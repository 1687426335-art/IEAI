-- ==================== 卡密验证系统 ====================
-- 验证成功后自动加载外部脚本
-- 左上角显示设备UID，验证成功后弹出5秒信息窗

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local player = LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

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
frame.Size = UDim2.new(0, 420, 0, 270)
frame.Position = UDim2.new(0.5, -210, 0.5, -135)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(80, 180, 255)
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- ===== 左上角设备UID显示 =====
local uidLabel = Instance.new("TextLabel")
uidLabel.Size = UDim2.new(0.95, 0, 0, 20)
uidLabel.Position = UDim2.new(0.025, 0, 0, 5)
uidLabel.BackgroundTransparency = 1
uidLabel.Text = "UID: " .. DEVICE_UID
uidLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
uidLabel.TextSize = 11
uidLabel.Font = Enum.Font.Gotham
uidLabel.TextXAlignment = Enum.TextXAlignment.Left
uidLabel.TextWrapped = true
uidLabel.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 28)
title.BackgroundTransparency = 1
title.Text = "wdfex 卡密验证"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 28)
statusLabel.Position = UDim2.new(0, 10, 0, 72)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "请输入您的卡密"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.Parent = frame

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(0.8, 0, 0, 38)
inputBox.Position = UDim2.new(0.1, 0, 0, 108)
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

local confirmBtn = Instance.new("TextButton")
confirmBtn.Size = UDim2.new(0.35, 0, 0, 42)
confirmBtn.Position = UDim2.new(0.325, 0, 0, 165)
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

-- 底部小字提示
local footerLabel = Instance.new("TextLabel")
footerLabel.Size = UDim2.new(1, 0, 0, 20)
footerLabel.Position = UDim2.new(0, 0, 0, 220)
footerLabel.BackgroundTransparency = 1
footerLabel.Text = "错误3次将锁定10秒 | 每次使用会绑定设备"
footerLabel.TextColor3 = Color3.fromRGB(120, 120, 150)
footerLabel.TextSize = 11
footerLabel.Font = Enum.Font.Gotham
footerLabel.TextXAlignment = Enum.TextXAlignment.Center
footerLabel.Parent = frame

-- ==================== 目标脚本URL ====================
local TARGET_SCRIPT_URL = "https://raw.githubusercontent.com/1687426335-art/IEAI/refs/heads/main/xxdsihf.lua"

-- ==================== 验证成功后弹窗 ====================
local function showSuccessPopup(keyData)
    -- 计算剩余天数
    local remainingText = ""
    if keyData.days == -1 then
        remainingText = "永久"
    else
        local elapsed = os.time() - keyData.bindTime
        local usedDays = math.floor(elapsed / 86400)
        local remaining = keyData.days - usedDays
        if remaining < 0 then remaining = 0 end
        remainingText = remaining .. " 天"
    end
    
    -- 创建弹窗Gui
    local popupGui = Instance.new("ScreenGui")
    popupGui.Name = "SuccessPopup"
    popupGui.ResetOnSpawn = false
    popupGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    popupGui.Parent = player:WaitForChild("PlayerGui")
    
    -- 半透明背景遮罩
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.5
    overlay.Parent = popupGui
    
    -- 弹窗主框
    local popupFrame = Instance.new("Frame")
    popupFrame.Size = UDim2.new(0, 450, 0, 280)
    popupFrame.Position = UDim2.new(0.5, -225, 0.5, -140)
    popupFrame.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
    popupFrame.BorderSizePixel = 2
    popupFrame.BorderColor3 = Color3.fromRGB(0, 255, 100)
    popupFrame.BackgroundTransparency = 0.05
    popupFrame.Parent = overlay
    
    local popupCorner = Instance.new("UICorner")
    popupCorner.CornerRadius = UDim.new(0, 16)
    popupCorner.Parent = popupFrame
    
    -- 成功图标/标题
    local popupTitle = Instance.new("TextLabel")
    popupTitle.Size = UDim2.new(1, 0, 0, 50)
    popupTitle.Position = UDim2.new(0, 0, 0, 10)
    popupTitle.BackgroundTransparency = 1
    popupTitle.Text = "✅ 验证成功"
    popupTitle.TextColor3 = Color3.fromRGB(0, 255, 100)
    popupTitle.TextSize = 28
    popupTitle.Font = Enum.Font.GothamBold
    popupTitle.TextXAlignment = Enum.TextXAlignment.Center
    popupTitle.Parent = popupFrame
    
    -- 信息行1: 卡密类型 + 天数
    local info1 = Instance.new("TextLabel")
    info1.Size = UDim2.new(0.9, 0, 0, 30)
    info1.Position = UDim2.new(0.05, 0, 0, 70)
    info1.BackgroundTransparency = 1
    info1.Text = "卡密类型: " .. keyData.type
    info1.TextColor3 = Color3.fromRGB(200, 220, 255)
    info1.TextSize = 16
    info1.Font = Enum.Font.Gotham
    info1.TextXAlignment = Enum.TextXAlignment.Left
    info1.Parent = popupFrame
    
    local info2 = Instance.new("TextLabel")
    info2.Size = UDim2.new(0.9, 0, 0, 30)
    info2.Position = UDim2.new(0.05, 0, 0, 105)
    info2.BackgroundTransparency = 1
    info2.Text = "剩余时长: " .. remainingText
    info2.TextColor3 = Color3.fromRGB(200, 220, 255)
    info2.TextSize = 16
    info2.Font = Enum.Font.Gotham
    info2.TextXAlignment = Enum.TextXAlignment.Left
    info2.Parent = popupFrame
    
    local info3 = Instance.new("TextLabel")
    info3.Size = UDim2.new(0.9, 0, 0, 30)
    info3.Position = UDim2.new(0.05, 0, 0, 140)
    info3.BackgroundTransparency = 1
    info3.Text = "设备UID: " .. DEVICE_UID
    info3.TextColor3 = Color3.fromRGB(150, 200, 255)
    info3.TextSize = 14
    info3.Font = Enum.Font.Gotham
    info3.TextXAlignment = Enum.TextXAlignment.Left
    info3.TextWrapped = true
    info3.Parent = popupFrame
    
    -- 倒计时提示
    local countdownLabel = Instance.new("TextLabel")
    countdownLabel.Size = UDim2.new(1, 0, 0, 30)
    countdownLabel.Position = UDim2.new(0, 0, 0, 190)
    countdownLabel.BackgroundTransparency = 1
    countdownLabel.Text = "5 秒后自动关闭并加载脚本..."
    countdownLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
    countdownLabel.TextSize = 14
    countdownLabel.Font = Enum.Font.Gotham
    countdownLabel.TextXAlignment = Enum.TextXAlignment.Center
    countdownLabel.Parent = popupFrame
    
    -- 关闭按钮
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0.3, 0, 0, 35)
    closeBtn.Position = UDim2.new(0.35, 0, 0, 230)
    closeBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "立即加载"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = popupFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn
    
    -- 倒计时
    local countdown = 5
    local popupLoaded = true
    
    local countdownConn
    countdownConn = RunService.Heartbeat:Connect(function()
        if not popupLoaded then
            countdownConn:Disconnect()
            return
        end
        countdown = countdown - 0.1
        if countdown <= 0 then
            countdownConn:Disconnect()
            if popupGui and popupGui.Parent then
                popupGui:Destroy()
            end
            loadTargetScript()
        else
            countdownLabel.Text = math.ceil(countdown) .. " 秒后自动关闭并加载脚本..."
        end
    end)
    
    -- 关闭按钮手动加载
    closeBtn.MouseButton1Click:Connect(function()
        popupLoaded = false
        if popupGui and popupGui.Parent then
            popupGui:Destroy()
        end
        if countdownConn then countdownConn:Disconnect() end
        loadTargetScript()
    end)
end

-- ==================== 加载目标脚本 ====================
local function loadTargetScript()
    local success, err = pcall(function()
        loadstring(game:HttpGet(TARGET_SCRIPT_URL))()
    end)
    
    if not success then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "加载失败",
            Text = "脚本加载失败: " .. tostring(err),
            Duration = 5,
        })
    end
end

-- ==================== 验证逻辑 ====================
local attemptCount = 0
local locked = false
local lockTimer = nil

confirmBtn.MouseButton1Click:Connect(function()
    if locked then
        statusLabel.Text = "系统锁定中，请等待..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        return
    end
    
    local input = inputBox.Text
    if input == "" then
        statusLabel.Text = "请输入卡密"
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        return
    end
    
    local keyData = KEYS_DATA[input]
    if not keyData then
        attemptCount = attemptCount + 1
        local remaining = 3 - attemptCount
        statusLabel.Text = "卡密不存在 (剩余尝试: " .. remaining .. "/3)"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        inputBox.Text = ""
        
        if attemptCount >= 3 then
            locked = true
            confirmBtn.Visible = false
            inputBox.Visible = false
            statusLabel.Text = "错误次数过多，锁定 10 秒"
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
            
            local startTime = os.time()
            lockTimer = task.spawn(function()
                while os.time() - startTime < 10 do
                    local remaining = 10 - (os.time() - startTime)
                    statusLabel.Text = "请等待 " .. remaining .. " 秒后重试"
                    task.wait(0.5)
                end
                locked = false
                attemptCount = 0
                confirmBtn.Visible = true
                inputBox.Visible = true
                statusLabel.Text = "已解锁，请重新输入卡密"
                statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                inputBox.Text = ""
            end)
        end
        return
    end
    
    if keyData.used then
        attemptCount = attemptCount + 1
        local remaining = 3 - attemptCount
        statusLabel.Text = "卡密已被使用 (剩余尝试: " .. remaining .. "/3)"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        inputBox.Text = ""
        
        if attemptCount >= 3 then
            locked = true
            confirmBtn.Visible = false
            inputBox.Visible = false
            statusLabel.Text = "错误次数过多，锁定 10 秒"
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
            
            local startTime = os.time()
            lockTimer = task.spawn(function()
                while os.time() - startTime < 10 do
                    local remaining = 10 - (os.time() - startTime)
                    statusLabel.Text = "请等待 " .. remaining .. " 秒后重试"
                    task.wait(0.5)
                end
                locked = false
                attemptCount = 0
                confirmBtn.Visible = true
                inputBox.Visible = true
                statusLabel.Text = "已解锁，请重新输入卡密"
                statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                inputBox.Text = ""
            end)
        end
        return
    end
    
    -- 绑定设备
    keyData.used = true
    keyData.bind = DEVICE_UID
    keyData.bindTime = os.time()
    
    -- 隐藏验证界面
    screenGui.Enabled = false
    
    -- 显示成功弹窗
    showSuccessPopup(keyData)
end)

inputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        confirmBtn:Activate()
    end
end)

frame.Active = true
frame.Selectable = true

print("===== wdfex 卡密验证系统已加载 =====")
print("设备UID: " .. DEVICE_UID)
print("卡密总数: 100个 (天卡25, 周卡25, 月卡25, 永久卡25)")
print("目标脚本: " .. TARGET_SCRIPT_URL)
print("==========================")