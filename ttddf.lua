-- ========== 恐脚本UI + 飞车/飞天 过检测版 ==========
-- 恐脚本UI风格 | 飞车+飞天 | 速度调节 | 过检测

local player = game:GetService("Players").LocalPlayer
local plrId = player.UserId
local filename = "script_count_" .. plrId .. ".txt"
local count = 0
if pcall(function() return readfile(filename) end) then
    local data = readfile(filename)
    count = tonumber(data) or 0
end
count = count + 1
pcall(function()
    writefile(filename, tostring(count))
end)

local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ==================== 过检测 ====================
local bypassActive = false
local bypassConnections = {}

local function startBypass()
    if bypassActive then return end
    bypassActive = true
    print("🛡️ 启动过检测...")

    pcall(function()
        local oldKick = player.Kick
        player.Kick = function(self, msg)
            print("🛡️ 拦截踢出: " .. tostring(msg))
            return nil
        end
        table.insert(bypassConnections, {Disconnect = function()
            player.Kick = oldKick
        end})
    end)

    pcall(function()
        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                local conn = hum.HealthChanged:Connect(function()
                    if hum.Health <= 0 then
                        task.wait(0.1)
                        if hum and hum.Parent then
                            hum.Health = hum.MaxHealth
                        end
                    end
                end)
                table.insert(bypassConnections, conn)
            end
        end
    end)

    pcall(function()
        local function antiTeleport()
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local lastPos = hrp.Position
                    local conn = RunService.Heartbeat:Connect(function()
                        if not hrp or not hrp.Parent then return end
                        if (hrp.Position - lastPos).Magnitude > 100 then
                            hrp.CFrame = CFrame.new(lastPos)
                        end
                        lastPos = hrp.Position
                    end)
                    table.insert(bypassConnections, conn)
                end
            end
        end
        antiTeleport()
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            antiTeleport()
        end)
    end)

    pcall(function()
        local conn = RunService.Heartbeat:Connect(function()
            if math.random(1, 100) > 95 then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end
        end)
        table.insert(bypassConnections, conn)
    end)

    pcall(function()
        local conn = player:GetPropertyChangedSignal("Parent"):Connect(function()
            if not player.Parent then
                print("🔄 被踢出，重连中...")
                task.wait(2)
                TeleportService:Teleport(game.PlaceId, player)
            end
        end)
        table.insert(bypassConnections, conn)
    end)

    print("✅ 过检测已启动")
end

-- ==================== 飞车/飞天功能 ====================
local carFlyEnabled = false
local carSpeed = 50
local carBV = nil
local carBG = nil
local flyConn = nil
local moveForward = 0
local moveBackward = 0
local moveLeft = 0
local moveRight = 0
local moveUp = 0
local moveDown = 0

local function toggleCarFly()
    carFlyEnabled = not carFlyEnabled
    
    if carFlyEnabled then
        local char = player.Character
        if not char then
            print("❌ 没有角色")
            carFlyEnabled = false
            return
        end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if not hrp or not hum then
            print("❌ 找不到 HumanoidRootPart")
            carFlyEnabled = false
            return
        end
        
        print("✅ 飞车开启")
        hum.PlatformStand = true
        
        carBV = Instance.new("BodyVelocity")
        carBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        carBV.Velocity = Vector3.new(0, 0, 0)
        carBV.Parent = hrp
        
        carBG = Instance.new("BodyGyro")
        carBG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        carBG.D = 5000
        carBG.P = 50000
        carBG.CFrame = Camera.CFrame
        carBG.Parent = hrp
        
        -- 按键监听
        local keyBegan = UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.KeyCode == Enum.KeyCode.W then moveForward = 1 end
            if input.KeyCode == Enum.KeyCode.S then moveBackward = 1 end
            if input.KeyCode == Enum.KeyCode.A then moveLeft = 1 end
            if input.KeyCode == Enum.KeyCode.D then moveRight = 1 end
            if input.KeyCode == Enum.KeyCode.Space then moveUp = 1 end
            if input.KeyCode == Enum.KeyCode.LeftShift then moveDown = 1 end
        end)
        
        local keyEnded = UserInputService.InputEnded:Connect(function(input, gp)
            if gp then return end
            if input.KeyCode == Enum.KeyCode.W then moveForward = 0 end
            if input.KeyCode == Enum.KeyCode.S then moveBackward = 0 end
            if input.KeyCode == Enum.KeyCode.A then moveLeft = 0 end
            if input.KeyCode == Enum.KeyCode.D then moveRight = 0 end
            if input.KeyCode == Enum.KeyCode.Space then moveUp = 0 end
            if input.KeyCode == Enum.KeyCode.LeftShift then moveDown = 0 end
        end)
        
        flyConn = RunService.Heartbeat:Connect(function()
            if not carFlyEnabled then
                if flyConn then flyConn:Disconnect(); flyConn = nil end
                keyBegan:Disconnect()
                keyEnded:Disconnect()
                return
            end
            if not hrp or not hrp.Parent then
                carFlyEnabled = false
                if flyConn then flyConn:Disconnect(); flyConn = nil end
                keyBegan:Disconnect()
                keyEnded:Disconnect()
                return
            end
            
            local look = Camera.CFrame.LookVector
            local right = Camera.CFrame.RightVector
            local up = Camera.CFrame.UpVector
            
            local moveDir = Vector3.new(0, 0, 0)
            moveDir = moveDir + look * (moveForward - moveBackward) * carSpeed
            moveDir = moveDir + right * (moveRight - moveLeft) * carSpeed
            moveDir = moveDir + up * (moveUp - moveDown) * carSpeed
            
            if moveDir.Magnitude > 0 then
                carBV.Velocity = moveDir
            else
                carBV.Velocity = Vector3.new(0, 0, 0)
            end
            
            carBG.CFrame = Camera.CFrame
        end)
        
        -- 升空
        task.spawn(function()
            local targetHeight = hrp.Position.Y + 15
            while carFlyEnabled and hrp and hrp.Parent do
                if hrp.Position.Y < targetHeight then
                    if carBV then
                        carBV.Velocity = Vector3.new(0, 20, 0)
                    end
                else
                    break
                end
                task.wait(0.1)
            end
        end)
        
    else
        print("❌ 飞车关闭")
        if carBV then carBV:Destroy(); carBV = nil end
        if carBG then carBG:Destroy(); carBG = nil end
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        moveForward = 0
        moveBackward = 0
        moveLeft = 0
        moveRight = 0
        moveUp = 0
        moveDown = 0
        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then hum.PlatformStand = false end
        end
    end
end

-- ==================== 恐脚本UI ====================
local function createUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UniversalUI"
    ScreenGui.Parent = LocalPlayer.PlayerGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Main.Position = UDim2.new(0.5, 0, 0.5, 10)
    Main.Size = UDim2.new(0, 650, 0, 280)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Visible = false
    Main.ZIndex = 10
    Main.ClipsDescendants = true
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Main
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Thickness = 2
    MainStroke.Color = Color3.new(1, 0, 0)
    MainStroke.Parent = Main

    local BeanBack = Instance.new("Frame")
    BeanBack.Name = "BeanBackground"
    BeanBack.Parent = Main
    BeanBack.BackgroundTransparency = 1
    BeanBack.Size = UDim2.new(1, 0, 1, 0)
    BeanBack.ZIndex = 1

    local Line = Instance.new("Frame")
    Line.Parent = Main
    Line.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Line.Position = UDim2.new(0.3, 0, 0, 40)
    Line.Size = UDim2.new(0, 2, 1, -40)
    Line.ZIndex = 11

    local CategoryArea = Instance.new("Frame")
    CategoryArea.Name = "CategoryArea"
    CategoryArea.Parent = Main
    CategoryArea.BackgroundTransparency = 1
    CategoryArea.Size = UDim2.new(0.3, -10, 1, -40)
    CategoryArea.Position = UDim2.new(0, 10, 0, 40)
    CategoryArea.ZIndex = 20

    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Parent = Main
    ContentArea.BackgroundTransparency = 1
    ContentArea.Size = UDim2.new(0.7, -12, 1, -40)
    ContentArea.Position = UDim2.new(0.3, 12, 0, 40)
    ContentArea.ZIndex = 20
    ContentArea.ClipsDescendants = true

    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Parent = ContentArea
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 5, 0)
    ScrollingFrame.ScrollBarThickness = 6
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ZIndex = 20

    local categories = {}
    local pages = {}
    local selected = nil
    local catNames = {"飞车控制", "信息"}

    -- ========== 飞车控制页面 ==========
    local function createCarFlyPage()
        local page = Instance.new("Frame")
        page.Name = "Page1"
        page.Parent = ScrollingFrame
        page.BackgroundTransparency = 1
        page.Size = UDim2.new(1, 0, 1, 0)
        page.Visible = false
        page.ZIndex = 20

        local function addButton(parent, txt, y, callback)
            local btn = Instance.new("TextButton")
            btn.Parent = parent
            btn.BackgroundColor3 = Color3.new(0, 0, 0)
            btn.BackgroundTransparency = 0.5
            btn.Size = UDim2.new(0.48, 0, 0, 40)
            btn.Position = UDim2.new(0.5, -120, 0, y)
            btn.Text = txt
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.TextSize = 14
            btn.AutoButtonColor = false
            btn.ZIndex = 21
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = btn
            if callback then
                btn.MouseButton1Click:Connect(callback)
            end
            return btn
        end

        local function addSlider(parent, txt, y, min, max, default, callback)
            local frame = Instance.new("Frame")
            frame.Parent = parent
            frame.BackgroundTransparency = 1
            frame.Size = UDim2.new(0.9, 0, 0, 50)
            frame.Position = UDim2.new(0.05, 0, 0, y)

            local label = Instance.new("TextLabel")
            label.Parent = frame
            label.Size = UDim2.new(1, 0, 0, 20)
            label.Position = UDim2.new(0, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = txt .. ": " .. tostring(default)
            label.TextColor3 = Color3.new(1, 1, 1)
            label.TextSize = 14
            label.Font = Enum.Font.SourceSans

            local slider = Instance.new("Frame")
            slider.Parent = frame
            slider.Size = UDim2.new(1, 0, 0, 20)
            slider.Position = UDim2.new(0, 0, 0, 25)
            slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

            local fill = Instance.new("Frame")
            fill.Parent = slider
            fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            fill.BorderSizePixel = 0

            local knob = Instance.new("TextButton")
            knob.Parent = slider
            knob.Size = UDim2.new(0, 20, 0, 20)
            knob.Position = UDim2.new((default - min) / (max - min), -10, 0.5, -10)
            knob.Text = ""
            knob.BackgroundColor3 = Color3.new(1, 1, 1)
            knob.AutoButtonColor = false

            local dragging = false
            knob.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local mousePos = UserInputService:GetMouseLocation()
                    local sliderAbs = slider.AbsolutePosition
                    local sliderSize = slider.AbsoluteSize
                    local relativeX = math.clamp(mousePos.X - sliderAbs.X, 0, sliderSize.X)
                    local percent = relativeX / sliderSize.X
                    local val = math.floor(min + (max - min) * percent)
                    fill.Size = UDim2.new(percent, 0, 1, 0)
                    knob.Position = UDim2.new(percent, -10, 0.5, -10)
                    label.Text = txt .. ": " .. tostring(val)
                    if callback then callback(val) end
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            return {frame = frame, label = label, slider = slider, fill = fill, knob = knob}
        end

        local carFlyBtn = addButton(page, "🚗 飞车: 关", 10, function()
            toggleCarFly()
            carFlyBtn.Text = carFlyEnabled and "🚗 飞车: 开" or "🚗 飞车: 关"
            carFlyBtn.BackgroundColor3 = carFlyEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)
        end)

        local speedSlider = addSlider(page, "飞行速度", 65, 10, 200, 50, function(val)
            carSpeed = val
        end)

        local infoLabel = Instance.new("TextLabel")
        infoLabel.Parent = page
        infoLabel.Size = UDim2.new(0.9, 0, 0, 60)
        infoLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
        infoLabel.BackgroundTransparency = 1
        infoLabel.Text = "🛡️ 过检测已启动\nWASD控制方向 | 空格上升 | Shift下降"
        infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        infoLabel.TextSize = 13
        infoLabel.Font = Enum.Font.SourceSans
        infoLabel.TextXAlignment = Enum.TextXAlignment.Left

        local statusLabel = Instance.new("TextLabel")
        statusLabel.Parent = page
        statusLabel.Size = UDim2.new(0.9, 0, 0, 20)
        statusLabel.Position = UDim2.new(0.05, 0, 0.85, 0)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = "🟢 运行中"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        statusLabel.TextSize = 12
        statusLabel.Font = Enum.Font.SourceSans

        return page
    end

    -- ========== 信息页面 ==========
    local function createInfoPage()
        local page = Instance.new("Frame")
        page.Name = "Page2"
        page.Parent = ScrollingFrame
        page.BackgroundTransparency = 1
        page.Size = UDim2.new(1, 0, 1, 0)
        page.Visible = false
        page.ZIndex = 20

        local info = Instance.new("TextLabel")
        info.Parent = page
        info.Size = UDim2.new(0.9, 0, 0, 200)
        info.Position = UDim2.new(0.05, 0, 0.05, 0)
        info.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        info.Text = "恐脚本--飞车版\n\n创作者：恐拜大帝\n\n🛡️ 过检测已启动\n\n您已执行 " .. count .. " 次"
        info.TextColor3 = Color3.new(1, 1, 1)
        info.TextWrapped = true
        info.Font = Enum.Font.SourceSans
        info.TextSize = 16
        info.TextXAlignment = Enum.TextXAlignment.Center
        info.TextYAlignment = Enum.TextYAlignment.Center
        local infoCorner = Instance.new("UICorner")
        infoCorner.CornerRadius = UDim.new(0, 6)
        infoCorner.Parent = info

        return page
    end

    -- ========== 创建分类按钮 ==========
    for i, name in ipairs(catNames) do
        local cat = Instance.new("TextButton")
        cat.Name = "Cat" .. i
        cat.Parent = CategoryArea
        cat.BackgroundTransparency = 0.8
        cat.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        cat.Size = UDim2.new(1, 0, 0, 35)
        cat.Position = UDim2.new(0, 0, 0, (i - 1) * 40)
        cat.Text = name
        cat.TextColor3 = Color3.new(1, 1, 1)
        cat.TextSize = 14
        cat.AutoButtonColor = false
        cat.ZIndex = 21

        local page
        if i == 1 then
            page = createCarFlyPage()
        else
            page = createInfoPage()
        end

        cat.MouseButton1Click:Connect(function()
            if selected then
                selected.BackgroundTransparency = 0.8
                selected.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            end
            cat.BackgroundTransparency = 0.5
            cat.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            selected = cat
            for _, p in pairs(pages) do
                p.Visible = false
            end
            page.Visible = true
        end)

        table.insert(categories, cat)
        table.insert(pages, page)
    end

    -- ========== 顶部栏 ==========
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = Main
    TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.ZIndex = 15
    local TopUICorner = Instance.new("UICorner")
    TopUICorner.CornerRadius = UDim.new(0, 10)
    TopUICorner.Parent = TopBar

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Font = Enum.Font.ArialBold
    Title.Text = "恐脚本--飞车版" .. string.rep(" ", 6) .. "您已执行 " .. count .. " 次"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 16

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Parent = TopBar
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MinimizeBtn.Size = UDim2.new(0, 36, 0, 32)
    MinimizeBtn.Position = UDim2.new(1, -86, 0, 4)
    MinimizeBtn.Font = Enum.Font.ArialBold
    MinimizeBtn.Text = "—"
    MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeBtn.TextSize = 20
    MinimizeBtn.ZIndex = 17
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 6)
    MinCorner.Parent = MinimizeBtn

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = TopBar
    CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    CloseBtn.Size = UDim2.new(0, 36, 0, 32)
    CloseBtn.Position = UDim2.new(1, -46, 0, 4)
    CloseBtn.Font = Enum.Font.ArialBold
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.TextSize = 20
    CloseBtn.ZIndex = 17
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Parent = ScreenGui
    ToggleBtn.BackgroundColor3 = Color3.new(0, 0, 0)
    ToggleBtn.BackgroundTransparency = 0.5
    ToggleBtn.Position = UDim2.new(0.8, 0, 0.3, 0)
    ToggleBtn.Size = UDim2.new(0, 140, 0, 50)
    ToggleBtn.Font = Enum.Font.ArialBold
    ToggleBtn.Text = "打开菜单"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.TextSize = 20
    ToggleBtn.ZIndex = 100
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleBtn

    local dragging, dragInput, dragStartPos, btnStartPos = false, nil, nil, nil
    ToggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if not dragging and not dragInput then
                dragging = true
                dragInput = input
                dragStartPos = input.Position
                btnStartPos = ToggleBtn.Position
            end
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStartPos
            ToggleBtn.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
        end
    end)

    ToggleBtn.InputEnded:Connect(function(input)
        if input == dragInput then
            dragging = false
            dragInput = nil
        end
    end)

    ToggleBtn.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
        ToggleBtn.Text = Main.Visible and "关闭菜单" or "打开菜单"
    end)

    MinimizeBtn.MouseButton1Click:Connect(function()
        Main.Visible = false
        ToggleBtn.Text = "打开菜单"
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- 默认显示第一个分类
    if categories[1] then
        categories[1]:MouseButton1Click()
    end
end

-- ==================== 启动 ====================
task.wait(0.5)
startBypass()
createUI()

print("========================================")
print("  ✅ 恐脚本--飞车版 加载成功")
print("  🛡️ 过检测已启动")
print("  🚗 WASD控制方向 | 空格上升 | Shift下降")
print("========================================")