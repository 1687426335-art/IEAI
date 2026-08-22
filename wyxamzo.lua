-- This file has been deobfuscated Luraph using Hurricane https://discord.com/invite/AbeurBzKXe
local function safeLoad(url) local success, result = pcall(function() return loadstring(game:HttpGet(url))() end) if not success then warn("加载失败: " .. url) return nil end return result end local Library = safeLoad("https://raw.githubusercontent.com/kongbaNB/ui/refs/heads/main/黑曜石主库.ui") local ThemeManager = safeLoad("https://raw.githubusercontent.com/kongbaNB/ui/refs/heads/main/主题管理.ui") local SaveManager = safeLoad("https://raw.githubusercontent.com/kongbaNB/ui/refs/heads/main/配置管理.ui") if not Library then game:GetService("StarterGui"):SetCore("SendNotification", { Title = "错误", Text = "UI 库加载失败，请检查网络或脚本资源", Duration = 5, }) return end local Options = Library.Options local Toggles = Library.Toggles local Players = game:GetService("Players") local ReplicatedStorage = game:GetService("ReplicatedStorage") local Workspace = game:GetService("Workspace") local RunService = game:GetService("RunService") local player = Players.LocalPlayer local Window = Library:CreateWindow({ Title = "圣奥里", Footer = "wdfex 制作", Icon = 131153193945220, NotifySide = "Right", ShowCustomCursor = true, }) Library:Notify({ Title = "圣奥里", Description = "创作者：wdfex\nQQ：1687426335\n脚本已加载成功", Time = 5, }) local Tabs = { Notice = Window:AddTab("通知", "info"), Player = Window:AddTab("玩家修改", "user"), Gun = Window:AddTab("枪械修改", "target"), Teleports = Window:AddTab("传送点", "map-pin"), Settings = Window:AddTab("设置", "settings"), } local NoticeGroup = Tabs.Notice:AddLeftGroupbox("作者消息") NoticeGroup:AddLabel('wdfex') NoticeGroup:AddLabel('创作者：wdfex')

local Settings = {
    HoldTime = 0,
    Distance = 25,
    HitboxEnabled = false,
    HitboxSize = 10,
    WhitelistEnabled = false,
    TeleportEnabled = false,
    NoclipEnabled = false,
}

local Whitelist = {}
local affectedHeads = {}
local frameCount = 0
local isDestroyed = false
local connections = {}
local noclipConnections = {}

local espBillboards = {}
local espConnections = {}

local function GetTeleportData()
    return {
        {n = "车辆经销商", p = Vector3.new(3719.9501953125, 3.018573522567749, -333.3118591308594), region = "圣奥里"},
        {n = "医院", p = Vector3.new(3980.091064453125, 2.876060724258423, -138.79454040527344), region = "圣奥里"},
        {n = "警察局", p = Vector3.new(3364.273193359375, 3.9188079834, -394.7233581542969), region = "圣奥里"},
        {n = "圣奥里修车店", p = Vector3.new(2782.46875, 2.630995750427246, -418.59930419921875), region = "圣奥里"},
        {n = "圣奥里银行", p = Vector3.new(3134.05419921875, 6.116048336029053, -171.36976623535156), region = "圣奥里"},
        {n = "圣奥里服装店", p = Vector3.new(3617.91259765625, 3.1072206497192383, -452.8206481933594), region = "圣奥里"},
        {n = "圣奥里平民重生", p = Vector3.new(3741.114990234375, 3.720573663711548, -438.1059875488281), region = "圣奥里"},
        {n = "圣奥里码头", p = Vector3.new(4527.65625, -23.968238830566406, -280.59356689453125), region = "圣奥里"},
        {n = "圣奥里餐饮店", p = Vector3.new(3182.416748046875, 3.01859188079834, 426.5179138183594), region = "圣奥里"},
        {n = "消防部门", p = Vector3.new(3578.676025390625, 8.408823013305664, 579.6567993164062), region = "圣奥里"},
        {n = "宠物店", p = Vector3.new(3678.237305, 3.017920, 693.114624), region = "圣奥里"},
        {n = "圣奥里大码头", p = Vector3.new(2736.307617, 2.630299, -1120.333008), region = "圣奥里"},
        {n = "圣奥里海滩桥下(消星点)", p = Vector3.new(3964.504395, -25.068211, -854.057251), region = "圣奥里"},
        {n = "大景超市", p = Vector3.new(3936.582764, 3.038293, 1136.326416), region = "大景"},
        {n = "转镜中心", p = Vector3.new(4152.919922, 2.631675, 941.446045), region = "大景"},
        {n = "道路服务", p = Vector3.new(4271.332520, 2.628108, 1200.086914), region = "大景"},
        {n = "大景餐饮店", p = Vector3.new(4476.997559, 3.037825, 906.802979), region = "大景"},
        {n = "送货中心", p = Vector3.new(4399.419434, 3.038999, 1609.455933), region = "大景"},
        {n = "大景卖车店", p = Vector3.new(3434.377441, 42.931786, 2687.997070), region = "大景"},
        {n = "莱斯维尔餐饮店", p = Vector3.new(753.757812, 3.039824, 998.132996), region = "莱斯维尔"},
        {n = "莱斯维尔服装店", p = Vector3.new(820.745117, 2.766988, 1047.445679), region = "莱斯维尔"},
        {n = "莱斯维尔自由广场", p = Vector3.new(926.523376, 2.630995, 865.764771), region = "莱斯维尔"},
        {n = "莱斯维尔码头(游艇)", p = Vector3.new(947.840210, -22.529087, 1216.085693), region = "莱斯维尔"},
        {n = "米尔顿左上加油站", p = Vector3.new(1145.635742, 2.630916, -864.273682), region = "米尔顿"},
        {n = "米尔顿右下加油站", p = Vector3.new(-1646.802734, 2.630164, 1812.894653), region = "米尔顿"},
        {n = "米尔顿上方加油站", p = Vector3.new(-900.701660, 2.630927, 1124.683105), region = "米尔顿"},
        {n = "米尔顿居民区", p = Vector3.new(-528.565552, 2.630996, 1331.981689), region = "米尔顿"},
        {n = "约克镇小银行", p = Vector3.new(-668.217224, 2.630995, -65.347839), region = "约克镇"},
        {n = "约克镇修车厂", p = Vector3.new(-407.163025, 3.076807, -6.098211), region = "约克镇"},
        {n = "约克镇枪店", p = Vector3.new(-323.869293, 3.037825, 37.149670), region = "约克镇"},
        {n = "约克镇重生点", p = Vector3.new(-219.560318, 3.039824, -85.725433), region = "约克镇"},
        {n = "约克镇当铺", p = Vector3.new(-168.513733, 3.039000, -106.926529), region = "约克镇"},
        {n = "约克镇卫星车", p = Vector3.new(-302.093567, 3.037825, -167.621017), region = "约克镇"},
        {n = "约克镇中心点", p = Vector3.new(-275.995209, 2.630996, -139.985352), region = "约克镇"},
        {n = "黑市", p = Vector3.new(1038.969849, -22.732950, 895.430237), region = "其他"},
        {n = "渔夫码头", p = Vector3.new(-50.147552, -24.555279, 1462.145996), region = "其他"},
        {n = "农场", p = Vector3.new(-1268.339233, 2.572412, 2560.060303), region = "其他"},
        {n = "监狱门口", p = Vector3.new(-1697.931885, 2.630666, 1284.567383), region = "其他"},
        {n = "监狱广场", p = Vector3.new(-1600.602417, 2.631028, 1268.060059), region = "其他"},
        {n = "代尔山", p = Vector3.new(847.062988, 194.115753, -326.212708), region = "其他"},
        {n = "瀑布洞穴(消星点)", p = Vector3.new(3040.956055, 109.688538, 2711.069336), region = "其他"},
        {n = "大桥", p = Vector3.new(949.014954, 25.215754, 2897.654785), region = "其他"},
        {n = "地图右下(消星点)", p = Vector3.new(-1651.385010, 2.414712, 3225.278320), region = "其他"},
        {n = "下部加油站", p = Vector3.new(2270.378174, 2.630927, 154.161484), region = "其他"},
        {n = "游戏厅", p = Vector3.new(2934.893799, 2.956458, 1693.660034), region = "其他"},
        {n = "高尔夫", p = Vector3.new(2280.767090, 3.037836, 1982.357300), region = "其他"},
        {n = "修船厂", p = Vector3.new(4096.405273, -30.401447, 2865.045166), region = "其他"},
    }
end
local FIXED_TELEPORTS = GetTeleportData()

local function TeleportTo(pos)
    if not Settings.TeleportEnabled or isDestroyed then return end
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    pcall(function()
        root.CFrame = CFrame.new(pos)
    end)
end

local function ApplyNoclip()
    if isDestroyed or not Settings.NoclipEnabled then return end
    local char = player.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

local function ToggleNoclip(state)
    Settings.NoclipEnabled = state
    if state then
        ApplyNoclip()
    else
        local char = player.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

local function ApplyHitbox()
    if isDestroyed or not Settings.HitboxEnabled then return end
    local players = Players:GetPlayers()
    local newAffected = {}
    for i = 1, #players do
        local p = players[i]
        if p ~= player and p.Character then
            if Settings.WhitelistEnabled and Whitelist[p.UserId] then
            else
                local char = p.Character
                local head = char:FindFirstChild("Head")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 and head then
                    head.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
                    head.Transparency = 1
                    head.Color = Color3.fromRGB(255, 215, 0)
                    head.Material = Enum.Material.Neon
                    head.CanCollide = false
                    newAffected[head] = true
                end
            end
        end
    end
    for head, _ in pairs(affectedHeads) do
        if not newAffected[head] and head and head.Parent then
            head.Size = Vector3.new(2, 1, 1)
            head.Transparency = 0
            head.CanCollide = true
            head.Color = Color3.new(1, 1, 1)
            head.Material = Enum.Material.Plastic
        end
    end
    affectedHeads = newAffected
end

local function ResetHitbox()
    for head, _ in pairs(affectedHeads) do
        if head and head.Parent then
            head.Size = Vector3.new(2, 1, 1)
            head.Transparency = 0
            head.CanCollide = true
            head.Color = Color3.new(1, 1, 1)
            head.Material = Enum.Material.Plastic
        end
    end
    affectedHeads = {}
end

local function UpdateWhitelist()
    if isDestroyed then return end
    Whitelist = {}
    local players = Players:GetPlayers()
    for i = 1, #players do
        local p = players[i]
        if p ~= player then
            pcall(function()
                if p:IsFriendsWith(player.UserId) then
                    Whitelist[p.UserId] = true
                end
            end)
        end
    end
end

local UserInputService = game:GetService("UserInputService")
local FlySpeed = 0
local flyState = { enabled = false, hrp = nil, hum = nil, microThread = nil, healthThread = nil, diedConn = nil, targetPos = nil, lastTime = 0 }
local flyAnchor = { active = false, head = nil, hrp = nil, hum = nil, rayLength = 3.5, rayCount = 12, verticalLayers = 3 }
local FlyControl
task.spawn(function()
    pcall(function()
        local pm = player.PlayerScripts:FindFirstChild("PlayerModule")
        if pm then FlyControl = require(pm):GetControls() end
    end)
end)

local function flyRefreshParts()
    local char = player.Character
    if not char then
        flyState.hrp = nil flyState.hum = nil
        flyAnchor.hrp = nil flyAnchor.head = nil flyAnchor.hum = nil
        return
    end
    flyState.hrp = char:FindFirstChild("HumanoidRootPart")
    flyState.hum = char:FindFirstChildOfClass("Humanoid")
    flyAnchor.hrp = flyState.hrp
    flyAnchor.head = char:FindFirstChild("Head")
    flyAnchor.hum = flyState.hum
end

local function flyDetectWall()
    local hrp = flyAnchor.hrp
    if not hrp then return false end
    local pos = hrp.Position
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = { player.Character }
    for i = 1, flyAnchor.rayCount do
        local angle = (i / flyAnchor.rayCount) * 2 * math.pi
        local dx = math.cos(angle)
        local dz = math.sin(angle)
        for j = -(flyAnchor.verticalLayers - 1) // 2, (flyAnchor.verticalLayers - 1) // 2 do
            local dir = Vector3.new(dx, j * 0.5, dz).Unit
            local result = workspace:Raycast(pos, dir * flyAnchor.rayLength, params)
            if result and result.Instance and result.Instance.CanCollide and result.Instance.Transparency < 0.9 then
                return true
            end
        end
    end
    return false
end

local function flyEnterAnchor()
    if flyAnchor.active then return end
    if not flyAnchor.head or not flyAnchor.hrp or not flyAnchor.hum then return end
    flyAnchor.head.Anchored = true
    flyAnchor.hum.PlatformStand = true
    flyAnchor.active = true
end

local function flyExitAnchor()
    if not flyAnchor.active then return end
    if flyAnchor.head and flyAnchor.hum then
        flyAnchor.head.Anchored = false
        flyAnchor.hum.PlatformStand = false
    end
    flyAnchor.active = false
end

local function flyMicroStepLoop()
    flyState.targetPos = flyState.hrp.Position
    flyState.lastTime = tick()
    while flyState.enabled do
        local now = tick()
        local dt = now - flyState.lastTime
        flyState.lastTime = now
        if not flyState.hrp or not flyState.hrp.Parent then break end
        local inWall = flyDetectWall()
        if inWall and not flyAnchor.active then
            flyEnterAnchor()
        elseif not inWall and flyAnchor.active then
            flyExitAnchor()
        end
        local moveDir
        if FlyControl then
            local mv = FlyControl:GetMoveVector()
            local cf = workspace.CurrentCamera.CFrame
            moveDir = (cf.LookVector * -mv.Z) + (cf.RightVector * mv.X)
        else
            moveDir = (flyState.hum and flyState.hum.MoveDirection) or Vector3.zero
        end
        local vertical = 0
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            vertical = 1
        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            vertical = -1
        end
        local delta = (moveDir + Vector3.new(0, vertical, 0)) * FlySpeed * dt
        flyState.targetPos = flyState.targetPos + delta
        local currentPos = flyState.hrp.Position
        local remaining = flyState.targetPos - currentPos
        local distance = remaining.Magnitude
        if distance > 0 then
            local steps = math.ceil(distance / 10)
            local stepVec = remaining / steps
            for i = 1, steps do
                if not flyState.enabled then break end
                currentPos = currentPos + stepVec
                flyState.hrp.CFrame = CFrame.new(currentPos) * flyState.hrp.CFrame.Rotation
                flyState.hrp.Velocity = Vector3.zero
            end
        else
            flyState.hrp.CFrame = CFrame.new(flyState.targetPos) * flyState.hrp.CFrame.Rotation
            flyState.hrp.Velocity = Vector3.zero
        end
        if flyState.hum then
            flyState.hum:ChangeState(Enum.HumanoidStateType.Climbing)
        end
        task.wait(0.001)
    end
end

local function flyHealthLockLoop()
    while flyState.enabled do
        if flyState.hum and flyState.hum.Health <= 0 then
            flyState.hum.Health = flyState.hum.MaxHealth
        end
        task.wait(0.1)
    end
end

local function startFly()
    if flyState.enabled then return end
    flyRefreshParts()
    if not flyState.hrp or not flyState.hum then return end
    flyState.enabled = true
    flyState.hum:ChangeState(Enum.HumanoidStateType.Climbing)
    flyState.microThread = task.spawn(flyMicroStepLoop)
    flyState.healthThread = task.spawn(flyHealthLockLoop)
    flyState.diedConn = flyState.hum.Died:Connect(function()
        if flyState.hum and flyState.enabled then
            flyState.hum.Health = flyState.hum.MaxHealth
            flyState.hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
end

local function stopFly()
    flyState.enabled = false
    flyExitAnchor()
    if flyState.microThread then task.cancel(flyState.microThread) flyState.microThread = nil end
    if flyState.healthThread then task.cancel(flyState.healthThread) flyState.healthThread = nil end
    if flyState.diedConn then flyState.diedConn:Disconnect() flyState.diedConn = nil end
    if flyState.hum then flyState.hum:ChangeState(Enum.HumanoidStateType.Running) end
end

player.CharacterAdded:Connect(function()
    if flyState.enabled then
        stopFly()
        task.wait(0.2)
        startFly()
    end
end)

local interactEnabled = false
local ScanPrompts

local speedBypassOn = false
local speedBypassValue = 20
RunService.Heartbeat:Connect(function(dt)
    if not speedBypassOn then return end
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if hum and root and hum.MoveDirection.Magnitude > 0 then
        root.CFrame = root.CFrame + hum.MoveDirection * speedBypassValue * dt
    end
end)

local staminaOn = false
local godOn = false
local StaminaEvent
pcall(function()
    StaminaEvent = ReplicatedStorage:WaitForChild("Remote", 5):WaitForChild("PlayerEvent", 5)
end)
if StaminaEvent then
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if self == StaminaEvent and method == "FireServer" then
            if args[1] == "setStaminaOrFood" and args[2] == "stamina" and staminaOn then
                args[3] = 100
                return oldNamecall(self, unpack(args))
            end
            if args[1] == "takeDamage" and godOn then
                return
            end
        end
        return oldNamecall(self, ...)
    end)
end
task.spawn(function()
    while not isDestroyed do
        if staminaOn and StaminaEvent then
            pcall(function()
                StaminaEvent:FireServer("setStaminaOrFood", "stamina", 100)
            end)
        end
        task.wait(0.3)
    end
end)

local zzEnabled = false
local zzDistance = 40
local zzAffected = nil
local function zzRestore()
    if zzAffected and zzAffected.Parent then
        pcall(function()
            zzAffected.Size = Vector3.new(2, 1, 1)
            zzAffected.Transparency = 0
        end)
    end
    zzAffected = nil
end
task.spawn(function()
    while not isDestroyed do
        if zzEnabled then
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local best, bestDist = nil, zzDistance
            if root then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player and p.Character then
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        local head = p.Character:FindFirstChild("Head")
                        if hum and hum.Health > 0 and head then
                            local d = (head.Position - root.Position).Magnitude
                            if d < bestDist then
                                bestDist = d
                                best = head
                            end
                        end
                    end
                end
            end
            if best ~= zzAffected then
                zzRestore()
                if best then
                    zzAffected = best
                    pcall(function()
                        best.Size = Vector3.new(500, 500, 500)
                        best.Transparency = 1
                        best.CanCollide = false
                    end)
                end
            end
        else
            zzRestore()
        end
        task.wait(0.1)
    end
end)

local aimOn = false
local aimFOV = 150
local aimNoTeam = true
local aimWall = true
local aimGui, aimCircle
local function aimEnsureCircle()
    if aimGui then return end
    aimGui = Instance.new("ScreenGui")
    aimGui.Name = "SA_AimFOV"
    aimGui.ResetOnSpawn = false
    aimGui.IgnoreGuiInset = true
    aimGui.Parent = player:WaitForChild("PlayerGui")
    aimCircle = Instance.new("Frame")
    aimCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    aimCircle.Position = UDim2.fromScale(0.5, 0.5)
    aimCircle.BackgroundTransparency = 1
    aimCircle.Parent = aimGui
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.4
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = aimCircle
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = aimCircle
end
RunService.RenderStepped:Connect(function()
    if not aimOn then
        if aimGui then aimGui.Enabled = false end
        return
    end
    aimEnsureCircle()
    aimGui.Enabled = true
    aimCircle.Size = UDim2.fromOffset(aimFOV * 2, aimFOV * 2)
    local camera = workspace.CurrentCamera
    if not camera then return end
    local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local best, bestDist = nil, aimFOV
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local head = p.Character:FindFirstChild("Head")
            if hum and hum.Health > 0 and head then
                local skip = aimNoTeam and p.Team ~= nil and player.Team ~= nil and p.Team == player.Team
                if not skip then
                    local sp, onScreen = camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                        if d < bestDist then
                            local visible = true
                            if aimWall then
                                local rp = RaycastParams.new()
                                rp.FilterType = Enum.RaycastFilterType.Exclude
                                rp.FilterDescendantsInstances = { player.Character }
                                local res = Workspace:Raycast(camera.CFrame.Position, (head.Position - camera.CFrame.Position).Unit * 500, rp)
                                visible = (not res) or res.Instance:IsDescendantOf(p.Character)
                            end
                            if visible then
                                bestDist = d
                                best = head
                            end
                        end
                    end
                end
            end
        end
    end
    if best then
        camera.CFrame = CFrame.lookAt(camera.CFrame.Position, best.Position)
    end
end)

local infAmmoEnabled = false
task.spawn(function()
    while not isDestroyed do
        if infAmmoEnabled then
            local characterFolder = Workspace:FindFirstChild("Characters") and Workspace.Characters:FindFirstChild(player.Name)
            if characterFolder then
                for _, gun in ipairs(characterFolder:GetChildren()) do
                    local config = gun:FindFirstChild("Config")
                    if config then
                        local ammo = config:FindFirstChild("Ammo")
                        local totalAmmo = config:FindFirstChild("TotalAmmo")
                        if ammo then ammo.Value = math.huge end
                        if totalAmmo then totalAmmo.Value = math.huge end
                    end
                end
            end
        end
        RunService.Heartbeat:Wait()
    end
end)

local KA_MAX_DISTANCE = 300
local KA_WALL_CHECK = true
local kaEnabled = false
local kaStatusLabel = nil

local function kaIsVisible(targetHead)
    local char = player.Character
    if not char then return false end
    local myHead = char:FindFirstChild("Head")
    if not myHead then return false end
    local direction = targetHead.Position - myHead.Position
    local distance = direction.Magnitude
    if distance < 0.1 then return true end
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {char, targetHead.Parent}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    return Workspace:Raycast(myHead.Position, direction.Unit * distance, rayParams) == nil
end

local function kaGetNearestEnemy()
    local char = player.Character
    if not char then return nil end
    local myHead = char:FindFirstChild("Head")
    if not myHead then return nil end
    local bestPlayer, bestDist = nil, KA_MAX_DISTANCE
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local head = p.Character:FindFirstChild("Head")
                if head then
                    local dist = (head.Position - myHead.Position).Magnitude
                    if dist < bestDist and (not KA_WALL_CHECK or kaIsVisible(head)) then
                        bestDist = dist
                        bestPlayer = p
                    end
                end
            end
        end
    end
    return bestPlayer
end

local function kaSetStatus(text)
    if kaStatusLabel then
        pcall(function() kaStatusLabel:SetText(text) end)
    end
end

RunService.Heartbeat:Connect(function()
    if not isDestroyed then
        if kaEnabled then
            do
                local target = kaGetNearestEnemy()
                local targetHead = target and target.Character and target.Character:FindFirstChild("Head")
                if targetHead then
                    local myHead = player.Character and player.Character:FindFirstChild("Head")
                    if myHead then
                        local origin = myHead.Position
                        local hitPos = targetHead.Position
                        local direction = (hitPos - origin).Unit
                        pcall(function()
                            ReplicatedStorage.Remote.PlayerEvent:FireServer("damage", {
                                bodyParts = { { "Head", 100 } },
                                shotCode = { origin, direction },
                                target = target,
                                pos = hitPos
                            })
                        end)
                        pcall(function()
                            local handleShots = ReplicatedStorage:FindFirstChild("Events")
                            handleShots = handleShots and handleShots:FindFirstChild("HandleShots")
                            if handleShots then
                                handleShots:FireServer("2", "Shoot")
                            end
                        end)
                        kaSetStatus("状态：已锁定 " .. target.Name .. "，攻击已发送")
                    else
                        kaSetStatus("状态：等待角色头部加载")
                    end
                else
                    kaSetStatus("状态：范围内未找到敌人")
                end
            end
        end
    end
end)

local weaponGroup = Tabs.Gun:AddLeftGroupbox("武器强化")
weaponGroup:AddToggle("FastFire", {
    Text = "无限射速（伤害拉满）",
    Default = false,
    Callback = function(value)
        if not value then return end
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
        end
        ModifyWeaponStats()
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Died:Connect(ModifyWeaponStats)
            end
        end
        Library:Notify({ Title = "武器强化", Description = "无限射速已生效，死亡后自动重新生效", Time = 3 })
    end
})
weaponGroup:AddToggle("InfAmmo", {
    Text = "无限子弹",
    Default = false,
    Callback = function(value)
        infAmmoEnabled = value
    end
})

local mainLeftGroup = Tabs.Player:AddRightGroupbox("交互设置")
mainLeftGroup:AddToggle("InteractToggle", {
    Text = "启用交互修改",
    Default = false,
    Callback = function(value)
        interactEnabled = value
        if value and ScanPrompts then ScanPrompts() end
    end
})
mainLeftGroup:AddDivider()
mainLeftGroup:AddSlider("HoldTime", {
    Text = "按住时间",
    Default = 0,
    Min = 0,
    Max = 10,
    Rounding = 0,
    Suffix = "秒",
    Callback = function(value)
        Settings.HoldTime = value
        if not interactEnabled then return end
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = value
            end
        end
    end
})
mainLeftGroup:AddSlider("Distance", {
    Text = "触发距离",
    Default = 25,
    Min = 5,
    Max = 150,
    Rounding = 0,
    Suffix = "单位",
    Callback = function(value)
        Settings.Distance = value
        if not interactEnabled then return end
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.MaxActivationDistance = value
            end
        end
    end
})

local godGroup = Tabs.Player:AddRightGroupbox("伤害免疫")
godGroup:AddToggle("GodToggle", {
    Text = "免疫部分伤害",
    Default = false,
    Callback = function(value)
        godOn = value
    end
})
godGroup:AddLabel("免疫火焰/激光/火车/车祸，不免疫玩家枪械")

-- ===== 新透视系统 =====
local espGroup = Tabs.Gun:AddRightGroupbox("透视")
local espEnabled = false
local espShowName = false
local espShowDistance = false
local espShowHealth = false
local espShowJob = false
local espShowWanted = false
local espDetectFly = false
local espObjects = {}
local espRenderConnection = nil
local espUpdateTimer = 0
local flyWarnActive = false
local flyWarnGui = nil

local jobColors = {
    ["警察"] = Color3.fromRGB(0, 100, 255),
    ["平民"] = Color3.fromRGB(200, 200, 200),
    ["火焰"] = Color3.fromRGB(255, 150, 0),
    ["医生"] = Color3.fromRGB(0, 200, 0),
    ["送货"] = Color3.fromRGB(255, 100, 50),
    ["转运"] = Color3.fromRGB(0, 200, 150),
}

local function GetPlayerJobNew(p)
    if p.Team then
        return p.Team.Name
    end
    return "平民"
end

local function GetJobColorNew(job)
    return jobColors[job] or Color3.fromRGB(200, 200, 200)
end

local function ClearESPNew()
    for _, obj in ipairs(espObjects) do
        pcall(function() obj:Destroy() end)
    end
    espObjects = {}
    if espRenderConnection then
        espRenderConnection:Disconnect()
        espRenderConnection = nil
    end
end

local function GetWantedLevel(player)
    local char = player.Character
    if not char then return 0 end
    for _, child in ipairs(char:GetDescendants()) do
        if child:IsA("IntValue") or child:IsA("NumberValue") then
            local name = child.Name:lower()
            if name:find("wanted") or name:find("star") or name:find("通缉") then
                local val = tonumber(child.Value)
                if val then return val end
            end
        end
        if child:IsA("StringValue") then
            local name = child.Name:lower()
            if name:find("wanted") or name:find("star") or name:find("通缉") then
                local val = child.Value
                if val:match("%d+") then
                    return tonumber(val:match("%d+")) or 0
                end
            end
        end
    end
    return 0
end

local function IsPlayerFlying(player)
    local char = player.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    local vel = hrp.AssemblyLinearVelocity
    if vel.Y > 15 and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
        return true
    end
    return false
end

local function CreateESPForPlayer(player)
    local char = player.Character
    if not char then return end
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local health = humanoid and math.floor(humanoid.Health) or 0
    local maxHealth = humanoid and math.floor(humanoid.MaxHealth) or 100
    
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local distance = hrp and math.floor((hrp.Position - rootPart.Position).Magnitude) or 0
    
    local job = GetPlayerJobNew(player)
    local jobColor = GetJobColorNew(job)
    local wantedLevel = GetWantedLevel(player)
    local isFlying = IsPlayerFlying(player)
    
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 220, 0, 120)
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = rootPart
    table.insert(espObjects, billboard)
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.4
    bg.BorderSizePixel = 1
    bg.BorderColor3 = Color3.fromRGB(255, 255, 255)
    bg.Parent = billboard
    table.insert(espObjects, bg)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = bg
    
    local yOffset = 5
    
    if espShowName then
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -10, 0, 18)
        nameLabel.Position = UDim2.new(0, 5, 0, yOffset)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player == LocalPlayer and (player.Name .. " (你)") or player.Name
        nameLabel.TextColor3 = player == LocalPlayer and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 13
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextStrokeTransparency = 0.2
        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLabel.Parent = billboard
        table.insert(espObjects, nameLabel)
        yOffset = yOffset + 20
    end
    
    if espShowJob then
        local jobLabel = Instance.new("TextLabel")
        jobLabel.Size = UDim2.new(1, -10, 0, 16)
        jobLabel.Position = UDim2.new(0, 5, 0, yOffset)
        jobLabel.BackgroundTransparency = 1
        jobLabel.Text = job
        jobLabel.TextColor3 = jobColor
        jobLabel.TextSize = 12
        jobLabel.Font = Enum.Font.GothamBold
        jobLabel.TextStrokeTransparency = 0.2
        jobLabel.Parent = billboard
        table.insert(espObjects, jobLabel)
        yOffset = yOffset + 18
    end
    
    if espShowHealth then
        local healthBg = Instance.new("Frame")
        healthBg.Size = UDim2.new(0.7, 0, 0, 6)
        healthBg.Position = UDim2.new(0.15, 0, 0, yOffset)
        healthBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        healthBg.BorderSizePixel = 1
        healthBg.BorderColor3 = Color3.fromRGB(60, 60, 60)
        healthBg.Parent = billboard
        table.insert(espObjects, healthBg)
        
        local healthPercent = math.clamp(health / maxHealth, 0, 1)
        local healthBar = Instance.new("Frame")
        healthBar.Size = UDim2.new(healthPercent, 0, 1, 0)
        healthBar.BackgroundColor3 = healthPercent > 0.5 and Color3.fromRGB(0, 255, 100) or 
                                     healthPercent > 0.25 and Color3.fromRGB(255, 200, 0) or 
                                     Color3.fromRGB(255, 50, 50)
        healthBar.BorderSizePixel = 0
        healthBar.Parent = healthBg
        table.insert(espObjects, healthBar)
        
        local healthLabel = Instance.new("TextLabel")
        healthLabel.Size = UDim2.new(1, -10, 0, 14)
        healthLabel.Position = UDim2.new(0, 5, 0, yOffset + 8)
        healthLabel.BackgroundTransparency = 1
        healthLabel.Text = health .. "/" .. maxHealth
        healthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        healthLabel.TextSize = 10
        healthLabel.Font = Enum.Font.Gotham
        healthLabel.TextStrokeTransparency = 0.2
        healthLabel.Parent = billboard
        table.insert(espObjects, healthLabel)
        yOffset = yOffset + 26
    end
    
    if espShowDistance and player ~= LocalPlayer then
        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(1, -10, 0, 14)
        distLabel.Position = UDim2.new(0, 5, 0, yOffset)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = distance .. "m"
        distLabel.TextColor3 = Color3.fromRGB(180, 180, 255)
        distLabel.TextSize = 11
        distLabel.Font = Enum.Font.Gotham
        distLabel.TextStrokeTransparency = 0.2
        distLabel.Parent = billboard
        table.insert(espObjects, distLabel)
        yOffset = yOffset + 16
    end
    
    if espShowWanted and wantedLevel > 0 then
        local wantedLabel = Instance.new("TextLabel")
        wantedLabel.Size = UDim2.new(1, -10, 0, 16)
        wantedLabel.Position = UDim2.new(0, 5, 0, yOffset)
        wantedLabel.BackgroundTransparency = 1
        wantedLabel.Text = "通缉 " .. string.rep("⭐", wantedLevel)
        wantedLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        wantedLabel.TextSize = 12
        wantedLabel.Font = Enum.Font.GothamBold
        wantedLabel.TextStrokeTransparency = 0.2
        wantedLabel.Parent = billboard
        table.insert(espObjects, wantedLabel)
    end
    
    if espDetectFly and isFlying and player ~= LocalPlayer then
        local flyLabel = Instance.new("TextLabel")
        flyLabel.Size = UDim2.new(1, -10, 0, 14)
        flyLabel.Position = UDim2.new(0, 5, 0, yOffset + 16)
        flyLabel.BackgroundTransparency = 1
        flyLabel.Text = "✈ 飞行中"
        flyLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        flyLabel.TextSize = 11
        flyLabel.Font = Enum.Font.GothamBold
        flyLabel.TextStrokeTransparency = 0.2
        flyLabel.Parent = billboard
        table.insert(espObjects, flyLabel)
    end
end

local function UpdateESPNew()
    ClearESPNew()
    if not espEnabled then return end
    
    local flyers = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then
            CreateESPForPlayer(player)
        else
            CreateESPForPlayer(player)
            if espDetectFly and IsPlayerFlying(player) then
                table.insert(flyers, player.Name)
            end
        end
    end
    
    -- 飞行警告
    if espDetectFly and #flyers > 0 then
        if not flyWarnActive then
            flyWarnActive = true
            pcall(function()
                if flyWarnGui then flyWarnGui:Destroy() end
                flyWarnGui = Instance.new("ScreenGui")
                flyWarnGui.Name = "FlyWarnGui"
                flyWarnGui.ResetOnSpawn = false
                flyWarnGui.Parent = CoreGui
                
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(0, 350, 0, 40)
                frame.Position = UDim2.new(0.5, -175, 0, 20)
                frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                frame.BackgroundTransparency = 0.15
                frame.BorderSizePixel = 2
                frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
                frame.Parent = flyWarnGui
                
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 8)
                corner.Parent = frame
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = "检测到其他脚本玩家飞行中，建议更换服务器"
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextSize = 14
                label.Font = Enum.Font.GothamBold
                label.Parent = frame
            end)
        end
    else
        if flyWarnActive then
            flyWarnActive = false
            if flyWarnGui then
                flyWarnGui:Destroy()
                flyWarnGui = nil
            end
        end
    end
end

espGroup:AddToggle("ESPEnabled", {
    Text = "启用透视",
    Default = false,
    Callback = function(value)
        espEnabled = value
        if value then
            UpdateESPNew()
            if not espRenderConnection then
                espRenderConnection = RunService.Heartbeat:Connect(function()
                    espUpdateTimer = espUpdateTimer + 1
                    if espUpdateTimer >= 5 then
                        espUpdateTimer = 0
                        if espEnabled then UpdateESPNew() end
                    end
                end)
            end
            Players.PlayerAdded:Connect(function()
                if espEnabled then UpdateESPNew() end
            end)
            Players.PlayerRemoving:Connect(function()
                if espEnabled then UpdateESPNew() end
            end)
            for _, player in ipairs(Players:GetPlayers()) do
                player.CharacterAdded:Connect(function()
                    if espEnabled then UpdateESPNew() end
                end)
            end
        else
            ClearESPNew()
        end
    end
})

espGroup:AddDivider()

espGroup:AddToggle("ESPShowName", {
    Text = "显示名字",
    Default = false,
    Callback = function(value)
        espShowName = value
        if espEnabled then UpdateESPNew() end
    end
})

espGroup:AddToggle("ESPShowDistance", {
    Text = "显示距离",
    Default = false,
    Callback = function(value)