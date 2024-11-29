local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")
local inventoryHandler = require ("Core.newInventoryHandler")

local baseNuts = require ("Data.baseNuts")
local Nut = require ("Core.Nut")

local topStatusBar = require ("UI.topStatusBar")
local hotbar = require ("UI.hotbar")
local leftSideTrackers = require ("UI.leftSideTrackers")
local rightSideTrackers = require ("UI.rightSideTrackers")

local genericModal = require ("UI.genericModal")
local startWaveModal = require ("UI.startWaveModal")
local nutStats = require ("UI.nutStats")
local nutSelector = require ("UI.nutSelector")
local breedNutsModal = require ("UI.breedNutsModal")

local nutList = {
    Nut:new (baseNuts.peanut),
    Nut:new (baseNuts.coconut),
    Nut:new (baseNuts.macadamia),
    Nut:new (baseNuts.almond),
    Nut:new (baseNuts.candleNut),
    Nut:new (baseNuts.pine),
}

local currentNut = nil
local selectedNuts = {}

local stage = "chooseParents"
local childNut = nil

function thisScene:load (...)
    sceneMan = ...
    
end

function thisScene:update (dt)
    if stage == "chooseParents" then
        currentNut, selectedNuts = nutSelector (15, 575, nutList)
        nutStats (1470, 575, currentNut)
        breedNutsModal (selectedNuts, function (newChildNut)
            stage = "viewChildStats"
            childNut = newChildNut
        end)

    elseif stage == "viewChildStats" then
        layout:setParent (0, 0, GAMEWIDTH, GAMEHEIGHT)
        local centeredPos = {layout:center (435, 500)}

        nutStats (centeredPos[1], centeredPos[2], childNut)

        tux.show.label ({
            text = "Child Nut Stats",
            valign = "top",
            padding = {padAll = 10}
        }, centeredPos[1], centeredPos[2] - 65, 435, 100)

        if tux.show.button ({
            text = "Confirm",
        }, centeredPos[1], 800, 435, 100) == "end" then
            stage = "assignToHotbar"
        end

    elseif stage == "assignToHotbar" then
        local activeSlot = inventoryHandler:getActiveSlot ()
        local selectedNut = inventoryHandler:getNut (activeSlot)

        -- Selected stats
        if selectedNut ~= nil then
            nutStats (15, 575, selectedNut)
            tux.show.label ({
                text = "Hotbar Nut Stats",
                valign = "top",
                padding = {padAll = 10}
            }, 15, 510, 435, 100)
        end

        -- Child stats
        nutStats (1470, 575, childNut)
        tux.show.label ({
            text = "Child Nut Stats",
            valign = "top",
            padding = {padAll = 10}
        }, 1470, 510, 435, 100)

        layout:setParent (0, 0, GAMEWIDTH, GAMEHEIGHT)
        local centeredPos = {layout:center (300, 200)}

        if tux.show.button ({
            text = (selectedNut == nil) and "Add" or "Replace",
        }, centeredPos[1], 525, 300, 100) == "end" then
            stage = "startWave"

            inventoryHandler:replaceNut (childNut, activeSlot)

            childNut = nil
            selectedNuts = {}
        end
        genericModal ((selectedNut == nil) and ("Add to Slot " .. activeSlot) or ("Replace Slot " .. activeSlot), "")
    
    elseif stage == "startWave" then
        if startWaveModal () == true then
            stage = "inWave"
        end
    end

    hotbar ()
    leftSideTrackers ()
    rightSideTrackers ()
    topStatusBar ("TEMP", 0.45)
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