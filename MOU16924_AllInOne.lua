-- MOU16924 ALL IN ONE
-- สร้างโดย MOU16924

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer

-- ===== STATE =====
local HEADLOCK = false
local CAMLOCK = false
local NOCLIP = false
local ESP = true

-- ===== UI =====
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(260,220)
frame.Position = UDim2.new(1,-280,0,80)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local close = Instance.new("TextButton", frame)
close.Size = UDim2.fromOffset(26,26)
close.Position = UDim2.new(1,-30,0,4)
close.Text = "×"
close.TextScaled = true
close.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", close)

local ball = Instance.new("TextButton", gui)
ball.Size = UDim2.fromOffset(44,44)
ball.Position = UDim2.new(1,-60,0,20)
ball.Text = "●"
ball.TextScaled = true
ball.BackgroundColor3 = Color3.fromRGB(30,30,30)
ball.Visible = false
Instance.new("UICorner", ball).CornerRadius = UDim.new(1,0)

local credit = Instance.new("TextLabel", frame)
credit.Size = UDim2.new(1,0,0,24)
credit.BackgroundTransparency = 1
credit.Text = "สร้างโดย MOU16924"
credit.TextColor3 = Color3.fromRGB(200,200,200)
credit.TextScaled = true

local function btn(txt,y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0.9,0,0,30)
	b.Position = UDim2.new(0.05,0,0,y)
	b.Text = txt
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b)
	return b
end

local b1 = btn("HEAD LOCK : OFF",30)
local b2 = btn("CAM LOCK : OFF",65)
local b3 = btn("NO CLIP : OFF",100)
local b4 = btn("ESP : ON",135)

close.MouseButton1Click:Connect(function()
	frame.Visible=false
	ball.Visible=true
end)
ball.MouseButton1Click:Connect(function()
	frame.Visible=true
	ball.Visible=false
end)

b1.MouseButton1Click:Connect(function()
	HEADLOCK = not HEADLOCK
	b1.Text = HEADLOCK and "HEAD LOCK : ON" or "HEAD LOCK : OFF"
end)
b2.MouseButton1Click:Connect(function()
	CAMLOCK = not CAMLOCK
	b2.Text = CAMLOCK and "CAM LOCK : ON" or "CAM LOCK : OFF"
end)
b3.MouseButton1Click:Connect(function()
	NOCLIP = not NOCLIP
	b3.Text = NOCLIP and "NO CLIP : ON" or "NO CLIP : OFF"
end)
b4.MouseButton1Click:Connect(function()
	ESP = not ESP
	b4.Text = ESP and "ESP : ON" or "ESP : OFF"
end)

-- ===== HEAD LOCK (VISIBLE ONLY) =====
local function getVisibleHead()
	local camPos = Camera.CFrame.Position
	local center = Camera.ViewportSize/2
	local best,dist = nil,math.huge

	for _,p in ipairs(Players:GetPlayers()) do
		if p~=LP and p.Character and p.Character:FindFirstChild("Head") then
			local h = p.Character.Head
			local pos,vis = Camera:WorldToViewportPoint(h.Position)
			if vis and pos.Z>0 then
				local rp = RaycastParams.new()
				rp.FilterDescendantsInstances = {LP.Character}
				rp.FilterType = Enum.RaycastFilterType.Blacklist
				local r = workspace:Raycast(camPos,h.Position-camPos,rp)
				if r and r.Instance:IsDescendantOf(p.Character) then
					local d = (Vector2.new(pos.X,pos.Y)-center).Magnitude
					if d<dist then
						dist=d
						best=h
					end
				end
			end
		end
	end
	return best
end

-- ===== ESP =====
local lines, texts = {}, {}

local function clear(p)
	if lines[p] then lines[p]:Remove() end
	if texts[p] then texts[p]:Remove() end
	lines[p],texts[p]=nil,nil
end

RunService.RenderStepped:Connect(function()
	-- NOCLIP
	if NOCLIP and LP.Character then
		for _,v in ipairs(LP.Character:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide=false end
		end
	end

	-- CAM LOCK
	if CAMLOCK and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
		LP.Character.HumanoidRootPart.CFrame =
			CFrame.new(LP.Character.HumanoidRootPart.Position,
			LP.Character.HumanoidRootPart.Position + Camera.CFrame.LookVector)
	end

	-- HEAD LOCK
	if HEADLOCK then
		local h = getVisibleHead()
		if h then
			Camera.CFrame = CFrame.new(Camera.CFrame.Position,h.Position)
		end
	end

	-- ESP
	for _,p in ipairs(Players:GetPlayers()) do
		if p~=LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			if not lines[p] then
				lines[p]=Drawing.new("Line")
				lines[p].Thickness=2
				lines[p].Color=Color3.new(1,1,1)
				texts[p]=Drawing.new("Text")
				texts[p].Size=16
				texts[p].Color=Color3.new(1,1,1)
			end
			if ESP then
				local hrp=p.Character.HumanoidRootPart
				local pos,vis=Camera:WorldToViewportPoint(hrp.Position)
				if vis then
					lines[p].Visible=true
					lines[p].From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y)
					lines[p].To=Vector2.new(pos.X,pos.Y)
					texts[p].Visible=true
					texts[p].Text=math.floor((Camera.CFrame.Position-hrp.Position).Magnitude)
					texts[p].Position=Vector2.new(pos.X,pos.Y-20)
				else
					lines[p].Visible=false
					texts[p].Visible=false
				end
			else
				lines[p].Visible=false
				texts[p].Visible=false
			end
		else
			clear(p)
		end
	end
end)
