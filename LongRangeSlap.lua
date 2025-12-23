-- ===== REAL LONG RANGE SLAP (LOCAL LIMIT) =====
local RANGE = 40

RunService.RenderStepped:Connect(function()
	if not SCRIPT_ENABLED then return end
	if not TARGET_PLAYER then return end

	local char = LocalPlayer.Character
	if not char then return end

	local tool
	for _,v in ipairs(char:GetChildren()) do
		if v:IsA("Tool") and v:FindFirstChild("Handle") then
			tool = v
			break
		end
	end
	if not tool then return end

	local handle = tool.Handle
	local targetChar = TARGET_PLAYER.Character
	if not targetChar then return end

	local hrp = targetChar:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local dist = (handle.Position - hrp.Position).Magnitude
	if dist <= RANGE then
		pcall(function()
			firetouchinterest(handle, hrp, 0)
			firetouchinterest(handle, hrp, 1)
		end)
	end
end)
