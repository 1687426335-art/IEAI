-- =======================================================
-- 全平台通用版 透视脚本 (电脑/手机/任意执行器)
-- 纯原生UI，不依赖 Drawing 库，不限于特定游戏
-- =======================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ==================== 配置区域 ====================
local Config = {
    ESPEnabled = true,       -- 总开关
    ShowBox = true,          -- 显示方框
    ShowName = true,         -- 显示名字
    ShowDistance = true,     -- 显示距离
    ShowTeam = true,         -- 显示队伍
    ShowWanted = true,       -- 显示通缉
    MaxDistance = 500,       -- 最大透视距离
}

-- ==================== 通用悬浮窗 UI ====================
-- 清理旧UI避免重复执行
local oldGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("UniversalESP_UI")
if oldGui then oldGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UniversalESP_UI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 160, 0, 250)
mainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
mainFrame.Active = true
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
title.Text = "通用透视"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- 通用的触摸/鼠标拖拽逻辑 (手机电脑通用)
local dragging = false
local dragStart, startPos
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
title.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- 开关按钮生成函数
local yPos = 45
local function createToggle(text, defaultValue, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(100, 0, 0)
    btn.Text = text .. ": " .. (defaultValue and "开" or "关")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = mainFrame
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn

    btn.MouseButton1Click:Connect(function()
        defaultValue = not defaultValue
        btn.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(100, 0, 0)
        btn.Text = text .. ": " .. (defaultValue and "开" or "关")
        callback(defaultValue)
    end)
    yPos = yPos + 35
end

createToggle("总开关", Config.ESPEnabled, function(v) Config.ESPEnabled = v end)
createToggle("显示方框", Config.ShowBox, function(v) Config.ShowBox = v end)
createToggle("显示名字", Config.ShowName, function(v) Config.ShowName = v end)
createToggle("显示距离", Config.ShowDistance, function(v) Config.ShowDistance = v end)
createToggle("显示队伍", Config.ShowTeam, function(v) Config.ShowTeam = v end)
createToggle("显示通缉", Config.ShowWanted, function(v) Config.ShowWanted = v end)


-- ==================== 通用数据检测逻辑 ====================

-- 1. 队伍检测 (不硬编码，直接读取游戏内实际队伍名)
local function GetTeamName(p)
    if p.Team then
        return p.Team.Name -- 直接返回游戏原生的队伍名，不管是英文还是中文
    end
    return "无队伍"
end

-- 2. 通用通缉检测 (遍历玩家和角色内部，寻找任意包含 wanted/bounty/criminal/通缉 的标记)
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

-- ==================== BillboardGui 透视主体 ====================
local ESPCache = {}

local function CreateESP(p)
    local char = p.Character
    if not char then return end
    
    -- 优先找头，没头找躯干
    local attachPart = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    if not attachPart then return end

    local bb = Instance.new("BillboardGui")
    bb.Name = "ESP_UI"
    bb.Size = UDim2.new(0, 150, 0, 80) -- UI整体大小
    bb.StudsOffset = Vector3.new(0, 3, 0) -- 头顶偏移
    bb.AlwaysOnTop = true -- 实现透视的关键
    bb.MaxDistance = Config.MaxDistance
    bb.Parent = attachPart

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = bb

    -- 边框 (方框效果)
    local box = Instance.new("Frame")
    box.Name = "Box"
    box.Size = UDim2.new(0, 60, 0, 80)
    box.Position = UDim2.new(0.5, -30, 0, 0)
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 2
    box.BorderColor3 = Color3.fromRGB(255, 255, 255)
    box.Visible = Config.ShowBox
    box.Parent = container

    -- 通缉 (最上方)
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

    -- 队伍
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

    -- 名字
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

    -- 距离 (最下方)
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

-- 玩家离开时清理UI
Players.PlayerRemoving:Connect(RemoveESP)

-- ==================== 渲染主循环 ====================
RunService.RenderStepped:Connect(function()
    if not Config.ESPEnabled then
        for p, data in pairs(ESPCache) do
            if data.Billboard then data.Billboard.Enabled = false end
        end
        return
    end

    for _, p in ipairs(Players:GetPlayers()) do
        -- 跳过自己
        if p == LocalPlayer then
            if ESPCache[p] then RemoveESP(p) end
            continue
        end

        local char = p.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        -- 角色无效或死亡则清理
        if not char or not hrp or not hum or hum.Health <= 0 then
            if ESPCache[p] then RemoveESP(p) end
            continue
        end

        -- 距离检测
        local myChar = LocalPlayer.Character
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHrp then continue end
        local dist = (myHrp.Position - hrp.Position).Magnitude

        if dist > Config.MaxDistance then
            if ESPCache[p] then RemoveESP(p) end
            continue
        end

        -- 创建或更新
        if not ESPCache[p] then
            CreateESP(p)
            task.wait() -- 给引擎一帧时间生成UI
        end

        local data = ESPCache[p]
        if not data or not data.Billboard or not data.Billboard.Parent then
            RemoveESP(p)
            CreateESP(p)
            data = ESPCache[p]
        end

        if data then
            data.Billboard.Enabled = true
            
            -- 队伍更新
            local tName = GetTeamName(p)
            data.Team.Text = "[" .. tName .. "]"
            data.Team.Visible = Config.ShowTeam
            
            -- 名字
            data.Name.Text = p.Name
            data.Name.Visible = Config.ShowName
            
            -- 距离
            data.Dist.Text = "[" .. math.floor(dist) .. "m]"
            data.Dist.Visible = Config.ShowDistance
            
            -- 方框颜色 (如果你有特定队伍比如警察，可以在这里写if判断变色)
            if tName:lower():find("police") or tName:find("警察") then
                data.Box.BorderColor3 = Color3.fromRGB(0, 100, 255) -- 警察方框蓝色
            else
                data.Box.BorderColor3 = Color3.fromRGB(255, 255, 255) -- 其他人白色
            end
            data.Box.Visible = Config.ShowBox

            -- 通缉检测
            if Config.ShowWanted and CheckWanted(p) then
                data.Wanted.Visible = true
            else
                data.Wanted.Visible = false
            end
        end
    end
end)