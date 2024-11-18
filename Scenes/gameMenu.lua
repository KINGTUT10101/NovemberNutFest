local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")

function thisScene:load (...)
    sceneMan = ...
    
end

function thisScene:update (dt)
    -- HOTBAR
    layout:setParent (0, 0, GAMEWIDTH, GAMEHEIGHT)
    local centeredPos = {layout:center (750, 0)}
    layout:setOrigin (centeredPos[1], 995, 0, 15)

    for i = 1, 10 do
        if tux.show.button ({

        }, layout:right (75, 75)) == "end" then
            
        end
    end

    -- HEALTHBAR
    local centeredPos = {layout:center (750, 0)}
    layout:setOrigin (centeredPos[1], 955, 0, 15)

    local healthPercent = 0.65 -- TEMP
    tux.show.label ({
        colors = {1, 0, 0, 1}
    }, layout:right (750 * healthPercent, 36))

    local centeredPos = {layout:center (750, 0)}
    layout:setOrigin (centeredPos[1], 955, 0, 15)

    tux.show.label ({
        colors = {0, 0, 0, 1}
    }, layout:right (750, 36))

    -- SECTION INFO
    local centeredPos = {layout:center (750, 0)}
    layout:setOrigin (centeredPos[1], 900, 0, 15)

    tux.show.label ({
        text = "(3) One-shot - 23 / 250"
    }, layout:right (750, 50))

    -- Side quantities
    layout:setOrigin (15, 850, 15, 5)

    tux.show.button ({
        colors = {1, 0, 0, 1},
        image = icons.extinguisher,
        iscale = 1.65,
    }, layout:down (50, 50))
    tux.show.label ({
        text = "(Q) 7 / 10",
        align = "left",
        colors = {1, 0, 0, 1}
    }, layout:right (350, 50))

    tux.show.button ({
        colors = {1, 0, 0, 1},
        image = icons.inverseStar,
        iscale = 1.65,
    }, layout:down (50, 50))
    tux.show.label ({
        text = "(E) 4 / 5",
        align = "left",
        colors = {1, 0, 0, 1}
    }, layout:right (350, 50))

    
    tux.show.button ({
        colors = {1, 0, 0, 1},
        image = icons.person,
        iscale = 1.65,
    }, layout:down (50, 50))
    tux.show.label ({
        text = "(I) 147 / 250",
        align = "left",
        colors = {1, 0, 0, 1}
    }, layout:right (350, 50))

    tux.show.button ({
        colors = {1, 0, 0, 1},
        image = icons.brush,
        iscale = 1.65,
    }, layout:down (50, 50))
    tux.show.label ({
        text = "(R) Destroy",
        align = "left",
        colors = {1, 0, 0, 1}
    }, layout:right (350, 50))

    -- AREA INFO
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
        text = "Desert Biome (N)",
        align = "right",
        colors = {1, 0, 0, 1}
    }, layout:left (350, 50))

    tux.show.button ({
        colors = {1, 0, 0, 1},
        image = icons.news,
        iscale = 1.65,
    }, layout:down (50, 50, false))
    tux.show.label ({
        text = "(1053, 164) (M)",
        align = "right",
        colors = {1, 0, 0, 1}
    }, layout:left (350, 50))

    -- WAVE STATUS
    local centeredPos = {layout:center (800, 0)}
    layout:setOrigin (centeredPos[1], 75, 0, 15)

    local healthPercent = 0.65 -- TEMP
    tux.show.label ({
        colors = {1, 0, 0, 1}
    }, layout:right (800 * healthPercent, 36))

    local centeredPos = {layout:center (800, 0)}
    layout:setOrigin (centeredPos[1], 75, 0, 15)

    tux.show.label ({
        colors = {0, 0, 0, 1}
    }, layout:right (800, 36))

    local centeredPos = {layout:center (850, 0)}
    layout:setOrigin (centeredPos[1], 0, 0, 15)

    tux.show.label ({
        text = "Wave Progress",
        fsize = 48,
        padding = {padTop = 5},
        valign = "top"
    }, layout:right (850, 125))
end

function thisScene:draw ()
    
end

function thisScene:lateDraw ()
    
end

function thisScene:keypressed (key, scancode, isrepeat)
	
end

function thisScene:mousereleased (x, y, button)

end

return thisScene