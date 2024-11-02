Player = {}

local spriteSheet

Player.x = 250
Player.y = 250
Player.velX = 0
Player.velY = 0
Player.width = 32*Scale
Player.height = 32*Scale
Player.speed = 340
Player.runSpeed = 1.5
Player.maxHealth = 100
Player.health = Player.maxHealth
Player.dead = false

function Player.load()

    SpriteSheets.Player = love.graphics.newImage("Graphics/player.png")
    SpriteSheets.Player:setFilter("nearest", "nearest")
end

function Player.update(dt)

    local dtSpeed = Player.speed*dt

    -- Control
    if love.keyboard.isDown("w") then
        Player.velY = Player.velY - dtSpeed
    end
    if love.keyboard.isDown("s") then
        Player.velY = Player.velY + dtSpeed
    end
    if love.keyboard.isDown("a") then
        Player.velX = Player.velX - dtSpeed
    end
    if love.keyboard.isDown("d") then
        Player.velX = Player.velX + dtSpeed
    end

    if love.keyboard.isDown("lshift") then
        Player.velX = Player.velX * Player.runSpeed
        Player.velY = Player.velY * Player.runSpeed
    end

    if Player.velX ~= 0 and Player.velY ~= 0 then
        Player.x = Player.x + (Player.velX/1.44)
        Player.y = Player.y + (Player.velY/1.44)
    elseif Player.velX ~= 0 or Player.velY ~= 0 then
        Player.x = Player.x + Player.velX
        Player.y = Player.y + Player.velY
    end

    -- Deathcheck
    if Player.health <= 0 then
        Player.kill()
    end

    -- Adding velocity to the player's position
    if Player.velX < 0 then
        Player.velX = Player.velX + Player.speed
    elseif Player.velX > 0 then
        Player.velX = Player.velX - Player.speed
    end
    if Player.velY < 0 then
        Player.velY = Player.velY + Player.speed
    elseif Player.velY > 0 then
        Player.velY = Player.velY - Player.speed
    end

    -- Clamp the speed to avoid shaking or sparatic movement
    if Player.velX >= -Player.speed/3 or Player.velX <= Player.speed/3 then
        Player.velX = 0
    end
    if Player.velY >= -Player.speed/3 or Player.velY <= Player.speed/3 then
        Player.velY = 0
    end
end

function Player.kill()
    Player.dead = true
    Player.health = 0
    -- Other death logic
end

function Player.collisionCheck(x, y, width, height)
    return
    Player.x < x + width and
    Player.x + Player.width > x and
    Player.y < y + height and
    Player.y + Player.height > y

end

function Player.draw() 
    if not Player.dead then
        love.graphics.draw(SpriteSheets.Player, Player.x, Player.y)
    end
end

return Player