local function genericInit(enemy, x, y)

    enemy.health = 50
    enemy.amHealth = 200 -- armor health
    enemy.hasArmor = true

    -- This enemy has a different on hit function then the default
    enemy.hasNewOnHit = true

    function enemy:load()
        self.sprite = love.graphics.newImage("Graphics/enemies/armoredNone.png")
        self.sprite:setFilter("nearest", "nearest")
        self.armoredSprite = love.graphics.newImage("Graphics/enemies/armored.png")
        self.armoredSprite:setFilter("nearest", "nearest")

        enemy.body:setMass(3)
    end

    function enemy:update(dt)

    end

    function enemy:newOnHit(damage)

        print("HELLOOOO")

        if enemy.hasArmor then
            enemy.amHealth = enemy.amHealth - damage
        else
            enemy.health = enemy.health - damage
        end

        -- Armor broke off
        if enemy.amHealth <= 0 then
            enemy.hasArmor = false
            enemy.body:setMass(1)
        end
    end

    function enemy:kill()
        ItemManager:placeConsumable(ItemManager:newItem("cashew apple"), self.x, self.y)
    end

    function enemy:draw()
        -- Add death animations ect.
        if self.hasArmor then
            love.graphics.draw(self.armoredSprite, self.x, self.y)
        else
            love.graphics.draw(self.sprite, self.x, self.y)
        end
    end

    return enemy
end

return genericInit