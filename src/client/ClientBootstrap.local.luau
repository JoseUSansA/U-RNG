local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AuraManagerForClient = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("AuraManagerForClient")

require(AuraManagerForClient)

print("✅ [ClientInit] AuraManagerForClient despertado y escuchando paquetes.")