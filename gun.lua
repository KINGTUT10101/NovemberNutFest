local gun = {}

local nut = require("Core.Nut")
local inventoryHandler = require("Core.inventoryHandler")
local ProjectileManager = require("Managers.projectile")
local ItemManager = require("Managers.item")
local baseNuts = require("Data.baseNuts")

gun.mag = {} -- mag loads itself with the active inventory slot
gun.magSize = 50
gun.cooldownMax = .2 -- in seconds
gun.cooldownTimer = gun.cooldownMax
gun.width = 16
gun.height = 8
gun.flipped = 1 -- -1 will flip it

function gun:update(dt)

    -- Set the gun's position based on the player
    gun.x = Player.relX+(Player.width-5)
    gun.y = Player.relY+(Player.height/2)
    -- The guns position relative to the screen
    gun.camX = Player.camX+(Player.width-5)
    gun.camY = Player.camY+(Player.height/2)

    -- Set the gun's rotation based on the cursor
    gun.rotation =  math.atan2((love.mouse.getY()/1.333) - gun.camY, (love.mouse.getX()/1.333) - gun.camX)

    if (love.mouse.getX()/1.333) < gun.camX then
        gun.flipped = -1
    else
        gun.flipped = 1
    end

    -- Lower the cooldown timer
    if self.cooldownTimer < self.cooldownMax then
        self.cooldownTimer = self.cooldownTimer + dt
    end

    -- Fire the gun
    if love.mouse.isDown(1) then
        -- This takes account for the game size being different from the window's
        gun:shoot((love.mouse.getX()/1.333)+Player.x, (love.mouse.getY()/1.333)+Player.y)
    end

    -- Reload the gun
    if love.keyboard.isDown("r") then
        gun:loadMag()
    end

    -- TEST ** adds nut to section 1 of inventory
    if love.keyboard.isDown("space") then
        inventoryHandler:addNut(nut:new(baseNuts.almond))
    end
    if love.keyboard.isDown("f") then
        inventoryHandler:addNut(nut:new(baseNuts.candleNut))
    end
    -- TEST ** adds nut oil into the inventory
    if love.keyboard.isDown("t") then
       inventoryHandler:addItem(ItemManager:newItem("nut oil"))
    end
    -- TEST ** adds cashew apples into the inventory
    if love.keyboard.isDown("y") then
        inventoryHandler:addItem(ItemManager:newItem("cashew apple"))
     end
end

function gun:shoot(x, y)

    if #self.mag > 0 and self.cooldownTimer >= self.cooldownMax then

        -- Find where the end of the gun is
        local startX = gun.x + math.cos(gun.rotation) * gun.width
        local startY = gun.y + math.sin(gun.rotation) * gun.width

        -- Shoot the nut
        ProjectileManager:add(startX, startY, x, y, gun.mag[1])
        self.cooldownTimer = 0

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

function gun:load()
    SpriteSheets.gun = love.graphics.newImage("Graphics/gun.png")
    SpriteSheets.gun:setFilter("nearest", "nearest")
end

function gun:draw()
    love.graphics.draw(SpriteSheets.gun, self.camX, self.camY, gun.rotation, 1, gun.flipped, 0, gun.height/2)
end

return gun