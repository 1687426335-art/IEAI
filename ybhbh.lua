-- ==================== 卡密验证系统 ====================
-- 正确的卡密（请修改为你自己的）
local CORRECT_KEY = "wdfex2024"  -- ← 修改这里

-- ==================== GUI 创建 ====================
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeyValidation"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- 主框架
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 200)
frame.Position = UDim2.new(0.5, -175, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(100, 200, 255)
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- 标题
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "wdfex 卡密验证"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = frame

-- 状态提示
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 50)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "请输入卡密"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.Parent = frame

-- 输入框
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(0.8, 0, 0, 35)
inputBox.Position = UDim2.new(0.1, 0, 0, 85)
inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
inputBox.BorderSizePixel = 1
inputBox.BorderColor3 = Color3.fromRGB(100, 100, 120)
inputBox.Text = ""
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.TextSize = 16
inputBox.Font = Enum.Font.Gotham
inputBox.PlaceholderText = "在此输入卡密"
inputBox.ClearTextOnFocus = false
inputBox.Parent = frame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = inputBox

-- 按钮
local confirmBtn = Instance.new("TextButton")
confirmBtn.Size = UDim2.new(0.4, 0, 0, 40)
confirmBtn.Position = UDim2.new(0.3, 0, 0, 135)
confirmBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
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
local attemptCount = 0
local locked = false
local lockTimer = nil

local function onSuccess()
    -- 验证成功，执行脚本
    statusLabel.Text = "✅ 验证成功，正在加载脚本..."
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    confirmBtn.Visible = false
    inputBox.Visible = false
    
    task.wait(0.5)
    screenGui:Destroy()  -- 移除验证界面
    
    -- 执行目标脚本
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/1687426335-art/IEAI/refs/heads/main/xxdsihf.lua"))()
    end)
    if not success then
        warn("脚本加载失败: " .. tostring(err))
        -- 可以在这里显示错误通知（用StarterGui）
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "错误",
            Text = "脚本加载失败，请检查网络或脚本地址",
            Duration = 5,
        })
    end
end

local function onFail(message)
    attemptCount = attemptCount + 1
    statusLabel.Text = message .. " (剩余尝试: " .. (3 - attemptCount) .. "/3)"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    inputBox.Text = ""
    
    if attemptCount >= 3 then
        -- 锁定10秒
        locked = true
        confirmBtn.Visible = false
        inputBox.Visible = false
        statusLabel.Text = "⏳ 错误次数过多，锁定 10 秒..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        
        local startTime = os.time()
        lockTimer = task.spawn(function()
            while os.time() - startTime < 10 do
                local remaining = 10 - (os.time() - startTime)
                statusLabel.Text = "⏳ 请等待 " .. remaining .. " 秒后重试"
                task.wait(0.5)
            end
            -- 解锁
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
        statusLabel.Text = "⏳ 系统锁定中，请等待..."
        return
    end
    
    local input = inputBox.Text
    if input == "" then
        statusLabel.Text = "⚠️ 请输入卡密"
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        return
    end
    
    if input == CORRECT_KEY then
        onSuccess()
    else
        onFail("❌ 卡密错误")
    end
end)

-- 回车键支持
inputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        confirmBtn:Activate()
    end
end)

-- 防止GUI被关闭
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
    if screenGui and screenGui.Parent then
        -- 确保界面始终存在
    end
end)

-- 点击外部不影响
frame.Active = true
frame.Selectable = true