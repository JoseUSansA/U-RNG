-- RollScript.local.luau
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local RarityDB = require(ReplicatedStorage.Shared.RarityDB)
local RollEvent = ReplicatedStorage:WaitForChild("RollAuraEvent")

-- Referencias a la carpeta de títulos que el servidor nos preparó
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local StorageGui = PlayerGui:WaitForChild("AuraTitleStorage")
local TitlesFolder = StorageGui:WaitForChild("Titles")

-- Crear un ScreenGui principal para mostrar la animación en el centro
local mainRollGui = Instance.new("ScreenGui")
mainRollGui.Name = "AuraRollAnimation"
mainRollGui.ResetOnSpawn = false
mainRollGui.Parent = PlayerGui

-- --- 1. ORDENAR AURAS DE MAYOR A MENOR RAREZA (Para el cálculo real) ---
local sortedAuras = {}
local allAuraNames = {} -- Para elegir "fallos" al azar
for auraName, auraInfo in pairs(RarityDB) do
    table.insert(sortedAuras, {Name = auraName, Rarity = auraInfo.Rarity})
    table.insert(allAuraNames, auraName)
end

table.sort(sortedAuras, function(a, b)
    return a.Rarity > b.Rarity
end)

local isRolling = false


-- --- FUNCIÓN DE UTILIDAD: CENTRAR UN TEXTLABEL ---
local function centerLabel(label)
    label.AnchorPoint = Vector2.new(0.5, 0.5)
    label.Position = UDim2.new(0.5, 0, 0.5, 0) -- Centro absoluto
    label.Parent = mainRollGui
    label.Visible = true
end


-- --- FUNCIÓN DEL RNG REAL ---
local function calculateRealRoll()
    for _, aura in ipairs(sortedAuras) do
        local chance = math.random(1, aura.Rarity)
        if chance == 1 then
            return aura.Name 
        end
    end
    return "Common" 
end


-- --- DETECTAR TECLA 'R' ---
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or isRolling then return end

    if input.KeyCode == Enum.KeyCode.R then
        isRolling = true
        
        -- --- 2. ANIMACIÓN DE GIRO (5 FALLOS TOTALMENTE AL AZAR) ---
        for i = 1, 5 do
            -- Elegimos un aura totalmente al azar para el efecto visual
            local randomVisualName = allAuraNames[math.random(1, #allAuraNames)]
            local storedLabel = TitlesFolder:FindFirstChild(randomVisualName)
            
            if storedLabel then
                -- Clonamos el título visual para mostrarlo en el ScreenGui principal
                local visualClone = storedLabel:Clone()
                visualClone.TextTransparency = 0 -- Asegurar que sea visible
                centerLabel(visualClone)
                
                task.wait(0.1) -- Duración del destello
                
                visualClone:Destroy() -- Lo destruimos inmediatamente
            else
                task.wait(0.1) -- Mantener el ritmo si falta el título
            end
        end
        
        -- --- 3. CALCULAR RESULTADO REAL Y MOSTRARLO ---
        local finalAuraName = calculateRealRoll()
        -- print("¡Te ha tocado (Cálculo Real): " .. finalAuraName .. "!")
        
        local finalStoredLabel = TitlesFolder:FindFirstChild(finalAuraName)
        if finalStoredLabel then
            -- Clonamos y centramos el título del aura ganadora
            local finalVisualLabel = finalStoredLabel:Clone()
            finalVisualLabel.TextTransparency = 0
            centerLabel(finalVisualLabel)
            
            -- Opcional: Podrías añadir un efecto de sonido aquí
            
            task.wait(2) -- Queda en pantalla 2 segundos
            finalVisualLabel:Destroy()
        end
        
        -- --- 4. ENVIAR RESULTADO AL SERVIDOR PARA EQUIPAR ---
        RollEvent:FireServer(finalAuraName)
        
        isRolling = false
    end
end)