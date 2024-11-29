local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")
local inventoryHandler = require ("Core.inventoryHandler")
local Nut = require ("Core.Nut")
local getTableLength = require ("Helpers.getTableLength")

local compW, compH = 435, 500
local itemsPerRow = 5
local rowsPerPage = 5

local page = 1
local selectedNuts = {}

local function nutSelector (x, y, nutList, reset)
    local currentNut = nutList[page]
    local nutName, nutImage = Nut:generateDisplayData (currentNut)
    local maxPage = #nutList

    -- Reset values
    if reset == true then
        page = 1
        selectedNuts = {}
    end

    -- Page buttons
    if tux.show.button ({
        text = "<<",
        fsize = 28,
    }, x + 50, y + 435, 100, 50) == "end" then
        page = math.max (1, page - 1)
    end

    if tux.show.button ({
        text = ">>",
        fsize = 28,
    }, x + compW - 150, y + 435, 100, 50) == "end" then
        page = math.max (math.min (maxPage, page + 1), 1)
    end

    -- Page number
    layout:setParent (x, y, compW, compH)
    local centeredPos = {layout:center (compW, 0)}
    layout:setOrigin (centeredPos[1], y + 435, 0, 0)

    tux.show.label ({
        text = page .. " / " .. math.max (1, maxPage),
        colors = {0, 0, 0, 0}
    }, layout:right (compW, 50))

    layout:setParent (x, y, compW, compH)
    local centeredPos = {layout:center (400, 0)}
    layout:setOrigin (centeredPos[1], y + 50, 0, 0)

    -- Nut image
    tux.show.label ({
        image = nutImage,
        iscale = 4,
        colors = {currentNut.bgColor[1], currentNut.bgColor[2], currentNut.bgColor[3], 1},
    }, layout:down (400, 150))

    -- Nut name
    tux.show.label ({
        text = nutName,
        fsize = 36,
        colors = {0, 0, 0, 0},
        padding = {padX = 5},
    }, layout:down (400, 125))

    -- Select toggle button
    if selectedNuts[page] == true then
        if tux.show.button ({
            text = "Unselect for Breeding",
            padding = {padX = 5},
            colors = {0.75, 0.75, 0.75, 1},
        }, layout:down (400, 100)) == "end" then
            selectedNuts[page] = nil
        end

    elseif getTableLength (selectedNuts) >= 2 then
        if tux.show.button ({
            text = "Max # of Nuts",
            padding = {padX = 5},
            colors = {0.5, 0.5, 0.5, 1},
        }, layout:down (400, 100)) == "end" then
            selectedNuts[page] = nil
        end

    else
        if tux.show.button ({
            text = "Select for Breeding",
            padding = {padX = 5},
        }, layout:down (400, 100)) == "end" then
            selectedNuts[page] = true
        end
    end

    -- Background
    tux.show.label ({
        text = "Choose Parent Nuts",
        valign = "top",
        padding = {padAll = 5}
    }, x, y, compW, compH)

    local result = {}
    for i = 1, maxPage do
        if selectedNuts[i] ~= nil then
            result[#result+1] = nutList[i]
        end
    end

    return currentNut, result
end

return nutSelector