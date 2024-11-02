local copyTable = require ("Helpers.copyTable")

local buildableManager = {
    tracker = {},
}

local defaultClassDef = {
    -- Attributes
    id = nil,
    health = 100,
    frame = nil,

    -- Methods
    new = function () end,
    update = function () end,
    draw = function () end,
    interact = function () end,
    delete = function () end,
}

local function handleNilKey (self, key)
    return defaultClassDef[key]
end

function buildableManager:create (id, classDef)
    assert (self.tracker[id] == nil, "A class with the provided ID has already been defined")

    -- Copy class definition
    local newClassDef = copyTable (classDef)

    -- Set defaults
    setmetatable (newClassDef, {
        __index = handleNilKey,
    })

    -- Validate class
    assert (newClassDef.id ~= nil, "No ID was provided")
    assert (newClassDef.frame ~= nil, "No frame was provided")

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

return buildableManager