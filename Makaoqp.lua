-- สคริปสำหรับแมพ 99 คืนในป่า
local player = game.Players.LocalPlayer
local character = player.Character
local autoCollect = false
local autoWood = false
local autoFood = false

-- UI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer.PlayerGui
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.new(1, 1, 1)
frame.Parent = screenGui

local autoCollectButton = Instance.new("TextButton")
autoCollectButton.Size = UDim2.new(0, 100, 0, 30)
autoCollectButton.Position = UDim2.new(0, 10, 0, 10)
autoCollectButton.Text = "Auto Collect: Off"
autoCollectButton.Parent = frame
autoCollectButton.MouseButton1Click:Connect(function()
    autoCollect = not autoCollect
    autoCollectButton.Text = "Auto Collect: " .. (autoCollect and "On" or "Off")
end)

local autoWoodButton = Instance.new("TextButton")
autoWoodButton.Size = UDim2.new(0, 100, 0, 30)
autoWoodButton.Position = UDim2.new(0, 10, 0, 50)
autoWoodButton.Text = "Auto Wood: Off"
autoWoodButton.Parent = frame
autoWoodButton.MouseButton1Click:Connect(function()
    autoWood = not autoWood
    autoWoodButton.Text = "Auto Wood: " .. (autoWood and "On" or "Off")
end)

local autoFoodButton = Instance.new("TextButton")
autoFoodButton.Size = UDim2.new(0, 100, 0, 30)
autoFoodButton.Position = UDim2.new(0, 110, 0, 10)
autoFoodButton.Text = "Auto Food: Off"
autoFoodButton.Parent = frame
autoFoodButton.MouseButton1Click:Connect(function()
    autoFood = not autoFood
    autoFoodButton.Text = "Auto Food: " .. (autoFood and "On" or "Off")
end)

-- ฟังก์ชันตัดไม้
local function autoWoodCut()
    while wait(1) do
        if autoWood then
            -- ตัดไม้
            game.ReplicatedStorage:WaitForChild("WoodCut"):FireServer()
        end
    end
end

-- ฟังก์ชันเก็บไม้
local function autoWoodCollect()
    while wait(1) do
        if autoCollect and autoWood then
            -- เก็บไม้
            game.ReplicatedStorage:WaitForChild("WoodCollect"):FireServer()
        end
    end
end

-- ฟังก์ชันเก็บอาหาร
local function autoFoodCollect()
    while wait(1) do
        if autoCollect and autoFood then
            -- เก็บอาหาร
            game.ReplicatedStorage:WaitFor
      
