-- ========== wdfex踢出器 V2（玩家列表版） ==========
-- 刷新玩家列表 | 选择玩家踢出 | 可踢自己

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local selectedPlayer = nil
local minimized = false
local playerList = {}

-- ========== 创建GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = CoreGui
screenGui.Name = "KickGuiV2"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 260, 0, 380)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local mainCorner = Instance.new("UICorner")
mainCorner.Parent = mainFrame
mainCorner.CornerRadius = UDim.new(0, 14)

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Parent = mainFrame
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
titleBar.BackgroundTransparency = 0.2
titleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner")
titleCorner.Parent = titleBar
titleCorner.CornerRadius = UDim.new(0, 14)

local titleText = Instance.new("TextLabel")
titleText.Parent = titleBar
titleText.Size = UDim2.new(1, -75, 1, 0)
titleText.Position = UDim2.new(0, 40, 0, 0)
titleText.Text = "👢 踢出器 V2"
titleText.TextColor3 = Color3.fromRGB(255, 100, 100)
titleText.BackgroundTransparency = 1
titleText.TextSize = 17
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left

-- 关闭
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = titleBar
closeBtn.Size = UDim2.new(0, 35, 1, 0)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.BackgroundTransparency = 1
closeBtn.TextSize = 17
closeBtn.Font = Enum.Font.GothamBold
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    print("❌ 踢出器已关闭")
end)

-- 最小化
local minBtn = Instance.new("TextButton")
minBtn.Parent = titleBar
minBtn.Size = UDim2.new(0, 35, 1, 0)
minBtn.Position = UDim2.new(1, -70, 0, 0)
minBtn.Text = "─"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.BackgroundTransparency = 1
minBtn.TextSize = 17
minBtn.Font = Enum.Font.GothamBold
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame.Visible = false
        miniBall.Visible = true
    else
        mainFrame.Visible = true
        miniBall.Visible = false
    end
end)

-- ========== 最小化圆球 ==========
local miniBall = Instance.new("TextButton")
miniBall.Parent = screenGui
miniBall.Size = UDim2.new(0, 55, 0, 55)
miniBall.Position = UDim2.new(1, -75, 0.9, 0)
miniBall.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
miniBall.Text = "👢"
miniBall.TextColor3 = Color3.fromRGB(255, 255, 255)
miniBall.TextSize = 28
miniBall.Font = Enum.Font.GothamBold
miniBall.BorderSizePixel = 0
miniBall.Visible = false

local ballCorner = Instance.new("UICorner")
ballCorner.Parent = miniBall
ballCorner.CornerRadius = UDim.new(1, 0)

miniBall.MouseButton1Click:Connect(function()
    minimized = false
    miniBall.Visible = false
    mainFrame.Visible = true
end)

-- ========== 刷新按钮 ==========
local refreshBtn = Instance.new("TextButton")
refreshBtn.Parent = mainFrame
refreshBtn.Size = UDim2.new(0, 80, 0, 35)
refreshBtn.Position = UDim2.new(0, 10, 0, 50)
refreshBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
refreshBtn.Text = "🔄 刷新"
refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
refreshBtn.TextSize = 15
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.BorderSizePixel = 0

local refCorner = Instance.new("UICorner")
refCorner.Parent = refreshBtn
refCorner.CornerRadius = UDim.new(0, 8)

-- ========== 踢出按钮 ==========
local kickBtn = Instance.new("TextButton")
kickBtn.Parent = mainFrame
kickBtn.Size = UDim2.new(0, 120, 0, 35)
kickBtn.Position = UDim2.new(1, -130, 0, 50)
kickBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
kickBtn.Text = "👢 踢出"
kickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
kickBtn.TextSize = 15
kickBtn.Font = Enum.Font.GothamBold
kickBtn.BorderSizePixel = 0

local kickCorner = Instance.new("UICorner")
kickCorner.Parent = kickBtn
kickCorner.CornerRadius = UDim.new(0, 8)

-- ========== 玩家列表容器 ==========
local listContainer = Instance.new("ScrollingFrame")
listContainer.Parent = mainFrame
listContainer.Size = UDim2.new(1, -20, 0, 220)
listContainer.Position = UDim2.new(0, 10, 0, 95)
listContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
listContainer.BackgroundTransparency = 0.3
listContainer.BorderSizePixel = 0
listContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
listContainer.ScrollBarThickness = 4

local listCorner = Instance.new("UICorner")
listCorner.Parent = listContainer
listCorner.CornerRadius = UDim.new(0, 8)

-- ========== 玩家列表UI ==========
local playerButtons = {}

local function updatePlayerList()
    -- 清除旧按钮
    for _, btn in pairs(playerButtons) do
        btn:Destroy()
    end
    playerButtons = {}
    
    -- 获取玩家列表
    local players = {}
    for _, player in pairs(Players:GetPlayers()) do
        table.insert(players, player)
    end
    
    -- 按名称排序
    table.sort(players, function(a, b)
        return a.Name < b.Name
    end)
    
    -- 创建按钮
    local y = 5
    for _, player in pairs(players) do
        local isSelf = player == LocalPlayer
        
        local btn = Instance.new("TextButton")
        btn.Parent = listContainer
        btn.Size = UDim2.new(1, -10, 0, 32)
        btn.Position = UDim2.new(0, 5, 0, y)
        btn.BackgroundColor3 = (selectedPlayer == player) and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 60)
        btn.Text = player.Name .. (isSelf and " (自己)" or "")
        btn.TextColor3 = isSelf and Color3.fromRGB(255, 200, 100) or Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.Font = Enum.Font.Gotham
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.TextTruncate = Enum.TextTruncate.AtEnd
        btn.BorderSizePixel = 0
        btn.ZIndex = 2
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.Parent = btn
        btnCorner.CornerRadius = UDim.new(0, 6)
        
        btn.MouseButton1Click:Connect(function()
            selectedPlayer = player
            updatePlayerList()
        end)
        
        table.insert(playerButtons, btn)
        y = y + 37
    end
    
    -- 更新画布大小
    listContainer.CanvasSize = UDim2.new(0, 0, 0, y + 10)
end

-- ========== 踢出功能 ==========
local function kickPlayer(player)
    if not player then
        print("❌ 请先选择一个玩家")
        return
    end
    
    print("🔄 正在踢出: " .. player.Name .. (player == LocalPlayer and " (自己)" or ""))
    
    local success = false
    
    -- 方法1: 移除角色
    pcall(function()
        if player.Character then
            player.Character:Destroy()
            success = true
        end
    end)
    
    -- 方法2: 血量归零
    pcall(function()
        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.Health = 0
                success = true
            end
        end
    end)
    
    -- 方法3: Kick
    pcall(function()
        player:Kick("你已被踢出")
        success = true
    end)
    
    -- 方法4: 移除所有部件
    pcall(function()
        local char = player.Character
        if char then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part:Destroy()
                end
            end
            success = true
        end
    end)
    
    -- 方法5: 传送出地图
    pcall(function()
        local char = player.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(0, -99999, 0)
                success = true
            end
        end
    end)
    
    if success thenprint("✅ 已踢出: " .. player.Name)
    else
        print("❌ 踢出失败: " .. player.Name)
    end
end

-- ========== 绑定按钮事件 ==========
refreshBtn.MouseButton1Click:Connect(function()
    updatePlayerList()
    print("✅ 玩家列表已刷新")
end)

kickBtn.MouseButton1Click:Connect(function()
    if selectedPlayer then
        kickPlayer(selectedPlayer)
    else
        print("❌ 请先选择一名玩家")
    end
end)

-- ========== 快捷键 ==========
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.K then
        if selectedPlayer then
            kickPlayer(selectedPlayer)
        else
            print("❌ 请先选择一名玩家")
        end
    end
    if input.KeyCode == Enum.KeyCode.R then
        updatePlayerList()
        print("✅ 玩家列表已刷新")
    end
end)

-- ========== 状态标签 ==========
local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = mainFrame
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 0, 0, 325)
statusLabel.Text = "🟢 运行中 | 选择玩家后点踢出"
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham

local versionLabel = Instance.new("TextLabel")
versionLabel.Parent = mainFrame
versionLabel.Size = UDim2.new(1, 0, 0, 25)
versionLabel.Position = UDim2.new(0, 0, 0, 350)
versionLabel.Text = "wdfex踢出器 V2 | K键踢出 R键刷新"
versionLabel.TextColor3 = Color3.fromRGB(100, 100, 140)
versionLabel.BackgroundTransparency = 1
versionLabel.TextSize = 11
versionLabel.Font = Enum.Font.Gotham

-- ========== 启动 ==========
updatePlayerList()

print("========================================")
print("  ✅ wdfex踢出器 V2 加载成功！")
print("  选择玩家 → 点击踢出 或 按 K 键")
print("  R 键刷新列表 | 可选择自己")
print("========================================")