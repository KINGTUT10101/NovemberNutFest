local copyTable = require ("Helpers.copyTable")

-- Sets default values for an object based on the provided keys/values in the default object
local function setDefaults (defaultObj, newObj)
    for key, value in pairs (defaultObj) do
        if newObj[key] == nil then
            newObj[key] = copyTable (value)
        end
    end
end

return setDefaults