local WasUIPro = loadstring(game:HttpGet("https://github.com/WasKKal/WasUI-For-Roblox/raw/refs/heads/main/WasUIPro.lua"))()

local Uis = game:GetService("UserInputService")
local Players = game:GetService("Players")
--[[
    设置默认项 一般用于用户端改变界面调用
    正常通过CreateWindow中设置即可
]]
WasUIPro:SetDefaultTheme("Dark")
WasUIPro:SetDefaultRainbowMode("流动")
WasUIPro:SetLanguage("中文") 
-- 默认不启用英文,一般无需设置该项目
-- 默认为Dark主题

local mainWindow = WasUIPro:CreateWindow({
    Title = "WasUIPro 完整演示",
    WelcomeText = "展示所有控件及动态功能",
    MinimizedText = "WasUIPro",
    Theme = "Dark",
    RainbowMode = "流动",
    DialogTitle = "确认关闭窗口",
    GroupText = "加入交流群",
    GroupCopy = "123456789", --在此输入你的群聊加入链接等
    SnowEnabled = true,
    Background = "rbxassetid://1234567890", --设置背景链接 支持rbx资产/Url链接
    Folder = "WasUIPro_示例配置",
    TitleTag = {
        { text = "Demo", backgroundColor = Color3.fromRGB(0,152,211), textColor = Color3.fromRGB(255,255,255) },
        { text = "NEW", backgroundColor = Color3.fromRGB(255,80,80), textColor = Color3.fromRGB(255,255,255) }
    }, -- 添加titletag,最多两个
    FrameColor = nil,-- 传入nil默认彩虹流动,你可以传入多组颜色到边框中,但不会流动(我不会做)
--[[
    {
    Color3.fromRGB(255, 100, 100),
    Color3.fromRGB(100, 255, 100),
    Color3.fromRGB(100, 100, 255)
    },
    ]]
    FeatureNameColor = {Color3.fromRGB(255, 100, 200), Color3.fromRGB(255, 150, 50)}
    -- 设置两种颜色以渐变,不设置时默认绿向紫渐变
})

task.spawn(function()
    task.wait(0.5)
    WasUIPro:Popup({
        title = "欢迎使用 WasUIPro",
        titleIcon = "sparkles",
        content = "完整控件演示，配置文件自动保存",
        confirmText = "开始体验",
        onConfirm = function() end --你可以在这里加上功能
    })
end)

-- 创建选项卡
local basicTab = mainWindow:Tab({ Title = "基础控件" })
--创建Category
local basicCategory = basicTab:Category({ Title = "常用控件", IconName = "layout-grid" })

-- 绑定在Category上的控件 用于折叠功能
basicCategory:Button({
    Text = "普通按钮",
    Icon = "play",
    Tooltip = "点击触发通知",
    Callback = function()
        WasUIPro:Notify({ Title = "按钮", Content = "你点击了按钮", Duration = 2 })
    end
})

basicCategory:Toggle({
    Title = "自动拾取",
    Value = false,
    FeatureName = "AutoLoot",
    Icon = "package",
    ConfigKey = "auto_loot",
    Tooltip = "开启后自动拾取物品",
    Callback = function(state)
        WasUIPro:Notify({ Title = "自动拾取", Content = state and "已开启" or "已关闭", Duration = 1 })
    end
})

basicCategory:Toggle({
    Title = "无敌模式",
    Value = false,
    FeatureName = "GodMode",
    Icon = "shield",
    ConfigKey = "god_mode",
    Tooltip = "免疫所有伤害",
    Callback = function(state)
        WasUIPro:Notify({ Title = "无敌模式", Content = state and "已开启" or "已关闭", Duration = 1 })
    end
})

local volumeSlider = basicCategory:Slider({
    Title = "音量调节",
    Min = 0,
    Max = 100,
    Default = 50,
    Ticks = 10,
    ConfigKey = "volume",
    Callback = function(value)
        print("音量", value)
    end
})

-- 单选的下拉菜单
basicCategory:Dropdown({
    Title = "武器选择",
    Values = { "剑", "弓", "法杖", "匕首" },
    Value = "剑",
    Multi = false,
    ConfigKey = "weapon",
    Callback = function(selected)
        WasUIPro:Notify({ Title = "武器", Content = "当前武器: " .. selected, Duration = 1 })
    end
})

--多选的下拉菜单
basicCategory:Dropdown({
    Title = "技能多选",
    Values = { "火球术", "冰霜新星", "闪现", "治疗术" },
    Value = { "火球术", "闪现" }, -- 设置默认值
    Multi = true, -- 控制多选
    ConfigKey = "skills",
    Callback = function(selected)
        print("已选技能", table.concat(selected, ", "))
    end
})

-- 输入框
basicCategory:TextInput({
    Title = "玩家昵称",
    Placeholder = "请输入昵称",
    Value = "冒险者",
    ConfigKey = "nickname",
    Callback = function(text)
        print("昵称", text)
    end
})

-- 进度条控件 一般用于功能进度可视化
local expBar = basicCategory:ProgressBar({
    Title = "经验值",
    Min = 0,
    Max = 1000,
    Default = 250,
})

task.spawn(function()
    while true do
        task.wait(3)
        local newValue = expBar:GetValue() + 50
        if newValue > 1000 then newValue = 0 end
        expBar:SetValue(newValue)
    end
end)

-- 段落控件
basicTab:Paragraph({
    Title = "关于 WasUIPro",
    Desc = "轻量级 UI 库，支持主题切换、动画效果、配置保存、快捷键",
    Icon = "info"
})

local advancedTab = mainWindow:Tab({ Title = "高级控件" })

local advancedCategory = advancedTab:Category({ Title = "高级功能", IconName = "sliders-horizontal" })

advancedCategory:ColorPickerButton({
    Title = "主题颜色选择",
    Default = Color3.fromRGB(153, 51, 255),
    ConfigKey = "theme_color",
    Callback = function(color, alpha)
        WasUIPro:Notify({ Title = "颜色", Content = string.format("RGB: %s", color:ToHex()), Duration = 2 })
    end
})

advancedCategory:Toggle({
    Title = "彩虹文字特效",
    Value = false,
    FeatureName = "RainbowEffect",
    ConfigKey = "rainbow_effect",
    Callback = function(state)
        WasUIPro:Notify({ Title = "彩虹", Content = state and "特效已开启" or "特效已关闭", Duration = 1 })
    end
})

advancedCategory:Button({
    Text = "危险操作",
    Icon = "alert-triangle",
    Callback = function()
        WasUIPro:ShowConfirmDialog({
            title = "危险操作确认",
            description = "此操作不可逆，是否继续",
            confirmText = "确定",
            cancelText = "取消",
            onConfirm = function()
                WasUIPro:Notify({ Title = "执行", Content = "危险操作已执行", Duration = 2 })
            end
        })
    end
})
advancedCategory:Button({
    Text = "显示自定义弹窗",
    Icon = "message-circle",
    Callback = function()
        WasUIPro:ShowPopup({
            title = "自定义弹窗",
            titleIcon = "smile",
            content = "这是一个完全自定义的弹窗，可以包含图标和多个按钮",
            confirmText = "确认",
            cancelText = "取消",
            onConfirm = function()
                WasUIPro:Notify({ Title = "弹窗", Content = "点击了确认", Duration = 1 })
            end
        })
    end
})

local demoSliderTab = mainWindow:Tab({ Title = "滑块联动" })

local sliderCategory = demoSliderTab:Category({ Title = "进度条与滑块联动", IconName = "activity" })

local sliderA = sliderCategory:Slider({
    Title = "控制进度A",
    Min = 0,
    Max = 100,
    Default = 30,
    Step = 0.5 --控制分度值
})
local sliderB = sliderCategory:Slider({
    Title = "控制进度B",
    Min = 0,
    Max = 100,
    Default = 60,
    Step = 1
})
-- 进度条控件展示
local progressDemo = sliderCategory:ProgressBar({
    Title = "总进度平均值",
    Min = 0,
    Max = 100,
    Default = 0,
})

local function updateTotal()
    local avg = (sliderA.Value + sliderB.Value) / 2
    progressDemo:SetValue(avg)
end
sliderA.Callback = updateTotal
sliderB.Callback = updateTotal
updateTotal()

sliderCategory:Button({
    Text = "重置全部",
    Icon = "refresh-cw",
    Callback = function()
        sliderA:SetValue(50)
        sliderB:SetValue(50)
        WasUIPro:Notify({ Title = "重置", Content = "已重置", Duration = 1 })
    end
})

local dynamicTab = mainWindow:Tab({ Title = "动态演示" })

local dynamicCategory = dynamicTab:Category({ Title = "玩家列表与动态信息", IconName = "users" })

local playerDropdown = nil

dynamicCategory:Button({
    Text = "刷新玩家列表",
    Icon = "refresh-cw",
    Tooltip = "从服务器获取当前在线玩家",
    Callback = function()
        local playerList = Players:GetPlayers()
        local playerNames = {}
        for _, plr in ipairs(playerList) do
            table.insert(playerNames, plr.Name)
        end
        if #playerNames == 0 then
            WasUIPro:Notify({ Title = "提示", Content = "当前没有玩家", Duration = 2 })
            return
        end
        if playerDropdown then
            local current = playerDropdown.SelectedValue
            local newDefault = nil
            for _, name in ipairs(playerNames) do
                if name == current then
                    newDefault = current
                    break
                end
            end
            if not newDefault and #playerNames > 0 then
                newDefault = playerNames[1]
            end
            playerDropdown:UpdateOptions(playerNames, newDefault)
        end
        WasUIPro:Notify({ Title = "刷新成功", Content = "共 " .. #playerNames .. " 名玩家", Duration = 2 })
    end
})

playerDropdown = dynamicCategory:Dropdown({
    Title = "选择玩家",
    Values = {},
    Value = "无",
    Multi = false,
    Callback = function(selected)
        if selected and selected ~= "无" then
            local player = Players:FindFirstChild(selected)
            if player then
                local char = player.Character
                local pos = char and char:GetPivot() or Vector3.zero
                local info = string.format("坐标: X=%.1f Y=%.1f Z=%.1f", pos.X, pos.Y, pos.Z)
                dynamicPara:SetContent(info)
                dynamicPara:SetTitle("当前玩家 " .. selected)
            else
                dynamicPara:SetContent("无法获取玩家信息")
                dynamicPara:SetTitle("未选中玩家")
            end
        else
            dynamicPara:SetContent("请从下拉菜单选择一个玩家")
            dynamicPara:SetTitle("未选中玩家")
        end
    end
})

local dynamicPara = dynamicCategory:Paragraph({
    Title = "未选中玩家",
    Desc = "请从下拉菜单选择一个玩家",
    Icon = "user"
})

dynamicCategory:Button({
    Text = "随机传送演示",
    Icon = "send",
    Tooltip = "模拟传送至随机位置",
    Callback = function()
        if not playerDropdown.SelectedValue or playerDropdown.SelectedValue == "无" then
            WasUIPro:Notify({ Title = "错误", Content = "请先选择玩家", Duration = 2 })
            return
        end
        local targetName = playerDropdown.SelectedValue
        local targetPlayer = Players:FindFirstChild(targetName)
        if targetPlayer then
            local randomX = math.random(-100, 100)
            local randomZ = math.random(-100, 100)
            local info = string.format("模拟传送至 X=%.1f Z=%.1f", randomX, randomZ)
            dynamicPara:SetContent(info)
            dynamicPara:SetTitle("已传送 " .. targetName)
            WasUIPro:Notify({ Title = "传送", Content = "已传送至 " .. targetName, Duration = 2 })
        else
            dynamicPara:SetContent("玩家不存在，请刷新列表")
            dynamicPara:SetTitle("传送失败")
        end
    end
})

local styleCategory = dynamicTab:Category({ Title = "段落样式动态切换", IconName = "palette" })

local stylePara = styleCategory:Paragraph({
    Title = "默认标题",
    Desc = "默认描述文字，点击下方按钮可动态修改内容和样式",
    Icon = "file-text"
})

local function updateStyle(style)
    if style == "red" then
        stylePara.TitleLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        stylePara.ContentLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
        stylePara:SetTitle("红色主题")
        stylePara:SetContent("段落文字已变为红色")
    elseif style == "blue" then
        stylePara.TitleLabel.TextColor3 = Color3.fromRGB(100, 150, 255)
        stylePara.ContentLabel.TextColor3 = Color3.fromRGB(120, 170, 255)
        stylePara:SetTitle("蓝色主题")
        stylePara:SetContent("段落文字已变为蓝色")
    else
        stylePara.TitleLabel.TextColor3 = WasUIPro.CurrentTheme.Text
        stylePara.ContentLabel.TextColor3 = WasUIPro.CurrentTheme.Text
        stylePara:SetTitle("默认样式")
        stylePara:SetContent("段落文字已恢复默认颜色")
    end
end

styleCategory:Button({
    Text = "红色样式",
    Icon = "circle",
    Callback = function() updateStyle("red") end
})

styleCategory:Button({
    Text = "蓝色样式",
    Icon = "circle",
    Callback = function() updateStyle("blue") end
})

styleCategory:Button({
    Text = "默认样式",
    Icon = "refresh-cw",
    Callback = function() updateStyle("default") end
})

local extraTab = mainWindow:Tab({ Title = "额外演示" })

local extraCategory = extraTab:Category({ Title = "FeatureName 颜色展示", IconName = "palette" })
extraCategory:Toggle({
    Title = "功能 A",
    Value = false,
    FeatureName = "FeatureA",
    Icon = "circle",
    Tooltip = "FeatureA 演示",
    Callback = function(state)
        WasUIPro:Notify({ Title = "FeatureA", Content = state and "开启" or "关闭", Duration = 1 })
    end
})

extraCategory:Toggle({
    Title = "功能 B",
    Value = true,
    FeatureName = "FeatureB",
    Icon = "circle",
    Tooltip = "FeatureB 演示",
    Callback = function(state)
        WasUIPro:Notify({ Title = "FeatureB", Content = state and "开启" or "关闭", Duration = 1 })
    end
})

extraCategory:Toggle({
    Title = "功能 C",
    Value = false,
    FeatureName = "FeatureC",
    Icon = "circle",
    Tooltip = "FeatureC 演示",
    Callback = function(state)
        WasUIPro:Notify({ Title = "FeatureC", Content = state and "开启" or "关闭", Duration = 1 })
    end
})

extraCategory:Toggle({
    Title = "功能 D",
    Value = true,
    FeatureName = "FeatureD",
    Icon = "circle",
    Tooltip = "FeatureD 演示",
    Callback = function(state)
        WasUIPro:Notify({ Title = "FeatureD", Content = state and "开启" or "关闭", Duration = 1 })
    end
})

local isVisible = true
Uis.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        isVisible = not isVisible
        mainWindow:SetVisible(isVisible)
    end
end)

WasUIPro:Notify({ Title = "初始化", Content = "WasUIPro 示例加载完成", Duration = 4 })