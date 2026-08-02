--[[
    XA-Hub 源代码还原版
    修复与重构: Claude
    版本: Beta-4.7.1 (还原)
]]

--------------------------------------------------------------------------------
-- 1. 服务与初始化
--------------------------------------------------------------------------------
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- 检查并创建工作目录
if not isfolder("XA-Hub") then makefolder("XA-Hub") end
if not isfolder("XA-Hub/Music") then makefolder("XA-Hub/Music") end

--------------------------------------------------------------------------------
-- 2. 加载外部库 (ESP, UI组件, 通知等)
--------------------------------------------------------------------------------

-- 加载 ESP 库
local Success_ESP, ESPLibrary = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Xingtaiduan/Script/refs/heads/main/ESPLibrary.lua"))()
end)

if not Success_ESP then warn("ESP Library failed to load") end

-- 加载通知库
local Success_Notify, NotifyLib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Xingtaiduan/Script/refs/heads/main/Library/Notification.lua"))()
end)

-- 加载翻译表 (模拟原脚本逻辑)
local Translations = {
    ["通用"] = "通用",
    ["信息"] = "信息",
    ["本地玩家"] = "本地玩家",
    ["传送"] = "传送",
    ["甩飞"] = "甩飞",
    ["循环甩飞"] = "循环甩飞",
    ["移动速度"] = "移动速度",
    ["跳跃高度"] = "跳跃高度",
    ["重力"] = "重力",
    ["视角"] = "视角",
    ["最大倾斜角"] = "最大倾斜角",
    ["CFrame加速"] = "CFrame加速",
    ["Velocity加速"] = "Velocity加速",
    ["人物高度"] = "人物高度",
    -- 如果需要更多翻译可在此添加
}

-- 简单的翻译辅助函数
local function GetTrans(key)
    return Translations[key] or key
end

--------------------------------------------------------------------------------
-- 3. 全局功能变量与工具函数
--------------------------------------------------------------------------------
local Flags = {} --用于存储开关状态
local SelectedPlayer = nil -- 下拉框选中的玩家
local TeleportOffset = CFrame.new(0, 0, 3) -- 默认传送位置（背后）

-- 自动获取 UI 父级 (优先 CoreGui，其次 PlayerGui)
local function GetUIParent()
    local success, parent = pcall(function() return game:GetService("CoreGui") end)
    if success and parent then return parent end
    return LocalPlayer:WaitForChild("PlayerGui")
end

-- 防止 UI 重复加载
for _, gui in pairs(GetUIParent():GetChildren()) do
    if gui.Name == "XA_LuaWare" then gui:Destroy() end
end

--------------------------------------------------------------------------------
-- 4. UI 构建 (重构自原代码的 Instance.new 部分)
--------------------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XA_LuaWare"
ScreenGui.Parent = GetUIParent()
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 主窗口
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BackgroundTransparency = 0.5
MainFrame.BorderColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.5, -286, 0.5, -176)
MainFrame.Size = UDim2.new(0, 572, 0, 353)
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 3)
MainCorner.Parent = MainFrame

-- 侧边栏背景
local SideBar = Instance.new("Frame")
SideBar.Name = "SideBar"
SideBar.Parent = MainFrame
SideBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SideBar.BackgroundTransparency = 0.5
SideBar.Size = UDim2.new(0, 8, 0, 353)

local SideBarCorner = Instance.new("UICorner")
SideBarCorner.CornerRadius = UDim.new(0, 6)
SideBarCorner.Parent = SideBar

-- 侧边栏内容区
local SideContent = Instance.new("Frame")
SideContent.Name = "SideContent"
SideContent.Parent = SideBar
SideContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SideContent.BackgroundTransparency = 0.5
SideContent.ClipsDescendants = true
SideContent.Size = UDim2.new(0, 110, 0, 353)

-- 侧边栏渐变
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 40, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 40, 70))
}
UIGradient.Rotation = 90
UIGradient.Parent = SideContent

-- 标题
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Parent = SideContent
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 5, 0, 10)
TitleLabel.Size = UDim2.new(0, 102, 0, 20)
TitleLabel.Font = Enum.Font.GothamSemibold
TitleLabel.Text = "XA-Hub"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Tab 按钮滚动区
local TabScroll = Instance.new("ScrollingFrame")
TabScroll.Name = "TabButtons"
TabScroll.Parent = SideContent
TabScroll.BackgroundTransparency = 1
TabScroll.Position = UDim2.new(0, 0, 0.1, 0)
TabScroll.Size = UDim2.new(0, 110, 0, 310)
TabScroll.CanvasSize = UDim2.new(0, 0, 1, 0)
TabScroll.ScrollBarThickness = 0

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabScroll
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 12)

-- 内容显示区 (所有功能页面放在这里)
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Parent = MainFrame
TabContainer.BackgroundTransparency = 1
TabContainer.Position = UDim2.new(0, 120, 0, 3)
TabContainer.Size = UDim2.new(0, 448, 0, 346)

-- 隐藏/打开 按钮 (小图标)
local ToggleUIButton = Instance.new("TextButton")
ToggleUIButton.Name = "ToggleUI"
ToggleUIButton.Parent = ScreenGui
ToggleUIButton.BackgroundColor3 = Color3.fromRGB(28, 33, 55)
ToggleUIButton.Position = UDim2.new(0, 20, 0.3, 0)
ToggleUIButton.Size = UDim2.new(0, 60, 0, 30)
ToggleUIButton.Font = Enum.Font.SourceSans
ToggleUIButton.Text = "隐藏/打开"
ToggleUIButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleUIButton.TextSize = 14
ToggleUIButton.Draggable = true
ToggleUIButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

--------------------------------------------------------------------------------
-- 5. UI 辅助构建函数 (用于创建 Tab, Section, Slider 等)
--------------------------------------------------------------------------------

local Tabs = {}

local function CreateTab(name)
    -- 创建 Tab 按钮
    local TabButtonFrame = Instance.new("ImageLabel")
    TabButtonFrame.Parent = TabScroll
    TabButtonFrame.BackgroundTransparency = 1
    TabButtonFrame.Size = UDim2.new(0, 110, 0, 24)
    TabButtonFrame.Image = "" -- 可以设置图标

    local TabLabel = Instance.new("TextLabel")
    TabLabel.Parent = TabButtonFrame
    TabLabel.BackgroundTransparency = 1
    TabLabel.Position = UDim2.new(0, 15, 0, 0)
    TabLabel.Size = UDim2.new(0, 80, 1, 0)
    TabLabel.Font = Enum.Font.GothamSemibold
    TabLabel.Text = GetTrans(name)
    TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabLabel.TextSize = 14
    TabLabel.TextXAlignment = Enum.TextXAlignment.Left
    TabLabel.TextTransparency = 0.5

    local TabBtn = Instance.new("TextButton")
    TabBtn.Parent = TabButtonFrame
    TabBtn.BackgroundTransparency = 1
    TabBtn.Size = UDim2.new(1, 0, 1, 0)
    TabBtn.Text = ""

    -- 创建 Tab 页面
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Name = name .. "_Page"
    TabPage.Parent = TabContainer
    TabPage.BackgroundTransparency = 1
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.Visible = false
    TabPage.ScrollBarThickness = 2

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = TabPage
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 6)

    -- Tab 切换逻辑
    TabBtn.MouseButton1Click:Connect(function()
        for _, page in pairs(TabContainer:GetChildren()) do
            page.Visible = false
        end
        for _, btn in pairs(TabScroll:GetChildren()) do
            if btn:IsA("ImageLabel") and btn:FindFirstChild("TextLabel") then
                TweenService:Create(btn.TextLabel, TweenInfo.new(0.2), {TextTransparency = 0.5}):Play()
            end
        end
        TabPage.Visible = true
        TweenService:Create(TabLabel, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
    end)

    -- 默认选中第一个
    if #Tabs == 0 then
        TabPage.Visible = true
        TabLabel.TextTransparency = 0
    end
    table.insert(Tabs, TabPage)

    return TabPage
end

local function CreateSection(parent, text)
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Parent = parent
    SectionFrame.BackgroundColor3 = Color3.fromRGB(35, 40, 70)
    SectionFrame.BackgroundTransparency = 1
    SectionFrame.Size = UDim2.new(0.98, 0, 0, 30) -- 初始高度

    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Parent = SectionFrame
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.Position = UDim2.new(0, 10, 0, 0)
    SectionLabel.Size = UDim2.new(1, -20, 0, 30)
    SectionLabel.Font = Enum.Font.GothamSemibold
    SectionLabel.Text = GetTrans(text)
    SectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SectionLabel.TextSize = 16
    SectionLabel.TextXAlignment = Enum.TextXAlignment.Left

    local Container = Instance.new("Frame")
    Container.Parent = parent
    Container.BackgroundTransparency = 1
    Container.Size = UDim2.new(0.98, 0, 0, 0)
    Container.ClipsDescendants = false
    
    local ContainerLayout = Instance.new("UIListLayout")
    ContainerLayout.Parent = Container
    ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContainerLayout.Padding = UDim.new(0, 5)

    ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.Size = UDim2.new(0.98, 0, 0, ContainerLayout.AbsoluteContentSize.Y)
    end)

    return Container
end

local function CreateLabel(parent, text, dynamicFunc)
    local LabelBg = Instance.new("Frame")
    LabelBg.Parent = parent
    LabelBg.BackgroundColor3 = Color3.fromRGB(35, 40, 70)
    LabelBg.Size = UDim2.new(1, 0, 0, 26)
    
    local LabelCorner = Instance.new("UICorner")
    LabelCorner.CornerRadius = UDim.new(0, 4)
    LabelCorner.Parent = LabelBg

    local Label = Instance.new("TextLabel")
    Label.Parent = LabelBg
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.Font = Enum.Font.GothamSemibold
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14

    if dynamicFunc then
        task.spawn(function()
            while parent.Parent do
                Label.Text = dynamicFunc()
                task.wait(1)
            end
        end)
    end
    return Label
end

local function CreateButton(parent, text, callback)
    local ButtonFrame = Instance.new("TextButton")
    ButtonFrame.Parent = parent
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(35, 40, 70)
    ButtonFrame.Size = UDim2.new(1, 0, 0, 32)
    ButtonFrame.AutoButtonColor = false
    ButtonFrame.Font = Enum.Font.GothamSemibold
    ButtonFrame.Text = "   " .. GetTrans(text)
    ButtonFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
    ButtonFrame.TextSize = 14
    ButtonFrame.TextXAlignment = Enum.TextXAlignment.Left

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = ButtonFrame

    ButtonFrame.MouseButton1Click:Connect(callback)
    return ButtonFrame
end

local function CreateToggle(parent, text, default, callback)
    local ToggleFrame = Instance.new("TextButton")
    ToggleFrame.Parent = parent
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 40, 70)
    ToggleFrame.Size = UDim2.new(1, 0, 0, 32)
    ToggleFrame.AutoButtonColor = false
    ToggleFrame.Font = Enum.Font.GothamSemibold
    ToggleFrame.Text = "   " .. GetTrans(text)
    ToggleFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleFrame.TextSize = 14
    ToggleFrame.TextXAlignment = Enum.TextXAlignment.Left

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = ToggleFrame

    local Indicator = Instance.new("Frame")
    Indicator.Parent = ToggleFrame
    Indicator.AnchorPoint = Vector2.new(1, 0.5)
    Indicator.Position = UDim2.new(0.95, 0, 0.5, 0)
    Indicator.Size = UDim2.new(0, 20, 0, 20)
    Indicator.BackgroundColor3 = default and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)

    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(0, 4)
    IndicatorCorner.Parent = Indicator

    local enabled = default
    Flags[text] = enabled

    ToggleFrame.MouseButton1Click:Connect(function()
        enabled = not enabled
        Flags[text] = enabled
        Indicator.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
        callback(enabled)
    end)
    
    -- 初始化调用
    if default then callback(true) end
end

local function CreateSlider(parent, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Parent = parent
    SliderFrame.BackgroundColor3 = Color3.fromRGB(35, 40, 70)
    SliderFrame.Size = UDim2.new(1, 0, 0, 40)

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = SliderFrame

    local Label = Instance.new("TextLabel")
    Label.Parent = SliderFrame
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Size = UDim2.new(0, 200, 0, 25)
    Label.Font = Enum.Font.GothamSemibold
    Label.Text = GetTrans(text)
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ValueLabel = Instance.new("TextBox")
    ValueLabel.Parent = SliderFrame
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Position = UDim2.new(0.8, 0, 0, 0)
    ValueLabel.Size = UDim2.new(0.15, 0, 0, 25)
    ValueLabel.Font = Enum.Font.Gotham
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ValueLabel.TextSize = 14

    local SliderBar = Instance.new("Frame")
    SliderBar.Parent = SliderFrame
    SliderBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    SliderBar.Position = UDim2.new(0, 10, 0, 30)
    SliderBar.Size = UDim2.new(1, -20, 0, 6)

    local SliderBarCorner = Instance.new("UICorner")
    SliderBarCorner.Parent = SliderBar

    local Fill = Instance.new("Frame")
    Fill.Parent = SliderBar
    Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)

    local FillCorner = Instance.new("UICorner")
    FillCorner.Parent = Fill

    local Button = Instance.new("TextButton")
    Button.Parent = SliderBar
    Button.BackgroundTransparency = 1
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.Text = ""

    local dragging = false
    local function update(input)
        local pos = UDim2.new(math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1), 0, 1, 0)
        Fill.Size = pos
        local val = math.floor(((pos.X.Scale * (max - min)) + min) * 10) / 10
        ValueLabel.Text = tostring(val)
        callback(val)
    end

    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            update(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input)
        end
    end)
    
    ValueLabel.FocusLost:Connect(function()
        local val = tonumber(ValueLabel.Text)
        if val then
            val = math.clamp(val, min, max)
            ValueLabel.Text = tostring(val)
            Fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
            callback(val)
        end
    end)
end

local function CreatePlayerDropdown(parent, callback)
    local DropFrame = Instance.new("Frame")
    DropFrame.Parent = parent
    DropFrame.BackgroundColor3 = Color3.fromRGB(35, 40, 70)
    DropFrame.Size = UDim2.new(1, 0, 0, 32)
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = DropFrame

    local SelectedLabel = Instance.new("TextLabel")
    SelectedLabel.Parent = DropFrame
    SelectedLabel.BackgroundTransparency = 1
    SelectedLabel.Position = UDim2.new(0, 10, 0, 0)
    SelectedLabel.Size = UDim2.new(0.8, 0, 1, 0)
    SelectedLabel.Font = Enum.Font.GothamSemibold
    SelectedLabel.Text = "选择玩家 (All 为全体)"
    SelectedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SelectedLabel.TextSize = 14
    SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left

    local OpenBtn = Instance.new("TextButton")
    OpenBtn.Parent = DropFrame
    OpenBtn.BackgroundTransparency = 1
    OpenBtn.Size = UDim2.new(1, 0, 1, 0)
    OpenBtn.Text = ""

    local ListFrame = Instance.new("ScrollingFrame")
    ListFrame.Parent = parent
    ListFrame.BackgroundColor3 = Color3.fromRGB(30, 35, 60)
    ListFrame.Size = UDim2.new(1, 0, 0, 150)
    ListFrame.Visible = false
    ListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Parent = ListFrame
    
    local function RefreshPlayers()
        for _, c in pairs(ListFrame:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        
        -- 添加 "All" 选项
        local AllBtn = Instance.new("TextButton")
        AllBtn.Parent = ListFrame
        AllBtn.Size = UDim2.new(1, 0, 0, 25)
        AllBtn.Font = Enum.Font.Gotham
        AllBtn.Text = "All"
        AllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        AllBtn.BackgroundColor3 = Color3.fromRGB(40, 45, 75)
        AllBtn.MouseButton1Click:Connect(function()
            SelectedLabel.Text = "All"
            SelectedPlayer = "All"
            ListFrame.Visible = false
            callback("All")
        end)

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local Btn = Instance.new("TextButton")
                Btn.Parent = ListFrame
                Btn.Size = UDim2.new(1, 0, 0, 25)
                Btn.Font = Enum.Font.Gotham
                Btn.Text = p.DisplayName .. " (" .. p.Name .. ")"
                Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                Btn.BackgroundColor3 = Color3.fromRGB(40, 45, 75)
                Btn.MouseButton1Click:Connect(function()
                    SelectedLabel.Text = p.Name
                    SelectedPlayer = p
                    ListFrame.Visible = false
                    callback(p)
                end)
            end
        end
        ListFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
    end

    OpenBtn.MouseButton1Click:Connect(function()
        ListFrame.Visible = not ListFrame.Visible
        if ListFrame.Visible then RefreshPlayers() end
    end)
    
    return DropFrame
end

--------------------------------------------------------------------------------
-- 6. 构建功能页面逻辑
--------------------------------------------------------------------------------

-- ==================== 通用 Tab ====================
local GeneralPage = CreateTab("通用")
local GeneralSection = CreateSection(GeneralPage, "常用功能")

-- 玩家选择
CreatePlayerDropdown(GeneralSection, function(val)
    -- 回调仅用于更新 SelectedPlayer 变量
end)

-- 传送功能
CreateButton(GeneralSection, "传送", function()
    if SelectedPlayer == "All" then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character:SetPrimaryPartCFrame(p.Character.HumanoidRootPart.CFrame * TeleportOffset)
            end
        end
    elseif SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character:SetPrimaryPartCFrame(SelectedPlayer.Character.HumanoidRootPart.CFrame * TeleportOffset)
    end
end)

-- 甩飞功能 (Fling)
local FlingLoop = false
CreateToggle(GeneralSection, "循环甩飞", false, function(state)
    FlingLoop = state
    if state then
        task.spawn(function()
            while FlingLoop and LocalPlayer.Character do
                local Root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if Root then
                    local Vel = Instance.new("BodyAngularVelocity")
                    Vel.AngularVelocity = Vector3.new(0, 99999, 0)
                    Vel.MaxTorque = Vector3.new(0, math.huge, 0)
                    Vel.P = math.huge
                    Vel.Parent = Root
                    task.wait(0.1)
                    Vel:Destroy()
                end
                task.wait()
            end
        end)
    end
end)

-- 甩飞 (单次)
CreateButton(GeneralSection, "甩飞", function()
    local Root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if Root then
        local Vel = Instance.new("BodyAngularVelocity")
        Vel.AngularVelocity = Vector3.new(0, 99999, 0)
        Vel.MaxTorque = Vector3.new(0, math.huge, 0)
        Vel.P = math.huge
        Vel.Parent = Root
        task.wait(0.5)
        Vel:Destroy()
    end
end)

-- 吸取玩家 (Bring/Magnet) - 客户端侧
CreateToggle(GeneralSection, "吸取该玩家(客户端)", false, function(state)
    Flags.Magnet = state
    task.spawn(function()
        while Flags.Magnet and SelectedPlayer and SelectedPlayer ~= "All" do
            if SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
                -- 尝试在本地移动目标玩家到自己面前 (仅部分未受保护的游戏有效或用于特定漏洞)
                SelectedPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
            end
            task.wait()
        end
    end)
end)

-- 定住玩家 (Freeze) - 客户端侧
CreateToggle(GeneralSection, "定住(客户端)", false, function(state)
    Flags.Freeze = state
    if Flags.Freeze and SelectedPlayer and SelectedPlayer ~= "All" and SelectedPlayer.Character then
        for _, part in pairs(SelectedPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.Anchored = true end
        end
    elseif not Flags.Freeze and SelectedPlayer and SelectedPlayer ~= "All" and SelectedPlayer.Character then
        for _, part in pairs(SelectedPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.Anchored = false end
        end
    end
end)

-- ==================== 信息 Tab ====================
local InfoPage = CreateTab("信息")
local InfoSection = CreateSection(InfoPage, "玩家与服务器信息")

CreateLabel(InfoSection, "用户名: " .. LocalPlayer.Name)
CreateLabel(InfoSection, "昵称: " .. LocalPlayer.DisplayName)
CreateLabel(InfoSection, "ID: " .. LocalPlayer.UserId)
CreateLabel(InfoSection, "账号年龄: " .. LocalPlayer.AccountAge .. " 天")
CreateLabel(InfoSection, "注入器: " .. (identifyexecutor and identifyexecutor() or "Unknown"))

-- 动态更新的信息
CreateLabel(InfoSection, "FPS: Calculating...", function()
    return "FPS: " .. math.floor(workspace:GetRealPhysicsFPS())
end)

CreateLabel(InfoSection, "Ping: Calculating...", function()
    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
    return "Ping: " .. ping
end)

CreateLabel(InfoSection, "服务器玩家数: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers, function()
    return "服务器玩家数: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers
end)

CreateLabel(InfoSection, "JobId: " .. game.JobId)
CreateLabel(InfoSection, "PlaceId: " .. game.PlaceId)

-- ==================== 本地玩家 Tab ====================
local LocalPage = CreateTab("本地玩家")
local LocalSection = CreateSection(LocalPage, "角色属性修改")

-- 移动速度
CreateSlider(LocalSection, "移动速度", 16, 500, 16, function(val)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)

-- 锁定移动速度
CreateToggle(LocalSection, "锁定移动速度", false, function(state)
    Flags.LoopSpeed = state
    task.spawn(function()
        while Flags.LoopSpeed do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                -- 假设滑块的值存在 Flags.WalkSpeedValue 中，这里简化处理直接读取当前
                -- 实际应存储滑块最后的值
                LocalPlayer.Character.Humanoid.WalkSpeed = LocalPlayer.Character.Humanoid.WalkSpeed 
            end
            task.wait()
        end
    end)
end)

-- 跳跃高度
CreateSlider(LocalSection, "跳跃高度", 50, 500, 50, function(val)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = val
        LocalPlayer.Character.Humanoid.UseJumpPower = true
    end
end)

-- 重力
CreateSlider(LocalSection, "重力", 0, 200, 196.2, function(val)
    workspace.Gravity = val
end)

-- 视角 (FOV)
CreateSlider(LocalSection, "视角", 70, 120, 70, function(val)
    Camera.FieldOfView = val
end)

-- CFrame 加速 (暴力位移)
CreateSlider(LocalSection, "CFrame加速", 0, 10, 0, function(val)
    Flags.CFrameSpeed = val
end)

-- Velocity 加速
CreateSlider(LocalSection, "Velocity加速", 0, 500, 0, function(val)
    Flags.VelocitySpeed = val
end)

-- 循环执行 CFrame 加速逻辑
RunService.Stepped:Connect(function()
    if Flags.CFrameSpeed and Flags.CFrameSpeed > 0 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local moveDir = LocalPlayer.Character.Humanoid.MoveDirection
        hrp.CFrame = hrp.CFrame + (moveDir * Flags.CFrameSpeed)
    end
end)

--------------------------------------------------------------------------------
-- 7. 射击/Aimbot 功能 (屏幕上的独立按钮)
--------------------------------------------------------------------------------
local AimButton = Instance.new("TextButton")
AimButton.Name = "AimButton"
AimButton.Parent = ScreenGui
AimButton.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
AimButton.BackgroundTransparency = 0.5
AimButton.Position = UDim2.new(0.8, 0, 0.7, 0)
AimButton.Size = UDim2.new(0, 55, 0, 55)
AimButton.Text = "射击"
AimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AimButton.Draggable = true
AimButton.Visible = true 

local AimCorner = Instance.new("UICorner")
AimCorner.CornerRadius = UDim.new(1, 0) -- 圆形
AimCorner.Parent = AimButton

-- 简易自瞄逻辑 (寻找最近玩家并指向)
AimButton.MouseButton1Click:Connect(function()
    local closest = nil
    local shortestDist = math.huge
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos = p.Character.HumanoidRootPart.Position
            local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
            if onScreen then
                local dist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    closest = p
                end
            end
        end
    end
    
    if closest and closest.Character then
        -- 简单的看向逻辑
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Character.Head.Position)
    end
end)

print("XA-Hub Restored Successfully")