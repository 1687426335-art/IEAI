local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function ModifyWeaponStats()
    local garbage = getgc(true)
    for _, tbl in pairs(garbage) do
        if type(tbl) == "table" then
            if rawget(tbl, "SHOOT_MODE") then
                rawset(tbl, "SHOOT_MODE", 2)
            end
            if rawget(tbl, "RPM") then
                rawset(tbl, "RPM", math.huge)
            end
            if rawget(tbl, "DAMAGE") then
                rawset(tbl, "DAMAGE", math.huge)
            end
        end
    end
    print("1")
end

local function SetupCharacter(char)
    local humanoid = char:WaitForChild("Humanoid")
 
    humanoid.Died:Connect(ModifyWeaponStats)
end

if LocalPlayer.Character then
    SetupCharacter(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(SetupCharacter)

task.wait(0.2)
ModifyWeaponStats()
--下面的这个是无限子弹上面的是射速
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

task.spawn(function()
    while RunService.Heartbeat:Wait() do
        local characterFolder = workspace:FindFirstChild("Characters") and workspace.Characters:FindFirstChild(LocalPlayer.Name)
        if not characterFolder then continue end

        for _, gun in ipairs(characterFolder:GetChildren()) do
            local config = gun:FindFirstChild("Config")
            if not config then continue end
            
            local Ammo = config:FindFirstChild("Ammo")
            local TotalAmmo = config:FindFirstChild("TotalAmmo")

            if Ammo then
                Ammo.Value = math.huge
            end
            if TotalAmmo then
                TotalAmmo.Value = math.huge
            end
        end
    end
end)
print("1")
