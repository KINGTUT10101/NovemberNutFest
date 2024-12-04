local function loadAnimationFrames (directory)
    local files = love.filesystem.getDirectoryItems (directory)
    table.sort (files)

    local newFrames = {}
    
    for index, file in ipairs (files) do
        newFrames[index] = love.graphics.newImage(directory .. "/" .. file)
        newFrames[index]:setFilter("nearest", "nearest")
    end
    
    return newFrames
end

return loadAnimationFrames