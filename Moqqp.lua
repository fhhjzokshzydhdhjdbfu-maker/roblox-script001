-- PLAYER LINE ESP (STABLE / RESPAWN SAFE)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ===== SETTINGS =====
local ESP_ON = true
local lineThickness = 2

local colors = {
	Color3.new(1,1,1), -- ขาว
	Color3.fromRGB(255,0,0),
	Color3.fromRGB(0,255,0),
	Color3.fromRGB(0,170,255),
	Color3.fromRGB(255,255,0),
	"RAINBOW"
}
local colorIndex = 1
local hue = 0

-- ===== STORAGE =====
local lines = {}

-- ===== LINE FUNCTIONS =====
local function removeLine(player)
	if lines[player] then
		lines[player]:Remove()
		lines[player] = nil
	end
end

local function createLine(player)
	if lines[player] then return end
	local l = Drawing.new("Line")
	l.Visible = false
	l.Thickness = lineThickness
	l.Transparency = 1
	lines[player] = l
end

-- ===== PLAYER HANDLING =====
local function onCharacterAdded(player, character)
	if player == LocalPlayer then return end -- ❗ไม่แตะเจ้าของสคริปต์

	createLine(player)

	local hum = character:WaitForChild("Humanoid",5)
	if hum then
		hum.Died:Connect(function()
			removeLine(player)
		end)
	end
end

-- ผู้เล่นที่มีอยู่แล้ว
for _,p in ipairs(Players:GetPlayers()) do
	if p ~= LocalPlayer then
		if p.Character then
			onCharacterAdded(p, p.Character)
		end
		p.CharacterAdded:Connect(function(char)
			onCharacterAdded(p, char)
		end)
	end
end

-- ผู้เล่นเข้าใหม่
Players.PlayerAdded:Connect(function(player)
	if player == LocalPlayer then return end
	player.CharacterAdded:Connect(function(char)
		onCharacterAdded(player, char)
	end)
end)

-- ผู้เล่นออก
Players.PlayerRemoving:Connect(function(player)
	removeLine(player)
end)

-- ===== RENDER LOOP =====
RunService.RenderStepped:Connect(function()
	if colors[colorIndex] == "RAINBOW" then
		hue = (hue + 0.01) % 1
	end

	for player, line in pairs(lines) do
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
				line.Thickness = lineThickness
				line.Color = (colors[colorIndex]=="RAINBOW")
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
