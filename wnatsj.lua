-- ========== SANA HUB 风格悬浮窗 ==========
-- 纯UI外壳，可拖拽，带关闭按钮

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SanaUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = Player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 320)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- 发光边框
local glowBorder = Instance.new("Frame")
glowBorder.Size = UDim2.new(1, 10, 1, 10)
glowBorder.Position = UDim2.new(0, -5, 0, -5)
glowBorder.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
glowBorder.BackgroundTransparency = 0.4
glowBorder.BorderSizePixel = 0
glowBorder.ZIndex = 0
glowBorder.Parent = mainFrame

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 16)
glowCorner.Parent = glowBorder

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
titleBar.BackgroundTransparency = 0.2
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "SANA HUB"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleBar

-- 关闭按钮
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -36, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.BackgroundTransparency = 0.2
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0
closeButton.Parent = titleBar

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
    screenGui:Destroy()
end)

-- 分割线
local divider = Instance.new("Frame")
divider.Size = UDim2.new(0.9, 0, 0, 1)
divider.Position = UDim2.new(0.05, 0, 0.14, 0)
divider.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
divider.BackgroundTransparency = 0.5
divider.BorderSizePixel = 0
divider.Parent = mainFrame

-- ===== 内容区域（示例控件） =====
local function MakeLabel(text, y, color)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.92, 0, 0, 30)
    label.Position = UDim2.new(0.04, 0, 0, y)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(220, 220, 220)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = mainFrame
    return label
end

local function MakeButton(text, y, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 35)
    btn.Position = UDim2.new(0.075, 0, 0, y)
    btn.BackgroundColor3 = color or Color3.fromRGB(0, 150, 255)
    btn.BackgroundTransparency = 0.15
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = mainFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    return btn
end

MakeLabel("状态: 已停止", 55, Color3.fromRGB(180, 180, 180))
MakeLabel("传送: 0", 90, Color3.fromRGB(70, 150, 255))
MakeLabel("模式: 出租车", 125, Color3.fromRGB(200, 200, 200))

local startBtn = MakeButton("启动", 170, Color3.fromRGB(180, 50, 50))
local modeBtn = MakeButton("切换模式", 215, Color3.fromRGB(50, 50, 80))

-- 底部小字
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(0.9, 0, 0, 20)
footer.Position = UDim2.new(0.05, 0, 0.91, 0)
footer.BackgroundTransparency = 1
footer.Text = "拖拽移动 | 点击X关闭"
footer.TextColor3 = Color3.fromRGB(100, 100, 150)
footer.TextSize = 11
footer.TextXAlignment = Enum.TextXAlignment.Center
footer.Font = Enum.Font.Gotham
footer.Parent = mainFrame

-- ===== 按钮事件（示例） =====
startBtn.MouseButton1Click:Connect(function()
    print("启动按钮点击")
end)

modeBtn.MouseButton1Click:Connect(function()
    print("切换模式点击")
end)

print("SANA HUB 悬浮窗已加载")