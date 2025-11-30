--[[


all items with varients/level table. by zuka


--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LOCAL_PLAYER = Players.LocalPlayer

local function hookGamepassChecker()
    print("--> V42.1: Attempting to hook gamepass check function...")
    local modulesFolder = ReplicatedStorage:FindFirstChild("modules")
    if not (modulesFolder and modulesFolder:FindFirstChild("gamepasses")) then
        warn("--> V42.1 Hooking FAILED: 'gamepasses' module not found.")
        return
    end
    
    local success, gamepassModule = pcall(function() return require(modulesFolder.gamepasses) end)
    
    if not success then
        warn("--> V42.1 Hooking FAILED: Could not require the 'gamepasses' module.", gamepassModule)
        return
    end
    
    for key, value in pairs(gamepassModule) do
        if type(value) == "function" then
            local success_hook, err = pcall(function()
                hookfunction(value, function(...) return true end)
            end)
            if success_hook then
                print("--> V42.1 Hooking SUCCESS: Gamepass ownership check at key '"..tostring(key).."' has been hooked.")
                return
            else
                warn("--> V42.1 Hooking FAILED: 'hookfunction' is not available or failed.", err)
                return
            end
        end
    end
    warn("--> V42.1 Hooking FAILED: No function found within the 'gamepasses' module to hook.")
end


local masterWeaponMap, perkDatabase, variantDatabase, isInitialized = {}, {}, {}, false
local selectedWeapon, perkControls = nil, {}
local screenGui = Instance.new("ScreenGui"); screenGui.Name = "MasterEquipperGUI_V42_1"; screenGui.ResetOnSpawn = false; screenGui.Parent = LOCAL_PLAYER:WaitForChild("PlayerGui")
local mainFrame = Instance.new("Frame"); mainFrame.Size = UDim2.new(0, 700, 0, 500); mainFrame.Position = UDim2.new(0.5, -350, 0.5, -250); mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); mainFrame.BorderColor3 = Color3.fromRGB(80, 80, 80); mainFrame.Active = true; mainFrame.Draggable = true; mainFrame.Visible = false; mainFrame.Parent = screenGui
local titleLabel = Instance.new("TextLabel", mainFrame); titleLabel.Size = UDim2.new(1, 0, 0, 30); titleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40); titleLabel.Text = "Master Equipper V42.1 (Syntax Hotfix)"; titleLabel.Font = Enum.Font.SourceSansBold; titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255); titleLabel.TextSize = 18
local weaponPanel = Instance.new("Frame", mainFrame); weaponPanel.Size = UDim2.new(0, 250, 1, -30); weaponPanel.Position = UDim2.new(0, 0, 0, 30); weaponPanel.BackgroundColor3 = Color3.fromRGB(35, 35, 35); weaponPanel.BorderSizePixel = 0
local searchBox = Instance.new("TextBox", weaponPanel); searchBox.Size = UDim2.new(1, -10, 0, 30); searchBox.Position = UDim2.new(0, 5, 0, 5); searchBox.PlaceholderText = "Search Weapons..."; searchBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25); searchBox.TextColor3 = Color3.fromRGB(220, 220, 220)
local weaponList = Instance.new("ScrollingFrame", weaponPanel); weaponList.Size = UDim2.new(1, 0, 1, -40); weaponList.Position = UDim2.new(0, 0, 0, 40); weaponList.BackgroundColor3 = Color3.fromRGB(35, 35, 35); weaponList.ScrollBarThickness = 6
local weaponListLayout = Instance.new("UIListLayout", weaponList); weaponListLayout.Padding = UDim.new(0, 2); weaponListLayout.SortOrder = Enum.SortOrder.Name
local configPanel = Instance.new("Frame", mainFrame); configPanel.Size = UDim2.new(1, -260, 1, -40); configPanel.Position = UDim2.new(0, 260, 0, 35); configPanel.BackgroundColor3 = Color3.fromRGB(45, 45, 45); configPanel.BorderSizePixel = 0
local selectedWeaponLabel = Instance.new("TextLabel", configPanel); selectedWeaponLabel.Size = UDim2.new(1, -10, 0, 30); selectedWeaponLabel.Position = UDim2.new(0, 5, 0, 5); selectedWeaponLabel.Font = Enum.Font.SourceSansBold; selectedWeaponLabel.Text = "Selected: None"; selectedWeaponLabel.TextColor3 = Color3.fromRGB(255, 255, 255); selectedWeaponLabel.TextSize = 18; selectedWeaponLabel.TextXAlignment = Enum.TextXAlignment.Left
local rarityLabel = Instance.new("TextLabel", configPanel); rarityLabel.Size = UDim2.new(0.5, -10, 0, 20); rarityLabel.Position = UDim2.new(0, 5, 0, 40); rarityLabel.Text = "Rarity:"; rarityLabel.TextColor3 = Color3.fromRGB(200,200,200); rarityLabel.BackgroundTransparency=1; rarityLabel.TextXAlignment = Enum.TextXAlignment.Left
local levelLabel = Instance.new("TextLabel", configPanel); levelLabel.Size = UDim2.new(0.5, -10, 0, 20); levelLabel.Position = UDim2.new(0.5, 5, 0, 40); levelLabel.Text = "Level:"; levelLabel.TextColor3 = Color3.fromRGB(200,200,200); levelLabel.BackgroundTransparency=1; levelLabel.TextXAlignment = Enum.TextXAlignment.Left
local levelInput = Instance.new("TextBox", configPanel); levelInput.Size = UDim2.new(0.5, -10, 0, 30); levelInput.Position = UDim2.new(0.5, 5, 0, 60); levelInput.Text = "800"; levelInput.BackgroundColor3 = Color3.fromRGB(30,30,30); levelInput.TextColor3 = Color3.fromRGB(220,220,220)
local perkList = Instance.new("ScrollingFrame", configPanel); perkList.Size = UDim2.new(0.5, -10, 1, -100); perkList.Position = UDim2.new(0, 5, 0, 100); perkList.BackgroundColor3 = Color3.fromRGB(35,35,35); perkList.ScrollBarThickness = 4
local perkListLayout = Instance.new("UIListLayout", perkList); perkListLayout.Padding = UDim.new(0, 5)
local variantList = Instance.new("ScrollingFrame", configPanel); variantList.Size = UDim2.new(0.5, -10, 1, -100); variantList.Position = UDim2.new(0.5, 5, 0, 100); variantList.BackgroundColor3 = Color3.fromRGB(35,35,35); variantList.ScrollBarThickness = 4
local equipButton = Instance.new("TextButton", mainFrame); equipButton.Name = "EquipButton"; equipButton.Size = UDim2.new(1, -270, 0, 30); equipButton.Position = UDim2.new(0, 260, 1, -35); equipButton.BackgroundColor3 = Color3.fromRGB(83, 12, 255); equipButton.Font = Enum.Font.SourceSansBold; equipButton.Text = "CONSTRUCT & EQUIP"; equipButton.TextColor3 = Color3.fromRGB(255, 255, 255); equipButton.TextSize = 16
local rarityDropdown, variantDropdown;

local function createSlider(parent, name, minValue, maxValue, initialValue) local sliderData = { Value = initialValue or 0 }; local container = Instance.new("Frame", parent); container.Size = UDim2.new(1, 0, 0, 50); container.BackgroundTransparency = 1; container.LayoutOrder = 1; local nameLabel = Instance.new("TextLabel", container); nameLabel.Size = UDim2.new(1, -50, 0, 20); nameLabel.Position = UDim2.new(0, 5, 0, 5); nameLabel.Text = name; nameLabel.TextColor3 = Color3.fromRGB(200,200,200); nameLabel.BackgroundTransparency = 1; nameLabel.TextXAlignment = Enum.TextXAlignment.Left; nameLabel.Font = Enum.Font.SourceSans; nameLabel.TextSize = 14; local valueLabel = Instance.new("TextLabel", container); valueLabel.Size = UDim2.new(0, 40, 0, 20); valueLabel.Position = UDim2.new(1, -45, 0, 5); valueLabel.Text = "0"; valueLabel.TextColor3 = Color3.fromRGB(200,200,200); valueLabel.BackgroundTransparency = 1; valueLabel.TextXAlignment = Enum.TextXAlignment.Right; valueLabel.Font = Enum.Font.SourceSans; valueLabel.TextSize = 14; local track = Instance.new("Frame", container); track.Size = UDim2.new(1, -10, 0, 6); track.Position = UDim2.new(0, 5, 0, 30); track.BackgroundColor3 = Color3.fromRGB(25, 25, 25); track.BorderSizePixel = 0; Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0); local handle = Instance.new("TextButton", track); handle.Size = UDim2.new(0, 12, 0, 12); handle.Position = UDim2.new(0, 0, 0.5, 0); handle.AnchorPoint = Vector2.new(0.5, 0.5); handle.BackgroundColor3 = Color3.fromRGB(120, 120, 120); handle.Text = ""; handle.ZIndex = 2; Instance.new("UICorner", handle).CornerRadius = UDim.new(1, 0); local isDragging = false; handle.MouseButton1Down:Connect(function() isDragging = true end); UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = false end end); local function updateSlider(percentage) handle.Position = UDim2.fromScale(percentage, 0.5); sliderData.Value = math.floor(minValue + (maxValue - minValue) * percentage); valueLabel.Text = tostring(sliderData.Value) end; RunService.Heartbeat:Connect(function() if isDragging then local mouseX = UserInputService:GetMouseLocation().X; local trackStart = track.AbsolutePosition.X; local trackWidth = track.AbsoluteSize.X; local percentage = math.clamp((mouseX - trackStart) / trackWidth, 0, 1); updateSlider(percentage) end end); local function setValue(newValue) local clampedValue = math.clamp(newValue, minValue, maxValue); if (maxValue - minValue) == 0 then return end; local percentage = (clampedValue - minValue) / (maxValue - minValue); updateSlider(percentage) end; setValue(sliderData.Value); return { GetValue = function() return sliderData.Value end, SetValue = setValue } end

local dropdownModule = {}
function dropdownModule.new(parent, position, size, options)
    local self = {};
    local selectedValue = options[1] or "None";
    local dropdownFrame = Instance.new("Frame", parent); dropdownFrame.Position = position; dropdownFrame.Size = size; dropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); dropdownFrame.BorderSizePixel = 1; dropdownFrame.BorderColor3 = Color3.fromRGB(80, 80, 80); dropdownFrame.ZIndex = 3;
    local mainButton = Instance.new("TextButton", dropdownFrame); mainButton.Size = UDim2.new(1, 0, 1, 0); mainButton.Text = ""; mainButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45);
    local mainButtonLabel = Instance.new("TextLabel", mainButton); mainButtonLabel.Size=UDim2.new(1, -5, 1, 0); mainButtonLabel.Position=UDim2.new(0,5,0,0); mainButtonLabel.Text=selectedValue; mainButtonLabel.TextColor3=Color3.fromRGB(220,220,220); mainButtonLabel.Font=Enum.Font.SourceSans; mainButtonLabel.TextSize=14; mainButtonLabel.BackgroundTransparency=1; mainButtonLabel.TextXAlignment = Enum.TextXAlignment.Left;
    local optionsList = Instance.new("ScrollingFrame", dropdownFrame); optionsList.Size = UDim2.new(1, 0, 4, 0); optionsList.Position = UDim2.new(0, 0, 1, 0); optionsList.BackgroundColor3 = Color3.fromRGB(30, 30, 30); optionsList.BorderColor3 = Color3.fromRGB(80, 80, 80); optionsList.ScrollBarThickness = 5; optionsList.Visible = false; optionsList.ZIndex = 4;
    local listLayout = Instance.new("UIListLayout", optionsList); listLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    
    function self:UpdateOptions(newOptions)
        for _, c in ipairs(optionsList:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        for i, optionName in ipairs(newOptions) do
            local optionButton = Instance.new("TextButton", optionsList); optionButton.Size = UDim2.new(1, 0, 0, 25); optionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45); optionButton.TextColor3 = Color3.fromRGB(200, 200, 200); optionButton.Font = Enum.Font.SourceSans; optionButton.TextSize = 14; optionButton.Text = "  " .. optionName; optionButton.LayoutOrder = i; optionButton.TextXAlignment = Enum.TextXAlignment.Left;
            optionButton.MouseButton1Click:Connect(function() selectedValue = optionName; mainButtonLabel.Text = optionName; optionsList.Visible = false end)
        end
        task.wait(); optionsList.CanvasSize = UDim2.fromOffset(0, listLayout.AbsoluteContentSize.Y)
    end
    
    function self:SetSelectedOption(optionName)
        selectedValue = optionName; mainButtonLabel.Text = optionName;
    end
    
    self.GetSelectedOption = function() return selectedValue end
    
    mainButton.MouseButton1Click:Connect(function() optionsList.Visible = not optionsList.Visible end)
    
    self:UpdateOptions(options)
    return self
end
rarityDropdown = dropdownModule.new(configPanel, UDim2.new(0, 5, 0, 60), UDim2.new(0.5, -10, 0, 30), {"basic", "standard", "improved", "refined", "advanced", "calibrated", "elite", "masterwork", "ascendant"})


local function updateVariantDropdown(weaponName) local opts = {"None"}; if variantDatabase[weaponName] then for _, vName in ipairs(variantDatabase[weaponName]) do table.insert(opts, vName) end end; variantDropdown:UpdateOptions(opts); variantDropdown:SetSelectedOption("None") end
local function initializeFirstTime()
    if isInitialized then return true end; print("--> V42.1: Initializing...")
    hookGamepassChecker()
    local modulesFolder = ReplicatedStorage:FindFirstChild("modules"); if not modulesFolder then warn("--> CRITICAL: 'modules' folder not found."); return false end
    pcall(function() masterWeaponMap = require(modulesFolder:WaitForChild("itemData")) end)
    pcall(function() perkDatabase = require(modulesFolder:WaitForChild("upgradeData")).upgrades end)
    local assets = ReplicatedStorage:FindFirstChild("assets"); if assets and assets:FindFirstChild("variants") then for _, wFolder in ipairs(assets.variants:GetChildren()) do local wName = wFolder.Name; variantDatabase[wName] = {}; for _, v in ipairs(wFolder:GetChildren()) do table.insert(variantDatabase[wName], v.Name) end end end
    for _, c in ipairs(perkList:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end; perkControls = {}
    local sortedPerks = {}; for n in pairs(perkDatabase) do table.insert(sortedPerks, n) end; table.sort(sortedPerks)
    for _, pName in ipairs(sortedPerks) do if type(perkDatabase[pName]) == "table" then perkControls[pName] = createSlider(perkList, pName, 0, perkDatabase[pName].maxUpgrades or 1, 0) end end
    local vTitle = Instance.new("TextLabel", variantList); vTitle.Size = UDim2.new(1,0,0,20); vTitle.Text = "Weapon Variant"; vTitle.TextColor3=Color3.fromRGB(200,200,200); vTitle.BackgroundTransparency=1; vTitle.TextXAlignment=Enum.TextXAlignment.Left
    variantDropdown = dropdownModule.new(variantList, UDim2.new(0,0,0,25), UDim2.new(1,0,0,30), {"None"})
    for _, b in ipairs(weaponList:GetChildren()) do if b:IsA("TextButton") then b:Destroy() end end
    local sortedWeapons = {}; for n, d in pairs(masterWeaponMap) do if d.itemType == "weapons" then table.insert(sortedWeapons, n) end end; table.sort(sortedWeapons)
    for _, name in ipairs(sortedWeapons) do
        local btn = Instance.new("TextButton", weaponList); btn.Size=UDim2.new(1,-10,0,25); btn.Text="  "..name; btn.BackgroundColor3=Color3.fromRGB(50,50,50); btn.TextColor3=Color3.fromRGB(220,220,220); btn.TextXAlignment=Enum.TextXAlignment.Left; btn.Font = Enum.Font.SourceSans; btn.TextSize = 14
        btn.MouseButton1Click:Connect(function() selectedWeapon=name; selectedWeaponLabel.Text="Selected: "..name; for _,s in pairs(perkControls) do s:SetValue(0) end; updateVariantDropdown(name) end)
    end
    task.wait(); weaponList.CanvasSize = UDim2.fromOffset(0, weaponListLayout.AbsoluteContentSize.Y); perkList.CanvasSize = UDim2.fromOffset(0, perkListLayout.AbsoluteContentSize.Y)
    print("--> V42.1: Database built and GUI populated."); isInitialized = true; return true
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function() if not isInitialized then initializeFirstTime() end; local f=searchBox.Text:lower(); for _,b in ipairs(weaponList:GetChildren()) do if b:IsA("TextButton") then b.Visible = f=="" or b.Text:lower():find(f,1,true) end end; task.wait(); weaponList.CanvasSize=UDim2.fromOffset(0,weaponListLayout.AbsoluteContentSize.Y) end)

local function verifyWeaponConstruction(weaponName)
    print(`--> Verifying construction of '{weaponName}'...`)
    print("--> Waiting for Player.data folder to be created...")
    local playerData = LOCAL_PLAYER:WaitForChild("data", 5)
    if not playerData then warn("--> Verification FAILED: Player 'data' folder did not appear within 5 seconds."); return end
    print("--> Player.data found. Waiting for exaltedWeapons table...")
    local exaltedWeapons = playerData:WaitForChild("exaltedWeapons", 2)
    if not exaltedWeapons then warn("--> Verification FAILED: 'exaltedWeapons' table did not appear within 2 seconds."); return end
    if exaltedWeapons:FindFirstChild(weaponName) then print("--> SUCCESS: Construction confirmed in local data.") else warn("--> FAILED: Weapon entry did not appear in local data. (This is expected for unowned gamepass items).") end
end

equipButton.MouseButton1Click:Connect(function()
    if not isInitialized then if not initializeFirstTime() then warn("Init failed."); return end end
    if not selectedWeapon then return end
    print("--> V42.1: Locating remotes via confirmed paths...")
    local eventsFolder = ReplicatedStorage:WaitForChild("events", 5); if not eventsFolder then warn("--> CRITICAL: 'events' folder not found."); return end
    local remotes = { reroll=eventsFolder:FindFirstChild("rerollItem"), equip=eventsFolder:FindFirstChild("equipItem"), upgrade=eventsFolder:FindFirstChild("purchaseUpgrade"), infuse=eventsFolder:FindFirstChild("infuseExaltedWeapon") }
    if not (remotes.reroll and remotes.equip and remotes.upgrade and remotes.infuse) then warn("--> CRITICAL: One or more remotes missing. Injection aborted."); return end
    print("--> All remotes located.")
    local weaponData = {perkData = {}, rarity = rarityDropdown.GetSelectedOption(), level = math.clamp(tonumber(levelInput.Text) or 800, 1, 800), attributes = {}}
    pcall(function() remotes.reroll:InvokeServer(selectedWeapon, weaponData) end); print("--> Fired Reroll.")
    task.wait(0.2); pcall(function() remotes.equip:InvokeServer(selectedWeapon) end); print("--> Fired Equip.")
    task.wait(0.3)
    for perkName, slider in pairs(perkControls) do
        for i = 1, slider:GetValue() do pcall(function() remotes.upgrade:FireServer(selectedWeapon, perkName) end); task.wait(0.05) end
    end
    print("--> Perk upgrade sequence complete.")
    local selectedVariant = variantDropdown:GetSelectedOption()
    if selectedVariant and selectedVariant ~= "None" then
        pcall(function() remotes.infuse:FireServer(selectedWeapon, selectedVariant) end)
        print(`--> Fired Infuse for variant: "{selectedVariant}"`)
    end
    print("--> Injection sequence complete."); task.delay(1, function() verifyWeaponConstruction(selectedWeapon) end)
end)

UserInputService.InputBegan:Connect(function(input, gpe) if not gpe and input.KeyCode == Enum.KeyCode.RightControl then mainFrame.Visible = not mainFrame.Visible; if mainFrame.Visible then initializeFirstTime() end end end)
print("hell yeah, gg."); print("That was ez pz , now press [RIGHT CONTROL] to toggle the gui")