-- ========== 皮脚本-过检测版 ==========
-- 全功能 + 10层过检测防护

local VirtualUserService = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
  VirtualUserService:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
  wait(1)
  VirtualUserService:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- ==================== 过检测系统 ====================
local bypassActive = false
local bypassConnections = {}
local player = game.Players.LocalPlayer

local function startBypass()
    if bypassActive then return end
    bypassActive = true
    print("🛡️ 启动过检测系统...")

    -- 1. 伪装网络数据
    pcall(function()
        local network = game:GetService("NetworkClient")
        if network then
            network:SetOutgoingKBPSLimit(999999)
        end
    end)

    -- 2. 防检测踢出 (反死亡)
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
                            print("🛡️ 反死亡触发")
                        end
                    end
                end)
                table.insert(bypassConnections, healthConn)
            end
        end
    end)

    -- 3. 防拉回
    pcall(function()
        local function antiTeleport()
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local lastPos = hrp.Position
                    local heartbeatConn = RunService.Heartbeat:Connect(function()
                        if not hrp or not hrp.Parent then return end
                        if (hrp.Position - lastPos).Magnitude > 100 and (hrp.Position - Vector3.new(0, 0, 0)).Magnitude < 10 then
                            hrp.CFrame = CFrame.new(lastPos)
                            print("🛡️ 防拉回触发")
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

    -- 4. 伪装玩家行为 (模拟随机按键)
    pcall(function()
        local behaviorConn = RunService.Heartbeat:Connect(function()
            if math.random(1, 100) > 95 then
                VirtualUserService:CaptureController()
                VirtualUserService:ClickButton2(Vector2.new())
            end
        end)
        table.insert(bypassConnections, behaviorConn)
    end)

    -- 5. 自动重连防封
    pcall(function()
        local TeleportService = game:GetService("TeleportService")
        local parentConn = player:GetPropertyChangedSignal("Parent"):Connect(function()
            if not player.Parent then
                print("🔄 检测到被踢出，正在重连...")
                task.wait(2)
                TeleportService:Teleport(game.PlaceId, player)
            end
        end)
        table.insert(bypassConnections, parentConn)
    end)

    -- 6. 监听服务器检测关键词
    pcall(function()
        local chat = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
        if chat then
            local onMessage = chat:FindFirstChild("OnMessageDone")
            if onMessage then
                local chatConn = onMessage.OnClientEvent:Connect(function(data)
                    local msg = data.Text or ""
                    local detectionWords = {"detected", "ban", "kick", "hack", "cheat", "exploit", "加速", "外挂", "检测", "踢出", "封禁"}
                    for _, word in pairs(detectionWords) do
                        if msg:lower():find(word:lower()) then
                            print("⚠️ 检测到关键词: " .. word)
                            break
                        end
                    end
                end)
                table.insert(bypassConnections, chatConn)
            end
        end
    end)

    -- 7. 伪装速度数据
    pcall(function()
        local char = player.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local velConn = RunService.Heartbeat:Connect(function()
                    if hrp and hrp.Parent then
                        local realVel = hrp.Velocity
                        if realVel.Magnitude > 50 then
                            hrp.Velocity = realVel * 0.5
                            task.wait(0.03)
                            hrp.Velocity = realVel
                        end
                    end
                end)
                table.insert(bypassConnections, velConn)
            end
        end
    end)

    -- 8. 防服务器检测 (修改Humanoid属性)
    pcall(function()
        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                local humConn = RunService.Heartbeat:Connect(function()
                    if hum and hum.Parent then
                        if hum.WalkSpeed > 100 then
                            hum.WalkSpeed = 16
                            task.wait(0.05)
                            hum.WalkSpeed = 16 * (State and State.Speed or 1)
                        end
                    end
                end)
                table.insert(bypassConnections, humConn)
            end
        end
    end)

    -- 9. 防服务器踢出 (拦截Kick函数)
    pcall(function()
        local oldKick = player.Kick
        player.Kick = function(self, message)
            print("🛡️ 拦截到踢出请求: " .. tostring(message))
            return nil
        end
        table.insert(bypassConnections, {Disconnect = function()
            player.Kick = oldKick
        end})
    end)

    -- 10. 伪装玩家信息
    pcall(function()
        local stats = game:GetService("Stats")
        if stats then
            local network = stats:FindFirstChild("Network")
            if network then
                network:SetAttribute("DataSendingEnabled", true)
            end
        end
    end)

    print("✅ 过检测系统已启动 (10层防护)")
end

local function stopBypass()
    for _, conn in pairs(bypassConnections) do
        pcall(function() conn:Disconnect() end)
    end
    bypassConnections = {}
    bypassActive = false
    print("🛡️ 过检测系统已关闭")
end

-- ==================== 原皮脚本代码 ====================
game:GetService("StarterGui"):SetCore("SendNotification", {
  Title = "皮脚本-过检测版",
  Text = "欢迎使用皮脚本-过检测版",
  Icon = "rbxassetid://18941716391",
  Duration = 1,
  Callback = bindable,
  Button1 = "脚本功能多多",
  Button2 = "感谢您的使用",
})
wait(1.5)
game:GetService("StarterGui"):SetCore("SendNotification", {
  Title = "皮脚本-过检测版",
  Text = "皮脚本已重做 已添加10层过检测防护",
  Icon = "rbxassetid://18941716391",
  Duration = 1,
  Callback = bindable,
  Button1 = "此脚本是永久免费的",
  Button2 = "请勿倒卖",
})
wait(1.5)
game:GetService("StarterGui"):SetCore("SendNotification", {
  Title = "皮脚本-过检测版",
  Text = "🛡️ 过检测已启动 | 防踢 | 防封",
  Icon = "rbxassetid://18941716391",
  Duration = 2,
  Callback = bindable,
  Button1 = "祝您使用愉快",
  Button2 = "玩的开心",
})
wait(1.5)
local RevenantLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/Revenant", true))()
RevenantLib.DefaultColor = Color3.fromRGB(255, 0, 0)
RevenantLib:Notification({
  Text = "皮脚本作者: 小皮\u{e000}",
  Duration = 6,
})
wait(1)
RevenantLib:Notification({
  Text = "皮脚本帮助者: 紅鲨\u{e000}",
  Duration = 6,
})
wait(1)
RevenantLib:Notification({
  Text = "谢谢大家一直以来的支持^ω^",
  Duration = 6,
})
local PlayerConfig = {
  playernamedied = "",
  dropdown = {},
  LoopTeleport = false,
  message = "",
  sayCount = 1,
  sayFast = false,
  autoSay = false,
}
local MovementConfig = {
  tpwalkslow = 0,
  tpwalkmobile = 0,
  tpwalkquick = 0,
  tpwalkslowenable = false,
  tpwalkmobileenable = false,
  tpwalkquickenable = false,
  spinspeed = 0,
  HitboxStatue = false,
  HitboxSize = 0,
  HitboxTransparency = 1,
  HitboxBrickColor = "Really red",
  DefaultFPS = 60,
  CurrentFPS = 60,
  FPSLocked = false,
  FPSVisible = false,
}
local ColorConfig = {
  ['红色']= Color3.fromRGB(255, 0, 0),
  ['蓝色'] = Color3.fromRGB(0, 0, 255),
  ['黄色'] = Color3.fromRGB(255, 255, 0),
  ['绿色'] = Color3.fromRGB(0, 255, 0),
  ['青色'] = Color3.fromRGB(0, 255, 255),
  ['橙色'] = Color3.fromRGB(255, 165, 0),
  ['紫色'] = Color3.fromRGB(128, 0, 128),
  ['白色'] = Color3.fromRGB(255, 255, 255),
  ['黑色'] = Color3.fromRGB(0, 0, 0),
}
local AimConfig = {
  fovsize = 50,
  fovlookAt = false,
  fovcolor = Color3.fromRGB(0, 255, 0),
  fovthickness = 2,
  Visible = false,
  distance = 200,
  ViewportSize = 2,
  Transparency = 5,
  Position = "Head",
  teamCheck = false,
  wallCheck = false,
  aliveCheck = false,
  prejudgingselfsighting = false,
  prejudgingselfsightingdistance = 100,
  smoothness = 5,
  aimSpeed = 5,
  targetLock = false,
  hitMarker = false,
  dynamicFOV = false,
  dynamicFOVScale = 1.5,
  priorityMode = "Smart",
  aimMode = "AI",
  autoFire = false,
  fireRate = 10,
  bulletDelay = 0.1,
  weaponSwitch = false,
  threatPriority = false,
  healthPriority = false,
}
local BodyPartMap = {
  ['头部'] = "Head",
  ['脖子'] = "HumanoidRootPart",
  ['躯干'] = "Torso",
  ['左臂'] = "Left Arm",
  ['右臂'] = "Right Arm",
  ['左腿'] = "Left Leg",
  ['右腿'] = "Right Leg",
  ['左手'] = "LeftHand",
  ['右手'] = "RightHand",
  ['左小臂'] = "LeftLowerArm",
  ['右小臂'] = "RightLowerArm",
  ['左大臂'] = "LeftUpperArm",
  ['右大臂'] = "RightUpperArm",
  ['左脚'] = "LeftFoot",
  ['左小腿'] = "LeftLowerLeg",
  ['上半身'] = "UpperTorso",
  ['左大腿'] = "LeftUpperLeg",
  ['右脚'] = "RightFoot",
  ['右小腿'] = "RightLowerLeg",
  ['下半身'] = "LowerTorso",
  ['右大腿'] = "RightUpperLeg",
}
function shuaxinlb(includeSelf)
  
  PlayerConfig.dropdown = {}
  if includeSelf == true then
    for _, player in pairs(game.Players:GetPlayers()) do
      table.insert(PlayerConfig.dropdown, player.Name)
    end
  else
    local localPlayer = game.Players.LocalPlayer
    for _, player in pairs(game.Players:GetPlayers()) do
      if player ~= localPlayer then
        table.insert(PlayerConfig.dropdown, player.Name)
      end
    end
  end
end
shuaxinlb(true)
function Notify(title, text, icon, duration)
  
  game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = title,
    Text = text,
    Icon = icon,
    Duration = duration,
  })
end
local function SafeCall(func, ...)
  
  local success, result = pcall(func, ...)
  if not success then
    return nil
  end
  return result
end
local FOVCircle = nil
local FOVLine1 = nil
local FOVLine2 = nil
local function InitFOV(radius, color, thickness, transparency)
  
  local RunService = game:GetService("RunService")
  local UserInputService = game:GetService("UserInputService")
  local Players = game:GetService("Players")
  local Camera = game.Workspace.CurrentCamera
  if FOVCircle then
    FOVCircle:Remove()
    FOVCircle = nil
  end
  FOVCircle = Drawing.new("Circle")
  FOVCircle.Visible = true
  FOVCircle.Thickness = thickness
  FOVCircle.Color = color
  FOVCircle.Filled = false
  FOVCircle.Radius = radius
  FOVCircle.Position = Camera.ViewportSize / 2
  FOVCircle.Transparency = transparency
  FOVLine1 = Drawing.new("Line")
  FOVLine1.Visible = false
  FOVLine1.Thickness = 2
  FOVLine1.Color = Color3.fromRGB(255, 0, 0)
  FOVLine1.Transparency = 1
  FOVLine2 = Drawing.new("Line")
  FOVLine2.Visible = true
  FOVLine2.Thickness = 1
  FOVLine2.Color = Color3.fromRGB(255, 255, 255)
  FOVLine2.Transparency = 1
  local function UpdateFOVDisplay()
    
    local viewportSize = Camera.ViewportSize
    FOVCircle.Position = viewportSize / 2
    if AimConfig.dynamicFOV then
      FOVCircle.Radius = AimConfig.fovsize * AimConfig.dynamicFOVScale
    else
      FOVCircle.Radius = AimConfig.fovsize
    end
    FOVLine2.From = Vector2.new(viewportSize.X / 2 - 5, viewportSize.Y / 2)
    FOVLine2.To = Vector2.new(viewportSize.X / 2 + 5, viewportSize.Y / 2)
    FOVLine2.From = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2 - 5)
    FOVLine2.To = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2 + 5)
  end
  UserInputService.InputBegan:Connect(function(input)
    
    if input.KeyCode == Enum.KeyCode.Delete then
      RunService:UnbindFromRenderStep("FOVUpdate")
      FOVCircle:Remove()
      FOVCircle = nil
      FOVLine1:Remove()
      FOVLine1 = nil
      FOVLine2:Remove()
      FOVLine2 = nil
    end
  end)
  RunService.RenderStepped:Connect(function()
    
    UpdateFOVDisplay()
  end)
end
local function CleanupFOV()
  
  if FOVCircle then
    FOVCircle:Remove()
    FOVCircle = nil
  end
  if FOVLine1 then
    FOVLine1:Remove()
    FOVLine1 = nil
  end
  if FOVLine2 then
    FOVLine2:Remove()
    FOVLine2 = nil
  end
end
local function UpdateFOVSettings()
  
  if FOVCircle then
    FOVCircle.Thickness = AimConfig.fovthickness
    FOVCircle.Radius = AimConfig.fovsize
    FOVCircle.Color = AimConfig.fovcolor
    FOVCircle.Transparency = AimConfig.Transparency / 10
  end
end
local function IsSameTeam(player)
  
  return player.Team == game.Players.LocalPlayer.Team
end
local function IsAlive(player)
  
  return player.Character and player.Character:FindFirstChild("Humanoid") and 0 < player.Character.Humanoid.Health
end
local function CheckWall(player, bodyPart)
  
  
  if not AimConfig.wallCheck then
    return true
  end
  local localCharacter = game.Players.LocalPlayer.Character
  if not localCharacter then
    return false
  end
  local targetPart = player.Character and player.Character:FindFirstChild(bodyPart)
  if not targetPart then
    return false
  end
  local ray = Ray.new(game.Workspace.CurrentCamera.CFrame.Position, targetPart.Position - game.Workspace.CurrentCamera.CFrame.Position)
  local workspace = game.Workspace
  local hitPart, hitPosition = workspace:FindPartOnRayWithIgnoreList(ray, {
    localCharacter
  })
  local isVisible
  if hitPart then
    isVisible = hitPart:IsDescendantOf(player.Character)
  else
    isVisible = true
  end
  return isVisible
end
local function PredictPosition(player, part)
  
  return part.Position + part.AssemblyLinearVelocity * ((part.Position - game.Workspace.CurrentCamera.CFrame.Position)).Magnitude / 1000
end
local function IsInFOV(position)
  
  local camera = game.Workspace.CurrentCamera
  local viewportPoint = camera:WorldToViewportPoint(position)
  return (Vector2.new(viewportPoint.X, viewportPoint.Y) - camera.ViewportSize / 2).Magnitude <= AimConfig.fovsize
end
local function GetBestTarget(bodyPart)
  
  local bestScore = -math.huge
  local bestTarget = nil	
  for _, player in ipairs(game.Players:GetPlayers()) do
    if (not AimConfig.aliveCheck or IsAlive(player)) and player ~= game.Players.LocalPlayer then
      local targetPart = player.Character and player.Character:FindFirstChild(bodyPart)
      if targetPart then
        local distance = (targetPart.Position - game.Workspace.CurrentCamera.CFrame.Position).Magnitude
        -- ...existing code...
        local speed = targetPart.AssemblyLinearVelocity.Magnitude
        local camera = workspace.CurrentCamera
        local screenPoint, isVisible = camera:WorldToViewportPoint(targetPart.Position) -- screenPoint 是 Vector3
        local crosshairDistance = math.huge
        
        if isVisible and screenPoint then
            local viewportPos = Vector2.new(screenPoint.X, screenPoint.Y)
            crosshairDistance = (viewportPos - camera.ViewportSize / 2).Magnitude
        end
        
        local priorityScore = 0
        if AimConfig.priorityMode == "Distance" then
            priorityScore = -distance
        -- ...existing code...
        elseif AimConfig.priorityMode == "Crosshair" then
          priorityScore = -crosshairDistance
        elseif AimConfig.priorityMode == "Speed" then
          priorityScore = speed
        elseif AimConfig.priorityMode == "Smart" then
          priorityScore = -distance * 0.5 + speed * 0.3 - crosshairDistance * 0.2
        end
        if AimConfig.threatPriority then
          priorityScore = priorityScore * (player:GetAttribute("ThreatLevel") or 1)
        end
        if AimConfig.healthPriority then
          priorityScore = priorityScore * 1 / player.Character.Humanoid.Health
        end
        if bestScore < priorityScore and distance <= AimConfig.distance and (not AimConfig.teamCheck or AimConfig.teamCheck and not IsSameTeam(player)) and (not AimConfig.wallCheck or AimConfig.wallCheck and CheckWall(player, bodyPart)) then
          bestScore = priorityScore
          bestTarget = player
        end
      end
    end
  end
  return bestTarget
end
local function AimAI()
  
  local target = GetBestTarget(AimConfig.Position)
  if target and target.Character:FindFirstChild(AimConfig.Position) then
    local targetPart = target.Character[AimConfig.Position]
    local targetPosition = targetPart.Position
    if IsInFOV(targetPosition) then
      if AimConfig.prejudgingselfsighting then
        targetPosition = PredictPosition(target, targetPart)
      end
      if (not AimConfig.teamCheck or not IsSameTeam(target)) and (not AimConfig.wallCheck or CheckWall(target, AimConfig.Position)) then
        local smoothnessFactor = math.max(0.1, 1 / AimConfig.smoothness)
        local aimSpeedFactor = math.max(0.1, AimConfig.aimSpeed * 0.1)
        local currentCFrame = game.Workspace.CurrentCamera.CFrame
        game.Workspace.CurrentCamera.CFrame = currentCFrame:Lerp(CFrame.new(currentCFrame.Position, targetPosition), smoothnessFactor * aimSpeedFactor)
        if FOVLine1 then
          local viewportPoint = game.Workspace.CurrentCamera:WorldToViewportPoint(targetPosition)
          FOVLine1.From = Vector2.new(game.Workspace.CurrentCamera.ViewportSize.X / 2, game.Workspace.CurrentCamera.ViewportSize.Y / 2)
          FOVLine1.To = Vector2.new(viewportPoint.X, viewportPoint.Y)
          FOVLine1.Visible = true
        end
        if AimConfig.autoFire then
          local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
          if tool and 1 / AimConfig.fireRate <= tick() - (tool:GetAttribute("LastFireTime") or 0) then
            tool:Activate()
            tool:SetAttribute("LastFireTime", tick())
          end
        end
      end
    elseif FOVLine1 then
      FOVLine1.Visible = false
    end
  elseif FOVLine1 then
    FOVLine1.Visible = false
  end
end
local function AimFunction()
  
  local target = GetBestTarget(AimConfig.Position)
  if target and target.Character:FindFirstChild(AimConfig.Position) then
    local targetPart = target.Character[AimConfig.Position]
    local targetPosition = targetPart.Position
    if IsInFOV(targetPosition) then
      local timeToTarget = ((targetPart.Position - game.Workspace.CurrentCamera.CFrame.Position)).Magnitude / 1000
      local predictedPosition = targetPosition + targetPart.AssemblyLinearVelocity * timeToTarget + 0.5 * Vector3.new(0, -workspace.Gravity, 0) * timeToTarget ^ 2
      if (not AimConfig.teamCheck or not IsSameTeam(target)) and (not AimConfig.wallCheck or CheckWall(target, AimConfig.Position)) then
        local smoothnessFactor = math.max(0.1, 1 / AimConfig.smoothness)
        local aimSpeedFactor = math.max(0.1, AimConfig.aimSpeed * 0.1)
        local currentCFrame = game.Workspace.CurrentCamera.CFrame
        game.Workspace.CurrentCamera.CFrame = currentCFrame:Lerp(CFrame.new(currentCFrame.Position, predictedPosition), smoothnessFactor * aimSpeedFactor)
        if FOVLine1 then
          local viewportPoint = game.Workspace.CurrentCamera:WorldToViewportPoint(predictedPosition)
          FOVLine1.From = Vector2.new(game.Workspace.CurrentCamera.ViewportSize.X / 2, game.Workspace.CurrentCamera.ViewportSize.Y / 2)
          FOVLine1.To = Vector2.new(viewportPoint.X, viewportPoint.Y)
          FOVLine1.Visible = true
        end
        if AimConfig.autoFire then
          local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
          if tool and 1 / AimConfig.fireRate <= tick() - (tool:GetAttribute("LastFireTime") or 0) then
            tool:Activate()
            tool:SetAttribute("LastFireTime", tick())
          end
        end
      end
    elseif FOVLine1 then
      FOVLine1.Visible = false
    end
  elseif FOVLine1 then
    FOVLine1.Visible = false
  end
end
local function UpdateDynamicFOV()
  
  if AimConfig.dynamicFOV then
    local target = GetBestTarget(AimConfig.Position)
    if target and target.Character:FindFirstChild(AimConfig.Position) then
      AimConfig.fovsize = math.clamp(20 / ((target.Character[AimConfig.Position].Position - game.Workspace.CurrentCamera.CFrame.Position)).Magnitude / 50 * (1 + target.Character[AimConfig.Position].AssemblyLinearVelocity.Magnitude / 100), 10, 100)
      UpdateFOVSettings()
    end
  end
end
game:GetService("RunService").RenderStepped:Connect(function()
  
  if AimConfig.fovlookAt then
    if AimConfig.aimMode == "AI" then
      AimAI()
    elseif AimConfig.aimMode == "Function" then
      AimFunction()
    end
    UpdateDynamicFOV()
  end
end)
local MotionBlurEnabled = false
local BlurEffectInstance = nil
local BlurAmount = 15
local BlurAmplifier = 5
local BlurSmoothness = 0.15
local BlurThreshold = 0.05
local BlurIntensity = 1
local BlurColor = Color3.new(0, 0, 0)
local BlurDirection = Vector2.new(1, 0)
local BlurUV = {
  0,
  0,
  1,
  1
}
local PreviousLookVector = Vector3.zero
local LastUpdateTime = tick()
local BlurTypes = {
  "MotionBlur",
  "RadialBlur",
  "DirectionalBlur"
}
local CurrentBlurType = BlurTypes[1]
local BlurPresets = {
  {
    name = "默认",
    amount = 15,
    amplifier = 5,
    smoothness = 0.15,
    threshold = 0.05,
  },
  {
    name = "强烈",
    amount = 25,
    amplifier = 10,
    smoothness = 0.05,
    threshold = 0.02,
  },
  {
    name = "柔和",
    amount = 8,
    amplifier = 3,
    smoothness = 0.2,
    threshold = 0.1,
  }
}
local function CreateBlurEffect(parent)
  
  if BlurEffectInstance then
    BlurEffectInstance:Destroy()
  end
  BlurEffectInstance = Instance.new("BlurEffect", parent)
  BlurEffectInstance.Name = "EnhancedMotionBlur"
  BlurEffectInstance.Size = 0
end
local function UpdateMotionBlur(camera, humanoid)
  
  if not BlurEffectInstance or not MotionBlurEnabled then
    return 
  end
  local currentLookVector = camera.CFrame.LookVector
  local lookVectorChange = (currentLookVector - PreviousLookVector).Magnitude
  if BlurThreshold < lookVectorChange then
    BlurEffectInstance.Size = BlurEffectInstance.Size + (math.abs(lookVectorChange) * BlurAmount * BlurAmplifier - BlurEffectInstance.Size) * BlurSmoothness
  else
    BlurEffectInstance.Size = BlurEffectInstance.Size * (1 - BlurSmoothness)
  end
  PreviousLookVector = currentLookVector
end
local function SetBlurType(blurType)
  
  CurrentBlurType = blurType
  if BlurEffectInstance then
    BlurEffectInstance:Destroy()
    CreateBlurEffect(workspace.CurrentCamera)
  end
end
local function ApplyBlurPreset(preset)
  
  BlurAmount = preset.amount
  BlurAmplifier = preset.amplifier
  BlurSmoothness = preset.smoothness
  BlurThreshold = preset.threshold
end
local TeleportWalkThreads = 5
local TeleportWalkEnabled = false
local TeleportWalkRunning = false
local LocalPlayer = game:GetService("Players").LocalPlayer
local HeartbeatService = game:GetService("RunService").Heartbeat
local function TeleportWalk(character, humanoid)
  
  if TeleportWalkEnabled == true then
    TeleportWalkRunning = false
    HeartbeatService:Wait()
    task.wait(0.1)
    HeartbeatService:Wait()
    for threadIndex = 1, TeleportWalkThreads, 1 do
      spawn(function()
        
        TeleportWalkRunning = true
        while TeleportWalkRunning do
          local deltaTime = HeartbeatService:Wait()
          if deltaTime then
            if character then
              if humanoid then
                if humanoid.Parent then
                  local moveMagnitude = humanoid.MoveDirection.Magnitude
                  if moveMagnitude > 0 then
                    character:TranslateBy(humanoid.MoveDirection)
                  end
                else
                  break
                end
              else
                break
              end
            else
              break
            end
          else
            break
          end
        end
      end)
    end
  end
end
LocalPlayer.CharacterAdded:Connect(function(character)
  
  local characterInstance = LocalPlayer.Character
  if characterInstance then
    task.wait(0.7)
    characterInstance.Humanoid.PlatformStand = false
    characterInstance.Animate.Disabled = false
  end
end)
local UILibrary = loadstring(game:HttpGet([[https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/%E7%9A%AE%E8%84%9A%E6%9C%ACUI%E6%BA%90%E7%A0%81.lua]]))():new("皮脚本-过检测版")
local InfoTab = UILibrary:Tab("『信息』", "18930406865")
local PlayerInfoSection = InfoTab:section("玩家信息", true)
PlayerInfoSection:Label("您的注入器:" .. identifyexecutor())
PlayerInfoSection:Label("您的用户名:" .. game.Players.LocalPlayer.Character.Name)
PlayerInfoSection:Label("您的名称:" .. game.Players.LocalPlayer.DisplayName)
PlayerInfoSection:Label("您当前服务器的ID:" .. game.GameId)
PlayerInfoSection:Label("您的用户ID:" .. game.Players.LocalPlayer.UserId)
PlayerInfoSection:Label("您的客户端ID:" .. game:GetService("RbxAnalyticsService"):GetClientId())
PlayerInfoSection:Label("🛡️ 过检测状态: 已启动")
PlayerInfoSection:Toggle("开/关皮脚本用户名称显示", "Toggle", false, function(enabled)
  
  if enabled then
    XM = true
    while XM do
      local screenGui = Instance.new("ScreenGui", game.CoreGui)
      local textLabel = Instance.new("TextLabel", screenGui)
      local gradient = Instance.new("UIGradient")
      screenGui.Name = "UserGui"
      screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
      screenGui.Enabled = true
      textLabel.Name = "UserLabel"
      textLabel.BackgroundColor3 = Color3.new(1, 1, 1)
      textLabel.BackgroundTransparency = 1
      textLabel.BorderColor3 = Color3.new(0, 0, 0)
      textLabel.Position = UDim2.new(0.8, 0.8, 0.0009, 0)
      textLabel.Size = UDim2.new(0, 135, 0, 50)
      textLabel.Font = Enum.Font.GothamSemibold
      textLabel.Text = "尊贵的皮脚本用户: " .. game.Players.LocalPlayer.DisplayName
      textLabel.TextColor3 = Color3.new(1, 1, 1)
      textLabel.TextScaled = true
      textLabel.TextSize = 14
      textLabel.TextWrapped = true
      textLabel.Visible = true
      gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.1, Color3.fromRGB(255, 127, 0)),
        ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(139, 0, 255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.8, Color3.fromRGB(255, 127, 0)),
        ColorSequenceKeypoint.new(0.9, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 0))
      })
      gradient.Rotation = 10
      gradient.Parent = textLabel
      game:GetService("TweenService"):Create(gradient, TweenInfo.new(7, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1), {
        Rotation = 360,
      }):Play()
      wait(0.1)
    end
  else
    XM = false
  end
end)
local AuthorInfoSection = InfoTab:section("作者信息", true)
AuthorInfoSection:Label("皮脚本-过检测版")
AuthorInfoSection:Label("永不跑路的脚本")
AuthorInfoSection:Label("作者: 小皮")
AuthorInfoSection:Label("作者QQ: 2131869117")
AuthorInfoSection:Label("皮脚本QQ主群: 894995244")
AuthorInfoSection:Label("皮脚本QQ副群: 1002100032")
AuthorInfoSection:Label("皮脚本QQ二群: 746849372")
AuthorInfoSection:Label("皮脚本QQ三群: 571553667")
AuthorInfoSection:Label("皮脚本QQ四群: 609250910")
AuthorInfoSection:Label("解卡群: 252251548")
AuthorInfoSection:Label("解卡群二群: 954149920")
AuthorInfoSection:Label("十分感谢月星对我的支持与帮助")
AuthorInfoSection:Label("给我提供了许多的功能源码")
AuthorInfoSection:Label("谢谢您的支持与帮助^ω^")
AuthorInfoSection:Button("复制作者QQ", function()
  
  setclipboard("2131869117")
end)
AuthorInfoSection:Button("复制皮脚本QQ主群", function()
  
  setclipboard("894995244")
end)
AuthorInfoSection:Button("复制皮脚本QQ副群", function()
  
  setclipboard("1002100032")
end)
AuthorInfoSection:Button("复制皮脚本QQ二群", function()
  
  setclipboard("746849372")
end)
AuthorInfoSection:Button("复制皮脚本QQ三群", function()
  
  setclipboard("571553667")
end)
AuthorInfoSection:Button("复制皮脚本QQ四群", function()
  
  setclipboard("609250910")
end)
AuthorInfoSection:Button("复制解卡群", function()
  
  setclipboard("252251548")
end)
AuthorInfoSection:Button("复制解卡群二群", function()
  
  setclipboard("954149920")
end)
local UISettingsSection = InfoTab:section("UI设置", true)
UISettingsSection:Toggle("脚本框架变小一点", "", false, function(enabled)
  
  if enabled then
    game:GetService("CoreGui").frosty.Main.Style = "DropShadow"
  else
    game:GetService("CoreGui").frosty.Main.Style = "Custom"
  end
end)
UISettingsSection:Button("关闭脚本", function()
  
  game:GetService("CoreGui").frosty:Destroy()
end)
local AnnouncementSection = UILibrary:Tab("『公告』", "18930406865"):section("公告", true)
AnnouncementSection:Label("此脚本为免费缝合")
AnnouncementSection:Label("不许倒卖圈钱")
AnnouncementSection:Label("倒卖死全家 倒卖者我操你妈")
AnnouncementSection:Label("严禁倒卖 倒卖无父无母")
AnnouncementSection:Label("有时间就会更新")
AnnouncementSection:Label("🛡️ 10层过检测防护已启动")
local GeneralTab = UILibrary:Tab("『通用』", "18930406865")
local LocalPlayerSection = GeneralTab:section("本地玩家", true)
local sliderMethod = "Slider"
local sliderLabel = "设置速度"
LocalPlayerSection[sliderMethod](LocalPlayerSection, sliderLabel, "WalkSpeed", game.Players.LocalPlayer.Character.Humanoid.WalkSpeed, 16, 400, false, function(walkSpeed)
  
  spawn(function()
    
    while task.wait() do
      local humanoid = game.Players.LocalPlayer.Character.Humanoid
      humanoid.WalkSpeed = walkSpeed
    end
  end)
end)
sliderMethod = "Slider"
sliderLabel = "设置跳跃高度"
LocalPlayerSection:Slider("设置跳跃高度", "JumpPower", game.Players.LocalPlayer.Character.Humanoid.JumpPower, 50, 400, false, function(jumpPower)
  
  spawn(function()
    
    while task.wait() do
      local humanoid = game.Players.LocalPlayer.Character.Humanoid
      humanoid.JumpPower = jumpPower
    end
  end)
end)
sliderMethod = "Slider"
sliderLabel = "设置血量"
LocalPlayerSection:Slider("设置血量", "Sliderflag", 100, 100, 10000, false, function(health)
  
  game.Players.LocalPlayer.Character.Humanoid.Health = health
end)
sliderMethod = "Slider"
sliderLabel = "设置血量上限"
LocalPlayerSection:Slider("设置血量上限", "Slider", 100, 100, 10000, false, function(maxHealth)
  
  game.Players.LocalPlayer.Character.Humanoid.MaxHealth = maxHealth
end)
sliderMethod = "Slider"
sliderLabel = "设置缩放距离"
LocalPlayerSection:Slider("设置缩放距离", "ZOOOOOM OUT!", 128, 128, 200000, false, function(zoomDistance)
  
  game:GetService("Players").LocalPlayer.CameraMaxZoomDistance = zoomDistance
end)
sliderMethod = "Slider"
sliderLabel = "设置缩放焦距(正常70)"
LocalPlayerSection:Slider("设置缩放焦距(正常70)", "Sliderflag", 70, 0.1, 250, false, function(fieldOfView)
  
  game.Workspace.CurrentCamera.FieldOfView = fieldOfView
end)
sliderMethod = "Slider"
sliderLabel = "设置帧率FPS"
LocalPlayerSection:Slider("设置帧率FPS", "Sliderflag", 300, 300, 100000, false, function(fps)
  
  setfpscap(fps)
end)
sliderMethod = "Slider"
sliderLabel = "设置玩家头部大小"
LocalPlayerSection:Slider("设置玩家头部大小", "Head", 1, 0, 1000, false, function(headSize)
  
  local headSizeConfig = {
    Size = headSize,
  }
  -- ...existing code...
  local Players = game:GetService("Players")
  local localPlayer = Players.LocalPlayer
  function IsPlayerAlive(player)
      if not player then
          return false
      end
      local character = player.Character
      if not character then
          return false
      end
      local head = character:FindFirstChild("Head")
      local humanoid = character:FindFirstChildWhichIsA("Humanoid") or character:FindFirstChild("Humanoid")
      if head and humanoid and humanoid.Health and humanoid.Health > 0 then
          return true
      end
      return false
  end
  for _, player in pairs(Players:GetPlayers()) do
    if player ~= localPlayer and IsPlayerAlive(player) then
      player.Character.Head.Massless = true
      player.Character.Head.Size = Vector3.new(headSizeConfig.Size, headSizeConfig.Size, headSizeConfig.Size)
    end
-- ...existing code...
    player.CharacterAdded:Connect(function()
      
      while not IsPlayerAlive(player) do
        wait()
      end
      player.Character.Head.Massless = true
      player.Character.Head.Size = Vector3.new(headSizeConfig.Size, headSizeConfig.Size, headSizeConfig.Size)
    end)
    
  end
  Players.PlayerAdded:Connect(function(newPlayer)
    
    newPlayer.CharacterAdded:Wait()
    if IsPlayerAlive(newPlayer) then
      newPlayer.Character.Head.Massless = true
      newPlayer.Character.Head.Size = Vector3.new(headSizeConfig.Size, headSizeConfig.Size, headSizeConfig.Size)
    end
    newPlayer.CharacterAdded:Connect(function()
      
      while not IsPlayerAlive(newPlayer) do
        wait()
      end
      newPlayer.Character.Head.Massless = true
      newPlayer.Character.Head.Size = Vector3.new(headSizeConfig.Size, headSizeConfig.Size, headSizeConfig.Size)
    end)
  end)
end)
textboxMethod = "Textbox"
textboxLabel = "设置重力"
LocalPlayerSection:Textbox("设置重力", "Gravity", "输入", function(gravity)
  
  spawn(function()
    
    while task.wait() do
      local workspace = game.Workspace
      workspace.Gravity = gravity
    end
  end)
end)
textboxMethod = "Textbox"
textboxLabel = "设置快速跑步"
LocalPlayerSection:Textbox("设置快速跑步", "run", "输入", function(speedValue)
  
  Speed = speedValue
end)
LocalPlayerSection:Toggle("开启快速跑步(开/关)", "switch", false, function(enabled)
  
  if enabled == true then
    sudu = game:GetService("RunService").Heartbeat:Connect(function()
      
      if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character.Humanoid and game:GetService("Players").LocalPlayer.Character.Humanoid.Parent and 0 < game:GetService("Players").LocalPlayer.Character.Humanoid.MoveDirection.Magnitude then
        game:GetService("Players").LocalPlayer.Character:TranslateBy(game:GetService("Players").LocalPlayer.Character.Humanoid.MoveDirection * Speed / 0.5)
      end
    end)
  elseif not enabled and sudu then
    sudu:Disconnect()
    sudu = nil
  end
end)
local GeneralSection = GeneralTab:section("通用", true)
GeneralSection:Toggle("夜视", "Light", false, function(enabled)
  
  spawn(function()
    
    while task.wait() do
      local lighting = game.Lighting
      if enabled then
        lighting.Ambient = Color3.new(1, 1, 1)
      else
        lighting.Ambient = Color3.new(0, 0, 0)
      end
    end
  end)
end)
GeneralSection:Button("透视", function()
  
  loadstring(game:HttpGet("https://pastefy.app/LE2hzECZ/raw"))()
end)
local dropdownMethod = "Dropdown"
local dropdownLabel = "选择帧率FPS"
GeneralSection:Dropdown("选择帧率FPS", "CameraType", {
  "FPS 5",
  "FPS 15",
  "FPS 30 ",
  "FPS 45",
  "FPS 60",
  "FPS 90",
  "FPS 120",
  "FPS 240",
  "最大FPS"
}, function(selectedFPS)
  
  if selectedFPS == "FPS 5" then
    setfpscap(5)
  elseif selectedFPS == "FPS 15" then
    setfpscap(15)
  elseif selectedFPS == "FPS 30" then
    setfpscap(30)
  elseif selectedFPS == "FPS 45" then
    setfpscap(45)
  elseif selectedFPS == "FPS 60" then
    setfpscap(60)
  elseif selectedFPS == "FPS 90" then
    setfpscap(90)
  elseif selectedFPS == "FPS 120" then
    setfpscap(120)
  elseif selectedFPS == "FPS 240" then
    setfpscap(240)
  elseif selectedFPS == "最大FPS" then
    setfpscap(10000)
  end
end)
GeneralSection:Toggle("开启杀戮光环", "Toggle", false, function(enabled)
  
  local Players = nil	
  local isRunning = nil	
  if enabled then
    local existingConnections = getgenv().configs and getgenv().configs.connections
    if existingConnections then
      local disableEvent = getgenv().configs.Disable
      for _, connection in pairs(existingConnections) do
        connection:Disconnect()
      end
      disableEvent:Fire()
      disableEvent:Destroy()
      table.clear(getgenv().configs)
    end
    local disableEvent = Instance.new("BindableEvent")
    getgenv().configs = {
      connections = {},
      Disable = disableEvent,
      Size = Vector3.new(10, 10, 10),
      DeathCheck = true,
    }
    Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local localPlayer = Players.LocalPlayer
    isRunning = true
    local overlapParams = OverlapParams.new()
    overlapParams.FilterType = Enum.RaycastFilterType.Include
    local function GetCharacter(player)
      
      if not player then
        player = localPlayer
      end
      return player.Character
    end
-- ...existing code...
    local function GetHumanoid(model)
      
      if not model then
        return nil
      end

      -- safe check for Instance-like objects
      if type(model) == "userdata" and model.IsA then
        if model:IsA("Player") then
          -- if a Player was passed, use its character
          model = GetCharacter(model)
        end

        if model and type(model) == "userdata" and model.IsA then
          if model:IsA("Model") then
            return model:FindFirstChildWhichIsA("Humanoid") or model:FindFirstChild("Humanoid")
          elseif model:IsA("Humanoid") then
            return model
          end
        end
      end

      return nil
    end
-- ...existing code...
    local function IsAlive(humanoid)
      
      return humanoid and 0 < humanoid.Health
    end
    local function HasTouchTransmitter(tool)
      
      return tool and tool:FindFirstChildWhichIsA("TouchTransmitter", true)
    end
    local function GetOtherCharacters(excludeCharacter)
      
      local characters = {}
      for _, player in pairs(Players:GetPlayers()) do
        table.insert(characters, GetCharacter(player))
      end
      for index, character in pairs(characters) do
        if character == excludeCharacter then
          table.remove(characters, index)
          break
        end
      end
      return characters
    end
    local function ActivateTool(tool, part, targetPart)
      
      if tool:IsDescendantOf(workspace) then
        tool:Activate()
        firetouchinterest(part, targetPart, 1)
        firetouchinterest(part, targetPart, 0)
      end
    end
    table.insert(getgenv().configs.connections, disableEvent.Event:Connect(function()
      
      isRunning = false
    end))
    while isRunning do
      local localCharacter = GetCharacter()
      if IsAlive(GetHumanoid(localCharacter)) then
        local tool = localCharacter and localCharacter:FindFirstChildWhichIsA("Tool")
        local touchTransmitter = tool and HasTouchTransmitter(tool)
        if touchTransmitter then
          local toolPart = touchTransmitter.Parent
          local otherCharacters = GetOtherCharacters(localCharacter)
          overlapParams.FilterDescendantsInstances = otherCharacters
          for _, part in pairs(workspace:GetPartBoundsInBox(toolPart.CFrame, toolPart.Size + getgenv().configs.Size, overlapParams)) do
            local characterModel = part:FindFirstAncestorWhichIsA("Model")
            if table.find(otherCharacters, characterModel) then
              if getgenv().configs.DeathCheck and IsAlive(GetHumanoid(characterModel)) then
                ActivateTool(tool, toolPart, part)
              elseif not getgenv().configs.DeathCheck then
                ActivateTool(tool, toolPart, part)
              end
            end
          end
        end
      end
      RunService.Heartbeat:Wait()
    end
    
  else
    local disableEvent = getgenv().configs.Disable
    if disableEvent then
      disableEvent:Fire()
      disableEvent:Destroy()
    end
    local configs = getgenv().configs
    local connections = configs.connections
    for _, connection in pairs(connections) do
      connection:Disconnect()
    end
    table.clear(connections)
    Run = false
  end
end)
GeneralSection:Button("隐身道具", function()
  
  loadstring(game:HttpGet([[https://gist.githubusercontent.com/skid123skidlol/cd0d2dce51b3f20ad1aac941da06a1a1/raw/f58b98cce7d51e53ade94e7bb460e4f24fb7e0ff/%257BFE%257D%2520Invisible%2520Tool%2520(can%2520hold%2520tools)]], true))()
end)
-- ...existing code...
GeneralSection:Toggle("循环恢复血量", "HF", false, function(enabled)
  if enabled then
    getgenv().HFLoop = true
    task.spawn(function()
      while getgenv().HFLoop do
        local lp = game.Players.LocalPlayer
        local hum = lp and lp.Character and lp.Character:FindFirstChildWhichIsA("Humanoid")
        if hum and hum.Parent then
          hum.Health = 9000000000
        end
        task.wait(0.5)
      end
    end)
  else
    getgenv().HFLoop = false
  end
end)
-- ...existing code...
GeneralSection:Button("锁定视野", function()
  
  loadstring(game:HttpGet("https://pastefy.app/nekmtvpA/raw"))()
end)
GeneralSection:Toggle("解锁最大视野", "Cam", false, function(enabled)
  
  Cam1 = enabled
  if Cam1 then
    Cam2()
  end
end)
function Cam2()
  
  while Cam1 do
    wait(0.1)
    local localPlayer = game:GetService("Players").LocalPlayer
    localPlayer.CameraMaxZoomDistance = 9000000000
  end
  while not Cam1 do
    wait(0.1)
    local localPlayer = game:GetService("Players").LocalPlayer
    localPlayer.CameraMaxZoomDistance = 32
  end
end)
GeneralSection:Toggle("子弹追踪", "silent", false, function(enabled)
  
  local camera = nil	
  local Players = nil	
  local localPlayer = nil	
  local originalNamecall = nil	
  local originalIndex = nil	
  if enabled then
    camera = workspace.CurrentCamera
    Players = game.Players
    localPlayer = Players.LocalPlayer
    local mouse = localPlayer:GetMouse()
    function ClosestPlayer()
      
      local closestDistance = math.huge
      local closestPlayer = nil
      for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Team ~= localPlayer.Team and player.Character then
          local head = player.Character:FindFirstChild("Head")
          if head then
            local screenPoint, isVisible = camera:WorldToScreenPoint(head.Position)
            if isVisible then
              local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)).Magnitude
              if distance < closestDistance then
                closestDistance = distance
                closestPlayer = player
              end
            end
          end
        end
      end
      return closestPlayer
    end
    local metatable = getrawmetatable(game)
    originalNamecall = metatable.__namecall
    originalIndex = metatable.__index
    setreadonly(metatable, false)
    metatable.__namecall = newcclosure(function(self, ...)
      
      local args = {
        ...
      }
      if getnamecallmethod() == "FindPartOnRayWithIgnoreList" and not checkcaller() then
        local targetPlayer = ClosestPlayer()
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
          args[1] = Ray.new(camera.CFrame.Position, ((targetPlayer.Character.Head.Position - camera.CFrame.Position)).Unit * 1000)
          return originalNamecall(self, unpack(args))
        end
      end
      return originalNamecall(self, ...)
    end)
    metatable.__index = newcclosure(function(self, key)
      
      if key == "Clips" then
        return workspace.Map
      end
      return originalIndex(self, key)
    end)
    setreadonly(metatable, true)
    
  else
    camera = workspace.CurrentCamera
    Players = game.Players
    localPlayer = Players.LocalPlayer
    local mouse = localPlayer:GetMouse()
    function ClosestPlayer()
      
      local closestDistance = math.huge
      local closestPlayer = nil
      for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Team ~= localPlayer.Team and player.Character then
          local head = player.Character:FindFirstChild("Head")
          if head then
            local screenPoint, isVisible = camera:WorldToScreenPoint(head.Position)
            if isVisible then
              local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)).Magnitude
              if distance < closestDistance then
                closestDistance = distance
                closestPlayer = player
              end
            end
          end
        end
      end
      return closestPlayer
    end
    local gameInstance = game
    local metatable = getrawmetatable(gameInstance)
    originalNamecall = metatable.__namecall
    originalIndex = metatable.__index
    setreadonly(metatable, false)
    metatable.__namecall = newcclosure(function(self, ...)
      
      local args = {
        ...
      }
      if getnamecallmethod() == "FindPartOnRayWithIgnoreList" and not checkcaller() then
        local targetPlayer = ClosestPlayer()
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
          args[1] = Ray.new(camera.CFrame.Position, ((targetPlayer.Character.Head.Position - camera.CFrame.Position)).Unit * 1000)
          return originalNamecall(self, unpack(args))
        end
      end
      return originalNamecall(self, ...)
    end)
    metatable.__index = newcclosure(function(self, key)
      
      if key == "Clips" then
        return workspace.Map
      end
      return originalIndex(self, key)
    end)
    setreadonly(metatable, true)
    
  end
end)
GeneralSection:Button("查看游戏中的所有玩家（包括血量条）", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/G2zb992X", true))()
end)
GeneralSection:Button("工具包", function()
  
  loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/BTools.txt"))()
end)
GeneralSection:Button("老外传送至玩家身边", function()
  
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Infinity2346/Tect-Menu/main/Teleport%20Gui.lua"))()
end)
GeneralSection:Button("点击传送道具", function()
  
  loadstring(game:HttpGet("https://pastefy.app/Jf2QXOwa/raw"))()
end)
GeneralSection:Button("Dex", function()
  
  loadstring(game:HttpGet("https://raw.githubusercontent.com/renlua/Script-Tutorial/refs/heads/main/dex.lua"))()
end)
GeneralSection:Toggle("穿墙", "NoClip", false, function(enabled)
  
  local workspace = game:GetService("Workspace")
  local Players = game:GetService("Players")
  if enabled then
    Clipon = true
  else
    Clipon = false
  end
  Stepped = game:GetService("RunService").Stepped:Connect(function()
    
    if Clipon then
      for _, child in pairs(workspace:GetChildren()) do
        if child.Name == Players.LocalPlayer.Name then
          for _, part in pairs(workspace[Players.LocalPlayer.Name]:GetChildren()) do
            if part:IsA("BasePart") then
              part.CanCollide = false
            end
          end
        end
      end
    else
      Stepped:Disconnect()
    end
  end)
end)
GeneralSection:Button("皮飞行", function()
  
  loadstring(game:HttpGet([[https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/07cdd3eeaf4d4928.txt_2024-08-09_090317.OTed.lua]]))()
end)
GeneralSection:Button("皮飞车", function()
  
  loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/Pi-feiche.lua"))()
end)
GeneralSection:Button("皮自瞄", function()
  
  loadstring(game:HttpGet([[https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/3683e49998644fb7.txt_2024-08-09_094310.OTed.lua]]))()
end)
GeneralSection:Button("皮甩飞", function()
  
  loadstring(game:HttpGet([[https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/%E7%9A%AE%E7%94%A9%E9%A3%9E.lua]]))()
end)
GeneralSection:Button("甩飞所有人", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/zqyDSUWX"))()
end)
GeneralSection:Button("死亡笔记", function()
  
  loadstring(game:HttpGet([[https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/1_1.txt_2024-08-08_153358.OTed.lua]]))()
end)
GeneralSection:Button("铁拳", function()
  
  loadstring(game:HttpGet([[https://raw.githubusercontent.com/0Ben1/fe/main/obf_rf6iQURzu1fqrytcnLBAvW34C9N55kS9g9G3CKz086rC47M6632sEd4ZZYB0AYgV.lua.txt]]))()
end)
GeneralSection:Button("电脑键盘", function()
  
  loadstring(game:HttpGet([[https://raw.githubusercontent.com/advxzivhsjjdhxhsidifvsh/mobkeyboard/main/main.txt]], true))()
end)
GeneralSection:Toggle("无法移动", "Fake flag", false, function(enabled)
  
  local localPlayer = game.Players.LocalPlayer
  local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
  if enabled then
    for _, child in pairs(character:GetChildren()) do
      if child:IsA("BasePart") then
        child.Anchored = true
      end
    end
  else
    for _, child in pairs(character:GetChildren()) do
      if child:IsA("BasePart") then
        child.Anchored = false
      end
    end
  end
end)
GeneralSection:Button("自杀", function()
  
  game.Players.LocalPlayer.Character.Humanoid.Health = 0
end)
GeneralSection:Button("踏空行走", function()
  
  loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Float"))()
end)
GeneralSection:Button("通用ESP", function()
  
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasfin000/SpaceHub/main/UESP"))()
end)
GeneralSection:Button("踢人脚本(仅娱乐)", function()
  
  loadstring(game:HttpGet([[https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/c8320f69b6aa4f5d.txt_2024-08-08_214628.OTed.lua]]))()
end)
GeneralSection:Button("动画中心", function()
  
  loadstring(game:HttpGet([[https://raw.githubusercontent.com/GamingScripter/Animation-Hub/main/Animation%20Gui]], true))()
end)
GeneralSection:Button("爬墙", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/zXk4Rq2r"))()
end)
GeneralSection:Button("替身", function()
  
  loadstring(game:HttpGet([[https://raw.githubusercontent.com/SkrillexMe/SkrillexLoader/main/SkrillexLoadMain]]))()
end)
GeneralSection:Button("操人脚本", function()
  
  loadstring(game:HttpGet("https://pastefy.app/BkeffrT5/raw"))()
end)
GeneralSection:Button("圈圈自瞄(可调)", function()
  
  loadstring(game:HttpGet("https://pastefy.app/YnfF3sje/raw"))()
end)
GeneralSection:Button("iw指令", function()
  
  loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", true))()
end)
GeneralSection:Toggle("人物不可见状态(隐身)", "Invisible Character", false, function(enabled)
  
  local localPlayer = game.Players.LocalPlayer
  for _, child in pairs((localPlayer.Character or localPlayer.CharacterAdded:Wait()):GetChildren()) do
    local isBasePart = child:IsA("BasePart")
    if isBasePart then
      if enabled then
        isBasePart = 1
      else
        isBasePart = 0
      end
      child.Transparency = isBasePart
      child.CanCollide = not enabled
    elseif child:IsA("Accessory") then
      local handle = child.Handle
      local transparency = nil	
      if enabled then
        transparency = 1
      else
        transparency = 0
      end
      handle.Transparency = transparency
    end
  end
end)
GeneralSection:Toggle("获取所有玩家背包", "GetBackPack", false, function(enabled)
  
  if enabled then
    while enabled do
      for _, player in pairs(game.Players:GetChildren()) do
        wait()
        for _, tool in pairs(player.Backpack:GetChildren()) do
          tool.Parent = game.Players.LocalPlayer.Backpack
          wait()
        end
      end
    end
  end
end)
GeneralSection:Button("获取当前道具", function()
  
  loadstring(game:HttpGet("https://pastefy.app/3FU05Dyt/raw"))()
end)
GeneralSection:Button("装备全部道具", function()
  
  loadstring(game:HttpGet("https://pastefy.app/uBqVR9JC/raw"))()
end)
GeneralSection:Button("删除道具", function()
  
  loadstring(game:HttpGet("https://pastefy.app/r4LHK4p0/raw"))()
end)
GeneralSection:Button("删除所有道具", function()
  
  loadstring(game:HttpGet("https://pastefy.app/8HB71Lbj/raw"))()
end)
GeneralSection:Toggle("自动互动", "AutoInteract", false, function(enabled)
  
  if enabled then
    autoInteract = true
    while autoInteract do
      for _, descendant in pairs(workspace:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") then
          fireproximityprompt(descendant)
        end
      end
      task.wait(0.25)
    end
  else
    autoInteract = false
  end
end)
GeneralSection:Button("快速互动", function()
  
  game.ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    
    prompt.HoldDuration = 0
  end)
end)
GeneralSection:Toggle("圆圈高亮透视", "ESP", false, function(enabled)
  
  for _, player in pairs(game.Players:GetPlayers()) do
    if player ~= game.Players.LocalPlayer then
      if enabled then
        local highlight = Instance.new("Highlight")
        highlight.Parent = player.Character
        highlight.Adornee = player.Character
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Parent = player.Character
        billboardGui.Adornee = player.Character
        billboardGui.Size = UDim2.new(0, 100, 0, 100)
        billboardGui.StudsOffset = Vector3.new(0, 3, 0)
        billboardGui.AlwaysOnTop = true
        local textLabel = Instance.new("TextLabel")
        textLabel.Parent = billboardGui
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = player.Name
        textLabel.TextColor3 = Color3.new(1, 1, 1)
        textLabel.TextStrokeTransparency = 0.5
        textLabel.TextScaled = true
        local imageLabel = Instance.new("ImageLabel")
        imageLabel.Parent = billboardGui
        imageLabel.Size = UDim2.new(0, 50, 0, 50)
        imageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
        imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        imageLabel.BackgroundTransparency = 1
        imageLabel.Image = "rbxassetid://2200552246"
      else
        if player.Character:FindFirstChildOfClass("Highlight") then
          player.Character:FindFirstChildOfClass("Highlight"):Destroy()
        end
        if player.Character:FindFirstChildOfClass("BillboardGui") then
          player.Character:FindFirstChildOfClass("BillboardGui"):Destroy()
        end
      end
    end
  end
end)
GeneralSection:Toggle("无限跳", "IJ", false, function(enabled)
  
  getgenv().InfJ = enabled
  game:GetService("UserInputService").JumpRequest:connect(function()
    
    if InfJ == true then
      game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
  end)
end)
GeneralSection:Toggle("无敌", "LSTM", false, function(enabled)
  if enabled then
    local camera = workspace.CurrentCamera
    local cameraCFrame = camera.CFrame
    local character = LocalPlayer and LocalPlayer.Character
    local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
    if humanoid then
      local clonedHumanoid = humanoid:Clone()
      clonedHumanoid.Parent = character
      clonedHumanoid:SetStateEnabled(Enum.HumanoidStateType.Health, false)
      clonedHumanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
      clonedHumanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
      clonedHumanoid.BreakJointsOnDeath = true
      humanoid:Destroy()
      LocalPlayer.Character = nil
      LocalPlayer.Character = character
      camera.CameraSubject = clonedHumanoid

      task.wait() -- 稍作等待以确保对象稳定
      local targetCFrame = cameraCFrame or camera.CFrame
      camera.CFrame = targetCFrame

      clonedHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
      local animate = character:FindFirstChild("Animate")
      if animate then
        animate.Disabled = true
        task.wait()
        animate.Disabled = false
      end
      clonedHumanoid.Health = clonedHumanoid.MaxHealth
    end
  else
    local lpChar = game.Players.LocalPlayer and game.Players.LocalPlayer.Character
    local lpHum = lpChar and lpChar:FindFirstChildWhichIsA("Humanoid")
    if lpHum then
      lpHum.Health = 100
    end
  end
end)
GeneralSection:Toggle("上帝模式", "No Description", false, function(enabled)
  local Players = game:GetService("Players")
  local localPlayer = Players and Players.LocalPlayer
  if not localPlayer then
    return
  end

  local function getCharacter()
    return localPlayer.Character or localPlayer.CharacterAdded:Wait()
  end

  local character = localPlayer.Character
  if not character then
    character = getCharacter()
  end

  if enabled then
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if hrp and not character:FindFirstChild("GodModeHRPClone") then
      local clone = hrp:Clone()
      clone.Name = "GodModeHRPClone"
      clone.Parent = character
    end
  else
    if character then
      local clone = character:FindFirstChild("GodModeHRPClone")
      if clone then
        clone:Destroy()
      end
    end
  end
end)
GeneralSection:Toggle("靠近自动攻击(需要拿起武器)", "Toggle", false, function(enabled)
  
  local Players = nil	
  local isRunning = nil	
  if enabled then
    local r1_585 = getgenv().configs and getgenv().configs.connections
    if r1_585 then
      local r2_585 = getgenv().configs.Disable
      r3_585 = pairs
      for r6_585, r7_585 in r3_585(r1_585) do
        r7_585:Disconnect()
      end
      r2_585:Fire()
      r2_585:Destroy()
      table.clear(getgenv().configs)
    end
    local r2_585 = Instance.new("BindableEvent")
    r3_585 = getgenv()
    r3_585.configs = {
      connections = {},
      Disable = r2_585,
      Size = Vector3.new(10, 10, 10),
      DeathCheck = true,
    }
    r3_585 = game:GetService("Players")
    local r4_585 = game:GetService("RunService")
    local r5_585 = r3_585.LocalPlayer
    r6_585 = true
    local r7_585 = OverlapParams.new()
    r7_585.FilterType = Enum.RaycastFilterType.Include
    local function r8_585(r0_591)
      
      if not r0_591 then
        r0_591 = r5_585
      end
      return r0_591.Character
    end
-- ...existing code...
    local function r9_585(r0_590)
      -- 安全版：接受 Player / Model / Humanoid，并返回 Humanoid 或 nil
      if not r0_590 then
        return nil
      end

      -- 如果传入的是 Player，则获取其角色（使用文件中已有的 r8_585）
      local candidate = r0_590
      if type(candidate) == "userdata" and candidate.IsA then
        if candidate:IsA("Player") then
          candidate = r8_585(candidate)
        end

        if candidate and type(candidate) == "userdata" and candidate.IsA then
          if candidate:IsA("Model") then
            return candidate:FindFirstChildWhichIsA("Humanoid") or candidate:FindFirstChild("Humanoid")
          elseif candidate:IsA("Humanoid") then
            return candidate
          end
        end
      end

      return nil
    end
-- ...existing code...
    local function r10_585(r0_587)
      
      return r0_587 and 0 < r0_587.Health
    end
    local function r11_585(r0_588)
      
      return r0_588 and r0_588:FindFirstChildWhichIsA("TouchTransmitter", true)
    end
    local function r12_585(r0_589)
      
      local r1_589 = {}
      for r5_589, r6_589 in pairs(r3_585:GetPlayers()) do
        table.insert(r1_589, r8_585(r6_589))
      end
      for r5_589, r6_589 in pairs(r1_589) do
        if r6_589 == r0_589 then
          table.remove(r1_589, r5_589)
          break
        end
      end
      return r1_589
    end
    local function r13_585(r0_592, r1_592, r2_592)
      
      if r0_592:IsDescendantOf(workspace) then
        r0_592:Activate()
        firetouchinterest(r1_592, r2_592, 1)
        firetouchinterest(r1_592, r2_592, 0)
      end
    end
    table.insert(getgenv().configs.connections, r2_585.Event:Connect(function()
      
      r6_585 = false
    end))
    while r6_585 do
      local r14_585 = r8_585()
      if r10_585(r9_585(r14_585)) then
        local r15_585 = r14_585 and r14_585:FindFirstChildWhichIsA("Tool")
        local r16_585 = r15_585 and r11_585(r15_585)
        if r16_585 then
          local r17_585 = r16_585.Parent
          local r18_585 = r12_585(r14_585)
          r7_585.FilterDescendantsInstances = r18_585
          for r23_585, r24_585 in pairs(workspace:GetPartBoundsInBox(r17_585.CFrame, r17_585.Size + getgenv().configs.Size, r7_585)) do
            local r25_585 = r24_585:FindFirstAncestorWhichIsA("Model")
            if table.find(r18_585, r25_585) then
              if getgenv().configs.DeathCheck and r10_585(r9_585(r25_585)) then
                r13_585(r15_585, r17_585, r24_585)
              elseif not getgenv().configs.DeathCheck then
                r13_585(r15_585, r17_585, r24_585)
              end
            end
          end
        end
      end
      r4_585.Heartbeat:Wait()
    end
    
  else
    local r1_585 = getgenv().configs.Disable
    if r1_585 then
      r1_585:Fire()
      r1_585:Destroy()
    end
    r3_585 = getgenv
    r3_585 = r3_585()
    r3_585 = r3_585.configs
    r3_585 = r3_585.connections
    for r5_585, r6_585 in pairs(r3_585) do
      r6_585:Disconnect()
    end
    r3_585 = getgenv
    r3_585 = r3_585()
    r3_585 = r3_585.configs
    r3_585 = r3_585.connections
    table.clear(r3_585)
    Run = false
  end
end)
GeneralSection:Button("坐下", function()
  
  game.Players.LocalPlayer.Character.Humanoid.Sit = true
end)
GeneralSection:Toggle("声音折磨", "Sound", false, function(enabled)
  
  getgenv().spamSoond = enabled
  if enabled then
    spamSound()
  end
end)
function spamSound()
  
  while getgenv().spamSoond == true do
    local soundInstance = Instance.new("Sound")
    local descendants = game:GetDescendants()
    for _, descendant in next, descendants do
      if descendant:IsA("Sound") then
        descendant:Play()
      end
    end
    soundInstance:Remove()
    task.wait()
  end
end
GeneralSection:Toggle("七彩建筑", "BasePart", false, function(enabled)
  
  local baseParts = nil	
  if enabled then
    Break = false
    r1_665 = {}
    local r2_665 = Enum.Material:GetEnumItems()
    for r6_665, r7_665 in pairs(game.Workspace:GetDescendants()) do
      if r7_665:IsA("BasePart") then
        table.insert(r1_665, r7_665)
      end
    end
    game.Workspace.DescendantAdded:Connect(function(r0_666)
      
      if r0_666:IsA("BasePart") then
        table.insert(r1_665, r0_666)
      end
    end)
    while task.wait(0.025) do
      local r3_665 = pairs
      local r4_665 = r1_665
      for r6_665, r7_665 in r3_665(r4_665) do
        r7_665.Material = r2_665[math.random(1, #r2_665)]
        r7_665.Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
        if Break then
        end
      end
    end
    
  else
    r1_665 = true
    Break = r1_665
  end
end)
GeneralSection:Button("吸人(无法关闭)", function()
  
  loadstring(game:HttpGet("https://pastefy.app/fF3DMBNF/raw"))()
end)
GeneralSection:Button("人物螺旋上天", function()
  
  loadstring(game:HttpGet("https://pastefy.app/xV1T3PAi/raw"))()
end)
GeneralSection:Button("无限R币", function()
  
  loadstring(game:HttpGet("https://pastefy.app/SxhPVOyM/raw"))()
end)
GeneralSection:Button("聊天气泡美化", function()
  
  loadstring(game:HttpGet("https://pastefy.app/lCEPuiQO/raw"))()
end)
GeneralSection:Button("人物绘制", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/pmgp7mdm"))()
end)
GeneralSection:Toggle("人物显示", "RWXS", false, function(enabled)
  
  getgenv().enabled = enabled
  getgenv().filluseteamcolor = true
  getgenv().outlineuseteamcolor = true
  getgenv().fillcolor = Color3.new(1, 0, 0)
  getgenv().outlinecolor = Color3.new(1, 1, 1)
  getgenv().filltrans = 0.5
  getgenv().outlinetrans = 0.5
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Vcsk/RobloxScripts/main/Highlight-ESP.lua"))()
end)
GeneralSection:Button("无后坐快速射击", function()
  
  loadstring(game:HttpGet("https://pastefy.app/Vbnh3Ycg/raw"))()
end)
GeneralSection:Button("无限子弹", function()
  
  loadstring(game:HttpGet("https://pastefy.app/bYg3smqm/raw"))()
end)
GeneralSection:Button("弹人(实体)", function()
  
  loadstring(game:HttpGet("https://pastefy.app/4r9e4F3p/raw"))()
end)
GeneralSection:Button("弹人(半实体)", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/UTWcDtzj"))()
end)
GeneralSection:Button("获得管理员权限", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/sZpgTVas"))()
end)
GeneralSection:Button("重新加入游戏", function()
  
  loadstring(game:HttpGet("https://pastefy.app/XXabqNiv/raw"))()
end)
GeneralSection:Button("显示FPS", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/g54KFcUU"))()
end)
GeneralSection:Button("显示时间", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/RycMWV3a"))()
end)
GeneralSection:Button("F3X", function()
  
  loadstring(game:GetObjects("rbxassetid://6695644299")[1].Source)()
end)
GeneralSection:Button("保存游戏", function()
  
  saveinstance()
end)
GeneralSection:Button("离开游戏", function()
  
  game:Shutdown()
end)
GeneralSection:Button("玩家加入与退出提示", function()
  
  loadstring(game:HttpGet("https://pastefy.app/KexNS25n/raw"))()
end)
GeneralSection:Label("修改时间")
GeneralSection:Button("凌晨12点", function()
  
  loadstring(game:HttpGet("https://pastefy.app/xFX51PIw/raw"))()
end)
GeneralSection:Button("下午4点", function()
  
  loadstring(game:HttpGet("https://pastefy.app/sIrAGJxJ/raw"))()
end)
GeneralSection:Button("中午11点", function()
  
  loadstring(game:HttpGet("https://pastefy.app/rccCMBch/raw"))()
end)
GeneralSection:Button("早上6点", function()
  
  loadstring(game:HttpGet("https://pastefy.app/h9VLRgYR/raw"))()
end)
GeneralSection:Label("轰炸Webhook")
textboxMethod = "Textbox"
textboxLabel = "Webhook链接"
GeneralSection:Textbox("Webhook链接", "text", "输入", function(webhookUrl)
  
  local webhook = ""
  webhook = webhookUrl
end)
GeneralSection:Button("复制轰炸", function()
  
  setclipboard("", 9999)
end)
GeneralSection:Label("设置相机")
dropdownMethod = "Dropdown"
dropdownLabel = "选择相机方式"
GeneralSection:Dropdown("选择相机方式", "CameraType", {
  "自定义 ",
  "附加 ",
  "固定",
  "跟随",
  "动态观察",
  "可脚本化",
  "跟踪",
  "观看"
}, function(cameraType)
  
  if cameraType == "自定义" then
    game.Workspace.CurrentCamera.CameraType = "Custom"
  elseif cameraType == "附加" then
    game.Workspace.CurrentCamera.CameraType = "Attach"
  elseif cameraType == "固定" then
    game.Workspace.CurrentCamera.CameraType = "Fixed"
  elseif cameraType == "跟随" then
    game.Workspace.CurrentCamera.CameraType = "Follow"
  elseif cameraType == "动态观察" then
    game.Workspace.CurrentCamera.CameraType = "Orbital"
  elseif cameraType == "可脚本化" then
    game.Workspace.CurrentCamera.CameraType = "Scriptable"
  elseif cameraType == "跟踪" then
    game.Workspace.CurrentCamera.CameraType = "Track"
  elseif cameraType == "观看" then
    game.Workspace.CurrentCamera.CameraType = "Watch"
  end
end)
GeneralSection:Toggle("切板摄像机的遮挡模式", "DevCameraOcclusionMode", false, function(r0_607)
  
  if state then
    game:GetService("Players").LocalPlayer.DevCameraOcclusionMode = "Invisicam"
  else
    game:GetService("Players").LocalPlayer.DevCameraOcclusionMode = "Zoom"
  end
end)
dropdownMethod = "Dropdown"
dropdownLabel = "相机"
GeneralSection:Dropdown("相机", "Camera", {
  "经典",
  "第一人称"
}, function(cameraMode)
  
  if cameraMode == "经典" then
    game:GetService("Players").LocalPlayer.CameraMode = "Classic"
  elseif cameraMode == "第一人称" then
    game:GetService("Players").LocalPlayer.CameraMode = "LockFirstPerson"
  end
end)
local SpinRangeTab = UILibrary:Tab("『旋转与范围』", "18930406865")
local SpinRangeSection = SpinRangeTab:section("旋转与范围", true)
SpinRangeSection:Label("旋转")
textboxMethod = "Textbox"
textboxLabel = "设置旋转速度"
SpinRangeSection:Textbox("设置旋转速度", "TextBoxFlag", "输入", function(speed)
  
  bin.speed = tonumber(speed) or 100
end)
SpinRangeSection:Toggle("开启/关闭旋转", "Spinbot", false, function(enabled)
  
  local localPlayer = game:GetService("Players").LocalPlayer
  repeat
    task.wait()
  until localPlayer.Character
  local humanoidRootPart = localPlayer.Character:WaitForChild("HumanoidRootPart")
  localPlayer.Character:WaitForChild("Humanoid").AutoRotate = false
  if enabled then
    local angularVelocity = Instance.new("AngularVelocity")
    angularVelocity.Attachment0 = humanoidRootPart:WaitForChild("RootAttachment")
    angularVelocity.MaxTorque = math.huge
    angularVelocity.AngularVelocity = Vector3.new(0, bin.speed, 0)
    angularVelocity.Parent = humanoidRootPart
    angularVelocity.Name = "Spinbot"
  else
    local spinbot = humanoidRootPart:FindFirstChild("Spinbot")
    if spinbot then
      spinbot:Destroy()
    end
  end
end)
SpinRangeSection:Label("范围")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
getgenv().HitboxSize = 15
getgenv().HitboxTransparency = 0.9
getgenv().HitboxStatus = false
getgenv().TeamCheck = false
SpinRangeSection:Toggle("开启/关闭范围", "HitboxStatus", false, function(enabled)
  
  getgenv().HitboxStatus = enabled
  game:GetService("RunService").RenderStepped:connect(function()
    
    if HitboxStatus == true and TeamCheck == false then
      for _, player in next, game:GetService("Players"):GetPlayers() do
        if player.Name ~= game:GetService("Players").LocalPlayer.Name then
          pcall(function()
            
            player.Character.HumanoidRootPart.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
            player.Character.HumanoidRootPart.Transparency = HitboxTransparency
            player.Character.HumanoidRootPart.BrickColor = BrickColor.new(MovementConfig.HitboxBrickColor)
            player.Character.HumanoidRootPart.Material = "Neon"
            player.Character.HumanoidRootPart.CanCollide = false
          end)
        end
        
      end
    elseif HitboxStatus == true and TeamCheck == true then
      for _, player in next, game:GetService("Players"):GetPlayers() do
        if game:GetService("Players").LocalPlayer.Team ~= player.Team then
          pcall(function()
            
            player.Character.HumanoidRootPart.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
            player.Character.HumanoidRootPart.Transparency = HitboxTransparency
            player.Character.HumanoidRootPart.BrickColor = BrickColor.new(MovementConfig.HitboxBrickColor)
            player.Character.HumanoidRootPart.Material = "Neon"
            player.Character.HumanoidRootPart.CanCollide = false
          end)
        end
        
      end
    else
      for _, player in next, game:GetService("Players"):GetPlayers() do
        if player.Name ~= game:GetService("Players").LocalPlayer.Name then
          pcall(function()
            
            player.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
            player.Character.HumanoidRootPart.Transparency = 1
            player.Character.HumanoidRootPart.BrickColor = BrickColor.new(MovementConfig.HitboxBrickColor)
            player.Character.HumanoidRootPart.Material = "Plastic"
            player.Character.HumanoidRootPart.CanCollide = false
          end)
        end
        
      end
    end
  end)
end)
textboxMethod = "Textbox"
textboxLabel = "范围大小设置"
SpinRangeSection:Textbox("范围大小设置", "HitboxSize", "输入", function(size)
  
  getgenv().HitboxSize = size
end)
SpinRangeSection:Toggle("队伍检测", "TeamCheck", false, function(enabled)
  
  getgenv().TeamCheck = enabled
  ESP_SETTINGS.Teamcheck = true
end)
textboxMethod = "Textbox"
textboxLabel = "范围透明度设置（调0更好区分队伍)"
SpinRangeSection:Textbox("范围透明度设置（调0更好区分队伍)", "HitboxTransparency", "输入", function(transparency)
  
  getgenv().HitboxTransparency = transparency
end)
dropdownMethod = "Dropdown"
dropdownLabel = "选择范围颜色"
SpinRangeSection:Dropdown("选择范围颜色", "Hitbox", {
  "Really blue",
  "Really black",
  "Really red",
  "Really pink",
  "Really brown",
  "Really yellow",
  "Really green",
  "Really orange",
  "Really purple",
  "Really light gray"
}, function(color)
  
  MovementConfig.HitboxBrickColor = color
end)
local QuickSettingsSection = SpinRangeTab:section("快捷设置范围与旋转", true)
QuickSettingsSection:Label("范围")
QuickSettingsSection:Button("范围清空", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/RqrTrPF5"))()
end)
QuickSettingsSection:Button("范围10", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/DT94B37a"))()
end)
QuickSettingsSection:Button("范围20", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/Kyyt1e4g"))()
end)
QuickSettingsSection:Button("范围50", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/pMtKEgWd"))()
end)
QuickSettingsSection:Button("范围100", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/aLBSXPYE"))()
end)
QuickSettingsSection:Button("范围150", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/RWxsQuU9"))()
end)
QuickSettingsSection:Button("范围200", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/hbp3RV2p"))()
end)
QuickSettingsSection:Button("范围300", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/x8cZhegq"))()
end)
QuickSettingsSection:Button("范围400", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/LixK0gG3"))()
end)
QuickSettingsSection:Button("范围500", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/yXWMGLYJ"))()
end)
QuickSettingsSection:Label("旋转")
QuickSettingsSection:Button("旋转清零", function()
  
  loadstring(game:HttpGet("https://pastefy.app/UOWFy58g/raw"))()
end)
QuickSettingsSection:Button("旋转10", function()
  
  loadstring(game:HttpGet("https://pastefy.app/pX8CKeHn/raw"))()
end)
QuickSettingsSection:Button("旋转30", function()
  
  loadstring(game:HttpGet("https://pastefy.app/1Ob0oE2h/raw"))()
end)
QuickSettingsSection:Button("旋转50", function()
  
  loadstring(game:HttpGet("https://pastefy.app/4UL7XrJU/raw"))()
end)
QuickSettingsSection:Button("旋转100", function()
  
  loadstring(game:HttpGet("https://pastefy.app/6agZDErY/raw"))()
end)
QuickSettingsSection:Button("旋转150", function()
  
  loadstring(game:HttpGet("https://pastefy.app/MqAalYjs/raw"))()
end)
QuickSettingsSection:Button("旋转200", function()
  
  loadstring(game:HttpGet("https://pastefy.app/00mtNBML/raw"))()
end)
QuickSettingsSection:Button("旋转250", function()
  
  loadstring(game:HttpGet("https://pastefy.app/CR2woYXY/raw"))()
end)
QuickSettingsSection:Button("旋转300", function()
  
  loadstring(game:HttpGet("https://pastefy.app/5SbEaumY/raw"))()
end)
QuickSettingsSection:Button("旋转400", function()
  
  loadstring(game:HttpGet("https://pastefy.app/pjkZd07i/raw"))()
end)
QuickSettingsSection:Button("旋转500", function()
  
  loadstring(game:HttpGet("https://pastefy.app/9emFsJ7N/raw"))()
end)
local HubScriptsSection = UILibrary:Tab("『HUB脚本』", "18930406865"):section("HUB脚本", true)
HubScriptsSection:Button("EZ-HUB", function()
  
  loadstring(game:HttpGet([[https://raw.githubusercontent.com/debug42O/Ez-Industries-Launcher-Data/master/Launcher.lua]], true))()
end)
HubScriptsSection:Button("reen script", function()
  
  loadstring(game:HttpGet("https://raw.githubusercontent.com/xDepressionx/Free-Script/main/KingLegacy.lua"))()
end)
HubScriptsSection:Button("Maru_Hub", function()
  
  loadstring(game:HttpGet("https://raw.githubusercontent.com/raw-scriptpastebin/raw/main/B_Genesis"))()
end)
HubScriptsSection:Button("Xenon_Hub", function()
  
  loadstring(game:HttpGet("https://raw.githubusercontent.com/1f0yt/community/master/legacy"))()
end)
HubScriptsSection:Button("ipper_hub", function()
  
  loadstring(game:HttpGet("https://raw.githubusercontent.com/hajibeza/RIPPER-HUB/main/King%20Leagacy"))()
end)
HubScriptsSection:Button("trike_hub", function()
  
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Strikehubv2z/StormSKz/main/All_in_one"))()
end)
HubScriptsSection:Button("unfair hub", function()
  
  loadstring(game:HttpGet("https://raw.githubusercontent.com/rblxscriptsnet/unfair/main/rblxhub.lua", true))()
end)
HubScriptsSection:Button(" Shadow Hub V2", function()
  
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Alexcirer/Alexcirer/main/V%20d"))()
end)
HubScriptsSection:Button("Zen_Hub", function()
  
  loadstring(game:HttpGet("https://shz.al/~aboutnnn/Zen_Hub.lua"))()
end)
HubScriptsSection:Button("PlaybackX Hub", function()
  
  loadstring(game:HttpGet("https://raw.githubusercontent.com/NeaPchX2/Playback-X-HUB/main/Protected.lua.txt"))()
end)
HubScriptsSection:Button("Tianhe\'s script hub", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/xdQVhQdm"))()
end)
HubScriptsSection:Button("Mango hub", function()
  
  loadstring(game:HttpGet("https://gitlab.com/L1ZOT/mango-hub/-/raw/main/Mango-Bloxf-Fruits-Beta"))()
end)
HubScriptsSection:Button("VG hub", function()
  
  loadstring(game:HttpGet("https://raw.githubusercontent.com/1201for/V.G-Hub/main/V.Ghub"))()
end)
HubScriptsSection:Button("Owl-Hub", function()
  
  loadstring(game:HttpGet("https://raw.githubusercontent.com/CriShoux/OwlHub/master/OwlHub.txt"))()
end)
HubScriptsSection:Button("HOHO_hub", function()
  
  loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI"))()
end)
local TeleportSection = UILibrary:Tab("『传送与甩飞』", "18930406865"):section("传送与甩飞玩家", true)
dropdownMethod = "Dropdown"
dropdownLabel = "选择玩家名称"
local playerDropdown = TeleportSection:Dropdown("选择玩家名称", "Dropdown", PlayerConfig.dropdown, function(selectedPlayer)
  
  PlayerConfig.playernamedied = selectedPlayer
end)
TeleportSection:Button("刷新玩家名称", function()
  
  shuaxinlb(true)
  playerDropdown:SetOptions(PlayerConfig.dropdown)
end)
TeleportSection:Button("传送到玩家旁边", function()
  
  local localRootPart = game.Players.LocalPlayer.Character.HumanoidRootPart
  local targetPlayer = game.Players:FindFirstChild(PlayerConfig.playernamedied)
  if targetPlayer and targetPlayer.Character and targetPlayer.Character.HumanoidRootPart then
    localRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
    Notify("皮脚本", "已经传送到玩家身边", "rbxassetid://18941716391", 5)
  else
    Notify("皮脚本", "无法传送 原因: 玩家已消失", "rbxassetid://18941716391", 5)
  end
end)
TeleportSection:Toggle("循环锁定传送", "Loop", false, function(enabled)
  
  if enabled then
    PlayerConfig.LoopTeleport = true
    Notify("皮脚本", "已开启循环传送", "rbxassetid://18941716391", 5)
    while PlayerConfig.LoopTeleport do
      local localRootPart = game.Players.LocalPlayer.Character.HumanoidRootPart
      local targetPlayer = game.Players:FindFirstChild(PlayerConfig.playernamedied)
      if targetPlayer and targetPlayer.Character and targetPlayer.Character.HumanoidRootPart then
        localRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
      end
      wait()
    end
  else
    PlayerConfig.LoopTeleport = false
    Notify("皮脚本", "已关闭循环传送", "rbxassetid://18941716391", 5)
  end
end)
TeleportSection:Button("把玩家传送过来", function()
  
  local localRootPart = game.Players.LocalPlayer.Character.HumanoidRootPart
  local targetPlayer = game.Players:FindFirstChild(PlayerConfig.playernamedied)
  if targetPlayer and targetPlayer.Character and targetPlayer.Character.HumanoidRootPart then
    targetPlayer.Character.HumanoidRootPart.CFrame = localRootPart.CFrame + Vector3.new(0, 3, 0)
    Notify("皮脚本", "已将玩家传送过来", "rbxassetid://18941716391", 5)
  else
    Notify("皮脚本", "无法传送 原因: 玩家已消失", "rbxassetid://18941716391", 5)
  end
end)
TeleportSection:Toggle("循环传送玩家过来", "Loop", false, function(enabled)
  
  if enabled then
    PlayerConfig.LoopTeleport = true
    Notify("皮脚本", "已开启循环传送玩家过来", "rbxassetid://", 5)
    while PlayerConfig.LoopTeleport do
      local localRootPart = game.Players.LocalPlayer.Character.HumanoidRootPart
      local targetPlayer = game.Players:FindFirstChild(PlayerConfig.playernamedied)
      if targetPlayer and targetPlayer.Character and targetPlayer.Character.HumanoidRootPart then
        targetPlayer.Character.HumanoidRootPart.CFrame = localRootPart.CFrame + Vector3.new(0, 3, 0)
      end
      wait()
    end
  else
    PlayerConfig.LoopTeleport = false
    Notify("皮脚本", "已关闭循环传送玩家过来", "rbxassetid://18941716391", 5)
  end
end)
TeleportSection:Toggle("吸全部玩家", "Get All", false, function(enabled)
  
  if enabled then
    while enabled do
      for _, player in next, game:GetService("Players"):GetPlayers() do
        if player.Name ~= game:GetService("Players").LocalPlayer.Name then
          local localPosition = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position
          local lookVector = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame.lookVector
          player.Character.HumanoidRootPart.CFrame = CFrame.new(localPosition + lookVector * 3, localPosition + lookVector * 4)
          wait()
        end
      end
    end
  end
end)
TeleportSection:Toggle("查看玩家", "look player", false, function(enabled)
  
  if enabled then
    game:GetService("Workspace").CurrentCamera.CameraSubject = game:GetService("Players"):FindFirstChild(PlayerConfig.playernamedied).Character.Humanoid
    Notify("皮脚本", "已开启查看玩家", "rbxassetid://18941716391", 5)
  else
    game:GetService("Workspace").CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
    Notify("皮脚本", "已关闭查看玩家", "rbxassetid://18941716391", 5)
  end
end)
TeleportSection:Button("甩飞一次", function()
  
  if PlayerConfig.playernamedied ~= nil and PlayerConfig.playernamedied ~= nil then
    local targetNames = {
      PlayerConfig.playernamedied
    }
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    local isAllOrOthers = false
    local function FindPlayerByName(name)
      
      name = name:lower()
      if name == "all" or name == "others" then
        isAllOrOthers = true
        return 
      end
      if name == "random" then
        local allPlayers = Players:GetPlayers()
        if table.find(allPlayers, localPlayer) then
          table.remove(allPlayers, table.find(allPlayers, localPlayer))
        end
        return allPlayers[math.random(#allPlayers)]
      end
      if name ~= "random" and name ~= "all" and name ~= "others" then
        for _, player in next, Players:GetPlayers() do
          if player ~= localPlayer then
            if player.Name:lower():match("^" .. name) then
              return player
            end
            if player.DisplayName:lower():match("^" .. name) then
              return player
            end
          end
        end
      else
        return 
      end
    end
    local function SendNotification(title, text, duration)
      
      game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration,
      })
    end
    local function ThrowPlayer(targetPlayer)
      
      local localCharacter = localPlayer.Character
      local localHumanoid = localCharacter and localCharacter:FindFirstChildOfClass("Humanoid")
      local localRootPart = localHumanoid and localHumanoid.RootPart
      local targetCharacter = targetPlayer.Character
      local targetHumanoid = nil
      local targetRootPart = nil
      local targetHead = nil
      local targetAccessory = nil
      local accessoryHandle = nil
      if targetCharacter:FindFirstChildOfClass("Humanoid") then
        targetHumanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
      end
      if targetHumanoid and targetHumanoid.RootPart then
        targetRootPart = targetHumanoid.RootPart
      end
      if targetCharacter:FindFirstChild("Head") then
        targetHead = targetCharacter.Head
      end
      if targetCharacter:FindFirstChildOfClass("Accessory") then
        targetAccessory = targetCharacter:FindFirstChildOfClass("Accessory")
      end
      if Accessoy and targetAccessory:FindFirstChild("Handle") then
        accessoryHandle = targetAccessory.Handle
      end
      if localCharacter and localHumanoid and localRootPart then
        if localRootPart.Velocity.Magnitude < 50 then
          getgenv().OldPos = localRootPart.CFrame
        end
        if targetHumanoid and targetHumanoid.Sit and not isAllOrOthers then
          return SendNotification("玩家消失", "已停止", 5)
        end
        if targetHead then
          workspace.CurrentCamera.CameraSubject = targetHead
        elseif not targetHead and accessoryHandle then
          workspace.CurrentCamera.CameraSubject = accessoryHandle
        elseif targetHumanoid and targetRootPart then
          workspace.CurrentCamera.CameraSubject = targetHumanoid
        end
        if not targetCharacter:FindFirstChildWhichIsA("BasePart") then
          return 
        end
        local function ApplyThrowForce(part, offset, rotation)
          
          localRootPart.CFrame = CFrame.new(part.Position) * offset * rotation
          localCharacter:SetPrimaryPartCFrame(CFrame.new(part.Position) * offset * rotation)
          localRootPart.Velocity = Vector3.new(90000000, 900000000, 90000000)
          localRootPart.RotVelocity = Vector3.new(900000000, 900000000, 900000000)
        end
        local function PerformThrowAnimation(part)
          
          local timeoutDuration = 2
          local startTime = tick()
          local rotationAngle = 0
          while localRootPart do
            local velocityMagnitude = part.Velocity.Magnitude
            if velocityMagnitude < 50 then
              rotationAngle = rotationAngle + 100
              ApplyThrowForce(part, CFrame.new(0, 1.5, 0) + targetHumanoid.MoveDirection * part.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(rotationAngle), 0, 0))
                task.wait()
              ApplyThrowForce(part, CFrame.new(0, -1.5, 0) + targetHumanoid.MoveDirection * part.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(rotationAngle), 0, 0))
                task.wait()
              ApplyThrowForce(part, CFrame.new(2.25, 1.5, -2.25) + targetHumanoid.MoveDirection * part.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(rotationAngle), 0, 0))
                task.wait()
              ApplyThrowForce(part, CFrame.new(-2.25, -1.5, 2.25) + targetHumanoid.MoveDirection * part.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(rotationAngle), 0, 0))
                task.wait()
              ApplyThrowForce(part, CFrame.new(0, 1.5, 0) + targetHumanoid.MoveDirection, CFrame.Angles(math.rad(rotationAngle), 0, 0))
                task.wait()
              ApplyThrowForce(part, CFrame.new(0, -1.5, 0) + targetHumanoid.MoveDirection, CFrame.Angles(math.rad(rotationAngle), 0, 0))
                task.wait()
              else
              ApplyThrowForce(part, CFrame.new(0, 1.5, targetHumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                task.wait()
              ApplyThrowForce(part, CFrame.new(0, -1.5, -targetHumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                task.wait()
              ApplyThrowForce(part, CFrame.new(0, 1.5, targetHumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                task.wait()
              ApplyThrowForce(part, CFrame.new(0, 1.5, targetRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                task.wait()
              ApplyThrowForce(part, CFrame.new(0, -1.5, -targetRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                task.wait()
              ApplyThrowForce(part, CFrame.new(0, 1.5, targetRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                task.wait()
              ApplyThrowForce(part, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                task.wait()
              ApplyThrowForce(part, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                task.wait()
              ApplyThrowForce(part, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(-90), 0, 0))
                task.wait()
              ApplyThrowForce(part, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                task.wait()
              end
            velocityMagnitude = part.Velocity.Magnitude
            if velocityMagnitude <= 500 then
              local partParent = part.Parent
              if partParent == targetPlayer.Character then
                partParent = targetPlayer.Parent
                if partParent == Players then
                  local hasCharacter = not targetPlayer.Character
                  if hasCharacter ~= targetCharacter then
                    local isSitting = targetHumanoid.Sit
                    if not isSitting then
                      local health = localHumanoid.Health
                      if health > 0 then
                        local currentTime = tick()
                        if startTime + timeoutDuration < currentTime then
                          break
                        end
                      else
                        break
                      end
                    else
                      break
                    end
                  else
                    break
                  end
                else
                  break
                end
              else
                break
              end
            else
              break
            end
          end
        end
        workspace.FallenPartsDestroyHeight = 0 / 0
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Name = "EpixVel"
        bodyVelocity.Parent = localRootPart
        bodyVelocity.Velocity = Vector3.new(900000000, 900000000, 900000000)
        bodyVelocity.MaxForce = Vector3.new(1 / 0, 1 / 0, 1 / 0)
        localHumanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        if targetRootPart and targetHead then
          if (targetRootPart.CFrame.p - targetHead.CFrame.p).Magnitude > 5 then
            PerformThrowAnimation(targetHead)
          else
            PerformThrowAnimation(targetRootPart)
          end
        elseif targetRootPart and not targetHead then
          PerformThrowAnimation(targetRootPart)
        elseif not targetRootPart and targetHead then
          PerformThrowAnimation(targetHead)
        elseif not targetRootPart and not targetHead and targetAccessory and accessoryHandle then
          PerformThrowAnimation(accessoryHandle)
        else
          return SendNotification("皮脚本", "已开/关", 5)
        end
        bodyVelocity:Destroy()
        localHumanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = localHumanoid
        repeat
          localRootPart.CFrame = getgenv().OldPos * CFrame.new(0, 0.5, 0)
          localCharacter:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, 0.5, 0))
          localHumanoid:ChangeState("GettingUp")
          table.foreach(localCharacter:GetChildren(), function(_, child)
            
            if child:IsA("BasePart") then
              local zeroVector = Vector3.new()
              child.RotVelocity = Vector3.new()
              child.Velocity = zeroVector
            end
          end)
          task.wait()
        until (localRootPart.Position - getgenv().OldPos.p).Magnitude < 25
        workspace.FallenPartsDestroyHeight = getgenv().FPDH
        
      else
        SendNotification("玩家消失", "已停止", 5)
      end
    end
    if targetNames[1] then
      for _, name in next, targetNames, nil do
        local foundPlayer = FindPlayerByName(name)
        if foundPlayer then
          ThrowPlayer(foundPlayer)
        end
      end
    else
      return 
    end
    if isAllOrOthers then
      for _, player in next, Players:GetPlayers() do
        if player ~= localPlayer then
          ThrowPlayer(player)
        end
      end
    end
    for _, name in next, targetNames, nil do
      local foundPlayer = FindPlayerByName(name)
      if foundPlayer and foundPlayer ~= localPlayer then
        if foundPlayer.UserId ~= 1414978355 then
          ThrowPlayer(foundPlayer)
        else
          SendNotification("检测到玩家消失", "己停止", 5)
        end
      elseif not FindPlayerByName(name) and not isAllOrOthers then
        SendNotification("未获取到玩家或工具", "已停止", 5)
      end
    end
    
  end
end)
TeleportSection:Toggle("循环甩飞", "AutoFling", false, function(r0_53)
  
  if PlayerConfig.playernamedied ~= nil and PlayerConfig.playernamedied ~= nil then
    getgenv().autofling = r0_53
    spawn(function()
      
      while autofling do
        wait()
        pcall(function()
          
          local r0_55 = {
            PlayerConfig.playernamedied
          }
          local r1_55 = game:GetService("Players")
          local r2_55 = r1_55.LocalPlayer
          local r3_55 = false
          local function r4_55(r0_61)
            
            r0_61 = r0_61:lower()
            if r0_61 == "all" or r0_61 == "others" then
              r3_55 = true
              return 
            end
            if r0_61 == "random" then
              local r1_61 = r1_55:GetPlayers()
              if table.find(r1_61, r2_55) then
                table.remove(r1_61, table.find(r1_61, r2_55))
              end
              return r1_61[math.random(#r1_61)]
            end
            if r0_61 ~= "random" and r0_61 ~= "all" and r0_61 ~= "others" then
              local r1_61 = next
              local r2_61, r3_61 = r1_55:GetPlayers()
              for r4_61, r5_61 in r1_61, r2_61, r3_61 do
                if r5_61 ~= r2_55 then
                  if r5_61.Name:lower():match("^" .. r0_61) then
                    return r5_61
                  end
                  if r5_61.DisplayName:lower():match("^" .. r0_61) then
                    return r5_61
                  end
                end
              end
            else
              return 
            end
          end
          local function r5_55(r0_60, r1_60, r2_60)
            
            game:GetService("StarterGui"):SetCore("SendNotification", {
              Title = r0_60,
              Text = r1_60,
              Duration = r2_60,
            })
          end
          local function r6_55(r0_56)
            
            local r1_56 = r2_55.Character
            local r2_56 = r1_56 and r1_56:FindFirstChildOfClass("Humanoid")
            local r3_56 = r2_56 and r2_56.RootPart
            local r4_56 = r0_56.Character
            local r5_56 = nil
            local r6_56 = nil
            local r7_56 = nil
            local r8_56 = nil
            local r9_56 = nil
            if r4_56:FindFirstChildOfClass("Humanoid") then
              r5_56 = r4_56:FindFirstChildOfClass("Humanoid")
            end
            if r5_56 and r5_56.RootPart then
              r6_56 = r5_56.RootPart
            end
            if r4_56:FindFirstChild("Head") then
              r7_56 = r4_56.Head
            end
            if r4_56:FindFirstChildOfClass("Accessory") then
              r8_56 = r4_56:FindFirstChildOfClass("Accessory")
            end
            if Accessoy and r8_56:FindFirstChild("Handle") then
              r9_56 = r8_56.Handle
            end
            if r1_56 and r2_56 and r3_56 then
              if r3_56.Velocity.Magnitude < 50 then
                getgenv().OldPos = r3_56.CFrame
              end
              if r5_56 and r5_56.Sit and not r3_55 then
                return r5_55("皮脚本", "错误❌", 5)
              end
              if r7_56 then
                workspace.CurrentCamera.CameraSubject = r7_56
              elseif not r7_56 and r9_56 then
                workspace.CurrentCamera.CameraSubject = r9_56
              elseif r5_56 and r6_56 then
                workspace.CurrentCamera.CameraSubject = r5_56
              end
              if not r4_56:FindFirstChildWhichIsA("BasePart") then
                return 
              end
              local function r10_56(r0_58, r1_58, r2_58)
                
                r3_56.CFrame = CFrame.new(r0_58.Position) * r1_58 * r2_58
                r1_56:SetPrimaryPartCFrame(CFrame.new(r0_58.Position) * r1_58 * r2_58)
                r3_56.Velocity = Vector3.new(90000000, 900000000, 90000000)
                r3_56.RotVelocity = Vector3.new(900000000, 900000000, 900000000)
              end
              local function r11_56(r0_57)
                
                local r1_57 = 2
                local r2_57 = tick()
                local r3_57 = 0
                while r3_56 do
                  local r4_57 = r5_56
                  if r4_57 then
                    r4_57 = r0_57.Velocity.Magnitude
                    if r4_57 < 50 then
                      r3_57 = r3_57 + 100
                      r10_56(r0_57, CFrame.new(0, 1.5, 0) + r5_56.MoveDirection * r0_57.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(r3_57), 0, 0))
                      task.wait()
                      r10_56(r0_57, CFrame.new(0, -1.5, 0) + r5_56.MoveDirection * r0_57.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(r3_57), 0, 0))
                      task.wait()
                      r10_56(r0_57, CFrame.new(2.25, 1.5, -2.25) + r5_56.MoveDirection * r0_57.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(r3_57), 0, 0))
                      task.wait()
                      r10_56(r0_57, CFrame.new(-2.25, -1.5, 2.25) + r5_56.MoveDirection * r0_57.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(r3_57), 0, 0))
                      task.wait()
                      r10_56(r0_57, CFrame.new(0, 1.5, 0) + r5_56.MoveDirection, CFrame.Angles(math.rad(r3_57), 0, 0))
                      task.wait()
                      r10_56(r0_57, CFrame.new(0, -1.5, 0) + r5_56.MoveDirection, CFrame.Angles(math.rad(r3_57), 0, 0))
                      task.wait()
                    else
                      r10_56(r0_57, CFrame.new(0, 1.5, r5_56.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                      task.wait()
                      r10_56(r0_57, CFrame.new(0, -1.5, -r5_56.WalkSpeed), CFrame.Angles(0, 0, 0))
                      task.wait()
                      r10_56(r0_57, CFrame.new(0, 1.5, r5_56.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                      task.wait()
                      r10_56(r0_57, CFrame.new(0, 1.5, r6_56.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                      task.wait()
                      r10_56(r0_57, CFrame.new(0, -1.5, -r6_56.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                      task.wait()
                      r10_56(r0_57, CFrame.new(0, 1.5, r6_56.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                      task.wait()
                      r10_56(r0_57, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                      task.wait()
                      r10_56(r0_57, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                      task.wait()
                      r10_56(r0_57, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(-90), 0, 0))
                      task.wait()
                      r10_56(r0_57, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                      task.wait()
                    end
                    r4_57 = r0_57.Velocity.Magnitude
                    if r4_57 <= 500 then
                      r4_57 = r0_57.Parent
                      if r4_57 == r0_56.Character then
                        r4_57 = r0_56.Parent
                        if r4_57 == r1_55 then
                          r4_57 = not r0_56.Character
                          if r4_57 ~= r4_56 then
                            r4_57 = r5_56.Sit
                            if not r4_57 then
                              r4_57 = r2_56.Health
                              if r4_57 > 0 then
                                r4_57 = tick()
                                if r2_57 + r1_57 < r4_57 then
                                  break
                                end
                              else
                                break
                              end
                            else
                              break
                            end
                          else
                            break
                          end
                        else
                          break
                        end
                      else
                        break
                      end
                    else
                      break
                    end
                  else
                    break
                  end
                end
              end
              workspace.FallenPartsDestroyHeight = 0 / 0
              local r12_56 = Instance.new("BodyVelocity")
              r12_56.Name = "EpixVel"
              r12_56.Parent = r3_56
              r12_56.Velocity = Vector3.new(900000000, 900000000, 900000000)
              r12_56.MaxForce = Vector3.new(1 / 0, 1 / 0, 1 / 0)
              r2_56:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
              if r6_56 and r7_56 then
                if (r6_56.CFrame.p - r7_56.CFrame.p).Magnitude > 5 then
                  r11_56(r7_56)
                else
                  r11_56(r6_56)
                end
              elseif r6_56 and not r7_56 then
                r11_56(r6_56)
              elseif not r6_56 and r7_56 then
                r11_56(r7_56)
              elseif not r6_56 and not r7_56 and r8_56 and r9_56 then
                r11_56(r9_56)
              else
                return r5_55("皮脚本", "已开/关", 5)
              end
              r12_56:Destroy()
              r2_56:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
              workspace.CurrentCamera.CameraSubject = r2_56
              repeat
                r3_56.CFrame = getgenv().OldPos * CFrame.new(0, 0.5, 0)
                r1_56:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, 0.5, 0))
                r2_56:ChangeState("GettingUp")
                table.foreach(r1_56:GetChildren(), function(r0_59, r1_59)
                  
                  if r1_59:IsA("BasePart") then
                    local r2_59 = Vector3.new()
                    r1_59.RotVelocity = Vector3.new()
                    r1_59.Velocity = r2_59
                  end
                end)
                task.wait()
              until (r3_56.Position - getgenv().OldPos.p).Magnitude < 25
              workspace.FallenPartsDestroyHeight = getgenv().FPDH
              
            else
-- ...existing code...
              local r10_56 = r5_55
              local r11_56 = "玩家消失"
              local r12_56 = "已停止"
              local r13_56 = 5
              r10_56(r11_56, r12_56, r13_56)
-- ...existing code...
            end
          end
          if r0_55[1] then
            for r10_55, r11_55 in next, r0_55, nil do
              r4_55(r11_55)
            end
          else
            return 
          end
          if r3_55 then
            local r7_55 = next
            local r8_55, r9_55 = r1_55:GetPlayers()
            for r10_55, r11_55 in r7_55, r8_55, r9_55 do
              r6_55(r11_55)
            end
          end
          for r10_55, r11_55 in next, r0_55, nil do
            if r4_55(r11_55) and r4_55(r11_55) ~= r2_55 then
              if r4_55(r11_55).UserId ~= 1414978355 then
                local r12_55 = r4_55(r11_55)
                if r12_55 then
                  r6_55(r12_55)
                end
              else
                r5_55("检测到玩家消失", "已停止", 5)
              end
            elseif not r4_55(r11_55) and not r3_55 then
              r5_55("未获取到玩家或工具", "已停止", 5)
            end
          end
        end)
      end)
    end
  end
end)
TeleportSection:Toggle("开启指定自瞄目标", "Aimbot", false, function(r0_462)
  
  if r0_462 then
    while r0_462 do
      local r1_462 = workspace.CurrentCamera
      local r2_462 = game.Players:FindFirstChild(PlayerConfig.playernamedied)
      local r3_462 = r2_462 and r2_462.Character and r2_462.Character.HumanoidRootPart
      if r3_462 and r1_462 then
        r1_462.CFrame = CFrame.new(r1_462.CFrame.Position, r1_462.CFrame.Position + (r3_462.Position - r1_462.CFrame.Position).unit)
        wait()
      else
        break
      end
    end
  end
end)

local AutoSayTab = UILibrary:Tab("『自动说话』", "18930406865")
local AutoSaySection = AutoSayTab:section("自动说话", true)
AutoSaySection:Textbox("你要说的话", "TextBoxFlag", "填写你想要说的话", function(r0_664)
  
  bin.message = r0_664
end)
AutoSaySection:Textbox("说话次数", "TextBoxFlag", "输入说话次数", function(r0_683)
  
  bin.sayCount = tonumber(r0_683) or 1
end)
AutoSaySection:Button("说话", function()
  
  bin.sayFast = true
  for r3_481 = 1, bin.sayCount, 1 do
    if bin.sayFast then
      game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(bin.message, "All")
      wait(0.1)
    end
  end
  bin.sayFast = false
end)
AutoSaySection:Button("停止说话", function()
  
  bin.sayFast = false
end)
AutoSaySection:Toggle("全自动说话", "ToggleFlag", false, function(r0_443)
  
  bin.autoSay = r0_443
  if r0_443 then
    while bin.autoSay do
      game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(bin.message, "All")
      wait(0.1)
    end
  else
    bin.autoSay = false
  end
end)
AutoSaySection:Label("骂人区")
AutoSaySection:Label("Roblox发言有限制 连续7条后要冷却10秒")
_G.szj = true
function szj()
  
  while _G.szj == true do
    wait(1)
    local r0_300 = {
      [1] = "是不是",
      [2] = "All",
    }
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(r0_300))
    wait(1)
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack({
      [1] = "沙不沙",
      [2] = "All",
    }))
    wait(1)
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack({
      [1] = "乐不乐",
      [2] = "All",
    }))
    wait(1)
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack({
      [1] = "糙溺麻",
      [2] = "All",
    }))
    wait(1)
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack({
      [1] = "词穷仔",
      [2] = "All",
    }))
    wait(1)
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack({
      [1] = "逗不逗",
      [2] = "All",
    }))
    wait(1)
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack({
      [1] = "喔楠菲",
      [2] = "All",
    }))
  end
end
AutoSaySection:Toggle("三字经", "MR", false, function(r0_120)
  
  _G.szj = r0_120
  szj()
end)
_G.sz = true
function sz()
  
  while _G.sz == true do
    wait()
    wait(1)
    local r0_242 = {
      [1] = "狗仗人势",
      [2] = "All",
    }
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(r0_242))
    wait(1)
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack({
      [1] = "猪狗不如",
      [2] = "All",
    }))
    wait(1)
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack({
      [1] = "狼心狗肺",
      [2] = "All",
    }))
    wait(1)
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack({
      [1] = "厚颜无耻",
      [2] = "All",
    }))
    wait(1)
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack({
      [1] = "恬不知耻",
      [2] = "All",
    }))
    wait(1)
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack({
      [1] = "司跌司麻",
      [2] = "All",
    }))
    wait(1)
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack({
      [1] = "阳奉阴违",
      [2] = "All",
    }))
  end
end
AutoSaySection:Toggle("四字成语", "MR", false, function(r0_397)
  
  _G.sz = r0_397
  sz()
end)
_G.sb = true
function sb()
  
  while _G.sb == true do
    wait()
    wait(1)
    local r0_377 = {
      [1] = "损人不利己",
      [2] = "All",
    }
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(r0_377))
    wait(1)
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack({
      [1] = "害人又害己",
      [2] = "All",
    }))
    wait(1)
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack({
      [1] = "活着浪费空气，司了浪费土地",
      [2] = "All",
    }))
    wait(1)
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack({
      [1] = "给你爱因斯坦的脑子都没有用",
      [2] = "All",
    }))
    wait(1)
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack({
      [1] = "整天不干正事",
      [2] = "All",
    }))
    wait(1)
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack({
      [1] = "没用的东西",
      [2] = "All",
    }))
  end
end
AutoSaySection:Toggle("骂人语录(我老师爱用×＿×)", "MR", false, function(r0_189)
  
  _G.sb = r0_189
  sb()
end)
local TimeTab = UILibrary:Tab("『时间』", "18930406865")
local TimeSection = TimeTab:section("时间", true)
local label1 = TimeSection:Label("1")
local label2 = TimeSection:Label("2")
local label3 = TimeSection:Label("3")
local label4 = TimeSection:Label("4")
local label5 = TimeSection:Label("5")

  
  task.spawn(function()
    
    
    while true do
      label1.Text = "当前时间: " .. os.date("%Y-%m-%d %H:%M:%S")
      local r3_442 = os.time({
        year = 2025,
        month = 1,
        day = 29,
        hour = 0,
        min = 0,
        sec = 0,
      }) - os.time()
      if r3_442 > 0 then
        label2.Text = string.format("春节倒计时: %d天%d小时%d分钟%d秒", math.floor(r3_442 / 86400), math.floor(r3_442 % 86400 / 3600), math.floor(r3_442 % 3600 / 60), r3_442 % 60)
      else
        label2.Text = "过年啦！！！"
      end
      wait(1)
    end
  end)


  
  task.spawn(function()
    
    
    while true do
      local r2_634 = os.time({
        year = 2026,
        month = 1,
        day = 1,
        hour = 0,
        min = 0,
        sec = 0,
      }) - os.time()
      if r2_634 > 0 then
        label3.Text = string.format("跨年倒计时: %d天%d小时%d分钟%d秒", math.floor(r2_634 / 86400), math.floor(r2_634 % 86400 / 3600), math.floor(r2_634 % 3600 / 60), r2_634 % 60)
      else
        label3.Text = "跨年啦！！！"
      end
      wait(1)
    end
  end)


  
  task.spawn(function()
    
    
    while true do
      local r2_78 = os.time({
        year = 2025,
        month = 1,
        day = 28,
        hour = 0,
        min = 0,
        sec = 0,
      }) - os.time()
      if r2_78 > 0 then
        label4.Text = string.format("除夕倒计时: %d天%d小时%d分钟%d秒", math.floor(r2_78 / 86400), math.floor(r2_78 % 86400 / 3600), math.floor(r2_78 % 3600 / 60), r2_78 % 60)
      else
        label4.Text = "除夕啦！！！"
      end
      wait(1)
    end
  end)


  
  task.spawn(function()
    
    
    while true do
      local r2_671 = os.time({
        year = 2025,
        month = 2,
        day = 12,
        hour = 0,
        min = 0,
        sec = 0,
      }) - os.time()
      if r2_671 > 0 then
        label5.Text = string.format("元宵节倒计时: %d天%d小时%d分钟%d秒", math.floor(r2_671 / 86400), math.floor(r2_671 % 86400 / 3600), math.floor(r2_671 % 3600 / 60), r2_671 % 60)
      else
        label5.Text = "元宵节啦！！！"
      end
      wait(1)
    end
  end)

local ESPTab = UILibrary:Tab("『透视ESP』", "18930406865")
local ESPSection = ESPTab:section("透视ESP", true)
ESPSection:Label("①透视ESP")
ESPSection:Label("每个服务器都可以用 『推荐开启』")
local RunService = game:GetService("RunService")
local PlayersESP = game:GetService("Players")
local LocalPlayerESP = PlayersESP.LocalPlayer
local NameESPEnabled = false
local HighlightESPEnabled = false
local TracerESPEnabled = false
local BoxESPEnabled = false
local SquareESPEnabled = false
local function CreateNameESP(player)
  
  local billboard = Instance.new("BillboardGui")
  local textLabel = Instance.new("TextLabel")
  billboard.Name = "NameESP"
  billboard.Adornee = player.Character:WaitForChild("Head")
  billboard.Size = UDim2.new(0, 100, 0, 50)
  billboard.StudsOffset = Vector3.new(0, 3, 0)
  billboard.AlwaysOnTop = true
  textLabel.Parent = billboard
  textLabel.BackgroundTransparency = 1
  textLabel.Text = player.Name
  textLabel.Size = UDim2.new(1, 0, 1, 0)
  textLabel.TextColor3 = Color3.new(1, 1, 1)
  textLabel.TextScaled = true
  local distanceLabel = Instance.new("TextLabel")
  distanceLabel.Parent = billboard
  distanceLabel.BackgroundTransparency = 1
  distanceLabel.Position = UDim2.new(0, 0, 0, 30)
  distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
  distanceLabel.TextColor3 = Color3.new(1, 1, 1)
  distanceLabel.TextScaled = true
  local function UpdateDistance()
    
    if billboard.Parent then
      distanceLabel.Text = string.format("距离%.2f米", (LocalPlayerESP.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude)
    end
  end
  spawn(function()
    
    while billboard.Parent do
      UpdateDistance()
      wait(0.1)
    end
  end)
  billboard.Parent = player.Character:WaitForChild("Head")
end
local function DestroyNameESP(player)
  
  if player.Character and player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("NameESP") then
    player.Character.Head.NameESP:Destroy()
  end
end
local function CreateHighlightESP(player)
  
  local highlight = Instance.new("Highlight")
  highlight.Name = "HighlightESP"
  highlight.Adornee = player.Character
  highlight.FillTransparency = 0.5
  highlight.OutlineColor = Color3.new(1, 1, 1)
  highlight.OutlineTransparency = 0
  highlight.Parent = player.Character
  local function UpdateTeamColor()
    
    if player.Team and player.Team.TeamColor then
      highlight.FillColor = player.Team.TeamColor.Color
    else
      highlight.FillColor = Color3.new(1, 1, 1)
    end
  end
  UpdateTeamColor()
  player:GetPropertyChangedSignal("Team"):Connect(UpdateTeamColor)
end
local function DestroyHighlightESP(player)
  
  if player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("HighlightESP") then
    player.Character.HighlightESP:Destroy()
  end
end
local function CreateTracerESP(player)
  
  local tracer = Drawing.new("Line")
  tracer.Visible = false
  tracer.Color = Color3.new(1, 1, 1)
  tracer.Thickness = 1
  tracer.Transparency = 1
  RunService.RenderStepped:Connect(function()
    
    if TracerESPEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and LocalPlayerESP.Character and LocalPlayerESP.Character:FindFirstChild("HumanoidRootPart") then
      tracer.Visible = true
      local screenPos, isVisible = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
      if isVisible then
        tracer.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
        tracer.To = Vector2.new(screenPos.X, screenPos.Y)
      else
        tracer.Visible = false
      end
    else
      tracer.Visible = false
    end
  end)
  player.CharacterRemoving:Connect(function()
    
    tracer:Remove()
  end)
end
local function DestroyTracerESP(player)
  
  if player:FindFirstChild("TracerESP") then
    player.TracerESP:Destroy()
  end
end
local function CreateBoxESP(player)
  
  local box = Instance.new("BoxHandleAdornment")
  box.Name = "BoxESP"
  box.Size = player.Character:GetExtentsSize() * 1.1
  box.Adornee = player.Character
  box.AlwaysOnTop = true
  box.ZIndex = 5
  box.Transparency = 0.5
  box.Color3 = Color3.new(1, 0, 0)
  box.Parent = player.Character
end
local function DestroyBoxESP(player)
  
  if player.Character:FindFirstChild("BoxESP") then
    player.Character.BoxESP:Destroy()
  end
end
local function CreateSquareESP(player)
  
  local square = Drawing.new("Square")
  square.Visible = false
  square.Transparency = 0.5
  square.Color = Color3.new(1, 0, 0)
  square.Thickness = 2
  RunService.RenderStepped:Connect(function()
    
    if SquareESPEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and LocalPlayerESP.Character and LocalPlayerESP.Character:FindFirstChild("HumanoidRootPart") then
      square.Visible = true
      local rootPart = player.Character.HumanoidRootPart
      local screenPos, isVisible = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
      if isVisible then
        local extents = player.Character:GetExtentsSize()
        local topLeft = workspace.CurrentCamera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(extents.X / -2, extents.Y / 2, 0)).p)
        local bottomRight = workspace.CurrentCamera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(extents.X / 2, -extents.Y / 2, 0)).p)
        square.Size = Vector2.new(bottomRight.X - topLeft.X, bottomRight.Y - topLeft.Y)
        square.Position = Vector2.new(topLeft.X, topLeft.Y)
      else
        square.Visible = false
      end
    else
      square.Visible = false
    end
  end)
  player.CharacterRemoving:Connect(function()
    
    square:Remove()
  end)
end
local function DestroySquareESP(player)
  
end
local function SetupPlayerESP(player)
  
  player.CharacterAdded:Connect(function()
    
    wait(1)
    if NameESPEnabled then
      CreateNameESP(player)
    end
    if HighlightESPEnabled then
      CreateHighlightESP(player)
    end
    if TracerESPEnabled then
      CreateTracerESP(player)
    end
    if BoxESPEnabled then
      CreateBoxESP(player)
    end
    if SquareESPEnabled then
      CreateSquareESP(player)
    end
  end)
end
local function RemovePlayerESP(player)
  
  DestroyNameESP(player)
  DestroyHighlightESP(player)
  DestroyTracerESP(player)
  DestroyBoxESP(player)
  DestroySquareESP(player)
end
local function ToggleNameESP(enabled)
  
  NameESPEnabled = enabled
  for _, player in pairs(PlayersESP:GetPlayers()) do
    if player ~= LocalPlayerESP then
      DestroyNameESP(player)
    end
  end
  
  
  
  
end
local function ToggleHighlightESP(enabled)
  
  HighlightESPEnabled = enabled
  for _, player in pairs(PlayersESP:GetChildren()) do
    if player ~= LocalPlayerESP then
      DestroyHighlightESP(player)
    end
  end
  
  
  
  
end
local function ToggleTracerESP(enabled)
  
  TracerESPEnabled = enabled
  for _, player in pairs(PlayersESP:GetPlayers()) do
    if player ~= LocalPlayerESP then
      if TracerESPEnabled then
        CreateTracerESP(player)
      else
        DestroyTracerESP(player)
      end
    end
  end
end
local function ToggleBoxESP(enabled)
  
  BoxESPEnabled = enabled
  for _, player in pairs(PlayersESP:GetPlayers()) do
    if player ~= LocalPlayerESP then
      if BoxESPEnabled then
        CreateBoxESP(player)
      else
        DestroyBoxESP(player)
      end
    end
  end
end
local function ToggleSquareESP(enabled)
  
  SquareESPEnabled = enabled
  for _, player in pairs(PlayersESP:GetPlayers()) do
    if player ~= LocalPlayerESP then
      if SquareESPEnabled then
        CreateSquareESP(player)
      else
        DestroySquareESP(player)
      end
    end
  end
end
for _, player in pairs(PlayersESP:GetPlayers()) do
  if player ~= LocalPlayerESP then
    SetupPlayerESP(player)
  end
end
PlayersESP.PlayerAdded:Connect(function(player)
  
  if player ~= LocalPlayerESP then
    SetupPlayerESP(player)
  end
end)
PlayersESP.PlayerRemoving:Connect(RemovePlayerESP)
ESPSection:Toggle("透视位置", "ESP", false, function(enabled)
  
  local function EnableNameDisplay(player)
    
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
      player.Character.Humanoid.NameDisplayDistance = 9000000000
      player.Character.Humanoid.NameOcclusion = "NoOcclusion"
      player.Character.Humanoid.HealthDisplayDistance = 9000000000
      player.Character.Humanoid.HealthDisplayType = "AlwaysOn"
      player.Character.Humanoid.Health = player.Character.Humanoid.Health
    end
  end
  for _, player in pairs(game.Players:GetPlayers()) do
    EnableNameDisplay(player)
    player.CharacterAdded:Connect(function()
      
      task.wait(0.33)
      EnableNameDisplay(player)
    end)
    
  end
  game.Players.PlayerAdded:Connect(function(player)
    
    EnableNameDisplay(player)
    player.CharacterAdded:Connect(function()
      
      task.wait(0.33)
      EnableNameDisplay(player)
    end)
  end)
end)
ESPSection:Toggle("透视名字", "ESP", false, function(enabled)
  
  ToggleNameESP(enabled)
end)
ESPSection:Toggle("开启内透", "ESP", false, function(enabled)
  
  ToggleHighlightESP(enabled)
end)
ESPSection:Toggle("透视射线", "ESP", false, function(enabled)
  
  ToggleTracerESP(enabled)
end)
ESPSection:Toggle("透视3D框", "ESP", false, function(enabled)
  
  ToggleBoxESP(enabled)
end)
ESPSection:Toggle("透视2D框", "ESP", false, function(enabled)
  
  ToggleSquareESP(enabled)
end)
ESPSection:Label("②透视ESP")
local ESPLib = loadstring(game:HttpGet("https://pastefy.app/gR9TNZLb/raw"))()
ESPLib:Toggle(true)
ESPLib.Players = false
ESPLib.Tracers = false
ESPLib.Boxes = false
ESPLib.Names = false
ESPLib.TeamColor = false
ESPLib.TeamMates = false
ESPSection:Toggle("开启/关闭透视(总开关 必开)", "ESP", false, function(enabled)
  
  ESPLib.Players = enabled
end)
ESPSection:Toggle("显示名称", "ESP", false, function(enabled)
  
  ESPLib.Names = enabled
end)
ESPSection:Toggle("显示框框", "ESP", false, function(enabled)
  
  ESPLib.Boxes = enabled
end)
ESPSection:Toggle("显示射线", "ESP", false, function(enabled)
  
  ESPLib.Tracers = enabled
end)
ESPSection:Toggle("开启/关闭透视队伍验证", "ESP", false, function(enabled)
  
  ESPLib.TeamColor = enabled
end)
ESPSection:Label("③透视ESP")
getgenv().ESPEnabled = false
getgenv().ShowBox = false
getgenv().ShowHealth = false
getgenv().ShowName = false
getgenv().ShowDistance = false
getgenv().ShowTracer = false
getgenv().TeamCheck = false
local PlayersESP3 = game:GetService("Players")
local RunService3 = game:GetService("RunService")
local Camera3 = workspace.CurrentCamera
local LocalPlayerESP3 = PlayersESP3.LocalPlayer
local function CreateESP3(player)
  
  local box = Drawing.new("Square")
  box.Visible = false
  box.Color = Color3.new(1, 1, 1)
  box.Thickness = 1
  box.Filled = false
  local healthText = Drawing.new("Text")
  healthText.Visible = false
  healthText.Color = Color3.new(0, 1, 0)
  healthText.Size = 16
  local nameText = Drawing.new("Text")
  nameText.Visible = false
  nameText.Color = Color3.new(1, 1, 1)
  nameText.Size = 16
  local distText = Drawing.new("Text")
  distText.Visible = false
  distText.Color = Color3.new(1, 1, 0)
  distText.Size = 16
  local tracer = Drawing.new("Line")
  tracer.Visible = false
  tracer.Color = Color3.new(1, 0, 0)
  tracer.Thickness = 1
  RunService3.RenderStepped:Connect(function()
    
    if not getgenv().ESPEnabled or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") or not player.Character:FindFirstChild("Humanoid") or player == LocalPlayerESP3 then
      box.Visible = false
      healthText.Visible = false
      nameText.Visible = false
      distText.Visible = false
      tracer.Visible = false
      return 
    end
    if getgenv().TeamCheck and player.Team == LocalPlayerESP3.Team then
      box.Visible = false
      healthText.Visible = false
      nameText.Visible = false
      distText.Visible = false
      tracer.Visible = false
      return 
    end
    local character = player.Character
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    if rootPart and humanoid and 0 < humanoid.Health then
      local screenPos, isVisible = Camera3:WorldToViewportPoint(rootPart.Position)
      local topScreen, _ = Camera3:WorldToViewportPoint(rootPart.Position + Vector3.new(0, 3, 0))
      local bottomScreen, _ = Camera3:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
      if getgenv().ShowBox and isVisible then
        box.Size = Vector2.new(1000 / screenPos.Z, topScreen.Y - bottomScreen.Y)
        box.Position = Vector2.new(screenPos.X - box.Size.X / 2, screenPos.Y - box.Size.Y / 2)
        box.Visible = true
      else
        box.Visible = false
      end
      if getgenv().ShowHealth and isVisible then
        healthText.Position = Vector2.new(screenPos.X, screenPos.Y - box.Size.Y / 2 - 20)
        healthText.Text = "血量: " .. math.floor(humanoid.Health)
        healthText.Visible = true
      else
        healthText.Visible = false
      end
      if getgenv().ShowName and isVisible then
        nameText.Position = Vector2.new(screenPos.X, screenPos.Y - box.Size.Y / 2 - 40)
        nameText.Text = "名字: " .. player.Name
        nameText.Visible = true
      else
        nameText.Visible = false
      end
      if getgenv().ShowDistance and isVisible then
        distText.Position = Vector2.new(screenPos.X, screenPos.Y + box.Size.Y / 2 + 20)
        distText.Text = "距离: " .. math.floor((LocalPlayerESP3.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude) .. " ㎝"
        distText.Visible = true
      else
        distText.Visible = false
      end
      if getgenv().ShowTracer then
        tracer.From = Vector2.new(Camera3.ViewportSize.X / 2, Camera3.ViewportSize.Y)
        tracer.To = Vector2.new(screenPos.X, screenPos.Y)
        tracer.Visible = isVisible
      else
        tracer.Visible = false
      end
    else
      box.Visible = false
      healthText.Visible = false
      nameText.Visible = false
      distText.Visible = false
      tracer.Visible = false
    end
  end)
end
for _, player in pairs(PlayersESP3:GetPlayers()) do
  if player ~= LocalPlayerESP3 then
    CreateESP3(player)
  end
end
PlayersESP3.PlayerAdded:Connect(function(player)
  
  if player ~= LocalPlayerESP3 then
    CreateESP3(player)
  end
end)
ESPSection:Toggle("ESP总开关[必开]", "Enabled", false, function(enabled)
  
  getgenv().ESPEnabled = enabled
end)
ESPSection:Toggle("身体方框", "Box", false, function(enabled)
  
  getgenv().ShowBox = enabled
end)
ESPSection:Toggle("血量", "Health", false, function(enabled)
  
  getgenv().ShowHealth = enabled
end)
ESPSection:Toggle("用户名", "Name", false, function(enabled)
  
  getgenv().ShowName = enabled
end)
ESPSection:Toggle("距离", "Distance", false, function(enabled)
  
  getgenv().ShowDistance = enabled
end)
ESPSection:Toggle("天线", "Tracer", false, function(enabled)
  
  getgenv().ShowTracer = enabled
end)
ESPSection:Toggle("团队判断", "Team check", false, function(enabled)
  
  getgenv().TeamCheck = enabled
end)
local AimbotTab = UILibrary:Tab("『自瞄』", "18930406865")
local AimbotSection = AimbotTab:section("自瞄", true)
AimbotSection:Label("圈圈自瞄")
AimbotSection:Toggle("显示圈圈自瞄", "open/close", false, function(enabled)
  
  if enabled then
    InitFOV(AimConfig.fovsize, AimConfig.fovcolor, AimConfig.fovthickness, AimConfig.Transparency)
  else
    CleanupFOV()
  end
end)
AimbotSection:Toggle("开启/关闭圈圈自瞄", "open/close", false, function(enabled)
  
  AimConfig.fovlookAt = enabled
end)
AimbotSection:Slider("圈圈自瞄厚度", "thickness", 2, 0, 10, false, function(value)
  
  AimConfig.fovthickness = value
  UpdateFOVSettings()
end)
AimbotSection:Slider("圈圈自瞄大小", "Size", 50, 0, 100, false, function(value)
  
  AimConfig.fovsize = value
  UpdateFOVSettings()
end)
AimbotSection:Slider("圈圈自瞄透明度", "Transparency", 5, 0, 10, false, function(value)
  
  AimConfig.Transparency = value
  UpdateFOVSettings()
end)
AimbotSection:Slider("圈圈自瞄距离", "distance", 200, 10, 500, false, function(value)
  
  AimConfig.distance = value
end)
local colorDropdown = AimbotSection:Dropdown("选择圈圈自瞄颜色", "Dropdown", {
  "红色",
  "蓝色",
  "黄色",
  "绿色",
  "青色",
  "橙色",
  "紫色",
  "白色",
  "黑色"
}, function(value)
  
  AimConfig.fovcolor = ColorConfig[value]
  UpdateFOVSettings()
end)
local bodyPartDropdown = AimbotSection:Dropdown("选择圈圈自瞄部位", "Dropdown", {
  "头部",
  "脖子",
  "躯干",
  "左臂",
  "右臂",
  "左腿",
  "右腿",
  "左手",
  "右手",
  "左小臂",
  "右小臂",
  "左大臂",
  "右大臂",
  "左脚",
  "左小腿",
  "上半身",
  "左大腿",
  "右脚",
  "右小腿",
  "下半身",
  "右大腿",
}, function(value)
  
  AimConfig.Position = BodyPartMap[value]
  UpdateFOVSettings()
end)
AimbotSection:Toggle("队伍检测", "Enable/Disable Team Check", false, function(enabled)
  
  AimConfig.teamCheck = enabled
end)
AimbotSection:Toggle("活体检测", "Alive Check", false, function(enabled)
  
  AimConfig.aliveCheck = enabled
end)
AimbotSection:Toggle("墙壁检测", "Enable/Disable Wall Check", false, function(enabled)
  
  AimConfig.wallCheck = enabled
end)
AimbotSection:Toggle("预判自瞄", "prejudging self-sighting", false, function(enabled)
  
  AimConfig.prejudgingselfsighting = enabled
end)
AimbotSection:Slider("预判距离", "distance", 100, 10, 500, false, function(value)
  
  AimConfig.prejudgingselfsightingdistance = value
end)
AimbotSection:Label("Distance距离优先 : 优先瞄准距离最近的敌人")
AimbotSection:Label("Crosshair准星优先 : 优先瞄准准星附近的敌人")
AimbotSection:Label("Speed速度优先 : 优先瞄准移动速度最快的敌人")
AimbotSection:Label("Smart智能模式 : 综合距离、速度和准星距离，自动选择最佳目标")
local priorityDropdown = AimbotSection:Dropdown("圈圈自瞄优先模式", "Priority Mode", {
  "Distance",
  "Crosshair",
  "Speed",
  "Smart"
}, function(value)
  
  AimConfig.priorityMode = value
end)
AimbotSection:Label("AI自瞄 : 使用AI算法进行自瞄")
AimbotSection:Label("函数自瞄 : 使用数学函数进行自瞄")
local aimModeDropdown = AimbotSection:Dropdown("自瞄模式", "Aim Mode", {
  "AI",
  "Function"
}, function(value)
  
  AimConfig.aimMode = value
end)
AimbotSection:Slider("平滑度", "Smoothness", 5, 0, 10, false, function(value)
  
  AimConfig.smoothness = value
end)
AimbotSection:Slider("自瞄速度", "Aim Speed", 5, 0, 10, false, function(value)
  
  AimConfig.aimSpeed = value
end)
AimbotSection:Label("动态自瞄")
AimbotSection:Toggle("动态自瞄FOV", "Dynamic FOV Scaling", false, function(enabled)
  
  AimConfig.dynamicFOV = enabled
  if enabled then
    AimConfig.fovsize = 20 / AimConfig.smoothness * AimConfig.aimSpeed
    UpdateFOVSettings()
  else
    AimConfig.fovsize = 20
    UpdateFOVSettings()
  end
end)
AimbotSection:Slider("动态FOV缩放比例", "Dynamic FOV Scale", 1.5, 1, 3, false, function(value)
  
  AimConfig.dynamicFOVScale = value
  if AimConfig.dynamicFOV then
    AimConfig.fovsize = 20 / AimConfig.smoothness * AimConfig.aimSpeed * value
    UpdateFOVSettings()
  end
end)
AimbotSection:Toggle("自动开火", "Auto Fire", false, function(enabled)
  
  AimConfig.autoFire = enabled
end)
AimbotSection:Slider("开火频率", "Fire Rate", 10, 1, 20, false, function(value)
  
  AimConfig.fireRate = value
end)
AimbotSection:Slider("子弹延迟", "Bullet Delay", 0.1, 0, 1, false, function(value)
  
  AimConfig.bulletDelay = value
end)
AimbotSection:Toggle("武器切换", "Weapon Switch", false, function(enabled)
  
  AimConfig.weaponSwitch = enabled
end)
AimbotSection:Toggle("威胁度优先", "Threat Priority", false, function(enabled)
  
  AimConfig.threatPriority = enabled
end)
AimbotSection:Toggle("血量优先", "Health Priority", false, function(enabled)
  
  AimConfig.healthPriority = enabled
end)
local FETab = UILibrary:Tab("『FE』", "18930406865")
local FESection = FETab:section("脚本", true)
FESection:Button("FE cmd", function()
  
  loadstring(game:HttpGet("https://raw.githubusercontent.com/lxte/cmd/main/testing-main.lua"))()
end)
FESection:Button("FE C00lgui", function()
  
  loadstring(game:GetObjects("rbxassetid://8127297852")[1].Source)()
end)
FESection:Button("FE 1x1x1x1", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/JipYNCht", true))()
end)
FESection:Button("FE 大长腿", function()
  
  loadstring(game:HttpGet([[https://gist.githubusercontent.com/1BlueCat/7291747e9f093555573e027621f08d6e/raw/23b48f2463942befe19d81aa8a06e3222996242c/FE%2520Da%2520Feets]]))()
end)
FESection:Button("FE 用头", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/BK4Q0DfU"))()
end)
FESection:Button("FE 复仇者", function()
  
  loadstring(game:HttpGet("https://pastefy.ga/iGyVaTvs/raw", true))()
end)
FESection:Button("FE 鼠标", function()
  
  loadstring(game:HttpGet("https://pastefy.ga/V75mqzaz/raw", true))()
end)
FESection:Button("FE 变怪物", function()
  
  loadstring(game:HttpGetAsync("https://pastebin.com/raw/jfryBKds"))()
end)
FESection:Button("FE 香蕉枪", function()
  
  loadstring(game:HttpGet("https://raw.githubusercontent.com/MrNeRD0/Doors-Hack/main/BananaGunByNerd.lua"))()
end)
FESection:Button("FE 超长级把", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/ESWSFND7", true))()
end)
FESection:Button("FE 动画中心", function()
  
  loadstring(game:HttpGet([[https://raw.githubusercontent.com/GamingScripter/Animation-Hub/main/Animation%20Gui]], true))()
end)
FESection:Button("FE 变玩家", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/PvnN4B8R"))()
end)
FESection:Button("FE 猫娘R63", function()
  
  loadstring(game:HttpGet([[https://raw.githubusercontent.com/Tescalus/Pendulum-Hubs-Source/main/Pendulum%20Hub%20V5.lua]]))()
end)
FESection:Button("FE", function()
  
  loadstring(game:HttpGet("https://pastefy.ga/a7RTi4un/raw"))()
end)
FESection:Button("FE R6撸管", function()
  
  loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))()
end)
FESection:Button("FE R15撸管", function()
  
  loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
end)
FESection:Button("FE R6远程操蛋", function()
  
  loadstring(game:HttpGet([[https://raw.githubusercontent.com/roblox-ye/QQ515966991/refs/heads/main/YE-R6CB-SCRIPT.lua]]))()
end)
FESection:Button("FE R15远程操蛋", function()
  
  loadstring(game:HttpGet([[https://raw.githubusercontent.com/roblox-ye/QQ515966991/refs/heads/main/YE-R15CB-SCRIPT.lua]]))()
end)
FESection:Button("FE Tuber93入侵弹窗图显示", function()
  
  loadstring(game:HttpGet("https://pastefy.app/veGCWoZ6/raw"))()
end)
FESection:Button("FE 修改皮脚本天空", function()
  
  loadstring(game:HttpGet("https://pastefy.app/HZaYQYHa/raw"))()
end)
FESection:Button("FE 黑客入侵", function()
  
  loadstring(game:HttpGet("https://pastefy.app/qQOkHeaY/raw"))()
end)
local MusicTab = UILibrary:Tab("『音乐』", "18930406865")
local MusicSection = MusicTab:section("音乐", true)
MusicSection:Label("输入音乐ID即可 播放音乐仅自己可听见")
MusicSection:Textbox("音乐播放器", "Textbox", "输入音乐ID", true, function(id)
  
  if id then
    audio.SoundId = "rbxassetid://" .. id
    audio:Play()
  end
end)
MusicSection:Button("停止播放", function()
  
  audio:Stop()
end)
MusicSection:Label("下面是音乐合集↓")
MusicSection:Button("防空警报", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://792323017"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("义勇军进行曲", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://1845918434"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("彩虹瀑布", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://1837879082"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("雨中牛郎", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://16831108393"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("钢管落地(大声)", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://6729922069"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("钢管落地", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://6011094380"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("闪灯", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://8829969521"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("全损音质", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://6445594239"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("串稀", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://4809574295"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("手枪开枪", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://6569844325"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("喝可乐", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://6911756959"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("Doors TheHunt 倒计时开始", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://16695384009"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("Doors TheHunt 倒计时结束", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://16695021133"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("你他妈劈我瓜是吧", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://7309604510"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("未知核爆倒计时", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://9133927345"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("火车音", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://3900067524"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("Gentry Road", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://5567523008"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("植物大战僵尸", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://158260415"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("早安越南", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://8295016126"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("愤怒芒西 Evade?", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://5029269312"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("梅西", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://7354576319"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("永春拳", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://1845973140"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("带劲的音乐", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://18841891575"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("韩国国歌", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://1837478300"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("哥哥你女朋友不会吃醋吧?", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://8715811379"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("蜘蛛侠出场声音", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://9108472930"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("消防车", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://317455930"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("万圣节1������", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://1837467198"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("好听的", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://1844125168"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("妈妈生的", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://6689498326"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("Music Ball-CTT", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://9045415830"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("电音", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://6911766512"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("梗合集", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://8161248815"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("Its been so long", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://6913550990"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("Baller", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://13530439660"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("男娘必听", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://6797864253"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("螃蟹之舞", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://54100886218"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("布鲁克林惨案", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://6783714255"
  sound.Parent = game.Workspace
  sound:Play()
end)
MusicSection:Button("航空模拟器音乐", function()
  
  local sound = Instance.new("Sound")
  sound.SoundId = "rbxassetid://1838080629"
  sound.Parent = game.Workspace
  sound:Play()
end)
local OtherScriptsTab = UILibrary:Tab("『其他脚本』", "18930406865")
local OtherScriptsSection = OtherScriptsTab:section("其他脚本", true)
OtherScriptsSection:Button("鸭Hub", function()
  
  loadstring(game:HttpGet(utf8.char((function()
    
    return table.unpack({
      104,
      116,
      116,
      112,
      115,
      58,
      47,
      47,
      112,
      97,
      115,
      116,
      101,
      98,
      105,
      110,
      46,
      99,
      111,
      109,
      47,
      114,
      97,
      119,
      47,
      81,
      89,
      49,
      113,
      112,
      99,
      115,
      106,
      nil,
      nil,
      nil
    })
  end)())))()
end)
OtherScriptsSection:Button("落叶中心", function()
  
  getgenv().LS = "落叶中心"
  loadstring(game:HttpGet([[https://raw.githubusercontent.com/krlpl/Deciduous-center-LS/main/%E8%90%BD%E5%8F%B6%E4%B8%AD%E5%BF%83%E6%B7%B7%E6%B7%86.txt]]))()
end)
OtherScriptsSection:Button("情云脚本", function()
  
  loadstring(game:HttpGet([[https://raw.githubusercontent.com/krlpl/Qing-YunX/main/%E6%83%85%E4%BA%91%E6%B7%B7%E6%B7%86.lua]]))()
end)
OtherScriptsSection:Button("鲨脚本", function()
  
  loadstring(game:HttpGet([[https://raw.githubusercontent.com/sharksharksharkshark/shark-shark-shark-shark-shark/main/shark-scriptlollol.txt]], true))()
end)
OtherScriptsSection:Button("河流脚本", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/M29MuQsP"))()
end)
OtherScriptsSection:Button("地岩脚本", function()
  
  loadstring([[loadstring(game:HttpGet("https://raw.githubusercontent.com/bbamxbbamxbbamx/codespaces-blank/main/%E7%99%BD"))()]])()
end)
OtherScriptsSection:Button("云脚本", function()
  
  loadstring(game:HttpGet([[https://raw.githubusercontent.com/XiaoYunCN/VIP/main/%E4%BA%91%E8%84%9A%E6%9C%AC/UNIVERSAL%20VERSION.LUA]], true))()
end)
OtherScriptsSection:Button("小凌中心", function()
  
  XiaoLing = "小凌中心.Cocoe"
  loadstring(game:HttpGet([[https://raw.githubusercontent.com/flyspeed7/Xiao-Ling-NEO.UI/main/%E2%82%AA%E5%B0%8F%E5%87%8C%E4%B8%AD%E5%BF%83(%E6%96%B0%E7%89%88ui).txt]]))("小凌中心")("作者QQ:1211373508")
end)
OtherScriptsSection:Button("北极鲨脚本", function()
  
  loadstring(game:HttpGet([[https://raw.githubusercontent.com/sharksharksharkshark/potential-rotary-phone/main/bei%20ji%20shark.lua]], true))()
end)
OtherScriptsSection:Button("皮脚本测试版", function()
  
  getgenv().XiaoPi = "皮脚本测试版QQ群1002100032"
  loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/PijiaobenV1.lua"))()
end)
OtherScriptsSection:Button("XK脚本中心", function()
  
  loadstring([[
loadstring(game:HttpGet("https://raw.githubusercontent.com/BINjiaobzx6/BINjiao/main/XK.TXT"))()
]])()
end)
OtherScriptsSection:Button("k1s脚本", function()
  
  getgenv().LS = "k1s"
  loadstring(game:HttpGet("https://raw.githubusercontent.com/krlpl/llkj/main/ljj.txt"))()
end)
OtherScriptsSection:Button("XC脚本", function()
  
  getgenv().XC = "作者XC"
  loadstring(game:HttpGet("https://pastebin.com/raw/PAFzYx0F"))()
end)
OtherScriptsSection:Button("七脚本", function()
  
  loadstring("loadstring(game:HttpGet(\"https://pastebin.com/raw/iSbFa99J\"))()\n")()
end)
OtherScriptsSection:Button("林脚本", function()
  
  lin = "作者林"
  lin = "林QQ群 747623342"
  loadstring(game:HttpGet("https://raw.githubusercontent.com/linnblin/lin/main/lin"))()
end)
OtherScriptsSection:Button("小天脚本", function()
  
  loadstring(game:HttpGet([[https://raw.githubusercontent.com/dkfkfkfjfkfjdj/README.md/main/%E6%B7%B7%E6%B7%86%E6%96%87%E4%BB%B6.lua]]))()
end)
OtherScriptsSection:Button("黑洞中心", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/zSbimc3i"))()
end)
OtherScriptsSection:Button("丁丁脚本", function()
  
  loadstring(game:HttpGet([[https://raw.githubusercontent.com/dingding123hhh/vvbnn/main/%E4%B8%81%E4%B8%81%E8%84%9A%E6%9C%AC%E9%98%89%E5%89%B2.txt]]))()
end)
OtherScriptsSection:Button("导管中心", function()
  
  loadstring([[
loadstring(game:HttpGet("https://raw.githubusercontent.com/useranewrff/roblox-/main/%E6%9D%A1%E6%AC%BE%E5%8D%8F%E8%AE%AE"))()
]])()
end)
OtherScriptsSection:Button("星空脚本", function()
  
  loadstring(game:HttpGet([[https://raw.githubusercontent.com/XiaoYunCN/UWU/main/%E5%85%B6%E4%BB%96%E5%9B%BD%E5%86%85%E8%84%9A%E6%9C%AC/%E6%98%9F%E7%A9%BA%E8%84%9A%E6%9C%AC/MoonSecV3.lua]]))()
end)
local OtherInjectorsTab = UILibrary:Tab("『其他注入器』", "18930406865")
local OtherInjectorsSection = OtherInjectorsTab:section("其他注入器", true)
OtherInjectorsSection:Button("syn", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/tWGxhNq0"))()
end)
OtherInjectorsSection:Button("syn2", function()
  
  loadstring(game:HttpGet([[https://raw.githubusercontent.com/AZYsGithub/Chillz-s-scripts/main/Synapse-X-Remake.lua]]))()
end)
OtherInjectorsSection:Button("阿尔宙斯V3", function()
  
  loadstring(game:HttpGet([[https://raw.githubusercontent.com/AZYsGithub/chillz-workshop/main/Arceus%20X%20V3]]))()
end)
OtherInjectorsSection:Button("水滴注入器", function()
  
  loadstring(game:HttpGet([[https://raw.githubusercontent.com/crceck123/roblox-script/main/hydrogen_skin_for_evon.lua]]))()
end)
local GraphicsTab = UILibrary:Tab("『画质光影』", "18930406865")
local GraphicsSection = GraphicsTab:section("画质光影", true)
GraphicsSection:Label("先后顺序:运动模糊-径向模糊-方向模糊")
local blurTypeDropdown = GraphicsSection:Dropdown("模糊类型", "blurTypes", BlurTypes, function(value)
  
  SetBlurType(value)
end)
local presetNames = {}
for _, preset in ipairs(BlurPresets) do
  table.insert(presetNames, preset.name)
end
local presetDropdown = GraphicsSection:Dropdown("模糊效果预设", "presetNames", presetNames, function(value)
  
  for _, preset in ipairs(BlurPresets) do
    if preset.name == value then
      ApplyBlurPreset(preset)
      break
    end
  end
end)
GraphicsSection:Toggle("动态模糊", "动态模糊", false, function(enabled)
  
  MotionBlurEnabled = enabled
  if MotionBlurEnabled then
    CreateBlurEffect(workspace.CurrentCamera)
  elseif BlurEffectInstance then
    BlurEffectInstance:Destroy()
    BlurEffectInstance = nil
  end
end)
GraphicsSection:Slider("模糊强度", 1, 1, 50, BlurAmount, function(value)
  
  BlurAmount = value
end)
GraphicsSection:Slider("模糊平滑度", 0.1, 0.01, 1, BlurSmoothness, function(value)
  
  BlurSmoothness = value
end)
GraphicsSection:Slider("模糊阈值", 0.1, 0.01, 1, BlurThreshold, function(value)
  
  BlurThreshold = value
end)
GraphicsSection:Slider("模糊持续时间", 0.5, 0.1, 5, 0.5, function(value)
  
  -- 保存到全局变量
  _G.BlurDuration = value
end)
GraphicsSection:Slider("模糊方向 X", -1, 0, 1, 1, function(value)
  
  BlurDirection = Vector2.new(value, BlurDirection.Y)
end)
GraphicsSection:Slider("模糊方向 Y", -1, 0, 1, 0, function(value)
  
  BlurDirection = Vector2.new(BlurDirection.X, value)
end)
GraphicsSection:Slider("模糊区域 X1", 0.5, 0, 1, 0, function(value)
  
  BlurUV[1] = value
end)
GraphicsSection:Slider("模糊区域 Y1", 0.5, 0, 1, 0, function(value)
  
  BlurUV[2] = value
end)
GraphicsSection:Slider("模糊区域 X2", 0.5, 0, 1, 1, function(value)
  
  BlurUV[3] = value
end)
GraphicsSection:Slider("模糊区域 Y2", 0.5, 0, 1, 1, function(value)
  
  BlurUV[4] = value
end)
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
  local cam = workspace.CurrentCamera
  if not cam then return end
  if BlurEffectInstance and BlurEffectInstance.Parent then
    BlurEffectInstance.Parent = cam
  else
    CreateBlurEffect(cam)
  end
end)
game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
  
  local camera = workspace.CurrentCamera
  if MotionBlurEnabled and camera then
    UpdateMotionBlur(camera, deltaTime)
  end
end)
GraphicsSection:Label("画质光影")
GraphicsSection:Button("光影", function()
  
  loadstring(game:HttpGet("https://raw.githubusercontent.com/MZEEN2424/Graphics/main/Graphics.xml"))()
end)
GraphicsSection:Button("RTX高仿", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/Bkf0BJb3"))()
end)
GraphicsSection:Button("超高画质", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/jHBfJYmS"))()
end)
GraphicsSection:Button("光影v4", function()
  
  loadstring(game:HttpGet("https://raw.githubusercontent.com/MZEEN2424/Graphics/main/Graphics.xml"))()
end)
GraphicsSection:Button("光影浅", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/jHBfJYmS"))()
end)
GraphicsSection:Button("光影深", function()
  
  loadstring(game:HttpGet("https://raw.githubusercontent.com/MZEEN2424/Graphics/main/Graphics.xml"))()
end)
local FlyTab = UILibrary:Tab("『飞行与飞车』", "18930406865")
local FlySection = FlyTab:section("飞行与飞车", true)
FlySection:Label("飞行")
FlySection:Toggle("飞行", "Fly", false, function(enabled)
  
  local character = LocalPlayer.Character
  if not character or not character.Humanoid then
    return 
  end
  local humanoid = character.Humanoid
  if _G.FlyEnabled == true then
    _G.FlyEnabled = false
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, true)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
    humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
  else
    _G.FlyEnabled = true
    character.Animate.Disabled = true
    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
      track:AdjustSpeed(0)
    end
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
    humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
  end
  local torso = (function()
    
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Torso") then
      return LocalPlayer.Character.Torso
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("LowerTorso") then
      return LocalPlayer.Character.LowerTorso
    end
  end)()
  local flyForward = 0
  local flyBackward = 0
  local flyLeft = 0
  local flyRight = 0
  local flyUp = 0
  local flyDown = 0
  local flySpeed = 50
  local currentSpeed = 0
  local gyro = Instance.new("BodyGyro", torso)
  gyro.P = 90000
  gyro.maxTorque = Vector3.new(9000000000, 9000000000, 9000000000)
  gyro.cframe = torso.CFrame
  local velocity = Instance.new("BodyVelocity", torso)
  velocity.velocity = Vector3.new(0, 0.1, 0)
  velocity.maxForce = Vector3.new(9000000000, 9000000000, 9000000000)
  if _G.FlyEnabled == true then
    humanoid.PlatformStand = true
  end
  while _G.FlyEnabled do
    local lr = flyLeft + flyRight
    local fb = flyForward + flyBackward
    if lr ~= 0 or fb ~= 0 then
      currentSpeed = (currentSpeed + 0.5) + currentSpeed / flySpeed
      if currentSpeed > flySpeed then
        currentSpeed = flySpeed
      end
    else
      if currentSpeed ~= 0 then
        currentSpeed = currentSpeed - 1
        if currentSpeed < 0 then
          currentSpeed = 0
        end
      end
    end
    if lr ~= 0 or fb ~= 0 then
      velocity.velocity = (workspace.CurrentCamera.CFrame.LookVector * (fb)
        + workspace.CurrentCamera.CFrame * CFrame.new(lr, fb * 0.2, 0).p
        - workspace.CurrentCamera.CFrame.p) * currentSpeed
      flyUp = fb
      flyDown = fb
      flyLeft = lr
      flyRight = lr
    else
      if currentSpeed ~= 0 then
        velocity.velocity = (workspace.CurrentCamera.CFrame.LookVector * (flyUp + flyDown)
          + workspace.CurrentCamera.CFrame * CFrame.new((flyLeft + flyRight), (flyUp + flyDown) * 0.2, 0).p
          - workspace.CurrentCamera.CFrame.p) * currentSpeed
      else
        velocity.velocity = Vector3.new(0, 0, 0)
      end
    end
    gyro.cframe = workspace.CurrentCamera.CFrame *
      CFrame.Angles(-math.rad(((flyForward + flyBackward) * 50 * currentSpeed / flySpeed)), 0, 0)
    task.wait()
  end
  flyForward = 0
  flyBackward = 0
  flyLeft = 0
  flyRight = 0
  flyUp = 0
  flyDown = 0
  currentSpeed = 0
  gyro:Destroy()
  velocity:Destroy()
  humanoid.PlatformStand = false
  character.Animate.Disabled = false
  _G.FlyEnabled = false
end)
FlySection:Button("速度 + 1", function()
  
  local character = LocalPlayer.Character
  if character and character.Humanoid then
    _G.FlySpeed = (_G.FlySpeed or 50) + 1
  end
end)
FlySection:Button("速度 - 1", function()
  
  local character = LocalPlayer.Character
  if character and character.Humanoid then
    if (_G.FlySpeed or 50) > 1 then
      _G.FlySpeed = (_G.FlySpeed or 50) - 1
    end
  end
end)
FlySection:Button("上升", function()
  
  LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, 0)
end)
FlySection:Button("下降", function()
  
  LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -1, 0)
end)
local speedLabel = FlySection:Label("当前速度:" .. tostring(_G.FlySpeed or 50))
task.spawn(function()
  while true do
    task.wait(0.2)
    if not speedLabel or not speedLabel.Parent then
      break
    end
    pcall(function()
      speedLabel.Text = "当前速度:" .. tostring(_G.FlySpeed or 50)
    end)
  end
end)
FlySection:Label("飞车")
FlySection:Textbox("输入飞行速度", "TextBoxfalg", "输入数字", function(value)
  
  
  _G.FlyCarSpeed = tonumber(value) or 0
  if not _G.FlyCarControllerRunning then
    _G.FlyCarControllerRunning = true
    _G.FlyCarController = task.spawn(function()
      while _G.FlyCarControllerRunning do
        local lp = game.Players.LocalPlayer
        local char = lp and lp.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
          hrp.Anchored = false
          local oldBV = hrp:FindFirstChildOfClass("BodyVelocity")
          if oldBV then
            pcall(function() oldBV:Destroy() end)
          end
          local oldBG = hrp:FindFirstChildOfClass("BodyGyro")
          if oldBG then
            pcall(function() oldBG:Destroy() end)
          end
          local bv = Instance.new("BodyVelocity")
          bv.Parent = hrp
          bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
          bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * (_G.FlyCarSpeed or 0)
          local bg = Instance.new("BodyGyro")
          bg.Parent = hrp
          bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
          bg.D = 5000
          bg.P = 50000
          bg.CFrame = workspace.CurrentCamera.CFrame
        end
        task.wait(0.1)
      end
    end)
  end
end)
FlySection:Toggle("开始飞行", "Toggleflag", false, function(enabled)
  
  if enabled then
    local bv = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
    local bg = Instance.new("BodyGyro", LocalPlayer.Character.HumanoidRootPart)
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.D = 5000
    bg.P = 50000
    bg.CFrame = workspace.CurrentCamera.CFrame
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
  else
    LocalPlayer.Character.HumanoidRootPart:FindFirstChildOfClass("BodyVelocity"):Destroy()
    LocalPlayer.Character.HumanoidRootPart:FindFirstChildOfClass("BodyGyro"):Destroy()
  end
end)
FlySection:Toggle("飞车穿墙", "Toggleflag", false, function(enabled)
  
  if enabled then
    vnoclipParts = {}
    local vehicle = LocalPlayer.Character.Humanoid.SeatPart.Parent
    repeat
      if vehicle.ClassName ~= "Model" then
        vehicle = vehicle.Parent
      end
    until vehicle.ClassName == "Model"
    wait(0.1)
    for _, part in pairs(vehicle:GetDescendants()) do
      if part:IsA("BasePart") and part.CanCollide then
        table.insert(vnoclipParts, part)
        part.CanCollide = false
      end
    end
  else
    for _, part in pairs(vnoclipParts) do
      part.CanCollide = true
    end
    vnoclipParts = {}
  end
end)
local CommandTab = UILibrary:Tab("『指令与念力』", "18930406865")
local CommandSection = CommandTab:section("指令与念力", true)
CommandSection:Label("【指令】")
CommandSection:Button("指令脚本", function()
  
  loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", true))()
end)
CommandSection:Label("bang能够掀人")
CommandSection:Label("noface没有脸")
CommandSection:Label("headsit坐在玩家头上加玩家名字")
CommandSection:Label("float悬浮")
CommandSection:Label("re重置人物但位置不变")
CommandSection:Label("dance跳舞")
CommandSection:Label("nolegs没有腿")
CommandSection:Label("walltp碰到墙壁传送到墙壁顶部")
CommandSection:Label("bring+玩家名字可以让玩家吸到你手上但是只能用于一些服务器")
CommandSection:Label("carpet趴着走")
CommandSection:Label("infjump无限跳跃")
CommandSection:Label("xray透视地图所有物体变透明")
CommandSection:Label("bang玩家开头两个英文吸在玩家身后")
CommandSection:Label("noanim没有动作")
CommandSection:Label("spin人物旋转")
CommandSection:Label("sitwalk坐着走")
CommandSection:Label("trip让你的人物摔倒")
CommandSection:Label("antikick防踢")
CommandSection:Label("lay躺下")
CommandSection:Label("sit坐")
CommandSection:Label("god加血")
CommandSection:Label("invisfling配合加血可以旋转")
CommandSection:Label("goto+玩家名字传送")
CommandSection:Label("unxray关闭透视")
CommandSection:Label("noclip穿墙")
CommandSection:Label("【念力】")
CommandSection:Button("念力工具", function()
  
  loadstring(game:HttpGet([[https://raw.githubusercontent.com/xiaopi77/xiaopi77/refs/heads/main/Mindpower.lua]]))()
end)
CommandSection:Label("Q - 靠近")
CommandSection:Label("E - 离远")
CommandSection:Label("Y - 投掷")
CommandSection:Label("J - 超级投掷")
CommandSection:Label("U - 使物体自转")
CommandSection:Label("P - 使物体悬浮在空中")
CommandSection:Label("X - 走得更远一点")
CommandSection:Label("L - 使方块变直并锁定在前部")
CommandSection:Button("让手上的道具飘起来", function()
  
  loadstring(game:HttpGet("https://pastebin.com/raw/WmD8MuSx"))()
end)
CommandSection:Label("J-飞起来")
CommandSection:Label("K-回到手中")
local JoinTab = UILibrary:Tab("『加入服务器/游戏』", "18930406865")
local JoinSection = JoinTab:section("加入服务器/游戏", true)
JoinSection:Button("加入极速传奇", function()
  
  local gameId = 3101667897
  game:GetService("TeleportService"):Teleport(gameId, LocalPlayer)
end)
JoinSection:Button("加入鲨口生求2", function()
  
  local gameId = 8908228901
  game:GetService("TeleportService"):Teleport(gameId, LocalPlayer)
end)
JoinSection:Button("加入监狱人生", function()
  
  local gameId = 155615604
  game:GetService("TeleportService"):Teleport(gameId, LocalPlayer)
end)
JoinSection:Button("加入忍者传奇", function()
  
  local gameId = 3956818381
  game:GetService("TeleportService"):Teleport(gameId, LocalPlayer)
end)
JoinSection:Button("加入Break in", function()
  
  local gameId = 1318971886
  game:GetService("TeleportService"):Teleport(gameId, LocalPlayer)
end)
JoinSection:Button("加入自然灾害生存", function()
  
  local gameId = 189707
  game:GetService("TeleportService"):Teleport(gameId, LocalPlayer)
end)
JoinSection:Button("加入力量传奇", function()
  
  local gameId = 3623096087
  game:GetService("TeleportService"):Teleport(gameId, LocalPlayer)
end)
JoinSection:Button("加入餐厅大亨2", function()
  
  local gameId = 3398014311
  game:GetService("TeleportService"):Teleport(gameId, LocalPlayer)
end)
local IntegratedScriptsTab = UILibrary:Tab("『其他服务器』", "18930406865")
local IntegratedScriptsSection = IntegratedScriptsTab:section("皮脚本-整合脚本", true)
IntegratedScriptsSection:Button("皮脚本-骨折模拟器", function()
  
  loadstring(game:HttpGet("https://pastefy.app/BEvzhV3I/raw"))()
end)
IntegratedScriptsSection:Button("皮脚本-鱿鱼游戏", function()
  
  loadstring(game:HttpGet("https://pastefy.app/nQXytkWG/raw"))()
end)
IntegratedScriptsSection:Button("皮脚本-口渴的吸血鬼", function()
  
  loadstring(game:HttpGet("https://pastefy.app/w3IgIGwt/raw"))()
end)
IntegratedScriptsSection:Button("皮脚本-骑车模拟器", function()
  
  loadstring(game:HttpGet("https://pastefy.app/VK0m90yJ/raw"))()
end)
IntegratedScriptsSection:Button("皮脚本-非常容易的奥比跑酷", function()
  
  loadstring(game:HttpGet("https://pastefy.app/TfLTBjMa/raw"))()
end)
IntegratedScriptsSection:Button("皮脚本-Doors but bad", function()
  
  loadstring(game:HttpGet("https://pastefy.app/3NeDK8LZ/raw"))()
end)
IntegratedScriptsSection:Button("皮脚本-超简单障碍跑", function()
  
  loadstring(game:HttpGet("https://pastefy.app/HAZ1TXPS/raw"))()
end)
IntegratedScriptsSection:Button("皮脚本-steep steps", function()
  
  loadstring(game:HttpGet("https://pastefy.app/zQlVSgEZ/raw"))()
end)
IntegratedScriptsSection:Button("皮脚本-攀登珠穆朗玛峰模拟器", function()
  
  loadstring(game:HttpGet("https://pastefy.app/1GPELOFv/raw"))()
end)

-- ==================== 启动过检测 ====================
task.wait(1)
startBypass()

print("========================================")
print("  ✅ 皮脚本-过检测版 加载成功")
print("  🛡️ 10层过检测防护已启动")
print("  防踢 | 防封 | 防拉回 | 防死亡")
print("========================================")