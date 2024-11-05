local throwables = {}

-- Nut Oil
throwables.nutOil = {
    projVelocity = 4,
    type = "throwable",
    object = "nut oil",
    width = 6,
    height = 12,
}

function throwables.nutOil:onCollision(x, y)
    print("The nut oil went everywhere!!!\nAHHHH!!!!!")
    -- Go through enemies, give them a status effect
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