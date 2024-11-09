local function contains(table, str)
    for _, value in ipairs(table) do
        if value == str then
            return true
        end
    end
    return false
end

return contains