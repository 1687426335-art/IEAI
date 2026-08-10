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

print("✅ 环境净化完成，LogService 干扰已禁用")

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
        Title = "<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#333333'>I</font> <font color='#666666'>S</font><font color='#444444'>C</font><font color='#222222'>R</font><font color='#111111'>I</font><font color='#000000'>P</font><font color='#000000'>T</font><font color='#FFAEC4'></font>",
        Folder = "ftgshub",
        NewElements = true,
        HideSearchBar = false,
        Size = UDim2.fromOffset(600, 450),
        Theme = "Dark",  
        UserEnabled = true,
        SideBarWidth = 135,
        HasOutline = true,
        Background = "video:https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/extracted_1_3.mp4",
        
        OpenButton = {
            Title = "<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#333333'>I</font> <font color='#666666'>S</font><font color='#444444'>C</font><font color='#222222'>R</font><font color='#111111'>I</font><font color='#000000'>P</font><font color='#000000'>T</font><font color='#FFAEC4'></font>",
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
    Title = "大司马团队破解",
    Radius = 10,  -- 改这里，数值越大越圆
    Color = Color3.fromHex("#ffffff"),
})

Window:Tag({
    Title = "大司马团队打死yg团队",
    Radius = 10,  -- 改这里
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
    Title = "服务器状态",
    Desc = [[
1.终极战场√
2.偷走一粒红√
3.自然灾害√
4.99个森林夜√
5.忍者传奇√
6.种植花园√
7.被遗弃√
8.Ohio√
9.doors√
10.刀刃球√
11.鱼√
12.最强战场√
13.赛马娘√
14.闪光√
15.狙击竞技场（正在添加）
16.无限旅馆（正在更新无法使用）
17.无限旅馆第2章√
18.凹凸世界（正在修）
19.兵工厂√
20.防御√
21.摧毁师（正在加）
22.破坏者谜团2√
23.po大po√
24.手枪竞技场√
25.卡塔娜竞技场√
26.撕咬之夜√
27.决斗场（正在更新无法使用）
28.nico的下一个机器人√
29.竞争对手√
30.枪地FFA√
31.数学谋杀案√
32.手枪竞技场√
33.犯罪√
34.鱼（正在更新）
35.GB√
36.力量传奇（正在更新）
37.战斗勇士（测试中）
38.死铁轨（更新中）
39.木筏101生存（有bug正在修）
40.51区√
    ]],
    BackgroundColor3 = Color3.fromHex("#FFFFFF"),  -- 白色背景
    BackgroundTransparency = 0,                     -- 0=完全不透明
    Color = Color3.fromHex("#000000"),              -- 黑色文字
    OutlineColor = Color3.fromHex("#CCCCCC"),       -- 浅灰边框
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

AboutTab:Button({
    Title = "XIAOXIV3全局汉化",
    Icon = "pausel",
    Color = Gray,
    Callback = function()
        local CoreGui = game:GetService("CoreGui")
        local RunService = game:GetService("RunService")

        local hintGui = Instance.new("ScreenGui")
        hintGui.Parent = CoreGui
        hintGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        local hintLabel = Instance.new("TextLabel")
        hintLabel.Parent = hintGui
        hintLabel.BackgroundTransparency = 1
        hintLabel.Position = UDim2.new(1, -20, 1, -40)
        hintLabel.AnchorPoint = Vector2.new(1, 1)
        hintLabel.Size = UDim2.new(0, 220, 0, 32)
        hintLabel.Font = Enum.Font.SourceSansBold
        hintLabel.TextSize = 20
        hintLabel.TextColor3 = Color3.new(1, 1, 1)
        hintLabel.TextStrokeTransparency = 0
        hintLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        hintLabel.Text = "bywdfex全局汉化已启动"

        task.delay(3, function()
            for i = 1, 0, -0.05 do
                hintLabel.TextTransparency = i
                hintLabel.TextStrokeTransparency = i
                RunService.Heartbeat:Wait()
            end
            hintGui:Destroy()
        end)

        local HttpService = game:GetService("HttpService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer

        local translationSpeed = 2
        local translatedTexts = {}

        local function translateText(text)
            if not text or text == "" or #text < 2 then return nil end
            if translatedTexts[text] then return translatedTexts[text] end

            local success, result = pcall(function()
                local url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=zh-CN&dt=t&q=" .. HttpService:UrlEncode(text)
                local response = game:HttpGet(url)
                local decoded = HttpService:JSONDecode(response)
                return decoded and decoded[1] and decoded[1][1] and decoded[1][1][1] or nil
            end)

            if success and result then
                translatedTexts[text] = result
                return result
            end
            return nil
        end

        local function isEnglish(text)
            if not text or text == "" then return false end
            local englishCount, totalCount = 0, 0
            for char in text:gmatch(".") do
                local byte = string.byte(char)
                if byte then
                    totalCount = totalCount + 1
                    if (byte >= 65 and byte <= 90) or (byte >= 97 and byte <= 122) then
                        englishCount = englishCount + 1
                    end
                end
            end
            return totalCount > 0 and (englishCount / totalCount) > 0.5
        end

        local function processTextObject(textObject)
            if not textObject:IsA("TextLabel") and not textObject:IsA("TextButton") and not textObject:IsA("TextBox") then return end
            local originalText = textObject.Text
            if not originalText or originalText == "" or not isEnglish(originalText) then return end
            local translatedText = translateText(originalText)
            if translatedText and translatedText ~= originalText then
                textObject.Text = translatedText
            end
        end

        local function scanAndTranslate(parent)
            for _, descendant in pairs(parent:GetDescendants()) do
                task.spawn(function()
                    processTextObject(descendant)
                end)
            end
        end

        local function onDescendantAdded(descendant)
            task.delay(0.1, function()
                processTextObject(descendant)
            end)
        end

        local function startTranslation()
            local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
            local playerGuiConnection = PlayerGui.DescendantAdded:Connect(onDescendantAdded)
            local coreGuiConnection = CoreGui.DescendantAdded:Connect(onDescendantAdded)
            
            local lastScanTime = tick()
            local scanInterval = 1.5 / translationSpeed
            local heartbeatConnection = RunService.Heartbeat:Connect(function()
                local currentTime = tick()
                if currentTime - lastScanTime >= scanInterval then
                    lastScanTime = currentTime
                    task.spawn(function() scanAndTranslate(PlayerGui) end)
                    pcall(function()
                        for _, gui in pairs(CoreGui:GetChildren()) do
                            if gui:IsA("ScreenGui") then task.spawn(function() scanAndTranslate(gui) end) end
                        end
                    end)
                end
            end)

            scanAndTranslate(PlayerGui)
            pcall(function()
                for _, gui in pairs(CoreGui:GetChildren()) do
                    if gui:IsA("ScreenGui") then scanAndTranslate(gui) end
                end
            end)

            return {
                PlayerGui = playerGuiConnection,
                CoreGui = coreGuiConnection,
                Heartbeat = heartbeatConnection
            }
        end

        local translationConnections = startTranslation()
        
        WindUI:Notify({
            Title = "汉化已启动",
            Content = "全局汉化成功",
            Icon = "check-circle",
            Duration = 3
        })
    end
})

    local ScriptTab = Window:Tab({
        Title = "支持服务器",
        Desc = "点击即可",
        Icon = "solar:code-square-bold",
        IconColor = Gray,
        IconShape = "Square",
        Border = true,
    })

    local ScriptSection = ScriptTab:Section({
        Title = "服务器列表",
        Description = "点击下方按钮执行对应脚本"
    })

     ScriptTab:Button({
        Title = "XIAOXI通用中心",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Mysterious-coral./refs/heads/main/XIAOXI%E9%80%9A%E7%94%A8%E9%80%9A%E7%9F%A5.lua"))() 
        end
    })

    -- 脚本按钮列表
    ScriptTab:Button({
        Title = "赛马娘",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Potato5466794/Wind/refs/heads/main/Wind.luau"))()

getgenv().TransparencyEnabled = getgenv().TransparencyEnabled or false





local function gradient(text, startColor, endColor)
    local result, chars = "", {}
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        chars[#chars + 1] = uchar
    end
    
    for i = 1, #chars do
        local t = (i - 1) / math.max(#chars - 1, 1)
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
            math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255), 
            math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255), 
            math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255), 
            chars[i])
    end
    return result
end

local themes = {"Dark", "Light", "Mocha", "Aqua"}
local currentThemeIndex = 1


local Window = WindUI:CreateWindow({
    Title = "<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#333333'>I</font> <font color='#666666'>S</font><font color='#444444'>C</font><font color='#222222'>R</font><font color='#111111'>I</font><font color='#000000'>P</font><font color='#000000'>T</font><font color='#FFAEC4'></font>",
    IconTransparency = 1,
    Author = "bywdfex",
    Folder = "XIAOXI",
    Size = UDim2.fromOffset(700, 500),
    Transparent = true,
    Theme = "Dark",
    UserEnabled = true,
    SideBarWidth = 220,
    HasOutline = true,
    Background = "video:https://raw.githubusercontent.com/xiaoxi9008/chesksks/refs/heads/main/VID_20260323_161157.mp4",
    ScrollBarEnabled = true
})

Window:Tag({
        Title = "wdefx",
        Radius = 10,
        Color = Color3.fromHex("#ffffff"),
    })

    Window:Tag({
        Title = "赛马娘",
        Radius = 10,
        Color = Color3.fromHex("#ffffff"),
    })



WindUI.Themes.Dark.Button = Color3.fromRGB(255, 255, 255)  
WindUI.Themes.Dark.ButtonBorder = Color3.fromRGB(255, 255, 255)  

local function addButtonBorderStyle()
    local mainFrame = Window.UIElements.Main
    if not mainFrame then return end
    
    local styleSheet = Instance.new("StyleSheet")
    styleSheet.Parent = mainFrame
    
    local rule = Instance.new("StyleRule")
    rule.Selector = "Button, ImageButton, TextButton"
    rule.Parent = styleSheet
    
    local borderProp = Instance.new("StyleProperty")
    borderProp.Name = "BorderSizePixel"
    borderProp.Value = 1
    borderProp.Parent = rule
    
    local colorProp = Instance.new("StyleProperty")
    colorProp.Name = "BorderColor3"
    colorProp.Value = Color3.fromRGB(255, 255, 255)
    colorProp.Parent = rule
end

Window:CreateTopbarButton("theme-switcher", "moon", function()
    local themes_list = {"Dark", "Light", "Mocha", "Aqua"}
    currentThemeIndex = (currentThemeIndex % #themes_list) + 1
    local newTheme = themes_list[currentThemeIndex]
    WindUI:SetTheme(newTheme)
    WindUI:Notify({
        Title = "主题已切换",
        Content = "当前主题: "..newTheme,
        Duration = 2
    })
end, 990)

WindUI.Themes.Dark.Toggle = Color3.fromHex("FF69B4")
WindUI.Themes.Dark.Checkbox = Color3.fromHex("FFB6C1")
WindUI.Themes.Dark.Button = Color3.fromHex("FF1493")
WindUI.Themes.Dark.Slider = Color3.fromHex("FF69B4")

local COLOR_SCHEMES = {
    ["彩虹颜色"] = {ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("FF0000")),
        ColorSequenceKeypoint.new(0.16, Color3.fromHex("FFA500")),
        ColorSequenceKeypoint.new(0.33, Color3.fromHex("FFFF00")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("00FF00")),
        ColorSequenceKeypoint.new(0.66, Color3.fromHex("0000FF")),
        ColorSequenceKeypoint.new(0.83, Color3.fromHex("4B0082")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("EE82EE"))
    }), "palette"},
    
    ["樱花粉1"] = {ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("FF69B4")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF1493")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("FFB6C1"))
    }), "candy"},

    ["樱花粉2"] = {ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("FED0E0")),
        ColorSequenceKeypoint.new(0.2, Color3.fromHex("FDBAD2")),
        ColorSequenceKeypoint.new(0.4, Color3.fromHex("FCA5C5")),
        ColorSequenceKeypoint.new(0.6, Color3.fromHex("FB8FB7")),
        ColorSequenceKeypoint.new(0.8, Color3.fromHex("FA7AA9")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("F9649B"))
    }), "waves"},
}

Window:EditOpenButton({
    Title = "<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#333333'>I</font> <font color='#666666'>S</font><font color='#444444'>C</font><font color='#222222'>R</font><font color='#111111'>I</font><font color='#000000'>P</font><font color='#000000'>T</font>",
    CornerRadius = UDim.new(16,16),
    StrokeThickness = 2,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 188, 217)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 153, 204)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 105, 180)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 192, 203))
    }),
    Draggable = true,
})

local function createRainbowBorder(window, colorScheme, speed)
    local mainFrame = window.UIElements.Main
    if not mainFrame then return nil end
    
    local existingStroke = mainFrame:FindFirstChild("RainbowStroke")
    if existingStroke then
        existingStroke:Destroy()
    end
    
    if not mainFrame:FindFirstChildOfClass("UICorner") then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 16)
        corner.Parent = mainFrame
    end
    
    local rainbowStroke = Instance.new("UIStroke")
    rainbowStroke.Name = "RainbowStroke"
    rainbowStroke.Thickness = 2
    rainbowStroke.Color = Color3.new(1, 1, 1)
    rainbowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    rainbowStroke.LineJoinMode = Enum.LineJoinMode.Round
    rainbowStroke.Parent = mainFrame
    
    local glowEffect = Instance.new("UIGradient")
    glowEffect.Name = "GlowEffect"
    
    local schemeData = COLOR_SCHEMES[colorScheme or "樱花粉2"]
    if schemeData then
        glowEffect.Color = schemeData[1]
    else
        glowEffect.Color = COLOR_SCHEMES["樱花粉2"][1]
    end
    
    glowEffect.Rotation = 0
    glowEffect.Parent = rainbowStroke
    
    return rainbowStroke
end

local function startBorderAnimation(window, speed)
    local mainFrame = window.UIElements.Main
    if not mainFrame then return nil end
    
    local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
    if not rainbowStroke then return nil end
    
    local glowEffect = rainbowStroke:FindFirstChild("GlowEffect")
    if not glowEffect then return nil end
    
    local animation = game:GetService("RunService").Heartbeat:Connect(function()
        if not rainbowStroke or rainbowStroke.Parent == nil then
            animation:Disconnect()
            return
        end
        
        local time = tick()
        glowEffect.Rotation = (time * speed * 60) % 360
    end)
    
    return animation
end

local borderAnimation
local borderEnabled = true
local currentColor = "樱花粉2"
local animationSpeed = 5

local rainbowStroke = createRainbowBorder(Window, currentColor, animationSpeed)
if rainbowStroke then
    borderAnimation = startBorderAnimation(Window, animationSpeed)
end

Window:SetToggleKey(Enum.KeyCode.F, true)

local Tabs = {
    Main = Window:Tab({ Title = "主页", Icon = "home" }),
    Elements = Window:Tab({ Title = "速度区", Icon = "layout-grid" }),
    Rage = Window:Tab({ Title = "体力区", Icon = "skull" }), 
    LoadScript = Window:Tab({ Title = "音乐区", Icon = "file" }), 
    Settings = Window:Tab({ Title = "设置", Icon = "settings" }),
    Config = Window:Tab({ Title = "配置", Icon = "save" })
}

-- ==================== 主页内容 ====================
Tabs.Main:Paragraph({
    Title = "欢迎使用XIAIXI赛马娘",
    Desc = "作者：wdfec｜赛马娘\n版本：v1.0.0\n\n本人亲自制作",
    ImageSize = 50,
    Thumbnail = "https://raw.githubusercontent.com/xiaoxi9008/chesksks/refs/heads/main/1357873301.jpg",
    ThumbnailSize = 170
})

Tabs.Main:Divider()

Tabs.Main:Button({
    Title = "显示欢迎通知",
    Icon = "bell",
    Callback = function()
        WindUI:Notify({
            Title = "欢迎!",
            Content = "感谢使用XIAOXI",
            Icon = "heart",
            Duration = 3
        })
    end
})

-- ==================== 速度选项卡 ====================
local elementSection = Tabs.Elements:Section({ Title = "速度（注意要过一分钟才能终点直接进终点就可以直接给你踢了）", Icon = "box", Opened = true })



local aimbotToggleState = false
local aimbotDemo = elementSection:Toggle({
    Title = "移速修改",
    Default = false,
    Callback = function(v)
        if v == true then
            sudu = game:GetService("RunService").Heartbeat:Connect(function()
                if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character.Humanoid and game:GetService("Players").LocalPlayer.Character.Humanoid.Parent then
                    if game:GetService("Players").LocalPlayer.Character.Humanoid.MoveDirection.Magnitude > 0 then
                        game:GetService("Players").LocalPlayer.Character:TranslateBy(game:GetService("Players").LocalPlayer.Character.Humanoid.MoveDirection * Speed / 10)
                    end
                end
            end)
        elseif not v and sudu then
            sudu:Disconnect()
            sudu = nil
        end
    end
})    
elementSection:Slider({
    Title = "速度设置",
    Value = {
        Min = 1,
        Max = 100,
        Default = 1,
    },
    Callback = function(Value)
        Speed = Value
    end
})




-- ==============================================
-- 暴力区内容
-- ==============================================

local RageSection = Tabs.Rage:Section({ Title = "体力设置" })

local oldNamecall = nil
local infiniteStaminaEnabled = false

RageSection:Toggle({
    Title = "无限体力",
    Value = false,
    Callback = function(value)
        infiniteStaminaEnabled = value
        if value then
            if not oldNamecall then
                oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                    if getnamecallmethod() == "FireServer" and tostring(self) == "RequestSprintAction" then
                        local args = {...}
                        if args[1] == "SpeedTarget" then
                            args[2] = 0
                            return oldNamecall(self, unpack(args))
                        end
                    end
                    return oldNamecall(self, ...)
                end)
            end
        else
            if oldNamecall then
                hookmetamethod(game, "__namecall", oldNamecall)
                oldNamecall = nil
            end
        end
    end
})

local RageSection = Tabs.Rage:Section({ Title = "演戏体力" })

RageSection:Slider({
    Title = "体力消耗值",
    Description = "0 = 10",
    Min = 0,
    Max = 10,
    Default = 0,
    StepRounding = 0,
    Callback = function(value)
        staminaCostValue = value
    end
})

-- 无限体力开关
RageSection:Toggle({
    Title = "体力开关",
    Value = false,
    Callback = function(value)
        infiniteStaminaEnabled = value
        if value then
            if not oldNamecall then
                oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                    if getnamecallmethod() == "FireServer" and tostring(self) == "RequestSprintAction" then
                        local args = {...}
                        if args[1] == "SpeedTarget" then
                            args[2] = staminaCostValue or 0
                            return oldNamecall(self, unpack(args))
                        end
                    end
                    return oldNamecall(self, ...)
                end)
            end
        else
            if oldNamecall then
                hookmetamethod(game, "__namecall", oldNamecall)
                oldNamecall = nil
            end
        end
    end
})
-- ==================== 加载脚本选项卡 ====================
Tabs.LoadScript:Paragraph({ -- 把 Scripts 改成 LoadScript
    Title = "加载其他脚本",
    Desc = "点击下方按钮加载对应的脚本"
})
Tabs.LoadScript:Divider() -- 把 Scripts 改成 LoadScript

Tabs.LoadScript:Button({ -- 把 Scripts 改成 LoadScript
    Title = "网易云音乐",
    Icon = "file",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/%E7%BD%91%E6%98%93%E4%BA%91.lua"))()
        end)
        if success then
            WindUI:Notify({
                Title = "加载成功",
                Content = "网易云音乐已加载",
                Type = "success"
            })
        else
            WindUI:Notify({
                Title = "加载失败",
                Content = "错误: " .. tostring(err),
                Type = "error"
            })
        end
    end
})
 
-- ==================== 设置选项卡 ====================
-- 边框设置区域

local borderSection = Tabs.Settings:Section({ Title = "边框设置", Icon = "square", Opened = true })

borderSection:Toggle({
    Title = "启用边框",
    Value = true,
    Callback = function(value)
        borderEnabled = value
        local mainFrame = Window.UIElements.Main
        if mainFrame then
            local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
            if rainbowStroke then
                rainbowStroke.Enabled = value
                if value and not borderAnimation then
                    borderAnimation = startBorderAnimation(Window, animationSpeed)
                elseif not value and borderAnimation then
                    borderAnimation:Disconnect()
                    borderAnimation = nil
                end
            end
        end
    end
})

local colorNames = {}
for name, _ in pairs(COLOR_SCHEMES) do
    table.insert(colorNames, name)
end

borderSection:Dropdown({
    Title = "颜色方案",
    Values = colorNames,
    Value = "樱花粉2",
    Callback = function(value)
        currentColor = value
        local mainFrame = Window.UIElements.Main
        if mainFrame then
            local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
            if rainbowStroke then
                local glowEffect = rainbowStroke:FindFirstChild("GlowEffect")
                if glowEffect then
                    local schemeData = COLOR_SCHEMES[value]
                    if schemeData then
                        glowEffect.Color = schemeData[1]
                    end
                end
            end
        end
    end
})

borderSection:Slider({
    Title = "动画速度",
    Value = {
        Min = 1,
        Max = 10,
        Default = 5,
    },
    Callback = function(value)
        animationSpeed = value
        if borderAnimation then
            borderAnimation:Disconnect()
            borderAnimation = nil
        end
        if borderEnabled then
            borderAnimation = startBorderAnimation(Window, animationSpeed)
        end
    end
})

borderSection:Slider({
    Title = "边框粗细",
    Value = {
        Min = 1,
        Max = 5,
        Default = 2,
    },
    Step = 0.5,
    Callback = function(value)
        local mainFrame = Window.UIElements.Main
        if mainFrame then
            local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
            if rainbowStroke then
                rainbowStroke.Thickness = value
            end
        end
    end
})

borderSection:Slider({
    Title = "圆角大小",
    Value = {
        Min = 0,
        Max = 30,
        Default = 16,
    },
    Callback = function(value)
        local mainFrame = Window.UIElements.Main
        if mainFrame then
            local corner = mainFrame:FindFirstChildOfClass("UICorner")
            if not corner then
                corner = Instance.new("UICorner")
                corner.Parent = mainFrame
            end
            corner.CornerRadius = UDim.new(0, value)
        end
    end
})

-- 外观设置区域
local appearanceSection = Tabs.Settings:Section({ Title = "外观设置", Icon = "brush", Opened = true })

local themes_list = {}
for themeName, _ in pairs(WindUI:GetThemes()) do
    table.insert(themes_list, themeName)
end
table.sort(themes_list)

local themeDropdown = appearanceSection:Dropdown({
    Title = "选择主题",
    Values = themes_list,
    Value = "Dark",
    Callback = function(theme)
        WindUI:SetTheme(theme)
        WindUI:Notify({
            Title = "主题已应用",
            Content = theme,
            Icon = "palette",
            Duration = 2
        })
    end
})

local transparencySlider = appearanceSection:Slider({
    Title = "透明度",
    Value = { 
        Min = 0,
        Max = 1,
        Default = 0.2,
    },
    Step = 0.1,
    Callback = function(value)
        Window:ToggleTransparency(tonumber(value) > 0)
        WindUI.TransparencyValue = tonumber(value)
    end
})

-- ==================== 配置选项卡 ====================
local configSection = Tabs.Config:Section({ Title = "配置管理", Icon = "settings", Opened = true })

configSection:Paragraph({
    Title = "配置管理器",
    Desc = "保存和加载你的设置",
    Image = "save",
    ImageSize = 20,
    Color = "White"
})

local configName = "default"
local configFile = nil
local MyPlayerData = {
    name = "Player1",
    level = 1,
    inventory = { "sword", "shield", "potion" }
}

configSection:Input({
    Title = "配置名称",
    Value = configName,
    Callback = function(value)
        configName = value
    end
})

local ConfigManager = Window.ConfigManager
if ConfigManager then
    ConfigManager:Init(Window)
    
    configSection:Button({
        Title = "保存配置",
        Icon = "save",
        Variant = "Primary",
        Callback = function()
            configFile = ConfigManager:CreateConfig(configName)
            
            configFile:Register("demo1", demo1)
            configFile:Register("themeDropdown", themeDropdown)
            configFile:Register("transparencySlider", transparencySlider)
            
            configFile:Set("playerData", MyPlayerData)
            configFile:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))
            
            if configFile:Save() then
                WindUI:Notify({ 
                    Title = "保存配置", 
                    Content = "已保存为: "..configName,
                    Icon = "check",
                    Duration = 3
                })
            else
                WindUI:Notify({ 
                    Title = "错误", 
                    Content = "保存配置失败",
                    Icon = "x",
                    Duration = 3
                })
            end
        end
    })

    configSection:Button({
        Title = "加载配置",
        Icon = "folder",
        Callback = function()
            configFile = ConfigManager:CreateConfig(configName)
            local loadedData = configFile:Load()
            
            if loadedData then
                if loadedData.playerData then
                    MyPlayerData = loadedData.playerData
                end
                
                local lastSave = loadedData.lastSave or "未知"
                WindUI:Notify({ 
                    Title = "加载配置", 
                    Content = "已加载: "..configName.."\n上次保存: "..lastSave,
                    Icon = "refresh-cw",
                    Duration = 5
                })
                
                configSection:Paragraph({
                    Title = "玩家数据",
                    Desc = string.format("名称: %s\n等级: %d\n物品: %s", 
                        MyPlayerData.name, 
                        MyPlayerData.level, 
                        table.concat(MyPlayerData.inventory, ", "))
                })
            else
                WindUI:Notify({ 
                    Title = "错误", 
                    Content = "加载配置失败",
                    Icon = "x",
                    Duration = 3
                })
            end
        end
    })
    
    -- 配置文件列表
    configSection:Button({
        Title = "列出所有配置",
        Icon = "list",
        Callback = function()
            local files = ConfigManager:ListConfigs()
            local fileList = "找到 "..#files.." 个配置:\n"
            for i, file in ipairs(files) do
                fileList = fileList .. i .. ". " .. file .. "\n"
            end
            WindUI:Notify({
                Title = "配置文件列表",
                Content = fileList,
                Duration = 5
            })
        end
    })
else
    configSection:Paragraph({
        Title = "配置管理器不可用",
        Desc = "此功能需要ConfigManager",
        Image = "alert-triangle",
        ImageSize = 20,
        Color = "White"
    })
end

-- 关于信息
local aboutSection = Tabs.Config:Section({ Title = "关于" })
aboutSection:Paragraph({
    Title = "群号",
    Desc = "\n作者：bywdfex\n\n赛马娘 v1.0.0",
    Image = "🐧",
    ImageSize = 20,
    Color = "Grey",
    Buttons = {
        {
            Title = "复制链接",
            Icon = "copy",
            Variant = "Tertiary",
            Callback = function()
                setclipboard("点击链接加入群聊【XIAOXI HUB新主群 [ 联邦 ]】：https://qun.qq.com/universal-share/share?ac=1&authKey=uxronKi8Dwy0M%2BHPaFABKnzV8WyrSFglO3Of1XoiXRiLAPhBjUsMtdNH9v8jtzfN&busi_data=eyJncm91cENvZGUiOiI1OTA2NDI0MjciLCJ0b2tlbiI6IjA1RGVNUVNmVGRaYXRtcHhCdGtjUTVuMjljbm1DYlc3TUFHYmZMTmJsUDFXTW9YcXREbDdtakdRdGsxTWpHa1EiLCJ1aW4iOiIzNTc0NzY5NDE1In0%3D&data=Al4_C1ij3U2uuYGj_vrlBtLmLlYlshk79tTG094L7oiov3r5WBW8KV_BKUQBiEzRttVcPVGPi0PIdXFtKmyomw&svctype=4&tempid=h5_group_info")
                WindUI:Notify({
                    Title = "已复制!",
                    Content = "qq主群链接已复制到剪贴板",
                    Duration = 2
                })
            end
        }
    }
})

-- 窗口关闭清理
Window:OnClose(function()
    print("窗口关闭")
    
    if borderAnimation then
        borderAnimation:Disconnect()
        borderAnimation = nil
    end
    
    if ConfigManager and configFile then
        configFile:Set("playerData", MyPlayerData)
        configFile:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))
        configFile:Save()
        print("配置已自动保存")
    end
end)

Window:OnDestroy(function()
    print("窗口已销毁")
end)
        end
    })

    ScriptTab:Button({
        Title = "po大po",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/拉大便.lua"))()   
        end
    })

    ScriptTab:Button({
        Title = "99个森林夜",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/XIAOXI%E4%BB%98%E8%B4%B9%E7%89%8899%E5%A4%9C.lua"))() 
        end
    })

    ScriptTab:Button({
    Title = "决斗场",
    Color = Color3.fromHex("999999"),
    Justify = "Center",
    Icon = "shredder",
    IconAlign = "Left",
    Callback = function()
        -- 播放音频
        local Sound = Instance.new("Sound")
        Sound.SoundId = "rbxassetid://4590662766"
        Sound.Parent = game:GetService("SoundService")
        Sound.Volume = 5
        Sound:Play()
        
        local repo = 'https://raw.githubusercontent.com/DevSloPo/obsidian_UI/main/'
        local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
        
        -- 显示通知
        Library:Notify({
            Title = "wdfex HUB",
            Description = "该服务器正在更新中无法加载",
            Time = 6
        })
        
        Sound.Ended:Wait()
        Sound:Destroy()
    end
})

    ScriptTab:Button({
        Title = "DOORS（推荐游玩）",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/DOORS通知.lua"))() 
        end
    })

    ScriptTab:Button({
        Title = "终极战场",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/终极战场通知.lua"))()
        end
    })

    ScriptTab:Button({
        Title = "最强战场",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/最强战场.lua"))() 
        end
    })

    ScriptTab:Button({
        Title = "手枪竞技场",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/XIAOXI%E6%89%8B%E6%9E%AA%E7%AB%9E%E6%8A%80%E5%9C%BA%E4%BB%98%E8%B4%B9%E7%89%88.lua"))()
        end
    })

    ScriptTab:Button({
        Title = "自然灾害",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/自然灾害.lua"))() 
        end
    })

    ScriptTab:Button({
        Title = "卡塔娜竞技场",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("http://121.43.37.20:8885/output/enc/084b2e5e3026"))() 
        end
    })

    ScriptTab:Button({
    Title = "PETAPETA（无限旅馆）",
    Color = Color3.fromHex("999999"),
    Justify = "Center",
    Icon = "shredder",
    IconAlign = "Left",
    Callback = function()
        -- 播放音频
        local Sound = Instance.new("Sound")
        Sound.SoundId = "rbxassetid://4590662766"
        Sound.Parent = game:GetService("SoundService")
        Sound.Volume = 5
        Sound:Play()
        
        local repo = 'https://raw.githubusercontent.com/DevSloPo/obsidian_UI/main/'
        local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
        
        -- 显示通知
        Library:Notify({
            Title = "wdfex HUB",
            Description = "该服务器正在更新中无法加载",
            Time = 6
        })
        
        Sound.Ended:Wait()
        Sound:Destroy()
    end
})

    ScriptTab:Button({
        Title = "防御",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/%E4%BB%98%E8%B4%B9%E7%89%88%E9%98%B2%E5%BE%A1XIAOXI.lua"))() 
        end
    })

    ScriptTab:Button({
        Title = "nico下一个机器人",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/XIAOXI的nico下一个机器.lua"))() 
        end
    })


ScriptTab:Button({
        Title = "PETAPETA无限旅馆第2章",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/XIAOXI无限旅馆第2章.lua"))() 
        end
    })

ScriptTab:Button({
        Title = "GB（内脏与黑火药）",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/GB通知.lua"))() 
        end
    })
    
ScriptTab:Button({
        Title = "GB（更新频率快）",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/GB通知2.lua"))() 
        end
    })

ScriptTab:Button({
        Title = "Forsaken（被遗弃）",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Mysterious-coral./refs/heads/main/XIAOXI%E4%BB%98%E8%B4%B9%E7%89%88%E8%A2%AB%E9%81%97%E5%BC%83%E9%80%9A%E7%9F%A5.lua"))() 
        end
    })

ScriptTab:Button({
        Title = "犯罪",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/%E7%8A%AF%E7%BD%AA%E9%80%9A%E7%9F%A5.lua"))() 
        end
    })
    
ScriptTab:Button({
        Title = "亡命速递",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/XIAOXI%E4%BB%98%E8%B4%B9%E7%89%88%E4%BA%A1%E5%91%BD%E9%80%9F%E9%80%92.lua"))() 
        end
    })
 
ScriptTab:Button({
        Title = "数学谋杀案（残疾人专用）",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/XIAOXI数学谋杀案.lua"))() 
        end
    })    

ScriptTab:Button({
        Title = "闪光",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/闪光.lua"))() 
        end
    })    
ScriptTab:Button({
        Title = "兵工厂",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/XIAOXI%E4%BB%98%E8%B4%B9%E5%85%B5%E5%B7%A5%E5%8E%82.lua"))() 
        end
    })    

ScriptTab:Button({
        Title = "枪地FFA",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/枪地FFA.lua"))() 
        end
    })    

ScriptTab:Button({
        Title = "将会发生一些邪恶的事",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/XIAOXIHUB将会发生一些邪恶的事.lua"))() 
        end
    })    

                                                 
    task.wait(0.5)

    -- 黑白渐变边框效果
    local function startGrayscaleBorder()
        local mainFrame = Window.UIElements and Window.UIElements.Main
        if not mainFrame then
            task.wait(0.2)
            mainFrame = Window.UIElements and Window.UIElements.Main
            if not mainFrame then
                warn("无法找到窗口主框架")
                return
            end
        end
        
        local corner = mainFrame:FindFirstChildOfClass("UICorner")
        if not corner then
            corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 16)
            corner.Parent = mainFrame
        end
        
        local oldStroke = mainFrame:FindFirstChild("GrayscaleStroke")
        if oldStroke then oldStroke:Destroy() end
        
        local colorScheme = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("FFFFFF")),
            ColorSequenceKeypoint.new(0.25, Color3.fromHex("CCCCCC")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("999999")),
            ColorSequenceKeypoint.new(0.75, Color3.fromHex("666666")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("333333"))
        })
        
        local stroke = Instance.new("UIStroke")
        stroke.Name = "GrayscaleStroke"
        stroke.Thickness = 3
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.LineJoinMode = Enum.LineJoinMode.Round
        stroke.Parent = mainFrame
        
        local gradient = Instance.new("UIGradient")
        gradient.Color = colorScheme
        gradient.Rotation = 0
        gradient.Parent = stroke
        
        local runService = game:GetService("RunService")
        local angle = 0
        local animationConnection = runService.Heartbeat:Connect(function(deltaTime)
            if not stroke or stroke.Parent == nil then
                animationConnection:Disconnect()
                return
            end
            angle = (angle + 180 * deltaTime) % 360
            gradient.Rotation = angle
        end)
        
        print("黑白渐变边框动画已启动")
        return animationConnection
    end

    startGrayscaleBorder()
end

WindUI:Popup({
    Title = "<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#333333'>I</font> <font color='#666666'>S</font><font color='#444444'>C</font><font color='#222222'>R</font><font color='#111111'>I</font><font color='#000000'>P</font><font color='#000000'>T</font>",
    IconThemed = true,
    Content = "尊贵wdfex脚本用户" .. game.Players.LocalPlayer.Name .. "使用<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#333333'>I</font> <font color='#666666'>S</font><font color='#444444'>C</font><font color='#222222'>R</font><font color='#111111'>I</font><font color='#000000'>P</font><font color='#000000'>T</font>圣奥里",
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