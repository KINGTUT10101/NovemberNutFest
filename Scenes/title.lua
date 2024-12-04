local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")
local musicManager =require ("Core.musicManager")

local logoImg = love.graphics.newImage ("Graphics/Logos/nutPlantLarge.png")

function thisScene:whenAdded (...)
    musicManager:switchScene ("title")
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
    if tux.show.button ({
        text = "New Game"
    }, layout:down (580, 100)) == "end" then
        sceneMan:clearStack ()
        sceneMan:push("backgroundMap")
        sceneMan:push("gameMenu")
        sceneMan:push("game")
    end

    if tux.show.button ({
        text = "Enemies"
    }, layout:down (580, 100)) == "end" then
        sceneMan:clearStack ()
        sceneMan:push("enemyInfo")
    end

    if tux.show.button ({
        text = "Credits"
    }, layout:down (580, 100)) == "end" then
        sceneMan:clearStack ()
        sceneMan:push("credits")
    end

    if tux.show.button ({
        text = "Exit"
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
        love.system.openURL ("https://www.youtube.com/@Lyrith-Games")
    end

    if tux.show.button ({
        text = "",
        image = icons.twitter,
        iscale = 3,
        colors = {0, 0, 0, 0},
    }, layout:right (100, 100)) == "end" then
        love.system.openURL ("https://x.com/LyrithGames")
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