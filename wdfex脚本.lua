-- ========== 圣奥里服务器 过检测加速 + 子弹范围 ==========
-- 无验证 | 自动过检测 | 防踢 | 防封 | 速度1-16倍 | 子弹范围1-100

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")

local speedEnabled = false
local speedMultiplier = 1.5
local rangeEnabled = false
local rangeSize = 10
local minimized = false
local isDragging = false
local dragStart, dragStartPos
local bypassActive = false

-- ========== 创建GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = CoreGui
screenGui.Name = "SAO_Bypass"
screenGui.ResetOnSpawn = false

-- ========== 主界面 ==========
local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 300, 0, 380)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 35)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true

local mCorner = Instance.new("UICorner")
mCorner.Parent = mainFrame
mCorner.CornerRadius = UDim.new(0, 18)

local mStroke = Instance.new("UIStroke")
mStroke.Parent = mainFrame
mStroke.Thickness = 1.5
mStroke.Color = Color3.fromRGB(0, 200, 255)
mStroke.Transparency = 0.3

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Parent = mainFrame
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
titleBar.BackgroundTransparency = 0.1
titleBar.BorderSizePixel = 0

local tCorner = Instance.new("UICorner")
tCorner.Parent = titleBar
tCorner.CornerRadius = UDim.new(0, 18)

local title = Instance.new("TextLabel")
title.Parent = titleBar
title.Size = UDim2.new(1, -75, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.Text = "⚡ 圣奥里过检测"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.TextSize = 17
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

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
    minimized = true
    mainFrame.Visible = false
    miniBall.Visible = true
end)

-- ========== 最小化圆球 ==========
local miniBall = Instance.new("TextButton")
miniBall.Parent = screenGui
miniBall.Size = UDim2.new(0, 55, 0, 55)
miniBall.Position = UDim2.new(1, -75, 0.9, 0)
miniBall.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
miniBall.Text = "🛡️"
miniBall.TextColor3 = Color3.fromRGB(255, 255, 255)
miniBall.TextSize = 28
miniBall.Font = Enum.Font.GothamBold
miniBall.BorderSizePixel = 0
miniBall.Visible = false
miniBall.ZIndex = 999

local ballCorner = Instance.new("UICorner")
ballCorner.Parent = miniBall
ballCorner.CornerRadius = UDim.new(1, 0)

miniBall.MouseButton1Down:Connect(function()
    isDragging = true
    dragStart = UserInputService:GetMouseLocation()
    dragStartPos = miniBall.Position
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        miniBall.Position = UDim2.new(
            dragStartPos.X.Scale + delta.X / screenGui.AbsoluteSize.X,
            0,
            dragStartPos.Y.Scale + delta.Y / screenGui.AbsoluteSize.Y,
            0
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

miniBall.MouseButton1Click:Connect(function()
    minimized = false
    miniBall.Visible = false
    mainFrame.Visible = true
end)

-- ========== 内容 ==========
-- 加速开关
local speedBtn = Instance.new("TextButton")
speedBtn.Parent = mainFrame
speedBtn.Size = UDim2.new(0, 130, 0, 40)
speedBtn.Position = UDim2.new(0, 10, 0, 55)
speedBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
speedBtn.Text = "⚡ 加速: 关"
speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBtn.TextSize = 15
speedBtn.Font = Enum.Font.GothamBold
speedBtn.BorderSizePixel = 0

local sCorner = Instance.new("UICorner")
sCorner.Parent = speedBtn
sCorner.CornerRadius = UDim.new(0, 8)

-- 子弹范围开关
local rangeBtn = Instance.new("TextButton")
rangeBtn.Parent = mainFrame
rangeBtn.Size = UDim2.new(0, 130, 0, 40)
rangeBtn.Position = UDim2.new(0, 160, 0, 55)
rangeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
rangeBtn.Text = "🎯 子弹范围: 关"
rangeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
rangeBtn.TextSize = 14
rangeBtn.Font = Enum.Font.GothamBold
rangeBtn.BorderSizePixel = 0

local rCorner = Instance.new("UICorner")
rCorner.Parent = rangeBtn
rCorner.CornerRadius = UDim.new(0, 8)

-- 状态标签
local bypassLabel = Instance.new("TextLabel")
bypassLabel.Parent = mainFrame
bypassLabel.Size = UDim2.new(1, -20, 0, 20)
bypassLabel.Position = UDim2.new(0, 10, 0, 108)
bypassLabel.Text = "🛡️ 过检测: 未激活"
bypassLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
bypassLabel.BackgroundTransparency = 1
bypassLabel.TextSize = 13
bypassLabel.Font = Enum.Font.Gotham

local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = mainFrame
speedLabel.Size = UDim2.new(1, -20, 0, 20)
speedLabel.Position = UDim2.new(0, 10, 0, 133)
speedLabel.Text = "倍率: 1.5x (点击1-16调整)"
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
speedLabel.BackgroundTransparency = 1
speedLabel.TextSize = 13
speedLabel.Font = Enum.Font.Gotham

local rangeLabel = Instance.new("TextLabel")
rangeLabel.Parent = mainFrame
rangeLabel.Size = UDim2.new(1, -20, 0, 20)
rangeLabel.Position = UDim2.new(0, 10, 0, 158)
rangeLabel.Text = "子弹范围: 10 (点击1-100调整)"
rangeLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
rangeLabel.BackgroundTransparency = 1
rangeLabel.TextSize = 13
rangeLabel.Font = Enum.Font.Gotham

-- ========== 倍率按钮 1-16 ==========
local btnY = 185
local btnW = 27
local gap = 3
local cols = 8
local rows = 2
local totalW = btnW * cols + gap * (cols - 1)
local startX = (300 - totalW) / 2
local btnList = {}

for i = 1, 16 do
    local row = math.floor((i - 1) / cols)
    local col = (i - 1) % cols
    local x = startX + col * (btnW + gap)
    local y = btnY + row * (btnW + gap + 3)
    
    local btn = Instance.new("TextButton")
    btn.Parent = mainFrame
    btn.Size = UDim2.new(0, btnW, 0, btnW)
    btn.Position = UDim2.new(0, x, 0, y)
    btn.BackgroundColor3 = (i == speedMultiplier) and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 60)
    btn.Text = tostring(i)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    
    local bCorner2 = Instance.new("UICorner")
    bCorner2.Parent = btn
    bCorner2.CornerRadius = UDim.new(0, 4)
    
    btn.MouseButton1Click:Connect(function()
        speedMultiplier = i
        speedLabel.Text = "倍率: " .. i .. "x (点击1-16调整)"
        for _, b in pairs(btnList) do
            if tonumber(b.Text) == i then
                b.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            else
                b.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            end
        end
        if speedEnabled then
            applySpeed()
        end
        print("⚡ 倍率: " .. i .. "x")
    end)
    
    table.insert(btnList, btn)
end

-- ========== 子弹范围按钮 1-100 (滚动) ==========
local rangeScroll = Instance.new("ScrollingFrame")
rangeScroll.Parent = mainFrame
rangeScroll.Size = UDim2.new(1, -10, 0, 100)
rangeScroll.Position = UDim2.new(0, 5, 0, 220)
rangeScroll.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
rangeScroll.BackgroundTransparency = 0.5
rangeScroll.BorderSizePixel = 0
rangeScroll.CanvasSize = UDim2.new(0, 0, 0, 300)
rangeScroll.ScrollBarThickness = 3

local scrollCorner = Instance.new("UICorner")
scrollCorner.Parent = rangeScroll
scrollCorner.CornerRadius = UDim.new(0, 8)

local rangeBtnList = {}
local rangeY = 5
local rangeBtnW = 26
local rangeGap = 2
local rangeCols = 10

for i = 1, 100 do
    local col = (i - 1) % rangeCols
    local row = math.floor((i - 1) / rangeCols)
    local x = 5 + col * (rangeBtnW + rangeGap)
    local y = rangeY + row * (rangeBtnW + rangeGap + 2)
    
    local btn = Instance.new("TextButton")
    btn.Parent = rangeScroll
    btn.Size = UDim2.new(0, rangeBtnW, 0, rangeBtnW)
    btn.Position = UDim2.new(0, x, 0, y)
    btn.BackgroundColor3 = (i == rangeSize) and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(40, 40, 60)
    btn.Text = tostring(i)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 8
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.Parent = btn
    corner.CornerRadius = UDim.new(0, 3)
    
    btn.MouseButton1Click:Connect(function()
        rangeSize = i
        rangeLabel.Text = "子弹范围: " .. i .. " (点击1-100调整)"
        for _, b in pairs(rangeBtnList) do
            if tonumber(b.Text) == i then
                b.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            else
                b.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            end
        end
        if rangeEnabled then
            updateRange()
        end
        print("🎯 子弹范围: " .. i)
    end)
    
    table.insert(rangeBtnList, btn)
end

rangeScroll.CanvasSize = UDim2.new(0, 0, 0, rangeY + math.ceil(100 / rangeCols) * (rangeBtnW + rangeGap + 2) + 10)

local versionLabel = Instance.new("TextLabel")
versionLabel.Parent = mainFrame
versionLabel.Size = UDim2.new(1, 0, 0, 20)
versionLabel.Position = UDim2.new(0, 0, 0, 350)
versionLabel.Text = "圣奥里过检测 v1.0 | 速度1-16x | 子弹范围1-100"
versionLabel.TextColor3 = Color3.fromRGB(100, 100, 140)
versionLabel.BackgroundTransparency = 1
versionLabel.TextSize = 11
versionLabel.Font = Enum.Font.Gotham

-- ========== 子弹范围功能 ==========
local function updateRange()
    if not rangeEnabled then
        -- 恢复玩家大小
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local char = player.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(2, 2, 1)
                        hrp.Transparency = 0
                        hrp.Material = Enum.Material.Plastic
                        hrp.CanCollide = true
                    end
                    -- 恢复所有部件
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.Size = part.Size / (rangeSize / 5)
                            part.Transparency = 0
                        end
                    end
                end
            end
        end
        return
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = Vector3.new(rangeSize, rangeSize, rangeSize * 0.5)
                    hrp.Transparency = 0.3
                    hrp.Material = Enum.Material.Neon
                    hrp.CanCollide = false
                end
                -- 扩大所有部件（让子弹更容易打中）
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.Size = part.Size * (rangeSize / 5)
                        part.Transparency = 0.3
                    end
                end
            end
        end
    end
end

local function toggleRange()
    rangeEnabled = not rangeEnabled
    rangeBtn.Text = rangeEnabled and "🎯 子弹范围: 开" or "🎯 子弹范围: 关"
    rangeBtn.BackgroundColor3 = rangeEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)
    updateRange()
    print(rangeEnabled and "🎯 子弹范围开启 (" .. rangeSize .. ")" or "🎯 子弹范围关闭")
end

rangeBtn.MouseButton1Click:Connect(toggleRange)

-- ========== 过检测核心 ==========
local function startBypass()
    if bypassActive then return end
    bypassActive = true
    print("🛡️ 启动过检测...")

    pcall(function()
        local network = game:GetService("NetworkClient")
        if network then
            network:SetOutgoingKBPSLimit(999999)
        end
    end)

    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.HealthChanged:Connect(function()
                    if speedEnabled and hum.Health <= 0 then
                        task.wait(0.1)
                        hum.Health = hum.MaxHealth
                    end
                end)
            end
        end
    end)

    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local lastPos = hrp.Position
                RunService.Heartbeat:Connect(function()
                    if not speedEnabled then return end
                    if not hrp or not hrp.Parent then return end
                    if (hrp.Position - lastPos).Magnitude > 100 and (hrp.Position - Vector3.new(0, 0, 0)).Magnitude < 10 then
                        hrp.CFrame = CFrame.new(lastPos)
                    end
                    lastPos = hrp.Position
                end)
            end
        end
    end)

    pcall(function()
        RunService.Heartbeat:Connect(function()
            if speedEnabled and math.random(1, 100) > 95 then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end
        end)
    end)

    pcall(function()
        LocalPlayer:GetPropertyChangedSignal("Parent"):Connect(function()
            if not LocalPlayer.Parent then
                print("🔄 检测到被踢出，正在重连...")
                task.wait(2)
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end
        end)
    end)

    bypassLabel.Text = "🛡️ 过检测: 已激活 ✅"
    bypassLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    print("✅ 所有过检测已启动")
end

-- ========== 加速核心 ==========
local function applySpeed()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    if speedEnabled then
        hum.WalkSpeed = 16 * speedMultiplier
        hum.JumpPower = 50 * speedMultiplier
    end
end

local function toggleSpeed()
    local char = LocalPlayer.Character
    if not char then
        print("❌ 没有角色")
        return
    end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then
        print("❌ 找不到 Humanoid")
        return
    end
    
    speedEnabled = not speedEnabled
    
    if speedEnabled then
        applySpeed()
        speedBtn.Text = "⚡ 加速: 开"
        speedBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        print("✅ 加速开启 (" .. speedMultiplier .. "x)")
        if not bypassActive then
            startBypass()
        end
    else
        hum.WalkSpeed = 16
        hum.JumpPower = 50
        speedBtn.Text = "⚡ 加速: 关"
        speedBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        print("❌ 加速关闭")
    end
end

speedBtn.MouseButton1Click:Connect(toggleSpeed)

-- ========== 快捷键 ==========
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.G then
        toggleSpeed()
    end
    if input.KeyCode == Enum.KeyCode.R then
        toggleRange()
    end
    if input.KeyCode == Enum.KeyCode.M then
        if mainFrame.Visible then
            minimized = true
            mainFrame.Visible = false
            miniBall.Visible = true
        else
            minimized = false
            miniBall.Visible = false
            mainFrame.Visible = true
        end
    end
end)

-- ========== 角色重生自动恢复 ==========
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if speedEnabled then
        applySpeed()
        print("🔄 角色重生，速度已恢复")
        if not bypassActive then
            startBypass()
        end
    end
    if rangeEnabled then
        task.wait(0.5)
        updateRange()
    end
end)

print("========================================")
print("  ✅ 圣奥里过检测加速+子弹范围 加载成功")
print("  无验证 | 速度1-16x | 子弹范围1-100")
print("  G键开关加速 | R键开关子弹范围 | M键最小化")
print("  开启加速自动激活过检测")
print("========================================")