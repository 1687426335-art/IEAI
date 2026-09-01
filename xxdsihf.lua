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
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local player = Players.LocalPlayer
    local isDestroyed = false
    local connections = {}

    -- ==================== 统一设备UID检测（换服务器不变） ====================
    local function getDeviceUID()
        local userId = player.UserId
        local success, machineId = pcall(function()
            return game:GetService("HttpService"):GetMachineId()
        end)
        if not success then machineId = "unknown" end
        local combined = userId .. "_" .. machineId
        local uid = ""
        for i = 1, #combined do
            uid = uid .. string.char((string.byte(combined, i) % 26) + 65)
        end
        return uid:sub(1, 32)
    end
    local DEVICE_UID = getDeviceUID()

    -- ==================== 黑名单与授权系统 ====================
    -- 作者UID（你的设备）
    local AUTHOR_UID = "XXCWYXWFYZDRNGDGHPG"

    -- 黑名单列表
    local BLACKLIST = {
        ["XXCWZAYDAXZRNCDCHPCRCBYAX"] = true,
    }

    -- 授权列表（已授权的设备）
    local WHITELIST = {
        ["XXCWYXWFYZDRNGDGHPGRFYDXDACCAD"] = true,
    }

    local function isBlacklisted(uid)
        return BLACKLIST[uid] == true
    end

    local function isAuthorized(uid)
        if uid == AUTHOR_UID then return true end
        return WHITELIST[uid] == true
    end

    -- ==================== 权限验证 ====================
    if isBlacklisted(DEVICE_UID) then
        local blockGui = Instance.new("ScreenGui")
        blockGui.Name = "BlockedScreen"
        blockGui.ResetOnSpawn = false
        blockGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        blockGui.Parent = player:WaitForChild("PlayerGui")

        local blockFrame = Instance.new("Frame")
        blockFrame.Size = UDim2.new(0, 500, 0, 200)
        blockFrame.Position = UDim2.new(0.5, -250, 0.5, -100)
        blockFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
        blockFrame.BorderSizePixel = 3
        blockFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
        blockFrame.Parent = blockGui

        local blockCorner = Instance.new("UICorner")
        blockCorner.CornerRadius = UDim.new(0, 12)
        blockCorner.Parent = blockFrame

        local blockTitle = Instance.new("TextLabel")
        blockTitle.Size = UDim2.new(1, 0, 0, 40)
        blockTitle.Position = UDim2.new(0, 0, 0, 10)
        blockTitle.BackgroundTransparency = 1
        blockTitle.Text = "已被拉黑"
        blockTitle.TextColor3 = Color3.fromRGB(255, 0, 0)
        blockTitle.TextSize = 28
        blockTitle.Font = Enum.Font.GothamBold
        blockTitle.TextXAlignment = Enum.TextXAlignment.Center
        blockTitle.Parent = blockFrame

        local blockDesc = Instance.new("TextLabel")
        blockDesc.Size = UDim2.new(1, -40, 0, 50)
        blockDesc.Position = UDim2.new(0, 20, 0, 60)
        blockDesc.BackgroundTransparency = 1
        blockDesc.Text = "你已被作者或管理拉黑\n你无法使用此脚本"
        blockDesc.TextColor3 = Color3.fromRGB(255, 200, 200)
        blockDesc.TextSize = 18
        blockDesc.Font = Enum.Font.GothamBold
        blockDesc.TextXAlignment = Enum.TextXAlignment.Center
        blockDesc.Parent = blockFrame

        local blockUid = Instance.new("TextLabel")
        blockUid.Size = UDim2.new(1, -40, 0, 30)
        blockUid.Position = UDim2.new(0, 20, 0, 125)
        blockUid.BackgroundTransparency = 1
        blockUid.Text = "设备UID: " .. DEVICE_UID
        blockUid.TextColor3 = Color3.fromRGB(150, 150, 150)
        blockUid.TextSize = 14
        blockUid.Font = Enum.Font.Gotham
        blockUid.TextXAlignment = Enum.TextXAlignment.Center
        blockUid.Parent = blockFrame

        return
    end

    if not isAuthorized(DEVICE_UID) then
        local authGui = Instance.new("ScreenGui")
        authGui.Name = "AuthScreen"
        authGui.ResetOnSpawn = false
        authGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        authGui.Parent = player:WaitForChild("PlayerGui")

        local authFrame = Instance.new("Frame")
        authFrame.Size = UDim2.new(0, 520, 0, 220)
        authFrame.Position = UDim2.new(0.5, -260, 0.5, -110)
        authFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
        authFrame.BorderSizePixel = 3
        authFrame.BorderColor3 = Color3.fromRGB(255, 200, 0)
        authFrame.Parent = authGui

        local authCorner = Instance.new("UICorner")
        authCorner.CornerRadius = UDim.new(0, 12)
        authCorner.Parent = authFrame

        local authTitle = Instance.new("TextLabel")
        authTitle.Size = UDim2.new(1, 0, 0, 40)
        authTitle.Position = UDim2.new(0, 0, 0, 10)
        authTitle.BackgroundTransparency = 1
        authTitle.Text = "未授权"
        authTitle.TextColor3 = Color3.fromRGB(255, 200, 0)
        authTitle.TextSize = 28
        authTitle.Font = Enum.Font.GothamBold
        authTitle.TextXAlignment = Enum.TextXAlignment.Center
        authTitle.Parent = authFrame

        local authDesc = Instance.new("TextLabel")
        authDesc.Size = UDim2.new(1, -40, 0, 50)
        authDesc.Position = UDim2.new(0, 20, 0, 60)
        authDesc.BackgroundTransparency = 1
        authDesc.Text = "你没有被授权\n你无法使用此脚本"
        authDesc.TextColor3 = Color3.fromRGB(255, 220, 150)
        authDesc.TextSize = 18
        authDesc.Font = Enum.Font.GothamBold
        authDesc.TextXAlignment = Enum.TextXAlignment.Center
        authDesc.Parent = authFrame

        local authContact = Instance.new("TextLabel")
        authContact.Size = UDim2.new(1, -40, 0, 25)
        authContact.Position = UDim2.new(0, 20, 0, 118)
        authContact.BackgroundTransparency = 1
        authContact.Text = "请联系作者或管理员授权"
        authContact.TextColor3 = Color3.fromRGB(200, 200, 200)
        authContact.TextSize = 14
        authContact.Font = Enum.Font.Gotham
        authContact.TextXAlignment = Enum.TextXAlignment.Center
        authContact.Parent = authFrame

        local authUid = Instance.new("TextLabel")
        authUid.Size = UDim2.new(1, -40, 0, 30)
        authUid.Position = UDim2.new(0, 20, 0, 150)
        authUid.BackgroundTransparency = 1
        authUid.Text = "设备UID: " .. DEVICE_UID
        authUid.TextColor3 = Color3.fromRGB(150, 200, 255)
        authUid.TextSize = 14
        authUid.Font = Enum.Font.Gotham
        authUid.TextXAlignment = Enum.TextXAlignment.Center
        authUid.Parent = authFrame

        return
    end

    -- ==================== 主UI ====================
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
        Title = DEVICE_UID,
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

    -- ==================== 播放音乐（悬浮窗出来后播放7秒） ====================
    task.spawn(function()
        pcall(function()
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://80701295792893"
            sound.Volume = 1.5
            sound.Parent = player:WaitForChild("PlayerGui")
            sound:Play()
            task.wait(7)
            sound:Stop()
            sound:Destroy()
        end)
    end)

    -- ==================== 其余原有功能 ====================
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
        Desc = "已更换悬浮窗添加了一些功能\n杀戮光环的优先攻击最近目标如果选择距离内没有人\n那这个选项就不会生效杀戮光环正常生效\n请勿将此脚本分享给他人发现我将封禁你的设备\n让你无法使用\n如果你使用的过程中出现一些bug请联系作者修复\n被封永久了就是被挂DC了如果你要是执行其他脚本之后被封的那你也活该"
    })

    -- 通知 Tab
    local infoTab = Window:Tab({ Title = "通知", Icon = "layout-grid", Locked = false })
    local infoSection = infoTab:Section({ Title = "详情信息", Icon = "info", Opened = true })
    infoSection:Divider()
    infoSection:Paragraph({
        Title = "关于",
        Desc = "目前修复了\n使用手机的用户开启飞天卡顿的问题\n目前不知道更新什么功能了\n也没有什么bug了\n有什么功能可以向我提出我会更新\n凌晨我将更新自动躲警察",
        ThumbnailSize = 190,
    })
    local infoSection2 = infoTab:Section({ Title = "更新公告", Icon = "bell", Opened = true })
    infoSection2:Divider()
    infoSection2:Paragraph({
        Title = "v2.0提示",
        Desc = "修复所有已知问题\n更换了悬浮窗",
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

    -- ============================================================
    -- 自动躲警察 Tab
    -- ============================================================
    local PoliceEvadeTab = Window:Tab({ Title = "自动躲警察", Icon = "shield" })
    local PoliceEvadeGroup = PoliceEvadeTab:Section({ Title = "自动躲警察", Opened = true })

    local AutoEvadePolice = false
    local EvadeDistance = 50
    local EvadeStrength = 50
    local EvadeConnection = nil

    local function IsPolicePlayer(p)
        if p == player then return false end
        if p.Team then
            local teamName = p.Team.Name or ""
            if teamName:find("警察") or teamName:find("Police") or teamName:find("Cop") then
                return true
            end
        end
        if p.Character then
            for _, child in ipairs(p.Character:GetDescendants()) do
                if child:IsA("StringValue") or child:IsA("BoolValue") then
                    local name = child.Name:lower()
                    if name:find("police") or name:find("cop") or name:find("警察") then
                        return true
                    end
                end
            end
        end
        for _, child in ipairs(p:GetChildren()) do
            if child:IsA("StringValue") or child:IsA("BoolValue") then
                local name = child.Name:lower()
                if name:find("police") or name:find("cop") or name:find("警察") then
                    return true
                end
            end
        end
        return false
    end

    local function GetClosestPolice()
        local char = player.Character
        if not char then return nil, math.huge end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return nil, math.huge end
        
        local closest = nil
        local closestDist = math.huge
        
        for _, p in ipairs(Players:GetPlayers()) do
            if not IsPolicePlayer(p) then continue end
            if not p.Character then continue end
            local pRoot = p.Character:FindFirstChild("HumanoidRootPart")
            if not pRoot then continue end
            local dist = (root.Position - pRoot.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = p
            end
        end
        return closest, closestDist
    end

    local function StartEvadePolice()
        if EvadeConnection then return end
        local frameSkip = 0
        EvadeConnection = RunService.Stepped:Connect(function()
            if not AutoEvadePolice then return end
            
            frameSkip = frameSkip + 1
            if frameSkip % 3 ~= 0 then return end
            
            local char = player.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            
            local police, dist = GetClosestPolice()
            if not police then return end
            if dist > EvadeDistance then return end
            
            local policeRoot = police.Character:FindFirstChild("HumanoidRootPart")
            if not policeRoot then return end
            
            local awayDir = (root.Position - policeRoot.Position).Unit
            local forceStrength = EvadeStrength * (1 - (dist / EvadeDistance))
            forceStrength = math.max(forceStrength, 5)
            
            local velocity = awayDir * forceStrength * 10
            root.Velocity = velocity
            root.AssemblyLinearVelocity = velocity
            
            for _, obj in ipairs(root:GetChildren()) do
                if obj:IsA("BodyVelocity") and obj.Name ~= "EvadePolice" then
                    obj:Destroy()
                end
            end
        end)
    end

    local function StopEvadePolice()
        if EvadeConnection then
            EvadeConnection:Disconnect()
            EvadeConnection = nil
        end
        local char = player.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                root.Velocity = Vector3.new(0, 0, 0)
                root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        end
    end

    PoliceEvadeGroup:Divider()
    PoliceEvadeGroup:Toggle({
        Title = "启用自动躲警察",
        Desc = "警察靠近时自动弹开远离",
        Value = false,
        Callback = function(value)
            AutoEvadePolice = value
            if value then
                StartEvadePolice()
                WindUI:Notify({ Title = "自动躲警察", Content = "已开启，警察靠近将自动弹开", Duration = 2 })
            else
                StopEvadePolice()
                WindUI:Notify({ Title = "自动躲警察", Content = "已关闭", Duration = 2 })
            end
        end
    })
    PoliceEvadeGroup:Slider({
        Title = "触发距离",
        Desc = "警察进入该距离时触发弹开（米）",
        Step = 1,
        Value = { Min = 10, Max = 100, Default = 50 },
        Callback = function(value)
            EvadeDistance = value
        end
    })
    PoliceEvadeGroup:Slider({
        Title = "弹开力度",
        Desc = "数值越大弹开越远",
        Step = 1,
        Value = { Min = 10, Max = 200, Default = 50 },
        Callback = function(value)
            EvadeStrength = value
        end
    })

    -- ============================================================
    -- 玩家修改 Tab (A) - 修复版（含防摔）
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

    A:Divider({ Text = "飞行" })
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

    -- 飞天快捷开关（移到飞行速度下面）
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

    A:Divider({ Text = "防摔" })
    local antiFallEnabled = false
    local antiFallConnection = nil

    A:Toggle({
        Title = "防摔",
        Desc = "从高处落地时速度平稳",
        Value = false,
        Callback = function(value)
            antiFallEnabled = value
            if value then
                if antiFallConnection then antiFallConnection:Disconnect() end
                antiFallConnection = RunService.Heartbeat:Connect(function()
                    if not antiFallEnabled then return end
                    local char = player.Character
                    if not char then return end
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if not root then return end
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if not hum then return end
                    
                    local vel = root.Velocity
                    if vel.Y < -20 and hum.PlatformStand == false then
                        local newY = math.clamp(vel.Y, -40, -10)
                        root.Velocity = Vector3.new(vel.X, newY, vel.Z)
                    end
                end)
            else
                if antiFallConnection then
                    antiFallConnection:Disconnect()
                    antiFallConnection = nil
                end
            end
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
        if p.Team then
            local teamName = p.Team.Name
            local teamMap = {
                ["Police"] = "警察",
                ["Fire"] = "火焰",
                ["Medical"] = "医疗",
                ["Road"] = "道路",
                ["Civilian"] = "平民",
                ["Citizen"] = "平民",
                ["Criminal"] = "匪徒",
                ["Gang"] = "黑帮",
                ["Military"] = "军人",
                ["Delivery"] = "送货",
                ["Farmer"] = "农民",
                ["Banker"] = "银行家",
                ["Mayor"] = "市长",
                ["Journalist"] = "记者",
                ["Lawyer"] = "律师",
                ["Prisoner"] = "囚犯",
                ["Guard"] = "狱警",
                ["Driver"] = "司机",
                ["Chef"] = "厨师",
                ["Builder"] = "建筑工",
                ["Miner"] = "矿工",
                ["Fisherman"] = "渔夫",
                ["Merchant"] = "商人",
                ["Student"] = "学生",
                ["Teacher"] = "老师",
                ["Engineer"] = "工程师",
                ["Scientist"] = "科学家",
                ["Pilot"] = "飞行员",
                ["Courier"] = "快递员",
                ["BusDriver"] = "公交车司机",
            }
            return teamMap[teamName] or teamName
        end
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
    -- 音乐 Tab（含播放模式）
    -- ============================================================
    local MusicTab = Window:Tab({ Title = "音乐", Icon = "music" })
    local MusicGroup = MusicTab:Section({ Title = "音乐播放器", Opened = true })

    local SONG_LIST = {
        { name = "半壶纱", id = "140168001118478" },
        { name = "对你有感觉", id = "113476583412576" },
        { name = "失眠", id = "124928120639248" },
        { name = "中国人能飞", id = "79254667830418" },
        { name = "忘情牛肉面", id = "72954292508946" },
        { name = "无需多言", id = "114940361500053" },
        { name = "出山", id = "108542841138539" },
        { name = "来个好梗绷一绷", id = "120070812635771" },
        { name = "孤独患者", id = "88257174439605" },
        { name = "幻昼", id = "103093530102792" },
        { name = "海屿你", id = "76421239273915" },
        { name = "于是", id = "132959953803661" },
        { name = "罗生门", id = "79952466129206" },
        { name = "茫", id = "72194943092340" },
        { name = "忘不掉的你", id = "91111816286323" },
        { name = "DearD", id = "139047831212058" },
        { name = "戒烟", id = "137671588958836" },
        { name = "IQOO进行曲", id = "109693244185458" },
        { name = "祖国人进行曲", id = "86555185586884" },
        { name = "十年咕嘎无人知", id = "78729794283728" },
        { name = "unhappy", id = "88523902860927" },
    }

    local selectedSong = SONG_LIST[1]
    local musicSound = nil
    local isMusicPlaying = false
    local currentPlayIndex = 1
    local playMode = "顺序播放"
    local endedConnection = nil

    local songNames = {}
    for _, song in ipairs(SONG_LIST) do
        table.insert(songNames, song.name)
    end

    local function PlaySongByIndex(index)
        if index < 1 or index > #SONG_LIST then
            if playMode == "顺序播放" then
                index = 1
            elseif playMode == "循环播放" then
                index = 1
            elseif playMode == "随机播放" then
                index = math.random(1, #SONG_LIST)
            end
        end
        
        if index < 1 or index > #SONG_LIST then return end
        
        local song = SONG_LIST[index]
        selectedSong = song
        currentPlayIndex = index
        
        if musicSound then
            musicSound:Stop()
            musicSound:Destroy()
            musicSound = nil
        end
        if endedConnection then
            endedConnection:Disconnect()
            endedConnection = nil
        end
        
        pcall(function()
            musicSound = Instance.new("Sound")
            musicSound.SoundId = "rbxassetid://" .. song.id
            musicSound.Volume = 1
            musicSound.Looped = false
            musicSound.Parent = player:WaitForChild("PlayerGui")
            musicSound:Play()
            WindUI:Notify({ Title = "音乐", Content = "正在播放: " .. song.name, Duration = 2 })
            
            endedConnection = musicSound.Ended:Connect(function()
                if not isMusicPlaying then return end
                if playMode == "循环播放" then
                    PlaySongByIndex(currentPlayIndex)
                elseif playMode == "顺序播放" then
                    local nextIndex = currentPlayIndex + 1
                    if nextIndex > #SONG_LIST then
                        nextIndex = 7
                    end
                    PlaySongByIndex(nextIndex)
                elseif playMode == "随机播放" then
                    local randomIndex = math.random(1, #SONG_LIST)
                    while randomIndex == currentPlayIndex and #SONG_LIST > 1 do
                        randomIndex = math.random(1, #SONG_LIST)
                    end
                    PlaySongByIndex(randomIndex)
                end
            end)
        end)
    end

    MusicGroup:Dropdown({
        Title = "选择歌曲",
        Values = songNames,
        Value = songNames[1],
        Callback = function(value)
            for i, song in ipairs(SONG_LIST) do
                if song.name == value then
                    selectedSong = song
                    currentPlayIndex = i
                    break
                end
            end
            if isMusicPlaying then
                PlaySongByIndex(currentPlayIndex)
            end
        end
    })

    MusicGroup:Divider()

    MusicGroup:Toggle({
        Title = "播放音乐",
        Desc = "开启播放当前选中的歌曲，关闭停止播放",
        Value = false,
        Callback = function(value)
            isMusicPlaying = value
            if value then
                PlaySongByIndex(currentPlayIndex)
            else
                if musicSound then
                    musicSound:Stop()
                    musicSound:Destroy()
                    musicSound = nil
                end
                if endedConnection then
                    endedConnection:Disconnect()
                    endedConnection = nil
                end
                WindUI:Notify({ Title = "音乐", Content = "已停止播放", Duration = 2 })
            end
        end
    })

    MusicGroup:Slider({
        Title = "音量",
        Step = 0.1,
        Value = { Min = 0, Max = 1, Default = 0.5 },
        Callback = function(value)
            if musicSound then
                musicSound.Volume = value
            end
        end
    })

    MusicGroup:Divider()
    MusicGroup:Paragraph({
        Title = "播放模式",
        Desc = "选择音乐的播放方式"
    })

    MusicGroup:Dropdown({
        Title = "播放模式",
        Values = { "顺序播放", "循环播放", "随机播放" },
        Value = "顺序播放",
        Callback = function(value)
            playMode = value
            WindUI:Notify({ Title = "播放模式", Content = "已切换至: " .. value, Duration = 2 })
            if isMusicPlaying then
                PlaySongByIndex(currentPlayIndex)
            end
        end
    })

    -- ============================================================
    -- 设置 Tab (G) - 仅作者可见
    -- ============================================================
    local SettingsTab = Window:Tab({ Title = "设置", Icon = "settings" })

    if DEVICE_UID == AUTHOR_UID then
        local AdminGroup = SettingsTab:Section({ Title = "开发者后台", Opened = true })
        AdminGroup:Paragraph({
            Title = "已授权",
            Desc = "当前身份: 作者"
        })
        AdminGroup:Divider()

        AdminGroup:Paragraph({
            Title = "黑名单管理",
            Desc = "输入要拉黑的设备UID，点击拉黑即可"
        })

        local blacklistInput = nil
        AdminGroup:Input({
            Title = "输入UID",
            Placeholder = "请输入要拉黑的设备UID...",
            Callback = function(value)
                blacklistInput = value
            end
        })

        AdminGroup:Button({
            Title = "拉黑设备",
            Callback = function()
                if blacklistInput and blacklistInput ~= "" then
                    if blacklistInput == DEVICE_UID then
                        WindUI:Notify({ Title = "错误", Content = "不能拉黑自己的设备", Duration = 3 })
                        return
                    end
                    BLACKLIST[blacklistInput] = true
                    WindUI:Notify({ Title = "成功", Content = "已拉黑设备: " .. blacklistInput, Duration = 3 })
                else
                    WindUI:Notify({ Title = "错误", Content = "请输入设备UID", Duration = 2 })
                end
            end
        })

        AdminGroup:Button({
            Title = "从黑名单移除",
            Callback = function()
                if blacklistInput and blacklistInput ~= "" then
                    BLACKLIST[blacklistInput] = nil
                    WindUI:Notify({ Title = "成功", Content = "已移除黑名单: " .. blacklistInput, Duration = 3 })
                else
                    WindUI:Notify({ Title = "错误", Content = "请输入设备UID", Duration = 2 })
                end
            end
        })

        AdminGroup:Divider({ Text = "授权管理" })
        AdminGroup:Paragraph({
            Title = "说明",
            Desc = "输入要授权的设备UID，点击授权即可"
        })

        local whitelistInput = nil
        AdminGroup:Input({
            Title = "输入UID",
            Placeholder = "请输入要授权的设备UID...",
            Callback = function(value)
                whitelistInput = value
            end
        })

        AdminGroup:Button({
            Title = "授权设备",
            Callback = function()
                if whitelistInput and whitelistInput ~= "" then
                    if whitelistInput == DEVICE_UID then
                        WindUI:Notify({ Title = "提示", Content = "你已拥有最高权限", Duration = 3 })
                        return
                    end
                    WHITELIST[whitelistInput] = true
                    WindUI:Notify({ Title = "成功", Content = "已授权设备: " .. whitelistInput, Duration = 3 })
                else
                    WindUI:Notify({ Title = "错误", Content = "请输入设备UID", Duration = 2 })
                end
            end
        })

        AdminGroup:Button({
            Title = "移除授权",
            Callback = function()
                if whitelistInput and whitelistInput ~= "" then
                    WHITELIST[whitelistInput] = nil
                    WindUI:Notify({ Title = "成功", Content = "已移除授权: " .. whitelistInput, Duration = 3 })
                else
                    WindUI:Notify({ Title = "错误", Content = "请输入设备UID", Duration = 2 })
                end
            end
        })

        AdminGroup:Divider()
        AdminGroup:Button({
            Title = "查看当前黑名单",
            Callback = function()
                local list = {}
                for uid, _ in pairs(BLACKLIST) do
                    table.insert(list, uid)
                end
                if #list == 0 then
                    WindUI:Notify({ Title = "黑名单", Content = "当前黑名单为空", Duration = 3 })
                else
                    WindUI:Notify({ Title = "黑名单列表", Content = table.concat(list, "\n"), Duration = 5 })
                end
            end
        })

        AdminGroup:Button({
            Title = "查看当前授权列表",
            Callback = function()
                local list = {}
                for uid, _ in pairs(WHITELIST) do
                    table.insert(list, uid)
                end
                if #list == 0 then
                    WindUI:Notify({ Title = "授权列表", Content = "当前授权列表为空", Duration = 3 })
                else
                    WindUI:Notify({ Title = "授权列表", Content = table.concat(list, "\n"), Duration = 5 })
                end
            end
        })
    else
        local BlockGroup = SettingsTab:Section({ Title = "开发者后台", Opened = true })
        BlockGroup:Paragraph({
            Title = "禁止访问",
            Desc = "你无法进入开发者后台"
        })
    end

    WindUI:Notify({
        Title = "wdfex-Hub",
        Content = "脚本已加载成功，欢迎使用！",
        Duration = 3,
    })
end