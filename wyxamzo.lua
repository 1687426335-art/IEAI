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
    ["WDF-L1N5M8P4Q7-WEEK"] = { type = "周卡", days = 7, used = false, bind = nil,