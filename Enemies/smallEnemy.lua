local function genericInit(enemy, x, y)
    enemy.speed = enemy.speed+2000
    enemy.health = 50
    enemy.damge = 5
    enemy.width = 16
    enemy.height = 16

    function enemy:load()
        self.sprite = love.graphics.newImage("Graphics/smallEnemy.png")
        self.sprite:setFilter("nearest", "nearest")
        enemy.body:setMass(.7)
    end

    function enemy:update(dt)

    end

    function enemy:kill()
        ItemManager:placeConsumable(ItemManager:newItem("nut oil"), self.x, self.y)
    end

    function enemy:draw()
        -- Add death animations ect.
        love.graphics.draw(self.sprite, enemy.x, enemy.y)
    end

    return enemy
end

return genericInit
