local Nut = require ("Core.Nut")
local buildableManager = require ("Core.buildableManager")

local baseNuts = {}

buildableManager:create ("peanut", {})

baseNuts.peanut = buildableManager:generate ("peanut")
baseNuts.walnut = buildableManager:generate ("peanut")
baseNuts.acorn = buildableManager:generate ("peanut")
baseNuts.pecan = buildableManager:generate ("peanut")

return baseNuts