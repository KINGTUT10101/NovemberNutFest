local itemManager = {}
Items = {} -- list of items

local throwables = require("Data.throwables")
local consumables = require("Data.consumables")
local projectileManager = require("Managers.projectile")
local copyTable = require("Helpers/copyTable")

local ePressed = false -- Has e been pressed?
local hPressed = false -- Has h been pressed?

function itemManager:newThrowable(object)

    local item = {}

    if object == "nut butter" then
        item = copyTable(throwables.nutButter)
    elseif object == "nut oil" then
        item = copyTable(throwables.nutOil)
    else
        error(object .. " is not a throwable object.")
    end

    return item
end

function itemManager:newConsumable(object)

    local item = {}

    if object == "cashew apple" then
        item = copyTable(consumables.cashewApple)
    else
        error(object .. " is not a consumable object.")
    end

    return item
end

-- This will probally be reduntant later. It's just to test throwing throwables and consuming consumables
function itemManager:update()

    -- Throwables
    if love.keyboard.isDown("e") and #Throwables > 0 and not ePressed then
        projectileManager:add(Player.x+(Player.width/2), Player.y+(Player.height/2), love.mouse.getX()/1.333, love.mouse.getY()/1.333, Throwables[1])
        table.remove(Throwables, 1)
        ePressed = false
    end
    ePressed = love.keyboard.isDown("e")

    -- Consumables
    if love.keyboard.isDown("h") and #Consumables > 0 and not hPressed then
        print("Consume")
        Consumables[1]:onConsumption()
        table.remove(Consumables, 1)
        hPressed = false
    end
    hPressed = love.keyboard.isDown("h")
end

return itemManager