-- ============================================
--  纯净防封壳（仅防封 + 悬浮显示）
--  执行后加载其他辅助，不会被踢
-- ============================================

local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")

print("🛡️ 纯净防封壳启动中...")

-- 1. 拦截踢出（核心）
local oldKick = player.Kick
player.Kick = function(self, msg)
    print("🛡️ 拦截踢出: " .. tostring(msg))
    return nil
end

-- 2. 防拉回
local function antiTeleport()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local lastPos = hrp.Position
    RunService.Heartbeat:Connect(function()
        if not hrp or not hrp.Parent then return end
        if (hrp.Position - lastPos).Magnitude > 150 then
            hrp.CFrame = CFrame.new(lastPos)
        end
        lastPos = hrp.Position
    end)
end
player.CharacterAdded:Connect(function() task.wait(0.5) antiTeleport() end)
antiTeleport()

-- 3. 速度伪装（保护其他辅助的加速）
local function speedBypass()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    RunService.Heartbeat:Connect(function()
        if hum and hum.Parent and hum.WalkSpeed > 50 then
            hum.WalkSpeed = 16
        end
    end)
end
player.CharacterAdded:Connect(function() task.wait(0.5) speedBypass() end)
speedBypass()

-- 4. 防AFK
player.Idled:Connect(function()
    pcall(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

-- 5. 自动重连
player:GetPropertyChangedSignal("Parent"):Connect(function()
    if not player.Parent then
        print("🔄 被踢，重连中...")
        task.wait(2)
        pcall(function() TeleportService:Teleport(game.PlaceId) end)
    end
end)

-- 6. 悬浮状态显示
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiCheatStatus"
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 100)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -50)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.fromRGB(0, 255, 100)
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "🛡️ 防封保护中"
title.TextColor3 = Color3.fromRGB(0, 255, 100)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = mainFrame

local status1 = Instance.new("TextLabel")
status1.Size = UDim2.new(1, -20, 0, 25)
status1.Position = UDim2.new(0, 10, 0, 45)
status1.BackgroundTransparency = 1
status1.Text = "✅ 踢出拦截 | 速度伪装 | 防拉回"
status1.TextColor3 = Color3.fromRGB(150, 255, 150)
status1.TextSize = 13
status1.Font = Enum.Font.Gotham
status1.TextXAlignment = Enum.TextXAlignment.Center
status1.Parent = mainFrame

local tip = Instance.new("TextLabel")
tip.Size = UDim2.new(1, -20, 0, 20)
tip.Position = UDim2.new(0, 10, 0, 75)
tip.BackgroundTransparency = 1
tip.Text = "🔄 现在可以加载其他辅助了"
tip.TextColor3 = Color3.fromRGB(200, 200, 200)
tip.TextSize = 11
tip.Font = Enum.Font.Gotham
tip.TextXAlignment = Enum.TextXAlignment.Center
tip.Parent = mainFrame

print("========================================")
print("  ✅ 纯净防封壳已启动")
print("  📌 现在可以安全加载其他辅助脚本")
print("========================================")