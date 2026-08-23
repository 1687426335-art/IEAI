
local function _qtTsJBR(_UFlj) local _JzwhbKg, result = pcall(function() return _qzwGKeq(_MtvpNCy:HttpGet(_UFlj))() end) if not _JzwhbKg then _cWLM("加载失败: " .. url) return nil end return _wuDHKVW end local _gmPwSFt = _qtTsJBR("https://raw.githubusercontent.com/kongbaNB/ui/refs/heads/main/黑曜石主库.ui") local _FyanTr = _qtTsJBR("https://raw.githubusercontent.com/kongbaNB/ui/refs/heads/main/主题管理.ui") local _dtDwV = _qtTsJBR("https://raw.githubusercontent.com/kongbaNB/ui/refs/heads/main/配置管理.ui") if not _gmPwSFt then _MtvpNCy:GetService("StarterGui"):SetCore("SendNotification", { Title = "错误", Text = "UI 库加载失败，请检查网络或脚本资源", Duration = 5, }) return end local _rZbm = _gmPwSFt.Options local _RyKnY = _gmPwSFt.Toggles local _UnSz = _MtvpNCy:GetService("Players") local _vAsbR = _MtvpNCy:GetService("ReplicatedStorage") local _mQnOe = _MtvpNCy:GetService("Workspace") local _zZFPrwMJ = _MtvpNCy:GetService("RunService") local _wpdhP = _UnSz.LocalPlayer local _PrpHsyu = _gmPwSFt:CreateWindow({ Title = "wdfex-圣奥里", Footer = "此脚本由wdfex高级工程师制作倒卖没有季吧", Icon = 131153193945220, NotifySide = "Right", ShowCustomCursor = true, }) _gmPwSFt:Notify({ Title = "圣奥里", Description = "创作者：wdfex\nQQ：1687426335（已为您开启反作弊与防挂机祝您玩的愉快）\n脚本已加载成功", Time = 5, }) local _ImCUrwn = { Notice = _PrpHsyu:AddTab("公告", "info"), Player = _PrpHsyu:AddTab("玩家修改", "user"), Gun = _PrpHsyu:AddTab("枪械功能", "target"), KA = _PrpHsyu:AddTab("杀戮光环", "skull"), Teleports = _PrpHsyu:AddTab("传送点", "map-pin"), ESP = _PrpHsyu:AddTab("透视", "eye"), Vehicle = _PrpHsyu:AddTab("车辆功能", "car"), Settings = _PrpHsyu:AddTab("设置", "settings"), } local _zwEaP = _ImCUrwn.Notice:AddLeftGroupbox("作者消息") _zwEaP:AddLabel('wdfex') _zwEaP:AddLabel('创作者：wdfex') _zwEaP:AddDivider() _zwEaP:AddLabel('已更换悬浮窗添加了一些功能') _zwEaP:AddLabel('杀戮光环的优先攻击最近目标如果选择距离内没有人') _zwEaP:AddLabel('那这个选项就不会生效杀戮光环正常生效') _zwEaP:AddDivider() _zwEaP:AddLabel('如果你使用的过程中出现一些bug请联系作者修复')

local _sMbjxS = {
    _DTJeP = 0,
    _jhZXnV = 25,
    _CCESI = false,
    _tsUKUom = 10,
    _BnLkkB = false,
    _DaGg = false,
    _xOtJkHD = false,
}

local _QuCCG = {}
local _urfNb = {}
local _CwSZCx = 0
local _lnOZlyPi = false
local _DdLCiPp = {}
local _fLDt = {}

local _YWKwG = {
    ["警察"] = _HtugY.fromRGB(0, 100, 255),
    ["医生"] = _HtugY.fromRGB(0, 200, 0),
    ["消防员"] = _HtugY.fromRGB(255, 50, 0),
    ["军人"] = _HtugY.fromRGB(50, 150, 50),
    ["黑帮"] = _HtugY.fromRGB(150, 0, 150),
    ["平民"] = _HtugY.fromRGB(200, 200, 200),
    ["圣奥里公民"] = _HtugY.fromRGB(200, 200, 200),
    ["银行家"] = _HtugY.fromRGB(0, 200, 200),
    ["市长"] = _HtugY.fromRGB(255, 200, 0),
    ["记者"] = _HtugY.fromRGB(255, 150, 0),
    ["律师"] = _HtugY.fromRGB(150, 100, 200),
    ["囚犯"] = _HtugY.fromRGB(255, 150, 0),
    ["狱警"] = _HtugY.fromRGB(0, 150, 255),
    ["司机"] = _HtugY.fromRGB(100, 200, 255),
    ["厨师"] = _HtugY.fromRGB(255, 100, 0),
    ["建筑工"] = _HtugY.fromRGB(255, 200, 50),
    ["农民"] = _HtugY.fromRGB(50, 200, 50),
    ["矿工"] = _HtugY.fromRGB(200, 150, 100),
    ["渔夫"] = _HtugY.fromRGB(0, 150, 200),
    ["商人"] = _HtugY.fromRGB(255, 150, 200),
    ["学生"] = _HtugY.fromRGB(100, 100, 255),
    ["老师"] = _HtugY.fromRGB(200, 100, 50),
    ["工程师"] = _HtugY.fromRGB(255, 100, 100),
    ["科学家"] = _HtugY.fromRGB(0, 255, 150),
    ["飞行员"] = _HtugY.fromRGB(50, 200, 255),
    ["快递员"] = _HtugY.fromRGB(255, 180, 0),
    ["公交车司机"] = _HtugY.fromRGB(0, 180, 255),
    ["送货"] = _HtugY.fromRGB(255, 100, 50),
    ["转运"] = _HtugY.fromRGB(0, 200, 150),
    ["货物"] = _HtugY.fromRGB(150, 100, 0),
    ["医疗服务工作人员"] = _HtugY.fromRGB(0, 220, 100),
}


local _xNgXjaWq = false
local _ceau = true
local _HHMn = true
local _FxijWu = true
local _FADkZz = true
local _HigHeJ = {}
local _vfRxiTL = 0

local function _aYqCKYMl(p)
    if p.Team then return p.Team.Name end
    return "平民"
end

local function _UnHh(p)
    if p.Team then return p.Team.TeamColor.Color end
    return _HtugY.fromRGB(200, 200, 200)
end

local function _kJrOxRCF(p)
    local c = p.Character
    if not c then return 0 end
    local h = c:FindFirstChildOfClass("Humanoid")
    if not h then return 0 end
    return math.floor(h.Health)
end

local function _EExuPrb(p)
    local _wBfaPX = _wpdhP.Character
    if not _wBfaPX then return 0 end
    local _HrVNj = _wBfaPX:FindFirstChild("HumanoidRootPart")
    if not _HrVNj then return 0 end
    local _AOQD = p.Character
    if not _AOQD then return 0 end
    local _eqgDwk = _AOQD:FindFirstChild("HumanoidRootPart")
    if not _eqgDwk then return 0 end
    return math.floor((_HrVNj.Position - _eqgDwk.Position).Magnitude)
end

local function _DCtz(_DrEBwjG)
    local d = _HigHeJ[_DrEBwjG]
    if d then
        if d.Billboard then d.Billboard:Destroy() end
        _HigHeJ[_DrEBwjG] = nil
    end
end

local function _fVbj(p)
    if not p.Character or p == _wpdhP then return end
    local _fXJZ = p.Character:FindFirstChild("Head")
    if not _fXJZ then return end
    if _HigHeJ[p.UserId] then
        if _HigHeJ[p.UserId].Billboard then
            _HigHeJ[p.UserId].Billboard.Enabled = true
        end
        return
    end

    local _nhJSyW = _MJxJfniw.new("BillboardGui")
    _nhJSyW.Size = _pSAtlsi.new(0, 200, 0, 100)
    _nhJSyW.StudsOffset = _myOiEJ.new(0, 3, 0)
    _nhJSyW.AlwaysOnTop = true
    _nhJSyW.MaxDistance = 500
    _nhJSyW.Parent = _fXJZ

    local f = _MJxJfniw.new("Frame")
    f.Size = _pSAtlsi.new(1, 0, 1, 0)
    f.BackgroundTransparency = 1
    f.Parent = _nhJSyW

    _HigHeJ[p.UserId] = {Billboard = _nhJSyW, Frame = f}
end

local function _wBlJgLKm()
    if not _xNgXjaWq then
        for _, d in pairs(_HigHeJ) do
            if d.Billboard then d.Billboard.Enabled = false end
        end
        return
    end

    _vfRxiTL = _vfRxiTL + 1

    for _, p in ipairs(_UnSz:GetPlayers()) do
        if p == _wpdhP then _BHhc end
        if not p.Character then
            _DCtz(p.UserId)
            _BHhc
        end
        if _vfRxiTL % 30 == 0 and _HigHeJ[p.UserId] then
            _DCtz(p.UserId)
        end
        if not _HigHeJ[p.UserId] then
            _fVbj(p)
        end
        local d = _HigHeJ[p.UserId]
        if not d then _BHhc end
        if not d.Billboard or not d.Billboard.Parent then
            _HigHeJ[p.UserId] = nil
            _fVbj(p)
            d = _HigHeJ[p.UserId]
            if not d then _BHhc end
        end
        d.Billboard.Enabled = true

        local f = d.Frame
        for _, c in ipairs(f:GetChildren()) do c:Destroy() end

        local y = 0
        local _FPrCNp = 0
        local _gacTEQ = _aYqCKYMl(p)
        local _NoNCe = _UnHh(p)
        local _BmmDW = _kJrOxRCF(p)
        local _WmEHJklZ = _EExuPrb(p)

        if _ceau then
            local l = _MJxJfniw.new("TextLabel")
            l.Size = _pSAtlsi.new(1, 0, 0, 20)
            l.Position = _pSAtlsi.new(0, 0, 0, y)
            l.BackgroundTransparency = 1
            l.Text = p.Name
            l.TextColor3 = _NoNCe
            l.TextSize = 15
            l.Font = _nekcKc.Font.GothamBold
            l.TextStrokeTransparency = 0.3
            l.TextStrokeColor3 = _HtugY.fromRGB(0, 0, 0)
            l.TextXAlignment = _nekcKc.TextXAlignment.Center
            l.Parent = f
            y = y + 22
            _FPrCNp = _FPrCNp + 1
        end

        if _HHMn then
            local l = _MJxJfniw.new("TextLabel")
            l.Size = _pSAtlsi.new(1, 0, 0, 18)
            l.Position = _pSAtlsi.new(0, 0, 0, y)
            l.BackgroundTransparency = 1
            l.Text = "[" .. team .. "]"
            l.TextColor3 = _NoNCe
            l.TextSize = 13
            l.Font = _nekcKc.Font.GothamBold
            l.TextStrokeTransparency = 0.3
            l.TextStrokeColor3 = _HtugY.fromRGB(0, 0, 0)
            l.TextXAlignment = _nekcKc.TextXAlignment.Center
            l.Parent = f
            y = y + 20
            _FPrCNp = _FPrCNp + 1
        end

        if _FxijWu then
            local l = _MJxJfniw.new("TextLabel")
            l.Size = _pSAtlsi.new(1, 0, 0, 18)
            l.Position = _pSAtlsi.new(0, 0, 0, y)
            l.BackgroundTransparency = 1
            local c = _BmmDW > 70 and _HtugY.fromRGB(0, 255, 100) or _BmmDW > 40 and _HtugY.fromRGB(255, 200, 0) or _HtugY.fromRGB(255, 50, 50)
            l.Text = _BmmDW .. "HP"
            l.TextColor3 = c
            l.TextSize = 13
            l.Font = _nekcKc.Font.GothamBold
            l.TextStrokeTransparency = 0.3
            l.TextStrokeColor3 = _HtugY.fromRGB(0, 0, 0)
            l.TextXAlignment = _nekcKc.TextXAlignment.Center
            l.Parent = f
            y = y + 20
            _FPrCNp = _FPrCNp + 1
        end

        if _FADkZz then
            local l = _MJxJfniw.new("TextLabel")
            l.Size = _pSAtlsi.new(1, 0, 0, 18)
            l.Position = _pSAtlsi.new(0, 0, 0, y)
            l.BackgroundTransparency = 1
            l.Text = _WmEHJklZ .. "m"
            l.TextColor3 = _HtugY.fromRGB(200, 200, 200)
            l.TextSize = 13
            l.Font = _nekcKc.Font.Gotham
            l.TextStrokeTransparency = 0.3
            l.TextStrokeColor3 = _HtugY.fromRGB(0, 0, 0)
            l.TextXAlignment = _nekcKc.TextXAlignment.Center
            l.Parent = f
            y = y + 20
            _FPrCNp = _FPrCNp + 1
        end

        d.Billboard.Size = _pSAtlsi.new(0, 200, 0, _FPrCNp * 20 + 10)
    end
end


local _zQVUq = _ImCUrwn.ESP
local _yXoKyxX = _zQVUq:AddLeftGroupbox("透视设置")

_yXoKyxX:AddToggle("ESPEnabled", {
    _cawrzj = "透视总开关",
    _pphV = false,
    _rUdfI = function(v)
        _xNgXjaWq = v
        if v then _wBlJgLKm() end
    end
})

_yXoKyxX:AddDivider()

_yXoKyxX:AddToggle("ESPShowName", {
    _cawrzj = "显示名字",
    _pphV = true,
    _rUdfI = function(v)
        _ceau = v
        if _xNgXjaWq then _wBlJgLKm() end
    end
})

_yXoKyxX:AddToggle("ESPShowTeam", {
    _cawrzj = "显示队伍",
    _pphV = true,
    _rUdfI = function(v)
        _HHMn = v
        if _xNgXjaWq then _wBlJgLKm() end
    end
})

_yXoKyxX:AddToggle("ESPShowHealth", {
    _cawrzj = "显示血量",
    _pphV = true,
    _rUdfI = function(v)
        _FxijWu = v
        if _xNgXjaWq then _wBlJgLKm() end
    end
})

_yXoKyxX:AddToggle("ESPShowDist", {
    _cawrzj = "显示距离",
    _pphV = true,
    _rUdfI = function(v)
        _FADkZz = v
        if _xNgXjaWq then _wBlJgLKm() end
    end
})


_AaKeytNE.spawn(function()
    while not _lnOZlyPi do
        _AaKeytNE.wait(0.15)
        if _xNgXjaWq then
            _wBlJgLKm()
        end
    end
end)


_UnSz.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        _AaKeytNE.wait(0.3)
        if _xNgXjaWq then
            _wBlJgLKm()
        end
    end)
end)


_UnSz.PlayerRemoving:Connect(function(p)
    _DCtz(p.UserId)
end)


local _hsqPDI = _ImCUrwn.Vehicle
local _xYfSsyuD = _hsqPDI:AddLeftGroupbox("飞车功能")

_iRQoK().FlyCarSpeed = 50
_iRQoK().FlyCarControllerRunning = false
_iRQoK().FlyCarController = nil

_xYfSsyuD:AddSlider("FlyCarSpeedSlider", {
    _cawrzj = "飞车速度",
    _pphV = 50,
    _thNIl = 1,
    _MSKkvub = 139,
    _XiCy = 0,
    _KAgMCwY = "速度",
    _rUdfI = function(v)
        _iRQoK().FlyCarSpeed = v
    end
})

_xYfSsyuD:AddToggle("FlyCarToggle", {
    _cawrzj = "开始飞车",
    _pphV = false,
    _rUdfI = function(v)
        if v then
            local _zhThf = _wpdhP
            local _GNnxs = _zhThf and _zhThf.Character
            local _dMygWyMq = _GNnxs and _GNnxs:FindFirstChild("HumanoidRootPart")
            if not _dMygWyMq then return end
            
            if not _iRQoK().FlyCarControllerRunning then
                _iRQoK().FlyCarControllerRunning = true
                _iRQoK().FlyCarController = _AaKeytNE.spawn(function()
                    while _iRQoK().FlyCarControllerRunning do
                        local _CtomFV = _wpdhP
                        local _cXPQ = _CtomFV and _CtomFV.Character
                        local _LHncXEhR = _cXPQ and _cXPQ:FindFirstChild("HumanoidRootPart")
                        if _LHncXEhR then
                            _LHncXEhR.Anchored = false
                            local _erQj = _LHncXEhR:FindFirstChildOfClass("BodyVelocity")
                            if _erQj then pcall(function() _erQj:Destroy() end) end
                            local _gAnDHAxi = _LHncXEhR:FindFirstChildOfClass("BodyGyro")
                            if _gAnDHAxi then pcall(function() _gAnDHAxi:Destroy() end) end
                            local _JfbPwLU = _MJxJfniw.new("BodyVelocity")
                            _JfbPwLU.Parent = _LHncXEhR
                            _JfbPwLU.MaxForce = _myOiEJ.new(math.huge, math.huge, math.huge)
                            _JfbPwLU.Velocity = _xHvRDJI.CurrentCamera.CFrame.LookVector * (_iRQoK().FlyCarSpeed or 50)
                            local _tdHd = _MJxJfniw.new("BodyGyro")
                            _tdHd.Parent = _LHncXEhR
                            _tdHd.MaxTorque = _myOiEJ.new(math.huge, math.huge, math.huge)
                            _tdHd.D = 5000
                            _tdHd.P = 50000
                            _tdHd.CFrame = _xHvRDJI.CurrentCamera.CFrame
                        end
                        _AaKeytNE.wait(0.1)
                    end
                end)
            end
        else
            _iRQoK().FlyCarControllerRunning = false
            if _iRQoK().FlyCarController then
                _AaKeytNE.cancel(_iRQoK().FlyCarController)
                _iRQoK().FlyCarController = nil
            end
            local _zhThf = _wpdhP
            local _GNnxs = _zhThf and _zhThf.Character
            local _dMygWyMq = _GNnxs and _GNnxs:FindFirstChild("HumanoidRootPart")
            if _dMygWyMq then
                local _JfbPwLU = _dMygWyMq:FindFirstChildOfClass("BodyVelocity")
                if _JfbPwLU then _JfbPwLU:Destroy() end
                local _tdHd = _dMygWyMq:FindFirstChildOfClass("BodyGyro")
                if _tdHd then _tdHd:Destroy() end
            end
        end
    end
})



local function _daGF()
    return {
        {n = "车辆经销商", p = _myOiEJ.new(3719.9501953125, 3.018573522567749, -333.3118591308594), region = "圣奥里"},
        {n = "医院", p = _myOiEJ.new(3980.091064453125, 2.876060724258423, -138.79454040527344), region = "圣奥里"},
        {n = "警察局", p = _myOiEJ.new(3364.273193359375, 3.9188079834, -394.7233581542969), region = "圣奥里"},
        {n = "圣奥里修车店", p = _myOiEJ.new(2782.46875, 2.630995750427246, -418.59930419921875), region = "圣奥里"},
        {n = "圣奥里银行", p = _myOiEJ.new(3134.05419921875, 6.116048336029053, -171.36976623535156), region = "圣奥里"},
        {n = "圣奥里服装店", p = _myOiEJ.new(3617.91259765625, 3.1072206497192383, -452.8206481933594), region = "圣奥里"},
        {n = "圣奥里平民重生", p = _myOiEJ.new(3741.114990234375, 3.720573663711548, -438.1059875488281), region = "圣奥里"},
        {n = "圣奥里码头", p = _myOiEJ.new(4527.65625, -23.968238830566406, -280.59356689453125), region = "圣奥里"},
        {n = "圣奥里餐饮店", p = _myOiEJ.new(3182.416748046875, 3.01859188079834, 426.5179138183594), region = "圣奥里"},
        {n = "消防部门", p = _myOiEJ.new(3578.676025390625, 8.408823013305664, 579.6567993164062), region = "圣奥里"},
        {n = "宠物店", p = _myOiEJ.new(3678.237305, 3.017920, 693.114624), region = "圣奥里"},
        {n = "圣奥里大码头", p = _myOiEJ.new(2736.307617, 2.630299, -1120.333008), region = "圣奥里"},
        {n = "圣奥里海滩桥下(消星点)", p = _myOiEJ.new(3964.504395, -25.068211, -854.057251), region = "圣奥里"},
        {n = "大景超市", p = _myOiEJ.new(3936.582764, 3.038293, 1136.326416), region = "大景"},
        {n = "转镜中心", p = _myOiEJ.new(4152.919922, 2.631675, 941.446045), region = "大景"},
        {n = "道路服务", p = _myOiEJ.new(4271.332520, 2.628108, 1200.086914), region = "大景"},
        {n = "大景餐饮店", p = _myOiEJ.new(4476.997559, 3.037825, 906.802979), region = "大景"},
        {n = "送货中心", p = _myOiEJ.new(4399.419434, 3.038999, 1609.455933), region = "大景"},
        {n = "大景卖车店", p = _myOiEJ.new(3434.377441, 42.931786, 2687.997070), region = "大景"},
        {n = "莱斯维尔餐饮店", p = _myOiEJ.new(753.757812, 3.039824, 998.132996), region = "莱斯维尔"},
        {n = "莱斯维尔服装店", p = _myOiEJ.new(820.745117, 2.766988, 1047.445679), region = "莱斯维尔"},
        {n = "莱斯维尔自由广场", p = _myOiEJ.new(926.523376, 2.630995, 865.764771), region = "莱斯维尔"},
        {n = "莱斯维尔码头(游艇)", p = _myOiEJ.new(947.840210, -22.529087, 1216.085693), region = "莱斯维尔"},
        {n = "米尔顿左上加油站", p = _myOiEJ.new(1145.635742, 2.630916, -864.273682), region = "米尔顿"},
        {n = "米尔顿右下加油站", p = _myOiEJ.new(-1646.802734, 2.630164, 1812.894653), region = "米尔顿"},
        {n = "米尔顿上方加油站", p = _myOiEJ.new(-900.701660, 2.630927, 1124.683105), region = "米尔顿"},
        {n = "米尔顿居民区", p = _myOiEJ.new(-528.565552, 2.630996, 1331.981689), region = "米尔顿"},
        {n = "约克镇小银行", p = _myOiEJ.new(-668.217224, 2.630995, -65.347839), region = "约克镇"},
        {n = "约克镇修车厂", p = _myOiEJ.new(-407.163025, 3.076807, -6.098211), region = "约克镇"},
        {n = "约克镇枪店", p = _myOiEJ.new(-323.869293, 3.037825, 37.149670), region = "约克镇"},
        {n = "约克镇重生点", p = _myOiEJ.new(-219.560318, 3.039824, -85.725433), region = "约克镇"},
        {n = "约克镇当铺", p = _myOiEJ.new(-168.513733, 3.039000, -106.926529), region = "约克镇"},
        {n = "约克镇卫星车", p = _myOiEJ.new(-302.093567, 3.037825, -167.621017), region = "约克镇"},
        {n = "约克镇中心点", p = _myOiEJ.new(-275.995209, 2.630996, -139.985352), region = "约克镇"},
        {n = "黑市", p = _myOiEJ.new(1038.969849, -22.732950, 895.430237), region = "其他"},
        {n = "渔夫码头", p = _myOiEJ.new(-50.147552, -24.555279, 1462.145996), region = "其他"},
        {n = "农场", p = _myOiEJ.new(-1268.339233, 2.572412, 2560.060303), region = "其他"},
        {n = "监狱门口", p = _myOiEJ.new(-1697.931885, 2.630666, 1284.567383), region = "其他"},
        {n = "监狱广场", p = _myOiEJ.new(-1600.602417, 2.631028, 1268.060059), region = "其他"},
        {n = "代尔山", p = _myOiEJ.new(847.062988, 194.115753, -326.212708), region = "其他"},
        {n = "瀑布洞穴(消星点)", p = _myOiEJ.new(3040.956055, 109.688538, 2711.069336), region = "其他"},
        {n = "大桥", p = _myOiEJ.new(949.014954, 25.215754, 2897.654785), region = "其他"},
        {n = "地图右下(消星点)", p = _myOiEJ.new(-1651.385010, 2.414712, 3225.278320), region = "其他"},
        {n = "下部加油站", p = _myOiEJ.new(2270.378174, 2.630927, 154.161484), region = "其他"},
        {n = "游戏厅", p = _myOiEJ.new(2934.893799, 2.956458, 1693.660034), region = "其他"},
        {n = "高尔夫", p = _myOiEJ.new(2280.767090, 3.037836, 1982.357300), region = "其他"},
        {n = "修船厂", p = _myOiEJ.new(4096.405273, -30.401447, 2865.045166), region = "其他"},
    }
end
local _ofiWbzmL = _daGF()

local function _HOmLVw(_iqvZEaj)
    if not _sMbjxS.TeleportEnabled or _lnOZlyPi then return end
    local _GNnxs = _wpdhP.Character
    if not _GNnxs then return end
    local _DwZxGEZA = _GNnxs:FindFirstChild("HumanoidRootPart")
    if not _DwZxGEZA then return end
    pcall(function()
        _DwZxGEZA.CFrame = _jmEudoQq.new(_iqvZEaj)
    end)
end

local function _nGpFPZB()
    if _lnOZlyPi or not _sMbjxS.NoclipEnabled then return end
    local _GNnxs = _wpdhP.Character
    if not _GNnxs then return end
    for _, _gAeQeM in ipairs(_GNnxs:GetDescendants()) do
        if _gAeQeM:IsA("BasePart") then
            _gAeQeM.CanCollide = false
        end
    end
end

local function _jZcJounm(_mHJUp)
    _sMbjxS.NoclipEnabled = _mHJUp
    if _mHJUp then
        _nGpFPZB()
    else
        local _GNnxs = _wpdhP.Character
        if _GNnxs then
            for _, _gAeQeM in ipairs(_GNnxs:GetDescendants()) do
                if _gAeQeM:IsA("BasePart") then
                    _gAeQeM.CanCollide = true
                end
            end
        end
    end
end

local function _jAYb()
    if _lnOZlyPi or not _sMbjxS.HitboxEnabled then return end
    local _FkrAg = _UnSz:GetPlayers()
    local _MFkghOg = {}
    for i = 1, #_FkrAg do
        local p = _FkrAg[i]
        if p ~= _wpdhP and p.Character then
            if _sMbjxS.WhitelistEnabled and _QuCCG[p.UserId] then
            else
                local _GNnxs = p.Character
                local _fXJZ = _GNnxs:FindFirstChild("Head")
                local _uzzS = _GNnxs:FindFirstChildOfClass("Humanoid")
                if _uzzS and _uzzS.Health > 0 and _fXJZ then
                    _fXJZ.Size = _myOiEJ.new(_sMbjxS.HitboxSize, _sMbjxS.HitboxSize, _sMbjxS.HitboxSize)
                    _fXJZ.Transparency = 1
                    _fXJZ.Color = _HtugY.fromRGB(255, 215, 0)
                    _fXJZ.Material = _nekcKc.Material.Neon
                    _fXJZ.CanCollide = false
                    _MFkghOg[_fXJZ] = true
                end
            end
        end
    end
    for _fXJZ, _ in pairs(_urfNb) do
        if not _MFkghOg[_fXJZ] and _fXJZ and _fXJZ.Parent then
            _fXJZ.Size = _myOiEJ.new(2, 1, 1)
            _fXJZ.Transparency = 0
            _fXJZ.CanCollide = true
            _fXJZ.Color = _HtugY.new(1, 1, 1)
            _fXJZ.Material = _nekcKc.Material.Plastic
        end
    end
    _urfNb = _MFkghOg
end

local function _gEhMjTK()
    for _fXJZ, _ in pairs(_urfNb) do
        if _fXJZ and _fXJZ.Parent then
            _fXJZ.Size = _myOiEJ.new(2, 1, 1)
            _fXJZ.Transparency = 0
            _fXJZ.CanCollide = true
            _fXJZ.Color = _HtugY.new(1, 1, 1)
            _fXJZ.Material = _nekcKc.Material.Plastic
        end
    end
    _urfNb = {}
end

local function _cmQwVVM()
    if _lnOZlyPi then return end
    _QuCCG = {}
    local _FkrAg = _UnSz:GetPlayers()
    for i = 1, #_FkrAg do
        local p = _FkrAg[i]
        if p ~= _wpdhP then
            pcall(function()
                if p:IsFriendsWith(_wpdhP.UserId) then
                    _QuCCG[p.UserId] = true
                end
            end)
        end
    end
end

local _GIBE = _MtvpNCy:GetService("UserInputService")
local _NBVqRb = 35
local _QKnOq = { enabled = false, hrp = nil, hum = nil, microThread = nil, healthThread = nil, diedConn = nil, targetPos = nil, lastTime = 0 }
local _wHEHD = { active = false, head = nil, hrp = nil, hum = nil, rayLength = 3.5, rayCount = 12, verticalLayers = 3 }
local _kbGkRU
_AaKeytNE.spawn(function()
    pcall(function()
        local _tnluuv = _wpdhP.PlayerScripts:FindFirstChild("PlayerModule")
        if _tnluuv then _kbGkRU = require(_tnluuv):GetControls() end
    end)
end)

local function _FSrzKFIL()
    local _GNnxs = _wpdhP.Character
    if not _GNnxs then
        _QKnOq.hrp = nil _QKnOq.hum = nil
        _wHEHD.hrp = nil _wHEHD.head = nil _wHEHD.hum = nil
        return
    end
    _QKnOq.hrp = _GNnxs:FindFirstChild("HumanoidRootPart")
    _QKnOq.hum = _GNnxs:FindFirstChildOfClass("Humanoid")
    _wHEHD.hrp = _QKnOq.hrp
    _wHEHD.head = _GNnxs:FindFirstChild("Head")
    _wHEHD.hum = _QKnOq.hum
end

local function _JXFeOIQx()
    local _dMygWyMq = _wHEHD.hrp
    if not _dMygWyMq then return false end
    local _iqvZEaj = _dMygWyMq.Position
    local _LvCq = _Ameb.new()
    _LvCq.FilterType = _nekcKc.RaycastFilterType.Blacklist
    _LvCq.FilterDescendantsInstances = { _wpdhP.Character }
    for i = 1, _wHEHD.rayCount do
        local _XTmquDVx = (i / _wHEHD.rayCount) * 2 * math.pi
        local _qRRPRSBV = math.cos(_XTmquDVx)
        local _xvIVZqV = math.sin(_XTmquDVx)
        for j = -(_wHEHD.verticalLayers - 1) // 2, (_wHEHD.verticalLayers - 1) // 2 do
            local _rJMQza = _myOiEJ.new(_qRRPRSBV, j * 0.5, _xvIVZqV).Unit
            local _wuDHKVW = _xHvRDJI:Raycast(_iqvZEaj, _rJMQza * _wHEHD.rayLength, _LvCq)
            if _wuDHKVW and _wuDHKVW.Instance and _wuDHKVW.Instance.CanCollide and _wuDHKVW.Instance.Transparency < 0.9 then
                return true
            end
        end
    end
    return false
end

local function _rinH()
    if _wHEHD.active then return end
    if not _wHEHD.head or not _wHEHD.hrp or not _wHEHD.hum then return end
    _wHEHD.head.Anchored = true
    _wHEHD.hum.PlatformStand = true
    _wHEHD.active = true
end

local function _lrBvFGs()
    if not _wHEHD.active then return end
    if _wHEHD.head and _wHEHD.hum then
        _wHEHD.head.Anchored = false
        _wHEHD.hum.PlatformStand = false
    end
    _wHEHD.active = false
end

local function _qGPUY()
    _QKnOq.targetPos = _QKnOq.hrp.Position
    _QKnOq.lastTime = _zCKM()
    while _QKnOq.enabled do
        local _wWQstN = _zCKM()
        local _KrAeporB = _wWQstN - _QKnOq.lastTime
        _QKnOq.lastTime = _wWQstN
        if not _QKnOq.hrp or not _QKnOq.hrp.Parent then break end
        local _rEquP = _JXFeOIQx()
        if _rEquP and not _wHEHD.active then
            _rinH()
        elseif not _rEquP and _wHEHD.active then
            _lrBvFGs()
        end
        local _dDKVre
        if _kbGkRU then
            local _DVdpx = _kbGkRU:GetMoveVector()
            local _QbODgdja = _xHvRDJI.CurrentCamera.CFrame
            _dDKVre = (_QbODgdja.LookVector * -_DVdpx.Z) + (_QbODgdja.RightVector * _DVdpx.X)
        else
            _dDKVre = (_QKnOq.hum and _QKnOq.hum.MoveDirection) or _myOiEJ.zero
        end
        local _ZOaSPLLC = 0
        if _GIBE:IsKeyDown(_nekcKc.KeyCode.Space) then
            _ZOaSPLLC = 1
        elseif _GIBE:IsKeyDown(_nekcKc.KeyCode.LeftControl) then
            _ZOaSPLLC = -1
        end
        local _iQZGjZq = (_dDKVre + _myOiEJ.new(0, _ZOaSPLLC, 0)) * _NBVqRb * _KrAeporB
        _QKnOq.targetPos = _QKnOq.targetPos + _iQZGjZq
        local _IWQT = _QKnOq.hrp.Position
        local _McGS = _QKnOq.targetPos - _IWQT
        local _FEYUnJS = _McGS.Magnitude
        if _FEYUnJS > 0 then
            local _neoqFJe = math.ceil(_FEYUnJS / 10)
            local _LJFkP = _McGS / _neoqFJe
            for i = 1, _neoqFJe do
                if not _QKnOq.enabled then break end
                _IWQT = _IWQT + _LJFkP
                _QKnOq.hrp.CFrame = _jmEudoQq.new(_IWQT) * _QKnOq.hrp.CFrame.Rotation
                _QKnOq.hrp.Velocity = _myOiEJ.zero
            end
        else
            _QKnOq.hrp.CFrame = _jmEudoQq.new(_QKnOq.targetPos) * _QKnOq.hrp.CFrame.Rotation
            _QKnOq.hrp.Velocity = _myOiEJ.zero
        end
        if _QKnOq.hum then
            _QKnOq.hum:ChangeState(_nekcKc.HumanoidStateType.Climbing)
        end
        _AaKeytNE.wait(0.001)
    end
end

local function _sZcUbBj()
    while _QKnOq.enabled do
        if _QKnOq.hum and _QKnOq.hum.Health <= 0 then
            _QKnOq.hum.Health = _QKnOq.hum.MaxHealth
        end
        _AaKeytNE.wait(0.1)
    end
end

local function _rxVc()
    if _QKnOq.enabled then return end
    _FSrzKFIL()
    if not _QKnOq.hrp or not _QKnOq.hum then return end
    _QKnOq.enabled = true
    _QKnOq.hum:ChangeState(_nekcKc.HumanoidStateType.Climbing)
    _QKnOq.microThread = _AaKeytNE.spawn(_qGPUY)
    _QKnOq.healthThread = _AaKeytNE.spawn(_sZcUbBj)
    _QKnOq.diedConn = _QKnOq.hum.Died:Connect(function()
        if _QKnOq.hum and _QKnOq.enabled then
            _QKnOq.hum.Health = _QKnOq.hum.MaxHealth
            _QKnOq.hum:ChangeState(_nekcKc.HumanoidStateType.Running)
        end
    end)
end

local function _dhuQMY()
    _QKnOq.enabled = false
    _lrBvFGs()
    if _QKnOq.microThread then _AaKeytNE.cancel(_QKnOq.microThread) _QKnOq.microThread = nil end
    if _QKnOq.healthThread then _AaKeytNE.cancel(_QKnOq.healthThread) _QKnOq.healthThread = nil end
    if _QKnOq.diedConn then _QKnOq.diedConn:Disconnect() _QKnOq.diedConn = nil end
    if _QKnOq.hum then _QKnOq.hum:ChangeState(_nekcKc.HumanoidStateType.Running) end
end

_wpdhP.CharacterAdded:Connect(function()
    if _QKnOq.enabled then
        _dhuQMY()
        _AaKeytNE.wait(0.2)
        _rxVc()
    end
end)

local _LbsosD = false
local _EMxnTw

local _ammPJXP = false
local _vJmH = 20
_zZFPrwMJ.Heartbeat:Connect(function(_KrAeporB)
    if not _ammPJXP then return end
    local _GNnxs = _wpdhP.Character
    local _uzzS = _GNnxs and _GNnxs:FindFirstChildOfClass("Humanoid")
    local _DwZxGEZA = _GNnxs and _GNnxs:FindFirstChild("HumanoidRootPart")
    if _uzzS and _DwZxGEZA and _uzzS.MoveDirection.Magnitude > 0 then
        _DwZxGEZA.CFrame = _DwZxGEZA.CFrame + _uzzS.MoveDirection * _vJmH * _KrAeporB
    end
end)

local _ZbmlfW = false
local _oibaZ = false
local _WikqIdkT
pcall(function()
    _WikqIdkT = _vAsbR:WaitForChild("Remote", 5):WaitForChild("PlayerEvent", 5)
end)
if _WikqIdkT then
    local _jNcfLi
    _jNcfLi = _wiCvfv(_MtvpNCy, "__namecall", function(_Oiyis, ...)
        local _YdmRnVm = _Ejqt()
        local _xAuo = {...}
        if _Oiyis == _WikqIdkT and _YdmRnVm == "FireServer" then
            if _xAuo[1] == "setStaminaOrFood" and _xAuo[2] == "stamina" and _ZbmlfW then
                _xAuo[3] = 100
                return _jNcfLi(_Oiyis, unpack(_xAuo))
            end
            if _xAuo[1] == "takeDamage" and _oibaZ then
                return
            end
        end
        return _jNcfLi(_Oiyis, ...)
    end)
end
_AaKeytNE.spawn(function()
    while not _lnOZlyPi do
        if _ZbmlfW and _WikqIdkT then
            pcall(function()
                _WikqIdkT:FireServer("setStaminaOrFood", "stamina", 100)
            end)
        end
        _AaKeytNE.wait(0.3)
    end
end)

local _DFPvxNIU = false
local _QggbfRl = 40
local _vZsntyqE = nil
local function _eubX()
    if _vZsntyqE and _vZsntyqE.Parent then
        pcall(function()
            _vZsntyqE.Size = _myOiEJ.new(2, 1, 1)
            _vZsntyqE.Transparency = 0
        end)
    end
    _vZsntyqE = nil
end
_AaKeytNE.spawn(function()
    while not _lnOZlyPi do
        if _DFPvxNIU then
            local _GNnxs = _wpdhP.Character
            local _DwZxGEZA = _GNnxs and _GNnxs:FindFirstChild("HumanoidRootPart")
            local _erePn, bestDist = nil, _QggbfRl
            if _DwZxGEZA then
                for _, p in ipairs(_UnSz:GetPlayers()) do
                    if p ~= _wpdhP and p.Character then
                        local _uzzS = p.Character:FindFirstChildOfClass("Humanoid")
                        local _fXJZ = p.Character:FindFirstChild("Head")
                        if _uzzS and _uzzS.Health > 0 and _fXJZ then
                            local d = (_fXJZ.Position - _DwZxGEZA.Position).Magnitude
                            if d < _ULHzHGCu then
                                _ULHzHGCu = d
                                _erePn = _fXJZ
                            end
                        end
                    end
                end
            end
            if _erePn ~= _vZsntyqE then
                _eubX()
                if _erePn then
                    _vZsntyqE = _erePn
                    pcall(function()
                        _erePn.Size = _myOiEJ.new(500, 500, 500)
                        _erePn.Transparency = 1
                        _erePn.CanCollide = false
                    end)
                end
            end
        else
            _eubX()
        end
        _AaKeytNE.wait(0.2)
    end
end)

local _JVkxY = false
local _wXUS = 150
local _ZVVdZcrS = true
local _VqNILoth = true
local _tiEGPOlg, _QTFXGnRR
local function _YpNgvBn()
    if _tiEGPOlg then return end
    _tiEGPOlg = _MJxJfniw.new("ScreenGui")
    _tiEGPOlg.Name = "SA_AimFOV"
    _tiEGPOlg.ResetOnSpawn = false
    _tiEGPOlg.IgnoreGuiInset = true
    _tiEGPOlg.Parent = _wpdhP:WaitForChild("PlayerGui")
    _QTFXGnRR = _MJxJfniw.new("Frame")
    _QTFXGnRR.AnchorPoint = _DwODwa.new(0.5, 0.5)
    _QTFXGnRR.Position = _pSAtlsi.fromScale(0.5, 0.5)
    _QTFXGnRR.BackgroundTransparency = 1
    _QTFXGnRR.Parent = _tiEGPOlg
    local _DndB = _MJxJfniw.new("UIStroke")
    _DndB.Thickness = 1.5
    _DndB.Color = _HtugY.fromRGB(255, 255, 255)
    _DndB.Transparency = 0.4
    _DndB.ApplyStrokeMode = _nekcKc.ApplyStrokeMode.Border
    _DndB.Parent = _QTFXGnRR
    local _GsRcJYmn = _MJxJfniw.new("UICorner")
    _GsRcJYmn.CornerRadius = _WqNlRi.new(1, 0)
    _GsRcJYmn.Parent = _QTFXGnRR
end
_zZFPrwMJ.RenderStepped:Connect(function()
    if not _JVkxY then
        if _tiEGPOlg then _tiEGPOlg.Enabled = false end
        return
    end
    _YpNgvBn()
    _tiEGPOlg.Enabled = true
    _QTFXGnRR.Size = _pSAtlsi.fromOffset(_wXUS * 2, _wXUS * 2)
    local _NKcLtpUw = _xHvRDJI.CurrentCamera
    if not _NKcLtpUw then return end
    local _hmjtM = _DwODwa.new(_NKcLtpUw.ViewportSize.X / 2, _NKcLtpUw.ViewportSize.Y / 2)
    local _erePn, bestDist = nil, _wXUS
    for _, p in ipairs(_UnSz:GetPlayers()) do
        if p ~= _wpdhP and p.Character then
            local _uzzS = p.Character:FindFirstChildOfClass("Humanoid")
            local _fXJZ = p.Character:FindFirstChild("Head")
            if _uzzS and _uzzS.Health > 0 and _fXJZ then
                local _rTFcAy = _ZVVdZcrS and p.Team ~= nil and _wpdhP.Team ~= nil and p.Team == _wpdhP.Team
                if not _rTFcAy then
                    local _ygJnlc, onScreen = _NKcLtpUw:WorldToViewportPoint(_fXJZ.Position)
                    if _vWIznk then
                        local d = (_DwODwa.new(_ygJnlc.X, _ygJnlc.Y) - _hmjtM).Magnitude
                        if d < _ULHzHGCu then
                            local _YcCpVzrd = true
                            if _VqNILoth then
                                local _gqxF = _Ameb.new()
                                _gqxF.FilterType = _nekcKc.RaycastFilterType.Exclude
                                _gqxF.FilterDescendantsInstances = { _wpdhP.Character }
                                local _VScI = _mQnOe:Raycast(_NKcLtpUw.CFrame.Position, (_fXJZ.Position - _NKcLtpUw.CFrame.Position).Unit * 500, _gqxF)
                                _YcCpVzrd = (not _VScI) or _VScI.Instance:IsDescendantOf(p.Character)
                            end
                            if _YcCpVzrd then
                                _ULHzHGCu = d
                                _erePn = _fXJZ
                            end
                        end
                    end
                end
            end
        end
    end
    if _erePn then
        _NKcLtpUw.CFrame = _jmEudoQq.lookAt(_NKcLtpUw.CFrame.Position, _erePn.Position)
    end
end)

local _KHFcmZEo = false
_AaKeytNE.spawn(function()
    while not _lnOZlyPi do
        if _KHFcmZEo then
            local _ErnF = _mQnOe:FindFirstChild("Characters") and _mQnOe.Characters:FindFirstChild(_wpdhP.Name)
            if _ErnF then
                for _, _hJQBr in ipairs(_ErnF:GetChildren()) do
                    local _gyAnwp = _hJQBr:FindFirstChild("Config")
                    if _gyAnwp then
                        local _uRzepkm = _gyAnwp:FindFirstChild("Ammo")
                        local _NmWgmWy = _gyAnwp:FindFirstChild("TotalAmmo")
                        if _uRzepkm then _uRzepkm.Value = math.huge end
                        if _NmWgmWy then _NmWgmWy.Value = math.huge end
                    end
                end
            end
        end
        _zZFPrwMJ.Heartbeat:Wait()
    end
end)

local _crkItUL = 300
local _hRomAV = true
local _oghPL = false
local _fDXh = 1
local _qiQlSD = false
local _sqmb = 25
local _EnnAPUED = nil

local function _MeUtzE(_LAhOC)
    local _GNnxs = _wpdhP.Character
    if not _GNnxs then return false end
    local _ShtFCy = _GNnxs:FindFirstChild("Head")
    if not _ShtFCy then return false end
    local _OULKJJoG = _LAhOC.Position - _ShtFCy.Position
    local _FEYUnJS = _OULKJJoG.Magnitude
    if _FEYUnJS < 0.1 then return true end
    local _VkTaLdHR = _Ameb.new()
    _VkTaLdHR.FilterDescendantsInstances = {_GNnxs, _LAhOC.Parent}
    _VkTaLdHR.FilterType = _nekcKc.RaycastFilterType.Exclude
    return _mQnOe:Raycast(_ShtFCy.Position, _OULKJJoG.Unit * _FEYUnJS, _VkTaLdHR) == nil
end

local function _hxfbH()
    local _GNnxs = _wpdhP.Character
    if not _GNnxs then return nil end
    local _ShtFCy = _GNnxs:FindFirstChild("Head")
    if not _ShtFCy then return nil end
    local _qxlr, bestDist = nil, _crkItUL
    
    if _qiQlSD then
        local _ygnJk = nil
        local _tzRNsyo = 9999
        local _BOurL = nil
        local _XWYsYv = 9999
        
        for _, p in ipairs(_UnSz:GetPlayers()) do
            if p ~= _wpdhP and p.Character then
                local _uzzS = p.Character:FindFirstChildOfClass("Humanoid")
                if _uzzS and _uzzS.Health > 0 then
                    local _fXJZ = p.Character:FindFirstChild("Head")
                    if _fXJZ then
                        local _WmEHJklZ = (_fXJZ.Position - _ShtFCy.Position).Magnitude
                        if _WmEHJklZ < _XWYsYv and (not _hRomAV or _MeUtzE(_fXJZ)) then
                            _XWYsYv = _WmEHJklZ
                            _BOurL = p
                        end
                        if _WmEHJklZ <= _sqmb and _WmEHJklZ < _tzRNsyo and (not _hRomAV or _MeUtzE(_fXJZ)) then
                            _tzRNsyo = _WmEHJklZ
                            _ygnJk = p
                        end
                    end
                end
            end
        end
        
        if _ygnJk then
            return _ygnJk
        else
            return _BOurL
        end
    end
    
    for _, p in ipairs(_UnSz:GetPlayers()) do
        if p ~= _wpdhP and p.Character then
            local _uzzS = p.Character:FindFirstChildOfClass("Humanoid")
            if _uzzS and _uzzS.Health > 0 then
                local _fXJZ = p.Character:FindFirstChild("Head")
                if _fXJZ then
                    local _WmEHJklZ = (_fXJZ.Position - _ShtFCy.Position).Magnitude
                    if _WmEHJklZ < _ULHzHGCu and (not _hRomAV or _MeUtzE(_fXJZ)) then
                        _ULHzHGCu = _WmEHJklZ
                        _qxlr = p
                    end
                end
            end
        end
    end
    return _qxlr
end

local function _IZzrsk(_RKAhyUj)
    if _EnnAPUED then
        pcall(function() _EnnAPUED:SetText(_RKAhyUj) end)
    end
end

_zZFPrwMJ.Heartbeat:Connect(function()
    if not _lnOZlyPi then
        if _oghPL then
            do
                local _TmRKSI = _hxfbH()
                local _LAhOC = _TmRKSI and _TmRKSI.Character and _TmRKSI.Character:FindFirstChild("Head")
                if _LAhOC then
                    local _ShtFCy = _wpdhP.Character and _wpdhP.Character:FindFirstChild("Head")
                    if _ShtFCy then
                        local _PnutosgE = _ShtFCy.Position
                        local _mjdCob = _LAhOC.Position
                        local _OULKJJoG = (_mjdCob - _PnutosgE).Unit
                        local _rVAUgR = 100 * _fDXh
                        pcall(function()
                            _vAsbR.Remote.PlayerEvent:FireServer("damage", {
                                _Ibtrup = { { "Head", _rVAUgR } },
                                _Ezkp = { _PnutosgE, _OULKJJoG },
                                _TmRKSI = _TmRKSI,
                                _iqvZEaj = _mjdCob
                            })
                        end)
                        pcall(function()
                            local _cFQSAWy = _vAsbR:FindFirstChild("Events")
                            _cFQSAWy = _cFQSAWy and _cFQSAWy:FindFirstChild("HandleShots")
                            if _cFQSAWy then
                                _cFQSAWy:FireServer("2", "Shoot")
                            end
                        end)
                        _IZzrsk("状态：已锁定 " .. target.Name .. "，攻击已发送")
                    else
                        _IZzrsk("状态：等待角色头部加载")
                    end
                else
                    _IZzrsk("状态：范围内未找到敌人")
                end
            end
        end
    end
end)

local _qkrJ = _ImCUrwn.Gun:AddLeftGroupbox("枪械功能")
_qkrJ:AddToggle("FastFire", {
    _cawrzj = "超快射速",
    _pphV = false,
    _rUdfI = function(_AtNc)
        if not _AtNc then return end
        local function _rVfXNz()
            local _HnJQVzSW = _DFeN(true)
            for _, _PWUhjP in pairs(_HnJQVzSW) do
                if type(_PWUhjP) == "table" then
                    if _ZEapG(_PWUhjP, "SHOOT_MODE") then
                        _gVDHPjX(_PWUhjP, "SHOOT_MODE", 2)
                    end
                    if _ZEapG(_PWUhjP, "RPM") then
                        _gVDHPjX(_PWUhjP, "RPM", math.huge)
                    end
                    if _ZEapG(_PWUhjP, "DAMAGE") then
                        _gVDHPjX(_PWUhjP, "DAMAGE", math.huge)
                    end
                end
            end
        end
        _rVfXNz()
        local _GNnxs = _wpdhP.Character
        if _GNnxs then
            local _SZOyLI = _GNnxs:FindFirstChildOfClass("Humanoid")
            if _SZOyLI then
                _SZOyLI.Died:Connect(_rVfXNz)
            end
        end
        _gmPwSFt:Notify({ Title = "武器强化", Description = "无限射速已生效，死亡后自动重新生效", Time = 3 })
    end
})
_qkrJ:AddToggle("InfAmmo", {
    _cawrzj = "无限子弹",
    _pphV = false,
    _rUdfI = function(_AtNc)
        _KHFcmZEo = _AtNc
    end
})

local _JGBXAJO = _ImCUrwn.Player:AddRightGroupbox("快速互动")
_JGBXAJO:AddToggle("InteractToggle", {
    _cawrzj = "启用快速互动",
    _pphV = false,
    _rUdfI = function(_AtNc)
        _LbsosD = _AtNc
        if _AtNc and _EMxnTw then _EMxnTw() end
    end
})
_JGBXAJO:AddDivider()
_JGBXAJO:AddSlider("HoldTime", {
    _cawrzj = "按住时间",
    _pphV = 0,
    _thNIl = 0,
    _MSKkvub = 10,
    _XiCy = 0,
    _KAgMCwY = "秒",
    _rUdfI = function(_AtNc)
        _sMbjxS.HoldTime = _AtNc
        if not _LbsosD then return end
        for _, _UFRHbWh in ipairs(_xHvRDJI:GetDescendants()) do
            if _UFRHbWh:IsA("ProximityPrompt") then
                _UFRHbWh.HoldDuration = _AtNc
            end
        end
    end
})
_JGBXAJO:AddSlider("Distance", {
    _cawrzj = "触发距离",
    _pphV = 25,
    _thNIl = 5,
    _MSKkvub = 150,
    _XiCy = 0,
    _KAgMCwY = "单位",
    _rUdfI = function(_AtNc)
        _sMbjxS.Distance = _AtNc
        if not _LbsosD then return end
        for _, _UFRHbWh in ipairs(_xHvRDJI:GetDescendants()) do
            if _UFRHbWh:IsA("ProximityPrompt") then
                _UFRHbWh.MaxActivationDistance = _AtNc
            end
        end
    end
})

local _wqIu = _ImCUrwn.Player:AddRightGroupbox("伤害免疫")
_wqIu:AddToggle("GodToggle", {
    _cawrzj = "免疫部分伤害",
    _pphV = false,
    _rUdfI = function(_AtNc)
        _oibaZ = _AtNc
    end
})
_wqIu:AddLabel("免疫火焰和车爆炸时候的伤害")

local _ocrQCEfm = _ImCUrwn.Gun:AddLeftGroupbox("碰撞箱扩展")
_ocrQCEfm:AddToggle("HitboxToggle", {
    _cawrzj = "启用头部碰撞箱（推荐20-25）",
    _pphV = false,
    _rUdfI = function(_AtNc)
        _sMbjxS.HitboxEnabled = _AtNc
        if _AtNc then _jAYb() else _gEhMjTK() end
    end
})
_ocrQCEfm:AddSlider("HitboxSize", {
    _cawrzj = "头部大小",
    _pphV = 10,
    _thNIl = 5,
    _MSKkvub = 400,
    _XiCy = 0,
    _KAgMCwY = "单位",
    _rUdfI = function(_AtNc)
        _sMbjxS.HitboxSize = _AtNc
        if _sMbjxS.HitboxEnabled then _jAYb() end
    end
})
_ocrQCEfm:AddToggle("WhitelistToggle", {
    _cawrzj = "好友检测 (白名单)",
    _pphV = false,
    _rUdfI = function(_AtNc)
        _sMbjxS.WhitelistEnabled = _AtNc
        if _AtNc then _cmQwVVM() end
    end
})

local _cohsEXG = _ImCUrwn.Player:AddLeftGroupbox("角色修改")
_cohsEXG:AddToggle("FlyToggle", {
    _cawrzj = "飞行（绕过）",
    _pphV = false,
    _rUdfI = function(_AtNc)
        if _AtNc then _rxVc() else _dhuQMY() end
    end
})
_cohsEXG:AddSlider("FlySpeed", {
    _cawrzj = "飞行速度",
    _pphV = 35,
    _thNIl = 10,
    _MSKkvub = 620,
    _XiCy = 0,
    _rUdfI = function(_AtNc)
        _NBVqRb = _AtNc
    end
})
_cohsEXG:AddDivider()
_cohsEXG:AddToggle("NoclipToggle", {
    _cawrzj = "启用人物穿墙",
    _pphV = false,
    _rUdfI = function(_AtNc)
        _jZcJounm(_AtNc)
    end
})
_cohsEXG:AddDivider()
_cohsEXG:AddToggle("SpeedBypassToggle", {
    _cawrzj = "修改移速（绕过）（速度推荐80-90）",
    _pphV = false,
    _rUdfI = function(_AtNc)
        _ammPJXP = _AtNc
    end
})
_cohsEXG:AddSlider("SpeedBypassValue", {
    _cawrzj = "移速",
    _pphV = 20,
    _thNIl = 5,
    _MSKkvub = 150,
    _XiCy = 0,
    _rUdfI = function(_AtNc)
        _vJmH = _AtNc
    end
})
_cohsEXG:AddDivider()
_cohsEXG:AddToggle("StaminaToggle", {
    _cawrzj = "无限体力",
    _pphV = false,
    _rUdfI = function(_AtNc)
        _ZbmlfW = _AtNc
    end
})


local _NfKLcM = false
local _yUqJ = nil
local _AVyRkU = nil
local _WLCqBAy = nil

local function _HHtaS()
    if _AVyRkU then
        _AVyRkU:Destroy()
        _AVyRkU = nil
        _yUqJ = nil
        _WLCqBAy = nil
    end
end

local function _xNbkgQ()
    if _yUqJ then return end
    
    _AVyRkU = _MJxJfniw.new("ScreenGui")
    _AVyRkU.Name = "FlyQuickToggle"
    _AVyRkU.ResetOnSpawn = false
    _AVyRkU.ZIndexBehavior = _nekcKc.ZIndexBehavior.Sibling
    _AVyRkU.Parent = _wpdhP:WaitForChild("PlayerGui")
    
    local _vnXcnca = _MJxJfniw.new("ImageButton")
    _vnXcnca.Size = _pSAtlsi.new(0, 60, 0, 60)
    _vnXcnca.Position = _pSAtlsi.new(0.5, -30, 0.15, 0)
    _vnXcnca.BackgroundColor3 = _HtugY.fromRGB(30, 30, 50)
    _vnXcnca.BackgroundTransparency = 0.15
    _vnXcnca.BorderSizePixel = 2
    _vnXcnca.BorderColor3 = _HtugY.fromRGB(100, 200, 255)
    _vnXcnca.Image = "rbxassetid://7734068321"
    _vnXcnca.ImageColor3 = _HtugY.fromRGB(100, 200, 255)
    _vnXcnca.ScaleType = _nekcKc.ScaleType.Fit
    _vnXcnca.Parent = _AVyRkU
    _yUqJ = _vnXcnca
    
    local _GsRcJYmn = _MJxJfniw.new("UICorner")
    _GsRcJYmn.CornerRadius = _WqNlRi.new(1, 0)
    _GsRcJYmn.Parent = _vnXcnca
    
    _WLCqBAy = _MJxJfniw.new("TextLabel")
    _WLCqBAy.Size = _pSAtlsi.new(1, 0, 0, 20)
    _WLCqBAy.Position = _pSAtlsi.new(0, 0, 1, 0)
    _WLCqBAy.BackgroundTransparency = 1
    _WLCqBAy.TextColor3 = _HtugY.fromRGB(255, 255, 255)
    _WLCqBAy.TextSize = 12
    _WLCqBAy.Font = _nekcKc.Font.GothamBold
    _WLCqBAy.TextStrokeTransparency = 0.3
    _WLCqBAy.TextStrokeColor3 = _HtugY.fromRGB(0, 0, 0)
    _WLCqBAy.Text = "飞行: 关"
    _WLCqBAy.Parent = _vnXcnca
    
    local function _WRxrvkE()
        if _WLCqBAy then
            _WLCqBAy.Text = _QKnOq.enabled and "飞行: 开" or "飞行: 关"
            if _yUqJ then
                _yUqJ.BorderColor3 = _QKnOq.enabled and _HtugY.fromRGB(0, 255, 100) or _HtugY.fromRGB(100, 200, 255)
                _yUqJ.ImageColor3 = _QKnOq.enabled and _HtugY.fromRGB(0, 255, 100) or _HtugY.fromRGB(100, 200, 255)
            end
        end
    end
    
    _vnXcnca.MouseButton1Click:Connect(function()
        if _QKnOq.enabled then
            _dhuQMY()
        else
            _rxVc()
        end
        _WRxrvkE()
    end)
    
    local _vTyGbQn = false
    local _tVcKwd = nil
    local _HeQpUL = nil
    
    _vnXcnca.InputBegan:Connect(function(_qTSDuNa)
        if _qTSDuNa.UserInputType == _nekcKc.UserInputType.MouseButton1 then
            _vTyGbQn = true
            _tVcKwd = _qTSDuNa.Position
            _HeQpUL = _vnXcnca.Position
        end
    end)
    
    _vnXcnca.InputChanged:Connect(function(_qTSDuNa)
        if _vTyGbQn and _qTSDuNa.UserInputType == _nekcKc.UserInputType.MouseMovement then
            local _iQZGjZq = _qTSDuNa.Position - _tVcKwd
            local _fqDfVzf = _pSAtlsi.new(
                _HeQpUL.X.Scale + _iQZGjZq.X / _wpdhP:WaitForChild("PlayerGui").AbsoluteSize.X,
                _HeQpUL.X.Offset + _iQZGjZq.X,
                _HeQpUL.Y.Scale + _iQZGjZq.Y / _wpdhP:WaitForChild("PlayerGui").AbsoluteSize.Y,
                _HeQpUL.Y.Offset + _iQZGjZq.Y
            )
            _vnXcnca.Position = _fqDfVzf
        end
    end)
    
    _vnXcnca.InputEnded:Connect(function(_qTSDuNa)
        if _qTSDuNa.UserInputType == _nekcKc.UserInputType.MouseButton1 then
            _vTyGbQn = false
        end
    end)
    
    _WRxrvkE()
    
    local _eCrkq = _zZFPrwMJ.Heartbeat:Connect(function()
        if _NfKLcM and _WLCqBAy then
            _WRxrvkE()
        end
    end)
    table.insert(_DdLCiPp, _eCrkq)
end

_cohsEXG:AddDivider()
_cohsEXG:AddToggle("FlyQuickToggle", {
    _cawrzj = "飞天快捷开关",
    _fosTgG = "开启后在屏幕显示可拖动的飞天开关",
    _pphV = false,
    _rUdfI = function(_AtNc)
        _NfKLcM = _AtNc
        if _AtNc then
            _xNbkgQ()
        else
            _HHtaS()
        end
    end
})


local _SKhSmF = _ImCUrwn.KA:AddLeftGroupbox("杀戮光环")
_SKhSmF:AddLabel("注意：需装备枪械武器才有伤害")
_SKhSmF:AddToggle("KAToggle", {
    _cawrzj = "启用杀戮光环",
    _pphV = false,
    _rUdfI = function(_AtNc)
        _oghPL = _AtNc
        if _AtNc then
            _gmPwSFt:Notify({ Title = "杀戮光环", Description = "已开启，正在搜索敌人", Time = 3 })
            _IZzrsk("状态：已开启，正在搜索敌人")
        else
            _IZzrsk("状态：已关闭")
        end
    end
})
_SKhSmF:AddSlider("KADistance", {
    _cawrzj = "攻击距离",
    _pphV = 300,
    _thNIl = 50,
    _MSKkvub = 1000,
    _XiCy = 0,
    _KAgMCwY = "单位",
    _rUdfI = function(_AtNc)
        _crkItUL = _AtNc
    end
})
_SKhSmF:AddToggle("KAWallCheck", {
    _cawrzj = "墙体检测",
    _pphV = true,
    _rUdfI = function(_AtNc)
        _hRomAV = _AtNc
    end
})
_SKhSmF:AddSlider("KADamage", {
    _cawrzj = "伤害倍率",
    _pphV = 1,
    _thNIl = 1,
    _MSKkvub = 100,
    _XiCy = 0,
    _KAgMCwY = "倍",
    _rUdfI = function(_AtNc)
        _fDXh = _AtNc
    end
})
_SKhSmF:AddDivider()
_SKhSmF:AddToggle("KANearestOnly", {
    _cawrzj = "优先攻击最近目标",
    _fosTgG = "开启后优先攻击25米内的敌人，25米内无人则攻击远处目标",
    _pphV = false,
    _rUdfI = function(_AtNc)
        _qiQlSD = _AtNc
        if _AtNc then
            _gmPwSFt:Notify({ Title = "杀戮光环", Description = "已切换至25米内优先攻击", Time = 2 })
        end
    end
})
_SKhSmF:AddSlider("KANearestDistance", {
    _cawrzj = "优先攻击距离",
    _pphV = 25,
    _thNIl = 5,
    _MSKkvub = 100,
    _XiCy = 0,
    _KAgMCwY = "米",
    _rUdfI = function(_AtNc)
        _sqmb = _AtNc
        _gmPwSFt:Notify({ Title = "杀戮光环", Description = "优先攻击距离已设为" .. value .. "米", Time = 2 })
    end
})
_EnnAPUED = _SKhSmF:AddLabel("状态：已关闭")

local _iVsTfj = _ImCUrwn.Gun:AddLeftGroupbox("子追")
_iVsTfj:AddToggle("ZZToggle", {
    _cawrzj = "启用子追",
    _pphV = false,
    _rUdfI = function(_AtNc)
        _DFPvxNIU = _AtNc
        if not _AtNc then _eubX() end
    end
})
_iVsTfj:AddSlider("ZZDistance", {
    _cawrzj = "判定距离",
    _pphV = 40,
    _thNIl = 0,
    _MSKkvub = 1000,
    _XiCy = 0,
    _KAgMCwY = "米",
    _rUdfI = function(_AtNc)
        _QggbfRl = _AtNc
    end
})

local _oxWsrK = _ImCUrwn.Gun:AddRightGroupbox("自瞄")
_oxWsrK:AddToggle("AimToggle", {
    _cawrzj = "自瞄",
    _pphV = false,
    _rUdfI = function(_AtNc)
        _JVkxY = _AtNc
    end
})
_oxWsrK:AddSlider("AimFOVSize", {
    _cawrzj = "FOV圈大小",
    _pphV = 150,
    _thNIl = 30,
    _MSKkvub = 400,
    _XiCy = 0,
    _rUdfI = function(_AtNc)
        _wXUS = _AtNc
    end
})
_oxWsrK:AddToggle("AimNoTeam", {
    _cawrzj = "不瞄准队友",
    _pphV = true,
    _rUdfI = function(_AtNc)
        _ZVVdZcrS = _AtNc
    end
})
_oxWsrK:AddToggle("AimWallCheck", {
    _cawrzj = "墙壁检测",
    _pphV = true,
    _rUdfI = function(_AtNc)
        _VqNILoth = _AtNc
    end
})

local _ttjVoygk = _ImCUrwn.Teleports
local _yBynZY = _ttjVoygk:AddLeftGroupbox("传送控制")
_yBynZY:AddToggle("TeleportToggle", {
    _cawrzj = "启用传送",
    _pphV = false,
    _rUdfI = function(_AtNc)
        _sMbjxS.TeleportEnabled = _AtNc
    end
})

local _XaTBx = {}
for _, _dlQNW in ipairs(_ofiWbzmL) do
    table.insert(_XaTBx, _dlQNW.n)
end

_yBynZY:AddDropdown("TeleportSelect", {
    _KgsrpMuN = _XaTBx,
    _pphV = 1,
    _xKwDLiu = false,
    _cawrzj = "选定传送地点",
    _rUdfI = function(_AtNc) end,
})

_yBynZY:AddButton({
    _cawrzj = "传送到选定地点",
    _oOzpkrj = function()
        if not _sMbjxS.TeleportEnabled then
            _gmPwSFt:Notify({ Title = "传送", Description = "你还没有开启传送开关，请先开启", Time = 3 })
            return
        end
        local _qUUOGA = _rZbm.TeleportSelect.Value
        for _, _dlQNW in ipairs(_ofiWbzmL) do
            if _dlQNW.n == _qUUOGA then
                _HOmLVw(_dlQNW.p)
                _gmPwSFt:Notify({
                    _zvHe = "传送",
                    _ITaM = "正在传送至: " .. data.n,
                    _ogWPTXXH = 2,
                })
                return
            end
        end
        _gmPwSFt:Notify({ Title = "传送", Description = "未找到该地点", Time = 2 })
    end,
})

local function _KBAkCkNY(p)
    p.CharacterAdded:Connect(function()
        _AaKeytNE.wait(0.5)
        if _sMbjxS.HitboxEnabled and not _lnOZlyPi then
            _AaKeytNE.wait(0.5)
            _jAYb()
        end
        if _sMbjxS.NoclipEnabled and not _lnOZlyPi then
            _AaKeytNE.wait(0.1)
            _nGpFPZB()
        end
        if _xNgXjaWq and p ~= _wpdhP then
            _AaKeytNE.wait(0.3)
            _wBlJgLKm()
        end
    end)
    if _sMbjxS.WhitelistEnabled and not _lnOZlyPi then
        _cmQwVVM()
    end
end

for _, p in ipairs(_UnSz:GetPlayers()) do
    _KBAkCkNY(p)
end
local _ehhEOiI = _UnSz.PlayerAdded:Connect(_KBAkCkNY)
table.insert(_DdLCiPp, _ehhEOiI)
local _XWEv = _UnSz.PlayerRemoving:Connect(function(p)
    _DCtz(p.UserId)
end)
table.insert(_DdLCiPp, _XWEv)

local _DatSxntw = _zZFPrwMJ.RenderStepped:Connect(function()
    if _lnOZlyPi then return end
    if _sMbjxS.HitboxEnabled then
        _CwSZCx = _CwSZCx + 1
        if _CwSZCx % 3 == 0 then
            _jAYb()
        end
    end
    if _sMbjxS.NoclipEnabled then
        _nGpFPZB()
    end
end)
table.insert(_DdLCiPp, _DatSxntw)

_AaKeytNE.spawn(function()
    while not _lnOZlyPi do
        _AaKeytNE.wait(10)
        if _sMbjxS.WhitelistEnabled and not _lnOZlyPi then
            _cmQwVVM()
        end
        if _xNgXjaWq then
            _wBlJgLKm()
        end
    end
end)

_EMxnTw = function()
    if _lnOZlyPi or not _LbsosD then return end
    for _, _UFRHbWh in ipairs(_xHvRDJI:GetDescendants()) do
        if _UFRHbWh:IsA("ProximityPrompt") then
            _UFRHbWh.HoldDuration = _sMbjxS.HoldTime
            _UFRHbWh.MaxActivationDistance = _sMbjxS.Distance
        end
    end
end
local _pOvfPdF = _xHvRDJI.DescendantAdded:Connect(function(_UFRHbWh)
    if _lnOZlyPi then return end
    _AaKeytNE.wait(0.1)
    if _UFRHbWh:IsA("ProximityPrompt") and _LbsosD then
        _UFRHbWh.HoldDuration = _sMbjxS.HoldTime
        _UFRHbWh.MaxActivationDistance = _sMbjxS.Distance
    end
end)
table.insert(_DdLCiPp, _pOvfPdF)

_gmPwSFt:OnUnload(function()
    if _lnOZlyPi then return end
    _lnOZlyPi = true
    _dhuQMY()
    _NfKLcM = false
    _HHtaS()
    _eubX()
    if _tiEGPOlg then _tiEGPOlg:Destroy() end
    _gEhMjTK()
    if _sMbjxS.NoclipEnabled then
        _jZcJounm(false)
    end
    
    _iRQoK().FlyCarControllerRunning = false
    if _iRQoK().FlyCarController then
        _AaKeytNE.cancel(_iRQoK().FlyCarController)
        _iRQoK().FlyCarController = nil
    end
    for _QbpXo, _dlQNW in pairs(_HigHeJ) do
        if _dlQNW.Billboard then
            _dlQNW.Billboard:Destroy()
        end
    end
    _HigHeJ = {}
    for _, _MydbA in ipairs(_DdLCiPp) do
        pcall(function() _MydbA:Disconnect() end)
    end
    for _, _MydbA in ipairs(_fLDt) do
        pcall(function() _MydbA:Disconnect() end)
    end
end)

local _YLGW = _ImCUrwn.Settings:AddLeftGroupbox("脚本管理") _YLGW:AddButton("卸载脚本", function() _gmPwSFt:Unload() end) if _FyanTr then _FyanTr:SetLibrary(_gmPwSFt) _FyanTr:SetFolder("MyScriptTheme") _FyanTr:ApplyToTab(_ImCUrwn.Settings) end if _dtDwV then _dtDwV:SetLibrary(_gmPwSFt) _dtDwV:IgnoreThemeSettings() _dtDwV:SetFolder("MyScriptConfig") _dtDwV:BuildConfigSection(_ImCUrwn.Settings) end
