-- ===== wdfex 圣奥里传送+飞车+绘制版 =====

-- ===== 加载UI =====
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/%E7%9A%AE%E8%84%9A%E6%9C%ACUI%E6%BA%90%E7%A0%81.lua"))():new("wdfex 圣奥里")

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

-- ===== 绘制Tab =====
local DrawTab = UILibrary:Tab("『绘制』", "18930406865")
local DrawSection = DrawTab:section("玩家头顶绘制", true)

DrawSection:Label("👁️ 在玩家头顶显示通缉状态")
DrawSection:Label("🔴 通缉中 | 🟢 未通缉 | 👮 警察")

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
    billboard.MaxDistance = 100
    
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

-- ===== 设置Tab =====
local SettingsTab = UILibrary:Tab("『设置』", "18930406865")
local SettingsSection = SettingsTab:section("控制", true)
SettingsSection:Button("关闭脚本", function()
    getgenv().DrawEnabled = false
    getgenv().CarAccelEnabled = false
    ClearDraw()
    pcall(function()
        local frosty = game:GetService("CoreGui"):FindFirstChild("frosty")
        if frosty then frosty:Destroy() end
    end)
end)

print("✅ wdfex 圣奥里传送+飞车+绘制已加载")
print("📍 20个传送点 | 🚗 飞车 | 👁️ 绘制")