--傻逼张硕 我超你妈 叫你圈钱
--BS还原 PCO dump 
--张硕我就超你妈

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
TextLabel.Text = "欢迎使用KG脚本"
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
    Author = "作者:张硕",
    IconThemed = true,
    ScrollBarEnabled = true,
    Folder = "KG脚本",
    HideSearchBar = true,
    Title = "KG脚本",
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
    Title = "枪战射击类脚本 ",
    Color = Color3.fromHex("#10C550"),
})

Window:SelectTab(1)

local homeTab = Window:Tab({
    Title = "主页区",
    Icon = "home",
})

homeTab:Paragraph({
    Image = "rbxassetid://128586210657724",
    Title = "KG脚本介绍",
    Buttons = {{
        Callback = function()
            setclipboard("KG脚本QQ群819104139")
        end,
        Title = "复制KG脚本QQ群",
        Icon = "link",
    }},
    ImageSize = 68,
    Desc = "KG脚本为半自制\nKG脚本唯一作者：张硕\nKG脚本成立于2025年10月5日\nKG脚本是专门做枪战射击类游戏",
})

local feedbackSection = homeTab:Section({
    Title = "反馈",
    Opened = true,
})

feedbackSection:Paragraph({
    Title = "反馈一些正常内容，谢谢！",
})

local feedbackInput
feedbackSection:Input({
    Callback = function(value)
        feedbackInput = value
    end,
    Placeholder = "请输入反馈内容...",
    Title = "反馈内容",
    Desc = "请输入您的反馈内容",
})

feedbackSection:Button({
    Callback = function()
        if feedbackInput and feedbackInput ~= "" then
            local feedbackText = "反馈：" .. feedbackInput
            local executorName = identifyexecutor() or "未知"
            local playerName = LocalPlayer.Name
            local displayName = LocalPlayer.DisplayName
            local fullName = playerName .. " | " .. displayName
            
            local MarketplaceService = game:GetService("MarketplaceService")
            local placeInfo = MarketplaceService:GetProductInfo(game.PlaceId)
            local placeName = placeInfo.Name
            local placeUrl = "https://www.roblox.com/games/" .. game.PlaceId
            local gameInfo = placeName .. " | " .. placeUrl
            
            local httpRequest = http_request or request
            local webhookData = {
                username = "张硕牛逼",
                embeds = {{
                    color = 3329330,
                    fields = {
                        {name = "注入器", value = executorName, inline = true},
                        {name = "名字", value = fullName, inline = true},
                        {name = "地图", value = gameInfo, inline = true}
                    },
                    title = feedbackText
                }}
            }
            
            local jsonData = game:GetService("HttpService"):JSONEncode(webhookData)
            
            for _, webhookUrl in ipairs({
                "https://discord.com/api/webhooks/1429399144342229114/lpfGjuZxPsI7vh1VAUrVugB5SkJN1Dhcs6U5bxFQc87dSvUtVetZ3jpcGLRvtpywQuMr",
                "https://discord.com/api/webhooks/1429399180006260736/Le3l6JZWWoC-MDR594eXj-GONR7wCk7hIsyOXrWhiI7NX3qJYamBlAtWaUWdkVXE9Hsp",
                "https://discord.com/api/webhooks/1429399176550023179/bL2OjHDWvuo2zUBJodlto1_OrVGnLXreHHTg_ab1jIsqjWwqdkzvcIjLviTh-DCS3kTJ"
            }) do
                pcall(function()
                    httpRequest({
                        Body = jsonData,
                        Url = webhookUrl,
                        Method = "POST",
                        Headers = {
                            ["Content-Type"] = "application/json"
                        }
                    })
                end)
            end
            
            Loaded_Main_Lua:Notify({
                Icon = "check",
                Duration = 3,
                Title = "反馈成功",
                Content = "您的反馈已提交",
            })
        end
    end,
    Icon = "send",
    Title = "提交反馈",
    Desc = "提交您的反馈内容",
})

local musicTab = Window:Tab({
    Title = "音乐区",
    Icon = "music",
    IconColor = Color3.fromHex("#8A2BE2"),
})

local soundLibrary = musicTab:Section({
    Title = "音乐库",
    Opened = true,
    Box = true,
})

local musicList = {
    {"防空警报", "rbxassetid://792323017"},
    {"义勇军进行曲", "rbxassetid://1845918434"},
    {"彩虹瀑布", "rbxassetid://1837879082"},
    {"雨中牛郎", "rbxassetid://16831108393"},
    {"钢管落地(大声)", "rbxassetid://6729922069"},
    {"钢管落地", "rbxassetid://6011094380"},
    {"闪灯", "rbxassetid://8829969521"},
    {"全损音质", "rbxassetid://6445594239"},
    {"串稀", "rbxassetid://4809574295"},
    {"手枪开枪", "rbxassetid://6569844325"},
    {"喝可乐", "rbxassetid://6911756959"},
    {"Doors TheHunt 倒计时开始", "rbxassetid://16695384009"},
    {"Doors TheHunt 倒计时结束", "rbxassetid://16695021133"},
    {"你他妈劈我瓜是吧", "rbxassetid://7309604510"},
    {"未知核爆倒计时", "rbxassetid://9133927345"},
    {"火车音", "rbxassetid://3900067524"},
    {"Gentry Road", "rbxassetid://5567523008"},
    {"植物大战僵尸", "rbxassetid://158260415"},
    {"早安越南", "rbxassetid://8295016126"},
    {"愤怒芒西 Evade?", "rbxassetid://5029269312"},
    {"梅西", "rbxassetid://7354576319"},
    {"永春拳", "rbxassetid://1845973140"},
    {"带劲的音乐", "rbxassetid://18841891575"},
    {"韩国国歌", "rbxassetid://1837478300"},
    {"哥哥你女朋友不会吃醋吧?", "rbxassetid://8715811379"},
    {"蜘蛛侠出场声音", "rbxassetid://9108472930"},
    {"消防车", "rbxassetid://317455930"},
    {"万圣节1", "rbxassetid://1837467198"},
    {"好听的", "rbxassetid://1844125168"},
    {"妈妈生的", "rbxassetid://6689498326"},
    {"Music Ball-CTT", "rbxassetid://9045415830"},
    {"电音", "rbxassetid://6911766512"},
    {"梗合集", "rbxassetid://8161248815"},
    {"Its been so long", "rbxassetid://6913550990"},
    {"Baller", "rbxassetid://13530439660"},
    {"男娘必听", "rbxassetid://6797864253"},
    {"螃蟹之舞", "rbxassetid://54100886218"},
    {"布鲁克林惨案", "rbxassetid://6783714255"},
    {"航空模拟器音乐", "rbxassetid://1838080629"}
}

for _, music in ipairs(musicList) do
    local title, soundId = music[1], music[2]
    soundLibrary:Button({
        Title = title,
        Color = Color3.fromHex("#257AF7"),
        Callback = function()
            local sound = Instance.new("Sound")
            sound.SoundId = soundId
            sound.Parent = workspace
            sound:Play()
            
            Loaded_Main_Lua:Notify({
                Icon = "play",
                Title = "播放音乐",
                Content = "正在播放: " .. title,
            })
            
            sound.Ended:Connect(function()
                sound:Destroy()
            end)
        end,
        Icon = "music",
        IconAlign = "Left",
    })
    
    soundLibrary:Space()
end

local infoTab = Window:Tab({
    Title = "信息区",
    Icon = "star",
})

local selectedInfo = "游玩时间"
local infoParagraph = infoTab:Paragraph({
    Image = "save",
    Title = "信息显示",
    Color = "White",
    ImageSize = 20,
    Desc = "请选择要查看的信息",
})

local function updateInfoDisplay()
    if selectedInfo == "游玩时间" then
        local playTime = LocalPlayer.PlayTime or 0
        local hours = math.floor(playTime / 3600)
        local minutes = math.floor((playTime % 3600) / 60)
        local seconds = math.floor(playTime % 60)
        local formattedTime = string.format("%d小时%d分钟%d秒", hours, minutes, seconds)
        infoParagraph:SetDesc(formattedTime)
        infoParagraph:SetTitle("游玩时间")
    elseif selectedInfo == "服务器当前人数" then
        local playerCount = #Players:GetPlayers()
        infoParagraph:SetDesc("当前服务器人数: " .. playerCount)
        infoParagraph:SetTitle("服务器人数")
    elseif selectedInfo == "当前时间" then
        local currentTime = os.date("%Y-%m-%d %H:%M:%S")
        infoParagraph:SetDesc("当前时间: " .. currentTime)
        infoParagraph:SetTitle("系统时间")
    end
end

infoTab:Dropdown({
    Value = selectedInfo,
    Callback = function(value)
        selectedInfo = value
        updateInfoDisplay()
    end,
    Title = "选择查看信息",
    Values = {
        "服务器当前人数",
        "当前时间",
        "游戏时间",
        "账号年龄",
        "注入器",
        "用户名",
        "服务器名称",
        "服务器ID",
        "用户ID",
        "客户端ID",
        "游玩时间",
    },
})

infoTab:Button({
    Callback = updateInfoDisplay,
    Title = "立即刷新",
    Icon = "refresh-cw",
})

spawn(function()
    while wait(1) do
        updateInfoDisplay()
    end
end)

local visualsTab = Window:Tab({
    Title = "美化区",
    Icon = "sparkles",
})

visualsTab:Paragraph({
    Title = "只有自己看得见，别人看不见\n可能存在bug，希望谅解",
})

visualsTab:Toggle({
    Value = false,
    Callback = function(value)
        local character = LocalPlayer.Character
        if character then
            local head = character:FindFirstChild("Head")
            if head then
                head.Transparency = value and 1 or 0
            end
        end
    end,
    Title = "美化无头",
    Desc = "隐藏角色头部",
})

visualsTab:Toggle({
    Value = false,
    Callback = function(value)
        local character = LocalPlayer.Character
        if character then
            for _, child in ipairs(character:GetChildren()) do
                if child:IsA("Accessory") then
                    child:Destroy()
                end
            end
        end
    end,
    Title = "删除帽子",
    Desc = "移除所有装饰品",
})

visualsTab:Toggle({
    Value = false,
    Callback = function(value)
        if value then
            local rainbowConnection
            rainbowConnection = game:GetService("RunService").RenderStepped:Connect(function()
                local character = LocalPlayer.Character
                if character then
                    local hue = tick() % 5 / 5
                    local color = Color3.fromHSV(hue, 1, 1)
                    for _, part in ipairs(character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.Color = color
                        end
                    end
                end
            end)
        end
    end,
    Title = "彩虹角色",
    Desc = "为角色添加彩虹效果",
})

local playerTab = Window:Tab({
    Title = "玩家区",
    Icon = "user",
})

playerTab:Slider({
    Value = {Min = 16, Default = 16, Max = 200},
    Callback = function(value)
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = value
            end
        end
    end,
    Title = "移动速度",
    Step = 1,
})

playerTab:Slider({
    Value = {Min = 50, Default = 50, Max = 200},
    Callback = function(value)
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = value
            end
        end
    end,
    Title = "跳跃高度",
    Step = 1,
})

playerTab:Toggle({
    Value = false,
    Title = "解锁最大视野",
    Callback = function(value)
        LocalPlayer.CameraMaxZoomDistance = value and 99999 or 100
    end,
})

playerTab:Toggle({
    Value = false,
    Title = "穿墙",
    Callback = function(value)
        if value then
            local noclipConnection
            noclipConnection = game:GetService("RunService").Stepped:Connect(function()
                local character = LocalPlayer.Character
                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    end,
})

playerTab:Toggle({
    Value = false,
    Title = "无限跳",
    Callback = function(value)
        if value then
            local jumpConnection
            jumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                local character = LocalPlayer.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end)
        end
    end,
})

playerTab:Toggle({
    Value = false,
    Title = "走路瞬移",
    Desc = "行走时自动瞬移",
    Callback = function(value)
        if value then
            local teleportConnection
            teleportConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local character = LocalPlayer.Character
                if character then
                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.CFrame = rootPart.CFrame + rootPart.CFrame.LookVector * 5
                    end
                end
            end)
        end
    end,
})

playerTab:Toggle({
    Value = false,
    Title = "夜视",
    Callback = function(value)
        local lighting = game:GetService("Lighting")
        if value then
            lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            lighting.Brightness = 0.5
        else
            lighting.Ambient = Color3.new(0, 0, 0)
            lighting.Brightness = 1
        end
    end,
})

local teleportTab = Window:Tab({
    Title = "传送区",
    Icon = "map-pin",
})

teleportTab:Toggle({
    Value = false,
    Callback = function(value)
        if value then
            local mouse = LocalPlayer:GetMouse()
            mouse.Button1Down:Connect(function()
                local character = LocalPlayer.Character
                if character then
                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
                    end
                end
            end)
        end
    end,
    Title = "传送到鼠标位置",
    Desc = "点哪，传送到哪",
})

local savedLocations = {}
local locationName = ""
local selectedLocation = ""

teleportTab:Input({
    Placeholder = "输入名称",
    Title = "传送点名称",
    Callback = function(value)
        locationName = value
    end,
})

teleportTab:Button({
    Callback = function()
        if locationName ~= "" then
            local character = LocalPlayer.Character
            if character then
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    savedLocations[locationName] = rootPart.Position
                    Loaded_Main_Lua:Notify({
                        Icon = "check",
                        Title = "成功",
                        Content = "位置已保存: " .. locationName,
                    })
                end
            end
        end
    end,
    Title = "保存当前位置",
    Icon = "save",
})

local locationDropdown = teleportTab:Dropdown({
    Value = "",
    Callback = function(value)
        selectedLocation = value
    end,
    Title = "选择传送点",
    Values = {},
})

teleportTab:Button({
    Callback = function()
        local locationValues = {}
        for name, _ in pairs(savedLocations) do
            table.insert(locationValues, name)
        end
        locationDropdown:Refresh(locationValues)
    end,
    Title = "更新列表",
    Icon = "refresh-cw",
})

teleportTab:Button({
    Callback = function()
        if selectedLocation ~= "" and savedLocations[selectedLocation] then
            local character = LocalPlayer.Character
            if character then
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.CFrame = CFrame.new(savedLocations[selectedLocation])
                end
            end
        end
    end,
    Title = "传送到选择的位置",
    Icon = "navigation",
})

local animationsTab = Window:Tab({
    Title = "动画区",
    Icon = "user",
})

local animations = {
    {"宇航员", {
        idle1 = "rbxassetid://891621366",
        idle2 = "rbxassetid://891633237",
        walk = "rbxassetid://891667138",
        run = "rbxassetid://891636393",
        jump = "rbxassetid://891627522",
        climb = "rbxassetid://891609353",
        fall = "rbxassetid://891617961"
    }},
    {"泡状", {
        idle1 = "rbxassetid://910004836",
        idle2 = "rbxassetid://910009958",
        walk = "rbxassetid://910034870",
        run = "rbxassetid://910025107",
        jump = "rbxassetid://910016857",
        fall = "rbxassetid://910001910"
    }},
    {"卡通", {
        idle1 = "rbxassetid://742637544",
        idle2 = "rbxassetid://742638445",
        walk = "rbxassetid://742640026",
        run = "rbxassetid://742638842",
        jump = "rbxassetid://742637942",
        climb = "rbxassetid://742636889",
        fall = "rbxassetid://742637151"
    }},
    {"老人", {
        idle1 = "rbxassetid://845397899",
        idle2 = "rbxassetid://845400520",
        walk = "rbxassetid://845403856",
        run = "rbxassetid://845386501",
        jump = "rbxassetid://845398858",
        climb = "rbxassetid://845392038",
        fall = "rbxassetid://845396048"
    }},
    {"骑士", {
        idle1 = "rbxassetid://657595757",
        idle2 = "rbxassetid://657568135",
        walk = "rbxassetid://657552124",
        run = "rbxassetid://657564596",
        jump = "rbxassetid://658409194",
        climb = "rbxassetid://658360781",
        fall = "rbxassetid://657600338"
    }},
    {"悬浮", {
        idle1 = "rbxassetid://616006778",
        idle2 = "rbxassetid://616008087",
        walk = "rbxassetid://616013216",
        run = "rbxassetid://616010382",
        jump = "rbxassetid://616008936",
        climb = "rbxassetid://616003713",
        fall = "rbxassetid://616005863"
    }},
    {"法师", {
        idle1 = "rbxassetid://707742142",
        idle2 = "rbxassetid://707855907",
        walk = "rbxassetid://707897309",
        run = "rbxassetid://707861613",
        jump = "rbxassetid://707853694",
        climb = "rbxassetid://707826056",
        fall = "rbxassetid://707829716"
    }},
    {"忍者", {
        idle1 = "rbxassetid://656117400",
        idle2 = "rbxassetid://656118341",
        walk = "rbxassetid://656121766",
        run = "rbxassetid://656118852",
        jump = "rbxassetid://656117878",
        climb = "rbxassetid://656114359",
        fall = "rbxassetid://656115606"
    }},
    {"海盗", {
        idle1 = "rbxassetid://750781874",
        idle2 = "rbxassetid://750782770",
        walk = "rbxassetid://750785693",
        run = "rbxassetid://750783738",
        jump = "rbxassetid://750782230",
        climb = "rbxassetid://750779899",
        fall = "rbxassetid://750780242"
    }}
}

for _, animData in ipairs(animations) do
    local title, animIds = animData[1], animData[2]
    animationsTab:Button({
        Callback = function()
            local character = LocalPlayer.Character
            if character then
                local animate = character:FindFirstChild("Animate")
                if animate then
                    animate.idle.Animation1.AnimationId = animIds.idle1
                    animate.idle.Animation2.AnimationId = animIds.idle2 or animIds.idle1
                    animate.walk.WalkAnim.AnimationId = animIds.walk
                    animate.run.RunAnim.AnimationId = animIds.run
                    animate.jump.JumpAnim.AnimationId = animIds.jump
                    if animIds.climb then
                        animate.climb.ClimbAnim.AnimationId = animIds.climb
                    end
                    animate.fall.FallAnim.AnimationId = animIds.fall
                    
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.Jump = true
                    end
                end
            end
        end,
        Title = title,
        Justify = "Center",
    })
    
    animationsTab:Space()
end

local backpackTab = Window:Tab({
    Title = "背包区",
    Icon = "backpack",
})

backpackTab:Toggle({
    Value = false,
    Callback = function(value)
        if value then
            local getToolsConnection
            getToolsConnection = game:GetService("RunService").Heartbeat:Connect(function()
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer then
                        local backpack = player:FindFirstChild("Backpack")
                        if backpack then
                            for _, tool in ipairs(backpack:GetChildren()) do
                                if tool:IsA("Tool") then
                                    tool:Clone().Parent = LocalPlayer.Backpack
                                end
                            end
                        end
                    end
                end
            end)
        end
    end,
    Title = "获取所有玩家背包",
    Desc = "自动获取其他玩家的工具",
})

backpackTab:Button({
    Callback = function()
        local character = LocalPlayer.Character
        if character then
            local tool = character:FindFirstChildOfClass("Tool")
            if tool then
                Loaded_Main_Lua:Notify({
                    Icon = "package",
                    Title = "工具",
                    Content = "当前工具: " .. tool.Name,
                })
            end
        end
    end,
    Icon = "package",
    Title = "获取当前工具",
    Desc = "获取当前手持工具",
})

backpackTab:Button({
    Callback = function()
        local backpack = LocalPlayer.Backpack
        local equippedCount = 0
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = LocalPlayer.Character
                equippedCount = equippedCount + 1
            end
        end
        
        Loaded_Main_Lua:Notify({
            Icon = "check",
            Title = "成功",
            Content = "已装备 " .. equippedCount .. " 个工具",
        })
    end,
    Icon = "shield",
    Title = "装备全部工具",
    Desc = "装备背包中的所有工具",
})

backpackTab:Button({
    Callback = function()
        local character = LocalPlayer.Character
        if character then
            local tool = character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Destroy()
                Loaded_Main_Lua:Notify({
                    Icon = "check",
                    Title = "成功",
                    Content = "工具已删除",
                })
            end
        end
    end,
    Icon = "trash-2",
    Title = "删除工具",
    Desc = "删除当前手持工具",
})

local interactionTab = Window:Tab({
    Title = "交互区",
    Icon = "hand",
})

interactionTab:Paragraph({
    Title = "常见的交互有:长按E 开门 开宝箱 等",
})

interactionTab:Toggle({
    Value = false,
    Callback = function(value)
        if value then
            local autoInteractConnection
            autoInteractConnection = game:GetService("RunService").Heartbeat:Connect(function()
                for _, descendant in ipairs(workspace:GetDescendants()) do
                    if descendant:IsA("ProximityPrompt") then
                        fireproximityprompt(descendant)
                    end
                end
            end)
        end
    end,
    Title = "自动交互",
    Desc = "自动触发所有交互点",
})

local spectatorTab = Window:Tab({
    Title = "观战区",
    Icon = "eye",
})

local playerList = {}
local selectedPlayer = ""
local listMode = "用户名"

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        table.insert(playerList, listMode == "用户名" and player.Name or player.DisplayName)
    end
end

local playerDropdown = spectatorTab:Dropdown({
    Callback = function(value)
        selectedPlayer = value
    end,
    Title = "选择玩家",
    Values = playerList,
})

spectatorTab:Dropdown({
    Callback = function(value)
        listMode = value
        local newList = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(newList, listMode == "用户名" and player.Name or player.DisplayName)
            end
        end
        playerDropdown:Refresh(newList)
    end,
    Title = "选择玩家列表模式",
    Values = {"用户名", "显示名称"},
})

spectatorTab:Button({
    Callback = function()
        local newList = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(newList, listMode == "用户名" and player.Name or player.DisplayName)
            end
        end
        playerDropdown:Refresh(newList)
    end,
    Title = "刷新玩家列表",
    Icon = "refresh-cw",
})

spectatorTab:Toggle({
    Value = false,
    Callback = function(value)
        if value and selectedPlayer ~= "" then
            for _, player in ipairs(Players:GetPlayers()) do
                local playerName = listMode == "用户名" and player.Name or player.DisplayName
                if playerName == selectedPlayer then
                    local character = player.Character
                    if character then
                        workspace.CurrentCamera.CameraSubject = character:FindFirstChildOfClass("Humanoid")
                    end
                    return
                end
            end
        else
            workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        end
    end,
    Title = "观战此玩家",
    Desc = "切换到指定玩家视角",
})

local aimAssistTab = Window:Tab({
    Title = "自瞄区",
    Icon = "target",
    IconColor = Color3.fromHex("#EF4F1D"),
})

local aimSettings = {
    enabled = false,
    targetType = "Player",
    aimPart = "Head",
    maxDistance = 500,
    smoothAim = false,
    smoothness = 0.4,
    prediction = false,
    predictionStrength = 0.1,
    xOffset = 0,
    yOffset = 0,
    showFOV = false,
    useFOV = false,
    rainbowFOV = false,
    fovSize = 120,
    fovThickness = 2,
    fovColor = Color3.fromRGB(255, 0, 0)
}

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Radius = aimSettings.fovSize
fovCircle.Color = aimSettings.fovColor
fovCircle.Thickness = aimSettings.fovThickness
fovCircle.Position = workspace.CurrentCamera.ViewportSize / 2
fovCircle.Filled = false

aimAssistTab:Toggle({
    Title = "开启自瞄",
    Callback = function(value)
        aimSettings.enabled = value
    end,
})

aimAssistTab:Dropdown({
    Value = aimSettings.targetType,
    Callback = function(value)
        aimSettings.targetType = value
    end,
    Title = "瞄准目标",
    Values = {"Player", "NPC", "Both"},
})

aimAssistTab:Dropdown({
    Value = aimSettings.aimPart,
    Callback = function(value)
        aimSettings.aimPart = value
    end,
    Title = "瞄准部位",
    Values = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Torso"},
})

aimAssistTab:Slider({
    Min = 50,
    Title = "最大距离",
    Max = 1000,
    Callback = function(value)
        aimSettings.maxDistance = value
    end,
    Default = aimSettings.maxDistance,
})

aimAssistTab:Toggle({
    Title = "显示FOV圆圈",
    Callback = function(value)
        aimSettings.showFOV = value
        fovCircle.Visible = value
    end,
})

aimAssistTab:Toggle({
    Title = "使用FOV限制",
    Callback = function(value)
        aimSettings.useFOV = value
    end,
})

aimAssistTab:Toggle({
    Title = "彩虹FOV",
    Callback = function(value)
        aimSettings.rainbowFOV = value
    end,
})

aimAssistTab:Slider({
    Min = 50,
    Title = "FOV大小",
    Max = 300,
    Callback = function(value)
        aimSettings.fovSize = value
        fovCircle.Radius = value
    end,
    Default = aimSettings.fovSize,
})

aimAssistTab:Colorpicker({
    Callback = function(color)
        aimSettings.fovColor = color
        fovCircle.Color = color
    end,
    Title = "FOV颜色",
    Default = aimSettings.fovColor,
})

local espConfig = {
    enabled = false,
    teamCheck = false,
    wallhack = false,
    maxDistance = 2000,
    performanceMode = false,
    updateRate = 30,
    showBox = false,
    boxOutline = false,
    fillTransparency = 0.5,
    outlineTransparency = 0.2,
    showName = false,
    showHealth = false,
    showDistance = false,
    showWeapon = false,
    showBackpack = false,
    showTeam = false,
    textSize = 14,
    textOutline = true,
    showTracer = false,
    healthBarEnabled = false,
    healthBarDynamic = false,
    overallColor = "绿色",
    useDistanceFade = true,
    distanceScale = false,
    hideOnDeath = true
}

local espTab = Window:Tab({
    Title = "绘制区",
    Icon = "eye",
})

espTab:Toggle({
    Callback = function(value)
        espConfig.enabled = value
    end,
    Default = espConfig.enabled,
    Title = "启用 ESP",
    Desc = "开启/关闭 ESP 功能",
})

espTab:Toggle({
    Callback = function(value)
        espConfig.teamCheck = value
    end,
    Default = espConfig.teamCheck,
    Title = "队伍检测",
    Desc = "不显示同队玩家",
})

espTab:Toggle({
    Callback = function(value)
        espConfig.wallhack = value
    end,
    Default = espConfig.wallhack,
    Title = "穿墙显示",
    Desc = "显示墙壁后的玩家",
})

espTab:Slider({
    Title = "最大距离",
    Value = {Min = 100, Default = espConfig.maxDistance, Max = 5000},
    Callback = function(value)
        espConfig.maxDistance = value
    end,
    Step = 50,
    Desc = "显示玩家的最大距离",
})

espTab:Toggle({
    Callback = function(value)
        espConfig.performanceMode = value
        espConfig.updateRate = value and 15 or 30
    end,
    Default = espConfig.performanceMode,
    Title = "性能模式",
    Desc = "降低更新频率以提高性能",
})

espTab:Toggle({
    Callback = function(value)
        espConfig.showBox = value
    end,
    Title = "显示方框",
    Default = espConfig.showBox,
})

espTab:Toggle({
    Callback = function(value)
        espConfig.boxOutline = value
    end,
    Title = "方框描边",
    Default = espConfig.boxOutline,
})

espTab:Toggle({
    Callback = function(value)
        espConfig.showName = value
    end,
    Title = "显示玩家名",
    Default = espConfig.showName,
})

espTab:Toggle({
    Callback = function(value)
        espConfig.showHealth = value
    end,
    Title = "显示血量",
    Default = espConfig.showHealth,
})

espTab:Toggle({
    Callback = function(value)
        espConfig.showDistance = value
    end,
    Title = "显示距离",
    Default = espConfig.showDistance,
})

espTab:Toggle({
    Callback = function(value)
        espConfig.showWeapon = value
    end,
    Default = espConfig.showWeapon,
    Title = "显示武器",
    Desc = "显示玩家当前手持的武器",
})

espTab:Toggle({
    Callback = function(value)
        espConfig.showTracer = value
    end,
    Default = espConfig.showTracer,
    Title = "显示天线",
    Desc = "从屏幕位置连接到玩家",
})

espTab:Toggle({
    Callback = function(value)
        espConfig.healthBarEnabled = value
    end,
    Title = "显示血条",
    Default = espConfig.healthBarEnabled,
})

espTab:Dropdown({
    Title = "颜色选择",
    Value = espConfig.overallColor,
    Values = {"绿色", "红色", "蓝色", "黄色", "紫色", "橙色", "粉色", "青色", "白色"},
    Callback = function(value)
        espConfig.overallColor = value
    end,
    Desc = "选择ESP的显示颜色",
})

local rangeTab = Window:Tab({
    Title = "范围区",
    Icon = "target",
})

local rangeSettings = {
    enabled = false,
    size = 25,
    transparency = 0.7,
    color = "亮红色",
    material = "霓虹",
    noCollide = false,
    enemiesOnly = false,
    teamCheck = true,
    rainbowEffect = false,
    pulseEffect = false,
    glowEffect = false,
    showOutline = true,
    autoSize = false,
    adjustSpeed = 1
}

rangeTab:Toggle({
    Value = rangeSettings.enabled,
    Callback = function(value)
        rangeSettings.enabled = value
    end,
    Title = "范围开关",
    Desc = "启用或禁用范围功能",
})

rangeTab:Input({
    Callback = function(value)
        local num = tonumber(value)
        if num then
            rangeSettings.size = num
        end
    end,
    Placeholder = "输入大小",
    Title = "范围大小",
    Desc = "设置范围大小",
})

rangeTab:Slider({
    Title = "范围透明度",
    Value = {Min = 0, Default = rangeSettings.transparency, Max = 1},
    Callback = function(value)
        rangeSettings.transparency = value
    end,
    Step = 0.1,
    Desc = "设置范围透明度",
})

rangeTab:Dropdown({
    Title = "范围颜色",
    Value = rangeSettings.color,
    Values = {"亮红色", "鲜红色", "霓虹橙色", "亮黄色", "酸橙色", "亮绿色", "深蓝色", "亮蓝色", "皇家紫色", "亮粉色", "白色", "黑色"},
    Callback = function(value)
        rangeSettings.color = value
    end,
    Desc = "选择范围颜色",
})

rangeTab:Dropdown({
    Title = "范围材质",
    Value = rangeSettings.material,
    Values = {"霓虹", "塑料", "木材", "石板", "混凝土", "腐蚀金属", "钻石板", "箔纸", "草地", "冰面", "大理石", "花岗岩", "砖块", "鹅卵石", "沙子", "织物", "光滑塑料", "金属", "木地板", "鹅卵石路"},
    Callback = function(value)
        rangeSettings.material = value
    end,
    Desc = "选择范围材质",
})

rangeTab:Toggle({
    Value = rangeSettings.noCollide,
    Callback = function(value)
        rangeSettings.noCollide = value
    end,
    Title = "禁用碰撞",
    Desc = "禁用范围碰撞",
})

local uiSettingsTab = Window:Tab({
    Title = "UI设置",
    Icon = "settings",
})

uiSettingsTab:Dropdown({
    Value = "午夜",
    Callback = function(value)
        Loaded_Main_Lua:SetTheme(value)
    end,
    Title = "选择主题",
    Values = {"深色", "浅色", "玫瑰", "植物", "红色", "靛蓝", "天空", "紫罗兰", "琥珀", "翠绿", "午夜", "深红", "MonokaiPro", "棉花糖", "彩虹"},
})

uiSettingsTab:Button({
    Title = "销毁窗口",
    Callback = function()
        Window:Destroy()
    end,
})