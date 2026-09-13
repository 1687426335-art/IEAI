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

local version = "v3.7"
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
    local TweenService = game:GetService("TweenService")
    local player = Players.LocalPlayer
    local isDestroyed = false
    local connections = {}

    -- 购买成功提示（右下角）
    local function showBuySuccess(itemName)
        local sg = Instance.new("ScreenGui")
        sg.Name = "BuySuccessGui"
        sg.ResetOnSpawn = false
        sg.DisplayOrder = 999
        sg.Parent = player:WaitForChild("PlayerGui")

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 220, 0, 50)
        frame.Position = UDim2.new(1, 0, 1, -80)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        frame.BorderSizePixel = 0
        frame.Parent = sg

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = frame

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(0, 255, 100)
        stroke.Thickness = 2
        stroke.Parent = frame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -20, 1, -10)
        label.Position = UDim2.new(0, 10, 0, 5)
        label.BackgroundTransparency = 1
        label.Text = "购买成功: " .. itemName
        label.TextColor3 = Color3.fromRGB(0, 255, 100)
        label.TextSize = 16
        label.Font = Enum.Font.GothamBold
        label.Parent = frame

        local tweenIn = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -230, 1, -80)
        })
        tweenIn:Play()

        task.wait(2)

        local tweenOut = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 0, 1, -80)
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            sg:Destroy()
        end)
    end

    -- ==================== 自定义顶部标签 (wdfex脚本NB + 北京时间) ====================
    local tagGui = Instance.new("ScreenGui")
    tagGui.Name = "WdfexTopTags"
    tagGui.ResetOnSpawn = false
    tagGui.DisplayOrder = 999
    tagGui.Parent = player:WaitForChild("PlayerGui")

    -- 标签1：wdfex脚本NB
    local tag1Frame = Instance.new("Frame")
    tag1Frame.Size = UDim2.new(0, 130, 0, 28)
    tag1Frame.Position = UDim2.new(0, 110, 0, 5) -- 放在大概你圈的位置
    tag1Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    tag1Frame.BackgroundTransparency = 0.4
    tag1Frame.BorderSizePixel = 0
    tag1Frame.Parent = tagGui

    local corner1 = Instance.new("UICorner")
    corner1.CornerRadius = UDim.new(0, 6)
    corner1.Parent = tag1Frame

    local tag1Label = Instance.new("TextLabel")
    tag1Label.Size = UDim2.new(1, 0, 1, 0)
    tag1Label.BackgroundTransparency = 1
    tag1Label.Text = "wdfex脚本NB"
    tag1Label.TextColor3 = Color3.fromRGB(0, 255, 255)
    tag1Label.TextSize = 14
    tag1Label.Font = Enum.Font.GothamBold
    tag1Label.Parent = tag1Frame

    -- 标签1 彩虹描边
    local stroke1 = Instance.new("UIStroke")
    stroke1.Thickness = 1.5
    stroke1.Parent = tag1Label
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 255))
    })
    gradient.Parent = stroke1

    -- 标签1 描边旋转动画
    task.spawn(function()
        while tagGui.Parent and not isDestroyed do
            gradient.Rotation = (gradient.Rotation + 2) % 360
            task.wait(0.03)
        end
    end)

    -- 标签2：北京时间
    local tag2Frame = Instance.new("Frame")
    tag2Frame.Size = UDim2.new(0, 130, 0, 28)
    tag2Frame.Position = UDim2.new(0, 250, 0, 5) -- 放在标签1右边
    tag2Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    tag2Frame.BackgroundTransparency = 0.4
    tag2Frame.BorderSizePixel = 0
    tag2Frame.Parent = tagGui

    local corner2 = Instance.new("UICorner")
    corner2.CornerRadius = UDim.new(0, 6)
    corner2.Parent = tag2Frame

    local tag2Label = Instance.new("TextLabel")
    tag2Label.Size = UDim2.new(1, 0, 1, 0)
    tag2Label.BackgroundTransparency = 1
    tag2Label.Text = "北京时间: 00:00:00"
    tag2Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    tag2Label.TextSize = 14
    tag2Label.Font = Enum.Font.GothamBold
    tag2Label.Parent = tag2Frame

    -- 标签2 动态更新时间
    task.spawn(function()
        while tagGui.Parent and not isDestroyed do
            local now = os.date("!*t")
            now.hour = now.hour + 8
            if now.hour >= 24 then
                now.hour = now.hour - 24
            end
            local timeStr = string.format("%02d:%02d:%02d", now.hour, now.min, now.sec)
            tag2Label.Text = "北京时间: " .. timeStr
            task.wait(1)
        end
    end)

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
        User = { Enabled = false },
        SideBarWidth = 250,
        Search = {
            Enabled = true,
            Placeholder = "搜索...",
            Callback = function(searchText) end
        },
        SidePanel = {
            Enabled = true,
            Content = {
                {
                    Type = "Button", 
                    Text = "wdfex-Hub",
                    Style = "Subtle", 
                    Size = UDim2.new(1, -20, 0, 30),
                    Callback = function() end
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

    Window:EditOpenButton({
        Title = "wdfex-Hub",
        Icon = "heart",
        CornerRadius = UDim.new(0,16),
        StrokeThickness = 4,
        Color = ColorSequence.new(Color3.fromHex("FF6B6B")),
        Draggable = true,
    })

    task.wait(0.1)
    local mainGui = player.PlayerGui:FindFirstChild("CloudHub")
    if mainGui then
        local mainFrame = mainGui:FindFirstChildOfClass("Frame")
        if mainFrame then
            local stroke1 = Instance.new("UIStroke")
            stroke1.Thickness = 3
            stroke1.Color = Color3.fromHSV(0, 1, 1)
            stroke1.Transparency = 0.5
            stroke1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke1.Parent = mainFrame

            local stroke2 = Instance.new("UIStroke")
            stroke2.Thickness = 5
            stroke2.Color = Color3.fromHSV(0.5, 1, 1)
            stroke2.Transparency = 0.3
            stroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke2.Parent = mainFrame

            local hue1 = 0
            local hue2 = 0.5
            local colorConn = RunService.Heartbeat:Connect(function()
                hue1 = (hue1 + 0.01) % 1
                hue2 = (hue2 - 0.01) % 1
                stroke1.Color = Color3.fromHSV(hue1, 1, 1)
                stroke2.Color = Color3.fromHSV(hue2, 1, 1)
            end)
            table.insert(connections, colorConn)
        end
    end

    spawn(function()
        while true do
            for hue = 0, 1, 0.01 do  
                local color = Color3.fromHSV(hue, 0.8, 1)  
                Window:EditOpenButton({ Color = ColorSequence.new(color) })
                wait(0.04)  
            end
        end
    end)

    task.spawn(function()
        pcall(function()
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://80701295792893"
            sound.Volume = 0.5
            sound.Parent = player:WaitForChild("PlayerGui")
            sound:Play()
            task.wait(7)
            sound:Stop()
            sound:Destroy()
        end)
    end)

    task.spawn(function()
        pcall(function()
            local bannerGui = Instance.new("ScreenGui")
            bannerGui.Name = "BannerGui"
            bannerGui.ResetOnSpawn = false
            bannerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            bannerGui.Parent = player:WaitForChild("PlayerGui")
            
            local banner = Instance.new("TextLabel")
            banner.Size = UDim2.new(0, 160, 0, 28)
            banner.Position = UDim2.new(0, -160, 0, 2)
            banner.BackgroundTransparency = 1
            banner.Text = "已更新最新的绕过反作弊"
            banner.TextSize = 18
            banner.Font = Enum.Font.GothamBold
            banner.TextScaled = false
            banner.TextStrokeTransparency = 0.3
            banner.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            banner.Parent = bannerGui
            
            local textWidth = 160
            
            local hue = 0
            local colorConn = RunService.Heartbeat:Connect(function()
                hue = (hue + 0.005) % 1
                banner.TextColor3 = Color3.fromHSV(hue, 0.9, 1)
            end)
            table.insert(connections, colorConn)
            
            local function startAnimation()
                local tween1 = TweenService:Create(banner, TweenInfo.new(16, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                    Position = UDim2.new(1, 10, 0, 2)
                })
                tween1:Play()
                tween1.Completed:Connect(function()
                    banner.Position = UDim2.new(0, -textWidth, 0, 2)
                    startAnimation()
                end)
            end
            
            task.wait(0.5)
            startAnimation()
        end)
    end)

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

    local AuthorTab = Window:Tab({ Title = "作者信息", Icon = "user" })
    local AuthorSection = AuthorTab:Section({ Title = "", Opened = true })
    AuthorSection:Paragraph({
        Title = "",
        Desc = "",
        Thumbnail = "rbxassetid://74369447499630",
        ThumbnailSize = 150,
        ThumbnailShape = "Square",
    })
    AuthorSection:Paragraph({
        Title = "作者QQ：1687426335",
        Desc = "",
    })

    local NoticeTab = Window:Tab({ Title = "公告", Icon = "info" })
    local NoticeSection = NoticeTab:Section({ Title = "作者消息", Opened = true })
    NoticeSection:Divider()
    NoticeSection:Paragraph({
        Title = "注意事项",
        Desc = "已更换悬浮窗添加了一些功能\n杀戮光环的优先攻击最近目标如果选择距离内没有人\n那这个选项就不会生效杀戮光环正常生效\n修复了透视卡顿的问题\n修复了杀戮光环攻击有延迟的问题\n如果你使用的过程中出现一些bug请联系作者修复\n被封永久了就是被挂DC了如果你要是执行其他脚本之后被封的那你也活该"
    })

    local infoTab = Window:Tab({ Title = "通知", Icon = "layout-grid", Locked = false })
    local infoSection = infoTab:Section({ Title = "详情信息", Icon = "info", Opened = true })
    infoSection:Divider()
    infoSection:Paragraph({
        Title = "关于",
        Desc = "目前修复了\n使用手机的用户开启飞天卡顿的问题\n目前不知道更新什么功能了\n也没有什么bug了\n有什么功能可以向我提出我会更新",
        ThumbnailSize = 190,
    })
    local infoSection2 = infoTab:Section({ Title = "更新公告", Icon = "bell", Opened = true })
    infoSection2:Divider()
    infoSection2:Paragraph({
        Title = "v3.7提示",
        Desc = "黑市远程购买已更新，支持工具和武器分类，新增洛克17、战斧、球棒、大砍刀，新增顶部标签和北京时间",
        ThumbnailSize = 190,
    })
    infoTab:Select()

    AuthorTab:Select()

    local MainSection = Window:Section({
        Title = "主功能",
        Opened = true,
    })

    local function AddTab(section, title, icon)
        return section:Tab({ Title = title, Icon = icon })
    end

    -- ==================== Tab 顺序 ====================
    local A = AddTab(MainSection, "玩家修改", "user")
    local FlyTab = AddTab(MainSection, "飞天与加速", "plane")
    local RemoteBuyTab = AddTab(MainSection, "远程购买", "shopping-cart")
    local InteractTab = AddTab(MainSection, "互动", "hand")
    local B = AddTab(MainSection, "枪械功能", "target")
    local C = AddTab(MainSection, "杀戮光环", "skull")
    local D = AddTab(MainSection, "传送点", "map-pin")
    local E = AddTab(MainSection, "透视", "eye")
    local PoliceDodgeTab = AddTab(MainSection, "自动躲警察", "shield")

    -- ==================== 远程购买（工具和武器） ====================
    RemoteBuyTab:Divider({ Text = "黑市购买" })

    local toolItems = {
        { name = "解密电路", id = "1", itemName = "Decryption Circuit" },
        { name = "撬锁装置", id = "2", itemName = "Lockpick Device" },
        { name = "入侵工具", id = "3", itemName = "Hacking Tool" },
        { name = "C4", id = "4", itemName = "C4" },
        { name = "绿色USB", id = "5", itemName = "Green USB" },
        { name = "工作人员涂鸦", id = "8", itemName = "Crew Graffiti" }
    }

    local weaponItems = {
        { name = "洛克17", id = "5", itemName = "Glock 17" },
        { name = "战斧", id = "2", itemName = "Battle Axe" },
        { name = "球棒", id = "3", itemName = "Bat" },
        { name = "大砍刀", id = "4", itemName = "Machete" },
        { name = "小刀", id = "1", itemName = "Knife" }
    }

    local toolNameOptions = {}
    for _, v in ipairs(toolItems) do table.insert(toolNameOptions, v.name) end
    local selectedToolItem = toolNameOptions[1]

    RemoteBuyTab:Dropdown({
        Title = "工具",
        Values = toolNameOptions,
        Value = toolNameOptions[1],
        Callback = function(value)
            selectedToolItem = value
        end
    })

    RemoteBuyTab:Button({
        Title = "购买",
        Callback = function()
            local event = ReplicatedStorage:FindFirstChild("Remote") and ReplicatedStorage.Remote:FindFirstChild("PlayerFunc")
            local stuff = ReplicatedStorage:FindFirstChild("Stuff")
            
            if event and stuff then
                local blackMarket = stuff:FindFirstChild("Black Market")
                local targetItem = nil
                local displayName = ""
                
                if blackMarket then
                    for _, itemInfo in ipairs(toolItems) do
                        if itemInfo.name == selectedToolItem then
                            local slot = blackMarket:FindFirstChild(itemInfo.id)
                            if slot then
                                targetItem = slot:FindFirstChild(itemInfo.itemName)
                                displayName = itemInfo.name
                            end
                            break
                        end
                    end
                end
                
                if targetItem then
                    local success = pcall(function()
                        event:InvokeServer("purchase", {
                            isRestaurant = false,
                            item = targetItem
                        })
                    end)
                    if success then
                        showBuySuccess(displayName)
                    end
                else
                    WindUI:Notify({ Title = "购买失败", Content = "没找到" .. selectedToolItem .. "，可能商店刷新了", Duration = 3 })
                end
            else
                WindUI:Notify({ Title = "购买失败", Content = "没找到购买事件或物品路径", Duration = 3 })
            end
        end
    })

    RemoteBuyTab:Divider({ Text = "武器" })

    local weaponNameOptions = {}
    for _, v in ipairs(weaponItems) do table.insert(weaponNameOptions, v.name) end
    local selectedWeaponItem = weaponNameOptions[1]

    RemoteBuyTab:Dropdown({
        Title = "武器",
        Values = weaponNameOptions,
        Value = weaponNameOptions[1],
        Callback = function(value)
            selectedWeaponItem = value
        end
    })

    RemoteBuyTab:Button({
        Title = "购买",
        Callback = function()
            local event = ReplicatedStorage:FindFirstChild("Remote") and ReplicatedStorage.Remote:FindFirstChild("PlayerFunc")
            local stuff = ReplicatedStorage:FindFirstChild("Stuff")
            
            if event and stuff then
                local weaponsFolder = stuff:FindFirstChild("Weapons")
                local targetItem = nil
                local displayName = ""
                
                if weaponsFolder then
                    for _, itemInfo in ipairs(weaponItems) do
                        if itemInfo.name == selectedWeaponItem then
                            local slot = weaponsFolder:FindFirstChild(itemInfo.id)
                            if slot then
                                targetItem = slot:FindFirstChild(itemInfo.itemName)
                                displayName = itemInfo.name
                            end
                            break
                        end
                    end
                end
                
                if targetItem then
                    local success = pcall(function()
                        event:InvokeServer("purchase", {
                            isRestaurant = false,
                            item = targetItem
                        })
                    end)
                    if success then
                        showBuySuccess(displayName)
                    end
                else
                    WindUI:Notify({ Title = "购买失败", Content = "没找到" .. selectedWeaponItem .. "，可能商店刷新了", Duration = 3 })
                end
            else
                WindUI:Notify({ Title = "购买失败", Content = "没找到购买事件或物品路径", Duration = 3 })
            end
        end
    })

    -- ==================== 自动躲警察 ====================
    local policeDodgeEnabled = false
    local policeDodgeDistance = 30
    local policeDodgeForce = 50
    local policeDodgeWallCheck = true
    local policeDodgeConn = nil

    local function isVisible(fromPos, toPos, ignoreInstances)
        local direction = (toPos - fromPos).Unit
        local distance = (toPos - fromPos).Magnitude
        if distance < 0.1 then return true end
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = ignoreInstances or {}
        local result = workspace:Raycast(fromPos, direction * distance, params)
        return result == nil
    end

    local function startPoliceDodge()
        if policeDodgeConn then return end
        policeDodgeConn = RunService.Heartbeat:Connect(function()
            if not policeDodgeEnabled then return end
            local char = player.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local myHead = char:FindFirstChild("Head")
            if not myHead then myHead = root end

            local myPos = myHead.Position
            local forceVec = Vector3.zero
            local foundAny = false

            for _, p in ipairs(Players:GetPlayers()) do
                if p == player then continue end
                local team = p.Team
                if team then
                    local teamName = team.Name
                    if teamName:find("Police") or teamName:find("警察") or teamName:find("Cop") then
                        local pChar = p.Character
                        if pChar then
                            local pRoot = pChar:FindFirstChild("HumanoidRootPart")
                            local pHead = pChar:FindFirstChild("Head")
                            local targetPart = pHead or pRoot
                            if targetPart then
                                local dist = (targetPart.Position - myPos).Magnitude
                                if dist < policeDodgeDistance then
                                    if policeDodgeWallCheck then
                                        local ignoreList = {char, pChar}
                                        local visible = isVisible(myPos, targetPart.Position, ignoreList)
                                        if not visible then
                                            continue
                                        end
                                    end
                                    foundAny = true
                                    local dir = (myPos - targetPart.Position).Unit
                                    forceVec = forceVec + dir * (1 / (dist + 0.1))
                                end
                            end
                        end
                    end
                end
            end

            if foundAny and forceVec.Magnitude > 0 then
                local finalDir = forceVec.Unit
                local speed = policeDodgeForce * 5
                root.Velocity = finalDir * speed
            end
        end)
    end

    local function stopPoliceDodge()
        if policeDodgeConn then
            policeDodgeConn:Disconnect()
            policeDodgeConn = nil
        end
    end

    PoliceDodgeTab:Divider({ Text = "警察躲避设置" })
    PoliceDodgeTab:Toggle({
        Title = "启用自动躲警察",
        Value = false,
        Callback = function(value)
            policeDodgeEnabled = value
            if value then
                startPoliceDodge()
            else
                stopPoliceDodge()
            end
        end
    })

    PoliceDodgeTab:Slider({
        Title = "触发距离",
        Step = 1,
        Value = { Min = 1, Max = 100, Default = 30 },
        Callback = function(value)
            policeDodgeDistance = value
        end
    })

    PoliceDodgeTab:Slider({
        Title = "弹开力度",
        Step = 1,
        Value = { Min = 1, Max = 100, Default = 50 },
        Callback = function(value)
            policeDodgeForce = value
        end
    })

    PoliceDodgeTab:Toggle({
        Title = "墙体检测",
        Value = true,
        Callback = function(value)
            policeDodgeWallCheck = value
        end
    })

    local interactEnabled = false

    local function ScanPrompts()
        if isDestroyed or not interactEnabled then return end
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = Settings.HoldTime
                obj.MaxActivationDistance = Settings.Distance
            end
        end
    end

    InteractTab:Divider({ Text = "快速互动" })
    InteractTab:Toggle({
        Title = "启用快速互动",
        Value = false,
        Callback = function(value)
            interactEnabled = value
            if value then
                ScanPrompts()
            end
        end
    })

    workspace.DescendantAdded:Connect(function(obj)
        task.wait(0.1)
        if obj:IsA("ProximityPrompt") and interactEnabled then
            obj.HoldDuration = Settings.HoldTime
            obj.MaxActivationDistance = Settings.Distance
        end
    end)

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

    FlyTab:Divider({ Text = "飞行" })
    FlyTab:Toggle({
        Title = "飞行（绕过）",
        Value = false,
        Callback = function(value)
            if value then startFly() else stopFly() end
        end
    })
    FlyTab:Slider({
        Title = "飞行速度",
        Step = 1,
        Value = { Min = 10, Max = 620, Default = 35 },
        Callback = function(value)
            FlySpeed = value
        end
    })

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
        button.Image = "rbxassetid://74369447499630"
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

    FlyTab:Toggle({
        Title = "飞天快捷开关",
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

    FlyTab:Divider({ Text = "移速" })
    local speedBypassOn = false
    local speedBypassValue = 20
    FlyTab:Toggle({
        Title = "修改移速（绕过）",
        Value = false,
        Callback = function(value)
            speedBypassOn = value
        end
    })
    FlyTab:Slider({
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

    A:Divider({ Text = "体力" })
    local staminaOn = false

    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if method == "FireServer" then
            if staminaOn then
                if args[1] == "setStaminaOrFood" and args[2] == "stamina" then
                    args[3] = 9999999
                    return oldNamecall(self, unpack(args))
                end
                if type(args[1]) == "string" and args[1]:lower():find("stamina") then
                    for i = 2, #args do
                        if type(args[i]) == "number" then
                            args[i] = 9999999
                        end
                    end
                    return oldNamecall(self, unpack(args))
                end
            end
            if godOn and type(args[1]) == "string" and args[1] == "takeDamage" then
                return
            end
        end
        return oldNamecall(self, ...)
    end)

    task.spawn(function()
        while not isDestroyed do
            if staminaOn then
                pcall(function()
                    for _, obj in ipairs(player:GetDescendants()) do
                        if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                            local n = obj.Name:lower()
                            if n:find("stamina") or n:find("energy") then
                                obj.Value = 9999999
                            end
                        end
                    end
                    local char = player.Character
                    if char then
                        for _, obj in ipairs(char:GetDescendants()) do
                            if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                                local n = obj.Name:lower()
                                if n:find("stamina") or n:find("energy") then
                                    obj.Value = 9999999
                                end
                            end
                        end
                    end
                    local remote = ReplicatedStorage:FindFirstChild("Remote")
                    if remote then
                        local pe = remote:FindFirstChild("PlayerEvent")
                        if pe then
                            pcall(function()
                                pe:FireServer("setStaminaOrFood", "stamina", 9999999)
                            end)
                        end
                    end
                end)
            end
            task.wait(0.15)
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
        Value = false,
        Callback = function(value)
            _G.CatAntiFling_Enabled = value
        end
    })

    A:Divider({ Text = "防摔" })
    local antiFallEnabled = false
    local antiFallConnection = nil

    A:Toggle({
        Title = "防摔",
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

    local KA_MAX_DISTANCE = 300
    local kaEnabled = false
    local KANearestOnly = false
    local KA_NEAREST_DISTANCE = 25
    local KATargetPoliceOnly = false
    local KATargetCivilianOnly = false
    local KAIgnoreDead = true
    local showTarget = true
    local currentTarget = nil
    local targetDisplayGui = nil
    local targetDisplayLabel = nil

    local function CreateTargetDisplay()
        if targetDisplayGui then return end
        targetDisplayGui = Instance.new("ScreenGui")
        targetDisplayGui.Name = "KillAuraTargetDisplay"
        targetDisplayGui.ResetOnSpawn = false
        targetDisplayGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        targetDisplayGui.Parent = player:WaitForChild("PlayerGui")

        targetDisplayLabel = Instance.new("TextLabel")
        targetDisplayLabel.Size = UDim2.new(0, 220, 0, 30)
        targetDisplayLabel.Position = UDim2.new(1, -230, 1, -50)
        targetDisplayLabel.BackgroundTransparency = 1
        targetDisplayLabel.Text = "未检测到目标"
        targetDisplayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        targetDisplayLabel.TextSize = 18
        targetDisplayLabel.Font = Enum.Font.GothamBold
        targetDisplayLabel.TextStrokeTransparency = 0.2
        targetDisplayLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        targetDisplayLabel.TextXAlignment = Enum.TextXAlignment.Right
        targetDisplayLabel.Parent = targetDisplayGui
    end

    local function DestroyTargetDisplay()
        if targetDisplayGui then
            targetDisplayGui:Destroy()
            targetDisplayGui = nil
            targetDisplayLabel = nil
        end
    end

    local function UpdateTargetDisplay()
        if not showTarget or not kaEnabled then
            if targetDisplayGui then targetDisplayGui.Enabled = false end
            return
        end
        if not targetDisplayGui then CreateTargetDisplay() end
        targetDisplayGui.Enabled = true
        if currentTarget then
            targetDisplayLabel.Text = currentTarget.Name
            targetDisplayLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        else
            targetDisplayLabel.Text = "未检测到目标"
            targetDisplayLabel.TextColor3 = Color3.fromRGB(255, 200, 200)
        end
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
            local isCivilian = false
            if p.Team then
                local tn = p.Team.Name
                isCivilian = tn:find("平民") or tn:find("Citizen") or tn:find("圣奥里公民")
            else
                isCivilian = true
            end
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
                            if dist < anyDist then
                                anyDist = dist
                                anyEnemy = p
                            end
                            if dist <= KA_NEAREST_DISTANCE and dist < nearestDistInRange then
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
                        if dist < bestDist then
                            bestDist = dist
                            bestPlayer = p
                        end
                    end
                end
            end
        end
        return bestPlayer
    end

    local function performAttack()
        if not kaEnabled then return end
        
        local target = kaGetNearestEnemy()
        currentTarget = target
        
        if target then
            local targetHead = target.Character and target.Character:FindFirstChild("Head")
            if targetHead then
                local myHead = player.Character and player.Character:FindFirstChild("Head")
                if myHead then
                    local origin = myHead.Position
                    local hitPos = targetHead.Position
                    local direction = (hitPos - origin).Unit
                    local damage = 999999999
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
        UpdateTargetDisplay()
    end

    task.spawn(function()
        while not isDestroyed do
            if kaEnabled then
                performAttack()
            end
            task.wait(0.05)
        end
    end)

    player.CharacterAdded:Connect(function()
        if kaEnabled then
            task.wait(0.05)
            performAttack()
        end
    end)

    local function onToolAdded(tool)
        if kaEnabled then
            performAttack()
        end
    end

    local function setupToolListener(char)
        if char then
            char.DescendantAdded:Connect(function(desc)
                if desc:IsA("Tool") then
                    onToolAdded(desc)
                end
            end)
        end
    end

    if player.Character then
        setupToolListener(player.Character)
    end

    player.CharacterAdded:Connect(function(char)
        setupToolListener(char)
    end)

    C:Divider({ Text = "杀戮光环" })
    C:Paragraph({ Title = "注意", Desc = "需装备枪械武器才有伤害" })
    C:Toggle({
        Title = "启用杀戮光环",
        Value = false,
        Callback = function(value)
            kaEnabled = value
            if value then
                if showTarget then CreateTargetDisplay() end
                task.wait(0.1)
                performAttack()
            else
                currentTarget = nil
                if showTarget then UpdateTargetDisplay() end
            end
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

    C:Divider({ Text = "显示设置" })
    C:Toggle({
        Title = "显示攻击目标",
        Value = true,
        Callback = function(value)
            showTarget = value
            if value then
                if kaEnabled then
                    CreateTargetDisplay()
                    UpdateTargetDisplay()
                end
            else
                DestroyTargetDisplay()
            end
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

    D:Toggle({
        Title = "启用传送",
        Value = false,
        Callback = function(value)
            Settings.TeleportEnabled = value
        end
    })

    local function doTeleport(pos, name)
        if not Settings.TeleportEnabled then
            WindUI:Notify({ Title = "传送", Content = "请先开启传送开关", Duration = 3 })
            return
        end
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(pos)
            WindUI:Notify({ Title = "传送", Content = "正在传送至: " .. name, Duration = 2 })
        end
    end

    local FIXED_TELEPORTS = {
        {n = "车辆经销商", p = Vector3.new(3719.9501953125, 3.018573522567749, -333.3118591308594)},
        {n = "圣奥里服装店", p = Vector3.new(3617.91259765625, 3.1072206497192383, -452.8206481933594)},
        {n = "圣奥里码头", p = Vector3.new(4527.65625, -23.968238830566406, -280.59356689453125)},
        {n = "圣奥里餐饮店", p = Vector3.new(3182.416748046875, 3.01859188079834, 426.5179138183594)},
        {n = "宠物店", p = Vector3.new(3678.237305, 3.017920, 693.114624)},
        {n = "圣奥里大码头", p = Vector3.new(2736.307617, 2.630299, -1120.333008)},
        {n = "圣奥里海滩桥下(消星点)", p = Vector3.new(3964.504395, -25.068211, -854.057251)},
        {n = "大景超市", p = Vector3.new(3936.582764, 3.038293, 1136.326416)},
        {n = "大景餐饮店", p = Vector3.new(4476.997559, 3.037825, 906.802979)},
        {n = "大景卖车店", p = Vector3.new(3434.377441, 42.931786, 2687.997070)},
        {n = "莱斯维尔餐饮店", p = Vector3.new(753.757812, 3.039824, 998.132996)},
        {n = "莱斯维尔服装店", p = Vector3.new(820.745117, 2.766988, 1047.445679)},
        {n = "莱斯维尔自由广场", p = Vector3.new(926.523376, 2.630995, 865.764771)},
        {n = "莱斯维尔码头(游艇)", p = Vector3.new(947.840210, -22.529087, 1216.085693)},
        {n = "米尔顿居民区", p = Vector3.new(-528.565552, 2.630996, 1331.981689)},
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
        {n = "游戏厅", p = Vector3.new(2934.893799, 2.956458, 1693.660034)},
        {n = "高尔夫", p = Vector3.new(2280.767090, 3.037836, 1982.357300)},
    }

    local teleNames = {}
    for _, data in ipairs(FIXED_TELEPORTS) do table.insert(teleNames, data.n) end
    local selectedTeleport = teleNames[1] or ""

    D:Divider({ Text = "常规传送" })
    D:Dropdown({
        Title = "常规传送",
        Values = teleNames,
        Value = teleNames[1],
        Callback = function(value)
            selectedTeleport = value
        end
    })
    D:Button({
        Title = "传送到选定地点",
        Callback = function()
            for _, data in ipairs(FIXED_TELEPORTS) do
                if data.n == selectedTeleport then
                    doTeleport(data.p, data.n)
                    return
                end
            end
            WindUI:Notify({ Title = "传送", Content = "未找到该地点", Duration = 2 })
        end
    })

    local VENDING_TELEPORTS = {
        {n = "游戏厅售货机", p = Vector3.new(2905.10, -337.11, 1733.39)},
        {n = "警察局售货机", p = Vector3.new(3372.79, -337.46, -476.88)},
        {n = "医院售货机", p = Vector3.new(3943.85, -337.12, -201.67)},
        {n = "当铺售货机", p = Vector3.new(-208.57, -337.05, -97.18)},
    }
    local vendingNames = {}
    for _, data in ipairs(VENDING_TELEPORTS) do table.insert(vendingNames, data.n) end
    local selectedVending = vendingNames[1] or ""

    D:Divider({ Text = "售货机传送" })
    D:Dropdown({
        Title = "售货机传送",
        Values = vendingNames,
        Value = vendingNames[1],
        Callback = function(value)
            selectedVending = value
        end
    })
    D:Button({
        Title = "传送到选定售货机",
        Callback = function()
            for _, data in ipairs(VENDING_TELEPORTS) do
                if data.n == selectedVending then
                    doTeleport(data.p, data.n)
                    return
                end
            end
            WindUI:Notify({ Title = "传送", Content = "未找到该地点", Duration = 2 })
        end
    })

    local BANK_TELEPORTS = {
        {n = "小银行", p = Vector3.new(-678.77, -337.12, -104.65)},
        {n = "大银行", p = Vector3.new(3134.90, -321.84, -270.04)},
    }
    local bankNames = {}
    for _, data in ipairs(BANK_TELEPORTS) do table.insert(bankNames, data.n) end
    local selectedBank = bankNames[1] or ""

    D:Divider({ Text = "银行传送" })
    D:Dropdown({
        Title = "银行传送",
        Values = bankNames,
        Value = bankNames[1],
        Callback = function(value)
            selectedBank = value
        end
    })
    D:Button({
        Title = "传送到选定银行",
        Callback = function()
            for _, data in ipairs(BANK_TELEPORTS) do
                if data.n == selectedBank then
                    doTeleport(data.p, data.n)
                    return
                end
            end
            WindUI:Notify({ Title = "传送", Content = "未找到该地点", Duration = 2 })
        end
    })

    local TEAM_TELEPORTS = {
        {n = "警察局", p = Vector3.new(3315.72, 3.02, -481.83)},
        {n = "医院", p = Vector3.new(3895.47, 3.02, -179.65)},
        {n = "火焰", p = Vector3.new(3579.31, 8.41, 579.73)},
        {n = "转运", p = Vector3.new(4150.27, 2.63, 942.63)},
        {n = "送货", p = Vector3.new(4401.01, 3.04, 1607.59)},
        {n = "道路服务", p = Vector3.new(4274.56, 2.63, 1200.60)},
        {n = "圣奥里平民重生点", p = Vector3.new(3744.05, 2.63, -403.97)},
        {n = "约克镇平民重生点", p = Vector3.new(-250.24, 2.63, -82.67)},
    }
    local teamNames = {}
    for _, data in ipairs(TEAM_TELEPORTS) do table.insert(teamNames, data.n) end
    local selectedTeam = teamNames[1] or ""

    D:Divider({ Text = "队伍传送" })
    D:Dropdown({
        Title = "队伍传送",
        Values = teamNames,
        Value = teamNames[1],
        Callback = function(value)
            selectedTeam = value
        end
    })
    D:Button({
        Title = "传送到选定队伍点",
        Callback = function()
            for _, data in ipairs(TEAM_TELEPORTS) do
                if data.n == selectedTeam then
                    doTeleport(data.p, data.n)
                    return
                end
            end
            WindUI:Notify({ Title = "传送", Content = "未找到该地点", Duration = 2 })
        end
    })

    local GAS_TELEPORTS = {
        {n = "加油站1", p = Vector3.new(4517.21, -24.83, 111.44)},
        {n = "加油站2", p = Vector3.new(-918.75, 2.63, 1110.16)},
        {n = "加油站3", p = Vector3.new(2252.20, 2.63, 92.21)},
        {n = "加油站4", p = Vector3.new(1150.41, 2.63, -841.89)},
        {n = "加油站5", p = Vector3.new(-1620.28, 2.63, 1795.99)},
    }
    local gasNames = {}
    for _, data in ipairs(GAS_TELEPORTS) do table.insert(gasNames, data.n) end
    local selectedGas = gasNames[1] or ""

    D:Divider({ Text = "加油站传送" })
    D:Dropdown({
        Title = "加油站传送",
        Values = gasNames,
        Value = gasNames[1],
        Callback = function(value)
            selectedGas = value
        end
    })
    D:Button({
        Title = "传送到选定加油站",
        Callback = function()
            for _, data in ipairs(GAS_TELEPORTS) do
                if data.n == selectedGas then
                    doTeleport(data.p, data.n)
                    return
                end
            end
            WindUI:Notify({ Title = "传送", Content = "未找到该地点", Duration = 2 })
        end
    })

    local REPAIR_TELEPORTS = {
        {n = "船艇维修店", p = Vector3.new(4091.92, -17.28, 2861.75)},
        {n = "圣奥里车辆维修", p = Vector3.new(2783.67, 2.63, -413.05)},
        {n = "约克镇车辆维修", p = Vector3.new(-399.23, 2.63, -8.15)},
    }
    local repairNames = {}
    for _, data in ipairs(REPAIR_TELEPORTS) do table.insert(repairNames, data.n) end
    local selectedRepair = repairNames[1] or ""

    D:Divider({ Text = "载具维修类传送" })
    D:Dropdown({
        Title = "载具维修类传送",
        Values = repairNames,
        Value = repairNames[1],
        Callback = function(value)
            selectedRepair = value
        end
    })
    D:Button({
        Title = "传送到选定维修点",
        Callback = function()
            for _, data in ipairs(REPAIR_TELEPORTS) do
                if data.n == selectedRepair then
                    doTeleport(data.p, data.n)
                    return
                end
            end
            WindUI:Notify({ Title = "传送", Content = "未找到该地点", Duration = 2 })
        end
    })

    local CAR_TELEPORTS = {
        {n = "拆车的地方", p = Vector3.new(3440.26, 43.30, 2680.51)},
    }
    local carTeleNames = {}
    for _, data in ipairs(CAR_TELEPORTS) do table.insert(carTeleNames, data.n) end
    local selectedCarTeleport = carTeleNames[1] or ""

    D:Divider({ Text = "偷车能用到的传送地点" })
    D:Dropdown({
        Title = "偷车能用到的传送地点",
        Values = carTeleNames,
        Value = carTeleNames[1],
        Callback = function(value)
            selectedCarTeleport = value
        end
    })
    D:Button({
        Title = "传送到选定地点",
        Callback = function()
            for _, data in ipairs(CAR_TELEPORTS) do
                if data.n == selectedCarTeleport then
                    doTeleport(data.p, data.n)
                    return
                end
            end
            WindUI:Notify({ Title = "传送", Content = "未找到该地点", Duration = 2 })
        end
    })

    local ESP_ENABLED = false
    local ESP_SHOW_NAME = true
    local ESP_SHOW_TEAM = true
    local ESP_SHOW_HEALTH = true
    local ESP_SHOW_DIST = true
    local ESP_SHOW_SELF = false
    local ESP_SHOW_PEERS = true
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
        if not p.Character then return end
        if not ESP_SHOW_SELF and p == player then return end
        
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
        bb.MaxDistance = 764
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
        if ESP_REFRESH_COUNT % 3 ~= 0 then
            return
        end

        for _, p in ipairs(Players:GetPlayers()) do
            if not ESP_SHOW_SELF and p == player then
                RemoveESP(p.UserId)
                continue
            end
            
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
                if p == player then
                    l.Text = p.Name .. " (你)"
                    l.TextColor3 = Color3.fromRGB(0, 255, 255)
                else
                    l.Text = p.Name
                    l.TextColor3 = color
                end
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
            if value then
                RefreshESP()
            end
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
    E:Divider()
    E:Toggle({
        Title = "透视自己",
        Value = false,
        Callback = function(value)
            ESP_SHOW_SELF = value
            if ESP_ENABLED then RefreshESP() end
        end
    })
    E:Toggle({
        Title = "同行显示",
        Value = true,
        Callback = function(value)
            ESP_SHOW_PEERS = value
            if ESP_ENABLED then RefreshESP() end
        end
    })

    task.spawn(function()
        while not isDestroyed do
            task.wait(0.3)
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
            musicSound.Volume = 0.5
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
                        nextIndex = 1
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
        Value = { Min = 0, Max = 7, Default = 1 },
        Callback = function(value)
            if musicSound then
                local actualVolume = math.min(value, 1)
                musicSound.Volume = actualVolume
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

    local SettingsTab = Window:Tab({ Title = "设置", Icon = "settings" })

    local adminVerified = false

    local KeySection = SettingsTab:Section({ Title = "开发者验证", Opened = true })
    KeySection:Paragraph({
        Title = "说明",
        Desc = "请输入开发者卡密才能进入开发者后台"
    })
    KeySection:Divider()

    local keyInputValue = ""
    KeySection:Input({
        Title = "卡密",
        Placeholder = "请输入开发者卡密...",
        Callback = function(value)
            keyInputValue = value
        end
    })

    local function buildAdminPanel()
        local AdminGroup = SettingsTab:Section({ Title = "开发者后台", Opened = true })
        AdminGroup:Paragraph({
            Title = "已授权",
            Desc = "当前身份: 开发者"
        })
        AdminGroup:Divider({ Text = "坐标显示" })

        local coordEnabled = false
        local coordGui = nil
        local coordFrame = nil
        local coordTextBox = nil
        local coordCopyBtn = nil
        local coordDragging = false
        local coordDragStart, coordStartPos
        local coordRenderConn = nil

        local function CreateCoordDisplay()
            if coordGui then return end
            
            local character = player.Character or player.CharacterAdded:Wait()
            local root = character:WaitForChild("HumanoidRootPart")
            
            coordGui = Instance.new("ScreenGui")
            coordGui.Name = "CoordinateCopyTool"
            coordGui.Parent = player:WaitForChild("PlayerGui")
            
            coordFrame = Instance.new("Frame")
            coordFrame.Size = UDim2.new(0, 250, 0, 100)
            coordFrame.Position = UDim2.new(0.5, -125, 0.5, -50)
            coordFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            coordFrame.Active = true
            coordFrame.Parent = coordGui
            
            coordTextBox = Instance.new("TextBox")
            coordTextBox.Size = UDim2.new(0.9, 0, 0, 30)
            coordTextBox.Position = UDim2.new(0.05, 0, 0.15, 0)
            coordTextBox.Text = "加载中..."
            coordTextBox.ClearTextOnFocus = false
            coordTextBox.TextEditable = false
            coordTextBox.Parent = coordFrame
            
            coordCopyBtn = Instance.new("TextButton")
            coordCopyBtn.Size = UDim2.new(0.9, 0, 0, 35)
            coordCopyBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
            coordCopyBtn.Text = "点击准备复制 (Ctrl+C)"
            coordCopyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            coordCopyBtn.TextColor3 = Color3.new(1, 1, 1)
            coordCopyBtn.Parent = coordFrame
            
            coordFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    coordDragging = true
                    coordDragStart = input.Position
                    coordStartPos = coordFrame.Position
                end
            end)
            
            coordFrame.InputChanged:Connect(function(input)
                if coordDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local delta = input.Position - coordDragStart
                    coordFrame.Position = UDim2.new(coordStartPos.X.Scale, coordStartPos.X.Offset + delta.X, coordStartPos.Y.Scale, coordStartPos.Y.Offset + delta.Y)
                end
            end)
            
            coordFrame.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    coordDragging = false
                end
            end)
            
            coordRenderConn = RunService.RenderStepped:Connect(function()
                if not coordEnabled then return end
                local char = player.Character
                if not char then return end
                local rootPart = char:FindFirstChild("HumanoidRootPart")
                if not rootPart then return end
                local pos = rootPart.Position
                local formattedPos = string.format("%.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z)
                if coordTextBox and not coordTextBox:IsFocused() then
                    coordTextBox.Text = formattedPos
                end
            end)
            table.insert(connections, coordRenderConn)
            
            coordCopyBtn.MouseButton1Click:Connect(function()
                if not coordTextBox then return end
                coordTextBox:CaptureFocus()
                coordTextBox.SelectionStart = 1
                coordTextBox.CursorPosition = #coordTextBox.Text + 1
                coordCopyBtn.Text = "现在按下 Ctrl + C 复制！"
                task.wait(2)
                coordCopyBtn.Text = "点击准备复制 (Ctrl+C)"
            end)
        end

        local function DestroyCoordDisplay()
            if coordRenderConn then
                coordRenderConn:Disconnect()
                coordRenderConn = nil
            end
            if coordGui then
                coordGui:Destroy()
                coordGui = nil
                coordFrame = nil
                coordTextBox = nil
                coordCopyBtn = nil
            end
        end

        AdminGroup:Toggle({
            Title = "启用坐标显示",
            Value = false,
            Callback = function(value)
                coordEnabled = value
                if value then
                    CreateCoordDisplay()
                else
                    DestroyCoordDisplay()
                end
            end
        })
    end

    KeySection:Button({
        Title = "验证并进入",
        Callback = function()
            if adminVerified then
                WindUI:Notify({ Title = "提示", Content = "已通过验证，无需重复", Duration = 2 })
                return
            end
            if keyInputValue == "2639zako" then
                adminVerified = true
                WindUI:Notify({ Title = "成功", Content = "验证通过，已解锁开发者后台", Duration = 3 })
                buildAdminPanel()
            else
                WindUI:Notify({ Title = "错误", Content = "卡密错误", Duration = 2 })
            end
        end
    })

    WindUI:Notify({
        Title = "wdfex-Hub",
        Content = "脚本已加载成功，欢迎使用！",
        Duration = 3,
    })
end