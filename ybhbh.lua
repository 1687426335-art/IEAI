local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()
local Confirmed = false

-- 彩虹渐变颜色
local gradientColors = {
    "rgb(255, 230, 235)", "rgb(255, 210, 220)", "rgb(255, 190, 205)",
    "rgb(255, 170, 190)", "rgb(255, 150, 175)", "rgb(245, 140, 180)",
    "rgb(235, 130, 185)", "rgb(225, 120, 190)", "rgb(215, 110, 195)",
    "rgb(205, 100, 200)"
}

local username = game.Players.LocalPlayer.Name
local coloredUsername = ""
for i = 1, #username do
    local colorIndex = (i - 1) % #gradientColors + 1
    coloredUsername = coloredUsername .. '<font color="' .. gradientColors[colorIndex] .. '">' .. username:sub(i, i) .. '</font>'
end

local version = "v1.0"
local coloredVersion = ""
for i = 1, #version do
    local colorIndex = (i - 1) % #gradientColors + 1
    coloredVersion = coloredVersion .. '<font color="' .. gradientColors[colorIndex] .. '">' .. version:sub(i, i) .. '</font>'
end

WindUI:Popup({
    Title = '<font color="' .. gradientColors[1] .. '">偷</font><font color="' .. gradientColors[5] .. '">蛋</font>',
    IconThemed = true,
    Content = "尊敬的用户 " .. coloredUsername ..
        " \n您使用的 <font color='" .. gradientColors[1] .. "'>wdfex</font><font color='" .. gradientColors[5] .. "'>脚本</font> 当前版本型号是: " .. coloredVersion ..
        "\nwdfex制作",
    Buttons = {
        { Title = "取消", Callback = function() end, Variant = "Secondary" },
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
        Title = '偷蛋脚本',
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
                { Type = "Button", Text = "偷蛋", Style = "Subtle", Size = UDim2.new(1, -20, 0, 30), Callback = function() end }
            }
        }
    })

    Window:EditOpenButton({
        Title = "偷蛋",
        Icon = "rbxassetid://105677776902677",
        CornerRadius = UDim.new(0, 16),
        StrokeThickness = 4,
        Color = ColorSequence.new(Color3.fromHex("FF6B6B")),
        Draggable = true,
    })

    Window:Tag({
        Title = "偷蛋脚本",
        Color = Color3.fromHex("#00ffff")
    })

    Window:EditOpenButton({
        Title = "偷蛋",
        Icon = "heart",
        CornerRadius = UDim.new(0, 16),
        StrokeThickness = 4,
        Color = ColorSequence.new(Color3.fromHex("FF6B6B")),
        Draggable = true,
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

    -- ==================== 全局变量与功能 ====================
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    local CoreGui = game:GetService("CoreGui")
    local UserInputService = game:GetService("UserInputService")
    local Network = ReplicatedStorage:WaitForChild("Network")
    local player = Players.LocalPlayer
    local isDestroyed = false
    local connections = {}

    local States = {
        AntiDeath = false,
        DeleteDragons = false,
        AntiPull = false,
        SpeedEnabled = false,
        AutoHome = false,
    }

    local upgradeConnection = nil
    local giftConnections = {}
    local AntiDeathConnection = nil
    local AntiPullConnection = nil
    local SpeedConnection = nil
    local TeleportLoopConnection = nil
    local CurrentTeleportTarget = nil
    local lastEggDetectTime = 0
    local eggChildAddedConn = nil
    local backpackChildAddedConn = nil
    local auraThread = nil
    local auraEnabled = false
    local popupHomeBtn = nil
    local popupEndBtn = nil

    -- ==================== 辅助函数 ====================
    local function DeletePullBackFiles()
        local char = player.Character
        if char then
            for _, obj in ipairs(char:GetChildren()) do
                if obj:IsA("LocalScript") then
                    local n = obj.Name:lower()
                    if n:find("pushback") or n:find("pullback") or n:find("anticollision") or n:find("fixcollision") or n:find("anticheat") or n:find("resetpos") or n:find("rollback") or n:find("teleportcheck") or n:find("speedcheck") or n:find("positioncheck") or n:find("antiteleport") or n:find("antispeed") then
                        pcall(function() obj:Destroy() end)
                    end
                end
            end
        end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                for _, obj in ipairs(plr.Character:GetChildren()) do
                    if obj:IsA("LocalScript") then
                        local n = obj.Name:lower()
                        if n:find("pushback") or n:find("pullback") or n:find("anticollision") or n:find("fixcollision") or n:find("anticheat") or n:find("resetpos") or n:find("rollback") or n:find("teleportcheck") or n:find("speedcheck") or n:find("positioncheck") or n:find("antiteleport") or n:find("antispeed") then
                            pcall(function() obj:Destroy() end)
                        end
                    end
                end
            end
        end
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("LocalScript") or obj:IsA("Script") then
                local n = obj.Name:lower()
                if n:find("pushback") or n:find("pullback") or n:find("anticollision") or n:find("fixcollision") or n:find("anticheat") or n:find("resetpos") or n:find("rollback") or n:find("highseed") or n:find("teleportcheck") or n:find("speedcheck") or n:find("positioncheck") or n:find("antiteleport") or n:find("antispeed") then
                    pcall(function() obj:Destroy() end)
                end
            end
            if obj:IsA("ModuleScript") then
                local n = obj.Name:lower()
                if n:find("pushback") or n:find("pullback") or n:find("anticollision") or n:find("anticheat") or n:find("rollback") or n:find("teleportcheck") or n:find("speedcheck") or n:find("positioncheck") or n:find("antiteleport") or n:find("antispeed") then
                    pcall(function() obj:Destroy() end)
                end
            end
        end
    end

    local function StartAntiDeath()
        if AntiDeathConnection then return end
        AntiDeathConnection = RunService.Heartbeat:Connect(function()
            local char = player.Character
            if char then
                local healthScript = char:FindFirstChild("Health")
                if healthScript and healthScript:IsA("Script") then
                    pcall(function() healthScript:Destroy() end)
                end
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    pcall(function()
                        hum.MaxHealth = math.huge
                        hum.Health = math.huge
                        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                    end)
                end
            end
            local debris = Workspace:FindFirstChild("__DEBRIS")
            if debris then
                for _, item in ipairs(debris:GetChildren()) do
                    if item.Name == "PlayerTrap" or item.Name:find("Trap") or item.Name:find("Kill") or item.Name:find("Death") then
                        pcall(function() item:Destroy() end)
                    end
                end
            end
            local guardsFolder = Workspace:FindFirstChild("_Guards")
            if guardsFolder then
                for _, item in ipairs(guardsFolder:GetChildren()) do
                    pcall(function() item:Destroy() end)
                end
            end
        end)
    end

    local function StopAntiDeath()
        if AntiDeathConnection then
            AntiDeathConnection:Disconnect()
            AntiDeathConnection = nil
        end
    end

    local function DeleteAllDragons()
        local guardAreas = Workspace:FindFirstChild("Areas") and Workspace.Areas:FindFirstChild("GuardAreas")
        if guardAreas then
            for _, area in ipairs(guardAreas:GetChildren()) do
                local guard = area:FindFirstChild("Guard")
                if guard then
                    pcall(function() guard:Destroy() end)
                end
            end
        end
        local guardsFolder = Workspace:FindFirstChild("_Guards")
        if guardsFolder then
            for _, item in ipairs(guardsFolder:GetChildren()) do
                pcall(function() item:Destroy() end)
            end
        end
    end

    local function StartAntiPull()
        if AntiPullConnection then return end
        DeletePullBackFiles()
        AntiPullConnection = RunService.Heartbeat:Connect(function()
            DeletePullBackFiles()
        end)
    end

    local function StopAntiPull()
        if AntiPullConnection then
            AntiPullConnection:Disconnect()
            AntiPullConnection = nil
        end
    end

    local function doUpgrade()
        local remote = Network:FindFirstChild("Plots: RequestBaseUpgrade")
        if remote then
            pcall(function() remote:FireServer() end)
        end
    end

    local function acceptGift(senderId, giftId)
        local remote = Network:FindFirstChild("Gifting: Response")
        if remote then
            pcall(function() remote:InvokeServer(senderId, giftId, true) end)
        end
    end

    local function doTeleport(targetPos)
        DeletePullBackFiles()
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function()
                    hum.MaxHealth = math.huge
                    hum.Health = math.huge
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    hum.PlatformStand = false
                    hum.Sit = false
                end)
            end
            local healthScript = char:FindFirstChild("Health")
            if healthScript and healthScript:IsA("Script") then
                pcall(function() healthScript:Destroy() end)
            end
            for _, obj in ipairs(char:GetChildren()) do
                if obj:IsA("LocalScript") then
                    local n = obj.Name:lower()
                    if n:find("pushback") or n:find("pullback") or n:find("anticollision") or n:find("fixcollision") or n:find("anticheat") or n:find("resetpos") or n:find("rollback") or n:find("teleportcheck") or n:find("speedcheck") or n:find("positioncheck") or n:find("antiteleport") or n:find("antispeed") then
                        pcall(function() obj:Destroy() end)
                    end
                end
            end
        end
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            pcall(function()
                hrp.Velocity = Vector3.zero
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.RotVelocity = Vector3.zero
                hrp.CFrame = CFrame.new(targetPos) * (hrp.CFrame - hrp.CFrame.Position)
            end)
        end
    end

    local function startTeleportLoop(targetPos)
        if TeleportLoopConnection then
            TeleportLoopConnection:Disconnect()
            TeleportLoopConnection = nil
        end
        CurrentTeleportTarget = targetPos
        local startTime = os.clock()
        TeleportLoopConnection = RunService.Heartbeat:Connect(function()
            if not CurrentTeleportTarget then
                TeleportLoopConnection:Disconnect()
                TeleportLoopConnection = nil
                return
            end
            if os.clock() - startTime > 5 then
                CurrentTeleportTarget = nil
                TeleportLoopConnection:Disconnect()
                TeleportLoopConnection = nil
                return
            end
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (hrp.Position - CurrentTeleportTarget).Magnitude
                if dist > 3 then
                    doTeleport(CurrentTeleportTarget)
                else
                    CurrentTeleportTarget = nil
                    TeleportLoopConnection:Disconnect()
                    TeleportLoopConnection = nil
                end
            end
        end)
    end

    local function isEggObject(obj)
        if not obj then return false end
        local n = obj.Name:lower()
        return n:find("egg") or n:find("carry") or n:find("areaegg") or n:find("areacarry")
    end

    local function onEggDetected()
        if not States.AutoHome then return end
        local now = tick()
        if now - lastEggDetectTime < 5 then return end
        lastEggDetectTime = now
        if not States.AntiDeath then
            States.AntiDeath = true
            StartAntiDeath()
        end
        if not States.AntiPull then
            States.AntiPull = true
            StartAntiPull()
        end
        doTeleport(Vector3.new(519.1, 70.6, -365.4))
    end

    local function setupEggListeners()
        if eggChildAddedConn then
            pcall(function() eggChildAddedConn:Disconnect() end)
            eggChildAddedConn = nil
        end
        if backpackChildAddedConn then
            pcall(function() backpackChildAddedConn:Disconnect() end)
            backpackChildAddedConn = nil
        end

        local char = player.Character
        if char then
            for _, obj in ipairs(char:GetChildren()) do
                if isEggObject(obj) then
                    onEggDetected()
                end
            end
            eggChildAddedConn = char.ChildAdded:Connect(function(child)
                if isEggObject(child) then
                    onEggDetected()
                end
            end)
        end

        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            for _, obj in ipairs(backpack:GetChildren()) do
                if isEggObject(obj) then
                    onEggDetected()
                end
            end
            backpackChildAddedConn = backpack.ChildAdded:Connect(function(child)
                if isEggObject(child) then
                    onEggDetected()
                end
            end)
        end
    end

    local function clearEggListeners()
        if eggChildAddedConn then
            pcall(function() eggChildAddedConn:Disconnect() end)
            eggChildAddedConn = nil
        end
        if backpackChildAddedConn then
            pcall(function() backpackChildAddedConn:Disconnect() end)
            backpackChildAddedConn = nil
        end
    end

    -- ==================== 飞行模块 ====================
    local function initFly()
        local st = {on = false, spd = 100, hrp = nil, hum = nil, mt = nil, ht = nil, dc = nil, tp = nil, lt = 0, an = false, hd = nil, rl = 3.5, rc = 12, vl = 3, lastPos = nil, lastTime = nil, expectedPos = nil}
        local ctrl = nil
        task.spawn(function()
            pcall(function()
                local pm = player.PlayerScripts:FindFirstChild("PlayerModule")
                if pm then ctrl = require(pm):GetControls() end
            end)
        end)
        local function refresh()
            local ch = player.Character
            if not ch then st.hrp = nil st.hum = nil st.hd = nil return end
            st.hrp = ch:FindFirstChild("HumanoidRootPart")
            st.hum = ch:FindFirstChildOfClass("Humanoid")
            st.hd = ch:FindFirstChild("Head")
        end
        local function wall()
            if not st.hrp then return false end
            local pos = st.hrp.Position
            local rp = RaycastParams.new()
            rp.FilterType = Enum.RaycastFilterType.Blacklist
            rp.FilterDescendantsInstances = { player.Character }
            for i = 1, st.rc do
                local a = (i / st.rc) * 2 * math.pi
                local dx = math.cos(a)
                local dz = math.sin(a)
                for j = -(st.vl - 1) // 2, (st.vl - 1) // 2 do
                    local dir = Vector3.new(dx, j * 0.5, dz).Unit
                    local r = workspace:Raycast(pos, dir * st.rl, rp)
                    if r and r.Instance and r.Instance.CanCollide and r.Instance.Transparency < 0.9 then
                        return true
                    end
                end
            end
            return false
        end
        local function enterA()
            if st.an then return end
            if not st.hd or not st.hrp or not st.hum then return end
            st.hd.Anchored = true
            st.hum.PlatformStand = true
            st.an = true
        end
        local function exitA()
            if not st.an then return end
            if st.hd and st.hum then
                st.hd.Anchored = false
                st.hum.PlatformStand = false
            end
            st.an = false
        end
        local function microLoop()
            st.tp = st.hrp.Position
            st.lt = tick()
            while st.on do
                local now = tick()
                local dt = now - st.lt
                st.lt = now
                if not st.hrp or not st.hrp.Parent then break end
                local inW = wall()
                if inW and not st.an then
                    enterA()
                elseif not inW and st.an then
                    exitA()
                end
                local mv
                if ctrl then
                    local v = ctrl:GetMoveVector()
                    local cf = workspace.CurrentCamera.CFrame
                    mv = (cf.LookVector * -v.Z) + (cf.RightVector * v.X)
                else
                    mv = (st.hum and st.hum.MoveDirection) or Vector3.zero
                end
                local vy = 0
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    vy = 1
                elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    vy = -1
                end
                local d = (mv + Vector3.new(0, vy, 0)) * st.spd * dt
                st.tp = st.tp + d
                local cp = st.hrp.Position
                local rem = st.tp - cp
                local dist = rem.Magnitude
                if dist > 0 then
                    local steps = math.ceil(dist / 10)
                    local sv = rem / steps
                    for i = 1, steps do
                        if not st.on then break end
                        cp = cp + sv
                        st.hrp.CFrame = CFrame.new(cp) * st.hrp.CFrame.Rotation
                        st.hrp.Velocity = Vector3.zero
                    end
                else
                    st.hrp.CFrame = CFrame.new(st.tp) * st.hrp.CFrame.Rotation
                    st.hrp.Velocity = Vector3.zero
                end
                if st.lastPos and st.lastTime and dt > 0 then
                    local moved = (st.hrp.Position - st.lastPos).Magnitude
                    local maxNormal = st.spd * dt * 1.5
                    if moved > maxNormal then
                        st.hrp.CFrame = CFrame.new(st.expectedPos or st.lastPos) * st.hrp.CFrame.Rotation
                        st.hrp.Velocity = Vector3.zero
                        st.hrp.AssemblyLinearVelocity = Vector3.zero
                    end
                    if st.expectedPos and (st.hrp.Position - st.expectedPos).Magnitude > 5 then
                        st.hrp.CFrame = CFrame.new(st.expectedPos) * st.hrp.CFrame.Rotation
                        st.hrp.Velocity = Vector3.zero
                        st.hrp.AssemblyLinearVelocity = Vector3.zero
                    end
                end
                st.lastPos = st.hrp.Position
                st.lastTime = tick()
                st.expectedPos = st.hrp.Position + (mv + Vector3.new(0, vy, 0)) * st.spd * dt
                if st.hum then
                    st.hum:ChangeState(Enum.HumanoidStateType.Climbing)
                end
                task.wait(0.001)
            end
        end
        local function healthLoop()
            while st.on do
                if st.hum and st.hum.Health <= 0 then
                    st.hum.Health = st.hum.MaxHealth
                end
                task.wait(0.1)
            end
        end
        local function start()
            if st.on then return end
            refresh()
            if not st.hrp or not st.hum then return end
            st.on = true
            st.hum:ChangeState(Enum.HumanoidStateType.Climbing)
            st.mt = task.spawn(microLoop)
            st.ht = task.spawn(healthLoop)
            st.dc = st.hum.Died:Connect(function()
                if st.hum and st.on then
                    st.hum.Health = st.hum.MaxHealth
                    st.hum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
        end
        local function stop()
            if not st.on then return end
            st.on = false
            exitA()
            if st.mt then task.cancel(st.mt) st.mt = nil end
            if st.ht then task.cancel(st.ht) st.ht = nil end
            if st.dc then st.dc:Disconnect() st.dc = nil end
            if st.hum then st.hum:ChangeState(Enum.HumanoidStateType.Running) end
            refresh()
            if st.hrp then
                st.hrp.Velocity = Vector3.zero
                st.hrp.AssemblyLinearVelocity = Vector3.zero
            end
        end
        player.CharacterAdded:Connect(function()
            if st.on then
                stop()
                task.wait(0.2)
                start()
            end
        end)
        return {
            setE = function(v) if v then start() else stop() end end,
            setS = function(v) st.spd = v end,
        }
    end

    local flyMod = initFly()

    -- ==================== 弹窗按钮（可拖动） ====================
    local function makeDraggableButton(btn, onClick)
        local isDragging = false
        local hasMoved = false
        local dragStartMouse = nil
        local dragStartPos = nil
        local dragConn = nil

        btn.MouseButton1Down:Connect(function()
            isDragging = true
            hasMoved = false
            dragStartMouse = UserInputService:GetMouseLocation()
            dragStartPos = Vector2.new(btn.AbsolutePosition.X, btn.AbsolutePosition.Y)

            if dragConn then
                pcall(function() dragConn:Disconnect() end)
                dragConn = nil
            end

            dragConn = RunService.RenderStepped:Connect(function()
                if not isDragging then return end
                local mousePos = UserInputService:GetMouseLocation()
                local delta = mousePos - dragStartMouse
                if delta.Magnitude > 3 then
                    hasMoved = true
                end
                btn.Position = UDim2.new(0, dragStartPos.X + delta.X, 0, dragStartPos.Y + delta.Y)
            end)
        end)

        local function endDrag()
            if not isDragging then return end
            isDragging = false
            if dragConn then
                pcall(function() dragConn:Disconnect() end)
                dragConn = nil
            end
        end

        btn.MouseButton1Up:Connect(function()
            endDrag()
            if not hasMoved then
                onClick()
            end
        end)

        btn.MouseLeave:Connect(endDrag)
    end

    local function createPopupButtons()
        if popupHomeBtn then
            pcall(function() popupHomeBtn:Destroy() end)
            popupHomeBtn = nil
        end
        if popupEndBtn then
            pcall(function() popupEndBtn:Destroy() end)
            popupEndBtn = nil
        end

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "PopupTeleportGui"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        pcall(function() screenGui.Parent = CoreGui end)
        if not screenGui.Parent then
            screenGui.Parent = player:WaitForChild("PlayerGui")
        end

        local homeBtn = Instance.new("TextButton")
        homeBtn.Name = "PopupHomeBtn"
        homeBtn.Size = UDim2.new(0, 200, 0, 80)
        homeBtn.Position = UDim2.new(1, -220, 0, 20)
        homeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        homeBtn.BorderSizePixel = 0
        homeBtn.Text = "回家"
        homeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        homeBtn.TextSize = 24
        homeBtn.Font = Enum.Font.GothamBold
        homeBtn.Parent = screenGui
        popupHomeBtn = homeBtn

        makeDraggableButton(homeBtn, function()
            if not States.AntiDeath then
                States.AntiDeath = true
                StartAntiDeath()
            end
            if not States.AntiPull then
                States.AntiPull = true
                StartAntiPull()
            end
            doTeleport(Vector3.new(519.1, 70.6, -365.4))
        end)

        local endBtn = Instance.new("TextButton")
        endBtn.Name = "PopupEndBtn"
        endBtn.Size = UDim2.new(0, 200, 0, 80)
        endBtn.Position = UDim2.new(1, -220, 0, 110)
        endBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        endBtn.BorderSizePixel = 0
        endBtn.Text = "终点"
        endBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        endBtn.TextSize = 24
        endBtn.Font = Enum.Font.GothamBold
        endBtn.Parent = screenGui
        popupEndBtn = endBtn

        makeDraggableButton(endBtn, function()
            if not States.AntiDeath then
                States.AntiDeath = true
                StartAntiDeath()
            end
            if not States.AntiPull then
                States.AntiPull = true
                StartAntiPull()
            end
            doTeleport(Vector3.new(3405.4, 70.6, -353.4))
        end)
    end

    local function destroyPopupButtons()
        if popupHomeBtn then
            local parent = popupHomeBtn.Parent
            pcall(function() popupHomeBtn:Destroy() end)
            popupHomeBtn = nil
            if parent and parent.Name == "PopupTeleportGui" then
                pcall(function() parent:Destroy() end)
            end
        end
        popupEndBtn = nil
    end

    -- ==================== 创建 Tab ====================
    local function AddTab(section, title, icon)
        return section:Tab({ Title = title, Icon = icon })
    end

    -- 公告 Tab
    local NoticeTab = Window:Tab({ Title = "公告", Icon = "info" })
    local NoticeSection = NoticeTab:Section({ Title = "作者消息", Opened = true })
    NoticeSection:Paragraph({
        Title = "偷蛋脚本",
        Desc = "作者：wdefx\n脚本已加载成功"
    })

    -- 通知 Tab
    local infoTab = Window:Tab({ Title = "通知", Icon = "layout-grid", Locked = false })
    local infoSection = infoTab:Section({ Title = "详情信息", Icon = "info", Opened = true })
    infoSection:Divider()
    infoSection:Paragraph({
        Title = "关于",
        Desc = "无\n无",
        ThumbnailSize = 190,
    })
    local infoSection2 = infoTab:Section({ Title = "更新公告", Icon = "bell", Opened = true })
    infoSection2:Divider()
    infoSection2:Paragraph({
        Title = "v1.0 提示",
        Desc = "初始版本\n包含自动升级、绕过、传送、飞行、打飞光环等功能",
        ThumbnailSize = 190,
    })
    infoTab:Select()

    -- 主功能 Section
    local MainSection = Window:Section({
        Title = "主功能",
        Opened = true,
    })

    local A = AddTab(MainSection, "自动升级", "arrow-up")
    local B = AddTab(MainSection, "绕过", "shield")
    local C = AddTab(MainSection, "传送", "map-pin")
    local D = AddTab(MainSection, "移速", "gauge")
    local E = AddTab(MainSection, "飞行", "plane")
    local F = AddTab(MainSection, "交互", "hand")

    -- 其他功能 Section
    local OtherSection = Window:Section({
        Title = "其他功能",
        Opened = true,
    })

    local G = AddTab(OtherSection, "打飞光环", "skull")
    local H = AddTab(OtherSection, "偷蛋回家", "egg")
    local I = AddTab(OtherSection, "弹窗按钮", "layout-grid")
    local J = AddTab(OtherSection, "设置", "settings")

    -- ============================================================
    -- 自动升级 Tab
    -- ============================================================
    A:Divider({ Text = "基地升级" })

    A:Toggle({
        Title = "自动升级基地",
        Value = false,
        Callback = function(value)
            if value then
                upgradeConnection = RunService.Heartbeat:Connect(function()
                    doUpgrade()
                end)
            else
                if upgradeConnection then
                    upgradeConnection:Disconnect()
                    upgradeConnection = nil
                end
            end
        end
    })

    A:Paragraph({
        Title = "说明",
        Desc = "开启后自动发送基地升级请求"
    })

    -- ============================================================
    -- 绕过 Tab
    -- ============================================================
    B:Divider({ Text = "反作弊绕过" })

    B:Toggle({
        Title = "绕过反作弊击杀",
        Value = false,
        Callback = function(value)
            States.AntiDeath = value
            if value then
                StartAntiDeath()
            else
                StopAntiDeath()
            end
        end
    })
    B:Paragraph({ Title = "说明", Desc = "持续删除死亡相关文件并设置无限血量" })

    B:Divider()

    B:Toggle({
        Title = "删除所有龙",
        Value = false,
        Callback = function(value)
            States.DeleteDragons = value
            if value then
                DeleteAllDragons()
            end
        end
    })
    B:Paragraph({ Title = "说明", Desc = "删除所有龙与守卫" })

    B:Divider()

    B:Toggle({
        Title = "绕过反作弊回拉",
        Value = false,
        Callback = function(value)
            States.AntiPull = value
            if value then
                StartAntiPull()
            else
                StopAntiPull()
            end
        end
    })
    B:Paragraph({ Title = "说明", Desc = "持续删除回拉/反作弊相关脚本" })

    -- ============================================================
    -- 传送 Tab
    -- ============================================================
    C:Divider({ Text = "传送" })

    C:Button({
        Title = "传送到最后区域",
        Callback = function()
            startTeleportLoop(Vector3.new(3405.4, 70.6, -353.4))
        end
    })

    C:Button({
        Title = "传送到家里",
        Callback = function()
            startTeleportLoop(Vector3.new(519.1, 70.6, -365.4))
        end
    })

    C:Paragraph({
        Title = "说明",
        Desc = "点击后自动传送到目标位置，5秒内持续修正位置"
    })

    -- ============================================================
    -- 移速 Tab
    -- ============================================================
    local speedValue = 16

    D:Divider({ Text = "移速修改" })

    D:Toggle({
        Title = "移速修改总开关",
        Value = false,
        Callback = function(value)
            States.SpeedEnabled = value
            if value then
                if not States.AntiDeath then
                    States.AntiDeath = true
                    StartAntiDeath()
                end
                if not States.AntiPull then
                    States.AntiPull = true
                    StartAntiPull()
                end
                if SpeedConnection then SpeedConnection:Disconnect() end
                SpeedConnection = RunService.Heartbeat:Connect(function()
                    DeletePullBackFiles()
                    local char = player.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then
                            local val = speedValue
                            pcall(function()
                                hum.WalkSpeed = val
                                hum.MaxHealth = math.huge
                                hum.Health = math.huge
                                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                            end)
                        end
                        local healthScript = char:FindFirstChild("Health")
                        if healthScript and healthScript:IsA("Script") then
                            pcall(function() healthScript:Destroy() end)
                        end
                    end
                end)
            else
                if SpeedConnection then
                    SpeedConnection:Disconnect()
                    SpeedConnection = nil
                end
                local char = player.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        pcall(function() hum.WalkSpeed = 16 end)
                    end
                end
            end
        end
    })

    D:Slider({
        Title = "移速数值",
        Step = 1,
        Value = { Min = 16, Max = 300, Default = 16 },
        Callback = function(value)
            speedValue = value
            if States.SpeedEnabled then
                local char = player.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        pcall(function() hum.WalkSpeed = value end)
                    end
                end
            end
        end
    })

    -- ============================================================
    -- 飞行 Tab
    -- ============================================================
    D:Divider({ Text = "飞行" })  -- 使用 D（移速Tab）的Divider来区分，但这里单独放在飞行Tab

    -- 实际上飞行应该单独放一个Tab，但由于前面已经分了E作为飞行Tab，这里重新写E的内容
    -- 注意：上面D是移速Tab，E是飞行Tab，所以下面重新为E添加内容

    -- 由于上面已经定义了E = AddTab(MainSection, "飞行", "plane")，但还没有添加内容，现在添加

    -- ============================================================
    -- 飞行 Tab（重新添加到E）
    -- ============================================================
    E:Divider({ Text = "飞行绕过" })

    E:Toggle({
        Title = "飞行绕过",
        Value = false,
        Callback = function(value)
            if value then
                if not States.AntiDeath then
                    States.AntiDeath = true
                    StartAntiDeath()
                end
                if not States.AntiPull then
                    States.AntiPull = true
                    StartAntiPull()
                end
                flyMod.setE(true)
            else
                flyMod.setE(false)
            end
        end
    })

    E:Slider({
        Title = "飞行速度",
        Step = 1,
        Value = { Min = 0, Max = 500, Default = 100 },
        Callback = function(value)
            flyMod.setS(value)
        end
    })

    -- ============================================================
    -- 交互 Tab
    -- ============================================================
    F:Divider({ Text = "交互功能" })

    F:Button({
        Title = "全图交互",
        Callback = function()
            local wow_player = game:GetService("Players").LocalPlayer
            local wow_char = wow_player.Character
            if not wow_char then return end
            local wow_runtime = workspace:FindFirstChild("Runtime")
            local wow_scanRoot = wow_runtime and wow_runtime:FindFirstChild("LootPoints") or workspace
            for _, wow_obj in ipairs(wow_scanRoot:GetDescendants()) do
                if wow_obj:IsA("ProximityPrompt") then
                    pcall(function()
                        fireproximityprompt(wow_obj)
                    end)
                end
            end
        end
    })

    F:Paragraph({
        Title = "说明",
        Desc = "触发场景内所有可交互的提示点"
    })

    -- ============================================================
    -- 打飞光环 Tab
    -- ============================================================
    local auraRangeVal = 10
    local auraFreqVal = 0.5

    G:Divider({ Text = "打飞光环" })

    G:Toggle({
        Title = "打飞光环",
        Value = false,
        Callback = function(value)
            auraEnabled = value
            if value then
                auraThread = task.spawn(function()
                    while auraEnabled do
                        local range = auraRangeVal
                        local freq = auraFreqVal
                        local myChar = player.Character
                        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
                        if myHRP then
                            for _, plr in ipairs(Players:GetPlayers()) do
                                if plr ~= player and plr.Character then
                                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                                    if hrp then
                                        local dist = (hrp.Position - myHRP.Position).Magnitude
                                        if dist <= range then
                                            local batRemote = Network:FindFirstChild("Bat:Activate")
                                            if batRemote and batRemote:IsA("RemoteEvent") then
                                                pcall(function()
                                                    batRemote:FireServer(plr, "11406186857:16:1786605357845")
                                                end)
                                                pcall(function()
                                                    batRemote:FireServer(plr, "11406186857:7:1786605352104")
                                                end)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        task.wait(freq)
                    end
                end)
            else
                auraEnabled = false
                if auraThread then
                    pcall(function() task.cancel(auraThread) end)
                    auraThread = nil
                end
            end
        end
    })

    G:Slider({
        Title = "光环范围",
        Step = 1,
        Value = { Min = 5, Max = 100, Default = 10 },
        Callback = function(value)
            auraRangeVal = value
        end
    })

    G:Slider({
        Title = "攻击频率",
        Step = 0.1,
        Value = { Min = 0.1, Max = 2, Default = 0.5 },
        Callback = function(value)
            auraFreqVal = value
        end
    })

    -- ============================================================
    -- 偷蛋回家 Tab
    -- ============================================================
    H:Divider({ Text = "偷蛋检测" })

    H:Toggle({
        Title = "检测到偷蛋立马传送回家",
        Value = false,
        Callback = function(value)
            States.AutoHome = value
            if value then
                setupEggListeners()
            else
                clearEggListeners()
            end
        end
    })
    H:Paragraph({ Title = "说明", Desc = "检测到身上或背包出现蛋道具时自动传送回家" })

    H:Divider()

    H:Button({
        Title = "偷蛋并回家",
        Callback = function()
            if not States.AntiDeath then
                States.AntiDeath = true
                StartAntiDeath()
            end
            if not States.AntiPull then
                States.AntiPull = true
                StartAntiPull()
            end
            local eggRemote = Network:FindFirstChild("Eggs: RequestAreaEggCarry")
            if eggRemote and eggRemote:IsA("RemoteFunction") then
                pcall(function()
                    eggRemote:InvokeServer({ Uid = "d46a82d7877e4272a5364b50d64cc86f" })
                end)
            end
            task.wait(1)
            doTeleport(Vector3.new(519.1, 70.6, -365.4))
        end
    })

    -- ============================================================
    -- 弹窗按钮 Tab
    -- ============================================================
    I:Divider({ Text = "弹窗按钮" })

    I:Toggle({
        Title = "开启弹窗回家",
        Value = false,
        Callback = function(value)
            if value then
                if not popupHomeBtn then
                    createPopupButtons()
                end
                pcall(function() popupHomeBtn.Visible = true end)
            else
                pcall(function() popupHomeBtn.Visible = false end)
            end
        end
    })

    I:Toggle({
        Title = "开启弹窗终点",
        Value = false,
        Callback = function(value)
            if value then
                if not popupEndBtn then
                    createPopupButtons()
                end
                pcall(function() popupEndBtn.Visible = true end)
            else
                pcall(function() popupEndBtn.Visible = false end)
            end
        end
    })

    I:Paragraph({
        Title = "说明",
        Desc = "在屏幕右上角显示可拖动的传送按钮"
    })

    -- ============================================================
    -- 设置 Tab
    -- ============================================================
    J:Divider({ Text = "脚本管理" })

    J:Button({
        Title = "卸载脚本",
        Callback = function()
            isDestroyed = true
            if upgradeConnection then
                upgradeConnection:Disconnect()
                upgradeConnection = nil
            end
            for _, conn in ipairs(giftConnections) do
                if conn then
                    conn:Disconnect()
                end
            end
            giftConnections = {}
            if SpeedConnection then
                SpeedConnection:Disconnect()
                SpeedConnection = nil
            end
            if TeleportLoopConnection then
                TeleportLoopConnection:Disconnect()
                TeleportLoopConnection = nil
            end
            CurrentTeleportTarget = nil
            clearEggListeners()
            auraEnabled = false
            if auraThread then
                pcall(function() task.cancel(auraThread) end)
                auraThread = nil
            end
            destroyPopupButtons()
            StopAntiDeath()
            StopAntiPull()
            flyMod.setE(false)
            Window:Destroy()
            WindUI:Notify({ Title = "已卸载", Content = "脚本已安全卸载", Duration = 2 })
        end
    })

    -- ==================== 自动同意赠礼（放在主功能或单独的Tab，这里加在自动升级Tab后面） ====================
    -- 由于自动同意赠礼在原脚本中是一个独立功能，我们可以在自动升级Tab或主功能里加一个Section
    -- 但为了保持清晰，可以在主功能Section里加一个新的Tab叫"赠礼"，或者放在自动升级Tab里作为第二个功能

    -- 简单起见，我们在自动升级Tab里添加一个Section
    local giftSection = A:Section({ Title = "自动同意赠礼", Opened = true })
    giftSection:Toggle({
        Title = "自动同意赠礼",
        Value = false,
        Callback = function(value)
            if value then
                local requestNames = { "Gifting: Request", "Gifting: Offer", "Gifting: Incoming" }
                for _, name in ipairs(requestNames) do
                    local remote = Network:FindFirstChild(name)
                    if remote then
                        if remote:IsA("RemoteEvent") then
                            local conn = remote.OnClientEvent:Connect(function(senderId, giftId)
                                acceptGift(senderId, giftId)
                            end)
                            table.insert(giftConnections, conn)
                        elseif remote:IsA("RemoteFunction") then
                            remote.OnClientInvoke = function(senderId, giftId)
                                acceptGift(senderId, giftId)
                            end
                        end
                    end
                end
            else
                for _, conn in ipairs(giftConnections) do
                    if conn then
                        conn:Disconnect()
                    end
                end
                giftConnections = {}
            end
        end
    })

    -- 监听玩家重生自动设置监听器
    player.CharacterAdded:Connect(function()
        if States.AutoHome then
            task.wait(0.3)
            setupEggListeners()
        end
    end)

    WindUI:Notify({
        Title = "偷蛋脚本",
        Content = "脚本已加载成功，欢迎使用！",
        Duration = 3,
    })
end