-- ============================================
--  独立防封壳 v3.0（自动运行 + 强制保护）
--  执行即开启，无关闭按钮，防封永久生效
--  按 F 切换飞天（不影响防封）
-- ============================================

local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")

print("🛡️ 防封壳强制启动中...")

-- ========== 防封核心（自动运行，无法关闭） ==========

-- 1. 拦截踢出
local oldKick = player.Kick
player.Kick = function(self, msg)
    print("🛡️ 拦截踢出: " .. tostring(msg))
    return nil
end

-- 2. 防拉回
local function antiTeleport()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local lastPos = hrp.Position
    RunService.Heartbeat:Connect(function()
        if not hrp or not hrp.Parent then return end
        if (hrp.Position - lastPos).Magnitude > 150 then
            hrp.CFrame = CFrame.new(lastPos)
        end
        lastPos = hrp.Position
    end)
end
player.CharacterAdded:Connect(function() task.wait(0.5) antiTeleport() end)
antiTeleport()

-- 3. 速度伪装
local function speedBypass()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    RunService.Heartbeat:Connect(function()
        if hum and hum.Parent and hum.WalkSpeed > 50 then
            hum.WalkSpeed = 16
            task.wait(0.05)
            hum.WalkSpeed = 16
        end
    end)
end
player.CharacterAdded:Connect(function() task.wait(0.5) speedBypass() end)
speedBypass()

-- 4. 防AFK
player.Idled:Connect(function()
    pcall(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

-- 5. 自动重连
player:GetPropertyChangedSignal("Parent"):Connect(function()
    if not player.Parent then
        print("🔄 重连中...")
        task.wait(2)
        pcall(function() TeleportService:Teleport(game.PlaceId) end)
    end
end)

-- ========== 飞天（按F切换，防封始终运行） ==========
local flying = false
local flyConn = nil
local flyKeys = {}

local function startFly()
    if flying then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end
    flying = true
    hum.PlatformStand = true
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bv.Parent = hrp
    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    bg.D, bg.P = 5000, 50000
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp
    
    local kb = UserInputService.InputBegan:Connect(function(i) flyKeys[i.KeyCode] = true end)
    local ke = UserInputService.InputEnded:Connect(function(i) flyKeys[i.KeyCode] = nil end)
    
    flyConn = RunService.Heartbeat:Connect(function()
        if not flying or not hrp or not hrp.Parent then
            flying = false
            bv:Destroy(); bg:Destroy(); kb:Disconnect(); ke:Disconnect()
            if hum then hum.PlatformStand = false end
            return
        end
        local m = Vector3.new(0,0,0)
        if flyKeys[Enum.KeyCode.W] then m = m + Vector3.new(0,0,-1) end
        if flyKeys[Enum.KeyCode.S] then m = m + Vector3.new(0,0,1) end
        if flyKeys[Enum.KeyCode.A] then m = m + Vector3.new(-1,0,0) end
        if flyKeys[Enum.KeyCode.D] then m = m + Vector3.new(1,0,0) end
        if flyKeys[Enum.KeyCode.Space] then m = Vector3.new(0,1,0) end
        if flyKeys[Enum.KeyCode.LeftShift] then m = Vector3.new(0,-1,0) end
        if m.Magnitude > 0 then
            local v = (hrp.CFrame.LookVector * (-m.Z) + hrp.CFrame.RightVector * m.X + hrp.CFrame.UpVector * m.Y) * 50
            bv.Velocity = v
            bg.CFrame = hrp.CFrame
        else
            bv.Velocity = Vector3.new(0,0,0)
        end
    end)
end

UserInputService.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.F and not i.IsModifierKey then
        if flying then
            flying = false
            print("✈️ 飞天关闭")
        else
            startFly()
            print("✈️ 飞天开启")
        end
    end
end)

-- ========== 悬浮状态显示（无关闭按钮） ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiCheatStatus"
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 120)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -60)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.fromRGB(0, 255, 100)
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = mainFrame

-- 标题（无关闭按钮）
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "🛡️ 防封保护中"
title.TextColor3 = Color3.fromRGB(0, 255, 100)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = mainFrame

-- 状态1
local status1 = Instance.new("TextLabel")
status1.Size = UDim2.new(1, -20, 0, 25)
status1.Position = UDim2.new(0, 10, 0, 45)
status1.BackgroundTransparency = 1
status1.Text = "✅ 踢出拦截 | 速度伪装 | 防拉回"
status1.TextColor3 = Color3.fromRGB(150, 255, 150)
status1.TextSize = 13
status1.Font = Enum.Font.Gotham
status1.TextXAlignment = Enum.TextXAlignment.Center
status1.Parent = mainFrame

-- 状态2
local status2 = Instance.new("TextLabel")
status2.Size = UDim2.new(1, -20, 0, 25)
status2.Position = UDim2.new(0, 10, 0, 70)
status2.BackgroundTransparency = 1
status2.Text = "✈️ 按 F 切换飞天 | 自动重连"
status2.TextColor3 = Color3.fromRGB(150, 255, 150)
status2.TextSize = 13
status2.Font = Enum.Font.Gotham
status2.TextXAlignment = Enum.TextXAlignment.Center
status2.Parent = mainFrame

-- 提示
local tip = Instance.new("TextLabel")
tip.Size = UDim2.new(1, -20, 0, 20)
tip.Position = UDim2.new(0, 10, 0, 98)
tip.BackgroundTransparency = 1
tip.Text = "🔄 可加载其他辅助脚本"
tip.TextColor3 = Color3.fromRGB(200, 200, 200)
tip.TextSize = 11
tip.Font = Enum.Font.Gotham
tip.TextXAlignment = Enum.TextXAlignment.Center
tip.Parent = mainFrame

-- 发光动画
local glow = Instance.new("Frame")
glow.Size = UDim2.new(1, 10, 1, 10)
glow.Position = UDim2.new(0, -5, 0, -5)
glow.BackgroundTransparency = 1
glow.BorderSizePixel = 2
glow.BorderColor3 = Color3.fromRGB(0, 255, 100)
glow.ZIndex = 0
glow.Parent = mainFrame
local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 20)
glowCorner.Parent = glow

-- 呼吸动画
local t = 0
RunService.Heartbeat:Connect(function()
    t = t + 0.02
    local alpha = 0.3 + math.sin(t) * 0.2
    mainFrame.BackgroundTransparency = 0.08 - alpha * 0.05
    glow.BackgroundTransparency = 1
    glow.BorderSizePixel = 1 + math.sin(t) * 0.5
end)

print("========================================")
print("  ✅ 防封壳 v3.0 已强制启动")
print("  🔒 防封功能：无法关闭（永久运行）")
print("  📌 现在可以加载其他辅助脚本了")
print("  ✈️ 按 F 切换飞天（不影响防封）")
print("========================================")