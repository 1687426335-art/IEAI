-- ==================== 卡密管理系统 ====================
-- 卡密类型: 天卡(DAY) 周卡(WEEK) 月卡(MONTH) 永久(FOREVER)
-- 每种类型25个，共100个卡密
-- 存储方式: DataStore（需游戏开启权限）

-- ==================== 配置 ====================
local CONFIG = {
    PREFIX = "WDF",
    KEY_LENGTH = 10,
    MAX_ATTEMPTS = 3,
    LOCK_TIME = 10,
    DATASTORE_NAME = "KeySystemData",
}

-- ==================== 工具函数 ====================
local function generateRandomString(length)
    local chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
    local result = ""
    for i = 1, length do
        result = result .. chars:sub(math.random(1, #chars), math.random(1, #chars))
    end
    return result
end

local function getDeviceUID()
    local player = game.Players.LocalPlayer
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

-- ==================== 生成100个卡密 ====================
local function generateKeys()
    local keys = {}
    local types = {
        { name = "DAY", count = 25, days = 1 },
        { name = "WEEK", count = 25, days = 7 },
        { name = "MONTH", count = 25, days = 30 },
        { name = "FOREVER", count = 25, days = -1 },
    }
    
    for _, t in ipairs(types) do
        for i = 1, t.count do
            local code = generateRandomString(CONFIG.KEY_LENGTH)
            local key = CONFIG.PREFIX .. "-" .. code .. "-" .. t.name
            keys[key] = {
                type = t.name,
                days = t.days,
                generated = os.time(),
                used = false,
                bind = nil,
                bindTime = nil,
            }
        end
    end
    return keys
end

-- ==================== DataStore 存储 ====================
local DataStoreService = game:GetService("DataStoreService")
local store = DataStoreService:GetDataStore(CONFIG.DATASTORE_NAME)

local KeyStorage = {}

function KeyStorage.saveKeys(keys)
    local success, err = pcall(function()
        store:SetAsync("all_keys", keys)
    end)
    return success, err
end

function KeyStorage.getKeys()
    local success, result = pcall(function()
        return store:GetAsync("all_keys")
    end)
    if success and result then
        return result
    end
    return nil
end

function KeyStorage.initKeys()
    local existing = KeyStorage.getKeys()
    if existing then
        return existing
    end
    local newKeys = generateKeys()
    KeyStorage.saveKeys(newKeys)
    return newKeys
end

function KeyStorage.bindKey(key, uid)
    local keys = KeyStorage.getKeys()
    if not keys or not keys[key] then
        return false, "卡密不存在"
    end
    if keys[key].used then
        return false, "卡密已被使用"
    end
    keys[key].used = true
    keys[key].bind = uid
    keys[key].bindTime = os.time()
    KeyStorage.saveKeys(keys)
    return true
end

function KeyStorage.checkKey(key)
    local keys = KeyStorage.getKeys()
    if not keys or not keys[key] then
        return false, "卡密不存在"
    end
    local data = keys[key]
    if data.used then
        return false, "卡密已被使用"
    end
    if data.days ~= -1 then
        local elapsed = os.time() - data.generated
        if elapsed > data.days * 86400 then
            return false, "卡密已过期"
        end
    end
    return true, data
end

-- ==================== 初始化卡密 ====================
local ALL_KEYS = KeyStorage.initKeys()
local attemptCount = 0
local locked = false
local lockTimer = nil

-- ==================== GUI 验证界面 ====================
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeyValidation"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 380, 0, 220)
frame.Position = UDim2.new(0.5, -190, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(80, 180, 255)
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "wdfex 卡密验证"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 28)
statusLabel.Position = UDim2.new(0, 10, 0, 55)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "请输入您的卡密"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.Parent = frame

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(0.8, 0, 0, 38)
inputBox.Position = UDim2.new(0.1, 0, 0, 92)
inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
inputBox.BorderSizePixel = 1
inputBox.BorderColor3 = Color3.fromRGB(100, 100, 130)
inputBox.Text = ""
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.TextSize = 16
inputBox.Font = Enum.Font.Gotham
inputBox.PlaceholderText = "输入卡密 (例: WDF-XXXXX-DAY)"
inputBox.ClearTextOnFocus = false
inputBox.Parent = frame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = inputBox

local confirmBtn = Instance.new("TextButton")
confirmBtn.Size = UDim2.new(0.35, 0, 0, 42)
confirmBtn.Position = UDim2.new(0.325, 0, 0, 145)
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

-- ==================== 验证逻辑 ====================
local function onSuccess()
    statusLabel.Text = "验证成功，正在加载脚本..."
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    confirmBtn.Visible = false
    inputBox.Visible = false
    task.wait(0.6)
    screenGui:Destroy()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/1687426335-art/IEAI/refs/heads/main/xxdsihf.lua"))()
    end)
    if not success then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "错误",
            Text = "脚本加载失败: " .. tostring(err),
            Duration = 5,
        })
    end
end

local function onFail(message)
    attemptCount = attemptCount + 1
    local remaining = CONFIG.MAX_ATTEMPTS - attemptCount
    statusLabel.Text = message .. " (剩余尝试: " .. remaining .. "/" .. CONFIG.MAX_ATTEMPTS .. ")"
    statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    inputBox.Text = ""
    
    if attemptCount >= CONFIG.MAX_ATTEMPTS then
        locked = true
        confirmBtn.Visible = false
        inputBox.Visible = false
        statusLabel.Text = "错误次数过多，锁定 " .. CONFIG.LOCK_TIME .. " 秒"
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        
        local startTime = os.time()
        lockTimer = task.spawn(function()
            while os.time() - startTime < CONFIG.LOCK_TIME do
                local remaining = CONFIG.LOCK_TIME - (os.time() - startTime)
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
    local valid, data = KeyStorage.checkKey(input)
    if valid then
        local bindSuccess, bindMsg = KeyStorage.bindKey(input, DEVICE_UID)
        if bindSuccess then
            onSuccess()
        else
            onFail(bindMsg)
        end
    else
        onFail(data)
    end
end)

inputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        confirmBtn:Activate()
    end
end)

frame.Active = true
frame.Selectable = true