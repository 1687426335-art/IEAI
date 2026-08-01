-- ===== wdfex 圣奥里传送（叶脚本UI风格） =====

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer

-- ===== 加载叶脚本UI库 =====
local UI_Library_URL = "https://raw.githubusercontent.com/roblox-ye/QQ515966991/refs/heads/main/66YEUIUI.txt"
local Library = loadstring(game:HttpGet(UI_Library_URL))():new("wdfex 圣奥里传送 " .. identifyexecutor())

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

-------------------------------------------------------------------------
-- Tab: 公告
-------------------------------------------------------------------------
local Tab_Notice = Library:Tab("公告", "115466270141583")
local Section_Notice = Tab_Notice:section("公告", true)

Section_Notice:Label("━━━━━━━━━━━━━━━━━━━━")
Section_Notice:Label("作者: wdfex")
Section_Notice:Label("━━━━━━━━━━━━━━━━━━━━")
Section_Notice:Label("此版本为圣奥里传送脚本")
Section_Notice:Label("━━━━━━━━━━━━━━━━━━━━")
Section_Notice:Label("脚本无防踢，需要先执行皮脚本圣奥里")
Section_Notice:Label("否则概率被踢出")
Section_Notice:Label("━━━━━━━━━━━━━━━━━━━━")

-------------------------------------------------------------------------
-- Tab: 实用传送
-------------------------------------------------------------------------
local Tab_Teleport = Library:Tab("实用传送", "18520370419")
local Section_Teleport = Tab_Teleport:section("实用传送点", true)

Section_Teleport:Button("枪店门口", function()
    TeleportTo(Vector3.new(-330.09, 2.63, 24.57))
end)

Section_Teleport:Button("枪械商店", function()
    TeleportTo(Vector3.new(-336.86, -205.07, 61.75))
end)

Section_Teleport:Button("黑色市场", function()
    TeleportTo(Vector3.new(1040.91, -22.73, 899.80))
end)

Section_Teleport:Button("小银行", function()
    TeleportTo(Vector3.new(-667.74, 2.63, -67.18))
end)

Section_Teleport:Button("大银行", function()
    TeleportTo(Vector3.new(3134.64, 6.12, -169.70))
end)

Section_Teleport:Button("农场", function()
    TeleportTo(Vector3.new(-1269.56, 2.57, 2559.51))
end)

Section_Teleport:Button("警察局", function()
    TeleportTo(Vector3.new(3313.52, 3.02, -476.74))
end)

Section_Teleport:Button("医院", function()
    TeleportTo(Vector3.new(3892.10, 3.02, -185.78))
end)

Section_Teleport:Button("游戏厅", function()
    TeleportTo(Vector3.new(2936.71, 2.63, 1688.17))
end)

Section_Teleport:Button("超市", function()
    TeleportTo(Vector3.new(3936.62, 3.04, 1136.92))
end)

Section_Teleport:Button("平民出生点", function()
    TeleportTo(Vector3.new(3741.79, 3.72, -438.95))
end)

Section_Teleport:Button("约克镇出生点", function()
    TeleportTo(Vector3.new(-221.64, 3.04, -84.56))
end)

Section_Teleport:Button("躲藏点", function()
    TeleportTo(Vector3.new(-1505.97, 253.98, -476.43))
end)

Section_Teleport:Button("游轮码头", function()
    TeleportTo(Vector3.new(985.45, -22.53, 1274.22))
end)

Section_Teleport:Button("车辆维修", function()
    TeleportTo(Vector3.new(-409.58, 3.08, 2.80))
end)

Section_Teleport:Button("监狱", function()
    TeleportTo(Vector3.new(-1605.21, 2.63, 1223.50))
end)

Section_Teleport:Button("拆车场", function()
    TeleportTo(Vector3.new(3434.49, 42.93, 2686.46))
end)

Section_Teleport:Button("非法交易点", function()
    TeleportTo(Vector3.new(2284.16, -16.97, 2652.88))
end)

Section_Teleport:Button("送货队伍", function()
    TeleportTo(Vector3.new(4402.39, 3.04, 1607.56))
end)

Section_Teleport:Button("道路服务", function()
    TeleportTo(Vector3.new(4275.96, 2.63, 1200.88))
end)

Section_Teleport:Button("消防队伍", function()
    TeleportTo(Vector3.new(3578.02, 8.15, 577.34))
end)

Section_Teleport:Button("车店", function()
    TeleportTo(Vector3.new(0, 0, 0))
end)

-------------------------------------------------------------------------
-- Tab: 外卖员
-------------------------------------------------------------------------
local Tab_Delivery = Library:Tab("外卖员", "15440802720")
local Section_Delivery = Tab_Delivery:section("外卖员传送点", true)

Section_Delivery:Button("圣奥里取餐点", function()
    TeleportTo(Vector3.new(3070.80, 3.02, 451.35))
end)

Section_Delivery:Button("莱斯维尔取餐点", function()
    TeleportTo(Vector3.new(756.54, 3.04, 1006.94))
end)

Section_Delivery:Button("北方圣奥里取餐点", function()
    TeleportTo(Vector3.new(4535.62, 2.60, 915.71))
end)

-------------------------------------------------------------------------
-- Tab: 外卖员工专区
-------------------------------------------------------------------------
local Tab_Worker = Library:Tab("外卖员工专区", "108664063")
local Section_Worker = Tab_Worker:section("功能", true)

Section_Worker:Label("━━━━━━━━━━━━━━━━━━━━")
Section_Worker:Label("外卖员工专用功能")
Section_Worker:Label("━━━━━━━━━━━━━━━━━━━━")
Section_Worker:Label("暂无功能，等待更新...")

-------------------------------------------------------------------------
-- Tab: 设置
-------------------------------------------------------------------------
local Tab_Settings = Library:Tab("设置", "14895392107")
local Section_Settings = Tab_Settings:section("控制", true)

Section_Settings:Button("关闭脚本", function()
    getgenv().EasterEgg = false
    pcall(function()
        local frosty = game:GetService("CoreGui"):FindFirstChild("frosty")
        if frosty then frosty:Destroy() end
        local eggGui = game:GetService("CoreGui"):FindFirstChild("EasterEggGui")
        if eggGui then eggGui:Destroy() end
        local hubGui = game:GetService("CoreGui"):FindFirstChild("wdfexHub")
        if hubGui then hubGui:Destroy() end
    end)
    Library:Close()
end)

local easterEggEnabled = false
Section_Settings:Toggle("彩蛋开关", "开启彩蛋功能", false, function(bool)
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
            textLabel.Text = "你还想要彩蛋？赶紧去送货吧！"
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
end)

print("wdfex 圣奥里传送已加载（叶脚本UI风格）")
print("共23个传送点")