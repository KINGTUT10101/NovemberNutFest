local function mapToScale (number, inMin, inMax, outMin, outMax) 
    return (number - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
end

return mapToScale