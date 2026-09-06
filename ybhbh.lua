--[[
    ANSN破解脚本（Real注入器·终极增强版·防封整合·全图透视·防护升级）
    功能：犯罪透 + 自瞄 + 透视 + 起飞 + 传送 + 不会饿 + 快速互动(E) + 修车加油 + 跑得快(可设置) + 改车速(可设置)
    按键：F1犯罪透 F2自瞄 F3透视 F4起飞 F5鼠标传送 F6防饿 E快速互动 F8修车加油 F9跑得快 F10改车速
    菜单：可拖动、可收缩、支持按键绑定
    透视距离：自动覆盖整个地图
    防护：随机实例名、随机更新间隔、受保护父级、静默运行、随机延迟启动、参数随机化、低频率操作
]]

-- ==================== 防封：静默模式 ====================
local DEBUG = false
if not DEBUG then
    print = function() end
    warn = function() end
end

-- ==================== 防封：随机字符串 ====================
local function randomString(length)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local result = ""
    for i = 1, length do
        local index = math.random(1, #chars)
        result = result .. string.sub(chars, index, index)
    end
    return result
end

-- ==================== 安全父级获取 ====================
local function getSafeParent()
    local candidates = {}
    if gethui then
        table.insert(candidates, gethui)
    end
    table.insert(candidates, function() return game:GetService("CoreGui") end)
    table.insert(candidates, function() return LocalPlayer:WaitForChild("PlayerGui") end)
    for _, getParent in ipairs(candidates) do
        local ok, p = pcall(getParent)
        if ok and p then
            return p
        end
    end
    return game:GetService("CoreGui")
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ==================== 配置 ====================
local Config = {
    CrimeESPKey = Enum.KeyCode.F1,
    AimbotKey = Enum.KeyCode.F2,
    ESPKey = Enum.KeyCode.F3,
    FlyKey = Enum.KeyCode.F4,
    TeleportMouseKey = Enum.KeyCode.F5,
    NoHungerKey = Enum.KeyCode.F6,
    FastInteractKey = Enum.KeyCode.E,          -- 快速互动固定为E
    RepairCarKey = Enum.KeyCode.F8,
    SpeedRunKey = Enum.KeyCode.F9,
    CarBoostKey = Enum.KeyCode.F10,
    CollapseKey = Enum.KeyCode.LeftAlt,

    AimPart = "Head",
    AimFOV = 200,
    AimSmoothness = 0.25,
    AimPrediction = false,
    AimThroughWalls = false,
    MaxESP_Distance = 1000000,          -- 启动时自动覆盖全图
    HighlightFillTransparency = 0.5,
    HighlightOutlineTransparency = 0,

    FlySpeed = 60,
    TeleportDistance = 300,
    NoHungerValue = 100,
    WalkSpeed = 50,                     -- 默认跑速
    CarBoostMultiplier = 2.5,           -- 默认车速倍率

    NavPoint = nil,

    -- 防护参数
    FlySpeedMultiplier = 1.0,           -- 飞行速度随机因子
}

-- 按键绑定列表（快速互动已移除，固定E键）
local Bindings = {
    { name = "犯罪透", keyRef = "CrimeESPKey" },
    { name = "自瞄", keyRef = "AimbotKey" },
    { name = "透视", keyRef = "ESPKey" },
    { name = "起飞", keyRef = "FlyKey" },
    { name = "鼠标传送", keyRef = "TeleportMouseKey" },
    { name = "不会饿", keyRef = "NoHungerKey" },
    { name = "修车加油", keyRef = "RepairCarKey" },
    { name = "跑得快", keyRef = "SpeedRunKey" },
    { name = "改车速", keyRef = "CarBoostKey" },
    { name = "折叠菜单", keyRef = "CollapseKey" },
}

local isBinding = false
local bindingTarget = nil

-- ==================== 动态计算地图距离 ====================
local function calculateMapDistance()
    local mapParts = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Anchored then
            table.insert(mapParts, obj)
        end
    end
    if #mapParts == 0 then return 1000000 end

    local minX, minY, minZ = math.huge, math.huge, math.huge
    local maxX, maxY, maxZ = -math.huge, -math.huge, -math.huge
    for _, part in ipairs(mapParts) do
        local pos = part.Position
        local size = part.Size
        local half = size / 2
        minX = math.min(minX, pos.X - half.X)
        minY = math.min(minY, pos.Y - half.Y)
        minZ = math.min(minZ, pos.Z - half.Z)
        maxX = math.max(maxX, pos.X + half.X)
        maxY = math.max(maxY, pos.Y + half.Y)
        maxZ = math.max(maxZ, pos.Z + half.Z)
    end
    local center = Vector3.new((minX + maxX) / 2, (minY + maxY) / 2, (minZ + maxZ) / 2)
    local radius = (Vector3.new(maxX, maxY, maxZ) - Vector3.new(minX, minY, minZ)).Magnitude / 2
    return radius * 2
end

-- ==================== 职业颜色/名称 ====================
local TEAM_COLORS = {
    Police = Color3.fromRGB(80, 150, 255),
    Civilian = Color3.fromRGB(255, 255, 255),
    Chef = Color3.fromRGB(255, 200, 100),
    Delivery = Color3.fromRGB(255, 255, 100),
    Farmer = Color3.fromRGB(150, 255, 150),
    Fire = Color3.fromRGB(255, 100, 100),
    Medical = Color3.fromRGB(255, 150, 255),
    Prisoner = Color3.fromRGB(200, 200, 200),
    Criminal = Color3.fromRGB(255, 80, 80),
    ["Road Service"] = Color3.fromRGB(180, 180, 180),
    Transit = Color3.fromRGB(100, 200, 200),
    Default = Color3.fromRGB(255, 255, 255),
}
local TEAM_CN = {
    Police = "警察", Civilian = "平民", Chef = "厨师", Delivery = "外卖",
    Farmer = "农民", Fire = "消防", Medical = "医疗", Prisoner = "囚犯",
    Criminal = "罪犯", ["Road Service"] = "道路救援", Transit = "运输",
}

-- ==================== 状态 ====================
local CrimeESPEnabled = true
local AimbotEnabled = false
local ESPEnabled = true
local FlyEnabled = false
local NoHungerEnabled = false
local SpeedRunEnabled = false
local CarBoostEnabled = false
local CurrentTarget = nil
local GUICollapsed = false

-- ==================== 工具 ====================
local function clamp(v, min, max)
    if v < min then return min end
    if v > max then return max end
    return v
end

-- ==================== 犯罪判定 ====================
local function getWantedLevel(pl)
    local wl = pl:GetAttribute("WantedLevel")
    if wl == nil then return 0 end
    return tonumber(wl) or 0
end
local function isCriminal(pl)
    if getWantedLevel(pl) > 0 then return true end
    return pl:GetAttribute("Pursuit") == true
end
local function getProfession(pl)
    local team = pl.Team
    if not team then return "未知" end
    return TEAM_CN[team.Name] or team.Name
end
local function getTeamColor(pl)
    local team = pl.Team
    local teamName = team and team.Name or "Default"
    return TEAM_COLORS[teamName] or TEAM_COLORS.Default
end

-- ==================== ESP系统 ====================
local ESPHighlights = {}
local ESPBillboards = {}
local ESPLabels = {}

local function getHighlight(pl, character)
    local hl = ESPHighlights[pl]
    if hl and hl.Parent ~= character then
        pcall(function() hl:Destroy() end)
        hl = nil
    end
    if not hl then
        hl = Instance.new("Highlight")
        hl.Name = randomString(10)
        hl.Adornee = character
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Enabled = false
        hl.Parent = character
        ESPHighlights[pl] = hl
    end
    return hl
end

local function getBillboard(pl, character)
    local bb = ESPBillboards[pl]
    if bb and bb.Parent ~= character then
        pcall(function() bb:Destroy() end)
        bb = nil
        ESPLabels[pl] = nil
    end
    if not bb then
        bb = Instance.new("BillboardGui")
        bb.Name = randomString(10)
        bb.Size = UDim2.new(0, 300, 0, 60)
        bb.StudsOffset = Vector3.new(0, 2.5, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = Config.MaxESP_Distance
        bb.ResetOnSpawn = false

        local mainLabel = Instance.new("TextLabel")
        mainLabel.Name = randomString(8)
        mainLabel.Size = UDim2.new(1, 0, 0, 18)
        mainLabel.Position = UDim2.new(0, 0, 0, 0)
        mainLabel.BackgroundTransparency = 1
        mainLabel.Font = Enum.Font.Legacy
        mainLabel.TextSize = 14
        mainLabel.TextStrokeTransparency = 0
        mainLabel.TextColor3 = Color3.fromRGB(255,255,255)
        mainLabel.TextXAlignment = Enum.TextXAlignment.Center
        mainLabel.Parent = bb

        local distLabel = Instance.new("TextLabel")
        distLabel.Name = randomString(8)
        distLabel.Size = UDim2.new(0, 80, 0, 16)
        distLabel.Position = UDim2.new(-0.3, -80, 0, 2)
        distLabel.BackgroundTransparency = 1
        distLabel.Font = Enum.Font.Legacy
        distLabel.TextSize = 12
        distLabel.TextStrokeTransparency = 0
        distLabel.TextColor3 = Color3.fromRGB(255,255,255)
        distLabel.TextXAlignment = Enum.TextXAlignment.Right
        distLabel.Parent = bb

        local hpLabel = Instance.new("TextLabel")
        hpLabel.Name = randomString(8)
        hpLabel.Size = UDim2.new(0, 80, 0, 16)
        hpLabel.Position = UDim2.new(1.3, 0, 0, 2)
        hpLabel.BackgroundTransparency = 1
        hpLabel.Font = Enum.Font.Legacy
        hpLabel.TextSize = 12
        hpLabel.TextStrokeTransparency = 0
        hpLabel.TextColor3 = Color3.fromRGB(255,255,255)
        hpLabel.TextXAlignment = Enum.TextXAlignment.Left
        hpLabel.Parent = bb

        bb.Parent = character
        ESPBillboards[pl] = bb
        ESPLabels[pl] = {mainLabel, distLabel, hpLabel}
    end
    return bb
end

local function cleanupPlayerESP(pl)
    if ESPHighlights[pl] then pcall(function() ESPHighlights[pl]:Destroy() end) end
    if ESPBillboards[pl] then pcall(function() ESPBillboards[pl]:Destroy() end) end
    ESPHighlights[pl] = nil
    ESPBillboards[pl] = nil
    ESPLabels[pl] = nil
end

local function updateESP()
    if not Camera then Camera = Workspace.CurrentCamera return end
    local camPos = Camera.CFrame.Position
    local activePlayers = {}

    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer then
            local char = pl.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 then
                    local dist = (camPos - hrp.Position).Magnitude
                    if dist <= Config.MaxESP_Distance then
                        activePlayers[pl] = true
                        local criminal = isCriminal(pl)

                        local hl = getHighlight(pl, char)
                        if CrimeESPEnabled and criminal then
                            hl.Enabled = true
                            hl.FillColor = Color3.fromRGB(255, 30, 30)
                            hl.OutlineColor = Color3.fromRGB(255, 30, 30)
                            hl.FillTransparency = Config.HighlightFillTransparency
                            hl.OutlineTransparency = Config.HighlightOutlineTransparency
                        else
                            hl.Enabled = false
                        end

                        local showInfo = ESPEnabled or (CrimeESPEnabled and criminal)
                        if showInfo then
                            local bb = getBillboard(pl, char)
                            bb.Enabled = true
                            local labels = ESPLabels[pl]
                            if labels then
                                local mainLabel, distLabel, hpLabel = labels[1], labels[2], labels[3]
                                if mainLabel then
                                    mainLabel.Text = pl.Name .. " [" .. getProfession(pl) .. "]"
                                    if criminal then
                                        mainLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
                                    else
                                        mainLabel.TextColor3 = getTeamColor(pl)
                                    end
                                end
                                if distLabel then
                                    distLabel.Text = string.format("%.0fm", dist / 10)
                                end
                                if hpLabel then
                                    hpLabel.Text = string.format("HP:%.0f", hum.Health)
                                end
                            end
                        else
                            if ESPBillboards[pl] then ESPBillboards[pl].Enabled = false end
                        end
                    else
                        if ESPHighlights[pl] then ESPHighlights[pl].Enabled = false end
                        if ESPBillboards[pl] then ESPBillboards[pl].Enabled = false end
                    end
                else
                    if ESPHighlights[pl] then ESPHighlights[pl].Enabled = false end
                    if ESPBillboards[pl] then ESPBillboards[pl].Enabled = false end
                end
            else
                if ESPHighlights[pl] then ESPHighlights[pl].Enabled = false end
                if ESPBillboards[pl] then ESPBillboards[pl].Enabled = false end
            end
        end
    end

    for pl in pairs(ESPHighlights) do
        if not activePlayers[pl] then cleanupPlayerESP(pl) end
    end
    for pl in pairs(ESPBillboards) do
        if not activePlayers[pl] then cleanupPlayerESP(pl) end
    end
end

-- ==================== 自瞄 ====================
local hasMouseMove = false
pcall(function() mousemoverel(0,0); hasMouseMove = true end)

local function isEnemy(pl)
    if pl == LocalPlayer then return false end
    local myTeam = LocalPlayer.Team and LocalPlayer.Team.Name or ""
    local plTeam = pl.Team and pl.Team.Name or ""
    local myWanted = getWantedLevel(LocalPlayer)
    local plWanted = getWantedLevel(pl)
    if myTeam ~= "" and plTeam == myTeam then return false end
    if myTeam == "Police" then return plWanted > 0 end
    if myWanted > 0 then return plTeam == "Police" end
    return plTeam == "Police" or plWanted > 0
end

local function getAimPoint(character)
    local part = character:FindFirstChild(Config.AimPart) or character:FindFirstChild("Head")
    if not part then return nil end
    local pos = part.Position
    if Config.AimPrediction and character:FindFirstChild("HumanoidRootPart") then
        pos = pos + character.HumanoidRootPart.AssemblyLinearVelocity * 0.1
    end
    return pos
end

local function isOccluded(character, partPos)
    if not Camera then return true end
    local origin = Camera.CFrame.Position
    local dir = (partPos - origin).Unit
    local dist = (partPos - origin).Magnitude
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Blacklist
    rp.FilterDescendantsInstances = {character, LocalPlayer.Character or {}}
    local result = Workspace:Raycast(origin, dir * dist, rp)
    return result ~= nil
end

local function findTarget()
    if not Camera then return nil end
    local vp = Camera.ViewportSize
    local center = Vector2.new(vp.X / 2, vp.Y / 2)
    local bestDist = Config.AimFOV
    local bestPl = nil
    for _, pl in ipairs(Players:GetPlayers()) do
        if isEnemy(pl) and pl.Character then
            local char = pl.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then
                local aimPos = getAimPoint(char)
                if aimPos then
                    local sp, on = Camera:WorldToViewportPoint(aimPos)
                    if on and sp.Z > 0 then
                        if Config.AimThroughWalls or not isOccluded(char, aimPos) then
                            local screenDist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                            local worldDist = (Camera.CFrame.Position - hrp.Position).Magnitude
                            if screenDist < bestDist and worldDist <= Config.MaxESP_Distance then
                                bestDist = screenDist
                                bestPl = pl
                            end
                        end
                    end
                end
            end
        end
    end
    return bestPl
end

local function aimAt(pl, dt)
    if not pl or not pl.Character or not Camera then return end
    local aimPos = getAimPoint(pl.Character)
    if not aimPos then return end
    local sp, on = Camera:WorldToViewportPoint(aimPos)
    if not on or sp.Z <= 0 then return end
    local vp = Camera.ViewportSize
    local center = Vector2.new(vp.X / 2, vp.Y / 2)
    local dx = sp.X - center.X
    local dy = sp.Y - center.Y
    if math.sqrt(dx*dx + dy*dy) < 3 then return end
    local k = clamp(Config.AimSmoothness * (dt * 60), 0.05, 1)
    if hasMouseMove then
        mousemoverel(dx * k, dy * k)
    end
end

local function updateAimbot(dt)
    if not AimbotEnabled then CurrentTarget = nil return end
    if CurrentTarget then
        local char = CurrentTarget.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not hum or hum.Health <= 0 or not isEnemy(CurrentTarget) then
            CurrentTarget = nil
        end
    end
    if not CurrentTarget then CurrentTarget = findTarget() end
    if CurrentTarget then aimAt(CurrentTarget, dt) end
end

-- ==================== 起飞 ====================
local flyBodyVelocity = nil
local flyBodyGyro = nil
local flyTargetRoot = nil

local function getCharacterRoot()
    if not LocalPlayer.Character then return nil end
    return LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local function getVehicleRoot()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum and hum.SeatPart then
        local model = hum.SeatPart:FindFirstAncestorOfClass("Model")
        if model and model ~= LocalPlayer.Character then
            return model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Base") or model.PrimaryPart
        end
    end
    return nil
end

local function enableFly()
    local root = getVehicleRoot() or getCharacterRoot()
    if not root then return end
    flyTargetRoot = root

    -- 随机化飞行速度因子 0.8~1.2
    Config.FlySpeedMultiplier = 0.8 + math.random() * 0.4

    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent = root

    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    flyBodyGyro.CFrame = root.CFrame
    flyBodyGyro.Parent = root
end

local function disableFly()
    if flyBodyVelocity then flyBodyVelocity:Destroy() end
    if flyBodyGyro then flyBodyGyro:Destroy() end
    flyBodyVelocity = nil
    flyBodyGyro = nil
    flyTargetRoot = nil
end

local function updateFly()
    if not FlyEnabled then return end
    if not flyTargetRoot or not flyBodyVelocity or not flyBodyVelocity.Parent then
        enableFly()
    end
    if not flyBodyVelocity then return end

    local moveDirection = Vector3.new(0, 0, 0)
    local cam = Camera
    if cam then
        local forward = UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0
        local backward = UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0
        local left = UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0
        local right = UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0
        local up = UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0
        local down = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and 1 or 0

        local camCF = cam.CFrame
        moveDirection = (camCF.LookVector * (forward - backward) + camCF.RightVector * (right - left)) * (Config.FlySpeed * Config.FlySpeedMultiplier)
        moveDirection = moveDirection + Vector3.new(0, (up - down) * (Config.FlySpeed * Config.FlySpeedMultiplier), 0)
    end
    flyBodyVelocity.Velocity = moveDirection
end

-- ==================== 传送 ====================
local function teleportToMouse()
    local root = getCharacterRoot()
    if not root then return end
    local cam = Camera
    if not cam then return end
    local mousePos = UserInputService:GetMouseLocation()
    local ray = cam:ScreenPointToRay(mousePos.X, mousePos.Y)
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Blacklist
    rp.FilterDescendantsInstances = {LocalPlayer.Character}
    -- 随机化传送距离 0.9~1.1
    local actualDist = Config.TeleportDistance * (0.9 + math.random() * 0.2)
    local result = Workspace:Raycast(ray.Origin, ray.Direction * actualDist, rp)
    if result then
        root.CFrame = CFrame.new(result.Position + Vector3.new(0, 3, 0))
    else
        root.CFrame = CFrame.new(ray.Origin + ray.Direction * actualDist)
    end
end

local function setNavPoint()
    local root = getCharacterRoot()
    if root then Config.NavPoint = root.Position end
end

local function teleportToNav()
    local root = getCharacterRoot()
    if root and Config.NavPoint then
        root.CFrame = CFrame.new(Config.NavPoint + Vector3.new(0, 3, 0))
    end
end

local function teleportCarToMe()
    local root = getCharacterRoot()
    if not root then return end
    local nearestVehicle = nil
    local minDist = math.huge
    for _, model in ipairs(Workspace:GetDescendants()) do
        if model:IsA("Model") and model ~= LocalPlayer.Character then
            if model:FindFirstChildOfClass("VehicleSeat") then
                local vehicleRoot = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Base") or model.PrimaryPart
                if vehicleRoot then
                    local dist = (root.Position - vehicleRoot.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        nearestVehicle = vehicleRoot
                    end
                end
            end
        end
    end
    if nearestVehicle then
        nearestVehicle.CFrame = CFrame.new(root.Position + Vector3.new(0, 3, 0))
    end
end

-- ==================== 不会饿（降低频率） ====================
local noHungerTimer = 0
local function updateNoHunger(dt)
    if not NoHungerEnabled then
        noHungerTimer = 0
        return
    end
    noHungerTimer = noHungerTimer + dt
    if noHungerTimer < 5 then return end
    noHungerTimer = 0

    pcall(function()
        local hungerNames = {"Hunger", "HungerLevel", "Stamina", "Thirst", "HungerValue"}
        for _, name in ipairs(hungerNames) do
            pcall(function()
                if LocalPlayer:GetAttribute(name) ~= nil then
                    LocalPlayer:SetAttribute(name, Config.NoHungerValue)
                end
            end)
        end
        if LocalPlayer:FindFirstChild("leaderstats") then
            for _, stat in ipairs(LocalPlayer.leaderstats:GetChildren()) do
                local lowerName = string.lower(stat.Name)
                if lowerName:find("hunger") or lowerName:find("thirst") or lowerName:find("饱") then
                    if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                        stat.Value = Config.NoHungerValue
                    end
                end
            end
        end
    end)
end

-- ==================== 快速互动（固定E键，无开关） ====================
local function findNearestVehicleSeat()
    local root = getCharacterRoot()
    if not root then return nil end
    local nearestSeat = nil
    local minDist = 20
    for _, model in ipairs(Workspace:GetDescendants()) do
        if model:IsA("Model") and model ~= LocalPlayer.Character then
            local seat = model:FindFirstChildOfClass("VehicleSeat") or model:FindFirstChildOfClass("Seat")
            if seat then
                local seatPart = seat:IsA("BasePart") and seat or seat.Parent
                if seatPart and seatPart:IsA("BasePart") then
                    local dist = (root.Position - seatPart.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        nearestSeat = seat
                    end
                end
            end
        end
    end
    return nearestSeat
end

local function findNearestCriminal()
    local root = getCharacterRoot()
    if not root then return nil end
    local nearestCriminal = nil
    local minDist = 20
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and isCriminal(pl) and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (root.Position - pl.Character.HumanoidRootPart.Position).Magnitude
            if dist < minDist then
                minDist = dist
                nearestCriminal = pl
            end
        end
    end
    return nearestCriminal
end

local function fastInteract()
    pcall(function()
        local seat = findNearestVehicleSeat()
        if seat then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                local seatPart = seat:IsA("BasePart") and seat or seat.Parent
                if seatPart and seatPart:IsA("BasePart") then
                    hum.Sit = true
                    hum.Jump = false
                    LocalPlayer.Character.HumanoidRootPart.CFrame = seatPart.CFrame + Vector3.new(0, 2, 0)
                end
            end
            return
        end
        local target = findNearestCriminal()
        if target and target.Character then
            target:SetAttribute("Handcuffed", true)
            target:SetAttribute("Arrested", true)
            target:SetAttribute("Cuffed", true)
        end
    end)
end

-- ==================== 修车+加油 ====================
local function repairAndRefuelCar()
    pcall(function()
        local root = getCharacterRoot()
        if not root then return end
        local targetModel = nil
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.SeatPart then
            targetModel = hum.SeatPart:FindFirstAncestorOfClass("Model")
        else
            local minDist = 80
            for _, model in ipairs(Workspace:GetDescendants()) do
                if model:IsA("Model") and model ~= LocalPlayer.Character then
                    if model:FindFirstChildOfClass("VehicleSeat") or model:FindFirstChildOfClass("Seat") then
                        local vehicleRoot = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Base") or model.PrimaryPart
                        if vehicleRoot then
                            local dist = (root.Position - vehicleRoot.Position).Magnitude
                            if dist < minDist then
                                minDist = dist
                                targetModel = model
                            end
                        end
                    end
                end
            end
        end
        if not targetModel then return end
        for _, part in ipairs(targetModel:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Health = part.MaxHealth or 1000
                part.Material = Enum.Material.Metal
            end
        end
        local fuelNames = {"Fuel", "Gas", "Oil", "FuelLevel", "GasLevel"}
        for _, name in ipairs(fuelNames) do
            pcall(function()
                if targetModel:GetAttribute(name) ~= nil then
                    targetModel:SetAttribute(name, 100)
                end
            end)
        end
        for _, v in ipairs(targetModel:GetDescendants()) do
            if v:IsA("IntValue") or v:IsA("NumberValue") then
                local lower = string.lower(v.Name)
                if lower:find("fuel") or lower:find("gas") or lower:find("油") then
                    v.Value = 100
                end
            end
        end
        local seat = targetModel:FindFirstChildOfClass("VehicleSeat") or targetModel:FindFirstChildOfClass("Seat")
        if seat then
            seat.Disabled = false
        end
    end)
end

-- ==================== 跑得快 ====================
local function applyWalkSpeed()
    if not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = SpeedRunEnabled and Config.WalkSpeed or 16
    end
end

-- ==================== 改车速（开关 + 输入倍率，随机化实际倍率） ====================
local function applyCarBoost()
    if not CarBoostEnabled then return end
    pcall(function()
        local root = getCharacterRoot()
        if not root then return end
        local seat = nil
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.SeatPart then
            seat = hum.SeatPart
        else
            local minDist = 30
            for _, model in ipairs(Workspace:GetDescendants()) do
                if model:IsA("Model") and model ~= LocalPlayer.Character then
                    local vSeat = model:FindFirstChildOfClass("VehicleSeat") or model:FindFirstChildOfClass("Seat")
                    if vSeat then
                        local seatPart = vSeat:IsA("BasePart") and vSeat or vSeat.Parent
                        if seatPart and seatPart:IsA("BasePart") then
                            local dist = (root.Position - seatPart.Position).Magnitude
                            if dist < minDist then
                                minDist = dist
                                seat = vSeat
                            end
                        end
                    end
                end
            end
        end
        if seat then
            local vehicleSeat = seat:IsA("VehicleSeat") and seat or seat:FindFirstAncestorOfClass("VehicleSeat")
            -- 随机化倍率 0.9~1.1
            local boostRandom = 0.9 + math.random() * 0.2
            local finalMultiplier = Config.CarBoostMultiplier * boostRandom
            if vehicleSeat then
                vehicleSeat.MaxSpeed = (vehicleSeat.MaxSpeed or 100) * finalMultiplier
                vehicleSeat.Torque = (vehicleSeat.Torque or 100) * finalMultiplier
            end
            local model = seat:FindFirstAncestorOfClass("Model")
            if model then
                for _, part in ipairs(model:GetDescendants()) do
                    if part:IsA("Motor") or part:IsA("Motor6D") then
                        part.MaxVelocity = part.MaxVelocity * finalMultiplier
                    end
                end
            end
        end
    end)
end

-- ==================== 自瞄HUD ====================
local AimHUD = nil
local function createAimHUD()
    if AimHUD then return end
    local gui = Instance.new("ScreenGui")
    gui.Name = randomString(12)
    gui.ResetOnSpawn = false
    gui.Parent = getSafeParent()
    if syn and syn.protect_gui then
        pcall(function() syn.protect_gui(gui) end)
    end

    local hLine = Instance.new("Frame")
    hLine.Name = randomString(8)
    hLine.Size = UDim2.new(0, 20, 0, 2)
    hLine.Position = UDim2.new(0.5, -10, 0.5, -1)
    hLine.BackgroundColor3 = Color3.fromRGB(255,255,255)
    hLine.BorderSizePixel = 0
    hLine.Parent = gui

    local vLine = Instance.new("Frame")
    vLine.Name = randomString(8)
    vLine.Size = UDim2.new(0, 2, 0, 20)
    vLine.Position = UDim2.new(0.5, -1, 0.5, -10)
    vLine.BackgroundColor3 = Color3.fromRGB(255,255,255)
    vLine.BorderSizePixel = 0
    vLine.Parent = gui

    local circleLabel = Instance.new("TextLabel")
    circleLabel.Name = randomString(8)
    circleLabel.Size = UDim2.new(0, Config.AimFOV*2, 0, Config.AimFOV*2)
    circleLabel.Position = UDim2.new(0.5, -Config.AimFOV, 0.5, -Config.AimFOV)
    circleLabel.BackgroundTransparency = 1
    circleLabel.Text = "O"
    circleLabel.Font = Enum.Font.Legacy
    circleLabel.TextSize = Config.AimFOV*2
    circleLabel.TextColor3 = Color3.fromRGB(255,255,255)
    circleLabel.TextTransparency = 0.5
    circleLabel.Visible = false
    circleLabel.Parent = gui

    AimHUD = gui
end

local function updateAimHUD()
    if not AimHUD then return end
    local circle = AimHUD:FindFirstChildOfClass("TextLabel")
    if circle then
        circle.Visible = AimbotEnabled
        circle.TextColor3 = CurrentTarget and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,255,255)
    end
end

-- ==================== GUI（可收缩 + 按键绑定管理） ====================
local guiFrame = nil
local collapsibleContent = nil
local toggleCollapse = nil

local function createGUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = randomString(12)
    gui.ResetOnSpawn = false
    gui.Parent = getSafeParent()
    if syn and syn.protect_gui then
        pcall(function() syn.protect_gui(gui) end)
    end

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = randomString(10)
    mainFrame.Size = UDim2.new(0, 300, 0, 800)
    mainFrame.Position = UDim2.new(0, 20, 0.5, -400)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15,15,20)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = gui
    guiFrame = mainFrame

    local titleBar = Instance.new("Frame")
    titleBar.Name = randomString(8)
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(30,30,35)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local title = Instance.new("TextLabel")
    title.Name = randomString(8)
    title.Size = UDim2.new(1, -40, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.Text = "San Aurie 辅助"
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Font = Enum.Font.Legacy
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Parent = mainFrame

    local collapseBtn = Instance.new("TextButton")
    collapseBtn.Name = randomString(8)
    collapseBtn.Size = UDim2.new(0, 30, 0, 30)
    collapseBtn.Position = UDim2.new(1, -35, 0, 0)
    collapseBtn.Text = "−"
    collapseBtn.TextColor3 = Color3.fromRGB(255,255,255)
    collapseBtn.Font = Enum.Font.Legacy
    collapseBtn.TextSize = 20
    collapseBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)
    collapseBtn.BorderSizePixel = 0
    collapseBtn.AutoButtonColor = false
    collapseBtn.Parent = mainFrame

    local content = Instance.new("Frame")
    content.Name = randomString(8)
    content.Size = UDim2.new(1, 0, 1, -30)
    content.Position = UDim2.new(0, 0, 0, 30)
    content.BackgroundTransparency = 1
    content.Parent = mainFrame
    collapsibleContent = content

    local function makeButton(parent, text, y, color)
        local btn = Instance.new("TextButton")
        btn.Name = randomString(8)
        btn.Size = UDim2.new(1, -20, 0, 28)
        btn.Position = UDim2.new(0, 10, 0, y)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.Legacy
        btn.TextSize = 13
        btn.BackgroundColor3 = color
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = parent
        return btn
    end

    local function makeLabel(parent, text, y)
        local lbl = Instance.new("TextLabel")
        lbl.Name = randomString(8)
        lbl.Size = UDim2.new(1, -20, 0, 18)
        lbl.Position = UDim2.new(0, 10, 0, y)
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(200,200,200)
        lbl.Font = Enum.Font.Legacy
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.BackgroundTransparency = 1
        lbl.Parent = parent
        return lbl
    end

    local function makeTextBox(parent, y, defaultText)
        local box = Instance.new("TextBox")
        box.Name = randomString(8)
        box.Size = UDim2.new(0, 60, 0, 22)
        box.Position = UDim2.new(0, 150, 0, y)
        box.Text = defaultText
        box.TextColor3 = Color3.fromRGB(255,255,255)
        box.BackgroundColor3 = Color3.fromRGB(40,40,45)
        box.BorderSizePixel = 0
        box.Font = Enum.Font.Legacy
        box.TextSize = 13
        box.Parent = parent
        return box
    end

    -- 功能按钮（调整Y坐标）
    local crimeBtn = makeButton(content, "犯罪透 [F1]: 开", 0, Color3.fromRGB(50,180,50))
    local aimBtn = makeButton(content, "自瞄 [F2]: 关", 32, Color3.fromRGB(200,50,50))
    local espBtn = makeButton(content, "透视 [F3]: 开", 64, Color3.fromRGB(50,180,50))
    local flyBtn = makeButton(content, "起飞 [F4]: 关", 96, Color3.fromRGB(200,50,50))

    makeLabel(content, "传送：", 128)
    local teleMouseBtn = makeButton(content, "鼠标传送 [F5]", 146, Color3.fromRGB(50,50,200))
    local setNavBtn = makeButton(content, "设置导航点", 178, Color3.fromRGB(50,50,200))
    local teleNavBtn = makeButton(content, "传送到导航点", 210, Color3.fromRGB(50,50,200))
    local teleCarBtn = makeButton(content, "把我的车传送过来", 242, Color3.fromRGB(50,50,200))

    local noHungerBtn = makeButton(content, "不会饿 [F6]: 关", 274, Color3.fromRGB(200,50,50))
    local repairBtn = makeButton(content, "修车加油 [F8]", 306, Color3.fromRGB(50,50,200))

    -- 跑得快
    makeLabel(content, "跑得快速度：", 338)
    local walkSpeedBox = makeTextBox(content, 336, tostring(Config.WalkSpeed))
    local speedBtn = makeButton(content, "跑得快 [F9]: 关", 368, Color3.fromRGB(200,50,50))

    -- 改车速
    makeLabel(content, "车速倍率：", 400)
    local carBoostBox = makeTextBox(content, 398, tostring(Config.CarBoostMultiplier))
    local carBoostBtn = makeButton(content, "改车速 [F10]: 关", 430, Color3.fromRGB(200,50,50))

    -- 按键绑定区域
    makeLabel(content, "--- 按键绑定 ---", 462)
    local bindY = 482
    local bindButtons = {}

    for _, binding in ipairs(Bindings) do
        local name = binding.name
        local keyRef = binding.keyRef
        local currentKey = Config[keyRef]

        local label = makeLabel(content, name .. "： " .. tostring(currentKey), bindY)
        local bindBtn = makeButton(content, "绑定", bindY, Color3.fromRGB(80,80,80))
        bindBtn.Size = UDim2.new(0, 70, 0, 22)
        bindBtn.Position = UDim2.new(0, 200, 0, bindY)
        bindBtn.Parent = content

        table.insert(bindButtons, { label = label, btn = bindBtn, keyRef = keyRef })

        bindBtn.MouseButton1Click:Connect(function()
            isBinding = true
            bindingTarget = keyRef
            bindBtn.Text = "请按键..."
        end)

        bindY = bindY + 26
    end

    local function refreshUI()
        crimeBtn.Text = "犯罪透 [" .. tostring(Config.CrimeESPKey.Name) .. "]: " .. (CrimeESPEnabled and "开" or "关")
        crimeBtn.BackgroundColor3 = CrimeESPEnabled and Color3.fromRGB(50,180,50) or Color3.fromRGB(200,50,50)
        aimBtn.Text = "自瞄 [" .. tostring(Config.AimbotKey.Name) .. "]: " .. (AimbotEnabled and "开" or "关")
        aimBtn.BackgroundColor3 = AimbotEnabled and Color3.fromRGB(50,180,50) or Color3.fromRGB(200,50,50)
        espBtn.Text = "透视 [" .. tostring(Config.ESPKey.Name) .. "]: " .. (ESPEnabled and "开" or "关")
        espBtn.BackgroundColor3 = ESPEnabled and Color3.fromRGB(50,180,50) or Color3.fromRGB(200,50,50)
        flyBtn.Text = "起飞 [" .. tostring(Config.FlyKey.Name) .. "]: " .. (FlyEnabled and "开" or "关")
        flyBtn.BackgroundColor3 = FlyEnabled and Color3.fromRGB(50,180,50) or Color3.fromRGB(200,50,50)
        teleMouseBtn.Text = "鼠标传送 [" .. tostring(Config.TeleportMouseKey.Name) .. "]"
        noHungerBtn.Text = "不会饿 [" .. tostring(Config.NoHungerKey.Name) .. "]: " .. (NoHungerEnabled and "开" or "关")
        noHungerBtn.BackgroundColor3 = NoHungerEnabled and Color3.fromRGB(50,180,50) or Color3.fromRGB(200,50,50)
        repairBtn.Text = "修车加油 [" .. tostring(Config.RepairCarKey.Name) .. "]"
        speedBtn.Text = "跑得快 [" .. tostring(Config.SpeedRunKey.Name) .. "]: " .. (SpeedRunEnabled and "开" or "关")
        speedBtn.BackgroundColor3 = SpeedRunEnabled and Color3.fromRGB(50,180,50) or Color3.fromRGB(200,50,50)
        carBoostBtn.Text = "改车速 [" .. tostring(Config.CarBoostKey.Name) .. "]: " .. (CarBoostEnabled and "开" or "关")
        carBoostBtn.BackgroundColor3 = CarBoostEnabled and Color3.fromRGB(50,180,50) or Color3.fromRGB(200,50,50)

        walkSpeedBox.Text = tostring(Config.WalkSpeed)
        carBoostBox.Text = tostring(Config.CarBoostMultiplier)

        for _, item in ipairs(bindButtons) do
            item.label.Text = item.keyRef .. "： " .. tostring(Config[item.keyRef])
            item.btn.Text = "绑定"
        end
    end

    toggleCollapse = function()
        GUICollapsed = not GUICollapsed
        if GUICollapsed then
            content.Visible = false
            mainFrame.Size = UDim2.new(0, 300, 0, 30)
            collapseBtn.Text = "+"
        else
            content.Visible = true
            mainFrame.Size = UDim2.new(0, 300, 0, 800)
            collapseBtn.Text = "−"
        end
    end
    collapseBtn.MouseButton1Click:Connect(toggleCollapse)

    local function buttonAction(func)
        return function(...)
            if isBinding then return end
            func(...)
        end
    end

    crimeBtn.MouseButton1Click:Connect(buttonAction(function() CrimeESPEnabled = not CrimeESPEnabled refreshUI() end))
    aimBtn.MouseButton1Click:Connect(buttonAction(function() AimbotEnabled = not AimbotEnabled if not AimbotEnabled then CurrentTarget = nil end refreshUI() end))
    espBtn.MouseButton1Click:Connect(buttonAction(function() ESPEnabled = not ESPEnabled refreshUI() end))
    flyBtn.MouseButton1Click:Connect(buttonAction(function() FlyEnabled = not FlyEnabled if FlyEnabled then enableFly() else disableFly() end refreshUI() end))
    teleMouseBtn.MouseButton1Click:Connect(buttonAction(teleportToMouse))
    setNavBtn.MouseButton1Click:Connect(buttonAction(setNavPoint))
    teleNavBtn.MouseButton1Click:Connect(buttonAction(teleportToNav))
    teleCarBtn.MouseButton1Click:Connect(buttonAction(teleportCarToMe))
    noHungerBtn.MouseButton1Click:Connect(buttonAction(function() NoHungerEnabled = not NoHungerEnabled refreshUI() end))
    repairBtn.MouseButton1Click:Connect(buttonAction(repairAndRefuelCar))

    speedBtn.MouseButton1Click:Connect(buttonAction(function()
        SpeedRunEnabled = not SpeedRunEnabled
        applyWalkSpeed()
        refreshUI()
    end))

    carBoostBtn.MouseButton1Click:Connect(buttonAction(function()
        CarBoostEnabled = not CarBoostEnabled
        if CarBoostEnabled then
            applyCarBoost()
        end
        refreshUI()
    end))

    walkSpeedBox.FocusLost:Connect(function()
        local val = tonumber(walkSpeedBox.Text)
        if val and val > 0 then Config.WalkSpeed = val if SpeedRunEnabled then applyWalkSpeed() end end
        refreshUI()
    end)
    carBoostBox.FocusLost:Connect(function()
        local val = tonumber(carBoostBox.Text)
        if val and val > 0 then Config.CarBoostMultiplier = val end
        refreshUI()
    end)

    refreshUI()
    return refreshUI, toggleCollapse
end

-- ==================== 按键处理（含绑定逻辑 + 快速互动固定E） ====================
local function setupHotkeys(refreshUI, toggleCollapse)
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        local key = input.KeyCode

        if isBinding then
            if key ~= Enum.KeyCode.Unknown then
                if bindingTarget then
                    Config[bindingTarget] = key
                end
                isBinding = false
                bindingTarget = nil
                refreshUI()
            end
            return
        end

        if key == Config.CrimeESPKey then
            CrimeESPEnabled = not CrimeESPEnabled refreshUI()
        elseif key == Config.AimbotKey then
            AimbotEnabled = not AimbotEnabled if not AimbotEnabled then CurrentTarget = nil end refreshUI()
        elseif key == Config.ESPKey then
            ESPEnabled = not ESPEnabled refreshUI()
        elseif key == Config.FlyKey then
            FlyEnabled = not FlyEnabled if FlyEnabled then enableFly() else disableFly() end refreshUI()
        elseif key == Config.TeleportMouseKey then
            teleportToMouse()
        elseif key == Config.NoHungerKey then
            NoHungerEnabled = not NoHungerEnabled refreshUI()
        elseif key == Config.FastInteractKey then
            fastInteract()
        elseif key == Config.RepairCarKey then
            repairAndRefuelCar()
        elseif key == Config.SpeedRunKey then
            SpeedRunEnabled = not SpeedRunEnabled applyWalkSpeed() refreshUI()
        elseif key == Config.CarBoostKey then
            CarBoostEnabled = not CarBoostEnabled if CarBoostEnabled then applyCarBoost() end refreshUI()
        end

        if key == Config.CollapseKey then
            toggleCollapse()
        end
    end)
end

-- ==================== 主循环（随机更新间隔） ====================
local nextESPUpdate = math.random(2, 4)
local currentFrame = 0
local carBoostApplyTimer = 0

RunService.RenderStepped:Connect(function(dt)
    currentFrame = currentFrame + 1
    if currentFrame >= nextESPUpdate then
        pcall(updateESP)
        currentFrame = 0
        nextESPUpdate = math.random(2, 4)
    end
    pcall(function() updateAimbot(dt) end)
    pcall(updateAimHUD)
    pcall(updateFly)
    pcall(function() updateNoHunger(dt) end)  -- 传入dt

    if CarBoostEnabled then
        carBoostApplyTimer = carBoostApplyTimer + dt
        if carBoostApplyTimer >= 2 then
            pcall(applyCarBoost)
            carBoostApplyTimer = 0
        end
    else
        carBoostApplyTimer = 0
    end
end)

-- ==================== 启动（随机延迟 + 全图透视） ====================
local function start()
    wait(math.random(3, 8))  -- 随机3~8秒后启动
    Config.MaxESP_Distance = calculateMapDistance()
    createAimHUD()
    local refreshUI, toggleCollapseFunc = createGUI()
    setupHotkeys(refreshUI, toggleCollapseFunc)
end

local success, err = pcall(start)
if not success then
    -- 静默失败
end