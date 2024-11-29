local function hasEffect(table, effectName)
    for _, effectData in ipairs(table) do
        if effectData[1] == effectName then
            return true
        end
    end
    return false
end

return hasEffect