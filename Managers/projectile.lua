Projectiles = {}
local projectileManager = {}
local mapManager = require("Core.mapManager")
local collisionCheck = require("Helpers.collisionCheck")

projectileManager.projectileSize = 6

function projectileManager:load()

    self.peanutSprite = love.graphics.newImage("Graphics/Projectiles/peanut.png")
    self.coconutSprite = love.graphics.newImage("Graphics/Projectiles/coconut.png")
    self.macadamiaSprite = love.graphics.newImage("Graphics/Projectiles/macadamia.png")
    self.almondSprite = love.graphics.newImage("Graphics/Projectiles/almond.png")
    self.candleSprite = love.graphics.newImage("Graphics/Projectiles/candle.png")
    self.pineSprite = love.graphics.newImage("Graphics/Projectiles/pine.png")
    self.peanutSprite:setFilter("nearest", "nearest")
end

function projectileManager:draw()

    for _, p in pairs(Projectiles) do

        if p.class == "nut" then
            if p.type == "peanut" then
                love.graphics.draw(self.peanutSprite, p.x, p.y, p.rotation, 1, 1, self.projectileSize/2, self.projectileSize/2) -- all nuts are 6 high and wide
            elseif p.type == "coconut" then
                love.graphics.draw(self.coconutSprite, p.x, p.y, p.rotation, 1, 1, self.projectileSize/2, self.projectileSize/2)
            elseif p.type == "macadamia" then
                love.graphics.draw(self.macadamiaSprite, p.x, p.y, p.rotation, 1, 1, self.projectileSize/2, self.projectileSize/2)
            elseif p.type == "almond" then
                love.graphics.draw(self.almondSprite, p.x, p.y, p.rotation, 1, 1, self.projectileSize/2, self.projectileSize/2)
            elseif p.type == "candle" then
                love.graphics.draw(self.candleSprite, p.x, p.y, p.rotation, 1, 1, self.projectileSize/2, self.projectileSize/2)
            elseif p.type == "pine" then
                love.graphics.draw(self.pineSprite, p.x, p.y, p.rotation, 1, 1, self.projectileSize/2, self.projectileSize/2)
            else
                love.graphics.draw(SpriteSheets.nuts, p.x, p.y, p.rotation, 1, 1, self.projectileSize/2, self.projectileSize/2) -- all nuts are 6 high and wide
            end
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
        if p.class == "nut" then
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
        if p.class == "nut" then
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

    -- Get rid of those decimals
    projectile.damage = math.floor(projectile.damage + .5)

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

    if projectile.class == "nut" then

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