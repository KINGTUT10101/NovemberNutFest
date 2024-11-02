local function genericInit(enemy, x, y)

    function enemy:update(dt)
        
    end

    function enemy:draw()
        love.graphics.draw(SpriteSheets.GenericEnemy, enemy.x, enemy.y)
    end

    return enemy
end

return genericInit