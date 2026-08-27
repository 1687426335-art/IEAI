-- ============================================================
-- wdfex 卡密验证系统
-- 卡密格式：wdfex-XXXX-XXXX（字母数字混合，不区分大小写）
-- ============================================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- ===== 配置 =====
local CONFIG = {
    -- 预设有效卡密（生产环境建议从服务器获取）
    VALID_KEYS = {
        "wdfex-a1b2-c3d4",
        "wdfex-9f8e-7d6c",
        "wdfex-5g4h-3j2k",
        "wdfex-1q2w-3e4r",
        "wdfex-6t7y-8u9i",
    },
    -- 存储已使用卡密的Key（保存在HttpService或本地）
    SAVE_KEY = "wdfex_used_keys",
}

-- ===== 工具函数 =====
local function IsKeyFormatValid(key)
    if type(key) ~= "string" then return false end
    key = key:lower()
    -- 匹配 wdfex-xxxx-xxxx（x为字母或数字）
    local pattern = "^wdfex%-[%w][%w][%w][%w]%-[%w][%w][%w][%w]$"
    return string.match(key, pattern) ~= nil
end

local function NormalizeKey(key)
    return key:lower()
end

local function IsKeyValid(key)
    key = NormalizeKey(key)
    for _, valid in ipairs(CONFIG.VALID_KEYS) do
        if NormalizeKey(valid) == key then
            return true
        end
    end
    return false
end

-- ===== 存储已使用卡密（使用HttpService或自定义存储） =====
local function GetUsedKeys()
    local success, result = pcall(function()
        return getgenv()._wdfex_used_keys
    end)
    if success and result then
        return result
    end
    return {}
end

local function SaveUsedKeys(keys)
    getgenv()._wdfex_used_keys = keys
end

local function IsKeyUsed(key)
    key = NormalizeKey(key)
    local used = GetUsedKeys()
    for _, k in ipairs(used) do
        if NormalizeKey(k) == key then
            return true
        end
    end
    return false
end

local function MarkKeyUsed(key)
    key = NormalizeKey(key)
    local used = GetUsedKeys()
    table.insert(used, key)
    SaveUsedKeys(used)
end

-- ===== 验证主函数 =====
local function ValidateKey(key, onSuccess, onFail)
    if not key or key == "" then
        if onFail then onFail("请输入卡密") end
        return false
    end
    
    if not IsKeyFormatValid(key) then
        if onFail then onFail("卡密格式错误，正确格式：wdfex-XXXX-XXXX") end
        return false
    end
    
    if not IsKeyValid(key) then
        if onFail then onFail("卡密无效") end
        return false
    end
    
    if IsKeyUsed(key) then
        if onFail then onFail("卡密已被使用") end
        return false
    end
    
    MarkKeyUsed(key)
    if onSuccess then onSuccess() end
    return true
end

-- ===== UI ======
local function CreateKeyUI(onVerified)
    -- 防止重复创建
    local oldGui = CoreGui:FindFirstChild("wdfexKeySystem")
    if oldGui then oldGui:Destroy() end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "wdfexKeySystem"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = CoreGui
    
    -- 背景遮罩
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.6
    overlay.Parent = screenGui
    
    -- 主窗口
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 420, 0, 320)
    mainFrame.Position = UDim2.new(0.5, -210, 0.5, -160)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(100, 180, 255)
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = overlay
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- 彩色顶栏
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 4)
    topBar.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    
    -- 标题
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 12)
    title.BackgroundTransparency = 1
    title.Text = "wdfex 卡密验证"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    local subTitle = Instance.new("TextLabel")
    subTitle.Size = UDim2.new(1, 0, 0, 24)
    subTitle.Position = UDim2.new(0, 0, 0, 52)
    subTitle.BackgroundTransparency = 1
    subTitle.Text = "请输入你的卡密以激活脚本"
    subTitle.TextColor3 = Color3.fromRGB(180, 180, 200)
    subTitle.TextSize = 14
    subTitle.Font = Enum.Font.Gotham
    subTitle.Parent = mainFrame
    
    -- 输入框
    local inputBg = Instance.new("Frame")
    inputBg.Size = UDim2.new(0.85, 0, 0, 48)
    inputBg.Position = UDim2.new(0.075, 0, 0, 90)
    inputBg.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    inputBg.BackgroundTransparency = 0.3
    inputBg.BorderSizePixel = 2
    inputBg.BorderColor3 = Color3.fromRGB(60, 60, 90)
    inputBg.Parent = mainFrame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = inputBg
    
    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(1, -20, 1, 0)
    keyInput.Position = UDim2.new(0, 10, 0, 0)
    keyInput.BackgroundTransparency = 1
    keyInput.PlaceholderText = "wdfex-XXXX-XXXX"
    keyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 180)
    keyInput.Text = ""
    keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyInput.TextSize = 18
    keyInput.Font = Enum.Font.Gotham
    keyInput.ClearTextOnFocus = false
    keyInput.Parent = inputBg
    
    -- 状态提示
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0.85, 0, 0, 24)
    statusLabel.Position = UDim2.new(0.075, 0, 0, 148)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    statusLabel.TextSize = 13
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center
    statusLabel.Parent = mainFrame
    
    -- 验证按钮
    local verifyBtn = Instance.new("TextButton")
    verifyBtn.Size = UDim2.new(0.35, 0, 0, 48)
    verifyBtn.Position = UDim2.new(0.325, 0, 0, 185)
    verifyBtn.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
    verifyBtn.BackgroundTransparency = 0.15
    verifyBtn.BorderSizePixel = 2
    verifyBtn.BorderColor3 = Color3.fromRGB(100, 180, 255)
    verifyBtn.Text = "验证卡密"
    verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    verifyBtn.TextSize = 18
    verifyBtn.Font = Enum.Font.GothamBold
    verifyBtn.Parent = mainFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = verifyBtn
    
    -- 提示
    local tip = Instance.new("TextLabel")
    tip.Size = UDim2.new(1, 0, 0, 20)
    tip.Position = UDim2.new(0, 0, 0, 250)
    tip.BackgroundTransparency = 1
    tip.Text = "卡密格式：wdfex-XXXX-XXXX（字母数字不限）"
    tip.TextColor3 = Color3.fromRGB(120, 120, 150)
    tip.TextSize = 11
    tip.Font = Enum.Font.Gotham
    tip.TextXAlignment = Enum.TextXAlignment.Center
    tip.Parent = mainFrame
    
    -- ===== 验证按钮点击 =====
    verifyBtn.MouseButton1Click:Connect(function()
        local key = keyInput.Text
        statusLabel.Text = "验证中..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
        
        ValidateKey(key, 
            -- 成功
            function()
                statusLabel.Text = "✓ 验证成功！"
                statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
                
                -- 成功动画
                local tween = TweenService:Create(verifyBtn, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(0, 200, 100)
                })
                tween:Play()
                
                task.wait(0.5)
                
                -- 销毁UI
                screenGui:Destroy()
                
                -- 执行回调
                if onVerified then
                    onVerified()
                end
            end,
            -- 失败
            function(errMsg)
                statusLabel.Text = "✗ " .. errMsg
                statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
                
                local tween = TweenService:Create(inputBg, TweenInfo.new(0.15), {
                    BorderColor3 = Color3.fromRGB(255, 50, 50)
                })
                tween:Play()
                task.wait(0.3)
                TweenService:Create(inputBg, TweenInfo.new(0.15), {
                    BorderColor3 = Color3.fromRGB(60, 60, 90)
                }):Play()
            end
        )
    end)
    
    -- 回车键验证
    keyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            verifyBtn.MouseButton1Click:Fire()
        end
    end)
    
    -- 拖动窗口
    local dragging = false
    local dragStart, startPos
    
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    mainFrame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    mainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- ============================================================
-- 导出函数
-- ============================================================
-- 调用方式：wdfex.Verify(function() print("验证成功，加载脚本") end)
-- 或者直接调用：wdfex.Verify(加载脚本的函数)

local wdfex = {
    -- 验证卡密（显示UI）
    Verify = function(onVerified)
        CreateKeyUI(onVerified)
    end,
    
    -- 纯验证（不显示UI，返回布尔值）
    CheckKey = function(key)
        if not key or key == "" then
            return false, "请输入卡密"
        end
        if not IsKeyFormatValid(key) then
            return false, "卡密格式错误"
        end
        if not IsKeyValid(key) then
            return false, "卡密无效"
        end
        if IsKeyUsed(key) then
            return false, "卡密已被使用"
        end
        return true, "验证成功"
    end,
    
    -- 手动标记卡密已使用
    UseKey = function(key)
        if IsKeyValid(key) and not IsKeyUsed(key) then
            MarkKeyUsed(key)
            return true
        end
        return false
    end,
    
    -- 获取已使用卡密列表
    GetUsedKeys = GetUsedKeys,
    
    -- 重置所有已使用卡密（仅调试用）
    ResetAllKeys = function()
        SaveUsedKeys({})
    end,
}

-- ============================================================
-- 使用示例
-- ============================================================
-- [[
-- 在脚本开头调用：
-- wdfex.Verify(function()
--     print("✅ 验证成功，开始加载主脚本")
--     -- 在这里加载你的主脚本
--     loadstring(game:HttpGet("你的脚本URL"))()
-- end)
-- ]]

-- 如果直接运行此脚本，显示验证界面
wdfex.Verify(function()
    print("✅ 验证成功，脚本已激活")
    -- 这里可以放你的主功能代码
end)

return wdfex