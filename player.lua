Player = {}

local spriteSheet

Player.x = 250
Player.y = 250
Player.velX = 0
Player.velY = 0
Player.width = 32
Player.height = 32
Player.speed = 340
Player.runSpeed = 1.5
Player.maxHealth = 100
Player.health = Player.maxHealth
Player.immunityFrames = 60
Player.immunityTimer = 0
Player.dead = false

function Player.load()

    SpriteSheets.Player = love.graphics.newImage("Graphics/player.png")
    SpriteSheets.Player:setFilter("nearest", "nearest")
end

function Player:update(dt)

    -- Deathcheck
    if Player.health <= 0 then
        Player:kill()
    end

    -- Immunity Frames
    if self.immunityTimer > 0 then
        self.immunityTimer = self.immunityTimer - 1
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
end

function Player:kill()
    self.dead = true
    self.health = 0
    -- Other death logic
end

function Player:collisionCheck(x, y, width, height)
    return
    self.x < x + width and
    self.x + self.width > x and
    self.y < y + height and
    self.y + self.height > y
end

-- Something hitting the player
function Player:hit(damage)
    if self.immunityTimer <= 0 then
        self.health = self.health - damage
        self.immunityTimer = self.immunityFrames
    end
end


function Player.draw() 
    if not Player.dead then
        if Player.immunityTimer%4 == 0 then
            love.graphics.draw(SpriteSheets.Player, Player.x, Player.y)
        end
    end
end

return Player