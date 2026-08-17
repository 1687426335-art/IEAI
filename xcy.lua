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
    -- ===== 加载XA-Hub功能 =====
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end

    if not isfolder("XA-Hub") then
        makefolder("XA-Hub")
    end
    if not isfolder("XA-Hub/Fluent") then
        makefolder("XA-Hub/Fluent")
    end
    if not isfile("XA-Hub/Fluent/AutoFindMoneyPrinter.txt") then
        writefile("XA-Hub/Fluent/AutoFindMoneyPrinter.txt", "false")
    end

    local autoFind = readfile("XA-Hub/Fluent/AutoFindMoneyPrinter.txt")
    if autoFind == "true" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Xingtaiduan/Script/refs/heads/main/Games/俄亥俄州_印钞机.lua"))()
        return
    end

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

    task.spawn(function()
        for _, item in pairs(workspace.ItemsOnSale:GetChildren()) do
            ItemsOnSaleList[item.Name] = item.Name
        end

        for _, conn in pairs(getconnections(game:GetService("RunService").Heartbeat)) do
            local fn = conn.Function
            if fn and getfenv(fn).script == ReplicatedStorage.devv.client.Handlers.ClientValidate then
                conn:Disable()
                game.StarterGui:SetCore("SendNotification", {
                    Title = "XA：提示",
                    Text = "飞行/速度封禁绕过成功"
                })
            end
        end

        getgenv().fixedremotes = {}
        for name, remote in next, RemotesModule do
            local upval = debug.getupvalue(remote, 1)
            if upval then
                getgenv().fixedremotes[name] = upval
            end
        end
    end)

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
        game.StarterGui:SetCore("SendNotification", {
            Title = "XA：错误",
            Text = "未找到玩家"
        })
        return nil
    end

    local OriginalNamecall
    OriginalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local method = getnamecallmethod()

        if checkcaller() then
            return OriginalNamecall(self, ...)
        end

        if method == "FireServer" and self == Remotes.meleeItemHit then
            if tostring(args[1]) == "player" and not table.find(Whitelist, args[2].hitPlayerId) then
                if Fluent.Options.OnePunch.Value then
                    if not string.find(tostring(args[2].meleeType), "swing") then
                        args[2].meleeType = "meleemegapunch"
                    end
                end
                if Fluent.Options.OneSwing.Value then
                    if string.find(tostring(args[2].meleeType), "swing") then
                        args[2].meleeType = "meleemegaswing"
                    end
                end
                return OriginalNamecall(self, unpack(args))
            end
        end

        if Fluent.Options.Hitbox.Value and method == "FireServer" and self == Remotes.projectileHit then
            local hitPart = args[2].hitPart
            local model = hitPart:FindFirstAncestorOfClass("Model")
            local hitPlayer = Players:GetPlayerFromCharacter(model)
            if model and hitPlayer then
                args[2].hitPart = model.Hitbox["Head_Hitbox"]
                args[2].hitPlayerId = hitPlayer.UserId
                args[2].hitSize = args[2].hitPart.Size
                args[2].pos = args[2].hitPart.Position
            end
            return OriginalNamecall(self, unpack(args))
        end

        return OriginalNamecall(self, ...)
    end)

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

    -- ===== Fluent 兼容层 =====
    local Fluent = {
        Options = {
            OnePunch = { Value = false },
            OneSwing = { Value = false },
            KillAura = { Value = false },
            StompAura = { Value = false },
            GrabAura = { Value = false },
            Killall = { Value = false },
            AutoEquip = { Value = false },
            Godmode = { Value = false },
            Invisible = { Value = false },
            RPGBomb = { Value = false },
            AutoArmor = { Value = false },
            Hitbox = { Value = false },
            HitboxSize = { Value = "15" },
            HitboxTransparency = { Value = "0.8" },
            ATMFarm = { Value = false },
            RegisterFarm = { Value = false },
            AutoRobBank = { Value = false },
            CashFarm = { Value = false },
            CashAura = { Value = false },
            ItemFarm = { Value = false },
            ItemAura = { Value = false },
            SelectedItems = { Value = {} },
            SItemsFarm = { Value = false },
            ReturnOnTeleport = { Value = false },
            NotifyAirdrop = { Value = false },
            ShowBuyUI = { Value = false },
            BlackMarket = { Value = false },
            Locker = { Value = false },
            FastInteract = { Value = false },
            ItemESP = { Value = false },
            CashESP = { Value = false },
            WalkSpeed = { Value = 16, IsMoved = false },
            JumpPower = { Value = 50, IsMoved = false },
            Noclip = { Value = false },
            Fullbright = { Value = false },
            InfJump = { Value = false },
            ShowChat = { Value = false },
            SpamPlayer = { Value = false },
            SpamCall = { Value = false },
            SpamAll = { Value = false },
            SpamMessage = { Value = "XA-Hub No.1" },
            ItemSlots = { Value = "" },
        },
        Notify = function(data)
            WindUI:Notify({
                Title = data.Title or "通知",
                Content = data.Content or "",
                Duration = data.Duration or 3,
            })
        end,
        GiveSignal = function(connection)
            return connection
        end
    }

    -- ===== 战斗类Tab =====
    local TabCombat = Window:Tab({ Title = "战斗类", Icon = "" })
    
    local combatSection = TabCombat:Section({ Title = "战斗功能", TextXAlignment = "Left" })
    
    combatSection:Toggle({
        Title = "一拳秒杀",
        Default = false,
        Callback = function(val)
            Fluent.Options.OnePunch.Value = val
        end
    })
    
    combatSection:Toggle({
        Title = "其他近战武器秒杀",
        Default = false,
        Callback = function(val)
            Fluent.Options.OneSwing.Value = val
        end
    })
    
    combatSection:Toggle({
        Title = "杀戮光环",
        Default = false,
        Callback = function(val)
            Fluent.Options.KillAura.Value = val
            if val then
                Remotes.FireServer("equip", Inventory.getFromName("Fists").guid)
            end
        end
    })
    
    combatSection:Toggle({
        Title = "踩人光环",
        Default = false,
        Callback = function(val)
            Fluent.Options.StompAura.Value = val
        end
    })
    
    combatSection:Toggle({
        Title = "抓人光环",
        Default = false,
        Callback = function(val)
            Fluent.Options.GrabAura.Value = val
        end
    })
    
    combatSection:Toggle({
        Title = "杀死全部",
        Default = false,
        Callback = function(val)
            Fluent.Options.Killall.Value = val
            if val then
                Remotes.FireServer("equip", Inventory.getFromName("Fists").guid)
            end
            HumanoidRootPart.Anchored = val
            while Fluent.Options.Killall.Value do
                task.wait()
                for _, player in pairs(Players:GetPlayers()) do
                    if not Fluent.Options.Killall.Value then break end
                    if player == LocalPlayer then continue end
                    if table.find(Whitelist, player.UserId) then continue end
                    local char = player.Character
                    if not char then continue end
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if not hum then continue end
                    if char:FindFirstChild("ForceField") then continue end
                    if hum.Health <= 5 then continue end
                    task.wait()
                    Humanoid.Sit = false
                    Character:PivotTo(char.HumanoidRootPart.CFrame)
                    Remotes.FireServer("meleeItemHit", "player", {
                        meleeType = "meleemegapunch",
                        hitPlayerId = player.UserId
                    })
                    Remotes.FireServer("stomp", player)
                    task.wait(0.7)
                end
            end
            HumanoidRootPart.Anchored = false
        end
    })
    
    combatSection:Toggle({
        Title = "死亡自动装备拳头",
        Default = false,
        Callback = function(val)
            Fluent.Options.AutoEquip.Value = val
        end
    })
    
    combatSection:Toggle({
        Title = "防倒地",
        Default = false,
        Callback = function(val)
            Fluent.Options.Godmode.Value = val
        end
    })
    
    combatSection:Toggle({
        Title = "隐身",
        Desc = "可用枪械攻击",
        Default = false,
        Callback = function(val)
            Fluent.Options.Invisible.Value = val
            if val then
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
            else
                local chair = workspace:FindFirstChild("invischair")
                if chair then chair:Remove() end
            end
        end
    })
    
    combatSection:Toggle({
        Title = "RPG全图轰炸",
        Default = false,
        Callback = function(val)
            Fluent.Options.RPGBomb.Value = val
            if not val then return end
            if not Inventory.getFromName("RPG") then
                Remotes.InvokeServer("attemptPurchase", "RPG")
            end
            local equip = Inventory.getEquippedItem()
            if equip and equip.name ~= "RPG" then return end
            if equip then
                Remotes.FireServer("replicateProjectiles", equip.guid, {
                    { "AmmoGuid", HumanoidRootPart.CFrame }
                }, "semi")
            end
            task.spawn(function()
                while Fluent.Options.RPGBomb.Value do
                    task.wait()
                    local item = Inventory.getEquippedItem()
                    if not item or item.name ~= "RPG" then continue end
                    for _, player in pairs(Players:GetPlayers()) do
                        if not Fluent.Options.RPGBomb.Value then break end
                        if player == LocalPlayer then continue end
                        if table.find(Whitelist, player.UserId) then continue end
                        local char = player.Character
                        if not char then continue end
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if not hum or hum.Health <= 10 then continue end
                        if char:FindFirstChild("ForceField") then continue end
                        Remotes.FireServer("rocketHit", "AmmoGuid", "explosionGUID", char.HumanoidRootPart.Position)
                    end
                end
            end)
            repeat task.wait(5) until not Fluent.Options.RPGBomb.Value
        end
    })
    
    combatSection:Toggle({
        Title = "自动穿甲",
        Default = false,
        Callback = function(val)
            Fluent.Options.AutoArmor.Value = val
            while Fluent.Options.AutoArmor.Value do
                task.wait()
                if not Character then continue end
                local armor = LocalPlayer:GetAttribute("armor")
                if not armor or armor <= 0 then
                    Remotes.InvokeServer("attemptPurchase", "Light Vest")
                    local guid = Inventory.getFromName("Light Vest").guid
                    Remotes.FireServer("equip", guid)
                    Remotes.FireServer("useConsumable", guid)
                    Remotes.FireServer("removeItem", guid)
                end
            end
        end
    })
    
    local hitboxSection = TabCombat:Section({ Title = "子弹范围", TextXAlignment = "Left" })
    
    local HitboxConnection
    hitboxSection:Toggle({
        Title = "开关",
        Default = false,
        Callback = function(val)
            Fluent.Options.Hitbox.Value = val
            if val then
                HitboxConnection = RunService.RenderStepped:Connect(function()
                    for _, player in next, Players:GetPlayers() do
                        pcall(function()
                            player.Character.HumanoidRootPart.Size = Vector3.new(
                                tonumber(Fluent.Options.HitboxSize.Value) or 15,
                                tonumber(Fluent.Options.HitboxSize.Value) or 15,
                                tonumber(Fluent.Options.HitboxSize.Value) or 15
                            )
                            player.Character.HumanoidRootPart.Transparency = tonumber(Fluent.Options.HitboxTransparency.Value) or 0.8
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
        end
    })
    
    hitboxSection:Input({
        Title = "输入大小",
        Placeholder = "15",
        Callback = function(val)
            Fluent.Options.HitboxSize.Value = val
        end
    })
    
    hitboxSection:Input({
        Title = "输入透明度",
        Placeholder = "0.8",
        Callback = function(val)
            Fluent.Options.HitboxTransparency.Value = val
        end
    })
    
    local whitelistSection = TabCombat:Section({ Title = "白名单", TextXAlignment = "Left" })
    
    local WhitelistInput
    WhitelistInput = whitelistSection:Input({
        Title = "输入名称 当前：无",
        Placeholder = "输入玩家名称",
        Callback = function(val)
            local found = FindPlayer(val)
            if found then
                WhitelistInput:SetTitle("输入名称 当前：" .. found.Name)
                SelectedTarget = found
            else
                WhitelistInput:SetTitle("输入名称 当前：无")
                SelectedTarget = nil
            end
        end
    })
    
    whitelistSection:Button({
        Title = "添加至白名单",
        Callback = function()
            if SelectedTarget then
                if not table.find(Whitelist, SelectedTarget.UserId) then
                    table.insert(Whitelist, SelectedTarget.UserId)
                    WindUI:Notify({
                        Title = "XA",
                        Content = "已添加 " .. SelectedTarget.Name .. " 至白名单",
                        Duration = 2,
                    })
                else
                    WindUI:Notify({
                        Title = "XA",
                        Content = "该玩家已经在白名单中",
                        Duration = 2,
                    })
                end
            else
                WindUI:Notify({
                    Title = "XA",
                    Content = "请先输入玩家名称",
                    Duration = 2,
                })
            end
        end
    })
    
    whitelistSection:Button({
        Title = "移除白名单",
        Callback = function()
            if SelectedTarget then
                local idx = table.find(Whitelist, SelectedTarget.UserId)
                if idx then
                    table.remove(Whitelist, idx)
                    WindUI:Notify({
                        Title = "XA",
                        Content = "已移除 " .. SelectedTarget.Name .. " 白名单",
                        Duration = 2,
                    })
                else
                    WindUI:Notify({
                        Title = "XA",
                        Content = "该玩家不在白名单中",
                        Duration = 2,
                    })
                end
            else
                WindUI:Notify({
                    Title = "XA",
                    Content = "请先输入玩家名称",
                    Duration = 2,
                })
            end
        end
    })
    
    whitelistSection:Button({
        Title = "清空白名单",
        Callback = function()
            table.clear(Whitelist)
            WindUI:Notify({
                Title = "XA",
                Content = "已清空白名单",
                Duration = 2,
            })
        end
    })

    -- ===== 物品Tab =====
    local TabItems = Window:Tab({ Title = "物品", Icon = "" })
    local SelectedItem = nil
    
    local itemSection = TabItems:Section({ Title = "物品功能", TextXAlignment = "Left" })
    
    itemSection:Dropdown({
        Title = "选择物品",
        Options = (function()
            local list = {}
            for k in pairs(ItemsOnSaleList) do
                table.insert(list, k)
            end
            table.sort(list)
            return list
        end)(),
        Default = "",
        Callback = function(val)
            SelectedItem = val
        end
    })
    
    itemSection:Button({
        Title = "购买",
        Callback = function()
            if SelectedItem then
                Remotes.InvokeServer("attemptPurchase", SelectedItem)
            else
                WindUI:Notify({
                    Title = "错误",
                    Content = "请先选择物品",
                    Duration = 2,
                })
            end
        end
    })
    
    itemSection:Button({
        Title = "购买子弹",
        Callback = function()
            if SelectedItem then
                Remotes.InvokeServer("attemptPurchaseAmmo", SelectedItem)
            else
                WindUI:Notify({
                    Title = "错误",
                    Content = "请先选择物品",
                    Duration = 2,
                })
            end
        end
    })
    
    itemSection:Toggle({
        Title = "显示购买界面",
        Default = false,
        Callback = function(val)
            Fluent.Options.ShowBuyUI.Value = val
            while Fluent.Options.ShowBuyUI.Value do
                task.wait()
                if not SelectedItem then continue end
                local itemNode = workspace.ItemsOnSale:FindFirstChild(SelectedItem)
                if itemNode then
                    local td = itemNode:FindFirstChildOfClass("TouchDetector")
                    if td then
                        firetouchinterest(td.Parent, HumanoidRootPart, 0)
                        firetouchinterest(td.Parent, HumanoidRootPart, 1)
                    end
                end
            end
        end
    })
    
    itemSection:Toggle({
        Title = "远程黑市",
        Default = false,
        Callback = function(val)
            Fluent.Options.BlackMarket.Value = val
            workspace.BlackMarket.Dealer.Dealer.ProximityPrompt.MaxActivationDistance = val and 10000 or 20
        end
    })
    
    itemSection:Toggle({
        Title = "远程储物柜",
        Desc = "打开背包即可",
        Default = false,
        Callback = function(val)
            Fluent.Options.Locker.Value = val
            LocalPlayer.PlayerGui.Backpack.Holder.Locker.Visible = val
        end
    })
    
    local FastInteractConn
    itemSection:Toggle({
        Title = "快速互动",
        Default = false,
        Callback = function(val)
            Fluent.Options.FastInteract.Value = val
            if val then
                FastInteractConn = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
                    fireproximityprompt(prompt)
                end)
            else
                if FastInteractConn then FastInteractConn:Disconnect() end
            end
        end
    })
    
    -- ===== 自动Tab =====
    local TabAuto = Window:Tab({ Title = "自动", Icon = "" })
    
    local autoSection = TabAuto:Section({ Title = "自动功能", TextXAlignment = "Left" })
    
    autoSection:Toggle({
        Title = "自动打ATM",
        Default = false,
        Callback = function(val)
            Fluent.Options.ATMFarm.Value = val
            if val then
                Remotes.FireServer("equip", Inventory.getFromName("Fists").guid)
            end
            while Fluent.Options.ATMFarm.Value do
                task.wait()
                for _, atm in pairs(workspace.Game.Props.ATM:GetChildren()) do
                    if not Fluent.Options.ATMFarm.Value then break end
                    if atm:GetAttribute("state") ~= "destroyed" then
                        while atm:GetAttribute("state") ~= "destroyed" and Fluent.Options.ATMFarm.Value do
                            task.wait()
                            Character:PivotTo(atm:GetPivot())
                            Remotes.FireServer("meleeItemHit", "prop", {
                                meleeType = "meleepunch",
                                guid = atm:GetAttribute("guid")
                            })
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
        end
    })
    
    autoSection:Toggle({
        Title = "自动打收银机",
        Default = false,
        Callback = function(val)
            Fluent.Options.RegisterFarm.Value = val
            if val then
                Remotes.FireServer("equip", Inventory.getFromName("Fists").guid)
            end
            while Fluent.Options.RegisterFarm.Value do
                task.wait()
                for _, reg in pairs(workspace.Game.Props.CashRegister:GetChildren()) do
                    if not Fluent.Options.RegisterFarm.Value then break end
                    if reg:GetAttribute("state") ~= "destroyed" then
                        while reg:GetAttribute("state") ~= "destroyed" and Fluent.Options.RegisterFarm.Value do
                            task.wait()
                            Character:PivotTo(reg:GetPivot())
                            Remotes.FireServer("meleeItemHit", "prop", {
                                meleeType = "meleepunch",
                                guid = reg:GetAttribute("guid")
                            })
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
        end
    })
    
    autoSection:Toggle({
        Title = "自动抢银行",
        Default = false,
        Callback = function(val)
            Fluent.Options.AutoRobBank.Value = val
            while Fluent.Options.AutoRobBank.Value do
                local cash = workspace.BankRobbery.BankCash.Cash
                repeat task.wait() until #cash:GetChildren() ~= 0
                pcall(function()
                    HumanoidRootPart.CFrame = workspace.BankRobbery.VaultDoor.Door.CFrame
                    fireproximityprompt(workspace.BankRobbery.VaultDoor.Door.Attachment.ProximityPrompt)
                    task.wait(0.5)
                end)
                repeat task.wait() until not workspace.BankRobbery.VaultDoor.Door.Attachment.ProximityPrompt.Enabled
                HumanoidRootPart.CFrame = workspace.BankRobbery.BankCash.Pallet.CFrame
                fireproximityprompt(workspace.BankRobbery.BankCash.Main.Attachment.ProximityPrompt)
                task.wait(0.5)
                task.wait()
            end
        end
    })
    
    autoSection:Toggle({
        Title = "自动捡钱",
        Default = false,
        Callback = function(val)
            Fluent.Options.CashFarm.Value = val
            while Fluent.Options.CashFarm.Value do
                task.wait()
                for _, bundle in pairs(workspace.Game.Entities.CashBundle:GetChildren()) do
                    if not Fluent.Options.CashFarm.Value then break end
                    local cd = bundle:FindFirstChildOfClass("ClickDetector")
                    if cd then
                        Character:PivotTo(bundle:GetPivot())
                        task.wait(0.5)
                        fireclickdetector(cd)
                        task.wait(1)
                    end
                end
            end
        end
    })
    
    autoSection:Toggle({
        Title = "捡钱光环",
        Default = false,
        Callback = function(val)
            Fluent.Options.CashAura.Value = val
            while Fluent.Options.CashAura.Value do
                for _, bundle in pairs(workspace.Game.Entities.CashBundle:GetChildren()) do
                    local cd = bundle:FindFirstChildOfClass("ClickDetector")
                    if cd and (HumanoidRootPart.Position - bundle:GetPivot().Position).Magnitude <= cd.MaxActivationDistance then
                        fireclickdetector(cd)
                    end
                end
                wait(0.25)
            end
        end
    })
    
    autoSection:Toggle({
        Title = "自动捡物品",
        Default = false,
        Callback = function(val)
            Fluent.Options.ItemFarm.Value = val
            while Fluent.Options.ItemFarm.Value do
                task.wait()
                for _, item in pairs(workspace.Game.Entities.ItemPickup:GetChildren()) do
                    if not Fluent.Options.ItemFarm.Value then break end
                    local cd = item:FindFirstChildWhichIsA("ClickDetector", true)
                    if cd then
                        Character:PivotTo(cd.Parent.CFrame)
                        task.wait(0.5)
                        fireclickdetector(cd)
                        task.wait(1.5)
                    end
                end
            end
        end
    })
    
    autoSection:Toggle({
        Title = "捡物品光环",
        Default = false,
        Callback = function(val)
            Fluent.Options.ItemAura.Value = val
            while Fluent.Options.ItemAura.Value do
                for _, item in pairs(workspace.Game.Entities.ItemPickup:GetChildren()) do
                    if not Fluent.Options.ItemAura.Value then
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
        end
    })
    
    autoSection:Dropdown({
        Title = "选择物品",
        Options = { "红卡", "蓝卡", "印钞机", "气球" },
        Multi = true,
        Default = {},
        Callback = function(val)
            Fluent.Options.SelectedItems.Value = val
        end
    })
    
    autoSection:Toggle({
        Title = "自动捡选中的物品",
        Default = false,
        Callback = function(val)
            Fluent.Options.SItemsFarm.Value = val
            if not val then return end
            local v = Fluent.Options.SelectedItems.Value
            for _, item in pairs(workspace.Game.Entities.ItemPickup:GetDescendants()) do
                if item:IsA("ProximityPrompt") then
                    local match = (v["红卡"] and item.ObjectText == "Military Armory Keycard")
                        or (v["蓝卡"] and item.ObjectText == "Police Armory Keycard")
                        or (v["印钞机"] and item.ObjectText == "Money Printer")
                        or (v["气球"] and item.ObjectText:match("Balloon"))
                    if match then
                        local savedCF = HumanoidRootPart.CFrame
                        Character:PivotTo(item.Parent:GetPivot())
                        task.wait()
                        for i = 1, 5 do
                            fireproximityprompt(item)
                            task.wait(0.1)
                        end
                        Character:PivotTo(savedCF)
                        wait(1.5)
                    end
                end
            end
        end
    })
    
    autoSection:Toggle({
        Title = "是否回传",
        Default = false,
        Callback = function(val)
            Fluent.Options.ReturnOnTeleport.Value = val
        end
    })
    
    autoSection:Toggle({
        Title = "空投刷新提示",
        Default = false,
        Callback = function(val)
            Fluent.Options.NotifyAirdrop.Value = val
        end
    })
    
    autoSection:Button({
        Title = "自动换服寻找印钞机",
        Callback = function()
            WindUI:Notify({
                Title = "使用说明",
                Content = "如果您的注入器不受脚本支持\n请在手机目录/" .. identifyexecutor() .. "/Autoexec文件夹添加脚本 以便脚本自动执行",
                Duration = 5,
            })
            wait(3)
            writefile("XA-Hub/Fluent/AutoFindMoneyPrinter.txt", "true")
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Xingtaiduan/Script/refs/heads/main/Games/俄亥俄州_印钞机.lua"))()
        end
    })

    -- ===== 传送Tab =====
    local TabTeleport = Window:Tab({ Title = "传送", Icon = "" })
    local SelectedLocation = nil
    
    local teleportSection = TabTeleport:Section({ Title = "地点传送", TextXAlignment = "Left" })
    
    teleportSection:Dropdown({
        Title = "选择地点",
        Options = (function()
            local list = {}
            for k in pairs(Locations) do
                table.insert(list, k)
            end
            return list
        end)(),
        Default = "",
        Callback = function(val)
            SelectedLocation = val
        end
    })
    
    teleportSection:Button({
        Title = "传送",
        Callback = function()
            if SelectedLocation then
                Character:PivotTo(Locations[SelectedLocation])
            end
        end
    })

    -- ===== 娱乐Tab =====
    local TabFun = Window:Tab({ Title = "娱乐", Icon = "" })
    local FunTarget = nil
    local FunTargetInput
    
    local funSection = TabFun:Section({ Title = "娱乐功能", TextXAlignment = "Left" })
    
    FunTargetInput = funSection:Input({
        Title = "输入名称 当前：无",
        Placeholder = "输入玩家名称",
        Callback = function(val)
            local found = FindPlayer(val)
            FunTarget = found
            if found then
                FunTargetInput:SetTitle("输入名称 当前：" .. found.Name)
            else
                FunTargetInput:SetTitle("输入名称 当前：无")
            end
        end
    })
    
    funSection:Input({
        Title = "输入消息",
        Placeholder = "XA-Hub No.1",
        Callback = function(val)
            Fluent.Options.SpamMessage.Value = val
        end
    })
    
    funSection:Toggle({
        Title = "消息轰炸",
        Default = false,
        Callback = function(val)
            Fluent.Options.SpamPlayer.Value = val
            if not FunTarget then
                WindUI:Notify({
                    Title = "错误",
                    Content = "请先输入玩家名称",
                    Duration = 2,
                })
                return
            end
            while Fluent.Options.SpamPlayer.Value do
                task.wait(0.2)
                Remotes.FireServer("sendMessage", FunTarget.UserId, Fluent.Options.SpamMessage.Value)
            end
        end
    })
    
    funSection:Toggle({
        Title = "电话骚扰",
        Default = false,
        Callback = function(val)
            Fluent.Options.SpamCall.Value = val
            if not FunTarget then
                WindUI:Notify({
                    Title = "错误",
                    Content = "请先输入玩家名称",
                    Duration = 2,
                })
                return
            end
            while Fluent.Options.SpamCall.Value do
                task.wait(0.2)
                Remotes.InvokeServer("attemptCall", FunTarget.UserId)
            end
        end
    })
    
    funSection:Toggle({
        Title = "消息轰炸全体",
        Default = false,
        Callback = function(val)
            Fluent.Options.SpamAll.Value = val
            while Fluent.Options.SpamAll.Value do
                task.wait(0.2)
                for _, player in pairs(Players:GetPlayers()) do
                    if not Fluent.Options.SpamAll.Value then break end
                    Remotes.FireServer("sendMessage", player.UserId, Fluent.Options.SpamMessage.Value)
                end
            end
        end
    })

    -- ===== 其他Tab =====
    local TabOther = Window:Tab({ Title = "其他", Icon = "" })
    
    local otherSection = TabOther:Section({ Title = "通用设置", TextXAlignment = "Left" })
    
    otherSection:Toggle({
        Title = "显示聊天框",
        Default = false,
        Callback = function(val)
            Fluent.Options.ShowChat.Value = val
            game:GetService("TextChatService").ChatWindowConfiguration.Enabled = val
        end
    })
    
    otherSection:Input({
        Title = "设置物品栏数量",
        Placeholder = "输入数量",
        Callback = function(val)
            Inventory.numSlots = tonumber(val)
        end
    })
    
    otherSection:Slider({
        Title = "移动速度",
        Min = 0,
        Max = 500,
        Default = 16,
        Callback = function(val)
            Fluent.Options.WalkSpeed.Value = val
            Fluent.Options.WalkSpeed.IsMoved = true
            if Humanoid then
                Humanoid.WalkSpeed = val
            end
        end
    })
    
    otherSection:Slider({
        Title = "跳跃高度",
        Min = 0,
        Max = 500,
        Default = 50,
        Callback = function(val)
            Fluent.Options.JumpPower.Value = val
            Fluent.Options.JumpPower.IsMoved = true
            if Humanoid then
                Humanoid.JumpPower = val
                Humanoid.UseJumpPower = true
            end
        end
    })
    
    otherSection:Button({
        Title = "飞行",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Xingtaiduan/Script/main/Content/FlyGuiV3"))()
        end
    })
    
    otherSection:Toggle({
        Title = "穿墙",
        Default = false,
        Callback = function(val)
            Fluent.Options.Noclip.Value = val
            if not val and Humanoid then
                Humanoid:ChangeState("Flying")
            end
            while Fluent.Options.Noclip.Value do
                task.wait()
                if Character then
                    for _, part in pairs(Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end
    })
    
    otherSection:Toggle({
        Title = "夜视",
        Default = false,
        Callback = function(val)
            Fluent.Options.Fullbright.Value = val
            if val then
                Lighting.Ambient = Color3.new(1, 1, 1)
            else
                Lighting.Ambient = Color3.new(0, 0, 0)
            end
        end
    })
    
    otherSection:Toggle({
        Title = "无限跳",
        Default = false,
        Callback = function(val)
            Fluent.Options.InfJump.Value = val
        end
    })

    -- ===== 核心循环 =====
    RunService.RenderStepped:Connect(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local char = player.Character
                if not char then continue end
                local hum = char:FindFirstChildOfClass("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hum or not hrp then continue end
                if char:FindFirstChild("ForceField") then continue end
                if table.find(Whitelist, player.UserId) then continue end

                if Fluent.Options.KillAura.Value then
                    local dist = (HumanoidRootPart.Position - hrp.Position).Magnitude
                    if dist < 35 and hum.Health > 5 then
                        Remotes.FireServer("meleeItemHit", "player", {
                            meleeType = "meleemegapunch",
                            hitPlayerId = player.UserId
                        })
                    end
                end

                if Fluent.Options.StompAura.Value then
                    if ClientReplicator.Get(player, "knocked") then
                        local dist = (HumanoidRootPart.Position - hrp.Position).Magnitude
                        if dist < 30 then
                            Remotes.FireServer("stomp", player)
                        end
                    end
                end

                if Fluent.Options.GrabAura.Value then
                    if ClientReplicator.Get(player, "knocked") then
                        local dist = (HumanoidRootPart.Position - hrp.Position).Magnitude
                        if dist < 35 then
                            Remotes.FireServer("grabPlayer", player)
                        end
                    end
                end
            end
        end

        if Fluent.Options.Godmode.Value then
            if ClientReplicator.Get(LocalPlayer, "knocked") then
                ClientReplicator.Set(LocalPlayer, "knocked", false)
            end
        end

        if Fluent.Options.WalkSpeed.IsMoved and Humanoid then
            Humanoid.WalkSpeed = Fluent.Options.WalkSpeed.Value
        end
        if Fluent.Options.JumpPower.IsMoved and Humanoid then
            Humanoid.JumpPower = Fluent.Options.JumpPower.Value
            Humanoid.UseJumpPower = true
        end

        if Fluent.Options.Fullbright.Value then
            Lighting.Ambient = Color3.new(1, 1, 1)
        end
    end)
    
    UserInputService.JumpRequest:Connect(function()
        if Fluent.Options.InfJump.Value and Humanoid then
            Humanoid:ChangeState("Jumping")
        end
    end)

    -- ===== UI设置Tab =====
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