export type AuraInfo = {
	HipHeight: number?;
	AudioInfo: {Name: string, Author: string}?;
	CreatorId: (number | {number})?;
	ConceptId: (number | {number})?;
}

local Settings : {[string]: AuraInfo} = {
	["Common"] = {
		CreatorId = 933728988;
		Rarity = 2;
	};
	
	["Rare"] = {
		CreatorId = 933728988;
		Rarity = 4;
	};
	
	["Strange"] = {
		CreatorId = 933728988;
		Rarity = 8;
	};
	
	["Fast"] = {
		CreatorId = 933728988;
		Rarity = 10;
	};
	
	["Fear"] = {
		CreatorId = 933728988;
		Rarity = 15;
	};
	["Patience"] = {
		CreatorId = 933728988;
		Rarity = 20;
	};
	["Dreamer"] = {
		CreatorId = 933728988;
		Rarity = 25;
		AudioInfo = {"Level 3", "Distrokid"};
	};
	["Glitch"] = {
		CreatorId = 933728988;
		Rarity = 30;
	};
	["Future"] = {
		CreatorId = 933728988;
		Rarity = 40;
	}
}

return Settings :: {[string]: AuraInfo}