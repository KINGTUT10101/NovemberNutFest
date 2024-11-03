local gun = {}

local nut = require("Core.Nut")
local inventoryHandler = require("Core.inventoryHandler")
local ProjectileManager = require("projectile")

gun.mag = {} -- mag loads itself with the active inventory slot
gun.magSize = 50
gun.cooldownFrames = .1*60 -- half a second
gun.cooldownTimer = 0

function gun:update()

    -- Lower the cooldown timer
    if self.cooldownTimer > 0 then
        self.cooldownTimer = self.cooldownTimer - 1
    end

    -- Fire the gun
    if love.mouse.isDown(1) then
        -- This takes account for the game size being different from the window's
        gun:shoot(love.mouse.getX()/1.333, love.mouse.getY()/1.333)
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

    if #self.mag > 0 and self.cooldownTimer <= 0 then

        -- Shoot the nut
        ProjectileManager:add(Player.x, Player.y, x, y, gun.mag[1])
        self.cooldownTimer = self.cooldownFrames
        
        -- Get rid of the nut in the mag
        table.remove(gun.mag, 1)
    end
end

function gun:loadMag() -- Loads the mag with the selected inventory section

    local activeSection = inventoryHandler.sections[inventoryHandler.activeSection]
    while #gun.mag < gun.magSize do
        if #activeSection > 0 then
            table.insert(gun.mag, activeSection[1])
            inventoryHandler:consumeNut()
        else
            break
        end
    end
end

return gun