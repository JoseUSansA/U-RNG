-- RollScript.local.luau
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local RarityDB
local dbSuccess, dbErr = pcall(function()
    RarityDB = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RarityDB"))
end)
if not dbSuccess or not RarityDB then
    warn("RollScript CRÍTICO: No se pudo cargar RarityDB de ReplicatedStorage.Shared.RarityDB -> " .. tostring(dbErr))
    return
end

local RollEvent = ReplicatedStorage:WaitForChild("RollAuraEvent", 10)
if not RollEvent then
    warn("RollScript ERROR: No se encontro el RemoteEvent 'RollAuraEvent' en ReplicatedStorage tras 10 segundos")
    return
end

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
local StorageGui = PlayerGui and PlayerGui:WaitForChild("AuraTitleStorage", 10)
local TitlesFolder = StorageGui and StorageGui:WaitForChild("Titles", 10)

if not TitlesFolder then
    warn("RollScript ERROR: No se encontro la carpeta 'AuraTitleStorage.Titles' dentro del PlayerGui. El EquipScript del servidor podria haber fallado al crearla.")
    return
end

local mainRollGui = Instance.new("ScreenGui")
mainRollGui.Name = "AuraRollAnimation"
mainRollGui.ResetOnSpawn = false
mainRollGui.Parent = PlayerGui

local sortedAuras = {}
local allAuraNames = {}
for auraName, auraInfo in pairs(RarityDB) do
    table.insert(sortedAuras, {Name = auraName, Rarity = auraInfo.Rarity})
    table.insert(allAuraNames, auraName)
end

if #sortedAuras == 0 then
    warn("RollScript ADVERTENCIA: El modulo RarityDB no devolvio ninguna aura configurada.")
end

table.sort(sortedAuras, function(a, b)
    return a.Rarity > b.Rarity
end)

local isRolling = false

local function centerLabel(label)
    label.AnchorPoint = Vector2.new(0.5, 0.5)
    label.Position = UDim2.new(0.5, 0, 0.5, 0)
    label.Parent = mainRollGui
    label.Visible = true
end

local function calculateRealRoll()
    for _, aura in ipairs(sortedAuras) do
        local chance = math.random(1, aura.Rarity)
        if chance == 1 then
            return aura.Name
        end
    end
    return "Common"
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or isRolling then return end

    if input.KeyCode == Enum.KeyCode.R then
        isRolling = true

        if #allAuraNames == 0 then
            warn("RollScript ERROR: No se pueden mostrar fallos visuales porque la lista de nombres esta vacia.")
        end

        for i = 1, 5 do
            if #allAuraNames > 0 then
                local randomVisualName = allAuraNames[math.random(1, #allAuraNames)]
                local storedLabel = TitlesFolder:FindFirstChild(randomVisualName)

                if storedLabel then
                    local visualClone = storedLabel:Clone()
                    visualClone.TextTransparency = 0
                    centerLabel(visualClone)
                    task.wait(0.1)
                    visualClone:Destroy()
                else
                    warn("RollScript ADVERTENCIA: Se intento animar visualmente '" .. tostring(randomVisualName) .. "' pero su TextLabel clonado no existe en TitlesFolder.")
                    task.wait(0.1)
                end
            else
                task.wait(0.1)
            end
        end

        local finalAuraName = calculateRealRoll()
        local finalStoredLabel = TitlesFolder:FindFirstChild(finalAuraName)

        if finalStoredLabel then
            local finalVisualLabel = finalStoredLabel:Clone()
            finalVisualLabel.TextTransparency = 0
            centerLabel(finalVisualLabel)
            task.wait(2)
            finalVisualLabel:Destroy()
        else
            warn("RollScript ERROR: El RNG calculo que ganaste '" .. tostring(finalAuraName) .. "', pero no se pudo mostrar el titulo final porque no existe en TitlesFolder.")
        end

        RollEvent:FireServer(finalAuraName)
        isRolling = false
    end
end)