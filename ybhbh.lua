-- ========== 出租车/公交车 二合一（悬浮按钮 + 模式切换） ==========
-- 警告：本脚本必须搭配防检测措施使用！
-- 功能：出租车（接单+传送） / 公交车（站台接客+送达），一键切换

local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

-- ================== 全新UI（悬浮按钮 + 可隐藏主面板） ==================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = Player:WaitForChild("PlayerGui")

-- ---------- 悬浮按钮（右上角圆形） ----------
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 60, 0, 60)
toggleButton.Position = UDim2.new(1, -80, 0, 20)
toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
toggleButton.BackgroundTransparency = 0.2
toggleButton.BorderSizePixel = 2
toggleButton.BorderColor3 = Color3.fromRGB(150, 100, 255)
toggleButton.Text = "🚖"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Active = true
toggleButton.Draggable = true
toggleButton.Parent = screenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = toggleButton

local btnGlow = Instance.new("Frame")
btnGlow.Size = UDim2.new(1, 12, 1, 12)
btnGlow.Position = UDim2.new(0, -6, 0, -6)
btnGlow.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
btnGlow.BackgroundTransparency = 0.5
btnGlow.BorderSizePixel = 0
btnGlow.ZIndex = 0
btnGlow.Parent = toggleButton
local btnGlowCorner = Instance.new("UICorner")
btnGlowCorner.CornerRadius = UDim.new(1, 0)
btnGlowCorner.Parent = btnGlow

-- ---------- 主面板（初始隐藏） ----------
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 350)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(120, 80, 255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = mainFrame

-- 毛玻璃底层
local blurOverlay = Instance.new("Frame")
blurOverlay.Size = UDim2.new(1, 0, 1, 0)
blurOverlay.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
blurOverlay.BackgroundTransparency = 0.3
blurOverlay.BorderSizePixel = 0
blurOverlay.Parent = mainFrame
local blurCorner = Instance.new("UICorner")
blurCorner.CornerRadius = UDim.new(0, 16)
blurCorner.Parent = blurOverlay

-- 动态边框光晕
local glowBorder = Instance.new("Frame")
glowBorder.Size = UDim2.new(1, 8, 1, 8)
glowBorder.Position = UDim2.new(0, -4, 0, -4)
glowBorder.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
glowBorder.BackgroundTransparency = 0.6
glowBorder.BorderSizePixel = 0
glowBorder.ZIndex = 0
glowBorder.Parent = mainFrame
local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 18)
glowCorner.Parent = glowBorder

local borderGradient = Instance.new("UIGradient")
borderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 255)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(0, 150, 255)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 0, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 0, 255)),
})
borderGradient.Rotation = 0
borderGradient.Parent = glowBorder

-- 标题（固定显示）
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 8)
title.BackgroundTransparency = 1
title.Text = "🚖🚌 出租车/公交车"
title.TextColor3 = Color3.fromRGB(230, 230, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- 分隔线
local line = Instance.new("Frame")
line.Size = UDim2.new(0.8, 0, 0, 2)
line.Position = UDim2.new(0.1, 0, 0, 48)
line.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
line.BorderSizePixel = 0
line.Parent = mainFrame
local lineGlow = Instance.new("Frame")
lineGlow.Size = UDim2.new(1, 10, 1, 6)
lineGlow.Position = UDim2.new(0, -5, 0, -2)
lineGlow.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
lineGlow.BackgroundTransparency = 0.5
lineGlow.BorderSizePixel = 0
lineGlow.Parent = line

-- 状态指示点
local dot = Instance.new("Frame")
dot.Size = UDim2.new(0, 12, 0, 12)
dot.Position = UDim2.new(0, 12, 0, 55)
dot.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
dot.BorderSizePixel = 0
dot.Parent = mainFrame
local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = dot
local dotGlow = Instance.new("Frame")
dotGlow.Size = UDim2.new(1, 10, 1, 10)
dotGlow.Position = UDim2.new(0, -5, 0, -5)
dotGlow.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
dotGlow.BackgroundTransparency = 0.6
dotGlow.BorderSizePixel = 0
dotGlow.Parent = dot
local dotGlowCorner = Instance.new("UICorner")
dotGlowCorner.CornerRadius = UDim.new(1, 0)
dotGlowCorner.Parent = dotGlow

-- 状态文字
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.7, 0, 0, 22)
statusLabel.Position = UDim2.new(0, 30, 0, 53)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "⏸️ 已停止"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- 统计1（出租车：接单；公交车：乘客）
local statLabel1 = Instance.new("TextLabel")
statLabel1.Size = UDim2.new(0.4, 0, 0, 24)
statLabel1.Position = UDim2.new(0, 12, 0, 80)
statLabel1.BackgroundTransparency = 1
statLabel1.Text = "📦 接单: 0"
statLabel1.TextColor3 = Color3.fromRGB(255, 150, 150)
statLabel1.TextScaled = true
statLabel1.TextXAlignment = Enum.TextXAlignment.Left
statLabel1.Font = Enum.Font.GothamBold
statLabel1.Parent = mainFrame

-- 统计2（出租车：传送；公交车：站点）
local statLabel2 = Instance.new("TextLabel")
statLabel2.Size = UDim2.new(0.4, 0, 0, 24)
statLabel2.Position = UDim2.new(0.5, 0, 0, 80)
statLabel2.BackgroundTransparency = 1
statLabel2.Text = "🚗 传送: 0"
statLabel2.TextColor3 = Color3.fromRGB(150, 200, 255)
statLabel2.TextScaled = true
statLabel2.TextXAlignment = Enum.TextXAlignment.Left
statLabel2.Font = Enum.Font.GothamBold
statLabel2.Parent = mainFrame

-- 当前操作状态（详细）
local orderStatusLabel = Instance.new("TextLabel")
orderStatusLabel.Size = UDim2.new(1, -20, 0, 22)
orderStatusLabel.Position = UDim2.new(0, 12, 0, 108)
orderStatusLabel.BackgroundTransparency = 1
orderStatusLabel.Text = "🔄 等待启动..."
orderStatusLabel.TextColor3 = Color3.fromRGB(180, 180, 220)
orderStatusLabel.TextScaled = true
orderStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
orderStatusLabel.Font = Enum.Font.Gotham
orderStatusLabel.Parent = mainFrame

-- 额外状态（公交车专用：当前站台信息）
local stationInfoLabel = Instance.new("TextLabel")
stationInfoLabel.Size = UDim2.new(1, -20, 0, 22)
stationInfoLabel.Position = UDim2.new(0, 12, 0, 132)
stationInfoLabel.BackgroundTransparency = 1
stationInfoLabel.Text = "📍 站台: 无"
stationInfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
stationInfoLabel.TextScaled = true
stationInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
stationInfoLabel.Font = Enum.Font.Gotham
stationInfoLabel.Parent = mainFrame

-- 警告标签
local warningLabel = Instance.new("TextLabel")
warningLabel.Size = UDim2.new(1, -20, 0, 20)
warningLabel.Position = UDim2.new(0, 12, 0, 158)
warningLabel.BackgroundTransparency = 1
warningLabel.Text = "⚠️ 必须搭配防检测！"
warningLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
warningLabel.TextScaled = true
warningLabel.TextXAlignment = Enum.TextXAlignment.Left
warningLabel.Font = Enum.Font.GothamBold
warningLabel.Parent = mainFrame

-- ========== 模式切换按钮 ==========
local modeBtn = Instance.new("TextButton")
modeBtn.Size = UDim2.new(0, 120, 0, 30)
modeBtn.Position = UDim2.new(0.5, -60, 0, 185)
modeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
modeBtn.Text = "🚕 出租车"
modeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
modeBtn.TextScaled = true
modeBtn.Font = Enum.Font.GothamBold
modeBtn.BorderSizePixel = 2
modeBtn.BorderColor3 = Color3.fromRGB(100, 200, 255)
modeBtn.Parent = mainFrame
local modeCorner = Instance.new("UICorner")
modeCorner.CornerRadius = UDim.new(0, 8)
modeCorner.Parent = modeBtn

-- ========== 复制脚本按钮 ==========
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0, 120, 0, 30)
copyBtn.Position = UDim2.new(0.5, 60, 0, 185)
copyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
copyBtn.Text = "📋 复制脚本"
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.TextScaled = true
copyBtn.Font = Enum.Font.GothamBold
copyBtn.BorderSizePixel = 2
copyBtn.BorderColor3 = Color3.fromRGB(100, 200, 255)
copyBtn.Parent = mainFrame
local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 8)
copyCorner.Parent = copyBtn

-- 复制功能
copyBtn.MouseButton1Click:Connect(function()
    local scriptToCopy = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/idkidevthings/improved-octo-chainsaw/refs/heads/main/sanx.lua"))()'
    setclipboard(scriptToCopy)
    copyBtn.Text = "✅ 已复制！"
    task.wait(1.5)
    copyBtn.Text = "📋 复制脚本"
end)

-- ========== 启动/停止按钮 ==========
local internalBtn = Instance.new("TextButton")
internalBtn.Size = UDim2.new(0, 160, 0, 40)
internalBtn.Position = UDim2.new(0.5, -80, 0, 225)
internalBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 200)
internalBtn.Text = "▶️ 启动"
internalBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
internalBtn.TextScaled = true
internalBtn.Font = Enum.Font.GothamBold
internalBtn.BorderSizePixel = 0
internalBtn.Parent = mainFrame

local btnCorner2 = Instance.new("UICorner")
btnCorner2.CornerRadius = UDim.new(0, 10)
btnCorner2.Parent = internalBtn

local btnGlow2 = Instance.new("Frame")
btnGlow2.Size = UDim2.new(1, 10, 1, 10)
btnGlow2.Position = UDim2.new(0, -5, 0, -5)
btnGlow2.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
btnGlow2.BackgroundTransparency = 0.5
btnGlow2.BorderSizePixel = 0
btnGlow2.ZIndex = 0
btnGlow2.Parent = internalBtn
local btnGlowCorner2 = Instance.new("UICorner")
btnGlowCorner2.CornerRadius = UDim.new(0, 13)
btnGlowCorner2.Parent = btnGlow2

-- ========== 重置按钮 ==========
local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(0, 80, 0, 30)
resetBtn.Position = UDim2.new(0.5, -40, 0, 275)
resetBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
resetBtn.Text = "🔄 重置"
resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetBtn.TextScaled = true
resetBtn.Font = Enum.Font.GothamBold
resetBtn.BorderSizePixel = 0
resetBtn.Parent = mainFrame
local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 6)
resetCorner.Parent = resetBtn

-- ========== 动态光效 ==========
local hue = 0
local function UpdateGlow()
    hue = (hue + 0.8) % 360
    local angle = (hue / 360) * 360
    borderGradient.Rotation = angle
    
    local r = math.floor((math.sin(hue * math.pi / 180) * 0.5 + 0.5) * 255)
    local g = math.floor((math.sin((hue + 120) * math.pi / 180) * 0.5 + 0.5) * 255)
    local b = math.floor((math.sin((hue + 240) * math.pi / 180) * 0.5 + 0.5) * 255)
    
    local borderColor = Color3.fromRGB(r, g, b)
    mainFrame.BorderColor3 = borderColor
    glowBorder.BackgroundColor3 = borderColor
    line.BackgroundColor3 = borderColor
    lineGlow.BackgroundColor3 = borderColor
    btnGlow.BackgroundColor3 = borderColor
    btnGlow2.BackgroundColor3 = borderColor
    toggleButton.BorderColor3 = borderColor
    copyBtn.BorderColor3 = borderColor
    modeBtn.BorderColor3 = borderColor
end
RunService.Heartbeat:Connect(UpdateGlow)

-- ========== 悬浮按钮点击切换主面板显示 ==========
local function ToggleMainFrame()
    mainFrame.Visible = not mainFrame.Visible
end
toggleButton.MouseButton1Click:Connect(ToggleMainFrame)

-- ================== 核心功能（出租车 + 公交车） ==================

-- ---------- 模式与状态 ----------
local currentMode = "taxi"  -- "taxi" 或 "bus"
local isRunning = false
local modeLoopThread = nil

-- 出租车统计
local orderCount = 0
local teleportCount = 0

-- 公交车统计
local passengerCount = 0
local stationCount = 0
local currentPassengers = {}
local busStops = {}
local currentStopIndex = 1

-- 配置
local TAXI_CONFIG = {
    ORDER_INTERVAL = 10,
    TELEPORT_INTERVAL = 3,
}

local BUS_CONFIG = {
    MAX_PASSENGERS = 5,
    PICKUP_INTERVAL = 3,
    DELIVER_INTERVAL = 5,
    CLICK_COUNT = 5,
    DESTINATION_OFFSET = 100,
    TIMEOUT_SECONDS = 10,
}

-- ---------- 工具函数 ----------
local function ClickAt(x, y)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
    task.wait(0.05)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

-- ---------- 出租车功能 ----------
local function AcceptOrder()
    local screenSize = workspace.CurrentCamera.ViewportSize
    local phoneX = screenSize.X * 0.85
    local phoneY = screenSize.Y * 0.35

    print("📱 执行接单点击...")
    ClickAt(phoneX, phoneY)
    task.wait(0.3)
    ClickAt(phoneX, phoneY + 100)
    task.wait(0.3)
    ClickAt(phoneX, phoneY + 160)
    task.wait(0.3)
    ClickAt(phoneX, phoneY + 240)
    task.wait(0.3)
    
    orderCount = orderCount + 1
    statLabel1.Text = "📦 接单: " .. orderCount
    print("✅ 接单操作完成 (#" .. orderCount .. ")")
end

local function GetTargetPosition()
    local success, result = pcall(function()
        local targetFolder = workspace.Gameplay.Entities.ClientContent
        if not targetFolder then return nil end
        for _, child in ipairs(targetFolder:GetDescendants()) do
            if child:IsA("BasePart") then
                return child.Position + Vector3.new(0, 3, 0)
            end
        end
        return nil
    end)
    if not success then
        print("⚠️ 获取目标位置时出错，跳过本次传送")
        return nil
    end
    return result
end

local function DoTeleportTaxi(pos)
    local char = Player.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid and humanoid.SeatPart then
        humanoid.Sit = false
        task.wait(0.1)
    end
    hrp.CFrame = CFrame.new(pos)
    hrp.Velocity = Vector3.new(0, 0, 0)
    hrp.RotVelocity = Vector3.new(0, 0, 0)
    return true
end

local function TaxiLoop()
    while isRunning and currentMode == "taxi" do
        -- 接单
        orderStatusLabel.Text = "📱 正在接单..."
        AcceptOrder()
        orderStatusLabel.Text = "⏳ 等待 " .. TAXI_CONFIG.ORDER_INTERVAL .. "秒后接单..."
        task.wait(TAXI_CONFIG.ORDER_INTERVAL)
        if not isRunning then break end

        -- 传送
        orderStatusLabel.Text = "🚗 正在传送..."
        local pos = GetTargetPosition()
        if pos and DoTeleportTaxi(pos) then
            teleportCount = teleportCount + 1
            statLabel2.Text = "🚗 传送: " .. teleportCount
            print("✅ 传送完成 (#" .. teleportCount .. ")")
        else
            print("⚠️ 传送失败")
        end
        orderStatusLabel.Text = "⏳ 等待 " .. TAXI_CONFIG.TELEPORT_INTERVAL .. "秒后传送..."
        task.wait(TAXI_CONFIG.TELEPORT_INTERVAL)
    end
end

-- ---------- 公交车功能 ----------
local function FindBusStops()
    local stops = {}
    local added = {}

    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            local name = part.Name:lower()
            if name:find("busstop") or name:find("station") or part.BrickColor == BrickColor.new("Bright blue") then
                local pos = part.Position
                local key = tostring(pos)
                if not added[key] then
                    added[key] = true
                    table.insert(stops, pos + Vector3.new(0, 3, 0))
                end
            end
        end
    end

    if #stops == 0 then
        local targetFolder = workspace:FindFirstChild("Gameplay") and workspace.Gameplay:FindFirstChild("Entities") and workspace.Gameplay.Entities:FindFirstChild("ClientContent")
        if targetFolder then
            for _, child in ipairs(targetFolder:GetDescendants()) do
                if child:IsA("BasePart") then
                    local pos = child.Position
                    local key = tostring(pos)
                    if not added[key] then
                        added[key] = true
                        table.insert(stops, pos + Vector3.new(0, 3, 0))
                    end
                end
            end
        end
    end

    return stops
end

local function RefreshStops()
    busStops = FindBusStops()
    if #busStops == 0 then
        warn("⚠️ 未找到任何公交站台！请检查游戏内是否有'BusStop'、'Station'或蓝色方块。")
    else
        print("🚏 找到 " .. #busStops .. " 个站台")
    end
    currentStopIndex = 1
end

local function DoTeleportBus(pos)
    local char = Player.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid and humanoid.SeatPart then
        humanoid.Sit = false
        task.wait(0.1)
    end
    local offset = Vector3.new(math.random(-3, 3), 0, math.random(-3, 3))
    local finalPos = pos + offset
    hrp.CFrame = CFrame.new(finalPos) * CFrame.Angles(0, math.rad(math.random(0, 360)), 0)
    hrp.Velocity = Vector3.zero
    hrp.RotVelocity = Vector3.zero
    return true
end

local function PickupPassenger()
    local screenSize = workspace.CurrentCamera.ViewportSize
    local phoneX = screenSize.X * 0.85
    local phoneY = screenSize.Y * 0.35

    for i = 1, BUS_CONFIG.CLICK_COUNT do
        ClickAt(phoneX, phoneY + (i - 1) * 50)
        task.wait(0.2 + math.random() * 0.2)
    end
    passengerCount = passengerCount + 1
    table.insert(currentPassengers, { id = passengerCount, time = os.time() })
    statLabel1.Text = "👥 乘客: " .. #currentPassengers .. "/" .. BUS_CONFIG.MAX_PASSENGERS
    orderStatusLabel.Text = "👤 接载乘客 #" .. passengerCount
    print("✅ 接载乘客成功 (#" .. passengerCount .. ") 当前载客: " .. #currentPassengers)
end

local function DeliverToStation()
    if #currentPassengers == 0 then
        orderStatusLabel.Text = "⚠️ 没有乘客可送"
        return
    end
    local screenSize = workspace.CurrentCamera.ViewportSize
    local phoneX = screenSize.X * 0.85
    local phoneY = screenSize.Y * 0.35
    local destY = phoneY + BUS_CONFIG.DESTINATION_OFFSET

    for i = 1, 3 do
        ClickAt(phoneX, destY + i * 60)
        task.wait(0.3 + math.random() * 0.2)
    end

    local delivered = #currentPassengers
    currentPassengers = {}
    stationCount = stationCount + 1
    statLabel1.Text = "👥 乘客: 0/" .. BUS_CONFIG.MAX_PASSENGERS
    statLabel2.Text = "🚏 站点: " .. stationCount
    orderStatusLabel.Text = "✅ 送达 " .. delivered .. " 名乘客到站点 #" .. stationCount
    print("✅ 送达 " .. delivered .. " 名乘客到站点 #" .. stationCount)
end

local function CheckPassengerIncrease(prevCount, timeout)
    local startTime = tick()
    while tick() - startTime < timeout do
        task.wait(0.5)
        local current = #currentPassengers
        if current > prevCount then
            return true
        end
    end
    return false
end

local function BusLoop()
    RefreshStops()
    if #busStops == 0 then
        orderStatusLabel.Text = "❌ 无可用站台，停止"
        print("❌ 无可用站台，停止循环")
        isRunning = false
        UpdateUI(false)
        return
    end

    while isRunning and currentMode == "bus" do
        local targetPos = busStops[currentStopIndex]
        if not targetPos then
            currentStopIndex = 1
            targetPos = busStops[currentStopIndex]
        end

        stationInfoLabel.Text = "📍 站台 " .. currentStopIndex .. "/" .. #busStops
        orderStatusLabel.Text = "🚌 传送到站台 " .. currentStopIndex

        if not DoTeleportBus(targetPos) then
            orderStatusLabel.Text = "⚠️ 传送失败，跳过此站台"
            currentStopIndex = currentStopIndex + 1
            task.wait(1)
            if currentStopIndex > #busStops then currentStopIndex = 1 end
            continue
        end
        task.wait(0.5)

        local prevCount = #currentPassengers
        orderStatusLabel.Text = "🔄 尝试接客 (站台 " .. currentStopIndex .. ")"
        PickupPassenger()

        local gotPassenger = CheckPassengerIncrease(prevCount, BUS_CONFIG.TIMEOUT_SECONDS)

        if gotPassenger then
            orderStatusLabel.Text = "✅ 成功接到乘客！"
            print("✅ 站台 " .. currentStopIndex .. " 接客成功")
            if #currentPassengers >= BUS_CONFIG.MAX_PASSENGERS then
                orderStatusLabel.Text = "🚌 满员，准备送达..."
                task.wait(1)
                DeliverToStation()
                task.wait(BUS_CONFIG.DELIVER_INTERVAL)
            else
                task.wait(BUS_CONFIG.PICKUP_INTERVAL)
            end
        else
            orderStatusLabel.Text = "⏱️ " .. BUS_CONFIG.TIMEOUT_SECONDS .. "秒未接客，切换站台"
            print("⏱️ 站台 " .. currentStopIndex .. " 超时，切换到下一个")
            currentStopIndex = currentStopIndex + 1
            if currentStopIndex > #busStops then currentStopIndex = 1 end
            -- 回滚计数（如果PickupPassenger增加了但实际未接到）
            if #currentPassengers > prevCount then
                for i = #currentPassengers, prevCount + 1, -1 do
                    table.remove(currentPassengers, i)
                end
                statLabel1.Text = "👥 乘客: " .. #currentPassengers .. "/" .. BUS_CONFIG.MAX_PASSENGERS
            end
            task.wait(1)
        end
    end
end

-- ---------- UI更新与模式切换 ----------
local function UpdateUI(isActive)
    if isActive then
        statusLabel.Text = "▶️ 运行中"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        internalBtn.Text = "⏹️ 停止"
        internalBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        dot.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        dotGlow.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    else
        statusLabel.Text = "⏸️ 已停止"
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        internalBtn.Text = "▶️ 启动"
        internalBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 200)
        dot.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        dotGlow.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        if currentMode == "taxi" then
            orderStatusLabel.Text = "🔄 等待启动（出租车）..."
        else
            orderStatusLabel.Text = "🔄 等待启动（公交车）..."
        end
    end
end

local function SwitchMode(newMode)
    if newMode == currentMode then return end
    -- 如果正在运行则先停止
    if isRunning then
        isRunning = false
        task.wait(0.2)
    end
    currentMode = newMode
    -- 更新统计标签和模式按钮（标题保持不变）
    if currentMode == "taxi" then
        statLabel1.Text = "📦 接单: " .. orderCount
        statLabel2.Text = "🚗 传送: " .. teleportCount
        stationInfoLabel.Text = ""   -- 隐藏站台信息
        modeBtn.Text = "🚕 出租车"
        modeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
    else
        statLabel1.Text = "👥 乘客: " .. #currentPassengers .. "/" .. BUS_CONFIG.MAX_PASSENGERS
        statLabel2.Text = "🚏 站点: " .. stationCount
        stationInfoLabel.Text = "📍 站台: 无"
        modeBtn.Text = "🚌 公交车"
        modeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
    end
    UpdateUI(false)
    print("🔄 切换到 " .. (currentMode == "taxi" and "出租车" or "公交车") .. " 模式")
end

-- 重置统计
local function ResetStats()
    if isRunning then
        print("⚠️ 请先停止运行再重置")
        return
    end
    orderCount = 0
    teleportCount = 0
    passengerCount = 0
    stationCount = 0
    currentPassengers = {}
    if currentMode == "taxi" then
        statLabel1.Text = "📦 接单: 0"
        statLabel2.Text = "🚗 传送: 0"
        orderStatusLabel.Text = "🔄 统计已重置（出租车）"
    else
        statLabel1.Text = "👥 乘客: 0/" .. BUS_CONFIG.MAX_PASSENGERS
        statLabel2.Text = "🚏 站点: 0"
        orderStatusLabel.Text = "🔄 统计已重置（公交车）"
    end
    print("🔄 统计已重置")
end

-- ---------- 启动/停止逻辑 ----------
local function StartLoop()
    if isRunning then return end
    isRunning = true
    UpdateUI(true)

    if currentMode == "taxi" then
        print("🚖 出租车模式启动")
        orderStatusLabel.Text = "🚖 出租车运行中..."
        modeLoopThread = task.spawn(TaxiLoop)
    else
        print("🚌 公交车模式启动")
        orderStatusLabel.Text = "🚌 公交车运行中..."
        RefreshStops()
        modeLoopThread = task.spawn(BusLoop)
    end
end

local function StopLoop()
    if not isRunning then return end
    isRunning = false
    modeLoopThread = nil
    UpdateUI(false)
    print("⏹️ 已停止")
    if currentMode == "taxi" then
        print("📊 统计 - 接单: " .. orderCount .. " | 传送: " .. teleportCount)
    else
        print("📊 统计 - 乘客: " .. passengerCount .. " | 站点: " .. stationCount)
    end
end

-- ========== 按钮事件绑定 ==========
-- 模式切换
modeBtn.MouseButton1Click:Connect(function()
    if currentMode == "taxi" then
        SwitchMode("bus")
    else
        SwitchMode("taxi")
    end
end)

-- 启动/停止
internalBtn.MouseButton1Click:Connect(function()
    if isRunning then
        StopLoop()
    else
        StartLoop()
    end
end)

-- 重置
resetBtn.MouseButton1Click:Connect(function()
    ResetStats()
end)

-- 快捷键 F1 启动/停止，F2 重置
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        if isRunning then StopLoop() else StartLoop() end
    elseif input.KeyCode == Enum.KeyCode.F2 then
        ResetStats()
    end
end)

-- ========== 初始化 ==========
SwitchMode("taxi")  -- 默认出租车
UpdateUI(false)
print("✅ 二合一脚本加载完成")
print("💡 点击右上角 🚖 按钮显示/隐藏主面板")
print("📌 F1: 启动/停止 | F2: 重置统计")
print("🔄 点击 '🚕 出租车'/'🚌 公交车' 按钮切换模式")
print("⚠️ 请务必搭配防检测系统使用本脚本！")