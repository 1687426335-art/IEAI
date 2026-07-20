-- ============================================
--  🕺 热门动作脚本（平板适配版 + 卡密验证）
--  卡密：1 | 全屏适配
-- ============================================

local player = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

print("🕺 热门动作脚本已启动（平板适配版）")

-- ============================================
--  🔥 动作列表
-- ============================================
local animations = {
    {name = "🕺 疯狂兔子", id = "rbxassetid://507771391"},
    {name = "💃 科目三", id = "rbxassetid://507771447"},
    {name = "🎵 电摇", id = "rbxassetid://507771769"},
    {name = "🔥 青海摇", id = "rbxassetid://507771873"},
    {name = "🎉 胜利舞", id = "rbxassetid://507771829"},
    {name = "😎 耍帅", id = "rbxassetid://507771709"},
    {name = "💪 秀肌肉", id = "rbxassetid":"},  -- 需要替换ID
    {name = "🤯 震惊", id = "rbxassetid://507771313"},
    {name = "🎧 摇头", id = "rbxassetid://507771666"},
    {name = "🚶 帅气走", id = "rbxassetid://507771041"},
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
        pcall(function() currentAnim:Stop() end)
        currentAnim = nil
    end
    
    pcall(function()
        local anim = Instance.new("Animation")
        anim.AnimationId = animId
        currentAnim = hum:LoadAnimation(anim)
        currentAnim:Play()
        print("🎵 播放: " .. animId)
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
--  🔑 卡密验证（卡密：1）
-- ============================================
local function showLogin()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LoginGUI"
    screenGui.Parent = CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.5
    bg.Parent = screenGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 350, 0, 250)
    frame.Position = UDim2.new(0.5, -175, 0.5, -125)
    frame.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 100, 200)
    frame.Parent = screenGui

    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 16)
    frameCorner.Parent = frame

    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(1, 0, 0, 55)
    logo.Position = UDim2.new(0, 0, 0, 15)
    logo.BackgroundTransparency = 1
    logo.Text = "🕺 热门动作"
    logo.TextColor3 = Color3.fromRGB(255, 255, 255)
    logo.TextSize = 30
    logo.Font = Enum.Font.GothamBold
    logo.Parent = frame

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, 0, 0, 25)
    sub.Position = UDim2.new(0, 0, 0, 70)
    sub.BackgroundTransparency = 1
    sub.Text = "请输入卡密验证"
    sub.TextColor3 = Color3.fromRGB(180, 160, 220)
    sub.TextSize = 16
    sub.Font = Enum.Font.Gotham
    sub.Parent = frame

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0, 220, 0, 45)
    input.Position = UDim2.new(0.5, -110, 0, 110)
    input.BackgroundColor3 = Color3.fromRGB(30, 25, 50)
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.PlaceholderText = "请输入卡密"
    input.PlaceholderColor3 = Color3.fromRGB(100, 80, 150)
    input.TextSize = 20
    input.Font = Enum.Font.Gotham
    input.BorderSizePixel = 0
    input.Parent = frame

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = input

    local errorLabel = Instance.new("TextLabel")
    errorLabel.Size = UDim2.new(1, 0, 0, 25)
    errorLabel.Position = UDim2.new(0, 0, 0, 162)
    errorLabel.BackgroundTransparency = 1
    errorLabel.Text = ""
    errorLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    errorLabel.TextSize = 14
    errorLabel.Font = Enum.Font.Gotham
    errorLabel.TextXAlignment = Enum.TextXAlignment.Center
    errorLabel.Parent = frame

    local loginBtn = Instance.new("TextButton")
    loginBtn.Size = UDim2.new(0, 140, 0, 45)
    loginBtn.Position = UDim2.new(0.5, -70, 0, 195)
    loginBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 200)
    loginBtn.Text = "🚀 验证"
    loginBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    loginBtn.TextSize = 20
    loginBtn.Font = Enum.Font.GothamBold
    loginBtn.BorderSizePixel = 0
    loginBtn.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = loginBtn

    loginBtn.MouseButton1Click:Connect(function()
        if input.Text == "1" then
            errorLabel.Text = "✅ 验证成功！"
            errorLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
            loginBtn.Text = "✅ 成功！"
            loginBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            task.wait(0.3)
            screenGui:Destroy()
            createMainUI()
        else
            errorLabel.Text = "❌ 卡密错误，请重新输入"
            frame.Position = UDim2.new(0.5, -180, 0.5, -125)
            task.wait(0.05)
            frame.Position = UDim2.new(0.5, -170, 0.5, -125)
            task.wait(0.05)
            frame.Position = UDim2.new(0.5, -175, 0.5, -125)
            input.Text = ""
            input:CaptureFocus()
        end
    end)

    input.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            loginBtn.MouseButton1Click:Fire()
        end
    end)
end

-- ============================================
--  🖥️ 主悬浮窗（平板适配）
-- ============================================
local function createMainUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ActionMenu"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 280, 0, 450)
    frame.Position = UDim2.new(0.02, 0, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
    frame.BackgroundTransparency = 0.05
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
    titleBar.Size = UDim2.new(1, 0, 0, 40)
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
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -35, 0, 2)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 20
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleBar
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- 滚动区域
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, -45)
    scroll.Position = UDim2.new(0, 0, 0, 45)
    scroll.BackgroundTransparency = 1
    scroll.CanvasSize = UDim2.new(0, 0, 0, #animations * 45 + 60)
    scroll.ScrollBarThickness = 6
    scroll.Parent = frame

    local y = 5
    for _, anim in pairs(animations) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 38)
        btn.Position = UDim2.new(0.05, 0, 0, y)
        btn.BackgroundColor3 = Color3.fromRGB(35, 30, 55)
        btn.Text = anim.name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 16
        btn.Font = Enum.Font.Gotham
        btn.BorderSizePixel = 0
        btn.Parent = scroll

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn

        btn.MouseButton1Click:Connect(function()
            playAnim(anim.id)
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

        y = y + 43
    end

    -- 停止按钮
    local stopBtn = Instance.new("TextButton")
    stopBtn.Size = UDim2.new(0.9, 0, 0, 38)
    stopBtn.Position = UDim2.new(0.05, 0, 0, y + 5)
    stopBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 60)
    stopBtn.Text = "⏹️ 停止动作"
    stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    stopBtn.TextSize = 16
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

    scroll.CanvasSize = UDim2.new(0, 0, 0, y + 65)

    print("✅ 热门动作脚本已加载（平板适配版）")
end

-- ============================================
--  🚀 启动
-- ============================================
showLogin()