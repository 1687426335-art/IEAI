-- ============================================================
-- wdfex 卡密验证系统（黑白脚本UI样式）
-- 功能：设备UID检测、卡密绑定、时间倒计时、数据持久化
-- ============================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local localPlayer = Players.LocalPlayer

-- ===== 获取设备UID =====
local function GetDeviceUID()
    local success, result = pcall(function()
        return RbxAnalyticsService:GetClientId()
    end)
    if success and result then
        return result
    end
    return localPlayer.UserId .. "_" .. tostring(game:GetService("Workspace").DistributedGameTime)
end

local DEVICE_UID = GetDeviceUID()

-- ===== 存储管理 =====
local function GetStorage()
    if not getgenv()._wdfex_keys_data then
        getgenv()._wdfex_keys_data = {}
    end
    return getgenv()._wdfex_keys_data
end

local function SaveKeyData(key, data)
    local storage = GetStorage()
    storage[key] = data
end

local function GetKeyData(key)
    local storage = GetStorage()
    return storage[key]
end

-- ===== 卡密列表（60个预设卡密） =====
local PRESET_KEYS = {
    -- 天卡（15个）
    { key = "wdfex-a1b2-c3d4", type = "day" },
    { key = "wdfex-d5e6-f7g8", type = "day" },
    { key = "wdfex-h9i0-j1k2", type = "day" },
    { key = "wdfex-l3m4-n5o6", type = "day" },
    { key = "wdfex-p7q8-r9s0", type = "day" },
    { key = "wdfex-t1u2-v3w4", type = "day" },
    { key = "wdfex-x5y6-z7a8", type = "day" },
    { key = "wdfex-b9c0-d1e2", type = "day" },
    { key = "wdfex-f3g4-h5i6", type = "day" },
    { key = "wdfex-j7k8-l9m0", type = "day" },
    { key = "wdfex-n1o2-p3q4", type = "day" },
    { key = "wdfex-r5s6-t7u8", type = "day" },
    { key = "wdfex-v9w0-x1y2", type = "day" },
    { key = "wdfex-z3a4-b5c6", type = "day" },
    { key = "wdfex-d7e8-f9g0", type = "day" },
    -- 周卡（15个）
    { key = "wdfex-h1i2-j3k4", type = "week" },
    { key = "wdfex-l5m6-n7o8", type = "week" },
    { key = "wdfex-p9q0-r1s2", type = "week" },
    { key = "wdfex-t3u4-v5w6", type = "week" },
    { key = "wdfex-x7y8-z9a0", type = "week" },
    { key = "wdfex-b1c2-d3e4", type = "week" },
    { key = "wdfex-f5g6-h7i8", type = "week" },
    { key = "wdfex-j9k0-l1m2", type = "week" },
    { key = "wdfex-n3o4-p5q6", type = "week" },
    { key = "wdfex-r7s8-t9u0", type = "week" },
    { key = "wdfex-v1w2-x3y4", type = "week" },
    { key = "wdfex-z5a6-b7c8", type = "week" },
    { key = "wdfex-d9e0-f1g2", type = "week" },
    { key = "wdfex-h3i4-j5k6", type = "week" },
    { key = "wdfex-l7m8-n9o0", type = "week" },
    -- 月卡（15个）
    { key = "wdfex-p1q2-r3s4", type = "month" },
    { key = "wdfex-t5u6-v7w8", type = "month" },
    { key = "wdfex-x9y0-z1a2", type = "month" },
    { key = "wdfex-b3c4-d5e6", type = "month" },
    { key = "wdfex-f7g8-h9i0", type = "month" },
    { key = "wdfex-j1k2-l3m4", type = "month" },
    { key = "wdfex-n5o6-p7q8", type = "month" },
    { key = "wdfex-r9s0-t1u2", type = "month" },
    { key = "wdfex-v3w4-x5y6", type = "month" },
    { key = "wdfex-z7a8-b9c0", type = "month" },
    { key = "wdfex-d1e2-f3g4", type = "month" },
    { key = "wdfex-h5i6-j7k8", type = "month" },
    { key = "wdfex-l9m0-n1o2", type = "month" },
    { key = "wdfex-p3q4-r5s6", type = "month" },
    { key = "wdfex-t7u8-v9w0", type = "month" },
    -- 永久卡（15个）
    { key = "wdfex-x1y2-z3a4", type = "forever" },
    { key = "wdfex-b5c6-d7e8", type = "forever" },
    { key = "wdfex-f9g0-h1i2", type = "forever" },
    { key = "wdfex-j3k4-l5m6", type = "forever" },
    { key = "wdfex-n7o8-p9q0", type = "forever" },
    { key = "wdfex-r1s2-t3u4", type = "forever" },
    { key = "wdfex-v5w6-x7y8", type = "forever" },
    { key = "wdfex-z9a0-b1c2", type = "forever" },
    { key = "wdfex-d3e4-f5g6", type = "forever" },
    { key = "wdfex-h7i8-j9k0", type = "forever" },
    { key = "wdfex-l1m2-n3o4", type = "forever" },
    { key = "wdfex-p5q6-r7s8", type = "forever" },
    { key = "wdfex-t9u0-v1w2", type = "forever" },
    { key = "wdfex-x3y4-z5a6", type = "forever" },
    { key = "wdfex-b7c8-d9e0", type = "forever" },
}

-- 卡密类型配置
local KEY_TYPES = {
    day = { label = "天卡", hours = 24, expiryText = "24小时" },
    week = { label = "周卡", hours = 168, expiryText = "7天" },
    month = { label = "月卡", hours = 720, expiryText = "30天" },
    forever = { label = "永久卡", hours = nil, expiryText = "永久（2099-07-08）", foreverDate = os.time({ year = 2099, month = 7, day = 8 }) },
}

-- ===== 检查卡密是否有效 =====
local function IsKeyValid(key)
    key = key:lower()
    for _, data in ipairs(PRESET_KEYS) do
        if data.key:lower() == key then
            return true, data.type
        end
    end
    return false, nil
end

-- ===== 检查卡密格式 =====
local function IsKeyFormatValid(key)
    if type(key) ~= "string" then return false end
    key = key:lower()
    local pattern = "^wdfex%-[%w][%w][%w][%w]%-[%w][%w][%w][%w]$"
    return string.match(key, pattern) ~= nil
end

-- ===== 获取卡密剩余时间 =====
local function GetKeyRemainingTime(key)
    key = key:lower()
    local data = GetKeyData(key)
    if not data then return nil, "未激活" end
    
    local keyType = data.type
    local activatedAt = data.activatedAt
    local currentTime = os.time()
    local elapsed = currentTime - activatedAt
    
    if keyType == "forever" then
        local foreverDate = KEY_TYPES.forever.foreverDate
        if currentTime >= foreverDate then
            return 0, "已过期"
        end
        local remaining = foreverDate - currentTime
        local days = math.floor(remaining / 86400)
        local hours = math.floor((remaining % 86400) / 3600)
        return remaining, string.format("永久卡（剩余 %d天 %d小时）", days, hours)
    end
    
    local totalHours = KEY_TYPES[keyType].hours
    local totalSeconds = totalHours * 3600
    local remaining = totalSeconds - elapsed
    
    if remaining <= 0 then
        return 0, "已过期"
    end
    
    local days = math.floor(remaining / 86400)
    local hours = math.floor((remaining % 86400) / 3600)
    local minutes = math.floor((remaining % 3600) / 60)
    
    if days > 0 then
        return remaining, string.format("%s（剩余 %d天 %d小时）", KEY_TYPES[keyType].label, days, hours)
    elseif hours > 0 then
        return remaining, string.format("%s（剩余 %d小时 %d分钟）", KEY_TYPES[keyType].label, hours, minutes)
    else
        return remaining, string.format("%s（剩余 %d分钟）", KEY_TYPES[keyType].label, minutes)
    end
end

-- ===== 验证卡密 =====
local function ValidateKey(key)
    key = key:lower()
    
    if not IsKeyFormatValid(key) then
        return false, "卡密格式错误，正确格式：wdfex-XXXX-XXXX"
    end
    
    local valid, keyType = IsKeyValid(key)
    if not valid then
        return false, "卡密无效"
    end
    
    local existingData = GetKeyData(key)
    if existingData then
        if existingData.deviceId ~= DEVICE_UID then
            return false, "该卡密已被其他设备使用"
        end
        local remaining, status = GetKeyRemainingTime(key)
        if remaining == 0 then
            return false, "卡密已过期"
        end
        return true, "卡密验证成功（续期）", keyType, existingData
    end
    
    local newData = {
        deviceId = DEVICE_UID,
        activatedAt = os.time(),
        type = keyType,
    }
    SaveKeyData(key, newData)
    
    return true, "卡密验证成功", keyType, newData
end

-- ============================================================
-- 创建UI（黑白脚本样式）
-- ============================================================

-- ========== 启动音效 ==========
local StartSound = Instance.new("Sound")
StartSound.Parent = SoundService
StartSound.SoundId = "rbxassetid://148729028"
StartSound.Volume = 0.5
StartSound:Play()

-- ========== 全局变量 ==========
local attempts = 0
local maxAttempts = 3
local copyCooldown = false
local btnHovering = false
local isCopyHovering = false
local isDragging = false
local dragStart, frameStart
local isMobile = UserInputService.TouchEnabled
local isMouse = UserInputService.MouseEnabled
local keyVerified = false

-- ========== 创建UI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "wdfexKeyUI"
ScreenGui.Parent = localPlayer.PlayerGui
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 100

-- 暗化背景
local BackgroundOverlay = Instance.new("Frame")
BackgroundOverlay.Parent = ScreenGui
BackgroundOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BackgroundOverlay.BackgroundTransparency = 0.7
BackgroundOverlay.Size = UDim2.new(1, 0, 1, 0)
BackgroundOverlay.ZIndex = 1

-- ========== 主窗口 ==========
local MainWin = Instance.new("Frame")
MainWin.Parent = ScreenGui
MainWin.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainWin.Position = UDim2.new(0.5, -150, 0.5, -130)
MainWin.Size = UDim2.new(0, 300, 0, 280)
MainWin.ZIndex = 2
MainWin.Active = true
MainWin.Selectable = true

local WinCorner = Instance.new("UICorner")
WinCorner.Parent = MainWin
WinCorner.CornerRadius = UDim.new(0, 12)

local WinGlow = Instance.new("UIStroke")
WinGlow.Parent = MainWin
WinGlow.Color = Color3.fromRGB(90, 90, 90)
WinGlow.Thickness = 1.5
WinGlow.Transparency = 0.7

-- ========== 标题栏 ==========
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainWin
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.ZIndex = 3
TitleBar.Active = true
TitleBar.Selectable = true

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.Parent = TitleBar
TitleBarCorner.CornerRadius = UDim.new(0, 12, 0, 0)

-- 状态指示灯
local StatusLight = Instance.new("Frame")
StatusLight.Parent = TitleBar
StatusLight.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
StatusLight.Position = UDim2.new(0, 8, 0.5, -4)
StatusLight.Size = UDim2.new(0, 8, 0, 8)
StatusLight.ZIndex = 4

local StatusCorner = Instance.new("UICorner")
StatusCorner.Parent = StatusLight
StatusCorner.CornerRadius = UDim.new(1, 0)

local StatusText = Instance.new("TextLabel")
StatusText.Parent = TitleBar
StatusText.BackgroundTransparency = 1
StatusText.Position = UDim2.new(0, 20, 0.5, -6)
StatusText.Size = UDim2.new(0, 50, 0, 10)
StatusText.Font = Enum.Font.GothamMedium
StatusText.Text = "未验证"
StatusText.TextColor3 = Color3.fromRGB(255, 150, 150)
StatusText.TextSize = 9
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.ZIndex = 4

-- 标题装饰线
local TitleAccent = Instance.new("Frame")
TitleAccent.Parent = TitleBar
TitleAccent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TitleAccent.Position = UDim2.new(0, 0, 1, -1)
TitleAccent.Size = UDim2.new(1, 0, 0, 1)
TitleAccent.ZIndex = 4

-- 标题文字
local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Font = Enum.Font.GothamBlack
Title.Text = "wdfex - 卡密验证"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.TextYAlignment = Enum.TextYAlignment.Center
Title.ZIndex = 4

-- 副标题
local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = TitleBar
SubTitle.BackgroundTransparency = 1
SubTitle.Position = UDim2.new(0, 0, 0, 25)
SubTitle.Size = UDim2.new(1, 0, 0, 12)
SubTitle.Font = Enum.Font.Gotham
SubTitle.Text = "卡密验证系统 v1.0"
SubTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
SubTitle.TextSize = 10
SubTitle.TextXAlignment = Enum.TextXAlignment.Center
SubTitle.ZIndex = 4

-- 设备UID显示（左上角小字）
local UIDLabel = Instance.new("TextLabel")
UIDLabel.Parent = MainWin
UIDLabel.BackgroundTransparency = 1
UIDLabel.Position = UDim2.new(0, 10, 0, 45)
UIDLabel.Size = UDim2.new(1, 0, 0, 14)
UIDLabel.Font = Enum.Font.Gotham
UIDLabel.Text = "设备UID: " .. string.sub(DEVICE_UID, 1, 20) .. "..."
UIDLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
UIDLabel.TextSize = 9
UIDLabel.TextXAlignment = Enum.TextXAlignment.Left
UIDLabel.ZIndex = 3

-- ========== 群聊信息卡片 ==========
local GroupCard = Instance.new("Frame")
GroupCard.Parent = MainWin
GroupCard.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
GroupCard.Position = UDim2.new(0.5, -135, 0, 65)
GroupCard.Size = UDim2.new(0, 270, 0, 50)
GroupCard.ZIndex = 3

local GroupCorner = Instance.new("UICorner")
GroupCorner.Parent = GroupCard
GroupCorner.CornerRadius = UDim.new(0, 8)

local GroupGlow = Instance.new("UIStroke")
GroupGlow.Parent = GroupCard
GroupGlow.Color = Color3.fromRGB(80, 120, 200)
GroupGlow.Thickness = 1.5
GroupGlow.Transparency = 0.3

local GroupIcon = Instance.new("TextLabel")
GroupIcon.Parent = GroupCard
GroupIcon.BackgroundTransparency = 1
GroupIcon.Position = UDim2.new(0, 12, 0.5, -12)
GroupIcon.Size = UDim2.new(0, 24, 0, 24)
GroupIcon.Font = Enum.Font.GothamBold
GroupIcon.Text = "👥"
GroupIcon.TextColor3 = Color3.fromRGB(150, 180, 220)
GroupIcon.TextSize = 18
GroupIcon.TextYAlignment = Enum.TextYAlignment.Center
GroupIcon.ZIndex = 4

local GroupLabel = Instance.new("TextLabel")
GroupLabel.Parent = GroupCard
GroupLabel.BackgroundTransparency = 1
GroupLabel.Position = UDim2.new(0, 45, 0, 8)
GroupLabel.Size = UDim2.new(0, 120, 0, 16)
GroupLabel.Font = Enum.Font.GothamBold
GroupLabel.Text = "点击复制群号"
GroupLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
GroupLabel.TextSize = 11
GroupLabel.TextXAlignment = Enum.TextXAlignment.Left
GroupLabel.ZIndex = 4

local GroupNumber = Instance.new("TextLabel")
GroupNumber.Parent = GroupCard
GroupNumber.BackgroundTransparency = 1
GroupNumber.Position = UDim2.new(0, 45, 0, 24)
GroupNumber.Size = UDim2.new(0, 120, 0, 20)
GroupNumber.Font = Enum.Font.GothamBlack
GroupNumber.Text = "1012033070"
GroupNumber.TextColor3 = Color3.fromRGB(255, 255, 255)
GroupNumber.TextSize = 18
GroupNumber.TextXAlignment = Enum.TextXAlignment.Left
GroupNumber.ZIndex = 4

local CopyIcon = Instance.new("TextLabel")
CopyIcon.Parent = GroupCard
CopyIcon.BackgroundTransparency = 1
CopyIcon.Position = UDim2.new(1, -35, 0.5, -12)
CopyIcon.Size = UDim2.new(0, 24, 0, 24)
CopyIcon.Font = Enum.Font.GothamBold
CopyIcon.Text = "📋"
CopyIcon.TextColor3 = Color3.fromRGB(150, 180, 220)
CopyIcon.TextSize = 16
CopyIcon.TextYAlignment = Enum.TextYAlignment.Center
CopyIcon.ZIndex = 4

local CopyButton = Instance.new("TextButton")
CopyButton.Parent = GroupCard
CopyButton.BackgroundTransparency = 1
CopyButton.Size = UDim2.new(1, 0, 1, 0)
CopyButton.Text = ""
CopyButton.ZIndex = 5
CopyButton.AutoButtonColor = false

local CopySuccess = Instance.new("Frame")
CopySuccess.Parent = MainWin
CopySuccess.BackgroundColor3 = Color3.fromRGB(40, 200, 80)
CopySuccess.Position = UDim2.new(0.5, -65, 0, 75)
CopySuccess.Size = UDim2.new(0, 130, 0, 28)
CopySuccess.ZIndex = 10
CopySuccess.Visible = false

local CopySuccessCorner = Instance.new("UICorner")
CopySuccessCorner.Parent = CopySuccess
CopySuccessCorner.CornerRadius = UDim.new(0, 6)

local CopySuccessStroke = Instance.new("UIStroke")
CopySuccessStroke.Parent = CopySuccess
CopySuccessStroke.Color = Color3.fromRGB(255, 255, 255)
CopySuccessStroke.Thickness = 1

local CopySuccessText = Instance.new("TextLabel")
CopySuccessText.Parent = CopySuccess
CopySuccessText.BackgroundTransparency = 1
CopySuccessText.Size = UDim2.new(1, 0, 1, 0)
CopySuccessText.Font = Enum.Font.GothamBold
CopySuccessText.Text = "✓ 已复制"
CopySuccessText.TextColor3 = Color3.fromRGB(255, 255, 255)
CopySuccessText.TextSize = 10
CopySuccessText.TextXAlignment = Enum.TextXAlignment.Center
CopySuccessText.TextYAlignment = Enum.TextYAlignment.Center

-- ========== 输入框 ==========
local InputContainer = Instance.new("Frame")
InputContainer.Parent = MainWin
InputContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
InputContainer.Position = UDim2.new(0.5, -120, 0, 125)
InputContainer.Size = UDim2.new(0, 240, 0, 36)
InputContainer.ZIndex = 3

local InputContainerCorner = Instance.new("UICorner")
InputContainerCorner.Parent = InputContainer
InputContainerCorner.CornerRadius = UDim.new(0, 8)

local InputContainerStroke = Instance.new("UIStroke")
InputContainerStroke.Parent = InputContainer
InputContainerStroke.Color = Color3.fromRGB(50, 50, 50)
InputContainerStroke.Thickness = 1

local Input = Instance.new("TextBox")
Input.Parent = InputContainer
Input.BackgroundTransparency = 1
Input.Position = UDim2.new(0, 12, 0, 0)
Input.Size = UDim2.new(1, -24, 1, 0)
Input.Font = Enum.Font.Gotham
Input.Text = ""
Input.TextColor3 = Color3.fromRGB(255, 255, 255)
Input.TextSize = 13
Input.PlaceholderText = "请输入卡密 wdfex-XXXX-XXXX"
Input.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
Input.ClearTextOnFocus = false
Input.ZIndex = 4

local InputIcon = Instance.new("TextLabel")
InputIcon.Parent = InputContainer
InputIcon.BackgroundTransparency = 1
InputIcon.Position = UDim2.new(1, -30, 0.5, -9)
InputIcon.Size = UDim2.new(0, 18, 0, 18)
InputIcon.Font = Enum.Font.GothamBold
InputIcon.Text = "🔑"
InputIcon.TextColor3 = Color3.fromRGB(150, 150, 150)
InputIcon.TextSize = 12
InputIcon.TextYAlignment = Enum.TextYAlignment.Center
InputIcon.ZIndex = 4

local ClearInputButton = Instance.new("TextButton")
ClearInputButton.Parent = InputContainer
ClearInputButton.BackgroundTransparency = 1
ClearInputButton.Position = UDim2.new(1, -50, 0.5, -8)
ClearInputButton.Size = UDim2.new(0, 20, 0, 20)
ClearInputButton.Font = Enum.Font.GothamBold
ClearInputButton.Text = "×"
ClearInputButton.TextColor3 = Color3.fromRGB(120, 120, 120)
ClearInputButton.TextSize = 12
ClearInputButton.Visible = false
ClearInputButton.ZIndex = 4

-- ========== 验证按钮 ==========
local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Parent = MainWin
VerifyBtn.Position = UDim2.new(0.5, -95, 0, 172)
VerifyBtn.Size = UDim2.new(0, 190, 0, 36)
VerifyBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.Text = "验证卡密"
VerifyBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
VerifyBtn.TextSize = 14
VerifyBtn.TextXAlignment = Enum.TextXAlignment.Center
VerifyBtn.BorderSizePixel = 0
VerifyBtn.AutoButtonColor = false
VerifyBtn.ZIndex = 3

local VerifyBtnCorner = Instance.new("UICorner")
VerifyBtnCorner.Parent = VerifyBtn
VerifyBtnCorner.CornerRadius = UDim.new(0, 8)

local VerifyBtnStroke = Instance.new("UIStroke")
VerifyBtnStroke.Parent = VerifyBtn
VerifyBtnStroke.Color = Color3.fromRGB(50, 50, 50)
VerifyBtnStroke.Thickness = 1.5

-- ========== 消息显示区 ==========
local Msg = Instance.new("TextLabel")
Msg.Parent = MainWin
Msg.BackgroundTransparency = 1
Msg.Position = UDim2.new(0, 0, 1, -45)
Msg.Size = UDim2.new(1, 0, 0, 16)
Msg.Font = Enum.Font.Gotham
Msg.Text = ""
Msg.TextColor3 = Color3.fromRGB(150, 150, 150)
Msg.TextSize = 10
Msg.TextXAlignment = Enum.TextXAlignment.Center
Msg.Visible = false
Msg.ZIndex = 3

-- 信息显示区（验证成功后显示卡密信息）
local InfoFrame = Instance.new("Frame")
InfoFrame.Parent = MainWin
InfoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
InfoFrame.Position = UDim2.new(0.5, -135, 0, 215)
InfoFrame.Size = UDim2.new(0, 270, 0, 40)
InfoFrame.Visible = false
InfoFrame.ZIndex = 3

local InfoCorner = Instance.new("UICorner")
InfoCorner.Parent = InfoFrame
InfoCorner.CornerRadius = UDim.new(0, 6)

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Parent = InfoFrame
InfoLabel.BackgroundTransparency = 1
InfoLabel.Position = UDim2.new(0, 10, 0, 0)
InfoLabel.Size = UDim2.new(1, -20, 1, 0)
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.Text = ""
InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
InfoLabel.TextSize = 11
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.TextYAlignment = Enum.TextYAlignment.Center
InfoLabel.ZIndex = 4

-- ========== 剩余尝试次数 ==========
local AttemptsDisplay = Instance.new("TextLabel")
AttemptsDisplay.Parent = MainWin
AttemptsDisplay.BackgroundTransparency = 1
AttemptsDisplay.Position = UDim2.new(0, 0, 1, -20)
AttemptsDisplay.Size = UDim2.new(1, 0, 0, 14)
AttemptsDisplay.Font = Enum.Font.GothamMedium
AttemptsDisplay.Text = string.format("剩余尝试次数: %d/%d", maxAttempts - attempts, maxAttempts)
AttemptsDisplay.TextColor3 = Color3.fromRGB(180, 180, 180)
AttemptsDisplay.TextSize = 10
AttemptsDisplay.TextXAlignment = Enum.TextXAlignment.Center
AttemptsDisplay.ZIndex = 3

-- ========== 关闭按钮 ==========
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainWin
CloseBtn.Position = UDim2.new(1, -35, 0, 8)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.TextSize = 18
CloseBtn.TextXAlignment = Enum.TextXAlignment.Center
CloseBtn.BorderSizePixel = 0
CloseBtn.AutoButtonColor = false
CloseBtn.ZIndex = 10

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.Parent = CloseBtn
CloseBtnCorner.CornerRadius = UDim.new(0, 6)

-- ========== 触摸区域 ==========
local TouchDragArea = Instance.new("TextButton")
TouchDragArea.Parent = MainWin
TouchDragArea.BackgroundTransparency = 1
TouchDragArea.Size = UDim2.new(1, 0, 0, 60)
TouchDragArea.Text = ""
TouchDragArea.ZIndex = 5
TouchDragArea.AutoButtonColor = false
TouchDragArea.Visible = isMobile

-- ========== 入场动画 ==========
MainWin.Size = UDim2.new(0, 0, 0, 0)
MainWin.Position = UDim2.new(0.5, 0, 0.5, 0)
MainWin.BackgroundTransparency = 1

local entranceTween = TweenService:Create(MainWin, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 300, 0, 280),
    Position = UDim2.new(0.5, -150, 0.5, -140),
    BackgroundTransparency = 0
})
entranceTween:Play()

-- ========== 功能模块 ==========

local function updateAttemptsDisplay()
    AttemptsDisplay.Text = string.format("剩余尝试次数: %d/%d", maxAttempts - attempts, maxAttempts)
end

local function playSound(soundId, volume)
    local sound = Instance.new("Sound")
    sound.Parent = SoundService
    sound.SoundId = soundId
    sound.Volume = volume or 0.5
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 1)
end

local function showMessage(text, color, duration)
    Msg.Text = text
    Msg.TextColor3 = color
    Msg.Visible = true
    if duration then
        task.wait(duration)
        Msg.Visible = false
    end
end

local function updateStatus(color, text)
    StatusLight.BackgroundColor3 = color
    StatusText.Text = text
    StatusText.TextColor3 = color
end

-- ========== 输入框交互 ==========
Input.Focused:Connect(function()
    InputContainerStroke.Color = Color3.fromRGB(255, 255, 255)
    TweenService:Create(InputContainer, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    }):Play()
    TweenService:Create(InputIcon, TweenInfo.new(0.2), {
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
    if #Input.Text > 0 then
        ClearInputButton.Visible = true
    end
end)

Input.FocusLost:Connect(function()
    InputContainerStroke.Color = Color3.fromRGB(50, 50, 50)
    TweenService:Create(InputContainer, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    }):Play()
    TweenService:Create(InputIcon, TweenInfo.new(0.2), {
        TextColor3 = Color3.fromRGB(150, 150, 150)
    }):Play()
    ClearInputButton.Visible = false
end)

Input:GetPropertyChangedSignal("Text"):Connect(function()
    ClearInputButton.Visible = #Input.Text > 0
end)

ClearInputButton.MouseButton1Click:Connect(function()
    Input.Text = ""
    Input:CaptureFocus()
    playSound("rbxassetid://62339698", 0.3)
end)

-- ========== 按钮交互 ==========
VerifyBtn.MouseEnter:Connect(function()
    btnHovering = true
    TweenService:Create(VerifyBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(245, 245, 245)
    }):Play()
    TweenService:Create(VerifyBtnStroke, TweenInfo.new(0.2), {
        Color = Color3.fromRGB(75, 75, 75)
    }):Play()
end)

VerifyBtn.MouseLeave:Connect(function()
    btnHovering = false
    TweenService:Create(VerifyBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
    TweenService:Create(VerifyBtnStroke, TweenInfo.new(0.2), {
        Color = Color3.fromRGB(50, 50, 50)
    }):Play()
end)

-- ========== 复制功能 ==========
CopyButton.MouseEnter:Connect(function()
    isCopyHovering = true
    if not copyCooldown then
        TweenService:Create(GroupCard, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(30, 35, 55),
            Size = UDim2.new(0, 275, 0, 52)
        }):Play()
        TweenService:Create(GroupGlow, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(120, 160, 240),
            Thickness = 2,
            Transparency = 0.2
        }):Play()
        TweenService:Create(GroupIcon, TweenInfo.new(0.2), {
            TextColor3 = Color3.fromRGB(190, 210, 245)
        }):Play()
        TweenService:Create(CopyIcon, TweenInfo.new(0.2), {
            TextColor3 = Color3.fromRGB(190, 210, 245)
        }):Play()
        TweenService:Create(GroupNumber, TweenInfo.new(0.2), {
            TextColor3 = Color3.fromRGB(255, 255, 230)
        }):Play()
    end
end)

CopyButton.MouseLeave:Connect(function()
    isCopyHovering = false
    if not copyCooldown then
        TweenService:Create(GroupCard, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(20, 25, 40),
            Size = UDim2.new(0, 270, 0, 50)
        }):Play()
        TweenService:Create(GroupGlow, TweenInfo.new(0.3), {
            Color = Color3.fromRGB(80, 120, 200),
            Thickness = 1.5,
            Transparency = 0.3
        }):Play()
        TweenService:Create(GroupIcon, TweenInfo.new(0.3), {
            TextColor3 = Color3.fromRGB(150, 180, 220)
        }):Play()
        TweenService:Create(CopyIcon, TweenInfo.new(0.3), {
            TextColor3 = Color3.fromRGB(150, 180, 220)
        }):Play()
        TweenService:Create(GroupNumber, TweenInfo.new(0.3), {
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    end
end)

CopyButton.MouseButton1Click:Connect(function()
    if copyCooldown then return end
    copyCooldown = true
    playSound("rbxassetid://62339698", 0.5)
    
    local groupNumber = "1012033070"
    pcall(function()
        setclipboard(groupNumber)
    end)
    
    CopyIcon.Text = "✓"
    TweenService:Create(CopyIcon, TweenInfo.new(0.2), {
        TextColor3 = Color3.fromRGB(80, 255, 80),
        TextSize = 18
    }):Play()
    TweenService:Create(GroupNumber, TweenInfo.new(0.2), {
        TextColor3 = Color3.fromRGB(80, 255, 80)
    }):Play()
    
    CopySuccess.Visible = true
    CopySuccess.Position = UDim2.new(0.5, -65, 0, 75)
    local successTween = TweenService:Create(CopySuccess, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -65, 0, 70)
    })
    successTween:Play()
    
    task.wait(1.5)
    local hideTween = TweenService:Create(CopySuccess, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, -65, 0, 75)
    })
    hideTween:Play()
    hideTween.Completed:Wait()
    CopySuccess.Visible = false
    
    CopyIcon.Text = "📋"
    TweenService:Create(CopyIcon, TweenInfo.new(0.3), {
        TextColor3 = Color3.fromRGB(150, 180, 220),
        TextSize = 16
    }):Play()
    TweenService:Create(GroupNumber, TweenInfo.new(0.3), {
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
    
    showMessage("✅ 群号已复制到剪贴板", Color3.fromRGB(80, 255, 80), 2)
    task.wait(1)
    copyCooldown = false
end)

-- ========== 拖动功能 ==========
local function startDrag(input)
    if (isMouse and input.UserInputType == Enum.UserInputType.MouseButton1) or
       (isMobile and input.UserInputType == Enum.UserInputType.Touch) then
        isDragging = true
        dragStart = input.Position
        frameStart = MainWin.Position
        TweenService:Create(TitleBar, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        }):Play()
        TweenService:Create(TitleAccent, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(220, 220, 220)
        }):Play()
        showMessage("拖动中...", Color3.fromRGB(200, 200, 200))
    end
end

local function endDrag()
    if isDragging then
        isDragging = false
        TweenService:Create(TitleBar, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        }):Play()
        TweenService:Create(TitleAccent, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        Msg.Visible = false
    end
end

if isMobile then
    TouchDragArea.InputBegan:Connect(startDrag)
else
    TitleBar.InputBegan:Connect(startDrag)
end

UserInputService.InputChanged:Connect(function(input)
    if isDragging then
        local delta = input.Position - dragStart
        local newX = frameStart.X.Offset + delta.X
        local newY = frameStart.Y.Offset + delta.Y
        local screenWidth = workspace.CurrentCamera.ViewportSize.X
        local screenHeight = workspace.CurrentCamera.ViewportSize.Y
        newX = math.clamp(newX, 0, screenWidth - MainWin.Size.X.Offset)
        newY = math.clamp(newY, 0, screenHeight - MainWin.Size.Y.Offset)
        MainWin.Position = UDim2.new(0, newX, 0, newY)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if isDragging and ((isMouse and input.UserInputType == Enum.UserInputType.MouseButton1) or
                      (isMobile and input.UserInputType == Enum.UserInputType.Touch)) then
        endDrag()
    end
end)

-- ========== 关闭功能 ==========
CloseBtn.MouseButton1Click:Connect(function()
    playSound("rbxassetid://62339698", 0.3)
    local exitTween = TweenService:Create(MainWin, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1
    })
    exitTween:Play()
    exitTween.Completed:Wait()
    ScreenGui:Destroy()
    if StartSound then StartSound:Destroy() end
end)

-- ========== 验证功能 ==========
VerifyBtn.MouseButton1Click:Connect(function()
    local key = Input.Text
    
    if #key == 0 then
        showMessage("请输入卡密", Color3.fromRGB(255, 180, 80), 1.5)
        for i = 1, 3 do
            InputContainer.Position = UDim2.new(0.5, -120 + (i % 2 == 1 and 3 or -3), 0, 125)
            task.wait(0.05)
        end
        InputContainer.Position = UDim2.new(0.5, -120, 0, 125)
        return
    end
    
    local success, msg, keyType, data = ValidateKey(key)
    
    if success then
        keyVerified = true
        updateStatus(Color3.fromRGB(80, 255, 80), "已验证")
        showMessage("✓ " .. msg, Color3.fromRGB(80, 255, 80))
        
        -- 显示卡密信息
        InfoFrame.Visible = true
        local remaining, remainingText = GetKeyRemainingTime(key)
        InfoLabel.Text = "卡密类型: " .. KEY_TYPES[keyType].label .. "\n" .. remainingText
        InfoLabel.TextSize = 11
        InfoLabel.TextYAlignment = Enum.TextYAlignment.Top
        
        TweenService:Create(VerifyBtn, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(80, 255, 80),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        TweenService:Create(VerifyBtnStroke, TweenInfo.new(0.3), {
            Color = Color3.fromRGB(80, 255, 80)
        }):Play()
        TweenService:Create(WinGlow, TweenInfo.new(0.3), {
            Color = Color3.fromRGB(80, 255, 80),
            Thickness = 2
        }):Play()
        
        playSound("rbxassetid://62339698", 0.6)
        
        task.wait(1.5)
        
        local exitTween = TweenService:Create(MainWin, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        })
        exitTween:Play()
        exitTween.Completed:Wait()
        
        ScreenGui:Destroy()
        if StartSound then StartSound:Destroy() end
        
        -- ===== 验证通过，加载主脚本 =====
        pcall(function()
            loadstring([[
                -- 这里放你的主脚本
                print("✅ wdfex-Hub 主脚本加载成功")
                -- 你的主脚本代码放这里
            ]])()
        end)
        
    else
        attempts = attempts + 1
        updateAttemptsDisplay()
        
        showMessage(string.format("验证失败 (%d/%d)", attempts, maxAttempts), Color3.fromRGB(255, 110, 110))
        
        TweenService:Create(VerifyBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 110, 110),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        TweenService:Create(VerifyBtnStroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(255, 110, 110)
        }):Play()
        
        playSound("rbxassetid://62339698", 0.3)
        
        for i = 1, 3 do
            InputContainer.Position = UDim2.new(0.5, -120 + (i % 2 == 1 and 4 or -4), 0, 125)
            task.wait(0.05)
        end
        InputContainer.Position = UDim2.new(0.5, -120, 0, 125)
        
        task.wait(0.5)
        
        if attempts >= maxAttempts then
            updateStatus(Color3.fromRGB(255, 80, 80), "已锁定")
            showMessage("❌ 验证次数过多，UI将在3秒后关闭", Color3.fromRGB(255, 80, 80))
            VerifyBtn.AutoButtonColor = false
            VerifyBtn.Active = false
            Input.TextEditable = false
            
            task.wait(3)
            local exitTween = TweenService:Create(MainWin, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                BackgroundTransparency = 1
            })
            exitTween:Play()
            exitTween.Completed:Wait()
            ScreenGui:Destroy()
        else
            if btnHovering then
                TweenService:Create(VerifyBtn, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(245, 245, 245),
                    TextColor3 = Color3.fromRGB(0, 0, 0)
                }):Play()
                TweenService:Create(VerifyBtnStroke, TweenInfo.new(0.2), {
                    Color = Color3.fromRGB(75, 75, 75)
                }):Play()
            else
                TweenService:Create(VerifyBtn, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    TextColor3 = Color3.fromRGB(0, 0, 0)
                }):Play()
                TweenService:Create(VerifyBtnStroke, TweenInfo.new(0.2), {
                    Color = Color3.fromRGB(50, 50, 50)
                }):Play()
            end
            Input.Text = ""
        end
    end
end)

-- ========== 快捷键 ==========
Input.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        VerifyBtn.MouseButton1Click:Fire()
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Escape then
        CloseBtn.MouseButton1Click:Fire()
    end
    if input.KeyCode == Enum.KeyCode.F5 then
        if attempts < maxAttempts then
            attempts = 0
            updateAttemptsDisplay()
            updateStatus(Color3.fromRGB(255, 100, 100), "未验证")
            VerifyBtn.AutoButtonColor = true
            VerifyBtn.Active = true
            Input.TextEditable = true
            showMessage("重置验证次数", Color3.fromRGB(100, 200, 255), 1.5)
            playSound("rbxassetid://62339698", 0.3)
        end
    end
end)

-- ========== 呼吸效果 ==========
coroutine.wrap(function()
    while WinGlow.Parent do
        TweenService:Create(WinGlow, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true), {
            Transparency = 0.8
        }):Play()
        task.wait(2)
    end
end)()

coroutine.wrap(function()
    while StatusLight.Parent do
        TweenService:Create(StatusLight, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true), {
            BackgroundTransparency = 0.3
        }):Play()
        task.wait(1)
    end
end)()

-- ========== 移动端优化 ==========
if isMobile then
    local function onTextFieldFocused()
        TweenService:Create(MainWin, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0.5, -150, 0, 50)
        }):Play()
    end
    local function onTextFieldFocusLost()
        TweenService:Create(MainWin, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0.5, -150, 0.5, -140)
        }):Play()
    end
    Input.Focused:Connect(onTextFieldFocused)
    Input.FocusLost:Connect(onTextFieldFocusLost)
end

-- ========== 初始化 ==========
updateAttemptsDisplay()
updateStatus(Color3.fromRGB(255, 100, 100), "未验证")

print("✅ wdfex 卡密验证系统已加载")
print("📱 设备UID:", DEVICE_UID)
print("📐 窗口尺寸: 300x280")
print("📱 设备适配:", isMobile and "移动端" or "电脑端")