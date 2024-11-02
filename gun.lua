local gun = {}

local nut = require("Core.Nut")
local inventoryHandler = require("Core.inventoryHandler")
local ProjectileManager = require("projectile")

gun.mag = {} -- mag loads itself with the active inventory slot
gun.magSize = 50

function gun:update()

    -- Fire the gun
    if love.mouse.isDown(1) then
        gun:shoot(love.mouse.getPosition())
    end

    -- Reload the gun
    if love.keyboard.isDown("r") then
        gun:loadMag()
    end

    -- TEST ** adds nut to section 1 of inventory
    if love.keyboard.isDown("space") then
        inventoryHandler:addNut(nut:new())
    end
end

function gun:shoot(x, y)

    if #gun.mag > 0 then

        -- Shoot the nut
        ProjectileManager:add(Player.x, Player.y, x, y, gun.mag[1])

        -- Get rid of the nut in the mag
        table.remove(gun.mag, 1)
    end
end

function gun:loadMag() -- Loads the mag with the selected inventory section

    local activeSection = inventoryHandler.sections[inventoryHandler.activeSection]
    while #gun.mag < gun.magSize do
        if #activeSection > 0 then
            table.insert(gun.mag, activeSection[1])
            table.remove(activeSection, 1)
        else
            break
        end
    end
end

return gun