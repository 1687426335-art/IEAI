-- ========== wdfex 公交车刷钱测试版 ==========
local Players = game:GetService("Players")
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
    StopLoop()
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
title.Text = "wdfex 公交车刷钱测试"
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
orderCountLabel.Text = "对齐: 0"
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
orderStatusLabel.Text = "等待启动..."
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
local alignCount = 0
local teleportCount = 0

-- ===== 找圈并让公交车对齐 =====
local function FindNearestCircle()
    local nearest = nil
    local minDist = math.huge
    local char = Player.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name:find("circle") or name:find("ring") or name:find("aura") or 
               name:find("glow") or name:find("光环") or name:find("光圈") or
               name:find("marker") or name:find("target") or name:find("point") then
                local color = obj.Color
                if color then
                    local r, g, b = color.R * 255, color.G * 255, color.B * 255
                    if b > r and b > g and b > 80 then
                        local dist = (obj.Position - hrp.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            nearest = obj
                        end
                    end
                end
            end
        end
    end
    return nearest
end

local function AlignToCircle(circle)
    local char = Player.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid and humanoid.SeatPart then
        humanoid.Sit = false
        task.wait(0.1)
    end
    
    local circlePos = circle.Position
    local lookAt = circle.CFrame.LookVector or Vector3.new(1, 0, 0)
    
    hrp.CFrame = CFrame.new(circlePos + Vector3.new(0, 3, 0), circlePos + lookAt)
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
        orderStatusLabel.Text = "等待启动..."
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
        print("公交车刷钱已启动")
        
        while isRunning do
            orderStatusLabel.Text = "正在寻找圈..."
            local circle = FindNearestCircle()
            
            if circle then
                orderStatusLabel.Text = "找到圈，正在对齐..."
                local success = AlignToCircle(circle)
                if success then
                    alignCount = alignCount + 1
                    orderCountLabel.Text = "对齐: " .. alignCount
                    teleportCount = teleportCount + 1
                    teleportCountLabel.Text = "传送: " .. teleportCount
                    print("公交车已对齐到圈")
                else
                    warn("对齐失败")
                end
                task.wait(2)
            else
                orderStatusLabel.Text = "未找到圈，继续搜索..."
                task.wait(1)
            end
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
        local circle = FindNearestCircle()
        if circle then
            pcall(function() AlignToCircle(circle) end)
        end
    end
end)

UpdateUI(false)
print("UI已加载，点击启动开始")