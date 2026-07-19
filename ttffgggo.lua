-- ========== wdfex 独立防封脚本 V2（加强版） ==========
-- 作用：在执行其他脚本前运行，提供基础伪装和防护
-- 新增：伪装人物速度 + 飞天过检测

local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local HttpService = game:GetService("HttpService")

print("🛡️ 正在启动防封系统 V2...")

-- ==================== 1. 拦截踢出 ====================
local oldKick = player.Kick
player.Kick = function(self, message)
    print("🛡️ 拦截到踢出请求: " .. tostring(message))
    return nil
end

-- ==================== 2. 防死亡检测 ====================
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

-- ==================== 3. 防拉回（位置修正） ====================
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

-- ==================== 4. 伪装玩家行为（防AFK和检测） ====================
RunService.Heartbeat:Connect(function()
    if math.random(1, 100) > 95 then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

-- ==================== 5. 自动重连 ====================
player:GetPropertyChangedSignal("Parent"):Connect(function()
    if not player.Parent then
        print("🔄 被踢出，尝试重连...")
        task.wait(2)
        pcall(function()
            TeleportService:Teleport(game.PlaceId, player)
        end)
    end
end)

-- ==================== 6. 伪装网络数据 ====================
pcall(function()
    local network = game:GetService("NetworkClient")
    if network then
        network:SetOutgoingKBPSLimit(999999)
    end
end)

-- ==================== 7. 伪装人物速度（新增核心功能） ====================
local fakeSpeed = 16
local realSpeed = 16
local speedDetectionEnabled = true

local function fakeSpeedData()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end

    -- 方法1: 伪装Humanoid速度属性
    local originalWalkSpeed = hum.WalkSpeed
    local originalJumpPower = hum.JumpPower

    RunService.Heartbeat:Connect(function()
        if not speedDetectionEnabled then return end
        if not hum or not hum.Parent then return end
        
        -- 如果速度被修改，立即恢复伪装
        if hum.WalkSpeed ~= originalWalkSpeed and hum.WalkSpeed > 100 then
            hum.WalkSpeed = originalWalkSpeed
        end
        
        -- 伪造成正常玩家速度
        if hum.WalkSpeed > 16 then
            hum.WalkSpeed = 16
            task.wait(0.01)
        end
    end)

    -- 方法2: 伪装速度数据包（拦截网络上报）
    pcall(function()
        local oldGetVelocity = hrp.Velocity
        RunService.Heartbeat:Connect(function()
            if not speedDetectionEnabled then return end
            if not hrp or not hrp.Parent then return end
            
            -- 让服务器看到的速度减半
            local currentVel = hrp.Velocity
            if currentVel.Magnitude > 50 then
                -- 上报速度伪装
                hrp.Velocity = currentVel * 0.3
                task.wait(0.01)
                hrp.Velocity = currentVel
            end
        end)
    end)

    -- 方法3: 伪造移动记录
    pcall(function()
        local lastReportedPos = hrp.Position
        RunService.Heartbeat:Connect(function()
            if not speedDetectionEnabled then return end
            if not hrp or not hrp.Parent then return end
            
            -- 如果移动距离过大，伪造路径
            local dist = (hrp.Position - lastReportedPos).Magnitude
            if dist > 50 then
                -- 插入中间点，看起来像正常移动
                local midPoint = (hrp.Position + lastReportedPos) / 2
                hrp.CFrame = CFrame.new(midPoint)
                task.wait(0.01)
                hrp.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 0, 0))
            end
            lastReportedPos = hrp.Position
        end)
    end)
end

-- 启动速度伪装
fakeSpeedData()
player.CharacterAdded:Connect(function()
    task.wait(0.5)
    fakeSpeedData()
end)

-- ==================== 8. 飞天过检测（新增核心功能） ====================
local flyBypassEnabled = false
local flyBypassConn = nil
local flyBodyVelocity = nil
local flyBodyGyro = nil
local flyOriginalState = nil

local function startFlyBypass()
    if flyBypassEnabled then return end
    flyBypassEnabled = true
    
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end
    
    print("✈️ 飞天过检测已启动")
    
    -- 保存原始状态
    flyOriginalState = {
        platformStand = hum.PlatformStand,
        walkSpeed = hum.WalkSpeed,
    }
    
    -- 启用飞行状态但伪装成正常
    hum.PlatformStand = true
    
    -- 使用BodyVelocity实现飞行，但伪装成正常移动
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent = hrp
    
    -- 稳定陀螺仪
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    flyBodyGyro.D = 5000
    flyBodyGyro.P = 50000
    flyBodyGyro.CFrame = hrp.CFrame
    flyBodyGyro.Parent = hrp
    
    -- 速度伪装：飞行时伪造速度数据
    local moveDir = Vector3.new(0, 0, 0)
    local flySpeed = 50
    
    -- 按键监听
    local keyBegan = UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.W then moveDir = moveDir + Vector3.new(0, 0, -1) end
        if input.KeyCode == Enum.KeyCode.S then moveDir = moveDir + Vector3.new(0, 0, 1) end
        if input.KeyCode == Enum.KeyCode.A then moveDir = moveDir + Vector3.new(-1, 0, 0) end
        if input.KeyCode == Enum.KeyCode.D then moveDir = moveDir + Vector3.new(1, 0, 0) end
        if input.KeyCode == Enum.KeyCode.Space then moveDir = Vector3.new(0, 1, 0) end
        if input.KeyCode == Enum.KeyCode.LeftShift then moveDir = Vector3.new(0, -1, 0) end
    end)
    
    local keyEnded = UserInputService.InputEnded:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.W then moveDir = moveDir - Vector3.new(0, 0, -1) end
        if input.KeyCode == Enum.KeyCode.S then moveDir = moveDir - Vector3.new(0, 0, 1) end
        if input.KeyCode == Enum.KeyCode.A then moveDir = moveDir - Vector3.new(-1, 0, 0) end
        if input.KeyCode == Enum.KeyCode.D then moveDir = moveDir - Vector3.new(1, 0, 0) end
        if input.KeyCode == Enum.KeyCode.Space then moveDir = Vector3.new(0, 0, 0) end
        if input.KeyCode == Enum.KeyCode.LeftShift then moveDir = Vector3.new(0, 0, 0) end
    end)
    
    -- 飞控循环 + 速度伪装
    flyBypassConn = RunService.Heartbeat:Connect(function()
        if not flyBypassEnabled then
            if flyBypassConn then flyBypassConn:Disconnect(); flyBypassConn = nil end
            keyBegan:Disconnect()
            keyEnded:Disconnect()
            return
        end
        if not hrp or not hrp.Parent then
            flyBypassEnabled = false
            return
        end
        
        -- 计算移动方向
        local look = hrp.CFrame.LookVector
        local right = hrp.CFrame.RightVector
        local up = hrp.CFrame.UpVector
        
        local mv = Vector3.new(0, 0, 0)
        mv = mv + look * (-moveDir.Z) * flySpeed
        mv = mv + right * moveDir.X * flySpeed
        mv = mv + up * moveDir.Y * flySpeed
        
        if mv.Magnitude > 0 then
            flyBodyVelocity.Velocity = mv
            -- 伪装速度数据（让服务器看到的速度减半）
            hrp.Velocity = mv * 0.3
            task.wait(0.01)
            hrp.Velocity = mv
        else
            flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
        
        -- 稳定陀螺仪
        flyBodyGyro.CFrame = hrp.CFrame
    end)
    
    -- 防检测：每秒伪装一次速度
    RunService.Heartbeat:Connect(function()
        if not flyBypassEnabled then return end
        if hum then
            -- 伪造成正常行走速度
            if hum.WalkSpeed > 16 then
                hum.WalkSpeed = 16
            end
        end
    end)
end

local function stopFlyBypass()
    flyBypassEnabled = false
    if flyBypassConn then
        flyBypassConn:Disconnect()
        flyBypassConn = nil
    end
    if flyBodyVelocity then
        flyBodyVelocity:Destroy()
        flyBodyVelocity = nil
    end
    if flyBodyGyro then
        flyBodyGyro:Destroy()
        flyBodyGyro = nil
    end
    if player.Character then
        local hum = player.Character:FindFirstChild("Humanoid")
        if hum then
            hum.PlatformStand = false
        end
    end
    print("✈️ 飞天过检测已关闭")
end

-- 快捷键：按 F 切换飞天过检测
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F then
        if flyBypassEnabled then
            stopFlyBypass()
        else
            startFlyBypass()
        end
    end
end)

-- ==================== 9. 反检测伪装（Humanoid属性） ====================
local function antiDetection()
    local char = player.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            RunService.Heartbeat:Connect(function()
                if hum and hum.Parent then
                    if hum.WalkSpeed > 100 then
                        hum.WalkSpeed = 16
                        task.wait(0.05)
                    end
                end
            end)
        end
    end
end
antiDetection()
player.CharacterAdded:Connect(function()
    task.wait(0.5)
    antiDetection()
end)

-- ==================== 10. 防服务器检测 ====================
pcall(function()
    local stats = game:GetService("Stats")
    if stats then
        local network = stats:FindFirstChild("Network")
        if network then
            network:SetAttribute("DataSendingEnabled", true)
        end
    end
end)

-- ==================== 11. 反挂机 ====================
player.Idled:Connect(function()
    pcall(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

-- ==================== 12. 监听检测关键词 ====================
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

-- ==================== 13. 伪装人物速度（数据包拦截） ====================
local function interceptSpeedData()
    pcall(function()
        local mt = getrawmetatable(game)
        if mt then
            local oldIndex = mt.__index
            setreadonly(mt, false)
            mt.__index = newcclosure(function(self, key)
                if key == "WalkSpeed" and self:IsA("Humanoid") then
                    if checkcaller() then
                        return rawget(self, key)
                    else
                        return 16
                    end
                end
                return oldIndex(self, key)
            end)
            setreadonly(mt, true)
        end
    end)
end
interceptSpeedData()

print("========================================")
print("  ✅ 防封系统 V2 已启动 (13层防护)")
print("  🛡️ 速度伪装: 已开启")
print("  ✈️ 飞天过检测: 按 F 键切换")
print("  📌 现在可以执行其他脚本了")
print("========================================")