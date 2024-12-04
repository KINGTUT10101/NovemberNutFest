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
        -- Add death animations ect.
        love.graphics.draw(sprites[self.frame], enemy.x, enemy.y)
    end

    return enemy
end

return genericInit