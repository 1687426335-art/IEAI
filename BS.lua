-- ============================================
--  飞车功能 + 悬浮窗（纯飞车，无透视）
--  点击"飞车"按钮开启/关闭
--  方向键 W 加速前进
--  空格 向上 | Shift 向下
-- ============================================

local player = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- ========== 变量 ==========
local flycarEnabled = false
local flycarBV = nil
local flycarBG = nil
local flycarConn = nil
local flycarSpeed = 80
local keys = {}

-- ========== 创建悬浮窗 ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyCarMenu"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 140)
mainFrame.Position = UDim2.new(0.5, -90, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- 标题
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "🚗 飞车模式"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = mainFrame

-- 状态
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 20)
status.Position = UDim2.new(0, 0, 0, 38)
status.BackgroundTransparency = 1
status.Text = "状态: 关闭"
status.TextColor3 = Color3.fromRGB(200, 200, 200)
status.TextSize = 13
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Center
status.Parent = mainFrame

-- 开/关按钮
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 120, 0, 35)
toggleBtn.Position = UDim2.new(0.5, -60, 0, 65)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
toggleBtn.Text = "🚗 启动飞车"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 15
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = mainFrame
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = toggleBtn

-- 提示
local tip = Instance.new("TextLabel")
tip.Size = UDim2.new(1, 0, 0, 20)
tip.Position = UDim2.new(0, 0, 0, 108)
tip.BackgroundTransparency = 1
tip.Text = "W加速 空格↑ Shift↓"
tip.TextColor3 = Color3.fromRGB(150, 150, 180)
tip.TextSize = 11
tip.Font = Enum.Font.Gotham
tip.TextXAlignment = Enum.TextXAlignment.Center
tip.Parent = mainFrame

-- ========== 飞车核心功能 ==========
local function startFlyCar()
    if flycarEnabled then return end
    
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end
    
    flycarEnabled = true
    status.Text = "状态: 🟢 飞行中"
    status.TextColor3 = Color3.fromRGB(0, 255, 100)
    toggleBtn.Text = "🚗 关闭飞车"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    
    -- 保存原始速度，设置飞行状态
    hum.PlatformStand = true
    
    -- 身体速度（推动）
    flycarBV = Instance.new("BodyVelocity")
    flycarBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    flycarBV.Velocity = Vector3.new(0, 0, 0)
    flycarBV.Parent = hrp
    
    -- 陀螺仪（稳定方向）
    flycarBG = Instance.new("BodyGyro")
    flycarBG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    flycarBG.D = 5000
    flycarBG.P = 50000
    flycarBG.CFrame = hrp.CFrame
    flycarBG.Parent = hrp
    
    -- 键盘监听
    local function onKey(input, isDown)
        if input.KeyCode == Enum.KeyCode.W then keys.W = isDown end
        if input.KeyCode == Enum.KeyCode.S then keys.S = isDown end
        if input.KeyCode == Enum.KeyCode.A then keys.A = isDown end
        if input.KeyCode == Enum.KeyCode.D then keys.D = isDown end
        if input.KeyCode == Enum.KeyCode.Space then keys.Space = isDown end
        if input.KeyCode == Enum.KeyCode.LeftShift then keys.Shift = isDown end
    end
    
    local beganConn = UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        onKey(input, true)
    end)
    
    local endedConn = UserInputService.InputEnded:Connect(function(input, gp)
        if gp then return end
        onKey(input, false)
    end)
    
    -- 飞车主循环
    flycarConn = RunService.Heartbeat:Connect(function()
        if not flycarEnabled or not hrp or not hrp.Parent then
            stopFlyCar()
            return
        end
        
        -- 获取相机方向
        local forward = Camera.CFrame.LookVector
        local right = Camera.CFrame.RightVector
        local up = Camera.CFrame.UpVector
        
        -- 计算移动方向
        local move = Vector3.new(0, 0, 0)
        if keys.W then move = move + forward * flycarSpeed end
        if keys.S then move = move - forward * flycarSpeed * 0.5 end
        if keys.A then move = move - right * flycarSpeed * 0.7 end
        if keys.D then move = move + right * flycarSpeed * 0.7 end
        if keys.Space then move = move + up * flycarSpeed end
        if keys.Shift then move = move - up * flycarSpeed end
        
        if move.Magnitude > 0 then
            flycarBV.Velocity = move
        else
            flycarBV.Velocity = Vector3.new(0, 0, 0)
        end
        
        -- 保持身体朝向相机方向
        flycarBG.CFrame = CFrame.new(hrp.Position, hrp.Position + forward)
    end)
    
    -- 保存连接以便清理
    flycarConn._beganConn = beganConn
    flycarConn._endedConn = endedConn
end

local function stopFlyCar()
    flycarEnabled = false
    status.Text = "状态: 🔴 关闭"
    status.TextColor3 = Color3.fromRGB(200, 200, 200)
    toggleBtn.Text = "🚗 启动飞车"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
    
    if flycarBV then flycarBV:Destroy(); flycarBV = nil end
    if flycarBG then flycarBG:Destroy(); flycarBG = nil end
    if flycarConn then
        if flycarConn._beganConn then flycarConn._beganConn:Disconnect() end
        if flycarConn._endedConn then flycarConn._endedConn:Disconnect() end
        flycarConn:Disconnect()
        flycarConn = nil
    end
    
    local char = player.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end

-- ========== 按钮事件 ==========
toggleBtn.MouseButton1Click:Connect(function()
    if flycarEnabled then
        stopFlyCar()
    else
        startFlyCar()
    end
end)

-- ========== 角色重生清理 ==========
player.CharacterAdded:Connect(function()
    task.wait(0.5)
    if flycarEnabled then
        stopFlyCar()
        -- 自动重启
        task.wait(0.3)
        startFlyCar()
    end
end)

-- ========== 快捷键 F ==========
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F then
        toggleBtn.MouseButton1Click:Fire()
    end
end)

print("========================================")
print("  ✅ 飞车功能已加载")
print("  📌 点击悬浮窗按钮启动")
print("  ⌨️ 按 F 键快速开关")
print("  🚗 W加速 空格↑ Shift↓")
print("========================================")