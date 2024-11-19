Projectiles = {}
local projectileManager = {}

function projectileManager:load()

end

function projectileManager:draw()

    for _, p in pairs(Projectiles) do

        if p.type == "nut" then
            love.graphics.draw(SpriteSheets.nuts, p.x, p.y, p.rotation, 1, 1, 3, 3) -- all nuts are 6 high and wide
        elseif p.type == "throwable" then
            love.graphics.draw(p.sprite, p.x, p.y, p.rotation, 1, 1, p.width/2, p.height/2)
        end
    end
end

function projectileManager:update(dt)

    for i = #Projectiles, 1, -1 do

        local p = Projectiles[i]

        -- Move the projectiles
        p.x = p.x + (p.velX*dt)
        p.y = p.y + (p.velY*dt)
        p.rotation = p.rotation + 3

        -- Nuts
        if p.type == "nut" then
            -- Delete the projectiles after their range comes up
            if p.timer >= p.range then
                table.remove(Projectiles, i)
            else
                p.timer = p.timer + dt
            end
        -- Throwables
        elseif p.type == "throwable" then
            if math.abs(p.x - p.endX) <= 3 and math.abs(p.y - p.endY) <= 2 then
                p:onCollision(p.endX, p.endY)
                table.remove(Projectiles, i)
            end
        end
    end

end

function projectileManager:add(startX, startY, endX, endY, projectile)
    
    -- Initialize the rotation
    projectile.rotation = 0

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