-- Loads the libraries
local push = require ("Libraries.push")
local sceneMan = require ("Libraries.sceneMan")
local lovelyToasts = require ("Libraries.lovelyToasts")
local tux = require ("Libraries.tux")

-- Declares / initializes the local variables
local gameWidth, gameHeight = 1920, 1080
local windowWidth, windowHeight = 854, 480

-- Declares / initializes the global variables
Scale = 3
SpriteSheets = {}

-- Defines the functions
local Player = require("player")
local EnemyManager = require("enemies/enemy")
local Nut = require ("Core.Nut")
local Gun = require("gun")
local ProjectileManager = require("projectile")

function love.load ()
    -- Set up Push
    push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false})

    -- Load Assets
    Player.load()
    EnemyManager.loadSpriteSheets()
    Nut:load()

    -- Spawn enemy test
    EnemyManager.spawnEnemy(100, 100, "genericEnemy")

    -- Set up Lovely Toasts
    lovelyToasts.canvasSize = {gameWidth, gameHeight}
end

function love.update (dt)
	tux.callbacks.update (dt)
    sceneMan:event ("update", dt)

    -- Update Entities
    Player:update(dt)
    Gun:update()
    ProjectileManager:update()
    EnemyManager.updateEnemies(dt)

    lovelyToasts.update(dt)
end

function love.draw ()
    push:start()
        sceneMan:event ("draw")
        love.graphics.scale(Scale, Scale)

        -- Draw Entities
        EnemyManager.drawEnemies()
        Player.draw()
        ProjectileManager:draw()

        tux.callbacks.draw ()
        sceneMan:event ("lateDraw")
        lovelyToasts.draw()
    push:finish()
end


function love.keypressed (key, scancode, isrepeat)
    tux.callbacks.keypressed (key, scancode, isrepeat)
    sceneMan:event ("keypressed", key, scancode, isrepeat)

    -- TEMP: For testing the nut class
    local nutObj
    if key == "1" then
        nutObj = Nut:new ()
    elseif key == "2" then
        nutObj = Nut:new ({damage = 95})
    elseif key == "3" then
        nutObj = Nut:new ({damage = 65}, {damage = 35}, {})
    end

    -- Print nut info
    if nutObj ~= nil then
        print ("NEW NUT OBJECT")
        for key, value in pairs (nutObj) do
            print (key, value)
        end
        print ()
    end
end

function love.textinput (text)
    tux.callbacks.textinput (text)
end