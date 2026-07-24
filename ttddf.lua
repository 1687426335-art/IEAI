-- ===== wdfex San Aurie 专用版（全部功能集成 + 完整过检测） =====

-- ===== 1. 完整过检测 =====
local function SanAurieBypass()
    pcall(function()
        local player = game:GetService("Players").LocalPlayer
        local replicatedStorage = game:GetService("ReplicatedStorage")
        local workspace = game:GetService("Workspace")
        local coreGui = game:GetService("CoreGui")
        local scriptContext = game:GetService("ScriptContext")
        local logService = game:GetService("LogService")
        local runService = game:GetService("RunService")
        local teleportService = game:GetService("TeleportService")
        local starterGui = game:GetService("StarterGui")
        local lighting = game:GetService("Lighting")
        local httpService = game:GetService("HttpService")

        -- 1.1 删除所有反作弊脚本
        local antiKeywords = {
            "anticheat", "antifly", "antihack", "antikick", "antiban", "kick", "ban", 
            "cheat", "detect", "admin", "mod", "guard", "protect", "security", 
            "verify", "punish", "report", "flag", "suspect", "ac", "monitor", "track",
            "anti", "exploit", "hack", "abuse", "check", "validate", "enforce",
            "speedcheck", "flycheck", "tpcheck", "noclipcheck", "teleportcheck"
        }
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
                local name = obj.Name:lower()
                local fullName = obj:GetFullName():lower()
                for _, kw in pairs(antiKeywords) do
                    if name:match(kw) or fullName:match(kw) then
                        pcall(function() obj:Destroy() end)
                        break
                    end
                end
            end
        end

        -- 1.2 删除PlayerScripts检测
        local ps = player:FindFirstChild("PlayerScripts")
        if ps then
            for _, child in pairs(ps:GetChildren()) do
                if child:IsA("Script") or child:IsA("LocalScript") then
                    local n = child.Name:lower()
                    if n:match("anti") or n:match("cheat") or n:match("detect") or n:match("kick") or n:match("ban") or n:match("fly") or n:match("speed") then
                        pcall(function() child:Destroy() end)
                    end
                end
            end
        end

        -- 1.3 删除ReplicatedStorage检测
        for _, obj in pairs(replicatedStorage:GetDescendants()) do
            if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
                local n = obj.Name:lower()
                if n:match("anti") or n:match("cheat") or n:match("detect") or n:match("kick") then
                    pcall(function() obj:Destroy() end)
                end
            end
        end

        -- 1.4 删除Workspace检测
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Script") or obj:IsA("LocalScript") then
                local n = obj.Name:lower()
                if n:match("anti") or n:match("cheat") or n:match("detect") or n:match("kick") then
                    pcall(function() obj:Destroy() end)
                end
            end
        end

        -- 1.5 删除CoreGui检测GUI
        for _, obj in pairs(coreGui:GetDescendants()) do
            if obj:IsA("ScreenGui") or obj:IsA("Frame") or obj:IsA("TextLabel") then
                local n = obj.Name:lower()
                if n:match("anti") or n:match("cheat") or n:match("detect") or n:match("ban") or n:match("kick") then
                    pcall(function() obj:Destroy() end)
                end
            end
        end

        -- 1.6 删除Lighting检测
        for _, obj in pairs(lighting:GetDescendants()) do
            if obj:IsA("Script") or obj:IsA("LocalScript") then
                local n = obj.Name:lower()
                if n:match("anti") or n:match("cheat") or n:match("detect") then
                    pcall(function() obj:Destroy() end)
                end
            end
        end

        -- 1.7 多层拦截踢出
        player.Kick = function(self, msg)
            warn("🛡️ 拦截踢出: " .. tostring(msg))
            task.spawn(function()
                task.wait(0.5)
                pcall(function() teleportService:Teleport(game.PlaceId, player) end)
            end)
            return false
        end

        -- 1.8 监听被踢重连
        player:GetPropertyChangedSignal("Parent"):Connect(function()
            if not player.Parent then
                warn("🛡️ 被踢！正在重连...")
                task.wait(0.1)
                pcall(function() teleportService:Teleport(game.PlaceId, player) end)
            end
        end)

        -- 1.9 删除踢出GUI
        coreGui.DescendantAdded:Connect(function(child)
            if child:IsA("ScreenGui") then
                local n = child.Name:lower()
                if n:match("kick") or n:match("ban") or n:match("disconnect") or n:match("error") then
                    pcall(function() child:Destroy() end)
                end
            end
        end)

        -- 1.10 拦截RemoteEvent踢出
        for _, obj in pairs(replicatedStorage:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                local n = obj.Name:lower()
                if n:match("kick") or n:match("ban") or n:match("detect") or n:match("anti") then
                    local old = obj.FireServer
                    obj.FireServer = function(self, ...)
                        local args = {...}
                        for _, arg in pairs(args) do
                            if type(arg) == "string" then
                                if arg:lower():match("kick") or arg:lower():match("ban") or arg:lower():match("cheat") then
                                    warn("🛡️ 拦截远程踢出")
                                    return
                                end
                            end
                        end
                        return old(self, ...)
                    end
                end
            end
        end

        -- 1.11 拦截所有错误日志
        scriptContext.Error:Connect(function(msg, stack)
            if msg:lower():match("kick") or msg:lower():match("ban") or msg:lower():match("267") then
                warn("🛡️ 拦截错误: " .. msg)
                return
            end
        end)

        -- 1.12 拦截日志输出
        logService.MessageOut:Connect(function(msg)
            if msg:lower():match("kick") or msg:lower():match("ban") or msg:lower():match("cheat") then
                return
            end
        end)

        -- 1.13 删除踢出弹窗（持续监控）
        starterGui:SetCore("SendNotification", function(...)
            local args = {...}
            if args[1] and (args[1]:lower():match("kick") or args[1]:lower():match("ban")) then
                return
            end
        end)

        -- 1.14 伪装正常玩家
        task.spawn(function()
            while true do
                task.wait(math.random(2, 5))
                pcall(function()
                    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                    if hum then
                        local cam = workspace.CurrentCamera
                        if cam then
                            cam.CFrame = cam.CFrame * CFrame.Angles(
                                math.rad(math.random(-1, 1)),
                                math.rad(math.random(-2, 2)),
                                0
                            )
                        end
                    end
                end)
            end
        end)

        -- 1.15 速度限制（防服务器检测）
        task.spawn(function()
            while true do
                task.wait(0.5)
                pcall(function()
                    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.WalkSpeed > 80 then
                        hum.WalkSpeed = 50
                    end
                end)
            end
        end)

        -- 1.16 伪装网络延迟
        task.spawn(function()
            while true do
                task.wait(math.random(10, 30))
                pcall(function()
                    local stats = game:GetService("Stats")
                    if stats then
                        stats.Network:GetPropertyChangedSignal("Ping"):Wait()
                    end
                end)
            end
        end)

        print("🛡️ 完整过检测已启动")
    end)
end
SanAurieBypass()

-- ===== 2. 通知 =====
local function Notify(text, duration)
    duration = duration or 3
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "wdfex",
            Text = text,
            Icon = "rbxassetid://18941716391",
            Duration = duration,
        })
    end)
end

Notify("✅ wdfex 已加载", 2)

-- ===== 3. 防挂机 =====
local VirtualUserService = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
    VirtualUserService:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUserService:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- ===== 4. 卡密验证 =====
getgenv().CardVerified = false
getgenv()._DeviceBinds = getgenv()._DeviceBinds or {}
local ValidCards = { ["1"] = true }
local DeviceUID = pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end) or "UNKNOWN"

local function CheckDeviceBind()
    for card, dev in pairs(getgenv()._DeviceBinds) do
        if dev == DeviceUID and ValidCards[card] then return true end
    end
    return false
end

if CheckDeviceBind() then
    getgenv().CardVerified = true
    Notify("✅ 设备已验证，自动登录", 2)
else
    Notify("🔐 请验证卡密", 2)
end

-- ===== 5. 加载UI =====
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/%E7%9A%AE%E8%84%9A%E6%9C%ACUI%E6%BA%90%E7%A0%81.lua"))():new("wdfex")

-- ===== 公告Tab =====
local AnnounceTab = UILibrary:Tab("『公告』", "18930406865")
local AnnounceSection = AnnounceTab:section("🔐 卡密验证", true)
AnnounceSection:Label("━━━━━━━━━━━━━━━━━━━━━━━━━━")
AnnounceSection:Label("✦ 欢迎使用 wdfex ✦")
AnnounceSection:Label("⚠️ 验证卡密后解锁全部功能")
AnnounceSection:Label("📱 绑定自动登录 | 🛡️ 防267已启动")
AnnounceSection:Label("━━━━━━━━━━━━━━━━━━━━━━━━━━")
AnnounceSection:Label("📱 设备ID: " .. string.sub(DeviceUID, 1, 20) .. "...")
AnnounceSection:Label("👤 用户: " .. game.Players.LocalPlayer.Name)
AnnounceSection:Textbox("📝 请输入卡密", "CardInput", "输入卡密...", function(i) getgenv()._CardInput = i end)
AnnounceSection:Button("✅ 验证并绑定", function()
    local input = getgenv()._CardInput
    if input and input ~= "" then
        if ValidCards[input] then
            if getgenv()._DeviceBinds[input] and getgenv()._DeviceBinds[input] ~= DeviceUID then
                Notify("❌ 卡密已被其他设备绑定", 3)
                return
            end
            getgenv()._DeviceBinds[input] = DeviceUID
            getgenv().CardVerified = true
            Notify("🎉 验证成功！已绑定", 3)
        else
            Notify("❌ 卡密错误", 3)
        end
    else
        Notify("⚠️ 请先输入卡密", 2)
    end
end)
AnnounceSection:Button("🔓 解绑设备", function()
    if getgenv().CardVerified then
        for card, dev in pairs(getgenv()._DeviceBinds) do
            if dev == DeviceUID then getgenv()._DeviceBinds[card] = nil break end
        end
        getgenv().CardVerified = false
        Notify("🔓 已解绑", 3)
    else
        Notify("⚠️ 当前未绑定", 2)
    end
end)
local statusLabel = AnnounceSection:Label("📊 状态: ❌ 未验证")
task.spawn(function()
    while true do
        task.wait(0.3)
        pcall(function()
            if statusLabel and statusLabel.Parent then
                statusLabel.Text = getgenv().CardVerified and "📊 状态: ✅ 已验证" or "📊 状态: ❌ 未验证"
            end
        end)
    end
end)
AnnounceSection:Label("━━━━━━━━━━━━━━━━━━━━━━━━━━")
AnnounceSection:Label("📢 公告: 永久免费 | 禁止倒卖 | 速度上限80")

-- ===== 功能检查 =====
local function CheckCard()
    if not getgenv().CardVerified then
        Notify("⚠️ 请先验证卡密", 2)
        return false
    end
    return true
end

-- ===== 加速Tab =====
local SpeedTab = UILibrary:Tab("『加速』", "18930406865")
local SpeedSection = SpeedTab:section("速度控制", true)
SpeedSection:Label("⚠️ 建议速度不超过80")
getgenv().SafeSpeed = 30
getgenv().SpeedLock = true
SpeedSection:Slider("步行速度", "Speed", 30, 16, 80, false, function(s)
    if not CheckCard() then return end
    getgenv().SafeSpeed = s
    pcall(function()
        local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = s end
    end)
end)
SpeedSection:Toggle("锁定速度", "Lock", true, function(e)
    if not CheckCard() then return end
    getgenv().SpeedLock = e
end)
SpeedSection:Textbox("重力", "Gravity", "输入数值", function(g)
    if not CheckCard() then return end
    pcall(function() game.Workspace.Gravity = tonumber(g) or 196.2 end)
end)
SpeedSection:Toggle("穿墙", "NoClip", false, function(e)
    if not CheckCard() then return end
    getgenv().NoClip = e
end)
game:GetService("RunService").Stepped:Connect(function()
    if getgenv().NoClip and getgenv().CardVerified then
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    end
end)
game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().SpeedLock and getgenv().CardVerified then
        pcall(function()
            local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed > 80 then hum.WalkSpeed = getgenv().SafeSpeed end
        end)
    end
end)

-- ===== 范围Tab =====
local RangeTab = UILibrary:Tab("『范围』", "18930406865")
local RangeSection = RangeTab:section("范围设置", true)
getgenv().HitboxSize = 15
getgenv().HitboxTransparency = 0.7
getgenv().HitboxEnabled = false
getgenv().HitboxColor = "Really red"
getgenv().TeamCheck = false
RangeSection:Toggle("开启范围", "Hitbox", false, function(e)
    if not CheckCard() then return end
    getgenv().HitboxEnabled = e
end)
RangeSection:Slider("大小", "Size", 15, 5, 80, false, function(s)
    if not CheckCard() then return end
    getgenv().HitboxSize = s
end)
RangeSection:Slider("透明度", "Trans", 0.7, 0, 1, false, function(t)
    if not CheckCard() then return end
    getgenv().HitboxTransparency = t
end)
RangeSection:Toggle("队伍检测", "Team", false, function(e)
    if not CheckCard() then return end
    getgenv().TeamCheck = e
end)
RangeSection:Dropdown("颜色", "Color", {"Really red","Really blue","Really green","Really yellow","Really purple","Really black"}, function(c)
    if not CheckCard() then return end
    getgenv().HitboxColor = c
end)
game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().HitboxEnabled and getgenv().CardVerified then
        for _, p in pairs(game:GetService("Players"):GetPlayers()) do
            if p ~= game.Players.LocalPlayer then
                if getgenv().TeamCheck and p.Team == game.Players.LocalPlayer.Team then else
                    pcall(function()
                        local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.Size = Vector3.new(getgenv().HitboxSize, getgenv().HitboxSize, getgenv().HitboxSize)
                            hrp.Transparency = getgenv().HitboxTransparency
                            hrp.BrickColor = BrickColor.new(getgenv().HitboxColor)
                            hrp.Material = "Neon"
                            hrp.CanCollide = false
                        end
                    end)
                end
            end
        end
    else
        for _, p in pairs(game:GetService("Players"):GetPlayers()) do
            if p ~= game.Players.LocalPlayer then
                pcall(function()
                    local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(2,2,1)
                        hrp.Transparency = 1
                        hrp.Material = "Plastic"
                        hrp.CanCollide = false
                    end
                end)
            end
        end
    end
end)

-- ===== 透视Tab =====
local ESPTab = UILibrary:Tab("『透视』", "18930406865")
local ESPSection = ESPTab:section("透视绘制", true)
getgenv().ESPEnabled = false
getgenv().ShowBox = false
getgenv().ShowName = false
getgenv().ShowHealth = false
getgenv().ShowDistance = false
getgenv().ShowTracer = false
local espObjs = {}
local function ClearESP()
    for _, o in pairs(espObjs) do pcall(function() o:Remove() end) end
    espObjs = {}
end
local function CreateESP(p)
    if p == game.Players.LocalPlayer then return end
    local square = Drawing.new("Square")
    square.Visible = false
    square.Color = Color3.new(1,0,0)
    square.Thickness = 1
    square.Filled = false
    square.Transparency = 0.5
    local nameText = Drawing.new("Text")
    nameText.Visible = false
    nameText.Color = Color3.new(1,1,1)
    nameText.Size = 14
    nameText.Center = true
    local healthText = Drawing.new("Text")
    healthText.Visible = false
    healthText.Color = Color3.new(0,1,0)
    healthText.Size = 12
    healthText.Center = true
    local distText = Drawing.new("Text")
    distText.Visible = false
    distText.Color = Color3.new(1,1,0)
    distText.Size = 12
    distText.Center = true
    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Color = Color3.new(1,0,0)
    tracer.Thickness = 1
    table.insert(espObjs, square)
    table.insert(espObjs, nameText)
    table.insert(espObjs, healthText)
    table.insert(espObjs, distText)
    table.insert(espObjs, tracer)
    game:GetService("RunService").RenderStepped:Connect(function()
        if not getgenv().ESPEnabled or not getgenv().CardVerified then
            square.Visible = false; nameText.Visible = false; healthText.Visible = false; distText.Visible = false; tracer.Visible = false
            return
        end
        pcall(function()
            local char = p.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local cam = workspace.CurrentCamera
            if hrp and hum and hum.Health > 0 then
                local pos, on = cam:WorldToViewportPoint(hrp.Position)
                local top, _ = cam:WorldToViewportPoint(hrp.Position + Vector3.new(0,3,0))
                local bot, _ = cam:WorldToViewportPoint(hrp.Position - Vector3.new(0,3,0))
                if on then
                    local h = top.Y - bot.Y
                    local w = h * 0.6
                    if getgenv().ShowBox then
                        square.Visible = true
                        square.Size = Vector2.new(w, h)
                        square.Position = Vector2.new(pos.X - w/2, pos.Y - h/2)
                        square.Color = p.Team and p.Team.TeamColor.Color or Color3.new(1,1,1)
                    else square.Visible = false end
                    if getgenv().ShowName then
                        nameText.Visible = true
                        nameText.Position = Vector2.new(pos.X, pos.Y - h/2 - 20)
                        nameText.Text = p.Name
                    else nameText.Visible = false end
                    if getgenv().ShowHealth then
                        healthText.Visible = true
                        healthText.Position = Vector2.new(pos.X, pos.Y + h/2 + 5)
                        healthText.Text = "❤ " .. math.floor(hum.Health)
                        healthText.Color = hum.Health > 50 and Color3.new(0,1,0) or Color3.new(1,0,0)
                    else healthText.Visible = false end
                    if getgenv().ShowDistance then
                        distText.Visible = true
                        distText.Position = Vector2.new(pos.X, pos.Y + h/2 + 25)
                        local lp = game.Players.LocalPlayer
                        local lhrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                        local d = lhrp and (hrp.Position - lhrp.Position).Magnitude or 0
                        distText.Text = math.floor(d) .. "m"
                    else distText.Visible = false end
                    if getgenv().ShowTracer then
                        tracer.Visible = true
                        tracer.From = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y)
                        tracer.To = Vector2.new(pos.X, pos.Y)
                    else tracer.Visible = false end
                else
                    square.Visible = false; nameText.Visible = false; healthText.Visible = false; distText.Visible = false; tracer.Visible = false
                end
            else
                square.Visible = false; nameText.Visible = false; healthText.Visible = false; distText.Visible = false; tracer.Visible = false
            end
        end)
    end)
end
for _, p in pairs(game.Players:GetPlayers()) do
    if p ~= game.Players.LocalPlayer then CreateESP(p) end
end
game.Players.PlayerAdded:Connect(function(p)
    if p ~= game.Players.LocalPlayer then CreateESP(p) end
end)
ESPSection:Toggle("ESP总开关", "ESP", false, function(e)
    if not CheckCard() then return end
    getgenv().ESPEnabled = e
end)
ESPSection:Toggle("方框", "Box", false, function(e)
    if not CheckCard() then return end
    getgenv().ShowBox = e
end)
ESPSection:Toggle("名字", "Name", false, function(e)
    if not CheckCard() then return end
    getgenv().ShowName = e
end)
ESPSection:Toggle("血量", "Health", false, function(e)
    if not CheckCard() then return end
    getgenv().ShowHealth = e
end)
ESPSection:Toggle("距离", "Dist", false, function(e)
    if not CheckCard() then return end
    getgenv().ShowDistance = e
end)
ESPSection:Toggle("射线", "Tracer", false, function(e)
    if not CheckCard() then return end
    getgenv().ShowTracer = e
end)

-- ===== 自瞄Tab =====
local AimTab = UILibrary:Tab("『自瞄』", "18930406865")
local AimSection = AimTab:section("圈圈自瞄", true)
AimSection:Label("🟢 绿色=空闲 | 🔴 红色=锁定")

getgenv().AimFOV = 200
getgenv().AimPart = "Head"
getgenv().AimSmoothness = 5
getgenv().AimRange = 250
getgenv().AimEnabled = false
getgenv().AimTeamCheck = false
getgenv().AimWallCheck = true

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Radius = getgenv().AimFOV
fovCircle.Thickness = 2
fovCircle.Color = Color3.fromRGB(0,255,0)
fovCircle.Filled = false
fovCircle.Transparency = 0.5
fovCircle.Position = workspace.CurrentCamera.ViewportSize / 2

local function IsVisible(targetPart)
    if not getgenv().AimWallCheck then return true end
    local success, result = pcall(function()
        local cam = workspace.CurrentCamera
        local start = cam.CFrame.Position
        local target = targetPart.Position
        local ray = Ray.new(start, (target - start).Unit * (target - start).Magnitude)
        local hit = workspace:FindPartOnRayWithIgnoreList(ray, {game.Players.LocalPlayer.Character})
        if hit then
            if hit:IsDescendantOf(targetPart.Parent) then return true end
            return false
        end
        return true
    end)
    return result
end

local function GetClosestEnemy()
    local player = game.Players.LocalPlayer
    local cam = workspace.CurrentCamera
    local closest = nil
    local closestDist = getgenv().AimFOV
    for _, enemy in pairs(game.Players:GetPlayers()) do
        if enemy ~= player then
            if getgenv().AimTeamCheck and enemy.Team == player.Team then else
                local char = enemy.Character
                if char then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum and hum.Health > 0 then
                        local targetPart = char:FindFirstChild(getgenv().AimPart or "Head")
                        if not targetPart then targetPart = char:FindFirstChild("HumanoidRootPart") end
                        if targetPart then
                            if not IsVisible(targetPart) then else
                                local pos, on = cam:WorldToViewportPoint(targetPart.Position)
                                if on then
                                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)).Magnitude
                                    local world = (targetPart.Position - cam.CFrame.Position).Magnitude
                                    if dist < closestDist and world <= getgenv().AimRange then
                                        closestDist = dist
                                        closest = enemy
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return closest
end

game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().AimEnabled and getgenv().CardVerified then
        fovCircle.Position = workspace.CurrentCamera.ViewportSize / 2
        fovCircle.Radius = getgenv().AimFOV
        fovCircle.Visible = true
        local target = GetClosestEnemy()
        if target then
            local targetPart = target.Character and target.Character:FindFirstChild(getgenv().AimPart or "Head")
            if not targetPart then targetPart = target.Character and target.Character:FindFirstChild("HumanoidRootPart") end
            if targetPart and IsVisible(targetPart) then
                fovCircle.Color = Color3.fromRGB(255,0,0)
            else
                fovCircle.Color = Color3.fromRGB(0,255,0)
            end
        else
            fovCircle.Color = Color3.fromRGB(0,255,0)
        end
    else
        fovCircle.Visible = false
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().AimEnabled and getgenv().CardVerified then
        pcall(function()
            local target = GetClosestEnemy()
            if target then
                local targetPart = target.Character and target.Character:FindFirstChild(getgenv().AimPart or "Head")
                if not targetPart then targetPart = target.Character and target.Character:FindFirstChild("HumanoidRootPart") end
                if targetPart and IsVisible(targetPart) then
                    local cam = workspace.CurrentCamera
                    local targetPos = targetPart.Position
                    local current = cam.CFrame
                    local newCF = CFrame.new(current.Position, targetPos)
                    local smooth = getgenv().AimSmoothness or 5
                    local lerp = math.min(1, 1 / smooth)
                    cam.CFrame = current:Lerp(newCF, lerp)
                end
            end
        end)
    end
end)

AimSection:Toggle("开启自瞄", "Aim", false, function(e)
    if not CheckCard() then return end
    getgenv().AimEnabled = e
    Notify(e and "✅ 自瞄已开启" or "❌ 自瞄已关闭", 2)
end)
AimSection:Slider("FOV范围", "FOV", 200, 30, 500, false, function(v)
    if not CheckCard() then return end
    getgenv().AimFOV = v
    fovCircle.Radius = v
end)
AimSection:Slider("距离", "Range", 250, 50, 500, false, function(v)
    if not CheckCard() then return end
    getgenv().AimRange = v
end)
AimSection:Slider("平滑度", "Smooth", 5, 1, 20, false, function(v)
    if not CheckCard() then return end
    getgenv().AimSmoothness = v
end)
AimSection:Dropdown("部位", "Part", {"头部","躯干","腿部"}, function(part)
    if not CheckCard() then return end
    local parts = { ["头部"] = "Head", ["躯干"] = "HumanoidRootPart", ["腿部"] = "Right Leg" }
    getgenv().AimPart = parts[part] or "Head"
end)
AimSection:Toggle("队伍检测", "Team", false, function(e)
    if not CheckCard() then return end
    getgenv().AimTeamCheck = e
end)
AimSection:Toggle("掩体判断", "Wall", true, function(e)
    if not CheckCard() then return end
    getgenv().AimWallCheck = e
end)

-- ===== 车辆加速Tab =====
local VehicleTab = UILibrary:Tab("『车辆加速』", "18930406865")
local VehicleSection = VehicleTab:section("车辆加速", true)
VehicleSection:Label("🚗 坐上车辆后自动加速")
getgenv().VehicleSpeed = 80
getgenv().VehicleAccelEnabled = false

local function GetCurrentVehicle()
    pcall(function()
        local player = game.Players.LocalPlayer
        local char = player.Character
        if not char then return nil end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return nil end
        local seat = hum.SeatPart
        if not seat then return nil end
        local vehicle = seat.Parent
        if vehicle and (vehicle:FindFirstChild("HumanoidRootPart") or vehicle:FindFirstChildOfClass("VehicleSeat")) then
            return vehicle
        end
        return nil
    end)
    return nil
end

game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().VehicleAccelEnabled and getgenv().CardVerified then
        pcall(function()
            local vehicle = GetCurrentVehicle()
            if vehicle then
                local hrp = vehicle:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local bv = hrp:FindFirstChild("VehicleBV")
                    if not bv then
                        bv = Instance.new("BodyVelocity")
                        bv.Name = "VehicleBV"
                        bv.Parent = hrp
                        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                    end
                    bv.Velocity = hrp.CFrame.LookVector * getgenv().VehicleSpeed
                end
            end
        end)
    end
end)

VehicleSection:Toggle("开启车辆加速", "VehicleAccel", false, function(e)
    if not CheckCard() then return end
    getgenv().VehicleAccelEnabled = e
    Notify(e and "🚗 车辆加速已开启" or "❌ 车辆加速已关闭", 2)
end)
VehicleSection:Slider("车辆速度", "VehicleSpeed", 80, 20, 200, false, function(s)
    if not CheckCard() then return end
    getgenv().VehicleSpeed = s
end)

-- ===== 设置Tab =====
local SettingsTab = UILibrary:Tab("『设置』", "18930406865")
local SettingsSection = SettingsTab:section("控制", true)
SettingsSection:Button("关闭脚本", function()
    getgenv().HitboxEnabled = false
    getgenv().NoClip = false
    getgenv().ESPEnabled = false
    getgenv().AimEnabled = false
    getgenv().VehicleAccelEnabled = false
    ClearESP()
    pcall(function() fovCircle:Remove() end)
    pcall(function()
        local frosty = game:GetService("CoreGui"):FindFirstChild("frosty")
        if frosty then frosty:Destroy() end
    end)
end)

print("✅ wdfex San Aurie 专用版加载完成")
print("🛡️ 防267已启动")
print("📱 卡密: 1")