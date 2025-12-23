local player = game.Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")
local uiEnabled = true

-- Function to toggle the UI
local function toggleUI()
uiEnabled = not uiEnabled
uiFrame.Visible = uiEnabled
if not uiEnabled then
-- Change the UI to a small ball or another form
ball.Visible = true
else
ball.Visible = false
end
end

-- Function to cut trees around
local function cutTrees()
local radius = 20 -- Change this value to set the cutting range
for _, tree in pairs(workspace:GetChildren()) do
if (tree:IsA("Part") and tree.Name == "Tree") and (tree.Position - player.Character.HumanoidRootPart.Position).magnitude tree:Destroy() -- Simulate cutting the tree
local wood = Instance.new("IntValue")
wood.Name = "Wood"
wood.Value = 1
wood.Parent = backpack
end
end
end

-- Function to plant a tree
local function plantTree()
local newTree = Instance.new("Part")
newTree.Name = "Tree"
newTree.Size = Vector3.new(1, 5, 1)
newTree.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, 2.5, 0)
newTree.Parent = workspace
end

-- Function to collect food automatically
local function collectFood()
if #backpack:GetChildren() < 10 then -- Check backpack space
for _, food in pairs(workspace:GetChildren()) do
if food:IsA("Part") and food.Name == "Food" then
food:Destroy() -- Simulate collecting food
local foodItem = Instance.new("IntValue")
foodItem.Name = "Food"
foodItem.Value = 1
foodItem.Parent = backpack
end
end
end
end

-- Binding functions to UI buttons or commands
local cutTreesBtn = uiFrame.CutTreesButton
local plantTreesBtn = uiFrame.PlantTreesButton
local collectFoodBtn = uiFrame.CollectFoodButton
local toggleUIBtn = uiFrame.ToggleUIButton

cutTreesBtn.MouseButton1Click:Connect(cutTrees)
plantTreesBtn.MouseButton1Click:Connect(plantTree)
collectFoodBtn.MouseButton1Click:Connect(collectFood)
toggleUIBtn.MouseButton1Click:Connect(toggleUI)

-- UI Setup
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
local uiFrame = Instance.new("Frame", screenGui)
local ball = Instance.new("Part", workspace)

-- Setup UI components (Example)
uiFrame.Size = UDim2.new(0.3, 0, 0.4, 0)
uiFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
uiFrame.Visible = true

ball.Size = Vector3.new(1, 1, 1)
ball.Anchored = true
ball.Position = Vector3.new(0, 50, 0) -- Setting it above the ground
ball.BrickColor = BrickColor.new("Bright yellow")

-- Function to warp to different locations
local function warpTo(location)
player.Character.HumanoidRootPart.Position = location.Position
end

-- Example usage of warp function
local warpLocation1 = Instance.new("Part", workspace)
warpLocation1.Size = Vector3.new(1, 1, 1)
warpLocation1.Position = Vector3.new(50, 1, 50) -- warp location coordinates
warpLocation1.Name = "WarpLocation1"

warpTo(warpLocation1)
