-- Works with non-sequential tables
local function getTableLength (tbl)
    local length = 0

    for k, v in pairs (tbl) do
        length = length + 1
    end

    return length
end

return getTableLength