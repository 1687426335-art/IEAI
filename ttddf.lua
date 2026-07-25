-- ===== wdfex 完整版（过检测 + 加速 + 范围 + 透视 + 自瞄 + 飞车 + 动作 + 绘制 + 飞天 + 子弹追踪） =====

-- ===== 1. 过检测 =====
local function SanAurieBypass()
    pcall(function()
        local player = game:GetService("Players").LocalPlayer
        local replicatedStorage = game:GetService("ReplicatedStorage")
        local coreGui = game:GetService("CoreGui")
        local teleportService = game:GetService("TeleportService")
        local scriptContext = game:GetService("ScriptContext")
        local logService = game:GetService("LogService")
        local starterGui = game:GetService("StarterGui")

        local antiKeywords = {"anticheat", "antifly", "antihack", "antikick", "antiban", "cheat", "detect", "admin", "mod", "guard", "protect", "security"}
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
                local name = obj.Name:lower()
                for _, kw in pairs(antiKeywords) do
                    if name:match(kw) then
                        pcall(function() obj:Destroy() end)
                        break
                    end
                end
            end
        end

        local ps = player:FindFirstChild("PlayerScripts")
        if ps then
            for _, child in pairs(ps:GetChildren()) do
                if child:IsA("Script") or child:IsA("LocalScript") then
                    local n = child.Name:lower()
                    if n:match("anti") or n:match("cheat") or n:match("detect") then
                        pcall(function() child:Destroy() end)
                    end
                end
            end
        end

        player.Kick = function(self, msg)
            warn("拦截踢出: " .. tostring(msg))
            task.spawn(function()
                task.wait(0.1)
                pcall(function() teleportService:Teleport(game.PlaceId, player) end)
            end)
            return false
        end

        player:GetPropertyChangedSignal("Parent"):Connect(function()
            if not player.Parent then
                warn("被踢！重连...")
                task.wait(0.05)
                pcall(function() teleportService:Teleport(game.PlaceId, player) end)
            end
        end)

        coreGui.DescendantAdded:Connect(function(child)
            if child:IsA("ScreenGui") then
                local n = child.Name:lower()
                if n:match("kick") or n:match("ban") or n:match("disconnect") then
                    pcall(function() child:Destroy() end)
                end
            end
        end)

        for _, obj in pairs(replicatedStorage:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                local n = obj.Name:lower()
                if n:match("kick") or n:match("ban") then
                    local old = obj.FireServer
                    obj.FireServer = function(self, ...)
                        local args = {...}
                        for _, arg in pairs(args) do
                            if type(arg) == "string" and (arg:lower():match("kick") or arg:lower():match("ban")) then
                                return
                            end
                        end
                        return old(self, ...)
                    end
                end
            end
        end

        scriptContext.Error:Connect(function(msg)
            if msg:find("267") or msg:lower():find("kick") or msg:lower():find("ban") then
                return
            end
        end)

        print("✅ 过检测已启动")
    end)
end
SanAurieBypass()

-- ===== 2. 防挂机 =====
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- ===== 3. 通知 =====
local function Notify(text, duration)
    duration = duration or 3
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "wdfex",
            Text = text,
            Icon = "rbxassetid://18941716391",
            Duration = duration,
        })
    end)
end
Notify("✅ wdfex 已加载", 2)

-- ===== 4. 加载UI =====
loadstring(game:HttpGet("https://pastebin.com/raw/iXGNieAz"))()
local Window = OrionLib:MakeWindow({
    Name = "wdfex",
    HidePremium = false,
    SaveConfig = true,
    IntroText = "wdfex启动",
    ConfigFolder = "wdfex"
})

-- ===== 公告Tab =====
local Tab = Window:MakeTab({
    Name = "公告",
    Icon = "rbxassetid://7734068321",
    PremiumOnly = false
})
Tab:AddParagraph("❤️wdfex脚本❤️")
Tab:AddParagraph("本脚本主要更新通用和黑洞类")
Tab:AddParagraph("阿尔宙斯注入器可能用不了")
Tab:AddParagraph("永久免费 | 禁止倒卖")

-- ===== 设置Tab =====
local Tab = Window:MakeTab({
    Name = "设置",
    Icon = "rbxassetid://7734068321",
    PremiumOnly = false
})
Tab:AddParagraph("用户名: " .. game.Players.LocalPlayer.Name)
Tab:AddParagraph("注入器: " .. (identifyexecutor and identifyexecutor() or "未知"))
Tab:AddParagraph("服务器ID: " .. game.GameId)

Tab:AddTextbox({
    Name = "跳跃高度设置",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = tonumber(Value) or 50
        end)
    end
})

Tab:AddTextbox({
    Name = "移动速度设置",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(Value) or 16
        end)
    end
})

Tab:AddTextbox({
    Name = "重力设置",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        pcall(function()
            game.Workspace.Gravity = tonumber(Value) or 196.2
        end)
    end
})

Tab:AddTextbox({
    Name = "血量设置",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.Health = tonumber(Value) or 100
        end)
    end
})

Tab:AddTextbox({
    Name = "视野设置",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        pcall(function()
            workspace.CurrentCamera.FieldOfView = tonumber(Value) or 70
        end)
    end
})

Tab:AddButton({
    Name = "重新加入服务器",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game:GetService("Players").LocalPlayer)
    end
})

Tab:AddButton({
    Name = "离开服务器",
    Callback = function()
        game:Shutdown()
    end
})

Tab:AddButton({
    Name = "帧率显示",
    Callback = function()
        local ScreenGui = Instance.new("ScreenGui")
        local FpsLabel = Instance.new("TextLabel")
        ScreenGui.Name = "FPSGui"
        ScreenGui.ResetOnSpawn = false
        FpsLabel.Size = UDim2.new(0, 100, 0, 50)
        FpsLabel.Position = UDim2.new(0, 10, 0, 10)
        FpsLabel.BackgroundTransparency = 1
        FpsLabel.Font = Enum.Font.SourceSansBold
        FpsLabel.Text = "帧率: 0"
        FpsLabel.TextSize = 20
        FpsLabel.TextColor3 = Color3.new(1, 1, 1)
        FpsLabel.Parent = ScreenGui
        function updateFpsLabel()
            local fps = math.floor(1 / game:GetService("RunService").RenderStepped:Wait())
            FpsLabel.Text = "帧率: " .. fps
        end
        game:GetService("RunService").RenderStepped:Connect(updateFpsLabel)
        ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end
})

Tab:AddButton({
    Name = "显示时间",
    Callback = function()
        local LBLG = Instance.new("ScreenGui")
        local LBL = Instance.new("TextLabel")
        LBLG.Name = "LBLG"
        LBLG.Parent = game.CoreGui
        LBLG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        LBL.Name = "LBL"
        LBL.Parent = LBLG
        LBL.BackgroundColor3 = Color3.new(1, 1, 1)
        LBL.BackgroundTransparency = 1
        LBL.BorderColor3 = Color3.new(0, 0, 0)
        LBL.Position = UDim2.new(0.75,0,0.010,0)
        LBL.Size = UDim2.new(0, 133, 0, 30)
        LBL.Font = Enum.Font.GothamSemibold
        LBL.Text = "TextLabel"
        LBL.TextColor3 = Color3.new(1, 1, 1)
        LBL.TextScaled = true
        LBL.TextWrapped = true
        LBL.Visible = true
        local FpsLabel = LBL
        local Heartbeat = game:GetService("RunService").Heartbeat
        local LastIteration, Start
        local FrameUpdateTable = { }
        function HeartbeatUpdate()
            LastIteration = tick()
            for Index = #FrameUpdateTable, 1, -1 do
                FrameUpdateTable[Index + 1] = (FrameUpdateTable[Index] >= LastIteration - 1) and FrameUpdateTable[Index] or nil
            end
            FrameUpdateTable[1] = LastIteration
            local CurrentFPS = (tick() - Start >= 1 and #FrameUpdateTable) or (#FrameUpdateTable / (tick() - Start))
            CurrentFPS = CurrentFPS - CurrentFPS % 1
            FpsLabel.Text = ("时间:"..os.date("%H").."时"..os.date("%M").."分"..os.date("%S")).."秒"
        end
        Start = tick()
        Heartbeat:Connect(HeartbeatUpdate)
    end
})

Tab:AddButton({
    Name = "重开(删除头部)",
    Callback = function()
        pcall(function()
            game.Players.LocalPlayer.Character.Head:Remove()
        end)
    end
})

-- ===== 通用1 Tab =====
local Tab = Window:MakeTab({
    Name = "通用1",
    Icon = "rbxassetid://7734068321",
    PremiumOnly = false
})

Tab:AddToggle({
    Name = "夜视",
    Default = false,
    Callback = function(Value)
        if Value then
            game.Lighting.Ambient = Color3.new(1, 1, 1)
        else
            game.Lighting.Ambient = Color3.new(0, 0, 0)
        end
    end
})

Tab:AddButton({
    Name = "透视",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/LE2hzECZ/raw"))()
    end
})

Tab:AddToggle({
    Name = "无限跳",
    Default = false,
    Callback = function(Value)
        getgenv().InfJ = Value
        game:GetService("UserInputService").JumpRequest:connect(function()
            if getgenv().InfJ == true then
                game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
        end)
    end
})

Tab:AddButton({
    Name = "穿墙(可关闭)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TtmScripter/OtherScript/main/Noclip"))()
    end
})

Tab:AddButton({
    Name = "阿尔宙斯注入器",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/chillz-workshop/main/Arceus%20X%20V3"))()
    end
})

Tab:AddButton({
    Name = "子弹追踪",
    Callback = function()
        local Camera = game:GetService("Workspace").CurrentCamera
        local Players = game:GetService("Players")
        local LocalPlayer = game:GetService("Players").LocalPlayer

        local function GetClosestPlayer()
            local ClosestPlayer = nil
            local FarthestDistance = math.huge
            for i, v in pairs(Players.GetPlayers(Players)) do
                if v ~= LocalPlayer and v.Character and v.Character.FindFirstChild(v.Character, "HumanoidRootPart") then
                    local DistanceFromPlayer = (LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    if DistanceFromPlayer < FarthestDistance then
                        FarthestDistance = DistanceFromPlayer
                        ClosestPlayer = v
                    end
                end
            end
            if ClosestPlayer then
                return ClosestPlayer
            end
        end

        local GameMetaTable = getrawmetatable(game)
        local OldGameMetaTableNamecall = GameMetaTable.__namecall
        setreadonly(GameMetaTable, false)
        GameMetaTable.__namecall = newcclosure(function(object, ...)
            local NamecallMethod = getnamecallmethod()
            local Arguments = {...}
            if tostring(NamecallMethod) == "FindPartOnRayWithIgnoreList" then
                local ClosestPlayer = GetClosestPlayer()
                if ClosestPlayer and ClosestPlayer.Character then
                    Arguments[1] = Ray.new(Camera.CFrame.Position, (ClosestPlayer.Character.Head.Position - Camera.CFrame.Position).Unit * (Camera.CFrame.Position - ClosestPlayer.Character.Head.Position).Magnitude)
                end
            end
            return OldGameMetaTableNamecall(object, unpack(Arguments))
        end)
        setreadonly(GameMetaTable, true)
    end
})

Tab:AddButton({
    Name = "飞行",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/pMyEyJN6"))()
    end
})

Tab:AddButton({
    Name = "隐身",
    Callback = function()
        loadstring(game:HttpGet('https://pastebin.com/raw/3Rnd9rHf'))()
    end
})

Tab:AddButton({
    Name = "快速旋转",
    Callback = function()
        if game.Players.LocalPlayer.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 then
            spawn(function()
                local speaker = game.Players.LocalPlayer
                local Anim = Instance.new("Animation")
                Anim.AnimationId = "rbxassetid://27432686"
                local bruh = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
                bruh:Play()
                bruh:AdjustSpeed(0)
                speaker.Character.Animate.Disabled = true
                local hi = Instance.new("Sound")
                hi.Name = "Sound"
                hi.SoundId = "http://www.roblox.com/asset/?id=8114290584"
                hi.Volume = 2
                hi.Looped = false
                hi.archivable = false
                hi.Parent = game.Workspace
                hi:Play()
                wait(1.5)
                local spinSpeed = 30
                local Spin = Instance.new("BodyAngularVelocity")
                Spin.Name = "Spinning"
                Spin.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
                Spin.MaxTorque = Vector3.new(0, math.huge, 0)
                Spin.AngularVelocity = Vector3.new(0,spinSpeed,0)
                wait(3.5)
                while speaker.Character.Humanoid.Health > 0 do
                    wait(0)
                    speaker.Character.Humanoid.HipHeight = speaker.Character.Humanoid.HipHeight + 0
                end
            end)
        else
            spawn(function()
                local speaker = game.Players.LocalPlayer
                local Anim = Instance.new("Animation")
                Anim.AnimationId = "rbxassetid://507776043"
                local bruh = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
                bruh:Play()
                bruh:AdjustSpeed(0)
                speaker.Character.Animate.Disabled = true
                local hi = Instance.new("Sound")
                hi.Name = "Sound"
                hi.SoundId = "http://www.roblox.com/asset/?id=8114290584"
                hi.Volume = 0
                hi.Looped = false
                hi.archivable = false
                hi.Parent = game.Workspace
                hi:Play()
                wait()
                local spinSpeed = 30
                local Spin = Instance.new("BodyAngularVelocity")
                Spin.Name = "Spinning"
                Spin.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
                Spin.MaxTorque = Vector3.new(0, math.huge, 0)
                Spin.AngularVelocity = Vector3.new(0,spinSpeed,0)
                wait(3.5)
                while speaker.Character.Humanoid.Health > 0 do
                    wait(0)
                    speaker.Character.Humanoid.HipHeight = speaker.Character.Humanoid.HipHeight + 0
                end
            end)
        end
    end
})

Tab:AddButton({
    Name = "锁定视角",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/gdLR5Z7X"))()
    end
})

-- ===== 通用2 Tab =====
local Tab = Window:MakeTab({
    Name = "通用2",
    Icon = "rbxassetid://7734068321",
    PremiumOnly = false
})

Tab:AddButton({
    Name = "点击传送工具",
    Callback = function()
        mouse = game.Players.LocalPlayer:GetMouse()
        tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = "[wdfex]传送工具"
        tool.Activated:connect(function()
            local pos = mouse.Hit + Vector3.new(0,2.5,0)
            pos = CFrame.new(pos.X,pos.Y,pos.Z)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos
        end)
        tool.Parent = game.Players.LocalPlayer.Backpack
    end
})

Tab:AddButton({
    Name = "飞车",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/gNqZiexm"))()
    end
})

Tab:AddButton({
    Name = "动作(按,开启)",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/ws8cJmTD"))()
    end
})

Tab:AddButton({
    Name = "爬墙",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/zXk4Rq2r"))()
    end
})

Tab:AddButton({
    Name = "键盘",
    Callback = function()
        loadstring(game:HttpGet("https://gist.githubusercontent.com/RedZenXYZ/4d80bfd70ee27000660e4bfa7509c667/raw/da903c570249ab3c0c1a74f3467260972c3d87e6/KeyBoard%2520From%2520Ohio%2520Fr%2520Fr"))()
    end
})

Tab:AddButton({
    Name = "工具包",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Bebo-Mods/BeboScripts/main/StandAwekening.lua"))()
    end
})

Tab:AddButton({
    Name = "Dex",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/renlua/Script-Tutorial/refs/heads/main/dex.lua"))()
    end
})

Tab:AddToggle({
    Name = "隐身",
    Default = false,
    Callback = function(Value)
        local localPlayer = game.Players.LocalPlayer
        for _, child in pairs((localPlayer.Character or localPlayer.CharacterAdded:Wait()):GetChildren()) do
            local isBasePart = child:IsA("BasePart")
            if isBasePart then
                if Value then
                    child.Transparency = 1
                    child.CanCollide = false
                else
                    child.Transparency = 0
                    child.CanCollide = true
                end
            elseif child:IsA("Accessory") then
                local handle = child.Handle
                if Value then
                    handle.Transparency = 1
                else
                    handle.Transparency = 0
                end
            end
        end
    end
})

Tab:AddButton({
    Name = "自杀",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.Health = 0
    end
})

Tab:AddButton({
    Name = "重新加入游戏",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/XXabqNiv/raw"))()
    end
})

Tab:AddButton({
    Name = "保存游戏",
    Callback = function()
        saveinstance()
    end
})

-- ===== 范围Tab =====
local Tab = Window:MakeTab({
    Name = "范围",
    Icon = "rbxassetid://7734068321",
    PremiumOnly = false
})

Tab:AddButton({
    Name = "0范围",
    Callback = function()
        _G.HeadSize = 0
        _G.Disabled = true
        game:GetService('RunService').RenderStepped:connect(function()
            if _G.Disabled then
                for i,v in next, game:GetService('Players'):GetPlayers() do
                    if v.Name ~= game:GetService('Players').LocalPlayer.Name then
                        pcall(function()
                            v.Character.HumanoidRootPart.Size = Vector3.new(_G.HeadSize,_G.HeadSize,_G.HeadSize)
                            v.Character.HumanoidRootPart.Transparency = 0.7
                            v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really red")
                            v.Character.HumanoidRootPart.Material = "Neon"
                            v.Character.HumanoidRootPart.CanCollide = false
                        end)
                    end
                end
            end
        end)
    end
})

Tab:AddButton({
    Name = "普通范围",
    Callback = function()
        _G.HeadSize = 30
        _G.Disabled = true
        game:GetService('RunService').RenderStepped:connect(function()
            if _G.Disabled then
                for i,v in next, game:GetService('Players'):GetPlayers() do
                    if v.Name ~= game:GetService('Players').LocalPlayer.Name then
                        pcall(function()
                            v.Character.HumanoidRootPart.Size = Vector3.new(_G.HeadSize,_G.HeadSize,_G.HeadSize)
                            v.Character.HumanoidRootPart.Transparency = 0.7
                            v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really red")
                            v.Character.HumanoidRootPart.Material = "Neon"
                            v.Character.HumanoidRootPart.CanCollide = false
                        end)
                    end
                end
            end
        end)
    end
})

Tab:AddButton({
    Name = "中等范围",
    Callback = function()
        _G.HeadSize = 100
        _G.Disabled = true
        game:GetService('RunService').RenderStepped:connect(function()
            if _G.Disabled then
                for i,v in next, game:GetService('Players'):GetPlayers() do
                    if v.Name ~= game:GetService('Players').LocalPlayer.Name then
                        pcall(function()
                            v.Character.HumanoidRootPart.Size = Vector3.new(_G.HeadSize,_G.HeadSize,_G.HeadSize)
                            v.Character.HumanoidRootPart.Transparency = 0.7
                            v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really red")
                            v.Character.HumanoidRootPart.Material = "Neon"
                            v.Character.HumanoidRootPart.CanCollide = false
                        end)
                    end
                end
            end
        end)
    end
})

Tab:AddButton({
    Name = "全图范围",
    Callback = function()
        _G.HeadSize = 500
        _G.Disabled = true
        game:GetService('RunService').RenderStepped:connect(function()
            if _G.Disabled then
                for i,v in next, game:GetService('Players'):GetPlayers() do
                    if v.Name ~= game:GetService('Players').LocalPlayer.Name then
                        pcall(function()
                            v.Character.HumanoidRootPart.Size = Vector3.new(_G.HeadSize,_G.HeadSize,_G.HeadSize)
                            v.Character.HumanoidRootPart.Transparency = 0.7
                            v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really red")
                            v.Character.HumanoidRootPart.Material = "Neon"
                            v.Character.HumanoidRootPart.CanCollide = false
                        end)
                    end
                end
            end
        end)
    end
})

Tab:AddButton({
    Name = "终极范围",
    Callback = function()
        _G.HeadSize = 2500
        _G.Disabled = true
        game:GetService('RunService').RenderStepped:connect(function()
            if _G.Disabled then
                for i,v in next, game:GetService('Players'):GetPlayers() do
                    if v.Name ~= game:GetService('Players').LocalPlayer.Name then
                        pcall(function()
                            v.Character.HumanoidRootPart.Size = Vector3.new(_G.HeadSize,_G.HeadSize,_G.HeadSize)
                            v.Character.HumanoidRootPart.Transparency = 0.7
                            v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really red")
                            v.Character.HumanoidRootPart.Material = "Neon"
                            v.Character.HumanoidRootPart.CanCollide = false
                        end)
                    end
                end
            end
        end)
    end
})

-- ===== 自瞄Tab =====
local Tab = Window:MakeTab({
    Name = "自瞄",
    Icon = "rbxassetid://7734068321",
    PremiumOnly = false
})

Tab:AddButton({
    Name = "圈圈自瞄",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/YnfF3sje/raw"))()
    end
})

Tab:AddButton({
    Name = "自瞄",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/tYuVRD8r"))()
    end
})

-- ===== 绘制Tab =====
local Tab = Window:MakeTab({
    Name = "绘制",
    Icon = "rbxassetid://7734068321",
    PremiumOnly = false
})

Tab:AddButton({
    Name = "透视绘制",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasfin000/SpaceHub/main/UESP"))()
    end
})

Tab:AddButton({
    Name = "人物绘制",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/pmgp7mdm"))()
    end
})

print("✅ wdfex 加载完成")
print("🛡️ 防267已启动")