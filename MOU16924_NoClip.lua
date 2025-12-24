-- NOCLIP WALK THROUGH WALL
-- สร้างโดย MOU16924
-- LocalScript | ใช้ได้ทุกแมพ

-- ===== SERVICES =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ===== STATE =====
local NOCLIP = false
local UI_OPEN = true

-- ===== UI =====
local gui = Instance.new("ScreenGui")
gui.Name = "NoClipUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(240,120)
frame.Position = UDim2.new(0.5,-120,0.7,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,34)
title.BackgroundTransparency = 1
title.Text = "NOCLIP"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local credit = Instance.new("TextLabel", frame)
credit.Size = UDim2.new(1,0,0,16)
credit.Position = UDim2.new(0,0,0,32)
credit.BackgroundTransparency = 1
credit.Text = "สร้างโดย MOU16924"
credit.TextColor3 = Color3.fromRGB(180,180,180)
credit.Font = Enum.Font.Gotham
credit.TextScaled = true

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(0.9,0,0,34)
toggleBtn.Position = UDim2.new(0.05,0,0,54)
toggleBtn.Text = "NOCLIP : OFF"
toggleBtn.BackgroundColor3 = Color3.fromRGB(120,40,40)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextScaled = true
Instance.new("UICorner", toggleBtn)

local uiBtn = Instance.new("TextButton", frame)
uiBtn.Size = UDim2.new(0.9,0,0,26)
uiBtn.Position = UDim2.new(0.05,0,0,94)
uiBtn.Text = "ปิด UI"
uiBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
uiBtn.TextColor3 = Color3.new(1,1,1)
uiBtn.Font = Enum.Font.Gotham
uiBtn.TextScaled = true
Instance.new("UICorner", uiBtn)

-- ลูกบอลมุมขวาบน
local ball = Instance.new("TextButton", gui)
ball.Size = UDim2.fromOffset(44,44)
ball.Position = UDim2.new(1,-60,0,20)
ball.Text = "●"
ball.TextScaled = true
ball.BackgroundColor3 = Color3.fromRGB(30,30,30)
ball.TextColor3 = Color3.new(1,1,1)
ball.Visible = false
Instance.new("UICorner", ball).CornerRadius = UDim.new(1,0)

-- ===== UI LOGIC =====
toggleBtn.MouseButton1Click:Connect(function()
	NOCLIP = not NOCLIP
	toggleBtn.Text = NOCLIP and "NOCLIP : ON" or "NOCLIP : OFF"
	toggleBtn.BackgroundColor3 = NOCLIP
		and Color3.fromRGB(40,120,40)
		or Color3.fromRGB(120,40,40)
end)

uiBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	ball.Visible = true
	UI_OPEN = false
end)

ball.MouseButton1Click:Connect(function()
	frame.Visible = true
	ball.Visible = false
	UI_OPEN = true
end)

-- ===== NOCLIP CORE =====
RunService.Stepped:Connect(function()
	if not NOCLIP then return end
	local char = LocalPlayer.Character
	if not char then return end

	for _,v in ipairs(char:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = false
		end
	end
end)

-- รีเซ็ตตอนปิด
RunService.Heartbeat:Connect(function()
	if NOCLIP then return end
	local char = LocalPlayer.Character
	if not char then return end

	for _,v in ipairs(char:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = true
		end
	end
end)
