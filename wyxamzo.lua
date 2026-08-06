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
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")

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
        
        local sound = Instance.new("Sound")
        sound.Name = "WelcomeSound"
        sound.SoundId = "rbxassetid://9120393428"
        sound.Volume = 0.5
        sound.Parent = welcomeGui
        sound:Play()
        
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
        label.Text = "欢迎使用 wdfex 脚本"
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
        
        task.wait(6)
        local outTween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 0, 0, 10)
        })
        outTween:Play()
        outTween.Completed:Wait()
        welcomeGui:Destroy()
    end)
end

ShowWelcome()

-- 加载 UI 库
local UI_Library_URL = "https://raw.githubusercontent.com/114514lzkill/ui/refs/heads/main/ui.lua"
local Library = loadstring(game:HttpGet(UI_Library_URL))()

if not Library then
    UI_Library_URL = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/UI.Lua"
    Library = loadstring(game:HttpGet(UI_Library_URL))()
end

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
    ["Title"] = "本脚本已同步连接皮脚本的服务器，可在透视里面打开同行显示即可在皮脚本用户的头上显示皮脚本更容易让你分辨它是什么脚本",
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

local whiteoutEnabled = false

Tab_Notice:Toggle({
    ["Title"] = "打开此开关有大惊喜",
    ["Desc"] = "开启后游戏亮度拉满变成全白",
    ["Default"] = false,
    ["Callback"] = function(bool)
        whiteoutEnabled = bool
        if bool then
            pcall(function()
                Lighting.Brightness = 10
                Lighting.ExposureCompensation = 10
                Lighting.Ambient = Color3.fromRGB(255, 255, 255)
                Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
                Lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
                Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
                Lighting.GlobalShadows = false
                Lighting.FogEnd = 100000
                for _, atom in ipairs(Lighting:GetChildren()) do
                    if atom:IsA("BloomEffect") or atom:IsA("BlurEffect") or atom:IsA("ColorCorrectionEffect") then
                        atom.Enabled = false
                    end
                end
            end)
        else
            pcall(function()
                Lighting.Brightness = 2
                Lighting.ExposureCompensation = 0
                Lighting.Ambient = Color3.fromRGB(127, 127, 127)
                Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
                Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
                Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
                Lighting.GlobalShadows = true
                Lighting.FogEnd = 100000
            end)
        end
    end
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

Tab_General:Button({
    ["Title"] = "断麦",
    ["Desc"] = "强制断开所有人语音",
    ["Callback"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Rootleak/Stalkie-2.0/refs/heads/main/vc.lua"))()
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

local teleportPoints = {
    {"枪店门口", Vector3.new(-330.09, 2.63, 24.57)},
    {"枪械商店", Vector3.new(-336.86, -205.07, 61.75)},
    {"黑色市场", Vector3.new(1040.91, -22.73, 899.80)},
    {"小银行", Vector3.new(-667.74, 2.63, -67.18)},
    {"大银行", Vector3.new(3134.64, 6.12, -169.70)},
    {"农场", Vector3.new(-1269.56, 2.57, 2559.51)},
    {"警察局", Vector3.new(3313.52, 3.02, -476.74)},
    {"医院", Vector3.new(3892.10, 3.02, -185.78)},
    {"游戏厅", Vector3.new(2936.71, 2.63, 1688.17)},
    {"超市", Vector3.new(3936.62, 3.04, 1136.92)},
    {"平民出生点", Vector3.new(3741.79, 3.72, -438.95)},
    {"约克镇出生点", Vector3.new(-221.64, 3.04, -84.56)},
    {"躲藏点", Vector3.new(-1505.97, 253.98, -476.43)},
    {"游轮码头", Vector3.new(985.45, -22.53, 1274.22)},
    {"车辆维修", Vector3.new(-409.58, 3.08, 2.80)},
    {"监狱", Vector3.new(-1605.21, 2.63, 1223.50)},
    {"拆车场", Vector3.new(3434.49, 42.93, 2686.46)},
    {"送货队伍", Vector3.new(4402.39, 3.04, 1607.56)},
    {"道路服务", Vector3.new(4275.96, 2.63, 1200.88)},
    {"消防队伍", Vector3.new(3578.02, 8.15, 577.34)},
    {"车店", Vector3.new(0, 0, 0)},
}

for _, point in ipairs(teleportPoints) do
    Tab_Teleport:Button({
        ["Title"] = point[1],
        ["Desc"] = "传送至" .. point[1],
        ["Callback"] = function()
            TeleportTo(point[2])
        end
    })
end

-------------------------------------------------------------------------
-- Tab: 售货机传送区
-------------------------------------------------------------------------
local Tab_Vending = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "售货机传送区",
    ["Icon"] = "rbxassetid://18520370419",
})

Tab_Vending:Section({
    TextSize = 17,
    ["Title"] = "售货机传送点",
    TextXAlignment = "Left",
})

local vendingPoints = {
    {"警察局售货机", Vector3.new(3375.46, -337.46, -473.67)},
    {"医院售货机", Vector3.new(3939.51, -337.12, -199.84)},
    {"游戏厅售货机", Vector3.new(2904.22, -337.11, 1732.52)},
    {"当铺售货机", Vector3.new(-207.06, -337.05, -99.43)},
}

for _, point in ipairs(vendingPoints) do
    Tab_Vending:Button({
        ["Title"] = point[1],
        ["Desc"] = "传送至" .. point[1],
        ["Callback"] = function()
            TeleportTo(point[2])
        end
    })
end

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

local deliveryPoints = {
    {"圣奥里取餐点", Vector3.new(3070.80, 3.02, 451.35)},
    {"莱斯维尔取餐点", Vector3.new(756.54, 3.04, 1006.94)},
    {"北方圣奥里取餐点", Vector3.new(4535.62, 2.60, 915.71)},
}

for _, point in ipairs(deliveryPoints) do
    Tab_Delivery:Button({
        ["Title"] = point[1],
        ["Desc"] = "传送至" .. point[1],
        ["Callback"] = function()
            TeleportTo(point[2])
        end
    })
end

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
    ["Title"] = "透视开关",
    TextXAlignment = "Left",
})

local espMasterEnabled = false
local espObjects = {}
local espRenderConnection = nil

local espShowName = false
local espShowHealth = false
local espShowBox = false
local espShowDist = false
local espShowScriptTag = false
local espShowSelf = true
local espShowTeam = false
local espShowWeapon = false

local function ClearESP()
    for _, obj in ipairs(espObjects) do
        pcall(function() obj:Destroy() end)
    end
    espObjects = {}
    if espRenderConnection then
        espRenderConnection:Disconnect()
        espRenderConnection = nil
    end
end

local function GetPlayerWeapon(player)
    local character = player.Character
    if not character then return "赤手空拳" end
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Tool") and child:FindFirstChild("Handle") then
            return child.Name
        end
    end
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") then return child.Name end
        end
    end
    return "赤手空拳"
end

local function GetPlayerTeam(player)
    if not player.Team then return "平民" end
    local teamName = player.Team.Name or ""
    if teamName:find("警察") or teamName:find("Police") or teamName:find("Cop") then return "警察"
    elseif teamName:find("匪徒") or teamName:find("Criminal") or teamName:find("Gang") then return "匪徒"
    elseif teamName:find("医疗") or teamName:find("Medic") or teamName:find("医生") then return "医疗"
    elseif teamName:find("消防") or teamName:find("Fire") then return "火焰"
    elseif teamName:find("道路") or teamName:find("Road") then return "道路"
    elseif teamName:find("送货") or teamName:find("Delivery") then return "送货"
    elseif teamName:find("农民") or teamName:find("Farm") then return "农民"
    else return "平民" end
end

local function CheckPlayerScript(player)
    for _, child in ipairs(player:GetChildren()) do
        if child:IsA("BoolValue") or child:IsA("StringValue") then
            local name = child.Name:lower()
            if name:find("perscript") or name:find("xiaopi") or name:find("皮脚本") then return "皮脚本" end
            if name:find("wdfex") or name:find("wdfexscript") then return "wdfex" end
        end
    end
    if player == LocalPlayer then
        if LocalPlayer:FindFirstChild("PiScriptTag") or LocalPlayer:FindFirstChild("XiaoPi") then return "皮脚本" end
        return "wdfex"
    end
    return nil
end

local function CreateESPForPlayer(player)
    local character = player.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local health = humanoid and math.floor(humanoid.Health) or 0
    local maxHealth = humanoid and math.floor(humanoid.MaxHealth) or 100
    
    local localHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local distance = localHrp and math.floor((localHrp.Position - rootPart.Position).Magnitude) or 0
    
    local charSize = rootPart.Size
    local weapon = GetPlayerWeapon(player)
    local team = GetPlayerTeam(player)
    local scriptTag = CheckPlayerScript(player)
    
    local teamColor = Color3.fromRGB(200, 200, 200)
    if team == "警察" then teamColor = Color3.fromRGB(0, 150, 255)
    elseif team == "匪徒" then teamColor = Color3.fromRGB(255, 50, 50)
    elseif team == "医疗" then teamColor = Color3.fromRGB(0, 255, 100)
    elseif team == "火焰" then teamColor = Color3.fromRGB(255, 150, 0)
    elseif team == "道路" then teamColor = Color3.fromRGB(255, 255, 0)
    elseif team == "送货" then teamColor = Color3.fromRGB(255, 150, 255)
    elseif team == "农民" then teamColor = Color3.fromRGB(50, 255, 50)
    end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 250, 0, 120)
    billboard.StudsOffset = Vector3.new(0, charSize.Y / 2 + 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = rootPart
    table.insert(espObjects, billboard)
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.5
    bg.BorderSizePixel = 1
    bg.BorderColor3 = Color3.fromRGB(255, 255, 255)
    bg.Parent = billboard
    table.insert(espObjects, bg)
    
    local corner1 = Instance.new("UICorner")
    corner1.CornerRadius = UDim.new(0, 6)
    corner1.Parent = bg
    
    local yOffset = 5
    
    if espShowName then
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -10, 0, 20)
        nameLabel.Position = UDim2.new(0, 5, 0, yOffset)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player == LocalPlayer and (player.Name .. " *") or player.Name
        nameLabel.TextColor3 = player == LocalPlayer and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextStrokeTransparency = 0.2
        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLabel.Parent = billboard
        table.insert(espObjects, nameLabel)
        yOffset = yOffset + 22
    end
    
    if espShowTeam then
        local teamLabel = Instance.new("TextLabel")
        teamLabel.Size = UDim2.new(1, -10, 0, 16)
        teamLabel.Position = UDim2.new(0, 5, 0, yOffset)
        teamLabel.BackgroundTransparency = 1
        teamLabel.Text = "[" .. team .. "]"
        teamLabel.TextColor3 = teamColor
        teamLabel.TextSize = 12
        teamLabel.Font = Enum.Font.GothamBold
        teamLabel.TextStrokeTransparency = 0.2
        teamLabel.Parent = billboard
        table.insert(espObjects, teamLabel)
        yOffset = yOffset + 18
    end
    
    if espShowWeapon then
        local weaponLabel = Instance.new("TextLabel")
        weaponLabel.Size = UDim2.new(1, -10, 0, 16)
        weaponLabel.Position = UDim2.new(0, 5, 0, yOffset)
        weaponLabel.BackgroundTransparency = 1
        weaponLabel.Text = weapon == "赤手空拳" and "空手" or weapon
        weaponLabel.TextColor3 = weapon == "赤手空拳" and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(255, 200, 100)
        weaponLabel.TextSize = 12
        weaponLabel.Font = Enum.Font.Gotham
        weaponLabel.TextStrokeTransparency = 0.2
        weaponLabel.Parent = billboard
        table.insert(espObjects, weaponLabel)
        yOffset = yOffset + 18
    end
    
    if espShowScriptTag and scriptTag then
        local tagColor = scriptTag == "皮脚本" and Color3.fromRGB(255, 100, 100) or 
                         scriptTag == "wdfex" and Color3.fromRGB(100, 180, 255) or 
                         Color3.fromRGB(200, 100, 255)
        local tagLabel = Instance.new("TextLabel")
        tagLabel.Size = UDim2.new(1, -10, 0, 16)
        tagLabel.Position = UDim2.new(0, 5, 0, yOffset)
        tagLabel.BackgroundTransparency = 1
        tagLabel.Text = scriptTag
        tagLabel.TextColor3 = tagColor
        tagLabel.TextSize = 11
        tagLabel.Font = Enum.Font.GothamBold
        tagLabel.TextStrokeTransparency = 0.2
        tagLabel.Parent = billboard
        table.insert(espObjects, tagLabel)
        yOffset = yOffset + 18
    end
    
    if espShowHealth then
        local healthBg = Instance.new("Frame")
        healthBg.Size = UDim2.new(0.8, 0, 0, 8)
        healthBg.Position = UDim2.new(0.1, 0, 0, yOffset)
        healthBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        healthBg.BorderSizePixel = 1
        healthBg.BorderColor3 = Color3.fromRGB(60, 60, 60)
        healthBg.Parent = billboard
        table.insert(espObjects, healthBg)
        
        local healthPercent = math.clamp(health / maxHealth, 0, 1)
        local healthBar = Instance.new("Frame")
        healthBar.Size = UDim2.new(healthPercent, 0, 1, 0)
        healthBar.BackgroundColor3 = healthPercent > 0.5 and Color3.fromRGB(0, 255, 100) or 
                                     healthPercent > 0.25 and Color3.fromRGB(255, 200, 0) or 
                                     Color3.fromRGB(255, 50, 50)
        healthBar.BorderSizePixel = 0
        healthBar.Parent = healthBg
        table.insert(espObjects, healthBar)
        
        local healthLabel = Instance.new("TextLabel")
        healthLabel.Size = UDim2.new(1, -10, 0, 14)
        healthLabel.Position = UDim2.new(0, 5, 0, yOffset + 10)
        healthLabel.BackgroundTransparency = 1
        healthLabel.Text = health .. "/" .. maxHealth
        healthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        healthLabel.TextSize = 11
        healthLabel.Font = Enum.Font.Gotham
        healthLabel.TextStrokeTransparency = 0.2
        healthLabel.Parent = billboard
        table.insert(espObjects, healthLabel)
        yOffset = yOffset + 28
    end
    
    if espShowDist and player ~= LocalPlayer then
        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(1, -10, 0, 14)
        distLabel.Position = UDim2.new(0, 5, 0, yOffset)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = distance .. "m"
        distLabel.TextColor3 = Color3.fromRGB(180, 180, 255)
        distLabel.TextSize = 11
        distLabel.Font = Enum.Font.Gotham
        distLabel.TextStrokeTransparency = 0.2
        distLabel.Parent = billboard
        table.insert(espObjects, distLabel)
        yOffset = yOffset + 16
    end
    
    if espShowBox then
        local box = Instance.new("BoxHandleAdornment")
        box.Size = Vector3.new(3.8, 5.8, 2)
        box.Adornee = rootPart
        box.Color3 = Color3.fromRGB(0, 200, 255)
        box.Transparency = 0.3
        box.ZIndex = 0
        box.AlwaysOnTop = true
        box.Parent = rootPart
        table.insert(espObjects, box)
        
        local outline = Instance.new("BoxHandleAdornment")
        outline.Size = Vector3.new(4.2, 6.2, 2.4)
        outline.Adornee = rootPart
        outline.Color3 = Color3.fromRGB(255, 255, 255)
        outline.Transparency = 0.8
        outline.ZIndex = -1
        outline.AlwaysOnTop = true
        outline.Parent = rootPart
        table.insert(espObjects, outline)
    end
end

local function UpdateESP()
    ClearESP()
    if not espMasterEnabled then return end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer and espShowSelf then
        else
            CreateESPForPlayer(player)
        end
    end
end

Tab_ESP:Toggle({
    ["Title"] = "透视总开关",
    ["Desc"] = "开启/关闭所有透视功能",
    ["Default"] = false,
    ["Callback"] = function(bool)
        espMasterEnabled = bool
        if bool then
            UpdateESP()
            if not espRenderConnection then
                espRenderConnection = RunService.Heartbeat:Connect(function()
                    if espMasterEnabled then UpdateESP() end
                end)
            end
            Players.PlayerAdded:Connect(function()
                if espMasterEnabled then UpdateESP() end
            end)
            Players.PlayerRemoving:Connect(function()
                if espMasterEnabled then UpdateESP() end
            end)
            for _, player in ipairs(Players:GetPlayers()) do
                player.CharacterAdded:Connect(function()
                    if espMasterEnabled then UpdateESP() end
                end)
            end
        else
            ClearESP()
        end
    end
})

Tab_ESP:Toggle({
    ["Title"] = "绘制名字",
    ["Desc"] = "显示玩家名字",
    ["Default"] = false,
    ["Callback"] = function(bool)
        espShowName = bool
        if espMasterEnabled then UpdateESP() end
    end
})

Tab_ESP:Toggle({
    ["Title"] = "绘制血量",
    ["Desc"] = "显示玩家血量条和数值",
    ["Default"] = false,
    ["Callback"] = function(bool)
        espShowHealth = bool
        if espMasterEnabled then UpdateESP() end
    end
})

Tab_ESP:Toggle({
    ["Title"] = "绘制方框",
    ["Desc"] = "显示玩家方框",
    ["Default"] = false,
    ["Callback"] = function(bool)
        espShowBox = bool
        if espMasterEnabled then UpdateESP() end
    end
})

Tab_ESP:Toggle({
    ["Title"] = "绘制距离",
    ["Desc"] = "显示与玩家的距离",
    ["Default"] = false,
    ["Callback"] = function(bool)
        espShowDist = bool
        if espMasterEnabled then UpdateESP() end
    end
})

Tab_ESP:Toggle({
    ["Title"] = "同行显示",
    ["Desc"] = "检测并显示玩家使用的脚本",
    ["Default"] = false,
    ["Callback"] = function(bool)
        espShowScriptTag = bool
        if espMasterEnabled then UpdateESP() end
    end
})

Tab_ESP:Toggle({
    ["Title"] = "屏蔽自己",
    ["Desc"] = "开启后自己不显示透视",
    ["Default"] = true,
    ["Callback"] = function(bool)
        espShowSelf = bool
        if espMasterEnabled then UpdateESP() end
    end
})

Tab_ESP:Toggle({
    ["Title"] = "显示队伍",
    ["Desc"] = "显示玩家所属队伍",
    ["Default"] = false,
    ["Callback"] = function(bool)
        espShowTeam = bool
        if espMasterEnabled then UpdateESP() end
    end
})

Tab_ESP:Toggle({
    ["Title"] = "绘制手持武器",
    ["Desc"] = "显示玩家手持的武器名称",
    ["Default"] = false,
    ["Callback"] = function(bool)
        espShowWeapon = bool
        if espMasterEnabled then UpdateESP() end
    end
})

-------------------------------------------------------------------------
-- Tab: 标点传送
-------------------------------------------------------------------------
local Tab_Waypoint = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "标点传送",
    ["Icon"] = "rbxassetid://18520370419",
})

Tab_Waypoint:Section({
    TextSize = 17,
    ["Title"] = "地图标点传送",
    TextXAlignment = "Left",
})

local function GetWaypointPosition()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local closest = nil
    local closestDist = 9999
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Position then
            local name = obj.Name:lower()
            if name:find("waypoint") or name:find("marker") or name:find("标点") or name:find("导航") or name:find("nav") or name:find("目标") or name:find("target") or name:find("destination") or name:find("pin") then
                local dist = (hrp.Position - obj.Position).Magnitude
                if dist < closestDist and dist > 2 then
                    closestDist = dist
                    closest = obj.Position
                end
            end
            if obj:FindFirstChild("BillboardGui") or obj:FindFirstChild("SelectionBox") or obj:FindFirstChild("SelectionSphere") then
                local dist = (hrp.Position - obj.Position).Magnitude
                if dist < closestDist and dist > 2 then
                    closestDist = dist
                    closest = obj.Position
                end
            end
            if obj.Material == Enum.Material.Neon then
                local dist = (hrp.Position - obj.Position).Magnitude
                if dist < closestDist and dist > 2 then
                    closestDist = dist
                    closest = obj.Position
                end
            end
        end
        if obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("waypoint") or name:find("marker") or name:find("标点") or name:find("导航") or name:find("nav") or name:find("目标") then
                local primary = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("PrimaryPart")
                if primary and primary:IsA("BasePart") then
                    local dist = (hrp.Position - primary.Position).Magnitude
                    if dist < closestDist and dist > 2 then
                        closestDist = dist
                        closest = primary.Position
                    end
                end
            end
        end
    end
    
    return closest
end

Tab_Waypoint:Button({
    ["Title"] = "传送到地图标点",
    ["Desc"] = "自动检测地图上的标点并传送",
    ["Callback"] = function()
        local target = GetWaypointPosition()
        if target then
            TeleportTo(target)
            StarterGui:SetCore("SendNotification", {
                Title = "标点传送",
                Text = "已传送到标点位置",
                Duration = 2,
            })
        else
            StarterGui:SetCore("SendNotification", {
                Title = "标点传送",
                Text = "未找到地图标点",
                Duration = 2,
            })
        end
    end
})

local autoWaypointEnabled = false
local autoWaypointConnection = nil

local function AutoWaypoint()
    if not autoWaypointEnabled then return end
    local target = GetWaypointPosition()
    if target then
        TeleportTo(target)
    end
end

Tab_Waypoint:Toggle({
    ["Title"] = "自动传送标点",
    ["Desc"] = "自动检测标点并传送",
    ["Default"] = false,
    ["Callback"] = function(bool)
        autoWaypointEnabled = bool
        if bool then
            if autoWaypointConnection then autoWaypointConnection:Disconnect() end
            autoWaypointConnection = RunService.Heartbeat:Connect(function()
                if autoWaypointEnabled then
                    AutoWaypoint()
                end
            end)
        else
            if autoWaypointConnection then
                autoWaypointConnection:Disconnect()
                autoWaypointConnection = nil
            end
        end
    end
})

-------------------------------------------------------------------------
-- Tab: 甩飞
-------------------------------------------------------------------------
local Tab_Fling = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "甩飞",
    ["Icon"] = "rbxassetid://18520370419",
})

Tab_Fling:Section({
    TextSize = 17,
    ["Title"] = "甩飞功能",
    TextXAlignment = "Left",
})

Tab_Fling:Button({
    ["Title"] = "碰飞",
    ["Desc"] = "点击执行碰飞脚本",
    ["Callback"] = function()
        loadstring(game:HttpGet(('https://gist.githubusercontent.com/axelinharlem182/1ee425c9d850af697f8c3cb108a9d816/raw/c4660b01faf4db266e8031e310121a65836f98a7/The%2520Villain'),true))()
    end
})

local antiFlingEnabled = false
local antiFlingConnection = nil

Tab_Fling:Toggle({
    ["Title"] = "防甩飞",
    ["Desc"] = "防止自己被别人甩飞",
    ["Default"] = false,
    ["Callback"] = function(bool)
        antiFlingEnabled = bool
        if bool then
            if antiFlingConnection then
                antiFlingConnection:Disconnect()
                antiFlingConnection = nil
            end
            antiFlingConnection = RunService.Heartbeat:Connect(function()
                if not antiFlingEnabled then return end
                if not LocalPlayer.Character then return end
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                if hrp.AssemblyLinearVelocity.Magnitude > 100 then
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end
                
                for _, child in ipairs(hrp:GetChildren()) do
                    if child:IsA("BodyVelocity") or child:IsA("BodyAngularVelocity") or child:IsA("BodyForce") then
                        child:Destroy()
                    end
                end
            end)
        else
            if antiFlingConnection then
                antiFlingConnection:Disconnect()
                antiFlingConnection = nil
            end
        end
    end
})

local function SkidFling(TargetPlayer)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart
    if not Character or not Humanoid or not RootPart then return end
    
    local TCharacter = TargetPlayer.Character
    if not TCharacter then return end
    local TRootPart = TCharacter:FindFirstChild("HumanoidRootPart")
    if not TRootPart then return end
    
    RootPart.CFrame = CFrame.new(TRootPart.Position + Vector3.new(0, 1.5, 0))
    RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
    RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
    task.wait(0.05)
end

Tab_Fling:Button({
    ["Title"] = "甩飞所有人",
    ["Desc"] = "甩飞服务器内所有玩家",
    ["Callback"] = function()
        for _, x in next, Players:GetPlayers() do
            if x ~= LocalPlayer then
                SkidFling(x)
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

local rangeSizes = {10, 20, 30, 50, 70, 120, 300, 500, 999, 999999999}
for _, size in ipairs(rangeSizes) do
    Tab_Range:Button({
        ["Title"] = "范围" .. size,
        ["Desc"] = "设置碰撞箱大小为" .. size,
        ["Callback"] = function()
            updateRange(size)
        end
    })
end

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
        antiFlingEnabled = false
        autoWaypointEnabled = false
        if autoWaypointConnection then
            autoWaypointConnection:Disconnect()
            autoWaypointConnection = nil
        end
        if antiFlingConnection then
            antiFlingConnection:Disconnect()
            antiFlingConnection = nil
        end
        if espRenderConnection then
            espRenderConnection:Disconnect()
            espRenderConnection = nil
        end
        ClearESP()
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

local easterEggEnabled = false
local eggSound = nil
local eggVolumeConnection = nil
local eggPlaying = false

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
                local soundService = game:GetService("SoundService")
                soundService.Volume = 1
                soundService.RespectFilteringEnabled = false
            end)
            
            if eggVolumeConnection then
                eggVolumeConnection:Disconnect()
                eggVolumeConnection = nil
            end
            eggVolumeConnection = RunService.Heartbeat:Connect(function()
                if not easterEggEnabled then return end
                pcall(function()
                    game:GetService("SoundService").Volume = 1
                end)
            end)
            
            pcall(function()
                if eggSound then
                    eggSound:Destroy()
                    eggSound = nil
                end
                eggSound = Instance.new("Sound")
                eggSound.SoundId = "rbxassetid://1838556600"
                eggSound.Volume = 10
                eggSound.Looped = false
                eggSound.PlayOnRemove = false
                eggSound.Parent = CoreGui
                eggSound:Play()
                eggPlaying = true
                
                eggSound.Ended:Connect(function()
                    eggPlaying = false
                end)
            end)
            
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
                textLabel.Text = "你还想要彩蛋?赶紧去送货吧!"
                textLabel.TextScaled = true
                
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 8)
                corner.Parent = textLabel
            end)
            
        else
            pcall(function()
                if eggSound and eggPlaying then
                else
                    if eggSound then
                        eggSound:Destroy()
                        eggSound = nil
                    end
                end
                if eggVolumeConnection then
                    eggVolumeConnection:Disconnect()
                    eggVolumeConnection = nil
                end
                local soundService = game:GetService("SoundService")
                soundService.Volume = 0.5
            end)
            
            pcall(function()
                local eggGui = CoreGui:FindFirstChild("EasterEggGui")
                if eggGui then eggGui:Destroy() end
            end)
        end
    end
})

print("wdfex-圣奥里已加载")
print("标点传送已添加")