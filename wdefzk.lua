-- ========== 飞车控制 V4 ==========
-- 开启后车辆原地起飞，根据视角方向飞行
-- 速度1-200可调 | 默认50 | 带防检测

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local carFlyEnabled = false
local carSpeed = 50
local carBV = nil
local carBG = nil
local vehicleModel = nil
local bypassActive = false
local bypassConnections = {}

-- ==================== 反挂机 ====================
LocalPlayer.Idled:connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- ==================== 过检测系统 ====================
local function startBypass()
    if bypassActive then return end
    bypassActive = true
    print("🛡️ 飞车过检测启动")

    -- 1. 防踢出
    pcall(function()
        local oldKick = LocalPlayer.Kick
        LocalPlayer.Kick = function(self, msg)
            print("🛡️ 拦截踢出: " .. tostring(msg))
            return nil
        end
        table.insert(bypassConnections, {Disconnect = function()
            LocalPlayer.Kick = oldKick
        end})
    end)

    -- 2. 防死亡
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                local conn = hum.HealthChanged:Connect(function()
                    if hum.Health <= 0 then
                        task.wait(0.1)
                        if hum and hum.Parent then
                            hum.Health = hum.MaxHealth
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
            local char = LocalPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local lastPos = hrp.Position
                    local conn = RunService.Heartbeat:Connect(function()
                        if not hrp or not hrp.Parent then return end
                        if (hrp.Position - lastPos).Magnitude > 100 then
                            hrp.CFrame = CFrame.new(lastPos)
                        end
                        lastPos = hrp.Position
                    end)
                    table.insert(bypassConnections, conn)
                end
            end
        end
        antiTeleport()
        LocalPlayer.CharacterAdded:Connect(function()
            task.wait(0.5)
            antiTeleport()
        end)
    end)

    -- 4. 伪装行为
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
        local conn = LocalPlayer:GetPropertyChangedSignal("Parent"):Connect(function()
            if not LocalPlayer.Parent then
                print("🔄 被踢出，重连中...")
                task.wait(2)
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end
        end)
        table.insert(bypassConnections, conn)
    end)

    print("✅ 飞车过检测已启动")
end

-- ==================== 获取车辆 ====================
local function getVehicle()
    local char = LocalPlayer.Character
    if not char then return nil end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return nil end
    local seat = hum.SeatPart
    if not seat then return nil end
    local model = seat.Parent
    if model and model:IsA("Model") then
        return model
    end
    return nil
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
toggleBtn.Size = UDim2.new(0, 180, 0, 40)
toggleBtn.Position = UDim2.new(0.5, -90, 0, 45)
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
speedLabel.Text = "速度: 50"
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
speedInput.Text = "50"
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

-- 状态标签
local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = mainFrame
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0, 180)
statusLabel.Text = "🛡️ 过检测已启动"
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham

-- ========== 更新速度显示 ==========
local function updateSpeedDisplay()
    speedLabel.Text = "速度: " .. carSpeed
    speedInput.Text = tostring(carSpeed)
end

-- ========== 速度按钮事件 ==========
speedDown.MouseButton1Click:Connect(function()
    carSpeed = math.max(carSpeed - 5, 1)
    updateSpeedDisplay()
    if carFlyEnabled and carBV then
        carBV.Velocity = Camera.CFrame.LookVector * carSpeed
    end
end)

speedUp.MouseButton1Click:Connect(function()
    carSpeed = math.min(carSpeed + 5, 200)
    updateSpeedDisplay()
    if carFlyEnabled and carBV then
        carBV.Velocity = Camera.CFrame.LookVector * carSpeed
    end
end)

speedInput.FocusLost:Connect(function()
    local v = tonumber(speedInput.Text)
    if v then
        carSpeed = math.clamp(v, 1, 200)
        updateSpeedDisplay()
        if carFlyEnabled and carBV then
            carBV.Velocity = Camera.CFrame.LookVector * carSpeed
        end
    else
        updateSpeedDisplay()
    end
end)

-- ========== 飞车核心 ==========
local function toggleCarFly()
    carFlyEnabled = not carFlyEnabled
    
    if carFlyEnabled then
        -- 获取当前车辆
        vehicleModel = getVehicle()
        if not vehicleModel then
            print("❌ 请先坐在车上")
            carFlyEnabled = false
            toggleBtn.Text = "🚗 飞车: 关"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            return
        end
        
        print("✅ 飞车开启")
        toggleBtn.Text = "🚗 飞车: 开"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        
        -- 获取车辆HumanoidRootPart
        local hrp = vehicleModel:FindFirstChild("HumanoidRootPart")
        if not hrp then
            hrp = vehicleModel:FindFirstChild("PrimaryPart")
        end
        if not hrp then
            for _, part in pairs(vehicleModel:GetChildren()) do
                if part:IsA("BasePart") and part.Size.Magnitude > 5 then
                    hrp = part
                    break
                end
            end
        end
        if not hrp then
            print("❌ 找不到车辆主体")
            carFlyEnabled = false
            toggleBtn.Text = "🚗 飞车: 关"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            return
        end
        
        -- 车辆所有部件取消碰撞（防卡）
        for _, part in pairs(vehicleModel:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        
        -- 升空动力
        carBV = Instance.new("BodyVelocity")
        carBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        carBV.Velocity = Vector3.new(0, 20, 0) -- 先升空
        carBV.Parent = hrp
        
        -- 稳定陀螺仪
        carBG = Instance.new("BodyGyro")
        carBG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        carBG.D = 5000
        carBG.P = 50000
        carBG.CFrame = Camera.CFrame
        carBG.Parent = hrp
        
        -- 飞控循环
        RunService.Heartbeat:Connect(function()
            if not carFlyEnabled then return end
            if not hrp or not hrp.Parent then return end
            if carBV and carBG then
                -- 根据视角方向飞行
                carBV.Velocity = Camera.CFrame.LookVector * carSpeed
                carBG.CFrame = Camera.CFrame
            end
        end)
        
        -- 自动升空到一定高度
        local targetHeight = hrp.Position.Y + 15
        task.spawn(function()
            while carFlyEnabled and hrp and hrp.Parent do
                local currentY = hrp.Position.Y
                if currentY < targetHeight then
                    carBV.Velocity = Vector3.new(0, 20, 0)
                else
                    break
                end
                task.wait(0.1)
            end
        end)
        
    else
        print("❌ 飞车关闭")
        toggleBtn.Text = "🚗 飞车: 关"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        
        if carBV then
            carBV:Destroy()
            carBV = nil
        end
        if carBG then
            carBG:Destroy()
            carBG = nil
        end
        
        -- 恢复车辆碰撞
        if vehicleModel then
            for _, part in pairs(vehicleModel:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        vehicleModel = nil
    end
end

toggleBtn.MouseButton1Click:Connect(toggleCarFly)

-- ========== 快捷键 ==========
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.C then
        toggleCarFly()
    end
end)

-- ========== 角色重生 ==========
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if carFlyEnabled then
        carFlyEnabled = false
        if carBV then carBV:Destroy(); carBV = nil end
        if carBG then carBG:Destroy(); carBG = nil end
        toggleBtn.Text = "🚗 飞车: 关"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end
end)

-- ==================== 启动过检测 ====================
task.wait(0.5)
startBypass()

print("========================================")
print("  ✅ 飞车控制 V4 加载成功")
print("  先坐上载具，再点击飞车按钮")
print("  C键 开关飞车 | 速度1-200可调")
print("  🛡️ 过检测已启动")
print("========================================")
