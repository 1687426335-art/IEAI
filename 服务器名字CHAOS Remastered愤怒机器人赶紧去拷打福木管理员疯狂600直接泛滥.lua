local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local loopConnection = nil
local selectedSoundId = "rbxassetid://8679627751"
local AURA_RANGE = 90
local soundList = {
    "rbxassetid://8679627751",
    "rbxassetid://3125624765",
    "rbxassetid://17755696142",
    "rbxassetid://10070796384"
}

local function GetHitFunction()
    local char = LocalPlayer.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local remotes = tool:FindFirstChild("Remotes")
            if remotes then
                local hitFunc = remotes:FindFirstChild("HitFunction")
                if hitFunc then
                    return hitFunc
                end
            end
        end
    end
    return nil
end

local function GetEnemiesInRange()
    local enemies = {}
    local myChar = LocalPlayer.Character
    if not myChar then return enemies end
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return enemies end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character.Parent then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
                if targetHrp then
                    local dist = (myHrp.Position - targetHrp.Position).Magnitude
                    if dist <= AURA_RANGE then
                        table.insert(enemies, player)
                    end
                end
            end
        end
    end
    return enemies
end

local hue = 0
local function GetRainbowColor()
    hue = (hue + 0.02) % 1
    return Color3.fromHSV(hue, 1, 1)
end

local function DrawTrajectory(origin, targetPos)
    local color = GetRainbowColor()
    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
    part.Material = Enum.Material.Neon
    part.Color = color
    local distance = (origin - targetPos).Magnitude
    if distance < 0.1 then return end
    part.Size = Vector3.new(0.1, 0.1, distance)
    part.CFrame = CFrame.lookAt(origin, targetPos) * CFrame.new(0, 0, -distance / 2)
    part.Parent = workspace
    Debris:AddItem(part, 0.3)
end

local function PlayShootSound()
    local sound = Instance.new("Sound")
    sound.SoundId = selectedSoundId
    sound.Volume = 1
    sound.Parent = LocalPlayer.Character or workspace
    sound:Play()
    task.delay(1, function() sound:Destroy() end)
end

local function AttackEnemy(targetPlayer, hitFunction)
    local targetChar = targetPlayer.Character
    if not targetChar then return end
    local hitPart = targetChar:FindFirstChild("Left Arm") or targetChar:FindFirstChild("Right Arm") or targetChar:FindFirstChild("Head") or targetChar:FindFirstChild("HumanoidRootPart")
    if not hitPart then return end
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end
    local origin = myHrp.Position
    local targetPos = hitPart.Position
    DrawTrajectory(origin, targetPos)
    PlayShootSound()
    local args = {
        targetChar,
        hitPart,
        Vector3.new(1, 2, 1)
    }
    pcall(function()
        hitFunction:InvokeServer(unpack(args))
    end)
end

local function KillAuraLoop()
    local hitFunction = GetHitFunction()
    if not hitFunction then return end
    local enemies = GetEnemiesInRange()
    for _, enemy in ipairs(enemies) do
        task.spawn(AttackEnemy, enemy, hitFunction)
        task.wait(0.03)
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    print("1")
end)
loopConnection = RunService.Heartbeat:Connect(KillAuraLoop)