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
            local middle = gTable[hand .. "Middle"] or 0
            local ring   = gTable[hand .. "Ring"]   or 0
            local pinky  = gTable[hand .. "Pinky"]  or 0
            local bendCount = middle + ring + pinky
            if bendCount > 0 then return math.clamp(bendCount / 3, 0.2, 1) end
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
        ["Open"]     = { rThumb=0, rIndex=0, rMiddle=0, rRing=0, rPinky=0, rFist=0, lThumb=0, lIndex=0, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="张开" },
        ["Fist"]     = { rThumb=1, rIndex=1, rMiddle=1, rRing=1, rPinky=1, rFist=1, lThumb=1, lIndex=1, lMiddle=1, lRing=1, lPinky=1, lFist=1, presetName="握拳" },
        ["Point"]    = { rThumb=0, rIndex=1, rMiddle=0, rRing=0, rPinky=0, rFist=0, lThumb=0, lIndex=1, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="食指" },
        ["Peace"]    = { rThumb=0, rIndex=1, rMiddle=1, rRing=0, rPinky=0, rFist=0, lThumb=0, lIndex=1, lMiddle=1, lRing=0, lPinky=0, lFist=0, presetName="剪刀" },
        ["ThumbsUp"] = { rThumb=1, rIndex=0, rMiddle=0, rRing=0, rPinky=0, rFist=1, lThumb=1, lIndex=0, lMiddle=0, lRing=0, lPinky=0, lFist=1, presetName="点赞" },
        ["OK"]       = { rThumb=1, rIndex=1, rMiddle=0, rRing=0, rPinky=0, rFist=0, lThumb=1, lIndex=1, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="OK" },
        ["Rock"]     = { rThumb=0, rIndex=1, rMiddle=0, rRing=0, rPinky=1, rFist=0, lThumb=0, lIndex=1, lMiddle=0, lRing=0, lPinky=1, lFist=0, presetName="摇滚" },
        ["Middle"]   = { rThumb=0, rIndex=0, rMiddle=1, rRing=0, rPinky=0, rFist=0, lThumb=0, lIndex=0, lMiddle=1, lRing=0, lPinky=0, lFist=0, presetName="中指" },
        ["Phone"]    = { rThumb=1, rIndex=0, rMiddle=0, rRing=0, rPinky=1, rFist=0, lThumb=1, lIndex=0, lMiddle=0, lRing=0, lPinky=1, lFist=0, presetName="电话" },
        ["Gun"]      = { rThumb=0, rIndex=1, rMiddle=0, rRing=0, rPinky=0, rFist=0, lThumb=0, lIndex=1, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="手枪" },
        ["PinchR"]   = { rThumb=1, rIndex=1, rMiddle=0, rRing=0, rPinky=0, rFist=0, lThumb=0, lIndex=0, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="右手捏取" },
        ["PinchL"]   = { rThumb=0, rIndex=0, rMiddle=0, rRing=0, rPinky=0, rFist=0, lThumb=1, lIndex=1, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="左手捏取" },
        ["GrabR"]    = { rThumb=1, rIndex=1, rMiddle=1, rRing=1, rPinky=1, rFist=1, lThumb=0, lIndex=0, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="右手抓取" },
        ["GrabL"]    = { rThumb=0, rIndex=0, rMiddle=0, rRing=0, lThumb=1, lIndex=1, lMiddle=1, lRing=1, lPinky=1, lFist=1, presetName="左手抓取" },
        ["Horns"]    = { rThumb=1, rIndex=1, rMiddle=0, rRing=0, rPinky=1, rFist=0, lThumb=1, lIndex=1, lMiddle=0, lRing=0, lPinky=1, lFist=0, presetName="牛角" },
        ["Shaka"]    = { rThumb=1, rIndex=0, rMiddle=0, rRing=0, rPinky=1, rFist=0, lThumb=1, lIndex=0, lMiddle=0, lRing=0, lPinky=1, lFist=0, presetName="Shaka" },
        ["Claw"]     = { rThumb=0, rIndex=1, rMiddle=1, rRing=1, rPinky=1, rFist=0.5, lThumb=0, lIndex=1, lMiddle=1, lRing=1, lPinky=1, lFist=0.5, presetName="爪子" },
    }

    local keys = {}
    local jumpKey = false
    local lookTouch = nil
    local lookTouchLast = nil

    -- 视角
    local yaw, pitch
    do
        local lv = cam.CFrame.LookVector
        yaw   = math.atan2(-lv.X, -lv.Z)
        pitch = math.asin(math.clamp(lv.Y, -1, 1))
    end
    local camPos = cam.CFrame.Position
    cam.HeadLocked = true

    -- ============================================================
    -- 手机触屏 UI
    -- ============================================================
    local function createButton(parent, pos, size, text, bgColor)
        local btn = Instance.new("TextButton", parent)
        btn.Position = pos
        btn.Size = size
        btn.BackgroundColor3 = bgColor or Color3.fromRGB(60, 60, 75)
        btn.BackgroundTransparency = 0.4
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 22
        btn.Font = Enum.Font.GothamBold
        btn.AutoButtonColor = false
        local corner = Instance.new("UICorner", btn)
        corner.CornerRadius = UDim.new(0, 10)
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(100, 200, 255)
        stroke.Thickness = 1.5
        stroke.Transparency = 0.4
        return btn
    end

    local function bindHoldButton(btn, keyCode)
        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then
                keys[keyCode] = true
                btn.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
                btn.BackgroundTransparency = 0.1
            end
        end)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then
                keys[keyCode] = false
                btn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
                btn.BackgroundTransparency = 0.4
            end
        end)
    end

    local function bindTapButton(btn, fn)
        btn.MouseButton1Click:Connect(function()
            fn()
            btn.BackgroundColor3 = Color3.fromRGB(100, 255, 180)
            task.delay(0.15, function()
                btn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
            end)
        end)
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "NoVR_MobileUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 999
    gui.Parent = lp:WaitForChild("PlayerGui")

    -- ========== 顶部状态栏 ==========
    local statusFrame = Instance.new("Frame", gui)
    statusFrame.AnchorPoint = Vector2.new(0.5, 0)
    statusFrame.Position = UDim2.new(0.5, 0, 0, 8)
    statusFrame.Size = UDim2.new(0, 340, 0, 30)
    statusFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    statusFrame.BackgroundTransparency = 0.25
    statusFrame.BorderSizePixel = 0
    Instance.new("UICorner", statusFrame).CornerRadius = UDim.new(0, 8)
    local statusLabel = Instance.new("TextLabel", statusFrame)
    statusLabel.Size = UDim2.new(1, -20, 1, 0)
    statusLabel.Position = UDim2.new(0, 10, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextSize = 14
    statusLabel.Text = "动作: None"
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center

    -- ========== 左下角移动按钮 ==========
    local BTN = 58
    local GAP = 4
    local moveFrame = Instance.new("Frame", gui)
    moveFrame.AnchorPoint = Vector2.new(0, 1)
    moveFrame.Position = UDim2.new(0, 16, 1, -16)
    moveFrame.Size = UDim2.new(0, BTN*3 + GAP*2, 0, BTN*3 + GAP*2)
    moveFrame.BackgroundTransparency = 1

    local upBtn = createButton(moveFrame,
        UDim2.new(0, BTN + GAP, 0, 0),
        UDim2.new(0, BTN, 0, BTN), "↑")
    local downBtn = createButton(moveFrame,
        UDim2.new(0, BTN + GAP, 0, (BTN + GAP) * 2),
        UDim2.new(0, BTN, 0, BTN), "↓")
    local leftBtn = createButton(moveFrame,
        UDim2.new(0, 0, 0, BTN + GAP),
        UDim2.new(0, BTN, 0, BTN), "←")
    local rightBtn = createButton(moveFrame,
        UDim2.new(0, (BTN + GAP) * 2, 0, BTN + GAP),
        UDim2.new(0, BTN, 0, BTN), "→")
    local jumpBtn = createButton(moveFrame,
        UDim2.new(0, BTN + GAP, 0, BTN + GAP),
        UDim2.new(0, BTN, 0, BTN), "跳",
        Color3.fromRGB(80, 150, 80))

    bindHoldButton(upBtn,    Enum.KeyCode.W)
    bindHoldButton(downBtn,  Enum.KeyCode.S)
    bindHoldButton(leftBtn,  Enum.KeyCode.A)
    bindHoldButton(rightBtn, Enum.KeyCode.D)
    bindHoldButton(jumpBtn,  Enum.KeyCode.Space)

    -- 下蹲按钮（上方单独放）
    local crouchBtn = createButton(gui,
        UDim2.new(0, 16, 1, -(BTN*3 + GAP*2) - 60),
        UDim2.new(0, BTN, 0, BTN), "蹲",
        Color3.fromRGB(120, 80, 80))
    bindHoldButton(crouchBtn, Enum.KeyCode.LeftShift)

    -- ========== 屏幕上方动作按钮栏 ==========
    local actionBar = Instance.new("ScrollingFrame", gui)
    actionBar.AnchorPoint = Vector2.new(0.5, 0)
    actionBar.Position = UDim2.new(0.5, 0, 0, 46)
    actionBar.Size = UDim2.new(0, 460, 0, 52)
    actionBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    actionBar.BackgroundTransparency = 0.3
    actionBar.BorderSizePixel = 0
    actionBar.ScrollBarThickness = 3
    actionBar.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 150)
    actionBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    actionBar.ScrollingDirection = Enum.ScrollingDirection.X
    Instance.new("UICorner", actionBar).CornerRadius = UDim.new(0, 8)
    local aLayout = Instance.new("UIListLayout", actionBar)
    aLayout.FillDirection = Enum.FillDirection.Horizontal
    aLayout.Padding = UDim.new(0, 4)
    aLayout.SortOrder = Enum.SortOrder.LayoutOrder
    local aPad = Instance.new("UIPadding", actionBar)
    aPad.PaddingLeft = UDim.new(0, 4)
    aPad.PaddingRight = UDim.new(0, 4)
    aPad.PaddingTop = UDim.new(0, 4)

    local actionDefs = {
        { "张开", "Open" },   { "握拳", "Fist" },   { "食指", "Point" },
        { "剪刀", "Peace" },  { "点赞", "ThumbsUp" }, { "OK", "OK" },
        { "摇滚", "Rock" },   { "中指", "Middle" }, { "电话", "Phone" },
        { "手枪", "Gun" },    { "捏R", "PinchR" },  { "捏L", "PinchL" },
        { "抓R", "GrabR" },   { "抓L", "GrabL" },   { "牛角", "Horns" },
        { "Shaka", "Shaka" }, { "爪子", "Claw" },
    }

    for i, def in ipairs(actionDefs) do
        local ab = Instance.new("TextButton", actionBar)
        ab.Size = UDim2.new(0, 48, 0, 40)
        ab.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        ab.BackgroundTransparency = 0.25
        ab.BorderSizePixel = 0
        ab.Text = def[1]
        ab.TextColor3 = Color3.fromRGB(255, 255, 255)
        ab.Font = Enum.Font.GothamBold
        ab.TextSize = 13
        ab.LayoutOrder = i
        ab.AutoButtonColor = false
        Instance.new("UICorner", ab).CornerRadius = UDim.new(0, 8)
        local s = Instance.new("UIStroke", ab)
        s.Color = Color3.fromRGB(0, 200, 150)
        s.Thickness = 1
        s.Transparency = 0.5
        bindTapButton(ab, function()
            local p = Presets[def[2]]
            if p then
                applyGesture(p)
                statusLabel.Text = "动作: " .. p.presetName
            end
        end)
    end

    aLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        actionBar.CanvasSize = UDim2.new(0, aLayout.AbsoluteContentSize.X + 10, 0, 0)
    end)

    -- ========== 手旋转按钮（右上角）==========
    local rotFrame = Instance.new("Frame", gui)
    rotFrame.AnchorPoint = Vector2.new(1, 0)
    rotFrame.Position = UDim2.new(1, -10, 0, 46)
    rotFrame.Size = UDim2.new(0, 130, 0, 100)
    rotFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    rotFrame.BackgroundTransparency = 0.3
    rotFrame.BorderSizePixel = 0
    Instance.new("UICorner", rotFrame).CornerRadius = UDim.new(0, 8)

    local rotTitle = Instance.new("TextLabel", rotFrame)
    rotTitle.Size = UDim2.new(1, 0, 0, 20)
    rotTitle.BackgroundTransparency = 1
    rotTitle.Text = "手旋转"
    rotTitle.TextColor3 = Color3.fromRGB(0, 255, 170)
    rotTitle.Font = Enum.Font.GothamBold
    rotTitle.TextSize = 12

    local rotYawLeft  = createButton(rotFrame, UDim2.new(0, 4, 0, 22), UDim2.new(0, 38, 0, 34), "◄")
    local rotYawRight = createButton(rotFrame, UDim2.new(0, 88, 0, 22), UDim2.new(0, 38, 0, 34), "►")
    local rotPitchUp  = createButton(rotFrame, UDim2.new(0, 46, 0, 22), UDim2.new(0, 38, 0, 34), "▲")
    local rotPitchDown= createButton(rotFrame, UDim2.new(0, 46, 0, 60), UDim2.new(0, 38, 0, 34), "▼")

    -- 旋转目标切换
    local rotTargetLabel = Instance.new("TextLabel", rotFrame)
    rotTargetLabel.Size = UDim2.new(1, 0, 0, 18)
    rotTargetLabel.Position = UDim2.new(0, 0, 1, -20)
    rotTargetLabel.BackgroundTransparency = 1
    rotTargetLabel.Text = "目标: 双手 (点击切换)"
    rotTargetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    rotTargetLabel.Font = Enum.Font.Gotham
    rotTargetLabel.TextSize = 11

    local rotTargetBtn = Instance.new("TextButton", rotFrame)
    rotTargetBtn.Size = UDim2.new(1, 0, 1, 0)
    rotTargetBtn.BackgroundTransparency = 1
    rotTargetBtn.Text = ""
    rotTargetBtn.ZIndex = 0
    rotTargetBtn.MouseButton1Click:Connect(function()
        if rotTarget == "both" then rotTarget = "right"
        elseif rotTarget == "right" then rotTarget = "left"
        else rotTarget = "both" end
        local names = { both = "双手", right = "右手", left = "左手" }
        rotTargetLabel.Text = "目标: " .. names[rotTarget] .. " (点击切换)"
    end)

    local function bindRotButton(btn, dx, dy)
        local holding = false
        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then
                holding = true
                btn.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
            end
        end)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then
                holding = false
                btn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
            end
        end)
        task.spawn(function()
            while true do
                task.wait(0.03)
                if holding then
                    local t = HandRot[rotTarget]
                    t.yaw   = t.yaw   + (dx or 0) * 0.06
                    t.pitch = math.clamp(t.pitch + (dy or 0) * 0.06, -1.5, 1.5)
                end
            end
        end)
    end
    bindRotButton(rotYawLeft,  1, 0)
    bindRotButton(rotYawRight, -1, 0)
    bindRotButton(rotPitchUp,  0, 1)
    bindRotButton(rotPitchDown,0, -1)

    -- ========== 视角触屏区域（屏幕右侧中间偏下空白）==========
    -- 用全局 TouchMoved 检测，如果触摸点不在任何 UI 按钮上则控制视角
    local function isTouchOnButton(pos)
        local guiObjs = gui:GetGuiObjectsAtPosition(pos.X, pos.Y)
        for _, o in ipairs(guiObjs) do
            if o:IsA("TextButton") then return true end
        end
        return false
    end

    UIS.TouchStarted:Connect(function(input, gpe)
        if gpe then return end
        if isTouchOnButton(input.Position) then return end
        if not lookTouch then
            lookTouch = input
            lookTouchLast = Vector2.new(input.Position.X, input.Position.Y)
        end
    end)

    UIS.TouchMoved:Connect(function(input, gpe)
        if gpe then return end
        if lookTouch and input == lookTouch then
            local cur = Vector2.new(input.Position.X, input.Position.Y)
            local d = cur - lookTouchLast
            lookTouchLast = cur
            yaw   = yaw   - d.X * S.sens * 2.0
            pitch = math.clamp(pitch - d.Y * S.sens * 2.0, -1.45, 1.45)
        end
    end)

    UIS.TouchEnded:Connect(function(input, gpe)
        if lookTouch and input == lookTouch then
            lookTouch = nil
            lookTouchLast = nil
        end
    end)

    -- 缩放按钮（右侧下方）
    local scaleFrame = Instance.new("Frame", gui)
    scaleFrame.AnchorPoint = Vector2.new(1, 1)
    scaleFrame.Position = UDim2.new(1, -16, 1, -16)
    scaleFrame.Size = UDim2.new(0, 70, 0, 130)
    scaleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    scaleFrame.BackgroundTransparency = 0.3
    scaleFrame.BorderSizePixel = 0
    Instance.new("UICorner", scaleFrame).CornerRadius = UDim.new(0, 8)

    local scaleLabel = Instance.new("TextLabel", scaleFrame)
    scaleLabel.Size = UDim2.new(1, 0, 0, 24)
    scaleLabel.BackgroundTransparency = 1
    scaleLabel.Text = "10/10"
    scaleLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
    scaleLabel.Font = Enum.Font.GothamBold
    scaleLabel.TextSize = 14

    local function setScale(n)
        n = math.clamp(math.floor(n + 0.5), 1, 10)
        S.scale = n
        if scaleVal then pcall(function() scaleVal.Value = n / 10 end) end
        if vrm and vrm.DataManager and vrm.DataManager.SettingsManager then
            pcall(function() vrm.DataManager.SettingsManager:SetValue("vrscale", n) end)
        end
        scaleLabel.Text = n .. "/10"
    end
    setScale(10)

    local scaleUp = createButton(scaleFrame, UDim2.new(0, 5, 0, 28), UDim2.new(0, 60, 0, 40), "＋")
    local scaleDown = createButton(scaleFrame, UDim2.new(0, 5, 0, 74), UDim2.new(0, 60, 0, 40), "－")
    bindTapButton(scaleUp, function() setScale(S.scale + 1) end)
    bindTapButton(scaleDown, function() setScale(S.scale - 1) end)

    -- ============================================================
    -- 主循环
    -- ============================================================
    RunService:BindToRenderStep("NoVR_Mobile", Enum.RenderPriority.Camera.Value + 1, function(dt)
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

    -- 状态更新
    RunService.Heartbeat:Connect(function()
        statusLabel.Text = string.format("动作: %s  |  旋转: %s  |  体型: %d/10",
            Gesture.presetName,
            (rotTarget == "both" and "双手") or (rotTarget == "right" and "右手") or "左手",
            S.scale)
    end)

    print("[NoVR Pro Mobile] 已启动。手机触屏操作已就绪。")
end)
]==]

if queue_on_teleport then
    queue_on_teleport(hrs)
elseif syn and syn.queue_on_teleport then
    syn.queue_on_teleport(hrs)
end

TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)