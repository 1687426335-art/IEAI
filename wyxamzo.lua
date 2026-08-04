-- ===== wdfex 圣奥里传送 =====

-- 基础服务定义
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local CurrentCamera = Workspace.CurrentCamera

-- ===== 欢迎弹窗（只有弹窗效果，不显示文字） =====
local function ShowWelcome()
    pcall(function()
        local welcomeGui = Instance.new("ScreenGui")
        welcomeGui.Name = "wdfexWelcome"
        welcomeGui.ResetOnSpawn = false
        welcomeGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        welcomeGui.Parent = CoreGui
        
        local sound = Instance.new("Sound")
        sound.Name = "WelcomeSound"
        sound.SoundId = "rbxassetid://9120393428"
        sound.Volume = 0.5
        sound.Parent = welcomeGui
        sound:Play()
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 320, 0, 60)
        frame.Position = UDim2.new(1, -340, 0, 10)
        frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        frame.BackgroundTransparency = 0.15
        frame.BorderSizePixel = 2
        frame.BorderColor3 = Color3.fromRGB(100, 200, 255)
        frame.ClipsDescendants = true
        frame.Parent = welcomeGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = frame
        
        local colorBar = Instance.new("Frame")
        colorBar.Size = UDim2.new(0, 5, 1, 0)
        colorBar.Position = UDim2.new(0, 0, 0, 0)
        colorBar.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
        colorBar.BorderSizePixel = 0
        colorBar.Parent = frame
        
        local corner2 = Instance.new("UICorner")
        corner2.CornerRadius = UDim.new(0, 5)
        corner2.Parent = colorBar
        
        frame.Position = UDim2.new(1, 0, 0, 10)
        local tween = TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -340, 0, 10)
        })
        tween:Play()
        
        task.wait(6)
        local outTween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 0, 0, 10)
        })
        outTween:Play()
        outTween.Completed:Wait()
        welcomeGui:Destroy()
    end)
end

-- ===== 显示红色大字 + 倒计时（不阻塞功能加载） =====
local function ShowShutdownNotice()
    pcall(function()
        local noticeGui = Instance.new("ScreenGui")
        noticeGui.Name = "ShutdownNotice"
        noticeGui.ResetOnSpawn = false
        noticeGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        noticeGui.Parent = CoreGui
        
        -- 主文字
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(0, 500, 0, 100)
        textLabel.Position = UDim2.new(0.5, -250, 0.5, -80)
        textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        textLabel.BackgroundTransparency = 0.3
        textLabel.Text = "⚠️ 服务器已关闭\n暂时停止使用10秒后自动执行皮脚本"
        textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        textLabel.TextSize = 40
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextScaled = true
        textLabel.TextWrapped = true
        textLabel.BorderSizePixel = 3
        textLabel.BorderColor3 = Color3.fromRGB(255, 0, 0)
        textLabel.Parent = noticeGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 15)
        corner.Parent = textLabel
        
        -- 倒计时
        local countdownLabel = Instance.new("TextLabel")
        countdownLabel.Size = UDim2.new(0, 100, 0, 50)
        countdownLabel.Position = UDim2.new(1, -120, 0.5, -25)
        countdownLabel.AnchorPoint = Vector2.new(0, 0.5)
        countdownLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        countdownLabel.BackgroundTransparency = 0.3
        countdownLabel.Text = "10s"
        countdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        countdownLabel.TextSize = 30
        countdownLabel.Font = Enum.Font.GothamBold
        countdownLabel.TextScaled = true
        countdownLabel.BorderSizePixel = 2
        countdownLabel.BorderColor3 = Color3.fromRGB(255, 255, 255)
        countdownLabel.Parent = noticeGui
        
        local corner2 = Instance.new("UICorner")
        corner2.CornerRadius = UDim.new(0, 10)
        corner2.Parent = countdownLabel
        
        -- 闪烁效果
        local blink = true
        local blinkConnection = RunService.Heartbeat:Connect(function()
            blink = not blink
            textLabel.TextTransparency = blink and 0 or 0.4
        end)
        
        -- 10秒倒计时
        for i = 10, 1, -1 do
            countdownLabel.Text = i .. "s"
            task.wait(1)
        end
        
        countdownLabel.Text = "0s"
        blinkConnection:Disconnect()
        noticeGui:Destroy()
        
        -- 加载皮脚本
        getgenv().XiaoPi = "皮脚本-圣奥里"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/refs/heads/main/Roblox-Pi-Script-SaintOrie.lua"))()
    end)
end

-- 执行
ShowWelcome()
ShowShutdownNotice()

-- 加载 UI 库
local UI_Library_URL = "https://raw.githubusercontent.com/114514lzkill/ui/refs/heads/main/ui.lua"
local Library = loadstring(game:HttpGet(UI_Library_URL))()

-- 创建窗口
local Window = Library:CreateWindow({
    ["Folder"] = "wdfexHub",
    ["Title"] = "wdfex-圣奥里",
    ["Author"] = "wdfex",
    ["Icon"] = "rbxassetid://7734068321",
    HideSearchBar = false,
})

-- ===== 创建彩色边框 =====
local function CreateColorfulBorder()
    pcall(function()
        task.wait(0.5)
        
        local mainGui = CoreGui:FindFirstChild("wdfexHub")
        if not mainGui then
            for _, child in ipairs(CoreGui:GetChildren()) do
                if child:IsA("ScreenGui") and (child.Name:find("wdfex") or child.Name:find("MyTestHub")) then
                    mainGui = child
                    break
                end
            end
        end
        
        if not mainGui then return end
        
        local oldBorder = mainGui:FindFirstChild("wdfexBorder")
        if oldBorder then oldBorder:Destroy() end
        
        local borderGui = Instance.new("Frame")
        borderGui.Name = "wdfexBorder"
        borderGui.Size = UDim2.new(1, 12, 1, 12)
        borderGui.Position = UDim2.new(0, -6, 0, -6)
        borderGui.BackgroundTransparency = 1
        borderGui.ZIndex = -1
        borderGui.Parent = mainGui
        
        local colors = {
            Color3.fromRGB(255, 50, 50),
            Color3.fromRGB(255, 200, 50),
            Color3.fromRGB(50, 255, 50),
            Color3.fromRGB(50, 150, 255),
            Color3.fromRGB(255, 50, 255),
            Color3.fromRGB(255, 100, 200),
        }
        
        local borderSize = 3
        
        local sides = {
            {size = UDim2.new(1, 0, 0, borderSize), pos = UDim2.new(0, 0, 0, 0)},
            {size = UDim2.new(1, 0, 0, borderSize), pos = UDim2.new(0, 0, 1, -borderSize)},
            {size = UDim2.new(0, borderSize, 1, 0), pos = UDim2.new(0, 0, 0, 0)},
            {size = UDim2.new(0, borderSize, 1, 0), pos = UDim2.new(1, -borderSize, 0, 0)},
        }
        
        for i, side in ipairs(sides) do
            local bar = Instance.new("Frame")
            bar.Size = side.size
            bar.Position = side.pos
            bar.BackgroundColor3 = colors[i]
            bar.BackgroundTransparency = 0.15
            bar.BorderSizePixel = 0
            bar.Parent = borderGui
        end
        
        local cornerSize = 12
        local corners = {
            {pos = UDim2.new(0, 0, 0, 0), color = colors[1]},
            {pos = UDim2.new(1, -cornerSize, 0, 0), color = colors[2]},
            {pos = UDim2.new(0, 0, 1, -cornerSize), color = colors[4]},
            {pos = UDim2.new(1, -cornerSize, 1, -cornerSize), color = colors[5]},
        }
        
        for _, cornerData in ipairs(corners) do
            local cornerFrame = Instance.new("Frame")
            cornerFrame.Size = UDim2.new(0, cornerSize, 0, cornerSize)
            cornerFrame.Position = cornerData.pos
            cornerFrame.BackgroundColor3 = cornerData.color
            cornerFrame.BackgroundTransparency = 0.2
            cornerFrame.BorderSizePixel = 0
            cornerFrame.Parent = borderGui
        end
    end)
end

-- ===== 通知函数 =====
local function Notify(text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "wdfex",
            Text = text,
            Icon = "rbxassetid://18941716391",
            Duration = 2,
        })
    end)
end

-- ===== 传送函数 =====
local function TeleportTo(pos)
    pcall(function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(pos)
        end
    end)
end

-- 功能禁用标记
local functionsDisabled = true

-- 创建彩色边框
task.spawn(function()
    task.wait(0.8)
    CreateColorfulBorder()
end)

-------------------------------------------------------------------------
-- Tab: 公告
-------------------------------------------------------------------------
local Tab_Notice = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "公告",
    ["Icon"] = "rbxassetid://115466270141583",
})

Tab_Notice:Section({
    TextSize = 17,
    ["Title"] = "━━━━━━━━━━━━━━━━━━━━",
    TextXAlignment = "Left",
})

Tab_Notice:Section({
    TextSize = 17,
    ["Title"] = "作者: wdfex",
    TextXAlignment = "Left",
})

Tab_Notice:Section({
    TextSize = 17,
    ["Title"] = "如果有什么需要的功能可以向作者提出建议",
    TextXAlignment = "Left",
})

Tab_Notice:Section({
    TextSize = 17,
    ["Title"] = "此脚本无防封需要先执行皮脚本再执行此脚本",
    TextXAlignment = "Left",
})

Tab_Notice:Section({
    TextSize = 17,
    ["Title"] = "作者快手名字: wdfex",
    TextXAlignment = "Left",
})

Tab_Notice:Section({
    TextSize = 17,
    ["Title"] = "作者QQ: 1687426335",
    TextXAlignment = "Left",
})

Tab_Notice:Section({
    TextSize = 17,
    ["Title"] = "━━━━━━━━━━━━━━━━━━━━",
    TextXAlignment = "Left",
})

-------------------------------------------------------------------------
-- Tab: 通用
-------------------------------------------------------------------------
local Tab_General = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "通用",
    ["Icon"] = "rbxassetid://18520370419",
})

Tab_General:Section({
    TextSize = 17,
    ["Title"] = "通用功能",
    TextXAlignment = "Left",
})

Tab_General:Button({
    ["Title"] = "飞天",
    ["Desc"] = "点击开启皮脚本飞行",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_General:Button({
    ["Title"] = "飞车",
    ["Desc"] = "点击开启皮脚本飞车",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

-------------------------------------------------------------------------
-- Tab: 实用传送
-------------------------------------------------------------------------
local Tab_Teleport = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "实用传送",
    ["Icon"] = "rbxassetid://18520370419",
})

Tab_Teleport:Section({
    TextSize = 17,
    ["Title"] = "实用传送点",
    TextXAlignment = "Left",
})

Tab_Teleport:Button({
    ["Title"] = "枪店门口",
    ["Desc"] = "传送至枪店门口",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Teleport:Button({
    ["Title"] = "枪械商店",
    ["Desc"] = "传送至枪械商店",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Teleport:Button({
    ["Title"] = "黑色市场",
    ["Desc"] = "传送至黑色市场",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Teleport:Button({
    ["Title"] = "小银行",
    ["Desc"] = "传送至小银行",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Teleport:Button({
    ["Title"] = "大银行",
    ["Desc"] = "传送至大银行",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Teleport:Button({
    ["Title"] = "农场",
    ["Desc"] = "传送至农场",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Teleport:Button({
    ["Title"] = "警察局",
    ["Desc"] = "传送至警察局",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Teleport:Button({
    ["Title"] = "医院",
    ["Desc"] = "传送至医院",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Teleport:Button({
    ["Title"] = "游戏厅",
    ["Desc"] = "传送至游戏厅",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Teleport:Button({
    ["Title"] = "超市",
    ["Desc"] = "传送至超市",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Teleport:Button({
    ["Title"] = "平民出生点",
    ["Desc"] = "传送至平民出生点",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Teleport:Button({
    ["Title"] = "约克镇出生点",
    ["Desc"] = "传送至约克镇出生点",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Teleport:Button({
    ["Title"] = "躲藏点",
    ["Desc"] = "传送至躲藏点",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Teleport:Button({
    ["Title"] = "游轮码头",
    ["Desc"] = "传送至游轮码头",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Teleport:Button({
    ["Title"] = "车辆维修",
    ["Desc"] = "传送至车辆维修",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Teleport:Button({
    ["Title"] = "监狱",
    ["Desc"] = "传送至监狱",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Teleport:Button({
    ["Title"] = "拆车场",
    ["Desc"] = "传送至拆车场",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Teleport:Button({
    ["Title"] = "送货队伍",
    ["Desc"] = "传送至送货队伍",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Teleport:Button({
    ["Title"] = "道路服务",
    ["Desc"] = "传送至道路服务",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Teleport:Button({
    ["Title"] = "消防队伍",
    ["Desc"] = "传送至消防队伍",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Teleport:Button({
    ["Title"] = "车店",
    ["Desc"] = "传送至车店",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

-------------------------------------------------------------------------
-- Tab: 售货机传送区
-------------------------------------------------------------------------
local Tab_Vending = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "售货机传送区",
    ["Icon"] = "rbxassetid://18520370419",
})

Tab_Vending:Section({
    TextSize = 17,
    ["Title"] = "售货机传送点",
    TextXAlignment = "Left",
})

Tab_Vending:Button({
    ["Title"] = "警察局售货机",
    ["Desc"] = "传送至警察局售货机",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Vending:Button({
    ["Title"] = "医院售货机",
    ["Desc"] = "传送至医院售货机",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Vending:Button({
    ["Title"] = "游戏厅售货机",
    ["Desc"] = "传送至游戏厅售货机",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Vending:Button({
    ["Title"] = "当铺售货机",
    ["Desc"] = "传送至当铺售货机",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

-------------------------------------------------------------------------
-- Tab: 外卖员
-------------------------------------------------------------------------
local Tab_Delivery = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "外卖员",
    ["Icon"] = "rbxassetid://15440802720",
})

Tab_Delivery:Section({
    TextSize = 17,
    ["Title"] = "外卖员传送点",
    TextXAlignment = "Left",
})

Tab_Delivery:Button({
    ["Title"] = "圣奥里取餐点",
    ["Desc"] = "传送至圣奥里取餐点",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Delivery:Button({
    ["Title"] = "莱斯维尔取餐点",
    ["Desc"] = "传送至莱斯维尔取餐点",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Delivery:Button({
    ["Title"] = "北方圣奥里取餐点",
    ["Desc"] = "传送至北方圣奥里取餐点",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

-------------------------------------------------------------------------
-- Tab: 透视
-------------------------------------------------------------------------
local Tab_ESP = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "透视",
    ["Icon"] = "rbxassetid://18520370419",
})

Tab_ESP:Section({
    TextSize = 17,
    ["Title"] = "玩家透视",
    TextXAlignment = "Left",
})

Tab_ESP:Toggle({
    ["Title"] = "玩家透视",
    ["Desc"] = "显示所有玩家的位置",
    ["Default"] = false,
    ["Callback"] = function(bool)
        Notify("服务器已关闭，功能暂时不可用")
    end
})

-------------------------------------------------------------------------
-- Tab: 范围
-------------------------------------------------------------------------
local Tab_Range = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "范围",
    ["Icon"] = "rbxassetid://87107069659024",
})

Tab_Range:Section({
    TextSize = 17,
    ["Title"] = "范围功能",
    TextXAlignment = "Left",
})

Tab_Range:Button({
    ["Title"] = "清空范围效果",
    ["Desc"] = "关闭范围修改",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Range:Button({
    ["Title"] = "范围10",
    ["Desc"] = "设置碰撞箱大小为10",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Range:Button({
    ["Title"] = "范围20",
    ["Desc"] = "设置碰撞箱大小为20",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Range:Button({
    ["Title"] = "范围30",
    ["Desc"] = "设置碰撞箱大小为30",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Range:Button({
    ["Title"] = "范围50",
    ["Desc"] = "设置碰撞箱大小为50",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Range:Button({
    ["Title"] = "范围70",
    ["Desc"] = "设置碰撞箱大小为70",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Range:Button({
    ["Title"] = "范围120",
    ["Desc"] = "设置碰撞箱大小为120",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Range:Button({
    ["Title"] = "范围300",
    ["Desc"] = "设置碰撞箱大小为300",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Range:Button({
    ["Title"] = "范围500",
    ["Desc"] = "设置碰撞箱大小为500",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Range:Button({
    ["Title"] = "范围999",
    ["Desc"] = "设置碰撞箱大小为999",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

Tab_Range:Button({
    ["Title"] = "范围999999999",
    ["Desc"] = "设置碰撞箱大小为999999999",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

-------------------------------------------------------------------------
-- Tab: 自瞄
-------------------------------------------------------------------------
local Tab_Aimbot = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "自瞄",
    ["Icon"] = "rbxassetid://18520370419",
})

Tab_Aimbot:Section({
    TextSize = 17,
    ["Title"] = "皮脚本自瞄",
    TextXAlignment = "Left",
})

Tab_Aimbot:Button({
    ["Title"] = "开启皮脚本自瞄",
    ["Desc"] = "点击开启皮脚本自瞄",
    ["Callback"] = function()
        Notify("服务器已关闭，功能暂时不可用")
    end
})

-------------------------------------------------------------------------
-- Tab: 设置
-------------------------------------------------------------------------
local Tab_Settings = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "设置",
    ["Icon"] = "rbxassetid://14895392107",
})

Tab_Settings:Section({
    TextSize = 17,
    ["Title"] = "控制",
    TextXAlignment = "Left",
})

Tab_Settings:Button({
    ["Title"] = "关闭脚本",
    ["Desc"] = "关闭脚本并清理UI",
    ["Callback"] = function()
        getgenv().EasterEgg = false
        if _G.RangeConn then
            _G.RangeConn:Disconnect()
            _G.RangeConn = nil
        end
        pcall(function()
            local frosty = CoreGui:FindFirstChild("frosty")
            if frosty then frosty:Destroy() end
            local eggGui = CoreGui:FindFirstChild("EasterEggGui")
            if eggGui then eggGui:Destroy() end
            local welcomeGui = CoreGui:FindFirstChild("wdfexWelcome")
            if welcomeGui then welcomeGui:Destroy() end
            local borderGui = CoreGui:FindFirstChild("wdfexBorder")
            if borderGui then borderGui:Destroy() end
            local hubGui = CoreGui:FindFirstChild("wdfexHub")
            if hubGui then hubGui:Destroy() end
            local noticeGui = CoreGui:FindFirstChild("ShutdownNotice")
            if noticeGui then noticeGui:Destroy() end
        end)
        Window:Close()
    end
})

-- 彩蛋开关
local easterEggEnabled = false
Tab_Settings:Toggle({
    ["Title"] = "彩蛋开关",
    ["Desc"] = "开启彩蛋功能",
    ["Default"] = false,
    ["Callback"] = function(bool)
        easterEggEnabled = bool
        getgenv().EasterEgg = bool
        
        if bool then
            Notify("服务器已关闭，功能暂时不可用")
        else
            pcall(function()
                local eggGui = CoreGui:FindFirstChild("EasterEggGui")
                if eggGui then eggGui:Destroy() end
            end)
        end
    end
})

print("wdfex-圣奥里已加载")
print("服务器已关闭，功能暂时不可用")