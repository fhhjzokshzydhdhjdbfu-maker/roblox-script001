-- LINE ESP + DISTANCE + UI
-- สร้างโดย MOU16924

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ================= STATE =================
local ESP_ENABLED = true
local UI_OPEN = true
local lineThickness = 2

-- ================= COLORS =================
local colors = {
	Color3.new(1,1,1), -- ขาว
	Color3.fromRGB(255,0,0),
	Color3.fromRGB(0,255,0),
	Color3.fromRGB(0,170,255),
	Color3.fromRGB(255,255,0),
	"RAINBOW"
}
local colorIndex = 1
local hue = 0

-- ================= STORAGE =================
local lines = {}
local texts = {}

-- ================= FUNCTIONS =================
local function removeESP(player)
	if lines[player] then
		lines[player]:Remove()
		lines[player] = nil
	end
	if texts[player] then
		texts[player]:Remove()
		texts[player] = nil
	end
end

local function createESP(player)
	if lines[player] then return end

	local line = Drawing.new("Line")
	line.Thickness = lineThickness
	line.Transparency = 1
	line.Visible = false

	local text = Drawing.new("Text")
	text.Size = 16
	text.Center = true
	text.Outline = true
	text.Visible = false

	lines[player] = line
	texts[player] = text
end

-- ================= PLAYER HANDLING =================
local function setupCharacter(player, character)
	if player == LocalPlayer then return end
	createESP(player)

	local hum = character:WaitForChild("Humanoid",5)
	if hum then
		hum.Died:Connect(function()
			removeESP(player)
		end)
	end
end

for _,p in ipairs(Players:GetPlayers()) do
	if p ~= LocalPlayer then
		if p.Character then
			setupCharacter(p, p.Character)
		end
		p.CharacterAdded:Connect(function(c)
			setupCharacter(p, c)
		end)
	end
end

Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function(c)
		setupCharacter(p, c)
	end)
end)

Players.PlayerRemoving:Connect(removeESP)

-- ================= RENDER =================
RunService.RenderStepped:Connect(function()
	if colors[colorIndex] == "RAINBOW" then
		hue = (hue + 0.01) % 1
	end

	for plr,line in pairs(lines) do
		local txt = texts[plr]
		if ESP_ENABLED
		and plr.Character
		and plr.Character:FindFirstChild("HumanoidRootPart")
		and LocalPlayer.Character
		and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		then
			local root = plr.Character.HumanoidRootPart
			local myRoot = LocalPlayer.Character.HumanoidRootPart
			local pos, onScreen = Camera:WorldToViewportPoint(root.Position)

			if onScreen then
				local dist = math.floor((myRoot.Position - root.Position).Magnitude)

				line.Visible = true
				txt.Visible = true

				line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
				line.To = Vector2.new(pos.X, pos.Y)

				txt.Position = Vector2.new(pos.X, pos.Y - 25)
				txt.Text = tostring(dist)

				local col = (colors[colorIndex] == "RAINBOW")
					and Color3.fromHSV(hue,1,1)
					or colors[colorIndex]

				line.Color = col
				txt.Color = col
			else
				line.Visible = false
				txt.Visible = false
			end
		else
			line.Visible = false
			txt.Visible = false
		end
	end
end)

-- ================= UI =================
local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(260,170)
frame.Position = UDim2.new(0.5,-130,0.25,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "สร้างโดย MOU16924"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local function makeBtn(text,y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0.8,0,0,30)
	b.Position = UDim2.new(0.1,0,0,y)
	b.Text = text
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b)
	return b
end

local espBtn = makeBtn("ESP : ON",45)
local colorBtn = makeBtn("COLOR",80)

local hideBtn = Instance.new("TextButton", frame)
hideBtn.Size = UDim2.fromOffset(28,28)
hideBtn.Position = UDim2.new(1,-33,0,5)
hideBtn.Text = "×"
hideBtn.TextScaled = true
hideBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", hideBtn)

local ball = Instance.new("TextButton", gui)
ball.Size = UDim2.fromOffset(45,45)
ball.Position = UDim2.new(1,-60,0,20)
ball.Text = "●"
ball.TextScaled = true
ball.BackgroundColor3 = Color3.fromRGB(0,120,255)
ball.TextColor3 = Color3.new(1,1,1)
ball.Visible = false
ball.Active = true
ball.Draggable = true
Instance.new("UICorner", ball).CornerRadius = UDim.new(1,0)

-- ================= UI ACTIONS =================
espBtn.MouseButton1Click:Connect(function()
	ESP_ENABLED = not ESP_ENABLED
	espBtn.Text = ESP_ENABLED and "ESP : ON" or "ESP : OFF"
end)

colorBtn.MouseButton1Click:Connect(function()
	colorIndex = colorIndex % #colors + 1
end)

hideBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	ball.Visible = true
end)

ball.MouseButton1Click:Connect(function()
	frame.Visible = true
	ball.Visible = false
end)
