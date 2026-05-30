local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Asegúrate de que la ruta coincida con la ubicación de tu módulo
local AuraDB = require(ReplicatedStorage.Shared.RarityDB) 

print("==============================")
print("INICIANDO PRUEBA DE BASE DE DATOS DE AURAS")
print("==============================\n")

for auraName, info in pairs(AuraDB) do
    print(`[ Aura: {auraName} ]`)
    print(` > Rareza: 1 en {info.Rarity}`)
    print(` > Creador (ID): {info.CreatorId or "No definido"}`)
    
    if info.AudioInfo then
        print(` > Música: '{info.AudioInfo.Name}' por {info.AudioInfo.Author}`)
    else
        print(` > Música: Sin audio personalizado`)
    end
    
    print("------------------------------")
end

print("\n¡Prueba finalizada con éxito!")