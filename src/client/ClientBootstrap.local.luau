local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AuraManagerForClient = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("AuraManagerForClient")

require(AuraManagerForClient)

print("✅ [ClientInit] AuraManagerForClient despertado y escuchando paquetes.")