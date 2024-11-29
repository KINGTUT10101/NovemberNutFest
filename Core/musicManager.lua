local copyTable = require ("Helpers.copyTable")

local musicManager = {
    scenes = {},
    activeScene = nil,
}

-- Creates a new scene for the music manager to use
function musicManager:newScene (id, tracks)
    assert (self.scenes[id] == nil, "Attempt to redefine an existing scene")
    assert (#tracks > 0, "No tracks were provided with the scene")

    self.scenes[id] = {
        id = id,
        tracks = copyTable (tracks),
        lastTrack = nil
    }
end

-- Switches the current scene and loops a random song from its song list
function musicManager:switchScene (id)
    assert (self.scenes[id] ~= nil, "Attempt to switch to an undefined scene")

    self.activeScene = id
    self:nextTrack ()
end

function musicManager:nextTrack ()
    local activeScene = self.scenes[self.activeScene]
    local selectedTrack = activeScene.lastTrack

    -- Return early if there are no other tracks to choose from
    if #activeScene.tracks <= 1 then
        return
    end

    -- Stop current track
    if selectedTrack ~= nil then
        selectedTrack:stop ()
    end

    -- Randomly select tracks until a new one is chosen
    while selectedTrack == activeScene.lastTrack do
        selectedTrack = activeScene.tracks[math.random (1, #activeScene.tracks)]
    end

    -- Play new track
    selectedTrack:play ()

    activeScene.lastTrack = selectedTrack
end

return musicManager