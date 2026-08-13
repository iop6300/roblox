local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Config = require(ReplicatedStorage.Shared.ObbyConfig)
local player = Players.LocalPlayer

local movement = {
	Forward = false,
	Backward = false,
	Left = false,
	Right = false,
}
local cameraYaw = math.pi
local cameraPitch = math.rad(-12)
local cameraDistance = 11
local rotatingCamera = false
local extraJumpUsed = false

local function getHumanoid()
	local character = player.Character
	return character and character:FindFirstChildOfClass("Humanoid")
end

local function moveCharacter()
	local humanoid = getHumanoid()
	if not humanoid then
		return
	end

	local x = (movement.Right and 1 or 0) - (movement.Left and 1 or 0)
	local z = (movement.Backward and 1 or 0) - (movement.Forward and 1 or 0)
	local direction = Vector3.new(x, 0, z)
	if direction.Magnitude > 1 then
		direction = direction.Unit
	end
	humanoid:Move(direction, true)
end

local function requestJump()
	local humanoid = getHumanoid()
	if not humanoid then
		return
	end

	if humanoid.FloorMaterial ~= Enum.Material.Air then
		extraJumpUsed = false
		humanoid.Jump = true
	elseif not extraJumpUsed then
		extraJumpUsed = true
		local root = humanoid.RootPart
		if root then
			root.AssemblyLinearVelocity = Vector3.new(
				root.AssemblyLinearVelocity.X,
				Config.DoubleJumpForce,
				root.AssemblyLinearVelocity.Z
			)
		end
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end

local function watchCharacter(character)
	extraJumpUsed = false
	local humanoid = character:WaitForChild("Humanoid")
	humanoid.StateChanged:Connect(function(_, newState)
		if newState == Enum.HumanoidStateType.Landed or newState == Enum.HumanoidStateType.Running then
			extraJumpUsed = false
		end
	end)
end

player.CharacterAdded:Connect(watchCharacter)
if player.Character then
	task.spawn(watchCharacter, player.Character)
end

local function updateCamera(deltaTime)
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end

	local camera = workspace.CurrentCamera
	camera.CameraType = Enum.CameraType.Scriptable
	local focus = root.Position + Vector3.new(0, 2.5, 0)
	local rotation = CFrame.Angles(0, cameraYaw, 0) * CFrame.Angles(cameraPitch, 0, 0)
	local targetPosition = focus + rotation:VectorToWorldSpace(Vector3.new(0, 1.2, cameraDistance))
	local target = CFrame.lookAt(targetPosition, focus)
	local alpha = 1 - math.exp(-12 * deltaTime)
	camera.CFrame = camera.CFrame:Lerp(target, alpha)
end

local function bindFallbackControls()
	local playerScripts = player:WaitForChild("PlayerScripts", 5)
	if playerScripts and playerScripts:FindFirstChild("PlayerModule") then
		return
	end

	local function movementAction(actionName, inputState)
		movement[actionName] = inputState ~= Enum.UserInputState.End
		moveCharacter()
		return Enum.ContextActionResult.Sink
	end

	ContextActionService:BindAction("Forward", movementAction, false, Enum.KeyCode.W, Enum.KeyCode.Up)
	ContextActionService:BindAction("Backward", movementAction, false, Enum.KeyCode.S, Enum.KeyCode.Down)
	ContextActionService:BindAction("Left", movementAction, false, Enum.KeyCode.A, Enum.KeyCode.Left)
	ContextActionService:BindAction("Right", movementAction, false, Enum.KeyCode.D, Enum.KeyCode.Right)
	ContextActionService:BindAction("Jump", function(_, inputState)
		if inputState == Enum.UserInputState.Begin then
			requestJump()
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
			cameraDistance = math.clamp(cameraDistance - input.Position.Z, 6, 18)
		end
	end)

	RunService.RenderStepped:Connect(function(deltaTime)
		moveCharacter()
		updateCamera(deltaTime)
	end)
	warn("[Sky Jump] PlayerModule이 없어 대체 WASD 조작을 사용합니다.")
end

task.spawn(bindFallbackControls)

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
