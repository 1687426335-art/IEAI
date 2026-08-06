-- ===== 出租车自动刷钱（独立悬浮窗版） =====

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- ===== 传送函数 =====
local function TeleportTo(pos)
    pcall(function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(pos)
        end
    end)
end

-- ===== 检测黄色标记点 =====
local function GetYellowTarget()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local closest = nil
    local closestDist = 9999
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Position then
            local name = obj.Name:lower()
            local isYellow = false
            if obj.Color then
                local c = obj.Color
                if c.r > 0.6 and c.g > 0.6 and c.b < 0.4 then
                    isYellow = true
                end
            end
            local keywords = {"target", "marker", "point", "waypoint", "destination", "goal", "order", "customer", "npc", "interaction", "vehicle"}
            local match = false
            for _, kw in ipairs(keywords) do
                if name:find(kw) then
                    match = true
                    break
                end
            end
            if match or isYellow then
                local dist = (hrp.Position - obj.Position).Magnitude
                if dist > 3 and dist < closestDist then
                    closestDist = dist
                    closest = obj.Position
                end
            end
        end
    end
    
    return closest
end

-- ===== 检测顾客模型 =====
local function GetCustomerModel()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local closest = nil
    local closestDist = 9999
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("customer") or name:find("npc") or name:find("ped") or name:find("passenger") or name:find("client") or name:find("humanoid") then
                local root = obj:FindFirstChild("HumanoidRootPart")
                if root and root:IsA("BasePart") then
                    local dist = (hrp.Position - root.Position).Magnitude
                    if dist > 2 and dist < closestDist then
                        closestDist = dist
                        closest = root.Position
                    end
                end
            end
        end
    end
    
    return closest
end

-- ===== 检测UI判断是否有订单 =====
local function HasOrder()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return false end
    
    for _, child in ipairs(playerGui:GetDescendants()) do
        if child:IsA("TextLabel") then
            local text = child.Text or ""
            if text:find("出租车订单") or text:find("运行中") or text:find("前往客户位置") or text:find("驾驶客户前往目的地") then
                return true
            end
        end
    end
    return false
end

-- ===== 检测是否在送客阶段 =====
local function IsDelivering()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return false end
    
    for _, child in ipairs(playerGui:GetDescendants()) do
        if child:IsA("TextLabel") then
            local text = child.Text or ""
            if text:find("驾驶客户前往目的地") then
                return true
            end
        end
    end
    return false
end

local taxiRunning = false
local taxiConnection = nil
local isWaiting = false

-- ===== 核心逻辑 =====
local function DoTaxi()
    if not taxiRunning then return end
    if isWaiting then return end
    
    if not HasOrder() then
        return
    end
    
    local isDeliveringPhase = IsDelivering()
    local target = nil
    
    if isDeliveringPhase then
        target = GetYellowTarget()
    else
        target = GetCustomerModel()
        if not target then
            target = GetYellowTarget()
        end
    end
    
    if target then
        TeleportTo(target)
        isWaiting = true
        task.wait(3)
        isWaiting = false
    end
end

-- ===== 悬浮窗 =====
local function CreateFloatingWindow()
    -- 清除旧悬浮窗
    local old = CoreGui:FindFirstChild("TaxiFloating")
    if old then old:Destroy() end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TaxiFloating"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = CoreGui
    
    -- 主框架
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 180, 0, 100)
    frame.Position = UDim2.new(0.5, -90, 0.1, 50)
    frame.BackgroundColor3 = Color3.fromRGB(15, 20, 35)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 200, 50)
    frame.ClipsDescendants = true
    frame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    
    -- 顶部分隔条
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 3)
    topBar.Position = UDim2.new(0, 0, 0, 0)
    topBar.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    topBar.BorderSizePixel = 0
    topBar.Parent = frame
    
    -- 标题
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 24)
    title.Position = UDim2.new(0, 0, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "🚕 出租车刷钱"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 15
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    -- 状态显示
    local statusFrame = Instance.new("Frame")
    statusFrame.Size = UDim2.new(1, -20, 0, 20)
    statusFrame.Position = UDim2.new(0, 10, 0, 34)
    statusFrame.BackgroundColor3 = Color3.fromRGB(30, 35, 55)
    statusFrame.BackgroundTransparency = 0.5
    statusFrame.BorderSizePixel = 1
    statusFrame.BorderColor3 = Color3.fromRGB(60, 65, 85)
    statusFrame.Parent = frame
    
    local corner2 = Instance.new("UICorner")
    corner2.CornerRadius = UDim.new(0, 6)
    corner2.Parent = statusFrame
    
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 1, 0)
    status.BackgroundTransparency = 1
    status.Text = "⏹ 已停止"
    status.TextColor3 = Color3.fromRGB(255, 100, 100)
    status.TextSize = 13
    status.Font = Enum.Font.GothamBold
    status.Parent = statusFrame
    
    -- 按钮容器
    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(1, -20, 0, 30)
    btnFrame.Position = UDim2.new(0, 10, 0, 60)
    btnFrame.BackgroundTransparency = 1
    btnFrame.Parent = frame
    
    -- 启动按钮
    local startBtn = Instance.new("TextButton")
    startBtn.Size = UDim2.new(0.46, -5, 1, 0)
    startBtn.Position = UDim2.new(0, 0, 0, 0)
    startBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 80)
    startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    startBtn.TextSize = 13
    startBtn.Font = Enum.Font.GothamBold
    startBtn.Text = "▶ 启动"
    startBtn.Parent = btnFrame
    
    local corner3 = Instance.new("UICorner")
    corner3.CornerRadius = UDim.new(0, 6)
    corner3.Parent = startBtn
    
    -- 停止按钮
    local stopBtn = Instance.new("TextButton")
    stopBtn.Size = UDim2.new(0.46, -5, 1, 0)
    stopBtn.Position = UDim2.new(0.54, 0, 0, 0)
    stopBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    stopBtn.TextSize = 13
    stopBtn.Font = Enum.Font.GothamBold
    stopBtn.Text = "⏹ 停止"
    stopBtn.Parent = btnFrame
    
    local corner4 = Instance.new("UICorner")
    corner4.CornerRadius = UDim.new(0, 6)
    corner4.Parent = stopBtn
    
    -- ===== 拖拽功能 =====
    local drag = false
    local dragStart = nil
    local startPos = nil
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if drag and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- ===== 按钮功能 =====
    startBtn.MouseButton1Click:Connect(function()
        if taxiRunning then return end
        taxiRunning = true
        status.Text = "▶ 运行中"
        status.TextColor3 = Color3.fromRGB(100, 255, 100)
        startBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        startBtn.Text = "● 运行中"
        startBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        stopBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        
        StarterGui:SetCore("SendNotification", {
            Title = "出租车刷钱",
            Text = "已启动，自动检测订单",
            Duration = 2,
        })
        
        if taxiConnection then taxiConnection:Disconnect() end
        taxiConnection = RunService.Heartbeat:Connect(function()
            if taxiRunning then
                DoTaxi()
            end
        end)
    end)
    
    stopBtn.MouseButton1Click:Connect(function()
        taxiRunning = false
        isWaiting = false
        status.Text = "⏹ 已停止"
        status.TextColor3 = Color3.fromRGB(255, 100, 100)
        startBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 80)
        startBtn.Text = "▶ 启动"
        startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        stopBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        
        if taxiConnection then
            taxiConnection:Disconnect()
            taxiConnection = nil
        end
        
        StarterGui:SetCore("SendNotification", {
            Title = "出租车刷钱",
            Text = "已停止",
            Duration = 1,
        })
    end)
    
    return screenGui
end

-- ===== 启动 =====
CreateFloatingWindow()

print("出租车刷钱已加载")
print("悬浮窗已创建，点击启动按钮开始自动刷钱")