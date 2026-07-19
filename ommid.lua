-- ========== 皮脚本-原版功能+过检测 ==========
-- 直接从原版提取功能代码 + 过检测

local VirtualUserService = game:GetService("VirtualUser")
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

-- ==================== 反挂机 ====================
game:GetService("Players").LocalPlayer.Idled:connect(function()
    VirtualUserService:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUserService:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- ==================== 过检测系统 ====================
local bypassActive = false
local bypassConnections = {}

local function startBypass()
    if bypassActive then return end
    bypassActive = true
    print("🛡️ 启动过检测...")

    pcall(function()
        local oldKick = player.Kick
        player.Kick = function(self, message)
            print("🛡️ 拦截踢出: " .. tostring(message))
            return nil
        end
        table.insert(bypassConnections, {Disconnect = function()
            player.Kick = oldKick
        end})
    end)

    pcall(function()
        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                local healthConn = hum.HealthChanged:Connect(function()
                    if hum.Health <= 0 then
                        task.wait(0.1)
                        if hum and hum.Parent then
                            hum.Health = hum.MaxHealth
                        end
                    end
                end)
                table.insert(bypassConnections, healthConn)
            end
        end
    end)

    pcall(function()
        local function antiTeleport()
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local lastPos = hrp.Position
                    local heartbeatConn = RunService.Heartbeat:Connect(function()
                        if not hrp or not hrp.Parent then return end
                        if (hrp.Position - lastPos).Magnitude > 100 then
                            hrp.CFrame = CFrame.new(lastPos)
                        end
                        lastPos = hrp.Position
                    end)
                    table.insert(bypassConnections, heartbeatConn)
                end
            end
        end
        antiTeleport()
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            antiTeleport()
        end)
    end)

    pcall(function()
        local behaviorConn = RunService.Heartbeat:Connect(function()
            if math.random(1, 100) > 95 then
                VirtualUserService:CaptureController()
                VirtualUserService:ClickButton2(Vector2.new())
            end
        end)
        table.insert(bypassConnections, behaviorConn)
    end)

    pcall(function()
        local TeleportService = game:GetService("TeleportService")
        local parentConn = player:GetPropertyChangedSignal("Parent"):Connect(function()
            if not player.Parent then
                print("🔄 被踢出，正在重连...")
                task.wait(2)
                TeleportService:Teleport(game.PlaceId, player)
            end
        end)
        table.insert(bypassConnections, parentConn)
    end)

    print("✅ 过检测已启动")
end)

-- ==================== UI库 ====================
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/%E7%9A%AE%E8%84%9A%E6%9C%ACUI%E6%BA%90%E7%A0%81.lua"))():new("皮脚本-过检测版")

-- ==================== 信息页 ====================
local InfoTab = UILibrary:Tab("『信息』", "18930406865")
local PlayerInfoSection = InfoTab:section("玩家信息", true)
PlayerInfoSection:Label("您的注入器:" .. identifyexecutor())
PlayerInfoSection:Label("您的用户名:" .. game.Players.LocalPlayer.Character.Name)
PlayerInfoSection:Label("您的用户ID:" .. game.Players.LocalPlayer.UserId)
PlayerInfoSection:Label("您当前服务器的ID:" .. game.GameId)
PlayerInfoSection:Label("🛡️ 过检测: 已启动")

local AuthorInfoSection = InfoTab:section("作者信息", true)
AuthorInfoSection:Label("皮脚本")
AuthorInfoSection:Label("作者: 小皮")
AuthorInfoSection:Label("作者QQ: 2131869117")

-- ==================== 通用页 ====================
local GeneralTab = UILibrary:Tab("『通用』", "18930406865")
local LocalPlayerSection = GeneralTab:section("本地玩家", true)

-- 速度
LocalPlayerSection:Slider("设置速度", "WalkSpeed", game.Players