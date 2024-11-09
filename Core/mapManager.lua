local Tile = require ("Core.Tile")
local buildableManager = require ("Core.buildableManager")
local biomes = require ("Data.biomes")
local mapGenerator = require ("Core.mapGenerator")

local mapManager = {
    grid = nil, -- Stores all map tiles
    activeGrid = nil, -- Stores map tiles with buildings
    mapSize = 0,
    tileSize = 32,
    cam = {
        x = 0,
        y = 0,
        zoom = 1,
    }
}

-- Regenerates the map using the specified size, in tiles
function mapManager:resetMap (size)
    assert (size > 0 and size < math.huge, "Provided size is out of bounds")

    self.mapSize = size -- Set size
    self.grid = mapGenerator (size)
end

-- Updates the map and its tiles
-- The camera position basically defines where the player is in the map
function mapManager:update (dt, camX, camY, camZoom)
    self.cam.x = camX
    self.cam.y = camY
    self.cam.zoom = camZoom
end

-- Renders tiles that are within the player's view
function mapManager:draw()
    local startX, startY = self:screenToMap(0, 0)
    local endX, endY = self:screenToMap(GAMEWIDTH, GAMEHEIGHT)
    
    local grid = self.grid
    local camX, camY, zoom = self.cam.x, self.cam.y, self.cam.zoom
    local scaledTileSize = self.tileSize * zoom

    love.graphics.setColor(1, 1, 1, 1)
    for i = math.max(startX, 1), math.min(endX, self.mapSize) do
        local firstPart = grid[i]

        for j = math.max(startY, 1), math.min(endY, self.mapSize) do
            -- Remove the subtraction of startX/startY since screenToMap already accounts for camera position
            love.graphics.draw(
                firstPart[j].ground,
                (i - 1) * scaledTileSize - camX,
                (j - 1) * scaledTileSize - camY,
                nil,
                zoom
            )
        end
    end

    print (math.max(startX, 1), math.min(endX, self.mapSize))
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

function mapManager:screenToMap (screenX, screenY)
    local contMapX = (screenX + self.cam.x) / self.cam.zoom
    local mapX = math.floor (contMapX / self.tileSize) + 1
    -- local mapX = (contMapX - (contMapX%self.tileSize)) / self.tileSize + 1

    local contMapY = (screenY + self.cam.y) / self.cam.zoom
    local mapY = math.floor (contMapY / self.tileSize) + 1
    -- local mapY = (contMapY - (contMapY%self.tileSize)) / self.tileSize + 1

    return mapX, mapY
end

return mapManager