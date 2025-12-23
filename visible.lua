-- SERVER: Force players always visible (no color, no effect)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local function forceVisible(character)
	for _,obj in ipairs(character:GetDescendants()) do
		if obj:IsA("BasePart") then
			obj.Transparency = 0
			obj.LocalTransparencyModifier = 0
		end
	end
end

local function onCharacterAdded(character)
	-- ทำทันทีที่เกิด
	task.wait(0.1)
	forceVisible(character)

	-- กันสคริปต์อื่นพยายามซ่อน
	RunService.Heartbeat:Connect(function()
		if character.Parent then
			forceVisible(character)
		end
	end)
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(onCharacterAdded)
end)

for _,player in ipairs(Players:GetPlayers()) do
	if player.Character then
		onCharacterAdded(player.Character)
	end
end
