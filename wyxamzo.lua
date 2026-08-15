local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
WindUI.TransparencyValue = 0.2
WindUI:SetTheme("Dark")

local rainbowBorderAnimation
local currentBorderColorScheme = "彩虹颜色"
local currentFontColorScheme = "彩虹颜色"
local borderInitialized = false
local animationSpeed = 2
local borderEnabled = true
local fontColorEnabled = false
local uiScale = 1
local blurEnabled = false
local soundEnabled = true

local FONT_STYLES = {
    "SourceSansBold","SourceSansItalic","SourceSansLight","SourceSans",
    "GothamSSm","GothamSSm-Bold","GothamSSm-Medium","GothamSSm-Light",
    "GothamSSm-Black","GothamSSm-Book","GothamSSm-XLight","GothamSSm-Thin",
    "GothamSSm-Ultra","GothamSSm-SemiBold","GothamSSm-ExtraLight","GothamSSm-Heavy",
    "GothamSSm-ExtraBold","GothamSSm-Regular","Gotham","GothamBold",
    "GothamMedium","GothamBlack","GothamLight","Arial","ArialBold",
    "Code","CodeLight","CodeBold","Highway","HighwayBold","HighwayLight",
    "SciFi","SciFiBold","SciFiItalic","Cartoon","CartoonBold","Handwritten"
}

local FONT_DESCRIPTIONS = {
    ["SourceSansBold"] = "标准粗体",["SourceSansItalic"] = "斜体",["SourceSansLight"] = "细体",
    ["SourceSans"] = "标准体",["GothamSSm"] = "哥特标准",["GothamSSm-Bold"] = "哥特粗体",
    ["GothamSSm-Medium"] = "哥特中等",["GothamSSm-Light"] = "哥特细体",["GothamSSm-Black"] = "哥特黑体",
    ["GothamSSm-Book"] = "哥特书本体",["GothamSSm-XLight"] = "哥特超细体",["GothamSSm-Thin"] = "哥特极细体",
    ["GothamSSm-Ultra"] = "哥特超黑体",["GothamSSm-SemiBold"] = "哥特半粗体",["GothamSSm-ExtraLight"] = "哥特特细体",
    ["GothamSSm-Heavy"] = "哥特粗重体",["GothamSSm-ExtraBold"] = "哥特特粗体",["GothamSSm-Regular"] = "哥特常规体",
    ["Gotham"] = "经典哥特体",["GothamBold"] = "经典哥特粗体",["GothamMedium"] = "经典哥特中等",
    ["GothamBlack"] = "经典哥特黑体",["GothamLight"] = "经典哥特细体",["Arial"] = "标准Arial体",
    ["ArialBold"] = "Arial粗体",["Code"] = "代码字体",["CodeLight"] = "代码细体",
    ["CodeBold"] = "代码粗体",["Highway"] = "高速公路体",["HighwayBold"] = "高速公路粗体",
    ["HighwayLight"] = "高速公路细体",["SciFi"] = "科幻字体",["SciFiBold"] = "科幻粗体",
    ["SciFiItalic"] = "科幻斜体",["Cartoon"] = "卡通字体",["CartoonBold"] = "卡通粗体",
    ["Handwritten"] = "手写体"
}

local currentFontStyle = "SourceSansBold"

local COLOR_SCHEMES = {
    ["彩虹颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF0000")),ColorSequenceKeypoint.new(0.16, Color3.fromHex("FFA500")),ColorSequenceKeypoint.new(0.33, Color3.fromHex("FFFF00")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("00FF00")),ColorSequenceKeypoint.new(0.66, Color3.fromHex("0000FF")),ColorSequenceKeypoint.new(0.83, Color3.fromHex("4B0082")),ColorSequenceKeypoint.new(1, Color3.fromHex("EE82EE"))}),"palette"},
    ["黑红颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("000000")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF0000")),ColorSequenceKeypoint.new(1, Color3.fromHex("000000"))}),"alert-triangle"},
    ["蓝白颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FFFFFF")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("1E90FF")),ColorSequenceKeypoint.new(1, Color3.fromHex("FFFFFF"))}),"droplet"},
    ["紫金颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FFD700")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("8A2BE2")),ColorSequenceKeypoint.new(1, Color3.fromHex("FFD700"))}),"crown"},
    ["蓝黑颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("000000")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("0000FF")),ColorSequenceKeypoint.new(1, Color3.fromHex("000000"))}),"moon"},
    ["绿紫颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("00FF00")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("800080")),ColorSequenceKeypoint.new(1, Color3.fromHex("00FF00"))}),"zap"},
    ["粉蓝颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF69B4")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("00BFFF")),ColorSequenceKeypoint.new(1, Color3.fromHex("FF69B4"))}),"heart"},
    ["橙青颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF4500")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("00CED1")),ColorSequenceKeypoint.new(1, Color3.fromHex("FF4500"))}),"sun"},
    ["红金颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF0000")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FFD700")),ColorSequenceKeypoint.new(1, Color3.fromHex("FF0000"))}),"award"},
    ["银蓝颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("C0C0C0")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("4682B4")),ColorSequenceKeypoint.new(1, Color3.fromHex("C0C0C0"))}),"star"},
    ["霓虹颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF00FF")),ColorSequenceKeypoint.new(0.25, Color3.fromHex("00FFFF")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FFFF00")),ColorSequenceKeypoint.new(0.75, Color3.fromHex("FF00FF")),ColorSequenceKeypoint.new(1, Color3.fromHex("00FFFF"))}),"sparkles"},
    ["森林颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("228B22")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("32CD32")),ColorSequenceKeypoint.new(1, Color3.fromHex("228B22"))}),"tree"},
    ["火焰颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF4500")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF0000")),ColorSequenceKeypoint.new(1, Color3.fromHex("FF8C00"))}),"flame"},
    ["海洋颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("000080")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("1E90FF")),ColorSequenceKeypoint.new(1, Color3.fromHex("00BFFF"))}),"waves"},
    ["日落颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF4500")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF8C00")),ColorSequenceKeypoint.new(1, Color3.fromHex("FFD700"))}),"sunset"},
    ["银河颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("4B0082")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("8A2BE2")),ColorSequenceKeypoint.new(1, Color3.fromHex("9370DB"))}),"galaxy"},
    ["糖果颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF69B4")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF1493")),ColorSequenceKeypoint.new(1, Color3.fromHex("FFB6C1"))}),"candy"},
    ["金属颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("C0C0C0")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("A9A9A9")),ColorSequenceKeypoint.new(1, Color3.fromHex("696969"))}),"shield"}
}

local fontColorAnimations = {}

-- ============ 工具函数 ============
local function applyFontColorGradient(textElement, colorScheme)
    if not textElement or not textElement:IsA("TextLabel") and not textElement:IsA("TextButton") and not textElement:IsA("TextBox") then
        return
    end
    
    local existingGradient = textElement:FindFirstChild("FontColorGradient")
    if existingGradient then
        existingGradient:Destroy()
    end
    
    if fontColorAnimations[textElement] then
        fontColorAnimations[textElement]:Disconnect()
        fontColorAnimations[textElement] = nil
    end
    
    if not fontColorEnabled then
        textElement.TextColor3 = Color3.new(1, 1, 1)
        return
    end
    
    local schemeData = COLOR_SCHEMES[colorScheme or currentFontColorScheme]
    if not schemeData then return end
    
    local fontGradient = Instance.new("UIGradient")
    fontGradient.Name = "FontColorGradient"
    fontGradient.Color = schemeData[1]
    fontGradient.Rotation = 0
    fontGradient.Parent = textElement
    
    textElement.TextColor3 = Color3.new(1, 1, 1)
    
    local animation
    animation = game:GetService("RunService").Heartbeat:Connect(function()
        if not textElement or textElement.Parent == nil then
            animation:Disconnect()
            fontColorAnimations[textElement] = nil
            return
        end
        
        if not fontGradient or fontGradient.Parent == nil then
            animation:Disconnect()
            fontColorAnimations[textElement] = nil
            return
        end
        
        local time = tick()
        fontGradient.Rotation = (time * animationSpeed * 30) % 360
    end)
    
    fontColorAnimations[textElement] = animation
end

local function applyFontStyleToWindow(fontStyle)
    if not MainWindow or not MainWindow.UIElements then 
        wait(0.5)
        if not MainWindow or not MainWindow.UIElements then
            return false
        end
    end
    
    local successCount = 0
    local totalCount = 0
    
    local function processElement(element)
        for _, child in ipairs(element:GetDescendants()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                totalCount = totalCount + 1
                pcall(function()
                    child.Font = Enum.Font[fontStyle]
                    successCount = successCount + 1
                end)
            end
        end
    end
    
    processElement(MainWindow.UIElements.Main)
    
    return successCount, totalCount
end

local function applyFontColorsToWindow(colorScheme)
    if not MainWindow or not MainWindow.UIElements then return end
    
    local function processElement(element)
        for _, child in ipairs(element:GetDescendants()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                applyFontColorGradient(child, colorScheme)
            end
        end
    end
    
    processElement(MainWindow.UIElements.Main)
end

local function createRainbowBorder(window, colorScheme, speed)
    if not window or not window.UIElements then
        wait(1)
        if not window or not window.UIElements then
            return nil, nil
        end
    end
    
    local mainFrame = window.UIElements.Main
    if not mainFrame then
        return nil, nil
    end
    
    local existingStroke = mainFrame:FindFirstChild("RainbowStroke")
    if existingStroke then
        local glowEffect = existingStroke:FindFirstChild("GlowEffect")
        if glowEffect then
            local schemeData = COLOR_SCHEMES[colorScheme or currentBorderColorScheme]
            if schemeData then
                glowEffect.Color = schemeData[1]
            end
        end
        return existingStroke, rainbowBorderAnimation
    end
    
    if not mainFrame:FindFirstChildOfClass("UICorner") then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 16)
        corner.Parent = mainFrame
    end
    
    local rainbowStroke = Instance.new("UIStroke")
    rainbowStroke.Name = "RainbowStroke"
    rainbowStroke.Thickness = 1.5
    rainbowStroke.Color = Color3.new(1, 1, 1)
    rainbowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    rainbowStroke.LineJoinMode = Enum.LineJoinMode.Round
    rainbowStroke.Enabled = borderEnabled
    rainbowStroke.Parent = mainFrame
    
    local glowEffect = Instance.new("UIGradient")
    glowEffect.Name = "GlowEffect"
    
    local schemeData = COLOR_SCHEMES[colorScheme or currentBorderColorScheme]
    if schemeData then
        glowEffect.Color = schemeData[1]
    else
        glowEffect.Color = COLOR_SCHEMES["彩虹颜色"][1]
    end
    
    glowEffect.Rotation = 0
    glowEffect.Parent = rainbowStroke
    
    return rainbowStroke, nil
end

local function startBorderAnimation(window, speed)
    if not window or not window.UIElements then
        return nil
    end
    
    local mainFrame = window.UIElements.Main
    if not mainFrame then
        return nil
    end
    
    local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
    if not rainbowStroke or not rainbowStroke.Enabled then
        return nil
    end
    
    local glowEffect = rainbowStroke:FindFirstChild("GlowEffect")
    if not glowEffect then
        return nil
    end
    
    if rainbowBorderAnimation then
        rainbowBorderAnimation:Disconnect()
        rainbowBorderAnimation = nil
    end
    
    local animation
    animation = game:GetService("RunService").Heartbeat:Connect(function()
        if not rainbowStroke or rainbowStroke.Parent == nil or not rainbowStroke.Enabled then
            animation:Disconnect()
            return
        end
        
        local time = tick()
        glowEffect.Rotation = (time * speed * 60) % 360
    end)
    
    rainbowBorderAnimation = animation
    return animation
end

local function initializeRainbowBorder(scheme, speed)
    speed = speed or animationSpeed
    
    local rainbowStroke, _ = createRainbowBorder(MainWindow, scheme, speed)
    if rainbowStroke then
        if borderEnabled then
            startBorderAnimation(MainWindow, speed)
        end
        borderInitialized = true
        return true
    end
    return false
end

local function playSound()
    if soundEnabled then
        pcall(function()
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://9047002353"
            sound.Volume = 0.3
            sound.Parent = game:GetService("SoundService")
            sound:Play()
            game:GetService("Debris"):AddItem(sound, 2)
        end)
    end
end

local function applyBlurEffect(enabled)
    if enabled then
        pcall(function()
            local blur = Instance.new("BlurEffect")
            blur.Size = 8
            blur.Name = "UIwdfex HUBBlur"
            blur.Parent = game:GetService("Lighting")
        end)
    else
        pcall(function()
            local existingBlur = game:GetService("Lighting"):FindFirstChild("UIwdfex HUBBlur")
            if existingBlur then
                existingBlur:Destroy()
            end
        end)
    end
end

local function applyUIScale(scale)
    if MainWindow and MainWindow.UIElements and MainWindow.UIElements.Main then
        local mainFrame = MainWindow.UIElements.Main
        mainFrame.Size = UDim2.new(0, 600 * scale, 0, 400 * scale)
    end
end

local Confirmed = false
local username = game:GetService("Players").LocalPlayer.Name
local coloredUsername = ""
local gradientColors = {
    "#4169E1", 
    "#6A5ACD",  
    "#9370DB",  
    "#8A2BE2", 
    "#4B0082"   
}
local goldColor = "#FFD700"
for i = 1, #username do
    local char = username:sub(i, i)
    if char:match("[A-Za-z0-9]") then
        local colorIndex = (i - 1) % #gradientColors + 1
        coloredUsername = coloredUsername .. '<font color="' .. gradientColors[colorIndex] .. '">' .. char .. '</font>'
    else
        coloredUsername = coloredUsername .. '<font color="' .. goldColor .. '">' .. char .. '</font>'
    end
end

-- ============ 俄亥俄州功能变量 ============
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProximityPromptService = game:GetService("ProximityPromptService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character

if not Character then return end

local Humanoid = Character:WaitForChild("Humanoid", 5)
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart", 5)
local AirdropCallback = Instance.new("BindableFunction")

local RemotesModule = require(ReplicatedStorage.devv.client.Helpers.remotes.Signal)
local Remotes = debug.getupvalue(RemotesModule.FireServer, 1)
local ClientReplicator = require(ReplicatedStorage.devv.client.Helpers.objectProperties.ClientReplicator)
local Inventory = require(ReplicatedStorage.devv.client.Objects.v3item.modules.inventory)
local StateData = require(ReplicatedStorage.devv).load("state").data

local SelectedTarget = nil
local Whitelist = {
    2953444466,
    5509421902
}
local ItemsOnSaleList = {}
local Locations = {
    ["军械库"] = CFrame.new(671.68688964844, 6.2448601722717, -655.50268554688),
    ["银行"] = CFrame.new(1091.5296630859, 6.0434188842773, -457.62033081055),
    ["珠宝店"] = CFrame.new(1543.3168945312, 6.2433180809021, -682.63525390625),
    ["警察局"] = CFrame.new(655.10638427734, 9.035834312439, -903.20697021484),
    ["军事基地"] = CFrame.new(835.84875488281, 25.234800338745, -1327.0417480469),
    ["医院"] = CFrame.new(1112.4508056641, 6.0434203147888, -973.91772460938),
    ["游乐场"] = CFrame.new(1170.8796386719, 13.850684165955, -25.795112609863)
}

local WhitelistInput = nil
local FunTarget = nil
local FunTargetInput = nil
local SelectedItem = nil
local SelectedLocation = nil
local HitboxConnection = nil
local FastInteractConn = nil
local MainWindow = nil  -- 主窗口变量

-- ============ 俄亥俄州功能函数 ============
local function FindPlayer(input)
    local query = input:gsub("%s+", "")
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower():match("^" .. query:lower()) then
            return player
        end
        if player.DisplayName:lower():match("^" .. query:lower()) then
            return player
        end
    end
    WindUI:Notify({
        Title = "错误",
        Content = "未找到玩家",
        Duration = 2,
        Icon = "x"
    })
    return nil
end

local function RefreshItemESP()
    WindUI:Notify({
        Title = "物品透视",
        Content = "需要ESP库支持",
        Duration = 2,
        Icon = "eye"
    })
end

WindUI:Popup({
    Title = 'wdfex-HUB',
    IconThemed = true,
    Icon = "crown",
    Content = "欢迎尊重的用户 " .. coloredUsername .. " \n使用wdfex-HUB\n你的支持是我们更新的动力\n91",
    Buttons = {
        {
            Title = "取消",
            Callback = function() end,
            Variant = "Secondary",
        },
        {
            Title = "执行",
            Icon = "arrow-right",
            Callback = function() 
                Confirmed = true
                createUI()
            end,
            Variant = "Primary",
        }
    }
})

function createUI()
    MainWindow = WindUI:CreateWindow({
        Title = 'wdfex-HUB',
        Icon = "crown",
        IconThemed = true,
        Author = "当前版本：v1.0作者：wdfex",
        Folder = "CloudHub",
        Size = UDim2.fromOffset(300, 200),
        Transparent = true,
        Theme = "Dark",
        HideSearchBar = false,
        ScrollBarEnabled = true,
        Resizable = true,
        Background = "https://raw.githubusercontent.com/SQ182/y/c713ef1eeed1dc6b50e547dcbfee45034c385bf9/image_download_1768053890832.jpg",
        BackgroundImageTransparency = 0.5,
        User = {
            Enabled = true,
            Callback = function()
                WindUI:Notify({
                    Title = "点击了自己",
                    Content = "没什么", 
                    Duration = 1,
                    Icon = "4483362748"
                })
            end,
            Anonymous = false
        },
        SideBarWidth = 250,
        Search = {
            Enabled = true,
            Placeholder = "搜索...",
            Callback = function(searchText)
                print("搜索内容:", searchText)
            end
        },
        SidePanel = {
            Enabled = true,
            Content = {
                {
                    Type = "Button", 
                    Text = "",
                    Style = "Subtle", 
                    Size = UDim2.new(1, -20, 0, 30),
                    Callback = function()
                    end
                }
            }
        }
    })

    MainWindow:EditOpenButton({
        Title = "wdfex-HUB",
        Icon = "crown",
        CornerRadius = UDim.new(0,16),
        StrokeThickness = 4,
        Color = ColorSequence.new(Color3.fromHex("FF6B6B")),
        Draggable = true,
    })
    MainWindow:Tag({
        Title = "正在寻求",
        Color = Color3.fromHex("#00008B") 
    })
    MainWindow:Tag({
        Title = "3.0.1",
        Color = Color3.fromHex("#32CD32")
    })
    spawn(function()
        while true do
            for hue = 0, 1, 0.01 do  
                local color = Color3.fromHSV(hue, 0.8, 1)  
                MainWindow:EditOpenButton({
                    Color = ColorSequence.new(color)
                })
                wait(0.04)  
            end
        end
    end)
    if not borderInitialized then
        spawn(function()
            wait(0.5)
            initializeRainbowBorder("彩虹颜色", animationSpeed)
            wait(1)
            applyFontStyleToWindow(currentFontStyle)
        end)
    end

    local windowOpen = true

    MainWindow:OnClose(function()
        windowOpen = false
        if rainbowBorderAnimation then
            rainbowBorderAnimation:Disconnect()
            rainbowBorderAnimation = nil
        end
    end)

    local originalOpenFunction = MainWindow.Open
    MainWindow.Open = function(...)
        windowOpen = true
        local result = originalOpenFunction(...)
        
        if borderInitialized and borderEnabled and not rainbowBorderAnimation then
            wait(0.1)
            startBorderAnimation(MainWindow, animationSpeed)
        end
        
        return result
    end

    -- ============================================================
    -- 分类1: 通知
    -- ============================================================
    local infoTab = MainWindow:Tab({Title = "通知", Icon = "layout-grid", Locked = false})

    local infoSection = infoTab:Section({Title = "详情信息", Icon = "info", Opened = true})
    infoSection:Divider()
    infoSection:Paragraph({
        Title = "您当前的服务器为",
        Desc = "正在寻求\n欢迎使用此脚本",
        ThumbnailSize = 190,
    })
    infoSection:Paragraph({
        Title = "持续更新，有bug请提出来",
        ThumbnailSize = 190,
    })

    local infoSection2 = infoTab:Section({Title = "更新", Icon = "info", Opened = true})
    infoSection2:Paragraph({
        Title = "脚本已稳定发布",
        ThumbnailSize = 190,
    })
    infoSection2:Paragraph({
        Title = "已经更新了愤怒机器人",
        ThumbnailSize = 190,
    })
    infoSection2:Paragraph({
        Title = "更新自动抢银行",
        ThumbnailSize = 190,
    })

    -- ============================================================
    -- 分类2: 战斗类
    -- ============================================================
    local TabCombat = MainWindow:Tab({Title = "战斗类", Icon = "swords"})

    local combatSection1 = TabCombat:Section({Title = "秒杀设置", Icon = "swords", Opened = true})
    
    local onePunchValue = false
    combatSection1:Toggle({
        Title = "一拳秒杀",
        Default = onePunchValue,
        Callback = function(v)
            onePunchValue = v
            WindUI:Notify({
                Title = "一拳秒杀",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local oneSwingValue = false
    combatSection1:Toggle({
        Title = "其他近战武器秒杀",
        Default = oneSwingValue,
        Callback = function(v)
            oneSwingValue = v
            WindUI:Notify({
                Title = "近战秒杀",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local killAuraValue = false
    combatSection1:Toggle({
        Title = "杀戮光环",
        Default = killAuraValue,
        Callback = function(v)
            killAuraValue = v
            if v then
                pcall(function()
                    Remotes.FireServer("equip", Inventory.getFromName("Fists").guid)
                end)
            end
            WindUI:Notify({
                Title = "杀戮光环",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local stompAuraValue = false
    combatSection1:Toggle({
        Title = "踩人光环",
        Default = stompAuraValue,
        Callback = function(v)
            stompAuraValue = v
            WindUI:Notify({
                Title = "踩人光环",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local grabAuraValue = false
    combatSection1:Toggle({
        Title = "抓人光环",
        Default = grabAuraValue,
        Callback = function(v)
            grabAuraValue = v
            WindUI:Notify({
                Title = "抓人光环",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local killallValue = false
    combatSection1:Toggle({
        Title = "杀死全部",
        Default = killallValue,
        Callback = function(v)
            killallValue = v
            if v then
                pcall(function()
                    Remotes.FireServer("equip", Inventory.getFromName("Fists").guid)
                end)
            end
            if HumanoidRootPart then
                HumanoidRootPart.Anchored = v
            end
            if v then
                task.spawn(function()
                    while killallValue do
                        task.wait()
                        for _, player in pairs(Players:GetPlayers()) do
                            if not killallValue then break end
                            if player == LocalPlayer then continue end
                            if table.find(Whitelist, player.UserId) then continue end
                            local char = player.Character
                            if not char then continue end
                            local hum = char:FindFirstChildOfClass("Humanoid")
                            if not hum then continue end
                            if char:FindFirstChild("ForceField") then continue end
                            if hum.Health <= 5 then continue end
                            task.wait()
                            if Humanoid then Humanoid.Sit = false end
                            if Character and char.HumanoidRootPart then
                                Character:PivotTo(char.HumanoidRootPart.CFrame)
                            end
                            pcall(function()
                                Remotes.FireServer("meleeItemHit", "player", {
                                    meleeType = "meleemegapunch",
                                    hitPlayerId = player.UserId
                                })
                                Remotes.FireServer("stomp", player)
                            end)
                            task.wait(0.7)
                        end
                    end
                    if HumanoidRootPart then
                        HumanoidRootPart.Anchored = false
                    end
                end)
            else
                if HumanoidRootPart then
                    HumanoidRootPart.Anchored = false
                end
            end
            WindUI:Notify({
                Title = "杀死全部",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local autoEquipValue = false
    combatSection1:Toggle({
        Title = "死亡自动装备拳头",
        Default = autoEquipValue,
        Callback = function(v)
            autoEquipValue = v
            WindUI:Notify({
                Title = "自动装备",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local godmodeValue = false
    combatSection1:Toggle({
        Title = "防倒地",
        Default = godmodeValue,
        Callback = function(v)
            godmodeValue = v
            WindUI:Notify({
                Title = "防倒地",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local invisibleValue = false
    combatSection1:Toggle({
        Title = "隐身",
        Description = "可用枪械攻击",
        Default = invisibleValue,
        Callback = function(v)
            invisibleValue = v
            if v then
                pcall(function()
                    local savedCF = HumanoidRootPart.CFrame
                    Character:MoveTo(Vector3.new(-25.95, 84, 3537.55))
                    task.wait(0.15)
                    local chair = Instance.new("Seat", workspace)
                    chair.Anchored = false
                    chair.CanCollide = false
                    chair.Name = "invischair"
                    chair.Transparency = 1
                    chair.Position = Vector3.new(-25.95, 84, 3537.55)
                    local weld = Instance.new("Weld", chair)
                    weld.Part0 = chair
                    local torso = Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso")
                    if torso then
                        weld.Part1 = torso
                        task.wait()
                        Instance.new("Seat", workspace).CFrame = savedCF
                    end
                end)
            else
                local chair = workspace:FindFirstChild("invischair")
                if chair then chair:Remove() end
            end
            WindUI:Notify({
                Title = "隐身",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local rpgBombValue = false
    combatSection1:Toggle({
        Title = "RPG全图轰炸",
        Default = rpgBombValue,
        Callback = function(v)
            rpgBombValue = v
            if v then
                pcall(function()
                    if not Inventory.getFromName("RPG") then
                        Remotes.InvokeServer("attemptPurchase", "RPG")
                    end
                    task.spawn(function()
                        while rpgBombValue do
                            task.wait()
                            local item = Inventory.getEquippedItem()
                            if not item or item.name ~= "RPG" then 
                                task.wait(1)
                                continue 
                            end
                            for _, player in pairs(Players:GetPlayers()) do
                                if not rpgBombValue then break end
                                if player == LocalPlayer then continue end
                                if table.find(Whitelist, player.UserId) then continue end
                                local char = player.Character
                                if not char then continue end
                                local hum = char:FindFirstChildOfClass("Humanoid")
                                if not hum or hum.Health <= 10 then continue end
                                if char:FindFirstChild("ForceField") then continue end
                                pcall(function()
                                    Remotes.FireServer("rocketHit", "AmmoGuid", "explosionGUID", char.HumanoidRootPart.Position)
                                end)
                            end
                        end
                    end)
                end)
            end
            WindUI:Notify({
                Title = "RPG轰炸",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local autoArmorValue = false
    combatSection1:Toggle({
        Title = "自动穿甲",
        Default = autoArmorValue,
        Callback = function(v)
            autoArmorValue = v
            if v then
                task.spawn(function()
                    while autoArmorValue do
                        task.wait()
                        if not Character then continue end
                        local armor = LocalPlayer:GetAttribute("armor")
                        if not armor or armor <= 0 then
                            pcall(function()
                                Remotes.InvokeServer("attemptPurchase", "Light Vest")
                                local guid = Inventory.getFromName("Light Vest").guid
                                Remotes.FireServer("equip", guid)
                                Remotes.FireServer("useConsumable", guid)
                                Remotes.FireServer("removeItem", guid)
                            end)
                        end
                    end
                end)
            end
            WindUI:Notify({
                Title = "自动穿甲",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local combatSection2 = TabCombat:Section({Title = "子弹范围", Icon = "target", Opened = true})

    local hitboxValue = false
    local hitboxSize = "15"
    local hitboxTransparency = "0.8"
    combatSection2:Toggle({
        Title = "开关",
        Default = hitboxValue,
        Callback = function(v)
            hitboxValue = v
            if v then
                if HitboxConnection then HitboxConnection:Disconnect() end
                HitboxConnection = RunService.RenderStepped:Connect(function()
                    for _, player in next, Players:GetPlayers() do
                        pcall(function()
                            local size = tonumber(hitboxSize) or 15
                            local trans = tonumber(hitboxTransparency) or 0.8
                            player.Character.HumanoidRootPart.Size = Vector3.new(size, size, size)
                            player.Character.HumanoidRootPart.Transparency = trans
                            player.Character.HumanoidRootPart.Color = Color3.fromRGB(0, 0, 0)
                            player.Character.HumanoidRootPart.Material = "Neon"
                            player.Character.HumanoidRootPart.CanCollide = false
                        end)
                    end
                end)
            else
                if HitboxConnection then HitboxConnection:Disconnect() end
                task.wait()
                for _, player in next, Players:GetPlayers() do
                    pcall(function()
                        player.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                        player.Character.HumanoidRootPart.Transparency = 1
                        player.Character.HumanoidRootPart.Color = Color3.fromRGB(163, 162, 165)
                        player.Character.HumanoidRootPart.BrickColor = BrickColor.new("Medium stone grey")
                        player.Character.HumanoidRootPart.Material = "Plastic"
                        player.Character.HumanoidRootPart.CanCollide = false
                    end)
                end
            end
            WindUI:Notify({
                Title = "子弹范围",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    combatSection2:Input({
        Title = "输入大小",
        Placeholder = "15",
        Value = "15",
        Callback = function(v)
            hitboxSize = v
        end
    })

    combatSection2:Input({
        Title = "输入透明度",
        Placeholder = "0.8",
        Value = "0.8",
        Callback = function(v)
            hitboxTransparency = v
        end
    })

    local combatSection3 = TabCombat:Section({Title = "白名单", Icon = "shield", Opened = true})

    WhitelistInput = combatSection3:Input({
        Title = "输入名称 当前：无",
        Placeholder = "输入玩家名称",
        Value = "",
        Callback = function(v)
            local found = FindPlayer(v)
            if found then
                SelectedTarget = found
                WhitelistInput:SetTitle("输入名称 当前：" .. found.Name)
            else
                SelectedTarget = nil
                WhitelistInput:SetTitle("输入名称 当前：无")
            end
        end
    })

    combatSection3:Button({
        Title = "添加至白名单",
        Callback = function()
            if SelectedTarget then
                if not table.find(Whitelist, SelectedTarget.UserId) then
                    table.insert(Whitelist, SelectedTarget.UserId)
                    WindUI:Notify({
                        Title = "白名单",
                        Content = "已添加: " .. SelectedTarget.Name,
                        Duration = 2,
                        Icon = "check"
                    })
                else
                    WindUI:Notify({
                        Title = "错误",
                        Content = "该玩家已存在白名单中",
                        Duration = 2,
                        Icon = "x"
                    })
                end
            else
                WindUI:Notify({
                    Title = "错误",
                    Content = "请先输入玩家名称",
                    Duration = 2,
                    Icon = "x"
                })
            end
        end
    })

    combatSection3:Button({
        Title = "移除白名单",
        Callback = function()
            if SelectedTarget then
                local idx = table.find(Whitelist, SelectedTarget.UserId)
                if idx then
                    table.remove(Whitelist, idx)
                    WindUI:Notify({
                        Title = "白名单",
                        Content = "已移除: " .. SelectedTarget.Name,
                        Duration = 2,
                        Icon = "check"
                    })
                else
                    WindUI:Notify({
                        Title = "错误",
                        Content = "该玩家不在白名单中",
                        Duration = 2,
                        Icon = "x"
                    })
                end
            else
                WindUI:Notify({
                    Title = "错误",
                    Content = "请先输入玩家名称",
                    Duration = 2,
                    Icon = "x"
                })
            end
        end
    })

    combatSection3:Button({
        Title = "清空白名单",
        Callback = function()
            table.clear(Whitelist)
            WindUI:Notify({
                Title = "白名单",
                Content = "已清空所有白名单",
                Duration = 2,
                Icon = "check"
            })
        end
    })

    -- ============================================================
    -- 分类3: 物品
    -- ============================================================
    local TabItems = MainWindow:Tab({Title = "物品", Icon = "box"})

    local itemSection = TabItems:Section({Title = "物品购买", Icon = "shopping-cart", Opened = true})

    local itemValues = (function()
        local list = {}
        for k in pairs(ItemsOnSaleList) do
            table.insert(list, k)
        end
        table.sort(list)
        return list
    end)()

    if #itemValues == 0 then
        table.insert(itemValues, "无物品")
    end

    itemSection:Dropdown({
        Title = "选择物品",
        Values = itemValues,
        Value = itemValues[1] or "无物品",
        Callback = function(v)
            SelectedItem = v
        end
    })

    itemSection:Button({
        Title = "购买",
        Callback = function()
            if SelectedItem and SelectedItem ~= "无物品" then
                pcall(function()
                    Remotes.InvokeServer("attemptPurchase", SelectedItem)
                    WindUI:Notify({
                        Title = "购买",
                        Content = "正在购买: " .. SelectedItem,
                        Duration = 2,
                        Icon = "check"
                    })
                end)
            else
                WindUI:Notify({
                    Title = "错误",
                    Content = "请先选择物品",
                    Duration = 2,
                    Icon = "x"
                })
            end
        end
    })

    itemSection:Button({
        Title = "购买子弹",
        Callback = function()
            if SelectedItem and SelectedItem ~= "无物品" then
                pcall(function()
                    Remotes.InvokeServer("attemptPurchaseAmmo", SelectedItem)
                    WindUI:Notify({
                        Title = "购买子弹",
                        Content = "正在购买: " .. SelectedItem,
                        Duration = 2,
                        Icon = "check"
                    })
                end)
            else
                WindUI:Notify({
                    Title = "错误",
                    Content = "请先选择物品",
                    Duration = 2,
                    Icon = "x"
                })
            end
        end
    })

    local showBuyUIValue = false
    itemSection:Toggle({
        Title = "显示购买界面",
        Default = showBuyUIValue,
        Callback = function(v)
            showBuyUIValue = v
            if v then
                task.spawn(function()
                    while showBuyUIValue do
                        task.wait()
                        if not SelectedItem or SelectedItem == "无物品" then continue end
                        pcall(function()
                            local itemNode = workspace.ItemsOnSale:FindFirstChild(SelectedItem)
                            if itemNode then
                                local td = itemNode:FindFirstChildOfClass("TouchDetector")
                                if td then
                                    firetouchinterest(td.Parent, HumanoidRootPart, 0)
                                    firetouchinterest(td.Parent, HumanoidRootPart, 1)
                                end
                            end
                        end)
                    end
                end)
            end
            WindUI:Notify({
                Title = "购买界面",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local blackMarketValue = false
    itemSection:Toggle({
        Title = "远程黑市",
        Default = blackMarketValue,
        Callback = function(v)
            blackMarketValue = v
            pcall(function()
                workspace.BlackMarket.Dealer.Dealer.ProximityPrompt.MaxActivationDistance = v and 10000 or 20
            end)
            WindUI:Notify({
                Title = "远程黑市",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local lockerValue = false
    itemSection:Toggle({
        Title = "远程储物柜",
        Description = "打开背包即可",
        Default = lockerValue,
        Callback = function(v)
            lockerValue = v
            pcall(function()
                LocalPlayer.PlayerGui.Backpack.Holder.Locker.Visible = v
            end)
            WindUI:Notify({
                Title = "远程储物柜",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local fastInteractValue = false
    itemSection:Toggle({
        Title = "快速互动",
        Default = fastInteractValue,
        Callback = function(v)
            fastInteractValue = v
            if v then
                FastInteractConn = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
                    fireproximityprompt(prompt)
                end)
            else
                if FastInteractConn then FastInteractConn:Disconnect() end
            end
            WindUI:Notify({
                Title = "快速互动",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local itemESPValue = false
    itemSection:Toggle({
        Title = "透视物品",
        Default = itemESPValue,
        Callback = function(v)
            itemESPValue = v
            if v then
                RefreshItemESP()
            end
            WindUI:Notify({
                Title = "透视物品",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    -- ============================================================
    -- 分类4: 自动
    -- ============================================================
    local TabAuto = MainWindow:Tab({Title = "自动", Icon = "zap"})

    local autoSection = TabAuto:Section({Title = "自动农场", Icon = "zap", Opened = true})

    local atmFarmValue = false
    autoSection:Toggle({
        Title = "自动打ATM",
        Default = atmFarmValue,
        Callback = function(v)
            atmFarmValue = v
            if v then
                pcall(function()
                    Remotes.FireServer("equip", Inventory.getFromName("Fists").guid)
                end)
                task.spawn(function()
                    while atmFarmValue do
                        task.wait()
                        for _, atm in pairs(workspace.Game.Props.ATM:GetChildren()) do
                            if not atmFarmValue then break end
                            if atm:GetAttribute("state") ~= "destroyed" then
                                while atm:GetAttribute("state") ~= "destroyed" and atmFarmValue do
                                    task.wait()
                                    pcall(function()
                                        Character:PivotTo(atm:GetPivot())
                                        Remotes.FireServer("meleeItemHit", "prop", {
                                            meleeType = "meleepunch",
                                            guid = atm:GetAttribute("guid")
                                        })
                                    end)
                                end
                                task.wait(1)
                                for _, bundle in pairs(workspace.Game.Entities.CashBundle:GetChildren()) do
                                    local cd = bundle:FindFirstChildOfClass("ClickDetector")
                                    if cd and (HumanoidRootPart.Position - bundle:GetPivot().Position).Magnitude <= cd.MaxActivationDistance then
                                        fireclickdetector(cd)
                                        task.wait(0.5)
                                    end
                                end
                            end
                        end
                    end
                end)
            end
            WindUI:Notify({
                Title = "自动打ATM",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local registerFarmValue = false
    autoSection:Toggle({
        Title = "自动打收银机",
        Default = registerFarmValue,
        Callback = function(v)
            registerFarmValue = v
            if v then
                pcall(function()
                    Remotes.FireServer("equip", Inventory.getFromName("Fists").guid)
                end)
                task.spawn(function()
                    while registerFarmValue do
                        task.wait()
                        for _, reg in pairs(workspace.Game.Props.CashRegister:GetChildren()) do
                            if not registerFarmValue then break end
                            if reg:GetAttribute("state") ~= "destroyed" then
                                while reg:GetAttribute("state") ~= "destroyed" and registerFarmValue do
                                    task.wait()
                                    pcall(function()
                                        Character:PivotTo(reg:GetPivot())
                                        Remotes.FireServer("meleeItemHit", "prop", {
                                            meleeType = "meleepunch",
                                            guid = reg:GetAttribute("guid")
                                        })
                                    end)
                                end
                                task.wait(1)
                                for _, bundle in pairs(workspace.Game.Entities.CashBundle:GetChildren()) do
                                    local cd = bundle:FindFirstChildOfClass("ClickDetector")
                                    if cd and (HumanoidRootPart.Position - bundle:GetPivot().Position).Magnitude <= cd.MaxActivationDistance then
                                        fireclickdetector(cd)
                                        task.wait(0.5)
                                    end
                                end
                            end
                        end
                    end
                end)
            end
            WindUI:Notify({
                Title = "自动打收银机",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local autoRobBankValue = false
    autoSection:Toggle({
        Title = "自动抢银行",
        Default = autoRobBankValue,
        Callback = function(v)
            autoRobBankValue = v
            if v then
                task.spawn(function()
                    while autoRobBankValue do
                        pcall(function()
                            local cash = workspace.BankRobbery.BankCash.Cash
                            repeat task.wait() until #cash:GetChildren() ~= 0
                            HumanoidRootPart.CFrame = workspace.BankRobbery.VaultDoor.Door.CFrame
                            fireproximityprompt(workspace.BankRobbery.VaultDoor.Door.Attachment.ProximityPrompt)
                            task.wait(0.5)
                            repeat task.wait() until not workspace.BankRobbery.VaultDoor.Door.Attachment.ProximityPrompt.Enabled
                            HumanoidRootPart.CFrame = workspace.BankRobbery.BankCash.Pallet.CFrame
                            fireproximityprompt(workspace.BankRobbery.BankCash.Main.Attachment.ProximityPrompt)
                            task.wait(0.5)
                            task.wait()
                        end)
                    end
                end)
            end
            WindUI:Notify({
                Title = "自动抢银行",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local cashFarmValue = false
    autoSection:Toggle({
        Title = "自动捡钱(未测试)",
        Default = cashFarmValue,
        Callback = function(v)
            cashFarmValue = v
            if v then
                task.spawn(function()
                    while cashFarmValue do
                        task.wait()
                        for _, bundle in pairs(workspace.Game.Entities.CashBundle:GetChildren()) do
                            if not cashFarmValue then break end
                            local cd = bundle:FindFirstChildOfClass("ClickDetector")
                            if cd then
                                pcall(function()
                                    Character:PivotTo(bundle:GetPivot())
                                    task.wait(0.5)
                                    fireclickdetector(cd)
                                    task.wait(1)
                                end)
                            end
                        end
                    end
                end)
            end
            WindUI:Notify({
                Title = "自动捡钱",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local cashAuraValue = false
    autoSection:Toggle({
        Title = "捡钱光环",
        Default = cashAuraValue,
        Callback = function(v)
            cashAuraValue = v
            if v then
                task.spawn(function()
                    while cashAuraValue do
                        for _, bundle in pairs(workspace.Game.Entities.CashBundle:GetChildren()) do
                            local cd = bundle:FindFirstChildOfClass("ClickDetector")
                            if cd and (HumanoidRootPart.Position - bundle:GetPivot().Position).Magnitude <= cd.MaxActivationDistance then
                                fireclickdetector(cd)
                            end
                        end
                        wait(0.25)
                    end
                end)
            end
            WindUI:Notify({
                Title = "捡钱光环",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local itemFarmValue = false
    autoSection:Toggle({
        Title = "自动捡物品",
        Default = itemFarmValue,
        Callback = function(v)
            itemFarmValue = v
            if v then
                task.spawn(function()
                    while itemFarmValue do
                        task.wait()
                        for _, item in pairs(workspace.Game.Entities.ItemPickup:GetChildren()) do
                            if not itemFarmValue then break end
                            local cd = item:FindFirstChildWhichIsA("ClickDetector", true)
                            if cd then
                                pcall(function()
                                    Character:PivotTo(cd.Parent.CFrame)
                                    task.wait(0.5)
                                    fireclickdetector(cd)
                                    task.wait(1.5)
                                end)
                            end
                        end
                    end
                end)
            end
            WindUI:Notify({
                Title = "自动捡物品",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local itemAuraValue = false
    autoSection:Toggle({
        Title = "捡物品光环",
        Default = itemAuraValue,
        Callback = function(v)
            itemAuraValue = v
            if v then
                task.spawn(function()
                    while itemAuraValue do
                        for _, item in pairs(workspace.Game.Entities.ItemPickup:GetChildren()) do
                            if not itemAuraValue then
                                wait(0.25)
                                continue
                            end
                            pcall(function()
                                local cd = item:FindFirstChildWhichIsA("ClickDetector", true)
                                if cd and (HumanoidRootPart.Position - item:GetPivot().Position).Magnitude <= cd.MaxActivationDistance then
                                    fireclickdetector(cd)
                                end
                            end)
                        end
                    end
                end)
            end
            WindUI:Notify({
                Title = "捡物品光环",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local selectedItemsValue = {}
    autoSection:Dropdown({
        Title = "选择物品",
        Values = {"红卡", "蓝卡", "印钞机", "气球"},
        Multi = true,
        Value = {},
        Callback = function(v)
            selectedItemsValue = v
        end
    })

    local sItemsFarmValue = false
    autoSection:Toggle({
        Title = "自动捡选中的物品",
        Default = sItemsFarmValue,
        Callback = function(v)
            sItemsFarmValue = v
            if v then
                task.spawn(function()
                    while sItemsFarmValue do
                        task.wait()
                        for _, item in pairs(workspace.Game.Entities.ItemPickup:GetDescendants()) do
                            if not sItemsFarmValue then break end
                            if item:IsA("ProximityPrompt") then
                                local match = (selectedItemsValue["红卡"] and item.ObjectText == "Military Armory Keycard")
                                    or (selectedItemsValue["蓝卡"] and item.ObjectText == "Police Armory Keycard")
                                    or (selectedItemsValue["印钞机"] and item.ObjectText == "Money Printer")
                                    or (selectedItemsValue["气球"] and item.ObjectText:match("Balloon"))
                                if match then
                                    pcall(function()
                                        local savedCF = HumanoidRootPart.CFrame
                                        Character:PivotTo(item.Parent:GetPivot())
                                        task.wait()
                                        for i = 1, 5 do
                                            fireproximityprompt(item)
                                            task.wait(0.1)
                                        end
                                        Character:PivotTo(savedCF)
                                        wait(1.5)
                                    end)
                                end
                            end
                        end
                    end
                end)
            end
            WindUI:Notify({
                Title = "自动捡选中物品",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local returnOnTeleportValue = false
    autoSection:Toggle({
        Title = "是否回传",
        Default = returnOnTeleportValue,
        Callback = function(v)
            returnOnTeleportValue = v
            WindUI:Notify({
                Title = "回传",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local notifyAirdropValue = false
    autoSection:Toggle({
        Title = "空投刷新提示",
        Default = notifyAirdropValue,
        Callback = function(v)
            notifyAirdropValue = v
            WindUI:Notify({
                Title = "空投提示",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    autoSection:Button({
        Title = "自动换服寻找印钞机",
        Callback = function()
            WindUI:Notify({
                Title = "使用说明",
                Content = "如果您的注入器不受脚本支持\n请在手机目录/执行器/Autoexec文件夹添加脚本",
                Duration = 5,
                Icon = "info"
            })
        end
    })

    -- ============================================================
    -- 分类5: 传送
    -- ============================================================
    local TabTeleport = MainWindow:Tab({Title = "传送", Icon = "map-pin"})

    local teleSection = TabTeleport:Section({Title = "地点传送", Icon = "map-pin", Opened = true})

    local locationValues = (function()
        local list = {}
        for k in pairs(Locations) do
            table.insert(list, k)
        end
        return list
    end)()

    teleSection:Dropdown({
        Title = "选择地点",
        Values = locationValues,
        Value = locationValues[1] or "无",
        Callback = function(v)
            SelectedLocation = v
        end
    })

    teleSection:Button({
        Title = "传送",
        Callback = function()
            if SelectedLocation and Locations[SelectedLocation] then
                pcall(function()
                    Character:PivotTo(Locations[SelectedLocation])
                    WindUI:Notify({
                        Title = "传送",
                        Content = "已传送到: " .. SelectedLocation,
                        Duration = 2,
                        Icon = "check"
                    })
                end)
            else
                WindUI:Notify({
                    Title = "错误",
                    Content = "请先选择地点",
                    Duration = 2,
                    Icon = "x"
                })
            end
        end
    })

    -- ============================================================
    -- 分类6: 娱乐
    -- ============================================================
    local TabFun = MainWindow:Tab({Title = "娱乐", Icon = "settings"})

    local funSection = TabFun:Section({Title = "娱乐功能", Icon = "smile", Opened = true})

    FunTargetInput = funSection:Input({
        Title = "输入名称 当前：无",
        Placeholder = "输入玩家名称",
        Value = "",
        Callback = function(v)
            local found = FindPlayer(v)
            FunTarget = found
            if found then
                FunTargetInput:SetTitle("输入名称 当前：" .. found.Name)
            else
                FunTargetInput:SetTitle("输入名称 当前：无")
            end
        end
    })

    local spamMessageValue = "XA-Hub No.1"
    funSection:Input({
        Title = "输入消息",
        Placeholder = "XA-Hub No.1",
        Value = "XA-Hub No.1",
        Callback = function(v)
            spamMessageValue = v
        end
    })

    local spamPlayerValue = false
    funSection:Toggle({
        Title = "消息轰炸",
        Default = spamPlayerValue,
        Callback = function(v)
            spamPlayerValue = v
            if v then
                if not FunTarget then
                    WindUI:Notify({
                        Title = "错误",
                        Content = "请先输入玩家名称",
                        Duration = 2,
                        Icon = "x"
                    })
                    return
                end
                task.spawn(function()
                    while spamPlayerValue do
                        task.wait(0.2)
                        pcall(function()
                            Remotes.FireServer("sendMessage", FunTarget.UserId, spamMessageValue)
                        end)
                    end
                end)
            end
            WindUI:Notify({
                Title = "消息轰炸",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local spamCallValue = false
    funSection:Toggle({
        Title = "电话骚扰",
        Default = spamCallValue,
        Callback = function(v)
            spamCallValue = v
            if v then
                if not FunTarget then
                    WindUI:Notify({
                        Title = "错误",
                        Content = "请先输入玩家名称",
                        Duration = 2,
                        Icon = "x"
                    })
                    return
                end
                task.spawn(function()
                    while spamCallValue do
                        task.wait(0.2)
                        pcall(function()
                            Remotes.InvokeServer("attemptCall", FunTarget.UserId)
                        end)
                    end
                end)
            end
            WindUI:Notify({
                Title = "电话骚扰",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local spamAllValue = false
    funSection:Toggle({
        Title = "消息轰炸全体",
        Default = spamAllValue,
        Callback = function(v)
            spamAllValue = v
            if v then
                task.spawn(function()
                    while spamAllValue do
                        task.wait(0.2)
                        for _, player in pairs(Players:GetPlayers()) do
                            if not spamAllValue then break end
                            pcall(function()
                                Remotes.FireServer("sendMessage", player.UserId, spamMessageValue)
                            end)
                        end
                    end
                end)
            end
            WindUI:Notify({
                Title = "消息轰炸全体",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    -- 原有发言功能
    funSection:Divider()
    funSection:Paragraph({
        Title = "自动发言",
        Desc = "WindUI内置发言功能",
        Icon = "message-circle",
        ThumbnailSize = 190,
    })

    _G.AUTO_CHAT_TEXT = "wdfex-HUB ！！！"
    _G.AUTO_CHAT_ENABLED = false
    _G.AUTO_CHAT_INTERVAL = 1.5
    _G.AUTO_CHAT_MODE = "自定义"

    local chatSystem = {
        Players = game:GetService("Players"),
        ReplicatedStorage = game:GetService("ReplicatedStorage"),
        TextChatService = game:GetService("TextChatService"),
        messageIndex = 1,
        messageCount = 0,
        lastMessageTime = 0,
        chatModes = {
            ["自定义"] = function() return {_G.AUTO_CHAT_TEXT} end,
            ["7字经"] = function() return {"我妈死了", "我妈死了", "我是sz", "我妈死了", "我18码了", "我在这等着呢", "快来打压我"} end,
            ["14字经"] = function() return {"你有啥用", "你活着干啥呢", "赶紧跳了吧", "老弟家里几位在哪里", "来吧赶紧让我口吃", "你爹等着你呢", "你个窝囊废", "孩子快来呀", "怎么不敢和你爹对话了？", "你有什么用处", "你活着当技女吗？", "一句话", "来打压我", "哈哈哈笑死我了"} end,
            ["糖人语言"] = function() return {"我是奶龙", "奶龙是我", "你是谁？？", "我是谁", "你干嘛啊？"} end,
            ["宣传词"] = function() return {"wdfex-HUB牛逼", "打败一切", "快来购买", "功能多多", "支持超多服务器"} end
        },
        connections = {},
        active = false
    }

    chatSystem.tryTextChatSend = function(msg)
        local ok = false
        pcall(function()
            local ch = chatSystem.TextChatService.TextChannels:FindFirstChild("RBXGeneral") or
                       chatSystem.TextChatService.TextChannels:FindFirstChild("RBXGeneralChannel")
            if ch and ch.SendAsync then
                ch:SendAsync(msg)
                ok = true
            end
        end)
        return ok
    end

    chatSystem.tryOldChatSend = function(msg)
        local ok = false
        pcall(function()
            local ev = chatSystem.ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            local req = ev and ev:FindFirstChild("SayMessageRequest")
            if req then
                req:FireServer(msg, "All")
                ok = true
            end
        end)
        return ok
    end

    chatSystem.tryPlayerChat = function(msg)
        local ok = false
        pcall(function()
            local pl = chatSystem.Players.LocalPlayer
            if pl and pl.Chat then
                pl:Chat(msg)
                ok = true
            end
        end)
        return ok
    end

    chatSystem.doSend = function(msg)
        local sent = false
        sent = chatSystem.tryTextChatSend(msg) or sent
        if not sent then sent = chatSystem.tryOldChatSend(msg) or sent end
        if not sent then sent = chatSystem.tryPlayerChat(msg) or sent end
        
        if sent then
            chatSystem.messageCount = chatSystem.messageCount + 1
            chatSystem.lastMessageTime = os.time()
        end
        return sent
    end

    chatSystem.startAutoChat = function()
        if chatSystem.active then return end
        chatSystem.active = true
        
        chatSystem.connections.autoChat = game:GetService("RunService").Heartbeat:Connect(function()
            if _G.AUTO_CHAT_ENABLED and chatSystem.chatModes[_G.AUTO_CHAT_MODE] then
                local currentTime = tick()
                local lastSendTime = chatSystem.lastSendTime or 0
                local interval = tonumber(_G.AUTO_CHAT_INTERVAL) or 1.5
                
                if currentTime - lastSendTime >= interval then
                    local messages = chatSystem.chatModes[_G.AUTO_CHAT_MODE]()
                    if messages and #messages > 0 then
                        local message = messages[chatSystem.messageIndex]
                        chatSystem.doSend(tostring(message))
                        chatSystem.messageIndex = (chatSystem.messageIndex % #messages) + 1
                        chatSystem.lastSendTime = currentTime
                    end
                end
            end
        end)
    end

    chatSystem.stopAutoChat = function()
        chatSystem.active = false
        if chatSystem.connections.autoChat then
            chatSystem.connections.autoChat:Disconnect()
            chatSystem.connections.autoChat = nil
        end
    end

    chatSystem.init = function()
        chatSystem.startAutoChat()
    end

    chatSystem.sendNow = function(message)
        if not message or message == "" then
            message = _G.AUTO_CHAT_TEXT
        end
        return chatSystem.doSend(message)
    end

    chatSystem.cleanup = function()
        for name, connection in pairs(chatSystem.connections) do
            if connection then
                pcall(function() connection:Disconnect() end)
            end
        end
        chatSystem.connections = {}
        chatSystem.active = false
    end

    task.spawn(chatSystem.init)

    funSection:Dropdown({
        Title = "发言模式",
        Values = {"自定义", "7字经", "14字经", "糖人语言", "宣传词"},
        Value = "自定义",
        Callback = function(value)
            _G.AUTO_CHAT_MODE = value
            chatSystem.messageIndex = 1
            WindUI:Notify({
                Title = "发言模式",
                Content = "已切换到: " .. value,
                Duration = 2,
                Icon = "message-circle"
            })
        end
    })

    funSection:Input({
        Title = "自定义发言内容",
        Placeholder = "输入要发送的消息",
        Value = "wdfex-HUB ！！！",
        Callback = function(value)
            _G.AUTO_CHAT_TEXT = value
            WindUI:Notify({
                Title = "自定义内容",
                Content = "已设置: " .. value,
                Duration = 2,
                Icon = "edit"
            })
        end
    })

    funSection:Toggle({
        Title = "开启自动发言",
        Default = false,
        Callback = function(value)
            _G.AUTO_CHAT_ENABLED = value
            if value and not chatSystem.active then
                chatSystem.startAutoChat()
            elseif not value then
                chatSystem.stopAutoChat()
            end
            WindUI:Notify({
                Title = "自动发言",
                Content = value and "已开启" or "已关闭",
                Duration = 2,
                Icon = value and "play" or "square"
            })
        end
    })

    funSection:Slider({
        Title = "发言间隔",
        Desc = "设置发送消息的时间间隔（秒）",
        Value = {Min = 0.5, Max = 10, Default = 1.5},
        Callback = function(value)
            _G.AUTO_CHAT_INTERVAL = value
            WindUI:Notify({
                Title = "发言间隔",
                Content = "已设置为: " .. value .. "秒",
                Duration = 2,
                Icon = "clock"
            })
        end
    })

    _G.ChatSystem = chatSystem

    -- ============================================================
    -- 分类7: 数据
    -- ============================================================
    local TabData = MainWindow:Tab({Title = "数据", Icon = "database"})

    local dataSection = TabData:Section({Title = "封禁信息", Icon = "database", Opened = true})
    dataSection:Paragraph({ Title = "是否被封禁：否", ThumbnailSize = 190 })
    dataSection:Paragraph({ Title = "封禁开始期：无", ThumbnailSize = 190 })
    dataSection:Paragraph({ Title = "封禁结束期：无", ThumbnailSize = 190 })
    dataSection:Paragraph({ Title = "剩余封禁时间：无", ThumbnailSize = 190 })
    dataSection:Paragraph({ Title = "封禁原因：无", ThumbnailSize = 190 })
    dataSection:Paragraph({ Title = "历史封禁次数：0", ThumbnailSize = 190 })

    -- ============================================================
    -- 分类8: 其他
    -- ============================================================
    local TabOther = MainWindow:Tab({Title = "其他", Icon = "settings"})

    local otherSection = TabOther:Section({Title = "其他功能", Icon = "settings", Opened = true})

    local showChatValue = false
    otherSection:Toggle({
        Title = "显示聊天框",
        Default = showChatValue,
        Callback = function(v)
            showChatValue = v
            pcall(function()
                game:GetService("TextChatService").ChatWindowConfiguration.Enabled = v
            end)
            WindUI:Notify({
                Title = "聊天框",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local cashESPValue = false
    otherSection:Toggle({
        Title = "透视钱",
        Default = cashESPValue,
        Callback = function(v)
            cashESPValue = v
            if v then
                for _, bundle in pairs(workspace.Game.Entities.CashBundle:GetChildren()) do
                    local intVal = bundle:FindFirstChildOfClass("IntValue")
                    if intVal then
                        -- 简单ESP用通知替代
                    end
                end
            end
            WindUI:Notify({
                Title = "透视钱",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    otherSection:Input({
        Title = "设置物品栏数量",
        Placeholder = "输入数量",
        Value = "",
        Callback = function(v)
            local num = tonumber(v)
            if num then
                pcall(function()
                    Inventory.numSlots = num
                end)
                WindUI:Notify({
                    Title = "物品栏",
                    Content = "已设置为: " .. num,
                    Duration = 2,
                    Icon = "check"
                })
            end
        end
    })

    local otherSection2 = TabOther:Section({Title = "通用", Icon = "settings", Opened = true})

    local walkSpeedValue = 16
    otherSection2:Slider({
        Title = "移动速度",
        Desc = "设置移动速度",
        Value = {Min = 0, Max = 500, Default = 16},
        Callback = function(v)
            walkSpeedValue = v
            if Humanoid then
                Humanoid.WalkSpeed = v
            end
        end
    })

    local jumpPowerValue = 50
    otherSection2:Slider({
        Title = "跳跃高度",
        Desc = "设置跳跃高度",
        Value = {Min = 0, Max = 500, Default = 50},
        Callback = function(v)
            jumpPowerValue = v
            if Humanoid then
                Humanoid.JumpPower = v
                Humanoid.UseJumpPower = true
            end
        end
    })

    otherSection2:Button({
        Title = "飞行",
        Callback = function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Xingtaiduan/Script/main/Content/FlyGuiV3"))()
            end)
            WindUI:Notify({
                Title = "飞行",
                Content = "正在加载飞行脚本",
                Duration = 2,
                Icon = "check"
            })
        end
    })

    local noclipValue = false
    otherSection2:Toggle({
        Title = "穿墙",
        Default = noclipValue,
        Callback = function(v)
            noclipValue = v
            if v then
                task.spawn(function()
                    while noclipValue do
                        task.wait()
                        if Character then
                            for _, part in pairs(Character:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.CanCollide = false
                                end
                            end
                        end
                    end
                end)
            end
            WindUI:Notify({
                Title = "穿墙",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local fullbrightValue = false
    otherSection2:Toggle({
        Title = "夜视",
        Default = fullbrightValue,
        Callback = function(v)
            fullbrightValue = v
            if v then
                Lighting.Ambient = Color3.new(1, 1, 1)
            else
                Lighting.Ambient = Color3.new(0, 0, 0)
            end
            WindUI:Notify({
                Title = "夜视",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    local infJumpValue = false
    otherSection2:Toggle({
        Title = "无限跳",
        Default = infJumpValue,
        Callback = function(v)
            infJumpValue = v
            if v then
                local jumpConn
                jumpConn = UserInputService.JumpRequest:Connect(function()
                    if Humanoid then
                        Humanoid:ChangeState("Jumping")
                    end
                end)
                if not v and jumpConn then
                    jumpConn:Disconnect()
                end
            end
            WindUI:Notify({
                Title = "无限跳",
                Content = v and "已开启" or "已关闭",
                Duration = 1,
                Icon = v and "check" or "x"
            })
        end
    })

    -- ============================================================
    -- 分类9: UI设置
    -- ============================================================
    local Settings = MainWindow:Tab({Title = "ui设置", Icon = "palette"})
    Settings:Paragraph({
        Title = "ui设置",
        Desc = "二改wind原版ui",
        Image = "settings",
        ImageSize = 20,
        Color = "White"
    })

    Settings:Toggle({
        Title = "启用边框",
        Value = borderEnabled,
        Callback = function(value)
            borderEnabled = value
            local mainFrame = MainWindow.UIElements and MainWindow.UIElements.Main
            if mainFrame then
                local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
                if rainbowStroke then
                    rainbowStroke.Enabled = value
                    if value and windowOpen and not rainbowBorderAnimation then
                        startBorderAnimation(MainWindow, animationSpeed)
                    elseif not value and rainbowBorderAnimation then
                        rainbowBorderAnimation:Disconnect()
                        rainbowBorderAnimation = nil
                    end
                    
                    WindUI:Notify({
                        Title = "边框",
                        Content = value and "已启用" or "已禁用",
                        Duration = 2,
                        Icon = value and "eye" or "eye-off"
                    })
                end
            end
        end
    })

    Settings:Toggle({
        Title = "启用字体颜色",
        Value = fontColorEnabled,
        Callback = function(value)
            fontColorEnabled = value
            applyFontColorsToWindow(currentFontColorScheme)
            
            WindUI:Notify({
                Title = "字体颜色",
                Content = value and "已启用" or "已禁用",
                Duration = 2,
                Icon = value and "type" or "type"
            })
        end
    })

    Settings:Toggle({
        Title = "启用音效",
        Value = soundEnabled,
        Callback = function(value)
            soundEnabled = value
            WindUI:Notify({
                Title = "音效",
                Content = value and "已启用" or "已禁用",
                Duration = 2,
                Icon = value and "volume-2" or "volume-x"
            })
        end
    })

    Settings:Toggle({
        Title = "启用背景模糊",
        Value = blurEnabled,
        Callback = function(value)
            blurEnabled = value
            applyBlurEffect(value)
            WindUI:Notify({
                Title = "背景模糊",
                Content = value and "已启用" or "已禁用",
                Duration = 2,
                Icon = value and "cloud-rain" or "cloud"
            })
        end
    })

    local colorSchemeNames = {}
    for name, _ in pairs(COLOR_SCHEMES) do
        table.insert(colorSchemeNames, name)
    end
    table.sort(colorSchemeNames)

    Settings:Dropdown({
        Title = "边框颜色方案",
        Desc = "选择喜欢的颜色组合",
        Values = colorSchemeNames,
        Value = "彩虹颜色",
        Callback = function(value)
            currentBorderColorScheme = value
            local success = initializeRainbowBorder(value, animationSpeed)
            playSound()
        end
    })

    Settings:Dropdown({
        Title = "字体颜色方案",
        Desc = "选择文字颜色组合",
        Values = colorSchemeNames,
        Value = "彩虹颜色",
        Callback = function(value)
            currentFontColorScheme = value
            applyFontColorsToWindow(value)
            playSound()
        end
    })

    local fontOptions = {}
    for _, fontName in ipairs(FONT_STYLES) do
        local description = FONT_DESCRIPTIONS[fontName] or fontName
        table.insert(fontOptions, {text = description, value = fontName})
    end

    table.sort(fontOptions, function(a, b)
        return a.text < b.text
    end)

    local fontValues = {}
    local fontValueToName = {}
    for _, option in ipairs(fontOptions) do
        table.insert(fontValues, option.text)
        fontValueToName[option.text] = option.value
    end

    Settings:Dropdown({
        Title = "字体样式",
        Desc = "选择文字字体样式 (" .. #FONT_STYLES .. " 种可用)",
        Values = fontValues,
        Value = "标准粗体",
        Callback = function(value)
            local fontName = fontValueToName[value]
            if fontName then
                currentFontStyle = fontName
                local successCount, totalCount = applyFontStyleToWindow(fontName)
                playSound()
            end
        end
    })

    Settings:Slider({
        Title = "边框转动速度",
        Desc = "调整边框旋转的快慢",
        Value = { 
            Min = 1,
            Max = 10,
            Default = 5,
        },
        Callback = function(value)
            animationSpeed = value
            if rainbowBorderAnimation then
                rainbowBorderAnimation:Disconnect()
                rainbowBorderAnimation = nil
            end
            if borderEnabled then
                startBorderAnimation(MainWindow, animationSpeed)
            end
            
            applyFontColorsToWindow(currentFontColorScheme)
            playSound()
        end
    })

    Settings:Slider({
        Title = "UI整体缩放",
        Desc = "调整UI大小比例",
        Value = { 
            Min = 0.5,
            Max = 1.5,
            Default = 1,
        },
        Step = 0.1,
        Callback = function(value)
            uiScale = value
            applyUIScale(value)
            playSound()
        end
    })

    Settings:Divider()

    Settings:Slider({
        Title = "UI透明度",
        Desc = "调整整个UI的透明度",
        Value = { 
            Min = 0,
            Max = 1,
            Default = 0.2,
        },
        Step = 0.1,
        Callback = function(value)
            MainWindow:ToggleTransparency(tonumber(value) > 0)
            WindUI.TransparencyValue = tonumber(value)
            playSound()
        end
    })

    Settings:Slider({
        Title = "调整UI宽度",
        Desc = "调整窗口的宽度",
        Value = { 
            Min = 500,
            Max = 800,
            Default = 600,
        },
        Callback = function(value)
            if MainWindow.UIElements and MainWindow.UIElements.Main then
                MainWindow.UIElements.Main.Size = UDim2.fromOffset(value, 400)
            end
            playSound()
        end
    })

    Settings:Slider({
        Title = "调整UI高度",
        Desc = "调整窗口的高度",
        Value = { 
            Min = 300,
            Max = 600,
            Default = 400,
        },
        Callback = function(value)
            if MainWindow.UIElements and MainWindow.UIElements.Main then
                local currentWidth = MainWindow.UIElements.Main.Size.X.Offset
                MainWindow.UIElements.Main.Size = UDim2.fromOffset(currentWidth, value)
            end
            playSound()
        end
    })

    Settings:Slider({
        Title = "边框粗细",
        Desc = "调整边框的粗细",
        Value = { 
            Min = 1,
            Max = 5,
            Default = 1.5,
        },
        Step = 0.5,
        Callback = function(value)
            local mainFrame = MainWindow.UIElements and MainWindow.UIElements.Main
            if mainFrame then
                local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
                if rainbowStroke then
                    rainbowStroke.Thickness = value
                end
            end
            playSound()
        end
    })

    Settings:Slider({
        Title = "圆角大小",
        Desc = "调整UI圆角的大小",
        Value = { 
            Min = 0,
            Max = 20,
            Default = 16,
        },
        Callback = function(value)
            local mainFrame = MainWindow.UIElements and MainWindow.UIElements.Main
            if mainFrame then
                local corner = mainFrame:FindFirstChildOfClass("UICorner")
                if not corner then
                    corner = Instance.new("UICorner")
                    corner.Parent = mainFrame
                end
                corner.CornerRadius = UDim.new(0, value)
            end
            playSound()
        end
    })

    Settings:Button({
        Title = "恢复UI到原位",
        Icon = "rotate-ccw",
        Callback = function()
            if MainWindow.UIElements and MainWindow.UIElements.Main then
                MainWindow.UIElements.Main.Position = UDim2.new(0.5, 0, 0.5, 0)
                playSound()
            end
        end
    })

    Settings:Button({
        Title = "重置UI大小",
        Icon = "maximize-2",
        Callback = function()
            if MainWindow.UIElements and MainWindow.UIElements.Main then
                MainWindow.UIElements.Main.Size = UDim2.fromOffset(600, 400)
                playSound()
            end
        end
    })

    Settings:Button({
        Title = "随机字体",
        Icon = "shuffle",
        Callback = function()
            local randomFont = FONT_STYLES[math.random(1, #FONT_STYLES)]
            currentFontStyle = randomFont
            applyFontStyleToWindow(randomFont)
            playSound()
        end
    })

    Settings:Button({
        Title = "随机颜色",
        Icon = "palette",
        Callback = function()
            local randomColor = colorSchemeNames[math.random(1, #colorSchemeNames)]
            currentBorderColorScheme = randomColor
            initializeRainbowBorder(randomColor, animationSpeed)
            playSound()
        end
    })

    Settings:Divider()

    Settings:Button({
        Title = "刷新字体颜色",
        Icon = "refresh-cw",
        Callback = function()
            applyFontColorsToWindow(currentFontColorScheme)
            playSound()
        end
    })

    Settings:Button({
        Title = "刷新字体样式",
        Icon = "refresh-cw",
        Callback = function()
            local successCount, totalCount = applyFontStyleToWindow(currentFontStyle)
            playSound()
        end
    })

    Settings:Button({
        Title = "测试所有字体",
        Icon = "check-circle",
        Callback = function()
            local workingFonts = {}
            local totalFonts = #FONT_STYLES
            
            for i, fontName in ipairs(FONT_STYLES) do
                local success = pcall(function()
                    local test = Enum.Font[fontName]
                end)
                
                if success then
                    table.insert(workingFonts, fontName)
                end
            end
            playSound()
        end
    })

    Settings:Button({
        Title = "导出设置",
        Icon = "download",
        Callback = function()
            local settings = {
                font = currentFontStyle,
                borderColor = currentBorderColorScheme,
                fontSize = currentFontColorScheme,
                speed = animationSpeed,
                scale = uiScale
            }
            setclipboard("wdfex-HUB V2 设置: " .. game:GetService("HttpService"):JSONEncode(settings))
            playSound()
        end
    })

    MainWindow:OnClose(function()
        windowOpen = false
        if rainbowBorderAnimation then
            rainbowBorderAnimation:Disconnect()
            rainbowBorderAnimation = nil
        end
        applyBlurEffect(false)
    end)

    MainWindow:OnDestroy(function()
        windowOpen = false
        if rainbowBorderAnimation then
            rainbowBorderAnimation:Disconnect()
            rainbowBorderAnimation = nil
        end
        for _, animation in pairs(fontColorAnimations) do
            animation:Disconnect()
        end
        fontColorAnimations = {}
        applyBlurEffect(false)
    end)
end