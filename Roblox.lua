-- ========== wdfex加速2.0 完整透视版 ==========
-- 卡密: 1
-- 分类悬浮窗 | 加速 | 透视(名字/血量/距离/骨骼) | 公告

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local speedEnabled = false
local speedMultiplier = 1
local isVerified = false
local minimized = false
local isDragging = false
local dragStart = nil
local dragStartPos = nil
local espEnabled = false
local displayObjects = {}

-- ========== 公告内容 ==========
local announcement = "🎉 wdfex加速2.0 已加载！\n卡密: 1 | 按G开关加速"

-- ========== 卡密验证 ==========
local function verifyKey(inputKey)
    local validKeys = {
        ["1"] = true,
        ["wdfexnb"] = true,
        ["WDFEXNB"] = true,
    }
    return validKeys[inputKey] or false
end

-- ========== 创建GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = CoreGui
screenGui.Name = "wdfexSpeed"
screenGui.ResetOnSpawn = false

-- ========== 公告显示 ==========
local function showAnnouncement()
    local公告框 = Instance.new("Frame")
    公告框.Parent = screenGui
    公告框.Size = UDim2.new(0, 350, 0, 80)
    公告框.Position = UDim2.new(0.5, -175, 0, 10)
    公告框.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    公告框.BackgroundTransparency = 0.15
    公告框.BorderSizePixel = 0
    公告框.ZIndex = 999

    local 公告框Corner = Instance.new("UICorner")
    公告框Corner.Parent = 公告框
    公告框Corner.CornerRadius = UDim.new(0, 12)

    local 公告框Border = Instance.new("UIStroke")
    公告框Border.Parent = 公告框
    公告框Border.Thickness = 2
    公告框Border.Color = Color3.fromRGB(0, 200, 255)
    公告框Border.Transparency = 0.3

    local 公告文字 = Instance.new("TextLabel")
    公告文字.Parent = 公告框
    公告文字.Size = UDim2.new(1, 0, 1, 0)
    公告文字.Text = announcement
    公告文字.TextColor3 = Color3.fromRGB(255, 255, 255)
    公告文字.BackgroundTransparency = 1
    公告文字.TextSize = 18
    公告文字.Font = Enum.Font.GothamBold
    公告文字.TextScaled = true

    local 关闭公告 = Instance.new("TextButton")
    关闭公告.Parent = 公告框
    关闭公告.Size = UDim2.new(0, 30, 1, 0)
    关闭公告.Position = UDim2.new(1, -30, 0, 0)
    关闭公告.Text = "✕"
    关闭公告.TextColor3 = Color3.fromRGB(255, 255, 255)
    关闭公告.BackgroundTransparency = 1
    关闭公告.TextSize = 16
    关闭公告.Font = Enum.Font.GothamBold
    关闭公告.MouseButton1Click:Connect(function()
        公告框:Destroy()
    end)

    -- 5秒后自动消失
    task.delay(5, function()
        pcall(function()
            公告框:Destroy()
        end)
    end)
end

-- ========== 透视核心 ==========
local function worldToScreen(pos)
    local sp, onScreen = Camera:WorldToScreenPoint(pos)
    return Vector2.new(sp.X, sp.Y), onScreen
end

local function createESP(player)
    local container = Instance.new("Frame")
    container.Parent = screenGui
    container.Size = UDim2.new(0, 200, 0, 120)
    container.BackgroundTransparency = 1
    container.Visible = true
    container.ZIndex = 10

    -- 骨骼线
    local boneLines = {}
    for i = 1, 4 do
        local line = Instance.new("Frame")
        line.Parent = container
        line.Size = UDim2.new(0, 2, 0, 20)
        line.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
        line.BackgroundTransparency = 0.3
        line.BorderSizePixel = 0
        line.Visible = false
        table.insert(boneLines, line)
    end

    -- 方框
    local box = Instance.new("Frame")
    box.Parent = container
    box.Size = UDim2.new(0, 60, 0, 80)
    box.Position = UDim2.new(0, -30, 0, -40)
    box.BackgroundTransparency = 0.6
    box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    box.BorderSizePixel = 2
    box.BorderColor3 = Color3.fromRGB(0, 200, 255)

    -- 血条背景
    local healthBg = Instance.new("Frame")
    healthBg.Parent = container
    healthBg.Size = UDim2.new(0, 62, 0, 4)
    healthBg.Position = UDim2.new(0, -31, 0, 42)
    healthBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    healthBg.BorderSizePixel = 0

    -- 血条
    local healthBar = Instance.new("Frame")
    healthBar.Parent = container
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.Position = UDim2.new(0, 0, 0, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthBar.BorderSizePixel = 0

    -- 名字
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = container
    nameLabel.Size = UDim2.new(0, 120, 0, 18)
    nameLabel.Position = UDim2.new(0, -60, 0, -58)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = ""
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 13
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0.3

    -- 血量数字
    local healthText = Instance.new("TextLabel")
    healthText.Parent = container
    healthText.Size = UDim2.new(0, 80, 0, 16)
    healthText.Position = UDim2.new(0, -40, 0, 48)
    healthText.BackgroundTransparency = 1
    healthText.Text = ""
    healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
    healthText.TextSize = 11
    healthText.Font = Enum.Font.Gotham

    -- 距离
    local distLabel = Instance.new("TextLabel")
    distLabel.Parent = container
    distLabel.Size = UDim2.new(0, 60, 0, 16)
    distLabel.Position = UDim2.new(0, -30, 0, 66)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = ""
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLabel.TextSize = 10
    distLabel.Font = Enum.Font.Gotham

    return {
        container = container,
        box = box,
        healthBg = healthBg,
        healthBar = healthBar,
        name = nameLabel,
        healthText = healthText,
        dist = distLabel,
        boneLines = boneLines
    }
end

local function updateESP()
    if not espEnabled then
        for _, obj in pairs(displayObjects) do
            if obj.container then obj.container.Visible = false end
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
            displayObjects[player.UserId] = createESP(player)
        end

        local obj = displayObjects[player.UserId]
        local headPos = hrp.Position + Vector3.new(0, 2.5, 0)
        local footPos = hrp.Position - Vector3.new(0, 2, 0)
        local screenHead, onScreen = worldToScreen(headPos)
        local screenFoot, _ = worldToScreen(footPos)

        if not onScreen then
            obj.container.Visible = false
            goto continue
        end

        local height = math.abs(screenFoot.Y - screenHead.Y)
        if height < 20 then height = 60 end

        obj.container.Position = UDim2.new(0, screenHead.X, 0, screenHead.Y - height * 0.5)
        obj.container.Size = UDim2.new(0, height * 0.5, 0, height)

        obj.box.Size = UDim2.new(1, 0, 1, 0)
        obj.box.Position = UDim2.new(0, 0, 0, 0)

        local hpPercent = math.max(hum.Health / hum.MaxHealth, 0)
        obj.healthBar.Size = UDim2.new(hpPercent, 0, 1, 0)
        obj.healthBar.BackgroundColor3 = hpPercent > 0.5 and Color3.fromRGB(0, 255, 0)
            or (hpPercent > 0.25 and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(255, 0, 0))
        obj.healthBg.Size = UDim2.new(1, 0, 0, 4)
        obj.healthBg.Position = UDim2.new(0, 0, 1, 4)

        obj.name.Text = player.Name
        obj.name.Position = UDim2.new(0.5, -60, 0, -22)

        obj.healthText.Text = math.round(hum.Health) .. "/" .. math.round(hum.MaxHealth)
        obj.healthText.Position = UDim2.new(0.5, -40, 1, 2)

        local localPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local dist = localPos and (hrp.Position - localPos.Position).Magnitude or 0
        obj.dist.Text = math.round(dist) .. "m"
        obj.dist.Position = UDim2.new(0.5, -30, 1, 18)

        -- 骨骼绘制 (简单版)
        local bonePositions = {
            headPos + Vector3.new(0, 0.5, 0),
            headPos - Vector3.new(0, 0.8, 0),
            headPos - Vector3.new(0, 1.6, 0),
            headPos - Vector3.new(0, 2.4, 0)
        }
        for i, pos in ipairs(bonePositions) do
            local screenPos, _ = worldToScreen(pos)
            if i <= #obj.boneLines then
                obj.boneLines[i].Visible = true
                obj.boneLines[i].Position = UDim2.new(0, screenPos.X - 1, 0, screenPos.Y - 10)
                obj.boneLines[i].Size = UDim2.new(0, 2, 0, 20)
            end
        end

        obj.container.Visible = true
        ::continue::
    end

    for id, obj in pairs(displayObjects) do
        if not Players:GetPlayerByUserId(id) then
            if obj.container then obj.container:Destroy() end
            displayObjects[id] = nil
        end
    end
end

-- ========== 卡密验证窗口 ==========
local verifyFrame = Instance.new("Frame")
verifyFrame.Parent = screenGui
verifyFrame.Size = UDim2.new(0, 320, 0, 280)
verifyFrame.Position = UDim2.new(0.5, -160, 0.5, -140)
verifyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
verifyFrame.BackgroundTransparency = 0.05
verifyFrame.BorderSizePixel = 0
verifyFrame.Active = true
verifyFrame.Draggable = true

local verifyCorner = Instance.new("UICorner")
verifyCorner.Parent = verifyFrame
verifyCorner.CornerRadius = UDim.new(0, 20)

local verifyBorder = Instance.new("UIStroke")
verifyBorder.Parent = verifyFrame
verifyBorder.Thickness = 1.5
verifyBorder.Color = Color3.fromRGB(0, 200, 255)
verifyBorder.Transparency = 0.3

local verifyTitle = Instance.new("TextLabel")
verifyTitle.Parent = verifyFrame
verifyTitle.Size = UDim2.new(1, 0, 0, 50)
verifyTitle.Position = UDim2.new(0, 0, 0, 15)
verifyTitle.Text = "🔐 wdfex加速2.0"
verifyTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
verifyTitle.BackgroundTransparency = 1
verifyTitle.TextSize = 24
verifyTitle.Font = Enum.Font.GothamBold

local subTitle = Instance.new("TextLabel")
subTitle.Parent = verifyFrame
subTitle.Size = UDim2.new(1, 0, 0, 25)
subTitle.Position = UDim2.new(0, 0, 0, 65)
subTitle.Text = "请输入卡密验证"
subTitle.TextColor3 = Color3.fromRGB(180, 180, 210)
subTitle.BackgroundTransparency = 1
subTitle.TextSize = 15
subTitle.Font = Enum.Font.Gotham

local keyInput = Instance.new("TextBox")
keyInput.Parent = verifyFrame
keyInput.Size = UDim2.new(0, 250, 0, 50)
keyInput.Position = UDim2.new(0.5, -125, 0, 100)
keyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
keyInput.Text = ""
keyInput.PlaceholderText = "请输入卡密"
keyInput.TextSize = 18
keyInput.Font = Enum.Font.Gotham
keyInput.BorderSizePixel = 0

local inputCorner = Instance.new("UICorner")
inputCorner.Parent = keyInput
inputCorner.CornerRadius = UDim.new(0, 10)

local verifyBtn = Instance.new("TextButton")
verifyBtn.Parent = verifyFrame
verifyBtn.Size = UDim2.new(0, 250, 0, 50)
verifyBtn.Position = UDim2.new(0.5, -125, 0, 165)
verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
verifyBtn.Text = "✅ 验证卡密"
verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
verifyBtn.TextSize = 20
verifyBtn.Font = Enum.Font.GothamBold
verifyBtn.BorderSizePixel = 0

local verifyBtnCorner = Instance.new("UICorner")
verifyBtnCorner.Parent = verifyBtn
verifyBtnCorner.CornerRadius = UDim.new(0, 10)

local resultLabel = Instance.new("TextLabel")
resultLabel.Parent = verifyFrame
resultLabel.Size = UDim2.new(1, 0, 0, 25)
resultLabel.Position = UDim2.new(0, 0, 0, 230)
resultLabel.Text = "💡 卡密: 1"
resultLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
resultLabel.BackgroundTransparency = 1
resultLabel.TextSize = 14
resultLabel.Font = Enum.Font.Gotham

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
        local newPos = UDim2.new(
            dragStartPos.X.Scale + delta.X / screenGui.AbsoluteSize.X,
            0,
            dragStartPos.Y.Scale + delta.Y / screenGui.AbsoluteSize.Y,
            0
        )
        miniBall.Position = newPos
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

-- ========== 主悬浮窗 ==========
local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 280, 0, 450)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 35)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.ClipsDescendants = true

local mainCorner = Instance.new("UICorner")
mainCorner.Parent = mainFrame
mainCorner.CornerRadius = UDim.new(0, 20)

local mainBorder = Instance.new("UIStroke")
mainBorder.Parent = mainFrame
mainBorder.Thickness = 1.5
mainBorder.Color = Color3.fromRGB(0, 200, 255)
mainBorder.Transparency = 0.3

-- ========== 标题栏 ==========
local titleBar = Instance.new("Frame")
titleBar.Parent = mainFrame
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
titleBar.BackgroundTransparency = 0.1
titleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner")
titleCorner.Parent = titleBar
titleCorner.CornerRadius = UDim.new(0, 20)

local titleText = Instance.new("TextLabel")
titleText.Parent = titleBar
titleText.Size = UDim2.new(1, -80, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.Text = "⚡ wdfex加速2.0"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.BackgroundTransparency = 1
titleText.TextSize = 18
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = titleBar
closeBtn.Size = UDim2.new(0, 35, 1, 0)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.BackgroundTransparency = 1
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local minBtn = Instance.new("TextButton")
minBtn.Parent = titleBar
minBtn.Size = UDim2.new(0, 35, 1, 0)
minBtn.Position = UDim2.new(1, -70, 0, 0)
minBtn.Text = "─"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.BackgroundTransparency = 1
minBtn.TextSize = 18
minBtn.Font = Enum.Font.GothamBold
minBtn.MouseButton1Click:Connect(function()
    minimized = true
    mainFrame.Visible = false
    miniBall.Visible = true
end)

-- ========== 分类按钮 ==========
local categories = {"🚀 加速", "👁️ 透视", "📢 公告"}
local categoryBtns = {}
local currentCategory = "🚀 加速"

for i, cat in ipairs(categories) do
    local btn = Instance.new("TextButton")
    btn.Parent = mainFrame
    btn.Size = UDim2.new(0, 90, 0, 35)
    btn.Position = UDim2.new(0, 5 + (i-1) * 93, 0, 60)
    btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 60)
    btn.Text = cat
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.Parent = btn
    btnCorner.CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        currentCategory = cat
        for _, b in pairs(categoryBtns) do
            b.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        end
        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        updateContent(cat)
    end)
    
    table.insert(categoryBtns, btn)
end

-- ========== 内容容器 ==========
local contentFrame = Instance.new("Frame")
contentFrame.Parent = mainFrame
contentFrame.Size = UDim2.new(1, -20, 0, 320)
contentFrame.Position = UDim2.new(0, 10, 0, 105)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
contentFrame.BackgroundTransparency = 0.3
contentFrame.BorderSizePixel = 0

local contentCorner = Instance.new("UICorner")
contentCorner.Parent = contentFrame
contentCorner.CornerRadius = UDim.new(0, 10)

-- ========== 内容更新函数 ==========
local function updateContent(category)
    for _, child in pairs(contentFrame:GetChildren()) do
        child:Destroy()
    end
    
    if category == "🚀 加速" then
        -- 加速开关
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Parent = contentFrame
        toggleBtn.Size = UDim2.new(0, 230, 0, 50)
        toggleBtn.Position = UDim2.new(0.5, -115, 0, 15)
        toggleBtn.BackgroundColor3 = speedEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)
        toggleBtn.Text = speedEnabled and "⚡ 加速: 开" or "⚡ 加速: 关"
        toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleBtn.TextSize = 18
        toggleBtn.Font = Enum.Font.GothamBold
        toggleBtn.BorderSizePixel = 0
        toggleBtn.Name = "SpeedToggle"
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.Parent = toggleBtn
        btnCorner.CornerRadius = UDim.new(0, 10)
        
        toggleBtn.MouseButton1Click:Connect(function()
            if not isVerified then return end
            speedEnabled = not speedEnabled
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum then
                    if speedEnabled then
                        hum.WalkSpeed = 16 * speedMultiplier
                        hum.JumpPower = 50 * speedMultiplier
                    else
                        hum.WalkSpeed = 16
                        hum.JumpPower = 50
                    end
                end
            end
            toggleBtn.Text = speedEnabled and "⚡ 加速: 开" or "⚡ 加速: 关"
            toggleBtn.BackgroundColor3 = speedEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)
            print(speedEnabled and "✅ 加速开启" or "❌ 加速关闭")
        end)
        
        -- 倍率标签
        local label = Instance.new("TextLabel")
        label.Parent = contentFrame
        label.Size = UDim2.new(1, 0, 0, 25)
        label.Position = UDim2.new(0, 0, 0, 80)
        label.Text = "倍率: " .. speedMultiplier .. "x"
        label.TextColor3 = Color3.fromRGB(180, 180, 210)
        label.BackgroundTransparency = 1
        label.TextSize = 14
        label.Font = Enum.Font.Gotham
        
        -- 倍率按钮 1-15
        local btnY = 110
        local btnW = 32
        local gap = 4
        local cols = 5
        local totalW = btnW * cols + gap * (cols - 1)
        local startX = (contentFrame.Size.X.Offset - totalW) / 2
        
        for i = 1, 15 do
            local row = math.floor((i - 1) / cols)
            local col = (i - 1) % cols
            local x = startX + col * (btnW + gap)
            local y = btnY + row * (btnW + gap + 4)
            
            local btn = Instance.new("TextButton")
            btn.Parent = contentFrame
            btn.Size = UDim2.new(0, btnW, 0, btnW)
            btn.Position = UDim2.new(0, x, 0, y)
            btn.BackgroundColor3 = (i == speedMultiplier) and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 60)
            btn.Text = tostring(i)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 13
            btn.Font = Enum.Font.GothamBold
            btn.BorderSizePixel = 0
            
            local corner = Instance.new("UICorner")
            corner.Parent = btn
            corner.CornerRadius = UDim.new(0, 5)
            
            btn.MouseButton1Click:Connect(function()
                speedMultiplier = i
                label.Text = "倍率: " .. i .. "x"
                for _, child in pairs(contentFrame:GetChildren()) do
                    if child:IsA("TextButton") and child.Size == UDim2.new(0, btnW, 0, btnW) then
                        child.BackgroundColor3 = (tonumber(child.Text) == i) and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 60)
                    end
                end
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
                print("⚡ 倍率: " .. i .. "x")
            end)
        end
        
    elseif category == "👁️ 透视" then
        -- 透视开关
        local espBtn = Instance.new("TextButton")
        espBtn.Parent = contentFrame
        espBtn.Size = UDim2.new(0, 230, 0, 50)
        espBtn.Position = UDim2.new(0.5, -115, 0, 15)
        espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)
        espBtn.Text = espEnabled and "👁️ 透视: 开" or "👁️ 透视: 关"
        espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        espBtn.TextSize = 18
        espBtn.Font = Enum.Font.GothamBold
        espBtn.BorderSizePixel = 0
        
        local espCorner = Instance.new("UICorner")
        espCorner.Parent = espBtn
        espCorner.CornerRadius = UDim.new(0, 10)
        
        espBtn.MouseButton1Click:Connect(function()
            if not isVerified then return end
            espEnabled = not espEnabled
            espBtn.Text = espEnabled and "👁️ 透视: 开" or "👁️ 透视: 关"
            espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)
            print(espEnabled and "✅ 透视开启" or "❌ 透视关闭")
        end)
        
        -- 透视信息
        local info = Instance.new("TextLabel")
        info.Parent = contentFrame
        info.Size = UDim2.new(1, 0, 0, 80)
        info.Position = UDim2.new(0, 0, 0, 80)
        info.Text = "📋 透视显示内容:\n• 玩家名字\n• 血量 (数字+血条)\n• 距离\n• 骨骼 (简单版)"
        info.TextColor3 = Color3.fromRGB(180, 180, 210)
        info.BackgroundTransparency = 1
        info.TextSize = 14
        info.Font = Enum.Font.Gotham
        info.TextXAlignment = Enum.TextXAlignment.Left
        
    elseif category == "📢 公告" then
        local公告框 = Instance.new("Frame")
        公告框.Parent = contentFrame
        公告框.Size = UDim2.new(1, -10, 0, 250)
        公告框.Position = UDim2.new(0, 5, 0, 10)
        公告框.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        公告框.BackgroundTransparency = 0.3
        公告框.BorderSizePixel = 0
        
        local 公告框Corner = Instance.new("UICorner")
        公告框Corner.Parent = 公告框
        公告框Corner.CornerRadius = UDim.new(0, 10)
        
        local 公告文字 = Instance.new("TextLabel")
        公告文字.Parent = 公告框
        公告文字.Size = UDim2.new(1, -20, 1, -20)
        公告文字.Position = UDim2.new(0, 10, 0, 10)
        公告文字.Text = "📢 wdfex加速2.0 公告\n\n✅ 版本: 2.0\n🔑 卡密: 1\n⚡ 功能: 人物加速 (1-15x)\n👁️ 透视: 名字/血量/距离/骨骼\n📌 按 G 键开关加速\n📌 按 M 键最小化\n\n⚠️ 请用小号测试，风险自负"
        公告文字.TextColor3 = Color3.fromRGB(200, 200, 230)
        公告文字.BackgroundTransparency = 1
        公告文字.TextSize = 14
        公告文字.Font = Enum.Font.Gotham
        公告文字.TextXAlignment = Enum.TextXAlignment.Left
        公告文字.TextYAlignment = Enum.TextYAlignment.Top
    end
end

-- ========== 加速核心 ==========
local function applySpeed()
    if not isVerified then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    if speedEnabled then
        hum.WalkSpeed = 16 * speedMultiplier
        hum.JumpPower = 50 * speedMultiplier
    end
end

-- ========== 快捷键 ==========
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.G then
        if not isVerified then return end
        speedEnabled = not speedEnabled
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                if speedEnabled then
                    hum.WalkSpeed = 16 * speedMultiplier
                    hum.JumpPower = 50 * speedMultiplier
                else
                    hum.WalkSpeed = 16
                    hum.JumpPower = 50
                end
            end
        end
        print(speedEnabled and "✅ 加速开启" or "❌ 加速关闭")
        updateContent(currentCategory)
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

-- ========== 验证 ==========
verifyBtn.MouseButton1Click:Connect(function()
    local input = keyInput.Text
    if verifyKey(input) then
        isVerified = true
        verifyFrame.Visible = false
        mainFrame.Visible = true
        resultLabel.Text = "✅ 验证成功!"
        resultLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        print("✅ 卡密验证成功!")
        showAnnouncement()
        updateContent("🚀 加速")
    else
        resultLabel.Text = "❌ 卡密错误"
        resultLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        print("❌ 卡密错误")
    end
end)

-- ========== 角色重生 ==========
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if speedEnabled and isVerified then
        applySpeed()
    end
end)

-- ========== 启动透视 ==========
RunService.RenderStepped:Connect(updateESP)

print("========================================")
print("  ✅ wdfex加速2.0 完整版加载成功")
print("  卡密: 1")
print("  分类: 加速 | 透视 | 公告")
print("  G键开关加速 | M键最小化")
print("========================================")