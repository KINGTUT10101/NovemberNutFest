local inventoryHandler = require("Core.inventoryHandler")
Player = {}

local spriteSheet

Player.x = 250
Player.y = 250
Player.velX = 0
Player.velY = 0
Player.width = 32
Player.height = 32
Player.speed = 340
Player.runSpeed = 1.5 -- Isn't the actual run speed it's just a multiplier
Player.maxHealth = 100
Player.health = Player.maxHealth
Player.maxImmunityTimer = 0.8 -- The max amount of time in the immunity timer
Player.immunityTimer = Player.maxImmunityTimer -- The amount of time in the immunity timer
--Player.flashTimer = 0 -- The timer that dictates what flash your on based on framerate
Player.dead = false

-- Where the player is based on the camera's position
Player.camX = (ScaledGameWidth/2)-(Player.width/2)
Player.camY = (ScaledGameHeight/2)-(Player.height/2)

-- Position with the center of the screen offset
Player.relX = Player.x + Player.camX
Player.relY = Player.y + Player.camY

-- Sound Effedts
local hurtSound = love.audio.newSource("SoundEffects/player_hurt.wav", "static")

function Player.load()

    SpriteSheets.Player = love.graphics.newImage("Graphics/player.png")
    SpriteSheets.Player:setFilter("nearest", "nearest")
end

function Player:update(dt)

    -- Change active inventory section
    if love.keyboard.isDown("1") then
        inventoryHandler.activeSection = 1
    elseif love.keyboard.isDown("2") then
        inventoryHandler.activeSection = 2
    elseif love.keyboard.isDown("3") then
        inventoryHandler.activeSection = 3
    elseif love.keyboard.isDown("4") then
        inventoryHandler.activeSection = 4
    elseif love.keyboard.isDown("5") then
        inventoryHandler.activeSection = 5
    elseif love.keyboard.isDown("6") then
        inventoryHandler.activeSection = 6
    elseif love.keyboard.isDown("7") then
        inventoryHandler.activeSection = 7
    elseif love.keyboard.isDown("8") then
        inventoryHandler.activeSection = 8
    elseif love.keyboard.isDown("9") then
        inventoryHandler.activeSection = 9
    end
        
    

    -- Deathcheck
    if Player.health <= 0 then
        Player:kill()
    end

    -- Immunity Frames
    if self.immunityTimer < self.maxImmunityTimer then
        self.immunityTimer = self.immunityTimer + dt
    end

    local dtSpeed = self.speed*dt

    -- Control
    if love.keyboard.isDown("w") then
        self.velY = self.velY - dtSpeed
    end
    if love.keyboard.isDown("s") then
        self.velY = self.velY + dtSpeed
    end
    if love.keyboard.isDown("a") then
        self.velX = self.velX - dtSpeed
    end
    if love.keyboard.isDown("d") then
        self.velX = self.velX + dtSpeed
    end

    if love.keyboard.isDown("lshift") then
        self.velX = self.velX * self.runSpeed
        self.velY = self.velY * self.runSpeed
    end

    -- Adding velocity to the player's position
    if self.velX ~= 0 and self.velY ~= 0 then
        self.x = self.x + (self.velX/1.44)
        self.y = self.y + (self.velY/1.44)
    elseif self.velX ~= 0 or self.velY ~= 0 then
        self.x = self.x + self.velX
        self.y = self.y + self.velY
    end


    -- Taking off velocity based on the playsrs speed
    if self.velX < 0 then
        self.velX = self.velX + self.speed
    elseif self.velX > 0 then
        self.velX = self.velX - self.speed
    end
    if self.velY < 0 then
        self.velY = self.velY + self.speed
    elseif self.velY > 0 then
        self.velY = self.velY - self.speed
    end

    -- Clamp the speed to avoid shaking or sparatic movement
    if self.velX >= -self.speed/3 or self.velX <= self.speed/3 then
        self.velX = 0
    end
    if self.velY >= -self.speed/3 or self.velY <= self.speed/3 then
        self.velY = 0
    end

    self.relX = self.x + ((638/2)-(Player.width/2))
    self.relY = self.y + ((358/2)-(Player.height/2))
end

function Player:kill()
    self.dead = true
    self.health = 0
    -- Other death logic
end

function Player:collisionCheck(x, y, width, height)
    return
    self.relX < x + width and
    self.relX + self.width > x and
    self.relY < y + height and
    self.relY + self.height > y
end

-- Something hitting the player
function Player:hit(damage)
    if self.immunityTimer >= self.maxImmunityTimer then
        hurtSound:play()
        self.health = self.health - damage
        Player:giveImmunity()
    end
end

function Player:giveImmunity()
    self.immunityTimer = 0
end


function Player:draw() 
    if not self.dead then
        if self.immunityTimer >= self.maxImmunityTimer then
            love.graphics.draw(SpriteSheets.Player, self.camX, self.camY)
        else
            love.graphics.setColor(1, 1, 1, 0.85)
            love.graphics.draw(SpriteSheets.Player, self.camX, self.camY)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end
end

return Player