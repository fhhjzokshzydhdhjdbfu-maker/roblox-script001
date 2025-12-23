-- PLAYER LINE ESP + UI (STABLE)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ================= SETTINGS =================
local ESP_ON = true
local lineThickness = 2

local colors = {
	{ name="WHITE", value=Color3.new(1,1,1) },
	{ name="RED", value=Color3.fromRGB(255,0,0) },
	{ name="GREEN", value=Color3.fromRGB(0,255,0) },
	{ name="BLUE", value=Color3.fromRGB(0,170,255) },
	{ name="YELLOW", value=Color3.fromRGB(255,255,0) },
	{ name="RAINBOW", value="RAINBOW" }
}
local colorIndex = 1
local hue = 0

local lines = {}

-- ================= LINE FUNCTIONS =================
local function removeLine(player)
	if lines[player] then
		lines[player]:Remove()
		lines[player] = nil
	end
end

local function createLine(player)
	if lines[player] then return end
	local l = Drawing.new("Line")
	l.Visible = false
	l.Transparency = 1
	l.Thickness = lineThickness
	lines[player] = l
end

-- ================= PLAYER HANDLING =================
local function onCharacterAdded(player, character)
	if player == LocalPlayer then return end

	createLine(player)

	local hum = character:WaitForChild("Humanoid",5)
	if hum then
		hum.Died:Connect(function()
			removeLine(player)
		end)
	end
end

for _,p in ipairs(Players:GetPlayers()) do
	if p ~= LocalPlayer then
		if p.Character then
			onCharacterAdded(p, p.Character)
		end
		p.CharacterAdded:Connect(function(char)
			onCharacterAdded(p, char)
		end)
	end
end

Players.PlayerAdded:Connect(function(player)
	if player ~= LocalPlayer then
		player.CharacterAdded:Connect(function(char)
			onCharacterAdded(player, char)
		end)
	end
end)

Players.PlayerRemoving:Connect(removeLine)

-- ================= RENDER =================
RunService.RenderStepped:Connect(function()
	if colors[colorIndex].value == "RAINBOW" then
		hue = (hue + 0.01) % 1
	end

	for player, line in pairs(lines) do
		if ESP_ON
		and player.Character
		and player.Character:FindFirstChild("HumanoidRootPart")
		then
			local root = player.Character.HumanoidRootPart
			local pos, onScreen = Camera:WorldToViewportPoint(root.Position)

			if onScreen then
				line.Visible = true
				line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y - 5)
				line.To = Vector2.new(pos.X, pos.Y)
				line.Thickness = lineThickness
				line.Color =
					(colors[colorIndex].value == "RAINBOW")
					and Color3.fromHSV(hue,1,1)
					or colors[colorIndex].value
			else
				line.Visible = false
			end
		else
			line.Visible = false
		end
	end
end)

-- ================= UI =================
local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(260,180)
frame.Position = UDim2.new(0.5,-130,0.25,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "LINE ESP UI"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local function makeBtn(text, y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0.8,0,0,32)
	b.Position = UDim2.new(0.1,0,0,y)
	b.Text = text
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b)
	return b
end

local espBtn = makeBtn("ESP : ON", 50)
local colorBtn = makeBtn("COLOR : WHITE", 90)

local hideBtn = Instance.new("TextButton", frame)
hideBtn.Size = UDim2.fromOffset(30,30)
hideBtn.Position = UDim2.new(1,-35,0,5)
hideBtn.Text = "×"
hideBtn.TextScaled = true
hideBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", hideBtn)

local ball = Instance.new("TextButton", gui)
ball.Size = UDim2.fromOffset(45,45)
ball.Position = UDim2.new(0,15,0.5,-22)
ball.BackgroundColor3 = Color3.fromRGB(0,120,255)
ball.Text = "👁"
ball.TextScaled = true
ball.TextColor3 = Color3.new(1,1,1)
ball.Visible = false
ball.Active = true
ball.Draggable = true
Instance.new("UICorner", ball).CornerRadius = UDim.new(1,0)

-- ================= UI ACTIONS =================
espBtn.MouseButton1Click:Connect(function()
	ESP_ON = not ESP_ON
	espBtn.Text = ESP_ON and "ESP : ON" or "ESP : OFF"
end)

colorBtn.MouseButton1Click:Connect(function()
	colorIndex = colorIndex % #colors + 1
	colorBtn.Text = "COLOR : "..colors[colorIndex].name
end)

hideBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	ball.Visible = true
end)

ball.MouseButton1Click:Connect(function()
	frame.Visible = true
	ball.Visible = false
end)
