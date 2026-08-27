-- ============================================================
-- wdfex 卡密验证系统（极简版）
-- 卡密格式：wdfex-XXXX-XXXX
-- ============================================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local CONFIG = {
    VALID_KEYS = {
        "wdfex-a1b2-c3d4",
        "wdfex-9f8e-7d6c",
        "wdfex-5g4h-3j2k",
        "wdfex-1q2w-3e4r",
        "wdfex-6t7y-8u9i",
    },
}

local function IsKeyFormatValid(key)
    if type(key) ~= "string" then return false end
    key = key:lower()
    return string.match(key, "^wdfex%-[%w][%w][%w][%w]%-[%w][%w][%w][%w]$") ~= nil
end

local function NormalizeKey(key) return key:lower() end

local function IsKeyValid(key)
    key = NormalizeKey(key)
    for _, valid in ipairs(CONFIG.VALID_KEYS) do
        if NormalizeKey(valid) == key then return true end
    end
    return false
end

local function GetUsedKeys()
    local success, result = pcall(function() return getgenv()._wdfex_used_keys end)
    if success and result then return result end
    return {}
end

local function SaveUsedKeys(keys) getgenv()._wdfex_used_keys = keys end

local function IsKeyUsed(key)
    key = NormalizeKey(key)
    for _, k in ipairs(GetUsedKeys()) do
        if NormalizeKey(k) == key then return true end
    end
    return false
end

local function MarkKeyUsed(key)
    key = NormalizeKey(key)
    local used = GetUsedKeys()
    table.insert(used, key)
    SaveUsedKeys(used)
end

local function ValidateKey(key, onSuccess, onFail)
    if not key or key == "" then
        if onFail then onFail("请输入卡密") end
        return false
    end
    if not IsKeyFormatValid(key) then
        if onFail then onFail("格式：wdfex-XXXX-XXXX") end
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

-- ===== 创建UI =====
local function CreateKeyUI(onVerified)
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then return end
    
    local old = playerGui:FindFirstChild("wdfexKeySystem")
    if old then old:Destroy() end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "wdfexKeySystem"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- 主窗口
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 380, 0, 260)
    main.Position = UDim2.new(0.5, -190, 0.5, -130)
    main.BackgroundColor3 = Color3.fromRGB(22, 22, 40)
    main.BackgroundTransparency = 0.05
    main.BorderSizePixel = 2
    main.BorderColor3 = Color3.fromRGB(70, 140, 255)
    main.ClipsDescendants = true
    main.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = main
    
    -- 标题
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 16)
    title.BackgroundTransparency = 1
    title.Text = "wdfex 验证"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.Parent = main
    
    -- 分割线
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0.85, 0, 0, 1)
    line.Position = UDim2.new(0.075, 0, 0, 52)
    line.BackgroundColor3 = Color3.fromRGB(70, 140, 255)
    line.BackgroundTransparency = 0.5
    line.BorderSizePixel = 0
    line.Parent = main
    
    -- 副标题
    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, 0, 0, 20)
    sub.Position = UDim2.new(0, 0, 0, 62)
    sub.BackgroundTransparency = 1
    sub.Text = "请输入卡密"
    sub.TextColor3 = Color3.fromRGB(160, 170, 200)
    sub.TextSize = 14
    sub.Font = Enum.Font.Gotham
    sub.TextXAlignment = Enum.TextXAlignment.Center
    sub.Parent = main
    
    -- 输入框
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.8, 0, 0, 40)
    input.Position = UDim2.new(0.1, 0, 0, 92)
    input.BackgroundColor3 = Color3.fromRGB(35, 35, 60)
    input.BackgroundTransparency = 0.3
    input.BorderSizePixel = 1.5
    input.BorderColor3 = Color3.fromRGB(60, 80, 140)
    input.PlaceholderText = "wdfex-XXXX-XXXX"
    input.PlaceholderColor3 = Color3.fromRGB(120, 130, 170)
    input.Text = ""
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.TextSize = 16
    input.Font = Enum.Font.Gotham
    input.ClearTextOnFocus = false
    input.TextXAlignment = Enum.TextXAlignment.Center
    input.Parent = main
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = input
    
    -- 状态
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(0.8, 0, 0, 20)
    status.Position = UDim2.new(0.1, 0, 0, 138)
    status.BackgroundTransparency = 1
    status.Text = ""
    status.TextColor3 = Color3.fromRGB(255, 200, 100)
    status.TextSize = 13
    status.Font = Enum.Font.Gotham
    status.TextXAlignment = Enum.TextXAlignment.Center
    status.Parent = main
    
    -- 验证按钮
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.35, 0, 0, 38)
    btn.Position = UDim2.new(0.325, 0, 0, 168)
    btn.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
    btn.BackgroundTransparency = 0.15
    btn.BorderSizePixel = 1.5
    btn.BorderColor3 = Color3.fromRGB(80, 160, 255)
    btn.Text = "验证"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.Parent = main
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    -- 底部提示
    local tip = Instance.new("TextLabel")
    tip.Size = UDim2.new(1, 0, 0, 16)
    tip.Position = UDim2.new(0, 0, 1, -18)
    tip.BackgroundTransparency = 1
    tip.Text = "格式：wdfex-XXXX-XXXX"
    tip.TextColor3 = Color3.fromRGB(100, 110, 150)
    tip.TextSize = 11
    tip.Font = Enum.Font.Gotham
    tip.TextXAlignment = Enum.TextXAlignment.Center
    tip.Parent = main
    
    -- 关闭按钮
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 28, 0, 28)
    close.Position = UDim2.new(1, -36, 0, 8)
    close.BackgroundTransparency = 1
    close.Text = "✕"
    close.TextColor3 = Color3.fromRGB(150, 160, 200)
    close.TextSize = 16
    close.Font = Enum.Font.Gotham
    close.Parent = main
    close.MouseButton1Click:Connect(function() screenGui:Destroy() end)
    
    -- 按钮悬停
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundTransparency = 0.05 }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundTransparency = 0.15 }):Play()
    end)
    
    -- 输入框聚焦
    input.Focused:Connect(function()
        TweenService:Create(input, TweenInfo.new(0.2), { BorderColor3 = Color3.fromRGB(80, 160, 255) }):Play()
    end)
    input.FocusLost:Connect(function()
        TweenService:Create(input, TweenInfo.new(0.2), { BorderColor3 = Color3.fromRGB(60, 80, 140) }):Play()
    end)
    
    -- 验证逻辑
    local function doVerify()
        local key = input.Text
        if key ~= "" and not string.find(key:lower(), "^wdfex%-") then
            key = "wdfex-" .. key
        end
        status.Text = "验证中..."
        status.TextColor3 = Color3.fromRGB(255, 200, 100)
        ValidateKey(key,
            function()
                status.Text = "✓ 验证成功"
                status.TextColor3 = Color3.fromRGB(0, 255, 120)
                TweenService:Create(btn, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(0, 200, 100),
                    BorderColor3 = Color3.fromRGB(0, 220, 120)
                }):Play()
                task.wait(0.5)
                screenGui:Destroy()
                if onVerified then onVerified() end
            end,
            function(err)
                status.Text = "✗ " .. err
                status.TextColor3 = Color3.fromRGB(255, 80, 80)
                TweenService:Create(input, TweenInfo.new(0.15), {
                    BorderColor3 = Color3.fromRGB(255, 60, 60)
                }):Play()
                task.wait(0.25)
                TweenService:Create(input, TweenInfo.new(0.15), {
                    BorderColor3 = Color3.fromRGB(60, 80, 140)
                }):Play()
            end
        )
    end
    
    btn.MouseButton1Click:Connect(doVerify)
    input.FocusLost:Connect(function(enter) if enter then doVerify() end end)
    
    -- 拖动
    local drag = false
    local dragStart, startPos
    main.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true
            dragStart = i.Position
            startPos = main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end)
    
    -- 入场动画
    main.BackgroundTransparency = 1
    main.Size = UDim2.new(0, 360, 0, 240)
    main.Position = UDim2.new(0.5, -180, 0.5, -120)
    TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.05,
        Size = UDim2.new(0, 380, 0, 260),
        Position = UDim2.new(0.5, -190, 0.5, -130)
    }):Play()
end

local wdfex = {
    Verify = CreateKeyUI,
    CheckKey = function(key)
        if not key or key == "" then return false, "请输入卡密" end
        if not IsKeyFormatValid(key) then return false, "格式错误" end
        if not IsKeyValid(key) then return false, "卡密无效" end
        if IsKeyUsed(key) then return false, "卡密已被使用" end
        return true, "验证成功"
    end,
    ResetAllKeys = function() SaveUsedKeys({}) end,
}

wdfex.Verify(function()
    print("✅ 验证成功")
    -- 这里加载你的主脚本
end)

return wdfex