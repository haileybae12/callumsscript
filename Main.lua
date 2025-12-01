-- Introduction Splash Screen
(function()
    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")
    local THEME = {
        Title = "Success..",
        Subtitle = "Loading Zuka Tech...",
        IconAssetId = "rbxassetid://7243158473",
        BackgroundColor = Color3.fromRGB(20, 20, 25),
        AccentColor = Color3.fromRGB(0, 255, 255), -- Bright Cyan
        TextColor = Color3.fromRGB(240, 240, 240),
        FadeInTime = 0.5,
        HoldTime = 2.0,
        FadeOutTime = 0.7
    }
    local splashGui = Instance.new("ScreenGui")
    splashGui.Name = "SplashScreen_" .. math.random(1000, 9999)
    splashGui.ResetOnSpawn = false
    splashGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    local background = Instance.new("Frame", splashGui)
    background.Size = UDim2.fromScale(1, 1)
    background.BackgroundColor3 = THEME.BackgroundColor
    background.BackgroundTransparency = 1
    local centerFrame = Instance.new("Frame", background)
    centerFrame.Size = UDim2.fromOffset(200, 200)
    centerFrame.Position = UDim2.fromScale(0.5, 0.5)
    centerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    centerFrame.BackgroundTransparency = 1
    local icon = Instance.new("ImageLabel", centerFrame)
    icon.Size = UDim2.fromScale(0.5, 0.5)
    icon.Position = UDim2.fromScale(0.5, 0.35)
    icon.AnchorPoint = Vector2.new(0.5, 0.5)
    icon.BackgroundTransparency = 1
    icon.Image = THEME.IconAssetId
    icon.ImageColor3 = THEME.AccentColor
    icon.ImageTransparency = 0
    local title = Instance.new("TextLabel", centerFrame)
    title.Size = UDim2.new(1, 0, 0.2, 0)
    title.Position = UDim2.fromScale(0.5, 0.65)
    title.AnchorPoint = Vector2.new(0.5, 0.5)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamSemibold
    title.Text = THEME.Title
    title.TextColor3 = THEME.TextColor
    title.TextSize = 24
    title.TextTransparency = 1
    local subtitle = Instance.new("TextLabel", centerFrame)
    subtitle.Size = UDim2.new(1, 0, 0.1, 0)
    subtitle.Position = UDim2.fromScale(0.5, 0.8)
    subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
    subtitle.BackgroundTransparency = 1
    subtitle.Font = Enum.Font.Gotham
    subtitle.Text = THEME.Subtitle
    subtitle.TextColor3 = THEME.TextColor
    subtitle.TextSize = 14
    subtitle.TextTransparency = 1
    splashGui.Parent = CoreGui
    local tweenInfoIn = TweenInfo.new(THEME.FadeInTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenInfoOut = TweenInfo.new(THEME.FadeOutTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local fadeInTweens = {
        TweenService:Create(background, tweenInfoIn, { BackgroundTransparency = 0.3 }),
        TweenService:Create(icon, tweenInfoIn, { ImageTransparency = 0 }),
        TweenService:Create(title, tweenInfoIn, { TextTransparency = 0 }),
        TweenService:Create(subtitle, tweenInfoIn, { TextTransparency = 0.2 })
    }
    local fadeOutTweens = {
        TweenService:Create(background, tweenInfoOut, { BackgroundTransparency = 1 }),
        TweenService:Create(icon, tweenInfoOut, { ImageTransparency = 0 }),
        TweenService:Create(title, tweenInfoOut, { TextTransparency = 1 }),
        TweenService:Create(subtitle, tweenInfoOut, { TextTransparency = 1 })
    }
    for _, tween in ipairs(fadeInTweens) do tween:Play() end
    task.wait(THEME.FadeInTime + THEME.HoldTime)
    for _, tween in ipairs(fadeOutTweens) do tween:Play() end
    fadeOutTweens[1].Completed:Wait()
    splashGui:Destroy()
end)()

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

--// Variables
local LocalPlayer = Players.LocalPlayer
local Prefix = ";"
local Commands = {}
local CommandInfo = {}
local Modules = {}



--// Main Functions
function DoNotif(text, duration)
    pcall(function()
        -- Get the service for calculating text size
        local TextService = game:GetService("TextService")

        -- Find or create the main GUI container
        local notifGui = CoreGui:FindFirstChild("ZukaNotifGui") or Instance.new("ScreenGui", CoreGui)
        notifGui.Name = "ZukaNotifGui"
        notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
        notifGui.ResetOnSpawn = false

        -- Create the notification label
        local notif = Instance.new("TextLabel")
        notif.Font = Enum.Font.GothamSemibold
        notif.TextSize = 12
        notif.Text = text
        notif.TextWrapped = true -- CRITICAL FIX 1: Allow text to wrap to new lines
        notif.Size = UDim2.new(0, 300, 0, 0) -- Start with a fixed width of 300, height of 0

        -- Calculate the required size for the text to fit within the 300px width
        local textBounds = TextService:GetTextSize(notif.Text, notif.TextSize, notif.Font, Vector2.new(notif.Size.X.Offset, 1000))

        -- CRITICAL FIX 2: Apply the calculated height plus some vertical padding for aesthetics
        local verticalPadding = 20
        notif.Size = UDim2.new(0, 300, 0, textBounds.Y + verticalPadding)

        -- Set the remaining properties
        notif.Position = UDim2.new(0.5, -150, 0, -60) -- Initial off-screen position
        notif.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        notif.TextColor3 = Color3.fromRGB(255, 255, 255)
        notif.Parent = notifGui

        -- Add UI styling elements
        Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 6)
        Instance.new("UIStroke", notif).Color = Color3.fromRGB(80, 80, 100)

        -- Tween the notification onto the screen
        local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        local goal = { Position = UDim2.new(0.5, -150, 0, 10) }
        TweenService:Create(notif, tweenInfo, goal):Play()

        task.wait(duration or 1)

        -- Tween the notification off the screen
        local tweenInfoOut = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        local goalOut = { Position = UDim2.new(0.5, -150, 0, -60) }
        local outTween = TweenService:Create(notif, tweenInfoOut, goalOut)
        outTween:Play()
        outTween.Completed:Wait()
        notif:Destroy()
    end)
end

function RegisterCommand(info, func)
    if not info or not info.Name or not func then
        warn("Command registration failed: Missing info, name, or function.")
        return
    end
    local name = info.Name:lower()
    if Commands[name] then
        warn("Command registration skipped: Command '" .. name .. "' already exists.")
        return
    end
    Commands[name] = func
    if info.Aliases then
        for _, alias in ipairs(info.Aliases) do
            local aliasLower = alias:lower()
            if Commands[aliasLower] then
                warn("Alias '" .. aliasLower .. "' for command '" .. name .. "' conflicts with an existing command and was not registered.")
            else
                Commands[aliasLower] = func
            end
        end
    end
    table.insert(CommandInfo, info)
end

--// Modules
Modules.AutoComplete = {};
function Modules.AutoComplete:GetMatches(prefix)
    local matches = {}
    if typeof(prefix) ~= "string" or #prefix == 0 then return matches end
    prefix = prefix:lower()
    for cmdName, _ in pairs(Commands) do
        if cmdName:sub(1, #prefix) == prefix then
            table.insert(matches, cmdName)
        end
    end
    table.sort(matches)
    return matches
end

--// COMMAND LIST UI MODULE [VERSION 6 - POLISHED]
Modules.CommandList = {
    State = {
        UI = nil,
        IsEnabled = false,
        IsMinimized = false
    }
}

function Modules.CommandList:Initialize()
    local self = self
    
    local ui = Instance.new("ScreenGui")
    ui.Name = "CommandListUI_v6_Polished"
    ui.ResetOnSpawn = false
    ui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ui.Enabled = false
    self.State.UI = ui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.fromOffset(450, 350)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Position = UDim2.fromScale(0.5, 0.5)
    --[[ REVISED: Visuals ]]
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    mainFrame.BackgroundTransparency = 0.15 -- Making it slightly transparent
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = ui
    
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(80, 80, 100)
    
    --[[ NEW: Gradient Bloom Effect ]]
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 55)), -- Slightly lighter at the top
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 40))  -- Darker at the bottom
    })
    gradient.Parent = mainFrame

    local title = Instance.new("TextLabel", mainFrame)
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamSemibold
    title.Text = "Command List"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 20

    local closeButton = Instance.new("TextButton", mainFrame)
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.fromOffset(25, 25)
    closeButton.AnchorPoint = Vector2.new(1, 0)
    closeButton.Position = UDim2.new(1, -10, 0, 10)
    closeButton.BackgroundTransparency = 1
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 20
    closeButton.MouseButton1Click:Connect(function() self:Toggle() end)
    
    local minimizeButton = Instance.new("TextButton", mainFrame)
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.fromOffset(25, 25)
    minimizeButton.AnchorPoint = Vector2.new(1, 0)
    minimizeButton.Position = UDim2.new(1, -40, 0, 10)
    minimizeButton.BackgroundTransparency = 1
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.Text = "-"
    minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeButton.TextSize = 24

    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Name = "ScrollingFrame"
    scrollingFrame.Size = UDim2.new(1, -20, 1, -50)
    scrollingFrame.Position = UDim2.fromOffset(10, 40)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 5
    scrollingFrame.Parent = mainFrame
    
    local listLayout = Instance.new("UIListLayout", scrollingFrame)
    listLayout.Padding = UDim.new(0, 5)

    --[[ REVISED: Superior Dragging Logic ]]
    local function drag(input)
        local dragStart = input.Position
        local startPos = mainFrame.Position
        
        local moveConn, endConn
        
        moveConn = UserInputService.InputChanged:Connect(function(moveInput)
            if moveInput.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = moveInput.Position - dragStart
                -- The new position is the starting UDim2 plus the pixel delta
                mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        
        endConn = UserInputService.InputEnded:Connect(function(endInput)
            if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
                moveConn:Disconnect()
                endConn:Disconnect()
            end
        end)
    end
    
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            drag(input)
        end
    end)
    
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    minimizeButton.MouseButton1Click:Connect(function()
        self.State.IsMinimized = not self.State.IsMinimized
        
        local goalSize
        if self.State.IsMinimized then
            goalSize = UDim2.fromOffset(mainFrame.AbsoluteSize.X, 40)
            minimizeButton.Text = "+"
            scrollingFrame.Visible = false
        else
            goalSize = UDim2.fromOffset(mainFrame.AbsoluteSize.X, 350)
            minimizeButton.Text = "-"
            scrollingFrame.Visible = true
        end
        
        TweenService:Create(mainFrame, tweenInfo, {Size = goalSize}):Play()
    end)

    ui.Parent = CoreGui
    print("Command List UI Initialized. (Polished)")
end

-- (The Populate and Toggle functions remain the same as the last working version)
function Modules.CommandList:Populate()
    local scrollingFrame = self.State.UI.MainFrame:FindFirstChild("ScrollingFrame")
    if not scrollingFrame then return end
    
    local TextService = game:GetService("TextService")

    scrollingFrame:ClearAllChildren()
    local listLayout = Instance.new("UIListLayout", scrollingFrame)
    listLayout.Padding = UDim.new(0, 8)
    
    table.sort(CommandInfo, function(a, b) return a.Name < b.Name end)

    local totalHeight = 0
    local textBoundsWidth = scrollingFrame.AbsoluteSize.X - 10 

    for _, info in ipairs(CommandInfo) do
        local entry = Instance.new("TextLabel")
        entry.Name = info.Name
        entry.BackgroundTransparency = 1
        entry.Font = Enum.Font.Gotham
        entry.RichText = true
        entry.TextXAlignment = Enum.TextXAlignment.Left
        entry.TextWrapped = true
        
        local aliases = ""
        if info.Aliases and #info.Aliases > 0 then
            aliases = string.format("<font color='#AAAAAA'>(%s)</font>", table.concat(info.Aliases, ", "))
        end
        local description = info.Description or "No description."

        local richTextString = string.format(
            "<b><font color='#00FFFF'>;%s</font></b> %s\n<font size='13' color='#DDDDDD'>%s</font>",
            info.Name, aliases, description
        )
        entry.Text = richTextString
        
        local requiredSize = TextService:GetTextSize(richTextString, 14, entry.Font, Vector2.new(textBoundsWidth, 2000))
        local textHeight = requiredSize.Y + 5
        
        entry.Size = UDim2.new(1, 0, 0, textHeight)
        entry.Parent = scrollingFrame
        
        totalHeight = totalHeight + textHeight + listLayout.Padding.Offset
    end
    
    scrollingFrame.CanvasSize = UDim2.fromOffset(0, totalHeight)
end

function Modules.CommandList:Toggle()
    self.State.IsEnabled = not self.State.IsEnabled
    
    if self.State.IsEnabled then
        if self.State.IsMinimized then
            self.State.IsMinimized = false
            self.State.UI.MainFrame.Size = UDim2.fromOffset(450, 350)
            self.State.UI.MainFrame.ScrollingFrame.Visible = true
            self.State.UI.MainFrame.MinimizeButton.Text = "-"
        end
        self:Populate()
    end

    self.State.UI.Enabled = self.State.IsEnabled
end

--// REVAMPED COMMAND BAR MODULE
Modules.CommandBar = {
    State = {
        UI = nil,
        TextBox = nil,
        SuggestionsFrame = nil,
        KeybindConnection = nil,
        PrefixKey = Enum.KeyCode.Semicolon,
        IsAnimating = false,
        IsEnabled = false
    }
}

function Modules.CommandBar:Toggle()
    if self.State.IsAnimating then return end
    self.State.IsAnimating = true
    self.State.IsEnabled = not self.State.IsEnabled

    local isOpening = self.State.IsEnabled
    local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    if isOpening then
        self.State.UI.Enabled = true
        self.State.Container.Position = UDim2.fromScale(0.5, 0.82)
        self.State.Container.BackgroundTransparency = 1
        
        TweenService:Create(self.State.Container, tweenInfo, {
            Position = UDim2.fromScale(0.5, 0.8),
            BackgroundTransparency = 1
        }):Play()

        self.State.TextBox:CaptureFocus()
        self.State.IsAnimating = false
    else
        self.State.TextBox:ReleaseFocus()
        self:_ClearSuggestions()

        local anim = TweenService:Create(self.State.Container, tweenInfo, {
            Position = UDim2.fromScale(0.5, 0.82),
            BackgroundTransparency = 1
        })
        anim:Play()
        anim.Completed:Connect(function()
            self.State.UI.Enabled = false
            self.State.IsAnimating = false
        end)
    end
end

function Modules.CommandBar:_ClearSuggestions()
    if not self.State.SuggestionsFrame then return end
    self.State.SuggestionsFrame.Visible = false
    for _, child in ipairs(self.State.SuggestionsFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
end

function Modules.CommandBar:Initialize()
    local self = self
    
    -- This theme table is for reference, but our change will override it for the lines.
    local Theme = {
        BarColor = Color3.fromRGB(22, 22, 22),
        StrokeColor = Color3.fromRGB(60, 60, 60),
        InputTextColor = Color3.fromRGB(255, 255, 255),
        PlaceholderTextColor = Color3.fromRGB(150, 150, 150),
        SuggestionTextColor = Color3.fromRGB(210, 210, 220),
        SuggestionHoverColor = Color3.fromRGB(45, 45, 45),
        MainFont = Enum.Font.Gotham
    }
    local ui = Instance.new("ScreenGui")
    ui.Name, ui.ResetOnSpawn, ui.Enabled, ui.Parent = "CommandBarUI_Revamped", false, false, CoreGui
    self.State.UI = ui
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.Position = UDim2.fromScale(0.5, 0.82)
    container.Size = UDim2.new(1, 0, 0, 38)
    container.BackgroundTransparency = 1
    container.Parent = ui
    self.State.Container = container
    local inputFrame = Instance.new("Frame")
    inputFrame.Name = "InputFrame"
    inputFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    inputFrame.Position = UDim2.fromScale(0.5, 0.5)
    inputFrame.Size = UDim2.fromOffset(300, 38)
    inputFrame.BackgroundColor3 = Theme.BarColor
    inputFrame.Parent = container
    
    Instance.new("UICorner", inputFrame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", inputFrame).Color, Instance.new("UIStroke", inputFrame).Thickness = Theme.StrokeColor, 1.5
    local textBox = Instance.new("TextBox")
    textBox.Name = "Input"
    textBox.Size = UDim2.new(1, -20, 1, -10)
    textBox.Position = UDim2.fromScale(0.5, 0.5)
    textBox.AnchorPoint = Vector2.new(0.5, 0.5)
    textBox.BackgroundTransparency = 1
    textBox.Font = Theme.MainFont
    textBox.PlaceholderText = ";"
    textBox.PlaceholderColor3 = Theme.PlaceholderTextColor
    textBox.TextColor3 = Theme.InputTextColor
    textBox.TextSize = 16
    textBox.ClearTextOnFocus = true
    textBox.Parent = inputFrame
    self.State.TextBox = textBox

    --[[
        DEFINITIVE FIX:
        This function is updated to use a hardcoded dark color.
    ]]
    local function createLine(anchor)
        local line = Instance.new("Frame")
        line.Name = anchor .. "Line"
        line.AnchorPoint = Vector2.new(anchor == "Left" and 1 or 0, 0.5)
        line.Position = UDim2.new(0.5, anchor == "Left" and -155 or 155, 0.5, 0)
        line.Size = UDim2.new(0.2, 0, 0, 2)
        
        -- THE FIX: Directly setting the color to a very dark gray (near-black).
        line.BackgroundColor3 = Color3.fromRGB(10, 10, 10) 
        
        line.BorderSizePixel = 0
        line.Parent = container
        
        local gradient = Instance.new("UIGradient")
        gradient.Rotation = anchor == "Left" and 180 or 0
        -- We will use a subtle gradient that fades to black.
        gradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2), -- Starts mostly visible
            NumberSequenceKeypoint.new(1, 1)   -- Fades out
        })
        gradient.Parent = line
    end
    createLine("Left")
    createLine("Right")
    
    -- (The rest of the function remains the same as before)
    local suggestionsFrame = Instance.new("ScrollingFrame")
    suggestionsFrame.Name = "Suggestions"
    suggestionsFrame.AnchorPoint = Vector2.new(0.5, 0)
    suggestionsFrame.Position = UDim2.new(0.5, 0, 1, 10)
    suggestionsFrame.Size = UDim2.new(0, 300, 0, 120)
    suggestionsFrame.BackgroundColor3 = Theme.BarColor
    suggestionsFrame.BorderSizePixel = 0
    suggestionsFrame.ScrollBarThickness = 4
    suggestionsFrame.Visible = false
    suggestionsFrame.Parent = inputFrame
    self.State.SuggestionsFrame = suggestionsFrame
    Instance.new("UICorner", suggestionsFrame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", suggestionsFrame).Color = Theme.StrokeColor
    local listLayout = Instance.new("UIListLayout", suggestionsFrame)
    listLayout.Padding = UDim.new(0, 3)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.FillDirection = Enum.FillDirection.Vertical
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        suggestionsFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
    end)
    
    self.State.IsScriptUpdatingText = false
    local MAX_SUGGESTIONS = 2
    local function createSuggestionButton(text)
        local button = Instance.new("TextButton")
        button.Name, button.Text, button.Parent = text, text, self.State.SuggestionsFrame
        button.TextSize, button.Font, button.TextColor3 = 14, Theme.MainFont, Theme.SuggestionTextColor
        button.TextXAlignment, button.BackgroundTransparency = Enum.TextXAlignment.Left, 1
        button.Size = UDim2.new(1, -10, 0, 24)
        
        local tweenInfo = TweenInfo.new(0.15)
        button.MouseEnter:Connect(function() TweenService:Create(button, tweenInfo, { BackgroundColor3 = Theme.SuggestionHoverColor, BackgroundTransparency = 0 }):Play() end)
        button.MouseLeave:Connect(function() TweenService:Create(button, tweenInfo, { BackgroundTransparency = 1 }):Play() end)
        
        button.MouseButton1Click:Connect(function()
            self.State.IsScriptUpdatingText = true
            self.State.TextBox.Text = text .. " "
            self.State.TextBox.CursorPosition = #self.State.TextBox.Text + 1
            self.State.TextBox:CaptureFocus()
            self.State.IsScriptUpdatingText = false
            self:_ClearSuggestions()
        end)
        return button
    end
    local function updateSuggestions()
        if self.State.IsScriptUpdatingText then return end
        self:_ClearSuggestions()
        local inputText = textBox.Text:match("^%s*(%S*)")
        if not inputText or #inputText == 0 then return end
        
        local matches = Modules.AutoComplete:GetMatches(inputText)
        if #matches > 0 then
            suggestionsFrame.Visible = true
            for i, match in ipairs(matches) do
                if i > MAX_SUGGESTIONS then break end
                createSuggestionButton(match)
            end
        end
    end
    textBox.Changed:Connect(function(property) if property == "Text" then updateSuggestions() end end)
    
    local function submitCommand()
        if self.State.TextBox.Text:len() > 0 then
            processCommand(Prefix .. self.State.TextBox.Text)
            self.State.TextBox.Text = ""
            self:Toggle()
        end
    end
    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            submitCommand()
        else
            task.wait(0.1)
            if self.State.IsEnabled then self:Toggle() end
        end
    end)
    textBox.Focused:Connect(updateSuggestions)
    self.State.KeybindConnection = UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == self.State.PrefixKey then self:Toggle() end
    end)
end

--// Commands
Modules.UnlockMouse = { State = { Enabled = false, Connection = nil } }
RegisterCommand({ Name = "UnlockMouse", Aliases = {"unlockcursor", "freemouse", "um"}, Description = "Toggles a persistent loop to unlock the mouse cursor." }, function()
    local State = Modules.UnlockMouse.State
    State.Enabled = not State.Enabled
    if State.Enabled then
        if State.Connection then State.Connection:Disconnect() end
        State.Connection = RunService.RenderStepped:Connect(function()
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            UserInputService.MouseIconEnabled = true
        end)
        DoNotif("Mouse Unlock Enabled", 2)
    else
        if State.Connection then State.Connection:Disconnect(); State.Connection = nil end
        DoNotif("Mouse Unlock Disabled", 2)
    end
end)

Modules.ESP = { State = { IsActive = false, Connections = {}, TrackedPlayers = {} } }
function Modules.ESP:Toggle()
    self.State.IsActive = not self.State.IsActive
    if self.State.IsActive then
        local function createEspForPlayer(player)
            if player == LocalPlayer then return end
            local function setupVisuals(character)
                if self.State.TrackedPlayers[player] then self.State.TrackedPlayers[player].Highlight:Destroy(); self.State.TrackedPlayers[player].Billboard:Destroy() end
                local head = character:WaitForChild("Head", 2)
                if not head then return end
                local highlight = Instance.new("Highlight", character)
                highlight.FillColor, highlight.OutlineColor = Color3.fromRGB(255, 60, 60), Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency, highlight.OutlineTransparency = 0.8, 0.3
                local billboard = Instance.new("BillboardGui", head)
                billboard.Adornee, billboard.AlwaysOnTop, billboard.Size = head, true, UDim2.new(0, 200, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 2.5, 0)
                local nameLabel = Instance.new("TextLabel", billboard)
                nameLabel.Size, nameLabel.Text, nameLabel.BackgroundTransparency = UDim2.new(1, 0, 0.5, 0), player.Name, 1
                nameLabel.Font, nameLabel.TextSize, nameLabel.TextColor3 = Enum.Font.Code, 18, Color3.fromRGB(255, 255, 255)
                local teamLabel = Instance.new("TextLabel", billboard)
                teamLabel.Size, teamLabel.Position, teamLabel.BackgroundTransparency = UDim2.new(1, 0, 0.5, 0), UDim2.new(0, 0, 0.5, 0), 1
                teamLabel.Font, teamLabel.TextSize = Enum.Font.Code, 14
                teamLabel.Text = player.Team and player.Team.Name or "No Team"
                teamLabel.TextColor3 = player.Team and player.Team.TeamColor.Color or Color3.fromRGB(200, 200, 200)
                self.State.TrackedPlayers[player] = { Highlight = highlight, Billboard = billboard }
            end
            if player.Character then setupVisuals(player.Character) end
            player.CharacterAdded:Connect(setupVisuals)
        end
        local function removeEspForPlayer(player)
            if self.State.TrackedPlayers[player] then
                pcall(function() self.State.TrackedPlayers[player].Highlight:Destroy() end)
                pcall(function() self.State.TrackedPlayers[player].Billboard:Destroy() end)
                self.State.TrackedPlayers[player] = nil
            end
        end
        for _, player in ipairs(Players:GetPlayers()) do createEspForPlayer(player) end
        self.State.Connections.PlayerAdded = Players.PlayerAdded:Connect(createEspForPlayer)
        self.State.Connections.PlayerRemoving = Players.PlayerRemoving:Connect(removeEspForPlayer)
    else
        for _, conn in pairs(self.State.Connections) do conn:Disconnect() end; self.State.Connections = {}
        for _, data in pairs(self.State.TrackedPlayers) do pcall(function() data.Highlight:Destroy() end); pcall(function() data.Billboard:Destroy() end) end; self.State.TrackedPlayers = {}
    end
    DoNotif("ESP " .. (self.State.IsActive and "Enabled" or "Disabled"), 2)
end

RegisterCommand({Name = "esp", Aliases = {}, Description = "Toggles player ESP."}, function(args)
    Modules.ESP:Toggle(args)
end)

Modules.ClickTP = { State = { IsActive = false, Connection = nil } };
function Modules.ClickTP:Toggle()
    self.State.IsActive = not self.State.IsActive
    if self.State.IsActive then
        self.State.Connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local mouse = LocalPlayer:GetMouse()
                hrp.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0, 3, 0))
            end
        end)
    else
        if self.State.Connection then self.State.Connection:Disconnect(); self.State.Connection = nil end
    end
    DoNotif("Click TP " .. (self.State.IsActive and "Enabled" or "Disabled"), 2)
end

RegisterCommand({Name = "clicktp", Aliases = {}, Description = "Hold Left CTRL and click to teleport."}, function(args)
    Modules.ClickTP:Toggle(args)
end)

Modules.HighlightPlayer = { State = { TargetPlayer = nil, HighlightInstance = nil, CharacterAddedConnection = nil } }
local function findFirstPlayer(partialName)
    local lowerPartialName = string.lower(partialName)
    for _, player in ipairs(Players:GetPlayers()) do
        if string.lower(player.Name):sub(1, #lowerPartialName) == lowerPartialName then return player end
    end
    return nil
end
function Modules.HighlightPlayer:ApplyHighlight(character)
    if not character then return end
    if self.State.HighlightInstance then self.State.HighlightInstance:Destroy() end
    local highlight = Instance.new("Highlight", character)
    highlight.FillColor, highlight.OutlineColor = Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency, highlight.OutlineTransparency = 0.7, 0.2
    self.State.HighlightInstance = highlight
end
function Modules.HighlightPlayer:ClearHighlight()
    if self.State.HighlightInstance then self.State.HighlightInstance:Destroy(); self.State.HighlightInstance = nil end
    if self.State.CharacterAddedConnection then self.State.CharacterAddedConnection:Disconnect(); self.State.CharacterAddedConnection = nil end
    if self.State.TargetPlayer then DoNotif("Highlight cleared from: " .. self.State.TargetPlayer.Name, 2); self.State.TargetPlayer = nil end
end
RegisterCommand({ Name = "highlight", Aliases = {"hlp", "findplayer"}, Description = "Highlights a player. Usage: highlight <PlayerName|clear>" }, function(args)
    local argument = args[1]
    if not argument then DoNotif("Usage: highlight <PlayerName|clear>", 3); return end
    if string.lower(argument) == "clear" or string.lower(argument) == "reset" then Modules.HighlightPlayer:ClearHighlight(); return end
    local targetPlayer = findFirstPlayer(argument)
    if not targetPlayer then DoNotif("Player '" .. argument .. "' not found.", 3); return end
    Modules.HighlightPlayer:ClearHighlight()
    Modules.HighlightPlayer.State.TargetPlayer = targetPlayer
    DoNotif("Now highlighting: " .. targetPlayer.Name, 2)
    if targetPlayer.Character then Modules.HighlightPlayer:ApplyHighlight(targetPlayer.Character) end
    Modules.HighlightPlayer.State.CharacterAddedConnection = targetPlayer.CharacterAdded:Connect(function(newCharacter) Modules.HighlightPlayer:ApplyHighlight(newCharacter) end)
end)


Modules.FovChanger = {
    State = {
        IsEnabled = false,
        TargetFov = 70,
        DefaultFov = 70,
        Connection = nil
    }
}

local function updateFovOnRenderStep()
    local camera = Workspace.CurrentCamera
    local state = Modules.FovChanger.State
    if camera and state.IsEnabled and camera.FieldOfView ~= state.TargetFov then
        camera.FieldOfView = state.TargetFov
    end
end

local function enableFovLock()
    local state = Modules.FovChanger.State
    if not state.Connection then
        state.Connection = RunService.RenderStepped:Connect(updateFovOnRenderStep)
    end
    state.IsEnabled = true
end

local function disableFovLock()
    local state = Modules.FovChanger.State
    state.IsEnabled = false
    if state.Connection then
        state.Connection:Disconnect()
        state.Connection = nil
    end
end

pcall(function()
    Modules.FovChanger.State.DefaultFov = Workspace.CurrentCamera.FieldOfView
end)

RegisterCommand({ Name = "fov", Aliases = {"fieldofview", "camfov"}, Description = "Changes and locks FOV. Usage: fov <1-120|reset>" }, function(args)
    local camera = Workspace.CurrentCamera
    if not camera then 
        DoNotif("Could not find camera.", 3)
        return 
    end

    local argument = args[1]
    if not argument then 
        DoNotif("Current FOV is: " .. camera.FieldOfView, 3)
        return 
    end

    if string.lower(argument) == "reset" then
        disableFovLock()
        camera.FieldOfView = Modules.FovChanger.State.DefaultFov
        DoNotif("FOV lock disabled and reset to " .. Modules.FovChanger.State.DefaultFov, 2)
        return
    end

    local newFov = tonumber(argument)
    if not newFov then 
        DoNotif("Invalid argument. Provide a number or 'reset'.", 3)
        return 
    end

    local clampedFov = math.clamp(newFov, 1, 120)

    Modules.FovChanger.State.TargetFov = clampedFov
    enableFovLock()
    
    DoNotif("FOV locked to " .. clampedFov, 2)
end)


-- Replace your old 'cmds' command with this one.
RegisterCommand({ Name = "cmds", Aliases = {"commands", "help"}, Description = "Opens a UI that lists all available commands." }, function()
    Modules.CommandList:Toggle()
end)

Modules.Fly = {
State = {
IsActive = false,
Speed = 60,
SprintMultiplier = 2.5,
Connections = {},
BodyMovers = {}
}
}

function Modules.Fly:SetSpeed(s)
    local n = tonumber(s)
    if n and n > 0 then
        self.State.Speed = n
        DoNotif("Fly speed set to: " .. n, 1)
    else
    DoNotif("Invalid speed.", 1)
end
end

function Modules.Fly:Disable()
    if not self.State.IsActive then return end
    self.State.IsActive = false

    local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if h then h.PlatformStand = false end


    for _, mover in pairs(self.State.BodyMovers) do
        if mover and mover.Parent then
            mover:Destroy()
        end
    end


    for _, connection in ipairs(self.State.Connections) do
        connection:Disconnect()
    end

    table.clear(self.State.BodyMovers)
    table.clear(self.State.Connections)
    DoNotif("Fly disabled.", 1)
end

function Modules.Fly:Enable()
    local self = self -- FIX: Preserves the 'self' context for the connections below.
    if self.State.IsActive then return end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not (hrp and humanoid) then
        DoNotif("Character required.", 1)
        return
    end
    self.State.IsActive = true
    DoNotif("Fly Enabled.", 1)
    humanoid.PlatformStand = true
    local hrpAttachment = Instance.new("Attachment", hrp)
    local worldAttachment = Instance.new("Attachment", workspace.Terrain)
    worldAttachment.WorldCFrame = hrp.CFrame
    local alignOrientation = Instance.new("AlignOrientation")
    alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
    alignOrientation.Attachment0 = hrpAttachment
    alignOrientation.Responsiveness = 200
    alignOrientation.MaxTorque = math.huge
    alignOrientation.Parent = hrp
    local linearVelocity = Instance.new("LinearVelocity")
    linearVelocity.Attachment0 = hrpAttachment
    linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
    linearVelocity.MaxForce = math.huge
    linearVelocity.VectorVelocity = Vector3.zero
    linearVelocity.Parent = hrp
    self.State.BodyMovers.HRPAttachment = hrpAttachment
    self.State.BodyMovers.WorldAttachment = worldAttachment
    self.State.BodyMovers.AlignOrientation = alignOrientation
    self.State.BodyMovers.LinearVelocity = linearVelocity
    local keys = {}
    local function onInput(input, gameProcessed)
        if not gameProcessed then
            keys[input.KeyCode] = (input.UserInputState == Enum.UserInputState.Begin)
        end
    end
    table.insert(self.State.Connections, UserInputService.InputBegan:Connect(onInput))
    table.insert(self.State.Connections, UserInputService.InputEnded:Connect(onInput))
    local loop = RunService.RenderStepped:Connect(function()
        if not self.State.IsActive or not hrp.Parent then return end
        local camera = workspace.CurrentCamera
        alignOrientation.CFrame = camera.CFrame
        local direction = Vector3.new()
        if keys[Enum.KeyCode.W] then direction += camera.CFrame.LookVector end
        if keys[Enum.KeyCode.S] then direction -= camera.CFrame.LookVector end
        if keys[Enum.KeyCode.D] then direction += camera.CFrame.RightVector end
        if keys[Enum.KeyCode.A] then direction -= camera.CFrame.RightVector end
        if keys[Enum.KeyCode.Space] or keys[Enum.KeyCode.E] then direction += Vector3.yAxis end
        if keys[Enum.KeyCode.LeftControl] or keys[Enum.KeyCode.Q] then direction -= Vector3.yAxis end
        local speed = keys[Enum.KeyCode.LeftShift] and self.State.Speed * self.State.SprintMultiplier or self.State.Speed
        linearVelocity.VectorVelocity = direction.Magnitude > 0 and direction.Unit * speed or Vector3.zero
    end)
    table.insert(self.State.Connections, loop)
end

function Modules.Fly:Toggle()
    if self.State.IsActive then
        self:Disable()
    else
    self:Enable()
end
end

RegisterCommand({ Name = "fly", Aliases = {"flight"}, Description = "Toggles smooth flight mode." }, function()
    Modules.Fly:Toggle()
end)

Modules.NoClip = {
    State = {
        IsActive = false,
        Connection = nil
    }
}

function Modules.NoClip:Toggle()
    local state = self.State
    state.IsActive = not state.IsActive

    if state.IsActive then
        -- ENABLE NOCLIP
        state.Connection = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        DoNotif("NoClip Enabled", 2)
    else
        -- DISABLE NOCLIP
        if state.Connection then
            state.Connection:Disconnect()
            state.Connection = nil
        end
        DoNotif("NoClip Disabled", 2)
    end
end

RegisterCommand({ Name = "noclip", Aliases = {"nc"}, Description = "Allows you to fly through walls and objects." }, function()
    Modules.NoClip:Toggle()
end)



--// Universal Melee Editor Module
Modules.MeleeEditor = {
    State = {
        UI = nil,
        LiveConfig = nil,
        BackupConfig = nil,
        IsInitialized = false
    }
}

-- Utility function for deep copying tables
function Modules.MeleeEditor:_deepcopy(original)
    local copy = {}
    for key, value in pairs(original) do
        if type(value) == "table" then
            copy[key] = self:_deepcopy(value)
        else
            copy[key] = value
        end
    end
    return copy
end

function Modules.MeleeEditor:InitializeAndCreateUI()
    -- This function will only run once.
    if self.State.IsInitialized then return true end

    -- Failsafe Check: Ensure we are in the correct game before proceeding.
    local globalConfigModule = ReplicatedStorage:FindFirstChild("GlobalConfig")
    if not (globalConfigModule and globalConfigModule:IsA("ModuleScript")) then
        DoNotif("Melee Editor Error: 'GlobalConfig' module not found.", 5)
        return false -- Stop initialization
    end

    -- The Core Exploit: Get direct references to the game's live and backup configs.
    self.State.LiveConfig = require(globalConfigModule)
    self.State.BackupConfig = self:_deepcopy(self.State.LiveConfig)

    --// UI Creation (ported directly from the original script)
    local gui = Instance.new("ScreenGui")
    gui.Name = "MeleeEditorGUI_Integrated"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    self.State.UI = gui -- Store the UI in the state

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.fromOffset(450, 300)
    mainFrame.Position = UDim2.fromScale(0.5, 0.5)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = gui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

    local titleLabel = Instance.new("TextLabel", mainFrame)
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.Text = "Universal Melee Editor"
    titleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)

    local weaponList = Instance.new("ScrollingFrame", mainFrame)
    weaponList.Size = UDim2.new(0, 150, 1, -40)
    weaponList.Position = UDim2.fromOffset(10, 35)
    weaponList.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    weaponList.BorderSizePixel = 0
    weaponList.ScrollBarThickness = 6
    Instance.new("UIListLayout", weaponList).Padding = UDim.new(0, 5)

    local controlFrame = Instance.new("Frame", mainFrame)
    controlFrame.Size = UDim2.new(1, -180, 1, -40)
    controlFrame.Position = UDim2.fromOffset(170, 35)
    controlFrame.BackgroundTransparency = 1

    local selectedWeaponLabel = Instance.new("TextLabel", controlFrame)
    selectedWeaponLabel.Size = UDim2.new(1, 0, 0, 25)
    selectedWeaponLabel.Font = Enum.Font.GothamBold
    selectedWeaponLabel.Text = "Select a Weapon"
    selectedWeaponLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    selectedWeaponLabel.BackgroundTransparency = 1

    local damageInput = Instance.new("TextBox", controlFrame)
    damageInput.Size = UDim2.new(1, 0, 0, 35)
    damageInput.Position = UDim2.new(0, 0, 0, 50)
    damageInput.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    damageInput.Font = Enum.Font.Gotham
    damageInput.PlaceholderText = "Damage (e.g., 5000)"
    damageInput.TextColor3 = Color3.fromRGB(240, 240, 240)
    Instance.new("UICorner", damageInput).CornerRadius = UDim.new(0, 6)

    local cooldownInput = Instance.new("TextBox", controlFrame)
    cooldownInput.Size = UDim2.new(1, 0, 0, 35)
    cooldownInput.Position = UDim2.new(0, 0, 0, 95)
    cooldownInput.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    cooldownInput.Font = Enum.Font.Gotham
    cooldownInput.PlaceholderText = "Cooldown (e.g., 0)"
    cooldownInput.TextColor3 = Color3.fromRGB(240, 240, 240)
    Instance.new("UICorner", cooldownInput).CornerRadius = UDim.new(0, 6)

    local applyButton = Instance.new("TextButton", controlFrame)
    applyButton.Size = UDim2.new(1, 0, 0, 40)
    applyButton.Position = UDim2.new(0, 0, 0, 150)
    applyButton.BackgroundColor3 = Color3.fromRGB(80, 100, 255)
    applyButton.Font = Enum.Font.GothamBold
    applyButton.Text = "Apply Stats"
    applyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", applyButton).CornerRadius = UDim.new(0, 6)

    local restoreButton = Instance.new("TextButton", controlFrame)
    restoreButton.Size = UDim2.new(1, 0, 0, 30)
    restoreButton.Position = UDim2.new(0, 0, 0, 200)
    restoreButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    restoreButton.Font = Enum.Font.Gotham
    restoreButton.Text = "Restore Originals"
    restoreButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    Instance.new("UICorner", restoreButton).CornerRadius = UDim.new(0, 6)

    local selectedWeaponName = nil
    for weaponName, stats in pairs(self.State.LiveConfig.Melee) do
        if type(stats) ~= "table" or not stats.Damage then continue end
        local weaponButton = Instance.new("TextButton", weaponList)
        weaponButton.Name = weaponName; weaponButton.Size = UDim2.new(1, 0, 0, 30); weaponButton.BackgroundColor3 = Color3.fromRGB(50, 50, 65); weaponButton.TextColor3 = Color3.fromRGB(220, 220, 230); weaponButton.Font = Enum.Font.Code; weaponButton.Text = weaponName
        Instance.new("UICorner", weaponButton).CornerRadius = UDim.new(0, 4)
        weaponButton.MouseButton1Click:Connect(function()
            selectedWeaponName = weaponName
            selectedWeaponLabel.Text = "Selected: " .. weaponName
            damageInput.Text = tostring(self.State.LiveConfig.Melee[weaponName].Damage)
            cooldownInput.Text = tostring(self.State.LiveConfig.Melee[weaponName].Cooldown)
        end)
    end

    applyButton.MouseButton1Click:Connect(function()
        if not selectedWeaponName then return end
        local newDamage = tonumber(damageInput.Text)
        local newCooldown = tonumber(cooldownInput.Text)
        if newDamage then self.State.LiveConfig.Melee[selectedWeaponName].Damage = newDamage end
        if newCooldown then self.State.LiveConfig.Melee[selectedWeaponName].Cooldown = newCooldown end
        DoNotif("Applied stats to " .. selectedWeaponName, 2)
    end)

    restoreButton.MouseButton1Click:Connect(function()
        self.State.LiveConfig.Melee = self:_deepcopy(self.State.BackupConfig.Melee)
        if selectedWeaponName then
            damageInput.Text = tostring(self.State.LiveConfig.Melee[selectedWeaponName].Damage)
            cooldownInput.Text = tostring(self.State.LiveConfig.Melee[selectedWeaponName].Cooldown)
        end
        DoNotif("All melee stats restored to original values.", 3)
    end)
    
    gui.Parent = CoreGui
    self.State.IsInitialized = true
    DoNotif("Melee Editor Initialized.", 2)
    return true
end

function Modules.MeleeEditor:Toggle()
    -- Attempt to initialize the UI the first time the command is run.
    if not self.State.IsInitialized then
        if not self:InitializeAndCreateUI() then
            -- If initialization fails (e.g., not in the right game), stop here.
            return
        end
    end
    -- Toggle the visibility of the already-created UI.
    self.State.UI.Enabled = not self.State.UI.Enabled
end

-- Register the command in your admin system
RegisterCommand({
    Name = "meleeditor",
    Aliases = {"medit", "weaponeditor"},
    Description = "Opens a GUI to edit melee weapon stats by poisoning a shared module."
}, function(args)
    Modules.MeleeEditor:Toggle()
end)



Modules.AnimationFreezer = {
    State = {
        IsEnabled = false,
        CharacterConnection = nil,
        Originals = {} -- Store original animators per character
    }
}

function Modules.AnimationFreezer:_applyFreeze(character)
    if not character or self.State.Originals[character] then return end -- Already applied or no character

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then return end

    -- Store the original animator so we can restore it later
    self.State.Originals[character] = animator


    local fakeAnimationTrack = {
        IsPlaying = false,
        Length = 0,
        TimePosition = 0,
        Speed = 0,
        Play = function() end,
        Stop = function() end,
        Pause = function() end,
        AdjustSpeed = function() end,
        GetMarkerReachedSignal = function() return { Connect = function() end } end,
        GetTimeOfKeyframe = function() return 0 end,
        Destroy = function() end
    }
    
    -- We create a proxy (a stand-in) for the real Animator.
    local animatorProxy = {}
    local animatorMetatable = {
        __index = function(t, key)
            -- Intercept the call to LoadAnimation
            if tostring(key):lower() == "loadanimation" then
                -- Return a function that, when called, gives back our fake track.
                return function()
                    return fakeAnimationTrack
                end
            else
                return self.State.Originals[character][key]
            end
        end
    }

    -- Apply the metatable to our proxy
    setmetatable(animatorProxy, animatorMetatable)
    
    -- Replace the real Animator with our proxy
    animator.Parent = nil
    animatorProxy.Name = "Animator"
    animatorProxy.Parent = humanoid
end

function Modules.AnimationFreezer:_removeFreeze(character)
    if not character or not self.State.Originals[character] then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    -- Find our fake proxy and the original animator
    local proxy = humanoid:FindFirstChild("Animator")
    local original = self.State.Originals[character]

    if proxy then proxy:Destroy() end
    if original then original.Parent = humanoid end

    self.State.Originals[character] = nil
end

function Modules.AnimationFreezer:Toggle()
    self.State.IsEnabled = not self.State.IsEnabled

    if self.State.IsEnabled then
        DoNotif("Animation Freezer Enabled", 2)
        
        -- Apply to the current character if it exists
        if LocalPlayer.Character then
            self:_applyFreeze(LocalPlayer.Character)
        end
        
        -- Apply to all future characters
        self.State.CharacterConnection = LocalPlayer.CharacterAdded:Connect(function(character)
            -- A small delay is crucial to ensure the Animator has been created
            task.wait(0.1) 
            self:_applyFreeze(character)
        end)
    else
        DoNotif("Animation Freezer Disabled", 2)
        
        -- Remove from the current character
        if LocalPlayer.Character then
            self:_removeFreeze(LocalPlayer.Character)
        end

        -- Stop listening for new characters
        if self.State.CharacterConnection then
            self.State.CharacterConnection:Disconnect()
            self.State.CharacterConnection = nil
        end
        
        -- Clean up any remaining tracked originals just in case
        for char, animator in pairs(self.State.Originals) do
            self:_removeFreeze(char)
        end
    end
end

-- Register the command in your system
RegisterCommand({
    Name = "freezeanim",
    Aliases = {"noanim", "fa"},
    Description = "Freezes all local character animations to skip delays (e.g., weapon swings)."
}, function()
    Modules.AnimationFreezer:Toggle()
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

Modules.SuperPush = {
    State = {
        IsEnabled = false,
        Connections = {},
        Originals = setmetatable({}, {__mode = "k"}) -- Use a weak table for part references
    },
    Config = {
        PUSH_FORCE = 300,   -- The intensity of the velocity spike.
        DENSITY = 100,      -- How dense/heavy your character becomes. (Default is ~0.7)
        COOLDOWN = 0.2,     -- Cooldown between pushes in seconds.
        lastPushTime = 0
    }
}

-- Create the physical properties object once for efficiency
local HEAVY_PROPERTIES = PhysicalProperties.new(Modules.SuperPush.Config.DENSITY, 0.5, 0.5)

function Modules.SuperPush:_cleanupCharacter(character)
    if not character then return end

    -- Disconnect the touch event
    if self.State.Connections.Touch then
        self.State.Connections.Touch:Disconnect()
        self.State.Connections.Touch = nil
    end

    -- Restore original physical properties
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and self.State.Originals[part] then
            part.CustomPhysicalProperties = self.State.Originals[part]
            self.State.Originals[part] = nil -- Clear the stored value
        end
    end
end

function Modules.SuperPush:_applyToCharacter(character)
    if not character then return end
    
    local hrp = character:WaitForChild("HumanoidRootPart", 5)
    if not hrp then return end

    -- 1. Apply Heavyweight Properties
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            -- Store the original properties if we haven't already
            if not self.State.Originals[part] then
                self.State.Originals[part] = part.CustomPhysicalProperties
            end
            part.CustomPhysicalProperties = HEAVY_PROPERTIES
        end
    end

    -- 2. Setup Momentum Push Connection
    self.State.Connections.Touch = hrp.Touched:Connect(function(otherPart)
        if os.clock() - self.Config.lastPushTime < self.Config.COOLDOWN then return end
        
        local targetModel = otherPart:FindFirstAncestorWhichIsA("Model")
        if not targetModel then return end
        
        local targetPlayer = Players:GetPlayerFromCharacter(targetModel)
        if not targetPlayer or targetPlayer == LocalPlayer then return end

        local direction = hrp.CFrame.LookVector
        hrp.AssemblyLinearVelocity = direction * self.Config.PUSH_FORCE
        
        self.Config.lastPushTime = os.clock()

        task.wait()
        if hrp and hrp.Parent then
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end)
end

function Modules.SuperPush:Toggle()
    self.State.IsEnabled = not self.State.IsEnabled

    if self.State.IsEnabled then
        DoNotif("Super Push Enabled (Force: " .. self.Config.PUSH_FORCE .. ", Density: " .. self.Config.DENSITY .. ")", 3)
        
        -- Apply to current character
        if LocalPlayer.Character then
            self:_applyToCharacter(LocalPlayer.Character)
        end

        -- Handle future characters and clean up old ones
        self.State.Connections.CharacterAdded = LocalPlayer.CharacterAdded:Connect(function(character)
            self:_applyToCharacter(character)
        end)
        self.State.Connections.CharacterRemoving = LocalPlayer.CharacterRemoving:Connect(function(character)
            self:_cleanupCharacter(character)
        end)
    else
        DoNotif("Super Push Disabled", 2)
        
        -- Disconnect character event listeners
        if self.State.Connections.CharacterAdded then self.State.Connections.CharacterAdded:Disconnect() end
        if self.State.Connections.CharacterRemoving then self.State.Connections.CharacterRemoving:Disconnect() end
        table.clear(self.State.Connections)

        -- Clean up effects from the current character
        if LocalPlayer.Character then
            self:_cleanupCharacter(LocalPlayer.Character)
        end
    end
end

RegisterCommand({
    Name = "superpush",
    Aliases = {"push", "bump", "heavy"},
    Description = "Increases your mass and adds a velocity push when you bump into players."
}, function()
    Modules.SuperPush:Toggle()
end


--// DECOMPILER MODULE [XENO COMPATIBLE]
Modules.Decompiler = { State = { IsInitialized = false } }
function Modules.Decompiler:Initialize()
    if self.State.IsInitialized then
        return DoNotif("Decompiler is already initialized.", 3)
    end
    if not getscriptbytecode then
        return DoNotif("Decompiler Error: 'getscriptbytecode' is not available.", 5)
    end
    --// [XENO COMPATIBILITY FIX]: Create a universal HTTP function that works on Synapse, Xeno, and others.
    local httpRequest = (syn and syn.request) or (http and http.request) or http_request or request
    if not httpRequest then
        return DoNotif("Decompiler Error: A compatible HTTP function is required.", 5)
    end
    task.spawn(function()
        local API_URL = "http://api.plusgiant5.com"
        local last_call_time = 0
        local function callAPI(endpoint, scriptInstance)
            local success, bytecode = pcall(getscriptbytecode, scriptInstance)
            if not success then return DoNotif("Failed to get bytecode: " .. tostring(bytecode), 4) end
            local time_elapsed = os.clock() - last_call_time
            if time_elapsed < 0.5 then task.wait(0.5 - time_elapsed) end
            local reqSuccess, httpResult = pcall(httpRequest, {
                Url = API_URL .. endpoint, Body = bytecode, Method = "POST",
                Headers = { ["Content-Type"] = "text/plain" }
            })
            last_call_time = os.clock()
            if not reqSuccess then return DoNotif("HTTP request failed: " .. tostring(httpResult), 5) end
            if httpResult.StatusCode ~= 200 then return DoNotif("API Error " .. httpResult.StatusCode .. ": " .. httpResult.StatusMessage, 4) end
            return httpResult.Body
        end
        local function decompile_func(scriptInstance)
            if not (scriptInstance and (scriptInstance:IsA("LocalScript") or scriptInstance:IsA("ModuleScript"))) then
                warn("Decompile target must be a LocalScript or ModuleScript instance.")
                return nil
            end
            return callAPI("/konstant/decompile", scriptInstance)
        end
        local env = getfenv()
        env.decompile = decompile_func
        self.State.IsInitialized = true
        DoNotif("Decompiler initialized.", 4)
        DoNotif("Use 'decompile(script_instance)' globally.", 6)
    end)
end
RegisterCommand({Name = "decompile", Aliases = {"decomp", "disassemble"}, Description = "Initializes the Konstant decompiler functions."}, function()
    Modules.Decompiler:Initialize()
end)


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Module Definition
Modules.RespawnAtDeath = {
State = {
Enabled = false,
LastDeathCFrame = nil,
DiedConnection = nil,
CharacterConnection = nil,
}
}

-- This function runs when the player's character dies
function Modules.RespawnAtDeath.OnDied()
    local character = Players.LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if root then
        -- Capture the death location
        Modules.RespawnAtDeath.State.LastDeathCFrame = root.CFrame
        print("Death location saved.")
    end
end

function Modules.RespawnAtDeath.OnCharacterAdded(character)
   
    local humanoid = character:WaitForChild("Humanoid")
   

    if Modules.RespawnAtDeath.State.DiedConnection then
   
        Modules.RespawnAtDeath.State.DiedConnection:Disconnect()
    end
    Modules.RespawnAtDeath.State.DiedConnection = humanoid.Died:Connect(Modules.RespawnAtDeath.OnDied)

    local deathCFrame = Modules.RespawnAtDeath.State.LastDeathCFrame
    if deathCFrame then
        coroutine.wrap(function()
        print("Teleporting to saved death location...")

        task.wait(0.1)

        local root = character:WaitForChild("HumanoidRootPart")
        if not root then return end

        -- Execute the Anchor-Teleport
        local originalAnchored = root.Anchored
        root.Anchored = true
        root.CFrame = deathCFrame
        RunService.Heartbeat:Wait() -- Wait one frame for the change to register
        root.Anchored = originalAnchored

        -- Clear the CFrame so we don't teleport on manual reset
        Modules.RespawnAtDeath.State.LastDeathCFrame = nil
        print("Teleport successful.")
        end)()
    end
end

-- The main toggle function
function Modules.RespawnAtDeath.Toggle()
    local localPlayer = Players.LocalPlayer
    Modules.RespawnAtDeath.State.Enabled = not Modules.RespawnAtDeath.State.Enabled

    if Modules.RespawnAtDeath.State.Enabled then
        print("Respawn at Death: ENABLED")
        Modules.RespawnAtDeath.State.CharacterConnection = localPlayer.CharacterAdded:Connect(Modules.RespawnAtDeath.OnCharacterAdded)

        if localPlayer.Character then
            -- Manually run for the current character if it already exists
            Modules.RespawnAtDeath.OnCharacterAdded(localPlayer.Character)
        end
    else
    print("Respawn at Death: DISABLED")
    if Modules.RespawnAtDeath.State.DiedConnection then
        Modules.RespawnAtDeath.State.DiedConnection:Disconnect()
        Modules.RespawnAtDeath.State.DiedConnection = nil
    end
    if Modules.RespawnAtDeath.State.CharacterConnection then
        Modules.RespawnAtDeath.State.CharacterConnection:Disconnect()
        Modules.RespawnAtDeath.State.CharacterConnection = nil
    end
    Modules.RespawnAtDeath.State.LastDeathCFrame = nil
end
end

-- Register the command
RegisterCommand({
Name = "RespawnAtDeath",
Aliases = {"deathspawn", "spawnondeath"},
Description = "Toggles respawning at your last death location (Reliable)."
}, function(args)
Modules.RespawnAtDeath.Toggle()
end)



local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")


Modules.RejoinServer = {
State = {}
}


RegisterCommand({
Name = "rejoin",
Aliases = {"rj", "reconnect"},
Description = "Teleports you back to the current server."
}, function(args)
local localPlayer = Players.LocalPlayer

if not localPlayer then
    print("Error: Could not find LocalPlayer.")
    return
end

local placeId = game.PlaceId
local jobId = game.JobId

print("Rejoining server... Please wait.")


local success, errorMessage = pcall(function()
TeleportService:TeleportToPlaceInstance(placeId, jobId, localPlayer)
end)

if not success then
    print("Rejoin failed: " .. errorMessage)
end
end)


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")


Modules.AutoAttack = {
State = {
Enabled = false,
ClickDelay = 0.1,
Connection = nil,
LastClickTime = 0
}
}


function Modules.AutoAttack:AttackLoop()

    if UserInputService:GetFocusedTextBox() then
        return
    end

    local currentTime = os.clock()


    if currentTime - self.State.LastClickTime > self.State.ClickDelay then


        mouse1press()
        task.wait()
        mouse1release()


        self.State.LastClickTime = currentTime
    end
end


function Modules.AutoAttack:Enable()
    local self = self -- FIX: Preserves the 'self' context for the connection below.
    self.State.Enabled = true
    self.State.LastClickTime = 0
    self.State.Connection = RunService.Heartbeat:Connect(function()
        self:AttackLoop()
    end)
    print("Auto-Attack: [Enabled] | Delay: " .. self.State.ClickDelay * 1000 .. "ms")
end


function Modules.AutoAttack:Disable()
    self.State.Enabled = false
    if self.State.Connection then
        self.State.Connection:Disconnect()
        self.State.Connection = nil
    end
    print("Auto-Attack: [Disabled]")
end

RegisterCommand({
Name = "autoattack",
Aliases = {"aa", "autoclick"},
Description = "Toggles auto-click. Usage: autoattack [delay_in_ms]"
}, function(args)

local newDelay = tonumber(args[1])
if newDelay and newDelay > 0 then

    Modules.AutoAttack.State.ClickDelay = newDelay / 1000
    print("--> Auto-Attack delay set to: " .. newDelay .. "ms")


    if Modules.AutoAttack.State.Enabled then
        print("Auto-Attack: [Enabled] | Delay: " .. newDelay .. "ms")
    end
    return
end


if Modules.AutoAttack.State.Enabled then
    Modules.AutoAttack:Disable()
else
Modules.AutoAttack:Enable()
end
end)

Modules.killbrick = {
State = {
Tracked = setmetatable({}, {__mode="k"}),
Originals = setmetatable({}, {__mode="k"}),
Signals = setmetatable({}, {__mode="k"}),
Connections = {}
}
}

-- Private function to perform all cleanup and disable the anti-killbrick effect.
local function cleanupAntiKillbrick()
local state = Modules.killbrick.State

-- Disconnect all general connections
for _, conn in ipairs(state.Connections) do
    if conn and typeof(conn.Disconnect) == "function" then
        conn:Disconnect()
    end
end
table.clear(state.Connections)

-- Disconnect all part-specific signals
for _, signalTable in pairs(state.Signals) do
    if signalTable then
        for _, conn in ipairs(signalTable) do
            if conn and typeof(conn.Disconnect) == "function" then
                conn:Disconnect()
            end
        end
    end
end

-- Restore original CanTouch properties on all tracked parts
for part, originalValue in pairs(state.Originals) do
    if typeof(part) == "Instance" and part:IsA("BasePart") then
        part.CanTouch = (originalValue == nil) or originalValue -- Default to true if no value was stored
    end
end

-- Clear all state tables to prevent memory leaks
table.clear(state.Signals)
table.clear(state.Tracked)
table.clear(state.Originals)
end

-- Enables the anti-killbrick feature
function Modules.killbrick.Enable()
    cleanupAntiKillbrick() -- Ensure any previous state is cleared before starting

    local state = Modules.killbrick.State
    local localPlayer = Players.LocalPlayer

    -- Protects a single part by making it non-touchable
    local function applyProtection(part)
    if not (part and part:IsA("BasePart")) then return end

    if state.Originals[part] == nil then
        state.Originals[part] = part.CanTouch
    end

    part.CanTouch = false
    state.Tracked[part] = true

    if not state.Signals[part] then
        local connection = part:GetPropertyChangedSignal("CanTouch"):Connect(function()
        if part.CanTouch ~= false then
            part.CanTouch = false
        end
        end)
        state.Signals[part] = {connection}
    end
end

-- Sets up protection for the player's character model
local function setupCharacter(character)
if not character then return end

for _, descendant in ipairs(character:GetDescendants()) do
applyProtection(descendant)
end

table.insert(state.Connections, character.DescendantAdded:Connect(applyProtection))

table.insert(state.Connections, character.DescendantRemoving:Connect(function(descendant)
if state.Signals[descendant] then
for _, conn in ipairs(state.Signals[descendant]) do conn:Disconnect() end
state.Signals[descendant] = nil
end
state.Tracked[descendant] = nil
state.Originals[descendant] = nil
end))
end

-- Handle character respawns
local function onCharacterAdded(character)
cleanupAntiKillbrick()
task.wait() -- Wait for character to be fully parented
setupCharacter(character)
end

if localPlayer.Character then
    setupCharacter(localPlayer.Character)
end

table.insert(state.Connections, localPlayer.CharacterAdded:Connect(onCharacterAdded))
table.insert(state.Connections, localPlayer.CharacterRemoving:Connect(cleanupAntiKillbrick))

-- A resilient Stepped loop to enforce the property, as in the original script
table.insert(state.Connections, RunService.Stepped:Connect(function()
if not localPlayer.Character then return end
for part in pairs(state.Tracked) do
    if typeof(part) == "Instance" and part:IsA("BasePart") and part.Parent and part.CanTouch ~= false then
        part.CanTouch = false
    end
end
end))

print("Anti-KillBrick Enabled.")
end

-- Disables the anti-killbrick feature
function Modules.killbrick.Disable()
    cleanupAntiKillbrick()
    print("Anti-KillBrick Disabled.")
end

RegisterCommand({
Name = "antikillbrick",
Aliases = {"antikb"},
Description = "Prevents kill bricks from killing you."
}, function(args)
Modules.killbrick.Enable(args)
end)

RegisterCommand({
Name = "unantikillbrick",
Aliases = {"unantikb"},
Description = "Allows kill bricks to kill you again."
}, function(args)
Modules.killbrick.Disable(args)
end)

--// Tool Modification Commands

--// Persistent Reach Module (V2)
Modules.Reach = {
    State = {
        UI = nil,
        -- This will store the configuration to be re-applied after death.
        -- Example: { toolName = "ClassicSword", partName = "Handle", reachType = "box", reachSize = 15 }
        PersistentConfig = nil
    }
}

function Modules.Reach:_getTool()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
end

-- This is the core logic, now in its own function to be called from multiple places.
function Modules.Reach:_applyReachToPart(part, reachType, size)
    if not part or not part.Parent then
        return DoNotif("Target part for reach is invalid.", 3)
    end
    
    -- Store the original size if it hasn't been stored already.
    if not part:FindFirstChild("OGSize") then
        local originalSize = Instance.new("Vector3Value", part)
        originalSize.Name = "OGSize"
        originalSize.Value = part.Size
    end
    
    -- Apply the new size.
    if reachType == "box" then
        part.Size = Vector3.new(size, size, size)
    else -- "directional"
        part.Size = Vector3.new(part.Size.X, part.Size.Y, size)
    end
    part.Massless = true -- Important for preventing physics glitches.

    -- Visual indicator
    if part:FindFirstChild("ReachIndicator") then part.ReachIndicator:Destroy() end
    local selectionBox = Instance.new("SelectionBox", part)
    selectionBox.Name = "ReachIndicator"
    selectionBox.Adornee = part
    selectionBox.Color3 = Color3.fromRGB(0, 255, 100)
    selectionBox.LineThickness = 0.02
end

function Modules.Reach:Apply(reachType, size)
    if self.State.UI then self.State.UI:Destroy() end
    
    local tool = self:_getTool()
    if not tool then return DoNotif("No tool equipped to modify.", 3) end

    local parts = {}
    for _, p in ipairs(tool:GetDescendants()) do if p:IsA("BasePart") then table.insert(parts, p) end end
    if #parts == 0 then return DoNotif("Equipped tool has no modifiable parts.", 3) end

    -- Create the part selection UI
    local ui = Instance.new("ScreenGui", CoreGui); ui.Name = "ReachPartSelector"; self.State.UI = ui
    local frame = Instance.new("Frame", ui); frame.Size = UDim2.fromOffset(250, 200); frame.Position = UDim2.new(0.5, -125, 0.5, -100); frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45); Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    local title = Instance.new("TextLabel", frame); title.Size = UDim2.new(1, 0, 0, 30); title.BackgroundTransparency = 1; title.Font = Enum.Font.Code; title.Text = "Select a Part for Reach"; title.TextColor3 = Color3.fromRGB(200, 220, 255)
    local scroll = Instance.new("ScrollingFrame", frame); scroll.Size = UDim2.new(1, -20, 1, -40); scroll.Position = UDim2.fromOffset(10, 35); scroll.BackgroundTransparency = frame.BackgroundColor3; scroll.BorderSizePixel = 0; scroll.ScrollBarThickness = 6; local layout = Instance.new("UIListLayout", scroll); layout.Padding = UDim.new(0, 5)

    for _, part in ipairs(parts) do
        local btn = Instance.new("TextButton", scroll); btn.Size = UDim2.new(1, 0, 0, 30); btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65); btn.TextColor3 = Color3.fromRGB(220, 220, 230); btn.Font = Enum.Font.Code; btn.Text = part.Name; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
        btn.MouseButton1Click:Connect(function()
            self:_applyReachToPart(part, reachType, size)
            
            -- SAVE the configuration for persistence.
            self.State.PersistentConfig = {
                toolName = tool.Name,
                partName = part.Name,
                reachType = reachType,
                reachSize = size
            }
            
            DoNotif("Applied " .. reachType .. " reach of " .. size .. " to " .. part.Name, 3)
            DoNotif("This reach setting will now auto-apply on respawn.", 4)
            ui:Destroy()
            self.State.UI = nil
        end)
    end
end

function Modules.Reach:Reset()
    local tool = self:_getTool()
    if not tool then return DoNotif("No tool to reset.", 3) end
    for _, p in ipairs(tool:GetDescendants()) do
        if p:IsA("BasePart") then
            if p:FindFirstChild("OGSize") then
                p.Size = p.OGSize.Value; p.OGSize:Destroy()
            end
            if p:FindFirstChild("ReachIndicator") then p.ReachIndicator:Destroy() end
        end
    end
    DoNotif("Tool reach has been reset for the current session.", 3)
end

function Modules.Reach:Clear()
    self:Reset() -- Also reset the currently held tool.
    self.State.PersistentConfig = nil
    DoNotif("Persistent reach setting cleared. Will not re-apply on respawn.", 4)
end

function Modules.Reach:Initialize()
    -- This sets up the automatic re-application hook.
    LocalPlayer.CharacterAdded:Connect(function(character)
        -- This connection waits for a tool to be added to the new character.
        character.ChildAdded:Connect(function(child)
            if child:IsA("Tool") and self.State.PersistentConfig then
                local config = self.State.PersistentConfig
                -- Check if the newly added tool is the one we want to modify.
                if child.Name == config.toolName then
                    task.wait(0.1) -- Wait a moment for all parts to load inside the tool.
                    local targetPart = child:FindFirstChild(config.partName, true)
                    if targetPart and targetPart:IsA("BasePart") then
                        self:_applyReachToPart(targetPart, config.reachType, config.reachSize)
                        DoNotif("Persistent reach re-applied to " .. targetPart.Name, 3)
                    end
                end
            end
        end)
    end)
end

-- Initialize the persistence system when the script starts.
Modules.Reach:Initialize()

-- Register Commands
RegisterCommand({Name = "reach", Aliases = {}, Description = "Applies directional reach. ;reach [num]"}, function(args) Modules.Reach:Apply("directional", tonumber(args[1]) or 20) end)
RegisterCommand({Name = "boxreach", Aliases = {}, Description = "Applies box reach. ;boxreach [num]"}, function(args) Modules.Reach:Apply("box", tonumber(args[1]) or 20) end)
RegisterCommand({Name = "resetreach", Aliases = {"unreach"}, Description = "Resets reach on the currently held tool."}, function() Modules.Reach:Reset() end)
RegisterCommand({Name = "clearreach", Aliases = {}, Description = "Clears the saved reach setting to stop it from re-applying."}, function() Modules.Reach:Clear() end)
RegisterCommand({Name = "goto", Aliases = {}, Description = "Teleports to a player. ;goto [player]"}, function(args)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer


local inputName = args[1] and tostring(args[1]):lower()
if not inputName or inputName == "" then
    return DoNotif("Specify a player's name.", 3)
end


local exactMatch = nil
local partialMatch = nil


for _, player in ipairs(Players:GetPlayers()) do
    local username = player.Name:lower()
    local displayName = player.DisplayName:lower()


    if username == inputName or displayName == inputName then
        exactMatch = player
        break
    end


    if not partialMatch then
        if username:sub(1, #inputName) == inputName or displayName:sub(1, #inputName) == inputName then
            partialMatch = player
        end
    end
end


local targetPlayer = exactMatch or partialMatch


if targetPlayer then
    local localHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")

    if localHRP and targetHRP then

        localHRP.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)

        DoNotif("Teleported to " .. targetPlayer.Name, 3)
    else
    DoNotif("Target player's character could not be found.", 3)
end
else
DoNotif("Player not found.", 3)
end
end)

Modules.AdvancedFling = {
    State = {
        IsFlinging = false
    }
}

local function findFlingTargets(targetName)
    local targets = {}
    local localPlayer = Players.LocalPlayer
    local lowerTargetName = targetName and targetName:lower() or "nil"

    if not targetName or lowerTargetName == "me" then
        return { localPlayer }
    end

    if lowerTargetName == "all" then
        return Players:GetPlayers()
    end
    
    if lowerTargetName == "others" then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= localPlayer then table.insert(targets, p) end
        end
        return targets
    end

    if lowerTargetName == "random" then
        local allPlayers = Players:GetPlayers()
        if #allPlayers > 0 then
            return { allPlayers[math.random(1, #allPlayers)] }
        end
        return {}
    end
    
    if lowerTargetName == "nearest" then
        local nearestPlayer, minDist = nil, math.huge
        local localRoot = localPlayer.Character and localPlayer.Character.PrimaryPart
        if not localRoot then return {} end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= localPlayer and p.Character and p.Character.PrimaryPart then
                local dist = (p.Character.PrimaryPart.Position - localRoot.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearestPlayer = p
                end
            end
        end
        if nearestPlayer then return { nearestPlayer } end
        return {}
    end

    -- If none of the keywords match, search by player name
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():sub(1, #lowerTargetName) == lowerTargetName then
            table.insert(targets, p)
        end
    end
    
    return targets
end

function Modules.AdvancedFling:Execute(targetPlayer)
    if self.State.IsFlinging then return DoNotif("Fling already in progress.", 2) end

    local localCharacter = LocalPlayer.Character
    local localHumanoid = localCharacter and localCharacter:FindFirstChildOfClass("Humanoid")
    local localRootPart = localHumanoid and localHumanoid.RootPart

    if not (localRootPart and targetPlayer.Character) then
        return DoNotif("Cannot fling: a required character is missing.", 3)
    end
    
    self.State.IsFlinging = true
    local originalPosition = localRootPart.CFrame
    local originalWalkSpeed = localHumanoid.WalkSpeed
    local originalCameraSubject = Workspace.CurrentCamera.CameraSubject
    local originalDestroyHeight = Workspace.FallenPartsDestroyHeight

    task.spawn(function()
        local success, err = pcall(function()
            Workspace.CurrentCamera.CameraSubject = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            Workspace.FallenPartsDestroyHeight = math.huge
            localHumanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
            localHumanoid.WalkSpeed = 0 -- Prevent any self-movement from interfering

            local flingStartTime = tick()
            local timeToFling = 2

            repeat
                local targetCharacter = targetPlayer.Character
                local targetRootPart = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
                
                if not targetRootPart then break end

                -- THE FIX: "Blender Fling" - hit from multiple vectors within the same frame for max power.
                local targetCF = targetRootPart.CFrame
                
                -- Hit 1: Above
                localRootPart.CFrame = targetCF * CFrame.new(0, 3, 0)
                localRootPart.Velocity = Vector3.new(0, 9e8, 0)
                
                -- Hit 2: Below
                localRootPart.CFrame = targetCF * CFrame.new(0, -3, 0)
                localRootPart.Velocity = Vector3.new(0, -9e8, 0)

                -- Hit 3: In Front
                localRootPart.CFrame = targetCF * CFrame.new(0, 0, -3)
                localRootPart.Velocity = targetCF.LookVector * 9e8

                -- Hit 4: Behind
                localRootPart.CFrame = targetCF * CFrame.new(0, 0, 3)
                localRootPart.Velocity = -targetCF.LookVector * 9e8
                
                RunService.Heartbeat:Wait() -- Yield for one frame after the attack volley
                
            until targetRootPart.Velocity.Magnitude > 800
                or not targetPlayer.Parent
                or not targetPlayer.Character
                or (targetPlayer.Character:FindFirstChildOfClass("Humanoid") and targetPlayer.Character:FindFirstChildOfClass("Humanoid").Health <= 0)
                or tick() > flingStartTime + timeToFling

            -- Cleanup
            localHumanoid.WalkSpeed = originalWalkSpeed
            localHumanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            Workspace.CurrentCamera.CameraSubject = localCharacter
            Workspace.FallenPartsDestroyHeight = originalDestroyHeight
            
            repeat
                localRootPart.CFrame = originalPosition
                localRootPart.Velocity, localRootPart.RotVelocity = Vector3.new(), Vector3.new()
                task.wait()
            until (localRootPart.Position - originalPosition.Position).Magnitude < 25 or not self.State.IsFlinging
            
            self.State.IsFlinging = false
            DoNotif("Fling sequence complete.", 2)
        end)
        
        if not success then
            pcall(function()
                localHumanoid.WalkSpeed = originalWalkSpeed
                localHumanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                Workspace.CurrentCamera.CameraSubject = originalCameraSubject
                Workspace.FallenPartsDestroyHeight = originalDestroyHeight
                if localRootPart and localRootPart.Parent then localRootPart.CFrame = originalPosition end
            end)
            self.State.IsFlinging = false
            warn("AdvancedFling Error:", err)
            DoNotif("Fling failed. Target may have reset or left.", 3)
        end
    end)
end

RegisterCommand({ Name = "fling", Aliases = {"push"}, Description = "Fling a player. ;fling <player|all|others|random|nearest>" }, function(args)
    local targetName = args[1]
    local targets = findFlingTargets(targetName)

    if #targets == 0 then
        return DoNotif("No valid target found.", 3)
    end
    
    if #targets > 1 then
        DoNotif("Flinging multiple targets...", 2)
    else
        DoNotif("Target found: " .. targets[1].Name, 2)
    end
    
    for _, targetPlayer in ipairs(targets) do
        if targetPlayer ~= LocalPlayer then
            Modules.AdvancedFling:Execute(targetPlayer)
            task.wait(0.1) -- Stagger multi-flings slightly
        end
    end
end)

Modules.SetSpawnPoint = {
State = {

CustomSpawnCFrame = nil,

CharacterAddedConnection = nil
}
}



function Modules.SetSpawnPoint:OnCharacterAdded(newCharacter)

    if not self.State.CustomSpawnCFrame then return end


    local rootPart = newCharacter:WaitForChild("HumanoidRootPart", 5)

    if rootPart then


        task.wait()
        rootPart.CFrame = self.State.CustomSpawnCFrame
    end
end


RegisterCommand({
Name = "setspawnpoint",
Aliases = {"setspawn", "ssp"},
Description = "Sets your respawn point to your current location. Use 'clear' to reset."
}, function(args)
local localPlayer = Players.LocalPlayer
local commandArg = args[1] and string.lower(args[1])


if commandArg == "clear" or commandArg == "reset" then
    if Modules.SetSpawnPoint.State.CustomSpawnCFrame then
        Modules.SetSpawnPoint.State.CustomSpawnCFrame = nil
        print("Custom spawn point cleared. You will now use the default spawn.")


        if Modules.SetSpawnPoint.State.CharacterAddedConnection then
            Modules.SetSpawnPoint.State.CharacterAddedConnection:Disconnect()
            Modules.SetSpawnPoint.State.CharacterAddedConnection = nil
        end
    else
    print("No custom spawn point was set.")
end
return
end


local character = localPlayer and localPlayer.Character
local rootPart = character and character:FindFirstChild("HumanoidRootPart")

if not rootPart then
    print("Error: Could not set spawn point. Player character not found.")
    return
end


Modules.SetSpawnPoint.State.CustomSpawnCFrame = rootPart.CFrame
print("Custom spawn point set at: " .. tostring(rootPart.Position))



if not Modules.SetSpawnPoint.State.CharacterAddedConnection then
    Modules.SetSpawnPoint.State.CharacterAddedConnection = localPlayer.CharacterAdded:Connect(function(char)
    Modules.SetSpawnPoint:OnCharacterAdded(char)
    end)
end
end)

Modules.NoclipStabilizer = {
    State = {
        Enabled = false,
        Connection = nil
    }
}

function Modules.NoclipStabilizer:_OnStepped()
    -- This function runs every physics frame to cancel out server-side velocity.
    local character = Players.LocalPlayer and Players.LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")

    if rootPart then
        -- By setting Velocity and RotVelocity to zero, we prevent the server from
        -- physically pushing our character around (rubber-banding), while still
        -- allowing our own client-side movement to function as intended.
        rootPart.Velocity = Vector3.new(0, 0, 0)
        rootPart.RotVelocity = Vector3.new(0, 0, 0)
    end
end

function Modules.NoclipStabilizer:Enable()
    if self.State.Enabled then return end
    self.State.Enabled = true

    -- We connect to the 'Stepped' event, which is tied to the physics simulation.
    self.State.Connection = RunService.Stepped:Connect(function()
        self:_OnStepped()
    end)
    
    DoNotif("Noclip Stabilizer: [Enabled]", 3)
end

function Modules.NoclipStabilizer:Disable()
    if not self.State.Enabled then return end
    self.State.Enabled = false

    if self.State.Connection then
        self.State.Connection:Disconnect()
        self.State.Connection = nil
    end

    DoNotif("Noclip Stabilizer: [Disabled]", 3)
end

RegisterCommand({
    Name = "antirubberband",
    Aliases = {"antirb", "arb"},
    Description = "Toggles the Noclip Stabilizer to prevent server-side rubberbanding."
}, function(args)
    if Modules.NoclipStabilizer.State.Enabled then
        Modules.NoclipStabilizer:Disable()
    else
        Modules.NoclipStabilizer:Enable()
    end
end)


Modules.AntiCFrameTeleport = {
    -- Constants are moved inside the module for better encapsulation.
    MAX_SPEED = 70,
    MAX_STEP_DIST = 8,
    REPEAT_THRESHOLD = 3, -- How many detections before a brief lock.
    LOCK_TIME = 0.1,

    State = {
        Enabled = false,
        HeartbeatConnection = nil,
        CharacterAddedConnection = nil,
        
        LastCFrame = nil,
        LastTimestamp = 0,
        DetectionHits = 0
    }
}

function Modules.AntiCFrameTeleport:_zeroVelocity(character)
    -- Sets the velocity of all parts in a character to zero.
    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.AssemblyLinearVelocity = Vector3.zero
            descendant.AssemblyAngularVelocity = Vector3.zero
        end
    end
end

function Modules.AntiCFrameTeleport:_getFlyAllowances(deltaTime)
    -- This function preserves the original script's logic of increasing teleport
    -- detection thresholds when a known flight script is active.
    local maxSpeed, maxDist = self.MAX_SPEED, self.MAX_STEP_DIST
    
    if not (getfenv(0).NAmanage and NAmanage._state and getfenv(0).FLYING) then 
        return maxSpeed, maxDist 
    end

    local mode = NAmanage._state.mode or "none"
    local flyVars = getfenv(0).flyVariables or {}

    if mode == "fly" then
        local speed = tonumber(flyVars.flySpeed) or 1
        local velocity = speed * 50
        maxSpeed = math.max(maxSpeed, velocity * 1.4)
        maxDist = math.max(maxDist, velocity * deltaTime * 3)
    elseif mode == "vfly" then
        local speed = tonumber(flyVars.vFlySpeed) or 1
        local velocity = speed * 50
        maxSpeed = math.max(maxSpeed, velocity * 1.4)
        maxDist = math.max(maxDist, velocity * deltaTime * 3)
    elseif mode == "cfly" then
        local speed = tonumber(flyVars.cFlySpeed) or 1
        local step = speed * 2
        maxDist = math.max(self.MAX_STEP_DIST, step)
        maxSpeed = math.max(self.MAX_SPEED, (maxDist / deltaTime) * 1.25)
    elseif mode == "tfly" then
        local speed = tonumber(flyVars.TflySpeed) or 1
        local step = speed * 2.5
        maxDist = math.max(self.MAX_STEP_DIST, step)
        maxSpeed = math.max(self.MAX_SPEED, (maxDist / deltaTime) * 1.5)
    end
    
    return maxSpeed, maxDist
end

function Modules.AntiCFrameTeleport:_onCharacterAdded(character)
    -- Resets the tracking variables when the player respawns.
    local rootPart = character:WaitForChild("HumanoidRootPart", 5)
    if rootPart then
        self.State.LastCFrame = rootPart.CFrame
        self.State.LastTimestamp = os.clock()
        self.State.DetectionHits = 0
    end
end

function Modules.AntiCFrameTeleport:_onHeartbeat()
    local character = Players.LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")

    if not rootPart then return end

    local now = os.clock()
    local deltaTime = math.max(now - (self.State.LastTimestamp or now), 1/240)
    local currentCFrame = rootPart.CFrame

    if not self.State.LastCFrame then
        self.State.LastCFrame, self.State.LastTimestamp = currentCFrame, now
        return
    end

    local distance = (currentCFrame.Position - self.State.LastCFrame.Position).Magnitude
    local speed = distance / deltaTime
    
    local maxAllowedSpeed, maxAllowedDistance = self:_getFlyAllowances(deltaTime)

    if distance > maxAllowedDistance or speed > maxAllowedSpeed then
        -- Teleport detected, snap the player back.
        character:PivotTo(self.State.LastCFrame)
        self:_zeroVelocity(character)
        self.State.DetectionHits += 1

        if self.State.DetectionHits >= self.REPEAT_THRESHOLD then
            -- After repeated triggers, briefly pause to prevent getting stuck.
            task.delay(self.LOCK_TIME, function()
                self.State.DetectionHits = 0
            end)
        end
    else
        -- No teleport detected, update state for the next frame.
        self.State.DetectionHits = math.max(self.State.DetectionHits - 1, 0)
        self.State.LastCFrame = currentCFrame
    end
    self.State.LastTimestamp = now
end

function Modules.AntiCFrameTeleport:Enable()
    if self.State.Enabled then return end
    self.State.Enabled = true

    if Players.LocalPlayer.Character then
        self:_onCharacterAdded(Players.LocalPlayer.Character)
    end

    self.State.CharacterAddedConnection = Players.LocalPlayer.CharacterAdded:Connect(function(char)
        self:_onCharacterAdded(char)
    end)

    self.State.HeartbeatConnection = RunService.Heartbeat:Connect(function()
        self:_onHeartbeat()
    end)
    
    DoNotif("Anti-CFrame Teleport: [Enabled]", 3)
end

function Modules.AntiCFrameTeleport:Disable()
    if not self.State.Enabled then return end
    self.State.Enabled = false

    if self.State.HeartbeatConnection then
        self.State.HeartbeatConnection:Disconnect()
        self.State.HeartbeatConnection = nil
    end
    
    if self.State.CharacterAddedConnection then
        self.State.CharacterAddedConnection:Disconnect()
        self.State.CharacterAddedConnection = nil
    end

    -- Clear the state variables.
    self.State.LastCFrame = nil
    self.State.LastTimestamp = 0
    self.State.DetectionHits = 0

    DoNotif("Anti-CFrame Teleport: [Disabled]", 3)
end

RegisterCommand({
    Name = "anticframetp",
    Aliases = {"acftp", "antiteleport"},
    Description = "Toggles a client-side anti-teleport to prevent CFrame changes."
}, function(args)
    if Modules.AntiCFrameTeleport.State.Enabled then
        Modules.AntiCFrameTeleport:Disable()
    else
        Modules.AntiCFrameTeleport:Enable()
    end
end)


Modules.Mimic = {
    State = {
        IsEnabled = false,
        TargetPlayer = nil,
        Connections = {},
        --// [CAMERA FIX]: Store original camera properties to restore them perfectly.
        OriginalCameraState = {}
    },
    Config = {
        OFFSET = CFrame.new(0, 0, 0),
        --// [CAMERA FIX]: This CFrame determines the camera's position relative to your character.
        CAMERA_OFFSET = CFrame.new(0, 5, 15) 
    }
}

function Modules.Mimic:_findPlayer(query)
    if not query then return nil end
    query = query:lower()
    local partialMatch = nil
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower() == query then
            return player
        end
        if not partialMatch and player.Name:lower():sub(1, #query) == query then
            partialMatch = player
        end
    end
    return partialMatch
end

function Modules.Mimic:_cleanupConnections()
    for _, conn in pairs(self.State.Connections) do
        conn:Disconnect()
    end
    table.clear(self.State.Connections)
end

function Modules.Mimic:_updatePosition()
    local ourCharacter = LocalPlayer.Character
    local targetCharacter = self.State.TargetPlayer and self.State.TargetPlayer.Character
    local ourHRP = ourCharacter and ourCharacter:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
    
    if not (self.State.IsEnabled and ourHRP and targetHRP and targetHRP.Parent) then
        self:Toggle(nil)
        return
    end

    -- Set character position
    ourHRP.CFrame = targetHRP.CFrame * self.Config.OFFSET
    
    --// [CAMERA FIX]: Manually update the camera's CFrame every frame.
    local camera = Workspace.CurrentCamera
    camera.CFrame = ourHRP.CFrame * self.Config.CAMERA_OFFSET
end

function Modules.Mimic:_watchTarget(targetPlayer)
    local function onCharacterAdded(character)
        if self.State.Connections.StateConnection then
            self.State.Connections.StateConnection:Disconnect()
        end
        local targetHumanoid = character:WaitForChild("Humanoid", 5)
        if targetHumanoid then
            self.State.Connections.StateConnection = targetHumanoid.StateChanged:Connect(function(old, new)
                local ourHumanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if ourHumanoid and new == Enum.HumanoidStateType.Jumping then
                    ourHumanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end

    if targetPlayer.Character then
        onCharacterAdded(targetPlayer.Character)
    end
    self.State.Connections.CharacterAdded = targetPlayer.CharacterAdded:Connect(onCharacterAdded)
end

function Modules.Mimic:Toggle(targetPlayer)
    local camera = Workspace.CurrentCamera

    if self.State.IsEnabled then
        self.State.IsEnabled = false
        self.State.TargetPlayer = nil
        self:_cleanupConnections()
        
        local ourHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if ourHRP then
            ourHRP.Anchored = false
        end

        --// [CAMERA FIX]: Restore the original camera state.
        if self.State.OriginalCameraState.Type then
            camera.CameraType = self.State.OriginalCameraState.Type
        end
        if self.State.OriginalCameraState.Subject then
            camera.CameraSubject = self.State.OriginalCameraState.Subject
        end
        table.clear(self.State.OriginalCameraState)
        
        DoNotif("Mimic Disabled", 2)
        return
    end

    if not targetPlayer then return end

    local ourCharacter = LocalPlayer.Character
    local ourHumanoid = ourCharacter and ourCharacter:FindFirstChildOfClass("Humanoid")
    local ourHRP = ourCharacter and ourCharacter:FindFirstChild("HumanoidRootPart")

    if not (ourHumanoid and ourHRP) then
        DoNotif("Error: Your character is not properly loaded.", 4)
        return
    end

    self.State.IsEnabled = true
    self.State.TargetPlayer = targetPlayer
    ourHRP.Anchored = true
    
    --// [CAMERA FIX]: Save current camera state and switch to scriptable.
    self.State.OriginalCameraState = { Type = camera.CameraType, Subject = camera.CameraSubject }
    camera.CameraType = Enum.CameraMode.Scriptable

    self:_watchTarget(targetPlayer)
    self.State.Connections.Render = RunService.RenderStepped:Connect(function() self:_updatePosition() end)
    self.State.Connections.Died = ourHumanoid.Died:Connect(function()
        DoNotif("Mimic disabled due to death.", 3)
        self:Toggle(nil)
    end)
    
    DoNotif("Mimicking: " .. targetPlayer.Name, 2)
end

RegisterCommand({
    Name = "mimic",
    Aliases = {"attach", "glue"},
    Description = "Glues you to a target player, mimicking their movements. Usage: ;mimic <player>"
}, function(args)
    if #args == 0 then
        if Modules.Mimic.State.IsEnabled then
            Modules.Mimic:Toggle(nil)
        else
            DoNotif("Usage: ;mimic <player_name>", 3)
        end
        return
    end

    local targetName = table.concat(args, " ")
    local targetPlayer = Modules.Mimic:_findPlayer(targetName)

    if targetPlayer == LocalPlayer then
        DoNotif("You cannot mimic yourself.", 3)
        return
    end

    if targetPlayer then
        Modules.Mimic:Toggle(targetPlayer)
    else
        DoNotif("Player not found: " .. targetName, 3)
    end
end)


Modules.SwordBot = {
    State = {
        IsEnabled = false, AutoTarget = false, Target = nil, UI = nil,
        RenderConnection = nil, AutoTargetConnection = nil,
        ToolConnections = {}, bodyGyro = nil, ReachPart = nil
    },
    Config = {
        GyroP = 50000, GyroD = 1000, AttackDistance = 25, StrafeDistance = 10,
        AutoTargetSearchRadius = 80, AutoTargetInterval = 0.25,
        ReachSize = Vector3.new(25, 25, 25)
    }
}

function Modules.SwordBot:_cleanup()
    self.State.IsEnabled = false
    self.State.AutoTarget = false
    self.State.Target = nil

    if self.State.RenderConnection then self.State.RenderConnection:Disconnect(); self.State.RenderConnection = nil end
    if self.State.AutoTargetConnection then task.cancel(self.State.AutoTargetConnection); self.State.AutoTargetConnection = nil end
    if self.State.bodyGyro and self.State.bodyGyro.Parent then self.State.bodyGyro.Parent = nil end
    
    self:_cleanupReach()

    if self.State.UI and self.State.UI.Parent then
        self.State.UI.ToggleBot.Text = "Enable Bot"
        self.State.UI.ToggleBot.BackgroundColor3 = Color3.fromRGB(50, 160, 90)
        self.State.UI.ToggleAuto.Text = "Auto Target [OFF]"
        self.State.UI.ToggleAuto.BackgroundColor3 = Color3.fromRGB(190, 50, 50)
        self.State.UI.Target.Text = "Target: None"
    end
end

--// ... (The rest of the SwordBot functions are identical and correct) ...
--// The original functions _cleanupReach, _scanToolForParts, _applyReach, and _updateLoop are fine.

function Modules.SwordBot:_autoTargetLoop()
    while self.State.IsEnabled and self.State.AutoTarget do
        local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local closestTarget, minDist = nil, self.Config.AutoTargetSearchRadius
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local targetRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot and player.Character.Humanoid.Health > 0 then
                        local dist = (targetRoot.Position - rootPart.Position).Magnitude
                        if dist < minDist then
                            minDist, closestTarget = dist, player.Character
                        end
                    end
                end
            end
            self.State.Target = closestTarget
        end
        task.wait(self.Config.AutoTargetInterval)
    end
end

function Modules.SwordBot:Toggle()
    if self.State.UI and self.State.UI.Parent then
        self.State.UI:Destroy()
        self.State.UI = nil
        self:_cleanup()
        for _, conn in ipairs(self.State.ToolConnections) do conn:Disconnect() end
        table.clear(self.State.ToolConnections)
        return
    end

    --// UI Creation (code is unchanged and correct)
    local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    screenGui.Name = "SwordBot_Polished"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    
    local mainFrame = Instance.new("Frame", screenGui); mainFrame.Size = UDim2.fromOffset(250, 300); mainFrame.Position = UDim2.fromScale(0.5, 0.5); mainFrame.AnchorPoint = Vector2.new(0.5, 0.5); mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40); mainFrame.BackgroundTransparency = 0.15; Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(80, 80, 100)
    local title = Instance.new("TextLabel", mainFrame); title.Size = UDim2.new(1, 0, 0, 40); title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamSemibold; title.Text = "SwordBot Control"; title.TextColor3 = Color3.fromRGB(255, 255, 255); title.TextSize = 20
    local toggleBot = Instance.new("TextButton", mainFrame); toggleBot.Size = UDim2.new(1, -20, 0, 35); toggleBot.Position = UDim2.fromOffset(10, 45); toggleBot.BackgroundColor3 = Color3.fromRGB(50, 160, 90); toggleBot.Font = Enum.Font.GothamBold; toggleBot.Text = "Enable Bot"; toggleBot.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", toggleBot).CornerRadius = UDim.new(0, 6)
    local toggleAuto = Instance.new("TextButton", mainFrame); toggleAuto.Size = UDim2.new(1, -20, 0, 35); toggleAuto.Position = UDim2.fromOffset(10, 85); toggleAuto.BackgroundColor3 = Color3.fromRGB(190, 50, 50); toggleAuto.Font = Enum.Font.GothamBold; toggleAuto.Text = "Auto Target [OFF]"; toggleAuto.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", toggleAuto).CornerRadius = UDim.new(0, 6)
    local targetLabel = Instance.new("TextLabel", mainFrame); targetLabel.Size = UDim2.new(1, -20, 0, 20); targetLabel.Position = UDim2.fromOffset(10, 125); targetLabel.BackgroundTransparency = 1; targetLabel.Font = Enum.Font.Gotham; targetLabel.Text = "Target: None"; targetLabel.TextColor3 = Color3.new(1,1,1); targetLabel.TextXAlignment = Enum.TextXAlignment.Left
    local reachTitle = Instance.new("TextLabel", mainFrame); reachTitle.Size = UDim2.new(1, -20, 0, 20); reachTitle.Position = UDim2.fromOffset(10, 155); reachTitle.BackgroundTransparency = 1; reachTitle.Font = Enum.Font.GothamSemibold; reachTitle.Text = "Box Reach Control"; reachTitle.TextColor3 = Color3.new(1,1,1); reachTitle.TextXAlignment = Enum.TextXAlignment.Left
    local reachPartList = Instance.new("ScrollingFrame", mainFrame); reachPartList.Size = UDim2.new(1, -20, 1, -185); reachPartList.Position = UDim2.fromOffset(10, 180); reachPartList.BackgroundColor3 = Color3.fromRGB(25, 25, 35); reachPartList.BorderSizePixel = 0; reachPartList.ScrollBarThickness = 5; local listLayout = Instance.new("UIListLayout", reachPartList); listLayout.Padding = UDim.new(0, 3)
    
    self.State.UI = { Parent = screenGui, ToggleBot = toggleBot, ToggleAuto = toggleAuto, Target = targetLabel }
    
    toggleBot.MouseButton1Click:Connect(function()
        self.State.IsEnabled = not self.State.IsEnabled
        if self.State.IsEnabled then
            toggleBot.Text = "Disable Bot"; toggleBot.BackgroundColor3 = Color3.fromRGB(190, 50, 50)
            self.State.bodyGyro = Instance.new("BodyGyro"); self.State.bodyGyro.D = self.Config.GyroD; self.State.bodyGyro.P = self.Config.GyroP; self.State.bodyGyro.MaxTorque = Vector3.new(4e8, 4e8, 4e8)
            self.State.RenderConnection = RunService.RenderStepped:Connect(function() self:_updateLoop() end)
            --// [FIX]: Only start the auto target loop if it's already toggled on.
            if self.State.AutoTarget and not self.State.AutoTargetConnection then
                self.State.AutoTargetConnection = task.spawn(function() self:_autoTargetLoop() end)
            end
        else
            self:_cleanup()
        end
    end)
    
    toggleAuto.MouseButton1Click:Connect(function()
        self.State.AutoTarget = not self.State.AutoTarget
        if self.State.AutoTarget then
            toggleAuto.Text = "Auto Target [ON]"; toggleAuto.BackgroundColor3 = Color3.fromRGB(50, 160, 90)
            --// [FIX]: Ensure the master switch is on and that a thread isn't already running.
            if self.State.IsEnabled and not self.State.AutoTargetConnection then
                self.State.AutoTargetConnection = task.spawn(function() self:_autoTargetLoop() end)
            end
        else
            toggleAuto.Text = "Auto Target [OFF]"; toggleAuto.BackgroundColor3 = Color3.fromRGB(190, 50, 50)
            if self.State.AutoTargetConnection then task.cancel(self.State.AutoTargetConnection); self.State.AutoTargetConnection = nil end
            self.State.Target = nil
        end
    end)
    
    local function onToolChanged()
        self:_cleanupReach()
        local character = LocalPlayer.Character
        local tool = character and character:FindFirstChildOfClass("Tool")
        self:_scanToolForParts(tool, reachPartList)
    end
    
    table.insert(self.State.ToolConnections, LocalPlayer.Character.ChildAdded:Connect(onToolChanged))
    table.insert(self.State.ToolConnections, LocalPlayer.Character.ChildRemoved:Connect(onToolChanged))
    onToolChanged()
end

--// Register command is unchanged.
RegisterCommand({
    Name = "swordbot",
    Aliases = {"killaura", "sfbot"},
    Description = "Opens a GUI to control a combat bot with integrated box reach."
}, function()
    Modules.SwordBot:Toggle()
end)


Modules.EditStats = {
    State = {
        UI = nil,
        ActiveOverrides = {},
        HeartbeatConnection = nil,
        IsInitialized = false
    }
}

function Modules.EditStats:_forceProperties()
    -- This core logic is preserved as it's highly effective.
    if not next(self.State.ActiveOverrides) then
        if self.State.HeartbeatConnection then
            self.State.HeartbeatConnection:Disconnect()
            self.State.HeartbeatConnection = nil
        end
        return
    end

    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    for name, data in pairs(self.State.ActiveOverrides) do
        local currentValue = data.IsAttribute and humanoid:GetAttribute(name) or humanoid[name]
        if currentValue ~= data.Value then
            if data.IsAttribute then
                humanoid:SetAttribute(name, data.Value)
            else
                humanoid[name] = data.Value
            end
        end
    end
end

function Modules.EditStats:_createUI()
    if self.State.IsInitialized then return end

    local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    screenGui.Name = "HumanoidEditor_Polished"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    self.State.UI = screenGui

    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.fromOffset(320, 420)
    mainFrame.Position = UDim2.fromScale(0.5, 0.5)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    mainFrame.BackgroundTransparency = 0.15
    mainFrame.ClipsDescendants = true
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(80, 80, 100)
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 55)), ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 40))})
    gradient.Parent = mainFrame

    local title = Instance.new("TextLabel", mainFrame)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamSemibold
    title.Text = "Humanoid Editor"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 20

    local closeButton = Instance.new("TextButton", mainFrame)
    closeButton.Size = UDim2.fromOffset(25, 25); closeButton.AnchorPoint = Vector2.new(1, 0); closeButton.Position = UDim2.new(1, -10, 0, 10); closeButton.BackgroundTransparency = 1; closeButton.Font = Enum.Font.GothamBold; closeButton.Text = "X"; closeButton.TextColor3 = Color3.fromRGB(255, 255, 255); closeButton.TextSize = 20
    closeButton.MouseButton1Click:Connect(function() self:Toggle() end)

    local propertyList = Instance.new("ScrollingFrame", mainFrame)
    propertyList.Size = UDim2.new(1, -20, 1, -50)
    propertyList.Position = UDim2.fromOffset(10, 40)
    propertyList.BackgroundTransparency = 1
    propertyList.BorderSizePixel = 0
    propertyList.ScrollBarThickness = 5
    
    local listLayout = Instance.new("UIListLayout", propertyList)
    listLayout.Padding = UDim.new(0, 5)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- The modern, themed factory for creating a UI row for a stat.
    local function createStatRow(name, value, isAttribute, layoutOrder)
        local rowFrame = Instance.new("Frame", propertyList)
        rowFrame.Size = UDim2.new(1, 0, 0, 35)
        rowFrame.BackgroundTransparency = 1
        rowFrame.LayoutOrder = layoutOrder

        local nameLabel = Instance.new("TextLabel", rowFrame)
        nameLabel.Size = UDim2.new(0.4, -5, 1, 0)
        nameLabel.Font = Enum.Font.Gotham
        nameLabel.Text = name
        nameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.BackgroundTransparency = 1

        local valueBox = Instance.new("TextBox", rowFrame)
        valueBox.Size = UDim2.new(0.3, -5, 1, 0)
        valueBox.Position = UDim2.new(0.4, 0, 0, 0)
        valueBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        valueBox.Font = Enum.Font.Gotham
        valueBox.TextColor3 = Color3.fromRGB(240, 240, 240)
        valueBox.Text = tostring(value)
        Instance.new("UICorner", valueBox).CornerRadius = UDim.new(0, 6)

        local lockButton = Instance.new("TextButton", rowFrame)
        lockButton.Size = UDim2.new(0.3, 0, 1, 0)
        lockButton.Position = UDim2.new(0.7, 5, 0, 0)
        lockButton.Font = Enum.Font.GothamBold
        lockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        lockButton.Text = "Lock"
        lockButton.BackgroundColor3 = Color3.fromRGB(190, 50, 50) -- Red = Unlocked
        Instance.new("UICorner", lockButton).CornerRadius = UDim.new(0, 6)

        lockButton.MouseButton1Click:Connect(function()
            local numValue = tonumber(valueBox.Text)
            if not numValue then return end

            if self.State.ActiveOverrides[name] then
                self.State.ActiveOverrides[name] = nil
                lockButton.BackgroundColor3 = Color3.fromRGB(190, 50, 50); lockButton.Text = "Lock"
            else
                self.State.ActiveOverrides[name] = { Value = numValue, IsAttribute = isAttribute }
                lockButton.BackgroundColor3 = Color3.fromRGB(50, 160, 90); lockButton.Text = "Locked"
                if not self.State.HeartbeatConnection then
                    self.State.HeartbeatConnection = RunService.Heartbeat:Connect(function() self:_forceProperties() end)
                end
            end
        end)
        
        valueBox.FocusLost:Connect(function(enterPressed)
            if not enterPressed then return end
            local newValue = tonumber(valueBox.Text)
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if not (newValue and humanoid) then return end
            
            if isAttribute then humanoid:SetAttribute(name, newValue) else humanoid[name] = newValue end
            if self.State.ActiveOverrides[name] then self.State.ActiveOverrides[name].Value = newValue end
        end)
    end

    local function populateProperties()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        
        for _, child in ipairs(propertyList:GetChildren()) do if not child:IsA("UIListLayout") then child:Destroy() end end
        
        local layoutCounter = 1
        local propertiesToEdit = {"WalkSpeed", "JumpPower", "JumpHeight", "HipHeight", "MaxHealth", "Health"}
        
        for _, propName in ipairs(propertiesToEdit) do
            createStatRow(propName, humanoid[propName], false, layoutCounter)
            layoutCounter = layoutCounter + 1
        end

        for attrName, attrValue in pairs(humanoid:GetAttributes()) do
            if typeof(attrValue) == "number" then
                createStatRow(attrName, attrValue, true, layoutCounter)
                layoutCounter = layoutCounter + 1
            end
        end
    end
    
    -- Superior Dragging Logic
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local dragStart, startPos = input.Position, mainFrame.Position
            local moveConn, endConn
            moveConn = UserInputService.InputChanged:Connect(function(moveInput)
                if moveInput.UserInputType == Enum.UserInputType.MouseMovement then
                    local delta = moveInput.Position - dragStart
                    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
            endConn = UserInputService.InputEnded:Connect(function(endInput)
                if endInput.UserInputType == Enum.UserInputType.MouseButton1 then moveConn:Disconnect(); endConn:Disconnect() end
            end)
        end
    end)
    
    if LocalPlayer.Character then populateProperties() end
    LocalPlayer.CharacterAdded:Connect(function() task.wait(0.5); populateProperties() end)

    self.State.IsInitialized = true
end

function Modules.EditStats:Toggle()
    if not self.State.IsInitialized then
        self:_createUI()
    end
    self.State.UI.Enabled = not self.State.UI.Enabled
end

RegisterCommand({
    Name = "editstats",
    Aliases = {"stats", "humanoideditor", "prop"},
    Description = "Opens a properties window to edit and lock Humanoid stats."
}, function(args)
    Modules.EditStats:Toggle()
end)


--// Zombie Zone Force Equip Module
Modules.ZombieZoneEquipper = {
    State = {
        IsInitialized = false,
        EquipRemote = nil,
        ItemData = nil
    }
}

function Modules.ZombieZoneEquipper:Initialize()
    -- This function runs only once, the first time the command is used.
    if self.State.IsInitialized then return true end

    local success, remote = pcall(function()
        return ReplicatedStorage.events:WaitForChild("equipItem", 5)
    end)
    if not success or not remote then
        DoNotif("Equipper Error: Could not find 'equipItem' remote. Not in Zombie Zone?", 5)
        return false
    end
    self.State.EquipRemote = remote

    local success, data = pcall(function()
        return require(ReplicatedStorage.modules.itemData)
    end)
    if not success or not data then
        DoNotif("Equipper Error: Could not load itemData module.", 5)
        return false
    end
    self.State.ItemData = data

    self.State.IsInitialized = true
    print("Zombie Zone Equipper Initialized Successfully.")
    return true
end

function Modules.ZombieZoneEquipper:FindItemByName(query)
    -- This is a direct, improved port from the original script.
    query = query:lower()
    
    -- First, look for an exact match (case-insensitive)
    for itemName, _ in pairs(self.State.ItemData) do
        if itemName:lower() == query then return itemName end
    end
    
    -- If no exact match, find the first partial match
    for itemName, _ in pairs(self.State.ItemData) do
        if itemName:lower():find(query, 1, true) then return itemName end
    end
    
    return nil
end

function Modules.ZombieZoneEquipper:Execute(itemNameQuery)
    -- First, ensure the module is initialized and ready.
    if not self:Initialize() then return end

    local targetItemName = self:FindItemByName(itemNameQuery)
    
    if targetItemName then
        DoNotif("Found item: " .. targetItemName, 1.5)
        
        -- Use a protected call for the remote invocation itself.
        local success, result = pcall(function()
            return self.State.EquipRemote:InvokeServer(targetItemName)
        end)
        
        if success then
            DoNotif("Force-equipped: " .. targetItemName, 3)
        else
            DoNotif("Remote Error: " .. tostring(result), 5)
        end
    else
        DoNotif("Could not find an item matching '" .. itemNameQuery .. "'.", 3)
    end
end

-- Register the command with your admin system
RegisterCommand({
    Name = "equip",
    Aliases = {"forceequip", "item"},
    Description = "Force equips an item in Zombie Zone. Usage: equip <item_name>"
}, function(args)
    if #args == 0 then
        DoNotif("Usage: ;equip <item name>", 3)
        -- As a helper, list a few known good items from the original script
        DoNotif("Try: Nyx Echo, Revenant-45, or Nekomancer Staff", 5)
        return
    end
    
    -- Join all arguments to handle item names with spaces
    local fullItemName = table.concat(args, " ")
    Modules.ZombieZoneEquipper:Execute(fullItemName)
end)

Modules.FlingProtection = {
    State = {
        IsEnabled = false,
        SteppedConnection = nil,
        PlayerConnections = {} -- Stores connections for PlayerAdded/CharacterAdded
    },
    Config = {
        MAX_VELOCITY_MAGNITUDE = 200,
        -- Define unique names for our collision groups to avoid conflicts
        LOCAL_PLAYER_GROUP = "LocalPlayerCollisionGroup",
        OTHER_PLAYERS_GROUP = "OtherPlayersCollisionGroup"
    }
}

function Modules.FlingProtection:_setCollisionGroupForCharacter(character, groupName)
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            pcall(function() part.CollisionGroup = groupName end)
        end
    end
end

function Modules.FlingProtection:_setupPlayerCollisions()
    local PhysicsService = game:GetService("PhysicsService")

    -- Create the collision groups, wrapped in pcalls in case they already exist
    pcall(function() PhysicsService:CreateCollisionGroup(self.Config.LOCAL_PLAYER_GROUP) end)
    pcall(function() PhysicsService:CreateCollisionGroup(self.Config.OTHER_PLAYERS_GROUP) end)

    -- This is the key: disable collisions between our two new groups
    PhysicsService:CollisionGroupSetCollidable(self.Config.LOCAL_PLAYER_GROUP, self.Config.OTHER_PLAYERS_GROUP, false)

    -- Handle all players currently in the game
    for _, player in ipairs(Players:GetPlayers()) do
        local group = (player == LocalPlayer) and self.Config.LOCAL_PLAYER_GROUP or self.Config.OTHER_PLAYERS_GROUP
        if player.Character then
            self:_setCollisionGroupForCharacter(player.Character, group)
        end
        -- Listen for when their character respawns
        local conn = player.CharacterAdded:Connect(function(character)
            self:_setCollisionGroupForCharacter(character, group)
        end)
        table.insert(self.State.PlayerConnections, conn)
    end

    -- Handle players who join after the script is enabled
    local conn = Players.PlayerAdded:Connect(function(player)
        local group = self.Config.OTHER_PLAYERS_GROUP -- New players are always "others"
        local charConn = player.CharacterAdded:Connect(function(character)
            self:_setCollisionGroupForCharacter(character, group)
        end)
        table.insert(self.State.PlayerConnections, charConn)
    end)
    table.insert(self.State.PlayerConnections, conn)
end

function Modules.FlingProtection:_revertPlayerCollisions()
    -- Disconnect all event listeners to prevent memory leaks
    for _, conn in ipairs(self.State.PlayerConnections) do
        conn:Disconnect()
    end
    self.State.PlayerConnections = {}

    -- Reset all players back to the default collision group
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            self:_setCollisionGroupForCharacter(player.Character, "Default")
        end
    end
end

function Modules.FlingProtection:_enforceStability()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not (hrp and not hrp.Anchored) then return end
    if hrp.AssemblyLinearVelocity.Magnitude > self.Config.MAX_VELOCITY_MAGNITUDE then
        hrp.AssemblyLinearVelocity = Vector3.zero
    end
end

function Modules.FlingProtection:Toggle()
    self.State.IsEnabled = not self.State.IsEnabled

    if self.State.IsEnabled then
        DoNotif("Fling & Player Collision Protection: ENABLED", 2)
        self:_setupPlayerCollisions()
        self.State.SteppedConnection = RunService.Stepped:Connect(function() self:_enforceStability() end)
    else
        DoNotif("Fling & Player Collision Protection: DISABLED", 2)
        self:_revertPlayerCollisions()
        if self.State.SteppedConnection then
            self.State.SteppedConnection:Disconnect()
            self.State.SteppedConnection = nil
        end
    end
end

-- Register the updated command
RegisterCommand({
    Name = "antifling",
    Aliases = {"nofling", "ghost"},
    Description = "Prevents flinging and disables collision with other players."
}, function()
    Modules.FlingProtection:Toggle()
end)


RegisterCommand({
    Name = "fixcam",
    Aliases = {"fix", "unlockcam"},
    Description = "Unlocks camera, allows zooming through walls, and forces third-person."
}, function(args)
    
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")

    if not LocalPlayer then return end

    if isCameraFixed and cameraFixConnection and cameraFixConnection.Connected then
        
        
        cameraFixConnection:Disconnect()
        cameraFixConnection = nil
        
        
        pcall(function()
            if originalOcclusionMode and originalOcclusionMode ~= nil then
                LocalPlayer.DevCameraOcclusionMode = originalOcclusionMode
            end
            if originalMaxZoom and originalMaxZoom ~= nil then
                LocalPlayer.CameraMaxZoomDistance = originalMaxZoom
            end
        end)
        
        isCameraFixed = false
        DoNotif("Camera override disabled.", 3)
    else
        
    
        originalMaxZoom = LocalPlayer.CameraMaxZoomDistance
        originalOcclusionMode = LocalPlayer.DevCameraOcclusionMode
        
        
        LocalPlayer.CameraMaxZoomDistance = 10000 
        
        
        local success, err = pcall(function()
            
            LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.None
        end)

        if not success then
            
            
            LocalPlayer.DevCameraOcclusionMode = 0 
            
            
            warn("Failed to set DevCameraOcclusionMode to Enum.None. Falling back to numeric value 0. Error: " .. tostring(err))
        end
        
        
        cameraFixConnection = RunService.RenderStepped:Connect(function()
            
            if LocalPlayer.CameraMode ~= Enum.CameraMode.Classic then
                LocalPlayer.CameraMode = Enum.CameraMode.Classic
            end
        end)
        
        isCameraFixed = true
        DoNotif("Camera override enabled (with wall-zoom).", 3)
    end
end)


--// Loadstring Commands
local function loadstringCmd(url, notif)
    pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    DoNotif(notif, 3)
end

-- RegisterCommand({Name = "<command_name>", Aliases = {"<alias1>", "<alias2>"}, Description = "<Your Description Here>"}, function() loadstringCmd("URL_HERE", "Notification Message Here") end)
RegisterCommand({Name = "touchfling", Aliases = {"fui"}, Description = "Loads the FLING ui"}, function()
    loadstringCmd("https://raw.githubusercontent.com/miso517/scirpt/refs/heads/main/main.lua", "Fling GUI Loaded")
end)


RegisterCommand({Name = "teleporter", Aliases = {"tpui"}, Description = "Loads the Game Universe."}, function()
    loadstringCmd("https://raw.githubusercontent.com/ltseverydayyou/uuuuuuu/main/Universe%20Viewer", "Universe Initialized")
end)


RegisterCommand({Name = "wallwalk", Aliases = {"ww"}, Description = "Walk On Walls"}, function()
    loadstringCmd("https://raw.githubusercontent.com/ltseverydayyou/uuuuuuu/main/WallWalk.lua", "Script 1 Loaded!")
end)

RegisterCommand({Name = "ragebot", Aliases = {}, Description = "Attachs behind a player and auto attacks, remains out of view."}, function()
    loadstringCmd("https://raw.githubusercontent.com/zukatechdevelopment-ux/thingsandstuff/refs/heads/main/ragebot.lua", "Script 2 Activated!")
end)

RegisterCommand({Name = "dex", Aliases = {}, Description = "The dex explorer."}, function()
    loadstringCmd("https://raw.githubusercontent.com/scriptlisenbe-stack/luaprojectse3/refs/heads/main/CustomDex.lua", "Dex Loading.")
end)

RegisterCommand({Name = "zukahub", Aliases = {"zuka"}, Description = "Loads the Zuka Hub"}, function() loadstringCmd("https://raw.githubusercontent.com/zukatechdevelopment-ux/thingsandstuff/refs/heads/main/ZukaHub.lua", "Loading Zuka's Hub...") end)

RegisterCommand({Name = "lagswitch", Aliases = {"lag"}, Description = "Lag Switcer with a toggle"}, function() loadstringCmd("https://raw.githubusercontent.com/haileybae12/lua3/refs/heads/main/Lag%20switch.lua", "Loading...") end)

RegisterCommand({Name = "blockr", Aliases = {"br"}, Description = "block remotes"}, function() loadstringCmd("https://raw.githubusercontent.com/haileybae12/lua3/refs/heads/main/BlockRemote.lua", "Loading...") end)

RegisterCommand({Name = "stopanimations", Aliases = {"stopa"}, Description = "Stops local animations"}, function() loadstringCmd("https://raw.githubusercontent.com/haileybae12/lua3/refs/heads/main/noanimations.lua", "Loading...") end)

RegisterCommand({Name = "catbypasser", Aliases = {"cat"}, Description = "Loads the Cat Bypasser"}, function() loadstringCmd("https://raw.githubusercontent.com/haileybae12/lua3/refs/heads/main/CatBypasser(Reborn).lua", "Loading...") end)

RegisterCommand({Name = "desync", Aliases = {"invis", "astral"}, Description = "Desyncs local player, making them invisable."}, function() loadstringCmd("https://raw.githubusercontent.com/haileybae12/callumsscript/refs/heads/main/astralform.txt", "Leaving Physical Body..") end)

RegisterCommand({Name = "gamingchair", Aliases = {"gc"}, Description = "The best aimbot."}, function() loadstringCmd("https://raw.githubusercontent.com/haileybae12/callumsscript/refs/heads/main/gamingchairmain.lua", "Gaming Chair Loaded.") end)

RegisterCommand({Name = "zgui", Aliases = {"upd3", "zui"}, Description = "For Zombie Game upd3"}, function() loadstringCmd("https://raw.githubusercontent.com/zukatechdevelopment-ux/luaprojectse3/refs/heads/main/ZGUI.txt", "Loaded GUI") end)

RegisterCommand({Name = "reload", Aliases = {"update", "exec"}, Description = "Reloads and re-executes the admin script from the GitHub source."}, function() loadstringCmd("https://raw.githubusercontent.com/haileybae12/callumsscript/refs/heads/main/Main.lua", "Reloading admin from source...") end)

RegisterCommand({ Name = "zoneui", Aliases = {"guns"}, Description = "Loads the Best Gun Giver for Zombie Zone" }, function() loadstringCmd("https://raw.githubusercontent.com/haileybae12/callumsscript/refs/heads/main/ZombieZone.lua", "Loaded") end) 

RegisterCommand({Name = "ibtools", Aliases = {"btools"}, Description = "Upgraded Gui For Btools"}, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/PublicReleaseLua/refs/heads/main/ibtools.lua", "Loading Revamped Btools Gui") end)

RegisterCommand({Name = "rspy", Aliases = {"spy"}, Description = "Remote Functions"}, function() loadstringCmd("https://raw.githubusercontent.com/ltseverydayyou/uuuuuuu/main/simplee%20spyyy%20mobilee", "Loading SimpleSpy...") end)

RegisterCommand({Name = "nocooldown", Aliases = {"ncd"}, Description = "Disables Cooldowns for a specfic game."}, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/PublicReleaseLua/refs/heads/main/NocooldownsZombieUpd3.txt", "Loading Cooldownremover...") end)

RegisterCommand({Name = "oldsync", Aliases = {}, Description = "OP Works on some games.."}, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/PublicReleaseLua/refs/heads/main/soulform.lua", "Loading Invis Mode Use G and H for toggle...") end)

--// Finalization
function processCommand(message)
    if not message:sub(1, #Prefix) == Prefix then return false end
    local args = {}
    for word in message:sub(#Prefix + 1):gmatch("%S+") do table.insert(args, word) end
    if #args == 0 then return true end
    local cmdName = table.remove(args, 1):lower()
    local cmdFunc = Commands[cmdName]
    if cmdFunc then
        local success, err = pcall(cmdFunc, args)
        if not success then warn("Command Error:", err); DoNotif("Error: " .. tostring(err), 5) end
    else
        DoNotif("Unknown command: " .. cmdName, 3)
    end
    return true
end

Modules.CommandBar:Initialize()
Modules.CommandList:Initialize()

local TextChatService
local success = pcall(function() TextChatService = game:GetService("TextChatService") end)
if success and TextChatService then
    TextChatService.OnSendingMessage = function(message)
        if processCommand(message.Text) then return nil end
        return {}
    end
else
    LocalPlayer.Chatted:Connect(processCommand)
end

DoNotif("ZukaHub Initialized. Press ; to open.", 3)
