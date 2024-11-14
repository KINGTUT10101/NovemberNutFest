local gameUI = {}

local drawTextWithBorder = require("Helpers/drawTextWithBorder")
local inventoryHandler = require("Core.inventoryHandler")
local font = love.graphics.newFont("Fonts/PixelifySans.ttf", 32)

DarknessLevel = 0.8

function gameUI:load()
    -- Darkness
    Darkness = love.graphics.newShader([[
        extern number lights[384]; // Up to 64 lights, each with x, y, radius, r, g, b
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

    LightSources = {
        {x = (Player.camX*Scale)+((Player.width/2)*Scale), y = (Player.camY*Scale)+((Player.height/2)*Scale), radius = 150, r=0, g=0, b=0}
    }
end

    -- Send light positions and radii to the shader
    local positions = {}
    local radii = {}

function gameUI:addLight(x, y, strength, r, g, b)
    LightSources[#LightSources+1] = {
        x = x,
        y = y,
        radius = strength,
        r = r,
        g = g,
        b = b,
    }
end

function gameUI:update()

    -- Day
    if love.keyboard.isDown("m") then
        DarknessLevel = 0
    end
    -- Night
    if love.keyboard.isDown("n") then
        DarknessLevel = .9
    end

    local lights = {}
    local lightAmount = 0

    -- Add on fire enemies as a light
    for i, e in ipairs(Enemies) do
        if e.statusEffects.onFire then
            table.insert(lights, ((e.x-Player.x)*Scale)+(e.width*Scale)/2)
            table.insert(lights, ((e.y-Player.y)*Scale)+(e.height*Scale)/2)
            table.insert(lights, 125)
            table.insert(lights, 1) -- Make it red
            table.insert(lights, 0.1)
            table.insert(lights, 0.1)
            lightAmount = lightAmount + 1
        end
    end

    -- Prepare combined light data array for the shader
    
    for _, light in ipairs(LightSources) do
        table.insert(lights, light.x)
        table.insert(lights, light.y)
        table.insert(lights, light.radius)
        table.insert(lights, light.r)
        table.insert(lights, light.g)
        table.insert(lights, light.b)
        lightAmount = lightAmount + 1
    end

    -- Update shader variables
    Darkness:send("base_opacity", DarknessLevel)
    Darkness:send("lights", unpack(lights))
    Darkness:send("num_lights", lightAmount)
end

function gameUI:draw()

    -- Apply the shader
    love.graphics.setShader(Darkness)

    -- Draw a black rectangle covering the screen
    love.graphics.rectangle("fill", 0, 0, ScaledGameWidth, ScaledGameHeight)

    -- Reset the shader
    love.graphics.setShader()
    

    -- Health
    drawTextWithBorder("Health: " .. Player.health, 5, 5, {1,1,1}, {0,0,0}, font)

    -- Invetory Sections
    drawTextWithBorder("Section: " .. inventoryHandler.activeSection, 5, ScaledGameHeight-37, {1,1,1}, {0,0,0}, font)
end


return gameUI