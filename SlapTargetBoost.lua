-- TARGET SLAP BOOST SCRIPT (LOCAL)
-- ใช้กับเกมแนว Slap / Hand
-- สร้างโดย MOU16924

-- ===== SERVICES =====
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ===== STATE =====
local SCRIPT_ENABLED = false
local UI_OPEN = true
local TARGET_PLAYER = nil
local TARGET_COLOR = Color3.fromRGB(255,0,0)

-- ===== UI =====
local gui = Instance.new("ScreenGui")
gui.Name = "SlapTargetBoostUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(280,160)
frame.Position = UDim2.new(0.5,-140,0.75,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,38)
title.BackgroundTransparency = 1
title.Text = "SLAP TARGET BOOST"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local sub = Instance.new("TextLabel", frame)
sub.Size = UDim2.new(1,0,0,20)
sub.Position = UDim2.new(0,0,0,36)
sub.BackgroundTransparency = 1
sub.Text = "สร้างโดย MOU16924"
sub.TextColor3 = Color3.fromRGB(200,200,200)
sub.Font = Enum.Font.Gotham
sub.TextScaled = true

local toggleScript = Instance.new("TextButton", frame)
toggleScript.Size = UDim2.new(0.9,0,0,36)
toggleScript.Position = UDim2.new(0.05,0,0,64)
toggleScript.Text = "SCRIPT : OFF"
toggleScript.BackgroundColor3 = Color3.fromRGB(120,40,40)
toggleScript.TextColor3 = Color3.new(1,1,1)
toggleScript.Font = Enum.Font.GothamBold
toggleScript.TextScaled = true
Instance.new("UICorner", toggleScript)

local toggleUI = Instance.new("TextButton", frame)
toggleUI.Size = UDim2.new(0.9,0,0,30)
toggleUI.Position = UDim2.new(0.05,0,0,108)
toggleUI.Text = "HIDE UI"
toggleUI.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggleUI.TextColor3 = Color3.new(1,1,1)
toggleUI.Font = Enum.Font.Gotham
toggleUI.TextScaled = true
Instance.new("UICorner", toggleUI)

-- ===== UI ACTIONS =====
toggleScript.MouseButton1Click:Connect(function()
	SCRIPT_ENABLED = not SCRIPT_ENABLED
	toggleScript.Text = SCRIPT_ENABLED and "SCRIPT : ON" or "SCRIPT : OFF"
	toggleScript.BackgroundColor3 = SCRIPT_ENABLED
		and Color3.fromRGB(40,120,40)
		or Color3.fromRGB(120,40,40)

	if not SCRIPT_ENABLED then
		-- ปิดสคริปต์ = ล้างเป้า
		if TARGET_PLAYER and TARGET_PLAYER.Character then
			local h = TARGET_PLAYER.Character:FindFirstChild("Highlight")
			if h then h:Destroy() end
		end
		TARGET_PLAYER = nil
	end
end)

toggleUI.MouseButton1Click:Connect(function()
	UI_OPEN = not UI_OPEN
	frame.Visible = UI_OPEN
	toggleUI.Text = UI_OPEN and "HIDE UI" or "SHOW UI"
end)

-- ===== TARGET VISUAL =====
local function clearTarget()
	if TARGET_PLAYER and TARGET_PLAYER.Character then
		local h = TARGET_PLAYER.Character:FindFirstChild("Highlight")
		if h then h:Destroy() end
	end
	TARGET_PLAYER = nil
end

local function markTarget(player)
	clearTarget()
	TARGET_PLAYER = player

	if player.Character then
		local highlight = Instance.new("Highlight")
		highlight.FillColor = TARGET_COLOR
		highlight.OutlineColor = Color3.new(1,1,1)
		highlight.FillTransparency = 0.25
		highlight.Parent = player.Character
	end
end

-- ===== CLICK TO SELECT PLAYER =====
Mouse.Button1Down:Connect(function()
	if not SCRIPT_ENABLED then return end
	if not Mouse.Target then return end

	local model = Mouse.Target:FindFirstAncestorOfClass("Model")
	if not model then return end

	local hum = model:FindFirstChildOfClass("Humanoid")
	local plr = Players:GetPlayerFromCharacter(model)

	if hum and plr and plr ~= LocalPlayer then
		markTarget(plr)
	end
end)

-- ===== KEEP TARGET AFTER RESPAWN =====
RunService.Heartbeat:Connect(function()
	if TARGET_PLAYER and TARGET_PLAYER.Character then
		if not TARGET_PLAYER.Character:FindFirstChild("Highlight") then
			markTarget(TARGET_PLAYER)
		end
	end
end)

-- ===== SLAP BOOST CORE =====
local function getSlapTool()
	local char = LocalPlayer.Character
	if not char then return nil end
	for _,v in ipairs(char:GetChildren()) do
		if v:IsA("Tool") then
			return v
		end
	end
	return nil
end

RunService.RenderStepped:Connect(function()
	if not SCRIPT_ENABLED then return end
	if not TARGET_PLAYER or not TARGET_PLAYER.Character then return end

	local tool = getSlapTool()
	if not tool then return end

	local handle = tool:FindFirstChild("Handle")
	if not handle then return end

	local targetHRP = TARGET_PLAYER.Character:FindFirstChild("HumanoidRootPart")
	if not targetHRP then return end

	-- ระยะโดนมือตบ (local)
	if (handle.Position - targetHRP.Position).Magnitude <= 6 then
		local bv = Instance.new("BodyVelocity")
		bv.MaxForce = Vector3.new(1e6,1e6,1e6)
		bv.Velocity = (targetHRP.Position - handle.Position).Unit * 320
		bv.Parent = targetHRP
		Debris:AddItem(bv, 0.15)
	end
end)
