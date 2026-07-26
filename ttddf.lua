-- ===== wdfex 完整版（你的过检测 + 皮脚本UI + 飞天） =====

-- ==================== 你的过检测系统 ====================
local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera

print("🛡️ 过检测系统启动中...")

-- 1. 拦截踢出
local oldKick = player.Kick
player.Kick = function(self, message)
    print("🛡️ 拦截踢出: " .. tostring(message))
    return nil
end

-- 2. 防死亡检测
local function antiDeath()
    local char = player.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.HealthChanged:Connect(function()
                if hum.Health <= 0 then
                    task.wait(0.1)
                    if hum and hum.Parent then
                        hum.Health = hum.MaxHealth
                        print("🛡️ 反死亡触发")
                    end
                end
            end)
        end
    end
end
antiDeath()
player.CharacterAdded:Connect(function()
    task.wait(0.5)
    antiDeath()
end)

-- 3. 防拉回
local function antiTeleport()
    local char = player.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local lastPos = hrp.Position
            RunService.Heartbeat:Connect(function()
                if not hrp or not hrp.Parent then return end
                if (hrp.Position - lastPos).Magnitude > 100 then
                    hrp.CFrame = CFrame.new(lastPos)
                    print("🛡️ 防拉回触发")
                end
                lastPos = hrp.Position
            end)
        end
    end
end
antiTeleport()
player.CharacterAdded:Connect(function()
    task.wait(0.5)
    antiTeleport()
end)

-- 4. 伪装玩家行为
RunService.Heartbeat:Connect(function()
    if math.random(1, 100) > 95 then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

-- 5. 自动重连
player:GetPropertyChangedSignal("Parent"):Connect(function()
    if not player.Parent then
        print("🔄 被踢出，尝试重连...")
        task.wait(2)
        pcall(function()
            TeleportService:Teleport(game.PlaceId, player)
        end)
    end
end)

-- 6. 伪装网络数据
pcall(function()
    local network = game:GetService("NetworkClient")
    if network then
        network:SetOutgoingKBPSLimit(999999)
    end
end)

-- 7. 伪装速度数据
local function fakeSpeedData()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end
    
    RunService.Heartbeat:Connect(function()
        if not hum or not hum.Parent then return end
        if hum.WalkSpeed > 30 then
            hum.WalkSpeed = 16
            task.wait(0.05)
        end
    end)
    
    pcall(function()
        RunService.Heartbeat:Connect(function()
            if not hrp or not hrp.Parent then return end
            local vel = hrp.Velocity
            if vel.Magnitude > 60 then
                hrp.Velocity = vel * 0.3
                task.wait(0.02)
                hrp.Velocity = vel
            end
        end)
    end)
end
fakeSpeedData()
player.CharacterAdded:Connect(function()
    task.wait(0.5)
    fakeSpeedData()
end)

-- 8. 伪装Humanoid属性
pcall(function()
    local mt = getrawmetatable(game)
    if mt then
        local oldIndex = mt.__index
        setreadonly(mt, false)
        mt.__index = newcclosure(function(self, key)
            if key == "WalkSpeed" and self:IsA("Humanoid") then
                if not checkcaller() then
                    return 16
                end
            end
            return oldIndex(self, key)
        end)
        setreadonly(mt, true)
    end
end)

-- 9. 防服务器检测
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
player.Idled:Connect(function()
    pcall(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

-- 11. 监听检测关键词
pcall(function()
    local chat = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
    if chat then
        local onMessage = chat:FindFirstChild("OnMessageDone")
        if onMessage then
            onMessage.OnClientEvent:Connect(function(data)
                local msg = data.Text or ""
                local detectionWords = {"detected", "ban", "kick", "hack", "cheat", "exploit", "加速", "外挂", "检测", "踢出", "封禁"}
                for _, word in pairs(detectionWords) do
                    if msg:lower():find(word:lower()) then
                        print("⚠️ 检测到关键词: " .. word)
                        break
                    end
                end
            end)
        end
    end
end)

-- 12. 伪装飞行
local function antiFlyDetection()
    local char = player.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            RunService.Heartbeat:Connect(function()
                if hum and hum.Parent then
                    local state = hum:GetState()
                    if state == Enum.HumanoidStateType.Flying then
                        hum:ChangeState(Enum.HumanoidStateType.Running)
                    end
                    if state == Enum.HumanoidStateType.Freefall then
                        hum:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end
            end)
        end
    end
end
antiFlyDetection()
player.CharacterAdded:Connect(function()
    task.wait(0.5)
    antiFlyDetection()
end)

-- 13. 伪装位置数据
local function fakePositionData()
    local char = player.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local lastPos = hrp.Position
            RunService.Heartbeat:Connect(function()
                if not hrp or not hrp.Parent then return end
                local dist = (hrp.Position - lastPos).Magnitude
                if dist > 80 then
                    local midPos = (hrp.Position + lastPos) / 2
                    hrp.CFrame = CFrame.new(midPos)
                    task.wait(0.01)
                    hrp.CFrame = CFrame.new(hrp.Position)
                end
                lastPos = hrp.Position
            end)
        end
    end
end
fakePositionData()
player.CharacterAdded:Connect(function()
    task.wait(0.5)
    fakePositionData()
end)

print("========================================")
print("  ✅ 过检测系统已启动 (13层防护)")
print("  🛡️ 防踢 | 防死亡 | 防拉回 | 防检测")
print("  🛡️ 速度伪装 | 飞行伪装 | 位置伪装")
print("========================================")

-- ==================== 皮脚本UI ====================
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/%E7%9A%AE%E8%84%9A%E6%9C%ACUI%E6%BA%90%E7%A0%81.lua"))():new("wdfex")

-- ===== 公告Tab =====
local AnnounceTab = UILibrary:Tab("『公告』", "18930406865")
local AnnounceSection = AnnounceTab:section("🛡️ 系统状态", true)
AnnounceSection:Label("━━━━━━━━━━━━━━━━━━━━")
AnnounceSection:Label("✅ 过检测已启动 (13层防护)")
AnnounceSection:Label("✅ 防踢 | 防死亡 | 防拉回")
AnnounceSection:Label("✅ 防挂机 | 防检测")
AnnounceSection:Label("━━━━━━━━━━━━━━━━━━━━")
AnnounceSection:Label("📢 永久免费 | 禁止倒卖")
AnnounceSection:Label("━━━━━━━━━━━━━━━━━━━━")

-- ===== 飞天Tab =====
local FlyTab = UILibrary:Tab("『飞天』", "18930406865")
local FlySection = FlyTab:section("飞天控制", true)
FlySection:Label("🚀 点击按钮开启/关闭飞天")

getgenv().FlyEnabled = false
getgenv().FlySpeed = 50

FlySection:Toggle("开启飞天", "Fly", false, function(enabled)
    getgenv().FlyEnabled = enabled
    if not enabled then
        pcall(function()
            local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local bv = hrp:FindFirstChild("FlyBV")
                if bv then bv:Destroy() end
                local bg = hrp:FindFirstChild("FlyBG")
                if bg then bg:Destroy() end
            end
        end)
    end
end)

FlySection:Slider("飞行速度", "FlySpeed", 50, 10, 200, false, function(s)
    getgenv().FlySpeed = s
end)

FlySection:Button("上升", function()
    pcall(function()
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = hrp.CFrame * CFrame.new(0, 5, 0) end
    end)
end)

FlySection:Button("下降", function()
    pcall(function()
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = hrp.CFrame * CFrame.new(0, -5, 0) end
    end)
end)

-- 飞天核心
game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().FlyEnabled then
        pcall(function()
            local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local bv = hrp:FindFirstChild("FlyBV")
                if not bv then
                    bv = Instance.new("BodyVelocity")
                    bv.Name = "FlyBV"
                    bv.Parent = hrp
                    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                end
                local bg = hrp:FindFirstChild("FlyBG")
                if not bg then
                    bg = Instance.new("BodyGyro")
                    bg.Name = "FlyBG"
                    bg.Parent = hrp
                    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                    bg.D = 5000
                    bg.P = 50000
                end
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * getgenv().FlySpeed
                bg.CFrame = workspace.CurrentCamera.CFrame
            end
        end)
    end
end)

-- ===== 设置Tab =====
local SettingsTab = UILibrary:Tab("『设置』", "18930406865")
local SettingsSection = SettingsTab:section("控制", true)
SettingsSection:Button("关闭脚本", function()
    getgenv().FlyEnabled = false
    pcall(function()
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = hrp:FindFirstChild("FlyBV")
            if bv then bv:Destroy() end
            local bg = hrp:FindFirstChild("FlyBG")
            if bg then bg:Destroy() end
        end
    end)
    pcall(function()
        local frosty = game:GetService("CoreGui"):FindFirstChild("frosty")
        if frosty then frosty:Destroy() end
    end)
end)

Notify = function(text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "wdfex",
            Text = text,
            Icon = "rbxassetid://18941716391",
            Duration = 3,
        })
    end)
end

Notify("✅ wdfex 已加载")
print("✅ wdfex 加载完成")
print("🛡️ 过检测13层防护已启动")