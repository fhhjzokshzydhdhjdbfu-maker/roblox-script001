-- Player Visibility Script (Lua valid)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function addHighlight(character)
	if character:FindFirstChild("VisibilityHighlight") then
		return
	end

	local highlight = Instance.new("Highlight")
	highlight.Name = "VisibilityHighlight"
	highlight.Adornee = character
	highlight.FillColor = Color3.fromRGB(255,255,255)
	highlight.OutlineColor = Color3.fromRGB(255,255,255)
	highlight.FillTransparency = 0.4
	highlight.OutlineTransparency = 0
	highlight.Parent = character
end

local function setupPlayer(player)
	if player == LocalPlayer then
		return
	end

	if player.Character then
		addHighlight(player.Character)
	end

	player.CharacterAdded:Connect(function(character)
		task.wait(0.3)
		addHighlight(character)
	end)
end

for _, player in ipairs(Players:GetPlayers()) do
	setupPlayer(player)
end

Players.PlayerAdded:Connect(setupPlayer)
