-- ========== wdfex 刷钱 ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local isRunning = false
local teleportCount = 0
local currentMode = "出租车"
local loopThread = nil

local Settings = {
    TaxiWaitTime = 7,
}

-- ===== UI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 240, 0, 280)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -140)
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

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "wdfex 刷钱"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleLine = Instance.new("Frame")
titleLine.Size = UDim2.new(0.8, 0, 0, 3)
titleLine.Position = UDim2.new(0.1, 0, 0, 40)
titleLine.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
titleLine.BorderSizePixel = 0
titleLine.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 50)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "已停止"
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
statusLabel.TextScaled = true
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

local countLabel = Instance.new("TextLabel")
countLabel.Size = UDim2.new(1, 0, 0, 25)
countLabel.Position = UDim2.new(0, 10, 0, 80)
countLabel.BackgroundTransparency = 1
countLabel.Text = "传送: 0"
countLabel.TextColor3 = Color3.fromRGB(70, 150, 255)
countLabel.TextScaled = true
countLabel.TextXAlignment = Enum.TextXAlignment.Left
countLabel.Font = Enum.Font.GothamBold
countLabel.Parent = mainFrame

local modeLabel = Instance.new("TextLabel")
modeLabel.Size = UDim2.new(1, 0, 0, 22)
modeLabel.Position = UDim2.new(0, 10, 0, 108)
modeLabel.BackgroundTransparency = 1
modeLabel.Text = "模式: 出租车"
modeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
modeLabel.TextScaled = true
modeLabel.TextXAlignment = Enum.TextXAlignment.Left
modeLabel.Font = Enum.Font.Gotham
modeLabel.Parent = mainFrame

local dotIndicator = Instance.new("Frame")
dotIndicator.Size = UDim2.new(0, 14, 0, 14)
dotIndicator.Position = UDim2.new(0, 0, 0, 50)
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
toggleButton.Position = UDim2.new(0.5, -70, 0, 160)
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

local modeButton = Instance.new("TextButton")
modeButton.Size = UDim2.new(0, 100, 0, 30)
modeButton.Position = UDim2.new(0.5, -50, 0, 210)
modeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
modeButton.Text = "切换: 出租车"
modeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
modeButton.TextScaled = true
modeButton.Font = Enum.Font.Gotham
modeButton.BorderSizePixel = 0
modeButton.Parent = mainFrame

local modeBtnCorner = Instance.new("UICorner")
modeBtnCorner.CornerRadius = UDim.new(0, 8)
modeBtnCorner.Parent = modeButton

-- ===== 功能函数 =====
local function TeleportTo(pos)
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root and pos then
        local hum = char:FindFirstChild("Humanoid")
        if hum and hum.SeatPart then hum.Sit = false task.wait(0.1) end
        root.CFrame = CFrame.new(pos)
        root.Velocity = Vector3.new(0,0,0)
        root.RotVelocity = Vector3.new(0,0,0)
        teleportCount = teleportCount + 1
        countLabel.Text = "传送: " .. teleportCount
    end
end

local function GetAreas()
    local areas = {}
    local clientContent = Workspace:FindFirstChild("Gameplay") and Workspace.Gameplay:FindFirstChild("Entities") and Workspace.Gameplay.Entities:FindFirstChild("ClientContent")
    local searchRoot = clientContent or Workspace
    for _, obj in ipairs(searchRoot:GetDescendants()) do
        if obj.Name == "Area" and obj:IsA("BasePart") then
            table.insert(areas, obj)
        end
    end
    return areas
end

local function GetTargetPosition()
    local targetFolder = Workspace:FindFirstChild("Gameplay") and Workspace.Gameplay:FindFirstChild("Entities") and Workspace.Gameplay.Entities:FindFirstChild("ClientContent")
    if not targetFolder then return nil end
    for _, child in ipairs(targetFolder:GetDescendants()) do
        if child:IsA("BasePart") then
            return child.Position + Vector3.new(0, 3, 0)
        end
    end
    return nil
end

local function MainLoop()
    while isRunning do
        if currentMode == "出租车" then
            local areas = GetAreas()
            if #areas == 0 then
                local pos = GetTargetPosition()
                if pos then TeleportTo(pos) end
                task.wait(Settings.TaxiWaitTime)
            else
                for _, area in ipairs(areas) do
                    if not isRunning then break end
                    TeleportTo(area.Position + Vector3.new(0, 0, 5))
                    task.wait(Settings.TaxiWaitTime)
                end
            end
        elseif currentMode == "公交车" then
            local areas = GetAreas()
            if #areas == 0 then
                task.wait(5)
            else
                for _, area in ipairs(areas) do
                    if not isRunning then break end
                    local targetPos = area.Position + Vector3.new(3, 3, 16)
                    TeleportTo(targetPos)
                    task.wait(Settings.TaxiWaitTime)
                end
            end
        end
    end
end

-- ===== 按钮事件 =====
toggleButton.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        toggleButton.Text = "停止"
        toggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        statusLabel.Text = "运行中"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        dotIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        dotGlow.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        if loopThread then loopThread = nil end
        loopThread = task.spawn(MainLoop)
    else
        toggleButton.Text = "启动"
        toggleButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        statusLabel.Text = "已停止"
        statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        dotIndicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        dotGlow.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        if loopThread then task.cancel(loopThread) end
        loopThread = nil
    end
end)

modeButton.MouseButton1Click:Connect(function()
    if currentMode == "出租车" then
        currentMode = "公交车"
        modeButton.Text = "切换: 公交车"
        modeLabel.Text = "模式: 公交车"
    else
        currentMode = "出租车"
        modeButton.Text = "切换: 出租车"
        modeLabel.Text = "模式: 出租车"
    end
end)

print("wdfex 刷钱已加载 | 模式: " .. currentMode)