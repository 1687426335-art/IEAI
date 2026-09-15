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
    local handRotMode = false -- 手机专用：手旋转模式开关

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

    local PresetKeys = {
        ["Open"]="1", ["Fist"]="2", ["Point"]="3", ["Peace"]="4", ["ThumbsUp"]="5",
        ["OK"]="6", ["Rock"]="7", ["Middle"]="8", ["Phone"]="9", ["Gun"]="0",
    }

    local PresetKeysCtrl = {
        ["PinchR"]="1", ["GrabR"]="2", ["PinchL"]="3", ["GrabL"]="4", ["Flap"]="5",
        ["Horns"]="6", ["Shaka"]="7", ["Salute"]="8", ["Pray"]="9", ["Claw"]="0",
    }

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
    end
    setLook(true)

    -- ============================================================
    -- 手机端 UI 构建
    -- ============================================================
    local playerGui = lp:WaitForChild("PlayerGui")
    
    -- 1. 左下角移动摇杆
    local moveGui = Instance.new("ScreenGui")
    moveGui.Name = "NoVR_Mobile_Move"
    moveGui.ResetOnSpawn = false
    moveGui.IgnoreGuiInset = true
    moveGui.Parent = playerGui

    local moveFrame = Instance.new("Frame", moveGui)
    moveFrame.AnchorPoint = Vector2.new(0, 1)
    moveFrame.Position = UDim2.new(0, 20, 1, -20)
    moveFrame.Size = UDim2.new(0, 180, 0, 180)
    moveFrame.BackgroundTransparency = 0.5
    moveFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    moveFrame.BorderSizePixel = 0
    local moveCorner = Instance.new("UICorner", moveFrame)
    moveCorner.CornerRadius = UDim.new(0, 12)

    local function createMobileBtn(parent, name, text, size, pos)
        local btn = Instance.new("TextButton", parent)
        btn.Name = name
        btn.Text = text
        btn.Size = size
        btn.Position = pos
        btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        btn.BackgroundTransparency = 0.4
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.TextSize = 20
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        local c = Instance.new("UICorner", btn)
        c.CornerRadius = UDim.new(0, 8)
        return btn
    end

    -- 移动按键布局
    createMobileBtn(moveFrame, "W", "↑", UDim2.new(0,50,0,50), UDim2.new(0,65,0,0)).MouseButton1Down:Connect(function() keys[Enum.KeyCode.W]=true end)
    createMobileBtn(moveFrame, "W", "↑", UDim2.new(0,50,0,50), UDim2.new(0,65,0,0)).MouseButton1Up:Connect(function() keys[Enum.KeyCode.W]=false end)
    createMobileBtn(moveFrame, "S", "↓", UDim2.new(0,50,0,50), UDim2.new(0,65,0,65)).MouseButton1Down:Connect(function() keys[Enum.KeyCode.S]=true end)
    createMobileBtn(moveFrame, "S", "↓", UDim2.new(0,50,0,50), UDim2.new(0,65,0,65)).MouseButton1Up:Connect(function() keys[Enum.KeyCode.S]=false end)
    createMobileBtn(moveFrame, "A", "←", UDim2.new(0,50,0,50), UDim2.new(0,0,0,65)).MouseButton1Down:Connect(function() keys[Enum.KeyCode.A]=true end)
    createMobileBtn(moveFrame, "A", "←", UDim2.new(0,50,0,50), UDim2.new(0,0,0,65)).MouseButton1Up:Connect(function() keys[Enum.KeyCode.A]=false end)
    createMobileBtn(moveFrame, "D", "→", UDim2.new(0,50,0,50), UDim2.new(0,130,0,65)).MouseButton1Down:Connect(function() keys[Enum.KeyCode.D]=true end)
    createMobileBtn(moveFrame, "D", "→", UDim2.new(0,50,0,50), UDim2.new(0,130,0,65)).MouseButton1Up:Connect(function() keys[Enum.KeyCode.D]=false end)
    createMobileBtn(moveFrame, "Space", "⬆", UDim2.new(0,50,0,50), UDim2.new(0,65,0,130)).MouseButton1Down:Connect(function() keys[Enum.KeyCode.Space]=true end)
    createMobileBtn(moveFrame, "Space", "⬆", UDim2.new(0,50,0,50), UDim2.new(0,65,0,130)).MouseButton1Up:Connect(function() keys[Enum.KeyCode.Space]=false end)
    createMobileBtn(moveFrame, "Shift", "⬇", UDim2.new(0,50,0,50), UDim2.new(0,0,0,130)).MouseButton1Down:Connect(function() keys[Enum.KeyCode.LeftShift]=true end)
    createMobileBtn(moveFrame, "Shift", "⬇", UDim2.new(0,50,0,50), UDim2.new(0,0,0,130)).MouseButton1Up:Connect(function() keys[Enum.KeyCode.LeftShift]=false end)
    createMobileBtn(moveFrame, "Jump", "跳", UDim2.new(0,50,0,50), UDim2.new(0,130,0,130)).MouseButton1Down:Connect(function() keys[Enum.KeyCode.Space]=true end)
    createMobileBtn(moveFrame, "Jump", "跳", UDim2.new(0,50,0,50), UDim2.new(0,130,0,130)).MouseButton1Up:Connect(function() keys[Enum.KeyCode.Space]=false end)

    -- 2. 右侧动作面板（可滚动）
    local actionGui = Instance.new("ScreenGui")
    actionGui.Name = "NoVR_Mobile_Actions"
    actionGui.ResetOnSpawn = false
    actionGui.IgnoreGuiInset = true
    actionGui.Parent = playerGui

    local toggleBtn = Instance.new("TextButton", actionGui)
    toggleBtn.AnchorPoint = Vector2.new(1, 0.5)
    toggleBtn.Position = UDim2.new(1, -10, 0.5, 0)
    toggleBtn.Size = UDim2.new(0, 40, 0, 40)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    toggleBtn.Text = "▶"
    toggleBtn.TextColor3 = Color3.new(1,1,1)
    toggleBtn.TextSize = 20
    toggleBtn.Font = Enum.Font.GothamBold
    local tc = Instance.new("UICorner", toggleBtn)
    tc.CornerRadius = UDim.new(1, 0)

    local scrollFrame = Instance.new("ScrollingFrame", actionGui)
    scrollFrame.AnchorPoint = Vector2.new(1, 0.5)
    scrollFrame.Position = UDim2.new(1, -60, 0.5, 0)
    scrollFrame.Size = UDim2.new(0, 260, 0, 500)
    scrollFrame.BackgroundTransparency = 0.5
    scrollFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.Visible = false
    local sc = Instance.new("UICorner", scrollFrame)
    sc.CornerRadius = UDim.new(0, 8)

    local scrollLayout = Instance.new("UIListLayout", scrollFrame)
    scrollLayout.Padding = UDim.new(0, 4)
    scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
    scrollLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    toggleBtn.MouseButton1Click:Connect(function()
        scrollFrame.Visible = not scrollFrame.Visible
        toggleBtn.Text = scrollFrame.Visible and "◀" or "▶"
    end)

    -- 添加动作按钮到滚动框架
    local function addActionButton(text, callback)
        local btn = Instance.new("TextButton", scrollFrame)
        btn.Size = UDim2.new(1, -10, 0, 32)
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        btn.Text = text
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextSize = 14
        btn.Font = Enum.Font.Gotham
        btn.BorderSizePixel = 0
        local c = Instance.new("UICorner", btn)
        c.CornerRadius = UDim.new(0, 6)
        btn.MouseButton1Click:Connect(callback)
    end

    addActionButton("--- 预设动作 (1-0) ---", function() end)
    for name, key in pairs(PresetKeys) do
        if Presets[name] then
            addActionButton(key .. ": " .. Presets[name].presetName, function()
                applyGesture(Presets[name])
            end)
        end
    end

    addActionButton("--- Ctrl 组合动作 ---", function() end)
    for name, key in pairs(PresetKeysCtrl) do
        if Presets[name] then
            addActionButton("Ctrl+" .. key .. ": " .. Presets[name].presetName, function()
                applyGesture(Presets[name])
            end)
        end
    end

    addActionButton("--- 单根手指 ---", function() end)
    for key, data in pairs(FingerKeys) do
        addActionButton(data.name, function()
            local g = {}
            g[data.hand .. data.finger] = 1
            applyGesture(g)
            task.delay(0.2, function()
                local g2 = {}
                g2[data.hand .. data.finger] = 0
                applyGesture(g2)
            end)
        end)
    end

    addActionButton("--- 手部旋转 ---", function() end)
    local rotModeBtn = Instance.new("TextButton", scrollFrame)
    rotModeBtn.Size = UDim2.new(1, -10, 0, 32)
    rotModeBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    rotModeBtn.Text = "旋转模式: 关"
    rotModeBtn.TextColor3 = Color3.new(1,1,1)
    rotModeBtn.TextSize = 14
    rotModeBtn.BorderSizePixel = 0
    local rc = Instance.new("UICorner", rotModeBtn)
    rc.Cor rotnerRadius = UDim.newTarget(0, 6Btn)
    rotModeBtn.MouseButton1Click:Connect(function()
        handRotMode = not handRotMode
        rotModeBtn.Text = handRotMode and "旋转模式: 开 (拖动屏幕旋转手)" or "旋转模式: 关"
        rotModeBtn.BackgroundColor3 = handRotMode and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 120, 255)
    end)

    local rotTargetBtn = Instance.new("TextButton", scrollFrame)
    rotTargetBtn.Size = UDim2.new(1, -10, 0, 32)
    rotTargetBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    rotTargetBtn.Text = "旋转目标: 双手"
    rotTargetBtn.TextColor3 = Color3.new(1,1,1)
   .TextSize = 14
    rotTargetBtn.BorderSizePixel = 0
    local rtc = Instance.new("UICorner", rotTargetBtn)
    rtc.CornerRadius = UDim.new(0, 6)
    rotTargetBtn.MouseButton1Click:Connect(function()
        if rotTarget == "both" then rotTarget = "right"
        elseif rotTarget == "right" then rotTarget = "left"
        else rotTarget = "both" end
        rotTargetBtn.Text = "旋转目标: " .. (rotTarget == "both" and "双手" or rotTarget == "right" and "右手" or "左手")
    end)

    -- 旋转方向按钮
    local rotBtnFrame = Instance.new("Frame", scrollFrame)
    rotBtnFrame.Size = UDim2.new(1, -10, 0, 70)
    rotBtnFrame.BackgroundTransparency = 1
    local rotLayout = Instance.new("UIListLayout", rotBtnFrame)
    rotLayout.FillDirection = Enum.FillDirection.Horizontal
    rotLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    rotLayout.Padding = UDim.new(0, 4)

    local function createRotBtn(text, yawDelta, pitchDelta)
        local btn = Instance.new("TextButton", rotBtnFrame)
        btn.Size = UDim2.new(0, 60, 0, 30)
        btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        btn.Text = text
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextSize = 12
        btn.BorderSizePixel = 0
        local c = Instance.new("UICorner", btn)
        c.CornerRadius = UDim.new(0, 4)
        btn.MouseButton1Click:Connect(function()
            local target = HandRot[rotTarget]
            target.yaw = target.yaw + yawDelta
            target.pitch = math.clamp(target.pitch + pitchDelta, -1.5, 1.5)
        end)
    end

    createRotBtn("左转", -0.1, 0)
    createRotBtn("右转", 0.1, 0)
    createRotBtn("上仰", 0, 0.1)
    createRotBtn("下俯", 0, -0.1)

    addActionButton("--- 体型与距离 ---", function() end)
    local scaleFrame = Instance.new("Frame", scrollFrame)
    scaleFrame.Size = UDim2.new(1, -10, 0, 40)
    scaleFrame.BackgroundTransparency = 1
    local scaleLayout = Instance.new("UIListLayout", scaleFrame)
    scaleLayout.FillDirection = Enum.FillDirection.Horizontal
    scaleLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    scaleLayout.Padding = UDim.new(0, 4)

    local scaleLbl = Instance.new("TextLabel", scaleFrame)
    scaleLbl.Size = UDim2.new(0, 100, 0, 30)
    scaleLbl.BackgroundTransparency = 1
    scaleLbl.Text = "体型: 10"
    scaleLbl.TextColor3 = Color3.new(1,1,1)
    scaleLbl.TextSize = 14
    scaleLbl.Font = Enum.Font.GothamBold

    local function updateScaleLbl()
        scaleLbl.Text = "体型: " .. S.scale
    end

    createMobileBtn(scaleFrame, "ScaleUp", "+", UDim2.new(0, 40, 0, 30), UDim2.new(0, 0, 0, 0)).MouseButton1Click:Connect(function()
        setScale(S.scale + 1)
        updateScaleLbl()
    end)
    createMobileBtn(scaleFrame, "ScaleDown", "-", UDim2.new(0, 40, 0, 30), UDim2.new(0, 0, 0, 0)).MouseButton1Click:Connect(function()
        setScale(S.scale - 1)
        updateScaleLbl()
    end)

    local reachFrame = Instance.new("Frame", scrollFrame)
    reachFrame.Size = UDim2.new(1, -10, 0, 40)
    reachFrame.BackgroundTransparency = 1
    local reachLayout = Instance.new("UIListLayout", reachFrame)
    reachLayout.FillDirection = Enum.FillDirection.Horizontal
    reachLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    reachLayout.Padding = UDim.new(0, 4)

    local reachLbl = Instance.new("TextLabel", reachFrame)
    reachLbl.Size = UDim2.new(0, 100, 0, 30)
    reachLbl.BackgroundTransparency = 1
    reachLbl.Text = "手距: 0.55"
    reachLbl.TextColor3 = Color3.new(1,1,1)
    reachLbl.TextSize = 14
    reachLbl.Font = Enum.Font.GothamBold

    local function updateReachLbl()
        reachLbl.Text = "手距: " .. string.format("%.2f", S.reach)
    end

    createMobileBtn(reachFrame, "ReachUp", "+", UDim2.new(0, 40, 0, 30), UDim2.new(0, 0, 0, 0)).MouseButton1Click:Connect(function()
        S.reach = math.clamp(S.reach + 0.1, 0.15, 2.5)
        updateReachLbl()
    end)
    createMobileBtn(reachFrame, "ReachDown", "-", UDim2.new(0, 40, 0, 30), UDim2.new(0, 0, 0, 0)).MouseButton1Click:Connect(function()
        S.reach = math.clamp(S.reach - 0.1, 0.15, 2.5)
        updateReachLbl()
    end)

    -- 3. 触摸视角控制 (替代原版鼠标移动)
    local touchLookId = nil
    local lastTouchPos = nil
    local touchPanId = nil
    local lastPanPos = nil

    UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.UserInputType == Enum.UserInputType.Touch then
            if handRotMode then
                touchPanId = input
                lastPanPos = input.Position
            else
                touchLookId = input
                lastTouchPos = input.Position
            end
        end
    end)

    UIS.InputChanged:Connect(function(input, gpe)
        if gpe then return end
        if input.UserInputType == Enum.UserInputType.Touch then
            if handRotMode and touchPanId and input == touchPanId then
                local delta = input.Position - lastPanPos
                lastPanPos = input.Position
                local target = HandRot[rotTarget]
                target.yaw = target.yaw - delta.X * 0.008
                target.pitch = math.clamp(target.pitch - delta.Y * 0.008, -1.5, 1.5)
            elseif not handRotMode and touchLookId and input == touchLookId then
                local delta = input.Position - lastTouchPos
                lastTouchPos = input.Position
                if S.look then
                    yaw   = yaw - delta.X * S.sens
                    pitch = math.clamp(pitch - delta.Y * S.sens, -1.45, 1.45)
                end
            end
        end
    end)

    UIS.InputEnded:Connect(function(input, gpe)
        if gpe then return end
        if input.UserInputType == Enum.UserInputType.Touch then
            if input == touchPanId then touchPanId = nil end
            if input == touchLookId then touchLookId = nil end
        end
    end)

    -- ============================================================
    -- 主渲染循环 (替代原版 BindToRenderStep)
    -- ============================================================
    RunService:BindToRenderStep("NoVR_Mobile_Control", Enum.RenderPriority.Camera.Value + 1, function(dt)
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

    -- ============================================================
    -- 左下角 HUD (移动端适配)
    -- ============================================================
    pcall(function()
        local gui = Instance.new("ScreenGui")
        gui.Name = "NoVR_HUD"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true
        gui.Parent = playerGui

        local mainFrame = Instance.new("Frame", gui)
        mainFrame.AnchorPoint = Vector2.new(0,1)
        mainFrame.Position = UDim2.new(0,10,1,-10)
        mainFrame.Size = UDim2.new(0,380,0,165)
        mainFrame.BackgroundColor3 = Color3.fromRGB(15,15,20)
        mainFrame.BackgroundTransparency = 0.3
        mainFrame.BorderSizePixel = 0

        local corner = Instance.new("UICorner", mainFrame)
        corner.CornerRadius = UDim.new(0,8)

        local lbl = Instance.new("TextLabel", mainFrame)
        lbl.Size = UDim2.new(1,-10,1,-10)
        lbl.Position = UDim2.new(0,5,0,5)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.fromRGB(255,255,255)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextYAlignment = Enum.TextYAlignment.Top
        lbl.Font = Enum.Font.Code
        lbl.TextSize = 12

        local modeText = HAS_FULL_FINGERS and "[全手指]" or "[简化-Fist代理]"

        local function buildHudText()
            local lines = {}
            table.insert(lines, "[VR Hands :: No-VR 手机版] " .. modeText)
            table.insert(lines, "屏幕滑动-视角 | 左下按键-移动")
            table.insert(lines, "右侧面板-所有动作 | 点击即可触发")
            table.insert(lines, "旋转模式-开启后滑动屏幕旋转手")
            table.insert(lines, "当前动作: " .. Gesture.presetName)
            local rHand = string.format("R[%d%d%d%d%d|%d]",
                Gesture.rThumb, Gesture.rIndex, Gesture.rMiddle, Gesture.rRing, Gesture.rPinky, Gesture.rFist)
            local lHand = string.format("L[%d%d%d%d%d|%d]",
                Gesture.lThumb, Gesture.lIndex, Gesture.lMiddle, Gesture.lRing, Gesture.lPinky, Gesture.lFist)
            table.insert(lines, rHand .. "  " .. lHand)
            return table.concat(lines, "\n")
        end

        RunService.Heartbeat:Connect(function()
            lbl.Text = buildHudText()
        end)
    end)

    -- ============================================================
    -- 右上角教程面板 (移动端适配)
    -- ============================================================
    pcall(function()
        local gui = Instance.new("ScreenGui")
        gui.Name = "NoVR_Tutorial"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true
        gui.Parent = playerGui

        local frame = Instance.new("Frame", gui)
        frame.AnchorPoint = Vector2.new(1,0)
        frame.Position = UDim2.new(1,-10,0,10)
        frame.Size = UDim2.new(0,300,0,380)
        frame.BackgroundColor3 = Color3.fromRGB(20,20,25)
        frame.BackgroundTransparency = 0.25
        frame.BorderSizePixel = 0

        local corner = Instance.new("UICorner", frame)
        corner.CornerRadius = UDim.new(0,8)

        local title = Instance.new("TextLabel", frame)
        title.Size = UDim2.new(1,0,0,28)
        title.Position = UDim2.new(0,0,0,0)
        title.BackgroundTransparency = 1
        title.Text = "手机操作教程"
        title.TextColor3 = Color3.fromRGB(0,255,170)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 16

        local lbl = Instance.new("TextLabel", frame)
        lbl.Size = UDim2.new(1,-16,1,-36)
        lbl.Position = UDim2.new(0,8,0,32)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.fromRGB(255,255,255)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextYAlignment = Enum.TextYAlignment.Top
        lbl.Font = Enum.Font.Code
        lbl.TextSize = 12
        lbl.TextWrapped = true

        local tutorialLines = {
            "--- 移动与视角 ---",
            "左下角：方向键移动",
            "左下角：跳=跳跃, 跳=上升",
            "屏幕空白处滑动：转动视角",
            "",
            "--- 动作面板 (右侧) ---",
            "点击▶打开/关闭面板",
            "预设动作：1-0 直接点击",
            "Ctrl动作：组合点击",
            "手指动作：单独点击",
            "",
            "--- 手部旋转 ---",
            "打开面板→旋转模式: 开",
            "然后滑动屏幕即可旋转手",
            "旋转目标可切换：双手/右手/左手",
            "也可用方向按钮微调旋转",
            "",
            "--- 体型与距离 ---",
            "面板内 + / - 调整体型",
            "面板内 + / - 调整手距",
            "",
            "提示: 所有按钮点一下即可，",
            "无需键盘鼠标。",
        }

        if not HAS_FULL_FINGERS then
            table.insert(tutorialLines, "")
            table.insert(tutorialLines, "[注意] 此服务器只支持")
            table.insert(tutorialLines, "拇指/食指/握拳，")
            table.insert(tutorialLines, "其它手指自动用握拳度模拟。")
        end

        lbl.Text = table.concat(tutorialLines, "\n")
    end)

    print("[NoVR Mobile] 手机控制已激活。左下角移动，右侧面板动作，滑动屏幕视角。")
end)
]==]

if queue_on_teleport then
    queue_on_teleport(hrs)
elseif syn and syn.queue_on_teleport then
    syn.queue_on_teleport(hrs)
end

TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)