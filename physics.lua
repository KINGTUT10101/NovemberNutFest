local physics = {}

function physics:load()

    -- Physics World
    self.gameWorld = love.physics.newWorld(0, 0, true)
    self.gameWorld:setCallbacks(nil, nil, self.preSolveGame)
end

-- Collision logic for the game scene
function physics.preSolveGame(a, b)

    local idA, idB = a:getUserData(), b:getUserData()

        -- Spread fire if both enemies are oiled
    if idA ~= nil and idB ~= nil then
        if idA.class == "enemy" and idB.class == "enemy" then
            if idA.statusEffects.onFire and idB.statusEffects.oiled then
                idB.statusEffects.oiled = false
                idB.statusEffects.onFire = true
            end
        end

        -- Collisions between the player and enemy
        if idA.class == "player" and idB.class == "enemy" then
            idA:hit(idB.damage)
        end
    end
end

return physics