-- EquipScript.server.luau
local ServerStorage = game:GetService("ServerStorage")
local AuraManager = require(ServerStorage.Storage.AuraManager)

game.Players.PlayerAdded:Connect(function(player: Player)
    local playerGui = player:WaitForChild("PlayerGui")
    local assetsFolder = ServerStorage:FindFirstChild("Assets")
    
    if assetsFolder and assetsFolder:FindFirstChild("Tiers") then
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "AuraTiersGUI"
        screenGui.ResetOnSpawn = false
        
        local tiersClone = assetsFolder.Tiers:Clone()
        tiersClone.Parent = screenGui
        screenGui.Parent = playerGui
    else
        warn("No se encontró la ruta ServerStorage > Assets > Tiers")
    end

    if not player:GetAttribute("AuraName") then
        player:SetAttribute("AuraName", "Common")
    end

    player.CharacterAdded:Connect(function(character: Model)
        local currentAura = player:GetAttribute("AuraName")
        if currentAura then
            AuraManager.EquipAura(character, currentAura)
        end
    end)

    player:GetAttributeChangedSignal("AuraName"):Connect(function()
        local newAura = player:GetAttribute("AuraName")
        if player.Character then
            AuraManager.EquipAura(player.Character, newAura)
        end
    end)
end)