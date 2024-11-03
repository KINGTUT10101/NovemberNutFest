local projectiles = {}
local projectileManager = {}

function projectileManager:draw()

    for i, projectile in pairs(projectiles) do
        love.graphics.draw(SpriteSheets.nuts, projectile.x, projectile.y)
    end
end

function projectileManager:update(dt)

    for i, projectile in pairs(projectiles) do
        -- Move the projectiles
        projectile.x = projectile.x + (projectile.velX*dt)
        projectile.y = projectile.y + (projectile.velY*dt)

        -- Delete the projectiles after their range comes up
        if projectile.range <= 0 then
            table.remove(projectiles, i)
        end
        projectile.range = projectile.range - 1
    end

    -- TODO ** Make the projectiels appear from the end of the gun
end

function projectileManager:add(startX, startY, endX, endY, projectile)
    
    -- Set the starting location
    projectile.x = startX
    projectile.y = startY
    -- Get the difference between the starting and ending point
    local dx = endX - startX
    local dy = (endY - startY)

    -- Get the distance and normalize the direction
    local distance = math.sqrt((dx*dx) + (dy*dy))

    -- Normalize the vector
    local directionX = dx / distance
    local directionY = dy / distance

    -- Scale the direction by the projectile speed
    projectile.velX = directionX * (projectile.projVelocity*200) -- Delta time slows it down
    projectile.velY = directionY * (projectile.projVelocity*200)

    -- The range needs to scale with the velocity
    projectile.range = (projectile.range * projectile.projVelocity)*5

    -- Add it into the on screen projectiles
    table.insert(projectiles, projectile)
end

return projectileManager