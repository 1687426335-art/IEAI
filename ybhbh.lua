-- ================= 独立摇杆测试代码 =================
task.spawn(function()
    local lp = game:GetService("Players").LocalPlayer
    local UIS = game:GetService("UserInputService")

    local jGui = Instance.new("ScreenGui")
    jGui.Name = "NoVR_Joystick_Test"
    jGui.ResetOnSpawn = false
    jGui.IgnoreGuiInset = true
    jGui.DisplayOrder = 9999 -- 强制最高层级，防止被遮挡
    jGui.Parent = lp:WaitForChild("PlayerGui")

    local baseSize, knobSize = 180, 80
    local maxDist = (baseSize - knobSize) / 2

    local base = Instance.new("Frame", jGui)
    base.AnchorPoint = Vector2.new(0, 1)
    -- 位置：距离左边50像素，距离底部150像素（避免被手机系统栏遮挡）
    base.Position = UDim2.new(0, 50, 1, -150) 
    base.Size = UDim2.fromOffset(baseSize, baseSize)
    base.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    base.BackgroundTransparency = 0.3
    base.BorderSizePixel = 0
    base.Active = true
    
    local bc = Instance.new("UICorner", base)
    bc.CornerRadius = UDim.new(1, 0)
    local bs = Instance.new("UIStroke", base)
    bs.Color = Color3.fromRGB(0, 255, 170)
    bs.Thickness = 3
    bs.Transparency = 0.2

    -- 十字虚线
    local crossH = Instance.new("Frame", base)
    crossH.AnchorPoint = Vector2.new(0.5, 0.5)
    crossH.Position = UDim2.new(0.5, 0, 0.5, 0)
    crossH.Size = UDim2.new(1, -30, 0, 2)
    crossH.BackgroundColor3 = Color3.fromRGB(120, 120, 140)
    crossH.BackgroundTransparency = 0.5
    crossH.BorderSizePixel = 0

    local crossV = Instance.new("Frame", base)
    crossV.AnchorPoint = Vector2.new(0.5, 0.5)
    crossV.Position = UDim2.new(0.5, 0, 0.5, 0)
    crossV.Size = UDim2.new(0, 2, 1, -30)
    crossV.BackgroundColor3 = Color3.fromRGB(120, 120, 140)
    crossV.BackgroundTransparency = 0.5
    crossV.BorderSizePixel = 0

    -- 摇杆小球
    local knob = Instance.new("Frame", base)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(0.5, 0, 0.5, 0)
    knob.Size = UDim2.fromOffset(knobSize, knobSize)
    knob.BackgroundColor3 = Color3.fromRGB(0, 200, 140)
    knob.BackgroundTransparency = 0.1
    knob.BorderSizePixel = 0
    local kc = Instance.new("UICorner", knob)
    kc.CornerRadius = UDim.new(1, 0)
    local ks = Instance.new("UIStroke", knob)
    ks.Color = Color3.fromRGB(255, 255, 255)
    ks.Thickness = 3
    ks.Transparency = 0.2

    -- 文字提示
    local tip = Instance.new("TextLabel", base)
    tip.AnchorPoint = Vector2.new(0.5, 1)
    tip.Position = UDim2.new(0.5, 0, -0.15, 0)
    tip.Size = UDim2.new(1, 0, 0, 20)
    tip.BackgroundTransparency = 1
    tip.Text = "移动摇杆"
    tip.TextColor3 = Color3.fromRGB(0, 255, 170)
    tip.Font = Enum.Font.GothamBold
    tip.TextSize = 14

    print("[NoVR 测试] 摇杆UI已生成！如果能看到，说明独立代码没问题。")
    
    -- 触控逻辑
    local active = false
    local activeTouch = nil
    local joyOffset = Vector2.new(0, 0)
    
    local function getBaseCenter()
        return Vector2.new(base.AbsolutePosition.X + base.AbsoluteSize.X / 2, base.AbsolutePosition.Y + base.AbsoluteSize.Y / 2)
    end

    local function setKnobFromPos(pos)
        local center = getBaseCenter()
        local delta = Vector2.new(pos.X - center.X, pos.Y - center.Y)
        local mag = delta.Magnitude
        if mag > maxDist then delta = delta.Unit * maxDist end
        knob.Position = UDim2.new(0.5, delta.X, 0.5, delta.Y)
        joyOffset = Vector2.new(delta.X / maxDist, delta.Y / maxDist)
        -- 这里可以打印 joyOffset 来测试
        -- print("摇杆输入:", joyOffset.X, joyOffset.Y)
    end

    local function resetKnob()
        knob.Position = UDim2.new(0.5, 0, 0.5, 0)
        joyOffset = Vector2.new(0, 0)
    end

    base.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            active = true; activeTouch = input; setKnobFromPos(input.Position)
        end
    end)

    base.InputChanged:Connect(function(input)
        if active and input == activeTouch then setKnobFromPos(input.Position) end
    end)

    UIS.InputChanged:Connect(function(input)
        if active and input == activeTouch then setKnobFromPos(input.Position) end
    end)

    UIS.InputEnded:Connect(function(input)
        if active and input == activeTouch then
            active = false; activeTouch = nil; resetKnob()
        end
    end)
end)