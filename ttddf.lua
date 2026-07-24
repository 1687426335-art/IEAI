-- ===== wdfex 防267 + 安全加速 + 范围 + 透视绘制 + 公告卡密验证 + 顶部滚动文字 =====

-- ===== 1. 过检测系统 =====
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
        
        player.Kick = function(self, msg)
            warn("拦截踢出: " .. tostring(msg))
            return false
        end
        
        player:GetPropertyChangedSignal("Parent"):Connect(function()
            if not player.Parent then
                warn("检测到被踢，尝试重连...")
                task.wait(0.5)
                pcall(function()
                    game:GetService("TeleportService"):Teleport(game.PlaceId, player)
                end)
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

-- ===== 2. 右边通知函数 =====
local function Notify(title, text, duration)
    duration = duration or 3
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Icon = "rbxassetid://18941716391",
            Duration = duration,
        })
    end)
end

-- ===== 3. 卡密验证系统 =====
getgenv().CardVerified = false

local ValidCards = {
    ["1"] = true,
}

local VerifiedPlayers = {}
local CurrentPlayer = game.Players.LocalPlayer.Name

local function LoadSavedVerification()
    pcall(function()
        if getgenv()._VerifiedPlayers then
            VerifiedPlayers = getgenv()._VerifiedPlayers
        end
        if VerifiedPlayers[CurrentPlayer] then
            getgenv().CardVerified = true
            return true
        end
        return false
    end)
    return false
end

local function SaveVerification()
    pcall(function()
        getgenv()._VerifiedPlayers = VerifiedPlayers
    end)
end

if LoadSavedVerification() then
    Notify("wdfex", "✅ 欢迎回来！卡密已验证", 2)
else
    Notify("wdfex", "欢迎使用wdfex，请验证卡密", 2)
    wait(1)
    Notify("wdfex", "请在公告中输入卡密验证", 3)
end
wait(1)

-- ===== 4. 顶部滚动文字 =====
local function CreateTopScrollText()
    pcall(function()
        local gui = Instance.new("ScreenGui")
        gui.Name = "TopScrollText"
        gui.Parent = game:GetService("CoreGui")
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.ResetOnSpawn = false
        gui.DisplayOrder = 9999
        
        local label = Instance.new("TextLabel")
        label.Name = "ScrollLabel"
        label.Parent = gui
        label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        label.BackgroundTransparency = 0.4
        label.BorderColor3 = Color3.fromRGB(255, 0, 0)
        label.BorderSizePixel = 1
        label.Size = UDim2.new(0, 80, 0, 22)
        label.Position = UDim2.new(0, -80, 0, 4)
        label.Font = Enum.Font.GothamBold
        label.Text = "你好"
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.TextWrapped = true
        label.ClipsDescendants = false
        label.ZIndex = 9999
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = label
        
        local stroke = Instance.new("UIStroke")
        stroke.Parent = label
        stroke.Color = Color3.fromRGB(255, 0, 0)
        stroke.Thickness = 1
        
        task.spawn(function()
            while gui and label and label.Parent do
                local startX = -80
                local endX = game:GetService("GuiService").ScreenSize.X + 50
                local speed = 180
                
                label.Position = UDim2.new(0, startX, 0, 4)
                
                while label and label.Parent and label.Position.X.Offset < endX do
                    pcall(function()
                        local currentX = label.Position.X.Offset
                        local newX = currentX + speed * task.wait(0.016)
                        label.Position = UDim2.new(0, newX, 0, 4)
                    end)
                end
                
                if label and label.Parent then
                    label.Position = UDim2.new(0, startX, 0, 4)
                end
                task.wait(0.1)
            end
        end)
    end)
end

CreateTopScrollText()

-- ===== 5. 加载UI =====
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/%E7%9A%AE%E8%84%9A%E6%9C%ACUI%E6%BA%90%E7%A0%81.lua"))():new("wdfex")

-- ===== 公告Tab =====
local AnnounceTab = UILibrary:Tab("『公告』", "18930406865")
local AnnounceSection = AnnounceTab:section("卡密验证", true)

AnnounceSection:Label("⚠️ 请输入卡密验证后使用功能")
AnnounceSection:Label("卡密: 联系作者获取")

AnnounceSection:Textbox("输入卡密", "CardInput", "请输入卡密", function(input)
    getgenv()._CardInput = input
end)

AnnounceSection:Button("验证", function()
    local input = getgenv()._CardInput
    if input and input ~= "" then
        if ValidCards[input] then
            getgenv().CardVerified = true
            VerifiedPlayers[CurrentPlayer] = true
            SaveVerification()
            Notify("✅ 验证成功", "卡密正确！所有功能已解锁", 3)
        else
            getgenv().CardVerified = false
            Notify("❌ 验证失败", "卡密错误，请重新输入", 3)
        end
    else
        Notify("⚠️ 提示", "请先输入卡密", 2)
    end
end)

AnnounceSection:Button("解绑", function()
    if getgenv().CardVerified then
        getgenv().CardVerified = false
        VerifiedPlayers[CurrentPlayer] = nil
        SaveVerification()
        Notify("🔓 已解绑", "卡密已解绑", 3)
    else
        Notify("⚠️ 提示", "当前未绑定卡密", 2)
    end
end)

local statusLabel = AnnounceSection:Label("状态: ❌ 未验证")
task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(function()
            if statusLabel and statusLabel.Parent then
                if getgenv().CardVerified then
                    statusLabel.Text = "状态: ✅ 已验证"
                else
                    statusLabel.Text = "状态: ❌ 未验证"
                end
            end
        end)
    end
end)

AnnounceSection:Label("━━━━━━━━━━━━━━━━")
AnnounceSection:Label("公告内容:")
AnnounceSection:Label("1. 本脚本永久免费")
AnnounceSection:Label("2. 禁止倒卖")
AnnounceSection:Label("3. 安全速度上限80")

-- ===== 信息Tab =====
local InfoTab = UILibrary:Tab("『信息』", "18930406865")
local InfoSection = InfoTab:section("玩家信息", true)
InfoSection:Label("用户名: " .. game.Players.LocalPlayer.Name)
InfoSection:Label("服务器ID: " .. game.GameId)
InfoSection:Label("状态: 防267已启动")

-- ===== 功能检查 =====
local function CheckCard()
    if not getgenv().CardVerified then
        Notify("⚠️ 卡密未验证", "请先在公告中验证卡密", 2)
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
                        Notify("⚠️ 超速警告", "速度超过80！已自动降速", 3)
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
    for _, obj in pairs(espObjects) do
        pcall(function() obj:Remove() end)
    end
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
            square.Visible = false
            nameText.Visible = false
            healthText.Visible = false
            distText.Visible = false
            tracer.Visible = false
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
                    else
                        square.Visible = false
                    end
                    
                    if getgenv().ShowName then
                        nameText.Visible = true
                        nameText.Position = Vector2.new(pos.X, pos.Y - height/2 - 20)
                        nameText.Text = player.Name
                    else
                        nameText.Visible = false
                    end
                    
                    if getgenv().ShowHealth then
                        healthText.Visible = true
                        healthText.Position = Vector2.new(pos.X, pos.Y + height/2 + 5)
                        healthText.Text = "❤ " .. math.floor(hum.Health)
                        healthText.Color = hum.Health > 50 and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
                    else
                        healthText.Visible = false
                    end
                    
                    if getgenv().ShowDistance then
                        distText.Visible = true
                        distText.Position = Vector2.new(pos.X, pos.Y + height/2 + 25)
                        local lpChar = lp.Character
                        local lpHRP = lpChar and lpChar:FindFirstChild("HumanoidRootPart")
                        local dist = lpHRP and (hrp.Position - lpHRP.Position).Magnitude or 0
                        distText.Text = math.floor(dist) .. "m"
                    else
                        distText.Visible = false
                    end
                    
                    if getgenv().ShowTracer then
                        tracer.Visible = true
                        tracer.From = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y)
                        tracer.To = Vector2.new(pos.X, pos.Y)
                    else
                        tracer.Visible = false
                    end
                else
                    square.Visible = false
                    nameText.Visible = false
                    healthText.Visible = false
                    distText.Visible = false
                    tracer.Visible = false
                end
            else
                square.Visible = false
                nameText.Visible = false
                healthText.Visible = false
                distText.Visible = false
                tracer.Visible = false
            end
        end)
    end)
end

for _, player in pairs(game.Players:GetPlayers()) do
    if player ~= game.Players.LocalPlayer then
        CreateESP(player)
    end
end

game.Players.PlayerAdded:Connect(function(player)
    if player ~= game.Players.LocalPlayer then
        CreateESP(player)
    end
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

-- ===== 设置Tab =====
local SettingsTab = UILibrary:Tab("『设置』", "18930406865")
local SettingsSection = SettingsTab:section("控制", true)

SettingsSection:Button("关闭脚本", function()
    getgenv().HitboxEnabled = false
    getgenv().NoClip = false
    getgenv().ESPEnabled = false
    ClearESP()
    pcall(function()
        local gui = game:GetService("CoreGui"):FindFirstChild("TopScrollText")
        if gui then gui:Destroy() end
    end)
    pcall(function()
        local frosty = game:GetService("CoreGui"):FindFirstChild("frosty")
        if frosty then frosty:Destroy() end
    end)
end)

print("✅ wdfex加载完成 - 卡密: 1")