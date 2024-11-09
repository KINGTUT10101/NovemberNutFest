local baseNuts = {}

--[[
    Special Effects:
        pierce - nut can peirce through two enemies
        fire - sets enemies on fire
--]]

baseNuts.peanut = {
    damage = 5,
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
    specialEffects = {"pierce"},
    type = "nut"
}

return baseNuts