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

    -- 移动端旋转模式: "none" | "both" | "right" | "left"
    local rotMode = "none"

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
            local ok2 = pcall(function() Input[key] = value end)
            return ok2
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
        ["Open"]     = { rThumb=0, rIndex=0, rMiddle=0, rRing=0, rPinky=0, rFist=0,
                         lThumb=0, lIndex=0, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="张开手掌" },
        ["Fist"]     = { rThumb=1, rIndex=1, rMiddle=1, rRing=1, rPinky=1, rFist=1,
                         lThumb=1, lIndex=1, lMiddle=1, lRing=1, lPinky=1, lFist=1, presetName="握拳" },
        ["Point"]    = { rThumb=0, rIndex=1, rMiddle=0, rRing=0, rPinky=0, rFist=0,
                         lThumb=0, lIndex=1, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="食指指" },
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
                         lThumb=0, lIndex=1, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="手枪指" },
        ["PinchR"]   = { rThumb=1, rIndex=1, rMiddle=0, rRing=0, rPinky=0, rFist=0,
                         lThumb=0, lIndex=0, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="右手捏取" },
        ["PinchL"]   = { rThumb=0, rIndex=0, rMiddle=0, rRing=0, rPinky=0, rFist=0,
                         lThumb=1, lIndex=1, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="左手捏取" },
        ["GrabR"]    = { rThumb=1, rIndex=1, rMiddle=1, rRing=1, rPinky=1, rFist=1,
                         lThumb=0, lIndex=0, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="右手抓取" },
        ["GrabL"]    = { rThumb=0, rIndex=0, rMiddle=0, rRing=0, rPinky=0, rFist=0,
                         lThumb=1, lIndex=1, lMiddle=1, lRing=1, lPinky=1, lFist=1, presetName="左手抓取" },
        ["Flap"]     = { rThumb=0, rIndex=0, rMiddle=0, rRing=0, rPinky=0, rFist=0,
                         lThumb=0, lIndex=0, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="挥手" },
        ["Horns"]    = { rThumb=1, rIndex=1, rMiddle=0, rRing=0, rPinky=1, rFist=0,
                         lThumb=1, lIndex=1, lMiddle=0, lRing=0, lPinky=1, lFist=0, presetName="牛角" },
        ["Shaka"]    = { rThumb=1, rIndex=0, rMiddle=0, rRing=0, rPinky=1, rFist=0,
                         lThumb=1, lIndex=0, lMiddle=0, lRing=0, lPinky=1, lFist=0, presetName="Shaka" },
        ["Salute"]   = { rThumb=0, rIndex=1, rMiddle=0, rRing=0, rPinky=0, rFist=0,
                         lThumb=0, lIndex=0, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="敬礼" },
        ["Pray"]     = { rThumb=1, rIndex=1, rMiddle=1, rRing=1, rPinky=1, rFist=1,
                         lThumb=1, lIndex=1, lMiddle=1, lRing=1, lPinky=1, lFist=1, presetName="祈祷" },
        ["Claw"]     = { rThumb=0, rIndex=1, rMiddle=1, rRing=1, rPinky=1, rFist=0.5,
                         lThumb=0, lIndex=1, lMiddle=1, lRing=1, lPinky=1, lFist=0.5, presetName="爪子" },
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
    local keys = {}

    local function setLook(v)
        S.look = v
        UIS.MouseBehavior    = v and Enum.MouseBehavior.LockCenter or Enum.MouseBehavior.Default
        UIS.MouseIconEnabled = not v
    end
    setLook(true)

    -- ============================================================
    -- 移动端 UI
    -- ============================================================
    local playerGui = lp:WaitForChild("PlayerGui")

    local gui = Instance.new("ScreenGui")
    gui.Name = "NoVR_MobileUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = playerGui

    -- 视角触摸区（底层）
    local viewFrame = Instance.new("Frame")
    viewFrame.Name = "ViewArea"
    viewFrame.Size = UDim2.new(1, 0, 1, 0)
    viewFrame.BackgroundTransparency = 1
    viewFrame.Active = true
    viewFrame.ZIndex = 0
    viewFrame.Parent = gui

    local activeTouch = nil
    local lastTouchPos = nil

    viewFrame.InputBegan:Connect(function(io)
        if io.UserInputType == Enum.UserInputType.Touch and not activeTouch then
            activeTouch = io
            lastTouchPos = io.Position
        end
    end)

    viewFrame.InputChanged:Connect(function(io)
        if io == activeTouch and io.UserInputType == Enum.UserInputType.Touch then
            local delta = io.Position - lastTouchPos
            lastTouchPos = io.Position
            if rotMode == "none" then
                if S.look then
                    yaw = yaw - delta.X * S.sens * 2.5
                    pitch = math.clamp(pitch - delta.Y * S.sens * 2.5, -1.45, 1.45)
                end
            else
                local target = HandRot[rotMode]
                target.yaw   = target.yaw   - delta.X * 0.008
                target.pitch = math.clamp(target.pitch - delta.Y * 0.008, -1.5, 1.5)
            end
        end
    end)

    viewFrame.InputEnded:Connect(function(io)
        if io == activeTouch then
            activeTouch = nil
            lastTouchPos = nil
        end
    end)

    -- 通用按钮创建
    local function makeButton(parent, name, text, pos, size, onPress, onRelease, color)
        local btn = Instance.new("TextButton")
        btn.Name = name
        btn.Size = size
        btn.Position = pos
        btn.BackgroundColor3 = color or Color3.fromRGB(30, 30, 45)
        btn.BackgroundTransparency = 0.25
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 20
        btn.Font = Enum.Font.GothamBold
        btn.AutoButtonColor = true
        btn.ZIndex = 10
        btn.Parent = parent

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = btn

        btn.MouseButton1Down:Connect(function()
            if onPress then onPress() end
        end)
        if onRelease then
            btn.MouseButton1Up:Connect(onRelease)
            btn.MouseLeave:Connect(onRelease)
        end

        return btn
    end

    -- ========== 左下角十字方向键 ==========
    local padSize = 58
    local gap = 5
    local padX, padY = 15, 15

    local dpad = Instance.new("Frame")
    dpad.Name = "Dpad"
    dpad.AnchorPoint = Vector2.new(0, 1)
    dpad.Position = UDim2.new(0, padX, 1, -padY)
    dpad.Size = UDim2.new(0, padSize * 3 + gap * 2, 0, padSize * 3 + gap * 2)
    dpad.BackgroundTransparency = 1
    dpad.ZIndex = 10
    dpad.Parent = gui

    local function pKey(key)
        return function() keys[key] = true end, function() keys[key] = false end
    end

    local wP, wR = pKey(Enum.KeyCode.W)
    makeButton(dpad, "W", "▲", UDim2.new(0, padSize + gap, 0, 0), UDim2.new(0, padSize, 0, padSize), wP, wR)

    local sP, sR = pKey(Enum.KeyCode.S)
    makeButton(dpad, "S", "▼", UDim2.new(0, padSize + gap, 0, (padSize + gap) * 2), UDim2.new(0, padSize, 0, padSize), sP, sR)

    local aP, aR = pKey(Enum.KeyCode.A)
    makeButton(dpad, "A", "◀", UDim2.new(0, 0, 0, padSize + gap), UDim2.new(0, padSize, 0, padSize), aP, aR)

    local dP, dR = pKey(Enum.KeyCode.D)
    makeButton(dpad, "D", "▶", UDim2.new(0, (padSize + gap) * 2, 0, padSize + gap), UDim2.new(0, padSize, 0, padSize), dP, dR)

    -- 中心圆显示当前动作
    local centerLabel = Instance.new("TextLabel")
    centerLabel.Size = UDim2.new(0, padSize, 0, padSize)
    centerLabel.Position = UDim2.new(0, padSize + gap, 0, padSize + gap)
    centerLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    centerLabel.BackgroundTransparency = 0.3
    centerLabel.Text = "●"
    centerLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    centerLabel.TextSize = 18
    centerLabel.Font = Enum.Font.GothamBold
    centerLabel.ZIndex = 10
    centerLabel.Parent = dpad

    local centerCorner = Instance.new("UICorner")
    centerCorner.CornerRadius = UDim.new(1, 0)
    centerCorner.Parent = centerLabel

    -- 升降按钮（右侧）
    local vertX = padX + padSize * 3 + gap * 2 + 12
    local vert = Instance.new("Frame")
    vert.Name = "Vertical"
    vert.AnchorPoint = Vector2.new(0, 1)
    vert.Position = UDim2.new(0, vertX, 1, -padY)
    vert.Size = UDim2.new(0, padSize, 0, padSize * 2 + gap)
    vert.BackgroundTransparency = 1
    vert.ZIndex = 10
    vert.Parent = gui

    local spP, spR = pKey(Enum.KeyCode.Space)
    makeButton(vert, "Up", "↑", UDim2.new(0, 0, 0, 0), UDim2.new(0, padSize, 0, padSize), spP, spR, Color3.fromRGB(30, 60, 40))

    local shP, shR = pKey(Enum.KeyCode.LeftShift)
    makeButton(vert, "Down", "↓", UDim2.new(0, 0, 0, padSize + gap), UDim2.new(0, padSize, 0, padSize), shP, shR, Color3.fromRGB(60, 30, 30))

    -- ========== 动作面板 ==========
    local actionPanel = Instance.new("Frame")
    actionPanel.Name = "ActionPanel"
    actionPanel.AnchorPoint = Vector2.new(0.5, 1)
    actionPanel.Position = UDim2.new(0.5, 0, 1, -80)
    actionPanel.Size = UDim2.new(0, 360, 0, 300)
    actionPanel.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    actionPanel.BackgroundTransparency = 0.1
    actionPanel.Visible = false
    actionPanel.ZIndex = 20
    actionPanel.Parent = gui

    local apCorner = Instance.new("UICorner")
    apCorner.CornerRadius = UDim.new(0, 10)
    apCorner.Parent = actionPanel

    local apStroke = Instance.new("UIStroke")
    apStroke.Color = Color3.fromRGB(80, 80, 120)
    apStroke.Thickness = 1.5
    apStroke.Parent = actionPanel

    -- Tab 行
    local tabRow = Instance.new("Frame")
    tabRow.Size = UDim2.new(1, -12, 0, 34)
    tabRow.Position = UDim2.new(0, 6, 0, 6)
    tabRow.BackgroundTransparency = 1
    tabRow.ZIndex = 21
    tabRow.Parent = actionPanel

    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -12, 1, -48)
    contentArea.Position = UDim2.new(0, 6, 0, 44)
    contentArea.BackgroundTransparency = 1
    contentArea.ZIndex = 21
    contentArea.Parent = actionPanel

    local pages = {}

    local function makeTabBtn(text, idx)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1/3, -4, 1, 0)
        btn.Position = UDim2.new((idx-1)/3, (idx-1)*4 + 2, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
        btn.BackgroundTransparency = 0.2
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(220, 220, 255)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamBold
        btn.ZIndex = 22
        btn.Parent = tabRow

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 6)
        c.Parent = btn

        return btn
    end

    -- 按钮网格创建
    local function createGrid(pageFrame, items)
        local cols = 4
        local btnW = 78
        local btnH = 44
        local gapX = 6
        local gapY = 6

        for i, item in ipairs(items) do
            local row = math.floor((i - 1) / cols)
            local col = (i - 1) % cols

            local x = col * (btnW + gapX)
            local y = row * (btnH + gapY)

            local onPress, onRelease

            if item.hold then
                onPress = function()
                    if not next(heldFingers) then
                        preFingerState = saveState()
                    end
                    heldFingers[item.key] = true
                    local g = {}
                    g[item.hand .. item.finger] = 1
                    applyGesture(g)
                end
                onRelease = function()
                    if heldFingers[item.key] then
                        heldFingers[item.key] = nil
                        if not next(heldFingers) then
                            loadState(preFingerState)
                            preFingerState = nil
                        else
                            local g = {}
                            g[item.hand .. item.finger] = 0
                            applyGesture(g)
                        end
                    end
                end
            else
                onPress = function()
                    applyGesture(Presets[item.preset])
                    print("[NoVR] 动作: " .. (Presets[item.preset] and Presets[item.preset].presetName or item.preset))
                end
            end

            makeButton(pageFrame, item.name, item.text,
                UDim2.new(0, x, 0, y),
                UDim2.new(0, btnW, 0, btnH),
                onPress, onRelease,
                item.color or Color3.fromRGB(35, 35, 55)
            )
        end
    end

    -- 页面1：预设动作
    local page1 = Instance.new("Frame")
    page1.Size = UDim2.new(1, 0, 1, 0)
    page1.BackgroundTransparency = 1
    page1.ZIndex = 21
    page1.Parent = contentArea

    createGrid(page1, {
        { name="P1",  text="张开",  preset="Open" },
        { name="P2",  text="握拳",  preset="Fist" },
        { name="P3",  text="食指",  preset="Point" },
        { name="P4",  text="剪刀",  preset="Peace" },
        { name="P5",  text="点赞",  preset="ThumbsUp" },
        { name="P6",  text="OK",    preset="OK" },
        { name="P7",  text="摇滚",  preset="Rock" },
        { name="P8",  text="中指",  preset="Middle" },
        { name="P9",  text="电话",  preset="Phone" },
        { name="P10", text="手枪",  preset="Gun" },
    })

    -- 页面2：组合动作
    local page2 = Instance.new("Frame")
    page2.Size = UDim2.new(1, 0, 1, 0)
    page2.BackgroundTransparency = 1
    page2.ZIndex = 21
    page2.Visible = false
    page2.Parent = contentArea

    createGrid(page2, {
        { name="Q1",  text="右捏",   preset="PinchR" },
        { name="Q2",  text="右抓",   preset="GrabR" },
        { name="Q3",  text="左捏",   preset="PinchL" },
        { name="Q4",  text="左抓",   preset="GrabL" },
        { name="Q5",  text="挥手",   preset="Flap" },
        { name="Q6",  text="牛角",   preset="Horns" },
        { name="Q7",  text="Shaka",  preset="Shaka" },
        { name="Q8",  text="敬礼",   preset="Salute" },
        { name="Q9",  text="祈祷",   preset="Pray" },
        { name="Q10", text="爪子",   preset="Claw" },
    })

    -- 页面3：单指动作
    local page3 = Instance.new("Frame")
    page3.Size = UDim2.new(1, 0, 1, 0)
    page3.BackgroundTransparency = 1
    page3.ZIndex = 21
    page3.Visible = false
    page3.Parent = contentArea

    createGrid(page3, {
        { name="F1",  text="右拇",   hand="r", finger="Thumb",  key="rThumb",  hold=true },
        { name="F2",  text="右食",   hand="r", finger="Index",  key="rIndex",  hold=true },
        { name="F3",  text="右中",   hand="r", finger="Middle", key="rMiddle", hold=true },
        { name="F4",  text="右无名", hand="r", finger="Ring",   key="rRing",   hold=true },
        { name="F5",  text="右小",   hand="r", finger="Pinky",  key="rPinky",  hold=true },
        { name="F6",  text="右拳",   hand="r", finger="Fist",   key="rFist",   hold=true },
        { name="F7",  text="左拇",   hand="l", finger="Thumb",  key="lThumb",  hold=true },
        { name="F8",  text="左食",   hand="l", finger="Index",  key="lIndex",  hold=true },
        { name="F9",  text="左中",   hand="l", finger="Middle", key="lMiddle", hold=true },
        { name="F10", text="左无名", hand="l", finger="Ring",   key="lRing",   hold=true },
        { name="F11", text="左小",   hand="l", finger="Pinky",  key="lPinky",  hold=true },
        { name="F12", text="左拳",   hand="l", finger="Fist",   key="lFist",   hold=true },
    })

    pages = { page1, page2, page3 }

    local tab1 = makeTabBtn("预设", 1)
    local tab2 = makeTabBtn("组合", 2)
    local tab3 = makeTabBtn("单指", 3)

    local function switchTab(idx)
        for i, p in ipairs(pages) do
            p.Visible = (i == idx)
        end
        for i, b in ipairs({tab1, tab2, tab3}) do
            if i == idx then
                b.BackgroundColor3 = Color3.fromRGB(70, 90, 180)
                b.BackgroundTransparency = 0
            else
                b.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
                b.BackgroundTransparency = 0.2
            end
        end
    end

    tab1.MouseButton1Click:Connect(function() switchTab(1) end)
    tab2.MouseButton1Click:Connect(function() switchTab(2) end)
    tab3.MouseButton1Click:Connect(function() switchTab(3) end)
    switchTab(1)

    -- 打开/关闭面板按钮（右下）
    local togglePanelBtn = makeButton(gui, "TogglePanel", "动作",
        UDim2.new(1, -95, 1, -85),
        UDim2.new(0, 85, 0, 55),
        function()
            actionPanel.Visible = not actionPanel.Visible
        end,
        nil,
        Color3.fromRGB(50, 50, 100)
    )
    togglePanelBtn.ZIndex = 15
    togglePanelBtn.TextSize = 22

    -- ========== 手旋转模式按钮（右侧） ==========
    local rotBtnRow = Instance.new("Frame")
    rotBtnRow.AnchorPoint = Vector2.new(1, 1)
    rotBtnRow.Position = UDim2.new(1, -95, 1, -150)
    rotBtnRow.Size = UDim2.new(0, 85, 0, 120)
    rotBtnRow.BackgroundTransparency = 1
    rotBtnRow.ZIndex = 15
    rotBtnRow.Parent = gui

    local function makeRotBtn(text, mode, yOffset)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 34)
        btn.Position = UDim2.new(0, 0, 0, yOffset)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
        btn.BackgroundTransparency = 0.2
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(220, 220, 255)
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamBold
        btn.ZIndex = 15
        btn.Parent = rotBtnRow

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 6)
        c.Parent = btn

        btn.MouseButton1Click:Connect(function()
            if rotMode == mode then
                rotMode = "none"
                btn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
                btn.BackgroundTransparency = 0.2
            else
                rotMode = mode
                for _, b in ipairs(rotBtnRow:GetChildren()) do
                    if b:IsA("TextButton") then
                        b.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
                        b.BackgroundTransparency = 0.2
                    end
                end
                btn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
                btn.BackgroundTransparency = 0
            end
        end)

        return btn
    end

    makeRotBtn("转双手", "both",  0)
    makeRotBtn("转右手", "right", 40)
    makeRotBtn("转左手", "left",  80)

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

        -- 更新中心圆显示当前动作
        if centerLabel then
            centerLabel.Text = Gesture.presetName ~= "None" and Gesture.presetName:sub(1,2) or "●"
        end
    end)

    -- ============================================================
    -- 简易提示 HUD（顶部一行）
    -- ============================================================
    pcall(function()
        local hud = Instance.new("ScreenGui")
        hud.Name = "NoVR_Tip"
        hud.ResetOnSpawn = false
        hud.IgnoreGuiInset = true
        hud.Parent = playerGui

        local tip = Instance.new("TextLabel")
        tip.AnchorPoint = Vector2.new(0.5, 0)
        tip.Position = UDim2.new(0.5, 0, 0, 5)
        tip.Size = UDim2.new(0, 500, 0, 24)
        tip.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        tip.BackgroundTransparency = 0.4
        tip.TextColor3 = Color3.fromRGB(0, 255, 170)
        tip.Font = Enum.Font.Code
        tip.TextSize = 12
        tip.Text = "[VR Hands No-VR Pro] 手机端 | 拖动屏幕=视角 | 左下方向键=移动"
        tip.Parent = hud

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 6)
        c.Parent = tip
    end)

    print("[NoVR Pro] 手机端控制已激活。")
end)
]==]

if queue_on_teleport then
    queue_on_teleport(hrs)
elseif syn and syn.queue_on_teleport then
    syn.queue_on_teleport(hrs)
end

TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)