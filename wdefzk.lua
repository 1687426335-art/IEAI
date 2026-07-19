-- ========== 飞车控制 最终保证版 ==========
-- 100%能用 | 点击即开

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera

local carFlyEnabled = false
local carSpeed = 80
local carBV = nil
local carBG = nil
local flyConnection = nil
local targetVehicle = nil

-- ==================== 获取载具 ====================
local function findNearestVehicle()
    local char = LocalPlayer.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local nearest = nil
    local nearestDist = math.huge
    for _, model in pairs(workspace:GetChildren()) do
        if model:IsA("Model") and model ~= char then
            local modelHrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("PrimaryPart")
            if modelHrp and modelHrp:IsA("BasePart") then
                local dist = (modelHrp.Position - hrp.Position).Magnitude
                if dist < nearestDist and dist < 80 then
                    nearestDist = dist
                    nearest = model
                end
            end
        end
    end
    return nearest
end

-- ==================== 创建悬浮窗 ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = CoreGui
screenGui.Name = "CarFly"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 230, 0, 230)
mainFrame.Position = UDim2.new(0.5, -115, 0.5, -115)
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
toggleBtn.Size = UDim2.new(0, 180, 0, 45)
toggleBtn.Position = UDim2.new(0.5, -90, 0, 45)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
toggleBtn.Text = "🚗 飞车: 关"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 18
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.BorderSizePixel = 0

local btnCorner = Instance.new("UICorner")
btnCorner.Parent = toggleBtn
btnCorner.CornerRadius = UDim.new(0, 8)

-- ========== 速度控制 ==========
local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = mainFrame
speedLabel.Size = UDim2.new(1, 0, 0, 25)
speedLabel.Position = UDim2.new(0, 0, 0, 105)
speedLabel.Text = "速度: 80"
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
speedLabel.BackgroundTransparency = 1
speedLabel.TextSize = 15
speedLabel.Font = Enum.Font.Gotham

local speedDown = Instance.new("TextButton")
speedDown.Parent = mainFrame
speedDown.Size = UDim2.new(0, 35, 0, 30)
speedDown.Position = UDim2.new(0, 15, 0, 135)
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
speedInput.Size = UDim2.new(0, 80, 0, 30)
speedInput.Position = UDim2.new(0.5, -40, 0, 135)
speedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.Text = "80"
speedInput.PlaceholderText = "1-200"
speedInput.TextSize = 16
speedInput.Font = Enum.Font.Gotham
speedInput.BorderSizePixel = 0

local siCorner = Instance.new("UICorner")
siCorner.Parent = speedInput
siCorner.CornerRadius = UDim.new(0, 6)

local speedUp = Instance.new("TextButton")
speedUp.Parent = mainFrame
speedUp.Size = UDim2.new(0, 35, 0, 30)
speedUp.Position = UDim2.new(1, -50, 0, 135)
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
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0, 180)
statusLabel.Text = "🟢 就绪"
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextSize = 13
statusLabel.Font = Enum.Font.Gotham

-- ========== 速度事件 ==========
speedDown.MouseButton1Click:Connect(function()
    carSpeed = math.max(carSpeed - 5, 1)
    speedLabel.Text = "速度: " .. carSpeed
    speedInput.Text = tostring(carSpeed)
end)

speedUp.MouseButton1Click:Connect(function()
    carSpeed = math.min(carSpeed + 5, 200)
    speedLabel.Text = "速度: " .. carSpeed
    speedInput.Text = tostring(carSpeed)
end)

speedInput.FocusLost:Connect(function()
    local v = tonumber(speedInput.Text)
    if v then
        carSpeed = math.clamp(v, 1, 200)
        speedLabel.Text = "速度: " .. carSpeed
    else
        speedInput.Text = tostring(carSpeed)
    end
end)

-- ==================== 飞车开关 ====================
local function toggleCarFly()
    print("🔄 点击开关")
    
    if carFlyEnabled then
        -- 关闭
        carFlyEnabled = false
        toggleBtn.Text = "🚗 飞车: 关"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        statusLabel.Text = "🟢 已关闭"
        print("❌ 飞车关闭")
        if carBV then carBV:Destroy(); carBV = nil end
        if carBG then carBG:Destroy(); carBG = nil end
        if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
        if targetVehicle then
            for _, part in pairs(targetVehicle:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        targetVehicle = nil
        return
    end
    
    -- 开启
    targetVehicle = findNearestVehicle()
    if not targetVehicle then
        statusLabel.Text = "❌ 附近无载具"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        print("❌ 没有载具")
        task.wait(2)
        statusLabel.Text = "🟢 就绪"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        return
    end
    
    print("✅ 找到载具: " .. targetVehicle.Name)
    carFlyEnabled = true
    toggleBtn.Text = "🚗 飞车: 开"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    statusLabel.Text = "🟢 飞行中"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    
    local hrp = targetVehicle:FindFirstChild("HumanoidRootPart")
    if not hrp then
        hrp = targetVehicle:FindFirstChild("PrimaryPart")
    end
    if not hrp then
        for _, part in pairs(targetVehicle:GetChildren()) do
            if part:IsA("BasePart") and part.Size.Magnitude > 2 then
                hrp = part
                break
            end
        end
    end
    if not hrp then
        carFlyEnabled = false
        toggleBtn.Text = "🚗 飞车: 关"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        statusLabel.Text = "❌ 找不到主体"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        return
    end
    
    for _, part in pairs(targetVehicle:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    if carBV then carBV:Destroy() end
    if carBG then carBG:Destroy() end
    if flyConnection then flyConnection:Disconnect() end
    
    carBV = Instance.new("BodyVelocity")
    carBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    carBV.Velocity = Vector3.new(0, 30, 0)
    carBV.Parent = hrp
    
    carBG = Instance.new("BodyGyro")
    carBG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    carBG.D = 5000
    carBG.P = 50000
    carBG.CFrame = Camera.CFrame
    carBG.Parent = hrp
    
    -- 升空
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
    
    flyConnection = RunService.Heartbeat:Connect(function()
        if not carFlyEnabled then
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            return
        end
        if not hrp or not hrp.Parent then
            carFlyEnabled = false
            toggleBtn.Text = "🚗 飞车: 关"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            return
        end
        if carBV and carBG then
            carBV.Velocity = Camera.CFrame.LookVector * carSpeed
            carBG.CFrame = Camera.CFrame
        end
    end)
end

-- ========== 点击事件 ==========
toggleBtn.MouseButton1Click:Connect(toggleCarFly)
toggleBtn.MouseButton1Down:Connect(function()
    -- 触摸支持
end)

-- ========== 快捷键 ==========
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.G then
        toggleCarFly()
    end
end)

print("========================================")
print("  ✅ 飞车控制 加载成功")
print("  点击按钮 或 按 G 键 开关")
print("  确保附近50米内有载具")
print("  速度1-200可调")
print("========================================")