-- This file has been deobfuscated Luraph using Hurricane https://discord.com/invite/AbeurBzKXe

-- ============================================================
-- 卡密验证系统（整合版）
-- ============================================================
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local StarterGui = game:GetService("StarterGui")

local MAX_ATTEMPTS = 3
local attemptCount = 0
local validated = false
local DATA_FILE = "wdfex_card_bind_data.txt"
local DRAW_FILE = "wdfex_card_draw_record.txt"

-- 内置卡密库（50张）
local CARDS = {
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
    "wdfex-E3P9-R7U5", "wdfex-F4Q1-S8V6", "wdfex-G5R2-T9W7",
    "wdfex-H6S3-U1X8", "wdfex-I7T4-V2Y9", "wdfex-J8U5-W3Z1",
    "wdfex-K9V6-X4A2", "wdfex-L1W7-Y5B3", "wdfex-M2X8-Z6C4",
    "wdfex-N3Y9-A7D5",
    "wdfex-O4Z1-B8E6", "wdfex-P5A2-C9F7", "wdfex-Q6B3-D1G8",
    "wdfex-R7C4-E2H9", "wdfex-S8D5-F3I1", "wdfex-T9E6-G4J2",
    "wdfex-U1F7-H5K3",
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

local CARD_DURATIONS = {["天卡"]=86400,["周卡"]=604800,["月卡"]=2592000,["永久卡"]=-1}

local function getDeviceId()
    local clientId = RbxAnalyticsService:GetClientId()
    if clientId and clientId ~= "" then return clientId end
    return player.UserId .. "_" .. math.random(1000,9999)
end
local currentDeviceId = getDeviceId()

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

local function copyToClipboard(text)
    if type(setclipboard) == "function" then
        setclipboard(text)
        return true
    end
    return false
end

local function checkCard(card)
    if not CARD_TYPES[card] then return nil, "卡密不存在" end
    local cardType = CARD_TYPES[card]
    local bindData = loadBindData()
    local cardInfo = bindData[card]
    if cardInfo and cardInfo.activated then
        if cardInfo.deviceId ~= currentDeviceId then
            return nil, "已被其他设备绑定"
        end
        if cardType ~= "永久卡" then
            local elapsed = os.time() - cardInfo.activateTime
            if elapsed > CARD_DURATIONS[cardType] then
                return nil, "卡密已过期"
            end
            return cardType, "验证通过", CARD_DURATIONS[cardType] - elapsed
        else
            return cardType, "验证通过（永久）", -1
        end
    end
    local newData = { activated = true, deviceId = currentDeviceId, activateTime = os.time(), cardType = cardType }
    bindData[card] = newData
    saveBindData(bindData)
    if cardType == "永久卡" then
        return cardType, "激活成功（永久）", -1
    else
        return cardType, "激活成功", CARD_DURATIONS[cardType]
    end
end

local function drawCard()
    local drawRecord = loadDrawRecord()
    if drawRecord[player.UserId] then
        return nil, "您已抽过一次"
    end
    local r = math.random(1, 100)
    local cardType, display
    if r <= 60 then cardType = "天卡"; display = "天卡（1天）"
    elseif r <= 80 then cardType = "周卡"; display = "周卡（7天）"
    elseif r <= 95 then cardType = "月卡"; display = "月卡（30天）"
    else cardType = "永久卡"; display = "永久卡（无限）" end
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
    local bindData = loadBindData()
    if not bindData[newCard] then
        bindData[newCard] = { activated = true, deviceId = currentDeviceId, activateTime = os.time(), cardType = cardType }
        saveBindData(bindData)
    end
    drawRecord[player.UserId] = true
    saveDrawRecord(drawRecord)
    return newCard, cardType, display
end

local function formatRemaining(seconds)
    if seconds == -1 then return "永久有效" end
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    if days > 0 then return days .. "天 " .. hours .. "小时"
    elseif hours > 0 then return hours .. "小时 " .. minutes .. "分钟"
    else return minutes .. "分钟" end
end

local function unloadScript()
    local ver = CoreGui:FindFirstChild("CardVerificationGUI")
    if ver then ver:Destroy() end
    StarterGui:SetCore("SendNotification", { Title = "验证失败", Text = "卡密错误次数过多，脚本已卸载", Duration = 3 })
end

local function createVerificationUI(callback)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CardVerificationGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = CoreGui

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 420, 0, 380)
    bg.Position = UDim2.new(0.5, -210, 0.5, -190)
    bg.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    bg.BorderSizePixel = 2
    bg.BorderColor3 = Color3.fromRGB(100, 200, 255)
    bg.Parent = screenGui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = bg

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 45)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "wdfex 卡密验证"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 26
    title.Font = Enum.Font.GothamBold
    title.Parent = bg

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, 0, 0, 22)
    sub.Position = UDim2.new(0, 0, 0, 52)
    sub.BackgroundTransparency = 1
    sub.Text = "设备ID: " .. string.sub(currentDeviceId, 1, 12) .. "..."
    sub.TextColor3 = Color3.fromRGB(160, 160, 170)
    sub.TextSize = 12
    sub.Font = Enum.Font.Gotham
    sub.Parent = bg

    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(0.8, 0, 0, 45)
    inputBox.Position = UDim2.new(0.1, 0, 0, 85)
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

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -20, 0, 35)
    statusLabel.Position = UDim2.new(0, 10, 0, 138)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.TextSize = 14
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.TextWrapped = true
    statusLabel.Parent = bg

    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(1, -20, 0, 45)
    btnFrame.Position = UDim2.new(0, 10, 0, 182)
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

    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -20, 0, 20)
    infoLabel.Position = UDim2.new(0, 10, 0, 240)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "剩余尝试次数: 3"
    infoLabel.TextColor3 = Color3.fromRGB(120, 120, 130)
    infoLabel.TextSize = 12
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.Parent = bg

    local resultBg = Instance.new("Frame")
    resultBg.Size = UDim2.new(0.85, 0, 0, 50)
    resultBg.Position = UDim2.new(0.075, 0, 0, 270)
    resultBg.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    resultBg.BackgroundTransparency = 1
    resultBg.BorderSizePixel = 0
    resultBg.Parent = bg
    local resultLabel = Instance.new("TextLabel")
    resultLabel.Size = UDim2.new(1, 0, 1, 0)
    resultLabel.BackgroundTransparency = 1
    resultLabel.Text = ""
    resultLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    resultLabel.TextSize = 14
    resultLabel.Font = Enum.Font.GothamBold
    resultLabel.TextXAlignment = Enum.TextXAlignment.Center
    resultLabel.TextWrapped = true
    resultLabel.Parent = resultBg

    local function updateInfo()
        local remaining = MAX_ATTEMPTS - attemptCount
        infoLabel.Text = "剩余尝试次数: " .. remaining
        infoLabel.TextColor3 = remaining <= 0 and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(120, 120, 130)
    end

    local function showDrawResult(card, cardType, display)
        local msg = "恭喜您获得 " .. display .. " ！\n卡密: " .. card
        StarterGui:SetCore("SendNotification", { Title = "抽卡成功", Text = msg, Duration = 8 })
        if copyToClipboard(card) then
            StarterGui:SetCore("SendNotification", { Title = "已复制", Text = "卡密已复制到剪贴板", Duration = 3 })
        end
        resultLabel.Text = "卡密: " .. card .. " (" .. display .. ")"
        resultLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
        resultBg.BackgroundTransparency = 0.2
    end

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
        drawBtn.Visible = false
    end

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
                return
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
        StarterGui:SetCore("SendNotification", { Title = "验证成功", Text = "卡密类型: " .. cardType, Duration = 3 })
        task.wait(1)
        screenGui:Destroy()
        if callback then callback() end
    end

    confirmBtn.MouseButton1Click:Connect(function() doVerify(inputBox.Text) end)
    inputBox.FocusLost:Connect(function(enter) if enter then confirmBtn.MouseButton1Click:Fire() end end)
    drawBtn.MouseButton1Click:Connect(doDraw)
    updateInfo()
end

-- ============================================================
-- 主脚本入口
-- ============================================================
local function MainScript()
    local function safeLoad(url) local success, result = pcall(function() return loadstring(game:HttpGet(url))() end) if not success then warn("加载失败: " .. url) return nil end return result end

    local Library = safeLoad("https://raw.githubusercontent.com/kongbaNB/ui/refs/heads/main/黑曜石主库.ui")
    local ThemeManager = safeLoad("https://raw.githubusercontent.com/kongbaNB/ui/refs/heads/main/主题管理.ui")
    local SaveManager = safeLoad("https://raw.githubusercontent.com/kongbaNB/ui/refs/heads/main/配置管理.ui")
    if not Library then
        StarterGui:SetCore("SendNotification", { Title = "错误", Text = "UI 库加载失败", Duration = 5 })
        return
    end

    local Options = Library.Options
    local Toggles = Library.Toggles
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    local player = Players.LocalPlayer

    local Window = Library:CreateWindow({
        Title = "wdfex-圣奥里",
        Footer = "此脚本由wdfex高级工程师制作倒卖没有季吧",
        Icon = 131153193945220,
        NotifySide = "Right",
        ShowCustomCursor = true,
    })

    Library:Notify({
        Title = "圣奥里",
        Description = "创作者：wdfex\nQQ：1687426335\n脚本已加载成功",
        Time = 5,
    })

    local Tabs = {
        Notice = Window:AddTab("公告", "info"),
        Player = Window:AddTab("玩家修改", "user"),
        Gun = Window:AddTab("枪械功能", "target"),
        KA = Window:AddTab("杀戮光环", "skull"),
        Teleports = Window:AddTab("传送点", "map-pin"),
        ESP = Window:AddTab("透视", "eye"),
        Developer = Window:AddTab("开发者功能", "code"),
        Settings = Window:AddTab("设置", "settings"),
    }

    -- ============================================================
    -- 以下为原脚本所有功能（完整复制）
    -- ============================================================
    local NoticeGroup = Tabs.Notice:AddLeftGroupbox("作者消息")
    NoticeGroup:AddLabel('wdfex')
    NoticeGroup:AddLabel('创作者：wdfex')
    NoticeGroup:AddDivider()
    NoticeGroup:AddLabel('已更换悬浮窗添加了一些功能')
    NoticeGroup:AddLabel('杀戮光环的优先攻击最近目标如果选择距离内没有人')
    NoticeGroup:AddLabel('那这个选项就不会生效杀戮光环正常生效')
    NoticeGroup:AddDivider()
    NoticeGroup:AddLabel('如果你使用的过程中出现一些bug请联系作者修复')

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
    local isDestroyed = false
    local connections = {}
    local noclipConnections = {}

    local JobColors = {
        ["警察"] = Color3.fromRGB(0, 100, 255),
        ["医生"] = Color3.fromRGB(0, 200, 0),
        ["消防员"] = Color3.fromRGB(255, 50, 0),
        ["军人"] = Color3.fromRGB(50, 150, 50),
        ["黑帮"] = Color3.fromRGB(150, 0, 150),
        ["平民"] = Color3.fromRGB(200, 200, 200),
        ["圣奥里公民"] = Color3.fromRGB(200, 200, 200),
        ["银行家"] = Color3.fromRGB(0, 200, 200),
        ["市长"] = Color3.fromRGB(255, 200, 0),
        ["记者"] = Color3.fromRGB(255, 150, 0),
        ["律师"] = Color3.fromRGB(150, 100, 200),
        ["囚犯"] = Color3.fromRGB(255, 150, 0),
        ["狱警"] = Color3.fromRGB(0, 150, 255),
        ["司机"] = Color3.fromRGB(100, 200, 255),
        ["厨师"] = Color3.fromRGB(255, 100, 0),
        ["建筑工"] = Color3.fromRGB(255, 200, 50),
        ["农民"] = Color3.fromRGB(50, 200, 50),
        ["矿工"] = Color3.fromRGB(200, 150, 100),
        ["渔夫"] = Color3.fromRGB(0, 150, 200),
        ["商人"] = Color3.fromRGB(255, 150, 200),
        ["学生"] = Color3.fromRGB(100, 100, 255),
        ["老师"] = Color3.fromRGB(200, 100, 50),
        ["工程师"] = Color3.fromRGB(255, 100, 100),
        ["科学家"] = Color3.fromRGB(0, 255, 150),
        ["飞行员"] = Color3.fromRGB(50, 200, 255),
        ["快递员"] = Color3.fromRGB(255, 180, 0),
        ["公交车司机"] = Color3.fromRGB(0, 180, 255),
        ["送货"] = Color3.fromRGB(255, 100, 50),
        ["转运"] = Color3.fromRGB(0, 200, 150),
        ["货物"] = Color3.fromRGB(150, 100, 0),
        ["医疗服务工作人员"] = Color3.fromRGB(0, 220, 100),
    }

    -- ==================== 透视功能 ====================
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
        local mc = player.Character
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
        if not p.Character or p == player then return end
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

        ESP_LIST[p.UserId] = {Billboard = bb, Frame = f}
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
            if p == player then continue end
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

    -- ==================== 透视Tab ====================
    local espTab = Tabs.ESP
    local espGroup = espTab:AddLeftGroupbox("透视设置")

    espGroup:AddToggle("ESPEnabled", {
        Text = "透视总开关",
        Default = false,
        Callback = function(v)
            ESP_ENABLED = v
            if v then RefreshESP() end
        end
    })

    espGroup:AddDivider()

    espGroup:AddToggle("ESPShowName", {
        Text = "显示名字",
        Default = true,
        Callback = function(v)
            ESP_SHOW_NAME = v
            if ESP_ENABLED then RefreshESP() end
        end
    })

    espGroup:AddToggle("ESPShowTeam", {
        Text = "显示队伍",
        Default = true,
        Callback = function(v)
            ESP_SHOW_TEAM = v
            if ESP_ENABLED then RefreshESP() end
        end
    })

    espGroup:AddToggle("ESPShowHealth", {
        Text = "显示血量",
        Default = true,
        Callback = function(v)
            ESP_SHOW_HEALTH = v
            if ESP_ENABLED then RefreshESP() end
        end
    })

    espGroup:AddToggle("ESPShowDist", {
        Text = "显示距离",
        Default = true,
        Callback = function(v)
            ESP_SHOW_DIST = v
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

    -- ==================== 防甩飞 ====================
    _G.CatAntiFling_Enabled = false
    _G.CatAntiFling_Running = false

    local function AntiFlingLoop()
        if _G.CatAntiFling_Running then return end
        _G.CatAntiFling_Running = true
        task.spawn(function()
            while not isDestroyed do
                if _G.CatAntiFling_Enabled then
                    pcall(function()
                        local char = player.Character
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

    -- ==================== 开发者功能 ====================
    local DeveloperTab = Tabs.Developer
    local DeveloperGroup = DeveloperTab:AddLeftGroupbox("坐标工具")

    DeveloperGroup:AddButton({
        Text = "开启坐标显示",
        Func = function()
            local char = player.Character or player.CharacterAdded:Wait()
            local root = char:WaitForChild("HumanoidRootPart")
            local gui = Instance.new("ScreenGui")
            gui.Name = "CoordinateCopyTool"
            gui.Parent = player:WaitForChild("PlayerGui")
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
            game:GetService("RunService").RenderStepped:Connect(function()
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

    DeveloperGroup:AddButton({
        Text = "关闭坐标显示",
        Func = function()
            local gui = player.PlayerGui:FindFirstChild("CoordinateCopyTool")
            if gui then gui:Destroy() end
        end
    })

    -- ==================== 传送数据 ====================
    local function GetTeleportData()
        return {
            {n = "车辆经销商", p = Vector3.new(3719.9501953125, 3.018573522567749, -333.3118591308594), region = "圣奥里"},
            {n = "医院", p = Vector3.new(3980.091064453125, 2.876060724258423, -138.79454040527344), region = "圣奥里"},
            {n = "警察局", p = Vector3.new(3364.273193359375, 3.9188079834, -394.7233581542969), region = "圣奥里"},
            {n = "圣奥里修车店", p = Vector3.new(2782.46875, 2.630995750427246, -418.59930419921875), region = "圣奥里"},
            {n = "圣奥里银行", p = Vector3.new(3134.05419921875, 6.116048336029053, -171.36976623535156), region = "圣奥里"},
            {n = "圣奥里服装店", p = Vector3.new(3617.91259765625, 3.1072206497192383, -452.8206481933594), region = "圣奥里"},
            {n = "圣奥里平民重生", p = Vector3.new(3741.114990234375, 3.720573663711548, -438.1059875488281), region = "圣奥里"},
            {n = "圣奥里码头", p = Vector3.new(4527.65625, -23.968238830566406, -280.59356689453125), region = "圣奥里"},
            {n = "圣奥里餐饮店", p = Vector3.new(3182.416748046875, 3.01859188079834, 426.5179138183594), region = "圣奥里"},
            {n = "消防部门", p = Vector3.new(3578.676025390625, 8.408823013305664, 579.6567993164062), region = "圣奥里"},
            {n = "宠物店", p = Vector3.new(3678.237305, 3.017920, 693.114624), region = "圣奥里"},
            {n = "圣奥里大码头", p = Vector3.new(2736.307617, 2.630299, -1120.333008), region = "圣奥里"},
            {n = "圣奥里海滩桥下(消星点)", p = Vector3.new(3964.504395, -25.068211, -854.057251), region = "圣奥里"},
            {n = "大景超市", p = Vector3.new(3936.582764, 3.038293, 1136.326416), region = "大景"},
            {n = "转镜中心", p = Vector3.new(4152.919922, 2.631675, 941.446045), region = "大景"},
            {n = "道路服务", p = Vector3.new(4271.332520, 2.628108, 1200.086914), region = "大景"},
            {n = "大景餐饮店", p = Vector3.new(4476.997559, 3.037825, 906.802979), region = "大景"},
            {n = "送货中心", p = Vector3.new(4399.419434, 3.038999, 1609.455933), region = "大景"},
            {n = "大景卖车店", p = Vector3.new(3434.377441, 42.931786, 2687.997070), region = "大景"},
            {n = "莱斯维尔餐饮店", p = Vector3.new(753.757812, 3.039824, 998.132996), region = "莱斯维尔"},
            {n = "莱斯维尔服装店", p = Vector3.new(820.745117, 2.766988, 1047.445679), region = "莱斯维尔"},
            {n = "莱斯维尔自由广场", p = Vector3.new(926.523376, 2.630995, 865.764771), region = "莱斯维尔"},
            {n = "莱斯维尔码头(游艇)", p = Vector3.new(947.840210, -22.529087, 1216.085693), region = "莱斯维尔"},
            {n = "米尔顿左上加油站", p = Vector3.new(1145.635742, 2.630916, -864.273682), region = "米尔顿"},
            {n = "米尔顿右下加油站", p = Vector3.new(-1646.802734, 2.630164, 1812.894653), region = "米尔顿"},
            {n = "米尔顿上方加油站", p = Vector3.new(-900.701660, 2.630927, 1124.683105), region = "米尔顿"},
            {n = "米尔顿居民区", p = Vector3.new(-528.565552, 2.630996, 1331.981689), region = "米尔顿"},
            {n = "约克镇小银行", p = Vector3.new(-668.217224, 2.630995, -65.347839), region = "约克镇"},
            {n = "约克镇修车厂", p = Vector3.new(-407.163025, 3.076807, -6.098211), region = "约克镇"},
            {n = "约克镇枪店", p = Vector3.new(-323.869293, 3.037825, 37.149670), region = "约克镇"},
            {n = "约克镇重生点", p = Vector3.new(-219.560318, 3.039824, -85.725433), region = "约克镇"},
            {n = "约克镇当铺", p = Vector3.new(-168.513733, 3.039000, -106.926529), region = "约克镇"},
            {n = "约克镇卫星车", p = Vector3.new(-302.093567, 3.037825, -167.621017), region = "约克镇"},
            {n = "约克镇中心点", p = Vector3.new(-275.995209, 2.630996, -139.985352), region = "约克镇"},
            {n = "黑市", p = Vector3.new(1038.969849, -22.732950, 895.430237), region = "其他"},
            {n = "渔夫码头", p = Vector3.new(-50.147552, -24.555279, 1462.145996), region = "其他"},
            {n = "农场", p = Vector3.new(-1268.339233, 2.572412, 2560.060303), region = "其他"},
            {n = "监狱门口", p = Vector3.new(-1697.931885, 2.630666, 1284.567383), region = "其他"},
            {n = "监狱广场", p = Vector3.new(-1600.602417, 2.631028, 1268.060059), region = "其他"},
            {n = "代尔山", p = Vector3.new(847.062988, 194.115753, -326.212708), region = "其他"},
            {n = "瀑布洞穴(消星点)", p = Vector3.new(3040.956055, 109.688538, 2711.069336), region = "其他"},
            {n = "大桥", p = Vector3.new(949.014954, 25.215754, 2897.654785), region = "其他"},
            {n = "地图右下(消星点)", p = Vector3.new(-1651.385010, 2.414712, 3225.278320), region = "其他"},
            {n = "下部加油站", p = Vector3.new(2270.378174, 2.630927, 154.161484), region = "其他"},
            {n = "游戏厅", p = Vector3.new(2934.893799, 2.956458, 1693.660034), region = "其他"},
            {n = "高尔夫", p = Vector3.new(2280.767090, 3.037836, 1982.357300), region = "其他"},
            {n = "修船厂", p = Vector3.new(4096.405273, -30.401447, 2865.045166), region = "其他"},
        }
    end
    local FIXED_TELEPORTS = GetTeleportData()

    local function TeleportTo(pos)
        if not Settings.TeleportEnabled or isDestroyed then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        pcall(function()
            root.CFrame = CFrame.new(pos)
        end)
    end

    local function ApplyNoclip()
        if isDestroyed or not Settings.NoclipEnabled then return end
        local char = player.Character
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    local function ToggleNoclip(state)
        Settings.NoclipEnabled = state
        if state then
            ApplyNoclip()
        else
            local char = player.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end

    local function ApplyHitbox()
        if isDestroyed or not Settings.HitboxEnabled then return end
        local players = Players:GetPlayers()
        local newAffected = {}
        for i = 1, #players do
            local p = players[i]
            if p ~= player and p.Character then
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
            if p ~= player then
                pcall(function()
                    if p:IsFriendsWith(player.UserId) then
                        Whitelist[p.UserId] = true
                    end
                end)
            end
        end
    end

    -- ============================================================
    -- 飞行功能
    -- ============================================================
    local UserInputService = game:GetService("UserInputService")
    local FlySpeed = 35
    local flyState = { enabled = false, hrp = nil, hum = nil, microThread = nil, healthThread = nil, diedConn = nil, targetPos = nil, lastTime = 0 }
    local flyAnchor = { active = false, head = nil, hrp = nil, hum = nil, rayLength = 3.5, rayCount = 12, verticalLayers = 3 }
    local FlyControl
    task.spawn(function()
        pcall(function()
            local pm = player.PlayerScripts:FindFirstChild("PlayerModule")
            if pm then FlyControl = require(pm):GetControls() end
        end)
    end)

    local function flyRefreshParts()
        local char = player.Character
        if not char then
            flyState.hrp = nil flyState.hum = nil
            flyAnchor.hrp = nil flyAnchor.head = nil flyAnchor.hum = nil
            return
        end
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
        params.FilterDescendantsInstances = { player.Character }
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

    player.CharacterAdded:Connect(function()
        if flyState.enabled then
            stopFly()
            task.wait(0.2)
            startFly()
        end
    end)

    local interactEnabled = false
    local ScanPrompts

    local speedBypassOn = false
    local speedBypassValue = 20
    RunService.Heartbeat:Connect(function(dt)
        if not speedBypassOn then return end
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if hum and root and hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + hum.MoveDirection * speedBypassValue * dt
        end
    end)

    local staminaOn = false
    local godOn = false
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

    -- ============================================================
    -- 子追
    -- ============================================================
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
                local char = player.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local best, bestDist = nil, zzDistance
                if root then
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= player and p.Character then
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

    -- ============================================================
    -- 自瞄
    -- ============================================================
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
        aimGui.Parent = player:WaitForChild("PlayerGui")
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
            if p ~= player and p.Character then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                local head = p.Character:FindFirstChild("Head")
                if hum and hum.Health > 0 and head then
                    local skip = aimNoTeam and p.Team ~= nil and player.Team ~= nil and p.Team == player.Team
                    if not skip then
                        local sp, onScreen = camera:WorldToViewportPoint(head.Position)
                        if onScreen then
                            local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                            if d < bestDist then
                                local visible = true
                                if aimWall then
                                    local rp = RaycastParams.new()
                                    rp.FilterType = Enum.RaycastFilterType.Exclude
                                    rp.FilterDescendantsInstances = { player.Character }
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

    -- ============================================================
    -- 无限子弹
    -- ============================================================
    local infAmmoEnabled = false
    task.spawn(function()
        while not isDestroyed do
            if infAmmoEnabled then
                local characterFolder = Workspace:FindFirstChild("Characters") and Workspace.Characters:FindFirstChild(player.Name)
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

    -- ============================================================
    -- 杀戮光环（枪）
    -- ============================================================
    local KA_GUN_MAX_DISTANCE = 300
    local KA_GUN_WALL_CHECK = true
    local kaGunEnabled = false
    local KAGunNearestOnly = false
    local KA_GUN_NEAREST_DISTANCE = 25
    local kaGunStatusLabel = nil

    local KAGunTargetPoliceOnly = false
    local KAGunTargetCivilianOnly = false
    local KAGunIgnoreDead = true

    local function kaGunIsVisible(targetHead)
        local char = player.Character
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
        local char = player.Character
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
                if p ~= player and p.Character then
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
            if p ~= player and p.Character then
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

    local function kaGunSetStatus(text)
        if kaGunStatusLabel then
            pcall(function() kaGunStatusLabel:SetText(text) end)
        end
    end

    RunService.Heartbeat:Connect(function()
        if not isDestroyed then
            if kaGunEnabled then
                local target = kaGunGetNearestEnemy()
                local targetHead = target and target.Character and target.Character:FindFirstChild("Head")
                if targetHead then
                    local myHead = player.Character and player.Character:FindFirstChild("Head")
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
                        kaGunSetStatus("状态：已锁定 " .. target.Name)
                    else
                        kaGunSetStatus("状态：等待角色头部加载")
                    end
                else
                    kaGunSetStatus("状态：范围内未找到敌人")
                end
            end
        end
    end)

    -- ============================================================
    -- 杀戮光环（刀）
    -- ============================================================
    local KA_MELEE_MAX_DISTANCE = 300
    local KA_MELEE_WALL_CHECK = true
    local kaMeleeEnabled = false
    local KAMeleeNearestOnly = false
    local KA_MELEE_NEAREST_DISTANCE = 25
    local kaMeleeStatusLabel = nil

    local KAMeleeTargetPoliceOnly = false
    local KAMeleeTargetCivilianOnly = false
    local KAMeleeIgnoreDead = true

    local function kaMeleeIsVisible(targetHead)
        local char = player.Character
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
        local char = player.Character
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
                if p ~= player and p.Character then
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
            if p ~= player and p.Character then
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

    local function kaMeleeSetStatus(text)
        if kaMeleeStatusLabel then
            pcall(function() kaMeleeStatusLabel:SetText(text) end)
        end
    end

    RunService.Heartbeat:Connect(function()
        if not isDestroyed then
            if kaMeleeEnabled then
                local target = kaMeleeGetNearestEnemy()
                local targetHead = target and target.Character and target.Character:FindFirstChild("Head")
                if targetHead then
                    local myHead = player.Character and player.Character:FindFirstChild("Head")
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
                        kaMeleeSetStatus("状态：已锁定 " .. target.Name .. "（刀）")
                    else
                        kaMeleeSetStatus("状态：等待角色头部加载")
                    end
                else
                    kaMeleeSetStatus("状态：范围内未找到敌人")
                end
            end
        end
    end)

    -- ============================================================
    -- UI
    -- ============================================================
    local weaponGroup = Tabs.Gun:AddLeftGroupbox("枪械功能")
    weaponGroup:AddToggle("FastFire", {
        Text = "超快射速",
        Default = false,
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
            local char = player.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.Died:Connect(ModifyWeaponStats)
                end
            end
            Library:Notify({ Title = "武器强化", Description = "无限射速已生效，死亡后自动重新生效", Time = 3 })
        end
    })
    weaponGroup:AddToggle("InfAmmo", {
        Text = "无限子弹",
        Default = false,
        Callback = function(value)
            infAmmoEnabled = value
        end
    })

    local mainLeftGroup = Tabs.Player:AddRightGroupbox("快速互动")
    mainLeftGroup:AddToggle("InteractToggle", {
        Text = "启用快速互动",
        Default = false,
        Callback = function(value)
            interactEnabled = value
            if value and ScanPrompts then ScanPrompts() end
        end
    })
    mainLeftGroup:AddDivider()
    mainLeftGroup:AddSlider("HoldTime", {
        Text = "按住时间",
        Default = 0,
        Min = 0,
        Max = 10,
        Rounding = 0,
        Suffix = "秒",
        Callback = function(value)
            Settings.HoldTime = value
            if not interactEnabled then return end
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    obj.HoldDuration = value
                end
            end
        end
    })
    mainLeftGroup:AddSlider("Distance", {
        Text = "触发距离",
        Default = 25,
        Min = 5,
        Max = 150,
        Rounding = 0,
        Suffix = "单位",
        Callback = function(value)
            Settings.Distance = value
            if not interactEnabled then return end
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    obj.MaxActivationDistance = value
                end
            end
        end
    })

    local godGroup = Tabs.Player:AddRightGroupbox("伤害免疫")
    godGroup:AddToggle("GodToggle", {
        Text = "免疫部分伤害",
        Default = false,
        Callback = function(value)
            godOn = value
        end
    })
    godGroup:AddLabel("免疫火焰和车爆炸时候的伤害")

    local mainRightGroup = Tabs.Gun:AddLeftGroupbox("碰撞箱扩展")
    mainRightGroup:AddToggle("HitboxToggle", {
        Text = "启用头部碰撞箱（推荐20-25）",
        Default = false,
        Callback = function(value)
            Settings.HitboxEnabled = value
            if value then ApplyHitbox() else ResetHitbox() end
        end
    })
    mainRightGroup:AddSlider("HitboxSize", {
        Text = "头部大小",
        Default = 10,
        Min = 5,
        Max = 400,
        Rounding = 0,
        Suffix = "单位",
        Callback = function(value)
            Settings.HitboxSize = value
            if Settings.HitboxEnabled then ApplyHitbox() end
        end
    })
    mainRightGroup:AddToggle("WhitelistToggle", {
        Text = "好友检测 (白名单)",
        Default = false,
        Callback = function(value)
            Settings.WhitelistEnabled = value
            if value then UpdateWhitelist() end
        end
    })

    local flyGroup = Tabs.Player:AddLeftGroupbox("角色修改")
    flyGroup:AddToggle("FlyToggle", {
        Text = "飞行（绕过）",
        Default = false,
        Callback = function(value)
            if value then startFly() else stopFly() end
        end
    })
    flyGroup:AddSlider("FlySpeed", {
        Text = "飞行速度",
        Default = 35,
        Min = 10,
        Max = 620,
        Rounding = 0,
        Callback = function(value)
            FlySpeed = value
        end
    })
    flyGroup:AddDivider()
    flyGroup:AddToggle("NoclipToggle", {
        Text = "启用人物穿墙",
        Default = false,
        Callback = function(value)
            ToggleNoclip(value)
        end
    })
    flyGroup:AddDivider()
    flyGroup:AddToggle("SpeedBypassToggle", {
        Text = "修改移速（绕过）（速度推荐80-90）",
        Default = false,
        Callback = function(value)
            speedBypassOn = value
        end
    })
    flyGroup:AddSlider("SpeedBypassValue", {
        Text = "移速",
        Default = 20,
        Min = 5,
        Max = 150,
        Rounding = 0,
        Callback = function(value)
            speedBypassValue = value
        end
    })
    flyGroup:AddDivider()
    flyGroup:AddToggle("StaminaToggle", {
        Text = "无限体力",
        Default = false,
        Callback = function(value)
            staminaOn = value
        end
    })
    flyGroup:AddDivider()
    flyGroup:AddToggle("AntiFlingToggle", {
        Text = "防甩飞",
        Desc = "防止被其他脚本甩飞",
        Default = false,
        Callback = function(value)
            _G.CatAntiFling_Enabled = value
            if value then
                Library:Notify({ Title = "防甩飞", Description = "已开启，抵御甩飞攻击", Time = 2 })
            else
                Library:Notify({ Title = "防甩飞", Description = "已关闭", Time = 2 })
            end
        end
    })

    -- 飞天快捷开关
    local flyQuickToggle = false
    local flyQuickButton = nil
    local flyQuickScreenGui = nil
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
        flyQuickScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        flyQuickScreenGui.Parent = player:WaitForChild("PlayerGui")

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
            if flyState.enabled then
                stopFly()
            else
                startFly()
            end
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
                    startPos.X.Scale + delta.X / player:WaitForChild("PlayerGui").AbsoluteSize.X,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale + delta.Y / player:WaitForChild("PlayerGui").AbsoluteSize.Y,
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

    flyGroup:AddDivider()
    flyGroup:AddToggle("FlyQuickToggle", {
        Text = "飞天快捷开关",
        Desc = "开启后在屏幕显示可拖动的飞天开关",
        Default = false,
        Callback = function(value)
            flyQuickToggle = value
            if value then
                CreateFlyQuickToggle()
            else
                DestroyFlyQuickToggle()
            end
        end
    })

    -- ==================== 杀戮光环 UI ====================
    local kaGroup = Tabs.KA:AddLeftGroupbox("杀戮光环（枪）")
    kaGroup:AddLabel("注意：需装备枪械武器才有伤害")
    kaGroup:AddToggle("KAGunToggle", {
        Text = "启用杀戮光环（枪）",
        Default = false,
        Callback = function(value)
            kaGunEnabled = value
            if value then
                Library:Notify({ Title = "杀戮光环（枪）", Description = "已开启，正在搜索敌人", Time = 3 })
                kaGunSetStatus("状态：已开启，正在搜索敌人")
            else
                kaGunSetStatus("状态：已关闭")
            end
        end
    })
    kaGroup:AddSlider("KAGunDistance", {
        Text = "攻击距离",
        Default = 300,
        Min = 50,
        Max = 1000,
        Rounding = 0,
        Suffix = "米",
        Callback = function(value)
            KA_GUN_MAX_DISTANCE = value
        end
    })
    kaGroup:AddToggle("KAGunWallCheck", {
        Text = "墙体检测",
        Default = true,
        Callback = function(value)
            KA_GUN_WALL_CHECK = value
        end
    })
    kaGroup:AddDivider()
    kaGroup:AddToggle("KAGunTargetPoliceOnly", {
        Text = "只攻击警察",
        Desc = "开启后只攻击警察队伍的玩家",
        Default = false,
        Callback = function(value)
            KAGunTargetPoliceOnly = value
            if value and KAGunTargetCivilianOnly then
                KAGunTargetCivilianOnly = false
                Library:Notify({ Title = "队伍过滤", Description = "已自动关闭【只攻击平民】", Time = 2 })
            end
            if value then
                Library:Notify({ Title = "队伍过滤", Description = "只攻击警察队伍", Time = 2 })
            end
        end
    })
    kaGroup:AddToggle("KAGunTargetCivilianOnly", {
        Text = "只攻击平民",
        Desc = "开启后只攻击平民队伍的玩家",
        Default = false,
        Callback = function(value)
            KAGunTargetCivilianOnly = value
            if value and KAGunTargetPoliceOnly then
                KAGunTargetPoliceOnly = false
                Library:Notify({ Title = "队伍过滤", Description = "已自动关闭【只攻击警察】", Time = 2 })
            end
            if value then
                Library:Notify({ Title = "队伍过滤", Description = "只攻击平民队伍", Time = 2 })
            end
        end
    })
    kaGroup:AddToggle("KAGunIgnoreDead", {
        Text = "不攻击血量为0的玩家",
        Desc = "开启后不会攻击死亡或血量为0的玩家",
        Default = true,
        Callback = function(value)
            KAGunIgnoreDead = value
            if value then
                Library:Notify({ Title = "忽略死亡", Description = "已开启，不攻击血量为0的玩家", Time = 2 })
            else
                Library:Notify({ Title = "忽略死亡", Description = "已关闭，将攻击所有玩家", Time = 2 })
            end
        end
    })
    kaGroup:AddDivider()
    kaGroup:AddToggle("KAGunNearestOnly", {
        Text = "优先攻击最近目标",
        Desc = "开启后优先攻击25米内的敌人，25米内无人则攻击远处目标",
        Default = false,
        Callback = function(value)
            KAGunNearestOnly = value
            if value then
                Library:Notify({ Title = "杀戮光环（枪）", Description = "已切换至25米内优先攻击", Time = 2 })
            end
        end
    })
    kaGroup:AddSlider("KAGunNearestDistance", {
        Text = "优先攻击距离",
        Default = 25,
        Min = 5,
        Max = 100,
        Rounding = 0,
        Suffix = "米",
        Callback = function(value)
            KA_GUN_NEAREST_DISTANCE = value
            Library:Notify({ Title = "杀戮光环（枪）", Description = "优先攻击距离已设为" .. value .. "米", Time = 2 })
        end
    })
    kaGunStatusLabel = kaGroup:AddLabel("状态：已关闭")

    -- 刀
    local kaMeleeGroup = Tabs.KA:AddLeftGroupbox("杀戮光环（刀）")
    kaMeleeGroup:AddLabel("注意：需装备近战武器（刀/长戟等）才有伤害")
    kaMeleeGroup:AddToggle("KAMeleeToggle", {
        Text = "启用杀戮光环（刀）",
        Default = false,
        Callback = function(value)
            kaMeleeEnabled = value
            if value then
                Library:Notify({ Title = "杀戮光环（刀）", Description = "已开启，正在搜索敌人", Time = 3 })
                kaMeleeSetStatus("状态：已开启，正在搜索敌人")
            else
                kaMeleeSetStatus("状态：已关闭")
            end
        end
    })
    kaMeleeGroup:AddSlider("KAMeleeDistance", {
        Text = "攻击距离",
        Default = 300,
        Min = 50,
        Max = 1000,
        Rounding = 0,
        Suffix = "米",
        Callback = function(value)
            KA_MELEE_MAX_DISTANCE = value
        end
    })
    kaMeleeGroup:AddToggle("KAMeleeWallCheck", {
        Text = "墙体检测",
        Default = true,
        Callback = function(value)
            KA_MELEE_WALL_CHECK = value
        end
    })
    kaMeleeGroup:AddDivider()
    kaMeleeGroup:AddToggle("KAMeleeTargetPoliceOnly", {
        Text = "只攻击警察",
        Desc = "开启后只攻击警察队伍的玩家",
        Default = false,
        Callback = function(value)
            KAMeleeTargetPoliceOnly = value
            if value and KAMeleeTargetCivilianOnly then
                KAMeleeTargetCivilianOnly = false
                Library:Notify({ Title = "队伍过滤", Description = "已自动关闭【只攻击平民】", Time = 2 })
            end
            if value then
                Library:Notify({ Title = "队伍过滤", Description = "只攻击警察队伍", Time = 2 })
            end
        end
    })
    kaMeleeGroup:AddToggle("KAMeleeTargetCivilianOnly", {
        Text = "只攻击平民",
        Desc = "开启后只攻击平民队伍的玩家",
        Default = false,
        Callback = function(value)
            KAMeleeTargetCivilianOnly = value
            if value and KAMeleeTargetPoliceOnly then
                KAMeleeTargetPoliceOnly = false
                Library:Notify({ Title = "队伍过滤", Description = "已自动关闭【只攻击警察】", Time = 2 })
            end
            if value then
                Library:Notify({ Title = "队伍过滤", Description = "只攻击平民队伍", Time = 2 })
            end
        end
    })
    kaMeleeGroup:AddToggle("KAMeleeIgnoreDead", {
        Text = "不攻击血量为0的玩家",
        Desc = "开启后不会攻击死亡或血量为0的玩家",
        Default = true,
        Callback = function(value)
            KAMeleeIgnoreDead = value
            if value then
                Library:Notify({ Title = "忽略死亡", Description = "已开启，不攻击血量为0的玩家", Time = 2 })
            else
                Library:Notify({ Title = "忽略死亡", Description = "已关闭，将攻击所有玩家", Time = 2 })
            end
        end
    })
    kaMeleeGroup:AddDivider()
    kaMeleeGroup:AddToggle("KAMeleeNearestOnly", {
        Text = "优先攻击最近目标",
        Desc = "开启后优先攻击25米内的敌人，25米内无人则攻击远处目标",
        Default = false,
        Callback = function(value)
            KAMeleeNearestOnly = value
            if value then
                Library:Notify({ Title = "杀戮光环（刀）", Description = "已切换至25米内优先攻击", Time = 2 })
            end
        end
    })
    kaMeleeGroup:AddSlider("KAMeleeNearestDistance", {
        Text = "优先攻击距离",
        Default = 25,
        Min = 5,
        Max = 100,
        Rounding = 0,
        Suffix = "米",
        Callback = function(value)
            KA_MELEE_NEAREST_DISTANCE = value
            Library:Notify({ Title = "杀戮光环（刀）", Description = "优先攻击距离已设为" .. value .. "米", Time = 2 })
        end
    })
    kaMeleeStatusLabel = kaMeleeGroup:AddLabel("状态：已关闭")

    local zzGroup = Tabs.Gun:AddLeftGroupbox("子追")
    zzGroup:AddToggle("ZZToggle", {
        Text = "启用子追",
        Default = false,
        Callback = function(value)
            zzEnabled = value
            if not value then zzRestore() end
        end
    })
    zzGroup:AddSlider("ZZDistance", {
        Text = "判定距离",
        Default = 40,
        Min = 0,
        Max = 1000,
        Rounding = 0,
        Suffix = "米",
        Callback = function(value)
            zzDistance = value
        end
    })

    local aimGroup = Tabs.Gun:AddRightGroupbox("自瞄")
    aimGroup:AddToggle("AimToggle", {
        Text = "自瞄",
        Default = false,
        Callback = function(value)
            aimOn = value
        end
    })
    aimGroup:AddSlider("AimFOVSize", {
        Text = "FOV圈大小",
        Default = 150,
        Min = 30,
        Max = 400,
        Rounding = 0,
        Callback = function(value)
            aimFOV = value
        end
    })
    aimGroup:AddToggle("AimNoTeam", {
        Text = "不瞄准队友",
        Default = true,
        Callback = function(value)
            aimNoTeam = value
        end
    })
    aimGroup:AddToggle("AimWallCheck", {
        Text = "墙壁检测",
        Default = true,
        Callback = function(value)
            aimWall = value
        end
    })

    local teleTab = Tabs.Teleports
    local teleLeftGroup = teleTab:AddLeftGroupbox("传送控制")
    teleLeftGroup:AddToggle("TeleportToggle", {
        Text = "启用传送",
        Default = false,
        Callback = function(value)
            Settings.TeleportEnabled = value
        end
    })

    local teleNames = {}
    for _, data in ipairs(FIXED_TELEPORTS) do
        table.insert(teleNames, data.n)
    end

    teleLeftGroup:AddDropdown("TeleportSelect", {
        Values = teleNames,
        Default = 1,
        Multi = false,
        Text = "选定传送地点",
        Callback = function(value) end,
    })

    teleLeftGroup:AddButton({
        Text = "传送到选定地点",
        Func = function()
            if not Settings.TeleportEnabled then
                Library:Notify({ Title = "传送", Description = "你还没有开启传送开关，请先开启", Time = 3 })
                return
            end
            local selected = Options.TeleportSelect.Value
            for _, data in ipairs(FIXED_TELEPORTS) do
                if data.n == selected then
                    TeleportTo(data.p)
                    Library:Notify({
                        Title = "传送",
                        Description = "正在传送至: " .. data.n,
                        Time = 2,
                    })
                    return
                end
            end
            Library:Notify({ Title = "传送", Description = "未找到该地点", Time = 2 })
        end,
    })

    local function onPlayerAdded(p)
        p.CharacterAdded:Connect(function()
            task.wait(0.5)
            if Settings.HitboxEnabled and not isDestroyed then
                task.wait(0.5)
                ApplyHitbox()
            end
            if Settings.NoclipEnabled and not isDestroyed then
                task.wait(0.1)
                ApplyNoclip()
            end
            if ESP_ENABLED and p ~= player then
                task.wait(0.3)
                RefreshESP()
            end
        end)
        if Settings.WhitelistEnabled and not isDestroyed then
            UpdateWhitelist()
        end
    end

    for _, p in ipairs(Players:GetPlayers()) do
        onPlayerAdded(p)
    end
    local playerAddedCon = Players.PlayerAdded:Connect(onPlayerAdded)
    table.insert(connections, playerAddedCon)
    local playerRemovedCon = Players.PlayerRemoving:Connect(function(p)
        RemoveESP(p.UserId)
    end)
    table.insert(connections, playerRemovedCon)

    local renderCon = RunService.RenderStepped:Connect(function()
        if isDestroyed then return end
        if Settings.HitboxEnabled then
            frameCount = frameCount + 1
            if frameCount % 3 == 0 then
                ApplyHitbox()
            end
        end
        if Settings.NoclipEnabled then
            ApplyNoclip()
        end
    end)
    table.insert(connections, renderCon)

    task.spawn(function()
        while not isDestroyed do
            task.wait(10)
            if Settings.WhitelistEnabled and not isDestroyed then
                UpdateWhitelist()
            end
            if ESP_ENABLED then
                RefreshESP()
            end
        end
    end)

    ScanPrompts = function()
        if isDestroyed or not interactEnabled then return end
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = Settings.HoldTime
                obj.MaxActivationDistance = Settings.Distance
            end
        end
    end
    local descendantCon = workspace.DescendantAdded:Connect(function(obj)
        if isDestroyed then return end
        task.wait(0.1)
        if obj:IsA("ProximityPrompt") and interactEnabled then
            obj.HoldDuration = Settings.HoldTime
            obj.MaxActivationDistance = Settings.Distance
        end
    end)
    table.insert(connections, descendantCon)

    Library:OnUnload(function()
        if isDestroyed then return end
        isDestroyed = true
        stopFly()
        flyQuickToggle = false
        DestroyFlyQuickToggle()
        zzRestore()
        if aimGui then aimGui:Destroy() end
        ResetHitbox()
        if Settings.NoclipEnabled then
            ToggleNoclip(false)
        end
        local gui = player.PlayerGui:FindFirstChild("CoordinateCopyTool")
        if gui then gui:Destroy() end
        for userId, data in pairs(ESP_LIST) do
            if data.Billboard then
                data.Billboard:Destroy()
            end
        end
        ESP_LIST = {}
        for _, conn in ipairs(connections) do
            pcall(function() conn:Disconnect() end)
        end
        for _, conn in ipairs(noclipConnections) do
            pcall(function() conn:Disconnect() end)
        end
    end)

    local UnloadGroup = Tabs.Settings:AddLeftGroupbox("脚本管理")
    UnloadGroup:AddButton("卸载脚本", function() Library:Unload() end)
    if ThemeManager then
        ThemeManager:SetLibrary(Library)
        ThemeManager:SetFolder("MyScriptTheme")
        ThemeManager:ApplyToTab(Tabs.Settings)
    end
    if SaveManager then
        SaveManager:SetLibrary(Library)
        SaveManager:IgnoreThemeSettings()
        SaveManager:SetFolder("MyScriptConfig")
        SaveManager:BuildConfigSection(Tabs.Settings)
    end
end

-- ============================================================
-- 启动：先显示卡密验证，验证通过后执行主脚本
-- ============================================================
createVerificationUI(MainScript)