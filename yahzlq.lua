local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()
local Confirmed = false

local gradientColors = {
    "rgb(255, 230, 235)",
    "rgb(255, 210, 220)",
    "rgb(255, 190, 205)",
    "rgb(255, 170, 190)",
    "rgb(255, 150, 175)",
    "rgb(245, 140, 180)",
    "rgb(235, 130, 185)",
    "rgb(225, 120, 190)",
    "rgb(215, 110, 195)",
    "rgb(205, 100, 200)"
}

local username = game.Players.LocalPlayer.Name
local coloredUsername = ""
for i = 1, #username do
    local colorIndex = (i - 1) % #gradientColors + 1
    coloredUsername = coloredUsername .. '<font color="' .. gradientColors[colorIndex] .. '">' .. username:sub(i, i) .. '</font>'
end

local version = "v2.0"
local coloredVersion = ""
for i = 1, #version do
    local colorIndex = (i - 1) % #gradientColors + 1
    coloredVersion = coloredVersion .. '<font color="' .. gradientColors[colorIndex] .. '">' .. version:sub(i, i) .. '</font>'
end

WindUI:Popup({
    Title = '<font color="' .. gradientColors[1] .. '">wdf</font><font color="' .. gradientColors[5] .. '">ex</font>',
    IconThemed = true,
    Content = "尊敬的用户 " .. coloredUsername .. " \n您使用的 <font color='" .. gradientColors[1] .. "'>wdf</font><font color='" .. gradientColors[5] .. "'>ex</font> 当前版本型号是: " .. coloredVersion .. "\n脚本已就绪！",
    Buttons = {
        {
            Title = "取消",
            Callback = function() end,
            Variant = "Secondary",
        },
        {
            Title = "执行",
            Icon = "arrow-right",
            Callback = function() 
                Confirmed = true
                createUI()
            end,
            Variant = "Primary",
        }
    }
})

function createUI()
    local Window = WindUI:CreateWindow({
        Title = 'wdfex-Hub',
        Icon = "heart",
        IconThemed = true,
        Author = version,
        Folder = "CloudHub",
        Size = UDim2.fromOffset(580, 440),
        Transparent = true,
        Theme = "Dark",
        HideSearchBar = false,
        ScrollBarEnabled = true,
        Resizable = true,
        Background = "https://raw.githubusercontent.com/XxwanhexxX/UN/main/preview_png.png",
        BackgroundImageTransparency = 0.5,
        User = {
            Enabled = true,
            Callback = function()
                WindUI:Notify({
                    Title = "点击了自己",
                    Content = "没什么", 
                    Duration = 1,
                    Icon = "4483362748"
                })
            end,
            Anonymous = false
        },
        SideBarWidth = 250,
        Search = {
            Enabled = true,
            Placeholder = "搜索...",
            Callback = function(searchText)
                print("搜索内容:", searchText)
            end
        },
        SidePanel = {
            Enabled = true,
            Content = {
                {
                    Type = "Button", 
                    Text = "wdfex-Hub",
                    Style = "Subtle", 
                    Size = UDim2.new(1, -20, 0, 30),
                    Callback = function()
                    end
                }
            }
        }
    })

    Window:EditOpenButton({
        Title = "wdfex-Hub",
        Icon = "rbxassetid://105677776902677",
        CornerRadius = UDim.new(0,16),
        StrokeThickness = 4,
        Color = ColorSequence.new(Color3.fromHex("FF6B6B")),
        Draggable = true,
    })

    Window:Tag({
        Title = "圣奥里",
        Color = Color3.fromHex("#00ffff") 
    })

    Window:EditOpenButton({
        Title = "wdfex-Hub",
        Icon = "heart",
        CornerRadius = UDim.new(0,16),
        StrokeThickness = 4,
        Color = ColorSequence.new(Color3.fromHex("FF6B6B")),
        Draggable = true,
    })

    spawn(function()
        while true do
            for hue = 0, 1, 0.01 do  
                local color = Color3.fromHSV(hue, 0.8, 1)  
                Window:EditOpenButton({
                    Color = ColorSequence.new(color)
                })
                wait(0.04)  
            end
        end
    end)

    -- ==================== 全局变量 ====================
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local player = Players.LocalPlayer
    local isDestroyed = false
    local connections = {}

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

    -- 防甩飞
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

    -- ==================== Tab 创建 ====================
    -- 公告 Tab
    local NoticeTab = Window:Tab({ Title = "公告", Icon = "info" })
    local NoticeSection = NoticeTab:Section({ Title = "作者消息", Opened = true })
    NoticeSection:Paragraph({
        Title = "wdfex",
        Desc = "作者：wdfex\nQQ：1687426335\n已为您开启反作弊与防挂机祝您玩的愉快"
    })
    NoticeSection:Divider()
    NoticeSection:Paragraph({
        Title = "注意事项",
        Desc = "已更换悬浮窗添加了一些功能\n杀戮光环的优先攻击最近目标如果选择距离内没有人\n那这个选项就不会生效杀戮光环正常生效\n请勿将此脚本分享给他人发现我将封禁你的设备让你无法使用\n如果你使用的过程中出现一些bug请联系作者修复\n如果你被封了跟脚本没有任何问题属于自己被挂DC了"
    })

    -- 通知 Tab
    local infoTab = Window:Tab({ Title = "通知", Icon = "layout-grid", Locked = false })
    local infoSection = infoTab:Section({ Title = "详情信息", Icon = "info", Opened = true })
    infoSection:Divider()
    infoSection:Paragraph({
        Title = "关于",
        Desc = "目前还有一些问题\n可能无法解决\n已解决使用手机的用户开启飞天卡10帧问题\n此脚本由wdfex一人开发",
        ThumbnailSize = 190,
    })
    local infoSection2 = infoTab:Section({ Title = "更新公告", Icon = "bell", Opened = true })
    infoSection2:Divider()
    infoSection2:Paragraph({
        Title = "v2.1提示",
        Desc = "即将更新v2.1版本此版本将会开启收费\n如果你跟作者认识可以跟作者要一张月卡",
        ThumbnailSize = 190,
    })
    infoTab:Select()

    -- 主功能 Section
    local MainSection = Window:Section({
        Title = "主功能",
        Opened = true,
    })

    local function AddTab(section, title, icon)
        return section:Tab({ Title = title, Icon = icon })
    end

    local A = AddTab(MainSection, "玩家修改", "user")
    local B = AddTab(MainSection, "枪械功能", "target")
    local C = AddTab(MainSection, "杀戮光环", "skull")
    local D = AddTab(MainSection, "传送点", "map-pin")
    local E = AddTab(MainSection, "透视", "eye")

    -- 其他功能 Section
    local OtherSection = Window:Section({
        Title = "其他功能",
        Opened = true,
    })

    local F = AddTab(OtherSection, "开发者功能", "code")
    local G = AddTab(OtherSection, "设置", "settings")

    -- ============================================================
    -- 玩家修改 Tab (A)
    -- ============================================================
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

    local interactEnabled = false
    A:Divider({ Text = "快速互动" })
    A:Toggle({
        Title = "启用快速互动",
        Value = false,
        Callback = function(value)
            interactEnabled = value
            if value then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") then
                        obj.HoldDuration = Settings.HoldTime
                        obj.MaxActivationDistance = Settings.Distance
                    end
                end
            end
        end
    })
    A:Slider({
        Title = "按住时间",
        Step = 0.1,
        Value = { Min = 0, Max = 10, Default = 0 },
        Callback = function(value)
            Settings.HoldTime = value
            if interactEnabled then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") then
                        obj.HoldDuration = value
                    end
                end
            end
        end
    })
    A:Slider({
        Title = "触发距离",
        Step = 1,
        Value = { Min = 5, Max = 150, Default = 25 },
        Callback = function(value)
            Settings.Distance = value
            if interactEnabled then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") then
                        obj.MaxActivationDistance = value
                    end
                end
            end
        end
    })

    A:Divider({ Text = "伤害免疫" })
    local godOn = false
    A:Toggle({
        Title = "免疫部分伤害",
        Value = false,
        Callback = function(value)
            godOn = value
        end
    })
    A:Paragraph({ Title = "说明", Desc = "免疫火焰和车爆炸时候的伤害" })

    A:Divider({ Text = "角色修改" })
    -- 飞行功能
    local FlySpeed = 35
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
        if not char then flyState.hrp = nil flyState.hum = nil flyAnchor.hrp = nil flyAnchor.head = nil flyAnchor.hum = nil return end
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

    A:Toggle({
        Title = "飞行（绕过）",
        Value = false,
        Callback = function(value)
            if value then startFly() else stopFly() end
        end
    })
    A:Slider({
        Title = "飞行速度",
        Step = 1,
        Value = { Min = 10, Max = 620, Default = 35 },
        Callback = function(value)
            FlySpeed = value
        end
    })

    A:Divider({ Text = "穿墙" })
    A:Toggle({
        Title = "启用人物穿墙",
        Value = false,
        Callback = function(value)
            Settings.NoclipEnabled = value
            if value then
                local char = player.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
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
    })

    A:Divider({ Text = "移速" })
    local speedBypassOn = false
    local speedBypassValue = 20
    A:Toggle({
        Title = "修改移速（绕过）",
        Value = false,
        Callback = function(value)
            speedBypassOn = value
        end
    })
    A:Slider({
        Title = "移速",
        Step = 1,
        Value = { Min = 5, Max = 150, Default = 20 },
        Callback = function(value)
            speedBypassValue = value
        end
    })
    RunService.Heartbeat:Connect(function(dt)
        if not speedBypassOn then return end
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if hum and root and hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + hum.MoveDirection * speedBypassValue * dt
        end
    end)

    A:Divider({ Text = "体力" })
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
    A:Toggle({
        Title = "无限体力",
        Value = false,
        Callback = function(value)
            staminaOn = value
        end
    })

    A:Divider({ Text = "防甩飞" })
    A:Toggle({
        Title = "防甩飞",
        Desc = "防止被其他脚本甩飞",
        Value = false,
        Callback = function(value)
            _G.CatAntiFling_Enabled = value
        end
    })

    A:Divider({ Text = "飞天快捷开关" })
    local flyQuickToggle = false
    local flyQuickScreenGui = nil
    local flyQuickButton = nil
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
        flyQuickStatusLabel.Text = "飞行: 关"
        flyQuickStatusLabel.Parent = button

        local function updateFlyStatus()
            if flyQuickStatusLabel then
                flyQuickStatusLabel.Text = flyState.enabled and "飞行: 开" or "飞行: 关"
                if flyQuickButton then
                    flyQuickButton.BorderColor3 = flyState.enabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 200, 255)
                    flyQuickButton.ImageColor3 = flyState.enabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 200, 255)
                end
            end
        end

        button.MouseButton1Click:Connect(function()
            if flyState.enabled then stopFly() else startFly() end
            updateFlyStatus()
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

        updateFlyStatus()

        local statusConn = RunService.Heartbeat:Connect(function()
            if flyQuickToggle and flyQuickStatusLabel then
                updateFlyStatus()
            end
        end)
        table.insert(connections, statusConn)
    end

    A:Toggle({
        Title = "飞天快捷开关",
        Desc = "开启后在屏幕显示可拖动的飞天开关",
        Value = false,
        Callback = function(value)
            flyQuickToggle = value
            if value then
                CreateFlyQuickToggle()
            else
                DestroyFlyQuickToggle()
            end
        end
    })

    -- ============================================================
    -- 枪械功能 Tab (B)
    -- ============================================================
    B:Divider({ Text = "枪械强化" })
    B:Toggle({
        Title = "超快射速",
        Value = false,
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
            WindUI:Notify({ Title = "武器强化", Content = "无限射速已生效，死亡后自动重新生效", Duration = 3 })
        end
    })

    local infAmmoEnabled = false
    B:Toggle({
        Title = "无限子弹",
        Value = false,
        Callback = function(value)
            infAmmoEnabled = value
        end
    })
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

    B:Divider({ Text = "碰撞箱扩展" })
    B:Toggle({
        Title = "启用头部碰撞箱（推荐20-25）",
        Value = false,
        Callback = function(value)
            Settings.HitboxEnabled = value
            if value then ApplyHitbox() else ResetHitbox() end
        end
    })
    B:Slider({
        Title = "头部大小",
        Step = 1,
        Value = { Min = 5, Max = 400, Default = 10 },
        Callback = function(value)
            Settings.HitboxSize = value
            if Settings.HitboxEnabled then ApplyHitbox() end
        end
    })
    B:Toggle({
        Title = "好友检测 (白名单)",
        Value = false,
        Callback = function(value)
            Settings.WhitelistEnabled = value
            if value then UpdateWhitelist() end
        end
    })

    B:Divider({ Text = "子追" })
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
            task.wait(0.2)
        end
    end)

    B:Toggle({
        Title = "启用子追",
        Value = false,
        Callback = function(value)
            zzEnabled = value
            if not value then zzRestore() end
        end
    })
    B:Slider({
        Title = "判定距离",
        Step = 1,
        Value = { Min = 0, Max = 1000, Default = 40 },
        Callback = function(value)
            zzDistance = value
        end
    })

    B:Divider({ Text = "自瞄" })
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

    B:Toggle({
        Title = "自瞄",
        Value = false,
        Callback = function(value)
            aimOn = value
        end
    })
    B:Slider({
        Title = "FOV圈大小",
        Step = 1,
        Value = { Min = 30, Max = 400, Default = 150 },
        Callback = function(value)
            aimFOV = value
        end
    })
    B:Toggle({
        Title = "不瞄准队友",
        Value = true,
        Callback = function(value)
            aimNoTeam = value
        end
    })
    B:Toggle({
        Title = "墙壁检测",
        Value = true,
        Callback = function(value)
            aimWall = value
        end
    })

    -- ============================================================
    -- 杀戮光环 Tab (C)
    -- ============================================================
    local KA_MAX_DISTANCE = 300
    local KA_WALL_CHECK = true
    local kaEnabled = false
    local KANearestOnly = false
    local KA_NEAREST_DISTANCE = 25
    local KATargetPoliceOnly = false
    local KATargetCivilianOnly = false
    local KAIgnoreDead = true

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

        local function isTargetAllowed(p)
            if KATargetPoliceOnly and KATargetCivilianOnly then return false end
            local teamName = p.Team and p.Team.Name or ""
            local isPolice = teamName:find("警察") or teamName:find("Police") or teamName:find("Cop")
            local isCivilian = teamName == "" or teamName:find("平民") or teamName:find("Citizen") or teamName:find("圣奥里公民")
            if KATargetPoliceOnly then
                if not isPolice then return false end
            elseif KATargetCivilianOnly then
                if not isCivilian then return false end
            end
            if KAIgnoreDead then
                local hum = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
                if not hum or hum.Health <= 0 then return false end
            end
            return true
        end

        if KANearestOnly then
            local nearestInRange = nil
            local nearestDistInRange = 9999
            local anyEnemy = nil
            local anyDist = 9999
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local head = p.Character:FindFirstChild("Head")
                        if head and isTargetAllowed(p) then
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
            end
            if nearestInRange then return nearestInRange else return anyEnemy end
        end

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local head = p.Character:FindFirstChild("Head")
                    if head and isTargetAllowed(p) then
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
                    local damage = 300
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
                end
            end
        end
    end)

    C:Divider({ Text = "杀戮光环" })
    C:Paragraph({ Title = "注意", Desc = "需装备枪械武器才有伤害" })
    C:Toggle({
        Title = "启用杀戮光环",
        Value = false,
        Callback = function(value)
            kaEnabled = value
        end
    })
    C:Slider({
        Title = "攻击距离",
        Step = 1,
        Value = { Min = 50, Max = 1000, Default = 300 },
        Callback = function(value)
            KA_MAX_DISTANCE = value
        end
    })
    C:Toggle({
        Title = "墙体检测",
        Value = true,
        Callback = function(value)
            KA_WALL_CHECK = value
        end
    })

    C:Divider({ Text = "过滤" })
    C:Toggle({
        Title = "只攻击警察",
        Value = false,
        Callback = function(value)
            KATargetPoliceOnly = value
            if value and KATargetCivilianOnly then
                KATargetCivilianOnly = false
            end
        end
    })
    C:Toggle({
        Title = "只攻击平民",
        Value = false,
        Callback = function(value)
            KATargetCivilianOnly = value
            if value and KATargetPoliceOnly then
                KATargetPoliceOnly = false
            end
        end
    })
    C:Toggle({
        Title = "不攻击血量为0的玩家",
        Value = true,
        Callback = function(value)
            KAIgnoreDead = value
        end
    })

    C:Divider({ Text = "优先攻击" })
    C:Toggle({
        Title = "优先攻击最近目标",
        Value = false,
        Callback = function(value)
            KANearestOnly = value
        end
    })
    C:Slider({
        Title = "优先攻击距离",
        Step = 1,
        Value = { Min = 5, Max = 100, Default = 25 },
        Callback = function(value)
            KA_NEAREST_DISTANCE = value
        end
    })

    -- ============================================================
    -- 传送点 Tab (D)
    -- ============================================================
    D:Toggle({
        Title = "启用传送",
        Value = false,
        Callback = function(value)
            Settings.TeleportEnabled = value
        end
    })

    local FIXED_TELEPORTS = {
        {n = "车辆经销商", p = Vector3.new(3719.9501953125, 3.018573522567749, -333.3118591308594)},
        {n = "医院", p = Vector3.new(3980.091064453125, 2.876060724258423, -138.79454040527344)},
        {n = "警察局", p = Vector3.new(3364.273193359375, 3.9188079834, -394.7233581542969)},
        {n = "圣奥里修车店", p = Vector3.new(2782.46875, 2.630995750427246, -418.59930419921875)},
        {n = "圣奥里银行", p = Vector3.new(3134.05419921875, 6.116048336029053, -171.36976623535156)},
        {n = "圣奥里服装店", p = Vector3.new(3617.91259765625, 3.1072206497192383, -452.8206481933594)},
        {n = "圣奥里平民重生", p = Vector3.new(3741.114990234375, 3.720573663711548, -438.1059875488281)},
        {n = "圣奥里码头", p = Vector3.new(4527.65625, -23.968238830566406, -280.59356689453125)},
        {n = "圣奥里餐饮店", p = Vector3.new(3182.416748046875, 3.01859188079834, 426.5179138183594)},
        {n = "消防部门", p = Vector3.new(3578.676025390625, 8.408823013305664, 579.6567993164062)},
        {n = "宠物店", p = Vector3.new(3678.237305, 3.017920, 693.114624)},
        {n = "圣奥里大码头", p = Vector3.new(2736.307617, 2.630299, -1120.333008)},
        {n = "圣奥里海滩桥下(消星点)", p = Vector3.new(3964.504395, -25.068211, -854.057251)},
        {n = "大景超市", p = Vector3.new(3936.582764, 3.038293, 1136.326416)},
        {n = "转镜中心", p = Vector3.new(4152.919922, 2.631675, 941.446045)},
        {n = "道路服务", p = Vector3.new(4271.332520, 2.628108, 1200.086914)},
        {n = "大景餐饮店", p = Vector3.new(4476.997559, 3.037825, 906.802979)},
        {n = "送货中心", p = Vector3.new(4399.419434, 3.038999, 1609.455933)},
        {n = "大景卖车店", p = Vector3.new(3434.377441, 42.931786, 2687.997070)},
        {n = "莱斯维尔餐饮店", p = Vector3.new(753.757812, 3.039824, 998.132996)},
        {n = "莱斯维尔服装店", p = Vector3.new(820.745117, 2.766988, 1047.445679)},
        {n = "莱斯维尔自由广场", p = Vector3.new(926.523376, 2.630995, 865.764771)},
        {n = "莱斯维尔码头(游艇)", p = Vector3.new(947.840210, -22.529087, 1216.085693)},
        {n = "米尔顿左上加油站", p = Vector3.new(1145.635742, 2.630916, -864.273682)},
        {n = "米尔顿右下加油站", p = Vector3.new(-1646.802734, 2.630164, 1812.894653)},
        {n = "米尔顿上方加油站", p = Vector3.new(-900.701660, 2.630927, 1124.683105)},
        {n = "米尔顿居民区", p = Vector3.new(-528.565552, 2.630996, 1331.981689)},
        {n = "约克镇小银行", p = Vector3.new(-668.217224, 2.630995, -65.347839)},
        {n = "约克镇修车厂", p = Vector3.new(-407.163025, 3.076807, -6.098211)},
        {n = "约克镇枪店", p = Vector3.new(-323.869293, 3.037825, 37.149670)},
        {n = "约克镇重生点", p = Vector3.new(-219.560318, 3.039824, -85.725433)},
        {n = "约克镇当铺", p = Vector3.new(-168.513733, 3.039000, -106.926529)},
        {n = "约克镇卫星车", p = Vector3.new(-302.093567, 3.037825, -167.621017)},
        {n = "约克镇中心点", p = Vector3.new(-275.995209, 2.630996, -139.985352)},
        {n = "黑市", p = Vector3.new(1038.969849, -22.732950, 895.430237)},
        {n = "渔夫码头", p = Vector3.new(-50.147552, -24.555279, 1462.145996)},
        {n = "农场", p = Vector3.new(-1268.339233, 2.572412, 2560.060303)},
        {n = "监狱门口", p = Vector3.new(-1697.931885, 2.630666, 1284.567383)},
        {n = "监狱广场", p = Vector3.new(-1600.602417, 2.631028, 1268.060059)},
        {n = "代尔山", p = Vector3.new(847.062988, 194.115753, -326.212708)},
        {n = "瀑布洞穴(消星点)", p = Vector3.new(3040.956055, 109.688538, 2711.069336)},
        {n = "大桥", p = Vector3.new(949.014954, 25.215754, 2897.654785)},
        {n = "地图右下(消星点)", p = Vector3.new(-1651.385010, 2.414712, 3225.278320)},
        {n = "下部加油站", p = Vector3.new(2270.378174, 2.630927, 154.161484)},
        {n = "游戏厅", p = Vector3.new(2934.893799, 2.956458, 1693.660034)},
        {n = "高尔夫", p = Vector3.new(2280.767090, 3.037836, 1982.357300)},
        {n = "修船厂", p = Vector3.new(4096.405273, -30.401447, 2865.045166)},
    }

    local teleNames = {}
    for _, data in ipairs(FIXED_TELEPORTS) do table.insert(teleNames, data.n) end
    local selectedTeleport = teleNames[1] or ""

    D:Dropdown({
        Title = "选定传送地点",
        Values = teleNames,
        Value = teleNames[1],
        Callback = function(value)
            selectedTeleport = value
        end
    })

    D:Button({
        Title = "传送到选定地点",
        Callback = function()
            if not Settings.TeleportEnabled then
                WindUI:Notify({ Title = "传送", Content = "请先开启传送开关", Duration = 3 })
                return
            end
            for _, data in ipairs(FIXED_TELEPORTS) do
                if data.n == selectedTeleport then
                    local char = player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.CFrame = CFrame.new(data.p)
                        WindUI:Notify({ Title = "传送", Content = "正在传送至: " .. data.n, Duration = 2 })
                    end
                    return
                end
            end
            WindUI:Notify({ Title = "传送", Content = "未找到该地点", Duration = 2 })
        end
    })

    -- ============================================================
    -- 透视 Tab (E)
    -- ============================================================
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

        ESP_LIST[p.UserId] = { Billboard = bb, Frame = f }
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

    E:Toggle({
        Title = "透视总开关",
        Value = false,
        Callback = function(value)
            ESP_ENABLED = value
            if value then RefreshESP() end
        end
    })
    E:Divider()
    E:Toggle({
        Title = "显示名字",
        Value = true,
        Callback = function(value)
            ESP_SHOW_NAME = value
            if ESP_ENABLED then RefreshESP() end
        end
    })
    E:Toggle({
        Title = "显示队伍",
        Value = true,
        Callback = function(value)
            ESP_SHOW_TEAM = value
            if ESP_ENABLED then RefreshESP() end
        end
    })
    E:Toggle({
        Title = "显示血量",
        Value = true,
        Callback = function(value)
            ESP_SHOW_HEALTH = value
            if ESP_ENABLED then RefreshESP() end
        end
    })
    E:Toggle({
        Title = "显示距离",
        Value = true,
        Callback = function(value)
            ESP_SHOW_DIST = value
            if ESP_ENABLED then RefreshESP() end
        end
    })

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
    Players.PlayerRemoving:Connect(function(p)
        RemoveESP(p.UserId)
    end)

    -- ============================================================
    -- 开发者功能 Tab (F)
    -- ============================================================
    F:Divider({ Text = "坐标工具" })
    F:Button({
        Title = "开启坐标显示",
        Callback = function()
            local char = player.Character or player.CharacterAdded:Wait()
            local root = char:WaitForChild("HumanoidRootPart")
            local gui = Instance.new("ScreenGui")
            gui.Name = "CoordinateCopyTool"
            gui.Parent = player:WaitForChild("PlayerGui")

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 250, 0, 100)
            frame.Position = UDim2.new(0.5, -125, 0.5, -50)
            frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            frame.Active = true
            frame.Parent = gui

            local textBox = Instance.new("TextBox")
            textBox.Size = UDim2.new(0.9, 0, 0, 30)
            textBox.Position = UDim2.new(0.05, 0, 0.15, 0)
            textBox.Text = "加载中..."
            textBox.ClearTextOnFocus = false
            textBox.TextEditable = false
            textBox.Parent = frame

            local copyBtn = Instance.new("TextButton")
            copyBtn.Size = UDim2.new(0.9, 0, 0, 35)
            copyBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
            copyBtn.Text = "点击准备复制 (Ctrl+C)"
            copyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            copyBtn.TextColor3 = Color3.new(1, 1, 1)
            copyBtn.Parent = frame

            local dragging = false
            local dragStart, startPos

            frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    dragStart = input.Position
                    startPos = frame.Position
                end
            end)

            frame.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local delta = input.Position - dragStart
                    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)

            frame.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            RunService.RenderStepped:Connect(function()
                local pos = root.Position
                local formattedPos = string.format("%.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z)
                if not textBox:IsFocused() then
                    textBox.Text = formattedPos
                end
            end)

            copyBtn.MouseButton1Click:Connect(function()
                textBox:CaptureFocus()
                textBox.SelectionStart = 1
                textBox.CursorPosition = #textBox.Text + 1
                copyBtn.Text = "现在按下 Ctrl + C 复制！"
                task.wait(2)
                copyBtn.Text = "点击准备复制 (Ctrl+C)"
            end)
        end
    })
    F:Button({
        Title = "关闭坐标显示",
        Callback = function()
            local gui = player.PlayerGui:FindFirstChild("CoordinateCopyTool")
            if gui then gui:Destroy() end
        end
    })

    -- ============================================================
    -- 设置 Tab (G)
    -- ============================================================
    G:Button({
        Title = "卸载脚本",
        Callback = function()
            isDestroyed = true
            stopFly()
            DestroyFlyQuickToggle()
            zzRestore()
            if aimGui then aimGui:Destroy() end
            ResetHitbox()
            if Settings.NoclipEnabled then
                local char = player.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
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
            Window:Destroy()
            WindUI:Notify({ Title = "已卸载", Content = "脚本已安全卸载", Duration = 2 })
        end
    })

    WindUI:Notify({
        Title = "wdfex-Hub",
        Content = "脚本已加载成功，欢迎使用！",
        Duration = 3,
    })
end
这个新代码