Enemies = {} -- list of all enemies in the game
EnemyManager = {}

function EnemyManager.spawnEnemy(x, y, type)
    local enemy = {}

    -- Default stats
    enemy.health = 20
    enemy.x = x
    enemy.y = y
    enemy.speed = 175
    enemy.dead = false
    enemy.damage = 5
    enemy.type = type

    -- Each enemy will return their init function
    local init
    if type == "genericEnemy" then
        init = require("enemies/genericEnemy")
    else
        error(type + "is not a type.")
    end

    enemy = init(enemy, x, y)

    function enemy:genericUpdate(dt)
        local dtSpeed = self.speed*dt
        -- Move towards the player
        if self.x < Player.x then
            self.x = self.x + dtSpeed
        end
        if self.x > Player.x then
            self.x = self.x - dtSpeed
        end
        if self.y < Player.y then
            self.y = self.y + dtSpeed
        end
        if self.y > Player.y then
            self.y = self.y - dtSpeed
        end
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