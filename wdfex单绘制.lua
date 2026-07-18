-- ========== wdfex单绘制 全游戏通用 ==========
-- 血量 + 方框 + 名字 + 天线 + 墙后检测 + 手持武器 + 队伍检测
-- 队友不绘制，敌人正常绘制

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

local espEnabled = true
local displayObjects = {}
local minimized = false
local isDragging = false
local dragStart = nil
local dragStartPos = nil

-- ========== 创建GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = CoreGui
screenGui.Name = "wdfexESP"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ========== 检测队伍 ==========
local function isTeammate(player)
    if player == LocalPlayer then return true end
    local localTeam = LocalPlayer.Team
    local playerTeam = player.Team
    if localTeam and playerTeam then
        return localTeam == playerTeam
    end
    -- 有些游戏用属性判断
    local localTag = LocalPlayer:FindFirstChild("Team") or LocalPlayer:FindFirstChild("TeamColor")
    local playerTag = player:FindFirstChild("Team") or player:FindFirstChild("TeamColor")
    if localTag and playerTag then
        return localTag.Value == playerTag.Value
    end
    return false
end

-- ========== 获取武器 ==========
local function getWeapon(player)
    if not player or not player.Character then return "无" end
    local char = player.Character
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        return tool.Name
    end
    local child = char:FindFirstChild("Weapon") or char:FindFirstChild("Gun")
    if child then
        return child.Name
    end
    return "无"
end

-- ========== 世界转屏幕 ==========
local function worldToScreen(pos)
    local sp, onScreen = Camera:WorldToScreenPoint(pos)
    return Vector2.new(sp.X, sp.Y), onScreen
end

-- ========== 墙后检测 ==========
local function isVisible(pos)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    local ray = workspace:Raycast(Camera.CFrame.Position, (pos - Camera.CFrame.Position).Unit * 500, raycastParams)
    if ray then
        local dist = (ray.Position - pos).Magnitude
        if dist < 3 then
            return true
        else
            return false
        end
    end
    return true
end

-- ========== 创建标签 ==========
local function createLabels(player)
    local container = Instance.new("Frame")
    container.Parent = screenGui
    container.Size = UDim2.new(0, 200, 0, 80)
    container.BackgroundTransparency = 1
    container.Visible = true
    container.ZIndex = 10

    -- 方框
    local box = Instance.new("Frame")
    box.Parent = container
    box.Size = UDim2.new(0, 60, 0, 80)
    box.Position = UDim2.new(0, -30, 0, -40)
    box.BackgroundTransparency = 0.6
    box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    box.BorderSizePixel = 2
    box.BorderColor3 = Color3.fromRGB(0, 200, 255)
    box.ZIndex = 5

    -- 血条背景
    local healthBg = Instance.new("Frame")
    healthBg.Parent = container
    healthBg.Size = UDim2.new(0, 62, 0, 4)
    healthBg.Position = UDim2.new(0, -31, 0, 42)
    healthBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    healthBg.BorderSizePixel = 0
    healthBg.ZIndex = 6

    -- 血条
    local healthBar = Instance.new("Frame")
    healthBar.Parent = container
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.Position = UDim2.new(0, 0, 0, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthBar.BorderSizePixel = 0
    healthBar.ZIndex = 7

    -- 名字
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = container
    nameLabel.Size = UDim2.new(0, 120, 0, 18)
    nameLabel.Position = UDim2.new(0, -60, 0, -58)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = ""
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 13nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0.3
    nameLabel.ZIndex = 8

    -- 武器
    local weaponLabel = Instance.new("TextLabel")
    weaponLabel.Parent = container
    weaponLabel.Size = UDim2.new(0, 100, 0, 16)
    weaponLabel.Position = UDim2.new(0, -50, 0, 48)
    weaponLabel.BackgroundTransparency = 1
    weaponLabel.Text = ""
    weaponLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    weaponLabel.TextSize = 11
    weaponLabel.Font = Enum.Font.Gotham
    weaponLabel.TextStrokeTransparency = 0.3
    weaponLabel.ZIndex = 8

    -- 距离
    local distLabel = Instance.new("TextLabel")
    distLabel.Parent = container
    distLabel.Size = UDim2.new(0, 60, 0, 16)
    distLabel.Position = UDim2.new(0, -30, 0, 66)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = ""
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLabel.TextSize = 10
    distLabel.Font = Enum.Font.Gotham
    distLabel.ZIndex = 8

    -- 天线 (线)
    local line = Instance.new("Frame")
    line.Parent = container
    line.Size = UDim2.new(0, 2, 0, 40)
    line.Position = UDim2.new(0, -1, 0, -80)
    line.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    line.BackgroundTransparency = 0.3
    line.BorderSizePixel = 0
    line.ZIndex = 4

    -- 墙后检测指示器 (圆点)
    local wallDot = Instance.new("Frame")
    wallDot.Parent = container
    wallDot.Size = UDim2.new(0, 6, 0, 6)
    wallDot.Position = UDim2.new(0, -3, 0, -70)
    wallDot.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    wallDot.BorderSizePixel = 0
    wallDot.ZIndex = 9
    local dotCorner = Instance.new("UICorner")
    dotCorner.Parent = wallDot
    dotCorner.CornerRadius = UDim.new(1, 0)

    return {
        container = container,
        box = box,
        healthBg = healthBg,
        healthBar = healthBar,
        name = nameLabel,
        weapon = weaponLabel,
        dist = distLabel,
        line = line,
        wallDot = wallDot
    }
end

-- ========== 更新ESP ==========
local function updateESP()
    if not espEnabled then
        for _, obj in pairs(displayObjects) do
            if obj.container then obj.container.Visible = false end
        end
        return
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then goto continue end

        -- 队伍检测：队友不绘制
        if isTeammate(player) then
            if displayObjects[player.UserId] and displayObjects[player.UserId].container then
                displayObjects[player.UserId].container.Visible = false
            end
            goto continue
        end

        local char = player.Character
        if not char then
            if displayObjects[player.UserId] and displayObjects[player.UserId].container then
                displayObjects[player.UserId].container.Visible = false
            end
            goto continue
        end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if not hrp or not hum then
            if displayObjects[player.UserId] and displayObjects[player.UserId].container then
                displayObjects[player.UserId].container.Visible = false
            end
            goto continue
        end

        -- 创建或获取对象
        if not displayObjects[player.UserId] then
            displayObjects[player.UserId] = createLabels(player)
        end

        local obj = displayObjects[player.UserId]
        local headPos = hrp.Position + Vector3.new(0, 2.5, 0)
        local footPos = hrp.Position - Vector3.new(0, 2, 0)
        local screenHead, onScreen = worldToScreen(headPos)
        local screenFoot, _ = worldToScreen(footPos)

        if not onScreen then
            obj.container.Visible = false
            goto continue
        end

        -- 计算高度
        local height = math.abs(screenFoot.Y - screenHead.Y)
        if height < 20 then height = 60 end

        -- 更新位置
        obj.container.Position = UDim2.new(0, screenHead.X, 0, screenHead.Y - height * 0.5)
        obj.container.Size = UDim2.new(0, height * 0.5, 0, height)-- 更新方框
        obj.box.Size = UDim2.new(1, 0, 1, 0)
        obj.box.Position = UDim2.new(0, 0, 0, 0)

        -- 更新血条
        local hpPercent = math.max(hum.Health / hum.MaxHealth, 0)
        obj.healthBar.Size = UDim2.new(hpPercent, 0, 1, 0)
        obj.healthBar.BackgroundColor3 = hpPercent > 0.5 and Color3.fromRGB(0, 255, 0)
            or (hpPercent > 0.25 and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(255, 0, 0))
        obj.healthBg.Size = UDim2.new(1, 0, 0, 4)
        obj.healthBg.Position = UDim2.new(0, 0, 1, 4)

        -- 更新名字
        obj.name.Text = player.Name
        obj.name.Position = UDim2.new(0.5, -60, 0, -22)

        -- 更新武器
        local weapon = getWeapon(player)
        obj.weapon.Text = "🔫 " .. weapon
        obj.weapon.Position = UDim2.new(0.5, -50, 1, 2)

        -- 更新距离
        local localPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local dist = localPos and (hrp.Position - localPos.Position).Magnitude or 0
        obj.dist.Text = math.round(dist) .. "m"
        obj.dist.Position = UDim2.new(0.5, -30, 1, 18)

        -- 更新天线
        obj.line.Position = UDim2.new(0.5, -1, 0, -height * 0.5 - 10)
        obj.line.Size = UDim2.new(0, 2, 0, 20)

        -- 墙后检测
        local visible = isVisible(headPos)
        obj.wallDot.Visible = true
        obj.wallDot.Position = UDim2.new(0.5, -3, 0, -height * 0.5 - 35)
        obj.wallDot.BackgroundColor3 = visible and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 200, 0)
        obj.wallDot.Size = visible and UDim2.new(0, 6, 0, 6) or UDim2.new(0, 8, 0, 8)

        -- 方框颜色（墙后变色）
        obj.box.BorderColor3 = visible and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(255, 200, 0)

        obj.container.Visible = true

        ::continue::
    end

    -- 清理已离开玩家
    for id, obj in pairs(displayObjects) do
        if not Players:GetPlayerByUserId(id) then
            if obj.container then obj.container:Destroy() end
            displayObjects[id] = nil
        end
    end
end

-- ========== 创建悬浮窗 ==========
local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 200, 0, 280)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -140)
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
titleText.Text = "wdfex绘制"
titleText.TextColor3 = Color3.fromRGB(0, 200, 255)
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
    print("❌ wdfex绘制已关闭")
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
    minimized = not minimizedif minimized then
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
miniBall.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
miniBall.Text = "🎯"
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

-- ========== 内容按钮 ==========
local espBtn = Instance.new("TextButton")
espBtn.Parent = mainFrame
espBtn.Size = UDim2.new(0, 160, 0, 45)
espBtn.Position = UDim2.new(0.5, -80, 0, 55)
espBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
espBtn.Text = "🎯 绘制: 开"
espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
espBtn.TextSize = 18
espBtn.Font = Enum.Font.GothamBold
espBtn.BorderSizePixel = 0

local espCorner = Instance.new("UICorner")
espCorner.Parent = espBtn
espCorner.CornerRadius = UDim.new(0, 10)

espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.Text = espEnabled and "🎯 绘制: 开" or "🎯 绘制: 关"
    espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)
    print(espEnabled and "✅ 绘制开启" or "❌ 绘制关闭")
end)

local infoLabel = Instance.new("TextLabel")
infoLabel.Parent = mainFrame
infoLabel.Size = UDim2.new(1, -20, 0, 60)
infoLabel.Position = UDim2.new(0, 10, 0, 115)
infoLabel.Text = "血量 | 方框 | 名字\n天线 | 墙后检测 | 武器\n队伍检测 (队友不绘制)"
infoLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
infoLabel.BackgroundTransparency = 1
infoLabel.TextSize = 13
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextXAlignment = Enum.TextXAlignment.Left

local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = mainFrame
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 0, 0, 190)
statusLabel.Text = "🟢 运行中"
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham

local versionLabel = Instance.new("TextLabel")
versionLabel.Parent = mainFrame
versionLabel.Size = UDim2.new(1, 0, 0, 25)
versionLabel.Position = UDim2.new(0, 0, 0, 220)
versionLabel.Text = "wdfex绘制 v1.0 | 全游戏通用"
versionLabel.TextColor3 = Color3.fromRGB(100, 100, 140)
versionLabel.BackgroundTransparency = 1
versionLabel.TextSize = 12
versionLabel.Font = Enum.Font.Gotham

-- ========== 快捷键 ==========
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F then
        espEnabled = not espEnabled
        espBtn.Text = espEnabled and "🎯 绘制: 开" or "🎯 绘制: 关"
        espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)
        print(espEnabled and "✅ 绘制开启" or "❌ 绘制关闭")
    end
end)

-- ========== 启动 ==========
RunService.RenderStepped:Connect(updateESP)

print("========================================")
print("  ✅ wdfex单绘制 加载成功！")
print("  功能: 血量 | 方框 | 名字 | 天线")
print("  墙后检测 | 武器 | 队伍检测")
print("  F = 开关绘制  |  ✕ = 关闭")
print("  队友自动不绘制")
print("========================================")