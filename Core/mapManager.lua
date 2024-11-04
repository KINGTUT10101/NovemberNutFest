local Tile = require ("Core.Tile")
local buildableManager = require ("Core.buildableManager")
local biomes = require ("Data.biomes")

local mapManager = {
    grid = {}, -- Stores all map tiles
    activeGrid = {}, -- Stores map tiles with buildings
    size = 0,
    cam = {
        x = 0,
        y = 0,
        zoom = 1,
    }
}

-- Regenerates the map using the specified size, in tiles
function mapManager:resetMap (size)
    assert (size > 0 and size < math.huge, "Provided size is out of bounds")

    self.size = size -- Set size

    -- Generate tile objects
    local grid = self.grid
    for i = 1, size do
        local firstPart = {}
        grid[i] = firstPart

        for j = 1, size do
            firstPart[j] = {} -- TODO
        end
    end
end

-- Updates the map and its tiles
-- The camera position basically defines where the player is in the map
function mapManager:update (dt, playerX, playerY, zoom)

end

-- Renders tiles that are within the player's view
function mapManager:draw ()

end

-- Plants a nut object at the specified tile
-- Two nuts must be planted on the same location for a crop to start growing
function mapManager:plantNut (tilex, tiley, nutObj)

end

-- Creates a buildable object at the specified tile if it is not already occupied
function mapManager:build (tilex, tiley, buildID)

end

-- Removes a buildable object at the specified tile if one exists
function mapManager:destroy (tilex, tiley)

end

-- Adds health to a buildable object at the specified tile if one exists
function mapManager:adjustHealth (tilex, tiley)

end

return mapManager