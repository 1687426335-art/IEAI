-- ========== 皮脚本-原版功能+过检测 ==========
-- 直接从原版提取功能代码 + 过检测

local VirtualUserService = game:GetService("VirtualUser")
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ==================== 反挂机 ====================
game:GetService("Players").LocalPlayer.Idled:connect(function()
    VirtualUserService:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUserService:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- ==================== 过检测系统 ====================
local bypassActive = false
local bypassConnections = {}

local function startBypass()
    if bypassActive then return end
    bypassActive = true
    print("🛡️ 启动过检测...")

    pcall(function()
        local oldKick = player.Kick
        player.Kick = function(self, message)
            print("🛡️ 拦截踢出: " .. tostring(message))
            return nil
        end
        table.insert(bypassConnections, {Disconnect = function()
            player.Kick = oldKick
        end})
    end)

    pcall(function()
        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                local healthConn = hum.HealthChanged:Connect(function()
                    if hum.Health <= 0 then
                        task.wait(0.1)
                        if hum and hum.Parent then
                            hum.Health = hum.MaxHealth
                        end
                    end
                end)
                table.insert(bypassConnections, healthConn)
            end
        end
    end)

    pcall(function()
        local function antiTeleport()
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local lastPos = hrp.Position
                    local heartbeatConn = RunService.Heartbeat:Connect(function()
                        if not hrp or not hrp.Parent then return end
                        if (hrp.Position - lastPos).Magnitude > 100 then
                            hrp.CFrame = CFrame.new(lastPos)
                        end
                        lastPos = hrp.Position
                    end)
                    table.insert(bypassConnections, heartbeatConn)
                end
            end
        end
        antiTeleport()
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            antiTeleport()
        end)
    end)

    pcall(function()
        local behaviorConn = RunService.Heartbeat:Connect(function()
            if math.random(1, 100) > 95 then
                VirtualUserService:CaptureController()
                VirtualUserService:ClickButton2(Vector2.new())
            end
        end)
        table.insert(bypassConnections, behaviorConn)
    end)

    pcall(function()
        local TeleportService = game:GetService("TeleportService")
        local parentConn = player:GetPropertyChangedSignal("Parent"):Connect(function()
            if not player.Parent then
                print("🔄 被踢出，正在重连...")
                task.wait(2)
                TeleportService:Teleport(game.PlaceId, player)
            end
        end)
        table.insert(bypassConnections, parentConn)
    end)

    print("✅ 过检测已启动")
end)

-- ==================== UI库 ====================
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/%E7%9A%AE%E8%84%9A%E6%9C%ACUI%E6%BA%90%E7%A0%81.lua"))():new("皮脚本-过检测版")

-- ==================== 信息页 ====================
local InfoTab = UILibrary:Tab("『信息』", "18930406865")
local PlayerInfoSection = InfoTab:section("玩家信息", true)
PlayerInfoSection:Label("您的注入器:" .. identifyexecutor())
PlayerInfoSection:Label("您的用户名:" .. game.Players.LocalPlayer.Character.Name)
PlayerInfoSection:Label("您的用户ID:" .. game.Players.LocalPlayer.UserId)
PlayerInfoSection:Label("您当前服务器的ID:" .. game.GameId)
PlayerInfoSection:Label("🛡️ 过检测: 已启动")

local AuthorInfoSection = InfoTab:section("作者信息", true)
AuthorInfoSection:Label("皮脚本")
AuthorInfoSection:Label("作者: 小皮")
AuthorInfoSection:Label("作者QQ: 2131869117")

-- ==================== 通用页 ====================
local GeneralTab = UILibrary:Tab("『通用』", "18930406865")
local LocalPlayerSection = GeneralTab:section("本地玩家", true)

-- 速度
LocalPlayerSection:Slider("设置速度", "WalkSpeed", 16, 16, 400, false, function(v)
    spawn(function()
        while task.wait() do
            pcall(function()
                if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
                end
            end)
        end
    end)
end)

-- 跳跃高度
LocalPlayerSection:Slider("设置跳跃高度", "JumpPower", 50, 50, 400, false, function(v)
    spawn(function()
        while task.wait() do
            pcall(function()
                if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                    game.Players.LocalPlayer.Character.Humanoid.JumpPower = v
                end
            end)
        end
    end)
end)

-- 无限跳
LocalPlayerSection:Toggle("无限跳", "IJ", false, function(enabled)
    getgenv().InfJ = enabled
    game:GetService("UserInputService").JumpRequest:connect(function()
        if InfJ == true then
            pcall(function()
                game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end)
        end
    end)
end)

-- 穿墙
LocalPlayerSection:Toggle("穿墙", "NoClip", false, function(enabled)
    if enabled then
        Clipon = true
    else
        Clipon = false
    end
    Stepped = game:GetService("RunService").Stepped:Connect(function()
        if Clipon then
            for _, child in pairs(workspace:GetChildren()) do
                if child.Name == game.Players.LocalPlayer.Name then
                    for _, part in pairs(workspace[game.Players.LocalPlayer.Name]:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end
        else
            Stepped:Disconnect()
        end
    end)
end)

-- 夜视
LocalPlayerSection:Toggle("夜视", "Light", false, function(enabled)
    spawn(function()
        while task.wait() do
            local lighting = game.Lighting
            if enabled then
                lighting.Ambient = Color3.new(1, 1, 1)
            else
                lighting.Ambient = Color3.new(0, 0, 0)
            end
        end
    end)
end)

-- 人物显示
LocalPlayerSection:Toggle("人物显示", "RWXS", false, function(enabled)
    getgenv().enabled = enabled
    getgenv().filluseteamcolor = true
    getgenv().outlineuseteamcolor = true
    getgenv().fillcolor = Color3.new(1, 0, 0)
    getgenv().outlinecolor = Color3.new(1, 1, 1)
    getgenv().filltrans = 0.5
    getgenv().outlinetrans = 0.5
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Vcsk/RobloxScripts/main/Highlight-ESP.lua"))()
end)

-- ==================== 飞行与飞车页 ====================
local FlyTab = UILibrary:Tab("『飞行与飞车』", "18930406865")
local FlySection = FlyTab:section("飞行与飞车", true)

local flyEnabled = false
local flySpeed = 50

-- 飞行
FlySection:Toggle("飞行", "Fly", false, function(enabled)
    local character = LocalPlayer.Character
    if not character or not character.Humanoid then return end
    local humanoid = character.Humanoid
    
    if flyEnabled == true then
        flyEnabled = false
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
        humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
    else
        flyEnabled = true
        character.Animate.Disabled = true
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:AdjustSpeed(0)
        end
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
        humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
    end
    
    local torso = (function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Torso") then
            return LocalPlayer.Character.Torso
        end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("LowerTorso") then
            return LocalPlayer.Character.LowerTorso
        end
    end)()
    
    local flyForward = 0
    local flyBackward = 0
    local flyLeft = 0
    local flyRight = 0
    local currentSpeed = 0
    
    local gyro = Instance.new("BodyGyro", torso)
    gyro.P = 90000
    gyro.maxTorque = Vector3.new(9000000000, 9000000000, 9000000000)
    gyro.cframe = torso.CFrame
    
    local velocity = Instance.new("BodyVelocity", torso)
    velocity.velocity = Vector3.new(0, 0.1, 0)
    velocity.maxForce = Vector3.new(9000000000, 9000000000, 9000000000)
    
    if flyEnabled == true then
        humanoid.PlatformStand = true
    end
    
    while flyEnabled do
        local lr = flyLeft + flyRight
        local fb = flyForward + flyBackward
        if lr ~= 0 or fb ~= 0 then
            currentSpeed = (currentSpeed + 0.5) + currentSpeed / flySpeed
            if currentSpeed > flySpeed then
                currentSpeed = flySpeed
            end
        else
            if currentSpeed ~= 0 then
                currentSpeed = currentSpeed - 1
                if currentSpeed < 0 then
                    currentSpeed = 0
                end
            end
        end
        if lr ~= 0 or fb ~= 0 then
            velocity.velocity = (workspace.CurrentCamera.CFrame.LookVector * (fb)
                + workspace.CurrentCamera.CFrame * CFrame.new(lr, fb * 0.2, 0).p
                - workspace.CurrentCamera.CFrame.p) * currentSpeed
            flyForward = fb
            flyBackward = fb
            flyLeft = lr
            flyRight = lr
        else
            if currentSpeed ~= 0 then
                velocity.velocity = (workspace.CurrentCamera.CFrame.LookVector * (flyForward + flyBackward)
                    + workspace.CurrentCamera.CFrame * CFrame.new((flyLeft + flyRight), (flyForward + flyBackward) * 0.2, 0).p
                    - workspace.CurrentCamera.CFrame.p) * currentSpeed
            else
                velocity.velocity = Vector3.new(0, 0, 0)
            end
        end
        gyro.cframe = workspace.CurrentCamera.CFrame * CFrame.Angles(-math.rad(((flyForward + flyBackward) * 50 * currentSpeed / flySpeed)), 0, 0)
        task.wait()
    end
    
    gyro:Destroy()
    velocity:Destroy()
    humanoid.PlatformStand = false
    character.Animate.Disabled = false
end)

-- 飞行速度调节
FlySection:Button("速度 + 1", function()
    flySpeed = flySpeed + 1
end)
FlySection:Button("速度 - 1", function()
    if flySpeed > 1 then
        flySpeed = flySpeed - 1
    end
end)

-- 上升/下降
FlySection:Button("上升", function()
    LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, 0)
end)
FlySection:Button("下降", function()
    LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -1, 0)
end)

-- 飞车
local carFlyEnabled = false
local carBV = nil
local carBG = nil
local carSpeed = 100

FlySection:Textbox("输入飞行速度", "TextBoxfalg", "输入数字", function(value)
    carSpeed = tonumber(value) or 100
    if not carFlyEnabled then
        carFlyEnabled = true
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                carBV = Instance.new("BodyVelocity")
                carBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                carBV.Velocity = workspace.CurrentCamera.CFrame.LookVector * carSpeed
                carBV.Parent = hrp
                carBG = Instance.new("BodyGyro")
                carBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                carBG.D = 5000
                carBG.P = 50000
                carBG.CFrame = workspace.CurrentCamera.CFrame
                carBG.Parent = hrp
            end
        end
    end
end)

FlySection:Toggle("开始飞行", "Toggleflag", false, function(enabled)
    if enabled then
        carFlyEnabled = true
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                carBV = Instance.new("BodyVelocity")
                carBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                carBV.Velocity = workspace.CurrentCamera.CFrame.LookVector * carSpeed
                carBV.Parent = hrp
                carBG = Instance.new("BodyGyro")
                carBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                carBG.D = 5000
                carBG.P = 50000
                carBG.CFrame = workspace.CurrentCamera.CFrame
                carBG.Parent = hrp
            end
        end
    else
        carFlyEnabled = false
        if carBV then carBV:Destroy(); carBV = nil end
        if carBG then carBG:Destroy(); carBG = nil end
    end
end)

-- 飞车循环
RunService.Heartbeat:Connect(function()
    if carFlyEnabled then
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and carBV and carBG then
                carBV.Velocity = workspace.CurrentCamera.CFrame.LookVector * carSpeed
                carBG.CFrame = workspace.CurrentCamera.CFrame
            end
        end
    end
end)

-- ==================== 旋转与范围页 ====================
local SpinRangeTab = UILibrary:Tab("『旋转与范围』", "18930406865")
local SpinRangeSection = SpinRangeTab:section("旋转与范围", true)

local HitboxSize = 15
local HitboxTransparency = 0.9
local HitboxStatus = false
local TeamCheck = false

SpinRangeSection:Toggle("开启/关闭范围", "HitboxStatus", false, function(enabled)
    HitboxStatus = enabled
end)

SpinRangeSection:Textbox("范围大小设置", "HitboxSize", "输入", function(size)
    HitboxSize = tonumber(size) or 15
end)

SpinRangeSection:Toggle("队伍检测", "TeamCheck", false, function(enabled)
    TeamCheck = enabled
end)

-- 范围渲染
RunService.RenderStepped:connect(function()
    if HitboxStatus == true then
        for _, pl in next, game:GetService("Players"):GetPlayers() do
            if pl.Name ~= game:GetService("Players").LocalPlayer.Name then
                if TeamCheck == false or (TeamCheck == true and game:GetService("Players").LocalPlayer.Team ~= pl.Team) then
                    pcall(function()
                        pl.Character.HumanoidRootPart.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                        pl.Character.HumanoidRootPart.Transparency = HitboxTransparency
                        pl.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really red")
                        pl.Character.HumanoidRootPart.Material = "Neon"
                        pl.Character.HumanoidRootPart.CanCollide = false
                    end)
                end
            end
        end
    else
        for _, pl in next, game:GetService("Players"):GetPlayers() do
            if pl.Name ~= game:GetService("Players").LocalPlayer.Name then
                pcall(function()
                    pl.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                    pl.Character.HumanoidRootPart.Transparency = 1
                    pl.Character.HumanoidRootPart.Material = "Plastic"
                    pl.Character.HumanoidRootPart.CanCollide = false
                end)
            end
        end
    end
end)

-- ==================== 绘制（ESP） ====================
local espEnabled = false
local espObjects = {}

local function worldToScreen(pos)
    local sp, onScreen = Camera:WorldToScreenPoint(pos)
    return Vector2.new(sp.X, sp.Y), onScreen
end

local function createESPObject(pl)
    local container = Instance.new("Frame")
    container.Parent = CoreGui
    container.Size = UDim2.new(0, 200, 0, 80)
    container.BackgroundTransparency = 1
    container.Visible = false
    container.ZIndex = 10
    
    local box = Instance.new("Frame")
    box.Parent = container
    box.Size = UDim2.new(0, 50, 0, 70)
    box.Position = UDim2.new(0, -25, 0, -35)
    box.BackgroundTransparency = 0.6
    box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    box.BorderSizePixel = 2
    box.BorderColor3 = Color3.fromRGB(0, 200, 255)
    
    local healthBg = Instance.new("Frame")
    healthBg.Parent = container
    healthBg.Size = UDim2.new(0, 52, 0, 4)
    healthBg.Position = UDim2.new(0, -26, 0, 38)
    healthBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    healthBg.BorderSizePixel = 0
    
    local healthBar = Instance.new("Frame")
    healthBar.Parent = container
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthBar.BorderSizePixel = 0
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = container
    nameLabel.Size = UDim2.new(0, 120, 0, 18)
    nameLabel.Position = UDim2.new(0, -60, 0, -52)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = ""
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 12
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0.3
    
    local distLabel = Instance.new("TextLabel")
    distLabel.Parent = container
    distLabel.Size = UDim2.new(0, 60, 0, 16)
    distLabel.Position = UDim2.new(0, -30, 0, 58)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = ""
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLabel.TextSize = 10
    distLabel.Font = Enum.Font.Gotham
    
    return {
        container = container,
        box = box,
        healthBg = healthBg,
        healthBar = healthBar,
        name = nameLabel,
        dist = distLabel
    }
end

local function updateESP()
    if not espEnabled then
        for _, obj in pairs(espObjects) do
            if obj.container then obj.container.Visible = false end
        end
        return
    end
    
    local localChar = LocalPlayer.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
    
    for _, pl in pairs(Players:GetPlayers()) do
        if pl == LocalPlayer then goto continue end
        local char = pl.Character
        if not char then goto continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if not hrp or not hum then goto continue end
        
        if not espObjects[pl.UserId] then
            espObjects[pl.UserId] = createESPObject(pl)
        end
        
        local obj = espObjects[pl.UserId]
        local headPos = hrp.Position + Vector3.new(0, 2.5, 0)
        local footPos = hrp.Position - Vector3.new(0, 2, 0)
        local screenHead, onScreen = worldToScreen(headPos)
        local screenFoot, _ = worldToScreen(footPos)
        
        if not onScreen then
            obj.container.Visible = false
            goto continue
        end
        
        local height = math.abs(screenFoot.Y - screenHead.Y)
        if height < 20 then height = 60 end
        
        obj.container.Position = UDim2.new(0, screenHead.X, 0, screenHead.Y - height * 0.5)
        obj.container.Size = UDim2.new(0, height * 0.5, 0, height)
        
        obj.box.Size = UDim2.new(1, 0, 1, 0)
        obj.box.Position = UDim2.new(0, 0, 0, 0)
        
        local hpPercent = math.max(hum.Health / hum.MaxHealth, 0)
        obj.healthBar.Size = UDim2.new(hpPercent, 0, 1, 0)
        obj.healthBar.BackgroundColor3 = hpPercent > 0.5 and Color3.fromRGB(0, 255, 0)
            or (hpPercent > 0.25 and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(255, 0, 0))
        obj.healthBg.Size = UDim2.new(1, 0, 0, 4)
        obj.healthBg.Position = UDim2.new(0, 0, 1, 4)
        
        obj.name.Text = pl.Name
        obj.name.Position = UDim2.new(0.5, -60, 0, -18)
        
        local dist = localRoot and (hrp.Position - localRoot.Position).Magnitude or 0
        obj.dist.Text = math.round(dist) .. "m"
        obj.dist.Position = UDim2.new(0.5, -30, 1, 2)
        
        obj.container.Visible = true
        ::continue::
    end
    
    for id, obj in pairs(espObjects) do
        if not Players:GetPlayerByUserId(id) then
            if obj.container then obj.container:Destroy() end
            espObjects[id] = nil
        end
    end
end

-- 绘制开关
local ESPTab = UILibrary:Tab("『透视ESP』", "18930406865")
local ESPSection = ESPTab:section("透视ESP", true)
ESPSection:Toggle("开启绘制", "ESP", false, function(enabled)
    espEnabled = enabled
end)

-- 绘制循环
RunService.RenderStepped:Connect(function()
    updateESP()
end)

-- ==================== 传送页 ====================
local TeleportSection = UILibrary:Tab("『传送与甩飞』", "18930406865"):section("传送与甩飞玩家", true)

local PlayerConfig = {
    playernamedied = "",
    dropdown = {},
}

function shuaxinlb(includeSelf)
    PlayerConfig.dropdown = {}
    if includeSelf == true then
        for _, v in pairs(game.Players:GetPlayers()) do
            table.insert(PlayerConfig.dropdown, v.Name)
        end
    else
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player then
                table.insert(PlayerConfig.dropdown, v.Name)
            end
        end
    end
end
shuaxinlb(true)

local playerDropdown = TeleportSection:Dropdown("选择玩家名称", "Dropdown", PlayerConfig.dropdown, function(v)
    PlayerConfig.playernamedied = v
end)

TeleportSection:Button("刷新玩家名称", function()
    shuaxinlb(true)
    playerDropdown:SetOptions(PlayerConfig.dropdown)
end)

TeleportSection:Button("传送到玩家旁边", function()
    local target = game.Players:FindFirstChild(PlayerConfig.playernamedied)
    if target and target.Character and target.Character.HumanoidRootPart then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
    end
end)

-- ==================== 启动过检测 ====================
task.wait(1)
startBypass()

print("========================================")
print("  ✅ 皮脚本-过检测版 加载成功")
print("  🛡️ 过检测已启动")
print("  功能: 加速 | 飞行 | 飞车 | 范围 | 绘制")
print("========================================")