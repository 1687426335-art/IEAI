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
    local missing, report = {}, "[VR Hands No-VR Pro] UNC test:\n"
    for _, c in ipairs(checks) do
        local ok = type(c[2]) == "function"
        report = report .. ("  [%s] %s\n"):format(ok and "+" or "-", c[1])
        if not ok then table.insert(missing, c[1]) end
    end
    print(report)
    if #missing > 0 then
        warn("[NoVR Pro] 缺少函数: " .. table.concat(missing, ", "))
        warn("[NoVR Pro] 执行器不支持 - 中止。")
        return
    end
    print("[NoVR Pro] UNC 测试通过，启动中...")
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

-- 全局状态
getgenv().joyOffset   = Vector2.new(0, 0)
getgenv().dpadBusy    = false
getgenv().dpadState   = { up=false, down=false, left=false, right=false }

task.spawn(function()
    local lp = Players.LocalPlayer
    while not lp do task.wait() lp = Players.LocalPlayer end
    local uid = tostring(lp.UserId)

    local vrPlayers = workspace:WaitForChild("VRPlayers", 60)
    if not vrPlayers then warn("[NoVR] 找不到 VRPlayers 文件夹") return end
    local rig = vrPlayers:WaitForChild(uid, 60)
    if not rig then warn("[NoVR] 服务器没有分配 rig") return end
    rig:WaitForChild("VRHead", 20)
    rig:WaitForChild("LeftHand", 20)
    rig:WaitForChild("RightHand", 20)
    local scaleVal = rig:FindFirstChild("VRScale")
    local cam = workspace.CurrentCamera

    local S = {
        reach  = 0.55, spread = 0.34, height = -0.25,
        sens   = 0.005, moveK = 0.16, look = true,
        scale  = 10,
    }

    local Gesture = {
        rThumb = 0, rIndex = 0, rMiddle = 0, rRing = 0, rPinky = 0, rFist = 0,
        lThumb = 0, lIndex = 0, lMiddle = 0, lRing = 0, lPinky = 0, lFist = 0,
        presetName = "None",
    }

    local HandRot = {
        both  = { yaw = 0, pitch = 0 },
        right = { yaw = 0, pitch = 0 },
        left  = { yaw = 0, pitch = 0 },
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
        print("[NoVR] VRUtils 拦截成功，支持手旋转")
    else
        warn("[NoVR] 拦截 VRUtils 失败，手旋转不可用")
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

    if not Input then
        warn("[NoVR] 未找到 Input 对象 - 手势功能不可用")
    else
        print("[NoVR] Input 对象已找到")
    end

    local Supported = {}
    local SupportedList = {}
    if Input then
        for k, v in pairs(Input) do
            if type(v) == "number" then
                Supported[k] = true
                table.insert(SupportedList, k)
            end
        end
        table.sort(SupportedList)
        print("[NoVR] Input 支持的数字字段: " .. table.concat(SupportedList, ", "))
    end

    local HAS_FULL_FINGERS = Supported.rMiddle == true
    if HAS_FULL_FINGERS then
        print("[NoVR] 检测到完整手指支持")
    else
        print("[NoVR] 检测到简化手指支持，中指/无名指/小指用 Fist 代理")
    end

    local function safeSetInput(key, value)
        if Input and Supported[key] then
            local ok = pcall(function() Input[key] = value end)
            return ok
        end
        return false
    end

    local function applyGesture(g)
        if not Input then return end

        local function calcProxyFist(hand, gTable)
            if HAS_FULL_FINGERS then return nil end
            local fistKey = hand .. "Fist"
            if gTable[fistKey] ~= nil then return nil end
            local middle = gTable[hand .. "Middle"] or 0
            local ring   = gTable[hand .. "Ring"]   or 0
            local pinky  = gTable[hand .. "Pinky"]  or 0
            local bendCount = middle + ring + pinky
            if bendCount > 0 then
                return math.clamp(bendCount / 3, 0.2, 1)
            end
            return nil
        end

        local rProxy = calcProxyFist("r", g)
        local lProxy = calcProxyFist("l", g)

        if g.rThumb  ~= nil then safeSetInput("rThumb",  g.rThumb)  end
        if g.rIndex  ~= nil then safeSetInput("rIndex",  g.rIndex)  end
        if g.rMiddle ~= nil and Supported.rMiddle then safeSetInput("rMiddle", g.rMiddle) end
        if g.rRing   ~= nil and Supported.rRing   then safeSetInput("rRing",   g.rRing)   end
        if g.rPinky  ~= nil and Supported.rPinky  then safeSetInput("rPinky",  g.rPinky)  end
        if g.rFist   ~= nil then safeSetInput("rFist",   g.rFist)
        elseif rProxy then safeSetInput("rFist", rProxy) end

        if g.lThumb  ~= nil then safeSetInput("lThumb",  g.lThumb)  end
        if g.lIndex  ~= nil then safeSetInput("lIndex",  g.lIndex)  end
        if g.lMiddle ~= nil and Supported.lMiddle then safeSetInput("lMiddle", g.lMiddle) end
        if g.lRing   ~= nil and Supported.lRing   then safeSetInput("lRing",   g.lRing)   end
        if g.lPinky  ~= nil and Supported.lPinky  then safeSetInput("lPinky",  g.lPinky)  end
        if g.lFist   ~= nil then safeSetInput("lFist",   g.lFist)
        elseif lProxy then safeSetInput("lFist", lProxy) end

        for k, v in pairs(g) do
            if Gesture[k] ~= nil and type(v) == "number" then
                Gesture[k] = v
            end
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
        [Enum.KeyCode.One]   = "Open", [Enum.KeyCode.Two]   = "Fist", [Enum.KeyCode.Three] = "Point", [Enum.KeyCode.Four]  = "Peace", [Enum.KeyCode.Five]  = "ThumbsUp",
        [Enum.KeyCode.Six]   = "OK", [Enum.KeyCode.Seven] = "Rock", [Enum.KeyCode.Eight] = "Middle", [Enum.KeyCode.Nine]  = "Phone", [Enum.KeyCode.Zero]  = "Gun",
    }
    local PresetKeysCtrl = {
        [Enum.KeyCode.One]   = "PinchR", [Enum.KeyCode.Two]   = "GrabR", [Enum.KeyCode.Three] = "PinchL", [Enum.KeyCode.Four]  = "GrabL", [Enum.KeyCode.Five]  = "Flap",
        [Enum.KeyCode.Six]   = "Horns", [Enum.KeyCode.Seven] = "Shaka", [Enum.KeyCode.Eight] = "Salute", [Enum.KeyCode.Nine]  = "Pray", [Enum.KeyCode.Zero]  = "Claw",
    }
    local FingerKeys = {
        [Enum.KeyCode.T] = { hand="r", finger="Thumb",  name="右拇指" }, [Enum.KeyCode.Y] = { hand="r", finger="Index",  name="右食指" },
        [Enum.KeyCode.U] = { hand="r", finger="Middle", name="右中指" }, [Enum.KeyCode.I] = { hand="r", finger="Ring",   name="右无名指" },
        [Enum.KeyCode.O] = { hand="r", finger="Pinky",  name="右小指" }, [Enum.KeyCode.P] = { hand="r", finger="Fist",   name="右拳" },
        [Enum.KeyCode.Z] = { hand="l", finger="Thumb",  name="左拇指" }, [Enum.KeyCode.X] = { hand="l", finger="Index",  name="左食指" },
        [Enum.KeyCode.C] = { hand="l", finger="Middle", name="左中指" }, [Enum.KeyCode.V] = { hand="l", finger="Ring",   name="左无名指" },
        [Enum.KeyCode.B] = { hand="l", finger="Pinky",  name="左小指" }, [Enum.KeyCode.N] = { hand="l", finger="Fist",   name="左拳" },
    }

    local heldFingers = {}
    local preFingerState = nil
    local keys = {}

    local function saveState()
        return { rThumb=Gesture.rThumb, rIndex=Gesture.rIndex, rMiddle=Gesture.rMiddle, rRing=Gesture.rRing, rPinky=Gesture.rPinky, rFist=Gesture.rFist, lThumb=Gesture.lThumb, lIndex=Gesture.lIndex, lMiddle=Gesture.lMiddle, lRing=Gesture.lRing, lPinky=Gesture.lPinky, lFist=Gesture.lFist, }
    end

    local function loadState(st)
        if not st then return end
        applyGesture(st)
    end

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

    cam.HeadLocked = true
    local yaw, pitch
    do
        local lv = cam.CFrame.LookVector
        yaw   = math.atan2(-lv.X, -lv.Z)
        pitch = math.asin(math.clamp(lv.Y, -1, 1))
    end
    local camPos = cam.CFrame.Position

    local function setLook(v)
        S.look = v
        UIS.MouseBehavior    = v and Enum.MouseBehavior.LockCenter or Enum.MouseBehavior.Default
        UIS.MouseIconEnabled = not v
    end
    setLook(true)

    UIS.InputBegan:Connect(function(io)
        if io.UserInputType == Enum.UserInputType.Keyboard then
            keys[io.KeyCode] = true
            if io.KeyCode == Enum.KeyCode.F then rotTarget = "right" end
            if io.KeyCode == Enum.KeyCode.G then rotTarget = "left" end
            if io.KeyCode == Enum.KeyCode.LeftAlt then setLook(not S.look) end
            if io.KeyCode == Enum.KeyCode.Equals  then setScale(S.scale + 1) end
            if io.KeyCode == Enum.KeyCode.Minus   then setScale(S.scale - 1) end
            if Input and io.KeyCode == Enum.KeyCode.E then applyGesture({rIndex=1, rFist=0, rThumb=0}) end
            if Input and io.KeyCode == Enum.KeyCode.Q then applyGesture({lIndex=1, lFist=0, lThumb=0}) end
            local preset = PresetKeys[io.KeyCode]
            if preset and Presets[preset] then applyGesture(Presets[preset]) end
            if keys[Enum.KeyCode.LeftControl] or keys[Enum.KeyCode.RightControl] then
                local presetCtrl = PresetKeysCtrl[io.KeyCode]
                if presetCtrl and Presets[presetCtrl] then applyGesture(Presets[presetCtrl]) end
            end
            local fk = FingerKeys[io.KeyCode]
            if fk then
                if not next(heldFingers) then preFingerState = saveState() end
                heldFingers[io.KeyCode] = true
                local g = {}; g[fk.hand .. fk.finger] = 1; applyGesture(g)
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
                if not next(heldFingers) then
                    loadState(preFingerState); preFingerState = nil
                else
                    local g = {}; g[fk.hand .. fk.finger] = 0; applyGesture(g)
                end
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
            local target = HandRot[rotTarget]
            target.yaw   = target.yaw   - d.X * 0.008
            target.pitch = math.clamp(target.pitch - d.Y * 0.008, -1.5, 1.5)
            UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
        elseif not dpadBusy then
            if S.look then
                local d = UIS:GetMouseDelta()
                yaw   = yaw - d.X * S.sens
                pitch = math.clamp(pitch - d.Y * S.sens, -1.45, 1.45)
                UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
            end
        else
            UIS:GetMouseDelta()
        end

        local rot = CFrame.fromEulerAnglesYXZ(pitch, yaw, 0)

        local hs  = cam.HeadScale; if hs <= 1 then hs = S.scale * 6 end
        local spd = (10 + S.scale * 4) * hs * S.moveK
        local mv  = Vector3.zero
        if keys[Enum.KeyCode.W] then mv += Vector3.new(0,0,-1) end
        if keys[Enum.KeyCode.S] then mv += Vector3.new(0,0, 1) end
        if keys[Enum.KeyCode.A] then mv += Vector3.new(-1,0,0) end
        if keys[Enum.KeyCode.D] then mv += Vector3.new( 1,0,0) end
        if keys[Enum.KeyCode.Space]     then mv += Vector3.new(0, 1,0) end
        if keys[Enum.KeyCode.LeftShift] then mv += Vector3.new(0,-1,0) end

        local jo = getgenv().joyOffset
        if jo and jo.Magnitude > 0.08 then
            mv += Vector3.new(jo.X, 0, jo.Y)
        end

        if mv.Magnitude > 0 then camPos = camPos + (rot * mv.Unit) * spd * dt end

        cam.CameraType = Enum.CameraType.Scriptable
        cam.CFrame = CFrame.new(camPos) * rot

        if Input then
            Input.directionLateral  = Vector2.zero
            Input.directionVertical = 0
            Input.turnDirection     = 0
        end
    end)

    -- 屏幕 HUD
    pcall(function()
        local gui = Instance.new("ScreenGui")
        gui.Name = "NoVR_HUD"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true
        gui.Parent = lp:WaitForChild("PlayerGui")
        local mainFrame = Instance.new("Frame", gui)
        mainFrame.AnchorPoint = Vector2.new(0,0); mainFrame.Position = UDim2.new(0,10,0,10)
        mainFrame.Size = UDim2.new(0,300,0,72); mainFrame.BackgroundColor3 = Color3.fromRGB(15,15,20)
        mainFrame.BackgroundTransparency = 0.3; mainFrame.BorderSizePixel = 0
        local corner = Instance.new("UICorner", mainFrame); corner.CornerRadius = UDim.new(0,8)
        local title = Instance.new("TextLabel", mainFrame)
        title.Size = UDim2.new(1,-10,0,20); title.Position = UDim2.new(0,5,0,3)
        title.BackgroundTransparency = 1; title.Text = "VR 手势 (手机可点)"; title.TextColor3 = Color3.fromRGB(0,255,170)
        title.Font = Enum.Font.GothamBold; title.TextSize = 14; title.TextXAlignment = Enum.TextXAlignment.Left
        local hudLabel = Instance.new("TextLabel", mainFrame)
        hudLabel.Size = UDim2.new(1,-10,0,20); hudLabel.Position = UDim2.new(0,5,0,22)
        hudLabel.BackgroundTransparency = 1; hudLabel.TextColor3 = Color3.fromRGB(255,255,255)
        hudLabel.TextXAlignment = Enum.TextXAlignment.Left; hudLabel.Font = Enum.Font.Code; hudLabel.TextSize = 12
        local statusLabel = Instance.new("TextLabel", mainFrame)
        statusLabel.Size = UDim2.new(1,-10,0,20); statusLabel.Position = UDim2.new(0,5,0,44)
        statusLabel.BackgroundTransparency = 1; statusLabel.TextColor3 = Color3.fromRGB(255,220,120)
        statusLabel.TextXAlignment = Enum.TextXAlignment.Left; statusLabel.Font = Enum.Font.Code; statusLabel.TextSize = 12
        RunService.Heartbeat:Connect(function()
            hudLabel.Text = string.format("动作: %s | 体型: %d/10", Gesture.presetName, S.scale)
            statusLabel.Text = string.format("手距: %.2f | %s", S.reach, middleMouseHeld and ("旋转中-"..rotTarget) or (getgenv().dpadBusy and "移动中" or "未旋转"))
        end)
    end)

    -- 手机手势面板
    local mobileOpen = false
    local mobileFrame, toggleBtn
    local function makeButton(parent, text, color, callback)
        local btn = Instance.new("TextButton", parent); btn.BackgroundColor3 = color or Color3.fromRGB(40,40,55)
        btn.BorderSizePixel = 0; btn.Text = text; btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.GothamBold; btn.TextSize = 12; btn.AutoButtonColor = true
        local c = Instance.new("UICorner", btn); c.CornerRadius = UDim.new(0,6)
        btn.MouseButton1Click:Connect(callback); return btn
    end

    pcall(function()
        local gui = Instance.new("ScreenGui")
        gui.Name = "NoVR_MobilePanel"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true
        gui.Parent = lp:WaitForChild("PlayerGui")
        toggleBtn = Instance.new("TextButton", gui); toggleBtn.Size = UDim2.new(0, 60, 0, 60)
        toggleBtn.Position = UDim2.new(1, -70, 0, 90); toggleBtn.BackgroundColor3 = Color3.fromRGB(0,150,120)
        toggleBtn.BorderSizePixel = 0; toggleBtn.Text = "手势"; toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
        toggleBtn.Font = Enum.Font.GothamBold; toggleBtn.TextSize = 16; toggleBtn.Active = true; toggleBtn.Draggable = true
        local tbC = Instance.new("UICorner", toggleBtn); tbC.CornerRadius = UDim.new(1,0)
        toggleBtn.MouseButton1Click:Connect(function() mobileOpen = not mobileOpen; if mobileFrame then mobileFrame.Visible = mobileOpen end end)
        mobileFrame = Instance.new("Frame", gui); mobileFrame.Visible = false; mobileFrame.AnchorPoint = Vector2.new(1,0)
        mobileFrame.Position = UDim2.new(1,-10,0,160); mobileFrame.Size = UDim2.new(0, 340, 0, 460)
        mobileFrame.BackgroundColor3 = Color3.fromRGB(20,20,28); mobileFrame.BackgroundTransparency = 0.1
        mobileFrame.BorderSizePixel = 0; local mfC = Instance.new("UICorner", mobileFrame); mfC.CornerRadius = UDim.new(0,10)
        local title = Instance.new("TextLabel", mobileFrame); title.Size = UDim2.new(1,0,0,26); title.Position = UDim2.new(0,0,0,4)
        title.BackgroundTransparency = 1; title.Text = "点击按钮触动手势"; title.TextColor3 = Color3.fromRGB(0,255,170)
        title.Font = Enum.Font.GothamBold; title.TextSize = 14
        local scroll = Instance.new("ScrollingFrame", mobileFrame); scroll.Position = UDim2.new(0,6,0,32)
        scroll.Size = UDim2.new(1,-12,1,-40); scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 4; scroll.ScrollBarImageColor3 = Color3.fromRGB(100,100,120)
        scroll.CanvasSize = UDim2.new(0,0,0,0)
        local layout = Instance.new("UIListLayout", scroll); layout.Padding = UDim.new(0,6); layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() scroll.CanvasSize = UDim2.new(0,0,0, layout.AbsoluteContentSize.Y + 10) end)
        local function makeCategory(text)
            local lbl = Instance.new("TextLabel", scroll); lbl.Size = UDim2.new(1,0,0,22); lbl.BackgroundTransparency = 1
            lbl.Text = "── " .. text .. " ──"; lbl.TextColor3 = Color3.fromRGB(180,180,200)
            lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12; return lbl
        end
        local function makeRow()
            local row = Instance.new("Frame", scroll); row.Size = UDim2.new(1,0,0,38); row.BackgroundTransparency = 1
            local rl = Instance.new("UIListLayout", row); rl.FillDirection = Enum.FillDirection.Horizontal
            rl.Padding = UDim.new(0,4); rl.SortOrder = Enum.SortOrder.LayoutOrder; return row
        end
        makeCategory("快捷动作")
        local row1, row2 = makeRow(), makeRow()
        local presetBtnDefs = {
            { "张开", "Open", Color3.fromRGB(60,100,180) }, { "握拳", "Fist", Color3.fromRGB(180,60,60) },
            { "食指", "Point", Color3.fromRGB(80,150,80) }, { "剪刀", "Peace", Color3.fromRGB(150,100,180) },
            { "点赞", "ThumbsUp", Color3.fromRGB(180,150,60) }, { "OK", "OK", Color3.fromRGB(60,170,170) },
            { "摇滚", "Rock", Color3.fromRGB(150,60,150) }, { "中指", "Middle", Color3.fromRGB(120,120,120) },
            { "电话", "Phone", Color3.fromRGB(100,150,60) }, { "手枪", "Gun", Color3.fromRGB(60,60,150) },
        }
        for i, def in ipairs(presetBtnDefs) do
            local parent = (i <= 5) and row1 or row2
            local b = makeButton(parent, def[1], def[3], function() if Presets[def[2]] then applyGesture(Presets[def[2]]) end end)
            b.Size = UDim2.new(0, 62, 0, 34)
        end
        makeCategory("单/双手动作")
        local row3, row4 = makeRow(), makeRow()
        local ctrlDefs = {
            { "右捏", "PinchR", Color3.fromRGB(80,120,200) }, { "右抓", "GrabR", Color3.fromRGB(80,150,120) },
            { "左捏", "PinchL", Color3.fromRGB(200,120,80) }, { "左抓", "GrabL", Color3.fromRGB(150,80,150) },
            { "挥手", "Flap", Color3.fromRGB(100,100,180) }, { "牛角", "Horns", Color3.fromRGB(180,80,80) },
            { "Shaka", "Shaka", Color3.fromRGB(80,180,140) }, { "敬礼", "Salute", Color3.fromRGB(140,140,80) },
            { "祈祷", "Pray", Color3.fromRGB(120,120,180) }, { "爪子", "Claw", Color3.fromRGB(150,100,60) },
        }
        for i, def in ipairs(ctrlDefs) do
            local parent = (i <= 5) and row3 or row4
            local b = makeButton(parent, def[1], def[3], function() if Presets[def[2]] then applyGesture(Presets[def[2]]) end end)
            b.Size = UDim2.new(0, 62, 0, 34)
        end
        makeCategory("单根手指 (点一下切换)")
        local fingerDefs = {
            { "右拇指", "r", "Thumb", Color3.fromRGB(150,80,80) }, { "右食指", "r", "Index", Color3.fromRGB(150,80,120) },
            { "右中指", "r", "Middle", Color3.fromRGB(150,80,160) }, { "右无名", "r", "Ring",   Color3.fromRGB(150,80,190) },
            { "右小指", "r", "Pinky",  Color3.fromRGB(150,80,220) }, { "右拳",   "r", "Fist",   Color3.fromRGB(180,80,80) },
            { "左拇指", "l", "Thumb", Color3.fromRGB(80,150,150) }, { "左食指", "l", "Index", Color3.fromRGB(80,150,120) },
            { "左中指", "l", "Middle", Color3.fromRGB(80,150,90) }, { "左无名", "l", "Ring",   Color3.fromRGB(80,150,60) },
            { "左小指", "l", "Pinky",  Color3.fromRGB(80,150,30) }, { "左拳",   "l", "Fist",   Color3.fromRGB(100,180,100) },
        }
        local fingerRow1, fingerRow2, fingerRow3 = makeRow(), makeRow(), makeRow()
        for i, def in ipairs(fingerDefs) do
            local parent = (i <= 4) and fingerRow1 or ((i <= 8) and fingerRow2 or fingerRow3)
            local b = makeButton(parent, def[1], def[4], function()
                if Input then
                    local g = {}; g[def[2] .. def[3]] = 1
                    if not preFingerState then preFingerState = saveState() end
                    applyGesture(g)
                    task.delay(0.5, function() if preFingerState then loadState(preFingerState); preFingerState = nil end end)
                end
            end)
            b.Size = UDim2.new(0, 90, 0, 32)
        end
        makeCategory("手旋转 (点击切换)")
        local rotRow = makeRow()
        local rotStatusLabel = Instance.new("TextLabel", scroll); rotStatusLabel.Size = UDim2.new(1,0,0,22)
        rotStatusLabel.BackgroundTransparency = 1; rotStatusLabel.Text = "当前: 双手"; rotStatusLabel.TextColor3 = Color3.fromRGB(255,220,120)
        rotStatusLabel.Font = Enum.Font.Code; rotStatusLabel.TextSize = 12
        local function updateRotLabel() rotStatusLabel.Text = middleMouseHeld and ("旋转中: " .. rotTarget) or ("旋转目标: " .. rotTarget) end
        local bBoth = makeButton(rotRow, "双手", Color3.fromRGB(120,120,200), function() rotTarget = "both"; updateRotLabel() end); bBoth.Size = UDim2.new(0, 100, 0, 34)
        local bRight = makeButton(rotRow, "只右手", Color3.fromRGB(180,120,80), function() rotTarget = "right"; updateRotLabel() end); bRight.Size = UDim2.new(0, 100, 0, 34)
        local bLeft = makeButton(rotRow, "只左手", Color3.fromRGB(80,150,180), function() rotTarget = "left"; updateRotLabel() end); bLeft.Size = UDim2.new(0, 100, 0, 34)
        makeCategory("旋转角度 (拖拽调节)")
        local function makeSlider(name, color, minV, maxV, getFn, setFn)
            local slider = Instance.new("Frame", scroll); slider.Size = UDim2.new(1,0,0,24)
            slider.BackgroundColor3 = Color3.fromRGB(50,50,65); slider.BorderSizePixel = 0
            local sc = Instance.new("UICorner", slider); sc.CornerRadius = UDim.new(0,4)
            local fill = Instance.new("Frame", slider); fill.Size = UDim2.new((getFn()-minV)/(maxV-minV),0,1,0)
            fill.BackgroundColor3 = color; fill.BorderSizePixel = 0
            local fc = Instance.new("UICorner", fill); fc.CornerRadius = UDim.new(0,4)
            local label = Instance.new("TextLabel", slider); label.Size = UDim2.new(1,0,1,0); label.BackgroundTransparency = 1
            label.Text = name .. ": " .. string.format("%.3f", getFn()); label.TextColor3 = Color3.fromRGB(255,255,255)
            label.Font = Enum.Font.Code; label.TextSize = 11
            local dragging = false
            local function update(input)
                local rel = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                local val = minV + (maxV - minV) * rel
                fill.Size = UDim2.new(rel, 0, 1, 0); label.Text = name .. ": " .. string.format("%.3f", val); setFn(val)
            end
            slider.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; update(input) end end)
            slider.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end end)
            UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
        end
        makeSlider("滑屏灵敏度", Color3.fromRGB(220, 100, 220), 0.001, 0.02, function() return S.sens end, function(v) S.sens = v end)
        makeSlider("水平旋转", Color3.fromRGB(100,150,220), -3.14, 3.14, function() return HandRot[rotTarget].yaw end, function(v) HandRot[rotTarget].yaw = v end)
        makeSlider("垂直旋转", Color3.fromRGB(220,150,100), -1.5, 1.5, function() return HandRot[rotTarget].pitch end, function(v) HandRot[rotTarget].pitch = v end)
        makeCategory("体型 (点击 +/-)")
        local scaleRow = makeRow()
        local bScaleMinus = makeButton(scaleRow, "-", Color3.fromRGB(150,80,80), function() setScale(S.scale - 1) end); bScaleMinus.Size = UDim2.new(0, 60, 0, 34)
        local bScaleLabel = Instance.new("TextLabel", scaleRow); bScaleLabel.Size = UDim2.new(0, 100, 0, 34)
        bScaleLabel.BackgroundColor3 = Color3.fromRGB(40,40,55); bScaleLabel.Text = "体型: 10"; bScaleLabel.TextColor3 = Color3.fromRGB(255,255,255)
        bScaleLabel.Font = Enum.Font.GothamBold; bScaleLabel.TextSize = 13
        local blC = Instance.new("UICorner", bScaleLabel); blC.CornerRadius = UDim.new(0,6)
        local bScalePlus = makeButton(scaleRow, "+", Color3.fromRGB(80,150,80), function() setScale(S.scale + 1) end); bScalePlus.Size = UDim2.new(0, 60, 0, 34)
        task.spawn(function() while true do bScaleLabel.Text = "体型: " .. S.scale .. "/10"; task.wait(0.3) end end)
        makeCategory("手距 (拖拽)")
        makeSlider("手距", Color3.fromRGB(160,120,200), 0.15, 2.5, function() return S.reach end, function(v) S.reach = v end)
        makeCategory("抓取 (按住)")
        local grabRow = makeRow()
        local bGrabR = makeButton(grabRow, "抓右", Color3.fromRGB(200,100,100), function() end); bGrabR.Size = UDim2.new(0, 100, 0, 34)
        bGrabR.MouseButton1Down:Connect(function() if Input then applyGesture({rFist=1, rIndex=1}) end end)
        bGrabR.MouseButton1Up:Connect(function() if Input then applyGesture({rFist=0, rIndex=0}) end end)
        local bGrabL = makeButton(grabRow, "抓左", Color3.fromRGB(100,150,200), function() end); bGrabL.Size = UDim2.new(0, 100, 0, 34)
        bGrabL.MouseButton1Down:Connect(function() if Input then applyGesture({lFist=1, lIndex=1}) end end)
        bGrabL.MouseButton1Up:Connect(function() if Input then applyGesture({lFist=0, lIndex=0}) end end)
        local bReset = makeButton(grabRow, "重置", Color3.fromRGB(120,120,140), function() if Input then applyGesture({rFist=0, rIndex=0, lFist=0, lIndex=0, rThumb=0, lThumb=0}) end end); bReset.Size = UDim2.new(0, 100, 0, 34)
        makeCategory("视角")
        local viewRow = makeRow()
        local bLook = makeButton(viewRow, "锁定/解锁视角", Color3.fromRGB(100,150,100), function() setLook(not S.look) end); bLook.Size = UDim2.new(0, 200, 0, 34)
        print("[NoVR Pro] 手机按钮面板已加载")
    end)

    -- ============================================================
    -- 左下角方向键（多点触控安全版 - 修复右手滑屏断移动）
    -- ============================================================
    pcall(function()
        local dpGui = Instance.new("ScreenGui")
        dpGui.Name = "NoVR_DPad"
        dpGui.ResetOnSpawn = false
        dpGui.IgnoreGuiInset = true
        dpGui.DisplayOrder = 9999
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
        container.AnchorPoint = Vector2.new(0, 1)
        container.Position = UDim2.new(0, 30, 1, -30)
        container.Size = UDim2.fromOffset(220, 220)
        container.BackgroundTransparency = 1
        container.Active = true

        local function makeDpadBtn(text, pos, size, key)
            local btn = Instance.new("TextButton", container)
            btn.Position = pos
            btn.Size = size
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            btn.BackgroundTransparency = 0.3
            btn.BorderSizePixel = 0
            btn.Text = text
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 32
            btn.Font = Enum.Font.GothamBold
            btn.Active = true
            local c = Instance.new("UICorner", btn); c.CornerRadius = UDim.new(0, 10)
            local stroke = Instance.new("UIStroke", btn)
            stroke.Color = Color3.fromRGB(0, 255, 170)
            stroke.Thickness = 2
            stroke.Transparency = 0.4

            -- ★ 关键：记录最初按下的那根手指的 InputObject
            -- ★ 只有这根手指抬起时才释放，其他手指（比如右手滑屏）抬起不释放
            local activeTouch = nil

            local function doPress()
                getgenv().dpadState[key] = true
                btn.BackgroundColor3 = Color3.fromRGB(0, 200, 140)
                updateDPad()
            end

            local function doRelease()
                activeTouch = nil
                getgenv().dpadState[key] = false
                btn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                updateDPad()
            end

            btn.InputBegan:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.Touch
                    or input.UserInputType == Enum.UserInputType.MouseButton1) then
                    if activeTouch == nil then
                        activeTouch = input
                        doPress()
                    end
                end
            end)

            btn.InputEnded:Connect(function(input)
                if input == activeTouch then
                    doRelease()
                end
            end)

            -- 全局兜底：只处理"自己最初按下的那根手指"抬起
            -- 其他手指（右手滑屏的 Touch）即使抬起，也不影响本按钮
            UIS.InputEnded:Connect(function(input)
                if input == activeTouch then
                    doRelease()
                end
            end)
        end

        makeDpadBtn("↑", UDim2.new(0.5, -35, 0, 0), UDim2.fromOffset(70, 70), "up")
        makeDpadBtn("↓", UDim2.new(0.5, -35, 0, 150), UDim2.fromOffset(70, 70), "down")
        makeDpadBtn("←", UDim2.new(0, 0, 0.5, -35), UDim2.fromOffset(70, 70), "left")
        makeDpadBtn("→", UDim2.new(1, -70, 0.5, -35), UDim2.fromOffset(70, 70), "right")

        print("[NoVR Pro] 左下角方向键已加载（多点触控安全版）")
    end)

    print("[NoVR Pro] 控制已激活。手机点击右上角【手势】按钮，左下角方向键移动。")
end)
]==]

if queue_on_teleport then
    queue_on_teleport(hrs)
elseif syn and syn.queue_on_teleport then
    syn.queue_on_teleport(hrs)
end

TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)