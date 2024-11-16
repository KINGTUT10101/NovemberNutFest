local Nut = require ("Core.Nut")

local NutPlant = {
    firstParent = nil, -- Stores up to two nuts
    childNut = nil, -- Stores the cross-bred nut
    growth = 0,
}

-- Returns true if the nutObj was added to the buildable successfully
function NutPlant:addNut (nutObj, tileObj)
    assert (nutObj ~= nil, "Nut object not provided")
    assert (tileObj ~= nil, "Tile object not provided")

    -- Check if final nut has been calulcated yet
    if self.childNut == nil then
        -- Check how many parents have been planted
        if self.firstParent ~= nil then
            -- Define first parent
            self.firstParent = nutObj
        else
            -- Combine parents to form child
            self.childNut = Nut:new (self.parentNuts[1], self.parentNuts[2], tileObj)
            self.firstParent = nil
        end

        return true
    else
        return false
    end
end

function NutPlant:update (dt)
    self.growth = self.growth + dt

    if self.growth > self.childNut.growthTime then
        -- TODO: Set frame to full grown plant
    end
end

return NutPlant