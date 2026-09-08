--```
-- 1. Ensure the game world is fully loaded before running the code
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

-- 2. Define the target script loading function
local function executeTargetScript()
    local success, content = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/f6PlayzOfficalAccount/Forsaken/refs/heads/main/ALL%20SHOW")
    end)
    if success and content then
        local compiled, err = loadstring(content)
        if compiled then 
            task.spawn(compiled) 
            print("[AUTO-EXEC] 'ALL SHOW' successfully loaded!")
        else
            warn("[AUTO-EXEC] Syntax error in GitHub code: " .. tostring(err))
        end
    else
        warn("[AUTO-EXEC] Failed to download script from GitHub.")
    end
end

-- Run it immediately for the current session
executeTargetScript()

-- 3. THE AUTO-EXECUTE ENGINE: Hook into teleports/rejoins
-- This watches for when the game attempts to transition servers
local queue_on_teleport = queue_on_teleport or (syn and syn.queue_on_teleport)

if queue_on_teleport then
    game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(State)
        if State == Enum.TeleportState.Started or State == Enum.TeleportState.InProgress then
            -- This forces the executor to remember this string and run it the EXACT millisecond the next server starts loading
            queue_on_teleport([[
                repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer
                local success, content = pcall(function()
                    return game:HttpGet("https://raw.githubusercontent.com/f6PlayzOfficalAccount/Forsaken/refs/heads/main/ALL%20SHOW")
                end)
                if success and content then
                    loadstring(content)()
                end
            ]])
        end
    end)
    print("[SUCCESS] Auto-Execute persistent hook is now ACTIVE. It will auto-load when rejoining/teleporting!")
else
    warn("[WARNING] Your executor does not support 'queue_on_teleport'. You must use the autoexec folder step instead.")
end
--```
