-- ===== wdfex 完整版（加速 + 范围 + 透视 + 自瞄圈 + 掩体判断 + 高级卡密验证 + 设备绑定） =====

-- ===== 1. 过检测 =====
local function BypassAll()
    pcall(function()
        local player = game:GetService("Players").LocalPlayer
        local keywords = {"anti", "cheat", "detect", "kick", "ban", "fly", "speed", "exploit", "hack", "abuse", "admin", "mod", "check", "security"}
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("Script") or obj:IsA("LocalScript") then
                local name = obj.Name:lower()
                for _, kw in pairs(keywords) do
                    if name:match(kw) then
                        pcall(function() obj:Destroy() end)
                        break
                    end
                end
            end
        end
        local scripts = player:FindFirstChild("PlayerScripts")
        if scripts then
            for _, child in pairs(scripts:GetChildren()) do
                if child:IsA("Script") or child:IsA("LocalScript") then
                    local name = child.Name:lower()
                    if name:match("anti") or name:match("cheat") or name:match("detect") then
                        pcall(function() child:Destroy() end)
                    end
                end
            end
        end
        player.Kick = function(self, msg) warn("拦截踢出: "..tostring(msg)) return false end
        player:GetPropertyChangedSignal("Parent"):Connect(function()
            if not player.Parent then
                warn("检测到被踢，尝试重连...")
                task.wait(0.5)
                pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId, player) end)
            end
        end)
        game:GetService("CoreGui").DescendantAdded:Connect(function(child)
            if child:IsA("ScreenGui") and (child.Name:lower():match("kick") or child.Name:lower():match("ban")) then
                pcall(function() child:Destroy() end)
            end
        end)
    end)
end
BypassAll()

-- ===== 2. 通知 =====
local function Notify(title, text, duration)
    duration = duration or 3
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title or "wdfex",
            Text = text,
            Icon = "rbxassetid://18941716391",
            Duration = duration,
        })
    end)
end

-- ===== 3. 获取设备UID =====
local function GetDeviceUID()
    local uid = nil
    pcall(function()
        uid = game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    if not uid or uid == "" then
        pcall(function()
            local player = game.Players.LocalPlayer
            uid = player.UserId .. "_" .. game:GetService("RbxAnalyticsService"):GetClientId()
        end)
    end
    if not uid or uid == "" then
        pcall(function()
            local http = game:GetService("HttpService")
            uid = http:GenerateGUID(false)
        end)
    end
    return uid or "UNKNOWN_DEVICE"
end

local DeviceUID = GetDeviceUID()
print("📱 设备UID: " .. DeviceUID)

-- ===== 4. 卡密验证系统（设备绑定） =====
getgenv().CardVerified = false
getgenv()._DeviceBinds = getgenv()._DeviceBinds or {}

local ValidCards = {
    ["1"] = true,
    ["2"] = true,
    ["3"] = true,
}

local function CheckDeviceBind()
    for card, boundDevice in pairs(getgenv()._DeviceBinds) do
        if boundDevice == DeviceUID and ValidCards[card] then
            return true, card
        end
    end
    return false, nil
end

local isBound, boundCard = CheckDeviceBind()
if isBound then
    getgenv().CardVerified = true
    Notify("wdfex", "✅ 设备已验证！卡密已绑定，自动登录", 2)
else
    Notify("wdfex", "🔐 新设备，请验证卡密", 2)
    wait(1)
    Notify("wdfex", "请在公告中输入卡密验证", 3)
end
wait(1)

-- ===== 5. 加载UI =====
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/%E7%9A%AE%E8%84%9A%E6%9C%ACUI%E6%BA%90%E7%A0%81.lua"))():new("wdfex")

-- ===== 公告Tab（高级卡密验证） =====
local AnnounceTab = UILibrary:Tab("『公告』", "18930406865")
local AnnounceSection = AnnounceTab:section("🔐 卡密验证系统", true)

AnnounceSection:Label("━━━━━━━━━━━━━━━━━━━━━━━━")
AnnounceSection:Label("⚠️ 验证卡密后解锁全部功能")
AnnounceSection:Label("📱 绑定后自动登录")
AnnounceSection:Label("━━━━━━━━━━━━━━━━━━━━━━━━")

AnnounceSection:Label("📱 设备ID: " .. string.sub(DeviceUID, 1, 20) .. "...")

AnnounceSection:Textbox("📝 请输入卡密", "CardInput", "点击此处输入卡密...", function(input)
    getgenv()._CardInput = input
end)

AnnounceSection:Button("✅ 验证并绑定设备", function()
    local input = getgenv()._CardInput
    if input and input ~= "" then
        if ValidCards[input] then
            if getgenv()._DeviceBinds[input] and getgenv()._DeviceBinds[input] ~= DeviceUID then
                Notify("wdfex", "❌ 该卡密已被其他设备绑定！", 3)
                return
            end
            getgenv()._DeviceBinds[input] = DeviceUID
            getgenv().CardVerified = true
            Notify("wdfex", "🎉 验证成功！设备已绑定，下次自动登录", 3)
        else
            getgenv().CardVerified = false
            Notify("wdfex", "❌ 卡密错误，请重新输入", 3)
        end
    else
        Notify("wdfex", "⚠️ 请先输入卡密", 2)
    end
end)

AnnounceSection:Button("🔓 解绑设备", function()
    if getgenv().CardVerified then
        for card, device in pairs(getgenv()._DeviceBinds) do
            if device == DeviceUID then
                getgenv()._DeviceBinds[card] = nil
                break
            end
        end
        getgenv().CardVerified = false
        Notify("wdfex", "🔓 已解绑，下次启动需要重新验证", 3)
    else
        Notify("wdfex", "⚠️ 当前未绑定卡密", 2)
    end
end)

local statusLabel = AnnounceSection:Label("📊 状态: ❌ 未验证")
task.spawn(function()
    while true do
        task.wait(0.3)
        pcall(function()
            if statusLabel and statusLabel.Parent then
                if getgenv().CardVerified then
                    statusLabel.Text = "📊 状态: ✅ 已验证 (设备已绑定)"
                else
                    statusLabel.Text = "📊 状态: ❌ 未验证 (请输入卡密)"
                end
            end
        end)
    end
end)

AnnounceSection:Label("━━━━━━━━━━━━━━━━━━━━━━━━")
AnnounceSection:Label("👤 当前用户: " .. game.Players.LocalPlayer.Name)
AnnounceSection:Label("🆔 用户ID: " .. game.Players.LocalPlayer.UserId)
AnnounceSection:Label("━━━━━━━━━━━━━━━━━━━━━━━━")

AnnounceSection:Label("📢 公告内容:")
AnnounceSection:Label("  ● 本脚本永久免费")
AnnounceSection:Label("  ● 禁止倒卖")
AnnounceSection:Label("  ● 安全速度上限80")
AnnounceSection:Label("  ● 验证后设备自动绑定，无需重复输入")
AnnounceSection:Label("━━━━━━━━━━━━━━━━━━━━━━━━")

-- ===== 信息Tab =====
local InfoTab = UILibrary:Tab("『信息』", "18930406865")
local InfoSection = InfoTab:section("玩家信息", true)
InfoSection:Label("用户名: " .. game.Players.LocalPlayer.Name)
InfoSection:Label("服务器ID: " .. game.GameId)
InfoSection:Label("状态: 防267已启动")
InfoSection:Label("设备UID: " .. string.sub(DeviceUID, 1, 30) .. "...")
if getgenv().CardVerified then
    InfoSection:Label("卡密状态: ✅ 已验证")
else
    InfoSection:Label("卡密状态: ❌ 未验证")
end

local function CheckCard()
    if not getgenv().CardVerified then
        Notify("wdfex", "⚠️ 卡密未验证，请先在公告中验证卡密", 2)
        return false
    end
    return true
end

-- ===== 加速Tab =====
local SpeedTab = UILibrary:Tab("『加速』", "18930406865")
local SpeedSection = SpeedTab:section("安全速度控制", true)
SpeedSection:Label("⚠️ 安全速度范围: 16 ~ 80")
getgenv().SafeSpeed = 30
getgenv().SpeedLock = true
getgenv().WarningShown = false
SpeedSection:Slider("安全步行速度", "SafeSpeed", 30, 16, 80, false, function(s)
    if not CheckCard() then return end
    getgenv().SafeSpeed = s
    getgenv().WarningShown = false
    pcall(function()
        local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = getgenv().SafeSpeed end
    end)
end)
SpeedSection:Toggle("锁定安全速度", "SpeedLock", true, function(enabled)
    if not CheckCard() then return end
    getgenv().SpeedLock = enabled
    getgenv().WarningShown = false
    if enabled then
        pcall(function()
            local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = getgenv().SafeSpeed end
        end)
    end
end)
game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().SpeedLock and getgenv().CardVerified then
        pcall(function()
            local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                if hum.WalkSpeed > 80 then
                    if not getgenv().WarningShown then
                        getgenv().WarningShown = true
                        Notify("wdfex", "⚠️ 超速警告！速度超过80，已自动降速", 3)
                    end
                    hum.WalkSpeed = getgenv().SafeSpeed
                else
                    getgenv().WarningShown = false
                end
            end
        end)
    end
end)
SpeedSection:Textbox("设置重力", "Gravity", "输入数值", function(g)
    if not CheckCard() then return end
    pcall(function() game.Workspace.Gravity = tonumber(g) or 196.2 end)
end)
SpeedSection:Toggle("穿墙（NoClip）", "NoClip", false, function(enabled)
    if not CheckCard() then return end
    getgenv().NoClip = enabled
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

-- ===== 范围Tab =====
local RangeTab = UILibrary:Tab("『范围』", "18930406865")
local RangeSection = RangeTab:section("范围设置", true)
getgenv().HitboxSize = 15
getgenv().HitboxTransparency = 0.7
getgenv().HitboxEnabled = false
getgenv().HitboxColor = "Really red"
getgenv().TeamCheck = false
RangeSection:Toggle("开启范围", "Hitbox", false, function(enabled)
    if not CheckCard() then return end
    getgenv().HitboxEnabled = enabled
end)
RangeSection:Slider("范围大小", "Size", 15, 5, 80, false, function(size)
    if not CheckCard() then return end
    getgenv().HitboxSize = size
end)
RangeSection:Slider("范围透明度", "Transparency", 0.7, 0, 1, false, function(trans)
    if not CheckCard() then return end
    getgenv().HitboxTransparency = trans
end)
RangeSection:Toggle("队伍检测", "TeamCheck", false, function(enabled)
    if not CheckCard() then return end
    getgenv().TeamCheck = enabled
end)
RangeSection:Dropdown("范围颜色", "Color", {
    "Really red", "Really blue", "Really green",
    "Really yellow", "Really purple", "Really black",
    "Really pink", "Really orange"
}, function(color)
    if not CheckCard() then return end
    getgenv().HitboxColor = color
end)
game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().HitboxEnabled and getgenv().CardVerified then
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                if getgenv().TeamCheck and player.Team == game.Players.LocalPlayer.Team then
                else
                    pcall(function()
                        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
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
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                pcall(function()
                    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(2, 2, 1)
                        hrp.Transparency = 1
                        hrp.Material = "Plastic"
                        hrp.CanCollide = false
                    end
                end)
            end
        end
    end
end)

-- ===== 透视绘制Tab =====
local ESPTab = UILibrary:Tab("『透视绘制』", "18930406865")
local ESPSection = ESPTab:section("绘制设置", true)
getgenv().ESPEnabled = false
getgenv().ShowBox = false
getgenv().ShowName = false
getgenv().ShowHealth = false
getgenv().ShowDistance = false
getgenv().ShowTracer = false
local espObjects = {}
local function ClearESP()
    for _, obj in pairs(espObjects) do pcall(function() obj:Remove() end) end
    espObjects = {}
end
local function CreateESP(player)
    if player == game.Players.LocalPlayer then return end
    local square = Drawing.new("Square")
    square.Visible = false
    square.Color = Color3.new(1, 0, 0)
    square.Thickness = 1
    square.Filled = false
    square.Transparency = 0.5
    local nameText = Drawing.new("Text")
    nameText.Visible = false
    nameText.Color = Color3.new(1, 1, 1)
    nameText.Size = 14
    nameText.Center = true
    local healthText = Drawing.new("Text")
    healthText.Visible = false
    healthText.Color = Color3.new(0, 1, 0)
    healthText.Size = 12
    healthText.Center = true
    local distText = Drawing.new("Text")
    distText.Visible = false
    distText.Color = Color3.new(1, 1, 0)
    distText.Size = 12
    distText.Center = true
    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Color = Color3.new(1, 0, 0)
    tracer.Thickness = 1
    table.insert(espObjects, square)
    table.insert(espObjects, nameText)
    table.insert(espObjects, healthText)
    table.insert(espObjects, distText)
    table.insert(espObjects, tracer)
    game:GetService("RunService").RenderStepped:Connect(function()
        if not getgenv().ESPEnabled or not getgenv().CardVerified then
            square.Visible = false; nameText.Visible = false; healthText.Visible = false; distText.Visible = false; tracer.Visible = false
            return
        end
        pcall(function()
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local cam = workspace.CurrentCamera
            local lp = game.Players.LocalPlayer
            if hrp and hum and hum.Health > 0 then
                local pos, onScreen = cam:WorldToViewportPoint(hrp.Position)
                local topPos, _ = cam:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0))
                local botPos, _ = cam:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                if onScreen then
                    local height = topPos.Y - botPos.Y
                    local width = height * 0.6
                    if getgenv().ShowBox then
                        square.Visible = true
                        square.Size = Vector2.new(width, height)
                        square.Position = Vector2.new(pos.X - width/2, pos.Y - height/2)
                        square.Color = player.Team and player.Team.TeamColor.Color or Color3.new(1, 1, 1)
                    else square.Visible = false end
                    if getgenv().ShowName then
                        nameText.Visible = true
                        nameText.Position = Vector2.new(pos.X, pos.Y - height/2 - 20)
                        nameText.Text = player.Name
                    else nameText.Visible = false end
                    if getgenv().ShowHealth then
                        healthText.Visible = true
                        healthText.Position = Vector2.new(pos.X, pos.Y + height/2 + 5)
                        healthText.Text = "❤ " .. math.floor(hum.Health)
                        healthText.Color = hum.Health > 50 and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
                    else healthText.Visible = false end
                    if getgenv().ShowDistance then
                        distText.Visible = true
                        distText.Position = Vector2.new(pos.X, pos.Y + height/2 + 25)
                        local lpChar = lp.Character
                        local lpHRP = lpChar and lpChar:FindFirstChild("HumanoidRootPart")
                        local dist = lpHRP and (hrp.Position - lpHRP.Position).Magnitude or 0
                        distText.Text = math.floor(dist) .. "m"
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
for _, player in pairs(game.Players:GetPlayers()) do
    if player ~= game.Players.LocalPlayer then CreateESP(player) end
end
game.Players.PlayerAdded:Connect(function(player)
    if player ~= game.Players.LocalPlayer then CreateESP(player) end
end)
ESPSection:Toggle("ESP总开关", "ESP", false, function(enabled)
    if not CheckCard() then return end
    getgenv().ESPEnabled = enabled
end)
ESPSection:Toggle("显示方框", "Box", false, function(enabled)
    if not CheckCard() then return end
    getgenv().ShowBox = enabled
end)
ESPSection:Toggle("显示名字", "Name", false, function(enabled)
    if not CheckCard() then return end
    getgenv().ShowName = enabled
end)
ESPSection:Toggle("显示血量", "Health", false, function(enabled)
    if not CheckCard() then return end
    getgenv().ShowHealth = enabled
end)
ESPSection:Toggle("显示距离", "Distance", false, function(enabled)
    if not CheckCard() then return end
    getgenv().ShowDistance = enabled
end)
ESPSection:Toggle("显示射线", "Tracer", false, function(enabled)
    if not CheckCard() then return end
    getgenv().ShowTracer = enabled
end)

-- ===== 自瞄Tab =====
local AimTab = UILibrary:Tab("『自瞄』", "18930406865")
local AimSection = AimTab:section("圈圈自瞄", true)

AimSection:Label("⚠️ 开启后准星会自动锁定敌人")
AimSection:Label("🟢 绿色圈=空闲 | 🔴 红色圈=锁定目标")
AimSection:Label("✅ 自动掩体判断（被墙挡住不瞄）")

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
fovCircle.Color = Color3.fromRGB(0, 255, 0)
fovCircle.Filled = false
fovCircle.Transparency = 0.5
fovCircle.Position = workspace.CurrentCamera.ViewportSize / 2

local function IsVisible(targetPart)
    if not getgenv().AimWallCheck then return true end
    local success, result = pcall(function()
        local camera = workspace.CurrentCamera
        local startPos = camera.CFrame.Position
        local targetPos = targetPart.Position
        local ray = Ray.new(startPos, (targetPos - startPos).Unit * (targetPos - startPos).Magnitude)
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
    local camera = workspace.CurrentCamera
    local closest = nil
    local closestDist = getgenv().AimFOV
    for _, enemy in pairs(game.Players:GetPlayers()) do
        if enemy ~= player then
            if getgenv().AimTeamCheck and enemy.Team == player.Team then
            else
                local char = enemy.Character
                if char then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum and hum.Health > 0 then
                        local targetPart = char:FindFirstChild(getgenv().AimPart or "Head")
                        if not targetPart then targetPart = char:FindFirstChild("HumanoidRootPart") end
                        if targetPart then
                            if not IsVisible(targetPart) then
                            else
                                local pos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                                if onScreen then
                                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                                    local worldDist = (targetPart.Position - camera.CFrame.Position).Magnitude
                                    if dist < closestDist and worldDist <= getgenv().AimRange then
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
                fovCircle.Color = Color3.fromRGB(255, 0, 0)
            else
                fovCircle.Color = Color3.fromRGB(0, 255, 0)
            end
        else
            fovCircle.Color = Color3.fromRGB(0, 255, 0)
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
                    local camera = workspace.CurrentCamera
                    local targetPos = targetPart.Position
                    local currentCF = camera.CFrame
                    local newCF = CFrame.new(currentCF.Position, targetPos)
                    local smooth = getgenv().AimSmoothness or 5
                    local lerpFactor = math.min(1, 1 / smooth)
                    camera.CFrame = currentCF:Lerp(newCF, lerpFactor)
                end
            end
        end)
    end
end)

AimSection:Toggle("开启自瞄", "Aim", false, function(enabled)
    if not CheckCard() then return end
    getgenv().AimEnabled = enabled
    if enabled then
        Notify("wdfex", "✅ 自瞄已开启", "绿色圈=空闲 | 红色圈=锁定", 2)
    else
        fovCircle.Visible = false
        Notify("wdfex", "❌ 自瞄已关闭", "", 1)
    end
end)

AimSection:Slider("自瞄范围(FOV)", "FOV", 200, 30, 500, false, function(val)
    if not CheckCard() then return end
    getgenv().AimFOV = val
    fovCircle.Radius = val
end)

AimSection:Slider("自瞄距离", "Range", 250, 50, 500, false, function(val)
    if not CheckCard() then return end
    getgenv().AimRange = val
end)

AimSection:Slider("自瞄平滑度", "Smooth", 5, 1, 20, false, function(val)
    if not CheckCard() then return end
    getgenv().AimSmoothness = val
end)

AimSection:Dropdown("瞄准部位", "Part", {
    "头部", "躯干", "腿部"
}, function(part)
    if not CheckCard() then return end
    local parts = { ["头部"] = "Head", ["躯干"] = "HumanoidRootPart", ["腿部"] = "Right Leg" }
    getgenv().AimPart = parts[part] or "Head"
    Notify("wdfex", "✅ 瞄准部位已切换", part, 1)
end)

AimSection:Toggle("队伍检测", "TeamCheck", false, function(enabled)
    if not CheckCard() then return end
    getgenv().AimTeamCheck = enabled
end)

AimSection:Toggle("掩体判断", "WallCheck", true, function(enabled)
    if not CheckCard() then return end
    getgenv().AimWallCheck = enabled
    Notify("wdfex", enabled and "✅ 掩体判断已开启" or "❌ 掩体判断已关闭", "", 1)
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

print("✅ wdfex加载完成 - 卡密: 1")
print("🟢 自瞄圈: 绿色=空闲 | 🔴 红色=锁定目标")
print("✅ 掩体判断已开启")
print("📱 设备绑定已开启")