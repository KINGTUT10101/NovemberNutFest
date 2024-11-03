-- Defines the biomes used in the map
-- ATTRIBUTES:
-- heat: Defines how hot/cold the biome is, which affects crop growth. 0 is neutral. +-5(?) is max/min
-- fertility: Scales how fast plants grow in the soil. 1 is 100%, aka no scaling
-- radiation: Defines how much additional radiation the biome has
-- sizeMean: Defines the average size of the biome
-- sizeVarition: Defines how much the size of the biome can vary using a normal distribution
-- groundTiles: List of image objects that defines what tiles can look like
-- weather: List of weather ID/probability key/value pairs
-- buildables: List of buildables objects/probability pairs, placed into tables
local biomes = {
    default = {
        heat = 0,
        fertility = 0,
        radiation = 0,
        sizeMean = 50,
        sizeVarition = 1,
        groundTiles = {

        },
        weather = {
            thunder = 0.01,
            rain = 0.05,
            fishRain = 0.005
        },
        buildables = {
            -- Ex: {peanutObj, 0.05}
        }
    },
    plains = {
        heat = 0,
        fertility = 1,
        radiation = 0,
        sizeMean = 50,
        sizeVarition = 1,
        groundTiles = {
            -- Ex: grassTileImage1
        },
        weather = {
            thunder = 0.01,
            rain = 0.05,
            fishRain = 0.005
        },
        buildables = {
            -- Ex: {peanutObj, 0.05}
        }
    },
    desert = {
        heat = 3,
        fertility = 0.5,
        radiation = 0.1,
        sizeMean = 50,
        sizeVarition = 1,
        groundTiles = {

        },
        weather = {
            thunder = 0.01,
            rain = 0.05,
            fishRain = 0.005
        },
        buildables = {
            -- Ex: {peanutObj, 0.05}
        }
    },
    -- TODO: Add more biomes and balance/finish existing ones
}

return biomes