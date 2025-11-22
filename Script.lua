loadstring(game:HttpGet("https://raw.githubusercontent.com/Vitoarieshub/KALI-LINUX-/refs/heads/main/loader.lua"))()


MakeWindow({

    Hub = {

        Title = "Venix Hub",

        Animation = "  Universal"

    },

    

    Key = {

        KeySystem = false,

        Title = "Sistema de Chave",

        Description = "Digite a chave correta para continuar.",

        KeyLink = "https://seusite.com/chave",

        Keys = {"1234", "28922"},

        Notifi = {

            Notifications = true,

            CorrectKey = "Chave correta! Iniciando script...",

            Incorrectkey = "Chave incorreta, tente novamente.",

            CopyKeyLink = "Link copiado!"

        }

    }

})


MinimizeButton({
    Image = "rbxassetid://72235587208723",
    Size = {40, 40},
    Color = Color3.fromRGB(10, 10, 10),
    Corner = true,                       
    CornerRadius = UDim.new(1, 0),       
    Stroke = true,                      
    StrokeColor = Color3.fromRGB(137, 207, 240) 
})
   


local Jogador = MakeTab({Name = "Jogador"})
local Visuais = MakeTab({Name = "Visuals"})
local Teleportes = MakeTab({Name = "Teleportes"})
local Config = MakeTab({Name = "Config"})


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Estado atual
local velocidadeAtivada = false
local velocidadeValor = 25

local jumpAtivado = false
local jumpPowerSelecionado = 40
local jumpPowerPadrao = 50

local gravidadeAtivada = false
local gravidadeSelecionada = 196.2
local gravidadePadrao = 196.2

-- Função para aplicar velocidade
local function aplicarVelocidade(character)
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid and velocidadeAtivada then
		humanoid.WalkSpeed = velocidadeValor
	elseif humanoid then
		humanoid.WalkSpeed = 16
	end
end

-- Função para aplicar super pulo
local function aplicarJumpPower(character)
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.UseJumpPower = true
		humanoid.JumpPower = jumpAtivado and jumpPowerSelecionado or jumpPowerPadrao
	end
end

-- Aplica toda vez que o personagem renasce
LocalPlayer.CharacterAdded:Connect(function(character)
	character:WaitForChild("Humanoid")
	task.wait(0.1)
	aplicarVelocidade(character)
	aplicarJumpPower(character)

	if gravidadeAtivada then
		Workspace.Gravity = gravidadeSelecionada
	else
		Workspace.Gravity = gravidadePadrao
	end
end)


-- Velocidade
AddSlider(Jogador, {
	Name = "Velocidade",
	MinValue = 16,
	MaxValue = 250,
	Default = 25,
	Increase = 1,
	Callback = function(Value)
		velocidadeValor = Value
		if velocidadeAtivada and LocalPlayer.Character then
			aplicarVelocidade(LocalPlayer.Character)
		end
	end
})

AddToggle(Jogador, {
	Name = "Velocidade",
	Default = false,
	Callback = function(Value)
		velocidadeAtivada = Value
		if LocalPlayer.Character then
			aplicarVelocidade(LocalPlayer.Character)
		end
	end
})

-- Super Jump
AddSlider(Jogador, {
	Name = "Super Pulo",
	MinValue = 10,
	MaxValue = 900,
	Default = 40,
	Increase = 1,
	Callback = function(Value)
		jumpPowerSelecionado = Value
		if jumpAtivado and LocalPlayer.Character then
			aplicarJumpPower(LocalPlayer.Character)
		end
	end
})

AddToggle(Jogador, {
	Name = "Super Pulo",
	Default = false,
	Callback = function(Value)
		jumpAtivado = Value
		if LocalPlayer.Character then
			aplicarJumpPower(LocalPlayer.Character)
		end
	end
})

-- Gravidade
AddSlider(Jogador, {
	Name = "Gravidade",
	MinValue = 0,
	MaxValue = 500,
	Default = 196.2,
	Increase = 1,
	Callback = function(Value)
		gravidadeSelecionada = Value
		if gravidadeAtivada then
			Workspace.Gravity = gravidadeSelecionada
		end
	end
})

AddToggle(Jogador, {
	Name = "Gravidade",
	Default = false,
	Callback = function(Value)
		gravidadeAtivada = Value
		Workspace.Gravity = Value and gravidadeSelecionada or gravidadePadrao
	end
})


local Players = game:GetService("Players")

local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local noclipEnabled = false



-- Toggle para ativar/desativar Atravessar Paredes

AddToggle(Jogador, {

    Name = "Atravessar Paredes", 

    Default = false,

    Callback = function(Value)

        noclipEnabled = Value

        print("Noclip:", Value and "Ativado" or "Desativado")

    end

})



-- Loop para desativar colisão 

RunService.Stepped:Connect(function()

    if noclipEnabled and player.Character then

        for _, part in ipairs(player.Character:GetDescendants()) do

            if part:IsA("BasePart") then

                part.CanCollide = false

            end

        end

    end

end)



-- Infinite Jump
local jumpConnection

local function toggleInfiniteJump(enable)

    if enable then

        if not jumpConnection then

            jumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()

                local player = game.Players.LocalPlayer

                local character = player.Character or player.CharacterAdded:Wait()

                local humanoid = character:FindFirstChildOfClass("Humanoid")

                if humanoid then

                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

                end

            end)

        end

    else

        if jumpConnection then

            jumpConnection:Disconnect()

            jumpConnection = nil

        end

    end

end


-- Toggle pulo infinito

local Toggle = AddToggle(Jogador, {

    Name = "Pulo Infinito",

    Default = false,

    Callback = function(Value)

        toggleInfiniteJump(Value)

    end

})



local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local playerName = ""
local jogadorSelecionado = nil
local observarConnection = nil
local observando = false

local function encontrarJogador(nome)
	local lowerName = nome:lower()
	for _, player in pairs(Players:GetPlayers()) do
		if player.Name:lower():sub(1, #lowerName) == lowerName then
			return player
		end
	end
	return nil
end

local function pararObservar()
	if observarConnection then
		observarConnection:Disconnect()
		observarConnection = nil
	end
	observando = false
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		Camera.CameraSubject = LocalPlayer.Character.Humanoid
	end
end

local function iniciarObservar(jogador)
	if not jogador or jogador == LocalPlayer then return end
	observando = true
	if jogador.Character and jogador.Character:FindFirstChild("Humanoid") then
		Camera.CameraSubject = jogador.Character.Humanoid
	end
	if observarConnection then
		observarConnection:Disconnect()
	end
	observarConnection = jogador.CharacterAdded:Connect(function(char)
		task.wait(0.5)
		local humanoid = char:FindFirstChild("Humanoid")
		if observando and humanoid then
			Camera.CameraSubject = humanoid
		end
	end)
end

AddTextBox(Jogador, {
	Name = "Alvo",
	Default = "",
	Placeholder = "Nome do jogador",
	Callback = function(text)
		playerName = text
		local novoJogador = encontrarJogador(playerName)
		if novoJogador ~= jogadorSelecionado then
			jogadorSelecionado = novoJogador
			if observando and jogadorSelecionado then
				iniciarObservar(jogadorSelecionado)
			end
		end
	end
})

AddToggle(Jogador, {
	Name = "Visualizar",
	Default = false,
	Callback = function(Value)
		jogadorSelecionado = encontrarJogador(playerName)
		if Value then
			if jogadorSelecionado then
				iniciarObservar(jogadorSelecionado)
			end
		else
			pararObservar()
		end
	end
})

AddButton(Jogador, {
	Name = "Teleportar",
	Callback = function()
		jogadorSelecionado = encontrarJogador(playerName)
		if jogadorSelecionado and jogadorSelecionado.Character and jogadorSelecionado.Character:FindFirstChild("HumanoidRootPart") then
			local alvo = jogadorSelecionado.Character.HumanoidRootPart
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				LocalPlayer.Character.HumanoidRootPart.CFrame = alvo.CFrame + Vector3.new(0, 3, 0)
			end
		end
	end
})


local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer


-- Variáveis para ativar/desativar cada ESP

local espNomeAtivado = false

local espIdadeAtivado = false


-- Tabelas para armazenar conexões separadas para cada ESP

local conexoesNome = {}

local conexoesIdade = {}



-- Função que cria o ESP para um jogador, pode mostrar nome ou idade

local function criarESP(player, mostrarIdade)

	if player == LocalPlayer then return end

	task.spawn(function()

		while (mostrarIdade and espIdadeAtivado or not mostrarIdade and espNomeAtivado) and player and player.Character do

			local head = player.Character:FindFirstChild("Head")

			local humanoid = player.Character:FindFirstChild("Humanoid")



			if head and humanoid and humanoid.Health > 0 then

				-- Usamos nome diferente para os ESPs para não conflitar

				local espName = mostrarIdade and "ESP_Idade" or "ESP_Nome"

				local esp = head:FindFirstChild(espName)



				if not esp then

					esp = Instance.new("BillboardGui")

					esp.Name = espName

					esp.Adornee = head

					esp.Size = UDim2.new(0, 100, 0, 25)

					esp.StudsOffset = Vector3.new(0, mostrarIdade and 2.5 or 2, 0) -- Pequeno ajuste para não sobrepor

					esp.AlwaysOnTop = true



					local text = Instance.new("TextLabel")

					text.Name = "Texto"

					text.Size = UDim2.new(1, 0, 1, 0)

					text.BackgroundTransparency = 1

					text.TextColor3 = Color3.fromRGB(255, 255, 255)

					text.TextSize = 12

					text.TextScaled = false

					text.Font = Enum.Font.GothamBold

					text.TextStrokeTransparency = 0.4

					text.TextStrokeColor3 = Color3.new(0, 0, 0)

					text.Parent = esp



					esp.Parent = head



					humanoid.Died:Connect(function()

						if esp then esp:Destroy() end

					end)

				end



				local texto = esp:FindFirstChild("Texto")

				if texto then

					texto.Text = mostrarIdade and (tostring(player.AccountAge) .. " Days") or player.Name

				end

			end



			wait(0.3)

		end



		-- Quando desligar, destrói o ESP se existir

		if player.Character then

			local esp = player.Character.Head:FindFirstChild(mostrarIdade and "ESP_Idade" or "ESP_Nome")

			if esp then esp:Destroy() end

		end

	end)

end



-- Monitorar jogador para ESP Nome

local function monitorarPlayerNome(player)

	if conexoesNome[player] then

		conexoesNome[player]:Disconnect()

		conexoesNome[player] = nil

	end



	conexoesNome[player] = player.CharacterAdded:Connect(function()

		wait(1)

		if espNomeAtivado then

			criarESP(player, false)

		end

	end)



	if player.Character then

		criarESP(player, false)

	end

end



-- Monitorar jogador para ESP Idade

local function monitorarPlayerIdade(player)

	if conexoesIdade[player] then

		conexoesIdade[player]:Disconnect()

		conexoesIdade[player] = nil

	end



	conexoesIdade[player] = player.CharacterAdded:Connect(function()

		wait(1)

		if espIdadeAtivado then

			criarESP(player, true)

		end

	end)



	if player.Character then

		criarESP(player, true)

	end

end



-- Toggle ESP Nome

AddToggle(Visuais, {

	Name = "ESP Name",

	Default = false,

	Callback = function(Value)

		espNomeAtivado = Value

		if espNomeAtivado then

			for _, player in ipairs(Players:GetPlayers()) do

				if player ~= LocalPlayer then

					monitorarPlayerNome(player)

				end

			end

			conexoesNome["PlayerAdded"] = Players.PlayerAdded:Connect(function(player)

				monitorarPlayerNome(player)

			end)

		else

			for _, player in ipairs(Players:GetPlayers()) do

				if player.Character and player.Character:FindFirstChild("Head") then

					local esp = player.Character.Head:FindFirstChild("ESP_Nome")

					if esp then esp:Destroy() end

				end

				if conexoesNome[player] then

					conexoesNome[player]:Disconnect()

					conexoesNome[player] = nil

				end

			end

			if conexoesNome["PlayerAdded"] then

				conexoesNome["PlayerAdded"]:Disconnect()

				conexoesNome["PlayerAdded"] = nil

			end

		end

	end

})



local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local espEnabled = false
local skeletons = {}

local partsToConnect = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"},
    {"RightLowerLeg", "RightFoot"},
}

local function createSkeleton(t)
    local lines = {}
    for _ = 1, #partsToConnect do
        local line = Drawing.new("Line")
        line.Color = Color3.new(1, 1, 1)
        line.Thickness = 2
        line.Transparency = 1
        line.Visible = false
        table.insert(lines, line)
    end
    skeletons[t] = {Lines = lines}
end

local function removeSkeleton(t)
    if skeletons[t] then
        for _, line in ipairs(skeletons[t].Lines) do
            line:Remove()
        end
        skeletons[t] = nil
    end
end

local function updateSkeletons()
    if not espEnabled then
        for _, s in pairs(skeletons) do
            for _, l in ipairs(s.Lines) do
                l.Visible = false
            end
        end
        return
    end

    for _, t in pairs(Players:GetPlayers()) do
        if t ~= player then
            local c = t.Character
            local s = skeletons[t]
            if c and s then
                for i, conn in ipairs(partsToConnect) do
                    local p0, p1 = c:FindFirstChild(conn[1]), c:FindFirstChild(conn[2])
                    local l = s.Lines[i]
                    if p0 and p1 then
                        local v0, ok0 = workspace.CurrentCamera:WorldToViewportPoint(p0.Position)
                        local v1, ok1 = workspace.CurrentCamera:WorldToViewportPoint(p1.Position)
                        if ok0 and ok1 then
                            l.From = Vector2.new(v0.X, v0.Y)
                            l.To = Vector2.new(v1.X, v1.Y)
                            l.Visible = true
                        else
                            l.Visible = false
                        end
                    else
                        l.Visible = false
                    end
                end
            elseif s then
                for _, l in ipairs(s.Lines) do
                    l.Visible = false
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(updateSkeletons)

Players.PlayerAdded:Connect(function(t)
    if t ~= player then
        t.CharacterAdded:Connect(function()
            task.wait(1)
            removeSkeleton(t)
            createSkeleton(t)
        end)
        if t.Character then createSkeleton(t) end
    end
end)

Players.PlayerRemoving:Connect(removeSkeleton)

for _, t in pairs(Players:GetPlayers()) do
    if t ~= player then
        t.CharacterAdded:Connect(function()
            task.wait(1)
            removeSkeleton(t)
            createSkeleton(t)
        end)
        if t.Character then createSkeleton(t) end
    end
end

AddToggle(Visuais, {
    Name = "ESP Skeleton",
    Default = false,
    Callback = function(state)
        espEnabled = state
    end
})


local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local portalA, portalB = nil, nil
local debounce = false
local clickCount = 0

-- Função de criar portal
local function createPortal(position, name, color)
	local portal = Instance.new("Part")
	portal.Size = Vector3.new(6, 10, 1)
	portal.Anchored = true
	portal.CanCollide = false
	portal.Position = position
	portal.BrickColor = BrickColor.new(color)
	portal.Material = Enum.Material.Neon
	portal.Transparency = 0.2
	portal.Name = name
	portal.Parent = Workspace

	local decal = Instance.new("Decal")
	decal.Texture = "rbxassetid://4848206463"
	decal.Face = Enum.NormalId.Front
	decal.Parent = portal

	return portal
end

-- Teleporte entre portais
local function checkTouch()
	if not portalA or not portalB then return end

	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local hrp = char.HumanoidRootPart

	local function teleportIfNear(portal, destination)
		if debounce then return end
		if (hrp.Position - portal.Position).Magnitude < 6 then
			debounce = true
			hrp.CFrame = destination.CFrame + Vector3.new(0, 5, 0)
			task.wait(1)
			debounce = false
		end
	end

	teleportIfNear(portalA, portalB)
	teleportIfNear(portalB, portalA)
end
RunService.Heartbeat:Connect(checkTouch)

-- BOTÃO: Salvar posição com Portal
AddButton(Teleportes, {
	Name = "Salvar posição com Portal",
	Callback = function()
		local char = LocalPlayer.Character
		if not char or not char:FindFirstChild("HumanoidRootPart") then return end
		local pos = char.HumanoidRootPart.Position

		if clickCount == 0 then
			if portalA then portalA:Destroy() end
			portalA = createPortal(pos, "PortalA", "Lime green")
			clickCount = 1
			warn("Portal A salvo na sua posição!")
		elseif clickCount == 1 then
			if portalB then portalB:Destroy() end
			portalB = createPortal(pos, "PortalB", "Bright red")
			clickCount = 2
			warn("Portal B salvo na sua posição!")
		else
			warn("Já existem dois portais! Use o botão Remover Portais para resetar.")
		end
	end
})

-- BOTÃO: Remover Portais
AddButton(Teleportes, {
	Name = "Remover Portais",
	Callback = function()
		if portalA then portalA:Destroy() portalA = nil end
		if portalB then portalB:Destroy() portalB = nil end
		clickCount = 0
		warn("Portais removidos.")
	end
})


-- Variável para guardar a posição salva
local savedCFrame = nil

-- Botão: Salvar posição
AddButton(Teleportes, {
    Name = "Salvar posição",
    Callback = function()
        print("Botão foi clicado! Salvando posição...")
        pcall(function()
            local hrp = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
            savedCFrame = hrp.CFrame
            print("Posição salva:", tostring(savedCFrame))
        end)
    end
})

-- Botão: Teleportar para posição salva
AddButton(Teleportar, {
    Name = "Teleportar para posição",
    Callback = function()
        print("Botão foi clicado! Teleportando...")
        pcall(function()
            if savedCFrame then
                local hrp = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
                hrp.CFrame = savedCFrame
                print("Teleportado com sucesso.")
            else
                warn("Nenhuma posição salva ainda!")
            end
        end)
    end
})



-- Serviços
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- Estado de ativação
local antiKickEnabled = false
local oldNamecallHook

-- Notificar
local function NotifyKickBlocked()
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Vitor Developer",
            Text = "Kick attempt blocked",
            Icon = "rbxassetid://137903795082783",
            Duration = 3
        })
    end)
end

-- Hook global
if not oldNamecallHook then
    oldNamecallHook = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if antiKickEnabled and typeof(method) == "string" and string.lower(method) == "kick" and self == LocalPlayer then
            NotifyKickBlocked()
            return wait(9e9)
        end
        return oldNamecallHook(self, ...)
    end))
end

-- Toggle Anti Kick
AddToggle(Config, {
    Name = "Anti Chute",
    Default = false,
    Callback = function(state)
        antiKickEnabled = state
    end
})


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local trackedPlayers = {}
local antiFlingEnabled = false

local function setCollide(part, state)
    if part:IsA("BasePart") then
        part.CanCollide = state
        if not state then
            part.Velocity = Vector3.zero
            part.RotVelocity = Vector3.zero
            part.AssemblyLinearVelocity = Vector3.zero
            part.AssemblyAngularVelocity = Vector3.zero
        end
    end
end

local function trackCharacter(character)
    for _, part in pairs(character:GetChildren()) do
        setCollide(part, not antiFlingEnabled)
    end
    character.ChildAdded:Connect(function(child)
        setCollide(child, not antiFlingEnabled)
    end)
end

local function trackPlayer(player)
    if player == localPlayer then return end
    if player.Character then
        trackCharacter(player.Character)
    end
    player.CharacterAdded:Connect(trackCharacter)
    trackedPlayers[player] = true
end

local function applyState(state)
    for player in pairs(trackedPlayers) do
        local character = player.Character
        if character then
            for _, part in pairs(character:GetChildren()) do
                setCollide(part, state)
            end
        end
    end
end

local function enableTracking()
    for _, player in pairs(Players:GetPlayers()) do
        trackPlayer(player)
    end
    Players.PlayerAdded:Connect(trackPlayer)

    RunService.RenderStepped:Connect(function()
        if antiFlingEnabled then
            for player in pairs(trackedPlayers) do
                local character = player.Character
                if character then
                    for _, part in pairs(character:GetChildren()) do
                        setCollide(part, false)
                    end
                end
            end
        end
    end)
end

AddToggle(Config, {
    Name = "Anti Arremesso",
    Default = false,
    Callback = function(state)
        antiFlingEnabled = state
        if antiFlingEnabled then
            if next(trackedPlayers) == nil then
                enableTracking()
            end
        else
            applyState(true)
        end
    end
})

local Lighting = game:GetService("Lighting")  

-- Armazena configurações originais
local originalSettings = {
	Brightness = Lighting.Brightness,
	Ambient = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient,
	ClockTime = Lighting.ClockTime,
	FogEnd = Lighting.FogEnd,
	GlobalShadows = Lighting.GlobalShadows
}

local fullBrightEnabled = false
local connections = {}

-- Ativa o modo manhã com iluminação suave
local function enableMorningLight()
	fullBrightEnabled = true

	Lighting.Brightness = 1.5
	Lighting.Ambient = Color3.fromRGB(180, 180, 160) 
	Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 170)
	Lighting.ClockTime = 7 -- manhã cedo
	Lighting.FogEnd = 1e9
	Lighting.GlobalShadows = true

	-- Protege propriedades de alterações externas
	table.insert(connections, Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
		if fullBrightEnabled then Lighting.ClockTime = 7 end
	end))

	table.insert(connections, Lighting:GetPropertyChangedSignal("Ambient"):Connect(function()
		if fullBrightEnabled then Lighting.Ambient = Color3.fromRGB(180, 180, 160) end
	end))

	table.insert(connections, Lighting:GetPropertyChangedSignal("OutdoorAmbient"):Connect(function()
		if fullBrightEnabled then Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 170) end
	end))

	table.insert(connections, Lighting:GetPropertyChangedSignal("Brightness"):Connect(function()
		if fullBrightEnabled then Lighting.Brightness = 1.5 end
	end))

	table.insert(connections, Lighting:GetPropertyChangedSignal("GlobalShadows"):Connect(function()
		if fullBrightEnabled then Lighting.GlobalShadows = true end
	end))

	table.insert(connections, Lighting:GetPropertyChangedSignal("FogEnd"):Connect(function()
		if fullBrightEnabled then Lighting.FogEnd = 1e9 end
	end))

	print("Lighting ativado.")
end

-- Restaura os valores originais
local function disableMorningLight()
	fullBrightEnabled = false

	for _, conn in ipairs(connections) do
		if conn.Disconnect then
			conn:Disconnect()
		end
	end
	connections = {}

	for prop, value in pairs(originalSettings) do
		Lighting[prop] = value
	end

	print("Lighting desativardo.")
end

-- Toggle
AddToggle(Config, {
	Name = "Força Dia",
	Default = false,
	Callback = function(state) 
		if state then 
			enableMorningLight()
		else
			disableMorningLight()
		end
	end
})

