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

-- ===== 服务器关闭提示 =====
local function ServerClosedNotify()
    StarterGui:SetCore("SendNotification", {
        Title = "服务器已关闭",
        Text = "所有功能暂时停止使用，有问题联系作者",
        Duration = 3,
    })
end

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
        label.Text = "欢迎使用 wdfex 脚本"
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

-- ===== 传送函数（已失效） =====
local function TeleportTo(pos)
    ServerClosedNotify()
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
    ["Title"] = "服务器已关闭暂时停止使用，预计下午3点恢复",
    TextXAlignment = "Left",
})

Tab_Notice:Section({
    TextSize = 17,
    ["Title"] = "有问题联系作者",
    TextXAlignment = "Left",
})

Tab_Notice:Section({
    TextSize = 17,
    ["Title"] = "作者快手: wdfex",
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
        ServerClosedNotify()
    end
})

Tab_General:Button({
    ["Title"] = "飞车",
    ["Desc"] = "点击开启皮脚本飞车",
    ["Callback"] = function()
        ServerClosedNotify()
    end
})

Tab_General:Button({
    ["Title"] = "断麦",
    ["Desc"] = "强制断开所有人语音",
    ["Callback"] = function()
        ServerClosedNotify()
    end
})

Tab_General:Textbox({
    ["Title"] = "输入玩家名踢人",
    ["Desc"] = "输入玩家名称然后点击踢人",
    ["Callback"] = function(Value)
        getgenv().kickname = Value
    end
})

Tab_General:Button({
    ["Title"] = "踢人",
    ["Desc"] = "踢出输入的玩家",
    ["Callback"] = function()
        ServerClosedNotify()
    end
})

Tab_General:Button({
    ["Title"] = "踢出所有人",
    ["Desc"] = "踢出服务器内所有玩家",
    ["Callback"] = function()
        ServerClosedNotify()
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
        ServerClosedNotify()
    end
})

Tab_FPS:Toggle({
    ["Title"] = "性能模式",
    ["Desc"] = "降低画质提高帧率",
    ["Default"] = false,
    ["Callback"] = function(bool)
        ServerClosedNotify()
    end
})

Tab_FPS:Button({
    ["Title"] = "优化游戏流畅度",
    ["Desc"] = "一键优化",
    ["Callback"] = function()
        ServerClosedNotify()
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

local teleportPoints = {
    {"枪店门口", Vector3.new(-330.09, 2.63, 24.57)},
    {"枪械商店", Vector3.new(-336.86, -205.07, 61.75)},
    {"黑色市场", Vector3.new(1040.91, -22.73, 899.80)},
    {"小银行", Vector3.new(-667.74, 2.63, -67.18)},
    {"大银行", Vector3.new(3134.64, 6.12, -169.70)},
    {"农场", Vector3.new(-1269.56, 2.57, 2559.51)},
    {"警察局", Vector3.new(3313.52, 3.02, -476.74)},
    {"医院", Vector3.new(3892.10, 3.02, -185.78)},
    {"游戏厅", Vector3.new(2936.71, 2.63, 1688.17)},
    {"超市", Vector3.new(3936.62, 3.04, 1136.92)},
    {"平民出生点", Vector3.new(3741.79, 3.72, -438.95)},
    {"约克镇出生点", Vector3.new(-221.64, 3.04, -84.56)},
    {"躲藏点", Vector3.new(-1505.97, 253.98, -476.43)},
    {"游轮码头", Vector3.new(985.45, -22.53, 1274.22)},
    {"车辆维修", Vector3.new(-409.58, 3.08, 2.80)},
    {"监狱", Vector3.new(-1605.21, 2.63, 1223.50)},
    {"拆车场", Vector3.new(3434.49, 42.93, 2686.46)},
    {"送货队伍", Vector3.new(4402.39, 3.04, 1607.56)},
    {"道路服务", Vector3.new(4275.96, 2.63, 1200.88)},
    {"消防队伍", Vector3.new(3578.02, 8.15, 577.34)},
    {"车店", Vector3.new(0, 0, 0)},
}

for _, point in ipairs(teleportPoints) do
    Tab_Teleport:Button({
        ["Title"] = point[1],
        ["Desc"] = "传送至" .. point[1],
        ["Callback"] = function()
            ServerClosedNotify()
        end
    })
end

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

local vendingPoints = {
    {"警察局售货机", Vector3.new(3375.46, -337.46, -473.67)},
    {"医院售货机", Vector3.new(3939.51, -337.12, -199.84)},
    {"游戏厅售货机", Vector3.new(2904.22, -337.11, 1732.52)},
    {"当铺售货机", Vector3.new(-207.06, -337.05, -99.43)},
}

for _, point in ipairs(vendingPoints) do
    Tab_Vending:Button({
        ["Title"] = point[1],
        ["Desc"] = "传送至" .. point[1],
        ["Callback"] = function()
            ServerClosedNotify()
        end
    })
end

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

local deliveryPoints = {
    {"圣奥里取餐点", Vector3.new(3070.80, 3.02, 451.35)},
    {"莱斯维尔取餐点", Vector3.new(756.54, 3.04, 1006.94)},
    {"北方圣奥里取餐点", Vector3.new(4535.62, 2.60, 915.71)},
}

for _, point in ipairs(deliveryPoints) do
    Tab_Delivery:Button({
        ["Title"] = point[1],
        ["Desc"] = "传送至" .. point[1],
        ["Callback"] = function()
            ServerClosedNotify()
        end
    })
end

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

Tab_ESP:Toggle({
    ["Title"] = "透视总开关",
    ["Desc"] = "开启/关闭所有透视功能",
    ["Default"] = false,
    ["Callback"] = function(bool)
        ServerClosedNotify()
    end
})

Tab_ESP:Toggle({
    ["Title"] = "绘制名字",
    ["Desc"] = "显示玩家名字",
    ["Default"] = false,
    ["Callback"] = function(bool)
        ServerClosedNotify()
    end
})

Tab_ESP:Toggle({
    ["Title"] = "绘制血量",
    ["Desc"] = "显示玩家血量条和数值",
    ["Default"] = false,
    ["Callback"] = function(bool)
        ServerClosedNotify()
    end
})

Tab_ESP:Toggle({
    ["Title"] = "绘制方框",
    ["Desc"] = "显示玩家方框",
    ["Default"] = false,
    ["Callback"] = function(bool)
        ServerClosedNotify()
    end
})

Tab_ESP:Toggle({
    ["Title"] = "绘制骨骼",
    ["Desc"] = "显示玩家骨骼点",
    ["Default"] = false,
    ["Callback"] = function(bool)
        ServerClosedNotify()
    end
})

Tab_ESP:Toggle({
    ["Title"] = "绘制距离",
    ["Desc"] = "显示与玩家的距离",
    ["Default"] = false,
    ["Callback"] = function(bool)
        ServerClosedNotify()
    end
})

Tab_ESP:Toggle({
    ["Title"] = "同行显示",
    ["Desc"] = "检测并显示玩家使用的脚本（皮脚本/wdfex）",
    ["Default"] = false,
    ["Callback"] = function(bool)
        ServerClosedNotify()
    end
})

Tab_ESP:Toggle({
    ["Title"] = "屏蔽自己",
    ["Desc"] = "开启后自己不显示透视，关闭后自己显示透视",
    ["Default"] = true,
    ["Callback"] = function(bool)
        ServerClosedNotify()
    end
})

Tab_ESP:Toggle({
    ["Title"] = "显示队伍",
    ["Desc"] = "显示玩家所属队伍",
    ["Default"] = false,
    ["Callback"] = function(bool)
        ServerClosedNotify()
    end
})

Tab_ESP:Toggle({
    ["Title"] = "绘制手持武器",
    ["Desc"] = "显示玩家手持的武器名称",
    ["Default"] = false,
    ["Callback"] = function(bool)
        ServerClosedNotify()
    end
})

Tab_ESP:Toggle({
    ["Title"] = "警察靠近预警",
    ["Desc"] = "警察靠近时在屏幕上方显示警告和距离",
    ["Default"] = false,
    ["Callback"] = function(bool)
        ServerClosedNotify()
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
        ServerClosedNotify()
    end
})

local antiFlingEnabled = false
local antiFlingConnection = nil

Tab_Fling:Toggle({
    ["Title"] = "防甩飞",
    ["Desc"] = "防止自己被别人甩飞",
    ["Default"] = false,
    ["Callback"] = function(bool)
        ServerClosedNotify()
    end
})

Tab_Fling:Button({
    ["Title"] = "甩飞所有人",
    ["Desc"] = "甩飞服务器内所有玩家",
    ["Callback"] = function()
        ServerClosedNotify()
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
    ServerClosedNotify()
end

Tab_Range:Button({
    ["Title"] = "清空范围效果",
    ["Desc"] = "关闭范围修改",
    ["Callback"] = function()
        ServerClosedNotify()
    end
})

local rangeSizes = {10, 20, 30, 50, 70, 120, 300, 500, 999, 999999999}
for _, size in ipairs(rangeSizes) do
    Tab_Range:Button({
        ["Title"] = "范围" .. size,
        ["Desc"] = "设置碰撞箱大小为" .. size,
        ["Callback"] = function()
            ServerClosedNotify()
        end
    })
end

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
        ServerClosedNotify()
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
        pcall(function()
            local hubGui = CoreGui:FindFirstChild("wdfexHub")
            if hubGui then hubGui:Destroy() end
            local borderGui = CoreGui:FindFirstChild("wdfexBorder")
            if borderGui then borderGui:Destroy() end
            local welcomeGui = CoreGui:FindFirstChild("wdfexWelcome")
            if welcomeGui then welcomeGui:Destroy() end
        end)
        Window:Close()
    end
})

print("wdfex-圣奥里已加载（服务器已关闭，所有功能已停用）")