local function genericInit(enemy, x, y)

    enemy.speed = 100
    enemy.health = 500

    function enemy:update(dt)
        
    end

    function enemy:draw()
        -- Add death animations ect.
        love.graphics.draw(SpriteSheets.GenericEnemy, enemy.x, enemy.y)
    end

    return enemy
end

return genericInit