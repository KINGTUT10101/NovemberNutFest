local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")

local hoardManager = require ("Managers.hoard")

local compW, compH = 350, 200

local function genericModal (title, text)
    layout:setParent (0, 0, GAMEWIDTH, GAMEHEIGHT)

    -- Text
    tux.show.label ({
        text = text,
        valign = "top",
        padding = {padAll = 15, padTop = 30},
        colors = {0, 0, 0, 0},
        align = "left",
        fsize = 24,
    }, layout:center (compW, compH))

    -- Background and title
    tux.show.label ({
        text = title,
        valign = "top",
        padding = {padAll = 10},
    }, layout:center (compW, compH))
end

return genericModal