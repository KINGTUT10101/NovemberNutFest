local Tile = require ("Core.Tile")
local buildableManager = require ("Core.buildableManager")
local biomes = require ("Data.biomes")
local mapGenerator = require ("Core.mapGenerator")
local camera = require("Libraries.hump.camera")

-- MAJOR TODO: Create and update active buildings

local mapManager = {
    grid = {}, -- Stores all map tiles
    activeGrid = {}, -- Stores map tiles with buildings
    mapSize = 0,
    tileSize = 32,
}

-- Regenerates the map using the specified size, in tiles
function mapManager:resetMap (size)
    assert (size > 0 and size < math.huge, "Provided size is out of bounds")

    self.mapSize = size -- Set size
    self.grid = mapGenerator (size)
end

-- Updates the map and its tiles
-- The camera position basically defines where the player is in the map
function mapManager:update (dt)

    -- Updates buildables within the player's view
    local updateStartTime = love.timer.getTime()
    local startX, startY = self:screenToMap(-10, -10)
    local endX, endY = self:screenToMap(GAMEWIDTH + 10, GAMEHEIGHT + 10)
    local grid = self.grid

    for i = math.max(startX, 1), math.min(endX, self.mapSize) do
        local firstPart = grid[i]
    
        for j = math.max(startY, 1), math.min(endY, self.mapSize) do
            local buildable = firstPart[j].building

            if buildable ~= nil then
                buildable:update (dt, updateStartTime - buildable.lastUpdate)
                buildable.lastUpdate = updateStartTime
            end
        end
    end
end

-- Renders tiles that are within the player's view
function mapManager:draw()
    local startX, startY = self:screenToMap(-10, -10)
    local endX, endY = self:screenToMap(GAMEWIDTH + 10, GAMEHEIGHT + 10)

    local grid = self.grid

    love.graphics.setColor(1, 1, 1, 1)
    for i = math.max(startX, 1), math.min(endX, self.mapSize) do
        local firstPart = grid[i]

        for j = math.max(startY, 1), math.min(endY, self.mapSize) do
            local tile = firstPart[j]

            love.graphics.draw(
                tile.ground,
                (i - 1) * self.tileSize,
                (j - 1) * self.tileSize,
                nil
            )

            if tile.building ~= nil then
                love.graphics.draw (
                    tile.building.frame,
                    (i - 1) * self.tileSize,
                    (j - 1) * self.tileSize - (tile.building.frame:getHeight()/4),
                    nil
                )
            end
        end
    end
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

function mapManager:screenToMap(screenX, screenY)

    -- Convert screen coordinates to world coordinates (taking zoom into account)
    local worldX = (screenX + camera.x)/camera.scale
    local worldY = (screenY + camera.y)/camera.scale

    -- Convert world coordinates to map coordinates
    local mapX = math.floor(worldX / self.tileSize) + 1
    local mapY = math.floor(worldY / self.tileSize) + 1

    return mapX, mapY
end

function mapManager:interact (tileX, tileY)
    local result = false
    
    if tileX >= 1 and tileX <= self.mapSize and tileY >= 1 and tileY <= self.mapSize then
        local tile = self.grid[tileX][tileY]
        local buildable = tile.building
    
        if buildable ~= nil then
            buildable:interact ()
    
            result = true
        end
    end
    
    return result
end

return mapManager