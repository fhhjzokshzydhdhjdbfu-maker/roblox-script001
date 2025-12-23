-- ===== REAL LONG RANGE SLAP (NO TELEPORT) =====
RunService.RenderStepped:Connect(function()
	if not ENABLED then return end
	if not TARGET or not TARGET.Character then return end

	local tool = getHand()
	if not tool then return end

	local handle = tool:FindFirstChild("Handle")
	if not handle then return end

	local hrp = TARGET.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local distance = (handle.Position - hrp.Position).Magnitude

	-- ระยะตีไกล (ปรับได้)
	if distance <= 40 then
		pcall(function()
			firetouchinterest(handle, hrp, 0)
			firetouchinterest(handle, hrp, 1)
		end)
	end
end)
