local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local mapManager = require ("Core.mapManager")
local push = require ("Libraries.push")
local camera = require("Libraries.hump.camera")


local camVelocity = 1000
local zoomVelocity = .01

function thisScene:load (...)
    sceneMan = ...
    
    mapManager:resetMap (100)
end

function thisScene:delete (...)
    local args = {...}
    
end

function thisScene:update (dt)

    if love.keyboard.isDown("[") then
        camera:zoom(camera.scale-zoomVelocity * dt)
    elseif love.keyboard.isDown("]") then
        camera:zoom(camera.scale+zoomVelocity * dt)
    end

    mapManager:update (dt, 0, 0, 1)
end

function thisScene:draw ()
    camera:attach(nil, nil, push:getWidth(), push:getHeight())
    mapManager:draw()
    camera:detach()
end

function thisScene:keypressed (key, scancode, isrepeat)
	
end

function thisScene:mousereleased (x, y, button)
    local mx, my = push:toGame(love.mouse.getPosition ())

    mapManager:interact (mapManager:screenToMap (mx, my))
end

return thisScene