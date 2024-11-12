local gameUI = {}

local drawTextWithBorder = require("Helpers/drawTextWithBorder")
local inventoryHandler = require("Core.inventoryHandler")
local font = love.graphics.newFont("Fonts/PixelifySans.ttf", 32)

function gameUI:load()
    -- Darkness
    Darkness = love.graphics.newShader([[
        extern vec2 light_positions[16]; // Up to 16 light sources
        extern number light_radii[16];
        extern number num_lights;
        extern number base_opacity;

        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
        {
            vec4 pixel = vec4(0.0, 0.0, 0.0, base_opacity); // Black with base opacity
            
            float min_opacity = base_opacity;
            
            for (int i = 0; i < int(num_lights); i++) {
                float distance = distance(screen_coords, light_positions[i]);
                
                if (distance < light_radii[i]) {
                    float factor = 1.0 - (distance / light_radii[i]);
                    // Take the minimum opacity between current minimum and this light's contribution
                    min_opacity = min(min_opacity, base_opacity * (1.0 - factor));
                }
            }
            
            pixel.a = min_opacity;
            return pixel * color;
        }
    ]])

    Darkness:send("base_opacity", 0.8)

    LightSources = {
        {x = 1920/2, y = 1080/2, radius = 150}
    }
end

    -- Send light positions and radii to the shader
    local positions = {}
    local radii = {}

function gameUI:update()


    for i, light in ipairs(LightSources) do
        positions[(i - 1) * 2 + 1] = light.x
        positions[(i - 1) * 2 + 2] = light.y
        radii[i] = light.radius
    end
    Darkness:send("light_positions", positions)
    Darkness:send("light_radii", unpack(radii))
    Darkness:send("num_lights", #LightSources)
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