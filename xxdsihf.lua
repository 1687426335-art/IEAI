-- ====================== 卡密验证系统 ======================
local function getDeviceUID()
    local userId = game.Players.LocalPlayer.UserId
    local success, machineId = pcall(function()
        return game:GetService("HttpService"):GetMachineId()
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

-- ====================== 100个卡密 ======================
local ALL_KEYS = {
    -- 天卡 DAY (25个)
    ["wdfex-A7K2X9P4R1-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["wdfex-M8V3Q6T1L5-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["wdfex-H9J2K4M7R1-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["wdfex-B5N8Q2T6X9-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["wdfex-V3M7P1K4L8-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["wdfex-C6H9J2R5T1-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["wdfex-F4N8Q1X7K3-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["wdfex-P2M6T9L4V8-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["wdfex-R7K1H4N9Q2-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["wdfex-X5V8M3P6T1-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["wdfex-J2L4N7Q9R5-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["wdfex-T6X1K3M8P2-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["wdfex-H7R4V9L2N5-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["wdfex-Q3M8T1X6K4-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["wdfex-L5P9N2R7V3-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["wdfex-K1X6T4M9J2-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["wdfex-V8R3L7P1N5-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["wdfex-N4Q9K2X6T1-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["wdfex-M7P3V8L4R9-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["wdfex-T2X5K1N7Q4-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["wdfex-R9L4M8V2P6-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["wdfex-J5N1X7T3K9-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["wdfex-H8P2Q6L4V1-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["wdfex-K3V9N5R7X2-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["wdfex-T7M4L1P8Q6-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    -- 周卡 WEEK (25个)
    ["wdfex-P4K9X2N7R1-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["wdfex-M8V3Q6T1L5-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["wdfex-J2H7R4N9P3-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["wdfex-V6L1T8X4K7-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["wdfex-N3Q9R5P2M8-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["wdfex-X4K7T1L9V3-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["wdfex-H8M2P6R4N1-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["wdfex-Q5V9L3X7T2-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["wdfex-R1N6P4M8K3-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["wdfex-T7X2K9V5L1-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["wdfex-L4M8R2N6Q9-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["wdfex-V3P7T1X5K2-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["wdfex-J9N4L8R2M6-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["wdfex-H2T6X1K7V4-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["wdfex-Q8M3P9L1N5-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["wdfex-R4V7K2T9X3-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["wdfex-L1N5M8P4Q7-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["wdfex-X6T2R9V3K1-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["wdfex-H3M7L1N8Q5-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["wdfex-P9V4K2X6T8-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["wdfex-N5R8M3L7P1-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["wdfex-K2X9T4V6Q3-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["wdfex-T8L5N1M7R4-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["wdfex-V6P2K9X3L8-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["wdfex-Q4N7R1T5M2-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    -- 月卡 MONTH (25个)
    ["wdfex-R7M4N2X9P1-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["wdfex-T3L8V5Q6K2-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["wdfex-J9P1N4X7R3-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["wdfex-M5K2T8V1L9-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["wdfex-X7R3N6P4Q1-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["wdfex-H2L9V4T7K8-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["wdfex-Q6P1M8X3N5-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["wdfex-N4K7R9T2V6-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["wdfex-R8X3L5M1P9-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["wdfex-T1V6N4Q8K3-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["wdfex-K5M9P2X7R4-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["wdfex-L3T8V1N6Q9-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["wdfex-X7P4K2M9R1-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["wdfex-H6N1Q5T3V8-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["wdfex-R2M9X4L7P6-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["wdfex-V8K3N6Q1T5-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["wdfex-P4L1X9M7R2-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["wdfex-T7Q2V5N3K8-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["wdfex-M1R6P9L4X2-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["wdfex-N8K4T2Q6V7-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["wdfex-H3P7M1R9K5-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["wdfex-X9V2L6N4T8-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["wdfex-Q5M8P3K1R7-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["wdfex-R6T4X9V2L1-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["wdfex-K2N7M5P9Q4-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    -- 永久卡 FOREVER (25个)
    ["wdfex-X9N4M7K2R5-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["wdfex-T6V3L8P1Q9-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["wdfex-H2M9R5N7X4-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["wdfex-P8K4T1V6L3-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["wdfex-N5R7X2M9Q1-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["wdfex-V3L8P6K2T9-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["wdfex-Q7M4N1X8R6-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["wdfex-K2T9V5L4P7-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["wdfex-R6X3N8M1Q5-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["wdfex-H4P7K9T2L6-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["wdfex-M8V1X5N3R9-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["wdfex-L2Q6P4K8T1-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["wdfex-X5N9R3V7M2-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["wdfex-T8K4P1L6Q3-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["wdfex-R1M7X2N9V4-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["wdfex-K6T2Q8P5L1-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["wdfex-V9N4R7X3M6-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["wdfex-P3L8K1T5Q7-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["wdfex-M5X9V2N6R4-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["wdfex-H7Q1P4L8K2-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["wdfex-T3R6M9X1V5-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["wdfex-N8K2L5P9Q4-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["wdfex-X1V7R4M8T6-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["wdfex-Q6P3K9N2L7-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["wdfex-L4T8X1V6R2-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
}

-- ====================== DataStore存储 ======================
local DataStoreService = game:GetService("DataStoreService")
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

-- ====================== 设备已绑定卡密检测 ======================
local function getDeviceBoundKey()
    for key, data in pairs(KEYS_DATA) do
        if data.bind == DEVICE_UID and data.used then
            return key, data
        end
    end
    return nil, nil
end

local function isKeyValid(data)
    if data.days == -1 then
        return true
    end
    if not data.bindTime then
        return false
    end
    local elapsed = os.time() - data.bindTime
    return elapsed < data.days * 86400
end

local boundKey, boundData = getDeviceBoundKey()
local deviceHasValidKey = boundKey and boundData and isKeyValid(boundData)

local function verifyKey(inputKey)
    if deviceHasValidKey then
        return false, "您已经验证激活过一张卡密了，请继续使用那张卡密，您无法更换卡密，您需要联系作者给您替换卡密", "already_bound"
    end
    
    local keyData = KEYS_DATA[inputKey]
    if not keyData then
        return false, "卡密不存在", "invalid"
    end
    
    if keyData.used then
        if keyData.bind == DEVICE_UID then
            return false, "您已经验证激活过一张卡密了", "already_bound"
        else
            return false, "卡密已被其他设备使用", "used_by_other"
        end
    end
    
    keyData.used = true
    keyData.bind = DEVICE_UID
    keyData.bindTime = os.time()
    saveKeys(KEYS_DATA)
    
    return true, "验证成功，卡密类型: " .. keyData.type, "success"
end

-- 如果设备已绑定有效卡密，直接跳转到主脚本
if deviceHasValidKey then
    print("设备已绑定卡密: " .. boundData.type .. "，直接启动主脚本")
    createMainUI()
    return
end

-- ====================== 卡密验证UI ======================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local localPlayer = Players.LocalPlayer

local StartSound = Instance.new("Sound")
StartSound.Parent = SoundService
StartSound.SoundId = "rbxassetid://148729028"
StartSound.Volume = 0.5
StartSound:Play()

local attempts = 0
local maxAttempts = 3
local copyCooldown = false
local btnHovering = false
local isCopyHovering = false
local isDragging = false
local dragStart, frameStart
local isMobile = UserInputService.TouchEnabled
local isMouse = UserInputService.MouseEnabled

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KeyValidation"
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
MainWin.Position = UDim2.new(0.5, -150, 0.5, -130)
MainWin.Size = UDim2.new(0, 300, 0, 260)
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
Title.Text = "wdfex - 卡密验证"
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
SubTitle.Text = "卡密验证系统"
SubTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
SubTitle.TextSize = 10
SubTitle.TextXAlignment = Enum.TextXAlignment.Center
SubTitle.ZIndex = 4

local WarningCard = Instance.new("Frame")
WarningCard.Parent = MainWin
WarningCard.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
WarningCard.Position = UDim2.new(0.5, -135, 0, 45)
WarningCard.Size = UDim2.new(0, 270, 0, 35)
WarningCard.ZIndex = 3

local WarningCorner = Instance.new("UICorner")
WarningCorner.Parent = WarningCard
WarningCorner.CornerRadius = UDim.new(0, 6)

local WarningStroke = Instance.new("UIStroke")
WarningStroke.Parent = WarningCard
WarningStroke.Color = Color3.fromRGB(255, 110, 110)
WarningStroke.Thickness = 1
WarningStroke.Transparency = 0.2

local WarningIcon = Instance.new("TextLabel")
WarningIcon.Parent = WarningCard
WarningIcon.BackgroundTransparency = 1
WarningIcon.Position = UDim2.new(0, 8, 0, 8)
WarningIcon.Size = UDim2.new(0, 18, 0, 18)
WarningIcon.Font = Enum.Font.GothamBold
WarningIcon.Text = "⚠"
WarningIcon.TextColor3 = Color3.fromRGB(255, 110, 110)
WarningIcon.TextSize = 14
WarningIcon.TextYAlignment = Enum.TextYAlignment.Center
WarningIcon.ZIndex = 4

local WarningText = Instance.new("TextLabel")
WarningText.Parent = WarningCard
WarningText.BackgroundTransparency = 1
WarningText.Position = UDim2.new(0, 30, 0, 0)
WarningText.Size = UDim2.new(1, -30, 1, 0)
WarningText.Font = Enum.Font.GothamMedium
WarningText.Text = "卡密不定期更换，联系群主获取"
WarningText.TextColor3 = Color3.fromRGB(255, 180, 180)
WarningText.TextSize = 11
WarningText.TextXAlignment = Enum.TextXAlignment.Left
WarningText.TextYAlignment = Enum.TextYAlignment.Center
WarningText.ZIndex = 4

local GroupCard = Instance.new("Frame")
GroupCard.Parent = MainWin
GroupCard.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
GroupCard.Position = UDim2.new(0.5, -135, 0, 85)
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

local WhitelistNote = Instance.new("TextLabel")
WhitelistNote.Parent = MainWin
WhitelistNote.BackgroundTransparency = 1
WhitelistNote.Position = UDim2.new(0, 0, 0, 140)
WhitelistNote.Size = UDim2.new(1, 0, 0, 16)
WhitelistNote.Font = Enum.Font.GothamMedium
WhitelistNote.Text = "✨ 进群有机会获得白名单资格"
WhitelistNote.TextColor3 = Color3.fromRGB(255, 200, 80)
WhitelistNote.TextSize = 11
WhitelistNote.TextXAlignment = Enum.TextXAlignment.Center
WhitelistNote.ZIndex = 3

local InputContainer = Instance.new("Frame")
InputContainer.Parent = MainWin
InputContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
InputContainer.Position = UDim2.new(0.5, -120, 0, 160)
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
Input.PlaceholderText = "请输入卡密..."
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

local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Parent = MainWin
VerifyBtn.Position = UDim2.new(0.5, -95, 0, 205)
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

local AttemptsDisplay = Instance.new("TextLabel")
AttemptsDisplay.Parent = MainWin
AttemptsDisplay.BackgroundTransparency = 1
AttemptsDisplay.Position = UDim2.new(0, 0, 1, -35)
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

local Msg = Instance.new("TextLabel")
Msg.Parent = MainWin
Msg.BackgroundTransparency = 1
Msg.Position = UDim2.new(0, 0, 1, -20)
Msg.Size = UDim2.new(1, 0, 0, 16)
Msg.Font = Enum.Font.Gotham
Msg.Text = ""
Msg.TextColor3 = Color3.fromRGB(150, 150, 150)
Msg.TextSize = 10
Msg.TextXAlignment = Enum.TextXAlignment.Center
Msg.Visible = false
Msg.ZIndex = 3

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
    Size = UDim2.new(0, 300, 0, 260),
    Position = UDim2.new(0.5, -150, 0.5, -130),
    BackgroundTransparency = 0
})
entranceTween:Play()

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

-- 输入框交互
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

ClearInputButton.MouseEnter:Connect(function()
    TweenService:Create(ClearInputButton, TweenInfo.new(0.2), {
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
end)

ClearInputButton.MouseLeave:Connect(function()
    TweenService:Create(ClearInputButton, TweenInfo.new(0.2), {
        TextColor3 = Color3.fromRGB(120, 120, 120)
    }):Play()
end)

ClearInputButton.MouseButton1Click:Connect(function()
    Input.Text = ""
    Input:CaptureFocus()
    playSound("rbxassetid://62339698", 0.3)
end)

-- 按钮交互
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

VerifyBtn.MouseButton1Down:Connect(function()
    TweenService:Create(VerifyBtn, TweenInfo.new(0.1), {
        BackgroundColor3 = Color3.fromRGB(225, 225, 225),
        Size = UDim2.new(0, 185, 0, 34)
    }):Play()
    playSound("rbxassetid://62339698", 0.2)
end)

VerifyBtn.MouseButton1Up:Connect(function()
    TweenService:Create(VerifyBtn, TweenInfo.new(0.1), {
        BackgroundColor3 = btnHovering and Color3.fromRGB(245, 245, 245) or Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0, 190, 0, 36)
    }):Play()
end)

-- 关闭按钮
CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(55, 55, 55),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
end)

CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        TextColor3 = Color3.fromRGB(200, 200, 200)
    }):Play()
end)

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

-- 复制功能
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

CopyButton.MouseButton1Down:Connect(function()
    if not copyCooldown then
        TweenService:Create(GroupCard, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(15, 20, 35),
            Size = UDim2.new(0, 265, 0, 48)
        }):Play()
        TweenService:Create(GroupGlow, TweenInfo.new(0.1), {
            Color = Color3.fromRGB(150, 190, 255),
            Thickness = 2.2
        }):Play()
        playSound("rbxassetid://62339698", 0.2)
    end
end)

CopyButton.MouseButton1Up:Connect(function()
    if not copyCooldown then
        TweenService:Create(GroupCard, TweenInfo.new(0.1), {
            Size = UDim2.new(0, 270, 0, 50),
            BackgroundColor3 = isCopyHovering and Color3.fromRGB(30, 35, 55) or Color3.fromRGB(20, 25, 40)
        }):Play()
        TweenService:Create(GroupGlow, TweenInfo.new(0.1), {
            Color = isCopyHovering and Color3.fromRGB(120, 160, 240) or Color3.fromRGB(80, 120, 200),
            Thickness = 1.5
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
    for i = 1, 2 do
        TweenService:Create(GroupCard, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(30, 55, 30)
        }):Play()
        TweenService:Create(GroupGlow, TweenInfo.new(0.1), {
            Color = Color3.fromRGB(100, 255, 100)
        }):Play()
        task.wait(0.1)
        TweenService:Create(GroupCard, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(20, 25, 40)
        }):Play()
        TweenService:Create(GroupGlow, TweenInfo.new(0.1), {
            Color = Color3.fromRGB(80, 120, 200)
        }):Play()
        task.wait(0.1)
    end
    task.wait(1.5)
    local hideTween = TweenService:Create(CopySuccess, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, -65, 0, 75)
    })
    hideTween:Play()
    hideTween.Completed:Wait()
    CopySuccess.Visible = false
    task.wait(0.5)
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

-- 拖动
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

-- ====================== 验证功能 ======================
VerifyBtn.MouseButton1Click:Connect(function()
    local key = Input.Text
    
    if #key == 0 then
        showMessage("请输入卡密", Color3.fromRGB(255, 180, 80), 1.5)
        for i = 1, 3 do
            InputContainer.Position = UDim2.new(0.5, -120 + (i % 2 == 1 and 3 or -3), 0, 160)
            task.wait(0.05)
        end
        InputContainer.Position = UDim2.new(0.5, -120, 0, 160)
        return
    end
    
    local success, msg, code = verifyKey(key)
    
    if success then
        updateStatus(Color3.fromRGB(80, 255, 80), "已验证")
        showMessage("✓ " .. msg, Color3.fromRGB(80, 255, 80), 1.5)
        
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
        task.wait(1.2)
        
        local exitTween = TweenService:Create(MainWin, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        })
        exitTween:Play()
        exitTween.Completed:Wait()
        ScreenGui:Destroy()
        if StartSound then StartSound:Destroy() end
        
        -- ===== 验证成功，执行主脚本 =====
        createMainUI()
        -- ================================
        
    elseif code == "already_bound" then
        attempts = attempts + 1
        updateAttemptsDisplay()
        showMessage(msg, Color3.fromRGB(255, 200, 50), 3)
        playSound("rbxassetid://62339698", 0.3)
    else
        attempts = attempts + 1
        updateAttemptsDisplay()
        showMessage(string.format("验证失败: %s (%d/%d)", msg, attempts, maxAttempts), Color3.fromRGB(255, 110, 110), 2)
        playSound("rbxassetid://62339698", 0.3)
        
        for i = 1, 3 do
            InputContainer.Position = UDim2.new(0.5, -120 + (i % 2 == 1 and 4 or -4), 0, 160)
            task.wait(0.05)
        end
        InputContainer.Position = UDim2.new(0.5, -120, 0, 160)
        
        for i = 1, 2 do
            WarningStroke.Color = Color3.fromRGB(255, 80, 80)
            task.wait(0.1)
            WarningStroke.Color = Color3.fromRGB(255, 110, 110)
            task.wait(0.1)
        end
    end
    
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
        Input.Text = ""
    end
end)

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

Input:GetPropertyChangedSignal("Text"):Connect(function()
    if #Input.Text > 100 then
        Input.Text = string.sub(Input.Text, 1, 100)
        showMessage("输入过长，已自动截断", Color3.fromRGB(255, 160, 60), 1.5)
    end
end)

-- 动态效果
coroutine.wrap(function()
    while WinGlow.Parent do
        TweenService:Create(WinGlow, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true), {
            Transparency = 0.8
        }):Play()
        task.wait(2)
    end
end)()

coroutine.wrap(function()
    while VerifyBtnStroke.Parent do
        TweenService:Create(VerifyBtnStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true), {
            Transparency = 0.5
        }):Play()
        task.wait(1.5)
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

if isMobile then
    local function onTextFieldFocused()
        TweenService:Create(MainWin, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0.5, -150, 0, 50)
        }):Play()
    end
    local function onTextFieldFocusLost()
        TweenService:Create(MainWin, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0.5, -150, 0.5, -130)
        }):Play()
    end
    Input.Focused:Connect(onTextFieldFocused)
    Input.FocusLost:Connect(onTextFieldFocusLost)
    
    local lastTapTime = 0
    local doubleTapThreshold = 0.3
    TouchDragArea.MouseButton1Click:Connect(function()
        local currentTime = tick()
        if currentTime - lastTapTime < doubleTapThreshold then
            CloseBtn.MouseButton1Click:Fire()
        end
        lastTapTime = currentTime
    end)
end

updateAttemptsDisplay()
print("设备UID: " .. DEVICE_UID)
print("卡密数量: " .. table.getn(KEYS_DATA))
print("wdfex卡密验证系统已加载")

-- ====================== 主脚本 (WindUI) ======================
function createMainUI()
    local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()
    local Confirmed = false

    local gradientColors = {
        "rgb(255, 230, 235)", "rgb(255, 210, 220)", "rgb(255, 190, 205)",
        "rgb(255, 170, 190)", "rgb(255, 150, 175)", "rgb(245, 140, 180)",
        "rgb(235, 130, 185)", "rgb(225, 120, 190)", "rgb(215, 110, 195)",
        "rgb(205, 100, 200)"
    }

    local username = game.Players.LocalPlayer.Name
    local coloredUsername = ""
    for i = 1, #username do
        local colorIndex = (i - 1) % #gradientColors + 1
        coloredUsername = coloredUsername .. '<font color="' .. gradientColors[colorIndex] .. '">' .. username:sub(i, i) .. '</font>'
    end

    local version = "v2.0"
    local coloredVersion = ""
    for i = 1, #version do
        local colorIndex = (i - 1) % #gradientColors + 1
        coloredVersion = coloredVersion .. '<font color="' .. gradientColors[colorIndex] .. '">' .. version:sub(i, i) .. '</font>'
    end

    WindUI:Popup({
        Title = '<font color="' .. gradientColors[1] .. '">wdf</font><font color="' .. gradientColors[5] .. '">ex</font>',
        IconThemed = true,
        Content = "尊敬的用户 " .. coloredUsername .. " \n您使用的 <font color='" .. gradientColors[1] .. "'>wdf</font><font color='" .. gradientColors[5] .. "'>ex</font> 当前版本型号是: " .. coloredVersion .. "\n圣奥里（San Aurie）脚本已就绪！",
        Buttons = {
            { Title = "取消", Callback = function() end, Variant = "Secondary" },
            {
                Title = "执行",
                Icon = "arrow-right",
                Callback = function()
                    Confirmed = true
                    createMainUIWindow()
                end,
                Variant = "Primary",
            }
        }
    })

    function createMainUIWindow()
        local Window = WindUI:CreateWindow({
            Title = 'wdfex-圣奥里',
            Icon = "heart",
            IconThemed = true,
            Author = version,
            Folder = "CloudHub",
            Size = UDim2.fromOffset(580, 440),
            Transparent = true,
            Theme = "Dark",
            HideSearchBar = false,
            ScrollBarEnabled = true,
            Resizable = true,
            Background = "https://raw.githubusercontent.com/XxwanhexxX/UN/main/preview_png.png",
            BackgroundImageTransparency = 0.5,
            User = {
                Enabled = true,
                Callback = function()
                    WindUI:Notify({
                        Title = "点击了自己",
                        Content = "没什么",
                        Duration = 1,
                        Icon = "4483362748"
                    })
                end,
                Anonymous = false
            },
            SideBarWidth = 250,
            Search = {
                Enabled = true,
                Placeholder = "搜索...",
                Callback = function(searchText)
                    print("搜索内容:", searchText)
                end
            },
            SidePanel = {
                Enabled = true,
                Content = {
                    { Type = "Button", Text = "wdfex", Style = "Subtle", Size = UDim2.new(1, -20, 0, 30), Callback = function() end }
                }
            }
        })

        Window:EditOpenButton({
            Title = "wdfex",
            Icon = "rbxassetid://105677776902677",
            CornerRadius = UDim.new(0,16),
            StrokeThickness = 4,
            Color = ColorSequence.new(Color3.fromHex("FF6B6B")),
            Draggable = true,
        })

        Window:Tag({ Title = "圣奥里", Color = Color3.fromHex("#00ffff") })

        Window:EditOpenButton({
            Title = "wdfex",
            Icon = "heart",
            CornerRadius = UDim.new(0,16),
            StrokeThickness = 4,
            Color = ColorSequence.new(Color3.fromHex("FF6B6B")),
            Draggable = true,
        })

        spawn(function()
            while true do
                for hue = 0, 1, 0.01 do
                    local color = Color3.fromHSV(hue, 0.8, 1)
                    Window:EditOpenButton({ Color = ColorSequence.new(color) })
                    wait(0.04)
                end
            end
        end)

        -- ==================== 全局变量 ====================
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Workspace = game:GetService("Workspace")
        local RunService = game:GetService("RunService")
        local UserInputService = game:GetService("UserInputService")
        local lp = Players.LocalPlayer
        local isDestroyed = false
        local connections = {}

        local Settings = {
            HoldTime = 0,
            Distance = 25,
            HitboxEnabled = false,
            HitboxSize = 10,
            WhitelistEnabled = false,
            TeleportEnabled = false,
            NoclipEnabled = false,
        }
        local Whitelist = {}
        local affectedHeads = {}
        local frameCount = 0

        -- 防甩飞
        _G.CatAntiFling_Enabled = false
        _G.CatAntiFling_Running = false
        local function AntiFlingLoop()
            if _G.CatAntiFling_Running then return end
            _G.CatAntiFling_Running = true
            task.spawn(function()
                while not isDestroyed do
                    if _G.CatAntiFling_Enabled then
                        pcall(function()
                            local char = lp.Character
                            if not char then return end
                            local root = char:FindFirstChild("HumanoidRootPart")
                            if not root then return end
                            local vel = root.Velocity
                            if vel.Magnitude > 500 or math.abs(vel.Y) > 300 then
                                root.Velocity = Vector3.new(0, 0, 0)
                                root.RotVelocity = Vector3.new(0, 0, 0)
                            end
                            for _, obj in ipairs(root:GetChildren()) do
                                if (obj:IsA("BodyVelocity") or obj:IsA("BodyAngularVelocity")) and obj.Name ~= "CatAntiFling" and obj.Name ~= "CatAntiFlingAngular" then
                                    obj:Destroy()
                                end
                            end
                        end)
                    end
                    task.wait()
                end
                _G.CatAntiFling_Running = false
            end)
        end
        AntiFlingLoop()

        -- ==================== Tab 创建 ====================
        local NoticeTab = Window:Tab({ Title = "公告", Icon = "info" })
        local NoticeSection = NoticeTab:Section({ Title = "作者消息", Opened = true })
        NoticeSection:Paragraph({
            Title = "wdfex",
            Desc = "创作者：wdfex\nQQ：1687426335\n已为您开启反作弊与防挂机祝您玩的愉快"
        })
        NoticeSection:Divider()
        NoticeSection:Paragraph({
            Title = "注意事项",
            Desc = "已更换悬浮窗添加了一些功能\n杀戮光环的优先攻击最近目标如果选择距离内没有人\n那这个选项就不会生效杀戮光环正常生效\n请勿将此脚本分享给他人发现我将封禁你的设备\n让你无法使用\n如果你使用的过程中出现一些bug请联系作者修复"
        })

        local infoTab = Window:Tab({ Title = "通知", Icon = "layout-grid", Locked = false })
        local infoSection = infoTab:Section({ Title = "详情信息", Icon = "info", Opened = true })
        infoSection:Divider()
        infoSection:Paragraph({
            Title = "关于",
            Desc = "圣奥里脚本\n半成品\n国内免费最佳\n成品认准wdfex",
            ThumbnailSize = 190,
        })
        local infoSection2 = infoTab:Section({ Title = "更新公告", Icon = "bell", Opened = true })
        infoSection2:Divider()
        infoSection2:Paragraph({
            Title = "v2.0提示",
            Desc = "圣奥里专用脚本\n添加了杀戮光环+自瞄+子追等功能",
            ThumbnailSize = 190,
        })
        infoTab:Select()

        local MainSection = Window:Section({ Title = "主功能", Opened = true })

        local function AddTab(section, title, icon)
            return section:Tab({ Title = title, Icon = icon })
        end

        local A = AddTab(MainSection, "玩家修改", "user")
        local B = AddTab(MainSection, "枪械功能", "target")
        local C = AddTab(MainSection, "杀戮光环", "skull")
        local D = AddTab(MainSection, "传送点", "map-pin")
        local E = AddTab(MainSection, "透视", "eye")

        local OtherSection = Window:Section({ Title = "其他功能", Opened = true })
        local F = AddTab(OtherSection, "开发者功能", "code")
        local G = AddTab(OtherSection, "设置", "settings")

        -- ============================================================
        -- 玩家修改 Tab
        -- ============================================================
        local function ApplyHitbox()
            if isDestroyed or not Settings.HitboxEnabled then return end
            local players = Players:GetPlayers()
            local newAffected = {}
            for i = 1, #players do
                local p = players[i]
                if p ~= lp and p.Character then
                    if Settings.WhitelistEnabled and Whitelist[p.UserId] then
                    else
                        local char = p.Character
                        local head = char:FindFirstChild("Head")
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 and head then
                            head.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
                            head.Transparency = 1
                            head.Color = Color3.fromRGB(255, 215, 0)
                            head.Material = Enum.Material.Neon
                            head.CanCollide = false
                            newAffected[head] = true
                        end
                    end
                end
            end
            for head, _ in pairs(affectedHeads) do
                if not newAffected[head] and head and head.Parent then
                    head.Size = Vector3.new(2, 1, 1)
                    head.Transparency = 0
                    head.CanCollide = true
                    head.Color = Color3.new(1, 1, 1)
                    head.Material = Enum.Material.Plastic
                end
            end
            affectedHeads = newAffected
        end

        local function ResetHitbox()
            for head, _ in pairs(affectedHeads) do
                if head and head.Parent then
                    head.Size = Vector3.new(2, 1, 1)
                    head.Transparency = 0
                    head.CanCollide = true
                    head.Color = Color3.new(1, 1, 1)
                    head.Material = Enum.Material.Plastic
                end
            end
            affectedHeads = {}
        end

        local function UpdateWhitelist()
            if isDestroyed then return end
            Whitelist = {}
            local players = Players:GetPlayers()
            for i = 1, #players do
                local p = players[i]
                if p ~= lp then
                    pcall(function()
                        if p:IsFriendsWith(lp.UserId) then
                            Whitelist[p.UserId] = true
                        end
                    end)
                end
            end
        end

        local interactEnabled = false
        A:Divider({ Text = "快速互动" })
        A:Toggle({
            Title = "启用快速互动",
            Value = false,
            Callback = function(value)
                interactEnabled = value
                if value then
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") then
                            obj.HoldDuration = Settings.HoldTime
                            obj.MaxActivationDistance = Settings.Distance
                        end
                    end
                end
            end
        })
        A:Slider({
            Title = "按住时间",
            Step = 0.1,
            Value = { Min = 0, Max = 10, Default = 0 },
            Callback = function(value)
                Settings.HoldTime = value
                if interactEnabled then
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") then
                            obj.HoldDuration = value
                        end
                    end
                end
            end
        })
        A:Slider({
            Title = "触发距离",
            Step = 1,
            Value = { Min = 5, Max = 150, Default = 25 },
            Callback = function(value)
                Settings.Distance = value
                if interactEnabled then
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") then
                            obj.MaxActivationDistance = value
                        end
                    end
                end
            end
        })

        A:Divider({ Text = "伤害免疫" })
        local godOn = false
        A:Toggle({
            Title = "免疫部分伤害",
            Value = false,
            Callback = function(value)
                godOn = value
            end
        })
        A:Paragraph({ Title = "说明", Desc = "免疫火焰和车爆炸时候的伤害" })

        A:Divider({ Text = "角色修改" })
        local FlySpeed = 35
        local flyState = { enabled = false, hrp = nil, hum = nil, microThread = nil, healthThread = nil, diedConn = nil, targetPos = nil, lastTime = 0 }
        local flyAnchor = { active = false, head = nil, hrp = nil, hum = nil, rayLength = 3.5, rayCount = 12, verticalLayers = 3 }
        local FlyControl
        task.spawn(function()
            pcall(function()
                local pm = lp.PlayerScripts:FindFirstChild("PlayerModule")
                if pm then FlyControl = require(pm):GetControls() end
            end)
        end)

        local function flyRefreshParts()
            local char = lp.Character
            if not char then flyState.hrp = nil flyState.hum = nil flyAnchor.hrp = nil flyAnchor.head = nil flyAnchor.hum = nil return end
            flyState.hrp = char:FindFirstChild("HumanoidRootPart")
            flyState.hum = char:FindFirstChildOfClass("Humanoid")
            flyAnchor.hrp = flyState.hrp
            flyAnchor.head = char:FindFirstChild("Head")
            flyAnchor.hum = flyState.hum
        end

        local function flyDetectWall()
            local hrp = flyAnchor.hrp
            if not hrp then return false end
            local pos = hrp.Position
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Blacklist
            params.FilterDescendantsInstances = { lp.Character }
            for i = 1, flyAnchor.rayCount do
                local angle = (i / flyAnchor.rayCount) * 2 * math.pi
                local dx = math.cos(angle)
                local dz = math.sin(angle)
                for j = -(flyAnchor.verticalLayers - 1) // 2, (flyAnchor.verticalLayers - 1) // 2 do
                    local dir = Vector3.new(dx, j * 0.5, dz).Unit
                    local result = workspace:Raycast(pos, dir * flyAnchor.rayLength, params)
                    if result and result.Instance and result.Instance.CanCollide and result.Instance.Transparency < 0.9 then
                        return true
                    end
                end
            end
            return false
        end

        local function flyEnterAnchor()
            if flyAnchor.active then return end
            if not flyAnchor.head or not flyAnchor.hrp or not flyAnchor.hum then return end
            flyAnchor.head.Anchored = true
            flyAnchor.hum.PlatformStand = true
            flyAnchor.active = true
        end

        local function flyExitAnchor()
            if not flyAnchor.active then return end
            if flyAnchor.head and flyAnchor.hum then
                flyAnchor.head.Anchored = false
                flyAnchor.hum.PlatformStand = false
            end
            flyAnchor.active = false
        end

        local function flyMicroStepLoop()
            flyState.targetPos = flyState.hrp.Position
            flyState.lastTime = tick()
            while flyState.enabled do
                local now = tick()
                local dt = now - flyState.lastTime
                flyState.lastTime = now
                if not flyState.hrp or not flyState.hrp.Parent then break end
                local inWall = flyDetectWall()
                if inWall and not flyAnchor.active then
                    flyEnterAnchor()
                elseif not inWall and flyAnchor.active then
                    flyExitAnchor()
                end
                local moveDir
                if FlyControl then
                    local mv = FlyControl:GetMoveVector()
                    local cf = workspace.CurrentCamera.CFrame
                    moveDir = (cf.LookVector * -mv.Z) + (cf.RightVector * mv.X)
                else
                    moveDir = (flyState.hum and flyState.hum.MoveDirection) or Vector3.zero
                end
                local vertical = 0
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    vertical = 1
                elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    vertical = -1
                end
                local delta = (moveDir + Vector3.new(0, vertical, 0)) * FlySpeed * dt
                flyState.targetPos = flyState.targetPos + delta
                local currentPos = flyState.hrp.Position
                local remaining = flyState.targetPos - currentPos
                local distance = remaining.Magnitude
                if distance > 0 then
                    local steps = math.ceil(distance / 10)
                    local stepVec = remaining / steps
                    for i = 1, steps do
                        if not flyState.enabled then break end
                        currentPos = currentPos + stepVec
                        flyState.hrp.CFrame = CFrame.new(currentPos) * flyState.hrp.CFrame.Rotation
                        flyState.hrp.Velocity = Vector3.zero
                    end
                else
                    flyState.hrp.CFrame = CFrame.new(flyState.targetPos) * flyState.hrp.CFrame.Rotation
                    flyState.hrp.Velocity = Vector3.zero
                end
                if flyState.hum then
                    flyState.hum:ChangeState(Enum.HumanoidStateType.Climbing)
                end
                task.wait(0.001)
            end
        end

        local function flyHealthLockLoop()
            while flyState.enabled do
                if flyState.hum and flyState.hum.Health <= 0 then
                    flyState.hum.Health = flyState.hum.MaxHealth
                end
                task.wait(0.1)
            end
        end

        local function startFly()
            if flyState.enabled then return end
            flyRefreshParts()
            if not flyState.hrp or not flyState.hum then return end
            flyState.enabled = true
            flyState.hum:ChangeState(Enum.HumanoidStateType.Climbing)
            flyState.microThread = task.spawn(flyMicroStepLoop)
            flyState.healthThread = task.spawn(flyHealthLockLoop)
            flyState.diedConn = flyState.hum.Died:Connect(function()
                if flyState.hum and flyState.enabled then
                    flyState.hum.Health = flyState.hum.MaxHealth
                    flyState.hum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
        end

        local function stopFly()
            flyState.enabled = false
            flyExitAnchor()
            if flyState.microThread then task.cancel(flyState.microThread) flyState.microThread = nil end
            if flyState.healthThread then task.cancel(flyState.healthThread) flyState.healthThread = nil end
            if flyState.diedConn then flyState.diedConn:Disconnect() flyState.diedConn = nil end
            if flyState.hum then flyState.hum:ChangeState(Enum.HumanoidStateType.Running) end
        end

        lp.CharacterAdded:Connect(function()
            if flyState.enabled then
                stopFly()
                task.wait(0.2)
                startFly()
            end
        end)

        A:Toggle({
            Title = "飞行（绕过）",
            Value = false,
            Callback = function(value)
                if value then startFly() else stopFly() end
            end
        })
        A:Slider({
            Title = "飞行速度",
            Step = 1,
            Value = { Min = 10, Max = 620, Default = 35 },
            Callback = function(value)
                FlySpeed = value
            end
        })

        A:Divider({ Text = "穿墙" })
        A:Toggle({
            Title = "启用人物穿墙",
            Value = false,
            Callback = function(value)
                Settings.NoclipEnabled = value
                if value then
                    local char = lp.Character
                    if char then
                        for _, part in ipairs(char:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                else
                    local char = lp.Character
                    if char then
                        for _, part in ipairs(char:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = true
                            end
                        end
                    end
                end
            end
        })

        A:Divider({ Text = "移速" })
        local speedBypassOn = false
        local speedBypassValue = 20
        A:Toggle({
            Title = "修改移速（绕过）",
            Value = false,
            Callback = function(value)
                speedBypassOn = value
            end
        })
        A:Slider({
            Title = "移速",
            Step = 1,
            Value = { Min = 5, Max = 150, Default = 20 },
            Callback = function(value)
                speedBypassValue = value
            end
        })
        RunService.Heartbeat:Connect(function(dt)
            if not speedBypassOn then return end
            local char = lp.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if hum and root and hum.MoveDirection.Magnitude > 0 then
                root.CFrame = root.CFrame + hum.MoveDirection * speedBypassValue * dt
            end
        end)

        A:Divider({ Text = "体力" })
        local staminaOn = false
        local StaminaEvent
        pcall(function()
            StaminaEvent = ReplicatedStorage:WaitForChild("Remote", 5):WaitForChild("PlayerEvent", 5)
        end)
        if StaminaEvent then
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                local args = {...}
                if self == StaminaEvent and method == "FireServer" then
                    if args[1] == "setStaminaOrFood" and args[2] == "stamina" and staminaOn then
                        args[3] = 100
                        return oldNamecall(self, unpack(args))
                    end
                    if args[1] == "takeDamage" and godOn then
                        return
                    end
                end
                return oldNamecall(self, ...)
            end)
        end
        task.spawn(function()
            while not isDestroyed do
                if staminaOn and StaminaEvent then
                    pcall(function()
                        StaminaEvent:FireServer("setStaminaOrFood", "stamina", 100)
                    end)
                end
                task.wait(0.3)
            end
        end)
        A:Toggle({
            Title = "无限体力",
            Value = false,
            Callback = function(value)
                staminaOn = value
            end
        })

        A:Divider({ Text = "防甩飞" })
        A:Toggle({
            Title = "防甩飞",
            Desc = "防止被其他脚本甩飞",
            Value = false,
            Callback = function(value)
                _G.CatAntiFling_Enabled = value
            end
        })

        A:Divider({ Text = "飞天快捷开关" })
        local flyQuickToggle = false
        local flyQuickScreenGui = nil
        local flyQuickButton = nil
        local flyQuickStatusLabel = nil

        local function DestroyFlyQuickToggle()
            if flyQuickScreenGui then
                flyQuickScreenGui:Destroy()
                flyQuickScreenGui = nil
                flyQuickButton = nil
                flyQuickStatusLabel = nil
            end
        end

        local function CreateFlyQuickToggle()
            if flyQuickButton then return end
            flyQuickScreenGui = Instance.new("ScreenGui")
            flyQuickScreenGui.Name = "FlyQuickToggle"
            flyQuickScreenGui.ResetOnSpawn = false
            flyQuickScreenGui.Parent = lp:WaitForChild("PlayerGui")

            local button = Instance.new("ImageButton")
            button.Size = UDim2.new(0, 60, 0, 60)
            button.Position = UDim2.new(0.5, -30, 0.15, 0)
            button.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
            button.BackgroundTransparency = 0.15
            button.BorderSizePixel = 2
            button.BorderColor3 = Color3.fromRGB(100, 200, 255)
            button.Image = "rbxassetid://7734068321"
            button.ImageColor3 = Color3.fromRGB(100, 200, 255)
            button.ScaleType = Enum.ScaleType.Fit
            button.Parent = flyQuickScreenGui
            flyQuickButton = button

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = button

            flyQuickStatusLabel = Instance.new("TextLabel")
            flyQuickStatusLabel.Size = UDim2.new(1, 0, 0, 20)
            flyQuickStatusLabel.Position = UDim2.new(0, 0, 1, 0)
            flyQuickStatusLabel.BackgroundTransparency = 1
            flyQuickStatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            flyQuickStatusLabel.TextSize = 12
            flyQuickStatusLabel.Font = Enum.Font.GothamBold
            flyQuickStatusLabel.TextStrokeTransparency = 0.3
            flyQuickStatusLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            flyQuickStatusLabel.Text = "飞行: 关"
            flyQuickStatusLabel.Parent = button

            local function updateFlyStatus()
                if flyQuickStatusLabel then
                    flyQuickStatusLabel.Text = flyState.enabled and "飞行: 开" or "飞行: 关"
                    if flyQuickButton then
                        flyQuickButton.BorderColor3 = flyState.enabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 200, 255)
                        flyQuickButton.ImageColor3 = flyState.enabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 200, 255)
                    end
                end
            end

            button.MouseButton1Click:Connect(function()
                if flyState.enabled then stopFly() else startFly() end
                updateFlyStatus()
            end)

            local dragging = false
            local dragStart = nil
            local startPos = nil

            button.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    dragStart = input.Position
                    startPos = button.Position
                end
            end)

            button.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local delta = input.Position - dragStart
                    local newPos = UDim2.new(
                        startPos.X.Scale + delta.X / lp:WaitForChild("PlayerGui").AbsoluteSize.X,
                        startPos.X.Offset + delta.X,
                        startPos.Y.Scale + delta.Y / lp:WaitForChild("PlayerGui").AbsoluteSize.Y,
                        startPos.Y.Offset + delta.Y
                    )
                    button.Position = newPos
                end
            end)

            button.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            updateFlyStatus()

            local statusConn = RunService.Heartbeat:Connect(function()
                if flyQuickToggle and flyQuickStatusLabel then
                    updateFlyStatus()
                end
            end)
            table.insert(connections, statusConn)
        end

        A:Toggle({
            Title = "飞天快捷开关",
            Desc = "开启后在屏幕显示可拖动的飞天开关",
            Value = false,
            Callback = function(value)
                flyQuickToggle = value
                if value then
                    CreateFlyQuickToggle()
                else
                    DestroyFlyQuickToggle()
                end
            end
        })

        -- ============================================================
        -- 枪械功能 Tab
        -- ============================================================
        B:Divider({ Text = "枪械强化" })
        B:Toggle({
            Title = "超快射速",
            Value = false,
            Callback = function(value)
                if not value then return end
                local function ModifyWeaponStats()
                    local garbage = getgc(true)
                    for _, tbl in pairs(garbage) do
                        if type(tbl) == "table" then
                            if rawget(tbl, "SHOOT_MODE") then
                                rawset(tbl, "SHOOT_MODE", 2)
                            end
                            if rawget(tbl, "RPM") then
                                rawset(tbl, "RPM", math.huge)
                            end
                            if rawget(tbl, "DAMAGE") then
                                rawset(tbl, "DAMAGE", math.huge)
                            end
                        end
                    end
                end
                ModifyWeaponStats()
                local char = lp.Character
                if char then
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.Died:Connect(ModifyWeaponStats)
                    end
                end
                WindUI:Notify({ Title = "武器强化", Content = "无限射速已生效，死亡后自动重新生效", Duration = 3 })
            end
        })

        local infAmmoEnabled = false
        B:Toggle({
            Title = "无限子弹",
            Value = false,
            Callback = function(value)
                infAmmoEnabled = value
            end
        })
        task.spawn(function()
            while not isDestroyed do
                if infAmmoEnabled then
                    local characterFolder = Workspace:FindFirstChild("Characters") and Workspace.Characters:FindFirstChild(lp.Name)
                    if characterFolder then
                        for _, gun in ipairs(characterFolder:GetChildren()) do
                            local config = gun:FindFirstChild("Config")
                            if config then
                                local ammo = config:FindFirstChild("Ammo")
                                local totalAmmo = config:FindFirstChild("TotalAmmo")
                                if ammo then ammo.Value = math.huge end
                                if totalAmmo then totalAmmo.Value = math.huge end
                            end
                        end
                    end
                end
                RunService.Heartbeat:Wait()
            end
        end)

        B:Divider({ Text = "碰撞箱扩展" })
        B:Toggle({
            Title = "启用头部碰撞箱（推荐20-25）",
            Value = false,
            Callback = function(value)
                Settings.HitboxEnabled = value
                if value then ApplyHitbox() else ResetHitbox() end
            end
        })
        B:Slider({
            Title = "头部大小",
            Step = 1,
            Value = { Min = 5, Max = 400, Default = 10 },
            Callback = function(value)
                Settings.HitboxSize = value
                if Settings.HitboxEnabled then ApplyHitbox() end
            end
        })
        B:Toggle({
            Title = "好友检测 (白名单)",
            Value = false,
            Callback = function(value)
                Settings.WhitelistEnabled = value
                if value then UpdateWhitelist() end
            end
        })

        B:Divider({ Text = "子追" })
        local zzEnabled = false
        local zzDistance = 40
        local zzAffected = nil

        local function zzRestore()
            if zzAffected and zzAffected.Parent then
                pcall(function()
                    zzAffected.Size = Vector3.new(2, 1, 1)
                    zzAffected.Transparency = 0
                end)
            end
            zzAffected = nil
        end

        task.spawn(function()
            while not isDestroyed do
                if zzEnabled then
                    local char = lp.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    local best, bestDist = nil, zzDistance
                    if root then
                        for _, p in ipairs(Players:GetPlayers()) do
                            if p ~= lp and p.Character then
                                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                                local head = p.Character:FindFirstChild("Head")
                                if hum and hum.Health > 0 and head then
                                    local d = (head.Position - root.Position).Magnitude
                                    if d < bestDist then
                                        bestDist = d
                                        best = head
                                    end
                                end
                            end
                        end
                    end
                    if best ~= zzAffected then
                        zzRestore()
                        if best then
                            zzAffected = best
                            pcall(function()
                                best.Size = Vector3.new(500, 500, 500)
                                best.Transparency = 1
                                best.CanCollide = false
                            end)
                        end
                    end
                else
                    zzRestore()
                end
                task.wait(0.2)
            end
        end)

        B:Toggle({
            Title = "启用子追",
            Value = false,
            Callback = function(value)
                zzEnabled = value
                if not value then zzRestore() end
            end
        })
        B:Slider({
            Title = "判定距离",
            Step = 1,
            Value = { Min = 0, Max = 1000, Default = 40 },
            Callback = function(value)
                zzDistance = value
            end
        })

        B:Divider({ Text = "自瞄" })
        local aimOn = false
        local aimFOV = 150
        local aimNoTeam = true
        local aimWall = true
        local aimGui, aimCircle

        local function aimEnsureCircle()
            if aimGui then return end
            aimGui = Instance.new("ScreenGui")
            aimGui.Name = "SA_AimFOV"
            aimGui.ResetOnSpawn = false
            aimGui.IgnoreGuiInset = true
            aimGui.Parent = lp:WaitForChild("PlayerGui")
            aimCircle = Instance.new("Frame")
            aimCircle.AnchorPoint = Vector2.new(0.5, 0.5)
            aimCircle.Position = UDim2.fromScale(0.5, 0.5)
            aimCircle.BackgroundTransparency = 1
            aimCircle.Parent = aimGui
            local stroke = Instance.new("UIStroke")
            stroke.Thickness = 1.5
            stroke.Color = Color3.fromRGB(255, 255, 255)
            stroke.Transparency = 0.4
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke.Parent = aimCircle
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = aimCircle
        end

        RunService.RenderStepped:Connect(function()
            if not aimOn then
                if aimGui then aimGui.Enabled = false end
                return
            end
            aimEnsureCircle()
            aimGui.Enabled = true
            aimCircle.Size = UDim2.fromOffset(aimFOV * 2, aimFOV * 2)
            local camera = workspace.CurrentCamera
            if not camera then return end
            local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
            local best, bestDist = nil, aimFOV
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= lp and p.Character then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    local head = p.Character:FindFirstChild("Head")
                    if hum and hum.Health > 0 and head then
                        local skip = aimNoTeam and p.Team ~= nil and lp.Team ~= nil and p.Team == lp.Team
                        if not skip then
                            local sp, onScreen = camera:WorldToViewportPoint(head.Position)
                            if onScreen then
                                local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                                if d < bestDist then
                                    local visible = true
                                    if aimWall then
                                        local rp = RaycastParams.new()
                                        rp.FilterType = Enum.RaycastFilterType.Exclude
                                        rp.FilterDescendantsInstances = { lp.Character }
                                        local res = Workspace:Raycast(camera.CFrame.Position, (head.Position - camera.CFrame.Position).Unit * 500, rp)
                                        visible = (not res) or res.Instance:IsDescendantOf(p.Character)
                                    end
                                    if visible then
                                        bestDist = d
                                        best = head
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if best then
                camera.CFrame = CFrame.lookAt(camera.CFrame.Position, best.Position)
            end
        end)

        B:Toggle({
            Title = "自瞄",
            Value = false,
            Callback = function(value)
                aimOn = value
            end
        })
        B:Slider({
            Title = "FOV圈大小",
            Step = 1,
            Value = { Min = 30, Max = 400, Default = 150 },
            Callback = function(value)
                aimFOV = value
            end
        })
        B:Toggle({
            Title = "不瞄准队友",
            Value = true,
            Callback = function(value)
                aimNoTeam = value
            end
        })
        B:Toggle({
            Title = "墙壁检测",
            Value = true,
            Callback = function(value)
                aimWall = value
            end
        })

        -- ============================================================
        -- 杀戮光环 Tab
        -- ============================================================
        local KA_GUN_MAX_DISTANCE = 300
        local KA_GUN_WALL_CHECK = true
        local kaGunEnabled = false
        local KAGunNearestOnly = false
        local KA_GUN_NEAREST_DISTANCE = 25
        local KAGunTargetPoliceOnly = false
        local KAGunTargetCivilianOnly = false
        local KAGunIgnoreDead = true

        local function kaGunIsVisible(targetHead)
            local char = lp.Character
            if not char then return false end
            local myHead = char:FindFirstChild("Head")
            if not myHead then return false end
            local direction = targetHead.Position - myHead.Position
            local distance = direction.Magnitude
            if distance < 0.1 then return true end
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {char, targetHead.Parent}
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            return Workspace:Raycast(myHead.Position, direction.Unit * distance, rayParams) == nil
        end

        local function kaGunGetNearestEnemy()
            local char = lp.Character
            if not char then return nil end
            local myHead = char:FindFirstChild("Head")
            if not myHead then return nil end
            local bestPlayer, bestDist = nil, KA_GUN_MAX_DISTANCE

            local function isTargetAllowed(p)
                if KAGunTargetPoliceOnly and KAGunTargetCivilianOnly then return false end
                local teamName = p.Team and p.Team.Name or ""
                local isPolice = teamName:find("警察") or teamName:find("Police") or teamName:find("Cop")
                if KAGunTargetPoliceOnly then
                    if not isPolice then return false end
                end
                if KAGunTargetCivilianOnly then
                    local isCivilian = teamName == "" or teamName:find("平民") or teamName:find("Citizen") or teamName:find("圣奥里公民")
                    local hasJob = teamName:find("火焰") or teamName:find("医疗") or teamName:find("道路") or teamName:find("消防") or teamName:find("军人") or teamName:find("黑帮") or teamName:find("送货")
                    if not isCivilian or hasJob then return false end
                end
                if KAGunIgnoreDead then
                    local hum = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
                    if not hum or hum.Health <= 0 then return false end
                end
                return true
            end

            if KAGunNearestOnly then
                local nearestInRange = nil
                local nearestDistInRange = 9999
                local anyEnemy = nil
                local anyDist = 9999
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= lp and p.Character then
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            local head = p.Character:FindFirstChild("Head")
                            if head and isTargetAllowed(p) then
                                local dist = (head.Position - myHead.Position).Magnitude
                                if dist < anyDist and (not KA_GUN_WALL_CHECK or kaGunIsVisible(head)) then
                                    anyDist = dist
                                    anyEnemy = p
                                end
                                if dist <= KA_GUN_NEAREST_DISTANCE and dist < nearestDistInRange and (not KA_GUN_WALL_CHECK or kaGunIsVisible(head)) then
                                    nearestDistInRange = dist
                                    nearestInRange = p
                                end
                            end
                        end
                    end
                end
                if nearestInRange then return nearestInRange else return anyEnemy end
            end

            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= lp and p.Character then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local head = p.Character:FindFirstChild("Head")
                        if head and isTargetAllowed(p) then
                            local dist = (head.Position - myHead.Position).Magnitude
                            if dist < bestDist and (not KA_GUN_WALL_CHECK or kaGunIsVisible(head)) then
                                bestDist = dist
                                bestPlayer = p
                            end
                        end
                    end
                end
            end
            return bestPlayer
        end

        RunService.Heartbeat:Connect(function()
            if not isDestroyed and kaGunEnabled then
                local target = kaGunGetNearestEnemy()
                local targetHead = target and target.Character and target.Character:FindFirstChild("Head")
                if targetHead then
                    local myHead = lp.Character and lp.Character:FindFirstChild("Head")
                    if myHead then
                        local origin = myHead.Position
                        local hitPos = targetHead.Position
                        local direction = (hitPos - origin).Unit
                        local damage = 300
                        pcall(function()
                            ReplicatedStorage.Remote.PlayerEvent:FireServer("damage", {
                                bodyParts = { { "Head", damage } },
                                shotCode = { origin, direction },
                                target = target,
                                pos = hitPos
                            })
                        end)
                        pcall(function()
                            local handleShots = ReplicatedStorage:FindFirstChild("Events")
                            handleShots = handleShots and handleShots:FindFirstChild("HandleShots")
                            if handleShots then
                                handleShots:FireServer("2", "Shoot")
                            end
                        end)
                    end
                end
            end
        end)

        C:Divider({ Text = "杀戮光环（枪）" })
        C:Paragraph({ Title = "注意", Desc = "需装备枪械武器才有伤害" })
        C:Toggle({
            Title = "启用杀戮光环（枪）",
            Value = false,
            Callback = function(value)
                kaGunEnabled = value
            end
        })
        C:Slider({
            Title = "攻击距离",
            Step = 1,
            Value = { Min = 50, Max = 1000, Default = 300 },
            Callback = function(value)
                KA_GUN_MAX_DISTANCE = value
            end
        })
        C:Toggle({
            Title = "墙体检测",
            Value = true,
            Callback = function(value)
                KA_GUN_WALL_CHECK = value
            end
        })

        C:Divider({ Text = "过滤" })
        C:Toggle({
            Title = "只攻击警察",
            Value = false,
            Callback = function(value)
                KAGunTargetPoliceOnly = value
                if value and KAGunTargetCivilianOnly then
                    KAGunTargetCivilianOnly = false
                end
            end
        })
        C:Toggle({
            Title = "只攻击平民",
            Value = false,
            Callback = function(value)
                KAGunTargetCivilianOnly = value
                if value and KAGunTargetPoliceOnly then
                    KAGunTargetPoliceOnly = false
                end
            end
        })
        C:Toggle({
            Title = "不攻击血量为0的玩家",
            Value = true,
            Callback = function(value)
                KAGunIgnoreDead = value
            end
        })

        C:Divider({ Text = "优先攻击" })
        C:Toggle({
            Title = "优先攻击最近目标",
            Value = false,
            Callback = function(value)
                KAGunNearestOnly = value
            end
        })
        C:Slider({
            Title = "优先攻击距离",
            Step = 1,
            Value = { Min = 5, Max = 100, Default = 25 },
            Callback = function(value)
                KA_GUN_NEAREST_DISTANCE = value
            end
        })

        -- 杀戮光环（刀）
        local KA_MELEE_MAX_DISTANCE = 300
        local KA_MELEE_WALL_CHECK = true
        local kaMeleeEnabled = false
        local KAMeleeNearestOnly = false
        local KA_MELEE_NEAREST_DISTANCE = 25
        local KAMeleeTargetPoliceOnly = false
        local KAMeleeTargetCivilianOnly = false
        local KAMeleeIgnoreDead = true

        local function kaMeleeIsVisible(targetHead)
            local char = lp.Character
            if not char then return false end
            local myHead = char:FindFirstChild("Head")
            if not myHead then return false end
            local direction = targetHead.Position - myHead.Position
            local distance = direction.Magnitude
            if distance < 0.1 then return true end
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {char, targetHead.Parent}
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            return Workspace:Raycast(myHead.Position, direction.Unit * distance, rayParams) == nil
        end

        local function kaMeleeGetNearestEnemy()
            local char = lp.Character
            if not char then return nil end
            local myHead = char:FindFirstChild("Head")
            if not myHead then return nil end
            local bestPlayer, bestDist = nil, KA_MELEE_MAX_DISTANCE

            local function isTargetAllowed(p)
                if KAMeleeTargetPoliceOnly and KAMeleeTargetCivilianOnly then return false end
                local teamName = p.Team and p.Team.Name or ""
                local isPolice = teamName:find("警察") or teamName:find("Police") or teamName:find("Cop")
                if KAMeleeTargetPoliceOnly then
                    if not isPolice then return false end
                end
                if KAMeleeTargetCivilianOnly then
                    local isCivilian = teamName == "" or teamName:find("平民") or teamName:find("Citizen") or teamName:find("圣奥里公民")
                    local hasJob = teamName:find("火焰") or teamName:find("医疗") or teamName:find("道路") or teamName:find("消防") or teamName:find("军人") or teamName:find("黑帮") or teamName:find("送货")
                    if not isCivilian or hasJob then return false end
                end
                if KAMeleeIgnoreDead then
                    local hum = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
                    if not hum or hum.Health <= 0 then return false end
                end
                return true
            end

            if KAMeleeNearestOnly then
                local nearestInRange = nil
                local nearestDistInRange = 9999
                local anyEnemy = nil
                local anyDist = 9999
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= lp and p.Character then
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            local head = p.Character:FindFirstChild("Head")
                            if head and isTargetAllowed(p) then
                                local dist = (head.Position - myHead.Position).Magnitude
                                if dist < anyDist and (not KA_MELEE_WALL_CHECK or kaMeleeIsVisible(head)) then
                                    anyDist = dist
                                    anyEnemy = p
                                end
                                if dist <= KA_MELEE_NEAREST_DISTANCE and dist < nearestDistInRange and (not KA_MELEE_WALL_CHECK or kaMeleeIsVisible(head)) then
                                    nearestDistInRange = dist
                                    nearestInRange = p
                                end
                            end
                        end
                    end
                end
                if nearestInRange then return nearestInRange else return anyEnemy end
            end

            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= lp and p.Character then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local head = p.Character:FindFirstChild("Head")
                        if head and isTargetAllowed(p) then
                            local dist = (head.Position - myHead.Position).Magnitude
                            if dist < bestDist and (not KA_MELEE_WALL_CHECK or kaMeleeIsVisible(head)) then
                                bestDist = dist
                                bestPlayer = p
                            end
                        end
                    end
                end
            end
            return bestPlayer
        end

        RunService.Heartbeat:Connect(function()
            if not isDestroyed and kaMeleeEnabled then
                local target = kaMeleeGetNearestEnemy()
                local targetHead = target and target.Character and target.Character:FindFirstChild("Head")
                if targetHead then
                    local myHead = lp.Character and lp.Character:FindFirstChild("Head")
                    if myHead then
                        local origin = myHead.Position
                        local hitPos = targetHead.Position
                        local direction = (hitPos - origin).Unit
                        local damage = 300
                        pcall(function()
                            ReplicatedStorage.Remote.PlayerEvent:FireServer("damage", {
                                bodyParts = { { "Head", damage } },
                                shotCode = { origin, direction },
                                target = target,
                                pos = hitPos
                            })
                        end)
                        pcall(function()
                            local meleeEvent = ReplicatedStorage:FindFirstChild("Melee")
                            if meleeEvent then
                                meleeEvent:FireServer()
                            end
                        end)
                    end
                end
            end
        end)

        C:Divider({ Text = "杀戮光环（刀）" })
        C:Paragraph({ Title = "注意", Desc = "需装备近战武器（刀/长戟等）才有伤害" })
        C:Toggle({
            Title = "启用杀戮光环（刀）",
            Value = false,
            Callback = function(value)
                kaMeleeEnabled = value
            end
        })
        C:Slider({
            Title = "攻击距离",
            Step = 1,
            Value = { Min = 50, Max = 1000, Default = 300 },
            Callback = function(value)
                KA_MELEE_MAX_DISTANCE = value
            end
        })
        C:Toggle({
            Title = "墙体检测",
            Value = true,
            Callback = function(value)
                KA_MELEE_WALL_CHECK = value
            end
        })

        C:Divider({ Text = "过滤" })
        C:Toggle({
            Title = "只攻击警察",
            Value = false,
            Callback = function(value)
                KAMeleeTargetPoliceOnly = value
                if value and KAMeleeTargetCivilianOnly then
                    KAMeleeTargetCivilianOnly = false
                end
            end
        })
        C:Toggle({
            Title = "只攻击平民",
            Value = false,
            Callback = function(value)
                KAMeleeTargetCivilianOnly = value
                if value and KAMeleeTargetPoliceOnly then
                    KAMeleeTargetPoliceOnly = false
                end
            end
        })
        C:Toggle({
            Title = "不攻击血量为0的玩家",
            Value = true,
            Callback = function(value)
                KAMeleeIgnoreDead = value
            end
        })

        C:Divider({ Text = "优先攻击" })
        C:Toggle({
            Title = "优先攻击最近目标",
            Value = false,
            Callback = function(value)
                KAMeleeNearestOnly = value
            end
        })
        C:Slider({
            Title = "优先攻击距离",
            Step = 1,
            Value = { Min = 5, Max = 100, Default = 25 },
            Callback = function(value)
                KA_MELEE_NEAREST_DISTANCE = value
            end
        })

        -- ============================================================
        -- 传送点 Tab
        -- ============================================================
        D:Toggle({
            Title = "启用传送",
            Value = false,
            Callback = function(value)
                Settings.TeleportEnabled = value
            end
        })

        local FIXED_TELEPORTS = {
            {n = "车辆经销商", p = Vector3.new(3719.9501953125, 3.018573522567749, -333.3118591308594)},
            {n = "医院", p = Vector3.new(3980.091064453125, 2.876060724258423, -138.79454040527344)},
            {n = "警察局", p = Vector3.new(3364.273193359375, 3.9188079834, -394.7233581542969)},
            {n = "圣奥里修车店", p = Vector3.new(2782.46875, 2.630995750427246, -418.59930419921875)},
            {n = "圣奥里银行", p = Vector3.new(3134.05419921875, 6.116048336029053, -171.36976623535156)},
            {n = "圣奥里服装店", p = Vector3.new(3617.91259765625, 3.1072206497192383, -452.8206481933594)},
            {n = "圣奥里平民重生", p = Vector3.new(3741.114990234375, 3.720573663711548, -438.1059875488281)},
            {n = "圣奥里码头", p = Vector3.new(4527.65625, -23.968238830566406, -280.59356689453125)},
            {n = "圣奥里餐饮店", p = Vector3.new(3182.416748046875, 3.01859188079834, 426.5179138183594)},
            {n = "消防部门", p = Vector3.new(3578.676025390625, 8.408823013305664, 579.6567993164062)},
            {n = "宠物店", p = Vector3.new(3678.237305, 3.017920, 693.114624)},
            {n = "圣奥里大码头", p = Vector3.new(2736.307617, 2.630299, -1120.333008)},
            {n = "圣奥里海滩桥下(消星点)", p = Vector3.new(3964.504395, -25.068211, -854.057251)},
            {n = "大景超市", p = Vector3.new(3936.582764, 3.038293, 1136.326416)},
            {n = "转镜中心", p = Vector3.new(4152.919922, 2.631675, 941.446045)},
            {n = "道路服务", p = Vector3.new(4271.332520, 2.628108, 1200.086914)},
            {n = "大景餐饮店", p = Vector3.new(4476.997559, 3.037825, 906.802979)},
            {n = "送货中心", p = Vector3.new(4399.419434, 3.038999, 1609.455933)},
            {n = "大景卖车店", p = Vector3.new(3434.377441, 42.931786, 2687.997070)},
            {n = "莱斯维尔餐饮店", p = Vector3.new(753.757812, 3.039824, 998.132996)},
            {n = "莱斯维尔服装店", p = Vector3.new(820.745117, 2.766988, 1047.445679)},
            {n = "莱斯维尔自由广场", p = Vector3.new(926.523376, 2.630995, 865.764771)},
            {n = "莱斯维尔码头(游艇)", p = Vector3.new(947.840210, -22.529087, 1216.085693)},
            {n = "米尔顿左上加油站", p = Vector3.new(1145.635742, 2.630916, -864.273682)},
            {n = "米尔顿右下加油站", p = Vector3.new(-1646.802734, 2.630164, 1812.894653)},
            {n = "米尔顿上方加油站", p = Vector3.new(-900.701660, 2.630927, 1124.683105)},
            {n = "米尔顿居民区", p = Vector3.new(-528.565552, 2.630996, 1331.981689)},
            {n = "约克镇小银行", p = Vector3.new(-668.217224, 2.630995, -65.347839)},
            {n = "约克镇修车厂", p = Vector3.new(-407.163025, 3.076807, -6.098211)},
            {n = "约克镇枪店", p = Vector3.new(-323.869293, 3.037825, 37.149670)},
            {n = "约克镇重生点", p = Vector3.new(-219.560318, 3.039824, -85.725433)},
            {n = "约克镇当铺", p = Vector3.new(-168.513733, 3.039000, -106.926529)},
            {n = "约克镇卫星车", p = Vector3.new(-302.093567, 3.037825, -167.621017)},
            {n = "约克镇中心点", p = Vector3.new(-275.995209, 2.630996, -139.985352)},
            {n = "黑市", p = Vector3.new(1038.969849, -22.732950, 895.430237)},
            {n = "渔夫码头", p = Vector3.new(-50.147552, -24.555279, 1462.145996)},
            {n = "农场", p = Vector3.new(-1268.339233, 2.572412, 2560.060303)},
            {n = "监狱门口", p = Vector3.new(-1697.931885, 2.630666, 1284.567383)},
            {n = "监狱广场", p = Vector3.new(-1600.602417, 2.631028, 1268.060059)},
            {n = "代尔山", p = Vector3.new(847.062988, 194.115753, -326.212708)},
            {n = "瀑布洞穴(消星点)", p = Vector3.new(3040.956055, 109.688538, 2711.069336)},
            {n = "大桥", p = Vector3.new(949.014954, 25.215754, 2897.654785)},
            {n = "地图右下(消星点)", p = Vector3.new(-1651.385010, 2.414712, 3225.278320)},
            {n = "下部加油站", p = Vector3.new(2270.378174, 2.630927, 154.161484)},
            {n = "游戏厅", p = Vector3.new(2934.893799, 2.956458, 1693.660034)},
            {n = "高尔夫", p = Vector3.new(2280.767090, 3.037836, 1982.357300)},
            {n = "修船厂", p = Vector3.new(4096.405273, -30.401447, 2865.045166)},
        }

        local teleNames = {}
        for _, data in ipairs(FIXED_TELEPORTS) do table.insert(teleNames, data.n) end
        local selectedTeleport = teleNames[1] or ""

        D:Dropdown({
            Title = "选定传送地点",
            Values = teleNames,
            Value = teleNames[1],
            Callback = function(value)
                selectedTeleport = value
            end
        })

        D:Button({
            Title = "传送到选定地点",
            Callback = function()
                if not Settings.TeleportEnabled then
                    WindUI:Notify({ Title = "传送", Content = "请先开启传送开关", Duration = 3 })
                    return
                end
                for _, data in ipairs(FIXED_TELEPORTS) do
                    if data.n == selectedTeleport then
                        local char = lp.Character
                        local root = char and char:FindFirstChild("HumanoidRootPart")
                        if root then
                            root.CFrame = CFrame.new(data.p)
                            WindUI:Notify({ Title = "传送", Content = "正在传送至: " .. data.n, Duration = 2 })
                        end
                        return
                    end
                end
                WindUI:Notify({ Title = "传送", Content = "未找到该地点", Duration = 2 })
            end
        })

        -- ============================================================
        -- 透视 Tab
        -- ============================================================
        local ESP_ENABLED = false
        local ESP_SHOW_NAME = true
        local ESP_SHOW_TEAM = true
        local ESP_SHOW_HEALTH = true
        local ESP_SHOW_DIST = true
        local ESP_LIST = {}
        local ESP_REFRESH_COUNT = 0

        local function GetTeam(p)
            if p.Team then return p.Team.Name end
            return "平民"
        end

        local function GetTeamColor(p)
            if p.Team then return p.Team.TeamColor.Color end
            return Color3.fromRGB(200, 200, 200)
        end

        local function GetHealth(p)
            local c = p.Character
            if not c then return 0 end
            local h = c:FindFirstChildOfClass("Humanoid")
            if not h then return 0 end
            return math.floor(h.Health)
        end

        local function GetDist(p)
            local mc = lp.Character
            if not mc then return 0 end
            local mr = mc:FindFirstChild("HumanoidRootPart")
            if not mr then return 0 end
            local tc = p.Character
            if not tc then return 0 end
            local tr = tc:FindFirstChild("HumanoidRootPart")
            if not tr then return 0 end
            return math.floor((mr.Position - tr.Position).Magnitude)
        end

        local function RemoveESP(id)
            local d = ESP_LIST[id]
            if d then
                if d.Billboard then d.Billboard:Destroy() end
                ESP_LIST[id] = nil
            end
        end

        local function BuildESP(p)
            if not p.Character or p == lp then return end
            local head = p.Character:FindFirstChild("Head")
            if not head then return end
            if ESP_LIST[p.UserId] then
                if ESP_LIST[p.UserId].Billboard then
                    ESP_LIST[p.UserId].Billboard.Enabled = true
                end
                return
            end

            local bb = Instance.new("BillboardGui")
            bb.Size = UDim2.new(0, 200, 0, 100)
            bb.StudsOffset = Vector3.new(0, 3, 0)
            bb.AlwaysOnTop = true
            bb.MaxDistance = 500
            bb.Parent = head

            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 1, 0)
            f.BackgroundTransparency = 1
            f.Parent = bb

            ESP_LIST[p.UserId] = { Billboard = bb, Frame = f }
        end

        local function RefreshESP()
            if not ESP_ENABLED then
                for _, d in pairs(ESP_LIST) do
                    if d.Billboard then d.Billboard.Enabled = false end
                end
                return
            end

            ESP_REFRESH_COUNT = ESP_REFRESH_COUNT + 1

            for _, p in ipairs(Players:GetPlayers()) do
                if p == lp then continue end
                if not p.Character then
                    RemoveESP(p.UserId)
                    continue
                end
                if ESP_REFRESH_COUNT % 30 == 0 and ESP_LIST[p.UserId] then
                    RemoveESP(p.UserId)
                end
                if not ESP_LIST[p.UserId] then
                    BuildESP(p)
                end
                local d = ESP_LIST[p.UserId]
                if not d then continue end
                if not d.Billboard or not d.Billboard.Parent then
                    ESP_LIST[p.UserId] = nil
                    BuildESP(p)
                    d = ESP_LIST[p.UserId]
                    if not d then continue end
                end
                d.Billboard.Enabled = true

                local f = d.Frame
                for _, c in ipairs(f:GetChildren()) do c:Destroy() end

                local y = 0
                local lines = 0
                local team = GetTeam(p)
                local color = GetTeamColor(p)
                local hp = GetHealth(p)
                local dist = GetDist(p)

                if ESP_SHOW_NAME then
                    local l = Instance.new("TextLabel")
                    l.Size = UDim2.new(1, 0, 0, 20)
                    l.Position = UDim2.new(0, 0, 0, y)
                    l.BackgroundTransparency = 1
                    l.Text = p.Name
                    l.TextColor3 = color
                    l.TextSize = 15
                    l.Font = Enum.Font.GothamBold
                    l.TextStrokeTransparency = 0.3
                    l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    l.TextXAlignment = Enum.TextXAlignment.Center
                    l.Parent = f
                    y = y + 22
                    lines = lines + 1
                end

                if ESP_SHOW_TEAM then
                    local l = Instance.new("TextLabel")
                    l.Size = UDim2.new(1, 0, 0, 18)
                    l.Position = UDim2.new(0, 0, 0, y)
                    l.BackgroundTransparency = 1
                    l.Text = "[" .. team .. "]"
                    l.TextColor3 = color
                    l.TextSize = 13
                    l.Font = Enum.Font.GothamBold
                    l.TextStrokeTransparency = 0.3
                    l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    l.TextXAlignment = Enum.TextXAlignment.Center
                    l.Parent = f
                    y = y + 20
                    lines = lines + 1
                end

                if ESP_SHOW_HEALTH then
                    local l = Instance.new("TextLabel")
                    l.Size = UDim2.new(1, 0, 0, 18)
                    l.Position = UDim2.new(0, 0, 0, y)
                    l.BackgroundTransparency = 1
                    local c = hp > 70 and Color3.fromRGB(0, 255, 100) or hp > 40 and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(255, 50, 50)
                    l.Text = hp .. "HP"
                    l.TextColor3 = c
                    l.TextSize = 13
                    l.Font = Enum.Font.GothamBold
                    l.TextStrokeTransparency = 0.3
                    l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    l.TextXAlignment = Enum.TextXAlignment.Center
                    l.Parent = f
                    y = y + 20
                    lines = lines + 1
                end

                if ESP_SHOW_DIST then
                    local l = Instance.new("TextLabel")
                    l.Size = UDim2.new(1, 0, 0, 18)
                    l.Position = UDim2.new(0, 0, 0, y)
                    l.BackgroundTransparency = 1
                    l.Text = dist .. "m"
                    l.TextColor3 = Color3.fromRGB(200, 200, 200)
                    l.TextSize = 13
                    l.Font = Enum.Font.Gotham
                    l.TextStrokeTransparency = 0.3
                    l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    l.TextXAlignment = Enum.TextXAlignment.Center
                    l.Parent = f
                    y = y + 20
                    lines = lines + 1
                end

                d.Billboard.Size = UDim2.new(0, 200, 0, lines * 20 + 10)
            end
        end

        E:Toggle({
            Title = "透视总开关",
            Value = false,
            Callback = function(value)
                ESP_ENABLED = value
                if value then RefreshESP() end
            end
        })
        E:Divider()
        E:Toggle({
            Title = "显示名字",
            Value = true,
            Callback = function(value)
                ESP_SHOW_NAME = value
                if ESP_ENABLED then RefreshESP() end
            end
        })
        E:Toggle({
            Title = "显示队伍",
            Value = true,
            Callback = function(value)
                ESP_SHOW_TEAM = value
                if ESP_ENABLED then RefreshESP() end
            end
        })
        E:Toggle({
            Title = "显示血量",
            Value = true,
            Callback = function(value)
                ESP_SHOW_HEALTH = value
                if ESP_ENABLED then RefreshESP() end
            end
        })
        E:Toggle({
            Title = "显示距离",
            Value = true,
            Callback = function(value)
                ESP_SHOW_DIST = value
                if ESP_ENABLED then RefreshESP() end
            end
        })

        task.spawn(function()
            while not isDestroyed do
                task.wait(0.15)
                if ESP_ENABLED then RefreshESP() end
            end
        end)
        Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function()
                task.wait(0.3)
                if ESP_ENABLED then RefreshESP() end
            end)
        end)
        Players.PlayerRemoving:Connect(function(p)
            RemoveESP(p.UserId)
        end)

        -- ============================================================
        -- 开发者功能 Tab
        -- ============================================================
        F:Divider({ Text = "坐标工具" })
        F:Button({
            Title = "开启坐标显示",
            Callback = function()
                local char = lp.Character or lp.CharacterAdded:Wait()
                local root = char:WaitForChild("HumanoidRootPart")
                local gui = Instance.new("ScreenGui")
                gui.Name = "CoordinateCopyTool"
                gui.Parent = lp:WaitForChild("PlayerGui")

                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(0, 250, 0, 100)
                frame.Position = UDim2.new(0.5, -125, 0.5, -50)
                frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                frame.Active = true
                frame.Parent = gui

                local textBox = Instance.new("TextBox")
                textBox.Size = UDim2.new(0.9, 0, 0, 30)
                textBox.Position = UDim2.new(0.05, 0, 0.15, 0)
                textBox.Text = "加载中..."
                textBox.ClearTextOnFocus = false
                textBox.TextEditable = false
                textBox.Parent = frame

                local copyBtn = Instance.new("TextButton")
                copyBtn.Size = UDim2.new(0.9, 0, 0, 35)
                copyBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
                copyBtn.Text = "点击准备复制 (Ctrl+C)"
                copyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                copyBtn.TextColor3 = Color3.new(1, 1, 1)
                copyBtn.Parent = frame

                local dragging = false
                local dragStart, startPos

                frame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        dragStart = input.Position
                        startPos = frame.Position
                    end
                end)

                frame.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local delta = input.Position - dragStart
                        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                    end
                end)

                frame.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)

                RunService.RenderStepped:Connect(function()
                    local pos = root.Position
                    local formattedPos = string.format("%.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z)
                    if not textBox:IsFocused() then
                        textBox.Text = formattedPos
                    end
                end)

                copyBtn.MouseButton1Click:Connect(function()
                    textBox:CaptureFocus()
                    textBox.SelectionStart = 1
                    textBox.CursorPosition = #textBox.Text + 1
                    copyBtn.Text = "现在按下 Ctrl + C 复制！"
                    task.wait(2)
                    copyBtn.Text = "点击准备复制 (Ctrl+C)"
                end)
            end
        })
        F:Button({
            Title = "关闭坐标显示",
            Callback = function()
                local gui = lp.PlayerGui:FindFirstChild("CoordinateCopyTool")
                if gui then gui:Destroy() end
            end
        })

        -- ============================================================
        -- 设置 Tab
        -- ============================================================
        G:Button({
            Title = "卸载脚本",
            Callback = function()
                isDestroyed = true
                stopFly()
                DestroyFlyQuickToggle()
                zzRestore()
                if aimGui then aimGui:Destroy() end
                ResetHitbox()
                if Settings.NoclipEnabled then
                    local char = lp.Character
                    if char then
                        for _, part in ipairs(char:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = true
                            end
                        end
                    end
                end
                for userId, data in pairs(ESP_LIST) do
                    if data.Billboard then data.Billboard:Destroy() end
                end
                ESP_LIST = {}
                for _, conn in ipairs(connections) do
                    pcall(function() conn:Disconnect() end)
                end
                Window:Destroy()
                WindUI:Notify({ Title = "已卸载", Content = "脚本已安全卸载", Duration = 2 })
            end
        })

        WindUI:Notify({
            Title = "wdfex-圣奥里",
            Content = "脚本已加载成功，欢迎使用！",
            Duration = 3,
        })
    end
end