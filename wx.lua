local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "WX<font color='#00FF00'>脚本</font>",
    Icon = "rbxassetid://81944629903864",
    IconTransparency = 5,
    IconThemed = true,
    Author = "欢迎您使用",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(400, 300),
    Transparent = true,
    Theme = "Dark",
    User = {
        Enabled = true,
        Callback = function() print("clicked") end,
        Anonymous = false
    },
    SideBarWidth = 200,
    ScrollBarEnabled = true,
    Background = "rbxassetid://"
})

Window:EditOpenButton({
    Title = "WX脚本",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 8),
    StrokeThickness = 1,
    Draggable = true,
})
Window:Tag({
    Title = "正式版V1.5",
    Color = Color3.fromHex("#30ff6a")
})
Window:Tag({
    Title = "永久免费",
    Color = Color3.fromHex("#315dff")
})
Window:ToggleTransparency(true)

local TimeTag = Window:Tag({
    Title = "00:00",
    Color = Color3.fromHex("#000000")
})

local hue = 0
task.spawn(function()
    while true do
        local now = os.date("*t")
        local hours = string.format("%02d", now.hour)
        local minutes = string.format("%02d", now.min)
        
        hue = (hue + 0.01) % 1
        local rainbowColor = Color3.fromHSV(hue, 1, 1)
        
        TimeTag:SetTitle(hours .. ":" .. minutes)
        TimeTag:SetColor(rainbowColor)

        task.wait(0.06)
    end
end)

local TabHandles = {
    WX1 = Window:Tab({ Title = "公告", Icon = "layout-grid" }),
    WX2 = Window:Tab({ Title = "通用类", Icon = "layout-grid" }),
    WX3 = Window:Tab({ Title = "自瞄类", Icon = "crosshair" }),
    WX4 = Window:Tab({ Title = "甩飞类", Icon = "wind" }),
    WX5 = Window:Tab({ Title = "FE", Icon = "circle" }),
    WX6 = Window:Tab({ Title = "其他脚本", Icon = "server" }),
    WX7 = Window:Tab({ Title = "脚本中心", Icon = "code" }),
    WX8 = Window:Tab({ Title = "UI设色", Icon = "brush" }),
    WX9 = Window:Tab({ Title = "锻造", Icon = "zap" })
}

-- ==================== 情云同款自瞄系统 ====================
local CloudAimEnabled = false
local CloudAimFOV = 100
local CloudAimSmoothness = 10
local CloudAimPrediction = 5
local CloudAimFOVring = nil
local CloudAimRunService = game:GetService("RunService")
local CloudAimUserInputService = game:GetService("UserInputService")
local CloudAimPlayers = game:GetService("Players")
local CloudAimCam = workspace.CurrentCamera
local CloudAimConnection = nil

-- 创建FOV圈
local function CreateFOVCircle()
    if CloudAimFOVring then
        CloudAimFOVring:Remove()
    end
    
    CloudAimFOVring = Drawing.new("Circle")
    CloudAimFOVring.Visible = CloudAimEnabled
    CloudAimFOVring.Thickness = 2
    CloudAimFOVring.Color = Color3.fromRGB(0, 255, 0)
    CloudAimFOVring.Filled = false
    CloudAimFOVring.Radius = CloudAimFOV
    CloudAimFOVring.Position = CloudAimCam.ViewportSize / 2
end

-- 更新FOV圈
local function UpdateFOVCircle()
    if CloudAimFOVring then
        CloudAimFOVring.Position = CloudAimCam.ViewportSize / 2
        CloudAimFOVring.Radius = CloudAimFOV
    end
end

-- 获取FOV内最近玩家
local function GetClosestPlayerInFOV()
    local nearest = nil
    local lastDistance = math.huge
    local playerMousePos = CloudAimCam.ViewportSize / 2
    
    for _, player in ipairs(CloudAimPlayers:GetPlayers()) do
        if player ~= CloudAimPlayers.LocalPlayer then
            local character = player.Character
            if character then
                local head = character:FindFirstChild("Head")
                if head then
                    local screenPos, isVisible = CloudAimCam:WorldToViewportPoint(head.Position)
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - playerMousePos).Magnitude
                    
                    if distance < lastDistance and isVisible and distance < CloudAimFOV then
                        lastDistance = distance
                        nearest = player
                    end
                end
            end
        end
    end
    
    return nearest
end

-- 主自瞄循环
local function CloudAimLoop()
    UpdateFOVCircle()
    
    local closestPlayer = GetClosestPlayerInFOV()
    
    if closestPlayer and closestPlayer.Character then
        local targetCharacter = closestPlayer.Character
        local targetHead = targetCharacter:FindFirstChild("Head")
        local targetRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
        
        if targetHead then
            local isMoving = targetRootPart and targetRootPart.Velocity.Magnitude > 0.1
            local targetPosition
            
            if isMoving then
                targetPosition = targetHead.Position + (targetHead.CFrame.LookVector * CloudAimPrediction)
            else
                targetPosition = targetHead.Position
            end
            
            local targetCFrame = CFrame.new(CloudAimCam.CFrame.Position, targetPosition)
            CloudAimCam.CFrame = CloudAimCam.CFrame:Lerp(targetCFrame, 1 / CloudAimSmoothness)
        end
    end
end

-- 切换情云自瞄
local function ToggleCloudAim(enabled)
    CloudAimEnabled = enabled
    
    if enabled then
        CreateFOVCircle()
        CloudAimFOVring.Visible = true
        
        if CloudAimConnection then
            CloudAimConnection:Disconnect()
        end
        
        CloudAimConnection = CloudAimRunService.RenderStepped:Connect(CloudAimLoop)
        
        WindUI:Notify({
            Title = "情云自瞄",
            Content = "情云同款自瞄已开启\n按Delete键关闭",
            Icon = "crosshair",
            Duration = 3
        })
        
        -- 监听Delete键关闭
        local deleteConnection = CloudAimUserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.Delete then
                ToggleCloudAim(false)
                deleteConnection:Disconnect()
            end
        end)
    else
        if CloudAimFOVring then
            CloudAimFOVring.Visible = false
            CloudAimFOVring:Remove()
            CloudAimFOVring = nil
        end
        
        if CloudAimConnection then
            CloudAimConnection:Disconnect()
            CloudAimConnection = nil
        end
        
        WindUI:Notify({
            Title = "情云自瞄",
            Content = "情云同款自瞄已关闭",
            Icon = "x",
            Duration = 3
        })
    end
end

-- 在自瞄标签页添加情云自瞄部分
local CloudAimSection = TabHandles.WX3:Section({Title = "情云同款自瞄"})

-- 情云自瞄开关
TabHandles.WX3:Toggle({
    Title = "情云自瞄开关",
    Desc = "开启/关闭情云同款自瞄",
    Value = false,
    Callback = function(value)
        ToggleCloudAim(value)
    end
})

-- 自瞄范围滑块
TabHandles.WX3:Slider({
    Title = "自瞄范围 (FOV)",
    Desc = "调整自瞄识别范围大小",
    Value = {
        Min = 10,
        Max = 500,
        Default = CloudAimFOV
    },
    Step = 1,
    Callback = function(value)
        CloudAimFOV = value
        if CloudAimFOVring then
            CloudAimFOVring.Radius = CloudAimFOV
        end
    end
})

-- 平滑度滑块
TabHandles.WX3:Slider({
    Title = "自瞄平滑度",
    Desc = "值越大越平滑，值越小越灵敏",
    Value = {
        Min = 1,
        Max = 100,
        Default = CloudAimSmoothness
    },
    Step = 1,
    Callback = function(value)
        CloudAimSmoothness = value
    end
})

-- 预判距离滑块
TabHandles.WX3:Slider({
    Title = "自瞄预判距离",
    Desc = "调整自瞄预判距离",
    Value = {
        Min = 0,
        Max = 50,
        Default = CloudAimPrediction
    },
    Step = 1,
    Callback = function(value)
        CloudAimPrediction = value
    end
})

-- FOV圈颜色选择
local FOVColors = {
    ["绿色"] = Color3.fromRGB(0, 255, 0),
    ["红色"] = Color3.fromRGB(255, 0, 0),
    ["蓝色"] = Color3.fromRGB(0, 0, 255),
    ["黄色"] = Color3.fromRGB(255, 255, 0),
    ["紫色"] = Color3.fromRGB(128, 0, 128),
    ["白色"] = Color3.fromRGB(255, 255, 255)
}

TabHandles.WX3:Dropdown({
    Title = "FOV圈颜色",
    Desc = "选择自瞄范围圈的颜色",
    Values = {"绿色", "红色", "蓝色", "黄色", "紫色", "白色"},
    Value = "绿色",
    Callback = function(selected)
        if CloudAimFOVring then
            CloudAimFOVring.Color = FOVColors[selected]
        end
    end
})

-- FOV圈线宽滑块
TabHandles.WX3:Slider({
    Title = "FOV圈线宽",
    Desc = "调整自瞄范围圈线条粗细",
    Value = {
        Min = 1,
        Max = 10,
        Default = 2
    },
    Step = 1,
    Callback = function(value)
        if CloudAimFOVring then
            CloudAimFOVring.Thickness = value
        end
    end
})

-- 快速设置按钮
TabHandles.WX3:Button({
    Title = "快速设置：精准",
    Desc = "FOV:50 平滑:20 预判:3",
    Callback = function()
        CloudAimFOV = 50
        CloudAimSmoothness = 20
        CloudAimPrediction = 3
        
        if CloudAimFOVring then
            CloudAimFOVring.Radius = CloudAimFOV
        end
        
        WindUI:Notify({
            Title = "情云自瞄",
            Content = "已应用精准设置",
            Icon = "target",
            Duration = 2
        })
    end
})

TabHandles.WX3:Button({
    Title = "快速设置：广泛",
    Desc = "FOV:150 平滑:30 预判:8",
    Callback = function()
        CloudAimFOV = 150
        CloudAimSmoothness = 30
        CloudAimPrediction = 8
        
        if CloudAimFOVring then
            CloudAimFOVring.Radius = CloudAimFOV
        end
        
        WindUI:Notify({
            Title = "情云自瞄",
            Content = "已应用广泛设置",
            Icon = "maximize",
            Duration = 2
        })
    end
})

TabHandles.WX3:Divider()

-- 说明文本
TabHandles.WX3:Paragraph({
    Title = "使用说明",
    Desc = "开启后会在屏幕上显示绿色FOV圈\n圈内会自动瞄准最近的玩家\n按Delete键可快速关闭自瞄",
    Image = "info",
    ImageSize = 20
})

-- ==================== 原有自瞄系统保持不变 ====================
-- 注意：您原有的自瞄系统代码保持不变，我将其放在了情云自瞄的后面
-- 这样两个自瞄系统可以共存，用户可以选择使用哪一个

-- ==================== 自瞄系统变量初始化 ====================
local IsAimEnabled = false          -- 自瞄开关状态
local UsePrediction = false         -- 是否使用预测
local TargetLowestHealth = false    -- 是否瞄准最低血量
local AimRadius = 50                -- 自瞄半径
local LocalPlayer = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local PlayersService = game:GetService("Players")
local Camera = workspace.CurrentCamera
local AimPart = "Head"              -- 默认瞄准部位
local IgnoreTeam = false            -- 忽略队友
local CheckAlive = false            -- 检查存活状态
local PredictionScale = 1.2         -- 预测系数
local WallCheck = false             -- 墙体检查

-- 创建瞄准圈
local AimCircle = Drawing.new("Circle")
AimCircle.Visible = false
AimCircle.Thickness = 2
AimCircle.Color = Color3.fromRGB(0, 255, 0)  -- 绿色
AimCircle.Filled = false
AimCircle.Radius = AimRadius
AimCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

-- ==================== 自瞄系统核心函数 ====================
local function UpdateAimCirclePosition()
    AimCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

local function AimAt(position)
    local direction = (position - Camera.CFrame.Position).Unit
    Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + direction)
end

local function IsTeammate(player)
    return player.Team == LocalPlayer.Team
end

local function CanSeePlayer(player, maxDistance)
    if not WallCheck then
        return true
    end
    
    local localCharacter = LocalPlayer.Character
    if not localCharacter then
        return false
    end
    
    local targetCharacter = player.Character
    local targetPart = targetCharacter and targetCharacter:FindFirstChild(AimPart)
    if not targetPart then
        return false
    end
    
    local ray = Ray.new(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position).Unit * maxDistance)
    local hitPart, _ = workspace:FindPartOnRayWithIgnoreList(ray, {localCharacter})
    
    return not hitPart or not hitPart:IsDescendantOf(player.Character)
end

local function IsAlive(player)
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            return humanoid.Health > 0
        end
    end
    return false
end

local function FindBestTarget()
    local closestDistance = math.huge
    local lowestHealth = math.huge
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    local lowestHealthTarget = nil
    local closestTarget = nil
    
    for _, player in ipairs(PlayersService:GetPlayers()) do
        if player ~= LocalPlayer and not (IgnoreTeam and IsTeammate(player)) then
            local character = player.Character
            
            if character and character:FindFirstChild(AimPart) then
                if not CheckAlive or IsAlive(player) then
                    if not WallCheck or CanSeePlayer(player, 100) then
                        local screenPosition, onScreen = Camera:WorldToViewportPoint(character[AimPart].Position)
                        if onScreen then
                            local distance = (Vector2.new(screenPosition.X, screenPosition.Y) - screenCenter).Magnitude
                            
                            if distance < closestDistance then
                                if distance < AimRadius then
                                    closestTarget = player
                                end
                                closestDistance = distance
                            end
                            
                            if TargetLowestHealth then
                                local humanoid = character:FindFirstChildOfClass("Humanoid")
                                if humanoid and humanoid.Health > 0 and humanoid.Health < lowestHealth then
                                    lowestHealth = humanoid.Health
                                    lowestHealthTarget = player
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    return (TargetLowestHealth and lowestHealthTarget) or closestTarget
end

local function GetPredictedPosition(player, deltaTime)
    if not UsePrediction then
        if player.Character and player.Character:FindFirstChild(AimPart) then
            return player.Character[AimPart].Position
        end
        return nil
    end
    
    local character = player.Character
    if character and character:FindFirstChild(AimPart) then
        local aimPart = character[AimPart]
        local velocity = aimPart.Velocity
        return aimPart.Position + velocity * deltaTime * PredictionScale
    end
    return nil
end

-- ==================== 目标高亮系统 ====================
local CurrentTarget = nil
local HighlightedTargets = {}

local function HighlightTarget(player)
    if HighlightedTargets[player] then
        return
    end
    
    local character = player.Character
    if character then
        local highlight = Instance.new("Highlight")
        highlight.Adornee = character
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = character
        
        HighlightedTargets[player] = highlight
    end
end

local function RemoveHighlight(player)
    if HighlightedTargets[player] then
        HighlightedTargets[player]:Destroy()
        HighlightedTargets[player] = nil
    end
end

local function ClearAllHighlights()
    for player, highlight in pairs(HighlightedTargets) do
        highlight:Destroy()
        HighlightedTargets[player] = nil
    end
end

-- ==================== 自瞄主循环 ====================
local AimLoopConnection = nil

local function ToggleAim(enabled)
    if enabled then
        IsAimEnabled = true
        AimCircle.Visible = true
        AimCircle.Radius = AimRadius
        
        if AimLoopConnection then
            AimLoopConnection:Disconnect()
        end
        
        AimLoopConnection = RunService.RenderStepped:Connect(function(deltaTime)
            if IsAimEnabled then
                UpdateAimCirclePosition()
                
                local target = FindBestTarget()
                if target and target.Character and target.Character:FindFirstChild(AimPart) then
                    CurrentTarget = target
                    
                    local predictedPosition = GetPredictedPosition(target, deltaTime)
                    if predictedPosition then
                        AimAt(predictedPosition)
                    end
                    
                    HighlightTarget(target)
                else
                    CurrentTarget = nil
                    ClearAllHighlights()
                end
            end
        end)
        
        WindUI:Notify({
            Title = "WX自瞄",
            Content = "自瞄系统已开启",
            Icon = "check",
            Duration = 2
        })
    else
        IsAimEnabled = false
        CurrentTarget = nil
        
        if AimLoopConnection then
            AimLoopConnection:Disconnect()
            AimLoopConnection = nil
        end
        
        AimCircle.Visible = false
        ClearAllHighlights()
        
        WindUI:Notify({
            Title = "WX自瞄",
            Content = "自瞄系统已关闭",
            Icon = "x",
            Duration = 2
        })
    end
end

-- ==================== ESP透视系统 ====================
local Players = game:GetService("Players")
local ESPRunService = game:GetService("RunService")
local AllPlayers = Players:GetPlayers()
local LocalPlayerESP = Players.LocalPlayer

local ESPEnabled = false
local ESPColor = Color3.fromRGB(255, 255, 255)
local RainbowESP = false
local RainbowLoop = nil
local ShowHealthbars = false

local ESPHighlights = {}
local HealthbarGuis = {}

local function CreateESP(player, color)
    if ESPHighlights[player] then
        return
    end
    
    local character = player.Character or player.CharacterAdded:Wait()
    if character then
        local highlight = Instance.new("Highlight")
        highlight.Adornee = character
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillColor = color or ESPColor
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = character
        
        ESPHighlights[player] = highlight
    end
end

local function RemoveESP(player)
    if ESPHighlights[player] then
        ESPHighlights[player]:Destroy()
        ESPHighlights[player] = nil
    end
end

local function UpdateAllESP()
    if ESPEnabled then
        for _, player in ipairs(AllPlayers) do
            if player ~= LocalPlayerESP then
                CreateESP(player, ESPColor)
            end
        end
    else
        for player, _ in pairs(ESPHighlights) do
            RemoveESP(player)
        end
    end
end

local function ToggleESP(enabled)
    ESPEnabled = enabled
    UpdateAllESP()
    
    if enabled then
        WindUI:Notify({
            Title = "WX自瞄",
            Content = "ESP透视已开启",
            Icon = "eye",
            Duration = 2
        })
    else
        WindUI:Notify({
            Title = "WX自瞄",
            Content = "ESP透视已关闭",
            Icon = "eye-off",
            Duration = 2
        })
    end
end

local function SetESPColor(color)
    ESPColor = color
    if ESPEnabled then
        for _, highlight in pairs(ESPHighlights) do
            highlight.FillColor = ESPColor
        end
    end
end

local function ToggleRainbowESP(enabled)
    RainbowESP = enabled
    
    if RainbowESP then
        if RainbowLoop then
            RainbowLoop:Disconnect()
        end
        
        RainbowLoop = ESPRunService.RenderStepped:Connect(function()
            if ESPEnabled then
                local hue = tick() % 5 / 5
                local rainbowColor = Color3.fromHSV(hue, 1, 1)
                ESPColor = rainbowColor
                
                for _, highlight in pairs(ESPHighlights) do
                    highlight.FillColor = rainbowColor
                end
            end
        end)
    else
        if RainbowLoop then
            RainbowLoop:Disconnect()
            RainbowLoop = nil
        end
        ESPColor = Color3.fromRGB(255, 255, 255)
    end
end

-- 血条显示系统
local function CreateHealthbar(player)
    if HealthbarGuis[player] then
        return
    end
    
    local character = player.Character or player.CharacterAdded:Wait()
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local head = character:FindFirstChild("Head")
        
        if humanoid and head then
            local billboard = Instance.new("BillboardGui")
            billboard.Adornee = head
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = character
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundTransparency = 1
            frame.Parent = billboard
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
            nameLabel.Position = UDim2.new(0, 0, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextScaled = true
            nameLabel.TextStrokeTransparency = 0.5
            nameLabel.Parent = frame
            
            local healthbarBg = Instance.new("Frame")
            healthbarBg.Size = UDim2.new(1, 0, 0.3, 0)
            healthbarBg.Position = UDim2.new(0, 0, 0.6, 0)
            healthbarBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            healthbarBg.BorderSizePixel = 0
            healthbarBg.Parent = frame
            
            local healthbar = Instance.new("Frame")
            healthbar.Size = UDim2.new(1, 0, 1, 0)
            healthbar.Position = UDim2.new(0, 0, 0, 0)
            healthbar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            healthbar.BorderSizePixel = 0
            healthbar.Parent = healthbarBg
            
            local healthText = Instance.new("TextLabel")
            healthText.Size = UDim2.new(1, 0, 1, 0)
            healthText.Position = UDim2.new(0, 0, 0, 0)
            healthText.BackgroundTransparency = 1
            healthText.Text = tostring(math.floor(humanoid.Health)) .. "/" .. tostring(math.floor(humanoid.MaxHealth))
            healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
            healthText.TextScaled = true
            healthText.TextStrokeTransparency = 0.5
            healthText.Parent = healthbarBg
            
            local healthConnection = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                local healthRatio = humanoid.Health / humanoid.MaxHealth
                healthbar.Size = UDim2.new(healthRatio, 0, 1, 0)
                healthText.Text = tostring(math.floor(humanoid.Health)) .. "/" .. tostring(math.floor(humanoid.MaxHealth))
                
                if healthRatio > 0.6 then
                    healthbar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                elseif healthRatio > 0.3 then
                    healthbar.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                else
                    healthbar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                end
            end)
            
            HealthbarGuis[player] = {
                billboard = billboard,
                healthConnection = healthConnection
            }
        end
    end
end

local function RemoveHealthbar(player)
    if HealthbarGuis[player] then
        HealthbarGuis[player].billboard:Destroy()
        HealthbarGuis[player].healthConnection:Disconnect()
        HealthbarGuis[player] = nil
    end
end

local function UpdateAllHealthbars()
    if ShowHealthbars then
        for _, player in ipairs(AllPlayers) do
            if player ~= LocalPlayerESP then
                CreateHealthbar(player)
            end
        end
    else
        for player, _ in pairs(HealthbarGuis) do
            RemoveHealthbar(player)
        end
    end
end

local function ToggleHealthbars(enabled)
    ShowHealthbars = enabled
    UpdateAllHealthbars()
    
    if enabled then
        WindUI:Notify({
            Title = "WX自瞄",
            Content = "血条显示已开启",
            Icon = "heart",
            Duration = 2
        })
    else
        WindUI:Notify({
            Title = "WX自瞄",
            Content = "血条显示已关闭",
            Icon = "heart-off",
            Duration = 2
        })
    end
end

-- 玩家连接事件处理
Players.PlayerAdded:Connect(function(player)
    table.insert(AllPlayers, player)
    
    if ESPEnabled then
        CreateESP(player, ESPColor)
    end
    
    if ShowHealthbars then
        CreateHealthbar(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    for i, p in ipairs(AllPlayers) do
        if p == player then
            table.remove(AllPlayers, i)
            RemoveESP(player)
            RemoveHealthbar(player)
            break
        end
    end
end)

-- 初始化已存在的玩家
for _, player in ipairs(AllPlayers) do
    if player ~= LocalPlayerESP then
        player.CharacterAdded:Connect(function()
            if ESPEnabled then
                CreateESP(player, ESPColor)
            end
            if ShowHealthbars then
                CreateHealthbar(player)
            end
        end)
        
        if player.Character then
            if ESPEnabled then
                CreateESP(player, ESPColor)
            end
            if ShowHealthbars then
                CreateHealthbar(player)
            end
        end
    end
end

-- ==================== 移动修改系统 ====================
local SpeedEnabled = false
local SpeedMultiplier = 1
local SpeedConnection = nil

local function ToggleSpeed(enabled)
    if enabled then
        SpeedEnabled = true
        SpeedConnection = game:GetService("RunService").Heartbeat:Connect(function()
            local character = game:GetService("Players").LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Parent and humanoid.MoveDirection.Magnitude > 0 then
                    character:TranslateBy(humanoid.MoveDirection * SpeedMultiplier / 10)
                end
            end
        end)
        
        WindUI:Notify({
            Title = "WX自瞄",
            Content = "速度修改已开启",
            Icon = "zap",
            Duration = 2
        })
    elseif SpeedConnection then
        SpeedConnection:Disconnect()
        SpeedConnection = nil
        SpeedEnabled = false
        
        WindUI:Notify({
            Title = "WX自瞄",
            Content = "速度修改已关闭",
            Icon = "zap-off",
            Duration = 2
        })
    end
end

local function EnableInfiniteJump()
    game:GetService("UserInputService").JumpRequest:connect(function()
        game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end)
    
    WindUI:Notify({
        Title = "WX自瞄",
        Content = "无限跳跃已启用",
        Icon = "chevrons-up",
        Duration = 2
    })
end

-- ==================== 公告页面 ====================
TabHandles.WX1:Paragraph({
    Title = "WX作者:免费汉化，庅韷",
    Desc = "协助者:ADF(FLOKIV2) ,海底星新、斩过天花板, 沙记",
    Image = "users",
    ImageSize = 20
})

TabHandles.WX1:Paragraph({
    Title = "WX脚本特别欢迎您使用",
    Desc = "如果你玩此脚本被封了 或者服务器被封了我们概不负责",
    Image = "alert-triangle",
    ImageSize = 20
})

TabHandles.WX1:Paragraph({
    Title = "系统更新日志",
    Desc = "优化流畅度",
    Image = "package",
    ImageSize = 20
})

TabHandles.WX1:Paragraph({
    Title = "功能更新日志",
    Desc = "修改错字",
    Image = "target",
    ImageSize = 20
})

-- 你的群号
TabHandles.WX1:Paragraph({
    Title = "复制主群",
    Desc = "QQ主群:1071851583",
    Buttons = {{
        Title = "复制",
        Icon = "copy",
        Variant = "Primary",
        Callback = function()
            setclipboard("1071851583")
            local Sound = Instance.new("Sound", game:GetService("SoundService"))
            Sound.SoundId = "rbxassetid://138820873376530"
            Sound:Play()
            WindUI:Notify({
                Title = "WX：",
                Content = "已成功复制！",
                Icon = "bell",
                IconThemed = true,
                Duration = 5
            })
        end
    }}
})

local Paragraph1 = TabHandles.WX1:Paragraph({
    Title = "您的注入器: " .. identifyexecutor(),
    Desc = "欢迎使用WX脚本",
})

local Paragraph2 = TabHandles.WX1:Paragraph({
    Title = "您的用户名: " .. game.Players.LocalPlayer.Character.Name,
    Desc = "欢迎使用WX脚本",
})

local Paragraph3 = TabHandles.WX1:Paragraph({
    Title = "您的名称: " .. game.Players.LocalPlayer.DisplayName,
    Desc = "欢迎使用WX脚本",
})

local Paragraph4 = TabHandles.WX1:Paragraph({
    Title = "您当前服务器的ID: " .. game.GameId,
    Desc = "欢迎使用WX脚本",
})

local Paragraph5 = TabHandles.WX1:Paragraph({
    Title = "您的用户ID: " .. game.Players.LocalPlayer.UserId,
    Desc = "欢迎使用WX脚本",
})

local Paragraph6 = TabHandles.WX1:Paragraph({
    Title = "您的客户端ID: " .. game:GetService("RbxAnalyticsService"):GetClientId(),
    Desc = "欢迎使用WX脚本",
})

-- ==================== FE页面 ====================
TabHandles.WX5:Paragraph({
    Title = "FE功能",
    Desc = "FE (Filtering Enabled) 相关功能",
    Image = "circle",
    ImageSize = 20
})

TabHandles.WX5:Button({
    Title = "FE穿墙",
    Desc = "FE兼容的穿墙功能",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/7p9v2u7s/raw"))()
        WindUI:Notify({
            Title = "WX",
            Content = "FE穿墙加载成功",
            Duration = 3,
            Icon = "circle"
        })        
    end
})

TabHandles.WX5:Button({
    Title = "FE飞行",
    Desc = "FE兼容的飞行功能",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/GcjGkx1H/raw"))()
        WindUI:Notify({
            Title = "WX",
            Content = "FE飞行加载成功",
            Duration = 3,
            Icon = "circle"
        })        
    end
})

TabHandles.WX5:Button({
    Title = "FE速度",
    Desc = "FE兼容的速度功能",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/fjAcz84f/raw"))()
        WindUI:Notify({
            Title = "WX",
            Content = "FE速度加载成功",
            Duration = 3,
            Icon = "circle"
        })        
    end
})

-- ==================== 通用功能页面 ====================
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local JumpEnabled = false
local jumpConnection

local function getHumanoid()
    local char = game.Players.LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid") or nil
end

-- 移动速度滑块
TabHandles.WX2:Slider({
    Title = "移动速度",
    Desc = "调节角色移动速度（1-500）",
    Value = {
        Min = 1,
        Max = 500,
        Default = getHumanoid() and getHumanoid().WalkSpeed or 16
    },
    Step = 1,
    Callback = function(value)
        local humanoid = getHumanoid()
        if humanoid then
            humanoid.WalkSpeed = tonumber(value)
        end
    end
})

-- 跳跃高度滑块
TabHandles.WX2:Slider({
    Title = "跳跃高度",
    Desc = "调节角色跳跃力度（1-500）",
    Value = {
        Min = 1,
        Max = 500,
        Default = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.JumpPower or 50
    },
    Step = 1,
    Callback = function(value)
        local plr = game.Players.LocalPlayer
        local char = plr.Character or plr.CharacterAdded:Wait()
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = tonumber(value)
            humanoid.UseJumpPower = true
        end
    end
})

-- 重力设置滑块
TabHandles.WX2:Slider({
    Title = "重力设置",
    Desc = "调节世界重力大小（1-500）",
    Value = {
        Min = 1,
        Max = 500,
        Default = Workspace.Gravity
    },
    Step = 1,
    Callback = function(value)
        Workspace.Gravity = tonumber(value)
    end
})

-- 无限跳跃开关
TabHandles.WX2:Toggle({
    Title = "启用无限跳跃",
    Desc = "开启后可空中连续跳跃",
    Value = false,
    Callback = function(state)
        JumpEnabled = state
        if state then
            WindUI:Notify({
                Title = "功能已启用",
                Content = "无限跳跃已开启",
                Icon = "check-circle",
                Color = Color3.fromHex("#30ff6a"),
                Duration = 2
            })
        else
            WindUI:Notify({
                Title = "功能已关闭",
                Content = "无限跳跃已禁用",
                Icon = "x-circle",
                Color = Color3.fromHex("#ff3030"),
                Duration = 2
            })
        end
        if jumpConnection then jumpConnection:Disconnect() end
        if state then
            jumpConnection = UserInputService.JumpRequest:Connect(function()
                local success, humanoid = pcall(getHumanoid)
                if success and humanoid and humanoid.Health > 0 then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end
})

-- 夜视功能开关
TabHandles.WX2:Toggle({
    Title = "夜视功能", 
    Value = false, 
    Callback = function(Value)
        if Value then
            game.Lighting.Ambient = Color3.new(1, 1, 1)
        else
            game.Lighting.Ambient = Color3.new(0, 0, 0)
        end
        WindUI:Notify({
            Title = "WX",
            Content = Value and "已开启" or "已关闭",
            Duration = 3,
            Icon = "layout-grid",
        })
    end
})

-- 飞行功能
TabHandles.WX2:Button({
    Title = "飞行",
    Desc = "飞行功能",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/tvJQcwGt/raw"))()
        WindUI:Notify({
            Title = "WX",
            Content = "加载成功",
            Duration = 3,
            Icon = "layout-grid",
        })        
    end
})

-- 穿墙功能
TabHandles.WX2:Toggle({
    Title = "穿墙(可用)",
    Desc = "开启后可无视碰撞穿过物体",
    Value = false,
    Callback = function(NC)
        local Workspace = game:GetService("Workspace")
        local Players = game:GetService("Players")
        local Clipon = NC and true or false
        local Stepped = game:GetService("RunService").Stepped:Connect(function()
            if Clipon then
                for a, b in pairs(Workspace:GetChildren()) do
                    if b.Name == Players.LocalPlayer.Name then
                        for i, v in pairs(Workspace[Players.LocalPlayer.Name]:GetChildren()) do
                            if v:IsA("BasePart") then
                                v.CanCollide = false
                            end
                        end
                    end
                end
            else
                Stepped:Disconnect()
            end
        end)
    end
})

-- 踏空行走功能
TabHandles.WX2:Button({
    Title = "踏空行走",
    Desc = "在空中行走的功能",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/k5N6kXs8/raw"))()
        WindUI:Notify({
            Title = "WX",
            Content = "踏空行走加载成功",
            Duration = 3,
            Icon = "layout-grid"
        })        
    end
})

-- 继续其他通用功能按钮...
TabHandles.WX2:Button({
    Title = "无头加断腿美化",
    Desc = "",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Permanent-Headless-And-korblox-Script-4140"))()
        WindUI:Notify({
            Title = "正在加载WX美化",
            Content = "加载成功",
            Duration = 3,
            Icon = "layout-grid",
        })        
    end
})

TabHandles.WX2:Button({
    Title = "飞车",
    Desc = "飞车功能",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/0dZzBUiL/raw"))()
        WindUI:Notify({
            Title = "正在加载WX飞车",
            Content = "加载成功",
            Duration = 3,
            Icon = "layout-grid",
        })        
    end
})

TabHandles.WX2:Button({
    Title = "最高画质",
    Desc = "启用最高画质功能",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/jHBfJYmS"))()
        WindUI:Notify({
            Title = "WX",
            Content = "最高画质功能加载成功",
            Duration = 3,
            Icon = "layout-grid",
        })        
    end
})

TabHandles.WX2:Button({
    Title = "光影v4",
    Desc = "启用光影v4功能",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/MZEEN2424/Graphics/main/Graphics.xml"))()
        WindUI:Notify({
            Title = "WX",
            Content = "光影v4功能加载成功",
            Duration = 3,
            Icon = "layout-grid",
        })        
    end
})

TabHandles.WX2:Button({
    Title = "RTX高仿",
    Desc = "启用RTX高仿功能",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet('https://pastebin.com/raw/Bkf0BJb3'))()
        WindUI:Notify({
            Title = "WX",
            Content = "RTX高仿功能加载成功",
            Duration = 3,
            Icon = "layout-grid",
        })        
    end
})

TabHandles.WX2:Button({
    Title = "光影深",
    Desc = "启用光影深功能",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/MZEEN2424/Graphics/main/Graphics.xml"))()
        WindUI:Notify({
            Title = "WX",
            Content = "光影深功能加载成功",
            Duration = 3,
            Icon = "layout-grid",
        })        
    end
})

TabHandles.WX2:Button({
    Title = "光影浅",
    Desc = "启用光影浅功能",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/jHBfJYmS"))()
        WindUI:Notify({
            Title = "WX",
            Content = "光影浅功能加载成功",
            Duration = 3,
            Icon = "layout-grid",
        })        
    end
})

TabHandles.WX2:Button({
    Title = "旋转甩飞",
    Desc = "启用旋转甩飞功能",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dingding123hhh/tt/main/%E6%97%8B%E8%BD%AC.lua"))()
        WindUI:Notify({
            Title = "WX",
            Content = "旋转甩飞功能加载成功",
            Duration = 3,
            Icon = "layout-grid",
        })        
    end
})

TabHandles.WX2:Button({
    Title = "零件破坏者v2",
    Desc = "启用零件破坏者v2功能",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/cytj777i/-/main/零件破坏者v2"))()
        WindUI:Notify({
            Title = "WX",
            Content = "零件破坏者v2功能加载成功",
            Duration = 3,
            Icon = "layout-grid",
        })        
    end
})

TabHandles.WX2:Button({
    Title = "黑洞v5",
    Desc = "启用黑洞v5功能",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/DN0upqNm"))()
        WindUI:Notify({
            Title = "WX",
            Content = "黑洞v5功能加载成功",
            Duration = 3,
            Icon = "layout-grid",
        })        
    end
})

TabHandles.WX2:Button({
    Title = "黑洞v6",
    Desc = "启用黑洞v6功能",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/chesslovers69/Super-ring-parts-v6/refs/heads/main/Bylukaslol"))()
        WindUI:Notify({
            Title = "WX",
            Content = "黑洞v6功能加载成功",
            Duration = 3,
            Icon = "layout-grid",
        })        
    end
})

TabHandles.WX2:Button({
    Title = "黑洞v7",
    Desc = "启用黑洞v7功能",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/QYUALL7N"))()
        WindUI:Notify({
            Title = "WX",
            Content = "黑洞v7功能加载成功",
            Duration = 3,
            Icon = "layout-grid",
        })        
    end
})

TabHandles.WX2:Button({
    Title = "人物螺旋上天",
    Desc = "启用人物螺旋上天功能",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/xV1T3PAi/raw"))()
        WindUI:Notify({
            Title = "WX",
            Content = "人物螺旋上天能加载成功",
            Duration = 3,
            Icon = "layout-grid",
        })        
    end
})

TabHandles.WX2:Button({
    Title = "无敌少侠飞行",
    Desc = "仅支持R15体型，非R15体型无法使用",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Invinicible-Flight-R15-45414"))() 
        WindUI:Notify({
            Title = "WX",
            Content = "无敌少侠飞行加载成功",
            Duration = 3,
            Icon = "layout-grid",
        })        
    end
})

-- ==================== 其余脚本中心页面 ====================
TabHandles.WX7:Button({
    Title = "XK HUB",
    Desc = "史上最好用的免费脚本",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet(('https://github.com/devslopo/DVES/raw/main/XK%20Hub')))()
        WindUI:Notify({
            Title = "WX",
            Content = "XK HUB加载成功",
            Duration = 3,
            Icon = "layout-grid",
        })        
    end
})

TabHandles.WX7:Button({
    Title = "皮脚本",
    Desc = "免费脚本",
    Locked = false,
    Callback = function()
        getgenv().XiaoPi="皮脚本QQ群1002100032" loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/QQ1002100032-Roblox-Pi-script.lua"))()
        WindUI:Notify({
            Title = "WX",
            Content = "皮脚本加载成功",
            Duration = 3,
            Icon = "layout-grid",
        })        
    end
})

TabHandles.WX7:Button({
    Title = "沙脚本",
    Desc = "很好用的免费脚本，沙记制作",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/114514lzkill/ShaHUB/refs/heads/main/ShaHUB"))()
        WindUI:Notify({
            Title = "WX",
            Content = "沙脚本加载成功",
            Duration = 3,
            Icon = "layout-grid",
        })        
    end
})

TabHandles.WX7:Button({
    Title = "脚与本",
    Desc = "卡密jyb",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/FnYpMeAk"))()
        WindUI:Notify({
            Title = "WX",
            Content = "卡密jyb",
            Duration = 3,
            Icon = "layout-grid",
        })        
    end
})

TabHandles.WX7:Button({
    Title = "WU脚本破解版",
    Desc = "无需卡密，破解版",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/WUSCRIPT/WU-Script/d32b223a23ad84ef7c295656bff860e134eb8a90/77-obfuscated.lua"))()
        WindUI:Notify({
            Title = "WX",
            Content = "WU脚本加载成功",
            Duration = 3,
            Icon = "layout-grid",
        })        
    end
})

-- ==================== 其他服务器脚本页面 ====================

TabHandles.WX6:Button({
    Title = "死铁轨脚本",
    Desc = "未测试可否使用",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/e1cfd93b113a79773d93251b61af1e2f.lua"))()
        WindUI:Notify({
            Title = "WX",
            Content = "死铁轨脚本加载成功",
            Duration = 3,
            Icon = "layout-grid",
        })        
    end
})

TabHandles.WX6:Button({
    Title = "死亡铁轨刷债券",
    Desc = "全自动",
    Locked = false,
    Callback = function()
        getgenv().AutoExecute = true(loadstring or load)(game:HttpGet("https://raw.githubusercontent.com/hungquan99/HungHUB/main/loader.lua"))()
        WindUI:Notify({
            Title = "WX",
            Content = "死亡铁轨刷债卷加载成功",
            Duration = 3,
            Icon = "layout-grid",
        })        
    end
})

TabHandles.WX6:Button({
    Title = "最坚强的战场垃圾桶角色",
    Desc = "任意角色即可执行，死亡后需重新执行",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/Trashcan%20Man", true))()
        WindUI:Notify({
            Title = "WX",
            Content = "最坚强的战场垃圾桶加载成功",
            Duration = 3,
            Icon = "layout-grid",
        })        
    end
})

TabHandles.WX6:Button({
    Title = "最坚强的战场火车头",
    Desc = "需饿狼角色执行",
    Locked = false,
    Callback = function()
        getgenv().settings = {
            ["morph"] = {
                ["enabled"] = false,
                ["dontchangeskincolor"] = false,
            },
            ["ult_forcewalkspeed"] = true,
            ["ult_walkspeed"] = 64,
            ["tp_duration"] = 0.15
        } 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ATrainSounds/refs/heads/main/ATrain.lua"))()
        WindUI:Notify({
            Title = "WX",
            Content = "最坚强的战场火车头加载成功",
            Duration = 3,
            Icon = "layout-grid",
        })        
    end
})

TabHandles.WX6:Button({
    Title = "最坚强的战场动作脚本",
    Desc = "别人看不见，纯自己装帅用",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/HellishAgem/HellishMovesetCutscene/refs/heads/main/Protected_6748082827088148.txt"))()
        WindUI:Notify({
            Title = "WX",
            Content = "最坚强的战场动作加载成功",
            Duration = 3,
            Icon = "layout-grid",
        })        
    end
})

TabHandles.WX6:Button({
    Title = "俄亥俄州XA",
    Desc = "能不能用不确定",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XingFork/Scripts/refs/heads/main/Ohio"))()
        WindUI:Notify({
            Title = "WX",
            Content = "XA俄亥俄州加载成功",
            Duration = 3,
            Icon = "layout-grid",
        })        
    end
})

TabHandles.WX6:Button({
    Title = "偷走脑红",
    Desc = "加载慢",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/UrFSwAvs/raw"))()
    end
})

TabHandles.WX6:Button({
    Title = "偷走脑红钓鱼",
    Desc = "好用",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/somepath/somefile.lua"))()
    end
})

TabHandles.WX6:Button({
    Title = "偷走脑红",
    Desc = "汉化",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/ULdWe37N/raw"))()
    end
})

TabHandles.WX6:Button({
    Title = "植物VS大脑机器人",
    Desc = "已汉化",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/2EoYqTfl/raw"))()
    end
})

TabHandles.WX6:Button({
    Title = "99夜",
    Desc = "已汉化",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/2EoYqTfl/raw"))()
    end
})

TabHandles.WX6:Button({
    Title = "99夜",
    Desc = "虚空",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/99%E5%A4%9C%E8%99%9A%E7%A9%BA.txt"))()
    end
})

TabHandles.WX6:Button({
    Title = "99夜",
    Desc = "走马观花",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/Axg37JP7/raw"))()
    end
})

TabHandles.WX6:Button({
    Title = "99夜",
    Desc = "已汉化",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/Axg37JP7/raw"))()
    end
})

TabHandles.WX6:Button({
    Title = "自动翻译",
    Desc = "TK",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/JsYb666/Item/refs/heads/main/Auto-language"))()
    end
})

TabHandles.WX6:Button({
    Title = "伐木大亨",
    Desc = "作者思绪",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/oAqe0jak/raw"))()
    end
})

TabHandles.WX6:Button({
    Title = "种植花园",
    Desc = "没汉化",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/s9wO0IAp/raw"))()
    end
})

TabHandles.WX6:Button({
    Title = "种植花园",
    Desc = "好用",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/MoziIOnTop/MoziIHub/refs/heads/main/GrowaGarden"))()
    end
})

TabHandles.WX6:Button({
    Title = "极速传奇",
    Desc = "不会用问我",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/DhttNHdb/raw"))()
    end
})

TabHandles.WX6:Button({
    Title = "饲养宠物",
    Desc = "过几天汉化",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xwwwwwwwwwwwwwwwwwwwqd/loader/main/GamesData/RaiseAnimals.lua"))()
    end
})

TabHandles.WX6:Button({
    Title = "伐木大亨",
    Desc = "好用",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/oRaDTAPK/raw"))()
    end
})

TabHandles.WX6:Button({
    Title = "战争大亨",
    Desc = "还行",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E6%88%98%E4%BA%89%E5%A4%A7%E4%BA%A8.txt"))()
    end
})

TabHandles.WX6:Button({
    Title = "战争大亨",
    Desc = "XK中心",
    Callback = function()
        loadstring(game:HttpGet(('https://github.com/devslopo/DVES/raw/main/XK%20Hub')))()
    end
})
-- ==================== 锻造页面 ====================
TabHandles.WX9:Paragraph({
    Title = "锻造功能",
    Desc = "锻造加载卡，不要在意",
    Image = "zap",
    ImageSize = 20
})

TabHandles.WX9:Button({
    Title = "锻造1",
    Desc = "wx汉化",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/hpo8mrBS/raw"))()
        WindUI:Notify({
            Title = "WX",
            Content = "锻造加载成功",
            Duration = 3,
            Icon = "zap"
        })        
    end
})

TabHandles.WX9:Button({
    Title = "锻造2",
    Desc = "wx汉化",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/cqpwBBvX/raw"))()
        WindUI:Notify({
            Title = "WX",
            Content = "锻造加载成功",
            Duration = 3,
            Icon = "zap"
        })        
    end
})

TabHandles.WX9:Button({
    Title = "锻造3",
    Desc = "wx汉化",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/eEgLJA4f/raw"))()
        WindUI:Notify({
            Title = "WX",
            Content = "锻造加载成功",
            Duration = 3,
            Icon = "zap"
        })        
    end
})

-- ==================== UI设色页面 ====================
TabHandles.WX8:Button({
    Title = "自定义界面",
    Desc = "个性化您的体验",
    Image = "palette",
    ImageSize = 20
})

local themes = {}
for themeName, _ in pairs(WindUI:GetThemes()) do
    table.insert(themes, themeName)
end
table.sort(themes)
local themeDropdown = TabHandles.WX8:Dropdown({
    Title = "主题选择",
    Values = themes,
    Value = "Midnight",
    Callback = function(theme)
        WindUI:SetTheme(theme)
        WindUI:Notify({
            Title = "WX",
            Content = "已应用"..theme.."主题",
            Icon = "palette",
            Duration = 2
        })
    end
})

local transparencySlider = TabHandles.WX8:Slider({
    Title = "界面透明度",
    Value = { 
        Min = 0,
        Max = 1,
        Default = 0.2,
    },
    Step = 0.1,
    Callback = function(value)
        Window:ToggleTransparency(value > 0)
        WindUI.TransparencyValue = value
    end
})

TabHandles.WX8:Toggle({
    Title = "启用白色主题",
    Desc = "使用白色调主题方案",
    Value = true,
    Callback = function(state)
        WindUI:SetTheme(state and "Light" or "Dark")
        themeDropdown:Select(state and "Light" or "Dark")
        WindUI:Notify({
            Title = "WX",
            Content = state and "已启用白色主题" or "已启用黑色主题",
            Duration = 2,
            Icon = "palette"
        })
    end
})

TabHandles.WX8:Button({
    Title = "创建新主题",
    Icon = "plus",
    Callback = function()
        Window:Dialog({
            Title = "创建主题",
            Content = "此功能很快就会推出",
            Buttons = {
                {
                    Title = "确认",
                    Variant = "Primary"
                }
            }
        })
    end
})

TabHandles.WX8:Paragraph({
    Title = "配置管理",
    Desc = "保存你的设置",
    Image = "save",
    ImageSize = 20
})

-- ==================== 自瞄系统页面 ====================
-- 自瞄设置区域
local AimSection1 = TabHandles.WX3:Section({Title = "自瞄设置"})

AimSection1:Toggle({
    Title = "自瞄开关",
    Desc = "开启/关闭自瞄功能",
    Value = false,
    Callback = function(value)
        ToggleAim(value)
    end
})

AimSection1:Toggle({
    Title = "预测自瞄",
    Desc = "根据目标移动预测瞄准位置",
    Value = false,
    Callback = function(value)
        UsePrediction = value
    end
})

AimSection1:Toggle({
    Title = "优先最低血量",
    Desc = "优先瞄准血量最低的玩家",
    Value = false,
    Callback = function(value)
        TargetLowestHealth = value
    end
})

AimSection1:Slider({
    Title = "自瞄圈大小",
    Desc = "调整自瞄识别范围",
    Value = {
        Min = 1,
        Max = 600,
        Default = 50,
    },
    Step = 1,
    Callback = function(value)
        AimRadius = value
        if IsAimEnabled then
            AimCircle.Radius = AimRadius
        end
    end
})

AimSection1:Slider({
    Title = "自瞄圈线宽",
    Desc = "调整自瞄圈线条粗细",
    Value = {
        Min = 1,
        Max = 10,
        Default = 2,
    },
    Step = 1,
    Callback = function(value)
        AimCircle.Thickness = value
    end
})

-- 瞄准部位选择
local AimPartOptions = {
    ["头部"] = "Head",
    ["躯干"] = "UpperTorso",
    ["左手"] = "LeftHand",
    ["右手"] = "RightHand",
    ["左脚"] = "LeftFoot",
    ["右脚"] = "RightFoot"
}

AimSection1:Dropdown({
    Title = "瞄准部位",
    Desc = "选择自瞄瞄准的身体部位",
    Values = {"头部", "躯干", "左手", "右手", "左脚", "右脚"},
    Value = "头部",
    Callback = function(selected)
        AimPart = AimPartOptions[selected]
    end
})

-- 瞄准圈颜色选择
local AimCircleColors = {
    ["红色"] = Color3.fromRGB(255, 0, 0),
    ["黄色"] = Color3.fromRGB(255, 255, 0),
    ["绿色"] = Color3.fromRGB(0, 255, 0),
    ["蓝色"] = Color3.fromRGB(0, 0, 255),
    ["紫色"] = Color3.fromRGB(128, 0, 128),
    ["橙色"] = Color3.fromRGB(255, 165, 0),
    ["白色"] = Color3.fromRGB(255, 255, 255)
}

AimSection1:Dropdown({
    Title = "自瞄圈颜色",
    Desc = "选择自瞄圈显示颜色",
    Values = {"红色", "黄色", "绿色", "蓝色", "紫色", "橙色", "白色"},
    Value = "绿色",
    Callback = function(selected)
        AimCircle.Color = AimCircleColors[selected]
    end
})

AimSection1:Divider()

AimSection1:Toggle({
    Title = "忽略队友",
    Desc = "不瞄准同一队伍的玩家",
    Value = false,
    Callback = function(value)
        IgnoreTeam = value
    end
})

AimSection1:Toggle({
    Title = "存活检查",
    Desc = "只瞄准存活的玩家",
    Value = false,
    Callback = function(value)
        CheckAlive = value
    end
})

AimSection1:Slider({
    Title = "预测系数",
    Desc = "调整自瞄预测的强度",
    Value = {
        Min = 1,
        Max = 30,
        Default = 12,
    },
    Step = 1,
    Callback = function(value)
        PredictionScale = value / 10
    end
})

AimSection1:Toggle({
    Title = "墙体检查",
    Desc = "只瞄准可见的玩家",
    Value = false,
    Callback = function(value)
        WallCheck = value
    end
})

-- ESP透视系统区域
local AimSection2 = TabHandles.WX3:Section({Title = "透视设置"})

local ESPColors = {
    ["白色"] = Color3.fromRGB(255, 255, 255),
    ["青色"] = Color3.fromRGB(0, 255, 255),
    ["蓝色"] = Color3.fromRGB(0, 0, 255),
    ["紫色"] = Color3.fromRGB(128, 0, 128),
    ["黄色"] = Color3.fromRGB(255, 255, 0),
    ["绿色"] = Color3.fromRGB(0, 255, 0),
    ["红色"] = Color3.fromRGB(255, 0, 0)
}

AimSection2:Toggle({
    Title = "透视所有玩家",
    Desc = "显示所有玩家的轮廓",
    Value = false,
    Callback = function(value)
        ToggleESP(value)
    end
})

AimSection2:Dropdown({
    Title = "透视颜色",
    Desc = "选择透视显示颜色",
    Values = {"白色", "青色", "蓝色", "紫色", "黄色", "绿色", "红色"},
    Value = "白色",
    Callback = function(selected)
        if not RainbowESP then
            SetESPColor(ESPColors[selected])
        end
    end
})

AimSection2:Toggle({
    Title = "彩虹色透视",
    Desc = "启用七彩闪烁透视效果",
    Value = false,
    Callback = function(value)
        ToggleRainbowESP(value)
    end
})

AimSection2:Toggle({
    Title = "显示玩家血条",
    Desc = "显示玩家名字和血量信息",
    Value = false,
    Callback = function(value)
        ToggleHealthbars(value)
    end
})

-- 移动修改系统区域
local AimSection3 = TabHandles.WX3:Section({Title = "移动设置"})

AimSection3:Toggle({
    Title = "速度修改",
    Desc = "修改角色移动速度",
    Value = false,
    Callback = function(value)
        ToggleSpeed(value)
    end
})

AimSection3:Slider({
    Title = "速度倍数",
    Desc = "设置移动速度的倍率",
    Value = {
        Min = 1,
        Max = 1000,
        Default = 1,
    },
    Step = 1,
    Callback = function(value)
        SpeedMultiplier = value
    end
})

AimSection3:Button({
    Title = "启用无限跳跃",
    Desc = "启用无限跳跃功能",
    Callback = function()
        EnableInfiniteJump()
    end
})

-- 初始化ESP和血条
UpdateAllESP()
UpdateAllHealthbars()

-- ==================== 甩飞系统页面 ====================
local RunService = game:GetService("RunService")
local selectedPlayer = nil
local playerList = {}
local playerDropdown

TabHandles.WX4:Paragraph({
    Title = "甩飞页面",
    Desc = "🤓🤓甩飞他们",
    Image = "users",
    ImageSize = 20
})

local playerSelectionParagraph = TabHandles.WX4:Paragraph({
    Title = "玩家选择",
    Desc = "选择要操作的目标玩家"
})

local function refreshPlayers()
    table.clear(playerList)
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
    if playerDropdown then
        playerDropdown = TabHandles.WX4:Dropdown({
            Title = "选择玩家的名称",
            Values = playerList,
            Value = playerList[1] or "",
            Callback = function(selected)
                selectedPlayer = game.Players:FindFirstChild(selected)
                if selectedPlayer then
                    WindUI:Notify({
                        Title = "WX",
                        Content = "已选择玩家: " .. selectedPlayer.Name,
                        Duration = 3,
                        Icon = "user"
                    })
                end
            end
        })
    end
end

playerDropdown = TabHandles.WX4:Dropdown({
    Title = "选择玩家的名称",
    Values = playerList,
    Value = "",
    Callback = function(selected)
        selectedPlayer = game.Players:FindFirstChild(selected)
        if selectedPlayer then
            WindUI:Notify({
                Title = "WX",
                Content = "已选择玩家: " .. selectedPlayer.Name,
                Duration = 3,
                Icon = "user"
            })
        end
    end
})

TabHandles.WX4:Button({
    Title = "刷新玩家列表",
    Desc = "刷新当前所有在线玩家",
    Icon = "refresh-cw",
    Callback = function()
        refreshPlayers()
        WindUI:Notify({
            Title = "WX",
            Content = "玩家列表已刷新",
            Duration = 3,
            Icon = "check"
        })
    end
})

TabHandles.WX4:Button({
    Title = "查看选中玩家",
    Desc = "将视角切换到选中的玩家",
    Icon = "eye",
    Callback = function()
        if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("Humanoid") then
            game.Workspace.CurrentCamera.CameraSubject = selectedPlayer.Character.Humanoid
            WindUI:Notify({
                Title = "WX",
                Content = "正在查看: " .. selectedPlayer.Name,
                Duration = 3,
                Icon = "eye"
            })
        else
            WindUI:Notify({
                Title = "WX",
                Content = "请先选择一个有效玩家",
                Duration = 3,
                Icon = "alert-triangle"
            })
        end
    end
})

TabHandles.WX4:Button({
    Title = "停止查看",
    Desc = "将视角切回自己的角色",
    Icon = "eye-off",
    Callback = function()
        local localPlayer = game.Players.LocalPlayer
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
            game.Workspace.CurrentCamera.CameraSubject = localPlayer.Character.Humanoid
            WindUI:Notify({
                Title = "WX",
                Content = "已切回自己的视角",
                Duration = 3,
                Icon = "eye-off"
            })
        end
    end
})

TabHandles.WX4:Paragraph({
    Title = "传送功能",
    Desc = "传送相关功能",
    Image = "move",
    ImageSize = 20
})

TabHandles.WX4:Button({
    Title = "传送到玩家旁边",
    Desc = "传送到选中玩家的旁边",
    Icon = "navigation",
    Callback = function()
        if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = selectedPlayer.Character.HumanoidRootPart.Position
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(3, 0, 3))
            WindUI:Notify({
                Title = "WX",
                Content = "已传送到 " .. selectedPlayer.Name .. " 旁边",
                Duration = 3,
                Icon = "navigation"
            })
        else
            WindUI:Notify({
                Title = "WX",
                Content = "请先选择一个有效玩家",
                Duration = 3,
                Icon = "alert-triangle"
            })
        end
    end
})

local lockTPConnection = nil
local lockTPEnabled = false
TabHandles.WX4:Toggle({
    Title = "锁定传送",
    Desc = "持续传送到选中玩家的旁边",
    Value = false,
    Callback = function(state)
        lockTPEnabled = state
        if state then
            WindUI:Notify({
                Title = "WX",
                Content = "锁定传送已开启",
                Duration = 3,
                Icon = "check"
            })
            
            if lockTPConnection then
                lockTPConnection:Disconnect()
            end
            
            lockTPConnection = RunService.Heartbeat:Connect(function()
                if not lockTPEnabled or not selectedPlayer or not selectedPlayer.Character or not selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    if lockTPConnection then
                        lockTPConnection:Disconnect()
                        lockTPConnection = nil
                    end
                    return
                end
                local targetPos = selectedPlayer.Character.HumanoidRootPart.Position
                if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(3, 0, 3))
                end
            end)
        else
            if lockTPConnection then
                lockTPConnection:Disconnect()
                lockTPConnection = nil
            end
            WindUI:Notify({
                Title = "WX",
                Content = "锁定传送已关闭",
                Duration = 3,
                Icon = "x"
            })
        end
    end
})

TabHandles.WX4:Button({
    Title = "把玩家传送过来",
    Desc = "将选中玩家传送到自己旁边",
    Icon = "user-plus",
    Callback = function()
        if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local myChar = game.Players.LocalPlayer.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                local myPos = myChar.HumanoidRootPart.Position
                selectedPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(myPos + Vector3.new(3, 0, 3))
                WindUI:Notify({
                    Title = "WX",
                    Content = "已将 " .. selectedPlayer.Name .. " 传送到你旁边",
                    Duration = 3,
                    Icon = "user-plus"
                })
            end
        else
            WindUI:Notify({
                Title = "WX",
                Content = "请先选择一个有效玩家",
                Duration = 3,
                Icon = "alert-triangle"
            })
        end
    end
})

local loopTPConnection = nil
local loopTPEnabled = false
TabHandles.WX4:Toggle({
    Title = "循环把玩家传送过来",
    Desc = "持续将选中玩家传送到自己旁边",
    Value = false,
    Callback = function(state)
        loopTPEnabled = state
        if state then
            WindUI:Notify({
                Title = "WX",
                Content = "循环传送已开启",
                Duration = 3,
                Icon = "check"
            })
            
            if loopTPConnection then
                loopTPConnection:Disconnect()
            end
            
            loopTPConnection = RunService.Heartbeat:Connect(function()
                if not loopTPEnabled or not selectedPlayer or not selectedPlayer.Character or not selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    if loopTPConnection then
                        loopTPConnection:Disconnect()
                        loopTPConnection = nil
                    end
                    return
                end
                local myChar = game.Players.LocalPlayer.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    local myPos = myChar.HumanoidRootPart.Position
                    selectedPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(myPos + Vector3.new(3, 0, 3))
                end
            end)
        else
            if loopTPConnection then
                loopTPConnection:Disconnect()
                loopTPConnection = nil
            end
            WindUI:Notify({
                Title = "WX",
                Content = "循环传送已关闭",
                Duration = 3,
                Icon = "x"
            })
        end
    end
})

TabHandles.WX4:Paragraph({
    Title = "高级甩飞功能",
    Desc = "吸人、甩飞等高级功能",
    Image = "wind",
    ImageSize = 20
})

TabHandles.WX4:Button({
    Title = "甩飞选中玩家",
    Desc = "甩飞一次选中的玩家",
    Icon = "wind",
    Callback = function()
        local Player = game:GetService("Players").LocalPlayer
        local TargetPlayer = selectedPlayer
        if not TargetPlayer or TargetPlayer == Player then
            WindUI:Notify({
                Title = "WX",
                Content = "无玩家可甩飞",
                Duration = 3,
                Icon = "alert-triangle"
            })
            return
        end

        local Message = function(_Title, _Text, Time)
            WindUI:Notify({
                Title = _Title,
                Content = _Text,
                Duration = Time,
                Icon = "bell"
            })
        end

        local pid = game.PlaceId
        if pid == 189707 then
            local rs = game:GetService("RunService")
            local hb = rs.Heartbeat
            local rsd = rs.RenderStepped
            local lp = game.Players.LocalPlayer
            local z = Vector3.zero
            local function f(c)
                local r = c:WaitForChild("HumanoidRootPart")
                if r then
                    local con
                    con = hb:Connect(function()
                        if not r.Parent then
                            con:Disconnect()
                        end
                        local v = r.AssemblyLinearVelocity
                        r.AssemblyLinearVelocity = z
                        rsd:Wait()
                        r.AssemblyLinearVelocity = v
                    end)
                end
            end
            f(lp.Character)
            lp.CharacterAdded:Connect(f)
        end

        local SkidFling = function(Target)
            local Character = Player.Character
            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
            local RootPart = Humanoid and Humanoid.RootPart
            local TCharacter = Target.Character
            local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
            local TRootPart = THumanoid and THumanoid.RootPart
            local THead = TCharacter and TCharacter:FindFirstChild("Head")
            local Accessory = TCharacter and TCharacter:FindFirstChildOfClass("Accessory")
            local Handle = Accessory and Accessory:FindFirstChild("Handle")

            if not (Character and Humanoid and RootPart and TCharacter and THumanoid) then
                return Message("WX", "玩家已趋势", 2)
            end
            if THumanoid.Sit then return Message("WX", "目标处于坐姿", 2) end
            if not TCharacter:FindFirstChildWhichIsA("BasePart") then return Message("WX", "玩家已趋势", 2) end

            if THead then
                workspace.CurrentCamera.CameraSubject = THead
            elseif Handle then
                workspace.CurrentCamera.CameraSubject = Handle
            else
                workspace.CurrentCamera.CameraSubject = THumanoid
            end

            if RootPart.Velocity.Magnitude < 50 then
                getgenv().OldPos = RootPart.CFrame
            end

            local FPos = function(BasePart, Pos, Ang)
                RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
                Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
                RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
                RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
            end

            local SFBasePart = function(BasePart)
                local TimeToWait = 2
                local Time = tick()
                local Angle = 0
                repeat
                    if RootPart and THumanoid then
                        if BasePart.Velocity.Magnitude < 50 then
                            Angle = Angle + 100
                            FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 0.95, CFrame.Angles(math.rad(Angle),0 ,0))
                            task.wait()
                            FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 0.95, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 0.95, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 0.95, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()
                        else
                            FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()
                            
                            FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 0.95), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 0.95), CFrame.Angles(0, 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 0.95), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                            task.wait()
                        end
                    else
                        break
                    end
                until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= Target.Character or Target.Parent ~= game:GetService("Players") or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
            end

            workspace.FallenPartsDestroyHeight = 0/0
            local BV = Instance.new("BodyVelocity")
            BV.Name = "EpixVel"
            BV.Parent = RootPart
            BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
            BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

            if TRootPart and THead then
                SFBasePart((TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 and THead or TRootPart)
            elseif TRootPart then
                SFBasePart(TRootPart)
            elseif THead then
                SFBasePart(THead)
            elseif Handle then
                SFBasePart(Handle)
            else
                return Message("WX", "玩家已趋势", 2)
            end

            BV:Destroy()
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            workspace.CurrentCamera.CameraSubject = Humanoid
            getgenv().FPDH = getgenv().FPDH or workspace.FallenPartsDestroyHeight

            repeat
                RootPart.CFrame = getgenv().OldPos * CFrame.new(0, 0.5, 0)
                Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, 0.5, 0))
                Humanoid:ChangeState("GettingUp")
                table.foreach(Character:GetChildren(), function(_, x)
                    if x:IsA("BasePart") then x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new() end
                end)
                task.wait()
            until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
            workspace.FallenPartsDestroyHeight = getgenv().FPDH
            Message("WX", "已甩飞选中玩家", 2)
        end

        if TargetPlayer.UserId ~= 1414978355 then
            SkidFling(TargetPlayer)
        else
            Message("WX", "该玩家存在甩飞名单", 2)
        end
    end
})

local loopFlingEnabled = false
local loopFlingConnection = nil
TabHandles.WX4:Toggle({
    Title = "锁定甩飞选中玩家",
    Desc = "持续甩飞选中的玩家",
    Value = false,
    Callback = function(state)
        loopFlingEnabled = state
        if state then
            WindUI:Notify({
                Title = "WX",
                Content = "锁定甩飞已开启",
                Duration = 3,
                Icon = "check"
            })
            
            if loopFlingConnection then
                loopFlingConnection:Disconnect()
            end
            
            local function performFling()
                if not loopFlingEnabled or not selectedPlayer or selectedPlayer == game.Players.LocalPlayer then
                    return
                end
                
                local Player = game.Players.LocalPlayer
                local Target = selectedPlayer
                local Character = Player.Character
                local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
                local RootPart = Humanoid and Humanoid.RootPart
                local TCharacter = Target.Character
                local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
                local TRootPart = THumanoid and THumanoid.RootPart
                local THead = TCharacter and TCharacter:FindFirstChild("Head")
                local Accessory = TCharacter and TCharacter:FindFirstChildOfClass("Accessory")
                local Handle = Accessory and Accessory:FindFirstChild("Handle")
                
                if not (Character and Humanoid and RootPart and TCharacter and THumanoid) then
                    WindUI:Notify({
                        Title = "WX",
                        Content = "无玩家可甩飞",
                        Duration = 3,
                        Icon = "alert-triangle"
                    })
                    return
                end
                if THumanoid.Sit then
                    WindUI:Notify({
                        Title = "WX",
                        Content = "目标处于坐姿",
                        Duration = 3,
                        Icon = "alert-triangle"
                    })
                    return
                end
                if not TCharacter:FindFirstChildWhichIsA("BasePart") then
                    WindUI:Notify({
                        Title = "WX",
                        Content = "玩家已趋势",
                        Duration = 3,
                        Icon = "alert-triangle"
                    })
                    return
                end
                
                if THead then
                    workspace.CurrentCamera.CameraSubject = THead
                elseif Handle then
                    workspace.CurrentCamera.CameraSubject = Handle
                else
                    workspace.CurrentCamera.CameraSubject = THumanoid
                end
                
                if RootPart.Velocity.Magnitude < 50 then
                    getgenv().OldPos = RootPart.CFrame
                end
                
                local FPos = function(BasePart, Pos, Ang)
                    RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
                    Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
                    RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
                    RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
                end
                
                local SFBasePart = function(BasePart)
                    local TimeToWait = 2
                    local Time = tick()
                    local Angle = 0
                    repeat
                        if RootPart and THumanoid then
                            if BasePart.Velocity.Magnitude < 50 then
                                Angle = Angle + 100
                                FPos(BasePart, CFrame.new(0, 1.2, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 0.95, CFrame.Angles(math.rad(Angle),0 ,0))
                                task.wait()
                                FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 0.95, CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 0.95, CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 0.95, CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()
                            else
                                FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                                task.wait()
                                
                                FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 0.95), CFrame.Angles(math.rad(90), 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 0.95), CFrame.Angles(0, 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 0.95), CFrame.Angles(math.rad(90), 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                                task.wait()
                            end
                        else
                            break
                        end
                    until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= Target.Character or Target.Parent ~= game:GetService("Players") or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
                end
                
                workspace.FallenPartsDestroyHeight = 0/0
                local BV = Instance.new("BodyVelocity")
                BV.Name = "EpixVel"
                BV.Parent = RootPart
                BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
                BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
                Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                
                if TRootPart and THead then
                    SFBasePart((TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 and THead or TRootPart)
                elseif TRootPart then
                    SFBasePart(TRootPart)
                elseif THead then
                    SFBasePart(THead)
                elseif Handle then
                    SFBasePart(Handle)
                end
                
                BV:Destroy()
                Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                workspace.CurrentCamera.CameraSubject = Humanoid
                getgenv().FPDH = getgenv().FPDH or workspace.FallenPartsDestroyHeight
                
                repeat
                    RootPart.CFrame = getgenv().OldPos * CFrame.new(0, 0.5, 0)
                    Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, 0.5, 0))
                    Humanoid:ChangeState("GettingUp")
                    table.foreach(Character:GetChildren(), function(_, x)
                        if x:IsA("BasePart") then x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new() end
                    end)
                    task.wait()
                until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
                workspace.FallenPartsDestroyHeight = getgenv().FPDH
            end
            
            loopFlingConnection = RunService.Heartbeat:Connect(function()
                if loopFlingEnabled and selectedPlayer then
                    performFling()
                end
            end)
        else
            if loopFlingConnection then
                loopFlingConnection:Disconnect()
                loopFlingConnection = nil
            end
            WindUI:Notify({
                Title = "WX",
                Content = "锁定甩飞已关闭",
                Duration = 3,
                Icon = "x"
            })
        end
    end
})

TabHandles.WX4:Button({
    Title = "甩飞所有人",
    Desc = "甩飞所有在线玩家",
    Icon = "users",
    Callback = function()
        local Targets = {"All"}
        local Players = game:GetService("Players")
        local Player = Players.LocalPlayer
        local AllBool = false
        local GetPlayer = function(Name)
            Name = Name:lower()
            if Name == "all" or Name == "others" then
                AllBool = true
                return
            elseif Name == "random" then
                local GetPlayers = Players:GetPlayers()
                if table.find(GetPlayers,Player) then table.remove(GetPlayers,table.find(GetPlayers,Player)) end
                return GetPlayers[math.random(#GetPlayers)]
            elseif Name ~= "random" and Name ~= "all" and Name ~= "others" then
                for _,x in next, Players:GetPlayers() do
                    if x ~= Player then
                        if x.Name:lower():match("^"..Name) then
                            return x;
                        elseif x.DisplayName:lower():match("^"..Name) then
                            return x;
                        end
                    end
                end
            else
                return
            end
        end
        
        local Message = function(_Title, _Text, Time)
            WindUI:Notify({
                Title = _Title,
                Content = _Text,
                Duration = Time,
                Icon = "bell"
            })
        end
        
        local SkidFling = function(TargetPlayer)
            local Character = Player.Character
            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
            local RootPart = Humanoid and Humanoid.RootPart
            local TCharacter = TargetPlayer.Character
            local THumanoid
            local TRootPart
            local THead
            local Accessory
            local Handle
            if TCharacter:FindFirstChildOfClass("Humanoid") then
                THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
            end
            if THumanoid and THumanoid.RootPart then
                TRootPart = THumanoid.RootPart
            end
            if TCharacter:FindFirstChild("Head") then
                THead = TCharacter.Head
            end
            if TCharacter:FindFirstChildOfClass("Accessory") then
                Accessory = TCharacter:FindFirstChildOfClass("Accessory")
            end
            if Accessory and Accessory:FindFirstChild("Handle") then
                Handle = Accessory.Handle
            end
            if Character and Humanoid and RootPart then
                if RootPart.Velocity.Magnitude < 50 then
                    getgenv().OldPos = RootPart.CFrame
                end
                if THumanoid and THumanoid.Sit and not AllBool then
                    return Message("WX", "目标处于坐姿", 2)
                end
                if THead then
                    workspace.CurrentCamera.CameraSubject = THead
                elseif not THead and Handle then
                    workspace.CurrentCamera.CameraSubject = Handle
                elseif THumanoid and TRootPart then
                    workspace.CurrentCamera.CameraSubject = THumanoid
                end
                if not TCharacter:FindFirstChildWhichIsA("BasePart") then
                    return
                end
                
                local FPos = function(BasePart, Pos, Ang)
                    RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
                    Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
                    RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
                    RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
                end
                
                local SFBasePart = function(BasePart)
                    local TimeToWait = 2
                    local Time = tick()
                    local Angle = 0
                    repeat
                        if RootPart and THumanoid then
                            if BasePart.Velocity.Magnitude < 50 then
                                Angle = Angle + 100
                                FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 0.95, CFrame.Angles(math.rad(Angle),0 ,0))
                                task.wait()
                                FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 0.95, CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 0.95, CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 0.95, CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()
                            else
                                FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                                task.wait()
                                
                                FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 0.95), CFrame.Angles(math.rad(90), 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 0.95), CFrame.Angles(0, 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 0.95), CFrame.Angles(math.rad(90), 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
                                task.wait()
                                FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                                task.wait()
                            end
                        else
                            break
                        end
                    until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
                end
                
                workspace.FallenPartsDestroyHeight = 0/0
                
                local BV = Instance.new("BodyVelocity")
                BV.Name = "EpixVel"
                BV.Parent = RootPart
                BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
                BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
                
                Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                
                if TRootPart and THead then
                    if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                        SFBasePart(THead)
                    else
                        SFBasePart(TRootPart)
                    end
                elseif TRootPart and not THead then
                    SFBasePart(TRootPart)
                elseif not TRootPart and THead then
                    SFBasePart(THead)
                elseif not TRootPart and not THead and Accessory and Handle then
                    SFBasePart(Handle)
                else
                    return Message("WX", "玩家已趋势", 2)
                end
                
                BV:Destroy()
                Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                workspace.CurrentCamera.CameraSubject = Humanoid
                
                repeat
                    RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
                    Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
                    Humanoid:ChangeState("GettingUp")
                    table.foreach(Character:GetChildren(), function(_, x)
                        if x:IsA("BasePart") then
                            x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                        end
                    end)
                    task.wait()
                until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
                workspace.FallenPartsDestroyHeight = getgenv().FPDH
            else
                return Message("WX", "随机错误", 2)
            end
        end
        
        local hasPlayers = false
        for _,x in next, Players:GetPlayers() do
            if x ~= Player then
                hasPlayers = true
                break
            end
        end
        if not hasPlayers then
            return Message("WX", "无玩家可以甩飞", 2)
        end
        
        if Targets[1] then for _,x in next, Targets do GetPlayer(x) end else return end
        if AllBool then
            for _,x in next, Players:GetPlayers() do
                if x ~= Player then
                    SkidFling(x)
                end
            end
        end
        
        Message("WX", "正在甩飞所有玩家...", 3)
    end
})

TabHandles.WX4:Paragraph({
    Title = "精确位置传送",
    Desc = "传送到玩家的前后方、头顶等精确位置",
    Image = "target",
    ImageSize = 20
})

local frontDistance = 3
TabHandles.WX4:Slider({
    Title = "传送前方的距离",
    Desc = "设置传送到玩家前方的距离",
    Value = {
        Min = 1,
        Max = 50,
        Default = frontDistance
    },
    Step = 1,
    Callback = function(value)
        frontDistance = tonumber(value)
        WindUI:Notify({
            Title = "WX",
            Content = "前方距离设置为: " .. frontDistance,
            Duration = 3,
            Icon = "ruler"
        })
    end
})

local loopFrontTPConnection = nil
local loopFrontTPEnabled = false
TabHandles.WX4:Toggle({
    Title = "循环传送至玩家前方",
    Desc = "持续传送到选中玩家的前方",
    Value = false,
    Callback = function(state)
        loopFrontTPEnabled = state
        if state then
            WindUI:Notify({
                Title = "WX",
                Content = "前方传送已开启",
                Duration = 3,
                Icon = "check"
            })
            
            if loopFrontTPConnection then
                loopFrontTPConnection:Disconnect()
            end
            
            loopFrontTPConnection = RunService.Heartbeat:Connect(function()
                if not loopFrontTPEnabled or not selectedPlayer or not selectedPlayer.Character or not selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    if loopFrontTPConnection then
                        loopFrontTPConnection:Disconnect()
                        loopFrontTPConnection = nil
                    end
                    return
                end
                local targetCF = selectedPlayer.Character.HumanoidRootPart.CFrame
                local frontPos = targetCF.Position + targetCF.LookVector * frontDistance
                if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(frontPos)
                end
            end)
        else
            if loopFrontTPConnection then
                loopFrontTPConnection:Disconnect()
                loopFrontTPConnection = nil
            end
            WindUI:Notify({
                Title = "WX",
                Content = "前方传送已关闭",
                Duration = 3,
                Icon = "x"
            })
        end
    end
})

local headDistance = 4
TabHandles.WX4:Slider({
    Title = "传送头顶的距离",
    Desc = "设置传送到玩家头顶的距离",
    Value = {
        Min = 1,
        Max = 50,
        Default = headDistance
    },
    Step = 1,
    Callback = function(value)
        headDistance = tonumber(value)
        WindUI:Notify({
            Title = "WX",
            Content = "头顶距离设置为: " .. headDistance,
            Duration = 3,
            Icon = "ruler"
        })
    end
})

local loopHeadHeightConnection = nil
local loopHeadHeightEnabled = false
TabHandles.WX4:Toggle({
    Title = "循环传送至玩家头顶",
    Desc = "持续传送到选中玩家的头顶",
    Value = false,
    Callback = function(state)
        loopHeadHeightEnabled = state
        if state then
            WindUI:Notify({
                Title = "WX",
                Content = "头顶传送已开启",
                Duration = 3,
                Icon = "check"
            })
            
            if loopHeadHeightConnection then
                loopHeadHeightConnection:Disconnect()
            end
            
            loopHeadHeightConnection = RunService.Heartbeat:Connect(function()
                if not loopHeadHeightEnabled or not selectedPlayer or not selectedPlayer.Character or not selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    if loopHeadHeightConnection then
                        loopHeadHeightConnection:Disconnect()
                        loopHeadHeightConnection = nil
                    end
                    return
                end
                local targetPos = selectedPlayer.Character.HumanoidRootPart.Position
                if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos.X, targetPos.Y + headDistance, targetPos.Z)
                end
            end)
        else
            if loopHeadHeightConnection then
                loopHeadHeightConnection:Disconnect()
                loopHeadHeightConnection = nil
            end
            WindUI:Notify({
                Title = "WX",
                Content = "头顶传送已关闭",
                Duration = 3,
                Icon = "x"
            })
        end
    end
})

local backDistance = 2
TabHandles.WX4:Slider({
    Title = "传送后面的距离",
    Desc = "设置传送到玩家后面的距离",
    Value = {
        Min = 1,
        Max = 50,
        Default = backDistance
    },
    Step = 1,
    Callback = function(value)
        backDistance = tonumber(value)
        WindUI:Notify({
            Title = "WX",
            Content = "后面距离设置为: " .. backDistance,
            Duration = 3,
            Icon = "ruler"
        })
    end
})

local loopBackTPConnection = nil
local loopBackTPEnabled = false
TabHandles.WX4:Toggle({
    Title = "循环传送至玩家后面",
    Desc = "持续传送到选中玩家的后面",
    Value = false,
    Callback = function(state)
        loopBackTPEnabled = state
        if state then
            WindUI:Notify({
                Title = "WX",
                Content = "后面传送已开启",
                Duration = 3,
                Icon = "check"
            })
            
            if loopBackTPConnection then
                loopBackTPConnection:Disconnect()
            end
            
            loopBackTPConnection = RunService.Heartbeat:Connect(function()
                if not loopBackTPEnabled or not selectedPlayer or not selectedPlayer.Character or not selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    if loopBackTPConnection then
                        loopBackTPConnection:Disconnect()
                        loopBackTPConnection = nil
                    end
                    return
                end
                local targetCF = selectedPlayer.Character.HumanoidRootPart.CFrame
                local backPos = targetCF.Position - targetCF.LookVector * backDistance
                if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(backPos)
                end
            end)
        else
            if loopBackTPConnection then
                loopBackTPConnection:Disconnect()
                loopBackTPConnection = nil
            end
            WindUI:Notify({
                Title = "WX",
                Content = "后面传送已关闭",
                Duration = 3,
                Icon = "x"
            })
        end
    end
})

-- 初始化玩家列表
refreshPlayers()

-- 脚本加载完成通知
WindUI:Notify({
    Title = "WX脚本已加载",
    Content = "欢迎使用WX脚本！\n祝您游戏愉快！",
    Icon = "check-circle",
    Duration = 5
})

Window:Open()