-- ========== wdfex 飞车+飞天 过检测版 ==========
-- 功能：飞车 | 飞天 | 过检测（防踢/防拉回/防死亡/速度伪装）
-- 操作：点击按钮开关 | 按 F 开关飞天 | 按 G 开关飞车

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")

local carFlyEnabled = false
local flyEnabled = false
local flySpeed = 50
local carSpeed = 80
local carBV = nil
local carBG = nil
local flyBV = nil
local flyBG = nil
local flyConn = nil

-- ==================== 过检测系统 ====================
local bypassActive = false
local bypassConnections = {}

local function startBypass()
    if bypassActive then return end
    bypassActive = true
    print("🛡️ 启动过检测...")

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

    -- 6. 伪装速度数据
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local conn = RunService.Heartbeat:Connect(function()
                    if hrp and hrp.Parent then
                        local realVel = hrp.Velocity
                        if realVel.Magnitude > 50 then
                            hrp.Velocity = realVel * 0.5
                            task.wait(0.03)
                            hrp.Velocity = realVel
                        end
                    end
                end)
                table.insert(bypassConnections, conn)
            end
        end
    end)

    print("✅ 过检测已启动 (6层防护)")
end

-- ==================== 飞天功能（含过检测） ====================
local function toggleFly()
    flyEnabled = not flyEnabled
    
    if flyEnabled then
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if not hrp or not hum then return end
        
        print("✈️ 飞天开启")
        hum.PlatformStand = true
        
        flyBV = Instance.new("BodyVelocity")
        flyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        flyBV.Velocity = Vector3.new(0, 0, 0)
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
                if flyConn then
                    flyConn:Disconnect()
                    flyConn = nil
                end
                return
            end
            
            local move = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                move = move + Camera.CFrame.LookVector * flySpeed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                move = move - Camera.CFrame.LookVector * flySpeed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                move = move - Camera.CFrame.RightVector * flySpeed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                move = move + Camera.CFrame.RightVector * flySpeed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                move = Vector3.new(0, flySpeed * 1.5, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                move = Vector3.new(0, -flySpeed * 0.8, 0)
            end
            
            if move.Magnitude > 0 then
                flyBV.Velocity = move
            else
                flyBV.Velocity = Vector3.new(0, 0, 0)
            end
            flyBG.CFrame = Camera.CFrame
        end)
        
    else
        print("✈️ 飞天关闭")
        if flyBV then flyBV:Destroy(); flyBV = nil end
        if flyBG then flyBG:Destroy(); flyBG = nil end
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then hum.PlatformStand = false end
        end
    end
end

-- ==================== 飞车功能（含过检测） ====================
local function toggleCarFly()
    carFlyEnabled = not carFlyEnabled
    
    if carFlyEnabled then
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if not hrp or not hum then return end
        
        print("🚗 飞车开启")
        hum.PlatformStand = true
        
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
        
        -- 飞控循环
        if flyConn then flyConn:Disconnect() end
        flyConn = RunService.Heartbeat:Connect(function()
            if not carFlyEnabled then
                if flyConn then
                    flyConn:Disconnect()
                    flyConn = nil
                end
                return
            end
            if not hrp or not hrp.Parent then
                carFlyEnabled = false
                if flyConn then
                    flyConn:Disconnect()
                    flyConn = nil
                end
                return
            end
            if carBV and carBG then
                carBV.Velocity = Camera.CFrame.LookVector * carSpeed
                carBG.CFrame = Camera.CFrame
            end
        end)
        
        -- 自动升空
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
        print("🚗 飞车关闭")
        if carBV then carBV:Destroy(); carBV = nil end
        if carBG then carBG:Destroy(); carBG = nil end
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then hum.PlatformStand = false end
        end
    end
end

-- ==================== 创建悬浮窗 ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = CoreGui
screenGui.Name = "wdfexFly"
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

-- 标题
local titleText = Instance.new("TextLabel")
titleText.Parent = mainFrame
titleText.Size = UDim2.new(1, 0, 0, 30)
titleText.Position = UDim2.new(0, 0, 0, 0)
titleText.Text = "🚀 wdfex飞行"
titleText.TextColor3 = Color3.fromRGB(0, 200, 255)
titleText.BackgroundTransparency = 1
titleText.TextSize = 15
titleText.Font = Enum.Font.GothamBold

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = mainFrame
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 2)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.BackgroundTransparency = 1
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- 飞天按钮
local flyBtn = Instance.new("TextButton")
flyBtn.Parent = mainFrame
flyBtn.Size = UDim2.new(0, 160, 0, 35)
flyBtn.Position = UDim2.new(0.5, -80, 0, 40)
flyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
flyBtn.Text = "✈️ 飞天: 关"
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.TextSize = 15
flyBtn.Font = Enum.Font.GothamBold
flyBtn.BorderSizePixel = 0

local flyCorner = Instance.new("UICorner")
flyCorner.Parent = flyBtn
flyCorner.CornerRadius = UDim.new(0, 8)

flyBtn.MouseButton1Click:Connect(function()
    toggleFly()
    flyBtn.Text = flyEnabled and "✈️ 飞天: 开" or "✈️ 飞天: 关"
    flyBtn.BackgroundColor3 = flyEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)
end)

-- 飞车按钮
local carBtn = Instance.new("TextButton")
carBtn.Parent = mainFrame
carBtn.Size = UDim2.new(0, 160, 0, 35)
carBtn.Position = UDim2.new(0.5, -80, 0, 85)
carBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
carBtn.Text = "🚗 飞车: 关"
carBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
carBtn.TextSize = 15
carBtn.Font = Enum.Font.GothamBold
carBtn.BorderSizePixel = 0

local carCorner = Instance.new("UICorner")
carCorner.Parent = carBtn
carCorner.CornerRadius = UDim.new(0, 8)

carBtn.MouseButton1Click:Connect(function()
    toggleCarFly()
    carBtn.Text = carFlyEnabled and "🚗 飞车: 开" or "🚗 飞车: 关"
    carBtn.BackgroundColor3 = carFlyEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)
end)

-- 状态标签
local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = mainFrame
statusLabel.Size = UDim2.new(1, 0, 0, 18)
statusLabel.Position = UDim2.new(0, 0, 1, -22)
statusLabel.Text = "🛡️ 过检测已启动"
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.Gotham

-- ========== 快捷键 ==========
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F then
        toggleFly()
        flyBtn.Text = flyEnabled and "✈️ 飞天: 开" or "✈️ 飞天: 关"
        flyBtn.BackgroundColor3 = flyEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)
    end
    if input.KeyCode == Enum.KeyCode.G then
        toggleCarFly()
        carBtn.Text = carFlyEnabled and "🚗 飞车: 开" or "🚗 飞车: 关"
        carBtn.BackgroundColor3 = carFlyEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)
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
        flyBtn.Text = "✈️ 飞天: 关"
        flyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end
    if carFlyEnabled then
        carFlyEnabled = false
        if carBV then carBV:Destroy(); carBV = nil end
        if carBG then carBG:Destroy(); carBG = nil end
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        carBtn.Text = "🚗 飞车: 关"
        carBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end
end)

-- ==================== 启动过检测 ====================
task.wait(0.5)
startBypass()

print("========================================")
print("  ✅ wdfex飞车+飞天 过检测版 加载成功")
print("  点击按钮 或 按 F 键 开关飞天")
print("  点击按钮 或 按 G 键 开关飞车")
print("  WASD 控制方向 | 空格上升 Shift下降")
print("  🛡️ 6层过检测已启动")
print("========================================")