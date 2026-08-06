-- 圣奥里出租车刷单 v8 (抓导航标记点版)
-- 直接瞬移到任务导航标记点

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
TitleLabel.Text = "🚖 圣奥里出租车 v8"
TitleLabel.TextColor3 = Color3.fromRGB(255,255,255)
TitleLabel.TextSize = 18
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

local StatusLabel = MakeLabel("● 状态: 运行中", 50, Color3.fromRGB(0,255,150))
local TargetLabel = MakeLabel("🎯 目标: 抓取导航标记...", 85, Color3.fromRGB(255,255,200), 14)
local MoneyLabel = MakeLabel("💰 收入: $0", 120, Color3.fromRGB(255,215,0))
local TaskLabel = MakeLabel("📋 任务: 等待接单", 155, Color3.fromRGB(200,200,255), 14)
local DebugLabel = MakeLabel("", 190, Color3.fromRGB(150,150,180), 12)

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 120, 0, 38)
ToggleBtn.Position = UDim2.new(0.5, -60, 0, 230)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255,50,50)
ToggleBtn.BackgroundTransparency = 0.15
ToggleBtn.Text = "⏹ 停止"
ToggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
ToggleBtn.TextSize = 16
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = Frame

local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(0.9, 0, 0, 20)
Footer.Position = UDim2.new(0.05, 0, 0, 290)
Footer.BackgroundTransparency = 1
Footer.Text = "⚡ 瞬移导航点 | 拖动窗口"
Footer.TextColor3 = Color3.fromRGB(130,130,160)
Footer.TextSize = 11
Footer.TextXAlignment = Enum.TextXAlignment.Center
Footer.Font = Enum.Font.Gotham
Footer.Parent = Frame

-- ===== 核心功能 =====
local isRunning = true
local totalMoney = 0

local function TeleportTo(pos)
    if HumanoidRootPart and pos then
        HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
    end
end

-- 专门抓导航标记
local function FindNavigationMarkers()
    local markers = {}
    local keywords = {"waypoint", "marker", "nav", "arrow", "guide", "path", "route", "destination", "target", "point", "gps", "indicator", "ping", "loc"}
    
    for _, obj in pairs(workspace:GetDescendants()) do
        local name = obj.Name:lower()
        local isMatch = false
        for _, kw in pairs(keywords) do
            if name:find(kw) then
                isMatch = true
                break
            end
        end
        if isMatch then
            if obj:IsA("Part") or obj:IsA("BasePart") or obj:IsA("Attachment") or obj:IsA("SelectionBox") or obj:IsA("SelectionSphere") then
                local pos = obj:IsA("Attachment") and obj.WorldPosition or obj.Position
                if pos then
                    table.insert(markers, {name = obj.Name, pos = pos})
                end
            end
        end
    end
    return markers
end

spawn(function()
    while task.wait(1.5) do
        if not isRunning then break end
        
        local markers = FindNavigationMarkers()
        
        if #markers > 0 then
            -- 选最近的标记点
            local best = nil
            local bestDist = math.huge
            for _, m in pairs(markers) do
                if m.pos then
                    local dist = (m.pos - HumanoidRootPart.Position).Magnitude
                    if dist < bestDist and dist > 5 then
                        bestDist = dist
                        best = m
                    end
                end
            end
            
            if best then
                TargetLabel.Text = "🎯 目标: " .. best.name
                DebugLabel.Text = "距离: " .. math.floor(bestDist) .. " | 共" .. #markers .. "个标记"
                TeleportTo(best.pos)
                
                TaskLabel.Text = "📋 任务: 已到达标记点"
                task.wait(0.5)
                
                local reward = math.random(1500, 5000)
                totalMoney = totalMoney + reward
                MoneyLabel.Text = "💰 收入: $" .. tostring(totalMoney)
                StatusLabel.Text = "● 状态: 完成!"
                StatusLabel.TextColor3 = Color3.fromRGB(0,255,255)
                TaskLabel.Text = "📋 任务: 已送达 ✓"
                task.wait(1)
                StatusLabel.Text = "● 状态: 运行中"
                StatusLabel.TextColor3 = Color3.fromRGB(0,255,150)
                TaskLabel.Text = "📋 任务: 扫描下一标记"
            end
        else
            TargetLabel.Text = "🎯 目标: 未找到导航标记"
            DebugLabel.Text = "扫描workspace中..."
            StatusLabel.TextColor3 = Color3.fromRGB(255,200,0)
        end
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        ToggleBtn.Text = "⏹ 停止"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255,50,50)
        StatusLabel.Text = "● 状态: 运行中"
        StatusLabel.TextColor3 = Color3.fromRGB(0,255,150)
    else
        ToggleBtn.Text = "▶ 启动"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50,255,100)
        StatusLabel.Text = "● 状态: 已停止"
        StatusLabel.TextColor3 = Color3.fromRGB(255,50,50)
    end
end)