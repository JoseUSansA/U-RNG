local module = {}

local DatosAura = {}
local GRADOS_POR_SEGUNDO = 45 

function module.setup(character)
    DatosAura[character] = {
        Attachments = {}
    }

    task.spawn(function()
        local hrp = character:WaitForChild("HumanoidRootPart", 5)
        if not hrp then return end

        local fog = hrp:WaitForChild("Fog", 5)
        if not fog then return end

        local heartAtt = fog:WaitForChild("Heart", 5)
        if not heartAtt then return end

        DatosAura[character].Attachments[heartAtt] = heartAtt.CFrame
    end)
end

function module.loop(character: Model, deltaTime: number)
    local data = DatosAura[character]
    if not data then return end

    local rotacionFrame = math.rad(GRADOS_POR_SEGUNDO * deltaTime)

    for attachment, _ in data.Attachments do
        if attachment then
            attachment.CFrame = attachment.CFrame * CFrame.Angles(0, rotacionFrame, 0)
        end
    end
end

function module.cleanup(character)
    print("Limpiando rotación de Heart en:", character.Name)
    if DatosAura[character] then
        for attachment, cframeOriginal in DatosAura[character].Attachments do
            if attachment then
                attachment.CFrame = cframeOriginal
            end
        end
        DatosAura[character] = nil 
    end
end

return module