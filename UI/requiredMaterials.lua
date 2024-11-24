local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")
local inventoryHandler = require ("Core.inventoryHandler")

-- TODO: Replace the buildable data with actual buildables, or at least their images/IDs
local testCraftingData = {
    {"Wood", 10},
    {"Fiber", 25},
    {"Shells", 7},
}

local compW, compH = 435, 500

local function buildMenu (x, y)
    local selectedBuild = nil

    -- Iterate over nut stats
    layout:setOrigin (x + 15, y + 50, 10, 10)

    -- Core stats
    for index, materialPair in ipairs (testCraftingData) do
        -- Icon
        tux.show.button ({
            colors = {1, 0, 0, 1},
            image = icons.inverseStar,
            iscale = 1.65,
        }, layout:down (36, 36))

        -- Text
        tux.show.label ({
            text = materialPair[1] .. ": " .. materialPair[2] .. " (200)",
            align = "left",
            colors = {1, 0, 0, 1},
            fsize = 28,
        }, layout:right (350, 36))
    end

    -- Background
    tux.show.label ({
        text = "Required Materials",
        valign = "top",
        padding = {padAll = 5}
    }, x, y, compW, compH)

    return selectedBuild
end

return buildMenu