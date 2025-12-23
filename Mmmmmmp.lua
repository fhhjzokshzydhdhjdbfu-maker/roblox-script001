-- Mmmmmmpa.lua
-- เห็นแก้วที่ถูกใส่พิษเป็นสีแดง (บนเครื่องเรา)

-- ต้องใช้ผ่าน loadstring / executor ที่รองรับ Drawing
-- NOT SERVER SCRIPT — Client Only

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- กำหนดชื่อ RemoteEvent
local REMOTE_NAME = "PoisonEvent"

-- หา RemoteEvent
local poisonEvent = ReplicatedStorage:FindFirstChild(REMOTE_NAME)
if not poisonEvent then
    poisonEvent = Instance.new("RemoteEvent")
    poisonEvent.Name = REMOTE_NAME
    poisonEvent.Parent = ReplicatedStorage
end

-- ฟังก์ชันเปลี่ยนสีแก้ว
local function markPoisonedCup(cup)
    if cup and cup:IsA("BasePart") then
        cup.Color = Color3.fromRGB(255,0,0)
        cup.LocalTransparencyModifier = 0
    end
end

-- ตรวจแก้วที่มี Attribute Poisoned = true
for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") and obj:GetAttribute("Poisoned") == true then
        markPoisonedCup(obj)
    end
end

-- ฟังเมื่อมีการเปลี่ยน attribute ให้ Poisoned
workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("BasePart") then
        obj:GetAttributeChangedSignal("Poisoned"):Connect(function()
            if obj:GetAttribute("Poisoned") == true then
                markPoisonedCup(obj)
            end
        end)
    end
end)

-- ฟัง RemoteEvent แบบ realtime (ถ้ามีคนกดใส่พิษ)
poisonEvent.OnClientEvent:Connect(function(cup)
    if cup and cup:IsA("BasePart") then
        markPoisonedCup(cup)
    end
end)
