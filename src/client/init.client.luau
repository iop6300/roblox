local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.ObbyConfig)
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JumpMapUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local panel = Instance.new("Frame")
panel.AnchorPoint = Vector2.new(0.5, 0)
panel.Position = UDim2.fromScale(0.5, 0.035)
panel.Size = UDim2.fromOffset(310, 78)
panel.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
panel.BackgroundTransparency = 0.08
panel.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = panel

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(18, 10)
title.Size = UDim2.new(1, -36, 0, 25)
title.Font = Enum.Font.GothamBold
title.Text = "SKY JUMP"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

local status = Instance.new("TextLabel")
status.BackgroundTransparency = 1
status.Position = UDim2.fromOffset(18, 38)
status.Size = UDim2.new(1, -36, 0, 27)
status.Font = Enum.Font.GothamMedium
status.TextColor3 = Color3.fromRGB(139, 220, 255)
status.TextSize = 16
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = panel

local stage = player:WaitForChild("leaderstats"):WaitForChild("Stage")

local function updateStatus()
	if stage.Value >= Config.TotalStages then
		status.Text = "완주 성공! 🎉"
		status.TextColor3 = Color3.fromRGB(255, 223, 94)
	else
		status.Text = string.format("체크포인트 %d / %d", stage.Value, Config.TotalStages)
		status.TextColor3 = Color3.fromRGB(139, 220, 255)
	end
end

stage:GetPropertyChangedSignal("Value"):Connect(updateStatus)
updateStatus()
