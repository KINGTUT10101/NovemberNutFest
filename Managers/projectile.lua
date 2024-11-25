Projectiles = {}
local projectileManager = {}
local mapManager = require("Core.mapManager")
local collisionCheck = require("Helpers.collisionCheck")

projectileManager.projectileSize = 6

function projectileManager:load()

end

function projectileManager:draw()

    for _, p in pairs(Projectiles) do

        if p.type == "nut" then
            love.graphics.draw(SpriteSheets.nuts, p.x, p.y, p.rotation, 1, 1, self.projectileSize/2, self.projectileSize/2) -- all nuts are 6 high and wide
        elseif p.type == "throwable" then
            love.graphics.draw(p.sprite, p.x, p.y, p.rotation, 1, 1, p.width/2, p.height/2)
        end
    end
end

function projectileManager:update(dt)

    for n = #Projectiles, 1, -1 do

        local p = Projectiles[n]

        -- Move the projectiles
        p.x = p.x + (p.velX*dt)
        p.y = p.y + (p.velY*dt)
        p.rotation = p.rotation + 3

        -- Collisions with buildables
        if p.type == "nut" then
            -- Collisions with buildables
            local grid = mapManager.grid
            local tileSize = mapManager.tileSize
            local searchRadius = 2 -- Adjust this based on how many tiles around the player should be checked

            -- Calculate player's grid position
            local projectileTileX = math.floor(p.x / tileSize) + 1
            local projectileTileY = math.floor(p.y / tileSize) + 1

            -- Determine the bounds to search
            local startX = math.max(1, projectileTileX - searchRadius)
            local endX = math.min(mapManager.mapSize, projectileTileX + searchRadius)
            local startY = math.max(1, projectileTileY - searchRadius)
            local endY = math.min(mapManager.mapSize, projectileTileY + searchRadius)

            -- Iterate over the reduced grid range
            --[[
            for i = startX, endX do
                local firstPart = grid[i]

                for j = startY, endY do
                    local buildable = firstPart[j].building
                    --firstPart[j].setActive(true)

                    if buildable ~= nil then
                        local buildX, buildY = (i * tileSize) - tileSize, (j * tileSize) - tileSize

                        -- Collision
                        if collisionCheck(p.x, p.y, self.projectileSize, self.projectileSize, buildX, buildY, tileSize, tileSize) then
                            p.hitTile = true
                        end
                    end
                end
            end
            --]]
        end

        -- Nuts
        if p.type == "nut" then
            -- Delete the projectiles after their range comes up
            if p.timer >= p.range or p.hitTile then
                table.remove(Projectiles, n)
            else
                p.timer = p.timer + dt
            end
        -- Throwables
        elseif p.type == "throwable" then
            if math.abs(p.x - p.endX) <= 3 and math.abs(p.y - p.endY) <= 2 then
                p:onCollision(p.endX, p.endY)
                table.remove(Projectiles, n)
            end
        end
    end

end

function projectileManager:add(startX, startY, endX, endY, projectile)

    -- Initialize the rotation
    projectile.rotation = 0

    -- Has the projectile hit a tile
    projectile.hitTile = false

    -- Set the starting location
    projectile.x = startX
    projectile.y = startY
    -- Get the difference between the starting and ending point
    local dx = endX - startX
    local dy = endY - startY

    -- Get the distance and normalize the direction
    local distance = math.sqrt((dx*dx) + (dy*dy))

    -- Normalize the vector
    local directionX = dx / distance
    local directionY = dy / distance

    -- Scale the direction by the projectile speed
    projectile.velX = directionX * (projectile.projVelocity*65) -- Delta time slows it down
    projectile.velY = directionY * (projectile.projVelocity*65)

    if projectile.type == "nut" then

        -- The range needs to scale with the velocity
        projectile.range = (projectile.range/projectile.projVelocity)/1.85
        
        -- Will accumulate time with delta time
        projectile.timer = 0

        -- Things for special attributes
        projectile.pierces = 0
    elseif projectile.type == "throwable" then
        projectile.endX = endX
        projectile.endY = endY
    end

    -- Add it into the on screen projectiles
    table.insert(Projectiles, projectile)
end

return projectileManager