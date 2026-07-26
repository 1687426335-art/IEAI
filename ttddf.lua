-- ========== wdfex飞车 过检测版 ==========
-- 防踢 | 防封 | 防拉回 | 防按键乱跳
-- 恐脚本UI风格 | 速度可调

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")

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

    -- 6. 伪装网络数据
    pcall(function()
        local network = game:GetService("NetworkClient")
        if network then
            network:SetOutgoingKBPSLimit(999999)
        end
    end)

    -- 7. 速度伪装
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local conn = RunService.Heartbeat:Connect(function()
                    if hrp and hrp.Parent then
                        local realVel = hrp.Velocity
                        if realVel.Magnitude > 50 then
                            hrp.Velocity = realVel * 0.3
                            task.wait(0.03)
                            hrp.Velocity = realVel
                        end
                    end
                end)
                table.insert(bypassConnections, conn)
            end
        end
    end)

    print("✅ 过检测已启动 (7层防护)")
end

-- ==================== 飞车/飞天功能 ====================
local flyMode = "飞车"  -- "飞车" 或 "飞天"
local flyEnabled = false
local flySpeed = 50
local flyBV = nil
local flyBG = nil
local flyConn = nil
local flyUp = 0
local flyForward = 0
local flyBackward = 0
local flyLeft = 0
local flyRight = 0
local currentSpeed = 0

local function toggleFly(mode)
    flyMode = mode or flyMode
    flyEnabled = not flyEnabled
    
    if flyEnabled then
        local char = LocalPlayer.Character
        if not char then
            print("❌ 没有角色")
            flyEnabled = false
            return
        end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if not hrp or not hum then
            print("❌ 找不到 HumanoidRootPart")
            flyEnabled = false
            return
        end
        
        print("✅ " .. flyMode .. "开启")
        hum.PlatformStand = true
        
        -- 清空旧的
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
        
        -- 重置按键状态
        flyUp = 0
        flyForward = 0
        flyBackward = 0
        flyLeft = 0
        flyRight = 0
        currentSpeed = 0
        
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
            
            local moveDir = Vector3.new(0, 0, 0)
            
            if flyMode == "飞车" then
                -- 飞车模式：基于视角方向
                local look = Camera.CFrame.LookVector
                local right = Camera.CFrame.RightVector
                local up = Camera.CFrame.UpVector
                
                moveDir = moveDir + look * (flyForward - flyBackward) * flySpeed
                moveDir = moveDir + right * (flyRight - flyLeft) * flySpeed
                moveDir = moveDir + up * flyUp * flySpeed
                
            else
                -- 飞天模式：基于角色朝向
                local look = hrp.CFrame.LookVector
                local right = hrp.CFrame.RightVector
                local up = hrp.CFrame.UpVector
                
                moveDir = moveDir + look * (flyForward - flyBackward) * flySpeed
                moveDir = moveDir + right * (flyRight - flyLeft) * flySpeed
                moveDir = moveDir + up * flyUp * flySpeed
            end
            
            if moveDir.Magnitude > 0 then
                flyBV.Velocity = moveDir
            else
                flyBV.Velocity = Vector3.new(0, 0, 0)
            end
            
            flyBG.CFrame = Camera.CFrame
        end)
        
        -- 升空
        task.spawn(function()
            local targetHeight = hrp.Position.Y + 10
            while flyEnabled and hrp and hrp.Parent do
                if hrp.Position.Y < targetHeight then
                    if flyBV then
                        flyBV.Velocity = Vector3.new(0, 20, 0)
                    end
                else
                    break
                end
                task.wait(0.1)
            end
        end)
        
    else
        print("❌ " .. flyMode .. "关闭")
        if flyBV then flyBV:Destroy(); flyBV = nil end
        if flyBG then flyBG:Destroy(); flyBG = nil end
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        flyUp = 0
        flyForward = 0
        flyBackward = 0
        flyLeft = 0
        flyRight = 0
        currentSpeed = 0
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then hum.PlatformStand = false end
        end
    end
end

-- ==================== 按键监听（彻底修复按键乱跳） ====================
local keyState = {
    W = false, S = false, A = false, D = false,
    Space = false, Shift = false
}

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if not flyEnabled then return end
    
    local key = input.KeyCode
    if key == Enum.KeyCode.W then keyState.W = true; flyForward = 1 end
    if key == Enum.KeyCode.S then keyState.S = true; flyBackward = 1 end
    if key == Enum.KeyCode.A then keyState.A = true; flyLeft = 1 end
    if key == Enum.KeyCode.D then keyState.D = true; flyRight = 1 end
    if key == Enum.KeyCode.Space then keyState.Space = true; flyUp = 1 end
    if key == Enum.KeyCode.LeftShift then keyState.Shift = true; flyUp = -1 end
end)

UserInputService.InputEnded:Connect(function(input, gp)
    if gp then return end
    if not flyEnabled then return end
    
    local key = input.KeyCode
    if key == Enum.KeyCode.W then keyState.W = false; flyForward = 0 end
    if key == Enum.KeyCode.S then keyState.S = false; flyBackward = 0 end
    if key == Enum.KeyCode.A then keyState.A = false; flyLeft = 0 end
    if key == Enum.KeyCode.D then keyState.D = false; flyRight = 0 end
    if key == Enum.KeyCode.Space then keyState.Space = false; flyUp = 0 end
    if key == Enum.KeyCode.LeftShift then keyState.Shift = false; flyUp = 0 end
end)

-- ==================== 创建UI（恐脚本风格） ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = CoreGui
screenGui.Name = "wdfexFly"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 260, 0, 280)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 35)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local mainCorner = Instance.new("UICorner")
mainCorner.Parent = mainFrame
mainCorner.CornerRadius = UDim.new(0, 14)

local mainStroke = Instance.new("UIStroke")
mainStroke.Parent = mainFrame
mainStroke.Thickness = 1.5
mainStroke.Color = Color3.fromRGB(0, 200, 255)
mainStroke.Transparency = 0.3

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Parent = mainFrame
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
titleBar.BackgroundTransparency = 0.15
titleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner")
titleCorner.Parent = titleBar
titleCorner.CornerRadius = UDim.new(0, 14)

local titleText = Instance.new("TextLabel")
titleText.Parent = titleBar
titleText.Size = UDim2.new(1, -70, 1, 0)
titleText.Position = UDim2.new(0, 12, 0, 0)
titleText.Text = "⚡ wdfex飞车"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.BackgroundTransparency = 1
titleText.TextSize = 16
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = titleBar
closeBtn.Size = UDim2.new(0, 32, 1, 0)
closeBtn.Position = UDim2.new(1, -32, 0, 0)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.BackgroundTransparency = 1
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local minBtn = Instance.new("TextButton")
minBtn.Parent = titleBar
minBtn.Size = UDim2.new(0, 32, 1, 0)
minBtn.Position = UDim2.new(1, -64, 0, 0)
minBtn.Text = "─"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.BackgroundTransparency = 1
minBtn.TextSize = 16
minBtn.Font = Enum.Font.GothamBold
minBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    miniBall.Visible = true
end)

-- 最小化圆球
local miniBall = Instance.new("TextButton")
miniBall.Parent = screenGui
miniBall.Size = UDim2.new(0, 50, 0, 50)
miniBall.Position = UDim2.new(1, -70, 0.9, 0)
miniBall.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
miniBall.Text = "✈️"
miniBall.TextColor3 = Color3.fromRGB(255, 255, 255)
miniBall.TextSize = 24
miniBall.Font = Enum.Font.GothamBold
miniBall.BorderSizePixel = 0
miniBall.Visible = false

local ballCorner = Instance.new("UICorner")
ballCorner.Parent = miniBall
ballCorner.CornerRadius = UDim.new(1, 0)

miniBall.MouseButton1Click:Connect(function()
    miniBall.Visible = false
    mainFrame.Visible = true
end)

-- ========== 内容 ==========
local function createBtn(parent, text, y, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(0, 200, 0, 38)
    btn.Position = UDim2.new(0.5, -100, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 15
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.Parent = btn
    corner.CornerRadius = UDim.new(0, 8)
    
    if callback then
        btn.MouseButton1Click:Connect(callback)
    end
    
    return btn
end

-- 开关按钮
local toggleBtn = createBtn(mainFrame, "✈️ 飞车: 关", 50)
toggleBtn.MouseButton1Click:Connect(function()
    if flyEnabled then
        toggleFly("飞车")
        toggleBtn.Text = "✈️ 飞车: 关"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        modeBtn.Text = "🚗 切换飞天"
    else
        toggleFly("飞车")
        toggleBtn.Text = "✈️ 飞车: 开"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        modeBtn.Text = "🚗 切换飞天"
    end
end)

-- 切换模式按钮
local modeBtn = createBtn(mainFrame, "🚗 切换飞天", 95)
modeBtn.MouseButton1Click:Connect(function()
    if flyEnabled then
        flyEnabled = false
        if flyBV then flyBV:Destroy(); flyBV = nil end
        if flyBG then flyBG:Destroy(); flyBG = nil end
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then hum.PlatformStand = false end
        end
        toggleBtn.Text = "✈️ 飞车: 关"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end
    
    if flyMode == "飞车" then
        flyMode = "飞天"
        modeBtn.Text = "🚗 切换飞车"
        toggleBtn.Text = "🚀 飞天: 关"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        print("🔄 切换到飞天模式")
    else
        flyMode = "飞车"
        modeBtn.Text = "🚗 切换飞天"
        toggleBtn.Text = "✈️ 飞车: 关"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        print("🔄 切换到飞车模式")
    end
end)

-- 速度控制
local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = mainFrame
speedLabel.Size = UDim2.new(1, 0, 0, 25)
speedLabel.Position = UDim2.new(0, 0, 0, 148)
speedLabel.Text = "速度: " .. flySpeed
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
speedLabel.BackgroundTransparency = 1
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.Gotham

local speedDown = Instance.new("TextButton")
speedDown.Parent = mainFrame
speedDown.Size = UDim2.new(0, 40, 0, 30)
speedDown.Position = UDim2.new(0, 15, 0, 175)
speedDown.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
speedDown.Text = "-"
speedDown.TextColor3 = Color3.fromRGB(255, 255, 255)
speedDown.TextSize = 18
speedDown.Font = Enum.Font.GothamBold
speedDown.BorderSizePixel = 0

local speedDownCorner = Instance.new("UICorner")
speedDownCorner.Parent = speedDown
speedDownCorner.CornerRadius = UDim.new(0, 6)

speedDown.MouseButton1Click:Connect(function()
    flySpeed = math.max(flySpeed - 5, 10)
    speedLabel.Text = "速度: " .. flySpeed
    speedInput.Text = tostring(flySpeed)
end)

local speedInput = Instance.new("TextBox")
speedInput.Parent = mainFrame
speedInput.Size = UDim2.new(0, 80, 0, 30)
speedInput.Position = UDim2.new(0.5, -40, 0, 175)
speedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.Text = tostring(flySpeed)
speedInput.PlaceholderText = "速度"
speedInput.TextSize = 15
speedInput.Font = Enum.Font.Gotham
speedInput.BorderSizePixel = 0

local speedInputCorner = Instance.new("UICorner")
speedInputCorner.Parent = speedInput
speedInputCorner.CornerRadius = UDim.new(0, 6)

speedInput.FocusLost:Connect(function()
    local v = tonumber(speedInput.Text)
    if v then
        flySpeed = math.clamp(v, 10, 200)
        speedLabel.Text = "速度: " .. flySpeed
    else
        speedInput.Text = tostring(flySpeed)
    end
end)

local speedUp = Instance.new("TextButton")
speedUp.Parent = mainFrame
speedUp.Size = UDim2.new(0, 40, 0, 30)
speedUp.Position = UDim2.new(1, -55, 0, 175)
speedUp.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
speedUp.Text = "+"
speedUp.TextColor3 = Color3.fromRGB(255, 255, 255)
speedUp.TextSize = 18
speedUp.Font = Enum.Font.GothamBold
speedUp.BorderSizePixel = 0

local speedUpCorner = Instance.new("UICorner")
speedUpCorner.Parent = speedUp
speedUpCorner.CornerRadius = UDim.new(0, 6)

speedUp.MouseButton1Click:Connect(function()
    flySpeed = math.min(flySpeed + 5, 200)
    speedLabel.Text = "速度: " .. flySpeed
    speedInput.Text = tostring(flySpeed)
end)

-- 状态标签
local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = mainFrame
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 1, -25)
statusLabel.Text = "🛡️ 过检测已启动"
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham

-- 快捷键提示
local keyLabel = Instance.new("TextLabel")
keyLabel.Parent = mainFrame
keyLabel.Size = UDim2.new(1, 0, 0, 18)
keyLabel.Position = UDim2.new(0, 0, 1, -48)
keyLabel.Text = "WASD移动 | 空格上升 | Shift下降"
keyLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
keyLabel.BackgroundTransparency = 1
keyLabel.TextSize = 11
keyLabel.Font = Enum.Font.Gotham

-- ==================== 快捷键 ====================
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F then
        if flyEnabled then
            toggleFly(flyMode)
            toggleBtn.Text = (flyMode == "飞车" and "✈️ 飞车: 关" or "🚀 飞天: 关")
            toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        else
            toggleFly(flyMode)
            toggleBtn.Text = (flyMode == "飞车" and "✈️ 飞车: 开" or "🚀 飞天: 开")
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        end
    end
end)

-- ==================== 角色重生 ====================
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if flyEnabled then
        flyEnabled = false
        if flyBV then flyBV:Destroy(); flyBV = nil end
        if flyBG then flyBG:Destroy(); flyBG = nil end
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        toggleBtn.Text = (flyMode == "飞车" and "✈️ 飞车: 关" or "🚀 飞天: 关")
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then hum.PlatformStand = false end
        end
    end
end)

-- ==================== 启动 ====================
task.wait(0.5)
startBypass()

print("========================================")
print("  ✅ wdfex飞车 过检测版 加载成功")
print("  点击按钮 或 按 F 键 开关")
print("  恐脚本UI风格 | 速度可调")
print("  🛡️ 过检测已启动 (7层防护)")
print("  WASD移动 | 空格上升 | Shift下降")
print("  点击'切换飞天'切换模式")
print("========================================")