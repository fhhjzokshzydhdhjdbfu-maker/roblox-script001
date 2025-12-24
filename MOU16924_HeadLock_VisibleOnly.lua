-- HEAD LOCK (VISIBLE ONLY)
-- สร้างโดย MOU16924

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local LP = Players.LocalPlayer

-- ===== STATE =====
local LOCK_ON = false
local UI_OPEN = true

-- ===== UI =====
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(260,140)
frame.Position = UDim2.new(1,-280,0,80)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local credit = Instance.new("TextLabel", frame)
credit.Size = UDim2.new(1,0,0,28)
credit.BackgroundTransparency = 1
credit.Text = "สร้างโดย MOU16924"
credit.TextColor3 = Color3.fromRGB(200,200,200)
credit.Font = Enum.Font.Gotham
credit.TextScaled = true

local lockBtn = Instance.new("TextButton", frame)
lockBtn.Size = UDim2.new(0.85,0,0,36)
lockBtn.Position = UDim2.new(0.075,0,0,40)
lockBtn.Text = "HEAD LOCK : OFF"
lockBtn.BackgroundColor3 = Color3.fromRGB(120,40,40)
lockBtn.TextColor3 = Color3.new(1,1,1)
lockBtn.Font = Enum.Font.GothamBold
lockBtn.TextScaled = true
Instance.new("UICorner", lockBtn)

-- ปุ่มปิด UI (มุมขวาบน)
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.fromOffset(28,28)
closeBtn.Position = UDim2.new(1,-32,0,4)
closeBtn.Text = "×"
closeBtn.TextScaled = true
closeBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
Instance.new("UICorner", closeBtn)

-- ลูกบอล
local ball = Instance.new("TextButton", gui)
ball.Size = UDim2.fromOffset(44,44)
ball.Position = UDim2.new(1,-60,0,20)
ball.Text = "●"
ball.TextScaled = true
ball.BackgroundColor3 = Color3.fromRGB(30,30,30)
ball.TextColor3 = Color3.new(1,1,1)
ball.Visible = false
Instance.new("UICorner", ball).CornerRadius = UDim.new(1,0)

-- ===== UI LOGIC =====
lockBtn.MouseButton1Click:Connect(function()
	LOCK_ON = not LOCK_ON
	lockBtn.Text = LOCK_ON and "HEAD LOCK : ON" or "HEAD LOCK : OFF"
	lockBtn.BackgroundColor3 = LOCK_ON
		and Color3.fromRGB(40,120,40)
		or Color3.fromRGB(120,40,40)
end)

closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	ball.Visible = true
end)

ball.MouseButton1Click:Connect(function()
	frame.Visible = true
	ball.Visible = false
end)

-- ===== TARGET FIND (VISIBLE + NO WALL) =====
local function getVisibleTarget()
	local camPos = Camera.CFrame.Position
	local bestTarget = nil
	local bestDist = math.huge
	local screenCenter = Camera.ViewportSize / 2

	for _,plr in ipairs(Players:GetPlayers()) do
		if plr ~= LP and plr.Character and plr.Character:FindFirstChild("Head") then
			local head = plr.Character.Head
			local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)

			if onScreen and screenPos.Z > 0 then
				-- เช็คกำแพง
				local params = RaycastParams.new()
				params.FilterDescendantsInstances = {LP.Character}
				params.FilterType = Enum.RaycastFilterType.Blacklist

				local ray = workspace:Raycast(
					camPos,
					head.Position - camPos,
					params
				)

				if ray and ray.Instance:IsDescendantOf(plr.Character) then
					local dist2D = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
					if dist2D < bestDist then
						bestDist = dist2D
						bestTarget = head
					end
				end
			end
		end
	end

	return bestTarget
end

-- ===== LOCK LOOP =====
RunService.RenderStepped:Connect(function()
	if not LOCK_ON then return end

	local head = getVisibleTarget()
	if head then
		Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
	end
end)
