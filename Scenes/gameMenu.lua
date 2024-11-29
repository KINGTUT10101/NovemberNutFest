local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")
local inventoryHandler = require ("Core.newInventoryHandler")
local hoardManager = require ("Managers.hoard")
local baseNuts = require ("Data.baseNuts")
local Nut = require ("Core.Nut")
local shuffle = require ("Libraries.lume").shuffle

local topStatusBar = require ("UI.topStatusBar")
local hotbar = require ("UI.hotbar")
local leftSideTrackers = require ("UI.leftSideTrackers")
local rightSideTrackers = require ("UI.rightSideTrackers")
local genericModal = require ("UI.genericModal")
local startWaveModal = require ("UI.startWaveModal")
local nutStats = require ("UI.nutStats")
local nutSelector = require ("UI.nutSelector")
local breedNutsModal = require ("UI.breedNutsModal")

local availableBaseNuts = {
    "peanut",
    "coconut",
    "macadamia",
    "almond",
    "candle",
    "pine",
}

local nutList = {}

local firstWave = true

local currentNut = nil
local selectedNuts = {}

local stage = "start"
local childNut = nil

local showActiveNutStats = false

function thisScene:load (...)
    sceneMan = ...
    
end

function thisScene:update (dt)
    if stage == "start" or (stage == "inWave" and hoardManager.inProgress == false and #Enemies <= 0) then
        stage = "chooseParents"

        -- Add random base nuts to breeding list
        if firstWave == true then
            local availableBaseNutsShuffled = shuffle (availableBaseNuts)
            nutList = {} -- Reset nut breeding list

            -- Add some random base nuts
            for i = 1, 3 do
                nutList[i] = Nut:new (baseNuts[availableBaseNutsShuffled[i]])
                nutList[i].name = "(BASE) " .. nutList[i].name
            end

        -- Add mostly hotbar nuts to breeding list
        else
            nutList = {} -- Reset nut breeding list

            -- Add one base nut
            local nutToAdd = availableBaseNuts[math.random (1, #availableBaseNuts)]
            nutList[1] = Nut:new (baseNuts[nutToAdd])
            nutList[1].name = "(BASE)" .. nutList[1].name

            -- Add the rest of the hotbar nuts
            for i = 1, inventoryHandler:getMaxSlots () do
                local nutObj = inventoryHandler:getNut (i)

                if nutObj ~= nil then
                    nutList[#nutList+1] = nutObj
                end
            end
        end
    end

    -- Only show the nut breeding menus between waves
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
            firstWave = false
        end
        genericModal ((selectedNut == nil) and ("Add to Slot " .. activeSlot) or ("Replace Slot " .. activeSlot), "")
    
    elseif stage == "startWave" then
        if startWaveModal () == true then
            stage = "inWave"
        end

        local activeNut = inventoryHandler:getNut (inventoryHandler:getActiveSlot ())
        if showActiveNutStats == true and activeNut ~= nil then
            nutStats (1470, 575, activeNut)
        end

    elseif stage == "inWave" then
        local activeNut = inventoryHandler:getNut (inventoryHandler:getActiveSlot ())
        if showActiveNutStats == true and activeNut ~= nil then
            nutStats (1470, 575, activeNut)
        end
    end

    hotbar ()
    leftSideTrackers (showActiveNutStats)
    rightSideTrackers ()
    topStatusBar ("TEMP", 0.45)
end

function thisScene:draw ()
    
end

function thisScene:lateDraw ()
    
end

function thisScene:keypressed (key, scancode, isrepeat)
	if key == "i" and (stage == "inWave" or stage == "startWave") then
        showActiveNutStats = not showActiveNutStats
    end
end

function thisScene:mousereleased (x, y, button)

end

return thisScene