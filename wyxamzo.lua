-- ==================== 卡密验证系统 ====================
-- 只保留作者卡 + 70个永久卡（纯字母无规律）

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
    if not success then machineId = "unknown" end
    local combined = userId .. "_" .. machineId .. "_" .. game.GameId
    local uid = ""
    for i = 1, #combined do
        uid = uid .. string.char((string.byte(combined, i) % 26) + 65)
    end
    return uid:sub(1, 32)
end

local DEVICE_UID = getDeviceUID()

-- ==================== 卡密数据（作者卡1个 + 永久卡70个） ====================
local KEYS_DATA = {
    -- ===== 作者卡 (1个) =====
    ["作者卡-AFXD-wdfexNB"] = { type = "作者卡", days = -1, used = false, bind = nil, bindTime = nil },

    -- ===== 永久卡 FOREVER (70个，纯字母无规律) =====
    ["WDF-XKLMNOPQRS-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-ABCDEFGHIJ-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-ZYXWVUTSRQ-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-HIJKLMNOPQ-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-RSTUVWXYZQ-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-OPQRSTUVWX-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-LMNOPQRSTU-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-QWERTYUIOP-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-ASDFGHJKLM-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-ZXCVBNMQWE-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-POIULKJHGF-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-MNBVCXZLKI-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-QAZWSXEDCR-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-RFVTGBYHNU-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-JMIKOLPQRZ-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-WSXCDEFVGB-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-UJNHBGYTFR-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-EDCRFVTGBY-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-HNMIJKLOPQ-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-YTRWQPLKJH-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-GFDSAZXCVB-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-IUYTREWQAS-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-MKJNHBGYTF-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-QWERASDFTG-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-YHNBGVFCDX-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-PLKJMNBVCX-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-ZAQXSWCDEF-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-RTGVBHNJMK-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-OLKJUHYTGF-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-DEFRTGBNHY-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-SWQAZXEDCR-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-VFRBGTNHYJ-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-MJUHGYTRFD-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-KLOPIUYTRG-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-ASDQWERFGT-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-ZXCVBNMLKJ-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-HGFDSAPOIU-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-YTREWQASDF-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-UJMNKLOIPQ-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-BGVFRCDXSW-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-NHBGYTFRDE-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-IJKLMPOQAZ-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-WSXEDCVFTR-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-QAZPLMKOIJ-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-UHYTRFVDCX-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-MKJNHBGVCD-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-EWQASDZXCF-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-RTYFGHBNMJ-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-LKJHGFDSAP-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-POIUYTREWQ-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-MNBVCXZLKH-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-GFDSAPOIUY-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-JHGFDSAMNB-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-TREWQASDCF-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-YUIOKJHGFD-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-WQASZXYHBN-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-EDCVFRTGBH-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-UJMIKOLPQA-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-ZXCVBNHYTG-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-RFVCXSWAQZ-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-PLMKOIJNHB-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-GTYHBNMJIK-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-ASDFGHJKLP-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-QWERTYUIOK-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-ZXCVBNMLPO-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-IUYTREWQAZ-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-POIUYTRFVD-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-MNBVCXZASD-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-KJHGFDSAQWE-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-EDCRFVTGBN-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
    ["WDF-UJNHBGYTRE-FOREVER"] = { type = "永久卡", days = -1, used = false, bind = nil, bindTime = nil },
}

-- ==================== 验证界面 ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeyValidation"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 420, 0, 290)
frame.Position = UDim2.new(0.5, -210, 0.5, -145)
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

-- ===== 底部提示 =====
local footerLabel = Instance.new("TextLabel")
footerLabel.Size = UDim2.new(1, -20, 0, 36)
footerLabel.Position = UDim2.new(0, 10, 0, 225)
footerLabel.BackgroundTransparency = 1
footerLabel.Text = "你如果是作者认识的人可以向作者要一张月卡\n需要截图这个卡密验证的弹窗让我看到你的设备UID才可以"
footerLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
footerLabel.TextSize = 11
footerLabel.Font = Enum.Font.Gotham
footerLabel.TextXAlignment = Enum.TextXAlignment.Center
footerLabel.Parent = frame

-- ==================== 目标脚本URL ====================
local TARGET_SCRIPT_URL = "https://raw.githubusercontent.com/1687426335-art/IEAI/refs/heads/main/xxdsihf.lua"

-- ==================== 格式化剩余时间 ====================
local function formatRemainingTime(keyData)
    if keyData.days == -1 then
        return "永久"
    end
    
    if not keyData.bindTime then
        return "未绑定"
    end
    
    local totalSeconds = keyData.days * 86400
    local elapsed = os.time() - keyData.bindTime
    local remaining = totalSeconds - elapsed
    
    if remaining <= 0 then
        return "已过期"
    end
    
    local days = math.floor(remaining / 86400)
    remaining = remaining - days * 86400
    local hours = math.floor(remaining / 3600)
    remaining = remaining - hours * 3600
    local minutes = math.floor(remaining / 60)
    local seconds = math.floor(remaining % 60)
    
    if keyData.days == 1 then
        return string.format("%02d时 %02d分 %02d秒", hours, minutes, seconds)
    end
    
    return string.format("%d天 %02d时 %02d分 %02d秒", days, hours, minutes, seconds)
end

-- ==================== 验证逻辑 ====================
local attemptCount = 0
local locked = false
local lockTimer = nil

local function loadTargetScript()
    loadstring(game:HttpGet(TARGET_SCRIPT_URL))()
end

-- ==================== 成功弹窗函数 ====================
local function showSuccessPopup(keyData)
    local popupGui = Instance.new("ScreenGui")
    popupGui.Name = "SuccessPopup"
    popupGui.ResetOnSpawn = false
    popupGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    popupGui.Parent = player:WaitForChild("PlayerGui")

    local popupFrame = Instance.new("Frame")
    popupFrame.Size = UDim2.new(0, 450, 0, 320)
    popupFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
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
    icon.Position = UDim2.new(0.5, -25, 0, 8)
    icon.BackgroundTransparency = 1
    icon.Text = "✓"
    icon.TextColor3 = Color3.fromRGB(0, 255, 100)
    icon.TextSize = 40
    icon.Font = Enum.Font.GothamBold
    icon.TextXAlignment = Enum.TextXAlignment.Center
    icon.Parent = popupFrame

    -- 标题
    local popupTitle = Instance.new("TextLabel")
    popupTitle.Size = UDim2.new(1, 0, 0, 30)
    popupTitle.Position = UDim2.new(0, 0, 0, 62)
    popupTitle.BackgroundTransparency = 1
    popupTitle.Text = "验证成功！"
    popupTitle.TextColor3 = Color3.fromRGB(0, 255, 100)
    popupTitle.TextSize = 22
    popupTitle.Font = Enum.Font.GothamBold
    popupTitle.TextXAlignment = Enum.TextXAlignment.Center
    popupTitle.Parent = popupFrame

    -- 卡密类型
    local typeLabel = Instance.new("TextLabel")
    typeLabel.Size = UDim2.new(1, 0, 0, 28)
    typeLabel.Position = UDim2.new(0, 0, 0, 98)
    typeLabel.BackgroundTransparency = 1
    typeLabel.Text = "卡密类型: " .. keyData.type
    typeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    typeLabel.TextSize = 16
    typeLabel.Font = Enum.Font.GothamBold
    typeLabel.TextXAlignment = Enum.TextXAlignment.Center
    typeLabel.Parent = popupFrame

    -- 剩余时间
    local timeLabel = Instance.new("TextLabel")
    timeLabel.Size = UDim2.new(1, 0, 0, 30)
    timeLabel.Position = UDim2.new(0, 0, 0, 130)
    timeLabel.BackgroundTransparency = 1
    timeLabel.Text = "剩余: 永久"
    timeLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    timeLabel.TextSize = 16
    timeLabel.Font = Enum.Font.GothamBold
    timeLabel.TextXAlignment = Enum.TextXAlignment.Center
    timeLabel.Parent = popupFrame

    -- 设备UID
    local uidPopupLabel = Instance.new("TextLabel")
    uidPopupLabel.Size = UDim2.new(1, 0, 0, 28)
    uidPopupLabel.Position = UDim2.new(0, 0, 0, 165)
    uidPopupLabel.BackgroundTransparency = 1
    uidPopupLabel.Text = "设备UID: " .. DEVICE_UID
    uidPopupLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
    uidPopupLabel.TextSize = 13
    uidPopupLabel.Font = Enum.Font.Gotham
    uidPopupLabel.TextXAlignment = Enum.TextXAlignment.Center
    uidPopupLabel.Parent = popupFrame

    -- 底部提示
    local popupFooter = Instance.new("TextLabel")
    popupFooter.Size = UDim2.new(1, -20, 0, 20)
    popupFooter.Position = UDim2.new(0, 10, 0, 205)
    popupFooter.BackgroundTransparency = 1
    popupFooter.Text = "脚本将在 5 秒后自动加载..."
    popupFooter.TextColor3 = Color3.fromRGB(150, 150, 150)
    popupFooter.TextSize = 12
    popupFooter.Font = Enum.Font.Gotham
    popupFooter.TextXAlignment = Enum.TextXAlignment.Center
    popupFooter.Parent = popupFrame

    -- 倒计时进度条
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0.8, 0, 0, 4)
    progressBar.Position = UDim2.new(0.1, 0, 0, 235)
    progressBar.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    progressBar.BackgroundTransparency = 0.3
    progressBar.Parent = popupFrame

    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(0, 2)
    progressCorner.Parent = progressBar

    -- 5秒倒计时
    for i = 5, 1, -1 do
        popupFooter.Text = "脚本将在 " .. i .. " 秒后自动加载..."
        progressBar.Size = UDim2.new(0.8 * (i / 5), 0, 0, 4)
        task.wait(1)
    end

    popupGui:Destroy()
    loadTargetScript()
end

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

    -- 检查卡密是否已被绑定
    if keyData.used then
        if keyData.bind == DEVICE_UID then
            screenGui:Destroy()
            showSuccessPopup(keyData)
            return
        else
            attemptCount = attemptCount + 1
            local remaining = 3 - attemptCount
            statusLabel.Text = "卡密已在其他设备绑定，你无法使用 (剩余尝试: " .. remaining .. "/3)"
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
    end

    -- 首次使用，绑定设备
    keyData.used = true
    keyData.bind = DEVICE_UID
    keyData.bindTime = os.time()

    screenGui:Destroy()
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
print("卡密总数: 71个 (作者卡1个, 永久卡70个)")
print("==========================")