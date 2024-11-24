local icons = {}

local dirItems = love.filesystem.getDirectoryItems ("Graphics/Icons")
for _, v in pairs (dirItems) do
    icons[v:sub (1, -5)] = love.graphics.newImage ("Graphics/Icons/" .. v)
end

return icons