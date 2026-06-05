export type AuraInfo = {
	Rarity: number;
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
		ConceptId = 3617604552;
	};
	["Dreamer"] = {
		CreatorId = 933728988;
		Rarity = 25;
		AudioInfo = {Name = "Level 3", Author = "Flared Anomaly (BACKROOMS: Arrival)"};
	};
	["Glitch"] = {
		CreatorId = 933728988;
		Rarity = 30;
	};
	["Future"] = {
		CreatorId = 933728988;
		Rarity = 40;
	};
	["Wavestep"] = {
		CreatorId = 933728988;
		Rarity = 50;
		AudioInfo = {Name = "波 (Wave)", Author = "Joejoe Chow (VAPORWAVE TRIP)"}
	};
	["Fire"] = {
		CreatorId = 933728988;
		Rarity = 100;
		ConceptId = 2653920408;
	};
	["Interdimensional"] = {
		CreatorId = 933728988;
		Rarity = 200;
	};
	["Common_Chromosome"] = {
		CreatorId = 933728988;
		Rarity = 250;
	};
}

return Settings :: {[string]: AuraInfo}