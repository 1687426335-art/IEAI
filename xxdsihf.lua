-- 先创建 UI（用代码动态生成，省得你手动拖）
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "🔑 输入卡密"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Parent = frame

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.8, 0, 0, 36)
textBox.Position = UDim2.new(0.1, 0, 0.3, 0)
textBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.PlaceholderText = "wdfex-1234-5678"
textBox.ClearTextOnFocus = false
textBox.Parent = frame

local checkBtn = Instance.new("TextButton")
checkBtn.Size = UDim2.new(0.4, 0, 0, 40)
checkBtn.Position = UDim2.new(0.3, 0, 0.6, 0)
checkBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
checkBtn.Text = "验证"
checkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
checkBtn.Parent = frame

local resultLabel = Instance.new("TextLabel")
resultLabel.Size = UDim2.new(1, 0, 0, 30)
resultLabel.Position = UDim2.new(0, 0, 0.85, 0)
resultLabel.BackgroundTransparency = 1
resultLabel.Text = ""
resultLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
resultLabel.TextScaled = true
resultLabel.Parent = frame

-- ==================== 验证逻辑 ====================

-- ✅ 预设有效卡密（只用作娱乐演示，实际要放服务器）
local validKeys = {
    "wdfex-1234-5678",
    "wdfex-abcd-efgh",
    "wdfex-9999-0000"
}

-- 格式检查函数
local function isValidFormat(key)
    -- 匹配：wdfex- + 四位字母数字 + - + 四位字母数字
    return string.match(key, "^wdfex%-%w%w%w%w%-%w%w%w%w$") ~= nil
end

-- 按钮点击事件
checkBtn.MouseButton1Click:Connect(function()
    local input = textBox.Text
    if not isValidFormat(input) then
        resultLabel.Text = "❌ 格式错误，请按 wdfex-####-####"
        resultLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    -- 检查是否在有效列表里
    local found = false
    for _, key in ipairs(validKeys) do
        if key == input then
            found = true
            break
        end
    end
    
    if found then
        resultLabel.Text = "✅ 验证通过！解锁成功！"
        resultLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        -- 🎉 这里可以放你真正要执行的代码（比如加载游戏功能）
        print("卡密正确，玩家：" .. game.Players.LocalPlayer.Name)
    else
        resultLabel.Text = "❌ 卡密无效，请重试"
        resultLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)