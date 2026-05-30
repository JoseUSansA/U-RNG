local module = {}

local DatosAura = {}
local VELOCIDAD_GRADIENTE = 1.5 

function module.setup(character)
    DatosAura[character] = {
        Gradients = {}
    }

    task.spawn(function()
        local Cabeza = character:WaitForChild("Head", 5)
        if not Cabeza then return end

        local att = Cabeza:WaitForChild("title", 5)
        if not att then return end

        local CartelUI = att:WaitForChild("BillboardGui", 5)
        if not CartelUI then return end

        -- Buscamos los UIGradient dentro del BillboardGui
        for _, elemento in CartelUI:GetDescendants() do
            if elemento:IsA("UIGradient") then
                table.insert(DatosAura[character].Gradients, elemento)
            end
        end
    end)
end

function module.loop(Character: Model, deltaTime: number)
    local tiempo = os.clock() * VELOCIDAD_GRADIENTE
    
    for _, characterData in DatosAura do
        for _, gradient in characterData.Gradients do
            if gradient then
                gradient.Offset = Vector2.new(math.sin(tiempo), 0)
            end
        end
    end
end

function module.cleanup(character)
    print("Limpiando gradiente de:", character.Name)
    if DatosAura[character] then
        for _, gradient in DatosAura[character].Gradients do
            if gradient then
                gradient.Offset = Vector2.new(0, 0)
            end
        end
        DatosAura[character] = nil 
    end
end

return module