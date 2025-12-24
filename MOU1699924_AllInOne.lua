-- ===== ESP SETTINGS =====
local ESP_COLORS = {
	Color3.fromRGB(255,255,255), -- 1 ขาว
	Color3.fromRGB(255,0,0),     -- 2 แดง
	Color3.fromRGB(0,255,0),     -- 3 เขียว
	Color3.fromRGB(0,170,255),   -- 4 ฟ้า
	Color3.fromRGB(255,255,0),   -- 5 เหลือง
	"RAINBOW"                    -- 6 สีรุ้ง
}
local ESP_COLOR_INDEX = 1
local rainbowTick = 0

-- ===== ESP OBJECTS =====
local lines, texts = {}, {}

local function clearESP(p)
	if lines[p] then lines[p]:Remove() end
	if texts[p] then texts[p]:Remove() end
	lines[p], texts[p] = nil, nil
end

Players.PlayerRemoving:Connect(function(p)
	clearESP(p)
end)

local function getESPColor()
	if ESP_COLORS[ESP_COLOR_INDEX] == "RAINBOW" then
		rainbowTick += 0.02
		return Color3.fromHSV(rainbowTick % 1, 1, 1)
	end
	return ESP_COLORS[ESP_COLOR_INDEX]
end

RunService.RenderStepped:Connect(function()
	if not ESP then
		for p,_ in pairs(lines) do
			lines[p].Visible = false
			texts[p].Visible = false
		end
		return
	end

	local camPos = Camera.CFrame.Position
	local screenCenter = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)

	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= LP and p.Character then
			local hum = p.Character:FindFirstChildOfClass("Humanoid")
			local hrp = p.Character:FindFirstChild("HumanoidRootPart")

			-- ❌ ตาย = ลบ ESP
			if not hum or hum.Health <= 0 or not hrp then
				clearESP(p)
			else
				if not lines[p] then
					lines[p] = Drawing.new("Line")
					lines[p].Thickness = 2

					texts[p] = Drawing.new("Text")
					texts[p].Size = 16
					texts[p].Center = true
					texts[p].Outline = true
				end

				local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
				if onScreen then
					local color = getESPColor()

					lines[p].Visible = true
					lines[p].Color = color
					lines[p].From = Vector2.new(screenCenter.X, Camera.ViewportSize.Y)
					lines[p].To = Vector2.new(pos.X, pos.Y)

					texts[p].Visible = true
					texts[p].Color = color
					texts[p].Text = tostring(math.floor((camPos - hrp.Position).Magnitude))
					texts[p].Position = Vector2.new(pos.X, pos.Y - 20)
				else
					lines[p].Visible = false
					texts[p].Visible = false
				end
			end
		end
	end
end)
