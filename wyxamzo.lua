local Env = getfenv()

local LogService = game:GetService("LogService")
local getconnections = Env.getconnections
local MessageOut = "MessageOut"
local cons = getconnections(LogService[MessageOut])
if cons then
    for _, v in pairs(cons) do
        pcall(function() v:Disable() end)
    end
end

local function cleanupConnections()
    pcall(function()
        
        for _, conn in ipairs(getconnections(LogService.MessageOut) or {}) do
            pcall(function() conn:Disable() end)
        end
    end)
end
cleanupConnections()

print("环境净化完成，LogService 干扰已禁用")

local WindUI

do
    local ok, result = pcall(function()
        return require("./src/Init")
    end)

    if ok then
        WindUI = result
    else 
        WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
    end
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local function createUI()
    local Window = WindUI:CreateWindow({
        Title = "<font color='#FFFFFF'>w</font><font color='#CCCCCC'>d</font><font color='#999999'>f</font><font color='#666666'>e</font><font color='#444444'>x</font> <font color='#666666'>圣</font><font color='#444444'>奥</font><font color='#222222'>里</font>",
        Folder = "wdfexHub",
        NewElements = true,
        HideSearchBar = false,
        Size = UDim2.fromOffset(600, 450),
        Theme = "Dark",  
        UserEnabled = true,
        SideBarWidth = 135,
        HasOutline = true,
        Background = "video:https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/extracted_1_3.mp4",
        
        OpenButton = {
            Title = "<font color='#FFFFFF'>w</font><font color='#CCCCCC'>d</font><font color='#999999'>f</font><font color='#666666'>e</font><font color='#444444'>x</font> <font color='#666666'>圣</font><font color='#444444'>奥</font><font color='#222222'>里</font>",
            CornerRadius = UDim.new(1,0),
            StrokeThickness = 1.5,
            Enabled = true,
            Draggable = true,
            OnlyMobile = false,
            Color = ColorSequence.new(
                Color3.fromHex("FFFFFF"), 
                Color3.fromHex("FFFFFF")
            )
        },
        Topbar = {
            Height = 44,
            ButtonsType = "Mac",
        }
    })
    
AddSnowEffect(Window.UIElements.Main.Background, 30, 14, 0.5)

    Window:Tag({
    Title = "wdfex",
    Radius = 10,
    Color = Color3.fromHex("#ffffff"),
})

Window:Tag({
    Title = "wdfex圣奥里",
    Radius = 10,
    Color = Color3.fromHex("#ffffff"),
})

    local White = Color3.fromHex("#FFFFFF")
    local LightGray = Color3.fromHex("#CCCCCC")
    local Gray = Color3.fromHex("#999999")
    local DarkGray = Color3.fromHex("#666666")
    local AlmostBlack = Color3.fromHex("#333333")

    local AboutTab = Window:Tab({
        Title = "公告",
        Desc = "脚本信息", 
        Icon = "solar:info-square-bold",
        IconColor = Gray,
        IconShape = "Square",
        Border = true,
    })

AboutTab:Paragraph({
    Title = "wdfex圣奥里",
    Desc = [[
本脚本严禁外传发现永久拉黑无法使用此脚本
作者: wdfex
QQ: 1687426335
    ]],
    BackgroundColor3 = Color3.fromHex("#FFFFFF"),
    BackgroundTransparency = 0,
    Color = Color3.fromHex("#000000"),
    OutlineColor = Color3.fromHex("#CCCCCC"),
    OutlineThickness = 1
})

AboutTab:Keybind({
    Flag = "KeybindTest",
    Title = "快捷键",
    Desc = "打开UI的快捷键",
    Value = "G",
    Callback = function(v) 
        Window:SetToggleKey(Enum.KeyCode[v]) 
    end
})

    AboutTab:Divider()

-------------------------------------------------------------------------
-- Tab: 通用
-------------------------------------------------------------------------
local GeneralTab = Window:Tab({
    Title = "通用",
    Desc = "通用功能",
    Icon = "solar:code-square-bold",
    IconColor = Gray,
    IconShape = "Square",
    Border = true,
})

local GeneralSection = GeneralTab:Section({
    Title = "通用功能",
    Description = "反挂机、速度、跳跃等"
})

GeneralSection:Button({
    Title = "反挂机",
    Description = "防止被踢出",
    Icon = "shield",
    Callback = function()
        print("反挂机已开启")
        LocalPlayer.Idled:Connect(function()
            game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), Camera.CFrame)
            task.wait(1)
            game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), Camera.CFrame)
        end)
        WindUI:Notify({
            Title = "反挂机",
            Content = "已开启",
            Duration = 3
        })
    end
})

GeneralSection:Slider({
    Title = "速度设置",
    Min = 16,
    Max = 1000,
    Default = 16,
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

GeneralSection:Slider({
    Title = "跳跃设置",
    Min = 50,
    Max = 200,
    Default = 50,
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = Value
        end
    end
})

GeneralSection:Button({
    Title = "帧率显示",
    Description = "显示FPS",
    Icon = "eye",
    Callback = function()
        if LocalPlayer.PlayerGui:FindFirstChild("FPSGui") then return end
        
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "FPSGui"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Name = "FPSLabel"
        TextLabel.Size = UDim2.new(0, 100, 0, 50)
        TextLabel.Position = UDim2.new(0, 10, 0, 10)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Font = Enum.Font.SourceSansBold
        TextLabel.Text = "FPS: 0"
        TextLabel.TextSize = 20
        TextLabel.TextColor3 = Color3.new(1, 1, 1)
        TextLabel.Parent = ScreenGui
        
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        
        RunService.RenderStepped:Connect(function()
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            TextLabel.Text = "FPS: " .. fps
        end)
    end
})

GeneralSection:Button({
    Title = "时间显示",
    Description = "显示北京时间",
    Icon = "clock",
    Callback = function()
        if game.CoreGui:FindFirstChild("LBLG") then return end

        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "LBLG"
        ScreenGui.Parent = game.CoreGui
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Name = "LBL"
        TextLabel.Parent = ScreenGui
        TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
        TextLabel.BackgroundTransparency = 1
        TextLabel.BorderColor3 = Color3.new(0, 0, 0)
        TextLabel.Position = UDim2.new(0.75, 0, 0.01, 0)
        TextLabel.Size = UDim2.new(0, 133, 0, 30)
        TextLabel.Font = Enum.Font.GothamSemibold
        TextLabel.TextColor3 = Color3.new(1, 1, 1)
        TextLabel.TextScaled = true
        TextLabel.TextSize = 14
        TextLabel.TextWrapped = true
        
        RunService.Heartbeat:Connect(function()
            local currentTime = os.date("%H时%M分%S秒")
            TextLabel.Text = "北京时间:" .. currentTime
        end)
    end
})

GeneralSection:Button({
    Title = "重开",
    Description = "重新开始",
    Icon = "refresh-cw",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.Health = 0
        end
    end
})

GeneralSection:Toggle({
    Title = "防摔",
    Description = "从高处掉落时一下快一下慢",
    Default = false,
    Callback = function(bool)
        if bool then
            local function onCharacterAdded(char)
                local hrp = char:WaitForChild("HumanoidRootPart")
                local humanoid = char:WaitForChild("Humanoid")
                
                local falling = false
                local timer = 0
                
                local connection
                connection = RunService.Heartbeat:Connect(function()
                    if not bool then
                        connection:Disconnect()
                        return
                    end
                    if not hrp or not hrp.Parent then return end
                    
                    local velocity = hrp.AssemblyLinearVelocity
                    
                    if velocity.Y < -5 and humanoid:GetState() ~= Enum.HumanoidStateType.Climbing and humanoid:GetState() ~= Enum.HumanoidStateType.Swimming then
                        falling = true
                    else
                        falling = false
                        timer = 0
                    end
                    
                    if falling then
                        timer = timer + 1
                        local speed
                        if timer % 6 < 3 then
                            speed = -25
                        else
                            speed = -5
                        end
                        local newVel = Vector3.new(velocity.X, speed, velocity.Z)
                        hrp.AssemblyLinearVelocity = newVel
                    end
                end)
            end
            
            if LocalPlayer.Character then
                onCharacterAdded(LocalPlayer.Character)
            end
            LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
        else
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = LocalPlayer.Character.HumanoidRootPart
                local vel = hrp.AssemblyLinearVelocity
                hrp.AssemblyLinearVelocity = Vector3.new(vel.X, vel.Y, vel.Z)
            end
        end
    end
})

GeneralSection:Button({
    Title = "飞天",
    Description = "点击开启皮脚本飞行",
    Icon = "plane",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/07cdd3eeaf4d4928.txt_2024-08-09_090317.OTed.lua"))()
    end
})

GeneralSection:Button({
    Title = "飞车",
    Description = "点击开启皮脚本飞车",
    Icon = "car",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/Pi-feiche.lua"))()
    end
})

GeneralSection:Button({
    Title = "断麦",
    Description = "强制断开所有人语音",
    Icon = "mic-off",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Rootleak/Stalkie-2.0/refs/heads/main/vc.lua"))()
    end
})

-------------------------------------------------------------------------
-- Tab: 地点传送
-------------------------------------------------------------------------
local TeleportTab = Window:Tab({
    Title = "地点传送",
    Desc = "传送点",
    Icon = "solar:map-point-bold",
    IconColor = Gray,
    IconShape = "Square",
    Border = true,
})

local TeleportSection = TeleportTab:Section({
    Title = "选择传送点",
    Description = "点击传送"
})

local locationPoints = {
    {"枪店门口", Vector3.new(-330.09, 2.63, 24.57)},
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
    {"船艇修理店", Vector3.new(4087.73, -9.69, 2860.44)},
}

for _, loc in ipairs(locationPoints) do
    TeleportSection:Button({
        Title = loc[1],
        Icon = "map-pin",
        Callback = function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(loc[2])
                WindUI:Notify({
                    Title = "地点传送",
                    Content = "已传送到 " .. loc[1],
                    Duration = 2
                })
            end
        end
    })
end

-------------------------------------------------------------------------
-- Tab: 售货机传送区
-------------------------------------------------------------------------
local VendingTab = Window:Tab({
    Title = "售货机传送",
    Desc = "售货机传送点",
    Icon = "solar:shop-bold",
    IconColor = Gray,
    IconShape = "Square",
    Border = true,
})

local VendingSection = VendingTab:Section({
    Title = "售货机传送点"
})

local vendingPoints = {
    {"警察局售货机", Vector3.new(3375.46, -337.46, -473.67)},
    {"医院售货机", Vector3.new(3939.51, -337.12, -199.84)},
    {"游戏厅售货机", Vector3.new(2904.22, -337.11, 1732.52)},
    {"当铺售货机", Vector3.new(-207.06, -337.05, -99.43)},
}

for _, point in ipairs(vendingPoints) do
    VendingSection:Button({
        Title = point[1],
        Icon = "shopping-cart",
        Callback = function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(point[2])
                WindUI:Notify({
                    Title = "售货机传送",
                    Content = "已传送到 " .. point[1],
                    Duration = 2
                })
            end
        end
    })
end

-------------------------------------------------------------------------
-- Tab: 外卖员
-------------------------------------------------------------------------
local DeliveryTab = Window:Tab({
    Title = "外卖员",
    Desc = "外卖员传送点",
    Icon = "solar:bicycle-bold",
    IconColor = Gray,
    IconShape = "Square",
    Border = true,
})

local DeliverySection = DeliveryTab:Section({
    Title = "外卖员传送点"
})

local deliveryPoints = {
    {"圣奥里取餐点", Vector3.new(3070.80, 3.02, 451.35)},
    {"莱斯维尔取餐点", Vector3.new(756.54, 3.04, 1006.94)},
    {"北方圣奥里取餐点", Vector3.new(4535.62, 2.60, 915.71)},
}

for _, point in ipairs(deliveryPoints) do
    DeliverySection:Button({
        Title = point[1],
        Icon = "truck",
        Callback = function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(point[2])
                WindUI:Notify({
                    Title = "外卖员传送",
                    Content = "已传送到 " .. point[1],
                    Duration = 2
                })
            end
        end
    })
end

-------------------------------------------------------------------------
-- Tab: 出租车
-------------------------------------------------------------------------
local TaxiTab = Window:Tab({
    Title = "出租车",
    Desc = "出租车功能",
    Icon = "solar:car-bold",
    IconColor = Gray,
    IconShape = "Square",
    Border = true,
})

local TaxiSection = TaxiTab:Section({
    Title = "出租车功能"
})

TaxiSection:Button({
    Title = "wdfex出租车刷钱脚本",
    Icon = "dollar-sign",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/1687426335-art/IEAI/refs/heads/main/wnatsj.lua"))()
    end
})

-------------------------------------------------------------------------
-- Tab: 透视
-------------------------------------------------------------------------
local ESPTab = Window:Tab({
    Title = "透视",
    Desc = "透视功能",
    Icon = "solar:eye-bold",
    IconColor = Gray,
    IconShape = "Square",
    Border = true,
})

local ESPSection = ESPTab:Section({
    Title = "透视开关"
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

ESPSection:Toggle({
    Title = "透视总开关",
    Default = false,
    Callback = function(bool)
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

ESPSection:Toggle({
    Title = "绘制名字",
    Default = false,
    Callback = function(bool)
        espShowName = bool
        if espMasterEnabled then UpdateESP() end
    end
})

ESPSection:Toggle({
    Title = "绘制血量",
    Default = false,
    Callback = function(bool)
        espShowHealth = bool
        if espMasterEnabled then UpdateESP() end
    end
})

ESPSection:Toggle({
    Title = "绘制方框",
    Default = false,
    Callback = function(bool)
        espShowBox = bool
        if espMasterEnabled then UpdateESP() end
    end
})

ESPSection:Toggle({
    Title = "绘制距离",
    Default = false,
    Callback = function(bool)
        espShowDist = bool
        if espMasterEnabled then UpdateESP() end
    end
})

ESPSection:Toggle({
    Title = "同行显示",
    Default = false,
    Callback = function(bool)
        espShowScriptTag = bool
        if espMasterEnabled then UpdateESP() end
    end
})

ESPSection:Toggle({
    Title = "屏蔽自己",
    Default = true,
    Callback = function(bool)
        espShowSelf = bool
        if espMasterEnabled then UpdateESP() end
    end
})

ESPSection:Toggle({
    Title = "显示队伍",
    Default = false,
    Callback = function(bool)
        espShowTeam = bool
        if espMasterEnabled then UpdateESP() end
    end
})

ESPSection:Toggle({
    Title = "绘制手持武器",
    Default = false,
    Callback = function(bool)
        espShowWeapon = bool
        if espMasterEnabled then UpdateESP() end
    end
})

-------------------------------------------------------------------------
-- Tab: 标点传送
-------------------------------------------------------------------------
local WaypointTab = Window:Tab({
    Title = "标点传送",
    Desc = "地图标点传送",
    Icon = "solar:map-pin-bold",
    IconColor = Gray,
    IconShape = "Square",
    Border = true,
})

local WaypointSection = WaypointTab:Section({
    Title = "地图标点传送"
})

local function GetWaypointPosition()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local closest = nil
    local closestDist = 9999
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Position then
            local name = obj.Name:lower()
            local keywords = {"waypoint", "marker", "标点", "导航", "nav", "目标", "target", "destination", "pin", "flag", "point", "位置", "location", "way", "route", "指引", "标记", "gps", "map"}
            local match = false
            for _, kw in ipairs(keywords) do
                if name:find(kw) then
                    match = true
                    break
                end
            end
            if match then
                local dist = (hrp.Position - obj.Position).Magnitude
                if dist < closestDist and dist > 2 then
                    closestDist = dist
                    closest = obj.Position
                end
            end
            if obj.Color then
                local c = obj.Color
                if c.r > 0.8 and c.g > 0.8 and c.b < 0.3 then
                    local dist = (hrp.Position - obj.Position).Magnitude
                    if dist < closestDist and dist > 2 then
                        closestDist = dist
                        closest = obj.Position
                    end
                end
            end
            if obj.Material == Enum.Material.Neon then
                local dist = (hrp.Position - obj.Position).Magnitude
                if dist < closestDist and dist > 2 then
                    closestDist = dist
                    closest = obj.Position
                end
            end
            if obj:FindFirstChild("BillboardGui") or obj:FindFirstChild("SelectionBox") then
                local dist = (hrp.Position - obj.Position).Magnitude
                if dist < closestDist and dist > 2 then
                    closestDist = dist
                    closest = obj.Position
                end
            end
        end
        if obj:IsA("Model") then
            local name = obj.Name:lower()
            local keywords = {"waypoint", "marker", "标点", "导航", "nav", "目标", "target", "destination", "pin", "flag", "point", "位置", "指引", "标记", "gps"}
            local match = false
            for _, kw in ipairs(keywords) do
                if name:find(kw) then
                    match = true
                    break
                end
            end
            if match then
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

WaypointSection:Button({
    Title = "传送到地图标点",
    Icon = "navigation",
    Callback = function()
        local target = GetWaypointPosition()
        if target then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(target)
                WindUI:Notify({
                    Title = "标点传送",
                    Content = "已传送到标点位置",
                    Duration = 2
                })
            end
        else
            WindUI:Notify({
                Title = "标点传送",
                Content = "未找到地图标点，请先在地图上标点",
                Duration = 2
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
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(target)
        end
    end
end

WaypointSection:Toggle({
    Title = "自动传送标点",
    Default = false,
    Callback = function(bool)
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
local FlingTab = Window:Tab({
    Title = "甩飞",
    Desc = "甩飞功能",
    Icon = "solar:flame-bold",
    IconColor = Gray,
    IconShape = "Square",
    Border = true,
})

local FlingSection = FlingTab:Section({
    Title = "甩飞功能"
})

FlingSection:Button({
    Title = "碰飞",
    Icon = "zap",
    Callback = function()
        loadstring(game:HttpGet(('https://gist.githubusercontent.com/axelinharlem182/1ee425c9d850af697f8c3cb108a9d816/raw/c4660b01faf4db266e8031e310121a65836f98a7/The%2520Villain'),true))()
    end
})

local antiFlingEnabled = false
local antiFlingConnection = nil

FlingSection:Toggle({
    Title = "防甩飞",
    Default = false,
    Callback = function(bool)
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

FlingSection:Button({
    Title = "甩飞所有人",
    Icon = "users",
    Callback = function()
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
local RangeTab = Window:Tab({
    Title = "范围",
    Desc = "范围功能",
    Icon = "solar:target-bold",
    IconColor = Gray,
    IconShape = "Square",
    Border = true,
})

local RangeSection = RangeTab:Section({
    Title = "范围功能"
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

local rangeSizes = {10, 20, 30, 50, 70, 120, 300, 500, 999, 999999999}
for _, size in ipairs(rangeSizes) do
    RangeSection:Button({
        Title = "范围" .. size,
        Callback = function()
            updateRange(size)
        end
    })
end

RangeSection:Button({
    Title = "清空范围效果",
    Icon = "x",
    Callback = function()
        updateRange(0)
    end
})

-------------------------------------------------------------------------
-- Tab: 车辆功能
-------------------------------------------------------------------------
local VehicleTab = Window:Tab({
    Title = "车辆功能",
    Desc = "车辆功能",
    Icon = "solar:car-bold",
    IconColor = Gray,
    IconShape = "Square",
    Border = true,
})

local VehicleSection = VehicleTab:Section({
    Title = "车辆功能"
})

local vehicleSpinEnabled = false
local vehicleSpinConnection = nil
local spinSpeed = 30

VehicleSection:Toggle({
    Title = "车辆旋转",
    Description = "开启后人物旋转上车车也会跟着旋转",
    Default = false,
    Callback = function(bool)
        vehicleSpinEnabled = bool
        if bool then
            if vehicleSpinConnection then
                vehicleSpinConnection:Disconnect()
                vehicleSpinConnection = nil
            end
            vehicleSpinConnection = RunService.Heartbeat:Connect(function()
                if not vehicleSpinEnabled then return end
                if not LocalPlayer.Character then return end
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                local seat = hrp:FindFirstChild("SeatPart") or hrp:FindFirstChild("SeatWeld")
                if seat then
                    local currentCFrame = hrp.CFrame
                    local newCFrame = currentCFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
                    hrp.CFrame = newCFrame
                    
                    local vehicle = seat.Parent
                    if vehicle and vehicle:IsA("Model") then
                        local vehicleHRP = vehicle:FindFirstChild("HumanoidRootPart") or vehicle:FindFirstChild("PrimaryPart")
                        if vehicleHRP and vehicleHRP:IsA("BasePart") then
                            vehicleHRP.CFrame = vehicleHRP.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
                        end
                    end
                end
            end)
        else
            if vehicleSpinConnection then
                vehicleSpinConnection:Disconnect()
                vehicleSpinConnection = nil
            end
        end
    end
})

VehicleSection:Slider({
    Title = "旋转速度",
    Min = 5,
    Max = 200,
    Default = 30,
    Callback = function(Value)
        spinSpeed = Value
    end
})

-------------------------------------------------------------------------
-- Tab: 枪械功能
-------------------------------------------------------------------------
local WeaponTab = Window:Tab({
    Title = "枪械功能",
    Desc = "枪械功能",
    Icon = "solar:gun-bold",
    IconColor = Gray,
    IconShape = "Square",
    Border = true,
})

local WeaponSection = WeaponTab:Section({
    Title = "枪械功能"
})

WeaponSection:Button({
    Title = "无限子弹+超快射速（手枪可连发）",
    Icon = "bullet",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/1687426335-art/IEAI/refs/heads/main/tzh.lua"))()
    end
})

-------------------------------------------------------------------------
-- Tab: 杀戮光环
-------------------------------------------------------------------------
local KillAuraTab = Window:Tab({
    Title = "杀戮光环",
    Desc = "杀戮光环",
    Icon = "solar:skull-bold",
    IconColor = Gray,
    IconShape = "Square",
    Border = true,
})

local KillAuraSection = KillAuraTab:Section({
    Title = "杀戮光环"
})

KillAuraSection:Button({
    Title = "开启杀戮光环",
    Description = "点击执行杀戮光环脚本",
    Icon = "sword",
    Callback = function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local RunService = game:GetService("RunService")
        local Debris = game:GetService("Debris")

        local loopConnection = nil
        local selectedSoundId = "rbxassetid://8679627751"
        local AURA_RANGE = 90
        local soundList = {
            "rbxassetid://8679627751",
            "rbxassetid://3125624765",
            "rbxassetid://17755696142",
            "rbxassetid://10070796384"
        }

        local function GetHitFunction()
            local char = LocalPlayer.Character
            if not char then return nil end
            for _, tool in ipairs(char:GetChildren()) do
                if tool:IsA("Tool") then
                    local remotes = tool:FindFirstChild("Remotes")
                    if remotes then
                        local hitFunc = remotes:FindFirstChild("HitFunction")
                        if hitFunc then
                            return hitFunc
                        end
                    end
                end
            end
            return nil
        end

        local function GetEnemiesInRange()
            local enemies = {}
            local myChar = LocalPlayer.Character
            if not myChar then return enemies end
            local myHrp = myChar:FindFirstChild("HumanoidRootPart")
            if not myHrp then return enemies end
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character.Parent then
                    local humanoid = player.Character:FindFirstChild("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
                        if targetHrp then
                            local dist = (myHrp.Position - targetHrp.Position).Magnitude
                            if dist <= AURA_RANGE then
                                table.insert(enemies, player)
                            end
                        end
                    end
                end
            end
            return enemies
        end

        local hue = 0
        local function GetRainbowColor()
            hue = (hue + 0.02) % 1
            return Color3.fromHSV(hue, 1, 1)
        end

        local function DrawTrajectory(origin, targetPos)
            local color = GetRainbowColor()
            local part = Instance.new("Part")
            part.Anchored = true
            part.CanCollide = false
            part.Material = Enum.Material.Neon
            part.Color = color
            local distance = (origin - targetPos).Magnitude
            if distance < 0.1 then return end
            part.Size = Vector3.new(0.1, 0.1, distance)
            part.CFrame = CFrame.lookAt(origin, targetPos) * CFrame.new(0, 0, -distance / 2)
            part.Parent = workspace
            Debris:AddItem(part, 0.3)
        end

        local function PlayShootSound()
            local sound = Instance.new("Sound")
            sound.SoundId = selectedSoundId
            sound.Volume = 1
            sound.Parent = LocalPlayer.Character or workspace
            sound:Play()
            task.delay(1, function() sound:Destroy() end)
        end

        local function AttackEnemy(targetPlayer, hitFunction)
            local targetChar = targetPlayer.Character
            if not targetChar then return end
            local hitPart = targetChar:FindFirstChild("Left Arm") or targetChar:FindFirstChild("Right Arm") or targetChar:FindFirstChild("Head") or targetChar:FindFirstChild("HumanoidRootPart")
            if not hitPart then return end
            local myChar = LocalPlayer.Character
            if not myChar then return end
            local myHrp = myChar:FindFirstChild("HumanoidRootPart")
            if not myHrp then return end
            local origin = myHrp.Position
            local targetPos = hitPart.Position
            DrawTrajectory(origin, targetPos)
            PlayShootSound()
            local args = {
                targetChar,
                hitPart,
                Vector3.new(1, 2, 1)
            }
            pcall(function()
                hitFunction:InvokeServer(unpack(args))
            end)
        end

        local function KillAuraLoop()
            local hitFunction = GetHitFunction()
            if not hitFunction then return end
            local enemies = GetEnemiesInRange()
            for _, enemy in ipairs(enemies) do
                task.spawn(AttackEnemy, enemy, hitFunction)
                task.wait(0.03)
            end
        end

        LocalPlayer.CharacterAdded:Connect(function()
            task.wait(0.5)
            print("1")
        end)
        loopConnection = RunService.Heartbeat:Connect(KillAuraLoop)
    end
})

-------------------------------------------------------------------------
-- Tab: 警察显示
-------------------------------------------------------------------------
local PoliceTab = Window:Tab({
    Title = "警察显示",
    Desc = "警察数量显示",
    Icon = "solar:shield-bold",
    IconColor = Gray,
    IconShape = "Square",
    Border = true,
})

local PoliceSection = PoliceTab:Section({
    Title = "警察数量显示"
})

local policeDisplayEnabled = false
local policeLabel = nil
local policeGui = nil
local policeDisplayConnection = nil

local function IsPlayerPolice(player)
    if player.Team then
        local teamName = player.Team.Name or ""
        if teamName:find("警察") or teamName:find("Police") or teamName:find("Cop") or teamName:find("Sheriff") then
            return true
        end
    end
    if player.Character then
        for _, child in ipairs(player.Character:GetDescendants()) do
            if child:IsA("StringValue") or child:IsA("BoolValue") or child:IsA("IntValue") then
                local name = child.Name:lower()
                if name:find("police") or name:find("cop") or name:find("警察") or name:find("sheriff") then
                    return true
                end
            end
        end
    end
    for _, child in ipairs(player:GetChildren()) do
        if child:IsA("StringValue") or child:IsA("BoolValue") or child:IsA("IntValue") then
            local name = child.Name:lower()
            if name:find("police") or name:find("cop") or name:find("警察") or name:find("sheriff") then
                return true
            end
        end
    end
    return false
end

local function UpdatePoliceCount()
    if not policeDisplayEnabled then return end
    
    local count = 0
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if IsPlayerPolice(player) then
            count = count + 1
        end
    end
    
    if policeLabel then
        policeLabel.Text = "警察: " .. count
        if count == 0 then
            policeLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        elseif count <= 3 then
            policeLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
        else
            policeLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end
end

PoliceSection:Toggle({
    Title = "显示警察数量",
    Description = "在屏幕右上方实时显示警察数量",
    Default = false,
    Callback = function(bool)
        policeDisplayEnabled = bool
        if bool then
            if policeGui then
                policeGui:Destroy()
                policeGui = nil
                policeLabel = nil
            end
            
            policeGui = Instance.new("ScreenGui")
            policeGui.Name = "PoliceDisplay"
            policeGui.ResetOnSpawn = false
            policeGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            policeGui.Parent = game.CoreGui
            
            policeLabel = Instance.new("TextLabel")
            policeLabel.Name = "PoliceLabel"
            policeLabel.Size = UDim2.new(0, 120, 0, 30)
            policeLabel.Position = UDim2.new(1, -130, 0, 10)
            policeLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            policeLabel.BackgroundTransparency = 0.3
            policeLabel.BorderSizePixel = 1
            policeLabel.BorderColor3 = Color3.fromRGB(255, 255, 255)
            policeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            policeLabel.TextSize = 16
            policeLabel.Font = Enum.Font.GothamBold
            policeLabel.Text = "警察: 0"
            policeLabel.Parent = policeGui
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = policeLabel
            
            UpdatePoliceCount()
            
            if policeDisplayConnection then
                policeDisplayConnection:Disconnect()
                policeDisplayConnection = nil
            end
            policeDisplayConnection = RunService.Heartbeat:Connect(function()
                if policeDisplayEnabled then
                    UpdatePoliceCount()
                end
            end)
            
            Players.PlayerAdded:Connect(function()
                if policeDisplayEnabled then UpdatePoliceCount() end
            end)
            Players.PlayerRemoving:Connect(function()
                if policeDisplayEnabled then UpdatePoliceCount() end
            end)
            
        else
            if policeGui then
                policeGui:Destroy()
                policeGui = nil
                policeLabel = nil
            end
            if policeDisplayConnection then
                policeDisplayConnection:Disconnect()
                policeDisplayConnection = nil
            end
        end
    end
})

-------------------------------------------------------------------------
-- Tab: 设置
-------------------------------------------------------------------------
local SettingsTab = Window:Tab({
    Title = "设置",
    Desc = "设置",
    Icon = "solar:settings-bold",
    IconColor = Gray,
    IconShape = "Square",
    Border = true,
})

local SettingsSection = SettingsTab:Section({
    Title = "控制"
})

SettingsSection:Button({
    Title = "关闭脚本",
    Description = "关闭脚本并清理UI",
    Icon = "power",
    Callback = function()
        getgenv().EasterEgg = false
        antiFlingEnabled = false
        autoWaypointEnabled = false
        vehicleSpinEnabled = false
        policeDisplayEnabled = false
        if policeDisplayConnection then
            policeDisplayConnection:Disconnect()
            policeDisplayConnection = nil
        end
        if policeGui then
            policeGui:Destroy()
            policeGui = nil
            policeLabel = nil
        end
        if vehicleSpinConnection then
            vehicleSpinConnection:Disconnect()
            vehicleSpinConnection = nil
        end
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
            local frosty = game.CoreGui:FindFirstChild("frosty")
            if frosty then frosty:Destroy() end
            local eggGui = game.CoreGui:FindFirstChild("EasterEggGui")
            if eggGui then eggGui:Destroy() end
            local welcomeGui = game.CoreGui:FindFirstChild("wdfexWelcome")
            if welcomeGui then welcomeGui:Destroy() end
            local borderGui = game.CoreGui:FindFirstChild("wdfexBorder")
            if borderGui then borderGui:Destroy() end
            local hubGui = game.CoreGui:FindFirstChild("wdfexHub")
            if hubGui then hubGui:Destroy() end
            local policeGui = game.CoreGui:FindFirstChild("PoliceDisplay")
            if policeGui then policeGui:Destroy() end
        end)
        Window:Destroy()
    end
})

SettingsSection:Toggle({
    Title = "彩蛋开关",
    Description = "开启彩蛋功能",
    Default = false,
    Callback = function(bool)
        getgenv().EasterEgg = bool
        
        if bool then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(Vector3.new(4402.39, 3.04, 1607.56))
            end
            
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
                if not getgenv().EasterEgg then return end
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
                eggSound.Parent = game.CoreGui
                eggSound:Play()
                eggPlaying = true
                
                eggSound.Ended:Connect(function()
                    eggPlaying = false
                end)
            end)
            
            pcall(function()
                local eggGui = Instance.new("ScreenGui")
                eggGui.Name = "EasterEggGui"
                eggGui.Parent = game.CoreGui
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
                local eggGui = game.CoreGui:FindFirstChild("EasterEggGui")
                if eggGui then eggGui:Destroy() end
            end)
        end
    end
})

    -- 窗口关闭清理
    Window:OnClose(function()
        print("窗口关闭")
    end)

    Window:OnDestroy(function()
        print("窗口已销毁")
    end)
end

WindUI:Popup({
    Title = "<font color='#FFFFFF'>w</font><font color='#CCCCCC'>d</font><font color='#999999'>f</font><font color='#666666'>e</font><font color='#444444'>x</font> <font color='#666666'>圣</font><font color='#444444'>奥</font><font color='#222222'>里</font>",
    IconThemed = true,
    Content = "尊贵wdfex脚本用户 " .. game.Players.LocalPlayer.Name .. " 使用 wdfex圣奥里",
    Buttons = {
        {
            Title = "取消",
            Callback = function() 
                createUI()
            end,
            Variant = "Secondary",
        },
        {
            Title = "执行",
            Icon = "arrow-right",
            Callback = function() 
                createUI()
            end,
            Variant = "Primary",
        }
    }
})