-- These are not actual nut objects
-- They are blueprints that should be used with the Nut class to make actual nut objects
local baseNuts = {}


baseNuts.peanut = {
    name = "Peanut",
    image = love.graphics.newImage ("Graphics/Nuts/peanut.png"),

    damage = 8,
    projVelocity = 12,
    projSize = 4,
    range = 8,
    knockback = 4,
    magSize = 1,
    spread = 0,
    growthTime = 18000, -- Ticks
    cropYeild = 8,
    cropYeildVar = 3, -- How much extra/fewer nuts you get when harvesting
    specialEffects = {{"hyperburst", 1}}, -- Less time between this nut and the next nut shot
    class = "nut",
    type = "peanut",
    ancestry = {peanut = 1},
}

baseNuts.coconut = {
    name = "Coconut",
    image = love.graphics.newImage ("Graphics/Nuts/coconut.png"),

    damage = 15,
    projVelocity = 3,
    projSize = 10,
    range = 4,
    knockback = 4,
    magSize = 2,
    spread = 0,
    growthTime = 18000, -- Ticks
    cropYeild = 8,
    cropYeildVar = 3, -- How much extra/fewer nuts you get when harvesting
    specialEffects = {{"stun", 1}},
    class = "nut",
    type = "coconut",
    ancestry = {coconut = 1},
}

baseNuts.macadamia = {
    name = "Macadamia Nut",
    image = love.graphics.newImage ("Graphics/Nuts/macadamia.png"),

    damage = 6,
    projVelocity = 18,
    projSize = 2,
    range = 12,
    knockback = 2,
    mapdSize = 2,
    spread = 0,
    growthTime = 18000, -- Ticks
    cropYeild = 8,
    cropYeildVar = 3, -- How much extra/fewer nuts you get when harvesting
    specialEffects = {{"confusion", 1}}, -- Makes the enemy move away from the player
    class = "nut",
    type = "macadamia",
    ancestry = {macadamia = 1},
}


baseNuts.almond = {
    name = "Almond",
    image = love.graphics.newImage ("Graphics/Nuts/almond.png"),

    damage = 6,
    projVelocity = 22,
    projSize = 4,
    range = 15,
    knockback = 4,
    magSize = 1,
    spread = 0,
    growthTime = 18000, -- Ticks
    cropYeild = 8,
    cropYeildVar = 3, -- How much extra/fewer nuts you get when harvesting
    specialEffects = {{"pierce", 1}},
    class = "nut",
    type = "almond",
    ancestry = {almond = 1},
}

baseNuts.candle = {
    name = "Candlenut",
    image = love.graphics.newImage ("Graphics/Nuts/candlenut.png"),

    damage = 4,
    projVelocity = 3,
    projSize = 4,
    range = 11,
    knockback = 2,
    magSize = 1,
    spread = 0,
    growthTime = 18000, -- Ticks
    cropYeild = 8,
    cropYeildVar = 3, -- How much extra/fewer nuts you get when harvesting
    specialEffects = {{"fire", 1}},
    class = "nut",
    type = "candle",
    ancestry = {candle = 1},
}

baseNuts.pine = {
    name = "Pine Nut",
    image = love.graphics.newImage ("Graphics/Nuts/pinenut.png"),

    damage = 7,
    projVelocity = 4,
    projSize = 4,
    range = 7,
    knockback = 4,
    magSize = 1,
    spread = 0,
    growthTime = 18000, -- Ticks
    cropYeild = 8,
    cropYeildVar = 3, -- How much extra/fewer nuts you get when harvesting
    specialEffects = {{"freeze", 1}},
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
    specialEffects = {{"pierce", 1}, {"hyperburst", 1}, {"stun", 1}},
    class = "nut",
    type = "peanut",
    ancestry = {deathNut = 1},
}

return baseNuts