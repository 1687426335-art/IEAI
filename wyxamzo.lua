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
            blur.Name = "UISX HUBBlur"
            blur.Parent = game:GetService("Lighting")
        end)
    else
        pcall(function()
            local existingBlur = game:GetService("Lighting"):FindFirstChild("UISX HUBBlur")
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

local username = game:GetService("Players").LocalPlayer.Name
local coloredUsername = ""
local gradientColors2 = {
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
        local colorIndex = (i - 1) % #gradientColors2 + 1
        coloredUsername = coloredUsername .. '<font color="' .. gradientColors2[colorIndex] .. '">' .. char .. '</font>'
    else
        coloredUsername = coloredUsername .. '<font color="' .. goldColor .. '">' .. char .. '</font>'
    end
end

local Confirmed = false
WindUI:Popup({
    Title = 'wdfex-圣奥里',
    IconThemed = true,
    Icon = "crown",
    Content = "欢迎尊重的用户 " .. coloredUsername .. " \n使用wdfex-圣奥里\n当前脚本支持服务器\n圣奥里",
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
        Title = 'wdfex-圣奥里',
        Icon = "crown",
        IconThemed = true,
        Author = "作者wdfex",
        Folder = "wdfexHub",
        Size = UDim2.fromOffset(300, 200),
        Transparent = true,
        Theme = "Dark",
        HideSearchBar = false,
        ScrollBarEnabled = true,
        Resizable = true,
        SideBarWidth = 250,
        Search = {
            Enabled = true,
            Placeholder = "搜索...",
            Callback = function(searchText)
                print("搜索内容:", searchText)
            end
        },
    })

    Window:EditOpenButton({
        Title = "wdfex-圣奥里",
        Icon = "crown",
        CornerRadius = UDim.new(0,16),
        StrokeThickness = 4,
        Color = ColorSequence.new(Color3.fromHex("FF6B6B")),
        Draggable = true,
    })
    
    Window:Tag({
        Title = "wdfex",
        Color = Color3.fromHex("#00008B") 
    })
    Window:Tag({
        Title = "圣奥里",
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

    -- ==================== 公告Tab ====================
    local NoticeTab = Window:Tab({Title = "公告", Icon = "info", Locked = false})
    local NoticeSection = NoticeTab:Section({Title = "作者消息", Icon = "info", Opened = true})
    NoticeSection:Paragraph({Title = "创作者: wdfex", ThumbnailSize = 190})
    NoticeSection:Paragraph({Title = "QQ: 1687426335", ThumbnailSize = 190})
    NoticeSection:Divider()
    NoticeSection:Paragraph({Title = "已为您开启反作弊与防挂机", ThumbnailSize = 190})
    NoticeSection:Paragraph({Title = "杀戮光环优先攻击最近目标", ThumbnailSize = 190})
    NoticeSection:Paragraph({Title = "如果距离内没有人则正常生效", ThumbnailSize = 190})
    NoticeSection:Divider()
    NoticeSection:Paragraph({Title = "如果出现bug请联系作者修复", ThumbnailSize = 190})

    -- ==================== 玩家修改Tab ====================
    local PlayerTab = Window:Tab({Title = "玩家修改", Icon = "user"})
    local PlayerSection = PlayerTab:Section({Title = "角色修改", Icon = "user", Opened = true})

    -- ===== 飞行功能 =====
    local FlyingEnabled = false
    local SpinningEnabled = false
    local FlightSpeed = 50
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
            WindUI:Notify({ Title = "飞行失败", Content = "无法获取角色", Duration = 2, Icon = "x" })
            return
        end
        FlyingEnabled = true
        SpinningEnabled = false
        if CurrentAO then CurrentAO:Destroy() end
        if CurrentLV then CurrentLV:Destroy() end
        if CurrentMoverAttachment then CurrentMoverAttachment:Destroy() end
        CurrentAO, CurrentLV, humanoid, CurrentMoverAttachment = setupBodyMovers(character)
        WindUI:Notify({ Title = "飞行开启", Content = "速度: " .. FlightSpeed, Duration = 2, Icon = "check" })
        
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
        WindUI:Notify({ Title = "飞行关闭", Content = "飞行功能已禁用", Duration = 2, Icon = "x" })
    end

    PlayerSection:Toggle({
        Title = "飞行模式",
        Default = false,
        Callback = function(v)
            if v then startFlying() else stopFlying() end
        end
    })

    PlayerSection:Slider({
        Title = "飞行速度",
        Value = { Min = 1, Max = 200, Default = 50 },
        Callback = function(value)
            FlightSpeed = value
            if FlyingEnabled then
                WindUI:Notify({ Title = "速度已更新", Content = "飞行速度: " .. value, Duration = 1, Icon = "zap" })
            end
        end
    })

    PlayerSection:Divider()

    -- ===== 飞天快捷开关 =====
    local flyQuickToggle = false
    local flyQuickButton = nil
    local flyQuickScreenGui = nil
    local flyQuickStatusLabel = nil
    local flyQuickConn = nil

    local function DestroyFlyQuickToggle()
        if flyQuickScreenGui then
            flyQuickScreenGui:Destroy()
            flyQuickScreenGui = nil
            flyQuickButton = nil
            flyQuickStatusLabel = nil
        end
        if flyQuickConn then
            flyQuickConn:Disconnect()
            flyQuickConn = nil
        end
    end

    local function CreateFlyQuickToggle()
        if flyQuickButton then return end
        
        flyQuickScreenGui = Instance.new("ScreenGui")
        flyQuickScreenGui.Name = "FlyQuickToggle"
        flyQuickScreenGui.ResetOnSpawn = false
        flyQuickScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        flyQuickScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        
        local button = Instance.new("ImageButton")
        button.Size = UDim2.new(0, 60, 0, 60)
        button.Position = UDim2.new(0.5, -30, 0.15, 0)
        button.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        button.BackgroundTransparency = 0.15
        button.BorderSizePixel = 2
        button.BorderColor3 = Color3.fromRGB(100, 200, 255)
        button.Image = "rbxassetid://7734068321"
        button.ImageColor3 = Color3.fromRGB(100, 200, 255)
        button.ScaleType = Enum.ScaleType.Fit
        button.Parent = flyQuickScreenGui
        flyQuickButton = button
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = button
        
        flyQuickStatusLabel = Instance.new("TextLabel")
        flyQuickStatusLabel.Size = UDim2.new(1, 0, 0, 20)
        flyQuickStatusLabel.Position = UDim2.new(0, 0, 1, 0)
        flyQuickStatusLabel.BackgroundTransparency = 1
        flyQuickStatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        flyQuickStatusLabel.TextSize = 12
        flyQuickStatusLabel.Font = Enum.Font.GothamBold
        flyQuickStatusLabel.TextStrokeTransparency = 0.3
        flyQuickStatusLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        flyQuickStatusLabel.Text = "飞行: 关"
        flyQuickStatusLabel.Parent = button
        
        local function updateFlyStatus()
            if flyQuickStatusLabel then
                flyQuickStatusLabel.Text = FlyingEnabled and "飞行: 开" or "飞行: 关"
                if flyQuickButton then
                    flyQuickButton.BorderColor3 = FlyingEnabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 200, 255)
                    flyQuickButton.ImageColor3 = FlyingEnabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 200, 255)
                end
            end
        end
        
        button.MouseButton1Click:Connect(function()
            if FlyingEnabled then
                stopFlying()
            else
                startFlying()
            end
            updateFlyStatus()
        end)
        
        local dragging = false
        local dragStart = nil
        local startPos = nil
        
        button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = button.Position
            end
        end)
        
        button.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                local newPos = UDim2.new(
                    startPos.X.Scale + delta.X / game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui").AbsoluteSize.X,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale + delta.Y / game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui").AbsoluteSize.Y,
                    startPos.Y.Offset + delta.Y
                )
                button.Position = newPos
            end
        end)
        
        button.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        updateFlyStatus()
        
        flyQuickConn = game:GetService("RunService").Heartbeat:Connect(function()
            if flyQuickToggle and flyQuickStatusLabel then
                updateFlyStatus()
            end
        end)
    end

    PlayerSection:Toggle({
        Title = "飞天快捷开关",
        Desc = "开启后在屏幕显示可拖动的飞天开关",
        Default = false,
        Callback = function(value)
            flyQuickToggle = value
            if value then
                CreateFlyQuickToggle()
            else
                DestroyFlyQuickToggle()
            end
        end
    })

    PlayerSection:Divider()

    -- ===== Noclip =====
    local NoclipEnabled = false
    PlayerSection:Toggle({
        Title = "人物穿墙",
        Default = false,
        Callback = function(value)
            NoclipEnabled = value
            if value then
                local char = game:GetService("Players").LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
                game:GetService("RunService").Heartbeat:Connect(function()
                    if NoclipEnabled then
                        local char2 = game:GetService("Players").LocalPlayer.Character
                        if char2 then
                            for _, part in ipairs(char2:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.CanCollide = false
                                end
                            end
                        end
                    end
                end)
            else
                local char = game:GetService("Players").LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                end
            end
        end
    })

    PlayerSection:Divider()

    -- ===== 移速修改 =====
    local SpeedBypassOn = false
    local SpeedBypassValue = 20
    local speedConn = nil

    PlayerSection:Toggle({
        Title = "修改移速",
        Desc = "速度推荐80-90",
        Default = false,
        Callback = function(value)
            SpeedBypassOn = value
            if value then
                if speedConn then speedConn:Disconnect() end
                speedConn = game:GetService("RunService").Heartbeat:Connect(function(dt)
                    if not SpeedBypassOn then return end
                    local LocalPlayer = game:GetService("Players").LocalPlayer
                    local char = LocalPlayer.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if hum and root and hum.MoveDirection.Magnitude > 0 then
                        root.CFrame = root.CFrame + hum.MoveDirection * SpeedBypassValue * dt
                    end
                end)
            else
                if speedConn then
                    speedConn:Disconnect()
                    speedConn = nil
                end
            end
        end
    })

    PlayerSection:Slider({
        Title = "移速数值",
        Value = { Min = 5, Max = 150, Default = 20 },
        Callback = function(value)
            SpeedBypassValue = value
        end
    })

    PlayerSection:Divider()

    -- ===== 无限体力 =====
    local StaminaOn = false
    PlayerSection:Toggle({
        Title = "无限体力",
        Default = false,
        Callback = function(value)
            StaminaOn = value
        end
    })

    -- ===== 无限体力后台逻辑 =====
    task.spawn(function()
        while true do
            if StaminaOn then
                pcall(function()
                    local Remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remote")
                    if Remote then
                        local PlayerEvent = Remote:FindFirstChild("PlayerEvent")
                        if PlayerEvent then
                            PlayerEvent:FireServer("setStaminaOrFood", "stamina", 100)
                        end
                    end
                end)
            end
            task.wait(0.3)
        end
    end)

    PlayerSection:Divider()

    -- ===== 防甩飞 =====
    _G.CatAntiFling_Enabled = false
    _G.CatAntiFling_Running = false

    local function AntiFlingLoop()
        if _G.CatAntiFling_Running then return end
        _G.CatAntiFling_Running = true
        task.spawn(function()
            while true do
                if _G.CatAntiFling_Enabled then
                    pcall(function()
                        local LocalPlayer = game:GetService("Players").LocalPlayer
                        local char = LocalPlayer.Character
                        if not char then return end
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if not root then return end
                        local vel = root.Velocity
                        if vel.Magnitude > 500 or math.abs(vel.Y) > 300 then
                            root.Velocity = Vector3.new(0, 0, 0)
                            root.RotVelocity = Vector3.new(0, 0, 0)
                        end
                        for _, obj in ipairs(root:GetChildren()) do
                            if (obj:IsA("BodyVelocity") or obj:IsA("BodyAngularVelocity")) and obj.Name ~= "CatAntiFling" and obj.Name ~= "CatAntiFlingAngular" then
                                obj:Destroy()
                            end
                        end
                    end)
                end
                task.wait()
            end
        end)
    end

    AntiFlingLoop()

    PlayerSection:Toggle({
        Title = "防甩飞",
        Desc = "防止被其他脚本甩飞",
        Default = false,
        Callback = function(value)
            _G.CatAntiFling_Enabled = value
            if value then
                WindUI:Notify({ Title = "防甩飞", Content = "已开启，抵御甩飞攻击", Duration = 2, Icon = "shield" })
            else
                WindUI:Notify({ Title = "防甩飞", Content = "已关闭", Duration = 2, Icon = "x" })
            end
        end
    })

    PlayerSection:Divider()

    -- ===== 无限跳 =====
    local jumpConn = nil
    PlayerSection:Toggle({
        Title = "无限跳",
        Default = false,
        Callback = function(Value)
            if Value then
                jumpConn = game:GetService("UserInputService").JumpRequest:Connect(function()
                    local LocalPlayer = game:GetService("Players").LocalPlayer
                    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            else
                if jumpConn then
                    jumpConn:Disconnect()
                    jumpConn = nil
                end
            end
        end
    })

    -- ===== 扩大视野 =====
    local fovConnection = nil
    PlayerSection:Toggle({
        Title = "扩大视野",
        Default = false,
        Callback = function(v)
            if v then
                fovConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    workspace.CurrentCamera.FieldOfView = 120
                end)
            else
                if fovConnection then
                    fovConnection:Disconnect()
                    fovConnection = nil
                end
            end
        end
    })

    -- ==================== 枪械功能Tab ====================
    local GunTab = Window:Tab({Title = "枪械功能", Icon = "target"})
    local GunSection = GunTab:Section({Title = "枪械修改", Icon = "target", Opened = true})

    GunSection:Button({
        Title = "超快射速",
        Callback = function()
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
            local LocalPlayer = game:GetService("Players").LocalPlayer
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.Died:Connect(ModifyWeaponStats)
                end
            end
            WindUI:Notify({ Title = "武器强化", Content = "无限射速已生效", Duration = 2, Icon = "check" })
        end
    })

    GunSection:Divider()

    -- ===== 无限子弹 =====
    local InfAmmoEnabled = false
    GunSection:Toggle({
        Title = "无限子弹",
        Default = false,
        Callback = function(value)
            InfAmmoEnabled = value
        end
    })

    task.spawn(function()
        while true do
            if InfAmmoEnabled then
                pcall(function()
                    local LocalPlayer = game:GetService("Players").LocalPlayer
                    local characterFolder = workspace:FindFirstChild("Characters") and workspace.Characters:FindFirstChild(LocalPlayer.Name)
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
                end)
            end
            task.wait(0.5)
        end
    })

    GunSection:Divider()

    -- ===== 碰撞箱扩展 =====
    local HitboxEnabled = false
    local HitboxSize = 10
    local affectedHeads = {}

    local function ApplyHitbox()
        if not HitboxEnabled then return end
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local players = game:GetService("Players"):GetPlayers()
        local newAffected = {}
        for _, p in ipairs(players) do
            if p ~= LocalPlayer and p.Character then
                local char = p.Character
                local head = char:FindFirstChild("Head")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 and head then
                    head.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                    head.Transparency = 1
                    head.Color = Color3.fromRGB(255, 215, 0)
                    head.Material = Enum.Material.Neon
                    head.CanCollide = false
                    newAffected[head] = true
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

    GunSection:Toggle({
        Title = "启用碰撞箱",
        Desc = "推荐20-25",
        Default = false,
        Callback = function(value)
            HitboxEnabled = value
            if value then ApplyHitbox() end
        end
    })

    GunSection:Slider({
        Title = "头部大小",
        Value = { Min = 5, Max = 400, Default = 10 },
        Callback = function(value)
            HitboxSize = value
            if HitboxEnabled then ApplyHitbox() end
        end
    })

    -- ==================== 杀戮光环Tab ====================
    local KATab = Window:Tab({Title = "杀戮光环", Icon = "skull"})
    local KASection = KATab:Section({Title = "杀戮光环", Icon = "skull", Opened = true})
    KASection:Paragraph({Title = "注意：需装备枪械武器才有伤害", ThumbnailSize = 190})

    local KA_MAX_DISTANCE = 300
    local KA_WALL_CHECK = true
    local kaEnabled = false
    local kaDamageMultiplier = 1
    local KANearestOnly = false
    local KA_NEAREST_DISTANCE = 25
    local kaStatusLabel = nil

    local function kaIsVisible(targetHead)
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local char = LocalPlayer.Character
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
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local char = LocalPlayer.Character
        if not char then return nil end
        local myHead = char:FindFirstChild("Head")
        if not myHead then return nil end
        local bestPlayer, bestDist = nil, KA_MAX_DISTANCE
        
        if KANearestOnly then
            local nearestInRange = nil
            local nearestDistInRange = 9999
            local anyEnemy = nil
            local anyDist = 9999
            
            for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local head = p.Character:FindFirstChild("Head")
                        if head then
                            local dist = (head.Position - myHead.Position).Magnitude
                            if dist < anyDist and (not KA_WALL_CHECK or kaIsVisible(head)) then
                                anyDist = dist
                                anyEnemy = p
                            end
                            if dist <= KA_NEAREST_DISTANCE and dist < nearestDistInRange and (not KA_WALL_CHECK or kaIsVisible(head)) then
                                nearestDistInRange = dist
                                nearestInRange = p
                            end
                        end
                    end
                end
            end
            
            if nearestInRange then
                return nearestInRange
            else
                return anyEnemy
            end
        end
        
        for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
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

    local function kaSetStatus(text)
        if kaStatusLabel then
            pcall(function() kaStatusLabel:SetText(text) end)
        end
    end

    KASection:Toggle({
        Title = "启用杀戮光环",
        Default = false,
        Callback = function(value)
            kaEnabled = value
            if value then
                WindUI:Notify({ Title = "杀戮光环", Content = "已开启，正在搜索敌人", Duration = 2, Icon = "skull" })
                kaSetStatus("状态：已开启，正在搜索敌人")
            else
                kaSetStatus("状态：已关闭")
            end
        end
    })

    KASection:Slider({
        Title = "攻击距离",
        Value = { Min = 50, Max = 1000, Default = 300 },
        Callback = function(value)
            KA_MAX_DISTANCE = value
        end
    })

    KASection:Toggle({
        Title = "墙体检测",
        Default = true,
        Callback = function(value)
            KA_WALL_CHECK = value
        end
    })

    KASection:Slider({
        Title = "伤害倍率",
        Value = { Min = 1, Max = 100, Default = 1 },
        Callback = function(value)
            kaDamageMultiplier = value
        end
    })

    KASection:Divider()

    KASection:Toggle({
        Title = "优先攻击最近目标",
        Desc = "优先攻击25米内的敌人",
        Default = false,
        Callback = function(value)
            KANearestOnly = value
            if value then
                WindUI:Notify({ Title = "杀戮光环", Content = "已切换至25米内优先攻击", Duration = 2, Icon = "zap" })
            end
        end
    })

    KASection:Slider({
        Title = "优先攻击距离",
        Value = { Min = 5, Max = 100, Default = 25 },
        Callback = function(value)
            KA_NEAREST_DISTANCE = value
            WindUI:Notify({ Title = "杀戮光环", Content = "优先攻击距离已设为" .. value .. "米", Duration = 2, Icon = "zap" })
        end
    })

    kaStatusLabel = KASection:Paragraph({ Title = "状态：已关闭", ThumbnailSize = 190 })

    -- ===== 杀戮光环主循环 =====
    game:GetService("RunService").Heartbeat:Connect(function()
        if kaEnabled then
            local target = kaGetNearestEnemy()
            local targetHead = target and target.Character and target.Character:FindFirstChild("Head")
            if targetHead then
                local LocalPlayer = game:GetService("Players").LocalPlayer
                local myHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
                if myHead then
                    local origin = myHead.Position
                    local hitPos = targetHead.Position
                    local direction = (hitPos - origin).Unit
                    local damage = 100 * kaDamageMultiplier
                    pcall(function()
                        local ReplicatedStorage = game:GetService("ReplicatedStorage")
                        local Remote = ReplicatedStorage:FindFirstChild("Remote")
                        if Remote then
                            local PlayerEvent = Remote:FindFirstChild("PlayerEvent")
                            if PlayerEvent then
                                PlayerEvent:FireServer("damage", {
                                    bodyParts = { { "Head", damage } },
                                    shotCode = { origin, direction },
                                    target = target,
                                    pos = hitPos
                                })
                            end
                        end
                    end)
                    pcall(function()
                        local ReplicatedStorage = game:GetService("ReplicatedStorage")
                        local handleShots = ReplicatedStorage:FindFirstChild("Events")
                        if handleShots then
                            handleShots = handleShots:FindFirstChild("HandleShots")
                            if handleShots then
                                handleShots:FireServer("2", "Shoot")
                            end
                        end
                    end)
                    kaSetStatus("状态：已锁定 " .. target.Name)
                end
            else
                kaSetStatus("状态：范围内未找到敌人")
            end
        end
    end)

    -- ==================== 传送点Tab ====================
    local TeleportTab = Window:Tab({Title = "传送点", Icon = "map-pin"})
    local TeleportSection = TeleportTab:Section({Title = "传送控制", Icon = "map-pin", Opened = true})

    local TeleportEnabled = false
    TeleportSection:Toggle({
        Title = "启用传送",
        Default = false,
        Callback = function(value)
            TeleportEnabled = value
        end
    })

    local function TeleportTo(pos)
        if not TeleportEnabled then return end
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        pcall(function()
            root.CFrame = CFrame.new(pos)
        end)
    end

    local teleportData = {
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
        {n = "圣奥里海滩桥下", p = Vector3.new(3964.504395, -25.068211, -854.057251)},
        {n = "大景超市", p = Vector3.new(3936.582764, 3.038293, 1136.326416)},
        {n = "转镜中心", p = Vector3.new(4152.919922, 2.631675, 941.446045)},
        {n = "道路服务", p = Vector3.new(4271.332520, 2.628108, 1200.086914)},
        {n = "大景餐饮店", p = Vector3.new(4476.997559, 3.037825, 906.802979)},
        {n = "送货中心", p = Vector3.new(4399.419434, 3.038999, 1609.455933)},
        {n = "大景卖车店", p = Vector3.new(3434.377441, 42.931786, 2687.997070)},
        {n = "莱斯维尔餐饮店", p = Vector3.new(753.757812, 3.039824, 998.132996)},
        {n = "莱斯维尔服装店", p = Vector3.new(820.745117, 2.766988, 1047.445679)},
        {n = "莱斯维尔自由广场", p = Vector3.new(926.523376, 2.630995, 865.764771)},
        {n = "莱斯维尔码头", p = Vector3.new(947.840210, -22.529087, 1216.085693)},
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
        {n = "瀑布洞穴", p = Vector3.new(3040.956055, 109.688538, 2711.069336)},
        {n = "大桥", p = Vector3.new(949.014954, 25.215754, 2897.654785)},
        {n = "地图右下", p = Vector3.new(-1651.385010, 2.414712, 3225.278320)},
        {n = "下部加油站", p = Vector3.new(2270.378174, 2.630927, 154.161484)},
        {n = "游戏厅", p = Vector3.new(2934.893799, 2.956458, 1693.660034)},
        {n = "高尔夫", p = Vector3.new(2280.767090, 3.037836, 1982.357300)},
        {n = "修船厂", p = Vector3.new(4096.405273, -30.401447, 2865.045166)},
    }

    local teleNames = {}
    for _, data in ipairs(teleportData) do
        table.insert(teleNames, data.n)
    end

    local selectedTeleport = teleNames[1]

    TeleportSection:Dropdown({
        Title = "选定传送地点",
        Values = teleNames,
        Value = teleNames[1],
        Callback = function(value)
            selectedTeleport = value
        end
    })

    TeleportSection:Button({
        Title = "传送到选定地点",
        Callback = function()
            if not TeleportEnabled then
                WindUI:Notify({ Title = "传送", Content = "请先开启传送开关", Duration = 2, Icon = "x" })
                return
            end
            for _, data in ipairs(teleportData) do
                if data.n == selectedTeleport then
                    TeleportTo(data.p)
                    WindUI:Notify({ Title = "传送", Content = "正在传送至: " .. data.n, Duration = 2, Icon = "map-pin" })
                    return
                end
            end
            WindUI:Notify({ Title = "传送", Content = "未找到该地点", Duration = 2, Icon = "x" })
        end
    })

    -- ==================== 透视Tab ====================
    local ESPTab = Window:Tab({Title = "透视", Icon = "eye"})
    local ESPSection = ESPTab:Section({Title = "透视设置", Icon = "eye", Opened = true})

    local ESP_ENABLED = false
    local ESP_SHOW_NAME = true
    local ESP_SHOW_TEAM = true
    local ESP_SHOW_HEALTH = true
    local ESP_SHOW_DIST = true
    local ESP_LIST = {}
    local ESP_REFRESH_COUNT = 0

    local function GetTeam(p)
        if p.Team then return p.Team.Name end
        return "平民"
    end

    local function GetTeamColor(p)
        if p.Team then return p.Team.TeamColor.Color end
        return Color3.fromRGB(200, 200, 200)
    end

    local function GetHealth(p)
        local c = p.Character
        if not c then return 0 end
        local h = c:FindFirstChildOfClass("Humanoid")
        if not h then return 0 end
        return math.floor(h.Health)
    end

    local function GetDist(p)
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local mc = LocalPlayer.Character
        if not mc then return 0 end
        local mr = mc:FindFirstChild("HumanoidRootPart")
        if not mr then return 0 end
        local tc = p.Character
        if not tc then return 0 end
        local tr = tc:FindFirstChild("HumanoidRootPart")
        if not tr then return 0 end
        return math.floor((mr.Position - tr.Position).Magnitude)
    end

    local function RemoveESP(id)
        local d = ESP_LIST[id]
        if d then
            if d.Billboard then d.Billboard:Destroy() end
            ESP_LIST[id] = nil
        end
    end

    local function BuildESP(p)
        local LocalPlayer = game:GetService("Players").LocalPlayer
        if not p.Character or p == LocalPlayer then return end
        local head = p.Character:FindFirstChild("Head")
        if not head then return end
        if ESP_LIST[p.UserId] then
            if ESP_LIST[p.UserId].Billboard then
                ESP_LIST[p.UserId].Billboard.Enabled = true
            end
            return
        end

        local bb = Instance.new("BillboardGui")
        bb.Size = UDim2.new(0, 200, 0, 100)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = 500
        bb.Parent = head

        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 1, 0)
        f.BackgroundTransparency = 1
        f.Parent = bb

        ESP_LIST[p.UserId] = {Billboard = bb, Frame = f}
    end

    local function RefreshESP()
        local LocalPlayer = game:GetService("Players").LocalPlayer
        if not ESP_ENABLED then
            for _, d in pairs(ESP_LIST) do
                if d.Billboard then d.Billboard.Enabled = false end
            end
            return
        end

        ESP_REFRESH_COUNT = ESP_REFRESH_COUNT + 1

        for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
            if p == LocalPlayer then continue end
            if not p.Character then
                RemoveESP(p.UserId)
                continue
            end
            if ESP_REFRESH_COUNT % 30 == 0 and ESP_LIST[p.UserId] then
                RemoveESP(p.UserId)
            end
            if not ESP_LIST[p.UserId] then
                BuildESP(p)
            end
            local d = ESP_LIST[p.UserId]
            if not d then continue end
            if not d.Billboard or not d.Billboard.Parent then
                ESP_LIST[p.UserId] = nil
                BuildESP(p)
                d = ESP_LIST[p.UserId]
                if not d then continue end
            end
            d.Billboard.Enabled = true

            local f = d.Frame
            for _, c in ipairs(f:GetChildren()) do c:Destroy() end

            local y = 0
            local lines = 0
            local team = GetTeam(p)
            local color = GetTeamColor(p)
            local hp = GetHealth(p)
            local dist = GetDist(p)

            if ESP_SHOW_NAME then
                local l = Instance.new("TextLabel")
                l.Size = UDim2.new(1, 0, 0, 20)
                l.Position = UDim2.new(0, 0, 0, y)
                l.BackgroundTransparency = 1
                l.Text = p.Name
                l.TextColor3 = color
                l.TextSize = 15
                l.Font = Enum.Font.GothamBold
                l.TextStrokeTransparency = 0.3
                l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                l.TextXAlignment = Enum.TextXAlignment.Center
                l.Parent = f
                y = y + 22
                lines = lines + 1
            end

            if ESP_SHOW_TEAM then
                local l = Instance.new("TextLabel")
                l.Size = UDim2.new(1, 0, 0, 18)
                l.Position = UDim2.new(0, 0, 0, y)
                l.BackgroundTransparency = 1
                l.Text = "[" .. team .. "]"
                l.TextColor3 = color
                l.TextSize = 13
                l.Font = Enum.Font.GothamBold
                l.TextStrokeTransparency = 0.3
                l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                l.TextXAlignment = Enum.TextXAlignment.Center
                l.Parent = f
                y = y + 20
                lines = lines + 1
            end

            if ESP_SHOW_HEALTH then
                local l = Instance.new("TextLabel")
                l.Size = UDim2.new(1, 0, 0, 18)
                l.Position = UDim2.new(0, 0, 0, y)
                l.BackgroundTransparency = 1
                local c = hp > 70 and Color3.fromRGB(0, 255, 100) or hp > 40 and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(255, 50, 50)
                l.Text = hp .. "HP"
                l.TextColor3 = c
                l.TextSize = 13
                l.Font = Enum.Font.GothamBold
                l.TextStrokeTransparency = 0.3
                l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                l.TextXAlignment = Enum.TextXAlignment.Center
                l.Parent = f
                y = y + 20
                lines = lines + 1
            end

            if ESP_SHOW_DIST then
                local l = Instance.new("TextLabel")
                l.Size = UDim2.new(1, 0, 0, 18)
                l.Position = UDim2.new(0, 0, 0, y)
                l.BackgroundTransparency = 1
                l.Text = dist .. "m"
                l.TextColor3 = Color3.fromRGB(200, 200, 200)
                l.TextSize = 13
                l.Font = Enum.Font.Gotham
                l.TextStrokeTransparency = 0.3
                l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                l.TextXAlignment = Enum.TextXAlignment.Center
                l.Parent = f
                y = y + 20
                lines = lines + 1
            end

            d.Billboard.Size = UDim2.new(0, 200, 0, lines * 20 + 10)
        end
    end

    ESPSection:Toggle({
        Title = "透视总开关",
        Default = false,
        Callback = function(v)
            ESP_ENABLED = v
            if v then RefreshESP() end
        end
    })

    ESPSection:Divider()

    ESPSection:Toggle({
        Title = "显示名字",
        Default = true,
        Callback = function(v)
            ESP_SHOW_NAME = v
            if ESP_ENABLED then RefreshESP() end
        end
    })

    ESPSection:Toggle({
        Title = "显示队伍",
        Default = true,
        Callback = function(v)
            ESP_SHOW_TEAM = v
            if ESP_ENABLED then RefreshESP() end
        end
    })

    ESPSection:Toggle({
        Title = "显示血量",
        Default = true,
        Callback = function(v)
            ESP_SHOW_HEALTH = v
            if ESP_ENABLED then RefreshESP() end
        end
    })

    ESPSection:Toggle({
        Title = "显示距离",
        Default = true,
        Callback = function(v)
            ESP_SHOW_DIST = v
            if ESP_ENABLED then RefreshESP() end
        end
    })

    -- 透视实时刷新循环
    task.spawn(function()
        while true do
            task.wait(0.15)
            if ESP_ENABLED then
                RefreshESP()
            end
        end
    end)

    -- 玩家加入/离开处理
    game:GetService("Players").PlayerAdded:Connect(function(p)
        p.CharacterAdded:Connect(function()
            task.wait(0.3)
            if ESP_ENABLED then
                RefreshESP()
            end
        end)
    end)

    game:GetService("Players").PlayerRemoving:Connect(function(p)
        RemoveESP(p.UserId)
    end)

    -- ==================== 开发者功能Tab ====================
    local DevTab = Window:Tab({Title = "开发者功能", Icon = "code"})
    local DevSection = DevTab:Section({Title = "坐标工具", Icon = "code", Opened = true})

    local coordGui = nil
    local coordTextBox = nil
    local coordFrame = nil

    DevSection:Button({
        Title = "开启坐标显示",
        Callback = function()
            local LocalPlayer = game:GetService("Players").LocalPlayer
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local root = char:WaitForChild("HumanoidRootPart")
            
            if coordGui then coordGui:Destroy() end
            
            coordGui = Instance.new("ScreenGui")
            coordGui.Name = "CoordinateCopyTool"
            coordGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
            
            coordFrame = Instance.new("Frame")
            coordFrame.Size = UDim2.new(0, 250, 0, 100)
            coordFrame.Position = UDim2.new(0.5, -125, 0.5, -50)
            coordFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            coordFrame.Active = true
            coordFrame.Parent = coordGui
            
            coordTextBox = Instance.new("TextBox")
            coordTextBox.Size = UDim2.new(0.9, 0, 0, 30)
            coordTextBox.Position = UDim2.new(0.05, 0, 0.15, 0)
            coordTextBox.Text = "加载中..."
            coordTextBox.ClearTextOnFocus = false
            coordTextBox.TextEditable = false
            coordTextBox.Parent = coordFrame
            
            local copyBtn = Instance.new("TextButton")
            copyBtn.Size = UDim2.new(0.9, 0, 0, 35)
            copyBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
            copyBtn.Text = "点击准备复制 (Ctrl+C)"
            copyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            copyBtn.TextColor3 = Color3.new(1, 1, 1)
            copyBtn.Parent = coordFrame
            
            local dragging = false
            local dragStart, startPos
            
            coordFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    dragStart = input.Position
                    startPos = coordFrame.Position
                end
            end)
            
            coordFrame.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local delta = input.Position - dragStart
                    coordFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
            
            coordFrame.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            game:GetService("RunService").RenderStepped:Connect(function()
                local pos = root.Position
                local formattedPos = string.format("%.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z)
                if coordTextBox and not coordTextBox:IsFocused() then
                    coordTextBox.Text = formattedPos
                end
            end)
            
            copyBtn.MouseButton1Click:Connect(function()
                coordTextBox:CaptureFocus()
                coordTextBox.SelectionStart = 1
                coordTextBox.CursorPosition = #coordTextBox.Text + 1
                copyBtn.Text = "现在按下 Ctrl + C 复制！"
                task.wait(2)
                copyBtn.Text = "点击准备复制 (Ctrl+C)"
            end)
        end
    })

    DevSection:Button({
        Title = "关闭坐标显示",
        Callback = function()
            if coordGui then
                coordGui:Destroy()
                coordGui = nil
                coordTextBox = nil
                coordFrame = nil
            end
        end
    })

    -- ==================== 设置Tab ====================
    local SettingsTab = Window:Tab({Title = "UI设置", Icon = "palette"})
    SettingsTab:Paragraph({ Title = "UI设置", Desc = "WindUI原版设置", Image = "settings", ImageSize = 20, Color = "White" })

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
        Value = { Min = 1, Max = 10, Default = 5 },
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
        Value = { Min = 0.5, Max = 1.5, Default = 1 },
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
        Value = { Min = 0, Max = 1, Default = 0.2 },
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
        Value = { Min = 500, Max = 800, Default = 600 },
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
        Value = { Min = 300, Max = 600, Default = 400 },
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
        Value = { Min = 1, Max = 5, Default = 1.5 },
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
        Value = { Min = 0, Max = 20, Default = 16 },
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
            setclipboard("wdfex-圣奥里 设置: " .. game:GetService("HttpService"):JSONEncode(settings))
            playSound()
        end
    })

    -- ===== 关键修复：打开窗口 =====
    Window:Open()

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