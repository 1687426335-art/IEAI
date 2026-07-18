-- ========== wdfex飞行悬浮窗 ==========
-- 一比一还原截图风格，所有按钮功能生效

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local flying = false
local bodyVelocity = nil
local flightSpeed = 20
local speedMultiplier = 1

-- 创建悬浮窗
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = CoreGui
screenGui.Name = "wdfexFlyGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 180, 0, 220)
mainFrame.Position = UDim2.new(0.5, -90, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local mainCorner = Instance.new("UICorner")
mainCorner.Parent = mainFrame
mainCorner.CornerRadius = UDim.new(0, 12)

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Parent = mainFrame
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
titleBar.BackgroundTransparency = 0.3
titleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner")
titleCorner.Parent = titleBar
titleCorner.CornerRadius = UDim.new(0, 12)

-- 关闭按钮
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = titleBar
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(0, 0, 0, 0)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.BackgroundTransparency = 1
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- 缩小按钮
local minBtn = Instance.new("TextButton")
minBtn.Parent = titleBar
minBtn.Size = UDim2.new(0, 30, 1, 0)
minBtn.Position = UDim2.new(0, 30, 0, 0)
minBtn.Text = "─"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.BackgroundTransparency = 1
minBtn.TextSize = 18
minBtn.Font = Enum.Font.GothamBold
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame.Size = UDim2.new(0, 180, 0, 30)
        mainFrame.Position = UDim2.new(0.5, -90, 0.9, 0)
        minBtn.Text = "□"
    else
        mainFrame.Size = UDim2.new(0, 180, 0, 220)
        mainFrame.Position = UDim2.new(0.5, -90, 0.5, -110)
        minBtn.Text = "─"
    end
end)

-- 标题文字
local titleText = Instance.new("TextLabel")
titleText.Parent = titleBar
titleText.Size = UDim2.new(1, -60, 1, 0)
titleText.Position = UDim2.new(0, 60, 0, 0)
titleText.Text = "wdfex飞行"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.BackgroundTransparency = 1
titleText.TextSize = 16
titleText.Font = Enum.Font.GothamBold

-- ===== 中间区域 =====
-- 上按钮
local upBtn = Instance.new("TextButton")
upBtn.Parent = mainFrame
upBtn.Size = UDim2.new(0, 50, 0, 40)
upBtn.Position = UDim2.new(0.5, -25, 0, 45)
upBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
upBtn.Text = "上"
upBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
upBtn.TextSize = 16
upBtn.Font = Enum.Font.GothamBold
upBtn.BorderSizePixel = 0

local upCorner = Instance.new("UICorner")
upCorner.Parent = upBtn
upCorner.CornerRadius = UDim.new(0, 6)

upBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        hrp.CFrame = hrp.CFrame + Vector3.new(0, 5, 0)
    end
end)

-- + 按钮 (加速)
local plusBtn = Instance.new("TextButton")
plusBtn.Parent = mainFrame
plusBtn.Size = UDim2.new(0, 40, 0, 40)
plusBtn.Position = UDim2.new(0.5, -70, 0, 90)
plusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
plusBtn.Text = "+"
plusBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
plusBtn.TextSize = 24
plusBtn.Font = Enum.Font.GothamBold
plusBtn.BorderSizePixel = 0

local plusCorner = Instance.new("UICorner")
plusCorner.Parent = plusBtn
plusCorner.CornerRadius = UDim.new(0, 6)

plusBtn.MouseButton1Click:Connect(function()
    flightSpeed = math.min(flightSpeed + 2, 30)
    print("速度:", flightSpeed)
end)

-- 飞行按钮 (中间大按钮)
local flyBtn = Instance.new("TextButton")
flyBtn.Parent = mainFrame
flyBtn.Size = UDim2.new(0, 60, 0, 50)
flyBtn.Position = UDim2.new(0.5, -30, 0, 85)
flyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
flyBtn.Text = "飞行"
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.TextSize = 18
flyBtn.Font = Enum.Font.GothamBold
flyBtn.BorderSizePixel = 0

local flyCorner = Instance.new("UICorner")
flyCorner.Parent = flyBtn
flyCorner.CornerRadius = UDim.new(0, 8)

flyBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end

    flying = not flying

    if flying then
        hum.PlatformStand = true
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bodyVelocity.Velocity = Vector3.new(0, flightSpeed, 0)
        bodyVelocity.Parent = hrp
        flyBtn.Text = "降落"
        flyBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)

        RunService.Heartbeat:Connect(function()
            if not flying or not hrp or not bodyVelocity then return end
            local move = Vector3.new(0, 0, 0)
            local speed = flightSpeed
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                move = move + hrp.CFrame.LookVector * speed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                move = move - hrp.CFrame.LookVector * speed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                move = move - hrp.CFrame.RightVector * speed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                move = move + hrp.CFrame.RightVector * speed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                move = Vector3.new(0, speed * 1.5, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                move = Vector3.new(0, -speed * 0.8, 0)
            end
            if move.Magnitude > 0 then
                bodyVelocity.Velocity = move
            else
                bodyVelocity.Velocity = Vector3.new(0, speed * 0.3, 0)
            end
        end)
    else
        hum.PlatformStand = false
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        flyBtn.Text = "飞行"
        flyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    end
end)

-- ===== 底部区域 =====
-- 下按钮
local downBtn = Instance.new("TextButton")
downBtn.Parent = mainFrame
downBtn.Size = UDim2.new(0, 50, 0, 40)
downBtn.Position = UDim2.new(0.5, -25, 0, 145)
downBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
downBtn.Text = "下"
downBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
downBtn.TextSize = 16
downBtn.Font = Enum.Font.GothamBold
downBtn.BorderSizePixel = 0

local downCorner = Instance.new("UICorner")
downCorner.Parent = downBtn
downCorner.CornerRadius = UDim.new(0, 6)

downBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        hrp.CFrame = hrp.CFrame - Vector3.new(0, 5, 0)
    end
end)

-- 1 按钮 (速度减)
local speedDownBtn = Instance.new("TextButton")
speedDownBtn.Parent = mainFrame
speedDownBtn.Size = UDim2.new(0, 40, 0, 40)
speedDownBtn.Position = UDim2.new(0.5, -70, 0, 190)
speedDownBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
speedDownBtn.Text = "1"
speedDownBtn.TextColor3 = Color3.fromRGB(255, 200, 100)
speedDownBtn.TextSize = 20
speedDownBtn.Font = Enum.Font.GothamBold
speedDownBtn.BorderSizePixel = 0

local sdCorner = Instance.new("UICorner")
sdCorner.Parent = speedDownBtn
sdCorner.CornerRadius = UDim.new(0, 6)

speedDownBtn.MouseButton1Click:Connect(function()
    flightSpeed = math.max(flightSpeed - 2, 5)
    print("速度:", flightSpeed)
end)

-- wdfex飞行 文字 (底部)
local wdfexLabel = Instance.new("TextLabel")
wdfexLabel.Parent = mainFrame
wdfexLabel.Size = UDim2.new(1, 0, 0, 25)
wdfexLabel.Position = UDim2.new(0, 0, 0, 195)
wdfexLabel.Text = "wdfex飞行"
wdfexLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
wdfexLabel.BackgroundTransparency = 1
wdfexLabel.TextSize = 14
wdfexLabel.Font = Enum.Font.Gotham

-- 快捷键 F
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F then
        flyBtn.MouseButton1Click:Fire()
    end
end)

-- 防摔
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end
    if flying then return end
    if hrp.Velocity.Y < -30 then
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = Vector3.new(hrp.Velocity.X * 0.5, 0, hrp.Velocity.Z * 0.5)
        bv.Parent = hrp
        Debris:AddItem(bv, 0.5)
    end
end)

print("========================================")
print("  ✅ wdfex飞行 加载成功！")
print("  按 F 键 或 点击飞行按钮")
print("  WASD = 方向  空格 = 上升")
print("  + 加速  |  1 减速")
print("========================================")