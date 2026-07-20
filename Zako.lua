-- ============================================
--  🕺 热门动作脚本（全服可见）
--  按F1打开菜单 | 含"疯狂的兔子"等热门动作
-- ============================================

local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

print("🕺 热门动作脚本已加载")

-- ============================================
--  🔥 热门动作ID列表（全服可见）
-- ============================================
local animations = {
    -- 🐰 疯狂的兔子（近期热门）
    {name = "🐰 疯狂的兔子", id = "rbxassetid://507771447"},
    {name = "🐰 兔子舞", id = "rbxassetid://507771008"},
    {name = "🐰 兔兔跳", id = "rbxassetid://507771391"},
    
    -- 🔥 近期爆火动作
    {name = "🕺 科目三", id = "rbxassetid://507771447"},
    {name = "💃 青海摇", id = "rbxassetid://507771769"},
    {name = "🎵 钢管舞", id = "rbxassetid://507771873"},
    {name = "🔥 电摇", id = "rbxassetid://507771391"},
    {name = "😎 帅气走", id = "rbxassetid":"},  -- 需要替换ID
    {name = "🤯 震惊", id = "rbxassetid://507771313"},
    {name = "💪 秀肌肉", id = "rbxassetid://507771506"},
    {name = "🎧 摇头", id = "rbxassetid://507771666"},
    {name = "💔 伤心", id = "rbxassetid://507771873"},
    {name = "🎉 胜利舞", id = "rbxassetid://507771829"},
    {name = "🤝 握手", id = "rbxassetid":"},  -- 需要替换ID
}

-- ============================================
--  动作播放器
-- ============================================
local currentAnim = nil

local function playAnim(animId)
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    
    if currentAnim then
        currentAnim:Stop()
        currentAnim = nil
    end
    
    local anim = Instance.new("Animation")
    anim.AnimationId = animId
    currentAnim = hum:LoadAnimation(anim)
    currentAnim:Play()
    print("🎵 播放动作: " .. animId)
end

local function stopAnim()
    if currentAnim then
        currentAnim:Stop()
        currentAnim = nil
        print("⏹️ 已停止")
    end
end

-- ============================================
--  📋 菜单UI
-- ============================================
local function createMenu()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AnimMenu"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 230, 0, 400)
    frame.Position = UDim2.new(0.5, -115, 0.2, 0)
    frame.BackgroundColor3 = Color3.fromRGB(15, 12, 30)
    frame.BackgroundTransparency = 0.05
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(255, 100, 200)
    frame.Active = true
    frame.Draggable = true
    frame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 35)
    title.Position = UDim2.new(0, 0, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = "🐰 热门动作"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.Parent = frame

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, -50)
    scroll.Position = UDim2.new(0, 0, 0, 45)
    scroll.BackgroundTransparency = 1
    scroll.CanvasSize = UDim2.new(0, 0, 0, #animations * 40 + 60)
    scroll.ScrollBarThickness = 4
    scroll.Parent = frame

    local y = 5
    for _, anim in pairs(animations) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 32)
        btn.Position = UDim2.new(0.05, 0, 0, y)
        btn.BackgroundColor3 = Color3.fromRGB(30, 25, 50)
        btn.Text = anim.name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 13
        btn.Font = Enum.Font.Gotham
        btn.BorderSizePixel = 0
        btn.Parent = scroll

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn

        btn.MouseButton1Click:Connect(function()
            playAnim(anim.id)
        end)

        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(60, 50, 100)
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(30, 25, 50)
        end)

        y = y + 38
    end

    -- 停止按钮
    local stopBtn = Instance.new("TextButton")
    stopBtn.Size = UDim2.new(0.9, 0, 0, 32)
    stopBtn.Position = UDim2.new(0.05, 0, 0, y + 10)
    stopBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    stopBtn.Text = "⏹️ 停止动作"
    stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    stopBtn.TextSize = 13
    stopBtn.Font = Enum.Font.GothamBold
    stopBtn.BorderSizePixel = 0
    stopBtn.Parent = scroll

    local stopCorner = Instance.new("UICorner")
    stopCorner.CornerRadius = UDim.new(0, 6)
    stopCorner.Parent = stopBtn

    stopBtn.MouseButton1Click:Connect(function()
        stopAnim()
    end)

    scroll.CanvasSize = UDim2.new(0, 0, 0, y + 60)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 25, 0, 25)
    closeBtn.Position = UDim2.new(1, -30, 0, 5)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(200, 100, 100)
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = frame
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    return screenGui
end

-- ============================================
--  ⌨️ 快捷键
-- ============================================
local menu = nil

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        if menu then
            menu:Destroy()
            menu = nil
        else
            menu = createMenu()
        end
    end
end)

print("========================================")
print("  🕺 热门动作脚本已加载")
print("  📌 按 F1 打开菜单")
print("  🐰 包含热门动作：疯狂的兔子")
print("========================================")