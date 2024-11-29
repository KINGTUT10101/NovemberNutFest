local consumables = {}

-- Cashew Apple
consumables.cashewApple = {
    health = 15,
    type = "consumable",
    object = "cashew apple",
    sprite = love.graphics.newImage("Graphics/cashewApple.png"),
    width = 8,
    height = 8,
}

function consumables.cashewApple:onConsumption()
    if Player.health+self.health < Player.maxHealth then
        Player.health = Player.health+self.health
    else
        Player.health = Player.health+(Player.maxHealth-Player.health)
    end
end

return consumables