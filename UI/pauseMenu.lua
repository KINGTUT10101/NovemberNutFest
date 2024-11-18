local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")

-- Resume
-- Save
-- Load
-- Settings
-- Exit to main

local compW, compH = 550, 725

local function pauseMenu ()
    -- Menu buttons
    layout:setParent (0, 0, GAMEWIDTH, GAMEHEIGHT)
    local centeredPos = {layout:center (500, 0)}
    layout:setOrigin (centeredPos[1], 250, 0, 15)

    tux.show.button ({
        text = "Resume"
    }, layout:down (500, 100))

    -- Background
    layout:setParent (0, 0, GAMEWIDTH, GAMEHEIGHT)

    tux.show.label ({
        text = "PAUSED",
        valign = "top",
        padding = {padAll = 10},
        fsize = 48
    }, layout:center (compW, compH))
end

return pauseMenu