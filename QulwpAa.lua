-- TARGET SLAP BOOST (WORKING LOCAL)
-- ใช้กับเกมแนว Slap / Hand
-- สร้างโดย MOU16924

-- ===== SERVICES =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ===== STATE =====
local ENABLED = false
local TARGET = nil
local UI_OPEN = true

-- ===== UI =====
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(240,110)
frame.Position = UDim2.new(0.5,-120,0.75,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(1,-20,0,40)
toggle.Position = UDim2.new(0,10,0,10)
toggle.Text = "OFF"
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.GothamBold
toggle.TextScaled = true
toggle.BackgroundColor3 = Color3.fromRGB(120,40,40)
Instance.new("UICorner", toggle)

local credit = Instance.new("TextLabel", frame)
credit.Size = UDim2.new(1,0,0,20)
credit.Position = UDim2.new(0,0,0,70)
credit.BackgroundTransparency = 1
credit.Text = "สร้างโดย MOU16924"
credit.TextColor3 = Color3.fromRGB(180,180,180)
credit.Font = Enum.Font.Gotham
credit.TextScaled = true

-- ===== BALL TOGGLE =====
local ball = Instance.new("TextButton", gui)
ball.Size = UDim2.fromOffset(45,45)
ball.Position = UDim2.new(1,-60,0.5,-22)
ball.Text = ""
ball.Visible = false
ball.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", ball).CornerRadius = UDim.new(1,0)

ball.MouseButton1Click:Connect(function()
	frame.Visible = true
	ball.Visible = false
end)

toggle.MouseButton1Click:Connect(function()
	ENABLED = not ENABLED
	toggle.Text = ENABLED and "ON" or "OFF"
	toggle.BackgroundColor3 = ENABLED and Color3.fromRGB(40,120,40) or Color3.fromRGB(120,40,40)
end)

frame.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.RightControl then
		frame.Visible = false
		ball.Visible = true
	end
end)

-- ===== TARGET SELECT =====
local function markTarget(plr)
	if TARGET and TARGET.Character then
		local h = TARGET.Character:FindFirstChild("Highlight")
		if h then h:Destroy() end
	end
	TARGET = plr
	if plr.Character then
		local hl = Instance.new("Highlight")
		hl.FillColor = Color3.fromRGB(255,0,0)
		hl.FillTransparency = 0.3
		hl.Parent = plr.Character
	end
end

Mouse.Button1Down:Connect(function()
	if not ENABLED then return end
	if not Mouse.Target then return end

	local model = Mouse.Target:FindFirstAncestorOfClass("Model")
	local plr = model and Players:GetPlayerFromCharacter(model)

	if plr and plr ~= LocalPlayer then
		markTarget(plr)
	end
end)

-- ===== GET HAND TOOL =====
local function getHand()
	local char = LocalPlayer.Character
	if not char then return end
	for _,v in ipairs(char:GetChildren()) do
		if v:IsA("Tool") and v:FindFirstChild("Handle") then
			return v
		end
	end
end

-- ===== REAL SLAP BOOST =====
RunService.RenderStepped:Connect(function()
	if not ENABLED or not TARGET or not TARGET.Character then return end

	local tool = getHand()
	if not tool then return end

	local handle = tool.Handle
	local hrp = TARGET.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	-- ดึงมือไปหาเป้า (ใช้ได้จริง)
	handle.CFrame = hrp.CFrame * CFrame.new(0,0,-1)
end)
