-- HEAD LOCK : FARTHEST ON SCREEN
-- สร้างโดย MOU16924

-- ===== SERVICES =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ===== STATE =====
local LOCK_ENABLED = false
local UI_OPEN = true

-- ===== UI =====
local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
gui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(260,140)
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

-- Lock Toggle
local lockBtn = Instance.new("TextButton", frame)
lockBtn.Size = UDim2.new(0.9,0,0,32)
lockBtn.Position = UDim2.new(0.05,0,0,58)
lockBtn.Text = "LOCK : OFF"
lockBtn.BackgroundColor3 = Color3.fromRGB(120,40,40)
lockBtn.TextColor3 = Color3.new(1,1,1)
lockBtn.Font = Enum.Font.GothamBold
lockBtn.TextScaled = true
Instance.new("UICorner", lockBtn)

-- UI Toggle
local uiBtn = Instance.new("TextButton", frame)
uiBtn.Size = UDim2.new(0.9,0,0,28)
uiBtn.Position = UDim2.new(0.05,0,0,100)
uiBtn.Text = "ปิด UI"
uiBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
uiBtn.TextColor3 = Color3.new(1,1,1)
uiBtn.Font = Enum.Font.Gotham
uiBtn.TextScaled = true
Instance.new("UICorner", uiBtn)

-- Ball Button
local ball = Instance.new("TextButton", gui)
ball.Size = UDim2.fromOffset(44,44)
ball.Position = UDim2.new(0.5,-22,0.85,0)
ball.Text = "●"
ball.TextScaled = true
ball.BackgroundColor3 = Color3.fromRGB(30,30,30)
ball.TextColor3 = Color3.new(1,1,1)
ball.Visible = false
Instance.new("UICorner", ball).CornerRadius = UDim.new(1,0)

-- ===== UI LOGIC =====
lockBtn.MouseButton1Click:Connect(function()
	LOCK_ENABLED = not LOCK_ENABLED
	lockBtn.Text = LOCK_ENABLED and "LOCK : ON" or "LOCK : OFF"
	lockBtn.BackgroundColor3 = LOCK_ENABLED
		and Color3.fromRGB(40,120,40)
		or Color3.fromRGB(120,40,40)
end)

uiBtn.MouseButton1Click:Connect(function()
	UI_OPEN = false
	frame.Visible = false
	ball.Visible = true
end)

ball.MouseButton1Click:Connect(function()
	UI_OPEN = true
	frame.Visible = true
	ball.Visible = false
end)

-- ===== TARGET FIND (VISIBLE + FARTHEST) =====
local function getFarthestVisibleHead()
	local camPos = Camera.CFrame.Position
	local farthestHead = nil
	local farthestDist = 0

	for _,plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
			local head = plr.Character.Head
			local screenPos, visible = Camera:WorldToViewportPoint(head.Position)

			-- ต้องเห็นจริง + อยู่หน้ากล้อง
			if visible and screenPos.Z > 0 then
				-- Raycast เช็คไม่ทะลุกำแพง
				local rayParams = RaycastParams.new()
				rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
				rayParams.FilterType = Enum.RaycastFilterType.Blacklist

				local ray = workspace:Raycast(camPos, head.Position - camPos, rayParams)
				if ray and ray.Instance:IsDescendantOf(plr.Character) then
					local dist = (camPos - head.Position).Magnitude
					if dist > farthestDist then
						farthestDist = dist
						farthestHead = head
					end
				end
			end
		end
	end

	return farthestHead
end

-- ===== LOCK LOOP =====
RunService.RenderStepped:Connect(function()
	if not LOCK_ENABLED then return end

	local head = getFarthestVisibleHead()
	if head then
		Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
	end
end)
