-- 圣奥里出租车 v30 - 全光圈循环传送版
-- 扫描所有蓝色光圈，全部传送一遍，每个停4秒

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- ===== UI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 280, 0, 340)
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
TitleLabel.Text = "🚖 圣奥里 v30"
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
local TargetLabel = MakeLabel("🎯 等待启动", 82, Color3.fromRGB(200,200,200), 13)
local DebugLabel = MakeLabel("", 116, Color3.fromRGB(130,130,170), 11)
local CountLabel = MakeLabel("", 150, Color3.fromRGB(100,100,150), 11)

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
Footer.Text = "扫描所有光圈 → 循环传送"
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

-- 扫描所有蓝色光圈
local function FindAllBlueCircles()
    local circles = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name:find("circle") or name:find("ring") or name:find("aura") or 
               name:find("glow") or name:find("光环") or name:find("光圈") or
               name:find("marker") or name:find("target") or name:find("highlight") or
               name:find("point") or name:find("sphere") then
                
                local color = obj.Color
                if color then
                    local r, g, b = color.R * 255, color.G * 255, color.B * 255
                    if b > r and b > g and b > 80 then
                        table.insert(circles, {
                            pos = obj.Position,
                            name = obj.Name
                        })
                    end
                end
            end
        end
        -- 检测点光源
        if obj:IsA("PointLight") or obj:IsA("SpotLight") then
            local color = obj.Color
            if color then
                local r, g, b = color.R * 255, color.G * 255, color.B * 255
                if b > r and b > g and b > 80 then
                    local parent = obj.Parent
                    if parent and (parent:IsA("Part") or parent:IsA("BasePart")) then
                        table.insert(circles, {
                            pos = parent.Position,
                            name = parent.Name
                        })
                    end
                end
            end
        end
    end
    return circles
end

local function MainLoop()
    while isRunning do
        local circles = FindAllBlueCircles()
        CountLabel.Text = "🔵 找到 " .. #circles .. " 个光圈"
        
        if #circles > 0 then
            for i, circle in pairs(circles) do
                if not isRunning then break end
                
                TargetLabel.Text = "🎯 传送 " .. i .. "/" .. #circles .. ": " .. circle.name
                DebugLabel.Text = "距离: " .. math.floor((circle.pos - HumanoidRootPart.Position).Magnitude)
                TeleportTo(circle.pos)
                StatusLabel.Text = "● 已传送 (" .. i .. "/" .. #circles .. ")"
                StatusLabel.TextColor3 = Color3.fromRGB(0,255,255)
                
                -- 等待4秒
                for t = 4, 1, -1 do
                    if not isRunning then break end
                    CountLabel.Text = "⏳ 等待 " .. t .. "s"
                    task.wait(1)
                end
            end
        else
            TargetLabel.Text = "🎯 未找到光圈"
            DebugLabel.Text = "扫描中..."
            StatusLabel.TextColor3 = Color3.fromRGB(255,200,0)
            task.wait(1)
        end
        
        if not isRunning then break end
        CountLabel.Text = "🔄 重新扫描..."
        task.wait(0.5)
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
        TargetLabel.Text = "🎯 扫描光圈..."
        CountLabel.Text = "启动中..."
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
        CountLabel.Text = ""
    end
end)