local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")
local hoardManager = require ("Managers.hoard")
local inventoryHandler = require ("Core.newInventoryHandler")

local filledSlots = 0

function thisScene:whenAdded ()
    filledSlots = 0
    for i = 1, inventoryHandler:getMaxSlots () do
        if inventoryHandler:getNut (i) ~= nil then
            filledSlots = filledSlots + 1
        end
    end
end

function thisScene:update (dt)
    layout:setParent (0, 0, GAMEWIDTH, GAMEHEIGHT)
    local centeredPos = {layout:center (435, 500)}
    local x, y = centeredPos[1], centeredPos[2]

    layout:setOrigin (x + 15, y + 75, 10, 5)

    -- Waves survived
    tux.show.button ({
        colors = {1, 0, 0, 0},
        image = icons.stopwatch,
        iscale = 1.65,
    }, layout:down (50, 50))
    tux.show.label ({
        text = "Waves Survived: " .. hoardManager.waveCount,
        align = "left",
        colors = {1, 0, 0, 1},
        fsize = 28,
        padding = {padX = 15},
    }, layout:right (325, 50))

    -- Total kills
    tux.show.button ({
        colors = {1, 0, 0, 0},
        image = icons.star,
        iscale = 1.65,
    }, layout:down (50, 50))
    tux.show.label ({
        text = "Total Kills: " .. EnemyManager.totalKills,
        align = "left",
        colors = {1, 0, 0, 1},
        fsize = 28,
        padding = {padX = 15},
    }, layout:right (325, 50))

    -- Nuts in hotbar
    tux.show.button ({
        colors = {1, 0, 0, 0},
        image = icons.lightbulb,
        iscale = 1.65,
    }, layout:down (50, 50))
    tux.show.label ({
        text = "Nuts in Hotbar: " .. filledSlots,
        align = "left",
        colors = {1, 0, 0, 1},
        fsize = 28,
        padding = {padX = 15},
    }, layout:right (325, 50))

    -- Restart button
    if tux.show.button ({
        text = "Restart"
    }, 783, 600, 350, 75) == "end" then
        love.event.quit("restart")
    end

    -- Quit button
    if tux.show.button ({
        text = "Quit"
    }, 783, 685, 350, 75) == "end" then
        love.event.quit ()
    end

    -- Background
    tux.show.label ({
        text = "GAME OVER!",
        valign = "top",
        fsize = 48,
        padding = {padAll = 10, padTop = 10}
    }, x, y, 435, 500)
end

function thisScene:draw ()
    
end

function thisScene:keypressed (key, scancode, isrepeat)
	
end

function thisScene:mousereleased (x, y, button)

end

return thisScene