local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local tux = require ("Libraries.tux")
local Nut = require ("Core.Nut")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")

local nutStats = require ("UI.nutStats")

local nutStatsMode = "combat"
local testNut = Nut:new ()

function thisScene:load (...)
    
    
end

function thisScene:update (dt)
    -- nutStatsMode = nutStats (15, 575, testNut, nutStatsMode)
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