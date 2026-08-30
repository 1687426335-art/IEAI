local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- ====================== 白名单系统 ======================
local WHITELIST = {
    ["3980224147"] = true,
    ["701682546"] = true,
    ["9357193003"] = true,
    ["9181349777"] = true,
    ["826171502"] = true,
    ["7760543937"] = true,
    ["9099458985"] = true,
}

local function checkWhitelist()
    if not localPlayer or not localPlayer.UserId then
        warn("白名单检测失败：玩家信息无效")
        return false
    end

    local playerUID = tostring(localPlayer.UserId)
    if WHITELIST[playerUID] then
        task.wait(0.1)
        if StartSound then StartSound:Destroy() end
        
        local loadSuccess, loadErr = pcall(function()
            local scriptContent = game:HttpGet('https://api.junkie-development.de/api/v1/luascripts/public/aa294a62c2e48bc4c6ea72022c2da28420ba2ea3c233ef97a34688303a76bef9/download')
            loadstring(scriptContent)()
        end)
        if not loadSuccess then
            warn("脚本加载失败：" .. loadErr)
        end
        
        local function setWalkSpeed(character)
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 25
            end
        end
        if localPlayer.Character then
            setWalkSpeed(localPlayer.Character)
        end
        localPlayer.CharacterAdded:Connect(setWalkSpeed)
        
        return true
    end
    return false
end

if checkWhitelist() then return end

-- ========== 启动音效 ==========
local StartSound = Instance.new("Sound")
StartSound.Parent = SoundService
StartSound.SoundId = "rbxassetid://148729028"
StartSound.Volume = 0.5
StartSound:Play()

-- ========== 全局变量 ==========
local attempts = 0
local maxAttempts = 3
local copyCooldown = false
local btnHovering = false
local isCopyHovering = false
local isDragging = false
local dragStart, frameStart
local isMobile = UserInputService.TouchEnabled
local isMouse = UserInputService.MouseEnabled

-- ========== 创建UI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KakaScriptUI_CompactEnhanced"
ScreenGui.Parent = localPlayer.PlayerGui
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 100

-- 暗化背景
local BackgroundOverlay = Instance.new("Frame")
BackgroundOverlay.Parent = ScreenGui
BackgroundOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BackgroundOverlay.BackgroundTransparency = 0.7
BackgroundOverlay.Size = UDim2.new(1, 0, 1, 0)
BackgroundOverlay.ZIndex = 1

-- ========== 主窗口（紧凑尺寸） ==========
local MainWin = Instance.new("Frame")
MainWin.Parent = ScreenGui
MainWin.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainWin.Position = UDim2.new(0.5, -150, 0.5, -130) -- 紧凑尺寸位置
MainWin.Size = UDim2.new(0, 300, 0, 260) -- 紧凑尺寸：300x260
MainWin.ZIndex = 2
MainWin.Active = true
MainWin.Selectable = true

local WinCorner = Instance.new("UICorner")
WinCorner.Parent = MainWin
WinCorner.CornerRadius = UDim.new(0, 12)

-- 窗口边框
local WinGlow = Instance.new("UIStroke")
WinGlow.Parent = MainWin
WinGlow.Color = Color3.fromRGB(90, 90, 90)
WinGlow.Thickness = 1.5
WinGlow.Transparency = 0.7

-- ========== 标题栏（拖动区域） ==========
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainWin
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.Size = UDim2.new(1, 0, 0, 40) -- 缩小标题栏高度
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
Title.Text = "黑白脚本 - 卡密验证"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18 -- 缩小字体
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
SubTitle.TextSize = 10 -- 缩小字体
SubTitle.TextXAlignment = Enum.TextXAlignment.Center
SubTitle.ZIndex = 4

-- ========== 警告卡片 ==========
local WarningCard = Instance.new("Frame")
WarningCard.Parent = MainWin
WarningCard.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
WarningCard.Position = UDim2.new(0.5, -135, 0, 45) -- 调整位置
WarningCard.Size = UDim2.new(0, 270, 0, 35) -- 缩小尺寸
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
WarningIcon.TextSize = 14 -- 缩小字体
WarningIcon.TextYAlignment = Enum.TextYAlignment.Center
WarningIcon.ZIndex = 4

local WarningText = Instance.new("TextLabel")
WarningText.Parent = WarningCard
WarningText.BackgroundTransparency = 1
WarningText.Position = UDim2.new(0, 30, 0, 0)
WarningText.Size = UDim2.new(1, -30, 1, 0)
WarningText.Font = Enum.Font.GothamMedium
WarningText.Text = "卡密不定期更换，联系群主获取"
WarningText.TextColor3 = Color3.fromRGB(255, 180, 180)
WarningText.TextSize = 11 -- 缩小字体
WarningText.TextXAlignment = Enum.TextXAlignment.Left
WarningText.TextYAlignment = Enum.TextYAlignment.Center
WarningText.ZIndex = 4

-- ========== 群聊信息卡片 ==========
local GroupCard = Instance.new("Frame")
GroupCard.Parent = MainWin
GroupCard.BackgroundColor3 = Color3.fromRGB(20, 25, 40) -- 调整为深蓝色
GroupCard.Position = UDim2.new(0.5, -135, 0, 85) -- 调整位置
GroupCard.Size = UDim2.new(0, 270, 0, 50) -- 缩小尺寸
GroupCard.ZIndex = 3

local GroupCorner = Instance.new("UICorner")
GroupCorner.Parent = GroupCard
GroupCorner.CornerRadius = UDim.new(0, 8)

-- 发光边框
local GroupGlow = Instance.new("UIStroke")
GroupGlow.Parent = GroupCard
GroupGlow.Color = Color3.fromRGB(80, 120, 200) -- 调整颜色
GroupGlow.Thickness = 1.5
GroupGlow.Transparency = 0.3

-- 图标
local GroupIcon = Instance.new("TextLabel")
GroupIcon.Parent = GroupCard
GroupIcon.BackgroundTransparency = 1
GroupIcon.Position = UDim2.new(0, 12, 0.5, -12)
GroupIcon.Size = UDim2.new(0, 24, 0, 24)
GroupIcon.Font = Enum.Font.GothamBold
GroupIcon.Text = "👥"
GroupIcon.TextColor3 = Color3.fromRGB(150, 180, 220)
GroupIcon.TextSize = 18 -- 缩小字体
GroupIcon.TextYAlignment = Enum.TextYAlignment.Center
GroupIcon.ZIndex = 4

-- 标签
local GroupLabel = Instance.new("TextLabel")
GroupLabel.Parent = GroupCard
GroupLabel.BackgroundTransparency = 1
GroupLabel.Position = UDim2.new(0, 45, 0, 8)
GroupLabel.Size = UDim2.new(0, 120, 0, 16)
GroupLabel.Font = Enum.Font.GothamBold
GroupLabel.Text = "点击复制群号"
GroupLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
GroupLabel.TextSize = 11 -- 缩小字体
GroupLabel.TextXAlignment = Enum.TextXAlignment.Left
GroupLabel.ZIndex = 4

-- 群号显示
local GroupNumber = Instance.new("TextLabel")
GroupNumber.Parent = GroupCard
GroupNumber.BackgroundTransparency = 1
GroupNumber.Position = UDim2.new(0, 45, 0, 24)
GroupNumber.Size = UDim2.new(0, 120, 0, 20)
GroupNumber.Font = Enum.Font.GothamBlack
GroupNumber.Text = "1012033070"
GroupNumber.TextColor3 = Color3.fromRGB(255, 255, 255)
GroupNumber.TextSize = 18 -- 缩小字体
GroupNumber.TextXAlignment = Enum.TextXAlignment.Left
GroupNumber.ZIndex = 4

-- 复制图标
local CopyIcon = Instance.new("TextLabel")
CopyIcon.Parent = GroupCard
CopyIcon.BackgroundTransparency = 1
CopyIcon.Position = UDim2.new(1, -35, 0.5, -12)
CopyIcon.Size = UDim2.new(0, 24, 0, 24)
CopyIcon.Font = Enum.Font.GothamBold
CopyIcon.Text = "📋"
CopyIcon.TextColor3 = Color3.fromRGB(150, 180, 220)
CopyIcon.TextSize = 16 -- 缩小字体
CopyIcon.TextYAlignment = Enum.TextYAlignment.Center
CopyIcon.ZIndex = 4

-- 整个卡片可点击
local CopyButton = Instance.new("TextButton")
CopyButton.Parent = GroupCard
CopyButton.BackgroundTransparency = 1
CopyButton.Size = UDim2.new(1, 0, 1, 0)
CopyButton.Text = ""
CopyButton.ZIndex = 5
CopyButton.AutoButtonColor = false

-- 复制成功提示
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
WhitelistNote.Text = "✨ 进群有机会获得白名单资格"
WhitelistNote.TextColor3 = Color3.fromRGB(255, 200, 80)
WhitelistNote.TextSize = 11 -- 缩小字体
WhitelistNote.TextXAlignment = Enum.TextXAlignment.Center
WhitelistNote.ZIndex = 3

-- ========== 输入框 ==========
local InputContainer = Instance.new("Frame")
InputContainer.Parent = MainWin
InputContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
InputContainer.Position = UDim2.new(0.5, -120, 0, 160) -- 调整位置
InputContainer.Size = UDim2.new(0, 240, 0, 36) -- 缩小尺寸
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
Input.TextSize = 13 -- 缩小字体
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
InputIcon.TextSize = 12 -- 缩小字体
InputIcon.TextYAlignment = Enum.TextYAlignment.Center
InputIcon.ZIndex = 4

-- 输入框清空按钮
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
VerifyBtn.Position = UDim2.new(0.5, -95, 0, 205) -- 调整位置
VerifyBtn.Size = UDim2.new(0, 190, 0, 36) -- 缩小尺寸
VerifyBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.Text = "验证卡密"
VerifyBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
VerifyBtn.TextSize = 14 -- 缩小字体
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
AttemptsDisplay.Text = string.format("剩余尝试次数: %d/%d", maxAttempts - attempts, maxAttempts)
AttemptsDisplay.TextColor3 = Color3.fromRGB(180, 180, 180)
AttemptsDisplay.TextSize = 10
AttemptsDisplay.TextXAlignment = Enum.TextXAlignment.Center
AttemptsDisplay.ZIndex = 3

-- ========== 关闭按钮 ==========
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainWin
CloseBtn.Position = UDim2.new(1, -35, 0, 8)
CloseBtn.Size = UDim2.new(0, 24, 0, 24) -- 缩小尺寸
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.TextSize = 18 -- 缩小字体
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
Msg.Position = UDim2.new(0, 0, 1, -20) -- 调整位置
Msg.Size = UDim2.new(1, 0, 0, 16)
Msg.Font = Enum.Font.Gotham
Msg.Text = ""
Msg.TextColor3 = Color3.fromRGB(150, 150, 150)
Msg.TextSize = 10 -- 缩小字体
Msg.TextXAlignment = Enum.TextXAlignment.Center
Msg.Visible = false
Msg.ZIndex = 3

-- ========== 触摸区域 ==========
local TouchDragArea = Instance.new("TextButton")
TouchDragArea.Parent = MainWin
TouchDragArea.BackgroundTransparency = 1
TouchDragArea.Size = UDim2.new(1, 0, 0, 60) -- 触摸区域
TouchDragArea.Text = ""
TouchDragArea.ZIndex = 5
TouchDragArea.AutoButtonColor = false
TouchDragArea.Visible = isMobile

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

-- ========== 功能模块 ==========

-- 更新剩余尝试次数显示
local function updateAttemptsDisplay()
    AttemptsDisplay.Text = string.format("剩余尝试次数: %d/%d", maxAttempts - attempts, maxAttempts)
end

-- 播放音效
local function playSound(soundId, volume)
    local sound = Instance.new("Sound")
    sound.Parent = SoundService
    sound.SoundId = soundId
    sound.Volume = volume or 0.5
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 1)
end

-- 显示消息提示
local function showMessage(text, color, duration)
    Msg.Text = text
    Msg.TextColor3 = color
    Msg.Visible = true
    
    if duration then
        task.wait(duration)
        Msg.Visible = false
    end
end

-- 更新状态指示灯
local function updateStatus(color, text)
    StatusLight.BackgroundColor3 = color
    StatusText.Text = text
    StatusText.TextColor3 = color
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
    
    -- 显示清空按钮
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
    
    -- 隐藏清空按钮
    ClearInputButton.Visible = false
end)

-- 输入文本变化时显示/隐藏清空按钮
Input:GetPropertyChangedSignal("Text"):Connect(function()
    ClearInputButton.Visible = #Input.Text > 0
end)

-- 清空输入框按钮
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
    
    -- 播放复制音效
    playSound("rbxassetid://62339698", 0.5)
    
    -- 复制群号到剪贴板
    local groupNumber = "1012033070"
    pcall(function()
        setclipboard(groupNumber)
    end)
    
    -- 复制成功动画
    CopyIcon.Text = "✓"
    TweenService:Create(CopyIcon, TweenInfo.new(0.2), {
        TextColor3 = Color3.fromRGB(80, 255, 80),
        TextSize = 18
    }):Play()
    
    TweenService:Create(GroupNumber, TweenInfo.new(0.2), {
        TextColor3 = Color3.fromRGB(80, 255, 80)
    }):Play()
    
    -- 显示成功提示
    CopySuccess.Visible = true
    CopySuccess.Position = UDim2.new(0.5, -65, 0, 75)
    
    local successTween = TweenService:Create(CopySuccess, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -65, 0, 70)
    })
    successTween:Play()
    
    -- 成功闪烁
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
    
    -- 隐藏成功提示
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
    
    -- 显示消息提示
    showMessage("✅ 群号已复制到剪贴板", Color3.fromRGB(80, 255, 80), 2)
    
    task.wait(1)
    copyCooldown = false
end)

-- ========== 统一的拖动功能 ==========
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

-- 设置拖动区域
if isMobile then
    TouchDragArea.InputBegan:Connect(startDrag)
else
    TitleBar.InputBegan:Connect(startDrag)
end

-- 拖动处理
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
    if StartSound then
        StartSound:Destroy()
    end
end)

-- ========== 验证功能 ==========
VerifyBtn.MouseButton1Click:Connect(function()
    local key = Input.Text
    
    if #key == 0 then
        showMessage("请输入卡密", Color3.fromRGB(255, 180, 80), 1.5)
        
        -- 输入框震动效果
        for i = 1, 3 do
            InputContainer.Position = UDim2.new(0.5, -120 + (i % 2 == 1 and 3 or -3), 0, 160)
            task.wait(0.05)
        end
        InputContainer.Position = UDim2.new(0.5, -120, 0, 160)
        return
    end
    
    if key == "HB_GoodBye Planet Gay" then
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
        
        -- 成功音效
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
        if StartSound then
            StartSound:Destroy()
        end
        
        pcall(function()
            loadstring(game:HttpGet("https://api.junkie-development.de/api/v1/luascripts/public/aa294a62c2e48bc4c6ea72022c2da28420ba2ea3c233ef97a34688303a76bef9/download"))()
        end)
        
        if localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid") then
            localPlayer.Character.Humanoid.WalkSpeed = 25
        end
        
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
        
        -- 失败音效
        playSound("rbxassetid://62339698", 0.3)
        
        -- 震动效果
        for i = 1, 3 do
            InputContainer.Position = UDim2.new(0.5, -120 + (i % 2 == 1 and 4 or -4), 0, 160)
            task.wait(0.05)
        end
        InputContainer.Position = UDim2.new(0.5, -120, 0, 160)
        
        -- 警告闪烁
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
            
            -- 锁定UI
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
            
            -- 清空输入框
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

-- 键盘快捷键
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Escape then
        CloseBtn.MouseButton1Click:Fire()
    end
    
    if input.KeyCode == Enum.KeyCode.F5 then
        -- 重新验证快捷键
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

-- ========== 动态效果 ==========
-- 窗口边框呼吸效果
coroutine.wrap(function()
    while WinGlow.Parent do
        TweenService:Create(WinGlow, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true), {
            Transparency = 0.8
        }):Play()
        task.wait(2)
    end
end)()

-- 按钮边框呼吸效果
coroutine.wrap(function()
    while VerifyBtnStroke.Parent do
        TweenService:Create(VerifyBtnStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true), {
            Transparency = 0.5
        }):Play()
        task.wait(1.5)
    end
end)()

-- 状态指示灯闪烁
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
    -- 软键盘处理
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
    
    -- 双击拖动区域关闭UI
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

print("黑白脚本紧凑增强版UI已加载完成")
print("窗口尺寸: 300x260 (紧凑尺寸)")
print("设备适配:", isMobile and "移动端" or "电脑端")
print("功能优化完成，用户体验提升")