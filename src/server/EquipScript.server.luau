-- EquipScript.server.luau
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AuraManager = require(ServerStorage.Storage.AuraManager)

-- NUEVO: Crear carpeta segura para que el cliente acceda a los títulos
local assetsFolder = ServerStorage:FindFirstChild("Assets")
if assetsFolder and assetsFolder:FindFirstChild("Tiers") then
    local clientHeadsFolder = ReplicatedStorage:FindFirstChild("ClientRollHeads")
    if not clientHeadsFolder then
        clientHeadsFolder = Instance.new("Folder")
        clientHeadsFolder.Name = "ClientRollHeads"
        clientHeadsFolder.Parent = ReplicatedStorage
    end
    
    -- Clonamos SOLO las cabezas que tienen los BillboardGuis y TextLabels
    for _, auraFolder in ipairs(assetsFolder.Tiers:GetChildren()) do
        local headPart = auraFolder:FindFirstChild("Head")
        if headPart then
            local headClone = headPart:Clone()
            headClone.Name = auraFolder.Name -- Renombramos la parte con el nombre de la aura
            headClone.Parent = clientHeadsFolder
        end
    end
else
    warn("No se encontró ServerStorage > Assets > Tiers para clonar títulos.")
end

-- Funcionalidad de equipar auras
game.Players.PlayerAdded:Connect(function(player: Player)
    -- Asignar aura por defecto al conectarse
    if not player:GetAttribute("AuraName") then
        player:SetAttribute("AuraName", "Common")
    end

    -- Equipar cuando reaparece el personaje (muerte/reinicio)
    player.CharacterAdded:Connect(function(character: Model)
        task.wait(0.5) -- Pequeño margen para asegurar que el personaje cargó
        local currentAura = player:GetAttribute("AuraName")
        if currentAura then
            AuraManager.EquipAura(character, currentAura)
        end
    end)

    -- SEGURO DEFINITIVO ANTI-CRASHEO (Denounce table)
    local isEquipping = {} -- Tabla para rastrear si cada jugador está en proceso de equipar
    player:GetAttributeChangedSignal("AuraName"):Connect(function()
        -- Si el jugador ya se está equipando, ignoramos esta señal para evitar bucles infinitos
        if isEquipping[player] then return end 
        isEquipping[player] = true
        
        local newAura = player:GetAttribute("AuraName")
        if player.Character and newAura then
            print("Equipando nueva aura a " .. player.Name .. ": " .. newAura)
            AuraManager.EquipAura(player.Character, newAura)
        end
        
        task.wait(0.1) -- Tiempo de enfriamiento
        isEquipping[player] = nil -- Permitir volver a equipar
    end)
end)