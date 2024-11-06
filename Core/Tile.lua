local setDefaults = require ("Helpers.setDefaults")
local biomes = require ("Data.biomes")

local defaultTile = {
    -- ATTRIBUTES
    ground = nil, -- Holds a reference to the ground tile image
    biome = "default", -- The ID of a biome
    building = nil, -- Holds a reference to a buildable object

    -- METHODS
    setBuilding = function (self, buildObj)
        assert (buildObj ~= nil, "Buildable object not provided")

        self.building = buildObj
        buildObj:start ()
    end,
    removeBuilding = function (self)
        self.building:delete ()
        self.building = nil
    end,
}

local Tile = {} -- Tile class

function Tile:new (ground, biome)
    -- assert (ground ~= nil, "Ground graphic not provided")
    assert (biomes[biome] ~= nil, "Provided biome does not correspond to any defined biomes")

    local newObj = {
        ground = ground,
        biome = biome,
    }

    setDefaults (defaultTile, newObj)

    return newObj
end

return Tile