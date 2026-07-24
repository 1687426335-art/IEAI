-- ===== 皮脚本 - 完全隐身版（检测脚本发现不了） =====

-- 1. 隐藏执行痕迹（不让其他脚本检测到我们）
local function HideExecution()
    pcall(function()
        -- 清除调用栈痕迹
        local oldGetInfo = debug.getinfo
        debug.getinfo = function(...)
            local info = oldGetInfo(...)
            if info and info.source then
                -- 隐藏我们脚本的源路径
                if info.source:match("xiaopi77") or info.source:match("pastefy") then
                    return nil
                end
            end
            return info
        end
        
        -- 隐藏全局变量
        local oldGetFenv = getfenv
        getfenv = function(...)
            local env = oldGetFenv(...)
            if env then
                -- 移除我们添加的全局变量
                env.FlyCarSpeed = nil
                env.FlyCarEnabled = nil
                env.FlyCarRunning = nil
            end
            return env
        end
    end)
end
HideExecution()

-- 2. 使用混淆变量名（让检测脚本搜不到关键词）
local _a = game:GetService("StarterGui")
local _b = game:GetService("VirtualUser")
local _c = game:GetService("Players")
local _d = _c.LocalPlayer

-- 防挂机（使用混淆名）
_d.Idled:connect(function()
    _b:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    _b:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- 3. 全面清除检测脚本（静默执行，不触发任何事件）
local function SilentClear()
    pcall(function()
        -- 获取所有对象，静默删除检测脚本
        local allObjs = game:GetDescendants()
        local keywords = {
            "anti","cheat","detect","kick","ban","fly","speed",
            "exploit","hack","abuse","admin","mod","check"
        }
        
        for _, obj in pairs(allObjs) do
            if obj:IsA("Script") or obj:IsA("LocalScript") then
                local name = obj.Name:lower()
                for _, kw in pairs(keywords) do
                    if name:match(kw) then
                        pcall(function()
                            -- 静默删除（不触发任何事件）
                            obj.Parent = nil
                            obj:Destroy()
                        end)
                        break
                    end
                end
            end
        end
    end)
end
SilentClear()

-- 4. 拦截检测事件（让任何检测消息都发不出去）
local function InterceptDetection()
    pcall(function()
        -- 拦截RemoteEvent（防止服务器收到检测信号）
        local oldFire = game:GetService("ReplicatedStorage").FireServer
        if oldFire then
            game:GetService("ReplicatedStorage").FireServer = function(self, ...)
                local args = {...}
                for _, arg in pairs(args) do
                    if type(arg) == "string" and (arg:lower():match("anti") or arg:lower():match("cheat")) then
                        return -- 拦截检测消息
                    end
                end
                return oldFire(self, ...)
            end
        end
    end)
end
InterceptDetection()

-- 5. 使用无痕执行方式（避免被堆栈检测）
local function ExecuteHidden(func)
    local co = coroutine.create(func)
    coroutine.resume(co)
end

-- 6. 核心飞车功能（所有变量使用混淆名）
local _e = false  -- 飞车开关
local _f = 50     -- 飞车速度
local _g = false  -- 运行状态

local function _h()
    if _g then return end
    _g = true
    coroutine.wrap(function()
        while _g do
            if _e then
                pcall(function()
                    local _h = _d.Character and _d.Character:FindFirstChild("HumanoidRootPart")
                    if _h then
                        -- 清理旧的物理驱动
                        for _, _i in pairs(_h:GetChildren()) do
                            if _i:IsA("BodyVelocity") or _i:IsA("BodyGyro") then
                                _i:Destroy()
                            end
                        end
                        -- 创建新的物理驱动（使用随机属性名避免特征检测）
                        local _j = Instance.new("BodyVelocity")
                        _j.Name = "BodyVelocity" .. math.random(1000,9999)
                        _j.Parent = _h
                        _j.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                        _j.Velocity = workspace.CurrentCamera.CFrame.LookVector * _f
                        
                        local _k = Instance.new("BodyGyro")
                        _k.Name = "BodyGyro" .. math.random(1000,9999)
                        _k.Parent = _h
                        _k.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                        _k.D = 5000
                        _k.P = 50000
                        _k.CFrame = workspace.CurrentCamera.CFrame
                    end
                end)
            end
            task.wait(0.05)
        end
    end)()
end

-- 7. 防踢拦截（完全静默）
local function _l()
    pcall(function()
        local _m = _d
        -- 重写踢出函数（完全拦截）
        _m.Kick = function(self, msg)
            return false
        end
        -- 监听并阻止被踢
        _m:GetPropertyChangedSignal("Parent"):Connect(function()
            if not _m.Parent then
                task.wait(0.5)
                game:GetService("TeleportService"):Teleport(game.PlaceId, _m)
            end
        end)
    end)
end
_l()

-- 8. 加载UI（但使用混淆名）
local _n = loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/%E7%9A%AE%E8%84%9A%E6%9C%ACUI%E6%BA%90%E7%A0%81.lua"))():new("皮脚本")

local _o = _n:Tab("『飞车』", "18930406865")
local _p = _o:section("飞车控制", true)

_p:Toggle("开启飞车", "Toggle", false, function(_q)
    _e = _q
    if _q then
        _h()
        SilentClear()  -- 开启时再次清除检测
    else
        _g = false
        pcall(function()
            local _r = _d.Character and _d.Character:FindFirstChild("HumanoidRootPart")
            if _r then
                for _, _s in pairs(_r:GetChildren()) do
                    if _s:IsA("BodyVelocity") or _s:IsA("BodyGyro") then
                        _s:Destroy()
                    end
                end
            end
        end)
    end
end)

_p:Slider("飞车速度", "Speed", 50, 10, 500, false, function(_t)
    _f = _t
end)

_p:Button("速度 + 10", function()
    _f = _f + 10
end)

_p:Button("速度 - 10", function()
    if _f > 10 then _f = _f - 10 end
end)

_p:Button("上升", function()
    pcall(function()
        local _u = _d.Character and _d.Character:FindFirstChild("HumanoidRootPart")
        if _u then _u.CFrame = _u.CFrame * CFrame.new(0, 5, 0) end
    end)
end)

_p:Button("下降", function()
    pcall(function()
        local _v = _d.Character and _d.Character:FindFirstChild("HumanoidRootPart")
        if _v then _v.CFrame = _v.CFrame * CFrame.new(0, -5, 0) end
    end)
end)

-- 速度显示
local _w = _p:Label("当前速度: " .. tostring(_f))
task.spawn(function()
    while true do
        task.wait(0.3)
        pcall(function()
            if _w and _w.Parent then
                _w.Text = "当前速度: " .. tostring(_f)
            end
        end)
    end
end)

-- 设置Tab
local _x = _n:Tab("『设置』", "18930406865")
local _y = _x:section("控制", true)

_y:Button("关闭脚本", function()
    _g = false
    _e = false
    pcall(function()
        local _z = game:GetService("CoreGui"):FindFirstChild("frosty")
        if _z then _z:Destroy() end
    end)
end)

print("脚本已加载")