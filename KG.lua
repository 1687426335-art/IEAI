local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LoadingScreen"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Name = "MainContainer"
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.Size = UDim2.new(0, 400, 0, 400)
Frame.BackgroundTransparency = 1
Frame.Parent = ScreenGui

local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Name = "Logo"
ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
ImageLabel.Position = UDim2.new(0.5, 0, 0.4, 0)
ImageLabel.Size = UDim2.new(0, 200, 0, 200)
ImageLabel.BackgroundTransparency = 1
ImageLabel.Image = "rbxassetid://128586210657724"
ImageLabel.ImageTransparency = 0
ImageLabel.ZIndex = 999
ImageLabel.Parent = Frame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.2, 0)
UICorner.Parent = ImageLabel

local TextLabel = Instance.new("TextLabel")
TextLabel.Name = "WelcomeText"
TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel.Position = UDim2.new(0.5, 0, 0.75, 0)
TextLabel.Size = UDim2.new(0, 350, 0, 60)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "欢迎使用wdfex脚本"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 42
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextTransparency = 0
TextLabel.TextStrokeTransparency = 0.8
TextLabel.TextStrokeColor3 = Color3.fromRGB(50, 50, 50)
TextLabel.ZIndex = 999
TextLabel.Parent = Frame

local startTime = tick()

for i = 1, 42 do
    local currentTime = tick()
    local elapsedTime = currentTime - startTime
    
    if elapsedTime >= 1.5 then
        break
    end
    
    local progress = elapsedTime / 1.5
    local angle = progress * math.pi
    
    local offset = math.sin(angle) * 100
    
    ImageLabel.Position = UDim2.new(0.5, -offset, 0.4, 0)
    ImageLabel.ImageTransparency = offset / 100
    
    TextLabel.Position = UDim2.new(0.5, offset, 0.75, 0)
    TextLabel.TextTransparency = offset / 100
    
    game:GetService("RunService").Heartbeat:Wait()
end

ImageLabel.ImageTransparency = 0
TextLabel.TextTransparency = 0

local Main_Lua = game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua")
local Loaded_Main_Lua = loadstring(Main_Lua)()
local Window = Loaded_Main_Lua:CreateWindow({
    User = {
        Enabled = true,
        Callback = function()
            print("clicked")
        end,
        Anonymous = false,
    },
    Author = "作者:wdfex",
    IconThemed = true,
    ScrollBarEnabled = true,
    Folder = "wdfex脚本",
    HideSearchBar = true,
    Title = "wdfex脚本",
    Transparent = true,
    SideBarWidth = 200,
    Theme = "Midnight",
    Icon = "rbxassetid://129260712070622",
    Size = UDim2.fromOffset(300, 270),
})

Window:EditOpenButton({
    StrokeThickness = 4,
    Title = "打开脚本",
    Color = ColorSequence.new(Color3.fromHex("#00FF7F"), Color3.fromHex("#0080FF")),
    Draggable = true,
    Icon = "monitor",
    CornerRadius = UDim.new(0, 16),
})

local secondStartTime = tick()

for i = 1, 42 do
    local currentTime = tick()
    local elapsedTime = currentTime - secondStartTime
    
    if elapsedTime >= 1.2 then
        break
    end
    
    local progress = elapsedTime / 1.2
    local angle = progress * math.pi
    
    local offset = math.sin(angle) * 100
    
    ImageLabel.Position = UDim2.new(0.5, -offset, 0.4, 0)
    ImageLabel.ImageTransparency = offset / 100
    
    TextLabel.Position = UDim2.new(0.5, offset, 0.75, 0)
    TextLabel.TextTransparency = offset / 100
    
    game:GetService("RunService").Heartbeat:Wait()
end

ImageLabel.ImageTransparency = 1
TextLabel.TextTransparency = 1

Frame:Destroy()
ScreenGui:Destroy()

Window:Tag({
    Title = "wdfex 圣奥里传送 ",
    Color = Color3.fromHex("#10C550"),
})

Window:SelectTab(1)

-- ===== 通知函数 =====
local function Notify(text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "wdfex",
            Text = text,
            Icon = "rbxassetid://18941716391",
            Duration = 2,
        })
    end)
end

-- ===== 传送函数 =====
local function TeleportTo(pos)
    pcall(function()
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(pos)
        end
    end)
end

-- ===== 公告Tab =====
local homeTab = Window:Tab({
    Title = "『公告』",
    Icon = "home",
})

homeTab:Paragraph({
    Image = "rbxassetid://128586210657724",
    Title = "wdfex 圣奥里传送",
    Buttons = {},
    ImageSize = 68,
    Desc = "作者: wdfex\n此版本为圣奥里传送脚本\n本脚本悬浮窗UI由皮脚本作者提供\n脚本无防踢\n需要先执行皮脚本圣奥里再执行本脚本\n否则概率被踢出",
})

-- ===== 实用传送Tab =====
local teleportTab = Window:Tab({
    Title = "『实用传送』",
    Icon = "map-pin",
})

local teleportSection = teleportTab:Section({
    Title = "实用传送点",
    Opened = true,
})

teleportSection:Button({
    Title = "枪店门口",
    Callback = function()
        TeleportTo(Vector3.new(-330.09, 2.63, 24.57))
    end,
})

teleportSection:Button({
    Title = "枪械商店",
    Callback = function()
        TeleportTo(Vector3.new(-336.86, -205.07, 61.75))
    end,
})

teleportSection:Button({
    Title = "黑色市场",
    Callback = function()
        TeleportTo(Vector3.new(1040.91, -22.73, 899.80))
    end,
})

teleportSection:Button({
    Title = "小银行",
    Callback = function()
        TeleportTo(Vector3.new(-667.74, 2.63, -67.18))
    end,
})

teleportSection:Button({
    Title = "大银行",
    Callback = function()
        TeleportTo(Vector3.new(3134.64, 6.12, -169.70))
    end,
})

teleportSection:Button({
    Title = "农场",
    Callback = function()
        TeleportTo(Vector3.new(-1269.56, 2.57, 2559.51))
    end,
})

teleportSection:Button({
    Title = "警察局",
    Callback = function()
        TeleportTo(Vector3.new(3313.52, 3.02, -476.74))
    end,
})

teleportSection:Button({
    Title = "医院",
    Callback = function()
        TeleportTo(Vector3.new(3892.10, 3.02, -185.78))
    end,
})

teleportSection:Button({
    Title = "游戏厅",
    Callback = function()
        TeleportTo(Vector3.new(2936.71, 2.63, 1688.17))
    end,
})

teleportSection:Button({
    Title = "超市",
    Callback = function()
        TeleportTo(Vector3.new(3936.62, 3.04, 1136.92))
    end,
})

teleportSection:Button({
    Title = "平民出生点",
    Callback = function()
        TeleportTo(Vector3.new(3741.79, 3.72, -438.95))
    end,
})

teleportSection:Button({
    Title = "约克镇出生点",
    Callback = function()
        TeleportTo(Vector3.new(-221.64, 3.04, -84.56))
    end,
})

teleportSection:Button({
    Title = "躲藏点",
    Callback = function()
        TeleportTo(Vector3.new(-1505.97, 253.98, -476.43))
    end,
})

teleportSection:Button({
    Title = "游轮码头",
    Callback = function()
        TeleportTo(Vector3.new(985.45, -22.53, 1274.22))
    end,
})

teleportSection:Button({
    Title = "车辆维修",
    Callback = function()
        TeleportTo(Vector3.new(-409.58, 3.08, 2.80))
    end,
})

teleportSection:Button({
    Title = "监狱",
    Callback = function()
        TeleportTo(Vector3.new(-1605.21, 2.63, 1223.50))
    end,
})

teleportSection:Button({
    Title = "拆车场",
    Callback = function()
        TeleportTo(Vector3.new(3434.49, 42.93, 2686.46))
    end,
})

teleportSection:Button({
    Title = "非法交易点",
    Callback = function()
        TeleportTo(Vector3.new(2284.16, -16.97, 2652.88))
    end,
})

teleportSection:Button({
    Title = "送货队伍",
    Callback = function()
        TeleportTo(Vector3.new(4402.39, 3.04, 1607.56))
    end,
})

teleportSection:Button({
    Title = "道路服务",
    Callback = function()
        TeleportTo(Vector3.new(4275.96, 2.63, 1200.88))
    end,
})

teleportSection:Button({
    Title = "消防队伍",
    Callback = function()
        TeleportTo(Vector3.new(3578.02, 8.15, 577.34))
    end,
})

teleportSection:Button({
    Title = "车店",
    Callback = function()
        TeleportTo(Vector3.new(0, 0, 0))
    end,
})

-- ===== 外卖员Tab =====
local deliveryTab = Window:Tab({
    Title = "『外卖员』",
    Icon = "truck",
})

local deliverySection = deliveryTab:Section({
    Title = "外卖员传送点",
    Opened = true,
})

deliverySection:Button({
    Title = "圣奥里取餐点",
    Callback = function()
        TeleportTo(Vector3.new(3070.80, 3.02, 451.35))
    end,
})

deliverySection:Button({
    Title = "莱斯维尔取餐点",
    Callback = function()
        TeleportTo(Vector3.new(756.54, 3.04, 1006.94))
    end,
})

deliverySection:Button({
    Title = "北方圣奥里取餐点",
    Callback = function()
        TeleportTo(Vector3.new(4535.62, 2.60, 915.71))
    end,
})

-- ===== 外卖员工专区Tab =====
local workerTab = Window:Tab({
    Title = "『外卖员工专区』",
    Icon = "user",
})

local workerSection = workerTab:Section({
    Title = "功能",
    Opened = true,
})

workerSection:Paragraph({
    Title = "外卖员工专用功能",
    Desc = "暂无功能，等待更新...",
})

-- ===== 设置Tab =====
local settingsTab = Window:Tab({
    Title = "『设置』",
    Icon = "settings",
})

local settingsSection = settingsTab:Section({
    Title = "控制",
    Opened = true,
})

settingsSection:Button({
    Title = "关闭脚本",
    Callback = function()
        getgenv().EasterEgg = false
        pcall(function()
            local frosty = game:GetService("CoreGui"):FindFirstChild("frosty")
            if frosty then frosty:Destroy() end
            local eggGui = game:GetService("CoreGui"):FindFirstChild("EasterEggGui")
            if eggGui then eggGui:Destroy() end
        end)
        Window:Destroy()
    end,
})

settingsSection:Toggle({
    Title = "彩蛋开关",
    Default = false,
    Callback = function(enabled)
        getgenv().EasterEgg = enabled
        
        if enabled then
            TeleportTo(Vector3.new(4402.39, 3.04, 1607.56))
            Notify("彩蛋已开启")
            
            pcall(function()
                local eggGui = Instance.new("ScreenGui")
                eggGui.Name = "EasterEggGui"
                eggGui.Parent = game:GetService("CoreGui")
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
                local eggGui = game:GetService("CoreGui"):FindFirstChild("EasterEggGui")
                if eggGui then eggGui:Destroy() end
            end)
            Notify("彩蛋已关闭")
        end
    end,
})

print("wdfex 圣奥里传送脚本已加载")
print("共23个传送点")