local function genericInit(enemy, x, y)

    enemy.speed = 100
    enemy.health = 200

    function enemy:update(dt)
        
    end

    function enemy:kill()
        ItemManager:placeConsumable(ItemManager:newItem("cashew apple"), self.x, self.y)
    end

    function enemy:draw()
        -- Add death animations ect.
        love.graphics.draw(SpriteSheets.GenericEnemy, enemy.x, enemy.y)
    end

    return enemy
end

return genericInit