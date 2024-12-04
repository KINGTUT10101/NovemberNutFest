local copyTable = require ("Helpers.copyTable")

local musicManager = {
    scenes = {},
    activeScene = nil,
}

-- Creates a new scene for the music manager to use
function musicManager:newScene (id, tracks)
    assert (self.scenes[id] == nil, "Attempt to redefine an existing scene: " .. id)
    assert (#tracks > 0, "No tracks were provided with the scene")
    local newScene = {
        id = id,
        tracks = copyTable (tracks),
        lastTrack = nil
    }
    newScene.lastTrack = newScene.tracks[math.random (1, #newScene.tracks)]

    self.scenes[id] = newScene
end

-- Switches the current scene and loops a random song from its song list
function musicManager:switchScene (id)
    assert (self.scenes[id] ~= nil, "Attempt to switch to an undefined scene: " .. id)

    if self.activeScene ~= id then
        if self.activeScene ~= nil then
            self.scenes[self.activeScene].lastTrack:stop ()
        end
        self.activeScene = id
        self:nextTrack ()
    end
end

function musicManager:nextTrack ()
    local activeScene = self.scenes[self.activeScene]
    local selectedTrack = activeScene.lastTrack

    -- Stop current track
    if selectedTrack ~= nil then
        selectedTrack:stop ()
    end

    -- Randomly select tracks until a new one is chosen
    while selectedTrack == activeScene.lastTrack and not (#activeScene.tracks <= 1) do
        selectedTrack = activeScene.tracks[math.random (1, #activeScene.tracks)]
    end

    -- Play new track
    selectedTrack:play ()

    activeScene.lastTrack = selectedTrack
end

return musicManager