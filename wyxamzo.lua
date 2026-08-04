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
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")

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

if not Library then
    UI_Library_URL = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/UI.Lua"
    Library = loadstring(game:HttpGet(UI_Library_URL))()
end

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
-- Tab: 帧率
-------------------------------------------------------------------------
local Tab_FPS = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "帧率",
    ["Icon"] = "rbxassetid://18520370419",
})

Tab_FPS:Section({
    TextSize = 17,
    ["Title"] = "帧率优化",
    TextXAlignment = "Left",
})

local fpsLocked = false

Tab_FPS:Toggle({
    ["Title"] = "锁60帧",
    ["Desc"] = "将帧率锁定在60帧，保持流畅",
    ["Default"] = false,
    ["Callback"] = function(bool)
        fpsLocked = bool
        if bool then
            pcall(function()
                setfpscap(60)
            end)
        else
            pcall(function()
                setfpscap(0)
            end)
        end
    end
})

Tab_FPS:Toggle({
    ["Title"] = "性能模式",
    ["Desc"] = "降低画质提高帧率",
    ["Default"] = false,
    ["Callback"] = function(bool)
        if bool then
            pcall(function()
                Lighting.GlobalShadows = false
                Lighting.Technology = Enum.Technology.Compatibility
                Workspace.FallenPartsDestroyHeight = -500
            end)
        else
            pcall(function()
                Lighting.GlobalShadows = true
                Lighting.Technology = Enum.Technology.Future
                Workspace.FallenPartsDestroyHeight = -100
            end)
        end
    end
})

Tab_FPS:Button({
    ["Title"] = "优化游戏流畅度",
    ["Desc"] = "一键优化",
    ["Callback"] = function()
        pcall(function()
            setfpscap(60)
            Lighting.GlobalShadows = false
            Lighting.Technology = Enum.Technology.Compatibility
            Workspace.FallenPartsDestroyHeight = -500
        end)
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

local espMasterEnabled = false
local espObjects = {}
local espRenderConnection = nil

local espShowName = false
local espShowHealth = false
local espShowBox = false
local espShowBone = false
local espShowDist = false
local espShowScriptTag = false
local espShowSelf = true
local espShowTeam = false
local espShowWeapon = false

-- ===== 背后预警系统 =====
local policeAlertEnabled = false
local policeAlertGui = nil
local policeAlertLabel = nil
local policeDistLabel = nil
local policeAlertConnection = nil

local function CreatePoliceAlert()
    if policeAlertGui then
        policeAlertGui:Destroy()
        policeAlertGui = nil
    end
    
    policeAlertGui = Instance.new("ScreenGui")
    policeAlertGui.Name = "PoliceAlert"
    policeAlertGui.ResetOnSpawn = false
    policeAlertGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    policeAlertGui.Parent = CoreGui
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 350, 0, 80)
    bg.Position = UDim2.new(0.5, -175, 0, 20)
    bg.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    bg.BackgroundTransparency = 0.2
    bg.BorderSizePixel = 2
    bg.BorderColor3 = Color3.fromRGB(255, 0, 0)
    bg.Visible = false
    bg.Parent = policeAlertGui
    policeAlertLabel = bg
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = bg
    
    local warnText = Instance.new("TextLabel")
    warnText.Size = UDim2.new(1, 0, 0, 30)
    warnText.Position = UDim2.new(0, 0, 0, 5)
    warnText.BackgroundTransparency = 1
    warnText.Text = "⚠️ 警察来了！快跑！"
    warnText.TextColor3 = Color3.fromRGB(255, 255, 255)
    warnText.TextSize = 22
    warnText.Font = Enum.Font.GothamBold
    warnText.TextScaled = true
    warnText.Parent = bg
    
    local distText = Instance.new("TextLabel")
    distText.Size = UDim2.new(1, 0, 0, 25)
    distText.Position = UDim2.new(0, 0, 0, 40)
    distText.BackgroundTransparency = 1
    distText.Text = "距离: 0m"
    distText.TextColor3 = Color3.fromRGB(255, 255, 200)
    distText.TextSize = 16
    distText.Font = Enum.Font.GothamBold
    distText.Parent = bg
    policeDistLabel = distText
end

local function UpdatePoliceAlert()
    if not policeAlertEnabled then
        if policeAlertGui then
            policeAlertGui:Destroy()
            policeAlertGui = nil
        end
        if policeAlertConnection then
            policeAlertConnection:Disconnect()
            policeAlertConnection = nil
        end
        return
    end
    
    if not policeAlertGui then
        CreatePoliceAlert()
    end
    
    if policeAlertConnection then
        policeAlertConnection:Disconnect()
        policeAlertConnection = nil
    end
    
    policeAlertConnection = RunService.Heartbeat:Connect(function()
        if not policeAlertEnabled then return end
        if not LocalPlayer.Character then return end
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local closestPolice = nil
        local closestDist = 1000
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            if not player.Character then continue end
            local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
            if not targetHrp then continue end
            
            local isPolice = false
            if player.Team then
                local teamName = player.Team.Name or ""
                if teamName:find("警察") or teamName:find("Police") or teamName:find("Cop") then
                    isPolice = true
                end
            end
            
            if not isPolice then
                for _, child in ipairs(player.Character:GetDescendants()) do
                    if child:IsA("StringValue") or child:IsA("BoolValue") then
                        local name = child.Name:lower()
                        if name:find("police") or name:find("cop") or name:find("警察") then
                            isPolice = true
                            break
                        end
                    end
                end
            end
            
            if isPolice then
                local dist = (hrp.Position - targetHrp.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closestPolice = player
                end
            end
        end
        
        if closestPolice and closestDist < 50 then
            policeAlertLabel.Visible = true
            
            local warnColor = Color3.fromRGB(255, 0, 0)
            if closestDist > 30 then
                warnColor = Color3.fromRGB(255, 200, 0)
            elseif closestDist > 20 then
                warnColor = Color3.fromRGB(255, 150, 0)
            else
                warnColor = Color3.fromRGB(255, 0, 0)
            end
            
            policeAlertLabel.BackgroundColor3 = warnColor
            policeAlertLabel.BackgroundTransparency = 0.25
            policeAlertLabel.BorderColor3 = warnColor
            
            if policeDistLabel then
                policeDistLabel.Text = "警察 " .. closestPolice.Name .. " 距离: " .. math.floor(closestDist) .. "m"
            end
            
            if closestDist < 20 then
                local policeHrp = closestPolice.Character:FindFirstChild("HumanoidRootPart")
                if policeHrp then
                    local lookDirection = policeHrp.CFrame.LookVector
                    local toPlayer = (hrp.Position - policeHrp.Position).Unit
                    local dot = lookDirection:Dot(toPlayer)
                    if dot > 0.3 then
                        if policeDistLabel then
                            policeDistLabel.Text = "警察 " .. closestPolice.Name .. " 正在靠近! " .. math.floor(closestDist) .. "m"
                        end
                        policeAlertLabel.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                        policeAlertLabel.BackgroundTransparency = 0.15
                    end
                end
            end
        else
            if policeAlertLabel then
                policeAlertLabel.Visible = false
            end
        end
    end)
end

local function CheckPlayerScript(player)
    local hasPiScript = false
    local hasWdfexScript = false
    
    for _, child in ipairs(player:GetChildren()) do
        if child:IsA("BoolValue") or child:IsA("StringValue") then
            local name = child.Name:lower()
            if name:find("perscript") or name:find("xiaopi") or name:find("皮脚本") then
                hasPiScript = true
            end
            if name:find("wdfex") or name:find("wdfexscript") then
                hasWdfexScript = true
            end
        end
    end
    
    if player.Character then
        for _, child in ipairs(player.Character:GetDescendants()) do
            if child:IsA("BoolValue") or child:IsA("StringValue") then
                local name = child.Name:lower()
                if name:find("perscript") or name:find("xiaopi") or name:find("皮脚本") then
                    hasPiScript = true
                end
                if name:find("wdfex") or name:find("wdfexscript") then
                    hasWdfexScript = true
                end
            end
        end
    end
    
    if player == LocalPlayer then
        hasWdfexScript = true
        if LocalPlayer:FindFirstChild("PiScriptTag") or LocalPlayer:FindFirstChild("XiaoPi") then
            hasPiScript = true
        end
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

local function GetPlayerTeam(player)
    if not player.Team then return "平民" end
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

local function GetPlayerWeapon(player)
    local character = player.Character
    if not character then return "赤手空拳" end
    
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Tool") and child:FindFirstChild("Handle") then
            if child.Parent == character then
                return child.Name
            end
        end
    end
    
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") then
                return child.Name
            end
        end
    end
    
    return "赤手空拳"
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

local function GetCharacterSize(character)
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp then
        return hrp.Size
    end
    return Vector3.new(3, 5, 1.5)
end

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
    
    local charSize = GetCharacterSize(character)
    local weapon = GetPlayerWeapon(player)
    local team = GetPlayerTeam(player)
    local scriptTag = CheckPlayerScript(player)
    
    local teamColor = Color3.fromRGB(200, 200, 200)
    if team == "警察" then teamColor = Color3.fromRGB(0, 150, 255)
    elseif team == "匪徒" then teamColor = Color3.fromRGB(255, 50, 50)
    elseif team == "医疗" then teamColor = Color3.fromRGB(0, 255, 100)
    elseif team == "火焰" then teamColor = Color3.fromRGB(255, 150, 0)
    elseif team == "道路" then teamColor = Color3.fromRGB(255, 255, 0)
    elseif team == "送货" then teamColor = Color3.fromRGB(255, 150, 255)
    elseif team == "农民" then teamColor = Color3.fromRGB(50, 255, 50)
    end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 100)
    billboard.StudsOffset = Vector3.new(0, charSize.Y / 2 + 1.8, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = rootPart
    table.insert(espObjects, billboard)
    
    local yOffset = 0
    
    if espShowName then
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0, 18)
        nameLabel.Position = UDim2.new(0, 0, 0, yOffset)
        nameLabel.BackgroundTransparency = 1
        if player == LocalPlayer then
            nameLabel.Text = player.Name .. " (你)"
            nameLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
        else
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        nameLabel.TextSize = 13
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextStrokeTransparency = 0.3
        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLabel.Parent = billboard
        table.insert(espObjects, nameLabel)
        yOffset = yOffset + 20
    end
    
    if espShowTeam then
        local teamLabel = Instance.new("TextLabel")
        teamLabel.Size = UDim2.new(1, 0, 0, 14)
        teamLabel.Position = UDim2.new(0, 0, 0, yOffset)
        teamLabel.BackgroundTransparency = 1
        teamLabel.Text = team
        teamLabel.TextColor3 = teamColor
        teamLabel.TextSize = 11
        teamLabel.Font = Enum.Font.GothamBold
        teamLabel.TextStrokeTransparency = 0.3
        teamLabel.Parent = billboard
        table.insert(espObjects, teamLabel)
        yOffset = yOffset + 16
    end
    
    if espShowScriptTag and scriptTag then
        local tagColor = Color3.fromRGB(255, 255, 255)
        if scriptTag == "皮脚本" then
            tagColor = Color3.fromRGB(255, 100, 100)
        elseif scriptTag == "wdfex" then
            tagColor = Color3.fromRGB(100, 180, 255)
        elseif scriptTag == "皮脚本 + wdfex" then
            tagColor = Color3.fromRGB(200, 100, 255)
        end
        
        local tagLabel = Instance.new("TextLabel")
        tagLabel.Size = UDim2.new(1, 0, 0, 14)
        tagLabel.Position = UDim2.new(0, 0, 0, yOffset)
        tagLabel.BackgroundTransparency = 1
        tagLabel.Text = scriptTag
        tagLabel.TextColor3 = tagColor
        tagLabel.TextSize = 11
        tagLabel.Font = Enum.Font.GothamBold
        tagLabel.TextStrokeTransparency = 0.3
        tagLabel.Parent = billboard
        table.insert(espObjects, tagLabel)
        yOffset = yOffset + 16
    end
    
    if espShowWeapon then
        local weaponLabel = Instance.new("TextLabel")
        weaponLabel.Size = UDim2.new(1, 0, 0, 14)
        weaponLabel.Position = UDim2.new(0, 0, 0, yOffset)
        weaponLabel.BackgroundTransparency = 1
        if weapon == "赤手空拳" then
            weaponLabel.Text = "赤手空拳"
            weaponLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        else
            weaponLabel.Text = weapon
            weaponLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
        end
        weaponLabel.TextSize = 11
        weaponLabel.Font = Enum.Font.Gotham
        weaponLabel.TextStrokeTransparency = 0.3
        weaponLabel.Parent = billboard
        table.insert(espObjects, weaponLabel)
        yOffset = yOffset + 16
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
        if healthPercent > 0.5 then
            healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        elseif healthPercent > 0.25 then
            healthBar.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        else
            healthBar.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        end
        healthBar.BorderSizePixel = 0
        healthBar.Parent = healthBg
        table.insert(espObjects, healthBar)
        
        local healthLabel = Instance.new("TextLabel")
        healthLabel.Size = UDim2.new(1, 0, 0, 14)
        healthLabel.Position = UDim2.new(0, 0, 0, yOffset + 8)
        healthLabel.BackgroundTransparency = 1
        healthLabel.Text = health .. "/" .. maxHealth
        healthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        healthLabel.TextSize = 10
        healthLabel.Font = Enum.Font.Gotham
        healthLabel.TextStrokeTransparency = 0.3
        healthLabel.Parent = billboard
        table.insert(espObjects, healthLabel)
        yOffset = yOffset + 26
    end
    
    if espShowDist and player ~= LocalPlayer then
        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(1, 0, 0, 12)
        distLabel.Position = UDim2.new(0, 0, 0, yOffset)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = distance .. "m"
        distLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        distLabel.TextSize = 10
        distLabel.Font = Enum.Font.Gotham
        distLabel.Parent = billboard
        table.insert(espObjects, distLabel)
        yOffset = yOffset + 14
    end
    
    if espShowBox then
        local box = Instance.new("BoxHandleAdornment")
        box.Size = Vector3.new(3.5, 5.5, 1.8)
        box.Adornee = rootPart
        box.Color3 = Color3.fromRGB(0, 200, 255)
        box.Transparency = 0.4
        box.ZIndex = 0
        box.AlwaysOnTop = true
        box.Parent = rootPart
        table.insert(espObjects, box)
    end
    
    if espShowBone then
        local boneParts = {"Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg"}
        for _, boneName in ipairs(boneParts) do
            local part = character:FindFirstChild(boneName)
            if part and part:IsA("BasePart") then
                local sphere = Instance.new("SelectionBox")
                sphere.Adornee = part
                sphere.Color3 = Color3.fromRGB(0, 200, 255)
                sphere.LineThickness = 0.06
                sphere.Transparency = 0.2
                sphere.Parent = part
                table.insert(espObjects, sphere)
            end
        end
    end
end

local function UpdateESP()
    ClearESP()
    if not espMasterEnabled then return end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer and espShowSelf then
        else
            CreateESPForPlayer(player)
        end
    end
end

Tab_ESP:Toggle({
    ["Title"] = "透视总开关",
    ["Desc"] = "开启/关闭所有透视功能",
    ["Default"] = false,
    ["Callback"] = function(bool)
        espMasterEnabled = bool
        if bool then
            UpdateESP()
            if not espRenderConnection then
                espRenderConnection = RunService.Heartbeat:Connect(function()
                    if espMasterEnabled then UpdateESP() end
                end)
            end
            Players.PlayerAdded:Connect(function()
                if espMasterEnabled then UpdateESP() end
            end)
            Players.PlayerRemoving:Connect(function()
                if espMasterEnabled then UpdateESP() end
            end)
            for _, player in ipairs(Players:GetPlayers()) do
                player.CharacterAdded:Connect(function()
                    if espMasterEnabled then UpdateESP() end
                end)
            end
        else
            ClearESP()
        end
    end
})

Tab_ESP:Toggle({
    ["Title"] = "绘制名字",
    ["Desc"] = "显示玩家名字",
    ["Default"] = false,
    ["Callback"] = function(bool)
        espShowName = bool
        if espMasterEnabled then UpdateESP() end
    end
})

Tab_ESP:Toggle({
    ["Title"] = "绘制血量",
    ["Desc"] = "显示玩家血量条和数值",
    ["Default"] = false,
    ["Callback"] = function(bool)
        espShowHealth = bool
        if espMasterEnabled then UpdateESP() end
    end
})

Tab_ESP:Toggle({
    ["Title"] = "绘制方框",
    ["Desc"] = "显示玩家方框",
    ["Default"] = false,
    ["Callback"] = function(bool)
        espShowBox = bool
        if espMasterEnabled then UpdateESP() end
    end
})

Tab_ESP:Toggle({
    ["Title"] = "绘制骨骼",
    ["Desc"] = "显示玩家骨骼点",
    ["Default"] = false,
    ["Callback"] = function(bool)
        espShowBone = bool
        if espMasterEnabled then UpdateESP() end
    end
})

Tab_ESP:Toggle({
    ["Title"] = "绘制距离",
    ["Desc"] = "显示与玩家的距离",
    ["Default"] = false,
    ["Callback"] = function(bool)
        espShowDist = bool
        if espMasterEnabled then UpdateESP() end
    end
})

Tab_ESP:Toggle({
    ["Title"] = "同行显示",
    ["Desc"] = "检测并显示玩家使用的脚本（皮脚本/wdfex）",
    ["Default"] = false,
    ["Callback"] = function(bool)
        espShowScriptTag = bool
        if espMasterEnabled then UpdateESP() end
    end
})

Tab_ESP:Toggle({
    ["Title"] = "屏蔽自己",
    ["Desc"] = "开启后自己不显示透视，关闭后自己显示透视",
    ["Default"] = true,
    ["Callback"] = function(bool)
        espShowSelf = bool
        if espMasterEnabled then UpdateESP() end
    end
})

Tab_ESP:Toggle({
    ["Title"] = "显示队伍",
    ["Desc"] = "显示玩家所属队伍",
    ["Default"] = false,
    ["Callback"] = function(bool)
        espShowTeam = bool
        if espMasterEnabled then UpdateESP() end
    end
})

Tab_ESP:Toggle({
    ["Title"] = "绘制手持武器",
    ["Desc"] = "显示玩家手持的武器名称",
    ["Default"] = false,
    ["Callback"] = function(bool)
        espShowWeapon = bool
        if espMasterEnabled then UpdateESP() end
    end
})

Tab_ESP:Toggle({
    ["Title"] = "警察靠近预警",
    ["Desc"] = "警察靠近时在屏幕上方显示警告和距离",
    ["Default"] = false,
    ["Callback"] = function(bool)
        policeAlertEnabled = bool
        if bool then
            CreatePoliceAlert()
            UpdatePoliceAlert()
        else
            if policeAlertGui then
                policeAlertGui:Destroy()
                policeAlertGui = nil
            end
            if policeAlertConnection then
                policeAlertConnection:Disconnect()
                policeAlertConnection = nil
            end
        end
    end
})

-------------------------------------------------------------------------
-- Tab: 甩飞
-------------------------------------------------------------------------
local Tab_Fling = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "甩飞",
    ["Icon"] = "rbxassetid://18520370419",
})

Tab_Fling:Section({
    TextSize = 17,
    ["Title"] = "甩飞功能",
    TextXAlignment = "Left",
})

Tab_Fling:Button({
    ["Title"] = "碰飞",
    ["Desc"] = "点击执行碰飞脚本",
    ["Callback"] = function()
        loadstring(game:HttpGet(('https://gist.githubusercontent.com/axelinharlem182/1ee425c9d850af697f8c3cb108a9d816/raw/c4660b01faf4db266e8031e310121a65836f98a7/The%2520Villain'),true))()
    end
})

-- 防甩飞
local antiFlingEnabled = false
local antiFlingConnection = nil

Tab_Fling:Toggle({
    ["Title"] = "防甩飞",
    ["Desc"] = "防止自己被别人甩飞",
    ["Default"] = false,
    ["Callback"] = function(bool)
        antiFlingEnabled = bool
        if bool then
            if antiFlingConnection then
                antiFlingConnection:Disconnect()
                antiFlingConnection = nil
            end
            antiFlingConnection = RunService.Heartbeat:Connect(function()
                if not antiFlingEnabled then return end
                if not LocalPlayer.Character then return end
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                -- 检测身体上的异常速度，重置
                if hrp.AssemblyLinearVelocity.Magnitude > 100 then
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end
                
                -- 检查是否有 BodyVelocity 被加到自己身上
                for _, child in ipairs(hrp:GetChildren()) do
                    if child:IsA("BodyVelocity") or child:IsA("BodyAngularVelocity") or child:IsA("BodyForce") then
                        child:Destroy()
                    end
                end
                
                -- 检查整个人物上是否有异常力
                for _, child in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if child:IsA("BodyVelocity") or child:IsA("BodyAngularVelocity") or child:IsA("BodyForce") then
                        if child.Parent ~= hrp then
                            child:Destroy()
                        end
                    end
                end
            end)
            Notify("防甩飞已开启")
        else
            if antiFlingConnection then
                antiFlingConnection:Disconnect()
                antiFlingConnection = nil
            end
            Notify("防甩飞已关闭")
        end
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

_G.RangeConn = nil
local function updateRange(size)
    if _G.RangeConn then
        _G.RangeConn:Disconnect()
        _G.RangeConn = nil
    end
    if size == 0 then
        return
    end
    _G.HeadSize = size
    _G.Disabled = true
    _G.RangeConn = RunService.RenderStepped:Connect(function()
        if _G.Disabled then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer then
                    pcall(function()
                        if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                            v.Character.HumanoidRootPart.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                            v.Character.HumanoidRootPart.Transparency = 0.7
                            v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really blue")
                            v.Character.HumanoidRootPart.Material = "Neon"
                            v.Character.HumanoidRootPart.CanCollide = false
                        end
                    end)
                end
            end
        end
    end)
end

Tab_Range:Button({
    ["Title"] = "清空范围效果",
    ["Desc"] = "关闭范围修改",
    ["Callback"] = function()
        updateRange(0)
    end
})

Tab_Range:Button({
    ["Title"] = "范围10",
    ["Desc"] = "设置碰撞箱大小为10",
    ["Callback"] = function()
        updateRange(10)
    end
})

Tab_Range:Button({
    ["Title"] = "范围20",
    ["Desc"] = "设置碰撞箱大小为20",
    ["Callback"] = function()
        updateRange(20)
    end
})

Tab_Range:Button({
    ["Title"] = "范围30",
    ["Desc"] = "设置碰撞箱大小为30",
    ["Callback"] = function()
        updateRange(30)
    end
})

Tab_Range:Button({
    ["Title"] = "范围50",
    ["Desc"] = "设置碰撞箱大小为50",
    ["Callback"] = function()
        updateRange(50)
    end
})

Tab_Range:Button({
    ["Title"] = "范围70",
    ["Desc"] = "设置碰撞箱大小为70",
    ["Callback"] = function()
        updateRange(70)
    end
})

Tab_Range:Button({
    ["Title"] = "范围120",
    ["Desc"] = "设置碰撞箱大小为120",
    ["Callback"] = function()
        updateRange(120)
    end
})

Tab_Range:Button({
    ["Title"] = "范围300",
    ["Desc"] = "设置碰撞箱大小为300",
    ["Callback"] = function()
        updateRange(300)
    end
})

Tab_Range:Button({
    ["Title"] = "范围500",
    ["Desc"] = "设置碰撞箱大小为500",
    ["Callback"] = function()
        updateRange(500)
    end
})

Tab_Range:Button({
    ["Title"] = "范围999",
    ["Desc"] = "设置碰撞箱大小为999",
    ["Callback"] = function()
        updateRange(999)
    end
})

Tab_Range:Button({
    ["Title"] = "范围999999999",
    ["Desc"] = "设置碰撞箱大小为999999999",
    ["Callback"] = function()
        updateRange(999999999)
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
        loadstring(game:HttpGet("https://pastefy.app/YnfF3sje/raw"))()
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
        antiFlingEnabled = false
        if antiFlingConnection then
            antiFlingConnection:Disconnect()
            antiFlingConnection = nil
        end
        if policeAlertGui then
            policeAlertGui:Destroy()
            policeAlertGui = nil
        end
        if policeAlertConnection then
            policeAlertConnection:Disconnect()
            policeAlertConnection = nil
        end
        if _G.RangeConn then
            _G.RangeConn:Disconnect()
            _G.RangeConn = nil
        end
        if espRenderConnection then
            espRenderConnection:Disconnect()
            espRenderConnection = nil
        end
        ClearESP()
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
            TeleportTo(Vector3.new(4402.39, 3.04, 1607.56))
            
            pcall(function()
                local eggGui = Instance.new("ScreenGui")
                eggGui.Name = "EasterEggGui"
                eggGui.Parent = CoreGui
                eggGui.ResetOnSpawn = false
                
                local textLabel = Instance.new("TextLabel")
                textLabel.Name = "EggLabel"
                textLabel.Parent = eggGui
                textLabel.Size = UDim2.new(0, 220, 0, 30)
                textLabel.Position = UDim2.new(1, -230, 1, -40)
                textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                textLabel.BackgroundTransparency = 0.4
                textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                textLabel.TextSize = 16
                textLabel.Font = Enum.Font.GothamBold
                textLabel.Text = "你还想要彩蛋?赶紧去送货吧!"
                textLabel.TextScaled = true
                
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 8)
                corner.Parent = textLabel
            end)
        else
            pcall(function()
                local eggGui = CoreGui:FindFirstChild("EasterEggGui")
                if eggGui then eggGui:Destroy() end
            end)
        end
    end
})

print("wdfex-圣奥里已加载")
print("共26个传送点 + 透视 + 范围 + 自瞄 + 通用 + 售货机 + 帧率优化 + 警察预警 + 甩飞 + 彩色边框 + 欢迎弹窗")