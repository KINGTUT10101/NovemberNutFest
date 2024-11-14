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
    projSpeed = 5,
    projSize = 4,
    range = 11,
    knockback = 4,
    magSize = 1,
    spread = 0,
    growthTime = 18000, -- Ticks
    cropYeild = 8,
    cropYeildVar = 3, -- How much extra/fewer nuts you get when harvesting
    type = "nut"
}

baseNuts.coconut = {
    damage = 15,
    projSpeed = 3,
    projSize = 4,
    range = 8,
    knockback = 4,
    magSize = 2,
    spread = 0,
    growthTime = 18000, -- Ticks
    cropYeild = 8,
    cropYeildVar = 3, -- How much extra/fewer nuts you get when harvesting
    type = "nut"
}

baseNuts.almond = {
    damage = 7,
    projSpeed = 5,
    projSize = 4,
    range = 11,
    knockback = 4,
    magSize = 1,
    spread = 0,
    growthTime = 18000, -- Ticks
    cropYeild = 8,
    cropYeildVar = 3, -- How much extra/fewer nuts you get when harvesting
    specialEffects = {"pierce"},
    type = "nut"
}

baseNuts.candleNut = {
    damage = 4,
    projSpeed = 4,
    projSize = 4,
    range = 11,
    knockback = 4,
    magSize = 1,
    spread = 0,
    growthTime = 18000, -- Ticks
    cropYeild = 8,
    cropYeildVar = 3, -- How much extra/fewer nuts you get when harvesting
    specialEffects = {"fire"},
    type = "nut"
}


buildableManager:create ("peanut", {
    damage = 5,
    projSpeed = 200,
    projSize = 4,
    range = 500,
    knockback = 4,
    magSize = 1,
    spread = 0,
    growthTime = 18000, -- Ticks
    cropYeild = 8,
    cropYeildVar = 3, -- How much extra/fewer nuts you get when harvesting
    frame = nutPlantImg,
})

baseNuts.peanut = buildableManager:generate ("peanut")
baseNuts.walnut = buildableManager:generate ("peanut")
baseNuts.acorn = buildableManager:generate ("peanut")
baseNuts.pecan = buildableManager:generate ("peanut")


return baseNuts