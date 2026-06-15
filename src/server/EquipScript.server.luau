-- EquipScript.server.luau
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AuraManager = require(ServerStorage.Storage.AuraManager)

-- Ruta a tus auras en ServerStorage
local TIERS_PATH = ServerStorage:FindFirstChild("Assets") and ServerStorage.Assets:FindFirstChild("Tiers")

if not TIERS_PATH then
    warn("CRÍTICO: No se encontró la ruta ServerStorage.Assets.Tiers")
end

game.Players.PlayerAdded:Connect(function(player: Player)
    local playerGui = player:WaitForChild("PlayerGui")

    -- --- PARTE 1: REPLICACIÓN DE TÍTULOS PARA LA ANIMACIÓN (PROVISORIO) ---
    -- Creamos un ScreenGui oculto para guardar los clones de los TextLabels
    local storageGui = Instance.new("ScreenGui")
    storageGui.Name = "AuraTitleStorage"
    storageGui.Enabled = false -- Mantener oculto
    storageGui.ResetOnSpawn = false
    storageGui.Parent = playerGui

    local titlesFolder = Instance.new("Folder")
    titlesFolder.Name = "Titles"
    titlesFolder.Parent = storageGui

    -- Buscamos y clonamos los TextLabels de cada aura
    if TIERS_PATH then
        for _, auraFolder in ipairs(TIERS_PATH:GetChildren()) do
            -- Tu jerarquía: nombredelaura > Head > BillboardGui > Name (TextLabel)
            local head = auraFolder:FindFirstChild("Head")
            local billboard = head and head:FindFirstChild("BillboardGui")
            local nameLabel = billboard and billboard:FindFirstChild("Name")

            if nameLabel and nameLabel:IsA("TextLabel") then
                local labelClone = nameLabel:Clone()
                labelClone.Name = auraFolder.Name -- Renombramos el clon con el nombre de la aura
                labelClone.Parent = titlesFolder
            end
        end
    end


    -- --- PARTE 2: GESTIÓN DE ATRIBUTOS Y EQUIPADO SEGURO ---
    -- Asignar aura por defecto si no tiene
    if not player:GetAttribute("AuraName") then
        player:SetAttribute("AuraName", "Common")
    end

    -- Equipar cuando reaparece el personaje (muerte/reinicio)
    player.CharacterAdded:Connect(function(character: Model)
        task.wait(0.5) -- Pequeño margen de seguridad para la carga física
        local currentAura = player:GetAttribute("AuraName")
        if currentAura then
            AuraManager.EquipAura(character, currentAura)
        end
    end)

    -- SEGURO ANTI-CRASHEO (Denounce table)
    local isEquipping = {} 

    player:GetAttributeChangedSignal("AuraName"):Connect(function()
        -- Si el jugador ya se está equipando, ignoramos esta señal para evitar bucles infinitos
        if isEquipping[player] then return end 
        isEquipping[player] = true
        
        local newAura = player:GetAttribute("AuraName")
        if player.Character and newAura then
            -- print("Equipando nueva aura a " .. player.Name .. ": " .. newAura)
            AuraManager.EquipAura(player.Character, newAura)
        end
        
        task.wait(0.1) -- Tiempo de enfriamiento
        isEquipping[player] = nil -- Permitir volver a equipar
    end)
end)