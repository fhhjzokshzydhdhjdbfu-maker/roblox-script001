-- UI LOADER
-- สร้างโดย MOU16924

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ===== UI =====
local gui = Instance.new("ScreenGui")
gui.Name = "MOU16924_UI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(260,160)
main.Position = UDim2.new(0.5,-130,0.25,0)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,16)

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "BLIND SHOT SYSTEM"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)

-- CREDIT
local credit = Instance.new("TextLabel", main)
credit.Size = UDim2.new(1,0,0,18)
credit.Position = UDim2.new(0,0,0,36)
credit.BackgroundTransparency = 1
credit.Text = "สร้างโดย MOU16924"
credit.Font = Enum.Font.Gotham
credit.TextScaled = true
credit.TextColor3 = Color3.fromRGB(170,170,170)

-- LOAD BUTTON
local loadBtn = Instance.new("TextButton", main)
loadBtn.Size = UDim2.new(0.85,0,0,36)
loadBtn.Position = UDim2.new(0.075,0,0,70)
loadBtn.Text = "เปิดใช้งานระบบ"
loadBtn.Font = Enum.Font.GothamBold
loadBtn.TextScaled = true
loadBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
loadBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", loadBtn)

-- HIDE BUTTON
local hideBtn = Instance.new("TextButton", main)
hideBtn.Size = UDim2.fromOffset(30,30)
hideBtn.Position = UDim2.new(1,-35,0,5)
hideBtn.Text = "×"
hideBtn.TextScaled = true
hideBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
hideBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", hideBtn)

-- FLOAT BUTTON
local ball = Instance.new("TextButton", gui)
ball.Size = UDim2.fromOffset(45,45)
ball.Position = UDim2.new(0,15,0.5,-22)
ball.Text = "👁"
ball.TextScaled = true
ball.Visible = false
ball.BackgroundColor3 = Color3.fromRGB(0,120,255)
ball.TextColor3 = Color3.new(1,1,1)
ball.Active = true
ball.Draggable = true
Instance.new("UICorner", ball).CornerRadius = UDim.new(1,0)

-- ===== LOGIC =====
local loaded = false

loadBtn.MouseButton1Click:Connect(function()
	if loaded then return end
	loaded = true
	loadBtn.Text = "กำลังโหลด..."

	-- โหลดสคริปต์ต้นฉบับ (ไม่แก้ไข)
	loadstring(game:HttpGet(
		"https://rawscripts.net/raw/Blind-Shot-Trophy-73259"
	))()

	loadBtn.Text = "เปิดใช้งานแล้ว"
end)

hideBtn.MouseButton1Click:Connect(function()
	main.Visible = false
	ball.Visible = true
end)

ball.MouseButton1Click:Connect(function()
	main.Visible = true
	ball.Visible = false
end)
