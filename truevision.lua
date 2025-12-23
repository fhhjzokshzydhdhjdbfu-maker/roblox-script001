-- UNIVERSAL PLAYER VISION (SAFE & WORKING)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ===== UI =====
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(220,120)
frame.Position = UDim2.new(0.5,-110,0.75,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "PLAYER VISION"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0.8,0,0,32)
toggle.Position = UDim2.new(0.1,0,0,50)
toggle.Text = "VISION : ON"
toggle.TextScaled = true
toggle.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", toggle)

local hide = Instance.new("TextButton", frame)
hide.Size = UDim2.fromOffset(30,30)
hide.Position = UDim2.new(1,-35,0,5)
hide.Text = "×"
hide.TextScaled = true
hide.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", hide)

local ball = Instance.new("TextButton", gui)
ball.Size = UDim2.fromOffset(45,45)
ball.Position = UDim2.new(0,15,0.5,-22)
ball.Text = "👁"
ball.TextScaled = true
ball.BackgroundColor3 = Color3.fromRGB(0,120,255)
ball.Visible = false
ball.Active = true
ball.Draggable = true
Instance.new("UICorner", ball).CornerRadius = UDim.new(1,0)

-- ===== LOGIC =====
local ENABLED = true
local highlights = {}

local function apply(char)
	if highlights[char] then return end
	local h = Instance.new("Highlight")
	h.FillTransparency = 1
	h.OutlineTransparency = 0
	h.OutlineColor = Color3.new(1,1,1)
	h.Parent = char
	highlights[char] = h
end

local function remove(char)
	if highlights[char] then
		highlights[char]:Destroy()
		highlights[char] = nil
	end
end

RunService.RenderStepped:Connect(function()
	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character then
			apply(p.Character)
			highlights[p.Character].Enabled = ENABLED
		end
	end
end)

Players.PlayerRemoving:Connect(function(p)
	if p.Character then remove(p.Character) end
end)

toggle.MouseButton1Click:Connect(function()
	ENABLED = not ENABLED
	toggle.Text = ENABLED and "VISION : ON" or "VISION : OFF"
end)

hide.MouseButton1Click:Connect(function()
	frame.Visible = false
	ball.Visible = true
end)

ball.MouseButton1Click:Connect(function()
	frame.Visible = true
	ball.Visible = false
end)
