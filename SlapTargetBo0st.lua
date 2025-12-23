-- ===== CLIENT (UI MINIMAL) =====
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Rep = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local remote = Rep:WaitForChild("SlapBoostRemote")

local ENABLED = false
local TARGET

-- UI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(220,120)
frame.Position = UDim2.new(0.5,-110,0.7,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

-- ปุ่ม เปิด-ปิด
local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0.9,0,0,45)
toggle.Position = UDim2.new(0.05,0,0,15)
toggle.Text = "ปิด"
toggle.BackgroundColor3 = Color3.fromRGB(150,50,50)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.GothamBold
toggle.TextScaled = true
Instance.new("UICorner", toggle)

-- เครดิต
local credit = Instance.new("TextLabel", frame)
credit.Size = UDim2.new(1,0,0,30)
credit.Position = UDim2.new(0,0,0,70)
credit.BackgroundTransparency = 1
credit.Text = "สร้างโดย MOU16924"
credit.TextColor3 = Color3.new(1,1,1)
credit.Font = Enum.Font.Gotham
credit.TextScaled = true

-- ลูกบอลเปิด UI
local ball = Instance.new("TextButton", gui)
ball.Size = UDim2.fromOffset(50,50)
ball.Position = UDim2.new(0,10,0.5,-25)
ball.Text = "ON"
ball.Visible = false
ball.BackgroundColor3 = Color3.fromRGB(200,0,0)
ball.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", ball).CornerRadius = UDim.new(1,0)

toggle.MouseButton1Click:Connect(function()
	ENABLED = not ENABLED
	toggle.Text = ENABLED and "เปิด" or "ปิด"
	toggle.BackgroundColor3 = ENABLED and Color3.fromRGB(50,200,50) or Color3.fromRGB(150,50,50)
end)

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		frame.Visible = false
		ball.Visible = true
	end
end)

ball.MouseButton1Click:Connect(function()
	frame.Visible = true
	ball.Visible = false
end)

-- เลือกเป้าหมาย
mouse.Button1Down:Connect(function()
	if not ENABLED then return end
	if mouse.Target and mouse.Target.Parent then
		local char = mouse.Target.Parent
		local hum = char:FindFirstChild("Humanoid")
		if hum and char ~= player.Character then
			if TARGET then
				for _,p in pairs(TARGET:GetChildren()) do
					if p:IsA("BasePart") then p.Color = Color3.new(1,1,1) end
				end
			end
			TARGET = char
			for _,p in pairs(char:GetChildren()) do
				if p:IsA("BasePart") then p.Color = Color3.fromRGB(255,0,0) end
			end
		end
	end
end)

-- ตบ
UIS.InputBegan:Connect(function(input,gp)
	if gp then return end
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		if ENABLED and TARGET then
			remote:FireServer(TARGET)
		end
	end
end)
