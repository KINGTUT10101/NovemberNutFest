local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")

local hoardManager = require ("Managers.hoard")

local compW, compH = 350, 200

local function startWaveModal (show)
    if show ~= true then
        return
    end

    layout:setParent (0, 0, GAMEWIDTH, GAMEHEIGHT)

    -- Start button
    local centeredPos = {layout:center (300, 0)}
    layout:setOrigin (centeredPos[1], 510, 0, 0)

    if tux.show.button ({
        text = "Start Next Wave"
    }, layout:right (300, 100)) == "end" then
        hoardManager:startWave()
    end
    
    -- Background
    tux.show.label ({
        text = "Wave " .. hoardManager.waveCount + 1,
        valign = "top",
        padding = {padAll = 10}
    }, layout:center (compW, compH))
end

return startWaveModal