local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()
local Confirmed = false

-- ==================== 彩虹渐变（保留原风格） ====================
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

-- ==================== 弹窗 ====================
WindUI:Popup({
    Title = '<font color="' .. gradientColors[1] .. '">wdfex-</font><font color="' .. gradientColors[5] .. '">通缉</font>',
    IconThemed = true,
    Icon = "crown",
    Content = "欢迎尊重的用户 " .. coloredUsername .. " \n使用wdfex-通缉",
    Buttons = {
        { Title = "取消", Callback = function() end, Variant = "Secondary" },
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

-- ==================== 主界面 ====================
function createUI()
    local Window = WindUI:CreateWindow({
        Title = 'wdfex-通缉',
        Icon = "crown",
        IconThemed = true,
        Author = "v3.0 by wdfex",
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
                WindUI:Notify({ Title = "点击了自己", Content = "没什么", Duration = 1, Icon = "4483362748" })
            end,
            Anonymous = false
        },
        SideBarWidth = 250,
        Search = {
            Enabled = true,
            Placeholder = "搜索...",
            Callback = function(searchText) print("搜索内容:", searchText) end
        },
        SidePanel = {
            Enabled = true,
            Content = {
                { Type = "Button", Text = "wdfex-通缉", Style = "Subtle", Size = UDim2.new(1, -20, 0, 30), Callback = function() end }
            }
        }
    })

    -- 开屏按钮彩虹动画
    Window:EditOpenButton({
        Title = "wdfex-通缉",
        Icon = "crown",
        CornerRadius = UDim.new(0, 16),
        StrokeThickness = 4,
        Color = ColorSequence.new(Color3.fromHex("FF6B6B")),
        Draggable = true,
    })
    Window:Tag({ Title = "正在寻求", Color = Color3.fromHex("#00008B") })
    Window:Tag({ Title = "3.0.1", Color = Color3.fromHex("#32CD32") })
    spawn(function()
        while true do
            for hue = 0, 1, 0.01 do
                local color = Color3.fromHSV(hue, 0.8, 1)
                Window:EditOpenButton({ Color = ColorSequence.new(color) })
                wait(0.04)
            end
        end
    end)

    -- ==================== 全局变量（来自第二个代码） ====================
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer
    local isDestroyed = false
    local connections = {}

    -- ==================== 飞行功能（完整复制） ====================
    local FlightControl = nil
    task.spawn(function()
        pcall(function()
            local pm = LocalPlayer.PlayerScripts:FindFirstChild("PlayerModule")
            if pm then FlightControl = require(pm):GetControls() end
        end)
    end)
    local FlyingEnabled = false
    local SpinningEnabled = false
    local FlightSpeed = 50
    local SpinSpeed = 5
    local CurrentAO, CurrentLV, CurrentMoverAttachment
    local FlightConnection
    local Control = { F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0 }
    local function getControlModule()
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
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        if not character then return end
        FlyingEnabled = true
        SpinningEnabled = false
        if CurrentAO then CurrentAO:Destroy() end
        if CurrentLV then CurrentLV:Destroy() end
        if CurrentMoverAttachment then CurrentMoverAttachment:Destroy() end
        CurrentAO, CurrentLV, humanoid, CurrentMoverAttachment = setupBodyMovers(character)
        local controlModule = getControlModule()
        FlightConnection = RunService.Heartbeat:Connect(function()
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
            if not parent and FlyingEnabled then stopFlying() end
        end)
    end
    local function stopFlying()
        if not FlyingEnabled then return end
        FlyingEnabled = false
        SpinningEnabled = false
        Control = { F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0 }
        if FlightConnection then
            FlightConnection:Disconnect()
            FlightConnection = nil
        end
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.PlatformStand = false
        end
        if CurrentAO then CurrentAO:Destroy() CurrentAO = nil end
        if CurrentLV then CurrentLV:Destroy() CurrentLV = nil end
        if CurrentMoverAttachment then CurrentMoverAttachment:Destroy() CurrentMoverAttachment = nil end
    end
    local function toggleSpinning()
        if not FlyingEnabled then return end
        SpinningEnabled = not SpinningEnabled
    end
    LocalPlayer.CharacterAdded:Connect(function()
        if FlyingEnabled then
            stopFlying()
            task.wait(0.2)
            startFlying()
        end
    end)

    -- 速度增加
    local SpeedHack = false
    local SpeedValue = 16
    local speedConnection = nil
    local function toggleSpeedHack(v)
        SpeedHack = v
        if v then
            speedConnection = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum and hum.MoveDirection.Magnitude > 0 then
                    char:TranslateBy(hum.MoveDirection * SpeedValue / 10)
                end
            end)
        else
            if speedConnection then speedConnection:Disconnect() speedConnection = nil end
        end
    end

    -- 扩大视野
    local fovConnection = nil
    local function toggleFOV(v)
        if v then
            fovConnection = RunService.Heartbeat:Connect(function()
                workspace.CurrentCamera.FieldOfView = 120
            end)
        elseif fovConnection then
            fovConnection:Disconnect()
            fovConnection = nil
        end
    end

    -- 无限跳
    local jumpConn = nil
    local function toggleInfiniteJump(v)
        if v then
            jumpConn = UserInputService.JumpRequest:Connect(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        else
            if jumpConn then jumpConn:Disconnect() jumpConn = nil end
        end
    end

    -- ==================== 战斗功能变量 ====================
    local ForceLoadAll = false
    local AutoShoot = false
    local ShooterModule = nil
    local OriginalShoot = nil
    local AutoSell = false
    local AutoBankCash = false
    local HitATMAura = false
    local AutoATM = false
    local AutoRegister = false
    local AutoGold = false
    local AutoWorldItem = false
    local AutoSilverBar = false
    local AutoSapphire = false
    local ImmuneTurret = false
    local oldFireServer = nil

    -- ==================== 自瞄相关（完整复制） ====================
    local isAiming = false
    local isPredicting = false
    local isLowHealthPriority = false
    local fov = 50
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
    local useAdvancedPrediction = false
    local predictionType = "线性"
    local advancedPredictionFactor = 1.2
    local bulletSpeed = 500
    local gravityFactor = 9.8
    local pingCompensation = 0.1
    local isAutoShoot = false
    local shootDelay = 0.1
    local lastShotTime = 0
    local shootRange = 500
    local autoShootFov = 100
    local isBurstFire = false
    local burstCount = 3
    local burstDelay = 0.1
    local isRapidFire = false
    local rapidFireRate = 0.05
    local isTriggerBot = false
    local triggerDelay = 0.2
    local triggerHoldTime = 0.1
    local targetVisibleTime = 0
    local isAutoShootOnAim = false
    local isSmartAim = false
    local smartAimThreshold = 0.8
    local isLagCompensation = false
    local lagCompensationTime = 0.1
    local autoShootConnection = nil
    local isAutoShootingActive = false

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
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if teamCheck and player.Team == LocalPlayer.Team then continue end
                local character = player.Character
                if character and character:FindFirstChild(targetPart) then
                    if aliveCheck and (not character:FindFirstChildOfClass("Humanoid") or character:FindFirstChildOfClass("Humanoid").Health <= 0) then continue end
                    local part = character[targetPart]
                    local ePos, isVisible = Cam:WorldToViewportPoint(part.Position)
                    local screenDistance = (Vector2.new(ePos.x, ePos.y) - playerMousePos).Magnitude
                    if screenDistance < fovToUse and isVisible then
                        local distance = (LocalPlayer.Character and LocalPlayer.Character.PrimaryPart and (part.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude) or math.huge
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
        if useAdvancedPrediction then
            local character = player.Character
            if not character or not character:FindFirstChild(targetPart) then return end
            local part = character[targetPart]
            local velocity = part.Velocity
            local distance = (part.Position - Cam.CFrame.Position).Magnitude
            if predictionType == "线性" then
                local travelTime = distance / bulletSpeed
                return part.Position + velocity * travelTime
            elseif predictionType == "抛物线" then
                local travelTime = distance / bulletSpeed
                local predictedPos = part.Position + velocity * travelTime
                local drop = Vector3.new(0, -0.5 * gravityFactor * travelTime ^ 2, 0)
                return predictedPos + drop
            elseif predictionType == "自适应" then
                local targetSpeed = velocity.Magnitude
                local adaptiveFactor = 1 + (targetSpeed / 50) * advancedPredictionFactor
                local travelTime = distance / bulletSpeed
                return part.Position + velocity * travelTime * adaptiveFactor
            end
            return part.Position
        else
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
            local shake = Vector3.new((math.random() - 0.5) * 0.1, (math.random() - 0.5) * 0.1, 0)
            Cam.CFrame = CFrame.new(currentCFrame.Position, currentCFrame.Position + lookVector + shake)
        end
    end

    local function aimLoop()
        if not isAiming then return end
        updateDrawings()
        local now = tick()
        local deltaTime = 0.016
        if aimLock and lockedPlayer and now - lastLockTime < lockDuration then
            if lockedPlayer.Character and lockedPlayer.Character:FindFirstChild(targetPart) then
                local targetPos = getPredictedPosition(lockedPlayer, deltaTime)
                if targetPos then smartAimAt(targetPos) end
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

    local function initializeAutoShootModule()
        if not ShooterModule then
            local success, module = pcall(function()
                return require(ReplicatedStorage.Client.Wanted.Objects.ClientTool.Components.Guns.Shooter)
            end)
            if success and module then
                ShooterModule = module
                OriginalShoot = module._shoot
                return true
            end
        end
        return ShooterModule ~= nil
    end

    local function getLockedTargetPosition()
        if not isAiming then return nil end
        if aimLock and lockedPlayer and tick() - lastLockTime < lockDuration then
            if lockedPlayer.Character and lockedPlayer.Character:FindFirstChild(targetPart) then
                return lockedPlayer.Character[targetPart].Position
            end
        else
            local target = getClosestPlayerInFOV()
            if target and target.Character and target.Character:FindFirstChild(targetPart) then
                if aimLock then
                    lockedPlayer = target
                    lastLockTime = tick()
                end
                return target.Character[targetPart].Position
            end
        end
        return nil
    end

    local function hasLineOfSight(shooterPos, targetPos)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.FilterDescendantsInstances = { LocalPlayer.Character }
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

    local function createBeautifulTrail(origin, targetPos)
        local function createBezierCurve(p0, p1, p2, t)
            return (1 - t) ^ 2 * p0 + 2 * (1 - t) * t * p1 + t ^ 2 * p2
        end
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
            beamPart.CFrame = CFrame.new(startPoint, endPoint) * CFrame.new(0, 0, -distance / 2)
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

    local function hookAutoShoot()
        if not ShooterModule or not OriginalShoot then
            if not initializeAutoShootModule() then return end
        end
        ShooterModule._shoot = function(self)
            if not self or not self.tool then return OriginalShoot(self) end
            local LocalCharacter = LocalPlayer.Character
            if not LocalCharacter then return OriginalShoot(self) end
            local targetPos = getLockedTargetPosition()
            if targetPos and isAiming and isAutoShootOnAim then
                local shooterPos = LocalCharacter.HumanoidRootPart and LocalCharacter.HumanoidRootPart.Position or LocalCharacter.PrimaryPart.Position
                if hasLineOfSight(shooterPos, targetPos) then
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
                    if self.tool then self.tool.shooting = false end
                end
            end
            return OriginalShoot(self)
        end
    end

    local function startAutoShootLoop()
        if autoShootConnection then autoShootConnection:Disconnect() end
        autoShootConnection = RunService.Heartbeat:Connect(function()
            if not isAiming or not isAutoShootOnAim then return end
            local targetPos = getLockedTargetPosition()
            if not targetPos then return end
            local LocalCharacter = LocalPlayer.Character
            if not LocalCharacter then return end
            local now = tick()
            if now - lastShotTime < shootDelay then return end
            local tool = LocalCharacter:FindFirstChildWhichIsA("Tool")
            if not tool then return end
            local shooter = tool:FindFirstChild("Shooter") or { tool = tool }
            if ShooterModule and ShooterModule._shoot then
                pcall(function() ShooterModule._shoot(shooter) end)
            end
            lastShotTime = now
        end)
        isAutoShootingActive = true
    end

    local function stopAutoShoot()
        if autoShootConnection then autoShootConnection:Disconnect() autoShootConnection = nil end
        isAutoShootingActive = false
        if ShooterModule and OriginalShoot then
            ShooterModule._shoot = OriginalShoot
        end
    end

    -- ==================== ESP（完整复制） ====================
    local ESPConfig = {
        ESPEnabled = false,
        ShowBox = false,
        ShowHealth = false,
        ShowName = false,
        ShowDistance = false,
        ShowTracer = false,
        TeamCheck = false,
        ShowSkeleton = false,
        ShowRadar = false,
        ShowPlayerCount = false,
        ShowWeapon = false,
        ShowFOV = false,
        OutOfViewArrows = false,
        Chams = false,
        TracerColor = Color3.new(1, 0, 0),
        SkeletonColor = Color3.new(0.2, 0.8, 1),
        BoxColor = Color3.new(1, 1, 1),
        HealthBarColor = Color3.new(0, 1, 0),
        HealthTextColor = Color3.new(1, 1, 1),
        NameColor = Color3.new(1, 1, 1),
        DistanceColor = Color3.new(1, 1, 0),
        WeaponColor = Color3.new(1, 0.5, 0),
        ArrowColor = Color3.new(1, 0, 0),
        FOVColor = Color3.new(1, 1, 1),
        ChamsColor = Color3.new(1, 0, 0),
        BoxThickness = 1,
        TracerThickness = 1,
        SkeletonThickness = 2,
        FOVRadius = 100,
        ArrowSize = 15
    }
    local ESPComponents = {}
    local radar = Drawing.new("Circle")
    radar.Visible = false
    radar.Color = Color3.new(1, 1, 1)
    radar.Thickness = 2
    radar.Filled = false
    radar.Radius = 100
    radar.Position = Vector2.new(Cam.ViewportSize.X - 120, 120)
    local radarCenter = Drawing.new("Circle")
    radarCenter.Visible = false
    radarCenter.Color = Color3.new(1, 1, 1)
    radarCenter.Thickness = 2
    radarCenter.Filled = true
    radarCenter.Radius = 3
    radarCenter.Position = radar.Position
    local radarDirection = Drawing.new("Line")
    radarDirection.Visible = false
    radarDirection.Color = Color3.new(1, 1, 1)
    radarDirection.Thickness = 2
    local radarGridLines = {}
    for i = 1, 4 do
        radarGridLines[i] = Drawing.new("Line")
        radarGridLines[i].Visible = false
        radarGridLines[i].Color = Color3.new(0.5, 0.5, 0.5)
        radarGridLines[i].Thickness = 1
    end
    local radarRangeText = Drawing.new("Text")
    radarRangeText.Visible = false
    radarRangeText.Color = Color3.new(1, 1, 1)
    radarRangeText.Size = 14
    radarRangeText.Font = Drawing.Fonts.Monospace
    radarRangeText.Outline = true
    radarRangeText.OutlineColor = Color3.new(0, 0, 0)
    radarRangeText.Text = "100m"
    local radarPlayers = {}
    local playerCountText = Drawing.new("Text")
    playerCountText.Visible = false
    playerCountText.Color = Color3.new(1, 1, 1)
    playerCountText.Size = 20
    playerCountText.Font = Drawing.Fonts.Monospace
    playerCountText.Outline = true
    playerCountText.OutlineColor = Color3.new(0, 0, 0)
    playerCountText.Position = Vector2.new(Cam.ViewportSize.X / 2, 10)
    local fovCircle = Drawing.new("Circle")
    fovCircle.Visible = false
    fovCircle.Color = ESPConfig.FOVColor
    fovCircle.Thickness = 1
    fovCircle.Filled = false
    fovCircle.Radius = ESPConfig.FOVRadius
    fovCircle.Position = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)

    local function updatePlayerCount()
        local count = #Players:GetPlayers()
        playerCountText.Text = "在线玩家: " .. count
        playerCountText.Visible = ESPConfig.ESPEnabled and ESPConfig.ShowPlayerCount
        local time = tick()
        local r = math.sin(time * 2) * 0.5 + 0.5
        local g = math.sin(time * 3) * 0.5 + 0.5
        local b = math.sin(time * 4) * 0.5 + 0.5
        playerCountText.Color = Color3.new(r, g, b)
    end
    local function updateFOV()
        fovCircle.Visible = ESPConfig.ShowFOV
        fovCircle.Color = ESPConfig.FOVColor
        fovCircle.Radius = ESPConfig.FOVRadius
        fovCircle.Position = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)
    end
    local function createESP(player)
        local box = Drawing.new("Square")
        box.Visible = false
        box.Color = ESPConfig.BoxColor
        box.Thickness = ESPConfig.BoxThickness
        box.Filled = false
        local healthBar = Drawing.new("Square")
        healthBar.Visible = false
        healthBar.Color = ESPConfig.HealthBarColor
        healthBar.Thickness = 1
        healthBar.Filled = true
        local healthBarBackground = Drawing.new("Square")
        healthBarBackground.Visible = false
        healthBarBackground.Color = Color3.new(0, 0, 0)
        healthBarBackground.Transparency = 0.5
        healthBarBackground.Thickness = 1
        healthBarBackground.Filled = true
        local healthBarBorder = Drawing.new("Square")
        healthBarBorder.Visible = false
        healthBarBorder.Color = Color3.new(1, 1, 1)
        healthBarBorder.Thickness = 1
        healthBarBorder.Filled = false
        local healthText = Drawing.new("Text")
        healthText.Visible = false
        healthText.Color = ESPConfig.HealthTextColor
        healthText.Size = 14
        healthText.Font = Drawing.Fonts.Monospace
        healthText.Outline = true
        healthText.OutlineColor = Color3.new(0, 0, 0)
        local nameText = Drawing.new("Text")
        nameText.Visible = false
        nameText.Color = ESPConfig.NameColor
        nameText.Size = 16
        nameText.Font = Drawing.Fonts.Monospace
        nameText.Outline = true
        nameText.OutlineColor = Color3.new(0, 0, 0)
        local distanceText = Drawing.new("Text")
        distanceText.Visible = false
        distanceText.Color = ESPConfig.DistanceColor
        distanceText.Size = 14
        distanceText.Font = Drawing.Fonts.Monospace
        distanceText.Outline = true
        distanceText.OutlineColor = Color3.new(0, 0, 0)
        local weaponText = Drawing.new("Text")
        weaponText.Visible = false
        weaponText.Color = ESPConfig.WeaponColor
        weaponText.Size = 14
        weaponText.Font = Drawing.Fonts.Monospace
        weaponText.Outline = true
        weaponText.OutlineColor = Color3.new(0, 0, 0)
        local tracer = Drawing.new("Line")
        tracer.Visible = false
        tracer.Color = ESPConfig.TracerColor
        tracer.Thickness = ESPConfig.TracerThickness
        local arrow = Drawing.new("Triangle")
        arrow.Visible = false
        arrow.Color = ESPConfig.ArrowColor
        arrow.Filled = true
        arrow.Thickness = 1
        local skeletonLines = {}
        local skeletonPoints = {}
        for i = 1, 15 do
            skeletonLines[i] = Drawing.new("Line")
            skeletonLines[i].Visible = false
            skeletonLines[i].Color = ESPConfig.SkeletonColor
            skeletonLines[i].Thickness = ESPConfig.SkeletonThickness
        end
        skeletonPoints["Head"] = Drawing.new("Circle")
        skeletonPoints["Head"].Visible = false
        skeletonPoints["Head"].Color = Color3.new(1, 0.5, 0)
        skeletonPoints["Head"].Thickness = 2
        skeletonPoints["Head"].Filled = true
        skeletonPoints["Head"].Radius = 4
        local lastHealth = 100
        local healthChangeTime = 0
        local smoothHealth = 100
        ESPComponents[player] = {
            box = box, healthBar = healthBar, healthBarBackground = healthBarBackground,
            healthBarBorder = healthBarBorder, healthText = healthText,
            nameText = nameText, distanceText = distanceText, weaponText = weaponText,
            tracer = tracer, arrow = arrow, skeletonLines = skeletonLines, skeletonPoints = skeletonPoints
        }
        RunService.RenderStepped:Connect(function()
            if not ESPConfig.ESPEnabled or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") or not player.Character:FindFirstChild("Humanoid") or player == LocalPlayer then
                box.Visible = false; healthBar.Visible = false; healthBarBackground.Visible = false; healthBarBorder.Visible = false; healthText.Visible = false; nameText.Visible = false; distanceText.Visible = false; weaponText.Visible = false; tracer.Visible = false; arrow.Visible = false
                for _, line in pairs(skeletonLines) do line.Visible = false end
                for _, point in pairs(skeletonPoints) do point.Visible = false end
                return
            end
            if ESPConfig.TeamCheck and player.Team == LocalPlayer.Team then
                box.Visible = false; healthBar.Visible = false; healthBarBackground.Visible = false; healthBarBorder.Visible = false; healthText.Visible = false; nameText.Visible = false; distanceText.Visible = false; weaponText.Visible = false; tracer.Visible = false; arrow.Visible = false
                for _, line in pairs(skeletonLines) do line.Visible = false end
                for _, point in pairs(skeletonPoints) do point.Visible = false end
                return
            end
            local character = player.Character
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChild("Humanoid")
            if rootPart and humanoid and humanoid.Health > 0 then
                local rootPos, onScreen = Cam:WorldToViewportPoint(rootPart.Position)
                local headPos, _ = Cam:WorldToViewportPoint(rootPart.Position + Vector3.new(0, 3, 0))
                local legPos, _ = Cam:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
                local weaponName = "无武器"
                for _, tool in ipairs(character:GetChildren()) do
                    if tool:IsA("Tool") then weaponName = tool.Name break end
                end
                if ESPConfig.ShowBox and onScreen then
                    box.Size = Vector2.new(1000 / rootPos.Z, headPos.Y - legPos.Y)
                    box.Position = Vector2.new(rootPos.X - box.Size.X / 2, rootPos.Y - box.Size.Y / 2)
                    box.Visible = true
                    box.Color = ESPConfig.BoxColor
                    box.Thickness = ESPConfig.BoxThickness
                else box.Visible = false end
                if ESPConfig.ShowHealth and onScreen then
                    local healthPercentage = humanoid.Health / humanoid.MaxHealth
                    local barWidth = 50
                    local barHeight = 5
                    local barX = headPos.X - barWidth / 2
                    local barY = headPos.Y - 20
                    healthBarBackground.Size = Vector2.new(barWidth, barHeight)
                    healthBarBackground.Position = Vector2.new(barX, barY)
                    healthBarBackground.Visible = true
                    healthBarBorder.Size = Vector2.new(barWidth, barHeight)
                    healthBarBorder.Position = Vector2.new(barX, barY)
                    healthBarBorder.Visible = true
                    smoothHealth = smoothHealth + (humanoid.Health - smoothHealth) * 0.1
                    local smoothHealthPercentage = smoothHealth / humanoid.MaxHealth
                    healthBar.Size = Vector2.new(barWidth * smoothHealthPercentage, barHeight)
                    healthBar.Position = Vector2.new(barX, barY)
                    if smoothHealthPercentage >= 0.8 then healthBar.Color = Color3.new(0, 1, 0)
                    elseif smoothHealthPercentage >= 0.5 then healthBar.Color = Color3.new(1, 1, 0)
                    elseif smoothHealthPercentage >= 0.2 then healthBar.Color = Color3.new(1, 0.5, 0)
                    else healthBar.Color = Color3.new(1, 0, 0) end
                    healthBar.Visible = true
                    if humanoid.Health ~= lastHealth then healthChangeTime = tick() lastHealth = humanoid.Health end
                    if tick() - healthChangeTime < 0.5 then healthBar.Color = Color3.new(1, 0, 0) end
                    healthText.Position = Vector2.new(barX + barWidth + 5, barY - 5)
                    healthText.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                    healthText.Visible = true
                else
                    healthBar.Visible = false; healthBarBackground.Visible = false; healthBarBorder.Visible = false; healthText.Visible = false
                end
                if ESPConfig.ShowName and onScreen then
                    nameText.Position = Vector2.new(headPos.X, headPos.Y - 35)
                    nameText.Text = player.Name
                    nameText.Visible = true
                    if ESPConfig.ShowDistance then
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                        distanceText.Position = Vector2.new(headPos.X, headPos.Y + 10)
                        distanceText.Text = math.floor(distance) .. "m"
                        distanceText.Visible = true
                    else distanceText.Visible = false end
                    if ESPConfig.ShowWeapon then
                        weaponText.Position = Vector2.new(headPos.X, headPos.Y - 50)
                        weaponText.Text = weaponName
                        weaponText.Visible = true
                    else weaponText.Visible = false end
                else
                    nameText.Visible = false; distanceText.Visible = false; weaponText.Visible = false
                end
                if ESPConfig.ShowTracer then
                    local head = character:FindFirstChild("Head")
                    if head then
                        local headPos, onScreen = Cam:WorldToViewportPoint(head.Position)
                        if onScreen then
                            tracer.From = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y)
                            tracer.To = Vector2.new(headPos.X, headPos.Y)
                            tracer.Visible = true
                            tracer.Color = ESPConfig.TracerColor
                            tracer.Thickness = ESPConfig.TracerThickness
                            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                            if distance < 20 then tracer.Color = Color3.new(0, 1, 0)
                            elseif distance < 50 then tracer.Color = Color3.new(1, 1, 0)
                            else tracer.Color = ESPConfig.TracerColor end
                        else tracer.Visible = false end
                    else tracer.Visible = false end
                else tracer.Visible = false end
                if ESPConfig.OutOfViewArrows and not onScreen then
                    local direction = (rootPart.Position - Cam.CFrame.Position).Unit
                    local dotProduct = Cam.CFrame.RightVector:Dot(direction)
                    local crossProduct = Cam.CFrame.RightVector:Cross(direction)
                    local screenPosition = Vector2.new(
                        Cam.ViewportSize.X / 2 + dotProduct * Cam.ViewportSize.X / 3,
                        Cam.ViewportSize.Y / 2 - crossProduct.Y * Cam.ViewportSize.Y / 3
                    )
                    screenPosition = Vector2.new(
                        math.clamp(screenPosition.X, ESPConfig.ArrowSize, Cam.ViewportSize.X - ESPConfig.ArrowSize),
                        math.clamp(screenPosition.Y, ESPConfig.ArrowSize, Cam.ViewportSize.Y - ESPConfig.ArrowSize)
                    )
                    local angle = math.atan2(screenPosition.Y - Cam.ViewportSize.Y / 2, screenPosition.X - Cam.ViewportSize.X / 2)
                    arrow.PointA = screenPosition
                    arrow.PointB = Vector2.new(screenPosition.X - ESPConfig.ArrowSize * math.cos(angle - 0.5), screenPosition.Y - ESPConfig.ArrowSize * math.sin(angle - 0.5))
                    arrow.PointC = Vector2.new(screenPosition.X - ESPConfig.ArrowSize * math.cos(angle + 0.5), screenPosition.Y - ESPConfig.ArrowSize * math.sin(angle + 0.5))
                    arrow.Color = ESPConfig.ArrowColor
                    arrow.Visible = true
                else arrow.Visible = false end
                if ESPConfig.ShowSkeleton and onScreen then
                    local head = character:FindFirstChild("Head")
                    local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
                    local leftArm = character:FindFirstChild("Left Arm") or character:FindFirstChild("LeftUpperArm")
                    local rightArm = character:FindFirstChild("Right Arm") or character:FindFirstChild("RightUpperArm")
                    local leftLeg = character:FindFirstChild("Left Leg") or character:FindFirstChild("LeftUpperLeg")
                    local rightLeg = character:FindFirstChild("Right Leg") or character:FindFirstChild("RightUpperLeg")
                    if head and torso and leftArm and rightArm and leftLeg and rightLeg then
                        local headPos = Cam:WorldToViewportPoint(head.Position)
                        local torsoPos = Cam:WorldToViewportPoint(torso.Position)
                        local leftArmPos = Cam:WorldToViewportPoint(leftArm.Position)
                        local rightArmPos = Cam:WorldToViewportPoint(rightArm.Position)
                        local leftLegPos = Cam:WorldToViewportPoint(leftLeg.Position)
                        local rightLegPos = Cam:WorldToViewportPoint(rightLeg.Position)
                        skeletonPoints["Head"].Position = Vector2.new(headPos.X, headPos.Y)
                        skeletonPoints["Head"].Visible = true
                        skeletonLines[1].From = Vector2.new(headPos.X, headPos.Y)
                        skeletonLines[1].To = Vector2.new(torsoPos.X, torsoPos.Y)
                        skeletonLines[1].Visible = true
                        skeletonLines[2].From = Vector2.new(torsoPos.X, torsoPos.Y)
                        skeletonLines[2].To = Vector2.new(leftArmPos.X, leftArmPos.Y)
                        skeletonLines[2].Visible = true
                        skeletonLines[3].From = Vector2.new(torsoPos.X, torsoPos.Y)
                        skeletonLines[3].To = Vector2.new(rightArmPos.X, rightArmPos.Y)
                        skeletonLines[3].Visible = true
                        skeletonLines[4].From = Vector2.new(torsoPos.X, torsoPos.Y)
                        skeletonLines[4].To = Vector2.new(leftLegPos.X, leftLegPos.Y)
                        skeletonLines[4].Visible = true
                        skeletonLines[5].From = Vector2.new(torsoPos.X, torsoPos.Y)
                        skeletonLines[5].To = Vector2.new(rightLegPos.X, rightLegPos.Y)
                        skeletonLines[5].Visible = true
                        if character:FindFirstChild("LeftLowerArm") then
                            local leftLowerArmPos = Cam:WorldToViewportPoint(character.LeftLowerArm.Position)
                            skeletonLines[6].From = Vector2.new(leftArmPos.X, leftArmPos.Y)
                            skeletonLines[6].To = Vector2.new(leftLowerArmPos.X, leftLowerArmPos.Y)
                            skeletonLines[6].Visible = true
                        end
                        if character:FindFirstChild("RightLowerArm") then
                            local rightLowerArmPos = Cam:WorldToViewportPoint(character.RightLowerArm.Position)
                            skeletonLines[7].From = Vector2.new(rightArmPos.X, rightArmPos.Y)
                            skeletonLines[7].To = Vector2.new(rightLowerArmPos.X, rightLowerArmPos.Y)
                            skeletonLines[7].Visible = true
                        end
                        if character:FindFirstChild("LeftLowerLeg") then
                            local leftLowerLegPos = Cam:WorldToViewportPoint(character.LeftLowerLeg.Position)
                            skeletonLines[8].From = Vector2.new(leftLegPos.X, leftLegPos.Y)
                            skeletonLines[8].To = Vector2.new(leftLowerLegPos.X, leftLowerLegPos.Y)
                            skeletonLines[8].Visible = true
                        end
                        if character:FindFirstChild("RightLowerLeg") then
                            local rightLowerLegPos = Cam:WorldToViewportPoint(character.RightLowerLeg.Position)
                            skeletonLines[9].From = Vector2.new(rightLegPos.X, rightLegPos.Y)
                            skeletonLines[9].To = Vector2.new(rightLowerLegPos.X, rightLowerLegPos.Y)
                            skeletonLines[9].Visible = true
                        end
                    else
                        for _, line in pairs(skeletonLines) do line.Visible = false end
                        for _, point in pairs(skeletonPoints) do point.Visible = false end
                    end
                else
                    for _, line in pairs(skeletonLines) do line.Visible = false end
                    for _, point in pairs(skeletonPoints) do point.Visible = false end
                end
            else
                box.Visible = false; healthBar.Visible = false; healthBarBackground.Visible = false; healthBarBorder.Visible = false; healthText.Visible = false; nameText.Visible = false; distanceText.Visible = false; weaponText.Visible = false; tracer.Visible = false; arrow.Visible = false
                for _, line in pairs(skeletonLines) do line.Visible = false end
                for _, point in pairs(skeletonPoints) do point.Visible = false end
            end
        end)
    end

    local function updateRadar()
        if not ESPConfig.ShowRadar then
            radar.Visible = false; radarCenter.Visible = false; radarDirection.Visible = false; radarRangeText.Visible = false
            for _, line in pairs(radarGridLines) do line.Visible = false end
            for _, player in pairs(radarPlayers) do
                if player.dot then player.dot.Visible = false end
                if player.direction then player.direction.Visible = false end
                if player.name then player.name.Visible = false end
            end
            return
        end
        radar.Visible = true; radarCenter.Visible = true; radarDirection.Visible = true; radarRangeText.Visible = true
        radarRangeText.Position = Vector2.new(radar.Position.X, radar.Position.Y + radar.Radius + 5)
        for i = 1, 4 do
            local angle = (i - 1) * math.pi / 2
            radarGridLines[i].From = radar.Position
            radarGridLines[i].To = Vector2.new(radar.Position.X + math.cos(angle) * radar.Radius, radar.Position.Y + math.sin(angle) * radar.Radius)
            radarGridLines[i].Visible = true
        end
        radarDirection.From = radar.Position
        radarDirection.To = Vector2.new(radar.Position.X, radar.Position.Y - radar.Radius)
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= LocalPlayer then
                local rootPart = player.Character.HumanoidRootPart
                local relativePosition = rootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position
                local radarX = radar.Position.X + (relativePosition.X / 10)
                local radarY = radar.Position.Y + (relativePosition.Z / 10)
                local distanceFromCenter = math.sqrt((radarX - radar.Position.X) ^ 2 + (radarY - radar.Position.Y) ^ 2)
                if distanceFromCenter > radar.Radius then
                    local angle = math.atan2(radarY - radar.Position.Y, radarX - radar.Position.X)
                    radarX = radar.Position.X + math.cos(angle) * radar.Radius
                    radarY = radar.Position.Y + math.sin(angle) * radar.Radius
                end
                if not radarPlayers[player] then
                    radarPlayers[player] = {
                        dot = Drawing.new("Circle"),
                        direction = Drawing.new("Line"),
                        name = Drawing.new("Text")
                    }
                    radarPlayers[player].dot.Thickness = 1
                    radarPlayers[player].dot.Filled = true
                    radarPlayers[player].dot.Radius = 4
                    radarPlayers[player].direction.Thickness = 2
                    radarPlayers[player].direction.Visible = true
                    radarPlayers[player].name.Size = 12
                    radarPlayers[player].name.Font = Drawing.Fonts.Monospace
                    radarPlayers[player].name.Outline = true
                    radarPlayers[player].name.OutlineColor = Color3.new(0, 0, 0)
                end
                if player.Team == LocalPlayer.Team then
                    radarPlayers[player].dot.Color = Color3.new(0, 1, 0)
                    radarPlayers[player].direction.Color = Color3.new(0, 0.8, 0)
                    radarPlayers[player].name.Color = Color3.new(0, 1, 0)
                else
                    radarPlayers[player].dot.Color = Color3.new(1, 0, 0)
                    radarPlayers[player].direction.Color = Color3.new(1, 0, 0)
                    radarPlayers[player].name.Color = Color3.new(1, 0, 0)
                end
                radarPlayers[player].dot.Position = Vector2.new(radarX, radarY)
                radarPlayers[player].dot.Visible = true
                local lookVector = rootPart.CFrame.LookVector
                local directionLength = 10
                radarPlayers[player].direction.From = Vector2.new(radarX, radarY)
                radarPlayers[player].direction.To = Vector2.new(radarX + lookVector.X * directionLength, radarY + lookVector.Z * directionLength)
                radarPlayers[player].name.Position = Vector2.new(radarX, radarY - 15)
                radarPlayers[player].name.Text = player.Name
                radarPlayers[player].name.Visible = distanceFromCenter <= radar.Radius
            elseif radarPlayers[player] then
                radarPlayers[player].dot.Visible = false
                radarPlayers[player].direction.Visible = false
                radarPlayers[player].name.Visible = false
            end
        end
        for player, components in pairs(radarPlayers) do
            if not Players:FindFirstChild(player.Name) then
                components.dot.Visible = false
                components.direction.Visible = false
                components.name.Visible = false
                radarPlayers[player] = nil
            end
        end
    end

    -- ==================== 娱乐功能变量 ====================
    _G.AUTO_CHAT_TEXT = "wdfex-通缉"
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
            ["自定义"] = function() return { _G.AUTO_CHAT_TEXT } end,
            ["7字经"] = function() return { "我没有妈妈", "我没有爸爸", "我妈死了", "我全家没了", "爸爸", "爷爷", "妈妈" } end,
            ["14字经"] = function() return { "我有啥用", "我活着干啥呢", "我赶紧跳了吧", "我没有鸡8", "你是我爸爸", "你是我爷爷", "我个窝囊废", "孩子快来呀", "怎么不敢和你爹对话了？", "你有什么用处", "你活着当技女吗？", "一句话", "来打压我", "哈哈哈笑死我了" } end,
            ["糖人语言"] = function() return { "我是奶龙", "奶龙是我", "你是谁？？", "我是谁", "你干嘛啊？" } end,
            ["宣传词"] = function() return { "wdfex-Hub牛逼", "打败一切", "快来购买", "功能多多", "支持超多服务器" } end
        },
        connections = {},
        active = false
    }
    chatSystem.tryTextChatSend = function(msg)
        local ok = false
        pcall(function()
            local ch = chatSystem.TextChatService.TextChannels:FindFirstChild("RBXGeneral") or
                chatSystem.TextChatService.TextChannels:FindFirstChild("RBXGeneralChannel")
            if ch and ch.SendAsync then ch:SendAsync(msg) ok = true end
        end)
        return ok
    end
    chatSystem.tryOldChatSend = function(msg)
        local ok = false
        pcall(function()
            local ev = chatSystem.ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            local req = ev and ev:FindFirstChild("SayMessageRequest")
            if req then req:FireServer(msg, "All") ok = true end
        end)
        return ok
    end
    chatSystem.tryPlayerChat = function(msg)
        local ok = false
        pcall(function()
            local pl = chatSystem.Players.LocalPlayer
            if pl and pl.Chat then pl:Chat(msg) ok = true end
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
        chatSystem.connections.autoChat = RunService.Heartbeat:Connect(function()
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
    chatSystem.init = function() chatSystem.startAutoChat() end
    chatSystem.sendNow = function(message)
        if not message or message == "" then message = _G.AUTO_CHAT_TEXT end
        return chatSystem.doSend(message)
    end
    chatSystem.cleanup = function()
        for name, connection in pairs(chatSystem.connections) do
            if connection then pcall(function() connection:Disconnect() end) end
        end
        chatSystem.connections = {}
        chatSystem.active = false
    end
    task.spawn(chatSystem.init)

    -- ==================== 天气和天空盒 ====================
    local weatherSettings = {
        ["雨天"] = "Rainy", ["阴天"] = "Overcast", ["晴天"] = "Clear", ["雪天"] = "Snowy"
    }
    local selectedWeather = "晴天"
    local function changeWeather(weatherType)
        local lighting = game:GetService("Lighting")
        lighting.ClockTime = 14
        lighting.Brightness = 1
        lighting.FogEnd = 10000
        lighting.GlobalShadows = true
        for _, obj in pairs(lighting:GetChildren()) do
            if obj:IsA("ParticleEmitter") or obj.Name == "WeatherEffect" then obj:Destroy() end
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
    end
    local skySettings = {
        ["神青天空1"] = "http://www.roblox.com/asset/?id=112666167201442",
        ["神青天空2"] = "http://www.roblox.com/asset/?id=105006817202266",
        ["动漫猫羽雫天空"] = "http://www.roblox.com/asset/?id=16060333448"
    }
    local selectedSky = "神青天空1"
    local function changeSky(skyboxId)
        local lighting = game:GetService("Lighting")
        for _, obj in pairs(lighting:GetChildren()) do if obj:IsA("Sky") then obj:Destroy() end end
        local sky = Instance.new("Sky")
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        sky.SkyboxUp = skyboxId
        sky.SkyboxBk = skyboxId
        sky.SkyboxDn = skyboxId
        sky.SkyboxRt = skyboxId
        sky.SkyboxLf = skyboxId
        sky.SkyboxFt = skyboxId
    end

    -- ==================== UI 设置相关变量 ====================
    local borderEnabled = true
    local fontColorEnabled = false
    local soundEnabled = true
    local blurEnabled = false
    local animationSpeed = 2
    local currentBorderColorScheme = "彩虹颜色"
    local currentFontColorScheme = "彩虹颜色"
    local uiScale = 1
    local windowOpen = true
    local FONT_STYLES = {
        "SourceSansBold", "SourceSansItalic", "SourceSansLight", "SourceSans",
        "GothamSSm", "GothamSSm-Bold", "GothamSSm-Medium", "GothamSSm-Light",
        "GothamSSm-Black", "GothamSSm-Book", "GothamSSm-XLight", "GothamSSm-Thin",
        "GothamSSm-Ultra", "GothamSSm-SemiBold", "GothamSSm-ExtraLight", "GothamSSm-Heavy",
        "GothamSSm-ExtraBold", "GothamSSm-Regular", "Gotham", "GothamBold",
        "GothamMedium", "GothamBlack", "GothamLight", "Arial", "ArialBold",
        "Code", "CodeLight", "CodeBold", "Highway", "HighwayBold", "HighwayLight",
        "SciFi", "SciFiBold", "SciFiItalic", "Cartoon", "CartoonBold", "Handwritten"
    }
    local FONT_DESCRIPTIONS = {
        ["SourceSansBold"] = "标准粗体", ["SourceSansItalic"] = "斜体", ["SourceSansLight"] = "细体",
        ["SourceSans"] = "标准体", ["GothamSSm"] = "哥特标准", ["GothamSSm-Bold"] = "哥特粗体",
        ["GothamSSm-Medium"] = "哥特中等", ["GothamSSm-Light"] = "哥特细体", ["GothamSSm-Black"] = "哥特黑体",
        ["GothamSSm-Book"] = "哥特书本体", ["GothamSSm-XLight"] = "哥特超细体", ["GothamSSm-Thin"] = "哥特极细体",
        ["GothamSSm-Ultra"] = "哥特超黑体", ["GothamSSm-SemiBold"] = "哥特半粗体", ["GothamSSm-ExtraLight"] = "哥特特细体",
        ["GothamSSm-Heavy"] = "哥特粗重体", ["GothamSSm-ExtraBold"] = "哥特特粗体", ["GothamSSm-Regular"] = "哥特常规体",
        ["Gotham"] = "经典哥特体", ["GothamBold"] = "经典哥特粗体", ["GothamMedium"] = "经典哥特中等",
        ["GothamBlack"] = "经典哥特黑体", ["GothamLight"] = "经典哥特细体", ["Arial"] = "标准Arial体",
        ["ArialBold"] = "Arial粗体", ["Code"] = "代码字体", ["CodeLight"] = "代码细体",
        ["CodeBold"] = "代码粗体", ["Highway"] = "高速公路体", ["HighwayBold"] = "高速公路粗体",
        ["HighwayLight"] = "高速公路细体", ["SciFi"] = "科幻字体", ["SciFiBold"] = "科幻粗体",
        ["SciFiItalic"] = "科幻斜体", ["Cartoon"] = "卡通字体", ["CartoonBold"] = "卡通粗体",
        ["Handwritten"] = "手写体"
    }
    local currentFontStyle = "SourceSansBold"
    local COLOR_SCHEMES = {
        ["彩虹颜色"] = { ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHex("FF0000")), ColorSequenceKeypoint.new(0.16, Color3.fromHex("FFA500")), ColorSequenceKeypoint.new(0.33, Color3.fromHex("FFFF00")), ColorSequenceKeypoint.new(0.5, Color3.fromHex("00FF00")), ColorSequenceKeypoint.new(0.66, Color3.fromHex("0000FF")), ColorSequenceKeypoint.new(0.83, Color3.fromHex("4B0082")), ColorSequenceKeypoint.new(1, Color3.fromHex("EE82EE")) }), "palette" },
        ["黑红颜色"] = { ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHex("000000")), ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF0000")), ColorSequenceKeypoint.new(1, Color3.fromHex("000000")) }), "alert-triangle" },
        ["蓝白颜色"] = { ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHex("FFFFFF")), ColorSequenceKeypoint.new(0.5, Color3.fromHex("1E90FF")), ColorSequenceKeypoint.new(1, Color3.fromHex("FFFFFF")) }), "droplet" },
        ["紫金颜色"] = { ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHex("FFD700")), ColorSequenceKeypoint.new(0.5, Color3.fromHex("8A2BE2")), ColorSequenceKeypoint.new(1, Color3.fromHex("FFD700")) }), "crown" },
        ["蓝黑颜色"] = { ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHex("000000")), ColorSequenceKeypoint.new(0.5, Color3.fromHex("0000FF")), ColorSequenceKeypoint.new(1, Color3.fromHex("000000")) }), "moon" },
        ["绿紫颜色"] = { ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHex("00FF00")), ColorSequenceKeypoint.new(0.5, Color3.fromHex("800080")), ColorSequenceKeypoint.new(1, Color3.fromHex("00FF00")) }), "zap" },
        ["粉蓝颜色"] = { ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHex("FF69B4")), ColorSequenceKeypoint.new(0.5, Color3.fromHex("00BFFF")), ColorSequenceKeypoint.new(1, Color3.fromHex("FF69B4")) }), "heart" },
        ["橙青颜色"] = { ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHex("FF4500")), ColorSequenceKeypoint.new(0.5, Color3.fromHex("00CED1")), ColorSequenceKeypoint.new(1, Color3.fromHex("FF4500")) }), "sun" },
        ["红金颜色"] = { ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHex("FF0000")), ColorSequenceKeypoint.new(0.5, Color3.fromHex("FFD700")), ColorSequenceKeypoint.new(1, Color3.fromHex("FF0000")) }), "award" },
        ["银蓝颜色"] = { ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHex("C0C0C0")), ColorSequenceKeypoint.new(0.5, Color3.fromHex("4682B4")), ColorSequenceKeypoint.new(1, Color3.fromHex("C0C0C0")) }), "star" },
        ["霓虹颜色"] = { ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHex("FF00FF")), ColorSequenceKeypoint.new(0.25, Color3.fromHex("00FFFF")), ColorSequenceKeypoint.new(0.5, Color3.fromHex("FFFF00")), ColorSequenceKeypoint.new(0.75, Color3.fromHex("FF00FF")), ColorSequenceKeypoint.new(1, Color3.fromHex("00FFFF")) }), "sparkles" },
        ["森林颜色"] = { ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHex("228B22")), ColorSequenceKeypoint.new(0.5, Color3.fromHex("32CD32")), ColorSequenceKeypoint.new(1, Color3.fromHex("228B22")) }), "tree" },
        ["火焰颜色"] = { ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHex("FF4500")), ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF0000")), ColorSequenceKeypoint.new(1, Color3.fromHex("FF8C00")) }), "flame" },
        ["海洋颜色"] = { ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHex("000080")), ColorSequenceKeypoint.new(0.5, Color3.fromHex("1E90FF")), ColorSequenceKeypoint.new(1, Color3.fromHex("00BFFF")) }), "waves" },
        ["日落颜色"] = { ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHex("FF4500")), ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF8C00")), ColorSequenceKeypoint.new(1, Color3.fromHex("FFD700")) }), "sunset" },
        ["银河颜色"] = { ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHex("4B0082")), ColorSequenceKeypoint.new(0.5, Color3.fromHex("8A2BE2")), ColorSequenceKeypoint.new(1, Color3.fromHex("9370DB")) }), "galaxy" },
        ["糖果颜色"] = { ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHex("FF69B4")), ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF1493")), ColorSequenceKeypoint.new(1, Color3.fromHex("FFB6C1")) }), "candy" },
        ["金属颜色"] = { ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHex("C0C0C0")), ColorSequenceKeypoint.new(0.5, Color3.fromHex("A9A9A9")), ColorSequenceKeypoint.new(1, Color3.fromHex("696969")) }), "shield" }
    }
    local fontColorAnimations = {}
    local rainbowBorderAnimation = nil
    local borderInitialized = false

    local function applyFontColorGradient(textElement, colorScheme)
        if not textElement or not textElement:IsA("TextLabel") and not textElement:IsA("TextButton") and not textElement:IsA("TextBox") then return end
        local existingGradient = textElement:FindFirstChild("FontColorGradient")
        if existingGradient then existingGradient:Destroy() end
        if fontColorAnimations[textElement] then fontColorAnimations[textElement]:Disconnect() fontColorAnimations[textElement] = nil end
        if not fontColorEnabled then
            textElement.TextColor3 = Color3.new(1, 1, 1)
            return
        end
        local schemeData = COLOR_SCHEMES[colorScheme or currentFontColorScheme]
        if not schemeData then return end
        local fontGradient = Instance.new("UIGradient")
        fontGradient.Name = "FontColorGradient"
        fontGradient.Color = schemeData[1]
        fontGradient.Rotation = 0
        fontGradient.Parent = textElement
        textElement.TextColor3 = Color3.new(1, 1, 1)
        local animation
        animation = RunService.Heartbeat:Connect(function()
            if not textElement or textElement.Parent == nil then
                animation:Disconnect()
                fontColorAnimations[textElement] = nil
                return
            end
            if not fontGradient or fontGradient.Parent == nil then
                animation:Disconnect()
                fontColorAnimations[textElement] = nil
                return
            end
            local time = tick()
            fontGradient.Rotation = (time * animationSpeed * 30) % 360
        end)
        fontColorAnimations[textElement] = animation
    end

    local function applyFontStyleToWindow(fontStyle)
        if not Window or not Window.UIElements then return end
        local function processElement(element)
            for _, child in ipairs(element:GetDescendants()) do
                if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                    pcall(function() child.Font = Enum.Font[fontStyle] end)
                end
            end
        end
        processElement(Window.UIElements.Main)
    end

    local function applyFontColorsToWindow(colorScheme)
        if not Window or not Window.UIElements then return end
        local function processElement(element)
            for _, child in ipairs(element:GetDescendants()) do
                if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                    applyFontColorGradient(child, colorScheme)
                end
            end
        end
        processElement(Window.UIElements.Main)
    end

    local function createRainbowBorder(window, colorScheme, speed)
        if not window or not window.UIElements then return nil, nil end
        local mainFrame = window.UIElements.Main
        if not mainFrame then return nil, nil end
        local existingStroke = mainFrame:FindFirstChild("RainbowStroke")
        if existingStroke then
            local glowEffect = existingStroke:FindFirstChild("GlowEffect")
            if glowEffect then
                local schemeData = COLOR_SCHEMES[colorScheme or currentBorderColorScheme]
                if schemeData then glowEffect.Color = schemeData[1] end
            end
            return existingStroke, rainbowBorderAnimation
        end
        if not mainFrame:FindFirstChildOfClass("UICorner") then
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 16)
            corner.Parent = mainFrame
        end
        local rainbowStroke = Instance.new("UIStroke")
        rainbowStroke.Name = "RainbowStroke"
        rainbowStroke.Thickness = 1.5
        rainbowStroke.Color = Color3.new(1, 1, 1)
        rainbowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        rainbowStroke.LineJoinMode = Enum.LineJoinMode.Round
        rainbowStroke.Enabled = borderEnabled
        rainbowStroke.Parent = mainFrame
        local glowEffect = Instance.new("UIGradient")
        glowEffect.Name = "GlowEffect"
        local schemeData = COLOR_SCHEMES[colorScheme or currentBorderColorScheme]
        if schemeData then glowEffect.Color = schemeData[1] else glowEffect.Color = COLOR_SCHEMES["彩虹颜色"][1] end
        glowEffect.Rotation = 0
        glowEffect.Parent = rainbowStroke
        return rainbowStroke, nil
    end

    local function startBorderAnimation(window, speed)
        if not window or not window.UIElements then return nil end
        local mainFrame = window.UIElements.Main
        if not mainFrame then return nil end
        local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
        if not rainbowStroke or not rainbowStroke.Enabled then return nil end
        local glowEffect = rainbowStroke:FindFirstChild("GlowEffect")
        if not glowEffect then return nil end
        if rainbowBorderAnimation then rainbowBorderAnimation:Disconnect() rainbowBorderAnimation = nil end
        local animation
        animation = RunService.Heartbeat:Connect(function()
            if not rainbowStroke or rainbowStroke.Parent == nil or not rainbowStroke.Enabled then
                animation:Disconnect()
                return
            end
            local time = tick()
            glowEffect.Rotation = (time * speed * 60) % 360
        end)
        rainbowBorderAnimation = animation
        return animation
    end

    local function initializeRainbowBorder(scheme, speed)
        speed = speed or animationSpeed
        local rainbowStroke, _ = createRainbowBorder(Window, scheme, speed)
        if rainbowStroke then
            if borderEnabled then startBorderAnimation(Window, speed) end
            borderInitialized = true
            return true
        end
        return false
    end

    local function applyBlurEffect(enabled)
        if enabled then
            pcall(function()
                local blur = Instance.new("BlurEffect")
                blur.Size = 8
                blur.Name = "UIwdfex-通缉Blur"
                blur.Parent = game:GetService("Lighting")
            end)
        else
            pcall(function()
                local existingBlur = game:GetService("Lighting"):FindFirstChild("UIwdfex-通缉Blur")
                if existingBlur then existingBlur:Destroy() end
            end)
        end
    end

    local function applyUIScale(scale)
        if Window and Window.UIElements and Window.UIElements.Main then
            Window.UIElements.Main.Size = UDim2.new(0, 600 * scale, 0, 400 * scale)
        end
    end

    local function playSound()
        if soundEnabled then
            pcall(function()
                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://9047002353"
                sound.Volume = 0.3
                sound.Parent = game:GetService("SoundService")
                sound:Play()
                game:GetService("Debris"):AddItem(sound, 2)
            end)
        end
    end

    -- ==================== 开始构建 UI ====================
    -- 公告 Tab
    local NoticeTab = Window:Tab({ Title = "公告", Icon = "info" })
    local NoticeSection = NoticeTab:Section({ Title = "作者消息", Opened = true })
    NoticeSection:Paragraph({
        Title = "wdfex-通缉",
        Desc = "作者：wdfex\nQQ：1687426335"
    })
    NoticeSection:Divider()
    NoticeSection:Paragraph({
        Title = "注意事项",
        Desc = "本脚本仅供学习交流使用\n请勿用于非法用途\n如有bug请联系作者修复"
    })

    -- 通知 Tab
    local infoTab = Window:Tab({ Title = "通知", Icon = "layout-grid", Locked = false })
    local infoSection = infoTab:Section({ Title = "详情信息", Icon = "info", Opened = true })
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
    local infoSection2 = infoTab:Section({ Title = "更新", Icon = "info", Opened = true })
    infoSection2:Paragraph({
        Title = "脚本已稳定发布",
        ThumbnailSize = 190,
    })
    infoSection2:Paragraph({
        Title = "已经更新了愤怒机器人",
        ThumbnailSize = 190,
    })
    infoSection2:Paragraph({
        Title = "更新自动抢银行",
        ThumbnailSize = 190,
    })
    infoTab:Select()

    -- ==================== 主功能 Section ====================
    local MainSection = Window:Section({
        Title = "主功能",
        Opened = true,
    })
    local function AddTab(section, title, icon)
        return section:Tab({ Title = title, Icon = icon })
    end

    -- 玩家修改 Tab (飞行、速度、视野、无限跳)
    local PlayerTab = AddTab(MainSection, "玩家修改", "user")
    PlayerTab:Divider({ Text = "飞行" })
    PlayerTab:Toggle({
        Title = "飞行模式",
        Value = false,
        Callback = function(v)
            if v then startFlying() else stopFlying() end
        end
    })
    PlayerTab:Toggle({
        Title = "旋转模式",
        Value = false,
        Callback = function(v)
            if v then SpinningEnabled = true else SpinningEnabled = false end
        end
    })
    PlayerTab:Slider({
        Title = "飞行速度",
        Step = 1,
        Value = { Min = 1, Max = 200, Default = 50 },
        Callback = function(v) FlightSpeed = v end
    })
    PlayerTab:Slider({
        Title = "旋转速度",
        Step = 1,
        Value = { Min = 1, Max = 50, Default = 5 },
        Callback = function(v) SpinSpeed = v end
    })
    PlayerTab:Divider({ Text = "移动" })
    PlayerTab:Toggle({
        Title = "速度增加",
        Value = false,
        Callback = function(v) toggleSpeedHack(v) end
    })
    PlayerTab:Slider({
        Title = "速度设置",
        Step = 1,
        Value = { Min = 1, Max = 150, Default = 16 },
        Callback = function(v) SpeedValue = v end
    })
    PlayerTab:Toggle({
        Title = "扩大视野",
        Value = false,
        Callback = function(v) toggleFOV(v) end
    })
    PlayerTab:Toggle({
        Title = "无限跳",
        Value = false,
        Callback = function(v) toggleInfiniteJump(v) end
    })

    -- 战斗功能 Tab
    local CombatTab = AddTab(MainSection, "战斗功能", "swords")
    CombatTab:Toggle({
        Title = "强制加载所有数据",
        Value = false,
        Callback = function(v)
            ForceLoadAll = v
            if v then
                task.spawn(function()
                    local devv = require(ReplicatedStorage.Devv)
                    local Network = devv.load("Network")
                    local function loadArea(position, radius)
                        if RunService:IsClient() then
                            pcall(function()
                                Network.InvokeServer("requestStreamAround", position, radius)
                                Network.FireServer("setReplicationFocus", position)
                            end)
                        end
                    end
                    while ForceLoadAll do
                        local White = Workspace:FindFirstChild("Local") and Workspace.Local:FindFirstChild("Gizmos") and Workspace.Local.Gizmos:FindFirstChild("White")
                        if White then
                            for _, gizmo in ipairs(White:GetChildren()) do
                                if gizmo.PrimaryPart then
                                    loadArea(gizmo.PrimaryPart.Position, 50)
                                    task.wait(0.1)
                                end
                            end
                        end
                        for _, p in ipairs(Players:GetPlayers()) do
                            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                loadArea(p.Character.HumanoidRootPart.Position, 50)
                                task.wait(0.1)
                            end
                        end
                        loadArea(Vector3.new(0, 0, 0), 1000)
                        loadArea(Vector3.new(1000, 0, 1000), 1000)
                        loadArea(Vector3.new(-1000, 0, -1000), 1000)
                        loadArea(Vector3.new(1000, 0, -1000), 1000)
                        loadArea(Vector3.new(-1000, 0, 1000), 1000)
                        task.wait(5)
                    end
                end)
            end
        end
    })
    CombatTab:Toggle({
        Title = "愤怒机器人[全枪]",
        Value = false,
        Callback = function(v)
            AutoShoot = v
            if v then
                task.spawn(function()
                    ShooterModule = require(ReplicatedStorage.Client.Wanted.Objects.ClientTool.Components.Guns.Shooter)
                    OriginalShoot = ShooterModule._shoot
                    local function createBeautifulTrail(origin, targetPos)
                        local function createBezierCurve(p0, p1, p2, t)
                            return (1 - t) ^ 2 * p0 + 2 * (1 - t) * t * p1 + t ^ 2 * p2
                        end
                        local trailContainer = Instance.new("Folder")
                        trailContainer.Name = "MagicTrail"
                        trailContainer.Parent = Workspace
                        local midPoint = (origin + targetPos) / 2
                        local direction = (targetPos - origin).Unit
                        local perpendicular = Vector3.new(-direction.Z, direction.Y, direction.X) * 3
                        local controlPoint = midPoint + perpendicular + Vector3.new(0, math.random(-3, 3), 0)
                        local curvePoints = {}
                        for i = 0, 20 do
                            local t = i / 20
                            table.insert(curvePoints, createBezierCurve(origin, controlPoint, targetPos, t))
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
                            beamPart.CFrame = CFrame.new(startPoint, endPoint) * CFrame.new(0, 0, -distance / 2)
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
                            if trailContainer and trailContainer.Parent then trailContainer:Destroy() end
                        end)
                        return trailContainer
                    end
                    local function hasLineOfSight(shooterPos, targetPos)
                        local raycastParams = RaycastParams.new()
                        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                        raycastParams.FilterDescendantsInstances = { LocalPlayer.Character }
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
                        if not self or not self.tool then return OriginalShoot(self) end
                        local LocalCharacter = LocalPlayer.Character
                        if not LocalCharacter then return OriginalShoot(self) end
                        local shooterPos = LocalCharacter.HumanoidRootPart and LocalCharacter.HumanoidRootPart.Position or LocalCharacter.PrimaryPart.Position
                        local nearestPlayer = nil
                        local nearestDistance = math.huge
                        for _, p in ipairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                local targetPos = p.Character.HumanoidRootPart.Position
                                local distance = (shooterPos - targetPos).Magnitude
                                if hasLineOfSight(shooterPos, targetPos) and distance < nearestDistance then
                                    nearestDistance = distance
                                    nearestPlayer = p
                                end
                            end
                        end
                        if nearestPlayer and nearestPlayer.Character and nearestPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local targetPos = nearestPlayer.Character.HumanoidRootPart.Position
                            self.aimpoint = targetPos
                            self.aimpoint2 = targetPos
                            if self.tool.model and self.tool.model.PrimaryPart then
                                createBeautifulTrail(self.tool.model.PrimaryPart.Position, targetPos)
                            else
                                createBeautifulTrail(shooterPos, targetPos)
                            end
                            if self.tool then
                                self.tool.shooting = true
                                self.tool.fireDebounce = 0
                                self.tool.fireMode = "auto"
                            end
                        else
                            if self.tool then self.tool.shooting = false end
                        end
                        return OriginalShoot(self)
                    end
                    while AutoShoot do
                        if ShooterModule and ShooterModule._shoot then
                            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                            if tool then
                                local shooter = tool:FindFirstChild("Shooter") or { tool = tool }
                                pcall(function() ShooterModule._shoot(shooter) end)
                            end
                        end
                        task.wait(0.2)
                    end
                    if OriginalShoot then ShooterModule._shoot = OriginalShoot end
                end)
            else
                if ShooterModule and OriginalShoot then ShooterModule._shoot = OriginalShoot end
            end
        end
    })
    CombatTab:Toggle({
        Title = "出售物品光环",
        Value = false,
        Callback = function(v)
            AutoSell = v
            if v then
                task.spawn(function()
                    while AutoSell do
                        for _, a in ipairs(ReplicatedStorage.Shared.Core.Network:GetChildren()) do
                            if a:IsA("RemoteFunction") or a:IsA("RemoteEvent") then
                                if not a.Name:find("moveHouse") and not a.Name:find("House") then
                                    pcall(function() a:InvokeServer() end)
                                end
                            end
                            if not AutoSell then break end
                        end
                        task.wait(0.5)
                    end
                end)
            end
        end
    })

    -- 刷钱功能 Tab
    local MoneyTab = AddTab(MainSection, "刷钱功能", "dollar-sign")
    MoneyTab:Toggle({
        Title = "自动抢银行",
        Value = false,
        Callback = function(v)
            AutoBankCash = v
            if v then
                task.spawn(function()
                    local function GetRootPart()
                        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
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
                                    UserInputService:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                                    task.wait(0.05)
                                    UserInputService:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                                    task.wait(0.5)
                                end
                            end
                        end
                        task.wait(0.5)
                    end
                end)
            end
        end
    })
    MoneyTab:Toggle({
        Title = "摧毁ATM光环",
        Value = false,
        Callback = function(v)
            HitATMAura = v
            if v then
                local devv = require(ReplicatedStorage.Devv)
                local Get = devv.GetModule("Network")
                local function attackATM(gizmo)
                    if not gizmo or not gizmo:FindFirstChild("Metal") then return false end
                    local metalPart = gizmo.Metal
                    local guid = gizmo:GetAttribute("objectId")
                    if not guid then return false end
                    Get.FireServer("registerMeleeHits", { {
                        normal = Vector3.new(0, 0, 0),
                        direction = Vector3.new(0, 0, 0),
                        source = "Melee",
                        id = guid,
                        material = Enum.Material.Metal,
                        position = metalPart.Position,
                        gizmoType = "ATM",
                        processedPlayerId = LocalPlayer.UserId,
                        hit = metalPart,
                        speed = 50,
                        collisionPoint = metalPart.Position,
                        hitName = "Metal",
                        hitType = "gizmo"
                    } })
                    return true
                end
                local function isATMAlive(gizmo)
                    return gizmo and gizmo.Parent and gizmo:FindFirstChild("Metal")
                end
                local function findAllATMs()
                    local allATMs = {}
                    local gizmoColors = { "White", "Green", "Blue", "Purple", "Orange", "Red", "Yellow" }
                    for _, color in ipairs(gizmoColors) do
                        local colorFolder = Workspace.Local.Gizmos:FindFirstChild(color)
                        if colorFolder then
                            local atm = colorFolder:FindFirstChild("ATM")
                            if atm then table.insert(allATMs, atm) end
                        end
                    end
                    return allATMs
                end
                task.spawn(function()
                    local cooldown = false
                    while HitATMAura do
                        if cooldown then task.wait(0.1) continue end
                        local allATMs = findAllATMs()
                        if #allATMs == 0 then task.wait(1) continue end
                        for _, atm in ipairs(allATMs) do
                            if not HitATMAura then break end
                            local attackCount = 0
                            while HitATMAura and isATMAlive(atm) and attackCount < 50 do
                                attackATM(atm)
                                attackCount = attackCount + 1
                                task.wait(0.05)
                            end
                            if HitATMAura then task.wait(0.5) end
                        end
                        task.wait(0.1)
                    end
                end)
            end
        end
    })
    MoneyTab:Toggle({
        Title = "自动ATM",
        Value = false,
        Callback = function(v)
            AutoATM = v
            if v then
                task.spawn(function()
                    local RootPart = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
                    local GizmoFolder = Workspace.Local.Gizmos.White
                    local ATMPatrolPoints = {
                        Vector3.new(-1137, 78, -1953), Vector3.new(-44, 63, -2083),
                        Vector3.new(194, 60, -2884), Vector3.new(-412, 106, -1301),
                        Vector3.new(-377, 410, -741), Vector3.new(-985, 380, -1145),
                        Vector3.new(-854, 406, -1505)
                    }
                    local function GetBasePart(instance)
                        if instance:IsA("BasePart") then return instance end
                        for _, desc in ipairs(instance:GetDescendants()) do
                            if desc:IsA("BasePart") then return desc end
                        end
                    end
                    local function IsValidATMTarget(instance)
                        return instance:GetAttribute("gizmoType") == "ATM"
                    end
                    local function FindClosestATMTarget()
                        local minDist = math.huge
                        local closest = nil
                        for _, item in ipairs(GizmoFolder:GetChildren()) do
                            if IsValidATMTarget(item) then
                                local part = GetBasePart(item)
                                if part then
                                    local dist = (RootPart.Position - part.Position).Magnitude
                                    if dist < minDist then
                                        minDist = dist
                                        closest = part
                                    end
                                end
                            end
                        end
                        return closest
                    end
                    local function TeleportTo(target)
                        if typeof(target) ~= "Instance" then
                            RootPart.CFrame = CFrame.new(target)
                        else
                            RootPart.CFrame = target.CFrame * CFrame.new(0, 5, 0)
                        end
                    end
                    local function SpamInteract(duration)
                        local start = tick()
                        while tick() - start < duration do
                            UserInputService:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                            task.wait(0.05)
                            UserInputService:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                        end
                    end
                    local timeElapsed = 0
                    while AutoATM do
                        local target = FindClosestATMTarget()
                        if target then
                            TeleportTo(target)
                            task.wait(0.3)
                            SpamInteract(1.5)
                            timeElapsed = 0
                        else
                            timeElapsed = timeElapsed + 0.7
                            TeleportTo(ATMPatrolPoints[math.random(1, #ATMPatrolPoints)])
                            if timeElapsed >= 30 then timeElapsed = 0 end
                        end
                        task.wait(0.7)
                    end
                end)
            end
        end
    })
    MoneyTab:Toggle({
        Title = "自动收银机",
        Value = false,
        Callback = function(v)
            AutoRegister = v
            if v then
                task.spawn(function()
                    local RootPart = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
                    local GizmoFolder = Workspace.Local.Gizmos.White
                    local RegisterPatrolPoints = {
                        Vector3.new(-1000, 100, -2000), Vector3.new(-500, 100, -2200), Vector3.new(100, 100, -2500)
                    }
                    local function GetBasePart(instance)
                        if instance:IsA("BasePart") then return instance end
                        for _, desc in ipairs(instance:GetDescendants()) do
                            if desc:IsA("BasePart") then return desc end
                        end
                    end
                    local function IsValidRegisterTarget(instance)
                        return instance:GetAttribute("gizmoType") == "Register"
                    end
                    local function FindClosestRegisterTarget()
                        local minDist = math.huge
                        local closest = nil
                        for _, item in ipairs(GizmoFolder:GetChildren()) do
                            if IsValidRegisterTarget(item) then
                                local part = GetBasePart(item)
                                if part then
                                    local dist = (RootPart.Position - part.Position).Magnitude
                                    if dist < minDist then
                                        minDist = dist
                                        closest = part
                                    end
                                end
                            end
                        end
                        return closest
                    end
                    local function TeleportTo(target)
                        if typeof(target) ~= "Instance" then
                            RootPart.CFrame = CFrame.new(target)
                        else
                            RootPart.CFrame = target.CFrame * CFrame.new(0, 5, 0)
                        end
                    end
                    local function SpamInteract(duration)
                        local start = tick()
                        while tick() - start < duration do
                            UserInputService:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                            task.wait(0.05)
                            UserInputService:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                        end
                    end
                    local timeElapsed = 0
                    while AutoRegister do
                        local target = FindClosestRegisterTarget()
                        if target then
                            TeleportTo(target)
                            task.wait(0.3)
                            SpamInteract(1.2)
                            timeElapsed = 0
                        else
                            timeElapsed = timeElapsed + 0.7
                            TeleportTo(RegisterPatrolPoints[math.random(1, #RegisterPatrolPoints)])
                            if timeElapsed >= 30 then timeElapsed = 0 end
                        end
                        task.wait(0.7)
                    end
                end)
            end
        end
    })

    -- 自动拾取 Tab
    local PickupTab = AddTab(MainSection, "自动拾取", "box")
    PickupTab:Toggle({
        Title = "自动拾取金条",
        Value = false,
        Callback = function(v)
            AutoGold = v
            if v then
                task.spawn(function()
                    local function GetRootPart()
                        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
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
                                        UserInputService:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                                        task.wait(0.05)
                                        UserInputService:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                                        repeat task.wait(0.1) until not Item.Parent or not AutoGold
                                    end
                                end
                                if not AutoGold then break end
                            end
                        end
                        task.wait(0.5)
                    end
                end)
            end
        end
    })
    PickupTab:Toggle({
        Title = "自动拾取全部礼物盒",
        Value = false,
        Callback = function(v)
            AutoWorldItem = v
            if v then
                task.spawn(function()
                    local function GetRootPart()
                        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
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
                                        UserInputService:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                                        task.wait(0.05)
                                        UserInputService:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                                        repeat task.wait(0.1) until not Item.Parent or not AutoWorldItem
                                    end
                                end
                                if not AutoWorldItem then break end
                            end
                        end
                        task.wait(0.5)
                    end
                end)
            end
        end
    })
    PickupTab:Toggle({
        Title = "自动拾取银条",
        Value = false,
        Callback = function(v)
            AutoSilverBar = v
            if v then
                task.spawn(function()
                    local function GetRootPart()
                        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
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
                                        UserInputService:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                                        task.wait(0.05)
                                        UserInputService:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                                        repeat task.wait(0.1) until not Item.Parent or not AutoSilverBar
                                    end
                                end
                                if not AutoSilverBar then break end
                            end
                        end
                        task.wait(0.5)
                    end
                end)
            end
        end
    })
    PickupTab:Toggle({
        Title = "自动拾取蓝宝石",
        Value = false,
        Callback = function(v)
            AutoSapphire = v
            if v then
                task.spawn(function()
                    local function GetRootPart()
                        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
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
                                UserInputService:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                                task.wait(0.05)
                                UserInputService:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                                repeat task.wait(0.1) until not White:FindFirstChild("Sapphire") or not AutoSapphire
                            end
                        end
                        task.wait(0.5)
                    end
                end)
            end
        end
    })

    -- 自瞄 Tab
    local AimTab = AddTab(MainSection, "自瞄", "crosshair")
    AimTab:Toggle({
        Title = "开启自瞄",
        Value = false,
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
        Value = false,
        Callback = function(v)
            isSilentAim = v
            SilentFOVring.Visible = v
        end
    })
    AimTab:Toggle({
        Title = "瞄准时自动射击",
        Value = false,
        Callback = function(v)
            isAutoShootOnAim = v
            if v then
                hookAutoShoot()
                startAutoShootLoop()
            else
                stopAutoShoot()
            end
        end
    })
    AimTab:Toggle({
        Title = "预判自瞄",
        Value = false,
        Callback = function(v) isPredicting = v end
    })
    AimTab:Toggle({
        Title = "高级预判",
        Value = false,
        Callback = function(v) useAdvancedPrediction = v end
    })
    AimTab:Toggle({
        Title = "锁定目标",
        Value = false,
        Callback = function(v) aimLock = v end
    })
    AimTab:Toggle({
        Title = "狂暴模式",
        Value = false,
        Callback = function(v) isRageMode = v end
    })
    AimTab:Divider({ Text = "瞄准设置" })
    AimTab:Dropdown({
        Title = "瞄准风格",
        Values = { "平滑", "直接", "震动" },
        Value = "平滑",
        Callback = function(v) aimStyle = v end
    })
    AimTab:Dropdown({
        Title = "瞄准优先级",
        Values = { "距离", "屏幕距离", "生命值" },
        Value = "距离",
        Callback = function(v) aimbotPriority = v end
    })
    AimTab:Dropdown({
        Title = "自瞄身体部位",
        Values = { "头", "胸", "左手", "右手", "左腿", "右腿" },
        Value = "头",
        Callback = function(v)
            local map = { ["头"] = "Head", ["胸"] = "UpperTorso", ["左手"] = "LeftHand", ["右手"] = "RightHand", ["左腿"] = "LeftFoot", ["右腿"] = "RightFoot" }
            targetPart = map[v]
        end
    })
    AimTab:Dropdown({
        Title = "预判类型",
        Values = { "线性", "抛物线", "自适应" },
        Value = "线性",
        Callback = function(v) predictionType = v end
    })
    AimTab:Slider({
        Title = "FOV范围",
        Step = 1,
        Value = { Min = 1, Max = 500, Default = 50 },
        Callback = function(v)
            fov = v
            FOVring.Radius = v
        end
    })
    AimTab:Slider({
        Title = "静默FOV",
        Step = 1,
        Value = { Min = 1, Max = 200, Default = 30 },
        Callback = function(v)
            silentFov = v
            SilentFOVring.Radius = v
        end
    })
    AimTab:Slider({
        Title = "平滑度",
        Step = 0.01,
        Value = { Min = 0.01, Max = 1, Default = 0.5 },
        Callback = function(v) smoothness = v end
    })
    AimTab:Slider({
        Title = "预判距离",
        Step = 0.1,
        Value = { Min = 0.1, Max = 5, Default = 1.5 },
        Callback = function(v) predictionDistance = v end
    })
    AimTab:Slider({
        Title = "射击速度",
        Step = 0.01,
        Value = { Min = 0.01, Max = 1, Default = 0.1 },
        Callback = function(v) shootDelay = v end
    })
    AimTab:Slider({
        Title = "射击范围",
        Step = 1,
        Value = { Min = 10, Max = 2000, Default = 500 },
        Callback = function(v) shootRange = v end
    })
    AimTab:Slider({
        Title = "静默命中率",
        Step = 1,
        Value = { Min = 1, Max = 100, Default = 100 },
        Callback = function(v) silentAimChance = v end
    })
    AimTab:Slider({
        Title = "子弹速度",
        Step = 1,
        Value = { Min = 100, Max = 2000, Default = 500 },
        Callback = function(v) bulletSpeed = v end
    })
    AimTab:Slider({
        Title = "锁定时间",
        Step = 0.5,
        Value = { Min = 1, Max = 10, Default = 3 },
        Callback = function(v) lockDuration = v end
    })
    AimTab:Divider({ Text = "其他功能" })
    AimTab:Toggle({
        Title = "活体检测",
        Value = false,
        Callback = function(v) aliveCheck = v end
    })
    AimTab:Toggle({
        Title = "墙壁检测",
        Value = false,
        Callback = function(v) wallCheck = v end
    })
    AimTab:Toggle({
        Title = "团队检查",
        Value = false,
        Callback = function(v) teamCheck = v end
    })
    AimTab:Toggle({
        Title = "延迟补偿",
        Value = false,
        Callback = function(v) isLagCompensation = v end
    })

    -- 透视 Tab
    local ESPTab = AddTab(MainSection, "透视", "user")
    ESPTab:Toggle({
        Title = "ESP总开关",
        Value = false,
        Callback = function(v) ESPConfig.ESPEnabled = v end
    })
    ESPTab:Toggle({
        Title = "显示方框",
        Value = false,
        Callback = function(v) ESPConfig.ShowBox = v end
    })
    ESPTab:Toggle({
        Title = "显示血量",
        Value = false,
        Callback = function(v) ESPConfig.ShowHealth = v end
    })
    ESPTab:Toggle({
        Title = "显示名称",
        Value = false,
        Callback = function(v) ESPConfig.ShowName = v end
    })
    ESPTab:Toggle({
        Title = "显示距离",
        Value = false,
        Callback = function(v) ESPConfig.ShowDistance = v end
    })
    ESPTab:Toggle({
        Title = "显示射线",
        Value = false,
        Callback = function(v) ESPConfig.ShowTracer = v end
    })
    ESPTab:Toggle({
        Title = "队伍检查",
        Value = false,
        Callback = function(v) ESPConfig.TeamCheck = v end
    })
    ESPTab:Toggle({
        Title = "显示骨骼",
        Value = false,
        Callback = function(v) ESPConfig.ShowSkeleton = v end
    })
    ESPTab:Toggle({
        Title = "显示雷达",
        Value = false,
        Callback = function(v) ESPConfig.ShowRadar = v end
    })
    ESPTab:Toggle({
        Title = "显示玩家计数",
        Value = false,
        Callback = function(v) ESPConfig.ShowPlayerCount = v end
    })
    ESPTab:Toggle({
        Title = "显示武器",
        Value = false,
        Callback = function(v) ESPConfig.ShowWeapon = v end
    })
    ESPTab:Toggle({
        Title = "屏幕外箭头",
        Value = false,
        Callback = function(v) ESPConfig.OutOfViewArrows = v end
    })
    ESPTab:Toggle({
        Title = "显示 Chams",
        Value = false,
        Callback = function(v) ESPConfig.Chams = v end
    })
    ESPTab:Slider({
        Title = "方框粗细",
        Step = 1,
        Value = { Min = 1, Max = 5, Default = 1 },
        Callback = function(v) ESPConfig.BoxThickness = v end
    })
    ESPTab:Slider({
        Title = "射线粗细",
        Step = 1,
        Value = { Min = 1, Max = 5, Default = 1 },
        Callback = function(v) ESPConfig.TracerThickness = v end
    })
    ESPTab:Slider({
        Title = "骨骼粗细",
        Step = 1,
        Value = { Min = 1, Max = 5, Default = 2 },
        Callback = function(v) ESPConfig.SkeletonThickness = v end
    })
    ESPTab:Slider({
        Title = "箭头大小",
        Step = 1,
        Value = { Min = 5, Max = 30, Default = 15 },
        Callback = function(v) ESPConfig.ArrowSize = v end
    })

    -- ==================== 其他功能 Section ====================
    local OtherSection = Window:Section({
        Title = "其他功能",
        Opened = true,
    })
    local OtherTab1 = AddTab(OtherSection, "绕过类", "shield")
    OtherTab1:Toggle({
        Title = "绕过炮塔伤害",
        Value = false,
        Callback = function(v)
            ImmuneTurret = v
            if v then
                oldFireServer = ReplicatedStorage.Shared.Core.Network.FireServer
                ReplicatedStorage.Shared.Core.Network.FireServer = function(self, event, ...)
                    if event == "registerLocalHit" and ... == "Turret" then
                        return nil
                    end
                    return oldFireServer(self, event, ...)
                end
            else
                if oldFireServer then
                    ReplicatedStorage.Shared.Core.Network.FireServer = oldFireServer
                end
            end
        end
    })

    -- 武器修改 Tab
    local WeaponTab = AddTab(OtherSection, "武器修改", "target")
    WeaponTab:Button({
        Title = "无限子弹",
        Callback = function()
            local Shooter = require(ReplicatedStorage.Client.Wanted.Objects.ClientTool.Components.Guns.Shooter)
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
            local Shooter = require(ReplicatedStorage.Client.Wanted.Objects.ClientTool.Components.Guns.Shooter)
            local originalShoot = Shooter._shoot
            Shooter._shoot = function(self)
                self.recoil = { firstShotKick = 0, climb = 0, spread = 0 }
                return originalShoot(self)
            end
        end
    })
    WeaponTab:Button({
        Title = "无扩散",
        Callback = function()
            local Shooter = require(ReplicatedStorage.Client.Wanted.Objects.ClientTool.Components.Guns.Shooter)
            local originalShoot = Shooter._shoot
            Shooter._shoot = function(self)
                self.aim = { spreadAngle = 0, zeroing = 1000 }
                return originalShoot(self)
            end
        end
    })
    WeaponTab:Button({
        Title = "快速射击",
        Callback = function()
            local Shooter = require(ReplicatedStorage.Client.Wanted.Objects.ClientTool.Components.Guns.Shooter)
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
            local Shooter = require(ReplicatedStorage.Client.Wanted.Objects.ClientTool.Components.Guns.Shooter)
            local originalShoot = Shooter._shoot
            Shooter._shoot = function(self)
                self.ammoData = { reloadTime = 0, magSize = 9999 }
                return originalShoot(self)
            end
        end
    })

    -- 玩家传送 Tab
    local PlayerTeleTab = AddTab(OtherSection, "玩家传送", "user")
    local TargetPlayerName = ""
    local TeleportPosition = "前方"
    PlayerTeleTab:Input({
        Title = "输入玩家用户名",
        Placeholder = "输入玩家名称",
        Callback = function(v) TargetPlayerName = v end
    })
    PlayerTeleTab:Dropdown({
        Title = "传送部位",
        Values = { "前方", "后方", "头顶", "左侧", "右侧" },
        Value = "前方",
        Callback = function(v) TeleportPosition = v end
    })
    PlayerTeleTab:Button({
        Title = "传送一次",
        Callback = function()
            if TargetPlayerName and TeleportPosition then
                local targetPlayer = Players:FindFirstChild(TargetPlayerName)
                if targetPlayer and targetPlayer ~= LocalPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local p = LocalPlayer
                    local c = p.Character or p.CharacterAdded:Wait()
                    local h = c:WaitForChild("HumanoidRootPart")
                    local targetCFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                    local offset = CFrame.new(0, 0, 0)
                    if TeleportPosition == "前方" then offset = CFrame.new(0, 0, -5)
                    elseif TeleportPosition == "后方" then offset = CFrame.new(0, 0, 5)
                    elseif TeleportPosition == "头顶" then offset = CFrame.new(0, 5, 0)
                    elseif TeleportPosition == "左侧" then offset = CFrame.new(-5, 0, 0)
                    elseif TeleportPosition == "右侧" then offset = CFrame.new(5, 0, 0) end
                    h.CFrame = targetCFrame * offset
                end
            end
        end
    })
    local FixedTeleport = false
    PlayerTeleTab:Toggle({
        Title = "固定传送",
        Value = false,
        Callback = function(v)
            FixedTeleport = v
            if v then
                task.spawn(function()
                    while FixedTeleport do
                        if TargetPlayerName and TeleportPosition then
                            local targetPlayer = Players:FindFirstChild(TargetPlayerName)
                            if targetPlayer and targetPlayer ~= LocalPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                local p = LocalPlayer
                                local c = p.Character or p.CharacterAdded:Wait()
                                local h = c:WaitForChild("HumanoidRootPart")
                                local targetCFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                                local offset = CFrame.new(0, 0, 0)
                                if TeleportPosition == "前方" then offset = CFrame.new(0, 0, -5)
                                elseif TeleportPosition == "后方" then offset = CFrame.new(0, 0, 5)
                                elseif TeleportPosition == "头顶" then offset = CFrame.new(0, 5, 0)
                                elseif TeleportPosition == "左侧" then offset = CFrame.new(-5, 0, 0)
                                elseif TeleportPosition == "右侧" then offset = CFrame.new(5, 0, 0) end
                                h.CFrame = targetCFrame * offset
                            end
                        end
                        task.wait(0.1)
                    end
                end)
            end
        end
    })

    -- 地点传送 Tab
    local TeleportSection = AddTab(OtherSection, "地点传送", "map-pin")
    local teleportPoints = {
        { name = "奥菲的价值兑换", pos = Vector3.new(-2907.68848, 37.1002731, 1444.74817) },
        { name = "绿洲银行", pos = Vector3.new(-431.537354, 39.6113892, -1400.08313) },
        { name = "绿洲城警察", pos = Vector3.new(2578.02393, 119.169289, -718.579773) },
        { name = "金库", pos = Vector3.new(-400.492279, 163.151733, -1242.72632) },
        { name = "犯罪基地", pos = Vector3.new(-5981.50586, 37.2680244, 1245.22046) },
        { name = "烈焰要塞", pos = Vector3.new(-1494.58496, 41.16481, 3364.56055) }
    }
    for _, tp in ipairs(teleportPoints) do
        TeleportSection:Button({
            Title = "传送到 " .. tp.name,
            Callback = function()
                local p = LocalPlayer
                local c = p.Character or p.CharacterAdded:Wait()
                local h = c:WaitForChild("HumanoidRootPart")
                h.CFrame = CFrame.new(tp.pos)
            end
        })
    end

    -- 武器传送 Tab
    local GunsTab = AddTab(OtherSection, "武器传送", "target")
    local weaponTeleports = {
        { name = "自动瞄准器", pos = Vector3.new(-822.973816, 179.617432, -290.576813) },
        { name = "UMP 45", pos = Vector3.new(1358.20264, 143.366074, -1218.008301) },
        { name = "贝内利M1014", pos = Vector3.new(1345.20422, 141.041168, -4809.10693) },
        { name = "M4A1", pos = Vector3.new(-6342.43115, 134.380051, -1328.82861) },
        { name = "AK-47", pos = Vector3.new(-4825.20752, 21.3648071, 1192.14551) },
        { name = "RPG-7", pos = Vector3.new(-1392.19739, 275.933319, 2199.5188) },
        { name = "乌兹", pos = Vector3.new(-1348.55493, 1109.2014694, 2033.73645) }
    }
    for _, wt in ipairs(weaponTeleports) do
        GunsTab:Button({
            Title = "获取 " .. wt.name,
            Callback = function()
                local p = LocalPlayer
                local c = p.Character or p.CharacterAdded:Wait()
                local h = c:WaitForChild("HumanoidRootPart")
                h.CFrame = CFrame.new(wt.pos)
                task.wait(0.5)
                UserInputService:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.1)
                UserInputService:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            end
        })
    end

    -- 娱乐 Tab
    local FunTab = AddTab(OtherSection, "娱乐", "settings")
    FunTab:Dropdown({
        Title = "发言模式",
        Values = { "自定义", "7字经", "14字经", "糖人语言", "宣传词" },
        Value = "自定义",
        Callback = function(v)
            _G.AUTO_CHAT_MODE = v
            chatSystem.messageIndex = 1
        end
    })
    FunTab:Input({
        Title = "自定义发言内容",
        Placeholder = "输入要发送的消息",
        Value = "wdfex-通缉",
        Callback = function(v) _G.AUTO_CHAT_TEXT = v end
    })
    FunTab:Toggle({
        Title = "开启自动发言",
        Value = false,
        Callback = function(v)
            _G.AUTO_CHAT_ENABLED = v
            if v and not chatSystem.active then chatSystem.startAutoChat() elseif not v then chatSystem.stopAutoChat() end
        end
    })
    FunTab:Slider({
        Title = "发言间隔",
        Step = 0.5,
        Value = { Min = 0.5, Max = 10, Default = 1.5 },
        Callback = function(v) _G.AUTO_CHAT_INTERVAL = v end
    })
    FunTab:Divider({ Text = "天气" })
    FunTab:Dropdown({
        Title = "选择天气",
        Values = { "雨天", "阴天", "晴天", "雪天" },
        Value = "晴天",
        Callback = function(v) selectedWeather = v end
    })
    FunTab:Button({
        Title = "确认变换天气",
        Callback = function() changeWeather(weatherSettings[selectedWeather]) end
    })
    FunTab:Divider({ Text = "天空盒" })
    FunTab:Dropdown({
        Title = "选择天空盒",
        Values = { "神青天空1", "神青天空2", "动漫猫羽雫天空" },
        Value = "神青天空1",
        Callback = function(v) selectedSky = v end
    })
    FunTab:Button({
        Title = "确认变换天空",
        Callback = function() changeSky(skySettings[selectedSky]) end
    })

    -- UI设置 Tab
    local SettingsTab = AddTab(OtherSection, "UI设置", "palette")
    SettingsTab:Toggle({
        Title = "启用边框",
        Value = borderEnabled,
        Callback = function(v)
            borderEnabled = v
            local mainFrame = Window.UIElements and Window.UIElements.Main
            if mainFrame then
                local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
                if rainbowStroke then
                    rainbowStroke.Enabled = v
                    if v and windowOpen and not rainbowBorderAnimation then
                        startBorderAnimation(Window, animationSpeed)
                    elseif not v and rainbowBorderAnimation then
                        rainbowBorderAnimation:Disconnect()
                        rainbowBorderAnimation = nil
                    end
                end
            end
        end
    })
    SettingsTab:Toggle({
        Title = "启用字体颜色",
        Value = fontColorEnabled,
        Callback = function(v)
            fontColorEnabled = v
            applyFontColorsToWindow(currentFontColorScheme)
        end
    })
    SettingsTab:Toggle({
        Title = "启用音效",
        Value = soundEnabled,
        Callback = function(v) soundEnabled = v end
    })
    SettingsTab:Toggle({
        Title = "启用背景模糊",
        Value = blurEnabled,
        Callback = function(v)
            blurEnabled = v
            applyBlurEffect(v)
        end
    })
    local colorSchemeNames = {}
    for name, _ in pairs(COLOR_SCHEMES) do table.insert(colorSchemeNames, name) end
    table.sort(colorSchemeNames)
    SettingsTab:Dropdown({
        Title = "边框颜色方案",
        Values = colorSchemeNames,
        Value = "彩虹颜色",
        Callback = function(v)
            currentBorderColorScheme = v
            initializeRainbowBorder(v, animationSpeed)
            playSound()
        end
    })
    SettingsTab:Dropdown({
        Title = "字体颜色方案",
        Values = colorSchemeNames,
        Value = "彩虹颜色",
        Callback = function(v)
            currentFontColorScheme = v
            applyFontColorsToWindow(v)
            playSound()
        end
    })
    local fontOptions = {}
    for _, fontName in ipairs(FONT_STYLES) do
        local description = FONT_DESCRIPTIONS[fontName] or fontName
        table.insert(fontOptions, { text = description, value = fontName })
    end
    table.sort(fontOptions, function(a, b) return a.text < b.text end)
    local fontValues = {}
    local fontValueToName = {}
    for _, option in ipairs(fontOptions) do
        table.insert(fontValues, option.text)
        fontValueToName[option.text] = option.value
    end
    SettingsTab:Dropdown({
        Title = "字体样式",
        Values = fontValues,
        Value = "标准粗体",
        Callback = function(v)
            local fontName = fontValueToName[v]
            if fontName then
                currentFontStyle = fontName
                applyFontStyleToWindow(fontName)
                playSound()
            end
        end
    })
    SettingsTab:Slider({
        Title = "边框转动速度",
        Step = 1,
        Value = { Min = 1, Max = 10, Default = 5 },
        Callback = function(v)
            animationSpeed = v
            if rainbowBorderAnimation then
                rainbowBorderAnimation:Disconnect()
                rainbowBorderAnimation = nil
            end
            if borderEnabled then startBorderAnimation(Window, animationSpeed) end
            applyFontColorsToWindow(currentFontColorScheme)
            playSound()
        end
    })
    SettingsTab:Slider({
        Title = "UI整体缩放",
        Step = 0.1,
        Value = { Min = 0.5, Max = 1.5, Default = 1 },
        Callback = function(v)
            uiScale = v
            applyUIScale(v)
            playSound()
        end
    })
    SettingsTab:Divider()
    SettingsTab:Slider({
        Title = "UI透明度",
        Step = 0.1,
        Value = { Min = 0, Max = 1, Default = 0.2 },
        Callback = function(v)
            Window:ToggleTransparency(v > 0)
            WindUI.TransparencyValue = v
            playSound()
        end
    })
    SettingsTab:Slider({
        Title = "调整UI宽度",
        Step = 10,
        Value = { Min = 500, Max = 800, Default = 600 },
        Callback = function(v)
            if Window.UIElements and Window.UIElements.Main then
                Window.UIElements.Main.Size = UDim2.fromOffset(v, Window.UIElements.Main.Size.Y.Offset)
            end
            playSound()
        end
    })
    SettingsTab:Slider({
        Title = "调整UI高度",
        Step = 10,
        Value = { Min = 300, Max = 600, Default = 400 },
        Callback = function(v)
            if Window.UIElements and Window.UIElements.Main then
                Window.UIElements.Main.Size = UDim2.fromOffset(Window.UIElements.Main.Size.X.Offset, v)
            end
            playSound()
        end
    })
    SettingsTab:Slider({
        Title = "边框粗细",
        Step = 0.5,
        Value = { Min = 1, Max = 5, Default = 1.5 },
        Callback = function(v)
            local mainFrame = Window.UIElements and Window.UIElements.Main
            if mainFrame then
                local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
                if rainbowStroke then rainbowStroke.Thickness = v end
            end
            playSound()
        end
    })
    SettingsTab:Slider({
        Title = "圆角大小",
        Step = 1,
        Value = { Min = 0, Max = 20, Default = 16 },
        Callback = function(v)
            local mainFrame = Window.UIElements and Window.UIElements.Main
            if mainFrame then
                local corner = mainFrame:FindFirstChildOfClass("UICorner")
                if not corner then
                    corner = Instance.new("UICorner")
                    corner.Parent = mainFrame
                end
                corner.CornerRadius = UDim.new(0, v)
            end
            playSound()
        end
    })
    SettingsTab:Button({
        Title = "恢复UI到原位",
        Callback = function()
            if Window.UIElements and Window.UIElements.Main then
                Window.UIElements.Main.Position = UDim2.new(0.5, 0, 0.5, 0)
                playSound()
            end
        end
    })
    SettingsTab:Button({
        Title = "重置UI大小",
        Callback = function()
            if Window.UIElements and Window.UIElements.Main then
                Window.UIElements.Main.Size = UDim2.fromOffset(600, 400)
                playSound()
            end
        end
    })
    SettingsTab:Button({
        Title = "随机字体",
        Callback = function()
            local randomFont = FONT_STYLES[math.random(1, #FONT_STYLES)]
            currentFontStyle = randomFont
            applyFontStyleToWindow(randomFont)
            playSound()
        end
    })
    SettingsTab:Button({
        Title = "随机颜色",
        Callback = function()
            local randomColor = colorSchemeNames[math.random(1, #colorSchemeNames)]
            currentBorderColorScheme = randomColor
            initializeRainbowBorder(randomColor, animationSpeed)
            playSound()
        end
    })
    SettingsTab:Divider()
    SettingsTab:Button({
        Title = "刷新字体颜色",
        Callback = function()
            applyFontColorsToWindow(currentFontColorScheme)
            playSound()
        end
    })
    SettingsTab:Button({
        Title = "刷新字体样式",
        Callback = function()
            applyFontStyleToWindow(currentFontStyle)
            playSound()
        end
    })
    SettingsTab:Button({
        Title = "测试所有字体",
        Callback = function()
            local workingFonts = {}
            for _, fontName in ipairs(FONT_STYLES) do
                local success = pcall(function()
                    local test = Enum.Font[fontName]
                end)
                if success then table.insert(workingFonts, fontName) end
            end
            WindUI:Notify({ Title = "可用字体数", Content = #workingFonts .. "/" .. #FONT_STYLES, Duration = 3 })
            playSound()
        end
    })
    SettingsTab:Button({
        Title = "导出设置",
        Callback = function()
            local settings = {
                font = currentFontStyle,
                borderColor = currentBorderColorScheme,
                fontSize = currentFontColorScheme,
                speed = animationSpeed,
                scale = uiScale
            }
            setclipboard("wdfex-通缉设置: " .. game:GetService("HttpService"):JSONEncode(settings))
            playSound()
        end
    })

    -- ==================== 清理与初始化 ====================
    spawn(function()
        wait(0.5)
        initializeRainbowBorder("彩虹颜色", animationSpeed)
        wait(0.5)
        applyFontStyleToWindow(currentFontStyle)
    end)

    Window:OnClose(function()
        windowOpen = false
        if rainbowBorderAnimation then
            rainbowBorderAnimation:Disconnect()
            rainbowBorderAnimation = nil
        end
        applyBlurEffect(false)
    end)

    Window:OnDestroy(function()
        windowOpen = false
        if rainbowBorderAnimation then
            rainbowBorderAnimation:Disconnect()
            rainbowBorderAnimation = nil
        end
        for _, animation in pairs(fontColorAnimations) do
            animation:Disconnect()
        end
        fontColorAnimations = {}
        applyBlurEffect(false)
    end)

    WindUI:Notify({
        Title = "wdfex-通缉",
        Content = "脚本已加载成功，欢迎使用！",
        Duration = 3,
    })
end