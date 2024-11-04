local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local mapGenerator = require ("Core.mapGenerator")
local hotswap = require ("Libraries.lume").hotswap

local grid
local size = 64
local tileSize = 15
local colorMap = {
    [2] = {1, 0, 0, 1},
    [1] = {1, 0, 0.5, 1},
    [0] = {1, 0, 1, 1},
    [-1] = {0.5, 0, 1, 1},
    [-2] = {0, 0, 1, 1},

    [42] = {1, 1, 1, 1},
    [43] = {0.5, 0.5, 0.5, 1},
}

function thisScene:load (...)
    sceneMan = ...
    
    grid = mapGenerator (size)
end

function thisScene:update (dt)
    
end

function thisScene:draw ()
    -- for i = 1, size do
    --     local firstPart = grid[i]

    --     for j = 1, size do
    --         local tile = firstPart[j]

    --         love.graphics.setColor (colorMap[tile])
    --         love.graphics.rectangle ("fill", i * tileSize, j * tileSize, tileSize, tileSize)
    --     end
    -- end

    for i = 1, size do
        local firstPart = grid[i]

        for j = 1, size do
            local noise = firstPart[j]

            love.graphics.setColor (1, 1, 1, noise)
            love.graphics.rectangle ("fill", i * tileSize, j * tileSize, tileSize, tileSize)
        end
    end
end

function thisScene:keypressed (key, scancode, isrepeat)
	if key == "0" then
        grid = mapGenerator (size)
    end
end

function thisScene:mousereleased (x, y, button)

end

return thisScene