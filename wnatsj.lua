-- ========== wdfex 出租车刷钱1.0 ==========
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = Player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 240, 0, 220)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 3
mainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local outerGlow = Instance.new("Frame")
outerGlow.Size = UDim2.new(1, 12, 1, 12)
outerGlow.Position = UDim2.new(0, -6, 0, -6)
outerGlow.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
outerGlow.BackgroundTransparency = 0.7
outerGlow.BorderSizePixel = 0
outerGlow.ZIndex = 0
outerGlow.Parent = mainFrame

local outerGlowCorner = Instance.new("UICorner")
outerGlowCorner.CornerRadius = UDim.new(0, 16)
outerGlowCorner.Parent = outerGlow

local glowBorder = Instance.new("Frame")
glowBorder.Size = UDim2.new(1, 6, 1, 6)
glowBorder.Position = UDim2.new(0, -3, 0, -3)
glowBorder.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
glowBorder.BackgroundTransparency = 0.4
glowBorder.BorderSizePixel = 0
glowBorder.ZIndex = 1
glowBorder.Parent = mainFrame

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 14)
glowCorner.Parent = glowBorder

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 100, 0)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 255, 200)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 100, 255)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(200, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
})
gradient.Rotation = 0
gradient.Parent = glowBorder

-- 关闭按钮 (右上角X)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.BackgroundTransparency = 0.2
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeButton

local closeGlow = Instance.new("Frame")
closeGlow.Size = UDim2.new(1, 8, 1, 8)
closeGlow.Position = UDim2.new(0, -4, 0, -4)
closeGlow.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeGlow.BackgroundTransparency = 0.5
closeGlow.BorderSizePixel = 0
closeGlow.ZIndex = 0
closeGlow.Parent = closeButton

local closeGlowCorner = Instance.new("UICorner")
closeGlowCorner.CornerRadius = UDim.new(1, 0)
closeGlowCorner.Parent = closeGlow

closeButton.MouseButton1Click:Connect(function()
    isRunning = false
    if loopThread then
        loopThread = nil
    end
    task.wait(0.1)
    if screenGui and screenGui.Parent then
        screenGui:Destroy()
    end
    print("脚本已退出")
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 35)
title.Position = UDim2.new(0, 5, 0, 5)
title.BackgroundTransparency = 1
title.Text = "wdfex 出租车刷钱1.0"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Center
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleLine = Instance.new("Frame")
titleLine.Size = UDim2.new(0.8, 0, 0, 3)
titleLine.Position = UDim2.new(0.1, 0, 0, 40)
titleLine.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
titleLine.BorderSizePixel = 0
titleLine.Parent = mainFrame

local titleLineGlow = Instance.new("Frame")
titleLineGlow.Size = UDim2.new(1, 10, 1, 6)
titleLineGlow.Position = UDim2.new(0, -5, 0, -1.5)
titleLineGlow.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
titleLineGlow.BackgroundTransparency = 0.6
titleLineGlow.BorderSizePixel = 0
titleLineGlow.Parent = titleLine

local lineGradient = Instance.new("UIGradient")
lineGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 100, 0)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
})
lineGradient.Parent = titleLine

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 48)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "已停止"
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
statusLabel.TextScaled = true
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

local orderCountLabel = Instance.new("TextLabel")
orderCountLabel.Size = UDim2.new(0.5, 0, 0, 25)
orderCountLabel.Position = UDim2.new(0, 10, 0, 78)
orderCountLabel.BackgroundTransparency = 1
orderCountLabel.Text = "接单: 0"
orderCountLabel.TextColor3 = Color3.fromRGB(255, 70, 70)
orderCountLabel.TextScaled = true
orderCountLabel.TextXAlignment = Enum.TextXAlignment.Left
orderCountLabel.Font = Enum.Font.GothamBold
orderCountLabel.Parent = mainFrame

local teleportCountLabel = Instance.new("TextLabel")
teleportCountLabel.Size = UDim2.new(0.5, 0, 0, 25)
teleportCountLabel.Position = UDim2.new(0.5, 0, 0, 78)
teleportCountLabel.BackgroundTransparency = 1
teleportCountLabel.Text = "传送: 0"
teleportCountLabel.TextColor3 = Color3.fromRGB(70, 150, 255)
teleportCountLabel.TextScaled = true
teleportCountLabel.TextXAlignment = Enum.TextXAlignment.Left
teleportCountLabel.Font = Enum.Font.GothamBold
teleportCountLabel.Parent = mainFrame

local orderStatusLabel = Instance.new("TextLabel")
orderStatusLabel.Size = UDim2.new(1, 0, 0, 22)
orderStatusLabel.Position = UDim2.new(0, 10, 0, 105)
orderStatusLabel.BackgroundTransparency = 1
orderStatusLabel.Text = "等待接单..."
orderStatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
orderStatusLabel.TextScaled = true
orderStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
orderStatusLabel.Font = Enum.Font.Gotham
orderStatusLabel.Parent = mainFrame

local dotIndicator = Instance.new("Frame")
dotIndicator.Size = UDim2.new(0, 14, 0, 14)
dotIndicator.Position = UDim2.new(0, 0, 0, 48)
dotIndicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
dotIndicator.BorderSizePixel = 0
dotIndicator.Parent = mainFrame

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = dotIndicator

local dotGlow = Instance.new("Frame")
dotGlow.Size = UDim2.new(1, 12, 1, 12)
dotGlow.Position = UDim2.new(0, -6, 0, -6)
dotGlow.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
dotGlow.BackgroundTransparency = 0.6
dotGlow.BorderSizePixel = 0
dotGlow.Parent = dotIndicator

local dotGlowCorner = Instance.new("UICorner")
dotGlowCorner.CornerRadius = UDim.new(1, 0)
dotGlowCorner.Parent = dotGlow

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 140, 0, 40)
toggleButton.Position = UDim2.new(0.5, -70, 0, 150)
toggleButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
toggleButton.Text = "启动"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold
toggleButton.BorderSizePixel = 0
toggleButton.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = toggleButton

local btnOuterGlow = Instance.new("Frame")
btnOuterGlow.Size = UDim2.new(1, 12, 1, 12)
btnOuterGlow.Position = UDim2.new(0, -6, 0, -6)
btnOuterGlow.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
btnOuterGlow.BackgroundTransparency = 0.7
btnOuterGlow.BorderSizePixel = 0
btnOuterGlow.ZIndex = 0
btnOuterGlow.Parent = toggleButton

local btnOuterCorner = Instance.new("UICorner")
btnOuterCorner.CornerRadius = UDim.new(0, 11)
btnOuterCorner.Parent = btnOuterGlow

local btnGlow = Instance.new("Frame")
btnGlow.Size = UDim2.new(1, 6, 1, 6)
btnGlow.Position = UDim2.new(0, -3, 0, -3)
btnGlow.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
btnGlow.BackgroundTransparency = 0.5
btnGlow.BorderSizePixel = 0
btnGlow.ZIndex = 0
btnGlow.Parent = toggleButton

local btnGlowCorner = Instance.new("UICorner")
btnGlowCorner.CornerRadius = UDim.new(0, 10)
btnGlowCorner.Parent = btnGlow

local hue = 0

local function UpdateGlow()
    hue = (hue + 0.8) % 360
    local angle = (hue / 360) * 360
    gradient.Rotation = angle
    lineGradient.Rotation = angle
    
    local r = math.floor((math.sin(hue * math.pi / 180) * 0.5 + 0.5) * 255)
    local g = math.floor((math.sin((hue + 120) * math.pi / 180) * 0.5 + 0.5) * 255)
    local b = math.floor((math.sin((hue + 240) * math.pi / 180) * 0.5 + 0.5) * 255)
    
    local borderColor = Color3.fromRGB(r, g, b)
    mainFrame.BorderColor3 = borderColor
    glowBorder.BackgroundColor3 = borderColor
    outerGlow.BackgroundColor3 = borderColor
    btnGlow.BackgroundColor3 = borderColor
    btnOuterGlow.BackgroundColor3 = borderColor
    titleLine.BackgroundColor3 = borderColor
    titleLineGlow.BackgroundColor3 = borderColor
end

RunService.Heartbeat:Connect(UpdateGlow)

local isRunning = false
local loopThread = nil
local orderCount = 0
local teleportCount = 0

local screenSize = workspace.CurrentCamera.ViewportSize
local phoneX = screenSize.X * 0.85
local phoneY = screenSize.Y * 0.35

local function ClickAt(x, y)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
    task.wait(0.05)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

-- 循环点击接单区域，直到成功
local function AcceptOrder()
    local success = false
    for attempt = 1, 20 do  -- 尝试20次
        if not isRunning then break end
        ClickAt(phoneX, phoneY)
        task.wait(0.2)
        ClickAt(phoneX, phoneY + 100)
        task.wait(0.2)
        ClickAt(phoneX, phoneY + 160)
        task.wait(0.2)
        ClickAt(phoneX, phoneY + 240)
        task.wait(0.3)
        
        -- 检查是否接到订单（有客户位置文字或者订单状态变化）
        local hasOrder = false
        for _, gui in pairs(Player.PlayerGui:GetDescendants()) do
            if gui:IsA("TextLabel") or gui:IsA("TextButton") then
                local text = gui.Text or ""
                if text:find("前往客户位置") or text:find("客户位置") or text:find("目的地") or text:find("送达") then
                    hasOrder = true
                    break
                end
            end
        end
        
        if hasOrder then
            success = true
            break
        end
        
        task.wait(0.3)
    end
    
    if success then
        orderCount = orderCount + 1
        orderCountLabel.Text = "接单: " .. orderCount
        print("已接单")
        return true
    else
        print("未接到订单，继续循环")
        return false
    end
end

local function GetTargetPosition()
    local targetFolder = workspace.Gameplay and workspace.Gameplay.Entities and workspace.Gameplay.Entities.ClientContent
    if not targetFolder then 
        -- 尝试其他路径
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= Player.Character then
                local isPlayer = false
                for _, p in pairs(Players:GetPlayers()) do
                    if p.Character == obj then isPlayer = true; break end
                end
                if not isPlayer then
                    local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("PrimaryPart")
                    if root then
                        return root.Position + Vector3.new(0, 3, 0)
                    end
                end
            end
        end
        return nil
    end
    for _, child in ipairs(targetFolder:GetDescendants()) do
        if child:IsA("BasePart") then
            return child.Position + Vector3.new(0, 3, 0)
        end
    end
    return nil
end

local function TeleportCharacter(targetPos)
    local char = Player.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid and humanoid.SeatPart then
        humanoid.Sit = false
        task.wait(0.1)
    end
    
    hrp.CFrame = CFrame.new(targetPos)
    hrp.Velocity = Vector3.new(0, 0, 0)
    hrp.RotVelocity = Vector3.new(0, 0, 0)
    return true
end

local function UpdateUI(isActive)
    if isActive then
        statusLabel.Text = "运行中"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        toggleButton.Text = "停止"
        toggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        dotIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        dotGlow.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    else
        statusLabel.Text = "已停止"
        statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        toggleButton.Text = "启动"
        toggleButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        dotIndicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        dotGlow.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        orderStatusLabel.Text = "等待接单..."
    end
end

local function StopLoop()
    isRunning = false
    if loopThread then
        loopThread = nil
    end
    UpdateUI(false)
end

local function StartLoop()
    if isRunning then return end
    isRunning = true
    UpdateUI(true)
    
    loopThread = coroutine.create(function()
        print("自动出租车已启动 - 无限循环接单")
        
        while isRunning do
            -- ==== 第一阶段：无限循环接单 ====
            orderStatusLabel.Text = "正在循环接单..."
            local gotOrder = false
            while not gotOrder and isRunning do
                gotOrder = AcceptOrder()
                if not gotOrder then
                    -- 没接到就继续循环，不等待太久
                    task.wait(0.5)
                end
            end
            
            if not isRunning then break end
            
            -- ==== 第二阶段：传送 ====
            orderStatusLabel.Text = "第1次传送..."
            local targetPos1 = GetTargetPosition()
            if targetPos1 then
                TeleportCharacter(targetPos1)
                teleportCount = teleportCount + 1
                teleportCountLabel.Text = "传送: " .. teleportCount
                print("第1次传送完成")
            else
                warn("未找到目标位置")
            end
            task.wait(1)
            
            orderStatusLabel.Text = "第2次传送..."
            local targetPos2 = GetTargetPosition()
            if targetPos2 then
                TeleportCharacter(targetPos2)
                teleportCount = teleportCount + 1
                teleportCountLabel.Text = "传送: " .. teleportCount
                print("第2次传送完成")
            else
                warn("未找到目标位置")
            end
            
            orderStatusLabel.Text = "订单完成，继续接单..."
            task.wait(1)
        end
    end)
    
    coroutine.resume(loopThread)
end

toggleButton.MouseButton1Click:Connect(function()
    if isRunning then
        StopLoop()
    else
        StartLoop()
    end
end)

Player.CharacterAdded:Connect(function()
    if isRunning then
        task.wait(1)
        local pos = GetTargetPosition()
        if pos then
            pcall(function() TeleportCharacter(pos) end)
        end
    end
end)

UpdateUI(false)
print("UI已加载，点击启动开始")