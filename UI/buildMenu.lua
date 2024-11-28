local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")
local inventoryHandler = require ("Core.newInventoryHandler")

-- TODO: Replace the buildable data with actual buildables, or at least their images/IDs
local buildablesToShow = {
    {
        name = "Test",
        desc = "This is what the buildable does!",
        iscale = 4,
        buildable = {
            frame = icons.save
        }
    },
    {
        name = "Brush Building",
        desc = "It does da paintin stuff",
        iscale = 4,
        buildable = {
            frame = icons.brush
        }
    },
    {
        name = "Discord Tower",
        desc = "We don't have a discord server lol",
        iscale = 4,
        buildable = {
            frame = icons.discord
        }
    },
}

local compW, compH = 435, 500

local page = 1
local maxPage = #buildablesToShow

local function buildMenu (x, y)
    local selectedBuild = nil

    -- Page buttons
    if tux.show.button ({
        text = "<<",
        fsize = 28,
    }, x + 50, y + 440, 100, 50) == "end" then
        page = math.max (1, page - 1)
    end

    if tux.show.button ({
        text = ">>",
        fsize = 28,
    }, x + compW - 150, y + 440, 100, 50) == "end" then
        page = math.max (math.min (maxPage, page + 1), 1)
    end

    -- Page number
    layout:setParent (x, y, compW, compH)
    local centeredPos = {layout:center (compW, 0)}
    layout:setOrigin (centeredPos[1], y + 440, 0, 0)

    tux.show.label ({
        text = page .. " / " .. math.max (1, maxPage),
        colors = {0, 0, 0, 0}
    }, layout:right (compW, 50))

    -- Buildable item info
    layout:setParent (x, y, compW, compH)
    local centeredPos = {layout:center (400, 0)}
    layout:setOrigin (centeredPos[1], y + 50, 0, 0)

    -- Buildable image
    tux.show.label ({
        image = buildablesToShow[page].buildable.frame,
        iscale = buildablesToShow[page].iscale,
        colors = {0.85, 0.85, 1, 1},
    }, layout:down (400, 150))

    -- Buildable name
    tux.show.label ({
        text = buildablesToShow[page].name,
        fsize = 32,
        colors = {0, 0, 0, 0},
        padding = {padX = 5},
    }, layout:down (400, 40))

    -- Buildable description
    tux.show.label ({
        text = buildablesToShow[page].desc,
        fsize = 22,
        colors = {0, 0, 0, 0},
        padding = {padX = 5, padTop = 10},
        align = "left",
        valign = "top",
    }, layout:down (400, 200))

    -- Action buttons
    layout:setOrigin (x + compW, y, 5, 10)

    -- Select
    if tux.show.button ({
        image = icons.confirm,
        iscale = 2,
        tooltip = {
            text = "Select buildable"
        },
    }, layout:right (75, 75)) == "end" then
        print (buildablesToShow[page].name)
        selectedBuild = buildablesToShow[page].buildable
    end

    -- Background
    tux.show.label ({
        text = "Buildables",
        valign = "top",
        padding = {padAll = 5}
    }, x, y, compW, compH)

    return selectedBuild
end

return buildMenu