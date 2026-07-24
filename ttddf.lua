-- ========== 皮脚本 - 精简版（悬浮窗 + 飞车） ==========

local player = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera

print("🚗 皮脚本精简版已加载")

-- ============================================
--  飞车功能
-- ============================================
local carFlyEnabled = false
local carSpeed = 80
local carBV = nil
local carBG = nil
local carFlyConn = nil

local function toggleCarFly()
    carFlyEnabled = not carFlyEnabled

    if carFlyEnabled then
        local char = player.Character
        if not char then
            print("❌ 没有角色")
            carFlyEnabled = false
            return
        end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if not hrp or not hum then
            print("❌ 找不到 HumanoidRootPart")
            carFlyEnabled = false
            return
        end

        print("✅ 飞车开启")
        hum.PlatformStand = true

        carBV = Instance.new("BodyVelocity")
        carBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        carBV.Velocity = Vector3.new(0, 20, 0)
        carBV.Parent = hrp

        carBG = Instance.new("BodyGyro")
        carBG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        carBG.D = 5000
        carBG.P = 50000
        carBG.CFrame = Camera.CFrame
        carBG.Parent = hrp

        carFlyConn = RunService.Heartbeat:Connect(function()
            if not carFlyEnabled or not hrp or not hrp.Parent then
                if carFlyConn then
                    carFlyConn:Disconnect()
                    carFlyConn = nil
                end
                return
            end
            if carBV and carBG then
                carBV.Velocity = Camera.CFrame.LookVector * carSpeed
                carBG.CFrame = Camera.CFrame
            end
        end)

        -- 上升
        task.spawn(function()
            local targetHeight = hrp.Position.Y + 15
            local waitCount = 0
            while carFlyEnabled and hrp and hrp.Parent and waitCount < 30 do
                if hrp.Position.Y < targetHeight then
                    if carBV then
                        carBV.Velocity = Vector3.new(0, 30, 0)
                    end
                else
                    break
                end
                waitCount = waitCount + 1
                task.wait(0.1)
            end
        end)

    else
        print("❌ 飞车关闭")
        if carBV then carBV:Destroy(); carBV = nil end
        if carBG then carBG:Destroy(); carBG = nil end
        if carFlyConn then carFlyConn:Disconnect(); carFlyConn = nil end
        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.PlatformStand = false
            end
        end
    end
end

-- ============================================
--  创建悬浮窗
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PiScript_Menu"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

-- 主框架
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 180)
mainFrame.Position = UDim2.new(0.02, 0, 0.15, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 30)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.fromRGB(255, 100, 200)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 100, 200)
titleBar.BackgroundTransparency = 0.2
titleBar.Parent = mainFrame
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 14)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🚗 飞车控制"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- 关闭按钮
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 2)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 200, 200)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- 状态显示
local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -20, 0, 25)
statusText.Position = UDim2.new(0, 10, 0, 45)
statusText.BackgroundTransparency = 1
statusText.Text = "飞车状态: 关闭"
statusText.TextColor3 = Color3.fromRGB(200, 200, 200)
statusText.TextSize = 14
statusText.Font = Enum.Font.Gotham
statusText.TextXAlignment = Enum.TextXAlignment.Center
statusText.Parent = mainFrame

-- 飞车速度显示
local speedText = Instance.new("TextLabel")
speedText.Size = UDim2.new(1, -20, 0, 20)
speedText.Position = UDim2.new(0, 10, 0, 72)
speedText.BackgroundTransparency = 1
speedText.Text = "速度: 80"
speedText.TextColor3 = Color3.fromRGB(180, 180, 220)
speedText.TextSize = 12
speedText.Font = Enum.Font.Gotham
speedText.TextXAlignment = Enum.TextXAlignment.Center
speedText.Parent = mainFrame

-- 飞车按钮
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0, 160, 0, 40)
flyBtn.Position = UDim2.new(0.5, -80, 0, 105)
flyBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 200)
flyBtn.Text = "🚗 启动飞车"
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.TextSize = 16
flyBtn.Font = Enum.Font.GothamBold
flyBtn.BorderSizePixel = 0
flyBtn.Parent = mainFrame

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 8)
flyCorner.Parent = flyBtn

flyBtn.MouseButton1Click:Connect(function()
    toggleCarFly()
    if carFlyEnabled then
        flyBtn.Text = "🚗 关闭飞车"
        flyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        statusText.Text = "飞车状态: 开启"
        statusText.TextColor3 = Color3.fromRGB(0, 255, 100)
    else
        flyBtn.Text = "🚗 启动飞车"
        flyBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 200)
        statusText.Text = "飞车状态: 关闭"
        statusText.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

flyBtn.MouseEnter:Connect(function()
    flyBtn.BackgroundColor3 = flyBtn.BackgroundColor3 == Color3.fromRGB(255, 100, 200) and Color3.fromRGB(255, 150, 255) or Color3.fromRGB(255, 80, 80)
end)
flyBtn.MouseLeave:Connect(function()
    if carFlyEnabled then
        flyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    else
        flyBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 200)
    end
end)

-- 速度调节
local speedSlider = Instance.new("Frame")
speedSlider.Size = UDim2.new(0.8, 0, 0, 20)
speedSlider.Position = UDim2.new(0.1, 0, 0, 148)
speedSlider.BackgroundColor3 = Color3.fromRGB(40, 35, 60)
speedSlider.Parent = mainFrame
local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 10)
sliderCorner.Parent = speedSlider

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(255, 100, 200)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = speedSlider
local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 10)
fillCorner.Parent = sliderFill

local sliderKnob = Instance.new("TextButton")
sliderKnob.Size = UDim2.new(0, 20, 0, 20)
sliderKnob.Position = UDim2.new(0.5, -10, 0.5, -10)
sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderKnob.Text = ""
sliderKnob.AutoButtonColor = false
sliderKnob.Parent = speedSlider
local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1, 0)
knobCorner.Parent = sliderKnob

local function updateSpeedDisplay()
    speedText.Text = "速度: " .. carSpeed
    local percent = (carSpeed - 10) / 190
    sliderFill.Size = UDim2.new(percent, 0, 1, 0)
    sliderKnob.Position = UDim2.new(percent, -10, 0.5, -10)
end

local dragging = false
sliderKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mousePos = UserInputService:GetMouseLocation()
        local sliderPos = speedSlider.AbsolutePosition
        local sliderSize = speedSlider.AbsoluteSize
        local percent = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
        carSpeed = math.floor(10 + percent * 190)
        updateSpeedDisplay()
        if carFlyEnabled then
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp and carBV then
                    carBV.Velocity = Camera.CFrame.LookVector * carSpeed
                end
            end
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

updateSpeedDisplay()

-- ============================================
--  快捷键 F
-- ============================================
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F then
        flyBtn.MouseButton1Click:Fire()
    end
end)

-- ============================================
--  角色重生重置
-- ============================================
player.CharacterAdded:Connect(function()
    task.wait(0.5)
    if carFlyEnabled then
        carFlyEnabled = false
        if carBV then carBV:Destroy(); carBV = nil end
        if carBG then carBG:Destroy(); carBG = nil end
        if carFlyConn then carFlyConn:Disconnect(); carFlyConn = nil end
        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then hum.PlatformStand = false end
        end
        flyBtn.Text = "🚗 启动飞车"
        flyBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 200)
        statusText.Text = "飞车状态: 关闭"
        statusText.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

print("========================================")
print("  🚗 皮脚本精简版已加载")
print("  📌 按 F 键 开关飞车")
print("  📌 拖动滑块调节速度")
print("========================================")
