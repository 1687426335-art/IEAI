local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Potato5466794/Wind/refs/heads/main/Wind.luau"))()
local Window = WindUI:CreateWindow({
    Title = "<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#333333'>I</font> <font color='#666666'>S</font><font color='#444444'>C</font><font color='#222222'>R</font><font color='#111111'>I</font><font color='#000000'>P</font><font color='#000000'>T</font>",
    Author = "by小西制作",
    AuthorImage = 90840643379863,
    Folder = "CloudHub",
    Size = UDim2.fromOffset(200, 395),
    Transparent = true,
    Theme = "Dark",
    UserEnabled = true,
    SideBarWidth = 135,
    HasOutline = true,
    Transparent = true,
    Background = "video:https://raw.githubusercontent.com/xiaoxi9008/chesksks/refs/heads/main/Video_1773632365272_24.mp4",
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
})
    
Window:Tag({
        Title = "付费版",
        Radius = 10,
        Color = Color3.fromHex("#ffffff"),
    })

    Window:Tag({
        Title = "自然灾害",
        Radius = 10,
        Color = Color3.fromHex("#ffffff"),
    })

-- 通过主题设置按钮边框
WindUI.Themes.Dark.Button = Color3.fromRGB(255, 255, 255)
WindUI.Themes.Dark.ButtonBorder = Color3.fromRGB(255, 255, 255)

-- 主题切换按钮
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

-- 修改主题颜色
WindUI.Themes.Dark.Toggle = Color3.fromHex("FF69B4")
WindUI.Themes.Dark.Checkbox = Color3.fromHex("FFB6C1")
WindUI.Themes.Dark.Button = Color3.fromHex("FF1493")
WindUI.Themes.Dark.Slider = Color3.fromHex("FF69B4")

-- 彩虹边框颜色方案
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
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),    -- 纯白
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(220, 220, 220)), -- 浅灰
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 180, 180)),  -- 中灰
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(120, 120, 120)), -- 深灰
        ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 60, 60))        -- 暗灰
    }),
    Draggable = true,
})

-- 创建彩虹边框函数
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

-- 边框动画函数
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

-- 初始化边框动画
local borderAnimation
local borderEnabled = true
local currentColor = "樱花粉2"
local animationSpeed = 5

local rainbowStroke = createRainbowBorder(Window, currentColor, animationSpeed)
if rainbowStroke then
    borderAnimation = startBorderAnimation(Window, animationSpeed)
end

-- ============ 修正后的标签页结构 ============

-- 创建主标签页
local mainTab = Window:Tab({ Title = "功能", Icon = "layout-grid" })

-- 在标签页内创建分区
local naturalSection = mainTab:Section({ Title = "自然灾害", Opened = true })
local utilitySection = mainTab:Section({ Title = "实用功能", Opened = true })
local characterSection = mainTab:Section({ Title = "角色相关", Opened = true })

-- ============ 自然灾害分区 ============

naturalSection:Keybind({
    Flag = "KeybindTest",
    Title = "快捷键",
    Desc = "打开UI的快捷键",
    Value = "G",
    Callback = function(v) 
        Window:SetToggleKey(Enum.KeyCode[v]) 
    end
})

naturalSection:Button({
    Title = "指南针（可以用下面的地方显示不了地图）",
    Desc = "要使用的话就必须买指南针",
    Locked = false,
    Callback = function()
        local p = game.Players.LocalPlayer
        local r, c, h = game.ReplicatedStorage.Remotes.Compass, p.Backpack:WaitForChild("Compass"), p.Character:WaitForChild("Humanoid")
        h:EquipTool(c)
        task.wait()
        r:FireServer("Vote Map", 3)
        r:FireServer("Vote Map", 4)
        task.wait()
        h:UnequipTools()
        
        WindUI:Notify({
            Title = "通知",
            Content = "加载成功",
            Duration = 1,
            Icon = "layout-grid",
        })
    end
})

naturalSection:Button({
    Title = "黑洞",
    Desc = "点击加载",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Super-ring-Parts-V6-28581"))()
        
        WindUI:Notify({
            Title = "通知",
            Content = "加载成功",
            Duration = 3,
            Icon = "layout-grid",
        })
    end
})

naturalSection:Button({
    Title = "XIAOXI黑洞",
    Desc = "要开无敌",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/XIAOXI黑洞.lua"))()
        
        WindUI:Notify({
            Title = "通知",
            Content = "加载成功",
            Duration = 1,
            Icon = "layout-grid",
        })
    end
})

-- ============ 实用功能分区 ============

utilitySection:Button({
    Title = "物理磁铁",
    Desc = "可以把下面的东西吸上来可以踩",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/cytj777i/6669178/main/%E5%8D%95%E4%B8%80%E7%89%A9%E4%BD%93%E9%A3%9E%E8%A1%8C%E8%BD%BD%E8%87%AA%E5%B7%B1%E6%9C%80%E7%BB%88%E4%BC%98%E5%8C%96%E7%89%88"))()
        
        WindUI:Notify({
            Title = "通知",
            Content = "加载成功",
            Duration = 1,
            Icon = "layout-grid",
        })
    end
})

utilitySection:Button({
    Title = "无敌",
    Desc = "锁定血量（掉海里会死）",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/5twh2hsf9j-byte/BowenPrime67/refs/heads/main/Python"))()
        
        WindUI:Notify({
            Title = "通知",
            Content = "加载成功",
            Duration = 1,
            Icon = "layout-grid",
        })
    end
})

utilitySection:Button({
    Title = "防止摔跤伤害",
    Desc = "就算掉下去了，也毫发无伤，掉到水里面也会死的",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/cytj777i/Fall-injury/main/防止摔落伤害"))()
        
        WindUI:Notify({
            Title = "通知",
            Content = "加载成功",
            Duration = 1,
            Icon = "layout-grid",
        })
    end
})

utilitySection:Button({
    Title = "无敌少侠",
    Desc = "用了它，你就会变成城市超人",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Invinicible-Flight-R15-45414"))()
        
        WindUI:Notify({
            Title = "通知",
            Content = "加载成功",
            Duration = 1,
            Icon = "layout-grid",
        })
    end
})

-- ============ 角色相关分区 ============

characterSection:Button({
    Title = "美化",
    Desc = "断头和断腿",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Permanent-Headless-And-korblox-Script-4140"))()
        
        WindUI:Notify({
            Title = "通知",
            Content = "加载成功",
            Duration = 1,
            Icon = "layout-grid",
        })
    end
})

characterSection:Button({
    Title = "动作",
    Desc = "别人可看到",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/smalldesikon/vv/main/%E8%80%81%E5%A4%96%E5%8A%A8%E4%BD%9C100%E4%B8%87%E4%B8%AA"))()
        
        WindUI:Notify({
            Title = "通知",
            Content = "加载成功",
            Duration = 1,
            Icon = "layout-grid",
        })
    end
})

characterSection:Button({
    Title = "动画包➕动作",
    Desc = "非常好用",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://yarhm.mhi.im/scr?channel=afemmax"))()
        
        WindUI:Notify({
            Title = "通知",
            Content = "加载成功",
            Duration = 1,
            Icon = "layout-grid",
        })
    end
})