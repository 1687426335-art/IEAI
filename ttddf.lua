-- ===== wdfex 完整版（你的过检测 + 皮脚本UI + 飞天 + 飞车） =====

-- ==================== 你的过检测系统 ====================
local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local Camera = workspace.CurrentCamera

print("🛡️ 启动过检测系统...")

local bypassActive = false
local bypassConnections = {}

local function startBypass()
    if bypassActive then return end
    bypassActive = true
    print("🛡️ 启动过检测系统...")

    -- 1. 拦截踢出
    pcall(function()
        local oldKick = player.Kick
        player.Kick = function(self, msg)
            print("🛡️ 拦截踢出: " .. tostring(msg))
            return nil
        end
        table.insert(bypassConnections, {Disconnect = function()
            player.Kick = oldKick
        end})
    end)

    -- 2. 防死亡
    pcall(function()
        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                local conn = hum.HealthChanged:Connect(function()
                    if hum.Health <= 0 then
                        task.wait(0.1)
                        if hum and hum.Parent then
                            hum.Health = hum.MaxHealth
                            print("🛡️ 反死亡触发")
                        end
                    end
                end)
                table.insert(bypassConnections, conn)
            end
        end
    end)

    -- 3. 防拉回
    pcall(function()
        local function antiTeleport()
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local lastPos = hrp.Position
                    local conn = RunService.Heartbeat:Connect(function()
                        if not hrp or not hrp.Parent then return end
                        if (hrp.Position - lastPos).Magnitude > 100 then
                            hrp.CFrame = CFrame.new(lastPos)
                            print("🛡️ 防拉回触发")
                        end
                        lastPos = hrp.Position
                    end)
                    table.insert(bypassConnections, conn)
                end
            end
        end
        antiTeleport()
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            antiTeleport()
        end)
    end)

    -- 4. 伪装玩家行为
    pcall(function()
        local conn = RunService.Heartbeat:Connect(function()
            if math.random(1, 100) > 95 then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end
        end)
        table.insert(bypassConnections, conn)
    end)

    -- 5. 自动重连
    pcall(function()
        local conn = player:GetPropertyChangedSignal("Parent"):Connect(function()
            if not player.Parent then
                print("🔄 被踢出，重连中...")
                task.wait(2)
                TeleportService:Teleport(game.PlaceId, player)
            end
        end)
        table.insert(bypassConnections, conn)
    end)

    -- 6. 伪装网络数据
    pcall(function()
        local network = game:GetService("NetworkClient")
        if network then
            network:SetOutgoingKBPSLimit(999999)
        end
    end)

    -- 7. 伪装速度数据
    pcall(function()
        local char = player.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local conn = RunService.Heartbeat:Connect(function()
                    if hrp and hrp.Parent then
                        local realVel = hrp.Velocity
                        if realVel.Magnitude > 50 then
                            hrp.Velocity = realVel * 0.3
                            task.wait(0.03)
                            hrp.Velocity = realVel
                        end
                    end
                end)
                table.insert(bypassConnections, conn)
            end
        end
    end)

    -- 8. 防服务器检测
    pcall(function()
        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                local conn = RunService.Heartbeat:Connect(function()
                    if hum and hum.Parent then
                        if hum.WalkSpeed > 100 then
                            hum.WalkSpeed = 16
                            task.wait(0.05)
                            hum.WalkSpeed = 16 * (State and State.Speed or 1)
                        end
                        if hum.WalkSpeed > 16 then
                            hum.WalkSpeed = 16
                        end
                    end
                end)
                table.insert(bypassConnections, conn)
            end
        end
    end)

    -- 9. 伪装玩家信息
    pcall(function()
        local stats = game:GetService("Stats")
        if stats then
            local network = stats:FindFirstChild("Network")
            if network then
                network:SetAttribute("DataSendingEnabled", true)
            end
        end
    end)

    -- 10. 反挂机
    pcall(function()
        player.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end)

    print("✅ 过检测系统已启动 (10层防护)")
end

-- ==================== 启动过检测 ====================
task.wait(0.5)
startBypass()

-- ==================== 通知函数 ====================
local function Notify(text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "wdfex",
            Text = text,
            Icon = "rbxassetid://18941716391",
            Duration = 3,
        })
    end)
end

-- ==================== 皮脚本UI ====================
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/%E7%9A%AE%E8%84%9A%E6%9C%ACUI%E6%BA%90%E7%A0%81.lua"))():new("wdfex")

-- ===== 公告Tab =====
local AnnounceTab = UILibrary:Tab("『公告』", "18930406865")
local AnnounceSection = AnnounceTab:section("🛡️ 系统状态", true)
AnnounceSection:Label("━━━━━━━━━━━━━━━━━━━━")
AnnounceSection:Label("✅ 过检测已启动 (10层防护)")
AnnounceSection:Label("✅ 防踢 | 防死亡 | 防拉回")
AnnounceSection:Label("✅ 防挂机 | 防检测")
AnnounceSection:Label("━━━━━━━━━━━━━━━━━━━━")
AnnounceSection:Label("📢 永久免费 | 禁止倒卖")
AnnounceSection:Label("━━━━━━━━━━━━━━━━━━━━")

-- ===== 飞天Tab（集成本地飞天） =====
local FlyTab = UILibrary:Tab("『飞天』", "18930406865")
local FlySection = FlyTab:section("飞天控制", true)
FlySection:Label("🚀 点击开关开启/关闭飞天")

getgenv().FlyEnabled = false
getgenv().FlySpeed = 50
local flyBV = nil
local flyBG = nil
local flyConn = nil

local function toggleFly()
    getgenv().FlyEnabled = not getgenv().FlyEnabled
    
    if getgenv().FlyEnabled then
        local char = player.Character
        if not char then
            Notify("❌ 没有角色")
            getgenv().FlyEnabled = false
            return
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if not hrp or not hum then
            Notify("❌ 找不到 HumanoidRootPart")
            getgenv().FlyEnabled = false
            return
        end
        
        Notify("✈️ 飞天开启")
        hum.PlatformStand = true
        
        flyBV = Instance.new("BodyVelocity")
        flyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        flyBV.Velocity = Vector3.new(0, 20, 0)
        flyBV.Parent = hrp
        
        flyBG = Instance.new("BodyGyro")
        flyBG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        flyBG.D = 5000
        flyBG.P = 50000
        flyBG.CFrame = Camera.CFrame
        flyBG.Parent = hrp
        
        flyConn = RunService.Heartbeat:Connect(function()
            if not getgenv().FlyEnabled then
                if flyConn then flyConn:Disconnect(); flyConn = nil end
                return
            end
            if not hrp or not hrp.Parent then
                getgenv().FlyEnabled = false
                if flyConn then flyConn:Disconnect(); flyConn = nil end
                return
            end
            if flyBV and flyBG then
                flyBV.Velocity = Camera.CFrame.LookVector * getgenv().FlySpeed
                flyBG.CFrame = Camera.CFrame
            end
        end)
        
    else
        Notify("❌ 飞天关闭")
        if flyBV then flyBV:Destroy(); flyBV = nil end
        if flyBG then flyBG:Destroy(); flyBG = nil end
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.PlatformStand = false
                hum.WalkSpeed = 16
            end
        end
    end
end

FlySection:Toggle("开启飞天", "Fly", false, function(enabled)
    if enabled ~= getgenv().FlyEnabled then
        toggleFly()
    end
end)

FlySection:Slider("飞行速度", "FlySpeed", 50, 10, 200, false, function(s)
    getgenv().FlySpeed = s
end)

FlySection:Button("上升", function()
    pcall(function()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = hrp.CFrame * CFrame.new(0, 5, 0) end
    end)
end)

FlySection:Button("下降", function()
    pcall(function()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = hrp.CFrame * CFrame.new(0, -5, 0) end
    end)
end)

-- ===== 飞车Tab =====
local CarTab = UILibrary:Tab("『飞车』", "18930406865")
local CarSection = CarTab:section("飞车控制", true)
CarSection:Label("🚗 坐上车辆后自动加速")

getgenv().CarSpeed = 80
getgenv().CarAccelEnabled = false

local function GetCurrentVehicle()
    local char = player.Character
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
    Notify(e and "🚗 飞车已开启" or "❌ 飞车已关闭")
end)

CarSection:Slider("飞车速度", "CarSpeed", 80, 20, 300, false, function(s)
    getgenv().CarSpeed = s
end)

-- ===== 设置Tab =====
local SettingsTab = UILibrary:Tab("『设置』", "18930406865")
local SettingsSection = SettingsTab:section("控制", true)
SettingsSection:Button("关闭脚本", function()
    getgenv().FlyEnabled = false
    getgenv().CarAccelEnabled = false
    if flyBV then flyBV:Destroy(); flyBV = nil end
    if flyBG then flyBG:Destroy(); flyBG = nil end
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    pcall(function()
        local frosty = game:GetService("CoreGui"):FindFirstChild("frosty")
        if frosty then frosty:Destroy() end
    end)
end)

Notify("✅ wdfex 已加载")
print("========================================")
print("  ✅ wdfex 加载成功")
print("  🛡️ 10层过检测已启动")
print("  🚀 飞天 | 🚗 飞车")
print("========================================")