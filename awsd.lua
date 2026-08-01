-- ===== wdfex 圣奥里暴力完整版（无爆炸功能） =====

-- ===== 加载UI =====
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/%E7%9A%AE%E8%84%9A%E6%9C%ACUI%E6%BA%90%E7%A0%81.lua"))():new("wdfex 圣奥里暴力版")

-- ===== 通知函数 =====
local function Notify(text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "wdfex",
            Text = text,
            Icon = "rbxassetid://18941716391",
            Duration = 2,
        })
    end)
end

-- ===== 传送函数 =====
local function TeleportTo(pos)
    pcall(function()
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(pos)
        end
    end)
end

-- ===== 获取最近玩家 =====
local function GetClosestPlayer()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local closest = nil
    local closestDist = math.huge
    
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player then
            local c = p.Character
            if c then
                local h = c:FindFirstChild("HumanoidRootPart")
                if h then
                    local dist = (hrp.Position - h.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = p
                    end
                end
            end
        end
    end
    return closest, closestDist
end

-- ===== 获取所有玩家 =====
local function GetAllPlayers()
    local players = {}
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer then
            table.insert(players, p)
        end
    end
    return players
end

-- ===== 传送Tab =====
local TeleportTab = UILibrary:Tab("『传送』", "18930406865")
local TeleportSection = TeleportTab:section("圣奥里传送点", true)

TeleportSection:Button("🔫 枪械商店", function()
    TeleportTo(Vector3.new(-336.86, -205.07, 61.75))
end)

TeleportSection:Button("🏴 黑色市场", function()
    TeleportTo(Vector3.new(1040.91, -22.73, 899.80))
end)

TeleportSection:Button("🏦 小银行", function()
    TeleportTo(Vector3.new(-667.74, 2.63, -67.18))
end)

TeleportSection:Button("🏛️ 大银行", function()
    TeleportTo(Vector3.new(3134.64, 6.12, -169.70))
end)

TeleportSection:Button("🌾 农场", function()
    TeleportTo(Vector3.new(-1269.56, 2.57, 2559.51))
end)

TeleportSection:Button("🚔 警察局", function()
    TeleportTo(Vector3.new(3313.52, 3.02, -476.74))
end)

TeleportSection:Button("🏥 医院", function()
    TeleportTo(Vector3.new(3892.10, 3.02, -185.78))
end)

TeleportSection:Button("🎮 游戏厅", function()
    TeleportTo(Vector3.new(2936.71, 2.63, 1688.17))
end)

TeleportSection:Button("🏪 超市", function()
    TeleportTo(Vector3.new(3936.62, 3.04, 1136.92))
end)

TeleportSection:Button("🏛️ 平民出生点", function()
    TeleportTo(Vector3.new(3741.79, 3.72, -438.95))
end)

TeleportSection:Button("🏛️ 约克镇出生点", function()
    TeleportTo(Vector3.new(-221.64, 3.04, -84.56))
end)

TeleportSection:Button("🕳️ 躲藏点", function()
    TeleportTo(Vector3.new(-1505.97, 253.98, -476.43))
end)

TeleportSection:Button("🚢 游轮码头", function()
    TeleportTo(Vector3.new(985.45, -22.53, 1274.22))
end)

TeleportSection:Button("🔧 车辆维修", function()
    TeleportTo(Vector3.new(-409.58, 3.08, 2.80))
end)

TeleportSection:Button("⛓️ 监狱", function()
    TeleportTo(Vector3.new(-1605.21, 2.63, 1223.50))
end)

TeleportSection:Button("🔩 拆车场", function()
    TeleportTo(Vector3.new(3434.49, 42.93, 2686.46))
end)

TeleportSection:Button("💼 非法交易点", function()
    TeleportTo(Vector3.new(2284.16, -16.97, 2652.88))
end)

TeleportSection:Button("📦 送货队伍", function()
    TeleportTo(Vector3.new(4402.39, 3.04, 1607.56))
end)

TeleportSection:Button("🛣️ 道路服务", function()
    TeleportTo(Vector3.new(4275.96, 2.63, 1200.88))
end)

TeleportSection:Button("🚒 消防队伍", function()
    TeleportTo(Vector3.new(3578.02, 8.15, 577.34))
end)

TeleportSection:Button("🚗 车店", function()
    TeleportTo(Vector3.new(0, 0, 0))
end)

-- ===== 自定义传送 =====
TeleportSection:Label("━━━━━━━━━━━━━━━━━━━━")
TeleportSection:Label("📌 自定义坐标传送")

TeleportSection:Textbox("X坐标", "XInput", "输入X", function(x)
    getgenv().TeleportX = tonumber(x) or 0
end)

TeleportSection:Textbox("Y坐标", "YInput", "输入Y", function(y)
    getgenv().TeleportY = tonumber(y) or 0
end)

TeleportSection:Textbox("Z坐标", "ZInput", "输入Z", function(z)
    getgenv().TeleportZ = tonumber(z) or 0
end)

TeleportSection:Button("📌 传送到输入坐标", function()
    local x = getgenv().TeleportX or 0
    local y = getgenv().TeleportY or 0
    local z = getgenv().TeleportZ or 0
    TeleportTo(Vector3.new(x, y, z))
end)

-- ===== 飞车Tab =====
local VehicleTab = UILibrary:Tab("『飞车』", "18930406865")
local VehicleSection = VehicleTab:section("飞车控制", true)

VehicleSection:Label("🚀 坐上车辆后自动加速")

getgenv().CarSpeed = 80
getgenv().CarAccelEnabled = false

local function GetCurrentVehicle()
    local char = game.Players.LocalPlayer.Character
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
end

game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().CarAccelEnabled then
        pcall(function()
            local vehicle = GetCurrentVehicle()
            if vehicle then
                local hrp = vehicle:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local bv = hrp:FindFirstChild("CarBV")
                    if not bv then
                        bv = Instance.new("BodyVelocity")
                        bv.Name = "CarBV"
                        bv.Parent = hrp
                        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                    end
                    bv.Velocity = hrp.CFrame.LookVector * getgenv().CarSpeed
                end
            end
        end)
    end
end)

VehicleSection:Toggle("开启飞车", "CarAccel", false, function(e)
    getgenv().CarAccelEnabled = e
    Notify(e and "🚗 飞车已开启" or "❌ 飞车已关闭")
end)

VehicleSection:Slider("飞车速度", "CarSpeed", 80, 20, 300, false, function(s)
    getgenv().CarSpeed = s
end)

-- ===== ATM机Tab =====
local ATMTab = UILibrary:Tab("『ATM机』", "18930406865")
local ATMSection = ATMTab:section("ATM机列表", true)

ATMSection:Label("🏧 点击按钮传送到对应ATM")
ATMSection:Label("━━━━━━━━━━━━━━━━━━━━")

local atmLocations = {}
local atmNames = {}

local function ScanATM()
    atmLocations = {}
    atmNames = {}
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Part") then
            local name = obj.Name:lower()
            if name:match("atm") and not name:match("bank") then
                local pos = nil
                if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
                    pos = obj.HumanoidRootPart.Position
                elseif obj:IsA("Part") then
                    pos = obj.Position
                end
                if pos then
                    local displayName = obj.Name:gsub("_", " "):gsub("ATM", ""):gsub("  ", " ")
                    if displayName == "" or displayName == " " then
                        displayName = "ATM #" .. (#atmLocations + 1)
                    end
                    table.insert(atmLocations, pos)
                    table.insert(atmNames, displayName)
                end
            end
        end
    end
end

ScanATM()

ATMSection:Button("🔄 刷新ATM列表", function()
    ScanATM()
    Notify("✅ 已刷新，找到 " .. #atmLocations .. " 台ATM机")
end)

local maxButtons = 20
for i = 1, maxButtons do
    local btn = ATMSection:Button("🏧 " .. (atmNames[i] or "加载中..."), function()
        if atmLocations[i] then
            TeleportTo(atmLocations[i] + Vector3.new(0, 2, 0))
            Notify("✅ 已传送到 " .. (atmNames[i] or "ATM"))
        else
            Notify("❌ 该ATM不存在，请刷新列表")
        end
    end)
    if i > #atmLocations then
        pcall(function()
            btn.Text = "---"
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            btn.TextColor3 = Color3.fromRGB(100, 100, 100)
        end)
    end
end

ATMSection:Label("━━━━━━━━━━━━━━━━━━━━")
ATMSection:Label("📌 共可显示 " .. maxButtons .. " 个ATM")

-- ===== 绘制Tab =====
local DrawTab = UILibrary:Tab("『绘制』", "18930406865")
local DrawSection = DrawTab:section("玩家头顶绘制", true)

DrawSection:Label("👁️ 在玩家头顶显示通缉状态")
DrawSection:Label("🔴 通缉中 | 🟢 未通缉 | 👮 警察")
DrawSection:Label("📏 最大显示距离: 300米")

getgenv().DrawEnabled = false
local drawObjects = {}

local function ClearDraw()
    for _, obj in pairs(drawObjects) do
        pcall(function() obj:Remove() end)
    end
    drawObjects = {}
end

local function CreatePlayerLabel(player)
    if player == game.Players.LocalPlayer then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "WantedLabel"
    billboard.Size = UDim2.new(0, 150, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 300
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 0.3
    label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 16
    label.Font = Enum.Font.GothamBold
    label.Text = "检测中..."
    label.TextScaled = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = label
    
    billboard.Parent = player.Character and player.Character:FindFirstChild("Head")
    label.Parent = billboard
    
    table.insert(drawObjects, billboard)
    
    task.spawn(function()
        while billboard and billboard.Parent and getgenv().DrawEnabled do
            pcall(function()
                local isWanted = false
                
                if player:GetAttribute("Wanted") then
                    isWanted = player:GetAttribute("Wanted")
                elseif player:GetAttribute("WantedLevel") and player:GetAttribute("WantedLevel") > 0 then
                    isWanted = true
                elseif player:GetAttribute("Bounty") and player:GetAttribute("Bounty") > 0 then
                    isWanted = true
                elseif player:GetAttribute("IsWanted") then
                    isWanted = true
                end
                
                if player.Character then
                    for _, child in pairs(player.Character:GetChildren()) do
                        if child:IsA("ObjectValue") then
                            if child.Name:lower():match("wanted") or child.Name:lower():match("bounty") then
                                isWanted = true
                            end
                        end
                    end
                end
                
                if player.Team and player.Team.Name:lower():match("police") then
                    label.Text = "👮 警察"
                    label.TextColor3 = Color3.fromRGB(0, 150, 255)
                    label.BackgroundColor3 = Color3.fromRGB(0, 0, 80)
                elseif isWanted then
                    label.Text = "🔴 通缉中"
                    label.TextColor3 = Color3.fromRGB(255, 50, 50)
                    label.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
                else
                    label.Text = "🟢 未通缉"
                    label.TextColor3 = Color3.fromRGB(50, 255, 50)
                    label.BackgroundColor3 = Color3.fromRGB(0, 50, 0)
                end
            end)
            task.wait(0.5)
        end
    end)
end

local function StartDrawing()
    ClearDraw()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            if player.Character and player.Character:FindFirstChild("Head") then
                CreatePlayerLabel(player)
            end
        end
    end
end

DrawSection:Toggle("开启头顶绘制", "DrawToggle", false, function(enabled)
    getgenv().DrawEnabled = enabled
    if enabled then
        StartDrawing()
        game.Players.PlayerAdded:Connect(function(player)
            if getgenv().DrawEnabled then
                player.CharacterAdded:Connect(function()
                    task.wait(0.5)
                    if getgenv().DrawEnabled and player.Character and player.Character:FindFirstChild("Head") then
                        CreatePlayerLabel(player)
                    end
                end)
            end
        end)
        game.Players.PlayerRemoving:Connect(function()
            if getgenv().DrawEnabled then
                task.wait(0.1)
                StartDrawing()
            end
        end)
    else
        ClearDraw()
    end
end)

DrawSection:Button("刷新绘制", function()
    if getgenv().DrawEnabled then
        StartDrawing()
        Notify("🔄 绘制已刷新")
    end
end)

-- ===== 暴力Tab（无爆炸） =====
local ViolenceTab = UILibrary:Tab("『暴力』", "18930406865")
local ViolenceSection = ViolenceTab:section("暴力功能（别人可见）", true)

ViolenceSection:Label("💀 暴力功能 | ⚠️ 使用风险自负")
ViolenceSection:Label("━━━━━━━━━━━━━━━━━━━━")

-- 1. 无限血量
ViolenceSection:Toggle("❤️ 无限血量", "GodMode", false, function(enabled)
    getgenv().GodMode = enabled
    if enabled then
        pcall(function()
            local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.MaxHealth = 999999
                hum.Health = 999999
            end
        end)
        Notify("❤️ 无限血量已开启")
    else
        Notify("❤️ 无限血量已关闭")
    end
end)

-- 2. 无限体力
ViolenceSection:Toggle("⚡ 无限体力", "InfStamina", false, function(enabled)
    getgenv().InfStamina = enabled
    if enabled then
        Notify("⚡ 无限体力已开启")
    else
        Notify("⚡ 无限体力已关闭")
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().InfStamina then
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.Stamina = 100
                end
                local stamina = char:FindFirstChild("Stamina")
                if stamina then
                    stamina.Value = 100
                end
                local energy = char:FindFirstChild("Energy")
                if energy then
                    energy.Value = 100
                end
            end
        end)
    end
end)

-- 3. 无限饥饿值
ViolenceSection:Toggle("🍔 无限饥饿值", "InfHunger", false, function(enabled)
    getgenv().InfHunger = enabled
    if enabled then
        Notify("🍔 无限饥饿值已开启")
    else
        Notify("🍔 无限饥饿值已关闭")
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().InfHunger then
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            if char then
                local hunger = char:FindFirstChild("Hunger")
                if hunger then
                    hunger.Value = 100
                end
                local food = char:FindFirstChild("Food")
                if food then
                    food.Value = 100
                end
            end
        end)
    end
end)

-- 4. 无限子弹
ViolenceSection:Toggle("🔫 无限子弹", "InfAmmo", false, function(enabled)
    getgenv().InfAmmo = enabled
    if enabled then
        Notify("🔫 无限子弹已开启")
    else
        Notify("🔫 无限子弹已关闭")
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().InfAmmo then
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            if char then
                for _, tool in pairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        local ammo = tool:FindFirstChild("Ammo") or tool:FindFirstChild("Bullets") or tool:FindFirstChild("Magazine") or tool:FindFirstChild("Ammunition")
                        if ammo then
                            ammo.Value = 999
                        end
                        local clip = tool:FindFirstChild("Clip")
                        if clip then
                            clip.Value = 999
                        end
                        local maxAmmo = tool:FindFirstChild("MaxAmmo")
                        if maxAmmo then
                            maxAmmo.Value = 999
                        end
                    end
                end
                local backpack = game.Players.LocalPlayer.Backpack
                if backpack then
                    for _, tool in pairs(backpack:GetChildren()) do
                        if tool:IsA("Tool") then
                            local ammo = tool:FindFirstChild("Ammo") or tool:FindFirstChild("Bullets") or tool:FindFirstChild("Magazine")
                            if ammo then
                                ammo.Value = 999
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- 5. 超快射速
ViolenceSection:Toggle("⚡ 超快射速", "FastFire", false, function(enabled)
    getgenv().FastFire = enabled
    if enabled then
        Notify("⚡ 超快射速已开启")
    else
        Notify("⚡ 超快射速已关闭")
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().FastFire then
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            if char then
                for _, tool in pairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        local fireRate = tool:FindFirstChild("FireRate") or tool:FindFirstChild("Rate") or tool:FindFirstChild("Cooldown")
                        if fireRate then
                            fireRate.Value = 0.01
                        end
                        local reloadTime = tool:FindFirstChild("ReloadTime") or tool:FindFirstChild("Reload")
                        if reloadTime then
                            reloadTime.Value = 0
                        end
                    end
                end
            end
        end)
    end
end)

-- 6. 甩飞最近玩家
ViolenceSection:Button("💥 甩飞最近玩家", function()
    local target, dist = GetClosestPlayer()
    if not target then
        Notify("❌ 附近没有玩家")
        return
    end
    pcall(function()
        local hrp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = Vector3.new(0, 500, 0)
            hrp.RotVelocity = Vector3.new(1000, 1000, 1000)
            Notify("💥 已甩飞 " .. target.Name)
        end
    end)
end)

-- 7. 瞬移到最近玩家身后
ViolenceSection:Button("🔪 瞬移到最近玩家身后", function()
    local target, dist = GetClosestPlayer()
    if not target then
        Notify("❌ 附近没有玩家")
        return
    end
    pcall(function()
        local myHrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local targetHrp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if myHrp and targetHrp then
            myHrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, -3)
            Notify("🔪 已瞬移到 " .. target.Name .. " 身后")
        end
    end)
end)

-- 8. 秒杀最近目标
ViolenceSection:Button("⚔️ 秒杀最近目标", function()
    local target, dist = GetClosestPlayer()
    if not target then
        Notify("❌ 附近没有目标")
        return
    end
    pcall(function()
        local hum = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Health = 0
            Notify("⚔️ 已秒杀 " .. target.Name)
        end
    end)
end)

-- 9. 全图冻结
ViolenceSection:Toggle("❄️ 全图冻结", "FreezeAll", false, function(enabled)
    getgenv().FreezeAll = enabled
    if enabled then
        Notify("❄️ 全图冻结已开启")
    else
        Notify("❄️ 全图冻结已关闭")
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().FreezeAll then
        for _, p in pairs(GetAllPlayers()) do
            pcall(function()
                local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Velocity = Vector3.new(0, 0, 0)
                    hrp.RotVelocity = Vector3.new(0, 0, 0)
                    hrp.Anchored = true
                end
                local hum = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.WalkSpeed = 0
                    hum.JumpPower = 0
                    hum.PlatformStand = true
                end
            end)
        end
    end
end)

-- 10. 全图甩飞
ViolenceSection:Button("🌀 全图甩飞", function()
    local count = 0
    for _, p in pairs(GetAllPlayers()) do
        pcall(function()
            local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Velocity = Vector3.new(math.random(-500, 500), math.random(300, 800), math.random(-500, 500))
                hrp.RotVelocity = Vector3.new(math.random(-2000, 2000), math.random(-2000, 2000), math.random(-2000, 2000))
                count = count + 1
            end
        end)
    end
    Notify("🌀 已甩飞 " .. count .. " 个玩家")
end)

-- 11. 全图传送（所有玩家到你面前）
ViolenceSection:Button("🌀 全图传送（所有玩家到你面前）", function()
    local myHrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHrp then
        Notify("❌ 没有角色")
        return
    end
    local count = 0
    for _, p in pairs(GetAllPlayers()) do
        pcall(function()
            local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = myHrp.CFrame + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5))
                count = count + 1
            end
        end)
    end
    Notify("🌀 已传送 " .. count .. " 个玩家到你面前")
end)

-- 12. 全图秒杀
ViolenceSection:Button("☠️ 全图秒杀", function()
    local count = 0
    for _, p in pairs(GetAllPlayers()) do
        pcall(function()
            local hum = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.Health = 0
                count = count + 1
            end
        end)
    end
    Notify("☠️ 已秒杀 " .. count .. " 个玩家")
end)

-- 13. 全图火焰
ViolenceSection:Button("🔥 全图火焰", function()
    for _, p in pairs(GetAllPlayers()) do
        pcall(function()
            local char = p.Character
            if char then
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        local fire = Instance.new("Fire")
                        fire.Parent = part
                        fire.Size = 10
                        fire.Heat = 20
                    end
                end
            end
        end)
    end
    Notify("🔥 所有玩家已着火")
end)

-- 14. 全图传送随机
ViolenceSection:Button("🌀 全图传送随机位置", function()
    local count = 0
    for _, p in pairs(GetAllPlayers()) do
        pcall(function()
            local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(
                    math.random(-5000, 5000),
                    math.random(50, 200),
                    math.random(-5000, 5000)
                )
                count = count + 1
            end
        end)
    end
    Notify("🌀 已随机传送 " .. count .. " 个玩家")
end)

-- 15. 全图隐身
ViolenceSection:Toggle("👻 全图隐身", "Invisible", false, function(enabled)
    getgenv().Invisible = enabled
    pcall(function()
        local char = game.Players.LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    if enabled then
                        part.Transparency = 1
                    else
                        part.Transparency = 0
                    end
                end
            end
        end
    end)
    Notify(enabled and "👻 隐身已开启" or "👻 隐身已关闭")
end)

-- 16. 全图高跳
ViolenceSection:Toggle("🦘 全图高跳", "HighJump", false, function(enabled)
    getgenv().HighJump = enabled
    if enabled then
        for _, p in pairs(GetAllPlayers()) do
            pcall(function()
                local hum = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.JumpPower = 200
                end
            end)
        end
        Notify("🦘 全图高跳已开启")
    else
        for _, p in pairs(GetAllPlayers()) do
            pcall(function()
                local hum = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.JumpPower = 50
                end
            end)
        end
        Notify("🦘 全图高跳已关闭")
    end
end)

-- 17. 全图换肤
ViolenceSection:Button("🎨 全图换肤", function()
    for _, p in pairs(GetAllPlayers()) do
        pcall(function()
            local char = p.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.BrickColor = BrickColor.new(Color3.fromHSV(math.random(), 1, 1))
                    end
                end
            end
        end)
    end
    Notify("🎨 所有玩家已变色")
end)

-- 18. 全图武器删除
ViolenceSection:Button("🗑️ 全图武器删除", function()
    local count = 0
    for _, p in pairs(GetAllPlayers()) do
        pcall(function()
            local char = p.Character
            if char then
                for _, tool in pairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        tool:Destroy()
                        count = count + 1
                    end
                end
            end
        end)
    end
    Notify("🗑️ 已删除 " .. count .. " 个武器")
end)

-- 19. 全图车辆传送
ViolenceSection:Button("🚗 全图车辆传送", function()
    local myPos = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myPos then return end
    local count = 0
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj:FindFirstChild("VehicleSeat") or obj:FindFirstChild("HumanoidRootPart")) then
            pcall(function()
                local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("VehicleSeat")
                if hrp then
                    hrp.CFrame = myPos.CFrame + Vector3.new(math.random(-20, 20), 0, math.random(-20, 20))
                    count = count + 1
                end
            end)
        end
    end
    Notify("🚗 已传送 " .. count .. " 辆车到你面前")
end)

-- 20. 全图NPC击杀
ViolenceSection:Button("🤖 全图NPC击杀", function()
    local count = 0
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                hum.Health = 0
                count = count + 1
            end
        end
    end
    Notify("🤖 已击杀 " .. count .. " 个NPC")
end)

-- 21. 锁定血量
ViolenceSection:Toggle("🔒 锁定血量", "LockHealth", false, function(enabled)
    getgenv().LockHealth = enabled
    if enabled then
        Notify("🔒 血量锁定已开启")
    else
        Notify("🔒 血量锁定已关闭")
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().LockHealth then
        pcall(function()
            local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.Health = 999999
            end
        end)
    end
end)

-- 22. 一键全部开启
ViolenceSection:Label("━━━━━━━━━━━━━━━━━━━━")
ViolenceSection:Button("⚡ 一键开启全部暴力", function()
    getgenv().GodMode = true
    getgenv().InfStamina = true
    getgenv().InfHunger = true
    getgenv().InfAmmo = true
    getgenv().FastFire = true
    getgenv().LockHealth = true
    getgenv().Invisible = true
    getgenv().HighJump = true
    pcall(function()
        local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.MaxHealth = 999999
            hum.Health = 999999
            hum.Stamina = 100
        end
        local char = game.Players.LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                end
            end
        end
    end)
    Notify("⚡ 全部暴力功能已开启")
end)

ViolenceSection:Button("🔴 一键关闭全部暴力", function()
    getgenv().GodMode = false
    getgenv().InfStamina = false
    getgenv().InfHunger = false
    getgenv().InfAmmo = false
    getgenv().FastFire = false
    getgenv().FreezeAll = false
    getgenv().LockHealth = false
    getgenv().Invisible = false
    getgenv().HighJump = false
    pcall(function()
        local char = game.Players.LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                end
            end
        end
    end)
    Notify("🔴 全部暴力功能已关闭")
end)

-- ===== 设置Tab =====
local SettingsTab = UILibrary:Tab("『设置』", "18930406865")
local SettingsSection = SettingsTab:section("控制", true)
SettingsSection:Button("关闭脚本", function()
    getgenv().DrawEnabled = false
    getgenv().CarAccelEnabled = false
    getgenv().GodMode = false
    getgenv().InfStamina = false
    getgenv().InfHunger = false
    getgenv().InfAmmo = false
    getgenv().FastFire = false
    getgenv().FreezeAll = false
    getgenv().LockHealth = false
    getgenv().Invisible = false
    getgenv().HighJump = false
    ClearDraw()
    pcall(function()
        local frosty = game:GetService("CoreGui"):FindFirstChild("frosty")
        if frosty then frosty:Destroy() end
    end)
end)

print("✅ wdfex 圣奥里暴力完整版已加载（无爆炸）")
print("📍 传送 | 🚗 飞车 | 🏧 ATM | 👁️ 绘制 | 💀 暴力")