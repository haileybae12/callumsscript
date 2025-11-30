--[[
    SwordBot Refactored by Callum
    Version: 2.0 (GUI Edition)
    Architecture: GUI-Driven, State-Based Automation
    Core Components:
    - GUI Controller: Manages user input via on-screen buttons.
    - State Management: Central table for all operational states (Enabled, AutoTarget).
    - Auto-Targeting Module: Continuously finds the nearest valid enemy.
    - Aim & Movement Controller: The core combat logic, unchanged from the previous version.
]]

--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

--// Local Player
local localPlayer = Players.LocalPlayer

--// Configuration
local Config = {
    GyroSettings = {
        P = 50000,
        D = 1000,
        MaxTorque = Vector3.new(4e8, 4e8, 4e8)
    },
    AttackDistance = 20,
    StrafeDistance = 10,
    CloseCombatStickDistance = 5,
    AutoTargetSearchRadius = 60, -- Max distance for the auto-targeter to find enemies.
    AutoTargetInterval = 0.25   -- How often (in seconds) to scan for a new nearest target.
}

--// State & Objects
local State = {
    Enabled = false,
    AutoTarget = false,
    Target = nil,
    isStickingToTarget = false,
    strafeDirection = 1,
    strafeCounter = 0,
    movementMode = 0 -- 0 for predictive, 1 for strafing
}

local bodyGyro = Instance.new("BodyGyro")
bodyGyro.D = Config.GyroSettings.D
bodyGyro.P = Config.GyroSettings.P
bodyGyro.MaxTorque = Config.GyroSettings.MaxTorque
bodyGyro.Name = "SwordBot.AimController"

local strafeOffsetValue = Instance.new("NumberValue")
spawn(function()
    while true do
        strafeOffsetValue.Value = math.random(-90, -35)
        TweenService:Create(strafeOffsetValue, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true), { Value = math.random(35, 90) }):Play()
        task.wait(0.2)
    end
end)

--// GUI Elements
local screenGui, mainFrame, titleLabel, toggleBotButton, toggleAutoTargetButton, statusLabel, targetLabel

--// Utility Functions
local function sendSystemMessage(text, color)
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = text,
        Color = color or Color3.fromRGB(255, 255, 0),
        Font = Enum.Font.SourceSansBold,
        TextSize = 18
    })
end

--// GUI Management
local function updateGUI()
    if not screenGui then return end
    
    local enabledText = "Enable Bot"
    local enabledColor = Color3.fromRGB(80, 200, 120) -- Greenish
    if State.Enabled then
        enabledText = "Disable Bot"
        enabledColor = Color3.fromRGB(220, 80, 80) -- Reddish
    end
    toggleBotButton.Text = enabledText
    toggleBotButton.BackgroundColor3 = enabledColor

    local autoTargetText = "Auto Target: OFF"
    if State.AutoTarget then
        autoTargetText = "Auto Target: ON"
    end
    toggleAutoTargetButton.Text = autoTargetText

    statusLabel.Text = "Status: " .. (State.Enabled and "ACTIVE" or "DISABLED")
    targetLabel.Text = "Target: " .. (State.Target and State.Target.Name or "None")
end

local function createGUI()
    screenGui = Instance.new("ScreenGui", localPlayer:WaitForChild("PlayerGui"))
    screenGui.ResetOnSpawn = false
    
    mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 200, 0, 150)
    mainFrame.Position = UDim2.new(0, 10, 0, 10)
    mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    mainFrame.BorderColor3 = Color3.fromRGB(150, 150, 150)
    mainFrame.Draggable = true
    mainFrame.Active = true

    titleLabel = Instance.new("TextLabel", mainFrame)
    titleLabel.Size = UDim2.new(1, 0, 0, 25)
    titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Text = "SwordBot Control"
    titleLabel.Font = Enum.Font.SourceSansBold

    toggleBotButton = Instance.new("TextButton", mainFrame)
    toggleBotButton.Size = UDim2.new(1, -10, 0, 25)
    toggleBotButton.Position = UDim2.new(0, 5, 0, 30)
    toggleBotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBotButton.Font = Enum.Font.SourceSansBold

    toggleAutoTargetButton = Instance.new("TextButton", mainFrame)
    toggleAutoTargetButton.Size = UDim2.new(1, -10, 0, 25)
    toggleAutoTargetButton.Position = UDim2.new(0, 5, 0, 60)
    toggleAutoTargetButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    toggleAutoTargetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleAutoTargetButton.Font = Enum.Font.SourceSans

    statusLabel = Instance.new("TextLabel", mainFrame)
    statusLabel.Size = UDim2.new(1, -10, 0, 20)
    statusLabel.Position = UDim2.new(0, 5, 0, 95)
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.Text = "Status: DISABLED"
    statusLabel.Font = Enum.Font.SourceSans
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.BackgroundTransparency = 1

    targetLabel = Instance.new("TextLabel", mainFrame)
    targetLabel.Size = UDim2.new(1, -10, 0, 20)
    targetLabel.Position = UDim2.new(0, 5, 0, 115)
    targetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    targetLabel.Text = "Target: None"
    targetLabel.Font = Enum.Font.SourceSans
    targetLabel.TextXAlignment = Enum.TextXAlignment.Left
    targetLabel.BackgroundTransparency = 1

    --// Event Connections
    toggleBotButton.MouseButton1Click:Connect(function()
        State.Enabled = not State.Enabled
        if not State.Enabled and bodyGyro.Parent then
            bodyGyro.Parent = nil
        end
        updateGUI()
    end)
    
    toggleAutoTargetButton.MouseButton1Click:Connect(function()
        State.AutoTarget = not State.AutoTarget
        if not State.AutoTarget then
           State.Target = nil
        end
        updateGUI()
    end)
    
    updateGUI() -- Initial update
end


--// Core Logic
local function updateAimAndMovement()
    -- Update GUI labels in the main loop for real-time feedback
    updateGUI()

    if not State.Enabled or not State.Target then
        if bodyGyro.Parent then bodyGyro.Parent = nil end
        return
    end

    local playerChar = localPlayer.Character
    local targetChar = State.Target
    local rootPart = playerChar and playerChar:FindFirstChild("HumanoidRootPart")
    local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    local humanoid = playerChar and playerChar:FindFirstChild("Humanoid")

    if not (rootPart and targetRoot and humanoid and humanoid.Health > 0) then
        if bodyGyro.Parent then bodyGyro.Parent = nil end
        State.Target = nil -- Clear target if they become invalid
        return
    end

    bodyGyro.Parent = rootPart
    
    local distance = (targetRoot.Position - rootPart.Position).magnitude
    local targetVelocity = targetRoot.Velocity
    local rootPosition = rootPart.Position

    State.movementMode = (distance <= Config.StrafeDistance) and 1 or 0
    
    local aimPosition = (State.movementMode == 0) and (targetRoot.Position + (targetVelocity / 10)) or (targetRoot.Position + (rootPart.CFrame.RightVector * (strafeOffsetValue.Value / 25)))
    bodyGyro.CFrame = CFrame.new(rootPosition, Vector3.new(aimPosition.X, rootPosition.Y, aimPosition.Z))

    local movePosition
    if targetVelocity.Magnitude >= rootPart.Velocity.Magnitude then
        movePosition = targetRoot.Position + targetRoot.CFrame.RightVector * -1 + targetRoot.CFrame.LookVector * -1 + rootPart.CFrame.RightVector * 6 - (targetVelocity / 2)
        if distance <= Config.StrafeDistance then
            movePosition = targetRoot.Position + targetRoot.CFrame.RightVector * -1 + targetRoot.CFrame.LookVector * -1 + (rootPart.CFrame.RightVector * 1 + rootPart.CFrame.LookVector * -1) - (targetVelocity / 5) + (rootPart.CFrame.RightVector * State.strafeDirection)
        end
    else
        movePosition = targetRoot.Position + targetRoot.CFrame.RightVector * -1 + targetRoot.CFrame.LookVector * -1 + rootPart.CFrame.RightVector * 6 + (targetVelocity / 10)
        if distance <= Config.StrafeDistance then
            movePosition = targetRoot.Position + targetRoot.CFrame.RightVector * 1 + targetRoot.CFrame.LookVector * -1 + (rootPart.CFrame.RightVector * 1 + rootPart.CFrame.LookVector * -1) + (targetVelocity / 3) + (rootPart.CFrame.RightVector * State.strafeDirection)
        end
    end
    
    if distance <= Config.StrafeDistance then
        State.strafeCounter = State.strafeCounter + 1
        if State.strafeCounter >= 3 then State.strafeCounter = 0; State.strafeDirection = State.strafeDirection * -1 end
    end

    local rightArm = playerChar:FindFirstChild("Right Arm") or playerChar:FindFirstChild("RightHand")
    if rightArm then
        if (targetRoot.Position - rightArm.Position).magnitude <= Config.CloseCombatStickDistance then State.isStickingToTarget = true
        elseif (targetRoot.Position - rightArm.Position).magnitude >= Config.CloseCombatStickDistance + 2 then State.isStickingToTarget = false end
    end
    
    if State.isStickingToTarget then
        local dashValue = (math.floor(os.time()) % 4 < 2) and -2 or 0
        movePosition = rootPart.CFrame.LookVector * 5 * dashValue + (targetVelocity / 20)
    end
    
    if targetRoot.Position.Y > rootPosition.Y + 2 then humanoid.Jump = true end

    humanoid:MoveTo(movePosition)
    if distance <= Config.AttackDistance then
        local tool = playerChar:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Handle") then tool:Activate() end
    end
end

--// Auto-Targeting Loop
spawn(function()
    while true do
        if State.Enabled and State.AutoTarget then
            local playerChar = localPlayer.Character
            local rootPart = playerChar and playerChar:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local closestTarget, minDistance = nil, Config.AutoTargetSearchRadius
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= localPlayer then
                        local targetChar = player.Character
                        local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                        local targetHumanoid = targetChar and targetChar:FindFirstChild("Humanoid")
                        if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                            local distance = (targetRoot.Position - rootPart.Position).magnitude
                            if distance < minDistance then
                                minDistance = distance
                                closestTarget = targetChar
                            end
                        end
                    end
                end
                State.Target = closestTarget
            end
        end
        task.wait(Config.AutoTargetInterval)
    end
end)

--// Initialization
createGUI()
RunService.RenderStepped:Connect(updateAimAndMovement)
sendSystemMessage("SwordBot GUI Initialized.", Color3.fromRGB(255, 255, 0))
