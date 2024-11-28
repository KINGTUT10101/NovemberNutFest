local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")
local inventoryHandler = require ("Core.newInventoryHandler")
local slices = require ("Helpers.slices")

local baseNuts = require ("Data.baseNuts") -- TEMP
local Nut = require ("Core.Nut")

inventoryHandler:replaceNut (Nut:new (baseNuts.peanut), 1)

local function hotbar ()
    local activeSection = inventoryHandler:getActiveSlot ()
    local activeNutName, activeNutImage = Nut:generateDisplayData (inventoryHandler:getNut (inventoryHandler:getActiveSlot ()))

    -- HOTBAR
    layout:setParent (0, 0, GAMEWIDTH, GAMEHEIGHT)
    local centeredPos = {layout:center (750, 0)}
    layout:setOrigin (centeredPos[1], 995, 0, 15)

    for i = 1, inventoryHandler:getMaxSlots () do
        local nutName, nutImage = Nut:generateDisplayData (inventoryHandler:getNut (i))

        if tux.show.button ({
            image = nutImage,
            iscale = 2,
            colors = (i == activeSection) and {0.5, 0.5, 0.5, 1} or nil
        }, layout:right (75, 75)) == "end" then
            inventoryHandler:setActiveSlot (i)
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
    local sectionName = activeNutName
    local sectionSize = inventoryHandler:getAmmoCount ()
    local totalSize = inventoryHandler:getMaxAmmo ()
    local centeredPos = {layout:center (750, 0)}
    layout:setOrigin (centeredPos[1], 900, 0, 15)

    tux.show.label ({
        text = string.format ("(%s) %s - %s / %s", activeSection, sectionName, sectionSize, totalSize)
    }, layout:right (750, 50))
end

return hotbar