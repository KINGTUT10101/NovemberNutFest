local setDefaults = require ("Helpers.setDefaults")
local biomes = require ("Data.biomes")
local physics = require("physics")

local amount = 0

local defaultTile = {
    -- ATTRIBUTES
    ground = nil, -- Holds a reference to the ground tile image
    biome = "default", -- The ID of a biome
    building = nil, -- Holds a reference to a buildable object

    -- METHODS
    setBuilding = function (self, buildObj, x, y)
        assert (buildObj ~= nil, "Buildable object not provided")

        if self.building == nil then
            self.building = buildObj

            -- Physics body
            --[[
            buildObj.body = love.physics.newBody(physics.gameWorld, x, y, "static") -- TODO ** x and y don't exist so I can't multipy them by 32
            buildObj.shape = love.physics.newRectangleShape(32, 32) -- TILESIZE
            buildObj.fixture = love.physics.newFixture(buildObj.body, buildObj.shape)
            amount = amount + 1
            print("Buildable's Loaded:", amount)
            buildObj.fixture:setUserData(buildObj)
            buildObj.body:setActive(false)
            ]]--
            buildObj.lastUpdate = love.timer.getTime()
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
