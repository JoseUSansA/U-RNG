local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Asegúrate de que la ruta coincida con la ubicación de tu módulo
local AuraDB = require(ReplicatedStorage.Shared.RarityDB) 

print("==============================")
print("INICIANDO PRUEBA DE BASE DE DATOS DE AURAS")
print("==============================\n")

-- Función auxiliar genérica para obtener nombres desde uno o varios IDs
local function GetNamesFromIds(ids)
    if not ids then return nil end -- Retorna nil si no hay ID configurado
    
    -- Si es una tabla con múltiples IDs
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
    
    -- Si es un solo ID numérico
    local success, name = pcall(function()
        return Players:GetNameFromUserIdAsync(ids)
    end)
    
    return success and name or tostring(ids)
end

for auraName, info in pairs(AuraDB) do
    print(`[ Aura: {auraName} ]`)
    print(` > Rareza: 1 en {info.Rarity}`)
    
    -- Procesar Creador
    local creatorName = GetNamesFromIds(info.CreatorId)
    local creatorIdString = type(info.CreatorId) == "table" and "Múltiples IDs" or (info.CreatorId or "N/A")
    print(` > Creador: {creatorName or "No definido"} (ID: {creatorIdString})`)
    
    -- Procesar Creador del Concepto
    local conceptName = GetNamesFromIds(info.ConceptId)
    if conceptName then
        local conceptIdString = type(info.ConceptId) == "table" and "Múltiples IDs" or info.ConceptId
        print(` > Concepto por: {conceptName} (ID: {conceptIdString})`)
    else
        print(` > Concepto por: No definido`)
    end
    
    -- Procesar Audio
    if info.AudioInfo then
        print(` > Música: '{info.AudioInfo.Name}' por {info.AudioInfo.Author}`)
    else
        print(` > Música: Sin audio personalizado`)
    end
    
    print("------------------------------")
end

print("\n¡Prueba finalizada con éxito!")