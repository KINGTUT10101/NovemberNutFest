local gameUI = {}

local drawTextWithBorder = require("Helpers/drawTextWithBorder")
local font = love.graphics.newFont("Fonts/PixelifySans.ttf", 32)

function gameUI:draw()
    -- Health
    drawTextWithBorder("Health: " .. Player.health, 5, 5, {1,1,1}, {0,0,0}, font)
end



return gameUI