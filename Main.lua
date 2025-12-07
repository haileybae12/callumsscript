local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TextChatService = game:GetService("TextChatService")
local TeleportService = game:GetService("TeleportService")
local TextService = game:GetService("TextService")
local PhysicsService = game:GetService("PhysicsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
do
    local THEME = {
    Title = "Success..",
    Subtitle = "Loading Zuka Tech...",
    IconAssetId = "rbxassetid://7243158473",
    BackgroundColor = Color3.fromRGB(20, 20, 25),
    AccentColor = Color3.fromRGB(0, 255, 255),
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
    icon.ImageTransparency = 1
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
    TweenService:Create(icon, tweenInfoOut, { ImageTransparency = 1 }),
    TweenService:Create(title, tweenInfoOut, { TextTransparency = 1 }),
    TweenService:Create(subtitle, tweenInfoOut, { TextTransparency = 1 })
    }
    for _, tween in ipairs(fadeInTweens) do
        tween:Play()
    end
    task.wait(THEME.FadeInTime + THEME.HoldTime)
    for _, tween in ipairs(fadeOutTweens) do
        tween:Play()
    end
    fadeOutTweens[1].Completed:Wait()
    splashGui:Destroy()
end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Utilities = {}
function Utilities.findPlayer(inputName)
    local input = tostring(inputName):lower()
    if input == "" then return nil end
        local exactMatch = nil
        local partialMatch = nil
        if input == "me" then return Players.LocalPlayer end
            for _, player in ipairs(Players:GetPlayers()) do
                local username = player.Name:lower()
                local displayName = player.DisplayName:lower()
                if username == input or displayName == input then
                    exactMatch = player
                    break
                end
                if not partialMatch then
                    if username:sub(1, #input) == input or displayName:sub(1, #input) == input then
                        partialMatch = player
                    end
                end
            end
            return exactMatch or partialMatch
        end
        local Prefix = ";"
        local Commands = {}
        local CommandInfo = {}
        local Modules = {}
        local NotificationManager = {}
        do
            local queue = {}
            local isActive = false
            local tweenService = game:GetService("TweenService")
            local coreGui = game:GetService("CoreGui")
            local textService = game:GetService("TextService")
            local notifGui = Instance.new("ScreenGui", coreGui)
            notifGui.Name = "ZukaNotifGui_v2"
            notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
            notifGui.ResetOnSpawn = false
            local function processNext()
            if isActive or #queue == 0 then
                return
            end
            isActive = true
            local data = table.remove(queue, 1)
            local text, duration = data[1], data[2]
            local notif = Instance.new("TextLabel")
            notif.Font = Enum.Font.GothamSemibold
            notif.TextSize = 12
            notif.Text = text
            notif.TextWrapped = true
            notif.Size = UDim2.fromOffset(300, 0)
            local textBounds = textService:GetTextSize(notif.Text, notif.TextSize, notif.Font, Vector2.new(notif.Size.X.Offset, 1000))
            local verticalPadding = 20
            notif.Size = UDim2.fromOffset(300, textBounds.Y + verticalPadding)
            notif.Position = UDim2.new(0.5, -150, 0, -60)
            notif.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            notif.TextColor3 = Color3.fromRGB(255, 255, 255)
            local corner = Instance.new("UICorner", notif)
            corner.CornerRadius = UDim.new(0, 6)
            local stroke = Instance.new("UIStroke", notif)
            stroke.Color = Color3.fromRGB(80, 80, 100)
            notif.Parent = notifGui
            local tweenInfoIn = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            local tweenInfoOut = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            local goalIn = { Position = UDim2.new(0.5, -150, 0, 10) }
            local goalOut = { Position = UDim2.new(0.5, -150, 0, -60) }
            local inTween = tweenService:Create(notif, tweenInfoIn, goalIn)
            inTween:Play()
            inTween.Completed:Wait()
            task.wait(duration)
            local outTween = tweenService:Create(notif, tweenInfoOut, goalOut)
            outTween:Play()
            outTween.Completed:Wait()
            notif:Destroy()
            isActive = false
            task.spawn(processNext)
        end
        function NotificationManager.Send(text, duration)
            table.insert(queue, {tostring(text), duration or 1})
            task.spawn(processNext)
        end
    end
    function DoNotif(text, duration)
        NotificationManager.Send(text, duration)
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
        mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        mainFrame.BackgroundTransparency = 0.15
        mainFrame.BorderSizePixel = 0
        mainFrame.ClipsDescendants = true
        mainFrame.Parent = ui
        Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(80, 80, 100)
        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 55)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 40))
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
        local function drag(input)
        local dragStart = input.Position
        local startPos = mainFrame.Position
        local moveConn, endConn
        moveConn = UserInputService.InputChanged:Connect(function(moveInput)
        if moveInput.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = moveInput.Position - dragStart
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
print("Command List Loaded, We're so back.")
end
function Modules.CommandList:Populate()
    local scrollingFrame = self.State.UI.MainFrame:FindFirstChild("ScrollingFrame")
    if not scrollingFrame then return end
        local TextService = game:GetService("TextService")
        scrollingFrame:ClearAllChildren()
        local listLayout = Instance.new("UIListLayout", scrollingFrame)
        listLayout.Padding = UDim.new(0, 8)
        table.sort(CommandInfo, function(a, b) return a.Name < b.Name end)
        local totalHeight = 0
        local textBoundsWidth = scrollingFrame.AbsoluteSize.X - 11
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
            "<b><font color='#00FFFF'>;%s</font></b> %s\n<font size='17' color='#DDDDDD'>%s</font>",
            info.Name, aliases, description
            )
            entry.Text = richTextString
            local requiredSize = TextService:GetTextSize(richTextString, 14, entry.Font, Vector2.new(textBoundsWidth, 2000))
            local textHeight = requiredSize.Y + 3
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
                local anim = TweenService:Create(self.State.Container, tweenInfo, {
                Position = UDim2.fromScale(0.5, 0.8),
                BackgroundTransparency = 1
                })
                anim:Play()
                self.State.TextBox:CaptureFocus()
                task.spawn(function()
                task.wait()
                if self.State.IsEnabled then
                    self.State.TextBox.Text = ""
                end
            end)
            anim.Completed:Connect(function()
            self.State.IsAnimating = false
        end)
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
        container.BackgroundTransparency = 1.5
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
        textBox.PlaceholderText = "type here"
        textBox.PlaceholderColor3 = Theme.PlaceholderTextColor
        textBox.TextColor3 = Theme.InputTextColor
        textBox.TextSize = 18
        textBox.ClearTextOnFocus = true
        textBox.Parent = inputFrame
        self.State.TextBox = textBox
        local function createLine(anchor)
        local line = Instance.new("Frame")
        line.Name = anchor .. "Line"
        line.AnchorPoint = Vector2.new(anchor == "Left" and 1 or 0, 0.5)
        line.Position = UDim2.new(0.5, anchor == "Left" and -155 or 155, 0.5, 0)
        line.Size = UDim2.new(0.2, 0, 0, 2)
        line.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        line.BorderSizePixel = 0
        line.Parent = container
        local gradient = Instance.new("UIGradient")
        gradient.Rotation = anchor == "Left" and 180 or 0
        gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 1)
        })
        gradient.Parent = line
    end
    createLine("Left")
    createLine("Right")
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
local MAX_SUGGESTIONS = 5
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
            local UserInputService = game:GetService("UserInputService")
            local Workspace = game:GetService("Workspace")
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            if self.State.IsActive then
                self.State.Connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                        local camera = Workspace.CurrentCamera
                        local mousePos = UserInputService:GetMouseLocation()
                        local ray = camera:ViewportPointToRay(mousePos.X, mousePos.Y)
                        local params = RaycastParams.new()
                        params.FilterType = Enum.RaycastFilterType.Blacklist
                        params.FilterDescendantsInstances = {LocalPlayer.Character}
                        local result = Workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
                        if result and result.Position then
                            hrp.CFrame = CFrame.new(result.Position) + Vector3.new(0, 3, 0)
                        end
                    end
                end)
                DoNotif("Click TP Enabled", 2)
            else
            if self.State.Connection then
                self.State.Connection:Disconnect()
                self.State.Connection = nil
            end
            DoNotif("Click TP Disabled", 2)
        end
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
                local self = self
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
                            Connections = {}
                            }
                            }
                            function Modules.NoClip:_apply(character)
                                if not character then return end
                                    if self.State.Connections[character] then
                                        self.State.Connections[character]:Disconnect()
                                        self.State.Connections[character] = nil
                                    end
                                    for _, part in ipairs(character:GetDescendants()) do
                                        if part:IsA("BasePart") then
                                            part.CanCollide = false
                                        end
                                    end
                                    self.State.Connections[character] = character.DescendantAdded:Connect(function(descendant)
                                    if descendant:IsA("BasePart") then
                                        descendant.CanCollide = false
                                    end
                                end)
                            end
                            function Modules.NoClip:_revert(character)
                                if not character then return end
                                    if self.State.Connections[character] then
                                        self.State.Connections[character]:Disconnect()
                                        self.State.Connections[character] = nil
                                    end
                                    for _, part in ipairs(character:GetDescendants()) do
                                        if part:IsA("BasePart") then
                                            part.CanCollide = true
                                        end
                                    end
                                end
                                function Modules.NoClip:Toggle()
                                    local state = self.State
                                    state.IsActive = not state.IsActive
                                    local LocalPlayer = game:GetService("Players").LocalPlayer
                                    if state.IsActive then
                                        if LocalPlayer.Character then
                                            self:_apply(LocalPlayer.Character)
                                        end
                                        state.Connections.CharAdded = LocalPlayer.CharacterAdded:Connect(function(char) self:_apply(char) end)
                                        state.Connections.CharRemoving = LocalPlayer.CharacterRemoving:Connect(function(char) self:_revert(char) end)
                                        DoNotif("NoClip Enabled", 2)
                                    else
                                    if state.Connections.CharAdded then state.Connections.CharAdded:Disconnect() end
                                        if state.Connections.CharRemoving then state.Connections.CharRemoving:Disconnect() end
                                            if LocalPlayer.Character then
                                                self:_revert(LocalPlayer.Character)
                                            end
                                            for char, conn in pairs(state.Connections) do
                                                if type(conn) == "RBXScriptConnection" then conn:Disconnect() end
                                                end
                                                table.clear(state.Connections)
                                                DoNotif("NoClip Disabled", 2)
                                            end
                                        end
                                        RegisterCommand({ Name = "noclip", Aliases = {"nc"}, Description = "Allows you to fly through walls and objects." }, function()
                                        Modules.NoClip:Toggle()
                                    end)
                                    Modules.AnimationFreezer = {
                                    State = {
                                    IsEnabled = false,
                                    CharacterConnection = nil,
                                    Originals = {}
                                    }
                                    }
                                    function Modules.AnimationFreezer:_applyFreeze(character)
                                        if not character or self.State.Originals[character] then return end
                                            local humanoid = character:FindFirstChildOfClass("Humanoid")
                                            if not humanoid then return end
                                                local animator = humanoid:FindFirstChildOfClass("Animator")
                                                if not animator then return end
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
                                                    local animatorProxy = {}
                                                    local animatorMetatable = {
                                                    __index = function(t, key)
                                                    if tostring(key):lower() == "loadanimation" then
                                                        return function()
                                                        return fakeAnimationTrack
                                                    end
                                                else
                                                return self.State.Originals[character][key]
                                            end
                                        end
                                        }
                                        setmetatable(animatorProxy, animatorMetatable)
                                        animator.Parent = nil
                                        animatorProxy.Name = "Animator"
                                        animatorProxy.Parent = humanoid
                                    end
                                    function Modules.AnimationFreezer:_removeFreeze(character)
                                        if not character or not self.State.Originals[character] then return end
                                            local humanoid = character:FindFirstChildOfClass("Humanoid")
                                            if not humanoid then return end
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
                                                            if LocalPlayer.Character then
                                                                self:_applyFreeze(LocalPlayer.Character)
                                                            end
                                                            self.State.CharacterConnection = LocalPlayer.CharacterAdded:Connect(function(character)
                                                            task.wait(0.1)
                                                            self:_applyFreeze(character)
                                                        end)
                                                    else
                                                    DoNotif("Animation Freezer Disabled", 2)
                                                    if LocalPlayer.Character then
                                                        self:_removeFreeze(LocalPlayer.Character)
                                                    end
                                                    if self.State.CharacterConnection then
                                                        self.State.CharacterConnection:Disconnect()
                                                        self.State.CharacterConnection = nil
                                                    end
                                                    for char, animator in pairs(self.State.Originals) do
                                                        self:_removeFreeze(char)
                                                    end
                                                end
                                            end
                                            RegisterCommand({
                                            Name = "freezeanim",
                                            Aliases = {"noanim", "fa"},
                                            Description = "Freezes all local character animations to skip delays (e.g., weapon swings)."
                                            }, function()
                                            Modules.AnimationFreezer:Toggle()
                                        end)
                                        Modules.AutoDecompiler = {
                                        State = {
                                        IsEnabled = false,
                                        IsReady = false,
                                        Connections = {},
                                        LastAPICall = 0
                                        },
                                        API_URL = "http://api.plusgiant5.com"
                                        }
                                        function Modules.AutoDecompiler:_prepareDecompiler()
                                            if self.State.IsReady then return true end
                                                if not getscriptbytecode or not request then
                                                    warn("AutoDecompiler Error: 'getscriptbytecode' and/or 'request' are not available in this environment.")
                                                    return false
                                                end
                                                print("AutoDecompiler: Executor dependencies found. Ready.")
                                                self.State.IsReady = true
                                                return true
                                            end
                                            function Modules.AutoDecompiler:_decompileViaAPI(scriptObject)
                                                local success, bytecode = pcall(getscriptbytecode, scriptObject)
                                                if not success then
                                                    warn("AutoDecompiler:", scriptObject:GetFullName(), "- Failed to get bytecode:", tostring(bytecode))
                                                    return nil
                                                end
                                                local timeElapsed = os.clock() - self.State.LastAPICall
                                                if timeElapsed < 0.5 then
                                                    task.wait(0.5 - timeElapsed)
                                                end
                                                local success, httpResult = pcall(request, {
                                                Url = self.API_URL .. "/konstant/decompile",
                                                Body = bytecode,
                                                Method = "POST",
                                                Headers = { ["Content-Type"] = "text/plain" }
                                                })
                                                self.State.LastAPICall = os.clock()
                                                if not success then
                                                    warn("AutoDecompiler: request() function failed:", tostring(httpResult))
                                                    return nil
                                                end
                                                if httpResult and httpResult.StatusCode == 200 then
                                                    return httpResult.Body
                                                else
                                                warn("AutoDecompiler: API returned non-200 status:", httpResult.StatusCode, httpResult.Body)
                                                return nil
                                            end
                                        end
                                        function Modules.AutoDecompiler:Disable()
                                            DoNotif("Auto Decompiler Disabled.", 3)
                                            for _, connection in ipairs(self.State.Connections) do
                                                if connection.Connected then
                                                    connection:Disconnect()
                                                end
                                            end
                                            table.clear(self.State.Connections)
                                        end
                                        function Modules.AutoDecompiler:Enable()
                                            if not self:_prepareDecompiler() then
                                                DoNotif("Decompiler dependencies not met. Check console.", 5)
                                                self.State.Enabled = false
                                                return
                                            end
                                            DoNotif("Auto Decompiler Enabled. Sweeping existing scripts...", 4)
                                            local function processScript(script)
                                            local decompiledSource = self:_decompileViaAPI(script)
                                            if decompiledSource then
                                                local success, err = pcall(function() script.Source = decompiledSource end)
                                                if not success then
                                                    warn("Could not set source for", script:GetFullName(), "- it may be read-only. Error:", err)
                                                end
                                            end
                                        end
                                        task.spawn(function()
                                        for _, descendant in ipairs(game:GetDescendants()) do
                                            if descendant:IsA("LuaSourceContainer") then
                                                processScript(descendant)
                                                task.wait()
                                            end
                                        end
                                        print("Initial script sweep completed.")
                                    end)
                                    local conn = game.DescendantAdded:Connect(function(descendant)
                                    if descendant:IsA("LuaSourceContainer") then
                                        print("New script detected:", descendant:GetFullName())
                                        processScript(descendant)
                                    end
                                end)
                                table.insert(self.State.Connections, conn)
                            end
                            function Modules.AutoDecompiler:Toggle()
                                self.State.Enabled = not self.State.Enabled
                                if self.State.Enabled then
                                    self:Enable()
                                else
                                self:Disable()
                            end
                        end
                        function Modules.AutoDecompiler:Initialize()
                            local module = self
                            RegisterCommand({
                            Name = "autodecompile",
                            Aliases = {"adecompile", "decompile"},
                            Description = "Automatically decompiles scripts using a bytecode API."
                            }, function(args)
                            module:Toggle()
                        end)
                    end
                    local Players = game:GetService("Players")
                    local RunService = game:GetService("RunService")
                    Modules.RespawnAtDeath = {
                    State = {
                    Enabled = false,
                    LastDeathCFrame = nil,
                    DiedConnection = nil,
                    CharacterConnection = nil,
                    }
                    }
                    function Modules.RespawnAtDeath.OnDied()
                        local character = Players.LocalPlayer.Character
                        local root = character and character:FindFirstChild("HumanoidRootPart")
                        if root then
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
                                local originalAnchored = root.Anchored
                                root.Anchored = true
                                root.CFrame = deathCFrame
                                RunService.Heartbeat:Wait()
                                root.Anchored = originalAnchored
                                Modules.RespawnAtDeath.State.LastDeathCFrame = nil
                                print("Teleport successful.")
                            end)()
                        end
                    end
                    function Modules.RespawnAtDeath.Toggle()
                        local localPlayer = Players.LocalPlayer
                        Modules.RespawnAtDeath.State.Enabled = not Modules.RespawnAtDeath.State.Enabled
                        if Modules.RespawnAtDeath.State.Enabled then
                            print("Respawn at Death: ENABLED")
                            Modules.RespawnAtDeath.State.CharacterConnection = localPlayer.CharacterAdded:Connect(Modules.RespawnAtDeath.OnCharacterAdded)
                            if localPlayer.Character then
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
        local self = self
        self.State.Enabled = true
        self.State.LastClickTime = 0
        self.State.Connection = RunService.Heartbeat:Connect(function()
        self:AttackLoop()
    end)
    DoNotif("Auto-Attack: [Enabled] | Delay: " .. self.State.ClickDelay * 1000 .. "ms", 2)
end
function Modules.AutoAttack:Disable()
    self.State.Enabled = false
    if self.State.Connection then
        self.State.Connection:Disconnect()
        self.State.Connection = nil
    end
    DoNotif("Auto-Attack: [Disabled]", 2)
end
RegisterCommand({
Name = "autoattack",
Aliases = {"aut", "autoclick"},
Description = "Toggles auto-click. Usage: autoattack [delay_in_ms]"
}, function(args)
local newDelay = tonumber(args[1])
if newDelay and newDelay > 0 then
    Modules.AutoAttack.State.ClickDelay = newDelay / 1000
    if Modules.AutoAttack.State.Enabled then
        DoNotif("Auto-Attack Delay Updated: " .. newDelay .. "ms", 2)
    end
end
if not newDelay then
    if Modules.AutoAttack.State.Enabled then
        Modules.AutoAttack:Disable()
    else
    Modules.AutoAttack:Enable()
end
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
local function cleanupAntiKillbrick()
local state = Modules.killbrick.State
for _, conn in ipairs(state.Connections) do
    if conn and typeof(conn.Disconnect) == "function" then
        conn:Disconnect()
    end
end
table.clear(state.Connections)
for _, signalTable in pairs(state.Signals) do
    if signalTable then
        for _, conn in ipairs(signalTable) do
            if conn and typeof(conn.Disconnect) == "function" then
                conn:Disconnect()
            end
        end
    end
end
for part, originalValue in pairs(state.Originals) do
    if typeof(part) == "Instance" and part:IsA("BasePart") then
        part.CanTouch = (originalValue == nil) or originalValue
    end
end
table.clear(state.Signals)
table.clear(state.Tracked)
table.clear(state.Originals)
end
function Modules.killbrick.Enable()
    cleanupAntiKillbrick()
    local state = Modules.killbrick.State
    local localPlayer = Players.LocalPlayer
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
local function onCharacterAdded(character)
cleanupAntiKillbrick()
task.wait()
setupCharacter(character)
end
if localPlayer.Character then
    setupCharacter(localPlayer.Character)
end
table.insert(state.Connections, localPlayer.CharacterAdded:Connect(onCharacterAdded))
table.insert(state.Connections, localPlayer.CharacterRemoving:Connect(cleanupAntiKillbrick))
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
Modules.FlingProtection = {
State = {
IsEnabled = false,
SteppedConnection = nil,
PlayerConnections = {}
},
Config = {
MAX_VELOCITY_MAGNITUDE = 200,
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
        pcall(function() PhysicsService:CreateCollisionGroup(self.Config.LOCAL_PLAYER_GROUP) end)
        pcall(function() PhysicsService:CreateCollisionGroup(self.Config.OTHER_PLAYERS_GROUP) end)
        PhysicsService:CollisionGroupSetCollidable(self.Config.LOCAL_PLAYER_GROUP, self.Config.OTHER_PLAYERS_GROUP, false)
        for _, player in ipairs(Players:GetPlayers()) do
            local group = (player == LocalPlayer) and self.Config.LOCAL_PLAYER_GROUP or self.Config.OTHER_PLAYERS_GROUP
            if player.Character then
                self:_setCollisionGroupForCharacter(player.Character, group)
            end
            local conn = player.CharacterAdded:Connect(function(character)
            self:_setCollisionGroupForCharacter(character, group)
        end)
        table.insert(self.State.PlayerConnections, conn)
    end
    local conn = Players.PlayerAdded:Connect(function(player)
    local group = self.Config.OTHER_PLAYERS_GROUP
    local charConn = player.CharacterAdded:Connect(function(character)
    self:_setCollisionGroupForCharacter(character, group)
end)
table.insert(self.State.PlayerConnections, charConn)
end)
table.insert(self.State.PlayerConnections, conn)
end
function Modules.FlingProtection:_revertPlayerCollisions()
    for _, conn in ipairs(self.State.PlayerConnections) do
        conn:Disconnect()
    end
    self.State.PlayerConnections = {}
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
RegisterCommand({
Name = "antifling",
Aliases = {"nofling", "anf"},
Description = "Prevents flinging and disables collision with other players."
}, function()
Modules.FlingProtection:Toggle()
end)
Modules.Reach = {
Connections = {},
State = {
IsEnabled = false,
ActiveTool = nil,
ModifiedPart = nil,
PersistentToolName = nil,
PersistentPartName = nil,
ReachType = nil,
ReachSize = nil,
UI = {
ScreenGui = nil,
Frame = nil,
ScrollingFrame = nil,
CloseButton = nil
}
}
}
local ATTRIBUTE_OG_SIZE = "OriginalSize"
local SELECTION_BOX_NAME = "ReachSelectionBox"
function Modules.Reach:_updatePartModification(part, newSize, reachType)
    if not part or not part.Parent then return end
        local originalSize = part:GetAttribute(ATTRIBUTE_OG_SIZE)
        if not newSize then
            if originalSize then
                part.Size = originalSize
                part:SetAttribute(ATTRIBUTE_OG_SIZE, nil)
            end
            if part:FindFirstChild(SELECTION_BOX_NAME) then
                part[SELECTION_BOX_NAME]:Destroy()
            end
            return
        end
        if not originalSize then
            part:SetAttribute(ATTRIBUTE_OG_SIZE, part.Size)
        end
        local selectionBox = part:FindFirstChild(SELECTION_BOX_NAME)
        if not selectionBox then
            selectionBox = Instance.new("SelectionBox", part)
            selectionBox.Name = SELECTION_BOX_NAME
            selectionBox.Adornee = part
            selectionBox.LineThickness = 0.02
        end
        selectionBox.Color3 = reachType == "box" and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(255, 0, 0)
        if reachType == "box" then
            part.Size = Vector3.one * newSize
        else
        part.Size = Vector3.new(part.Size.X, part.Size.Y, newSize)
    end
    part.Massless = true
end
function Modules.Reach:_populatePartSelector()
    local self = Modules.Reach
    local scroll = self.State.UI.ScrollingFrame
    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    if not self.State.ActiveTool then return end
        local parts = {}
        for _, descendant in ipairs(self.State.ActiveTool:GetDescendants()) do
            if descendant:IsA("BasePart") then
                table.insert(parts, descendant)
            end
        end
        if #parts == 0 then
            DoNotif("Equipped tool has no physical parts.", 3)
            return
        end
        for _, part in ipairs(parts) do
            local btn = Instance.new("TextButton", scroll)
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
            btn.TextColor3 = Color3.fromRGB(220, 220, 230)
            btn.Font = Enum.Font.Code
            btn.Text = part.Name
            btn.TextSize = 14
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
            btn.MouseButton1Click:Connect(function()
            if not part or not part.Parent or not self.State.ActiveTool then
                self.State.UI.ScreenGui.Enabled = false
                return DoNotif("The selected part or tool no longer exists.", 3)
            end
            self.State.PersistentToolName = self.State.ActiveTool.Name
            self.State.PersistentPartName = part.Name
            if self.State.ModifiedPart and self.State.ModifiedPart ~= part then
                self:_updatePartModification(self.State.ModifiedPart)
            end
            self.State.IsEnabled = true
            self.State.ModifiedPart = part
            self:_updatePartModification(part, self.State.ReachSize, self.State.ReachType)
            self.State.UI.ScreenGui.Enabled = false
            DoNotif("Persistently set reach for " .. part.Name .. " on " .. self.State.PersistentToolName, 3)
        end)
    end
end
function Modules.Reach:_onToolEquipped(tool)
    local self = Modules.Reach
    self.State.ActiveTool = tool
    self:_populatePartSelector()
    if self.Connections.Unequipped then self.Connections.Unequipped:Disconnect() end
        self.Connections.Unequipped = tool.Unequipped:Connect(function()
        self.State.ActiveTool = nil
        self.State.UI.ScreenGui.Enabled = false
    end)
end
function Modules.Reach:_onCharacterAdded(character)
    local self = Modules.Reach
    if self.State.PersistentToolName and self.State.PersistentPartName then
        local function reapplyModification(tool)
        if tool and tool.Name == self.State.PersistentToolName then
            local part = tool:WaitForChild(self.State.PersistentPartName, 5)
            if part then
                self:_updatePartModification(part, self.State.ReachSize, self.State.ReachType)
                self.State.ModifiedPart = part
                self.State.IsEnabled = true
            end
        end
    end
    local equippedTool = character:FindFirstChild(self.State.PersistentToolName)
    reapplyModification(equippedTool)
    character.ChildAdded:Connect(function(child)
    if child:IsA("Tool") then
        reapplyModification(child)
    end
end)
end
character.ChildAdded:Connect(function(child)
if child:IsA("Tool") then self:_onToolEquipped(child) end
end)
local firstEquippedTool = character:FindFirstChildOfClass("Tool")
if firstEquippedTool then self:_onToolEquipped(firstEquippedTool) end
end
function Modules.Reach:Apply(reachType, size)
    local self = Modules.Reach
    if not self.State.ActiveTool then
        return DoNotif("You must have a tool equipped to select a part.", 3)
    end
    self.State.ReachType = reachType
    self.State.ReachSize = size
    self:_populatePartSelector()
    self.State.UI.ScreenGui.Enabled = true
end
function Modules.Reach:Reset()
    local self = Modules.Reach
    if not self.State.IsEnabled and not self.State.PersistentToolName then
        return DoNotif("Reach is not active and no part is set.", 3)
    end
    local tool
    if self.State.PersistentToolName then
        tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(self.State.PersistentToolName)
        if not tool then
            tool = LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild(self.State.PersistentToolName)
        end
    end
    if tool and self.State.PersistentPartName then
        local part = tool:FindFirstChild(self.State.PersistentPartName, true)
        if part then
            self:_updatePartModification(part)
        end
    end
    self.State.IsEnabled = false
    self.State.ModifiedPart = nil
    self.State.PersistentToolName = nil
    self.State.PersistentPartName = nil
    self.State.ReachType = nil
    self.State.ReachSize = nil
    if self.State.UI.ScreenGui then
        self.State.UI.ScreenGui.Enabled = false
    end
    DoNotif("Tool reach has been fully reset and persistence cleared.", 3)
end
function Modules.Reach:Initialize()
    local self = Modules.Reach
    local ui = Instance.new("ScreenGui")
    ui.Name = "ReachPartSelector_Persistent"
    ui.Parent = CoreGui
    ui.Enabled = false
    ui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ui.ResetOnSpawn = false
    self.State.UI.ScreenGui = ui
    local frame = Instance.new("Frame", ui)
    frame.Size = UDim2.fromOffset(250, 220)
    frame.Position = UDim2.new(0.5, -125, 0.5, -110)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.Draggable = true
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    self.State.UI.Frame = frame
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.Code
    title.Text = "Select a Part to Modify"
    title.TextColor3 = Color3.fromRGB(200, 220, 255)
    title.TextSize = 16
    local scroll = Instance.new("ScrollingFrame", frame)
    scroll.Size = UDim2.new(1, -20, 1, -50)
    scroll.Position = UDim2.fromOffset(10, 35)
    scroll.BackgroundColor3 = frame.BackgroundColor3
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 6
    self.State.UI.ScrollingFrame = scroll
    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    local closeBtn = Instance.new("TextButton", frame)
    closeBtn.Size = UDim2.fromOffset(20, 20)
    closeBtn.Position = UDim2.new(1, -25, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 50)
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.Code
    closeBtn.TextColor3 = Color3.fromRGB(255, 180, 180)
    closeBtn.MouseButton1Click:Connect(function() ui.Enabled = false end)
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)
    self.State.UI.CloseButton = closeBtn
    if LocalPlayer.Character then
        self:_onCharacterAdded(LocalPlayer.Character)
    end
    self.Connections.CharacterAdded = LocalPlayer.CharacterAdded:Connect(function(char)
    self:_onCharacterAdded(char)
end)
RegisterCommand({Name = "reach", Aliases = {"swordreach"}, Description = "Extends sword reach. ;reach [num]"}, function(args)
self:Apply("directional", tonumber(args[1]) or 15)
end)
RegisterCommand({Name = "boxreach", Aliases = {}, Description = "Creates a box hitbox. ;boxreach [num]"}, function(args)
self:Apply("box", tonumber(args[1]) or 15)
end)
RegisterCommand({Name = "resetreach", Aliases = {"unreach"}, Description = "Resets tool reach and clears persistent setting."}, function()
self:Reset()
end)
end
RegisterCommand({Name = "goto", Aliases = {}, Description = "Teleports to a player. ;goto [player]"}, function(args)
if not args[1] then
    return DoNotif("Specify a player's name.", 3)
end
local targetPlayer = Utilities.findPlayer(args[1])
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
                localHumanoid.WalkSpeed = 0
                local flingStartTime = tick()
                local timeToFling = 2
                repeat
                    local targetCharacter = targetPlayer.Character
                    local targetRootPart = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
                    if not targetRootPart then break end
                        local targetCF = targetRootPart.CFrame
                        localRootPart.CFrame = targetCF * CFrame.new(0, 3, 0)
                        localRootPart.Velocity = Vector3.new(0, 9e8, 0)
                        localRootPart.CFrame = targetCF * CFrame.new(0, -3, 0)
                        localRootPart.Velocity = Vector3.new(0, -9e8, 0)
                        localRootPart.CFrame = targetCF * CFrame.new(0, 0, -3)
                        localRootPart.Velocity = targetCF.LookVector * 9e8
                        localRootPart.CFrame = targetCF * CFrame.new(0, 0, 3)
                        localRootPart.Velocity = -targetCF.LookVector * 9e8
                        RunService.Heartbeat:Wait()
                    until targetRootPart.Velocity.Magnitude > 800
                    or not targetPlayer.Parent
                    or not targetPlayer.Character
                    or (targetPlayer.Character:FindFirstChildOfClass("Humanoid") and targetPlayer.Character:FindFirstChildOfClass("Humanoid").Health <= 0)
                    or tick() > flingStartTime + timeToFling
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
            task.wait(0.1)
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
    local character = Players.LocalPlayer and Players.LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        rootPart.Velocity = Vector3.new(0, 0, 0)
        rootPart.RotVelocity = Vector3.new(0, 0, 0)
    end
end
function Modules.NoclipStabilizer:Enable()
    if self.State.Enabled then return end
        self.State.Enabled = true
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
MAX_SPEED = 70,
MAX_STEP_DIST = 8,
REPEAT_THRESHOLD = 3,
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
    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.AssemblyLinearVelocity = Vector3.zero
            descendant.AssemblyAngularVelocity = Vector3.zero
        end
    end
end
function Modules.AntiCFrameTeleport:_getFlyAllowances(deltaTime)
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
            character:PivotTo(self.State.LastCFrame)
            self:_zeroVelocity(character)
            self.State.DetectionHits += 1
            if self.State.DetectionHits >= self.REPEAT_THRESHOLD then
                task.delay(self.LOCK_TIME, function()
                self.State.DetectionHits = 0
            end)
        end
    else
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
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
Modules.FireRemotes = {
State = {
Enabled = false,
},
}
function Modules.FireRemotes:Initialize()
    RegisterCommand({
    Name = "fireremotes",
    Aliases = {"fremotes", "frem"},
    Description = "Attempts to fire every discoverable RemoteEvent and RemoteFunction."
    }, function(args)
    local CoreGui = game:GetService("CoreGui")
    local remoteCount = 0
    local failedCount = 0
    for _, obj in ipairs(game:GetDescendants()) do
        if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and not obj:IsDescendantOf(CoreGui) then
            task.spawn(function()
            local success, err
            if obj:IsA("RemoteEvent") then
                success, err = pcall(function()
                obj:FireServer()
            end)
        elseif obj:IsA("RemoteFunction") then
            success, err = pcall(function()
            obj:InvokeServer()
        end)
    end
    if success then
        remoteCount = remoteCount + 1
    else
    failedCount = failedCount + 1
end
end)
end
end
task.delay(2, function()
DoNotif("Fired " .. remoteCount .. " remotes.\nFailed: " .. failedCount .. " remotes.")
end)
end)
end
Modules.RemoveForces = {
State = {},
}
function Modules.RemoveForces:Initialize()
    RegisterCommand({
    Name = "deletevelocity",
    Aliases = {"dv", "removevelocity", "removeforces"},
    Description = "Removes all force/velocity instances from your character to counter flings or fix physics glitches."
    }, function(args)
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    local character = localPlayer.Character
    if not character then
        return DoNotif("Character not found.", 3)
    end
    local forcesRemoved = 0
    for _, instance in ipairs(character:GetDescendants()) do
        if  instance:isA("BodyVelocity") or
            instance:isA("BodyGyro") or
            instance:isA("RocketPropulsion") or
            instance:isA("BodyAngularVelocity") or
            instance:isA("BodyForce") or
            instance:isA("BodyThrust") or
            instance:isA("VectorForce") or
            instance:isA("LineForce") or
            instance:isA("AngularVelocity")
            then
                instance:Destroy()
                forcesRemoved = forcesRemoved + 1
            end
        end
        DoNotif("Removed " .. forcesRemoved .. " force instances from your character.", 3)
    end)
end
Modules.TeleportToPlace = {
State = {},
}
function Modules.TeleportToPlace:Initialize()
    RegisterCommand({
    Name = "teleporttoplace",
    Aliases = {"toplace", "ttp"},
    Description = "Teleports you to a specific Roblox place using its ID."
    }, function(args)
    local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    if not args[1] then
        return DoNotif("Usage: teleporttoplace [PlaceId]", 5)
    end
    local placeId = tonumber(args[1])
    if not placeId then
        return DoNotif("Invalid PlaceId. It must be a number.", 5)
    end
    DoNotif("Attempting to teleport to " .. placeId .. "...", 3)
    local success, result = pcall(function()
    TeleportService:Teleport(placeId, localPlayer)
end)
if not success then
    DoNotif("Teleport failed: " .. tostring(result), 5)
end
end)
end
Modules.ToSpawn = {
State = {
Enabled = false,
},
}
function Modules.ToSpawn:Initialize()
    RegisterCommand({
    Name = "tospawn",
    Aliases = {"ts"},
    Description = "Teleports you to the nearest SpawnLocation."
    }, function(args)
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local localPlayer = Players.LocalPlayer
    local character = localPlayer.Character
    if not character then
        return DoNotif("Character not found.", 3)
    end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then
        return DoNotif("HumanoidRootPart not found.", 3)
    end
    local closestSpawn = nil
    local shortestDistance = math.huge
    local rootPosition = root.Position
    for _, part in ipairs(Workspace:GetDescendants()) do
        if part:IsA("SpawnLocation") then
            local distance = (part.Position - rootPosition).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestSpawn = part
            end
        end
    end
    if closestSpawn then
        root.CFrame = closestSpawn.CFrame * CFrame.new(0, 3, 0)
    else
    return DoNotif("No SpawnLocation found in workspace.", 3)
end
end)
end
Modules.TriggerRemoteTouch = {
State = {
IsExecuting = false
}
}
function Modules.TriggerRemoteTouch:_findPartFromPath(path)
    local current = Workspace
    for partName in path:gmatch("([^/]+)") do
        local found = nil
        for _, child in ipairs(current:GetChildren()) do
            if child.Name:lower() == partName:lower() then
                found = child
                break
            end
        end
        if not found then return nil end
            current = found
        end
        return current:IsA("BasePart") and current or nil
    end
    function Modules.TriggerRemoteTouch:Execute(targetPath)
        local self = Modules.TriggerRemoteTouch
        if self.State.IsExecuting then return DoNotif("A remote touch is already in progress.", 1) end
            if not targetPath then return DoNotif("Usage: ;touchpart [path/to/part]", 3) end
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return DoNotif("Cannot trigger: Your character's HumanoidRootPart was not found.", 3) end
                    local targetPart = self:_findPartFromPath(targetPath)
                    if not targetPart then return DoNotif("Could not find a valid part at path: " .. targetPath, 3) end
                        self.State.IsExecuting = true
                        DoNotif("Attempting to trigger touch on: " .. targetPart:GetFullName(), 1.5)
                        if firetouchinterest then
                            pcall(function()
                            firetouchinterest(hrp, targetPart, 0)
                            RunService.Heartbeat:Wait()
                            firetouchinterest(hrp, targetPart, 1)
                            DoNotif("Successfully triggered touch via firetouchinterest.", 2)
                        end)
                    else
                    warn("Callum's Warning: 'firetouchinterest' not found. Using CFrame fallback method for TriggerRemoteTouch.")
                    coroutine.wrap(function()
                    local originalCFrame = hrp.CFrame
                    local success, err = pcall(function()
                    hrp.CFrame = targetPart.CFrame
                    RunService.Heartbeat:Wait()
                    hrp.CFrame = originalCFrame
                end)
                if success then
                    DoNotif("Successfully triggered touch via CFrame method.", 2)
                else
                hrp.CFrame = originalCFrame
                DoNotif("CFrame method failed. The target part may be invalid.", 3)
                warn("TriggerRemoteTouch Error:", err)
            end
        end)()
    end
    task.wait(0.2)
    self.State.IsExecuting = false
end
function Modules.TriggerRemoteTouch:Initialize()
    local module = self
    RegisterCommand({
    Name = "touchpart",
    Aliases = {"trigger", "touch"},
    Description = "Remotely triggers the .Touched event on a part. Usage: ;touchpart [path/to/part]"
    }, function(args)
    local path = table.concat(args, "/")
    module:Execute(path)
end)
end
Modules.ScriptHunter = {
    State = {
        IsScanning = false
    }
}

function Modules.ScriptHunter:Execute(keywords)
    local self = Modules.ScriptHunter
    if self.State.IsScanning then return DoNotif("A script scan is already in progress.", 2) end
    if not keywords or #keywords == 0 then return DoNotif("Usage: ;huntscript <keyword1> [keyword2] ...", 3) end

    self.State.IsScanning = true
    DoNotif("Beginning script hunt for keywords: " .. table.concat(keywords, ", "), 3)

    task.spawn(function()
        local findings = {}
        local scriptsScanned = 0
        for _, script in ipairs(game:GetDescendants()) do
            if script:IsA("LuaSourceContainer") then
                local success, source = pcall(function() return script.Source end)
                if success and source then
                    scriptsScanned = scriptsScanned + 1
                    local lowerSource = source:lower()
                    local allKeywordsFound = true
                    for _, keyword in ipairs(keywords) do
                        if not lowerSource:find(keyword:lower(), 1, true) then
                            allKeywordsFound = false
                            break
                        end
                    end
                    if allKeywordsFound then
                        table.insert(findings, script:GetFullName())
                    end
                end
            end
            if scriptsScanned % 100 == 0 then task.wait() end
        end

        if #findings > 0 then
            DoNotif("Scan complete. Found " .. #findings .. " matching script(s). Results printed to console (F9).", 4)
            -- ARCHITECT'S NOTE: Corrected the malformed multi-line print statements.
            print("--- [Callum's ScriptHunter Report] ---")
            for _, path in ipairs(findings) do
                print("  [!] Match Found: " .. path)
            end
            print("--------------------------------------")
        else
            DoNotif("Scan complete. No scripts found containing all specified keywords.", 3)
        end
        self.State.IsScanning = false
    end)
end

function Modules.ScriptHunter:Initialize()
    local module = self
    RegisterCommand({
        Name = "huntscript",
        Aliases = {"findscript", "scripthunt"},
        Description = "Scans all client scripts for keywords. Usage: ;huntscript <keyword1> <keyword2>"
    }, function(args)
        module:Execute(args)
    end)
end
Modules.AstralHead = {
State = {
IsEnabled = false,
OriginalProperties = {},
Connections = {}
}
}
function Modules.AstralHead:_getCharacterHeadParts(character)
    local parts = {}
    if not character then return parts end
        local head = character:FindFirstChild("Head")
        if head then table.insert(parts, head) end
            for _, accessory in ipairs(character:GetChildren()) do
                if accessory:IsA("Accessory") then
                    local handle = accessory:FindFirstChild("Handle")
                    if handle and handle:IsA("BasePart") then
                        table.insert(parts, handle)
                    end
                end
            end
            return parts
        end
        function Modules.AstralHead:_enableForCharacter(character)
            local self = Modules.AstralHead
            if not character then return end
                local partsToModify = self:_getCharacterHeadParts(character)
                for _, part in ipairs(partsToModify) do
                    if not self.State.OriginalProperties[part] then
                        self.State.OriginalProperties[part] = {
                        Transparency = part.Transparency,
                        CanQuery = part.CanQuery,
                        CanTouch = part.CanTouch
                        }
                    end
                    part.Transparency = 1
                    part.CanQuery = false
                    part.CanTouch = false
                end
            end
            function Modules.AstralHead:_disableForCharacter(character)
                local self = Modules.AstralHead
                for part, properties in pairs(self.State.OriginalProperties) do
                    pcall(function()
                    if part and part.Parent then
                        part.Transparency = properties.Transparency
                        part.CanQuery = properties.CanQuery
                        part.CanTouch = properties.CanTouch
                    end
                end)
            end
            table.clear(self.State.OriginalProperties)
        end
        function Modules.AstralHead:Toggle()
            local self = Modules.AstralHead
            self.State.IsEnabled = not self.State.IsEnabled
            if self.State.IsEnabled then
                DoNotif("Astral Head Enabled. Head is now untargetable.", 2)
                if LocalPlayer.Character then
                    self:_enableForCharacter(LocalPlayer.Character)
                end
            else
            DoNotif("Astral Head Disabled. Head restored.", 2)
            if LocalPlayer.Character then
                self:_disableForCharacter(LocalPlayer.Character)
            else
            table.clear(self.State.OriginalProperties)
        end
    end
end
function Modules.AstralHead:Initialize()
    local module = self
    module.State.Connections.CharacterAdded = LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(0.1)
    if module.State.IsEnabled then
        module:_enableForCharacter(character)
    end
end)
module.State.Connections.CharacterRemoving = LocalPlayer.CharacterRemoving:Connect(function(character)
if module.State.IsEnabled then
    module:_disableForCharacter(character)
end
end)
RegisterCommand({
Name = "astralhead",
Aliases = {"hidehead", "nohead"},
Description = "Toggles head invisibility to counter aimbots."
}, function()
module:Toggle()
end)
end
Modules.LocalAntiTeamChange = {
State = {
IsEnabled = false,
OriginalTeam = nil,
PropertyConnection = nil
},
Dependencies = {"Players"}
}
function Modules.LocalAntiTeamChange:Enable()
    if self.State.IsEnabled then return end
        local localPlayer = self.Services.Players.LocalPlayer
        if not localPlayer then
            warn("[LocalAntiTeamChange] Could not find LocalPlayer to monitor.")
            return
        end
        self.State.IsEnabled = true
        self.State.OriginalTeam = localPlayer.Team
        if self.State.PropertyConnection then self.State.PropertyConnection:Disconnect() end
            self.State.PropertyConnection = localPlayer:GetPropertyChangedSignal("Team"):Connect(function()
            if self.State.IsEnabled and localPlayer.Team ~= self.State.OriginalTeam then
                pcall(function()
                localPlayer.Team = self.State.OriginalTeam
                DoNotif("Reverted personal team change.", 2)
            end)
        end
    end)
    DoNotif("Personal Team Lock: [Enabled]", 3)
end
function Modules.LocalAntiTeamChange:Disable()
    if not self.State.IsEnabled then return end
        self.State.IsEnabled = false
        if self.State.PropertyConnection then
            self.State.PropertyConnection:Disconnect()
            self.State.PropertyConnection = nil
        end
        self.State.OriginalTeam = nil
        DoNotif("Personal Team Lock: [Disabled]", 3)
    end
    function Modules.LocalAntiTeamChange:Toggle()
        if self.State.IsEnabled then
            self:Disable()
        else
        self:Enable()
    end
end
function Modules.LocalAntiTeamChange:Initialize()
    local module = self
    module.Services = {}
    for _, serviceName in ipairs(module.Dependencies or {}) do
        module.Services[serviceName] = game:GetService(serviceName)
    end
    RegisterCommand({
    Name = "lockteam",
    Aliases = {"localantiteamchange", "latc"},
    Description = "Toggles a lock that prevents YOUR team from being changed."
    }, function(args)
    module:Toggle()
end)
end
Modules.HumanoidIntegrity = {
State = {
IsEnabled = false,
Connections = {}
},
Dependencies = {"Players"}
}
function Modules.HumanoidIntegrity:_protectCharacter(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
        self:_cleanupCharacter(character)
        local charConnections = { Character = character }
        charConnections.StateChanged = humanoid.StateChanged:Connect(function(old, new)
        if not self.State.IsEnabled then return end
            if new == Enum.HumanoidStateType.Ragdoll or new == Enum.HumanoidStateType.Physics or new == Enum.HumanoidStateType.FallingDown then
                pcall(humanoid.ChangeState, humanoid, Enum.HumanoidStateType.GettingUp)
            end
        end)
        charConnections.JointRemoved = character.DescendantRemoving:Connect(function(descendant)
        if not self.State.IsEnabled then return end
            if descendant:IsA("Motor6D") then
                task.defer(humanoid.BuildRigFromAttachments, humanoid)
            end
        end)
        charConnections.PlatformStand = humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
        if not self.State.IsEnabled then return end
            if humanoid.PlatformStand then
                humanoid.PlatformStand = false
            end
        end)
        self.State.Connections[character] = charConnections
    end
    function Modules.HumanoidIntegrity:_cleanupCharacter(character)
        if self.State.Connections[character] then
            for _, conn in pairs(self.State.Connections[character]) do
                if typeof(conn) == "RBXScriptConnection" then
                    conn:Disconnect()
                end
            end
            self.State.Connections[character] = nil
        end
    end
    function Modules.HumanoidIntegrity:Enable()
        if self.State.IsEnabled then return end
            self.State.IsEnabled = true
            local localPlayer = self.Services.Players.LocalPlayer
            if localPlayer.Character then
                self:_protectCharacter(localPlayer.Character)
            end
            self.State.Connections.CharacterAdded = localPlayer.CharacterAdded:Connect(function(char)
            self:_protectCharacter(char)
        end)
        self.State.Connections.CharacterRemoving = localPlayer.CharacterRemoving:Connect(function(char)
        self:_cleanupCharacter(char)
    end)
    DoNotif("Humanoid Integrity System: [Enabled]", 3)
end
function Modules.HumanoidIntegrity:Disable()
    if not self.State.IsEnabled then return end
        self.State.IsEnabled = false
        for key, conn in pairs(self.State.Connections) do
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            elseif type(conn) == "table" then
                self:_cleanupCharacter(key)
            end
        end
        table.clear(self.State.Connections)
        DoNotif("Humanoid Integrity System: [Disabled]", 3)
    end
    function Modules.HumanoidIntegrity:Toggle()
        if self.State.IsEnabled then
            self:Disable()
        else
        self:Enable()
    end
end
function Modules.HumanoidIntegrity:Initialize()
    local module = self
    module.Services = { Players = game:GetService("Players") }
    RegisterCommand({
    Name = "antiragdoll",
    Aliases = {"noragdoll", "integrity"},
    Description = "Toggles a system to aggressively counter character ragdolling and joint breaking."
    }, function()
    module:Toggle()
end)
end
Modules.ToolPersistence = {
State = {
IsEnabled = false,
ToolCache = nil,
Connections = {}
},
Dependencies = {"Players", "CoreGui"}
}
function Modules.ToolPersistence:_initializeCache()
    if self.State.ToolCache and self.State.ToolCache.Parent then
        self.State.ToolCache:Destroy()
    end
    self.State.ToolCache = Instance.new("Folder")
    self.State.ToolCache.Name = "ToolCache_" .. math.random(1000, 9999)
    self.State.ToolCache.Parent = self.Services.CoreGui
end
function Modules.ToolPersistence:_cacheTool(tool)
    if not tool:IsA("Tool") then return end
        if self.State.ToolCache:FindFirstChild(tool.Name) then return end
            local success, result = pcall(function()
            local toolClone = tool:Clone()
            toolClone.Parent = self.State.ToolCache
        end)
        if not success then
            warn("[ToolPersistence] Failed to cache tool '" .. tool.Name .. "': " .. tostring(result))
        end
    end
    function Modules.ToolPersistence:Enable()
        if self.State.IsEnabled then return end
            self.State.IsEnabled = true
            local localPlayer = self.Services.Players.LocalPlayer
            local backpack = localPlayer and localPlayer:FindFirstChildOfClass("Backpack")
            if not backpack then
                self.State.IsEnabled = false
                return warn("[ToolPersistence] Cannot enable: Backpack not found.")
            end
            self:_initializeCache()
            for _, tool in ipairs(backpack:GetChildren()) do
                self:_cacheTool(tool)
            end
            self.State.Connections.ChildAdded = backpack.ChildAdded:Connect(function(child)
            self:_cacheTool(child)
        end)
        self.State.Connections.ChildRemoved = backpack.ChildRemoved:Connect(function(child)
        if self.State.IsEnabled and child:IsA("Tool") then
            local cachedTool = self.State.ToolCache:FindFirstChild(child.Name)
            if cachedTool then
                task.defer(function()
                if backpack and backpack.Parent then
                    cachedTool:Clone().Parent = backpack
                end
            end)
        end
    end
end)
DoNotif("Tool Persistence: [Enabled]", 3)
end
function Modules.ToolPersistence:Disable()
    if not self.State.IsEnabled then return end
        self.State.IsEnabled = false
        for _, conn in pairs(self.State.Connections) do
            conn:Disconnect()
        end
        table.clear(self.State.Connections)
        if self.State.ToolCache then
            self.State.ToolCache:Destroy()
            self.State.ToolCache = nil
        end
        DoNotif("Tool Persistence: [Disabled]", 3)
    end
    function Modules.ToolPersistence:Toggle()
        if self.State.IsEnabled then
            self:Disable()
        else
        self:Enable()
    end
end
function Modules.ToolPersistence:Initialize()
    local module = self
    module.Services = {}
    for _, serviceName in ipairs(module.Dependencies) do
        module.Services[serviceName] = game:GetService(serviceName)
    end
    RegisterCommand({
    Name = "antitoolremove",
    Aliases = {"locktools", "atr"},
    Description = "Toggles a system that prevents your tools from being removed from your backpack."
    }, function(args)
    module:Toggle()
end)
end
Modules.GrabTools = {
State = {
IsEnabled = false,
Connection = nil
}
}
function Modules.GrabTools:_onHeartbeat()
    local localPlayerBackpack = LocalPlayer and LocalPlayer:FindFirstChild("Backpack")
    if not localPlayerBackpack then return end
        for _, child in ipairs(Workspace:GetChildren()) do
            if child:IsA("Tool") and child:FindFirstChild("Handle") and not child.Handle.Anchored then
                child.Parent = localPlayerBackpack
                DoNotif("Grabbed Tool: " .. child.Name, 1.5)
            end
        end
    end
    function Modules.GrabTools:Toggle()
        local self = Modules.GrabTools
        self.State.IsEnabled = not self.State.IsEnabled
        if self.State.IsEnabled then
            if self.State.Connection then self.State.Connection:Disconnect() end
                self.State.Connection = RunService.Heartbeat:Connect(function() self:_onHeartbeat() end)
                DoNotif("Tool Grabber Enabled", 2)
            else
            if self.State.Connection then
                self.State.Connection:Disconnect()
                self.State.Connection = nil
            end
            DoNotif("Tool Grabber Disabled", 2)
        end
    end
    function Modules.GrabTools:Initialize()
        local module = self
        RegisterCommand({
        Name = "grabtools",
        Aliases = {"gt", "toolgrab"},
        Description = "Toggles an auto-grabber for all dropped tools in the workspace."
        }, function(args)
        module:Toggle()
    end)
end
Modules.AdminSpoofDemonstration = {
State = {
IsSpoofing = false,
SpoofedId = -1,
OriginalIndex = nil,
PlayerMetatable = nil
},
Dependencies = {"Players"}
}
function Modules.AdminSpoofDemonstration:Enable(targetId)
    if self.State.IsSpoofing then
        DoNotif("Already spoofing UserId. Reset first.", 3)
        return
    end
    local localPlayer = self.Services.Players.LocalPlayer
    if not localPlayer then return end
        local playerMetatable = getrawmetatable(localPlayer)
        if not playerMetatable then
            DoNotif("Error: Could not get the player's metatable. Environment may not support this.", 4)
            return
        end
        self.State.PlayerMetatable = playerMetatable
        self.State.OriginalIndex = playerMetatable.__index
        self.State.SpoofedId = tonumber(targetId) or -1
        self.State.IsSpoofing = true
        playerMetatable.__index = function(self, key)
        if tostring(key) == "UserId" then
            return Modules.AdminSpoofDemonstration.State.SpoofedId
        end
        return Modules.AdminSpoofDemonstration.State.OriginalIndex(self, key)
    end
    DoNotif("Local UserId spoof enabled. Now appearing as: " .. self.State.SpoofedId, 3)
end
function Modules.AdminSpoofDemonstration:Disable()
    if not self.State.IsSpoofing then return end
        if self.State.PlayerMetatable and self.State.OriginalIndex then
            self.State.PlayerMetatable.__index = self.State.OriginalIndex
        end
        self.State.IsSpoofing = false
        self.State.SpoofedId = -1
        self.State.OriginalIndex = nil
        self.State.PlayerMetatable = nil
        DoNotif("Local UserId spoof disabled. Identity restored.", 3)
    end
    function Modules.AdminSpoofDemonstration:Initialize()
        local module = self
        module.Services = { Players = game:GetService("Players") }
        RegisterCommand({
        Name = "spoofid",
        Aliases = {"setid", "fakeid"},
        Description = "Locally spoofs your UserId for vulnerable scripts. Usage: spoofid <UserId|reset>"
        }, function(args)
        local argument = args[1]
        if not argument then
            return DoNotif("Usage: ;spoofid <TargetUserId> or ;spoofid reset", 4)
        end
        if argument:lower() == "reset" or argument:lower() == "clear" then
            module:Disable()
        else
        local targetId = tonumber(argument)
        if targetId then
            module:Enable(targetId)
        else
        DoNotif("Invalid UserId. It must be a number.", 3)
    end
end
end)
end
Modules.SuperPush = {
State = {
IsEnabled = false,
Connections = {},
Originals = setmetatable({}, {__mode = "k"})
},
Config = {
PUSH_FORCE = 900,
DENSITY = 100,
COOLDOWN = 0,
lastPushTime = 0
}
}
local HEAVY_PROPERTIES = PhysicalProperties.new(Modules.SuperPush.Config.DENSITY, 0.5, 0.5)
function Modules.SuperPush:_cleanupCharacter(character)
    if not character then return end
        if self.State.Connections.Touch then
            self.State.Connections.Touch:Disconnect()
            self.State.Connections.Touch = nil
        end
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and self.State.Originals[part] then
                part.CustomPhysicalProperties = self.State.Originals[part]
                self.State.Originals[part] = nil
            end
        end
    end
    function Modules.SuperPush:_applyToCharacter(character)
        if not character then return end
            local hrp = character:WaitForChild("HumanoidRootPart", 5)
            if not hrp then return end
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if not self.State.Originals[part] then
                            self.State.Originals[part] = part.CustomPhysicalProperties
                        end
                        part.CustomPhysicalProperties = HEAVY_PROPERTIES
                    end
                end
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
                            if LocalPlayer.Character then
                                self:_applyToCharacter(LocalPlayer.Character)
                            end
                            self.State.Connections.CharacterAdded = LocalPlayer.CharacterAdded:Connect(function(character)
                            self:_applyToCharacter(character)
                        end)
                        self.State.Connections.CharacterRemoving = LocalPlayer.CharacterRemoving:Connect(function(character)
                        self:_cleanupCharacter(character)
                    end)
                else
                DoNotif("Super Push Disabled", 2)
                if self.State.Connections.CharacterAdded then self.State.Connections.CharacterAdded:Disconnect() end
                    if self.State.Connections.CharacterRemoving then self.State.Connections.CharacterRemoving:Disconnect() end
                        table.clear(self.State.Connections)
                        if LocalPlayer.Character then
                            self:_cleanupCharacter(LocalPlayer.Character)
                        end
                    end
                end
                RegisterCommand({
                Name = "superpush",
                Aliases = {"bump", "heavy"},
                Description = "Increases your mass and adds a velocity push when you bump into players."
                }, function()
                Modules.SuperPush:Toggle()
            end)
            Modules.Aura = {
            State = {
            Enabled = false,
            Distance = 20,
            Connection = nil,
            Visualizer = nil,
            },
            }
            function Modules.Aura:Disable()
                if not self.State.Enabled then return end
                    if self.State.Connection then
                        self.State.Connection:Disconnect()
                        self.State.Connection = nil
                    end
                    if self.State.Visualizer then
                        self.State.Visualizer:Destroy()
                        self.State.Visualizer = nil
                    end
                    self.State.Enabled = false
                    DoNotif("Aura disabled.", 2)
                end
                function Modules.Aura:Enable()
                    if self.State.Enabled then self:Disable() end
                        if not firetouchinterest then
                            return DoNotif("This script requires 'firetouchinterest' to function.", 5)
                        end
                        local Players = game:GetService("Players")
                        local RunService = game:GetService("RunService")
                        local Workspace = game:GetService("Workspace")
                        local visualizer = Instance.new("Part")
                        visualizer.Shape = Enum.PartType.Ball
                        visualizer.Size = Vector3.new(self.State.Distance * 2, self.State.Distance * 2, self.State.Distance * 2)
                        visualizer.Transparency = 0.8
                        visualizer.Color = Color3.fromRGB(255, 0, 0)
                        visualizer.Material = Enum.Material.Neon
                        visualizer.Anchored = true
                        visualizer.CanCollide = false
                        visualizer.Parent = Workspace
                        self.State.Visualizer = visualizer
                        self.State.Enabled = true
                        DoNotif("Aura enabled at " .. self.State.Distance .. " studs.", 2)
                        self.State.Connection = RunService.RenderStepped:Connect(function()
                        local localPlayer = Players.LocalPlayer
                        if not (localPlayer and self.State.Enabled) then return self:Disable() end
                            local character = localPlayer.Character
                            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                            local tool = character and character:FindFirstChildOfClass("Tool")
                            local handle = tool and (tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart"))
                            if not (rootPart and handle and self.State.Visualizer) then
                                return
                            end
                            self.State.Visualizer.CFrame = rootPart.CFrame
                            for _, player in ipairs(Players:GetPlayers()) do
                                if player ~= localPlayer and player.Character then
                                    local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
                                    local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                                    if targetHumanoid and targetHumanoid.Health > 0 and targetRoot then
                                        if (targetRoot.Position - rootPart.Position).Magnitude <= self.State.Distance then
                                            firetouchinterest(handle, targetRoot, 0)
                                            task.wait()
                                            firetouchinterest(handle, targetRoot, 1)
                                        end
                                    end
                                end
                            end
                        end)
                    end
                    function Modules.Aura:Initialize()
                        RegisterCommand({
                        Name = "aura",
                        Aliases = {},
                        Description = "Continuously damages nearby players. Optional [distance] argument."
                        }, function(args)
                        local dist = tonumber(args[1])
                        local wasEnabled = self.State.Enabled
                        if dist and dist > 0 then
                            self.State.Distance = dist
                            DoNotif("Aura distance set to " .. dist, 2)
                        end
                        if wasEnabled then
                            self:Disable()
                        else
                        self:Enable()
                    end
                end)
            end
            Modules.HandleKill = {
            State = {
            ActiveLoops = {},
            },
            }
            function Modules.HandleKill:StopLoop(targetPlayer)
                if not self.State.ActiveLoops[targetPlayer] then return end
                    self.State.ActiveLoops[targetPlayer] = nil
                    DoNotif("HandleKill stopped for " .. targetPlayer.Name, 2)
                end
                function Modules.HandleKill:StartLoop(targetPlayer)
                    if self.State.ActiveLoops[targetPlayer] then return end
                        local character = LocalPlayer.Character
                        if not character then return DoNotif("Your character was not found.", 3) end
                            local tool = character:FindFirstChildOfClass("Tool")
                            if not tool or not tool:FindFirstChild("Handle") then
                                return DoNotif("You must be holding a tool with a 'Handle'.", 3)
                            end
                            local handle = tool.Handle
                            local loopThread = coroutine.create(function()
                            self.State.ActiveLoops[targetPlayer] = true
                            while self.State.ActiveLoops[targetPlayer] and tool.Parent == character and targetPlayer.Character do
                                local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
                                if not humanoid or humanoid.Health <= 0 then break end
                                    for _, part in ipairs(targetPlayer.Character:GetChildren()) do
                                        if part:IsA("BasePart") then
                                            firetouchinterest(handle, part, 0)
                                            task.wait()
                                            firetouchinterest(handle, part, 1)
                                        end
                                    end
                                    RunService.Heartbeat:Wait()
                                end
                                self.State.ActiveLoops[targetPlayer] = nil
                            end)
                            coroutine.resume(loopThread)
                            DoNotif("HandleKill initiated on " .. targetPlayer.Name, 2)
                        end
                        function Modules.HandleKill:Initialize()
                            local module = self
                            RegisterCommand({
                            Name = "handlekill",
                            Aliases = {"hkill"},
                            Description = "Toggles a kill loop on a player using your equipped tool."
                            }, function(args)
                            if not firetouchinterest then
                                return DoNotif("firetouchinterest is not supported.", 3)
                            end
                            if not args[1] then
                                return DoNotif("Usage: hkill <player>", 3)
                            end
                            local targetPlayer = Utilities.findPlayer(args[1])
                            if not targetPlayer then
                                return DoNotif("No target found.", 3)
                            end
                            if module.State.ActiveLoops[targetPlayer] then
                                module:StopLoop(targetPlayer)
                            else
                            module:StartLoop(targetPlayer)
                        end
                    end)
                end
                Modules.RemoteSpy = {
                State = {
                IsEnabled = false,
                UI = nil,
                OriginalNamecall = nil,
                BlockedRemotes = {}
                }
                }
                function Modules.RemoteSpy:Toggle()
                    if self.State.IsEnabled then
                        pcall(function()
                        local mt = getrawmetatable(game)
                        if mt and self.State.OriginalNamecall then
                            setreadonly(mt, false)
                            mt.__namecall = self.State.OriginalNamecall
                            setreadonly(mt, true)
                        end
                        if self.State.UI then
                            self.State.UI:Destroy()
                        end
                    end)
                    self.State.IsEnabled = false
                    self.State.UI = nil
                    self.State.OriginalNamecall = nil
                    table.clear(self.State.BlockedRemotes)
                    DoNotif("RemoteSpy Disabled.", 2)
                    return
                end
                self.State.IsEnabled = true
                DoNotif("RemoteSpy Enabled.", 2)
                local CoreGui = game:GetService("CoreGui")
                local UserInputService = game:GetService("UserInputService")
                local CONFIG = {
                UI_TITLE = "Callum's RemoteSpy",
                PRIMARY_COLOR = Color3.fromRGB(0, 255, 255),
                BACKGROUND_COLOR = Color3.fromRGB(30, 30, 40),
                FONT = Enum.Font.GothamSemibold
                }
                local remoteSpyGui = Instance.new("ScreenGui")
                remoteSpyGui.Name = "RemoteSpy_" .. math.random(1000, 9999)
                remoteSpyGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
                remoteSpyGui.ResetOnSpawn = false
                self.State.UI = remoteSpyGui
                local mainFrame = Instance.new("Frame")
                mainFrame.Size = UDim2.fromOffset(500, 350)
                mainFrame.Position = UDim2.fromScale(0.5, 0.5)
                mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
                mainFrame.BackgroundColor3 = CONFIG.BACKGROUND_COLOR
                mainFrame.BorderSizePixel = 0
                mainFrame.ClipsDescendants = true
                mainFrame.Parent = remoteSpyGui
                Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 6)
                local stroke = Instance.new("UIStroke", mainFrame)
                stroke.Color = CONFIG.PRIMARY_COLOR
                stroke.Thickness = 1.5
                stroke.Transparency = 0.4
                local titleBar = Instance.new("Frame")
                titleBar.Size = UDim2.new(1, 0, 0, 30)
                titleBar.BackgroundColor3 = CONFIG.PRIMARY_COLOR
                titleBar.BackgroundTransparency = 0.85
                titleBar.Parent = mainFrame
                local titleLabel = Instance.new("TextLabel", titleBar)
                titleLabel.Size = UDim2.new(1, -60, 1, 0)
                titleLabel.Position = UDim2.fromOffset(10, 0)
                titleLabel.BackgroundTransparency = 1
                titleLabel.Font = CONFIG.FONT
                titleLabel.Text = CONFIG.UI_TITLE
                titleLabel.TextColor3 = Color3.new(1, 1, 1)
                titleLabel.TextXAlignment = Enum.TextXAlignment.Left
                titleLabel.TextSize = 16
                local exitButton = Instance.new("TextButton", titleBar)
                exitButton.Size = UDim2.fromOffset(30, 30)
                exitButton.Position = UDim2.new(1, 0, 0, 0)
                exitButton.AnchorPoint = Vector2.new(1, 0)
                exitButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
                exitButton.BackgroundTransparency = 0.5
                exitButton.Font = CONFIG.FONT
                exitButton.Text = "X"
                exitButton.TextColor3 = Color3.new(1, 1, 1)
                local minimizeButton = Instance.new("TextButton", titleBar)
                minimizeButton.Size = UDim2.fromOffset(30, 30)
                minimizeButton.Position = UDim2.new(1, -30, 0, 0)
                minimizeButton.AnchorPoint = Vector2.new(1, 0)
                minimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                minimizeButton.BackgroundTransparency = 0.5
                minimizeButton.Font = CONFIG.FONT
                minimizeButton.Text = "-"
                minimizeButton.TextColor3 = Color3.new(1, 1, 1)
                local contentFrame = Instance.new("Frame")
                contentFrame.Size = UDim2.new(1, 0, 1, -30)
                contentFrame.Position = UDim2.fromOffset(0, 30)
                contentFrame.BackgroundTransparency = 1
                contentFrame.Parent = mainFrame
                local scrollingFrame = Instance.new("ScrollingFrame")
                scrollingFrame.Size = UDim2.new(1, -10, 1, -10)
                scrollingFrame.Position = UDim2.fromScale(0.5, 0.5)
                scrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
                scrollingFrame.BackgroundColor3 = CONFIG.BACKGROUND_COLOR
                scrollingFrame.BackgroundTransparency = 0.5
                scrollingFrame.BorderSizePixel = 0
                scrollingFrame.ScrollBarThickness = 5
                scrollingFrame.Parent = contentFrame
                local listLayout = Instance.new("UIListLayout", scrollingFrame)
                listLayout.Padding = UDim.new(0, 5)
                local entryTemplate = Instance.new("Frame")
                entryTemplate.Name = "EntryTemplate"
                entryTemplate.Size = UDim2.new(1, -4, 0, 60)
                entryTemplate.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
                entryTemplate.BorderSizePixel = 0
                local pathLabel = Instance.new("TextLabel", entryTemplate)
                pathLabel.Size = UDim2.new(1, -10, 0, 20)
                pathLabel.Position = UDim2.fromOffset(5, 2)
                pathLabel.BackgroundTransparency = 1
                pathLabel.Font = Enum.Font.Code
                pathLabel.TextColor3 = CONFIG.PRIMARY_COLOR
                pathLabel.TextXAlignment = Enum.TextXAlignment.Left
                pathLabel.TextSize = 13
                pathLabel.ClipsDescendants = true
                local argsLabel = Instance.new("TextLabel", entryTemplate)
                argsLabel.Size = UDim2.new(1, -10, 0, 14)
                argsLabel.Position = UDim2.fromOffset(5, 22)
                argsLabel.BackgroundTransparency = 1
                argsLabel.Font = Enum.Font.Code
                argsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                argsLabel.TextXAlignment = Enum.TextXAlignment.Left
                argsLabel.TextSize = 12
                argsLabel.ClipsDescendants = true
                local fireButton = Instance.new("TextButton", entryTemplate)
                fireButton.Size = UDim2.fromOffset(60, 20)
                fireButton.Position = UDim2.new(1, -135, 1, -25)
                fireButton.AnchorPoint = Vector2.new(0, 1)
                fireButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
                fireButton.Font = Enum.Font.Gotham
                fireButton.Text = "Fire"
                fireButton.TextColor3 = Color3.white
                local blockButton = Instance.new("TextButton", entryTemplate)
                blockButton.Size = UDim2.fromOffset(60, 20)
                blockButton.Position = UDim2.new(1, -65, 1, -25)
                blockButton.AnchorPoint = Vector2.new(0, 1)
                blockButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
                blockButton.Font = Enum.Font.Gotham
                blockButton.Text = "Block"
                blockButton.TextColor3 = Color3.white
                local module = self
                exitButton.MouseButton1Click:Connect(function()
                module:Toggle()
            end)
            do
                local isMinimized = false
                minimizeButton.MouseButton1Click:Connect(function()
                isMinimized = not isMinimized
                contentFrame.Visible = not isMinimized
                minimizeButton.Text = isMinimized and "+" or "-"
                mainFrame.Size = isMinimized and UDim2.fromOffset(200, 30) or UDim2.fromOffset(500, 350)
            end)
        end
        do
            titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local dragStart = input.Position
                local startPos = mainFrame.Position
                local moveConn, endConn
                moveConn = UserInputService.InputChanged:Connect(function(moveInput)
                if moveInput.UserInputType == Enum.UserInputType.MouseMovement then
                    local delta = moveInput.Position - dragStart
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
end)
end
local function serializeArguments(args)
local serialized = {}
for _, v in ipairs(args) do
    local t = typeof(v)
    if t == "string" then table.insert(serialized, string.format("%q", v))
    elseif t == "Instance" then table.insert(serialized, v:GetFullName())
elseif t == "table" then table.insert(serialized, "{...}")
else table.insert(serialized, tostring(v)) end
end
return "{" .. table.concat(serialized, ", ") .. "}"
end
local function logRemote(remote, args)
local fullName = remote:GetFullName()
local entry = entryTemplate:Clone()
local remoteType = remote:IsA("RemoteEvent") and "EVENT" or "FUNCTION"
entry.pathLabel.Text = string.format("[%s] %s", remoteType, fullName)
entry.argsLabel.Text = serializeArguments(args)
entry.Parent = scrollingFrame
entry.fireButton.MouseButton1Click:Connect(function()
if remote and remote.Parent then
    if remoteType == "EVENT" then
        remote:FireServer(unpack(args))
    else
    pcall(remote.InvokeServer, remote, unpack(args))
end
end
end)
entry.blockButton.MouseButton1Click:Connect(function()
module.State.BlockedRemotes[fullName] = true
entry.blockButton.Text = "Blocked"
entry.blockButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
entry.blockButton.AutoButtonColor = false
end)
scrollingFrame.CanvasPosition = Vector2.new(0, listLayout.AbsoluteContentSize.Y)
end
local mt = getrawmetatable(game)
self.State.OriginalNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = function(...)
local args = {...}
local selfArg = args[1]
local method = getnamecallmethod()
if (selfArg:IsA("RemoteEvent") and method == "FireServer") or (selfArg:IsA("RemoteFunction") and method == "InvokeServer") then
    local fullName = selfArg:GetFullName()
    if module.State.BlockedRemotes[fullName] then
        return
    end
    local callArgs = {}
    for i = 2, #args do table.insert(callArgs, args[i]) end
        logRemote(selfArg, callArgs)
    end
    return module.State.OriginalNamecall(...)
end
setreadonly(mt, true)
remoteSpyGui.Parent = CoreGui
end
function Modules.RemoteSpy:Initialize()
    local module = self
    RegisterCommand({
    Name = "remotespy",
    Aliases = {"rspy"},
    Description = "Toggles a UI to inspect and block remote events/functions."
    }, function(args)
    module:Toggle()
end)
end
Modules.Strengthen = {
State = {
Enabled = false,
Density = 100,
OriginalProperties = {},
},
}
function Modules.Strengthen:ApplyToCharacter(character)
    table.clear(self.State.OriginalProperties)
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            self.State.OriginalProperties[part] = part.CustomPhysicalProperties
            part.CustomPhysicalProperties = PhysicalProperties.new(self.State.Density, 0.3, 0.5)
        end
    end
end
function Modules.Strengthen:RevertForCharacter()
    local character = Players.LocalPlayer.Character
    if not character then return end
        for part, originalProperties in pairs(self.State.OriginalProperties) do
            if part and part.Parent and part:IsDescendantOf(character) then
                part.CustomPhysicalProperties = originalProperties
            end
        end
        table.clear(self.State.OriginalProperties)
    end
    function Modules.Strengthen:Initialize()
        local module = self
        RegisterCommand({
        Name = "strengthen",
        Aliases = {"buff", "density"},
        Description = "Toggles high character density to resist forces. Optional [density] argument."
        }, function(args)
        local character = Players.LocalPlayer.Character
        if not character then
            return DoNotif("Character not found.", 3)
        end
        local newDensity = tonumber(args[1])
        if newDensity and newDensity > 0 then
            module.State.Density = newDensity
            DoNotif("Strengthen density set to " .. module.State.Density, 2)
        end
        if module.State.Enabled then
            module:RevertForCharacter()
            module.State.Enabled = false
            DoNotif("Strengthen disabled. Character physics restored.", 2)
        else
        module:ApplyToCharacter(character)
        module.State.Enabled = true
        DoNotif("Strengthen enabled at density " .. module.State.Density, 2)
    end
end)
end
Modules.PlayerFollower = {
State = {
IsEnabled = false,
MimicMoves = false,
Target = "Nearest Player",
CurrentHighlight = nil,
RenderSteppedConnection = nil,
KeybindConnection = nil
},
Config = {
FollowSpeed = 1.0
},
Dependencies = {"Players", "RunService", "UserInputService"}
}
function Modules.PlayerFollower:_getNearestPlayer()
    local localChar = self.Services.Players.LocalPlayer.Character
    if not (localChar and localChar:FindFirstChild("HumanoidRootPart")) then return nil end
        local myPos = localChar.HumanoidRootPart.Position
        local closestPlayer, closestDist = nil, math.huge
        for _, player in ipairs(self.Services.Players:GetPlayers()) do
            if player ~= self.Services.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (player.Character.HumanoidRootPart.Position - myPos).Magnitude
                if dist < closestDist then
                    closestPlayer, closestDist = player, dist
                end
            end
        end
        return closestPlayer
    end
    function Modules.PlayerFollower:_applyHighlight(targetPlayer)
        if self.State.CurrentHighlight and self.State.CurrentHighlight.Parent then
            self.State.CurrentHighlight:Destroy()
            self.State.CurrentHighlight = nil
        end
        if targetPlayer and targetPlayer.Character then
            local highlight = Instance.new("Highlight")
            highlight.Name = "FollowerHighlight"
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.45
            highlight.Adornee = targetPlayer.Character
            highlight.Parent = targetPlayer.Character
            self.State.CurrentHighlight = highlight
        end
    end
    function Modules.PlayerFollower:_onRenderStepped()
        if not self.State.IsEnabled then return end
            local targetPlayer
            if self.State.Target == "Nearest Player" then
                targetPlayer = self:_getNearestPlayer()
            elseif typeof(self.State.Target) == "Instance" and self.State.Target:IsA("Player") then
                targetPlayer = self.State.Target
            end
            self:_applyHighlight(targetPlayer)
            if not targetPlayer then return end
                local localChar, targetChar = self.Services.Players.LocalPlayer.Character, targetPlayer.Character
                if localChar and targetChar then
                    local part, targetPart = localChar:FindFirstChild("HumanoidRootPart"), targetChar:FindFirstChild("HumanoidRootPart")
                    local hum = localChar:FindFirstChildOfClass("Humanoid")
                    if part and targetPart and hum then
                        hum.AutoRotate = false
                        local lerpAlpha = math.clamp(self.Config.FollowSpeed, 0, 1)
                        if self.State.MimicMoves then
                            part.CFrame = part.CFrame:Lerp(targetPart.CFrame, lerpAlpha)
                            local targetHum = targetChar:FindFirstChildOfClass("Humanoid")
                            if targetHum and targetHum.Jump then
                                hum.Jump = true
                            end
                        else
                        local lookAtCFrame = CFrame.new(part.Position, targetPart.Position)
                        part.CFrame = part.CFrame:Lerp(lookAtCFrame, lerpAlpha)
                        hum:MoveTo(targetPart.Position)
                    end
                end
            end
        end
        function Modules.PlayerFollower:ToggleFollow()
            self.State.IsEnabled = not self.State.IsEnabled
            DoNotif("Following", self.State.IsEnabled and "Enabled" or "Disabled", 2)
            if self.State.IsEnabled then
                if not self.State.RenderSteppedConnection then
                    self.State.RenderSteppedConnection = self.Services.RunService.RenderStepped:Connect(function()
                    self:_onRenderStepped()
                end)
            end
        else
        if self.State.RenderSteppedConnection then
            self.State.RenderSteppedConnection:Disconnect()
            self.State.RenderSteppedConnection = nil
        end
        self:_applyHighlight(nil)
        local localChar = self.Services.Players.LocalPlayer.Character
        if localChar and localChar:FindFirstChildOfClass("Humanoid") then
            localChar:FindFirstChildOfClass("Humanoid").AutoRotate = true
        end
    end
end
function Modules.PlayerFollower:ToggleMimic()
    self.State.MimicMoves = not self.State.MimicMoves
    DoNotif("Mimic Movements", self.State.MimicMoves and "Enabled" or "Disabled", 2)
    if self.State.MimicMoves and not self.State.IsEnabled then
        self:ToggleFollow()
    end
end
function Modules.PlayerFollower:Initialize()
    local module = self
    module.Services = {}
    for _, serviceName in ipairs(module.Dependencies) do
        module.Services[serviceName] = game:GetService(serviceName)
    end
    RegisterCommand({
    Name = "follow",
    Aliases = {},
    Description = "Follows a player. Usage: ;follow <player|nearest|off>"
    }, function(args)
    local targetName = args[1] and args[1]:lower() or "off"
    if targetName == "off" then
        if module.State.IsEnabled then module:ToggleFollow() end
            module.State.Target = "Nearest Player"
            return DoNotif("Follow target cleared.", 2)
        end
        if targetName == "nearest" then
            module.State.Target = "Nearest Player"
            return DoNotif("Follow target set to: Nearest Player", 2)
        end
        local targetPlayer = Utilities.findPlayer(targetName)
        if targetPlayer then
            module.State.Target = targetPlayer
            DoNotif("Follow target set to: " .. targetPlayer.Name, 2)
        else
        DoNotif("Player not found: " .. (args[1] or ""), 3)
    end
end)
RegisterCommand({
Name = "followspeed",
Aliases = {"fspeed"},
Description = "Sets the follow speed (0 to 5). Usage: ;fspeed <number>"
}, function(args)
local speed = tonumber(args[1])
if speed then
    module.Config.FollowSpeed = math.clamp(speed / 5, 0, 1)
    DoNotif("Follow speed set to: " .. speed, 2)
else
DoNotif("Invalid speed. Please provide a number.", 3)
end
end)
module.State.KeybindConnection = module.Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.X then
        module:ToggleFollow()
    elseif input.KeyCode == Enum.KeyCode.Z then
        module:ToggleMimic()
    end
end)
end
Modules.AntiAnchor = {
    State = {
        Enabled = false,
        TrackedParts = setmetatable({}, {__mode="k"}),
        OriginalProperties = setmetatable({}, {__mode="k"}),
        Signals = setmetatable({}, {__mode="k"}),
        CharacterConnections = {},
        FailsafeConnection = nil,
    },
    Dependencies = {"Players", "RunService"},
}

function Modules.AntiAnchor:Enforce(part)
    if not (part and part:IsA("BasePart")) then return end
    
    if self.State.OriginalProperties[part] == nil then
        self.State.OriginalProperties[part] = part.Anchored
    end
    
    self.State.TrackedParts[part] = true
    if part.Anchored then part.Anchored = false end
    
    if not self.State.Signals[part] then
        self.State.Signals[part] = part:GetPropertyChangedSignal("Anchored"):Connect(function()
            if self.State.Enabled and part.Anchored then
                part.Anchored = false
            end
        end)
    end
end

function Modules.AntiAnchor:ProcessCharacter(character)
    for _, child in ipairs(character:GetDescendants()) do self:Enforce(child) end
    
    table.insert(self.State.CharacterConnections, character.DescendantAdded:Connect(function(child) self:Enforce(child) end))
    table.insert(self.State.CharacterConnections, character.DescendantRemoving:Connect(function(child)
        if self.State.Signals[child] then
            self.State.Signals[child]:Disconnect()
            self.State.Signals[child] = nil
        end
        self.State.TrackedParts[child] = nil
        self.State.OriginalProperties[child] = nil
    end))
end

function Modules.AntiAnchor:Enable()
    if self.State.Enabled then return end
    self.State.Enabled = true
    
    local localPlayer = self.Services.Players.LocalPlayer
    if localPlayer.Character then self:ProcessCharacter(localPlayer.Character) end
    
    table.insert(self.State.CharacterConnections, localPlayer.CharacterAdded:Connect(function(char) self:ProcessCharacter(char) end))
    
    self.State.FailsafeConnection = self.Services.RunService.Stepped:Connect(function()
        for part in pairs(self.State.TrackedParts) do
            if part and part.Anchored then part.Anchored = false end
        end
    end)
    DoNotif("Anti-Anchor enabled.", 2)
end

function Modules.AntiAnchor:Disable()
    if not self.State.Enabled then return end
    self.State.Enabled = false
    
    for _, conn in ipairs(self.State.CharacterConnections) do conn:Disconnect() end
    for _, conn in pairs(self.State.Signals) do conn:Disconnect() end
    if self.State.FailsafeConnection then self.State.FailsafeConnection:Disconnect() end
    
    for part, originalValue in pairs(self.State.OriginalProperties) do
        if part and part.Parent then part.Anchored = originalValue end
    end
    
    table.clear(self.State.TrackedParts)
    table.clear(self.State.OriginalProperties)
    table.clear(self.State.Signals)
    table.clear(self.State.CharacterConnections)
    self.State.FailsafeConnection = nil
    
    DoNotif("Anti-Anchor disabled.", 2)
end

function Modules.AntiAnchor:Initialize()
    -- ARCHITECT'S NOTE: The 'Initialize' function is where dependencies should be loaded.
    self.Services = {}
    for _, service in ipairs(self.Dependencies) do
        self.Services[service] = game:GetService(service)
    end

    RegisterCommand({
        Name = "antianchor",
        Aliases = {"aa"},
        Description = "Toggles a robust defense against being anchored."
    }, function()
        -- The previous logic was slightly flawed; calling self:Enable/Disable directly is cleaner.
        if self.State.Enabled then
            self:Disable()
        else
            self:Enable()
        end
    end)
end

Modules.RevealInvisible = {
    State = {
        Connection = nil,
        OriginalTransparency = setmetatable({}, {__mode="k"}),
    },
    Dependencies = {"RunService", "Workspace"},
}

function Modules.RevealInvisible:Disable()
    if not self.State.Connection then return end
    
    self.State.Connection:Disconnect()
    self.State.Connection = nil
    
    for part, originalValue in pairs(self.State.OriginalTransparency) do
        if part and part.Parent then
            part.Transparency = originalValue
        end
    end
    
    table.clear(self.State.OriginalTransparency)
    DoNotif("Invisible parts have been hidden again.", 2)
end

function Modules.RevealInvisible:Enable()
    self:Disable() -- Ensure any previous state is cleared before running.
    
    local partsRevealed = 0
    for _, part in ipairs(self.Services.Workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency > 0.95 then
            if self.State.OriginalTransparency[part] == nil then
                self.State.OriginalTransparency[part] = part.Transparency
                part.Transparency = 0.5
                partsRevealed = partsRevealed + 1
            end
        end
    end
    
    DoNotif("Initial scan revealed " .. partsRevealed .. " invisible parts.", 2)
    
    self.State.Connection = self.Services.RunService.RenderStepped:Connect(function()
        for _, part in ipairs(self.Services.Workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Transparency > 0.95 and not self.State.OriginalTransparency[part] then
                self.State.OriginalTransparency[part] = part.Transparency
                part.Transparency = 0.5
            end
        end
    end)
end

function Modules.RevealInvisible:Initialize()
    self.Services = {}
    for _, service in ipairs(self.Dependencies) do
        self.Services[service] = game:GetService(service)
    end

    RegisterCommand({
        Name = "invisibleparts",
        Aliases = {"invisparts", "showinvisible"},
        Description = "Toggles the visibility of all invisible parts in the workspace."
    }, function()
        if self.State.Connection then
            self:Disable()
        else
            self:Enable()
        end
    end)
end

Modules.FixCamera = {
    State = {
        Enabled = false,
        Connection = nil,
        OriginalMaxZoom = nil,
        OriginalOcclusionMode = nil,
    }
}

RegisterCommand({
    Name = "fixcam",
    Aliases = {"fix", "unlockcam"},
    Description = "Unlocks camera, allows zooming through walls, and forces third-person."
}, function(args)
    if not LocalPlayer then return end
    
    local self = Modules.FixCamera -- Reference the module table
    self.State.Enabled = not self.State.Enabled
    
    if self.State.Enabled then
        self.State.OriginalMaxZoom = LocalPlayer.CameraMaxZoomDistance
        self.State.OriginalOcclusionMode = LocalPlayer.DevCameraOcclusionMode
        LocalPlayer.CameraMaxZoomDistance = 10000
        
        local success, err = pcall(function()
            LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.None
        end)
        if not success then
            warn("FixCamera: Failed to set DevCameraOcclusionMode via Enum. Falling back to 0. Error:", err)
            LocalPlayer.DevCameraOcclusionMode = 0
        end
        
        self.State.Connection = RunService.RenderStepped:Connect(function()
            if LocalPlayer.CameraMode ~= Enum.CameraMode.Classic then
                LocalPlayer.CameraMode = Enum.CameraMode.Classic
            end
        end)
        DoNotif("Camera override enabled (with wall-zoom).", 3)
    else
        if self.State.Connection and self.State.Connection.Connected then
            self.State.Connection:Disconnect()
            self.State.Connection = nil
        end
        
        pcall(function()
            if self.State.OriginalOcclusionMode ~= nil then
                LocalPlayer.DevCameraOcclusionMode = self.State.OriginalOcclusionMode
            end
            if self.State.OriginalMaxZoom ~= nil then
                LocalPlayer.CameraMaxZoomDistance = self.State.OriginalMaxZoom
            end
        end)
        
        self.State.OriginalOcclusionMode = nil
        self.State.OriginalMaxZoom = nil
        DoNotif("Camera override disabled.", 3)
    end
end)

local function loadstringCmd(url, notif)
    pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    DoNotif(notif, 3)
end
RegisterCommand({Name = "touchfling", Aliases = {"tfling"}, Description = "Loads the FLING ui"}, function()
loadstringCmd("https://raw.githubusercontent.com/miso517/scirpt/refs/heads/main/main.lua", "Fling GUI Loaded")
end)
RegisterCommand({Name = "teleporter", Aliases = {"tpui"}, Description = "Loads the Game Universe."}, function()
loadstringCmd("https://raw.githubusercontent.com/ltseverydayyou/uuuuuuu/main/Universe%20Viewer", "Universe Initialized")
end)
RegisterCommand({Name = "wallwalk", Aliases = {"ww"}, Description = "Walk On Walls"}, function()
loadstringCmd("https://raw.githubusercontent.com/ltseverydayyou/uuuuuuu/main/WallWalk.lua", "Loaded!")
end)
RegisterCommand({Name = "ragebot", Aliases = {}, Description = "Attachs behind a player and auto attacks, remains out of view."}, function()
loadstringCmd("https://raw.githubusercontent.com/zukatechdevelopment-ux/thingsandstuff/refs/heads/main/ragebot.lua", "Script 2 Activated!")
end)
RegisterCommand({Name = "dex", Aliases = {}, Description = "Xeno might fucking die, caution."}, function()
loadstringCmd("https://raw.githubusercontent.com/zukatechdevelopment-ux/luaprojectse3/refs/heads/main/CustomDex.lua", "Dex Loading.")
end)
RegisterCommand({Name = "funbox", Aliases = {"fbox"}, Description = "Loads the Original Zuka Hub"}, function() loadstringCmd("https://raw.githubusercontent.com/bloxtech1/luaprojects2/refs/heads/main/ZukasFunBox.lua", "Loading Zuka's FunBox...") end)
RegisterCommand({Name = "zukahub", Aliases = {"zuka"}, Description = "Loads the Zuka Hub"}, function() loadstringCmd("https://raw.githubusercontent.com/zukatechdevelopment-ux/thingsandstuff/refs/heads/main/ZukaHub.lua", "Loading Zuka's Hub...") end)
RegisterCommand({Name = "stopanimations", Aliases = {"stopa"}, Description = "Stops local animations"}, function() loadstringCmd("https://raw.githubusercontent.com/haileybae12/lua3/refs/heads/main/noanimations.lua", "Loading...") end)
RegisterCommand({Name = "catbypasser", Aliases = {"cat"}, Description = "Loads the Cat Bypasser"}, function() loadstringCmd("https://raw.githubusercontent.com/haileybae12/lua3/refs/heads/main/CatBypasser(Reborn).lua", "Loading...") end)
RegisterCommand({Name = "stats", Aliases = {}, Description = "Edit and lock your properties."}, function() loadstringCmd("https://raw.githubusercontent.com/haileybae12/callumsscript/refs/heads/main/editstats.txt", "Loading Stats..") end)
RegisterCommand({Name = "desync", Aliases = {"invis", "astral"}, Description = "Desyncs local player, making them invisable."}, function() loadstringCmd("https://raw.githubusercontent.com/haileybae12/callumsscript/refs/heads/main/astralform.txt", "Leaving Physical Body..") end)
RegisterCommand({Name = "aimbot", Aliases = {"aim", "a"}, Description = "The best aimbot."}, function() loadstringCmd("https://raw.githubusercontent.com/haileybae12/callumsscript/refs/heads/main/gamingchairmain.lua", "Gaming Chair Loaded.") end)
RegisterCommand({Name = "zgui", Aliases = {"upd3", "zui"}, Description = "For Zombie Game upd3"}, function() loadstringCmd("https://raw.githubusercontent.com/zukatechdevelopment-ux/luaprojectse3/refs/heads/main/ZGUI.txt", "Loaded GUI") end)
RegisterCommand({Name = "swordbot", Aliases = {"sf", "sfbot"}, Description = "Auto Sword Fighter, use E and R"}, function() loadstringCmd("https://raw.githubusercontent.com/bloxtech1/luaprojects2/refs/heads/main/swordnpc", "Bot loaded.") end)
RegisterCommand({Name = "reload", Aliases = {"update", "exec"}, Description = "Reloads and re-executes the admin script from the GitHub source."}, function() loadstringCmd("https://raw.githubusercontent.com/haileybae12/callumsscript/refs/heads/main/Main.lua", "Reloading admin from source...") end)
RegisterCommand({Name = "xenodg", Aliases = {"downgrade", "badexec"}, Description = "Reloads and downgrades the admin script because xeno shits itself using hooks."}, function() loadstringCmd("https://raw.githubusercontent.com/haileybae12/callumsscript/refs/heads/main/Main.lua", "Reloading xeno port from source...") end)
RegisterCommand({Name = "zoneui", Aliases = {"guns"}, Description = "Loads the Best Gun Giver for Zombie Zone" }, function() loadstringCmd("https://raw.githubusercontent.com/haileybae12/callumsscript/refs/heads/main/ZombieZone.lua", "Loaded") end)
RegisterCommand({Name = "ibtools", Aliases = {"btools"}, Description = "Upgraded Gui For Btools"}, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/PublicReleaseLua/refs/heads/main/ibtools.lua", "Loading Revamped Btools Gui") end)
RegisterCommand({Name = "ketamine", Aliases = {"kspy"}, Description = "Warning: may crash on xeno"}, function() loadstringCmd("https://raw.githubusercontent.com/haileybae12/callumsscript/refs/heads/main/remotes.lua", "Loading SimpleSpy...") end)
RegisterCommand({Name = "nocooldown", Aliases = {"ncd"}, Description = "Warning: Broken due to xeno."}, function() loadstringCmd("https://raw.githubusercontent.com/legalize8ga-maker/PublicReleaseLua/refs/heads/main/NocooldownsZombieUpd3.txt", "Loading Cooldownremover...") end)
RegisterCommand({Name = "scripts", Aliases = {"scriptsearch"}, Description = "May or may not work.."}, function() loadstringCmd("https://raw.githubusercontent.com/bloxtech1/luaprojects2/refs/heads/main/scriptsearcher.lua", "Loading Scripts.") end)
RegisterCommand({Name = "antiafk", Aliases = {"npcmode"}, Description = "Avoid being kicked for being idle."}, function() loadstringCmd("https://raw.githubusercontent.com/bloxtech1/luaprojects2/refs/heads/main/AutoPilotMode.lua", "Anti Afk loaded.") end)
RegisterCommand({Name = "scriptblox", Aliases = {}, Description = "Loads the script blox api."}, function() loadstringCmd("https://raw.githubusercontent.com/AZYsGithub/chillz-workshop/main/ScriptSearcher", "Loading API..") end)
RegisterCommand({Name = "freakyfling", Aliases = {"ffling"}, Description = "Loads the Kawaii. GUI"}, function() loadstringCmd("https://raw.githubusercontent.com/hellohellohell012321/KAWAII-FREAKY-FLING/main/kawaii_freaky_fling.lua", "Loading GUI..") end)
RegisterCommand({Name = "rem", Aliases = {}, Description = "In game exploit creation kit.."}, function() loadstringCmd("https://e-vil.com/anbu/rem.lua", "Loading Rem.") end)
RegisterCommand({Name = "copyconsole", Aliases = {copy}, Description = "In game exploit creation kit.."}, function() loadstringCmd("https://raw.githubusercontent.com/scriptlisenbe-stack/luaprojectse3/refs/heads/main/consolecopy.lua", "Copy Console Activated.") end)
RegisterCommand({Name = "simplespy", Aliases = {"ispy"}, Description = "Remote Functions"}, function() loadstringCmd("https://raw.githubusercontent.com/ltseverydayyou/uuuuuuu/main/simplee%20spyyy%20mobilee", "Loading SimpleSpy...") end)
function processCommand(message)
    if not (message:sub(1, #Prefix) == Prefix) then
        return false
    end
    local args = {}
    for word in message:sub(#Prefix + 1):gmatch("%S+") do
        table.insert(args, word)
    end
    if #args == 0 then
        return true
    end
    local cmdName = table.remove(args, 1):lower()
    local cmdFunc = Commands[cmdName]
    if cmdFunc then
        local success, err = pcall(cmdFunc, args)
        if not success then
            warn("Command Error:", err)
            DoNotif("Error: " .. tostring(err), 5)
        end
    else
    DoNotif("Unknown command: " .. cmdName, 3)
end
return true
end
for moduleName, module in pairs(Modules) do
    if type(module) == "table" and type(module.Initialize) == "function" then
        pcall(function()
        module:Initialize()
        print("Initialized module:", moduleName)
    end)
end
end
Modules.CommandBar:Initialize()
Modules.CommandList:Initialize()
local TextChatService = game:GetService("TextChatService")
if TextChatService then
    TextChatService.SendingMessage:Connect(function(messageObject)
    local wasCommand = processCommand(messageObject.Text)
    if wasCommand then
        messageObject.ShouldSend = false
    end
end)
else
LocalPlayer.Chatted:Connect(processCommand)
end
DoNotif("ZukaHub Initialized. Press ; to open.", 3)
