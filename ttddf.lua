-- ===== wdfex San Aurie 最终版（过检测 + 加速 + 范围 + 透视 + 自瞄，无加载动画） =====

-- ===== 1. 过检测 =====
local function SanAurieBypass()
    pcall(function()
        local player = game:GetService("Players").LocalPlayer
        local replicatedStorage = game:GetService("ReplicatedStorage")
        local coreGui = game:GetService("CoreGui")
        local teleportService = game:GetService("TeleportService")
        local scriptContext = game:GetService("ScriptContext")
        local logService = game:GetService("LogService")
        local starterGui = game:GetService("StarterGui")

        local antiKeywords = {"anticheat", "antifly", "antihack", "antikick", "antiban", "cheat", "detect"}
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
                local name = obj.Name:lower()
                for _, kw in pairs(antiKeywords) do
                    if name:match(kw) then
                        pcall(function() obj:Destroy() end)
                        break
                    end
                end
            end
        end

        local ps = player:FindFirstChild("PlayerScripts")
        if ps then
            for _, child in pairs(ps:GetChildren()) do
                if child:IsA("Script") or child:IsA("LocalScript") then
                    local n = child.Name:lower()
                    if n:match("anti") or n:match("cheat") or n:match("detect") then
                        pcall(function() child:Destroy() end)
                    end
                end
            end
        end

        player.Kick = function(self, msg)
            warn("拦截踢出: " .. tostring(msg))
            task.spawn(function()
                task.wait(0.1)
                pcall(function() teleportService:Teleport(game.PlaceId, player) end)
            end)
            return false
        end

        player:GetPropertyChangedSignal("Parent"):Connect(function()
            if not player.Parent then
                warn("被踢！重连...")
                task.wait(0.05)
                pcall(function() teleportService:Teleport(game.PlaceId, player) end)
            end
        end)

        coreGui.DescendantAdded:Connect(function(child)
            if child:IsA("ScreenGui") then
                local n = child.Name:lower()
                if n:match("kick") or n:match("ban") or n:match("disconnect") then
                    pcall(function() child:Destroy() end)
                end
            end
        end)

        for _, obj in pairs(replicatedStorage:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                local n = obj.Name:lower()
                if n:match("kick") or n:match("ban") then
                    local old = obj.FireServer
                    obj.FireServer = function(self, ...)
                        local args = {...}
                        for _, arg in pairs(args) do
                            if type(arg) == "string" then
                                if arg:lower():match("kick") or arg:lower():match("ban") then
                                    return
                                end
                            end
                        end
                        return old(self, ...)
                    end
                end
            end
        end

        scriptContext.Error:Connect(function(msg)
            if msg:find("267") or msg:lower():find("kick") or msg:lower():find("ban") then
                return
            end
        end)

        print("过检测已启动")
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

-- ===== 4. 加载UI =====
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/%E7%9A%AE%E8%84%9A%E6%9C%ACUI%E6%BA%90%E7%A0%81.lua"))():new("wdfex")

-- ===== 公告Tab =====
local AnnounceTab = UILibrary:Tab("『公告』", "18930406865")
local AnnounceSection = AnnounceTab:section("🛡️ 系统状态", true)
AnnounceSection:Label("━━━━━━━━━━━━━━━━━━━━")
AnnounceSection:Label("✅ 过检测已启动")
AnnounceSection:Label("✅ 防267已启动")
AnnounceSection:Label("✅ 防挂机已启动")
AnnounceSection:Label("━━━━━━━━━━━━━━━━━━━━")
AnnounceSection:Label("📢 永久免费 | 禁止倒卖")
AnnounceSection:Label("📢 速度上限80 | 低调使用")
AnnounceSection:Label("━━━━━━━━━━━━━━━━━━━━")

-- ===== 加速Tab =====
local SpeedTab = UILibrary:Tab("『加速』", "18930406865")
local SpeedSection = SpeedTab:section("速度控制", true)
SpeedSection:Label("⚠️ 速度超过80会增加被踢风险")
getgenv().SafeSpeed = 30
getgenv().SpeedLock = true
SpeedSection:Slider("步行速度", "Speed", 30, 16, 80, false, function(s)
    getgenv().SafeSpeed = s
    pcall(function()
        local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = s end
    end)
end)
SpeedSection:Toggle("锁定速度", "Lock", true, function(e)
    getgenv().SpeedLock = e
end)
SpeedSection:Textbox("重力", "Gravity", "输入数值", function(g)
    pcall(function() game.Workspace.Gravity = tonumber(g) or 196.2 end)
end)
SpeedSection:Toggle("穿墙", "NoClip", false, function(e)
    getgenv().NoClip = e
end)

game:GetService("RunService").Stepped:Connect(function()
    if getgenv().NoClip then
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
    if getgenv().SpeedLock then
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
    getgenv().HitboxEnabled = e
end)
RangeSection:Slider("大小", "Size", 15, 5, 80, false, function(s)
    getgenv().HitboxSize = s
end)
RangeSection:Slider("透明度", "Trans", 0.7, 0, 1, false, function(t)
    getgenv().HitboxTransparency = t
end)
RangeSection:Toggle("队伍检测", "Team", false, function(e)
    getgenv().TeamCheck = e
end)
RangeSection:Dropdown("颜色", "Color", {"Really red","Really blue","Really green","Really yellow","Really purple","Really black"}, function(c)
    getgenv().HitboxColor = c
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().HitboxEnabled then
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
        if not getgenv().ESPEnabled then
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
    getgenv().ESPEnabled = e
end)
ESPSection:Toggle("方框", "Box", false, function(e)
    getgenv().ShowBox = e
end)
ESPSection:Toggle("名字", "Name", false, function(e)
    getgenv().ShowName = e
end)
ESPSection:Toggle("血量", "Health", false, function(e)
    getgenv().ShowHealth = e
end)
ESPSection:Toggle("距离", "Dist", false, function(e)
    getgenv().ShowDistance = e
end)
ESPSection:Toggle("射线", "Tracer", false, function(e)
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
    if getgenv().AimEnabled then
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
    if getgenv().AimEnabled then
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
    getgenv().AimEnabled = e
    Notify(e and "✅ 自瞄已开启" or "❌ 自瞄已关闭", 2)
end)
AimSection:Slider("FOV范围", "FOV", 200, 30, 500, false, function(v)
    getgenv().AimFOV = v
    fovCircle.Radius = v
end)
AimSection:Slider("距离", "Range", 250, 50, 500, false, function(v)
    getgenv().AimRange = v
end)
AimSection:Slider("平滑度", "Smooth", 5, 1, 20, false, function(v)
    getgenv().AimSmoothness = v
end)
AimSection:Dropdown("部位", "Part", {"头部","躯干","腿部"}, function(part)
    local parts = { ["头部"] = "Head", ["躯干"] = "HumanoidRootPart", ["腿部"] = "Right Leg" }
    getgenv().AimPart = parts[part] or "Head"
end)
AimSection:Toggle("队伍检测", "Team", false, function(e)
    getgenv().AimTeamCheck = e
end)
AimSection:Toggle("掩体判断", "Wall", true, function(e)
    getgenv().AimWallCheck = e
end)

-- ===== 设置Tab =====
local SettingsTab = UILibrary:Tab("『设置』", "18930406865")
local SettingsSection = SettingsTab:section("控制", true)
SettingsSection:Button("关闭脚本", function()
    getgenv().HitboxEnabled = false
    getgenv().NoClip = false
    getgenv().ESPEnabled = false
    getgenv().AimEnabled = false
    ClearESP()
    pcall(function() fovCircle:Remove() end)
    pcall(function()
        local frosty = game:GetService("CoreGui"):FindFirstChild("frosty")
        if frosty then frosty:Destroy() end
    end)
end)

Notify("✅ wdfex 加载完成", 2)
print("✅ wdfex San Aurie 最终版加载完成")
print("🛡️ 防267已启动")