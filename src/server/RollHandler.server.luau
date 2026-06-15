-- RollHandler.server.luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Crear el RemoteEvent automáticamente si no existe
local RollEvent = ReplicatedStorage:FindFirstChild("RollAuraEvent")
if not RollEvent then
    RollEvent = Instance.new("RemoteEvent")
    RollEvent.Name = "RollAuraEvent"
    RollEvent.Parent = ReplicatedStorage
end

local RarityDB = require(ReplicatedStorage.Shared.RarityDB)

RollEvent.OnServerEvent:Connect(function(player, auraResult)
    -- Verificar que el jugador nos envió un aura que realmente existe
    if RarityDB[auraResult] then
        -- Esto actualizará el atributo individual del jugador,
        -- lo cual disparará la función de equipar en tu EquipScript.
        player:SetAttribute("AuraName", auraResult)
    end
end)