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
            blur.Name = "UIwdfex-HUBBlur"
            blur.Parent = game:GetService("Lighting")
        end)
    else
        pcall(function()
            local existingBlur = game:GetService("Lighting"):FindFirstChild("UIwdfex-HUBBlur")
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
    Content = "欢迎尊重的wdfex脚本用户 " .. coloredUsername .. " \n使用wdfexHUB\n当前你执行的脚本支持\n圣奥里服务器",
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
    local Window = WindUI:CreateWindow({
        Title = 'wdfex-HUB',
        Icon = "crown",
        IconThemed = true,
        Author = "v3.0.1 by 神青",
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

    -- ===== 通知Tab =====
    local infoTab = Window:Tab({Title = "通知", Icon = "layout-grid", Locked = false})
    local infoSection = infoTab:Section({Title = "详情信息",Icon = "info", Opened = true})
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
    local infoSection2 = infoTab:Section({Title = "更新",Icon = "info", Opened = true})
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

    -- ===== 玩家修改Tab =====
    local PlayerTab = Window:Tab({Title = "玩家修改", Icon = "user"})

    -- 交互设置
    local interactGroup = PlayerTab:AddRightGroupbox("交互设置")
    local interactEnabled = false
    local holdTime = 0
    local distance = 25

    interactGroup:Toggle({
        Title = "启用交互修改",
        Default = false,
        Callback = function(value)
            interactEnabled = value
            if value then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") then
                        obj.HoldDuration = holdTime
                        obj.MaxActivationDistance = distance
                    end
                end
            end
        end
    })
    interactGroup:Divider()
    interactGroup:Slider({
        Title = "按住时间",
        Default = 0,
        Min = 0,
        Max = 10,
        Callback = function(value)
            holdTime = value
            if interactEnabled then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") then
                        obj.HoldDuration = value
                    end
                end
            end
        end
    })
    interactGroup:Slider({
        Title = "触发距离",
        Default = 25,
        Min = 5,
        Max = 150,
        Callback = function(value)
            distance = value
            if interactEnabled then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") then
                        obj.MaxActivationDistance = value
                    end
                end
            end
        end
    })

    -- 角色修改
    local flyGroup = PlayerTab:AddLeftGroupbox("角色修改")
    local FlyingEnabled = false
    local FlightSpeed = 80
    local SpinningEnabled = false
    local SpinSpeed = 5
    local CurrentAO, CurrentLV, CurrentMoverAttachment
    local FlightConnection
    local Control = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local LastControl = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}

    local function getControlModule()
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local PlayerModule = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")
        return require(PlayerModule:WaitForChild("ControlModule"))
    end

    local function setupBodyMovers(character)
        local hrp = character:WaitForChild("HumanoidRootPart")
        local humanoid = character:WaitForChild("Humanoid")
        local moverParent = workspace:FindFirstChildOfClass("Terrain") or workspace
        local moverAttachment = Instance.new("Attachment", hrp)
        moverAttachment.Name = "FlightAttachment"
        local alignOrientation = Instance.new('AlignOrientation')
        alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
        alignOrientation.RigidityEnabled = true
        alignOrientation.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        alignOrientation.CFrame = hrp.CFrame
        alignOrientation.Attachment0 = moverAttachment
        alignOrientation.Parent = moverParent
        local linearVelocity = Instance.new('LinearVelocity')
        linearVelocity.VectorVelocity = Vector3.new(0, 0, 0)
        linearVelocity.MaxForce = 9e9
        linearVelocity.Attachment0 = moverAttachment
        linearVelocity.Parent = moverParent
        return alignOrientation, linearVelocity, humanoid, moverAttachment
    end

    local function getFlightVector(controlModule)
        local moveVector = controlModule:GetMoveVector()
        local camera = workspace.CurrentCamera
        Control.F = -moveVector.Z
        Control.B = moveVector.Z
        Control.L = -moveVector.X
        Control.R = moveVector.X
        Control.Q = moveVector.Y
        Control.E = -moveVector.Y
        local UserInputService = game:GetService("UserInputService")
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then Control.F = 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then Control.B = 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then Control.L = 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then Control.R = 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then Control.Q = 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then Control.E = 1 end
        local flightVector = (camera.CFrame.LookVector * (Control.F - Control.B) +
            camera.CFrame.RightVector * (Control.R - Control.L) +
            Vector3.new(0, 1, 0) * (Control.Q - Control.E))
        return flightVector.Magnitude > 0 and flightVector.Unit or flightVector
    end

    local function startFlying()
        if FlyingEnabled then return end
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        if not character then
            WindUI:Notify({Title = "飞行失败", Content = "无法获取角色", Duration = 2, Icon = "x"})
            return
        end
        FlyingEnabled = true
        SpinningEnabled = false
        if CurrentAO then CurrentAO:Destroy() end
        if CurrentLV then CurrentLV:Destroy() end
        if CurrentMoverAttachment then CurrentMoverAttachment:Destroy() end
        CurrentAO, CurrentLV, humanoid, CurrentMoverAttachment = setupBodyMovers(character)
        WindUI:Notify({Title = "飞行开启", Content = "速度: " .. FlightSpeed, Duration = 2, Icon = "check"})
        local controlModule = getControlModule()
        FlightConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not FlyingEnabled or not CurrentLV or not CurrentAO then
                if FlightConnection then
                    FlightConnection:Disconnect()
                    FlightConnection = nil
                end
                return
            end
            local flightVector = getFlightVector(controlModule)
            if flightVector.Magnitude > 0 then
                CurrentLV.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
                CurrentLV.VectorVelocity = flightVector * FlightSpeed
            else
                CurrentLV.VectorVelocity = Vector3.new(0, 0, 0)
            end
            if SpinningEnabled then
                local targetPart = character.Humanoid.SeatPart or character.HumanoidRootPart
                local spinCFrame = targetPart.CFrame * CFrame.Angles(0, math.rad(SpinSpeed), 0)
                CurrentAO.CFrame = spinCFrame
            else
                CurrentAO.CFrame = workspace.CurrentCamera.CFrame
            end
            if character.HumanoidRootPart then
                character.Humanoid.PlatformStand = true
            end
        end)
        character.AncestryChanged:Connect(function(_, parent)
            if not parent and FlyingEnabled then
                stopFlying()
            end
        end)
    end

    local function stopFlying()
        if not FlyingEnabled then return end
        FlyingEnabled = false
        SpinningEnabled = false
        Control = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
        LastControl = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
        if FlightConnection then
            FlightConnection:Disconnect()
            FlightConnection = nil
        end
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.PlatformStand = false
        end
        if CurrentAO then
            CurrentAO:Destroy()
            CurrentAO = nil
        end
        if CurrentLV then
            CurrentLV:Destroy()
            CurrentLV = nil
        end
        if CurrentMoverAttachment then
            CurrentMoverAttachment:Destroy()
            CurrentMoverAttachment = nil
        end
        WindUI:Notify({Title = "飞行关闭", Content = "飞行功能已禁用", Duration = 2, Icon = "x"})
    end

    flyGroup:Toggle({
        Title = "飞行模式",
        Default = false,
        Callback = function(v)
            if v then startFlying() else stopFlying() end
        end
    })

    flyGroup:Toggle({
        Title = "旋转模式",
        Default = false,
        Callback = function(v)
            SpinningEnabled = v
        end
    })

    flyGroup:Slider({
        Title = "飞行速度",
        Value = {Min = 1, Max = 300, Default = 80},
        Callback = function(value)
            FlightSpeed = value
        end
    })

    flyGroup:Slider({
        Title = "旋转速度",
        Value = {Min = 1, Max = 50, Default = 5},
        Callback = function(value)
            SpinSpeed = value
        end
    })

    flyGroup:Divider()

    local speedBypassOn = false
    local speedBypassValue = 20

    flyGroup:Toggle({
        Title = "修改移速（绕过）",
        Default = false,
        Callback = function(value)
            speedBypassOn = value
        end
    })

    flyGroup:Slider({
        Title = "移速",
        Value = {Min = 5, Max = 150, Default = 20},
        Callback = function(value)
            speedBypassValue = value
        end
    })

    local RunService = game:GetService("RunService")
    local player = game:GetService("Players").LocalPlayer

    RunService.Heartbeat:Connect(function(dt)
        if not speedBypassOn then return end
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if hum and root and hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + hum.MoveDirection * speedBypassValue * dt
        end
    end)

    flyGroup:Toggle({
        Title = "无限体力",
        Default = false,
        Callback = function(value)
            staminaOn = value
        end
    })

    flyGroup:Toggle({
        Title = "启用人物穿墙",
        Default = false,
        Callback = function(value)
            ToggleNoclip(value)
        end
    })

    flyGroup:Toggle({
        Title = "扩大视野",
        Default = false,
        Callback = function(value)
            if value then
                fovConnection = RunService.Heartbeat:Connect(function()
                    workspace.CurrentCamera.FieldOfView = 120
                end)
            elseif fovConnection then
                fovConnection:Disconnect()
                fovConnection = nil
            end
        end
    })

    flyGroup:Toggle({
        Title = "无限跳",
        Default = false,
        Callback = function(value)
            local jumpConn
            if value then
                jumpConn = game:GetService("UserInputService").JumpRequest:Connect(function()
                    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            elseif jumpConn then
                jumpConn:Disconnect()
                jumpConn = nil
            end
        end
    })

    -- 伤害免疫
    local godGroup = PlayerTab:AddRightGroupbox("伤害免疫")
    local godOn = false
    local StaminaEvent
    pcall(function()
        StaminaEvent = game:GetService("ReplicatedStorage"):WaitForChild("Remote", 5):WaitForChild("PlayerEvent", 5)
    end)
    if StaminaEvent then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            if self == StaminaEvent and method == "FireServer" then
                if args[1] == "takeDamage" and godOn then
                    return
                end
            end
            return oldNamecall(self, ...)
        end)
    end

    godGroup:Toggle({
        Title = "免疫部分伤害",
        Default = false,
        Callback = function(value)
            godOn = value
        end
    })
    godGroup:AddLabel("免疫火焰/激光/火车/车祸，不免疫玩家枪械")

    -- ===== 枪械修改Tab =====
    local GunTab = Window:Tab({Title = "枪械修改", Icon = "target"})

    -- 武器强化
    local weaponGroup = GunTab:AddLeftGroupbox("武器强化")
    local infAmmoEnabled = false

    weaponGroup:Toggle({
        Title = "无限射速（伤害拉满）",
        Default = false,
        Callback = function(value)
            if not value then return end
            local function ModifyWeaponStats()
                local garbage = getgc(true)
                for _, tbl in pairs(garbage) do
                    if type(tbl) == "table" then
                        if rawget(tbl, "SHOOT_MODE") then
                            rawset(tbl, "SHOOT_MODE", 2)
                        end
                        if rawget(tbl, "RPM") then
                            rawset(tbl, "RPM", math.huge)
                        end
                        if rawget(tbl, "DAMAGE") then
                            rawset(tbl, "DAMAGE", math.huge)
                        end
                    end
                end
            end
            ModifyWeaponStats()
            local char = player.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.Died:Connect(ModifyWeaponStats)
                end
            end
            WindUI:Notify({Title = "武器强化", Content = "无限射速已生效，死亡后自动重新生效", Duration = 3})
        end
    })

    weaponGroup:Toggle({
        Title = "无限子弹",
        Default = false,
        Callback = function(value)
            infAmmoEnabled = value
        end
    })

    task.spawn(function()
        while true do
            if infAmmoEnabled then
                local characterFolder = workspace:FindFirstChild("Characters") and workspace.Characters:FindFirstChild(player.Name)
                if characterFolder then
                    for _, gun in ipairs(characterFolder:GetChildren()) do
                        local config = gun:FindFirstChild("Config")
                        if config then
                            local ammo = config:FindFirstChild("Ammo")
                            local totalAmmo = config:FindFirstChild("TotalAmmo")
                            if ammo then ammo.Value = math.huge end
                            if totalAmmo then totalAmmo.Value = math.huge end
                        end
                    end
                end
            end
            RunService.Heartbeat:Wait()
        end
    end)

    -- 透视
    local espGroup = GunTab:AddRightGroupbox("透视")
    local ESPEnabled = false
    local ESPShowName = true
    local ESPShowJob = true
    local espBillboards = {}
    local espConnections = {}
    local isDestroyed = false

    local JobColors = {
        ["警察"] = Color3.fromRGB(0, 100, 255),
        ["医生"] = Color3.fromRGB(0, 200, 0),
        ["消防员"] = Color3.fromRGB(255, 50, 0),
        ["军人"] = Color3.fromRGB(50, 150, 50),
        ["黑帮"] = Color3.fromRGB(150, 0, 150),
        ["平民"] = Color3.fromRGB(200, 200, 200),
        ["圣奥里公民"] = Color3.fromRGB(200, 200, 200),
        ["银行家"] = Color3.fromRGB(0, 200, 200),
        ["市长"] = Color3.fromRGB(255, 200, 0),
        ["记者"] = Color3.fromRGB(255, 150, 0),
        ["律师"] = Color3.fromRGB(150, 100, 200),
        ["囚犯"] = Color3.fromRGB(255, 150, 0),
        ["狱警"] = Color3.fromRGB(0, 150, 255),
        ["司机"] = Color3.fromRGB(100, 200, 255),
        ["厨师"] = Color3.fromRGB(255, 100, 0),
        ["建筑工"] = Color3.fromRGB(255, 200, 50),
        ["农民"] = Color3.fromRGB(50, 200, 50),
        ["矿工"] = Color3.fromRGB(200, 150, 100),
        ["渔夫"] = Color3.fromRGB(0, 150, 200),
        ["商人"] = Color3.fromRGB(255, 150, 200),
        ["学生"] = Color3.fromRGB(100, 100, 255),
        ["老师"] = Color3.fromRGB(200, 100, 50),
        ["工程师"] = Color3.fromRGB(255, 100, 100),
        ["科学家"] = Color3.fromRGB(0, 255, 150),
        ["飞行员"] = Color3.fromRGB(50, 200, 255),
        ["快递员"] = Color3.fromRGB(255, 180, 0),
        ["公交车司机"] = Color3.fromRGB(0, 180, 255),
        ["送货"] = Color3.fromRGB(255, 100, 50),
        ["转运"] = Color3.fromRGB(0, 200, 150),
        ["货物"] = Color3.fromRGB(150, 100, 0),
        ["医疗服务工作人员"] = Color3.fromRGB(0, 220, 100),
    }

    local function GetPlayerTeamColor(p)
        local team = p.Team
        if team then
            return team.TeamColor.Color
        end
        return Color3.fromRGB(255, 255, 255)
    end

    local function GetPlayerJob(p)
        if p.Team then
            return p.Team.Name
        end
        return "平民"
    end

    local function GetJobColor(jobName)
        return JobColors[jobName] or Color3.fromRGB(200, 200, 200)
    end

    local function RemoveESP(userId)
        local data = espBillboards[userId]
        if data then
            if data.Billboard then
                data.Billboard:Destroy()
            end
            espBillboards[userId] = nil
        end
    end

    local function CreateESP(p)
        if isDestroyed then return end
        if not p.Character then return end
        if p == player then return end
        local head = p.Character:FindFirstChild("Head")
        if not head then return end
        if espBillboards[p.UserId] then return end
        local name = p.Name
        local job = GetPlayerJob(p)
        local teamColor = GetPlayerTeamColor(p)
        local jobColor = GetJobColor(job)
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_" .. p.UserId
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 300, 0, 60)
        billboard.StudsOffset = Vector3.new(0, 2.8, 0)
        billboard.MaxDistance = 500
        billboard.AlwaysOnTop = true
        billboard.Parent = head
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        frame.Parent = billboard
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0, 26)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = name
        nameLabel.TextColor3 = teamColor
        nameLabel.TextSize = 18
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextXAlignment = Enum.TextXAlignment.Center
        nameLabel.TextYAlignment = Enum.TextYAlignment.Center
        nameLabel.Parent = frame
        local jobLabel = Instance.new("TextLabel")
        jobLabel.Size = UDim2.new(1, 0, 0, 22)
        jobLabel.Position = UDim2.new(0, 0, 0, 28)
        jobLabel.BackgroundTransparency = 1
        jobLabel.Text = job
        jobLabel.TextColor3 = jobColor
        jobLabel.TextSize = 16
        jobLabel.Font = Enum.Font.GothamBold
        jobLabel.TextXAlignment = Enum.TextXAlignment.Center
        jobLabel.TextYAlignment = Enum.TextYAlignment.Center
        jobLabel.Parent = frame
        espBillboards[p.UserId] = {
            Billboard = billboard,
            Frame = frame,
            NameLabel = nameLabel,
            JobLabel = jobLabel,
        }
        local con
        con = p.AncestryChanged:Connect(function()
            if not p.Parent or not p.Character then
                RemoveESP(p.UserId)
                if con then
                    con:Disconnect()
                end
            end
        end)
        table.insert(espConnections, con)
    end

    local function UpdateESPVisibility()
        for userId, data in pairs(espBillboards) do
            if data.NameLabel then
                data.NameLabel.Visible = ESPShowName
            end
            if data.JobLabel then
                data.JobLabel.Visible = ESPShowJob
            end
            if data.Billboard then
                data.Billboard.Enabled = ESPEnabled
            end
        end
    end

    espGroup:Toggle({
        Title = "启用透视",
        Default = false,
        Callback = function(value)
            ESPEnabled = value
            if value then
                for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
                    if p ~= player and p.Character then
                        if not espBillboards[p.UserId] then
                            CreateESP(p)
                        end
                    end
                end
                UpdateESPVisibility()
            else
                for userId, data in pairs(espBillboards) do
                    if data.Billboard then
                        data.Billboard.Enabled = false
                    end
                end
            end
        end
    })

    espGroup:Divider()

    espGroup:Toggle({
        Title = "显示名字（队伍颜色）",
        Default = true,
        Callback = function(value)
            ESPShowName = value
            UpdateESPVisibility()
        end
    })

    espGroup:Toggle({
        Title = "显示职业（职业颜色）",
        Default = true,
        Callback = function(value)
            ESPShowJob = value
            UpdateESPVisibility()
        end
    })

    -- 碰撞箱扩展
    local hitboxGroup = GunTab:AddLeftGroupbox("碰撞箱扩展")
    local hitboxEnabled = false
    local hitboxSize = 10
    local whitelistEnabled = false
    local affectedHeads = {}
    local Whitelist = {}

    local function ApplyHitbox()
        if isDestroyed or not hitboxEnabled then return end
        local players = game:GetService("Players"):GetPlayers()
        local newAffected = {}
        for i = 1, #players do
            local p = players[i]
            if p ~= player and p.Character then
                if whitelistEnabled and Whitelist[p.UserId] then
                else
                    local char = p.Character
                    local head = char:FindFirstChild("Head")
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 and head then
                        head.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                        head.Transparency = 1
                        head.Color = Color3.fromRGB(255, 215, 0)
                        head.Material = Enum.Material.Neon
                        head.CanCollide = false
                        newAffected[head] = true
                    end
                end
            end
        end
        for head, _ in pairs(affectedHeads) do
            if not newAffected[head] and head and head.Parent then
                head.Size = Vector3.new(2, 1, 1)
                head.Transparency = 0
                head.CanCollide = true
                head.Color = Color3.new(1, 1, 1)
                head.Material = Enum.Material.Plastic
            end
        end
        affectedHeads = newAffected
    end

    hitboxGroup:Toggle({
        Title = "启用头部碰撞箱",
        Default = false,
        Callback = function(value)
            hitboxEnabled = value
            if value then ApplyHitbox() else 
                for head, _ in pairs(affectedHeads) do
                    if head and head.Parent then
                        head.Size = Vector3.new(2, 1, 1)
                        head.Transparency = 0
                        head.CanCollide = true
                        head.Color = Color3.new(1, 1, 1)
                        head.Material = Enum.Material.Plastic
                    end
                end
                affectedHeads = {}
            end
        end
    })

    hitboxGroup:Slider({
        Title = "头部大小",
        Default = 10,
        Min = 5,
        Max = 400,
        Callback = function(value)
            hitboxSize = value
            if hitboxEnabled then ApplyHitbox() end
        end
    })

    hitboxGroup:Toggle({
        Title = "好友检测 (白名单)",
        Default = false,
        Callback = function(value)
            whitelistEnabled = value
            if value then
                Whitelist = {}
                local players = game:GetService("Players"):GetPlayers()
                for i = 1, #players do
                    local p = players[i]
                    if p ~= player then
                        pcall(function()
                            if p:IsFriendsWith(player.UserId) then
                                Whitelist[p.UserId] = true
                            end
                        end)
                    end
                end
            end
        end
    })

    -- 杀戮光环
    local kaGroup = GunTab:AddLeftGroupbox("杀戮光环")
    kaGroup:AddLabel("注意：需要自己装备枪械武器才有伤害")
    local kaEnabled = false
    local KA_MAX_DISTANCE = 300
    local KA_WALL_CHECK = true
    local kaStatusLabel = nil

    local function kaIsVisible(targetHead)
        local char = player.Character
        if not char then return false end
        local myHead = char:FindFirstChild("Head")
        if not myHead then return false end
        local direction = targetHead.Position - myHead.Position
        local distance = direction.Magnitude
        if distance < 0.1 then return true end
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {char, targetHead.Parent}
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        return workspace:Raycast(myHead.Position, direction.Unit * distance, rayParams) == nil
    end

    local function kaGetNearestEnemy()
        local char = player.Character
        if not char then return nil end
        local myHead = char:FindFirstChild("Head")
        if not myHead then return nil end
        local bestPlayer, bestDist = nil, KA_MAX_DISTANCE
        for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
            if p ~= player and p.Character then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local head = p.Character:FindFirstChild("Head")
                    if head then
                        local dist = (head.Position - myHead.Position).Magnitude
                        if dist < bestDist and (not KA_WALL_CHECK or kaIsVisible(head)) then
                            bestDist = dist
                            bestPlayer = p
                        end
                    end
                end
            end
        end
        return bestPlayer
    end

    kaGroup:Toggle({
        Title = "启用杀戮光环",
        Default = false,
        Callback = function(value)
            kaEnabled = value
            if value then
                WindUI:Notify({Title = "杀戮光环", Content = "已开启，正在搜索敌人", Duration = 3})
            end
        end
    })

    kaGroup:Slider({
        Title = "攻击距离",
        Default = 300,
        Min = 50,
        Max = 1000,
        Callback = function(value)
            KA_MAX_DISTANCE = value
        end
    })

    kaGroup:Toggle({
        Title = "墙体检测",
        Default = true,
        Callback = function(value)
            KA_WALL_CHECK = value
        end
    })

    RunService.Heartbeat:Connect(function()
        if kaEnabled then
            local target = kaGetNearestEnemy()
            local targetHead = target and target.Character and target.Character:FindFirstChild("Head")
            if targetHead then
                local myHead = player.Character and player.Character:FindFirstChild("Head")
                if myHead then
                    local origin = myHead.Position
                    local hitPos = targetHead.Position
                    local direction = (hitPos - origin).Unit
                    pcall(function()
                        local ReplicatedStorage = game:GetService("ReplicatedStorage")
                        ReplicatedStorage.Remote.PlayerEvent:FireServer("damage", {
                            bodyParts = { { "Head", 100 } },
                            shotCode = { origin, direction },
                            target = target,
                            pos = hitPos
                        })
                    end)
                    pcall(function()
                        local handleShots = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
                        handleShots = handleShots and handleShots:FindFirstChild("HandleShots")
                        if handleShots then
                            handleShots:FireServer("2", "Shoot")
                        end
                    end)
                end
            end
        end
    end)

    -- 子追
    local zzGroup = GunTab:AddLeftGroupbox("子追")
    local zzEnabled = false
    local zzDistance = 40
    local zzAffected = nil

    local function zzRestore()
        if zzAffected and zzAffected.Parent then
            pcall(function()
                zzAffected.Size = Vector3.new(2, 1, 1)
                zzAffected.Transparency = 0
            end)
        end
        zzAffected = nil
    end

    zzGroup:Toggle({
        Title = "启用子追",
        Default = false,
        Callback = function(value)
            zzEnabled = value
            if not value then zzRestore() end
        end
    })

    zzGroup:Slider({
        Title = "判定距离",
        Default = 40,
        Min = 0,
        Max = 1000,
        Callback = function(value)
            zzDistance = value
        end
    })

    task.spawn(function()
        while true do
            if zzEnabled then
                local char = player.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local best, bestDist = nil, zzDistance
                if root then
                    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
                        if p ~= player and p.Character then
                            local hum = p.Character:FindFirstChildOfClass("Humanoid")
                            local head = p.Character:FindFirstChild("Head")
                            if hum and hum.Health > 0 and head then
                                local d = (head.Position - root.Position).Magnitude
                                if d < bestDist then
                                    bestDist = d
                                    best = head
                                end
                            end
                        end
                    end
                end
                if best ~= zzAffected then
                    zzRestore()
                    if best then
                        zzAffected = best
                        pcall(function()
                            best.Size = Vector3.new(500, 500, 500)
                            best.Transparency = 1
                            best.CanCollide = false
                        end)
                    end
                end
            else
                zzRestore()
            end
            task.wait(0.1)
        end
    end)

    -- 自瞄
    local aimGroup = GunTab:AddRightGroupbox("自瞄")
    local aimOn = false
    local aimFOV = 150
    local aimNoTeam = true
    local aimWall = true
    local aimGui, aimCircle

    local function aimEnsureCircle()
        if aimGui then return end
        aimGui = Instance.new("ScreenGui")
        aimGui.Name = "SA_AimFOV"
        aimGui.ResetOnSpawn = false
        aimGui.IgnoreGuiInset = true
        aimGui.Parent = player:WaitForChild("PlayerGui")
        aimCircle = Instance.new("Frame")
        aimCircle.AnchorPoint = Vector2.new(0.5, 0.5)
        aimCircle.Position = UDim2.fromScale(0.5, 0.5)
        aimCircle.BackgroundTransparency = 1
        aimCircle.Parent = aimGui
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 1.5
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Transparency = 0.4
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = aimCircle
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = aimCircle
    end

    aimGroup:Toggle({
        Title = "自瞄",
        Default = false,
        Callback = function(value)
            aimOn = value
            if value then aimEnsureCircle()
            if aimGui then aimGui.Enabled = value end
        end
    })

    aimGroup:Slider({
        Title = "FOV圈大小",
        Default = 150,
        Min = 30,
        Max = 400,
        Callback = function(value)
            aimFOV = value
            if aimGui and aimCircle then
                aimCircle.Size = UDim2.fromOffset(value * 2, value * 2)
            end
        end
    })

    aimGroup:Toggle({
        Title = "不瞄准队友",
        Default = true,
        Callback = function(value)
            aimNoTeam = value
        end
    })

    aimGroup:Toggle({
        Title = "墙壁检测",
        Default = true,
        Callback = function(value)
            aimWall = value
        end
    })

    RunService.RenderStepped:Connect(function()
        if not aimOn then return end
        aimEnsureCircle()
        if aimGui then aimGui.Enabled = true end
        if aimCircle then aimCircle.Size = UDim2.fromOffset(aimFOV * 2, aimFOV * 2) end
        local camera = workspace.CurrentCamera
        if not camera then return end
        local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
        local best, bestDist = nil, aimFOV
        for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
            if p ~= player and p.Character then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                local head = p.Character:FindFirstChild("Head")
                if hum and hum.Health > 0 and head then
                    local skip = aimNoTeam and p.Team ~= nil and player.Team ~= nil and p.Team == player.Team
                    if not skip then
                        local sp, onScreen = camera:WorldToViewportPoint(head.Position)
                        if onScreen then
                            local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                            if d < bestDist then
                                local visible = true
                                if aimWall then
                                    local rp = RaycastParams.new()
                                    rp.FilterType = Enum.RaycastFilterType.Exclude
                                    rp.FilterDescendantsInstances = { player.Character }
                                    local res = workspace:Raycast(camera.CFrame.Position, (head.Position - camera.CFrame.Position).Unit * 500, rp)
                                    visible = (not res) or res.Instance:IsDescendantOf(p.Character)
                                end
                                if visible then
                                    bestDist = d
                                    best = head
                                end
                            end
                        end
                    end
                end
            end
        end
        if best then
            camera.CFrame = CFrame.lookAt(camera.CFrame.Position, best.Position)
        end
    end)

    -- 敌我透视
    local teamEspGroup = GunTab:AddRightGroupbox("敌我透视")
    teamEspGroup:AddLabel("红色标注敌人，绿色标注队友")
    local teamEspOn = false
    local teamTracked = {}

    local function teamClearAll()
        for plr, data in pairs(teamTracked) do
            pcall(function() if data.Highlight then data.Highlight:Destroy() end end)
            pcall(function() if data.Billboard then data.Billboard:Destroy() end end)
            teamTracked[plr] = nil
        end
    end

    local function teamApply(plr)
        if plr == player then return end
        local char = plr.Character
        if not char then return end
        local old = teamTracked[plr]
        if old then
            pcall(function() if old.Highlight then old.Highlight:Destroy() end end)
            pcall(function() if old.Billboard then old.Billboard:Destroy() end end)
            teamTracked[plr] = nil
        end
        local isTeam = plr.Team ~= nil and player.Team ~= nil and plr.Team == player.Team
        local color = isTeam and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        local hl = Instance.new("Highlight")
        hl.Adornee = char
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0
        hl.FillColor = color
        hl.OutlineColor = color
        hl.Parent = char
        local bb
        local head = char:FindFirstChild("Head")
        if head then
            bb = Instance.new("BillboardGui")
            bb.Size = UDim2.new(0, 100, 0, 22)
            bb.StudsOffset = Vector3.new(0, 3.2, 0)
            bb.AlwaysOnTop = true
            bb.Adornee = head
            local tl = Instance.new("TextLabel")
            tl.Size = UDim2.new(1, 0, 1, 0)
            tl.BackgroundTransparency = 1
            tl.Text = isTeam and "队友" or "敌人"
            tl.TextColor3 = color
            tl.TextStrokeTransparency = 0
            tl.Font = Enum.Font.GothamBold
            tl.TextSize = 14
            tl.Parent = bb
            bb.Parent = head
        end
        teamTracked[plr] = { Highlight = hl, Billboard = bb }
    end

    teamEspGroup:Toggle({
        Title = "透视敌人和队友",
        Default = false,
        Callback = function(value)
            teamEspOn = value
            if not value then teamClearAll() end
        end
    })

    task.spawn(function()
        while true do
            if teamEspOn then
                for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
                    teamApply(plr)
                end
            end
            task.wait(0.5)
        end
    end)

    game:GetService("Players").PlayerRemoving:Connect(function(plr)
        local data = teamTracked[plr]
        if data then
            pcall(function() if data.Highlight then data.Highlight:Destroy() end end)
            pcall(function() if data.Billboard then data.Billboard:Destroy() end end)
            teamTracked[plr] = nil
        end
    end)

    -- 人物描边透视
    local outlineGroup = GunTab:AddRightGroupbox("人物描边透视")
    local outlineESPEnabled = false
    local outlineESPData = {}

    local function RemoveOutlineESP(userId)
        local data = outlineESPData[userId]
        if data then
            if data.Highlight then
                data.Highlight:Destroy()
            end
            if data.Billboard then
                data.Billboard:Destroy()
            end
            outlineESPData[userId] = nil
        end
    end

    local function ClearAllOutlineESP()
        for userId, _ in pairs(outlineESPData) do
            RemoveOutlineESP(userId)
        end
    end

    local function CreateOutlineESP(p)
        if isDestroyed then return end
        if p == player then return end
        local char = p.Character
        if not char then return end
        local head = char:FindFirstChild("Head")
        if not head then return end
        if outlineESPData[p.UserId] then
            local data = outlineESPData[p.UserId]
            if data.Highlight then data.Highlight.Enabled = true end
            if data.Billboard then data.Billboard.Enabled = true end
            return
        end
        local highlight = Instance.new("Highlight")
        highlight.Name = "OutlineESP_" .. p.UserId
        highlight.Adornee = char
        highlight.FillColor = Color3.fromRGB(255, 255, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
        highlight.FillTransparency = 0.6
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = char
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "OutlineESPGui_" .. p.UserId
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3.5, 0)
        billboard.AlwaysOnTop = true
        billboard.MaxDistance = 1000
        billboard.Parent = head
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 0)
        label.TextSize = 15
        label.Font = Enum.Font.GothamBold
        label.TextStrokeTransparency = 0
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        label.Text = p.Name
        label.Parent = billboard
        outlineESPData[p.UserId] = {
            Player = p,
            Highlight = highlight,
            Billboard = billboard,
            Label = label,
        }
    end

    local function UpdateOutlineESP()
        if not outlineESPEnabled or isDestroyed then return end
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
            if p ~= player and p.Character then
                if not outlineESPData[p.UserId] then
                    CreateOutlineESP(p)
                end
                local data = outlineESPData[p.UserId]
                if data and data.Label then
                    local targetHead = p.Character:FindFirstChild("Head")
                    if targetHead and root then
                        local dist = (targetHead.Position - root.Position).Magnitude
                        data.Label.Text = p.Name .. "\n[" .. math.floor(dist) .. "]"
                    else
                        data.Label.Text = p.Name
                    end
                    if data.Billboard then
                        data.Billboard.Enabled = true
                    end
                    if data.Highlight then
                        data.Highlight.Enabled = true
                    end
                end
            elseif p ~= player then
                RemoveOutlineESP(p.UserId)
            end
        end
    end

    outlineGroup:Toggle({
        Title = "人物描边透视",
        Default = false,
        Callback = function(value)
            outlineESPEnabled = value
            if value then
                UpdateOutlineESP()
            else
                ClearAllOutlineESP()
            end
        end
    })

    task.spawn(function()
        while true do
            if outlineESPEnabled then
                UpdateOutlineESP()
            end
            task.wait(0.1)
        end
    end)

    -- ===== 传送点Tab =====
    local TeleportTab = Window:Tab({Title = "传送点", Icon = "map-pin"})
    local teleGroup = TeleportTab:AddLeftGroupbox("传送控制")
    local TeleportEnabled = false

    local function GetTeleportData()
        return {
            {n = "车辆经销商", p = Vector3.new(3719.9501953125, 3.018573522567749, -333.3118591308594)},
            {n = "医院", p = Vector3.new(3980.091064453125, 2.876060724258423, -138.79454040527344)},
            {n = "警察局", p = Vector3.new(3364.273193359375, 3.9188079834, -394.7233581542969)},
            {n = "圣奥里修车店", p = Vector3.new(2782.46875, 2.630995750427246, -418.59930419921875)},
            {n = "圣奥里银行", p = Vector3.new(3134.05419921875, 6.116048336029053, -171.36976623535156)},
            {n = "圣奥里服装店", p = Vector3.new(3617.91259765625, 3.1072206497192383, -452.8206481933594)},
            {n = "圣奥里平民重生", p = Vector3.new(3741.114990234375, 3.720573663711548, -438.1059875488281)},
            {n = "圣奥里码头", p = Vector3.new(4527.65625, -23.968238830566406, -280.59356689453125)},
            {n = "圣奥里餐饮店", p = Vector3.new(3182.416748046875, 3.01859188079834, 426.5179138183594)},
            {n = "消防部门", p = Vector3.new(3578.676025390625, 8.408823013305664, 579.6567993164062)},
            {n = "宠物店", p = Vector3.new(3678.237305, 3.017920, 693.114624)},
            {n = "圣奥里大码头", p = Vector3.new(2736.307617, 2.630299, -1120.333008)},
            {n = "圣奥里海滩桥下(消星点)", p = Vector3.new(3964.504395, -25.068211, -854.057251)},
            {n = "大景超市", p = Vector3.new(3936.582764, 3.038293, 1136.326416)},
            {n = "转镜中心", p = Vector3.new(4152.919922, 2.631675, 941.446045)},
            {n = "道路服务", p = Vector3.new(4271.332520, 2.628108, 1200.086914)},
            {n = "大景餐饮店", p = Vector3.new(4476.997559, 3.037825, 906.802979)},
            {n = "送货中心", p = Vector3.new(4399.419434, 3.038999, 1609.455933)},
            {n = "大景卖车店", p = Vector3.new(3434.377441, 42.931786, 2687.997070)},
            {n = "莱斯维尔餐饮店", p = Vector3.new(753.757812, 3.039824, 998.132996)},
            {n = "莱斯维尔服装店", p = Vector3.new(820.745117, 2.766988, 1047.445679)},
            {n = "莱斯维尔自由广场", p = Vector3.new(926.523376, 2.630995, 865.764771)},
            {n = "莱斯维尔码头(游艇)", p = Vector3.new(947.840210, -22.529087, 1216.085693)},
            {n = "米尔顿左上加油站", p = Vector3.new(1145.635742, 2.630916, -864.273682)},
            {n = "米尔顿右下加油站", p = Vector3.new(-1646.802734, 2.630164, 1812.894653)},
            {n = "米尔顿上方加油站", p = Vector3.new(-900.701660, 2.630927, 1124.683105)},
            {n = "米尔顿居民区", p = Vector3.new(-528.565552, 2.630996, 1331.981689)},
            {n = "约克镇小银行", p = Vector3.new(-668.217224, 2.630995, -65.347839)},
            {n = "约克镇修车厂", p = Vector3.new(-407.163025, 3.076807, -6.098211)},
            {n = "约克镇枪店", p = Vector3.new(-323.869293, 3.037825, 37.149670)},
            {n = "约克镇重生点", p = Vector3.new(-219.560318, 3.039824, -85.725433)},
            {n = "约克镇当铺", p = Vector3.new(-168.513733, 3.039000, -106.926529)},
            {n = "约克镇卫星车", p = Vector3.new(-302.093567, 3.037825, -167.621017)},
            {n = "约克镇中心点", p = Vector3.new(-275.995209, 2.630996, -139.985352)},
            {n = "黑市", p = Vector3.new(1038.969849, -22.732950, 895.430237)},
            {n = "渔夫码头", p = Vector3.new(-50.147552, -24.555279, 1462.145996)},
            {n = "农场", p = Vector3.new(-1268.339233, 2.572412, 2560.060303)},
            {n = "监狱门口", p = Vector3.new(-1697.931885, 2.630666, 1284.567383)},
            {n = "监狱广场", p = Vector3.new(-1600.602417, 2.631028, 1268.060059)},
            {n = "代尔山", p = Vector3.new(847.062988, 194.115753, -326.212708)},
            {n = "瀑布洞穴(消星点)", p = Vector3.new(3040.956055, 109.688538, 2711.069336)},
            {n = "大桥", p = Vector3.new(949.014954, 25.215754, 2897.654785)},
            {n = "地图右下(消星点)", p = Vector3.new(-1651.385010, 2.414712, 3225.278320)},
            {n = "下部加油站", p = Vector3.new(2270.378174, 2.630927, 154.161484)},
            {n = "游戏厅", p = Vector3.new(2934.893799, 2.956458, 1693.660034)},
            {n = "高尔夫", p = Vector3.new(2280.767090, 3.037836, 1982.357300)},
            {n = "修船厂", p = Vector3.new(4096.405273, -30.401447, 2865.045166)},
        }
    end
    local FIXED_TELEPORTS = GetTeleportData()

    local function TeleportTo(pos)
        if not TeleportEnabled or isDestroyed then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        pcall(function()
            root.CFrame = CFrame.new(pos)
        end)
    end

    teleGroup:Toggle({
        Title = "启用传送",
        Default = false,
        Callback = function(value)
            TeleportEnabled = value
        end
    })

    local teleNames = {}
    for _, data in ipairs(FIXED_TELEPORTS) do
        table.insert(teleNames, data.n)
    end

    teleGroup:Dropdown({
        Title = "选定传送地点",
        Values = teleNames,
        Default = 1,
        Callback = function(value) end,
    })

    teleGroup:Button({
        Title = "传送到选定地点",
        Callback = function()
            if not TeleportEnabled then
                WindUI:Notify({Title = "传送", Content = "请先开启传送开关", Duration = 3})
                return
            end
            local selected = teleNames[1]
            for _, data in ipairs(FIXED_TELEPORTS) do
                if data.n == selected then
                    TeleportTo(data.p)
                    WindUI:Notify({Title = "传送", Content = "正在传送至: " .. data.n, Duration = 2})
                    return
                end
            end
        end
    })

    -- ===== 设置Tab =====
    local SettingsTab = Window:Tab({Title = "ui设置", Icon = "palette"})
    
    SettingsTab:Paragraph({
        Title = "ui设置",
        Desc = "二改wind原版ui",
        Image = "settings",
        ImageSize = 20,
        Color = "White"
    })

    SettingsTab:Toggle({
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

    SettingsTab:Toggle({
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

    SettingsTab:Toggle({
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

    SettingsTab:Toggle({
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

    SettingsTab:Dropdown({
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

    SettingsTab:Dropdown({
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

    SettingsTab:Dropdown({
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

    SettingsTab:Slider({
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

    SettingsTab:Slider({
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

    SettingsTab:Divider()

    SettingsTab:Slider({
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

    SettingsTab:Slider({
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

    SettingsTab:Slider({
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

    SettingsTab:Slider({
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

    SettingsTab:Slider({
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

    SettingsTab:Button({
        Title = "恢复UI到原位",
        Icon = "rotate-ccw",
        Callback = function()
            if Window.UIElements and Window.UIElements.Main then
                Window.UIElements.Main.Position = UDim2.new(0.5, 0, 0.5, 0)
                playSound()
            end
        end
    })

    SettingsTab:Button({
        Title = "重置UI大小",
        Icon = "maximize-2",
        Callback = function()
            if Window.UIElements and Window.UIElements.Main then
                Window.UIElements.Main.Size = UDim2.fromOffset(600, 400)
                playSound()
            end
        end
    })

    SettingsTab:Button({
        Title = "随机字体",
        Icon = "shuffle",
        Callback = function()
            local randomFont = FONT_STYLES[math.random(1, #FONT_STYLES)]
            currentFontStyle = randomFont
            applyFontStyleToWindow(randomFont)
            playSound()
        end
    })

    SettingsTab:Button({
        Title = "随机颜色",
        Icon = "palette",
        Callback = function()
            local randomColor = colorSchemeNames[math.random(1, #colorSchemeNames)]
            currentBorderColorScheme = randomColor
            initializeRainbowBorder(randomColor, animationSpeed)
            playSound()
        end
    })

    SettingsTab:Divider()

    SettingsTab:Button({
        Title = "刷新字体颜色",
        Icon = "refresh-cw",
        Callback = function()
            applyFontColorsToWindow(currentFontColorScheme)
            playSound()
        end
    })

    SettingsTab:Button({
        Title = "刷新字体样式",
        Icon = "refresh-cw",
        Callback = function()
            local successCount, totalCount = applyFontStyleToWindow(currentFontStyle)
            playSound()
        end
    })

    SettingsTab:Button({
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

    SettingsTab:Button({
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
            setclipboard("wdfex-HUB  设置: " .. game:GetService("HttpService"):JSONEncode(settings))
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