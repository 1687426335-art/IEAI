local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()
local Confirmed = false

local gradientColors = {
    "rgb(255, 230, 235)",
    "rgb(255, 210, 220)",
    "rgb(255, 190, 205)",
    "rgb(255, 170, 190)",
    "rgb(255, 150, 175)",
    "rgb(245, 140, 180)",
    "rgb(235, 130, 185)",
    "rgb(225, 120, 190)",
    "rgb(215, 110, 195)",
    "rgb(205, 100, 200)"
}

local username = game.Players.LocalPlayer.Name
local coloredUsername = ""
for i = 1, #username do
    local colorIndex = (i - 1) % #gradientColors + 1
    coloredUsername = coloredUsername .. '<font color="' .. gradientColors[colorIndex] .. '">' .. username:sub(i, i) .. '</font>'
end

local version = "v3.0"
local coloredVersion = ""
for i = 1, #version do
    local colorIndex = (i - 1) % #gradientColors + 1
    coloredVersion = coloredVersion .. '<font color="' .. gradientColors[colorIndex] .. '">' .. version:sub(i, i) .. '</font>'
end

WindUI:Popup({
    Title = '<font color="' .. gradientColors[1] .. '">SX</font><font color="' .. gradientColors[5] .. '">HUB</font>',
    IconThemed = true,
    Icon = "crown",
    Content = "欢迎尊重的用户 " .. coloredUsername .. " \n使用SX HUB\n你的支持是我们更新的动力\nQQ主群566257944",
    Buttons = {
        {
            Title = "取消",
            Callback = function() end,
            Variant = "Secondary",
        },
        {
            Title = "执行",
            Icon = "arrow-right",
            Callback = function() 
                Confirmed = true
                createUI()
            end,
            Variant = "Primary",
        }
    }
})

function createUI()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local player = LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local isDestroyed = false
    local connections = {}

    -- ==================== 主UI ====================
    local Window = WindUI:CreateWindow({
        Title = 'SX HUB',
        Icon = "crown",
        IconThemed = true,
        Author = "v3.0.1 by 神青",
        Folder = "CloudHub",
        Size = UDim2.fromOffset(580, 440),
        Transparent = true,
        Theme = "Dark",
        HideSearchBar = false,
        ScrollBarEnabled = true,
        Resizable = true,
        Background = "https://raw.githubusercontent.com/SQ182/y/c713ef1eeed1dc6b50e547dcbfee45034c385bf9/image_download_1768053890832.jpg",
        BackgroundImageTransparency = 0.5,
        User = {
            Enabled = true,
            Callback = function()
                WindUI:Notify({
                    Title = "点击了自己",
                    Content = "没什么", 
                    Duration = 1,
                    Icon = "4483362748"
                })
            end,
            Anonymous = false
        },
        SideBarWidth = 250,
        Search = {
            Enabled = true,
            Placeholder = "搜索...",
            Callback = function(searchText)
                print("搜索内容:", searchText)
            end
        },
        SidePanel = {
            Enabled = true,
            Content = {
                {
                    Type = "Button", 
                    Text = "SX HUB",
                    Style = "Subtle", 
                    Size = UDim2.new(1, -20, 0, 30),
                    Callback = function()
                    end
                }
            }
        }
    })

    -- ===== 悬浮窗 =====
    Window:EditOpenButton({
        Title = "SX HUB",
        Icon = "crown",
        CornerRadius = UDim.new(0,16),
        StrokeThickness = 4,
        Color = ColorSequence.new(Color3.fromHex("FF6B6B")),
        Draggable = true,
    })

    Window:Tag({
        Title = "SX HUB",
        Color = Color3.fromHex("#00008B") 
    })

    Window:Tag({
        Title = "3.0.1",
        Color = Color3.fromHex("#32CD32")
    })

    Window:EditOpenButton({
        Title = "SX HUB",
        Icon = "heart",
        CornerRadius = UDim.new(0,16),
        StrokeThickness = 4,
        Color = ColorSequence.new(Color3.fromHex("FF6B6B")),
        Draggable = true,
    })

    -- 彩虹动画
    spawn(function()
        while true do
            for hue = 0, 1, 0.01 do  
                local color = Color3.fromHSV(hue, 0.8, 1)  
                Window:EditOpenButton({
                    Color = ColorSequence.new(color)
                })
                wait(0.04)  
            end
        end
    end)

    -- ===== 播放音乐（悬浮窗出来后播放7秒） =====
    task.spawn(function()
        pcall(function()
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://80701295792893"
            sound.Volume = 0.5
            sound.Parent = player:WaitForChild("PlayerGui")
            sound:Play()
            task.wait(7)
            sound:Stop()
            sound:Destroy()
        end)
    end)

    -- ============================================================
    -- Tab 创建
    -- ============================================================
    local infoTab = Window:Tab({Title = "通知", Icon = "layout-grid", Locked = false})
    local infoSection = infoTab:Section({Title = "详情信息",Icon = "info", Opened = true})
    infoSection:Divider()
    infoSection:Paragraph({
        Title = "您当前的服务器为",
        Desc = "正在寻求\n欢迎使用此脚本",
        ThumbnailSize = 190,
    })
    infoSection:Paragraph({
        Title = "持续更新，有bug请提出来",
        ThumbnailSize = 190,
    })
    local infoSection = infoTab:Section({Title = "更新",Icon = "info", Opened = true})
    infoSection:Paragraph({
        Title = "脚本已稳定发布",
        ThumbnailSize = 190,
    })
    infoSection:Paragraph({
        Title = "已经更新了愤怒机器人",
        ThumbnailSize = 190,
    })
    infoSection:Paragraph({
        Title = "更新自动抢银行",
        ThumbnailSize = 190,
    })

    -- ============================================================
    -- 人物功能 Tab（飞行 + 速度）
    -- ============================================================
    local FlightControl = Window:Tab({Title = "人物功能", Icon = "gift"})
    local FlyingEnabled = false
    local SpinningEnabled = false
    local FlightSpeed = 50
    local SpinSpeed = 5
    local CurrentAO, CurrentLV, CurrentMoverAttachment
    local FlightConnection
    local Control = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local LastControl = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}

    local function getControlModule()
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local PlayerModule = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")
        return require(PlayerModule:WaitForChild("ControlModule"))
    end

    local function setupBodyMovers(character)
        local hrp = character:WaitForChild("HumanoidRootPart")
        local humanoid = character:WaitForChild("Humanoid")
        local moverParent = workspace:FindFirstChildOfClass("Terrain") or workspace
        local moverAttachment = Instance.new("Attachment", hrp)
        moverAttachment.Name = "FlightAttachment"
        local alignOrientation = Instance.new('AlignOrientation')
        alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
        alignOrientation.RigidityEnabled = true
        alignOrientation.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        alignOrientation.CFrame = hrp.CFrame
        alignOrientation.Attachment0 = moverAttachment
        alignOrientation.Parent = moverParent
        local linearVelocity = Instance.new('LinearVelocity')
        linearVelocity.VectorVelocity = Vector3.new(0, 0, 0)
        linearVelocity.MaxForce = 9e9
        linearVelocity.Attachment0 = moverAttachment
        linearVelocity.Parent = moverParent
        return alignOrientation, linearVelocity, humanoid, moverAttachment
    end

    local function getFlightVector(controlModule)
        local moveVector = controlModule:GetMoveVector()
        local camera = workspace.CurrentCamera
        Control.F = -moveVector.Z
        Control.B = moveVector.Z
        Control.L = -moveVector.X
        Control.R = moveVector.X
        Control.Q = moveVector.Y
        Control.E = -moveVector.Y
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then Control.F = 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then Control.B = 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then Control.L = 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then Control.R = 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then Control.Q = 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then Control.E = 1 end
        local flightVector = (camera.CFrame.LookVector * (Control.F - Control.B) +
            camera.CFrame.RightVector * (Control.R - Control.L) +
            Vector3.new(0, 1, 0) * (Control.Q - Control.E))
        return flightVector.Magnitude > 0 and flightVector.Unit or flightVector
    end

    local function startFlying()
        if FlyingEnabled then return end
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        if not character then
            WindUI:Notify({ Title = "飞行失败", Content = "无法获取角色", Duration = 2, Icon = "x" })
            return
        end
        FlyingEnabled = true
        SpinningEnabled = false
        if CurrentAO then CurrentAO:Destroy() end
        if CurrentLV then CurrentLV:Destroy() end
        if CurrentMoverAttachment then CurrentMoverAttachment:Destroy() end
        CurrentAO, CurrentLV, humanoid, CurrentMoverAttachment = setupBodyMovers(character)
        WindUI:Notify({ Title = "飞行开启", Content = "速度: " .. FlightSpeed, Duration = 2, Icon = "check" })
        local controlModule = getControlModule()
        FlightConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not FlyingEnabled or not CurrentLV or not CurrentAO then
                if FlightConnection then
                    FlightConnection:Disconnect()
                    FlightConnection = nil
                end
                return
            end
            local flightVector = getFlightVector(controlModule)
            if flightVector.Magnitude > 0 then
                CurrentLV.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
                CurrentLV.VectorVelocity = flightVector * FlightSpeed
            else
                CurrentLV.VectorVelocity = Vector3.new(0, 0, 0)
            end
            if SpinningEnabled then
                local targetPart = character.Humanoid.SeatPart or character.HumanoidRootPart
                local spinCFrame = targetPart.CFrame * CFrame.Angles(0, math.rad(SpinSpeed), 0)
                CurrentAO.CFrame = spinCFrame
            else
                CurrentAO.CFrame = workspace.CurrentCamera.CFrame
            end
            if character.HumanoidRootPart then
                character.Humanoid.PlatformStand = true
            end
        end)
        character.AncestryChanged:Connect(function(_, parent)
            if not parent and FlyingEnabled then
                stopFlying()
            end
        end)
    end

    local function stopFlying()
        if not FlyingEnabled then return end
        FlyingEnabled = false
        SpinningEnabled = false
        Control = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
        LastControl = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
        if FlightConnection then
            FlightConnection:Disconnect()
            FlightConnection = nil
        end
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.PlatformStand = false
        end
        if CurrentAO then
            CurrentAO:Destroy()
            CurrentAO = nil
        end
        if CurrentLV then
            CurrentLV:Destroy()
            CurrentLV = nil
        end
        if CurrentMoverAttachment then
            CurrentMoverAttachment:Destroy()
            CurrentMoverAttachment = nil
        end
        WindUI:Notify({ Title = "飞行关闭", Content = "飞行功能已禁用", Duration = 2, Icon = "x" })
    end

    local function toggleSpinning()
        if not FlyingEnabled then
            WindUI:Notify({ Title = "提示", Content = "请先开启飞行功能", Duration = 2, Icon = "info" })
            return
        end
        SpinningEnabled = not SpinningEnabled
        if SpinningEnabled then
            WindUI:Notify({ Title = "旋转开启", Content = "旋转速度: " .. SpinSpeed, Duration = 2, Icon = "refresh-cw" })
        else
            WindUI:Notify({ Title = "旋转关闭", Content = "旋转功能已禁用", Duration = 2, Icon = "x" })
        end
    end

    FlightControl:Toggle({
        Title = "飞行模式",
        Default = FlyingEnabled,
        Callback = function(v)
            if v then startFlying() else stopFlying() end
        end
    })
    FlightControl:Toggle({
        Title = "旋转模式",
        Default = SpinningEnabled,
        Callback = function(v)
            if v then SpinningEnabled = true else SpinningEnabled = false end
        end
    })
    FlightControl:Slider({
        Title = "飞行速度",
        Value = { Min = 1, Max = 200, Default = 50 },
        Callback = function(value)
            FlightSpeed = value
            if FlyingEnabled then
                WindUI:Notify({ Title = "速度已更新", Content = "飞行速度: " .. value, Duration = 1, Icon = "zap" })
            end
        end
    })
    FlightControl:Slider({
        Title = "旋转速度",
        Value = { Min = 1, Max = 50, Default = 5 },
        Callback = function(value)
            SpinSpeed = value
            if SpinningEnabled then
                WindUI:Notify({ Title = "旋转速度已更新", Content = "旋转速度: " .. value, Duration = 1, Icon = "refresh-cw" })
            end
        end
    })

    LocalPlayer.CharacterAdded:Connect(function()
        if FlyingEnabled then
            task.wait(0.5)
            stopFlying()
            task.wait(0.1)
            startFlying()
        end
    end)

    game:GetService("CoreGui").ChildRemoved:Connect(function(child)
        if child.Name == "CloudHub" and FlyingEnabled then
            stopFlying()
        end
    end)

    FlightControl:Divider()
    local SpeedHack = false
    local SpeedValue = 16
    FlightControl:Toggle({
        Title = "速度增加",
        Default = SpeedHack,
        Callback = function(v)
            SpeedHack = v
            if v then
                task.spawn(function()
                    local sudu = game:GetService("RunService").Heartbeat:Connect(function()
                        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                            local hum = game.Players.LocalPlayer.Character.Humanoid
                            if hum.MoveDirection.Magnitude > 0 then
                                game.Players.LocalPlayer.Character:TranslateBy(hum.MoveDirection * SpeedValue / 10)
                            end
                        end
                    end)
                    while SpeedHack do
                        task.wait()
                    end
                    sudu:Disconnect()
                end)
            else
                print("速度：关闭")
            end
        end
    })
    FlightControl:Slider({
        Title = "速度设置",
        Value = { Min = 1, Max = 150, Default = 16 },
        Callback = function(v)
            SpeedValue = v
        end
    })

    FlightControl:Toggle({
        Title = "扩大视野",
        Default = false,
        Callback = function(v)
            if v == true then
                fovConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    workspace.CurrentCamera.FieldOfView = 120
                end)
            elseif not v and fovConnection then
                fovConnection:Disconnect()
                fovConnection = nil
            end
        end
    })

    FlightControl:Divider()
    FlightControl:Toggle({
        Title = "无限跳",
        Default = false,
        Callback = function(Value)
            local jumpConn
            if Value then
                jumpConn = game:GetService("UserInputService").JumpRequest:Connect(function()
                    local humanoid = game:GetService("Players").LocalPlayer.Character and
                                     game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            else
                if jumpConn then
                    jumpConn:Disconnect()
                    jumpConn = nil
                end
            end
        end
    })

    -- ============================================================
    -- 战斗功能 Tab
    -- ============================================================
    local Main = Window:Tab({Title = "战斗功能", Icon = "swords"})
    local ForceLoadAll = false
    Main:Toggle({
        Title = "强制加载所有数据",
        Default = ForceLoadAll,
        Callback = function(v)
            ForceLoadAll = v
            if v then
                task.spawn(function()
                    local devv = require(game:GetService("ReplicatedStorage").Devv)
                    local Network = devv.load("Network")
                    local Players = game:GetService("Players")
                    local RunService = game:GetService("RunService")
                    local LocalPlayer = Players.LocalPlayer
                    
                    local function loadArea(position, radius)
                        if RunService:IsClient() then
                            pcall(function()
                                Network.InvokeServer("requestStreamAround", position, radius)
                            end)
                            pcall(function()
                                Network.FireServer("setReplicationFocus", position)
                            end)
                        end
                    end
                    
                    local function loadAllGizmos()
                        local White = Workspace:FindFirstChild("Local") and Workspace.Local:FindFirstChild("Gizmos") and Workspace.Local.Gizmos:FindFirstChild("White")
                        if White then
                            for _,gizmo in ipairs(White:GetChildren()) do
                                if gizmo.PrimaryPart then
                                    loadArea(gizmo.PrimaryPart.Position, 50)
                                    task.wait(0.1)
                                end
                            end
                        end
                    end
                    
                    local function loadAllPlayers()
                        for _,player in ipairs(Players:GetPlayers()) do
                            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                loadArea(player.Character.HumanoidRootPart.Position, 50)
                                task.wait(0.1)
                            end
                        end
                    end
                    
                    while ForceLoadAll do
                        loadAllGizmos()
                        loadAllPlayers()
                        loadArea(Vector3.new(0,0,0), 1000)
                        loadArea(Vector3.new(1000,0,1000), 1000)
                        loadArea(Vector3.new(-1000,0,-1000), 1000)
                        loadArea(Vector3.new(1000,0,-1000), 1000)
                        loadArea(Vector3.new(-1000,0,1000), 1000)
                        task.wait(5)
                    end
                end)
            else
                print("强制加载：关闭")
            end
        end
    })
    
    local AutoShoot = false
    local OriginalShoot = nil
    local ShooterModule = nil
    
    Main:Toggle({
        Title = "愤怒机器人[全枪]",
        Default = AutoShoot,
        Callback = function(v)
            AutoShoot = v
            if v then
                task.spawn(function()
                    ShooterModule = require(game:GetService("ReplicatedStorage").Client.Wanted.Objects.ClientTool.Components.Guns.Shooter)
                    OriginalShoot = ShooterModule._shoot
                    
                    local trailColors = {
                        primary = ColorSequence.new{
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 170, 255)),
                            ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 0, 255)),
                            ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 255, 0)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                        }
                    }
                    
                    local function createBezierCurve(p0, p1, p2, t)
                        return (1-t)^2 * p0 + 2*(1-t)*t * p1 + t^2 * p2
                    end
                    
                    local function createBeautifulTrail(origin, targetPos)
                        local trailContainer = Instance.new("Folder")
                        trailContainer.Name = "MagicTrail"
                        trailContainer.Parent = Workspace
                        
                        local midPoint = (origin + targetPos) / 2
                        local direction = (targetPos - origin).Unit
                        local perpendicular = Vector3.new(-direction.Z, direction.Y, direction.X) * 3
                        local controlPoint = midPoint + perpendicular + Vector3.new(0, math.random(-3, 3), 0)
                        
                        local curvePoints = {}
                        local numSegments = 20
                        
                        for i = 0, numSegments do
                            local t = i / numSegments
                            local point = createBezierCurve(origin, controlPoint, targetPos, t)
                            table.insert(curvePoints, point)
                        end
                        
                        for i = 1, #curvePoints - 1 do
                            local startPoint = curvePoints[i]
                            local endPoint = curvePoints[i + 1]
                            local distance = (endPoint - startPoint).Magnitude
                            
                            local beamPart = Instance.new("Part")
                            beamPart.Size = Vector3.new(0.15, 0.15, distance)
                            beamPart.Anchored = true
                            beamPart.CanCollide = false
                            beamPart.Material = Enum.Material.Neon
                            beamPart.Transparency = 0.3
                            beamPart.CFrame = CFrame.new(startPoint, endPoint) * CFrame.new(0, 0, -distance/2)
                            beamPart.Parent = trailContainer
                            
                            local pointLight = Instance.new("PointLight")
                            pointLight.Brightness = 5
                            pointLight.Range = 3
                            pointLight.Color = Color3.fromRGB(0, 170, 255)
                            pointLight.Parent = beamPart
                            
                            local particles = Instance.new("ParticleEmitter")
                            particles.Size = NumberSequence.new(0.1, 0.3)
                            particles.Transparency = NumberSequence.new(0.3, 0.8)
                            particles.Lifetime = NumberRange.new(0.5, 1)
                            particles.Rate = 50
                            particles.Speed = NumberRange.new(1, 2)
                            particles.VelocitySpread = 180
                            particles.Parent = beamPart
                        end
                        
                        task.spawn(function()
                            task.wait(1.5)
                            if trailContainer and trailContainer.Parent then
                                trailContainer:Destroy()
                            end
                        end)
                        
                        return trailContainer
                    end
                    
                    local function hasLineOfSight(shooterPos, targetPos)
                        local raycastParams = RaycastParams.new()
                        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                        raycastParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character}
                        raycastParams.IgnoreWater = true
                        
                        local direction = (targetPos - shooterPos).Unit
                        local distance = (targetPos - shooterPos).Magnitude
                        local raycastResult = Workspace:Raycast(shooterPos, direction * distance, raycastParams)
                        
                        if raycastResult then
                            local hitPart = raycastResult.Instance
                            if hitPart then
                                local hitCharacter = hitPart:FindFirstAncestorOfClass("Model")
                                if hitCharacter and hitCharacter:FindFirstChild("Humanoid") then
                                    return true
                                else
                                    return false
                                end
                            end
                        end
                        return true
                    end
                    
                    ShooterModule._shoot = function(self)
                        if not self or not self.tool then
                            return OriginalShoot(self)
                        end
                        
                        local Players = game:GetService("Players")
                        local LocalPlayer = game.Players.LocalPlayer
                        local LocalCharacter = LocalPlayer.Character
                        
                        if not LocalCharacter then
                            return OriginalShoot(self)
                        end
                        
                        local shooterPos = LocalCharacter.HumanoidRootPart and LocalCharacter.HumanoidRootPart.Position or LocalCharacter.PrimaryPart.Position
                        local nearestPlayer = nil
                        local nearestDistance = math.huge
                        
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                local targetPos = player.Character.HumanoidRootPart.Position
                                local distance = (shooterPos - targetPos).Magnitude
                                
                                if hasLineOfSight(shooterPos, targetPos) and distance < nearestDistance then
                                    nearestDistance = distance
                                    nearestPlayer = player
                                end
                            end
                        end
                        
                        if nearestPlayer and nearestPlayer.Character and nearestPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local targetPos = nearestPlayer.Character.HumanoidRootPart.Position
                            self.aimpoint = targetPos
                            self.aimpoint2 = targetPos
                            
                            if self.tool.model and self.tool.model.PrimaryPart then
                                local muzzlePos = self.tool.model.PrimaryPart.Position
                                createBeautifulTrail(muzzlePos, targetPos)
                            else
                                createBeautifulTrail(shooterPos, targetPos)
                            end
                            
                            if self.tool then
                                self.tool.shooting = true
                                self.tool.fireDebounce = 0
                                self.tool.fireMode = "auto"
                            end
                        else
                            if self.tool then
                                self.tool.shooting = false
                            end
                        end
                        
                        return OriginalShoot(self)
                    end
                    
                    while AutoShoot do
                        if ShooterModule and ShooterModule._shoot then
                            local tool = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                            if tool then
                                local shooter = tool:FindFirstChild("Shooter")
                                if not shooter then
                                    shooter = {tool = tool}
                                end
                                pcall(function()
                                    ShooterModule._shoot(shooter)
                                end)
                            end
                        end
                        task.wait(0.2)
                    end
                    
                    if OriginalShoot then
                        ShooterModule._shoot = OriginalShoot
                    end
                end)
            else
                print("自动射击：关闭")
                if ShooterModule and OriginalShoot then
                    ShooterModule._shoot = OriginalShoot
                end
            end
        end
    })
    
    local AutoSell = false
    Main:Toggle({
        Title = "出售物品光环",
        Default = AutoSell,
        Callback = function(v)
            AutoSell = v
            if v then
                task.spawn(function()
                    while AutoSell do
                        for _, a in ipairs(game:GetService("ReplicatedStorage").Shared.Core.Network:GetChildren()) do
                            if a:IsA("RemoteFunction") or a:IsA("RemoteEvent") then
                                if not a.Name:find("moveHouse") and not a.Name:find("House") then
                                    pcall(function()
                                        a:InvokeServer()
                                    end)
                                end
                            end
                            if not AutoSell then
                                break
                            end
                        end
                        task.wait(0.5)
                    end
                end)
            else
                print("自动出售：关闭")
            end
        end
    })

    -- ============================================================
    -- 刷钱功能 Tab
    -- ============================================================
    local MoneyFarmTab = Window:Tab({Title = "刷钱功能", Icon = "dollar-sign"})
    
    local AutoBankCash = false
    MoneyFarmTab:Toggle({
        Title = "自动抢银行",
        Default = AutoBankCash,
        Callback = function(v)
            AutoBankCash = v
            if v then
                task.spawn(function()
                    local function GetRootPart()
                        local Character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                        return Character:WaitForChild("HumanoidRootPart", 5)
                    end
                    
                    while AutoBankCash do
                        local RootPart = GetRootPart()
                        local White = Workspace:FindFirstChild("Local") and Workspace.Local:FindFirstChild("Gizmos") and Workspace.Local.Gizmos:FindFirstChild("White")
                        
                        if White and RootPart and White:FindFirstChild("MainBankCash") and AutoBankCash then
                            local Item = White.MainBankCash
                            local Target = Item.PrimaryPart or Item:FindFirstChildWhichIsA("BasePart", true)
                            
                            if Target then
                                RootPart.CFrame = Target.CFrame * CFrame.new(0, 0, -2.5)
                                task.wait(0.2)
                                
                                while AutoBankCash and White:FindFirstChild("MainBankCash") do
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
                                    task.wait(0.05)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
                                    task.wait(0.5)
                                end
                            end
                        end
                        task.wait(0.5)
                    end
                end)
            else
                print("银行钱堆：关闭")
            end
        end
    })
    
    local HitATMAura = false
    MoneyFarmTab:Toggle({
        Title = "摧毁ATM光环",
        Default = HitATMAura,
        Callback = function(Value)
            HitATMAura = Value
            if Value then
                local devv = require(game:GetService("ReplicatedStorage").Devv)
                local Get = devv.GetModule("Network")
                local Players = game:GetService("Players")
                local localPlayer = Players.LocalPlayer
                local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
                local humanoid = character:WaitForChild("Humanoid")
                local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                
                local gizmoColors = {
                    "White", "Green", "Blue", "Purple", "Orange", "Red", "Yellow"
                }
                
                local isAttacking = false
                local cooldown = false
                
                local function attackATM(gizmo)
                    if not gizmo or not gizmo:FindFirstChild("Metal") then
                        return false
                    end
                    local metalPart = gizmo.Metal
                    local guid = gizmo:GetAttribute("objectId")
                    if not guid then
                        return false
                    end
                    
                    Get.FireServer("registerMeleeHits", {{
                        normal = Vector3.new(0, 0, 0),
                        direction = Vector3.new(0, 0, 0),
                        source = "Melee",
                        id = guid,
                        material = Enum.Material.Metal,
                        position = metalPart.Position,
                        gizmoType = "ATM",
                        processedPlayerId = localPlayer.UserId,
                        hit = metalPart,
                        speed = 50,
                        collisionPoint = metalPart.Position,
                        hitName = "Metal",
                        hitType = "gizmo"
                    }})
                    return true
                end
                
                local function isATMAlive(gizmo)
                    if not gizmo or not gizmo.Parent then
                        return false
                    end
                    if not gizmo:FindFirstChild("Metal") then
                        return false
                    end
                    return true
                end
                
                local function findAllATMs()
                    local allATMs = {}
                    for _, color in ipairs(gizmoColors) do
                        local colorFolder = Workspace.Local.Gizmos:FindFirstChild(color)
                        if colorFolder then
                            local atm = colorFolder:FindFirstChild("ATM")
                            if atm then
                                table.insert(allATMs, atm)
                            end
                        end
                    end
                    return allATMs
                end
                
                local function attackLoop()
                    while HitATMAura do
                        if cooldown then
                            task.wait(0.1)
                            continue
                        end
                        
                        local allATMs = findAllATMs()
                        
                        if #allATMs == 0 then
                            task.wait(1)
                            continue
                        end
                        
                        for _, atm in ipairs(allATMs) do
                            if not HitATMAura then break end
                            
                            local attackCount = 0
                            
                            while HitATMAura and isATMAlive(atm) and attackCount < 50 do
                                attackATM(atm)
                                attackCount += 1
                                task.wait(0.05)
                            end
                            
                            if HitATMAura then
                                task.wait(0.5)
                            end
                        end
                        
                        task.wait(0.1)
                    end
                end
                
                local function onCharacterDied()
                    if HitATMAura then
                        cooldown = true
                        task.wait(3)
                        cooldown = false
                    end
                end
                
                local function setupCharacterListeners()
                    if character:FindFirstChild("Humanoid") then
                        character.Humanoid.Died:Connect(onCharacterDied)
                    end
                    
                    localPlayer.CharacterAdded:Connect(function(newChar)
                        character = newChar
                        humanoid = newChar:WaitForChild("Humanoid")
                        humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
                        humanoid.Died:Connect(onCharacterDied)
                    end)
                end
                
                setupCharacterListeners()
                task.spawn(attackLoop)
            end
        end
    })
    
    local AutoATM = false
    MoneyFarmTab:Toggle({
        Title = "自动ATM",
        Default = AutoATM,
        Callback = function(Value)
            AutoATM = Value
            if Value then
                local TimeElapsedATM = 0
                local TimeoutThresholdATM = 30
                local RootPart = (game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
                local GizmoFolder = Workspace.Local.Gizmos.White
                
                local ATMPatrolPoints = {
                    Vector3.new(-1137, 78, -1953),
                    Vector3.new(-44, 63, -2083),
                    Vector3.new(194, 60, -2884),
                    Vector3.new(-412, 106, -1301),
                    Vector3.new(-377, 410, -741),
                    Vector3.new(-985, 380, -1145),
                    Vector3.new(-854, 406, -1505)
                }
                
                local function GetBasePart(instance)
                    if instance:IsA("BasePart") then
                        return instance
                    end
                    for _, descendant in ipairs(instance:GetDescendants()) do
                        if descendant:IsA("BasePart") then
                            return descendant
                        end
                    end
                end
                
                local function IsValidATMTarget(instance)
                    local typeAttr = instance:GetAttribute("gizmoType")
                    return typeAttr == "ATM"
                end
                
                local function FindClosestATMTarget()
                    local minDistance = math.huge
                    local closestPart = nil
                    for _, item in ipairs(GizmoFolder:GetChildren()) do
                        if IsValidATMTarget(item) then
                            local part = GetBasePart(item)
                            if part then
                                local dist = (RootPart.Position - part.Position).Magnitude
                                if dist < minDistance then
                                    closestPart = part
                                    minDistance = dist
                                end
                            end
                        end
                    end
                    return closestPart
                end
                
                local function TeleportTo(target)
                    if typeof(target) ~= "Instance" then
                        if typeof(target) == "Vector3" then
                            RootPart.CFrame = CFrame.new(target)
                        end
                    else
                        RootPart.CFrame = target.CFrame * CFrame.new(0, 5, 0)
                    end
                end
                
                local function SpamInteract(duration)
                    local start = tick()
                    while tick() - start < duration do
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
                        task.wait(0.05)
                    end
                end
                
                local function ProcessATMCollection(targetPart)
                    local start = tick()
                    local maxWait = 3
                    while tick() - start < maxWait and (targetPart.Parent and not targetPart:GetAttribute("Collected")) do
                        task.wait(0.1)
                    end
                    SpamInteract(1.5)
                end
                
                task.spawn(function()
                    while AutoATM do
                        local target = FindClosestATMTarget()
                        if target then
                            TeleportTo(target)
                            task.wait(0.3)
                            SpamInteract(1.5)
                            ProcessATMCollection(target)
                            TimeElapsedATM = 0
                        else
                            TimeElapsedATM = TimeElapsedATM + 0.7
                            TeleportTo(ATMPatrolPoints[math.random(1, #ATMPatrolPoints)])
                            if TimeoutThresholdATM <= TimeElapsedATM then
                                TimeElapsedATM = 0
                            end
                        end
                        task.wait(0.7)
                    end
                end)
            end
        end
    })
    
    local AutoRegister = false
    MoneyFarmTab:Toggle({
        Title = "自动收银机",
        Default = AutoRegister,
        Callback = function(Value)
            AutoRegister = Value
            if Value then
                local TimeElapsedRegister = 0
                local TimeoutThresholdRegister = 30
                local RootPart = (game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
                local GizmoFolder = Workspace.Local.Gizmos.White
                
                local RegisterPatrolPoints = {
                    Vector3.new(-1000, 100, -2000),
                    Vector3.new(-500, 100, -2200),
                    Vector3.new(100, 100, -2500)
                }
                
                local function GetBasePart(instance)
                    if instance:IsA("BasePart") then
                        return instance
                    end
                    for _, descendant in ipairs(instance:GetDescendants()) do
                        if descendant:IsA("BasePart") then
                            return descendant
                        end
                    end
                end
                
                local function IsValidRegisterTarget(instance)
                    local typeAttr = instance:GetAttribute("gizmoType")
                    return typeAttr == "Register"
                end
                
                local function FindClosestRegisterTarget()
                    local minDistance = math.huge
                    local closestPart = nil
                    for _, item in ipairs(GizmoFolder:GetChildren()) do
                        if IsValidRegisterTarget(item) then
                            local part = GetBasePart(item)
                            if part then
                                local dist = (RootPart.Position - part.Position).Magnitude
                                if dist < minDistance then
                                    closestPart = part
                                    minDistance = dist
                                end
                            end
                        end
                    end
                    return closestPart
                end
                
                local function TeleportTo(target)
                    if typeof(target) ~= "Instance" then
                        if typeof(target) == "Vector3" then
                            RootPart.CFrame = CFrame.new(target)
                        end
                    else
                        RootPart.CFrame = target.CFrame * CFrame.new(0, 5, 0)
                    end
                end
                
                local function SpamInteract(duration)
                    local start = tick()
                    while tick() - start < duration do
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
                        task.wait(0.05)
                    end
                end
                
                local function ProcessRegisterCollection(targetPart)
                    local start = tick()
                    local maxWait = 2
                    while tick() - start < maxWait and (targetPart.Parent and not targetPart:GetAttribute("Collected")) do
                        task.wait(0.1)
                    end
                    SpamInteract(1.2)
                end
                
                task.spawn(function()
                    while AutoRegister do
                        local target = FindClosestRegisterTarget()
                        if target then
                            TeleportTo(target)
                            task.wait(0.3)
                            SpamInteract(1.2)
                            ProcessRegisterCollection(target)
                            TimeElapsedRegister = 0
                        else
                            TimeElapsedRegister = TimeElapsedRegister + 0.7
                            TeleportTo(RegisterPatrolPoints[math.random(1, #RegisterPatrolPoints)])
                            if TimeoutThresholdRegister <= TimeElapsedRegister then
                                TimeElapsedRegister = 0
                            end
                        end
                        task.wait(0.7)
                    end
                end)
            end
        end
    })

    -- ============================================================
    -- 自动拾取 Tab
    -- ============================================================
    local AutoPickupTab = Window:Tab({Title = "自动拾取", Icon = "box"})
    
    local AutoGold = false
    AutoPickupTab:Toggle({
        Title = "自动拾取金条",
        Default = AutoGold,
        Callback = function(v)
            AutoGold = v
            if v then
                task.spawn(function()
                    local function GetRootPart()
                        local Character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                        return Character:WaitForChild("HumanoidRootPart", 5)
                    end
                    
                    while AutoGold do
                        local RootPart = GetRootPart()
                        local White = Workspace:FindFirstChild("Local") and Workspace.Local:FindFirstChild("Gizmos") and Workspace.Local.Gizmos:FindFirstChild("White")
                        
                        if White and RootPart then
                            for _, Item in ipairs(White:GetChildren()) do
                                if Item.Name == "Gold Bar" and AutoGold then
                                    local Target = Item.PrimaryPart or Item:FindFirstChildWhichIsA("BasePart", true)
                                    
                                    if Target then
                                        RootPart.CFrame = Target.CFrame * CFrame.new(0, 0, -2.5)
                                        task.wait(0.2)
                                        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
                                        task.wait(0.05)
                                        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
                                        
                                        repeat
                                            task.wait(0.1)
                                        until not Item.Parent or not AutoGold
                                    end
                                end
                                
                                if not AutoGold then
                                    break
                                end
                            end
                        end
                        task.wait(0.5)
                    end
                end)
            end
        end
    })
    
    local AutoWorldItem = false
    AutoPickupTab:Toggle({
        Title = "自动拾取全部礼物盒",
        Default = AutoWorldItem,
        Callback = function(v)
            AutoWorldItem = v
            if v then
                task.spawn(function()
                    local function GetRootPart()
                        local Character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                        return Character:WaitForChild("HumanoidRootPart", 5)
                    end
                    
                    while AutoWorldItem do
                        local RootPart = GetRootPart()
                        local White = Workspace:FindFirstChild("Local") and Workspace.Local:FindFirstChild("Gizmos") and Workspace.Local.Gizmos:FindFirstChild("White")
                        
                        if White and RootPart then
                            for _, Item in ipairs(White:GetChildren()) do
                                if Item.Name == "WorldItem" and AutoWorldItem then
                                    local Target = Item.PrimaryPart or Item:FindFirstChildWhichIsA("BasePart", true)
                                    
                                    if Target then
                                        RootPart.CFrame = Target.CFrame * CFrame.new(0, 0, -2.5)
                                        task.wait(0.2)
                                        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
                                        task.wait(0.05)
                                        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
                                        
                                        repeat
                                            task.wait(0.1)
                                        until not Item.Parent or not AutoWorldItem
                                    end
                                end
                                
                                if not AutoWorldItem then
                                    break
                                end
                            end
                        end
                        task.wait(0.5)
                    end
                end)
            else
                print("礼物盒：关闭")
            end
        end
    })
    
    local AutoSilverBar = false
    AutoPickupTab:Toggle({
        Title = "自动拾取银条",
        Default = AutoSilverBar,
        Callback = function(v)
            AutoSilverBar = v
            if v then
                task.spawn(function()
                    local function GetRootPart()
                        local Character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                        return Character:WaitForChild("HumanoidRootPart", 5)
                    end
                    
                    while AutoSilverBar do
                        local RootPart = GetRootPart()
                        local White = Workspace:FindFirstChild("Local") and Workspace.Local:FindFirstChild("Gizmos") and Workspace.Local.Gizmos:FindFirstChild("White")
                        
                        if White and RootPart then
                            for _, Item in ipairs(White:GetChildren()) do
                                if Item.Name == "Silver Bar" and AutoSilverBar then
                                    local Target = Item.PrimaryPart or Item:FindFirstChildWhichIsA("BasePart", true)
                                    
                                    if Target then
                                        RootPart.CFrame = Target.CFrame * CFrame.new(0, 0, -2.5)
                                        task.wait(0.2)
                                        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
                                        task.wait(0.05)
                                        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
                                        
                                        repeat
                                            task.wait(0.1)
                                        until not Item.Parent or not AutoSilverBar
                                    end
                                end
                                
                                if not AutoSilverBar then
                                    break
                                end
                            end
                        end
                        task.wait(0.5)
                    end
                end)
            else
                print("银条：关闭")
            end
        end
    })
    
    local AutoSapphire = false
    AutoPickupTab:Toggle({
        Title = "自动拾取蓝宝石",
        Default = AutoSapphire,
        Callback = function(v)
            AutoSapphire = v
            if v then
                task.spawn(function()
                    local function GetRootPart()
                        local Character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                        return Character:WaitForChild("HumanoidRootPart", 5)
                    end
                    
                    while AutoSapphire do
                        local RootPart = GetRootPart()
                        local White = Workspace:FindFirstChild("Local") and Workspace.Local:FindFirstChild("Gizmos") and Workspace.Local.Gizmos:FindFirstChild("White")
                        
                        if White and RootPart and White:FindFirstChild("Sapphire") and AutoSapphire then
                            local Item = White.Sapphire
                            local Target = Item.PrimaryPart or Item:FindFirstChildWhichIsA("BasePart", true)
                            
                            if Target then
                                RootPart.CFrame = Target.CFrame * CFrame.new(0, 0, -2.5)
                                task.wait(0.2)
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
                                task.wait(0.05)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
                                
                                repeat
                                    task.wait(0.1)
                                until not White:FindFirstChild("Sapphire") or not AutoSapphire
                            end
                        end
                        task.wait(0.5)
                    end
                end)
            else
                print("蓝宝石：关闭")
            end
        end
    })

    -- ============================================================
    -- 绕过类 Tab
    -- ============================================================
    local BypassTab = Window:Tab({Title = "绕过类", Icon = "wind"})
    local ImmuneTurret = false
    local oldFireServer

    BypassTab:Toggle({
        Title = "绕过炮塔伤害",
        Default = ImmuneTurret,
        Callback = function(v)
            ImmuneTurret = v
            if v then
                oldFireServer = game:GetService("ReplicatedStorage").Shared.Core.Network.FireServer
                game:GetService("ReplicatedStorage").Shared.Core.Network.FireServer = function(self, event, ...)
                    if event == "registerLocalHit" and ... == "Turret" then
                        return nil
                    end
                    return oldFireServer(self, event, ...)
                end
            else
                game:GetService("ReplicatedStorage").Shared.Core.Network.FireServer = oldFireServer
            end
        end
    })

    -- ============================================================
    -- 武器修改 Tab
    -- ============================================================
    local WeaponTab = Window:Tab({Title = "武器修改", Icon = "target"})
    
    WeaponTab:Button({
        Title = "无限子弹",
        Callback = function()
            local Shooter = require(game:GetService("ReplicatedStorage").Client.Wanted.Objects.ClientTool.Components.Guns.Shooter)
            local originalShoot = Shooter._shoot
            Shooter._shoot = function(self)
                self.ammo = 9999
                self.totalAmmo = 9999
                return originalShoot(self)
            end
        end
    })
    
    WeaponTab:Button({
        Title = "无后坐力",
        Callback = function()
            local Shooter = require(game:GetService("ReplicatedStorage").Client.Wanted.Objects.ClientTool.Components.Guns.Shooter)
            local originalShoot = Shooter._shoot
            Shooter._shoot = function(self)
                self.recoil = {firstShotKick = 0, climb = 0, spread = 0}
                return originalShoot(self)
            end
        end
    })
    
    WeaponTab:Button({
        Title = "无扩散",
        Callback = function()
            local Shooter = require(game:GetService("ReplicatedStorage").Client.Wanted.Objects.ClientTool.Components.Guns.Shooter)
            local originalShoot = Shooter._shoot
            Shooter._shoot = function(self)
                self.aim = {spreadAngle = 0, zeroing = 1000}
                return originalShoot(self)
            end
        end
    })
    
    WeaponTab:Button({
        Title = "快速射击",
        Callback = function()
            local Shooter = require(game:GetService("ReplicatedStorage").Client.Wanted.Objects.ClientTool.Components.Guns.Shooter)
            local originalShoot = Shooter._shoot
            Shooter._shoot = function(self)
                self.tool.fireDebounce = 0
                self.tool.fireMode = "auto"
                return originalShoot(self)
            end
        end
    })
    
    WeaponTab:Button({
        Title = "无装弹",
        Callback = function()
            local Shooter = require(game:GetService("ReplicatedStorage").Client.Wanted.Objects.ClientTool.Components.Guns.Shooter)
            local originalShoot = Shooter._shoot
            Shooter._shoot = function(self)
                self.ammoData = {reloadTime = 0, magSize = 9999}
                return originalShoot(self)
            end
        end
    })

    -- ============================================================
    -- 自瞄 Tab
    -- ============================================================
    local AimTab = Window:Tab({Title = "自瞄", Icon = "crosshair"})
    local isAiming = false
    local isPredicting = false 
    local isLowHealthPriority = false 
    local fov = 50 
    local plr = game:GetService("Players").LocalPlayer
    local Cam = workspace.CurrentCamera
    local targetPart = "Head"
    local teamCheck = false
    local aliveCheck = false
    local predictionDistance = 1.5
    local wallCheck = false
    local smoothness = 0.5
    local aimKey = Enum.KeyCode.Q
    local aimLock = false
    local aimLockSpeed = 0.2
    local isAimingHead = false
    local aimStyle = "平滑"
    local lockTime = 0.5
    local lastLockTime = 0
    local lockedPlayer = nil
    local lockDuration = 3
    local lockExpire = 0
    local isSilentAim = false
    local silentFov = 30
    local isRageMode = false
    local silentAimChance = 100
    local aimbotType = "传统"
    local aimbotPriority = "距离"
    local isAutoShootOnAim = false
    local isSmartAim = false
    local smartAimThreshold = 0.8
    local isLagCompensation = false
    local lagCompensationTime = 0.1

    local FOVring = Drawing.new("Circle")
    FOVring.Visible = false
    FOVring.Thickness = 2
    FOVring.Color = Color3.fromRGB(255, 0, 0) 
    FOVring.Filled = false
    FOVring.Radius = fov
    FOVring.Position = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)

    local SilentFOVring = Drawing.new("Circle")
    SilentFOVring.Visible = false
    SilentFOVring.Thickness = 1
    SilentFOVring.Color = Color3.fromRGB(0, 255, 255)
    SilentFOVring.Filled = false
    SilentFOVring.Radius = silentFov
    SilentFOVring.Position = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)

    local aimConnection = nil
    local silentAimConnection = nil

    local function updateDrawings()
        FOVring.Position = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)
        SilentFOVring.Position = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)
    end

    local function getClosestPlayerInFOV()
        local nearest = nil
        local lastDistance = math.huge
        local lowestHealthPlayer = nil
        local lowestHealth = math.huge
        local nearestDistance = math.huge
        local playerMousePos = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)
        local fovToUse = silentFov
        local now = tick()

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= plr then
                if teamCheck and player.Team == plr.Team then continue end
                
                local character = player.Character
                if character and character:FindFirstChild(targetPart) then
                    if aliveCheck and (not character:FindFirstChildOfClass("Humanoid") or character:FindFirstChildOfClass("Humanoid").Health <= 0) then continue end
                    
                    local part = character[targetPart]
                    local ePos, isVisible = Cam:WorldToViewportPoint(part.Position)
                    local screenDistance = (Vector2.new(ePos.x, ePos.y) - playerMousePos).Magnitude
                    
                    if screenDistance < fovToUse and isVisible then
                        local distance = (plr.Character and plr.Character.PrimaryPart and (part.Position - plr.Character.PrimaryPart.Position).Magnitude) or math.huge
                        
                        if aimbotPriority == "距离" and distance < nearestDistance then
                            nearestDistance = distance
                            nearest = player
                        elseif aimbotPriority == "屏幕距离" and screenDistance < lastDistance then
                            lastDistance = screenDistance
                            nearest = player
                        elseif aimbotPriority == "生命值" then
                            local humanoid = character:FindFirstChildOfClass("Humanoid")
                            if humanoid and humanoid.Health < lowestHealth then
                                lowestHealth = humanoid.Health
                                lowestHealthPlayer = player
                            end
                        end
                    end
                end
            end
        end

        if aimbotPriority == "生命值" and lowestHealthPlayer then
            return lowestHealthPlayer
        end

        return nearest
    end

    local function getPredictedPosition(player, deltaTime)
        if not isPredicting then
            return player.Character and player.Character:FindFirstChild(targetPart) and player.Character[targetPart].Position
        end
        
        local character = player.Character
        if not character or not character:FindFirstChild(targetPart) then return end

        local part = character[targetPart]
        local velocity = part.Velocity
        local nextPosition = part.Position + velocity * deltaTime * predictionDistance
        
        if isLagCompensation then
            nextPosition = nextPosition + velocity * lagCompensationTime
        end
        
        return nextPosition
    end

    local function smartAimAt(targetPosition)
        local currentCFrame = Cam.CFrame
        local targetDirection = (targetPosition - currentCFrame.Position).Unit
        
        if aimStyle == "平滑" then
            local smoothFactor = smoothness
            if isRageMode then smoothFactor = smoothness * 0.3 end
            
            local lookVector = currentCFrame.LookVector:Lerp(targetDirection, smoothFactor)
            Cam.CFrame = CFrame.new(currentCFrame.Position, currentCFrame.Position + lookVector)
        elseif aimStyle == "直接" or isRageMode then
            Cam.CFrame = CFrame.new(currentCFrame.Position, currentCFrame.Position + targetDirection)
        elseif aimStyle == "震动" then
            local lookVector = currentCFrame.LookVector:Lerp(targetDirection, smoothness)
            local shake = Vector3.new(
                (math.random() - 0.5) * 0.1,
                (math.random() - 0.5) * 0.1,
                0
            )
            Cam.CFrame = CFrame.new(currentCFrame.Position, currentCFrame.Position + lookVector + shake)
        end
    end

    local function silentAim()
        if not isSilentAim then return nil end
        
        local target = getClosestPlayerInFOV()
        if not target or not target.Character or not target.Character:FindFirstChild(targetPart) then return nil end
        
        if math.random(1, 100) > silentAimChance then return nil end
        
        local part = target.Character[targetPart]
        local predictedPos = getPredictedPosition(target, 0.016)
        
        return predictedPos or part.Position
    end

    local function aimLoop()
        if not isAiming then return end
        
        updateDrawings()
        
        local now = tick()
        local deltaTime = 0.016
        
        if aimLock and lockedPlayer and now - lastLockTime < lockDuration then
            if lockedPlayer.Character and lockedPlayer.Character:FindFirstChild(targetPart) then
                local targetPos = getPredictedPosition(lockedPlayer, deltaTime)
                if targetPos then
                    smartAimAt(targetPos)
                end
            end
        else
            local target = getClosestPlayerInFOV()
            if target and target.Character and target.Character:FindFirstChild(targetPart) then
                local targetPos = getPredictedPosition(target, deltaTime)
                if targetPos then
                    smartAimAt(targetPos)
                    
                    if aimLock then
                        lockedPlayer = target
                        lastLockTime = now
                    end
                end
            end
        end
    end

    AimTab:Toggle({
        Title = "开启自瞄",
        Default = false,
        Callback = function(v)
            isAiming = v
            FOVring.Visible = v
            if v then
                if aimConnection then aimConnection:Disconnect() end
                aimConnection = RunService.RenderStepped:Connect(aimLoop)
            elseif aimConnection then
                aimConnection:Disconnect()
                aimConnection = nil
            end
        end
    })

    AimTab:Toggle({
        Title = "静默瞄准",
        Default = false,
        Callback = function(v)
            isSilentAim = v
            SilentFOVring.Visible = v
        end
    })

    AimTab:Toggle({
        Title = "预判自瞄",
        Default = false,
        Callback = function(v)
            isPredicting = v
        end
    })

    AimTab:Toggle({
        Title = "锁定目标",
        Default = false,
        Callback = function(v)
            aimLock = v
        end
    })

    AimTab:Toggle({
        Title = "狂暴模式",
        Default = false,
        Callback = function(v)
            isRageMode = v
        end
    })

    AimTab:Section({Title = "瞄准设置"})

    AimTab:Dropdown({
        Title = "瞄准风格",
        Values = {"平滑", "直接", "震动"},
        Default = "平滑",
        Callback = function(v)
            aimStyle = v
        end
    })

    AimTab:Dropdown({
        Title = "瞄准优先级",
        Values = {"距离", "屏幕距离", "生命值"},
        Default = "距离",
        Callback = function(v)
            aimbotPriority = v
        end
    })

    AimTab:Dropdown({
        Title = "自瞄身体部位",
        Values = {"头", "胸", "左手", "右手", "左腿", "右腿"},
        Default = "头",
        Callback = function(v)
            local partMap = {
                ["头"] = "Head",
                ["胸"] = "UpperTorso",
                ["左手"] = "LeftHand",
                ["右手"] = "RightHand",
                ["左腿"] = "LeftFoot",
                ["右腿"] = "RightFoot"
            }
            targetPart = partMap[v]
        end
    })

    AimTab:Slider({
        Title = "FOV范围",
        Desc = "自瞄检测范围",
        Value = { Min = 1, Max = 500, Default = 50 },
        Callback = function(v)
            fov = v
            FOVring.Radius = v
        end
    })

    AimTab:Slider({
        Title = "静默FOV",
        Desc = "静默瞄准范围",
        Value = { Min = 1, Max = 200, Default = 30 },
        Callback = function(v)
            silentFov = v
            SilentFOVring.Radius = v
        end
    })

    AimTab:Slider({
        Title = "平滑度",
        Desc = "瞄准平滑程度",
        Value = { Min = 0.01, Max = 1, Default = 0.5 },
        Callback = function(v)
            smoothness = v
        end
    })

    AimTab:Slider({
        Title = "预判距离",
        Desc = "预判移动距离",
        Value = { Min = 0.1, Max = 5, Default = 1.5 },
        Callback = function(v)
            predictionDistance = v
        end
    })

    AimTab:Slider({
        Title = "锁定时间",
        Desc = "目标锁定持续时间(秒)",
        Value = { Min = 1, Max = 10, Default = 3 },
        Callback = function(v)
            lockDuration = v
        end
    })

    AimTab:Section({Title = "其他功能"})

    AimTab:Toggle({
        Title = "活体检测",
        Default = false,
        Callback = function(v)
            aliveCheck = v
        end
    })

    AimTab:Toggle({
        Title = "团队检查",
        Default = false,
        Callback = function(v)
            teamCheck = v
        end
    })

    AimTab:Toggle({
        Title = "延迟补偿",
        Default = false,
        Callback = function(v)
            isLagCompensation = v
        end
    })

    -- ============================================================
    -- 透视 Tab（使用 wdfex 的透视，已删除“显示队伍”）
    -- ============================================================
    local EspTab = Window:Tab({Title = "透视", Icon = "eye"})
    local ESP_ENABLED = false
    local ESP_SHOW_NAME = true
    local ESP_SHOW_HEALTH = true
    local ESP_SHOW_DIST = true
    local ESP_SHOW_SELF = false
    local ESP_SHOW_PEERS = true
    local ESP_LIST = {}
    local ESP_REFRESH_COUNT = 0

    local function GetTeam(p)
        if p.Team then
            local teamName = p.Team.Name
            local teamMap = {
                ["Police"] = "警察",
                ["Fire"] = "火焰",
                ["Medical"] = "医疗",
                ["Road"] = "道路",
                ["Civilian"] = "平民",
                ["Citizen"] = "平民",
                ["Criminal"] = "匪徒",
                ["Gang"] = "黑帮",
                ["Military"] = "军人",
                ["Delivery"] = "送货",
                ["Farmer"] = "农民",
                ["Banker"] = "银行家",
                ["Mayor"] = "市长",
                ["Journalist"] = "记者",
                ["Lawyer"] = "律师",
                ["Prisoner"] = "囚犯",
                ["Guard"] = "狱警",
                ["Driver"] = "司机",
                ["Chef"] = "厨师",
                ["Builder"] = "建筑工",
                ["Miner"] = "矿工",
                ["Fisherman"] = "渔夫",
                ["Merchant"] = "商人",
                ["Student"] = "学生",
                ["Teacher"] = "老师",
                ["Engineer"] = "工程师",
                ["Scientist"] = "科学家",
                ["Pilot"] = "飞行员",
                ["Courier"] = "快递员",
                ["BusDriver"] = "公交车司机",
            }
            return teamMap[teamName] or teamName
        end
        return "平民"
    end

    local function GetTeamColor(p)
        if p.Team then return p.Team.TeamColor.Color end
        return Color3.fromRGB(200, 200, 200)
    end

    local function GetHealth(p)
        local c = p.Character
        if not c then return 0 end
        local h = c:FindFirstChildOfClass("Humanoid")
        if not h then return 0 end
        return math.floor(h.Health)
    end

    local function GetDist(p)
        local mc = player.Character
        if not mc then return 0 end
        local mr = mc:FindFirstChild("HumanoidRootPart")
        if not mr then return 0 end
        local tc = p.Character
        if not tc then return 0 end
        local tr = tc:FindFirstChild("HumanoidRootPart")
        if not tr then return 0 end
        return math.floor((mr.Position - tr.Position).Magnitude)
    end

    local function RemoveESP(id)
        local d = ESP_LIST[id]
        if d then
            if d.Billboard then d.Billboard:Destroy() end
            ESP_LIST[id] = nil
        end
    end

    local function BuildESP(p)
        if not p.Character then return end
        if not ESP_SHOW_SELF and p == player then return end
        
        local head = p.Character:FindFirstChild("Head")
        if not head then return end
        if ESP_LIST[p.UserId] then
            if ESP_LIST[p.UserId].Billboard then
                ESP_LIST[p.UserId].Billboard.Enabled = true
            end
            return
        end

        local bb = Instance.new("BillboardGui")
        bb.Size = UDim2.new(0, 200, 0, 100)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = 764
        bb.Parent = head

        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 1, 0)
        f.BackgroundTransparency = 1
        f.Parent = bb

        ESP_LIST[p.UserId] = { Billboard = bb, Frame = f }
    end

    local function RefreshESP()
        if not ESP_ENABLED then
            for _, d in pairs(ESP_LIST) do
                if d.Billboard then d.Billboard.Enabled = false end
            end
            return
        end

        ESP_REFRESH_COUNT = ESP_REFRESH_COUNT + 1
        if ESP_REFRESH_COUNT % 3 ~= 0 then
            return
        end

        for _, p in ipairs(Players:GetPlayers()) do
            if not ESP_SHOW_SELF and p == player then
                RemoveESP(p.UserId)
                continue
            end
            
            if not p.Character then
                RemoveESP(p.UserId)
                continue
            end
            
            if ESP_REFRESH_COUNT % 30 == 0 and ESP_LIST[p.UserId] then
                RemoveESP(p.UserId)
            end
            
            if not ESP_LIST[p.UserId] then
                BuildESP(p)
            end
            
            local d = ESP_LIST[p.UserId]
            if not d then continue end
            if not d.Billboard or not d.Billboard.Parent then
                ESP_LIST[p.UserId] = nil
                BuildESP(p)
                d = ESP_LIST[p.UserId]
                if not d then continue end
            end
            d.Billboard.Enabled = true

            local f = d.Frame
            for _, c in ipairs(f:GetChildren()) do c:Destroy() end

            local y = 0
            local lines = 0
            local team = GetTeam(p)
            local color = GetTeamColor(p)
            local hp = GetHealth(p)
            local dist = GetDist(p)

            local isWdfexUser = false
            local isAuthor = false
            
            for _, child in ipairs(p:GetChildren()) do
                if child:IsA("BoolValue") and child.Name == "wdfexScript" and child.Value == true then
                    isWdfexUser = true
                end
                if child:IsA("BoolValue") and child.Name == "wdfexAuthor" and child.Value == true then
                    isAuthor = true
                end
            end
            
            if p.Character then
                for _, child in ipairs(p.Character:GetDescendants()) do
                    if child:IsA("BoolValue") and child.Name == "wdfexScript" and child.Value == true then
                        isWdfexUser = true
                    end
                    if child:IsA("BoolValue") and child.Name == "wdfexAuthor" and child.Value == true then
                        isAuthor = true
                    end
                end
            end

            if ESP_SHOW_NAME then
                local l = Instance.new("TextLabel")
                l.Size = UDim2.new(1, 0, 0, 20)
                l.Position = UDim2.new(0, 0, 0, y)
                l.BackgroundTransparency = 1
                if p == player then
                    l.Text = p.Name .. " (你)"
                    l.TextColor3 = Color3.fromRGB(0, 255, 255)
                else
                    l.Text = p.Name
                    l.TextColor3 = color
                end
                l.TextSize = 15
                l.Font = Enum.Font.GothamBold
                l.TextStrokeTransparency = 0.3
                l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                l.TextXAlignment = Enum.TextXAlignment.Center
                l.Parent = f
                y = y + 22
                lines = lines + 1
            end

            if ESP_SHOW_PEERS and isWdfexUser then
                local displayText = isAuthor and "wdfex脚本作者" or "wdfex脚本"
                local textColor = isAuthor and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(100, 200, 255)
                
                local l = Instance.new("TextLabel")
                l.Size = UDim2.new(1, 0, 0, 18)
                l.Position = UDim2.new(0, 0, 0, y)
                l.BackgroundTransparency = 1
                l.Text = displayText
                l.TextColor3 = textColor
                l.TextSize = 13
                l.Font = Enum.Font.GothamBold
                l.TextStrokeTransparency = 0.3
                l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                l.TextXAlignment = Enum.TextXAlignment.Center
                l.Parent = f
                y = y + 20
                lines = lines + 1
            end

            if ESP_SHOW_HEALTH then
                local l = Instance.new("TextLabel")
                l.Size = UDim2.new(1, 0, 0, 18)
                l.Position = UDim2.new(0, 0, 0, y)
                l.BackgroundTransparency = 1
                local c = hp > 70 and Color3.fromRGB(0, 255, 100) or hp > 40 and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(255, 50, 50)
                l.Text = hp .. "HP"
                l.TextColor3 = c
                l.TextSize = 13
                l.Font = Enum.Font.GothamBold
                l.TextStrokeTransparency = 0.3
                l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                l.TextXAlignment = Enum.TextXAlignment.Center
                l.Parent = f
                y = y + 20
                lines = lines + 1
            end

            if ESP_SHOW_DIST then
                local l = Instance.new("TextLabel")
                l.Size = UDim2.new(1, 0, 0, 18)
                l.Position = UDim2.new(0, 0, 0, y)
                l.BackgroundTransparency = 1
                l.Text = dist .. "m"
                l.TextColor3 = Color3.fromRGB(200, 200, 200)
                l.TextSize = 13
                l.Font = Enum.Font.Gotham
                l.TextStrokeTransparency = 0.3
                l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                l.TextXAlignment = Enum.TextXAlignment.Center
                l.Parent = f
                y = y + 20
                lines = lines + 1
            end

            d.Billboard.Size = UDim2.new(0, 200, 0, lines * 20 + 10)
        end
    end

    EspTab:Toggle({
        Title = "透视总开关",
        Value = false,
        Callback = function(value)
            ESP_ENABLED = value
            if value then RefreshESP() end
        end
    })
    EspTab:Divider()
    EspTab:Toggle({
        Title = "显示名字",
        Value = true,
        Callback = function(value)
            ESP_SHOW_NAME = value
            if ESP_ENABLED then RefreshESP() end
        end
    })
    EspTab:Toggle({
        Title = "显示血量",
        Value = true,
        Callback = function(value)
            ESP_SHOW_HEALTH = value
            if ESP_ENABLED then RefreshESP() end
        end
    })
    EspTab:Toggle({
        Title = "显示距离",
        Value = true,
        Callback = function(value)
            ESP_SHOW_DIST = value
            if ESP_ENABLED then RefreshESP() end
        end
    })
    EspTab:Divider()
    EspTab:Toggle({
        Title = "透视自己",
        Value = false,
        Callback = function(value)
            ESP_SHOW_SELF = value
            if ESP_ENABLED then RefreshESP() end
        end
    })
    EspTab:Toggle({
        Title = "同行显示",
        Value = true,
        Callback = function(value)
            ESP_SHOW_PEERS = value
            if ESP_ENABLED then RefreshESP() end
        end
    })

    task.spawn(function()
        while not isDestroyed do
            task.wait(0.3)
            if ESP_ENABLED then RefreshESP() end
        end
    end)

    Players.PlayerAdded:Connect(function(p)
        p.CharacterAdded:Connect(function()
            task.wait(0.3)
            if ESP_ENABLED then RefreshESP() end
        end)
    end)

    Players.PlayerRemoving:Connect(function(p)
        RemoveESP(p.UserId)
    end)

    -- ============================================================
    -- 玩家传送 Tab
    -- ============================================================
    local TeleportPlayerTab = Window:Tab({Title = "玩家传送", Icon = "user"})
    
    local TargetPlayerName = ""
    local TeleportPosition = "前方"
    
    TeleportPlayerTab:Input({
        Title = "输入玩家用户名",
        Placeholder = "输入玩家名称",
        Callback = function(v)
            TargetPlayerName = v
        end
    })
    
    TeleportPlayerTab:Dropdown({
        Title = "传送部位",
        Values = {"前方", "后方", "头顶", "左侧", "右侧"},
        Value = TeleportPosition,
        Callback = function(v)
            TeleportPosition = v
        end
    })
    
    TeleportPlayerTab:Button({
        Title = "传送一次",
        Callback = function()
            if TargetPlayerName and TeleportPosition then
                local targetPlayer = game.Players:FindFirstChild(TargetPlayerName)
                
                if targetPlayer and targetPlayer ~= game.Players.LocalPlayer then
                    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local p = game.Players.LocalPlayer
                        local c = p.Character or p.CharacterAdded:Wait()
                        local h = c:WaitForChild("HumanoidRootPart")
                        local targetCFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                        
                        if TeleportPosition == "前方" then
                            h.CFrame = targetCFrame * CFrame.new(0, 0, -5)
                        elseif TeleportPosition == "后方" then
                            h.CFrame = targetCFrame * CFrame.new(0, 0, 5)
                        elseif TeleportPosition == "头顶" then
                            h.CFrame = targetCFrame * CFrame.new(0, 5, 0)
                        elseif TeleportPosition == "左侧" then
                            h.CFrame = targetCFrame * CFrame.new(-5, 0, 0)
                        elseif TeleportPosition == "右侧" then
                            h.CFrame = targetCFrame * CFrame.new(5, 0, 0)
                        end
                    end
                end
            end
        end
    })
    
    local FixedTeleport = false
    TeleportPlayerTab:Toggle({
        Title = "固定传送",
        Default = FixedTeleport,
        Callback = function(v)
            FixedTeleport = v
            if v then
                task.spawn(function()
                    while FixedTeleport do
                        if TargetPlayerName and TeleportPosition then
                            local targetPlayer = game.Players:FindFirstChild(TargetPlayerName)
                            
                            if targetPlayer and targetPlayer ~= game.Players.LocalPlayer then
                                if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                    local p = game.Players.LocalPlayer
                                    local c = p.Character or p.CharacterAdded:Wait()
                                    local h = c:WaitForChild("HumanoidRootPart")
                                    local targetCFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                                    
                                    if TeleportPosition == "前方" then
                                        h.CFrame = targetCFrame * CFrame.new(0, 0, -5)
                                    elseif TeleportPosition == "后方" then
                                        h.CFrame = targetCFrame * CFrame.new(0, 0, 5)
                                    elseif TeleportPosition == "头顶" then
                                        h.CFrame = targetCFrame * CFrame.new(0, 5, 0)
                                    elseif TeleportPosition == "左侧" then
                                        h.CFrame = targetCFrame * CFrame.new(-5, 0, 0)
                                    elseif TeleportPosition == "右侧" then
                                        h.CFrame = targetCFrame * CFrame.new(5, 0, 0)
                                    end
                                end
                            end
                        end
                        task.wait(0.1)
                    end
                end)
            end
        end
    })

    -- ============================================================
    -- 地点传送 Tab
    -- ============================================================
    local TeleportSection = Window:Tab({Title = "地点传送", Icon = "map-pin"})
    
    TeleportSection:Button({
        Title = "传送到奥菲的价值兑换",
        Callback = function()
            local p = game.Players.LocalPlayer
            local c = p.Character or p.CharacterAdded:Wait()
            local h = c:WaitForChild("HumanoidRootPart")
            h.CFrame = CFrame.new(-2907.68848, 37.1002731, 1444.74817, 0.848566413, 3.9380446e-8, -0.529088855, -1.774107e-8, 1, 4.5977092e-8, 0.529088855, -2.962804e-8, 0.848566413)
        end
    })
    
    TeleportSection:Button({
        Title = "传送到绿洲银行",
        Callback = function()
            local p = game.Players.LocalPlayer
            local c = p.Character or p.CharacterAdded:Wait()
            local h = c:WaitForChild("HumanoidRootPart")
            h.CFrame = CFrame.new(-431.537354, 39.6113892, -1400.08313, -0.901108384, -1.61008e-8, -0.433593899, -5.2681104e-9, 1, -2.618487e-8, 0.433593899, -2.1311186e-8, -0.901108384)
        end
    })
    
    TeleportSection:Button({
        Title = "传送到绿洲城警察",
        Callback = function()
            local p = game.Players.LocalPlayer
            local c = p.Character or p.CharacterAdded:Wait()
            local h = c:WaitForChild("HumanoidRootPart")
            h.CFrame = CFrame.new(2578.02393, 119.169289, -718.579773, -0.395326763, -5.9598324e-8, -0.918540537, -9.65633e-9, 1, -5.232432e-8, 0.918540537, 7.947669e-8, -0.395326763)
        end
    })
    
    TeleportSection:Button({
        Title = "传送到金库",
        Callback = function()
            local p = game.Players.LocalPlayer
            local c = p.Character or p.CharacterAdded:Wait()
            local h = c:WaitForChild("HumanoidRootPart")
            h.CFrame = CFrame.new(-400.492279, 163.151733, -1242.72632, -0.912052214, -1.09039995e-8, -0.410074085, 1.4650267e-8, 1, -5.9174205e-8, 0.410074085, -5.997766e-8, -0.912052214)
        end
    })
    
    TeleportSection:Button({
        Title = "传送到犯罪基地",
        Callback = function()
            local p = game.Players.LocalPlayer
            local c = p.Character or p.CharacterAdded:Wait()
            local h = c:WaitForChild("HumanoidRootPart")
            h.CFrame = CFrame.new(-5981.50586, 37.2680244, 1245.22046, -0.733384013, -3.6538985e-8, -0.679814577, -1.7351333e-8, 1, -3.502984e-8, 0.679814577, -1.38946366e-8, -0.733384013)
        end
    })
    
    TeleportSection:Button({
        Title = "传送到烈焰要塞",
        Callback = function()
            local p = game.Players.LocalPlayer
            local c = p.Character or p.CharacterAdded:Wait()
            local h = c:WaitForChild("HumanoidRootPart")
            h.CFrame = CFrame.new(-1494.58496, 41.16481, 3364.56055, 0.961387396, 1.07588015e-7, 0.275198698, -9.5233396e-8, 1, -5.8255473e-8, -0.275198698, 2.97983e-8, 0.961387396)
        end
    })

    -- ============================================================
    -- 武器传送 Tab
    -- ============================================================
    local GunsTab = Window:Tab({Title = "武器传送", Icon = "target"})
    
    GunsTab:Button({
        Title = "自动瞄准器",
        Callback = function()
            local p = game.Players.LocalPlayer
            local c = p.Character or p.CharacterAdded:Wait()
            local h = c:WaitForChild("HumanoidRootPart")
            h.CFrame = CFrame.new(-822.973816, 179.617432, -290.576813, -0.829824746, 4.1572e-8, 0.558024108, -1.7091425e-8, 1, -9.991484e-8, -0.558024108, -9.24494e-8, -0.829824746)
            task.wait(0.5)
            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.1)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
        end
    })
    
    GunsTab:Button({
        Title = "UMP 45",
        Callback = function()
            local p = game.Players.LocalPlayer
            local c = p.Character or p.CharacterAdded:Wait()
            local h = c:WaitForChild("HumanoidRootPart")
            h.CFrame = CFrame.new(1358.20264, 143.366074, -1218.008301, -0.711087286, 7.777568e-9, -0.703103721, 0.0004326, 1, 1.0624305e-8, 0.703103721, 7.2505e-9, -0.711087286)
            task.wait(0.5)
            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.1)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
        end
    })
    
    GunsTab:Button({
        Title = "贝内利M1014",
        Callback = function()
            local p = game.Players.LocalPlayer
            local c = p.Character or p.CharacterAdded:Wait()
            local h = c:WaitForChild("HumanoidRootPart")
            h.CFrame = CFrame.new(1345.20422, 141.041168, -4809.10693, -0.879722357, 4.0964014e-8, -0.475487679, 7.8684534e-9, 1, 7.159378e-8, 0.475487679, 5.92413e-8, -0.879722357)
            task.wait(0.5)
            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.1)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
        end
    })
    
    GunsTab:Button({
        Title = "M4A1",
        Callback = function()
            local p = game.Players.LocalPlayer
            local c = p.Character or p.CharacterAdded:Wait()
            local h = c:WaitForChild("HumanoidRootPart")
            h.CFrame = CFrame.new(-6342.43115, 134.380051, -1328.82861, -0.984255195, 1.02914e-8, 0.176753372, 1.648925e-8, 1, 3.359626e-8, -0.176753372, 3.59818e-8, -0.984255195)
            task.wait(0.5)
            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.1)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
        end
    })
    
    GunsTab:Button({
        Title = "AK-47",
        Callback = function()
            local p = game.Players.LocalPlayer
            local c = p.Character or p.CharacterAdded:Wait()
            local h = c:WaitForChild("HumanoidRootPart")
            h.CFrame = CFrame.new(-4825.20752, 21.3648071, 1192.14551, -0.907641709, 3.2050632e-8, -0.419745833, 5.61627e-8, 1, -4.508672e-8, 0.419745833, -6.44966e-8, -0.907641709)
            task.wait(0.5)
            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.1)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
        end
    })
    
    GunsTab:Button({
        Title = "RPG-7",
        Callback = function()
            local p = game.Players.LocalPlayer
            local c = p.Character or p.CharacterAdded:Wait()
            local h = c:WaitForChild("HumanoidRootPart")
            h.CFrame = CFrame.new(-1392.19739, 275.933319, 2199.5188, -0.999439657, -4.083614e-8, -0.0334718302, -4.136207e-8, 1, 1.50201e-8, 0.0334718302, 1.6396225e-8, -0.999439657)
            task.wait(0.5)
            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.1)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
        end
    })
    
    GunsTab:Button({
        Title = "乌兹",
        Callback = function()
            local p = game.Players.LocalPlayer
            local c = p.Character or p.CharacterAdded:Wait()
            local h = c:WaitForChild("HumanoidRootPart")
            h.CFrame = CFrame.new(-1348.55493, 1109.2014694, 2033.73645, -0.322550327, 6.191085e-8, -0.946552336, 8.2431725e-8, 1, 3.731697e-8, 0.946552336, -6.598934e-8, -0.322550327)
            task.wait(0.5)
            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.1)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
        end
    })

    -- ============================================================
    -- 娱乐 Tab（自动发言 + 天气 + 天空）
    -- ============================================================
    local EntertainmentTab = Window:Tab({Title = "娱乐", Icon = "settings"})

    _G.AUTO_CHAT_TEXT = "SX HUB ！！！"
    _G.AUTO_CHAT_ENABLED = false
    _G.AUTO_CHAT_INTERVAL = 1.5
    _G.AUTO_CHAT_MODE = "自定义"
    local chatSystem = {
        Players = game:GetService("Players"),
        ReplicatedStorage = game:GetService("ReplicatedStorage"),
        TextChatService = game:GetService("TextChatService"),
        messageIndex = 1,
        messageCount = 0,
        lastMessageTime = 0,
        chatModes = {
            ["自定义"] = function() return {_G.AUTO_CHAT_TEXT} end,
            ["7字经"] = function() return {"来老弟", "你有啥实力", "你活着干啥呢", "臭底层", "快来打压你爹", "我在这等着呢", "快来打压我"} end,
            ["14字经"] = function() return {"你有啥用", "你活着干啥呢", "赶紧跳了吧", "老弟家里几位在哪里", "来吧赶紧让我口吃", "你爹等着你呢", "你个窝囊废", "孩子快来呀", "怎么不敢和你爹对话了？", "你有什么用处", "你活着当技女吗？", "一句话", "来打压我", "哈哈哈笑死我了"} end,
            ["糖人语言"] = function() return {"我是奶龙", "奶龙是我", "你是谁？？", "我是谁", "你干嘛啊？"} end,
            ["宣传词"] = function() return {"SX HUB牛逼", "打败一切", "快来购买", "功能多多", "支持超多服务器"} end
        },
        connections = {},
        active = false
    }

    chatSystem.tryTextChatSend = function(msg)
        local ok = false
        pcall(function()
            local ch = chatSystem.TextChatService.TextChannels:FindFirstChild("RBXGeneral") or
                       chatSystem.TextChatService.TextChannels:FindFirstChild("RBXGeneralChannel")
            if ch and ch.SendAsync then
                ch:SendAsync(msg)
                ok = true
            end
        end)
        return ok
    end

    chatSystem.tryOldChatSend = function(msg)
        local ok = false
        pcall(function()
            local ev = chatSystem.ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            local req = ev and ev:FindFirstChild("SayMessageRequest")
            if req then
                req:FireServer(msg, "All")
                ok = true
            end
        end)
        return ok
    end

    chatSystem.tryPlayerChat = function(msg)
        local ok = false
        pcall(function()
            local pl = chatSystem.Players.LocalPlayer
            if pl and pl.Chat then
                pl:Chat(msg)
                ok = true
            end
        end)
        return ok
    end

    chatSystem.doSend = function(msg)
        local sent = false
        sent = chatSystem.tryTextChatSend(msg) or sent
        if not sent then sent = chatSystem.tryOldChatSend(msg) or sent end
        if not sent then sent = chatSystem.tryPlayerChat(msg) or sent end
        
        if sent then
            chatSystem.messageCount = chatSystem.messageCount + 1
            chatSystem.lastMessageTime = os.time()
        end
        return sent
    end

    chatSystem.startAutoChat = function()
        if chatSystem.active then return end
        chatSystem.active = true
        
        chatSystem.connections.autoChat = game:GetService("RunService").Heartbeat:Connect(function()
            if _G.AUTO_CHAT_ENABLED and chatSystem.chatModes[_G.AUTO_CHAT_MODE] then
                local currentTime = tick()
                local lastSendTime = chatSystem.lastSendTime or 0
                local interval = tonumber(_G.AUTO_CHAT_INTERVAL) or 1.5
                
                if currentTime - lastSendTime >= interval then
                    local messages = chatSystem.chatModes[_G.AUTO_CHAT_MODE]()
                    if messages and #messages > 0 then
                        local message = messages[chatSystem.messageIndex]
                        chatSystem.doSend(tostring(message))
                        chatSystem.messageIndex = (chatSystem.messageIndex % #messages) + 1
                        chatSystem.lastSendTime = currentTime
                    end
                end
            end
        end)
    end

    chatSystem.stopAutoChat = function()
        chatSystem.active = false
        if chatSystem.connections.autoChat then
            chatSystem.connections.autoChat:Disconnect()
            chatSystem.connections.autoChat = nil
        end
    end

    chatSystem.init = function()
        chatSystem.startAutoChat()
    end

    chatSystem.sendNow = function(message)
        if not message or message == "" then
            message = _G.AUTO_CHAT_TEXT
        end
        return chatSystem.doSend(message)
    end

    chatSystem.cleanup = function()
        for name, connection in pairs(chatSystem.connections) do
            if connection then
                pcall(function() connection:Disconnect() end)
            end
        end
        chatSystem.connections = {}
        chatSystem.active = false
    end

    task.spawn(chatSystem.init)

    EntertainmentTab:Dropdown({
        Title = "发言模式",
        Values = {"自定义", "7字经", "14字经", "糖人语言", "宣传词"},
        Value = "自定义",
        Callback = function(value)
            _G.AUTO_CHAT_MODE = value
            chatSystem.messageIndex = 1
            WindUI:Notify({ Title = "发言模式", Content = "已切换到: " .. value, Duration = 2, Icon = "message-circle" })
        end
    })

    EntertainmentTab:Input({
        Title = "自定义发言内容",
        Placeholder = "输入要发送的消息",
        Value = "SX HUB ！！！",
        Callback = function(value)
            _G.AUTO_CHAT_TEXT = value
            WindUI:Notify({ Title = "自定义内容", Content = "已设置: " .. value, Duration = 2, Icon = "edit" })
        end
    })

    EntertainmentTab:Toggle({
        Title = "开启自动发言",
        Value = false,
        Callback = function(value)
            _G.AUTO_CHAT_ENABLED = value
            if value and not chatSystem.active then
                chatSystem.startAutoChat()
            elseif not value then
                chatSystem.stopAutoChat()
            end
            WindUI:Notify({ Title = "自动发言", Content = value and "已开启" or "已关闭", Duration = 2, Icon = value and "play" or "square" })
        end
    })

    EntertainmentTab:Slider({
        Title = "发言间隔",
        Desc = "设置发送消息的时间间隔（秒）",
        Value = {Min = 0.5, Max = 10, Default = 1.5},
        Callback = function(value)
            _G.AUTO_CHAT_INTERVAL = value
            WindUI:Notify({ Title = "发言间隔", Content = "已设置为: " .. value .. "秒", Duration = 2, Icon = "clock" })
        end
    })

    _G.ChatSystem = chatSystem

    -- 天气系统
    local weatherSettings = {
        ["雨天"] = "Rainy",
        ["阴天"] = "Overcast",
        ["晴天"] = "Clear",
        ["雪天"] = "Snowy"
    }
    local selectedWeather = "晴天"

    local function changeWeather(weatherType)
        local lighting = game:GetService("Lighting")
        lighting.ClockTime = 14 
        lighting.Brightness = 1
        lighting.FogEnd = 10000
        lighting.GlobalShadows = true
        
        for _, obj in pairs(lighting:GetChildren()) do
            if obj:IsA("ParticleEmitter") or obj.Name == "WeatherEffect" then
                obj:Destroy()
            end
        end
        
        if weatherType == "Rainy" then
            lighting.Brightness = 0.7
            lighting.FogEnd = 5000
            lighting.ExposureCompensation = -0.5
            
            local rain = Instance.new("ParticleEmitter")
            rain.Name = "WeatherEffect"
            rain.Parent = lighting
            rain.Texture = "rbxassetid://2530913495"
            rain.Size = NumberSequence.new(0.5)
            rain.Transparency = NumberSequence.new(0.3)
            rain.Lifetime = NumberRange.new(5)
            rain.Rate = 100
            rain.Speed = NumberRange.new(20)
            rain.VelocitySpread = 90
            rain.Rotation = NumberRange.new(0, 360)
            rain.RotSpeed = NumberRange.new(10)
            rain.LightEmission = 0.1
            
        elseif weatherType == "Overcast" then
            lighting.Brightness = 0.6
            lighting.FogEnd = 3000
            lighting.ExposureCompensation = -0.8
            lighting.OutdoorAmbient = Color3.fromRGB(100, 100, 100)
            
        elseif weatherType == "Clear" then
            lighting.Brightness = 2
            lighting.FogEnd = 20000
            lighting.ExposureCompensation = 0.3
            lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            
        elseif weatherType == "Snowy" then
            lighting.Brightness = 1.2
            lighting.FogEnd = 8000
            lighting.ExposureCompensation = 0.1
            
            local snow = Instance.new("ParticleEmitter")
            snow.Name = "WeatherEffect"
            snow.Parent = lighting
            snow.Texture = "rbxassetid://2530914826"
            snow.Size = NumberSequence.new(0.3)
            snow.Transparency = NumberSequence.new(0.1)
            snow.Lifetime = NumberRange.new(8)
            snow.Rate = 80
            snow.Speed = NumberRange.new(5)
            snow.VelocitySpread = 45
            snow.Rotation = NumberRange.new(0, 360)
            snow.RotSpeed = NumberRange.new(5)
            snow.LightEmission = 0.5
            snow.LightInfluence = 0
        end
        
        print("天气已切换至: " .. weatherType)
    end

    EntertainmentTab:Dropdown({
        Title = "选择天气",
        Values = {"雨天", "阴天", "晴天", "雪天"},
        Value = "晴天",
        Callback = function(option)
            selectedWeather = option
        end
    })

    EntertainmentTab:Button({
        Title = "确认变换天气",
        Callback = function()
            changeWeather(weatherSettings[selectedWeather])
        end
    })

    -- 天空盒
    local skySettings = {
        ["神青天空1"] = "http://www.roblox.com/asset/?id=112666167201442",
        ["神青天空2"] = "http://www.roblox.com/asset/?id=105006817202266",
        ["动漫猫羽雫天空"] = "http://www.roblox.com/asset/?id=16060333448"
    }
    local selectedSky = "神青天空1"

    local function changeSky(skyboxId)
        local lighting = game:GetService("Lighting")
        
        for _, obj in pairs(lighting:GetChildren()) do
            if obj:IsA("Sky") then
                obj:Destroy()
            end
        end
        
        local sky = Instance.new("Sky")
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        sky.SkyboxUp = skyboxId
        sky.SkyboxBk = skyboxId
        sky.SkyboxDn = skyboxId
        sky.SkyboxRt = skyboxId
        sky.SkyboxLf = skyboxId
        sky.SkyboxFt = skyboxId
        
        print("天空已切换至: " .. selectedSky)
    end

    EntertainmentTab:Dropdown({
        Title = "选择天空盒",
        Values = {"神青天空1", "神青天空2", "动漫猫羽雫天空"},
        Value = "神青天空1",
        Callback = function(option)
            selectedSky = option
        end
    })

    EntertainmentTab:Button({
        Title = "确认变换天空",
        Callback = function()
            changeSky(skySettings[selectedSky])
        end
    })

    -- ============================================================
    -- 关闭/卸载处理
    -- ============================================================
    Window:OnClose(function()
        isDestroyed = true
        stopFlying()
        if aimConnection then
            aimConnection:Disconnect()
            aimConnection = nil
        end
        for _, conn in ipairs(connections) do
            pcall(function() conn:Disconnect() end)
        end
    end)

    Window:OnDestroy(function()
        isDestroyed = true
        stopFlying()
        if aimConnection then
            aimConnection:Disconnect()
            aimConnection = nil
        end
        for _, conn in ipairs(connections) do
            pcall(function() conn:Disconnect() end)
        end
    end)

    WindUI:Notify({
        Title = "SX HUB",
        Content = "脚本已加载成功，欢迎使用！",
        Duration = 3,
    })
end