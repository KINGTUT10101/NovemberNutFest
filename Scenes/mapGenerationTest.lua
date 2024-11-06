local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local push = require ("Libraries.push")
local mapGenerator = require ("Core.mapGenerator")
local biomes = require ("Data.biomes")

local grid
local size = 2000
local tileSize = 0.5
local colorMap = {
    [2] = {1, 0, 0, 1},
    [1] = {1, 0, 0.5, 1},
    [0] = {1, 0, 1, 1},
    [-1] = {0.5, 0, 1, 1},
    [-2] = {0, 0, 1, 1},

    [42] = {1, 1, 1, 1},
    [43] = {0.5, 0.5, 0.5, 1},
}

local camera = {
    x = 0,
    y = 0,
}
local camVelocity = 1000

function thisScene:load (...)
    sceneMan = ...
    
    grid = mapGenerator (size)
end

function thisScene:update (dt)
    if love.keyboard.isDown("w") then
        camera.y = camera.y - camVelocity * dt
    elseif love.keyboard.isDown("s") then
        camera.y = camera.y + camVelocity * dt
    end

    if love.keyboard.isDown("a") then
        camera.x = camera.x - camVelocity * dt
    elseif love.keyboard.isDown("d") then
        camera.x = camera.x + camVelocity * dt
    end
end

function thisScene:draw ()
    -- -- Stage 1-2 test rendering
    -- for i = 1, size do
    --     local firstPart = grid[i]

    --     for j = 1, size do
    --         local tile = firstPart[j]

    --         love.graphics.setColor (colorMap[tile])
    --         love.graphics.rectangle ("fill", i * tileSize, j * tileSize, tileSize, tileSize)
    --     end
    -- end

    -- -- Stage 3 test rendering
    -- for i = 1, size do
    --     local firstPart = grid[i]

    --     for j = 1, size do
    --         local noise = firstPart[j]

    --         love.graphics.setColor (1, 1, 1, noise)
    --         love.graphics.rectangle ("fill", i * tileSize, j * tileSize, tileSize, tileSize)
    --     end
    -- end

    -- Biome color test rendering

    -- Get tile at 0, 0 screen pos


    for i = 1, size do
        local firstPart = grid[i]

        for j = 1, size do
            local tileObj = firstPart[j]

            love.graphics.setColor (biomes[tileObj.biome].mapColor)
            love.graphics.rectangle ("fill", i * tileSize - camera.x, j * tileSize - camera.y, tileSize, tileSize)
        end
    end

    -- Show mouse postion
    local mx, my = push:toGame(love.mouse.getPosition ())

    print (mx, my)

    -- love.graphics.setColor ({0, 0, 0, 0.25})
    -- love.graphics.rectangle ("fill", 700, 0, 100, 55)
    -- love.graphics.setColor ({1, 1, 1, 1})
    -- love.graphics.printf (mx .. ", " .. my, 700, 5, 100, "center") -- Mouse position
end

function thisScene:keypressed (key, scancode, isrepeat)
	if key == "0" then
        grid = mapGenerator (size)
    end
end

function thisScene:mousereleased (x, y, button)

end

return thisScene