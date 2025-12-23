-- TRUE VISION SYSTEM (NO BLOCK FIXED)
-- LocalScript

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ENABLED = true

-- ===== UI =====
local gui = Instance.new("ScreenGui")
gui.Name = "TrueVisionUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(220,90)
main.Position = UDim2.new(0.5,-110,0.8,0)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,16)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "TRUE VISION"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local toggle = Instance.new("TextButton", main)
toggle.Size = UDim2.new(0.8,0,0,32)
toggle.Position = UDim2.new(0.1,0,0,45)
toggle.Text = "VISION : ON"
toggle.Font = Enum.Font.GothamBold
toggle.TextScaled = true
toggle.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", toggle)

toggle.MouseButton1Click:Connect(function()
	ENABLED = not ENABLED
	toggle.Text = ENABLED and "VISION : ON" or "VISION : OFF"
end)

-- ===== CORE =====
local function forceVisible(char)
	for _,v in ipairs(char:GetDescendants()) do
		-- ข้าม Root / Hitbox
		if v:IsA("BasePart") then
			if v.Name ~= "HumanoidRootPart" then
				-- ไม่แตะ Transparency จริง
				v.LocalTransparencyModifier = 0
			end

		elseif v:IsA("Decal") then
			v.LocalTransparencyModifier = 0

		elseif v:IsA("ParticleEmitter")
			or v:IsA("Trail")
			or v:IsA("Beam") then
			v.Enabled = true
		end
	end
end

-- ===== LOOP =====
RunService.RenderStepped:Connect(function()
	if not ENABLED then return end

	for _,plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character then
			forceVisible(plr.Character)
		end
	end
end)
