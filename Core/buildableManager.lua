local copyTable = require ("Helpers.copyTable")
local setDefaults = require ("Helpers.setDefaults")

local buildableManager = {
    tracker = {},
}

local defaultClassDef = {
    -- Attributes
    id = nil,
    name = "None",
    desc = "None",
    health = 100,
    frame = nil,
    lastUpdate = 0,
    addToMenu = false, -- If true, the buildable will be added to the buildables menu
    requiredMaterials = {}, -- Contains a list of resource ID/quantity pairs

    -- Methods
    start = function (self) end,
    update = function (self, dt, passedTime) end,
    interact = function (self, tileX, tileY) end,
    delete = function (self) end,
}

local function handleNilKey (self, key)
    return defaultClassDef[key]
end

function buildableManager:create (id, classDef)
    assert (self.tracker[id] == nil, "A class with the provided ID has already been defined")

    -- Copy class definition
    local newClassDef = copyTable (classDef)

    -- Set defaults
    setDefaults (defaultClassDef, newClassDef)
    newClassDef.id = id

    -- Validate class
    assert (newClassDef.frame ~= nil, "No frame was provided") -- TEMP: Uncomment later!!!

    self.tracker[id] = newClassDef

    return self:get (id)
end

function buildableManager:delete (id)
    assert (self.tracker[id] ~= nil, "Provided ID does not match any defined class")

    self.tracker[id] = nil
end

function buildableManager:get (id)
    assert (self.tracker[id] ~= nil, "Provided ID does not match any defined class")

    return self.tracker[id]
end

function buildableManager:generate (id)
    assert (self.tracker[id] ~= nil, "Provided ID does not match any defined class")

    local newObj = copyTable (self.tracker[id])

    return newObj
end

-- Register buildables
buildableManager:create ("bush", require ("Data.Buildables.Bush"))
buildableManager:create ("cactus", require ("Data.Buildables.Cactus"))

return buildableManager