-- GHOST MODE / NOCLIP
-- ใช้ในแมพของตัวเองเท่านั้น
-- สร้างโดย MOU16924

-- ===== SERVICES =====
local Players = game:GetService("Players")
local PhysicsService = game:GetService("PhysicsService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- ===== STATE =====
local ENABLED = false
local UI_OPEN = true
local GHOST_GROUP = "GhostPlayer"

-- ===== COLLISION SETUP =====
pcall(function()
	PhysicsService:CreateCollisionGroup(GHOST_GROUP)
end)
PhysicsService:CollisionGroupSetCollidable(GHOST_GROUP, "Default", false)
PhysicsService:CollisionGroupSetCollidable(GHOST_GROUP, GHOST_GROUP, false)

local function setCharacterCollision(character, group)
	for _,v in ipairs(character:GetDescendants()) do
		if v:IsA("BasePart") then
			PhysicsService:SetPartCollisionGroup(v, group)
		end
	end
end

-- ===== CHARACTER LOAD =====
local function onCharacter(char)
	task.wait(0.2)
	if ENABLED then
		setCharacterCollision(char, GHOST_GROUP)
	else
		setCharacterCollision(char, "Default")
	end
end

if LocalPlayer.Character then
	onCharacter(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(onCharacter)

-- ===== UI =====
local gui = Instance.new("ScreenGui")
gui.Name = "GhostUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(230,110)
frame.Position = UDim2.new(0.5,-115,0.7,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(0.9,0,0,40)
toggleBtn.Position = UDim2.new(0.05,0,0.2,0)
toggleBtn.Text = "GHOST : OFF"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextScaled = true
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.BackgroundColor3 = Color3.fromRGB(120,40,40)
Instance.new("UICorner", toggleBtn)

local credit = Instance.new("TextLabel", frame)
credit.Size = UDim2.new(1,0,0,20)
credit.Position = UDim2.new(0,0,0.65,0)
credit.BackgroundTransparency = 1
credit.Text = "สร้างโดย MOU16924"
credit.TextColor3 = Color3.fromRGB(180,180,180)
credit.Font = Enum.Font.Gotham
credit.TextScaled = true

-- ===== BALL BUTTON (ขวาบน) =====
local ball = Instance.new("TextButton", gui)
ball.Size = UDim2.fromOffset(44,44)
ball.Position = UDim2.new(1,-60,0,20) -- ขวาบน
ball.Text = "●"
ball.TextScaled = true
ball.BackgroundColor3 = Color3.fromRGB(30,30,30)
ball.TextColor3 = Color3.new(1,1,1)
ball.Visible = false
Instance.new("UICorner", ball).CornerRadius = UDim.new(1,0)

-- ===== UI LOGIC =====
toggleBtn.MouseButton1Click:Connect(function()
	ENABLED = not ENABLED
	toggleBtn.Text = ENABLED and "GHOST : ON" or "GHOST : OFF"
	toggleBtn.BackgroundColor3 = ENABLED
		and Color3.fromRGB(40,120,40)
		or Color3.fromRGB(120,40,40)

	if LocalPlayer.Character then
		setCharacterCollision(
			LocalPlayer.Character,
			ENABLED and GHOST_GROUP or "Default"
		)
	end
end)

frame.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.RightControl then
		UI_OPEN = false
		frame.Visible = false
		ball.Visible = true
	end
end)

ball.MouseButton1Click:Connect(function()
	UI_OPEN = true
	frame.Visible = true
	ball.Visible = false
end)
