-- ALL IN ONE SCORE SCRIPT
-- วางที่ ServerScriptService

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- สร้าง RemoteEvent
local AddScoreEvent = Instance.new("RemoteEvent")
AddScoreEvent.Name = "AddScoreEvent"
AddScoreEvent.Parent = ReplicatedStorage

-- เพิ่มคะแนนฝั่ง Server
AddScoreEvent.OnServerEvent:Connect(function(player, amount)
	if typeof(amount) ~= "number" then return end
	if player:FindFirstChild("leaderstats") then
		local score = player.leaderstats:FindFirstChild("Score")
		if score then
			score.Value += amount
		end
	end
end)

-- ผู้เล่นเข้าเกม
Players.PlayerAdded:Connect(function(player)

	-- leaderstats
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local Score = Instance.new("IntValue")
	Score.Name = "Score"
	Score.Value = 0
	Score.Parent = leaderstats

	-- สร้าง UI
	player.CharacterAdded:Connect(function()
		task.wait(1)

		local gui = Instance.new("ScreenGui")
		gui.Name = "ScoreUI"
		gui.ResetOnSpawn = false
		gui.Parent = player:WaitForChild("PlayerGui")

		local frame = Instance.new("Frame", gui)
		frame.Size = UDim2.fromOffset(260,180)
		frame.Position = UDim2.new(0.5,-130,0.75,0)
		frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
		frame.Active = true
		frame.Draggable = true
		Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

		local title = Instance.new("TextLabel", frame)
		title.Size = UDim2.new(1,0,0,40)
		title.BackgroundTransparency = 1
		title.Text = "เสกคะแนน"
		title.TextColor3 = Color3.new(1,1,1)
		title.Font = Enum.Font.GothamBold
		title.TextScaled = true

		local credit = Instance.new("TextLabel", frame)
		credit.Size = UDim2.new(1,0,0,20)
		credit.Position = UDim2.new(0,0,0,35)
		credit.BackgroundTransparency = 1
		credit.Text = "สร้างโดย MOU16924"
		credit.TextColor3 = Color3.fromRGB(180,180,180)
		credit.Font = Enum.Font.Gotham
		credit.TextScaled = true

		local btn = Instance.new("TextButton", frame)
		btn.Size = UDim2.new(0.8,0,0,40)
		btn.Position = UDim2.new(0.1,0,0,70)
		btn.Text = "+100 คะแนน"
		btn.Font = Enum.Font.GothamBold
		btn.TextScaled = true
		btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
		btn.TextColor3 = Color3.new(1,1,1)
		Instance.new("UICorner", btn)

		local toggle = Instance.new("TextButton", frame)
		toggle.Size = UDim2.new(0.8,0,0,35)
		toggle.Position = UDim2.new(0.1,0,0,120)
		toggle.Text = "ซ่อน / แสดง"
		toggle.Font = Enum.Font.Gotham
		toggle.TextScaled = true
		toggle.BackgroundColor3 = Color3.fromRGB(40,40,40)
		toggle.TextColor3 = Color3.new(1,1,1)
		Instance.new("UICorner", toggle)

		-- LocalScript คุมปุ่ม
		local localScript = Instance.new("LocalScript", frame)
		localScript.Source = [[
			local ReplicatedStorage = game:GetService("ReplicatedStorage")
			local AddScoreEvent = ReplicatedStorage:WaitForChild("AddScoreEvent")
			local frame = script.Parent
			local btn = frame:FindFirstChildWhichIsA("TextButton")
			local buttons = frame:GetChildren()

			btn.MouseButton1Click:Connect(function()
				AddScoreEvent:FireServer(100)
			end)

			local toggle = buttons[#buttons]
			local visible = true
			toggle.MouseButton1Click:Connect(function()
				visible = not visible
				for _,v in ipairs(frame:GetChildren()) do
					if v:IsA("TextButton") or v:IsA("TextLabel") then
						if v ~= toggle then
							v.Visible = visible
						end
					end
				end
			end)
		]]
	end)
end)
