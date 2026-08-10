-- ========== Car Speed Gui 车辆加速悬浮窗 ==========
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CarSpeedGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = Player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 480)
mainFrame.Position = UDim2.new(0.02, 0, 0.05, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 18)
mainFrame.BackgroundTransparency = 0.08
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- ========== 关闭按钮 ==========
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.BackgroundTransparency = 0.3
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    print("Car Speed Gui 已关闭")
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -35, 0, 30)
title.Position = UDim2.new(0, 5, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Car Speed Gui"
title.TextColor3 = Color3.fromRGB(0, 150, 255)
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Center
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local line1 = Instance.new("Frame")
line1.Size = UDim2.new(0.9, 0, 0, 1)
line1.Position = UDim2.new(0.05, 0, 0, 38)
line1.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
line1.BackgroundTransparency = 0.5
line1.BorderSizePixel = 0
line1.Parent = mainFrame

-- 速度上限
local speedLimitLabel = Instance.new("TextLabel")
speedLimitLabel.Size = UDim2.new(0.5, 0, 0, 25)
speedLimitLabel.Position = UDim2.new(0.05, 0, 0, 45)
speedLimitLabel.BackgroundTransparency = 1
speedLimitLabel.Text = "速度上限："
speedLimitLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLimitLabel.TextSize = 14
speedLimitLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLimitLabel.Font = Enum.Font.Gotham
speedLimitLabel.Parent = mainFrame

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0.3, 0, 0, 25)
speedInput.Position = UDim2.new(0.6, 0, 0, 45)
speedInput.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
speedInput.BackgroundTransparency = 0.3
speedInput.Text = "90"
speedInput.TextColor3 = Color3.fromRGB(0, 200, 255)
speedInput.TextSize = 14
speedInput.TextXAlignment = Enum.TextXAlignment.Center
speedInput.Font = Enum.Font.GothamBold
speedInput.ClearTextOnFocus = false
speedInput.Parent = mainFrame

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 5)
speedCorner.Parent = speedInput

-- 线性加速
local accelLabel = Instance.new("TextLabel")
accelLabel.Size = UDim2.new(0.5, 0, 0, 25)
accelLabel.Position = UDim2.new(0.05, 0, 0, 75)
accelLabel.BackgroundTransparency = 1
accelLabel.Text = "线性加速"
accelLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
accelLabel.TextSize = 14
accelLabel.TextXAlignment = Enum.TextXAlignment.Left
accelLabel.Font = Enum.Font.Gotham
accelLabel.Parent = mainFrame

local accelToggle = Instance.new("TextButton")
accelToggle.Size = UDim2.new(0.3, 0, 0, 22)
accelToggle.Position = UDim2.new(0.65, 0, 0, 76)
accelToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 50)
accelToggle.BackgroundTransparency = 0.2
accelToggle.Text = "lin_bobo77"
accelToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
accelToggle.TextSize = 11
accelToggle.Font = Enum.Font.GothamBold
accelToggle.BorderSizePixel = 0
accelToggle.Parent = mainFrame

local accelCorner = Instance.new("UICorner")
accelCorner.CornerRadius = UDim.new(0, 6)
accelCorner.Parent = accelToggle

-- 线性转向
local steerLabel = Instance.new("TextLabel")
steerLabel.Size = UDim2.new(0.5, 0, 0, 25)
steerLabel.Position = UDim2.new(0.05, 0, 0, 105)
steerLabel.BackgroundTransparency = 1
steerLabel.Text = "线性转向"
steerLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
steerLabel.TextSize = 14
steerLabel.TextXAlignment = Enum.TextXAlignment.Left
steerLabel.Font = Enum.Font.Gotham
steerLabel.Parent = mainFrame

local steerToggle = Instance.new("TextButton")
steerToggle.Size = UDim2.new(0.3, 0, 0, 22)
steerToggle.Position = UDim2.new(0.65, 0, 0, 106)
steerToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 50)
steerToggle.BackgroundTransparency = 0.2
steerToggle.Text = "线性转向"
steerToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
steerToggle.TextSize = 11
steerToggle.Font = Enum.Font.GothamBold
steerToggle.BorderSizePixel = 0
steerToggle.Parent = mainFrame

local steerCorner = Instance.new("UICorner")
steerCorner.CornerRadius = UDim.new(0, 6)
steerCorner.Parent = steerToggle

-- 上车检测
local boardLabel = Instance.new("TextLabel")
boardLabel.Size = UDim2.new(0.5, 0, 0, 25)
boardLabel.Position = UDim2.new(0.05, 0, 0, 135)
boardLabel.BackgroundTransparency = 1
boardLabel.Text = "上车检测"
boardLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
boardLabel.TextSize = 14
boardLabel.TextXAlignment = Enum.TextXAlignment.Left
boardLabel.Font = Enum.Font.Gotham
boardLabel.Parent = mainFrame

local boardToggle = Instance.new("TextButton")
boardToggle.Size = UDim2.new(0.3, 0, 0, 22)
boardToggle.Position = UDim2.new(0.65, 0, 0, 136)
boardToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
boardToggle.BackgroundTransparency = 0.2
boardToggle.Text = "未上车"
boardToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
boardToggle.TextSize = 11
boardToggle.Font = Enum.Font.GothamBold
boardToggle.BorderSizePixel = 0
boardToggle.Parent = mainFrame

local boardCorner = Instance.new("UICorner")
boardCorner.CornerRadius = UDim.new(0, 6)
boardCorner.Parent = boardToggle

-- 横向移动辅助
local assistLabel = Instance.new("TextLabel")
assistLabel.Size = UDim2.new(0.55, 0, 0, 25)
assistLabel.Position = UDim2.new(0.05, 0, 0, 165)
assistLabel.BackgroundTransparency = 1
assistLabel.Text = "横向移动辅助："
assistLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
assistLabel.TextSize = 14
assistLabel.TextXAlignment = Enum.TextXAlignment.Left
assistLabel.Font = Enum.Font.Gotham
assistLabel.Parent = mainFrame

local assistToggle = Instance.new("TextButton")
assistToggle.Size = UDim2.new(0.3, 0, 0, 22)
assistToggle.Position = UDim2.new(0.65, 0, 0, 166)
assistToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
assistToggle.BackgroundTransparency = 0.2
assistToggle.Text = "已关闭"
assistToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
assistToggle.TextSize = 11
assistToggle.Font = Enum.Font.GothamBold
assistToggle.BorderSizePixel = 0
assistToggle.Parent = mainFrame

local assistCorner = Instance.new("UICorner")
assistCorner.CornerRadius = UDim.new(0, 6)
assistCorner.Parent = assistToggle

-- 车头跟随
local followLabel = Instance.new("TextLabel")
followLabel.Size = UDim2.new(0.55, 0, 0, 25)
followLabel.Position = UDim2.new(0.05, 0, 0, 195)
followLabel.BackgroundTransparency = 1
followLabel.Text = "车头跟随："
followLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
followLabel.TextSize = 14
followLabel.TextXAlignment = Enum.TextXAlignment.Left
followLabel.Font = Enum.Font.Gotham
followLabel.Parent = mainFrame

local followToggle = Instance.new("TextButton")
followToggle.Size = UDim2.new(0.3, 0, 0, 22)
followToggle.Position = UDim2.new(0.65, 0, 0, 196)
followToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
followToggle.BackgroundTransparency = 0.2
followToggle.Text = "已关闭"
followToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
followToggle.TextSize = 11
followToggle.Font = Enum.Font.GothamBold
followToggle.BorderSizePixel = 0
followToggle.Parent = mainFrame

local followCorner = Instance.new("UICorner")
followCorner.CornerRadius = UDim.new(0, 6)
followCorner.Parent = followToggle

local line2 = Instance.new("Frame")
line2.Size = UDim2.new(0.9, 0, 0, 1)
line2.Position = UDim2.new(0.05, 0, 0, 225)
line2.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
line2.BackgroundTransparency = 0.5
line2.BorderSizePixel = 0
line2.Parent = mainFrame

-- 前进按钮
local forwardBtn = Instance.new("TextButton")
forwardBtn.Size = UDim2.new(0.8, 0, 0, 40)
forwardBtn.Position = UDim2.new(0.1, 0, 0, 235)
forwardBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 50)
forwardBtn.BackgroundTransparency = 0.2
forwardBtn.Text = "前进"
forwardBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
forwardBtn.TextSize = 18
forwardBtn.Font = Enum.Font.GothamBold
forwardBtn.BorderSizePixel = 0
forwardBtn.Parent = mainFrame

local forwardCorner = Instance.new("UICorner")
forwardCorner.CornerRadius = UDim.new(0, 8)
forwardCorner.Parent = forwardBtn

-- 引擎状态
local engineLabel = Instance.new("TextLabel")
engineLabel.Size = UDim2.new(0.8, 0, 0, 25)
engineLabel.Position = UDim2.new(0.1, 0, 0, 280)
engineLabel.BackgroundTransparency = 1
engineLabel.Text = "引擎运行中（已开启）"
engineLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
engineLabel.TextSize = 14
engineLabel.TextXAlignment = Enum.TextXAlignment.Center
engineLabel.Font = Enum.Font.GothamBold
engineLabel.Parent = mainFrame

-- 后退按钮
local backwardBtn = Instance.new("TextButton")
backwardBtn.Size = UDim2.new(0.8, 0, 0, 40)
backwardBtn.Position = UDim2.new(0.1, 0, 0, 310)
backwardBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
backwardBtn.BackgroundTransparency = 0.2
backwardBtn.Text = "后退"
backwardBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
backwardBtn.TextSize = 18
backwardBtn.Font = Enum.Font.GothamBold
backwardBtn.BorderSizePixel = 0
backwardBtn.Parent = mainFrame

local backwardCorner = Instance.new("UICorner")
backwardCorner.CornerRadius = UDim.new(0, 8)
backwardCorner.Parent = backwardBtn

-- ========== 功能逻辑 ==========
local speed = 90
local accelEnabled = false
local steerEnabled = false
local boardEnabled = false
local assistEnabled = false
local followEnabled = false
local engineRunning = true
local isInVehicle = false
local currentSpeed = 0
local targetSpeed = 0

-- 速度输入
speedInput.FocusLost:Connect(function()
    local val = tonumber(speedInput.Text)
    if val and val > 0 then
        speed = val
        speedInput.Text = tostring(speed)
    else
        speedInput.Text = tostring(speed)
    end
    print("速度上限已设为: " .. speed)
end)

-- 线性加速切换
accelToggle.MouseButton1Click:Connect(function()
    accelEnabled = not accelEnabled
    accelToggle.Text = accelEnabled and "lin_bobo77" or "lin_bobo77"
    accelToggle.BackgroundColor3 = accelEnabled and Color3.fromRGB(0, 200, 50) or Color3.fromRGB(200, 50, 50)
    print("线性加速: " .. (accelEnabled and "开启" or "关闭"))
end)

-- 线性转向切换
steerToggle.MouseButton1Click:Connect(function()
    steerEnabled = not steerEnabled
    steerToggle.Text = steerEnabled and "线性转向" or "线性转向"
    steerToggle.BackgroundColor3 = steerEnabled and Color3.fromRGB(0, 200, 50) or Color3.fromRGB(200, 50, 50)
    print("线性转向: " .. (steerEnabled and "开启" or "关闭"))
end)

-- 上车检测切换
boardToggle.MouseButton1Click:Connect(function()
    if not isInVehicle then
        print("未检测到上车，无法开启")
        return
    end
    boardEnabled = not boardEnabled
    boardToggle.Text = boardEnabled and "已上车" or "未上车"
    boardToggle.BackgroundColor3 = boardEnabled and Color3.fromRGB(0, 200, 50) or Color3.fromRGB(200, 50, 50)
    print("上车检测: " .. (boardEnabled and "开启" or "关闭"))
end)

-- 横向移动辅助切换
assistToggle.MouseButton1Click:Connect(function()
    assistEnabled = not assistEnabled
    assistToggle.Text = assistEnabled and "已开启" or "已关闭"
    assistToggle.BackgroundColor3 = assistEnabled and Color3.fromRGB(0, 200, 50) or Color3.fromRGB(200, 50, 50)
    print("横向移动辅助: " .. (assistEnabled and "已开启" or "已关闭"))
end)

-- 车头跟随切换
followToggle.MouseButton1Click:Connect(function()
    followEnabled = not followEnabled
    followToggle.Text = followEnabled and "已开启" or "已关闭"
    followToggle.BackgroundColor3 = followEnabled and Color3.fromRGB(0, 200, 50) or Color3.fromRGB(200, 50, 50)
    print("车头跟随: " .. (followEnabled and "已开启" or "已关闭"))
end)

-- 引擎切换
engineLabel.MouseButton1Click:Connect(function()
    engineRunning = not engineRunning
    engineLabel.Text = engineRunning and "引擎运行中（已开启）" or "引擎已关闭（已关闭）"
    engineLabel.TextColor3 = engineRunning and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
    print("引擎: " .. (engineRunning and "已开启" or "已关闭"))
end)

-- ========== 上车检测 ==========
local function CheckInVehicle()
    local char = Player.Character
    if not char then return false end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return false end
    if hum.SeatPart then
        return true
    end
    return false
end

-- 实时检测上车状态
RunService.Heartbeat:Connect(function()
    local newState = CheckInVehicle()
    if newState ~= isInVehicle then
        isInVehicle = newState
        if isInVehicle then
            boardToggle.Text = "已上车"
            boardToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 50)
            print("检测到上车")
        else
            boardToggle.Text = "未上车"
            boardToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            boardEnabled = false
            print("已下车")
        end
    end
end)

-- ========== 前进/后退 ==========
local function GetVehicle()
    local char = Player.Character
    if not char then return nil end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return nil end
    return hum.SeatPart
end

local function GetVehicleRoot(vehicle)
    if not vehicle then return nil end
    local root = vehicle:FindFirstChild("HumanoidRootPart") or vehicle:FindFirstChild("PrimaryPart")
    if not root then
        root = vehicle:FindFirstChildOfClass("BasePart")
    end
    return root
end

local function ApplyForce(forward)
    local char = Player.Character
    if not char then return end
    if not engineRunning then return end
    if not isInVehicle then return end
    
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    local vehicle = hum.SeatPart
    if not vehicle then return end
    
    local root = GetVehicleRoot(vehicle)
    if not root then return end
    
    local dir = forward and root.CFrame.LookVector or -root.CFrame.LookVector
    local force = dir * (forward and 1 or -1) * speed * 0.5
    
    if accelEnabled then
        -- 线性加速：从0慢慢加速到目标速度
        currentSpeed = currentSpeed + (speed - currentSpeed) * 0.05
        local currentForce = dir * (forward and 1 or -1) * currentSpeed * 0.5
        root.Velocity = root.Velocity + currentForce * 0.1
    else
        -- 直接达到目标速度
        root.Velocity = dir * (forward and 1 or -1) * speed * 0.3
    end
    
    -- 车头跟随：摄像头方向
    if followEnabled then
        local camLook = Camera.CFrame.LookVector
        local flatLook = Vector3.new(camLook.X, 0, camLook.Z).Unit
        if flatLook.Magnitude > 0.1 then
            root.CFrame = CFrame.new(root.Position, root.Position + flatLook)
        end
    end
end

-- 前进按钮
forwardBtn.MouseButton1Down:Connect(function()
    if not isInVehicle then
        print("未上车，无法前进")
        return
    end
    ApplyForce(true)
end)

forwardBtn.MouseButton1Up:Connect(function()
    currentSpeed = 0
end)

-- 后退按钮
backwardBtn.MouseButton1Down:Connect(function()
    if not isInVehicle then
        print("未上车，无法后退")
        return
    end
    ApplyForce(false)
end)

backwardBtn.MouseButton1Up:Connect(function()
    currentSpeed = 0
end)

-- 键盘控制
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.W then
        forwardBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        forwardBtn.BackgroundTransparency = 0.1
        if isInVehicle and engineRunning then
            ApplyForce(true)
        end
    end
    if input.KeyCode == Enum.KeyCode.S then
        backwardBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        backwardBtn.BackgroundTransparency = 0.1
        if isInVehicle and engineRunning then
            ApplyForce(false)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.W then
        forwardBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 50)
        forwardBtn.BackgroundTransparency = 0.2
        currentSpeed = 0
    end
    if input.KeyCode == Enum.KeyCode.S then
        backwardBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        backwardBtn.BackgroundTransparency = 0.2
        currentSpeed = 0
    end
end)

-- ========== 速度限制 ==========
RunService.Heartbeat:Connect(function()
    local char = Player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local vel = hrp.Velocity
    local speedVal = vel.Magnitude
    if speedVal > speed then
        local ratio = speed / speedVal
        hrp.Velocity = vel * ratio
    end
end)

-- ========== 车头跟随循环 ==========
RunService.Heartbeat:Connect(function()
    if not followEnabled then return end
    if not isInVehicle then return end
    
    local char = Player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    local vehicle = hum.SeatPart
    if not vehicle then return end
    
    local root = GetVehicleRoot(vehicle)
    if not root then return end
    
    local camLook = Camera.CFrame.LookVector
    local flatLook = Vector3.new(camLook.X, 0, camLook.Z).Unit
    if flatLook.Magnitude > 0.1 then
        root.CFrame = CFrame.new(root.Position, root.Position + flatLook)
    end
end)

print("Car Speed Gui 已加载")
print("速度上限可自定义输入")
print("上车检测: 上车后自动识别")
print("车头跟随: 开启后摄像头方向控制车头")