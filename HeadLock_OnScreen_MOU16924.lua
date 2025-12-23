-- HEAD LOCK ON SCREEN
-- สร้างโดย MOU16924

-- ===== SERVICES =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ===== STATE =====
local LOCK_ENABLED = false
local UI_OPEN = true
local TARGET = nil

-- ===== UI =====
local gui = Instance.new("ScreenGui")
gui.Name = "HeadLockUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(260,120)
frame.Position = UDim2.new(0.5,-130,0.7,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "HEAD LOCK"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- Credit
local credit = Instance.new("TextLabel", frame)
credit.Size = UDim2.new(1,0,0,18)
credit.Position = UDim2.new(0,0,0,32)
credit.BackgroundTransparency = 1
credit.Text = "สร้างโดย MOU16924"
credit.TextColor3 = Color3.fromRGB(180,180,180)
credit.Font = Enum.Font.Gotham
credit.TextScaled = true

-- Toggle Lock
local toggleLock = Instance.new("TextButton", frame)
toggleLock.Size = UDim2.new(0.9,0,0,32)
toggleLock.Position = UDim2.new(0.05,0,0,55)
toggleLock.Text = "LOCK : OFF"
toggleLock.BackgroundColor3 = Color3.fromRGB(120,40,40)
toggleLock.TextColor3 = Color3.new(1,1,1)
toggleLock.Font = Enum.Font.GothamBold
toggleLock.TextScaled = true
Instance.new("UICorner", toggleLock)

-- Toggle UI
local toggleUI = Instance.new("TextButton", frame)
toggleUI.Size = UDim2.fromOffset(40,40)
toggleUI.Position = UDim2.new(1,-45,0,-45)
toggleUI.Text = "●"
toggleUI.TextScaled = true
toggleUI.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggleUI.TextColor3 = Color3.new(1,1,1)
toggleUI.Visible = false
Instance.new("UICorner", toggleUI).CornerRadius = UDim.new(1,0)

-- ===== UI LOGIC =====
toggleLock.MouseButton1Click:Connect(function()
	LOCK_ENABLED = not LOCK_ENABLED
	toggleLock.Text = LOCK_ENABLED and "LOCK : ON" or "LOCK : OFF"
	toggleLock.BackgroundColor3 = LOCK_ENABLED
		and Color3.fromRGB(40,120,40)
		or Color3.fromRGB(120,40,40)
end)

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		UI_OPEN = false
		frame.Visible = false
		toggleUI.Visible = true
	end
end)

toggleUI.MouseButton1Click:Connect(function()
	UI_OPEN = true
	frame.Visible = true
	toggleUI.Visible = false
end)

-- ===== TARGET FIND =====
local function getOnScreenTarget()
	local closest
	local shortest = math.huge
	local screenCenter = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

	for _,plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
			local head = plr.Character.Head
			local pos, visible = Camera:WorldToViewportPoint(head.Position)
			if visible then
				local dist = (Vector2.new(pos.X,pos.Y) - screenCenter).Magnitude
				if dist < shortest then
					shortest = dist
					closest = head
				end
			end
		end
	end
	return closest
end

-- ===== LOCK LOOP =====
RunService.RenderStepped:Connect(function()
	if not LOCK_ENABLED then return end

	local head = getOnScreenTarget()
	if head then
		Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
	end
end)
