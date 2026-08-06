-- 圣奥里出租车 v37 - 指哪传哪
-- 你在地图上标点，脚本就传送过去

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- ===== UI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 260, 0, 180)
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
TitleBar.Size = UDim2.new(1, 0, 0, 35)
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
TitleLabel.Text = "🚖 标点传送"
TitleLabel.TextColor3 = Color3.fromRGB(255,255,255)
TitleLabel.TextSize = 17
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = TitleBar

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.92, 0, 0, 28)
StatusLabel.Position = UDim2.new(0.04, 0, 0, 45)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "● 已停止"
StatusLabel.TextColor3 = Color3.fromRGB(255,80,80)
StatusLabel.TextSize = 14
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = Frame

local TargetLabel = Instance.new("TextLabel")
TargetLabel.Size = UDim2.new(0.92, 0, 0, 28)
TargetLabel.Position = UDim2.new(0.04, 0, 0, 75)
TargetLabel.BackgroundTransparency = 1
TargetLabel.Text = "🎯 未检测到标点"
TargetLabel.TextColor3 = Color3.fromRGB(255,200,0)
TargetLabel.TextSize = 13
TargetLabel.TextXAlignment = Enum.TextXAlignment.Left
TargetLabel.Font = Enum.Font.Gotham
TargetLabel.Parent = Frame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 100, 0, 34)
ToggleBtn.Position = UDim2.new(0.5, -50, 0, 120)
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

-- ===== 核心 =====
local isRunning = false
local loopThread = nil
local lastMarkerPos = nil

local function TeleportTo(pos)
    if HumanoidRootPart and pos then
        HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
    end
end

-- 找地图标点（所有叫Marker的物体）
local function FindAllMarkers()
    local markers = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("BasePart") or obj:IsA("Attachment") then
            local name = obj.Name:lower()
            if name:find("marker") or name:find("标点") or name:find("pin") or name:find("flag") or name:find("waypoint") then
                local pos = obj:IsA("Attachment") and obj.WorldPosition or obj.Position
                if pos then
                    table.insert(markers, {pos = pos, name = obj.Name})
                end
            end
        end
    end
    return markers
end

local function MainLoop()
    while task.wait(1) do
        if not isRunning then break end
        
        local markers = FindAllMarkers()
        
        if #markers > 0 then
            -- 找离你最近的标点
            local best = nil
            local bestDist = math.huge
            local myPos = HumanoidRootPart.Position
            
            for _, m in pairs(markers) do
                local dist = (m.pos - myPos).Magnitude
                if dist < bestDist then
                    bestDist = dist
                    best = m
                end
            end
            
            if best then
                TargetLabel.Text = "🎯 标点: " .. best.name
                TargetLabel.TextColor3 = Color3.fromRGB(0,255,100)
                TeleportTo(best.pos)
                StatusLabel.Text = "● 已传送!"
                StatusLabel.TextColor3 = Color3.fromRGB(0,255,255)
                task.wait(0.5)
                StatusLabel.Text = "● 运行中"
                StatusLabel.TextColor3 = Color3.fromRGB(0,255,150)
            end
        else
            TargetLabel.Text = "🎯 未检测到标点"
            TargetLabel.TextColor3 = Color3.fromRGB(255,200,0)
            StatusLabel.TextColor3 = Color3.fromRGB(255,200,0)
            task.wait(1)
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
        TargetLabel.Text = "🎯 扫描标点..."
        TargetLabel.TextColor3 = Color3.fromRGB(200,200,200)
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
        TargetLabel.TextColor3 = Color3.fromRGB(200,200,200)
    end
end)