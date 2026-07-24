-- ===== 皮脚本 精简版（完整悬浮窗 + 仅飞车） =====

-- 启动通知
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "皮脚本",
    Text = "欢迎使用皮脚本",
    Icon = "rbxassetid://18941716391",
    Duration = 1,
    Button1 = "脚本功能多多",
    Button2 = "感谢您的使用",
})
wait(1.5)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "皮脚本",
    Text = "皮脚本精简版 - 仅保留飞车功能",
    Icon = "rbxassetid://18941716391",
    Duration = 1,
    Button1 = "此脚本是永久免费的",
    Button2 = "请勿倒卖",
})
wait(1.5)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "皮脚本",
    Text = "祝您使用愉快！",
    Icon = "rbxassetid://18941716391",
    Duration = 2,
    Button1 = "玩的开心",
    Button2 = "感谢使用",
})
wait(1.5)

-- 防挂机
local VirtualUserService = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
    VirtualUserService:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUserService:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "皮脚本",
    Text = "已自动开启反挂机",
    Icon = "rbxassetid://18941716391",
    Duration = 2,
    Button1 = "开启成功",
    Button2 = "谢谢使用",
})

-- 加载 Revenant 通知库
local RevenantLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/Revenant", true))()
RevenantLib.DefaultColor = Color3.fromRGB(255, 0, 0)
RevenantLib:Notification({ Text = "皮脚本作者: 小皮", Duration = 3 })
wait(1)
RevenantLib:Notification({ Text = "精简版 - 仅保留飞车功能", Duration = 3 })
wait(1)
RevenantLib:Notification({ Text = "谢谢大家一直以来的支持^ω^", Duration = 3 })

-- ===== 加载悬浮窗UI =====
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/%E7%9A%AE%E8%84%9A%E6%9C%ACUI%E6%BA%90%E7%A0%81.lua"))():new("皮脚本-精简版")

-- ===== 信息 Tab =====
local InfoTab = UILibrary:Tab("『信息』", "18930406865")

local PlayerInfoSection = InfoTab:section("玩家信息", true)
PlayerInfoSection:Label("您的注入器: " .. (identifyexecutor and identifyexecutor() or "未知"))
PlayerInfoSection:Label("您的用户名: " .. game.Players.LocalPlayer.Name)
PlayerInfoSection:Label("您的名称: " .. game.Players.LocalPlayer.DisplayName)
PlayerInfoSection:Label("您当前服务器的ID: " .. game.GameId)
PlayerInfoSection:Label("您的用户ID: " .. game.Players.LocalPlayer.UserId)
pcall(function()
    PlayerInfoSection:Label("您的客户端ID: " .. game:GetService("RbxAnalyticsService"):GetClientId())
end)

local AuthorInfoSection = InfoTab:section("作者信息", true)
AuthorInfoSection:Label("皮脚本 - 精简版")
AuthorInfoSection:Label("作者: 小皮")
AuthorInfoSection:Label("仅保留飞车功能")

local UISettingsSection = InfoTab:section("UI设置", true)
UISettingsSection:Button("关闭脚本", function()
    pcall(function()
        local frosty = game:GetService("CoreGui"):FindFirstChild("frosty")
        if frosty then frosty:Destroy() end
    end)
end)

-- ===== 飞车 Tab =====
local FlyTab = UILibrary:Tab("『飞车』", "18930406865")
local FlySection = FlyTab:section("飞车控制", true)

-- 飞车变量
getgenv().FlyCarSpeed = 50
getgenv().FlyCarEnabled = false
getgenv().FlyCarRunning = false

-- 飞车主循环
local function StartFlyCar()
    if getgenv().FlyCarRunning then return end
    getgenv().FlyCarRunning = true
    task.spawn(function()
        while getgenv().FlyCarRunning do
            if getgenv().FlyCarEnabled then
                pcall(function()
                    local lp = game.Players.LocalPlayer
                    local char = lp and lp.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Anchored = false
                        for _, child in pairs(hrp:GetChildren()) do
                            if child:IsA("BodyVelocity") or child:IsA("BodyGyro") then
                                child:Destroy()
                            end
                        end
                        local bv = Instance.new("BodyVelocity")
                        bv.Parent = hrp
                        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * getgenv().FlyCarSpeed
                        local bg = Instance.new("BodyGyro")
                        bg.Parent = hrp
                        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                        bg.D = 5000
                        bg.P = 50000
                        bg.CFrame = workspace.CurrentCamera.CFrame
                    end
                end)
            end
            task.wait(0.05)
        end
    end)
end

-- 飞车开关
FlySection:Toggle("开启飞车", "FlyToggle", false, function(enabled)
    getgenv().FlyCarEnabled = enabled
    if enabled then
        StartFlyCar()
    else
        getgenv().FlyCarRunning = false
        pcall(function()
            local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, child in pairs(hrp:GetChildren()) do
                    if child:IsA("BodyVelocity") or child:IsA("BodyGyro") then
                        child:Destroy()
                    end
                end
            end
        end)
    end
end)

-- 速度滑块
FlySection:Slider("飞车速度", "Speed", 50, 10, 500, false, function(speed)
    getgenv().FlyCarSpeed = speed
end)

-- 速度加减
FlySection:Button("速度 + 10", function()
    getgenv().FlyCarSpeed = getgenv().FlyCarSpeed + 10
end)

FlySection:Button("速度 - 10", function()
    if getgenv().FlyCarSpeed > 10 then
        getgenv().FlyCarSpeed = getgenv().FlyCarSpeed - 10
    end
end)

-- 上升
FlySection:Button("上升", function()
    pcall(function()
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = hrp.CFrame * CFrame.new(0, 5, 0) end
    end)
end)

-- 下降
FlySection:Button("下降", function()
    pcall(function()
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = hrp.CFrame * CFrame.new(0, -5, 0) end
    end)
end)

-- 当前速度显示
local speedLabel = FlySection:Label("当前速度: " .. tostring(getgenv().FlyCarSpeed))
task.spawn(function()
    while true do
        task.wait(0.3)
        pcall(function()
            if speedLabel and speedLabel.Parent then
                speedLabel.Text = "当前速度: " .. tostring(getgenv().FlyCarSpeed)
            end
        end)
    end
end)

-- ===== 设置 Tab =====
local SettingsTab = UILibrary:Tab("『设置』", "18930406865")
local SettingsSection = SettingsTab:section("控制", true)

SettingsSection:Button("关闭脚本", function()
    getgenv().FlyCarRunning = false
    getgenv().FlyCarEnabled = false
    pcall(function()
        local frosty = game:GetService("CoreGui"):FindFirstChild("frosty")
        if frosty then frosty:Destroy() end
    end)
end)

print("皮脚本精简版加载完成！仅保留飞车功能。")