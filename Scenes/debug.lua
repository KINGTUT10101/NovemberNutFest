local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local push = require ("Libraries.push")
local tux = require ("Libraries.tux")

local biggerFont = love.graphics.newFont (32)

local showFPS = true
local showCursorPos = true
local showRenderStats = false

function thisScene:load (...)
    if DevMode == false then
        showFPS = false
        showCursorPos = false
    end
end

function thisScene:update (dt)
    
end

function thisScene:draw ()
    love.graphics.setFont (biggerFont)

    -- FPS
    if showFPS == true then
        love.graphics.setColor ({0, 0, 0, 0.35})
        love.graphics.rectangle ("fill", 0, 0, 100, 50)
        love.graphics.setColor ({1, 1, 1, 1})
        love.graphics.printf (love.timer.getFPS (), 0, 10, 100, "center") -- Mouse position
    end

    -- Show mouse postion
    if showCursorPos == true then
        local mx, my = push:toGame(love.mouse.getPosition ())
        love.graphics.setColor ({0, 0, 0, 0.35})
        love.graphics.rectangle ("fill", 1720, 0, 200, 50)
        love.graphics.setColor ({1, 1, 1, 1})
        love.graphics.printf (math.floor (mx) .. ", " .. math.floor (my), 1720, 10, 200, "center") -- Mouse position
    end

    -- Rendering info
    if showRenderStats == true then
        local renderStats = love.graphics.getStats ()

        love.graphics.setColor ({0, 0, 0, 0.35})
        love.graphics.rectangle ("fill", 0, 880, 350, 200)
        love.graphics.setColor ({1, 1, 1, 1})
        love.graphics.printf ("Drawcalls: " .. renderStats.drawcalls, 10, 890, 350, "left") -- Mouse position
        love.graphics.printf ("Batched Calls: " .. renderStats.drawcalls, 10, 930, 350, "left") -- Mouse position
        love.graphics.printf ("Images: " .. renderStats.images, 10, 970, 350, "left") -- Mouse position
        love.graphics.printf ("Canvases: " .. renderStats.canvases, 10, 1010, 350, "left") -- Mouse position
    end

    -- Tux debug mode indicator
    if tux.utils.getDebugMode () == true then
        love.graphics.setColor ({0, 0, 0, 0.35})
        love.graphics.rectangle ("fill", 1720, 1030, 200, 50)
        love.graphics.setColor ({1, 1, 1, 1})
        love.graphics.printf ("Tux Debug", 1720, 1040, 200, "center") -- Mouse position
    end
end

function thisScene:keypressed (key, scancode, isrepeat)
	if key == "kp0" then
        showFPS = not showFPS
    elseif key == "kp1" then
        showCursorPos = not showCursorPos
    elseif key == "kp2" then
        showRenderStats = not showRenderStats
    elseif key == "kp3" then
        tux.utils.setDebugMode (not tux.utils.getDebugMode ())
    end
end

function thisScene:mousereleased (x, y, button)

end

return thisScene