-- ============================================
--  🕺 热门动作脚本（悬浮窗版）
--  按F1打开/关闭 | 全服可见
-- ============================================

local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

print("🕺 热门动作脚本已加载")

-- ============================================
--  🔥 官方可用动画ID（全服可见）
-- ============================================
local animations = {
    -- 舞蹈类
    {name = "🕺 疯狂兔子", id = "rbxassetid://18464395233"},
    {name = "💃 科目三", id = "rbxassetid://507771447"},
    {name = "🎵 电摇", id = "rbxassetid://507771391"},
    {name = "🔥 青海摇", id = "rbxassetid://507771769"},
    {name = "🎧 钢管舞", id = "rbxassetid://507771873"},
    {name = "🎉 胜利舞", id = "rbxassetid://507771829"},
    
    -- 表情类
    {name = "😎 耍帅", id = "rbxassetid://507771709"},
    {name = "💪 秀肌肉", id = "rbxassetid://507771506"},
    {name = "🤯 震惊", id = "rbxassetid://507771313"},
    {name = "💔 伤心", id = "rbxassetid":"},  -- 需要替换ID
    {name = "🎧 摇头", id = "rbxassetid://507771666"},
    {name = "🤝 握手", id = "rbxassetid":"},  -- 需要替换ID
    
    -- 行走类
    {name = "🚶 帅气走", id = "rbxassetid://507771041"},
    {name = "🏃 跑步", id = "rbxassetid":"},  -- 需要替换ID
}

-- ============================================
--  动作播放器
-- ============================================
local currentAnim = nil
local currentTrack = nil

local function playAnim(animId)
    local char = player.Character
    if not char then
        print("❌ 没有角色")
        return
    end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then
        print("❌ 没有Humanoid")
        return
    end
    
    -- 停止当前动作
    if currentAnim then
        pcall(function() currentAnim:Stop() end)
        currentAnim = nil
    end
    
    -- 创建并播放新动作
    pcall(function()
        local anim = Instance.new("Animation")
        anim.AnimationId = animId
        currentAnim = hum:LoadAnimation(anim)
        currentAnim:Play()
        print("🎵 播放动作: " .. animId)
    end)
end

local function stopAnim()
    if currentAnim then
        pcall(function() currentAnim:Stop() end)
        currentAnim = nil
        print("⏹️ 已停止")
    end
end

-- ============================================
--  🖥️ 悬浮窗菜单
-- ============================================
local menu = nil
local isMenuOpen = false

local function createMenu()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ActionMenu"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false

    -- 主框架
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 220, 0, 380)
    frame.Position = UDim2.new(0.5, -110, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
    frame.BackgroundTransparency = 0.08
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(255, 100, 200)
    frame.Active = true
    frame.Draggable = true
    frame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = frame

    -- 标题栏
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = Color3.fromRGB(255, 100, 200)
    titleBar.BackgroundTransparency = 0.2
    titleBar.Parent = frame
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 14)
    titleCorner.Parent = titleBar

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -50, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🕺 热门动作"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar

    -- 关闭按钮
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -30, 0, 2)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleBar
    closeBtn.MouseButton1Click:Connect(function()
        if menu then
            menu:Destroy()
            menu = nil
            isMenuOpen = false
        end
    end)

    -- 滚动区域
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, -40)
    scroll.Position = UDim2.new(0, 0, 0, 40)
    scroll.BackgroundTransparency = 1
    scroll.CanvasSize = UDim2.new(0, 0, 0, #animations * 40 + 50)
    scroll.ScrollBarThickness = 4
    scroll.Parent = frame

    local y = 5
    for _, anim in pairs(animations) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 34)
        btn.Position = UDim2.new(0.05, 0, 0, y)
        btn.BackgroundColor3 = Color3.fromRGB(35, 30, 55)
        btn.Text = anim.name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.Font = Enum.Font.Gotham
        btn.BorderSizePixel = 0
        btn.Parent = scroll

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn

        btn.MouseButton1Click:Connect(function()
            playAnim(anim.id)
            -- 点击反馈
            btn.BackgroundColor3 = Color3.fromRGB(100, 80, 180)
            task.wait(0.1)
            btn.BackgroundColor3 = Color3.fromRGB(35, 30, 55)
        end)

        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(60, 50, 100)
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(35, 30, 55)
        end)

        y = y + 40
    end

    -- 停止按钮
    local stopBtn = Instance.new("TextButton")
    stopBtn.Size = UDim2.new(0.9, 0, 0, 34)
    stopBtn.Position = UDim2.new(0.05, 0, 0, y + 5)
    stopBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 60)
    stopBtn.Text = "⏹️ 停止动作"
    stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    stopBtn.TextSize = 14
    stopBtn.Font = Enum.Font.GothamBold
    stopBtn.BorderSizePixel = 0
    stopBtn.Parent = scroll

    local stopCorner = Instance.new("UICorner")
    stopCorner.CornerRadius = UDim.new(0, 8)
    stopCorner.Parent = stopBtn

    stopBtn.MouseButton1Click:Connect(function()
        stopAnim()
        stopBtn.BackgroundColor3 = Color3.fromRGB(100, 80, 180)
        task.wait(0.1)
        stopBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 60)
    end)

    stopBtn.MouseEnter:Connect(function()
        stopBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 90)
    end)
    stopBtn.MouseLeave:Connect(function()
        stopBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 60)
    end)

    scroll.CanvasSize = UDim2.new(0, 0, 0, y + 55)

    return screenGui
end

-- ============================================
--  打开/关闭菜单
-- ============================================
local function toggleMenu()
    if isMenuOpen and menu then
        menu:Destroy()
        menu = nil
        isMenuOpen = false
    else
        menu = createMenu()
        isMenuOpen = true
    end
end

-- ============================================
--  ⌨️ 快捷键 F1
-- ============================================
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        toggleMenu()
    end
end)

print("========================================")
print("  🕺 热门动作脚本已加载")
print("  📌 按 F1 打开/关闭悬浮窗")
print("  🐰 包含：疯狂兔子 等热门动作")
print("========================================")