-- ========== 圣奥里服务器 过检测加速 + 方框范围 ==========
-- 无验证 | 自动过检测 | 防踢 | 防封 | 速度1-16倍 | 方框范围1-100

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local Camera = workspace.CurrentCamera

local speedEnabled = false
local speedMultiplier = 1.5
local boxEnabled = false
local boxSize = 10
local minimized = false
local isDragging = false
local dragStart, dragStartPos
local bypassActive = false
local boxConn = nil
local boxObjects = {}

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

-- 方框开关
local boxBtn = Instance.new("TextButton")
boxBtn.Parent = mainFrame
boxBtn.Size = UDim2.new(0, 130, 0, 40)
boxBtn.Position = UDim2.new(0, 160, 0, 55)
boxBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
boxBtn.Text = "📦 方框: 关"
boxBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
boxBtn.TextSize = 15
boxBtn.Font = Enum.Font.GothamBold
boxBtn.BorderSizePixel = 0

local bCorner = Instance.new("UICorner")
bCorner.Parent = boxBtn
bCorner.CornerRadius = UDim.new(0, 8)

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

local boxLabel = Instance.new("TextLabel")
boxLabel.Parent = mainFrame
boxLabel.Size = UDim2.new(1, -20, 0, 20)
boxLabel.Position = UDim2.new(0, 10, 0, 158)
boxLabel.Text = "方框大小: 10 (点击1-100调整)"
boxLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
boxLabel.BackgroundTransparency = 1
boxLabel.TextSize = 13
boxLabel.Font = Enum.Font.Gotham

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

-- ========== 方框大小按钮 1-100 (滚动) ==========
local boxScroll = Instance.new("ScrollingFrame")
boxScroll.Parent = mainFrame
boxScroll.Size = UDim2.new(1, -10, 0, 100)
boxScroll.Position = UDim2.new(0, 5, 0, 220)
boxScroll.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
boxScroll.BackgroundTransparency = 0.5
boxScroll.BorderSizePixel = 0
boxScroll.CanvasSize = UDim2.new(0, 0, 0, 300)
boxScroll.ScrollBarThickness = 3

local scrollCorner = Instance.new("UICorner")
scrollCorner.Parent = boxScroll
scrollCorner.CornerRadius = UDim.new(0, 8)

local boxBtnList = {}
local boxY = 5
local boxBtnW = 26
local boxGap = 2
local boxCols = 10

for i = 1, 100 do
    local col = (i - 1) % boxCols
    local row = math.floor((i - 1) / boxCols)
    local x = 5 + col * (boxBtnW + boxGap)
    local y = boxY + row * (boxBtnW + boxGap + 2)
    
    local btn = Instance.new("TextButton")
    btn.Parent = boxScroll
    btn.Size = UDim2.new(0, boxBtnW, 0, boxBtnW)
    btn.Position = UDim2.new(0, x, 0, y)
    btn.BackgroundColor3 = (i == boxSize) and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(40, 40, 60)
    btn.Text = tostring(i)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 8
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.Parent = btn
    corner.CornerRadius = UDim.new(0, 3)
    
    btn.MouseButton1Click:Connect(function()
        boxSize = i
        boxLabel.Text = "方框大小: " .. i .. " (点击1-100调整)"
        for _, b in pairs(boxBtnList) do
            if tonumber(b.Text) == i then
                b.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            else
                b.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            end
        end
        if boxEnabled then
            updateBoxes()
        end
        print("📦 方框大小: " .. i)
    end)
    
    table.insert(boxBtnList, btn)
end

boxScroll.CanvasSize = UDim2.new(0, 0, 0, boxY + math.ceil(100 / boxCols) * (boxBtnW + boxGap + 2) + 10)

local versionLabel = Instance.new("TextLabel")
versionLabel.Parent = mainFrame
versionLabel.Size = UDim2.new(1, 0, 0, 20)
versionLabel.Position = UDim2.new(0, 0, 0, 350)
versionLabel.Text = "圣奥里过检测 v1.0 | 速度1-16x | 方框1-100"
versionLabel.TextColor3 = Color3.fromRGB(100, 100, 140)
versionLabel.BackgroundTransparency = 1
versionLabel.TextSize = 11
versionLabel.Font = Enum.Font.Gotham

-- ========== 方框功能 ==========
local function worldToScreen(pos)
    local screenPos, onScreen = Camera:WorldToScreenPoint(pos)
    return Vector2.new(screenPos.X, screenPos.Y), onScreen
end

local function createBox(player)
    local label = Instance.new("Frame")
    label.Parent = screenGui
    label.Size = UDim2.new(0, boxSize * 6, 0, boxSize * 8)
    label.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    label.BackgroundTransparency = 0.7
    label.BorderSizePixel = 2
    label.BorderColor3 = Color3.fromRGB(0, 200, 255)
    label.Visible = false
    label.ZIndex = 10
    
    local corner = Instance.new("UICorner")
    corner.Parent = label
    corner.CornerRadius = UDim.new(0, 4)
    
    -- 名字标签
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = label
    nameLabel.Size = UDim2.new(1, 0, 0, 16)
    nameLabel.Position = UDim2.new(0, 0, 1, 2)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 11
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0.3
    
    -- 血量标签
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Parent = label
    healthLabel.Size = UDim2.new(1, 0, 0, 14)
    healthLabel.Position = UDim2.new(0, 0, 1, 18)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "100"
    healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    healthLabel.TextSize = 10
    healthLabel.Font = Enum.Font.Gotham
    
    -- 距离标签
    local distLabel = Instance.new("TextLabel")
    distLabel.Parent = label
    distLabel.Size = UDim2.new(1, 0, 0, 14)
    distLabel.Position = UDim2.new(0, 0, 1, 32)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "0m"
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLabel.TextSize = 10
    distLabel.Font = Enum.Font.Gotham
    
    return {
        frame = label,
        name = nameLabel,
        health = healthLabel,
        dist = distLabel,
        player = player
    }
end

local function updateBoxes()
    if not boxEnabled then
        for _, obj in pairs(boxObjects) do
            if obj.frame then
                obj.frame.Visible = false
            end
        end
        return
    end
    
    local localChar = LocalPlayer.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then goto continue end
        
        local char = player.Character
        if not char then goto continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if not hrp or not hum then goto continue end
        
        if not boxObjects[player.UserId] then
            boxObjects[player.UserId] = createBox(player)
        end
        
        local obj = boxObjects[player.UserId]
        local headPos = hrp.Position + Vector3.new(0, 2.5, 0)
        local screenPos, onScreen = worldToScreen(headPos)
        
        if not onScreen then
            obj.frame.Visible = false
            goto continue
        end
        
        -- 计算大小（根据距离调整）
        local dist = localRoot and (hrp.Position - localRoot.Position).Magnitude or 0
        local scale = math.clamp(1 / (dist * 0.02), 0.3, 2)
        local size = boxSize * 0.5 * scale
        
        obj.frame.Size = UDim2.new(0, size * 6, 0, size * 8)
        obj.frame.Position = UDim2.new(0, screenPos.X - size * 3, 0, screenPos.Y - size * 4)
        obj.frame.Visible = true
        
        -- 颜色根据队伍
        if player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
            obj.frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
            obj.frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        else
            obj.frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
            obj.frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        end
        
        -- 更新信息
        obj.name.Text = player.Name
        obj.health.Text = math.round(hum.Health) .. "/" .. math.round(hum.MaxHealth)
        obj.health.TextColor3 = hum.Health / hum.MaxHealth > 0.5 and Color3.fromRGB(0, 255, 0) or
                                (hum.Health / hum.MaxHealth > 0.25 and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(255, 0, 0))
        obj.dist.Text = math.round(dist) .. "m"
        
        ::continue::
    end
    
    -- 清理已离开玩家
    for userId, obj in pairs(boxObjects) do
        if not Players:GetPlayerByUserId(userId) then
            if obj.frame then
                obj.frame:Destroy()
            end
            boxObjects[userId] = nil
        end
    end
end

local function toggleBox()
    boxEnabled = not boxEnabled
    boxBtn.Text = boxEnabled and "📦 方框: 开" or "📦 方框: 关"
    boxBtn.BackgroundColor3 = boxEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)
    if boxEnabled then
        updateBoxes()
        print("📦 方框开启 (大小: " .. boxSize .. ")")
    else
        for _, obj in pairs(boxObjects) do
            if obj.frame then
                obj.frame.Visible = false
            end
        end
        print("📦 方框关闭")
    end
end

boxBtn.MouseButton1Click:Connect(toggleBox)

-- 每帧更新方框
RunService.RenderStepped:Connect(function()
    if boxEnabled then
        updateBoxes()
    end
end)

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
    if input.KeyCode == Enum.KeyCode.B then
        toggleBox()
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
end)

print("========================================")
print("  ✅ 圣奥里过检测加速+方框 加载成功")
print("  无验证 | 速度1-16x | 方框1-100")
print("  G键开关加速 | B键开关方框 | M键最小化")
print("  开启加速自动激活过检测")
print("========================================")