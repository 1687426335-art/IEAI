-- =======================================================
-- 全平台通用版 透视脚本 (全新拨动开关UI版)
-- 电脑/手机 均可拖拽，不依赖 Drawing 库
-- =======================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ==================== 配置 ====================
local Config = {
    ESPEnabled = true,
    ShowBox = true,
    ShowName = true,
    ShowDistance = true,
    ShowTeam = true,
    ShowWanted = true,
    MaxDistance = 500,
}

-- ==================== UI 构建 (现代拨动开关悬浮窗) ====================
local oldGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("ModernESP_UI")
if oldGui then oldGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ModernESP_UI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- 主容器
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 280)
mainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 2
mainStroke.Color = Color3.fromRGB(100, 100, 120)
mainStroke.Parent = mainFrame

-- 顶部标题栏 (拖拽区域)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- 修补标题栏下方的圆角，使其看起来与主框融合
local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 15)
titleFix.Position = UDim2.new(0, 0, 1, -15)
titleFix.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -20, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Universal ESP"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 15
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- 状态指示灯
local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 8, 0, 8)
statusDot.Position = UDim2.new(1, -20, 0.5, -4)
statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
statusDot.BorderSizePixel = 0
statusDot.Parent = titleBar

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = statusDot

-- 拖拽逻辑
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
titleBar.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ==================== 拨动开关生成函数 ====================
local yPos = 50
local function createSwitch(text, defaultValue, callback)
    -- 背景容器
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 32)
    container.Position = UDim2.new(0, 10, 0, yPos)
    container.BackgroundTransparency = 1
    container.Parent = mainFrame

    -- 文字
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    -- 开关轨道
    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 40, 0, 20)
    track.Position = UDim2.new(1, -45, 0.5, -10)
    track.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(60, 60, 70)
    track.BorderSizePixel = 0
    track.Parent = container

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track

    -- 开关滑块
    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.new(0, 16, 0, 16)
    thumb.Position = defaultValue and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.BorderSizePixel = 0
    thumb.Parent = track

    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = thumb

    -- 点击事件
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = container

    btn.MouseButton1Click:Connect(function()
        defaultValue = not defaultValue
        
        -- 动画效果
        if defaultValue then
            TweenService:Create(track, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 150, 255)}):Play()
            TweenService:Create(thumb, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
        else
            TweenService:Create(track, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
            TweenService:Create(thumb, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
        end
        
        callback(defaultValue)
    end)
    
    yPos = yPos + 36
end

-- 创建开关列表
createSwitch("总开关", Config.ESPEnabled, function(v) 
    Config.ESPEnabled = v 
    statusDot.BackgroundColor3 = v and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
end)
createSwitch("显示方框", Config.ShowBox, function(v) Config.ShowBox = v end)
createSwitch("显示名字", Config.ShowName, function(v) Config.ShowName = v end)
createSwitch("显示距离", Config.ShowDistance, function(v) Config.ShowDistance = v end)
createSwitch("显示队伍", Config.ShowTeam, function(v) Config.ShowTeam = v end)
createSwitch("显示通缉", Config.ShowWanted, function(v) Config.ShowWanted = v end)


-- ==================== 通用逻辑 ====================
local function GetTeamName(p)
    if p.Team then return p.Team.Name end
    return "无队伍"
end

local function CheckWanted(p)
    local function scan(obj)
        for _, child in ipairs(obj:GetChildren()) do
            local name = child.Name:lower()
            if name:find("wanted") or name:find("bounty") or name:find("criminal") or name:find("通缉") then
                if child:IsA("BoolValue") and child.Value then return true end
                if child:IsA("IntValue") and child.Value > 0 then return true end
                if child:IsA("StringValue") and child.Value ~= "" and child.Value ~= "0" then return true end
            end
        end
        return false
    end
    if scan(p) then return true end
    if p.Character and scan(p.Character) then return true end
    return false
end

-- ==================== BillboardGui 透视 ====================
local ESPCache = {}

local function CreateESP(p)
    local char = p.Character
    if not char then return end
    local attachPart = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    if not attachPart then return end

    local bb = Instance.new("BillboardGui")
    bb.Name = "ESP_UI"
    bb.Size = UDim2.new(0, 150, 0, 80)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = Config.MaxDistance
    bb.Parent = attachPart

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = bb

    local box = Instance.new("Frame")
    box.Name = "Box"
    box.Size = UDim2.new(0, 60, 0, 80)
    box.Position = UDim2.new(0.5, -30, 0, 0)
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 2
    box.BorderColor3 = Color3.fromRGB(255, 255, 255)
    box.Visible = Config.ShowBox
    box.Parent = container

    local wantedLabel = Instance.new("TextLabel")
    wantedLabel.Name = "Wanted"
    wantedLabel.Size = UDim2.new(1, 0, 0, 18)
    wantedLabel.Position = UDim2.new(0, 0, 0, -56)
    wantedLabel.BackgroundTransparency = 1
    wantedLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    wantedLabel.Text = "★通缉★"
    wantedLabel.TextSize = 14
    wantedLabel.Font = Enum.Font.GothamBold
    wantedLabel.Visible = false
    wantedLabel.Parent = container

    local teamLabel = Instance.new("TextLabel")
    teamLabel.Name = "Team"
    teamLabel.Size = UDim2.new(1, 0, 0, 18)
    teamLabel.Position = UDim2.new(0, 0, 0, -38)
    teamLabel.BackgroundTransparency = 1
    teamLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    teamLabel.TextSize = 14
    teamLabel.Font = Enum.Font.GothamBold
    teamLabel.Visible = Config.ShowTeam
    teamLabel.Parent = container

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "Name"
    nameLabel.Size = UDim2.new(1, 0, 0, 18)
    nameLabel.Position = UDim2.new(0, 0, 0, -20)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Visible = Config.ShowName
    nameLabel.Parent = container

    local distLabel = Instance.new("TextLabel")
    distLabel.Name = "Distance"
    distLabel.Size = UDim2.new(1, 0, 0, 18)
    distLabel.Position = UDim2.new(0, 0, 1, 2)
    distLabel.BackgroundTransparency = 1
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLabel.TextSize = 13
    distLabel.Font = Enum.Font.Gotham
    distLabel.Visible = Config.ShowDistance
    distLabel.Parent = container

    ESPCache[p] = { Billboard = bb, Box = box, Team = teamLabel, Name = nameLabel, Wanted = wantedLabel, Dist = distLabel }
end

local function RemoveESP(p)
    if ESPCache[p] and ESPCache[p].Billboard then
        ESPCache[p].Billboard:Destroy()
        ESPCache[p] = nil
    end
end

Players.PlayerRemoving:Connect(RemoveESP)

-- ==================== 渲染循环 ====================
RunService.RenderStepped:Connect(function()
    if not Config.ESPEnabled then
        for p, data in pairs(ESPCache) do
            if data.Billboard then data.Billboard.Enabled = false end
        end
        return
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then
            if ESPCache[p] then RemoveESP(p) end
            continue
        end

        local char = p.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if not char or not hrp or not hum or hum.Health <= 0 then
            if ESPCache[p] then RemoveESP(p) end
            continue
        end

        local myChar = LocalPlayer.Character
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHrp then continue end
        local dist = (myHrp.Position - hrp.Position).Magnitude

        if dist > Config.MaxDistance then
            if ESPCache[p] then RemoveESP(p) end
            continue
        end

        if not ESPCache[p] then
            CreateESP(p)
            task.wait()
        end

        local data = ESPCache[p]
        if not data or not data.Billboard or not data.Billboard.Parent then
            RemoveESP(p)
            CreateESP(p)
            data = ESPCache[p]
        end

        if data then
            data.Billboard.Enabled = true
            
            local tName = GetTeamName(p)
            data.Team.Text = "[" .. tName .. "]"
            data.Team.Visible = Config.ShowTeam
            
            data.Name.Text = p.Name
            data.Name.Visible = Config.ShowName
            
            data.Dist.Text = "[" .. math.floor(dist) .. "m]"
            data.Dist.Visible = Config.ShowDistance
            
            if tName:lower():find("police") or tName:find("警察") then
                data.Box.BorderColor3 = Color3.fromRGB(0, 100, 255)
            else
                data.Box.BorderColor3 = Color3.fromRGB(255, 255, 255)
            end
            data.Box.Visible = Config.ShowBox

            if Config.ShowWanted and CheckWanted(p) then
                data.Wanted.Visible = true
            else
                data.Wanted.Visible = false
            end
        end
    end
end)

-- 初始化状态
statusDot.BackgroundColor3 = Config.ESPEnabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)