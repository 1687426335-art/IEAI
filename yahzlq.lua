-- ===== wdfex 圣奥里传送 =====

-- 基础服务定义
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local CurrentCamera = Workspace.CurrentCamera

-- ===== 创建UI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "wdfexUI"
ScreenGui.Parent = CoreGui
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 100

-- 暗化背景
local BackgroundOverlay = Instance.new("Frame")
BackgroundOverlay.Parent = ScreenGui
BackgroundOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BackgroundOverlay.BackgroundTransparency = 0.7
BackgroundOverlay.Size = UDim2.new(1, 0, 1, 0)
BackgroundOverlay.ZIndex = 1

-- ========== 主窗口 ==========
local MainWin = Instance.new("Frame")
MainWin.Parent = ScreenGui
MainWin.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainWin.Position = UDim2.new(0.5, -150, 0.5, -130)
MainWin.Size = UDim2.new(0, 300, 0, 260)
MainWin.ZIndex = 2
MainWin.Active = true
MainWin.Selectable = true

local WinCorner = Instance.new("UICorner")
WinCorner.Parent = MainWin
WinCorner.CornerRadius = UDim.new(0, 12)

local WinGlow = Instance.new("UIStroke")
WinGlow.Parent = MainWin
WinGlow.Color = Color3.fromRGB(90, 90, 90)
WinGlow.Thickness = 1.5
WinGlow.Transparency = 0.7

-- ========== 标题栏 ==========
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainWin
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.ZIndex = 3
TitleBar.Active = true
TitleBar.Selectable = true

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.Parent = TitleBar
TitleBarCorner.CornerRadius = UDim.new(0, 12, 0, 0)

-- 状态指示灯
local StatusLight = Instance.new("Frame")
StatusLight.Parent = TitleBar
StatusLight.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
StatusLight.Position = UDim2.new(0, 8, 0.5, -4)
StatusLight.Size = UDim2.new(0, 8, 0, 8)
StatusLight.ZIndex = 4

local StatusCorner = Instance.new("UICorner")
StatusCorner.Parent = StatusLight
StatusCorner.CornerRadius = UDim.new(1, 0)

local StatusText = Instance.new("TextLabel")
StatusText.Parent = TitleBar
StatusText.BackgroundTransparency = 1
StatusText.Position = UDim2.new(0, 20, 0.5, -6)
StatusText.Size = UDim2.new(0, 50, 0, 10)
StatusText.Font = Enum.Font.GothamMedium
StatusText.Text = "未验证"
StatusText.TextColor3 = Color3.fromRGB(255, 150, 150)
StatusText.TextSize = 9
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.ZIndex = 4

-- 标题装饰线
local TitleAccent = Instance.new("Frame")
TitleAccent.Parent = TitleBar
TitleAccent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TitleAccent.Position = UDim2.new(0, 0, 1, -1)
TitleAccent.Size = UDim2.new(1, 0, 0, 1)
TitleAccent.ZIndex = 4

-- 标题文字
local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Font = Enum.Font.GothamBlack
Title.Text = "wdfex-圣奥里"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.TextYAlignment = Enum.TextYAlignment.Center
Title.ZIndex = 4

-- 副标题
local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = TitleBar
SubTitle.BackgroundTransparency = 1
SubTitle.Position = UDim2.new(0, 0, 0, 25)
SubTitle.Size = UDim2.new(1, 0, 0, 12)
SubTitle.Font = Enum.Font.Gotham
SubTitle.Text = "卡密验证系统"
SubTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
SubTitle.TextSize = 10
SubTitle.TextXAlignment = Enum.TextXAlignment.Center
SubTitle.ZIndex = 4

-- ========== 警告卡片 ==========
local WarningCard = Instance.new("Frame")
WarningCard.Parent = MainWin
WarningCard.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
WarningCard.Position = UDim2.new(0.5, -135, 0, 45)
WarningCard.Size = UDim2.new(0, 270, 0, 35)
WarningCard.ZIndex = 3

local WarningCorner = Instance.new("UICorner")
WarningCorner.Parent = WarningCard
WarningCorner.CornerRadius = UDim.new(0, 6)

local WarningStroke = Instance.new("UIStroke")
WarningStroke.Parent = WarningCard
WarningStroke.Color = Color3.fromRGB(255, 110, 110)
WarningStroke.Thickness = 1
WarningStroke.Transparency = 0.2

local WarningIcon = Instance.new("TextLabel")
WarningIcon.Parent = WarningCard
WarningIcon.BackgroundTransparency = 1
WarningIcon.Position = UDim2.new(0, 8, 0, 8)
WarningIcon.Size = UDim2.new(0, 18, 0, 18)
WarningIcon.Font = Enum.Font.GothamBold
WarningIcon.Text = "⚠"
WarningIcon.TextColor3 = Color3.fromRGB(255, 110, 110)
WarningIcon.TextSize = 14
WarningIcon.TextYAlignment = Enum.TextYAlignment.Center
WarningIcon.ZIndex = 4

local WarningText = Instance.new("TextLabel")
WarningText.Parent = WarningCard
WarningText.BackgroundTransparency = 1
WarningText.Position = UDim2.new(0, 30, 0, 0)
WarningText.Size = UDim2.new(1, -30, 1, 0)
WarningText.Font = Enum.Font.GothamMedium
WarningText.Text = "卡密: 1"
WarningText.TextColor3 = Color3.fromRGB(255, 180, 180)
WarningText.TextSize = 11
WarningText.TextXAlignment = Enum.TextXAlignment.Left
WarningText.TextYAlignment = Enum.TextYAlignment.Center
WarningText.ZIndex = 4

-- ========== 作者QQ卡片 ==========
local GroupCard = Instance.new("Frame")
GroupCard.Parent = MainWin
GroupCard.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
GroupCard.Position = UDim2.new(0.5, -135, 0, 85)
GroupCard.Size = UDim2.new(0, 270, 0, 50)
GroupCard.ZIndex = 3

local GroupCorner = Instance.new("UICorner")
GroupCorner.Parent = GroupCard
GroupCorner.CornerRadius = UDim.new(0, 8)

local GroupGlow = Instance.new("UIStroke")
GroupGlow.Parent = GroupCard
GroupGlow.Color = Color3.fromRGB(80, 120, 200)
GroupGlow.Thickness = 1.5
GroupGlow.Transparency = 0.3

local GroupIcon = Instance.new("TextLabel")
GroupIcon.Parent = GroupCard
GroupIcon.BackgroundTransparency = 1
GroupIcon.Position = UDim2.new(0, 12, 0.5, -12)
GroupIcon.Size = UDim2.new(0, 24, 0, 24)
GroupIcon.Font = Enum.Font.GothamBold
GroupIcon.Text = "👤"
GroupIcon.TextColor3 = Color3.fromRGB(150, 180, 220)
GroupIcon.TextSize = 18
GroupIcon.TextYAlignment = Enum.TextYAlignment.Center
GroupIcon.ZIndex = 4

local GroupLabel = Instance.new("TextLabel")
GroupLabel.Parent = GroupCard
GroupLabel.BackgroundTransparency = 1
GroupLabel.Position = UDim2.new(0, 45, 0, 8)
GroupLabel.Size = UDim2.new(0, 120, 0, 16)
GroupLabel.Font = Enum.Font.GothamBold
GroupLabel.Text = "点击复制作者QQ"
GroupLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
GroupLabel.TextSize = 11
GroupLabel.TextXAlignment = Enum.TextXAlignment.Left
GroupLabel.ZIndex = 4

local GroupNumber = Instance.new("TextLabel")
GroupNumber.Parent = GroupCard
GroupNumber.BackgroundTransparency = 1
GroupNumber.Position = UDim2.new(0, 45, 0, 24)
GroupNumber.Size = UDim2.new(0, 120, 0, 20)
GroupNumber.Font = Enum.Font.GothamBlack
GroupNumber.Text = "1687426335"
GroupNumber.TextColor3 = Color3.fromRGB(255, 255, 255)
GroupNumber.TextSize = 18
GroupNumber.TextXAlignment = Enum.TextXAlignment.Left
GroupNumber.ZIndex = 4

local CopyIcon = Instance.new("TextLabel")
CopyIcon.Parent = GroupCard
CopyIcon.BackgroundTransparency = 1
CopyIcon.Position = UDim2.new(1, -35, 0.5, -12)
CopyIcon.Size = UDim2.new(0, 24, 0, 24)
CopyIcon.Font = Enum.Font.GothamBold
CopyIcon.Text = "📋"
CopyIcon.TextColor3 = Color3.fromRGB(150, 180, 220)
CopyIcon.TextSize = 16
CopyIcon.TextYAlignment = Enum.TextYAlignment.Center
CopyIcon.ZIndex = 4

local CopyButton = Instance.new("TextButton")
CopyButton.Parent = GroupCard
CopyButton.BackgroundTransparency = 1
CopyButton.Size = UDim2.new(1, 0, 1, 0)
CopyButton.Text = ""
CopyButton.ZIndex = 5
CopyButton.AutoButtonColor = false

local CopySuccess = Instance.new("Frame")
CopySuccess.Parent = MainWin
CopySuccess.BackgroundColor3 = Color3.fromRGB(40, 200, 80)
CopySuccess.Position = UDim2.new(0.5, -65, 0, 75)
CopySuccess.Size = UDim2.new(0, 130, 0, 28)
CopySuccess.ZIndex = 10
CopySuccess.Visible = false

local CopySuccessCorner = Instance.new("UICorner")
CopySuccessCorner.Parent = CopySuccess
CopySuccessCorner.CornerRadius = UDim.new(0, 6)

local CopySuccessStroke = Instance.new("UIStroke")
CopySuccessStroke.Parent = CopySuccess
CopySuccessStroke.Color = Color3.fromRGB(255, 255, 255)
CopySuccessStroke.Thickness = 1

local CopySuccessText = Instance.new("TextLabel")
CopySuccessText.Parent = CopySuccess
CopySuccessText.BackgroundTransparency = 1
CopySuccessText.Size = UDim2.new(1, 0, 1, 0)
CopySuccessText.Font = Enum.Font.GothamBold
CopySuccessText.Text = "✓ 已复制"
CopySuccessText.TextColor3 = Color3.fromRGB(255, 255, 255)
CopySuccessText.TextSize = 10
CopySuccessText.TextXAlignment = Enum.TextXAlignment.Center
CopySuccessText.TextYAlignment = Enum.TextYAlignment.Center

-- ========== 白名单提示 ==========
local WhitelistNote = Instance.new("TextLabel")
WhitelistNote.Parent = MainWin
WhitelistNote.BackgroundTransparency = 1
WhitelistNote.Position = UDim2.new(0, 0, 0, 140)
WhitelistNote.Size = UDim2.new(1, 0, 0, 16)
WhitelistNote.Font = Enum.Font.GothamMedium
WhitelistNote.Text = "✨ 卡密: 1"
WhitelistNote.TextColor3 = Color3.fromRGB(255, 200, 80)
WhitelistNote.TextSize = 11
WhitelistNote.TextXAlignment = Enum.TextXAlignment.Center
WhitelistNote.ZIndex = 3

-- ========== 输入框 ==========
local InputContainer = Instance.new("Frame")
InputContainer.Parent = MainWin
InputContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
InputContainer.Position = UDim2.new(0.5, -120, 0, 160)
InputContainer.Size = UDim2.new(0, 240, 0, 36)
InputContainer.ZIndex = 3

local InputContainerCorner = Instance.new("UICorner")
InputContainerCorner.Parent = InputContainer
InputContainerCorner.CornerRadius = UDim.new(0, 8)

local InputContainerStroke = Instance.new("UIStroke")
InputContainerStroke.Parent = InputContainer
InputContainerStroke.Color = Color3.fromRGB(50, 50, 50)
InputContainerStroke.Thickness = 1

local Input = Instance.new("TextBox")
Input.Parent = InputContainer
Input.BackgroundTransparency = 1
Input.Position = UDim2.new(0, 12, 0, 0)
Input.Size = UDim2.new(1, -24, 1, 0)
Input.Font = Enum.Font.Gotham
Input.Text = ""
Input.TextColor3 = Color3.fromRGB(255, 255, 255)
Input.TextSize = 13
Input.PlaceholderText = "请输入卡密..."
Input.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
Input.ClearTextOnFocus = false
Input.ZIndex = 4

local InputIcon = Instance.new("TextLabel")
InputIcon.Parent = InputContainer
InputIcon.BackgroundTransparency = 1
InputIcon.Position = UDim2.new(1, -30, 0.5, -9)
InputIcon.Size = UDim2.new(0, 18, 0, 18)
InputIcon.Font = Enum.Font.GothamBold
InputIcon.Text = "🔑"
InputIcon.TextColor3 = Color3.fromRGB(150, 150, 150)
InputIcon.TextSize = 12
InputIcon.TextYAlignment = Enum.TextYAlignment.Center
InputIcon.ZIndex = 4

local ClearInputButton = Instance.new("TextButton")
ClearInputButton.Parent = InputContainer
ClearInputButton.BackgroundTransparency = 1
ClearInputButton.Position = UDim2.new(1, -50, 0.5, -8)
ClearInputButton.Size = UDim2.new(0, 20, 0, 20)
ClearInputButton.Font = Enum.Font.GothamBold
ClearInputButton.Text = "×"
ClearInputButton.TextColor3 = Color3.fromRGB(120, 120, 120)
ClearInputButton.TextSize = 12
ClearInputButton.Visible = false
ClearInputButton.ZIndex = 4

-- ========== 验证按钮 ==========
local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Parent = MainWin
VerifyBtn.Position = UDim2.new(0.5, -95, 0, 205)
VerifyBtn.Size = UDim2.new(0, 190, 0, 36)
VerifyBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.Text = "验证卡密"
VerifyBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
VerifyBtn.TextSize = 14
VerifyBtn.TextXAlignment = Enum.TextXAlignment.Center
VerifyBtn.BorderSizePixel = 0
VerifyBtn.AutoButtonColor = false
VerifyBtn.ZIndex = 3

local VerifyBtnCorner = Instance.new("UICorner")
VerifyBtnCorner.Parent = VerifyBtn
VerifyBtnCorner.CornerRadius = UDim.new(0, 8)

local VerifyBtnStroke = Instance.new("UIStroke")
VerifyBtnStroke.Parent = VerifyBtn
VerifyBtnStroke.Color = Color3.fromRGB(50, 50, 50)
VerifyBtnStroke.Thickness = 1.5

-- 剩余尝试次数显示
local AttemptsDisplay = Instance.new("TextLabel")
AttemptsDisplay.Parent = MainWin
AttemptsDisplay.BackgroundTransparency = 1
AttemptsDisplay.Position = UDim2.new(0, 0, 1, -35)
AttemptsDisplay.Size = UDim2.new(1, 0, 0, 14)
AttemptsDisplay.Font = Enum.Font.GothamMedium
AttemptsDisplay.Text = "剩余尝试次数: 3/3"
AttemptsDisplay.TextColor3 = Color3.fromRGB(180, 180, 180)
AttemptsDisplay.TextSize = 10
AttemptsDisplay.TextXAlignment = Enum.TextXAlignment.Center
AttemptsDisplay.ZIndex = 3

-- ========== 关闭按钮 ==========
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainWin
CloseBtn.Position = UDim2.new(1, -35, 0, 8)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.TextSize = 18
CloseBtn.TextXAlignment = Enum.TextXAlignment.Center
CloseBtn.BorderSizePixel = 0
CloseBtn.AutoButtonColor = false
CloseBtn.ZIndex = 10

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.Parent = CloseBtn
CloseBtnCorner.CornerRadius = UDim.new(0, 6)

-- ========== 消息提示 ==========
local Msg = Instance.new("TextLabel")
Msg.Parent = MainWin
Msg.BackgroundTransparency = 1
Msg.Position = UDim2.new(0, 0, 1, -20)
Msg.Size = UDim2.new(1, 0, 0, 16)
Msg.Font = Enum.Font.Gotham
Msg.Text = ""
Msg.TextColor3 = Color3.fromRGB(150, 150, 150)
Msg.TextSize = 10
Msg.TextXAlignment = Enum.TextXAlignment.Center
Msg.Visible = false
Msg.ZIndex = 3

-- ========== 触摸区域 ==========
local TouchDragArea = Instance.new("TextButton")
TouchDragArea.Parent = MainWin
TouchDragArea.BackgroundTransparency = 1
TouchDragArea.Size = UDim2.new(1, 0, 0, 60)
TouchDragArea.Text = ""
TouchDragArea.ZIndex = 5
TouchDragArea.AutoButtonColor = false
TouchDragArea.Visible = UserInputService.TouchEnabled

-- ========== 全局变量 ==========
local attempts = 0
local maxAttempts = 3
local copyCooldown = false
local isDragging = false
local dragStart, frameStart
local isMobile = UserInputService.TouchEnabled
local isMouse = UserInputService.MouseEnabled

-- ========== 功能函数 ==========

local function updateAttemptsDisplay()
    AttemptsDisplay.Text = string.format("剩余尝试次数: %d/%d", maxAttempts - attempts, maxAttempts)
end

local function playSound(soundId, volume)
    local sound = Instance.new("Sound")
    sound.Parent = SoundService
    sound.SoundId = soundId
    sound.Volume = volume or 0.5
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 1)
end

local function showMessage(text, color, duration)
    Msg.Text = text
    Msg.TextColor3 = color
    Msg.Visible = true
    
    if duration then
        task.wait(duration)
        Msg.Visible = false
    end
end

local function updateStatus(color, text)
    StatusLight.BackgroundColor3 = color
    StatusText.Text = text
    StatusText.TextColor3 = color
end

-- ========== 传送函数 ==========
local function TeleportTo(pos)
    pcall(function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(pos)
        end
    end)
end

-- ===== 加载主脚本 =====
local function LoadMainScript()
    -- 创建UI库窗口
    local UI_Library_URL = "https://raw.githubusercontent.com/114514lzkill/ui/refs/heads/main/ui.lua"
    local Library = loadstring(game:HttpGet(UI_Library_URL))()
    
    if not Library then
        UI_Library_URL = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/UI.Lua"
        Library = loadstring(game:HttpGet(UI_Library_URL))()
    end
    
    local Window = Library:CreateWindow({
        ["Folder"] = "wdfexHub",
        ["Title"] = "wdfex-圣奥里",
        ["Author"] = "wdfex",
        ["Icon"] = "rbxassetid://7734068321",
        HideSearchBar = false,
    })
    
    -- ========== Tab: 公告 ==========
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
    
    -- ========== Tab: 通用 ==========
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
            LocalPlayer.Idled:Connect(function()
                VirtualUser:Button2Down(Vector2.new(0, 0), CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0, 0), CurrentCamera.CFrame)
            end)
            StarterGui:SetCore("SendNotification", {
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
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.JumpPower = jump
            end
        end
    })
    
    Tab_General:Button({
        ["Title"] = "帧率显示",
        ["Desc"] = "显示FPS",
        ["Callback"] = function()
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
    
    -- ========== Tab: 地点传送 ==========
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
    
    for _, loc in ipairs(locationPoints) do
        Tab_LocationTeleport:Button({
            ["Title"] = loc[1],
            ["Desc"] = "传送至" .. loc[1],
            ["Callback"] = function()
                TeleportTo(loc[2])
                StarterGui:SetCore("SendNotification", {
                    Title = "地点传送",
                    Text = "已传送到 " .. loc[1],
                    Duration = 2,
                })
            end
        })
    end
    
    -- ========== Tab: 售货机传送区 ==========
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
    
    -- ========== Tab: 外卖员 ==========
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
    
    -- ========== Tab: 出租车 ==========
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
    
    -- ========== Tab: 透视 ==========
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
    
    -- ========== Tab: 标点传送 ==========
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
                StarterGui:SetCore("SendNotification", {
                    Title = "标点传送",
                    Text = "已传送到标点位置",
                    Duration = 2,
                })
            else
                StarterGui:SetCore("SendNotification", {
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
    
    -- ========== Tab: 甩飞 ==========
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
            for _, x in next, Players:GetPlayers() do
                if x ~= LocalPlayer then
                    SkidFling(x)
                end
            end
        end
    })
    
    -- ========== Tab: 范围 ==========
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
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= LocalPlayer then
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
    
    -- ========== Tab: 车辆功能 ==========
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
    
    -- ========== Tab: 枪械功能 ==========
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
    
    -- ========== Tab: 杀戮光环 ==========
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
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            local RunService = game:GetService("RunService")
            local Debris = game:GetService("Debris")

            local loopConnection = nil
            local selectedSoundId = "rbxassetid://8679627751"
            local AURA_RANGE = 90

            local function GetHitFunction()
                local char = LocalPlayer.Character
                if not char then return nil end
                for _, tool in ipairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        local remotes = tool:FindFirstChild("Remotes")
                        if remotes then
                            local hitFunc = remotes:FindFirstChild("HitFunction")
                            if hitFunc then
                                return hitFunc
                            end
                        end
                    end
                end
                return nil
            end

            local function GetEnemiesInRange()
                local enemies = {}
                local myChar = LocalPlayer.Character
                if not myChar then return enemies end
                local myHrp = myChar:FindFirstChild("HumanoidRootPart")
                if not myHrp then return enemies end
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character.Parent then
                        local humanoid = player.Character:FindFirstChild("Humanoid")
                        if humanoid and humanoid.Health > 0 then
                            local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
                            if targetHrp then
                                local dist = (myHrp.Position - targetHrp.Position).Magnitude
                                if dist <= AURA_RANGE then
                                    table.insert(enemies, player)
                                end
                            end
                        end
                    end
                end
                return enemies
            end

            local hue = 0
            local function GetRainbowColor()
                hue = (hue + 0.02) % 1
                return Color3.fromHSV(hue, 1, 1)
            end

            local function DrawTrajectory(origin, targetPos)
                local color = GetRainbowColor()
                local part = Instance.new("Part")
                part.Anchored = true
                part.CanCollide = false
                part.Material = Enum.Material.Neon
                part.Color = color
                local distance = (origin - targetPos).Magnitude
                if distance < 0.1 then return end
                part.Size = Vector3.new(0.1, 0.1, distance)
                part.CFrame = CFrame.lookAt(origin, targetPos) * CFrame.new(0, 0, -distance / 2)
                part.Parent = workspace
                Debris:AddItem(part, 0.3)
            end

            local function PlayShootSound()
                local sound = Instance.new("Sound")
                sound.SoundId = selectedSoundId
                sound.Volume = 1
                sound.Parent = LocalPlayer.Character or workspace
                sound:Play()
                task.delay(1, function() sound:Destroy() end)
            end

            local function AttackEnemy(targetPlayer, hitFunction)
                local targetChar = targetPlayer.Character
                if not targetChar then return end
                local hitPart = targetChar:FindFirstChild("Left Arm") or targetChar:FindFirstChild("Right Arm") or targetChar:FindFirstChild("Head") or targetChar:FindFirstChild("HumanoidRootPart")
                if not hitPart then return end
                local myChar = LocalPlayer.Character
                if not myChar then return end
                local myHrp = myChar:FindFirstChild("HumanoidRootPart")
                if not myHrp then return end
                local origin = myHrp.Position
                local targetPos = hitPart.Position
                DrawTrajectory(origin, targetPos)
                PlayShootSound()
                local args = {
                    targetChar,
                    hitPart,
                    Vector3.new(1, 2, 1)
                }
                pcall(function()
                    hitFunction:InvokeServer(unpack(args))
                end)
            end

            local function KillAuraLoop()
                local hitFunction = GetHitFunction()
                if not hitFunction then return end
                local enemies = GetEnemiesInRange()
                for _, enemy in ipairs(enemies) do
                    task.spawn(AttackEnemy, enemy, hitFunction)
                    task.wait(0.03)
                end
            end

            LocalPlayer.CharacterAdded:Connect(function()
                task.wait(0.5)
                print("1")
            end)
            loopConnection = RunService.Heartbeat:Connect(KillAuraLoop)
        end
    })
    
    -- ========== Tab: 警察显示 ==========
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
        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            if IsPlayerPolice(player) then
                count = count + 1
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
                policeGui.Parent = CoreGui
                
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
                
                Players.PlayerAdded:Connect(function()
                    if policeDisplayEnabled then UpdatePoliceCount() end
                end)
                Players.PlayerRemoving:Connect(function()
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
    
    -- ========== Tab: 设置 ==========
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
                local frosty = CoreGui:FindFirstChild("frosty")
                if frosty then frosty:Destroy() end
                local eggGui = CoreGui:FindFirstChild("EasterEggGui")
                if eggGui then eggGui:Destroy() end
                local welcomeGui = CoreGui:FindFirstChild("wdfexWelcome")
                if welcomeGui then welcomeGui:Destroy() end
                local borderGui = CoreGui:FindFirstChild("wdfexBorder")
                if borderGui then borderGui:Destroy() end
                local hubGui = CoreGui:FindFirstChild("wdfexHub")
                if hubGui then hubGui:Destroy() end
                local policeGui = CoreGui:FindFirstChild("PoliceDisplay")
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
                    eggSound.Parent = CoreGui
                    eggSound:Play()
                    eggPlaying = true
                    
                    eggSound.Ended:Connect(function()
                        eggPlaying = false
                    end)
                end)
                
                pcall(function()
                    local eggGui = Instance.new("ScreenGui")
                    eggGui.Name = "EasterEggGui"
                    eggGui.Parent = CoreGui
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
                    local eggGui = CoreGui:FindFirstChild("EasterEggGui")
                    if eggGui then eggGui:Destroy() end
                end)
            end
        end
    })
    
    print("wdfex-圣奥里已加载")
    print("所有功能已恢复")
end

-- ========== 输入框交互 ==========
Input.Focused:Connect(function()
    InputContainerStroke.Color = Color3.fromRGB(255, 255, 255)
    TweenService:Create(InputContainer, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    }):Play()
    TweenService:Create(InputIcon, TweenInfo.new(0.2), {
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
    
    if #Input.Text > 0 then
        ClearInputButton.Visible = true
    end
end)

Input.FocusLost:Connect(function()
    InputContainerStroke.Color = Color3.fromRGB(50, 50, 50)
    TweenService:Create(InputContainer, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    }):Play()
    TweenService:Create(InputIcon, TweenInfo.new(0.2), {
        TextColor3 = Color3.fromRGB(150, 150, 150)
    }):Play()
    
    ClearInputButton.Visible = false
end)

Input:GetPropertyChangedSignal("Text"):Connect(function()
    ClearInputButton.Visible = #Input.Text > 0
end)

ClearInputButton.MouseEnter:Connect(function()
    TweenService:Create(ClearInputButton, TweenInfo.new(0.2), {
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
end)

ClearInputButton.MouseLeave:Connect(function()
    TweenService:Create(ClearInputButton, TweenInfo.new(0.2), {
        TextColor3 = Color3.fromRGB(120, 120, 120)
    }):Play()
end)

ClearInputButton.MouseButton1Click:Connect(function()
    Input.Text = ""
    Input:CaptureFocus()
    playSound("rbxassetid://62339698", 0.3)
end)

-- ========== 按钮交互 ==========
local btnHovering = false

VerifyBtn.MouseEnter:Connect(function()
    btnHovering = true
    TweenService:Create(VerifyBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(245, 245, 245)
    }):Play()
    TweenService:Create(VerifyBtnStroke, TweenInfo.new(0.2), {
        Color = Color3.fromRGB(75, 75, 75)
    }):Play()
end)

VerifyBtn.MouseLeave:Connect(function()
    btnHovering = false
    TweenService:Create(VerifyBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
    TweenService:Create(VerifyBtnStroke, TweenInfo.new(0.2), {
        Color = Color3.fromRGB(50, 50, 50)
    }):Play()
end)

VerifyBtn.MouseButton1Down:Connect(function()
    TweenService:Create(VerifyBtn, TweenInfo.new(0.1), {
        BackgroundColor3 = Color3.fromRGB(225, 225, 225),
        Size = UDim2.new(0, 185, 0, 34)
    }):Play()
    playSound("rbxassetid://62339698", 0.2)
end)

VerifyBtn.MouseButton1Up:Connect(function()
    TweenService:Create(VerifyBtn, TweenInfo.new(0.1), {
        BackgroundColor3 = btnHovering and Color3.fromRGB(245, 245, 245) or Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0, 190, 0, 36)
    }):Play()
end)

-- ========== 关闭按钮交互 ==========
CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(55, 55, 55),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
end)

CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        TextColor3 = Color3.fromRGB(200, 200, 200)
    }):Play()
end)

-- ========== 复制功能交互 ==========
local isCopyHovering = false

CopyButton.MouseEnter:Connect(function()
    isCopyHovering = true
    if not copyCooldown then
        TweenService:Create(GroupCard, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(30, 35, 55),
            Size = UDim2.new(0, 275, 0, 52)
        }):Play()
        TweenService:Create(GroupGlow, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(120, 160, 240),
            Thickness = 2,
            Transparency = 0.2
        }):Play()
        TweenService:Create(GroupIcon, TweenInfo.new(0.2), {
            TextColor3 = Color3.fromRGB(190, 210, 245)
        }):Play()
        TweenService:Create(CopyIcon, TweenInfo.new(0.2), {
            TextColor3 = Color3.fromRGB(190, 210, 245)
        }):Play()
        TweenService:Create(GroupNumber, TweenInfo.new(0.2), {
            TextColor3 = Color3.fromRGB(255, 255, 230)
        }):Play()
    end
end)

CopyButton.MouseLeave:Connect(function()
    isCopyHovering = false
    if not copyCooldown then
        TweenService:Create(GroupCard, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(20, 25, 40),
            Size = UDim2.new(0, 270, 0, 50)
        }):Play()
        TweenService:Create(GroupGlow, TweenInfo.new(0.3), {
            Color = Color3.fromRGB(80, 120, 200),
            Thickness = 1.5,
            Transparency = 0.3
        }):Play()
        TweenService:Create(GroupIcon, TweenInfo.new(0.3), {
            TextColor3 = Color3.fromRGB(150, 180, 220)
        }):Play()
        TweenService:Create(CopyIcon, TweenInfo.new(0.3), {
            TextColor3 = Color3.fromRGB(150, 180, 220)
        }):Play()
        TweenService:Create(GroupNumber, TweenInfo.new(0.3), {
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    end
end)

CopyButton.MouseButton1Down:Connect(function()
    if not copyCooldown then
        TweenService:Create(GroupCard, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(15, 20, 35),
            Size = UDim2.new(0, 265, 0, 48)
        }):Play()
        TweenService:Create(GroupGlow, TweenInfo.new(0.1), {
            Color = Color3.fromRGB(150, 190, 255),
            Thickness = 2.2
        }):Play()
        playSound("rbxassetid://62339698", 0.2)
    end
end)

CopyButton.MouseButton1Up:Connect(function()
    if not copyCooldown then
        TweenService:Create(GroupCard, TweenInfo.new(0.1), {
            Size = UDim2.new(0, 270, 0, 50),
            BackgroundColor3 = isCopyHovering and Color3.fromRGB(30, 35, 55) or Color3.fromRGB(20, 25, 40)
        }):Play()
        TweenService:Create(GroupGlow, TweenInfo.new(0.1), {
            Color = isCopyHovering and Color3.fromRGB(120, 160, 240) or Color3.fromRGB(80, 120, 200),
            Thickness = 1.5
        }):Play()
    end
end)

CopyButton.MouseButton1Click:Connect(function()
    if copyCooldown then return end
    
    copyCooldown = true
    
    playSound("rbxassetid://62339698", 0.5)
    
    local authorQQ = "1687426335"
    pcall(function()
        setclipboard(authorQQ)
    end)
    
    CopyIcon.Text = "✓"
    TweenService:Create(CopyIcon, TweenInfo.new(0.2), {
        TextColor3 = Color3.fromRGB(80, 255, 80),
        TextSize = 18
    }):Play()
    
    TweenService:Create(GroupNumber, TweenInfo.new(0.2), {
        TextColor3 = Color3.fromRGB(80, 255, 80)
    }):Play()
    
    CopySuccess.Visible = true
    CopySuccess.Position = UDim2.new(0.5, -65, 0, 75)
    
    local successTween = TweenService:Create(CopySuccess, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -65, 0, 70)
    })
    successTween:Play()
    
    for i = 1, 2 do
        TweenService:Create(GroupCard, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(30, 55, 30)
        }):Play()
        TweenService:Create(GroupGlow, TweenInfo.new(0.1), {
            Color = Color3.fromRGB(100, 255, 100)
        }):Play()
        task.wait(0.1)
        TweenService:Create(GroupCard, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(20, 25, 40)
        }):Play()
        TweenService:Create(GroupGlow, TweenInfo.new(0.1), {
            Color = Color3.fromRGB(80, 120, 200)
        }):Play()
        task.wait(0.1)
    end
    
    task.wait(1.5)
    
    local hideTween = TweenService:Create(CopySuccess, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, -65, 0, 75)
    })
    hideTween:Play()
    hideTween.Completed:Wait()
    CopySuccess.Visible = false
    
    task.wait(0.5)
    
    CopyIcon.Text = "📋"
    TweenService:Create(CopyIcon, TweenInfo.new(0.3), {
        TextColor3 = Color3.fromRGB(150, 180, 220),
        TextSize = 16
    }):Play()
    
    TweenService:Create(GroupNumber, TweenInfo.new(0.3), {
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
    
    showMessage("✅ 作者QQ已复制到剪贴板", Color3.fromRGB(80, 255, 80), 2)
    
    task.wait(1)
    copyCooldown = false
end)

-- ========== 拖动功能 ==========
local function startDrag(input)
    if (isMouse and input.UserInputType == Enum.UserInputType.MouseButton1) or
       (isMobile and input.UserInputType == Enum.UserInputType.Touch) then
        isDragging = true
        dragStart = input.Position
        frameStart = MainWin.Position
        
        TweenService:Create(TitleBar, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        }):Play()
        TweenService:Create(TitleAccent, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(220, 220, 220)
        }):Play()
        
        showMessage("拖动中...", Color3.fromRGB(200, 200, 200))
    end
end

local function endDrag()
    if isDragging then
        isDragging = false
        
        TweenService:Create(TitleBar, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        }):Play()
        TweenService:Create(TitleAccent, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        
        Msg.Visible = false
    end
end

if isMobile then
    TouchDragArea.InputBegan:Connect(startDrag)
else
    TitleBar.InputBegan:Connect(startDrag)
end

UserInputService.InputChanged:Connect(function(input)
    if isDragging then
        local delta = input.Position - dragStart
        local newX = frameStart.X.Offset + delta.X
        local newY = frameStart.Y.Offset + delta.Y
        
        local screenWidth = workspace.CurrentCamera.ViewportSize.X
        local screenHeight = workspace.CurrentCamera.ViewportSize.Y
        
        newX = math.clamp(newX, 0, screenWidth - MainWin.Size.X.Offset)
        newY = math.clamp(newY, 0, screenHeight - MainWin.Size.Y.Offset)
        
        MainWin.Position = UDim2.new(0, newX, 0, newY)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if isDragging and ((isMouse and input.UserInputType == Enum.UserInputType.MouseButton1) or
                      (isMobile and input.UserInputType == Enum.UserInputType.Touch)) then
        endDrag()
    end
end)

-- ========== 关闭功能 ==========
CloseBtn.MouseButton1Click:Connect(function()
    playSound("rbxassetid://62339698", 0.3)
    
    local exitTween = TweenService:Create(MainWin, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1
    })
    exitTween:Play()
    exitTween.Completed:Wait()
    ScreenGui:Destroy()
end)

-- ========== 验证功能 ==========
VerifyBtn.MouseButton1Click:Connect(function()
    local key = Input.Text
    
    if #key == 0 then
        showMessage("请输入卡密", Color3.fromRGB(255, 180, 80), 1.5)
        
        for i = 1, 3 do
            InputContainer.Position = UDim2.new(0.5, -120 + (i % 2 == 1 and 3 or -3), 0, 160)
            task.wait(0.05)
        end
        InputContainer.Position = UDim2.new(0.5, -120, 0, 160)
        return
    end
    
    if key == "1" then
        -- 验证成功
        updateStatus(Color3.fromRGB(80, 255, 80), "已验证")
        showMessage("✓ 验证成功，正在启动脚本...", Color3.fromRGB(80, 255, 80))
        
        TweenService:Create(VerifyBtn, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(80, 255, 80),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        
        TweenService:Create(VerifyBtnStroke, TweenInfo.new(0.3), {
            Color = Color3.fromRGB(80, 255, 80)
        }):Play()
        
        TweenService:Create(WinGlow, TweenInfo.new(0.3), {
            Color = Color3.fromRGB(80, 255, 80),
            Thickness = 2
        }):Play()
        
        playSound("rbxassetid://62339698", 0.6)
        
        task.wait(1.2)
        
        local exitTween = TweenService:Create(MainWin, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        })
        exitTween:Play()
        exitTween.Completed:Wait()
        
        ScreenGui:Destroy()
        
        -- 加载主脚本
        LoadMainScript()
        
        return
    else
        -- 验证失败
        attempts = attempts + 1
        updateAttemptsDisplay()
        
        showMessage(string.format("验证失败 (%d/%d)", attempts, maxAttempts), Color3.fromRGB(255, 110, 110))
        
        TweenService:Create(VerifyBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 110, 110),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        
        TweenService:Create(VerifyBtnStroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(255, 110, 110)
        }):Play()
        
        playSound("rbxassetid://62339698", 0.3)
        
        for i = 1, 3 do
            InputContainer.Position = UDim2.new(0.5, -120 + (i % 2 == 1 and 4 or -4), 0, 160)
            task.wait(0.05)
        end
        InputContainer.Position = UDim2.new(0.5, -120, 0, 160)
        
        for i = 1, 2 do
            WarningStroke.Color = Color3.fromRGB(255, 80, 80)
            task.wait(0.1)
            WarningStroke.Color = Color3.fromRGB(255, 110, 110)
            task.wait(0.1)
        end
        
        task.wait(0.5)
        
        if attempts >= maxAttempts then
            updateStatus(Color3.fromRGB(255, 80, 80), "已锁定")
            showMessage("❌ 验证次数过多，UI将在3秒后关闭", Color3.fromRGB(255, 80, 80))
            
            VerifyBtn.AutoButtonColor = false
            VerifyBtn.Active = false
            Input.TextEditable = false
            
            task.wait(3)
            
            local exitTween = TweenService:Create(MainWin, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                BackgroundTransparency = 1
            })
            exitTween:Play()
            exitTween.Completed:Wait()
            ScreenGui:Destroy()
        else
            if btnHovering then
                TweenService:Create(VerifyBtn, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(245, 245, 245),
                    TextColor3 = Color3.fromRGB(0, 0, 0)
                }):Play()
                TweenService:Create(VerifyBtnStroke, TweenInfo.new(0.2), {
                    Color = Color3.fromRGB(75, 75, 75)
                }):Play()
            else
                TweenService:Create(VerifyBtn, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    TextColor3 = Color3.fromRGB(0, 0, 0)
                }):Play()
                TweenService:Create(VerifyBtnStroke, TweenInfo.new(0.2), {
                    Color = Color3.fromRGB(50, 50, 50)
                }):Play()
            end
            
            Input.Text = ""
        end
    end
end)

-- ========== 快捷键功能 ==========
Input.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        VerifyBtn.MouseButton1Click:Fire()
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Escape then
        CloseBtn.MouseButton1Click:Fire()
    end
    
    if input.KeyCode == Enum.KeyCode.F5 then
        if attempts < maxAttempts then
            attempts = 0
            updateAttemptsDisplay()
            updateStatus(Color3.fromRGB(255, 100, 100), "未验证")
            VerifyBtn.AutoButtonColor = true
            VerifyBtn.Active = true
            Input.TextEditable = true
            
            showMessage("重置验证次数", Color3.fromRGB(100, 200, 255), 1.5)
            playSound("rbxassetid://62339698", 0.3)
        end
    end
end)

-- ========== 输入限制 ==========
Input:GetPropertyChangedSignal("Text"):Connect(function()
    if #Input.Text > 100 then
        Input.Text = string.sub(Input.Text, 1, 100)
        showMessage("输入过长，已自动截断", Color3.fromRGB(255, 160, 60), 1.5)
    end
end)

-- ========== 入场动画 ==========
MainWin.Size = UDim2.new(0, 0, 0, 0)
MainWin.Position = UDim2.new(0.5, 0, 0.5, 0)
MainWin.BackgroundTransparency = 1

local entranceTween = TweenService:Create(MainWin, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 300, 0, 260),
    Position = UDim2.new(0.5, -150, 0.5, -130),
    BackgroundTransparency = 0
})
entranceTween:Play()

-- ========== 动态效果 ==========
coroutine.wrap(function()
    while WinGlow.Parent do
        TweenService:Create(WinGlow, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true), {
            Transparency = 0.8
        }):Play()
        task.wait(2)
    end
end)()

coroutine.wrap(function()
    while VerifyBtnStroke.Parent do
        TweenService:Create(VerifyBtnStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true), {
            Transparency = 0.5
        }):Play()
        task.wait(1.5)
    end
end)()

coroutine.wrap(function()
    while StatusLight.Parent do
        TweenService:Create(StatusLight, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true), {
            BackgroundTransparency = 0.3
        }):Play()
        task.wait(1)
    end
end)()

-- ========== 移动端优化 ==========
if isMobile then
    local function onTextFieldFocused()
        TweenService:Create(MainWin, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0.5, -150, 0, 50)
        }):Play()
    end
    
    local function onTextFieldFocusLost()
        TweenService:Create(MainWin, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0.5, -150, 0.5, -130)
        }):Play()
    end
    
    Input.Focused:Connect(onTextFieldFocused)
    Input.FocusLost:Connect(onTextFieldFocusLost)
    
    local lastTapTime = 0
    local doubleTapThreshold = 0.3
    
    TouchDragArea.MouseButton1Click:Connect(function()
        local currentTime = tick()
        if currentTime - lastTapTime < doubleTapThreshold then
            CloseBtn.MouseButton1Click:Fire()
        end
        lastTapTime = currentTime
    end)
end

-- 初始化
updateAttemptsDisplay()
updateStatus(Color3.fromRGB(255, 100, 100), "未验证")

print("wdfex-圣奥里 UI已加载")
print("卡密: 1")
print("作者QQ: 1687426335")