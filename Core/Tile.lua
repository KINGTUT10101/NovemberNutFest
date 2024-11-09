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

        if self.building == nil then
            self.building = buildObj
            buildObj:start ()

            return true
        else
            return false
        end
    end,
    removeBuilding = function (self)
        if self.building ~= nil then
            self.building:delete ()
            self.building = nil

            return true
        else
            return false
        end
    end,
}

local Tile = {} -- Tile class

function Tile:new (ground, biome)
    assert (ground ~= nil, "Ground graphic not provided")
    assert (biomes[biome] ~= nil, "Provided biome does not correspond to any defined biomes")

    local newObj = {
        ground = ground,
        biome = biome,
    }

    setDefaults (defaultTile, newObj)

    return newObj
end

return Tile