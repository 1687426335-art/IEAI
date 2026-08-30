-- ============================================================
-- wdfex-Hub 主脚本（含卡密验证系统）
-- ============================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local localPlayer = Players.LocalPlayer

-- ===== 设备UID =====
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

-- ===== 卡密列表 =====
local PRESET_KEYS = {
    -- 天卡 15个
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
    -- 周卡 15个
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
    -- 月卡 15个
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
    -- 永久卡 15个
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

local KEY_TYPES = {
    day = { label = "天卡", hours = 24, expiryText = "24小时" },
    week = { label = "周卡", hours = 168, expiryText = "7天" },
    month = { label = "月卡", hours = 720, expiryText = "30天" },
    forever = { label = "永久卡", hours = nil, expiryText = "永久", foreverDate = os.time({ year = 2099, month = 7, day = 8 }) },
}

-- ===== 卡密验证函数 =====
local function IsKeyValid(key)
    key = key:lower()
    for _, data in ipairs(PRESET_KEYS) do
        if data.key:lower() == key then
            return true, data.type
        end
    end
    return false, nil
end

local function IsKeyFormatValid(key)
    if type(key) ~= "string" then return false end
    key = key:lower()
    local pattern = "^wdfex%-[%w][%w][%w][%w]%-[%w][%w][%w][%w]$"
    return string.match(key, pattern) ~= nil
end

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
        return remaining, string.format("剩余 %d天 %d小时", days, hours)
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
        return remaining, string.format("%s 剩余 %d天 %d小时", KEY_TYPES[keyType].label, days, hours)
    elseif hours > 0 then
        return remaining, string.format("%s 剩余 %d小时 %d分钟", KEY_TYPES[keyType].label, hours, minutes)
    else
        return remaining, string.format("%s 剩余 %d分钟", KEY_TYPES[keyType].label, minutes)
    end
end

local function ValidateKey(key)
    key = key:lower()

    if not IsKeyFormatValid(key) then
        return false, "卡密格式错误"
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
        return true, "验证成功", keyType, existingData
    end

    local newData = {
        deviceId = DEVICE_UID,
        activatedAt = os.time(),
        type = keyType,
    }
    SaveKeyData(key, newData)

    return true, "验证成功", keyType, newData
end

-- ============================================================
-- 卡密验证UI（无表情包，专业风格）
-- ============================================================

local StartSound = Instance.new("Sound")
StartSound.Parent = SoundService
StartSound.SoundId = "rbxassetid://148729028"
StartSound.Volume = 0.5
StartSound:Play()

local attempts = 0
local maxAttempts = 3
local isDragging = false
local dragStart, frameStart
local isMobile = UserInputService.TouchEnabled
local isMouse = UserInputService.MouseEnabled

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "wdfexKeyUI"
ScreenGui.Parent = localPlayer.PlayerGui
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 100

local BackgroundOverlay = Instance.new("Frame")
BackgroundOverlay.Parent = ScreenGui
BackgroundOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BackgroundOverlay.BackgroundTransparency = 0.7
BackgroundOverlay.Size = UDim2.new(1, 0, 1, 0)
BackgroundOverlay.ZIndex = 1

local MainWin = Instance.new("Frame")
MainWin.Parent = ScreenGui
MainWin.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainWin.Position = UDim2.new(0.5, -150, 0.5, -140)
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

local TitleAccent = Instance.new("Frame")
TitleAccent.Parent = TitleBar
TitleAccent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TitleAccent.Position = UDim2.new(0, 0, 1, -1)
TitleAccent.Size = UDim2.new(1, 0, 0, 1)
TitleAccent.ZIndex = 4

local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Font = Enum.Font.GothamBlack
Title.Text = "wdfex 卡密验证"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.TextYAlignment = Enum.TextYAlignment.Center
Title.ZIndex = 4

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

local GroupLabel = Instance.new("TextLabel")
GroupLabel.Parent = GroupCard
GroupLabel.BackgroundTransparency = 1
GroupLabel.Position = UDim2.new(0, 12, 0, 8)
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
GroupNumber.Position = UDim2.new(