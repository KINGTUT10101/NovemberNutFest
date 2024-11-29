local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")

local inventoryHandler = require ("Core.newInventoryHandler")

local function leftSideTrackers ()
    local usedStorage = 0

    for i = 1, inventoryHandler:getMaxSlots () do
        usedStorage = usedStorage + inventoryHandler:getMaxAmmo (i)
    end

    layout:setOrigin (15, 950, 15, 5)

    tux.show.button ({
        colors = {1, 0, 0, 1},
        image = icons.extinguisher,
        iscale = 1.65,
    }, layout:down (50, 50))
    tux.show.label ({
        text = "(Q) " .. #Throwables,
        align = "left",
        colors = {1, 0, 0, 1},
        padding = {padX = 15},
    }, layout:right (350, 50))

    tux.show.button ({
        colors = {1, 0, 0, 1},
        image = icons.inverseStar,
        iscale = 1.65,
    }, layout:down (50, 50))
    tux.show.label ({
        text = "(E) " .. #Consumables,
        align = "left",
        colors = {1, 0, 0, 1},
        padding = {padX = 15},
    }, layout:right (350, 50))
end

return leftSideTrackers