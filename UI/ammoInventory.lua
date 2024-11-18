local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")
local inventoryHandler = require ("Core.inventoryHandler")

local compW, compH = 435, 500
local itemsPerRow = 5
local rowsPerPage = 5

local lastSectionIndex = 1
local page = 1

local function ammoInventory (x, y, sectionIndex)
    local sectionNuts = inventoryHandler:getSectionStorage (sectionIndex)
    local maxPage = math.ceil (#sectionNuts / (itemsPerRow * rowsPerPage))
    local selectedNut = nil

    -- Reset values if section index was changed
    if lastSectionIndex ~= sectionIndex then
        lastSectionIndex = sectionIndex
        page = 1
    end

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
    layout:setOrigin (x + 25, y + 50, 5, 5)
    layout:down (0, 0)

    for i = 1, rowsPerPage do
        for j = 1, itemsPerRow do
            local nutObj = sectionNuts[(i - 1) * itemsPerRow + j]

            if nutObj == nil then
                break
            else
                if tux.show.button ({
                    image = icons.info,
                    iscale = 2,
                }, layout:right (70, 70)) == "end" then
                    print ((i - 1) * itemsPerRow + j)
                    selectedNut = nutObj
                end
            end
        end
        layout:down (0, 0)
    end

    -- Edit buttons
    layout:setOrigin (x + compW, y, 5, 10)

    -- Edit name
    if tux.show.button ({
        image = inventoryHandler:getSectionIcon (sectionIndex),
        iscale = 2,
        tooltip = {
            text = "Edit section info"
        },
    }, layout:right (75, 75)) == "end" then
        print ("EDIT")
    end

    -- Background
    tux.show.label ({
        text = "Ammo Inventory",
        valign = "top",
        padding = {padAll = 5}
    }, x, y, compW, compH)

    return selectedNut
end

return ammoInventory