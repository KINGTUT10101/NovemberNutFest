local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")
local slices = require ("Helpers.slices")

local function topStatusBar (text, progress)
    layout:setParent (0, 0, GAMEWIDTH, GAMEHEIGHT)
    local centeredPos = {layout:center (800, 0)}
    layout:setOrigin (centeredPos[1], 75, 0, 15)

    -- Progress
    tux.show.label ({
        colors = {1, 0, 0, 1},
        slices = slices.rect,
    }, layout:right (800 * progress, 36))

    -- Progress background
    local centeredPos = {layout:center (800, 0)}
    layout:setOrigin (centeredPos[1], 75, 0, 15)

    tux.show.label ({
        colors = {0, 0, 0, 1},
        slices = slices.rect,
    }, layout:right (800, 36))

    local centeredPos = {layout:center (850, 0)}
    layout:setOrigin (centeredPos[1], 0, 0, 15)

    tux.show.label ({
        text = text,
        fsize = 48,
        padding = {padTop = 5},
        valign = "top"
    }, layout:right (850, 125))
end

return topStatusBar