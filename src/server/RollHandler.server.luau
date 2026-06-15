-- RollHandler.server.luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RollEvent = ReplicatedStorage:FindFirstChild("RollAuraEvent")
if not RollEvent then
    RollEvent = Instance.new("RemoteEvent")
    RollEvent.Name = "RollAuraEvent"
    RollEvent.Parent = ReplicatedStorage
end

local RarityDB
local dbSuccess, dbErr = pcall(function()
    RarityDB = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RarityDB"))
end)

if not dbSuccess or not RarityDB then
    warn("RollHandler CRÍTICO: No se pudo cargar RarityDB de ReplicatedStorage.Shared.RarityDB -> " .. tostring(dbErr))
end

RollEvent.OnServerEvent:Connect(function(player, auraResult)
    if RarityDB then
        if RarityDB[auraResult] then
            player:SetAttribute("AuraName", auraResult)
        else
            warn("RollHandler ADVERTENCIA: El jugador " .. player.Name .. " envio un resultado de roll invalido o inexistente en RarityDB: '" .. tostring(auraResult) .. "'")
        end
    else
        warn("RollHandler ERROR: Intento de procesar un RollEvent pero RarityDB no esta inicializado.")
    end
end)