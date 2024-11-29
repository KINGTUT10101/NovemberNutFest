local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")

local inventoryHandler = require ("Core.newInventoryHandler")

local function leftSideTrackers (showActiveNutStats)
    layout:setOrigin (15, 900, 15, 5)

    tux.show.button ({
        colors = {1, 0, 0, 1},
        image = icons.battery,
        iscale = 1.65,
    }, layout:down (50, 50))
    tux.show.label ({
        text = "(Q) Consume: " .. #Consumables,
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
        text = "(E) Throw: " .. #Throwables,
        align = "left",
        colors = {1, 0, 0, 1},
        padding = {padX = 15},
    }, layout:right (350, 50))

    tux.show.button ({
        colors = {1, 0, 0, 1},
        image = icons.info,
        iscale = 1.65,
    }, layout:down (50, 50))
    tux.show.label ({
        text = "(I) Nut Info",
        align = "left",
        colors = (showActiveNutStats == true) and {0.5, 0, 0, 1} or {1, 0, 0, 1},
        padding = {padX = 15},
    }, layout:right (350, 50))
end

return leftSideTrackers