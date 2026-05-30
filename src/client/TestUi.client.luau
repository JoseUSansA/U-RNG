local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Asegúrate de que la ruta sea correcta
local AuraDB = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RarityDB"))

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ==========================================
-- 1. CREACIÓN DE LA UI BASE
-- ==========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AuraDBTestUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(0.4, 0, 0.8, 0)
scrollingFrame.Position = UDim2.new(0.3, 0, 0.1, 0)
scrollingFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 8
scrollingFrame.Parent = screenGui

local uiPadding = Instance.new("UIPadding")
uiPadding.PaddingTop = UDim.new(0, 10)
uiPadding.PaddingLeft = UDim.new(0, 10)
uiPadding.PaddingRight = UDim.new(0, 10)
uiPadding.Parent = scrollingFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 10)
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Parent = scrollingFrame

-- ==========================================
-- 2. FUNCIÓN AUXILIAR DE NOMBRES
-- ==========================================
local function GetNamesFromIds(ids)
    if not ids then return nil end
    
    if type(ids) == "table" then
        local names = {}
        for _, id in ipairs(ids) do
            local success, name = pcall(function()
                return Players:GetNameFromUserIdAsync(id)
            end)
            table.insert(names, success and name or tostring(id))
        end
        return table.concat(names, ", ")
    end
    
    local success, name = pcall(function()
        return Players:GetNameFromUserIdAsync(ids)
    end)
    return success and name or tostring(ids)
end

-- ==========================================
-- 3. POBLAR LA INTERFAZ
-- ==========================================
for auraName, info in pairs(AuraDB) do
    -- Usamos task.spawn para evitar que la UI se congele mientras carga los nombres
    task.spawn(function()
        local card = Instance.new("TextLabel")
        card.Size = UDim2.new(1, 0, 0, 120)
        card.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        card.TextColor3 = Color3.fromRGB(255, 255, 255)
        card.TextSize = 14
        card.RichText = true
        card.TextXAlignment = Enum.TextXAlignment.Left
        card.TextYAlignment = Enum.TextYAlignment.Top
        card.Parent = scrollingFrame
        
        -- Añadimos un poco de margen interno a la tarjeta
        local cardPadding = Instance.new("UIPadding")
        cardPadding.PaddingTop = UDim.new(0, 10)
        cardPadding.PaddingLeft = UDim.new(0, 10)
        cardPadding.Parent = card

        -- Texto temporal de carga
        card.Text = `<b>{auraName}</b>\nCargando datos...`

        -- Procesar datos
        local creatorName = GetNamesFromIds(info.CreatorId)
        local conceptName = GetNamesFromIds(info.ConceptId)
        local audioText = info.AudioInfo and `'{info.AudioInfo.Name}' por {info.AudioInfo.Author}` or "Sin audio personalizado"
        
        -- Actualizar texto con los datos reales
        card.Text = string.format(
            "<b>%s</b>\n<font color='#aaffaa'>Rareza:</font> 1 en %s\n<font color='#aaaaff'>Creador:</font> %s\n<font color='#ffaaaa'>Concepto:</font> %s\n<font color='#ffffaa'>Música:</font> %s",
            auraName,
            tostring(info.Rarity),
            creatorName or "No definido",
            conceptName or "No definido",
            audioText
        )
        
        -- Ajustar el tamaño del Canvas del ScrollingFrame para que se pueda bajar
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y + 20)
    end)
end