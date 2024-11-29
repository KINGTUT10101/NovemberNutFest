local function genericInit(enemy, x, y)
    enemy.speed = 1650
    enemy.health = 50
    enemy.damge = 10
    enemy.width = 11
    enemy.height = 16

    function enemy:load()
        self.sprite = love.graphics.newImage("Graphics/enemies/smallEnemy.png")
        self.sprite:setFilter("nearest", "nearest")
        enemy.body:setMass(.5)
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
