local inventoryHandler = require("Core.inventoryHandler")
local mapManager = require("Core.mapManager")
local collisionCheck = require("Helpers.collisionCheck")
local push = require("Libraries.push")
Player = {}

local spriteSheet

Player.x = 0
Player.y = 0
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


-- Sound Effedts
local hurtSound = love.audio.newSource("SoundEffects/player_hurt.wav", "static")

function Player.load()

    SpriteSheets.Player = love.graphics.newImage("Graphics/player.png")
    SpriteSheets.Player:setFilter("nearest", "nearest")

end

Builds = {}

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
                table.insert(Builds, {x = buildX, y = buildY})

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
        self.x = self.x + (self.velX/1.44)
        self.y = self.y + (self.velY/1.44)
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
            love.graphics.draw(SpriteSheets.Player, self.x, self.y)
        else
            love.graphics.setColor(1, 1, 1, 0.85)
            love.graphics.draw(SpriteSheets.Player, self.x, self.y)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end

    -- TEST **
    for _, b in ipairs(Builds) do
        --print("Player X: " .. self.x, "Player Y:" .. self.y)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", b.x, b.y, mapManager.tileSize, mapManager.tileSize)
        love.graphics.setColor(1, 1, 1)
    end
end

return Player