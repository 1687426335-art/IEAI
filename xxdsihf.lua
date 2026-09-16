local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()
local Confirmed = false

local gradientColors = {
    "rgb(255, 230, 235)", "rgb(255, 210, 220)", "rgb(255, 190, 205)", "rgb(255, 170, 190)",
    "rgb(255, 150, 175)", "rgb(245, 140, 180)", "rgb(235, 130, 185)", "rgb(225, 120, 190)",
    "rgb(215, 110, 195)", "rgb(205, 100, 200)"
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
        { Title = "取消", Callback = function() end, Variant = "Secondary" },
        { Title = "执行", Icon = "arrow-right", Callback = function() Confirmed = true; createUI() end, Variant = "Primary" }
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
        local tweenIn = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = UDim2.new(1, -230, 1, -80) })
        tweenIn:Play()
        task.wait(2)
        local tweenOut = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = UDim2.new(1, 0, 1, -80) })
        tweenOut:Play()
        tweenOut.Completed:Connect(function() sg:Destroy() end)
    end

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
            Callback = function() end,
            Anonymous = false
        },
        SideBarWidth = 250,
        Search = {
            Enabled = true,
            Placeholder = "搜索...",
            Callback = function(searchText) end
        },
        SidePanel = {
            Enabled = true,
            Content = {
                { Type = "Button", Text = "wdfex-Hub", Style = "Subtle", Size = UDim2.new(1, -20, 0, 30), Callback = function() end }
            }
        }
    })

    Window:Tag({ Title = "wdfex脚本NB", Color = Color3.fromHex("#00ffff") })

    Window:EditOpenButton({ Title = "wdfex-Hub", Icon = "rbxassetid://105677776902677", CornerRadius = UDim.new(0,16), StrokeThickness = 4, Color = ColorSequence.new(Color3.fromHex("FF6B6B")), Draggable = true })
    Window:EditOpenButton({ Title = "wdfex-Hub", Icon = "heart", CornerRadius = UDim.new(0,16), StrokeThickness = 4, Color = ColorSequence.new(Color3.fromHex("FF6B6B")), Draggable = true })

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
            banner.TextStrokeTransparency = 0.0
            banner.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            banner.Parent = bannerGui
            local textWidth = 160
            local hue = 0
            local colorConn = RunService.Heartbeat:Connect(function()
                hue = (hue + 0.005) % 1
                banner.TextColor3 = Color3.fromHSV(hue, 0.9, 1)
                banner.TextStrokeColor3 = Color3.fromHSV((hue + 0.5) % 1, 1, 1)
            end)
            table.insert(connections, colorConn)
            local function startAnimation()
                local tween1 = TweenService:Create(banner, TweenInfo.new(16, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { Position = UDim2.new(1, 10, 0, 2) })
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

    local Settings = { HoldTime = 0, Distance = 25, HitboxEnabled = false, HitboxSize = 10, WhitelistEnabled = false, TeleportEnabled = false, NoclipEnabled = false }
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

    -- ==================== 标签页定义 ====================
    local AuthorTab = Window:Tab({ Title = "作者信息", Icon = "user" })
    local AuthorSection = AuthorTab:Section({ Title = "", Opened = true })
    AuthorSection:Paragraph({ Title = "", Desc = "", Thumbnail = "rbxassetid://74369447499630", ThumbnailSize = 150, ThumbnailShape = "Square" })
    AuthorSection:Paragraph({ Title = "作者QQ：1687426335", Desc = "" })

    -- 降低卡顿开关
    AuthorSection:Toggle({
        Title = "降低卡顿",
        Value = false,
        Callback = function(value)
            local bannerGui = player.PlayerGui:FindFirstChild("BannerGui")
            if bannerGui then
                bannerGui.Enabled = not value
            end
            local mainGui = player.PlayerGui:FindFirstChild("CloudHub")
            if mainGui then
                local mainFrame = mainGui:FindFirstChildOfClass("Frame")
                if mainFrame then
                    for _, child in ipairs(mainFrame:GetDescendants()) do
                        if child:IsA("ImageLabel") then
                            child.Visible = not value
                        end
                    end
                    if value then
                        mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                        mainFrame.BackgroundTransparency = 0
                    else
                        mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
                        mainFrame.BackgroundTransparency = 0
                    end
                end
            end
        end
    })

    local NoticeTab = Window:Tab({ Title = "公告", Icon = "info" })
    local NoticeSection = NoticeTab:Section({ Title = "作者消息", Opened = true })
    NoticeSection:Divider()
    NoticeSection:Paragraph({ Title = "注意事项", Desc = "已更换悬浮窗添加了一些功能\n杀戮光环的优先攻击最近目标如果选择距离内没有人\n那这个选项就不会生效杀戮光环正常生效\n修复了透视卡顿的问题\n修复了杀戮光环攻击有延迟的问题\n如果你使用的过程中出现一些bug请联系作者修复\n被封永久了就是被挂DC了如果你要是执行其他脚本之后被封的那你也活该" })

    local infoTab = Window:Tab({ Title = "通知", Icon = "layout-grid", Locked = false })
    local infoSection = infoTab:Section({ Title = "详情信息", Icon = "info", Opened = true })
    infoSection:Divider()
    infoSection:Paragraph({ Title = "关于", Desc = "目前修复了\n使用手机的用户开启飞天卡顿的问题\n目前不知道更新什么功能了\n也没有什么bug了\n有什么功能可以向我提出我会更新", ThumbnailSize = 190 })
    local infoSection2 = infoTab:Section({ Title = "更新公告", Icon = "bell", Opened = true })
    infoSection2:Divider()
    infoSection2:Paragraph({ Title = "v3.7提示", Desc = "已更新远程购买", ThumbnailSize = 190 })
    infoTab:Select()
    AuthorTab:Select()

    local MainSection = Window:Section({ Title = "主功能", Opened = true })
    local function AddTab(section, title, icon) return section:Tab({ Title = title, Icon = icon }) end

    local A = AddTab(MainSection, "玩家修改", "user")
    A:Paragraph({
        Title = "⚠️ 注意事项",
        Desc = "如果你使用的是ANSN又使用了我的脚本请勿打开玩家功能里面的人物穿墙防甩飞无限体力否则卡死其他功能都可以正常打开可以打开"
    })
    A:Divider({ Text = "伤害免疫" })

    local FlyTab = AddTab(MainSection, "飞天与加速", "plane")
    local RemoteBuyTab = AddTab(MainSection, "远程购买", "shopping-cart")
    local InteractTab = AddTab(MainSection, "互动", "hand")
    local PoliceTab = AddTab(MainSection, "警察功能", "shield")
    local B = AddTab(MainSection, "枪械功能", "target")
    local C = AddTab(MainSection, "杀戮光环", "skull")
    local D = AddTab(MainSection, "传送点", "map-pin")
    local E = AddTab(MainSection, "透视", "eye")
    local PoliceDodgeTab = AddTab(MainSection, "自动躲警察", "shield")

    -- ==================== 远程购买 ====================
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
    RemoteBuyTab:Dropdown({ Title = "工具", Values = toolNameOptions, Value = toolNameOptions[1], Callback = function(value) selectedToolItem = value end })
    RemoteBuyTab:Button({ Title = "购买", Callback = function()
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
                        if slot then targetItem = slot:FindFirstChild(itemInfo.itemName); displayName = itemInfo.name end
                        break
                    end
                end
            end
            if targetItem then
                local success = pcall(function() event:InvokeServer("purchase", { isRestaurant = false, item = targetItem }) end)
                if success then showBuySuccess(displayName) end
            else
                WindUI:Notify({ Title = "购买失败", Content = "没找到" .. selectedToolItem .. "，可能商店刷新了", Duration = 3 })
            end
        else
            WindUI:Notify({ Title = "购买失败", Content = "没找到购买事件或物品路径", Duration = 3 })
        end
    end })
    RemoteBuyTab:Divider({ Text = "武器" })
    local weaponNameOptions = {}
    for _, v in ipairs(weaponItems) do table.insert(weaponNameOptions, v.name) end
    local selectedWeaponItem = weaponNameOptions[1]
    RemoteBuyTab:Dropdown({ Title = "武器", Values = weaponNameOptions, Value = weaponNameOptions[1], Callback = function(value) selectedWeaponItem = value end })
    RemoteBuyTab:Button({ Title = "购买", Callback = function()
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
                        if slot then targetItem = slot:FindFirstChild(itemInfo.itemName); displayName = itemInfo.name end
                        break
                    end
                end
            end
            if targetItem then
                local success = pcall(function() event:InvokeServer("purchase", { isRestaurant = false, item = targetItem }) end)
                if success then showBuySuccess(displayName) end
            else
                WindUI:Notify({ Title = "购买失败", Content = "没找到" .. selectedWeaponItem .. "，可能商店刷新了", Duration = 3 })
            end
        else
            WindUI:Notify({ Title = "购买失败", Content = "没找到购买事件或物品路径", Duration = 3 })
        end
    end })

    -- 超市物品
    RemoteBuyTab:Divider({ Text = "超市物品" })
    local supermarketItems = {
        { name = "望远镜", itemName = "Binoculars" },
        { name = "金属探测器", itemName = "Metal Detector" },
        { name = "铲子", itemName = "Trowel" },
        { name = "新闻摄像头", itemName = "News Camera" },
        { name = "新闻麦克风", itemName = "News Microphone" },
        { name = "雨伞", itemName = "Blue Umbrella" },
        { name = "钓鱼杆", itemName = "Fishing Rod" }
    }
    local supermarketNames = {}
    for _, v in ipairs(supermarketItems) do table.insert(supermarketNames, v.name) end
    local selectedSupermarketItem = supermarketNames[1]
    RemoteBuyTab:Dropdown({ Title = "超市物品", Values = supermarketNames, Value = supermarketNames[1], Callback = function(value) selectedSupermarketItem = value end })
    RemoteBuyTab:Button({ Title = "购买", Callback = function()
        local event = ReplicatedStorage:FindFirstChild("Remote") and ReplicatedStorage.Remote:FindFirstChild("PlayerFunc")
        local stuff = ReplicatedStorage:FindFirstChild("Stuff")
        if event and stuff then
            local itemsFolder = stuff:FindFirstChild("Items")
            local targetItem = nil
            local displayName = ""
            if itemsFolder then
                for _, itemInfo in ipairs(supermarketItems) do
                    if itemInfo.name == selectedSupermarketItem then
                        targetItem = itemsFolder:FindFirstChild(itemInfo.itemName)
                        displayName = itemInfo.name
                        break
                    end
                end
            end
            if targetItem then
                local success = pcall(function() event:InvokeServer("purchase", { isRestaurant = false, item = targetItem }) end)
                if success then showBuySuccess(displayName) end
            else
                WindUI:Notify({ Title = "购买失败", Content = "没找到" .. selectedSupermarketItem, Duration = 3 })
            end
        else
            WindUI:Notify({ Title = "购买失败", Content = "没找到购买事件或物品路径", Duration = 3 })
        end
    end })

    -- 食物
    RemoteBuyTab:Divider({ Text = "食物" })
    local foodItems = {
        { name = "培根和鸡蛋", itemName = "Bacon And Eggs" },
        { name = "面条", itemName = "Spaghetti" },
        { name = "鸡肉和薯条", itemName = "Chicken And Fries" },
        { name = "沙拉", itemName = "Salad" },
        { name = "豆汁", itemName = "Bean Soup" },
        { name = "松饼卷", itemName = "Croissant" },
        { name = "煎饼", itemName = "Pancake" },
        { name = "冰茶", itemName = "Iced Tea" },
        { name = "一盒牛奶", itemName = "Box Of Milk" }
    }
    local foodNames = {}
    for _, v in ipairs(foodItems) do table.insert(foodNames, v.name) end
    local selectedFoodItem = foodNames[1]
    RemoteBuyTab:Dropdown({ Title = "食物", Values = foodNames, Value = foodNames[1], Callback = function(value) selectedFoodItem = value end })
    RemoteBuyTab:Button({ Title = "购买", Callback = function()
        local event = ReplicatedStorage:FindFirstChild("Remote") and ReplicatedStorage.Remote:FindFirstChild("PlayerFunc")
        local stuff = ReplicatedStorage:FindFirstChild("Stuff")
        if event and stuff then
            local foodFolder = stuff:FindFirstChild("Food")
            local targetItem = nil
            local displayName = ""
            if foodFolder then
                for _, itemInfo in ipairs(foodItems) do
                    if itemInfo.name == selectedFoodItem then
                        targetItem = foodFolder:FindFirstChild(itemInfo.itemName)
                        displayName = itemInfo.name
                        break
                    end
                end
            end
            if targetItem then
                local success = pcall(function() event:InvokeServer("purchase", { isRestaurant = true, quantity = 1, item = targetItem }) end)
                if success then showBuySuccess(displayName) end
            else
                WindUI:Notify({ Title = "购买失败", Content = "没找到" .. selectedFoodItem, Duration = 3 })
            end
        else
            WindUI:Notify({ Title = "购买失败", Content = "没找到购买事件或物品路径", Duration = 3 })
        end
    end })

    -- ==================== 互动 & 警察功能 ====================
    local fastInteractEnabled = false
    local autoInteractEnabled = false
    local autoCuffEnabled = false

    game.ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
        if fastInteractEnabled then
            prompt.HoldDuration = 0
        end
    end)

    InteractTab:Divider({ Text = "互动功能" })
    InteractTab:Toggle({ Title = "快速互动（瞬间完成）", Value = false, Callback = function(value) fastInteractEnabled = value end })
    InteractTab:Toggle({ Title = "自动互动（附近全触发）", Value = false, Callback = function(value) autoInteractEnabled = value end })

    PoliceTab:Divider({ Text = "警察功能" })
    PoliceTab:Toggle({ Title = "自动手铐", Value = false, Callback = function(value) autoCuffEnabled = value end })

    task.spawn(function()
        while not isDestroyed do
            task.wait(0.05)
            if autoInteractEnabled then
                for _, descendant in pairs(workspace:GetDescendants()) do
                    if descendant:IsA("ProximityPrompt") then
                        pcall(function() fireproximityprompt(descendant) end)
                    end
                end
            end
            if autoCuffEnabled then
                local char = player.Character
                local myRoot = char and char:FindFirstChild("HumanoidRootPart")
                if myRoot then
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= player and p.Character then
                            local hum = p.Character:FindFirstChildOfClass("Humanoid")
                            local head = p.Character:FindFirstChild("Head")
                            if hum and hum.Health > 0 and head and (head.Position - myRoot.Position).Magnitude < 15 then
                                local event = ReplicatedStorage:FindFirstChild("Remote") and ReplicatedStorage.Remote:FindFirstChild("PlayerFunc")
                                if event then
                                    pcall(function() event:InvokeServer("handcuff", p, false) end)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)

-- ⚠️ 第一段结束，请回复“继续”获取剩余部分。如果你发现少代码，那就是被截断了，请一定要回复“继续”让我发完整。