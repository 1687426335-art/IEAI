-- ===== wdfex 完整版（传送 + ATM + 车辆 + 绘制） =====

-- ===== 加载UI =====
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/%E7%9A%AE%E8%84%9A%E6%9C%ACUI%E6%BA%90%E7%A0%81.lua"))():new("wdfex 圣奥里")

-- ===== 通知函数 =====
local function Notify(text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "wdfex",
            Text = text,
            Icon = "rbxassetid://18941716391",
            Duration = 3,
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

-- ===== 查找最近ATM =====
local function FindNearestATM()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return nil, nil, nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, nil, nil end
    
    local nearestATM = nil
    local nearestDist = math.huge
    local nearestPos = nil
    
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Part") then
            local name = obj.Name:lower()
            if name:match("atm") or name:match("bank") or name:match("cash") or name:match("money") then
                local pos = nil
                if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
                    pos = obj.HumanoidRootPart.Position
                elseif obj:IsA("Part") then
                    pos = obj.Position
                end
                if pos then
                    local dist = (hrp.Position - pos).Magnitude
                    if dist < nearestDist then
                        nearestDist = dist
                        nearestATM = obj
                        nearestPos = pos
                    end
                end
            end
        end
    end
    return nearestATM, nearestDist, nearestPos
end

-- ===== 查找所有ATM =====
local function FindAllATM()
    local atms = {}
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Part") then
            local name = obj.Name:lower()
            if name:match("atm") or name:match("bank") or name:match("cash") or name:match("money") then
                local pos = nil
                if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
                    pos = obj.HumanoidRootPart.Position
                elseif obj:IsA("Part") then
                    pos = obj.Position
                end
                if pos then
                    table.insert(atms, {Object = obj, Position = pos})
                end
            end
        end
    end
    return atms
end

-- ===== 查找最近车辆 =====
local function FindNearestVehicle()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return nil, nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, nil end
    
    local nearestVehicle = nil
    local nearestDist = math.huge
    
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local seat = obj:FindFirstChild("VehicleSeat")
            local hrp2 = obj:FindFirstChild("HumanoidRootPart")
            if seat or hrp2 then
                local pos = hrp2 and hrp2.Position or seat and seat.Position
                if pos then
                    local dist = (hrp.Position - pos).Magnitude
                    if dist < nearestDist and dist > 0.5 then
                        nearestDist = dist
                        nearestVehicle = obj
                    end
                end
            end
        end
    end
    return nearestVehicle, nearestDist
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

-- ===== ATM机Tab =====
local ATMTab = UILibrary:Tab("『ATM机』", "18930406865")
local ATMSection = ATMTab:section("ATM机控制", true)

ATMSection:Label("🏧 ATM机管理")
ATMSection:Label("━━━━━━━━━━━━━━━━━━━━")

ATMSection:Button("📍 传送到最近ATM", function()
    local atm, dist, pos = FindNearestATM()
    if atm and pos then
        TeleportTo(pos + Vector3.new(0, 2, 0))
        Notify("✅ 已传送到ATM (距离" .. math.floor(dist) .. "m)")
    else
        Notify("❌ 未找到ATM机")
    end
end)

ATMSection:Button("🔍 查找ATM机数量", function()
    local atms = FindAllATM()
    Notify("📊 找到 " .. #atms .. " 台ATM机")
end)

local distanceLabel = ATMSection:Label("最近ATM距离: 未检测")
task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            if distanceLabel and distanceLabel.Parent then
                local atm, dist, pos = FindNearestATM()
                if atm and pos then
                    distanceLabel.Text = "最近ATM距离: " .. math.floor(dist) .. "m"
                else
                    distanceLabel.Text = "最近ATM距离: 未找到"
                end
            end
        end)
    end
end)

ATMSection:Label("━━━━━━━━━━━━━━━━━━━━")

-- ATM绘制
getgenv().ATMDrawEnabled = false
local atmDrawObjects = {}

local function ClearATMDraw()
    for _, obj in pairs(atmDrawObjects) do
        pcall(function() obj:Remove() end)
    end
    atmDrawObjects = {}
end

local function DrawAllATM()
    ClearATMDraw()
    if not getgenv().ATMDrawEnabled then return end
    local atms = FindAllATM()
    for _, atmData in pairs(atms) do
        local obj = atmData.Object
        pcall(function()
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "ATMMarker"
            billboard.Size = UDim2.new(0, 120, 0, 30)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = obj
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 0.4
            label.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextSize = 14
            label.Font = Enum.Font.GothamBold
            label.Text = "🏧 ATM"
            label.TextScaled = true
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 4)
            corner.Parent = label
            label.Parent = billboard
            table.insert(atmDrawObjects, billboard)
        end)
    end
end

ATMSection:Toggle("显示ATM机位置", "ATMDraw", false, function(enabled)
    getgenv().ATMDrawEnabled = enabled
    if enabled then
        DrawAllATM()
        game.Workspace.DescendantAdded:Connect(function()
            if getgenv().ATMDrawEnabled then
                task.wait(0.5)
                DrawAllATM()
            end
        end)
    else
        ClearATMDraw()
    end
end)

ATMSection:Button("🔄 刷新ATM标记", function()
    if getgenv().ATMDrawEnabled then
        DrawAllATM()
        Notify("✅ ATM标记已刷新")
    end
end)

ATMSection:Label("━━━━━━━━━━━━━━━━━━━━")

-- 自动抢劫ATM
getgenv().AutoRobATM = false
local atmRobConnection = nil

local function FindATMProximityPrompt(atm)
    if not atm then return nil end
    for _, child in pairs(atm:GetDescendants()) do
        if child:IsA("ProximityPrompt") then
            local name = child.Name:lower()
            if name:match("atm") or name:match("bank") or name:match("cash") or name:match("rob") or name:match("hack") then
                return child
            end
        end
    end
    return nil
end

local function FindATMClickDetector(atm)
    if not atm then return nil end
    for _, child in pairs(atm:GetDescendants()) do
        if child:IsA("ClickDetector") then
            return child
        end
    end
    return nil
end

local function AutoRobATM()
    if not getgenv().AutoRobATM then return end
    pcall(function()
        local player = game.Players.LocalPlayer
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local atm, dist, pos = FindNearestATM()
        if not atm or not pos then return end
        if dist > 15 then
            hrp.CFrame = CFrame.new(pos + Vector3.new(0, 2, 0))
            task.wait(0.3)
        end
        local prompt = FindATMProximityPrompt(atm)
        if prompt then
            fireproximityprompt(prompt, 0)
            return
        end
        local clicker = FindATMClickDetector(atm)
        if clicker then
            fireclickdetector(clicker)
            return
        end
        local remote = atm:FindFirstChild("RemoteEvent") or atm:FindFirstChild("ATMEvent")
        if remote then
            pcall(function() remote:FireServer() end)
            return
        end
        task.spawn(function()
            local VirtualInput = game:GetService("VirtualInputManager")
            VirtualInput:SendKeyEvent(true, "E", false, game)
            task.wait(0.1)
            VirtualInput:SendKeyEvent(false, "E", false, game)
        end)
    end)
end

ATMSection:Toggle("自动抢劫ATM", "AutoRobATM", false, function(enabled)
    getgenv().AutoRobATM = enabled
    if enabled then
        if atmRobConnection then
            atmRobConnection:Disconnect()
            atmRobConnection = nil
        end
        atmRobConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if getgenv().AutoRobATM then
                AutoRobATM()
            end
        end)
        Notify("🏧 自动抢劫ATM已开启")
    else
        if atmRobConnection then
            atmRobConnection:Disconnect()
            atmRobConnection = nil
        end
        Notify("❌ 自动抢劫ATM已关闭")
    end
end)

ATMSection:Button("⚡ 一键操作ATM (传送+抢劫)", function()
    local atm, dist, pos = FindNearestATM()
    if not atm or not pos then
        Notify("❌ 未找到ATM机")
        return
    end
    TeleportTo(pos + Vector3.new(0, 2, 0))
    task.wait(0.5)
    local prompt = FindATMProximityPrompt(atm)
    if prompt then
        fireproximityprompt(prompt, 0)
        Notify("✅ 已破解ATM")
    else
        local clicker = FindATMClickDetector(atm)
        if clicker then
            fireclickdetector(clicker)
            Notify("✅ 已破解ATM")
        else
            Notify("⚠️ 无法破解该ATM")
        end
    end
end)

-- ===== 车辆Tab =====
local VehicleTab = UILibrary:Tab("『车辆』", "18930406865")
local VehicleSection = VehicleTab:section("车辆控制", true)

VehicleSection:Label("🚗 车辆管理")
VehicleSection:Label("━━━━━━━━━━━━━━━━━━━━")

-- 飞车（坐上车辆后自动加速）
VehicleSection:Label("🚀 飞车加速")
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

VehicleSection:Label("━━━━━━━━━━━━━━━━━━━━")

-- 自动偷车（不循环，点一次偷一次）
VehicleSection:Label("🔑 自动偷车")
VehicleSection:Label("点击按钮自动偷取最近的车辆")

local function FindVehicleInteract(vehicle)
    if not vehicle then return nil, nil end
    for _, child in pairs(vehicle:GetDescendants()) do
        if child:IsA("ProximityPrompt") then
            local name = child.Name:lower()
            if name:match("enter") or name:match("drive") or name:match("steal") or name:match("car") or name:match("vehicle") or name:match("get in") then
                return child, "prompt"
            end
        end
        if child:IsA("ClickDetector") then
            return child, "click"
        end
    end
    local seat = vehicle:FindFirstChild("VehicleSeat")
    if seat then
        return seat, "seat"
    end
    return nil, nil
end

VehicleSection:Button("🚗 自动偷车", function()
    pcall(function()
        local player = game.Players.LocalPlayer
        local char = player.Character
        if not char then
            Notify("❌ 没有角色")
            return
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            Notify("❌ 找不到角色位置")
            return
        end
        
        local vehicle, dist = FindNearestVehicle()
        if not vehicle then
            Notify("❌ 附近没有车辆")
            return
        end
        
        -- 传送到车辆旁边
        local seat = vehicle:FindFirstChild("VehicleSeat")
        local hrp2 = vehicle:FindFirstChild("HumanoidRootPart")
        local targetPos = hrp2 and hrp2.Position or seat and seat.Position
        if targetPos then
            hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 2))
            task.wait(0.3)
        end
        
        -- 查找交互
        local interact, type = FindVehicleInteract(vehicle)
        
        if interact and type == "prompt" then
            fireproximityprompt(interact, 0)
            Notify("✅ 已偷车 (ProximityPrompt)")
            return
        end
        
        if interact and type == "click" then
            fireclickdetector(interact)
            Notify("✅ 已偷车 (ClickDetector)")
            return
        end
        
        if interact and type == "seat" then
            -- 直接坐到座位上
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and interact then
                hum.Sit = true
                hum.SeatPart = interact
                Notify("✅ 已上车")
            end
            return
        end
        
        -- 尝试按E键
        task.spawn(function()
            local VirtualInput = game:GetService("VirtualInputManager")
            VirtualInput:SendKeyEvent(true, "E", false, game)
            task.wait(0.1)
            VirtualInput:SendKeyEvent(false, "E", false, game)
        end)
        Notify("⚠️ 已尝试按E键")
    end)
end)

VehicleSection:Button("🔍 查找附近车辆", function()
    local vehicle, dist = FindNearestVehicle()
    if vehicle then
        Notify("🚗 找到车辆，距离 " .. math.floor(dist) .. "m")
    else
        Notify("❌ 附近没有车辆")
    end
end)

-- ===== 设置Tab =====
local SettingsTab = UILibrary:Tab("『设置』", "18930406865")
local SettingsSection = SettingsTab:section("控制", true)
SettingsSection:Button("关闭脚本", function()
    getgenv().ATMDrawEnabled = false
    getgenv().AutoRobATM = false
    getgenv().CarAccelEnabled = false
    if atmRobConnection then
        atmRobConnection:Disconnect()
        atmRobConnection = nil
    end
    ClearATMDraw()
    pcall(function()
        local frosty = game:GetService("CoreGui"):FindFirstChild("frosty")
        if frosty then frosty:Destroy() end
    end)
end)

print("✅ wdfex 圣奥里完整版已加载")
print("📍 传送 | 🏧 ATM | 🚗 车辆 | 🎨 绘制")