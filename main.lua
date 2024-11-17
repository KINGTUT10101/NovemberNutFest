-- Set RNG seed
math.randomseed (os.time ())

-- Set image filtering
-- This works best for pixel art
love.graphics.setDefaultFilter ("nearest", "nearest")
love.graphics.setLineStyle ("smooth")

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
DevMode = true
ScaledGameWidth, ScaledGameHeight = GAMEWIDTH/Scale, GAMEHEIGHT/Scale

-- Defines the functions
local Player = require("player")
local EnemyManager = require("Enemies/enemy")
local Nut = require ("Core.Nut")
local Gun = require("gun")
local ProjectileManager = require("Managers.projectile")

function love.load ()
    -- TEMP
    -- Loads personal config changes
    -- You can change these by editing personalConfig.lua
    local config = require ("personalConfig")
    windowWidth, windowHeight = config.window[1], config.window[2]

    -- Set up Push
    push:setupScreen(GAMEWIDTH, GAMEHEIGHT, windowWidth, windowHeight, {fullscreen = false})
    
    -- Set up Lovely Toasts
    lovelyToasts.canvasSize = {GAMEWIDTH, GAMEHEIGHT}

    -- Set up Tux
    -- tux.utils.setDefaultSlices ()
    local test = require ("Helpers.slices").default
    tux.utils.setDefaultSlices (test)
    tux.utils.setDefaultFontSize (32)
    tux.utils.setDefaultColors (
        {
            normal = {
                fg = {1, 1, 1, 1},
                bg = {1, 1, 1, 1},
            },
            hover = {
                fg = {1, 1, 1, 1},
                bg = {1, 1, 1, 1},
            },
            held = {
                fg = {1, 1, 1, 1},
                bg = {1, 1, 1, 1},
            },
        }
    )

    -- Set up scenes and SceneMan
    sceneMan:newScene ("noiseTest", require ("Scenes.noiseTest"))
    sceneMan:newScene ("mapGenerationTest", require ("Scenes.mapGenerationTest"))
    sceneMan:newScene ("backgroundMap", require ("Scenes.backgroundMap"))
    sceneMan:newScene("game", require("Scenes.gameScene"))
    sceneMan:newScene("debug", require("Scenes.debug"))
    sceneMan:newScene("title", require("Scenes.title"))

    -- sceneMan:push ("backgroundMap")
    sceneMan:push ("title")
    sceneMan:push ("debug")
end

function love.update (dt)
	tux.callbacks.update (dt, push:toGame(love.mouse.getPosition ()))
    sceneMan:event ("update", dt)

    lovelyToasts.update(dt)
end

function love.draw ()
    push:start()
        sceneMan:event ("draw")
        tux.callbacks.draw ()
        sceneMan:event ("lateDraw")
        lovelyToasts.draw()
    push:finish()
end


function love.keypressed (key, scancode, isrepeat)
    tux.callbacks.keypressed (key, scancode, isrepeat)
    sceneMan:event ("keypressed", key, scancode, isrepeat)

end

function love.textinput (text)
    tux.callbacks.textinput (text)
end

function love.mousereleased (x, y, button)
    sceneMan:event ("mousereleased", x, y, button)
end