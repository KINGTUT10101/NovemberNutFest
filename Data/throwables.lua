local throwables = {}

-- Nut Oil
throwables.nutOil = {
    projVelocity = 4,
    type = "throwable",
    object = "nut oil"
}

function throwables.nutOil:onCollision(x, y)
    print("The nut oil went everywhere!!!\nAHHHH!!!!!")
end


-- Nut Butter
throwables.nutButter = {
    projVelocity = 4,
    type = "throwable",
    object = "nut butter"
}

function throwables.nutButter:onCollision(x, y)
    print("The nut butter went everywhere!!!\nAHHHH!!!!!")
end


return throwables