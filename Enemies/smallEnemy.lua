local loadAnimationFrames = require ("Helpers.loadAnimationFrames")
local processAnimation = require ("Helpers.processAnimation")

local sprites = loadAnimationFrames ("Graphics/enemies/Small")

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

        self.frame = 1
        self.frameTimer = 0
    end

    function enemy:update(dt)
        processAnimation (dt, self, #sprites, 0.2)
    end


    function enemy:draw()
        local velX = self.body:getLinearVelocity()
        local scale, origin = 1, 0
        if velX < 0 then
            scale = -1
            origin = sprites[self.frame]:getWidth ()
        end
        love.graphics.draw(sprites[self.frame], self.x, self.y, nil, scale, 1, origin)
    end

    return enemy
end

return genericInit
