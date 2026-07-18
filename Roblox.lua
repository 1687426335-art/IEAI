-- ========== wdfex人物加速 全服务器通用 ==========
-- 手机/平板通用 | 所有游戏都能用
-- 点按钮开关 | 点数字调倍率

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local speedEnabled = false
local speedMultiplier = 1.5

-- ========== 创建悬浮窗 ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = CoreGui
screenGui.Name = "wdfexSpeed"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 240, 0, 300)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

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
titleText.Text = "⚡ 人物加速"
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

-- ========== 加速开关按钮 ==========
local toggleBtn = Instance.new("TextButton")
toggleBtn.Parent = mainFrame
toggleBtn.Size = UDim2.new(0, 200, 0, 55)
toggleBtn.Position = UDim2.new(0.5, -100, 0, 55)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
toggleBtn.Text = "⚡ 加速: 关"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 20
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.BorderSizePixel = 0

local btnCorner = Instance.new("UICorner")
btnCorner.Parent = toggleBtn
btnCorner.CornerRadius = UDim.new(0, 12)

-- ========== 倍率按钮行 ==========
local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = mainFrame
speedLabel.Size = UDim2.new(1, 0, 0, 30)
speedLabel.Position = UDim2.new(0, 0, 0, 125)
speedLabel.Text = "倍率: 1.5x"
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
speedLabel.BackgroundTransparency = 1
speedLabel.TextSize = 16
speedLabel.Font = Enum.Font.Gotham

-- 倍率按钮 1-5
local btnY = 160
local btnW = 36
local gap = 8
local totalW = btnW * 5 + gap * 4
local startX = (240 - totalW) / 2

local speedMap = {1, 1.5, 2, 2.5, 3}

for i, val in ipairs(speedMap) do
    local btn = Instance.new("TextButton")
    btn.Parent = mainFrame
    btn.Size = UDim2.new(0, btnW, 0, 36)
    btn.Position = UDim2.new(0, startX + (i-1) * (btnW + gap), 0, btnY)
    btn.BackgroundColor3 = (val == speedMultiplier) and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 60)
    btn.Text = tostring(val)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    
    local btnCorner2 = Instance.new("UICorner")
    btnCorner2.Parent = btn
    btnCorner2.CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        speedMultiplier = val
        speedLabel.Text = "倍率: " .. val .. "x"
        for _, child in pairs(mainFrame:GetChildren()) do
            if child:IsA("TextButton") and child.Size == UDim2.new(0, btnW, 0, 36) then
                local num = tonumber(child.Text)
                if num == val then
                    child.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                else
                    child.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                end
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
        originalSpeed = hum.WalkSpeed
        originalJump = hum.JumpPower
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

-- ========== 状态 ==========
local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = mainFrame
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 0, 0, 210)
statusLabel.Text = "🟢 运行中 | 点按钮开关"
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham

local versionLabel = Instance.new("TextLabel")
versionLabel.Parent = mainFrame
versionLabel.Size = UDim2.new(1, 0, 0, 25)
versionLabel.Position = UDim2.new(0, 0, 0, 240)
versionLabel.Text = "wdfex加速 | 全服务器通用"
versionLabel.TextColor3 = Color3.fromRGB(100, 100, 140)
versionLabel.BackgroundTransparency = 1
versionLabel.TextSize = 13
versionLabel.Font = Enum.Font.Gotham

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
    applySpeed()
end)

print("========================================")
print("  ✅ wdfex人物加速 全服通用")
print("  点击按钮开关 | 点击数字调倍率")
print("  手机/平板通用 | 所有游戏可用")
print("========================================")