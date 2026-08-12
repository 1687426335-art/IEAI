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
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local CurrentCamera = Workspace.CurrentCamera

-- ===== 服务器已关闭提示 =====
local function ShowServerClosed()
    pcall(function()
        -- 右下角提示
        local notiGui = Instance.new("ScreenGui")
        notiGui.Name = "ServerClosedNoti"
        notiGui.ResetOnSpawn = false
        notiGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        notiGui.Parent = CoreGui
        
        local notiFrame = Instance.new("Frame")
        notiFrame.Size = UDim2.new(0, 280, 0, 50)
        notiFrame.Position = UDim2.new(1, -300, 1, -70)
        notiFrame.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        notiFrame.BackgroundTransparency = 0.15
        notiFrame.BorderSizePixel = 2
        notiFrame.BorderColor3 = Color3.fromRGB(255, 50, 50)
        notiFrame.Parent = notiGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = notiFrame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "服务器已关闭，无法使用此功能"
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 16
        label.Font = Enum.Font.GothamBold
        label.Parent = notiFrame
        
        task.wait(3)
        notiGui:Destroy()
    end)
end

-- ===== 中间红色大字提示 =====
local function ShowServerClosedMain()
    pcall(function()
        local mainGui = Instance.new("ScreenGui")
        mainGui.Name = "ServerClosedMain"
        mainGui.ResetOnSpawn = false
        mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        mainGui.Parent = CoreGui
        
        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        bg.BackgroundTransparency = 0.7
        bg.Parent = mainGui
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 500, 0, 150)
        frame.Position = UDim2.new(0.5, -250, 0.5, -75)
        frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        frame.BackgroundTransparency = 0.05
        frame.BorderSizePixel = 2
        frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
        frame.Parent = mainGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = frame
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 40)
        title.Position = UDim2.new(0, 0, 0, 15)
        title.BackgroundTransparency = 1
        title.Text = "服务器已关闭"
        title.TextColor3 = Color3.fromRGB(255, 0, 0)
        title.TextSize = 28
        title.Font = Enum.Font.GothamBold
        title.Parent = frame
        
        local msg = Instance.new("TextLabel")
        msg.Size = UDim2.new(1, 0, 0, 30)
        msg.Position = UDim2.new(0, 0, 0, 60)
        msg.BackgroundTransparency = 1
        msg.Text = "无法使用此脚本"
        msg.TextColor3 = Color3.fromRGB(255, 200, 200)
        msg.TextSize = 18
        msg.Font = Enum.Font.GothamBold
        msg.Parent = frame
        
        local msg2 = Instance.new("TextLabel")
        msg2.Size = UDim2.new(1, 0, 0, 30)
        msg2.Position = UDim2.new(0, 0, 0, 95)
        msg2.BackgroundTransparency = 1
        msg2.Text = "已停更，原因你们应该也知道，抱歉"
        msg2.TextColor3 = Color3.fromRGB(255, 200, 200)
        msg2.TextSize = 16
        msg2.Font = Enum.Font.Gotham
        msg2.Parent = frame
        
        task.wait(5)
        mainGui:Destroy()
    end)
end

ShowServerClosedMain()

-- ===== 所有功能失效 =====
local function TeleportTo(pos)
    ShowServerClosed()
end

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

Tab_Notice:Section({
    TextSize = 17,
    ["Title"] = "作者: wdfex",
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

Tab_General:Section({
    TextSize = 14,
    ["Title"] = "服务器已关闭，通用功能暂时无法使用",
    TextXAlignment = "Center",
})

-------------------------------------------------------------------------
-- Tab: 地点传送
-------------------------------------------------------------------------
local Tab_LocationTeleport = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "地点传送",
    ["Icon"] = "rbxassetid://18520370419",
})

Tab_LocationTeleport:Section({
    TextSize = 17,
    ["Title"] = "选择传送点",
    TextXAlignment = "Left",
})

Tab_LocationTeleport:Section({
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
-- Tab: 出租车
-------------------------------------------------------------------------
local Tab_Taxi = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "出租车",
    ["Icon"] = "rbxassetid://18520370419",
})

Tab_Taxi:Section({
    TextSize = 17,
    ["Title"] = "出租车功能",
    TextXAlignment = "Left",
})

Tab_Taxi:Section({
    TextSize = 14,
    ["Title"] = "服务器已关闭，出租车功能暂时无法使用",
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
    ["Title"] = "服务器已关闭，标点传送功能暂时无法使用",
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
-- Tab: 车辆功能
-------------------------------------------------------------------------
local Tab_Vehicle = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "车辆功能",
    ["Icon"] = "rbxassetid://18520370419",
})

Tab_Vehicle:Section({
    TextSize = 17,
    ["Title"] = "车辆功能",
    TextXAlignment = "Left",
})

Tab_Vehicle:Section({
    TextSize = 14,
    ["Title"] = "服务器已关闭，车辆功能暂时无法使用",
    TextXAlignment = "Center",
})

-------------------------------------------------------------------------
-- Tab: 枪械功能
-------------------------------------------------------------------------
local Tab_Weapon = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "枪械功能",
    ["Icon"] = "rbxassetid://18520370419",
})

Tab_Weapon:Section({
    TextSize = 17,
    ["Title"] = "枪械功能",
    TextXAlignment = "Left",
})

Tab_Weapon:Section({
    TextSize = 14,
    ["Title"] = "服务器已关闭，枪械功能暂时无法使用",
    TextXAlignment = "Center",
})

-------------------------------------------------------------------------
-- Tab: 警察显示
-------------------------------------------------------------------------
local Tab_Police = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "警察显示",
    ["Icon"] = "rbxassetid://18520370419",
})

Tab_Police:Section({
    TextSize = 17,
    ["Title"] = "警察数量显示",
    TextXAlignment = "Left",
})

Tab_Police:Section({
    TextSize = 14,
    ["Title"] = "服务器已关闭，警察显示功能暂时无法使用",
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
            local eggGui = CoreGui:FindFirstChild("EasterEggGui")
            if eggGui then eggGui:Destroy() end
            local welcomeGui = CoreGui:FindFirstChild("wdfexWelcome")
            if welcomeGui then welcomeGui:Destroy() end
            local borderGui = CoreGui:FindFirstChild("wdfexBorder")
            if borderGui then borderGui:Destroy() end
            local hubGui = CoreGui:FindFirstChild("wdfexHub")
            if hubGui then hubGui:Destroy() end
            local noti = CoreGui:FindFirstChild("ServerClosedNoti")
            if noti then noti:Destroy() end
            local main = CoreGui:FindFirstChild("ServerClosedMain")
            if main then main:Destroy() end
        end)
        Window:Close()
    end
})

print("wdfex-圣奥里已加载")
print("服务器已关闭，所有功能暂时无法使用")