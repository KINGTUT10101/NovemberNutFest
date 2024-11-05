local hitmarkerManager = {}
local hitmarkers = {}

local gravity = .7

function hitmarkerManager:new(value, x, y)

    local hitmarker = {}

    hitmarker.x = x
    hitmarker.y = y
    hitmarker.font = love.graphics.newFont("Fonts/PixelifySans.ttf", value*1.75) -- The size of the hitmarker scales with damage

    -- Set the velocity to shoot the hitmarker to the side
    hitmarker.velY = math.random(-7, -5)
    hitmarker.velX = math.random(0, 1)
    if hitmarker.velX == 0 then
        hitmarker.velX = -1
    end
    hitmarker.velX = hitmarker.velX * (math.random(6, 14)*.25)

    hitmarker.value = value
    hitmarker.timer = 0
    hitmarker.maxTimer = 1.5 -- in seconds
    hitmarker.timeToFade = .5

    --hitmarker.color = {value/20, 0, 0} -- redness of the hitmarker will scale with damage
    hitmarker.color = {1, 0, 0} -- TEST **

    table.insert(hitmarkers, hitmarker)
end

function hitmarkerManager:update(dt)

    for i, h in pairs(hitmarkers) do

        if h.timer >= h.maxTimer then
           hitmarkers[i] = nil
        end

        h.x = h.x + h.velX
        h.y = h.y + h.velY

        -- Decrease the x velocity according to the side it's coming from
        if h.velX > 0 then
            h.velX = h.velX - dt*10
            if h.velX < 0 then h.velX = 0.075 end
        elseif h.velX < 0 and h.velX then
            h.velX = h.velX + dt*10
            if h.velX > 0 then h.velX = -0.075 end
        end

        -- Make the hitmarker stop and float in the iar
        if h.velY < 0 then
            h.velY = h.velY + gravity*(dt*40)
        else
            h.velY = 0
        end

        -- Hitmarker fades away
        if h.timer > h.maxTimer-h.timeToFade then
            h.color = {h.color[1], 0, 0, (h.maxTimer-h.timer)/h.timeToFade} -- Always will start and full opacity and go down
        end

        h.timer = h.timer + dt
    end
end

function hitmarkerManager:draw()

    for _, h in pairs(hitmarkers) do
        love.graphics.setFont(h.font)
        love.graphics.setColor(h.color)
        love.graphics.print(h.value, h.x, h.y)
    end
end

return hitmarkerManager