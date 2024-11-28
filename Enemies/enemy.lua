local hitmarkerManager = require "Managers.hitmarker"
local contains = require "Helpers.contains"
local physics = require "physics"
local mapManager = require "Core.mapManager"
local collisionCheck = require "Helpers.collisionCheck"
local camera = require "Libraries.hump.camera"

Enemies = {} -- list of all enemies in the game
EnemyManager = {}

-- Stats
EnemyManager.totalKills = 0
EnemyManager.enemyTypes = 5

-- Sound Effects
local enemyHitSound = love.audio.newSource("SoundEffects/enemy_hit.wav", "static")

function EnemyManager:spawnEnemy(x, y, type)
    local enemy = {}

    -- Default stats
    enemy.health = 20
    enemy.x = x
    enemy.y = y
    enemy.velX = 0
    enemy.velY = 0
    enemy.width = 32
    enemy.height = 32
    enemy.speed = 3000
    enemy.friction = 10
    enemy.dead = false
    enemy.damage = 5
    enemy.stunned = false -- When true the enemy won't go after the player
    enemy.type = type
    enemy.class = "enemy"
    enemy.maxImmunityTimer = .15
    enemy.immunityTimer = enemy.maxImmunityTimer

    -- Physics
    enemy.body = love.physics.newBody(physics.gameWorld, x, y, "dynamic")
    enemy.shape = love.physics.newRectangleShape(enemy.width, enemy.height)
    enemy.fixture = love.physics.newFixture(enemy.body, enemy.shape)
    enemy.body:setMass(1)
    enemy.fixture:setUserData(enemy)
    enemy.body:setLinearDamping(enemy.friction)


    -- Sound Effects
    enemy.deathSound = love.audio.newSource("SoundEffects/enemy_killed.wav", "static")

    -- Status Effects
    enemy.statusEffects = {}
    -- Fire
    enemy.statusEffects.onFire = false
    enemy.maxFireTimer = 10
    enemy.fireTimer = enemy.maxFireTimer
    enemy.fireHitTimer = 0
    -- Frozen
    enemy.statusEffects.frozen = false
    enemy.freezeTimer = 0
    enemy.maxFreezeTimer = 10
    -- Oiled... oiled nuts... heh
    enemy.statusEffects.oiled = false
    enemy.maxOiledTimer = 13
    enemy.oiledTimer = 0

    -- Each enemy will return their init function
    local init
    if type == "generic" then
        init = require("Enemies/genericEnemy")
    elseif type == "small" then
        init = require("Enemies/smallEnemy")
    elseif type == "witch" then
        init = require("Enemies/witch")
    elseif type == "armored" then
        init = require("Enemies.armored")
    elseif type == "screecher" then
        init = require("Enemies.screecher")
    else
        error(type + "is not an enemy type.")
    end

    enemy = init(enemy, x, y)
    enemy:load()

    function enemy:genericUpdate(dt)
        self.x, self.y = self.body:getPosition()

        self.camX = select(1, camera:cameraCoords(self.x, self.y, nil, nil, GAMEWIDTH, GAMEHEIGHT))
        self.camY = select(2, camera:cameraCoords(self.x, self.y, nil, nil, GAMEWIDTH, GAMEHEIGHT))

        if self.immunityTimer < self.maxImmunityTimer then
            self.immunityTimer = self.immunityTimer + dt
        end

        -- Enemies can't be on fire and frozen at the same time
        if enemy.statusEffects.onFire then enemy.statusEffects.frozen = false end

        -- Half the enemies speed if they're frozen
        local originalSpeed = self.speed
        if enemy.statusEffects.frozen then
            self.speed = self.speed / 2
        end

        local threshold = 4 -- Stops the enemy from moving back and forth when it overshoots

        if self.stunned and self.velX == 0 and self.velY == 0 then
            self.stunned = false
        end

        self.velX, self.velY = 0, 0
        -- Move towards the player
        if self.hasNewMove then
            self:move(threshold)
        else
            if not self.stunned then
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

        -- Set the speed back if the enemy's frozen
        if self.statusEffects.frozen then self.speed = originalSpeed end

        if math.abs(self.velX) > 0 and math.abs(self.velY) > 0 then
            self.velX = self.velX / 1.44
            self.velY = self.velY / 1.44
        end

        self.body:applyForce(self.velX, self.velY)
        self.velX, self.velY = 0, 0

        -- Damaged by nuts
        for i = #Projectiles, 1, -1 do -- Is in reverse to stop the table from becoming sparse
            local p = Projectiles[i]
            if p ~= nil and self.immunityTimer >= self.maxImmunityTimer then
                if p.type == "nut" and enemy:collisionCheck(p.x, p.y, 6, 6) then
                    enemy:hit(p.damage, p.knockback, p.velX, p.velY)
                    self.immunityTimer = 0
                    if contains(p.specialEffects, "fire") then
                        self.statusEffects.onFire = true
                        self.fireTimer = 0
                    end
                    if contains(p.specialEffects, "freeze") then
                        self.statusEffects.frozen = true
                        self.freezeTimer = 0
                    end
                    if contains(p.specialEffects, "pierce") then
                        if p.pierces >= 2 then
                            table.remove(Projectiles, i)
                        end
                        p.pierces = p.pierces + 1
                    else
                        table.remove(Projectiles, i)
                    end
                end
            end
        end

        -- Status effects
        -- On Fire
        if self.statusEffects.onFire and self.fireTimer <= self.maxFireTimer then
            self.statusEffects.oiled = false
            self.fireTimer = self.fireTimer + dt
            self.fireHitTimer = self.fireHitTimer + dt

            if self.fireHitTimer > 1 then -- Fire hurts the enemy every second
                self.fireHitTimer = 0
                self:hit(2, 0, 0, 0)
            end

            -- Damage the player over time
            if self.fireTimer >= self.maxFireTimer then
                self.fireHitTimer = 0
                self.fireTimer = 0
                self.statusEffects.onFire = false
            end
        -- If the enemy suddenly loses the on fire status effect the timers will reset
        elseif self.fireTimer ~= 0 and self.statusEffects.onFire == false then
            self.fireTimer = 0
            self.fireHitTimer = 0
        end

        -- Frozen
        if self.statusEffects.frozen and self.freezeTimer <= self.maxFreezeTimer then
            self.freezeTimer = self.freezeTimer + dt

            if self.freezeTimer >= self.maxFreezeTimer then
                self.freezeTimer = 0
                self.statusEffects.frozen = false
            end
        -- If the enemy suddenly loses the on freeze status effect the timers will reset
        elseif self.freezeTimer ~= 0 and self.statusEffects.frozen == false then
            self.freezeTimer = 0
        end

        -- Oiled
        if self.statusEffects.oiled and self.oiledTimer < self.maxOiledTimer then
            self.fireTimer = self.oiledTimer + dt
        elseif self.oiledTimer >= self.maxOiledTimer then
            self.oiledTimer = 0
            self.statusEffects.oiled = false
        end


        -- Death logic
        if self.health <= 0 then
            self:genericKill()
        end
    end

    function enemy:collisionCheck(x, y, width, height)
        return
            self.x < x + width and
            self.x + self.width > x and
            self.y < y + height and
            self.y + self.height > y
    end

    function enemy:genericKill()
        self.dead = true
        self.health = 0
        self.body:destroy()
        self.deathSound:play()

        if self.kill ~= nil then
            self:kill()
        end
    end

    -- Something hitting the enemy
    function enemy:hit(damage, strength, velX, velY)
        enemyHitSound:play()

        -- Scale knockback based on enemy size
        if (self.width * self.height) < 1024 then strength = strength * 6 end
        if strength < 0 then strength = 0 end

        if self.hasNewOnHit then
            self:newOnHit(damage)
        else
            self:onHit(damage)
        end

        hitmarkerManager:new(damage, self.x + (self.width / 2), self.y)

        local magnitude = math.sqrt(velX * velX + velY * velY)

        if magnitude > 0 then
            local dirX = velX / magnitude
            local dirY = velY / magnitude

            if dirX < 0 then
                self:knockback((strength * math.abs(dirX)) * 1000, "left")
            elseif dirX > 0 then
                self:knockback((strength * math.abs(dirX)) * 1000, "right")
            end

            if dirY < 0 then
                self:knockback((strength * math.abs(dirY)) * 1000, "up")
            elseif dirY > 0 then
                self:knockback((strength * math.abs(dirY)) * 1000, "down")
            end
        end
    end

    function enemy:knockback(strength, direction)
        if direction == "up" then
            self.body:applyForce(0, -strength)
        elseif direction == "down" then
            self.body:applyForce(0, strength)
        elseif direction == "left" then
            self.body:applyForce(-strength, 0)
        elseif direction == "right" then
            self.body:applyForce(strength, 0)
        end
    end

    function enemy:onHit(damage)
        self.health = self.health - damage
    end

    table.insert(Enemies, enemy)
end

function EnemyManager:updateEnemies(dt)
    for i = #Enemies, 1, -1 do
        local e = Enemies[i]
        e:genericUpdate(dt)
        e:update(dt)

        -- Enemy out of bounds check
        if not collisionCheck(e.x, e.y, e.width, e.height, 0, 0, mapManager.realSize, mapManager.realSize) then
            print("Enemy \"" .. e.type .. "\" out of bounds at, " .. e.x .. ", " .. e.y)
            table.remove(Enemies, i)
        end

        -- Get rid of dead enemies
        if e.dead then
            EnemyManager.totalKills = EnemyManager.totalKills + 1
            table.remove(Enemies, i)
        end
    end
end

function EnemyManager.drawEnemies()
    for _, e in pairs(Enemies) do
        if e.statusEffects.onFire then
            love.graphics.setColor(.5, 0, 0)
        elseif e.statusEffects.oiled then
            love.graphics.setColor(.5, .5, 0)
        elseif e.statusEffects.frozen then
            love.graphics.setColor(.2, .2, 1)
        end
        e:draw()
        love.graphics.setColor(1, 1, 1)
    end
end

-- https://www.youtube.com/watch?v=BXLAqEchBW0
-- I could take everything from the init function and just return the size but that would take up too much cpu time, it's easier to do this
function EnemyManager:getWidth(type)
    if type == "generic" then
        return 32
    elseif type == "small" then
        return 16
    elseif type == "witch" then
        return 32
    elseif type == "armored" then
        return 32
    elseif type == "screecher" then
        return 16
    else
        error(type .. " is not an enemy type.")
    end
end

function EnemyManager:getHeight(type)
    if type == "generic" then
        return 32
    elseif type == "small" then
        return 16
    elseif type == "witch" then
        return 32
    elseif type == "armored" then
        return 32
    elseif type == "screecher" then
        return 32
    else
        error(type .. " is not an enemy type.")
    end
end

return EnemyManager
