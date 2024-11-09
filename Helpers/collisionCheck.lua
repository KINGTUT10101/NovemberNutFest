local function collisionCheck(x1, y1, width1, height1, x2, y2, width2, height2)
    return
    x1 < x2 + width1 and
    x1 + width1 > x2 and
    y1 < y2 + height1 and
    y1 + height1 > y2
end

return collisionCheck