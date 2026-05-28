--!nocheck
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Uso de WaitForChild para evitar errores si las carpetas tardan en replicarse/cargar
local Assets = ReplicatedStorage:WaitForChild("Assets")
local AuraScripts = Assets:WaitForChild("AuraScripts")


local module = {}
module.auraScripts = {}
module.Auras = {}

function module.setup(character: Model, AuraName: string, AuraInstances: table)
    local auraServer = module.auraScripts.Server[AuraName]
    local baseModule = require(auraServer or script.Server.Default)
    
    local auraServerModule = type(baseModule) == "table" and table.clone(baseModule) or {}
    
    if not AuraScripts:FindFirstChild(AuraName) then
        local clientScript = module.auraScripts.Client[AuraName]
        if clientScript then
            local auraClient = clientScript:Clone()
            auraClient.Parent = AuraScripts
        end
    end
    
    module.Auras[character] = auraServerModule
    auraServerModule.Name = AuraName
    auraServerModule.Character = character
    auraServerModule.AuraInstances = AuraInstances
    auraServerModule.ModuleScript = auraServer

    if auraServerModule.equip then
        auraServerModule.equip(character)
    end
    
    if auraServerModule.setup then
        auraServerModule.setup(character)
    end
    
    auraServerModule.LoopEvent = RunService.Heartbeat:Connect(function(deltaTime)
        if not (auraServerModule.Character and module.Auras[auraServerModule.Character]) then
            if auraServerModule.LoopEvent then
                auraServerModule.LoopEvent:Disconnect()
            end
            return
        end
        
        module.loop(character, deltaTime)
        
        if auraServerModule.loop then
            auraServerModule.loop(deltaTime)
        end
    end)
end

function module.loop(character: Model, deltaTime: number)
end

function module.cleanup(Character: Model?)
    if not Character then return end
    
    local Aura = module.Auras[Character]
    if not Aura then return end

    if Aura.LoopEvent then
        Aura.LoopEvent:Disconnect()
    end
    
    if Aura.cleanup then
        Aura.cleanup(Character)
    end

    if Aura.AuraInstances then
        for _, v: Instance in pairs(Aura.AuraInstances) do
            if not (v and v:FindFirstAncestorOfClass("Workspace")) then continue end
            if v.Parent == Character then continue end
            v:Destroy()
        end
    end

    if AuraPacket and AuraPacket.Unequipped then
        AuraPacket.Unequipped.sendToAll({Name = Aura.Name, Character = Character})
    end
    
    module.Auras[Character] = nil
end

function module.GetAuraFromPlayer(player: Player): string?
    if not player.Character then return nil end
    
    local aura = module.Auras[player.Character]
    return aura and aura.Name
end

function module.GetAuraFromCharacter(character: Model): string?
    local aura = module.Auras[character]
    return aura and aura.Name
end

function module.GetAuraDataFromCharacter(character: Model)
    return module.Auras[character]
end

function module.FindFirstAura(AuraName: string)
    for _, aura in pairs(module.Auras) do
        if aura.Name == AuraName then
            return aura
        end
    end
    return nil
end

function SaveAuraModules()
    module.auraScripts = {Server = {}, Client = {}}
    
    if script:FindFirstChild("Server") then
        for _, auraScript in ipairs(script.Server:GetChildren()) do
            module.auraScripts.Server[auraScript.Name] = auraScript
        end
    end
    
    if script:FindFirstChild("Client") then
        for _, auraScript in ipairs(script.Client:GetChildren()) do
            module.auraScripts.Client[auraScript.Name] = auraScript
        end
    end
end

SaveAuraModules()

return module