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

    tux.show.button ({
        colors = {1, 0, 0, 0},
        image = icons.bug,
        iscale = 1.65,
    }, layout:down (50, 50))
    tux.show.label ({
        text = "Co-dev: Kingtut 101",
        align = "left",
        colors = {1, 0, 0, 1},
        fsize = 28,
        padding = {padX = 15},
    }, layout:right (325, 50))

    -- Total kills
    tux.show.button ({
        colors = {1, 0, 0, 0},
        image = icons.bug,
        iscale = 1.65,
    }, layout:down (50, 50))
    tux.show.label ({
        text = "Co-dev: Wardence",
        align = "left",
        colors = {1, 0, 0, 1},
        fsize = 28,
        padding = {padX = 15},
    }, layout:right (325, 50))

    --Enemies killed last wave
    tux.show.button ({
        colors = {1, 0, 0, 0},
        image = icons.brush,
        iscale = 1.65,
    }, layout:down (50, 50))
    tux.show.label ({
        text = "Art: Kingtut 101",
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
        text = "Concept Art: Mateo",
        align = "left",
        colors = {1, 0, 0, 1},
        fsize = 28,
        padding = {padX = 15},
    }, layout:right (325, 50))

    tux.show.button ({
        colors = {1, 0, 0, 0},
        image = icons.musicNote,
        iscale = 1.65,
    }, layout:down (50, 50))
    tux.show.label ({
        text = "Music: Steven Melin",
        align = "left",
        colors = {1, 0, 0, 1},
        fsize = 28,
        padding = {padX = 15},
    }, layout:right (325, 50))

    -- Quit button
    if tux.show.button ({
        text = "Back"
    }, 783, 685, 350, 75) == "end" then
        sceneMan:clearStack ()
        sceneMan:push ("title")
    end

    -- Background
    tux.show.label ({
        text = "Credits",
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