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
    local missing, report = {}, "[VR Hands No-VR Mobile] UNC test:\n"
    for _, c in ipairs(checks) do
        local ok = type(c[2]) == "function"
        report = report .. ("  [%s] %s\n"):format(ok and "+" or "-", c[1])
        if not ok then table.insert(missing, c[1]) end
    end
    print(report)
    if #missing > 0 then
        warn("[NoVR Mobile] 缺少函数: " .. table.concat(missing, ", "))
        warn("[NoVR Mobile] 执行器不支持 - 中止。")
        return
    end
    print("[NoVR Mobile] UNC 测试通过，启动中...")
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
    local rotTarget = "both"
    local rotating = false

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

    if Input then print("[NoVR] Input 对象已找到") else warn("[NoVR] 未找到 Input 对象") end

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
            if Gesture[k] ~= nil and type(v) == "number" then Gesture[k] = v end
        end
        if g.presetName then Gesture.presetName = g.presetName end
    end

    local Presets = {
        ["Open"]     = { rThumb=0, rIndex=0, rMiddle=0, rRing=0, rPinky=0, rFist=0,
                         lThumb=0, lIndex=0, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="张开" },
        ["Fist"]     = { rThumb=1, rIndex=1, rMiddle=1, rRing=1, rPinky=1, rFist=1,
                         lThumb=1, lIndex=1, lMiddle=1, lRing=1, lPinky=1, lFist=1, presetName="握拳" },
        ["Point"]    = { rThumb=0, rIndex=1, rMiddle=0, rRing=0, rPinky=0, rFist=0,
                         lThumb=0, lIndex=1, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="食指" },
        ["Peace"]    = { rThumb=0, rIndex=1, rMiddle=1, rRing=0, rPinky=0, rFist=0,
                         lThumb=0, lIndex=1, lMiddle=1, lRing=0, lPinky=0, lFist=0, presetName="剪刀手" },
        ["ThumbsUp"] = { rThumb=1, rIndex=0, rMiddle=0, rRing=0, rPinky=0, rFist=1,
                         lThumb=1, lIndex=0, lMiddle=0, lRing=0, lPinky=0, lFist=1, presetName="点赞" },
        ["OK"]       = { rThumb=1, rIndex=1, rMiddle=0, rRing=0, rPinky=0, rFist=0,
                         lThumb=1, lIndex=1, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="OK" },
        ["Rock"]     = { rThumb=0, rIndex=1, rMiddle=0, rRing=0, rPinky=1, rFist=0,
                         lThumb=0, lIndex=1, lMiddle=0, lRing=0, lPinky=1, lFist=0, presetName="摇滚" },
        ["Middle"]   = { rThumb=0, rIndex=0, rMiddle=1, rRing=0, rPinky=0, rFist=0,
                         lThumb=0, lIndex=0, lMiddle=1, lRing=0, lPinky=0, lFist=0, presetName="中指" },
        ["Phone"]    = { rThumb=1, rIndex=0, rMiddle=0, rRing=0, rPinky=1, rFist=0,
                         lThumb=1, lIndex=0, lMiddle=0, lRing=0, lPinky=1, lFist=0, presetName="电话" },
        ["Gun"]      = { rThumb=0, rIndex=1, rMiddle=0, rRing=0, rPinky=0, rFist=0,
                         lThumb=0, lIndex=1, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="手枪" },
        ["GrabR"]    = { rThumb=1, rIndex=1, rMiddle=1, rRing=1, rPinky=1, rFist=1,
                         lThumb=0, lIndex=0, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="右抓" },
        ["GrabL"]    = { rThumb=0, rIndex=0, rMiddle=0, rRing=0, rPinky=0, rFist=0,
                         lThumb=1, lIndex=1, lMiddle=1, lRing=1, lPinky=1, lFist=1, presetName="左抓" },
    }

    local FingerKeys = {
        { hand="r", finger="Thumb",  name="右拇指", color=Color3.fromRGB(120,170,255) },
        { hand="r", finger="Index",  name="右食指", color=Color3.fromRGB(120,170,255) },
        { hand="r", finger="Middle", name="右中指", color=Color3.fromRGB(120,170,255) },
        { hand="r", finger="Ring",   name="右无名", color=Color3.fromRGB(120,170,255) },
        { hand="r", finger="Pinky",  name="右小指", color=Color3.fromRGB(120,170,255) },
        { hand="r", finger="Fist",   name="右拳",   color=Color3.fromRGB(120,170,255) },
        { hand="l", finger="Thumb",  name="左拇指", color=Color3.fromRGB(255,170,120) },
        { hand="l", finger="Index",  name="左食指", color=Color3.fromRGB(255,170,120) },
        { hand="l", finger="Middle", name="左中指", color=Color3.fromRGB(255,170,120) },
        { hand="l", finger="Ring",   name="左无名", color=Color3.fromRGB(255,170,120) },
        { hand="l", finger="Pinky",  name="左小指", color=Color3.fromRGB(255,170,120) },
        { hand="l", finger="Fist",   name="左拳",   color=Color3.fromRGB(255,170,120) },
    }

    local heldFingers = {}
    local preFingerState = nil

    local function saveState()
        return {
            rThumb=Gesture.rThumb, rIndex=Gesture.rIndex, rMiddle=Gesture.rMiddle,
            rRing=Gesture.rRing, rPinky=Gesture.rPinky, rFist=Gesture.rFist,
            lThumb=Gesture.lThumb, lIndex=Gesture.lIndex, lMiddle=Gesture.lMiddle,
            lRing=Gesture.lRing, lPinky=Gesture.lPinky, lFist=Gesture.lFist,
        }
    end

    local keys = {}
    local camPos = cam.CFrame.Position
    local yaw, pitch
    do
        local lv = cam.CFrame.LookVector
        yaw   = math.atan2(-lv.X, -lv.Z)
        pitch = math.asin(math.clamp(lv.Y, -1, 1))
    end
    cam.HeadLocked = true

    local function setScale(n)
        n = math.clamp(math.floor(n + 0.5), 1, 10)
        S.scale = n
        if scaleVal then pcall(function() scaleVal.Value = n / 10 end) end
        if vrm and vrm.DataManager and vrm.DataManager.SettingsManager then
            pcall(function() vrm.DataManager.SettingsManager:SetValue("vrscale", n) end)
        end
    end
    setScale(10)

    -- ============================================================
    -- 移动端 UI
    -- ============================================================
    local playerGui = lp:WaitForChild("PlayerGui")

    local mobileGui = Instance.new("ScreenGui")
    mobileGui.Name = "NoVR_MobileUI"
    mobileGui.ResetOnSpawn = false
    mobileGui.IgnoreGuiInset = true
    mobileGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    mobileGui.Parent = playerGui

    local function makeButton(parent, text, size, pos, bgColor, textColor, textSize)
        local btn = Instance.new("TextButton")
        btn.Size = size
        btn.Position = pos
        btn.BackgroundColor3 = bgColor or Color3.fromRGB(50,50,60)
        btn.BackgroundTransparency = 0.2
        btn.Text = text
        btn.TextColor3 = textColor or Color3.new(1,1,1)
        btn.TextSize = textSize or 16
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = parent
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 10)
        c.Parent = btn
        -- 按下变色
        btn.MouseButton1Down:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(
                math.min(255, btn.BackgroundColor3.R * 255 + 40),
                math.min(255, btn.BackgroundColor3.G * 255 + 40),
                math.min(255, btn.BackgroundColor3.B * 255 + 40)
            )
        end)
        btn.MouseButton1Up:Connect(function()
            btn.BackgroundColor3 = bgColor or Color3.fromRGB(50,50,60)
        end)
        return btn
    end

    -- ========== 左下角 D-pad ==========
    local dpad = Instance.new("Frame")
    dpad.Name = "Dpad"
    dpad.AnchorPoint = Vector2.new(0, 1)
    dpad.Position = UDim2.new(0, 20, 1, -20)
    dpad.Size = UDim2.new(0, 220, 0, 220)
    dpad.BackgroundTransparency = 1
    dpad.Parent = mobileGui

    local btnW  = makeButton(dpad, "▲", UDim2.new(0,68,0,68), UDim2.new(0,76,0,0),   Color3.fromRGB(55,80,130))
    local btnS  = makeButton(dpad, "▼", UDim2.new(0,68,0,68), UDim2.new(0,76,0,152), Color3.fromRGB(55,80,130))
    local btnA  = makeButton(dpad, "◀", UDim2.new(0,68,0,68), UDim2.new(0,0,0,76),   Color3.fromRGB(55,80,130))
    local btnD  = makeButton(dpad, "▶", UDim2.new(0,68,0,68), UDim2.new(0,152,0,76), Color3.fromRGB(55,80,130))
    local btnUp = makeButton(dpad, "升",  UDim2.new(0,68,0,32), UDim2.new(0,76,0,76),  Color3.fromRGB(70,130,70), nil, 15)
    local btnDn = makeButton(dpad, "降",  UDim2.new(0,68,0,32), UDim2.new(0,76,0,112), Color3.fromRGB(130,70,70), nil, 15)

    local function bindHold(btn, key)
        btn.MouseButton1Down:Connect(function() keys[key] = true end)
        btn.MouseButton1Up:Connect(function() keys[key] = false end)
        btn.MouseLeave:Connect(function() keys[key] = false end)
        btn.TouchLongPress:Connect(function() end)  -- 兼容
    end

    bindHold(btnW,  Enum.KeyCode.W)
    bindHold(btnS,  Enum.KeyCode.S)
    bindHold(btnA,  Enum.KeyCode.A)
    bindHold(btnD,  Enum.KeyCode.D)
    bindHold(btnUp, Enum.KeyCode.Space)
    bindHold(btnDn, Enum.KeyCode.LeftShift)

    -- ========== 右下角动作按钮 ==========
    local actionPanel = Instance.new("Frame")
    actionPanel.Name = "ActionPanel"
    actionPanel.AnchorPoint = Vector2.new(1, 1)
    actionPanel.Position = UDim2.new(1, -20, 1, -20)
    actionPanel.Size = UDim2.new(0, 300, 0, 250)
    actionPanel.BackgroundTransparency = 1
    actionPanel.Parent = mobileGui

    local mainActions = {
        { name = "Open",     label = "张开" },
        { name = "Fist",     label = "握拳" },
        { name = "Point",    label = "食指" },
        { name = "Peace",    label = "剪刀" },
        { name = "ThumbsUp", label = "点赞" },
        { name = "OK",       label = "OK"   },
        { name = "Rock",     label = "摇滚" },
        { name = "Middle",   label = "中指" },
        { name = "Phone",    label = "电话" },
        { name = "Gun",      label = "手枪" },
    }

    local bSize = 54
    local bPad  = 4
    for i, act in ipairs(mainActions) do
        local row = math.floor((i - 1) / 5)
        local col = (i - 1) % 5
        local b = makeButton(actionPanel, act.label,
            UDim2.new(0, bSize, 0, bSize),
            UDim2.new(0, col * (bSize + bPad), 0, row * (bSize + bPad)),
            Color3.fromRGB(45, 90, 55), nil, 13)
        b.MouseButton1Click:Connect(function()
            if Presets[act.name] then applyGesture(Presets[act.name]) end
        end)
    end

    local btnGrabR = makeButton(actionPanel, "右抓", UDim2.new(0,54,0,54),
        UDim2.new(0, 0, 0, 2 * (bSize + bPad)), Color3.fromRGB(80, 55, 130), nil, 13)
    local btnGrabL = makeButton(actionPanel, "左抓", UDim2.new(0,54,0,54),
        UDim2.new(0, (bSize + bPad), 0, 2 * (bSize + bPad)), Color3.fromRGB(80, 55, 130), nil, 13)
    btnGrabR.MouseButton1Click:Connect(function() applyGesture(Presets.GrabR) end)
    btnGrabL.MouseButton1Click:Connect(function() applyGesture(Presets.GrabL) end)

    -- ========== 右上角手指按钮 ==========
    local fingerPanel = Instance.new("Frame")
    fingerPanel.Name = "FingerPanel"
    fingerPanel.AnchorPoint = Vector2.new(1, 0)
    fingerPanel.Position = UDim2.new(1, -20, 0, 80)
    fingerPanel.Size = UDim2.new(0, 200, 0, 260)
    fingerPanel.BackgroundTransparency = 1
    fingerPanel.Parent = mobileGui

    for i, fk in ipairs(FingerKeys) do
        local row = math.floor((i - 1) / 2)
        local col = (i - 1) % 2
        local b = makeButton(fingerPanel, fk.name,
            UDim2.new(0, 92, 0, 34),
            UDim2.new(0, col * (92 + 4), 0, row * (34 + 4)),
            Color3.fromRGB(35, 35, 45), fk.color, 13)

        b.MouseButton1Down:Connect(function()
            if not next(heldFingers) then
                preFingerState = saveState()
            end
            heldFingers[fk] = true
            local g = {}
            g[fk.hand .. fk.finger] = 1
            applyGesture(g)
        end)
        local function release()
            if not heldFingers[fk] then return end
            heldFingers[fk] = nil
            if not next(heldFingers) then
                if preFingerState then
                    applyGesture(preFingerState)
                    preFingerState = nil
                end
            else
                local g = {}
                g[fk.hand .. fk.finger] = 0
                applyGesture(g)
            end
        end
        b.MouseButton1Up:Connect(release)
        b.MouseLeave:Connect(release)
    end

    -- ========== 旋转控制 ==========
    local rotPanel = Instance.new("Frame")
    rotPanel.Name = "RotPanel"
    rotPanel.AnchorPoint = Vector2.new(0.5, 1)
    rotPanel.Position = UDim2.new(0.5, 0, 1, -20)
    rotPanel.Size = UDim2.new(0, 340, 0, 130)
    rotPanel.BackgroundTransparency = 1
    rotPanel.Parent = mobileGui

    local btnRotToggle = makeButton(rotPanel, "旋转: OFF", UDim2.new(0,160,0,42),
        UDim2.new(0, 0, 0, 0), Color3.fromRGB(120, 60, 120), nil, 14)
    local btnRotR = makeButton(rotPanel, "F:右", UDim2.new(0,80,0,42),
        UDim2.new(0, 168, 0, 0), Color3.fromRGB(55, 55, 110), nil, 13)
    local btnRotL = makeButton(rotPanel, "G:左", UDim2.new(0,80,0,42),
        UDim2.new(0, 252, 0, 0), Color3.fromRGB(55, 55, 110), nil, 13)

    local rotPad  -- 前置声明
    btnRotToggle.MouseButton1Click:Connect(function()
        rotating = not rotating
        local n = rotTarget == "both" and "双手" or (rotTarget == "right" and "右手" or "左手")
        btnRotToggle.Text = rotating and ("旋转:" .. n .. " ON") or "旋转: OFF"
        btnRotToggle.BackgroundColor3 = rotating and Color3.fromRGB(200, 80, 200) or Color3.fromRGB(120, 60, 120)
        if rotPad then rotPad.Visible = rotating end
    end)
    btnRotR.MouseButton1Click:Connect(function()
        rotTarget = "right"
        if rotating then btnRotToggle.Text = "旋转:右手 ON" end
    end)
    btnRotL.MouseButton1Click:Connect(function()
        rotTarget = "left"
        if rotating then btnRotToggle.Text = "旋转:左手 ON" end
    end)

    local btnScaleUp   = makeButton(rotPanel, "体型+", UDim2.new(0,80,0,40), UDim2.new(0, 0,   0, 50), Color3.fromRGB(50, 80, 100), nil, 13)
    local btnScaleDown = makeButton(rotPanel, "体型-", UDim2.new(0,80,0,40), UDim2.new(0, 86,  0, 50), Color3.fromRGB(50, 80, 100), nil, 13)
    local btnReachUp   = makeButton(rotPanel, "手距+", UDim2.new(0,80,0,40), UDim2.new(0, 172, 0, 50), Color3.fromRGB(50, 80, 100), nil, 13)
    local btnReachDown = makeButton(rotPanel, "手距-", UDim2.new(0,80,0,40), UDim2.new(0, 258, 0, 50), Color3.fromRGB(50, 80, 100), nil, 13)

    btnScaleUp.MouseButton1Click:Connect(function() setScale(S.scale + 1) end)
    btnScaleDown.MouseButton1Click:Connect(function() setScale(S.scale - 1) end)
    btnReachUp.MouseButton1Click:Connect(function() S.reach = math.clamp(S.reach + 0.1, 0.15, 2.5) end)
    btnReachDown.MouseButton1Click:Connect(function() S.reach = math.clamp(S.reach - 0.1, 0.15, 2.5) end)

    -- ========== 视角拖动区 ==========
    local dragPad = Instance.new("TextButton")
    dragPad.Name = "DragPad"
    dragPad.AnchorPoint = Vector2.new(0.5, 0.5)
    dragPad.Position = UDim2.new(0.5, 0, 0.55, 0)
    dragPad.Size = UDim2.new(0, 260, 0, 160)
    dragPad.BackgroundColor3 = Color3.new(0,0,0)
    dragPad.BackgroundTransparency = 0.85
    dragPad.Text = "拖动视角"
    dragPad.TextColor3 = Color3.new(1,1,1)
    dragPad.TextTransparency = 0.55
    dragPad.Font = Enum.Font.Gotham
    dragPad.TextSize = 14
    dragPad.BorderSizePixel = 0
    dragPad.Parent = mobileGui
    local dcc = Instance.new("UICorner"); dcc.CornerRadius = UDim.new(0, 12); dcc.Parent = dragPad

    local dragging, lastTouch
    dragPad.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            lastTouch = input.Position
        end
    end)
    dragPad.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement then
            local d = input.Position - lastTouch
            lastTouch = input.Position
            yaw   = yaw - d.X * S.sens
            pitch = math.clamp(pitch - d.Y * S.sens, -1.45, 1.45)
        end
    end)
    dragPad.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- ========== 旋转拖动板 ==========
    rotPad = Instance.new("TextButton")
    rotPad.Name = "RotPad"
    rotPad.AnchorPoint = Vector2.new(0.5, 0.5)
    rotPad.Position = UDim2.new(0.5, 0, 0.78, 0)
    rotPad.Size = UDim2.new(0, 260, 0, 90)
    rotPad.BackgroundColor3 = Color3.fromRGB(120, 60, 120)
    rotPad.BackgroundTransparency = 0.75
    rotPad.Text = "旋转手（拖动）"
    rotPad.TextColor3 = Color3.new(1,1,1)
    rotPad.TextTransparency = 0.4
    rotPad.Font = Enum.Font.Gotham
    rotPad.TextSize = 14
    rotPad.BorderSizePixel = 0
    rotPad.Visible = false
    rotPad.Parent = mobileGui
    local rpc = Instance.new("UICorner"); rpc.CornerRadius = UDim.new(0, 12); rpc.Parent = rotPad

    local rotDragging, rotLastTouch
    rotPad.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            rotDragging = true
            rotLastTouch = input.Position
        end
    end)
    rotPad.InputChanged:Connect(function(input)
        if not rotDragging then return end
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement then
            local d = input.Position - rotLastTouch
            rotLastTouch = input.Position
            local target = HandRot[rotTarget]
            target.yaw   = target.yaw   - d.X * 0.008
            target.pitch = math.clamp(target.pitch - d.Y * 0.008, -1.5, 1.5)
        end
    end)
    rotPad.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            rotDragging = false
        end
    end)

    -- ========== 顶部状态栏 ==========
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.AnchorPoint = Vector2.new(0.5, 0)
    topBar.Position = UDim2.new(0.5, 0, 0, 10)
    topBar.Size = UDim2.new(0, 520, 0, 66)
    topBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    topBar.BackgroundTransparency = 0.25
    topBar.BorderSizePixel = 0
    topBar.Parent = mobileGui
    local tc = Instance.new("UICorner"); tc.CornerRadius = UDim.new(0, 10); tc.Parent = topBar

    local statusLbl = Instance.new("TextLabel")
    statusLbl.Size = UDim2.new(1, -12, 1, -8)
    statusLbl.Position = UDim2.new(0, 6, 0, 4)
    statusLbl.BackgroundTransparency = 1
    statusLbl.TextColor3 = Color3.new(1,1,1)
    statusLbl.Font = Enum.Font.Code
    statusLbl.TextSize = 13
    statusLbl.TextXAlignment = Enum.TextXAlignment.Left
    statusLbl.TextYAlignment = Enum.TextYAlignment.Top
    statusLbl.Parent = topBar

    -- ============================================================
    -- 主循环
    -- ============================================================
    RunService:BindToRenderStep("NoVR_Control", Enum.RenderPriority.Camera.Value + 1, function(dt)
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
        if mv.Magnitude > 0 then camPos = camPos + (rot * mv.Unit) * spd * dt end

        cam.CameraType = Enum.CameraType.Scriptable
        cam.CFrame = CFrame.new(camPos) * rot

        if Input then
            Input.directionLateral  = Vector2.zero
            Input.directionVertical = 0
            Input.turnDirection     = 0
        end
    end)

    -- HUD 实时刷新
    RunService.Heartbeat:Connect(function()
        local rotStatus = rotating and ("[旋转:" .. rotTarget .. "]") or ""
        local line1 = "[NoVR Mobile] 动作: " .. Gesture.presetName .. "  " .. rotStatus
        local line2 = string.format("R[%d%d%d%d%d|%d]  L[%d%d%d%d%d|%d]",
            Gesture.rThumb, Gesture.rIndex, Gesture.rMiddle, Gesture.rRing, Gesture.rPinky, Gesture.rFist,
            Gesture.lThumb, Gesture.lIndex, Gesture.lMiddle, Gesture.lRing, Gesture.lPinky, Gesture.lFist)
        local line3 = string.format("体型:%d/10  手距:%.2f  %s",
            S.scale, S.reach, HAS_FULL_FINGERS and "全手指" or "简化")
        statusLbl.Text = line1 .. "\n" .. line2 .. "\n" .. line3
    end)

    print("[NoVR Mobile] 已激活。左下=D-pad 右下=动作/手指 顶部=状态")
end)
]==]

if queue_on_teleport then
    queue_on_teleport(hrs)
elseif syn and syn.queue_on_teleport then
    syn.queue_on_teleport(hrs)
end

TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)