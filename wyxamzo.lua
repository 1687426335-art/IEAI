-- ===== wdfex 圣奥里传送 =====

-- 基础服务定义
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local CurrentCamera = Workspace.CurrentCamera

-- ===== 欢迎弹窗 =====
local function ShowWelcome()
    pcall(function()
        local welcomeGui = Instance.new("ScreenGui")
        welcomeGui.Name = "wdfexWelcome"
        welcomeGui.ResetOnSpawn = false
        welcomeGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        welcomeGui.Parent = CoreGui
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 320, 0, 60)
        frame.Position = UDim2.new(1, -340, 0, 10)
        frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        frame.BackgroundTransparency = 0.15
        frame.BorderSizePixel = 2
        frame.BorderColor3 = Color3.fromRGB(100, 200, 255)
        frame.ClipsDescendants = true
        frame.Parent = welcomeGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = frame
        
        local colorBar = Instance.new("Frame")
        colorBar.Size = UDim2.new(0, 5, 1, 0)
        colorBar.Position = UDim2.new(0, 0, 0, 0)
        colorBar.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
        colorBar.BorderSizePixel = 0
        colorBar.Parent = frame
        
        local corner2 = Instance.new("UICorner")
        corner2.CornerRadius = UDim.new(0, 5)
        corner2.Parent = colorBar
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -15, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = "🎉 欢迎使用 wdfex 脚本"
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 18
        label.Font = Enum.Font.GothamBold
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
        frame.Position = UDim2.new(1, 0, 0, 10)
        local tween = TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -340, 0, 10)
        })
        tween:Play()
        
        task.wait(5)
        
        local outTween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 0, 0, 10)
        })
        outTween:Play()
        outTween.Completed:Wait()
        welcomeGui:Destroy()
    end)
end

-- 加载 UI 库
local UI_Library_URL = "https://raw.githubusercontent.com/114514lzkill/ui/refs/heads/main/ui.lua"
local Library = loadstring(game:HttpGet(UI_Library_URL))()

-- 创建窗口
local Window = Library:CreateWindow({
    ["Folder"] = "wdfexHub",
    ["Title"] = "wdfex-圣奥里",
    ["Author"] = "wdfex",
    ["Icon"] = "rbxassetid://7734068321",
    HideSearchBar = false,
})

-- ===== 创建彩色边框 =====
local function CreateColorfulBorder()
    pcall(function()
        task.wait(0.5)
        
        local mainGui = CoreGui:FindFirstChild("wdfexHub")
        if not mainGui then
            for _, child in ipairs(CoreGui:GetChildren()) do
                if child:IsA("ScreenGui") and (child.Name:find("wdfex") or child.Name:find("MyTestHub")) then
                    mainGui = child
                    break
                end
            end
        end
        
        if not mainGui then return end
        
        local oldBorder = mainGui:FindFirstChild("wdfexBorder")
        if oldBorder then oldBorder:Destroy() end
        
        local borderGui = Instance.new("Frame")
        borderGui.Name = "wdfexBorder"
        borderGui.Size = UDim2.new(1, 12, 1, 12)
        borderGui.Position = UDim2.new(0, -6, 0, -6)
        borderGui.BackgroundTransparency = 1
        borderGui.ZIndex = -1
        borderGui.Parent = mainGui
        
        local colors = {
            Color3.fromRGB(255, 50, 50),
            Color3.fromRGB(255, 200, 50),
            Color3.fromRGB(50, 255, 50),
            Color3.fromRGB(50, 150, 255),
            Color3.fromRGB(255, 50, 255),
            Color3.fromRGB(255, 100, 200),
        }
        
        local borderSize = 3
        
        local sides = {
            {size = UDim2.new(1, 0, 0, borderSize), pos = UDim2.new(0, 0, 0, 0)},
            {size = UDim2.new(1, 0, 0, borderSize), pos = UDim2.new(0, 0, 1, -borderSize)},
            {size = UDim2.new(0, borderSize, 1, 0), pos = UDim2.new(0, 0, 0, 0)},
            {size = UDim2.new(0, borderSize, 1, 0), pos = UDim2.new(1, -borderSize, 0, 0)},
        }
        
        for i, side in ipairs(sides) do
            local bar = Instance.new("Frame")
            bar.Size = side.size
            bar.Position = side.pos
            bar.BackgroundColor3 = colors[i]
            bar.BackgroundTransparency = 0.15
            bar.BorderSizePixel = 0
            bar.Parent = borderGui
        end
        
        local cornerSize = 12
        local corners = {
            {pos = UDim2.new(0, 0, 0, 0), color = colors[1]},
            {pos = UDim2.new(1, -cornerSize, 0, 0), color = colors[2]},
            {pos = UDim2.new(0, 0, 1, -cornerSize), color = colors[4]},
            {pos = UDim2.new(1, -cornerSize, 1, -cornerSize), color = colors[5]},
        }
        
        for _, cornerData in ipairs(corners) do
            local cornerFrame = Instance.new("Frame")
            cornerFrame.Size = UDim2.new(0, cornerSize, 0, cornerSize)
            cornerFrame.Position = cornerData.pos
            cornerFrame.BackgroundColor3 = cornerData.color
            cornerFrame.BackgroundTransparency = 0.2
            cornerFrame.BorderSizePixel = 0
            cornerFrame.Parent = borderGui
        end
    end)
end

-- ===== 传送函数 =====
local function TeleportTo(pos)
    pcall(function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(pos)
        end
    end)
end

-- 显示欢迎弹窗
ShowWelcome()

-- 创建彩色边框
task.spawn(function()
    task.wait(0.8)
    CreateColorfulBorder()
end)

-------------------------------------------------------------------------
-- Tab: 公告
-------------------------------------------------------------------------
local Tab_Notice = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "公告",
    ["Icon"] = "rbxassetid://115466270141583",
})

Tab_Notice:Section({
    TextSize = 17,
    ["Title"] = "━━━━━━━━━━━━━━━━━━━━",
    TextXAlignment = "Left",
})

Tab_Notice:Section({
    TextSize = 17,
    ["Title"] = "作者: wdfex",
    TextXAlignment = "Left",
})

Tab_Notice:Section({
    TextSize = 17,
    ["Title"] = "如果有什么需要的功能可以向作者提出建议",
    TextXAlignment = "Left",
})

Tab_Notice:Section({
    TextSize = 17,
    ["Title"] = "此脚本无防封需要先执行皮脚本再执行此脚本",
    TextXAlignment = "Left",
})

Tab_Notice:Section({
    TextSize = 17,
    ["Title"] = "作者快手名字: wdfex",
    TextXAlignment = "Left",
})

Tab_Notice:Section({
    TextSize = 17,
    ["Title"] = "作者QQ: 1687426335",
    TextXAlignment = "Left",
})

Tab_Notice:Section({
    TextSize = 17,
    ["Title"] = "━━━━━━━━━━━━━━━━━━━━",
    TextXAlignment = "Left",
})

-------------------------------------------------------------------------
-- Tab: 通用
-------------------------------------------------------------------------
local Tab_General = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "通用",
    ["Icon"] = "rbxassetid://18520370419",
})

Tab_General:Section({
    TextSize = 17,
    ["Title"] = "通用功能",
    TextXAlignment = "Left",
})

Tab_General:Button({
    ["Title"] = "飞天",
    ["Desc"] = "点击开启皮脚本飞行",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/07cdd3eeaf4d4928.txt_2024-08-09_090317.OTed.lua"))()
    end
})

Tab_General:Button({
    ["Title"] = "飞车",
    ["Desc"] = "点击开启皮脚本飞车",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/Pi-feiche.lua"))()
    end
})

-------------------------------------------------------------------------
-- Tab: 实用传送
-------------------------------------------------------------------------
local Tab_Teleport = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "实用传送",
    ["Icon"] = "rbxassetid://18520370419",
})

Tab_Teleport:Section({
    TextSize = 17,
    ["Title"] = "实用传送点",
    TextXAlignment = "Left",
})

Tab_Teleport:Button({
    ["Title"] = "枪店门口",
    ["Desc"] = "传送至枪店门口",
    ["Callback"] = function()
        TeleportTo(Vector3.new(-330.09, 2.63, 24.57))
    end
})

Tab_Teleport:Button({
    ["Title"] = "枪械商店",
    ["Desc"] = "传送至枪械商店",
    ["Callback"] = function()
        TeleportTo(Vector3.new(-336.86, -205.07, 61.75))
    end
})

Tab_Teleport:Button({
    ["Title"] = "黑色市场",
    ["Desc"] = "传送至黑色市场",
    ["Callback"] = function()
        TeleportTo(Vector3.new(1040.91, -22.73, 899.80))
    end
})

Tab_Teleport:Button({
    ["Title"] = "小银行",
    ["Desc"] = "传送至小银行",
    ["Callback"] = function()
        TeleportTo(Vector3.new(-667.74, 2.63, -67.18))
    end
})

Tab_Teleport:Button({
    ["Title"] = "大银行",
    ["Desc"] = "传送至大银行",
    ["Callback"] = function()
        TeleportTo(Vector3.new(3134.64, 6.12, -169.70))
    end
})

Tab_Teleport:Button({
    ["Title"] = "农场",
    ["Desc"] = "传送至农场",
    ["Callback"] = function()
        TeleportTo(Vector3.new(-1269.56, 2.57, 2559.51))
    end
})

Tab_Teleport:Button({
    ["Title"] = "警察局",
    ["Desc"] = "传送至警察局",
    ["Callback"] = function()
        TeleportTo(Vector3.new(3313.52, 3.02, -476.74))
    end
})

Tab_Teleport:Button({
    ["Title"] = "医院",
    ["Desc"] = "传送至医院",
    ["Callback"] = function()
        TeleportTo(Vector3.new(3892.10, 3.02, -185.78))
    end
})

Tab_Teleport:Button({
    ["Title"] = "游戏厅",
    ["Desc"] = "传送至游戏厅",
    ["Callback"] = function()
        TeleportTo(Vector3.new(2936.71, 2.63, 1688.17))
    end
})

Tab_Teleport:Button({
    ["Title"] = "超市",
    ["Desc"] = "传送至超市",
    ["Callback"] = function()
        TeleportTo(Vector3.new(3936.62, 3.04, 1136.92))
    end
})

Tab_Teleport:Button({
    ["Title"] = "平民出生点",
    ["Desc"] = "传送至平民出生点",
    ["Callback"] = function()
        TeleportTo(Vector3.new(3741.79, 3.72, -438.95))
    end
})

Tab_Teleport:Button({
    ["Title"] = "约克镇出生点",
    ["Desc"] = "传送至约克镇出生点",
    ["Callback"] = function()
        TeleportTo(Vector3.new(-221.64, 3.04, -84.56))
    end
})

Tab_Teleport:Button({
    ["Title"] = "躲藏点",
    ["Desc"] = "传送至躲藏点",
    ["Callback"] = function()
        TeleportTo(Vector3.new(-1505.97, 253.98, -476.43))
    end
})

Tab_Teleport:Button({
    ["Title"] = "游轮码头",
    ["Desc"] = "传送至游轮码头",
    ["Callback"] = function()
        TeleportTo(Vector3.new(985.45, -22.53, 1274.22))
    end
})

Tab_Teleport:Button({
    ["Title"] = "车辆维修",
    ["Desc"] = "传送至车辆维修",
    ["Callback"] = function()
        TeleportTo(Vector3.new(-409.58, 3.08, 2.80))
    end
})

Tab_Teleport:Button({
    ["Title"] = "监狱",
    ["Desc"] = "传送至监狱",
    ["Callback"] = function()
        TeleportTo(Vector3.new(-1605.21, 2.63, 1223.50))
    end
})

Tab_Teleport:Button({
    ["Title"] = "拆车场",
    ["Desc"] = "传送至拆车场",
    ["Callback"] = function()
        TeleportTo(Vector3.new(3434.49, 42.93, 2686.46))
    end
})

Tab_Teleport:Button({
    ["Title"] = "送货队伍",
    ["Desc"] = "传送至送货队伍",
    ["Callback"] = function()
        TeleportTo(Vector3.new(4402.39, 3.04, 1607.56))
    end
})

Tab_Teleport:Button({
    ["Title"] = "道路服务",
    ["Desc"] = "传送至道路服务",
    ["Callback"] = function()
        TeleportTo(Vector3.new(4275.96, 2.63, 1200.88))
    end
})

Tab_Teleport:Button({
    ["Title"] = "消防队伍",
    ["Desc"] = "传送至消防队伍",
    ["Callback"] = function()
        TeleportTo(Vector3.new(3578.02, 8.15, 577.34))
    end
})

Tab_Teleport:Button({
    ["Title"] = "车店",
    ["Desc"] = "传送至车店",
    ["Callback"] = function()
        TeleportTo(Vector3.new(0, 0, 0))
    end
})

-------------------------------------------------------------------------
-- Tab: 非法交易区
-------------------------------------------------------------------------
local Tab_Illegal = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "非法交易区",
    ["Icon"] = "rbxassetid://18520370419",
})

Tab_Illegal:Section({
    TextSize = 17,
    ["Title"] = "非法交易传送点",
    TextXAlignment = "Left",
})

Tab_Illegal:Button({
    ["Title"] = "非法交易任务接取点1",
    ["Desc"] = "传送至非法交易任务接取点",
    ["Callback"] = function()
        TeleportTo(Vector3.new(2284.16, -16.97, 2652.88))
    end
})

-------------------------------------------------------------------------
-- Tab: 外卖员
-------------------------------------------------------------------------
local Tab_Delivery = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "外卖员",
    ["Icon"] = "rbxassetid://15440802720",
})

Tab_Delivery:Section({
    TextSize = 17,
    ["Title"] = "外卖员传送点",
    TextXAlignment = "Left",
})

Tab_Delivery:Button({
    ["Title"] = "圣奥里取餐点",
    ["Desc"] = "传送至圣奥里取餐点",
    ["Callback"] = function()
        TeleportTo(Vector3.new(3070.80, 3.02, 451.35))
    end
})

Tab_Delivery:Button({
    ["Title"] = "莱斯维尔取餐点",
    ["Desc"] = "传送至莱斯维尔取餐点",
    ["Callback"] = function()
        TeleportTo(Vector3.new(756.54, 3.04, 1006.94))
    end
})

Tab_Delivery:Button({
    ["Title"] = "北方圣奥里取餐点",
    ["Desc"] = "传送至北方圣奥里取餐点",
    ["Callback"] = function()
        TeleportTo(Vector3.new(4535.62, 2.60, 915.71))
    end
})

-------------------------------------------------------------------------
-- Tab: 透视
-------------------------------------------------------------------------
local Tab_ESP = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "透视",
    ["Icon"] = "rbxassetid://18520370419",
})

Tab_ESP:Section({
    TextSize = 17,
    ["Title"] = "玩家透视（含血量/距离/名字/骨骼）",
    TextXAlignment = "Left",
})

local espEnabled = false
local espObjects = {}

local function GetPlayerStatus(player)
    local status = "平民"
    local isWanted = false
    
    -- 检测是否有通缉状态
    if player.Character then
        for _, child in ipairs(player.Character:GetDescendants()) do
            if child:IsA("BoolValue") or child:IsA("StringValue") then
                local name = child.Name:lower()
                if name:find("wanted") or name:find("通缉") or name:find("criminal") then
                    isWanted = true
                    break
                end
            end
        end
    end
    
    -- 检测队伍
    if player.Team then
        local teamName = player.Team.Name or ""
        if teamName:find("警察") or teamName:find("Police") or teamName:find("Cop") then
            status = "警察"
        elseif teamName:find("匪徒") or teamName:find("Criminal") or teamName:find("Gang") then
            status = "匪徒"
            isWanted = true
        elseif teamName:find("医疗") or teamName:find("Medic") or teamName:find("医生") then
            status = "医疗"
        elseif teamName:find("消防") or teamName:find("Fire") then
            status = "消防"
        elseif teamName:find("道路") or teamName:find("Road") then
            status = "道路"
        else
            status = "平民"
        end
    end
    
    if isWanted then
        status = "通缉犯"
    end
    
    return status
end

local function CreateSkeletonESP(player)
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local health = humanoid and math.floor(humanoid.Health) or 0
    local distance = rootPart and math.floor((LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude) or 0)
    local status = GetPlayerStatus(player)
    
    -- 颜色根据状态变化
    local statusColor = Color3.fromRGB(0, 255, 0)
    if status == "通缉犯" then
        statusColor = Color3.fromRGB(255, 0, 0)
    elseif status == "警察" then
        statusColor = Color3.fromRGB(0, 100, 255)
    elseif status == "匪徒" then
        statusColor = Color3.fromRGB(255, 100, 0)
    elseif status == "医疗" then
        statusColor = Color3.fromRGB(0, 255, 100)
    elseif status == "消防" then
        statusColor = Color3.fromRGB(255, 150, 0)
    elseif status == "道路" then
        statusColor = Color3.fromRGB(255, 255, 0)
    end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 160, 0, 80)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = rootPart
    table.insert(espObjects, billboard)
    
    -- 名字
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 16)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 12
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0.3
    nameLabel.Parent = billboard
    table.insert(espObjects, nameLabel)
    
    -- 状态（队伍/通缉）
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, 0, 0, 14)
    statusLabel.Position = UDim2.new(0, 0, 0, 17)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = status
    statusLabel.TextColor3 = statusColor
    statusLabel.TextSize = 11
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextStrokeTransparency = 0.3
    statusLabel.Parent = billboard
    table.insert(espObjects, statusLabel)
    
    -- 血量条背景
    local healthBg = Instance.new("Frame")
    healthBg.Size = UDim2.new(0.7, 0, 0, 5)
    healthBg.Position = UDim2.new(0.15, 0, 0, 33)
    healthBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    healthBg.BorderSizePixel = 0
    healthBg.Parent = billboard
    table.insert(espObjects, healthBg)
    
    -- 血量条
    local healthBar = Instance.new("Frame")
    healthBar.Size = UDim2.new((health / 100), 0, 1, 0)
    healthBar.BackgroundColor3 = health > 50 and Color3.fromRGB(0, 255, 0) or health > 25 and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 0, 0)
    healthBar.BorderSizePixel = 0
    healthBar.Parent = healthBg
    table.insert(espObjects, healthBar)
    
    -- 血量数值
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1, 0, 0, 12)
    healthLabel.Position = UDim2.new(0, 0, 0, 40)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = health .. " HP"
    healthLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    healthLabel.TextSize = 10
    healthLabel.Font = Enum.Font.Gotham
    healthLabel.Parent = billboard
    table.insert(espObjects, healthLabel)
    
    -- 距离
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1, 0, 0, 12)
    distLabel.Position = UDim2.new(0, 0, 0, 54)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = distance .. "m"
    distLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    distLabel.TextSize = 10
    distLabel.Font = Enum.Font.Gotham
    distLabel.Parent = billboard
    table.insert(espObjects, distLabel)
end

-- 更新血量循环
local function UpdateESPHealth()
    for _, obj in ipairs(espObjects) do
        if obj:IsA("BillboardGui") then
            local rootPart = obj.Parent
            if rootPart and rootPart:IsA("BasePart") then
                local character = rootPart.Parent
                if character and character:IsA("Model") then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    local health = humanoid and math.floor(humanoid.Health) or 0
                    for _, child in ipairs(obj:GetChildren()) do
                        if child:IsA("TextLabel") and child.Text and child.Text:find("HP") then
                            child.Text = health .. " HP"
                        end
                        if child:IsA("Frame") and child.Size then
                            local healthBar = child:FindFirstChildWhichIsA("Frame")
                            if healthBar then
                                healthBar.Size = UDim2.new((health / 100), 0, 1, 0)
                                healthBar.BackgroundColor3 = health > 50 and Color3.fromRGB(0, 255, 0) or health > 25 and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 0, 0)
                            end
                        end
                    end
                end
            end
        end
    end
end

local function ToggleESP()
    espEnabled = not espEnabled
    
    if espEnabled then
        for _, obj in ipairs(espObjects) do
            pcall(function() obj:Destroy() end)
        end
        espObjects = {}
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                CreateSkeletonESP(player)
            end
        end
        
        -- 启动血量更新循环
        if espEnabled then
            RunService.Heartbeat:Connect(function()
                if espEnabled then
                    UpdateESPHealth()
                end
            end)
        end
    else
        for _, obj in ipairs(espObjects) do
            pcall(function() obj:Destroy() end)
        end
        espObjects = {}
    end
end

Tab_ESP:Toggle({
    ["Title"] = "玩家透视（血量/距离/名字/队伍/通缉）",
    ["Desc"] = "显示所有玩家的完整信息（含队伍和通缉状态）",
    ["Default"] = false,
    ["Callback"] = function(bool)
        if bool then
            if not espEnabled then
                ToggleESP()
            end
        else
            if espEnabled then
                ToggleESP()
            end
        end
    end
})

-------------------------------------------------------------------------
-- Tab: 范围
-------------------------------------------------------------------------
local Tab_Range = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "范围",
    ["Icon"] = "rbxassetid://87107069659024",
})

Tab_Range:Section({
    TextSize = 17,
    ["Title"] = "范围功能",
    TextXAlignment = "Left",
})

_G.RangeConn = nil
local function updateRange(size)
    if _G.RangeConn then
        _G.RangeConn:Disconnect()
        _G.RangeConn = nil
    end
    if size == 0 then
        return
    end
    _G.HeadSize = size
    _G.Disabled = true
    _G.RangeConn = RunService.RenderStepped:Connect(function()
        if _G.Disabled then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer then
                    pcall(function()
                        if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                            v.Character.HumanoidRootPart.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                            v.Character.HumanoidRootPart.Transparency = 0.7
                            v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really blue")
                            v.Character.HumanoidRootPart.Material = "Neon"
                            v.Character.HumanoidRootPart.CanCollide = false
                        end
                    end)
                end
            end
        end
    end)
end

Tab_Range:Button({
    ["Title"] = "清空范围效果",
    ["Desc"] = "关闭范围修改",
    ["Callback"] = function()
        updateRange(0)
    end
})

Tab_Range:Button({
    ["Title"] = "范围10",
    ["Desc"] = "设置碰撞箱大小为10",
    ["Callback"] = function()
        updateRange(10)
    end
})

Tab_Range:Button({
    ["Title"] = "范围20",
    ["Desc"] = "设置碰撞箱大小为20",
    ["Callback"] = function()
        updateRange(20)
    end
})

Tab_Range:Button({
    ["Title"] = "范围30",
    ["Desc"] = "设置碰撞箱大小为30",
    ["Callback"] = function()
        updateRange(30)
    end
})

Tab_Range:Button({
    ["Title"] = "范围50",
    ["Desc"] = "设置碰撞箱大小为50",
    ["Callback"] = function()
        updateRange(50)
    end
})

Tab_Range:Button({
    ["Title"] = "范围70",
    ["Desc"] = "设置碰撞箱大小为70",
    ["Callback"] = function()
        updateRange(70)
    end
})

Tab_Range:Button({
    ["Title"] = "范围120",
    ["Desc"] = "设置碰撞箱大小为120",
    ["Callback"] = function()
        updateRange(120)
    end
})

Tab_Range:Button({
    ["Title"] = "范围300",
    ["Desc"] = "设置碰撞箱大小为300",
    ["Callback"] = function()
        updateRange(300)
    end
})

Tab_Range:Button({
    ["Title"] = "范围500",
    ["Desc"] = "设置碰撞箱大小为500",
    ["Callback"] = function()
        updateRange(500)
    end
})

Tab_Range:Button({
    ["Title"] = "范围999",
    ["Desc"] = "设置碰撞箱大小为999",
    ["Callback"] = function()
        updateRange(999)
    end
})

Tab_Range:Button({
    ["Title"] = "范围999999999",
    ["Desc"] = "设置碰撞箱大小为999999999",
    ["Callback"] = function()
        updateRange(999999999)
    end
})

-------------------------------------------------------------------------
-- Tab: 自瞄
-------------------------------------------------------------------------
local Tab_Aimbot = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "自瞄",
    ["Icon"] = "rbxassetid://18520370419",
})

Tab_Aimbot:Section({
    TextSize = 17,
    ["Title"] = "皮脚本自瞄",
    TextXAlignment = "Left",
})

Tab_Aimbot:Button({
    ["Title"] = "开启皮脚本自瞄",
    ["Desc"] = "点击开启皮脚本自瞄",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://pastefy.app/YnfF3sje/raw"))()
    end
})

-------------------------------------------------------------------------
-- Tab: 设置
-------------------------------------------------------------------------
local Tab_Settings = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "设置",
    ["Icon"] = "rbxassetid://14895392107",
})

Tab_Settings:Section({
    TextSize = 17,
    ["Title"] = "控制",
    TextXAlignment = "Left",
})

Tab_Settings:Button({
    ["Title"] = "关闭脚本",
    ["Desc"] = "关闭脚本并清理UI",
    ["Callback"] = function()
        getgenv().EasterEgg = false
        if _G.RangeConn then
            _G.RangeConn:Disconnect()
            _G.RangeConn = nil
        end
        pcall(function()
            local frosty = CoreGui:FindFirstChild("frosty")
            if frosty then frosty:Destroy() end
            local eggGui = CoreGui:FindFirstChild("EasterEggGui")
            if eggGui then eggGui:Destroy() end
            local welcomeGui = CoreGui:FindFirstChild("wdfexWelcome")
            if welcomeGui then welcomeGui:Destroy() end
            local borderGui = CoreGui:FindFirstChild("wdfexBorder")
            if borderGui then borderGui:Destroy() end
            local hubGui = CoreGui:FindFirstChild("wdfexHub")
            if hubGui then hubGui:Destroy() end
        end)
        Window:Close()
    end
})

-- 彩蛋开关
local easterEggEnabled = false
Tab_Settings:Toggle({
    ["Title"] = "彩蛋开关",
    ["Desc"] = "开启彩蛋功能",
    ["Default"] = false,
    ["Callback"] = function(bool)
        easterEggEnabled = bool
        getgenv().EasterEgg = bool
        
        if bool then
            TeleportTo(Vector3.new(4402.39, 3.04, 1607.56))
            
            pcall(function()
                local eggGui = Instance.new("ScreenGui")
                eggGui.Name = "EasterEggGui"
                eggGui.Parent = CoreGui
                eggGui.ResetOnSpawn = false
                
                local textLabel = Instance.new("TextLabel")
                textLabel.Name = "EggLabel"
                textLabel.Parent = eggGui
                textLabel.Size = UDim2.new(0, 220, 0, 30)
                textLabel.Position = UDim2.new(1, -230, 1, -40)
                textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                textLabel.BackgroundTransparency = 0.4
                textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                textLabel.TextSize = 16
                textLabel.Font = Enum.Font.GothamBold
                textLabel.Text = "你还想要彩蛋赶紧去送货吧🤣"
                textLabel.TextScaled = true
                
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 8)
                corner.Parent = textLabel
            end)
        else
            pcall(function()
                local eggGui = CoreGui:FindFirstChild("EasterEggGui")
                if eggGui then eggGui:Destroy() end
            end)
        end
    end
})

print("wdfex-圣奥里已加载")
print("共24个传送点 + 透视 + 范围 + 自瞄 + 通用 + 彩色边框 + 欢迎弹窗")