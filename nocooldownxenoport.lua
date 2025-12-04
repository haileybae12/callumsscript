-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Configuration
local MODULE_WAIT_TIMEOUT = 15 -- Max seconds to wait for a module to exist.

--[[
    @function patchModule
    @description Safely finds a ModuleScript, requires it, and applies a patch function.
    @param modulePath {string} The path to the module from ReplicatedStorage, e.g., "Modules.Items.Shovel"
    @param patchFunction {function} The function that will be executed with the required module as its argument.
]]
local function patchModule(modulePath, patchFunction)
    -- Use WaitForChild to patiently wait for the module to replicate from the server.
    -- This is the most critical fix for environments like Xeno.
    local moduleInstance = ReplicatedStorage:WaitForChild(modulePath, MODULE_WAIT_TIMEOUT)

    if not moduleInstance then
        warn(("[PATCHER_ERROR]: Timed out waiting for module: ReplicatedStorage.%s"):format(modulePath))
        return false
    end

    -- Wrap the require and patch logic in a pcall for maximum safety.
    local success, result = pcall(function()
        -- Require the module to get its table of functions/data.
        local requiredModule = require(moduleInstance)
        -- Execute the specific patch logic.
        patchFunction(requiredModule)
    end)

    if success then
        print(("[PATCHER]: Successfully applied patch to module: %s"):format(modulePath))
    else
        warn(("[PATCHER_ERROR]: Failed to apply patch to module %s. Error: %s"):format(modulePath, tostring(result)))
    end
    
    return success
end

-- ==================================================================================
-- //                           APPLYING ALL PATCHES                               //
-- ==================================================================================

-- // Patch 1: Bypass Global Melee Cooldown
patchModule("Modules.MeleeFunctions", function(MeleeFunctions)
    -- Hooking is more robust than direct replacement.
    -- This intercepts any call to CheckForCooldown and forces it to return false.
    hookfunction(MeleeFunctions.CheckForCooldown, function()
        return false -- Instantly tells the game there is no cooldown.
    end)

    -- Replace AddCooldown with an empty function so it does nothing.
    MeleeFunctions.AddCooldown = function() end
end)


-- // Patch 2: Increase Shovel Attack Speed
patchModule("Modules.Items.Shovel", function(ShovelModule)
    local originalShovelNew = ShovelModule.new
    
    -- We hook the constructor (.new) for the shovel.
    ShovelModule.new = function(...)
        -- Call the original function to create the shovel object as the game expects.
        local shovelObject = originalShovelNew(...)
        
        -- Modify the created object before the game can use it.
        if shovelObject and shovelObject.AnimationTracks and shovelObject.AnimationTracks.Attack then
            -- Increasing the animation speed directly speeds up the attack.
            shovelObject.AnimationTracks.Attack.Speed = 1.75 -- Increased from 1.30 for a more noticeable effect
        end
        
        -- Return the modified object.
        return shovelObject
    end
end)


-- // Patch 3: Bypass Spit Cooldown and Improve Aiming
patchModule("Modules.Items.Spit", function(SpitModule)
    -- This patch completely replaces the FireGun logic to remove any internal cooldowns
    -- and improve aiming to follow the mouse cursor perfectly.
    SpitModule.FireGun = function(spitObject, mouseX, mouseY)
        local localPlayer = Players.LocalPlayer
        if not (localPlayer and localPlayer.Character and localPlayer.Character:FindFirstChild("Head")) then return end

        local headPosition = localPlayer.Character.Head.Position
        local camera = workspace.CurrentCamera

        -- Raycast from the camera to the mouse position to get a precise 3D aim point.
        local cameraRay = camera:ScreenPointToRay(mouseX, mouseY)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        raycastParams.FilterDescendantsInstances = { localPlayer.Character }
        
        local raycastResult = workspace:Raycast(cameraRay.Origin, cameraRay.Direction * 1000, raycastParams)
        local aimPosition = raycastResult and raycastResult.Position or (cameraRay.Origin + cameraRay.Direction * 1000)

        -- Fire the remote event directly, bypassing any client-side checks.
        ReplicatedStorage.Remotes.ZombieRelated.AcidSpit:FireServer(headPosition, aimPosition)

        -- Replicate the visual effect locally for instant feedback.
        local directionVector = aimPosition - headPosition
        local projectileMagnitude = directionVector.Magnitude
        if projectileMagnitude > 41 then
            directionVector = directionVector.Unit * 40
            projectileMagnitude = 40
        end

        local timeToTarget = math.log(1.001 + projectileMagnitude * 0.01)
        local projectileVelocity = directionVector / timeToTarget + Vector3.new(0, workspace.Gravity * 0.5 * timeToTarget, 0)
        
        -- The visual function might not be available in all contexts, wrap it.
        pcall(require(ReplicatedStorage.VisualFunctions.AcidProjectile), headPosition, projectileVelocity)
    end
end)

print("[PATCHER]: All patch attempts have been deployed.")
