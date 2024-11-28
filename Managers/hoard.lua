local hoardManager = {}

local enemyManager = require("Enemies.enemy")
local camera = require("Libraries.hump.camera")
local mapManager = require("Core.mapManager")
local collisionCheck = require("Helpers.collisionCheck")

hoardManager.waveTimer = 0          -- Time counting up to next wave
hoardManager.maxWaveTimer = 3       -- Seconds to before next wave
hoardManager.kills = 0      -- Amount of kills during the current wave
hoardManager.maxKills = 5   -- Amount of kills needed to end the wave
hoardManager.previousTotalKills = 0   -- Amound of total kills at the start of the wave 
hoardManager.waveCount = 0          -- Amount of waves the player has gone through
hoardManager.inProgress = false -- Is true if a wave is currently happening

hoardManager.spawnTimer = 0         -- Counting up till another enemy spawns
hoardManager.maxSpawnTimer = 2      -- The time it takes for another enemy to spawn

function hoardManager:startWave()

    self.inProgress = true
    self.waveTimer = 0
    self.spawnTimer = 0
    self.kills = 0
    self.previousTotalKills = EnemyManager.totalKills
    print("WAVE " .. self.waveCount+1 .. " HAS BEGUN!!!")
end

function hoardManager:update(dt)
    if not self.inProgress then
        self.waveTimer = self.waveTimer + dt
        -- Only has a timer for the first wave
        if self.waveTimer >= self.maxWaveTimer and self.waveCount == 0 then
            self:startWave()
        end
    else
        -- Spawner
        self.spawnTimer = self.spawnTimer + dt
        if self.spawnTimer >= self.maxSpawnTimer then

            hoardManager:HoardSpawn()

            self.spawnTimer = 0
        end

        -- Kills update
        self.kills = EnemyManager.totalKills - self.previousTotalKills
        -- Hoard end check
        if self.kills >= self.maxKills then
            self.inProgress = false
            self.waveCount = self.waveCount + 1
            print("You fended off wave " .. self.waveCount .. " succesfully!")
        end
    end
end

-- Spawns an enemy in a random spot around the players camera
function hoardManager:HoardSpawn(type)
    local enemyX, enemyY
    local count = 0
    local rare -- This is given a random value to decide if a rare enemy spawns in

    if type == nil then
        -- Scale enemies based on curent wave
        local enemyType = math.random(1, self.waveCount+1)
        if enemyType > EnemyManager.enemyTypes then enemyType = math.random(1, EnemyManager.enemyTypes) end
        while type == nil do
            if enemyType == 1 then
                type = "generic"
            elseif enemyType == 2 then
                type = "small"
            elseif enemyType == 3 then
                type = "armored"
            elseif enemyType == 4 then
                rare = math.random(1, 4)
                if rare == 4 then type = "screecher" end
            elseif enemyType == 5 then
                type = "witch"
            else
                error(enemyType .. " is not a valid number for an enemy.")
            end
        end
    end

    while true do
        -- Give up on spawning if a spawn position can't be found
        if count > 5 then break end
        local side = math.random(1, 4)
        if side == 1 then -- left
            enemyX = camera.x - ((TRUEGAMEWIDTH / 2) + enemyManager:getWidth(type))
            enemyY = math.random(camera.y - TRUEGAMEHEIGHT, camera.y + TRUEGAMEHEIGHT)
        elseif side == 2 then -- right
            enemyX = camera.x + ((TRUEGAMEWIDTH / 2) + enemyManager:getWidth(type))
            enemyY = math.random(camera.y - TRUEGAMEHEIGHT, camera.y + TRUEGAMEHEIGHT)
        elseif side == 3 then -- top
            enemyX = math.random(camera.x - TRUEGAMEWIDTH, camera.x + TRUEGAMEWIDTH)
            enemyY = camera.y - ((TRUEGAMEWIDTH / 2) + enemyManager:getHeight(type))
        elseif side == 4 then -- bottom
            enemyX = math.random(camera.x - TRUEGAMEWIDTH, camera.x + TRUEGAMEWIDTH)
            enemyY = camera.y + ((TRUEGAMEWIDTH / 2) + enemyManager:getHeight(type))
        else
            count = count + 1; goto continue
        end

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
