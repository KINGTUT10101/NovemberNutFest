local gameUI = {}

local drawTextWithBorder = require("Helpers/drawTextWithBorder")
local inventoryHandler = require("Core.inventoryHandler")
local push = require("Libraries.push")
local camera = require("Libraries.hump.camera")
local hoard = require("Managers.hoard")
local font = love.graphics.newFont("Fonts/PixelifySans.ttf", 96)

gameUI.darknessLevel = 0
gameUI.maxDarkness = .8
gameUI.manualControl = false

function gameUI:load()
    -- Darkness
    Darkness = love.graphics.newShader([[
        extern number lights[768]; // Up to 128 lights, each with x, y, radius, r, g, b
        extern number num_lights;
        extern number base_opacity;

        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
        {
            vec4 pixel = vec4(0.0, 0.0, 0.0, base_opacity); // Black with base opacity
            vec3 accumulated_color = vec3(0.0);
            float accumulated_opacity = 0.0;

            for (int i = 0; i < int(num_lights); i++) {
                vec2 light_pos = vec2(lights[i * 6], lights[i * 6 + 1]);
                float light_radius = lights[i * 6 + 2];
                vec3 light_color = vec3(lights[i * 6 + 3], lights[i * 6 + 4], lights[i * 6 + 5]);

                float distance = distance(screen_coords, light_pos);

                if (distance < light_radius) {
                    float factor = 1.0 - (distance / light_radius);

                    // Blend color and accumulate opacity based on distance factor
                    accumulated_color += light_color * factor;
                    accumulated_opacity += base_opacity * factor;
                }
            }

            // Cap values to a maximum of 1.0
            accumulated_color = min(accumulated_color, vec3(1.0));
            accumulated_opacity = min(accumulated_opacity, 1.0);

            // Set the final color with blended RGB and adjusted alpha
            pixel.rgb = accumulated_color;
            pixel.a = base_opacity * (1.0 - accumulated_opacity);

            return pixel * color;
        }
    ]])
end

function gameUI:update()

    -- Day night cycle
    if not hoard.inProgress and not self.manualControl then
        self.darknessLevel = 0
    elseif hoard.inProgress and not self.manualControl then
        self.darknessLevel = self.maxDarkness
    end

    -- DEBUG ** Manual day night cycle
    if love.keyboard.isDown("n") then
        self.manualControl = true
        self.darknessLevel = self.maxDarkness
    end
    if love.keyboard.isDown("m") then
        self.manualControl = true
        self.darknessLevel = 0
    end

    local lights = {}
    local lightAmount = 0

    -- Add the players position as a light
    table.insert(lights, Player.camX+Player.width)
    table.insert(lights, Player.camY+Player.height)
    table.insert(lights, 150)
    table.insert(lights, 0)
    table.insert(lights, 0)
    table.insert(lights, 0)
    lightAmount = lightAmount + 1

    -- Add on fire enemies as a light
    for i, e in ipairs(Enemies) do
        if e.statusEffects.onFire then
            table.insert(lights, e.camX+e.width)
            table.insert(lights, e.camY+e.height)
            table.insert(lights, 120)
            table.insert(lights, 1) -- Make it red
            table.insert(lights, 0.1)
            table.insert(lights, 0.1)
            lightAmount = lightAmount + 1
        end
    end
    

    -- Update shader variables
    Darkness:send("base_opacity", self.darknessLevel)
    Darkness:send("lights", unpack(lights))
    Darkness:send("num_lights", lightAmount)
end

function gameUI:draw()

    -- Apply the shader
    love.graphics.setShader(Darkness)

    -- Draw a black rectangle covering the screen
    love.graphics.rectangle("fill", 0, 0, GAMEWIDTH, GAMEHEIGHT)

    -- Reset the shader
    love.graphics.setShader()


    -- Health
    --drawTextWithBorder("Health: " .. Player.health, 5, 5, {1,1,1}, {0,0,0}, font)

    -- Invetory Sections
    --drawTextWithBorder("Section: " .. inventoryHandler.activeSection, 5, push:getHeight()-99, {1,1,1}, {0,0,0}, font)

end


return gameUI