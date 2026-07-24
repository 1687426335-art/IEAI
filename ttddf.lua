-- ===== wdfex 完整精简版（全部功能都在） =====

-- ===== 过检测 =====
local function SanAurieBypass()
    pcall(function()
        local player = game:GetService("Players").LocalPlayer
        local rep = game:GetService("ReplicatedStorage")
        local ws = game:GetService("Workspace")
        local gui = game:GetService("CoreGui")
        local ctx = game:GetService("ScriptContext")
        local tele = game:GetService("TeleportService")
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("Script") or obj:IsA("LocalScript") then
                local n = obj.Name:lower()
                if n:match("anti") or n:match("cheat") or n:match("detect") or n:match("kick") or n:match("ban") then
                    pcall(function() obj:Destroy() end)
                end
            end
        end
        local ps = player:FindFirstChild("PlayerScripts")
        if ps then for _, c in pairs(ps:GetChildren()) do if c:IsA("Script") or c:IsA("LocalScript") then if c.Name:lower():match("anti") or c.Name:lower():match("cheat") then pcall(function() c:Destroy() end) end end end end
        player.Kick = function(self, msg) warn("拦截踢出") return false end
        player:GetPropertyChangedSignal("Parent"):Connect(function() if not player.Parent then task.wait(0.3) pcall(function() tele:Teleport(game.PlaceId, player) end) end end)
        gui.DescendantAdded:Connect(function(c) if c:IsA("ScreenGui") and (c.Name:lower():match("kick") or c.Name:lower():match("ban")) then pcall(function() c:Destroy() end) end end)
        print("过检测已启动")
    end)
end
SanAurieBypass()

-- ===== 通知 =====
local function Notify(txt, dur) dur = dur or 3 pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", {Title="wdfex", Text=txt, Icon="rbxassetid://18941716391", Duration=dur}) end) end
Notify("✅ wdfex 已加载", 2)

-- ===== 防挂机 =====
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function() vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame) wait(1) vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame) end)

-- ===== 卡密验证 =====
getgenv().CardVerified = false
getgenv()._DeviceBinds = getgenv()._DeviceBinds or {}
local ValidCards = { ["1"] = true }
local DeviceUID = pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end) or "UNKNOWN"
for card, dev in pairs(getgenv()._DeviceBinds) do if dev == DeviceUID and ValidCards[card] then getgenv().CardVerified = true Notify("✅ 设备已验证，自动登录", 2) break end end
if not getgenv().CardVerified then Notify("🔐 请验证卡密", 2) end

-- ===== 加载UI =====
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/%E7%9A%AE%E8%84%9A%E6%9C%ACUI%E6%BA%90%E7%A0%81.lua"))():new("wdfex")

-- ===== 公告Tab =====
local aTab = UILibrary:Tab("『公告』", "18930406865")
local aSec = aTab:section("🔐 卡密验证", true)
aSec:Label("━━━━━━━━━━━━━━━━━")
aSec:Label("✦ 验证卡密解锁全部功能")
aSec:Label("📱 绑定自动登录 | 🛡️ 防267")
aSec:Label("━━━━━━━━━━━━━━━━━")
aSec:Label("📱 设备: " .. string.sub(DeviceUID,1,20).."...")
aSec:Textbox("📝 输入卡密", "CardInput", "输入卡密...", function(i) getgenv()._CardInput = i end)
aSec:Button("✅ 验证并绑定", function()
    local inp = getgenv()._CardInput
    if inp and inp ~= "" then
        if ValidCards[inp] then
            if getgenv()._DeviceBinds[inp] and getgenv()._DeviceBinds[inp] ~= DeviceUID then Notify("❌ 已被其他设备绑定",3) return end
            getgenv()._DeviceBinds[inp] = DeviceUID
            getgen