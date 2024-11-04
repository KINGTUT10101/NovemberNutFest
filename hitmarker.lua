local hitmarkerManager = {}
local hitmarkers = {}



function hitmarkerManager:new(value, base, x, y)

    local hitmarker = {}

    hitmarker.x = x
    hitmarker.y = y
    hitmarker.base = base -- Where the hitmarker will fall to
    hitmarker.font = love.graphics.newFont("Fonts/PixelifySans.ttf", value*1.75)

    -- Set the velocity to shoot the hitmarker to the side
    hitmarker.velY = math.random(-8, -5)
    hitmarker.velX = math.random(0, 1)
    if hitmarker.velX == 0 then
        hitmarker.velX = -1
    end
    hitmarker.velX = hitmarker.velX * (math.random(6, 10)*.25)

    hitmarker.value = value
    hitmarker.timer = 60*2 -- 2 seconds

    hitmarker.color = {150+value, 0, 0}

    table.insert(hitmarkers, hitmarker)
end

function hitmarkerManager:update()

    for i, h in pairs(hitmarkers) do

        if h.timer <= 0 then
           table.remove(hitmarkers, i)
        end

        h.x = h.x + h.velX
        h.y = h.y + h.velY

        -- Decrease the x velocity according to the side it's coming from
        if h.velX > 0 then
            h.velX = h.velX - .1
        elseif h.velX < 0 then
            h.velX = h.velX + .1
        end

        if h.velY ~=0 then
            h.velY = h.velY + 1
        end

        if h.timer < 50 then
            h.color = {h.color[1], 0, 0, (h.timer*2)/100}
        end

        h.timer = h.timer - 1
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