local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local Player = require("player")
local EnemyManager = require("Enemies/enemy")
local Nut = require ("Core.Nut")
local Gun = require("gun")
local ProjectileManager = require("projectile")


function thisScene:load (...)
    sceneMan = ...

    -- Load Assets
    Player.load()
    EnemyManager.loadSpriteSheets()
    Nut:load()
    Gun:load()

    -- Spawn enemy test
    EnemyManager.spawnEnemy(100, 100, "genericEnemy")
end

function thisScene:delete (...)
    local args = {...}
    
end

function thisScene:update (dt)
    -- Update Entities
    Player:update(dt)
    Gun:update()
    ProjectileManager:update(dt)
    EnemyManager.updateEnemies(dt)
end

function thisScene:draw ()
    -- Draw Entities
    EnemyManager.drawEnemies()
    Player.draw()
    Gun:draw()
    ProjectileManager:draw()
end

function thisScene:keypressed (key, scancode, isrepeat)
    
end

function thisScene:mousereleased (x, y, button)

end

return thisScene