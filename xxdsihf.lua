-- ============================================================
-- wdfex 卡密验证系统（独立版）
-- 功能：验证 + 绑定设备 + 到期检测 + 免费抽卡（限一次）
-- 使用方法：直接复制到执行器运行
-- ============================================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local StarterGui = game:GetService("StarterGui")

-- ============================================================
-- 配置
-- ============================================================
local MAX_ATTEMPTS = 3
local attemptCount = 0
local validated = false
local DATA_FILE = "wdfex_card_bind_data.txt"
local DRAW_FILE = "wdfex_card_draw_record.txt"

-- ============================================================
-- 内置卡密库（50张）
-- ============================================================
local CARDS = {
    -- 天卡 x30
    "wdfex-A7K2-M9P4", "wdfex-B3L8-N5R1", "wdfex-C6M1-P8S3",
    "wdfex-D9N4-Q2T6", "wdfex-E2P7-R5U9", "wdfex-F5Q1-S8V2",
    "wdfex-G8R3-T6W4", "wdfex-H1S6-U9X7", "wdfex-I4T9-V2Y8",
    "wdfex-J7U2-W5Z1", "wdfex-K9V5-X3A6", "wdfex-L2W8-Y7B4",
    "wdfex-M4X1-Z9C2", "wdfex-N6Y3-A5D7", "wdfex-O8Z6-B2E9",
    "wdfex-P1A9-C8F3", "wdfex-Q3B2-D6G5", "wdfex-R5C4-E1H7",
    "wdfex-S7D6-F3I8", "wdfex-T9E8-G5J2", "wdfex-U1F7-H4K6",
    "wdfex-V2G9-I6L3", "wdfex-W3H1-J8M5", "wdfex-X4I2-K7N9",
    "wdfex-Y5J3-L1O7", "wdfex-Z6K4-M2P8", "wdfex-A8L5-N3Q1",
    "wdfex-B9M6-O4R2", "wdfex-C1N7-P5S3", "wdfex-D2O8-Q6T4",
    -- 周卡 x10
    "wdfex-E3P9-R7U5", "wdfex-F4Q1-S8V6", "wdfex-G5R2-T9W7",
    "wdfex-H6S3-U1X8", "wdfex-I7T4-V2Y9", "wdfex-J8U5-W3Z1",
    "wdfex-K9V6-X4A2", "wdfex-L1W7-Y5B3", "wdfex-M2X8-Z6C4",
    "wdfex-N3Y9-A7D5",
    -- 月卡 x7
    "wdfex-O4Z1-B8E6", "wdfex-P5A2-C9F7", "wdfex-Q6B3-D1G8",
    "wdfex-R7C4-E2H9", "wdfex-S8D5-F3I1", "wdfex-T9E6-G4J2",
    "wdfex-U1F7-H5K3",
    -- 永久卡 x3
    "wdfex-V2G8-I6L4", "wdfex-W3H9-J7M5", "wdfex-X4I1-K8N6",
}

-- 卡密类型映射
local CARD_TYPES = {}
for _, card in ipairs(CARDS) do CARD_TYPES[card] = "天卡" end
local weekCards = {"wdfex-E3P9-R7U5","wdfex-F4Q1-S8V6","wdfex-G5R2-T9W7","wdfex-H6S3-U1X8","wdfex-I7T4-V2Y9","wdfex-J8U5-W3Z1","wdfex-K9V6-X4A2","wdfex-L1W7-Y5B3","wdfex-M2X8-Z6C4","wdfex-N3Y9-A7D5"}
for _, card in ipairs(weekCards) do CARD_TYPES[card] = "周卡" end
local monthCards = {"wdfex-O4Z1-B8E6","wdfex-P5A2-C9F7","wdfex-Q6B3-D1G8","wdfex-R7C4-E2H9","wdfex-S8D5-F3I1","wdfex-T9E6-G4J2","wdfex-U1F7-H5K3"}
for _, card in ipairs(monthCards) do CARD_TYPES[card] = "月卡" end
local permCards = {"wdfex-V2G8-I6L4","wdfex-W3H9-J7M5","wdfex-X4I1-K8N6"}
for _, card in ipairs(permCards) do CARD_TYPES[card] = "永久卡" end

local CARD_DURATIONS = {
    ["天卡"] = 86400,
    ["周卡"] = 604800,
    ["月卡"] = 2592000,
    ["永久卡"] = -1,
}

-- ============================================================
-- 获取设备ID
-- ============================================================
local function getDeviceId()
    local clientId = RbxAnalyticsService:GetClientId()
    if clientId and clientId ~= "" then return clientId end
    return player.UserId .. "_" .. math.random(1000,9999)
end
local currentDeviceId = getDeviceId()

-- ============================================================
-- 文件操作
-- ============================================================
local function hasFileFuncs()
    return type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
end

local function loadBindData()
    if not hasFileFuncs() then return {} end
    if isfile(DATA_FILE) then
        local content = readfile(DATA_FILE)
        if content and content ~= "" then
            local success, data = pcall(function() return HttpService:JSONDecode(content) end)
            if success and data then return data end
        end
    end
    return {}
end

local function saveBindData(data)
    if not hasFileFuncs() then return false end
    local success, json = pcall(function() return HttpService:JSONEncode(data) end)
    if success and json then
        writefile(DATA_FILE, json)
        return true
    end
    return false
end

local function loadDrawRecord()
    if not hasFileFuncs() then return {} end
    if isfile(DRAW_FILE) then
        local content = readfile(DRAW_FILE)
        if content and content ~= "" then
            local success, data = pcall(function() return HttpService:JSONDecode(content) end)
            if success and data then return data end
        end
    end
    return {}
end

local function saveDrawRecord(data)
    if not hasFileFuncs() then return false end
    local success, json = pcall(function() return HttpService:JSONEncode(data) end)
    if success and json then
        writefile(DRAW_FILE, json)
        return true
    end
    return false
end

-- ============================================================
-- 剪贴板功能
-- ============================================================
local function copyToClipboard(text)
    if type(setclipboard) == "function" then
        setclipboard(text)
        return true
    end
    return false
end

-- ============================================================
-- 核心验证
-- ============================================================
local function checkCard(card)
    if not CARD_TYPES[card] then return nil, "卡密不存在，请检查输入" end
    local cardType = CARD_TYPES[card]
    local bindData = loadBindData()
    local cardInfo = bindData[card]
    if cardInfo and cardInfo.activated then
        if cardInfo.deviceId ~= currentDeviceId then
            return nil, "当前卡密已被其他设备绑定，您无法使用"
        end
        if cardType ~= "永久卡" then
            local elapsed = os.time() - cardInfo.activateTime
            if elapsed > CARD_DURATIONS[cardType] then
                return nil, "卡密已过期（" .. cardType .. "）"
            end
            return cardType, "验证通过", CARD_DURATIONS[cardType] - elapsed
        else
            return cardType, "验证通过（永久有效）", -1
        end
    end
    -- 激活
    local newData = { activated = true, deviceId = currentDeviceId, activateTime = os.time(), cardType = cardType }
    bindData[card] = newData
    saveBindData(bindData)
    if cardType == "永久卡" then
        return cardType, "激活成功（永久有效）", -1
    else
        return cardType, "激活成功", CARD_DURATIONS[cardType]
    end
end

-- ============================================================
-- 抽卡逻辑（每人限一次）
-- ============================================================
local function drawCard()
    local drawRecord = loadDrawRecord()
    if drawRecord[player.UserId] then
        return nil, "您已经抽过一次卡密了，无法再次获取"
    end
    local r = math.random(1, 100)
    local cardType, display
    if r <= 60 then
        cardType = "天卡"
        display = "天卡（1天）"
    elseif r <= 80 then
        cardType = "周卡"
        display = "周卡（7天）"
    elseif r <= 95 then
        cardType = "月卡"
        display = "月卡（30天）"
    else
        cardType = "永久卡"
        display = "永久卡（无限）"
    end
    -- 生成卡密
    local function genCard()
        local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        local function rndStr(len)
            local str = ""
            for i = 1, len do str = str .. string.sub(chars, math.random(1, #chars), math.random(1, #chars)) end
            return str
        end
        return "wdfex-" .. rndStr(4) .. "-" .. rndStr(4)
    end
    local newCard = genCard()
    -- 将该卡密直接绑定当前设备（激活）
    local bindData = loadBindData()
    if not bindData[newCard] then
        bindData[newCard] = {
            activated = true,
            deviceId = currentDeviceId,
            activateTime = os.time(),
            cardType = cardType,
        }
        saveBindData(bindData)
    end
    -- 记录抽卡
    drawRecord[player.UserId] = true
    saveDrawRecord(drawRecord)
    return newCard, cardType, display
end

-- ============================================================
-- 格式化剩余时间
-- ============================================================
local function formatRemaining(seconds)
    if seconds == -1 then return "永久有效" end
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    if days > 0 then
        return days .. "天 " .. hours .. "小时" .. minutes .. "分钟"
    elseif hours > 0 then
        return hours .. "小时 " .. minutes .. "分钟"
    else
        return minutes .. "分钟"
    end
end

-- ============================================================
-- 卸载脚本
-- ============================================================
local function unloadScript()
    local ver = CoreGui:FindFirstChild("CardVerificationGUI")
    if ver then ver:Destroy() end
    StarterGui:SetCore("SendNotification", {
        Title = "验证失败",
        Text = "卡密错误次数过多，脚本已卸载",
        Duration = 3,
    })
end

-- ============================================================
-- 创建UI
-- ============================================================
local function createUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CardVerificationGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = CoreGui

    -- 主背景
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 420, 0, 400)
    bg.Position = UDim2.new(0.5, -210, 0.5, -200)
    bg.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    bg.BorderSizePixel = 2
    bg.BorderColor3 = Color3.fromRGB(100, 200, 255)
    bg.Parent = screenGui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = bg

    -- 标题
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 45)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "wdfex 卡密验证"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 26
    title.Font = Enum.Font.GothamBold
    title.Parent = bg

    -- 设备信息
    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, 0, 0, 22)
    sub.Position = UDim2.new(0, 0, 0, 52)
    sub.BackgroundTransparency = 1
    sub.Text = "设备ID: " .. string.sub(currentDeviceId, 1, 12) .. "..."
    sub.TextColor3 = Color3.fromRGB(160, 160, 170)
    sub.TextSize = 12
    sub.Font = Enum.Font.Gotham
    sub.Parent = bg

    -- 输入框
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(0.8, 0, 0, 45)
    inputBox.Position = UDim2.new(0.1, 0, 0, 90)
    inputBox.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.TextSize = 17
    inputBox.Font = Enum.Font.Gotham
    inputBox.PlaceholderText = "请输入卡密"
    inputBox.ClearTextOnFocus = false
    inputBox.Parent = bg
    local corner2 = Instance.new("UICorner")
    corner2.CornerRadius = UDim.new(0, 8)
    corner2.Parent = inputBox

    -- 状态标签
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -20, 0, 40)
    statusLabel.Position = UDim2.new(0, 10, 0, 142)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.TextSize = 14
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.TextWrapped = true
    statusLabel.Parent = bg

    -- 按钮区域
    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(1, -20, 0, 45)
    btnFrame.Position = UDim2.new(0, 10, 0, 195)
    btnFrame.BackgroundTransparency = 1
    btnFrame.Parent = bg

    local confirmBtn = Instance.new("TextButton")
    confirmBtn.Size = UDim2.new(0.45, 0, 1, 0)
    confirmBtn.Position = UDim2.new(0, 0, 0, 0)
    confirmBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
    confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    confirmBtn.TextSize = 18
    confirmBtn.Font = Enum.Font.GothamBold
    confirmBtn.Text = "验证卡密"
    confirmBtn.Parent = btnFrame
    local corner3 = Instance.new("UICorner")
    corner3.CornerRadius = UDim.new(0, 8)
    corner3.Parent = confirmBtn

    local drawBtn = Instance.new("TextButton")
    drawBtn.Size = UDim2.new(0.45, 0, 1, 0)
    drawBtn.Position = UDim2.new(0.55, 0, 0, 0)
    drawBtn.BackgroundColor3 = Color3.fromRGB(200, 140, 0)
    drawBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    drawBtn.TextSize = 18
    drawBtn.Font = Enum.Font.GothamBold
    drawBtn.Text = "免费抽卡密"
    drawBtn.Parent = btnFrame
    local corner4 = Instance.new("UICorner")
    corner4.CornerRadius = UDim.new(0, 8)
    corner4.Parent = drawBtn

    -- 剩余尝试次数
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -20, 0, 20)
    infoLabel.Position = UDim2.new(0, 10, 0, 255)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "剩余尝试次数: 3"
    infoLabel.TextColor3 = Color3.fromRGB(120, 120, 130)
    infoLabel.TextSize = 12
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.Parent = bg

    -- 结果显示区域
    local resultBg = Instance.new("Frame")
    resultBg.Size = UDim2.new(0.85, 0, 0, 50)
    resultBg.Position = UDim2.new(0.075, 0, 0, 285)
    resultBg.BackgroundColor3 = Color3.fromRGB(30, 30, 450)
    resultBg.Background,Transparency = 1
    resultBg.B orderSizePixel = 0
    result1Bg.Parent = bg
    local resultLabel = Instance.new("TextLabel")
    resultLabel.Size = UDim2.new(1, , 0)
    resultLabel.BackgroundTransparency = 1
    resultLabel.Text = ""
    resultLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    resultLabel.TextSize = 14
    resultLabel.Font = Enum.Font.GothamBold
    resultLabel.TextXAlignment = Enum.TextXAlignment.Center
    resultLabel.TextWrapped = true
    resultLabel.Parent = resultBg

    -- ============================================================
    -- 逻辑函数
    -- ============================================================

    local function updateInfo()
        local remaining = MAX_ATTEMPTS - attemptCount
        infoLabel.Text = "剩余尝试次数: " .. remaining
        if remaining <= 0 then
            infoLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        else
            infoLabel.TextColor3 = Color3.fromRGB(120, 120, 130)
        end
    end

    -- 显示抽卡结果（右上角通知 + 自动复制）
    local function showDrawResult(card, cardType, display)
        local msg = "恭喜您获得 " .. display .. " ！\n卡密: " .. card
        StarterGui:SetCore("SendNotification", {
            Title = "抽卡成功",
            Text = msg,
            Duration = 8,
        })
        -- 复制到剪贴板
        local copied = copyToClipboard(card)
        if copied then
            StarterGui:SetCore("SendNotification", {
                Title = "已复制",
                Text = "卡密已复制到剪贴板",
                Duration = 3,
            })
        end
        -- 显示在UI
        resultLabel.Text = "卡密: " .. card .. " (" .. display .. ")"
        resultLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
        resultBg.BackgroundTransparency = 0.2
    end

    -- 抽卡
    local function doDraw()
        local card, cardType, display = drawCard()
        if not card then
            statusLabel.Text = display or "您已抽过卡密"
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            return
        end
        showDrawResult(card, cardType, display)
        statusLabel.Text = "抽卡成功！"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        drawBtn.Visible = false  -- 防止重复点击
    end

    -- 验证
    local function doVerify(input)
        if attemptCount >= MAX_ATTEMPTS then
            statusLabel.Text = "已达到最大尝试次数！"
            statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            return
        end
        if input == "" then
            statusLabel.Text = "请输入卡密！"
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            return
        end
        local cardType, msg, remaining = checkCard(input)
        if not cardType then
            attemptCount = attemptCount + 1
            updateInfo()
            statusLabel.Text = msg
            statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            resultLabel.Text = ""
            if attemptCount >= MAX_ATTEMPTS then
                statusLabel.Text = "卡密错误次数过多！脚本即将卸载"
                task.wait(1.5)
                unloadScript()
            end
            return
        end
        validated = true
        statusLabel.Text = msg
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        confirmBtn.Visible = false
        inputBox.Visible = false
        drawBtn.Visible = false
        if remaining and remaining ~= -1 then
            resultLabel.Text = "卡密类型: " .. cardType .. " | 剩余: " .. formatRemaining(remaining)
            resultLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        elseif remaining == -1 then
            resultLabel.Text = "卡密类型: " .. cardType .. " | 永久有效"
            resultLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
        end
        resultBg.BackgroundTransparency = 0.2
        infoLabel.Text = "✓ 验证通过，可正常使用"
        infoLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        StarterGui:SetCore("SendNotification", {
            Title = "验证成功",
            Text = "卡密类型: " .. cardType,
            Duration = 3,
        })
    end

    -- 绑定事件
    confirmBtn.MouseButton1Click:Connect(function()
        doVerify(inputBox.Text)
    end)
    inputBox.FocusLost:Connect(function(enter)
        if enter then confirmBtn.MouseButton1Click:Fire() end
    end)
    drawBtn.MouseButton1Click:Connect(doDraw)

    updateInfo()
end

-- ============================================================
-- 启动
-- ============================================================
createUI()
print("[卡密验证] 界面已加载，请输入卡密或免费抽卡")