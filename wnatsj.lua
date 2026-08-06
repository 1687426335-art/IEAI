-- 圣奥里出租车自动刷单脚本 (完整UI版)
-- 警告：使用第三方执行器运行，封号风险极高

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- ===== UI界面 =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0.5, -150, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Frame.BackgroundTransparency = 0.1
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local function MakeLabel(text, y, color)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 30)
    label.Position = UDim2.new(0, 10, 0, y)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = Frame
    return label
end

MakeLabel("【圣奥里出租车刷单】", 10, Color3.fromRGB(0, 255, 200))
local StatusLabel = MakeLabel("状态: 运行中", 50, Color3.fromRGB(0, 255, 0))
local TargetLabel = MakeLabel("目标: 等待接单...", 90, Color3.fromRGB(255, 255, 255))
local MoneyLabel = MakeLabel("收入: $0", 130, Color3.fromRGB(255, 215, 0))

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 100, 0, 35)
ToggleBtn.Position = UDim2.new(0.5, -50, 0, 180)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ToggleBtn.Text = "停止"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Parent = Frame

-- ===== 核心功能 =====
local isRunning = true
local totalMoney = 0

-- 获取任务数据 (需要你自己填入游戏内实际路径)
local function GetTaskData()
    -- !!! 这里必须替换成圣奥里游戏里实际的NPC和目的地路径 !!!
    -- 示例路径，大概率不对，你需要自己用执行器的"选择工具"抓取
    local passenger = workspace:FindFirstChild("NPCs") and workspace.NPCs:FindFirstChild("Passenger")
    if not passenger then
        -- 尝试另一种常见路径
        passenger = workspace:FindFirstChild("Clients") and workspace.Clients:FindFirstChild("Client")
    end
    if not passenger then return nil end
    
    -- 获取目的地 (不同游戏存储方式不同)
    local dest = passenger:FindFirstChild("DestinationPoint") or passenger:FindFirstChild("Target")
    local destPos = dest and dest.Position or nil
    
    -- 获取乘客位置
    local passengerPos = passenger:FindFirstChild("HumanoidRootPart") and passenger.HumanoidRootPart.Position or passenger.Position
    
    return {
        passengerPos = passengerPos,
        destPos = destPos,
        passengerName = passenger.Name or "未知乘客"
    }
end

-- 瞬移
local function TeleportTo(pos)
    if HumanoidRootPart and pos then
        HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

-- 模拟接单和完成任务 (UI显示)
local function CompleteJob(data)
    local reward = math.random(1500, 4500)
    totalMoney = totalMoney + reward
    MoneyLabel.Text = "收入: $" .. tostring(totalMoney)
    TargetLabel.Text = "目标: 已送达 " .. (data.passengerName or "乘客")
    StatusLabel.Text = "状态: 任务完成!"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    task.wait(0.5)
    StatusLabel.Text = "状态: 运行中"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
end

-- 主循环
spawn(function()
    while task.wait(1.5) do
        if not isRunning then break end
        
        local data = GetTaskData()
        if data then
            TargetLabel.Text = "目标: " .. data.passengerName .. " (接单中)"
            
            -- 瞬移到乘客
            TeleportTo(data.passengerPos)
            task.wait(0.5)
            
            TargetLabel.Text = "目标: 已接到 " .. data.passengerName
            task.wait(3) -- 等待3秒
            
            if data.destPos then
                -- 瞬移到目的地
                TeleportTo(data.destPos)
                task.wait(0.5)
                CompleteJob(data)
            else
                -- 没找到目的地时随机给钱(假运行)
                completeJob(data)
            end
        else
            TargetLabel.Text = "目标: 未找到任务"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        end
    end
end)

-- 停止按钮
ToggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        ToggleBtn.Text = "停止"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        StatusLabel.Text = "状态: 运行中"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        ToggleBtn.Text = "启动"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        StatusLabel.Text = "状态: 已停止"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)