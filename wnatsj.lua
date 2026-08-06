-- 圣奥里出租车刷单脚本 v2 (自动扫描NPC版)
-- 警告：运行即封号，风险自负

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- ===== 自动扫描找乘客 =====
local function FindPassenger()
    local found = nil
    -- 在workspace里找所有带这些关键词的对象
    for _, v in pairs(workspace:GetDescendants()) do
        local name = v.Name:lower()
        if v:IsA("Model") or v:IsA("Part") then
            if name:find("client") or name:find("passenger") or name:find("npc") or name:find("pax") or name:find("customer") or name:find("people") then
                if v:FindFirstChild("Humanoid") or v:FindFirstChild("HumanoidRootPart") then
                    found = v
                    break
                end
            end
        end
    end
    return found
end

-- ===== UI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 350, 0, 450)
Frame.Position = UDim2.new(0.5, -175, 0.5, -225)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Frame.BackgroundTransparency = 0.1
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local function MakeLabel(text, y, color, size)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 30)
    label.Position = UDim2.new(0, 10, 0, y)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(255,255,255)
    label.TextSize = size or 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = Frame
    return label
end

MakeLabel("【圣奥里出租车刷单 v2】", 10, Color3.fromRGB(0,255,200), 18)
local StatusLabel = MakeLabel("状态: 运行中", 50, Color3.fromRGB(0,255,0))
local TargetLabel = MakeLabel("目标: 扫描NPC中...", 90, Color3.fromRGB(255,255,255))
local MoneyLabel = MakeLabel("收入: $0", 130, Color3.fromRGB(255,215,0))
local DebugLabel = MakeLabel("", 170, Color3.fromRGB(200,200,200), 12)

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 120, 0, 40)
ToggleBtn.Position = UDim2.new(0.5, -60, 0, 210)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255,50,50)
ToggleBtn.Text = "停止"
ToggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
ToggleBtn.TextSize = 18
ToggleBtn.Parent = Frame

-- ===== 核心 =====
local isRunning = true
local totalMoney = 0

local function TeleportTo(pos)
    if HumanoidRootPart and pos then
        HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

local function CompleteJob()
    local reward = math.random(2000, 5000)
    totalMoney = totalMoney + reward
    MoneyLabel.Text = "收入: $" .. tostring(totalMoney)
    StatusLabel.Text = "状态: 任务完成!"
    StatusLabel.TextColor3 = Color3.fromRGB(0,255,255)
    task.wait(1)
    StatusLabel.Text = "状态: 运行中"
    StatusLabel.TextColor3 = Color3.fromRGB(0,255,0)
end

-- 主循环
spawn(function()
    while task.wait(2) do
        if not isRunning then break end

        local passenger = FindPassenger()
        if passenger then
            local root = passenger:FindFirstChild("HumanoidRootPart") or passenger:FindFirstChild("PrimaryPart") or passenger:FindFirstChildOfClass("Part")
            if root then
                local pos = root.Position
                TargetLabel.Text = "目标: " .. passenger.Name .. " (接单中)"
                DebugLabel.Text = "路径: " .. passenger:GetFullName()
                
                TeleportTo(pos)
                task.wait(0.5)
                TargetLabel.Text = "目标: 已接到 " .. passenger.Name
                task.wait(3)
                
                -- 尝试找目的地 (通常是另一个标记点)
                local destFound = false
                for _, d in pairs(workspace:GetDescendants()) do
                    if d:IsA("Part") and d.Name:lower():find("dest") or d.Name:lower():find("target") or d.Name:lower():find("point") then
                        if (d.Position - pos).Magnitude > 50 then
                            TeleportTo(d.Position)
                            destFound = true
                            break
                        end
                    end
                end
                
                if not destFound then
                    -- 没找到目的地就随机传送到附近
                    local randomOffset = Vector3.new(math.random(-100,100), 0, math.random(-100,100))
                    TeleportTo(pos + randomOffset)
                end
                
                task.wait(1)
                CompleteJob()
            else
                TargetLabel.Text = "目标: NPC无有效部位"
            end
        else
            TargetLabel.Text = "目标: 未找到乘客NPC"
            DebugLabel.Text = "尝试扫描workspace..."
            StatusLabel.TextColor3 = Color3.fromRGB(255,255,0)
        end
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        ToggleBtn.Text = "停止"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255,50,50)
        StatusLabel.Text = "状态: 运行中"
        StatusLabel.TextColor3 = Color3.fromRGB(0,255,0)
    else
        ToggleBtn.Text = "启动"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50,255,50)
        StatusLabel.Text = "状态: 已停止"
        StatusLabel.TextColor3 = Color3.fromRGB(255,0,0)
    end
end)