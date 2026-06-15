-- EquipScript.server.luau
local ServerStorage = game:GetService("ServerStorage")
local AuraManager = require(ServerStorage.Storage.AuraManager)

game.Players.PlayerAdded:Connect(function(player: Player)
    -- 1. Asignar atributo por defecto INMEDIATAMENTE
    if not player:GetAttribute("AuraName") then
        player:SetAttribute("AuraName", "Common")
    end

    -- 2. Clonar la UI en un hilo separado (task.spawn) para que NO congele al servidor
    task.spawn(function()
        -- Le damos 10 segundos máximo para encontrar el GUI, si no, se cancela sin crashear
        local playerGui = player:WaitForChild("PlayerGui", 10)
        local assetsFolder = ServerStorage:FindFirstChild("Assets")
        
        if playerGui and assetsFolder and assetsFolder:FindFirstChild("Tiers") then
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "AuraTiersGUI"
            screenGui.ResetOnSpawn = false 
            
            local tiersClone = assetsFolder.Tiers:Clone()
            tiersClone.Parent = screenGui
            screenGui.Parent = playerGui
        end
    end)

    -- 3. Equipar al cargar el personaje
    player.CharacterAdded:Connect(function(character: Model)
        task.wait(0.5) -- Pequeño margen para asegurar que el personaje cargó sus partes físicas
        local currentAura = player:GetAttribute("AuraName")
        if currentAura then
            AuraManager.EquipAura(character, currentAura)
        end
    end)

    -- 4. Equipar al cambiar de Aura (Con seguro Anti-Recursión)
    local isEquipping = false
    player:GetAttributeChangedSignal("AuraName"):Connect(function()
        if isEquipping then return end -- Si ya está equipando, ignora la señal
        isEquipping = true
        
        local newAura = player:GetAttribute("AuraName")
        if player.Character then
            AuraManager.EquipAura(player.Character, newAura)
        end
        
        task.wait(0.1) -- Tiempo de enfriamiento
        isEquipping = false
    end)
end)