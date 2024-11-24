local function genericInit(enemy, x, y)

    enemy.speed = 3000
    enemy.health = 550
    enemy.damage = 20
    enemy.width = 32
    enemy.height = 32
    enemy.deathSound = love.audio.newSource("SoundEffects/witch_death.wav", "static")
    enemy.friction = 5


    function enemy:load()
        self.sprite = love.graphics.newImage("Graphics/witch.png")
        self.sprite:setFilter("nearest", "nearest")
        enemy.body:setLinearDamping(enemy.friction)
    end

    function enemy:update(dt)

    end


    function enemy:draw()
        -- Add death animations ect.
        love.graphics.draw(self.sprite, enemy.x, enemy.y)
    end

    return enemy
end

return genericInit