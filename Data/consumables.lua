local consumables = {}

-- Nut Oil
consumables.cashewApple = {
    health = 15,
    type = "consumable",
    object = "cashew apple",
    sprite = love.graphics.newImage("Graphics/cashewApple.png"),
    width = 8,
    height = 8,
}

function consumables.cashewApple:onConsumption(player)
    print("You ate the ".. self.object .. "... yummy.")
end

return consumables