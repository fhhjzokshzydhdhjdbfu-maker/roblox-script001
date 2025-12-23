-- WALK THROUGH WALLS (DEV / MAP TEST)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ===== UI =====
local gui = Instance.new("ScreenGui")
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromOffset(160,40)
btn.Position = UDim2.new(1,-180,0,30)
btn.Text = "NOCLIP : OFF"
btn.TextScaled = true
btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.GothamBold
Instance.new("UICorner", btn)

-- ===== LOGIC =====
local NOCLIP = false

local function setCollision(char, state)
	for _,v in ipairs(char:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = state
		end
	end
end

btn.MouseButton1Click:Connect(function()
	NOCLIP = not NOCLIP
	btn.Text = NOCLIP and "NOCLIP : ON" or "NOCLIP : OFF"
end)

-- ทำทุกเฟรม กันเกมเปิดกลับ
RunService.Stepped:Connect(function()
	if NOCLIP and LocalPlayer.Character then
		setCollision(LocalPlayer.Character, false)
	end
end)

-- เกิดใหม่
LocalPlayer.CharacterAdded:Connect(function(char)
	task.wait(0.2)
	if NOCLIP then
		setCollision(char, false)
	end
end)
