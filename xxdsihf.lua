-- ==================== 创建 UI ====================
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- 背景遮罩（点击无反应，仅装饰）
local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.new(0, 0, 0)
overlay.BackgroundTransparency = 0.5
overlay.BorderSizePixel = 0
overlay.Parent = gui

-- 主卡片
local card = Instance.new("Frame")
card.Size = UDim2.new(0, 360, 0, 200)
card.Position = UDim2.new(0.5, -180, 0.5, -100)
card.BackgroundColor3 = Color3.fromRGB(245, 245, 255)  -- 浅色磨砂
card.BackgroundTransparency = 0.15
card.BorderSizePixel = 0
card.Parent = overlay

-- 圆角
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = card

-- 边框发光（用另一个Frame做描边）
local border = Instance.new("Frame")
border.Size = UDim2.new(1, 0, 1, 0)
border.BackgroundTransparency = 1
border.BorderSizePixel = 2
border.BorderColor3 = Color3.fromRGB(100, 180, 255)
border.Parent = card
local borderCorner = Instance.new("UICorner")
borderCorner.CornerRadius = UDim.new(0, 16)
borderCorner.Parent = border

-- 阴影效果（用多个UIStroke模拟，但简单起见用另一个半透明框）
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 4, 1, 4)
shadow.Position = UDim2.new(0, -2, 0, -2)
shadow.BackgroundColor3 = Color3.new(0, 0, 0)
shadow.BackgroundTransparency = 0.3
shadow.BorderSizePixel = 0
shadow.ZIndex = 0
shadow.Parent = card
local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 18)
shadowCorner.Parent = shadow

-- 标题
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 10)
title.BackgroundTransparency = 1
title.Text = "🔐 输入授权码"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextStrokeTransparency = 0.5
title.Parent = card

-- 输入框（没有格式占位）
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.8, 0, 0, 40)
textBox.Position = UDim2.new(0.1, 0, 0.35, 0)
textBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
textBox.BackgroundTransparency = 0.2
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.PlaceholderText = ""  -- 不显示任何格式
textBox.ClearTextOnFocus = false
textBox.Font = Enum.Font.GothamMedium
textBox.TextScaled = true
textBox.Parent = card
local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = textBox

-- 验证按钮
local checkBtn = Instance.new("TextButton")
checkBtn.Size = UDim2.new(0.5, 0, 0, 44)
checkBtn.Position = UDim2.new(0.25, 0, 0.6, 0)
checkBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
checkBtn.Text = "验证"
checkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
checkBtn.Font = Enum.Font.GothamBold
checkBtn.TextScaled = true
checkBtn.AutoButtonColor = false
checkBtn.Parent = card
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 12)
btnCorner.Parent = checkBtn

-- 按钮悬停效果（用Tween）
local tweenService = game:GetService("TweenService")
local btnHoverIn = tweenService:Create(checkBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 150, 255)})
local btnHoverOut = tweenService:Create(checkBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 120, 255)})
checkBtn.MouseEnter:Connect(function() btnHoverIn:Play() end)
checkBtn.MouseLeave:Connect(function() btnHoverOut:Play() end)

-- 结果标签
local resultLabel = Instance.new("TextLabel")
resultLabel.Size = UDim2.new(1, 0, 0, 30)
resultLabel.Position = UDim2.new(0, 0, 0.82, 0)
resultLabel.BackgroundTransparency = 1
resultLabel.Text = ""
resultLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
resultLabel.TextScaled = true
resultLabel.Font = Enum.Font.GothamMedium
resultLabel.Parent = card

-- ==================== 验证逻辑 ====================

-- 预设有效卡密（仅娱乐演示）
local validKeys = {
    "wdfex-1234-5678",
    "wdfex-abcd-efgh",
    "wdfex-9999-0000"
}

-- 格式检查（但不暴露格式给用户）
local function isValidFormat(key)
    return string.match(key, "^wdfex%-%w%w%w%w%-%w%w%w%w$") ~= nil
end

-- 按钮点击事件
checkBtn.MouseButton1Click:Connect(function()
    local input = textBox.Text
    if not isValidFormat(input) then
        resultLabel.Text = "❌ 卡密无效"   -- 不提示格式
        resultLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    local found = false
    for _, key in ipairs(validKeys) do
        if key == input then
            found = true
            break
        end
    end
    
    if found then
        resultLabel.Text = "✅ 验证通过！"
        resultLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        -- 🎉 成功时执行你的功能（例如加载游戏）
        print("玩家 " .. player.Name .. " 验证成功！")
        -- 可选：关闭UI
        -- gui:Destroy()
    else
        resultLabel.Text = "❌ 卡密无效"
        resultLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)