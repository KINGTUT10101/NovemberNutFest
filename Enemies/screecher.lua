local hoard = require("Managers.hoard")

local screechSound = love.audio.newSource("SoundEffects/screech.wav", "static")
screechSound:setVolume (0.5)

local loadAnimationFrames = require ("Helpers.loadAnimationFrames")
local processAnimation = require ("Helpers.processAnimation")

local spritesOpen = loadAnimationFrames ("Graphics/enemies/Screecher Open")
local spritesClosed = loadAnimationFrames ("Graphics/enemies/Screecher Closed")

local function genericInit(enemy, x, y)

    enemy.health = 50
    enemy.screeching = false
    enemy.screechTimer = require("util.timer")
    enemy.screechTimer.max = 1
    enemy.screechBeginTimer = require("util.timer")
    enemy.screechBeginTimer.max = 5

    enemy.width = 24
    enemy.height = 30

    -- This enemy has a different on move function then the default
    enemy.hasNewMove = true

    function enemy:load()
        enemy.body:setMass(3)

        self.frame = 1
        self.frameTimer = 0
    end

    function enemy:update(dt)

        if self.screeching then

            self.screechTimer.time = self.screechTimer.time + dt
            -- Only spawns enemies when the screeching timer ends
            if self.screechTimer.time >= self.screechTimer.max then
                hoard:HoardSpawn()
                self.screeching = false
                self.screechTimer.time = 0
                self.frame = 1
            end
        else
            self.screechBeginTimer.time = self.screechBeginTimer.time + dt
            if self.screechBeginTimer.time >= self.screechBeginTimer.max then
                self.screechBeginTimer.time = 0
                self.screeching = true
                screechSound:play()
                self.frame = 1
            end
        end

        local spriteTbl = spritesClosed
        local aniSpeed = 0.2
        if self.screeching == true then
            spriteTbl = spritesOpen
            aniSpeed = 0.1
        end
        processAnimation (dt, self, #spriteTbl, aniSpeed)
    end

    function enemy:move(threshold)
        if not self.stunned and not self.screeching then
            if math.abs(self.x - Player.x) > threshold then
                if self.x < Player.x then
                    self.velX = self.speed
                end
                if self.x > Player.x then
                    self.velX = -self.speed
                end
            end
            if math.abs(self.y - Player.y) > threshold then
                if self.y < Player.y then
                    self.velY = self.speed
                end
                if self.y > Player.y then
                    self.velY = -self.speed
                end
            end
        end
    end

    function enemy:kill()
        ItemManager:placeConsumable(ItemManager:newItem("cashew apple"), self.x, self.y)
    end

    function enemy:draw()
        local sprites = (self.screeching == true) and spritesOpen or spritesClosed
        local velX = self.body:getLinearVelocity()
        local scale, origin = 1, 0
        if velX < 0 then
            scale = -1
            origin = sprites[self.frame]:getWidth ()
        end
        love.graphics.draw(sprites[self.frame], self.x, self.y, nil, scale, 1, origin)
    end

    return enemy
end

return genericInit