local Tile = require ("Core.Tile")
local buildableManager = require ("Core.buildableManager")
local biomes = require ("Data.biomes")
local mapGenerator = require ("Core.mapGenerator")

-- MAJOR TODO: Create and update active buildings

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
    self.cam.x = Player.relX
    self.cam.y = Player.relY
    self.cam.zoom = camZoom

    -- TODO: Update buildable tiles from the active grid
end

-- Renders tiles that are within the player's view
function mapManager:draw()
    local renderedBuildables = 0 -- TEMP

    local startX, startY = self:screenToMap(-10, -10)
    local endX, endY = self:screenToMap(GAMEWIDTH + 10, GAMEHEIGHT + 10)
    
    local grid = self.grid
    local camX, camY, zoom = self.cam.x, self.cam.y, self.cam.zoom
    local scaledTileSize = self.tileSize * zoom

    -- print ((math.min(endX, self.mapSize) - math.max(startX, 1)) * (math.min(endY, self.mapSize) - math.max(startY, 1)))
    print (startX, startY, endX, endY)

    love.graphics.setColor(1, 1, 1, 1)
    for i = math.max(startX, 1), math.min(endX, self.mapSize) do
        local firstPart = grid[i]

        for j = math.max(startY, 1), math.min(endY, self.mapSize) do
            local tile = firstPart[j]

            love.graphics.draw(
                tile.ground,
                (i - 1) * scaledTileSize - Player.relX,
                (j - 1) * scaledTileSize - Player.relY,
                nil,
                zoom
            )

            if tile.building ~= nil then
                love.graphics.draw (
                    tile.building.frame,
                    (i - 1) * scaledTileSize - Player.relX,
                    (j - 1) * scaledTileSize - Player.relY - tile.building.frame:getHeight () + 32,
                    nil,
                    zoom
                )

                renderedBuildables = renderedBuildables + 1
            end
        end
    end

    -- print (renderedBuildables)
end

-- Plants a nut object at the specified tile
-- Two nuts must be planted on the same location for a crop to start growing
function mapManager:plantNut (tileX, tileY, nutObj)
    assert (nutObj ~= nil, "Nut object not provided")

    local result = false
    
    if tileX >= 1 and tileX <= self.mapSize and tileY >= 1 and tileY <= self.mapSize then
        local tile = self.grid[tileX][tileY]

        -- TODO: Create nut plant if it doesn't currently exist here
        -- TODO: Finish code for setting the nuts for the plant
    end

    return result
end

-- Creates a buildable object at the specified tile if it is not already occupied
function mapManager:build (tileX, tileY, buildID)
    local result = false
    
    if tileX >= 1 and tileX <= self.mapSize and tileY >= 1 and tileY <= self.mapSize then
        local tile = self.grid[tileX][tileY]
        local newBuildable = buildableManager:generate (buildID)
        result = tile:setBuilding (newBuildable)
    end

    return result
end

-- Removes a buildable object at the specified tile if one exists
function mapManager:destroy (tileX, tileY)
    local result = false
    
    if tileX >= 1 and tileX <= self.mapSize and tileY >= 1 and tileY <= self.mapSize then
        local tile = self.grid[tileX][tileY]
        result = tile:removeBuilding ()
    end

    return result
end

-- Adds health to a buildable object at the specified tile if one exists
function mapManager:adjustHealth (tileX, tileY, health)
    local result = false
    
    if tileX >= 1 and tileX <= self.mapSize and tileY >= 1 and tileY <= self.mapSize then
        local tile = self.grid[tileX][tileY]
        local buildable = tile.building

        if buildable ~= nil then
            buildable.health = buildable.health + health

            if buildable.health <= 0 then
                tile:removeBuilding ()
            end

            result = true
        end
    end

    return result
end

function mapManager:screenToMap (screenX, screenY)
    local contMapX = (screenX + self.cam.x) / self.cam.zoom
    -- local mapX = math.floor (contMapX / self.tileSize) + 1
    local mapX = (contMapX - (contMapX%self.tileSize)) / self.tileSize + 1

    local contMapY = (screenY + self.cam.y) / self.cam.zoom
    -- local mapY = math.floor (contMapY / self.tileSize) + 1
    local mapY = (contMapY - (contMapY%self.tileSize)) / self.tileSize + 1

    return mapX, mapY
end

return mapManager