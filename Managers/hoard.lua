local hoardManager = {}

local enemyManager = require("Enemies.enemy")
local camera = require("Libraries.hump.camera")
local mapManager = require("Core.mapManager")

hoardManager.waveTimer = 0 -- Time counting up to next wave
hoardManager.maxWaveTimer = 1 -- Seconds to before next wave
hoardManager.progress = 0 -- Progress through the current wave
hoardManager.waveCount = 0 -- Amount of waves the player has gone through
hoardManager.waveInProgress = false -- Is true if a wave is currently happening

hoardManager.spawnTimer = 0 -- Counting up till another enemy spawns
hoardManager.maxSpawnTimer = .2 -- The time it takes for another enemy to spawn

function hoardManager:update(dt)

    if not self.waveInProgress then
        self.waveTimer = self.waveTimer + dt
        if self.waveTimer >= self.maxWaveTimer then
            self.waveInProgress = true
            self.waveTimer = 0
            self.spawnTimer = 0
        end
    else
        self.spawnTimer = self.spawnTimer + dt
        if self.spawnTimer >= self.maxSpawnTimer then
            self:HoardSpawn("generic")
            self.spawnTimer = 0
        end
    end
end

-- Spawns an enemy in a random spot around the players camera
function hoardManager:HoardSpawn(type)
    local reroll = true
    while reroll do
        reroll = false
        local side = math.random(1, 4)
        --print(side, camera.x, GAMEWIDTH/3)
        if side == 1 and camera.x > GAMEWIDTH/3 then -- left
           enemyManager:spawnEnemy(camera.x-((GAMEWIDTH/4)-enemyManager:getEnemyWidth(type)), math.random(camera.y-GAMEHEIGHT/2, camera.y+GAMEHEIGHT/2), type)
           --print("Second:", side)
        elseif side == 2 and camera.x < (mapManager.mapSize*mapManager.tileSize)-(GAMEWIDTH/3) then -- right
            enemyManager:spawnEnemy(camera.x+(GAMEWIDTH/4), math.random(camera.y-GAMEHEIGHT/2, camera.y+GAMEHEIGHT/2), type)
            --print("Second:", side)
        elseif side == 3 then -- top
            reroll = false
        elseif side == 4 then -- bottom
            reroll = false
        else reroll = true end
    end
end

return hoardManager