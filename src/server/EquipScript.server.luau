-- EquipScript.server.luau
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AuraManager
local success, err = pcall(function()
    AuraManager = require(ServerStorage:WaitForChild("Storage"):WaitForChild("AuraManager"))
end)
if not success or not AuraManager then
    warn("EquipScript CRÍTICO: No se pudo cargar el modulo AuraManager. Verifica la ruta ServerStorage.Storage.AuraManager -> " .. tostring(err))
end

local assetsFolder = ServerStorage:FindFirstChild("Assets")
local tiersPath = assetsFolder and assetsFolder:FindFirstChild("Tiers")
if not tiersPath then
    warn("EquipScript ERROR: No se encontro la carpeta fisica de las auras en ServerStorage.Assets.Tiers")
end

game.Players.PlayerAdded:Connect(function(player: Player)
    local playerGui = player:WaitForChild("PlayerGui", 10)
    if not playerGui then
        warn("EquipScript ERROR: Tiempo de espera agotado (10s) para encontrar el PlayerGui de " .. player.Name)
        return
    end

    local storageGui = Instance.new("ScreenGui")
    storageGui.Name = "AuraTitleStorage"
    storageGui.Enabled = false
    storageGui.ResetOnSpawn = false
    storageGui.Parent = playerGui

    local titlesFolder = Instance.new("Folder")
    titlesFolder.Name = "Titles"
    titlesFolder.Parent = storageGui

    if tiersPath then
        local foundAny = false
        for _, auraFolder in ipairs(tiersPath:GetChildren()) do
            local head = auraFolder:FindFirstChild("Head")
            local billboard = head and head:FindFirstChild("BillboardGui")
            local nameLabel = billboard and billboard:FindFirstChild("Name")

            if nameLabel and nameLabel:IsA("TextLabel") then
                local labelClone = nameLabel:Clone()
                labelClone.Name = auraFolder.Name
                labelClone.Parent = titlesFolder
                foundAny = true
            else
                warn("EquipScript ADVERTENCIA: Al aura '" .. auraFolder.Name .. "' le falta la jerarquia exacta -> Head > BillboardGui > Name (TextLabel)")
            end
        end
        if not foundAny then
            warn("EquipScript ERROR: No se pudo clonar ningun TextLabel de ServerStorage.Assets.Tiers. La carpeta podria estar vacia.")
        end
    end

    if not player:GetAttribute("AuraName") then
        player:SetAttribute("AuraName", "Common")
    end

    player.CharacterAdded:Connect(function(character: Model)
        task.wait(0.5)
        local currentAura = player:GetAttribute("AuraName")
        if currentAura and AuraManager then
            local ok, equipErr = pcall(function()
                AuraManager.EquipAura(character, currentAura)
            end)
            if not ok then
                warn("EquipScript ERROR: AuraManager fallo internamente al equipar el aura inicial '" .. tostring(currentAura) .. "' -> " .. tostring(equipErr))
            end
        end
    end)

    local isEquipping = false
    player:GetAttributeChangedSignal("AuraName"):Connect(function()
        if isEquipping then return end
        isEquipping = true

        local newAura = player:GetAttribute("AuraName")
        if player.Character and newAura and AuraManager then
            local ok, equipErr = pcall(function()
                AuraManager.EquipAura(player.Character, newAura)
            end)
            if not ok then
                warn("EquipScript ERROR: AuraManager fallo internamente al equipar la nueva aura '" .. tostring(newAura) .. "' -> " .. tostring(equipErr))
            end
        end

        task.wait(0.1)
        isEquipping = false
    end)
end)