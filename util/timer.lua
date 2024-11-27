local copyTable = require("Helpers.copyTable")

local timer = {}

timer.max = 0
timer.time = 0

function timer:add(dt)
    self.time = self.time + dt
end

function timer:reset()
    timer.time = 0
end

return copyTable(timer)