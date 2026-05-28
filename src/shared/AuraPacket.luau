--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")

--// Variables
local ByteNet = require(Shared:WaitForChild("ByteNet"))

--// Definte Packets
return ByteNet.defineNamespace("Aura", function()
	return {
		
		--// Server => Client
		
		--// Client => Server
		Equipped =ByteNet.definePacket{
			value = ByteNet.struct{
				Name=ByteNet.string;
				Character=ByteNet.inst;
				SourceContained=ByteNet.bool;
			}
		};
		
		Unequipped = ByteNet.definePacket{
			value = ByteNet.struct{
				Name=ByteNet.string;
				Character=ByteNet.inst;
			}
		};
	}
end)