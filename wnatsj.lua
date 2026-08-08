-- ========== wdfex 出租车刷钱 ==========
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = Player.PlayerGui

-- ===== 状态变量 =====
local isMinimized = false
local currentTab = "公告"

-- ===== 主窗口 =====
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 240, 0, 280)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 3
mainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
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

-- ===== 最小化球体 =====
local miniBall = Instance.new("Frame")
miniBall.Size = UDim2.new(0, 50, 0, 50)
miniBall.Position = UDim2.new(0.02, 0, 0.8, 0)
miniBall.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
miniBall.BackgroundTransparency = 0.1
miniBall.BorderSizePixel = 2
miniBall.BorderColor3 = Color3.fromRGB(255, 0, 0)
miniBall.Visible = false
miniBall.Active = true
miniBall.Draggable = true
miniBall.Parent = screenGui

local ballCorner = Instance.new("UICorner")
ballCorner.CornerRadius = UDim.new(1, 0)
ballCorner.Parent = miniBall

local ballGlow = Instance.new("Frame")
ballGlow.Size = UDim2.new(1, 12, 1, 12)
ballGlow.Position = UDim2.new(0, -6, 0, -6)
ballGlow.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ballGlow.BackgroundTransparency = 0.6
ballGlow.BorderSizePixel = 0
ballGlow.Parent = miniBall

local ballGlowCorner = Instance.new("UICorner")
ballGlowCorner.CornerRadius = UDim.new(1, 0)
ballGlowCorner.Parent = ballGlow

local ballLabel = Instance.new("TextLabel")
ballLabel.Size = UDim2.new(1, 0, 1, 0)
ballLabel.BackgroundTransparency = 1
ballLabel.Text = "W"
ballLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ballLabel.TextSize = 24
ballLabel.TextScaled = true
ballLabel.Font = Enum.Font.GothamBold
ballLabel.Parent = miniBall

-- ===== 标题栏 =====
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -90, 0, 30)
title.Position = UDim2.new(0, 5, 0, 5)
title.BackgroundTransparency = 1
title.Text = "wdfex 出租车刷钱"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Center
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- ===== 最小化按钮 =====
local minButton = Instance.new("TextButton")
minButton.Size = UDim2.new(0, 25, 0, 25)
minButton.Position = UDim2.new(1, -65, 0, 7)
minButton.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
minButton.BackgroundTransparency = 0.2
minButton.Text = "-"
minButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minButton.TextSize = 18
minButton.TextScaled = true
minButton.Font = Enum.Font.GothamBold
minButton.BorderSizePixel = 0
minButton.Parent = mainFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(1, 0)
minCorner.Parent = minButton

-- ===== 关闭按钮 =====
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -35, 0, 7)
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

-- ===== 分类标签 =====
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 30)
tabFrame.Position = UDim2.new(0, 0, 0, 38)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

local tab1 = Instance.new("TextButton")
tab1.Size = UDim2.new(0.5, -1, 1, 0)
tab1.Position = UDim2.new(0, 0, 0, 0)
tab1.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
tab1.BackgroundTransparency = 0.2
tab1.Text = "公告"
tab1.TextColor3 = Color3.fromRGB(255, 255, 255)
tab1.TextScaled = true
tab1.Font = Enum.Font.GothamBold
tab1.BorderSizePixel = 0
tab1.Parent = tabFrame

local tab1Corner = Instance.new("UICorner")
tab1Corner.CornerRadius = UDim.new(0, 6)
tab1Corner.Parent = tab1

local tab2 = Instance.new("TextButton")
tab2.Size = UDim2.new(0.5, -1, 1, 0)
tab2.Position = UDim2.new(0.5, 1, 0, 0)
tab2.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
tab2.BackgroundTransparency = 0.2
tab2.Text = "出租车"
tab2.TextColor3 = Color3.fromRGB(200, 200, 200)
tab2.TextScaled = true
tab2.Font = Enum.Font.GothamBold
tab2.BorderSizePixel = 0
tab2.Parent = tabFrame

local tab2Corner = Instance.new("UICorner")
tab2Corner.CornerRadius = UDim.new(0, 6)
tab2Corner.Parent = tab2

-- ===== 公告内容 =====
local announceFrame = Instance.new("Frame")
announceFrame.Size = UDim2.new(1, -10, 0, 150)
announceFrame.Position = UDim2.new(0.02, 0, 0, 72)
announceFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
announceFrame.BackgroundTransparency = 0.3
announceFrame.BorderSizePixel = 1
announceFrame.BorderColor3 = Color3.fromRGB(255, 200, 0)
announceFrame.Visible = true
announceFrame.Parent = mainFrame

local announceCorner = Instance.new("UICorner")
announceCorner.CornerRadius = UDim.new(0, 8)
announceCorner.Parent = announceFrame

local announceLabel = Instance.new("TextLabel")
announceLabel.Size = UDim2.new(0.95, 0, 0.9, 0)
announceLabel.Position = UDim2.new(0.025, 0, 0.05, 0)
announceLabel.BackgroundTransparency = 1
announceLabel.Text = "公 告\n\n此版本严禁宣传\n仅供个人使用\n请勿传播"
announceLabel.TextColor3 = Color3.fromRGB(255, 220, 100)
announceLabel.TextSize = 16
announceLabel.TextXAlignment = Enum.TextXAlignment.Center
announceLabel.TextYAlignment = Enum.TextYAlignment.Center
announceLabel.Font = Enum.Font.GothamBold
announceLabel.Parent = announceFrame

-- ===== 出租车内容 =====
local taxiFrame = Instance.new("Frame")
taxiFrame.Size = UDim2.new(1, -10, 0, 150)
taxiFrame.Position = UDim2.new(0.02, 0, 0, 72)
taxiFrame.BackgroundTransparency = 1
taxiFrame.Visible = false
taxiFrame.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 22)
statusLabel.Position = UDim2.new(0, 0, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "已停止"
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
statusLabel.TextSize = 14
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = taxiFrame

local orderCountLabel = Instance.new("TextLabel")
orderCountLabel.Size = UDim2.new(0.5, 0, 0, 22)
orderCountLabel.Position = UDim2.new(0, 0, 0, 24)
orderCountLabel.BackgroundTransparency = 1
orderCountLabel.Text = "接单: 0"
orderCountLabel.TextColor3 = Color3.fromRGB(255, 70, 70)
orderCountLabel.TextSize = 14
orderCountLabel.TextXAlignment = Enum.TextXAlignment.Left
orderCountLabel.Font = Enum.Font.GothamBold
orderCountLabel.Parent = taxiFrame

local teleportCountLabel = Instance.new("TextLabel")
teleportCountLabel.Size = UDim2.new(0.5, 0, 0, 22)
teleportCountLabel.Position = UDim2.new(0.5, 0, 0, 24)
teleportCountLabel.BackgroundTransparency = 1
teleportCountLabel.Text = "传送: 0"
teleportCountLabel.TextColor3 = Color3.fromRGB(70, 150, 255)
teleportCountLabel.TextSize = 14
teleportCountLabel.TextXAlignment = Enum.TextXAlignment.Left
teleportCountLabel.Font = Enum.Font.GothamBold
teleportCountLabel.Parent = taxiFrame

local orderStatusLabel = Instance.new("TextLabel")
orderStatusLabel.Size = UDim2.new(1, 0, 0, 20)
orderStatusLabel.Position = UDim2.new(0, 0, 0, 48)
orderStatusLabel.BackgroundTransparency = 1
orderStatusLabel.Text = "等待接单..."
orderStatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
orderStatusLabel.TextSize = 13
orderStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
orderStatusLabel.Font = Enum.Font.Gotham
orderStatusLabel.Parent = taxiFrame

local dotIndicator = Instance.new("Frame")
dotIndicator.Size = UDim2.new(0, 12, 0, 12)
dotIndicator.Position = UDim2.new(0, 0, 0, 2)
dotIndicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
dotIndicator.BorderSizePixel = 0
dotIndicator.Parent = taxiFrame

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = dotIndicator

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 32)
toggleButton.Position = UDim2.new(0.5, -60, 0, 95)
toggleButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
toggleButton.Text = "启动"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold
toggleButton.BorderSizePixel = 0
toggleButton.Parent = taxiFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = toggleButton

-- ===== 切换分类 =====
local function SwitchTab(tabName)
    currentTab = tabName
    if tabName == "公告" then
        announceFrame.Visible = true
        taxiFrame.Visible = false
        tab1.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        tab1.TextColor3 = Color3.fromRGB(255, 255, 255)
        tab2.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        tab2.TextColor3 = Color3.fromRGB(200, 200, 200)
    else
        announceFrame.Visible = false
        taxiFrame.Visible = true
        tab2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        tab2.TextColor3 = Color3.fromRGB(255, 255, 255)
        tab1.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        tab1.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end

tab1.MouseButton1Click:Connect(function()
    SwitchTab("公告")
end)

tab2.MouseButton1Click:Connect(function()
    SwitchTab("出租车")
end)

-- ===== 最小化/还原 =====
local function Minimize()
    isMinimized = true
    mainFrame.Visible = false
    miniBall.Visible = true
end

local function Restore()
    isMinimized = false
    mainFrame.Visible = true
    miniBall.Visible = false
end

minButton.MouseButton1Click:Connect(function()
    Minimize()
end)

miniBall.MouseButton1Click:Connect(function()
    Restore()
end)

-- ===== 关闭 =====
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

-- ===== 核心功能 =====
local hue = 0

local function UpdateGlow()
    hue = (hue + 0.8) % 360
    local angle = (hue / 360) * 360
    gradient.Rotation = angle

    local r = math.floor((math.sin(hue * math.pi / 180) * 0.5 + 0.5) * 255)
    local g = math.floor((math.sin((hue + 120) * math.pi / 180) * 0.5 + 0.5) * 255)
    local b = math.floor((math.sin((hue + 240) * math.pi / 180) * 0.5 + 0.5) * 255)

    local borderColor = Color3.fromRGB(r, g, b)
    mainFrame.BorderColor3 = borderColor
    glowBorder.BackgroundColor3 = borderColor
    outerGlow.BackgroundColor3 = borderColor
    miniBall.BorderColor3 = borderColor
    miniBall.BackgroundColor3 = borderColor
    ballGlow.BackgroundColor3 = borderColor
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

local function HasActiveOrder()
    for _, gui in pairs(Player.PlayerGui:GetDescendants()) do
        if gui:IsA("TextLabel") or gui:IsA("TextButton") then
            local text = gui.Text or ""
            if text:find("前往客户位置") or text:find("客户位置") or text:find("目的地") or text:find("送达") or text:find("正在进行的工作") then
                return true
            end
        end
    end
    return false
end

local function AcceptOrder()
    if HasActiveOrder() then
        return true
    end

    for attempt = 1, 30 do
        if not isRunning then return false end

        ClickAt(phoneX, phoneY)
        task.wait(0.15)
        ClickAt(phoneX, phoneY + 100)
        task.wait(0.15)
        ClickAt(phoneX, phoneY + 160)
        task.wait(0.15)
        ClickAt(phoneX, phoneY + 240)
        task.wait(0.3)

        if HasActiveOrder() then
            orderCount = orderCount + 1
            orderCountLabel.Text = "接单: " .. orderCount
            print("已接单")
            return true
        end

        task.wait(0.2)
    end

    return false
end

local function GetTargetPosition()
    local targetFolder = workspace.Gameplay and workspace.Gameplay.Entities and workspace.Gameplay.Entities.ClientContent
    if not targetFolder then
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
    else
        statusLabel.Text = "已停止"
        statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        toggleButton.Text = "启动"
        toggleButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        dotIndicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
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
        print("自动出租车已启动")

        while isRunning do
            if HasActiveOrder() then
                orderCount = orderCount + 1
                orderCountLabel.Text = "接单: " .. orderCount
            else
                orderStatusLabel.Text = "正在接单..."
                local got = AcceptOrder()
                if not got then
                    orderStatusLabel.Text = "接单失败，重试..."
                    task.wait(1)
                end
            end

            if not isRunning then break end

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

            if not isRunning then break end

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

            orderStatusLabel.Text = "订单完成"
            task.wait(1.5)
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

SwitchTab("公告")
UpdateUI(false)
print("UI已加载，点击启动开始")