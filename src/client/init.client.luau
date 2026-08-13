local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local storyUpdate = ReplicatedStorage:WaitForChild("StoryUpdate")

local movement = { Forward = false, Backward = false, Left = false, Right = false }
local cameraYaw = math.pi
local cameraPitch = math.rad(-12)
local cameraDistance = 12
local rotatingCamera = false

local function getHumanoid()
	local character = player.Character
	return character and character:FindFirstChildOfClass("Humanoid")
end

local function moveCharacter()
	local humanoid = getHumanoid()
	if not humanoid then return end
	local x = (movement.Right and 1 or 0) - (movement.Left and 1 or 0)
	local z = (movement.Backward and 1 or 0) - (movement.Forward and 1 or 0)
	local direction = Vector3.new(x, 0, z)
	if direction.Magnitude > 1 then direction = direction.Unit end
	humanoid:Move(direction, true)
end

local function updateCamera(deltaTime)
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local camera = workspace.CurrentCamera
	camera.CameraType = Enum.CameraType.Scriptable
	local focus = root.Position + Vector3.new(0, 2.5, 0)
	local rotation = CFrame.Angles(0, cameraYaw, 0) * CFrame.Angles(cameraPitch, 0, 0)
	local targetPosition = focus + rotation:VectorToWorldSpace(Vector3.new(0, 1.2, cameraDistance))
	local alpha = 1 - math.exp(-12 * deltaTime)
	camera.CFrame = camera.CFrame:Lerp(CFrame.lookAt(targetPosition, focus), alpha)
end

local function bindFallbackControls()
	local playerScripts = player:WaitForChild("PlayerScripts", 5)
	if playerScripts and playerScripts:FindFirstChild("PlayerModule") then return end
	local function movementAction(actionName, inputState)
		movement[actionName] = inputState ~= Enum.UserInputState.End
		return Enum.ContextActionResult.Sink
	end
	ContextActionService:BindAction("Forward", movementAction, false, Enum.KeyCode.W, Enum.KeyCode.Up)
	ContextActionService:BindAction("Backward", movementAction, false, Enum.KeyCode.S, Enum.KeyCode.Down)
	ContextActionService:BindAction("Left", movementAction, false, Enum.KeyCode.A, Enum.KeyCode.Left)
	ContextActionService:BindAction("Right", movementAction, false, Enum.KeyCode.D, Enum.KeyCode.Right)
	ContextActionService:BindAction("Jump", function(_, inputState)
		if inputState == Enum.UserInputState.Begin then
			local humanoid = getHumanoid()
			if humanoid then humanoid.Jump = true end
		end
		return Enum.ContextActionResult.Sink
	end, false, Enum.KeyCode.Space)
	UserInputService.InputBegan:Connect(function(input, processed)
		if not processed and input.UserInputType == Enum.UserInputType.MouseButton2 then
			rotatingCamera = true
			UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			rotatingCamera = false
			UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if rotatingCamera and input.UserInputType == Enum.UserInputType.MouseMovement then
			cameraYaw -= input.Delta.X * 0.004
			cameraPitch = math.clamp(cameraPitch - input.Delta.Y * 0.003, math.rad(-55), math.rad(25))
		elseif input.UserInputType == Enum.UserInputType.MouseWheel then
			cameraDistance = math.clamp(cameraDistance - input.Position.Z, 7, 20)
		end
	end)
	RunService.RenderStepped:Connect(function(deltaTime)
		moveCharacter()
		updateCamera(deltaTime)
	end)
end

task.spawn(bindFallbackControls)

local gui = Instance.new("ScreenGui")
gui.Name = "ExodusStoryUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local panel = Instance.new("Frame")
panel.AnchorPoint = Vector2.new(0.5, 0)
panel.Position = UDim2.fromScale(0.5, 0.035)
panel.Size = UDim2.new(0.82, 0, 0, 112)
panel.BackgroundColor3 = Color3.fromRGB(40, 29, 22)
panel.BackgroundTransparency = 0.08
panel.Parent = gui
local maxSize = Instance.new("UISizeConstraint")
maxSize.MaxSize = Vector2.new(680, 112)
maxSize.MinSize = Vector2.new(300, 112)
maxSize.Parent = panel
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = panel
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(212, 169, 91)
stroke.Thickness = 2
stroke.Transparency = 0.25
stroke.Parent = panel

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(20, 12)
title.Size = UDim2.new(1, -110, 0, 28)
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 226, 166)
title.TextSize = 21
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

local timer = Instance.new("TextLabel")
timer.BackgroundTransparency = 1
timer.AnchorPoint = Vector2.new(1, 0)
timer.Position = UDim2.new(1, -18, 0, 12)
timer.Size = UDim2.fromOffset(80, 28)
timer.Font = Enum.Font.GothamBold
timer.TextColor3 = Color3.fromRGB(255, 148, 122)
timer.TextSize = 20
timer.TextXAlignment = Enum.TextXAlignment.Right
timer.Parent = panel

local objective = Instance.new("TextLabel")
objective.BackgroundTransparency = 1
objective.Position = UDim2.fromOffset(20, 46)
objective.Size = UDim2.new(1, -40, 0, 48)
objective.Font = Enum.Font.GothamMedium
objective.TextColor3 = Color3.fromRGB(245, 238, 220)
objective.TextSize = 17
objective.TextWrapped = true
objective.TextXAlignment = Enum.TextXAlignment.Left
objective.TextYAlignment = Enum.TextYAlignment.Top
objective.Parent = panel

local dialogue = Instance.new("TextLabel")
dialogue.AnchorPoint = Vector2.new(0.5, 1)
dialogue.Position = UDim2.fromScale(0.5, 0.94)
dialogue.Size = UDim2.new(0.84, 0, 0, 94)
dialogue.BackgroundColor3 = Color3.fromRGB(25, 20, 18)
dialogue.BackgroundTransparency = 0.08
dialogue.Font = Enum.Font.GothamMedium
dialogue.TextColor3 = Color3.fromRGB(255, 247, 225)
dialogue.TextSize = 18
dialogue.TextWrapped = true
dialogue.Visible = false
dialogue.Parent = gui
local dialogueCorner = Instance.new("UICorner")
dialogueCorner.CornerRadius = UDim.new(0, 14)
dialogueCorner.Parent = dialogue
local dialoguePadding = Instance.new("UIPadding")
dialoguePadding.PaddingLeft = UDim.new(0, 20)
dialoguePadding.PaddingRight = UDim.new(0, 20)
dialoguePadding.Parent = dialogue

local dialogueToken = 0
storyUpdate.OnClientEvent:Connect(function(state)
	title.Text = state.Title
	objective.Text = state.Objective
	timer.Text = state.Remaining and (tostring(state.Remaining) .. "초") or ""
	if state.Dialogue then
		dialogueToken += 1
		local token = dialogueToken
		dialogue.Text = state.Dialogue
		dialogue.Visible = true
		task.delay(6, function()
			if dialogueToken == token then dialogue.Visible = false end
		end)
	end
end)
