local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")

local hoardManager = require ("Managers.hoard")
local biomes = require ("Data.biomes")
local mapManager = require ("Core.mapManager")

local function rightSideTrackers ()
    local tileX, tileY = mapManager:screenToMap (Player.x + 0.5, Player.y)
    local biomeDef = biomes[mapManager:getBiome (tileX, tileY)]

    layout:setOrigin (1905, 950, 15, 5)
    tux.show.button ({
        colors = {1, 0, 0, 1},
        image = icons.clock,
        iscale = 1.65,
    }, layout:left (50, 50))
    tux.show.label ({
        text = "Wave Kills: " .. hoardManager.kills .. "/" .. hoardManager.maxKills,
        align = "right",
        colors = {1, 0, 0, 1},
        padding = {padX = 15},
    }, layout:left (350, 50))

    tux.show.button ({
        colors = {1, 0, 0, 1},
        image = icons.calender,
        iscale = 1.65,
    }, layout:down (50, 50, false))
    tux.show.label ({
        text = "Wave " .. math.min (hoardManager.waveCount, 1),
        align = "right",
        colors = {1, 0, 0, 1},
        padding = {padX = 15},
    }, layout:left (350, 50))
end

return rightSideTrackers