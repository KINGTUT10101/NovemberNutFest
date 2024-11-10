local hitmarkerManager = {}
local hitmarkers = {}

local gravity = .7
local font = love.graphics.newFont("Fonts/PixelifySans.ttf", 20)

function hitmarkerManager:new(value, x, y)

    local hitmarker = {}

    hitmarker.x = x
    hitmarker.y = y

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

    hitmarker.color = {1, 0, 0}

    table.insert(hitmarkers, hitmarker)
end

function hitmarkerManager:update(dt)

    for i = #hitmarkers, 1, -1 do

        local h = hitmarkers[i]

        if h.timer >= h.maxTimer then
           table.remove(hitmarkers, i)
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
        love.graphics.setFont(font)
        love.graphics.setColor(h.color)
        love.graphics.print(h.value, h.x-Player.x, h.y-Player.y)
    end
end

return hitmarkerManager