-- 圣奥里出租车刷单 v27 (强制NPC扫描版)
-- 不依赖UI文字，直接扫描任务NPC

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- ===== UI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 280, 0, 350)
Frame.Position = UDim2.new(0.02, 0, 0.15, 0)
Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
Frame.BackgroundTransparency = 0.1
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 14)
Corner.Parent = Frame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 200, 255)
Stroke.Thickness = 1.5
Stroke.Transparency = 0.4
Stroke.Parent = Frame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 38)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
TitleBar.BackgroundTransparency = 0.2
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Frame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 14)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🚖 圣奥里 v27"
TitleLabel.TextColor3 = Color3.fromRGB(255,255,255)
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = TitleBar

local function MakeLabel(text, y, color, size)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.92, 0, 0, 28)
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

local StatusLabel = MakeLabel("● 已停止", 48, Color3.fromRGB(255,80,80))
local OrderLabel = MakeLabel("📋 状态: 待机", 82, Color3.fromRGB(200,200,200), 13)
local TargetLabel = MakeLabel("🎯 目标: 等待中", 116, Color3.fromRGB(200,200,200), 13)
local DebugLabel = MakeLabel("", 150, Color3.fromRGB(130,130,170), 11)

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 110, 0, 36)
ToggleBtn.Position = UDim2.new(0.5, -55, 0, 190)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0,220,100)
ToggleBtn.BackgroundTransparency = 0.15
ToggleBtn.Text = "▶ 启动"
ToggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
ToggleBtn.TextSize = 15
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = Frame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 10)
BtnCorner.Parent = ToggleBtn

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Color = Color3.fromRGB(0,220,100)
BtnStroke.Thickness = 1
BtnStroke.Transparency = 0.4
BtnStroke.Parent = ToggleBtn

local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(0.9, 0, 0, 18)
Footer.Position = UDim2.new(0.05, 0, 0, 250)
Footer.BackgroundTransparency = 1
Footer.Text = "自动扫描任务NPC → 传送"
Footer.TextColor3 = Color3.fromRGB(100,100,150)
Footer.TextSize = 11
Footer.TextXAlignment = Enum.TextXAlignment.Center
Footer.Font = Enum.Font.Gotham
Footer.Parent = Frame

-- ===== 核心 =====
local isRunning = false
local loopThread = nil

local function TeleportTo(pos)
    if HumanoidRootPart and pos then
        HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
    end
end

-- 找所有NPC（排除玩家）
local function FindAllNPCs()
    local npcs = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= Character then
            local isPlayer = false
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character == obj then isPlayer = true; break end
            end
            if not isPlayer then
                local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("PrimaryPart")
                if root then
                    table.insert(npcs, {
                        model = obj,
                        root = root,
                        pos = root.Position,
                        name = obj.Name
                    })
                end
            end
        end
    end
    return npcs
end

-- 找任务标记（目的地）
local function FindTaskMarker()
    local keywords = {"destination", "target", "goal", "waypoint", "marker", "arrow", "nav", "drop", "终点", "标记", "箭头"}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("BasePart") or obj:IsA("Attachment") then
            local name = obj.Name:lower()
            for _, kw in pairs(keywords) do
                if name:find(kw) then
                    local pos = obj:IsA("Attachment") and obj.WorldPosition or obj.Position
                    if pos then
                        return pos
                    end
                end
            end
        end
    end
    return nil
end

-- 检测是否有活跃任务（通过NPC数量变化或标记存在）
local function HasActiveTask()
    -- 方法1: 检查有没有任务标记
    local marker = FindTaskMarker()
    if marker then return true end
    
    -- 方法2: 检查NPC数量是否>1 (有乘客)
    local npcs = FindAllNPCs()
    if #npcs > 1 then return true end
    
    return false
end

local function MainLoop()
    while task.wait(1.5) do
        if not isRunning then break end
        
        -- 检测是否有任务
        if HasActiveTask() then
            OrderLabel.Text = "📋 状态: 有任务 ✓"
            
            -- 找最近的NPC（乘客）
            local npcs = FindAllNPCs()
            local best = nil
            local bestDist = math.huge
            local myPos = HumanoidRootPart.Position
            
            for _, npc in pairs(npcs) do
                local dist = (npc.pos - myPos).Magnitude
                if dist < bestDist and dist > 2 then
                    bestDist = dist
                    best = npc
                end
            end
            
            if best then
                TargetLabel.Text = "🎯 传送到: " .. best.name
                DebugLabel.Text = "距离: " .. math.floor(bestDist)
                TeleportTo(best.pos)
                StatusLabel.Text = "● 已接客"
                StatusLabel.TextColor3 = Color3.fromRGB(0,255,200)
                task.wait(0.5)
                
                -- 找目的地
                local dest = FindTaskMarker()
                if dest then
                    TargetLabel.Text = "🎯 传送到目的地"
                    DebugLabel.Text = "找到标记!"
                    TeleportTo(dest)
                    StatusLabel.Text = "● 已送达!"
                    StatusLabel.TextColor3 = Color3.fromRGB(0,255,255)
                    task.wait(1)
                else
                    DebugLabel.Text = "未找到目的地, 等待..."
                    task.wait(1)
                end
            else
                TargetLabel.Text = "🎯 未找到乘客"
                DebugLabel.Text = "扫描中..."
            end
        else
            OrderLabel.Text = "📋 状态: 无任务"
            TargetLabel.Text = "🎯 等待接单..."
            DebugLabel.Text = "去接出租车订单"
            StatusLabel.TextColor3 = Color3.fromRGB(255,200,0)
        end
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        ToggleBtn.Text = "⏹ 停止"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255,60,60)
        BtnStroke.Color = Color3.fromRGB(255,60,60)
        StatusLabel.Text = "● 运行中"
        StatusLabel.TextColor3 = Color3.fromRGB(0,255,150)
        TargetLabel.Text = "🎯 扫描中..."
        if not loopThread then
            loopThread = coroutine.create(MainLoop)
            coroutine.resume(loopThread)
        end
    else
        ToggleBtn.Text = "▶ 启动"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0,220,100)
        BtnStroke.Color = Color3.fromRGB(0,220,100)
        StatusLabel.Text = "● 已停止"
        StatusLabel.TextColor3 = Color3.fromRGB(255,80,80)
        TargetLabel.Text = "🎯 已暂停"
    end
end)