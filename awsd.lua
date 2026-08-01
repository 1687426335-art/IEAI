-- ===== wdfex 圣奥里传送脚本 =====

-- ===== 加载UI =====
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/%E7%9A%AE%E8%84%9A%E6%9C%ACUI%E6%BA%90%E7%A0%81.lua"))():new("wdfex 圣奥里传送")

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
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(pos)
        end
    end)
end

-- ===== ATM透视标记 =====
local atmMarkers = {}
local atm透视开关 = false

local function ToggleATMPerspective()
    atm透视开关 = not atm透视开关
    
    if atm透视开关 then
        pcall(function()
            local player = game.Players.LocalPlayer
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then
                Notify("未找到角色")
                return
            end

            for _, marker in ipairs(atmMarkers) do
                pcall(function() marker:Destroy() end)
            end
            atmMarkers = {}

            local found = 0
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Position then
                    local name = obj.Name:lower()
                    if name:find("atm") or name:find("bank") or name:find("cash") or name:find("money") or name:find("取款") or name:find("柜员") then
                        local dist = (hrp.Position - obj.Position).Magnitude
                        if dist < 500 then
                            local marker = Instance.new("Part")
                            marker.Size = Vector3.new(1.5, 1.5, 1.5)
                            marker.Shape = Enum.PartType.Ball
                            marker.Position = obj.Position + Vector3.new(0, 2, 0)
                            marker.Anchored = true
                            marker.CanCollide = false
                            marker.Transparency = 0.3
                            marker.BrickColor = BrickColor.new("Bright green")
                            marker.Name = "ATMPerspective"
                            marker.Parent = workspace

                            local box = Instance.new("SelectionBox")
                            box.Adornee = marker
                            box.Color3 = Color3.fromRGB(0, 255, 0)
                            box.LineThickness = 0.15
                            box.Transparency = 0.3
                            box.Parent = marker

                            local billboard = Instance.new("BillboardGui")
                            billboard.Size = UDim2.new(0, 120, 0, 30)
                            billboard.StudsOffset = Vector3.new(0, 3, 0)
                            billboard.AlwaysOnTop = true
                            billboard.Parent = marker

                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.TextColor3 = Color3.fromRGB(0, 255, 0)
                            label.TextStrokeTransparency = 0.3
                            label.Text = string.format("ATM [%.1fm]", dist)
                            label.TextSize = 14
                            label.Font = Enum.Font.GothamBold
                            label.Parent = billboard

                            table.insert(atmMarkers, marker)
                            found = found + 1
                        end
                    end
                end
            end

            Notify("ATM透视开启，找到 " .. found .. " 个")
        end)
    else
        for _, marker in ipairs(atmMarkers) do
            pcall(function() marker:Destroy() end)
        end
        atmMarkers = {}
        Notify("ATM透视已关闭")
    end
end

-- ===== 键盘快捷键 =====
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.P then
        ToggleATMPerspective()
    end
end)

-- ===== 公告Tab =====
local AnnounceTab = UILibrary:Tab("『公告』", "18930406865")
local AnnounceSection = AnnounceTab:section("公告", true)

AnnounceSection:Label("━━━━━━━━━━━━━━━━━━━━")
AnnounceSection:Label("作者: wdfex")
AnnounceSection:Label("━━━━━━━━━━━━━━━━━━━━")
AnnounceSection:Label("此版本为圣奥里传送脚本")
AnnounceSection:Label("━━━━━━━━━━━━━━━━━━━━")
AnnounceSection:Label("本脚本悬浮窗UI由皮脚本作者提供")
AnnounceSection:Label("━━━━━━━━━━━━━━━━━━━━")
AnnounceSection:Label("脚本无防踢")
AnnounceSection:Label("需要先执行皮脚本圣奥里再执行本脚本")
AnnounceSection:Label("否则概率被踢出")
AnnounceSection:Label("━━━━━━━━━━━━━━━━━━━━")

-- ===== 实用传送Tab =====
local TeleportTab = UILibrary:Tab("『实用传送』", "18930406865")
local TeleportSection = TeleportTab:section("实用传送点", true)

TeleportSection:Button("枪店门口", function()
    TeleportTo(Vector3.new(-330.09, 2.63, 24.57))
end)

TeleportSection:Button("枪械商店", function()
    TeleportTo(Vector3.new(-336.86, -205.07, 61.75))
end)

TeleportSection:Button("黑色市场", function()
    TeleportTo(Vector3.new(1040.91, -22.73, 899.80))
end)

TeleportSection:Button("小银行", function()
    TeleportTo(Vector3.new(-667.74, 2.63, -67.18))
end)

TeleportSection:Button("大银行", function()
    TeleportTo(Vector3.new(3134.64, 6.12, -169.70))
end)

TeleportSection:Button("农场", function()
    TeleportTo(Vector3.new(-1269.56, 2.57, 2559.51))
end)

TeleportSection:Button("警察局", function()
    TeleportTo(Vector3.new(3313.52, 3.02, -476.74))
end)

TeleportSection:Button("医院", function()
    TeleportTo(Vector3.new(3892.10, 3.02, -185.78))
end)

TeleportSection:Button("游戏厅", function()
    TeleportTo(Vector3.new(2936.71, 2.63, 1688.17))
end)

TeleportSection:Button("超市", function()
    TeleportTo(Vector3.new(3936.62, 3.04, 1136.92))
end)

TeleportSection:Button("平民出生点", function()
    TeleportTo(Vector3.new(3741.79, 3.72, -438.95))
end)

TeleportSection:Button("约克镇出生点", function()
    TeleportTo(Vector3.new(-221.64, 3.04, -84.56))
end)

TeleportSection:Button("躲藏点", function()
    TeleportTo(Vector3.new(-1505.97, 253.98, -476.43))
end)

TeleportSection:Button("游轮码头", function()
    TeleportTo(Vector3.new(985.45, -22.53, 1274.22))
end)

TeleportSection:Button("车辆维修", function()
    TeleportTo(Vector3.new(-409.58, 3.08, 2.80))
end)

TeleportSection:Button("监狱", function()
    TeleportTo(Vector3.new(-1605.21, 2.63, 1223.50))
end)

TeleportSection:Button("拆车场", function()
    TeleportTo(Vector3.new(3434.49, 42.93, 2686.46))
end)

TeleportSection:Button("非法交易点", function()
    TeleportTo(Vector3.new(2284.16, -16.97, 2652.88))
end)

TeleportSection:Button("送货队伍", function()
    TeleportTo(Vector3.new(4402.39, 3.04, 1607.56))
end)

TeleportSection:Button("道路服务", function()
    TeleportTo(Vector3.new(4275.96, 2.63, 1200.88))
end)

TeleportSection:Button("消防队伍", function()
    TeleportTo(Vector3.new(3578.02, 8.15, 577.34))
end)

TeleportSection:Button("车店", function()
    TeleportTo(Vector3.new(0, 0, 0))
end)

-- ===== 外卖员传送Tab（取餐点） =====
local DeliveryTab = UILibrary:Tab("『外卖员』", "18930406865")
local DeliverySection = DeliveryTab:section("外卖员传送点", true)

DeliverySection:Button("圣奥里取餐点", function()
    TeleportTo(Vector3.new(3070.80, 3.02, 451.35))
end)

DeliverySection:Button("莱斯维尔取餐点", function()
    TeleportTo(Vector3.new(756.54, 3.04, 1006.94))
end)

DeliverySection:Button("北方圣奥里取餐点", function()
    TeleportTo(Vector3.new(4535.62, 2.60, 915.71))
end)

-- ===== ATM透视Tab =====
local AtmTab = UILibrary:Tab("『ATM透视』", "18930406865")
local AtmSection = AtmTab:section("ATM透视", true)

AtmSection:Label("━━━━━━━━━━━━━━━━━━━━")
AtmSection:Label("按 P 键开启/关闭ATM透视")
AtmSection:Label("透视范围：500米")
AtmSection:Label("━━━━━━━━━━━━━━━━━━━━")

AtmSection:Toggle("ATM透视开关", "ATMPerspective", false, function(enabled)
    if enabled then
        if not atm透视开关 then
            ToggleATMPerspective()
        end
    else
        if atm透视开关 then
            ToggleATMPerspective()
        end
    end
end)

AtmSection:Label("开启后ATM机会显示绿色球体+距离标签")

-- ===== 外卖员工功能专区Tab =====
local WorkerTab = UILibrary:Tab("『外卖员工专区』", "18930406865")
local WorkerSection = WorkerTab:section("功能", true)

WorkerSection:Label("━━━━━━━━━━━━━━━━━━━━")
WorkerSection:Label("外卖员工专用功能")
WorkerSection:Label("━━━━━━━━━━━━━━━━━━━━")

WorkerSection:Label("暂无功能，等待更新...")

-- ===== 设置Tab =====
local SettingsTab = UILibrary:Tab("『设置』", "18930406865")
local SettingsSection = SettingsTab:section("控制", true)

SettingsSection:Button("关闭脚本", function()
    getgenv().EasterEgg = false
    pcall(function()
        local frosty = game:GetService("CoreGui"):FindFirstChild("frosty")
        if frosty then frosty:Destroy() end
        local eggGui = game:GetService("CoreGui"):FindFirstChild("EasterEggGui")
        if eggGui then eggGui:Destroy() end
    end)
end)

-- ===== 彩蛋开关 =====
SettingsSection:Toggle("彩蛋开关", "EasterEgg", false, function(enabled)
    getgenv().EasterEgg = enabled
    
    if enabled then
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
end)

print("wdfex 圣奥里传送脚本已加载")
print("共24个传送点 + ATM透视（按P键）")