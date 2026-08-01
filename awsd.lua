-- ===== wdfex 圣奥里传送脚本（纯传送，无过检测无其他功能） =====

-- ===== 加载UI =====
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/%E7%9A%AE%E8%84%9A%E6%9C%ACUI%E6%BA%90%E7%A0%81.lua"))():new("wdfex 圣奥里传送")

-- ===== 传送函数 =====
local function TeleportTo(pos)
    pcall(function()
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(pos)
            print("✅ 已传送到: " .. tostring(pos))
        end
    end)
end

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

TeleportSection:Button("圣奥里出生点", function()
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

TeleportSection:Button("车店", function()
    TeleportTo(Vector3.new(0, 0, 0))  -- 等你提供坐标
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

TeleportSection:Button("📌 传送到输入坐标", function()
    local x = getgenv().TeleportX or 0
    local y = getgenv().TeleportY or 0
    local z = getgenv().TeleportZ or 0
    TeleportTo(Vector3.new(x, y, z))
end)

-- ===== 设置Tab =====
local SettingsTab = UILibrary:Tab("『设置』", "18930406865")
local SettingsSection = SettingsTab:section("控制", true)
SettingsSection:Button("关闭脚本", function()
    pcall(function()
        local frosty = game:GetService("CoreGui"):FindFirstChild("frosty")
        if frosty then frosty:Destroy() end
    end)
end)

print("✅ wdfex 圣奥里传送已加载")
print("📍 共14个传送点")