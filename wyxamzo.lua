-- ===== 悬浮窗UI（从加密脚本完整提取） =====
-- 不依赖任何UI库，纯原生

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function CreateFloatingUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FloatingUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = CoreGui
    
    -- 主圆形按钮
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 60, 0, 60)
    mainFrame.Position = UDim2.new(0, 20, 0.5, -30)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BackgroundTransparency = 0.15
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(100, 200, 255)
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = mainFrame
    
    -- 图标
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(1, 0, 1, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = "⚡"
    iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    iconLabel.TextSize = 30
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Parent = mainFrame
    
    -- 展开面板
    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0, 220, 0, 280)
    panel.Position = UDim2.new(1, 15, 0, -10)
    panel.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    panel.BackgroundTransparency = 0.08
    panel.BorderSizePixel = 2
    panel.BorderColor3 = Color3.fromRGB(100, 200, 255)
    panel.Visible = false
    panel.Parent = mainFrame
    
    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 12)
    panelCorner.Parent = panel
    
    -- 标题
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 35)
    title.Position = UDim2.new(0, 0, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = "⚡ 控制面板"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Parent = panel
    
    -- 分隔线
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0.9, 0, 0, 1)
    line.Position = UDim2.new(0.05, 0, 0, 45)
    line.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    line.BackgroundTransparency = 0.5
    line.BorderSizePixel = 0
    line.Parent = panel
    
    -- 按钮列表
    local btnList = {"透视", "传送", "远程购买", "抢ATM", "设置"}
    local btnIcons = {"👁️", "📍", "🛒", "💰", "⚙️"}
    
    for i, name in ipairs(btnList) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.85, 0, 0, 32)
        btn.Position = UDim2.new(0.075, 0, 0, 50 + (i-1) * 38)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        btn.BackgroundTransparency = 0.5
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 15
        btn.Font = Enum.Font.Gotham
        btn.Text = btnIcons[i] .. " " .. name
        btn.Parent = panel
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        btn.MouseEnter:Connect(function()
            btn.BackgroundTransparency = 0.2
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundTransparency = 0.5
        end)
        
        btn.MouseButton1Click:Connect(function()
            panel.Visible = false
            mainFrame.Size = UDim2.new(0, 60, 0, 60)
            -- 触发对应功能
            if name == "透视" then
                -- 打开透视Tab
            elseif name == "传送" then
                -- 打开传送Tab
            elseif name == "远程购买" then
                -- 打开远程购买Tab
            elseif name == "抢ATM" then
                -- 打开抢ATMTab
            elseif name == "设置" then
                -- 打开设置Tab
            end
        end)
    end
    
    -- 版本信息
    local verLabel = Instance.new("TextLabel")
    verLabel.Size = UDim2.new(1, 0, 0, 20)
    verLabel.Position = UDim2.new(0, 0, 1, -25)
    verLabel.BackgroundTransparency = 1
    verLabel.Text = "v2.0 | 皮脚本-圣奥里"
    verLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
    verLabel.TextSize = 11
    verLabel.Font = Enum.Font.Gotham
    verLabel.Parent = panel
    
    -- ===== 拖拽功能 =====
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
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
    
    -- ===== 点击展开/收起 =====
    local isOpen = false
    mainFrame.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        panel.Visible = isOpen
        if isOpen then
            mainFrame.Size = UDim2.new(0, 240, 0, 60)
        else
            mainFrame.Size = UDim2.new(0, 60, 0, 60)
        end
    end)
    
    return screenGui
end

CreateFloatingUI()