local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")

local topStatusBar = require ("UI.topStatusBar")
local hotbar = require ("UI.hotbar")
local leftSideTrackers = require ("UI.leftSideTrackers")
local rightSideTrackers = require ("UI.rightSideTrackers")

local startWaveModal = require ("UI.startWaveModal")

function thisScene:load (...)
    sceneMan = ...
    
end

function thisScene:update (dt)
    hotbar ()

    leftSideTrackers ()
    rightSideTrackers ()

    -- WAVE STATUS
    topStatusBar ("TEMP", 0.45)

    startWaveModal (true)
end

function thisScene:draw ()
    
end

function thisScene:lateDraw ()
    
end

function thisScene:keypressed (key, scancode, isrepeat)
	
end

function thisScene:mousereleased (x, y, button)

end

return thisScene