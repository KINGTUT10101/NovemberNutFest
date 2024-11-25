local hoardManager = {}

local enemyManager = require("Enemies.enemy")
local camera = require("Libraries.hump.camera")
local mapManager = require("Core.mapManager")
local collisionCheck = require("Helpers.collisionCheck")

hoardManager.waveTimer = 0 -- Time counting up to next wave
hoardManager.maxWaveTimer = 5 -- Seconds to before next wave
hoardManager.progress = 0 -- Progress through the current wave
hoardManager.waveCount = 0 -- Amount of waves the player has gone through
hoardManager.waveInProgress = false -- Is true if a wave is currently happening

hoardManager.spawnTimer = 0 -- Counting up till another enemy spawns
hoardManager.maxSpawnTimer = 2 -- The time it takes for another enemy to spawn

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
    local enemyX, enemyY
    local count = 0
    while true do
        if count > 5 then break end
        local side = math.random(1, 4)
        if side == 1 then -- left
           enemyX = camera.x-((TRUEGAMEWIDTH/2)+enemyManager:getWidth(type))
           enemyY = math.random(camera.y-TRUEGAMEHEIGHT, camera.y+TRUEGAMEHEIGHT)
        elseif side == 2 then -- right
            enemyX = camera.x+((TRUEGAMEWIDTH/2)+enemyManager:getWidth(type))
            enemyY = math.random(camera.y-TRUEGAMEHEIGHT, camera.y+TRUEGAMEHEIGHT)
        elseif side == 3 then -- top
            enemyX = math.random(camera.x-TRUEGAMEWIDTH, camera.x+TRUEGAMEWIDTH)
            enemyY = camera.y-((TRUEGAMEWIDTH/2)+enemyManager:getHeight(type))
        elseif side == 4 then -- bottom
            enemyX = math.random(camera.x-TRUEGAMEWIDTH, camera.x+TRUEGAMEWIDTH)
            enemyY = camera.y+((TRUEGAMEWIDTH/2)+enemyManager:getHeight(type))
        else count = count + 1; goto continue end

        -- Is the enemy in bounds?
        if collisionCheck(enemyX, enemyY, enemyManager:getWidth(type), enemyManager:getHeight(type), 0, 0, mapManager.realSize, mapManager.realSize)
        then
            enemyManager:spawnEnemy(enemyX, enemyY, type)
            break
        else
            count = count + 1
        end
        ::continue::
    end
end

return hoardManager