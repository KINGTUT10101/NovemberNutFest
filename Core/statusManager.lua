local copyTable = require ("Helpers.copyTable")

local statusManager = {
    tracker = {},
}

local defaultClassDef = {
    -- Attributes
    id = nil,

    -- Methods
    update = function () end,
    draw = function () end,
}

local function handleNilKey (self, key)
    return defaultClassDef[key]
end

function statusManager:create (id, classDef)
    assert (self.tracker[id] == nil, "A class with the provided ID has already been defined")

    -- Copy class definition
    local newClassDef = copyTable (classDef)

    -- Set defaults
    setmetatable (newClassDef, {
        __index = handleNilKey,
    })

    -- Validate class
    assert (newClassDef.id ~= nil, "No ID was provided")

    self.tracker[id] = newClassDef

    return self:get (id)
end

function statusManager:delete (id)
    assert (self.tracker[id] ~= nil, "Provided ID does not match any defined class")

    self.tracker[id] = nil
end

function statusManager:get (id)
    assert (self.tracker[id] ~= nil, "Provided ID does not match any defined class")

    return self.tracker[id]
end

return statusManager