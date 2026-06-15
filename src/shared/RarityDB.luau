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
	["Cherry"] = {
		CreatorId = 933728988;
		Rarity = 300;
	};
	["Rare_Wanted"] = {
		CreatorId = 933728988;
		ConceptId = 1157619438;
		Rarity = 400;
	};
	-- Unfinished/Undone
	["RAINBOW"] = {
		CreatorId = 933728988;
		Rarity = 500;
	};
	["Ethereal"] = {
		CreatorId = 933728988;
		Rarity = 650;
	};
	["Radioactive"] = {
		CreatorId = 933728988;
		Rarity = 725;
	};
	["Space"] = {
		CreatorId = 933728988;
		Rarity = 800;
	};
	["Infinite"] = {
		CreatorId = 933728988;
		Rarity = 900;
	};
	["RAINBOW_FUTURIST"] = {
        CreatorId = 933728988;
        Rarity = 1000;
    };
    ["Cosmic"] = {
        CreatorId = 933728988;
        Rarity = 1500;
    };
    ["Interdimensional_3D"] = {
        CreatorId = 933728988;
        Rarity = 2000;
    };
    ["Ghost"] = {
        CreatorId = 933728988;
        Rarity = 2500;
    };
    ["Glitch_Random"] = {
        CreatorId = 933728988;
        Rarity = 3000;
    };
    ["Infinite_Transfinite"] = {
        CreatorId = 933728988;
        Rarity = 5000;
    };
    ["Angel"] = {
        CreatorId = 933728988;
        Rarity = 10000;
    };
}

return Settings :: {[string]: AuraInfo}