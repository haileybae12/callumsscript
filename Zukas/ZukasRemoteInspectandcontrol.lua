--// Description: The definitive RE tool. Features a ReplicatedStorage remote scanner, a deep
--// signal connection inspector, a remote blocker, and a remote firing utility. (v7 - Final Stability Patches)

--// --- Hooking & Blocking Core ---
local blockedRemotes = {}

local function SetupHooks()
    if not hookfunction or not getconnections then
        warn("[Remote Inspector] WARNING: Executor missing critical functions. Some features may fail.")
        return
    end

    --// THE FIX #1: Create temporary instances to hook, avoiding nil global variables.
    local tempEvent = Instance.new("RemoteEvent")
    local tempFunc = Instance.new("RemoteFunction")

    local originalFireServer; originalFireServer = hookfunction(tempEvent.FireServer, function(self, ...) if blockedRemotes[self] then return end return originalFireServer(self, ...) end)
    local originalInvokeServer; originalInvokeServer = hookfunction(tempFunc.InvokeServer, function(self, ...) if blockedRemotes[self] then return nil end return originalInvokeServer(self, ...) end)

    tempEvent:Destroy()
    tempFunc:Destroy()
    
    warn("[Remote Inspector] Hooks initialized successfully.")
end

--// --- Signal Inspection Core ---
function getconnections(signal)
    local connections = {}
    local upvalues = debug.getupvalues(signal.Connect)
    for i, upvalue in ipairs(upvalues) do
        if type(upvalue) == "table" and rawget(upvalue, "Next") then
            local connection = upvalue
            while connection do
                local info = { State = "Unknown", Function = "Unknown" }
                if type(connection) == "function" then
                    info.Function = connection; local d = debug.getinfo(connection); if d and d.source then info.Source, info.Line = d.source, d.linedefined end
                elseif type(connection) == "table" then
                    if connection.Handler then info.Function = connection.Handler; local d = debug.getinfo(connection.Handler); if d and d.source then info.Source, info.Line = d.source, d.linedefined end end
                    if connection.Enabled ~= nil then info.State = connection.Enabled and "Enabled" or "Disabled" elseif connection.Disabled ~= nil then info.State = not connection.Disabled and "Enabled" or "Disabled" end
                end
                table.insert(connections, info)
                connection = rawget(connection, "Next")
            end
            break
        end
    end
    return connections
end

--// --- UI Creation ---
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.ZIndexBehavior, ScreenGui.ResetOnSpawn = Enum.ZIndexBehavior.Global, false
local MainFrame = Instance.new("Frame", ScreenGui); MainFrame.Size, MainFrame.Position, MainFrame.BackgroundColor3, MainFrame.BorderColor3, MainFrame.Draggable, MainFrame.Active = UDim2.new(0, 850, 0, 450), UDim2.new(0.5, -425, 0.5, -225), Color3.fromRGB(35, 35, 45), Color3.fromRGB(80, 80, 120), true, true
local Header = Instance.new("Frame", MainFrame); Header.Size, Header.BackgroundColor3 = UDim2.new(1, 0, 0, 30), Color3.fromRGB(45, 45, 55)
local Title = Instance.new("TextLabel", Header); Title.Size, Title.BackgroundTransparency, Title.Font, Title.Text, Title.TextColor3, Title.TextSize = UDim2.new(1, 0, 1, 0), 1, Enum.Font.SourceSans, "Remote Inspector & Controller", Color3.new(1, 1, 1), 18
local RemoteListFrame = Instance.new("Frame", MainFrame); RemoteListFrame.Size, RemoteListFrame.Position, RemoteListFrame.BackgroundTransparency = UDim2.new(0, 300, 1, -40), UDim2.new(0, 10, 0, 35), 1
local RemoteListHeader = Instance.new("TextLabel", RemoteListFrame); RemoteListHeader.Size, RemoteListHeader.BackgroundTransparency, RemoteListHeader.Font, RemoteListHeader.Text, RemoteListHeader.TextColor3, RemoteListHeader.TextSize = UDim2.new(1, 0, 0, 20), 1, Enum.Font.SourceSansBold, "ReplicatedStorage Remotes", Color3.fromRGB(200, 200, 200), 14
local RemoteScrollingFrame = Instance.new("ScrollingFrame", RemoteListFrame); RemoteScrollingFrame.Size, RemoteScrollingFrame.Position, RemoteScrollingFrame.BackgroundColor3, RemoteScrollingFrame.BorderColor3, RemoteScrollingFrame.ScrollBarThickness = UDim2.new(1, 0, 1, -25), UDim2.new(0, 0, 0, 25), Color3.fromRGB(25, 25, 35), Color3.fromRGB(80, 80, 120), 6
local RemoteListLayout = Instance.new("UIListLayout", RemoteScrollingFrame); RemoteListLayout.Padding, RemoteListLayout.SortOrder = UDim.new(0, 3), Enum.SortOrder.LayoutOrder
local InspectorFrame = Instance.new("Frame", MainFrame); InspectorFrame.Size, InspectorFrame.Position, InspectorFrame.BackgroundTransparency = UDim2.new(1, -330, 1, -40), UDim2.new(0, 320, 0, 35), 1
local PathInput = Instance.new("TextBox", InspectorFrame); PathInput.Size, PathInput.Position, PathInput.BackgroundColor3, PathInput.BorderColor3, PathInput.Font, PathInput.Text, PathInput.TextColor3, PathInput.TextSize = UDim2.new(1, -110, 0, 30), UDim2.new(0, 0, 0, 5), Color3.fromRGB(25, 25, 35), Color3.fromRGB(80, 80, 120), Enum.Font.Code, "Select a remote...", Color3.fromRGB(220, 220, 220), 14; PathInput.ClearTextOnFocus = false
local InspectButton = Instance.new("TextButton", InspectorFrame); InspectButton.Size, InspectButton.Position, InspectButton.BackgroundColor3, InspectButton.Font, InspectButton.Text, InspectButton.TextColor3, InspectButton.TextSize = UDim2.new(0, 100, 0, 30), UDim2.new(1, -100, 0, 5), Color3.fromRGB(80, 80, 120), Enum.Font.SourceSansBold, "Inspect", Color3.new(1, 1, 1), 16
local ResultsScrollingFrame = Instance.new("ScrollingFrame", InspectorFrame); ResultsScrollingFrame.Size, ResultsScrollingFrame.Position, ResultsScrollingFrame.BackgroundColor3, ResultsScrollingFrame.BorderColor3, ResultsScrollingFrame.ScrollBarThickness = UDim2.new(1, 0, 1, -135), UDim2.new(0, 0, 0, 40), Color3.fromRGB(25, 25, 35), Color3.fromRGB(80, 80, 120), 6
local ResultsListLayout = Instance.new("UIListLayout", ResultsScrollingFrame); ResultsListLayout.Padding, ResultsListLayout.SortOrder = UDim.new(0, 5), Enum.SortOrder.LayoutOrder
local ActionsFrame = Instance.new("Frame", InspectorFrame); ActionsFrame.Size, ActionsFrame.Position, ActionsFrame.BackgroundColor3, ActionsFrame.BorderColor3 = UDim2.new(1, 0, 0, 90), UDim2.new(0, 0, 1, -90), Color3.fromRGB(40, 40, 50), Color3.fromRGB(80, 80, 120)
local ArgsInput = Instance.new("TextBox", ActionsFrame); ArgsInput.Size, ArgsInput.Position, ArgsInput.BackgroundColor3, ArgsInput.BorderColor3, ArgsInput.Font, ArgsInput.Text, ArgsInput.PlaceholderText, ArgsInput.TextColor3 = UDim2.new(1, -110, 0, 30), UDim2.new(0, 5, 0, 5), Color3.fromRGB(25, 25, 35), Color3.fromRGB(80, 80, 120), Enum.Font.Code, "", "Arguments: \"Hello\", 123", Color3.fromRGB(220, 220, 220)
local FireButton = Instance.new("TextButton", ActionsFrame); FireButton.Size, FireButton.Position, FireButton.BackgroundColor3, FireButton.Font, FireButton.Text, FireButton.TextColor3, FireButton.TextSize = UDim2.new(0, 100, 0, 30), UDim2.new(1, -105, 0, 5), Color3.fromRGB(120, 80, 80), Enum.Font.SourceSansBold, "Fire / Invoke", Color3.new(1, 1, 1), 14
local FireStatus = Instance.new("TextLabel", ActionsFrame); FireStatus.Size, FireStatus.Position, FireStatus.BackgroundTransparency, FireStatus.Font, FireStatus.Text, FireStatus.TextColor3, FireStatus.TextXAlignment = UDim2.new(1, -10, 0, 40), UDim2.new(0, 5, 0, 40), 1, Enum.Font.Code, "Status: Idle", Color3.fromRGB(200, 200, 200), Enum.TextXAlignment.Left

--// --- Core Logic ---
local function addResult(connection) local frame = Instance.new("Frame", ResultsScrollingFrame); frame.Size, frame.BackgroundColor3, frame.BorderColor3 = UDim2.new(1, 0, 0, 40), Color3.fromRGB(45, 45, 55), Color3.fromRGB(60, 60, 80); local src = Instance.new("TextLabel", frame); src.Size, src.Position, src.BackgroundTransparency, src.Font, src.Text, src.TextColor3, src.TextSize, src.TextXAlignment = UDim2.new(1, -100, 1, 0), UDim2.new(0, 5, 0, 0), 1, Enum.Font.Code, string.format("@%s (L%s)", connection.Source or "C/Unknown", connection.Line or "N/A"), Color3.fromRGB(200, 200, 200), 12, Enum.TextXAlignment.Left; local state = Instance.new("TextLabel", frame); state.Size, state.Position, state.BackgroundTransparency, state.Font, state.Text, state.TextColor3, state.TextSize, state.TextXAlignment = UDim2.new(0, 90, 1, 0), UDim2.new(1, -95, 0, 0), 1, Enum.Font.SourceSansBold, connection.State, (connection.State == "Enabled" and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)), 14, Enum.TextXAlignment.Right; end
local function scanAndPopulateRemotes() for _, child in ipairs(RemoteScrollingFrame:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end; for _, descendant in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then local entry = Instance.new("Frame", RemoteScrollingFrame); entry.Size, entry.BackgroundTransparency = UDim2.new(1, 0, 0, 22), 1; local btn = Instance.new("TextButton", entry); btn.Size, btn.BackgroundColor3, btn.Font, btn.Text, btn.TextSize, btn.TextXAlignment = UDim2.new(1, -65, 1, 0), Color3.fromRGB(45, 45, 55), Enum.Font.Code, "  "..descendant.Name, 12, Enum.TextXAlignment.Left; local block = Instance.new("TextButton", entry); block.Size, block.Position, block.BackgroundColor3, block.Font, block.Text, block.TextColor3 = UDim2.new(0, 60, 1, 0), UDim2.new(1, -60, 0, 0), Color3.fromRGB(120, 60, 60), Enum.Font.SourceSansBold, "Block", Color3.fromRGB(255, 255, 255); block.MouseButton1Click:Connect(function() blockedRemotes[descendant] = not blockedRemotes[descendant]; if blockedRemotes[descendant] then block.Text, block.BackgroundColor3 = "Unblock", Color3.fromRGB(60, 120, 60) else block.Text, block.BackgroundColor3 = "Block", Color3.fromRGB(120, 60, 60) end end); local fullPath = "game." .. descendant:GetFullName(); if descendant:IsA("RemoteEvent") then btn.TextColor3 = Color3.fromRGB(255, 180, 100); btn.MouseButton1Click:Connect(function() PathInput.Text = fullPath .. ".OnClientEvent"; task.spawn(inspectFunction) end) else btn.TextColor3, btn.Text = Color3.fromRGB(100, 120, 155), btn.Text .. " (Func)"; btn.MouseButton1Click:Connect(function() PathInput.Text = fullPath; for i,v in pairs(ResultsScrollingFrame:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end; addResult({Source="RemoteFunction callback", Line="N/A", State="Cannot Inspect"}) end) end end end; RemoteScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, (#RemoteScrollingFrame:GetChildren() - 1) * 25); end

local function inspectFunction()
    for i,v in pairs(ResultsScrollingFrame:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    
    --// THE FIX #2: More robust object retrieval and validation.
    local signal
    local success, result = pcall(function()
        local func = loadstring("return " .. PathInput.Text)
        if func then
            return func()
        end
        return nil
    end)

    if not success or typeof(result) ~= "Instance" then
        addResult({Source="ERROR", Line="N/A", State="Invalid Path"})
        return
    end
    
    signal = result
    
    if not signal:IsA("RBXScriptSignal") then
        addResult({Source="ERROR", Line="N/A", State="Not a Signal"})
        return
    end
    
    local conns = getconnections(signal)
    if #conns == 0 then addResult({Source="No connections found.", Line="", State="Empty"}) else for _,c in ipairs(conns) do addResult(c) end end
    ResultsScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, (#ResultsScrollingFrame:GetChildren() - 1) * 45)
end

local function fireFunction() local path = PathInput.Text:gsub(".OnClientEvent", ""); local remote; local s_remote, r_remote = pcall(function() return loadstring("return " .. path)() end); if not s_remote or not r_remote then FireStatus.Text, FireStatus.TextColor3 = "Status: Invalid remote path.", Color3.fromRGB(255,100,100); return end; remote = r_remote; local args = {}; local s_args, r_args = pcall(function() return loadstring("return {" .. ArgsInput.Text .. "}")() end); if not s_args then FireStatus.Text, FireStatus.TextColor3 = "Status: Invalid arguments format.", Color3.fromRGB(255,100,100); return end; args = r_args; local success, result; if remote:IsA("RemoteEvent") then success, result = pcall(function() remote:FireServer(table.unpack(args)) end) elseif remote:IsA("RemoteFunction") then success, result = pcall(function() return remote:InvokeServer(table.unpack(args)) end) end; if success then FireStatus.TextColor3 = Color3.fromRGB(100, 255, 100); if remote:IsA("RemoteFunction") then FireStatus.Text = "Invoke Success! Result: " .. tostring(result) else FireStatus.Text = "Fire Success!" end else FireStatus.TextColor3 = Color3.fromRGB(255, 100, 100); FireStatus.Text = "Status: Error - " .. tostring(result) end; end

--// --- Connections & Init ---
InspectButton.MouseButton1Click:Connect(inspectFunction)
FireButton.MouseButton1Click:Connect(fireFunction)
scanAndPopulateRemotes()

if game:IsLoaded() then task.spawn(SetupHooks) else game.Loaded:Connect(SetupHooks) end