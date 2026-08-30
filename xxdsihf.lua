-- ============================================================
-- wdfex-Hub 主脚本（完整版 - DataStore卡密验证）
-- ============================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local localPlayer = Players.LocalPlayer

-- ==================== 设备UID生成 ====================
local function getDeviceUID()
    local userId = localPlayer.UserId
    local success, machineId = pcall(function()
        return HttpService:GetMachineId()
    end)
    if not success then machineId = "unknown" end
    local combined = userId .. "_" .. machineId .. "_" .. game.GameId
    local uid = ""
    for i = 1, #combined do
        uid = uid .. string.char((string.byte(combined, i) % 26) + 65)
    end
    return uid:sub(1, 32)
end

local DEVICE_UID = getDeviceUID()
print("设备UID: " .. DEVICE_UID)

-- ==================== 100个卡密（硬编码） ====================
local ALL_KEYS = {
    -- 天卡 25个
    ["WDF-K4M8R2N7P9-DAY"] = { type = "天卡", days = 1 },
    ["WDF-X3Q6T1L5V8-DAY"] = { type = "天卡", days = 1 },
    ["WDF-H9J2K4M7R1-DAY"] = { type = "天卡", days = 1 },
    ["WDF-B5N8Q2T6X9-DAY"] = { type = "天卡", days = 1 },
    ["WDF-V3M7P1K4L8-DAY"] = { type = "天卡", days = 1 },
    ["WDF-C6H9J2R5T1-DAY"] = { type = "天卡", days = 1 },
    ["WDF-F4N8Q1X7K3-DAY"] = { type = "天卡", days = 1 },
    ["WDF-M2P6T9L4V8-DAY"] = { type = "天卡", days = 1 },
    ["WDF-R7K1H4N9Q2-DAY"] = { type = "天卡", days = 1 },
    ["WDF-X5V8M3P6T1-DAY"] = { type = "天卡", days = 1 },
    ["WDF-J2L4N7Q9R5-DAY"] = { type = "天卡", days = 1 },
    ["WDF-T6X1K3M8P2-DAY"] = { type = "天卡", days = 1 },
    ["WDF-H7R4V9L2N5-DAY"] = { type = "天卡", days = 1 },
    ["WDF-Q3M8T1X6K4-DAY"] = { type = "天卡", days = 1 },
    ["WDF-L5P9N2R7V3-DAY"] = { type = "天卡", days = 1 },
    ["WDF-K1X6T4M9J2-DAY"] = { type = "天卡", days = 1 },
    ["WDF-V8R3L7P1N5-DAY"] = { type = "天卡", days = 1 },
    ["WDF-N4Q9K2X6T1-DAY"] = { type = "天卡", days = 1 },
    ["WDF-M7P3V8L4R9-DAY"] = { type = "天卡", days = 1 },
    ["WDF-T2X5K1N7Q4-DAY"] = { type = "天卡", days = 1 },
    ["WDF-R9L4M8V2P6-DAY"] = { type = "天卡", days = 1 },
    ["WDF-J5N1X7T3K9-DAY"] = { type = "天卡", days = 1 },
    ["WDF-H8P2Q6L4V1-DAY"] = { type = "天卡", days = 1 },
    ["WDF-K3V9N5R7X2-DAY"] = { type = "天卡", days = 1 },
    ["WDF-T7M4L1P8Q6-DAY"] = { type = "天卡", days = 1 },
    -- 周卡 25个
    ["WDF-P4K9X2N7R1-WEEK"] = { type = "周卡", days = 7 },
    ["WDF-M8V3Q6T1L5-WEEK"] = { type = "周卡", days = 7 },
    ["WDF-J2H7R4N9P3-WEEK"] = { type = "周卡", days = 7 },
    ["WDF-V6L1T8X4K7-WEEK"] = { type = "周卡", days = 7 },
    ["WDF-N3Q9R5P2M8-WEEK"] = { type = "周卡", days = 7 },
    ["WDF-X4K7T1L9V3-WEEK"] = { type = "周卡", days = 7 },
    ["WDF-H8M2P6R4N1-WEEK"] = { type = "周卡", days = 7 },
    ["WDF-Q5V9L3X7T2-WEEK"] = { type = "周卡", days = 7 },
    ["WDF-R1N6P4M8K3-WEEK"] = { type = "周卡", days = 7 },
    ["WDF-T7X2K9V5L1-WEEK"] = { type = "周卡", days = 7 },
    ["WDF-L4M8R2N6Q9-WEEK"] = { type = "周卡", days = 7 },
    ["WDF-V3P7T1X5K2-WEEK"] = { type = "周卡", days = 7 },
    ["WDF-J9N4L8R2M6-WEEK"] = { type = "周卡", days = 7 },
    ["WDF-H2T6X1K7V4-WEEK"] = { type = "周卡", days = 7 },
    ["WDF-Q8M3P9L1N5-WEEK"] = { type = "周卡", days = 7 },
    ["WDF-R4V7K2T9X3-WEEK"] = { type = "周卡", days = 7 },
    ["WDF-L1N5M8P4Q7-WEEK"] = { type = "周卡", days = 7 },
    ["WDF-X6T2R9V3K1-WEEK"] = { type = "周卡", days = 7 },
    ["WDF-H3M7L1N8Q5-WEEK"] = { type = "周卡", days = 7 },
    ["WDF-P9V4K2X6T8-WEEK"] = { type = "周卡", days = 7 },
    ["WDF-N5R8M3L7P1-WEEK"] = { type = "周卡", days = 7 },
    ["WDF-K2X9T4V6Q3-WEEK"] = { type = "周卡", days = 7 },
    ["WDF-T8L5N1M7R4-WEEK"] = { type = "周卡", days = 7 },
    ["WDF-V6P2K9X3L8-WEEK"] = { type = "周卡", days = 7 },
    ["WDF-Q4N7R1T5M2-WEEK"] = { type = "周卡", days = 7 },
    -- 月卡 25个
    ["WDF-R7M4N2X9P1-MONTH"] = { type = "月卡", days = 30 },
    ["WDF-T3L8V5Q6K2-MONTH"] = { type = "月卡", days = 30 },
    ["WDF-J9P1N4X7R3-MONTH"] = { type = "月卡", days = 30 },
    ["WDF-M5K2T8V1L9-MONTH"] = { type = "月卡", days = 30 },
    ["WDF-X7R3N6P4Q1-MONTH"] = { type = "月卡", days = 30 },
    ["WDF-H2L9V4T7K8-MONTH"] = { type = "月卡", days = 30 },
    ["WDF-Q6P1M8X3N5-MONTH"] = { type = "月卡", days = 30 },
    ["WDF-N4K7R9T2V6-MONTH"] = { type = "月卡", days = 30 },
    ["WDF-R8X3L5M1P9-MONTH"] = { type = "月卡", days = 30 },
    ["WDF-T1V6N4Q8K3-MONTH"] = { type = "月卡", days = 30 },
    ["WDF-K5M9P2X7R4-MONTH"] = { type = "月卡", days = 30 },
    ["WDF-L3T8V1N6Q9-MONTH"] = { type = "月卡", days = 30 },
    ["WDF-X7P4K2M9R1-MONTH"] = { type = "月卡", days = 30 },
    ["WDF-H6N1Q5T3V8-MONTH"] = { type = "月卡", days = 30 },
    ["WDF-R2M9X4L7P6-MONTH"] = { type = "月卡", days = 30 },
    ["WDF-V8K3N6Q1T5-MONTH"] = { type = "月卡", days = 30 },
    ["WDF-P4L1X9M7R2-MONTH"] = { type = "月卡", days = 30 },
    ["WDF-T7Q2V5N3K8-MONTH"] = { type = "月卡", days = 30 },
    ["WDF-M1R6P9L4X2-MONTH"] = { type = "月卡", days = 30 },
    ["WDF-N8K4T2Q6V7-MONTH"] = { type = "月卡", days = 30 },
    ["WDF-H3P7M1R9K5-MONTH"] = { type = "月卡", days = 30 },
    ["WDF-X9V2L6N4T8-MONTH"] = { type = "月卡", days = 30 },
    ["WDF-Q5M8P3K1R7-MONTH"] = { type = "月卡", days = 30 },
    ["WDF-R6T4X9V2L1-MONTH"] = { type = "月卡", days = 30 },
    ["WDF-K2N7M5P9Q4-MONTH"] = { type = "月卡", days = 30 },
    -- 永久卡 25个
    ["WDF-X9N4M7K2R5-FOREVER"] = { type = "永久卡", days = -1 },
    ["WDF-T6V3L8P1Q9-FOREVER"] = { type = "永久卡", days = -1 },
    ["WDF-H2M9R5N7X4-FOREVER"] = { type = "永久卡", days = -1 },
    ["WDF-P8K4T1V6L3-FOREVER"] = { type = "永久卡", days = -1 },
    ["WDF-N5R7X2M9Q1-FOREVER"] = { type = "永久卡", days = -1 },
    ["WDF-V3L8P6K2T9-FOREVER"] = { type = "永久卡", days = -1 },
    ["WDF-Q7M4N1X8R6-FOREVER"] = { type = "永久卡", days = -1 },
    ["WDF-K2T9V5L4P7-FOREVER"] = { type = "永久卡", days = -1 },
    ["WDF-R6X3N8M1Q5-FOREVER"] = { type = "永久卡", days = -1 },
    ["WDF-H4P7K9T2L6-FOREVER"] = { type = "永久卡", days = -1 },
    ["WDF-M8V1X5N3R9-FOREVER"] = { type = "永久卡", days = -1 },
    ["WDF-L2Q6P4K8T1-FOREVER"] = { type = "永久卡", days = -1 },
    ["WDF-X5N9R3V7M2-FOREVER"] = { type = "永久卡", days = -1 },
    ["WDF-T8K4P1L6Q3-FOREVER"] = { type = "永久卡", days = -1 },
    ["WDF-R1M7X2N9V4-FOREVER"] = { type = "永久卡", days = -1 },
    ["WDF-K6T2Q8P5L1-FOREVER"] = { type = "永久卡", days = -1 },
    ["WDF-V9N4R7X3M6-FOREVER"] = { type = "永久卡", days = -1 },
    ["WDF-P3L8K1T5Q7-FOREVER"] = { type = "永久卡", days = -1 },
    ["WDF-M5X9V2N6R4-FOREVER"] = { type = "永久卡", days = -1 },
    ["WDF-H7Q1P4L8K2-FOREVER"] = { type = "永久卡", days = -1 },
    ["WDF-T3R6M9X1V5-FOREVER"] = { type = "永久卡", days = -1 },
    ["WDF-N8K2L5P9Q4-FOREVER"] = { type = "永久卡", days = -1 },
    ["WDF-X1V7R4M8T6-FOREVER"] = { type = "永久卡", days = -1 },
    ["WDF-Q6P3K9N2L7-FOREVER"] = { type = "永久卡", days = -1 },
    ["WDF-L4T8X1V6R2-FOREVER"] = { type = "永久卡", days = -1 },
}

-- ==================== DataStore 存储 ====================
local store = DataStoreService:GetDataStore("KeySystemData")

local function loadKeys()
    local success, result = pcall(function()
        return store:GetAsync("all_keys")
    end)
    if success and result then
        return result
    end
    return nil
end

local function saveKeys(keys)
    local success = pcall(function()
        store:SetAsync("all_keys", keys)
    end)
    return success
end

local function initKeys()
    local saved = loadKeys()
    if saved then
        return saved
    end
    local newKeys = {}
    for key, data in pairs(ALL_KEYS) do
        newKeys[key] = {
            type = data.type,
            days = data.days,
            used = false,
            bind = nil,
            bindTime = nil,
        }
    end
    saveKeys(newKeys)
    return newKeys
end

local KEYS_DATA = initKeys()
print("卡密数据已加载，共 " .. table.getn(KEYS_DATA) .. " 个卡密")

-- ==================== 卡密验证函数 ====================
local function ValidateKey(key)
    local keyData = KEYS_DATA[key]
    if not keyData then
        return false, "卡密不存在"
    end

    if keyData.used then
        return false, "卡密已被使用"
    end

    if keyData.days ~= -1 then
        if keyData.bindTime then
            local elapsed = os.time() - keyData.bindTime
            local maxSeconds = keyData.days * 86400
            if elapsed >= maxSeconds then
                return false, "卡密已过期"
            end
        end
    end

    return true, "验证成功", keyData
end

local function ActivateKey(key)
    local keyData = KEYS_DATA[key]
    if not keyData then
        return false, "卡密不存在"
    end

    if keyData.used then
        return false, "卡密已被使用"
    end

    keyData.used = true
    keyData.bind = DEVICE_UID
    keyData.bindTime = os.time()
    saveKeys(KEYS_DATA)
    return true, "卡密绑定成功"
end

local function GetKeyRemainingTime(key)
    local keyData = KEYS_DATA[key]
    if not keyData then
        return nil, "卡密不存在"
    end

    if not keyData.used then
        return nil, "卡密未激活"
    end

    if keyData.days == -1 then
        return 999999, "永久卡"
    end

    if not keyData.bindTime then
        return nil, "数据异常"
    end

    local elapsed = os.time() - keyData.bindTime
    local maxSeconds = keyData.days * 86400
    local remaining = maxSeconds - elapsed

    if remaining <= 0 then
        return 0, "已过期"
    end

    local days = math.floor(remaining / 86400)
    local hours = math.floor((remaining % 86400) / 3600)
    local minutes = math.floor((remaining % 3600) / 60)

    if days > 0 then
        return remaining, string.format("%s 剩余 %d天 %d小时", keyData.type, days, hours)
    elseif hours > 0 then
        return remaining, string.format("%s 剩余 %d小时 %d分钟", keyData.type, hours, minutes)
    else
        return remaining, string.format("%s 剩余 %d分钟", keyData.type, minutes)
    end
end

-- ============================================================
-- 卡密验证UI（纯净版，无表情包，无群号）
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
MainWin.Position = UDim2.new(0.5, -150, 0.5, -120)
MainWin.Size = UDim2.new(0, 300, 0, 240)
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
SubTitle.Text = "卡密验证系统 v2.0"
SubTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
SubTitle.TextSize = 10
SubTitle.TextXAlignment = Enum.TextXAlignment.Center
SubTitle.ZIndex = 4

local UIDLabel = Instance.new("TextLabel")
UIDLabel.Parent = MainWin
UIDLabel.BackgroundTransparency = 1
UIDLabel.Position = UDim2.new(0, 10, 0, 48)
UIDLabel.Size = UDim2.new(1, 0, 0, 14)
UIDLabel.Font = Enum.Font.Gotham
UIDLabel.Text = "设备UID: " .. string.sub(DEVICE_UID, 1, 20) .. "..."
UIDLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
UIDLabel.TextSize = 9
UIDLabel.TextXAlignment = Enum.TextXAlignment.Left
UIDLabel.ZIndex = 3

local InputContainer = Instance.new("Frame")
InputContainer.Parent = MainWin
InputContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
InputContainer.Position = UDim2.new(0.5, -120, 0, 72)
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
Input.PlaceholderText = "请输入卡密 WDF-XXXX-XXXX"
Input.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
Input.ClearTextOnFocus = false
Input.ZIndex = 4

local InputIcon = Instance.new("TextLabel")
InputIcon.Parent = InputContainer
InputIcon.BackgroundTransparency = 1
InputIcon.Position = UDim2.new(1, -30, 0.5, -9)
InputIcon.Size = UDim2.new(0, 18, 0, 18)
InputIcon.Font = Enum.Font.GothamBold
InputIcon.Text = "K"
InputIcon.TextColor3 = Color3.fromRGB(150, 150, 150)
InputIcon.TextSize = 12
InputIcon.TextYAlignment = Enum.TextYAlignment.Center
InputIcon.ZIndex = 4

local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Parent = MainWin
VerifyBtn.Position = UDim2.new(0.5, -95, 0, 120)
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

local InfoFrame = Instance.new("Frame")
InfoFrame.Parent = MainWin
InfoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
InfoFrame.Position = UDim2.new(0.5, -135, 0, 165)
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

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainWin
CloseBtn.Position = UDim2.new(1, -35, 0, 8)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "x"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.TextSize = 18
CloseBtn.TextXAlignment = Enum.TextXAlignment.Center
CloseBtn.BorderSizePixel = 0
CloseBtn.AutoButtonColor = false
CloseBtn.ZIndex = 10

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.Parent = CloseBtn
CloseBtnCorner.CornerRadius = UDim.new(0, 6)

local TouchDragArea = Instance.new("TextButton")
TouchDragArea.Parent = MainWin
TouchDragArea.BackgroundTransparency = 1
TouchDragArea.Size = UDim2.new(1, 0, 0, 60)
TouchDragArea.Text = ""
TouchDragArea.ZIndex = 5
TouchDragArea.AutoButtonColor = false
TouchDragArea.Visible = isMobile

MainWin.Size = UDim2.new(0, 0, 0, 0)
MainWin.Position = UDim2.new(0.5, 0, 0.5, 0)
MainWin.BackgroundTransparency = 1

local entranceTween = TweenService:Create(MainWin, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 300, 0, 240),
    Position = UDim2.new(0.5, -150, 0.5, -120),
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
end)

Input.FocusLost:Connect(function()
    InputContainerStroke.Color = Color3.fromRGB(50, 50, 50)
    TweenService:Create(InputContainer, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    }):Play()
    TweenService:Create(InputIcon, TweenInfo.new(0.2), {
        TextColor3 = Color3.fromRGB(150, 150, 150)
    }):Play()
end)

-- ========== 按钮交互 ==========
VerifyBtn.MouseEnter:Connect(function()
    TweenService:Create(VerifyBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(245, 245, 245)
    }):Play()
    TweenService:Create(VerifyBtnStroke, TweenInfo.new(0.2), {
        Color = Color3.fromRGB(75, 75, 75)
    }):Play()
end)

VerifyBtn.MouseLeave:Connect(function()
    TweenService:Create(VerifyBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
    TweenService:Create(VerifyBtnStroke, TweenInfo.new(0.2), {
        Color = Color3.fromRGB(50, 50, 50)
    }):Play()
end)

-- ========== 拖动功能 ==========
local function startDrag(input)
    if (isMouse and input.UserInputType == Enum.UserInputType.MouseButton1) or
       (isMobile and input.UserInputType == Enum.UserInputType.Touch) then
        isDragging = true
        dragStart = input.Position
        frameStart = MainWin.Position
    end
end

local function endDrag()
    if isDragging then
        isDragging = false
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
            InputContainer.Position = UDim2.new(0.5, -120 + (i % 2 == 1 and 3 or -3), 0, 72)
            task.wait(0.05)
        end
        InputContainer.Position = UDim2.new(0.5, -120, 0, 72)
        return
    end

    local valid, msg, keyData = ValidateKey(key)

    if valid then
        local bindSuccess, bindMsg = ActivateKey(key)
        if not bindSuccess then
            showMessage(bindMsg, Color3.fromRGB(255, 110, 110), 2)
            return
        end

        updateStatus(Color3.fromRGB(80, 255, 80), "已验证")
        showMessage("验证成功，卡密已绑定", Color3.fromRGB(80, 255, 80))

        InfoFrame.Visible = true
        local remaining, remainingText = GetKeyRemainingTime(key)
        if remainingText then
            InfoLabel.Text = "卡密类型: " .. keyData.type .. "\n" .. remainingText
        else
            InfoLabel.Text = "卡密类型: " .. keyData.type
        end
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
                -- 这里放你的 WindUI 主脚本
                print("wdfex-Hub 主脚本加载成功")
                -- 你的主脚本代码放这里
            ]])()
        end)

    else
        attempts = attempts + 1
        updateAttemptsDisplay()

        showMessage(string.format("验证失败 (%d/%d): %s", attempts, maxAttempts, msg), Color3.fromRGB(255, 110, 110))

        TweenService:Create(VerifyBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 110, 110),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        TweenService:Create(VerifyBtnStroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(255, 110, 110)
        }):Play()

        playSound("rbxassetid://62339698", 0.3)

        for i = 1, 3 do
            InputContainer.Position = UDim2.new(0.5, -120 + (i % 2 == 1 and 4 or -4), 0, 72)
            task.wait(0.05)
        end
        InputContainer.Position = UDim2.new(0.5, -120, 0, 72)

        task.wait(0.5)

        if attempts >= maxAttempts then
            updateStatus(Color3.fromRGB(255, 80, 80), "已锁定")
            showMessage("验证次数过多，UI即将关闭", Color3.fromRGB(255, 80, 80))
            VerifyBtn.AutoButtonColor = false
            VerifyBtn.Active = false
            Input.TextEditable = false

            task.wait(2)
            local exitTween = TweenService:Create(MainWin, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                BackgroundTransparency = 1
            })
            exitTween:Play()
            exitTween.Completed:Wait()
            ScreenGui:Destroy()
        else
            TweenService:Create(VerifyBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                TextColor3 = Color3.fromRGB(0, 0, 0)
            }):Play()
            TweenService:Create(VerifyBtnStroke, TweenInfo.new(0.2), {
                Color = Color3.fromRGB(50, 50, 50)
            }):Play()
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
            Position = UDim2.new(0.5, -150, 0.5, -120)
        }):Play()
    end
    Input.Focused:Connect(onTextFieldFocused)
    Input.FocusLost:Connect(onTextFieldFocusLost)
end

-- ========== 初始化 ==========
updateAttemptsDisplay()
updateStatus(Color3.fromRGB(255, 100, 100), "未验证")

print("wdfex 卡密验证系统已加载")
print("设备UID:", DEVICE_UID)
print("卡密数量:", table.getn(KEYS_DATA))
print("天卡: 25个, 周卡: 25个, 月卡: 25个, 永久卡: 25个")