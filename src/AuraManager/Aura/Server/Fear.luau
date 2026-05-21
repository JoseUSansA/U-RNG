local module = {}

-- Guardaremos los datos agrupados por PERSONAJE. 
-- ¡Así funciona perfecto si 5 personas se equipan Fear al mismo tiempo!
local DatosAura = {}

function module.setup(character)
	print("1. [Fear Client] Setup iniciado para:", character.Name)

	DatosAura[character] = {
		Textos = {},
		Posiciones = {}
	}

	-- Usamos task.spawn para que las esperas no bloqueen el resto de tu juego
	task.spawn(function()
		local Cabeza = character:WaitForChild("Head", 5)
		if not Cabeza then return print("❌ [Fear] Error: No se encontró la Cabeza en 5 segundos") end
		print("2. [Fear] Cabeza encontrada")

		local att = Cabeza:WaitForChild("title", 5)
		if not att then return print("❌ [Fear] Error: No se encontró el attachment 'title'") end
		print("3. [Fear] Attachment encontrado")

		local CartelUI = att:WaitForChild("BillboardGui", 5)
		if not CartelUI then return print("❌ [Fear] Error: No se encontró el BillboardGui") end
		print("4. [Fear] Cartel encontrado")

		local textosEncontrados = 0
		for _, elemento in CartelUI:GetDescendants() do
			if elemento:IsA("TextLabel") then
				table.insert(DatosAura[character].Textos, elemento)
				DatosAura[character].Posiciones[elemento] = elemento.Position
				textosEncontrados += 1
			end
		end
		print("5. [Fear] TextLabels encontrados y guardados:", textosEncontrados)
	end)
end

function module.loop(deltaTime: number)
	-- Recorremos todos los personajes que tengan esta aura equipada
	for _, characterData in DatosAura do
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
end

function module.cleanup(character)
	print("6. [Fear Client] Limpiando aura de:", character.Name)
	if DatosAura[character] then
		for texto, PosOriginal in DatosAura[character].Posiciones do
			if texto then
				texto.Position = PosOriginal
				texto.Rotation = 0
			end
		end
		-- Borramos los datos de este jugador específico para liberar memoria
		DatosAura[character] = nil 
	end
end

return module