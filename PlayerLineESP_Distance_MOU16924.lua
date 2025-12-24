-- PLAYER LINE ESP + DISTANCE (STABLE)
-- สร้างโดย MOU16924

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ================= SETTINGS =================
local ESP_ON = true
local lineThickness = 2

local colors = {
	{ name="WHITE", value=Color3.new(1,1,1) },
	{ name="RED", value=Color3.fromRGB(255,0,0) },
	{ name="GREEN", value=Color3.fromRGB(0,255,0) },
	{ name="BLUE", value=Color3.fromRGB(0,170,255) },
	{ name="YELLOW", value=Color3.fromRGB(255,255,0) },
	{ name="RAINBOW", value="RAINBOW" }
}
local colorIndex = 1
local hue = 0

local lines = {}
local distanceTags = {}

-- ================= LINE FUNCTIONS =================
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
	l.Transparency = 1
	l.Thickness = lineThickness
	lines[player] = l
end

-- ================= DISTANCE TAG =================
local function removeDistance(player)
	if distanceTags[player] then
		local gui = distanceTags[player].Parent
		if gui then gui:Destroy() end
		distanceTags[player] = nil
	end
end

local function createDistance(player)
	if distanceTags[player] then return end
	if not player.Character then return end
	local head = player.Character:FindFirstChild("Head")
	if not head then return end

	local bill = Instance.new("BillboardGui")
	bill.Name = "DistanceTag"
	bill.Size = UDim2.fromOffset(120,40)
	bill.StudsOffset = Vector3.new(0,2.5,0)
	bill.AlwaysOnTop = true
	bill.Parent = head

	local text = Instance.new("TextLabel", bill)
	text.Size = UDim2.fromScale(1,1)
	text.BackgroundTransparency = 1
	text.TextColor3 = Color3.new(1,1,1)
	text.TextStrokeTransparency = 0
	text.Font = Enum.Font.GothamBold
	text.TextScaled = true
	text.Text = "0 m"

	distanceTags[player] = text
end

-- ================= PLAYER HANDLING =================
local function onCharacterAdded(player, character)
	if player == LocalPlayer then return end

	createLine(player)
	task.wait(0.5)
	createDistance(player)

	local hum = character:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.Died:Connect(function()
			removeLine(player)
			removeDistance(player)
		end)
	end
end

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

Players.PlayerAdded:Connect(function(player)
	if player ~= LocalPlayer then
		player.CharacterAdded:Connect(function(char)
			onCharacterAdded(player, char)
		end)
	end
end)

Players.PlayerRemoving:Connect(function(player)
	removeLine(player)
	removeDistance(player)
end)

-- ================= RENDER =================
RunService.RenderStepped:Connect(function()
	if colors[colorIndex].value == "RAINBOW" then
		hue = (hue + 0.01) % 1
	end

	for player, line in pairs(lines) do
		if ESP_ON
		and player.Character
		and player.Character:FindFirstChild("HumanoidRootPart")
		and LocalPlayer.Character
		and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		then
			local root = player.Character.HumanoidRootPart
			local pos, onScreen = Camera:WorldToViewportPoint(root.Position)

			if onScreen then
				line.Visible = true
				line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y - 5)
				line.To = Vector2.new(pos.X, pos.Y)
				line.Thickness = lineThickness
				line.Color =
					(colors[colorIndex].value == "RAINBOW")
					and Color3.fromHSV(hue,1,1)
					or colors[colorIndex].value
			else
				line.Visible = false
			end

			if distanceTags[player] then
				local dist = (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude
				distanceTags[player].Text = math.floor(dist) .. " m"
			end
		else
			line.Visible = false
		end
	end
end)
