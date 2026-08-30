-- ==================== 卡密验证系统 ====================
-- 验证成功后自动加载外部脚本
-- 左上角显示设备UID，验证成功显示详情弹窗

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local player = LocalPlayer
local RunService = game:GetService("RunService")

-- ==================== 工具函数 ====================
local function getDeviceUID()
    local userId = player.UserId
    local success, machineId = pcall(function()
        return game:GetService("HttpService"):GetMachineId()
    end)
    if not success then machineId = "unknown"
    end
    local combined = userId .. "_" .. machineId .. "_" .. game.GameId
    local uid = ""
    for i = 1, #combined do
        uid = uid .. string.char((string.byte(combined, i) % 26) + 65)
    end
    return uid:sub(1, 32)
end

local DEVICE_UID = getDeviceUID()

-- ==================== 100个预生成卡密 ====================
-- 格式: 卡密 = { 类型, 天数(-1为永久), 是否已使用, 绑定设备, 绑定时间 }
local KEYS_DATA = {
    -- ===== 天卡 DAY (25个) =====
    ["WDF-K4M8R2N7P9-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["WDF-X3Q6T1L5V8-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["WDF-H9J2K4M7R1-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["WDF-B5N8Q2T6X9-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["WDF-V3M7P1K4L8-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["WDF-C6H9J2R5T1-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["WDF-F4N8Q1X7K3-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["WDF-M2P6T9L4V8-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["WDF-R7K1H4N9Q2-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["WDF-X5V8M3P6T1-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["WDF-J2L4N7Q9R5-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["WDF-T6X1K3M8P2-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["WDF-H7R4V9L2N5-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["WDF-Q3M8T1X6K4-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["WDF-L5P9N2R7V3-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["WDF-K1X6T4M9J2-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["WDF-V8R3L7P1N5-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["WDF-N4Q9K2X6T1-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["WDF-M7P3V8L4R9-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["WDF-T2X5K1N7Q4-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["WDF-R9L4M8V2P6-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["WDF-J5N1X7T3K9-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["WDF-H8P2Q6L4V1-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["WDF-K3V9N5R7X2-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    ["WDF-T7M4L1P8Q6-DAY"] = { type = "天卡", days = 1, used = false, bind = nil, bindTime = nil },
    -- ===== 周卡 WEEK (25个) =====
    ["WDF-P4K9X2N7R1-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["WDF-M8V3Q6T1L5-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["WDF-J2H7R4N9P3-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["WDF-V6L1T8X4K7-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["WDF-N3Q9R5P2M8-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["WDF-X4K7T1L9V3-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["WDF-H8M2P6R4N1-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["WDF-Q5V9L3X7T2-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["WDF-R1N6P4M8K3-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["WDF-T7X2K9V5L1-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["WDF-L4M8R2N6Q9-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["WDF-V3P7T1X5K2-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["WDF-J9N4L8R2M6-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["WDF-H2T6X1K7V4-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["WDF-Q8M3P9L1N5-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["WDF-R4V7K2T9X3-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["WDF-L1N5M8P4Q7-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["WDF-X6T2R9V3K1-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["WDF-H3M7L1N8Q5-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["WDF-P9V4K2X6T8-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["WDF-N5R8M3L7P1-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["WDF-K2X9T4V6Q3-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["WDF-T8L5N1M7R4-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["WDF-V6P2K9X3L8-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    ["WDF-Q4N7R1T5M2-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil, bindTime = nil },
    -- ===== 月卡 MONTH (25个) =====
    ["WDF-R7M4N2X9P1-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["WDF-T3L8V5Q6K2-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["WDF-J9P1N4X7R3-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["WDF-M5K2T8V1L9-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["WDF-X7R3N6P4Q1-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["WDF-H2L9V4T7K8-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["WDF-Q6P1M8X3N5-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["WDF-N4K7R9T2V6-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["WDF-R8X3L5M1P9-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["WDF-T1V6N4Q8K3-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["WDF-K5M9P2X7R4-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["WDF-L3T8V1N6Q9-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["WDF-X7P4K2M9R1-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["WDF-H6N1Q5T3V8-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["WDF-R2M9X4L7P6-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["WDF-V8K3N6Q1T5-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["WDF-P4L1X9M7R2-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["WDF-T7Q2V5N3K8-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["WDF-M1R6P9L4X2-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["WDF-N8K4T2Q6V7-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["WDF-H3P7M1R9K5-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["WDF-X9V2L6N4T8-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["WDF-Q5M8P3K1R7-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["WDF-R6T4X9V2L1-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    ["WDF-K2N7M5P9Q4-MONTH"] = { type = "月卡", days = 30, used = false, bind = nil, bindTime = nil },
    -- ===== 永久卡 FOREVER (25个) =====
    ["WDF-X9N4M7K2R5-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-T6V3L8P1Q9-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-H2M9R5N7X4-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-P8K4T1V6L3-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-N5R7X2M9Q1-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-V3L8P6K2T9-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-Q7M4N1X8R6-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-K2T9V5L4P7-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-R6X3N8M1Q5-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-H4P7K9T2L6-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-M8V1X5N3R9-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-L2Q6P4K8T1-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-X5N9R3V7M2-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-T8K4P1L6Q3-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-R1M7X2N9V4-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-K6T2Q8P5L1-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-V9N4R7X3M6-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-P3L8K1T5Q7-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-M5X9V2N6R4-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-H7Q1P4L8K2-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-T3R6M9X1V5-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-N8K2L5P9Q4-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-X1V7R4M8T6-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-Q6P3K9N2L7-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-L4T8X1V6R2-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
}

-- ==================== 验证界面 ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeyValidation"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 420, 0, 280)
frame.Position = UDim2.new(0.5, -210, 0.5, -140)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(80, 180, 255)
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- ===== 左上角显示设备UID =====
local uidLabel = Instance.new("TextLabel")
uidLabel.Size = UDim2.new(1, -20, 0, 22)
uidLabel.Position = UDim2.new(0, 10, 0, 8)
uidLabel.BackgroundTransparency = 1
uidLabel.Text = "设备UID: " .. DEVICE_UID
uidLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
uidLabel.TextSize = 12
uidLabel.Font = Enum.Font.Gotham
uidLabel.TextXAlignment = Enum.TextXAlignment.Left
uidLabel.TextScaled = false
uidLabel.Parent = frame

-- ===== 标题 =====
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "wdfex 卡密验证"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = frame

-- ===== 状态提示 =====
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 28)
statusLabel.Position = UDim2.new(0, 10, 0, 80)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "请输入您的卡密"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.Parent = frame

-- ===== 输入框 =====
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(0.8, 0, 0, 38)
inputBox.Position = UDim2.new(0.1, 0, 0, 115)
inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
inputBox.BorderSizePixel = 1
inputBox.BorderColor3 = Color3.fromRGB(100, 100, 130)
inputBox.Text = ""
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.TextSize = 16
inputBox.Font = Enum.Font.Gotham
inputBox.PlaceholderText = "请输入卡密"
inputBox.ClearTextOnFocus = false
inputBox.Parent = frame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = inputBox

-- ===== 确认按钮 =====
local confirmBtn = Instance.new("TextButton")
confirmBtn.Size = UDim2.new(0.35, 0, 0, 42)
confirmBtn.Position = UDim2.new(0.325, 0, 0, 170)
confirmBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
confirmBtn.BorderSizePixel = 0
confirmBtn.Text = "确认"
confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmBtn.TextSize = 18
confirmBtn.Font = Enum.Font.GothamBold
confirmBtn.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = confirmBtn

-- ===== 底部小提示 =====
local footerLabel = Instance.new("TextLabel")
footerLabel.Size = UDim2.new(1, -20, 0, 20)
footerLabel.Position = UDim2.new(0, 10, 0, 225)
footerLabel.BackgroundTransparency = 1
footerLabel.Text = "错误3次将锁定10秒"
footerLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
footerLabel.TextSize = 11
footerLabel.Font = Enum.Font.Gotham
footerLabel.TextXAlignment = Enum.TextXAlignment.Center
footerLabel.Parent = frame

-- ==================== 成功弹窗函数 ====================
local function showSuccessPopup(keyData)
    local popupGui = Instance.new("ScreenGui")
    popupGui.Name = "SuccessPopup"
    popupGui.ResetOnSpawn = false
    popupGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    popupGui.Parent = player:WaitForChild("PlayerGui")

    local popupFrame = Instance.new("Frame")
    popupFrame.Size = UDim2.new(0, 450, 0, 240)
    popupFrame.Position = UDim2.new(0.5, -225, 0.5, -120)
    popupFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
    popupFrame.BorderSizePixel = 2
    popupFrame.BorderColor3 = Color3.fromRGB(0, 255, 100)
    popupFrame.BackgroundTransparency = 0.05
    popupFrame.Parent = popupGui

    local popupCorner = Instance.new("UICorner")
    popupCorner.CornerRadius = UDim.new(0, 14)
    popupCorner.Parent = popupFrame

    -- 成功图标
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 50, 0, 50)
    icon.Position = UDim2.new(0.5, -25, 0, 15)
    icon.BackgroundTransparency = 1
    icon.Text = "✓"
    icon.TextColor3 = Color3.fromRGB(0, 255, 100)
    icon.TextSize = 40
    icon.Font = Enum.Font.GothamBold
    icon.TextXAlignment = Enum.TextXAlignment.Center
    icon.Parent = popupFrame

    -- 验证成功标题
    local popupTitle = Instance.new("TextLabel")
    popupTitle.Size = UDim2.new(1, 0, 0, 30)
    popupTitle.Position = UDim2.new(0, 0, 0, 70)
    popupTitle.BackgroundTransparency = 1
    popupTitle.Text = "验证成功！"
    popupTitle.TextColor3 = Color3.fromRGB(0, 255, 100)
    popupTitle.TextSize = 22
    popupTitle.Font = Enum.Font.GothamB