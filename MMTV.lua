-- PLAYER LINE ESP (STABLE + UI)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ===== STATE =====
local ESP_ON = false
local UI_ON = true
local lineThickness = 2

-- สี 6 สี (สีที่ 6 = สายรุ้ง)
local colors = {
	Color3.new(1,1,1), -- ขาว
	Color3.fromRGB(255,0,0), -- แดง
	Color3.fromRGB(0,255,0), -- เขียว
	Color3.fromRGB(0,170,255), -- ฟ้า
	Color3.fromRGB(255,255,0), -- เหลือง
	"RAINBOW"
}
local colorIndex = 1
local hue = 0

-- เก็บเส้น
local lines = {}

-- ===== UI =====
local gui = Instance.new("ScreenGui")
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(260,180)
frame.Position = UDim2.new(0.5,-130,0.25,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,18)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "LINE ESP UI"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local espBtn = Instance.new("TextButton", frame)
espBtn.Size = UDim2.new(0.85,0,0,32)
espBtn.Position = UDim2.new(0.075,0,0,45)
espBtn.Text = "เส้น : ปิด"
espBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
espBtn.TextColor3 = Color3.new(1,1,1)
espBtn.TextScaled = true
Instance.new("UICorner", espBtn)

local colorBtn = Instance.new("TextButton", frame)
colorBtn.Size = UDim2.new(0.85,0,0,32)
colorBtn.Position = UDim2.new(0.075,0,0,85)
colorBtn.Text = "สี : ขาว"
colorBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
colorBtn.TextColor3 = Color3.new(1,1,1)
colorBtn.TextScaled = true
Instance.new("UICorner", colorBtn)

local hideBtn = Instance.new("TextButton", frame)
hideBtn.Size = UDim2.fromOffset(28,28)
hideBtn.Position = UDim2.new(1,-32,0,4)
hideBtn.Text = "×"
hideBtn.TextScaled = true
hideBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
hideBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", hideBtn)

-- ปุ่มลูกบอล
local ball = Instance.new("TextButton", gui)
ball.Size = UDim2.fromOffset(44,44)
ball.Position = UDim2.new(1,-60,0,120)
ball.Text = "👁"
ball.TextScaled = true
ball.BackgroundColor3 = Color3.fromRGB(0,120,255)
ball.TextColor3 = Color3.new(1,1,1)
ball.Visible = false
ball.Active = true
ball.Draggable = true
Instance.new("UICorner", ball).CornerRadius = UDim.new(1,0)

-- ===== LINE FUNCTIONS =====
local function removeLine(player)
	if lines[player] then
		lines[player]:Remove()
		lines[player] = nil
	end
end

local function getLine(player)
	if not lines[player] then
		local l = Drawing.new("Line")
		l.Visible = false
		l.Thickness = lineThickness
		l.Transparency = 1
		lines[player] = l
	end
	return lines[player]
end

-- ===== PLAYER EVENTS =====
Players.PlayerRemoving:Connect(removeLine)

local function hookCharacter(player, char)
	local hum = char:WaitForChild("Humanoid",5)
	if hum then
		hum.Died:Connect(function()
			removeLine(player)
		end)
	end
end

for _,p in ipairs(Players:GetPlayers()) do
	if p ~= LocalPlayer then
		if p.Character then hookCharacter(p,p.Character) end
		p.CharacterAdded:Connect(function(c)
			hookCharacter(p,c)
		end)
	end
end

Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function(c)
		hookCharacter(p,c)
	end)
end)

-- ===== RENDER =====
RunService.RenderStepped:Connect(function()
	if colors[colorIndex] == "RAINBOW" then
		hue = (hue + 0.01) % 1
	end

	for player,line in pairs(lines) do
		if ESP_ON
		and player.Character
		and player.Character:FindFirstChild("HumanoidRootPart")
		then
			local root = player.Character.HumanoidRootPart
			local pos, onScreen = Camera:WorldToViewportPoint(root.Position)

			if onScreen then
				line.Visible = true
				line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
				line.To = Vector2.new(pos.X, pos.Y)
				line.Color = colors[colorIndex]=="RAINBOW"
					and Color3.fromHSV(hue,1,1)
					or colors[colorIndex]
			else
				line.Visible = false
			end
		else
			line.Visible = false
		end
	end
end)

-- ===== BUTTONS =====
espBtn.MouseButton1Click:Connect(function()
	ESP_ON = not ESP_ON
	espBtn.Text = ESP_ON and "เส้น : เปิด" or "เส้น : ปิด"
end)

colorBtn.MouseButton1Click:Connect(function()
	colorIndex = colorIndex % #colors + 1
	local names = {"ขาว","แดง","เขียว","ฟ้า","เหลือง","สายรุ้ง"}
	colorBtn.Text = "สี : "..names[colorIndex]
end)

hideBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	ball.Visible = true
end)

ball.MouseButton1Click:Connect(function()
	frame.Visible = true
	ball.Visible = false
end)
