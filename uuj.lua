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

local LocalPlayer = Players.LocalPlayer
local CurrentCamera = Workspace.CurrentCamera

-- ===== 创建彩色边框 =====
local function CreateColorfulBorder()
    pcall(function()
        -- 检查是否已存在边框
        if CoreGui:FindFirstChild("wdfexBorder") then
            CoreGui:FindFirstChild("wdfexBorder"):Destroy()
        end
        
        local borderGui = Instance.new("ScreenGui")
        borderGui.Name = "wdfexBorder"
        borderGui.ResetOnSpawn = false
        borderGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        borderGui.Parent = CoreGui
        
        local colors = {
            Color3.fromRGB(255, 0, 0),   -- 红
            Color3.fromRGB(255, 165, 0), -- 橙
            Color3.fromRGB(255, 255, 0), -- 黄
            Color3.fromRGB(0, 255, 0),   -- 绿
            Color3.fromRGB(0, 0, 255),   -- 蓝
            Color3.fromRGB(255, 0, 255)  -- 紫
        }
        
        local borderSize = 3
        local screenSize = Instance.new("ScreenGui").AbsoluteSize or Vector2.new(1920, 1080)
        
        -- 上边框
        local topBar = Instance.new("Frame")
        topBar.Size = UDim2.new(1, 0, 0, borderSize)
        topBar.Position = UDim2.new(0, 0, 0, 0)
        topBar.BackgroundColor3 = colors[1]
        topBar.BorderSizePixel = 0
        topBar.Parent = borderGui
        
        -- 下边框
        local bottomBar = Instance.new("Frame")
        bottomBar.Size = UDim2.new(1, 0, 0, borderSize)
        bottomBar.Position = UDim2.new(0, 0, 1, -borderSize)
        bottomBar.BackgroundColor3 = colors[4]
        bottomBar.BorderSizePixel = 0
        bottomBar.Parent = borderGui
        
        -- 左边框
        local leftBar = Instance.new("Frame")
        leftBar.Size = UDim2.new(0, borderSize, 1, 0)
        leftBar.Position = UDim2.new(0, 0, 0, 0)
        leftBar.BackgroundColor3 = colors[6]
        leftBar.BorderSizePixel = 0
        leftBar.Parent = borderGui
        
        -- 右边框
        local rightBar = Instance.new("Frame")
        rightBar.Size = UDim2.new(0, borderSize, 1, 0)
        rightBar.Position = UDim2.new(1, -borderSize, 0, 0)
        rightBar.BackgroundColor3 = colors[3]
        rightBar.BorderSizePixel = 0
        rightBar.Parent = borderGui
        
        -- 四角光晕（小方块）
        local cornerSize = 20
        local corners = {
            {pos = UDim2.new(0, 0, 0, 0), color = colors[1]},
            {pos = UDim2.new(1, -cornerSize, 0, 0), color = colors[2]},
            {pos = UDim2.new(0, 0, 1, -cornerSize), color = colors[5]},
            {pos = UDim2.new(1, -cornerSize, 1, -cornerSize), color = colors[4]},
        }
        
        for _, corner in ipairs(corners) do
            local cornerFrame = Instance.new("Frame")
            cornerFrame.Size = UDim2.new(0, cornerSize, 0, cornerSize)
            cornerFrame.Position = corner.pos
            cornerFrame.BackgroundColor3 = corner.color
            cornerFrame.BorderSizePixel = 0
            cornerFrame.Parent = borderGui
        end
        
        -- 渐变光效（彩色流光）
        local glow = Instance.new("Frame")
        glow.Size = UDim2.new(1, 0, 0, 2)
        glow.Position = UDim2.new(0, 0, 0, 0)
        glow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        glow.BackgroundTransparency = 0.7
        glow.BorderSizePixel = 0
        glow.Parent = borderGui
        
        -- 流光动画
        local glowSpeed = 0.02
        local glowPos = 0
        RunService.Heartbeat:Connect(function()
            if not borderGui.Parent then return end
            glowPos = (glowPos + glowSpeed) % 1
            glow.Position = UDim2.new(glowPos, 0, 0, 0)
            -- 动态改变颜色
            local idx = math.floor(glowPos * 6) % 6 + 1
            glow.BackgroundColor3 = colors[idx] or colors[1]
        end)
    end)
end

-- 加载 UI 库
local UI_Library_URL = "https://raw.githubusercontent.com/114514lzkill/ui/refs/heads/main/ui.lua"
local Library = loadstring(game:HttpGet(UI_Library_URL))()

-- 创建窗口
local Window = Library:CreateWindow({
    ["Folder"] = "wdfexHub",
    ["Title"] = "wdfex 圣奥里传送",
    ["Author"] = "wdfex",
    ["Icon"] = "rbxassetid://7734068321",
    HideSearchBar = false,
})

-- 创建彩色边框
CreateColorfulBorder()

-- ===== 通知函数 =====
local function Notify(text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
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
    ["Title"] = "此版本为圣奥里传送脚本",
    TextXAlignment = "Left",
})

Tab_Notice:Section({
    TextSize = 17,
    ["Title"] = "脚本无防踢，需要先执行皮脚本圣奥里",
    TextXAlignment = "Left",
})

Tab_Notice:Section({
    TextSize = 17,
    ["Title"] = "━━━━━━━━━━━━━━━━━━━━",
    TextXAlignment = "Left",
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
    ["Title"] = "非法交易点",
    ["Desc"] = "传送至非法交易点",
    ["Callback"] = function()
        TeleportTo(Vector3.new(2284.16, -16.97, 2652.88))
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
-- Tab: 外卖员工专区
-------------------------------------------------------------------------
local Tab_Worker = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "外卖员工专区",
    ["Icon"] = "rbxassetid://108664063",
})

Tab_Worker:Section({
    TextSize = 17,
    ["Title"] = "功能",
    TextXAlignment = "Left",
})

Tab_Worker:Section({
    TextSize = 15,
    ["Title"] = "━━━━━━━━━━━━━━━━━━━━",
    TextXAlignment = "Left",
})

Tab_Worker:Section({
    TextSize = 15,
    ["Title"] = "外卖员工专用功能",
    TextXAlignment = "Left",
})

Tab_Worker:Section({
    TextSize = 15,
    ["Title"] = "━━━━━━━━━━━━━━━━━━━━",
    TextXAlignment = "Left",
})

Tab_Worker:Section({
    TextSize = 15,
    ["Title"] = "暂无功能，等待更新...",
    TextXAlignment = "Left",
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
        pcall(function()
            local frosty = game:GetService("CoreGui"):FindFirstChild("frosty")
            if frosty then frosty:Destroy() end
            local eggGui = game:GetService("CoreGui"):FindFirstChild("EasterEggGui")
            if eggGui then eggGui:Destroy() end
            local borderGui = game:GetService("CoreGui"):FindFirstChild("wdfexBorder")
            if borderGui then borderGui:Destroy() end
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
            Notify("彩蛋已开启")
            
            pcall(function()
                local eggGui = Instance.new("ScreenGui")
                eggGui.Name = "EasterEggGui"
                eggGui.Parent = game:GetService("CoreGui")
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
                local eggGui = game:GetService("CoreGui"):FindFirstChild("EasterEggGui")
                if eggGui then eggGui:Destroy() end
            end)
            Notify("彩蛋已关闭")
        end
    end
})

print("wdfex 圣奥里传送已加载")
print("共23个传送点 + 彩色边框")