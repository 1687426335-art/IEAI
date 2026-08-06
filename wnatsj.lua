-- 圣奥里出租车刷单 v22 (两步传送版)
-- 第一步：传送到光圈NPC（接客）
-- 第二步：传送到目的地标记（送客）

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- ===== UI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 440)
Frame.Position = UDim2.new(0.02, 0, 0.10, 0)
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
TitleLabel.Text = "🚖 圣奥里 v22 (两步传送)"
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
    label.TextSize = size or 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = Frame
    return label
end

local StatusLabel = MakeLabel("● 状态: 已停止", 50, Color3.fromRGB(255,50,50))
local TargetLabel = MakeLabel("🎯 目标: 未开始", 85, Color3.fromRGB(200,200,200), 14)
local MoneyLabel = MakeLabel("💰 收入: $0", 120, Color3.fromRGB(255,215,0))
local TaskLabel = MakeLabel("📋 步骤: 等待启动", 155, Color3.fromRGB(200,200,255), 14)
local DebugLabel = MakeLabel("", 190, Color3.fromRGB(150,150,180), 12)

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 120, 0, 38)
ToggleBtn.Position = UDim2.new(0.5, -60, 0, 240)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50,255,100)
ToggleBtn.BackgroundTransparency = 0.15
ToggleBtn.Text = "▶ 启动"
ToggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
ToggleBtn.TextSize = 16
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = Frame

local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(0.9, 0, 0, 20)
Footer.Position = UDim2.new(0.05, 0, 0, 300)
Footer.BackgroundTransparency = 1
Footer.Text = "①传NPC ②传目的地"
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

-- 找光圈NPC
local function FindAuraNPC()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= Character then
            local isPlayer = false
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character == obj then isPlayer = true; break end
            end
            if not isPlayer then
                local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("PrimaryPart")
                if root then
                    for _, child in pairs(obj:GetChildren()) do
                        if child:IsA("Part") or child:IsA("BasePart") then
                            local name = child.Name:lower()
                            if name:find("circle") or name:find("ring") or name:find("aura") or name:find("glow") or name:find("光环") or name:find("光圈") then
                                return root
                            end
                        end
                    end
                    local npcName = obj.Name:lower()
                    if npcName:find("aura") or npcName:find("ring") or npcName:find("circle") or npcName:find("光环") or npcName:find("光圈") then
                        return root
                    end
                end
            end
        end
    end
    return nil
end

-- 找目的地标记
local function FindDestination()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("BasePart") or obj:IsA("Attachment") then
            local name = obj.Name:lower()
            if name:find("destination") or name:find("target") or name:find("goal") or name:find("终点") or 
               name:find("waypoint") or name:find("marker") or name:find("arrow") or name:find("nav") or
               name:find("finish") or name:find("end") or name:find("drop") then
                local pos = obj:IsA("Attachment") and obj.WorldPosition or obj.Position
                if pos then
                    return pos
                end
            end
        end
    end
    return nil
end

local function MainLoop()
    local step = 0
    while task.wait(1.5) do
        if not isRunning then break end
        
        if step == 0 then
            local npc = FindAuraNPC()
            if npc then
                local pos = npc.Position
                TargetLabel.Text = "🎯 接客: " .. npc.Parent.Name
                DebugLabel.Text = "距离: " .. math.floor((pos - HumanoidRootPart.Position).Magnitude)
                TeleportTo(pos)
                TaskLabel.Text = "📋 步骤: 已接到乘客"
                task.wait(1)
                step = 1
            else
                TargetLabel.Text = "🎯 扫描光圈NPC..."
                DebugLabel.Text = "未找到，继续扫描"
                StatusLabel.TextColor3 = Color3.fromRGB(255,200,0)
            end
        elseif step == 1 then
            local dest = FindDestination()
            if dest then
                TargetLabel.Text = "🎯 送客: 目的地"
                DebugLabel.Text = "距离: " .. math.floor((dest - HumanoidRootPart.Position).Magnitude)
                TeleportTo(dest)
                TaskLabel.Text = "📋 步骤: 已送达!"
                task.wait(0.5)
                local reward = math.random(2000, 6000)
                totalMoney = totalMoney + reward
                MoneyLabel.Text = "💰 收入: $" .. tostring(totalMoney)
                StatusLabel.Text = "● 状态: 完成! (+$" .. reward .. ")"
                StatusLabel.TextColor3 = Color3.fromRGB(0,255,255)
                task.wait(1)
                StatusLabel.Text = "● 状态: 运行中"
                StatusLabel.TextColor3 = Color3.fromRGB(0,255,150)
                step = 0
            else
                TargetLabel.Text = "🎯 扫描目的地..."
                DebugLabel.Text = "未找到，继续扫描"
                StatusLabel.TextColor3 = Color3.fromRGB(255,200,0)
            end
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
        TargetLabel.Text = "🎯 扫描中..."
        TaskLabel.Text = "📋 步骤: 寻找乘客"
        if not loopThread then
            loopThread = coroutine.create(MainLoop)
            coroutine.resume(loopThread)
        end
    else
        ToggleBtn.Text = "▶ 启动"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50,255,100)
        StatusLabel.Text = "● 状态: 已停止"
        StatusLabel.TextColor3 = Color3.fromRGB(255,50,50)
        TargetLabel.Text = "🎯 已暂停"
        TaskLabel.Text = "📋 步骤: 已停止"
    end
end)