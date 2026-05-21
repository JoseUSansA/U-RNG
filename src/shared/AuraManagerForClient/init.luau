--!nocheck
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage:WaitForChild("Modules")
local AuraScripts = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("AuraScripts")

local Storage = ReplicatedStorage:WaitForChild("Storage")
local Packets = ReplicatedStorage:WaitForChild("Packets")
local AuraPacket = require(Packets:WaitForChild("Aura"))
local RarityDB = require(Storage:WaitForChild("RarityDB"))
local GoodSignal = require(Modules:WaitForChild("GoodSignal"))

local auramanager = {}
local PlayerAura = {}
auramanager.Auras = {}
local Auras = auramanager.Auras

function auramanager.GetAuraFromCharacter(Character: Model): string?
	return Auras[Character] and Auras[Character].Name
end

auramanager.Events = {} :: {[Model]: {RBXScriptConnection}}

function Equip(data)
	local Character = data.Character :: Model
	local AuraName = data.Name

	if not Character then
		warn("⚠️ [AuraManager] Equip cancelado: Character es nil (Aún no carga en el cliente)")
		return
	end
	if not AuraName then
		return
	end

	local aurascript = AuraScripts:FindFirstChild(AuraName)
	if not aurascript then
		aurascript = AuraScripts:WaitForChild(AuraName, 3) 
	end

	aurascript = aurascript or script.Default

	if aurascript == script.Default then
		warn("⚠️ [AuraManager] No se encontró el script de:", AuraName, ". Usando Default.")
	end

	Unequip({Character = Character, Name = auramanager.GetAuraFromCharacter(Character) or ""})

	auramanager.Events[Character] = {}
	local module = table.clone(require(aurascript))
	module.Name = AuraName
	module.setup(Character)

	if module.start then
		module.start(Character)
	end

	module.RenderEvent = RunService.RenderStepped:Connect(module.loop)

	Auras[Character] = module

	local destroyConnection = Character.Destroying:Connect(function()
		Unequip(data)
	end)
	table.insert(auramanager.Events[Character], destroyConnection)
end

function Unequip(data: { Character: Instance, Name: string })
	local AuraName = data.Name
	local Character = data.Character

	if not AuraName or not Character then
		return
	end

	if AuraName == "" then
		return
	end

	local aurascript = AuraScripts:FindFirstChild(AuraName)
	if not aurascript or not aurascript:IsA("ModuleScript") then
		return
	end

	local module = Auras[Character]
	if not module then
		return
	end

	if auramanager.Events[Character] then
		for i, event: RBXScriptConnection in auramanager.Events[Character] do
			event:Disconnect()
			auramanager.Events[Character][i] = nil
		end
	end

	if module.RenderEvent then
		module.RenderEvent:Disconnect()
		module.RenderEvent = nil
	end

	if module.cleanup then
		module.cleanup(Character)
	end
	Auras[Character] = nil
end

AuraPacket.Equipped.listen(Equip)
AuraPacket.Unequipped.listen(Unequip)

for _, player in Players:GetPlayers() do
	if not player.Character then
		continue
	end
	Equip({Character = player.Character, Name = player:GetAttribute("AuraName")})
end

return auramanager