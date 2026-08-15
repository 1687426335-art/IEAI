local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/kitten-maomao/cdnUI/refs/heads/main/Mao%20ui%E4%BF%AE%E5%A4%8Dbug.lua"))()
local lc = game:GetService("Players").LocalPlayer
local group = 309474883
local grouplink = "猫脚本QQ群569036702"
local creds = "猫脚本"
if lc:IsInGroup(group) then
    print("猫脚本验证通过，欢迎使用！")
else
local FailWindow = WindUI:CreateWindow({
    Title = "<font color='#FFC0CB'><b>猫脚本 - 验证失败</b></font>",
    Author = "<font color='#FFC0CB'><b>请先加入群组</b></font>",
    Folder = "猫脚本",
    Size = UDim2.fromOffset(390, 460),
    Transparent = false,
    Theme = "Dark",
    SideBarWidth = 150,
    ScrollBarEnabled = true,
    Background = "rbxassetid://115018839123076",
    BackgroundlmageTransparency = 0,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 165, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 192, 203))
        }),
        User = { Enabled = false },
    })
    local FailTab = FailWindow:Tab({ Title = "<font color='#FFC0CB'>验证失败</font>", Icon = "alert-triangle" })
    FailTab:Paragraph({ Title = "<font color='#FFC0CB'><b>问: 为什么我在这里？</b></font>", Desc = "<font color='#FFC0CB'>答: 因为你没加入猫脚本群组</font>" })
    FailTab:Paragraph({ Title = "<font color='#FFC0CB'><b>问: 什么是猫脚本群组？</b></font>", Desc = "<font color='#FFC0CB'>答: 是Roblox里的一个名为猫脚本的群组</font>" })
    FailTab:Paragraph({ Title = "<font color='#FFC0CB'><b>问: 手机怎么加入群组</b></font>", Desc = "<font color='#FFC0CB'>答: Roblox主界面→更多→社区→更多群组→搜索猫脚本→加入</font>" })
    FailTab:Paragraph({ Title = "<font color='#FFC0CB'><b>问: 电脑怎么加入群组</b></font>", Desc = "<font color='#FFC0CB'>答: Roblox主界面→更多→社区→更多群组→搜索猫脚本→加入</font>" })
    FailTab:Paragraph({ Title = "<font color='#FFC0CB'><b>问: 我电脑是网页版的怎么办</b></font>", Desc = "<font color='#FFC0CB'>答: 在你Roblox大厅有个叫(群组)的 点进去然后点击(更多群组)然后搜索(猫脚本)加入就行了</font>" })
    setclipboard(grouplink)
    wait(999999999)
end
local currentPlaceId = game.PlaceId
local gameName = "未知"
local scriptUrl = nil
if currentPlaceId == 3623096087 then
    gameName = "力量传奇 Muscle Legends"
    scriptUrl = "https://raw.githubusercontent.com/kitten-maomao/jiaobeng/refs/heads/main/%E5%8A%9B%E9%87%8F%E4%BC%A0%E5%A5%87.lua"
elseif currentPlaceId == 3956818381 then
    gameName = "忍者传奇"
    scriptUrl = "https://raw.githubusercontent.com/kitten-maomao/jiaobeng/refs/heads/main/%E5%BF%8D%E8%80%85%E4%BC%A0%E5%A5%87.lua"
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "该服务器还为制作\n若需要请联系作者\n作者QQ:3931554043",
        Text = "",
        Duration = 9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
    })
    return
end
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera
local function rgb(r, g, b)
    return Color3.fromRGB(r, g, b)
end
local viewportSize = Camera.ViewportSize
local scale = math.clamp(math.min(viewportSize.X, viewportSize.Y) / 390, 1.0, 1.6)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CatLoaderV2"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999
screenGui.Parent = PlayerGui
local panelWidth = math.max(math.min(viewportSize.X * 0.82, 540), 400)
local panelHeight = math.floor(102 * scale)
local posX = (viewportSize.X - panelWidth) / 2
local posY = (viewportSize.Y - panelHeight) / 2
local snowContainer = Instance.new("Frame")
snowContainer.Size = UDim2.new(1, 0, 1, 0)
snowContainer.Position = UDim2.new(0, 0, 0, 0)
snowContainer.BackgroundTransparency = 1
snowContainer.ZIndex = 1
snowContainer.Parent = screenGui
local snowflakes = {}
local snowflakeCount = 40
local snowChar = utf8.char(0x2744)
for i = 1, snowflakeCount do
    local flake = Instance.new("TextLabel")
    flake.BackgroundTransparency = 1
    flake.Text = snowChar
    flake.TextColor3 = Color3.fromRGB(230, 240, 255)
    flake.TextTransparency = math.random(5, 35) / 100
    flake.TextSize = math.random(10, 18) * scale
    flake.Font = Enum.Font.GothamBold
    flake.TextXAlignment = Enum.TextXAlignment.Center
    flake.AnchorPoint = Vector2.new(0.5, 0.5)
    flake.ZIndex = 1
    flake.Parent = snowContainer
    flake.Position = UDim2.new(math.random(), 0, math.random(), 0)
    table.insert(snowflakes, {
        label = flake,
        speed = math.random(20, 60) * scale,
        drift = math.random(-15, 15) * scale,
        wobbleAmp = math.random(0.2, 0.8),
        wobbleSpeed = math.random(1, 3),
        startTime = tick(),
    })
end
local snowConnection
snowConnection = RunService.Heartbeat:Connect(function(deltaTime)
    local now = tick()
    local vpSize = Camera.ViewportSize
    for _, flakeData in ipairs(snowflakes) do
        local flake = flakeData.label
        local pos = flake.Position
        local newY = pos.Y.Scale + (flakeData.speed * deltaTime) / vpSize.Y
        if newY > 1.1 then
            newY = -0.05
            flake.Position = UDim2.new(math.random(), 0, newY, 0)
        else
            local elapsed = now - flakeData.startTime
            local wobble = math.sin(elapsed * flakeData.wobbleSpeed) * flakeData.wobbleAmp
            local newX = pos.X.Scale + (flakeData.drift * deltaTime + wobble * deltaTime * 0.5) / vpSize.X
            if newX > 1.05 then newX = -0.05
            elseif newX < -0.05 then newX = 1.05 end
            flake.Position = UDim2.new(newX, 0, newY, 0)
        end
    end
end)
screenGui.Destroying:Connect(function()
    if snowConnection then
        snowConnection:Disconnect()
        snowConnection = nil
    end
end)
local mainPanel = Instance.new("Frame")
mainPanel.Name = "SplashPanel"
mainPanel.Size = UDim2.new(0, 0, 0, panelHeight)
mainPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
mainPanel.AnchorPoint = Vector2.new(0.5, 0.5)
mainPanel.BackgroundColor3 = rgb(10, 8, 14)
mainPanel.BackgroundTransparency = 0
mainPanel.BorderSizePixel = 0
mainPanel.ZIndex = 10
mainPanel.ClipsDescendants = true
mainPanel.Parent = screenGui
Instance.new("UICorner", mainPanel).CornerRadius = UDim.new(0, 16)
local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.5
stroke.Color = rgb(210, 35, 35)
stroke.Transparency = 0.35
stroke.Parent = mainPanel
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, -32, 0, math.floor(3 * scale))
topBar.Position = UDim2.new(0, 16, 0, 0)
topBar.BackgroundColor3 = rgb(210, 35, 35)
topBar.BackgroundTransparency = 1
topBar.BorderSizePixel = 0
topBar.ZIndex = 13
topBar.Parent = mainPanel
Instance.new("UICorner", topBar).CornerRadius = UDim.new(1, 0)
local iconSize = math.floor(52 * scale)
local iconFrame = Instance.new("Frame")
iconFrame.Size = UDim2.new(0, iconSize, 0, iconSize)
iconFrame.Position = UDim2.new(0, math.floor(16 * scale), 0.5, -iconSize / 2)
iconFrame.BackgroundColor3 = rgb(8, 6, 12)
iconFrame.BackgroundTransparency = 0
iconFrame.BorderSizePixel = 0
iconFrame.ZIndex = 12
iconFrame.Parent = mainPanel
Instance.new("UICorner", iconFrame).CornerRadius = UDim.new(0, 11)
local iconStroke = Instance.new("UIStroke")
iconStroke.Thickness = 2
iconStroke.Color = rgb(210, 35, 35)
iconStroke.Transparency = 0.3
iconStroke.Parent = iconFrame
local icon = Instance.new("ImageLabel")
icon.Size = UDim2.new(1, -8, 1, -8)
icon.Position = UDim2.new(0, 4, 0, 4)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://124925027249193"
icon.ScaleType = Enum.ScaleType.Fit
icon.ZIndex = 13
icon.Parent = iconFrame
local titleX = math.floor(16 * scale) + iconSize + math.floor(14 * scale)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -(titleX + 18), 0, math.floor(18 * scale))
title.Position = UDim2.new(0, titleX, 0, math.floor(16 * scale))
title.BackgroundTransparency = 1
title.Text = "欢迎使用猫脚本"
title.TextColor3 = rgb(255, 255, 255)
title.TextSize = math.floor(13 * scale)
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextTransparency = 1
title.ZIndex = 12
title.Parent = mainPanel
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -(titleX + 18), 0, math.floor(13 * scale))
status.Position = UDim2.new(0, titleX, 0, math.floor(37 * scale))
status.BackgroundTransparency = 1
status.Text = "Initializing..."
status.TextColor3 = rgb(140, 132, 158)
status.TextSize = math.floor(9 * scale)
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextTransparency = 1
status.ZIndex = 12
status.Parent = mainPanel
local barX = math.floor(18 * scale)
local barY = math.floor(56 * scale)
local percentWidth = math.floor(28 * scale)
local progressBg = Instance.new("Frame")
progressBg.Size = UDim2.new(1, -(titleX + barX + percentWidth + math.floor(8 * scale)), 0, math.floor(5 * scale))
progressBg.Position = UDim2.new(0, titleX, 0, barY)
progressBg.BackgroundColor3 = rgb(28, 22, 38)
progressBg.BorderSizePixel = 0
progressBg.ZIndex = 12
progressBg.Parent = mainPanel
Instance.new("UICorner", progressBg).CornerRadius = UDim.new(1, 0)
local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = rgb(210, 35, 35)
progressFill.BorderSizePixel = 0
progressFill.ZIndex = 13
progressFill.Parent = progressBg
Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)
local fillStroke = Instance.new("UIStroke")
fillStroke.Thickness = 3
fillStroke.Color = rgb(210, 35, 35)
fillStroke.Transparency = 0.6
fillStroke.Parent = progressFill
local percentLabel = Instance.new("TextLabel")
percentLabel.Size = UDim2.new(0, percentWidth, 0, math.floor(13 * scale))
percentLabel.Position = UDim2.new(1, -(percentWidth + barX), 0, barY - math.floor(3 * scale))
percentLabel.BackgroundTransparency = 1
percentLabel.Text = "0%"
percentLabel.TextColor3 = rgb(50, 255, 50)
percentLabel.TextSize = math.floor(8 * scale)
percentLabel.Font = Enum.Font.GothamBold
percentLabel.TextXAlignment = Enum.TextXAlignment.Right
percentLabel.TextTransparency = 1
percentLabel.ZIndex = 12
percentLabel.Parent = mainPanel
local version = Instance.new("TextLabel")
version.Size = UDim2.new(1, 0, 0, math.floor(11 * scale))
version.Position = UDim2.new(0, 0, 0, math.floor(78 * scale))
version.BackgroundTransparency = 1
version.Text = "v2猫脚本加载器"
version.TextColor3 = rgb(90, 82, 108)
version.TextSize = math.floor(7 * scale)
version.Font = Enum.Font.Gotham
version.TextXAlignment = Enum.TextXAlignment.Center
version.TextTransparency = 1
version.ZIndex = 12
version.Parent = mainPanel
local tweenInfo = TweenInfo.new
local scriptSource = nil
if scriptUrl and scriptUrl ~= "" then
    task.spawn(function()
        local success, result = pcall(function()
            return game:HttpGet(scriptUrl)
        end)
        if success then
            scriptSource = result
        end
    end)
end
task.spawn(function()
    task.wait(0.02)
    TweenService:Create(mainPanel, tweenInfo(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        ["Size"] = UDim2.new(0, panelWidth, 0, panelHeight)
    }):Play()
    task.wait(0.2)
    TweenService:Create(title, tweenInfo(0.18), {["TextTransparency"] = 0}):Play()
    TweenService:Create(status, tweenInfo(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.04), {["TextTransparency"] = 0}):Play()
    TweenService:Create(percentLabel, tweenInfo(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.06), {["TextTransparency"] = 0}):Play()
    TweenService:Create(version, tweenInfo(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.08), {["TextTransparency"] = 0}):Play()
    local progress = 0.01
    local stepSize = 0.008
    local stepDelay = 0.025
    while progress < 1 do
        progress = math.min(progress + stepSize, 1)
        progressFill.Size = UDim2.new(progress, 0, 1, 0)
        percentLabel.Text = math.floor(progress * 100) .. "%"
        if progress < 0.3 then
            status.Text = "加载UI中"
            status.TextColor3 = rgb(140, 132, 158)
        elseif progress < 0.6 then
            status.Text = "UI加载成功"
            status.TextColor3 = rgb(140, 132, 158)
        elseif progress < 0.85 then
            status.Text = "脚本功能加载中"
            status.TextColor3 = rgb(251, 191, 36)
        else
            status.Text = "欢迎使用猫脚本"
            status.TextColor3 = rgb(50, 220, 100)
            percentLabel.TextColor3 = rgb(50, 220, 100)
        end
        task.wait(stepDelay)
    end
    progressFill.Size = UDim2.new(1, 0, 1, 0)
    percentLabel.Text = "100%"
    task.wait(0.3)
    local fadeOutTime = 0.15
    TweenService:Create(title, tweenInfo(fadeOutTime), {["TextTransparency"] = 1}):Play()
    TweenService:Create(status, tweenInfo(fadeOutTime), {["TextTransparency"] = 1}):Play()
    TweenService:Create(percentLabel, tweenInfo(fadeOutTime), {["TextTransparency"] = 1}):Play()
    TweenService:Create(version, tweenInfo(fadeOutTime), {["TextTransparency"] = 1}):Play()
    TweenService:Create(icon, tweenInfo(fadeOutTime), {["ImageTransparency"] = 1}):Play()
    TweenService:Create(iconStroke, tweenInfo(fadeOutTime), {["Transparency"] = 1}):Play()
    TweenService:Create(iconFrame, tweenInfo(fadeOutTime), {["BackgroundTransparency"] = 1}):Play()
    TweenService:Create(progressBg, tweenInfo(fadeOutTime), {["BackgroundTransparency"] = 1}):Play()
    TweenService:Create(progressFill, tweenInfo(fadeOutTime), {["BackgroundTransparency"] = 1}):Play()
    TweenService:Create(topBar, tweenInfo(fadeOutTime), {["BackgroundTransparency"] = 1}):Play()
    TweenService:Create(stroke, tweenInfo(fadeOutTime), {["Transparency"] = 1}):Play()
    TweenService:Create(mainPanel, tweenInfo(fadeOutTime + 0.05), {["BackgroundTransparency"] = 1}):Play()
    task.wait(fadeOutTime + 0.1)
    screenGui:Destroy()
    if scriptSource then
        pcall(function() loadstring(scriptSource)("猫脚本") end)
    elseif scriptUrl and scriptUrl ~= "" then
        pcall(function() loadstring(game:HttpGet(scriptUrl))("猫脚本") end)
    end
end)