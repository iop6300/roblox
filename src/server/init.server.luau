local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.ObbyConfig)

local oldCourse = workspace:FindFirstChild("JumpMap")
if oldCourse then
	oldCourse:Destroy()
end

local course = Instance.new("Folder")
course.Name = "JumpMap"
course.Parent = workspace

local checkpoints = {}
local touchCooldown = {}
local TOOL_NAME = "SpeedCoil"

local function makePart(name, size, position, color, material)
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.Size = size
	part.Position = position
	part.Color = color
	part.Material = material or Enum.Material.SmoothPlastic
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = course
	return part
end

local function playerFromHit(hit)
	local character = hit:FindFirstAncestorOfClass("Model")
	if not character then
		return nil
	end
	return Players:GetPlayerFromCharacter(character)
end

local function setStage(player, stage)
	local stats = player:FindFirstChild("leaderstats")
	local stageValue = stats and stats:FindFirstChild("Stage")
	if stageValue and stage > stageValue.Value then
		stageValue.Value = stage
	end
end

local function makeCheckpoint(stage, position)
	local checkpoint = makePart(
		"Checkpoint" .. stage,
		Vector3.new(12, 1, 12),
		position,
		Config.Colors.Checkpoint,
		Enum.Material.Neon
	)
	checkpoints[stage] = checkpoint
	checkpoint.Touched:Connect(function(hit)
		local player = playerFromHit(hit)
		if not player then
			return
		end
		local key = tostring(player.UserId) .. ":" .. stage
		if touchCooldown[key] then
			return
		end
		touchCooldown[key] = true
		setStage(player, stage)
		task.delay(0.5, function()
			touchCooldown[key] = nil
		end)
	end)
	return checkpoint
end

local function setCoilSpeed(player, enabled)
	local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = if enabled then Config.SpeedCoilWalkSpeed else Config.DefaultWalkSpeed
	end
end

local function makeSpeedCoil(player)
	local tool = Instance.new("Tool")
	tool.Name = TOOL_NAME
	tool.ToolTip = "장착하면 이동 속도가 빨라집니다"
	tool.CanBeDropped = false

	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Size = Vector3.new(1, 2.5, 1)
	handle.Color = Config.Colors.Toolbox
	handle.Material = Enum.Material.Neon
	handle.CanCollide = false
	handle.Parent = tool

	tool.Equipped:Connect(function()
		setCoilSpeed(player, true)
	end)
	tool.Unequipped:Connect(function()
		setCoilSpeed(player, false)
	end)
	tool.AncestryChanged:Connect(function(_, parent)
		if not parent then
			setCoilSpeed(player, false)
		end
	end)
	return tool
end

local function giveSpeedCoil(player)
	local backpack = player:FindFirstChildOfClass("Backpack")
	local character = player.Character
	if not backpack then
		return
	end
	if backpack:FindFirstChild(TOOL_NAME) or (character and character:FindFirstChild(TOOL_NAME)) then
		return
	end
	makeSpeedCoil(player).Parent = backpack
end

local toolbox = makePart("Toolbox", Vector3.new(6, 4, 5), Vector3.new(10, 8.5, 0), Config.Colors.Toolbox, Enum.Material.Metal)
local prompt = Instance.new("ProximityPrompt")
prompt.Name = "OpenToolbox"
prompt.ActionText = "열기"
prompt.ObjectText = "속도 코일 상자"
prompt.KeyboardKeyCode = Enum.KeyCode.E
prompt.HoldDuration = 0.25
prompt.MaxActivationDistance = 10
prompt.Parent = toolbox
prompt.Triggered:Connect(function(player)
	if player:GetAttribute("HasSpeedCoil") then
		return
	end
	player:SetAttribute("HasSpeedCoil", true)
	giveSpeedCoil(player)
end)

makeCheckpoint(1, Vector3.new(0, 6, 0))

for index = 1, 5 do
	local z = index * 11
	local x = if index % 2 == 0 then 7 else -7
	makePart("SteppingStone" .. index, Vector3.new(7, 1, 7), Vector3.new(x, 7 + index * 0.6, z), Config.Colors.Platform)
end
makeCheckpoint(2, Vector3.new(0, 11, 68))

for index = 1, 6 do
	local width = if index % 2 == 0 then 4 else 9
	makePart(
		"ThinPath" .. index,
		Vector3.new(width, 1, 9),
		Vector3.new(0, 11 + index * 0.45, 68 + index * 10),
		Config.Colors.Platform
	)
end
makeCheckpoint(3, Vector3.new(0, 15, 140))

for index = 1, 7 do
	local angle = index * math.pi / 2
	makePart(
		"SpiralStep" .. index,
		Vector3.new(7, 1, 7),
		Vector3.new(math.cos(angle) * 9, 15 + index * 3, 140 + index * 8),
		Config.Colors.Platform
	)
end
makeCheckpoint(4, Vector3.new(0, 38, 204))

for index = 1, 5 do
	makePart(
		"FinalJump" .. index,
		Vector3.new(6, 1, 6),
		Vector3.new((index % 2 == 0 and 9 or -9), 38 + index, 204 + index * 11),
		Config.Colors.Platform
	)
end

local finish = makePart("Finish", Vector3.new(16, 1, 16), Vector3.new(0, 44, 270), Config.Colors.Finish, Enum.Material.Neon)
finish.Touched:Connect(function(hit)
	local player = playerFromHit(hit)
	if player then
		setStage(player, Config.TotalStages)
	end
end)

local lava = makePart("Lava", Vector3.new(90, 2, 310), Vector3.new(0, 1, 135), Config.Colors.Lava, Enum.Material.Neon)
lava.Touched:Connect(function(hit)
	local humanoid = hit.Parent and hit.Parent:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.Health = 0
	end
end)

local function moveToCheckpoint(player, character)
	local stats = player:WaitForChild("leaderstats")
	local stage = stats:WaitForChild("Stage").Value
	local checkpoint = checkpoints[stage] or checkpoints[1]
	character:WaitForChild("HumanoidRootPart")
	character:PivotTo(checkpoint.CFrame + Vector3.new(0, 4, 0))
end

Players.PlayerAdded:Connect(function(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local stage = Instance.new("IntValue")
	stage.Name = "Stage"
	stage.Value = 1
	stage.Parent = leaderstats

	player.CharacterAdded:Connect(function(character)
		moveToCheckpoint(player, character)
		setCoilSpeed(player, false)
		if player:GetAttribute("HasSpeedCoil") then
			task.defer(giveSpeedCoil, player)
		end
	end)
end)
