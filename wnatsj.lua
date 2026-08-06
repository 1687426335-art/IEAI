-- 圣奥里出租车刷单 v26 (极简自动版)
-- 自动检测订单 → 传乘客 → 传目的地 → 循环

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
TitleLabel.Text = "🚖 圣奥里 v26"
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
local OrderLabel = MakeLabel("📋 订单: 无", 82, Color3.fromRGB(200,200,200), 13)
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
Footer.Text = "自动检测订单 → 传乘客 → 传目的地"
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

-- 检测是否有订单 (扫描UI里的"前往客户位置"或"新目标"等文字)
local function HasOrder()
    for _, gui in pairs(Player.PlayerGui:GetDescendants()) do
        if gui:IsA("TextLabel") or gui:IsA("TextButton") then
            local text = gui.Text or ""
            if text:find("前往客户位置") or text:find("新目标") or text:find("驾驶客户") or text:find("送达") then
                return true
            end
        end
    end
    return false
end

-- 找最近的NPC (乘客)
local function FindNearestNPC()
    local best = nil
    local bestDist = math.huge
    local myPos = HumanoidRootPart.Position
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= Character then
            local isPlayer = false
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character == obj then isPlayer = true; break end
            end
            if not isPlayer then
                local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("PrimaryPart")
                if root then
                    local dist = (root.Position - myPos).Magnitude
                    if dist < bestDist then
                        bestDist = dist
                        best = root
                    end
                end
            end
        end
    end
    return best
end

-- 找目的地标记
local function FindDestination()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("BasePart") or obj:IsA("Attachment") then
            local name = obj.Name:lower()
            if name:find("destination") or name:find("target") or name:find("goal") or 
               name:find("waypoint") or name:find("marker") or name:find("arrow") or
               name:find("drop") or name:find("终点") or name:find("mark") then
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
    while task.wait(1.5) do
        if not isRunning then break end
        
        -- 1. 检测有没有订单
        if HasOrder() then
            OrderLabel.Text = "📋 订单: 有 ✓"
            
            -- 2. 找乘客 (最近的NPC)
            local npc = FindNearestNPC()
            if npc then
                local pos = npc.Position
                TargetLabel.Text = "🎯 传送到乘客: " .. npc.Parent.Name
                DebugLabel.Text = "距离: " .. math.floor((pos - HumanoidRootPart.Position).Magnitude)
                TeleportTo(pos)
                StatusLabel.Text = "● 已接客"
                StatusLabel.TextColor3 = Color3.fromRGB(0,255,200)
                task.wait(1)
                
                -- 3. 找目的地
                local dest = FindDestination()
                if dest then
                    TargetLabel.Text = "🎯 传送到目的地"
                    DebugLabel.Text = "距离: " .. math.floor((dest - HumanoidRootPart.Position).Magnitude)
                    TeleportTo(dest)
                    StatusLabel.Text = "● 已送达!"
                    StatusLabel.TextColor3 = Color3.fromRGB(0,255,255)
                    task.wait(1)
                else
                    DebugLabel.Text = "未找到目的地"
                end
            else
                TargetLabel.Text = "🎯 未找到乘客NPC"
                DebugLabel.Text = "扫描中..."
            end
        else
            OrderLabel.Text = "📋 订单: 无"
            TargetLabel.Text = "🎯 等待接单..."
            DebugLabel.Text = "去接个出租车订单"
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