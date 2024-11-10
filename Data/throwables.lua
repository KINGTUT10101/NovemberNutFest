local throwables = {}

-- Nut Oil
throwables.nutOil = {
    projVelocity = 4,
    type = "throwable",
    object = "nut oil",
    width = 6,
    height = 12,
    splashRadius = 150,
    sprite = love.graphics.newImage("Graphics/nutOil.png")
}

function throwables.nutOil:onCollision(x, y)
    -- Go through enemies, give them a status effect
    for _, e in pairs(Enemies) do
        if e:collisionCheck(x-(self.splashRadius/2), y-(self.splashRadius/2), self.splashRadius, self.splashRadius) then
            e.statusEffects.oiled = true
        end
    end
end


-- Nut Butter
throwables.nutButter = {
    projVelocity = 4,
    type = "throwable",
    object = "nut butter"
}

function throwables.nutButter:onCollision(x, y)
    print("The nut butter went everywhere!!!\nAHHHH!!!!!")
    -- Go through enemies, give them a status effect
end


return throwables