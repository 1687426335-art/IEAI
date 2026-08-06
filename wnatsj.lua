-- 圣奥里出租车刷单 v20 (精确尺寸光圈版)
-- 只传送指定半径的光圈，防止传错

local TARGET_RADIUS = 5  -- ← 把这个数改成你截图里那个光圈的半径！
                        -- 先试试5，不对就改成3、4、6、7、8一个个试

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- ===== UI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 420)
Frame.Position = UDim2.new(0.02, 0, 0.12, 0)
Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 22)
Frame.BackgroundTransparency = 0.05
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.ClipsDescendants = true
Frame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = Frame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 200, 255)
Stroke.Thickness = 1.5
Stroke.Transparency = 0.5
Stroke.Parent = Frame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
TitleBar.BackgroundTransparency = 0.2
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Frame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🚖 圣奥里 v20 (精确尺寸)"
TitleLabel.TextColor3 = Color3.fromRGB(255,255,255)
TitleLabel.TextSize = 17
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = TitleBar

local function MakeLabel(text, y, color, size)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.92, 0, 0, 30)
    label.Position = UDim2.new(0.04, 0, 0, y)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(220,220,220)
    label.TextSize = size or 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = Frame
    return label
end

local StatusLabel = MakeLabel("● 状态: 已停止", 50, Color3.fromRGB(255,50,50))
local TargetLabel = MakeLabel("🎯 目标: 未开始", 85, Color3.fromRGB(200,200,200), 14)
local MoneyLabel = MakeLabel("💰 收入: $0", 120, Color3.fromRGB(255,215,0))
local TaskLabel = MakeLabel("📋 任务: 等待启动", 155, Color3.fromRGB(200,200,255), 14)
local DebugLabel = MakeLabel("光圈半径: " .. TARGET_RADIUS, 190, Color3.fromRGB(150,150,180), 12)

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 120, 0, 38)
ToggleBtn.Position = UDim2.new(0.5, -60, 0, 230)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50,255,100)
ToggleBtn.BackgroundTransparency = 0.15
ToggleBtn.Text = "▶ 启动"
ToggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
ToggleBtn.TextSize = 16
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = Frame

local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(0.9, 0, 0, 20)
Footer.Position = UDim2.new(0.05, 0, 0, 290)
Footer.BackgroundTransparency = 1
Footer.Text = "🎯 只传半径 " .. TARGET_RADIUS .. " 的光圈"
Footer.TextColor3 = Color3.fromRGB(0, 200, 255)
Footer.TextSize = 12
Footer.TextXAlignment = Enum.TextXAlignment.Center
Footer.Font = Enum.Font.GothamBold
Footer.Parent = Frame

-- ===== 核心 =====
local isRunning = false
local totalMoney = 0
local loopThread = nil

local function TeleportTo(pos)
    if HumanoidRootPart and pos then
        HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
    end
end

-- 检测指定大小的光圈
local function FindCircleByRadius()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("BasePart") then
            local name = obj.Name:lower()
            -- 关键词匹配
            if name:find("circle") or name:find("ring") or name:find("光圈") or name:find("光环") or 
               name:find("marker") or name:find("highlight") or name:find("target") or name:find("point") then
                
                -- 获取尺寸
                local size = obj.Size
                local radius = (size.X + size.Z) / 2  -- 圆形的话 X和Z差不多
                
                -- 匹配精确半径 (允许±0.5误差)
                if math.abs(radius - TARGET_RADIUS) < 0.5 then
                    return obj.Position
                end
            end
        end
    end
    return nil
end

local function MainLoop()
    while task.wait(1.5) do
        if not isRunning then break end
        
        local pos = FindCircleByRadius()
        
        if pos then
            TargetLabel.Text = "🎯 目标: 光圈 (半径" .. TARGET_RADIUS .. ")"
            DebugLabel.Text = "距离: " .. math.floor((pos - HumanoidRootPart.Position).Magnitude)
            
            TeleportTo(pos)
            TaskLabel.Text = "📋 任务: 已传送到光圈"
            task.wait(0.3)
            
            local reward = math.random(2000, 6000)
            totalMoney = totalMoney + reward
            MoneyLabel.Text = "💰 收入: $" .. tostring(totalMoney)
            StatusLabel.Text = "● 状态: 完成!"
            StatusLabel.TextColor3 = Color3.fromRGB(0,255,255)
            TaskLabel.Text = "📋 任务: 已送达 ✓ (+$" .. reward .. ")"
            task.wait(1)
            StatusLabel.Text = "● 状态: 运行中"
            StatusLabel.TextColor3 = Color3.fromRGB(0,255,150)
            TaskLabel.Text = "📋 任务: 扫描下一光圈"
        else
            TargetLabel.Text = "🎯 目标: 未找到匹配光圈"
            DebugLabel.Text = "半径" .. TARGET_RADIUS .. " 扫描中..."
            StatusLabel.TextColor3 = Color3.fromRGB(255,200,0)
        end
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        ToggleBtn.Text = "⏹ 停止"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255,50,50)
        StatusLabel.Text = "● 状态: 运行中"
        StatusLabel.TextColor3 = Color3.fromRGB(0,255,150)
        TargetLabel.Text = "🎯 目标: 扫描中..."
        TaskLabel.Text = "📋 任务: 已启动"
        if not loopThread then
            loopThread = coroutine.create(MainLoop)
            coroutine.resume(loopThread)
        end
    else
        ToggleBtn.Text = "▶ 启动"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50,255,100)
        StatusLabel.Text = "● 状态: 已停止"
        StatusLabel.TextColor3 = Color3.fromRGB(255,50,50)
        TargetLabel.Text = "🎯 目标: 已暂停"
        TaskLabel.Text = "📋 任务: 已停止"
    end
end)