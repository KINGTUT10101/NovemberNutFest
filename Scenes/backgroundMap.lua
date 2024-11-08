local thisScene = {}
local sceneMan = require ("Libraries.sceneMan")
local mapManager = require ("Core.mapManager")

local camera = {
    x = 0,
    y = 0,
    zoom = 1,
}
local camVelocity = 100
local zoomVelocity = 10

function thisScene:load (...)
    sceneMan = ...
    
    mapManager:resetMap (100)
end

function thisScene:delete (...)
    local args = {...}
    
end

function thisScene:update (dt)
    if love.keyboard.isDown("w") then
        camera.y = camera.y - camVelocity * dt * camera.zoom
    elseif love.keyboard.isDown("s") then
        camera.y = camera.y + camVelocity * dt * camera.zoom
    end

    if love.keyboard.isDown("a") then
        camera.x = camera.x - camVelocity * dt * camera.zoom
    elseif love.keyboard.isDown("d") then
        camera.x = camera.x + camVelocity * dt * camera.zoom
    end

    if love.keyboard.isDown("q") then
        camera.zoom = camera.zoom - zoomVelocity * dt
    elseif love.keyboard.isDown("e") then
        camera.zoom = camera.zoom + zoomVelocity * dt
    end

    mapManager:update (dt, camera.x, camera.y, camera.zoom)
end

function thisScene:draw ()
    mapManager:draw ()
end

function thisScene:keypressed (key, scancode, isrepeat)
	
end

function thisScene:mousereleased (x, y, button)

end

return thisScene