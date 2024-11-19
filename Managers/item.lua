ItemManager = {}
Items = {} -- list of items on the ground

local throwables = require("Data.throwables")
local consumables = require("Data.consumables")
local projectileManager = require("Managers.projectile")
local copyTable = require("Helpers/copyTable")
local inventoryHandler = require("Core.inventoryHandler")
local push = require("Libraries.push")
local camera = require("Libraries.hump.camera")

local eatSound = love.audio.newSource("SoundEffects/eating.wav", "static")
local collectSound = love.audio.newSource("SoundEffects/collect.wav", "static")

local ePressed = false -- Has e been pressed?
local hPressed = false -- Has h been pressed?

function ItemManager:newItem(type)

    local item = {}

    -- I miss switches :(
    if type == "cashew apple" then
        item = copyTable(consumables.cashewApple)
    elseif type == "nut butter" then
        item = copyTable(throwables.nutButter)
    elseif type == "nut oil" then
        item = copyTable(throwables.nutOil)
    else
        error(type .. " is not a valid item.")
    end

    item.sprite:setFilter("nearest", "nearest")

    return item
end

function ItemManager:placeThrowable(item, x, y)

    item.x = x
    item.y = y

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
        local targetX, targetY = push:toGame(camera:worldCoords(love.mouse.getPosition()))
        projectileManager:add(Player.x+(Player.width/2), Player.y+(Player.height/2), targetX, targetY, Throwables[1])
        table.remove(Throwables, 1)
        ePressed = false
    end
    ePressed = love.keyboard.isDown("e")

    -- Consumables
    if love.keyboard.isDown("h") and #Consumables > 0 and not hPressed then
        eatSound:play()
        Consumables[1]:onConsumption()
        table.remove(Consumables, 1)
        hPressed = false
    end
    hPressed = love.keyboard.isDown("h")

    -- Detect collision with placed items
    for i=#Items, 1, -1 do
        local item = Items[i]
       if Player:collisionCheck(item.x, item.y, item.width, item.height) then
            collectSound:play()
            inventoryHandler:addItem(item)
            table.remove(Items, i)
       end
    end
end

-- Only draws placed items
function ItemManager:draw()
    
    for i=#Items, 1, -1 do
        local item = Items[i]
        love.graphics.draw(item.sprite, item.x, item.y)
    end
end

return ItemManager