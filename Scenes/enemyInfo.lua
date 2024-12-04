local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local loadAnimationFrames = require ("Helpers.loadAnimationFrames")
local processAnimation = require ("Helpers.processAnimation")
local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")

local enemyInfo = {
    {
        name = "Basic Nut",
        seriousDesc = "Walks toward you... menacingly.",
        funnyDesc = "Just a regular nut off the ol' nut tree. He's not really evil, but the job pays well enough and he REALLY needs those dental benefits for his kid's braces.",
        sprites = loadAnimationFrames ("Graphics/enemies/Basic"),
    },
    {
        name = "Small Nut",
        seriousDesc = "Runs toward you at high speed. Is hard to spot due to his size.",
        funnyDesc = "This little guy developed a hatred toward the world after realizing that pine nuts aren't actually nuts. His gang of little homies will cut you down to size if you aren't careful!",
        sprites = loadAnimationFrames ("Graphics/enemies/Small"),
    },
    {
        name = "Armored Nut",
        seriousDesc = "Starts with a tough shell. Once cracked, he will either run toward you in a blind rage or run away in fear.",
        funnyDesc = "Some say the eyes are the window to the soul. \"Well, personally,\" says the armored nut, \"I'd rather you didn't see much of me at all.\" He always eats alone at lunch...",
        sprites = loadAnimationFrames ("Graphics/enemies/Armored Normal"),
    },
    {
        name = "Witch Nut",
        seriousDesc = "A fast and rare enemy that may take you by surprise.",
        funnyDesc = "No one knows where she came from or who she used to be. All her peers know is that she reeks of the dead and her views are \"of a different time.\"",
        sprites = loadAnimationFrames ("Graphics/enemies/Witch"),
    },
    {
        name = "Screecher Nut",
        seriousDesc = "Occasionally stops moving to scream, which will spawn more enemies.",
        funnyDesc = "Despite how he may look, the screaming thing is entirely an act. This kooky nut is actually a well-renowned philosopher and progressive nut politician, fighting for the rights of his fellow nuts in congress.",
        sprites = loadAnimationFrames ("Graphics/enemies/Screecher Closed"),
    },
}
local animateObj = {
    frame = 1,
    frameTimer = 0,
}
local page = 1

function thisScene:update (dt)
    local currEnemyInfo = enemyInfo[page]

    processAnimation (dt, animateObj, #enemyInfo[page].sprites, 0.2)
    local currentFrame = enemyInfo[page].sprites[animateObj.frame]

    layout:setParent (0, 0, GAMEWIDTH, GAMEHEIGHT)
    local centeredPos = {layout:center (800, 800)}
    local x, y = centeredPos[1], centeredPos[2]
    
    layout:setOrigin (x + 15, y + 75, 10, 5)

    -- Enemy animation
    tux.show.label ({
        image = currentFrame,
        iscale = 6,
    }, layout:down (760, 250))

    -- Serious description
    tux.show.label ({
        text = currEnemyInfo.seriousDesc,
        align = "left",
        colors = {0, 0, 0, 0},
        padding = {padAll = 10, padTop = 10}
    }, layout:down (760, 150))

    -- Funny description
    tux.show.label ({
        text = currEnemyInfo.funnyDesc,
        align = "left",
        colors = {0, 0, 0, 0},
        padding = {padAll = 10, padTop = 10}
    }, layout:down (760, 250))

    -- Background
    tux.show.label ({
        text = currEnemyInfo.name,
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
        page = math.min (#enemyInfo, page + 1)
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