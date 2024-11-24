local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")
local inventoryHandler = require ("Core.inventoryHandler")

local compW, compH = 435, 500
local itemsPerRow = 1
local rowsPerPage = 5

local lastSectionIndex = nil
local page = 1

local function consumableInventory (x, y)
    local maxPage = math.ceil (#Consumables / (itemsPerRow * rowsPerPage))

    -- Page buttons
    if tux.show.button ({
        text = "<<",
        fsize = 28,
    }, x + 50, y + 440, 100, 50) == "end" then
        page = math.max (1, page - 1)
    end

    if tux.show.button ({
        text = ">>",
        fsize = 28,
    }, x + compW - 150, y + 440, 100, 50) == "end" then
        page = math.max (math.min (maxPage, page + 1), 1)
    end

    -- Page number
    layout:setParent (x, y, compW, compH)
    local centeredPos = {layout:center (compW, 0)}
    layout:setOrigin (centeredPos[1], y + 440, 0, 0)

    tux.show.label ({
        text = page .. " / " .. math.max (1, maxPage),
        colors = {0, 0, 0, 0}
    }, layout:right (compW, 50))

    -- Inventory section items
    local invIndexOffset = (page - 1) * itemsPerRow * rowsPerPage
    layout:setOrigin (x + 25, y + 35, 5, 5)
    layout:down (0, 0)

    for i = 1, rowsPerPage do
        for j = 1, itemsPerRow do
            local consumeObj = Consumables[(i - 1) * itemsPerRow + j + invIndexOffset]

            if consumeObj == nil then
                break
            else
                if tux.show.button ({
                    image = consumeObj.sprite,
                    iscale = 2,
                }, layout:down (70, 70)) == "end" then
                    print ((i - 1) * itemsPerRow + j + invIndexOffset)
                end

                if tux.show.label ({
                    text = consumeObj.object,
                    fsize = 24,
                    align = "left",
                    padding = {padX = 10},
                }, layout:right (230, 70)) == "end" then
                    print ((i - 1) * itemsPerRow + j + invIndexOffset)
                end

                if tux.show.label ({
                    image = icons.delete,
                    iscale = 2,
                }, layout:right (70, 70)) == "end" then
                    print ((i - 1) * itemsPerRow + j + invIndexOffset)
                end
            end
        end
        layout:down (0, 0)
    end

    -- Background
    tux.show.label ({
        text = "Consumables",
        valign = "top",
        padding = {padAll = 5}
    }, x, y, compW, compH)
end

return consumableInventory