local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local Player = require("player")
local EnemyManager = require("Enemies/enemy")
local Nut = require ("Core.Nut")
local Gun = require("gun")
local ProjectileManager = require("Managers.projectile")
local hitmarkerManager = require("Managers.hitmarker")
local ItemManager = require("Managers.item")
local gameUI = require("UI/gameUI")

-- Enemy Spawn Timer
local spawnTimer = 0
local maxSpawnTimer = 3
local flip = false -- Will swap between two different enemies


function thisScene:load (...)
    sceneMan = ...

    -- Load Assets
    Player.load()
    ProjectileManager:load()
    Nut:load()
    Gun:load()

    -- Spawn enemy test
    EnemyManager.spawnEnemy(100, 100, "generic")
    EnemyManager.spawnEnemy(160, 100, "generic")
end

function thisScene:delete (...)
    local args = {...}
    
end

function thisScene:update (dt)

    spawnTimer = spawnTimer + dt

    if spawnTimer >= maxSpawnTimer then
        if flip then EnemyManager.spawnEnemy(100, 100, "generic") else EnemyManager.spawnEnemy(100, 100, "small") end
        spawnTimer = 0
        if flip then flip = false else flip = true end
    end

    -- Update Entities
    Player:update(dt)
    ItemManager.update(dt)
    Gun:update(dt)
    ProjectileManager:update(dt)
    EnemyManager.updateEnemies(dt)
    hitmarkerManager:update(dt)
end

function thisScene:draw ()
    -- Draw Entities
    EnemyManager.drawEnemies()
    Player:draw()
    Gun:draw()
    ItemManager:draw()
    ProjectileManager:draw()
    hitmarkerManager:draw()
    gameUI:draw()
end

function thisScene:keypressed (key, scancode, isrepeat)
    
end

function thisScene:mousereleased (x, y, button)

end

return thisScene