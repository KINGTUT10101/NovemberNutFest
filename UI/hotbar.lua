local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")
local inventoryHandler = require ("Core.inventoryHandler")
local slices = require ("Helpers.slices")

local function hotbar ()
    local activeSection = inventoryHandler:getActiveSectionIndex ()
    local sectionInfo = inventoryHandler.sectionInfo

    -- HOTBAR
    layout:setParent (0, 0, GAMEWIDTH, GAMEHEIGHT)
    local centeredPos = {layout:center (750, 0)}
    layout:setOrigin (centeredPos[1], 995, 0, 15)

    for i = 1, inventoryHandler:getNumSections () do
        if tux.show.button ({
            image = sectionInfo[i].icon,
            iscale = 2,
            colors = (i == activeSection) and {0.5, 0.5, 0.5, 1} or nil
        }, layout:right (75, 75)) == "end" then
            inventoryHandler:setActiveSectionIndex (i)
        end
    end

    -- HEALTHBAR
    local centeredPos = {layout:center (750, 0)}
    layout:setOrigin (centeredPos[1], 955, 0, 15)

    tux.show.label ({
        colors = {1, 0, 0, 1},
        slices = slices.rect,
    }, layout:right (750 * Player.health / 100, 36))

    local centeredPos = {layout:center (750, 0)}
    layout:setOrigin (centeredPos[1], 955, 0, 15)

    tux.show.label ({
        colors = {0, 0, 0, 1},
        slices = slices.rect,
    }, layout:right (750, 36))

    -- SECTION INFO
    local sectionName = inventoryHandler:getSectionName (activeSection)
    local sectionSize = #inventoryHandler:getSectionStorage (activeSection)
    local totalSize = inventoryHandler:getMaxStorage ()
    local centeredPos = {layout:center (750, 0)}
    layout:setOrigin (centeredPos[1], 900, 0, 15)

    tux.show.label ({
        text = string.format ("(%s) %s - %s / %s", activeSection, sectionName, sectionSize, totalSize)
    }, layout:right (750, 50))
end

return hotbar