do
    local qot = queue_on_teleport or (syn and syn.queue_on_teleport)
    local checks = {
        { "getrawmetatable", getrawmetatable },
        { "setreadonly", setreadonly },
        { "newcclosure", newcclosure },
        { "getnamecallmethod", getnamecallmethod },
        { "getgc", getgc },
        { "queue_on_teleport", qot },
    }
    local missing, report = {}, "[VR Hands No-VR] UNC test:\n"
    for _, c in ipairs(checks) do
        local ok = type(c[2]) == "function"
        report = report .. (" [%s] %s\n"):format(ok and "+" or "-", c[1])
        if not ok then table.insert(missing, c[1]) end
    end
    print(report)
    if #missing > 0 then
        warn("[VR Hands No-VR] Missing: " .. table.concat(missing, ", "))
        return
    end
    print("[VR Hands No-VR] UNC test passed - launching.")
end

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local hrs = [==[
local env = (getgenv and getgenv()) or _G
if env.__NoVR_Running then return end
env.__NoVR_Running = true

local VRService = game:GetService("VRService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local identity = CFrame.identity

local HOOK_OK = false
pcall(function()
    local mt = getrawmetatable(game)
    local oldIndex = mt.__index
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__index = newcclosure(function(self, k)
        if k == "VREnabled" and (self == VRService or self == UIS) then return true end
        return oldIndex(self, k)
    end)
    mt.__namecall = newcclosure(function(self, ...)
        if self == VRService then
            local m = getnamecallmethod()
            if m == "GetUserCFrameEnabled" then return true end
            if m == "GetUserCFrame" then return identity end
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
    HOOK_OK = true
end)
print("[NoVR] VRService hook: " .. tostring(HOOK_OK))

task.spawn(function()
    local function ensureFolder(p, n)
        local f = p:FindFirstChild(n)
        if not f then f = Instance.new("Folder"); f.Name = n; f.Parent = p end
        return f
    end
    local function ensurePart(p, n)
        local x = p:FindFirstChild(n)
        if not x then
            x = Instance.new("Part"); x.Name = n
            x.Anchored = true; x.CanCollide = false; x.Transparency = 1
            x.Size = Vector3.new(1,1,1); x.Parent = p
        end
        return x
    end
    local function populate(cam)
        if not cam then return end
        ensurePart(ensureFolder(cam, "VRCoreEffectParts"), "Cursor")
        ensurePart(ensureFolder(cam, "VRCorePanelParts"), "BottomBar_Part")
    end
    populate(workspace.CurrentCamera)
    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        populate(workspace.CurrentCamera)
    end)
    local t0 = os.clock()
    while os.clock() - t0 < 30 do
        populate(workspace.CurrentCamera)
        task.wait(0.1)
    end
end)

local function naturalSway(t, seed)
    return math.sin(t * 0.63 + seed) * 0.55
         + math.sin(t * 1.19 + seed * 2.71) * 0.28
         + math.sin(t * 1.87 + seed * 5.13) * 0.17
end
local function slowDrift(t, seed)
    return math.sin(t * 0.11 + seed) * 0.5
         + math.sin(t * 0.23 + seed * 2.31) * 0.3
         + math.sin(t * 0.43 + seed * 3.77) * 0.2
end
local function breathDrift(t, seed)
    return math.sin(t * 0.07 + seed) * 0.6
         + math.sin(t * 0.13 + seed * 1.87) * 0.4
end

local D = math.rad
local function R(x,y,z) return CFrame.fromEulerAnglesXYZ(D(x or 0), D(y or 0), D(z or 0)) end

local GESTURES = {
    wave = { dur = 2.4, kfs = {
        {0.00, Vector3.new(0,0,0),             CFrame.new()},
        {0.30, Vector3.new(0.20, 0.30, -0.10), R(0, 0, -35)},
        {0.55, Vector3.new(0.05, 0.30, -0.10), R(0, 0, -35)},
        {0.80, Vector3.new(0.35, 0.30, -0.10), R(0, 0, -35)},
        {1.05, Vector3.new(0.05, 0.30, -0.10), R(0, 0, -35)},
        {1.30, Vector3.new(0.35, 0.30, -0.10), R(0, 0, -35)},
        {1.55, Vector3.new(0.20, 0.30, -0.10), R(0, 0, -35)},
        {1.90, Vector3.new(0.15, 0.18, -0.08), R(0, 0, -15)},
        {2.40, Vector3.new(0,0,0),             CFrame.new()},
    }},
    come = { dur = 2.2, kfs = {
        {0.00, Vector3.new(0,0,0),             CFrame.new()},
        {0.30, Vector3.new(0.15, 0.22, -0.15), R(-25, 0, -35)},
        {0.50, Vector3.new(0.15, 0.22, -0.15), R( 45, 0, -35)},
        {0.70, Vector3.new(0.15, 0.22, -0.15), R(-25, 0, -35)},
        {0.90, Vector3.new(0.15, 0.22, -0.15), R( 45, 0, -35)},
        {1.10, Vector3.new(0.15, 0.22, -0.15), R(-25, 0, -35)},
        {1.30, Vector3.new(0.15, 0.22, -0.15), R( 45, 0, -35)},
        {1.55, Vector3.new(0.15, 0.22, -0.15), R( 10, 0, -35)},
        {2.20, Vector3.new(0,0,0),             CFrame.new()},
    }},
    thumb = { dur = 2.0, kfs = {
        {0.00, Vector3.new(0,0,0),             CFrame.new()},
        {0.40, Vector3.new(0.18, 0.25, -0.18), R(-15, 0, -30)},
        {1.40, Vector3.new(0.18, 0.25, -0.18), R(-15, 0, -30)},
        {2.00, Vector3.new(0,0,0),             CFrame.new()},
    }},
    point = { dur = 1.8, kfs = {
        {0.00, Vector3.new(0,0,0),             CFrame.new()},
        {0.40, Vector3.new(0.10, 0.15, -0.35), R(-10, 0, 0)},
        {1.40, Vector3.new(0.10, 0.15, -0.35), R(-10, 0, 0)},
        {1.80, Vector3.new(0,0,0),             CFrame.new()},
    }},
    fist = { dur = 3.2, kfs = {
        {0.00, Vector3.new(0,0,0),                CFrame.new()},
        {0.45, Vector3.new(0.05, 0.30, -0.15),    R(-15, 0, -20)},
        {0.90, Vector3.new(-0.05, 0.40, -0.45),   R(-40, 0, -35)},
        {1.15, Vector3.new(-0.05, 0.40, -0.45),   R(-25, 0, -35)},
        {1.40, Vector3.new(-0.05, 0.40, -0.45),   R(-55, 0, -35)},
        {1.65, Vector3.new(-0.05, 0.40, -0.45),   R(-25, 0, -35)},
        {1.90, Vector3.new(-0.05, 0.40, -0.45),   R(-55, 0, -35)},
        {2.15, Vector3.new(-0.05, 0.40, -0.45),   R(-25, 0, -35)},
        {2.40, Vector3.new(-0.05, 0.40, -0.45),   R(-50, 0, -35)},
        {2.85, Vector3.new(0.05, 0.22, -0.18),    R(-15, 0, -20)},
        {3.20, Vector3.new(0,0,0),                CFrame.new()},
    }},
}

local function sampleGesture(g, t)
    local kfs = g.kfs
    if t <= kfs[1][1] then return kfs[1][2], kfs[1][3] end
    if t >= kfs[#kfs][1] then return kfs[#kfs][2], kfs[#kfs][3] end
    for i = 1, #kfs - 1 do
        local a, b = kfs[i], kfs[i+1]
        if t >= a[1] and t <= b[1] then
            local f = (t - a[1]) / (b[1] - a[1])
            f = f * f * (3 - 2 * f)
            return a[2]:Lerp(b[2], f), a[3]:Lerp(b[3], f)
        end
    end
    return Vector3.zero, CFrame.new()
end

task.spawn(function()
    local lp = Players.LocalPlayer
    while not lp do task.wait() lp = Players.LocalPlayer end
    local uid = tostring(lp.UserId)

    local rig, vrPlayers
    local t0 = os.clock()
    local reHookTick = 0
    while os.clock() - t0 < 60 do
        vrPlayers = workspace:FindFirstChild("VRPlayers")
        if vrPlayers then
            rig = vrPlayers:FindFirstChild(uid)
            if rig then break end
        end
        if os.clock() - reHookTick > 5 then
            reHookTick = os.clock()
            pcall(function()
                local mt = getrawmetatable(game)
                local oldIndex = mt.__index
                setreadonly(mt, false)
                mt.__index = newcclosure(function(self, k)
                    if k == "VREnabled" and (self == VRService or self == UIS) then return true end
                    return oldIndex(self, k)
                end)
                setreadonly(mt, true)
            end)
        end
        task.wait(0.5)
    end

    if not rig then warn("[NoVR] Rig not found after 60s.") return end

    rig:WaitForChild("VRHead", 20)
    rig:WaitForChild("LeftHand", 20)
    rig:WaitForChild("RightHand", 20)

    local scaleVal = rig:FindFirstChild("VRScale")
    local cam = workspace.CurrentCamera

    local S = {
        reach = 0.80, spread = 0.34, height = -0.25,
        sens = 0.016, sensPitch = 0.016, smooth = 20,
        gyroEnabled = true,
        gyroRotK = 1.40,
        gyroPosK = 1.60,
        gyroPosMax = 0.4,
        gyroRotSmooth = 12,
        gyroRotMax = 0.9,
        gyroAngleMax = 1.2,
        handMirrorL = 1.0, handMirrorR = -1.0,
        swayEnabled = true,
        handSway = 0.22,
        handRotSway = 0.20,
        headSwayYaw = 0.040,
        headSwayPitch = 0.028,
        headSwayPos = 0.018,
        breathAmp = 0.012,
        breathSpeed = 0.28,
        breathHeadK = 0.6,
        gestureBlend = 12,
        moveK = 0.16, speedMult = 0.2,
        moveAccel = 7.0,
        moveDecel = 4.0,
        scale = 10, grabRadiusMult = 3.2,
        toggleGrabMode = false, look = true,
        handInertia = 0.5,
        handInertiaDecay = 6,
        rollK = 0.30, rollMax = 0.55,
        rollSmooth = 6, rollReturnSmooth = 3.5,
        pitchTiltK = 0.25, pitchTiltMax = 0.45,
        pitchTiltSmooth = 6, pitchTiltReturnSmooth = 3.5,
        manualTiltMax = 1.5708,
        manualReturnSmooth = 6,
    }

    local gyroBase = nil
    local gyroNow = nil
    local swayOffsetL, swayOffsetR = Vector3.zero, Vector3.zero
    local rotL, rotR = CFrame.new(), CFrame.new()
    local gyroPosL, gyroPosR = Vector3.zero, Vector3.zero
    local handInertiaVec = Vector3.zero
    local prevRotForInertia = CFrame.new()
    local moveVel = Vector3.zero

    local gestureCur = nil
    local gestureT = 0
    local gestureHand = "R"
    local gesturePosL, gesturePosR = Vector3.zero, Vector3.zero
    local gestureRotL, gestureRotR = CFrame.new(), CFrame.new()

    local spinMode = false
    local spinAngle = 0

    local grabOverride = { L = false, R = false }

    local roll = 0
    local pitchTilt = 0
    local manualRoll = 0
    local manualPitch = 0
    local headDragging = false

    local autoTiltEnabled = true

    local function gesturePlay(name, hand)
        local g = GESTURES[name]
        if not g then return end
        gestureCur = g
        gestureT = 0
        gestureHand = hand or "R"
    end

    local function refreshInput()
        for _, o in pairs(getgc(true)) do
            if type(o) == "table" and rawget(o,"directionLateral") ~= nil
            and rawget(o,"rFist") ~= nil and rawget(o,"turnDirection") ~= nil then
                if o ~= Input then Input = o end
                return Input
            end
        end
        return Input
    end

    local ok, VRUtils = pcall(function()
        return require(lp.PlayerScripts.ClientLoader.PlayerModule.VRModule.VRUtils)
    end)
    if ok and type(VRUtils) == "table" then
        VRUtils.GetUserCFrame = function(uc, scale)
            scale = scale or cam.HeadScale
            if scale <= 1 then scale = math.max((scaleVal and scaleVal.Value or 1) * 60, 6) end
            local baseC, swayOff, rot, gPos, gRot, gPos2
            if uc == Enum.UserCFrame.LeftHand then
                baseC = CFrame.new(-S.spread, S.height, -S.reach)
                swayOff = swayOffsetL; rot = rotL
                gPos = gesturePosL; gRot = gestureRotL
                gPos2 = gyroPosL
            elseif uc == Enum.UserCFrame.RightHand then
                baseC = CFrame.new(S.spread, S.height, -S.reach)
                swayOff = swayOffsetR; rot = rotR
                gPos = gesturePosR; gRot = gestureRotR
                gPos2 = gyroPosR
            else
                return identity
            end
            local iner = handInertiaVec
            if uc == Enum.UserCFrame.LeftHand and grabOverride.L then iner = Vector3.zero end
            if uc == Enum.UserCFrame.RightHand and grabOverride.R then iner = Vector3.zero end
            local pos = (baseC.Position + swayOff + gPos + gPos2 + iner) * scale
            return CFrame.new(pos) * rot * gRot
        end
    end

    local vrm, Input
    for _ = 1, 60 do
        for _, o in pairs(getgc(true)) do
            if type(o) == "table" then
                if not Input and rawget(o,"directionLateral") ~= nil
                and rawget(o,"rFist") ~= nil and rawget(o,"turnDirection") ~= nil then
                    Input = o
                end
                if not vrm and rawget(o,"HeadsetPart") ~= nil and rawget(o,"Input") ~= nil
                and rawget(o,"CharacterScale") ~= nil and rawget(o,"DataManager") ~= nil then
                    vrm = o
                    if not Input then Input = rawget(o,"Input") end
                end
            end
        end
        if Input and vrm then break end
        task.wait(0.2)
    end

    task.spawn(function()
        for _ = 1, 100 do
            pcall(function() RunService:UnbindFromRenderStep("Inputs") end)
            task.wait(0.1)
        end
    end)

    if vrm then
        pcall(function()
            if vrm.PropManager then
                local pmMT = getrawmetatable(vrm.PropManager)
                if pmMT and rawget(pmMT, "GetBestGrabPartInRadius") then
                    local orig = pmMT.GetBestGrabPartInRadius
                    setreadonly(pmMT, false)
                    pmMT.GetBestGrabPartInRadius = function(self, root, prox, radius, scale, ...)
                        local comp = 10 / math.max(S.scale, 0.1)
                        return orig(self, root, prox, radius * comp * S.grabRadiusMult, scale, ...)
                    end
                    setreadonly(pmMT, true)
                end
            end
            if vrm.CharacterManager then
                local cmMT = getrawmetatable(vrm.CharacterManager)
                if cmMT and rawget(cmMT, "GetClosestCharacterInRadius") then
                    local orig = cmMT.GetClosestCharacterInRadius
                    setreadonly(cmMT, false)
                    cmMT.GetClosestCharacterInRadius = function(self, pos, radius, ...)
                        local comp = 10 / math.max(S.scale, 0.1)
                        return orig(self, pos, radius * comp * S.grabRadiusMult, ...)
                    end
                    setreadonly(cmMT, true)
                end
            end
        end)
    end

    task.spawn(function()
        while true do
            task.wait(2)
            refreshInput()
        end
    end)

    local function setScale(n)
        n = math.clamp(n, 0.1, 100)
        S.scale = n
        if scaleVal then pcall(function() scaleVal.Value = n / 10 end) end
        if vrm and vrm.DataManager and vrm.DataManager.SettingsManager then
            pcall(function() vrm.DataManager.SettingsManager:SetValue("vrscale", n) end)
        end
    end
    setScale(S.scale)
    cam.HeadLocked = true

    local yaw, pitch
    do
        local lv = cam.CFrame.LookVector
        yaw = math.atan2(-lv.X, -lv.Z)
        pitch = math.asin(math.clamp(lv.Y, -1, 1))
    end
    local targetYaw, targetPitch = yaw, pitch
    local camPos = cam.CFrame.Position
    prevRotForInertia = CFrame.fromEulerAnglesYXZ(pitch, yaw, 0)
    local keys = {}

    local function setLook(v)
        S.look = v
        if not UIS.TouchEnabled then
            UIS.MouseBehavior = v and Enum.MouseBehavior.LockCenter or Enum.MouseBehavior.Default
            UIS.MouseIconEnabled = not v
        end
    end
    setLook(S.look)

    if UIS.TouchEnabled then
        pcall(function()
            UIS.DeviceRotationChanged:Connect(function(_, cf)
                if not cf then return end
                gyroNow = cf
                if not gyroBase then gyroBase = cf end
            end)
        end)
    end

    UIS.InputBegan:Connect(function(io)
        if io.UserInputType == Enum.UserInputType.Keyboard then
            keys[io.KeyCode] = true
            if io.KeyCode == Enum.KeyCode.LeftAlt then setLook(not S.look) end
            if io.KeyCode == Enum.KeyCode.Equals then setScale(S.scale + 1) end
            if io.KeyCode == Enum.KeyCode.Minus then setScale(S.scale - 1) end
            if io.KeyCode == Enum.KeyCode.LeftBracket then S.grabRadiusMult = math.clamp(S.grabRadiusMult - 0.1, 0.1, 10) end
            if io.KeyCode == Enum.KeyCode.RightBracket then S.grabRadiusMult = math.clamp(S.grabRadiusMult + 0.1, 0.1, 10) end
            if io.KeyCode == Enum.KeyCode.Semicolon then S.speedMult = math.clamp(S.speedMult - 0.1, 0.1, 10) end
            if io.KeyCode == Enum.KeyCode.Quote then S.speedMult = math.clamp(S.speedMult + 0.1, 0.1, 10) end
            if io.KeyCode == Enum.KeyCode.G then S.toggleGrabMode = not S.toggleGrabMode end
            if io.KeyCode == Enum.KeyCode.Comma then
                S.sens = math.clamp(S.sens - 0.002, 0.002, 0.05); S.sensPitch = S.sens
            end
            if io.KeyCode == Enum.KeyCode.Period then
                S.sens = math.clamp(S.sens + 0.002, 0.002, 0.05); S.sensPitch = S.sens
            end
            if io.KeyCode == Enum.KeyCode.One then gesturePlay("wave", "R") end
            if io.KeyCode == Enum.KeyCode.Two then spinMode = not spinMode; spinAngle = 0 end
            if io.KeyCode == Enum.KeyCode.Three then gesturePlay("come", "R") end
            if io.KeyCode == Enum.KeyCode.Four then gesturePlay("thumb", "R") end
            if io.KeyCode == Enum.KeyCode.Five then gesturePlay("point", "R") end
            if io.KeyCode == Enum.KeyCode.Six then gesturePlay("fist", "R") end

            if io.KeyCode == Enum.KeyCode.E then
                refreshInput()
                if Input then
                    if S.toggleGrabMode then
                        Input.rIndex = Input.rIndex == 1 and 0 or 1
                        if Input.rIndex == 1 then Input.rFist = 0; Input.rThumb = 0 end
                    else
                        Input.rIndex = 1; Input.rFist = 0; Input.rThumb = 0
                        grabOverride.R = true
                        task.delay(0.2, function() grabOverride.R = false end)
                    end
                end
            end
            if io.KeyCode == Enum.KeyCode.Q then
                refreshInput()
                if Input then
                    if S.toggleGrabMode then
                        Input.lIndex = Input.lIndex == 1 and 0 or 1
                        if Input.lIndex == 1 then Input.lFist = 0; Input.lThumb = 0 end
                    else
                        Input.lIndex = 1; Input.lFist = 0; Input.lThumb = 0
                        grabOverride.L = true
                        task.delay(0.2, function() grabOverride.L = false end)
                    end
                end
            end
        elseif io.UserInputType == Enum.UserInputType.MouseButton1 then
            refreshInput()
            if Input then
                if S.toggleGrabMode then
                    Input.rFist = Input.rFist == 1 and 0 or 1
                    Input.rIndex = Input.rIndex == 1 and 0 or 1
                else
                    Input.rFist = 1; Input.rIndex = 1
                    grabOverride.R = true
                    task.delay(0.2, function() grabOverride.R = false end)
                end
            end
        elseif io.UserInputType == Enum.UserInputType.MouseButton2 then
            refreshInput()
            if Input then
                if S.toggleGrabMode then
                    Input.lFist = Input.lFist == 1 and 0 or 1
                    Input.lIndex = Input.lIndex == 1 and 0 or 1
                else
                    Input.lFist = 1; Input.lIndex = 1
                    grabOverride.L = true
                    task.delay(0.2, function() grabOverride.L = false end)
                end
            end
        end
    end)

    UIS.InputEnded:Connect(function(io)
        if io.UserInputType == Enum.UserInputType.Keyboard then
            keys[io.KeyCode] = false
            if Input and io.KeyCode == Enum.KeyCode.E and not S.toggleGrabMode then Input.rIndex = 0 end
            if Input and io.KeyCode == Enum.KeyCode.Q and not S.toggleGrabMode then Input.lIndex = 0 end
        elseif io.UserInputType == Enum.UserInputType.MouseButton1 then
            if Input and not S.toggleGrabMode then Input.rFist = 0; Input.rIndex = 0 end
        elseif io.UserInputType == Enum.UserInputType.MouseButton2 then
            if Input and not S.toggleGrabMode then Input.lFist = 0; Input.lIndex = 0 end
        end
    end)

    UIS.InputChanged:Connect(function(io)
        if io.UserInputType == Enum.UserInputType.MouseWheel then
            S.reach = math.clamp(S.reach - io.Position.Z * 0.07, 0.05, 20)
        end
    end)

    RunService:BindToRenderStep("NoVR_Control", Enum.RenderPriority.Camera.Value + 1, function(dt)
        local t = os.clock()

        if S.look and not UIS.TouchEnabled then
            local d = UIS:GetMouseDelta()
            local comp = math.clamp(dt * 60, 0.25, 3)
            targetYaw   = targetYaw   - d.X * S.sens * comp
            targetPitch = math.clamp(targetPitch - d.Y * S.sensPitch * comp, -1.55, 1.55)
            UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
        end

        local breath = math.sin(t * S.breathSpeed * math.pi * 2) * S.breathAmp

        local swayAmp = S.swayEnabled and S.handSway or 0
        local targetSwayL = Vector3.new(
            naturalSway(t, 1.31) * swayAmp,
            naturalSway(t, 2.73) * swayAmp * 0.7 + breath,
            naturalSway(t, 4.17) * swayAmp * 0.5)
        local targetSwayR = Vector3.new(
            naturalSway(t, 5.39) * swayAmp,
            naturalSway(t, 6.81) * swayAmp * 0.7 + breath,
            naturalSway(t, 8.23) * swayAmp * 0.5)
        local aS = 1 - math.exp(-6 * dt)
        swayOffsetL = swayOffsetL:Lerp(targetSwayL, aS)
        swayOffsetR = swayOffsetR:Lerp(targetSwayR, aS)

        if S.gyroEnabled and gyroBase and gyroNow then
            local rel = gyroBase:Inverse() * gyroNow
            local rx, ry, rz = rel:ToEulerAnglesYXZ()
            if math.abs(rx) > S.gyroAngleMax or math.abs(ry) > S.gyroAngleMax or math.abs(rz) > S.gyroAngleMax then
                gyroBase = gyroNow
                rx, ry, rz = 0, 0, 0
            end
            rx = math.clamp(rx, -S.gyroRotMax, S.gyroRotMax)
            ry = math.clamp(ry, -S.gyroRotMax, S.gyroRotMax)
            rz = math.clamp(rz, -S.gyroRotMax, S.gyroRotMax)

            local rk = S.gyroRotK
            local targetRL = CFrame.fromEulerAnglesYXZ(
                rx * rk * S.handMirrorL, ry * rk * S.handMirrorL, rz * rk * S.handMirrorL)
            local targetRR = CFrame.fromEulerAnglesYXZ(
                rx * rk * S.handMirrorR * -1, ry * rk * S.handMirrorR * -1, rz * rk * S.handMirrorR * -1)

            if S.swayEnabled then
                targetRL = targetRL * CFrame.fromEulerAnglesYXZ(
                    naturalSway(t, 10.1) * S.handRotSway,
                    naturalSway(t, 11.3) * S.handRotSway,
                    naturalSway(t, 12.7) * S.handRotSway)
                targetRR = targetRR * CFrame.fromEulerAnglesYXZ(
                    naturalSway(t, 13.1) * S.handRotSway,
                    naturalSway(t, 14.3) * S.handRotSway,
                    naturalSway(t, 15.7) * S.handRotSway)
            end

            local aR = 1 - math.exp(-S.gyroRotSmooth * dt)
            rotL = rotL:Lerp(targetRL, aR)
            rotR = rotR:Lerp(targetRR, aR)

            local pk = S.gyroPosK
            local targetGyroL = Vector3.new(-ry * pk * S.handMirrorL, rz * pk * S.handMirrorL * 0.6, -rx * pk * 0.4)
            local targetGyroR = Vector3.new(-ry * pk * S.handMirrorR, rz * pk * S.handMirrorR * 0.6, -rx * pk * 0.4)
            local maxP = S.gyroPosMax
            if targetGyroL.Magnitude > maxP then targetGyroL = targetGyroL.Unit * maxP end
            if targetGyroR.Magnitude > maxP then targetGyroR = targetGyroR.Unit * maxP end

            local aP = 1 - math.exp(-S.gyroRotSmooth * dt)
            gyroPosL = gyroPosL:Lerp(targetGyroL, aP)
            gyroPosR = gyroPosR:Lerp(targetGyroR, aP)
        else
            local aR = math.min(dt * 6, 1)
            rotL = rotL:Lerp(CFrame.new(), aR)
            rotR = rotR:Lerp(CFrame.new(), aR)
            gyroPosL = gyroPosL:Lerp(Vector3.zero, aR)
            gyroPosR = gyroPosR:Lerp(Vector3.zero, aR)
        end

        local targetGPosL, targetGPosR = Vector3.zero, Vector3.zero
        local targetGRotL, targetGRotR = CFrame.new(), CFrame.new()
        if gestureCur then
            gestureT = gestureT + dt
            if gestureT >= gestureCur.dur then
                gestureCur = nil
                gestureT = 0
            else
                local gp, gr = sampleGesture(gestureCur, gestureT)
                local h = gestureHand
                if h == "L" then
                    targetGPosL = Vector3.new(-gp.X, gp.Y, gp.Z)
                    targetGRotL = gr
                elseif h == "R" then
                    targetGPosR = gp
                    targetGRotR = gr
                elseif h == "B" then
                    targetGPosL = Vector3.new(-gp.X, gp.Y, gp.Z)
                    targetGRotL = gr
                    targetGPosR = gp
                    targetGRotR = gr
                end
            end
        end
        local aG = 1 - math.exp(-S.gestureBlend * dt)
        gesturePosL = gesturePosL:Lerp(targetGPosL, aG)
        gesturePosR = gesturePosR:Lerp(targetGPosR, aG)
        gestureRotL = gestureRotL:Lerp(targetGRotL, aG)
        gestureRotR = gestureRotR:Lerp(targetGRotR, aG)

        if spinMode then
            spinAngle = spinAngle + dt * 35
            local spinCF = CFrame.fromEulerAnglesXYZ(0, 0, spinAngle)
            rotL = rotL * spinCF
            rotR = rotR * spinCF
        end

        local k = 1 - math.exp(-S.smooth * dt)
        local prevYaw = yaw
        local prevPitch = pitch
        yaw   = yaw   + (targetYaw   - yaw)   * k
        pitch = pitch + (targetPitch - pitch) * k

        if autoTiltEnabled then
            local yawVel = (yaw - prevYaw) / math.max(dt, 1/240)
            local autoRoll = math.clamp(yawVel * S.rollK, -S.rollMax, S.rollMax)
            local rollSpeed = (math.abs(autoRoll) > 0.005) and S.rollSmooth or S.rollReturnSmooth
            roll = roll + (autoRoll - roll) * (1 - math.exp(-rollSpeed * dt))

            local pitchVel = (pitch - prevPitch) / math.max(dt, 1/240)
            local autoPitchTilt = math.clamp(pitchVel * S.pitchTiltK, -S.pitchTiltMax, S.pitchTiltMax)
            local pitchSpeed = (math.abs(autoPitchTilt) > 0.005) and S.pitchTiltSmooth or S.pitchTiltReturnSmooth
            pitchTilt = pitchTilt + (autoPitchTilt - pitchTilt) * (1 - math.exp(-pitchSpeed * dt))
        else
            roll = roll * (1 - math.exp(-4 * dt))
            pitchTilt = pitchTilt * (1 - math.exp(-4 * dt))
        end

        if not headDragging then
            local decay = 1 - math.exp(-S.manualReturnSmooth * dt)
            manualRoll = manualRoll * (1 - decay)
            manualPitch = manualPitch * (1 - decay)
        end

        local finalRoll = roll + manualRoll
        local finalPitchOffset = pitchTilt + manualPitch

        local headSwayYawV = 0
        local headSwayPitchV = 0
        local headSwayPosV = Vector3.zero
        if S.swayEnabled then
            headSwayYawV   = (slowDrift(t, 20.1) * 0.7 + naturalSway(t, 20.1) * 0.3) * S.headSwayYaw
            headSwayPitchV = (slowDrift(t, 33.7) * 0.7 + naturalSway(t, 33.7) * 0.3) * S.headSwayPitch
            headSwayPosV   = Vector3.new(
                slowDrift(t, 22.7) * S.headSwayPos,
                slowDrift(t, 23.9) * S.headSwayPos * 1.2 + breathDrift(t, 40.3) * S.headSwayPos * 0.8,
                slowDrift(t, 25.1) * S.headSwayPos * 0.5)
        end
        local breathHead = breath * S.breathHeadK
        headSwayPosV = headSwayPosV + Vector3.new(0, breathHead, 0)
        headSwayPitchV = headSwayPitchV + breathHead * 0.4

        local finalPitch = pitch + headSwayPitchV + finalPitchOffset
        local finalYaw = yaw + headSwayYawV
        local rot = CFrame.fromEulerAnglesYXZ(finalPitch, finalYaw, finalRoll)

        local rotDelta = prevRotForInertia:Inverse() * rot
        local idy, idp, _ = rotDelta:ToEulerAnglesYXZ()
        handInertiaVec = handInertiaVec + Vector3.new(idy * S.handInertia, -idp * S.handInertia, 0)
        handInertiaVec = handInertiaVec * math.exp(-S.handInertiaDecay * dt)
        if handInertiaVec.Magnitude > 0.35 then handInertiaVec = handInertiaVec.Unit * 0.35 end
        prevRotForInertia = rot

        local hs = cam.HeadScale; if not hs or hs <= 1 then hs = S.scale * 6 end
        local spd = (10 + S.scale * 4) * hs * S.moveK * S.speedMult

        local mv = Vector3.zero
        if keys[Enum.KeyCode.W] then mv += Vector3.new(0,0,-1) end
        if keys[Enum.KeyCode.S] then mv += Vector3.new(0,0, 1) end
        if keys[Enum.KeyCode.A] then mv += Vector3.new(-1,0,0) end
        if keys[Enum.KeyCode.D] then mv += Vector3.new( 1,0,0) end
        if keys[Enum.KeyCode.Space] then mv += Vector3.new(0, 1,0) end
        if keys[Enum.KeyCode.LeftShift] then mv += Vector3.new(0,-1,0) end

        local targetVel = Vector3.zero
        if mv.Magnitude > 0 then targetVel = (rot * mv.Unit) * spd end
        local accel = (mv.Magnitude > 0) and S.moveAccel or S.moveDecel
        moveVel = moveVel:Lerp(targetVel, 1 - math.exp(-accel * dt))
        camPos = camPos + moveVel * dt

        cam.CameraType = Enum.CameraType.Scriptable
        cam.CFrame = CFrame.new(camPos + headSwayPosV) * rot

        if Input then
            Input.directionLateral = Vector2.zero
            Input.directionVertical = 0
            Input.turnDirection = 0
        end
    end)

    task.spawn(function()
        while true do
            task.wait(1)
            pcall(function()
                local cam = workspace.CurrentCamera
                if cam then
                    local tip = cam:FindFirstChild("VR_TIP")
                    if tip then tip:Destroy() end
                end
            end)
            local CoreGui
            pcall(function() CoreGui = game:GetService("CoreGui") end)
            local containers = {}
            if CoreGui then table.insert(containers, CoreGui) end
            local pg = lp:FindFirstChild("PlayerGui")
            if pg then table.insert(containers, pg) end
            local c2 = workspace.CurrentCamera
            if c2 then table.insert(containers, c2) end
            for _, container in ipairs(containers) do
                for _, child in ipairs(container:GetChildren()) do
                    if (child:IsA("ScreenGui") or child:IsA("BillboardGui")) and
                       child.Name ~= "NoVR_HUD" and child.Name ~= "NoVR_MobileControls" then
                        local n = child.Name:lower()
                        if n:match("vr") or n:match("bottom") or n:match("panel") or n:match("tutorial") then
                            pcall(function() child.Enabled = false end)
                        end
                    end
                end
            end
        end
    end)

    pcall(function()
        if UIS.TouchEnabled then return end
        local gui = Instance.new("ScreenGui")
        gui.Name = "NoVR_HUD"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true
        gui.Parent = lp:WaitForChild("PlayerGui")
        local lbl = Instance.new("TextLabel", gui)
        lbl.AnchorPoint = Vector2.new(1, 0)
        lbl.Position = UDim2.new(1, -10, 0, 10)
        lbl.Size = UDim2.new(0, 400, 0, 300)
        lbl.BackgroundColor3 = Color3.fromRGB(0,0,0); lbl.BackgroundTransparency = 0.45
        lbl.TextColor3 = Color3.fromRGB(255,255,255)
        lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.TextYAlignment = Enum.TextYAlignment.Top
        lbl.Font = Enum.Font.Code; lbl.TextSize = 13
        RunService.Heartbeat:Connect(function()
            local vrNow = false
            pcall(function() vrNow = VRService.VREnabled end)
            lbl.Text = ("[VR Hands :: No-VR]\nHook: %s | VREnabled: %s\nInput: %s | VRM: %s\nWASD - fly | LMB/RMB - grab\n1/3/4/5/6 - 手势 | 2 - 手转")
            :format(tostring(HOOK_OK), tostring(vrNow), tostring(Input ~= nil), tostring(vrm ~= nil))
        end)
    end)

    pcall(function()
        if not UIS.TouchEnabled then return end
        local mobileGui = Instance.new("ScreenGui")
        mobileGui.Name = "NoVR_MobileControls"
        mobileGui.ResetOnSpawn = false
        mobileGui.IgnoreGuiInset = true
        mobileGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        mobileGui.Parent = lp:WaitForChild("PlayerGui")

        -- ===== 统一样式的按钮工厂（黑白风，浅透明背景，白描边） =====
        local function createBtn(parent, name, pos, size, text, textSize)
            textSize = textSize or 13
            local btn = Instance.new("TextButton")
            btn.Name = name; btn.Position = pos; btn.Size = size
            btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            btn.BackgroundTransparency = 0.72
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Text = text
            btn.Font = Enum.Font.SourceSansBold
            btn.TextSize = textSize
            btn.AutoButtonColor = false
            btn.BorderSizePixel = 0
            btn.Parent = parent
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            local stroke = Instance.new("UIStroke", btn)
            stroke.Color = Color3.fromRGB(255, 255, 255)
            stroke.Transparency = 0.55
            stroke.Thickness = 1.3
            return btn
        end

        -- ✅ 独立描边辅助：先干掉弱描边，再套一层明显的白边
        local function applyStroke(btn, thickness, transparency)
            local old = btn:FindFirstChildOfClass("UIStroke")
            if old then old:Destroy() end
            local s = Instance.new("UIStroke", btn)
            s.Color = Color3.fromRGB(255, 255, 255)
            s.Thickness = thickness or 2
            s.Transparency = transparency or 0.15
            s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            return btn
        end

        local function bindPress(btn)
            btn.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.Touch then btn.BackgroundTransparency = 0.4 end
            end)
            btn.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.Touch then btn.BackgroundTransparency = 0.72 end
            end)
        end

        -- ===== 顶部 4 个按钮（固定像素宽，不重叠） =====
        local btnW = 62
        local btnGap = 4
        local btnH = 26
        local startX = -10

        local toggleUIBtn = createBtn(mobileGui, "ToggleUI",
            UDim2.new(1, startX, 0.02, 0), UDim2.fromOffset(btnW, btnH), "隐藏UI", 11)
        toggleUIBtn.AnchorPoint = Vector2.new(1, 0)

        local tiltToggleBtn = createBtn(mobileGui, "TiltToggle",
            UDim2.new(1, startX - (btnW + btnGap), 0.02, 0), UDim2.fromOffset(btnW, btnH), "侧倾开", 11)
        tiltToggleBtn.AnchorPoint = Vector2.new(1, 0)

        local funcToggleBtn = createBtn(mobileGui, "FuncToggle",
            UDim2.new(1, startX - (btnW + btnGap) * 2, 0.02, 0), UDim2.fromOffset(btnW, btnH), "功能区", 11)
        funcToggleBtn.AnchorPoint = Vector2.new(1, 0)

        local infoToggleBtn = createBtn(mobileGui, "InfoToggle",
            UDim2.new(1, startX - (btnW + btnGap) * 3, 0.02, 0), UDim2.fromOffset(btnW, btnH), "参数", 11)
        infoToggleBtn.AnchorPoint = Vector2.new(1, 0)

        local uiHidden = false
        local funcWrapVisible = true
        local infoPanelVisible = true
        local funcWrap, infoPanel

        local FUNC_Y_SHOW = 0.10
        local FUNC_Y_HIDE = -0.30
        local funcTween = nil

        local function setFuncWrapVisible(show)
            if not funcWrap then return end
            funcWrapVisible = show
            if funcTween then funcTween:Cancel() end
            if show then
                funcWrap.Visible = true
                funcTween = TweenService:Create(funcWrap,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Position = UDim2.new(0.99, 0, FUNC_Y_SHOW, 0)})
                funcTween:Play()
            else
                funcTween = TweenService:Create(funcWrap,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Position = UDim2.new(0.99, 0, FUNC_Y_HIDE, 0)})
                funcTween.Completed:Connect(function() funcWrap.Visible = false end)
                funcTween:Play()
            end
        end

        toggleUIBtn.InputBegan:Connect(function(i)
            if i.UserInputType ~= Enum.UserInputType.Touch then return end
            uiHidden = not uiHidden
            for _, child in ipairs(mobileGui:GetChildren()) do
                if child:IsA("GuiObject") and
                   child ~= toggleUIBtn and child ~= tiltToggleBtn and
                   child ~= funcToggleBtn and child ~= infoToggleBtn then
                    child.Visible = not uiHidden
                end
            end
            if not uiHidden then
                if funcWrap then funcWrap.Visible = funcWrapVisible end
                if infoPanel then infoPanel.Visible = infoPanelVisible end
            end
            toggleUIBtn.Text = uiHidden and "显示UI" or "隐藏UI"
        end)
        bindPress(toggleUIBtn)

        tiltToggleBtn.InputBegan:Connect(function(i)
            if i.UserInputType ~= Enum.UserInputType.Touch then return end
            autoTiltEnabled = not autoTiltEnabled
            tiltToggleBtn.Text = autoTiltEnabled and "侧倾开" or "侧倾关"
        end)
        bindPress(tiltToggleBtn)

        funcToggleBtn.InputBegan:Connect(function(i)
            if i.UserInputType ~= Enum.UserInputType.Touch then return end
            setFuncWrapVisible(not funcWrapVisible)
            funcToggleBtn.Text = funcWrapVisible and "功能区" or "功能区▲"
        end)
        bindPress(funcToggleBtn)

        infoToggleBtn.InputBegan:Connect(function(i)
            if i.UserInputType ~= Enum.UserInputType.Touch then return end
            infoPanelVisible = not infoPanelVisible
            if infoPanel then infoPanel.Visible = infoPanelVisible end
            infoToggleBtn.Text = infoPanelVisible and "参数" or "参数▲"
        end)
        bindPress(infoToggleBtn)

        -- ===== 手势面板 =====
        local selHand = "R"
        local gp = Instance.new("Frame")
        gp.Size = UDim2.fromScale(0.30, 0.30)
        gp.Position = UDim2.fromScale(0.02, 0.16)
        gp.AnchorPoint = Vector2.new(0, 0)
        gp.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        gp.BackgroundTransparency = 0.78
        gp.BorderSizePixel = 0
        gp.Parent = mobileGui
        Instance.new("UICorner", gp).CornerRadius = UDim.new(0, 10)
        local gpStroke = Instance.new("UIStroke", gp)
        gpStroke.Color = Color3.fromRGB(255,255,255)
        gpStroke.Transparency = 0.55
        gpStroke.Thickness = 1.5
        local pad = Instance.new("UIPadding", gp)
        pad.PaddingTop = UDim.new(0.03, 0)
        pad.PaddingBottom = UDim.new(0.03, 0)
        pad.PaddingLeft = UDim.new(0.04, 0)
        pad.PaddingRight = UDim.new(0.04, 0)

        local handBar = Instance.new("Frame")
        handBar.Size = UDim2.fromScale(1, 0.18)
        handBar.Position = UDim2.fromScale(0, 0)
        handBar.BackgroundTransparency = 1
        handBar.Parent = gp

        local tagL = createBtn(handBar, "TagL", UDim2.fromScale(0, 0), UDim2.fromScale(0.31, 1), "左手", 12)
        local tagR = createBtn(handBar, "TagR", UDim2.fromScale(0.345, 0), UDim2.fromScale(0.31, 1), "右手", 12)
        local tagB = createBtn(handBar, "TagB", UDim2.fromScale(0.69, 0), UDim2.fromScale(0.31, 1), "双手", 12)

        local function refreshHandTags()
            tagL.BackgroundColor3 = (selHand == "L") and Color3.fromRGB(255,255,255) or Color3.fromRGB(15,15,15)
            tagL.TextColor3 = (selHand == "L") and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
            tagR.BackgroundColor3 = (selHand == "R") and Color3.fromRGB(255,255,255) or Color3.fromRGB(15,15,15)
            tagR.TextColor3 = (selHand == "R") and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
            tagB.BackgroundColor3 = (selHand == "B") and Color3.fromRGB(255,255,255) or Color3.fromRGB(15,15,15)
            tagB.TextColor3 = (selHand == "B") and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
        end
        refreshHandTags()

        tagL.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then selHand = "L"; refreshHandTags() end end)
        tagR.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then selHand = "R"; refreshHandTags() end end)
        tagB.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then selHand = "B"; refreshHandTags() end end)
        for _, b in ipairs({tagL, tagR, tagB}) do bindPress(b) end

        local gArea = Instance.new("Frame")
        gArea.Size = UDim2.fromScale(1, 0.78)
        gArea.Position = UDim2.fromScale(0, 0.22)
        gArea.BackgroundTransparency = 1
        gArea.Parent = gp

        local gcols, grows = 2, 3
        local ggap = 0.05
        local gbw = (1 - ggap*(gcols-1)) / gcols
        local gbh = (1 - ggap*(grows-1)) / grows
        local function gcell(c, r) return UDim2.fromScale((gbw+ggap)*c, (gbh+ggap)*r) end

        local gNames = {"wave", "spin", "come", "thumb", "point", "fist"}
        local gLabels = {"挥手", "手转", "指人", "拇指", "指", "喝水"}
        for i = 1, 6 do
            local c = (i - 1) % 2
            local r = math.floor((i - 1) / 2)
            local b = createBtn(gArea, "G_"..gNames[i], gcell(c, r), UDim2.fromScale(gbw, gbh), gLabels[i], 13)
            local name = gNames[i]
            if i == 2 then
                b.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.Touch then
                        spinMode = not spinMode
                        spinAngle = 0
                        b.Text = spinMode and "手转●" or "手转"
                    end
                end)
            else
                b.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.Touch then gesturePlay(name, selHand) end
                end)
            end
            bindPress(b)
        end

        local vert = Instance.new("Frame")
        vert.Size = UDim2.fromScale(0.12, 0.14)
        vert.Position = UDim2.fromScale(0.02, 0.50)
        vert.AnchorPoint = Vector2.new(0, 0)
        vert.BackgroundTransparency = 1
        vert.Parent = mobileGui
        local ascend = createBtn(vert, "Ascend", UDim2.fromScale(0, 0), UDim2.fromScale(1, 0.46), "↑", 20)
        local descend = createBtn(vert, "Descend", UDim2.fromScale(0, 1), UDim2.fromScale(1, 0.46), "↓", 20)
        descend.AnchorPoint = Vector2.new(0, 1)
        local function bindKey(btn, key)
            btn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then keys[key] = true end end)
            btn.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then keys[key] = false end end)
            bindPress(btn)
        end
        bindKey(ascend, Enum.KeyCode.Space)
        bindKey(descend, Enum.KeyCode.LeftShift)

        -- ===== 左下移动轮盘（黑白，无刻度点） =====
        local stickBase = Instance.new("Frame")
        stickBase.Size = UDim2.fromOffset(160, 160) -- 👈 原来110，现在改成160，变大
        stickBase.Position = UDim2.new(0, 20, 1, -20)
        stickBase.AnchorPoint = Vector2.new(0, 1)
        stickBase.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        stickBase.BackgroundTransparency = 0.55
        stickBase.BorderSizePixel = 0
        stickBase.Parent = mobileGui
        Instance.new("UICorner", stickBase).CornerRadius = UDim.new(1, 0)
        local baseStroke = Instance.new("UIStroke", stickBase)
        baseStroke.Color = Color3.fromRGB(0, 0, 0); baseStroke.Transparency = 0.4; baseStroke.Thickness = 2

        local stickKnob = Instance.new("Frame")
        stickKnob.Size = UDim2.fromOffset(60, 60) -- 👈 原来42，现在改成60，变大
        stickKnob.AnchorPoint = Vector2.new(0.5, 0.5)
        stickKnob.Position = UDim2.fromScale(0.5, 0.5)
        stickKnob.BackgroundColor3 = Color3.fromRGB(0, 0, 0); stickKnob.BackgroundTransparency = 0.15
        stickKnob.BorderSizePixel = 0
        stickKnob.Parent = stickBase
        Instance.new("UICorner", stickKnob).CornerRadius = UDim.new(1, 0)
        local knobStroke = Instance.new("UIStroke", stickKnob)
        knobStroke.Color = Color3.fromRGB(255, 255, 255); knobStroke.Transparency = 0.2; knobStroke.Thickness = 2

        local stickTouch = nil
        local stickCenterX, stickCenterY, stickRadius = 0, 0, 0
        local DEADZONE = 0.25

        local function stickReset()
            keys[Enum.KeyCode.W] = false; keys[Enum.KeyCode.S] = false
            keys[Enum.KeyCode.A] = false; keys[Enum.KeyCode.D] = false
            stickKnob.Position = UDim2.fromScale(0.5, 0.5)
        end

        local function stickUpdate(touchPos)
            local dx = touchPos.X - stickCenterX
            local dy = touchPos.Y - stickCenterY
            local dist = math.sqrt(dx*dx + dy*dy)
            if dist > stickRadius then dx = dx / dist * stickRadius; dy = dy / dist * stickRadius end
            stickKnob.Position = UDim2.new(0.5, dx, 0.5, dy)
            local nx, ny = dx / stickRadius, dy / stickRadius
            keys[Enum.KeyCode.W] = ny < -DEADZONE
            keys[Enum.KeyCode.S] = ny >  DEADZONE
            keys[Enum.KeyCode.A] = nx < -DEADZONE
            keys[Enum.KeyCode.D] = nx >  DEADZONE
        end

        UIS.TouchStarted:Connect(function(i)
            if stickTouch then return end
            local absPos = stickBase.AbsolutePosition
            local absSize = stickBase.AbsoluteSize
            if i.Position.X >= absPos.X and i.Position.X <= absPos.X + absSize.X
               and i.Position.Y >= absPos.Y and i.Position.Y <= absPos.Y + absSize.Y then
                stickTouch = i
                stickCenterX = absPos.X + absSize.X / 2
                stickCenterY = absPos.Y + absSize.Y / 2
                stickRadius = absSize.X / 2
                stickBase.BackgroundTransparency = 0.35
                stickUpdate(i.Position)
            end
        end)
        UIS.TouchMoved:Connect(function(i)
            if i ~= stickTouch then return end
            stickUpdate(i.Position)
        end)
        UIS.TouchEnded:Connect(function(i)
            if i ~= stickTouch then return end
            stickTouch = nil
            stickBase.BackgroundTransparency = 0.55
            stickReset()
        end)

        -- ===== 右侧中部头部倾斜轮盘（80x80，黑白，无刻度点） =====
        local headBase = Instance.new("Frame")
        headBase.Size = UDim2.fromOffset(80, 80)
        headBase.Position = UDim2.new(1, -20, 0.5, 0)
        headBase.AnchorPoint = Vector2.new(1, 0.5)
        headBase.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        headBase.BackgroundTransparency = 0.55
        headBase.BorderSizePixel = 0
        headBase.Parent = mobileGui
        Instance.new("UICorner", headBase).CornerRadius = UDim.new(1, 0)
        local headStroke = Instance.new("UIStroke", headBase)
        headStroke.Color = Color3.fromRGB(0, 0, 0); headStroke.Transparency = 0.4; headStroke.Thickness = 2

        local headKnob = Instance.new("Frame")
        headKnob.Size = UDim2.fromOffset(30, 30)
        headKnob.AnchorPoint = Vector2.new(0.5, 0.5)
        headKnob.Position = UDim2.fromScale(0.5, 0.5)
        headKnob.BackgroundColor3 = Color3.fromRGB(0, 0, 0); headKnob.BackgroundTransparency = 0.15
        headKnob.BorderSizePixel = 0
        headKnob.Parent = headBase
        Instance.new("UICorner", headKnob).CornerRadius = UDim.new(1, 0)
        local headKnobStroke = Instance.new("UIStroke", headKnob)
        headKnobStroke.Color = Color3.fromRGB(255, 255, 255); headKnobStroke.Transparency = 0.2; headKnobStroke.Thickness = 2

        local headTouch = nil
        local headCenterX, headCenterY, headRadius = 0, 0, 0

        local function headUpdate(touchPos)
            local dx = touchPos.X - headCenterX
            local dy = touchPos.Y - headCenterY
            local dist = math.sqrt(dx*dx + dy*dy)
            if dist > headRadius then dx = dx / dist * headRadius; dy = dy / dist * headRadius end
            headKnob.Position = UDim2.new(0.5, dx, 0.5, dy)
            manualRoll = -(dx / headRadius) * S.manualTiltMax
            manualPitch = (dy / headRadius) * S.manualTiltMax
        end

        UIS.TouchStarted:Connect(function(i)
            if headTouch then return end
            local absPos = headBase.AbsolutePosition
            local absSize = headBase.AbsoluteSize
            if i.Position.X >= absPos.X and i.Position.X <= absPos.X + absSize.X
               and i.Position.Y >= absPos.Y and i.Position.Y <= absPos.Y + absSize.Y then
                headTouch = i
                headDragging = true
                headCenterX = absPos.X + absSize.X / 2
                headCenterY = absPos.Y + absSize.Y / 2
                headRadius = absSize.X / 2
                headBase.BackgroundTransparency = 0.35
                headUpdate(i.Position)
            end
        end)
        UIS.TouchMoved:Connect(function(i)
            if i ~= headTouch then return end
            headUpdate(i.Position)
        end)
        UIS.TouchEnded:Connect(function(i)
            if i ~= headTouch then return end
            headTouch = nil
            headDragging = false
            headBase.BackgroundTransparency = 0.55
            headKnob.Position = UDim2.fromScale(0.5, 0.5)
        end)

        -- ===== 右下抓取（4 个按钮各自独立描边） =====
        local grab = Instance.new("Frame")
        grab.Size = UDim2.fromScale(0.40, 0.26)
        grab.Position = UDim2.fromScale(0.98, 0.98)
        grab.AnchorPoint = Vector2.new(1, 1)
        grab.BackgroundTransparency = 1
        grab.Parent = mobileGui
        local gapp = 0.08
        local bw2 = (1 - gapp) / 2
        local bh2 = (1 - gapp) / 2

        local grabL  = applyStroke(createBtn(grab, "GrabL",  UDim2.fromScale(0, 0), UDim2.fromScale(bw2, bh2), "左抓", 18), 2, 0.15)
        local grabR  = applyStroke(createBtn(grab, "GrabR",  UDim2.fromScale(1, 0), UDim2.fromScale(bw2, bh2), "右抓", 18), 2, 0.15)
        grabR.AnchorPoint = Vector2.new(1, 0)
        local pinchL = applyStroke(createBtn(grab, "PinchL", UDim2.fromScale(0, 1), UDim2.fromScale(bw2, bh2), "左捏", 17), 2, 0.15)
        local pinchR = applyStroke(createBtn(grab, "PinchR", UDim2.fromScale(1, 1), UDim2.fromScale(bw2, bh2), "右捏", 17), 2, 0.15)
        pinchL.AnchorPoint = Vector2.new(0, 1)
        pinchR.AnchorPoint = Vector2.new(1, 1)

        grabL.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.Touch then
                refreshInput()
                if Input then
                    if S.toggleGrabMode then
                        Input.lFist = Input.lFist == 1 and 0 or 1
                        Input.lIndex = Input.lIndex == 1 and 0 or 1
                    else
                        Input.lFist = 1; Input.lIndex = 1
                        grabOverride.L = true
                        task.delay(0.2, function() grabOverride.L = false end)
                    end
                end
            end
        end)
        grabL.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.Touch and Input and not S.toggleGrabMode then
                Input.lFist = 0; Input.lIndex = 0
            end
        end)
        bindPress(grabL)

        grabR.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.Touch then
                refreshInput()
                if Input then
                    if S.toggleGrabMode then
                        Input.rFist = Input.rFist == 1 and 0 or 1
                        Input.rIndex = Input.rIndex == 1 and 0 or 1
                    else
                        Input.rFist = 1; Input.rIndex = 1
                        grabOverride.R = true
                        task.delay(0.2, function() grabOverride.R = false end)
                    end
                end
            end
        end)
        grabR.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.Touch and Input and not S.toggleGrabMode then
                Input.rFist = 0; Input.rIndex = 0
            end
        end)
        bindPress(grabR)

        pinchL.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.Touch then
                refreshInput()
                if Input then
                    if S.toggleGrabMode then
                        Input.lIndex = Input.lIndex == 1 and 0 or 1
                        if Input.lIndex == 1 then Input.lFist = 0; Input.lThumb = 0 end
                    else
                        Input.lIndex = 1; Input.lFist = 0; Input.lThumb = 0
                        grabOverride.L = true
                        task.delay(0.2, function() grabOverride.L = false end)
                    end
                end
            end
        end)
        pinchL.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.Touch and Input and not S.toggleGrabMode then
                Input.lIndex = 0
            end
        end)
        bindPress(pinchL)

        pinchR.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.Touch then
                refreshInput()
                if Input then
                    if S.toggleGrabMode then
                        Input.rIndex = Input.rIndex == 1 and 0 or 1
                        if Input.rIndex == 1 then Input.rFist = 0; Input.rThumb = 0 end
                    else
                        Input.rIndex = 1; Input.rFist = 0; Input.rThumb = 0
                        grabOverride.R = true
                        task.delay(0.2, function() grabOverride.R = false end)
                    end
                end
            end
        end)
        pinchR.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.Touch and Input and not S.toggleGrabMode then
                Input.rIndex = 0
            end
        end)
        bindPress(pinchR)

        -- 功能区
        funcWrap = Instance.new("Frame")
        funcWrap.Size = UDim2.fromScale(0.60, 0.13)
        funcWrap.Position = UDim2.new(0.99, 0, FUNC_Y_SHOW, 0)
        funcWrap.AnchorPoint = Vector2.new(1, 0)
        funcWrap.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        funcWrap.BackgroundTransparency = 0.78
        funcWrap.BorderSizePixel = 0
        funcWrap.Parent = mobileGui
        Instance.new("UICorner", funcWrap).CornerRadius = UDim.new(0, 8)
        local funcStroke = Instance.new("UIStroke", funcWrap)
        funcStroke.Color = Color3.fromRGB(255,255,255); funcStroke.Transparency = 0.55; funcStroke.Thickness = 1.5

        local cols, rowH, fgap = 6, 0.46, 0.02
        local fw = (1 - fgap * (cols - 1)) / cols
        local function cellPos(col, row) return UDim2.fromScale((fw + fgap) * col, (rowH + 0.06) * row) end

        local reachUp   = createBtn(funcWrap, "ReachUp",   cellPos(0, 0), UDim2.fromScale(fw, rowH), "手长+", 10)
        local reachDown = createBtn(funcWrap, "ReachDown", cellPos(1, 0), UDim2.fromScale(fw, rowH), "手长-", 10)
        local grabUp    = createBtn(funcWrap, "GrabUp",    cellPos(2, 0), UDim2.fromScale(fw, rowH), "抓距+", 10)
        local grabDown  = createBtn(funcWrap, "GrabDown",  cellPos(3, 0), UDim2.fromScale(fw, rowH), "抓距-", 10)
        local handGyroUp   = createBtn(funcWrap, "HandGyroUp",   cellPos(4, 0), UDim2.fromScale(fw, rowH), "手陀+", 10)
        local handGyroDown = createBtn(funcWrap, "HandGyroDown", cellPos(5, 0), UDim2.fromScale(fw, rowH), "手陀-", 10)

        local speedUp   = createBtn(funcWrap, "SpeedUp",   cellPos(0, 1), UDim2.fromScale(fw, rowH), "速度+", 10)
        local speedDown = createBtn(funcWrap, "SpeedDown", cellPos(1, 1), UDim2.fromScale(fw, rowH), "速度-", 10)
        local sensUp    = createBtn(funcWrap, "SensUp",    cellPos(2, 1), UDim2.fromScale(fw, rowH), "灵敏+", 10)
        local sensDown  = createBtn(funcWrap, "SensDown",  cellPos(3, 1), UDim2.fromScale(fw, rowH), "灵敏-", 10)
        local modeBtn   = createBtn(funcWrap, "ModeBtn",   cellPos(4, 1), UDim2.fromScale(fw, rowH), "模式长按", 8)
        local gyroBtn   = createBtn(funcWrap, "GyroBtn",   cellPos(5, 1), UDim2.fromScale(fw, rowH), "陀螺仪", 10)

        reachUp.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then S.reach = math.clamp(S.reach + 0.1, 0.05, 20) end end)
        reachDown.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then S.reach = math.clamp(S.reach - 0.1, 0.05, 20) end end)
        grabUp.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then S.grabRadiusMult = math.clamp(S.grabRadiusMult + 0.1, 0.1, 10) end end)
        grabDown.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then S.grabRadiusMult = math.clamp(S.grabRadiusMult - 0.1, 0.1, 10) end end)
        handGyroUp.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.Touch then
                S.gyroPosK = math.clamp(S.gyroPosK + 0.15, 0, 3)
                S.gyroPosMax = math.clamp(S.gyroPosMax + 0.15, 0.1, 3)
            end
        end)
        handGyroDown.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.Touch then
                S.gyroPosK = math.clamp(S.gyroPosK - 0.15, 0, 3)
                S.gyroPosMax = math.clamp(S.gyroPosMax - 0.15, 0.1, 3)
            end
        end)
        speedUp.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then S.speedMult = math.clamp(S.speedMult + 0.1, 0.1, 10) end end)
        speedDown.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then S.speedMult = math.clamp(S.speedMult - 0.1, 0.1, 10) end end)
        sensUp.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.Touch then
                S.gyroRotK = math.clamp(S.gyroRotK + 0.2, 0.1, 5)
                S.gyroPosK = math.clamp(S.gyroPosK + 0.1, 0.1, 3)
            end
        end)
        sensDown.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.Touch then
                S.gyroRotK = math.clamp(S.gyroRotK - 0.2, 0.1, 5)
                S.gyroPosK = math.clamp(S.gyroPosK - 0.1, 0.1, 3)
            end
        end)
        modeBtn.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.Touch then
                S.toggleGrabMode = not S.toggleGrabMode
                modeBtn.Text = S.toggleGrabMode and "模式切换" or "模式长按"
            end
        end)

        local gyroHoldT = nil
        gyroBtn.InputBegan:Connect(function(i)
            if i.UserInputType ~= Enum.UserInputType.Touch then return end
            gyroHoldT = os.clock()
        end)
        gyroBtn.InputEnded:Connect(function(i)
            if i.UserInputType ~= Enum.UserInputType.Touch then return end
            local held = os.clock() - (gyroHoldT or 0)
            if held > 0.5 then
                if gyroNow then gyroBase = gyroNow end
                swayOffsetL = Vector3.zero; swayOffsetR = Vector3.zero
                rotL = CFrame.new(); rotR = CFrame.new()
                gyroPosL = Vector3.zero; gyroPosR = Vector3.zero
                gyroBtn.Text = "校准✓"
                task.delay(0.8, function() gyroBtn.Text = S.gyroEnabled and "陀螺仪" or "陀螺关" end)
            else
                S.gyroEnabled = not S.gyroEnabled
                gyroBtn.Text = S.gyroEnabled and "陀螺仪" or "陀螺关"
            end
        end)

        for _, b in ipairs({reachUp, reachDown, grabUp, grabDown,
                            handGyroUp, handGyroDown,
                            speedUp, speedDown, sensUp, sensDown, modeBtn}) do
            bindPress(b)
        end
        bindPress(gyroBtn)

        -- 属性面板
        infoPanel = Instance.new("Frame")
        infoPanel.Size = UDim2.fromScale(0.36, 0.19)
        infoPanel.Position = UDim2.fromScale(0.99, 0.24)
        infoPanel.AnchorPoint = Vector2.new(1, 0)
        infoPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        infoPanel.BackgroundTransparency = 0.78
        infoPanel.BorderSizePixel = 0
        infoPanel.Parent = mobileGui
        Instance.new("UICorner", infoPanel).CornerRadius = UDim.new(0, 8)
        local infoStroke = Instance.new("UIStroke", infoPanel)
        infoStroke.Color = Color3.fromRGB(255,255,255); infoStroke.Transparency = 0.55; infoStroke.Thickness = 1.5
        local infoPad = Instance.new("UIPadding", infoPanel)
        infoPad.PaddingTop = UDim.new(0.06, 0); infoPad.PaddingBottom = UDim.new(0.06, 0)
        infoPad.PaddingLeft = UDim.new(0.05, 0); infoPad.PaddingRight = UDim.new(0.05, 0)

        local infoLbl = Instance.new("TextLabel")
        infoLbl.Size = UDim2.fromScale(1, 1); infoLbl.BackgroundTransparency = 1
        infoLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        infoLbl.TextXAlignment = Enum.TextXAlignment.Left
        infoLbl.TextYAlignment = Enum.TextYAlignment.Top
        infoLbl.Font = Enum.Font.Code; infoLbl.TextSize = 11
        infoLbl.Text = ""; infoLbl.Parent = infoPanel

        RunService.Heartbeat:Connect(function()
            infoLbl.Text = ("手陀 %.2f  灵敏 %.2f\n手长 %.2f  抓距 %.1f\n速度 %.1f  体型 %.1f\n模式 %s  陀螺 %s  手转 %s")
            :format(S.gyroPosK, S.gyroRotK, S.reach, S.grabRadiusMult,
                    S.speedMult, S.scale,
                    S.toggleGrabMode and "切换" or "长按",
                    S.gyroEnabled and "开" or "关",
                    spinMode and "开" or "关")
        end)

        -- ===== 视角触摸（4 指防跳屏，阈值 150） =====
        local function pointOnAnyUI(pos)
            for _, obj in ipairs(mobileGui:GetDescendants()) do
                if obj:IsA("GuiObject") and obj.Visible then
                    local ap = obj.AbsolutePosition
                    local as = obj.AbsoluteSize
                    if pos.X >= ap.X and pos.X <= ap.X + as.X
                       and pos.Y >= ap.Y and pos.Y <= ap.Y + as.Y then
                        return true
                    end
                end
            end
            return false
        end

        local touchLook = false
        local lastTouch = Vector2.zero
        local JUMP_THRESHOLD = 150

        UIS.TouchStarted:Connect(function(i)
            if touchLook then return end
            local vp = workspace.CurrentCamera.ViewportSize
            if i.Position.X > vp.X * 0.5 and not pointOnAnyUI(i.Position) then
                touchLook = true
                lastTouch = i.Position
            end
        end)

        UIS.TouchMoved:Connect(function(i)
            if not touchLook then return end
            local d = i.Position - lastTouch
            if d.Magnitude > JUMP_THRESHOLD then
                return
            end
            targetYaw   = targetYaw   - d.X * S.sens
            targetPitch = math.clamp(targetPitch - d.Y * S.sensPitch, -1.55, 1.55)
            lastTouch = i.Position
        end)

        UIS.TouchEnded:Connect(function(i)
            if not touchLook then return end
            if (i.Position - lastTouch).Magnitude > JUMP_THRESHOLD then return end
            touchLook = false
        end)
    end)

    print("[NoVR] control active.")
end)
]==]

local function teleportToCurrentServer()
    local ok, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
    end)
    if not ok then
        warn("[VR Hands No-VR] reconnect failed: " .. tostring(err))
        pcall(function() TeleportService:Teleport(game.PlaceId, Players.LocalPlayer) end)
    end
end

local localExec = loadstring or load
if localExec then
    local fn, err = pcall(localExec, hrs)
    if fn then
        local ok, e = pcall(fn)
        if not ok then warn("[VR Hands No-VR] local exec error: " .. tostring(e)) end
    else
        warn("[VR Hands No-VR] compile failed: " .. tostring(err))
    end
end

if type(queue_on_teleport) == "function" then
    queue_on_teleport(hrs)
    task.delay(3, teleportToCurrentServer)
elseif syn and type(syn.queue_on_teleport) == "function" then
    syn.queue_on_teleport(hrs)
    task.delay(3, teleportToCurrentServer)
else
    warn("[VR Hands No-VR] 执行器不支持 queue_on_teleport，只本地生效")
end