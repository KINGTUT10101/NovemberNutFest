local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")

local inventoryHandler = require ("Core.inventoryHandler")

local function leftSideTrackers ()
    local usedStorage = 0

    for i = 1, inventoryHandler:getNumSections () do
        usedStorage = usedStorage + inventoryHandler:getSectionSize (i)
    end

    layout:setOrigin (15, 850, 15, 5)

    tux.show.button ({
        colors = {1, 0, 0, 1},
        image = icons.extinguisher,
        iscale = 1.65,
    }, layout:down (50, 50))
    tux.show.label ({
        text = "(Q) " .. #Throwables,
        align = "left",
        colors = {1, 0, 0, 1}
    }, layout:right (350, 50))

    tux.show.button ({
        colors = {1, 0, 0, 1},
        image = icons.inverseStar,
        iscale = 1.65,
    }, layout:down (50, 50))
    tux.show.label ({
        text = "(E) " .. #Consumables,
        align = "left",
        colors = {1, 0, 0, 1}
    }, layout:right (350, 50))

    
    tux.show.button ({
        colors = {1, 0, 0, 1},
        image = icons.person,
        iscale = 1.65,
    }, layout:down (50, 50))
    tux.show.label ({
        text = "(I) " .. usedStorage .. " / " .. inventoryHandler:getMaxStorage (),
        align = "left",
        colors = {1, 0, 0, 1}
    }, layout:right (350, 50))

    tux.show.button ({
        colors = {1, 0, 0, 1},
        image = icons.brush,
        iscale = 1.65,
    }, layout:down (50, 50))
    tux.show.label ({
        text = "(R) Shoot",
        align = "left",
        colors = {1, 0, 0, 1}
    }, layout:right (350, 50))
end

return leftSideTrackers