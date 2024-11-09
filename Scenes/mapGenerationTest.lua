local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local push = require ("Libraries.push")
local mapGenerator = require ("Core.mapGenerator")
local biomes = require ("Data.biomes")
local mapManager = require("Core.mapManager")

local grid
local size = 500
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
    zoom = 0.5,
}
local camVelocity = 1000
local zoomVelocity = 10

local mapRender = love.graphics.newCanvas (size, size)
local mapRendered = false

local biggerFont = love.graphics.newFont (32)

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

    if love.keyboard.isDown("q") then
        camera.zoom = camera.zoom - zoomVelocity * dt
    elseif love.keyboard.isDown("e") then
        camera.zoom = camera.zoom + zoomVelocity * dt
    end
end

function thisScene:draw ()
    if mapRendered == false then
        local origCanvas = love.graphics.getCanvas ()
        love.graphics.setCanvas (mapRender)

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
                local tileColor = biomes[tileObj.biome].mapColor

                if tileObj.building == nil then
                    love.graphics.setColor (tileColor[1], tileColor[2], tileColor[3], 1)
                else
                    love.graphics.setColor (tileColor[1], tileColor[2], tileColor[3], 0.25)
                end
                -- love.graphics.rectangle ("fill", i * tileSize - camera.x, j * tileSize - camera.y, tileSize, tileSize)
                love.graphics.rectangle ("fill", i - 1, j - 1, 1, 1)
            end
        end

        love.graphics.setCanvas (origCanvas)
        mapRendered = true
    else
        love.graphics.draw (mapRender, 0 - camera.x, 0 - camera.y, nil, camera.zoom, camera.zoom)
    end

    -- Show mouse postion
    local mx, my = push:toGame(love.mouse.getPosition ())

    love.graphics.setFont (biggerFont)
    love.graphics.setColor ({0, 0, 0, 0.45})
    love.graphics.rectangle ("fill", 1720, 0, 200, 50)
    love.graphics.setColor ({1, 1, 1, 1})
    love.graphics.printf (math.floor (mx) .. ", " .. math.floor (my), 1720, 10, 200, "center") -- Mouse position

    print (mapManager:screenToMap (mx, my))
end

function thisScene:keypressed (key, scancode, isrepeat)
	if key == "0" then
        grid = mapGenerator (size)
        mapRendered = false
    elseif key == "9" then
        camera.x = 0
        camera.y = 0
        camera.zoom = 0.5
    elseif key == "8" then
        camera.x = 0
        camera.y = 0
        camera.zoom = 64
    end
end

function thisScene:mousereleased (x, y, button)

end

return thisScene