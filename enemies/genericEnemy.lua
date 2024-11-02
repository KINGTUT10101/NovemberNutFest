local function genericInit(enemy, x, y)

    enemy.speed = 100

    function enemy:update(dt)
        
    end

    function enemy:draw()
        if not self.dead then -- Add death animations ect.
            love.graphics.draw(SpriteSheets.GenericEnemy, enemy.x, enemy.y)
        end
    end

    return enemy
end

return genericInit