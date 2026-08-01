-- ===== wdfex 圣奥里传送（整合叶脚本功能） =====

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- ===== 加载UI库 =====
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
-- Tab: 飞车
-------------------------------------------------------------------------
local Tab_CarFly = Library:Tab("飞车", "6035145364")
local Section_CarFly = Tab_CarFly:section("wdfex飞车", true)

Section_CarFly:Button("wdfex飞车", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/roblox-ye/QQ515966991/refs/heads/main/YE%20FLY%20CAR.lua"))()
end)

Section_CarFly:Label("点击后让车辆飞起来")

-------------------------------------------------------------------------
-- Tab: 透视（ESP）
-------------------------------------------------------------------------
local Tab_ESP = Library:Tab("透视", "7733770689")
local Section_ESP = Tab_ESP:section("wdfex透视", true)

Section_ESP:Button("wdfex玩家ESP", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasfin000/SpaceHub/main/UESP"))()
end)

Section_ESP:Button("wdfex名字显示", function()
    local v1041, v1042, v1043 = pairs(game.Players:GetPlayers())
    local function vu1045(p1044)
        if p1044.Character and p1044.Character:FindFirstChildOfClass("Humanoid") then
            p1044.Character.Humanoid.NameDisplayDistance = 9000000000
            p1044.Character.Humanoid.NameOcclusion = "NoOcclusion"
            p1044.Character.Humanoid.HealthDisplayDistance = 9000000000
            p1044.Character.Humanoid.HealthDisplayType = "AlwaysOn"
            p1044.Character.Humanoid.Health = p1044.Character.Humanoid.Health
        end
    end
    while true do
        local vu1046
        v1043, vu1046 = v1041(v1042, v1043)
        if v1043 == nil then
            break
        end
        vu1045(vu1046)
        vu1046.CharacterAdded:Connect(function()
            task.wait(0.33)
            vu1045(vu1046)
        end)
    end
    game.Players.PlayerAdded:Connect(function(pu1047)
        vu1045(pu1047)
        pu1047.CharacterAdded:Connect(function()
            task.wait(0.33)
            vu1045(pu1047)
        end)
    end)
end)

Section_ESP:Button("wdfex玩家标记", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasfin000/SpaceHub/main/UESP"))()
end)

-------------------------------------------------------------------------
-- Tab: 范围
-------------------------------------------------------------------------
local Tab_Range = Library:Tab("范围", "6035145364")
local Section_Range = Tab_Range:section("wdfex范围", true)

Section_Range:Textbox("wdfex范围大小", "HitBox", "输入数字", function(p233)
    _G.HeadSize = p233
    _G.Disabled = true
    game:GetService("RunService").RenderStepped:connect(function()
        if _G.Disabled then
            local v234 = next
            local v235, v236 = game:GetService("Players"):GetPlayers()
            while true do
                local vu237
                v236, vu237 = v234(v235, v236)
                if v236 == nil then
                    break
                end
                if vu237.Name ~= game:GetService("Players").LocalPlayer.Name then
                    pcall(function()
                        vu237.Character.HumanoidRootPart.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                        vu237.Character.HumanoidRootPart.Transparency = 0.7
                        vu237.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really red")
                        vu237.Character.HumanoidRootPart.Material = "Neon"
                        vu237.Character.HumanoidRootPart.CanCollide = false
                    end)
                end
            end
        end
    end)
end)

Section_Range:Button("wdfex范围10", function()
    _G.HeadSize = 10
    _G.Disabled = true
    game:GetService("RunService").RenderStepped:connect(function()
        if _G.Disabled then
            local v969 = next
            local v970, v971 = game:GetService("Players"):GetPlayers()
            while true do
                local vu972
                v971, vu972 = v969(v970, v971)
                if v971 == nil then
                    break
                end
                if vu972.Name ~= game:GetService("Players").LocalPlayer.Name then
                    pcall(function()
                        vu972.Character.HumanoidRootPart.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                        vu972.Character.HumanoidRootPart.Transparency = 0.7
                        vu972.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really blue")
                        vu972.Character.HumanoidRootPart.Material = "Neon"
                        vu972.Character.HumanoidRootPart.CanCollide = false
                    end)
                end
            end
        end
    end)
end)

Section_Range:Button("wdfex范围30", function()
    _G.HeadSize = 30
    _G.Disabled = true
    game:GetService("RunService").RenderStepped:connect(function()
        if _G.Disabled then
            local v977 = next
            local v978, v979 = game:GetService("Players"):GetPlayers()
            while true do
                local vu980
                v979, vu980 = v977(v978, v979)
                if v979 == nil then
                    break
                end
                if vu980.Name ~= game:GetService("Players").LocalPlayer.Name then
                    pcall(function()
                        vu980.Character.HumanoidRootPart.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                        vu980.Character.HumanoidRootPart.Transparency = 0.7
                        vu980.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really blue")
                        vu980.Character.HumanoidRootPart.Material = "Neon"
                        vu980.Character.HumanoidRootPart.CanCollide = false
                    end)
                end
            end
        end
    end)
end)

Section_Range:Button("wdfex范围50", function()
    _G.HeadSize = 50
    _G.Disabled = true
    game:GetService("RunService").RenderStepped:connect(function()
        if _G.Disabled then
            local v985 = next
            local v986, v987 = game:GetService("Players"):GetPlayers()
            while true do
                local vu988
                v987, vu988 = v985(v986, v987)
                if v987 == nil then
                    break
                end
                if vu988.Name ~= game:GetService("Players").LocalPlayer.Name then
                    pcall(function()
                        vu988.Character.HumanoidRootPart.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                        vu988.Character.HumanoidRootPart.Transparency = 0.7
                        vu988.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really blue")
                        vu988.Character.HumanoidRootPart.Material = "Neon"
                        vu988.Character.HumanoidRootPart.CanCollide = false
                    end)
                end
            end
        end
    end)
end)

Section_Range:Button("wdfex范围100", function()
    _G.HeadSize = 100
    _G.Disabled = true
    game:GetService("RunService").RenderStepped:connect(function()
        if _G.Disabled then
            local v1005 = next
            local v1006, v1007 = game:GetService("Players"):GetPlayers()
            while true do
                local vu1008
                v1007, vu1008 = v1005(v1006, v1007)
                if v1007 == nil then
                    break
                end
                if vu1008.Name ~= game:GetService("Players").LocalPlayer.Name then
                    pcall(function()
                        vu1008.Character.HumanoidRootPart.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                        vu1008.Character.HumanoidRootPart.Transparency = 0.7
                        vu1008.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really blue")
                        vu1008.Character.HumanoidRootPart.Material = "Neon"
                        vu1008.Character.HumanoidRootPart.CanCollide = false
                    end)
                end
            end
        end
    end)
end)

Section_Range:Button("wdfex范围200", function()
    _G.HeadSize = 200
    _G.Disabled = true
    game:GetService("RunService").RenderStepped:connect(function()
        if _G.Disabled then
            local v1013 = next
            local v1014, v1015 = game:GetService("Players"):GetPlayers()
            while true do
                local vu1016
                v1015, vu1016 = v1013(v1014, v1015)
                if v1015 == nil then
                    break
                end
                if vu1016.Name ~= game:GetService("Players").LocalPlayer.Name then
                    pcall(function()
                        vu1016.Character.HumanoidRootPart.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                        vu1016.Character.HumanoidRootPart.Transparency = 0.7
                        vu1016.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really blue")
                        vu1016.Character.HumanoidRootPart.Material = "Neon"
                        vu1016.Character.HumanoidRootPart.CanCollide = false
                    end)
                end
            end
        end
    end)
end)

Section_Range:Button("wdfex关闭范围", function()
    _G.Disabled = false
    Notify("范围已关闭")
end)

-------------------------------------------------------------------------
-- Tab: 设置
-------------------------------------------------------------------------
local Tab_Settings = Library:Tab("设置", "14895392107")
local Section_Settings = Tab_Settings:section("控制", true)

Section_Settings:Button("关闭脚本", function()
    getgenv().EasterEgg = false
    pcall(function()
        local frosty = CoreGui:FindFirstChild("frosty")
        if frosty then frosty:Destroy() end
        local eggGui = CoreGui:FindFirstChild("EasterEggGui")
        if eggGui then eggGui:Destroy() end
        local hubGui = CoreGui:FindFirstChild("wdfexHub")
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
            textLabel.Text = "你还想要彩蛋？赶紧去送货吧！"
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
        Notify("彩蛋已关闭")
    end
end)

print("wdfex 圣奥里传送已加载（含飞车、透视、范围）")
print("共23个传送点 + 飞车 + 透视 + 范围")