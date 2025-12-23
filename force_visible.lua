-- FORCE VISIBLE REAL CHARACTERS (NO BLOCKS)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function forceVisible(character)
	for _, obj in ipairs(character:GetDescendants()) do
		if obj:IsA("BasePart") then
			-- บังคับให้ฝั่งเราเห็น
			obj.LocalTransparencyModifier = 0
		elseif obj:IsA("Decal") or obj:IsA("Texture") then
			obj.Transparency = 0
		end
	end
end

local function onCharacter(player, character)
	if player == LocalPlayer then return end

	-- ทำทันที
	forceVisible(character)

	-- เผื่อเกมไปเปลี่ยนค่าทีหลัง
	character.DescendantAdded:Connect(function(obj)
		if obj:IsA("BasePart") then
			obj.LocalTransparencyModifier = 0
		elseif obj:IsA("Decal") or obj:IsA("Texture") then
			obj.Transparency = 0
		end
	end)
end

-- ผู้เล่นที่มีอยู่แล้ว
for _, player in ipairs(Players:GetPlayers()) do
	if player ~= LocalPlayer and player.Character then
		onCharacter(player, player.Character)
	end
	player.CharacterAdded:Connect(function(char)
		onCharacter(player, char)
	end)
end

-- ผู้เล่นเข้าใหม่
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(char)
		onCharacter(player, char)
	end)
end)
