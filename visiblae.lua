local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local button = Instance.new("TextButton")
button.Parent = player.PlayerGui
button.Size = UDim2.new(0.2, 0, 0.1, 0)
button.Position = UDim2.new(0.4, 0, 0.45, 0)
button.Text = "เห็นผู้เล่นล่องหน"

local seeInvisible = false

button.MouseButton1Click:Connect(function()
    seeInvisible = not seeInvisible
    if seeInvisible then
        button.Text = "ไม่เห็นผู้เล่นล่องหน"
    else
        button.Text = "เห็นผู้เล่นล่องหน"
    end
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            if seeInvisible then
                p.Character.Humanoid.Transparency = 0
            else
                p.Character.Humanoid.Transparency = 1
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            if seeInvisible then
                p.Character.Humanoid.Transparency = 0
            else
                p.Character.Humanoid.Transparency = 1
            end
        end
    end
end)
