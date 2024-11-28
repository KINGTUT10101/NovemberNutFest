-- These are not actual nut objects
-- They are blueprints that should be used with the Nut class to make actual nut objects
local baseNuts = {}

--[[
    Special Effects:
        pierce - nut can peirce through two enemies
        fire - sets enemies on fire
--]]

baseNuts.peanut = {
    name = "Peanut",
    image = love.graphics.newImage ("Graphics/Nuts/peanut.png"),

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
    type = "peanut",
    ancestry = {peanut = 1},
}

baseNuts.coconut = {
    name = "Coconut",
    image = love.graphics.newImage ("Graphics/Nuts/coconut.png"),

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
    type = "coconut",
    ancestry = {coconut = 1},
}

baseNuts.macadamia = {
    name = "Macadamia Nut",
    image = love.graphics.newImage ("Graphics/Nuts/macadamia.png"),

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
    type = "macadamia",
    ancestry = {macadamia = 1},
}


baseNuts.almond = {
    name = "Almond",
    image = love.graphics.newImage ("Graphics/Nuts/almond.png"),

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
    type = "almond",
    ancestry = {almond = 1},
}

baseNuts.candle = {
    name = "Candlenut",
    image = love.graphics.newImage ("Graphics/Nuts/candlenut.png"),

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
    type = "candle",
    ancestry = {candleNut = 1},
}

baseNuts.pine = {
    name = "Pine Nut",
    image = love.graphics.newImage ("Graphics/Nuts/pinenut.png"),

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
    type = "pine",
    ancestry = {pine = 1},
}

-- This is for debugging
baseNuts.deathNut = {
    name = "Coconut",
    image = love.graphics.newImage ("Graphics/Nuts/coconut.png"),

    damage = 100,
    projVelocity = 6,
    projSize = 4,
    range = 11,
    knockback = 4,
    magSize = 1,
    spread = 0,
    growthTime = 18000, -- Ticks
    cropYeild = 8,
    cropYeildVar = 3, -- How much extra/fewer nuts you get when harvesting
    specialEffects = {"pierce", "hyperburst", "stun"},
    class = "nut",
    type = "peanut",
    ancestry = {deathNut = 1},
}

return baseNuts