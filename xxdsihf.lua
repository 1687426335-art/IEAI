local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local f = loadstring(game:HttpGet("https://raw.githubusercontent.com/FengYu-X/FengYu-ui/refs/heads/main/UI.lua"))()
local window = f.CreateWindow(f, {
    Subtitle = "脚本作者 无解 | QQ:3490168468",
    Title = "GND Hub",
    Icon = "104645605199482",
    Keybind = Enum.KeyCode.RightControl
})

local mainTab = window:Tab("[主要]", "1847190174")
local mainSection = mainTab:Section("主要功能", "1847190174", true)

mainSection:Button("传送所有人", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/3490168468w-dotcom/GND-HUB/main/%E4%BC%A0%E9%80%81%E6%89%80%E6%9C%89%E4%BA%BA%E5%85%AC%E5%BC%80"))()
end)

mainSection:Button("黑闪秒杀", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/3490168468w-dotcom/GND-HUB/main/%E9%BB%91%E9%97%AA%E7%A7%92%E6%9D%80"))()
end)

mainSection:Button("飞行V3 GND", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/3490168468w-dotcom/GND-HUB/main/Fly%20V3%20GND"))()
end)

local playerESPTab = window:Tab("[玩家ESP]", "1847190174")
local npcESPTab = window:Tab("[NPC ESP]", "1847190174")
local otherESPTab = window:Tab("[透视其他]", "1847190174")
local aimbotTab = window:Tab("[自瞄]", "1847190174")
local bulletTrackTab = window:Tab("[子弹追踪]", "1847190174")

local playerESPSection = playerESPTab:Section("玩家ESP设置", "1847190174", true)
local npcESPSection = npcESPTab:Section("NPC ESP设置", "1847190174", true)
local otherESPSection = otherESPTab:Section("其他透视设置", "1847190174", true)
local aimbotSection = aimbotTab:Section("自瞄设置", "1847190174", true)
local bulletTrackSection = bulletTrackTab:Section("子弹追踪设置", "1847190174", true)
local weaponModSection = bulletTrackTab:Section("枪械修改", "1847190174", true)
autoShootSection = bulletTrackTab:Section("自动射击 需要开启子追", "1847190174", true)

local playerESPEnabled = false
local nameESPEnabled = false
local healthESPEnabled = false
local distanceESPEnabled = false
local boxESPEnabled = false
local glowESPEnabled = false
local tracerEnabled = false
local maxDistance = 150
local playerColor = Color3.fromRGB(255, 0, 0)
local teamColor = Color3.fromRGB(0, 255, 0)
local enemyColor = Color3.fromRGB(255, 0, 0)
local npcColor = Color3.fromRGB(0, 255, 0)
local npcGlowColor = Color3.fromRGB(255, 105, 180)
local deadBodyColor = Color3.fromRGB(128, 128, 128)
local deadBodyESPEnabled = false
local deadBodyPermanent = false
local deadBodyCleanupTime = 10
local deadBodyMaxDistance = 1000

local playerESPObjects = {}
local npcESPObjects = {}
local deadBodyESPObjects = {}
local extractionESPObjects = {}

local aimbotEnabled = false
local aimbotSmoothness = 0.25
local aimbotFOV = 150
local aimbotAimPart = "Head"
local aimbotIgnoreTeammates = true
local aimbotOnlyEnemies = false
local aimbotThroughWalls = false
local aimbotShowFOV = false
local aimbotFOVCircle = nil

local bulletTrackEnabled = false
local bulletTrackRange = 5000
local bulletTrackLockOn = true
local bulletTrackShowLine = true
local bulletTrackLine = nil
local bulletTrackTarget = nil
local bulletTrackTargetVisible = false

local autoShootEnabled = false
local autoShootDelay = 50
local autoShootChance = 100
local autoShootShowEffect = false

local noRecoilEnabled = false
local instantAimEnabled = false
local bulletBoostEnabled = false
local fireRateEnabled = false
local fireRateValue = 0.5
local fullAutoEnabled = false

local originalWeaponAttributes = {}
local originalFireRateValues = {}
local originalFireRateMap = {}

local bossDetectionEnabled = false
local bossDetectionScanning = false
local bossDetectionTask = nil
local detectedBosses = {}

local function getPlayerHealth(character)
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        return humanoid.Health
    end
    local healthValue = character:FindFirstChild("Health")
    if healthValue and (healthValue:IsA("NumberValue") or healthValue:IsA("IntValue")) then
        return healthValue.Value
    end
    local healthAttr = character:GetAttribute("Health")
    if healthAttr then
        return healthAttr
    end
    return nil
end

local function getCharacterPosition(character)
    if character:IsA("Model") then
        local head = character:FindFirstChild("Head")
        if head and head:IsA("BasePart") then
            return head.Position
        end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp and hrp:IsA("BasePart") then
            return hrp.Position
        end
        local primaryPart = character.PrimaryPart
        if primaryPart then
            return primaryPart.Position
        end
    end
    return nil
end

local function getAimPart(character)
    local head = character:FindFirstChild("Head")
    if head and head:IsA("BasePart") then
        return head
    end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp and hrp:IsA("BasePart") then
        return hrp
    end
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("BasePart") then
            return child
        end
    end
    return nil
end

local function isEnemy(player)
    if player == LocalPlayer then
        return false
    end
    if aimbotIgnoreTeammates and LocalPlayer.Team and player.Team == LocalPlayer.Team then
        return false
    end
    return true
end

local function isVisible(part)
    local origin = Camera.CFrame.Position
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LocalPlayer.Character, part.Parent}
    params.IgnoreWater = true
    local result = workspace:Raycast(origin, part.Position - origin, params)
    return result == nil or result.Instance:IsDescendantOf(part.Parent)
end

local function createPlayerESP(character)
    if character == LocalPlayer.Character then
        return
    end
    if not character or not character.Parent then
        return
    end
    if playerESPObjects[character] then
        return
    end
    local attachPart = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
    if not attachPart then
        return
    end
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = attachPart
    billboard.Size = UDim2.new(0, 150, 0, 75)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = Camera
    local nameLabel = Instance.new("TextLabel")
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(1, 0, 0.33, 0)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Text = ""
    nameLabel.Parent = billboard
    local healthLabel = Instance.new("TextLabel")
    healthLabel.BackgroundTransparency = 1
    healthLabel.Size = UDim2.new(1, 0, 0.33, 0)
    healthLabel.Position = UDim2.new(0, 0, 0.33, 0)
    healthLabel.Font = Enum.Font.GothamBold
    healthLabel.TextSize = 14
    healthLabel.TextStrokeTransparency = 0.5
    healthLabel.Text = ""
    healthLabel.Parent = billboard
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Size = UDim2.new(1, 0, 0.33, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.66, 0)
    distanceLabel.Font = Enum.Font.GothamBold
    distanceLabel.TextSize = 14
    distanceLabel.TextStrokeTransparency = 0.5
    distanceLabel.Text = ""
    distanceLabel.Parent = billboard
    local glow = Instance.new("Highlight")
    glow.Adornee = character
    glow.FillTransparency = 0.5
    glow.OutlineTransparency = 1
    glow.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    glow.Enabled = false
    glow.Parent = character
    playerESPObjects[character] = {
        Billboard = billboard,
        NameLabel = nameLabel,
        HealthLabel = healthLabel,
        DistanceLabel = distanceLabel,
        Glow = glow,
        AttachPart = attachPart
    }
end

local function updatePlayerESP()
    for _, data in pairs(playerESPObjects) do
        if data.Billboard then
            data.Billboard.Enabled = playerESPEnabled
        end
        if data.Glow then
            data.Glow.Enabled = playerESPEnabled and glowESPEnabled
            if glowESPEnabled then
                local player = Players:GetPlayerFromCharacter(data.Glow.Adornee)
                if player then
                    if isEnemy(player) then
                        data.Glow.FillColor = enemyColor
                    else
                        data.Glow.FillColor = teamColor
                    end
                end
            end
        end
    end
end

local function createNPCESP(model, isDead)
    if model == LocalPlayer.Character then
        return
    end
    if not model or not model.Parent then
        return
    end
    if npcESPObjects[model] then
        return
    end
    local attachPart = getAimPart(model)
    if not attachPart then
        return
    end
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = attachPart
    billboard.Size = UDim2.new(0, 120, 0, 75)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = Camera
    local nameLabel = Instance.new("TextLabel")
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(1, 0, 0.33, 0)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Text = model.Name or "NPC"
    nameLabel.Parent = billboard
    local healthLabel = Instance.new("TextLabel")
    healthLabel.BackgroundTransparency = 1
    healthLabel.Size = UDim2.new(1, 0, 0.33, 0)
    healthLabel.Position = UDim2.new(0, 0, 0.33, 0)
    healthLabel.Font = Enum.Font.GothamBold
    healthLabel.TextSize = 14
    healthLabel.TextStrokeTransparency = 0.5
    healthLabel.Text = ""
    healthLabel.Parent = billboard
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Size = UDim2.new(1, 0, 0.33, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.66, 0)
    distanceLabel.Font = Enum.Font.GothamBold
    distanceLabel.TextSize = 14
    distanceLabel.TextStrokeTransparency = 0.5
    distanceLabel.Text = ""
    distanceLabel.Parent = billboard
    local glow = Instance.new("Highlight")
    glow.Adornee = model
    glow.FillColor = npcGlowColor
    glow.FillTransparency = 0.5
    glow.OutlineTransparency = 1
    glow.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    glow.Enabled = false
    glow.Parent = model
    npcESPObjects[model] = {
        Billboard = billboard,
        NameLabel = nameLabel,
        HealthLabel = healthLabel,
        DistanceLabel = distanceLabel,
        Glow = glow,
        AttachPart = attachPart,
        isDead = isDead
    }
end

local function updateNPCESP()
    for _, data in pairs(npcESPObjects) do
        if data.Billboard then
            data.Billboard.Enabled = npcESPEnabled
        end
        if data.Glow then
            data.Glow.Enabled = npcESPEnabled and npcGlowEnabled
        end
    end
end

local function createDeadBodyESP(model, originalName)
    if deadBodyESPObjects[model] then
        return
    end
    local attachPart = model:FindFirstChild("Head") or model:FindFirstChild("HumanoidRootPart")
    if not attachPart then
        return
    end
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = attachPart
    billboard.Size = UDim2.new(0, 150, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 1.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = Camera
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextStrokeTransparency = 0.5
    label.Text = "尸体[" .. originalName .. "]"
    label.TextColor3 = deadBodyColor
    label.Parent = billboard
    deadBodyESPObjects[model] = {
        Billboard = billboard,
        Label = label,
        AttachPart = attachPart
    }
end

local function updateDeadBodyESP()
    for _, data in pairs(deadBodyESPObjects) do
        if data.Billboard then
            data.Billboard.Enabled = deadBodyESPEnabled
        end
    end
end

local function cleanupDeadBodies()
    for model, data in pairs(deadBodyESPObjects) do
        if data.Billboard then
            data.Billboard:Destroy()
        end
        deadBodyESPObjects[model] = nil
    end
    print("[死亡ESP] 已手动清除所有尸体")
    window:Notification("死亡ESP", "已手动清除所有尸体", "Success", 3)
end

local function createExtractionESP(part)
    if not part or not part.Parent or extractionESPObjects[part] then
        return
    end
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = part
    billboard.Size = UDim2.new(0, 150, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = Camera
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextStrokeTransparency = 0.5
    label.Text = "撤离点"
    label.TextColor3 = extractionColor
    label.Parent = billboard
    local glow = Instance.new("Highlight")
    glow.Adornee = part
    glow.FillColor = extractionColor
    glow.FillTransparency = 0.7
    glow.OutlineTransparency = 1
    glow.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    glow.Parent = part
    extractionESPObjects[part] = {
        Billboard = billboard,
        Label = label,
        Glow = glow
    }
end

local function updateExtractionESP()
    if not extractionESPEnabled then
        return
    end
    local noCollision = workspace:FindFirstChild("NoCollision")
    if noCollision then
        local exitLocations = noCollision:FindFirstChild("ExitLocations")
        if exitLocations then
            for _, part in ipairs(exitLocations:GetChildren()) do
                if part:IsA("BasePart") then
                    if not extractionESPObjects[part] then
                        createExtractionESP(part)
                    end
                    local data = extractionESPObjects[part]
                    if data then
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            data.Label.Text = "撤离点 [" .. math.floor((hrp.Position - part.Position).Magnitude) .. "]"
                            data.Label.TextColor3 = extractionColor
                        end
                        if data.Glow then
                            data.Glow.FillColor = extractionColor
                        end
                    end
                end
            end
        end
    end
end

local function getAllPlayers()
    local players = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            players[player.Name:lower()] = player.Name
        end
    end
    return players
end

local function updatePlayerList()
    getAllPlayers()
end

local function scanForBosses()
    local bosses = {}
    local aiZones = workspace:FindFirstChild("AiZones")
    if not aiZones then
        return bosses
    end
    for _, descendant in ipairs(aiZones:GetDescendants()) do
        if descendant:IsA("Model") then
            local nameLower = string.lower(descendant.Name or "")
            if string.find(nameLower, "boss") or string.find(nameLower, "elite") or string.find(nameLower, "raid") then
                local humanoid = descendant:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    table.insert(bosses, descendant.Name)
                end
            end
        end
    end
    return bosses
end

local function startBossDetection()
    if bossDetectionScanning then
        return
    end
    bossDetectionScanning = true
    if bossDetectionTask then
        task.cancel(bossDetectionTask)
        bossDetectionTask = nil
    end
    bossDetectionTask = task.spawn(function()
        for i = 1, 3 do
            if not bossDetectionEnabled then
                bossDetectionScanning = false
                return
            end
            task.wait(0.5)
            local bosses = scanForBosses()
            if #bosses > 0 then
                window:Notification("Boss检测", "第" .. i .. "次扫描 | 发现: " .. table.concat(bosses, "、"), "Warning", 4)
            else
                window:Notification("Boss检测", "第" .. i .. "次扫描 | 未发现Boss", "Success", 3)
            end
            for _, boss in ipairs(bosses) do
                local found = false
                for _, detected in ipairs(detectedBosses) do
                    if detected == boss then
                        found = true
                        break
                    end
                end
                if not found then
                    table.insert(detectedBosses, boss)
                end
            end
        end
        while bossDetectionEnabled do
            task.wait(5)
            local bosses = scanForBosses()
            local newBosses = {}
            for _, boss in ipairs(bosses) do
                local found = false
                for _, detected in ipairs(detectedBosses) do
                    if detected == boss then
                        found = true
                        break
                    end
                end
                if not found then
                    table.insert(newBosses, boss)
                    table.insert(detectedBosses, boss)
                end
            end
            if #newBosses > 0 then
                window:Notification("Boss检测", "发现新Boss: " .. table.concat(newBosses, "、"), "Warning", 5)
            end
        end
        bossDetectionScanning = false
    end)
end

local function stopBossDetection()
    if bossDetectionTask then
        task.cancel(bossDetectionTask)
        bossDetectionTask = nil
    end
    bossDetectionScanning = false
end

local function createBulletTrackUI()
    if bulletTrackUI then
        return
    end
    bulletTrackUI = Instance.new("ScreenGui")
    bulletTrackUI.Name = "BulletTrackFloat"
    bulletTrackUI.ResetOnSpawn = false
    bulletTrackUI.Parent = CoreGui
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 120, 0, 100)
    mainFrame.Position = UDim2.new(0, 20, 0, 200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BackgroundTransparency = 0.15
    mainFrame.BorderSizePixel = 1
    mainFrame.BorderColor3 = Color3.fromRGB(80, 80, 100)
    mainFrame.Parent = bulletTrackUI
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 20)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "子弹追踪"
    title.TextColor3 = Color3.fromRGB(200, 200, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 12
    title.Parent = mainFrame
    local separator = Instance.new("Frame")
    separator.Size = UDim2.new(1, -10, 0, 1)
    separator.Position = UDim2.new(0, 5, 0, 20)
    separator.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    separator.BackgroundTransparency = 0.5
    separator.Parent = mainFrame
    local btStatus = Instance.new("TextLabel")
    btStatus.Size = UDim2.new(1, -10, 0, 18)
    btStatus.Position = UDim2.new(0, 5, 0, 24)
    btStatus.BackgroundTransparency = 1
    btStatus.Text = "BT: OFF"
    btStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
    btStatus.Font = Enum.Font.Gotham
    btStatus.TextSize = 11
    btStatus.TextXAlignment = Enum.TextXAlignment.Left
    btStatus.Parent = mainFrame
    local targetLabel = Instance.new("TextLabel")
    targetLabel.Size = UDim2.new(1, -10, 0, 18)
    targetLabel.Position = UDim2.new(0, 5, 0, 42)
    targetLabel.BackgroundTransparency = 1
    targetLabel.Text = "目标: 无"
    targetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    targetLabel.Font = Enum.Font.Gotham
    targetLabel.TextSize = 11
    targetLabel.TextXAlignment = Enum.TextXAlignment.Left
    targetLabel.Parent = mainFrame
    local visibilityLabel = Instance.new("TextLabel")
    visibilityLabel.Size = UDim2.new(1, -10, 0, 18)
    visibilityLabel.Position = UDim2.new(0, 5, 0, 60)
    visibilityLabel.BackgroundTransparency = 1
    visibilityLabel.Text = "状态: 无"
    visibilityLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    visibilityLabel.Font = Enum.Font.Gotham
    visibilityLabel.TextSize = 11
    visibilityLabel.TextXAlignment = Enum.TextXAlignment.Left
    visibilityLabel.Parent = mainFrame
    local autoLabel = Instance.new("TextLabel")
    autoLabel.Size = UDim2.new(1, -10, 0, 18)
    autoLabel.Position = UDim2.new(0, 5, 0, 78)
    autoLabel.BackgroundTransparency = 1
    autoLabel.Text = "自动: OFF"
    autoLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    autoLabel.Font = Enum.Font.Gotham
    autoLabel.TextSize = 11
    autoLabel.TextXAlignment = Enum.TextXAlignment.Left
    autoLabel.Parent = mainFrame
    bulletTrackUIElements = {
        Frame = mainFrame,
        BTStatus = btStatus,
        TargetLabel = targetLabel,
        VisibilityLabel = visibilityLabel,
        AutoLabel = autoLabel
    }
end

local function updateBulletTrackUI()
    if not bulletTrackUI then
        return
    end
    if bulletTrackEnabled then
        bulletTrackUIElements.BTStatus.Text = "BT: ON"
        bulletTrackUIElements.BTStatus.TextColor3 = Color3.fromRGB(80, 255, 80)
    else
        bulletTrackUIElements.BTStatus.Text = "BT: OFF"
        bulletTrackUIElements.BTStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
    if bulletTrackTarget then
        local name = ""
        if type(bulletTrackTarget) == "table" and bulletTrackTarget.Name then
            name = bulletTrackTarget.Name
        elseif type(bulletTrackTarget) == "string" then
            name = bulletTrackTarget
        elseif bulletTrackTarget:IsA("Model") then
            name = bulletTrackTarget.Name
        else
            name = "目标"
        end
        bulletTrackUIElements.TargetLabel.Text = "目标: " .. string.sub(name, 1, 15)
    else
        bulletTrackUIElements.TargetLabel.Text = "目标: 无"
    end
    if bulletTrackTargetVisible then
        bulletTrackUIElements.VisibilityLabel.Text = "状态: 可见"
        bulletTrackUIElements.VisibilityLabel.TextColor3 = Color3.fromRGB(80, 255, 80)
    else
        bulletTrackUIElements.VisibilityLabel.Text = "状态: 掩体"
        bulletTrackUIElements.VisibilityLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
    if autoShootEnabled and bulletTrackEnabled then
        bulletTrackUIElements.AutoLabel.Text = "自动: ON"
        bulletTrackUIElements.AutoLabel.TextColor3 = Color3.fromRGB(80, 255, 80)
    elseif autoShootEnabled and not bulletTrackEnabled then
        bulletTrackUIElements.AutoLabel.Text = "自动: 需开BT"
        bulletTrackUIElements.AutoLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
    else
        bulletTrackUIElements.AutoLabel.Text = "自动: OFF"
        bulletTrackUIElements.AutoLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
end

local function createAimbotFOVCircle()
    if aimbotFOVCircle then
        aimbotFOVCircle:Remove()
    end
    if not aimbotShowFOV then
        return
    end
    aimbotFOVCircle = Drawing.new("Circle")
    aimbotFOVCircle.Radius = aimbotFOV
    aimbotFOVCircle.Thickness = 1
    aimbotFOVCircle.Color = Color3.fromRGB(255, 255, 255)
    aimbotFOVCircle.Filled = false
    aimbotFOVCircle.Visible = true
    aimbotFOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

local function updateAimbotFOVCircle()
    if aimbotFOVCircle then
        aimbotFOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        aimbotFOVCircle.Radius = aimbotFOV
        aimbotFOVCircle.Visible = aimbotShowFOV
    end
end

local function findClosestTarget()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local closestDistance = math.huge
    local closestTarget = nil
    local closestPart = nil
    if aimbotLockOnPlayers then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and isEnemy(player) then
                local character = player.Character
                if character then
                    local aimPart = character:FindFirstChild(aimbotAimPart) or character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
                    if aimPart then
                        local distance = (Camera.CFrame.Position - aimPart.Position).Magnitude
                        if distance <= aimbotFOV then
                            local screenPos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
                            if onScreen then
                                local screenDistance = (center - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                                if screenDistance < closestDistance and screenDistance <= aimbotFOV then
                                    local visible = isVisible(aimPart)
                                    if aimbotThroughWalls or visible then
                                        closestDistance = screenDistance
                                        closestTarget = player
                                        closestPart = aimPart
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if aimbotLockOnNPCs then
        for _, npc in ipairs(npcList) do
            if npc and npc.Parent then
                local aimPart = npc:FindFirstChild("Head") or npc:FindFirstChild("HumanoidRootPart")
                if aimPart then
                    local distance = (Camera.CFrame.Position - aimPart.Position).Magnitude
                    if distance <= aimbotFOV then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
                        if onScreen then
                            local screenDistance = (center - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                            if screenDistance < closestDistance and screenDistance <= aimbotFOV then
                                local visible = isVisible(aimPart)
                                if aimbotThroughWalls or visible then
                                    closestDistance = screenDistance
                                    closestTarget = npc
                                    closestPart = aimPart
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return closestTarget, closestPart, closestDistance
end

local function smoothCamera(targetPosition)
    if not aimbotSmoothness then
        return
    end
    local currentCFrame = Camera.CFrame
    local newCFrame = CFrame.lookAt(currentCFrame.Position, targetPosition)
    Camera.CFrame = currentCFrame:Lerp(newCFrame, aimbotSmoothness)
end

local function updateAimbot()
    if not aimbotEnabled then
        return
    end
    if aimbotOnMouseMove and Mouse then
        local mousePos = Vector2.new(Mouse.X, Mouse.Y)
        if lastMousePos then
            local delta = (mousePos - lastMousePos).Magnitude / Camera.ViewportSize.X
            mouseAccumulatedDelta = (mouseAccumulatedDelta or 0) + delta
            if mouseAccumulatedDelta >= aimbotMouseSensitivity then
                local target, part = findClosestTarget()
                if target and part then
                    smoothCamera(part.Position)
                end
                mouseAccumulatedDelta = 0
            end
        end
        lastMousePos = mousePos
    end
    if not aimbotOnMouseMove then
        local target, part = findClosestTarget()
        if target and part then
            smoothCamera(part.Position)
        end
    end
end

local function findBulletTrackTarget()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local closestDistance = math.huge
    local closestTarget = nil
    local closestPart = nil
    if bulletTrackLockOnPlayers then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and (not bulletTrackIgnoreTeammates or not isEnemy(player)) then
                local character = player.Character
                if character then
                    local aimPart = character:FindFirstChild(bulletTrackAimPart) or character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
                    if aimPart then
                        local distance = (Camera.CFrame.Position - aimPart.Position).Magnitude
                        if distance <= bulletTrackRange then
                            local screenPos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
                            if onScreen then
                                local screenDistance = (center - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                                if screenDistance < closestDistance then
                                    local visible = isVisible(aimPart)
                                    closestDistance = screenDistance
                                    closestTarget = player
                                    closestPart = aimPart
                                    bulletTrackTargetVisible = visible
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if bulletTrackLockOnNPCs then
        for _, npc in ipairs(npcList) do
            if npc and npc.Parent then
                local aimPart = npc:FindFirstChild("Head") or npc:FindFirstChild("HumanoidRootPart")
                if aimPart then
                    local distance = (Camera.CFrame.Position - aimPart.Position).Magnitude
                    if distance <= bulletTrackRange then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
                        if onScreen then
                            local screenDistance = (center - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                            if screenDistance < closestDistance then
                                local visible = isVisible(aimPart)
                                closestDistance = screenDistance
                                closestTarget = npc
                                closestPart = aimPart
                                bulletTrackTargetVisible = visible
                            end
                        end
                    end
                end
            end
        end
    end
    return closestTarget, closestPart
end

local function updateBulletTrack()
    if not bulletTrackEnabled then
        if bulletTrackLine then
            bulletTrackLine.Visible = false
        end
        bulletTrackTarget = nil
        updateBulletTrackUI()
        return
    end
    local target, part = findBulletTrackTarget()
    if target and part then
        bulletTrackTarget = target
        if bulletTrackShowLine then
            if not bulletTrackLine then
                bulletTrackLine = Drawing.new("Line")
                bulletTrackLine.Thickness = 2
                bulletTrackLine.Color = bulletTrackTargetVisible and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                bulletTrackLine.Visible = true
            end
            local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                bulletTrackLine.From = center
                bulletTrackLine.To = Vector2.new(screenPos.X, screenPos.Y)
                bulletTrackLine.Color = bulletTrackTargetVisible and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                bulletTrackLine.Visible = true
            else
                bulletTrackLine.Visible = false
            end
        end
    else
        bulletTrackTarget = nil
        bulletTrackTargetVisible = false
        if bulletTrackLine then
            bulletTrackLine.Visible = false
        end
    end
    updateBulletTrackUI()
end

local function autoShoot()
    if not autoShootEnabled then
        return
    end
    if not bulletTrackEnabled then
        return
    end
    if not bulletTrackTargetVisible then
        return
    end
    if math.random(1, 100) <= autoShootChance then
        local currentTime = tick() * 1000
        if currentTime - lastShootTime >= autoShootDelay then
            pcall(function()
                if VirtualUser then
                    VirtualUser:Button1Down(Vector2.new(0, 0))
                    task.wait(0.03)
                    VirtualUser:Button1Up(Vector2.new(0, 0))
                elseif VirtualInputManager then
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    task.wait(0.03)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                else
                    if Mouse then
                        Mouse.Button1Click:Fire()
                    end
                end
            end)
            lastShootTime = currentTime
            if autoShootShowEffect then
                local effectPart = Instance.new("Part")
                effectPart.Size = Vector3.new(0.3, 0.3, 0.3)
                effectPart.CFrame = CFrame.new(bulletTrackTargetPart.Position)
                effectPart.Anchored = true
                effectPart.CanCollide = false
                effectPart.Material = Enum.Material.Neon
                effectPart.Color = Color3.fromRGB(0, 255, 0)
                effectPart.Parent = workspace
                Debris:AddItem(effectPart, 0.1)
            end
        end
    end
end

local function applyNoRecoil()
    local gc = getgc(true)
    for _, obj in pairs(gc) do
        if type(obj) == "table" then
            if rawget(obj, "shove") and rawget(obj, "update") then
                local originalShove = obj.shove
                local originalUpdate = obj.update
                obj.shove = function(...)
                    if noRecoilEnabled then
                        return
                    end
                    return originalShove(...)
                end
                obj.update = function(...)
                    if noRecoilEnabled then
                        return Vector3.zero
                    end
                    return originalUpdate(...)
                end
            end
            if rawget(obj, "updateClient") then
                local originalUpdateClient = obj.updateClient
                obj.updateClient = function(...)
                    if instantAimEnabled and select(-1, ...) then
                        select(-1, ...).AimInSpeed = 0
                        select(-1, ...).AimOutSpeed = 0
                    end
                    return originalUpdateClient(...)
                end
            end
        end
    end
end

local function applyBulletBoost()
    if not bulletBoostEnabled then
        return
    end
    local bulletScripts = {}
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local bulletTypes = replicatedStorage:FindFirstChild("AmmoTypes")
    if bulletTypes then
        for _, bullet in ipairs(bulletTypes:GetChildren()) do
            if not originalWeaponAttributes[bullet] then
                originalWeaponAttributes[bullet] = {
                    Drag = bullet:GetAttribute("Drag"),
                    ProjectileDrop = bullet:GetAttribute("ProjectileDrop")
                }
            end
            bullet:SetAttribute("Drag", 0)
            bullet:SetAttribute("ProjectileDrop", 0)
        end
    end
end

local function resetBulletBoost()
    for bullet, attrs in pairs(originalWeaponAttributes) do
        if attrs.Drag then
            bullet:SetAttribute("Drag", attrs.Drag)
        end
        if attrs.ProjectileDrop then
            bullet:SetAttribute("ProjectileDrop", attrs.ProjectileDrop)
        end
    end
end

local function scanFireRate()
    originalFireRateMap = {}
    originalFireRateValues = {}
    local gc = getgc(true)
    local count = 0
    for _, obj in pairs(gc) do
        if type(obj) == "table" then
            for k, v in pairs(obj) do
                if k == "FireRate" and type(v) == "number" and v > 0 then
                    originalFireRateMap[obj] = {key = k}
                    originalFireRateValues[obj] = v
                    count = count + 1
                end
            end
        end
    end
    if count > 0 then
        print("[射速] 扫描到 " .. count .. " 个 FireRate")
    end
    return count
end

local function applyFireRate()
    if not fireRateEnabled then
        return
    end
    for obj, data in pairs(originalFireRateMap) do
        if obj then
            obj[data.key] = fireRateValue
        end
    end
end

local function resetFireRate()
    for obj, originalValue in pairs(originalFireRateValues) do
        if obj then
            obj.FireRate = originalValue
        end
    end
end

local function applyFullAuto()
    local gc = getgc(true)
    for _, obj in pairs(gc) do
        if type(obj) == "table" then
            for k, v in pairs(obj) do
                if k == "FireModeIndex" then
                    if fullAutoEnabled then
                        obj[k] = 2
                    else
                        obj[k] = 1
                    end
                end
            end
        end
    end
end

local function onCharacterAdded()
    task.wait(0.5)
    if noRecoilEnabled then
        applyNoRecoil()
    end
    if instantAimEnabled then
        applyNoRecoil()
    end
    if fullAutoEnabled then
        applyFullAuto()
    end
    if fireRateEnabled then
        scanFireRate()
        applyFireRate()
    end
    if bulletBoostEnabled then
        applyBulletBoost()
    end
end

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        if playerESPEnabled then
            createPlayerESP(character)
        end
    end)
end

local function onPlayerRemoving(player)
    if player.Character and playerESPObjects[player.Character] then
        local data = playerESPObjects[player.Character]
        if data.Billboard then
            data.Billboard:Destroy()
        end
        if data.Glow then
            data.Glow:Destroy()
        end
        playerESPObjects[player.Character] = nil
    end
    if deadBodyESPObjects[player.Name] then
        local data = deadBodyESPObjects[player.Name]
        if data.Billboard then
            data.Billboard:Destroy()
        end
        deadBodyESPObjects[player.Name] = nil
    end
end

local function createUIElements()
    mainSection:Button("传送所有人", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/3490168468w-dotcom/GND-HUB/main/%E4%BC%A0%E9%80%81%E6%89%80%E6%9C%89%E4%BA%BA%E5%85%AC%E5%BC%80"))()
    end)
    mainSection:Button("黑闪秒杀", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/3490168468w-dotcom/GND-HUB/main/%E9%BB%91%E9%97%AA%E7%A7%92%E6%9D%80"))()
    end)
    mainSection:Button("飞行V3 GND", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/3490168468w-dotcom/GND-HUB/main/Fly%20V3%20GND"))()
    end)
    
    playerESPSection:Toggle("玩家ESP", function(value)
        playerESPEnabled = value
        updatePlayerESP()
    end, false)
    
    playerESPSection:Toggle("显示名字", function(value)
        nameESPEnabled = value
        updatePlayerESP()
    end, true)
    
    playerESPSection:Toggle("显示血量", function(value)
        healthESPEnabled = value
        updatePlayerESP()
    end, true)
    
    playerESPSection:Toggle("显示距离", function(value)
        distanceESPEnabled = value
        updatePlayerESP()
    end, true)
    
    playerESPSection:Toggle("方框透视", function(value)
        boxESPEnabled = value
        updatePlayerESP()
    end, false)
    
    playerESPSection:Toggle("发光透视", function(value)
        glowESPEnabled = value
        updatePlayerESP()
    end, false)
    
    playerESPSection:Slider("最大距离", 10, 7000, function(value)
        maxDistance = value
    end, 7000)
    
    playerESPSection:ColorPicker("敌方颜色", function(value)
        enemyColor = value
        updatePlayerESP()
    end, Color3.fromRGB(255, 0, 0))
    
    playerESPSection:ColorPicker("队友颜色", function(value)
        teamColor = value
        updatePlayerESP()
    end, Color3.fromRGB(0, 255, 0))
    
    npcESPSection:Toggle("NPC ESP", function(value)
        npcESPEnabled = value
        updateNPCESP()
    end, false)
    
    npcESPSection:Toggle("发光透视", function(value)
        npcGlowEnabled = value
        updateNPCESP()
    end, false)
    
    npcESPSection:ColorPicker("NPC颜色", function(value)
        npcColor = value
        updateNPCESP()
    end, Color3.fromRGB(0, 255, 0))
    
    npcESPSection:ColorPicker("发光颜色", function(value)
        npcGlowColor = value
        for _, data in pairs(npcESPObjects) do
            if data.Glow then
                data.Glow.FillColor = value
            end
        end
    end, Color3.fromRGB(255, 105, 180))
    
    otherESPSection:Toggle("死亡ESP", function(value)
        deadBodyESPEnabled = value
        updateDeadBodyESP()
    end, false)
    
    otherESPSection:Toggle("尸体永久显示", function(value)
        deadBodyPermanent = value
        if value then
            window:Notification("死亡ESP", "尸体永久显示已开启，不会自动消失", "Success", 3)
        else
            window:Notification("死亡ESP", "尸体永久显示已关闭", "Warning", 3)
        end
    end, false)
    
    otherESPSection:Slider("尸体消失时间", 5, 30, function(value)
        deadBodyCleanupTime = value
    end, 10)
    
    otherESPSection:Button("手动清除尸体", function()
        cleanupDeadBodies()
    end)
    
    otherESPSection:ColorPicker("尸体颜色", function(value)
        deadBodyColor = value
        for _, data in pairs(deadBodyESPObjects) do
            if data.Label then
                data.Label.TextColor3 = value
            end
        end
    end, Color3.fromRGB(128, 128, 128))
    
    otherESPSection:Toggle("撤离点透视", function(value)
        extractionESPEnabled = value
    end, false)
    
    otherESPSection:ColorPicker("撤离点颜色", function(value)
        extractionColor = value
    end, Color3.fromRGB(0, 255, 255))
    
    aimbotSection:Toggle("自瞄", function(value)
        aimbotEnabled = value
        if not value then
            if aimbotFOVCircle then
                aimbotFOVCircle.Visible = false
            end
        else
            if aimbotShowFOV then
                createAimbotFOVCircle()
            end
        end
    end, false)
    
    aimbotSection:Slider("平滑度", 0.01, 0.5, function(value)
        aimbotSmoothness = value
    end, 0.25)
    
    aimbotSection:Slider("FOV范围", 1, 5000, function(value)
        aimbotFOV = value
        if aimbotFOVCircle then
            aimbotFOVCircle.Radius = value
        end
    end, 150)
    
    aimbotSection:Dropdown("瞄准部位", {"Head", "HumanoidRootPart"}, function(value)
        aimbotAimPart = value
    end, true, "Head")
    
    aimbotSection:Toggle("忽略队友", function(value)
        aimbotIgnoreTeammates = value
    end, true)
    
    aimbotSection:Toggle("只打敌人", function(value)
        aimbotOnlyEnemies = value
    end, false)
    
    aimbotSection:Toggle("穿墙自瞄", function(value)
        aimbotThroughWalls = value
    end, false)
    
    aimbotSection:Toggle("显示FOV圆圈", function(value)
        aimbotShowFOV = value
        if value then
            createAimbotFOVCircle()
        elseif aimbotFOVCircle then
            aimbotFOVCircle:Remove()
            aimbotFOVCircle = nil
        end
    end, false)
    
    aimbotSection:Toggle("平滑转向", function(value)
        aimbotSmoothTurn = value
    end, true)
    
    bulletTrackSection:Toggle("子弹追踪", function(value)
        bulletTrackEnabled = value
        updateBulletTrackUI()
        if not value then
            bulletTrackTarget = nil
            if bulletTrackLine then
                bulletTrackLine.Visible = false
            end
        end
    end, false)
    
    bulletTrackSection:Slider("追踪距离", 50, 5000, function(value)
        bulletTrackRange = value
    end, 5000)
    
    bulletTrackSection:Toggle("锁定玩家", function(value)
        bulletTrackLockOnPlayers = value
    end, true)
    
    bulletTrackSection:Toggle("锁定NPC", function(value)
        bulletTrackLockOnNPCs = value
    end, true)
    
    bulletTrackSection:Toggle("忽略队友", function(value)
        bulletTrackIgnoreTeammates = value
    end, true)
    
    bulletTrackSection:Toggle("显示追踪线", function(value)
        bulletTrackShowLine = value
        if not value and bulletTrackLine then
            bulletTrackLine.Visible = false
        end
    end, true)
    
    bulletTrackSection:ColorPicker("追踪线颜色", function(value)
        bulletTrackLineColor = value
        if bulletTrackLine then
            bulletTrackLine.Color = value
        end
    end, Color3.fromRGB(0, 255, 0))
    
    bulletTrackSection:Dropdown("瞄准部位", {"Head", "HumanoidRootPart"}, function(value)
        bulletTrackAimPart = value
    end, true, "Head")
    
    autoShootSection:Toggle("自动射击", function(value)
        autoShootEnabled = value
        updateBulletTrackUI()
        if value then
            if not bulletTrackEnabled then
                print("[警告] 子弹追踪未开启！自动射击需要子弹追踪的支持")
            end
            print("[自动射击] 已开启 | 当追踪线为绿色时自动开枪")
        else
            print("[自动射击] 已关闭")
        end
    end, false)
    
    autoShootSection:Slider("射击延迟(ms)", 0, 500, function(value)
        autoShootDelay = value
    end, 50)
    
    autoShootSection:Slider("射击概率", 1, 100, function(value)
        autoShootChance = value
    end, 100)
    
    autoShootSection:Toggle("显示击中特效", function(value)
        autoShootShowEffect = value
    end, false)
    
    weaponModSection:Toggle("无后坐力", function(value)
        noRecoilEnabled = value
        applyNoRecoil()
    end, false)
    
    weaponModSection:Toggle("快速开镜", function(value)
        instantAimEnabled = value
        applyNoRecoil()
    end, false)
    
    weaponModSection:Toggle("子弹修改(无阻力/无下坠)", function(value)
        bulletBoostEnabled = value
        if value then
            applyBulletBoost()
            if bulletBoostTask then
                task.cancel(bulletBoostTask)
            end
            bulletBoostTask = task.spawn(function()
                while bulletBoostEnabled do
                    task.wait(0.5)
                    applyBulletBoost()
                end
            end)
            window:Notification("子弹修改", "无阻力 + 无下坠", "Success", 2)
        else
            if bulletBoostTask then
                task.cancel(bulletBoostTask)
                bulletBoostTask = nil
            end
            resetBulletBoost()
            window:Notification("子弹修改", "已关闭", "Warning", 2)
        end
    end, false)
    
    weaponModSection:Toggle("半自动改全自动", function(value)
        fullAutoEnabled = value
        applyFullAuto()
    end, false)
    
    weaponModSection:Toggle("自定义射速", function(value)
        fireRateEnabled = value
        if value then
            scanFireRate()
            applyFireRate()
            if fireRateTask then
                task.cancel(fireRateTask)
            end
            fireRateTask = task.spawn(function()
                while fireRateEnabled do
                    task.wait(0.5)
                    applyFireRate()
                end
            end)
            window:Notification("射速", "当前射速: " .. fireRateValue .. " 秒/发", "Success", 2)
        else
            if fireRateTask then
                task.cancel(fireRateTask)
                fireRateTask = nil
            end
            resetFireRate()
            window:Notification("射速", "已恢复原射速", "Warning", 2)
        end
    end, false)
    
    weaponModSection:Slider("射速(秒/发)", 0.001, 0.5, function(value)
        fireRateValue = value
        if fireRateEnabled then
            applyFireRate()
            window:Notification("射速", "射速已改为: " .. value .. " 秒/发", "Info", 1)
        end
    end, 0.5)
    
    local bossToggle = window:Tab("[Boss检测]", "1847190174"):Toggle("Boss检测", function(value)
        bossDetectionEnabled = value
        if value then
            startBossDetection()
        else
            stopBossDetection()
            bossDetectionScanning = false
        end
    end, true)
end

local function init()
    createUIElements()
    createBulletTrackUI()
    updatePlayerList()
    Players.PlayerAdded:Connect(onPlayerAdded)
    Players.PlayerRemoving:Connect(onPlayerRemoving)
    LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
    task.spawn(function()
        while task.wait(0.15) do
            updateAimbot()
            updateBulletTrack()
            autoShoot()
            updateExtractionESP()
            updateAimbotFOVCircle()
        end
    end)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.Escape then
            if aimbotEnabled then
                aimbotEnabled = false
            end
        end
    end)
    print("脚本加载完成，按 RightControl 打开菜单，点击按钮执行功能")
end

init()