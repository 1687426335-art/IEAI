local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")

print("🛡️ 防封已启动（无悬浮窗版）")

-- 在聊天框提示
local function sendChat(msg)
    pcall(function()
        local chat = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
        if chat then
            local send = chat:FindFirstChild("SayMessageRequest")
            if send then
                send:FireServer(msg, "All")
            end
        end
    end)
end
task.wait(2)
sendChat("🛡️ 防封已开启 | 可安全加载其他辅助")

-- 拦截踢出
player.Kick = function(self, msg)
    print("拦截踢出: " .. tostring(msg))
    sendChat("🛡️ 已拦截踢出: " .. tostring(msg))
    return nil
end

-- 防拉回
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

-- 速度伪装
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

-- 防AFK
player.Idled:Connect(function()
    pcall(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

-- 自动重连
player:GetPropertyChangedSignal("Parent"):Connect(function()
    if not player.Parent then
        print("重连中...")
        task.wait(2)
        pcall(function() TeleportService:Teleport(game.PlaceId) end)
    end
end)

print("========================================")
print("  ✅ 防封已启动（无悬浮窗）")
print("  📌 现在可以安全加载其他辅助了")
print("========================================")
sendChat("✅ 防封生效中 | 可加载其他辅助脚本")