local function processAnimation (dt, obj, numFrames, timeBetweenFrames)
    obj.frame = obj.frame or 1
    obj.frameTimer = obj.frameTimer or 0

    obj.frameTimer = obj.frameTimer + dt
    if obj.frameTimer >= timeBetweenFrames then
        obj.frameTimer = 0
        obj.frame = obj.frame + 1
        if obj.frame > numFrames then
            obj.frame = 1
        end
    end
end

return processAnimation