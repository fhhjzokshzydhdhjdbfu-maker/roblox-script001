-- DEV ESP (SEE INVISIBLE PLAYERS)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ===== UI =====
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(260,160)
frame.Position = UDim2.new(0.5,-130,0.25,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,18)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "PLAYER VISION UI"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local espBtn = Instance.new("TextButton", frame)
espBtn.Size = UDim2.new(0.8,0,0,35)
espBtn.Position = UDim2.new(0.1,0,0,60)
espBtn.Text = "VISION : OFF"
espBtn.TextScaled = true
espBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
espBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", espBtn)

local hideBtn = Instance.new("TextButton", frame)
hideBtn.Size = UDim2.fromOffset(30,30)
hideBtn.Position = UDim2.new(1,-35,0,5)
hideBtn.Text = "×"
hideBtn.TextScaled = true
hideBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", hideBtn)

-- ลูกบอล
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

-- ===== ESP LOGIC =====
local ESP_ON = false
local highlights = {}

local function applyESP(char)
	if highlights[char] then return end
	local h = Instance.new("Highlight")
	h.FillColor = Color3.fromRGB(255,0,0)
	h.OutlineColor = Color3.new(1,1,1)
	h.FillTransparency = 0.25
	h.OutlineTransparency = 0
	h.Enabled = false
	h.Parent = char
	highlights[char] = h
end

local function updateESP()
	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character then
			applyESP(p.Character)
			highlights[p.Character].Enabled = ESP_ON
		end
	end
end

Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function(char)
		task.wait(0.5)
		applyESP(char)
	end)
end)

-- ===== BUTTONS =====
espBtn.MouseButton1Click:Connect(function()
	ESP_ON = not ESP_ON
	espBtn.Text = ESP_ON and "VISION : ON" or "VISION : OFF"
	updateESP()
end)

hideBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	ball.Visible = true
end)

ball.MouseButton1Click:Connect(function()
	frame.Visible = true
	ball.Visible = false
end)
