-- NOCLIP WITH THAI UI (DEV USE)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ===== UI =====
local gui = Instance.new("ScreenGui")
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- UI Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(260,150)
frame.Position = UDim2.new(0.5,-130,0.25,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "โหมดเดินทะลุกำแพง"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- Close Button
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.fromOffset(30,30)
closeBtn.Position = UDim2.new(1,-35,0,5)
closeBtn.Text = "×"
closeBtn.TextScaled = true
closeBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
closeBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", closeBtn)

-- Toggle Button
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(0.85,0,0,45)
toggleBtn.Position = UDim2.new(0.075,0,0,60)
toggleBtn.Text = "ปิดโหมด (ชนกำแพง)"
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
toggleBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", toggleBtn)

-- Ball Button
local ball = Instance.new("TextButton", gui)
ball.Size = UDim2.fromOffset(45,45)
ball.Position = UDim2.new(0,15,0.5,-22)
ball.BackgroundColor3 = Color3.fromRGB(0,120,255)
ball.Text = "⚙"
ball.TextScaled = true
ball.TextColor3 = Color3.new(1,1,1)
ball.Visible = false
ball.Active = true
ball.Draggable = true
Instance.new("UICorner", ball).CornerRadius = UDim.new(1,0)

-- ===== LOGIC =====
local NOCLIP = false

local function setCollision(char, state)
	for _,v in ipairs(char:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = state
		end
	end
end

-- Toggle noclip
toggleBtn.MouseButton1Click:Connect(function()
	NOCLIP = not NOCLIP

	if LocalPlayer.Character then
		setCollision(LocalPlayer.Character, not NOCLIP)
	end

	if NOCLIP then
		toggleBtn.Text = "เปิดโหมด (ทะลุกำแพง)"
	else
		toggleBtn.Text = "ปิดโหมด (ชนกำแพง)"
	end
end)

-- Keep noclip active
RunService.Stepped:Connect(function()
	if NOCLIP and LocalPlayer.Character then
		setCollision(LocalPlayer.Character, false)
	end
end)

-- Respawn support
LocalPlayer.CharacterAdded:Connect(function(char)
	task.wait(0.2)
	if NOCLIP then
		setCollision(char, false)
	end
end)

-- UI hide / show
closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	ball.Visible = true
end)

ball.MouseButton1Click:Connect(function()
	frame.Visible = true
	ball.Visible = false
end)
