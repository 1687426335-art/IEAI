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

    -- ============================================================
    -- 可调设置（全部可通过设置面板实时修改）
    -- ============================================================
    local S = {
        reach   = 0.55,     -- 手往前伸距离
        spread  = 0.34,     -- 左右手分开距离
        height  = -0.25,    -- 手的高度
        sens    = 0.0025,   -- 滑屏灵敏度(视角)
        moveK   = 0.16,     -- 移动速度倍率
        rotSens = 0.06,     -- 手旋转按钮灵敏度
        look    = true,
        scale   = 10,
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

    -- VRUtils 拦截
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

    -- 找 Input
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

    -- ============================================================
    -- 全部预设动作（20 个，和原键位 1-0 / Ctrl+1-0 一致）
    -- ============================================================
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
        ["GrabL"]    = { rThumb=0, rIndex=0, rMiddle=0, rRing=0, rPinky=0, lThumb=1, lIndex=1, lMiddle=1, lRing=1, lPinky=1, lFist=1, presetName="左手抓取" },
        ["Flap"]     = { rThumb=0, rIndex=0, rMiddle=0, rRing=0, rPinky=0, rFist=0, lThumb=0, lIndex=0, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="挥手" },
        ["Horns"]    = { rThumb=1, rIndex=1, rMiddle=0, rRing=0, rPinky=1, rFist=0, lThumb=1, lIndex=1, lMiddle=0, lRing=0, lPinky=1, lFist=0, presetName="牛角" },
        ["Shaka"]    = { rThumb=1, rIndex=0, rMiddle=0, rRing=0, rPinky=1, rFist=0, lThumb=1, lIndex=0, lMiddle=0, lRing=0, lPinky=1, lFist=0, presetName="Shaka" },
        ["Salute"]   = { rThumb=0, rIndex=1, rMiddle=0, rRing=0, rPinky=0, rFist=0, lThumb=0, lIndex=0, lMiddle=0, lRing=0, lPinky=0, lFist=0, presetName="敬礼" },
        ["Pray"]     = { rThumb=1, rIndex=1, rMiddle=1, rRing=1, rPinky=1, rFist=1, lThumb=1, lIndex=1, lMiddle=1, lRing=1, lPinky=1, lFist=1, presetName="祈祷" },
        ["Claw"]     = { rThumb=0, rIndex=1, rMiddle=1, rRing=1, rPinky=1, rFist=0.5, lThumb=0, lIndex=1, lMiddle=1, lRing=1, lPinky=1, lFist=0.5, presetName="爪子" },
    }

    -- 单指键映射
    local FingerKeys = {
        [Enum.KeyCode.T] = { hand="r", finger="Thumb",  name="右拇指" },
        [Enum.KeyCode.Y] = { hand="r", finger="Index",  name="右食指" },
        [Enum.KeyCode.U] = { hand="r", finger="Middle", name="右中指" },
        [Enum.KeyCode.I] = { hand="r", finger="Ring",   name="右无名指" },
        [Enum.KeyCode.O] = { hand="r", finger="Pinky",  name="右小指" },
        [Enum.KeyCode.P] = { hand="r", finger="Fist",   name="右拳" },
        [Enum.KeyCode.Z] = { hand="l", finger="Thumb",  name="左拇指" },
        [Enum.KeyCode.X] = { hand="l", finger="Index",  name="左食指" },
        [Enum.KeyCode.C] = { hand="l", finger="Middle", name="左中指" },
        [Enum.KeyCode.V] = { hand="l", finger="Ring",   name="左无名指" },
        [Enum.KeyCode.B] = { hand="l", finger="Pinky",  name="左小指" },
        [Enum.KeyCode.N] = { hand="l", finger="Fist",   name="左拳" },
    }

    local keys = {}
    local yaw, pitch
    do
        local lv = cam.CFrame.LookVector
        yaw   = math.atan2(-lv.X, -lv.Z)
        pitch = math.asin(math.clamp(lv.Y, -1, 1))
    end
    local camPos = cam.CFrame.Position
    cam.HeadLocked = true

    -- ============================================================
    -- UI 辅助
    -- ============================================================
    local function createBtn(parent, pos, size, text, bg, txtSize)
        local b = Instance.new("TextButton", parent)
        b.Position = pos; b.Size = size
        b.BackgroundColor3 = bg or Color3.fromRGB(60, 60, 75)
        b.BackgroundTransparency = 0.35
        b.BorderSizePixel = 0
        b.Text = text
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.TextSize = txtSize or 20
        b.Font = Enum.Font.GothamBold
        b.AutoButtonColor = false
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        local s = Instance.new("UIStroke", b)
        s.Color = Color3.fromRGB(100, 200, 255)
        s.Thickness = 1.2
        s.Transparency = 0.5
        return b
    end

    local function bindHold(btn, keyCode)
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
                btn.BackgroundTransparency = 0.35
            end
        end)
    end

    local function bindTap(btn, fn, flashColor)
        flashColor = flashColor or Color3.fromRGB(100, 255, 180)
        btn.MouseButton1Click:Connect(function()
            fn()
            btn.BackgroundColor3 = flashColor
            task.delay(0.15, function()
                btn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
            end)
        end)
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "NoVR_Mobile_Pro"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 999
    gui.Parent = lp:WaitForChild("PlayerGui")

    -- ========== 顶部状态栏 ==========
    local statusFrame = Instance.new("Frame", gui)
    statusFrame.AnchorPoint = Vector2.new(0.5, 0)
    statusFrame.Position = UDim2.new(0.5, 0, 0, 4)
    statusFrame.Size = UDim2.new(0, 400, 0, 26)
    statusFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    statusFrame.BackgroundTransparency = 0.2
    statusFrame.BorderSizePixel = 0
    Instance.new("UICorner", statusFrame).CornerRadius = UDim.new(0, 8)
    local statusLabel = Instance.new("TextLabel", statusFrame)
    statusLabel.Size = UDim2.new(1, -12, 1, 0)
    statusLabel.Position = UDim2.new(0, 6, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextSize = 13
    statusLabel.Text = "动作: None"
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center

    -- ========== 顶部预设动作栏（横向滚动）==========
    local actionBar = Instance.new("ScrollingFrame", gui)
    actionBar.AnchorPoint = Vector2.new(0.5, 0)
    actionBar.Position = UDim2.new(0.5, 0, 0, 34)
    actionBar.Size = UDim2.new(0, 480, 0, 50)
    actionBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    actionBar.BackgroundTransparency = 0.25
    actionBar.BorderSizePixel = 0
    actionBar.ScrollBarThickness = 3
    actionBar.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 150)
    actionBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    actionBar.ScrollingDirection = Enum.ScrollingDirection.X
    Instance.new("UICorner", actionBar).CornerRadius = UDim.new(0, 8)
    local aLayout = Instance.new("UIListLayout", actionBar)
    aLayout.FillDirection = Enum.FillDirection.Horizontal
    aLayout.Padding = UDim.new(0, 3)
    aLayout.SortOrder = Enum.SortOrder.LayoutOrder
    local aPad = Instance.new("UIPadding", actionBar)
    aPad.PaddingLeft = UDim.new(0, 4); aPad.PaddingRight = UDim.new(0, 4); aPad.PaddingTop = UDim.new(0, 5)

    local actionDefs = {
        { "张开", "Open" },   { "握拳", "Fist" },   { "食指", "Point" },
        { "剪刀", "Peace" },  { "点赞", "ThumbsUp" }, { "OK", "OK" },
        { "摇滚", "Rock" },   { "中指", "Middle" }, { "电话", "Phone" },
        { "手枪", "Gun" },    { "捏R", "PinchR" },  { "捏L", "PinchL" },
        { "抓R", "GrabR" },   { "抓L", "GrabL" },   { "挥手", "Flap" },
        { "牛角", "Horns" },  { "Shaka", "Shaka" }, { "敬礼", "Salute" },
        { "祈祷", "Pray" },   { "爪子", "Claw" },
    }
    for i, def in ipairs(actionDefs) do
        local ab = Instance.new("TextButton", actionBar)
        ab.Size = UDim2.new(0, 46, 0, 38)
        ab.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        ab.BackgroundTransparency = 0.2
        ab.BorderSizePixel = 0
        ab.Text = def[1]
        ab.TextColor3 = Color3.fromRGB(255, 255, 255)
        ab.Font = Enum.Font.GothamBold
        ab.TextSize = 12
        ab.LayoutOrder = i
        ab.AutoButtonColor = false
        Instance.new("UICorner", ab).CornerRadius = UDim.new(0, 8)
        local s = Instance.new("UIStroke", ab)
        s.Color = Color3.fromRGB(0, 200, 150); s.Thickness = 1; s.Transparency = 0.5
        bindTap(ab, function()
            local p = Presets[def[2]]
            if p then applyGesture(p); statusLabel.Text = "动作: " .. p.presetName end
        end)
    end
    aLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        actionBar.CanvasSize = UDim2.new(0, aLayout.AbsoluteContentSize.X + 10, 0, 0)
    end)

    -- ========== 左下角移动十字 ==========
    local BTN, GAP = 54, 4
    local moveFrame = Instance.new("Frame", gui)
    moveFrame.AnchorPoint = Vector2.new(0, 1)
    moveFrame.Position = UDim2.new(0, 14, 1, -14)
    moveFrame.Size = UDim2.new(0, BTN*3 + GAP*2, 0, BTN*3 + GAP*2)
    moveFrame.BackgroundTransparency = 1

    local upBtn    = createBtn(moveFrame, UDim2.new(0, BTN+GAP, 0, 0),               UDim2.new(0, BTN, 0, BTN), "↑")
    local downBtn  = createBtn(moveFrame, UDim2.new(0, BTN+GAP, 0, (BTN+GAP)*2),     UDim2.new(0, BTN, 0, BTN), "↓")
    local leftBtn  = createBtn(moveFrame, UDim2.new(0, 0, 0, BTN+GAP),               UDim2.new(0, BTN, 0, BTN), "←")
    local rightBtn = createBtn(moveFrame, UDim2.new(0, (BTN+GAP)*2, 0, BTN+GAP),     UDim2.new(0, BTN, 0, BTN), "→")
    local jumpBtn  = createBtn(moveFrame, UDim2.new(0, BTN+GAP, 0, BTN+GAP),         UDim2.new(0, BTN, 0, BTN), "跳", Color3.fromRGB(80, 150, 80))

    bindHold(upBtn,    Enum.KeyCode.W)
    bindHold(downBtn,  Enum.KeyCode.S)
    bindHold(leftBtn,  Enum.KeyCode.A)
    bindHold(rightBtn, Enum.KeyCode.D)
    bindHold(jumpBtn,  Enum.KeyCode.Space)

    -- 蹲下
    local crouchBtn = createBtn(gui, UDim2.new(0, 14, 1, -(BTN*3 + GAP*2) - 60), UDim2.new(0, BTN, 0, BTN), "蹲", Color3.fromRGB(120, 80, 80))
    bindHold(crouchBtn, Enum.KeyCode.LeftShift)

    -- ========== 单指控制面板（左侧竖排一列）==========
    local fingerPanel = Instance.new("Frame", gui)
    fingerPanel.AnchorPoint = Vector2.new(0, 0.5)
    fingerPanel.Position = UDim2.new(0, 14, 0.5, 0)
    fingerPanel.Size = UDim2.new(0, 56, 0, 380)
    fingerPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    fingerPanel.BackgroundTransparency = 0.3
    fingerPanel.BorderSizePixel = 0
    Instance.new("UICorner", fingerPanel).CornerRadius = UDim.new(0, 8)

    local fpTitle = Instance.new("TextLabel", fingerPanel)
    fpTitle.Size = UDim2.new(1, 0, 0, 18); fpTitle.Position = UDim2.new(0, 0, 0, 2)
    fpTitle.BackgroundTransparency = 1; fpTitle.Text = "单指"
    fpTitle.TextColor3 = Color3.fromRGB(0, 255, 170)
    fpTitle.Font = Enum.Font.GothamBold; fpTitle.TextSize = 11

    local fingerList = {
        {"右拇","rThumb"}, {"右食","rIndex"}, {"右中","rMiddle"},
        {"右无","rRing"},  {"右小","rPinky"}, {"右拳","rFist"},
        {"左拇","lThumb"}, {"左食","lIndex"}, {"左中","lMiddle"},
        {"左无","lRing"},  {"左小","lPinky"}, {"左拳","lFist"},
    }
    local fpScroll = Instance.new("ScrollingFrame", fingerPanel)
    fpScroll.Position = UDim2.new(0, 2, 0, 22)
    fpScroll.Size = UDim2.new(1, -4, 1, -26)
    fpScroll.BackgroundTransparency = 1
    fpScroll.BorderSizePixel = 0
    fpScroll.ScrollBarThickness = 2
    fpScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 150)
    fpScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    local fpLayout = Instance.new("UIListLayout", fpScroll)
    fpLayout.Padding = UDim.new(0, 3)
    fpLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local fingerBtns = {}
    for i, fd in ipairs(fingerList) do
        local fb = Instance.new("TextButton", fpScroll)
        fb.Size = UDim2.new(1, -4, 0, 24)
        fb.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        fb.BackgroundTransparency = 0.2
        fb.BorderSizePixel = 0
        fb.Text = fd[1]
        fb.TextColor3 = Color3.fromRGB(255, 255, 255)
        fb.Font = Enum.Font.GothamBold
        fb.TextSize = 11
        fb.LayoutOrder = i
        fb.AutoButtonColor = false
        Instance.new("UICorner", fb).CornerRadius = UDim.new(0, 6)
        local s = Instance.new("UIStroke", fb)
        s.Color = Color3.fromRGB(150, 100, 200); s.Thickness = 1; s.Transparency = 0.5

        local fk = fd[2]
        local isPressed = false
        fb.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then
                isPressed = true
                fb.BackgroundColor3 = Color3.fromRGB(150, 100, 200)
                fb.BackgroundTransparency = 0.1
                local g = {}
                g[fk] = 1
                applyGesture(g)
            end
        end)
        fb.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then
                isPressed = false
                fb.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
                fb.BackgroundTransparency = 0.2
                local g = {}
                g[fk] = 0
                applyGesture(g)
            end
        end)
        table.insert(fingerBtns, fb)
    end
    fpLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        fpScroll.CanvasSize = UDim2.new(0, 0, 0, fpLayout.AbsoluteContentSize.Y + 4)
    end)

    -- ========== 右上角手旋转 ==========
    local rotFrame = Instance.new("Frame", gui)
    rotFrame.AnchorPoint = Vector2.new(1, 0)
    rotFrame.Position = UDim2.new(1, -10, 0, 34)
    rotFrame.Size = UDim2.new(0, 140, 0, 120)
    rotFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    rotFrame.BackgroundTransparency = 0.25
    rotFrame.BorderSizePixel = 0
    Instance.new("UICorner", rotFrame).CornerRadius = UDim.new(0, 8)

    local rotTitle = Instance.new("TextLabel", rotFrame)
    rotTitle.Size = UDim2.new(1, 0, 0, 18)
    rotTitle.BackgroundTransparency = 1
    rotTitle.Text = "手旋转"
    rotTitle.TextColor3 = Color3.fromRGB(0, 255, 170)
    rotTitle.Font = Enum.Font.GothamBold; rotTitle.TextSize = 11

    local rotYawL   = createBtn(rotFrame, UDim2.new(0, 4,  0, 22), UDim2.new(0, 38, 0, 34), "◄", nil, 16)
    local rotYawR   = createBtn(rotFrame, UDim2.new(0, 96, 0, 22), UDim2.new(0, 38, 0, 34), "►", nil, 16)
    local rotPitchU = createBtn(rotFrame, UDim2.new(0, 50, 0, 22), UDim2.new(0, 38, 0, 34), "▲", nil, 16)
    local rotPitchD = createBtn(rotFrame, UDim2.new(0, 50, 0, 62), UDim2.new(0, 38, 0, 34), "▼", nil, 16)

    local rotTargetLbl = Instance.new("TextLabel", rotFrame)
    rotTargetLbl.Size = UDim2.new(1, 0, 0, 18)
    rotTargetLbl.Position = UDim2.new(0, 0, 1, -20)
    rotTargetLbl.BackgroundTransparency = 1
    rotTargetLbl.Text = "目标: 双手 (点击切换)"
    rotTargetLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    rotTargetLbl.Font = Enum.Font.Gotham; rotTargetLbl.TextSize = 10

    local rotTargetBtn = Instance.new("TextButton", rotFrame)
    rotTargetBtn.Size = UDim2.new(1, 0, 1, 0)
    rotTargetBtn.BackgroundTransparency = 1
    rotTargetBtn.Text = ""; rotTargetBtn.ZIndex = 0
    rotTargetBtn.MouseButton1Click:Connect(function()
        if rotTarget == "both" then rotTarget = "right"
        elseif rotTarget == "right" then rotTarget = "left"
        else rotTarget = "both" end
        local names = { both = "双手", right = "右手", left = "左手" }
        rotTargetLbl.Text = "目标: " .. names[rotTarget] .. " (点击切换)"
    end)

    local function bindRot(btn, dx, dy)
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
                    t.yaw   = t.yaw   + (dx or 0) * S.rotSens
                    t.pitch = math.clamp(t.pitch + (dy or 0) * S.rotSens, -1.5, 1.5)
                end
            end
        end)
    end
    bindRot(rotYawL, 1, 0); bindRot(rotYawR, -1, 0)
    bindRot(rotPitchU, 0, 1); bindRot(rotPitchD, 0, -1)

    -- ========== 右下角体型缩放 ==========
    local scaleFrame = Instance.new("Frame", gui)
    scaleFrame.AnchorPoint = Vector2.new(1, 1)
    scaleFrame.Position = UDim2.new(1, -14, 1, -14)
    scaleFrame.Size = UDim2.new(0, 70, 0, 120)
    scaleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    scaleFrame.BackgroundTransparency = 0.25
    scaleFrame.BorderSizePixel = 0
    Instance.new("UICorner", scaleFrame).CornerRadius = UDim.new(0, 8)

    local scaleLbl = Instance.new("TextLabel", scaleFrame)
    scaleLbl.Size = UDim2.new(1, 0, 0, 22)
    scaleLbl.BackgroundTransparency = 1
    scaleLbl.Text = "10/10"
    scaleLbl.TextColor3 = Color3.fromRGB(0, 255, 170)
    scaleLbl.Font = Enum.Font.GothamBold; scaleLbl.TextSize = 13

    local function setScale(n)
        n = math.clamp(math.floor(n + 0.5), 1, 10)
        S.scale = n
        if scaleVal then pcall(function() scaleVal.Value = n / 10 end) end
        if vrm and vrm.DataManager and vrm.DataManager.SettingsManager then
            pcall(function() vrm.DataManager.SettingsManager:SetValue("vrscale", n) end)
        end
        scaleLbl.Text = n .. "/10"
    end
    setScale(10)

    local scaleUpBtn   = createBtn(scaleFrame, UDim2.new(0, 5, 0, 26), UDim2.new(0, 60, 0, 38), "＋")
    local scaleDownBtn = createBtn(scaleFrame, UDim2.new(0, 5, 0, 70), UDim2.new(0, 60, 0, 38), "－")
    bindTap(scaleUpBtn,   function() setScale(S.scale + 1) end)
    bindTap(scaleDownBtn, function() setScale(S.scale - 1) end)

    -- ========== 设置面板（可开关，包含滑屏灵敏度等）==========
    local settingsBtn = createBtn(gui,
        UDim2.new(0.5, -30, 1, -60), UDim2.new(0, 60, 0, 44), "⚙", Color3.fromRGB(80, 60, 120), 22)

    local settingsPanel = Instance.new("Frame", gui)
    settingsPanel.AnchorPoint = Vector2.new(0.5, 0.5)
    settingsPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
    settingsPanel.Size = UDim2.new(0, 340, 0, 400)
    settingsPanel.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    settingsPanel.BackgroundTransparency = 0.1
    settingsPanel.BorderSizePixel = 0
    settingsPanel.Visible = false
    Instance.new("UICorner", settingsPanel).CornerRadius = UDim.new(0, 12)
    local pStroke = Instance.new("UIStroke", settingsPanel)
    pStroke.Color = Color3.fromRGB(0, 200, 150); pStroke.Thickness = 2

    local sTitle = Instance.new("TextLabel", settingsPanel)
    sTitle.Size = UDim2.new(1, 0, 0, 34)
    sTitle.BackgroundTransparency = 1
    sTitle.Text = "设置面板"
    sTitle.TextColor3 = Color3.fromRGB(0, 255, 170)
    sTitle.Font = Enum.Font.GothamBold; sTitle.TextSize = 18

    local closeBtn = Instance.new("TextButton", settingsPanel)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -34, 0, 2)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    closeBtn.BackgroundTransparency = 0.2
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 14
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
    closeBtn.MouseButton1Click:Connect(function()
        settingsPanel.Visible = false
    end)

    local sScroll = Instance.new("ScrollingFrame", settingsPanel)
    sScroll.Position = UDim2.new(0, 8, 0, 40)
    sScroll.Size = UDim2.new(1, -16, 1, -48)
    sScroll.BackgroundTransparency = 1
    sScroll.BorderSizePixel = 0
    sScroll.ScrollBarThickness = 4
    sScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 150)
    sScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    local sLayout = Instance.new("UIListLayout", sScroll)
    sLayout.Padding = UDim.new(0, 8)
    sLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- 滑动条
    local function makeSlider(label, minV, maxV, defaultV, step, onChange)
        local row = Instance.new("Frame", sScroll)
        row.Size = UDim2.new(1, 0, 0, 62)
        row.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        row.BackgroundTransparency = 0.3
        row.BorderSizePixel = 0
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

        local nameLbl = Instance.new("TextLabel", row)
        nameLbl.Size = UDim2.new(0.7, 0, 0, 22)
        nameLbl.Position = UDim2.new(0, 8, 0, 2)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = label
        nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLbl.Font = Enum.Font.GothamBold; nameLbl.TextSize = 13
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left

        local valLbl = Instance.new("TextLabel", row)
        valLbl.Size = UDim2.new(0.3, -8, 0, 22)
        valLbl.Position = UDim2.new(0.7, 0, 0, 2)
        valLbl.BackgroundTransparency = 1
        valLbl.Text = tostring(defaultV)
        valLbl.TextColor3 = Color3.fromRGB(0, 255, 170)
        valLbl.Font = Enum.Font.Code; valLbl.TextSize = 13
        valLbl.TextXAlignment = Enum.TextXAlignment.Right

        -- 减号
        local minusBtn = Instance.new("TextButton", row)
        minusBtn.Size = UDim2.new(0, 32, 0, 30)
        minusBtn.Position = UDim2.new(0, 8, 0, 28)
        minusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        minusBtn.BorderSizePixel = 0
        minusBtn.Text = "－"
        minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        minusBtn.Font = Enum.Font.GothamBold; minusBtn.TextSize = 16
        minusBtn.AutoButtonColor = false
        Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 6)

        -- 加号
        local plusBtn = Instance.new("TextButton", row)
        plusBtn.Size = UDim2.new(0, 32, 0, 30)
        plusBtn.Position = UDim2.new(1, -40, 0, 28)
        plusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        plusBtn.BorderSizePixel = 0
        plusBtn.Text = "＋"
        plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        plusBtn.Font = Enum.Font.GothamBold; plusBtn.TextSize = 16
        plusBtn.AutoButtonColor = false
        Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 6)

        -- 滑条背景
        local barBg = Instance.new("Frame", row)
        barBg.Size = UDim2.new(1, -100, 0, 10)
        barBg.Position = UDim2.new(0, 48, 0, 38)
        barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        barBg.BorderSizePixel = 0
        Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

        -- 滑条填充
        local barFill = Instance.new("Frame", barBg)
        barFill.Size = UDim2.new((defaultV - minV) / (maxV - minV), 0, 1, 0)
        barFill.BackgroundColor3 = Color3.fromRGB(0, 200, 150)
        barFill.BorderSizePixel = 0
        Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

        -- 拖动条
        local handle = Instance.new("Frame", barBg)
        handle.Size = UDim2.new(0, 18, 0, 18)
        handle.Position = UDim2.new((defaultV - minV) / (maxV - minV), -9, 0.5, -9)
        handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        handle.BorderSizePixel = 0
        Instance.new("UICorner", handle).CornerRadius = UDim.new(1, 0)

        local current = defaultV
        local function update(v)
            current = math.clamp(v, minV, maxV)
            local ratio = (current - minV) / (maxV - minV)
            barFill.Size = UDim2.new(ratio, 0, 1, 0)
            handle.Position = UDim2.new(ratio, -9, 0.5, -9)
            local display
            if step and step < 1 then
                display = string.format("%.4f", current)
            elseif step and step < 10 then
                display = string.format("%.2f", current)
            else
                display = string.format("%d", math.floor(current + 0.5))
            end
            valLbl.Text = display
            onChange(current)
        end

        minusBtn.MouseButton1Click:Connect(function() update(current - step) end)
        plusBtn.MouseButton1Click:Connect(function() update(current + step) end)

        -- 点击滑条跳跃
        barBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then
                local relX = input.Position.X - barBg.AbsolutePosition.X
                local r = math.clamp(relX / barBg.AbsoluteSize.X, 0, 1)
                update(minV + r * (maxV - minV))
            end
        end)

        -- 滑动
        local dragging = false
        handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseMovement) then
                local relX = input.Position.X - barBg.AbsolutePosition.X
                local r = math.clamp(relX / barBg.AbsoluteSize.X, 0, 1)
                update(minV + r * (maxV - minV))
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        return { update = update, row = row }
    end

    -- 滑屏灵敏度（视角速度）
    makeSlider("滑屏灵敏度 (视角)", 0.0005, 0.02, S.sens, 0.0005, function(v) S.sens = v end)
    -- 移动速度倍率
    makeSlider("移动速度倍率", 0.02, 1.0, S.moveK, 0.02, function(v) S.moveK = v end)
    -- 手旋转灵敏度
    makeSlider("手旋转灵敏度", 0.01, 0.3, S.rotSens, 0.01, function(v) S.rotSens = v end)
    -- 手前伸距离
    makeSlider("手前伸距离 (reach)", 0.1, 2.5, S.reach, 0.05, function(v) S.reach = v end)
    -- 左右手分开距离
    makeSlider("左右手分开 (spread)", 0.05, 1.2, S.spread, 0.02, function(v) S.spread = v end)
    -- 手的高度
    makeSlider("手的高度 (height)", -1.5, 1.0, S.height, 0.05, function(v) S.height = v end)

    sLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sScroll.CanvasSize = UDim2.new(0, 0, 0, sLayout.AbsoluteContentSize.Y + 8)
    end)

    settingsBtn.MouseButton1Click:Connect(function()
        settingsPanel.Visible = not settingsPanel.Visible
    end)

    -- ========== 触屏滑动控制视角 ==========
    local function isTouchOnButton(pos)
        local objs = gui:GetGuiObjectsAtPosition(pos.X, pos.Y)
        for _, o in ipairs(objs) do
            if o:IsA("GuiButton") then return true end
        end
        return false
    end

    local lookTouch, lookTouchLast
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
            lookTouch = nil; lookTouchLast = nil
        end
    end)

    -- ========== 主循环 ==========
    RunService:BindToRenderStep("NoVR_Mobile_Pro", Enum.RenderPriority.Camera.Value + 1, function(dt)
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

    -- 状态栏刷新
    RunService.Heartbeat:Connect(function()
        local names = { both = "双手", right = "右手", left = "左手" }
        statusLabel.Text = string.format("动作: %s  |  旋转: %s  |  体型: %d/10",
            Gesture.presetName, names[rotTarget], S.scale)
    end)

    print("[NoVR Mobile Pro] 已启动。所有动作 + 可调设置已加载。")
end)
]==]

if queue_on_teleport then
    queue_on_teleport(hrs)
elseif syn and syn.queue_on_teleport then
    syn.queue_on_teleport(hrs)
end

TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)