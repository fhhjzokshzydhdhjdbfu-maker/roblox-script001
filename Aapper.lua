-- SPEED CONTROL SYSTEM
-- LocalScript (StarterPlayer > StarterPlayerScripts)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local speed = 16 -- ความเร็วปกติ Roblox
local enabled = false

local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(260,150)
frame.Position = UDim2.new(0.5,-130,0.75,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "SPEED CONTROL"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0.8,0,0,30)
toggle.Position = UDim2.new(0.1,0,0,45)
toggle.Text = "ปิดความเร็ว"
toggle.TextScaled = true
toggle.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", toggle)

local plus = Instance.new("TextButton", frame)
plus.Size = UDim2.new(0.35,0,0,30)
plus.Position = UDim2.new(0.1,0,0,85)
plus.Text = "+ เร็ว"
plus.TextScaled = true
plus.BackgroundColor3 = Color3.fromRGB(60,60,60)
plus.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", plus)

local minus = Instance.new("TextButton", frame)
minus.Size = UDim2.new(0.35,0,0,30)
minus.Position = UDim2.new(0.55,0,0,85)
minus.Text = "- ช้า"
minus.TextScaled = true
minus.BackgroundColor3 = Color3.fromRGB(60,60,60)
minus.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", minus)

local function applySpeed()
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("Humanoid") then
		char.Humanoid.WalkSpeed = enabled and speed or 16
	end
end

toggle.MouseButton1Click:Connect(function()
	enabled = not enabled
	toggle.Text = enabled and "เปิดความเร็ว" or "ปิดความเร็ว"
	applySpeed()
end)

plus.MouseButton1Click:Connect(function()
	speed = math.clamp(speed + 4, 16, 200)
	applySpeed()
end)

minus.MouseButton1Click:Connect(function()
	speed = math.clamp(speed - 4, 16, 200)
	applySpeed()
end)

LocalPlayer.CharacterAdded:Connect(function()
	task.wait(0.2)
	applySpeed()
end)
