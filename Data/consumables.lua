local consumables = {}

-- Nut Oil
consumables.cashewApple = {
    health = 15,
    type = "consumable",
    object = "cashew apple"
}

function consumables.cashewApple:onConsumption(player)
    print("You ate the ".. self.object .. "... yummy.")
end

return consumables