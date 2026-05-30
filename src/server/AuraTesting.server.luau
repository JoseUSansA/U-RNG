local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Asegúrate de que la ruta coincida con la ubicación de tu módulo
local AuraDB = require(ReplicatedStorage.Shared.RarityDB) 

print("==============================")
print("INICIANDO PRUEBA DE BASE DE DATOS DE AURAS")
print("==============================\n")

-- Función auxiliar para obtener el nombre (o nombres) desde el ID
local function GetCreatorNames(creatorId)
    if not creatorId then return "No definido" end
    
    -- Si es una tabla con múltiples IDs
    if type(creatorId) == "table" then
        local names = {}
        for _, id in ipairs(creatorId) do
            local success, name = pcall(function()
                return Players:GetNameFromUserIdAsync(id)
            end)
            -- Si falla, muestra el ID numérico; si funciona, muestra el nombre
            table.insert(names, success and name or tostring(id))
        end
        return table.concat(names, ", ")
    end
    
    -- Si es un solo ID numérico
    local success, name = pcall(function()
        return Players:GetNameFromUserIdAsync(creatorId)
    end)
    
    return success and name or tostring(creatorId)
end

for auraName, info in pairs(AuraDB) do
    print(`[ Aura: {auraName} ]`)
    print(` > Rareza: 1 en {info.Rarity}`)
    
    -- Convertimos el ID a nombre aquí
    local creatorName = GetCreatorNames(info.CreatorId)
    
    -- Manejo visual por si la tabla de múltiples IDs se imprime raro al concatenar
    local idString = type(info.CreatorId) == "table" and "Múltiples IDs" or (info.CreatorId or "N/A")
    print(` > Creador: {creatorName} (ID: {idString})`)
    
    if info.AudioInfo then
        print(` > Música: '{info.AudioInfo.Name}' por {info.AudioInfo.Author}`)
    else
        print(` > Música: Sin audio personalizado`)
    end
    
    print("------------------------------")
end

print("\n¡Prueba finalizada con éxito!")