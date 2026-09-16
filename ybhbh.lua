-- =======================================================
-- 圣奥里 (San Aurie) 专用 独立悬浮窗 2D方框透视脚本
-- =======================================================

-- 检查执行器是否支持 Drawing 库
if not Drawing then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "错误",
        Text = "你的执行器不支持 Drawing 库，无法使用方框透视！",
    })
    return
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

-- ==================== 配置区域 ====================
local Config = {
    ESPEnabled = true,       -- 总开关
    ShowBox = true,          -- 显示方框
    ShowName = true,         -- 显示名字
    ShowDistance = true,     -- 显示距离
    ShowTeam = true,         -- 显示队伍
    ShowWanted = true,       -- 显示通缉
    MaxDistance = 500,       -- 最大透视距离（单位：米）
    TeamCheck = true         -- 只显示指定队伍（根据需要开启，默认开启）
}

-- 支持的队伍映射表 (根据圣奥里实际队伍名调整)
local ValidTeams = {
    ["Police"] = "警察",
    ["Cop"] = "警察",
    ["Fire"] = "火焰",
    ["Medical"] = "医疗",
    ["Doctor"] = "医疗",
    ["Road"] = "道路服务",
    ["RoadService"] = "道路服务",
    ["Delivery"] = "转运",
    ["Transporter"] = "转运",
    ["Farmer"] = "农民",
    ["Civilian"] = "平民",
    ["Citizen"] = "平民"
}

-- 颜色配置
local Colors = {
    Box = Color3.fromRGB(255, 255, 255),
    Name = Color3.fromRGB(255, 255, 255),
    Distance = Color3.fromRGB(200, 200, 200),
    Team = Color3.fromRGB(0, 255, 255),
    Wanted = Color3.fromRGB(255, 0, 0),
    Police = Color3.fromRGB(0, 100, 255)
}

-- ==================== 悬浮窗 UI 制作 ====================
local oldGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("SanAurieESP_Gui")
if oldGui then oldGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SanAurieESP_Gui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- 主面板
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 280)
mainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
mainFrame.Active = true
mainFrame.Draggable = true -- Roblox原生拖拽
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
title.Text = "San Aurie 透视设置"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- 创建切换按钮的函数
local yPos = 45
local function createToggle(text, defaultValue, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(100, 0, 0)
    btn.Text = text .. ": " .. (defaultValue and "开启" or "关闭")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = mainFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        defaultValue = not defaultValue
        btn.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(100, 0, 0)
        btn.Text = text .. ": " .. (defaultValue and "开启" or "关闭")
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

-- ==================== 绘图逻辑 ====================
local ESPCache = {}

-- 检查通缉状态的函数 (根据游戏实际结构可能需要微调)
local function isPlayerWanted(p)
    -- 1. 检查 Player 本身
    local wantedTag = p:FindFirstChild("Wanted") or p:FindFirstChild("WantedTag")
    if wantedTag and (wantedTag:IsA("BoolValue") and wantedTag.Value == true) then return true end
    
    -- 2. 检查角色
    if p.Character then
        local charTag = p.Character:FindFirstChild("Wanted") or p.Character:FindFirstChild("WantedTag")
        if charTag and (charTag:IsA("BoolValue") and charTag.Value == true) then return true end
        local humanoid = p.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid:GetAttribute("Wanted") then return true end
    end
    
    -- 3. 检查 PlayerGui (有些游戏用UI显示通缉)
    local pg = p:FindFirstChild("PlayerGui")
    if pg and pg:FindFirstChild("WantedGui") then return true end
    
    return false
end

-- 获取显示队伍名称
local function getTeamName(p)
    if not p.Team then return "平民" end
    local teamName = p.Team.Name
    for eng, chn in pairs(ValidTeams) do
        if string.find(teamName, eng) then
            return chn
        end
    end
    return teamName -- 如果不在名单内，返回原队伍名（或者可以选择返回 nil 来隐藏）
end

-- 初始化或获取绘图对象
local function getDrawingObjects(p)
    if ESPCache[p] then return ESPCache[p] end
    
    local objs = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        Team = Drawing.new("Text"),
        Wanted = Drawing.new("Text")
    }
    
    objs.Box.Thickness = 2
    objs.Box.Filled = false
    objs.Box.Transparency = 1
    objs.Box.Color = Colors.Box
    
    objs.Name.Size = 14
    objs.Name.Center = true
    objs.Name.Outline = true
    objs.Name.Color = Colors.Name
    objs.Name.Font = 2 -- 2 是 UI 字体，3 是系统字体，根据执行器不同略有差异
    
    objs.Distance.Size = 12
    objs.Distance.Center = true
    objs.Distance.Outline = true
    objs.Distance.Color = Colors.Distance
    
    objs.Team.Size = 12
    objs.Team.Center = true
    objs.Team.Outline = true
    objs.Team.Color = Colors.Team
    
    objs.Wanted.Size = 14
    objs.Wanted.Center = true
    objs.Wanted.Outline = true
    objs.Wanted.Color = Colors.Wanted
    
    ESPCache[p] = objs
    return objs
end

-- 清理绘图对象
local function removeDrawingObjects(p)
    if ESPCache[p] then
        for _, obj in pairs(ESPCache[p]) do
            obj:Remove()
        end
        ESPCache[p] = nil
    end
end

-- 玩家离开时清理
Players.PlayerRemoving:Connect(removeDrawingObjects)

-- ==================== 主循环 ====================
RunService.RenderStepped:Connect(function()
    if not Config.ESPEnabled then
        -- 如果关闭总开关，隐藏所有绘图
        for p, objs in pairs(ESPCache) do
            for _, obj in pairs(objs) do obj.Visible = false end
        end
        return
    end

    for _, p in ipairs(Players:GetPlayers()) do
        -- 跳过自己
        if p == LocalPlayer then
            if ESPCache[p] then
                for _, obj in pairs(ESPCache[p]) do obj.Visible = false end
            end
            continue
        end

        local char = p.Character
        if not char then
            if ESPCache[p] then
                for _, obj in pairs(ESPCache[p]) do obj.Visible = false end
            end
            continue
        end

        local head = char:FindFirstChild("Head")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")

        if not head or not hrp or not humanoid or humanoid.Health <= 0 then
            if ESPCache[p] then
                for _, obj in pairs(ESPCache[p]) do obj.Visible = false end
            end
            continue
        end

        -- 距离计算
        local myChar = LocalPlayer.Character
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHrp then continue end
        
        local distance = (myHrp.Position - hrp.Position).Magnitude
        if distance > Config.MaxDistance then
            if ESPCache[p] then
                for _, obj in pairs(ESPCache[p]) do obj.Visible = false end
            end
            continue
        end

        -- 队伍过滤
        local teamName = getTeamName(p)
        local showTeam = Config.ShowTeam and ValidTeams[string.lower(teamName)] ~= nil -- 只显示名单内的队伍
        
        -- 获取 2D 坐标
        local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
        if not onScreen then
            if ESPCache[p] then
                for _, obj in pairs(ESPCache[p]) do obj.Visible = false end
            end
            continue
        end

        -- 计算方框大小和位置
        local topLeft = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1, 0)) -- 头顶
        local bottomRight = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 2.5, 0)) -- 脚底
        
        local height = math.abs(topLeft.Y - bottomRight.Y)
        local width = height * 0.6 -- 根据高度自适应宽度
        
        local posX = headPos.X - width / 2
        local posY = topLeft.Y

        -- 获取或创建绘图对象
        local objs = getDrawingObjects(p)

        -- 1. 方框
        if Config.ShowBox then
            objs.Box.Visible = true
            objs.Box.Size = Vector2.new(width, height)
            objs.Box.Position = Vector2.new(posX, posY)
            -- 如果是警察，方框变蓝
            if teamName == "警察" then
                objs.Box.Color = Colors.Police
            else
                objs.Box.Color = Colors.Box
            end
        else
            objs.Box.Visible = false
        end

        -- 2. 名字
        if Config.ShowName then
            objs.Name.Visible = true
            objs.Name.Text = p.Name
            objs.Name.Position = Vector2.new(headPos.X, posY - 20)
        else
            objs.Name.Visible = false
        end

        -- 3. 队伍 (只显示指定队伍)
        if showTeam then
            objs.Team.Visible = true
            objs.Team.Text = "[" .. teamName .. "]"
            objs.Team.Position = Vector2.new(headPos.X, posY - 36)
        else
            objs.Team.Visible = false
        end

        -- 4. 通缉检测
        if Config.ShowWanted then
            if isPlayerWanted(p) then
                objs.Wanted.Visible = true
                objs.Wanted.Text = "★通缉★"
                objs.Wanted.Position = Vector2.new(headPos.X, posY - 52)
            else
                objs.Wanted.Visible = false
            end
        else
            objs.Wanted.Visible = false
        end

        -- 5. 距离
        if Config.ShowDistance then
            objs.Distance.Visible = true
            objs.Distance.Text = "[" .. math.floor(distance) .. "m]"
            objs.Distance.Position = Vector2.new(headPos.X, posY + height + 5)
        else
            objs.Distance.Visible = false
        end
    end
end)

-- 提示信息
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "加载成功",
    Text = "圣奥里透视脚本已加载，请查看左侧悬浮窗。",
    Duration = 5
})