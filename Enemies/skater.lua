local function genericInit(enemy, x, y)

    enemy.speed = Player.runSpeed
    enemy.health = 120
    enemy.damage = 15
    enemy.width = 32
    enemy.height = 32

    function enemy:load()
        self.sprite = love.graphics.newImage("Graphics/skater.png")
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