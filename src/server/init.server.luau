local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Config = require(ReplicatedStorage.Shared.ExodusConfig)

local oldWorld = workspace:FindFirstChild("ExodusAdventure")
if oldWorld then
	oldWorld:Destroy()
end

local oldMap = workspace:FindFirstChild("JumpMap")
if oldMap then
	oldMap:Destroy()
end

local storyUpdate = ReplicatedStorage:FindFirstChild("StoryUpdate") or Instance.new("RemoteEvent")
storyUpdate.Name = "StoryUpdate"
storyUpdate.Parent = ReplicatedStorage

local world = Instance.new("Folder")
world.Name = "ExodusAdventure"
world.Parent = workspace

local function part(name, size, position, color, material, parent)
	local object = Instance.new("Part")
	object.Name = name
	object.Anchored = true
	object.Size = size
	object.Position = position
	object.Color = color
	object.Material = material or Enum.Material.SmoothPlastic
	object.TopSurface = Enum.SurfaceType.Smooth
	object.BottomSurface = Enum.SurfaceType.Smooth
	object.Parent = parent or world
	return object
end

local function label(object, text)
	local gui = Instance.new("BillboardGui")
	gui.Size = UDim2.fromOffset(220, 50)
	gui.StudsOffset = Vector3.new(0, object.Size.Y / 2 + 1.8, 0)
	gui.AlwaysOnTop = true
	gui.Parent = object
	local value = Instance.new("TextLabel")
	value.Size = UDim2.fromScale(1, 1)
	value.BackgroundTransparency = 1
	value.Text = text
	value.Font = Enum.Font.GothamBold
	value.TextSize = 18
	value.TextColor3 = Color3.new(1, 1, 1)
	value.TextStrokeTransparency = 0.35
	value.Parent = gui
end

part("Desert", Vector3.new(260, 2, 260), Vector3.new(0, 0, 25), Config.Colors.Sand, Enum.Material.Sand)

part("Nile", Vector3.new(34, 1, 250), Vector3.new(-82, 1.5, 25), Config.Colors.River, Enum.Material.Glass)
for index = 1, 8 do
	local x = -45 + ((index - 1) % 4) * 25
	local z = -35 + math.floor((index - 1) / 4) * 70
	local house = part("House" .. index, Vector3.new(15, 10, 14), Vector3.new(x, 6, z), Config.Colors.Sandstone, Enum.Material.Sandstone)
	part("Door", Vector3.new(4, 6, 0.5), house.Position + Vector3.new(0, -2, -7.25), Color3.fromRGB(78, 52, 35), Enum.Material.Wood)
end

for index = 1, 6 do
	local z = -65 + index * 28
	local trunk = part("PalmTrunk" .. index, Vector3.new(2, 12, 2), Vector3.new(-61, 7, z), Color3.fromRGB(108, 75, 43), Enum.Material.Wood)
	part("PalmLeaves" .. index, Vector3.new(10, 2, 10), trunk.Position + Vector3.new(0, 7, 0), Config.Colors.Palm, Enum.Material.Grass)
end

local palace = part("Palace", Vector3.new(55, 22, 20), Vector3.new(62, 12, -75), Config.Colors.Sandstone, Enum.Material.Sandstone)
label(palace, "파라오의 궁전")
for x = 42, 82, 10 do
	part("PalaceColumn", Vector3.new(4, 25, 4), Vector3.new(x, 13.5, -64), Config.Colors.Gold, Enum.Material.Marble)
end

local tent = part("Shelter", Vector3.new(30, 1, 24), Vector3.new(45, 1.6, 45), Config.Colors.Tent, Enum.Material.Fabric)
part("TentRoof", Vector3.new(32, 2, 26), Vector3.new(45, 13, 45), Config.Colors.Tent, Enum.Material.Fabric)
for _, offset in ipairs({ Vector3.new(-14, 6, -11), Vector3.new(14, 6, -11), Vector3.new(-14, 6, 11), Vector3.new(14, 6, 11) }) do
	part("TentPost", Vector3.new(1, 12, 1), tent.Position + offset, Color3.fromRGB(72, 47, 32), Enum.Material.Wood)
end
label(tent, "마을 피난 천막")

local moses = part("Moses", Vector3.new(4, 7, 3), Vector3.new(0, 4.5, -5), Color3.fromRGB(119, 75, 51), Enum.Material.Fabric)
label(moses, "모세")
local mosesPrompt = Instance.new("ProximityPrompt")
mosesPrompt.ActionText = "대화하기"
mosesPrompt.ObjectText = "모세"
mosesPrompt.KeyboardKeyCode = Enum.KeyCode.E
mosesPrompt.HoldDuration = 0.25
mosesPrompt.MaxActivationDistance = 12
mosesPrompt.Parent = moses

local waterItems = {}
for index, position in ipairs({ Vector3.new(-57, 3, -25), Vector3.new(-55, 3, 20), Vector3.new(-60, 3, 68) }) do
	local jar = part("WaterJar" .. index, Vector3.new(3, 4, 3), position, Color3.fromRGB(76, 143, 184), Enum.Material.Glass)
	label(jar, "깨끗한 물")
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = "항아리 담기"
	prompt.ObjectText = "깨끗한 물"
	prompt.KeyboardKeyCode = Enum.KeyCode.E
	prompt.MaxActivationDistance = 10
	prompt.Parent = jar
	waterItems[index] = prompt
end

local supplyItems = {}
local supplyNames = { "약초", "깨끗한 천", "향유" }
for index, position in ipairs({ Vector3.new(35, 3, 38), Vector3.new(52, 3, 42), Vector3.new(43, 3, 55) }) do
	local supply = part("Supply" .. index, Vector3.new(3, 3, 3), position, Config.Colors.Gold, Enum.Material.Wood)
	label(supply, supplyNames[index])
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = "물자 챙기기"
	prompt.ObjectText = supplyNames[index]
	prompt.KeyboardKeyCode = Enum.KeyCode.E
	prompt.MaxActivationDistance = 10
	prompt.Parent = supply
	supplyItems[index] = prompt
end

local frogs = {}
for index = 1, 10 do
	local frog = part("Frog" .. index, Vector3.new(4, 2, 4), Vector3.new(-45 + index * 9, 3, 5 + (index % 3) * 18), Config.Colors.Danger, Enum.Material.SmoothPlastic)
	frog.Shape = Enum.PartType.Ball
	label(frog, "개구리")
	frogs[index] = { Part = frog, Origin = frog.Position, Phase = index * 0.7 }
	frog.Touched:Connect(function(hit)
		local character = hit:FindFirstAncestorOfClass("Model")
		local player = character and Players:GetPlayerFromCharacter(character)
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if player and humanoid and player:GetAttribute("Chapter") == 2 then
			humanoid.Health = 0
		end
	end)
end

RunService.Heartbeat:Connect(function()
	local now = workspace.DistributedGameTime
	for index, frogData in ipairs(frogs) do
		local offsetX = math.sin(now * 1.5 + frogData.Phase) * 18
		local offsetZ = math.cos(now * 1.1 + index) * 12
		local bounce = math.abs(math.sin(now * 3 + frogData.Phase)) * 5
		frogData.Part.Position = frogData.Origin + Vector3.new(offsetX, bounce, offsetZ)
	end
end)

local spawnByChapter = {
	[0] = Vector3.new(0, 5, 8),
	[1] = Vector3.new(-35, 5, -10),
	[2] = Vector3.new(45, 5, 45),
	[3] = Vector3.new(45, 5, 45),
	[4] = Vector3.new(0, 5, 8),
}

local function sendState(player, remaining, dialogue)
	local chapter = player:GetAttribute("Chapter") or 0
	local data = Config.Chapters[chapter]
	local progress = ""
	if chapter == 1 then
		progress = string.format(" (%d/%d)", player:GetAttribute("WaterCount") or 0, Config.WaterGoal)
	elseif chapter == 3 then
		progress = string.format(" (%d/%d)", player:GetAttribute("SupplyCount") or 0, Config.SupplyGoal)
	end
	storyUpdate:FireClient(player, {
		Chapter = chapter,
		Title = data.Title,
		Objective = data.Objective .. progress,
		Remaining = remaining,
		Dialogue = dialogue,
	})
end

local function moveToChapterSpawn(player, character)
	character:WaitForChild("HumanoidRootPart")
	local chapter = player:GetAttribute("Chapter") or 0
	character:PivotTo(CFrame.new(spawnByChapter[chapter] or spawnByChapter[0]))
end

local function startChapter3(player)
	local token = (player:GetAttribute("RunToken") or 0) + 1
	player:SetAttribute("RunToken", token)
	player:SetAttribute("Chapter", 3)
	player:SetAttribute("SupplyCount", 0)
	for index = 1, Config.SupplyGoal do
		player:SetAttribute("Supply" .. index, false)
	end
	task.spawn(function()
		for remaining = Config.SupplySeconds, 0, -1 do
			if not player.Parent or player:GetAttribute("Chapter") ~= 3 or player:GetAttribute("RunToken") ~= token then
				return
			end
			sendState(player, remaining, if remaining == Config.SupplySeconds then "작은 벌레들이 온 땅을 뒤덮었습니다. 시간이 끝나기 전에 구호 물자를 모아 주민들을 도우세요." else nil)
			task.wait(1)
		end
		if player.Parent and player:GetAttribute("Chapter") == 3 and player:GetAttribute("RunToken") == token then
			startChapter3(player)
		end
	end)
end

local function startFrogSurvival(player)
	local token = (player:GetAttribute("RunToken") or 0) + 1
	player:SetAttribute("RunToken", token)
	player:SetAttribute("Chapter", 2)
	task.spawn(function()
		for remaining = Config.SurvivalSeconds, 0, -1 do
			if not player.Parent or player:GetAttribute("Chapter") ~= 2 or player:GetAttribute("RunToken") ~= token then
				return
			end
			sendState(player, remaining, if remaining == Config.SurvivalSeconds then "개구리 떼가 마을을 덮쳤습니다. 천막 주변에서 몸을 피하세요!" else nil)
			task.wait(1)
		end
		if player.Parent and player:GetAttribute("RunToken") == token then
			startChapter3(player)
		end
	end)
end

mosesPrompt.Triggered:Connect(function(player)
	if (player:GetAttribute("Chapter") or 0) ~= 0 then
		return
	end
	player:SetAttribute("Chapter", 1)
	player:SetAttribute("WaterCount", 0)
	for index = 1, Config.WaterGoal do
		player:SetAttribute("Water" .. index, false)
	end
	sendState(player, nil, "모세가 파라오에게 백성을 보내 달라고 요구했습니다. 강물이 붉게 변했습니다. 마을을 위해 깨끗한 물을 찾으세요.")
end)

for index, prompt in ipairs(waterItems) do
	prompt.Triggered:Connect(function(player)
		if player:GetAttribute("Chapter") ~= 1 or player:GetAttribute("Water" .. index) then
			return
		end
		player:SetAttribute("Water" .. index, true)
		local count = (player:GetAttribute("WaterCount") or 0) + 1
		player:SetAttribute("WaterCount", count)
		sendState(player, nil, if count == Config.WaterGoal then "물을 모두 모았습니다. 하지만 파라오는 마음을 돌리지 않았습니다." else nil)
		if count == Config.WaterGoal then
			task.delay(2, startFrogSurvival, player)
		end
	end)
end

for index, prompt in ipairs(supplyItems) do
	prompt.Triggered:Connect(function(player)
		if player:GetAttribute("Chapter") ~= 3 or player:GetAttribute("Supply" .. index) then
			return
		end
		player:SetAttribute("Supply" .. index, true)
		local count = (player:GetAttribute("SupplyCount") or 0) + 1
		player:SetAttribute("SupplyCount", count)
		if count >= Config.SupplyGoal then
			player:SetAttribute("Chapter", 4)
			sendState(player, nil, "주민들을 도왔습니다. 그러나 파라오의 마음은 여전히 완고했습니다. 다음 재앙의 이야기가 이어집니다.")
		else
			sendState(player)
		end
	end)
end

Players.PlayerAdded:Connect(function(player)
	player:SetAttribute("Chapter", 0)
	player:SetAttribute("RunToken", 0)
	player.CharacterAdded:Connect(function(character)
		moveToChapterSpawn(player, character)
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.WalkSpeed = Config.DefaultWalkSpeed
		humanoid.Died:Connect(function()
			player:SetAttribute("RunToken", (player:GetAttribute("RunToken") or 0) + 1)
		end)
		if player:GetAttribute("Chapter") == 2 then
			task.defer(startFrogSurvival, player)
		elseif player:GetAttribute("Chapter") == 3 then
			task.defer(startChapter3, player)
		else
			task.defer(sendState, player)
		end
	end)
end)
