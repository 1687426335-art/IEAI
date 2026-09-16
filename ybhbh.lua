-- =======================================================
-- 圣奥里 (San Aurie) 专用 独立悬浮窗 透视脚本
-- 全新暗金质感UI，默认全关，自带通缉检测
-- =======================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 检查 Drawing 库支持
local hasDrawing = pcall(function()
    return Drawing and Drawing.new("Square")
end)

-- ==================== 配置 (默认全部关闭) ====================
local Config = {
    ESPEnabled = false,      -- 总开关
    ShowBox = false,         -- 显示方框
    ShowName = false,        -- 显示名字
    ShowDistance = false,    -- 显示距离
    ShowTeam = false,        -- 显示队伍
    ShowWanted = false,      -- 显示通缉
    MaxDistance = 500,       -- 最大透视距离
}

-- ==================== 全新暗金质感 UI ====================
local oldGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("GoldESP_UI")
if oldGui then oldGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GoldESP_UI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- 主面板 (深色半透明)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 280)
mainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BackgroundTransparency = 0.1 -- 稍微透明一点，看起来高级
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 1.5
mainStroke.Color = Color3.fromRGB(255, 215, 0) -- 金色描边
mainStroke.Transparency = 0.3
mainStroke.Parent = mainFrame

-- 顶部标题栏 (带渐变)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

-- 渐变效果
local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 130, 0))
})
titleGradient.Rotation = 90
titleGradient.Parent = titleBar

-- 标题文字
local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -10, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "San Aurie 透视"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 14
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- 状态指示灯
local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 8, 0, 8)
statusDot.Position = UDim2.new(1, -18, 0.5, -4)
statusDot.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- 默认红色关闭状态
statusDot.BorderSizePixel = 0
statusDot.Parent = titleBar
local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = statusDot

-- 拖拽逻辑 (手机电脑通用)
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

-- 好看的卡片式按钮生成器
local yPos = 50
local function createStyledButton(text, defaultValue, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 32)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = defaultValue and Color3.fromRGB(40, 70, 40) or Color3.fromRGB(45, 45, 50)
    btn.Text = text .. ": " .. (defaultValue and "开" or "关")
    btn.TextColor3 = defaultValue and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(180, 180, 180)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = mainFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Thickness = 1
    btnStroke.Color = defaultValue and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(80, 80, 80)
    btnStroke.Transparency = 0.5
    btnStroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        defaultValue = not defaultValue
        if defaultValue then
            btn.BackgroundColor3 = Color3.fromRGB(40, 70, 40)
            btn.TextColor3 = Color3.fromRGB(0, 255, 100)
            btnStroke.Color = Color3.fromRGB(0, 255, 100)
            btn.Text = text .. ": 开"
            TweenService:Create(btn, TweenInfo.new(0.15), {Size = UDim2.new(0.95, 0, 0, 32)}):Play()
            task.wait(0.15)
            TweenService:Create(btn, TweenInfo.new(0.15), {Size = UDim2.new(0.9, 0, 0, 32)}):Play()
        else
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            btn.TextColor3 = Color3.fromRGB(180, 180, 180)
            btnStroke.Color = Color3.fromRGB(80, 80, 80)
            btn.Text = text .. ": 关"
        end
        callback(defaultValue)
    end)
    yPos = yPos + 38
end

createStyledButton("总开关", Config.ESPEnabled, function(v) 
    Config.ESPEnabled = v 
    statusDot.BackgroundColor3 = v and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
end)
createStyledButton("显示方框", Config.ShowBox, function(v) Config.ShowBox = v end)
createStyledButton("显示名字", Config.ShowName, function(v) Config.ShowName = v end)
createStyledButton("显示距离", Config.ShowDistance, function(v) Config.ShowDistance = v end)
createStyledButton("显示队伍", Config.ShowTeam, function(v) Config.ShowTeam = v end)
createStyledButton("显示通缉", Config.ShowWanted, function(v) Config.ShowWanted = v end)


-- ==================== 通用数据检测 ====================
-- 1. 队伍检测
local function GetTeamName(p)
    if p.Team then 
        return p.Team.Name 
    end
    return "平民"
end

-- 2. 通缉检测 (你要求的自己写，自动扫描所有常见通缉标记)
local function CheckWanted(p)
    -- 扫描 Player
    local function scanObject(obj)
        for _, child in ipairs(obj:GetChildren()) do
            local name = child.Name:lower()
            -- 检测名字包含 wanted, bounty, criminal, 通缉 的变量
            if name:find("wanted") or name:find("bounty") or name:find("criminal") or name:find("通缉") then
                if child:IsA("BoolValue") and child.Value == true then return true end
                if child:IsA("IntValue") and child.Value > 0 then return true end
                if child:IsA("StringValue") and child.Value ~= "" and child.Value ~= "0" then return true end
            end
        end
        return false
    end

    if scanObject(p) then return true end
    if p.Character and scanObject(p.Character) then return true end
    
    -- 有些游戏通缉放在 PlayerGui 里
    local pg = p:FindFirstChild("PlayerGui")
    if pg then
        if pg:FindFirstChild("WantedGui") or pg:FindFirstChild("Wanted") then return true end
    end

    return false
end

-- ==================== Drawing 绘图逻辑 ====================
local ESPCache = {}

local function CreateDrawing(p)
    if not hasDrawing then return nil end
    
    local objs = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        Team = Drawing.new("Text"),
        Wanted = Drawing.new("Text")
    }
    
    objs.Box.Thickness = 1.5
    objs.Box.Filled = false
    objs.Box.Transparency = 1
    objs.Box.Color = Color3.fromRGB(255, 255, 255)
    
    objs.Name.Size = 14
    objs.Name.Center = true
    objs.Name.Outline = true
    objs.Name.Color = Color3.fromRGB(255, 255, 255)
    
    objs.Distance.Size = 12
    objs.Distance.Center = true
    objs.Distance.Outline = true
    objs.Distance.Color = Color3.fromRGB(200, 200, 200)
    
    objs.Team.Size = 12
    objs.Team.Center = true
    objs.Team.Outline = true
    objs.Team.Color = Color3.fromRGB(0, 255, 255)
    
    objs.Wanted.Size = 14
    objs.Wanted.Center = true
    objs.Wanted.Outline = true
    objs.Wanted.Color = Color3.fromRGB(255, 0, 0)
    
    ESPCache[p] = { Drawing = objs }
    return ESPCache[p]
end

local function RemoveDrawing(p)
    if ESPCache[p] and ESPCache[p].Drawing then
        for _, obj in pairs(ESPCache[p].Drawing) do
            obj:Remove()
        end
        ESPCache[p] = nil
    end
end

Players.PlayerRemoving:Connect(RemoveDrawing)

-- ==================== 主渲染循环 ====================
RunService.RenderStepped:Connect(function()
    -- 如果总开关关闭，隐藏所有UI并返回
    if not Config.ESPEnabled then
        if hasDrawing then
            for p, data in pairs(ESPCache) do
                for _, obj in pairs(data.Drawing) do obj.Visible = false end
            end
        else
            for _, p in ipairs(Players:GetPlayers()) do
                local char = p.Character
                if char and char:FindFirstChild("Head") then
                    local oldBb = char.Head:FindFirstChild("FallbackESP")
                    if oldBb then oldBb.Enabled = false end
                end
            end
        end
        return
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end

        local char = p.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        -- 角色无效或死亡
        if not char or not hrp or not head or not hum or hum.Health <= 0 then
            if hasDrawing then RemoveDrawing(p) end
            continue
        end

        local myChar = LocalPlayer.Character
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHrp then continue end
        local dist = (myHrp.Position - hrp.Position).Magnitude

        -- 超出最大距离
        if dist > Config.MaxDistance then
            if hasDrawing then RemoveDrawing(p) end
            continue
        end

        -- 获取2D屏幕坐标
        local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
        if not onScreen then
            if hasDrawing and ESPCache[p] then
                for _, obj in pairs(ESPCache[p].Drawing) do obj.Visible = false end
            end
            continue
        end

        local tName = GetTeamName(p)
        local isWanted = CheckWanted(p)

        if hasDrawing then
            if not ESPCache[p] then CreateDrawing(p) end
            local d = ESPCache[p].Drawing
            if not d then continue end

            -- 计算方框大小
            local top = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1, 0))
            local bottom = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 2.5, 0))
            local height = math.abs(top.Y - bottom.Y)
            local width = height * 0.6
            local posX = headPos.X - width / 2
            local posY = top.Y

            -- 绘制方框
            d.Box.Visible = Config.ShowBox
            d.Box.Size = Vector2.new(width, height)
            d.Box.Position = Vector2.new(posX, posY)
            
            -- 颜色反馈：通缉变红，警察变蓝，其他人白色
            if isWanted then
                d.Box.Color = Color3.fromRGB(255, 0, 0)
            elseif tName:lower():find("police") or tName:find("警察") then
                d.Box.Color = Color3.fromRGB(0, 100, 255)
            else
                d.Box.Color = Color3.fromRGB(255, 255, 255)
            end

            -- 绘制名字
            d.Name.Visible = Config.ShowName
            d.Name.Text = p.Name
            d.Name.Position = Vector2.new(headPos.X, posY - 20)

            -- 绘制队伍
            d.Team.Visible = Config.ShowTeam
            d.Team.Text = "[" .. tName .. "]"
            d.Team.Position = Vector2.new(headPos.X, posY - 38)

            -- 绘制通缉 (自定义)
            d.Wanted.Visible = Config.ShowWanted and isWanted
            d.Wanted.Text = "★通缉★"
            d.Wanted.Position = Vector2.new(headPos.X, posY - 56)

            -- 绘制距离
            d.Distance.Visible = Config.ShowDistance
            d.Distance.Text = "[" .. math.floor(dist) .. "m]"
            d.Distance.Position = Vector2.new(headPos.X, posY + height + 5)

        else
            -- 备用降级方案 (如果没有Drawing，只显示头顶文字)
            local bb = head:FindFirstChild("FallbackESP")
            if not bb then
                bb = Instance.new("BillboardGui")
                bb.Name = "FallbackESP"
                bb.Size = UDim2.new(0, 200, 0, 60)
                bb.StudsOffset = Vector3.new(0, 3, 0)
                bb.AlwaysOnTop = true
                bb.Parent = head
                local txt = Instance.new("TextLabel")
                txt.Size = UDim2.new(1, 0, 1, 0)
                txt.BackgroundTransparency = 1
                txt.TextColor3 = Color3.fromRGB(255, 255, 255)
                txt.Font = Enum.Font.GothamBold
                txt.TextSize = 14
                txt.Parent = bb
            end
            bb.Enabled = true
            local parts = {}
            if Config.ShowName then table.insert(parts, p.Name) end
            if Config.ShowTeam then table.insert(parts, "["..tName.."]") end
            if Config.ShowWanted and isWanted then table.insert(parts, "★通缉★") end
            if Config.ShowDistance then table.insert(parts, "["..math.floor(dist).."m]") end
            bb.TextLabel.Text = table.concat(parts, "\n")
        end
    end
end)