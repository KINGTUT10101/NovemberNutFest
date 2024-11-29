local physics = require "physics"
-- Set RNG seed
math.randomseed(os.time())

-- Set image filtering
-- This works best for pixel art
love.graphics.setDefaultFilter("nearest", "nearest")
love.graphics.setLineStyle("smooth")

-- Loads the libraries
local push = require("Libraries.push")
local sceneMan = require("Libraries.sceneMan")
local lovelyToasts = require("Libraries.lovelyToasts")
local tux = require("Libraries.tux")
local camera = require("Libraries.hump.camera")
local musicManager = require ("Core.musicManager")

-- Declares / initializes the local variables

-- filepath (string) A folder containing three slices: normal, hovered, and active
local function loadTracks (filepath)
    local files = love.filesystem.getDirectoryItems (filepath)

    local newTracks = {}

    for index, file in ipairs (files) do
        newTracks[index] = love.audio.newSource(filepath .. "/" .. file, "stream")
        newTracks[index]:setLooping(true)
        newTracks[index]:setVolume(0.1)
    end

    return newTracks
end

-- Declares / initializes the global variables
SpriteSheets = {}
GAMEWIDTH, GAMEHEIGHT = 1920, 1080
WindowWidth, WindowHeight = 1280, 720
-- WindowWidth, WindowHeight = 1280, 720
DevMode = true

function love.load()
    -- Set up Push
    push:setupScreen(GAMEWIDTH, GAMEHEIGHT, WindowWidth, WindowHeight, { fullscreen = false })
    TRUEGAMEWIDTH, TRUEGAMEHEIGHT = push:getWidth() / camera.scale, push:getHeight() / camera.scale

    -- Set up Lovely Toasts
    lovelyToasts.canvasSize = { GAMEWIDTH, GAMEHEIGHT }

    -- Load in the physics world
    physics:load()

    -- Set up Tux
    tux.utils.setDefaultSlices(require("Helpers.slices").default)
    tux.utils.setDefaultFontSize(32)
    tux.utils.setTooltipFont("default", 24)
    tux.utils.setDefaultColors(
        {
            normal = {
                fg = { 1, 1, 1, 1 },
                bg = { 1, 1, 1, 1 },
            },
            hover = {
                fg = { 1, 1, 1, 1 },
                bg = { 1, 1, 1, 1 },
            },
            held = {
                fg = { 1, 1, 1, 1 },
                bg = { 1, 1, 1, 1 },
            },
        }
    )

    -- Sets up scenes for the music manager
    musicManager:newScene ("betweenWaves", loadTracks ("Music/Between Waves"))
    musicManager:newScene ("activeWave", loadTracks ("Music/Active Wave"))
    musicManager:newScene ("mainMenu", loadTracks ("Music/Main Menu"))

    musicManager:switchScene ("betweenWaves")

    -- Set up scenes for SceneMan
    sceneMan:newScene("noiseTest", require("Scenes.noiseTest"))
    sceneMan:newScene("mapGenerationTest", require("Scenes.mapGenerationTest"))
    sceneMan:newScene("backgroundMap", require("Scenes.backgroundMap"))
    sceneMan:newScene("game", require("Scenes.gameScene"))
    sceneMan:newScene("debug", require("Scenes.debug"))
    sceneMan:newScene("title", require("Scenes.title"))
    sceneMan:newScene("gameMenu", require("Scenes.gameMenu"))
    sceneMan:newScene("sideMenus", require("Scenes.sideMenus"))

    sceneMan:push("backgroundMap")
    -- sceneMan:push("sideMenus")
    sceneMan:push("gameMenu")
    sceneMan:push("game")
    sceneMan:push("debug")
end

function love.update(dt)
    tux.callbacks.update(dt, push:toGame(love.mouse.getPosition()))
    sceneMan:event("update", dt)
    lovelyToasts.update(dt)
end

function love.draw()
    push:start()
    sceneMan:event("draw")
    tux.callbacks.draw()
    sceneMan:event("lateDraw")
    lovelyToasts.draw()
    push:finish()
end

function love.keypressed(key, scancode, isrepeat)
    tux.callbacks.keypressed(key, scancode, isrepeat)
    sceneMan:event("keypressed", key, scancode, isrepeat)

    if key == "k" then
        musicManager:nextTrack ()
    end
end

function love.wheelmoved (x, y)
    sceneMan:event("wheelmoved", x, y)
end

function love.textinput(text)
    tux.callbacks.textinput(text)
end

function love.mousereleased(x, y, button)
    sceneMan:event("mousereleased", x, y, button)
end
