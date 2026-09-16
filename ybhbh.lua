-- =======================================================
-- 独立版 悬浮窗飞天脚本
-- 按 F 键 或 点击悬浮窗 开关飞行
-- WASD 移动，空格上升，左Ctrl下降
-- =======================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local flying = false
local flySpeed = 80 -- 飞行速度

-- ================= GUI 创建 (悬浮窗) =================
-- 防止重复执行导致出现多个悬浮窗
local oldGui = player:WaitForChild("PlayerGui"):FindFirstChild("MyFlyGui")
if oldGui then oldGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MyFlyGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0, 80, 0, 80)
flyBtn.Position = UDim2.new(0.1, 0, 0.3, 0) -- 初始位置
flyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
flyBtn.Text = "飞行\n关闭"
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.TextSize = 16
flyBtn.Font = Enum.Font.GothamBold
flyBtn.AutoButtonColor = false
flyBtn.Parent = screenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0) -- 圆形按钮
btnCorner.Parent = flyBtn

local btnStroke = Instance.new("UIStroke")
btnStroke.Thickness = 3
btnStroke.Color = Color3.fromRGB(100, 200, 255) -- 默认蓝色
btnStroke.Parent = flyBtn

-- ================= 悬浮窗拖拽逻辑 =================
local dragging = false
local dragStart = nil
local startPos = nil

flyBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = flyBtn.Position
        
        -- 拖动时稍微放大一点，有反馈感
        TweenService:Create(flyBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 85, 0, 85)}):Play()
    end
end)

flyBtn.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        flyBtn.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

flyBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        -- 恢复大小
        TweenService:Create(flyBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 80, 0, 80)}):Play()
    end
end)

-- ================= 飞行状态切换 =================
local function toggleFly()
    flying = not flying
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = flying -- 开启时禁用物理，防止人物乱倒
        end
    end
    
    -- 更新 UI 状态
    if flying then
        flyBtn.Text = "飞行\n开启"
        flyBtn.BackgroundColor3 = Color3.fromRGB(40, 60, 40)
        btnStroke.Color = Color3.fromRGB(0, 255, 100) -- 绿色
    else
        flyBtn.Text = "飞行\n关闭"
        flyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        btnStroke.Color = Color3.fromRGB(100, 200, 255) -- 蓝色
    end
end

-- 点击悬浮窗开启/关闭
flyBtn.MouseButton1Click:Connect(function()
    -- 如果刚拖动过，就不触发点击（防止误触）
    if not dragging then
        toggleFly()
    end
end)

-- 键盘 F 键开关
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        toggleFly()
    end
end)

-- 角色重生时自动关闭飞行状态
player.CharacterAdded:Connect(function()
    flying = false
    flyBtn.Text = "飞行\n关闭"
    flyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btnStroke.Color = Color3.fromRGB(100, 200, 255)
end)

-- ================= 飞行主循环 =================
RunService.RenderStepped:Connect(function(dt)
    if not flying then return end
    
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local moveDir = Vector3.zero

    -- 获取按键输入
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
    
    -- 空格上升，左Ctrl下降
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end

    -- 执行移动
    if moveDir.Magnitude > 0 then
        -- 直接修改 CFrame 实现无视物理飞行
        hrp.CFrame = hrp.CFrame + (moveDir.Unit * flySpeed * dt)
    end
    
    -- 强制将速度归零，防止游戏引擎把你往回拉（防甩飞）
    hrp.Velocity = Vector3.zero
end)