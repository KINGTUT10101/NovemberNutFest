local Nut = require ("Core.Nut")
local buildableManager = require ("Core.buildableManager")

local baseNuts = {}

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
})

baseNuts.peanut = buildableManager:generate ("peanut")
baseNuts.walnut = buildableManager:generate ("peanut")
baseNuts.acorn = buildableManager:generate ("peanut")
baseNuts.pecan = buildableManager:generate ("peanut")

return baseNuts