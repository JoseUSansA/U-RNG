-- RollScript.local.luau
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local RarityDB = require(ReplicatedStorage.Shared.RarityDB)
local RollEvent = ReplicatedStorage:WaitForChild("RollAuraEvent")

-- Buscar la carpeta que el servidor preparó para nosotros en ReplicatedStorage
local ClientHeadsFolder = ReplicatedStorage:WaitForChild("ClientRollHeads")

-- Ordenar las auras de mayor a menor rareza
local sortedAuras = {}
for auraName, auraInfo in pairs(RarityDB) do
    table.insert(sortedAuras, {Name = auraName, Rarity = auraInfo.Rarity})
end

table.sort(sortedAuras, function(a, b)
    return a.Rarity > b.Rarity
end)

local isRolling = false

-- Función del RNG
local function calculateRoll()
    for _, aura in ipairs(sortedAuras) do
        local chance = math.random(1, aura.Rarity)
        if chance == 1 then
            return aura.Name 
        end
    end
    return "Common" 
end

-- Detectar tecla 'R'
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or isRolling then return end

    if input.KeyCode == Enum.KeyCode.R then
        isRolling = true
        
        -- Animación de los 5 primeros destellos
        for i = 1, 5 do
            local randomVisualAura = sortedAuras[math.random(1, #sortedAuras)].Name
            local headClone = ClientHeadsFolder:FindFirstChild(randomVisualAura)
            
            if headClone then
                -- TU JERARQUÍA: Head > BillboardGui > Name (TextLabel)
                local nameLabel = headClone:FindFirstChild("BillboardGui") and headClone.BillboardGui:FindFirstChild("Name")
                
                if nameLabel and nameLabel:IsA("TextLabel") then
                    nameLabel.Visible = true
                    task.wait(0.1)
                    nameLabel.Visible = false
                else
                    task.wait(0.1)
                end
            else
                task.wait(0.1)
            end
        end
        
        -- Calcular el 6to resultado (el real) y mostrarlo
        local finalAura = calculateRoll()
        
        local finalHead = ClientHeadsFolder:FindFirstChild(finalAura)
        if finalHead then
            -- TU JERARQUÍA FINAL
            local finalNameLabel = finalHead:FindFirstChild("BillboardGui") and finalHead.BillboardGui:FindFirstChild("Name")
            
            if finalNameLabel and finalNameLabel:IsA("TextLabel") then
                finalNameLabel.Visible = true
                task.wait(2) -- Queda en pantalla 2 segundos
                finalNameLabel.Visible = false
            end
        end
        
        -- Enviar al servidor el resultado real
        RollEvent:FireServer(finalAura)
        
        isRolling = false
    end
end)