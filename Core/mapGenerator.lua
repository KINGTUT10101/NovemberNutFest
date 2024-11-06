local Tile = require ("Core.Tile")
local biomes = require ("Data.biomes")
local clamp = require ("Libraries.lume").clamp
local mapToScale = require ("Helpers.mapToScale")

-- NOTE: Assume a tile size of 64x64p when at 1x zoom

local biomeScale = 75
local buildScale = 1

-- Temperature gradient
local function stage1 (size)
    -- Calculate sizes of each temperature area
    local spaceLeft = size
    local areaSizes = {}

    -- Level 0
    areaSizes[0] = math.ceil ((33 + math.random (-3, 3)) / 100 * size)
    spaceLeft = spaceLeft - areaSizes[0]

    -- Level 1
    areaSizes[1] = math.ceil ((21 + math.random (-2, 2)) / 100 * size)
    spaceLeft = spaceLeft - areaSizes[1]

    -- Level -1
    areaSizes[-1] = math.ceil ((21 + math.random (-2, 2)) / 100 * size)
    spaceLeft = spaceLeft - areaSizes[-1]

    -- Level 2
    areaSizes[2] = math.ceil ((50 + math.random (-5, 5)) / 100 * spaceLeft)
    spaceLeft = spaceLeft - areaSizes[2]

    -- Level -2
    areaSizes[-2] = spaceLeft

    -- Calculate temperature area boundaries
    local areaBoundaries = {} -- Contains bottom boundaries for levels -2 to 1

    areaBoundaries[-2] = areaSizes[-2]
    areaBoundaries[-1] = areaBoundaries[-2] + areaSizes[-1]
    areaBoundaries[0] = areaBoundaries[-1] + areaSizes[0]
    areaBoundaries[1] = areaBoundaries[0] + areaSizes[1]

    -- Generate temperature grid
    local tempGrid = {}
    for i = 1, size do
        local firstPart = {}
        tempGrid[i] = firstPart

        for j = 1, size do
            local temp = 2
            for i = -2, 1 do
                if areaBoundaries[i] >= j then
                    temp = i
                    break
                end
            end
            firstPart[j] = temp
        end
    end

    return areaBoundaries, tempGrid
end

-- Roughing temperature area edges
local function stage2 (size, areaBoundaries, tempGrid)
    -- Iterate over area boundaries
    for t = -2, 1 do
        local boundary = areaBoundaries[t]
        local scale = math.random (5, 10)
        local offset = math.random (0, math.ceil (math.pi * scale * 2))

        -- Iterate horizontally over boundary tiles
        for i = 1, size do
            local firstPart = tempGrid[i]
            local direction = math.ceil (math.sin(1 / scale*(i-offset))*3 + math.random (-1, 1))

            -- Iterate over vertical tiles
            if direction > 0 then
                for j = 1, direction do
                    firstPart[boundary + j] = t
                end
            elseif direction < 0 then
                for j = direction, 0 do
                    firstPart[boundary + j] = t + 1
                end
            end
        end
    end

    return tempGrid
end

-- Biome noise maps
local function stage3 (size, tempGrid, grid)
    local biomeNoise = {} -- Stores biome noise maps for each biome, ordered by their temperature

    for temp = -2, 2 do
        biomeNoise[temp] = {}
    end

    -- Generate parameters for each biome's noise map
    for biomeID, biomeDef in pairs (biomes) do
        local temp = biomeDef.temp
        local sizeCoeff = biomeDef.size --+ (math.random (-10, 10) / 100) * biomeDef.size
        sizeCoeff = clamp (sizeCoeff, 0.1, 1)
        sizeCoeff = mapToScale (sizeCoeff, 0, 1, 1 / biomeScale * 0.02, 1 / biomeScale * 0.1)

        biomeNoise[temp][biomeID] = {
            scaleCoeff = sizeCoeff,
            offset = math.random (1, 100000),
            weight = biomeDef.weight,
        }
    end

    -- Set tiles based on temperature and noise values
    for i = 1, size do
        local firstPart = {}
        grid[i] = firstPart

        local tempFirstPart = tempGrid[i]

        for j = 1, size do
            -- Select biome based on weights
            local temp = tempFirstPart[j]
            local selectedBiome = "default"
            local highestNoise = 0

            for biomeID, biomeNoiseDef in pairs (biomeNoise[temp]) do
                local noiseX = biomeNoiseDef.scaleCoeff * i + biomeNoiseDef.offset
                local noiseY = 3 * biomeNoiseDef.scaleCoeff * j + biomeNoiseDef.offset
                local noiseValue = love.math.noise (noiseX, noiseY) * biomeNoiseDef.weight
                
                if noiseValue > highestNoise then
                    highestNoise = noiseValue
                    selectedBiome = biomeID
                end
            end

            -- Select a ground tile graphic
            local groundTile = biomes[selectedBiome].groundTiles[math.random (1, #biomes[selectedBiome].groundTiles)]

            -- Set tile
            firstPart[j] = Tile:new (groundTile, selectedBiome)
        end
    end

    -- -- TEMP
    -- local baseX = 10000 * love.math.random()
	-- local baseY = 10000 * love.math.random()
    -- for i = 1, size do
    --     local firstPart = tempGrid[i]

    --     for j = 1, size do
    --         -- y = 3x will create horizontally wide biomes
    --         -- 0.1 = very small, 0.02 = very large
    --         firstPart[j] = love.math.noise (0.01*i, 0.03*j)
    --     end
    -- end

    return grid
end

local function stage4 (size, grid)
    local densityOffset = math.random (1, 100000)

    -- Generate parameters for each biome's noise map
    local buildNoise = {}

    for biomeID, biomeDef in pairs (biomes) do
        for index, probPair in ipairs (biomeDef.buildables) do
            local buildObj = probPair[1]
            local weight = clamp (probPair[2], 0, 1)
            
            buildNoise[biomeID][index] = {
                buildObj = buildObj,
                offset = math.random (1, 100000),
                weight = weight,
            }
        end
    end

    -- Place buildables based on noise values
    for i = 1, size do
        local firstPart = {}
        grid[i] = firstPart

        for j = 1, size do
            local selectedBuild = nil
            local highestNoise = 0

            -- Set building
            if selectedBuild ~= nil then

            end
        end
    end
end

local function generateMap (size)
    local grid = {}

    local areaBoundaries, tempGrid = stage1(size)
    local tempGrid = stage2 (size, areaBoundaries, tempGrid)
    local grid = stage3 (size, tempGrid, grid)
    local grid = stage4 (size, grid)

    return grid
end

return generateMap