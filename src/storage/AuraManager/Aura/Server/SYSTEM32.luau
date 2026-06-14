local module = {}

local CharacterData = {}

local RAINBOW_COLORS = {
	Color3.fromRGB(255, 0, 0),
	Color3.fromRGB(255, 127, 0),
	Color3.fromRGB(255, 255, 0),
	Color3.fromRGB(0, 255, 0),
	Color3.fromRGB(0, 0, 255),
	Color3.fromRGB(75, 0, 130),
	Color3.fromRGB(148, 0, 211)
}

local COLOR_CHANGE_SPEED = 5
local SWAY_SPEED = 6
local MAX_SWAY_DEG = 25

local function isParticleWhite(particle: ParticleEmitter)
	local keypoints = particle.Color.Keypoints
	if #keypoints > 0 then
		local color = keypoints[1].Value
		return color.R == 1 and color.G == 1 and color.B == 1
	end
	return false
end

local function applyGlitchState(character, data)
	for _, descendant in ipairs(character:GetDescendants()) do
		if descendant:IsA("ParticleEmitter") then
			if descendant.Name == "Toggle" then
				descendant.Enabled = true
				table.insert(data.ToggleParticles, descendant)
			elseif isParticleWhite(descendant) then
				table.insert(data.WhiteParticles, descendant)
			end
		elseif descendant:IsA("TextLabel") then
			table.insert(data.TextLabels, {
				Instance = descendant,
				OriginalRotation = descendant.Rotation
			})
		end
	end
end

local function restoreNormalState(data)
	for _, particle in ipairs(data.ToggleParticles) do
		if particle and particle.Parent then
			particle.Enabled = false
		end
	end
	table.clear(data.ToggleParticles)

	local whiteSequence = ColorSequence.new(Color3.new(1, 1, 1))
	for _, particle in ipairs(data.WhiteParticles) do
		if particle and particle.Parent then
			particle.Color = whiteSequence
		end
	end
	table.clear(data.WhiteParticles)

	for _, labelData in ipairs(data.TextLabels) do
		local label = labelData.Instance
		if label and label.Parent then
			label.TextColor3 = Color3.new(1, 1, 1)
			label.Rotation = 0
		end
	end
	table.clear(data.TextLabels)
end

function module.setup(character)
	CharacterData[character] = {
		Audio = nil,
		Phase = 0,
		TimeActive = 0,
		ToggleParticles = {},
		WhiteParticles = {},
		TextLabels = {}
	}

	task.spawn(function()
		local head = character:WaitForChild("Head", 5)
		if not head then return end

		local audio = head:WaitForChild("GLITCHED_.WAV", 5)
		if not audio then return end

		if CharacterData[character] then
			CharacterData[character].Audio = audio
		end
	end)
end

function module.loop(character: Model, deltaTime: number)
	local data = CharacterData[character]
	
	if not data or not data.Audio then 
		return 
	end

	local currentTime = data.Audio.TimePosition
	data.TimeActive += deltaTime

	if currentTime >= 11.5 and currentTime < 74 and data.Phase == 0 then
		data.Phase = 1
		applyGlitchState(character, data)
	elseif currentTime >= 74 and data.Phase == 1 then
		data.Phase = 2
		restoreNormalState(data)
	end

	if data.Phase == 1 then
		local colorIndex = math.floor(data.TimeActive * COLOR_CHANGE_SPEED) % #RAINBOW_COLORS + 1
		local currentColor = RAINBOW_COLORS[colorIndex]
		local currentSequence = ColorSequence.new(currentColor)
		
		local swayRotation = math.sin(data.TimeActive * SWAY_SPEED) * MAX_SWAY_DEG

		for _, particle in ipairs(data.WhiteParticles) do
			if particle and particle.Parent then
				particle.Color = currentSequence
			end
		end

		for _, labelData in ipairs(data.TextLabels) do
			local label = labelData.Instance
			if label and label.Parent then
				label.TextColor3 = currentColor
				label.Rotation = swayRotation
			end
		end
	end
end

function module.cleanup(character)
	local data = CharacterData[character]
	
	if not data then 
		return 
	end

	if data.Phase == 1 then
		restoreNormalState(data)
	end

	CharacterData[character] = nil
end

return module