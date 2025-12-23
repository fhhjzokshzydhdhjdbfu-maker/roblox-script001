-- PLAYER VISION & FAKE LASER (FOR YOUR OWN MAP)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ================= UI =================
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(300,220)
frame.Position = UDim2.new(0.5,-150,0.25,0)
frame.BackgroundColor3 = Color3.fromRGB(18,18,22)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,20)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,45)
title.BackgroundTransparency = 1
title.Text = "PLAYER VISION SYSTEM"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local function newButton(text,y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0.8,0,0,34)
	b.Position = UDim2.new(0.1,0,0,y)
	b.Text = text
	b.TextScaled = true
	b.Font = Enum.Font.Gotham
	b.BackgroundColor3 = Color3.fromRGB(35,35,45)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b)
	return b
end

local espBtn   = newButton("ESP : OFF",60)
local laserBtn = newButton("LASER : OFF",100)
local colorBtn = newButton("COLOR : WHITE",140)

local hideBtn = Instance.new("TextButton", frame)
hideBtn.Size = UDim2.fromOffset(32,32)
hideBtn.Position = UDim2.new(1,-38,0,6)
hideBtn.Text = "×"
hideBtn.TextScaled = true
hideBtn.BackgroundColor3 = Color3.fromRGB(60,60,70)
Instance.new("UICorner", hideBtn)

-- ลูกกลม
local ball = Instance.new("TextButton", gui)
ball.Size = UDim2.fromOffset(46,46)
ball.Position = UDim2.new(0,15,0.5,-23)
ball.Text = "👁"
ball.TextScaled = true
ball.BackgroundColor3 = Color3.fromRGB(0,140,255)
ball.Visible = false
ball.Active = true
ball.Draggable = true
Instance.new("UICorner", ball).CornerRadius = UDim.new(1,0)

-- ================= SYSTEM =================
local ESP_ON = false
local LASER_ON = false

local colors = {
	Color3.new(1,1,1),
	Color3.fromRGB(255,0,0),
	Color3.fromRGB(0,255,0),
	Color3.fromRGB(0,170,255),
	Color3.fromRGB(255,255,0),
}
local colorIndex = 1

local tracers = {}

local function removeTracer(p)
	if tracers[p] then
		tracers[p]:Remove()
		tracers[p] = nil
	end
end

local function getTracer(p)
	if not tracers[p] then
		local l = Drawing.new("Line")
		l.Visible = false
		l.Thickness = 2
		l.Transparency = 1
		tracers[p] = l
	end
	return tracers[p]
end

Players.PlayerRemoving:Connect(removeTracer)

RunService.RenderStepped:Connect(function()
	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local line = getTracer(p)
			local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)

			if (ESP_ON or LASER_ON) and onScreen then
				line.Visible = true
				line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
				line.To = Vector2.new(pos.X,pos.Y)
				line.Color = colors[colorIndex]
			else
				line.Visible = false
			end
		end
	end
end)

-- ================= BUTTONS =================
espBtn.MouseButton1Click:Connect(function()
	ESP_ON = not ESP_ON
	espBtn.Text = ESP_ON and "ESP : ON" or "ESP : OFF"
end)

laserBtn.MouseButton1Click:Connect(function()
	LASER_ON = not LASER_ON
	laserBtn.Text = LASER_ON and "LASER : ON" or "LASER : OFF"
end)

colorBtn.MouseButton1Click:Connect(function()
	colorIndex = colorIndex % #colors + 1
	colorBtn.Text = "COLOR : "..colorIndex
end)

hideBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	ball.Visible = true
end)

ball.MouseButton1Click:Connect(function()
	frame.Visible = true
	ball.Visible = false
end)
