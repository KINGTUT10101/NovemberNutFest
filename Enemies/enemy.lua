local hitmarkerManager = require "Managers.hitmarker"
local contains = require "Helpers.contains"

Enemies = {} -- list of all enemies in the game
EnemyManager = {}

function EnemyManager.spawnEnemy(x, y, type)
    local enemy = {}

    -- Default stats
    enemy.health = 20
    enemy.x = x
    enemy.y = y
    enemy.velX = 0
    enemy.velY = 0
    enemy.width = 32
    enemy.height = 32
    enemy.speed = 125
    enemy.dead = false
    enemy.damage = 5
    enemy.stunned = false -- When true the enemy won't go after the player
    enemy.type = type
    enemy.maxImmunityTimer = .15
    enemy.immunityTimer = enemy.maxImmunityTimer

    -- Status effects
    enemy.statusEffects = {}
    -- Fire
    enemy.statusEffects.onFire = false
    enemy.maxFireTimer = 7
    enemy.fireTimer = enemy.maxFireTimer
    enemy.fireHitTimer = 0
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
    else
        error(type + "is not an enemy type.")
    end

    enemy = init(enemy, x, y)
    enemy:load()

    function enemy:genericUpdate(dt)

        if self.immunityTimer < self.maxImmunityTimer then
            self.immunityTimer = self.immunityTimer + dt
        end

        local dtSpeed = self.speed*dt
        local threshold = 4 -- Stops the enemy from moving back and forth when it overshoots

        if self.stunned and self.velX == 0 and self.velY == 0 then
            self.stunned = false
        end

        -- Move towards the player
        if not self.stunned then
            if math.abs(self.x - Player.relX) > threshold then
                if self.x < Player.relX then
                    self.velX = self.velX + dtSpeed
                end
                if self.x > Player.relX then
                    self.velX = self.velX - dtSpeed
                end
            end
            if math.abs(self.y - Player.relY) > threshold then
                if self.y < Player.relY then
                    self.velY = self.velY + dtSpeed
                end
                if self.y > Player.relY then
                    self.velY = self.velY - dtSpeed
                end
            end
        end


        -- Go through all enemies
        for i, e in pairs(Enemies) do
            -- Set oiled enemies on fire
            if e~=self and e:collisionCheck(self.x-5, self.y-5, self.width+5, self.height+5) then
                if e.statusEffects.oiled and self.statusEffects.onFire then
                    e.statusEffects.onFire = true
                    e.statusEffects.oiled = false
                end
            end
            -- TODO ** Spacial hashing :)
            -- Collisions with other enemies
            if e ~= self and e:collisionCheck(self.x + self.velX, self.y + self.velY, self.width, self.height) then
                -- Calculate overlap
                local overlapX = math.min(self.x + self.width, e.x + e.width) - math.max(self.x, e.x)
                local overlapY = math.min(self.y + self.height, e.y + e.height) - math.max(self.y, e.y)

                if overlapX < overlapY then
                    self.velX = 0
                    self.x = self.x + (self.x < e.x and -overlapX or overlapX)
                else
                    self.velY = 0
                    self.y = self.y + (self.y < e.y and -overlapY or overlapY)
                end
            end
        end

        -- Movement based on velocity
        if self.velX ~= 0 and self.velY ~= 0 then
            self.x = self.x + (self.velX/1.44)
            self.y = self.y + (self.velY/1.44)
        elseif self.velX ~= 0 or self.velY ~= 0 then
            self.x = self.x + self.velX
            self.y = self.y + self.velY
        end

        -- Taking away velocity based on the enemies speed
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
        if self.statusEffects.onFire and self.fireTimer < self.maxFireTimer then
            self.statusEffects.oiled = false
            self.fireTimer = self.fireTimer + dt
            self.fireHitTimer = self.fireHitTimer + dt
            
            if self.fireHitTimer > 1 then -- Fire hurts the enemy every second
                self.fireHitTimer = 0
                self:hit(2, 0, 0, 0)
            end

            if self.fireTimer > self.maxFireTimer then
                self.fireHitTimer = 0
                self.fireTimer = 0
                self.statusEffects.onFire = false
            end
        elseif self.fireTimer ~= 0 and self.statusEffects.onFire == false then
            self.fireTimer = 0
            self.fireHitTimer = 0
        end

        -- Oiled
        if self.statusEffects.oiled and self.oiledTimer < self.maxOiledTimer then
            self.fireTimer = self.oiledTimer + dt
        elseif self.oiledTimer >= self.maxOiledTimer then
            self.oiledTimer = 0
            self.statusEffects.oiled = false
        end

        -- Touch Attack
        if Player:collisionCheck(self.x, self.y, self.width, self.height) then
            if not self.statusEffects.oiled then
                Player:hit(self.damage)
            else
                Player:hit(math.floor(self.damage/1.4))
            end
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

        if self.kill ~= nil then
            self:kill()
        end
    end

    -- Something hitting the enemy
    function enemy:hit(damage, strength, velX, velY)

        -- Scale knockback based on enemy size
        if (self.width * self.height) < 1024 then strength = strength*6 end
        if strength < 0 then strength = 0 end

        self.health = self.health - damage

        hitmarkerManager:new(damage, self.x+(self.width/2), self.y)

        local magnitude = math.sqrt(velX * velX + velY * velY)
    
        if magnitude > 0 then
            local dirX = velX / magnitude
            local dirY = velY / magnitude
    
            if dirX < 0 then
                self:knockback(strength * math.abs(dirX), "left")
            elseif dirX > 0 then
                self:knockback(strength * math.abs(dirX), "right")
            end
    
            if dirY < 0 then
                self:knockback(strength * math.abs(dirY), "up")
            elseif dirY > 0 then
                self:knockback(strength * math.abs(dirY), "down")
            end
        end
    end

    function enemy:knockback(strength, direction)
    
        if direction == "up" then
            self.velY = -strength
        elseif direction == "down" then
            self.velY = strength
        elseif direction == "left" then
            self.velX = -strength
        elseif direction == "right" then
            self.velX = strength
        end
        enemy.stunned = true
    end

    table.insert(Enemies, enemy)
end



function EnemyManager.updateEnemies(dt)
    for i, e in pairs(Enemies) do
        e:genericUpdate(dt)
        e:update(dt)

        if e.dead then
            Enemies[i] = nil
        end
    end
end

function EnemyManager.drawEnemies()
    for _, e in pairs(Enemies) do
        if e.statusEffects.onFire then
            love.graphics.setColor(.5,0,0)
        elseif e.statusEffects.oiled then
            love.graphics.setColor(.5,.5,0)
        end
        e:draw()
        love.graphics.setColor(1,1, 1)
    end
end

return EnemyManager