local module = {}

local DatosAura = {}

function module.setup(character)

	DatosAura[character] = {
		Textos = {},
		Posiciones = {}
	}

	task.spawn(function()
		local Cabeza = character:WaitForChild("Head", 5)
		if not Cabeza then return end

		local att = Cabeza:WaitForChild("title", 5)
		if not att then return end

		local CartelUI = att:WaitForChild("BillboardGui", 5)
		if not CartelUI then return end

		for _, elemento in CartelUI:GetDescendants() do
			if elemento:IsA("TextLabel") then
				table.insert(DatosAura[character].Textos, elemento)
				DatosAura[character].Posiciones[elemento] = elemento.Position
			end
		end
	end)
end

function module.loop(Character: Model, deltaTime: number)
    local characterData = DatosAura[Character]
    if not characterData then return end
    for _, texto in characterData.Textos do
        if texto and characterData.Posiciones[texto] then
            local PosOriginal = characterData.Posiciones[texto]

            local TemblorX = math.random(-2, 2)
            local TemblorY = math.random(-2, 2)

            texto.Position = UDim2.new(
                PosOriginal.X.Scale, PosOriginal.X.Offset + TemblorX,
                PosOriginal.Y.Scale, PosOriginal.Y.Offset + TemblorY
            )

            texto.Rotation = math.random(-2, 2)
        end
    end
end

function module.cleanup(character)
	if DatosAura[character] then
		for texto, PosOriginal in DatosAura[character].Posiciones do
			if texto then
				texto.Position = PosOriginal
				texto.Rotation = 0
			end
		end
		DatosAura[character] = nil 
	end
end

return module