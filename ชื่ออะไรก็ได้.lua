-- คัดลอกสคริปต์ด้านล่างนี้ --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- สร้าง UI แบบเรียบง่าย
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "StudyUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 100)
MainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Far Lock System (Study)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 40)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.45, 0)
ToggleBtn.Text = "OFF"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- ตัวแปรสถานะ
local _G_Enabled = false

-- ฟังก์ชันหาผู้เล่นที่อยู่ "ไกลที่สุด"
local function getFarthestPlayer()
	local farthestTarget = nil
	local maxDistance = 0
	
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
			local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
			if dist > maxDistance then
				maxDistance = dist
				farthestTarget = player
			end
		end
	end
	return farthestTarget
end

-- ระบบล็อคกล้อง
RunService.RenderStepped:Connect(function()
	if _G_Enabled then
		local target = getFarthestPlayer()
		if target and target.Character and target.Character:FindFirstChild("Head") then
			-- หมุนกล้องไปยังหัวเป้าหมาย
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
		end
	end
end)

-- เปิด-ปิดการทำงาน
ToggleBtn.MouseButton1Click:Connect(function()
	_G_Enabled = not _G_Enabled
	if _G_Enabled then
		ToggleBtn.Text = "ON"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
	else
		ToggleBtn.Text = "OFF"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	end
end)
