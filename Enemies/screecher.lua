local hoard = require("Managers.hoard")

local screechSound = love.audio.newSource("SoundEffects/screech.wav", "static")

local function genericInit(enemy, x, y)

    enemy.health = 50
    enemy.screeching = false
    enemy.screechTimer = require("util.timer")
    enemy.screechTimer.max = 1
    enemy.screechBeginTimer = require("util.timer")
    enemy.screechBeginTimer.max = 5

    -- This enemy has a different on move function then the default
    enemy.hasNewMove = true

    function enemy:load()
        self.sprite = love.graphics.newImage("Graphics/enemies/screecher.png")
        self.sprite:setFilter("nearest", "nearest")
        self.screechingSprite = love.graphics.newImage("Graphics/enemies/screecherScreaming.png")
        self.screechingSprite:setFilter("nearest", "nearest")

        enemy.body:setMass(3)
    end

    function enemy:update(dt)

        if self.screeching then

            self.screechTimer.time = self.screechTimer.time + dt
            -- Only spawns enemies when the screeching timer ends
            if self.screechTimer.time >= self.screechTimer.max then
                hoard:HoardSpawn()
                self.screeching = false
                self.screechTimer.time = 0
            end
        else
            self.screechBeginTimer.time = self.screechBeginTimer.time + dt
            if self.screechBeginTimer.time >= self.screechBeginTimer.max then
                self.screechBeginTimer.time = 0
                self.screeching = true
                screechSound:play()
            end
        end
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
        -- Add death animations ect.
        if self.screeching then
            love.graphics.draw(self.screechingSprite, self.x, self.y)
        else
            love.graphics.draw(self.sprite, self.x, self.y)
        end
    end

    return enemy
end

return genericInit