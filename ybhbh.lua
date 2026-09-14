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

-- ============================================================
-- 自动屏蔽左上角 VR 弹窗
-- ============================================================
task.spawn(function()
    local function hidePrompt()
        local function scan(container)
            if not container then return end
            for _, v in pairs(container:GetDescendants()) do
                if (v:IsA("TextLabel") or v:IsA("TextButton")) and v.Text then
                    if string.find(v.Text, "To open the settings") or string.find(v.Text, "left wrist") or string.find(v.Text, "left controller") then
                        v.Visible = false
                        if v.Parent and v.Parent:IsA("GuiObject") then v.Parent.Visible = false end
                    end
                end
            end
        end
        pcall(scan, game:GetService("CoreGui"))
        pcall(scan, Players.LocalPlayer:FindFirstChild("PlayerGui"))
    end
    while task.wait(1) do
        hidePrompt()
    end
end)

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
        sens   = 0.0025, moveK = 0.16, look = true,
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

    local heldFingers = {}
    local preFingerState = nil
    local keys = {}
    local joyOffset = Vector2.new(0, 0)

    local function saveState()
        return {
            rThumb=Gesture.rThumb, rIndex=Gesture.rIndex, rMiddle=Gesture.rMiddle,
            rRing=Gesture.rRing, rPinky=Gesture.rPinky, rFist=Gesture.rFist,
            lThumb=Gesture.lThumb, lIndex=Gesture.lIndex, lMiddle=Gesture.lMiddle,
            lRing=Gesture.lRing, lPinky=Gesture.lPinky, lFist=Gesture.lFist,
        }
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
        elseif io.UserInputType == Enum.UserInputType.MouseButton3 then
            middleMouseHeld = false
            rotTarget = "both"
        end
    end)

    RunService:BindToRenderStep("NoVR_Control", Enum.RenderPriority.Camera.Value + 1, function(dt)
        if middleMouseHeld then
            local d = UIS:GetMouseDelta()
            local target = HandRot[rotTarget]
            target.yaw   = target.yaw   - d.X * 0.008
            target.pitch = math.clamp(target.pitch - d.Y * 0.008, -1.5, 1.5)
            UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
        else
            if S.look then
                local d = UIS:GetMouseDelta()
                yaw   = yaw - d.X * S.sens
                pitch = math.clamp(pitch - d.Y * S.sens, -1.45, 1.45)
                UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
            end
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
        if joyOffset.Magnitude > 0.08 then mv += Vector3.new(joyOffset.X, 0, joyOffset.Y) end
        if mv.Magnitude > 0 then camPos = camPos + (rot * mv.Unit) * spd * dt end

        cam.CameraType = Enum.CameraType.Scriptable
        cam.CFrame = CFrame.new(camPos) * rot

        if Input then
            Input.directionLateral  = Vector2.zero
            Input.directionVertical = 0
            Input.turnDirection     = 0
        end
    end)

    -- ============================================================
    -- 屏幕 HUD
    -- ============================================================
    pcall(function()
        local gui = Instance.new("ScreenGui")
        gui.Name = "NoVR_HUD"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true
        gui.DisplayOrder = 999
        gui.Parent = lp:WaitForChild("PlayerGui")

        local mainFrame = Instance.new("Frame", gui)
        mainFrame.Position = UDim2.new(0,10,0,10)
        mainFrame.Size = UDim2.new(0,300,0,50)
        mainFrame.BackgroundColor3 = Color3.fromRGB(15,15,20)
        mainFrame.BackgroundTransparency = 0.3
        mainFrame.BorderSizePixel = 0
        Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,8)

        local hudLabel = Instance.new("TextLabel", mainFrame)
        hudLabel.Size = UDim2.new(1,-10,0,20); hudLabel.Position = UDim2.new(0,5,0,5)
        hudLabel.BackgroundTransparency = 1; hudLabel.TextColor3 = Color3.fromRGB(255,255,255)
        hudLabel.TextXAlignment = Enum.TextXAlignment.Left
        hudLabel.Font = Enum.Font.Code; hudLabel.TextSize = 12

        RunService.Heartbeat:Connect(function()
            hudLabel.Text = string.format("动作: %s | 体型: %d/10", Gesture.presetName, S.scale)
        end)
    end)

    -- ============================================================
    -- 屏幕正中间摇杆
    -- ============================================================
    pcall(function()
        local jGui = Instance.new("ScreenGui")
        jGui.Name = "NoVR_Joystick"
        jGui.ResetOnSpawn = false
        jGui.IgnoreGuiInset = true
        jGui.DisplayOrder = 999
        jGui.Parent = lp:WaitForChild("PlayerGui")

        local baseSize, knobSize = 180, 80 -- 加大尺寸
        local maxDist = (baseSize - knobSize) / 2

        local base = Instance.new("Frame", jGui)
        base.AnchorPoint = Vector2.new(0.5, 0.5)
        base.Position = UDim2.new(0.5, 0, 0.5, 0) -- 屏幕正中心
        base.Size = UDim2.fromOffset(baseSize, baseSize)
        base.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        base.BackgroundTransparency = 0.4
        base.BorderSizePixel = 0
        base.Active = true
        base.ZIndex = 100
        local bc = Instance.new("UICorner", base); bc.CornerRadius = UDim.new(1, 0)
        local bs = Instance.new("UIStroke", base)
        bs.Color = Color3.fromRGB(0, 255, 170); bs.Thickness = 3; bs.Transparency = 0.3

        local knob = Instance.new("Frame", base)
        knob.AnchorPoint = Vector2.new(0.5, 0.5)
        knob.Position = UDim2.new(0.5, 0, 0.5, 0)
        knob.Size = UDim2.fromOffset(knobSize, knobSize)
        knob.BackgroundColor3 = Color3.fromRGB(0, 200, 140)
        knob.BackgroundTransparency = 0.1
        knob.BorderSizePixel = 0
        knob.ZIndex = 101
        local kc = Instance.new("UICorner", knob); kc.CornerRadius = UDim.new(1, 0)
        local ks = Instance.new("UIStroke", knob)
        ks.Color = Color3.fromRGB(255, 255, 255); ks.Thickness = 3; ks.Transparency = 0.2

        local active = false
        local activeTouch = nil

        local function getBaseCenter()
            return Vector2.new(base.AbsolutePosition.X + base.AbsoluteSize.X / 2, base.AbsolutePosition.Y + base.AbsoluteSize.Y / 2)
        end

        local function setKnobFromPos(pos)
            local center = getBaseCenter()
            local delta = Vector2.new(pos.X - center.X, pos.Y - center.Y)
            local mag = delta.Magnitude
            if mag > maxDist then delta = delta.Unit * maxDist end
            knob.Position = UDim2.new(0.5, delta.X, 0.5, delta.Y)
            joyOffset = Vector2.new(delta.X / maxDist, delta.Y / maxDist)
        end

        local function resetKnob()
            knob.Position = UDim2.new(0.5, 0, 0.5, 0)
            joyOffset = Vector2.new(0, 0)
        end

        base.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                active = true; activeTouch = input
                setKnobFromPos(input.Position)
            end
        end)

        base.InputChanged:Connect(function(input)
            if active and input == activeTouch then setKnobFromPos(input.Position) end
        end)

        UIS.InputChanged:Connect(function(input)
            if active and input == activeTouch then setKnobFromPos(input.Position) end
        end)

        UIS.InputEnded:Connect(function(input)
            if active and input == activeTouch then
                active = false; activeTouch = nil
                resetKnob()
            end
        end)
    end)

    print("[NoVR Pro] 摇杆已放在屏幕正中间，VR弹窗已屏蔽。")
end)
]==]

if queue_on_teleport then
    queue_on_teleport(hrs)
elseif syn and syn.queue_on_teleport then
    syn.queue_on_teleport(hrs)
end

TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)