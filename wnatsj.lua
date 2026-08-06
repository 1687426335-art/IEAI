-- 圣奥里出租车刷单 v24 (纯瞬移版)
-- 两步传送：光圈NPC → 目的地 | 不加钱，纯瞬移

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- ===== 悬浮窗UI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 260, 0, 340)
Frame.Position = UDim2.new(0.02, 0, 0.15, 0)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
Frame.BackgroundTransparency = 0.15
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 16)
Corner.Parent = Frame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 220, 255)
Stroke.Thickness = 1.5
Stroke.Transparency = 0.4
Stroke.Parent = Frame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 38)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
TitleBar.BackgroundTransparency = 0.15
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Frame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 16)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🚖 圣奥里 v24"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 17
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = TitleBar

local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(0.9, 0, 0, 1)
Divider.Position = UDim2.new(0.05, 0, 0.12, 0)
Divider.BackgroundColor3 = Color3.fromRGB(0, 220, 255)
Divider.BackgroundTransparency = 0.6
Divider.BorderSizePixel = 0
Divider.Parent = Frame

local function MakeLabel(text, y, color, size, icon)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.92, 0, 0, 28)
    label.Position = UDim2.new(0.04, 0, 0, y)
    label.BackgroundTransparency = 1
    label.Text = (icon or "") .. " " .. text
    label.TextColor3 = color or Color3.fromRGB(220, 220, 220)
    label.TextSize = size or 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = Frame
    return label
end

local StatusLabel = MakeLabel("● 已停止", 48, Color3.fromRGB(255, 80, 80), 14)
local TargetLabel = MakeLabel("🎯 等待启动", 82, Color3.fromRGB(200, 200, 200), 13)
local StepLabel = MakeLabel("📌 空闲中", 116, Color3.fromRGB(180, 180, 220), 13)
local DebugLabel = MakeLabel("", 150, Color3.fromRGB(130, 130, 170), 11)

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 110, 0, 36)
ToggleBtn.Position = UDim2.new(0.5, -55, 0, 190)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 220, 100)
ToggleBtn.BackgroundTransparency = 0.15
ToggleBtn.Text = "▶ 启动"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 15
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = Frame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 10)
BtnCorner.Parent = ToggleBtn

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Color = Color3.fromRGB(0, 220, 100)
BtnStroke.Thickness = 1
BtnStroke.Transparency = 0.4
BtnStroke.Parent = ToggleBtn

local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(0.9, 0, 0, 18)
Footer.Position = UDim2.new(0.05, 0, 0, 250)
Footer.BackgroundTransparency = 1
Footer.Text = "①接客 ②送客  🔄循环"
Footer.TextColor3 = Color3.fromRGB(100, 100, 150)
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
                StepLabel.Text = "📌 已接到乘客"
                task.wait(1)
                step = 1
            else
                TargetLabel.Text = "🎯 扫描光圈NPC..."
                DebugLabel.Text = "未找到，继续"
                StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            end
        elseif step == 1 then
            local dest = FindDestination()
            if dest then
                TargetLabel.Text = "🎯 送客: 目的地"
                DebugLabel.Text = "距离: " .. math.floor((dest - HumanoidRootPart.Position).Magnitude)
                TeleportTo(dest)
                StepLabel.Text = "📌 已送达!"
                task.wait(0.5)
                StatusLabel.Text = "● 完成!"
                StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
                task.wait(1)
                StatusLabel.Text = "● 运行中"
                StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
                step = 0
            else
                TargetLabel.Text = "🎯 扫描目的地..."
                DebugLabel.Text = "未找到，继续"
                StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            end
        end
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        ToggleBtn.Text = "⏹ 停止"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        BtnStroke.Color = Color3.fromRGB(255, 60, 60)
        StatusLabel.Text = "● 运行中"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
        TargetLabel.Text = "🎯 扫描中..."
        StepLabel.Text = "📌 寻找乘客"
        if not loopThread then
            loopThread = coroutine.create(MainLoop)
            coroutine.resume(loopThread)
        end
    else
        ToggleBtn.Text = "▶ 启动"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 220, 100)
        BtnStroke.Color = Color3.fromRGB(0, 220, 100)
        StatusLabel.Text = "● 已停止"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        TargetLabel.Text = "🎯 已暂停"
        StepLabel.Text = "📌 已停止"
    end
end)