local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")

local statsToShow = {
    all = {
        {
            id = "level",
            name = "Level",
            icon = icons.inverseStar,
        },
        {
            id = "invSize",
            name = "Inventory Size",
            icon = icons.inverseStar,
        },
    },
    combat = {
        {
            id = "damage",
            name = "Damage",
            icon = icons.inverseStar,
        },
        {
            id = "range",
            name = "Range",
            icon = icons.inverseStar,
        },
        {
            id = "projVelocity",
            name = "Velocity",
            icon = icons.inverseStar,
        },
        {
            id = "projScale",
            name = "Bullet Size",
            icon = icons.inverseStar,
        },
        {
            id = "knockback",
            name = "Knockback",
            icon = icons.inverseStar,
        },
        {
            id = "spread",
            name = "Spread",
            icon = icons.inverseStar,
        },
    },
    farming = {
        {
            id = "growthTime",
            name = "Growth Time",
            icon = icons.inverseStar,
        },
        {
            id = "yield",
            name = "Crop Yield",
            icon = icons.inverseStar,
        },
        {
            id = "variation",
            name = "Yield Variation",
            icon = icons.inverseStar,
        },
    },
}

local compW, compH = 435, 500

-- Mode can be either "combat", "effects", or "farming"
-- The component may modify the mode, so it returns the new mode as a string
local function nutStats (x, y, nutObj, mode)
    -- Mode change buttons
    layout:setParent (x + 10, y, compW - 20, compH)
    local centeredPos = {layout:center (compW - 20, 0)}
    layout:setOrigin (centeredPos[1], y + 50, 0, 0)

    if tux.show.button ({
        text = "Combat",
        fsize = 28,
    }, layout:right ((compW - 20) / 3, 50)) == "end" then
        mode = "combat"
    end

    if tux.show.button ({
        text = "Effects",
        fsize = 28,
    }, layout:right ((compW - 20) / 3, 50)) == "end" then
        mode = "effects"
    end

    if tux.show.button ({
        text = "Farming",
        fsize = 28,
    }, layout:right ((compW - 20) / 3, 50)) == "end" then
        mode = "farming"
    end

    -- Iterate over nut stats
    layout:setOrigin (x + 15, y + 100, 10, 5)

    -- Core stats
    for index, statDef in ipairs (statsToShow.all) do
        -- Icon
        tux.show.button ({
            colors = {1, 0, 0, 1},
            image = statDef.icon,
            iscale = 1.65,
        }, layout:down (36, 36))

        -- Text
        tux.show.label ({
            text = statDef.name .. ": " .. "42",
            align = "left",
            colors = {1, 0, 0, 1},
            fsize = 28,
        }, layout:right (350, 36))
    end

    if mode ~= "effects" then
        for index, statDef in ipairs (statsToShow[mode]) do
            -- Icon
            tux.show.button ({
                colors = {1, 0, 0, 1},
                image = statDef.icon,
                iscale = 1.65,
            }, layout:down (36, 36))

            -- Text
            tux.show.label ({
                text = statDef.name .. ": " .. nutObj[statDef.id],
                align = "left",
                colors = {1, 0, 0, 1},
                fsize = 28,
            }, layout:right (350, 36))
        end
    end

    -- Background
    tux.show.label ({
        text = "Nut Info",
        valign = "top",
        padding = {padAll = 5}
    }, x, y, compW, compH)

    return mode
end

return nutStats