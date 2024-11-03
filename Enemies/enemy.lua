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
    enemy.strength = 30 -- knockback strength
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

        -- Move towards the player
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
        -- TODO

        -- Touch Attack
        if Player:collisionCheck(self.x, self.y, self.width, self.height) then
            Player:hit(self.damage)
        end

        -- Death logic
        if self.health <= 0 then
            self:kill()
        end
    end

    function enemy:knockback(strength, direction)
        if direction == "left" then
            self.velX = self.velX - strength
        elseif direction == "right" then
            self.velX = self.velX + strength
        elseif direction == "up" then
            self.velY = self.velY - strength
        elseif direction == "down" then
            self.velY = self.velY + strength
        end
    end

    function enemy:kill()
        self.dead = true
        self.healht = 0
    end

    table.insert(Enemies, enemy)
end


function EnemyManager.updateEnemies(dt)
    for i, e in ipairs(Enemies) do
        e:genericUpdate(dt)
        e:update(dt)
    end
end

function EnemyManager.drawEnemies()
    for i, e in ipairs(Enemies) do
        e:draw()
    end
end


function EnemyManager.loadSpriteSheets()
    SpriteSheets.GenericEnemy = love.graphics.newImage("Graphics/genericEnemy.png")
    SpriteSheets.GenericEnemy:setFilter("nearest", "nearest")
end

return EnemyManager