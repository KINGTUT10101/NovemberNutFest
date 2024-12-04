local loadAnimationFrames = require ("Helpers.loadAnimationFrames")
local processAnimation = require ("Helpers.processAnimation")

local sprites = loadAnimationFrames ("Graphics/enemies/Basic")

local function genericInit(enemy, x, y)

    enemy.speed = 22500
    enemy.health = 550
    enemy.damage = 20
    enemy.width = 29
    enemy.height = 29
    enemy.deathSound = love.audio.newSource("SoundEffects/witch_death.wav", "static")
    enemy.friction = 5


    function enemy:load()
        self.sprite = love.graphics.newImage("Graphics/enemies/witch.png")
        self.sprite:setFilter("nearest", "nearest")
        enemy.body:setLinearDamping(enemy.friction)
        enemy.body:setMass(8)

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