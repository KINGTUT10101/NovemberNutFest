local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")
local inventoryHandler = require ("Core.newInventoryHandler")
local slices = require ("Helpers.slices")

local Nut = require ("Core.Nut")

local function hotbar ()
    local activeSection = inventoryHandler:getActiveSlot ()
    local activeNut = inventoryHandler:getNut (inventoryHandler:getActiveSlot ())

    -- HOTBAR
    layout:setParent (0, 0, GAMEWIDTH, GAMEHEIGHT)
    local centeredPos = {layout:center (750, 0)}
    layout:setOrigin (centeredPos[1], 995, 0, 15)

    for i = 1, inventoryHandler:getMaxSlots () do
        local currentNut = inventoryHandler:getNut (i)
        local nutImage = nil

        if currentNut ~= nil then
            nutImage = currentNut.image
        end

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

    -- NUT INFO
    local sectionName = (activeNut == nil) and "" or activeNut.name
    local sectionSize = inventoryHandler:getAmmoCount ()
    local totalSize = inventoryHandler:getMaxAmmo ()
    local centeredPos = {layout:center (750, 0)}
    layout:setOrigin (centeredPos[1], 900, 0, 15)

    tux.show.label ({
        text = string.format ("(%s) %s - %s / %s", activeSection, sectionName, sectionSize, totalSize),
        fsize = 24,
    }, layout:right (750, 50))
end

return hotbar