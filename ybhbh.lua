local repo = "https://raw.githubusercontent.com/YirdeX-Dev/obsidian_UI/refs/heads/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "SaveManager.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "ThemeManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

local Window = Library:CreateWindow({
	Title = "<font color=\"#7FC8F0\">A</font><font color=\"#74C0EB\">F</font><font color=\"#69B8E6\">H</font><font color=\"#5EB0E1\">U</font><font color=\"#53A8DC\">B</font><font color=\"#48A0D7\">（</font><font color=\"#3D98D2\">回</font><font color=\"#3290CD\">归</font><font color=\"#2788C8\">版</font><font color=\"#1C80C3\">）</font>",
	Footer = "版本: 示例",
	Icon = 122936242690381,
	NotifySide = "Right",
	ShowCustomCursor = true,
	BackgroundImage = "rbxassetid://123887383447725",--这里改你的图片背景
	BackgroundTransparency = 0.3, 
	BackgroundColor = Color3.fromRGB(0, 0, 0),
})

-- 创建标签页 (Tab)
local Tabs = {
    Main = Window:AddTab("主要控件", "info"),
    Settings = Window:AddTab("设置", "settings"),
}

-- 创建分组 (Groupbox)
-- Left 和 Right 决定了在窗口的哪一侧
local LeftGroup = Tabs.Main:AddLeftGroupbox("常用控件示例")
local RightGroup = Tabs.Main:AddRightGroupbox("高级/特殊控件")

-- ==========================================================
-- 左侧：基础控件 (开关、滑条、按钮)
-- ==========================================================

-- 1. 文本标签 (Label)
LeftGroup:AddLabel('这是一个普通文本标签')
LeftGroup:AddLabel('这是一个带颜色的标签', true)

-- 2. 开关 (Toggle)
LeftGroup:AddToggle('MyToggle', {
    Text = '普通开关',
    Default = false, -- 默认状态
    Tooltip = '鼠标悬停提示：这是一个开关', -- 提示文本
    Callback = function(Value)
        print('[回调] 开关状态改变:', Value)
    end
})

-- 3. 带颜色选择器的开关
LeftGroup:AddToggle('ToggleWithColor', {
    Text = '开关 + 颜色选择',
    Default = true,
}):AddColorPicker('MyColorPicker', {
    Default = Color3.fromRGB(255, 0, 0),
    Title = '颜色设置', 
    Transparency = 0, 
    Callback = function(Value)
        print('[回调] 颜色改变:', Value)
    end
})

-- 4. 按钮 (Button)
LeftGroup:AddButton({
    Text = '普通按钮',
    Func = function()
        Library:Notify("你点击了按钮！", 3) -- 发送通知
        print('按钮被点击')
    end,
    DoubleClick = false, -- 是否需要双击
})

-- 5. 带子按钮的按钮
LeftGroup:AddButton({
    Text = '主按钮',
    Func = function() print('主按钮点击') end,
}):AddButton({
    Text = '子按钮',
    Func = function() print('子按钮点击') end,
})

-- 6. 滑条 (Slider)
LeftGroup:AddSlider('MyIntSlider', {
    Text = '整数滑条',
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0, -- 0 表示整数
    Suffix = " %", -- 后缀单位
    Compact = false, 
    Callback = function(Value)
        print('[回调] 滑条值:', Value)
    end
})

LeftGroup:AddSlider('MyFloatSlider', {
    Text = '小数滑条',
    Default = 0.5,
    Min = 0,
    Max = 1,
    Rounding = 2, -- 保留两位小数
    Callback = function(Value)
        print('[回调] 小数值:', Value)
    end
})

-- ==========================================================
-- 右侧：输入、下拉、快捷键
-- ==========================================================

-- 7. 输入框 (Input)
RightGroup:AddInput('MyInput', {
    Default = '默认内容',
    Numeric = false, -- 是否只允许输入数字
    Finished = true, -- true: 按回车触发; false: 实时触发
    Text = '文本输入框',
    Placeholder = '请输入...', 
    Callback = function(Value)
        print('[回调] 输入内容:', Value)
    end
})

-- 8. 下拉框 (Dropdown) - 单选
RightGroup:AddDropdown('MyDropdown', {
    Values = { '选项 A', '选项 B', '选项 C' },
    Default = 1, 
    Multi = false, -- 单选
    Text = '单选下拉框',
    Callback = function(Value)
        print('[回调] 选中:', Value)
    end
})

-- 9. 下拉框 (Dropdown) - 多选
RightGroup:AddDropdown('MyMultiDropdown', {
    Values = { '苹果', '香蕉', '橘子' },
    Default = 1, 
    Multi = true, -- 多选
    Text = '多选下拉框',
    Tooltip = '可以选择多个',
    Callback = function(Value)
        -- 多选返回的是一个表 {["苹果"] = true, ["香蕉"] = false}
        print('[回调] 多选表:', Value)
    end
})

-- 10. 玩家选择下拉框 (特殊类型)
RightGroup:AddDropdown('PlayerList', {
    SpecialType = 'Player',
    Text = '玩家列表',
    Tooltip = '自动获取当前服务器玩家',
    Callback = function(Value)
        print('[回调] 选中玩家:', Value)
    end
})

-- 11. 快捷键 (Keybind)
RightGroup:AddLabel('按键绑定'):AddKeyPicker('MyKeybind', {
    Default = 'RightAlt', 
    SyncToggleState = false, 
    Mode = 'Toggle', -- 模式: Always, Toggle, Hold
    Text = '功能热键', 
    NoUI = false, 
    Callback = function(Value)
        print('[回调] 按键触发:', Value)
    end
})

-- 12. 独立颜色选择器
RightGroup:AddLabel('独立颜色选择器'):AddColorPicker('StandaloneColor', {
    Default = Color3.fromRGB(0, 255, 128),
    Title = '自定义颜色', 
    Callback = function(Value)
        print('[回调] 颜色:', Value)
    end
})

local MenuGroup = Tabs.Settings:AddLeftGroupbox('菜单')
MenuGroup:AddButton('卸载脚本', function() Library:Unload() end)
MenuGroup:AddLabel('菜单快捷键'):AddKeyPicker('MenuKeybind', { Default = 'RightShift', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("MyScriptTheme")
SaveManager:SetFolder("MyScriptConfig")
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)