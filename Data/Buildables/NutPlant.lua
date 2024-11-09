local Nut = require ("Core.Nut")

local NutPlant = {
    nuts = {}, -- Stores up to two nuts
    finalNut = nil, -- Stores the cross-bred nut
    growth = 0,
}

function NutPlant:addNut (nutObj, tileObj)
    assert (nutObj ~= nil, "Nut object not provided")
    assert (tileObj ~= nil, "Tile object not provided")

    if self.finalNut == nil then
        self.nuts[#self.nuts+1] = nutObj
    else
        self.finalNut = Nut:new (self.nuts[1], self.nuts[2], tileObj)
        self.nuts = nil
    end
end

function NutPlant:update (dt)
    self.growth = self.growth + dt

    if self.growth > self.finalNut.growthTime then
        -- TODO: Set frame to full grown plant
    end
end

return NutPlant