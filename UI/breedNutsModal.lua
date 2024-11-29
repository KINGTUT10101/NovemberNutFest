local tux = require ("Libraries.tux")
local layout = require ("Helpers.layout")
local icons = require ("Helpers.icons")
local Nut = require ("Core.Nut")

local compW, compH = 350, 200

-- breedConfirmFunc is a function that has one argument: The nut produced from cross breeding
local function breedNutsModal (selectedNuts, breedConfirmFunc)
    layout:setParent (0, 0, GAMEWIDTH, GAMEHEIGHT)

    -- Start button
    local centeredPos = {layout:center (300, 0)}
    layout:setOrigin (centeredPos[1], 525, 0, 0)

    if #selectedNuts >= 2 then
        if tux.show.button ({
            text = "Breed Nuts",
            fsize = 26,
        }, layout:right (300, 100)) == "end" then
            breedConfirmFunc (Nut:new (selectedNuts[1], selectedNuts[2]))
        end
    else
        tux.show.button ({
            text = "Select (" .. 2 - #selectedNuts .. ") More Nuts",
            fsize = 26,
            colors = {0.5, 0.5, 0.5, 1}
        }, layout:right (300, 100))
    end
    
    -- Background
    tux.show.label ({
        text = "Select Parents For Cross Breeding",
        valign = "top",
        fsize = 28,
        padding = {padAll = 10}
    }, layout:center (compW, compH))
end

return breedNutsModal