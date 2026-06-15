-- RollHandler.server.luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RollEvent = ReplicatedStorage:WaitForChild("RollAuraEvent")
local RarityDB = require(ReplicatedStorage.Shared.RarityDB)

RollEvent.OnServerEvent:Connect(function(player, auraResult)
    -- Medida de seguridad básica: verificar que el aura existe en la base de datos
    if RarityDB[auraResult] then
        -- Esto actualizará el atributo individual del jugador,
        -- lo cual disparará automáticamente el equipado en tu EquipScript.
        player:SetAttribute("AuraName", auraResult)
    end
end)