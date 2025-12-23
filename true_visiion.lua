-- TRUE VISION VIEWPORT (NO BLOCK / REAL CHARACTER)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ENABLED = true
local clones = {}

-- ===== UI =====
local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(200,80)
main.Position = UDim2.new(0.5,-100,0.82,0)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

local btn = Instance.new("TextButton", main)
btn.Size = UDim2.new(0.8,0,0.6,0)
btn.Position = UDim2.new(0.1,0,0.2,0)
btn.Text = "TRUE VISION : ON"
btn.TextScaled = true
btn.Font = Enum.Font.GothamBold
btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
btn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btn)

btn.MouseButton1Click:Connect(function()
	ENABLED = not ENABLED
	btn.Text = ENABLED and "TRUE VISION : ON" or "TRUE VISION : OFF"

	for _,v in pairs(clones) do
		v.gui.Enabled = ENABLED
	end
end)

-- ===== CREATE VIEWPORT =====
local function createClone(player)
	if clones[player] then return end
	if not player.Character then return end

	local char = player.Character
	local clone = char:Clone()

	for _,v in ipairs(clone:GetDescendants()) do
		if v:IsA("Script") or v:IsA("LocalScript") then
			v:Destroy()
		elseif v:IsA("BasePart") then
			v.Anchored = true
			v.CanCollide = false
		end
	end

	local billboard = Instance.new("BillboardGui")
	billboard.Size = UDim2.fromScale(4,6)
	billboard.AlwaysOnTop = true
	billboard.Adornee = char:WaitForChild("HumanoidRootPart")
	billboard.Parent = gui

	local viewport = Instance.new("ViewportFrame", billboard)
	viewport.Size = UDim2.fromScale(1,1)
	viewport.BackgroundTransparency = 1

	local cam = Instance.new("Camera", viewport)
	viewport.CurrentCamera = cam

	clone.Parent = viewport
	cam.CFrame = Camera.CFrame

	clones[player] = {
		gui = billboard,
		model = clone,
		camera = cam
	}
end

local function removeClone(player)
	if clones[player] then
		clones[player].gui:Destroy()
		clones[player] = nil
	end
end

-- ===== PLAYER HANDLING =====
for _,p in ipairs(Players:GetPlayers()) do
	if p ~= LocalPlayer then
		p.CharacterAdded:Connect(function()
			task.wait(0.5)
			createClone(p)
		end)
		if p.Character then
			createClone(p)
		end
	end
end

Players.PlayerAdded:Connect(function(p)
	if p ~= LocalPlayer then
		p.CharacterAdded:Connect(function()
			task.wait(0.5)
			createClone(p)
		end)
	end
end)

Players.PlayerRemoving:Connect(removeClone)

-- ===== UPDATE CAMERA =====
RunService.RenderStepped:Connect(function()
	if not ENABLED then return end

	for _,data in pairs(clones) do
		data.camera.CFrame = Camera.CFrame
	end
end)
