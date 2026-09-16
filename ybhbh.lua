-- =======================================================
-- 全平台通用版 方框透视脚本 (支持电脑/手机，纯 Drawing 画框)
-- 保留现代拨动开关 UI，自动检测队伍与通缉
-- =======================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 检查是否支持 Drawing 库
local hasDrawing = pcall(function()
    return Drawing and Drawing.new("Square")
end)

if not hasDrawing then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "注意",
        Text = "你的执行器不支持 Drawing 库，将使用备用文字模式（无方框）",
        Duration = 5
    })
end

-- ==================== 配置 ====================
local Config = {
    ESPEnabled = true,
    ShowBox = true,
    ShowName = true,
    ShowDistance = true,
    ShowTeam = true,
    ShowWanted = true,
    MaxDistance = 800,
}

-- ==================== 现代拨动开关 UI ====================
local oldGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("ModernESP_UI_V2")
if oldGui then oldGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ModernESP_UI_V2"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

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

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

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
titleText.Text = "Universal ESP V2"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 15
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

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

-- 开关创建
local yPos = 50
local function createSwitch(text, defaultValue, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 32)
    container.Position = UDim2.new(0, 10, 0, yPos)
    container.BackgroundTransparency = 1
    container.Parent = mainFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 40, 0, 20)
    track.Position = UDim2.new(1, -45, 0.5, -10)
    track.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(60, 60, 70)
    track.BorderSizePixel = 0
    track.Parent = container

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track

    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.new(0, 16, 0, 16)
    thumb.Position = defaultValue and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.BorderSizePixel = 0
    thumb.Parent = track

    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = thumb

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = container

    btn.MouseButton1Click:Connect(function()
        defaultValue = not defaultValue
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

createSwitch("总开关", Config.ESPEnabled, function(v) 
    Config.ESPEnabled = v 
    statusDot.BackgroundColor3 = v and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
end)
createSwitch("显示方框", Config.ShowBox, function(v) Config.ShowBox = v end)
createSwitch("显示名字", Config.ShowName, function(v) Config.ShowName = v end)
createSwitch("显示距离", Config.ShowDistance, function(v) Config.ShowDistance = v end)
createSwitch("显示队伍", Config.ShowTeam, function(v) Config.ShowTeam = v end)
createSwitch("显示通缉", Config.ShowWanted, function(v) Config.ShowWanted = v end)

-- ==================== 通用数据检测 ====================
local function GetTeamName(p)
    if p.Team then return p.Team.Name end
    return "平民" 
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

-- ==================== 绘图对象管理 ====================
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
    if not Config.ESPEnabled then
        if hasDrawing then
            for p, data in pairs(ESPCache) do
                for _, obj in pairs(data.Drawing) do obj.Visible = false end
            end
        else
            -- 备用文字模式的隐藏逻辑
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

        if not char or not hrp or not head or not hum or hum.Health <= 0 then
            if hasDrawing then RemoveDrawing(p) end
            continue
        end

        local myChar = LocalPlayer.Character
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHrp then continue end
        local dist = (myHrp.Position - hrp.Position).Magnitude

        if dist > Config.MaxDistance then
            if hasDrawing then RemoveDrawing(p) end
            continue
        end

        -- 2D坐标计算
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
            
            -- 如果是警察，方框变蓝；如果是通缉，方框变红
            if isWanted then
                d.Box.Color = Color3.fromRGB(255, 0, 0)
            elseif tName:lower():find("police") or tName:find("警察") then
                d.Box.Color = Color3.fromRGB(0, 100, 255)
            else
                d.Box.Color = Color3.fromRGB(255, 255, 255)
            end

            -- 绘制文字
            d.Name.Visible = Config.ShowName
            d.Name.Text = p.Name
            d.Name.Position = Vector2.new(headPos.X, posY - 20)

            d.Team.Visible = Config.ShowTeam
            d.Team.Text = "[" .. tName .. "]"
            d.Team.Position = Vector2.new(headPos.X, posY - 38)

            d.Wanted.Visible = Config.ShowWanted and isWanted
            d.Wanted.Text = "★通缉★"
            d.Wanted.Position = Vector2.new(headPos.X, posY - 56)

            d.Distance.Visible = Config.ShowDistance
            d.Distance.Text = "[" .. math.floor(dist) .. "m]"
            d.Distance.Position = Vector2.new(headPos.X, posY + height + 5)

        else
            -- 降级备用方案：只显示头顶文字（无方框）
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

statusDot.BackgroundColor3 = Config.ESPEnabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)