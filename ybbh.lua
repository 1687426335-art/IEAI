-- ==================== 悬浮窗（快速互动 + 自动互动） ====================
local autoInteract = false

-- 创建悬浮窗
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoInteractGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 200, 0, 130)
MainFrame.Position = UDim2.new(0.02, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.BorderSizePixel = 0
Title.Font = Enum.Font.GothamBold
Title.Text = "塔菲喵 - 互动工具"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- 快速互动按钮
local FastBtn = Instance.new("TextButton")
FastBtn.Size = UDim2.new(0.9, 0, 0, 35)
FastBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
FastBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
FastBtn.BorderSizePixel = 0
FastBtn.Font = Enum.Font.GothamBold
FastBtn.Text = "快速互动: 关"
FastBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FastBtn.TextSize = 13
FastBtn.Parent = MainFrame

local FastCorner = Instance.new("UICorner")
FastCorner.CornerRadius = UDim.new(0, 6)
FastCorner.Parent = FastBtn

-- 自动互动按钮
local AutoBtn = Instance.new("TextButton")
AutoBtn.Size = UDim2.new(0.9, 0, 0, 35)
AutoBtn.Position = UDim2.new(0.05, 0, 0.62, 0)
AutoBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AutoBtn.BorderSizePixel = 0
AutoBtn.Font = Enum.Font.GothamBold
AutoBtn.Text = "自动互动: 关"
AutoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoBtn.TextSize = 13
AutoBtn.Parent = MainFrame

local AutoCorner = Instance.new("UICorner")
AutoCorner.CornerRadius = UDim.new(0, 6)
AutoCorner.Parent = AutoBtn

-- ==================== 快速互动 ====================
local fastInteractEnabled = false
local fastInteractConn = nil

FastBtn.MouseButton1Click:Connect(function()
    fastInteractEnabled = not fastInteractEnabled
    if fastInteractEnabled then
        FastBtn.Text = "快速互动: 开"
        FastBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 100)

        -- 原代码逻辑
        fastInteractConn = game.ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
            prompt.HoldDuration = 0
        end)
    else
        FastBtn.Text = "快速互动: 关"
        FastBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        if fastInteractConn then
            fastInteractConn:Disconnect()
            fastInteractConn = nil
        end
    end
end)

-- ==================== 自动互动 ====================
AutoBtn.MouseButton1Click:Connect(function()
    local enabled = not autoInteract
    autoInteract = enabled

    if enabled then
        AutoBtn.Text = "自动互动: 开"
        AutoBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 100)

        -- 原代码逻辑
        while autoInteract do
            for _, descendant in pairs(workspace:GetDescendants()) do
                if descendant:IsA("ProximityPrompt") then
                    fireproximityprompt(descendant)
                end
            end
            task.wait(0.25)
        end
    else
        AutoBtn.Text = "自动互动: 关"
        AutoBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)
