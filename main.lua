-- Set RNG seed
math.randomseed (os.time ())

-- Loads the libraries
local push = require ("Libraries.push")
local sceneMan = require ("Libraries.sceneMan")
local lovelyToasts = require ("Libraries.lovelyToasts")
local tux = require ("Libraries.tux")

-- Declares / initializes the local variables
local windowWidth, windowHeight = 854, 480

-- Declares / initializes the global variables
Scale = 3
SpriteSheets = {}
GAMEWIDTH, GAMEHEIGHT = 1920, 1080

-- Defines the functions
local Player = require("player")
local EnemyManager = require("Enemies/enemy")
local Nut = require ("Core.Nut")
local Gun = require("gun")
local ProjectileManager = require("Managers.projectile")

function love.load ()
    -- Set image filtering
    -- This works best for pixel art
    love.graphics.setDefaultFilter ("nearest", "nearest")
    love.graphics.setLineStyle ("smooth")

    -- Set up Push
    push:setupScreen(GAMEWIDTH, GAMEHEIGHT, windowWidth, windowHeight, {fullscreen = false})
    
    -- Set up Lovely Toasts
    lovelyToasts.canvasSize = {GAMEWIDTH, GAMEHEIGHT}

    -- Set up scenes and SceneMan
    sceneMan:newScene ("noiseTest", require ("Scenes.noiseTest"))
    sceneMan:newScene ("mapGenerationTest", require ("Scenes.mapGenerationTest"))
    sceneMan:newScene ("backgroundMap", require ("Scenes.backgroundMap"))
    sceneMan:newScene("game", require("Scenes.gameScene"))

    sceneMan:push ("backgroundMap")
    sceneMan:push ("game")
end

function love.update (dt)
	tux.callbacks.update (dt)
    sceneMan:event ("update", dt)

    lovelyToasts.update(dt)
end

function love.draw ()
    push:start()
        love.graphics.scale(Scale, Scale)
        sceneMan:event ("draw")
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