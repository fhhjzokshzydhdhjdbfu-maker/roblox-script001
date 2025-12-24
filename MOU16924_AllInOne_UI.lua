-- MOU16924_AllInOne_UI.lua
-- สร้างโดย MOU16924

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ================= STATE =================
local UI_OPEN = true
local LOCK_HEAD = false
local NOCLIP = false
local ESP_ON = false

-- ================= UI =================
local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(360,260)
frame.Position = UDim2.new(0.65,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "ALL IN ONE UI"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local credit = Instance.new("TextLabel", frame)
credit.Size = UDim2.new(1,0,0,18)
credit.Position = UDim2.new(0,0,0,40)
credit.BackgroundTransparency = 1
credit.Text = "สร้างโดย MOU16924"
credit.TextColor3 = Color3.fromRGB(200,200,200)
credit.Font = Enum.Font.Gotham
credit.TextScaled = true

local function btn(text,y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0.9,0,0,34)
	b.Position = UDim2.new(0.05,0,0,y)
	b.Text = text
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(40,0,0)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b)
	return b
end

local headBtn = btn("HEAD LOCK : OFF",70)
local noclipBtn = btn("NOCLIP : OFF",110)
local espBtn = btn("ESP + DISTANCE : OFF",150)

local hideBtn = btn("HIDE UI",190)

local ball = Instance.new("TextButton", gui)
ball.Size = UDim2.fromOffset(46,46)
ball.Position = UDim2.new(0.93,-23,0.05,0)
ball.Text = "●"
ball.TextScaled = true
ball.BackgroundColor3 = Color3.fromRGB(120,0,0)
ball.TextColor3 = Color3.new(1,1,1)
ball.Visible = false
Instance.new("UICorner", ball).CornerRadius = UDim.new(1,0)

hideBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	ball.Visible = true
end)

ball.MouseButton1Click:Connect(function()
	frame.Visible = true
	ball.Visible = false
end)

-- ================= TOGGLES =================
headBtn.MouseButton1Click:Connect(function()
	LOCK_HEAD = not LOCK_HEAD
	headBtn.Text = LOCK_HEAD and "HEAD LOCK : ON" or "HEAD LOCK : OFF"
end)

noclipBtn.MouseButton1Click:Connect(function()
	NOCLIP = not NOCLIP
	noclipBtn.Text = NOCLIP and "NOCLIP : ON" or "NOCLIP : OFF"
end)

espBtn.MouseButton1Click:Connect(function()
	ESP_ON = not ESP_ON
	espBtn.Text = ESP_ON and "ESP + DISTANCE : ON" or "ESP + DISTANCE : OFF"
end)

-- ================= NOCLIP =================
RunService.Stepped:Connect(function()
	if NOCLIP and LocalPlayer.Character then
		for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

-- ================= HEAD LOCK =================
local function getVisibleHead()
	local camPos = Camera.CFrame.Position
	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
			local head = p.Character.Head
			local pos,vis = Camera:WorldToViewportPoint(head.Position)
			if vis and pos.Z > 0 then
				return head
			end
		end
	end
end

RunService.RenderStepped:Connect(function()
	if LOCK_HEAD then
		local head = getVisibleHead()
		if head then
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
		end
	end
end)

-- ================= ESP + DISTANCE =================
local drawings = {}

local function clearESP(p)
	if drawings[p] then
		drawings[p].Line:Remove()
		drawings[p].Text:Remove()
		drawings[p] = nil
	end
end

local function createESP(p)
	local l = Drawing.new("Line")
	l.Thickness = 2
	l.Color = Color3.new(1,1,1)

	local t = Drawing.new("Text")
	t.Size = 14
	t.Color = Color3.new(1,1,1)
	t.Center = true
	t.Outline = true

	drawings[p] = {Line=l,Text=t}
end

RunService.RenderStepped:Connect(function()
	for p,d in pairs(drawings) do
		if not ESP_ON or not p.Character or not p.Character:FindFirstChild("HumanoidRootPart") then
			d.Line.Visible = false
			d.Text.Visible = false
		else
			local hrp = p.Character.HumanoidRootPart
			local pos,vis = Camera:WorldToViewportPoint(hrp.Position)
			if vis then
				local dist = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
				d.Line.Visible = true
				d.Line.From = Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y)
				d.Line.To = Vector2.new(pos.X,pos.Y)
				d.Text.Visible = true
				d.Text.Position = Vector2.new(pos.X,pos.Y-15)
				d.Text.Text = tostring(dist)
			else
				d.Line.Visible = false
				d.Text.Visible = false
			end
		end
	end
end)

for _,p in ipairs(Players:GetPlayers()) do
	if p ~= LocalPlayer then
		createESP(p)
	end
end

Players.PlayerAdded:Connect(function(p)
	if p ~= LocalPlayer then
		createESP(p)
	end
end)

Players.PlayerRemoving:Connect(clearESP)
