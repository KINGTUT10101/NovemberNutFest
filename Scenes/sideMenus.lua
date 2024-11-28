local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local tux = require ("Libraries.tux")
local Nut = require ("Core.Nut")
local inventoryHandler = require ("Core.newInventoryHandler")
local ItemManager = require("Managers.item")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")

local nutStats = require ("UI.nutStats")
local ammoInventory = require ("UI.ammoInventory")
local sectionEditor = require ("UI.sectionEditor")
local buildMenu = require ("UI.buildMenu")
local requiredMaterials = require ("UI.requiredMaterials")
local throwableInventory = require ("UI.throwableInventory")
local consumableInventory = require ("UI.consumableInventory")

local pauseMenu = require ("UI.pauseMenu")

local nutStatsMode = "combat"
local testNut = Nut:new ()

function thisScene:load (...)
    
    
end

function thisScene:update (dt)
    consumableInventory (15, 575)
end

function thisScene:draw ()
    
end

function thisScene:lateDraw ()
    
end

function thisScene:keypressed (key, scancode, isrepeat)
    if key == "p" then
        inventoryHandler:addNut (testNut)

    elseif key == "o" then
        inventoryHandler:addItem(ItemManager:newItem("nut oil"))

    elseif key == "i" then
        inventoryHandler:addItem(ItemManager:newItem("cashew apple"))
    end
end

function thisScene:mousereleased (x, y, button)

end

return thisScene