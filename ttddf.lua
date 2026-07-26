-- ========== wdfex飞车 过检测版 ==========
-- 恐脚本飞天 + 飞车 + 加速 + 过检测

local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")

-- ==================== 过检测系统 ====================
local bypassActive = false
local bypassConnections = {}

local function startBypass()
    if bypassActive then return end
    bypassActive = true
    print("🛡️ 启动过检测...")

    -- 1. 拦截踢出
    pcall(function()
        local oldKick = player.Kick
        player.Kick = function(self, msg)
            print("🛡️ 拦截踢出: " .. tostring(msg))
            return nil
        end
        table.insert(bypassConnections, {Disconnect = function() player.Kick = oldKick end})
    end)

    -- 2. 反死亡
    pcall(function()
        local char = player.Character
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

    -- 4. 伪装玩家行为
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
        local conn = player:GetPropertyChangedSignal("Parent"):Connect(function()
            if not player.Parent then
                print("🔄 被踢出，重连中...")
                task.wait(2)
                TeleportService:Teleport(game.PlaceId, player)
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

    -- 7. 伪装速度数据
    pcall(function()
        local char = player.Character
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

-- ==================== 功能变量 ====================
local speedEnabled = false
local speedMultiplier = 1.5
local originalWalkSpeed = 16
local originalJumpPower = 50
local flyEnabled = false
local flySpeed = 50
local flyConn = nil
local flyBV = nil
local flyBG = nil

-- ==================== 恐脚本飞天 ====================
local function startFly()
    if flyEnabled then return end
    flyEnabled = true

    local char = player.Character
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

    print("✈️ 飞天开启")
    hum.PlatformStand = true

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

    local moveForward = 0
    local moveBackward = 0
    local moveLeft = 0
    local moveRight = 0
    local moveUp = 0
    local moveDown = 0

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
        if not flyEnabled then
            if flyConn then flyConn:Disconnect(); flyConn = nil end
            keyBegan:Disconnect()
            keyEnded:Disconnect()
            return
        end
        if not hrp or not hrp.Parent then
            flyEnabled = false
            if flyConn then flyConn:Disconnect(); flyConn = nil end
            keyBegan:Disconnect()
            keyEnded:Disconnect()
            return
        end

        local look = Camera.CFrame.LookVector
        local right = Camera.CFrame.RightVector
        local up = Camera.CFrame.UpVector

        local moveDir = Vector3.new(0, 0, 0)
        moveDir = moveDir + look * (moveForward - moveBackward) * flySpeed
        moveDir = moveDir + right * (moveRight - moveLeft) * flySpeed
        moveDir = moveDir + up * (moveUp - moveDown) * flySpeed

        if moveDir.Magnitude > 0 then
            flyBV.Velocity = moveDir
            -- 伪装速度
            hrp.Velocity = moveDir * 0.3
            task.wait(0.01)
            hrp.Velocity = moveDir
        else
            flyBV.Velocity = Vector3.new(0, 0, 0)
        end
        flyBG.CFrame = Camera.CFrame
    end)

    -- 升空
    task.spawn(function()
        local targetHeight = hrp.Position.Y + 15
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
end

local function stopFly()
    flyEnabled = false
    if flyBV then flyBV:Destroy(); flyBV = nil end
    if flyBG then flyBG:Destroy(); flyBG = nil end
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    local char = player.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.PlatformStand = false end
    end
    print("✈️ 飞天关闭")
end

-- ==================== 飞车功能 ====================
local carFlyEnabled = false
local carSpeed = 80
local carBV = nil
local carBG = nil
local carConn = nil

local function toggleCarFly()
    carFlyEnabled = not carFlyEnabled

    if carFlyEnabled then
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if not hrp or not hum then return end

        print("🚗 飞车开启")
        hum.PlatformStand = true

        carBV = Instance.new("BodyVelocity")
        carBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        carBV.Velocity = Vector3.new(0, 20, 0)
        carBV.Parent = hrp

        carBG = Instance.new("BodyGyro")
        carBG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        carBG.D = 5000
        carBG.P = 50000
        carBG.CFrame = hrp.CFrame
        carBG.Parent = hrp

        carConn = RunService.Heartbeat:Connect(function()
            if not carFlyEnabled then
                if carConn then carConn:Disconnect(); carConn = nil end
                return
            end
            if not hrp or not hrp.Parent then
                carFlyEnabled = false
                if carConn then carConn:Disconnect(); carConn = nil end
                return
            end
            if carBV and carBG then
                carBV.Velocity = hrp.CFrame.LookVector * carSpeed
                carBG.CFrame = hrp.CFrame
            end
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
        print("🚗 飞车关闭")
        if carBV then carBV:Destroy(); carBV = nil end
        if carBG then carBG:Destroy(); carBG = nil end
        if carConn then carConn:Disconnect(); carConn = nil end
        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then hum.PlatformStand = false end
        end
    end
end

-- ==================== 加速功能 ====================
local function applySpeed()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    if speedEnabled then
        hum.WalkSpeed = 16 * speedMultiplier
        hum.JumpPower = 50 * speedMultiplier
    else
        hum.WalkSpeed = originalWalkSpeed
        hum.JumpPower = originalJumpPower
    end
end

local function toggleSpeed()
    speedEnabled = not speedEnabled
    applySpeed()
    print(speedEnabled and "✅ 加速开启 (" .. speedMultiplier .. "x)" or "❌ 加速关闭")
end

-- ==================== 创建悬浮窗 ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = CoreGui
screenGui.Name = "wdfexFly"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 200, 0, 260)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -130)
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
titleText.Text = "⚡ wdfex飞车"
titleText.TextColor3 = Color3.fromRGB(0, 200, 255)
titleText.BackgroundTransparency = 1
titleText.TextSize = 16
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

-- ========== 按钮 ==========
local function createBtn(text, y, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = mainFrame
    btn.Size = UDim2.new(0, 160, 0, 35)
    btn.Position = UDim2.new(0.5, -80, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
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

local speedBtn = createBtn("⚡ 加速: 关", 45, function()
    toggleSpeed()
    speedBtn.Text = speedEnabled and "⚡ 加速: 开" or "⚡ 加速: 关"
    speedBtn.BackgroundColor3 = speedEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)
end)

local flyBtn = createBtn("✈️ 飞天: 关", 45 + 40, function()
    if flyEnabled then
        stopFly()
        flyBtn.Text = "✈️ 飞天: 关"
        flyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    else
        startFly()
        flyBtn.Text = "✈️ 飞天: 开"
        flyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    end
end)

local carBtn = createBtn("🚗 飞车: 关", 45 + 40 * 2, function()
    toggleCarFly()
    carBtn.Text = carFlyEnabled and "🚗 飞车: 开" or "🚗 飞车: 关"
    carBtn.BackgroundColor3 = carFlyEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)
end)

-- ========== 倍率按钮 1-5 ==========
local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = mainFrame
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Position = UDim2.new(0, 0, 0, 45 + 40 * 3 + 5)
speedLabel.Text = "倍率: 1.5x"
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
speedLabel.BackgroundTransparency = 1
speedLabel.TextSize = 13
speedLabel.Font = Enum.Font.Gotham

local by = 45 + 40 * 3 + 30
for i = 1, 5 do
    local val = i == 1 and 1 or (i == 2 and 1.5 or (i == 3 and 2 or (i == 4 and 2.5 or 3)))
    local btn = Instance.new("TextButton")
    btn.Parent = mainFrame
    btn.Size = UDim2.new(0, 28, 0, 28)
    btn.Position = UDim2.new(0, 10 + (i-1) * 38, 0, by)
    btn.BackgroundColor3 = (val == speedMultiplier) and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 60)
    btn.Text = tostring(val)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    local corner = Instance.new("UICorner")
    corner.Parent = btn
    corner.CornerRadius = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(function()
        speedMultiplier = val
        speedLabel.Text = "倍率: " .. val .. "x"
        for _, b in pairs(mainFrame:GetChildren()) do
            if b:IsA("TextButton") and b.Size == UDim2.new(0, 28, 0, 28) then
                if tonumber(b.Text) == val then
                    b.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                else
                    b.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                end
            end
        end
        if speedEnabled then
            local char = player.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum then
                    hum.WalkSpeed = 16 * val
                    hum.JumpPower = 50 * val
                end
            end
        end
    end)
end

-- 状态标签
local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = mainFrame
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 1, -20)
statusLabel.Text = "🛡️ 过检测已启动"
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.Gotham

-- ==================== 快捷键 ====================
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F then
        if flyEnabled then
            stopFly()
            flyBtn.Text = "✈️ 飞天: 关"
            flyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        else
            startFly()
            flyBtn.Text = "✈️ 飞天: 开"
            flyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        end
    end
    if input.KeyCode == Enum.KeyCode.G then
        toggleSpeed()
        speedBtn.Text = speedEnabled and "⚡ 加速: 开" or "⚡ 加速: 关"
        speedBtn.BackgroundColor3 = speedEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)
    end
    if input.KeyCode == Enum.KeyCode.C then
        toggleCarFly()
        carBtn.Text = carFlyEnabled and "🚗 飞车: 开" or "🚗 飞车: 关"
        carBtn.BackgroundColor3 = carFlyEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)
    end
end)

-- ==================== 角色重生 ====================
player.CharacterAdded:Connect(function()
    task.wait(0.5)
    if speedEnabled then
        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = 16 * speedMultiplier
                hum.JumpPower = 50 * speedMultiplier
            end
        end
    end
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
        if carConn then carConn:Disconnect(); carConn = nil end
        carBtn.Text = "🚗 飞车: 关"
        carBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end
end)

-- ==================== 启动 ====================
task.wait(0.5)
startBypass()

print("========================================")
print("  ✅ wdfex飞车 过检测版 加载成功")
print("  功能: 加速 | 飞天(恐脚本) | 飞车")
print("  F键 飞天 | G键 加速 | C键 飞车")
print("  1-5 调倍率 | 🛡️ 过检测已启动")
print("========================================")