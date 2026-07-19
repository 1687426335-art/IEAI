-- ========== 飞车控制 V5（视角控制版） ==========
-- 视角朝哪飞哪 | WASD控制 | 空格上升 | Shift下降

local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera

local carFlyEnabled = false
local carSpeed = 50
local carBV = nil
local carBG = nil
local flyConn = nil

-- ==================== 过检测 ====================
local bypassActive = false
local bypassConnections = {}

local function startBypass()
    if bypassActive then return end
    bypassActive = true
    print("🛡️ 启动过检测...")
    pcall(function()
        local oldKick = player.Kick
        player.Kick = function(self, msg) print("🛡️ 拦截踢出: " .. tostring(msg)) return nil end
        table.insert(bypassConnections, {Disconnect = function() player.Kick = oldKick end})
    end)
    pcall(function()
        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                local conn = hum.HealthChanged:Connect(function()
                    if hum.Health <= 0 then
                        task.wait(0.1)
                        if hum and hum.Parent then hum.Health = hum.MaxHealth end
                    end
                end)
                table.insert(bypassConnections, conn)
            end
        end
    end)
    pcall(function()
        local function antiTeleport()
            local char = player.Character
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
        player.CharacterAdded:Connect(function() task.wait(0.5) antiTeleport() end)
    end)
    pcall(function()
        local VirtualUser = game:GetService("VirtualUser")
        local conn = RunService.Heartbeat:Connect(function()
            if math.random(1, 100) > 95 then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end
        end)
        table.insert(bypassConnections, conn)
    end)
    pcall(function()
        local TeleportService = game:GetService("TeleportService")
        local conn = player:GetPropertyChangedSignal("Parent"):Connect(function()
            if not player.Parent then
                print("🔄 被踢出，重连中...")
                task.wait(2)
                TeleportService:Teleport(game.PlaceId, player)
            end
        end)
        table.insert(bypassConnections, conn)
    end)
    print("✅ 过检测已启动")
end

-- ==================== 飞车核心 ====================
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
        
        local moveForward = 0
        local moveBackward = 0
        local moveLeft = 0
        local moveRight = 0
        local moveUp = 0
        local moveDown = 0
        
        -- 按键监听
        local keyBegan = UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.KeyCode == Enum.KeyCode.W then moveForward = 1 end
            if input.KeyCode == Enum.KeyCode.S then moveBackward = 1 end
            if input.KeyCode == Enum.KeyCode.A then moveLeft = 1 end
            if input.KeyCode == Enum.KeyCode.D then moveRight = 1 end
            if input.KeyCode == Enum.KeyCode.Space then moveUp = 1 end
            if input.KeyCode == Enum.KeyCode.LeftShift then moveDown = 1 end
        end)
        
        local keyEnded = UserInputService.InputEnded:Connect(function(input, gp)
            if gp then return end
            if input.KeyCode == Enum.KeyCode.W then moveForward = 0 end
            if input.KeyCode == Enum.KeyCode.S then moveBackward = 0 end
            if input.KeyCode == Enum.KeyCode.A then moveLeft = 0 end
            if input.KeyCode == Enum.KeyCode.D then moveRight = 0 end
            if input.KeyCode == Enum.KeyCode.Space then moveUp = 0 end
            if input.KeyCode == Enum.KeyCode.LeftShift then moveDown = 0 end
        end)
        
        flyConn = RunService.Heartbeat:Connect(function()
            if not carFlyEnabled then
                if flyConn then flyConn:Disconnect(); flyConn = nil end
                keyBegan:Disconnect()
                keyEnded:Disconnect()
                return
            end
            if not hrp or not hrp.Parent then
                carFlyEnabled = false
                if flyConn then flyConn:Disconnect(); flyConn = nil end
                keyBegan:Disconnect()
                keyEnded:Disconnect()
                return
            end
            
            -- 视角方向
            local look = Camera.CFrame.LookVector
            local right = Camera.CFrame.RightVector
            local up = Camera.CFrame.UpVector
            
            -- 计算移动方向
            local moveDir = Vector3.new(0, 0, 0)
            moveDir = moveDir + look * (moveForward - moveBackward) * carSpeed
            moveDir = moveDir + right * (moveRight - moveLeft) * carSpeed
            moveDir = moveDir + up * (moveUp - moveDown) * carSpeed
            
            if moveDir.Magnitude > 0 then
                carBV.Velocity = moveDir
                hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + look)
            else
                -- 悬停
                carBV.Velocity = Vector3.new(0, 0, 0)
            end
            
            carBG.CFrame = Camera.CFrame
        end)
        
        -- 升空
        task.spawn(function()
            local targetHeight = hrp.Position.Y + 15
            while carFlyEnabled and hrp and hrp.Parent do
                if hrp.Position.Y < targetHeight then
                    if carBV then
                        carBV.Velocity = Vector3.new(0, 20, 0)
                    end
                else
                    break
                end
                task.wait(0.1)
            end
        end)
        
    else
        print("❌ 飞车关闭")
        if carBV then carBV:Destroy(); carBV = nil end
        if carBG then carBG:Destroy(); carBG = nil end
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then hum.PlatformStand = false end
        end
    end
end

-- ==================== 创建悬浮窗 ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = CoreGui
screenGui.Name = "CarFly"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 200, 0, 180)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -90)
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
titleText.TextColor3 = Color3.fromRGB(0, 200, 255)
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
speedLabel.Text = "速度: 50"
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
speedInput.Text = "50"
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

-- ========== 状态标签 ==========
local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = mainFrame
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 1, -25)
statusLabel.Text = "🛡️ 过检测已启动"
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham

-- ========== 按钮事件 ==========
toggleBtn.MouseButton1Click:Connect(toggleCarFly)

-- ========== 快捷键 ==========
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.G then
        toggleCarFly()
    end
end)

-- ========== 角色重生 ==========
player.CharacterAdded:Connect(function()
    task.wait(0.5)
    if carFlyEnabled then
        carFlyEnabled = false
        if carBV then carBV:Destroy(); carBV = nil end
        if carBG then carBG:Destroy(); carBG = nil end
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        toggleBtn.Text = "🚗 飞车: 关"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end
end)

-- ==================== 启动过检测 ====================
task.wait(0.5)
startBypass()

print("========================================")
print("  ✅ 飞车控制 加载成功")
print("  点击按钮 或 按 G 键 开关")
print("  视角控制方向 | 速度1-200可调")
print("  W前 S后 A左 D右 | 空格上升 Shift下降")
print("  🛡️ 过检测已启动")
print("========================================")