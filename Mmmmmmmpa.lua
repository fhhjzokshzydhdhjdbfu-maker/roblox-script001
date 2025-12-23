-- Mmmmmmpa.lua
-- Poison Cup Detector (CLIENT ONLY)
-- รันแล้วทำงานทันที

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- เก็บสถานะแก้วเดิม
local cupCache = {}

-- เช็คว่าเป็นแก้วหรือไม่ (กันมั่ว)
local function isCup(obj)
	if not obj:IsA("BasePart") then return false end
	local n = obj.Name:lower()
	return n:find("cup") or n:find("glass") or n:find("drink")
end

-- ทำแก้วให้เป็นสีแดง (เห็นเฉพาะเรา)
local function markPoison(cup)
	cup.Color = Color3.fromRGB(255,0,0)
	cup.LocalTransparencyModifier = 0
end

-- บันทึกค่าเดิมของแก้ว
local function cacheCup(cup)
	cupCache[cup] = {
		Color = cup.Color,
		Transparency = cup.Transparency,
		Material = cup.Material
	}
end

-- ตรวจว่าแก้วเปลี่ยนจากเดิมไหม
local function isChanged(cup)
	local old = cupCache[cup]
	if not old then return false end

	return cup.Color ~= old.Color
		or cup.Transparency ~= old.Transparency
		or cup.Material ~= old.Material
end

-- สแกนแก้วทั้งหมด
local function scan()
	for _,obj in ipairs(Workspace:GetDescendants()) do
		if isCup(obj) then
			if not cupCache[obj] then
				cacheCup(obj)
			else
				if isChanged(obj) then
					markPoison(obj)
				end
			end
		end
	end
end

-- ลูปตลอดเวลา (Real-time)
task.spawn(function()
	while true do
		scan()
		task.wait(0.2)
	end
end)

print("✅ Poison Cup Detector Loaded")
