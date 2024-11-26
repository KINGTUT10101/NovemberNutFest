local tangereen = require ("Libraries.tangereen")
local tux = require ("Libraries.tux")

-- filepath (string) A folder containing three slices: normal, hovered, and active
local function loadSlices (filepath)
    local newSlices = {
        normal = tangereen.load (filepath .. "/normal.png"),
        hover = tangereen.load (filepath .. "/hover.png"),
        held = tangereen.load (filepath .. "/held.png"),
    }

    return newSlices
end

local slices = {
    rect = tux.utils.getDefaultSlices (),
    default = loadSlices ("Graphics/Slices/Default"),
}

return slices