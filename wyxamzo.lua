-- ===== wdfex 圣奥里传送 (完整优化版) =====

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

-- ===== 卡密验证（三次机会，错三次自动退出） =====
local function PasswordVerify()
    local attempts = 0
    local maxAttempts = 3
    local verified = false
    
    while attempts < maxAttempts and not verified do
        local dialog = Instance.new("ScreenGui")
        dialog.Name = "PasswordDialog"
        dialog.Parent = CoreGui
        dialog.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 320, 0, 160)
        frame.Position = UDim2.new(0.5, -160, 0.5, -80)
        frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        frame.BackgroundTransparency = 0.1
        frame.BorderSizePixel = 2
        frame.BorderColor3 = Color3.fromRGB(100, 200, 255)
        frame.Parent = dialog
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = frame
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 40)
        title.Position = UDim2.new(0, 0, 0, 10)
        title.BackgroundTransparency = 1
        title.Text = "请输入开发者密码"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextSize = 20
        title.Font = Enum.Font.GothamBold
        title.Parent = frame
        
        local textBox = Instance.new("TextBox")
        textBox.Size = UDim2.new(0.8, 0, 0, 38)
        textBox.Position = UDim2.new(0.1, 0, 0, 55)
        textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        textBox.TextSize = 16
        textBox.Font = Enum.Font.Gotham
        textBox.PlaceholderText = "输入密码"
        textBox.ClearTextOnFocus = false
        textBox.Parent = frame
        
        local corner2 = Instance.new("UICorner")
        corner2.CornerRadius = UDim.new(0, 6)
        corner2.Parent = textBox
        
        local confirmBtn = Instance.new("TextButton")
        confirmBtn.Size = UDim2.new(0.4, 0, 0, 38)
        confirmBtn.Position = UDim2.new(0.3, 0, 0, 105)
        confirmBtn.BackgroundColor3 = Color3.fromRGB(60, 150, 255)
        confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        confirmBtn.TextSize = 16
        confirmBtn.Font = Enum.Font.GothamBold
        confirmBtn.Text = "确认"
        confirmBtn.Parent = frame
        
        local corner3 = Instance.new("UICorner")
        corner3.CornerRadius = UDim.new(0, 6)
        corner3.Parent = confirmBtn
        
        local result = false
        local dialogClosed = false
        
        confirmBtn.MouseButton1Click:Connect(function()
            if textBox.Text == "3948" then
                result = true
                verified = true
                dialog:Destroy()
                dialogClosed = true
            else
                attempts = attempts + 1
                local remain = maxAttempts - attempts
                if remain > 0 then
                    StarterGui:SetCore("SendNotification", {
                        Title = "密码错误",
                        Text = "还剩 " .. remain .. " 次机会",
                        Duration = 2,
                    })
                    textBox.Text = ""
                else
                    StarterGui:SetCore("SendNotification", {
                        Title = "验证失败",
                        Text = "密码错误次数过多，脚本将退出",
                        Duration = 3,
                    })
                    dialog:Destroy()
                    dialogClosed = true
                    return
                end
            end
        end)
        
        textBox.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                confirmBtn.MouseButton1Click:Fire()
            end
        end)
        
        repeat
            task.wait(0.1)
        until result or attempts >= maxAttempts or dialogClosed
        
        if not verified and attempts >= maxAttempts then
            return false
        end
    end
    
    return verified
end

local verified = PasswordVerify()
if not verified then
    return
end

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
-- Tab: 帧率
-------------------------------------------------------------------------
local Tab_FPS = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "帧率",
    ["Icon"] = "rbxassetid://18520370419",
})

Tab_FPS:Section({
    TextSize = 17,
    ["Title"] = "帧率优化",
    TextXAlignment = "Left",
})

local fpsLocked = false

Tab_FPS:Toggle({
    ["Title"] = "锁60帧",
    ["Desc"] = "将帧率锁定在60帧，保持流畅",
    ["Default"] = false,
    ["Callback"] = function(bool)
        fpsLocked = bool
        if bool then
            pcall(function()
                setfpscap(60)
            end)
        else
            pcall(function()
                setfpscap(0)
            end)
        end
    end
})

Tab_FPS:Toggle({
    ["Title"] = "性能模式",
    ["Desc"] = "降低画质提高帧率",
    ["Default"] = false,
    ["Callback"] = function(bool)
        if bool then
            pcall(function()
                Lighting.GlobalShadows = false
                Lighting.Technology = Enum.Technology.Compatibility
                Workspace.FallenPartsDestroyHeight = -500
            end)
        else
            pcall(function()
                Lighting.GlobalShadows = true
                Lighting.Technology = Enum.Technology.Future
                Workspace.FallenPartsDestroyHeight = -100
            end)
        end
    end
})

Tab_FPS:Button({
    ["Title"] = "优化游戏流畅度",
    ["Desc"] = "一键优化",
    ["Callback"] = function()
        pcall(function()
            setfpscap(60)
            Lighting.GlobalShadows = false
            Lighting.Technology = Enum.Technology.Compatibility
            Workspace.FallenPartsDestroyHeight = -500
        end)
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
-- Tab: 透视 (优化版)
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
local espUpdateTimer = 0
local espUpdateInterval = 0.15

local espShowName = false
local espShowHealth = false
local espShowBox = false
local espShowBone = false
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
    
    local showDetail = distance < 200
    local charSize = rootPart.Size
    local weapon = showDetail and GetPlayerWeapon(player) or ""
    local team = showDetail and GetPlayerTeam(player) or ""
    local scriptTag = showDetail and CheckPlayerScript(player) or nil
    
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
    billboard.Size = UDim2.new(0, 200, 0, 100)
    billboard.StudsOffset = Vector3.new(0, charSize.Y / 2 + 1.8, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = rootPart
    table.insert(espObjects, billboard)
    
    local yOffset = 0
    
    if espShowName then
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0, 18)
        nameLabel.Position = UDim2.new(0, 0, 0, yOffset)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player == LocalPlayer and (player.Name .. " (你)") or player.Name
        nameLabel.TextColor3 = player == LocalPlayer and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 13
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextStrokeTransparency = 0.3
        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLabel.Parent = billboard
        table.insert(espObjects, nameLabel)
        yOffset = yOffset + 20
    end
    
    if espShowTeam and showDetail then
        local teamLabel = Instance.new("TextLabel")
        teamLabel.Size = UDim2.new(1, 0, 0, 14)
        teamLabel.Position = UDim2.new(0, 0, 0, yOffset)
        teamLabel.BackgroundTransparency = 1
        teamLabel.Text = team
        teamLabel.TextColor3 = teamColor
        teamLabel.TextSize = 11
        teamLabel.Font = Enum.Font.GothamBold
        teamLabel.TextStrokeTransparency = 0.3
        teamLabel.Parent = billboard
        table.insert(espObjects, teamLabel)
        yOffset = yOffset + 16
    end
    
    if espShowScriptTag and scriptTag and showDetail then
        local tagColor = scriptTag == "皮脚本" and Color3.fromRGB(255, 100, 100) or 
                         scriptTag == "wdfex" and Color3.fromRGB(100, 180, 255) or 
                         Color3.fromRGB(200, 100, 255)
        local tagLabel = Instance.new("TextLabel")
        tagLabel.Size = UDim2.new(1, 0, 0, 14)
        tagLabel.Position = UDim2.new(0, 0, 0, yOffset)
        tagLabel.BackgroundTransparency = 1
        tagLabel.Text = scriptTag
        tagLabel.TextColor3 = tagColor
        tagLabel.TextSize = 11
        tagLabel.Font = Enum.Font.GothamBold
        tagLabel.TextStrokeTransparency = 0.3
        tagLabel.Parent = billboard
        table.insert(espObjects, tagLabel)
        yOffset = yOffset + 16
    end
    
    if espShowWeapon and showDetail then
        local weaponLabel = Instance.new("TextLabel")
        weaponLabel.Size = UDim2.new(1, 0, 0, 14)
        weaponLabel.Position = UDim2.new(0, 0, 0, yOffset)
        weaponLabel.BackgroundTransparency = 1
        weaponLabel.Text = weapon
        weaponLabel.TextColor3 = weapon == "赤手空拳" and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(255, 200, 100)
        weaponLabel.TextSize = 11
        weaponLabel.Font = Enum.Font.Gotham
        weaponLabel.TextStrokeTransparency = 0.3
        weaponLabel.Parent = billboard
        table.insert(espObjects, weaponLabel)
        yOffset = yOffset + 16
    end
    
    if espShowHealth then
        local healthBg = Instance.new("Frame")
        healthBg.Size = UDim2.new(0.7, 0, 0, 6)
        healthBg.Position = UDim2.new(0.15, 0, 0, yOffset)
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
        healthLabel.Size = UDim2.new(1, 0, 0, 14)
        healthLabel.Position = UDim2.new(0, 0, 0, yOffset + 8)
        healthLabel.BackgroundTransparency = 1
        healthLabel.Text = health .. "/" .. maxHealth
        healthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        healthLabel.TextSize = 10
        healthLabel.Font = Enum.Font.Gotham
        healthLabel.TextStrokeTransparency = 0.3
        healthLabel.Parent = billboard
        table.insert(espObjects, healthLabel)
        yOffset = yOffset + 26
    end
    
    if espShowDist and player ~= LocalPlayer and showDetail then
        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(1, 0, 0, 12)
        distLabel.Position = UDim2.new(0, 0, 0, yOffset)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = distance .. "m"
        distLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        distLabel.TextSize = 10
        distLabel.Font = Enum.Font.Gotham
        distLabel.Parent = billboard
        table.insert(espObjects, distLabel)
    end
    
    if espShowBox then
        local box = Instance.new("BoxHandleAdornment")
        box.Size = Vector3.new(3.5, 5.5, 1.8)
        box.Adornee = rootPart
        box.Color3 = Color3.fromRGB(0, 200, 255)
        box.Transparency = 0.4
        box.ZIndex = 0
        box.AlwaysOnTop = true
        box.Parent = rootPart
        table.insert(espObjects, box)
    end
    
    if espShowBone and showDetail then
        local boneParts = {"Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "RightUpperArm"}
        for _, boneName in ipairs(boneParts) do
            local part = character:FindFirstChild(boneName)
            if part and part:IsA("BasePart") then
                local sphere = Instance.new("SelectionBox")
                sphere.Adornee = part
                sphere.Color3 = Color3.fromRGB(0, 200, 255)
                sphere.LineThickness = 0.06
                sphere.Transparency = 0.2
                sphere.Parent = part
                table.insert(espObjects, sphere)
            end
        end
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
                    espUpdateTimer = espUpdateTimer + RunService.Heartbeat:Wait()
                    if espUpdateTimer >= espUpdateInterval then
                        espUpdateTimer = 0
                        if espMasterEnabled then UpdateESP() end
                    end
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
    ["Title"] = "绘制骨骼",
    ["Desc"] = "显示玩家骨骼点（简化版）",
    ["Default"] = false,
    ["Callback"] = function(bool)
        espShowBone = bool
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

-- 警察预警
local policeAlertEnabled = false
local policeAlertGui = nil
local policeAlertLabel = nil
local policeDistLabel = nil
local policeAlertConnection = nil
local policeCheckTimer = 0

local function CreatePoliceAlert()
    if policeAlertGui then
        policeAlertGui:Destroy()
        policeAlertGui = nil
    end
    
    policeAlertGui = Instance.new("ScreenGui")
    policeAlertGui.Name = "PoliceAlert"
    policeAlertGui.ResetOnSpawn = false
    policeAlertGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    policeAlertGui.Parent = CoreGui
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 350, 0, 80)
    bg.Position = UDim2.new(0.5, -175, 0, 20)
    bg.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    bg.BackgroundTransparency = 0.2
    bg.BorderSizePixel = 2
    bg.BorderColor3 = Color3.fromRGB(255, 0, 0)
    bg.Visible = false
    bg.Parent = policeAlertGui
    policeAlertLabel = bg
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = bg
    
    local warnText = Instance.new("TextLabel")
    warnText.Size = UDim2.new(1, 0, 0, 30)
    warnText.Position = UDim2.new(0, 0, 0, 5)
    warnText.BackgroundTransparency = 1
    warnText.Text = "警察来了！快跑！"
    warnText.TextColor3 = Color3.fromRGB(255, 255, 255)
    warnText.TextSize = 22
    warnText.Font = Enum.Font.GothamBold
    warnText.TextScaled = true
    warnText.Parent = bg
    
    local distText = Instance.new("TextLabel")
    distText.Size = UDim2.new(1, 0, 0, 25)
    distText.Position = UDim2.new(0, 0, 0, 40)
    distText.BackgroundTransparency = 1
    distText.Text = "距离: 0m"
    distText.TextColor3 = Color3.fromRGB(255, 255, 200)
    distText.TextSize = 16
    distText.Font = Enum.Font.GothamBold
    distText.Parent = bg
    policeDistLabel = distText
end

Tab_ESP:Toggle({
    ["Title"] = "警察靠近预警",
    ["Desc"] = "警察靠近时在屏幕上方显示警告",
    ["Default"] = false,
    ["Callback"] = function(bool)
        policeAlertEnabled = bool
        if bool then
            CreatePoliceAlert()
            if not policeAlertConnection then
                policeAlertConnection = RunService.Heartbeat:Connect(function()
                    policeCheckTimer = policeCheckTimer + RunService.Heartbeat:Wait()
                    if policeCheckTimer < 0.3 then return end
                    policeCheckTimer = 0
                    
                    if not policeAlertEnabled then return end
                    if not LocalPlayer.Character then return end
                    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                    
                    local closestPolice = nil
                    local closestDist = 1000
                    
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player == LocalPlayer then continue end
                        if not player.Character then continue end
                        local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
                        if not targetHrp then continue end
                        
                        local isPolice = false
                        if player.Team then
                            local teamName = player.Team.Name or ""
                            if teamName:find("警察") or teamName:find("Police") or teamName:find("Cop") then
                                isPolice = true
                            end
                        end
                        
                        if isPolice then
                            local dist = (hrp.Position - targetHrp.Position).Magnitude
                            if dist < closestDist then
                                closestDist = dist
                                closestPolice = player
                            end
                        end
                    end
                    
                    if closestPolice and closestDist < 50 then
                        policeAlertLabel.Visible = true
                        if policeDistLabel then
                            policeDistLabel.Text = "警察 " .. closestPolice.Name .. " 距离: " .. math.floor(closestDist) .. "m"
                        end
                    else
                        if policeAlertLabel then
                            policeAlertLabel.Visible = false
                        end
                    end
                end)
            end
        else
            if policeAlertGui then
                policeAlertGui:Destroy()
                policeAlertGui = nil
            end
            if policeAlertConnection then
                policeAlertConnection:Disconnect()
                policeAlertConnection = nil
            end
        end
    end
})

-------------------------------------------------------------------------
-- Tab: 甩飞 (附近一次 + 循环)
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

-- 甩飞附近的人（一次）
Tab_Fling:Button({
    ["Title"] = "甩飞附近的人",
    ["Desc"] = "甩飞距离你50米内的所有玩家（一次）",
    ["Callback"] = function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            local targetHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not targetHrp then continue end
            
            local dist = (hrp.Position - targetHrp.Position).Magnitude
            if dist <= 50 then
                local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.CFrame = CFrame.new(targetHrp.Position + Vector3.new(0, 1.5, 0))
                    rootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
                    rootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
                    task.wait(0.05)
                end
            end
        end
    end
})

-- 循环甩飞
local loopFlingEnabled = false
local loopFlingConnection = nil
local loopFlingRadius = 50

Tab_Fling:Toggle({
    ["Title"] = "循环甩飞",
    ["Desc"] = "持续甩飞距离你50米内的所有玩家",
    ["Default"] = false,
    ["Callback"] = function(bool)
        loopFlingEnabled = bool
        if bool then
            if loopFlingConnection then
                loopFlingConnection:Disconnect()
                loopFlingConnection = nil
            end
            loopFlingConnection = RunService.Heartbeat:Connect(function()
                if not loopFlingEnabled then return end
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                for _, player in ipairs(Players:GetPlayers()) do
                    if player == LocalPlayer then continue end
                    local targetHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if not targetHrp then continue end
                    
                    local dist = (hrp.Position - targetHrp.Position).Magnitude
                    if dist <= loopFlingRadius then
                        local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if rootPart then
                            rootPart.CFrame = CFrame.new(targetHrp.Position + Vector3.new(0, 1.5, 0))
                            rootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
                            rootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
                        end
                    end
                end
                task.wait(0.1)
            end)
        else
            if loopFlingConnection then
                loopFlingConnection:Disconnect()
                loopFlingConnection = nil
            end
        end
    end
})

-- 防甩飞
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

-------------------------------------------------------------------------
-- Tab: 范围 (优化版)
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
_G.RangeTimer = 0

local function updateRange(size)
    if _G.RangeConn then
        _G.RangeConn:Disconnect()
        _G.RangeConn = nil
    end
    if size == 0 then
        _G.Disabled = false
        return
    end
    _G.HeadSize = size
    _G.Disabled = true
    _G.RangeTimer = 0
    _G.RangeConn = RunService.Heartbeat:Connect(function()
        _G.RangeTimer = _G.RangeTimer + RunService.Heartbeat:Wait()
        if _G.RangeTimer < 0.1 then return end
        _G.RangeTimer = 0
        if _G.Disabled then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer then
                    pcall(function()
                        if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                            v.Character.HumanoidRootPart.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                            v.Character.HumanoidRootPart.Transparency = 0.7
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
        if antiFlingConnection then
            antiFlingConnection:Disconnect()
            antiFlingConnection = nil
        end
        loopFlingEnabled = false
        if loopFlingConnection then
            loopFlingConnection:Disconnect()
            loopFlingConnection = nil
        end
        if policeAlertGui then
            policeAlertGui:Destroy()
            policeAlertGui = nil
        end
        if policeAlertConnection then
            policeAlertConnection:Disconnect()
            policeAlertConnection = nil
        end
        if _G.RangeConn then
            _G.RangeConn:Disconnect()
            _G.RangeConn = nil
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
                textLabel.Text = "你还想要彩蛋?赶紧去送货吧!"
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

print("wdfex-圣奥里已加载 (完整优化版)")
print("共26个传送点 + 透视 + 范围 + 自瞄 + 通用 + 售货机 + 帧率优化 + 警察预警 + 甩飞(附近/循环) + 彩色边框 + 欢迎弹窗 + 卡密验证")