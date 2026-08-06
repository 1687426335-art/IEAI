-- 圣奥里出租车刷单 v13 (UI坐标提取版)
-- 从游戏界面的文字里提取乘客坐标

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
TitleLabel.Text = "🚖 圣奥里出租车 v13"
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

local StatusLabel = MakeLabel("● 状态: 已停止", 50, Color3.fromRGB(255,50,50))
local TargetLabel = MakeLabel("🎯 目标: 未开始", 85, Color3.fromRGB(200,200,200), 14)
local MoneyLabel = MakeLabel("💰 收入: $0", 120, Color3.fromRGB(255,215,0))
local TaskLabel = MakeLabel("📋 任务: 等待启动", 155, Color3.fromRGB(200,200,255), 14)
local DebugLabel = MakeLabel("", 190, Color3.fromRGB(150,150,180), 12)

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
Footer.Text = "⚡ UI坐标提取 | 拖动窗口"
Footer.TextColor3 = Color3.fromRGB(130,130,160)
Footer.TextSize = 11
Footer.TextXAlignment = Enum.TextXAlignment.Center
Footer.Font = Enum.Font.Gotham
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

-- 从UI里提取坐标数字
local function ExtractCoordinatesFromUI()
    local allText = {}
    -- 扫描所有GUI里的文字
    for _, gui in pairs(Player.PlayerGui:GetDescendants()) do
        if gui:IsA("TextLabel") or gui:IsA("TextButton") or gui:IsA("TextBox") then
            local text = gui.Text or ""
            -- 找包含三位数坐标的文本 (比如 "X: 123 Y: 456")
            local x, y, z = text:match("(%d+)%.?(%d*)%s*[Xx]%s*[=:]%s*(%d+)%.?(%d*)%s*[Yy]%s*[=:]%s*(%d+)%.?(%d*)")
            if x and y and z then
                local pos = Vector3.new(tonumber(x), tonumber(y), tonumber(z))
                return pos
            end
        end
    end
    return nil
end

-- 从workspace里找带"Waypoint"或"Marker"且会移动的对象
local function FindMovingWaypoint()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name:find("waypoint") or name:find("marker") or name:find("nav") or name:find("arrow") then
                -- 检查这个对象是否在移动 (速度 > 0)
                local velocity = obj:FindFirstChild("Velocity")
                if velocity and velocity.Value and velocity.Value.Magnitude > 1 then
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
        
        local targetPos = nil
        
        -- 方法1: 从UI提取坐标
        local uiPos = ExtractCoordinatesFromUI()
        if uiPos then
            targetPos = uiPos
            TargetLabel.Text = "🎯 目标: UI坐标提取"
        end
        
        -- 方法2: 找移动中的导航点
        if not targetPos then
            local movingPoint = FindMovingWaypoint()
            if movingPoint then
                targetPos = movingPoint
                TargetLabel.Text = "🎯 目标: 移动导航点"
            end
        end
        
        -- 方法3: 找最近的带Humanoid的NPC(排除玩家)
        if not targetPos then
            local best = nil
            local bestDist = math.huge
            local myPos = HumanoidRootPart.Position
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= Character then
                    -- 排除其他玩家
                    local isPlayer = false
                    for _, p in pairs(Players:GetPlayers()) do
                        if p.Character == obj then
                            isPlayer = true
                            break
                        end
                    end
                    if not isPlayer then
                        local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("PrimaryPart")
                        if root then
                            local dist = (root.Position - myPos).Magnitude
                            if dist < bestDist and dist > 1 then
                                bestDist = dist
                                best = root
                            end
                        end
                    end
                end
            end
            if best then
                targetPos = best.Position
                TargetLabel.Text = "🎯 目标: NPC (" .. best.Parent.Name .. ")"
            end
        end
        
        if targetPos then
            DebugLabel.Text = "距离: " .. math.floor((targetPos - HumanoidRootPart.Position).Magnitude)
            TeleportTo(targetPos)
            TaskLabel.Text = "📋 任务: 已传送"
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
        else
            TargetLabel.Text = "🎯 目标: 未找到任何数据"
            DebugLabel.Text = "扫描UI和workspace..."
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