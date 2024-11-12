local function genericInit(enemy, x, y)

    enemy.speed = Player.speed*Player.runSpeed
    enemy.health = 250
    enemy.damage = 20
    enemy.width = 32
    enemy.height = 32
    enemy.deathSound = love.audio.newSource("SoundEffects/witch_death.wav", "static")

    function enemy:load()
        self.sprite = love.graphics.newImage("Graphics/witch.png")
        self.sprite:setFilter("nearest", "nearest")
    end

    function enemy:update(dt)
        
    end


    function enemy:draw()
        -- Add death animations ect.
        love.graphics.draw(self.sprite, enemy.x-Player.x, enemy.y-Player.y)
    end

    return enemy
end

return genericInit