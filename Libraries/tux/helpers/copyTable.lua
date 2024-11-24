local function deepCopy(original, seen)
    -- Initialize the seen table if this is the first call
    seen = seen or {}
    
    -- Handle non-table values
    if type(original) ~= "table" then
        return original
    end
    
    -- If we've seen this table before, return the copy we already made
    if seen[original] then
        return seen[original]
    end
    
    -- Get the metatable of the original
    local meta = getmetatable(original)
    
    -- Create new table and store it in seen
    local copy = {}
    seen[original] = copy
    
    -- Copy all key-value pairs recursively
    for key, value in pairs(original) do
        -- Handle table keys
        if type(key) == "table" then
            key = deepCopy(key, seen)
        end
        -- Handle table values
        if type(value) == "table" then
            value = deepCopy(value, seen)
        end
        copy[key] = value
    end
    
    -- Set the metatable if it exists
    if meta then
        setmetatable(copy, deepCopy(meta, seen))
    end
    
    return copy
end

return deepCopy