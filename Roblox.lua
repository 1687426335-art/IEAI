-- ========== wdfex人物加速 ==========
-- 纯人物加速，非全局变速
-- 按 G 开关，按 1-5 调倍率

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local speedEnabled = false
local speedMultiplier = 1.5
local originalSpeed = 16
local originalJump = 50

-- ========== 创建悬浮窗 ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = CoreGui
screenGui.Name = "wdfexSpeed"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 200, 0, 200)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local mainCorner = Instance.new("UICorner")
mainCorner.Parent = mainFrame
mainCorner.CornerRadius = UDim.new(0, 14)

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Parent = mainFrame
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
titleBar.BackgroundTransparency = 0.2
titleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner")
titleCorner.Parent = titleBar
titleCorner.CornerRadius = UDim.new(0, 14)

local titleText = Instance.new("TextLabel")
titleText.Parent = titleBar
titleText.Size = UDim2.new(1, -70, 1, 0)
titleText.Position = UDim2.new(0, 35, 0, 0)
titleText.Text = "⚡ 人物加速"
titleText.TextColor3 = Color3.fromRGB(0, 200, 255)
titleText.BackgroundTransparency = 1
titleText.TextSize = 16
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left

-- 关闭
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

-- ========== 加速开关按钮 ==========
local toggleBtn = Instance.new("TextButton")
toggleBtn.Parent = mainFrame
toggleBtn.Size = UDim2.new(0, 160, 0, 45)
toggleBtn.Position = UDim2.new(0.5, -80, 0, 50)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
toggleBtn.Text = "⚡ 加速: 关"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 18
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.BorderSizePixel = 0

local btnCorner = Instance.new("UICorner")
btnCorner.Parent = toggleBtn
btnCorner.CornerRadius = UDim.new(0, 10)

-- ========== 倍率显示 ==========
local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = mainFrame
speedLabel.Size = UDim2.new(1, 0, 0, 30)
speedLabel.Position = UDim2.new(0, 0, 0, 110)
speedLabel.Text = "倍率: 1.5x (按1-5调整)"
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
speedLabel.BackgroundTransparency = 1
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.Gotham

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
        print("✅ 加速开启 (" .. speedMultiplier .. "倍)")else
        hum.WalkSpeed = 16
        hum.JumpPower = 50
        toggleBtn.Text = "⚡ 加速: 关"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        print("❌ 加速关闭")
    end
end

local function setSpeed(mult)
    speedMultiplier = mult
    speedLabel.Text = "倍率: " .. mult .. "x (按1-5调整)"
    if speedEnabled then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = 16 * speedMultiplier
                hum.JumpPower = 50 * speedMultiplier
            end
        end
        print("⚡ 倍率调整为: " .. mult .. "x")
    else
        print("📌 已设为 " .. mult .. "x (开启后生效)")
    end
end

-- ========== 按钮事件 ==========
toggleBtn.MouseButton1Click:Connect(toggleSpeed)

-- ========== 快捷键 ==========
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    local key = input.KeyCode
    
    if key == Enum.KeyCode.G then
        toggleSpeed()
    end
    
    local speedMap = {
        [Enum.KeyCode.One] = 1,
        [Enum.KeyCode.Two] = 1.5,
        [Enum.KeyCode.Three] = 2,
        [Enum.KeyCode.Four] = 2.5,
        [Enum.KeyCode.Five] = 3,
    }
    if speedMap[key] then
        setSpeed(speedMap[key])
    end
end)

-- ========== 角色重生 ==========
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    applySpeed()
end)

-- ========== 状态标签 ==========
local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = mainFrame
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 0, 0, 145)
statusLabel.Text = "🟢 运行中 | G键开关"
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextSize = 13
statusLabel.Font = Enum.Font.Gotham

local versionLabel = Instance.new("TextLabel")
versionLabel.Parent = mainFrame
versionLabel.Size = UDim2.new(1, 0, 0, 25)
versionLabel.Position = UDim2.new(0, 0, 0, 170)
versionLabel.Text = "wdfex加速 v1.0"
versionLabel.TextColor3 = Color3.fromRGB(100, 100, 140)
versionLabel.BackgroundTransparency = 1
versionLabel.TextSize = 12
versionLabel.Font = Enum.Font.Gotham

print("========================================")
print("  ✅ wdfex人物加速 加载成功！")
print("  G = 开关加速")
print("  1 = 1x  2 = 1.5x  3 = 2x")
print("  4 = 2.5x  5 = 3x")
print("========================================")