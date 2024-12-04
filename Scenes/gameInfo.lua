local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local loadAnimationFrames = require ("Helpers.loadAnimationFrames")
local processAnimation = require ("Helpers.processAnimation")
local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")

local tips = {
    "Clear 15 enemies per wave as fast as you can! Press the left mouse button to shoot.",
    "You can breed two nuts together after every wave to improve your arsenal. The child nut will share traits from each parent.",
    "Keep an eye on your nuts' levels! The higher the level, the greater your nut's base stats will be boosted.",
    "Each BASE nut starts at level 1 and has a unique effect. Try out different combos to see what works best!",
    "Enemies will occasionally drop cashew apples and nut oil when they're defeated. Use these to your advantage to gain the upper hand!",
    "Press (Q) to consume a cashew apple and heal yourself. Press (E) to throw a bottle of nut oil.",
    "Nut oil will give you a combat boost! It will increase your damage against affected enemies and spread the fire effect (although this will remove the nut oil effect).",
    "Enemies may also drop powerups that give you a temporary speed or damage boosts.",
    "And of course, press (I) to view more information about the currently selected nut while you're in combat.",
    "That's about it. Now have fun!",
    "Alright listen, I'm not made out of tips. If you want more, go play the game and make them up yourself!",
    "...",
}
local page = 1

function thisScene:whenAdded ()
    page = 1
end

function thisScene:update (dt)
    layout:setParent (0, 0, GAMEWIDTH, GAMEHEIGHT)
    local centeredPos = {layout:center (800, 800)}
    local x, y = centeredPos[1], centeredPos[2]

    -- Enemy animation
    tux.show.label ({
        text = tips[page],
        colors = {0, 0, 0, 0},
        padding = {padAll = 15, padTop = 15},
    }, x, y + 50, 800, 800 - 50)

    -- Background
    tux.show.label ({
        text = "How to Play",
        valign = "top",
        fsize = 48,
        padding = {padAll = 10, padTop = 10}
    }, x, y, 800, 800)

    -- Page buttons
    layout:setOrigin (x, y + 815, 0, 5)

    if tux.show.button ({
        text = "<<",
        fsize = 28,
    }, layout:right (200, 100)) == "end" then
        page = math.max (1, page - 1)
    end

    layout:setOrigin (x + 800, y + 815, 0, 5)
    if tux.show.button ({
        text = ">>",
        fsize = 28,
    }, layout:left (200, 100)) == "end" then
        page = math.min (#tips, page + 1)
    end

    -- Back button
    layout:setParent (0, 0, GAMEWIDTH, GAMEHEIGHT)
    local centeredPos = {layout:center (200, 100)}
    
    if tux.show.button ({
        text = "Back",
    }, centeredPos[1], y + 815, 200, 100) == "end" then
        sceneMan:clearStack ()
        sceneMan:push ("title")
    end
end

function thisScene:keypressed (key, scancode, isrepeat)
	
end

function thisScene:mousereleased (x, y, button)

end

return thisScene