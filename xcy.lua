-- 简易飞行悬浮窗开关
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- 创建悬浮窗按钮
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 80, 0, 80)
button.Position = UDim2.new(0.8, 0, 0.7, 0)
button.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 20
button.Text = "飞行: 关"
button.Parent = game.CoreGui

-- 圆角效果
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 40)
corner.Parent = button

-- 飞行状态变量
local flying = false
local bodyVelocity, bodyGyro

-- 飞行功能
local function startFlying()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    -- 创建BodyVelocity控制飞行
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    -- 创建BodyGyro保持平衡
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart
    
    -- 设置人物动画为游泳状态（看起来像飞行）
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Flying)
    end
end

local function stopFlying()
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end
end

-- 按键控制移动
local keysPressed = {}
local moveConnection

local function updateMovement()
    if not flying or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    local camera = workspace.CurrentCamera
    local moveDirection = Vector3.new(0, 0, 0)
    
    -- WASD移动
    if keysPressed["W"] then
        moveDirection = moveDirection + camera.CFrame.LookVector
    end
    if keysPressed["S"] then
        moveDirection = moveDirection - camera.CFrame.LookVector
    end
    if keysPressed["A"] then
        moveDirection = moveDirection - camera.CFrame.RightVector
    end
    if keysPressed["D"] then
        moveDirection = moveDirection + camera.CFrame.RightVector
    end
    if keysPressed["Space"] then
        moveDirection = moveDirection + Vector3.new(0, 1, 0)
    end
    if keysPressed["LeftControl"] then
        moveDirection = moveDirection - Vector3.new(0, 1, 0)
    end
    
    if moveDirection.Magnitude > 0 then
        moveDirection = moveDirection.Unit * 50 -- 飞行速度
        bodyVelocity.Velocity = moveDirection
    else
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
end

-- 按钮点击事件
button.MouseButton1Click:Connect(function()
    flying = not flying
    
    if flying then
        button.Text = "飞行: 开"
        button.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
        startFlying()
        
        -- 开启移动监听
        moveConnection = game:GetService("RunService").RenderStepped:Connect(updateMovement)
    else
        button.Text = "飞行: 关"
        button.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
        stopFlying()
        
        if moveConnection then
            moveConnection:Disconnect()
            moveConnection = nil
        end
    end
end)

-- 键盘监听
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        keysPressed[input.KeyCode.Name] = true
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        keysPressed[input.KeyCode.Name] = nil
    end
end)

-- 玩家死亡或重置时自动停止飞行
player.CharacterAdded:Connect(function()
    if flying then
        flying = false
        button.Text = "飞行: 关"
        button.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
        if moveConnection then
            moveConnection:Disconnect()
            moveConnection = nil
        end
    end
end)