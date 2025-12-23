local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- ===== GUI =====
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "TimeStopUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(260,200)
frame.Position = UDim2.new(0.5,-130,0.8,-100)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.Text = "⏱ หยุดเวลาอัตโนมัติ"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local timeLabel = Instance.new("TextLabel", frame)
timeLabel.Position = UDim2.new(0,0,0,45)
timeLabel.Size = UDim2.new(1,0,0,30)
timeLabel.Text = "เวลาเป้าหมาย: 3.0 วิ"
timeLabel.TextColor3 = Color3.new(1,1,1)
timeLabel.BackgroundTransparency = 1
timeLabel.Font = Enum.Font.Gotham
timeLabel.TextScaled = true

local function makeBtn(text,y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0.8,0,0,32)
	b.Position = UDim2.new(0.1,0,0,y)
	b.Text = text
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b)
	return b
end

local startBtn = makeBtn("▶ เริ่มจับเวลา",80)
local stopBtn  = makeBtn("⏹ หยุดเวลา",120)
local plusBtn  = makeBtn("➕ เพิ่มเวลา",160)
local minusBtn = makeBtn("➖ ลดเวลา",200)

-- ===== Toggle UI Button =====
local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.fromOffset(50,50)
toggle.Position = UDim2.new(1,-60,0,20)
toggle.Text = "⏱"
toggle.TextScaled = true
toggle.BackgroundColor3 = Color3.fromRGB(30,30,30)
toggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", toggle)

-- ===== LOGIC =====
local TARGET_TIME = 3.0
local running = false
local startTime = 0

local function updateLabel()
	timeLabel.Text = "เวลาเป้าหมาย: "..string.format("%.1f",TARGET_TIME).." วิ"
end

startBtn.MouseButton1Click:Connect(function()
	running = true
	startTime = tick()
end)

stopBtn.MouseButton1Click:Connect(function()
	running = false
end)

plusBtn.MouseButton1Click:Connect(function()
	TARGET_TIME += 0.5
	updateLabel()
end)

minusBtn.MouseButton1Click:Connect(function()
	TARGET_TIME = math.max(0.5, TARGET_TIME - 0.5)
	updateLabel()
end)

toggle.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

RunService.RenderStepped:Connect(function()
	if running and tick() - startTime >= TARGET_TIME then
		running = false
		game:GetService("RunService"):Set3dRenderingEnabled(false)
		task.wait(0.1)
		game:GetService("RunService"):Set3dRenderingEnabled(true)
	end
end)

updateLabel()
