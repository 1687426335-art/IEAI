-- ========== 圣奥里飞车 V2 ==========
-- 不需要载具 | 直接飞自己 | 跟飞行一样但显示飞车

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera

local flyEnabled = false
local flySpeed = 80
local flyBV = nil
local flyBG = nil
local flyConn = nil

-- ==================== 创建悬浮窗 ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = CoreGui
screenGui.Name = "CarFly"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 200, 0, 200)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local mainCorner = Instance.new("UICorner")
mainCorner.Parent = mainFrame
mainCorner.CornerRadius = UDim.new(0, 14)

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Parent = mainFrame
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
titleBar.BackgroundTransparency = 0.2
titleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner")
titleCorner.Parent = titleBar
titleCorner.CornerRadius = UDim.new(0, 14)

local titleText = Instance.new("TextLabel")
titleText.Parent = titleBar
titleText.Size = UDim2.new(1, -60, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.Text = "🚗 飞车控制"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.BackgroundTransparency = 1
titleText.TextSize = 15
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = titleBar
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.BackgroundTransparency = 1
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ========== 开关按钮 ==========
local toggleBtn = Instance.new("TextButton")
toggleBtn.Parent = mainFrame
toggleBtn.Size = UDim2.new(0, 160, 0, 40)
toggleBtn.Position = UDim2.new(0.5, -80, 0, 45)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
toggleBtn.Text = "🚗 飞车: 关"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 16
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.BorderSizePixel = 0

local btnCorner = Instance.new("UICorner")
btnCorner.Parent = toggleBtn
btnCorner.CornerRadius = UDim.new(0, 8)

-- ========== 速度控制 ==========
local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = mainFrame
speedLabel.Size = UDim2.new(1, 0, 0, 25)
speedLabel.Position = UDim2.new(0, 0, 0, 100)
speedLabel.Text = "速度: 80"
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
speedLabel.BackgroundTransparency = 1
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.Gotham

local speedDown = Instance.new("TextButton")
speedDown.Parent = mainFrame
speedDown.Size = UDim2.new(0, 35, 0, 28)
speedDown.Position = UDim2.new(0, 15, 0, 130)
speedDown.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
speedDown.Text = "-"
speedDown.TextColor3 = Color3.fromRGB(255, 255, 255)
speedDown.TextSize = 18
speedDown.Font = Enum.Font.GothamBold
speedDown.BorderSizePixel = 0

local sdCorner = Instance.new("UICorner")
sdCorner.Parent = speedDown
sdCorner.CornerRadius = UDim.new(0, 6)

local speedInput = Instance.new("TextBox")
speedInput.Parent = mainFrame
speedInput.Size = UDim2.new(0, 70, 0, 28)
speedInput.Position = UDim2.new(0.5, -35, 0, 130)
speedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.Text = "80"
speedInput.PlaceholderText = "1-200"
speedInput.TextSize = 15
speedInput.Font = Enum.Font.Gotham
speedInput.BorderSizePixel = 0

local siCorner = Instance.new("UICorner")
siCorner.Parent = speedInput
siCorner.CornerRadius = UDim.new(0, 6)

local speedUp = Instance.new("TextButton")
speedUp.Parent = mainFrame
speedUp.Size = UDim2.new(0, 35, 0, 28)
speedUp.Position = UDim2.new(1, -50, 0, 130)
speedUp.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
speedUp.Text = "+"
speedUp.TextColor3 = Color3.fromRGB(255, 255, 255)
speedUp.TextSize = 18
speedUp.Font = Enum.Font.GothamBold
speedUp.BorderSizePixel = 0

local suCorner = Instance.new("UICorner")
suCorner.Parent = speedUp
suCorner.CornerRadius = UDim.new(0, 6)

local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = mainFrame
statusLabel.Size = UDim2.new(1, 0, 0, 18)
statusLabel.Position = UDim2.new(0, 0, 0, 170)
statusLabel.Text = "🟢 就绪 | 点开关"
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham

-- ========== 速度事件 ==========
speedDown.MouseButton1Click:Connect(function()
    carSpeed = math.max(carSpeed - 5, 1)
    speedLabel.Text = "速度: " .. carSpeed
    speedInput.Text = tostring(carSpeed)
    if flyEnabled and flyBV then
        flyBV.Velocity = Camera.CFrame.LookVector * carSpeed
    end
end)

speedUp.MouseButton1Click:Connect(function()
    carSpeed = math.min(carSpeed + 5, 200)
    speedLabel.Text = "速度: " .. carSpeed
    speedInput.Text = tostring(carSpeed)
    if flyEnabled and flyBV then
        flyBV.Velocity = Camera.CFrame.LookVector * carSpeed
    end
end)

speedInput.FocusLost:Connect(function()
    local v = tonumber(speedInput.Text)
    if v then
        carSpeed = math.clamp(v, 1, 200)
        speedLabel.Text = "速度: " .. carSpeed
        if flyEnabled and flyBV then
            flyBV.Velocity = Camera.CFrame.LookVector * carSpeed
        end
    else
        speedInput.Text = tostring(carSpeed)
    end
end)

-- ==================== 飞车核心（直接飞自己） ====================
local function toggleFly()
    print("🔄 点击开关")
    
    if flyEnabled then
        -- 关闭
        flyEnabled = false
        toggleBtn.Text = "🚗 飞车: 关"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        statusLabel.Text = "🟢 已关闭"
        print("❌ 飞车关闭")
        if flyBV then flyBV:Destroy(); flyBV = nil end
        if flyBG then flyBG:Destroy(); flyBG = nil end
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        if LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum.PlatformStand = false end
        end
        return
    end
    
    -- 开启
    local char = LocalPlayer.Character
    if not char then
        statusLabel.Text = "❌ 无角色"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        return
    end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then
        statusLabel.Text = "❌ 无角色"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        return
    end
    
    print("✅ 飞车开启")
    flyEnabled = true
    toggleBtn.Text = "🚗 飞车: 开"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    statusLabel.Text = "🟢 飞行中"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    
    hum.PlatformStand = true
    
    if flyBV then flyBV:Destroy() end
    if flyBG then flyBG:Destroy() end
    if flyConn then flyConn:Disconnect() end
    
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
        if not flyEnabled then
            if flyConn then
                flyConn:Disconnect()
                flyConn = nil
            end
            return
        end
        if not hrp or not hrp.Parent then
            flyEnabled = false
            toggleBtn.Text = "🚗 飞车: 关"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            if flyConn then
                flyConn:Disconnect()
                flyConn = nil
            end
            return
        end
        if flyBV and flyBG then
            flyBV.Velocity = Camera.CFrame.LookVector * carSpeed
            flyBG.CFrame = Camera.CFrame
        end
    end)
end

-- ========== 点击事件 ==========
toggleBtn.MouseButton1Click:Connect(toggleFly)

-- ========== 快捷键 G ==========
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.G then
        toggleFly()
    end
end)

-- ========== 角色重生 ==========
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if flyEnabled then
        flyEnabled = false
        if flyBV then flyBV:Destroy(); flyBV = nil end
        if flyBG then flyBG:Destroy(); flyBG = nil end
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        toggleBtn.Text = "🚗 飞车: 关"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end
end)

print("========================================")
print("  ✅ 圣奥里飞车 加载成功")
print("  不需要载具 | 直接飞自己")
print("  点击按钮 或 按 G 键 开关")
print("  速度1-200可调")
print("========================================")