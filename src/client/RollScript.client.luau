-- RollScript.local.luau
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local RarityDB = require(ReplicatedStorage.Shared.RarityDB)
local RollEvent = ReplicatedStorage:WaitForChild("RollAuraEvent")

-- Buscar la carpeta clonada en el PlayerGui del jugador local
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local AuraTiersGUI = PlayerGui:WaitForChild("AuraTiersGUI")
local TiersFolder = AuraTiersGUI:WaitForChild("Tiers")

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
            local auraFolder = TiersFolder:FindFirstChild(randomVisualAura)
            
            if auraFolder then
                -- BUSCAMOS EL TEXTLABEL DENTRO DE LA CARPETA
                local textLabel = auraFolder:FindFirstChildWhichIsA("TextLabel")
                
                if textLabel then
                    textLabel.Visible = true
                    task.wait(0.1)
                    textLabel.Visible = false
                else
                    task.wait(0.1) -- Mantiene el ritmo si la carpeta está vacía
                end
            else
                task.wait(0.1) -- Mantiene el ritmo si la carpeta no existe
            end
        end
        
        -- Calcular el 6to resultado (el real) y mostrarlo
        local finalAura = calculateRoll()
        
        local finalFolder = TiersFolder:FindFirstChild(finalAura)
        if finalFolder then
            -- BUSCAMOS EL TEXTLABEL DENTRO DE LA CARPETA FINAL
            local finalTextLabel = finalFolder:FindFirstChildWhichIsA("TextLabel")
            
            if finalTextLabel then
                finalTextLabel.Visible = true
                task.wait(2) -- Queda en pantalla 2 segundos
                finalTextLabel.Visible = false
            end
        end
        
        -- Enviar al servidor el resultado real
        RollEvent:FireServer(finalAura)
        
        isRolling = false
    end
end)