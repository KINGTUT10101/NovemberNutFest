ItemManager = {}
Items = {} -- list of items on the ground

local throwables = require("Data.throwables")
local consumables = require("Data.consumables")
local powerups = require("Data.powerups")
local projectileManager = require("Managers.projectile")
local copyTable = require("Helpers/copyTable")
local inventoryHandler = require("Core.newInventoryHandler")
local push = require("Libraries.push")
local lovelyToasts = require ("Libraries.lovelyToasts")

local eatSound = love.audio.newSource("SoundEffects/eating.wav", "static")
local collectSound = love.audio.newSource("SoundEffects/collect.wav", "static")

local ePressed = false -- Has e been pressed?
local qPressed = false -- Has h been pressed?

function ItemManager:newItem(type)
    local item = {}

    -- I miss switches :(
    if type == "cashew apple" then
        item = copyTable(consumables.cashewApple)
    elseif type == "nut butter" then
        item = copyTable(throwables.nutButter)
    elseif type == "nut oil" then
        item = copyTable(throwables.nutOil)
    elseif type == "speed" then
        item = copyTable(powerups.speed)
    elseif type == "damage" then
        item = copyTable(powerups.damage)
    else
        error(type .. " is not a valid item.")
    end

    item.sprite:setFilter("nearest", "nearest")

    return item
end

function ItemManager:placeThrowable(item, x, y)
    item.x = x
    item.y = y

    item.sprite.Player:setFilter("nearest", "nearest")

    table.insert(Items, item)
end

function ItemManager:placeConsumable(item, x, y)
    item.x = x
    item.y = y

    table.insert(Items, item)
end

-- This will probally be reduntant later. It's just to test throwing throwables and consuming consumables
function ItemManager:update()
    -- Throwables
    if love.keyboard.isDown("e") and #Throwables > 0 and not ePressed then
        local mouseGameX, mouseGameY = push:toGame(love.mouse.getPosition())
        local targetX = (Player.x - Player.camX + mouseGameX) - (mouseGameX - Player.camX) / 2
        local targetY = (Player.y - Player.camY + mouseGameY) - (mouseGameY - Player.camY) / 2
        projectileManager:add(Player.x + (Player.width / 2), Player.y + (Player.height / 2), targetX, targetY,
            Throwables[1])
        table.remove(Throwables, 1)
        ePressed = false
    end
    ePressed = love.keyboard.isDown("e")

    -- Consumables
    if love.keyboard.isDown("q") and #Consumables > 0 and not qPressed then
        eatSound:play()
        Consumables[1]:onConsumption()
        table.remove(Consumables, 1)
        qPressed = false
    end
    qPressed = love.keyboard.isDown("q")

    -- Powerup Despawn

    -- Detect collision with placed items
    for i = #Items, 1, -1 do
        local item = Items[i]
        if Player:collisionCheck(item.x, item.y, item.width, item.height) then
            if item.type ~= "powerup" then
                collectSound:play()
                inventoryHandler:addItem(item)

            else
                if item.object == "speed" then
                    Player.speedUpTimer = 0
                    lovelyToasts.show ("Speed BONUS!", 3)
                elseif item.object == "damage" then
                    Player.damageUpTimer = 0
                    lovelyToasts.show ("Damage BONUS!", 3)
                end
                item.soundEffect:play()
            end
            table.remove(Items, i)
        end
    end
end

-- Only draws placed items
function ItemManager:draw()
    for i = #Items, 1, -1 do
        local item = Items[i]
        love.graphics.draw(item.sprite, item.x, item.y)
    end
end

return ItemManager
