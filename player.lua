local inventoryHandler = require("Core.newInventoryHandler")
local mapManager = require("Core.mapManager")
local collisionCheck = require("Helpers.collisionCheck")
local push = require("Libraries.push")
local physics = require("physics")
local camera = require("Libraries.hump.camera")
local hoard  = require("Managers.hoard")
Player = {}

local spriteSheet

Player.x = 4*mapManager.tileSize
Player.y = 3*mapManager.tileSize
Player.velX = 0
Player.velY = 0
Player.width = 32
Player.height = 32
Player.speed = 5000
Player.runSpeed = 1.5 -- Isn't the actual run speed it's just a multiplier
Player.maxHealth = 100
Player.health = Player.maxHealth
Player.maxImmunityTimer = 0.8                  -- The max amount of time in the immunity timer
Player.immunityTimer = Player.maxImmunityTimer -- The amount of time in the immunity timer
Player.class = "player"
Player.dead = false
Player.god = false -- God mode

-- Powerups
-- speed
Player.speedUp = false
Player.speedUpMaxTimer = 5
Player.speedUpTimer = Player.speedUpMaxTimer

-- Gives more ammo the more it increases, is reset after the player gets hit
Player.nutTimer = 0
Player.nutAddTimer = 0

-- Sound Effedts
local hurtSound = love.audio.newSource("SoundEffects/player_hurt.wav", "static")

function Player.load()
    SpriteSheets.Player = love.graphics.newImage("Graphics/player.png")
    SpriteSheets.Player:setFilter("nearest", "nearest")

    -- Add the player to the physics world
    Player.body = love.physics.newBody(physics.gameWorld, Player.x, Player.y, "dynamic")
    Player.shape = love.physics.newRectangleShape(Player.width, Player.height)
    Player.fixture = love.physics.newFixture(Player.body, Player.shape)
    Player.body:setMass(1)
    Player.fixture:setUserData(Player)
    Player.body:setLinearDamping(10)
end

function Player:update(dt)

    self.x, self.y = self.body:getPosition()

    self.camX = select(1, camera:cameraCoords(Player.x, Player.y, nil, nil, GAMEWIDTH, GAMEHEIGHT))
    self.camY = select(2, camera:cameraCoords(Player.x, Player.y, nil, nil, GAMEWIDTH, GAMEHEIGHT))

    -- Powerups
    -- speed up
    if self.speedUpTimer < self.speedUpMaxTimer then
        self.speedUpTimer = self.speedUpTimer + dt
        self.speedUp = true
    else
        self.speedUp = false
    end


    -- Add ammo based on the amount of time gone without being hit
    if hoard.inProgress then
        -- Add onto the nut regeneration timer
        self.nutTimer = self.nutTimer + dt
        self.nutAddTimer = self.nutAddTimer + dt

        -- Add more ammo depending on where the timer is
        if self.nutTimer < 3 then
            if self.nutAddTimer > .8 then
                inventoryHandler:addAmmoCount(1)
                self.nutAddTimer = 0
            end
        elseif self.nutTimer < 8 then
            if self.nutAddTimer > .6 then
                inventoryHandler:addAmmoCount(1)
                self.nutAddTimer = 0
            end
        elseif self.nutTimer < 15 then
            if self.nutAddTimer > .4 then
                inventoryHandler:addAmmoCount(1)
                self.nutAddTimer = 0
            end
        elseif self.nutTimer < 30 then
            if self.nutAddTimer > .2 then
                inventoryHandler:addAmmoCount(1)
                self.nutAddTimer = 0
            end
        end
    else
        self.nutAddTimer = 0
        self.nutTimer = 0
    end

    -- Deathcheck
    if Player.health <= 0 then
        Player:kill()
    end

    -- Immunity Frames
    if self.immunityTimer < self.maxImmunityTimer then
        self.immunityTimer = self.immunityTimer + dt
    end

    self.velX, self.velY = 0, 0

    -- Control
    if love.keyboard.isDown("w") then
        self.velY = self.velY - self.speed
    end
    if love.keyboard.isDown("s") then
        self.velY = self.velY + self.speed
    end
    if love.keyboard.isDown("a") then
        self.velX = self.velX - self.speed
    end
    if love.keyboard.isDown("d") then
        self.velX = self.velX + self.speed
    end

    if self.speedUp then
        self.velX = self.velX * 1.4
        self.velY = self.velY * 1.4
    end

    if math.abs(self.velX) > 0 and math.abs(self.velY) > 0 then
        self.velX = self.velX / 1.44
        self.velY = self.velY / 1.44
    end

    self.body:applyForce(self.velX, self.velY)
    self.velX, self.velY = 0, 0


    -- Collisions with buildables
    -- Updates buildables within the player's view
    local grid = mapManager.grid
    local tileSize = mapManager.tileSize
    local searchRadius = 2 -- Adjust this based on how many tiles around the player should be checked

    -- Calculate player's grid position
    local playerTileX = math.floor(self.x / tileSize) + 1
    local playerTileY = math.floor(self.y / tileSize) + 1

    -- Determine the bounds to search
    local startX = math.max(1, playerTileX - searchRadius)
    local endX = math.min(mapManager.mapSize, playerTileX + searchRadius)
    local startY = math.max(1, playerTileY - searchRadius)
    local endY = math.min(mapManager.mapSize, playerTileY + searchRadius)

    -- Iterate over the reduced grid range
    for i = startX, endX do
        local firstPart = grid[i]

        for j = startY, endY do
            local buildable = firstPart[j].building

            if buildable ~= nil then
                local buildX, buildY = (i * tileSize) - tileSize, (j * tileSize) - tileSize

                local epsilon = 3 -- Small value to allow slight overlap

                -- Horizontal collision
                if collisionCheck(self.x + self.velX, self.y, self.width - epsilon, self.height - epsilon, buildX, buildY, tileSize, tileSize) then
                    if self.velX > 0 then
                        self.x = buildX - self.width
                    elseif self.velX < 0 then
                        self.x = buildX + tileSize
                    end
                    self.velX = 0
                end

                -- Vertical collision
                if collisionCheck(self.x, self.y + self.velY, self.width - epsilon, self.height - epsilon, buildX, buildY, tileSize, tileSize) then
                    if self.velY > 0 then
                        self.y = buildY - self.height
                    elseif self.velY < 0 then
                        self.y = buildY + tileSize
                    end
                    self.velY = 0
                end
            end
        end
    end

    -- Adding velocity to the player's position
    if self.velX ~= 0 and self.velY ~= 0 then
        self.x = self.x + (self.velX / 1.44)
        self.y = self.y + (self.velY / 1.44)
    elseif self.velX ~= 0 or self.velY ~= 0 then
        self.x = self.x + self.velX
        self.y = self.y + self.velY
    end


    -- Taking off velocity based on the player's speed
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
    if self.velX >= -self.speed / 3 or self.velX <= self.speed / 3 then
        self.velX = 0
    end
    if self.velY >= -self.speed / 3 or self.velY <= self.speed / 3 then
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
    if self.immunityTimer >= self.maxImmunityTimer and not self.god then
        hurtSound:play()
        self.health = self.health - damage
        Player:giveImmunity()
    end

    self.nutAddTimer = 0
    self.nutTimer = 0
end

function Player:giveImmunity()
    self.immunityTimer = 0
end

function Player:draw()
    if not self.dead then
        if self.immunityTimer >= self.maxImmunityTimer then
            love.graphics.draw(SpriteSheets.Player, self.x, self.y)
        else
            love.graphics.setColor(1, 1, 1, 0.85)
            love.graphics.draw(SpriteSheets.Player, self.x, self.y)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end
end

return Player
