local Nut = require ("Core.Nut")
local buildableManager = require ("Core.buildableManager")

local nutPlantImg = love.graphics.newImage ("Graphics/Plants/nutPlant.png")

local baseNuts = {}

--[[
    Special Effects:
        pierce - nut can peirce through two enemies
        fire - sets enemies on fire
--]]

baseNuts.peanut = {
    damage = 10,
    projVelocity = 5,
    projSize = 4,
    range = 11,
    knockback = 4,
    magSize = 1,
    spread = 0,
    growthTime = 18000, -- Ticks
    cropYeild = 8,
    cropYeildVar = 3, -- How much extra/fewer nuts you get when harvesting
    specialEffects = {"hyperburst"}, -- Less time between this nut and the next nut shot
    class = "nut",
    type = "peanut"
}

baseNuts.coconut = {
    damage = 15,
    projVelocity = 3,
    projSize = 4,
    range = 8,
    knockback = 4,
    magSize = 2,
    spread = 0,
    growthTime = 18000, -- Ticks
    cropYeild = 8,
    cropYeildVar = 3, -- How much extra/fewer nuts you get when harvesting
    specialEffects = {"stun"},
    class = "nut",
    type = "coconut"
}

baseNuts.macadamia = {
    damage = 5,
    projVelocity = 10,
    projSize = 2,
    range = 7,
    knockback = 2,
    mapdSize = 2,
    spread = 0,
    growthTime = 18000, -- Ticks
    cropYeild = 8,
    cropYeildVar = 3, -- How much extra/fewer nuts you get when harvesting
    class = "nut",
    type = "macadamia"
}


baseNuts.almond = {
    damage = 7,
    projVelocity = 5,
    projSize = 4,
    range = 11,
    knockback = 4,
    magSize = 1,
    spread = 0,
    growthTime = 18000, -- Ticks
    cropYeild = 8,
    cropYeildVar = 3, -- How much extra/fewer nuts you get when harvesting
    specialEffects = {"pierce"},
    class = "nut",
    type = "almond"
}

baseNuts.candleNut = {
    damage = 4,
    projVelocity = 4,
    projSize = 4,
    range = 11,
    knockback = 4,
    magSize = 1,
    spread = 0,
    growthTime = 18000, -- Ticks
    cropYeild = 8,
    cropYeildVar = 3, -- How much extra/fewer nuts you get when harvesting
    specialEffects = {"fire"},
    class = "nut",
    type = "candle"
}

baseNuts.pine = {
    damage = 4,
    projVelocity = 4,
    projSize = 4,
    range = 11,
    knockback = 4,
    magSize = 1,
    spread = 0,
    growthTime = 18000, -- Ticks
    cropYeild = 8,
    cropYeildVar = 3, -- How much extra/fewer nuts you get when harvesting
    specialEffects = {"freeze"},
    class = "nut",
    type = "pine"
}

-- This is for debugging
baseNuts.deathNut = {
    damage = 10,
    projVelocity = 6,
    projSize = 4,
    range = 11,
    knockback = 4,
    magSize = 1,
    spread = 0,
    growthTime = 18000, -- Ticks
    cropYeild = 8,
    cropYeildVar = 3, -- How much extra/fewer nuts you get when harvesting
    specialEffects = {"pierce"},
    class = "nut",
    type = "peanut"
}

return baseNuts