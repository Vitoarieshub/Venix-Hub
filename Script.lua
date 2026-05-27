loadstring(game:HttpGet("https://raw.githubusercontent.com/Vitoarieshub/KALI-LINUX-/refs/heads/main/loader.lua"))()


MakeWindow({

    Hub = {

        Title = "Venix Hub",

        Animation = "Venix Universal"

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


local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local espNomeAtivado = false
local espDistAtivado = false
local espCor = Color3.fromRGB(255, 0, 0)

local connections = {}

-- Função para criar BillboardGui
local function criarBillboard(nome, adornee, offsetY)
	local gui = Instance.new("BillboardGui")
	gui.Name = nome
	gui.Adornee = adornee
	gui.Size = UDim2.new(0, 150, 0, 22) -- Aumentado
	gui.StudsOffset = Vector3.new(0, offsetY, 0)
	gui.AlwaysOnTop = true

	local texto = Instance.new("TextLabel")
	texto.Name = "Texto"
	texto.Size = UDim2.new(1, 0, 1, 0)
	texto.BackgroundTransparency = 1
	texto.TextColor3 = espCor
	texto.TextStrokeTransparency = (espCor == Color3.fromRGB(255, 255, 255)) and 1 or 0.4
	texto.TextStrokeColor3 = Color3.new(0, 0, 0)
	texto.Font = Enum.Font.Gotham
	texto.TextSize = 14 -- Aumentado
	texto.Parent = gui

	gui.Parent = adornee
	return texto, gui
end

-- Função para aplicar ESP
local function criarESP(player)
	if player == LocalPlayer then return end

	task.spawn(function()
		while (espNomeAtivado or espDistAtivado) and player and player.Character do
			local char = player.Character
			local head = char:FindFirstChild("Head")
			local root = char:FindFirstChild("HumanoidRootPart")
			local humanoid = char:FindFirstChild("Humanoid")

			if humanoid and humanoid.Health > 0 then
				-- ESP Nome
				if espNomeAtivado and head and not head:FindFirstChild("ESP_Name") then
					local texto, gui = criarBillboard("ESP_Name", head, 1.5)
					texto.Text = player.Name
					humanoid.Died:Connect(function() gui:Destroy() end)
				end

				-- ESP Distância
				if espDistAtivado and root and not root:FindFirstChild("ESP_Distancia") then
					local texto, gui = criarBillboard("ESP_Distancia", root, -3)
					humanoid.Died:Connect(function() gui:Destroy() end)
				end

				-- Atualizar distância
				if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and root then
					local lpPos = LocalPlayer.Character.HumanoidRootPart.Position
					local targetPos = root.Position
					local dist = math.floor((lpPos - targetPos).Magnitude)

					local guiDist = root:FindFirstChild("ESP_Distancia")
					if guiDist and guiDist:FindFirstChild("Texto") then
						guiDist.Texto.Text = dist .. "m"
						guiDist.Texto.TextColor3 = espCor
						guiDist.Texto.TextStrokeTransparency = (espCor == Color3.fromRGB(255, 255, 255)) and 1 or 0.4
					end
				end

				-- Atualizar nome
				if head then
					local guiNome = head:FindFirstChild("ESP_Name")
					if guiNome and guiNome:FindFirstChild("Texto") then
						guiNome.Texto.TextColor3 = espCor
						guiNome.Texto.TextStrokeTransparency = (espCor == Color3.fromRGB(255, 255, 255)) and 1 or 0.4
					end
				end
			end

			task.wait(0.3)
		end
	end)
end

-- Limpa apenas ESP Nome
local function limparESPNome()
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char then
			local head = char:FindFirstChild("Head")
			if head then
				local esp = head:FindFirstChild("ESP_Name")
				if esp then esp:Destroy() end
			end
		end
	end
end

-- Limpa apenas ESP Distância
local function limparESPDistancia()
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char then
			local root = char:FindFirstChild("HumanoidRootPart")
			if root then
				local esp = root:FindFirstChild("ESP_Distancia")
				if esp then esp:Destroy() end
			end
		end
	end
end

-- Monitoramento de players
local function monitorarPlayer(player)
	if connections[player] then connections[player]:Disconnect() end

	connections[player] = player.CharacterAdded:Connect(function()
		task.wait(1)
		if espNomeAtivado or espDistAtivado then
			criarESP(player)
		end
	end)

	if player.Character then
		criarESP(player)
	end
end

-- Atualiza todos os jogadores
local function atualizarTodos()
	for _, player in ipairs(Players:GetPlayers()) do
		monitorarPlayer(player)
	end
	if not connections["PlayerAdded"] then
		connections["PlayerAdded"] = Players.PlayerAdded:Connect(monitorarPlayer)
	end
end

-- BOTÃO: ESP Nome
AddToggle(Visuais, {
	Name = "ESP Name",
	Default = false,
	Callback = function(Value)
		espNomeAtivado = Value
		if espNomeAtivado then
			atualizarTodos()
		else
			limparESPNome()
		end
	end
})

-- BOTÃO: ESP Distância
AddToggle(Visuais, {
	Name = "ESP Distance",
	Default = false,
	Callback = function(Value)
		espDistAtivado = Value
		if espDistAtivado then
			atualizarTodos()
		else
			limparESPDistancia()
		end
	end
})

-- COR
AddColorPicker(Visuais, {
	Name = "Change Color",
	Default = espCor,
	Callback = function(Value)
		espCor = Value
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
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
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
AddToggle(Config, {
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
AddSlider(Config, {
    Name = "Tamanho do FOV",
    MinValue = 19,
    MaxValue = 190,
    Default = FOVRadius,
    Increase = 1,
    Callback = function(Value)
        FOVRadius = Value
        FOVCircle.Radius = FOVRadius
    end
})

