local copyTable = require ("Helpers.copyTable")
local average = require ("Helpers.average")
local clamp = require ("Libraries.lume").clamp
local mapToScale = require ("Helpers.mapToScale")
local setDefaults = require ("Helpers.setDefaults")

local baseNuts = require ("Data.baseNuts")

-- Defines the default nut object attributes
local defaultNut = {
    name = "Default",
    image = baseNuts.peanut,

    level = 1, -- The domestication level of the nut, which gives a stat boost for each level
    damage = 10, -- The base amount of damage the nut will deal to enemies
    projVelocity = 4, -- The velocity of the projectile
    projSize = 1, -- The scale of the projectile
    range = 10, -- The maximum range the projectile until it despawns
    knockback = 50, -- How far an enemy will be pushed when hit by the projectile
    -- invSize = 1, -- How many spaces the nut will use inside the player's inventory
    spread = 0, -- How wide the firing cone is for the projectile. Wider cones make it less accurate
    -- growthTime = 5, -- How long it takes the nut to grow when planted. In cross-breeding, the highest value of the pair will be used
    -- yield = 5, -- The base amount of nuts a fully-grown crop will produce
    -- variation = 1, -- How much the yield can vary in either direction
    specialEffects = {}, -- A list of tables, each with an effect and a probability
    class = "nut", -- What type of projectile
    type = "default",
    bgColor = {0.5, 0.5, 0.5, 1},
    ancestry = {}, -- Tracks the nut's genetic lineage
}
-- Defines min/max value pairs for each nut attribute
-- TODO: Adjust these values later when balancing the game
local nutAttributeRanges = {
    level = {1, 10},
    damage = {0, 100},
    projVelocity = {0, 25},
    projSize = {0.1, 10},
    range = {0, 25},
    knockback = {0, 10},
    -- invSize = {1, 10},
    spread = {0, 360},
    -- growthTime = {1, 10},
    -- yield = {1, 10},
    -- variation = {0, 5},
}

-- Adjectives for the attributes in the nut names
local nutAttributeMaxAdj = {
    level = "Max",
    damage = "Hurtful",
    projVelocity = "Swift",
    projSize = "Giga",
    range = "Lasting",
    knockback = "Recoiling",
    -- invSize = "na",
    spread = "Wide",
    -- growthTime = "na",
    -- yield = "na",
    -- variation = "na"
}

local function handleNilKey (self, key)
    return defaultNut[key]
end

local function clampNutAttributes (nutObj)
    for key, value in pairs (nutAttributeRanges) do
        nutObj[key] = clamp (nutObj[key], value[1], value[2])
    end
end

-- Generates a name and image for a nut depending on its genetics
local function generateDisplayData (nutObj)
    local type = "default"
    local name = ""
    local image = nil

    if nutObj == nil then
        return name, image
    end

    -- Gets the top 2 ancestors
    local topAncestors = {
        {
            id = "default",
            value = 0,
        },
        {
            id = "default",
            value = 0,
        },
    }
    for ancestorid, ancestorValue in pairs (nutObj.ancestry) do
        if ancestorValue > topAncestors[1].value then
            topAncestors[2].id = topAncestors[1].id
            topAncestors[2].value = topAncestors[1].value

            topAncestors[1].id = ancestorid
            topAncestors[1].value = ancestorValue

        elseif ancestorValue > topAncestors[2].value then
            topAncestors[2].id = ancestorid
            topAncestors[2].value = ancestorValue
        end
    end

    -- Gets the type for the nut
    type = topAncestors[1].id

    -- Gets the image for the nut
    if topAncestors[1].id ~= "default" then
        image = baseNuts[topAncestors[1].id].image
    else
        image = baseNuts.peanut.image
    end

    -- Generates the name of the nut

    -- Second half of name
    -- No ancestors
    if topAncestors[1].id == "default" then
        name = "Unknown Nut"

    -- One ancestor
    elseif topAncestors[2].id == "default" then
        name = baseNuts[topAncestors[1].id].name

    -- At least two ancestors
    else
        name = baseNuts[topAncestors[1].id].name .. "-" .. baseNuts[topAncestors[2].id].name
    end

    -- First half of name
    local topStats = {
        {
            id = "default",
            value = 0,
        },
        {
            id = "default",
            value = 0,
        }
    }
    for statid, statValue in pairs (nutAttributeRanges) do
        local scaledStatValue = mapToScale (nutObj[statid], statValue[1], statValue[2], 0, 1)

        if scaledStatValue > topStats[1].value then
            topStats[2].id = topStats[1].id
            topStats[2].value = topStats[1].value
    
            topStats[1].id = statid
            topStats[1].value = scaledStatValue
        elseif scaledStatValue > topStats[2].value then
            topStats[2].id = statid
            topStats[2].value = scaledStatValue
        end
    end

    -- No top stats
    if topStats[1].id == "default" then
        name = "Confusing " .. name

    -- One top stat
    elseif topStats[2].id == "default" then
        name = nutAttributeMaxAdj[topStats[1].id] .. " " .. name

    -- At least two top stats
    else
        name = nutAttributeMaxAdj[topStats[1].id] .. " " .. nutAttributeMaxAdj[topStats[2].id] .. " " .. name
    end

    -- Set nut stats
    nutObj.type = type
    nutObj.name = name
    nutObj.image = image
end

local Nut = {} -- Nut class used to create new nut objects

-- Providing no arguments will return a default nut object
-- Providing a nut object will create a copy of that object (good for cloning base nuts)
-- Providing two nut objects and the tile they're growing on will create a cross-bred nut
function Nut:new (...)
    local args = {...}
    local newNutObj

    -- Default nut
    if #args == 0 then
        newNutObj = {}

        -- Set defaults
        setDefaults (defaultNut, newNutObj)

    -- Copy the provided nut
    elseif #args == 1 then
        local nutObj = args[1]
        newNutObj = copyTable (nutObj)

        -- Set defaults
        setDefaults (defaultNut, newNutObj)

    -- Cross-breed the provided nuts
    elseif #args == 3 or #args == 2 then
        local nutObj1, nutObj2, tileObj = args[1], args[2], args[3]
        local nutObjCopy1, nutObjCopy2 = copyTable (nutObj1), copyTable (nutObj2)

        -- Set default values for provided nuts
        setDefaults (defaultNut, nutObjCopy1)
        setDefaults (defaultNut, nutObjCopy2)

        -- Clamp values
        clampNutAttributes (nutObjCopy1)
        clampNutAttributes (nutObjCopy2)

        newNutObj = {}
        -- Set defaults
        setDefaults (defaultNut, newNutObj)

        -- Calculate cross-bred attributes
        -- TODO: Adjust this to balance the game better. It currently just takes the average of the two values
        for key, rangePair in pairs (nutAttributeRanges) do
            newNutObj[key] = average (nutObjCopy1[key], nutObjCopy2[key])

            -- Apply random mutations
            -- It slightly favors positive mutations
            if key ~= "level" then
                local attributeRange = rangePair[2] - rangePair[1]
                local mutation = mapToScale (love.math.randomNormal (1, 0), -3, 3, -5, 7) / 100 * attributeRange
                newNutObj[key] = newNutObj[key] + mutation
            end
        end

        -- Mutate color values
        local colorIndex = math.random (1, 3)
        newNutObj.bgColor[colorIndex] = clamp (newNutObj.bgColor[colorIndex] + 0.1 * (math.random () < 0.5 and 1 or -1), 0, 1)

        -- Round level down to nearest integer and increment it
        newNutObj.level = math.floor (newNutObj.level) + 1

        -- Calculate ancestors
        for k, v in pairs (nutObjCopy1.ancestry) do
            newNutObj.ancestry[k] = v
        end
        for k, v in pairs (nutObjCopy2.ancestry) do
            if newNutObj.ancestry[k] == nil then
                newNutObj.ancestry[k] = v
            else
                newNutObj.ancestry[k] = newNutObj.ancestry[k] + v
            end
        end

        -- Cross breed nut effects
        -- Adds the effects to a new table for processing
        local parentEffects = {} -- Holds pairs of nut effects chances where each pair can have info from each parent

        -- Parent 1
        for index, pair in ipairs (nutObjCopy1.specialEffects) do
            local effectid, chance = pair[1], pair[2]

            parentEffects[effectid] = {
                [1] = chance,
                [2] = 0,
            }
        end
        -- Parent 2
        for index, pair in ipairs (nutObjCopy2.specialEffects) do
            local effectid, chance = pair[1], pair[2]
            
            if parentEffects[effectid] == nil then
                parentEffects[effectid] = {
                    [1] = 0,
                    [2] = chance,
                }
            else
                parentEffects[effectid][2] = chance
            end
        end

        -- Process effects genetics
        local index = 1
        for effectid, chancePair in pairs (parentEffects) do
            newNutObj.specialEffects[index] = {
                effectid,
                average (chancePair[1], chancePair[2]),
            }

            index = index + 1
        end
    else
        error ("Too many arguments provided to constructor")
    end

    -- Clamp nut attributes
    clampNutAttributes (newNutObj)

    -- Generate name and image for the nut
    generateDisplayData (newNutObj)

    return newNutObj
end

function Nut:load()
    SpriteSheets.nuts = love.graphics.newImage("Graphics/nuts.png") -- Each nut's 6x6
    SpriteSheets.Player:setFilter("nearest", "nearest")
end

return Nut