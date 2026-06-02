loadstring(game:HttpGet("https://raw.githubusercontent.com/Vitoarieshub/KALI-LINUX-/refs/heads/main/loader.lua"))()


MakeWindow({

    Hub = {

        Title = "Venix Hub",

        Animation = "Venix Hub Universal"

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
local Combate = MakeTab({Name = "Combate"})
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


-- Noclip
local noclipConnection

function toggleNoclip(enable)
    if enable then
        if not noclipConnection then
            noclipConnection = game:GetService("RunService").Stepped:Connect(function()
                for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        end
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Toggle para ativar/desativar colisão
AddToggle(Jogador, {
    Name = "Disable Collisions", 
    Default = false,
    Callback = function(Value)
        toggleNoclip(Value)
    end
})


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
AddButton(Teleportes, {
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

============== Esp ==============

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local espNomeAtivado = false
local espDistanciaAtivado = false
local espCor = Color3.fromRGB(255, 255, 255)

local function criarESP(root)
	local gui = root:FindFirstChild("ESP_INFO")

	if not gui then
		gui = Instance.new("BillboardGui")
		gui.Name = "ESP_INFO"
		gui.Adornee = root
		gui.Size = UDim2.new(0, 220, 0, 20)
		gui.StudsOffset = Vector3.new(0, -3, 0)
		gui.AlwaysOnTop = true
		gui.LightInfluence = 0
		gui.Parent = root

		local texto = Instance.new("TextLabel")
		texto.Name = "Texto"
		texto.Size = UDim2.new(1, 0, 1, 0)
		texto.BackgroundTransparency = 1
		texto.Font = Enum.Font.GothamBold
		texto.TextSize = 14
		texto.TextStrokeTransparency = 0.4
		texto.TextStrokeColor3 = Color3.new(0, 0, 0)
		texto.TextColor3 = espCor
		texto.Parent = gui
	end

	return gui
end

task.spawn(function()
	while task.wait(0.15) do
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				local char = player.Character
				local myChar = LocalPlayer.Character

				if char and myChar then
					local root = char:FindFirstChild("HumanoidRootPart")
					local myRoot = myChar:FindFirstChild("HumanoidRootPart")
					local humanoid = char:FindFirstChildOfClass("Humanoid")

					if root and myRoot and humanoid and humanoid.Health > 0 then
						local gui = criarESP(root)
						local texto = gui:FindFirstChild("Texto")

						local dist = math.floor((myRoot.Position - root.Position).Magnitude)

						local info = {}

						if espNomeAtivado then
							table.insert(info, player.Name)
						end

						if espDistanciaAtivado then
							table.insert(info, dist .. "m")
						end

						gui.Enabled = (#info > 0)

						if #info > 0 then
							texto.Text = table.concat(info, " ")
							texto.TextColor3 = espCor
						end
					end
				end
			end
		end
	end
end)

AddToggle(Visuais, {
	Name = "ESP Nome",
	Default = false,
	Callback = function(Value)
		espNomeAtivado = Value
	end
})

AddToggle(Visuais, {
	Name = "ESP Distância",
	Default = false,
	Callback = function(Value)
		espDistanciaAtivado = Value
	end
})

AddColorPicker(Visuais, {
	Name = "Cor ESP",
	Default = espCor,
	Callback = function(Value)
		espCor = Value
	end
})



local espAtivado = false
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function aplicarHighlight(player)
    if player == LocalPlayer then return end

    local character = player.Character
    if not character then return end

    local highlight = character:FindFirstChild("ESPHighlight")

    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.FillTransparency = 1
        highlight.OutlineTransparency = 0
        highlight.Adornee = character
        highlight.Parent = character
    end

    -- Verifica time
    if LocalPlayer.Team and player.Team then
        if LocalPlayer.Team == player.Team then
            highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
        else
            highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
        end
    else
        -- Caso o jogo não tenha Teams
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    end
end

local function removerHighlight(player)
    local character = player.Character
    if character then
        local highlight = character:FindFirstChild("ESPHighlight")
        if highlight then
            highlight:Destroy()
        end
    end
end

RunService.RenderStepped:Connect(function()
    if espAtivado then
        for _, player in ipairs(Players:GetPlayers()) do
            aplicarHighlight(player)
        end
    else
        for _, player in ipairs(Players:GetPlayers()) do
            removerHighlight(player)
        end
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if espAtivado then
            aplicarHighlight(player)
        end
    end)
end)

AddToggle(Visuais, {
    Name = "ESP Box",
    Default = false,
    Callback = function(Value)
        espAtivado = Value
    end
})


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local linhas = {}
local espConnections = {}
local espLinhaAtivado = false
local corVermelha = Color3.fromRGB(255, 0, 0)

local function criarLinha(player)
    if player == LocalPlayer then return end

    if linhas[player] then
        linhas[player]:Remove()
        linhas[player] = nil
    end
    if espConnections[player] then
        espConnections[player]:Disconnect()
        espConnections[player] = nil
    end

    local linha = Drawing.new("Line")
    linha.Thickness = 2
    linha.Transparency = 1
    linha.Visible = false
    linha.Color = corVermelha
    linhas[player] = linha

    espConnections[player] = RunService.RenderStepped:Connect(function()
        if not espLinhaAtivado then
            linha.Visible = false
            return
        end

        local char = player.Character
        local head = char and char:FindFirstChild("Head")
        if not head then
            linha.Visible = false
            return
        end

        local cam = workspace.CurrentCamera
        local screenSize = cam.ViewportSize
        local headPos, onScreen = cam:WorldToViewportPoint(head.Position)

        if onScreen then
            linha.From = Vector2.new(screenSize.X / 2, 0)
            linha.To = Vector2.new(headPos.X, headPos.Y)
            linha.Visible = true
        else
            linha.Visible = false
        end
    end)

    player.CharacterAdded:Connect(function()
        wait(1)
        if espLinhaAtivado then
            criarLinha(player)
        end
    end)
end

function ativarESP()
    for _, p in ipairs(Players:GetPlayers()) do
        criarLinha(p)
    end
    espConnections["PlayerAdded"] = Players.PlayerAdded:Connect(function(p)
        wait(1)
        criarLinha(p)
    end)
end

function desativarESP()
    for _, linha in pairs(linhas) do
        if linha then linha:Remove() end
    end
    linhas = {}
    for _, conn in pairs(espConnections) do
        if conn then conn:Disconnect() end
    end
    espConnections = {}
end

AddToggle(Visuais, {
    Name = "ESP Line",
    Default = false,
    Callback = function(Value)
        espLinhaAtivado = Value
        if espLinhaAtivado then
            ativarESP()
        else
            desativarESP()
        end
    end
})


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local antiSeatEnabled = false
local seatedConnection = nil
local characterConnection = nil
local seatWatcher = nil
local ignoreSeats = {}

-- Impede o personagem de sentar
local function preventSitting(character)
	local humanoid = character:WaitForChild("Humanoid", 5)
	if not humanoid then return end

	if seatedConnection then
		seatedConnection:Disconnect()
	end

	seatedConnection = humanoid.Seated:Connect(function(isSeated)
		if isSeated and antiSeatEnabled then
			humanoid.Sit = false
		end
	end)

	if humanoid.Sit then
		humanoid.Sit = false
	end
end

-- Torna todos os assentos não interativos
local function disableSeatTouch()
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Seat") or obj:IsA("VehicleSeat") then
			if not ignoreSeats[obj] then
				ignoreSeats[obj] = obj.CanTouch
				obj.CanTouch = false
			end
		end
	end
end

-- Restaura os assentos
local function restoreSeats()
	for seat, original in pairs(ignoreSeats) do
		if seat and seat:IsDescendantOf(workspace) then
			seat.CanTouch = original
		end
	end
	ignoreSeats = {}
end

-- Observa novos assentos adicionados
local function watchNewSeats()
	if seatWatcher then seatWatcher:Disconnect() end
	seatWatcher = workspace.DescendantAdded:Connect(function(desc)
		if antiSeatEnabled and (desc:IsA("Seat") or desc:IsA("VehicleSeat")) then
			task.wait(0.1)
			if desc:IsDescendantOf(workspace) then
				ignoreSeats[desc] = desc.CanTouch
				desc.CanTouch = false
			end
		end
	end)
end

-- Toggle Anti Sit
AddToggle(Config, {
	Name = "Anti Sit",
	Default = false,
	Callback = function(Value)
		antiSeatEnabled = Value

		if Value then
			if LocalPlayer.Character then
				preventSitting(LocalPlayer.Character)
			end

			if characterConnection then
				characterConnection:Disconnect()
			end
			characterConnection = LocalPlayer.CharacterAdded:Connect(preventSitting)

			disableSeatTouch()
			watchNewSeats()
		else
			if seatedConnection then
				seatedConnection:Disconnect()
				seatedConnection = nil
			end
			if characterConnection then
				characterConnection:Disconnect()
				characterConnection = nil
			end
			if seatWatcher then
				seatWatcher:Disconnect()
				seatWatcher = nil
			end

			restoreSeats()
		end
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
    Name = "Anti Fling",
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


local Workspace = game:GetService("Workspace")
local storedTransparency = {}

local function setXRay(state)
    if state then
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Transparency < 0.5 then
                storedTransparency[part] = part.Transparency
                part.Transparency = 0.7
            end
        end
    else
        for part, t in pairs(storedTransparency) do
            if part and part:IsA("BasePart") then
                part.Transparency = t
            end
        end
        storedTransparency = {}
    end
end

AddToggle(Config, {
    Name = "X-Ray",
    Default = false,
    Callback = function(state)
        setXRay(state)
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


-- Serviços

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variáveis do Aimbot
local AimbotEnabled = false
local AimbotConnection = nil
local FOVRadius = 100
local AimbotTargetPart = "Head"
local ChangeMode = false

-- Desenha o círculo de FOV
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Radius = FOVRadius

-- Correção do centro
local FOV_OffsetX = 5
local FOV_OffsetY = 0

-- Atualiza posição do círculo de FOV
RunService.RenderStepped:Connect(function()
    local screenSize = Camera.ViewportSize
    FOVCircle.Position = Vector2.new((screenSize.X / 2) + FOV_OffsetX, (screenSize.Y / 2) + FOV_OffsetY)
end)

-- Alterna entre Head e Neck automaticamente
local function toggleTargetPart()
    AimbotTargetPart = (AimbotTargetPart == "Head") and "Neck" or "Head"
end

-- Encontra o jogador mais próximo do FOV
local function getClosestPlayerToFOV()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= LocalPlayer and otherPlayer.Character then
            local part = otherPlayer.Character:FindFirstChild(AimbotTargetPart)
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - FOVCircle.Position).Magnitude
                    if dist < FOVCircle.Radius and dist < shortestDistance then
                        shortestDistance = dist
                        closestPlayer = otherPlayer
                    end
                end
            end
        end
    end

    return closestPlayer
end

-- Toggle do Aimbot
AddToggle(Combate, {
    Name = "Aimbot",
    Default = false,
    Callback = function(Value)
        AimbotEnabled = Value
        FOVCircle.Visible = Value

        if Value and not AimbotConnection then
            AimbotConnection = RunService.RenderStepped:Connect(function()
                if ChangeMode then toggleTargetPart() end
                local target = getClosestPlayerToFOV()
                if target and target.Character then
                    local part = target.Character:FindFirstChild(AimbotTargetPart)
                    if part then
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
                    end
                end
            end)
        elseif not Value and AimbotConnection then
            AimbotConnection:Disconnect()
            AimbotConnection = nil
        end
    end
})

-- Slider para controlar o tamanho do FOV
AddSlider(Combate, {
    Name = "Tamanho do FOV",
    MinValue = 20,
    MaxValue = 100,
    Default = FOVRadius,
    Increase = 1,
    Callback = function(Value)
        FOVRadius = Value
        FOVCircle.Radius = FOVRadius
    end
})


--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// SETTINGS
local AimAssistEnabled = false
local FOV_RADIUS = 80
local SMOOTHNESS = 0.12

--// TOGGLE (SEU HUB)
AddToggle(Combate, {
    Name = "Aim Assist",
    Default = false,
    Callback = function(Value)
        AimAssistEnabled = Value
    end
})

--// GET TARGET DENTRO DO FOV
local function GetClosestTarget()
    local closest = nil
    local shortest = FOV_RADIUS

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")

            if head then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)

                if onScreen then
                    local center = Vector2.new(
                        Camera.ViewportSize.X / 2,
                        Camera.ViewportSize.Y / 2
                    )

                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude

                    if dist < shortest then
                        shortest = dist
                        closest = head
                    end
                end
            end
        end
    end

    return closest
end

--// AIM LOOP
RunService.RenderStepped:Connect(function()
    if not AimAssistEnabled then return end

    local target = GetClosestTarget()

    if target then
        local current = Camera.CFrame
        local goal = CFrame.new(current.Position, target.Position)

        Camera.CFrame = current:Lerp(goal, SMOOTHNESS)
    end
end)

