local gun = {}

local nut = require("Core.Nut")
local inventoryHandler = require("Core.newInventoryHandler")
local ProjectileManager = require("Managers.projectile")
local ItemManager = require("Managers.item")
local baseNuts = require("Data.baseNuts")
local push = require("Libraries.push")
local copyTable= require "Helpers.copyTable"
local tux = require ("Libraries.tux")
local Nut      = require "Core.Nut"
local hasEffect= require "Helpers.hasEffect"

gun.cooldownMax = .2 -- in seconds
gun.orginCooldownMax = gun.cooldownMax
gun.cooldownTimer = gun.cooldownMax
gun.width = 16
gun.height = 8
gun.flipped = 1 -- -1 will flip it

local shootSound = love.audio.newSource("SoundEffects/shoot.wav", "static")

function gun:update(dt)
    local mouseGameX, mouseGameY = push:toGame(love.mouse.getPosition())

    -- Set the gun's position based on the player
    if Player.facing == "right" then
        gun.x = Player.x + (Player.width - 5)
        gun.y = Player.y + (Player.height / 2)

        gun.camX = Player.camX + (Player.width - 5)
        gun.camY = Player.camY + (Player.height / 2)
    else
        gun.x = Player.x + 5
        gun.y = Player.y + (Player.height / 2)
    
        gun.camX = Player.camX + 5
        gun.camY = Player.camY + (Player.height / 2)
    end

    -- Set the gun's rotation based on the cursor
    gun.rotation = math.atan2(mouseGameY - (gun.camY+self.height), mouseGameX - (gun.camX+self.width))

    if mouseGameX < gun.camX then
        gun.flipped = -1
    else
        gun.flipped = 1
    end
    
    Player.facing = (gun.flipped == 1) and "right" or "left"

    -- Lower the cooldown timer
    if self.cooldownTimer < self.cooldownMax then
        self.cooldownTimer = self.cooldownTimer + dt
    end

    -- Fire the gun
    if love.mouse.isDown(1) and tux.utils.itemClicked () == false then
        local targetX = Player.x + (mouseGameX - gun.camX)
        local targetY = Player.y + (mouseGameY - gun.camY)
        gun:shoot(targetX, targetY)
    end
end

function gun:shoot(x, y)
    local currentNut = inventoryHandler:getNut(inventoryHandler:getActiveSlot())
    if currentNut ~= nil and inventoryHandler:getAmmoCount() > 0 and self.cooldownTimer >= self.cooldownMax then
        shootSound:play()

        -- Find where the end of the gun is
        local startX = gun.x + math.cos(gun.rotation) * gun.width
        local startY = gun.y + math.sin(gun.rotation) * gun.width

        local newNut = copyTable(currentNut)

        -- Choose what attributes stay and go
        for i = #currentNut.specialEffects, 1, -1 do
            local trib = currentNut.specialEffects[i]
            local chance = math.random()
            if trib[2] > chance then
                table.remove(newNut.specialEffects, i)
            end
        end

        -- Lower the gun's cooldown for hyperburst
        if hasEffect(newNut.specialEffects, "hyperburst") then
            self.cooldownMax = self.orginCooldownMax/2
        else
            self.cooldownMax = self.orginCooldownMax
        end

        -- Scale the nut's stats based on it's level
        if newNut.level > 1 then
            newNut.damage = newNut.damage * newNut.level/1.5
            newNut.projVelocity = newNut.projVelocity * newNut.level/1.5
            newNut.range = newNut.range * newNut.level/1.5
        end

        -- Shoot the nut
        ProjectileManager:add(startX, startY, x, y, newNut)
        self.cooldownTimer = 0

        inventoryHandler:addAmmoCount(-1)
    end
end

function gun:load()
    SpriteSheets.gun = love.graphics.newImage("Graphics/gun.png")
    SpriteSheets.gun:setFilter("nearest", "nearest")
end

function gun:draw()
    love.graphics.draw(SpriteSheets.gun, self.x, self.y, gun.rotation, 1, gun.flipped, 0, gun.height / 2)
end

return gun
