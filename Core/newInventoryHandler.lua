local clamp = require ("Libraries.lume").clamp

local inventoryHandler = {
    hotbar = {}, -- Holds the nuts in the player's inventory
    size = 0, -- Number of nuts in the inventory
    maxSlots = 10, -- Max number of hotbar slots
    maxAmmmo  = 500, -- Max amount of ammo
    currAmmo = 0, -- Current amount of ammo
    activeSlot = 1, -- Currently selected hotbar slot
}

function inventoryHandler:getActiveSlot ()
    return self.activeSlot
end

function inventoryHandler:setActiveSlot (hotbarIndex)
    assert (hotbarIndex >= 1 and hotbarIndex <= self.maxSlots, "Hotbar index out of bounds")

    self.activeSlot = hotbarIndex
end

function inventoryHandler:replaceNut (nutObj, hotbarIndex)
    assert (type (nutObj) == "table", "Provided nut object is an invalid data type")
    assert (hotbarIndex >= 1 and hotbarIndex <= self.maxSlots, "Hotbar index out of bounds")

    if self.hotbar[hotbarIndex] == nil then
        self.size = self.size + 1
    end

    self.hotbar[hotbarIndex] = nutObj
end

function inventoryHandler:removeNut (hotbarIndex)
    assert (hotbarIndex >= 1 and hotbarIndex <= self.maxSlots, "Hotbar index out of bounds")

    if self.hotbar[hotbarIndex] ~= nil then
        self.size = self.size - 1
    end

    self.hotbar[hotbarIndex] = nil
end

function inventoryHandler:getNut (hotbarIndex)
    assert (hotbarIndex >= 1 and hotbarIndex <= self.maxSlots, "Hotbar index out of bounds")

    return self.hotbar[hotbarIndex]
end

function inventoryHandler:getAmmoCount ()
    return self.currAmmo
end

function inventoryHandler:setAmmoCount (amount)
    self.currAmmo = clamp (amount, 0, self.maxAmmmo)
end

function inventoryHandler:addAmmoCount (amount)
    self.currAmmo = clamp (self.currAmmo + amount, 0, self.maxAmmmo)
end

return inventoryHandler