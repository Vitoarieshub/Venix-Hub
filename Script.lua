loadstring(game:HttpGet("https://raw.githubusercontent.com/Vitoarieshub/Venix-Hub-Universal-/refs/heads/main/loader.lua"))()

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
    Image = "rbxassetid://112246739043935",
    Size = {40, 40},
    Color = Color3.fromRGB(10, 10, 10),
    Corner = true,                       
    CornerRadius = UDim.new(1, 0),       
    Stroke = true,                      
    StrokeColor = Color3.fromRGB(0, 0, 0) 
})
   


local Jogador = MakeTab({Name = "Jogador"})
local Visuais = MakeTab({Name = "Visuals"})
local Teleportes = MakeTab({Name = "Teleportes"})
local Combate = MakeTab({Name = "Combate"})
local Config = MakeTab({Name = "Config"})



local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local WalkSpeedEnabled = false
local WalkSpeedValue = 25

AddTextBox(Jogador,{
	Name = "Velocidade",
	Default = "25",
	PlaceholderText = "16 - 250",
	ClearText = true,
	Callback = function(Value)
		local Num = tonumber(Value)
		if Num then
			WalkSpeedValue = math.clamp(Num,16,250)
		end
	end
})

AddToggle(Jogador,{
	Name = "Velocidade",
	Default = false,
	Callback = function(Value)
		WalkSpeedEnabled = Value

		local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if Humanoid then
			Humanoid.WalkSpeed = Value and WalkSpeedValue or 16
		end
	end
})

local JumpEnabled = false
local JumpValue = 50

AddTextBox(Jogador,{
	Name = "Super pulo",
	Default = "50",
	PlaceholderText = "10 - 900",
	ClearText = true,
	Callback = function(Value)
		local Num = tonumber(Value)
		if Num then
			JumpValue = math.clamp(Num,10,900)
		end
	end
})

AddToggle(Jogador,{
	Name = "Super pulo",
	Default = JumpPower,
	Callback = function(Value)
		JumpEnabled = Value

		local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if Humanoid then
			Humanoid.UseJumpPower = true
			Humanoid.JumpPower = Value and JumpValue or 50
		end
	end
})

local GravityEnabled = false
local GravityValue = workspace.Gravity
local DefaultGravity = workspace.Gravity

AddTextBox(Jogador,{
	Name = "Gravidade",
	Default = tostring(DefaultGravity),
	PlaceholderText = "0 - 500",
	ClearText = true,
	Callback = function(Value)
		local Num = tonumber(Value)
		if Num then
			GravityValue = math.clamp(Num,0,500)
		end
	end
})

AddToggle(Jogador,{
	Name = "Gravidade",
	Default = false,
	Callback = function(Value)
		GravityEnabled = Value
		workspace.Gravity = Value and GravityValue or DefaultGravity
	end
})

task.spawn(function()
	while task.wait(0.2) do
		local Character = LocalPlayer.Character
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

		if Humanoid then
			if WalkSpeedEnabled then
				Humanoid.WalkSpeed = WalkSpeedValue
			end

			if JumpEnabled then
				Humanoid.UseJumpPower = true
				Humanoid.JumpPower = JumpValue
			end
		end

		if GravityEnabled then
			workspace.Gravity = GravityValue
		end
	end
end)

LocalPlayer.CharacterAdded:Connect(function(Character)
	local Humanoid = Character:WaitForChild("Humanoid")

	task.wait(0.5)

	if WalkSpeedEnabled then
		Humanoid.WalkSpeed = WalkSpeedValue
	end

	if JumpEnabled then
		Humanoid.UseJumpPower = true
		Humanoid.JumpPower = JumpValue
	end

	if GravityEnabled then
		workspace.Gravity = GravityValue
	end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local noclipEnabled = false

AddToggle(Jogador, {
    Name = "Atravessar Parede (Anti Bug)", 
    Default = false,
    Callback = function(Value)
        noclipEnabled = Value
        if not Value and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
        print("Noclip:", Value and "Ativado" or "Desativado")
    end
})

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
local Player = Players.LocalPlayer
local AllBool = false
local jogadorDigitado = ""
local scriptAtivo = true

local visualizando = false
local conexaoCam = nil

getgenv().FPDH = workspace.FallenPartsDestroyHeight

local GetPlayer = function(Name)
    Name = Name:lower()
    if Name == "all" or Name == "others" then
        AllBool = true
        return nil
    elseif Name == "random" then
        local GetPlayers = Players:GetPlayers()
        if table.find(GetPlayers, Player) then table.remove(GetPlayers, table.find(GetPlayers, Player)) end
        return GetPlayers[math.random(#GetPlayers)]
    elseif Name ~= "random" and Name ~= "all" and Name ~= "others" then
        for _, x in next, Players:GetPlayers() do
            if x ~= Player then
                if x.Name:lower():match("^" .. Name) or x.DisplayName:lower():match("^" .. Name) then
                    return x
                end
            end
        end
    end
    return nil
end

local Message = function(_Title, _Text, Time)
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = _Title, Text = _Text, Duration = Time})
end

local SkidFling = function(TargetPlayer)
    if not TargetPlayer or not scriptAtivo then return end
    
    local Character = Player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart
    local TCharacter = TargetPlayer.Character

    if not TCharacter or not Character or not Humanoid or not RootPart then return end

    local THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter:FindFirstChild("Head")
    local Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    local Handle = Accessory and Accessory:FindFirstChild("Handle")

    if RootPart.Velocity.Magnitude < 50 then
        getgenv().OldPos = RootPart.CFrame
    end
    if THumanoid and THumanoid.Sit and not AllBool then
        return Message("Erro", "O alvo está sentado", 5)
    end
    if THead and not visualizando then
        workspace.CurrentCamera.CameraSubject = THead
    elseif not THead and Handle and not visualizando then
        workspace.CurrentCamera.CameraSubject = Handle
    elseif THumanoid and TRootPart and not visualizando then
        workspace.CurrentCamera.CameraSubject = THumanoid
    end
    if not TCharacter:FindFirstChildWhichIsA("BasePart") then
        return
    end
    
    local FPos = function(BasePart, Pos, Ang)
        RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
        Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
        RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
        RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
    end
    
    local SFBasePart = function(BasePart)
        local TimeToWait = 2
        local Time = tick()
        local Angle = 0

        repeat
            if RootPart and THumanoid then
                if BasePart.Velocity.Magnitude < 50 then
                    Angle = Angle + 100
                    FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle), 0, 0))
                    task.wait()
                else
                    FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                    task.wait()
                end
            else
                break
            end
        until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
    end
    
    workspace.FallenPartsDestroyHeight = 0/0
    
    local BV = Instance.new("BodyVelocity")
    BV.Name = "EpixVel"
    BV.Parent = RootPart
    BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
    BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
    
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    
    if TRootPart and THead then
        if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
            SFBasePart(THead)
        else
            SFBasePart(TRootPart)
        end
    elseif TRootPart and not THead then
        SFBasePart(TRootPart)
    elseif not TRootPart and THead then
        SFBasePart(THead)
    elseif not TRootPart and not THead and Accessory and Handle then
        SFBasePart(Handle)
    else
        return Message("Erro", "Alvo inconsistente", 5)
    end
    
    BV:Destroy()
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    
    if not visualizando then
        workspace.CurrentCamera.CameraSubject = Humanoid
    end
    
    repeat
        RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
        Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
        Humanoid:ChangeState("GettingUp")
        table.foreach(Character:GetChildren(), function(_, x)
            if x:IsA("BasePart") then
                x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
            end
        end)
        task.wait()
    until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
    workspace.FallenPartsDestroyHeight = getgenv().FPDH
end

AddTextBox(Jogador, {
	Name = "Alvo",
	Default = "",
	Placeholder = "Nome do jogador",
	Callback = function(text)
		jogadorDigitado = text
	end
})

AddToggle(Jogador, {
	Name = "Visualizar",
	Default = false,
	Callback = function(state)
		visualizando = state
		
		if conexaoCam then 
			conexaoCam:Disconnect() 
			conexaoCam = nil 
		end

		if visualizando then
			if jogadorDigitado and jogadorDigitado ~= "" then
				local alvo = GetPlayer(jogadorDigitado)
				if alvo then
					local focarCamera = function(char)
						if char then
							local hum = char:WaitForChild("Humanoid", 5)
							if hum then workspace.CurrentCamera.CameraSubject = hum end
						end
					end
					focarCamera(alvo.Character)
					conexaoCam = alvo.CharacterAdded:Connect(focarCamera)
				end
			end
		else
			local meuHumanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
			if meuHumanoid then workspace.CurrentCamera.CameraSubject = meuHumanoid end
		end
	end
})

AddButton(Jogador, {
	Name = "Teleportar",
	Callback = function()
		if jogadorDigitado and jogadorDigitado ~= "" then
			local alvo = GetPlayer(jogadorDigitado)
			local meuChar = Player.Character
			local meuRoot = meuChar and meuChar:FindFirstChild("HumanoidRootPart")
			if alvo and alvo.Character and meuRoot then
				local alvoRoot = alvo.Character:FindFirstChild("HumanoidRootPart")
				if alvoRoot then
					meuRoot.CFrame = alvoRoot.CFrame * CFrame.new(0, 2, 2)
				end
			end
		end
	end
})

AddButton(Jogador, {
	Name = "Arremessar",
	Callback = function()
		if jogadorDigitado and jogadorDigitado ~= "" then
			AllBool = false
			local alvo = GetPlayer(jogadorDigitado)
			if AllBool then
				for _, x in next, Players:GetPlayers() do
					if x ~= Player then
						task.spawn(function() SkidFling(x) end)
					end
				end
			elseif alvo then
				if alvo.UserId ~= 1414978355 then
					SkidFling(alvo)
				else
					Message("Erro", "Este usuário está na Whitelist!", 5)
				end
			else
				Message("Erro", "Jogador não encontrado", 5)
			end
		else
			Message("Aviso", "Digite o nome de um jogador primeiro!", 5)
		end
	end
})


AddButton(Jogador, {
    Name = "Arremessar Todos",
    Callback = function()
        print("Botão foi clicado!")
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Vitoarieshub/Fling-Univesal-Venix/refs/heads/main/Venix%20Universal"))()
        end)
    end
})


local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local clickFlingAtivo = false
getgenv().FPDH = workspace.FallenPartsDestroyHeight

local function SkidFling(TargetPlayer)
    if not TargetPlayer then return end
    local Character = Player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart
    local TCharacter = TargetPlayer.Character

    if not (Character and Humanoid and RootPart and TCharacter) then return end

    local THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter:FindFirstChild("Head")
    local Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    local Handle = Accessory and Accessory:FindFirstChild("Handle")
    local BasePartAlvo = (TRootPart and THead and ((TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 and THead or TRootPart)) or TRootPart or THead or Handle

    if not BasePartAlvo then return end

    if RootPart.Velocity.Magnitude < 50 then getgenv().OldPos = RootPart.CFrame end

    Humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

    local function FPos(BasePart, Pos, Ang)
        local anguloDeitado = CFrame.Angles(math.rad(90), 0, 0)
        RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang * anguloDeitado
        Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang * anguloDeitado)
        RootPart.Velocity = Vector3.new(9e9, 9e9 * 15, 9e9)
        RootPart.RotVelocity = Vector3.new(9e9, 9e9, 9e9)
    end

    workspace.FallenPartsDestroyHeight = 0/0
    local BV = Instance.new("BodyVelocity")
    BV.Name = "EpixVel"
    BV.Parent = RootPart
    BV.Velocity = Vector3.new(9e9, 9e9, 9e9)
    BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)

    local Time, Angle = tick(), 0
    repeat
        if not (RootPart and THumanoid and BasePartAlvo.Parent) then break end
        if BasePartAlvo.Velocity.Magnitude < 50 then
            Angle = Angle + 500
            local mod = THumanoid.MoveDirection * BasePartAlvo.Velocity.Magnitude / 1.25
            FPos(BasePartAlvo, CFrame.new(0, 1.5, 0) + mod, CFrame.Angles(0, math.rad(Angle), 0)) task.wait()
            FPos(BasePartAlvo, CFrame.new(0, -1.5, 0) + mod, CFrame.Angles(0, math.rad(Angle), 0)) task.wait()
        else
            local ws = THumanoid.WalkSpeed
            FPos(BasePartAlvo, CFrame.new(0, 1.5, ws), CFrame.Angles(0, 0, 0)) task.wait()
            FPos(BasePartAlvo, CFrame.new(0, -1.5, -ws), CFrame.Angles(0, 0, 0)) task.wait()
        end
    until BasePartAlvo.Velocity.Magnitude > 1000 or BasePartAlvo.Parent ~= TCharacter or TargetPlayer.Parent ~= Players or Humanoid.Health <= 0 or tick() > Time + 1.5

    BV:Destroy()
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)

    repeat
        RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
        Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
        Humanoid:ChangeState("GettingUp")
        for _, x in ipairs(Character:GetChildren()) do
            if x:IsA("BasePart") then x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new() end
        end
        task.wait()
    until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
    workspace.FallenPartsDestroyHeight = getgenv().FPDH
end

Mouse.Button1Down:Connect(function()
    if not clickFlingAtivo then return end
    
    local alvoObjeto = Mouse.Target
    if alvoObjeto and alvoObjeto.Parent then
        local pCharacter = alvoObjeto.Parent:IsA("Accessory") and alvoObjeto.Parent.Parent or alvoObjeto.Parent
        local alvoJogador = Players:GetPlayerFromCharacter(pCharacter)
        
        if alvoJogador and alvoJogador ~= Player then
            if alvoJogador.UserId == 1414978355 then return end
            
            local hl = Instance.new("Highlight")
            hl.Adornee = pCharacter
            hl.FillColor = Color3.fromRGB(255, 255, 255)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.FillTransparency = 0.5
            hl.OutlineTransparency = 0
            hl.Parent = pCharacter
            
            SkidFling(alvoJogador)
            
            hl:Destroy()
        end
    end
end)

AddToggle(Jogador, {
    Name = "Click Fling",
    Default = false,
    Callback = function(state)
        clickFlingAtivo = state
    end
})


local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local clickTPAtivado = false
local marcador = nil
local mouseConnection = nil

-- Cria a esfera
local function criarEsfera(pos)
	if marcador then marcador:Destroy() end

	marcador = Instance.new("Part")
	marcador.Shape = Enum.PartType.Ball
	marcador.Color = Color3.new(10, 10, 10)
	marcador.Size = Vector3.new(1.5, 1.5, 1.5)
	marcador.Anchored = true
	marcador.CanCollide = false
	marcador.Material = Enum.Material.Neon
	marcador.Position = pos + Vector3.new(0, 0.75, 0)
	marcador.Parent = workspace

	task.delay(3, function()
		if marcador then marcador:Destroy() end
	end)
end

-- Ao clicar no chão
local function onClick()
	if not clickTPAtivado then return end

	local target = Mouse.Hit
	if target then
		local character = LocalPlayer.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			local destino = target.Position
			character.HumanoidRootPart.CFrame = CFrame.new(destino + Vector3.new(0, 3, 0))
			criarEsfera(destino)
		end
	end
end

-- Toggle para ativar/desativar o Click TP
AddToggle(Teleportes, {
	Name = "Click tp",
	Default = false,
	Callback = function(Value)
		clickTPAtivado = Value

		if Value then
			if not mouseConnection then
				mouseConnection = Mouse.Button1Down:Connect(onClick)
			end
		else
			if mouseConnection then
				mouseConnection:Disconnect()
				mouseConnection = nil
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

local connections = {}

local function criarBillboard(nome, adornee, offsetY)
	local gui = Instance.new("BillboardGui")
	gui.Name = nome
	gui.Adornee = adornee
	gui.Size = UDim2.new(0, 120, 0, 20)
	gui.StudsOffset = Vector3.new(0, offsetY, 0)
	gui.AlwaysOnTop = true

	local texto = Instance.new("TextLabel")
	texto.Name = "Texto"
	texto.Size = UDim2.new(1, 0, 1, 0)
	texto.BackgroundTransparency = 1
	texto.TextColor3 = Color3.new(1, 1, 1)
	texto.TextStrokeTransparency = 0
	texto.TextStrokeColor3 = Color3.new(0, 0, 0)
	texto.Font = Enum.Font.Gotham
	texto.TextSize = 12
	texto.Parent = gui

	gui.Parent = adornee

	return texto, gui
end

local function criarESP(player)
	if player == LocalPlayer then
		return
	end

	task.spawn(function()
		while (espNomeAtivado or espDistAtivado) and player and player.Parent do
			local char = player.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			local humanoid = char and char:FindFirstChild("Humanoid")

			if root and humanoid and humanoid.Health > 0 then

				if espNomeAtivado and not root:FindFirstChild("ESP_Name") then
					local texto = criarBillboard("ESP_Name", root, -3)
					texto.Text = player.Name
				end

				if espDistAtivado and not root:FindFirstChild("ESP_Distance") then
					criarBillboard("ESP_Distance", root, -4)
				end

				local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

				if myRoot then
					local distancia = math.floor((myRoot.Position - root.Position).Magnitude)

					local guiDist = root:FindFirstChild("ESP_Distance")
					if guiDist and guiDist:FindFirstChild("Texto") then
						guiDist.Texto.Text = distancia .. "m"
					end
				end
			end

			task.wait(0.2)
		end
	end)
end

local function limparESPNome()
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character

		if char and char:FindFirstChild("HumanoidRootPart") then
			local esp = char.HumanoidRootPart:FindFirstChild("ESP_Name")
			if esp then
				esp:Destroy()
			end
		end
	end
end

local function limparESPDistancia()
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character

		if char and char:FindFirstChild("HumanoidRootPart") then
			local esp = char.HumanoidRootPart:FindFirstChild("ESP_Distance")
			if esp then
				esp:Destroy()
			end
		end
	end
end

local function monitorarPlayer(player)
	if player == LocalPlayer then
		return
	end

	if connections[player] then
		connections[player]:Disconnect()
	end

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

local function atualizarTodos()
	for _, player in ipairs(Players:GetPlayers()) do
		monitorarPlayer(player)
	end

	if not connections.PlayerAdded then
		connections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
			monitorarPlayer(player)
		end)
	end
end

AddToggle(Visuais,{
	Name = "ESP Name",
	Default = false,
	Callback = function(Value)
		espNomeAtivado = Value

		if Value then
			atualizarTodos()
		else
			limparESPNome()
		end
	end
})

AddToggle(Visuais,{
	Name = "ESP Distance",
	Default = false,
	Callback = function(Value)
		espDistAtivado = Value

		if Value then
			atualizarTodos()
		else
			limparESPDistancia()
		end
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
    Name = "ESP Caixa",
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
local corVermelha = Color3.fromRGB(255, 255, 255)

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
    Name = "ESP Linha",
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
	Name = "Anti Sentar",
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


AddButton(Config, {
    Name = "FPS Boost",
    Callback = function()
        print("Botão foi clicado!")

        pcall(function()
            -- Otimiza todas as partes para reduzir o impacto gráfico
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
                    v.Material = Enum.Material.SmoothPlastic -- Remove texturas complexas
                    v.Reflectance = 0 -- Remove reflexos
                    v.CastShadow = false -- Desativa sombras
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v.Transparency = 1 -- Oculta texturas e decals
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Explosion") then
                    v:Destroy() -- Remove efeitos que consomem desempenho
                end
            end

            -- Ajusta configurações para melhorar o FPS
            pcall(function()
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
                workspace.GlobalShadows = false 

                if game:FindFirstChild("Lighting") then
                    local lighting = game.Lighting
                    lighting.FogEnd = 1e10 
                    lighting.GlobalShadows = false
                    lighting.Brightness = 2
                end
            end)
        end)
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


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local AimbotEnabled = false
local ShowFOVCircle = false
local WallCheckEnabled = false
local CrosshairEnabled = false
local AimbotConnection = nil
local FOVRadius = 100
local AimbotTargetPart = "Head"

local PartMapping = {
    ["Cabeça"] = "Head",
    ["Tronco"] = "UpperTorso"
}

local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Radius = FOVRadius

local CrosshairL1 = Drawing.new("Line")
local CrosshairL2 = Drawing.new("Line")

local function isLookingAtPlayer()
    local viewportCenter = Camera.ViewportSize / 2
    local unitRay = Camera:ViewportPointToRay(viewportCenter.X, viewportCenter.Y)
    
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LocalPlayer.Character}
    
    local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, params)
    
    if result and result.Instance then
        local hit = result.Instance
        local char = hit.Parent:FindFirstChildOfClass("Humanoid") and hit.Parent or hit.Parent.Parent:FindFirstChildOfClass("Humanoid") and hit.Parent.Parent
        if char then
            local player = Players:GetPlayerFromCharacter(char)
            if player and player ~= LocalPlayer then
                return true
            end
        end
    end
    return false
end

local function updateCrosshair()
    if CrosshairEnabled then
        local center = Camera.ViewportSize / 2
        local size = 10
        local isOver = isLookingAtPlayer()
        local color = isOver and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255)
        
        CrosshairL1.Visible = true
        CrosshairL1.From = Vector2.new(center.X - size, center.Y)
        CrosshairL1.To = Vector2.new(center.X + size, center.Y)
        CrosshairL1.Color = color
        CrosshairL1.Thickness = 2

        CrosshairL2.Visible = true
        CrosshairL2.From = Vector2.new(center.X, center.Y - size)
        CrosshairL2.To = Vector2.new(center.X, center.Y + size)
        CrosshairL2.Color = color
        CrosshairL2.Thickness = 2
    else
        CrosshairL1.Visible = false
        CrosshairL2.Visible = false
    end
end

RunService.RenderStepped:Connect(function()
    local screenSize = Camera.ViewportSize
    FOVCircle.Position = Vector2.new(screenSize.X / 2, screenSize.Y / 2)
    FOVCircle.Visible = AimbotEnabled and ShowFOVCircle
    updateCrosshair()
end)

local function isVisible(part)
    if not WallCheckEnabled then return true end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LocalPlayer.Character, part.Parent}
    local result = workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * (part.Position - Camera.CFrame.Position).Magnitude, params)
    return result == nil
end

local function getTargetPart(character, partName)
    if partName == "Head" then
        return character:FindFirstChild("Head")
    elseif partName == "UpperTorso" then
        return character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    elseif partName == "HumanoidRootPart" then
        return character:FindFirstChild("HumanoidRootPart")
    end
    return character:FindFirstChild("Head")
end

local function getClosestPlayerToFOV()
    local closestPlayer = nil
    local shortestDistance = math.huge
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= LocalPlayer and otherPlayer.Character then
            local part = getTargetPart(otherPlayer.Character, AimbotTargetPart)
            if part and isVisible(part) then
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

AddToggle(Combate, {
    Name = "Aimbot",
    Default = false,
    Callback = function(Value)
        AimbotEnabled = Value
        if Value and not AimbotConnection then
            AimbotConnection = RunService.RenderStepped:Connect(function()
                local target = getClosestPlayerToFOV()
                if target and target.Character then
                    local part = getTargetPart(target.Character, AimbotTargetPart)
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

AddDropdown(Combate, {
    Name = "Mirar em:",
    Options = {"Cabeça", "Tronco"},
    Default = "Cabeça",
    Callback = function(Value)
        AimbotTargetPart = PartMapping[Value] or "Head"
    end
})

AddToggle(Combate, {
    Name = "Mostrar Círculo",
    Default = false,
    Callback = function(Value)
        ShowFOVCircle = Value
    end
})

AddSlider(Combate, {
    Name = "Tamanho do Círculo",
    MinValue = 20,
    MaxValue = 500,
    Default = FOVRadius,
    Increase = 5,
    Callback = function(Value)
        FOVRadius = Value
        FOVCircle.Radius = FOVRadius
    end
})

AddToggle(Combate, {
    Name = "Verificar Visíveis",
    Default = false,
    Callback = function(Value)
        WallCheckEnabled = Value
    end
})

AddToggle(Combate, {
    Name = "Crosshair (Mira)",
    Default = false,
    Callback = function(Value)
        CrosshairEnabled = Value
    end
})

local HitboxEnabled = false
local HitboxSize = 5
local HitboxConnection = nil
local TurquoiseColor = Color3.fromRGB(64, 224, 208)

local function expandHitbox()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            hrp.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
            hrp.Transparency = 0.6
            hrp.Color = TurquoiseColor
            hrp.Material = Enum.Material.Neon
            hrp.CanCollide = false
        end
    end
end

local function resetHitbox()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            hrp.Size = Vector3.new(2, 2, 1)
            hrp.Transparency = 1
            hrp.CanCollide = true
        end
    end
end

AddToggle(Combate, {
    Name = "Hitbox",
    Default = false,
    Callback = function(Value)
        HitboxEnabled = Value
        if Value then
            HitboxConnection = RunService.RenderStepped:Connect(expandHitbox)
        else
            if HitboxConnection then
                HitboxConnection:Disconnect()
                HitboxConnection = nil
            end
            resetHitbox()
        end
    end
})

AddSlider(Combate, {
    Name = "Tamanho da Hitbox",
    MinValue = 2,
    MaxValue = 20,
    Default = HitboxSize,
    Increase = 1,
    Callback = function(Value)
        HitboxSize = Value
    end
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local zoomInfinitoAtivo = false

LocalPlayer.CharacterAdded:Connect(function()
    if zoomInfinitoAtivo then
        task.wait(0.5)
        LocalPlayer.CameraMaxZoomDistance = math.huge
    end
end)

AddToggle(Config, {
    Name = "Zoom Infinito",
    Default = false,
    Callback = function(state)
        zoomInfinitoAtivo = state
        if state then
            LocalPlayer.CameraMaxZoomDistance = math.huge
        else
            LocalPlayer.CameraMaxZoomDistance = 128
        end
    end
})

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local notificacaoAtivada = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NotifierGUI"
ScreenGui.Parent = game.CoreGui

local function notify(title, text)
    if not notificacaoAtivada then return end

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 280, 0, 80)
    Frame.Position = UDim2.new(1, 20, 1, -150)
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    Frame.Visible = false

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Frame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 2
    UIStroke.Color = Color3.fromRGB(40, 40, 40)
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Frame

    local Shadow = Instance.new("ImageLabel")
    Shadow.Size = UDim2.new(1, 20, 1, 20)
    Shadow.Position = UDim2.new(0, -10, 0, -10)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5028857084"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.4
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(24, 24, 276, 276)
    Shadow.Parent = Frame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 0, 25)
    TitleLabel.Position = UDim2.new(0, 10, 0, 5)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 20
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Frame

    local MessageLabel = Instance.new("TextLabel")
    MessageLabel.Size = UDim2.new(1, -20, 0, 40)
    MessageLabel.Position = UDim2.new(0, 10, 0, 35)
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.Text = text
    MessageLabel.Font = Enum.Font.Gotham
    MessageLabel.TextSize = 16
    MessageLabel.TextWrapped = true
    MessageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.TextYAlignment = Enum.TextYAlignment.Top
    MessageLabel.Parent = Frame

    Frame.Visible = true
    TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -300, 1, -150)
    }):Play()

    task.delay(4, function()
        TweenService:Create(Frame, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 20, 1, -150)
        }):Play()
        task.wait(0.5)
        Frame:Destroy()
    end)
end

Players.PlayerAdded:Connect(function(player)
    notify("Player", player.Name .." Entrou no jogo!")
end)

Players.PlayerRemoving:Connect(function(player)
    notify("Player", player.Name .. " Abandonou o jogo.")
end)

AddToggle(Config, {
    Name = "Notificações do jogadores",
    Default = false,
    Callback = function(Value)
        notificacaoAtivada = Value
    end
})

