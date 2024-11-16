local gun = {}

local nut = require("Core.Nut")
local inventoryHandler = require("Core.inventoryHandler")
local ProjectileManager = require("Managers.projectile")
local ItemManager = require("Managers.item")
local baseNuts = require("Data.baseNuts")

gun.cooldownMax = .2 -- in seconds
gun.cooldownTimer = gun.cooldownMax
gun.width = 16
gun.height = 8
gun.flipped = 1 -- -1 will flip it

local shootSound = love.audio.newSource("SoundEffects/shoot.wav", "static")

function gun:update(dt)

    -- Set the gun's position based on the player
    gun.x = Player.relX+(Player.width-5)
    gun.y = Player.relY+(Player.height/2)
    -- The guns position relative to the screen
    gun.camX = Player.camX+(Player.width-5)
    gun.camY = Player.camY+(Player.height/2)

    -- Set the gun's rotation based on the cursor
    gun.rotation =  math.atan2((love.mouse.getY()) - gun.camY, (love.mouse.getX()) - gun.camX)

    if (love.mouse.getX()) < gun.camX then
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
        gun:shoot((love.mouse.getX())+Player.x, (love.mouse.getY())+Player.y)
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

    local activeSection = inventoryHandler.sections[inventoryHandler.activeSection]
    if #activeSection > 0 and self.cooldownTimer >= self.cooldownMax then

        shootSound:play()

        -- Find where the end of the gun is
        local startX = gun.x + math.cos(gun.rotation) * gun.width
        local startY = gun.y + math.sin(gun.rotation) * gun.width

        -- Shoot the nut
        ProjectileManager:add(startX, startY, x, y, activeSection[1])
        self.cooldownTimer = 0

        inventoryHandler:consumeNut()
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