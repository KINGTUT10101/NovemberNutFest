local baseNuts = require ("Data.baseNuts")

-- TEMP
local tileImages = {
    default = love.graphics.newImage ("Graphics/Tiles/default.png"),
    grass = love.graphics.newImage ("Graphics/Tiles/grass.png"),
    dirt = love.graphics.newImage ("Graphics/Tiles/dirt.png"),
    sand = love.graphics.newImage ("Graphics/Tiles/sand.png"),
    snow = love.graphics.newImage ("Graphics/Tiles/snow.png"),
}

-- Defines the biomes used in the map
-- ATTRIBUTES:
-- weight: Defines how likely the biome is to appear in world generation
-- temp: Defines how hot/cold the biome is, which affects crop growth. 0 is neutral. +-5(?) is max/min
-- fertility: Scales how fast plants grow in the soil. 1 is 100%, aka no scaling
-- radiation: Defines how much additional radiation the biome has
-- sizeMean: Defines the average size of the biome
-- sizeVarition: Defines how much the size of the biome can vary using a normal distribution
-- groundTiles: List of image objects that defines what tiles can look like
-- weather: List of weather ID/probability key/value pairs
-- buildables: List of buildables objects/probability pairs, placed into tables
local biomes = {
    default = {
        name = "Default",
        weight = 0,
        temp = 0,
        fertility = 0,
        radiation = 0,
        size = 1,
        mapColor = {1, 1, 1, 1},
        groundTiles = {
            tileImages.default,
        },
        weather = {
            thunder = 0.01,
            rain = 0.05,
            fishRain = 0.005
        },
        buildableChance = 1,
        buildableThreshold = 0.65,
        buildables = {
            {baseNuts.peanut, 1}
        }
    },

    -- ===================
    -- Level 2 temperature
    -- ===================
    desert = {
        name = "Desert",
        weight = 0.75,
        temp = 2,
        fertility = 0.5,
        radiation = 0.1,
        size = 0.90,
        mapColor = {1, 1, 0, 1},
        groundTiles = {
            tileImages.sand,
        },
        weather = {
            thunder = 0.01,
            rain = 0.05,
            fishRain = 0.005
        },
        buildableChance = 1,
        buildableThreshold = 0.65,
        buildables = {
            {baseNuts.peanut, 1}
        }
    },
    bloodDesert = {
        name = "Blood Desert",
        weight = 0.35,
        temp = 2,
        fertility = 0.5,
        radiation = 0.1,
        size = 0.85,
        mapColor = {1, 0, 0, 1},
        groundTiles = {
            tileImages.sand,
        },
        weather = {
            thunder = 0.01,
            rain = 0.05,
            fishRain = 0.005
        },
        buildableChance = 1,
        buildableThreshold = 0.65,
        buildables = {
            {baseNuts.peanut, 1}
        }
    },
    savana = {
        name = "Savana",
        weight = 0.75,
        temp = 2,
        fertility = 1,
        radiation = 0,
        size = 0.85,
        mapColor = {0.65, 0.65, 0, 1},
        groundTiles = {
            tileImages.grass,
        },
        weather = {
            thunder = 0.01,
            rain = 0.05,
            fishRain = 0.005
        },
        buildableChance = 1,
        buildableThreshold = 0.65,
        buildables = {
            {baseNuts.peanut, 1}
        }
    },

    -- ===================
    -- Level 1 temperature
    -- ===================
    swamp = {
        name = "Swamp",
        weight = 0.75,
        temp = 1,
        fertility = 1,
        radiation = 0,
        size = 0.75,
        mapColor = {0.35, 0.65, 0.45, 1},
        groundTiles = {
            tileImages.dirt,
        },
        weather = {
            thunder = 0.01,
            rain = 0.05,
            fishRain = 0.005
        },
        buildableChance = 1,
        buildableThreshold = 0.65,
        buildables = {
            {baseNuts.peanut, 1}
        }
    },
    beach = {
        name = "Beach",
        weight = 0.65,
        temp = 1,
        fertility = 0.5,
        radiation = 0.1,
        size = 0.40,
        mapColor = {0.45, 0, 1, 1},
        groundTiles = {
            tileImages.sand,
        },
        weather = {
            thunder = 0.01,
            rain = 0.05,
            fishRain = 0.005
        },
        buildableChance = 1,
        buildableThreshold = 0.65,
        buildables = {
            {baseNuts.peanut, 1}
        }
    },

    -- ===================
    -- Level 0 temperature
    -- ===================
    plains = {
        name = "Plains",
        weight = 0.75,
        temp = 0,
        fertility = 1,
        radiation = 0,
        size = 0.85,
        mapColor = {0, 1, 0, 1},
        groundTiles = {
            tileImages.grass,
        },
        weather = {
            thunder = 0.01,
            rain = 0.05,
            fishRain = 0.005
        },
        buildableChance = 1,
        buildableThreshold = 0.65,
        buildables = {
            {baseNuts.peanut, 1}
        }
    },
    flowerPlains = {
        name = "Flower Plains",
        weight = 0.45,
        temp = 0,
        fertility = 1,
        radiation = 0,
        size = 0.45,
        mapColor = {1, 0, 1, 1},
        groundTiles = {
            tileImages.grass,
        },
        weather = {
            thunder = 0.01,
            rain = 0.05,
            fishRain = 0.005
        },
        buildableChance = 1,
        buildableThreshold = 0.65,
        buildables = {
            {baseNuts.peanut, 1}
        }
    },
    forest = {
        name = "Forest",
        weight = 0.75,
        temp = 0,
        fertility = 1,
        radiation = 0,
        size = 0.85,
        mapColor = {0, 0.65, 0, 1},
        groundTiles = {
            tileImages.dirt,
        },
        weather = {
            thunder = 0.01,
            rain = 0.05,
            fishRain = 0.005
        },
        buildableChance = 1,
        buildableThreshold = 0.65,
        buildables = {
            {baseNuts.peanut, 1}
        }
    },

    -- ===================
    -- Level -1 temperature
    -- ===================
    tiaga = {
        name = "Tiaga",
        weight = 0.65,
        temp = -1,
        fertility = 1,
        radiation = 0,
        size = 1,
        mapColor = {0, 0.75, 0.75, 1},
        groundTiles = {
            tileImages.dirt,
        },
        weather = {
            thunder = 0.01,
            rain = 0.05,
            fishRain = 0.005
        },
        buildableChance = 1,
        buildableThreshold = 0.65,
        buildables = {
            {baseNuts.peanut, 1}
        }
    },
    glacialPlains = {
        name = "Glacial Plains",
        weight = 0.65,
        temp = -1,
        fertility = 1,
        radiation = 0,
        size = 1,
        mapColor = {0, 0.95, 0.55, 1},
        groundTiles = {
            tileImages.snow,
        },
        weather = {
            thunder = 0.01,
            rain = 0.05,
            fishRain = 0.005
        },
        buildableChance = 1,
        buildableThreshold = 0.65,
        buildables = {
            {baseNuts.peanut, 1}
        }
    },

    -- ===================
    -- Level -2 temperature
    -- ===================
    frozenOcean = {
        name = "Frozen Ocean",
        weight = 0.85,
        temp = -2,
        fertility = 1,
        radiation = 0,
        size = 0.90,
        mapColor = {0, 0, 0.25, 1},
        groundTiles = {
            tileImages.snow,
        },
        weather = {
            thunder = 0.01,
            rain = 0.05,
            fishRain = 0.005
        },
        buildableChance = 1,
        buildableThreshold = 0.65,
        buildables = {
            {baseNuts.peanut, 1}
        }
    },
    permafrost = {
        name = "Permafrost",
        weight = 0.45,
        temp = -2,
        fertility = 1,
        radiation = 0,
        size = 0.35,
        mapColor = {0, 0.75, 0.25, 1},
        groundTiles = {
            tileImages.dirt,
        },
        weather = {
            thunder = 0.01,
            rain = 0.05,
            fishRain = 0.005
        },
        buildableChance = 1,
        buildableThreshold = 0.65,
        buildables = {
            {baseNuts.peanut, 1}
        }
    },
}

return biomes