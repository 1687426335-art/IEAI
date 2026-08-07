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

-- ===== 右下角提示 =====
local function ShowServerClosed()
    pcall(function()
        local gui = Instance.new("ScreenGui")
        gui.Name = "ServerClosedNotice"
        gui.ResetOnSpawn = false
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.Parent = CoreGui
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 280, 0, 50)
        frame.Position = UDim2.new(1, -300, 1, -70)
        frame.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        frame.BackgroundTransparency = 0.15
        frame.BorderSizePixel = 2
        frame.BorderColor3 = Color3.fromRGB(255, 50, 50)
        frame.Parent = gui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "服务器已关闭"
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 16
        label.Font = Enum.Font.GothamBold
        label.Parent = frame
        
        task.wait(3)
        gui:Destroy()
    end)
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
    ShowServerClosed()
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
    ["Title"] = "服务器已关闭，所有功能暂时无法使用",
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

Tab_General:Section({
    TextSize = 14,
    ["Title"] = "服务器已关闭，通用功能暂时无法使用",
    TextXAlignment = "Center",
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

Tab_Teleport:Section({
    TextSize = 14,
    ["Title"] = "服务器已关闭，传送功能暂时无法使用",
    TextXAlignment = "Center",
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

Tab_Vending:Section({
    TextSize = 14,
    ["Title"] = "服务器已关闭，传送功能暂时无法使用",
    TextXAlignment = "Center",
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

Tab_Delivery:Section({
    TextSize = 14,
    ["Title"] = "服务器已关闭，传送功能暂时无法使用",
    TextXAlignment = "Center",
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

Tab_ESP:Section({
    TextSize = 14,
    ["Title"] = "服务器已关闭，透视功能暂时无法使用",
    TextXAlignment = "Center",
})

-------------------------------------------------------------------------
-- Tab: 标点传送
-------------------------------------------------------------------------
local Tab_Waypoint = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "标点传送",
    ["Icon"] = "rbxassetid://18520370419",
})

Tab_Waypoint:Section({
    TextSize = 17,
    ["Title"] = "地图标点传送",
    TextXAlignment = "Left",
})

Tab_Waypoint:Section({
    TextSize = 14,
    ["Title"] = "服务器已关闭，标点传送暂时无法使用",
    TextXAlignment = "Center",
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

Tab_Fling:Section({
    TextSize = 14,
    ["Title"] = "服务器已关闭，甩飞功能暂时无法使用",
    TextXAlignment = "Center",
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

Tab_Range:Section({
    TextSize = 14,
    ["Title"] = "服务器已关闭，范围功能暂时无法使用",
    TextXAlignment = "Center",
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

Tab_Aimbot:Section({
    TextSize = 14,
    ["Title"] = "服务器已关闭，自瞄功能暂时无法使用",
    TextXAlignment = "Center",
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
            local frosty = CoreGui:FindFirstChild("frosty")
            if frosty then frosty:Destroy() end
            local welcomeGui = CoreGui:FindFirstChild("wdfexWelcome")
            if welcomeGui then welcomeGui:Destroy() end
            local borderGui = CoreGui:FindFirstChild("wdfexBorder")
            if borderGui then borderGui:Destroy() end
            local hubGui = CoreGui:FindFirstChild("wdfexHub")
            if hubGui then hubGui:Destroy() end
            local notice = CoreGui:FindFirstChild("ServerClosedNotice")
            if notice then notice:Destroy() end
        end)
        Window:Close()
    end
})

print("wdfex-圣奥里已加载")
print("服务器已关闭，所有功能暂时无法使用")