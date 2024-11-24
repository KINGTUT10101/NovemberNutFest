local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")
local inventoryHandler = require ("Core.inventoryHandler")

local sectionIcons = {
    icons.inverseStar,
    icons.lightbulb,
    icons.extinguisher,
    icons.temperature,
}

local compW, compH = 435, 500
local itemsPerRow = 5
local rowsPerPage = 3
local maxNameLength = 15

local lastSectionIndex = nil
local page = 1

local nameInputData = {
    text = "ERROR",
    inFocus = false,
}

local function sectionEditor (x, y, sectionIndex)
    local maxPage = math.ceil (#sectionIcons / (itemsPerRow * rowsPerPage))
    local selectedNut = nil

    -- Reset values if section index was changed
    if lastSectionIndex ~= sectionIndex then
        lastSectionIndex = sectionIndex
        page = 1
        nameInputData.text = inventoryHandler:getSectionName (sectionIndex)
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

    -- Name editor
    layout:setParent (x, y, compW, compH)
    local centeredPos = {layout:center (400, 0)}
    layout:setOrigin (centeredPos[1], y + 440, 0, 0)

    tux.show.singleInput ({
        data = nameInputData,
        fsize = 24,
        padding = {padX = 5}
    }, centeredPos[1], y + 50, 400, 50)

    -- Clamp name length
    if #nameInputData.text > maxNameLength then
        nameInputData.text = string.sub (nameInputData.text, 1, maxNameLength)
    end

    -- Inventory section items
    local invIndexOffset = (page - 1) * itemsPerRow * rowsPerPage
    layout:setOrigin (x + 25, y + 200, 5, 5)
    layout:down (0, 0)

    for i = 1, rowsPerPage do
        for j = 1, itemsPerRow do
            local icon = sectionIcons[(i - 1) * itemsPerRow + j + invIndexOffset]

            if icon == nil then
                break
            else
                if tux.show.button ({
                    image = icon,
                    iscale = 2,
                }, layout:right (70, 70)) == "end" then
                    print ((i - 1) * itemsPerRow + j + invIndexOffset)
                end
            end
        end
        layout:down (0, 0)
    end

    -- Edit buttons
    layout:setOrigin (x + compW, y, 5, 10)

    -- Save
    if tux.show.button ({
        image = icons.save,
        iscale = 2,
        tooltip = {
            text = "Save and close"
        },
    }, layout:right (75, 75)) == "end" then
        print ("SAVE")
    end

    -- Section icon
    layout:setParent (x, y + 100, compW, 100)

    tux.show.label ({
        image = inventoryHandler:getSectionIcon (sectionIndex),
        iscale = 2.5,
        colors = {0, 0, 0, 0},
    }, layout:center (compW, 100))

    -- Background
    tux.show.label ({
        text = "Edit Section",
        valign = "top",
        padding = {padAll = 5}
    }, x, y, compW, compH)

    return selectedNut
end

return sectionEditor