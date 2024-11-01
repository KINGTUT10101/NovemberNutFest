-- Loads the libraries
local push = require ("Libraries.push")
local sceneMan = require ("Libraries.sceneMan")
local lovelyToasts = require ("Libraries.lovelyToasts")
local tux = require ("Libraries.tux")

-- Declares / initializes the local variables
local gameWidth, gameHeight = 1920, 1080
local windowWidth, windowHeight = 1280, 720

-- Declares / initializes the global variables


-- Defines the functions


function love.load ()
    -- Set up Push
    push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false})

    -- Set up Lovely Toasts
    lovelyToasts.canvasSize = {gameWidth, gameHeight}
end

function love.update (dt)
	tux.callbacks.update (dt)
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