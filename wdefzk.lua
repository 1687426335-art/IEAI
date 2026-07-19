-- ========== 圣奥里飞车 完整版 ==========
-- 卡密验证 + 加载动画 + 欢迎特效 + 飞车控制

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

local flyEnabled = false
local flySpeed = 80
local flyBV = nil
local flyBG = nil
local flyConn = nil
local isVerified = false

-- ==================== 卡密验证 ====================
local function verifyKey(input)
    local validKeys = {
        ["wdfex"] = true,
        ["WDFEX"] = true,
        ["1"] = true,
    }
    return validKeys[input] or false
end

-- ==================== 加载动画 ====================
local function createLoadingScreen()
    local loadingGui = Instance.new("ScreenGui")
    loadingGui.Parent = CoreGui
    loadingGui.Name = "LoadingScreen"
    loadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    loadingGui.IgnoreGuiInset = true

    local bg = Instance.new("Frame")
    bg.Parent = loadingGui
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(5, 5, 20)
    bg.BackgroundTransparency = 0
    bg.ZIndex = 999

    local logo = Instance.new("TextLabel")
    logo.Parent = bg
    logo.Size = UDim2.new(1, 0, 0, 60)
    logo.Position = UDim2.new(0, 0, 0.3, 0)
    logo.BackgroundTransparency = 1
    logo.Text = "🚗 飞车控制"
    logo.TextColor3 = Color3.fromRGB(0, 200, 255)
    logo.TextSize = 40
    logo.Font = Enum.Font.GothamBlack
    logo.TextStrokeTransparency = 0
    logo.TextStrokeColor3 = Color3.fromRGB(0, 100, 200)
    logo.ZIndex = 1000

    local subText = Instance.new("TextLabel")
    subText.Parent = bg
    subText.Size = UDim2.new(1, 0, 0, 30)
    subText.Position = UDim2.new(0, 0, 0.4, 0)
    subText.BackgroundTransparency = 1
    subText.Text = "正在加载..."
    subText.TextColor3 = Color3.fromRGB(180, 180, 210)
    subText.TextSize = 18
    subText.Font = Enum.Font.Gotham
    subText.ZIndex = 1000

    local barBg = Instance.new("Frame")
    barBg.Parent = bg
    barBg.Size = UDim2.new(0, 250, 0, 6)
    barBg.Position = UDim2.new(0.5, -125, 0.48, 0)
    barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    barBg.BorderSizePixel = 0
    barBg.ZIndex = 1000

    local barCorner = Instance.new("UICorner")
    barCorner.Parent = barBg
    barCorner.CornerRadius = UDim.new(1, 0)

    local bar = Instance.new("Frame")
    bar.Parent = barBg
    bar.Size = UDim2.new(0, 0, 1, 0)
    bar.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    bar.BorderSizePixel = 0
    bar.ZIndex = 1001

    local barCorner2 = Instance.new("UICorner")
    barCorner2.Parent = bar
    barCorner2.CornerRadius = UDim.new(1, 0)

    local percentText = Instance.new("TextLabel")
    percentText.Parent = bg
    percentText.Size = UDim2.new(1, 0, 0, 25)
    percentText.Position = UDim2.new(0, 0, 0.52, 0)
    percentText.BackgroundTransparency = 1
    percentText.Text = "0%"
    percentText.TextColor3 = Color3.fromRGB(0, 200, 255)
    percentText.TextSize = 16
    percentText.Font = Enum.Font.Gotham
    percentText.ZIndex = 1000

    -- 粒子特效
    local particles = {}
    for i = 1, 30 do
        local p = Instance.new("Frame")
        p.Parent = bg
        p.Size = UDim2.new(0, 3 + math.random() * 4, 0, 3 + math.random() * 4)
        p.Position = UDim2.new(math.random(), 0, math.random(), 0)
        p.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
        p.BackgroundTransparency = 0.5 + math.random() * 0.4
        p.BorderSizePixel = 0
        p.ZIndex = 999
        local pCorner = Instance.new("UICorner")
        pCorner.Parent = p
        pCorner.CornerRadius = UDim.new(1, 0)
        table.insert(particles, {
            frame = p,
            x = p.Position.X.Scale,
            y = p.Position.Y.Scale,
            speed = 0.0005 + math.random() * 0.001,
            dir = math.random() * 2 - 1
        })
    end

    return loadingGui, bar, percentText, subText, particles
end

-- ==================== 卡密验证UI ====================
local function createVerifyUI()
    local verifyGui = Instance.new("ScreenGui")
    verifyGui.Parent = CoreGui
    verifyGui.Name = "VerifyUI"
    verifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local bg = Instance.new("Frame")
    bg.Parent = verifyGui
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(5, 5, 20)
    bg.BackgroundTransparency = 0.2
    bg.ZIndex = 1000

    local frame = Instance.new("Frame")
    frame.Parent = bg
    frame.Size = UDim2.new(0, 320, 0, 240)
    frame.Position = UDim2.new(0.5, -160, 0.5, -120)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.ZIndex = 1001

    local frameCorner = Instance.new("UICorner")
    frameCorner.Parent = frame
    frameCorner.CornerRadius = UDim.new(0, 16)

    local stroke = Instance.new("UIStroke")
    stroke.Parent = frame
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(0, 200, 255)
    stroke.Transparency = 0.3

    local title = Instance.new("TextLabel")
    title.Parent = frame
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "🔐 飞车控制"
    title.TextColor3 = Color3.fromRGB(0, 200, 255)
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.ZIndex = 1002

    local subTitle = Instance.new("TextLabel")
    subTitle.Parent = frame
    subTitle.Size = UDim2.new(1, 0, 0, 25)
    subTitle.Position = UDim2.new(0, 0, 0, 60)
    subTitle.BackgroundTransparency = 1
    subTitle.Text = "请输入卡密"
    subTitle.TextColor3 = Color3.fromRGB(180, 180, 210)
    subTitle.TextSize = 15
    subTitle.Font = Enum.Font.Gotham
    subTitle.ZIndex = 1002

    local input = Instance.new("TextBox")
    input.Parent = frame
    input.Size = UDim2.new(0, 220, 0, 40)
    input.Position = UDim2.new(0.5, -110, 0, 95)
    input.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.Text = ""
    input.PlaceholderText = "请输入卡密"
    input.TextSize = 18
    input.Font = Enum.Font.Gotham
    input.BorderSizePixel = 0
    input.ZIndex = 1002

    local inputCorner = Instance.new("UICorner")
    inputCorner.Parent = input
    inputCorner.CornerRadius = UDim.new(0, 8)

    local verifyBtn = Instance.new("TextButton")
    verifyBtn.Parent = frame
    verifyBtn.Size = UDim2.new(0, 220, 0, 40)
    verifyBtn.Position = UDim2.new(0.5, -110, 0, 150)
    verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    verifyBtn.Text = "✅ 验证卡密"
    verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    verifyBtn.TextSize = 18
    verifyBtn.Font = Enum.Font.GothamBold
    verifyBtn.BorderSizePixel = 0
    verifyBtn.ZIndex = 1002

    local btnCorner = Instance.new("UICorner")
    btnCorner.Parent = verifyBtn
    btnCorner.CornerRadius = UDim.new(0, 8)

    local result = Instance.new("TextLabel")
    result.Parent = frame
    result.Size = UDim2.new(1, 0, 0, 25)
    result.Position = UDim2.new(0, 0, 0, 200)
    result.BackgroundTransparency = 1
    result.Text = "💡 卡密: wdfex"
    result.TextColor3 = Color3.fromRGB(255, 200, 0)
    result.TextSize = 14
    result.Font = Enum.Font.Gotham
    result.ZIndex = 1002

    return verifyGui, input, verifyBtn, result, bg
end

-- ==================== 欢迎特效 ====================
local function showWelcomeEffect()
    local welcomeGui = Instance.new("ScreenGui")
    welcomeGui.Parent = CoreGui
    welcomeGui.Name = "WelcomeEffect"
    welcomeGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local bg = Instance.new("Frame")
    bg.Parent = welcomeGui
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.3
    bg.ZIndex = 998

    -- 烟花粒子
    for i = 1, 50 do
        local p = Instance.new("Frame")
        p.Parent = bg
        p.Size = UDim2.new(0, 4 + math.random() * 6, 0, 4 + math.random() * 6)
        p.Position = UDim2.new(math.random(), 0, math.random(), 0)
        p.BackgroundColor3 = Color3.fromRGB(
            math.random(100, 255),
            math.random(100, 255),
            math.random(100, 255)
        )
        p.BackgroundTransparency = 0.2
        p.BorderSizePixel = 0
        p.ZIndex = 999
        local pCorner = Instance.new("UICorner")
        pCorner.Parent = p
        pCorner.CornerRadius = UDim.new(1, 0)
        
        local startY = p.Position.Y.Scale
        local endY = startY - 0.3 - math.random() * 0.3
        TweenService:Create(p, TweenInfo.new(1.5 + math.random() * 2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(p.Position.X.Scale + (math.random() - 0.5) * 0.1, 0, endY, 0),
            BackgroundTransparency = 1
        }):Play()
    end

    -- 欢迎文字
    local welcomeText = Instance.new("TextLabel")
    welcomeText.Parent = bg
    welcomeText.Size = UDim2.new(1, 0, 0, 60)
    welcomeText.Position = UDim2.new(0, 0, 0.3, 0)
    welcomeText.BackgroundTransparency = 1
    welcomeText.Text = "🎉 欢迎使用飞车控制"
    welcomeText.TextColor3 = Color3.fromRGB(0, 200, 255)
    welcomeText.TextSize = 36
    welcomeText.Font = Enum.Font.GothamBlack
    welcomeText.TextStrokeTransparency = 0
    welcomeText.TextStrokeColor3 = Color3.fromRGB(0, 100, 200)
    welcomeText.ZIndex = 1000

    local subText = Instance.new("TextLabel")
    subText.Parent = bg
    subText.Size = UDim2.new(1, 0, 0, 30)
    subText.Position = UDim2.new(0, 0, 0.4, 0)
    subText.BackgroundTransparency = 1
    subText.Text = "按 G 键开关飞车 | 速度可调"
    subText.TextColor3 = Color3.fromRGB(180, 180, 210)
    subText.TextSize = 16
    subText.Font = Enum.Font.Gotham
    subText.ZIndex = 1000

    TweenService:Create(welcomeText, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        TextSize = 40
    }):Play()

    -- 3秒后消失
    task.wait(3)
    TweenService:Create(bg, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    }):Play()
    TweenService:Create(welcomeText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        TextTransparency = 1
    }):Play()
    TweenService:Create(subText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        TextTransparency = 1
    }):Play()
    task.wait(0.5)
    welcomeGui:Destroy()
end

-- ==================== 创建悬浮窗 ====================
local function createMainUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = CoreGui
    screenGui.Name = "CarFly"
    screenGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = screenGui
    mainFrame.Size = UDim2.new(0, 200, 0, 180)
    mainFrame.Position = UDim2.new(0.5, -100, 0.5, -90)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
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
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    titleBar.BackgroundTransparency = 0.2
    titleBar.BorderSizePixel = 0

    local titleCorner = Instance.new("UICorner")
    titleCorner.Parent = titleBar
    titleCorner.CornerRadius = UDim.new(0, 14)

    local titleText = Instance.new("TextLabel")
    titleText.Parent = titleBar
    titleText.Size = UDim2.new(1, -60, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.Text = "🚗 飞车控制"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.BackgroundTransparency = 1
    titleText.TextSize = 15
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left

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

    -- 开关按钮
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Parent = mainFrame
    toggleBtn.Size = UDim2.new(0, 160, 0, 40)
    toggleBtn.Position = UDim2.new(0.5, -80, 0, 45)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    toggleBtn.Text = "🚗 飞车: 关"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 16
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.BorderSizePixel = 0

    local btnCorner = Instance.new("UICorner")
    btnCorner.Parent = toggleBtn
    btnCorner.CornerRadius = UDim.new(0, 8)

    -- 速度控制
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Parent = mainFrame
    speedLabel.Size = UDim2.new(1, 0, 0, 25)
    speedLabel.Position = UDim2.new(0, 0, 0, 100)
    speedLabel.Text = "速度: 80"
    speedLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
    speedLabel.BackgroundTransparency = 1
    speedLabel.TextSize = 14
    speedLabel.Font = Enum.Font.Gotham

    local speedDown = Instance.new("TextButton")
    speedDown.Parent = mainFrame
    speedDown.Size = UDim2.new(0, 35, 0, 28)
    speedDown.Position = UDim2.new(0, 15, 0, 130)
    speedDown.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    speedDown.Text = "-"
    speedDown.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedDown.TextSize = 18
    speedDown.Font = Enum.Font.GothamBold
    speedDown.BorderSizePixel = 0

    local sdCorner = Instance.new("UICorner")
    sdCorner.Parent = speedDown
    sdCorner.CornerRadius = UDim.new(0, 6)

    local speedInput = Instance.new("TextBox")
    speedInput.Parent = mainFrame
    speedInput.Size = UDim2.new(0, 70, 0, 28)
    speedInput.Position = UDim2.new(0.5, -35, 0, 130)
    speedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedInput.Text = "80"
    speedInput.PlaceholderText = "1-200"
    speedInput.TextSize = 15
    speedInput.Font = Enum.Font.Gotham
    speedInput.BorderSizePixel = 0

    local siCorner = Instance.new("UICorner")
    siCorner.Parent = speedInput
    siCorner.CornerRadius = UDim.new(0, 6)

    local speedUp = Instance.new("TextButton")
    speedUp.Parent = mainFrame
    speedUp.Size = UDim2.new(0, 35, 0, 28)
    speedUp.Position = UDim2.new(1, -50, 0, 130)
    speedUp.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    speedUp.Text = "+"
    speedUp.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedUp.TextSize = 18
    speedUp.Font = Enum.Font.GothamBold
    speedUp.BorderSizePixel = 0

    local suCorner = Instance.new("UICorner")
    suCorner.Parent = speedUp
    suCorner.CornerRadius = UDim.new(0, 6)

    return screenGui, toggleBtn, speedLabel, speedInput
end

-- ==================== 飞车核心 ====================
local function toggleFly(toggleBtn)
    if not isVerified then
        print("❌ 请先验证卡密")
        return
    end
    
    if flyEnabled then
        flyEnabled = false
        toggleBtn.Text = "🚗 飞车: 关"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        print("❌ 飞车关闭")
        if flyBV then flyBV:Destroy(); flyBV = nil end
        if flyBG then flyBG:Destroy(); flyBG = nil end
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        if LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum.PlatformStand = false end
        end
        return
    end
    
    local char = LocalPlayer.Character
    if not char then
        print("❌ 没有角色")
        return
    end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then
        print("❌ 没有 Humanoid")
        return
    end
    
    print("✅ 飞车开启")
    flyEnabled = true
    toggleBtn.Text = "🚗 飞车: 开"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    
    hum.PlatformStand = true
    
    if flyBV then flyBV:Destroy() end
    if flyBG then flyBG:Destroy() end
    if flyConn then flyConn:Disconnect() end
    
    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    flyBV.Velocity = Vector3.new(0, 20, 0)
    flyBV.Parent = hrp
    
    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    flyBG.D = 5000
    flyBG.P = 50000
    flyBG.CFrame = Camera.CFrame
    flyBG.Parent = hrp
    
    flyConn = RunService.Heartbeat:Connect(function()
        if not flyEnabled then
            if flyConn then
                flyConn:Disconnect()
                flyConn = nil
            end
            return
        end
        if not hrp or not hrp.Parent then
            flyEnabled = false
            toggleBtn.Text = "🚗 飞车: 关"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            if flyConn then
                flyConn:Disconnect()
                flyConn = nil
            end
            return
        end
        if flyBV and flyBG then
            flyBV.Velocity = Camera.CFrame.LookVector * flySpeed
            flyBG.CFrame = Camera.CFrame
        end
    end)
end

-- ==================== 主流程 ====================
local function startScript()
    -- 创建加载动画
    local loadingGui, bar, percentText, subText, particles = createLoadingScreen()
    
    -- 模拟加载进度
    local progress = 0
    local steps = {"初始化...", "加载配置...", "启动引擎...", "准备就绪!"}
    local stepIndex = 1
    
    while progress < 100 do
        progress = progress + math.random(2, 5)
        if progress > 100 then progress = 100 end
        bar.Size = UDim2.new(progress / 100, 0, 1, 0)
        percentText.Text = progress .. "%"
        if progress > 20 and stepIndex < 2 then stepIndex = 2; subText.Text = steps[2] end
        if progress > 50 and stepIndex < 3 then stepIndex = 3; subText.Text = steps[3] end
        if progress > 80 and stepIndex < 4 then stepIndex = 4; subText.Text = steps[4] end
        
        -- 粒子飘动
        for _, p in pairs(particles) do
            p.y = p.y - p.speed
            if p.y < -0.1 then
                p.y = 1.1
                p.x = math.random()
            end
            p.frame.Position = UDim2.new(p.x, 0, p.y, 0)
        end
        
        task.wait(0.02 + math.random() * 0.03)
    end
    
    task.wait(0.3)
    loadingGui:Destroy()
    
    -- 创建验证UI
    local verifyGui, input, verifyBtn, result, bg = createVerifyUI()
    
    -- 验证事件
    verifyBtn.MouseButton1Click:Connect(function()
        local key = input.Text
        if verifyKey(key) then
            isVerified = true
            result.Text = "✅ 验证成功!"
            result.TextColor3 = Color3.fromRGB(0, 255, 0)
            print("✅ 卡密验证成功")
            
            -- 关闭验证UI
            TweenService:Create(bg, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(0.3)
            verifyGui:Destroy()
            
            -- 创建主UI
            local screenGui, toggleBtn, speedLabel, speedInput = createMainUI()
            
            -- 速度事件
            speedDown.MouseButton1Click:Connect(function()
                flySpeed = math.max(flySpeed - 5, 1)
                speedLabel.Text = "速度: " .. flySpeed
                speedInput.Text = tostring(flySpeed)
                if flyEnabled and flyBV then
                    flyBV.Velocity = Camera.CFrame.LookVector * flySpeed
                end
            end)
            
            speedUp.MouseButton1Click:Connect(function()
                flySpeed = math.min(flySpeed + 5, 200)
                speedLabel.Text = "速度: " .. flySpeed
                speedInput.Text = tostring(flySpeed)
                if flyEnabled and flyBV then
                    flyBV.Velocity = Camera.CFrame.LookVector * flySpeed
                end
            end)
            
            speedInput.FocusLost:Connect(function()
                local v = tonumber(speedInput.Text)
                if v then
                    flySpeed = math.clamp(v, 1, 200)
                    speedLabel.Text = "速度: " .. flySpeed
                    if flyEnabled and flyBV then
                        flyBV.Velocity = Camera.CFrame.LookVector * flySpeed
                    end
                else
                    speedInput.Text = tostring(flySpeed)
                end
            end)
            
            -- 飞车开关
            toggleBtn.MouseButton1Click:Connect(function()
                toggleFly(toggleBtn)
            end)
            
            -- 快捷键
            UserInputService.InputBegan:Connect(function(input, gp)
                if gp then return end
                if input.KeyCode == Enum.KeyCode.G then
                    toggleFly(toggleBtn)
                end
            end)
            
            -- 角色重生
            LocalPlayer.CharacterAdded:Connect(function()
                task.wait(0.5)
                if flyEnabled then
                    flyEnabled = false
                    if flyBV then flyBV:Destroy(); flyBV = nil end
                    if flyBG then flyBG:Destroy(); flyBG = nil end
                    if flyConn then flyConn:Disconnect(); flyConn = nil end
                    toggleBtn.Text = "🚗 飞车: 关"
                    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                end
            end)
            
            -- 显示欢迎特效
            showWelcomeEffect()
            
            print("========================================")
            print("  ✅ 飞车控制 加载成功")
            print("  卡密: wdfex")
            print("  点击按钮 或 按 G 键 开关")
            print("  速度1-200可调")
            print("========================================")
            
        else
            result.Text = "❌ 卡密错误"
            result.TextColor3 = Color3.fromRGB(255, 0, 0)
            input.Text = ""
            print("❌ 卡密错误")
        end
    end)
end

-- ==================== 启动 ====================
startScript()