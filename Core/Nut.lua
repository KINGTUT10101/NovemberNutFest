local copyTable = require ("Helpers.copyTable")
local average = require ("Helpers.average")
local clamp = require ("Helpers.clamp")
local mapToScale = require ("Helpers.mapToScale")
local setDefaults = require ("Helpers.setDefaults")

-- Defines the default nut object attributes
local defaultNut = {
    level = 1, -- The domestication level of the nut, which affects 
    damage = 10, -- The base amount of damage the nut will deal to enemies
    projVelocity = 4, -- The velocity of the projectile
    projScale = 1, -- The scale of the projectile
    range = 10, -- The maximum range the projectile until it despawns
    knockback = 50, -- How far an enemy will be pushed when hit by the projectile
    invSize = 1, -- How many spaces the nut will use inside the player's inventory
    spread = 0, -- How wide the firing cone is for the projectile. Wider cones make it less accurate
    growthTime = 5, -- How long it takes the nut to grow when planted. In cross-breeding, the highest value of the pair will be used
    yield = 5, -- The base amount of nuts a fully-grown crop will produce
    variation = 1, -- How much the yield can vary in either direction
    specialEffects = {}, -- A list of tables, each with an effect and a probability
    type = "nut" -- What type of projectile
}
-- Defines min/max value pairs for each nut attribute
-- TODO: Adjust these values later when balancing the game
local nutAttributeRanges = {
    level = {1, 10},
    damage = {0, 100},
    projVelocity = {0, 25},
    projScale = {0.1, 10},
    range = {0, 25},
    knockback = {0, 10},
    invSize = {1, 10},
    spread = {0, 360},
    growthTime = {1, 10},
    yield = {1, 10},
    variation = {0, 5},
}

local function handleNilKey (self, key)
    return defaultNut[key]
end

local function clampNutAttributes (nutObj)
    for key, value in pairs (nutAttributeRanges) do
        if nutObj[key] < value[1] or nutObj[key] > value[2] then
            -- print ("Warning: Provided nut attribute " .. key .. " was out of range and has been clamped")
            -- print (key, nutObj[key])
    
            nutObj[key] = clamp (nutObj[key], value[1], value[2])
        end
    end
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
    elseif #args == 3 then
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
            local attributeRange = rangePair[2] - rangePair[1]
            local mutation = mapToScale (love.math.randomNormal (1, 0), -3, 3, -5, 7) / 100 * attributeRange
            newNutObj[key] = newNutObj[key] + mutation
            print (key, mutation, newNutObj[key])
        end
        print ()

        -- Round level down to nearest integer and increments it
        newNutObj.level = math.min (newNutObj.level) + 1
    else
        error ("Too many arguments provided to constructor")
    end

    -- Clamp nut attributes
    clampNutAttributes (newNutObj)

    return newNutObj
end

function Nut:load()
    SpriteSheets.nuts = love.graphics.newImage("Graphics/nuts.png") -- Each nut's 6x6
    SpriteSheets.Player:setFilter("nearest", "nearest")
end

return Nut