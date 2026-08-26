-- ===== wdfex-圣奥里 =====
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/kitten-maomao/cdnUI/refs/heads/main/Mao%20ui%E4%BF%AE%E5%A4%8Dbug.lua"))()
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- ===== 防挂机 =====
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- ===== 窗口 =====
local Window = WindUI:CreateWindow({
    Title = "<font color='#FFC0CB'><b>wdfex-圣奥里</b></font>",
    Author = "<font color='#FFC0CB'><b>wdfex</b></font>",
    Folder = "wdfex圣奥里",
    Size = UDim2.fromOffset(390, 460),
    Transparent = false,
    Theme = "Dark",
    SideBarWidth = 150,
    ScrollBarEnabled = true,
    Background = "rbxassetid://115018839123076",
    BackgroundlmageTransparency = 0.5,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 165, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 192, 203))
    }),
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function() end
    },
})
Window:EditOpenButton({
    Title = "<font color='#FFC0CB'><b>wdfex-圣奥里</b></font>",
    CornerRadius = UDim.new(0, 10),
    StrokeThickness = 2.5,
    Color = ColorSequence.new(Color3.fromRGB(255, 100, 100)),
    Draggable = true,
})

-- ===== 欢迎弹窗 =====
task.wait(0.5)
WindUI:Notify({
    Title = "wdfex-圣奥里",
    Description = "欢迎使用 wdfex 脚本",
    Time = 3,
})
task.wait(0.3)
WindUI:Notify({
    Title = "wdfex-圣奥里",
    Description = "已为您开启防挂机与反作弊，祝您游戏愉快",
    Time = 3,
})

-- ===== 标签（右上角信息） =====
local TimeTag = Window:Tag({
    Title = os.date("%H:%M"),
    Color = Color3.fromRGB(0, 255, 0),
    Radius = 12
})
local TimerTag = Window:Tag({
    Title = "00:00:00",
    Color = Color3.fromRGB(178, 34, 34),
    Radius = 12
})
local SessionTag = Window:Tag({
    Title = "00:00:00",
    Color = Color3.fromRGB(0, 100, 255),
    Radius = 12
})

-- ===== 计时器 =====
local saveFolder = "wdfex圣奥里"
local saveFile = saveFolder .. "/total_time.json"
local function loadTotalTime()
    pcall(function()
        if not isfolder(saveFolder) then makefolder(saveFolder) end
    end)
    local saved = 0
    pcall(function()
        if isfile(saveFile) then
            local data = readfile(saveFile)
            saved = tonumber(data) or 0
        end
    end)
    return saved
end
local function saveTotalTime(total)
    pcall(function()
        if not isfolder(saveFolder) then makefolder(saveFolder) end
        writefile(saveFile, tostring(total))
    end)
end
local historyTime = loadTotalTime()
local sessionStartTime = tick()
local currentSessionStartTime = tick()
local function formatTime(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = math.floor(seconds % 60)
    return string.format("%02d:%02d:%02d", h, m, s)
end
if TimerTag and TimerTag.SetTitle then
    TimerTag:SetTitle(formatTime(historyTime))
end
task.spawn(function()
    while TimerTag do
        task.wait(1)
        if TimeTag and TimeTag.SetTitle then
            TimeTag:SetTitle(os.date("%H:%M"))
        end
        if TimerTag and TimerTag.SetTitle then
            local sessionElapsed = tick() - sessionStartTime
            local totalElapsed = historyTime + sessionElapsed
            TimerTag:SetTitle(formatTime(totalElapsed))
            saveTotalTime(totalElapsed)
        end
        if SessionTag and SessionTag.SetTitle then
            local currentSessionElapsed = tick() - currentSessionStartTime
            SessionTag:SetTitle(formatTime(currentSessionElapsed))
        end
    end
end)

-- ===== 创建Tabs函数 =====
local function CreateTab(name, icon)
    return Window:Tab({ Title = name, Icon = icon })
end

-- ===== 全局设置 =====
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

-- ============================================================
-- Tab: 公告
-- ============================================================
local Tab_Notice = CreateTab("公告", "info")
do
    local Tab = Tab_Notice
    Tab:Paragraph({ Title = "<font color='#FFC0CB'><b>━━━━━━━━━━━━━━━━━━━━</b></font>", Desc = "" })
    Tab:Paragraph({ Title = "<font color='#FFC0CB'><b>作者: wdfex</b></font>", Desc = "" })
    Tab:Paragraph({ Title = "<font color='#FFC0CB'><b>如果有什么需要的功能可以向作者提出建议</b></font>", Desc = "" })
    Tab:Paragraph({ Title = "<font color='#FFC0CB'><b>此脚本无防封需要先执行皮脚本再执行此脚本</b></font>", Desc = "" })
    Tab:Paragraph({ Title = "<font color='#FFC0CB'><b>本脚本已同步连接皮脚本的服务器，可在透视里面打开同行显示即可在皮脚本用户的头上显示皮脚本更容易让你分辨它是什么脚本</b></font>", Desc = "" })
    Tab:Paragraph({ Title = "<font color='#FFC0CB'><b>作者快手: wdfex</b></font>", Desc = "" })
    Tab:Paragraph({ Title = "<font color='#FFC0CB'><b>作者QQ: 1687426335</b></font>", Desc = "" })
    Tab:Paragraph({ Title = "<font color='#FFC0CB'><b>━━━━━━━━━━━━━━━━━━━━</b></font>", Desc = "" })
end

-- ============================================================
-- Tab: 玩家修改
-- ============================================================
local Tab_Player = CreateTab("玩家修改", "user")
do
    local Tab = Tab_Player

    -- ===== 飞行（带飞天快捷开关） =====
    local FlySpeed = 35
    local flyState = { enabled = false }
    local UserInputService = game:GetService("UserInputService")
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
            flyState.hrp = nil; flyState.hum = nil; return
        end
        flyState.hrp = char:FindFirstChild("HumanoidRootPart")
        flyState.hum = char:FindFirstChildOfClass("Humanoid")
    end

    local function startFly()
        if flyState.enabled then return end
        flyRefreshParts()
        if not flyState.hrp or not flyState.hum then return end
        flyState.enabled = true
        flyState.hum:ChangeState(Enum.HumanoidStateType.Climbing)
        flyState.connection = RunService.Heartbeat:Connect(function()
            if not flyState.enabled then return end
            if not flyState.hrp or not flyState.hrp.Parent then
                flyState.enabled = false; return
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
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vertical = 1
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then vertical = -1 end
            local delta = (moveDir + Vector3.new(0, vertical, 0)) * FlySpeed * 0.1
            flyState.hrp.CFrame = flyState.hrp.CFrame + delta
            flyState.hrp.Velocity = Vector3.zero
            if flyState.hum then flyState.hum:ChangeState(Enum.HumanoidStateType.Climbing) end
        end)
        -- 更新快捷开关状态
        if flyQuickStatusLabel then
            flyQuickStatusLabel.Text = "飞行: 开"
            if flyQuickButton then
                flyQuickButton.BorderColor3 = Color3.fromRGB(0, 255, 100)
                flyQuickButton.ImageColor3 = Color3.fromRGB(0, 255, 100)
            end
        end
    end

    local function stopFly()
        flyState.enabled = false
        if flyState.connection then flyState.connection:Disconnect(); flyState.connection = nil end
        if flyState.hum then flyState.hum:ChangeState(Enum.HumanoidStateType.Running) end
        if flyQuickStatusLabel then
            flyQuickStatusLabel.Text = "飞行: 关"
            if flyQuickButton then
                flyQuickButton.BorderColor3 = Color3.fromRGB(100, 200, 255)
                flyQuickButton.ImageColor3 = Color3.fromRGB(100, 200, 255)
            end
        end
    end

    -- 飞天快捷开关（屏幕上的浮动按钮）
    local flyQuickToggle = false
    local flyQuickButton = nil
    local flyQuickScreenGui = nil
    local flyQuickStatusLabel = nil

    local function DestroyFlyQuickToggle()
        if flyQuickScreenGui then
            flyQuickScreenGui:Destroy()
            flyQuickScreenGui = nil
            flyQuickButton = nil
            flyQuickStatusLabel = nil
        end
    end

    local function CreateFlyQuickToggle()
        if flyQuickButton then return end
        flyQuickScreenGui = Instance.new("ScreenGui")
        flyQuickScreenGui.Name = "FlyQuickToggle"
        flyQuickScreenGui.ResetOnSpawn = false
        flyQuickScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        flyQuickScreenGui.Parent = player:WaitForChild("PlayerGui")

        local button = Instance.new("ImageButton")
        button.Size = UDim2.new(0, 60, 0, 60)
        button.Position = UDim2.new(0.5, -30, 0.15, 0)
        button.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        button.BackgroundTransparency = 0.15
        button.BorderSizePixel = 2
        button.BorderColor3 = Color3.fromRGB(100, 200, 255)
        button.Image = "rbxassetid://7734068321"
        button.ImageColor3 = Color3.fromRGB(100, 200, 255)
        button.ScaleType = Enum.ScaleType.Fit
        button.Parent = flyQuickScreenGui
        flyQuickButton = button

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = button

        flyQuickStatusLabel = Instance.new("TextLabel")
        flyQuickStatusLabel.Size = UDim2.new(1, 0, 0, 20)
        flyQuickStatusLabel.Position = UDim2.new(0, 0, 1, 0)
        flyQuickStatusLabel.BackgroundTransparency = 1
        flyQuickStatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        flyQuickStatusLabel.TextSize = 12
        flyQuickStatusLabel.Font = Enum.Font.GothamBold
        flyQuickStatusLabel.TextStrokeTransparency = 0.3
        flyQuickStatusLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        flyQuickStatusLabel.Text = flyState.enabled and "飞行: 开" or "飞行: 关"
        flyQuickStatusLabel.Parent = button

        button.MouseButton1Click:Connect(function()
            if flyState.enabled then
                stopFly()
            else
                startFly()
            end
        end)

        local dragging = false
        local dragStart = nil
        local startPos = nil
        button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = button.Position
            end
        end)
        button.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                local newPos = UDim2.new(
                    startPos.X.Scale + delta.X / player:WaitForChild("PlayerGui").AbsoluteSize.X,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale + delta.Y / player:WaitForChild("PlayerGui").AbsoluteSize.Y,
                    startPos.Y.Offset + delta.Y
                )
                button.Position = newPos
            end
        end)
        button.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
    end

    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>飞行（绕过）</b></font>",
        Default = false,
        Callback = function(s)
            if s then startFly() else stopFly() end
        end
    })
    Tab:Input({
        Title = "<font color='#FFC0CB'><b>飞行速度</b></font>",
        Placeholder = "默认35",
        Default = "35",
        Callback = function(v) local n = tonumber(v); if n then FlySpeed = n end end
    })

    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>飞天快捷开关</b></font>",
        Desc = "<font color='#FFC0CB'>开启后在屏幕显示可拖动的飞天开关</font>",
        Default = false,
        Callback = function(s)
            flyQuickToggle = s
            if s then CreateFlyQuickToggle() else DestroyFlyQuickToggle() end
        end
    })

    -- ===== 穿墙 =====
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>启用人物穿墙</b></font>",
        Default = false,
        Callback = function(s)
            Settings.NoclipEnabled = s
            if s then
                task.spawn(function()
                    while Settings.NoclipEnabled do
                        pcall(function()
                            local char = player.Character
                            if char then
                                for _, part in ipairs(char:GetDescendants()) do
                                    if part:IsA("BasePart") then part.CanCollide = false end
                                end
                            end
                        end)
                        task.wait()
                    end
                end)
            else
                local char = player.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = true end
                    end
                end
            end
        end
    })

    -- ===== 修改移速 =====
    local speedValue = 20
    local speedBypassOn = false
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>修改移速（绕过）</b></font>",
        Desc = "<font color='#FFC0CB'>速度推荐80-90</font>",
        Default = false,
        Callback = function(s)
            speedBypassOn = s
            if s then
                task.spawn(function()
                    while speedBypassOn do
                        pcall(function()
                            local char = player.Character
                            local hum = char and char:FindFirstChildOfClass("Humanoid")
                            local root = char and char:FindFirstChild("HumanoidRootPart")
                            if hum and root and hum.MoveDirection.Magnitude > 0 then
                                root.CFrame = root.CFrame + hum.MoveDirection * speedValue * 0.1
                            end
                            if hum then hum.WalkSpeed = speedValue end
                        end)
                        task.wait()
                    end
                end)
            else
                pcall(function()
                    local char = player.Character
                    if char and char:FindFirstChildOfClass("Humanoid") then
                        char:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
                    end
                end)
            end
        end
    })
    Tab:Input({
        Title = "<font color='#FFC0CB'><b>移速值</b></font>",
        Placeholder = "默认20",
        Default = "20",
        Callback = function(v) local n = tonumber(v); if n then speedValue = n end end
    })

    -- ===== 无限体力 =====
    local staminaOn = false
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
            end
            return oldNamecall(self, ...)
        end)
    end
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>无限体力</b></font>",
        Default = false,
        Callback = function(s)
            staminaOn = s
            if s then
                task.spawn(function()
                    while staminaOn do
                        pcall(function()
                            if StaminaEvent then
                                StaminaEvent:FireServer("setStaminaOrFood", "stamina", 100)
                            end
                        end)
                        task.wait(0.3)
                    end
                end)
            end
        end
    })

    -- ===== 防甩飞 =====
    _G.CatAntiFling_Enabled = false
    _G.CatAntiFling_Running = false
    local function AntiFlingLoop()
        if _G.CatAntiFling_Running then return end
        _G.CatAntiFling_Running = true
        task.spawn(function()
            while not isDestroyed do
                if _G.CatAntiFling_Enabled then
                    pcall(function()
                        local char = player.Character
                        if not char then return end
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if not root then return end
                        local vel = root.Velocity
                        if vel.Magnitude > 500 or math.abs(vel.Y) > 300 then
                            root.Velocity = Vector3.new(0, 0, 0)
                            root.RotVelocity = Vector3.new(0, 0, 0)
                        end
                        for _, obj in ipairs(root:GetChildren()) do
                            if (obj:IsA("BodyVelocity") or obj:IsA("BodyAngularVelocity")) and obj.Name ~= "CatAntiFling" and obj.Name ~= "CatAntiFlingAngular" then
                                obj:Destroy()
                            end
                        end
                    end)
                end
                task.wait()
            end
            _G.CatAntiFling_Running = false
        end)
    end
    AntiFlingLoop()
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>防甩飞</b></font>",
        Default = false,
        Callback = function(s)
            _G.CatAntiFling_Enabled = s
        end
    })
end

-- ============================================================
-- Tab: 枪械功能
-- ============================================================
local Tab_Gun = CreateTab("枪械功能", "target")
do
    local Tab = Tab_Gun

    -- ===== 碰撞箱扩展 =====
    local function ApplyHitbox()
        if isDestroyed or not Settings.HitboxEnabled then return end
        local players = Players:GetPlayers()
        local newAffected = {}
        for _, p in ipairs(players) do
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
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player then
                pcall(function()
                    if p:IsFriendsWith(player.UserId) then
                        Whitelist[p.UserId] = true
                    end
                end)
            end
        end
    end

    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>启用头部碰撞箱</b></font>",
        Desc = "<font color='#FFC0CB'>推荐20-25</font>",
        Default = false,
        Callback = function(s)
            Settings.HitboxEnabled = s
            if s then ApplyHitbox() else ResetHitbox() end
        end
    })
    Tab:Input({
        Title = "<font color='#FFC0CB'><b>头部大小</b></font>",
        Placeholder = "默认10",
        Default = "10",
        Callback = function(v)
            local n = tonumber(v)
            if n then Settings.HitboxSize = n end
            if Settings.HitboxEnabled then ApplyHitbox() end
        end
    })
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>好友检测(白名单)</b></font>",
        Default = false,
        Callback = function(s)
            Settings.WhitelistEnabled = s
            if s then UpdateWhitelist() end
        end
    })

    -- ===== 超快射速 =====
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>超快射速</b></font>",
        Default = false,
        Callback = function(value)
            if not value then return end
            local function ModifyWeaponStats()
                local garbage = getgc(true)
                for _, tbl in pairs(garbage) do
                    if type(tbl) == "table" then
                        if rawget(tbl, "SHOOT_MODE") then rawset(tbl, "SHOOT_MODE", 2) end
                        if rawget(tbl, "RPM") then rawset(tbl, "RPM", math.huge) end
                        if rawget(tbl, "DAMAGE") then rawset(tbl, "DAMAGE", math.huge) end
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
            WindUI:Notify({ Title = "武器强化", Description = "无限射速已生效，死亡后自动重新生效", Time = 3 })
        end
    })

    -- ===== 无限子弹 =====
    local infAmmoEnabled = false
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>无限子弹</b></font>",
        Default = false,
        Callback = function(s)
            infAmmoEnabled = s
            if s then
                task.spawn(function()
                    while infAmmoEnabled and not isDestroyed do
                        pcall(function()
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
                        end)
                        task.wait(0.5)
                    end
                end)
            end
        end
    })

    -- ===== 子追 =====
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
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>启用子追</b></font>",
        Default = false,
        Callback = function(s)
            zzEnabled = s
            if not s then zzRestore() end
            if s then
                task.spawn(function()
                    while zzEnabled and not isDestroyed do
                        pcall(function()
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
                        end)
                        task.wait(0.2)
                    end
                end)
            end
        end
    })
    Tab:Input({
        Title = "<font color='#FFC0CB'><b>判定距离</b></font>",
        Placeholder = "默认40",
        Default = "40",
        Callback = function(v) local n = tonumber(v); if n then zzDistance = n end end
    })

    -- ===== 自瞄 =====
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
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>自瞄</b></font>",
        Default = false,
        Callback = function(s) aimOn = s end
    })
    Tab:Input({
        Title = "<font color='#FFC0CB'><b>FOV圈大小</b></font>",
        Placeholder = "默认150",
        Default = "150",
        Callback = function(v) local n = tonumber(v); if n then aimFOV = n end end
    })
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>不瞄准队友</b></font>",
        Default = true,
        Callback = function(s) aimNoTeam = s end
    })
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>墙壁检测</b></font>",
        Default = true,
        Callback = function(s) aimWall = s end
    })
end

-- ============================================================
-- Tab: 杀戮光环
-- ============================================================
local Tab_KA = CreateTab("杀戮光环", "skull")
do
    local Tab = Tab_KA

    local KA_MAX_DISTANCE = 300
    local KA_WALL_CHECK = true
    local kaEnabled = false
    local kaDamageMultiplier = 1
    local KANearestOnly = false
    local KA_NEAREST_DISTANCE = 25
    local kaAttackPolice = false
    local kaAttackCitizen = false
    local kaStatusText = "状态：已关闭"
    local kaStatusLabel

    kaStatusLabel = Tab:Paragraph({
        Title = "<font color='#FFC0CB'><b>状态：已关闭</b></font>",
        Desc = ""
    })

    local function kaSetStatus(text)
        kaStatusText = text
        if kaStatusLabel and kaStatusLabel.SetTitle then
            kaStatusLabel:SetTitle("<font color='#FFC0CB'><b>" .. text .. "</b></font>")
        end
    end

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

    local function kaIsTargetValid(p)
        if p == player then return false end
        if not p.Character then return false end
        local hum = p.Character:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return false end
        if not p.Character:FindFirstChild("Head") then return false end
        
        -- 队伍过滤逻辑
        if kaAttackPolice and kaAttackCitizen then
            -- 两个都开启：攻击警察和平民
            if p.Team then
                local teamName = p.Team.Name
                if teamName:find("警察") or teamName:find("Police") or teamName:find("平民") or teamName:find("Citizen") then
                    return true
                end
            end
            return false
        elseif kaAttackPolice then
            -- 只攻击警察
            if p.Team then
                local teamName = p.Team.Name
                if teamName:find("警察") or teamName:find("Police") then
                    return true
                end
            end
            return false
        elseif kaAttackCitizen then
            -- 只攻击平民
            if p.Team then
                local teamName = p.Team.Name
                if teamName:find("平民") or teamName:find("Citizen") then
                    return true
                end
            end
            return false
        else
            -- 两个都关闭：攻击所有非自己的玩家
            return true
        end
    end

    local function kaGetNearestEnemy()
        local char = player.Character
        if not char then return nil end
        local myHead = char:FindFirstChild("Head")
        if not myHead then return nil end
        local bestPlayer, bestDist = nil, KA_MAX_DISTANCE

        if KANearestOnly then
            local nearestInRange = nil
            local nearestDistInRange = 9999
            local anyEnemy = nil
            local anyDist = 9999
            for _, p in ipairs(Players:GetPlayers()) do
                if kaIsTargetValid(p) then
                    local head = p.Character:FindFirstChild("Head")
                    if head then
                        local dist = (head.Position - myHead.Position).Magnitude
                        if dist < anyDist and (not KA_WALL_CHECK or kaIsVisible(head)) then
                            anyDist = dist
                            anyEnemy = p
                        end
                        if dist <= KA_NEAREST_DISTANCE and dist < nearestDistInRange and (not KA_WALL_CHECK or kaIsVisible(head)) then
                            nearestDistInRange = dist
                            nearestInRange = p
                        end
                    end
                end
            end
            if nearestInRange then return nearestInRange else return anyEnemy end
        end

        for _, p in ipairs(Players:GetPlayers()) do
            if kaIsTargetValid(p) then
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
        return bestPlayer
    end

    RunService.Heartbeat:Connect(function()
        if not isDestroyed and kaEnabled then
            local target = kaGetNearestEnemy()
            local targetHead = target and target.Character and target.Character:FindFirstChild("Head")
            if targetHead then
                local myHead = player.Character and player.Character:FindFirstChild("Head")
                if myHead then
                    local origin = myHead.Position
                    local hitPos = targetHead.Position
                    local direction = (hitPos - origin).Unit
                    local damage = 100 * kaDamageMultiplier
                    pcall(function()
                        ReplicatedStorage.Remote.PlayerEvent:FireServer("damage", {
                            bodyParts = { { "Head", damage } },
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
                    kaSetStatus("已锁定 " .. target.Name .. "，攻击已发送")
                else
                    kaSetStatus("等待角色头部加载")
                end
            else
                kaSetStatus("范围内未找到敌人")
            end
        end
    end)

    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>启用杀戮光环</b></font>",
        Desc = "<font color='#FFC0CB'>需装备枪械武器才有伤害</font>",
        Default = false,
        Callback = function(s)
            kaEnabled = s
            if s then
                kaSetStatus("已开启，正在搜索敌人")
                WindUI:Notify({ Title = "杀戮光环", Description = "已开启，正在搜索敌人", Time = 3 })
            else
                kaSetStatus("已关闭")
            end
        end
    })
    Tab:Input({
        Title = "<font color='#FFC0CB'><b>攻击距离</b></font>",
        Placeholder = "默认300米",
        Default = "300",
        Callback = function(v) local n = tonumber(v); if n then KA_MAX_DISTANCE = n end end
    })
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>墙体检测</b></font>",
        Default = true,
        Callback = function(s) KA_WALL_CHECK = s end
    })
    Tab:Input({
        Title = "<font color='#FFC0CB'><b>伤害倍率</b></font>",
        Placeholder = "默认1",
        Default = "1",
        Callback = function(v) local n = tonumber(v); if n then kaDamageMultiplier = n end end
    })
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>优先攻击最近目标</b></font>",
        Desc = "<font color='#FFC0CB'>开启后优先攻击25米内的敌人，25米内无人则攻击远处目标</font>",
        Default = false,
        Callback = function(s)
            KANearestOnly = s
            if s then WindUI:Notify({ Title = "杀戮光环", Description = "已切换至25米内优先攻击", Time = 2 }) end
        end
    })
    Tab:Input({
        Title = "<font color='#FFC0CB'><b>优先攻击距离</b></font>",
        Placeholder = "默认25米",
        Default = "25",
        Callback = function(v) local n = tonumber(v); if n then KA_NEAREST_DISTANCE = n end end
    })
    
    -- ===== 新增队伍过滤开关 =====
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>只攻击警察</b></font>",
        Desc = "<font color='#FFC0CB'>开启后杀戮光环只会攻击警察队伍的玩家</font>",
        Default = false,
        Callback = function(s)
            kaAttackPolice = s
            if s and kaAttackCitizen then
                WindUI:Notify({ Title = "杀戮光环", Description = "已开启：攻击警察和平民", Time = 2 })
            elseif s then
                WindUI:Notify({ Title = "杀戮光环", Description = "已开启：只攻击警察", Time = 2 })
            end
        end
    })
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>只攻击平民</b></font>",
        Desc = "<font color='#FFC0CB'>开启后杀戮光环只会攻击平民队伍的玩家</font>",
        Default = false,
        Callback = function(s)
            kaAttackCitizen = s
            if s and kaAttackPolice then
                WindUI:Notify({ Title = "杀戮光环", Description = "已开启：攻击警察和平民", Time = 2 })
            elseif s then
                WindUI:Notify({ Title = "杀戮光环", Description = "已开启：只攻击平民", Time = 2 })
            end
        end
    })
end

-- ============================================================
-- Tab: 传送点
-- ============================================================
local Tab_Teleports = CreateTab("传送点", "map-pin")
do
    local Tab = Tab_Teleports

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
        pcall(function() root.CFrame = CFrame.new(pos) end)
    end

    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>启用传送</b></font>",
        Default = false,
        Callback = function(s) Settings.TeleportEnabled = s end
    })

    local teleNames = {}
    for _, data in ipairs(FIXED_TELEPORTS) do
        table.insert(teleNames, data.n)
    end

    local teleDropdown = Tab:Dropdown({
        Title = "<font color='#FFC0CB'><b>选定传送地点</b></font>",
        Values = teleNames,
        Default = 1,
        Callback = function(v) end
    })

    Tab:Button({
        Title = "<font color='#FFC0CB'><b>传送到选定地点</b></font>",
        Callback = function()
            if not Settings.TeleportEnabled then
                WindUI:Notify({ Title = "传送", Description = "请先开启传送开关", Time = 2 })
                return
            end
            local selected = teleDropdown.Value or teleNames[1]
            for _, data in ipairs(FIXED_TELEPORTS) do
                if data.n == selected then
                    TeleportTo(data.p)
                    WindUI:Notify({ Title = "传送", Description = "正在传送至: " .. data.n, Time = 2 })
                    return
                end
            end
            WindUI:Notify({ Title = "传送", Description = "未找到该地点", Time = 2 })
        end
    })
end

-- ============================================================
-- Tab: 透视
-- ============================================================
local Tab_ESP = CreateTab("透视", "eye")
do
    local Tab = Tab_ESP

    local ESP_ENABLED = false
    local ESP_SHOW_NAME = true
    local ESP_SHOW_TEAM = true
    local ESP_SHOW_HEALTH = true
    local ESP_SHOW_DIST = true
    local ESP_LIST = {}
    local ESP_REFRESH_COUNT = 0

    local function GetTeam(p)
        if p.Team then return p.Team.Name end
        return "平民"
    end
    local function GetTeamColor(p)
        if p.Team then return p.Team.TeamColor.Color end
        return Color3.fromRGB(200, 200, 200)
    end
    local function GetHealth(p)
        local c = p.Character
        if not c then return 0 end
        local h = c:FindFirstChildOfClass("Humanoid")
        if not h then return 0 end
        return math.floor(h.Health)
    end
    local function GetDist(p)
        local mc = player.Character
        if not mc then return 0 end
        local mr = mc:FindFirstChild("HumanoidRootPart")
        if not mr then return 0 end
        local tc = p.Character
        if not tc then return 0 end
        local tr = tc:FindFirstChild("HumanoidRootPart")
        if not tr then return 0 end
        return math.floor((mr.Position - tr.Position).Magnitude)
    end
    local function RemoveESP(id)
        local d = ESP_LIST[id]
        if d then
            if d.Billboard then d.Billboard:Destroy() end
            ESP_LIST[id] = nil
        end
    end
    local function BuildESP(p)
        if not p.Character or p == player then return end
        local head = p.Character:FindFirstChild("Head")
        if not head then return end
        if ESP_LIST[p.UserId] then
            if ESP_LIST[p.UserId].Billboard then
                ESP_LIST[p.UserId].Billboard.Enabled = true
            end
            return
        end
        local bb = Instance.new("BillboardGui")
        bb.Size = UDim2.new(0, 200, 0, 100)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = 500
        bb.Parent = head
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 1, 0)
        f.BackgroundTransparency = 1
        f.Parent = bb
        ESP_LIST[p.UserId] = {Billboard = bb, Frame = f}
    end
    local function RefreshESP()
        if not ESP_ENABLED then
            for _, d in pairs(ESP_LIST) do
                if d.Billboard then d.Billboard.Enabled = false end
            end
            return
        end
        ESP_REFRESH_COUNT = ESP_REFRESH_COUNT + 1
        for _, p in ipairs(Players:GetPlayers()) do
            if p == player then continue end
            if not p.Character then
                RemoveESP(p.UserId)
                continue
            end
            if ESP_REFRESH_COUNT % 30 == 0 and ESP_LIST[p.UserId] then
                RemoveESP(p.UserId)
            end
            if not ESP_LIST[p.UserId] then
                BuildESP(p)
            end
            local d = ESP_LIST[p.UserId]
            if not d then continue end
            if not d.Billboard or not d.Billboard.Parent then
                ESP_LIST[p.UserId] = nil
                BuildESP(p)
                d = ESP_LIST[p.UserId]
                if not d then continue end
            end
            d.Billboard.Enabled = true
            local f = d.Frame
            for _, c in ipairs(f:GetChildren()) do c:Destroy() end
            local y = 0
            local lines = 0
            local team = GetTeam(p)
            local color = GetTeamColor(p)
            local hp = GetHealth(p)
            local dist = GetDist(p)
            if ESP_SHOW_NAME then
                local l = Instance.new("TextLabel")
                l.Size = UDim2.new(1, 0, 0, 20)
                l.Position = UDim2.new(0, 0, 0, y)
                l.BackgroundTransparency = 1
                l.Text = p.Name
                l.TextColor3 = color
                l.TextSize = 15
                l.Font = Enum.Font.GothamBold
                l.TextStrokeTransparency = 0.3
                l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                l.TextXAlignment = Enum.TextXAlignment.Center
                l.Parent = f
                y = y + 22
                lines = lines + 1
            end
            if ESP_SHOW_TEAM then
                local l = Instance.new("TextLabel")
                l.Size = UDim2.new(1, 0, 0, 18)
                l.Position = UDim2.new(0, 0, 0, y)
                l.BackgroundTransparency = 1
                l.Text = "[" .. team .. "]"
                l.TextColor3 = color
                l.TextSize = 13
                l.Font = Enum.Font.GothamBold
                l.TextStrokeTransparency = 0.3
                l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                l.TextXAlignment = Enum.TextXAlignment.Center
                l.Parent = f
                y = y + 20
                lines = lines + 1
            end
            if ESP_SHOW_HEALTH then
                local l = Instance.new("TextLabel")
                l.Size = UDim2.new(1, 0, 0, 18)
                l.Position = UDim2.new(0, 0, 0, y)
                l.BackgroundTransparency = 1
                local c = hp > 70 and Color3.fromRGB(0, 255, 100) or hp > 40 and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(255, 50, 50)
                l.Text = hp .. "HP"
                l.TextColor3 = c
                l.TextSize = 13
                l.Font = Enum.Font.GothamBold
                l.TextStrokeTransparency = 0.3
                l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                l.TextXAlignment = Enum.TextXAlignment.Center
                l.Parent = f
                y = y + 20
                lines = lines + 1
            end
            if ESP_SHOW_DIST then
                local l = Instance.new("TextLabel")
                l.Size = UDim2.new(1, 0, 0, 18)
                l.Position = UDim2.new(0, 0, 0, y)
                l.BackgroundTransparency = 1
                l.Text = dist .. "m"
                l.TextColor3 = Color3.fromRGB(200, 200, 200)
                l.TextSize = 13
                l.Font = Enum.Font.Gotham
                l.TextStrokeTransparency = 0.3
                l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                l.TextXAlignment = Enum.TextXAlignment.Center
                l.Parent = f
                y = y + 20
                lines = lines + 1
            end
            d.Billboard.Size = UDim2.new(0, 200, 0, lines * 20 + 10)
        end
    end

    -- 透视刷新循环
    task.spawn(function()
        while not isDestroyed do
            task.wait(0.15)
            if ESP_ENABLED then RefreshESP() end
        end
    end)
    Players.PlayerAdded:Connect(function(p)
        p.CharacterAdded:Connect(function()
            task.wait(0.3)
            if ESP_ENABLED then RefreshESP() end
        end)
    end)
    Players.PlayerRemoving:Connect(function(p) RemoveESP(p.UserId) end)

    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>透视总开关</b></font>",
        Default = false,
        Callback = function(s)
            ESP_ENABLED = s
            if s then RefreshESP() end
        end
    })
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>绘制名字</b></font>",
        Default = true,
        Callback = function(s) ESP_SHOW_NAME = s; if ESP_ENABLED then RefreshESP() end end
    })
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>绘制血量</b></font>",
        Default = true,
        Callback = function(s) ESP_SHOW_HEALTH = s; if ESP_ENABLED then RefreshESP() end end
    })
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>绘制距离</b></font>",
        Default = true,
        Callback = function(s) ESP_SHOW_DIST = s; if ESP_ENABLED then RefreshESP() end end
    })
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>绘制队伍</b></font>",
        Default = true,
        Callback = function(s) ESP_SHOW_TEAM = s; if ESP_ENABLED then RefreshESP() end end
    })
end

-- ============================================================
-- Tab: 开发者功能
-- ============================================================
local Tab_Developer = CreateTab("开发者功能", "code")
do
    local Tab = Tab_Developer

    local coordPara = Tab:Paragraph({
        Title = "<font color='#FFC0CB'><b>当前坐标: 加载中...</b></font>",
        Desc = ""
    })
    task.spawn(function()
        while coordPara do
            task.wait(0.1)
            pcall(function()
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local pos = char.HumanoidRootPart.Position
                    local coord = string.format("%.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z)
                    if coordPara and coordPara.SetTitle then
                        coordPara:SetTitle("<font color='#FFC0CB'><b>当前坐标: " .. coord .. "</b></font>")
                    end
                end
            end)
        end
    end)

    Tab:Button({
        Title = "<font color='#FFC0CB'><b>复制当前坐标</b></font>",
        Callback = function()
            pcall(function()
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local pos = char.HumanoidRootPart.Position
                    local coord = string.format("%.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z)
                    if setclipboard then setclipboard(coord) end
                    WindUI:Notify({ Title = "坐标复制", Description = coord, Time = 2 })
                end
            end)
        end
    })

    Tab:Button({
        Title = "<font color='#FFC0CB'><b>复制服务器JobId</b></font>",
        Callback = function()
            if setclipboard then setclipboard(game.JobId) end
            WindUI:Notify({ Title = "JobId复制", Description = game.JobId, Time = 2 })
        end
    })

    Tab:Button({
        Title = "<font color='#FFC0CB'><b>复制游戏PlaceId</b></font>",
        Callback = function()
            if setclipboard then setclipboard(tostring(game.PlaceId)) end
            WindUI:Notify({ Title = "PlaceId复制", Description = tostring(game.PlaceId), Time = 2 })
        end
    })
end

-- ============================================================
-- Tab: 设置
-- ============================================================
local Tab_Settings = CreateTab("设置", "settings")
do
    local Tab = Tab_Settings

    Tab:Button({
        Title = "<font color='#FFC0CB'><b>关闭脚本</b></font>",
        Callback = function()
            isDestroyed = true
            if flyState and flyState.enabled then stopFly() end
            if flyQuickScreenGui then flyQuickScreenGui:Destroy() end
            DestroyFlyQuickToggle()
            if aimGui then aimGui:Destroy() end
            ResetHitbox()
            if Settings.NoclipEnabled then
                local char = player.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = true end
                    end
                end
            end
            for userId, data in pairs(ESP_LIST) do
                if data.Billboard then data.Billboard:Destroy() end
            end
            ESP_LIST = {}
            for _, conn in ipairs(connections) do
                pcall(function() conn:Disconnect() end)
            end
            for _, conn in ipairs(noclipConnections) do
                pcall(function() conn:Disconnect() end)
            end
            Window:Close()
        end
    })
end

-- ===== 自动选择第一个Tab =====
Window:SelectTab(1)