local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()
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

local username = game.Players.LocalPlayer.Name
local coloredUsername = ""
for i = 1, #username do
    local colorIndex = (i - 1) % #gradientColors + 1
    coloredUsername = coloredUsername .. '<font color="' .. gradientColors[colorIndex] .. '">' .. username:sub(i, i) .. '</font>'
end

local version = "v2.0.5"
local coloredVersion = ""
for i = 1, #version do
    local colorIndex = (i - 1) % #gradientColors + 1
    coloredVersion = coloredVersion .. '<font color="' .. gradientColors[colorIndex] .. '">' .. version:sub(i, i) .. '</font>'
end

WindUI:Popup({
    Title = '<font color="' .. gradientColors[1] .. '">wdf</font><font color="' .. gradientColors[5] .. '">ex</font>',
    IconThemed = true,
    Content = "尊敬的用户 " .. coloredUsername .. " \n您使用的 <font color='" .. gradientColors[1] .. "'>wdf</font><font color='" .. gradientColors[5] .. "'>ex</font> 当前版本型号是: " .. coloredVersion .. "\n脚本已就绪！",
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
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local player = Players.LocalPlayer
    local isDestroyed = false
    local connections = {}

    -- ==================== 设备UID ====================
    local function getDeviceUID()
        local userId = player.UserId
        local success, machineId = pcall(function()
            return game:GetService("HttpService"):GetMachineId()
        end)
        if not success then machineId = "unknown" end
        local combined = userId .. "_" .. machineId
        local uid = ""
        for i = 1, #combined do
            uid = uid .. string.char((string.byte(combined, i) % 26) + 65)
        end
        return uid:sub(1, 32)
    end
    local DEVICE_UID = getDeviceUID()

    local AUTHOR_UID = "XXCXXFEXWXARNGDGHPG"

    local BLACKLIST = {
        ["XXCWZAYDAXZRNCDCHPCRCBYAX"] = true,
    }

    local WHITELIST = {
        ["XXCWYXWFYZDRNGDGHPGRFYDXDACCAD"] = true,
        ["XXCWZZCACWARNGDGHPG"] = true,
        ["XXCXXFEXWXARNGDGHPG"] = true,
        ["XWZFFFYAYCRNGDGHPG"] = true,
    }

    local function isBlacklisted(uid)
        return BLACKLIST[uid] == true
    end

    local function isAuthorized(uid)
        if uid == AUTHOR_UID then return true end
        return WHITELIST[uid] == true
    end

    -- ==================== 权限验证 ====================
    if isBlacklisted(DEVICE_UID) then
        local blockGui = Instance.new("ScreenGui")
        blockGui.Name = "BlockedScreen"
        blockGui.ResetOnSpawn = false
        blockGui.Parent = player:WaitForChild("PlayerGui")

        local blockFrame = Instance.new("Frame")
        blockFrame.Size = UDim2.new(0, 500, 0, 200)
        blockFrame.Position = UDim2.new(0.5, -250, 0.5, -100)
        blockFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
        blockFrame.BorderSizePixel = 3
        blockFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
        blockFrame.Parent = blockGui

        local blockCorner = Instance.new("UICorner")
        blockCorner.CornerRadius = UDim.new(0, 12)
        blockCorner.Parent = blockFrame

        local blockTitle = Instance.new("TextLabel")
        blockTitle.Size = UDim2.new(1, 0, 0, 40)
        blockTitle.Position = UDim2.new(0, 0, 0, 10)
        blockTitle.BackgroundTransparency = 1
        blockTitle.Text = "已被拉黑"
        blockTitle.TextColor3 = Color3.fromRGB(255, 0, 0)
        blockTitle.TextSize = 28
        blockTitle.Font = Enum.Font.GothamBold
        blockTitle.TextXAlignment = Enum.TextXAlignment.Center
        blockTitle.Parent = blockFrame

        local blockDesc = Instance.new("TextLabel")
        blockDesc.Size = UDim2.new(1, -40, 0, 50)
        blockDesc.Position = UDim2.new(0, 20, 0, 60)
        blockDesc.BackgroundTransparency = 1
        blockDesc.Text = "你已被作者或管理拉黑\n你无法使用此脚本"
        blockDesc.TextColor3 = Color3.fromRGB(255, 200, 200)
        blockDesc.TextSize = 18
        blockDesc.Font = Enum.Font.GothamBold
        blockDesc.TextXAlignment = Enum.TextXAlignment.Center
        blockDesc.Parent = blockFrame

        local blockUid = Instance.new("TextLabel")
        blockUid.Size = UDim2.new(1, -40, 0, 30)
        blockUid.Position = UDim2.new(0, 20, 0, 125)
        blockUid.BackgroundTransparency = 1
        blockUid.Text = "设备UID: " .. DEVICE_UID
        blockUid.TextColor3 = Color3.fromRGB(150, 150, 150)
        blockUid.TextSize = 14
        blockUid.Font = Enum.Font.Gotham
        blockUid.TextXAlignment = Enum.TextXAlignment.Center
        blockUid.Parent = blockFrame

        return
    end

    if not isAuthorized(DEVICE_UID) then
        local authGui = Instance.new("ScreenGui")
        authGui.Name = "AuthScreen"
        authGui.ResetOnSpawn = false
        authGui.Parent = player:WaitForChild("PlayerGui")

        local authFrame = Instance.new("Frame")
        authFrame.Size = UDim2.new(0, 520, 0, 220)
        authFrame.Position = UDim2.new(0.5, -260, 0.5, -110)
        authFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
        authFrame.BorderSizePixel = 3
        authFrame.BorderColor3 = Color3.fromRGB(255, 200, 0)
        authFrame.Parent = authGui

        local authCorner = Instance.new("UICorner")
        authCorner.CornerRadius = UDim.new(0, 12)
        authCorner.Parent = authFrame

        local authTitle = Instance.new("TextLabel")
        authTitle.Size = UDim2.new(1, 0, 0, 40)
        authTitle.Position = UDim2.new(0, 0, 0, 10)
        authTitle.BackgroundTransparency = 1
        authTitle.Text = "未授权"
        authTitle.TextColor3 = Color3.fromRGB(255, 200, 0)
        authTitle.TextSize = 28
        authTitle.Font = Enum.Font.GothamBold
        authTitle.TextXAlignment = Enum.TextXAlignment.Center
        authTitle.Parent = authFrame

        local authDesc = Instance.new("TextLabel")
        authDesc.Size = UDim2.new(1, -40, 0, 50)
        authDesc.Position = UDim2.new(0, 20, 0, 60)
        authDesc.BackgroundTransparency = 1
        authDesc.Text = "你没有被授权\n你无法使用此脚本"
        authDesc.TextColor3 = Color3.fromRGB(255, 220, 150)
        authDesc.TextSize = 18
        authDesc.Font = Enum.Font.GothamBold
        authDesc.TextXAlignment = Enum.TextXAlignment.Center
        authDesc.Parent = authFrame

        local authContact = Instance.new("TextLabel")
        authContact.Size = UDim2.new(1, -40, 0, 25)
        authContact.Position = UDim2.new(0, 20, 0, 118)
        authContact.BackgroundTransparency = 1
        authContact.Text = "请联系作者或管理员授权"
        authContact.TextColor3 = Color3.fromRGB(200, 200, 200)
        authContact.TextSize = 14
        authContact.Font = Enum.Font.Gotham
        authContact.TextXAlignment = Enum.TextXAlignment.Center
        authContact.Parent = authFrame

        local authUid = Instance.new("TextLabel")
        authUid.Size = UDim2.new(1, -40, 0, 30)
        authUid.Position = UDim2.new(0, 20, 0, 150)
        authUid.BackgroundTransparency = 1
        authUid.Text = "设备UID: " .. DEVICE_UID
        authUid.TextColor3 = Color3.fromRGB(150, 200, 255)
        authUid.TextSize = 14
        authUid.Font = Enum.Font.Gotham
        authUid.TextXAlignment = Enum.TextXAlignment.Center
        authUid.Parent = authFrame

        return
    end

    -- ==================== 标记 ====================
    local scriptTag = Instance.new("BoolValue")
    scriptTag.Name = "wdfexScript"
    scriptTag.Value = true
    scriptTag.Parent = player

    local uidTag = Instance.new("StringValue")
    uidTag.Name = "wdfexDeviceUID"
    uidTag.Value = DEVICE_UID
    uidTag.Parent = player

    if DEVICE_UID == AUTHOR_UID then
        local authorTag = Instance.new("BoolValue")
        authorTag.Name = "wdfexAuthor"
        authorTag.Value = true
        authorTag.Parent = player
    end

    -- ==================== 屏幕中间更新弹窗（可关闭） ====================
    local function showCenterNotice()
        local gui = Instance.new("ScreenGui")
        gui.Name = "CenterNotice"
        gui.ResetOnSpawn = false
        gui.DisplayOrder = 1000
        gui.Parent = player:WaitForChild("PlayerGui")

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 440, 0, 170)
        frame.Position = UDim2.new(0.5, -220, 0.5, -85)
        frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        frame.BorderSizePixel = 0
        frame.Parent = gui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 14)
        corner.Parent = frame

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(255, 180, 60)
        stroke.Thickness = 2
        stroke.Parent = frame

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -30, 0, 30)
        title.Position = UDim2.new(0, 15, 0, 15)
        title.BackgroundTransparency = 1
        title.Text = "⚠ 提示"
        title.TextColor3 = Color3.fromRGB(255, 200, 80)
        title.TextSize = 20
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = frame

        local content = Instance.new("TextLabel")
        content.Size = UDim2.new(1, -40, 0, 70)
        content.Position = UDim2.new(0, 20, 0, 55)
        content.BackgroundTransparency = 1
        content.Text = "暂时停止使用正在更新绕过反作弊中\n这可能需要一些时间"
        content.TextColor3 = Color3.fromRGB(235, 235, 235)
        content.TextSize = 16
        content.Font = Enum.Font.Gotham
        content.TextWrapped = true
        content.TextXAlignment = Enum.TextXAlignment.Left
        content.TextYAlignment = Enum.TextYAlignment.Top
        content.Parent = frame

        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 110, 0, 34)
        closeBtn.Position = UDim2.new(0.5, -55, 1, -46)
        closeBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        closeBtn.Text = "关闭"
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.TextSize = 15
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.Parent = frame

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = closeBtn

        closeBtn.MouseButton1Click:Connect(function()
            gui:Destroy()
        end)

        return gui
    end

    -- 显示中间弹窗
    showCenterNotice()

    -- ==================== 右下角"开启失败"提示 ====================
    local function showFailNotice()
        local gui = Instance.new("ScreenGui")
        gui.Name = "FailNotice"
        gui.ResetOnSpawn = false
        gui.DisplayOrder = 999
        gui.Parent = player:WaitForChild("PlayerGui")

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 220, 0, 56)
        frame.Position = UDim2.new(1, 0, 1, -80)
        frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        frame.BorderSizePixel = 0
        frame.Parent = gui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = frame

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(255, 60, 60)
        stroke.Thickness = 2
        stroke.Parent = frame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -20, 1, -10)
        label.Position = UDim2.new(0, 10, 0, 5)
        label.BackgroundTransparency = 1
        label.Text = "开启失败"
        label.TextColor3 = Color3.fromRGB(255, 100, 100)
        label.TextSize = 17
        label.Font = Enum.Font.GothamBold
        label.Parent = frame

        local tweenIn = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -240, 1, -80)
        })
        tweenIn:Play()

        task.wait(2)

        local tweenOut = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 0, 1, -80)
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            gui:Destroy()
        end)
    end

    -- 所有功能统一入口：只提示失败
    local function fail()
        showFailNotice()
    end

    -- ==================== 仿iPhone灵动岛 ====================
    local function createDynamicIsland()
        local gui = Instance.new("ScreenGui")
        gui.Name = "DynamicIsland"
        gui.ResetOnSpawn = false
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.Parent = player:WaitForChild("PlayerGui")

        local expanded = false
        local musicPlaying = false

        local pillBaseY = 0
        local pill = Instance.new("Frame")
        pill.Size = UDim2.new(0, 140, 0, 34)
        pill.Position = UDim2.new(0.5, -70, 0, pillBaseY)
        pill.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
        pill.BorderSizePixel = 0
        pill.ClipsDescendants = true
        pill.Parent = gui

        local pillCorner = Instance.new("UICorner")
        pillCorner.CornerRadius = UDim.new(1, 0)
        pillCorner.Parent = pill

        local glow = Instance.new("UIStroke")
        glow.Thickness = 1.2
        glow.Color = Color3.fromRGB(255, 255, 255)
        glow.Transparency = 0.9
        glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        glow.Parent = pill

        local iconHolder = Instance.new("Frame")
        iconHolder.Size = UDim2.new(0, 14, 0, 14)
        iconHolder.Position = UDim2.new(0, 10, 0.5, -7)
        iconHolder.BackgroundTransparency = 1
        iconHolder.Parent = pill

        local dot = Instance.new("Frame")
        dot.Name = "GreenDot"
        dot.Size = UDim2.new(0, 7, 0, 7)
        dot.Position = UDim2.new(0, 3.5, 0, 3.5)
        dot.BackgroundColor3 = Color3.fromRGB(50, 220, 100)
        dot.BorderSizePixel = 0
        dot.Parent = iconHolder
        local dotCorner = Instance.new("UICorner")
        dotCorner.CornerRadius = UDim.new(1, 0)
        dotCorner.Parent = dot

        local noteLabel = Instance.new("TextLabel")
        noteLabel.Name = "NoteIcon"
        noteLabel.Size = UDim2.new(1, 0, 1, 0)
        noteLabel.BackgroundTransparency = 1
        noteLabel.Text = "♪"
        noteLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        noteLabel.TextSize = 16
        noteLabel.Font = Enum.Font.GothamBold
        noteLabel.TextXAlignment = Enum.TextXAlignment.Center
        noteLabel.TextYAlignment = Enum.TextYAlignment.Center
        noteLabel.Rotation = 0
        noteLabel.Visible = false
        noteLabel.Parent = iconHolder

        for i = 1, 3 do
            local miniDot = Instance.new("Frame")
            miniDot.Name = "SignalDot"
            miniDot.Size = UDim2.new(0, 3, 0, 3)
            miniDot.Position = UDim2.new(1, -16 - (i-1)*8, 0.5, -1.5)
            miniDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            miniDot.BackgroundTransparency = 0.5
            miniDot.BorderSizePixel = 0
            miniDot.Parent = pill
            local miniCorner = Instance.new("UICorner")
            miniCorner.CornerRadius = UDim.new(1, 0)
            miniCorner.Parent = miniDot
        end

        local breatheActive = true
        local function breatheLoop()
            while gui and gui.Parent do
                if breatheActive then
                    local t1 = TweenService:Create(glow, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                        Transparency = 0.5
                    })
                    local t2 = TweenService:Create(glow, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                        Transparency = 0.9
                    })
                    local d1 = TweenService:Create(dot, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                        Size = UDim2.new(0, 9, 0, 9),
                        Position = UDim2.new(0, 2.5, 0, 2.5)
                    })
                    local d2 = TweenService:Create(dot, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                        Size = UDim2.new(0, 7, 0, 7),
                        Position = UDim2.new(0, 3.5, 0, 3.5)
                    })
                    t1:Play()
                    d1:Play()
                    task.wait(1.2)
                    t2:Play()
                    d2:Play()
                    task.wait(1.2)
                else
                    task.wait(0.1)
                end
            end
        end
        task.spawn(breatheLoop)

        local noteSpinConn = nil
        local function startNoteSpin()
            if noteSpinConn then return end
            local angle = 0
            noteSpinConn = RunService.RenderStepped:Connect(function(dt)
                angle = (angle + dt * 180) % 360
                noteLabel.Rotation = angle
            end)
        end

        local function stopNoteSpin()
            if noteSpinConn then
                noteSpinConn:Disconnect()
                noteSpinConn = nil
            end
            noteLabel.Rotation = 0
        end

        local floatConn = nil
        local floatTime = 0
        local function startFloat()
            if floatConn then return end
            floatConn = RunService.RenderStepped:Connect(function(dt)
                floatTime = floatTime + dt * 3
                local offsetY = math.sin(floatTime) * 4
                pill.Position = UDim2.new(0.5, -70, 0, pillBaseY + offsetY)
            end)
        end

        local function stopFloat()
            if floatConn then
                floatConn:Disconnect()
                floatConn = nil
            end
            floatTime = 0
            pill.Position = UDim2.new(0.5, -70, 0, pillBaseY)
        end

        local function setMusicMode(isPlaying)
            musicPlaying = isPlaying
            if isPlaying then
                dot.Visible = false
                noteLabel.Visible = true
                breatheActive = false
                startNoteSpin()
                startFloat()
            else
                dot.Visible = true
                noteLabel.Visible = false
                breatheActive = true
                stopNoteSpin()
                stopFloat()
            end
        end

        local function toggleExpand()
            expanded = not expanded
            if expanded then
                for _, child in ipairs(pill:GetChildren()) do
                    if child:IsA("Frame") and child.Name == "ExpandedDot" then
                        child:Destroy()
                    end
                end

                local tween = TweenService:Create(pill, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 280, 0, 48),
                    Position = UDim2.new(0.5, -140, 0, pillBaseY)
                })
                tween:Play()

                for i = 1, 6 do
                    local miniDot = Instance.new("Frame")
                    miniDot.Name = "ExpandedDot"
                    miniDot.Size = UDim2.new(0, 4, 0, 4)
                    miniDot.Position = UDim2.new(0, 30 + (i-1)*35, 0.5, -2)
                    miniDot.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
                    miniDot.BackgroundTransparency = 0.3
                    miniDot.BorderSizePixel = 0
                    miniDot.Parent = pill
                    local miniCorner = Instance.new("UICorner")
                    miniCorner.CornerRadius = UDim.new(1, 0)
                    miniCorner.Parent = miniDot
                    task.wait(0.05)
                end
            else
                local tween = TweenService:Create(pill, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                    Size = UDim2.new(0, 140, 0, 34),
                    Position = UDim2.new(0.5, -70, 0, pillBaseY)
                })
                tween:Play()

                for _, child in ipairs(pill:GetChildren()) do
                    if child:IsA("Frame") and child.Name == "ExpandedDot" then
                        child:Destroy()
                    end
                end
            end
        end

        local clicker = Instance.new("TextButton")
        clicker.Size = UDim2.new(1, 0, 1, 0)
        clicker.BackgroundTransparency = 1
        clicker.Text = ""
        clicker.Parent = pill
        clicker.MouseButton1Click:Connect(toggleExpand)

        return gui, pill, setMusicMode
    end

    local islandGui, islandPill, setIslandMusicMode = createDynamicIsland()

    -- ==================== 主UI ====================
    local Window = WindUI:CreateWindow({
        Title = 'wdfex-Hub',
        Icon = "heart",
        IconThemed = true,
        Author = version,
        Folder = "CloudHub",
        Size = UDim2.fromOffset(580, 440),
        Transparent = true,
        Theme = "Dark",
        HideSearchBar = false,
        ScrollBarEnabled = true,
        Resizable = true,
        Background = "https://raw.githubusercontent.com/XxwanhexxX/UN/main/preview_png.png",
        BackgroundImageTransparency = 0.5,
        User = {
            Enabled = true,
            Callback = function()
                local userId = player.UserId
                local thumbType = Enum.ThumbnailType.HeadShot
                local thumbSize = Enum.ThumbnailSize.Size420x420
                local success, thumbnail = pcall(function()
                    return Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
                end)
                local avatarUrl = success and thumbnail or "rbxassetid://0"

                local name = player.Name

                local pwdLen = math.random(10, 15)
                local stars = string.rep("*", pwdLen)

                local days = player.AccountAge
                local regTime = days .. " 天前"

                local popupGui = Instance.new("ScreenGui")
                popupGui.Name = "UserInfoPopup"
                popupGui.ResetOnSpawn = false
                popupGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                popupGui.Parent = player:WaitForChild("PlayerGui")

                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(0, 300, 0, 250)
                frame.Position = UDim2.new(0.5, -150, 0.5, -125)
                frame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
                frame.BorderSizePixel = 2
                frame.BorderColor3 = Color3.fromRGB(100, 200, 255)
                frame.Active = true
                frame.Draggable = true
                frame.Parent = popupGui

                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 10)
                corner.Parent = frame

                local avatar = Instance.new("ImageLabel")
                avatar.Size = UDim2.new(0, 60, 0, 60)
                avatar.Position = UDim2.new(0.5, -30, 0, 15)
                avatar.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                avatar.Image = avatarUrl
                avatar.ScaleType = Enum.ScaleType.Fit
                avatar.Parent = frame

                local avatarCorner = Instance.new("UICorner")
                avatarCorner.CornerRadius = UDim.new(1, 0)
                avatarCorner.Parent = avatar

                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(1, -20, 0, 30)
                nameLabel.Position = UDim2.new(0, 10, 0, 85)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = "名字: " .. name
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.TextSize = 16
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                nameLabel.Parent = frame

                local pwdLabel = Instance.new("TextLabel")
                pwdLabel.Size = UDim2.new(1, -20, 0, 30)
                pwdLabel.Position = UDim2.new(0, 10, 0, 120)
                pwdLabel.BackgroundTransparency = 1
                pwdLabel.Text = "密码: " .. stars
                pwdLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                pwdLabel.TextSize = 16
                pwdLabel.Font = Enum.Font.Gotham
                pwdLabel.TextXAlignment = Enum.TextXAlignment.Left
                pwdLabel.Parent = frame

                local timeLabel = Instance.new("TextLabel")
                timeLabel.Size = UDim2.new(1, -20, 0, 30)
                timeLabel.Position = UDim2.new(0, 10, 0, 155)
                timeLabel.BackgroundTransparency = 1
                timeLabel.Text = "注册: " .. regTime
                timeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                timeLabel.TextSize = 16
                timeLabel.Font = Enum.Font.Gotham
                timeLabel.TextXAlignment = Enum.TextXAlignment.Left
                timeLabel.Parent = frame

                local closeBtn = Instance.new("TextButton")
                closeBtn.Size = UDim2.new(0, 60, 0, 30)
                closeBtn.Position = UDim2.new(0.5, -30, 1, -40)
                closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                closeBtn.Text = "关闭"
                closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                closeBtn.TextSize = 14
                closeBtn.Font = Enum.Font.GothamBold
                closeBtn.Parent = frame

                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 5)
                btnCorner.Parent = closeBtn

                closeBtn.MouseButton1Click:Connect(function()
                    popupGui:Destroy()
                end)
            end,
            Anonymous = false
        },
        SideBarWidth = 250,
        Search = {
            Enabled = true,
            Placeholder = "搜索...",
            Callback = function(searchText)
            end
        },
        SidePanel = {
            Enabled = true,
            Content = {
                {
                    Type = "Button", 
                    Text = "wdfex-Hub",
                    Style = "Subtle", 
                    Size = UDim2.new(1, -20, 0, 30),
                    Callback = function()
                    end
                }
            }
        }
    })

    Window:EditOpenButton({
        Title = "wdfex-Hub",
        Icon = "rbxassetid://105677776902677",
        CornerRadius = UDim.new(0,16),
        StrokeThickness = 4,
        Color = ColorSequence.new(Color3.fromHex("FF6B6B")),
        Draggable = true,
    })

    Window:Tag({
        Title = DEVICE_UID,
        Color = Color3.fromHex("#00ffff") 
    })

    Window:EditOpenButton({
        Title = "wdfex-Hub",
        Icon = "heart",
        CornerRadius = UDim.new(0,16),
        StrokeThickness = 4,
        Color = ColorSequence.new(Color3.fromHex("FF6B6B")),
        Draggable = true,
    })

    task.wait(0.1)
    local mainGui = player.PlayerGui:FindFirstChild("CloudHub")
    if mainGui then
        local mainFrame = mainGui:FindFirstChildOfClass("Frame")
        if mainFrame then
            local stroke1 = Instance.new("UIStroke")
            stroke1.Thickness = 3
            stroke1.Color = Color3.fromHSV(0, 1, 1)
            stroke1.Transparency = 0.5
            stroke1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke1.Parent = mainFrame

            local stroke2 = Instance.new("UIStroke")
            stroke2.Thickness = 5
            stroke2.Color = Color3.fromHSV(0.5, 1, 1)
            stroke2.Transparency = 0.3
            stroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke2.Parent = mainFrame

            local hue1 = 0
            local hue2 = 0.5
            local colorConn = RunService.Heartbeat:Connect(function()
                hue1 = (hue1 + 0.01) % 1
                hue2 = (hue2 - 0.01) % 1
                stroke1.Color = Color3.fromHSV(hue1, 1, 1)
                stroke2.Color = Color3.fromHSV(hue2, 1, 1)
            end)
            table.insert(connections, colorConn)
        end
    end

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

    task.spawn(function()
        pcall(function()
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://80701295792893"
            sound.Volume = 0.5
            sound.Parent = player:WaitForChild("PlayerGui")
            sound:Play()
            task.wait(7)
            sound:Stop()
            sound:Destroy()
        end)
    end)

    task.spawn(function()
        pcall(function()
            local bannerGui = Instance.new("ScreenGui")
            bannerGui.Name = "BannerGui"
            bannerGui.ResetOnSpawn = false
            bannerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            bannerGui.Parent = player:WaitForChild("PlayerGui")
            
            local banner = Instance.new("TextLabel")
            banner.Size = UDim2.new(0, 160, 0, 28)
            banner.Position = UDim2.new(0, -160, 0, 2)
            banner.BackgroundTransparency = 1
            banner.Text = "请免费分享请勿倒卖被我发现我将会删除你的授权"
            banner.TextSize = 18
            banner.Font = Enum.Font.GothamBold
            banner.TextScaled = false
            banner.TextStrokeTransparency = 0.3
            banner.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            banner.Parent = bannerGui
            
            local textWidth = 160
            
            local hue = 0
            local colorConn = RunService.Heartbeat:Connect(function()
                hue = (hue + 0.005) % 1
                banner.TextColor3 = Color3.fromHSV(hue, 0.9, 1)
            end)
            table.insert(connections, colorConn)
            
            local function startAnimation()
                local tween1 = TweenService:Create(banner, TweenInfo.new(16, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                    Position = UDim2.new(1, 10, 0, 2)
                })
                tween1:Play()
                tween1.Completed:Connect(function()
                    banner.Position = UDim2.new(0, -textWidth, 0, 2)
                    startAnimation()
                end)
            end
            
            task.wait(0.5)
            startAnimation()
        end)
    end)

    -- ==================== Tabs 结构 ====================
    local AuthorTab = Window:Tab({ Title = "作者信息", Icon = "user" })
    local AuthorSection = AuthorTab:Section({ Title = "", Opened = true })
    AuthorSection:Paragraph({
        Title = "",
        Desc = "",
        Thumbnail = "rbxassetid://74369447499630",
        ThumbnailSize = 150,
        ThumbnailShape = "Square",
    })
    AuthorSection:Paragraph({
        Title = "作者QQ：1687426335",
        Desc = "",
    })

    local NoticeTab = Window:Tab({ Title = "公告", Icon = "info" })
    local NoticeSection = NoticeTab:Section({ Title = "作者消息", Opened = true })
    NoticeSection:Divider()
    NoticeSection:Paragraph({
        Title = "注意事项",
        Desc = "已更换悬浮窗添加了一些功能\n杀戮光环的优先攻击最近目标如果选择距离内没有人\n那这个选项就不会生效杀戮光环正常生效\n修复了透视卡顿的问题\n修复了杀戮光环攻击有延迟的问题\n如果你使用的过程中出现一些bug请联系作者修复\n被封永久了就是被挂DC了如果你要是执行其他脚本之后被封的那你也活该"
    })

    local infoTab = Window:Tab({ Title = "通知", Icon = "layout-grid", Locked = false })
    local infoSection = infoTab:Section({ Title = "详情信息", Icon = "info", Opened = true })
    infoSection:Divider()
    infoSection:Paragraph({
        Title = "关于",
        Desc = "目前修复了\n使用手机的用户开启飞天卡顿的问题\n目前不知道更新什么功能了\n也没有什么bug了\n有什么功能可以向我提出我会更新",
        ThumbnailSize = 190,
    })
    local infoSection2 = infoTab:Section({ Title = "更新公告", Icon = "bell", Opened = true })
    infoSection2:Divider()
    infoSection2:Paragraph({
        Title = "v2.0.5提示",
        Desc = "修复所有已知问题\n更换了悬浮窗\n新增自动躲警察功能",
        ThumbnailSize = 190,
    })
    infoTab:Select()

    AuthorTab:Select()

    local MainSection = Window:Section({
        Title = "主功能",
        Opened = true,
    })

    local function AddTab(section, title, icon)
        return section:Tab({ Title = title, Icon = icon })
    end

    local A = AddTab(MainSection, "玩家修改", "user")
    local FlyTab = AddTab(MainSection, "飞天与加速", "plane")
    local InteractTab = AddTab(MainSection, "互动", "hand")
    local B = AddTab(MainSection, "枪械功能", "target")
    local C = AddTab(MainSection, "杀戮光环", "skull")
    local D = AddTab(MainSection, "传送点", "map-pin")
    local E = AddTab(MainSection, "透视", "eye")
    local PoliceDodgeTab = AddTab(MainSection, "自动躲警察", "shield")

    -- ============================================================
    -- 所有功能 UI（全部 Callback 失效，点击即提示开启失败）
    -- ============================================================

    -- ==================== 自动躲警察 ====================
    PoliceDodgeTab:Divider({ Text = "警察躲避设置" })
    PoliceDodgeTab:Toggle({
        Title = "启用自动躲警察",
        Value = false,
        Callback = function(value)
            fail()
        end
    })
    PoliceDodgeTab:Slider({
        Title = "触发距离",
        Step = 1,
        Value = { Min = 1, Max = 100, Default = 30 },
        Callback = function(value)
            fail()
        end
    })
    PoliceDodgeTab:Slider({
        Title = "弹开力度",
        Step = 1,
        Value = { Min = 1, Max = 100, Default = 50 },
        Callback = function(value)
            fail()
        end
    })
    PoliceDodgeTab:Toggle({
        Title = "墙体检测",
        Value = true,
        Callback = function(value)
            fail()
        end
    })

    -- ==================== 互动 ====================
    InteractTab:Divider({ Text = "快速互动" })
    InteractTab:Toggle({
        Title = "启用快速互动",
        Value = false,
        Callback = function(value)
            fail()
        end
    })
    InteractTab:Slider({
        Title = "按住时间",
        Step = 0.1,
        Value = { Min = 0, Max = 10, Default = 0 },
        Callback = function(value)
            fail()
        end
    })
    InteractTab:Slider({
        Title = "触发距离",
        Step = 1,
        Value = { Min = 5, Max = 150, Default = 25 },
        Callback = function(value)
            fail()
        end
    })

    -- ==================== 飞天与加速 ====================
    FlyTab:Divider({ Text = "飞行" })
    FlyTab:Toggle({
        Title = "飞行（绕过）",
        Value = false,
        Callback = function(value)
            fail()
        end
    })
    FlyTab:Slider({
        Title = "飞行速度",
        Step = 1,
        Value = { Min = 10, Max = 620, Default = 35 },
        Callback = function(value)
            fail()
        end
    })
    FlyTab:Toggle({
        Title = "飞天快捷开关",
        Value = false,
        Callback = function(value)
            fail()
        end
    })
    FlyTab:Divider({ Text = "移速" })
    FlyTab:Toggle({
        Title = "修改移速（绕过）",
        Value = false,
        Callback = function(value)
            fail()
        end
    })
    FlyTab:Slider({
        Title = "移速",
        Step = 1,
        Value = { Min = 5, Max = 150, Default = 20 },
        Callback = function(value)
            fail()
        end
    })

    -- ==================== 玩家修改 ====================
    A:Divider({ Text = "伤害免疫" })
    A:Toggle({
        Title = "免疫部分伤害",
        Value = false,
        Callback = function(value)
            fail()
        end
    })
    A:Paragraph({ Title = "说明", Desc = "免疫火焰和车爆炸时候的伤害" })

    A:Divider({ Text = "穿墙" })
    A:Toggle({
        Title = "启用人物穿墙",
        Value = false,
        Callback = function(value)
            fail()
        end
    })

    A:Divider({ Text = "体力" })
    A:Toggle({
        Title = "无限体力",
        Value = false,
        Callback = function(value)
            fail()
        end
    })

    A:Divider({ Text = "防甩飞" })
    A:Toggle({
        Title = "防甩飞",
        Value = false,
        Callback = function(value)
            fail()
        end
    })

    A:Divider({ Text = "防摔" })
    A:Toggle({
        Title = "防摔",
        Value = false,
        Callback = function(value)
            fail()
        end
    })

    -- ==================== 枪械功能 ====================
    B:Divider({ Text = "枪械强化" })
    B:Toggle({
        Title = "超快射速",
        Value = false,
        Callback = function(value)
            fail()
        end
    })
    B:Toggle({
        Title = "无限子弹",
        Value = false,
        Callback = function(value)
            fail()
        end
    })

    B:Divider({ Text = "碰撞箱扩展" })
    B:Toggle({
        Title = "启用头部碰撞箱（推荐20-25）",
        Value = false,
        Callback = function(value)
            fail()
        end
    })
    B:Slider({
        Title = "头部大小",
        Step = 1,
        Value = { Min = 5, Max = 400, Default = 10 },
        Callback = function(value)
            fail()
        end
    })
    B:Toggle({
        Title = "好友检测 (白名单)",
        Value = false,
        Callback = function(value)
            fail()
        end
    })

    B:Divider({ Text = "子追" })
    B:Toggle({
        Title = "启用子追",
        Value = false,
        Callback = function(value)
            fail()
        end
    })
    B:Slider({
        Title = "判定距离",
        Step = 1,
        Value = { Min = 0, Max = 1000, Default = 40 },
        Callback = function(value)
            fail()
        end
    })

    B:Divider({ Text = "自瞄" })
    B:Toggle({
        Title = "自瞄",
        Value = false,
        Callback = function(value)
            fail()
        end
    })
    B:Slider({
        Title = "FOV圈大小",
        Step = 1,
        Value = { Min = 30, Max = 400, Default = 150 },
        Callback = function(value)
            fail()
        end
    })
    B:Toggle({
        Title = "不瞄准队友",
        Value = true,
        Callback = function(value)
            fail()
        end
    })
    B:Toggle({
        Title = "墙壁检测",
        Value = true,
        Callback = function(value)
            fail()
        end
    })

    -- ==================== 杀戮光环 ====================
    C:Divider({ Text = "杀戮光环" })
    C:Paragraph({ Title = "注意", Desc = "需装备枪械武器才有伤害" })
    C:Toggle({
        Title = "启用杀戮光环",
        Value = false,
        Callback = function(value)
            fail()
        end
    })
    C:Slider({
        Title = "攻击距离",
        Step = 1,
        Value = { Min = 50, Max = 1000, Default = 300 },
        Callback = function(value)
            fail()
        end
    })

    C:Divider({ Text = "显示设置" })
    C:Toggle({
        Title = "显示攻击目标",
        Value = true,
        Callback = function(value)
            fail()
        end
    })

    C:Divider({ Text = "过滤" })
    C:Toggle({
        Title = "只攻击警察",
        Value = false,
        Callback = function(value)
            fail()
        end
    })
    C:Toggle({
        Title = "只攻击平民",
        Value = false,
        Callback = function(value)
            fail()
        end
    })
    C:Toggle({
        Title = "不攻击血量为0的玩家",
        Value = true,
        Callback = function(value)
            fail()
        end
    })

    C:Divider({ Text = "优先攻击" })
    C:Toggle({
        Title = "优先攻击最近目标",
        Value = false,
        Callback = function(value)
            fail()
        end
    })
    C:Slider({
        Title = "优先攻击距离",
        Step = 1,
        Value = { Min = 5, Max = 100, Default = 25 },
        Callback = function(value)
            fail()
        end
    })

    -- ==================== 传送点 ====================
    D:Toggle({
        Title = "启用传送",
        Value = false,
        Callback = function(value)
            fail()
        end
    })

    local FIXED_TELEPORTS = {
        "车辆经销商","医院","警察局","圣奥里修车店","圣奥里银行","圣奥里服装店",
        "圣奥里平民重生","圣奥里码头","圣奥里餐饮店","消防部门","宠物店",
        "圣奥里大码头","圣奥里海滩桥下(消星点)","大景超市","转镜中心","道路服务",
        "大景餐饮店","送货中心","大景卖车店","莱斯维尔餐饮店","莱斯维尔服装店",
        "莱斯维尔自由广场","莱斯维尔码头(游艇)","米尔顿左上加油站","米尔顿右下加油站",
        "米尔顿上方加油站","米尔顿居民区","约克镇小银行","约克镇修车厂","约克镇枪店",
        "约克镇重生点","约克镇当铺","约克镇卫星车","约克镇中心点","黑市","渔夫码头",
        "农场","监狱门口","监狱广场","代尔山","瀑布洞穴(消星点)","大桥",
        "地图右下(消星点)","下部加油站","游戏厅","高尔夫","修船厂",
    }

    local CAR_TELEPORTS = { "拆车的地方" }

    D:Divider({ Text = "常规传送" })
    D:Dropdown({
        Title = "常规传送",
        Values = FIXED_TELEPORTS,
        Value = FIXED_TELEPORTS[1],
        Callback = function(value)
            fail()
        end
    })
    D:Button({
        Title = "传送到选定地点",
        Callback = function()
            fail()
        end
    })

    D:Divider({ Text = "偷车能用到的传送地点" })
    D:Dropdown({
        Title = "偷车能用到的传送地点",
        Values = CAR_TELEPORTS,
        Value = CAR_TELEPORTS[1],
        Callback = function(value)
            fail()
        end
    })
    D:Button({
        Title = "传送到选定地点",
        Callback = function()
            fail()
        end
    })

    -- ==================== 透视 ====================
    E:Toggle({
        Title = "透视总开关",
        Value = false,
        Callback = function(value)
            fail()
        end
    })
    E:Divider()
    E:Toggle({
        Title = "显示名字",
        Value = true,
        Callback = function(value)
            fail()
        end
    })
    E:Toggle({
        Title = "显示队伍",
        Value = true,
        Callback = function(value)
            fail()
        end
    })
    E:Toggle({
        Title = "显示血量",
        Value = true,
        Callback = function(value)
            fail()
        end
    })
    E:Toggle({
        Title = "显示距离",
        Value = true,
        Callback = function(value)
            fail()
        end
    })
    E:Divider()
    E:Toggle({
        Title = "透视自己",
        Value = false,
        Callback = function(value)
            fail()
        end
    })
    E:Toggle({
        Title = "同行显示",
        Value = true,
        Callback = function(value)
            fail()
        end
    })

    -- ==================== 音乐 ====================
    local MusicTab = Window:Tab({ Title = "音乐", Icon = "music" })
    local MusicGroup = MusicTab:Section({ Title = "音乐播放器", Opened = true })

    local SONG_LIST = {
        "半壶纱","对你有感觉","失眠","中国人能飞","忘情牛肉面","无需多言","出山",
        "来个好梗绷一绷","孤独患者","幻昼","海屿你","于是","罗生门","茫",
        "忘不掉的你","DearD","戒烟","IQOO进行曲","祖国人进行曲","十年咕嘎无人知","unhappy",
    }

    MusicGroup:Dropdown({
        Title = "选择歌曲",
        Values = SONG_LIST,
        Value = SONG_LIST[1],
        Callback = function(value)
            fail()
        end
    })

    MusicGroup:Divider()

    MusicGroup:Toggle({
        Title = "播放音乐",
        Value = false,
        Callback = function(value)
            fail()
        end
    })

    MusicGroup:Slider({
        Title = "音量",
        Step = 0.1,
        Value = { Min = 0, Max = 7, Default = 1 },
        Callback = function(value)
            fail()
        end
    })

    MusicGroup:Divider()
    MusicGroup:Paragraph({
        Title = "播放模式",
        Desc = "选择音乐的播放方式"
    })

    MusicGroup:Dropdown({
        Title = "播放模式",
        Values = { "顺序播放", "循环播放", "随机播放" },
        Value = "顺序播放",
        Callback = function(value)
            fail()
        end
    })

    -- ==================== 设置 ====================
    local SettingsTab = Window:Tab({ Title = "设置", Icon = "settings" })

    if DEVICE_UID == AUTHOR_UID then
        local AdminGroup = SettingsTab:Section({ Title = "开发者后台", Opened = true })
        AdminGroup:Paragraph({
            Title = "已授权",
            Desc = "当前身份: 作者"
        })
        AdminGroup:Divider()

        AdminGroup:Paragraph({
            Title = "黑名单管理",
            Desc = "输入要拉黑的设备UID，点击拉黑即可"
        })

        local blacklistInput = nil
        AdminGroup:Input({
            Title = "输入UID",
            Placeholder = "请输入要拉黑的设备UID...",
            Callback = function(value)
                blacklistInput = value
            end
        })

        AdminGroup:Button({
            Title = "拉黑设备",
            Callback = function()
                if blacklistInput and blacklistInput ~= "" then
                    if blacklistInput == DEVICE_UID then
                        WindUI:Notify({ Title = "错误", Content = "不能拉黑自己的设备", Duration = 3 })
                        return
                    end
                    BLACKLIST[blacklistInput] = true
                    WindUI:Notify({ Title = "成功", Content = "已拉黑设备: " .. blacklistInput, Duration = 3 })
                else
                    WindUI:Notify({ Title = "错误", Content = "请输入设备UID", Duration = 2 })
                end
            end
        })

        AdminGroup:Button({
            Title = "从黑名单移除",
            Callback = function()
                if blacklistInput and blacklistInput ~= "" then
                    BLACKLIST[blacklistInput] = nil
                    WindUI:Notify({ Title = "成功", Content = "已移除黑名单: " .. blacklistInput, Duration = 3 })
                else
                    WindUI:Notify({ Title = "错误", Content = "请输入设备UID", Duration = 2 })
                end
            end
        })

        AdminGroup:Divider({ Text = "授权管理" })
        AdminGroup:Paragraph({
            Title = "说明",
            Desc = "输入要授权的设备UID，点击授权即可"
        })

        local whitelistInput = nil
        AdminGroup:Input({
            Title = "输入UID",
            Placeholder = "请输入要授权的设备UID...",
            Callback = function(value)
                whitelistInput = value
            end
        })

        AdminGroup:Button({
            Title = "授权设备",
            Callback = function()
                if whitelistInput and whitelistInput ~= "" then
                    if whitelistInput == DEVICE_UID then
                        WindUI:Notify({ Title = "提示", Content = "你已拥有最高权限", Duration = 3 })
                        return
                    end
                    WHITELIST[whitelistInput] = true
                    WindUI:Notify({ Title = "成功", Content = "已授权设备: " .. whitelistInput, Duration = 3 })
                else
                    WindUI:Notify({ Title = "错误", Content = "请输入设备UID", Duration = 2 })
                end
            end
        })

        AdminGroup:Button({
            Title = "移除授权",
            Callback = function()
                if whitelistInput and whitelistInput ~= "" then
                    WHITELIST[whitelistInput] = nil
                    WindUI:Notify({ Title = "成功", Content = "已移除授权: " .. whitelistInput, Duration = 3 })
                else
                    WindUI:Notify({ Title = "错误", Content = "请输入设备UID", Duration = 2 })
                end
            end
        })

        AdminGroup:Divider()
        AdminGroup:Button({
            Title = "查看当前黑名单",
            Callback = function()
                local list = {}
                for uid, _ in pairs(BLACKLIST) do
                    table.insert(list, uid)
                end
                if #list == 0 then
                    WindUI:Notify({ Title = "黑名单", Content = "当前黑名单为空", Duration = 3 })
                else
                    WindUI:Notify({ Title = "黑名单列表", Content = table.concat(list, "\n"), Duration = 5 })
                end
            end
        })

        AdminGroup:Button({
            Title = "查看当前授权列表",
            Callback = function()
                local list = {}
                for uid, _ in pairs(WHITELIST) do
                    table.insert(list, uid)
                end
                if #list == 0 then
                    WindUI:Notify({ Title = "授权列表", Content = "当前授权列表为空", Duration = 3 })
                else
                    WindUI:Notify({ Title = "授权列表", Content = table.concat(list, "\n"), Duration = 5 })
                end
            end
        })

        AdminGroup:Divider({ Text = "用户查询" })
        AdminGroup:Paragraph({
            Title = "通过设备UID查看Roblox用户名",
            Desc = "输入已授权或任意在线玩家的设备UID，点击查询即可显示对应的游戏名字"
        })

        local searchUidInput = nil
        AdminGroup:Input({
            Title = "输入设备UID",
            Placeholder = "请输入要查询的设备UID...",
            Callback = function(value)
                searchUidInput = value
            end
        })

        AdminGroup:Button({
            Title = "查询用户名",
            Callback = function()
                if not searchUidInput or searchUidInput == "" then
                    WindUI:Notify({ Title = "错误", Content = "请输入设备UID", Duration = 2 })
                    return
                end

                local found = false
                local resultName = "未找到"
                
                for _, p in ipairs(Players:GetPlayers()) do
                    local uidTag = p:FindFirstChild("wdfexDeviceUID")
                    if uidTag and uidTag:IsA("StringValue") and uidTag.Value == searchUidInput then
                        found = true
                        resultName = p.Name
                        break
                    end
                end

                if found then
                    WindUI:Notify({ 
                        Title = "查询结果", 
                        Content = "设备UID: " .. searchUidInput .. "\n用户名: " .. resultName, 
                        Duration = 5 
                    })
                else
                    WindUI:Notify({ 
                        Title = "查询结果", 
                        Content = "未找到该设备UID对应的在线玩家\n（玩家可能未运行此脚本或已离线）", 
                        Duration = 4 
                    })
                end
            end
        })

        AdminGroup:Divider({ Text = "坐标显示" })
        local coordEnabled = false
        local coordGui = nil
        local coordFrame = nil
        local coordTextBox = nil
        local coordCopyBtn = nil
        local coordDragging = false
        local coordDragStart, coordStartPos
        local coordRenderConn = nil

        local function CreateCoordDisplay()
            if coordGui then return end
            
            local character = player.Character or player.CharacterAdded:Wait()
            local root = character:WaitForChild("HumanoidRootPart")
            
            coordGui = Instance.new("ScreenGui")
            coordGui.Name = "CoordinateCopyTool"
            coordGui.Parent = player:WaitForChild("PlayerGui")
            
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
            
            coordCopyBtn = Instance.new("TextButton")
            coordCopyBtn.Size = UDim2.new(0.9, 0, 0, 35)
            coordCopyBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
            coordCopyBtn.Text = "点击准备复制 (Ctrl+C)"
            coordCopyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            coordCopyBtn.TextColor3 = Color3.new(1, 1, 1)
            coordCopyBtn.Parent = coordFrame
            
            coordFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    coordDragging = true
                    coordDragStart = input.Position
                    coordStartPos = coordFrame.Position
                end
            end)
            
            coordFrame.InputChanged:Connect(function(input)
                if coordDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local delta = input.Position - coordDragStart
                    coordFrame.Position = UDim2.new(coordStartPos.X.Scale, coordStartPos.X.Offset + delta.X, coordStartPos.Y.Scale, coordStartPos.Y.Offset + delta.Y)
                end
            end)
            
            coordFrame.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    coordDragging = false
                end
            end)
            
            coordRenderConn = RunService.RenderStepped:Connect(function()
                if not coordEnabled then return end
                local char = player.Character
                if not char then return end
                local rootPart = char:FindFirstChild("HumanoidRootPart")
                if not rootPart then return end
                local pos = rootPart.Position
                local formattedPos = string.format("%.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z)
                if coordTextBox and not coordTextBox:IsFocused() then
                    coordTextBox.Text = formattedPos
                end
            end)
            table.insert(connections, coordRenderConn)
            
            coordCopyBtn.MouseButton1Click:Connect(function()
                if not coordTextBox then return end
                coordTextBox:CaptureFocus()
                coordTextBox.SelectionStart = 1
                coordTextBox.CursorPosition = #coordTextBox.Text + 1
                coordCopyBtn.Text = "现在按下 Ctrl + C 复制！"
                task.wait(2)
                coordCopyBtn.Text = "点击准备复制 (Ctrl+C)"
            end)
        end

        local function DestroyCoordDisplay()
            if coordRenderConn then
                coordRenderConn:Disconnect()
                coordRenderConn = nil
            end
            if coordGui then
                coordGui:Destroy()
                coordGui = nil
                coordFrame = nil
                coordTextBox = nil
                coordCopyBtn = nil
            end
        end

        AdminGroup:Toggle({
            Title = "启用坐标显示",
            Value = false,
            Callback = function(value)
                coordEnabled = value
                if value then
                    CreateCoordDisplay()
                else
                    DestroyCoordDisplay()
                end
            end
        })

    else
        local BlockGroup = SettingsTab:Section({ Title = "开发者后台", Opened = true })
        BlockGroup:Paragraph({
            Title = "禁止访问",
            Desc = "你无法进入开发者后台"
        })
    end

    WindUI:Notify({
        Title = "wdfex-Hub",
        Content = "脚本已加载成功，欢迎使用！",
        Duration = 3,
    })
end