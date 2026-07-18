-- ========== wdfex3.1 ==========
-- 卡密: 1 | 按G开关加速 | 带公告

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local speedEnabled = false
local speedMultiplier = 2
local isVerified = false
local minimized = false
local isDragging = false
local dragStart = nil
local dragStartPos = nil

-- ========== 卡密验证 ==========
local function verifyKey(input)
    return input == "1" or input == "wdfexnb"
end

-- ========== 创建GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = CoreGui
screenGui.Name = "wdfex31"
screenGui.ResetOnSpawn = false

-- ========== 公告弹窗 ==========
local function showAnnouncement()
    local 公告框 = Instance.new("Frame")
    公告框.Parent = screenGui
    公告框.Size = UDim2.new(0, 340, 0, 160)
    公告框.Position = UDim2.new(0.5, -170, 0, 20)
    公告框.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    公告框.BackgroundTransparency = 0.1
    公告框.BorderSizePixel = 0
    公告框.ZIndex = 999
    公告框.ClipsDescendants = true

    local 公告框Corner = Instance.new("UICorner")
    公告框Corner.Parent = 公告框
    公告框Corner.CornerRadius = UDim.new(0, 14)

    local 公告框Border = Instance.new("UIStroke")
    公告框Border.Parent = 公告框
    公告框Border.Thickness = 2
    公告框Border.Color = Color3.fromRGB(0, 200, 255)
    公告框Border.Transparency = 0.4

    local 标题 = Instance.new("TextLabel")
    标题.Parent = 公告框
    标题.Size = UDim2.new(1, -40, 0, 35)
    标题.Position = UDim2.new(0, 20, 0, 5)
    标题.Text = "📢 wdfex3.1 公告"
    标题.TextColor3 = Color3.fromRGB(255, 255, 255)
    标题.BackgroundTransparency = 1
    标题.TextSize = 18
    标题.Font = Enum.Font.GothamBold
    标题.TextXAlignment = Enum.TextXAlignment.Left

    local 关闭 = Instance.new("TextButton")
    关闭.Parent = 公告框
    关闭.Size = UDim2.new(0, 30, 0, 30)
    关闭.Position = UDim2.new(1, -35, 0, 5)
    关闭.Text = "✕"
    关闭.TextColor3 = Color3.fromRGB(255, 255, 255)
    关闭.BackgroundTransparency = 1
    关闭.TextSize = 18
    关闭.Font = Enum.Font.GothamBold
    关闭.MouseButton1Click:Connect(function()
        公告框:Destroy()
    end)

    local 内容 = Instance.new("TextLabel")
    内容.Parent = 公告框
    内容.Size = UDim2.new(1, -20, 0, 100)
    内容.Position = UDim2.new(0, 10, 0, 45)
    内容.Text = "✅ 版本: wdfex3.1\n🔑 卡密: 1\n⚡ 功能: 人物加速 (1-15x)\n📌 按 G 键 开关加速\n📌 按 M 键 最小化悬浮窗\n⚠️ 请用小号测试，风险自负"
    内容.TextColor3 = Color3.fromRGB(220, 220, 240)
    内容.BackgroundTransparency = 1
    内容.TextSize = 14
    内容.Font = Enum.Font.Gotham
    内容.TextXAlignment = Enum.TextXAlignment.Left
    内容.TextYAlignment = Enum.TextYAlignment.Top

    task.delay(5, function()
        pcall(function()
            公告框:Destroy()
        end)
    end)
end

-- ========== 验证窗口 ==========
local verifyFrame = Instance.new("Frame")
verifyFrame.Parent = screenGui
verifyFrame.Size = UDim2.new(0, 300, 0, 200)
verifyFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
verifyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
verifyFrame.BackgroundTransparency = 0.1
verifyFrame.BorderSizePixel = 0
verifyFrame.Active = true
verifyFrame.Draggable = true

local verifyCorner = Instance.new("UICorner")
verifyCorner.Parent = verifyFrame
verifyCorner.CornerRadius = UDim.new(0, 16)

local verifyTitle = Instance.new("TextLabel")
verifyTitle.Parent = verifyFrame
verifyTitle.Size = UDim2.new(1, 0, 0, 50)
verifyTitle.Position = UDim2.new(0, 0, 0, 10)
verifyTitle.Text = "🔐 wdfex3.1"
verifyTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
verifyTitle.BackgroundTransparency = 1
verifyTitle.TextSize = 24
verifyTitle.Font = Enum.Font.GothamBold

local keyInput = Instance.new("TextBox")
keyInput.Parent = verifyFrame
keyInput.Size = UDim2.new(0, 220, 0, 45)
keyInput.Position = UDim2.new(0.5, -110, 0, 70)
keyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
keyInput.Text = ""
keyInput.PlaceholderText = "卡密: 1"
keyInput.TextSize = 18
keyInput.Font = Enum.Font.Gotham
keyInput.BorderSizePixel = 0

local inputCorner = Instance.new("UICorner")
inputCorner.Parent = keyInput
inputCorner.CornerRadius = UDim.new(0, 8)

local verifyBtn = Instance.new("TextButton")
verifyBtn.Parent = verifyFrame
verifyBtn.Size = UDim2.new(0, 220, 0, 45)
verifyBtn.Position = UDim2.new(0.5, -110, 0, 130)
verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
verifyBtn.Text = "✅ 验证卡密"
verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
verifyBtn.TextSize = 18
verifyBtn.Font = Enum.Font.GothamBold
verifyBtn.BorderSizePixel = 0

local verifyBtnCorner = Instance.new("UICorner")
verifyBtnCorner.Parent = verifyBtn
verifyBtnCorner.CornerRadius = UDim.new(0, 8)

local resultLabel = Instance.new("TextLabel")
resultLabel.Parent = verifyFrame
resultLabel.Size = UDim2.new(1, 0, 0, 25)
resultLabel.Position = UDim2.new(0, 0, 0, 185)
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

-- ========== 主界面 ==========
local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 220, 0, 200)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false

local mainCorner = Instance.new("UICorner")
mainCorner.Parent = mainFrame
mainCorner.CornerRadius = UDim.new(0, 16)

-- ========== 标题栏 ==========
local titleBar = Instance.new("Frame")
titleBar.Parent = mainFrame
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
titleBar.BackgroundTransparency = 0.15
titleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner")
titleCorner.Parent = titleBar
titleCorner.CornerRadius = UDim.new(0, 16)

local mainTitle = Instance.new("TextLabel")
mainTitle.Parent = titleBar
mainTitle.Size = UDim2.new(1, -70, 1, 0)
mainTitle.Position = UDim2.new(0, 15, 0, 0)
mainTitle.Text = "⚡ wdfex3.1"
mainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
mainTitle.BackgroundTransparency = 1
mainTitle.TextSize = 17
mainTitle.Font = Enum.Font.GothamBold
mainTitle.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = titleBar
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
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
minBtn.Size = UDim2.new(0, 30, 1, 0)
minBtn.Position = UDim2.new(1, -60, 0, 0)
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

-- ========== 内容 ==========
local speedBtn = Instance.new("TextButton")
speedBtn.Parent = mainFrame
speedBtn.Size = UDim2.new(0, 180, 0, 45)
speedBtn.Position = UDim2.new(0.5, -90, 0, 50)
speedBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
speedBtn.Text = "⚡ 加速: 关"
speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBtn.TextSize = 18
speedBtn.Font = Enum.Font.GothamBold
speedBtn.BorderSizePixel = 0

local sCorner = Instance.new("UICorner")
sCorner.Parent = speedBtn
sCorner.CornerRadius = UDim.new(0, 10)

local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = mainFrame
speedLabel.Size = UDim2.new(1, 0, 0, 25)
speedLabel.Position = UDim2.new(0, 0, 0, 108)
speedLabel.Text = "倍率: 2x (点击1-15调整)"
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
speedLabel.BackgroundTransparency = 1
speedLabel.TextSize = 13
speedLabel.Font = Enum.Font.Gotham

-- 倍率按钮 1-15
local btnY = 135
local btnW = 28
local gap = 3
local cols = 5
local totalW = btnW * cols + gap * (cols - 1)
local startX = (220 - totalW) / 2

local speedMap = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}
local btnList = {}

for i, val in ipairs(speedMap) do
    local row = math.floor((i - 1) / cols)
    local col = (i - 1) % cols
    local x = startX + col * (btnW + gap)
    local y = btnY + row * (btnW + gap + 3)
    
    local btn = Instance.new("TextButton")
    btn.Parent = mainFrame
    btn.Size = UDim2.new(0, btnW, 0, btnW)
    btn.Position = UDim2.new(0, x, 0, y)
    btn.BackgroundColor3 = (val == speedMultiplier) and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 60)
    btn.Text = tostring(val)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.Parent = btn
    corner.CornerRadius = UDim.new(0, 4)
    
    btn.MouseButton1Click:Connect(function()
        if not isVerified then return end
        speedMultiplier = val
        speedLabel.Text = "倍率: " .. val .. "x"
        for _, b in pairs(btnList) do
            if tonumber(b.Text) == val then
                b.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            else
                b.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
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
        print("⚡ 倍率: " .. val .. "x")
    end)
    
    table.insert(btnList, btn)
end

-- ========== 加速核心 ==========
local function toggleSpeed()
    if not isVerified then
        print("❌ 请先验证卡密!")
        return
    end
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
        hum.WalkSpeed = 16 * speedMultiplier
        hum.JumpPower = 50 * speedMultiplier
        speedBtn.Text = "⚡ 加速: 开"
        speedBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        print("✅ 加速开启 (" .. speedMultiplier .. "x)")
    else
        hum.WalkSpeed = 16
        hum.JumpPower = 50
        speedBtn.Text = "⚡ 加速: 关"
        speedBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        print("❌ 加速关闭")
    end
end

speedBtn.MouseButton1Click:Connect(toggleSpeed)

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
    else
        resultLabel.Text = "❌ 卡密错误"
        resultLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        print("❌ 卡密错误")
    end
end)

-- ========== 快捷键 ==========
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.G then
        toggleSpeed()
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

-- ========== 角色重生 ==========
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if speedEnabled and isVerified then
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

print("========================================")
print("  ✅ wdfex3.1 加载成功")
print("  卡密: 1")
print("  G键开关加速 | M键最小化")
print("  点击数字1-15调倍率")
print("========================================")