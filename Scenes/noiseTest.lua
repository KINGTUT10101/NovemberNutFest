local grid = {}

local function generateNoiseGrid()
	-- Fill each tile in our grid with noise.
	local baseX = 10000 * love.math.random()
	local baseY = 10000 * love.math.random()
	for y = 1, 25 do
		grid[y] = {}
		for x = 1, 25 do
			grid[y][x] = love.math.noise(baseX+.1*x, baseY+.2*y)
		end
	end
end

local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")

function thisScene:load (...)
    sceneMan = ...
    
end

function thisScene:delete (...)
    local args = {...}
    
end

function thisScene:update (dt)
    
end

function thisScene:draw ()
    local tileSize = 30
	for y = 1, #grid do
		for x = 1, #grid[y] do
			love.graphics.setColor(1, 1, 1, grid[y][x])
			love.graphics.rectangle("fill", x*tileSize, y*tileSize, tileSize-1, tileSize-1)
		end
	end
end

function thisScene:keypressed (key, scancode, isrepeat)
	if key == "0" then
        generateNoiseGrid ()
    end
end

function thisScene:mousereleased (x, y, button)

end

return thisScene