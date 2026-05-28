local AuraManager = require(game.ServerStorage.Storage.AuraManager)

local AuraName = script:GetAttribute("AuraName")

game.Players.PlayerAdded:Connect(function(player: Player)
	player.CharacterAdded:Connect(function(character: Model)
		AuraManager.EquipAura(character,AuraName)
	end)
end)