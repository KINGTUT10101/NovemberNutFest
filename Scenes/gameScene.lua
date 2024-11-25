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
local camera = require("Libraries.hump.camera")
local push = require("Libraries.push")
local physics = require("physics")
local mapManager = require("Core.mapManager")
local hoardManager = require("Managers.hoard")

-- Enemy Spawn Timer
local spawnTimer = 0
local maxSpawnTimer = 30
local flip = false -- Will swap between two different enemies

local boundaries = {} -- Boundries around the map

function thisScene:load (...)
    sceneMan = ...

    -- Load Assets
    Player.load()
    ProjectileManager:load()
    Nut:load()
    Gun:load()


    -- Map borders
    -- Top
    boundaries.topBody = love.physics.newBody(physics.gameWorld, (mapManager.mapSize*mapManager.tileSize)/2, (-mapManager.tileSize/2)-5, "static")
    boundaries.topShape = love.physics.newRectangleShape(mapManager.mapSize*mapManager.tileSize, 10)
    boundaries.topFixture = love.physics.newFixture(boundaries.topBody, boundaries.topShape)
    -- Bottom
    boundaries.topBody = love.physics.newBody(physics.gameWorld, (mapManager.mapSize*mapManager.tileSize)/2, (mapManager.mapSize*mapManager.tileSize)-10, "static")
    boundaries.topShape = love.physics.newRectangleShape(mapManager.mapSize*mapManager.tileSize, 10)
    boundaries.topFixture = love.physics.newFixture(boundaries.topBody, boundaries.topShape)
    -- Left
    boundaries.topBody = love.physics.newBody(physics.gameWorld, (-mapManager.tileSize/2)-7, (mapManager.mapSize*mapManager.tileSize)/2, "static")
    boundaries.topShape = love.physics.newRectangleShape(10, mapManager.mapSize*mapManager.tileSize)
    boundaries.topFixture = love.physics.newFixture(boundaries.topBody, boundaries.topShape)
    -- Right
    boundaries.topBody = love.physics.newBody(physics.gameWorld, (mapManager.mapSize*mapManager.tileSize)-10, (mapManager.mapSize*mapManager.tileSize)/2, "static")
    boundaries.topShape = love.physics.newRectangleShape(10, mapManager.mapSize*mapManager.tileSize)
    boundaries.topFixture = love.physics.newFixture(boundaries.topBody, boundaries.topShape)

    gameUI:load()
    camera:zoom(2)
end

function thisScene:delete (...)
    local args = {...}
end


function thisScene:update (dt)

    -- TEST ** spawner
    spawnTimer = spawnTimer + dt

    if spawnTimer >= maxSpawnTimer then
        --if flip then EnemyManager.spawnEnemy(100, 100, "generic") else EnemyManager.spawnEnemy(100, 100, "small") end
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
    hoardManager:update(dt)
    gameUI:update()
    physics.gameWorld:update(dt)

    camera:lookAt(Player.x, Player.y)
    -- Stop the camera from going off the sides of the map
    -- left
    if camera.x < GAMEWIDTH/4 then
        camera.x = GAMEWIDTH/4
    -- right
    elseif camera.x > (mapManager.mapSize*mapManager.tileSize)-GAMEWIDTH/4 then
        camera.x = (mapManager.mapSize*mapManager.tileSize)-GAMEWIDTH/4
    end
    -- top
    if camera.y < GAMEHEIGHT/4 then
        camera.y = GAMEHEIGHT/4
    -- bottom
    elseif camera.y > (mapManager.mapSize*mapManager.tileSize)-GAMEHEIGHT/4 then
        camera.y = (mapManager.mapSize*mapManager.tileSize)-GAMEHEIGHT/4
    end
end

function thisScene:draw ()

    camera:attach(nil, nil, push:getWidth(), push:getHeight())
    love.graphics.setScissor(0, 0, push:getWidth(), push:getHeight())
    -- Draw Entities
    EnemyManager.drawEnemies()
    Player:draw()
    Gun:draw()
    ItemManager:draw()
    ProjectileManager:draw()
    hitmarkerManager:draw()

    camera:detach()

    gameUI:draw()
end


function thisScene:keypressed (key, scancode, isrepeat)

end

function thisScene:mousereleased (x, y, button)

end

return thisScene