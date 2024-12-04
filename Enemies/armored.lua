local loadAnimationFrames = require ("Helpers.loadAnimationFrames")
local processAnimation = require ("Helpers.processAnimation")

local spritesNormal = loadAnimationFrames ("Graphics/enemies/Armored Normal")
local spritesMad = loadAnimationFrames ("Graphics/enemies/Armored Mad")
local spritesSad = loadAnimationFrames ("Graphics/enemies/Armored Sad")

local function genericInit(enemy, x, y)
    enemy.health = 50
    enemy.amHealth = 200 -- armor health
    enemy.width = 19
    enemy.height = 31
    enemy.damage = 15
    enemy.maxAmHealth = enemy.amHealth
    enemy.origSpeed = enemy.speed
    enemy.hasArmor = true
    enemy.angry = false  -- if true the enemy will run after the player
    enemy.sad = false    -- if true the enemy will run away from the player and regenerate it's shell

    -- The shell will regenerate if the enemy gets sad after it's shell's destroyed
    enemy.shellTimer = 0
    enemy.shellMaxTimer = 7

    -- This enemy has a different on hit function then the default
    enemy.hasNewOnHit = true

    -- This enemy has a different on move function then the default
    enemy.hasNewMove = true

    function enemy:load()
        self.madSprite = love.graphics.newImage("Graphics/enemies/armoredMad.png")
        self.madSprite:setFilter("nearest", "nearest")
        self.armoredSprite = love.graphics.newImage("Graphics/enemies/armored.png")
        self.armoredSprite:setFilter("nearest", "nearest")
        self.sadSprite = love.graphics.newImage("Graphics/enemies/armoredSad.png")
        self.sadSprite:setFilter("nearest", "nearest")

        enemy.body:setMass(3)

        self.frame = 1
        self.frameTimer = 0
    end

    function enemy:update(dt)

        if self.sad then
            self.shellTimer = self.shellTimer + dt
        end

        if self.shellTimer >= self.shellMaxTimer then
            self.sad = false
            self.angry = false
            self.hasArmor = true
            self.amHealth = self.maxAmHealth
            self.shellTimer = 0
            self.speed = self.origSpeed
            enemy.body:setMass(3)
        end

        local spriteTbl = spritesNormal
        local aniSpeed = 0.2
        if self.angry == true then
            spriteTbl = spritesMad
            aniSpeed = 0.1
        elseif self.sad == true then
            spriteTbl = spritesSad
            aniSpeed = 0.15
        end
        processAnimation (dt, self, #spriteTbl, aniSpeed)
    end

    function enemy:newOnHit(damage)
        if enemy.hasArmor then
            enemy.amHealth = enemy.amHealth - damage
        else
            enemy.health = enemy.health - damage
        end

        -- Armor broke off
        if enemy.amHealth <= 0 and self.hasArmor then
            enemy.hasArmor = false
            self.frame = 1

            local choice = math.random(1, 2)
            if choice == 1 then
                self.angry = true
                self.body:setMass(1)
                self.speed = self.speed * 1.5
            else
                self.sad = true
                self.body:setMass(1)
                self.speed = self.speed / 2
            end
        end
    end

    function enemy:move(threshold)
        if not self.stunned then
            if self.sad then
                if math.abs(self.x - Player.x) > threshold then
                    if self.x < Player.x then
                        self.velX = -self.speed
                    end
                    if self.x > Player.x then
                        self.velX = self.speed
                    end
                end
                if math.abs(self.y - Player.y) > threshold then
                    if self.y < Player.y then
                        self.velY = -self.speed
                    end
                    if self.y > Player.y then
                        self.velY = self.speed
                    end
                end
            else
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
    end

    function enemy:kill()
        ItemManager:placeConsumable(ItemManager:newItem("cashew apple"), self.x, self.y)
    end

    function enemy:draw()
        -- Add death animations ect.
        if self.hasArmor then
            love.graphics.draw(spritesNormal[self.frame], self.x, self.y)
        elseif self.angry then
            love.graphics.draw(spritesMad[self.frame], self.x, self.y)
        elseif self.sad then
            love.graphics.draw(spritesSad[self.frame], self.x, self.y)
        end
    end

    return enemy
end

return genericInit
