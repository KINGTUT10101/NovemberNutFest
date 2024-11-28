local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local push = require ("Libraries.push")
local tux = require ("Libraries.tux")
local lovelyToasts = require ("Libraries.lovelyToasts")
local mapManager = require ("Core.mapManager")
local camera = require ("Libraries.hump.camera")

local biggerFont = love.graphics.newFont (32)

local showFPS = true
local showCursorPos = true
local showMapPos = true
local showPlayerPos = true
local showRenderStats = false
local showScreenCrosshair = false
local showMouseCrosshair = false
local showCursorBox = true

local savedCursorPos = {
    x1 = 0,
    y1 = 0,
    x2 = 0,
    y2 = 0,
}

function thisScene:load (...)
    if DevMode == false then
        showFPS = false
        showCursorPos = false
    end
end

function thisScene:update (dt)
    if love.keyboard.isDown ("f1") == true then
        local mx, my = push:toGame(love.mouse.getPosition ())
        savedCursorPos.x1 = mx
        savedCursorPos.y1 = my

    elseif love.keyboard.isDown ("f2") == true then
        local mx, my = push:toGame(love.mouse.getPosition ())
        savedCursorPos.x2 = mx
        savedCursorPos.y2 = my
    end
end

function thisScene:lateDraw ()
    local mx, my = push:toGame(love.mouse.getPosition ())
    local tx, ty = mapManager:screenToMap (mx, my)

    -- print (camera.x, camera.y, camera.scale, "-", camera:worldCoords (mx, my))

    love.graphics.setFont (biggerFont)

    -- FPS
    if showFPS == true then
        love.graphics.setColor ({0, 0, 0, 0.45})
        love.graphics.rectangle ("fill", 0, 0, 100, 50)
        love.graphics.setColor ({1, 1, 1, 1})
        love.graphics.printf (love.timer.getFPS (), 0, 10, 100, "center") -- Mouse position
    end

    -- Show mouse postion
    if showCursorPos == true then
        love.graphics.setColor ({0, 0, 0, 0.45})
        love.graphics.rectangle ("fill", 1720, 0, 200, 50)
        love.graphics.setColor ({1, 1, 1, 1})
        love.graphics.printf (math.floor (mx) .. ", " .. math.floor (my), 1720, 10, 200, "center") -- Mouse position
    end

    -- Show map position
    if showMapPos == true then
        love.graphics.setColor ({0, 0, 0, 0.45})
        love.graphics.rectangle ("fill", 1720, 50, 200, 50)
        love.graphics.setColor ({1, 1, 1, 1})
        love.graphics.printf (math.floor (tx) .. ", " .. math.floor (ty), 1720, 60, 200, "center")
    end

    -- Show player postion
    if showPlayerPos == true then
        love.graphics.setColor ({0, 0, 0, 0.45})
        love.graphics.rectangle ("fill", 1720, 100, 200, 50)
        love.graphics.setColor ({1, 1, 1, 1})
        love.graphics.printf (math.floor (Player.x) .. ", " .. math.floor (Player.y), 1720, 110, 200, "center")
    end

    -- Rendering info
    if showRenderStats == true then
        local renderStats = love.graphics.getStats ()

        love.graphics.setColor ({0, 0, 0, 0.45})
        love.graphics.rectangle ("fill", 0, 880, 350, 200)
        love.graphics.setColor ({1, 1, 1, 1})
        love.graphics.printf ("Drawcalls: " .. renderStats.drawcalls, 10, 890, 350, "left") -- Mouse position
        love.graphics.printf ("Batched Calls: " .. renderStats.drawcalls, 10, 930, 350, "left") -- Mouse position
        love.graphics.printf ("Images: " .. renderStats.images, 10, 970, 350, "left") -- Mouse position
        love.graphics.printf ("Canvases: " .. renderStats.canvases, 10, 1010, 350, "left") -- Mouse position
    end

    -- Tux debug mode indicator
    if tux.utils.getDebugMode () == true then
        love.graphics.setColor ({0, 0, 0, 0.45})
        love.graphics.rectangle ("fill", 1720, 1030, 200, 50)
        love.graphics.setColor ({1, 1, 1, 1})
        love.graphics.printf ("Tux Debug", 1720, 1040, 200, "center") -- Mouse position
    end

    -- Screen crosshair
    if showScreenCrosshair == true then
        love.graphics.setColor(0, 0, 1, 1)
        love.graphics.line (GAMEWIDTH / 2, 0, GAMEWIDTH / 2, 1080)
        love.graphics.line (0, GAMEHEIGHT / 2, 1920, GAMEHEIGHT / 2)
    end

    -- Mouse crosshair
    if showMouseCrosshair == true then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.line (mx, 0, mx, 1080)
        love.graphics.line (0, my, 1920, my)
    end

    if showCursorBox == true then
        local boxW = savedCursorPos.x2 - savedCursorPos.x1
        local boxY = savedCursorPos.y2 - savedCursorPos.y1
        love.graphics.setColor ({1, 0, 0, 0.45})
            love.graphics.rectangle ("fill", savedCursorPos.x1, savedCursorPos.y1, boxW, boxY)
    end
end

function thisScene:keypressed (key, scancode, isrepeat)
	if key == "kp0" then
        showFPS = not showFPS
    elseif key == "kp1" then
        showCursorPos = not showCursorPos
    elseif key == "kp2" then
        showMapPos = not showMapPos
    elseif key == "kp3" then
        showPlayerPos = not showPlayerPos
    elseif key == "kp4" then
        showRenderStats = not showRenderStats
    elseif key == "kp5" then
        tux.utils.setDebugMode (not tux.utils.getDebugMode ())
    elseif key == "kp6" then
        showScreenCrosshair = not showScreenCrosshair
    elseif key == "kp7" then
        showMouseCrosshair = not showMouseCrosshair
    elseif key == "kp8" then
        showCursorBox = not showCursorBox
    elseif key == "f3" then
        local w = math.abs (savedCursorPos.x2 - savedCursorPos.x1)
        local h = math.abs (savedCursorPos.y2 - savedCursorPos.y1)
        love.system.setClipboardText (savedCursorPos.x1 .. ", " .. savedCursorPos.y1 .. ", " .. w .. ", " .. h)

        lovelyToasts.show ("Rectangle copied!", 1)
        print ("Rectangle copied!")
    end
end

function thisScene:mousereleased (x, y, button)

end

return thisScene