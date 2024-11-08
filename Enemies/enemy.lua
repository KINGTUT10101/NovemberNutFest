local hitmarkerManager = require "Managers.hitmarker"

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

    -- Each enemy will return their init function
    local init
    if type == "genericEnemy" then
        init = require("Enemies/genericEnemy")
    else
        error(type + "is not a type.")
    end

    enemy = init(enemy, x, y)

    function enemy:genericUpdate(dt)
        local dtSpeed = self.speed*dt
        local threshold = 4 -- Stops the enemy from moving back and forth when it overshoots

        if self.stunned and self.velX == 0 and self.velY == 0 then
            self.stunned = false
        end

        -- Move towards the player
        if not self.stunned then
            if math.abs(self.x - Player.x) > threshold then
                if self.x < Player.x then
                    self.velX = self.velX + dtSpeed
                end
                if self.x > Player.x then
                    self.velX = self.velX - dtSpeed
                end
            end
            if math.abs(self.y - Player.y) > threshold then
                if self.y < Player.y then
                    self.velY = self.velY + dtSpeed
                end
                if self.y > Player.y then
                    self.velY = self.velY - dtSpeed
                end
            end
        end

        -- Stopping if another enemy is next to it
        -- TODO ** Spacial hashing :)
        for i, e in pairs(Enemies) do
            if Enemies[i] ~= self then
                if e:collisionCheck(self.x+self.velX, self.y, self.width, self.height) then
                    if self.velX > 0 then
                        self.x = e.x-self.width
                    elseif self.x < 0 then
                        self.x = e.x+e.width
                    end
                    self.velX = 0
                end
                if e:collisionCheck(self.x, self.y+self.velY, self.width, self.height) then
                    if self.velY > 0 then
                        self.y = e.y-self.height
                    elseif self.y < 0 then
                        self.y = e.y+e.height
                    end
                    self.velY = 0
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
            if Projectiles[i] ~= nil then
                if Projectiles[i].type == "nut" and enemy:collisionCheck(Projectiles[i].x, Projectiles[i].y, 6, 6) then
                    enemy:hit(Projectiles[i].damage, Projectiles[i].knockback, Projectiles[i].velX, Projectiles[i].velY)
                    table.remove(Projectiles, i)
                end
            end
        end

        -- Touch Attack
        if Player:collisionCheck(self.x, self.y, self.width, self.height) then
            Player:hit(self.damage)
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
    for i, e in pairs(Enemies) do
        e:draw()
    end
end


function EnemyManager.loadSpriteSheets()
    SpriteSheets.GenericEnemy = love.graphics.newImage("Graphics/genericEnemy.png")
    SpriteSheets.GenericEnemy:setFilter("nearest", "nearest")
end

return EnemyManager