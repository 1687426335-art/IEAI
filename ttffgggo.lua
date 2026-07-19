-- ========== wdfex辅助 手机版 V2 ==========
-- 加载动画 → 悬浮窗按钮 → 点一下开启功能 → 可关闭

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local speedEnabled = false
local espEnabled = true
local speedMultiplier = 2
local displayObjects = {}
local minimized = false

-- ========== 创建GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = CoreGui
screenGui.Name = "wdfexGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ========== 加载动画 ==========
local loadingFrame = Instance.new("Frame")
loadingFrame.Parent = screenGui
loadingFrame.Size = UDim2.new(0, 300, 0, 200)
loadingFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
loadingFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
loadingFrame.BackgroundTransparency = 0.1
loadingFrame.BorderSizePixel = 0

local loadCorner = Instance.new("UICorner")
loadCorner.Parent = loadingFrame
loadCorner.CornerRadius = UDim.new(0, 16)

local loadTitle = Instance.new("TextLabel")
loadTitle.Parent = loadingFrame
loadTitle.Size = UDim2.new(1, 0, 0, 40)
loadTitle.Position = UDim2.new(0, 0, 0, 20)
loadTitle.Text = "wdfex辅助"
loadTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
loadTitle.BackgroundTransparency = 1
loadTitle.TextSize = 26
loadTitle.Font = Enum.Font.GothamBold

local loadHint = Instance.new("TextLabel")
loadHint.Parent = loadingFrame
loadHint.Size = UDim2.new(1, 0, 0, 25)
loadHint.Position = UDim2.new(0, 0, 0, 65)
loadHint.Text = "正在加载..."
loadHint.TextColor3 = Color3.fromRGB(200, 200, 200)
loadHint.BackgroundTransparency = 1
loadHint.TextSize = 15
loadHint.Font = Enum.Font.Gotham

local progressBg = Instance.new("Frame")
progressBg.Parent = loadingFrame
progressBg.Size = UDim2.new(0, 250, 0, 8)
progressBg.Position = UDim2.new(0.5, -125, 0, 95)
progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
progressBg.BorderSizePixel = 0

local progCorner = Instance.new("UICorner")
progCorner.Parent = progressBg
progCorner.CornerRadius = UDim.new(0, 4)

local progressBar = Instance.new("Frame")
progressBar.Parent = progressBg
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
progressBar.BorderSizePixel = 0

local progBarCorner = Instance.new("UICorner")
progBarCorner.Parent = progressBar
progBarCorner.CornerRadius = UDim.new(0, 4)

local progressText = Instance.new("TextLabel")
progressText.Parent = loadingFrame
progressText.Size = UDim2.new(1, 0, 0, 30)
progressText.Position = UDim2.new(0, 0, 0, 110)
progressText.Text = "0%"
progressText.TextColor3 = Color3.fromRGB(0, 200, 255)
progressText.BackgroundTransparency = 1
progressText.TextSize = 18
progressText.Font = Enum.Font.GothamBold

-- ========== 加载功能（真实加载） ==========
local function loadFunctions()
    local steps = {
        {text = "初始化配置...", pct = 10},
        {text = "加载过检测模块...", pct = 25},
        {text = "加载ESP透视...", pct = 45},
        {text = "加载人物加速...", pct = 65},
        {text = "加载悬浮窗...", pct = 80},
        {text = "加载完成！", pct = 100}
    }
    
    for i, step in ipairs(steps) do
        loadHint.Text = step.text
        progressBar.Size = UDim2.new(step.pct / 100, 0, 1, 0)
        progressText.Text = step.pct .. "%"
        
        if step.pct == 25 then
            -- 加载过检测
            pcall(function()
                local network = game:GetService("NetworkClient")
                if network then
                    network:SetOutgoingKBPSLimit(999999)
                end
            end)
        end
        
        if step.pct == 45 then
            -- 加载ESP
            setupESP()
        end
        
        if step.pct == 65 then
            -- 加载加速
            setupSpeed()
        end
        
        RunService.Heartbeat:Wait()
        task.wait(0.3)
    end
    
    -- 加载完成，显示主界面
    loadingFrame.Visible = false
    mainFrame.Visible = true
end

-- ========== ESP功能 ==========
function setupESP()
    local Camera = workspace.CurrentCamera
    local function worldToScreen(pos)
        local sp, onScreen = Camera:WorldToScreenPoint(pos)
        return Vector2.new(sp.X, sp.Y), onScreen
    end
    
    RunService.RenderStepped:Connect(function()
        if not espEnabled then
            for _, obj in pairs(displayObjects) do
                if obj.label then obj.label.Visible = false end
            end
            return
        end
        
        for _, player in pairs(Players:GetPlayers()) do
            if player == LocalPlayer then goto continue end
            local char = player.Character
            if not char then goto continue end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")
            if not hrp or not hum then goto continue end
            
            if not displayObjects[player.UserId] then
                local label = Instance.new("TextLabel")
                label.Parent = screenGui
                label.Size = UDim2.new(0, 200, 0, 45)
                label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                label.BackgroundTransparency = 0.5
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextSize = 14
                label.Font = Enum.Font.GothamBold
                label.Text = ""
                label.BorderSizePixel = 0
                local corner = Instance.new("UICorner")
                corner.Parent = label
                corner.CornerRadius = UDim.new(0, 6)
                displayObjects[player.UserId] = { label = label }
            end
            
            local obj = displayObjects[player.UserId]
            local localPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local dist = localPos and (hrp.Position - localPos.Position).Magnitude or 0
            local sp, onScreen = worldToScreen(hrp.Position + Vector3.new(0, 2.5, 0))
            
            if not onScreen then
                obj.label.Visible = false
                goto continue
            end
            
            obj.label.Position = UDim2.new(0, sp.X - 100, 0, sp.Y - 30)
            obj.label.Visible = true
            obj.label.Text = string.format("%s\n❤️%d  📏%dm", player.Name, math.round(hum.Health), math.round(dist))
            
            ::continue::
        end
        
        for id, obj in pairs(displayObjects) do
            if not Players:GetPlayerByUserId(id) then
                if obj.label then obj.label:Destroy() end
                displayObjects[id] = nil
            end
        end
    end)
end

-- ========== 加速功能 ==========
function setupSpeed()
    local function applySpeed()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        if not hum then return end
        if speedEnabled then
            hum.WalkSpeed = 16 * speedMultiplier
            hum.JumpPower = 50 * speedMultiplier
            print("⚡ 加速: " .. speedMultiplier .. "倍")
        end
    end
    
    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)
        applySpeed()
    end)
end

local function toggleSpeed()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    
    speedEnabled = not speedEnabled
    if speedEnabled then
        hum.WalkSpeed = 16 * speedMultiplier
        hum.JumpPower = 50 * speedMultiplier
        speedBtn.Text = "⚡ 加速: 开"
        speedBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        print("✅ 加速开启")
    else
        hum.WalkSpeed = 16
        hum.JumpPower = 50
        speedBtn.Text = "⚡ 加速: 关"
        speedBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        print("❌ 加速关闭")
    end
end

local function toggleESP()
    espEnabled = not espEnabled
    espBtn.Text = espEnabled and "👁️ ESP: 开" or "👁️ ESP: 关"
    espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)
    print(espEnabled and "✅ ESP开启" or "❌ ESP关闭")
end

-- ========== 创建主悬浮窗 ==========
local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 220, 0, 320)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false

local mainCorner = Instance.new("UICorner")
mainCorner.Parent = mainFrame
mainCorner.CornerRadius = UDim.new(0, 14)

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Parent = mainFrame
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
titleBar.BackgroundTransparency = 0.2
titleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner")
titleCorner.Parent = titleBar
titleCorner.CornerRadius = UDim.new(0, 14)

local titleText = Instance.new("TextLabel")
titleText.Parent = titleBar
titleText.Size = UDim2.new(1, -70, 1, 0)
titleText.Position = UDim2.new(0, 35, 0, 0)
titleText.Text = "wdfex辅助"
titleText.TextColor3 = Color3.fromRGB(0, 200, 255)
titleText.BackgroundTransparency = 1
titleText.TextSize = 18
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left

-- 关闭按钮 X
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = titleBar
closeBtn.Size = UDim2.new(0, 35, 1, 0)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.BackgroundTransparency = 1
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    print("❌ wdfex辅助已关闭")
end)

-- 最小化按钮 -
local minBtn = Instance.new("TextButton")
minBtn.Parent = titleBar
minBtn.Size = UDim2.new(0, 35, 1, 0)
minBtn.Position = UDim2.new(1, -70, 0, 0)
minBtn.Text = "─"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.BackgroundTransparency = 1
minBtn.TextSize = 18
minBtn.Font = Enum.Font.GothamBold
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame.Visible = false
        miniBall.Visible = true
    else
        mainFrame.Visible = true
        miniBall.Visible = false
    end
end)

-- ========== 最小化圆球 ==========
local miniBall = Instance.new("TextButton")
miniBall.Parent = screenGui
miniBall.Size = UDim2.new(0, 55, 0, 55)
miniBall.Position = UDim2.new(1, -75, 0.9, 0)
miniBall.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
miniBall.Text = "✈️"
miniBall.TextColor3 = Color3.fromRGB(255, 255, 255)
miniBall.TextSize = 26
miniBall.Font = Enum.Font.GothamBold
miniBall.BorderSizePixel = 0
miniBall.Visible = false

local ballCorner = Instance.new("UICorner")
ballCorner.Parent = miniBall
ballCorner.CornerRadius = UDim.new(1, 0)

miniBall.MouseButton1Click:Connect(function()
    minimized = false
    miniBall.Visible = false
    mainFrame.Visible = true
end)

-- ========== 功能按钮 ==========
local btnY = 55

-- 加速按钮
local speedBtn = Instance.new("TextButton")
speedBtn.Parent = mainFrame
speedBtn.Size = UDim2.new(0, 180, 0, 45)
speedBtn.Position = UDim2.new(0.5, -90, 0, btnY)
speedBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
speedBtn.Text = "⚡ 加速: 关"
speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBtn.TextSize = 18
speedBtn.Font = Enum.Font.GothamBold
speedBtn.BorderSizePixel = 0

local btnCorner = Instance.new("UICorner")
btnCorner.Parent = speedBtn
btnCorner.CornerRadius = UDim.new(0, 10)

speedBtn.MouseButton1Click:Connect(toggleSpeed)

-- ESP按钮
local espBtn = Instance.new("TextButton")
espBtn.Parent = mainFrame
espBtn.Size = UDim2.new(0, 180, 0, 45)
espBtn.Position = UDim2.new(0.5, -90, 0, btnY + 60)
espBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
espBtn.Text = "👁️ ESP: 开"
espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
espBtn.TextSize = 18
espBtn.Font = Enum.Font.GothamBold
espBtn.BorderSizePixel = 0

local espCorner = Instance.new("UICorner")
espCorner.Parent = espBtn
espCorner.CornerRadius = UDim.new(0, 10)

espBtn.MouseButton1Click:Connect(toggleESP)

-- 倍率显示
local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = mainFrame
speedLabel.Size = UDim2.new(1, 0, 0, 30)
speedLabel.Position = UDim2.new(0, 0, 0, btnY + 115)
speedLabel.Text = "倍率: 2x (按1-5调整)"
speedLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
speedLabel.BackgroundTransparency = 1
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.Gotham

-- 状态标签
local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = mainFrame
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 0, btnY + 150)
statusLabel.Text = "🟢 运行中"
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham

-- 版本信息
local versionLabel = Instance.new("TextLabel")
versionLabel.Parent = mainFrame
versionLabel.Size = UDim2.new(1, 0, 0, 25)
versionLabel.Position = UDim2.new(0, 0, 0, btnY + 185)
versionLabel.Text = "wdfex v2.0 | 手机版"
versionLabel.TextColor3 = Color3.fromRGB(100, 100, 140)
versionLabel.BackgroundTransparency = 1
versionLabel.TextSize = 12
versionLabel.Font = Enum.Font.Gotham

-- ========== 键盘监听 ==========
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    local key = input.KeyCode
    
    if key == Enum.KeyCode.G then
        toggleSpeed()
    end
    
    if key == Enum.KeyCode.F then
        toggleESP()
    end
    
    local speedMap = {
        [Enum.KeyCode.One] = 1,
        [Enum.KeyCode.Two] = 1.5,
        [Enum.KeyCode.Three] = 2,
        [Enum.KeyCode.Four] = 2.5,
        [Enum.KeyCode.Five] = 3,
    }
    if speedMap[key] then
        speedMultiplier = speedMap[key]
        speedLabel.Text = "倍率: " .. speedMultiplier .. "x (按1-5调整)"
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
        print("⚡ 倍率: " .. speedMultiplier .. "x")
    end
end)

-- ========== 启动加载 ==========
task.spawn(function()
    loadFunctions()
end)

print("========================================")
print("  ✅ wdfex辅助 手机版加载成功！")
print("  点击按钮开关功能")
print("  G = 开关加速  F = 开关ESP")
print("  1-5 = 调整加速倍率")
print("  ✕ = 关闭辅助  ─ = 最小化")
print("========================================")
