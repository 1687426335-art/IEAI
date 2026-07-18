-- ========== wdfex超级加速 卡密验证版 ==========
-- 卡密: wdfexnb
-- 倍率1-15 | 自动恢复 | 永不中断

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local speedEnabled = false
local speedMultiplier = 2
local isVerified = false

-- ========== 卡密验证 ==========
local function verifyKey(inputKey)
    local validKeys = {
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

-- ========== 验证窗口 ==========
local verifyFrame = Instance.new("Frame")
verifyFrame.Parent = screenGui
verifyFrame.Size = UDim2.new(0, 300, 0, 220)
verifyFrame.Position = UDim2.new(0.5, -150, 0.5, -110)
verifyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
verifyFrame.BackgroundTransparency = 0.1
verifyFrame.BorderSizePixel = 0
verifyFrame.Active = true
verifyFrame.Draggable = true

local verifyCorner = Instance.new("UICorner")
verifyCorner.Parent = verifyFrame
verifyCorner.CornerRadius = UDim.new(0, 16)

-- 标题
local verifyTitle = Instance.new("TextLabel")
verifyTitle.Parent = verifyFrame
verifyTitle.Size = UDim2.new(1, 0, 0, 50)
verifyTitle.Position = UDim2.new(0, 0, 0, 10)
verifyTitle.Text = "🔐 卡密验证"
verifyTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
verifyTitle.BackgroundTransparency = 1
verifyTitle.TextSize = 24
verifyTitle.Font = Enum.Font.GothamBold

-- 卡密输入框
local keyInput = Instance.new("TextBox")
keyInput.Parent = verifyFrame
keyInput.Size = UDim2.new(0, 220, 0, 45)
keyInput.Position = UDim2.new(0.5, -110, 0, 75)
keyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
keyInput.Text = ""
keyInput.PlaceholderText = "请输入卡密"
keyInput.TextSize = 18
keyInput.Font = Enum.Font.Gotham
keyInput.BorderSizePixel = 0

local inputCorner = Instance.new("UICorner")
inputCorner.Parent = keyInput
inputCorner.CornerRadius = UDim.new(0, 8)

-- 验证按钮
local verifyBtn = Instance.new("TextButton")
verifyBtn.Parent = verifyFrame
verifyBtn.Size = UDim2.new(0, 220, 0, 45)
verifyBtn.Position = UDim2.new(0.5, -110, 0, 135)
verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
verifyBtn.Text = "✅ 验证卡密"
verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
verifyBtn.TextSize = 18
verifyBtn.Font = Enum.Font.GothamBold
verifyBtn.BorderSizePixel = 0

local verifyBtnCorner = Instance.new("UICorner")
verifyBtnCorner.Parent = verifyBtn
verifyBtnCorner.CornerRadius = UDim.new(0, 8)

-- 验证结果标签
local resultLabel = Instance.new("TextLabel")
resultLabel.Parent = verifyFrame
resultLabel.Size = UDim2.new(1, 0, 0, 25)
resultLabel.Position = UDim2.new(0, 0, 0, 190)
resultLabel.Text = ""
resultLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
resultLabel.BackgroundTransparency = 1
resultLabel.TextSize = 14
resultLabel.Font = Enum.Font.Gotham

-- ========== 主悬浮窗 ==========
local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 260, 0, 380)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false

local mainCorner = Instance.new("UICorner")
mainCorner.Parent = mainFrame
mainCorner.CornerRadius = UDim.new(0, 16)

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Parent = mainFrame
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
titleBar.BackgroundTransparency = 0.2
titleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner")
titleCorner.Parent = titleBar
titleCorner.CornerRadius = UDim.new(0, 16)

local titleText = Instance.new("TextLabel")
titleText.Parent = titleBar
titleText.Size = UDim2.new(1, -75, 1, 0)
titleText.Position = UDim2.new(0, 40, 0, 0)
titleText.Text = "⚡ 超级加速"
titleText.TextColor3 = Color3.fromRGB(0, 200, 255)
titleText.BackgroundTransparency = 1
titleText.TextSize = 18
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left

-- 关闭
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = titleBar
closeBtn.Size = UDim2.new(0, 40, 1, 0)
closeBtn.Position = UDim2.new(1, -40, 0, 0)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.BackgroundTransparency = 1
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ========== 加速开关 ==========
local toggleBtn = Instance.new("TextButton")
toggleBtn.Parent = mainFrame
toggleBtn.Size = UDim2.new(0, 220, 0, 50)
toggleBtn.Position = UDim2.new(0.5, -110, 0, 55)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
toggleBtn.Text = "⚡ 加速: 关"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 20
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.BorderSizePixel = 0

local btnCorner = Instance.new("UICorner")
btnCorner.Parent = toggleBtn
btnCorner.CornerRadius = UDim.new(0, 12)

-- ========== 倍率显示 ==========
local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = mainFrame
speedLabel.Size = UDim2.new(1, 0, 0, 25)
speedLabel.Position = UDim2.new(0, 0, 0, 118)
speedLabel.Text = "倍率: 2x (点击数字调整)"
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
speedLabel.BackgroundTransparency = 1
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.Gotham

-- ========== 倍率按钮 1-15 ==========
local btnY = 150
local btnW = 34
local gap = 4
local cols = 5
local totalW = btnW * cols + gap * (cols - 1)
local startX = (260 - totalW) / 2

local speedMap = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}
local btnList = {}

for i, val in ipairs(speedMap) do
    local row = math.floor((i - 1) / cols)
    local col = (i - 1) % cols
    local x = startX + col * (btnW + gap)
    local y = btnY + row * (btnW + gap + 4)
    
    local btn = Instance.new("TextButton")
    btn.Parent = mainFrame
    btn.Size = UDim2.new(0, btnW, 0, btnW)
    btn.Position = UDim2.new(0, x, 0, y)
    btn.BackgroundColor3 = (val == speedMultiplier) and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 60)
    btn.Text = tostring(val)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    
    local btnCorner2 = Instance.new("UICorner")
    btnCorner2.Parent = btn
    btnCorner2.CornerRadius = UDim.new(0, 5)
    
    btn.MouseButton1Click:Connect(function()
        if not isVerified then
            print("❌ 请先验证卡密")
            return
        end
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
            applySpeed()
        end
        print("⚡ 倍率: " .. val .. "x")
    end)
    
    table.insert(btnList, btn)
end

-- ========== 状态标签 ==========
local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = mainFrame
statusLabel.Size = UDim2.new(1, 0, 0, 22)
statusLabel.Position = UDim2.new(0, 0, 0, 295)
statusLabel.Text = "🔒 未验证"
statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextSize = 13
statusLabel.Font = Enum.Font.Gotham

local restoreLabel = Instance.new("TextLabel")
restoreLabel.Parent = mainFrame
restoreLabel.Size = UDim2.new(1, 0, 0, 22)
restoreLabel.Position = UDim2.new(0, 0, 0, 318)
restoreLabel.Text = "🔄 自动恢复已开启"
restoreLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
restoreLabel.BackgroundTransparency = 1
restoreLabel.TextSize = 13
restoreLabel.Font = Enum.Font.Gotham

local versionLabel = Instance.new("TextLabel")
versionLabel.Parent = mainFrame
versionLabel.Size = UDim2.new(1, 0, 0, 22)
versionLabel.Position = UDim2.new(0, 0, 0, 342)
versionLabel.Text = "wdfex超级加速 | 卡密验证版"
versionLabel.TextColor3 = Color3.fromRGB(100, 100, 140)
versionLabel.BackgroundTransparency = 1
versionLabel.TextSize = 11
versionLabel.Font = Enum.Font.Gotham

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

-- ========== 自动恢复 ==========
local function autoRestore()
    RunService.Heartbeat:Connect(function()
        if not speedEnabled or not isVerified then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        if not hum then return end
        
        local targetSpeed = 16 * speedMultiplier
        local targetJump = 50 * speedMultiplier
        
        if hum.WalkSpeed < targetSpeed * 0.9 or hum.JumpPower < targetJump * 0.9 then
            hum.WalkSpeed = targetSpeed
            hum.JumpPower = targetJump
            restoreLabel.Text = "🔄 已自动恢复!"
            restoreLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            task.wait(0.5)
            restoreLabel.Text = "🔄 自动恢复已开启"
            restoreLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        end
    end)
end

local function toggleSpeed()
    if not isVerified then
        print("❌ 请先验证卡密!")
        return
    end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    
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

-- ========== 验证按钮事件 ==========
verifyBtn.MouseButton1Click:Connect(function()
    local input = keyInput.Text
    if verifyKey(input) then
        isVerified = true
        verifyFrame.Visible = false
        mainFrame.Visible = true
        statusLabel.Text = "🟢 已验证"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        resultLabel.Text = "✅ 验证成功!"
        resultLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        print("✅ 卡密验证成功!")
    else
        resultLabel.Text = "❌ 卡密错误，请重试"
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
end)

-- ========== 角色重生 ==========
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if speedEnabled and isVerified then
        applySpeed()
    end
end)

-- ========== 启动 ==========
autoRestore()

print("========================================")
print("  ✅ wdfex超级加速 卡密版加载成功")
print("  卡密: wdfexnb")
print("  验证后点击按钮开关 | 点击数字调倍率")
print("========================================")