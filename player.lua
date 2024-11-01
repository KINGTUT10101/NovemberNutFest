Player = {}

local spriteSheet

Player.x = 100
Player.y = 100
Player.velX = 0
Player.velY = 0
Player.speed = 5
Player.runSpeed = 1.5

function Player.load()

    spriteSheet = love.graphics.newImage("Graphics/player.png")
end

function Player.update(dt)

    if love.keyboard.isDown("w") then
        Player.velY = Player.velY - Player.speed
    end
    if love.keyboard.isDown("s") then
        Player.velY = Player.velY + Player.speed
    end
    if love.keyboard.isDown("a") then
        Player.velX = Player.velX - Player.speed
    end
    if love.keyboard.isDown("d") then
        Player.velX = Player.velX + Player.speed
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

    Player.velX = 0
    Player.velY = 0
end

function Player.draw() 

    love.graphics.draw(spriteSheet, Player.x, Player.y)
end

return Player