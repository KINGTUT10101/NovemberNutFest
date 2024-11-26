local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")

local biomes = require ("Data.biomes")
local mapManager = require ("Core.mapManager")

local function rightSideTrackers ()
    local tileX, tileY = mapManager:screenToMap (Player.x + 0.5, Player.y)
    local biomeDef = biomes[mapManager:getBiome (tileX, tileY)]

    layout:setOrigin (1905, 850, 15, 5)
    tux.show.button ({
        colors = {1, 0, 0, 1},
        image = icons.clock,
        iscale = 1.65,
    }, layout:left (50, 50))
    tux.show.label ({
        text = "11:56 PM - Midnight",
        align = "right",
        colors = {1, 0, 0, 1}
    }, layout:left (350, 50))

    tux.show.button ({
        colors = {1, 0, 0, 1},
        image = icons.calender,
        iscale = 1.65,
    }, layout:down (50, 50, false))
    tux.show.label ({
        text = "Day 5",
        align = "right",
        colors = {1, 0, 0, 1}
    }, layout:left (350, 50))

    tux.show.button ({
        colors = {1, 0, 0, 1},
        image = icons.inspect,
        iscale = 1.65,
    }, layout:down (50, 50, false))
    tux.show.label ({
        text = "BLANK Biome (N)",
        align = "right",
        colors = {1, 0, 0, 1}
    }, layout:left (350, 50))

    tux.show.button ({
        colors = {1, 0, 0, 1},
        image = icons.news,
        iscale = 1.65,
    }, layout:down (50, 50, false))
    tux.show.label ({
        text = string.format ("(%s, %s) (M)", tileX, tileY),
        align = "right",
        colors = {1, 0, 0, 1}
    }, layout:left (350, 50))
end

return rightSideTrackers