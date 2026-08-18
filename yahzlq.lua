-- 祖国人飞行系统 v21.4 落地动画3倍速版
-- 修复：玩家/坐标模式的落地动画改为3倍速，贴地稳定不飘

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local function create(className, props)
    local obj = Instance.new(className)
    for k, v in pairs(props) do obj[k] = v end
    return obj
end

-- 动作ID
local ANIMS = {
    TAKEOFF = "rbxassetid://134974990345233",
    FLYING_FAST = "rbxassetid://137006704296145",
    FLYING_SLOW = "rbxassetid://126046533185038",
    MOON = "rbxassetid://82731245433251",
    LANDING = "rbxassetid://79698004825744",
}
-- 待机动作列表
local IDLE_ANIMS = {
    "rbxassetid://118327551669637",
    "rbxassetid://116874847956719",
    "rbxassetid://96251694399659",
    "rbxassetid://70950173927129",
}

local flying = false
local landing = false
local bg, bv
local nowe = false
local tpwalking = false
local tpwalkingConnections = {}
local speeds = 1
local idleTrack, flyTrack, currentActionTrack
local moonTrack = nil
local moonActive = false
local isRising = false
local speedMode = "fast"
local currentIdleIndex = 1

-- 激光眼相关
local laserActive = false
local laserBeam1

-- 防甩飞相关
local antiStiffConn = nil
local antiStiffActive = false

-- 玩家/坐标模式相关
local teleportActive = false

local SLOW_SPEEDS = 1
local fastSpeeds = 8

-- 角色工具
local function getChar() return player.Character end
local function getHum() local c = getChar() return c and c:FindFirstChildOfClass("Humanoid") end
local function getAnimator() local h = getHum() return h and h:FindFirstChildOfClass("Animator") end

local function stopAllAnimTracks()
    if idleTrack then idleTrack:Stop(0.2); idleTrack = nil end
    if flyTrack then flyTrack:Stop(0.2); flyTrack = nil end
    if currentActionTrack then currentActionTrack:Stop(0.2); currentActionTrack = nil end
    if moonTrack then moonTrack:Stop(0.2); moonTrack = nil end
end

local function playAnim(id, loop, speedMul)
    local animator = getAnimator()
    if not animator then return nil end
    local anim = Instance.new("Animation")
    anim.AnimationId = id
    local track = animator:LoadAnimation(anim)
    track.Looped = loop or false
    track:Play(0.2)
    if speedMul then track:AdjustSpeed(speedMul) end
    return track
end

local function getCurrentIdleAnimID()
    return IDLE_ANIMS[currentIdleIndex]
end

-- 飞行物理
local function stopTranslateBy()
    tpwalking = false
    for _, conn in ipairs(tpwalkingConnections) do conn:Disconnect() end
    tpwalkingConnections = {}
end

local function startTranslateBy()
    stopTranslateBy()
    local currentSpeeds = (speedMode == "slow") and SLOW_SPEEDS or fastSpeeds
    for i = 1, currentSpeeds do
        local conn = RunService.RenderStepped:Connect(function()
            if not tpwalking or not nowe then conn:Disconnect(); return end
            local chr = player.Character
            local h = chr and chr:FindFirstChildOfClass("Humanoid")
            if h and h.MoveDirection.Magnitude > 0 then
                chr:TranslateBy(h.MoveDirection)
            end
        end)
        table.insert(tpwalkingConnections, conn)
    end
    tpwalking = true
end

-- 移除自身碰撞箱
local function removeCollision()
    local char = getChar()
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

-- 恢复自身碰撞箱
local function restoreCollision()
    local char = getChar()
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

local function startFlight()
    local char = getChar()
    local hum = getHum()
    if not char or not hum then return end
    for _, state in ipairs(Enum.HumanoidStateType:GetEnumItems()) do hum:SetStateEnabled(state, false) end
    hum:ChangeState(Enum.HumanoidStateType.Swimming)
    local attachPart = hum.RigType == Enum.HumanoidRigType.R6 and char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if not attachPart then return end
    bg = Instance.new("BodyGyro")
    bg.P = 9e4; bg.MaxTorque = Vector3.new(9e9,9e9,9e9); bg.CFrame = attachPart.CFrame; bg.Parent = attachPart
    bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(0,0.1,0); bv.MaxForce = Vector3.new(9e9,9e9,9e9); bv.Parent = attachPart
    hum.PlatformStand = true; char.Animate.Disabled = true
    local animator = hum:FindFirstChildOfClass("Animator")
    if animator then for _, t in pairs(animator:GetPlayingAnimationTracks()) do t:Stop(0) end end
    startTranslateBy()
    removeCollision()
end

local function stopFlight()
    nowe = false; stopTranslateBy()
    if bg then bg:Destroy(); bg = nil end
    if bv then bv:Destroy(); bv = nil end
    local char = getChar(); local hum = getHum()
    if hum then hum.PlatformStand = false; for _, s in ipairs(Enum.HumanoidStateType:GetEnumItems()) do hum:SetStateEnabled(s, true) end end
    if char then char.Animate.Disabled = false end
    restoreCollision()
end

local function getFlyingAnimID()
    return speedMode == "slow" and ANIMS.FLYING_SLOW or ANIMS.FLYING_FAST
end

local function getCameraPitch()
    return math.asin(camera.CFrame.LookVector.Y)
end

-- 防甩飞
local function startAntiStiff()
    if antiStiffConn then antiStiffConn:Disconnect() end
    antiStiffActive = true
    antiStiffConn = RunService.Stepped:Connect(function()
        if not antiStiffActive then return end
        local char = getChar(); local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hum and hrp then
            hum.PlatformStand = false; hum.Sit = false; hum.AutoRotate = true
            local state = hum:GetState()
            if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Ragdoll then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
    end)
end

local function stopAntiStiff()
    antiStiffActive = false
    if antiStiffConn then antiStiffConn:Disconnect(); antiStiffConn = nil end
end

-- 冲击波特效
local function spawnShockwave()
    local char = getChar(); if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
    local wave = create("Part", { Shape = Enum.PartType.Ball, Size = Vector3.new(2,2,2), Position = root.Position - Vector3.new(0,3,0), Material = Enum.Material.ForceField, Color = Color3.fromRGB(255,255,255), Transparency = 0.2, Anchored = true, CanCollide = false, Parent = workspace })
    local light = create("PointLight", { Color = Color3.fromRGB(100,200,255), Range = 20, Brightness = 4, Parent = wave })
    task.spawn(function() for i=1,8 do wave.Size += Vector3.new(3,3,3); wave.Transparency += 0.1; light.Brightness -= 0.5; task.wait(0.04) end wave:Destroy() end)
end

-- 激光眼
local function fireLaser()
    local char = getChar()
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local eyeOffset = Vector3.new(0.3, 0.2, 0.5)
    local leftEye = head.CFrame * CFrame.new(-eyeOffset.X, eyeOffset.Y, -eyeOffset.Z)
    local rightEye = head.CFrame * CFrame.new(eyeOffset.X, eyeOffset.Y, -eyeOffset.Z)
    local function createBeam(origin)
        local part = Instance.new("Part")
        part.Size = Vector3.new(0.2, 0.2, 50)
        part.CFrame = origin * CFrame.new(0, 0, -25)
        part.Material = Enum.Material.Neon
        part.Color = Color3.fromRGB(255, 0, 0)
        part.Transparency = 0.5
        part.Anchored = true
        part.CanCollide = false
        part.Parent = workspace
        local rayOrigin = origin.Position
        local rayDir = origin.LookVector * 50
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        rayParams.FilterDescendantsInstances = {char}
        local result = workspace:Raycast(rayOrigin, rayDir, rayParams)
        if result then
            part.Size = Vector3.new(0.2, 0.2, (result.Position - rayOrigin).Magnitude)
            part.CFrame = CFrame.lookAt(rayOrigin, result.Position) * CFrame.new(0, 0, -part.Size.Z / 2)
            if result.Instance then
                local em = Instance.new("ParticleEmitter")
                em.Texture = "rbxasset://textures/particles/sparkles_main.dds"
                em.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
                em.Size = NumberSequence.new(0.3)
                em.Lifetime = NumberRange.new(0.5)
                em.Rate = 50
                em.Parent = result.Instance
                Debris:AddItem(em, 0.5)
            end
        else
            part.CFrame = origin * CFrame.new(0, 0, -25)
        end
        Debris:AddItem(part, 0.1)
    end
    createBeam(leftEye)
    createBeam(rightEye)
end

local function stopLaser()
    laserActive = false
    if laserBeam1 then laserBeam1:Disconnect(); laserBeam1 = nil end
end

local function restoreNormalAnim()
    if not nowe then return end
    local hum = getHum()
    local isMoving = hum and hum.MoveDirection.Magnitude > 0.1 and not isRising
    if isMoving then
        if idleTrack then idleTrack:Stop(0.2); idleTrack = nil end
        if not flyTrack or not flyTrack.IsPlaying then flyTrack = playAnim(getFlyingAnimID(), true) end
    else
        if flyTrack then flyTrack:Stop(0.2); flyTrack = nil end
        if not idleTrack or not idleTrack.IsPlaying then idleTrack = playAnim(getCurrentIdleAnimID(), true) end
    end
end

local function takeOff()
    if flying or landing then return end
    flying = true; stopAllAnimTracks(); moonActive = false
    startAntiStiff()
    local char = getChar(); local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then root.Anchored = true end
    local track = playAnim(ANIMS.TAKEOFF, false, 4)
    if track then track.Stopped:Wait() end
    currentActionTrack = nil
    if root then root.Anchored = false end
    if not flying then return end
    nowe = true; startFlight()
    spawnShockwave()
    isRising = true; if bv then bv.Velocity = Vector3.new(0, 12, 0) end
    task.wait(0.4); isRising = false; if bv then bv.Velocity = Vector3.new(0, 0.1, 0) end
    idleTrack = playAnim(getCurrentIdleAnimID(), true)
    -- 姿态
    task.spawn(function()
        while nowe do
            RunService.RenderStepped:Wait()
            if not nowe or not bg or not bg.Parent then break end
            local hum = getHum(); if not hum then break end
            local isMoving = hum.MoveDirection.Magnitude > 0.1 and not isRising
            if isMoving then
                local flatDir = Vector3.new(hum.MoveDirection.X, 0, hum.MoveDirection.Z)
                if flatDir.Magnitude < 0.01 then flatDir = Vector3.new(camera.CFrame.LookVector.X, 0, camera.CFrame.LookVector.Z).Unit end
                flatDir = flatDir.Unit
                if speedMode == "fast" then
                    local pitch = getCameraPitch(); local tilt = -math.pi/2 + pitch * 0.5
                    tilt = math.clamp(tilt, -math.pi/2 - 1, -math.pi/2 + 1)
                    bg.CFrame = CFrame.lookAt(Vector3.zero, flatDir) * CFrame.Angles(tilt, 0, 0)
                else bg.CFrame = CFrame.lookAt(Vector3.zero, flatDir) end
            else
                local flatCf = Vector3.new(camera.CFrame.LookVector.X, 0, camera.CFrame.LookVector.Z).Unit
                bg.CFrame = CFrame.lookAt(Vector3.zero, flatCf)
            end
        end
    end)
    -- 动画
    task.spawn(function()
        while nowe do
            local hum = getHum(); local isMoving = hum and hum.MoveDirection.Magnitude > 0.1
            if not moonActive then
                if isMoving and not isRising then
                    if idleTrack then idleTrack:Stop(0.2); idleTrack = nil end
                    if not flyTrack or not flyTrack.IsPlaying then flyTrack = playAnim(getFlyingAnimID(), true) end
                else
                    if flyTrack then flyTrack:Stop(0.2); flyTrack = nil end
                    if not idleTrack or not idleTrack.IsPlaying then idleTrack = playAnim(getCurrentIdleAnimID(), true) end
                end
            end
            RunService.Heartbeat:Wait()
        end
    end)
end

local function land()
    if not flying or landing then return end
    landing = true; flying = false; moonActive = false
    stopAntiStiff()
    stopFlight(); stopAllAnimTracks()
    local char = getChar(); local hum = getHum()
    if hum then hum.PlatformStand = false; for _, s in ipairs(Enum.HumanoidStateType:GetEnumItems()) do hum:SetStateEnabled(s, true) end end
    if char then char.Animate.Disabled = false end
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root and root.Position.Y < -20 then
        root.CFrame = CFrame.new(root.Position.X, 50, root.Position.Z)
    end
    landing = false; stopAllAnimTracks()
end

-- ★ 玩家/坐标模式：落地动画3倍速，使用BodyPosition固定地面
local function startTeleportSequence(targetPlayer)
    if teleportActive then return end
    teleportActive = true

    -- 关闭超人飞行（如果正在飞行），直接停止不做位置修正
    if nowe then
        stopFlight()
        stopAllAnimTracks()
        local char = getChar()
        local hum = getHum()
        if hum then
            hum.PlatformStand = false
            for _, s in ipairs(Enum.HumanoidStateType:GetEnumItems()) do
                hum:SetStateEnabled(s, true)
            end
        end
        if char then char.Animate.Disabled = false end
        flying = false
        nowe = false
        moonActive = false
        stopAntiStiff()
    end

    local char = player.Character
    if not char then teleportActive = false; return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then teleportActive = false; return end

    -- 1. 在原地播放起飞动画（4倍速）
    root.Anchored = true
    stopAllAnimTracks()
    local track = playAnim(ANIMS.TAKEOFF, false, 4)
    if track then track.Stopped:Wait() end
    root.Anchored = false

    -- 2. 快速向上移动一小段
    local bvUp = Instance.new("BodyVelocity")
    bvUp.Velocity = Vector3.new(0, 200, 0)
    bvUp.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bvUp.Parent = root
    task.wait(0.3)
    bvUp:Destroy()

    -- 3. 瞬移到目标玩家旁边
    local targetChar = targetPlayer.Character
    if not targetChar or not targetChar:FindFirstChild("HumanoidRootPart") then
        teleportActive = false
        return
    end
    local targetRoot = targetChar.HumanoidRootPart
    local targetPos = targetRoot.CFrame * CFrame.new(3, 0, 0) -- 目标右侧3 studs

    -- 4. 精准贴地：射线检测找到地面高度
    local function findGround(pos)
        local rayOrigin = pos + Vector3.new(0, 10, 0)
        local rayDir = Vector3.new(0, -50, 0)
        local result = workspace:Raycast(rayOrigin, rayDir)
        if result then
            return result.Position.Y + 3  -- 加上角色身高偏移
        else
            return pos.Y
        end
    end
    local groundY = findGround(targetPos.Position)
    root.CFrame = CFrame.new(targetPos.Position.X, groundY, targetPos.Position.Z)

    -- 5. ★ 使用BodyPosition轻柔固定在地面，而不是锚定
    local bodyPos = Instance.new("BodyPosition")
    bodyPos.Position = root.Position
    bodyPos.MaxForce = Vector3.new(100000, 100000, 100000)
    bodyPos.P = 10000
    bodyPos.D = 500
    bodyPos.Parent = root

    -- 6. 播放落地动画（3倍速）
    stopAllAnimTracks()
    local landTrack = playAnim(ANIMS.LANDING, false, 3)  -- ★ 3倍速
    if landTrack then
        landTrack.Stopped:Connect(function()
            -- 动画结束后移除BodyPosition，角色自然站立
            if bodyPos then
                bodyPos:Destroy()
            end
            teleportActive = false
        end)
    else
        -- 如果动画加载失败，直接清理
        if bodyPos then bodyPos:Destroy() end
        teleportActive = false
    end
end

-- ==================== UI ====================
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "FlyMinUI"; screenGui.ResetOnSpawn = false

-- 使按钮可拖动的函数
local function makeDraggable(btn)
    btn.Active = true
    local dragInput, dragStart, startPos
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input; dragStart = input.Position; startPos = btn.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragInput = nil end end)
        end
    end)
    btn.InputChanged:Connect(function(input)
        if dragInput and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- 超人模式按钮
local flyBtn = Instance.new("TextButton", screenGui)
flyBtn.Size = UDim2.new(0, 120, 0, 40); flyBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
flyBtn.Text = "超人模式"; flyBtn.Font = Enum.Font.GothamBold; flyBtn.TextSize = 16; flyBtn.TextColor3 = Color3.new(1, 1, 1)
flyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200); flyBtn.BackgroundTransparency = 0.3; flyBtn.BorderSizePixel = 0; flyBtn.AutoButtonColor = false
Instance.new("UICorner", flyBtn).CornerRadius = UDim.new(0, 12)
makeDraggable(flyBtn)

-- 玩家/坐标模式按钮
local teleBtn = Instance.new("TextButton", screenGui)
teleBtn.Size = UDim2.new(0, 130, 0, 40); teleBtn.Position = UDim2.new(0.05, 130, 0.4, 0)
teleBtn.Text = "玩家/坐标模式"; teleBtn.Font = Enum.Font.GothamBold; teleBtn.TextSize = 13; teleBtn.TextColor3 = Color3.new(1, 1, 1)
teleBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 100); teleBtn.BackgroundTransparency = 0.3; teleBtn.BorderSizePixel = 0; teleBtn.AutoButtonColor = false
Instance.new("UICorner", teleBtn).CornerRadius = UDim.new(0, 8)
makeDraggable(teleBtn)

-- 玩家列表
local playerListFrame = Instance.new("Frame", screenGui)
playerListFrame.Size = UDim2.new(0, 150, 0, 200)
playerListFrame.Position = UDim2.new(0.8, -75, 0.5, -100)
playerListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
playerListFrame.BackgroundTransparency = 0.2
playerListFrame.BorderSizePixel = 0
playerListFrame.Visible = false
Instance.new("UICorner", playerListFrame).CornerRadius = UDim.new(0, 8)

local scrollFrame = Instance.new("ScrollingFrame", playerListFrame)
scrollFrame.Size = UDim2.new(1, -10, 1, -10)
scrollFrame.Position = UDim2.new(0, 5, 0, 5)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ScrollBarThickness = 4

local listLayout = Instance.new("UIListLayout", scrollFrame)
listLayout.Padding = UDim.new(0, 4)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

teleBtn.MouseButton1Click:Connect(function()
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            local btn = Instance.new("TextButton", scrollFrame)
            btn.Size = UDim2.new(1, 0, 0, 28)
            btn.Text = p.Name
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 12
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            btn.BackgroundTransparency = 0.3
            btn.BorderSizePixel = 0
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
            btn.MouseButton1Click:Connect(function()
                playerListFrame.Visible = false
                startTeleportSequence(p)
            end)
        end
    end
    playerListFrame.Visible = not playerListFrame.Visible
end)

-- 功能按钮容器