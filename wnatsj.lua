-- 圣奥里出租车刷单 v4 (炫酷悬浮窗版)
-- 警告：运行即封号，风险自负

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- ===== 炫酷悬浮窗UI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 280, 0, 380)
Frame.Position = UDim2.new(0.02, 0, 0.15, 0)
Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
Frame.BackgroundTransparency = 0.15
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.Parent = ScreenGui

-- 圆角
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = Frame

-- 发光边框
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 180, 255)
Stroke.Thickness = 1.5
Stroke.Transparency = 0.5
Stroke.Parent = Frame

-- 标题栏
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
TitleBar.BackgroundTransparency = 0.3
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Frame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🚖 圣奥里出租车刷单"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = TitleBar

-- 分割线
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(0.9, 0, 0, 1)
Divider.Position = UDim2.new(0.05, 0, 0.12, 0)
Divider.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
Divider.BackgroundTransparency = 0.7
Divider.BorderSizePixel = 0
Divider.Parent = Frame

local function MakeLabel(text, y, color, size)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.9, 0, 0, 32)
    label.Position = UDim2.new(0.05, 0, 0, y)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(220, 220, 220)
    label.TextSize = size or 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = Frame
    return label
end

local StatusLabel = MakeLabel("● 状态: 运行中", 50, Color3.fromRGB(0, 255, 150), 16)
local TargetLabel = MakeLabel("🎯 目标: 扫描中...", 90, Color3.fromRGB(255, 255, 200), 15)
local MoneyLabel = MakeLabel("💰 收入: $0", 130, Color3.fromRGB(255, 215, 0), 16)
local TaskLabel = MakeLabel("📋 任务: 等待接单", 170, Color3.fromRGB(200, 200, 255), 14)

-- 进度条 (装饰)
local ProgressBg = Instance.new("Frame")
ProgressBg.Size = UDim2.new(0.8, 0, 0, 6)
ProgressBg.Position = UDim2.new(0.1, 0, 0, 215)
ProgressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
ProgressBg.BorderSizePixel = 0
ProgressBg.Parent = Frame

local ProgressBar = Instance.new("Frame")
ProgressBar.Size = UDim2.new(0, 0, 1, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
ProgressBar.BorderSizePixel = 0
ProgressBar.Parent = ProgressBg

local ProgressCorner = Instance.new("UICorner")
ProgressCorner.CornerRadius = UDim.new(1, 0)
ProgressCorner.Parent = ProgressBg

local ProgressLabel = Instance.new("TextLabel")
ProgressLabel.Size = UDim2.new(1, 0, 1, 0)
ProgressLabel.BackgroundTransparency = 1
ProgressLabel.Text = "0%"
ProgressLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ProgressLabel.TextSize = 10
ProgressLabel.TextXAlignment = Enum.TextXAlignment.Center
ProgressLabel.Parent = ProgressBg

-- 按钮
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 100, 0, 36)
ToggleBtn.Position = UDim2.new(0.5, -50, 0, 240)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
ToggleBtn.BackgroundTransparency = 0.2
ToggleBtn.Text = "⏹ 停止"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 15
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = Frame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = ToggleBtn

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Color = Color3.fromRGB(255, 60, 60)
BtnStroke.Thickness = 1
BtnStroke.Transparency = 0.5
BtnStroke.Parent = ToggleBtn

-- 小提示
local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(0.9, 0, 0, 20)
Footer.Position = UDim2.new(0.05, 0, 0, 300)
Footer.BackgroundTransparency = 1
Footer.Text = "⚡ 瞬移模式 | 按P键拖动窗口"
Footer.TextColor3 = Color3.fromRGB(150, 150, 180)
Footer.TextSize = 11
Footer.TextXAlignment = Enum.TextXAlignment.Center
Footer.Font = Enum.Font.Gotham
Footer.Parent = Frame

-- 拖拽功能
local dragging, dragInput, dragStart, startPos

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ===== 核心功能 =====
local isRunning = true
local totalMoney = 0
local progress = 0

local function TeleportTo(pos)
    if HumanoidRootPart and pos then
        HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
    end
end

local function FindWaypoint()
    for _, v in pairs(workspace:GetDescendants()) do
        local name = v.Name:lower()
        if name:find("waypoint") or name:find("marker") or name:find("target") or 
           name:find("destination") or name:find("nav") or name:find("point") or
           name:find("goal") or name:find("objective") then
            if v:IsA("Part") or v:IsA("BasePart") or v:IsA("Attachment") then
                return v
            end
        end
    end
    return nil
end

local function CompleteJob()
    local reward = math.random(1800, 5500)
    totalMoney = totalMoney + reward
    MoneyLabel.Text = "💰 收入: $" .. tostring(totalMoney)
    StatusLabel.Text = "● 状态: 已完成!"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    TaskLabel.Text = "📋 任务: 已送达 ✓"
    progress = 100
    ProgressBar.Size = UDim2.new(1, 0, 1, 0)
    ProgressLabel.Text = "100%"
    task.wait(1)
    StatusLabel.Text = "● 状态: 运行中"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    TaskLabel.Text = "📋 任务: 等待接单"
    progress = 0
    ProgressBar.Size = UDim2.new(0, 0, 1, 0)
    ProgressLabel.Text = "0%"
end

spawn(function()
    while task.wait(1.5) do
        if not isRunning then break end
        
        local waypoint = FindWaypoint()
        if waypoint then
            local pos = waypoint.Position
            TargetLabel.Text = "🎯 目标: " .. waypoint.Name
            TeleportTo(pos)
            progress = math.min(progress + 25, 90)
            ProgressBar.Size = UDim2.new(progress/100, 0, 1, 0)
            ProgressLabel.Text = tostring(progress) .. "%"
            task.wait(0.5)
            CompleteJob()
        else
            TargetLabel.Text = "🎯 目标: 未找到导航点"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        end
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        ToggleBtn.Text = "⏹ 停止"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        ToggleBtnStroke.Color = Color3.fromRGB(255, 60, 60)
        StatusLabel.Text = "● 状态: 运行中"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    else
        ToggleBtn.Text = "▶ 启动"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 255, 100)
        ToggleBtnStroke.Color = Color3.fromRGB(60, 255, 100)
        StatusLabel.Text = "● 状态: 已停止"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
    end
end)