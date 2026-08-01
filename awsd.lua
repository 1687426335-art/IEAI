-- ===== wdfex 圣奥里完整版（修复卡顿+ATM传送+绘制） =====

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

-- ===== 查找最近ATM（修复：排除大银行，只找真正的ATM机） =====
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
            -- 只匹配真正的ATM机，排除银行建筑
            if name:match("atm") and not name:match("bank") then
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

-- ===== 查找所有ATM（修复：排除大银行） =====
local function FindAllATM()
    local atms = {}
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
    TeleportTo(Vector3.new(3313.