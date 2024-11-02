local projectiles = {}
local projectileManager = {}

function projectileManager:draw()

    for i, projectile in pairs(projectiles) do
        love.graphics.draw(SpriteSheets.nuts, projectile.x, projectile.y)
    end
end

function projectileManager:update()

    for i, projectile in pairs(projectiles) do
        projectile.x = projectile.x + projectile.velX
        projectile.y = projectile.y + projectile.velY
        print(projectile.velX)
    end

    -- TODO ** Delete the projectiles after their range comes up
    -- TODO ** Make the projectiels appear from the end of the gun
end

function projectileManager:add(startX, startY, endX, endY, projectile)
    
    -- Set the starting location
    projectile.x = startX
    projectile.y = startY
    -- Get the difference between the starting and endign point
    local dx = endX - startX
    local dy = endY - endX

    -- Get the distance and normalize the direction
    local distance = math.sqrt(dx * dx + dy * dy)

    -- Normalize the vector
    local directionX = dx / distance
    local directionY = dy / distance

    -- Scale the direction by the projectile speed
    projectile.velX = directionX * projectile.projVelocity
    projectile.velY = directionY * projectile.projVelocity

    -- Add it into the on screen projectiles
    table.insert(projectiles, projectile)
end

return projectileManager