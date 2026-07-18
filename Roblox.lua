-- ========== 皮脚本 无卡密版 ==========

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Camera = workspace.CurrentCamera

local minimized = false
local currentTab = "信息"
local isDragging = false
local dragStart, dragStartPos

-- ========== 功能变量 ==========
local speedEnabled = false
local speedMultiplier = 2
local jumpEnabled = false
local infiniteJump = false
local flyEnabled = false
local flySpeed = 50
local espEnabled = false
local aimbotEnabled = false
local noClipEnabled = false
local godMode = false
local walkSpeed = 16
local jumpPower = 50
local gravity = 196.2
local nightVision = false
local currentBrightness = 1
local displayObjects = {}

-- ========== 创建GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = CoreGui
screenGui.Name = "PiScript"
screenGui.ResetOnSpawn = false

-- ========== 主界面 ==========
local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 420, 0, 470)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -235)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 35)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true

local mCorner = Instance.new("UICorner")
mCorner.Parent = mainFrame
mCorner.CornerRadius = UDim.new(0, 16)

local mStroke = Instance.new("UIStroke")
mStroke.Parent = mainFrame
mStroke.Thickness = 1.5
mStroke.Color = Color3.fromRGB(0, 200, 255)
mStroke.Transparency = 0.3

-- ========== 标题栏 ==========
local titleBar = Instance.new("Frame")
titleBar.Parent = mainFrame
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
titleBar.BackgroundTransparency = 0.1
titleBar.BorderSizePixel = 0

local tCorner = Instance.new("UICorner")
tCorner.Parent = titleBar
tCorner.CornerRadius = UDim.new(0, 16)

local title = Instance.new("TextLabel")
title.Parent = titleBar
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.Text = "⚡ 皮脚本"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.TextSize = 18
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

-- ========== 分类按钮 ==========
local tabs = {"信息", "本地玩家", "通用", "旋转与范围", "传送与甩飞", "自动说话", "时间", "透视", "自瞄"}
local tabBtns = {}

local tabBar = Instance.new("ScrollingFrame")
tabBar.Parent = mainFrame
tabBar.Size = UDim2.new(1, 0, 0, 35)
tabBar.Position = UDim2.new(0, 0, 0, 42)
tabBar.BackgroundTransparency = 1
tabBar.BorderSizePixel = 0
tabBar.ScrollBarThickness = 3
tabBar.CanvasSize = UDim2.new(0, #tabs * 75, 0, 0)

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Parent = tabBar
    btn.Size = UDim2.new(0, 70, 1, 0)
    btn.Position = UDim2.new(0, (i-1) * 73, 0, 0)
    btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 60)
    btn.Text = tabName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Name = tabName
    
    local bCorner = Instance.new("UICorner")
    bCorner.Parent = btn
    bCorner.CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        currentTab = tabName
        for _, b in pairs(tabBtns) do
            b.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        end
        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        updateContent(tabName)
    end)
    
    table.insert(tabBtns, btn)
end

-- ========== 内容容器 ==========
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Parent = mainFrame
contentFrame.Size = UDim2.new(1, -10, 0, 370)
contentFrame.Position = UDim2.new(0, 5, 0, 82)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
contentFrame.BackgroundTransparency = 0.3
contentFrame.BorderSizePixel = 0
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
contentFrame.ScrollBarThickness = 4

local cCorner = Instance.new("UICorner")
cCorner.Parent = contentFrame
cCorner.CornerRadius = UDim.new(0, 10)

-- ========== 创建切换开关 ==========
local function createToggle(parent, y, label, default, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(1, -10, 0, 35)
    frame.Position = UDim2.new(0, 5, 0, y)
    frame.BackgroundTransparency = 1
    
    local labelText = Instance.new("TextLabel")
    labelText.Parent = frame
    labelText.Size = UDim2.new(0, 200, 1, 0)
    labelText.Text = label
    labelText.TextColor3 = Color3.fromRGB(220, 220, 230)
    labelText.BackgroundTransparency = 1
    labelText.TextSize = 14
    labelText.Font = Enum.Font.Gotham
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    
    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.Size = UDim2.new(0, 60, 0, 28)
    btn.Position = UDim2.new(1, -65, 0.5, -14)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)
    btn.Text = default and "开" or "关"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    
    local bCorner = Instance.new("UICorner")
    bCorner.Parent = btn
    bCorner.CornerRadius = UDim.new(0, 6)
    
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)
        btn.Text = state and "开" or "关"
        if callback then callback(state) end
    end)
    
    return {btn = btn, frame = frame, getState = function() return state end}
end

-- ========== 创建输入框 ==========
local function createInput(parent, y, label, default, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(1, -10, 0, 35)
    frame.Position = UDim2.new(0, 5, 0, y)
    frame.BackgroundTransparency = 1
    
    local labelText = Instance.new("TextLabel")
    labelText.Parent = frame
    labelText.Size = UDim2.new(0, 150, 1, 0)
    labelText.Text = label
    labelText.TextColor3 = Color3.fromRGB(220, 220, 230)
    labelText.BackgroundTransparency = 1
    labelText.TextSize = 14
    labelText.Font = Enum.Font.Gotham
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    
    local inputBox = Instance.new("TextBox")
    inputBox.Parent = frame
    inputBox.Size = UDim2.new(0, 80, 0, 28)
    inputBox.Position = UDim2.new(1, -85, 0.5, -14)
    inputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.Text = tostring(default)
    inputBox.TextSize = 14
    inputBox.Font = Enum.Font.Gotham
    inputBox.BorderSizePixel = 0
    inputBox.ClearTextOnFocus = false
    
    local bCorner = Instance.new("UICorner")
    bCorner.Parent = inputBox
    bCorner.CornerRadius = UDim.new(0, 6)
    
    inputBox.FocusLost:Connect(function()
        local val = tonumber(inputBox.Text)
        if val then
            if callback then callback(val) end
        else
            inputBox.Text = tostring(default)
        end
    end)
    
    return inputBox
end

-- ========== 内容更新 ==========
local function updateContent(tab)
    for _, child in pairs(contentFrame:GetChildren()) do
        child:Destroy()
    end
    
    local y = 5
    
    if tab == "信息" then
        local info = {
            {"用户名", LocalPlayer.Name},
            {"用户ID", LocalPlayer.UserId},
            {"客户端ID", "已连接"},
            {"地区", "US"},
            {"语言", "zh-cn"},
            {"账户年龄", "1天"},
            {"注入器", "Delta"},
            {"服务器ID", game.JobId or "未知"},
            {"总人数", #Players:GetPlayers()},
        }
        for _, item in ipairs(info) do
            local label = Instance.new("TextLabel")
            label.Parent = contentFrame
            label.Size = UDim2.new(1, -10, 0, 28)
            label.Position = UDim2.new(0, 5, 0, y)
            label.Text = item[1] .. ": " .. tostring(item[2])
            label.TextColor3 = Color3.fromRGB(200, 200, 220)
            label.BackgroundTransparency = 1
            label.TextSize = 14
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            y = y + 32
        end
        
    elseif tab == "本地玩家" then
        local info = {
            {"用户名", LocalPlayer.Name},
            {"用户ID", LocalPlayer.UserId},
            {"客户端ID", "已连接"},
            {"地区", "US"},
            {"语言", "zh-cn"},
            {"账户年龄", "1天"},
        }
        for _, item in ipairs(info) do
            local label = Instance.new("TextLabel")
            label.Parent = contentFrame
            label.Size = UDim2.new(1, -10, 0, 28)
            label.Position = UDim2.new(0, 5, 0, y)
            label.Text = item[1] .. ": " .. tostring(item[2])
            label.TextColor3 = Color3.fromRGB(200, 200, 220)
            label.BackgroundTransparency = 1
            label.TextSize = 14
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            y = y + 32
        end
        
    elseif tab == "通用" then
        local speedToggle = createToggle(contentFrame, y, "快速跑步", false, function(s)
            speedEnabled = s
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum then
                    if s then
                        hum.WalkSpeed = 16 * speedMultiplier
                        hum.JumpPower = 50 * speedMultiplier
                    else
                        hum.WalkSpeed = 16
                        hum.JumpPower = 50
                    end
                end
            end
        end)
        y = y + 40
        
        local speedInput = createInput(contentFrame, y, "设置速度", speedMultiplier, function(v)
            speedMultiplier = v
            if speedEnabled then
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum then
                        hum.WalkSpeed = 16 * v
                        hum.JumpPower = 50 * v
                    end
                end
            end
        end)
        y = y + 40
        
        local jumpToggle = createToggle(contentFrame, y, "无限跳跃", false, function(s)
            infiniteJump = s
        end)
        y = y + 40
        
        local godToggle = createToggle(contentFrame, y, "上帝模式", false, function(s)
            godMode = s
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum then
                    if s then
                        hum.MaxHealth = math.huge
                        hum.Health = math.huge
                    else
                        hum.MaxHealth = 100
                        hum.Health = 100
                    end
                end
            end
        end)
        y = y + 40
        
        local noClipToggle = createToggle(contentFrame, y, "穿墙", false, function(s)
            noClipEnabled = s
        end)
        y = y + 40
        
    elseif tab == "传送与甩飞" then
        local teleportBtn = Instance.new("TextButton")
        teleportBtn.Parent = contentFrame
        teleportBtn.Size = UDim2.new(0, 150, 0, 35)
        teleportBtn.Position = UDim2.new(0.5, -75, 0, y)
        teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        teleportBtn.Text = "📍 传送最近玩家"
        teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        teleportBtn.TextSize = 14
        teleportBtn.Font = Enum.Font.GothamBold
        teleportBtn.BorderSizePixel = 0
        local btnCorner = Instance.new("UICorner")
        btnCorner.Parent = teleportBtn
        btnCorner.CornerRadius = UDim.new(0, 8)
        teleportBtn.MouseButton1Click:Connect(function()
            local target = nil
            local dist = math.huge
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = p.Character.HumanoidRootPart
                    local lhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if lhrp then
                        local d = (hrp.Position - lhrp.Position).Magnitude
                        if d < dist then
                            dist = d
                            target = p
                        end
                    end
                end
            end
            if target and LocalPlayer.Character then
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                end
            end
        end)
        y = y + 45
        
        local flyToggle = createToggle(contentFrame, y, "皮飞行", false, function(s)
            flyEnabled = s
        end)
        y = y + 40
        
    elseif tab == "透视" then
        local espToggle = createToggle(contentFrame, y, "通用ESP", false, function(s)
            espEnabled = s
            if not s then
                for _, obj in pairs(displayObjects) do
                    if obj then pcall(function() obj:Destroy() end) end
                end
                displayObjects = {}
            end
        end)
        y = y + 40
        
        local info = Instance.new("TextLabel")
        info.Parent = contentFrame
        info.Size = UDim2.new(1, -10, 0, 60)
        info.Position = UDim2.new(0, 5, 0, y)
        info.Text = "📋 显示: 玩家名字 | 血量 | 距离\n⚠️ 部分游戏可能不兼容"
        info.TextColor3 = Color3.fromRGB(180, 180, 210)
        info.BackgroundTransparency = 1
        info.TextSize = 13
        info.Font = Enum.Font.Gotham
        info.TextXAlignment = Enum.TextXAlignment.Left
        y = y + 70
        
    elseif tab == "自瞄" then
        local aimToggle = createToggle(contentFrame, y, "自瞄", false, function(s)
            aimbotEnabled = s
        end)
        y = y + 40
        
        local info = Instance.new("TextLabel")
        info.Parent = contentFrame
        info.Size = UDim2.new(1, -10, 0, 40)
        info.Position = UDim2.new(0, 5, 0, y)
        info.Text = "⚠️ 自瞄功能需要装备武器\n点击开启后自动瞄准最近敌人"
        info.TextColor3 = Color3.fromRGB(255, 200, 100)
        info.BackgroundTransparency = 1
        info.TextSize = 13
        info.Font = Enum.Font.Gotham
        info.TextXAlignment = Enum.TextXAlignment.Left
        y = y + 50
        
    elseif tab == "自动说话" then
        local chatInput = Instance.new("TextBox")
        chatInput.Parent = contentFrame
        chatInput.Size = UDim2.new(0, 250, 0, 35)
        chatInput.Position = UDim2.new(0.5, -125, 0, y)
        chatInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        chatInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        chatInput.Text = ""
        chatInput.PlaceholderText = "输入要发送的消息..."
        chatInput.TextSize = 14
        chatInput.Font = Enum.Font.Gotham
        chatInput.BorderSizePixel = 0
        local cCorner = Instance.new("UICorner")
        cCorner.Parent = chatInput
        cCorner.CornerRadius = UDim.new(0, 8)
        y = y + 45
        
        local sendBtn = Instance.new("TextButton")
        sendBtn.Parent = contentFrame
        sendBtn.Size = UDim2.new(0, 150, 0, 35)
        sendBtn.Position = UDim2.new(0.5, -75, 0, y)
        sendBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        sendBtn.Text = "📤 发送消息"
        sendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        sendBtn.TextSize = 14
        sendBtn.Font = Enum.Font.GothamBold
        sendBtn.BorderSizePixel = 0
        local btnCorner = Instance.new("UICorner")
        btnCorner.Parent = sendBtn
        btnCorner.CornerRadius = UDim.new(0, 8)
        sendBtn.MouseButton1Click:Connect(function()
            if chatInput.Text ~= "" then
                game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest"):FireServer(chatInput.Text, "All")
            end
        end)
        y = y + 45
        
    elseif tab == "时间" then
        local info = Instance.new("TextLabel")
        info.Parent = contentFrame
        info.Size = UDim2.new(1, -10, 0, 60)
        info.Position = UDim2.new(0, 5, 0, y)
        info.Text = "🕐 当前时间: " .. os.date("%Y-%m-%d %H:%M:%S")
        info.TextColor3 = Color3.fromRGB(200, 200, 220)
        info.BackgroundTransparency = 1
        info.TextSize = 14
        info.Font = Enum.Font.Gotham
        info.TextXAlignment = Enum.TextXAlignment.Left
        y = y + 40
        
        local timeLabel = Instance.new("TextLabel")
        timeLabel.Parent = contentFrame
        timeLabel.Size = UDim2.new(1, -10, 0, 30)
        timeLabel.Position = UDim2.new(0, 5, 0, y)
        timeLabel.Text = "⏱️ 服务器运行时间: " .. math.floor(os.time() - game:GetService("RunService"):GetTime())
        timeLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
        timeLabel.BackgroundTransparency = 1
        timeLabel.TextSize = 14
        timeLabel.Font = Enum.Font.Gotham
        timeLabel.TextXAlignment = Enum.TextXAlignment.Left
        y = y + 40
        
    elseif tab == "旋转与范围" then
        local zoomInput = createInput(contentFrame, y, "缩放距离", 128, function(v)
            Camera.FieldOfView = v
        end)
        y = y + 40
    end
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, y + 20)
end

-- ========== 最小化圆球 ==========
local miniBall = Instance.new("TextButton")
miniBall.Parent = screenGui
miniBall.Size = UDim2.new(0, 55, 0, 55)
miniBall.Position = UDim2.new(1, -75, 0.9, 0)
miniBall.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
miniBall.Text = "⚡"
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

-- ========== 透视核心 ==========
local function worldToScreen(pos)
    local sp, onScreen = Camera:WorldToScreenPoint(pos)
    return Vector2.new(sp.X, sp.Y), onScreen
end

local function updateESP()
    if not espEnabled then
        for _, obj in pairs(displayObjects) do
            if obj then pcall(function() obj.Visible = false end) end
        end
        return
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then goto continue end
        local char = player.Character
        if not char then goto continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if not hrp or not hum then goto continue end

        if not displayObjects[player.UserId] then
            local label = Instance.new("TextLabel")
            label.Parent = screenGui
            label.Size = UDim2.new(0, 180, 0, 50)
            label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            label.BackgroundTransparency = 0.5
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextSize = 13
            label.Font = Enum.Font.GothamBold
            label.Text = ""
            label.BorderSizePixel = 0
            local corner = Instance.new("UICorner")
            corner.Parent = label
            corner.CornerRadius = UDim.new(0, 6)
            
            local healthBar = Instance.new("Frame")
            healthBar.Parent = label
            healthBar.Size = UDim2.new(1, -10, 0, 4)
            healthBar.Position = UDim2.new(0, 5, 0, 42)
            healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            healthBar.BorderSizePixel = 0
            
            local healthBg = Instance.new("Frame")
            healthBg.Parent = label
            healthBg.Size = UDim2.new(1, -10, 0, 4)
            healthBg.Position = UDim2.new(0, 5, 0, 42)
            healthBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            healthBg.BorderSizePixel = 0
            
            displayObjects[player.UserId] = {label = label, healthBar = healthBar}
        end

        local obj = displayObjects[player.UserId]
        local headPos = hrp.Position + Vector3.new(0, 2.5, 0)
        local screenPos, onScreen = worldToScreen(headPos)

        if not onScreen then
            obj.label.Visible = false
            goto continue
        end

        obj.label.Position = UDim2.new(0, screenPos.X - 90, 0, screenPos.Y - 30)
        obj.label.Visible = true

        local hpPercent = math.max(hum.Health / hum.MaxHealth, 0)
        local localPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local dist = localPos and (hrp.Position - localPos.Position).Magnitude or 0
        
        obj.label.Text = string.format("%s\n❤️%d  📏%dm", player.Name, math.round(hum.Health), math.round(dist))
        obj.healthBar.Size = UDim2.new(math.max(hpPercent, 0), -10, 0, 4)
        obj.healthBar.BackgroundColor3 = hpPercent > 0.5 and Color3.fromRGB(0, 255, 0) or 
                                         (hpPercent > 0.25 and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(255, 0, 0))
        ::continue::
    end

    for userId, obj in pairs(displayObjects) do
        if not Players:GetPlayerByUserId(userId) then
            if obj.label then obj.label:Destroy() end
            displayObjects[userId] = nil
        end
    end
end

-- ========== 飞行核心 ==========
local bodyVelocity = nil
local function updateFly()
    if not flyEnabled then
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        return
    end
    
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end
    
    if not bodyVelocity then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bodyVelocity.Parent = hrp
    end
    
    local moveDir = Vector3.new(0, 0, 0)
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        moveDir = moveDir + hrp.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        moveDir = moveDir - hrp.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        moveDir = moveDir - hrp.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        moveDir = moveDir + hrp.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        moveDir = Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        moveDir = Vector3.new(0, -1, 0)
    end
    
    if moveDir.Magnitude > 0 then
        bodyVelocity.Velocity = moveDir.Unit * flySpeed
    else
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
    
    hum.PlatformStand = true
end

-- ========== 无限跳跃 ==========
local function onJump()
    if infiniteJump then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                hum.Jump = true
            end
        end
    end
end

-- ========== 自瞄 ==========
local function updateAimbot()
    if not aimbotEnabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local target = nil
    local closest = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local ph = player.Character:FindFirstChild("HumanoidRootPart")
            if ph then
                local dist = (ph.Position - hrp.Position).Magnitude
                if dist < closest then
                    closest = dist
                    target = ph
                end
            end
        end
    end
    
    if target then
        local lookAt = target.Position
        local cam = workspace.CurrentCamera
        cam.CFrame = CFrame.new(cam.CFrame.Position, lookAt)
    end
end

-- ========== 上帝模式 ==========
local function updateGodMode()
    if godMode then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.MaxHealth = math.huge
                hum.Health = math.huge
            end
        end
    end
end

-- ========== 快捷键 ==========
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        mainFrame.Visible = not mainFrame.Visible
    end
    if input.KeyCode == Enum.KeyCode.F then
        flyEnabled = not flyEnabled
        print(flyEnabled and "✈️ 飞行开启" or "✈️ 飞行关闭")
    end
    if input.KeyCode == Enum.KeyCode.G then
        espEnabled = not espEnabled
        print(espEnabled and "👁️ 透视开启" or "👁️ 透视关闭")
    end
end)

-- ========== 循环更新 ==========
RunService.Heartbeat:Connect(function()
    updateFly()
    updateGodMode()
end)

RunService.RenderStepped:Connect(function()
    updateESP()
    updateAimbot()
end)

-- ========== 无限跳跃监听 ==========
UserInputService.JumpRequest:Connect(onJump)

-- ========== 角色重生 ==========
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if speedEnabled then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = 16 * speedMultiplier
                hum.JumpPower = 50 * speedMultiplier
            end
        end
    end
end)

-- ========== 启动 ==========
updateContent("信息")
mainFrame.Visible = true

print("========================================")
print("  ✅ 皮脚本 加载成功！")
print("  无卡密验证")
print("  F1 = 开关菜单")
print("  F = 飞行  G = 透视")
print("========================================")