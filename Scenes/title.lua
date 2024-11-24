local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")

local logoImg = love.graphics.newImage ("Graphics/Logos/nutPlantLarge.png")

function thisScene:load (...)
    sceneMan = ...
    
end

function thisScene:delete (...)
    local args = {...}
    
end

function thisScene:update (dt)
    layout:setParent (0, 0, GAMEWIDTH, GAMEHEIGHT)
    local centeredPos = {layout:center (580, 0)}
    layout:setOrigin (centeredPos[1], 0, 0, 15)
    
    -- Logo
    tux.show.label ({
        image = logoImg,
        iscale = 2,
        colors = {0, 0, 0, 0},
    }, layout:right (580, 400))

    -- Menu buttons
    tux.show.button ({
        text = "NEW GAME"
    }, layout:down (580, 100))

    tux.show.button ({
        text = "CREDITS"
    }, layout:down (580, 100))

    tux.show.button ({
        text = "SETTINGS"
    }, layout:down (580, 100))

    if tux.show.button ({
        text = "EXIT"
    }, layout:down (580, 100)) == "end" then
        love.event.quit ()
    end

    -- Social media buttons
    local centeredPos = {layout:center (220, 0)}
    layout:setOrigin (centeredPos[1] - 10, 925, 20, 15)

    if tux.show.button ({
        text = "",
        image = icons.youtube,
        iscale = 3,
        colors = {0, 0, 0, 0},
    }, layout:right (100, 100)) == "end" then
        
    end

    if tux.show.button ({
        text = "",
        image = icons.twitter,
        iscale = 3,
        colors = {0, 0, 0, 0},
    }, layout:right (100, 100)) == "end" then
        
    end
end

function thisScene:draw ()
    -- Background (TEMP)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.rectangle ("fill", 0, 0, GAMEWIDTH, GAMEHEIGHT)

    -- Menu background
    layout:setParent (0, 0, GAMEWIDTH, GAMEHEIGHT)
    love.graphics.setColor(0, 0, 0, 0.35)
    love.graphics.rectangle ("fill", layout:center (750, 1080))
end

function thisScene:lateDraw ()
    
end

function thisScene:keypressed (key, scancode, isrepeat)
	
end

function thisScene:mousereleased (x, y, button)

end

return thisScene