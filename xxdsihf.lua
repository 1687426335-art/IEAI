-- ============================================================
-- wdfex 卡密验证系统（高级版）
-- 卡密格式：wdfex-XXXX-XXXX（字母数字混合，不区分大小写）
-- ============================================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ===== 配置 =====
local CONFIG = {
    VALID_KEYS = {
        "wdfex-a1b2-c3d4",
        "wdfex-9f8e-7d6c",
        "wdfex-5g4h-3j2k",
        "wdfex-1q2w-3e4r",
        "wdfex-6t7y-8u9i",
    },
    SAVE_KEY = "wdfex_used_keys",
}

-- ===== 工具函数 =====
local function IsKeyFormatValid(key)
    if type(key) ~= "string" then return false end
    key = key:lower()
    local pattern = "^wdfex%-[%w][%w][%w][%w]%-[%w][%w][%w][%w]$"
    return string.match(key, pattern) ~= nil
end

local function NormalizeKey(key)
    return key:lower()
end

local function IsKeyValid(key)
    key = NormalizeKey(key)
    for _, valid in ipairs(CONFIG.VALID_KEYS) do
        if NormalizeKey(valid) == key then
            return true
        end
    end
    return false
end

local function GetUsedKeys()
    local success, result = pcall(function()
        return getgenv()._wdfex_used_keys
    end)
    if success and result then
        return result
    end
    return {}
end

local function SaveUsedKeys(keys)
    getgenv()._wdfex_used_keys = keys
end

local function IsKeyUsed(key)
    key = NormalizeKey(key)
    local used = GetUsedKeys()
    for _, k in ipairs(used) do
        if NormalizeKey(k) == key then
            return true
        end
    end
    return false
end

local function MarkKeyUsed(key)
    key = NormalizeKey(key)
    local used = GetUsedKeys()
    table.insert(used, key)
    SaveUsedKeys(used)
end

local function ValidateKey(key, onSuccess, onFail)
    if not key or key == "" then
        if onFail then onFail("请输入卡密") end
        return false
    end
    
    if not IsKeyFormatValid(key) then
        if onFail then onFail("卡密格式错误") end
        return false
    end
    
    if not IsKeyValid(key) then
        if onFail then onFail("卡密无效") end
        return false
    end
    
    if IsKeyUsed(key) then
        if onFail then onFail("卡密已被使用") end
        return false
    end
    
    MarkKeyUsed(key)
    if onSuccess then onSuccess() end
    return true
end

-- ============================================================
-- 高级UI
-- ============================================================
local function CreateKeyUI(onVerified)
    local oldGui = CoreGui:FindFirstChild("wdfexKeySystem")
    if oldGui then oldGui:Destroy() end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "wdfexKeySystem"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = CoreGui
    
    -- ===== 主窗口（毛玻璃效果） =====
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 440, 0, 340)
    mainFrame.Position = UDim2.new(0.5, -220, 0.5, -170)
    mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 30)
    mainFrame.BackgroundTransparency = 0.12
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    
    -- 主窗口圆角
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 16)
    mainCorner.Parent = mainFrame
    
    -- 玻璃边框（渐变光晕）
    local borderFrame = Instance.new("Frame")
    borderFrame.Size = UDim2.new(1, 4, 1, 4)
    borderFrame.Position = UDim2.new(0, -2, 0, -2)
    borderFrame.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
    borderFrame.BackgroundTransparency = 0.7
    borderFrame.BorderSizePixel = 0
    borderFrame.ClipsDescendants = true
    borderFrame.ZIndex = 0
    borderFrame.Parent = mainFrame
    
    local borderCorner = Instance.new("UICorner")
    borderCorner.CornerRadius = UDim.new(0, 18)
    borderCorner.Parent = borderFrame
    
    -- 内发光光晕
    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(1.4, 0, 1.4, 0)
    glow.Position = UDim2.new(-0.2, 0, -0.2, 0)
    glow.BackgroundColor3 = Color3.fromRGB(80, 140, 255)
    glow.BackgroundTransparency = 0.92
    glow.BorderSizePixel = 0
    glow.ZIndex = 0
    glow.Parent = mainFrame
    
    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(1, 0)
    glowCorner.Parent = glow
    
    -- ===== 顶部装饰条 =====
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(0.8, 0, 0, 3)
    topBar.Position = UDim2.new(0.1, 0, 0, 0)
    topBar.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
    topBar.BackgroundTransparency = 0.3
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(1, 0)
    topCorner.Parent = topBar
    
    -- ===== Logo区域 =====
    local logoContainer = Instance.new("Frame")
    logoContainer.Size = UDim2.new(0, 56, 0, 56)
    logoContainer.Position = UDim2.new(0.5, -28, 0, 24)
    logoContainer.BackgroundColor3 = Color3.fromRGB(40, 80, 180)
    logoContainer.BackgroundTransparency = 0.3
    logoContainer.BorderSizePixel = 0
    logoContainer.Parent = mainFrame
    
    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(1, 0)
    logoCorner.Parent = logoContainer
    
    local logoText = Instance.new("TextLabel")
    logoText.Size = UDim2.new(1, 0, 1, 0)
    logoText.BackgroundTransparency = 1
    logoText.Text = "W"
    logoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    logoText.TextSize = 28
    logoText.Font = Enum.Font.GothamBold
    logoText.Parent = logoContainer
    
    -- ===== 标题 =====
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 28)
    title.Position = UDim2.new(0, 0, 0, 88)
    title.BackgroundTransparency = 1
    title.Text = "wdfex 卡密验证"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 22
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.Parent = mainFrame
    
    -- ===== 副标题 =====
    local subTitle = Instance.new("TextLabel")
    subTitle.Size = UDim2.new(1, 0, 0, 20)
    subTitle.Position = UDim2.new(0, 0, 0, 120)
    subTitle.BackgroundTransparency = 1
    subTitle.Text = "请输入卡密"
    subTitle.TextColor3 = Color3.fromRGB(160, 170, 200)
    subTitle.TextSize = 14
    subTitle.Font = Enum.Font.Gotham
    subTitle.TextXAlignment = Enum.TextXAlignment.Center
    subTitle.Parent = mainFrame
    
    -- ===== 分割线 =====
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0.8, 0, 0, 1)
    line.Position = UDim2.new(0.1, 0, 0, 148)
    line.BackgroundColor3 = Color3.fromRGB(80, 120, 220)
    line.BackgroundTransparency = 0.6
    line.BorderSizePixel = 0
    line.Parent = mainFrame
    
    -- ===== 输入框 =====
    local inputBg = Instance.new("Frame")
    inputBg.Size = UDim2.new(0.8, 0, 0, 50)
    inputBg.Position = UDim2.new(0.1, 0, 0, 165)
    inputBg.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
    inputBg.BackgroundTransparency = 0.4
    inputBg.BorderSizePixel = 1.5
    inputBg.BorderColor3 = Color3.fromRGB(60, 80, 140)
    inputBg.ClipsDescendants = true
    inputBg.Parent = mainFrame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 10)
    inputCorner.Parent = inputBg
    
    -- 输入框前缀
    local prefix = Instance.new("TextLabel")
    prefix.Size = UDim2.new(0, 60, 1, 0)
    prefix.Position = UDim2.new(0, 12, 0, 0)
    prefix.BackgroundTransparency = 1
    prefix.Text = "wdfex-"
    prefix.TextColor3 = Color3.fromRGB(120, 160, 255)
    prefix.TextSize = 17
    prefix.Font = Enum.Font.GothamBold
    prefix.TextXAlignment = Enum.TextXAlignment.Left
    prefix.ParentLabel = inputBg
    
    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(1, -80, 1, 0)
    keyInput.Position = UDim2.new(0, 72, 0, 0)
    keyInput.BackgroundTransparency = 1
    keyInput.PlaceholderText = "XXXX-XXXX"
    keyInput.PlaceholderColor3 = Color3.fromRGB(120, 130, 170)
    keyInput.Text = ""
    keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyInput.TextSize = 17
    keyInput.Font = Enum.Font.Gotham
    keyInput.ClearTextOnFocus = false
    keyInput.Parent = inputBg
    
    -- ===== 状态提示 =====
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0.8, 0, 0, 22)
    statusLabel.Position = UDim2.new(0.1, 0, 0, 222)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    status.TextSize = 13
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center
    statusLabel.Parent = mainFrame
    
    -- ===== 验证按钮 =====
    local verifyBtn = Instance.new("TextButton")
    verifyBtn.Size = UDim2.new(0.4, 0, 0, 48)
    verifyBtn.Position = UDim2.new(0.3, 0, 0, 255)
    verifyBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
    verifyBtn.BackgroundTransparency = 0.2
    verifyBtn.BorderSizePixel = 1.5
    verifyBtn.BorderColor3 = Color3.fromRGB(80, 160, 255)
    verifyBtn.Text = "验 证"
    verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    verifyBtn.TextSize = 17
    verifyBtn.Font = Enum.Font.GothamBold
    verifyBtn.Parent = mainFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = verifyBtn
    
    -- 按钮光效
    local btnGlow = Instance.new("Frame")
    btnGlow.Size = UDim2.new(1.2, 0, 1.6, 0)
    btnGlow.Position = UDim2.new(-0.1, 0, -0.3, 0)
    btnGlow.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
    btnGlow.BackgroundTransparency = 0.9
    btnGlow.BorderSizePixel = 0
    btnGlow.ZIndex = 0
    btnGlow.Parent = verifyBtn
    
    local btnGlowCorner = Instance.new("UICorner")
    btnGlowCorner.CornerRadius = UDim.new(1, 0)
    btnGlowCorner.Parent = btnGlow
    
    -- ===== 底部提示 =====
    local tip = Instance.new("TextLabel")
    tip.Size = UDim2.new(1, 0, 0, 18)
    tip.Position = UDim2.new(0, 0, 1, -24)
    tip.BackgroundTransparency = 1
    tip.Text = "格式：wdfex-XXXX-XXXX  ·  字母数字不限"
    tip.TextColor3 = Color3.fromRGB(100, 110, 150)
    tip.TextSize = 11
    tip.Font = Enum.Font.Gotham
    tip.TextXAlignment = Enum.TextXAlignment.Center
    tip.Parent = mainFrame
    
    -- ===== 关闭按钮 =====
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -40, 0, 12)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(150, 160, 200)
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.Parent = mainFrame
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- 悬停效果
    closeBtn.MouseEnter:Connect(function()
        closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    end)
    closeBtn.MouseLeave:Connect(function()
        closeBtn.TextColor3 = Color3.fromRGB(150, 160, 200)
    end)
    
    -- ===== 按钮悬停动画 =====
    verifyBtn.MouseEnter:Connect(function()
        TweenService:Create(verifyBtn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.05
        }):Play()
        TweenService:Create(verifyBtn, TweenInfo.new(0.2), {
            BorderColor3 = Color3.fromRGB(120, 200, 255)
        }):Play()
    end)
    verifyBtn.MouseLeave:Connect(function()
        TweenService:Create(verifyBtn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.2
        }):Play()
        TweenService:Create(verifyBtn, TweenInfo.new(0.2), {
            BorderColor3 = Color3.fromRGB(80, 160, 255)
        }):Play()
    end)
    
    -- ===== 输入框聚焦动画 =====
    keyInput.Focused:Connect(function()
        TweenService:Create(inputBg, TweenInfo.new(0.2), {
            BorderColor3 = Color3.fromRGB(80, 160, 255),
            BackgroundTransparency = 0.2
        }):Play()
    end)
    keyInput.FocusLost:Connect(function()
        TweenService:Create(inputBg, TweenInfo.new(0.2), {
            BorderColor3 = Color3.fromRGB(60, 80, 140),
            BackgroundTransparency = 0.4
        }):Play()
    end)
    
    -- ===== 验证逻辑 =====
    local function doVerify()
        local key = keyInput.Text
        if key ~= "" and not string.find(key:lower(), "^wdfex%-") then
            key = "wdfex-" .. key
        end
        
        statusLabel.Text = "验证中..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
        
        ValidateKey(key,
            function()
                statusLabel.Text = "✓ 验证成功"
                statusLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
                TweenService:Create(verifyBtn, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(0, 200, 100)
                }):Play()
                TweenService:Create(verifyBtn, TweenInfo.new(0.3), {
                    BorderColor3 = Color3.fromRGB(0, 220, 120)
                }):Play()
                
                task.wait(0.6)
                screenGui:Destroy()
                if onVerified then onVerified() end
            end,
            function(errMsg)
                statusLabel.Text = "✗ " .. errMsg
                statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
                TweenService:Create(inputBg, TweenInfo.new(0.15), {
                    BorderColor3 = Color3.fromRGB(255, 60, 60)
                }):Play()
                task.wait(0.25)
                TweenService:Create(inputBg, TweenInfo.new(0.15), {
                    BorderColor3 = Color3.fromRGB(60, 80, 140)
                }):Play()
            end
        )
    end
    
    verifyBtn.MouseButton1Click:Connect(doVerify)
    
    keyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then doVerify() end
    end)
    
    -- ===== 拖动 =====
    local dragging = false
    local dragStart, startPos
    local dragHandle = Instance.new("Frame")
    dragHandle.Size = UDim2.new(1, 0, 0, 100)
    dragHandle.BackgroundTransparency = 1
    dragHandle.Parent = mainFrame
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- ===== 入场动画 =====
    mainFrame.BackgroundTransparency = 1
    mainFrame.Size = UDim2.new(0, 400, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    
    TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.12,
        Size = UDim2.new(0, 440, 0, 340),
        Position = UDim2.new(0.5, -220, 0.5, -170)
    }):Play()
end

-- ============================================================
-- 导出
-- ============================================================
local wdfex = {
    Verify = function(onVerified)
        CreateKeyUI(onVerified)
    end,
    CheckKey = function(key)
        if not key or key == "" then
            return false, "请输入卡密"
        end
        if not IsKeyFormatValid(key) then
            return false, "卡密格式错误"
        end
        if not IsKeyValid(key) then
            return false, "卡密无效"
        end
        if IsKeyUsed(key) then
            return false, "卡密已被使用"
        end
        return true, "验证成功"
    end,
    UseKey = function(key)
        if IsKeyValid(key) and not IsKeyUsed(key) then
            MarkKeyUsed(key)
            return true
        end
        return false
    end,
    GetUsedKeys = GetUsedKeys,
    ResetAllKeys = function()
        SaveUsedKeys({})
    end,
}

wdfex.Verify(function()
    print("✅ 验证成功")
end)

return wdfex