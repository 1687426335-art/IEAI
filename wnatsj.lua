-- ===== 悬浮窗 =====
local function CreateFloatingWindow()
    pcall(function()
        -- 主悬浮窗
        local floatingGui = Instance.new("ScreenGui")
        floatingGui.Name = "FloatingWindow"
        floatingGui.ResetOnSpawn = false
        floatingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        floatingGui.Parent = CoreGui
        
        -- 背景框
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 160, 0, 180)
        frame.Position = UDim2.new(0, 10, 0.5, -90)
        frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        frame.BackgroundTransparency = 0.1
        frame.BorderSizePixel = 2
        frame.BorderColor3 = Color3.fromRGB(100, 200, 255)
        frame.Parent = floatingGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = frame
        
        -- 标题行
        local titleFrame = Instance.new("Frame")
        titleFrame.Size = UDim2.new(1, 0, 0, 30)
        titleFrame.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
        titleFrame.BackgroundTransparency = 0.2
        titleFrame.BorderSizePixel = 0
        titleFrame.Parent = frame
        
        local titleCorner = Instance.new("UICorner")
        titleCorner.CornerRadius = UDim.new(0, 10)
        titleCorner.Parent = titleFrame
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, 0, 1, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = "等待目标..."
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.TextSize = 14
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.Parent = titleFrame
        
        -- 状态文字
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(1, 0, 0, 25)
        statusLabel.Position = UDim2.new(0, 0, 0, 35)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = "已停止"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        statusLabel.TextSize = 16
        statusLabel.Font = Enum.Font.GothamBold
        statusLabel.Parent = frame
        
        -- 分割线
        local line = Instance.new("Frame")
        line.Size = UDim2.new(0.8, 0, 0, 1)
        line.Position = UDim2.new(0.1, 0, 0, 65)
        line.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
        line.BackgroundTransparency = 0.5
        line.BorderSizePixel = 0
        line.Parent = frame
        
        -- 功能按钮行1：出租车、高尔夫
        local btn1 = Instance.new("TextButton")
        btn1.Size = UDim2.new(0.4, 0, 0, 30)
        btn1.Position = UDim2.new(0.05, 0, 0, 75)
        btn1.BackgroundColor3 = Color3.fromRGB(60, 150, 255)
        btn1.BackgroundTransparency = 0.3
        btn1.BorderSizePixel = 0
        btn1.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn1.TextSize = 13
        btn1.Font = Enum.Font.GothamBold
        btn1.Text = "出租车"
        btn1.Parent = frame
        
        local btn1Corner = Instance.new("UICorner")
        btn1Corner.CornerRadius = UDim.new(0, 5)
        btn1Corner.Parent = btn1
        
        local btn2 = Instance.new("TextButton")
        btn2.Size = UDim2.new(0.4, 0, 0, 30)
        btn2.Position = UDim2.new(0.55, 0, 0, 75)
        btn2.BackgroundColor3 = Color3.fromRGB(60, 150, 255)
        btn2.BackgroundTransparency = 0.3
        btn2.BorderSizePixel = 0
        btn2.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn2.TextSize = 13
        btn2.Font = Enum.Font.GothamBold
        btn2.Text = "高尔夫"
        btn2.Parent = frame
        
        local btn2Corner = Instance.new("UICorner")
        btn2Corner.CornerRadius = UDim.new(0, 5)
        btn2Corner.Parent = btn2
        
        -- 功能按钮行2：自动钓鱼、公交车
        local btn3 = Instance.new("TextButton")
        btn3.Size = UDim2.new(0.4, 0, 0, 30)
        btn3.Position = UDim2.new(0.05, 0, 0, 115)
        btn3.BackgroundColor3 = Color3.fromRGB(60, 150, 255)
        btn3.BackgroundTransparency = 0.3
        btn3.BorderSizePixel = 0
        btn3.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn3.TextSize = 13
        btn3.Font = Enum.Font.GothamBold
        btn3.Text = "自动钓鱼"
        btn3.Parent = frame
        
        local btn3Corner = Instance.new("UICorner")
        btn3Corner.CornerRadius = UDim.new(0, 5)
        btn3Corner.Parent = btn3
        
        local btn4 = Instance.new("TextButton")
        btn4.Size = UDim2.new(0.4, 0, 0, 30)
        btn4.Position = UDim2.new(0.55, 0, 0, 115)
        btn4.BackgroundColor3 = Color3.fromRGB(60, 150, 255)
        btn4.BackgroundTransparency = 0.3
        btn4.BorderSizePixel = 0
        btn4.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn4.TextSize = 13
        btn4.Font = Enum.Font.GothamBold
        btn4.Text = "公交车"
        btn4.Parent = frame
        
        local btn4Corner = Instance.new("UICorner")
        btn4Corner.CornerRadius = UDim.new(0, 5)
        btn4Corner.Parent = btn4
        
        -- 最小化按钮
        local minBtn = Instance.new("TextButton")
        minBtn.Size = UDim2.new(0, 20, 0, 20)
        minBtn.Position = UDim2.new(1, -25, 0, 5)
        minBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        minBtn.BackgroundTransparency = 0.3
        minBtn.BorderSizePixel = 0
        minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        minBtn.TextSize = 14
        minBtn.Font = Enum.Font.GothamBold
        minBtn.Text = "✕"
        minBtn.Parent = frame
        
        local minCorner = Instance.new("UICorner")
        minCorner.CornerRadius = UDim.new(0, 4)
        minCorner.Parent = minBtn
        
        -- 拖动功能
        local dragging = false
        local dragStartX, dragStartY
        local startPosX, startPosY
        
        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStartX = input.Position.X
                dragStartY = input.Position.Y
                startPosX = frame.Position.X.Offset
                startPosY = frame.Position.Y.Offset
            end
        end)
        
        frame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        frame.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local deltaX = input.Position.X - dragStartX
                local deltaY = input.Position.Y - dragStartY
                frame.Position = UDim2.new(0, startPosX + deltaX, 0, startPosY + deltaY)
            end
        end)
        
        -- 关闭按钮功能
        minBtn.MouseButton1Click:Connect(function()
            floatingGui:Destroy()
        end)
    end)
end

task.spawn(function()
    task.wait(0.5)
    CreateFloatingWindow()
end)