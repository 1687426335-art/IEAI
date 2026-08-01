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

-- ===== 传送Tab =====
local TeleportTab = UILibrary:Tab("『传送』", "18930406865")
local TeleportSection = TeleportTab:section("圣奥里传送点", true)

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

-- ===== 自定义传送 =====
TeleportSection:Label("━━━━━━━━━━━━━━━━━━━━")
TeleportSection:Label("自定义坐标传送")

TeleportSection:Textbox("X坐标", "XInput", "输入X", function(x)
    getgenv().TeleportX = tonumber(x) or 0
end)

TeleportSection:Textbox("Y坐标", "YInput", "输入Y", function(y)
    getgenv().TeleportY = tonumber(y) or 0
end)

TeleportSection:Textbox("Z坐标", "ZInput", "输入Z", function(z)
    getgenv().TeleportZ = tonumber(z) or 0
end)

TeleportSection:Button("传送到输入坐标", function()
    local x = getgenv().TeleportX or 0
    local y = getgenv().TeleportY or 0
    local z = getgenv().TeleportZ or 0
    TeleportTo(Vector3.new(x, y, z))
end)

-- ===== 飞车Tab（皮脚本原版飞车） =====
local CarTab = UILibrary:Tab("『飞车』", "18930406865")
local CarSection = CarTab:section("飞车控制", true)

CarSection:Label("坐上车辆后自动加速")

getgenv().CarSpeed = 80
getgenv().CarAccelEnabled = false

local function GetCurrentVehicle()
    local char = game.Players.LocalPlayer.Character
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end
    local seat = hum.SeatPart
    if not seat then return nil end
    local vehicle = seat.Parent
    if vehicle and (vehicle:FindFirstChild("HumanoidRootPart") or vehicle:FindFirstChildOfClass("VehicleSeat")) then
        return vehicle
    end
    return nil
end

game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().CarAccelEnabled then
        pcall(function()
            local vehicle = GetCurrentVehicle()
            if vehicle then
                local hrp = vehicle:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local bv = hrp:FindFirstChild("CarBV")
                    if not bv then
                        bv = Instance.new("BodyVelocity")
                        bv.Name = "CarBV"
                        bv.Parent = hrp
                        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                    end
                    bv.Velocity = hrp.CFrame.LookVector * getgenv().CarSpeed
                end
            end
        end)
    end
end)

CarSection:Toggle("开启飞车", "CarAccel", false, function(e)
    getgenv().CarAccelEnabled = e
    Notify(e and "飞车已开启" or "飞车已关闭")
end)

CarSection:Slider("飞车速度", "CarSpeed", 80, 20, 300, false, function(s)
    getgenv().CarSpeed = s
end)

-- ===== 设置Tab =====
local SettingsTab = UILibrary:Tab("『设置』", "18930406865")
local SettingsSection = SettingsTab:section("控制", true)

SettingsSection:Button("关闭脚本", function()
    getgenv().EasterEgg = false
    getgenv().CarAccelEnabled = false
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
            textLabel.Text = "你还想要彩蛋赶紧去送货吧🤓（把彩蛋关掉即可把你右下角这些字去掉）"
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
print("共20个传送点")