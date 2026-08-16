-- 加载 WindUI 库
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
    if not Window or not Window.UIElements then 
        wait(0.5)
        if not Window or not Window.UIElements then
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
    
    processElement(Window.UIElements.Main)
    
    return successCount, totalCount
end

local function applyFontColorsToWindow(colorScheme)
    if not Window or not Window.UIElements then return end
    
    local function processElement(element)
        for _, child in ipairs(element:GetDescendants()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                applyFontColorGradient(child, colorScheme)
            end
        end
    end
    
    processElement(Window.UIElements.Main)
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
    
    local rainbowStroke, _ = createRainbowBorder(Window, scheme, speed)
    if rainbowStroke then
        if borderEnabled then
            startBorderAnimation(Window, speed)
        end
        borderInitialized = true
        return true
    end
    return false
end

local function gradient(text, startColor, endColor)
    local result = ""
    for i = 1, #text do
        local t = (i - 1) / (#text - 1)
        local r = math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255)
        local g = math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255)
        local b = math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255)
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', r, g, b, text:sub(i, i))
    end
    return result
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
    if Window and Window.UIElements and Window.UIElements.Main then
        local mainFrame = Window.UIElements.Main
        mainFrame.Size = UDim2.new(0, 600 * scale, 0, 400 * scale)
    end
end

local Confirmed = false
local gradientColors = {
    "rgb(255, 230, 235)",
    "rgb(255, 210, 220)",
    "rgb(255, 190, 205)",
    "rgb(255, 170, 190)",
    "rgb(255, 150, 175)",
    "rgb(245, 140, 180)",
    "rgb(235, 130, 185)",
    "rgb(225, 120, 190)",
    "rgb(215, 110, 195)",
    "rgb(205, 100, 200)"
}
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
    -- ===== 创建窗口 =====
    local Window = WindUI:CreateWindow({
        Title = 'wdfex-HUB',
        Icon = "crown",
        IconThemed = true,
        Author = "当前版本：v2.0 作者：wdfex",
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

    Window:EditOpenButton({
        Title = "wdfex-HUB",
        Icon = "crown",
        CornerRadius = UDim.new(0,16),
        StrokeThickness = 4,
        Color = ColorSequence.new(Color3.fromHex("FF6B6B")),
        Draggable = true,
    })
    
    Window:Tag({
        Title = "正在寻求",
        Color = Color3.fromHex("#00008B") 
    })
    
    Window:Tag({
        Title = "3.0.1",
        Color = Color3.fromHex("#32CD32")
    })
    
    spawn(function()
        while true do
            for hue = 0, 1, 0.01 do  
                local color = Color3.fromHSV(hue, 0.8, 1)  
                Window:EditOpenButton({
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

    Window:OnClose(function()
        windowOpen = false
        if rainbowBorderAnimation then
            rainbowBorderAnimation:Disconnect()
            rainbowBorderAnimation = nil
        end
    end)

    local originalOpenFunction = Window.Open
    Window.Open = function(...)
        windowOpen = true
        local result = originalOpenFunction(...)
        
        if borderInitialized and borderEnabled and not rainbowBorderAnimation then
            wait(0.1)
            startBorderAnimation(Window, animationSpeed)
        end
        
        return result
    end

    -- ===== 公告Tab =====
    local Tab_Notice = Window:Tab({
        ["Locked"] = false,
        ["Title"] = "公告",
        ["Icon"] = "rbxassetid://115466270141583",
    })

    Tab_Notice:Section({
        TextSize = 17,
        ["Title"] = "本脚本严禁外传发现永久拉黑无法使用此脚本",
        TextXAlignment = "Left",
    })

    Tab_Notice:Section({
        TextSize = 17,
        ["Title"] = "━━━━━━━━━━━━━━━━━━━━",
        TextXAlignment = "Left",
    })

    Tab_Notice:Section({
        TextSize = 17,
        ["Title"] = "如何使用没有防的脚本不被踢：执行此脚本之后点进出租车里面然后点接出租车刷钱然后出来悬浮窗之后点击启动然后退出游戏（速度一定要快）然后等1分钟要是被封了两个小时就是成功了，然后等解开了就不会再被封了（除非被挂到DG）",
        TextXAlignment = "Left",
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

    -- ===== 通用Tab =====
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
        ["Title"] = "反挂机",
        ["Desc"] = "防止被踢出",
        ["Callback"] = function()
            print("反挂机已开启")
            local LocalPlayer = game:GetService("Players").LocalPlayer
            local VirtualUser = game:GetService("VirtualUser")
            local CurrentCamera = workspace.CurrentCamera
            LocalPlayer.Idled:Connect(function()
                VirtualUser:Button2Down(Vector2.new(0, 0), CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0, 0), CurrentCamera.CFrame)
            end)
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "反挂机",
                Text = "已开启",
                Duration = 3,
            })
        end
    })

    Tab_General:Slider({
        ["Title"] = "速度设置",
        ["Step"] = 1,
        ["Value"] = { Min = 16, Default = 16, Max = 1000 },
        ["Callback"] = function(Value)
            local speed = type(Value) == "table" and Value[1] or Value
            local LocalPlayer = game:GetService("Players").LocalPlayer
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = speed
            end
        end
    })

    Tab_General:Slider({
        ["Title"] = "跳跃设置",
        ["Step"] = 1,
        ["Value"] = { Min = 50, Default = 50, Max = 200 },
        ["Callback"] = function(Value)
            local jump = type(Value) == "table" and Value[1] or Value
            local LocalPlayer = game:GetService("Players").LocalPlayer
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.JumpPower = jump
            end
        end
    })

    Tab_General:Button({
        ["Title"] = "帧率显示",
        ["Desc"] = "显示FPS",
        ["Callback"] = function()
            local LocalPlayer = game:GetService("Players").LocalPlayer
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
            
            local RunService = game:GetService("RunService")
            RunService.RenderStepped:Connect(function()
                local fps = math.floor(1 / RunService.RenderStepped:Wait())
                TextLabel.Text = "FPS: " .. fps
            end)
        end
    })

    Tab_General:Button({
        ["Title"] = "时间显示",
        ["Desc"] = "显示北京时间",
        ["Callback"] = function()
            local CoreGui = game:GetService("CoreGui")
            if CoreGui:FindFirstChild("LBLG") then return end

            local ScreenGui = Instance.new("ScreenGui")
            ScreenGui.Name = "LBLG"
            ScreenGui.Parent = CoreGui
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
            
            local RunService = game:GetService("RunService")
            RunService.Heartbeat:Connect(function()
                local currentTime = os.date("%H时%M分%S秒")
                TextLabel.Text = "北京时间:" .. currentTime
            end)
        end
    })

    Tab_General:Button({
        ["Title"] = "重开",
        ["Desc"] = "重新开始",
        ["Callback"] = function()
            local LocalPlayer = game:GetService("Players").LocalPlayer
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Health = 0
            end
        end
    })

    Tab_General:Toggle({
        ["Title"] = "防摔",
        ["Desc"] = "从高处掉落时一下快一下慢",
        ["Default"] = false,
        ["Callback"] = function(bool)
            local LocalPlayer = game:GetService("Players").LocalPlayer
            local RunService = game:GetService("RunService")
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

    -- ===== 地点传送Tab =====
    local Tab_LocationTeleport = Window:Tab({
        ["Locked"] = false,
        ["Title"] = "地点传送",
        ["Icon"] = "rbxassetid://18520370419",
    })

    Tab_LocationTeleport:Section({
        TextSize = 17,
        ["Title"] = "选择传送点",
        TextXAlignment = "Left",
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

    local function TeleportTo(pos)
        pcall(function()
            local LocalPlayer = game:GetService("Players").LocalPlayer
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(pos)
            end
        end)
    end

    for _, loc in ipairs(locationPoints) do
        Tab_LocationTeleport:Button({
            ["Title"] = loc[1],
            ["Desc"] = "传送至" .. loc[1],
            ["Callback"] = function()
                TeleportTo(loc[2])
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "地点传送",
                    Text = "已传送到 " .. loc[1],
                    Duration = 2,
                })
            end
        })
    end

    -- ===== 售货机传送区Tab =====
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

    -- ===== 外卖员Tab =====
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

    -- ===== 出租车Tab =====
    local Tab_Taxi = Window:Tab({
        ["Locked"] = false,
        ["Title"] = "出租车",
        ["Icon"] = "rbxassetid://18520370419",
    })

    Tab_Taxi:Section({
        TextSize = 17,
        ["Title"] = "出租车功能",
        TextXAlignment = "Left",
    })

    Tab_Taxi:Button({
        ["Title"] = "wdfex出租车刷钱脚本",
        ["Desc"] = "点击执行出租车刷钱脚本",
        ["Callback"] = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/1687426335-art/IEAI/refs/heads/main/wnatsj.lua"))()
        end
    })

    -- ===== 透视Tab =====
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
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")

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

    -- ===== 标点传送Tab =====
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
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local Workspace = game:GetService("Workspace")
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

    Tab_Waypoint:Button({
        ["Title"] = "传送到地图标点",
        ["Desc"] = "自动检测地图上的标点并传送",
        ["Callback"] = function()
            local target = GetWaypointPosition()
            if target then
                TeleportTo(target)
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "标点传送",
                    Text = "已传送到标点位置",
                    Duration = 2,
                })
            else
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "标点传送",
                    Text = "未找到地图标点，请先在地图上标点",
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

    -- ===== 甩飞Tab =====
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
                    local LocalPlayer = game:GetService("Players").LocalPlayer
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
        local LocalPlayer = game:GetService("Players").LocalPlayer
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
            for _, x in next, game:GetService("Players"):GetPlayers() do
                if x ~= game:GetService("Players").LocalPlayer then
                    SkidFling(x)
                end
            end
        end
    })

    -- ===== 范围Tab =====
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
                for _, v in pairs(game:GetService("Players"):GetPlayers()) do
                    if v ~= game:GetService("Players").LocalPlayer then
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

    -- ===== 车辆功能Tab =====
    local Tab_Vehicle = Window:Tab({
        ["Locked"] = false,
        ["Title"] = "车辆功能",
        ["Icon"] = "rbxassetid://18520370419",
    })

    Tab_Vehicle:Section({
        TextSize = 17,
        ["Title"] = "车辆功能",
        TextXAlignment = "Left",
    })

    local vehicleSpinEnabled = false
    local vehicleSpinConnection = nil
    local spinSpeed = 30

    Tab_Vehicle:Toggle({
        ["Title"] = "车辆旋转",
        ["Desc"] = "开启后人物旋转上车车也会跟着旋转",
        ["Default"] = false,
        ["Callback"] = function(bool)
            vehicleSpinEnabled = bool
            if bool then
                if vehicleSpinConnection then
                    vehicleSpinConnection:Disconnect()
                    vehicleSpinConnection = nil
                end
                vehicleSpinConnection = RunService.Heartbeat:Connect(function()
                    if not vehicleSpinEnabled then return end
                    local LocalPlayer = game:GetService("Players").LocalPlayer
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

    Tab_Vehicle:Slider({
        ["Title"] = "旋转速度",
        ["Step"] = 1,
        ["Value"] = { Min = 5, Default = 30, Max = 200 },
        ["Callback"] = function(Value)
            spinSpeed = type(Value) == "table" and Value[1] or Value
        end
    })

    -- ===== 枪械功能Tab =====
    local Tab_Weapon = Window:Tab({
        ["Locked"] = false,
        ["Title"] = "枪械功能",
        ["Icon"] = "rbxassetid://18520370419",
    })

    Tab_Weapon:Section({
        TextSize = 17,
        ["Title"] = "枪械功能",
        TextXAlignment = "Left",
    })

    Tab_Weapon:Button({
        ["Title"] = "无限子弹+超快射速（手枪可连发）",
        ["Desc"] = "点击开启无限子弹+超快射速",
        ["Callback"] = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/1687426335-art/IEAI/refs/heads/main/tzh.lua"))()
        end
    })

    -- ===== 杀戮光环Tab =====
    local Tab_KillAura = Window:Tab({
        ["Locked"] = false,
        ["Title"] = "杀戮光环",
        ["Icon"] = "rbxassetid://18520370419",
    })

    Tab_KillAura:Section({
        TextSize = 17,
        ["Title"] = "杀戮光环",
        TextXAlignment = "Left",
    })

    Tab_KillAura:Button({
        ["Title"] = "开启杀戮光环",
        ["Desc"] = "点击执行杀戮光环脚本",
        ["Callback"] = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/1687426335-art/IEAI/refs/heads/main/yahzlq.lua"))()
        end
    })

    -- ===== 警察显示Tab =====
    local Tab_Police = Window:Tab({
        ["Locked"] = false,
        ["Title"] = "警察显示",
        ["Icon"] = "rbxassetid://18520370419",
    })

    Tab_Police:Section({
        TextSize = 17,
        ["Title"] = "警察数量显示",
        TextXAlignment = "Left",
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
        for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
            if player ~= game:GetService("Players").LocalPlayer then
                if IsPlayerPolice(player) then
                    count = count + 1
                end
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

    Tab_Police:Toggle({
        ["Title"] = "显示警察数量",
        ["Desc"] = "在屏幕右上方实时显示警察数量",
        ["Default"] = false,
        ["Callback"] = function(bool)
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
                policeGui.Parent = game:GetService("CoreGui")
                
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
                
                game:GetService("Players").PlayerAdded:Connect(function()
                    if policeDisplayEnabled then UpdatePoliceCount() end
                end)
                game:GetService("Players").PlayerRemoving:Connect(function()
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

    -- ===== 设置Tab =====
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
                local frosty = game:GetService("CoreGui"):FindFirstChild("frosty")
                if frosty then frosty:Destroy() end
                local eggGui = game:GetService("CoreGui"):FindFirstChild("EasterEggGui")
                if eggGui then eggGui:Destroy() end
                local welcomeGui = game:GetService("CoreGui"):FindFirstChild("wdfexWelcome")
                if welcomeGui then welcomeGui:Destroy() end
                local borderGui = game:GetService("CoreGui"):FindFirstChild("wdfexBorder")
                if borderGui then borderGui:Destroy() end
                local hubGui = game:GetService("CoreGui"):FindFirstChild("wdfexHub")
                if hubGui then hubGui:Destroy() end
                local policeGui = game:GetService("CoreGui"):FindFirstChild("PoliceDisplay")
                if policeGui then policeGui:Destroy() end
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
                    eggSound.Parent = game:GetService("CoreGui")
                    eggSound:Play()
                    eggPlaying = true
                    
                    eggSound.Ended:Connect(function()
                        eggPlaying = false
                    end)
                end)
                
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
                    local eggGui = game:GetService("CoreGui"):FindFirstChild("EasterEggGui")
                    if eggGui then eggGui:Destroy() end
                end)
            end
        end
    })

    -- ===== UI设置Tab（WindUI自带） =====
    local Settings = Window:Tab({Title = "ui设置", Icon = "palette"})
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
            local mainFrame = Window.UIElements and Window.UIElements.Main
            if mainFrame then
                local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
                if rainbowStroke then
                    rainbowStroke.Enabled = value
                    if value and windowOpen and not rainbowBorderAnimation then
                        startBorderAnimation(Window, animationSpeed)
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
                startBorderAnimation(Window, animationSpeed)
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
            Window:ToggleTransparency(tonumber(value) > 0)
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
            if Window.UIElements and Window.UIElements.Main then
                Window.UIElements.Main.Size = UDim2.fromOffset(value, 400)
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
            if Window.UIElements and Window.UIElements.Main then
                local currentWidth = Window.UIElements.Main.Size.X.Offset
                Window.UIElements.Main.Size = UDim2.fromOffset(currentWidth, value)
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
            local mainFrame = Window.UIElements and Window.UIElements.Main
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
            local mainFrame = Window.UIElements and Window.UIElements.Main
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
            if Window.UIElements and Window.UIElements.Main then
                Window.UIElements.Main.Position = UDim2.new(0.5, 0, 0.5, 0)
                playSound()
            end
        end
    })

    Settings:Button({
        Title = "重置UI大小",
        Icon = "maximize-2",
        Callback = function()
            if Window.UIElements and Window.UIElements.Main then
                Window.UIElements.Main.Size = UDim2.fromOffset(600, 400)
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

    Window:OnClose(function()
        windowOpen = false
        if rainbowBorderAnimation then
            rainbowBorderAnimation:Disconnect()
            rainbowBorderAnimation = nil
        end
        applyBlurEffect(false)
    end)

    Window:OnDestroy(function()
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