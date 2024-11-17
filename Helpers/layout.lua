local layout = {
    origin = {
        x = 0,
        y = 0,
        rowX = 0, -- Current position within the row
        rowH = 0, -- Height of the row
        marginX = 0,
        marginY = 0,
    },
    parent = {
        x = 0,
        y = 0,
        w = 0,
        h = 0,
    }
}

function layout:setOrigin (x, y, marginX, marginY)
    self.origin.x = x
    self.origin.rowX = x
    self.origin.rowY = y
    self.origin.rowH = marginY
    self.origin.marginX = marginX
    self.origin.marginY = marginY

    -- print (x, y)
end

function layout:left (w, h)
    local startingRowX = self.origin.rowX - (w + self.origin.marginX)
    self.origin.rowX = startingRowX
    local result = {self:right (w, h)}
    self.origin.rowX = startingRowX

    return result
end

function layout:right (w, h)
    local origRowX = self.origin.rowX
    self.origin.rowX = origRowX + self.origin.marginX + w
    self.origin.rowH = math.max (self.origin.rowH, h + self.origin.marginY)

    return origRowX + self.origin.marginX / 2, self.origin.rowY + self.origin.marginY / 2, w, h
end

function layout:down (w, h)
    self.origin.rowY = self.origin.rowY + self.origin.rowH
    self.origin.rowH = self.origin.marginY
    self.origin.rowX = self.origin.x

    return self:right (w, h)
end

function layout:setParent (x, y, w, h)
    self.parent.x = x
    self.parent.y = y
    self.parent.w = w
    self.parent.h = h
end

function layout:center (w, h)
    local x = self.parent.x + (self.parent.w / 2) - (w / 2)
    local y = self.parent.y + (self.parent.h / 2) - (h / 2)

    return x, y, w, h
end

return layout