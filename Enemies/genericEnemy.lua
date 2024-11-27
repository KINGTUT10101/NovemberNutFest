local function genericInit(enemy, x, y)

    enemy.health = 125

    function enemy:load()
        self.sprite = love.graphics.newImage("Graphics/enemies/genericEnemy.png")
        self.sprite:setFilter("nearest", "nearest")
    end

    function enemy:update(dt)

    end

    function enemy:kill()
        ItemManager:placeConsumable(ItemManager:newItem("cashew apple"), self.x, self.y)
    end

    function enemy:draw()
        -- Add death animations ect.
        love.graphics.draw(self.sprite, self.x, self.y)
    end

    return enemy
end

return genericInit