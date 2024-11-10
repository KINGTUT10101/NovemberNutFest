local function drawTextWithBorder(text, x, y, borderColor, textColor, font)
    local offset = 1 -- Offset for the border thickness
    
    -- Set the font if provided
    if font then
        love.graphics.setFont(font)
    end
    
    -- Draw the border by drawing the text in different directions around the main text
    love.graphics.setColor(borderColor)
    love.graphics.print(text, x - offset, y)     -- Left
    love.graphics.print(text, x + offset, y)     -- Right
    love.graphics.print(text, x, y - offset)     -- Up
    love.graphics.print(text, x, y + offset)     -- Down
    love.graphics.print(text, x - offset, y - offset) -- Top-left
    love.graphics.print(text, x + offset, y - offset) -- Top-right
    love.graphics.print(text, x - offset, y + offset) -- Bottom-left
    love.graphics.print(text, x + offset, y + offset) -- Bottom-right

    -- Draw the main text
    love.graphics.setColor(textColor)
    love.graphics.print(text, x, y)
    
    -- Reset color to white
    love.graphics.setColor(1, 1, 1)
end

return drawTextWithBorder