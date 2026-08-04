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

-- ===== 欢迎弹窗 =====
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
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -15, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = "🎉 欢迎使用 wdfex 脚本"
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 18
        label.Font = Enum.Font.GothamBold
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
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

-- 执行
ShowWelcome()

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
    ["Title"] = "本脚本已同步连接皮脚本的服务器，可在透视里面打开同行显示即可在皮脚本用户的头上显示皮脚本更容易让你分辨它是什么脚本",
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
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/07cdd3eeaf4d4928.txt_2024-08-09_090317.OTed.lua"))()
    end
})

Tab_General:Button({
    ["Title"] = "飞车",
    ["Desc"] = "点击开启皮脚本飞车",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/Pi-feiche.lua"))()
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
        TeleportTo(Vector3.new(-330.09, 2.63, 24.57))
    end
})

Tab_Teleport:Button({
    ["Title"] = "枪械商店",
    ["Desc"] = "传送至枪械商店",
    ["Callback"] = function()
        TeleportTo(Vector3.new(-336.86, -205.07, 61.75))
    end
})

Tab_Teleport:Button({
    ["Title"] = "黑色市场",
    ["Desc"] = "传送至黑色市场",
    ["Callback"] = function()
        TeleportTo(Vector3.new(1040.91, -22.73, 899.80))
    end
})

Tab_Teleport:Button({
    ["Title"] = "小银行",
    ["Desc"] = "传送至小银行",
    ["Callback"] = function()
        TeleportTo(Vector3.new(-667.74, 2.63, -67.18))
    end
})

Tab_Teleport:Button({
    ["Title"] = "大银行",
    ["Desc"] = "传送至大银行",
    ["Callback"] = function()
        TeleportTo(Vector3.new(3134.64, 6.12, -169.70))
    end
})

Tab_Teleport:Button({
    ["Title"] = "农场",
    ["Desc"] = "传送至农场",
    ["Callback"] = function()
        TeleportTo(Vector3.new(-1269.56, 2.57, 2559.51))
    end
})

Tab_Teleport:Button({
    ["Title"] = "警察局",
    ["Desc"] = "传送至警察局",
    ["Callback"] = function()
        TeleportTo(Vector3.new(3313.52, 3.02, -476.74))
    end
})

Tab_Teleport:Button({
    ["Title"] = "医院",
    ["Desc"] = "传送至医院",
    ["Callback"] = function()
        TeleportTo(Vector3.new(3892.10, 3.02, -185.78))
    end
})

Tab_Teleport:Button({
    ["Title"] = "游戏厅",
    ["Desc"] = "传送至游戏厅",
    ["Callback"] = function()
        TeleportTo(Vector3.new(2936.71, 2.63, 1688.17))
    end
})

Tab_Teleport:Button({
    ["Title"] = "超市",
    ["Desc"] = "传送至超市",
    ["Callback"] = function()
        TeleportTo(Vector3.new(3936.62, 3.04, 1136.92))
    end
})

Tab_Teleport:Button({
    ["Title"] = "平民出生点",
    ["Desc"] = "传送至平民出生点",
    ["Callback"] = function()
        TeleportTo(Vector3.new(3741.79, 3.72, -438.95))
    end
})

Tab_Teleport:Button({
    ["Title"] = "约克镇出生点",
    ["Desc"] = "传送至约克镇出生点",
    ["Callback"] = function()
        TeleportTo(Vector3.new(-221.64, 3.04, -84.56))
    end
})

Tab_Teleport:Button({
    ["Title"] = "躲藏点",
    ["Desc"] = "传送至躲藏点",
    ["Callback"] = function()
        TeleportTo(Vector3.new(-1505.97, 253.98, -476.43))
    end
})

Tab_Teleport:Button({
    ["Title"] = "游轮码头",
    ["Desc"] = "传送至游轮码头",
    ["Callback"] = function()
        TeleportTo(Vector3.new(985.45, -22.53, 1274.22))
    end
})

Tab_Teleport:Button({
    ["Title"] = "车辆维修",
    ["Desc"] = "传送至车辆维修",
    ["Callback"] = function()
        TeleportTo(Vector3.new(-409.58, 3.08, 2.80))
    end
})

Tab_Teleport:Button({
    ["Title"] = "监狱",
    ["Desc"] = "传送至监狱",
    ["Callback"] = function()
        TeleportTo(Vector3.new(-1605.21, 2.63, 1223.50))
    end
})

Tab_Teleport:Button({
    ["Title"] = "拆车场",
    ["Desc"] = "传送至拆车场",
    ["Callback"] = function()
        TeleportTo(Vector3.new(3434.49, 42.93, 2686.46))
    end
})

Tab_Teleport:Button({
    ["Title"] = "送货队伍",
    ["Desc"] = "传送至送货队伍",
    ["Callback"] = function()
        TeleportTo(Vector3.new(4402.39, 3.04, 1607.56))
    end
})

Tab_Teleport:Button({
    ["Title"] = "道路服务",
    ["Desc"] = "传送至道路服务",
    ["Callback"] = function()
        TeleportTo(Vector3.new(4275.96, 2.63, 1200.88))
    end
})

Tab_Teleport:Button({
    ["Title"] = "消防队伍",
    ["Desc"] = "传送至消防队伍",
    ["Callback"] = function()
        TeleportTo(Vector3.new(3578.02, 8.15, 577.34))
    end
})

Tab_Teleport:Button({
    ["Title"] = "车店",
    ["Desc"] = "传送至车店",
    ["Callback"] = function()
        TeleportTo(Vector3.new(0, 0, 0))
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
        TeleportTo(Vector3.new(3375.46, -337.46, -473.67))
    end
})

Tab_Vending:Button({
    ["Title"] = "医院售货机",
    ["Desc"] = "传送至医院售货机",
    ["Callback"] = function()
        TeleportTo(Vector3.new(3939.51, -337.12, -199.84))
    end
})

Tab_Vending:Button({
    ["Title"] = "游戏厅售货机",
    ["Desc"] = "传送至游戏厅售货机",
    ["Callback"] = function()
        TeleportTo(Vector3.new(2904.22, -337.11, 1732.52))
    end
})

Tab_Vending:Button({
    ["Title"] = "当铺售货机",
    ["Desc"] = "传送至当铺售货机",
    ["Callback"] = function()
        TeleportTo(Vector3.new(-207.06, -337.05, -99.43))
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
        TeleportTo(Vector3.new(3070.80, 3.02, 451.35))
    end
})

Tab_Delivery:Button({
    ["Title"] = "莱斯维尔取餐点",
    ["Desc"] = "传送至莱斯维尔取餐点",
    ["Callback"] = function()
        TeleportTo(Vector3.new(756.54, 3.04, 1006.94))
    end
})

Tab_Delivery:Button({
    ["Title"] = "北方圣奥里取餐点",
    ["Desc"] = "传送至北方圣奥里取餐点",
    ["Callback"] = function()
        TeleportTo(Vector3.new(4535.62, 2.60, 915.71))
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
    ["Title"] = "透视开关",
    TextXAlignment = "Left",
})

-- 总开关
local espMasterEnabled = false
local espObjects = {}
local espRenderConnection = nil

-- 各功能开关状态
local espShowName = false
local espShowHealth = false
local espShowBox = false
local espShowBone = false
local espShowDist = false
local espShowScriptTag = false
local espShowSelf = true  -- 默认为true，即屏蔽自己（不显示自己）
local espShowTeam = false

-- 检测当前玩家自己的脚本
local function GetMyScriptTag()
    -- 检测自己是否使用了皮脚本
    local hasPi = false
    local hasWdfex = false
    
    -- 检测皮脚本特征
    if LocalPlayer:FindFirstChild("PiScriptTag") or LocalPlayer:FindFirstChild("XiaoPi") then
        hasPi = true
    end
    -- 检测wdfex脚本特征（自己肯定有）
    if LocalPlayer:FindFirstChild("WdfexTag") or LocalPlayer:FindFirstChild("wdfex") then
        hasWdfex = true
    end
    
    -- 如果都没检测到，但有脚本标记，默认自己就是wdfex
    if not hasPi and not hasWdfex then
        hasWdfex = true  -- 默认自己使用wdfex
    end
    
    if hasPi and hasWdfex then
        return "皮脚本 + wdfex"
    elseif hasPi then
        return "皮脚本"
    elseif hasWdfex then
        return "wdfex"
    else
        return nil
    end
end

-- 检测玩家使用的脚本（包括自己）
local function CheckPlayerScript(player)
    local hasPiScript = false
    local hasWdfexScript = false
    
    if player:FindFirstChild("PiScriptTag") or player:FindFirstChild("XiaoPi") then
        hasPiScript = true
    end
    if player:FindFirstChild("WdfexTag") or player:FindFirstChild("wdfex") then
        hasWdfexScript = true
    end
    
    -- 如果是自己，强制检测
    if player == LocalPlayer then
        local myTag = GetMyScriptTag()
        if myTag then
            return myTag
        end
        return "wdfex"
    end
    
    if hasPiScript and hasWdfexScript then
        return "皮脚本 + wdfex"
    elseif hasPiScript then
        return "皮脚本"
    elseif hasWdfexScript then
        return "wdfex"
    else
        return nil
    end
end

-- 获取玩家队伍
local function GetPlayerTeam(player)
    if not player.Team then return "无队伍" end
    local teamName = player.Team.Name or ""
    if teamName:find("警察") or teamName:find("Police") or teamName:find("Cop") then
        return "警察"
    elseif teamName:find("匪徒") or teamName:find("Criminal") or teamName:find("Gang") then
        return "匪徒"
    elseif teamName:find("医疗") or teamName:find("Medic") or teamName:find("医生") then
        return "医疗"
    elseif teamName:find("消防") or teamName:find("Fire") then
        return "火焰"
    elseif teamName:find("道路") or teamName:find("Road") then
        return "道路"
    elseif teamName:find("送货") or teamName:find("Delivery") then
        return "送货"
    elseif teamName:find("农民") or teamName:find("Farm") then
        return "农民"
    else
        return "平民"
    end
end

local function ClearESP()
    for _, obj in ipairs(espObjects) do
        pcall(function() obj:Destroy() end)
    end
    espObjects = {}
    if espRenderConnection then
        espRenderConnection:Disconnect()
        espRenderConnection = nil
    end
end

-- 为单个玩家创建ESP
local function CreateESPForPlayer(player)
    local character = player.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local health = humanoid and math.floor(humanoid.Health) or 0
    local maxHealth = humanoid and math.floor(humanoid.MaxHealth) or 100
    local distance = 0
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        distance = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude)
    end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 130)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = rootPart
    table.insert(espObjects, billboard)
    
    local yOffset = 0
    
    -- 队伍显示
    if espShowTeam then
        local team = GetPlayerTeam(player)
        local teamColor = Color3.fromRGB(200, 200, 200)
        if team == "警察" then
            teamColor = Color3.fromRGB(0, 100, 255)
        elseif team == "匪徒" then
            teamColor = Color3.fromRGB(255, 50, 50)
        elseif team == "医疗" then
            teamColor = Color3.fromRGB(0, 255, 100)
        elseif team == "火焰" then
            teamColor = Color3.fromRGB(255, 150, 0)
        elseif team == "道路" then
            teamColor = Color3.fromRGB(255, 255, 0)
        elseif team == "送货" then
            teamColor = Color3.fromRGB(255, 150, 255)
        elseif team == "农民" then
            teamColor = Color3.fromRGB(50, 255, 50)
        else
            teamColor = Color3.fromRGB(200, 200, 200)
        end
        
        local teamLabel = Instance.new("TextLabel")
        teamLabel.Size = UDim2.new(1, 0, 0, 18)
        teamLabel.Position = UDim2.new(0, 0, 0, yOffset)
        teamLabel.BackgroundTransparency = 1
        teamLabel.Text = team
        teamLabel.TextColor3 = teamColor
        teamLabel.TextSize = 13
        teamLabel.Font = Enum.Font.GothamBold
        teamLabel.TextStrokeTransparency = 0.3
        teamLabel.Parent = billboard
        table.insert(espObjects, teamLabel)
        yOffset = yOffset + 20
    end
    
    -- 脚本标签（同行显示）
    if espShowScriptTag then
        local scriptTag = CheckPlayerScript(player)
        if scriptTag then
            local tagLabel = Instance.new("Text