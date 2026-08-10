local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LuanScriptUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = Player.PlayerGui

local mainPanelVisible = false
local scriptClosed = false

-- ===================== 启动加载页 =====================
local loadFrame = Instance.new("Frame")
loadFrame.Size = UDim2.new(0, 270, 0, 120)
loadFrame.Position = UDim2.new(0.5, -135, 0.5, -60)
loadFrame.BackgroundColor3 = Color3.new(1, 1, 1)
loadFrame.BorderSizePixel = 1
loadFrame.BorderColor3 = Color3.fromRGB(228, 233, 243)
loadFrame.BackgroundTransparency = 0
loadFrame.Parent = screenGui

local loadCorner = Instance.new("UICorner")
loadCorner.CornerRadius = UDim.new(0, 14)
loadCorner.Parent = loadFrame

local loadShadow = Instance.new("Frame")
loadShadow.Size = UDim2.new(1, 12, 1, 12)
loadShadow.Position = UDim2.new(0, -6, 0, -6)
loadShadow.BackgroundColor3 = Color3.new(0,0,0)
loadShadow.BackgroundTransparency = 0.92
loadShadow.ZIndex = 0
loadShadow.Parent = loadFrame
local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 16)
shadowCorner.Parent = loadShadow

-- 左上角官方认证标签
local officialTag = Instance.new("TextLabel")
officialTag.Size = UDim2.new(0, 62, 0, 18)
officialTag.Position = UDim2.new(0, 6, 0, 6)
officialTag.BackgroundTransparency = 1
officialTag.Text = "官方认证"
officialTag.TextColor3 = Color3.fromRGB(37, 99, 235)
officialTag.Font = Enum.Font.Gotham
officialTag.TextSize = 11
officialTag.Parent = loadFrame
local tagStroke = Instance.new("UIStroke")
tagStroke.Color = Color3.fromRGB(37, 99, 235)
tagStroke.Thickness = 1
tagStroke.Parent = officialTag
local tagCorner = Instance.new("UICorner")
tagCorner.CornerRadius = UDim.new(0, 6)
tagCorner.Parent = officialTag

-- 标题 Luan 脚本
local loadTitle = Instance.new("TextLabel")
loadTitle.Size = UDim2.new(1, 0, 0, 24)
loadTitle.Position = UDim2.new(0, 0, 0, 32)
loadTitle.BackgroundTransparency = 1
loadTitle.Text = "Luan 脚本初始化程序"
loadTitle.Font = Enum.Font.GothamBold
loadTitle.TextScaled = true
loadTitle.TextColor3 = Color3.new(0,0,0)
loadTitle.Parent = loadFrame

local loadTip = Instance.new("TextLabel")
loadTip.Size = UDim2.new(1, 0, 0, 14)
loadTip.Position = UDim2.new(0, 0, 0, 60)
loadTip.BackgroundTransparency = 1
loadTip.Text = "正在加载核心模块，请稍候"
loadTip.Font = Enum.Font.Gotham
loadTip.TextScaled = true
loadTip.TextColor3 = Color3.fromRGB(100, 116, 139)
loadTip.Parent = loadFrame

-- 进度条容器
local progressBg = Instance.new("Frame")
progressBg.Size = UDim2.new(0.92, 0, 0, 9)
progressBg.Position = UDim2.new(0.04, 0, 0, 82)
progressBg.BackgroundColor3 = Color3.fromRGB(241, 245, 255)
progressBg.BorderSizePixel = 0
progressBg.Parent = loadFrame
local progBgCorner = Instance.new("UICorner")
progBgCorner.CornerRadius = UDim.new(1, 0)
progBgCorner.Parent = progressBg

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = Color3.fromRGB(37, 99, 235)
progressFill.BorderSizePixel = 0
progressFill.Parent = progressBg
local progFillCorner = Instance.new("UICorner")
progFillCorner.CornerRadius = UDim.new(1, 0)
progFillCorner.Parent = progressFill

-- 进度条动画，加载完成销毁启动页
task.spawn(function()
    local tweenLoad = TweenService:Create(progressFill, TweenInfo.new(1.8), {Size = UDim2.new(1, 0, 1, 0)})
    tweenLoad:Play()
    tweenLoad.Completed:Connect(function()
        local fadeTween = TweenService:Create(loadFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1, Transparency = 1})
        fadeTween:Play()
        fadeTween.Completed:Connect(function()
            loadFrame:Destroy()
        end)
    end)
end)

-- ===================== 主功能面板 =====================
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 240, 0, 220)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.new(1,1,1)
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.fromRGB(160,160,160)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = screenGui
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- 右上角关闭按钮 X
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -28, 0, 2)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(0,0,0)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(function()
    scriptClosed = true
    screenGui:Destroy()
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "自动出租车"
title.TextColor3 = Color3.new(0,0,0)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleLine = Instance.new("Frame")
titleLine.Size = UDim2.new(0.8, 0, 0, 1)
titleLine.Position = UDim2.new(0.1, 0, 0, 40)
titleLine.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
titleLine.BorderSizePixel = 0
titleLine.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 48)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "已停止"
statusLabel.TextColor3 = Color3.new(0, 0, 0)
statusLabel.TextScaled = true
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

local orderCountLabel = Instance.new("TextLabel")
orderCountLabel.Size = UDim2.new(0.5, 0, 0, 25)
orderCountLabel.Position = UDim2.new(0, 10, 0, 78)
orderCountLabel.BackgroundTransparency = 1
orderCountLabel.Text = "接单：0"
orderCountLabel.TextColor3 = Color3.new(0, 0, 0)
orderCountLabel.TextScaled = true
orderCountLabel.TextXAlignment = Enum.TextXAlignment.Left
orderCountLabel.Font = Enum.Font.GothamBold
orderCountLabel.Parent = mainFrame

local teleportCountLabel = Instance.new("TextLabel")
teleportCountLabel.Size = UDim2.new(0.5, 0, 0, 25)
teleportCountLabel.Position = UDim2.new(0.5, 0, 0, 78)
teleportCountLabel.BackgroundTransparency = 1
teleportCountLabel.Text = "传送：0"
teleportCountLabel.TextColor3 = Color3.new(0, 0, 0)
teleportCountLabel.TextScaled = true
teleportCountLabel.TextXAlignment = Enum.TextXAlignment.Left
teleportCountLabel.Font = Enum.Font.GothamBold
teleportCountLabel.Parent = mainFrame

local orderStatusLabel = Instance.new("TextLabel")
orderStatusLabel.Size = UDim2.new(1, 0, 0, 22)
orderStatusLabel.Position = UDim2.new(0, 10, 0, 105)
orderStatusLabel.BackgroundTransparency = 1
orderStatusLabel.Text = "等待接单"
orderStatusLabel.TextColor3 = Color3.new(0, 0, 0)
orderStatusLabel.TextScaled = true
orderStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
orderStatusLabel.Font = Enum.Font.Gotham
orderStatusLabel.Parent = mainFrame

local dotIndicator = Instance.new("Frame")
dotIndicator.Size = UDim2.new(0, 14, 0, 14)
dotIndicator.Position = UDim2.new(0, 0, 0, 48)
dotIndicator.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
dotIndicator.BorderSizePixel = 0
dotIndicator.Parent = mainFrame
local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = dotIndicator

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 140, 0, 40)
toggleButton.Position = UDim2.new(0.5, -70, 0, 150)
toggleButton.BackgroundColor3 = Color3.new(0.88, 0.88, 0.88)
toggleButton.Text = "启动"
toggleButton.TextColor3 = Color3.new(0, 0, 0)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold
toggleButton.BorderSizePixel = 0
toggleButton.Parent = mainFrame
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = toggleButton

-- ===================== 可拖动悬浮按钮 =====================
local floatBtn = Instance.new("TextButton")
floatBtn.Size = UDim2.new(0, 40, 0, 40)
floatBtn.Position = UDim2.new(0.92, 0, 0.4, 0)
floatBtn.BackgroundColor3 = Color3.new(1, 1, 1)
floatBtn.BorderSizePixel = 1
floatBtn.BorderColor3 = Color3.new(0.5, 0.5, 0.5)
floatBtn.Text = "功能"
floatBtn.TextColor3 = Color3.new(0, 0, 0)
floatBtn.TextScaled = true
floatBtn.Font = Enum.Font.GothamBold
floatBtn.Active = true
floatBtn.Draggable = true
floatBtn.Parent = screenGui
local floatCorner = Instance.new("UICorner")
floatCorner.CornerRadius = UDim.new(1, 0)
floatCorner.Parent = floatBtn

floatBtn.MouseButton1Click:Connect(function()
    if scriptClosed then return end
    mainPanelVisible = not mainPanelVisible
    mainFrame.Visible = mainPanelVisible
end)

-- 关闭原版彩虹流光
local function UpdateGlow() end
RunService.Heartbeat:Connect(UpdateGlow)

-- ===================== 原版出租车核心逻辑（未修改） =====================
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

local function AcceptOrder()
    ClickAt(phoneX, phoneY)
    task.wait(0.3)
    ClickAt(phoneX, phoneY + 100)
    task.wait(0.3)
    ClickAt(phoneX, phoneY + 160)
    task.wait(0.3)
    ClickAt(phoneX, phoneY + 240)
    task.wait(0.3)
    orderCount = orderCount + 1
    orderCountLabel.Text = "接单：" .. orderCount
    print("已接单")
end

local function GetTargetPosition()
    local targetFolder = workspace.Gameplay.Entities.ClientContent
    if not targetFolder then return nil end
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
        dotIndicator.BackgroundColor3 = Color3.new(0.2, 0.75, 0.3)
        toggleButton.Text = "停止"
    else
        statusLabel.Text = "已停止"
        dotIndicator.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
        toggleButton.Text = "启动"
        orderStatusLabel.Text = "等待接单"
    end
end

local function StartLoop()
    if isRunning or scriptClosed then return end
    isRunning = true
    UpdateUI(true)
    loopThread = coroutine.create(function()
        print("Luan自动出租车已启动")
        while isRunning and not scriptClosed do
            orderStatusLabel.Text = "正在自动接单"
            AcceptOrder()
            task.wait(1)

            orderStatusLabel.Text = "第一次传送"
            local targetPos1 = GetTargetPosition()
            if targetPos1 then
                TeleportCharacter(targetPos1)
                teleportCount = teleportCount + 1
                teleportCountLabel.Text = "传送：" .. teleportCount
                print("第一次传送完成")
            else
                warn("未找到目标位置")
            end
            task.wait(2.5)

            orderStatusLabel.Text = "第二次传送"
            local targetPos2 = GetTargetPosition()
            if targetPos2 then
                TeleportCharacter(targetPos2)
                teleportCount = teleportCount + 1
                teleportCountLabel.Text = "传送：" .. teleportCount
                print("第二次传送完成")
            else
                warn("未找到目标位置")
            end

            orderStatusLabel.Text = "订单完成，等待下一单"
            task.wait(2)
        end
    end)
    coroutine.resume(loopThread)
end

local function StopLoop()
    isRunning = false
    UpdateUI(false)
    loopThread = nil
end

toggleButton.MouseButton1Click:Connect(function()
    if scriptClosed then return end
    if isRunning then
        StopLoop()
    else
        StartLoop()
    end
end)

Player.CharacterAdded:Connect(function()
    if isRunning and not scriptClosed then
        task.wait(1)
        local pos = GetTargetPosition()
        if pos then
            pcall(function() TeleportCharacter(pos) end)
        end
    end
end)

UpdateUI(false)
print("Luan脚本加载完成，拖动右侧悬浮窗打开功能面板，点击X彻底关闭脚本")