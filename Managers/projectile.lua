Projectiles = {}
local projectileManager = {}

function projectileManager:load()
    SpriteSheets.nutOil = love.graphics.newImage("Graphics/nutOil.png")
    SpriteSheets.nutOil:setFilter("nearest", "nearest")
end

function projectileManager:draw()

    for _, projectile in pairs(Projectiles) do

        if projectile.type == "nut" then
            love.graphics.draw(SpriteSheets.nuts, projectile.x, projectile.y, projectile.rotation, 1, 1, 3, 3) -- all nuts are 6 high and wide
        elseif projectile.type == "throwable" then
            if projectile.object == "nut oil" then
                love.graphics.draw(SpriteSheets.nutOil, projectile.x, projectile.y, projectile.rotation, 1, 1, projectile.width/2, projectile.height/2)
            elseif projectile.object == "nut butter" then
                
            end
        end
    end
end

function projectileManager:update(dt)

    for i, projectile in pairs(Projectiles) do
        -- Move the projectiles
        projectile.x = projectile.x + (projectile.velX*dt)
        projectile.y = projectile.y + (projectile.velY*dt)
        projectile.rotation = projectile.rotation + 3

        -- Nuts
        if projectile.type == "nut" then
            -- Delete the projectiles after their range comes up
            if projectile.timer >= projectile.range then
                Projectiles[i] = nil
            else
                projectile.timer = projectile.timer + dt
            end
        -- Throwables
        elseif projectile.type == "throwable" then
            if math.abs(projectile.x - projectile.endX) <= 3 and math.abs(projectile.y - projectile.endY) <= 2 then
                print("collision")
                projectile:onCollision(projectile.endX, projectile.endY)
                Projectiles[i] = nil
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
        projectile.range = (distance/projectile.projVelocity)/80
        
        -- Will accumulate time with delta time
        projectile.timer = 0
    elseif projectile.type == "throwable" then
        projectile.endX = endX
        projectile.endY = endY
    end

    -- Add it into the on screen projectiles
    table.insert(Projectiles, projectile)
end

return projectileManager