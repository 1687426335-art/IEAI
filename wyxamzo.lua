-- ===== wdfex-Hub =====

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
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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

-- ===== 加载 UI 库 =====
local UI_Library_URL = "https://raw.githubusercontent.com/114514lzkill/ui/refs/heads/main/ui.lua"
local Library = loadstring(game:HttpGet(UI_Library_URL))()

if not Library then
    UI_Library_URL = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/UI.Lua"
    Library = loadstring(game:HttpGet(UI_Library_URL))()
end

local Window = Library:CreateWindow({
    ["Folder"] = "wdfexHub",
    ["Title"] = "wdfex-Hub",
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

task.spawn(function()
    task.wait(0.8)
    CreateColorfulBorder()
end)

-- ===== 传送函数 =====
local function TeleportTo(pos)
    pcall(function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(pos)
        end
    end)
end

-- ===== 坐标列表 =====
local Locations = {
    ["军械库"] = Vector3.new(671.68688964844, 6.2448601722717, -655.50268554688),
    ["银行"] = Vector3.new(1091.5296630859, 6.0434188842773, -457.62033081055),
    ["珠宝店"] = Vector3.new(1543.3168945312, 6.2433180809021, -682.63525390625),
    ["警察局"] = Vector3.new(655.10638427734, 9.035834312439, -903.20697021484),
    ["军事基地"] = Vector3.new(835.84875488281, 25.234800338745, -1327.0417480469),
    ["医院"] = Vector3.new(1112.4508056641, 6.0434203147888, -973.91772460938),
    ["游乐场"] = Vector3.new(1170.8796386719, 13.850684165955, -25.795112609863)
}

-- ===== 获取俄亥俄州 Remotes =====
local Remotes, Inventory
pcall(function()
    local RemotesModule = require(ReplicatedStorage.devv.client.Helpers.remotes.Signal)
    Remotes = debug.getupvalue(RemotesModule.FireServer, 1)
    Inventory = require(ReplicatedStorage.devv.client.Objects.v3item.modules.inventory)
end)

-------------------------------------------------------------------------
-- Tab: 战斗
-------------------------------------------------------------------------
local Tab_Combat = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "战斗",
    ["Icon"] = "rbxassetid://18520370419",
})

Tab_Combat:Section({
    TextSize = 17,
    ["Title"] = "战斗功能",
    TextXAlignment = "Left",
})

Tab_Combat:Toggle({
    ["Title"] = "一拳秒杀",
    ["Desc"] = "拳头攻击秒杀敌人",
    ["Default"] = false,
    ["Callback"] = function(bool)
        _G.OnePunch = bool
    end
})

Tab_Combat:Toggle({
    ["Title"] = "近战秒杀",
    ["Desc"] = "所有近战武器秒杀",
    ["Default"] = false,
    ["Callback"] = function(bool)
        _G.OneSwing = bool
    end
})

Tab_Combat:Toggle({
    ["Title"] = "杀戮光环",
    ["Desc"] = "自动攻击周围敌人",
    ["Default"] = false,
    ["Callback"] = function(bool)
        _G.KillAura = bool
        if bool and Remotes then
            pcall(function()
                Remotes.FireServer("equip", Inventory.getFromName("Fists").guid)
            end)
        end
    end
})

Tab_Combat:Toggle({
    ["Title"] = "踩人光环",
    ["Desc"] = "自动踩倒地的敌人",
    ["Default"] = false,
    ["Callback"] = function(bool)
        _G.StompAura = bool
    end
})

Tab_Combat:Toggle({
    ["Title"] = "抓人光环",
    ["Desc"] = "自动抓倒地的敌人",
    ["Default"] = false,
    ["Callback"] = function(bool)
        _G.GrabAura = bool
    end
})

Tab_Combat:Toggle({
    ["Title"] = "防倒地",
    ["Desc"] = "不会倒地",
    ["Default"] = false,
    ["Callback"] = function(bool)
        _G.Godmode = bool
    end
})

Tab_Combat:Toggle({
    ["Title"] = "RPG全图轰炸",
    ["Desc"] = "使用RPG轰炸全图",
    ["Default"] = false,
    ["Callback"] = function(bool)
        _G.RPGBomb = bool
    end
})

Tab_Combat:Toggle({
    ["Title"] = "自动穿甲",
    ["Desc"] = "自动购买并穿上护甲",
    ["Default"] = false,
    ["Callback"] = function(bool)
        _G.AutoArmor = bool
    end
})

Tab_Combat:Section({
    TextSize = 17,
    ["Title"] = "━━━━━━━━━━━━━━━━━━━━",
    TextXAlignment = "Left",
})

Tab_Combat:Toggle({
    ["Title"] = "子弹范围开关",
    ["Desc"] = "修改敌人模型大小",
    ["Default"] = false,
    ["Callback"] = function(bool)
        _G.HitboxEnabled = bool
    end
})

Tab_Combat:Slider({
    ["Title"] = "子弹范围大小",
    ["Step"] = 1,
    ["Value"] = { Min = 1, Default = 15, Max = 50 },
    ["Callback"] = function(Value)
        local size = type(Value) == "table" and Value[1] or Value
        _G.HitboxSize = size
    end
})

-------------------------------------------------------------------------
-- Tab: 物品
-------------------------------------------------------------------------
local Tab_Items = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "物品",
    ["Icon"] = "rbxassetid://18520370419",
})

Tab_Items:Section({
    TextSize = 17,
    ["Title"] = "购买物品",
    TextXAlignment = "Left",
})

Tab_Items:Button({
    ["Title"] = "购买拳头",
    ["Desc"] = "购买拳头",
    ["Callback"] = function()
        if Remotes then
            pcall(function()
                Remotes.InvokeServer("attemptPurchase", "Fists")
            end)
        end
    end
})

Tab_Items:Button({
    ["Title"] = "购买RPG",
    ["Desc"] = "购买RPG火箭筒",
    ["Callback"] = function()
        if Remotes then
            pcall(function()
                Remotes.InvokeServer("attemptPurchase", "RPG")
            end)
        end
    end
})

Tab_Items:Button({
    ["Title"] = "购买手枪",
    ["Desc"] = "购买手枪",
    ["Callback"] = function()
        if Remotes then
            pcall(function()
                Remotes.InvokeServer("attemptPurchase", "Pistol")
            end)
        end
    end
})

Tab_Items:Button({
    ["Title"] = "购买步枪",
    ["Desc"] = "购买步枪",
    ["Callback"] = function()
        if Remotes then
            pcall(function()
                Remotes.InvokeServer("attemptPurchase", "Rifle")
            end)
        end
    end
})

Tab_Items:Button({
    ["Title"] = "购买霰弹枪",
    ["Desc"] = "购买霰弹枪",
    ["Callback"] = function()
        if Remotes then
            pcall(function()
                Remotes.InvokeServer("attemptPurchase", "Shotgun")
            end)
        end
    end
})

Tab_Items:Button({
    ["Title"] = "购买狙击枪",
    ["Desc"] = "购买狙击枪",
    ["Callback"] = function()
        if Remotes then
            pcall(function()
                Remotes.InvokeServer("attemptPurchase", "Sniper")
            end)
        end
    end
})

Tab_Items:Button({
    ["Title"] = "购买轻甲",
    ["Desc"] = "购买轻型护甲",
    ["Callback"] = function()
        if Remotes then
            pcall(function()
                Remotes.InvokeServer("attemptPurchase", "Light Vest")
            end)
        end
    end
})

Tab_Items:Button({
    ["Title"] = "购买重甲",
    ["Desc"] = "购买重型护甲",
    ["Callback"] = function()
        if Remotes then
            pcall(function()
                Remotes.InvokeServer("attemptPurchase", "Heavy Vest")
            end)
        end
    end
})

Tab_Items:Section({
    TextSize = 17,
    ["Title"] = "━━━━━━━━━━━━━━━━━━━━",
    TextXAlignment = "Left",
})

Tab_Items:Toggle({
    ["Title"] = "远程黑市",
    ["Desc"] = "远距离使用黑市",
    ["Default"] = false,
    ["Callback"] = function(bool)
        pcall(function()
            workspace.BlackMarket.Dealer.Dealer.ProximityPrompt.MaxActivationDistance = bool and 10000 or 20
        end)
    end
})

Tab_Items:Toggle({
    ["Title"] = "快速互动",
    ["Desc"] = "快速触发互动提示",
    ["Default"] = false,
    ["Callback"] = function(bool)
        if bool then
            _G.FastInteractConn = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
                fireproximityprompt(prompt)
            end)
        else
            if _G.FastInteractConn then
                _G.FastInteractConn:Disconnect()
                _G.FastInteractConn = nil
            end
        end
    end
})

-------------------------------------------------------------------------
-- Tab: 自动
-------------------------------------------------------------------------
local Tab_Auto = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "自动",
    ["Icon"] = "rbxassetid://18520370419",
})

Tab_Auto:Section({
    TextSize = 17,
    ["Title"] = "自动功能",
    TextXAlignment = "Left",
})

Tab_Auto:Toggle({
    ["Title"] = "自动打ATM",
    ["Desc"] = "自动攻击ATM取钱",
    ["Default"] = false,
    ["Callback"] = function(bool)
        _G.ATMFarm = bool
    end
})

Tab_Auto:Toggle({
    ["Title"] = "自动打收银机",
    ["Desc"] = "自动攻击收银机取钱",
    ["Default"] = false,
    ["Callback"] = function(bool)
        _G.RegisterFarm = bool
    end
})

Tab_Auto:Toggle({
    ["Title"] = "自动抢银行",
    ["Desc"] = "自动完成银行抢劫",
    ["Default"] = false,
    ["Callback"] = function(bool)
        _G.AutoRobBank = bool
    end
})

Tab_Auto:Toggle({
    ["Title"] = "自动捡钱",
    ["Desc"] = "自动捡取地上的钱",
    ["Default"] = false,
    ["Callback"] = function(bool)
        _G.CashFarm = bool
    end
})

Tab_Auto:Toggle({
    ["Title"] = "捡钱光环",
    ["Desc"] = "自动吸取周围的钱",
    ["Default"] = false,
    ["Callback"] = function(bool)
        _G.CashAura = bool
    end
})

Tab_Auto:Toggle({
    ["Title"] = "自动捡物品",
    ["Desc"] = "自动捡取地上的物品",
    ["Default"] = false,
    ["Callback"] = function(bool)
        _G.ItemFarm = bool
    end
})

Tab_Auto:Toggle({
    ["Title"] = "捡物品光环",
    ["Desc"] = "自动吸取周围物品",
    ["Default"] = false,
    ["Callback"] = function(bool)
        _G.ItemAura = bool
    end
})

Tab_Auto:Section({
    TextSize = 17,
    ["Title"] = "━━━━━━━━━━━━━━━━━━━━",
    TextXAlignment = "Left",
})

Tab_Auto:Toggle({
    ["Title"] = "空投刷新提示",
    ["Desc"] = "空投刷新时提示",
    ["Default"] = false,
    ["Callback"] = function(bool)
        _G.NotifyAirdrop = bool
    end
})

-------------------------------------------------------------------------
-- Tab: 传送
-------------------------------------------------------------------------
local Tab_Teleport = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "传送",
    ["Icon"] = "rbxassetid://18520370419",
})

Tab_Teleport:Section({
    TextSize = 17,
    ["Title"] = "地点传送",
    TextXAlignment = "Left",
})

Tab_Teleport:Button({
    ["Title"] = "军械库",
    ["Desc"] = "传送到军械库",
    ["Callback"] = function()
        TeleportTo(Locations["军械库"])
    end
})

Tab_Teleport:Button({
    ["Title"] = "银行",
    ["Desc"] = "传送到银行",
    ["Callback"] = function()
        TeleportTo(Locations["银行"])
    end
})

Tab_Teleport:Button({
    ["Title"] = "珠宝店",
    ["Desc"] = "传送到珠宝店",
    ["Callback"] = function()
        TeleportTo(Locations["珠宝店"])
    end
})

Tab_Teleport:Button({
    ["Title"] = "警察局",
    ["Desc"] = "传送到警察局",
    ["Callback"] = function()
        TeleportTo(Locations["警察局"])
    end
})

Tab_Teleport:Button({
    ["Title"] = "军事基地",
    ["Desc"] = "传送到军事基地",
    ["Callback"] = function()
        TeleportTo(Locations["军事基地"])
    end
})

Tab_Teleport:Button({
    ["Title"] = "医院",
    ["Desc"] = "传送到医院",
    ["Callback"] = function()
        TeleportTo(Locations["医院"])
    end
})

Tab_Teleport:Button({
    ["Title"] = "游乐场",
    ["Desc"] = "传送到游乐场",
    ["Callback"] = function()
        TeleportTo(Locations["游乐场"])
    end
})

-------------------------------------------------------------------------
-- Tab: 娱乐
-------------------------------------------------------------------------
local Tab_Fun = Window:Tab({
    ["Locked"] = false,
    ["Title"] = "娱乐",
    ["Icon"] = "rbxassetid://18520370419",
})

Tab_Fun:Section({
    TextSize = 17,
    ["Title"] = "娱乐功能",
    TextXAlignment = "Left",
})

local FunTarget = nil
local SpamMessage = "wdfex-Hub"

Tab_Fun:Input({
    ["Title"] = "输入目标名称",
    ["Desc"] = "输入玩家名称",
    ["Callback"] = function(Value)
        local query = Value:gsub("%s+", "")
        for _, player in pairs(Players:GetPlayers()) do
            if player.Name:lower():match("^" .. query:lower()) then
                FunTarget = player
                break
            end
            if player.DisplayName:lower():match("^" .. query:lower()) then
                FunTarget = player
                break
            end
        end
    end
})

Tab_Fun:Input({
    ["Title"] = "轰炸消息",
    ["Desc"] = "输入要发送的消息",
    ["Callback"] = function(Value)
        SpamMessage = Value
    end
})

Tab_Fun:Toggle({
    ["Title"] = "消息轰炸",
    ["Desc"] = "向目标发送消息轰炸",
    ["Default"] = false,
    ["Callback"] = function(bool)
        _G.SpamPlayer = bool
    end
})

Tab_Fun:Toggle({
    ["Title"] = "电话骚扰",
    ["Desc"] = "向目标打电话骚扰",
    ["Default"] = false,
    ["Callback"] = function(bool)
        _G.SpamCall = bool
    end
})

Tab_Fun:Toggle({
    ["Title"] = "全体消息轰炸",
    ["Desc"] = "向所有玩家发送消息轰炸",
    ["Default"] = false,
    ["Callback"] = function(bool)
        _G.SpamAll = bool
    end
})

-------------------------------------------------------------------------
-- 后台运行循环
-------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            -- 杀戮光环
            if _G.KillAura and Remotes then
                for _, player in pairs(Players:GetPlayers()) do
                    if player == LocalPlayer then continue end
                    local pchar = player.Character
                    if not pchar then continue end
                    local hum = pchar:FindFirstChildOfClass("Humanoid")
                    local phrp = pchar:FindFirstChild("HumanoidRootPart")
                    if not hum or not phrp then continue end
                    if pchar:FindFirstChild("ForceField") then continue end
                    if hum.Health <= 5 then continue end
                    local dist = (hrp.Position - phrp.Position).Magnitude
                    if dist < 35 then
                        pcall(function()
                            Remotes.FireServer("meleeItemHit", "player", {
                                meleeType = "meleemegapunch",
                                hitPlayerId = player.UserId
                            })
                        end)
                    end
                end
            end
            
            -- 防倒地
            if _G.Godmode then
                pcall(function()
                    local ClientReplicator = require(ReplicatedStorage.devv.client.Helpers.objectProperties.ClientReplicator)
                    if ClientReplicator.Get(LocalPlayer, "knocked") then
                        ClientReplicator.Set(LocalPlayer, "knocked", false)
                    end
                end)
            end
            
            -- 踩人光环
            if _G.StompAura and Remotes then
                pcall(function()
                    local ClientReplicator = require(ReplicatedStorage.devv.client.Helpers.objectProperties.ClientReplicator)
                    for _, player in pairs(Players:GetPlayers()) do
                        if player == LocalPlayer then continue end
                        if ClientReplicator.Get(player, "knocked") then
                            local pchar = player.Character
                            if pchar and pchar:FindFirstChild("HumanoidRootPart") then
                                local dist = (hrp.Position - pchar.HumanoidRootPart.Position).Magnitude
                                if dist < 30 then
                                    Remotes.FireServer("stomp", player)
                                end
                            end
                        end
                    end
                end)
            end
            
            -- 抓人光环
            if _G.GrabAura and Remotes then
                pcall(function()
                    local ClientReplicator = require(ReplicatedStorage.devv.client.Helpers.objectProperties.ClientReplicator)
                    for _, player in pairs(Players:GetPlayers()) do
                        if player == LocalPlayer then continue end
                        if ClientReplicator.Get(player, "knocked") then
                            local pchar = player.Character
                            if pchar and pchar:FindFirstChild("HumanoidRootPart") then
                                local dist = (hrp.Position - pchar.HumanoidRootPart.Position).Magnitude
                                if dist < 35 then
                                    Remotes.FireServer("grabPlayer", player)
                                end
                            end
                        end
                    end
                end)
            end
            
            -- 子弹范围
            if _G.HitboxEnabled then
                local size = _G.HitboxSize or 15
                for _, player in pairs(Players:GetPlayers()) do
                    pcall(function()
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            player.Character.HumanoidRootPart.Size = Vector3.new(size, size, size)
                            player.Character.HumanoidRootPart.Transparency = 0.8
                            player.Character.HumanoidRootPart.Color = Color3.fromRGB(0, 0, 0)
                            player.Character.HumanoidRootPart.Material = "Neon"
                            player.Character.HumanoidRootPart.CanCollide = false
                        end
                    end)
                end
            else
                for _, player in pairs(Players:GetPlayers()) do
                    pcall(function()
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            player.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                            player.Character.HumanoidRootPart.Transparency = 1
                            player.Character.HumanoidRootPart.Color = Color3.fromRGB(163, 162, 165)
                            player.Character.HumanoidRootPart.Material = "Plastic"
                            player.Character.HumanoidRootPart.CanCollide = false
                        end
                    end)
                end
            end
            
            -- RPG全图轰炸
            if _G.RPGBomb and Remotes then
                local item = Inventory.getEquippedItem()
                if item and item.name == "RPG" then
                    for _, player in pairs(Players:GetPlayers()) do
                        if player == LocalPlayer then continue end
                        local pchar = player.Character
                        if not pchar then continue end
                        local hum = pchar:FindFirstChildOfClass("Humanoid")
                        if not hum or hum.Health <= 10 then continue end
                        if pchar:FindFirstChild("ForceField") then continue end
                        pcall(function()
                            Remotes.FireServer("rocketHit", "AmmoGuid", "explosionGUID", pchar.HumanoidRootPart.Position)
                        end)
                    end
                end
                task.wait(0.3)
            end
            
            -- 自动穿甲
            if _G.AutoArmor and Remotes then
                pcall(function()
                    local armor = LocalPlayer:GetAttribute("armor")
                    if not armor or armor <= 0 then
                        Remotes.InvokeServer("attemptPurchase", "Light Vest")
                        local guid = Inventory.getFromName("Light Vest").guid
                        Remotes.FireServer("equip", guid)
                        Remotes.FireServer("useConsumable", guid)
                        Remotes.FireServer("removeItem", guid)
                    end
                end)
            end
            
            -- ATM自动刷
            if _G.ATMFarm and Remotes then
                for _, atm in pairs(workspace.Game.Props.ATM:GetChildren()) do
                    if atm:GetAttribute("state") ~= "destroyed" then
                        char:PivotTo(atm:GetPivot())
                        task.wait(0.1)
                        Remotes.FireServer("meleeItemHit", "prop", {
                            meleeType = "meleepunch",
                            guid = atm:GetAttribute("guid")
                        })
                    end
                end
            end
            
            -- 收银机自动刷
            if _G.RegisterFarm and Remotes then
                for _, reg in pairs(workspace.Game.Props.CashRegister:GetChildren()) do
                    if reg:GetAttribute("state") ~= "destroyed" then
                        char:PivotTo(reg:GetPivot())
                        task.wait(0.1)
                        Remotes.FireServer("meleeItemHit", "prop", {
                            meleeType = "meleepunch",
                            guid = reg:GetAttribute("guid")
                        })
                    end
                end
            end
            
            -- 自动抢银行
            if _G.AutoRobBank then
                pcall(function()
                    local cash = workspace.BankRobbery.BankCash.Cash
                    if #cash:GetChildren() ~= 0 then
                        hrp.CFrame = workspace.BankRobbery.VaultDoor.Door.CFrame
                        fireproximityprompt(workspace.BankRobbery.VaultDoor.Door.Attachment.ProximityPrompt)
                        task.wait(0.5)
                        hrp.CFrame = workspace.BankRobbery.BankCash.Pallet.CFrame
                        fireproximityprompt(workspace.BankRobbery.BankCash.Main.Attachment.ProximityPrompt)
                    end
                end)
            end
            
            -- 自动捡钱
            if _G.CashFarm then
                for _, bundle in pairs(workspace.Game.Entities.CashBundle:GetChildren()) do
                    local cd = bundle:FindFirstChildOfClass("ClickDetector")
                    if cd then
                        char:PivotTo(bundle:GetPivot())
                        task.wait(0.1)
                        fireclickdetector(cd)
                        task.wait(0.5)
                    end
                end
            end
            
            -- 捡钱光环
            if _G.CashAura then
                for _, bundle in pairs(workspace.Game.Entities.CashBundle:GetChildren()) do
                    local cd = bundle:FindFirstChildOfClass("ClickDetector")
                    if cd and (hrp.Position - bundle:GetPivot().Position).Magnitude <= cd.MaxActivationDistance then
                        fireclickdetector(cd)
                    end
                end
            end
            
            -- 自动捡物品
            if _G.ItemFarm then
                for _, item in pairs(workspace.Game.Entities.ItemPickup:GetChildren()) do
                    local cd = item:FindFirstChildWhichIsA("ClickDetector", true)
                    if cd then
                        char:PivotTo(cd.Parent.CFrame)
                        task.wait(0.1)
                        fireclickdetector(cd)
                        task.wait(0.5)
                    end
                end
            end
            
            -- 捡物品光环
            if _G.ItemAura then
                for _, item in pairs(workspace.Game.Entities.ItemPickup:GetChildren()) do
                    pcall(function()
                        local cd = item:FindFirstChildWhichIsA("ClickDetector", true)
                        if cd and (hrp.Position - item:GetPivot().Position).Magnitude <= cd.MaxActivationDistance then
                            fireclickdetector(cd)
                        end
                    end)
                end
            end
            
            -- 消息轰炸
            if _G.SpamPlayer and Remotes and FunTarget then
                Remotes.FireServer("sendMessage", FunTarget.UserId, SpamMessage)
                task.wait(0.2)
            end
            
            -- 电话骚扰
            if _G.SpamCall and Remotes and FunTarget then
                Remotes.InvokeServer("attemptCall", FunTarget.UserId)
                task.wait(0.2)
            end
            
            -- 全体消息轰炸
            if _G.SpamAll and Remotes then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer then
                        Remotes.FireServer("sendMessage", player.UserId, SpamMessage)
                        task.wait(0.1)
                    end
                end
                task.wait(0.2)
            end
        end)
    end
end)

print("wdfex-Hub 已加载")