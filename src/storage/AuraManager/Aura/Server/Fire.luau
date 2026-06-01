local module = {}

local DatosAura = {}
local GRADOS_POR_SEGUNDO = 90

function module.setup(character)
	print("[SETUP] Iniciado para", character.Name)

	DatosAura[character] = {
		Attachments = {}
	}

	task.spawn(function()
		local hrp = character:WaitForChild("HumanoidRootPart", 5)
		print("[SETUP] HRP:", hrp)

		if not hrp then
			warn("[SETUP] No se encontró HumanoidRootPart")
			return
		end

		local fog = hrp:WaitForChild("Fog", 5)
		print("[SETUP] Fog:", fog)

		if not fog then
			warn("[SETUP] No se encontró Fog")
			return
		end

		local heartAtt = fog:WaitForChild("Heart", 5)
		print("[SETUP] Heart:", heartAtt)

		if not heartAtt then
			warn("[SETUP] No se encontró Heart")
			return
		end

		print("[SETUP] Clase de Heart:", heartAtt.ClassName)

		DatosAura[character].Attachments[heartAtt] = heartAtt.CFrame

		print("[SETUP] Attachment registrado correctamente")
		print("[SETUP] Total attachments:", #table.create(0))
	end)
end

function module.loop(character: Model, deltaTime: number)
	local data = DatosAura[character]

	if not data then
		warn("[LOOP] No existe data para", character.Name)
		return
	end

	local cantidad = 0

	for _ in pairs(data.Attachments) do
		cantidad += 1
	end

	print("[LOOP] Attachments registrados:", cantidad)

	local rotacionFrame = math.rad(GRADOS_POR_SEGUNDO * deltaTime)

	for attachment, _ in pairs(data.Attachments) do
		print("[LOOP] Procesando:", attachment)

		if attachment and attachment.Parent then
			local antes = attachment.CFrame

			attachment.CFrame *= CFrame.Angles(0, rotacionFrame, 0)

			print("[LOOP] Rotado")
			print("[LOOP] Antes:", antes)
			print("[LOOP] Después:", attachment.CFrame)
		else
			warn("[LOOP] Attachment inválido")
		end
	end
end

function module.cleanup(character)
	print("[CLEANUP] Iniciado para", character.Name)

	local data = DatosAura[character]

	if not data then
		warn("[CLEANUP] No había datos")
		return
	end

	for attachment, cframeOriginal in pairs(data.Attachments) do
		print("[CLEANUP] Restaurando:", attachment)

		if attachment and attachment.Parent then
			attachment.CFrame = cframeOriginal
		end
	end

	DatosAura[character] = nil

	print("[CLEANUP] Completado")
end

return module