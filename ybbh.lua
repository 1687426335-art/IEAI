-- ============================================
-- wdfex碰飞 全自动锁人版（无需输入指令）
-- ============================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

local Enabled = false
local originalCFrame = nil
local statusLabel = nil

-- 自动寻找最近的活着的玩家
local function getNearestPlayer()
    local nearest = nil
    local dist = math.huge
    local myChar = lp.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= lp and plr.Character then
            local targetHRP = plr.Character:FindFirstChild("HumanoidRootPart")
            local targetHum = plr.Character:FindFirstChild("Humanoid")
            if targetHRP and targetHum and targetHum.Health > 0 then
                local d = (myHRP.Position - targetHRP.Position).Magnitude
                if d < dist then
                    dist = d
                    nearest = plr
                end
            end
        end
    end
    return nearest
end

-- 贴人循环（自动搜索目标，贴上去）
task.spawn(function()
    while task.wait(0.01) do
        if not Enabled then continue end
        
        local targetPlayer = getNearestPlayer()
        if not targetPlayer then
            if statusLabel then statusLabel.Text = "开启 (附近无人)" end
            continue
        end

        local char = targetPlayer.Character
        local myChar = lp.Character
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local targetHRP = char:FindFirstChild("HumanoidRootPart")

        if myHRP and targetHRP then
            -- 力度调大了，贴得更猛
            local offset = targetHRP.Velocity.Magnitude < 0.1 and 0 or 7
            local goal = targetHRP.CFrame * CFrame.new(0, 0, -offset) * CFrame.Angles(0, math.rad(-3), 0)
            myHRP.CFrame = myHRP.CFrame:Lerp(goal, 0.8)
            myHRP.Velocity = Vector3.new(0, 0, 0)
            myHRP.RotVelocity = Vector3.new(0, 0, 0)
            
            if statusLabel then 
                statusLabel.Text = "开启 (正在碰飞: " .. targetPlayer.Name .. ")" 
            end
        end
    end
end)

-- 强制移动循环（碰飞核心物理引擎）
task.spawn(function()
    while task.wait() do
        if not Enabled then continue end
        local hum = lp.Character and lp.Character:FindFirstChild("Humanoid")
        if hum then
            hum:Move(Vector3.one * 1e31)
        end
    end
end)

-- ============================================
-- 悬浮窗界面
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PengFeiGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = lp:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 240, 0, 160)
mainFrame.Position = UDim2.new(0.5, -120, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 170, 255)
stroke.Thickness = 1.5
stroke.Transparency = 0.3
stroke.Parent = mainFrame

-- 标题
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "wdfex碰飞 (全自动锁人)"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- 开启/关闭按钮
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 180, 0, 36)
toggleBtn.Position = UDim2.new(0.5, -90, 0, 45)
toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggleBtn.Text = "开启碰飞"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamSemibold
toggleBtn.TextSize = 14
toggleBtn.Parent = mainFrame
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = toggleBtn

-- 状态标签
statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 22)
statusLabel.Position = UDim2.new(0, 0, 0, 86)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "状态: 关闭"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- 用法提示
local hint = Instance.new("TextLabel")
hint.Size = UDim2.new(1, 0, 0, 20)
hint.Position = UDim2.new(0, 0, 0, 108)
hint.BackgroundTransparency = 1
hint.Text = "自动追踪最近玩家，无需输入指令"
hint.TextColor3 = Color3.fromRGB(255, 220, 120)
hint.TextSize = 11
hint.Font = Enum.Font.Gotham
hint.Parent = mainFrame

-- 关闭按钮
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 90, 0, 24)
closeBtn.Position = UDim2.new(0.5, -45, 0, 132)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "关闭窗口"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamSemibold
closeBtn.TextSize = 11
closeBtn.Parent = mainFrame
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- 开关点击逻辑
toggleBtn.MouseButton1Click:Connect(function()
    Enabled = not Enabled
    if Enabled then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        toggleBtn.Text = "关闭碰飞"
        statusLabel.Text = "开启 (搜索目标中...)"
    else
        toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        toggleBtn.Text = "开启碰飞"
        statusLabel.Text = "状态: 关闭"
        originalCFrame = nil
    end
end)

-- 关闭窗口
closeBtn.MouseButton1Click:Connect(function()
    Enabled = false
    originalCFrame = nil
    screenGui:Destroy()
end)

print("😝 wdfex碰飞 全自动锁人版已加载")