local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")

local hoardManager = require ("Managers.hoard")
local biomes = require ("Data.biomes")
local mapManager = require ("Core.mapManager")

local function rightSideTrackers ()
    local tileX, tileY = mapManager:screenToMap (Player.x + 0.5, Player.y)
    local biomeDef = biomes[mapManager:getBiome (tileX, tileY)]

    layout:setOrigin (1905, 900, 15, 5)
    tux.show.button ({
        colors = {1, 0, 0, 1},
        image = icons.person,
        iscale = 1.65,
    }, layout:left (50, 50))
    tux.show.label ({
        text = "Wave Kills: " .. hoardManager.kills .. "/" .. math.floor(hoardManager.maxKills*hoardManager.hoardScale),
        align = "right",
        colors = {1, 0, 0, 1},
        padding = {padX = 15},
    }, layout:left (350, 50))

    tux.show.button ({
        colors = {1, 0, 0, 1},
        image = icons.stopwatch,
        iscale = 1.65,
    }, layout:down (50, 50, false))
    tux.show.label ({
        text = "Wave: " .. hoardManager.waveCount+1,
        align = "right",
        colors = {1, 0, 0, 1},
        padding = {padX = 15},
    }, layout:left (350, 50))

    local waveProgressText = nil
    if hoardManager.inProgress == true then
        waveProgressText = "Enemies: " .. #Enemies
    else
        waveProgressText = "Between Waves"
    end
    tux.show.button ({
        colors = {1, 0, 0, 1},
        image = icons.lightbulb,
        iscale = 1.65,
    }, layout:down (50, 50, false))
    tux.show.label ({
        text = waveProgressText,
        align = "right",
        colors = {1, 0, 0, 1},
        padding = {padX = 15},
    }, layout:left (350, 50))
end

return rightSideTrackers
