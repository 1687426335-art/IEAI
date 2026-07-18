-- ========== wdfxe优化版本 ==========
-- 卡密: 1 | 按G开关加速 | 按M最小化

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local speedEnabled = false
local speedMultiplier = 1
local isVerified = false
local minimized = false
local isDragging = false
local dragStart, dragStartPos

local function verifyKey(input)
    return input == "1" or input == "wdfexnb" or input == "WDFEXNB"
end

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = CoreGui
screenGui.Name = "wdfxe"
screenGui.ResetOnSpawn = false

-- ========== 验证窗口 ==========
local verifyFrame = Instance.new("Frame")
verifyFrame.Parent = screenGui
verifyFrame.Size = UDim2.new(0, 300, 0, 210)
verifyFrame.Position = UDim2.new(0.5, -150, 0.5, -105)
verifyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
verifyFrame.BackgroundTransparency = 0.05
verifyFrame.BorderSizePixel = 0
verifyFrame.Active = true
verifyFrame.Draggable = true

local vCorner = Instance.new("UICorner")
vCorner.Parent = verifyFrame
vCorner.CornerRadius = UDim.new(0, 18)

local vStroke = Instance.new("UIStroke")
vStroke.Parent = verifyFrame
vStroke.Thickness = 1.5
vStroke.Color = Color3.fromRGB(0, 200, 255)
vStroke.Transparency = 0.3

local vTitle = Instance.new("TextLabel")
vTitle.Parent = verifyFrame
vTitle.Size = UDim2.new(1, 0, 0, 45)
vTitle.Position = UDim2.new(0, 0, 0, 10)
vTitle.Text = "🔐 wdfxe"
vTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
vTitle.BackgroundTransparency = 1
vTitle.TextSize = 24
vTitle.Font = Enum.Font.GothamBold

local sub = Instance.new("TextLabel")
sub.Parent = verifyFrame
sub.Size = UDim2.new(1, 0, 0, 25)
sub.Position = UDim2.new(0, 0, 0, 58)
sub.Text = "请输入卡密验证"
sub.TextColor3 = Color3.fromRGB(180, 180, 210)
sub.BackgroundTransparency = 1
sub.TextSize = 15
sub.Font = Enum.Font.Gotham

local keyInput = Instance.new("TextBox")
keyInput.Parent = verifyFrame
keyInput.Size = UDim2.new(0, 230, 0, 45)
keyInput.Position = UDim2.new(0.5, -115, 0, 90)
keyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
keyInput.Text = ""
keyInput.PlaceholderText = "卡密: 1"
keyInput.TextSize = 18
keyInput.Font = Enum.Font.Gotham
keyInput.BorderSizePixel = 0

local iCorner = Instance.new("UICorner")
iCorner.Parent = keyInput
iCorner.CornerRadius = UDim.new(0, 10)

local verifyBtn = Instance.new("TextButton")
verifyBtn.Parent = verifyFrame
verifyBtn.Size = UDim2.new(0, 230, 0, 45)
verifyBtn.Position = UDim2.new(0.5, -115, 0, 148)
verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
verifyBtn.Text = "✅ 验证卡密"
verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
verifyBtn.TextSize = 18
verifyBtn.Font = Enum.Font.GothamBold
verifyBtn.BorderSizePixel = 0

local bCorner = Instance.new("UICorner")
bCorner.Parent = verifyBtn
bCorner.CornerRadius = UDim.new(0, 10)

local result = Instance.new("TextLabel")
result.Parent = verifyFrame
result.Size = UDim2.new(1, 0, 0, 25)
result.Position = UDim2.new(0, 0, 0, 200)
result.Text = "💡 卡密: 1"
result.TextColor3 = Color3.fromRGB(255, 200, 0)
result.BackgroundTransparency = 1
result.TextSize = 14
result.Font = Enum.Font.Gotham

-- ========== 主界面 ==========
local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 230, 0, 210)
mainFrame.Position = UDim2.new(0.5, -115, 0.5, -105)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 35)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
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
title.Text = "⚡ wdfxe"
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
    print("❌ wdfxe已关闭")
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
    print("📌 已最小化")
end)

-- 状态
local status = Instance.new("TextLabel")
status.Parent = mainFrame
status.Size = UDim2.new(1, -20, 0, 22)
status.Position = UDim2.new(0, 10, 0, 52)
status.Text = "🔒 未验证"
status.TextColor3 = Color3.fromRGB(255, 200, 0)
status.BackgroundTransparency = 1
status.TextSize = 13
status.Font = Enum.Font.Gotham

-- 加速开关
local toggleBtn = Instance.new("TextButton")
toggleBtn.Parent = mainFrame
toggleBtn.Size = UDim2.new(0, 190, 0, 45)
toggleBtn.Position = UDim2.new(0.5, -95, 0, 82)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
toggleBtn.Text = "⚡ 加速: 关"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 18
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.BorderSizePixel = 0

local tCorner2 = Instance.new("UICorner")
tCorner2.Parent = toggleBtn
tCorner2.CornerRadius = UDim.new(0, 10)

-- 倍率
local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = mainFrame
speedLabel.Size = UDim2.new(1, 0, 0, 22)
speedLabel.Position = UDim2.new(0, 0, 0, 138)
speedLabel.Text = "倍率: 1x"
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
speedLabel.BackgroundTransparency = 1
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.Gotham

-- 倍率按钮 1-15
local btnY, btnW, gap, cols = 165, 28, 3, 5
local totalW = btnW * cols + gap * (cols - 1)
local startX = (230 - totalW) / 2
local btnList = {}

for i = 1, 15 do
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
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    
    local bCorner2 = Instance.new("UICorner")
    bCorner2.Parent = btn
    bCorner2.CornerRadius = UDim.new(0, 4)
    
    btn.MouseButton1Click:Connect(function()
        if not isVerified then return end
        speedMultiplier = i
        speedLabel.Text = "倍率: " .. i .. "x"
        for _, b in pairs(btnList) do
            if tonumber(b.Text) == i then
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
                    hum.WalkSpeed = 16 * i
                    hum.JumpPower = 50 * i
                end
            end
        end
        print("⚡ 倍率: " .. i .. "x")
    end)
    
    table.insert(btnList, btn)
end

-- ========== 底部信息 ==========
local versionLabel = Instance.new("TextLabel")
versionLabel.Parent = mainFrame
versionLabel.Size = UDim2.new(1, 0, 0, 20)
versionLabel.Position = UDim2.new(0, 0, 0, 330)
versionLabel.Text = "wdfxe | 卡密: 1"
versionLabel.TextColor3 = Color3.fromRGB(100, 100, 140)
versionLabel.BackgroundTransparency = 1
versionLabel.TextSize = 11
versionLabel.Font = Enum.Font.Gotham

-- ========== 最小化圆球 ==========
local miniBall = Instance.new("TextButton")
miniBall.Parent = screenGui
miniBall.Size = UDim2.new(0, 52, 0, 52)
miniBall.Position = UDim2.new(1, -72, 0.9, 0)
miniBall.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
miniBall.Text = "⚡"
miniBall.TextColor3 = Color3.fromRGB(255, 255, 255)
miniBall.TextSize = 26
miniBall.Font = Enum.Font.GothamBold
miniBall.BorderSizePixel = 0
miniBall.Visible = false
miniBall.ZIndex = 999

local bCorner3 = Instance.new("UICorner")
bCorner3.Parent = miniBall
bCorner3.CornerRadius = UDim.new(1, 0)

-- 修复：点击圆球恢复时，不退出脚本
miniBall.MouseButton1Click:Connect(function()
    minimized = false
    miniBall.Visible = false
    mainFrame.Visible = true
    print("📌 已恢复窗口")
end)

-- ========== 功能核心 ==========
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
        toggleBtn.Text = "⚡ 加速: 开"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        print("✅ 加速开启 (" .. speedMultiplier .. "x)")
    else
        hum.WalkSpeed = 16
        hum.JumpPower = 50
        toggleBtn.Text = "⚡ 加速: 关"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        print("❌ 加速关闭")
    end
end

toggleBtn.MouseButton1Click:Connect(toggleSpeed)

-- ========== 验证 ==========
verifyBtn.MouseButton1Click:Connect(function()
    local input = keyInput.Text
    if verifyKey(input) then
        isVerified = true
        verifyFrame.Visible = false
        mainFrame.Visible = true
        status.Text = "🟢 已验证"
        status.TextColor3 = Color3.fromRGB(0, 255, 0)
        result.Text = "✅ 验证成功!"
        result.TextColor3 = Color3.fromRGB(0, 255, 0)
        print("✅ 卡密验证成功!")
    else
        result.Text = "❌ 卡密错误"
        result.TextColor3 = Color3.fromRGB(255, 0, 0)
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
            print("📌 已最小化 (按M恢复)")
        else
            minimized = false
            miniBall.Visible = false
            mainFrame.Visible = true
            print("📌 已恢复窗口")
        end
    end
end)

-- ========== 角色重生 ==========
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if speedEnabled and isVerified then
        applySpeed()
    end
end)

print("========================================")
print("  ✅ wdfxe优化版本 加载成功")
print("  卡密: 1")
print("  G键开关加速 | M键最小化/恢复")
print("  点击数字1-15调倍率")
print("  点击圆球恢复窗口")
print("========================================")