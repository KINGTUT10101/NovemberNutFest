local numSections = 9

Throwables = {}
Consumables = {}


local inventoryHandler = {
    currentStorage = 0,
    maxStorage = 500,
    sections = {}, -- Array of queues that store nut objects
    activeSection = 1,
}

-- Set up inventory sections
for i = 1, numSections do
    inventoryHandler.sections[i] = {}
end

function inventoryHandler:setActiveSection (section)
    assert (section >= 1 and section <= numSections, "Section index is out of bounds")

    self.activeSection = section
end

function inventoryHandler:addNut (nutObj)
    -- Check if there is space
    if self.currentStorage + nutObj.invSize > self.maxStorage then
        return false
    else
        local sectionObj = self.sections[self.activeSection]

        sectionObj[#sectionObj+1] = nutObj

        self.currentStorage = self.currentStorage + nutObj.invSize

        return true
    end
end

function inventoryHandler:getStorageLevels ()
    local storageLevels = {}

    for i = 1, #self.sections do
        storageLevels[i] = #self.sections[i]
    end

    return storageLevels
end

-- Deletes the nut at the front of the active section
-- Not a sex joke, I swear
function inventoryHandler:consumeNut ()
    local sectionObj = self.sections[self.activeSection]

    if sectionObj[1] == nil then
        return false
    else
        local nutObj = sectionObj[1]
        
        self.currentStorage = self.currentStorage - nutObj.invSize
        table.remove (sectionObj, 1)

        return nutObj
    end
end

function inventoryHandler:dropNut (sectionNum, index)
    assert (sectionNum >= 1 and sectionNum <= numSections, "Section index is out of bounds")
    
    local section = self.sections[sectionNum]
    
    assert (index >= 1 and index <= #section, "Item index is out of bounds")

    local nutObj = section[index]

    self.currentStorage = self.currentStorage - nutObj.invSize
    table.remove (section, index)


    return nutObj
end

-- function inventoryHandler:swapNut (oldSection, oldIndex, newSection, newIndex)
    
-- end

-- Items
function inventoryHandler:addItem(object)

    if object.type == "throwable" then
        table.insert(Throwables, object)
    elseif object.type == "consumable" then
        table.insert(Consumables, object)
    else
        error(object.type .. " is ont a valid object type.")
    end
end

function inventoryHandler:addConsumeable(object)

    table.insert(Consumables, object)
end

return inventoryHandler