do
    local qot = queue_on_teleport or (syn and syn.queue_on_teleport)
    local checks = {
        { "getrawmetatable",   getrawmetatable   },
        { "setreadonly",       setreadonly       },
        { "newcclosure",       newcclosure       },
        { "getnamecallmethod", getnamecallmethod },
        { "getgc",             getgc             },
        { "queue_on_teleport", qot               },
    }
    local missing, report = {}, "[NoVR Pro] UNC test:\n"
    for _, c in ipairs(checks) do
        local ok = type(c[2]) == "function"
        report = report .. ("  [%s] %s\n"):format(ok and "+" or "-", c[1])
        if not ok then table.insert(missing, c[1]) end
    end
    print(report)
    if #missing > 0 then
        warn("[NoVR Pro] 缺少函数: " .. table.concat(missing, ", "))
        return
    end
end

local Players         = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local hrs = [==[
local VRService   = game:GetService("VRService")
local UIS         = game:GetService("UserInputService")
local RunService  = game:GetService("RunService")
local Players     = game:GetService("Players")
local identity    = CFrame.identity

do
    local mt = getrawmetatable(game)
    local oldIndex    = mt.__index
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
end

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

getgenv().joyOffset   = Vector2.new(0, 0)
getgenv().dpadBusy    = false
getgenv().dpadState   = { up=false, down=false, left=false, right=false }

task.spawn(function()
    local lp = Players.LocalPlayer
    while not lp do task.wait() lp = Players.LocalPlayer end
    local uid = tostring(lp.UserId)

    local vrPlayers = workspace:WaitForChild("VRPlayers", 60)
    if not vrPlayers then warn("[NoVR] 找不到 VRPlayers") return end
    local rig = vrPlayers:WaitForChild(uid, 60)
    if not rig then warn("[NoVR] 没有 rig") return end
    rig:WaitForChild("VRHead", 20)
    rig:WaitForChild("LeftHand", 20)
    rig:WaitForChild("RightHand", 20)
    local scaleVal = rig:FindFirstChild("VRScale")
    local cam = workspace.CurrentCamera

    local S = {
        reach = 0.55, spread = 0.34, height = -0.25,
        sens = 0.005, moveK = 0.16, look = true, scale = 10,
    }

    local Gesture = {
        rThumb=0, rIndex=0, rMiddle=0, rRing=0, rPinky=0, rFist=0,
        lThumb=0, lIndex=0, lMiddle=0, lRing=0, lPinky=0, lFist=0,
        presetName = "None",
    }

    local HandRot = {
        both  = { yaw=0, pitch=0 },
        right = { yaw=0, pitch=0 },
        left  = { yaw=0, pitch=0 },
    }
    local middleMouseHeld = false
    local rotTarget = "both"

    local ok, VRUtils = pcall(function()
        return require(lp.PlayerScripts.ClientLoader.PlayerModule.VRModule.VRUtils)
    end)
    if ok and type(VRUtils) == "table" then
        VRUtils.GetUserCFrame = function(uc, scale)
            scale = scale or cam.HeadScale
            if scale <= 1 then scale = math.max((scaleVal and scaleVal.Value or 1) * 60, 6) end
            local baseCF
            if uc == Enum.UserCFrame.LeftHand then
                local c = CFrame.new(-S.spread, S.height, -S.reach)
                baseCF = c.Rotation + c.Position * scale
            elseif uc == Enum.UserCFrame.RightHand then
                local c = CFrame.new(S.spread, S.height, -S.reach)
                baseCF = c.Rotation + c.Position * scale
            else
                baseCF = identity
            end
            local rotBoth  = CFrame.Angles(HandRot.both.pitch,  HandRot.both.yaw,  0)
            local rotRight = CFrame.Angles(HandRot.right.pitch, HandRot.right.yaw, 0)
            local rotLeft  = CFrame.Angles(HandRot.left.pitch,  HandRot.left.yaw,  0)
            if uc == Enum.UserCFrame.RightHand then
                return baseCF * rotBoth * rotRight
            elseif uc == Enum.UserCFrame.LeftHand then
                return baseCF * rotBoth * rotLeft
            end
            return baseCF
        end
    end

    local vrm, Input
    for _ = 1, 250 do
        for _, o in pairs(getgc(true)) do
            if type(o) == "table"
               and rawget(o,"HeadsetPart") ~= nil and rawget(o,"Input") ~= nil
               and rawget(o,"CharacterScale") ~= nil and rawget(o,"DataManager") ~= nil then
                vrm = o; Input = rawget(o,"Input"); break
            end
        end
        if Input then break end
        for _, o in pairs(getgc(true)) do
            if type(o) == "table" and rawget(o,"directionLateral") ~= nil
               and rawget(o,"rFist") ~= nil and rawget(o,"turnDirection") ~= nil then
                Input = o; break
            end
        end
        if Input then break end
        task.wait(0.1)
    end

    local Supported = {}
    if Input then
        for k, v in pairs(Input) do
            if type(v) == "number" then Supported[k] = true end
        end
    end

    local HAS_FULL_FINGERS = Supported.rMiddle == true

    local function safeSetInput(key, value)
        if Input and Supported[key] then
            pcall(function() Input[key] = value end)
        end
    end

    local function applyGesture(g)
        if not Input then return end

        local function calcProxyFist(hand, gTable)
            if HAS_FULL_FINGERS then return nil end
            local fistKey = hand .. "Fist"
            if gTable[fistKey] ~= nil then return nil end
            local m = gTable[hand .. "Middle"] or 0
            local r = gTable[hand .. "Ring"]   or 0
            local p = gTable[hand .. "Pinky"]  or 0
            local c = m + r + p
            if c > 0 then return math.clamp(c / 3, 0.2, 1) end
            return nil
        end

        local rProxy = calcProxyFist("r", g)
        local lProxy = calcProxyFist("l", g)

        if g.rThumb  ~= nil then safeSetInput("rThumb",  g.rThumb)  end
        if g.rIndex  ~= nil then safeSetInput("rIndex",  g.rIndex)  end
        if g.rMiddle ~= nil then safeSetInput("rMiddle", g.rMiddle) end
        if g.rRing   ~= nil then safeSetInput("rRing",   g.rRing)   end
        if g.rPinky  ~= nil then safeSetInput("rPinky",  g.rPinky)  end
        if g.rFist   ~= nil then safeSetInput("rFist",   g.rFist)
        elseif rProxy then safeSetInput("rFist", rProxy) end

        if g.lThumb  ~= nil then safeSetInput("lThumb",  g.lThumb)  end
        if g.lIndex  ~= nil then safeSetInput("lIndex",  g.lIndex)  end
        if g.lMiddle ~= nil then safeSetInput("lMiddle", g.lMiddle) end
        if g.lRing   ~= nil then safeSetInput("lRing",   g.lRing)   end
        if g.lPinky  ~= nil then safeSetInput("lPinky",  g.lPinky)  end
        if g.lFist   ~= nil then safeSetInput("lFist",   g.lFist)
        elseif lProxy then safeSetInput("lFist", lProxy) end

        for k, v in pairs(g) do
            if Gesture[k] ~= nil and type(v) == "number" then Gesture[k] = v end
        end
        if g.presetName then Gesture.presetName = g.presetName end
    end

    local Presets = {
        ["Open"]     = { rThumb=0, rIndex=0, rMiddle=0, rRing=0, rPinky=0, rFist=0, lThumb=0, lIndex=0, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="张开手掌" },
        ["Fist"]     = { rThumb=1, rIndex=1, rMiddle=1, rRing=1, rPinky=1, rFist=1, lThumb=1, lIndex=1, lMiddle=1, lRing=1, lPinky=1, lFist=1, presetName="握拳" },
        ["Point"]    = { rThumb=0, rIndex=1, rMiddle=0, rRing=0, rPinky=0, rFist=0, lThumb=0, lIndex=1, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="食指指" },
        ["Peace"]    = { rThumb=0, rIndex=1, rMiddle=1, rRing=0, rPinky=0, rFist=0, lThumb=0, lIndex=1, lMiddle=1, lRing=0, lPinky=0, lFist=0, presetName="剪刀手" },
        ["ThumbsUp"] = { rThumb=1, rIndex=0, rMiddle=0, rRing=0, rPinky=0, rFist=1, lThumb=1, lIndex=0, lMiddle=0, lRing=0, lPinky=0, lFist=1, presetName="点赞" },
        ["OK"]       = { rThumb=1, rIndex=1, rMiddle=0, rRing=0, rPinky=0, rFist=0, lThumb=1, lIndex=1, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="OK" },
        ["Rock"]     = { rThumb=0, rIndex=1, rMiddle=0, rRing=0, rPinky=1, rFist=0, lThumb=0, lIndex=1, lMiddle=0, lRing=0, lPinky=1, lFist=0, presetName="摇滚" },
        ["Middle"]   = { rThumb=0, rIndex=0, rMiddle=1, rRing=0, rPinky=0, rFist=0, lThumb=0, lIndex=0, lMiddle=1, lRing=0, lPinky=0, lFist=0, presetName="中指" },
        ["Phone"]    = { rThumb=1, rIndex=0, rMiddle=0, rRing=0, rPinky=1, rFist=0, lThumb=1, lIndex=0, lMiddle=0, lRing=0, lPinky=1, lFist=0, presetName="电话" },
        ["Gun"]      = { rThumb=0, rIndex=1, rMiddle=0, rRing=0, rPinky=0, rFist=0, lThumb=0, lIndex=1, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="手枪指" },
        ["PinchR"]   = { rThumb=1, rIndex=1, rMiddle=0, rRing=0, rPinky=0, rFist=0, lThumb=0, lIndex=0, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="右手捏取" },
        ["PinchL"]   = { rThumb=0, rIndex=0, rMiddle=0, rRing=0, rPinky=0, rFist=0, lThumb=1, lIndex=1, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="左手捏取" },
        ["GrabR"]    = { rThumb=1, rIndex=1, rMiddle=1, rRing=1, rPinky=1, rFist=1, lThumb=0, lIndex=0, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="右手抓取" },
        ["GrabL"]    = { rThumb=0, rIndex=0, rMiddle=0, rRing=0, rPinky=0, rFist=0, lThumb=1, lIndex=1, lMiddle=1, lRing=1, lPinky=1, lFist=1, presetName="左手抓取" },
        ["Flap"]     = { rThumb=0, rIndex=0, rMiddle=0, rRing=0, rPinky=0, rFist=0, lThumb=0, lIndex=0, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="挥手" },
        ["Horns"]    = { rThumb=1, rIndex=1, rMiddle=0, rRing=0, rPinky=1, rFist=0, lThumb=1, lIndex=1, lMiddle=0, lRing=0, lPinky=1, lFist=0, presetName="牛角" },
        ["Shaka"]    = { rThumb=1, rIndex=0, rMiddle=0, rRing=0, rPinky=1, rFist=0, lThumb=1, lIndex=0, lMiddle=0, lRing=0, lPinky=1, lFist=0, presetName="Shaka" },
        ["Salute"]   = { rThumb=0, rIndex=1, rMiddle=0, rRing=0, rPinky=0, rFist=0, lThumb=0, lIndex=0, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="敬礼" },
        ["Pray"]     = { rThumb=1, rIndex=1, rMiddle=1, rRing=1, rPinky=1, rFist=1, lThumb=1, lIndex=1, lMiddle=1, lRing=1, lPinky=1, lFist=1, presetName="祈祷" },
        ["Claw"]     = { rThumb=0, rIndex=1, rMiddle=1, rRing=1, rPinky=1, rFist=0.5, lThumb=0, lIndex=1, lMiddle=1, lRing=1, lPinky=1, lFist=0.5, presetName="爪子" },
    }

    local PresetKeys = {
        [Enum.KeyCode.One]="Open", [Enum.KeyCode.Two]="Fist", [Enum.KeyCode.Three]="Point",
        [Enum.KeyCode.Four]="Peace", [Enum.KeyCode.Five]="ThumbsUp", [Enum.KeyCode.Six]="OK",
        [Enum.KeyCode.Seven]="Rock", [Enum.KeyCode.Eight]="Middle", [Enum.KeyCode.Nine]="Phone", [Enum.KeyCode.Zero]="Gun",
    }
    local PresetKeysCtrl = {
        [Enum.KeyCode.One]="PinchR", [Enum.KeyCode.Two]="GrabR", [Enum.KeyCode.Three]="PinchL",
        [Enum.KeyCode.Four]="GrabL", [Enum.KeyCode.Five]="Flap", [Enum.KeyCode.Six]="Horns",
        [Enum.KeyCode.Seven]="Shaka", [Enum.KeyCode.Eight]="Salute", [Enum.KeyCode.Nine]="Pray", [Enum.KeyCode.Zero]="Claw",
    }
    local FingerKeys = {
        [Enum.KeyCode.T]={hand="r",finger="Thumb"}, [Enum.KeyCode.Y]={hand="r",finger="Index"},
        [Enum.KeyCode.U]={hand="r",finger="Middle"}, [Enum.KeyCode.I]={hand="r",finger="Ring"},
        [Enum.KeyCode.O]={hand="r",finger="Pinky"}, [Enum.KeyCode.P]={hand="r",finger="Fist"},
        [Enum.KeyCode.Z]={hand="l",finger="Thumb"}, [Enum.KeyCode.X]={hand="l",finger="Index"},
        [Enum.KeyCode.C]={hand="l",finger="Middle"}, [Enum.KeyCode.V]={hand="l",finger="Ring"},
        [Enum.KeyCode.B]={hand="l",finger="Pinky"}, [Enum.KeyCode.N]={hand="l",finger="Fist"},
    }

    local heldFingers, preFingerState, keys = {}, nil, {}

    local function saveState()
        return {rThumb=Gesture.rThumb,rIndex=Gesture.rIndex,rMiddle=Gesture.rMiddle,rRing=Gesture.rRing,
                rPinky=Gesture.rPinky,rFist=Gesture.rFist,lThumb=Gesture.lThumb,lIndex=Gesture.lIndex,
                lMiddle=Gesture.lMiddle,lRing=Gesture.lRing,lPinky=Gesture.lPinky,lFist=Gesture.lFist}
    end
    local function loadState(st) if st then applyGesture(st) end end

    task.spawn(function()
        for _ = 1, 100 do
            pcall(function() RunService:UnbindFromRenderStep("Inputs") end)
            task.wait(0.1)
        end
    end)

    pcall(function()
        local pmMT = getrawmetatable(vrm.PropManager)
        if pmMT and rawget(pmMT, "GetBestGrabPartInRadius") then
            local orig = pmMT.GetBestGrabPartInRadius
            setreadonly(pmMT, false)
            pmMT.GetBestGrabPartInRadius = function(self, root, prox, radius, scale, ...)
                return orig(self, root, prox, (radius or 0) * 3.5, scale, ...)
            end
            setreadonly(pmMT, true)
        end
        local cmMT = getrawmetatable(vrm.CharacterManager)
        if cmMT and rawget(cmMT, "GetClosestCharacterInRadius") then
            local orig = cmMT.GetClosestCharacterInRadius
            setreadonly(cmMT, false)
            cmMT.GetClosestCharacterInRadius = function(self, pos, radius, ...)
                return orig(self, pos, (radius or 0) * 3.5, ...)
            end
            setreadonly(cmMT, true)
        end
    end)

    local function setScale(n)
        n = math.clamp(math.floor(n + 0.5), 1, 10)
        S.scale = n
        if scaleVal then pcall(function() scaleVal.Value = n / 10 end) end
        if vrm and vrm.DataManager and vrm.DataManager.SettingsManager then
            pcall(function() vrm.DataManager.SettingsManager:SetValue("vrscale", n) end)
        end
    end
    setScale(10)

    pcall(function()
        for _, name in ipairs({"LeftHand", "RightHand"}) do
            local part = rig:FindFirstChild(name)
            if part and part:IsA("BasePart") then
                part.CanCollide = false
                part.Massless = true
                part.CanTouch = false
                part.CanQuery = false
            end
        end
        task.spawn(function()
            while true do
                task.wait(0.05)
                pcall(function()
                    if not rig or not rig.Parent then return end
                    local lh, rh = rig:FindFirstChild("LeftHand"), rig:FindFirstChild("RightHand")
                    local function check(part, isLeft)
                        if not part or not part:IsA("BasePart") then return end
                        local p = part.Position
                        local bad = false
                        if p.X ~= p.X or p.Y ~= p.Y or p.Z ~= p.Z then bad = true end
                        if p.Y < (cam.CFrame.Position.Y - 50) then bad = true end
                        if (p - cam.CFrame.Position).Magnitude > 200 then bad = true end
                        if part.Anchored then bad = true end
                        if part.CanCollide ~= false then part.CanCollide = false end
                        if bad then
                            local offset = isLeft and -S.spread or S.spread
                            part.Anchored = false
                            part.CFrame = cam.CFrame * CFrame.new(offset, S.height, -S.reach)
                            part.AssemblyLinearVelocity = Vector3.zero
                            part.AssemblyAngularVelocity = Vector3.zero
                        end
                    end
                    check(lh, true); check(rh, false)
                end)
            end
        end)
    end)

    cam.HeadLocked = true
    local yaw, pitch
    do
        local lv = cam.CFrame.LookVector
        yaw = math.atan2(-lv.X, -lv.Z)
        pitch = math.asin(math.clamp(lv.Y, -1, 1))
    end
    local camPos = cam.CFrame.Position

    local function setLook(v)
        S.look = v
        UIS.MouseBehavior = v and Enum.MouseBehavior.LockCenter or Enum.MouseBehavior.Default
        UIS.MouseIconEnabled = not v
    end
    setLook(true)

    UIS.InputBegan:Connect(function(io)
        if io.UserInputType == Enum.UserInputType.Keyboard then
            keys[io.KeyCode] = true
            if io.KeyCode == Enum.KeyCode.F then rotTarget = "right" end
            if io.KeyCode == Enum.KeyCode.G then rotTarget = "left" end
            if io.KeyCode == Enum.KeyCode.LeftAlt then setLook(not S.look) end
            if io.KeyCode == Enum.KeyCode.Equals then setScale(S.scale + 1) end
            if io.KeyCode == Enum.KeyCode.Minus then setScale(S.scale - 1) end
            if Input and io.KeyCode == Enum.KeyCode.E then applyGesture({rIndex=1,rFist=0,rThumb=0}) end
            if Input and io.KeyCode == Enum.KeyCode.Q then applyGesture({lIndex=1,lFist=0,lThumb=0}) end
            local preset = PresetKeys[io.KeyCode]
            if preset then applyGesture(Presets[preset]) end
            if keys[Enum.KeyCode.LeftControl] or keys[Enum.KeyCode.RightControl] then
                local pc = PresetKeysCtrl[io.KeyCode]
                if pc then applyGesture(Presets[pc]) end
            end
            local fk = FingerKeys[io.KeyCode]
            if fk then
                if not next(heldFingers) then preFingerState = saveState() end
                heldFingers[io.KeyCode] = true
                applyGesture({[fk.hand..fk.finger] = 1})
            end
        elseif io.UserInputType == Enum.UserInputType.MouseButton3 then
            middleMouseHeld = true
        end
    end)

    UIS.InputEnded:Connect(function(io)
        if io.UserInputType == Enum.UserInputType.Keyboard then
            keys[io.KeyCode] = false
            if io.KeyCode == Enum.KeyCode.F or io.KeyCode == Enum.KeyCode.G then
                if not middleMouseHeld then rotTarget = "both" end
            end
            if Input and io.KeyCode == Enum.KeyCode.E then applyGesture({rIndex=0}) end
            if Input and io.KeyCode == Enum.KeyCode.Q then applyGesture({lIndex=0}) end
            local fk = FingerKeys[io.KeyCode]
            if fk then
                heldFingers[io.KeyCode] = nil
                if not next(heldFingers) then loadState(preFingerState); preFingerState = nil
                else applyGesture({[fk.hand..fk.finger] = 0}) end
            end
        elseif io.UserInputType == Enum.UserInputType.MouseButton3 then
            middleMouseHeld = false; rotTarget = "both"
        end
    end)

    UIS.InputChanged:Connect(function(io)
        if io.UserInputType == Enum.UserInputType.MouseWheel then
            S.reach = math.clamp(S.reach - io.Position.Z * 0.07, 0.15, 2.5)
        end
    end)

    RunService:BindToRenderStep("NoVR_Control", Enum.RenderPriority.Camera.Value + 1, function(dt)
        local dpadBusy = getgenv().dpadBusy
        if middleMouseHeld and not dpadBusy then
            local d = UIS:GetMouseDelta()
            local t = HandRot[rotTarget]
            t.yaw = t.yaw - d.X * 0.008
            t.pitch = math.clamp(t.pitch - d.Y * 0.008, -1.5, 1.5)
            UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
        elseif not dpadBusy then
            if S.look then
                local d = UIS:GetMouseDelta()
                yaw = yaw - d.X * S.sens
                pitch = math.clamp(pitch - d.Y * S.sens, -1.45, 1.45)
                UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
            end
        else
            UIS:GetMouseDelta()
        end

        local rot = CFrame.fromEulerAnglesYXZ(pitch, yaw, 0)
        local hs = cam.HeadScale; if hs <= 1 then hs = S.scale * 6 end
        local spd = (10 + S.scale * 4) * hs * S.moveK
        local mv = Vector3.zero
        if keys[Enum.KeyCode.W] then mv += Vector3.new(0,0,-1) end
        if keys[Enum.KeyCode.S] then mv += Vector3.new(0,0,1) end
        if keys[Enum.KeyCode.A] then mv += Vector3.new(-1,0,0) end
        if keys[Enum.KeyCode.D] then mv += Vector3.new(1,0,0) end
        if keys[Enum.KeyCode.Space] then mv += Vector3.new(0,1,0) end
        if keys[Enum.KeyCode.LeftShift] then mv += Vector3.new(0,-1,0) end

        local jo = getgenv().joyOffset
        if jo and jo.Magnitude > 0.08 then mv += Vector3.new(jo.X, 0, jo.Y) end
        if mv.Magnitude > 0 then camPos = camPos + (rot * mv.Unit) * spd * dt end

        cam.CameraType = Enum.CameraType.Scriptable
        cam.CFrame = CFrame.new(camPos) * rot

        if Input then
            Input.directionLateral = Vector2.zero
            Input.directionVertical = 0
            Input.turnDirection = 0
        end
    end)

    -- HUD
    pcall(function()
        local gui = Instance.new("ScreenGui")
        gui.Name = "NoVR_HUD"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true
        gui.Parent = lp:WaitForChild("PlayerGui")
        local mf = Instance.new("Frame", gui)
        mf.Position = UDim2.new(0,10,0,10); mf.Size = UDim2.new(0,300,0,72)
        mf.BackgroundColor3 = Color3.fromRGB(15,15,20); mf.BackgroundTransparency = 0.3; mf.BorderSizePixel = 0
        Instance.new("UICorner", mf).CornerRadius = UDim.new(0,8)
        local t = Instance.new("TextLabel", mf)
        t.Size = UDim2.new(1,-10,0,20); t.Position = UDim2.new(0,5,0,3)
        t.BackgroundTransparency = 1; t.Text = "VR 手势 (手机可点)"
        t.TextColor3 = Color3.fromRGB(0,255,170); t.Font = Enum.Font.GothamBold
        t.TextSize = 14; t.TextXAlignment = Enum.TextXAlignment.Left
        local h = Instance.new("TextLabel", mf)
        h.Size = UDim2.new(1,-10,0,20); h.Position = UDim2.new(0,5,0,22)
        h.BackgroundTransparency = 1; h.TextColor3 = Color3.fromRGB(255,255,255)
        h.TextXAlignment = Enum.TextXAlignment.Left; h.Font = Enum.Font.Code; h.TextSize = 12
        local st = Instance.new("TextLabel", mf)
        st.Size = UDim2.new(1,-10,0,20); st.Position = UDim2.new(0,5,0,44)
        st.BackgroundTransparency = 1; st.TextColor3 = Color3.fromRGB(255,220,120)
        st.TextXAlignment = Enum.TextXAlignment.Left; st.Font = Enum.Font.Code; st.TextSize = 12
        RunService.Heartbeat:Connect(function()
            h.Text = string.format("动作: %s | 体型: %d/10", Gesture.presetName, S.scale)
            st.Text = string.format("手距: %.2f", S.reach)
        end)
    end)

    -- 手机手势面板
    local mobileOpen = false
    local mobileFrame, toggleBtn
    local function makeBtn(parent, text, color, cb)
        local b = Instance.new("TextButton", parent)
        b.BackgroundColor3 = color or Color3.fromRGB(40,40,55)
        b.BorderSizePixel = 0; b.Text = text; b.TextColor3 = Color3.fromRGB(255,255,255)
        b.Font = Enum.Font.GothamBold; b.TextSize = 12; b.AutoButtonColor = true
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
        b.MouseButton1Click:Connect(cb); return b
    end

    pcall(function()
        local gui = Instance.new("ScreenGui")
        gui.Name = "NoVR_MobilePanel"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true
        gui.Parent = lp:WaitForChild("PlayerGui")
        toggleBtn = Instance.new("TextButton", gui); toggleBtn.Size = UDim2.new(0,60,0,60)
        toggleBtn.Position = UDim2.new(1,-70,0,90); toggleBtn.BackgroundColor3 = Color3.fromRGB(0,150,120)
        toggleBtn.BorderSizePixel = 0; toggleBtn.Text = "手势"; toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
        toggleBtn.Font = Enum.Font.GothamBold; toggleBtn.TextSize = 16; toggleBtn.Draggable = true
        Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1,0)
        toggleBtn.MouseButton1Click:Connect(function() mobileOpen = not mobileOpen; if mobileFrame then mobileFrame.Visible = mobileOpen end end)

        mobileFrame = Instance.new("Frame", gui); mobileFrame.Visible = false
        mobileFrame.AnchorPoint = Vector2.new(1,0); mobileFrame.Position = UDim2.new(1,-10,0,160)
        mobileFrame.Size = UDim2.new(0,340,0,460); mobileFrame.BackgroundColor3 = Color3.fromRGB(20,20,28)
        mobileFrame.BackgroundTransparency = 0.1; mobileFrame.BorderSizePixel = 0
        Instance.new("UICorner", mobileFrame).CornerRadius = UDim.new(0,10)
        local title = Instance.new("TextLabel", mobileFrame)
        title.Size = UDim2.new(1,0,0,26); title.Position = UDim2.new(0,0,0,4)
        title.BackgroundTransparency = 1; title.Text = "点击按钮触动手势"
        title.TextColor3 = Color3.fromRGB(0,255,170); title.Font = Enum.Font.GothamBold; title.TextSize = 14

        local scroll = Instance.new("ScrollingFrame", mobileFrame)
        scroll.Position = UDim2.new(0,6,0,32); scroll.Size = UDim2.new(1,-12,1,-40)
        scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 4; scroll.ScrollBarImageColor3 = Color3.fromRGB(100,100,120)
        local layout = Instance.new("UIListLayout", scroll)
        layout.Padding = UDim.new(0,6); layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scroll.CanvasSize = UDim2.new(0,0,0, layout.AbsoluteContentSize.Y + 10)
        end)

        local function cat(text)
            local lbl = Instance.new("TextLabel", scroll); lbl.Size = UDim2.new(1,0,0,22)
            lbl.BackgroundTransparency = 1; lbl.Text = "── "..text.." ──"
            lbl.TextColor3 = Color3.fromRGB(180,180,200); lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12
        end
        local function row()
            local r = Instance.new("Frame", scroll); r.Size = UDim2.new(1,0,0,38); r.BackgroundTransparency = 1
            local l = Instance.new("UIListLayout", r); l.FillDirection = Enum.FillDirection.Horizontal
            l.Padding = UDim.new(0,4); l.SortOrder = Enum.SortOrder.LayoutOrder; return r
        end

        cat("快捷动作")
        local r1, r2 = row(), row()
        local pdefs = {
            {"张开","Open",Color3.fromRGB(60,100,180)},{"握拳","Fist",Color3.fromRGB(180,60,60)},
            {"食指","Point",Color3.fromRGB(80,150,80)},{"剪刀","Peace",Color3.fromRGB(150,100,180)},
            {"点赞","ThumbsUp",Color3.fromRGB(180,150,60)},{"OK","OK",Color3.fromRGB(60,170,170)},
            {"摇滚","Rock",Color3.fromRGB(150,60,150)},{"中指","Middle",Color3.fromRGB(120,120,120)},
            {"电话","Phone",Color3.fromRGB(100,150,60)},{"手枪","Gun",Color3.fromRGB(60,60,150)},
        }
        for i, d in ipairs(pdefs) do
            local p = (i<=5) and r1 or r2
            local b = makeBtn(p, d[1], d[3], function() if Presets[d[2]] then applyGesture(Presets[d[2]]) end end)
            b.Size = UDim2.new(0,62,0,34)
        end

        cat("单/双手动作")
        local r3, r4 = row(), row()
        local cdefs = {
            {"右捏","PinchR",Color3.fromRGB(80,120,200)},{"右抓","GrabR",Color3.fromRGB(80,150,120)},
            {"左捏","PinchL",Color3.fromRGB(200,120,80)},{"左抓","GrabL",Color3.fromRGB(150,80,150)},
            {"挥手","Flap",Color3.fromRGB(100,100,180)},{"牛角","Horns",Color3.fromRGB(180,80,80)},
            {"Shaka","Shaka",Color3.fromRGB(80,180,140)},{"敬礼","Salute",Color3.fromRGB(140,140,80)},
            {"祈祷","Pray",Color3.fromRGB(120,120,180)},{"爪子","Claw",Color3.fromRGB(150,100,60)},
        }
        for i, d in ipairs(cdefs) do
            local p = (i<=5) and r3 or r4
            local b = makeBtn(p, d[1], d[3], function() if Presets[d[2]] then applyGesture(Presets[d[2]]) end end)
            b.Size = UDim2.new(0,62,0,34)
        end

        cat("单根手指 (点一下切换)")
        local fdefs = {
            {"右拇指","r","Thumb",Color3.fromRGB(150,80,80)},{"右食指","r","Index",Color3.fromRGB(150,80,120)},
            {"右中指","r","Middle",Color3.fromRGB(150,80,160)},{"右无名","r","Ring",Color3.fromRGB(150,80,190)},
            {"右小指","r","Pinky",Color3.fromRGB(150,80,220)},{"右拳","r","Fist",Color3.fromRGB(180,80,80)},
            {"左拇指","l","Thumb",Color3.fromRGB(80,150,150)},{"左食指","l","Index",Color3.fromRGB(80,150,120)},
            {"左中指","l","Middle",Color3.fromRGB(80,150,90)},{"左无名","l","Ring",Color3.fromRGB(80,150,60)},
            {"左小指","l","Pinky",Color3.fromRGB(80,150,30)},{"左拳","l","Fist",Color3.fromRGB(100,180,100)},
        }
        local fr1, fr2, fr3 = row(), row(), row()
        for i, d in ipairs(fdefs) do
            local p = (i<=4) and fr1 or ((i<=8) and fr2 or fr3)
            local b = makeBtn(p, d[1], d[4], function()
                if Input then
                    local g = {}; g[d[2]..d[3]] = 1
                    if not preFingerState then preFingerState = saveState() end
                    applyGesture(g)
                    task.delay(0.5, function() if preFingerState then loadState(preFingerState); preFingerState = nil end end)
                end
            end)
            b.Size = UDim2.new(0,90,0,32)
        end

        cat("手旋转 (点击切换)")
        local rr = row()
        local rsl = Instance.new("TextLabel", scroll); rsl.Size = UDim2.new(1,0,0,22)
        rsl.BackgroundTransparency = 1; rsl.Text = "当前: 双手"
        rsl.TextColor3 = Color3.fromRGB(255,220,120); rsl.Font = Enum.Font.Code; rsl.TextSize = 12
        local function upR() rsl.Text = middleMouseHeld and ("旋转中: "..rotTarget) or ("旋转目标: "..rotTarget) end
        local bb = makeBtn(rr, "双手", Color3.fromRGB(120,120,200), function() rotTarget = "both"; upR() end); bb.Size = UDim2.new(0,100,0,34)
        local br = makeBtn(rr, "只右手", Color3.fromRGB(180,120,80), function() rotTarget = "right"; upR() end); br.Size = UDim2.new(0,100,0,34)
        local bl = makeBtn(rr, "只左手", Color3.fromRGB(80,150,180), function() rotTarget = "left"; upR() end); bl.Size = UDim2.new(0,100,0,34)

        cat("旋转角度 (拖拽调节)")
        local function msl(name, color, mn, mx, getFn, setFn)
            local sl = Instance.new("Frame", scroll); sl.Size = UDim2.new(1,0,0,24)
            sl.BackgroundColor3 = Color3.fromRGB(50,50,65); sl.BorderSizePixel = 0
            Instance.new("UICorner", sl).CornerRadius = UDim.new(0,4)
            local fl = Instance.new("Frame", sl)
            fl.Size = UDim2.new((getFn()-mn)/(mx-mn),0,1,0)
            fl.BackgroundColor3 = color; fl.BorderSizePixel = 0
            Instance.new("UICorner", fl).CornerRadius = UDim.new(0,4)
            local lb = Instance.new("TextLabel", sl); lb.Size = UDim2.new(1,0,1,0); lb.BackgroundTransparency = 1
            lb.Text = name..": "..string.format("%.3f", getFn())
            lb.TextColor3 = Color3.fromRGB(255,255,255); lb.Font = Enum.Font.Code; lb.TextSize = 11
            local drag = false
            local function upd(inp)
                local rel = math.clamp((inp.Position.X - sl.AbsolutePosition.X) / sl.AbsoluteSize.X, 0, 1)
                local v = mn + (mx-mn)*rel
                fl.Size = UDim2.new(rel,0,1,0); lb.Text = name..": "..string.format("%.3f", v); setFn(v)
            end
            sl.InputBegan:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then drag=true; upd(inp) end end)
            sl.InputChanged:Connect(function(inp) if drag and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then upd(inp) end end)
            UIS.InputEnded:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then drag=false end end)
        end
        msl("滑屏灵敏度", Color3.fromRGB(220,100,220), 0.001, 0.02, function() return S.sens end, function(v) S.sens = v end)
        msl("水平旋转", Color3.fromRGB(100,150,220), -3.14, 3.14, function() return HandRot[rotTarget].yaw end, function(v) HandRot[rotTarget].yaw = v end)
        msl("垂直旋转", Color3.fromRGB(220,150,100), -1.5, 1.5, function() return HandRot[rotTarget].pitch end, function(v) HandRot[rotTarget].pitch = v end)

        cat("体型")
        local sr = row()
        makeBtn(sr, "-", Color3.fromRGB(150,80,80), function() setScale(S.scale-1) end).Size = UDim2.new(0,60,0,34)
        local slb = Instance.new("TextLabel", sr); slb.Size = UDim2.new(0,100,0,34)
        slb.BackgroundColor3 = Color3.fromRGB(40,40,55); slb.Text = "体型: 10"
        slb.TextColor3 = Color3.fromRGB(255,255,255); slb.Font = Enum.Font.GothamBold; slb.TextSize = 13
        Instance.new("UICorner", slb).CornerRadius = UDim.new(0,6)
        makeBtn(sr, "+", Color3.fromRGB(80,150,80), function() setScale(S.scale+1) end).Size = UDim2.new(0,60,0,34)
        task.spawn(function() while true do slb.Text = "体型: "..S.scale.."/10"; task.wait(0.3) end end)

        cat("手距")
        msl("手距", Color3.fromRGB(160,120,200), 0.15, 2.5, function() return S.reach end, function(v) S.reach = v end)

        cat("抓取 (按住)")
        local gr = row()
        local gR = makeBtn(gr, "抓右", Color3.fromRGB(200,100,100), function() end); gR.Size = UDim2.new(0,100,0,34)
        gR.MouseButton1Down:Connect(function() if Input then applyGesture({rFist=1,rIndex=1}) end end)
        gR.MouseButton1Up:Connect(function() if Input then applyGesture({rFist=0,rIndex=0}) end end)
        local gL = makeBtn(gr, "抓左", Color3.fromRGB(100,150,200), function() end); gL.Size = UDim2.new(0,100,0,34)
        gL.MouseButton1Down:Connect(function() if Input then applyGesture({lFist=1,lIndex=1}) end end)
        gL.MouseButton1Up:Connect(function() if Input then applyGesture({lFist=0,lIndex=0}) end end)
        makeBtn(gr, "重置", Color3.fromRGB(120,120,140), function()
            if Input then applyGesture({rFist=0,rIndex=0,lFist=0,lIndex=0,rThumb=0,lThumb=0}) end
        end).Size = UDim2.new(0,100,0,34)

        cat("视角")
        local vr = row()
        makeBtn(vr, "锁定/解锁视角", Color3.fromRGB(100,150,100), function() setLook(not S.look) end).Size = UDim2.new(0,200,0,34)
    end)

    -- 左下角方向键
    pcall(function()
        local dpGui = Instance.new("ScreenGui")
        dpGui.Name = "NoVR_DPad"; dpGui.ResetOnSpawn = false
        dpGui.IgnoreGuiInset = true; dpGui.DisplayOrder = 9999
        dpGui.Parent = lp:WaitForChild("PlayerGui")

        local function refreshBusy()
            local s = getgenv().dpadState
            getgenv().dpadBusy = (s.up or s.down or s.left or s.right)
        end
        local function updateDPad()
            local x, y = 0, 0
            local s = getgenv().dpadState
            if s.up then y = -1 end
            if s.down then y = 1 end
            if s.left then x = -1 end
            if s.right then x = 1 end
            getgenv().joyOffset = Vector2.new(x, y)
            refreshBusy()
        end

        local container = Instance.new("Frame", dpGui)
        container.AnchorPoint = Vector2.new(0,1)
        container.Position = UDim2.new(0,30,1,-30)
        container.Size = UDim2.fromOffset(220,220)
        container.BackgroundTransparency = 1
        container.Active = true

        local function mkBtn(text, pos, size, key)
            local btn = Instance.new("TextButton", container)
            btn.Position = pos; btn.Size = size
            btn.BackgroundColor3 = Color3.fromRGB(60,60,70)
            btn.BackgroundTransparency = 0.3; btn.BorderSizePixel = 0
            btn.Text = text; btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.TextSize = 32; btn.Font = Enum.Font.GothamBold; btn.Active = true
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
            local sk = Instance.new("UIStroke", btn)
            sk.Color = Color3.fromRGB(0,255,170); sk.Thickness = 2; sk.Transparency = 0.4

            local activeTouch = nil
            local function doPress()
                getgenv().dpadState[key] = true
                btn.BackgroundColor3 = Color3.fromRGB(0,200,140)
                updateDPad()
            end
            local function doRelease()
                activeTouch = nil
                getgenv().dpadState[key] = false
                btn.BackgroundColor3 = Color3.fromRGB(60,60,70)
                updateDPad()
            end
            btn.InputBegan:Connect(function(inp)
                if (inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1) then
                    if activeTouch == nil then activeTouch = inp; doPress() end
                end
            end)
            btn.InputEnded:Connect(function(inp) if inp == activeTouch then doRelease() end end)
            UIS.InputEnded:Connect(function(inp) if inp == activeTouch then doRelease() end end)
        end
        mkBtn("↑", UDim2.new(0.5,-35,0,0), UDim2.fromOffset(70,70), "up")
        mkBtn("↓", UDim2.new(0.5,-35,0,150), UDim2.fromOffset(70,70), "down")
        mkBtn("←", UDim2.new(0,0,0.5,-35), UDim2.fromOffset(70,70), "left")
        mkBtn("→", UDim2.new(1,-70,0.5,-35), UDim2.fromOffset(70,70), "right")
    end)

    -- ============================================================
    -- 右下角射击按钮（点一下 = 单发，长按 = 连发）
    -- ============================================================
    pcall(function()
        local sg = Instance.new("ScreenGui")
        sg.Name = "NoVR_ShootBtn"; sg.ResetOnSpawn = false
        sg.IgnoreGuiInset = true; sg.DisplayOrder = 9999
        sg.Parent = lp:WaitForChild("PlayerGui")

        local btn = Instance.new("TextButton", sg)
        btn.AnchorPoint = Vector2.new(1,1)
        btn.Position = UDim2.new(1,-30,1,-30)
        btn.Size = UDim2.fromOffset(140,140)
        btn.BackgroundColor3 = Color3.fromRGB(220,60,60)
        btn.BackgroundTransparency = 0.15
        btn.BorderSizePixel = 0
        btn.Text = "射击"
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.TextSize = 24
        btn.Font = Enum.Font.GothamBold
        btn.Active = true
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)
        local bs = Instance.new("UIStroke", btn)
        bs.Color = Color3.fromRGB(255,255,255); bs.Thickness = 3; bs.Transparency = 0.3

        local activeTouch = nil
        local autoFiring = false
        local autoThread = nil
        local holdStart = 0

        -- 单次捏合射击
        local function fireOnce()
            if not Input then return end
            applyGesture({ rThumb = 1, rIndex = 1, rFist = 0 })
            task.delay(0.05, function()
                if Input then
                    applyGesture({ rThumb = 0, rIndex = 0, rFist = 0 })
                end
            end)
        end

        -- 连发循环
        local function startAutoFire()
            if autoFiring then return end
            autoFiring = true
            autoThread = task.spawn(function()
                while autoFiring do
                    if Input then
                        applyGesture({ rThumb = 1, rIndex = 1, rFist = 0 })
                    end
                    task.wait(0.05)
                    if Input then
                        applyGesture({ rThumb = 0, rIndex = 0, rFist = 0 })
                    end
                    task.wait(0.05)
                end
            end)
        end

        local function stopAutoFire()
            autoFiring = false
            autoThread = nil
            if Input then
                applyGesture({ rThumb = 0, rIndex = 0, rFist = 0 })
            end
        end

        btn.InputBegan:Connect(function(inp)
            if (inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1) then
                if activeTouch == nil then
                    activeTouch = inp
                    holdStart = tick()
                    btn.BackgroundColor3 = Color3.fromRGB(255,100,100)

                    -- 立即打一枪
                    fireOnce()

                    -- 判断是否长按（0.25 秒后开始连发）
                    task.delay(0.25, function()
                        if activeTouch == inp and (tick() - holdStart) >= 0.24 then
                            startAutoFire()
                        end
                    end)
                end
            end
        end)

        btn.InputEnded:Connect(function(inp)
            if inp == activeTouch then
                activeTouch = nil
                btn.BackgroundColor3 = Color3.fromRGB(220,60,60)
                stopAutoFire()
            end
        end)

        UIS.InputEnded:Connect(function(inp)
            if inp == activeTouch then
                activeTouch = nil
                btn.BackgroundColor3 = Color3.fromRGB(220,60,60)
                stopAutoFire()
            end
        end)

        print("[NoVR Pro] 射击按钮已加载：点一下=单发，长按=连发")
    end)

    print("[NoVR Pro] 全部加载完成")
end)
]==]

if queue_on_teleport then
    queue_on_teleport(hrs)
elseif syn and syn.queue_on_teleport then
    syn.queue_on_teleport(hrs)
end

TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)