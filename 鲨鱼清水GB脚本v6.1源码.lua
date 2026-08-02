game:GetService("StarterGui"):SetCore("SendNotification", { 
	Title = "鲨鱼清水GB脚本v6.1";
	Text = "加载完成";
	Icon = "rbxassetid://14250466898"})
Duration = 10;

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local debugMode = false

local AnimationController = {
    ActiveButtons = {},
    DefaultAnimations = {},
    Character = nil,
    Humanoid = nil,
    Animator = nil,
    Gui = nil,
    ScrollContainer = nil,
    SideFrame = nil,
    FunctionFrame = nil,
    OtherFrame = nil,
    IsClosed = false,
    IsInitialized = false,
    CannonHighlightEnabled = false,
    CannonHighlights = {},
    FactionDropdown = nil,
    AntiKickEnabled = false,
    AntiKickOriginal = nil
}

AnimationController.MainButtonConfigs = {
	{
    Name = "远古ZAPPER动画",
    IdleId = "12333488814",
    WalkId = "12333490576",
    Priority = Enum.AnimationPriority.Action2,
    Callback = function(state)
        local buttonName = "远古ZAPPER动画"
        local buttonData = AnimationController.ActiveButtons[buttonName]
        
        if state then
            if not buttonData.Tracks.Effect then
                local anim = Instance.new("Animation")
                anim.AnimationId = "rbxassetid://12638401607"
                buttonData.Tracks.Effect = AnimationController.Animator:LoadAnimation(anim)
                buttonData.Tracks.Effect.Priority = Enum.AnimationPriority.Action3
            end
            buttonData.Tracks.Effect:Play()
        else
            if buttonData.Tracks.Effect and buttonData.Tracks.Effect.IsPlaying then
                buttonData.Tracks.Effect:Stop()
            end
        end
    end
},
{
        Name = "超人",
        IdleId = "123279433658792",
        WalkId = "123279433658792",
        Priority = Enum.AnimationPriority.Action3,
        Callback = function(state) 
            if state then
                AnimationController.Humanoid.WalkSpeed = 50
            else
                AnimationController.Humanoid.WalkSpeed = 16
            end
        end
    },

    {
        Name = "ZAPPER动画",
        IdleId = "14498563473",
        WalkId = "14498289874",
        Priority = Enum.AnimationPriority.Action3,
        Callback = function(state) end
    },
   {
    Name = "拳击手",
    IdleId = "124381258015151",
    WalkId = "127477273497271",
    Priority = Enum.AnimationPriority.Action3,
    Callback = function(state)
        if not AnimationController.ActiveButtons["糖果叔叔（无头骑士）"] then
            AnimationController.ActiveButtons["糖果叔叔（无头骑士）"] = {
                Music = nil,
                IsPlaying = false
            }
        end

        local controller = AnimationController.ActiveButtons["糖果叔叔（无头骑士）"]

        if state then
            if not controller.Music then
			end
            controller.IsPlaying = true
            AnimationController.Humanoid.WalkSpeed = 17
            
            controller.IsActive = true
            controller.CanClick = true
            controller.CurrentTrack = nil
            controller.TouchConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if controller.IsActive and not gameProcessed and controller.CanClick then
                    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                        controller.CanClick = false
                        local randomAnim = math.random(1, 2) == 1 and "rbxassetid://100609705099226" or "rbxassetid://137400696654354"

                        local anim = Instance.new("Animation")
                        anim.AnimationId = randomAnim
                        controller.CurrentTrack = AnimationController.Animator:LoadAnimation(anim)
                        controller.CurrentTrack.Priority = Enum.AnimationPriority.Action4
                        controller.CurrentTrack:Play()
                        
                        controller.CurrentTrack.Stopped:Connect(function()
                            anim:Destroy()
                            controller.CurrentTrack = nil
                            controller.CanClick = true
                        end)
                    end
                end
            end)
            controller.DeathConnection = AnimationController.Humanoid.Died:Connect(function()
                if controller.CurrentTrack then
                    controller.CurrentTrack:Stop()
                end
                if controller.Music then
                    controller.Music:Stop()
                end
            end)
            
        else
            if controller.Music then
                controller.Music:Stop()
                controller.Music:Destroy()
                controller.Music = nil
                controller.IsPlaying = false
            end
            controller.IsActive = false
            AnimationController.Humanoid.WalkSpeed = 16
            if controller.TouchConnection then
                controller.TouchConnection:Disconnect()
                controller.TouchConnection = nil
            end
            
            if controller.DeathConnection then
                controller.DeathConnection:Disconnect()
                controller.DeathConnection = nil
            end
            if controller.CurrentTrack then
                controller.CurrentTrack:Stop()
                controller.CurrentTrack = nil
            end
        end
    end
},
	{
    Name = "德古拉",
    IdleId = "14970033333",
    WalkId = "15486477524",
    Priority = Enum.AnimationPriority.Action3,
    Callback = function(state)
        if not AnimationController.ActiveButtons["糖果叔叔（无头骑士）"] then
            AnimationController.ActiveButtons["糖果叔叔（无头骑士）"] = {
                Music = nil,
                IsPlaying = false
            }
        end

        local controller = AnimationController.ActiveButtons["糖果叔叔（无头骑士）"]

        if state then
            if not controller.Music then
                controller.Music = Instance.new("Sound")
                controller.Music.SoundId = "rbxassetid://0"
                controller.Music.Looped = true
                controller.Music.Volume = 5
                controller.Music.Parent = AnimationController.Character:FindFirstChild("Head") or AnimationController.Character
            end
            controller.Music:Play()
            controller.IsPlaying = true
            AnimationController.Humanoid.WalkSpeed = 16
            
            controller.IsActive = true
            controller.CanClick = true
            controller.CurrentTrack = nil
            controller.TouchConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if controller.IsActive and not gameProcessed and controller.CanClick then
                    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                        controller.CanClick = false
                        local randomAnim = math.random(1, 2) == 1 and "rbxassetid://86633946320798" or "rbxassetid://89397834398238"

                        local anim = Instance.new("Animation")
                        anim.AnimationId = randomAnim
                        controller.CurrentTrack = AnimationController.Animator:LoadAnimation(anim)
                        controller.CurrentTrack.Priority = Enum.AnimationPriority.Action4
                        controller.CurrentTrack:Play()
                        
                        controller.CurrentTrack.Stopped:Connect(function()
                            anim:Destroy()
                            controller.CurrentTrack = nil
                            controller.CanClick = true
                        end)
                    end
                end
            end)
            controller.DeathConnection = AnimationController.Humanoid.Died:Connect(function()
                if controller.CurrentTrack then
                    controller.CurrentTrack:Stop()
                end
                if controller.Music then
                    controller.Music:Stop()
                end
            end)
            
        else
            if controller.Music then
                controller.Music:Stop()
                controller.Music:Destroy()
                controller.Music = nil
                controller.IsPlaying = false
            end
            controller.IsActive = false
            AnimationController.Humanoid.WalkSpeed = 16
            if controller.TouchConnection then
                controller.TouchConnection:Disconnect()
                controller.TouchConnection = nil
            end
            
            if controller.DeathConnection then
                controller.DeathConnection:Disconnect()
                controller.DeathConnection = nil
            end
            if controller.CurrentTrack then
                controller.CurrentTrack:Stop()
                controller.CurrentTrack = nil
            end
        end
    end
},
	{
        Name = "孤勇者",
        IdleId = "111210841378590",
        WalkId = "139186204185685",
        Priority = Enum.AnimationPriority.Action3,
        Callback = function(state) 
            if state then
                AnimationController.Humanoid.WalkSpeed = 5
            else
                AnimationController.Humanoid.WalkSpeed = 16
            end
        end
    },
    {
        Name = "ZAPPER特效",
        PlayOnceId = "14499470197",
        Priority = Enum.AnimationPriority.Action4,
        Callback = function(state) end
    },

    {
        Name = "装死",
        PlayOnceId = "89945348540089",
        Priority = Enum.AnimationPriority.Action4,
        Callback = function(state) end
    },
    {
        Name = "山伯乐吃播",
        PlayOnceId = "18339432914",
        StopAfter = 10,
        Priority = Enum.AnimationPriority.Action4,
        Callback = function(state) end
    },
	{
        Name = "是多绝望的人能跳出这个舞步",
        PlayOnceId = "14860627011",
        StopAfter = 20,
        Priority = Enum.AnimationPriority.Action4,
        Callback = function(state) end
    },
	    {
    Name = "转枪",
    PlayOnceId = "15827239870",
    Priority = Enum.AnimationPriority.Action3,
    Callback = function(state) 
        if state then
            local buttonName = "转枪"
            local buttonData = AnimationController.ActiveButtons[buttonName]
            
            if buttonData and buttonData.Tracks.PlayOnce then
                local function playLoop()
                    while buttonData and buttonData.IsActive do
                        buttonData.Tracks.PlayOnce:Play()
                        task.wait(0.73)
                    end
                end
                
                task.spawn(playLoop)
            end
        end
    end
},
{
    Name = "老大肘击",
    PlayOnceId = "15345113937",
    Priority = Enum.AnimationPriority.Action4,
    Callback = function(state) 
        if state then
            local buttonName = "老大肘击"
            local buttonData = AnimationController.ActiveButtons[buttonName]
            
            if buttonData and buttonData.Tracks.PlayOnce then
                local function playLoop()
                    while buttonData and buttonData.IsActive do
                        buttonData.Tracks.PlayOnce:Play()
                        task.wait(0.6)
                    end
                end
                
                task.spawn(playLoop)
            end
        end
    end
},
{
    Name = "真正的光环（超快挥刀）",
    PlayOnceId = "12591938344",
    Priority = Enum.AnimationPriority.Action4,
    Callback = function(state) 
        if state then
            local buttonName = "真正的光环（超快挥刀）"
            local buttonData = AnimationController.ActiveButtons[buttonName]
            
            if buttonData and buttonData.Tracks.PlayOnce then
                local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                local humanoid = character:WaitForChild("Humanoid")
                local rootPart = character:WaitForChild("HumanoidRootPart")
                local rotationSpeed = 1440
                local isRotating = true
                local function playLoop()
                    while buttonData and buttonData.IsActive do
                        buttonData.Tracks.PlayOnce:Play()
                        task.wait(0.1)
                    end
                    isRotating = false 
                end
                local function rotateCharacter()
                    while isRotating and humanoid and rootPart do
                        local deltaTime = task.wait()
                        rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(rotationSpeed * deltaTime), 0)
                    end
                end
                task.spawn(playLoop)
                task.spawn(rotateCharacter)
            end
        else
        
        end
    end
},
    {
        Name = "红眼",
        IdleId = "12581784105",
        WalkId = "12581785298",
        Priority = Enum.AnimationPriority.Action3,
        Callback = function(state) 
            if state then
                AnimationController.Humanoid.WalkSpeed = 50
            else
                AnimationController.Humanoid.WalkSpeed = 16
            end
        end
    },
    {
        Name = "山伯乐动画",
        IdleId = "12333488814",
        WalkId = "14463730540",
        Priority = Enum.AnimationPriority.Action3,
        Callback = function(state) end
    },
    {
        Name = "提灯人",
        IdleId = "14678879479",
        WalkId = "14678880308",
        Priority = Enum.AnimationPriority.Action3,
        Callback = function(state) end
    },
    {
        Name = "无头士兵（美国）",
        IdleId = "107080941320600",
        WalkId = "74764025513892",
        Priority = Enum.AnimationPriority.Action3,
        Callback = function(state) end
    },
    {
        Name = "胸甲僵尸",
        IdleId = "87579228279296",
        WalkId = "102081698785465",
        Priority = Enum.AnimationPriority.Action3,
        Callback = function(state) end
    },
    {
        Name = "骑兵动画（刺）",
        Callback = function(state) end
    },
    {
        Name = "远古默认动画",
        IdleId = "180435571",
        WalkId = "180426354",
        Priority = Enum.AnimationPriority.Idle,
        Callback = function(state) end
    },
	{
        Name = "老山伯乐动画",
        IdleId = "12333488814",
        WalkId = "12333490857",
        Priority = Enum.AnimationPriority.Idle,
        Callback = function(state) end
    },
    {
        Name = "滑膛枪冲锋",
        IdleId = "14292935158",
        WalkId = "14292937831",
        Priority = Enum.AnimationPriority.Action3,
        Callback = function(state) 
            if state then
                AnimationController.Humanoid.WalkSpeed = 24
            else
                AnimationController.Humanoid.WalkSpeed = 16
            end
        end
    },
    {
        Name = "重剑冲锋",
        IdleId = "14284611111",
        WalkId = "17406602570",
        Priority = Enum.AnimationPriority.Action3,
        Callback = function(state) 
            if state then
                AnimationController.Humanoid.WalkSpeed = 24
            else
                AnimationController.Humanoid.WalkSpeed = 16
            end
        end
    },
    {
        Name = "冲锋",
        IdleId = "14284611111",
        WalkId = "14284623849",
        Priority = Enum.AnimationPriority.Idle,
        Callback = function(state) 
            if state then
                AnimationController.Humanoid.WalkSpeed = 24
            else
                AnimationController.Humanoid.WalkSpeed = 16
            end
        end
    },
    {
        Name = "假残血",
        IdleId = "14970034680",
        WalkId = "15530089342",
        Priority = Enum.AnimationPriority.Idle,
        Callback = function(state) end
    },
    {
        Name = "自爆",
        IdleId = "13211198049",
        WalkId = "13211207597",
        Priority = Enum.AnimationPriority.Action3,
        Callback = function(state) end
    },
    {
        Name = "爬尸",
        IdleId = "13726632691",
        WalkId = "13726634549",
        SitId = "130515356351734",
        Priority = Enum.AnimationPriority.Action3,
        Callback = function(state) end
    },
	{
    Name = "糖果叔叔（无头骑士）",
    IdleId = "13936362530",
    WalkId = "13936362530",
    Priority = Enum.AnimationPriority.Action3,
    Callback = function(state)
        if not AnimationController.ActiveButtons["糖果叔叔（无头骑士）"] then
            AnimationController.ActiveButtons["糖果叔叔（无头骑士）"] = {
                Music = nil,
                IsPlaying = false
            }
        end

        local controller = AnimationController.ActiveButtons["糖果叔叔（无头骑士）"]

        if state then
            if not controller.Music then
                controller.Music = Instance.new("Sound")
                controller.Music.SoundId = "rbxassetid://1836635087"
                controller.Music.Looped = true
                controller.Music.Volume = 5
                controller.Music.Parent = AnimationController.Character:FindFirstChild("Head") or AnimationController.Character
            end
            controller.Music:Play()
            controller.IsPlaying = true
            AnimationController.Humanoid.WalkSpeed = 70
            
            controller.IsActive = true
            controller.CanClick = true
            controller.CurrentTrack = nil
            controller.TouchConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if controller.IsActive and not gameProcessed and controller.CanClick then
                    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                        controller.CanClick = false
                        local randomAnim = math.random(1, 2) == 1 and "rbxassetid://13936377814" or "rbxassetid://13936368936"

                        local anim = Instance.new("Animation")
                        anim.AnimationId = randomAnim
                        controller.CurrentTrack = AnimationController.Animator:LoadAnimation(anim)
                        controller.CurrentTrack.Priority = Enum.AnimationPriority.Action4
                        controller.CurrentTrack:Play()
                        
                        controller.CurrentTrack.Stopped:Connect(function()
                            anim:Destroy()
                            controller.CurrentTrack = nil
                            controller.CanClick = true
                        end)
                    end
                end
            end)
            controller.DeathConnection = AnimationController.Humanoid.Died:Connect(function()
                if controller.CurrentTrack then
                    controller.CurrentTrack:Stop()
                end
                if controller.Music then
                    controller.Music:Stop()
                end
            end)
            
        else
            if controller.Music then
                controller.Music:Stop()
                controller.Music:Destroy()
                controller.Music = nil
                controller.IsPlaying = false
            end
            controller.IsActive = false
            AnimationController.Humanoid.WalkSpeed = 16
            if controller.TouchConnection then
                controller.TouchConnection:Disconnect()
                controller.TouchConnection = nil
            end
            
            if controller.DeathConnection then
                controller.DeathConnection:Disconnect()
                controller.DeathConnection = nil
            end
            if controller.CurrentTrack then
                controller.CurrentTrack:Stop()
                controller.CurrentTrack = nil
            end
        end
    end
}
}

AnimationController.SideButtonConfigs = {
	{
    Name = "假刺刀",
    IdleId = "12333492041",
    WalkId = "12333492041",
    Priority = Enum.AnimationPriority.Action3,
    Callback = function(state)
        if not AnimationController.ActiveButtons["假刺刀"] then
            AnimationController.ActiveButtons["假刺刀"] = {
                Music = nil,
                IsPlaying = false
            }
        end

        local controller = AnimationController.ActiveButtons["假刺刀"]

        if state then
            if not controller.Music then
                controller.Music = Instance.new("Sound")
                controller.Music.SoundId = "rbxassetid://0"
                controller.Music.Looped = true
                controller.Music.Volume = 5
                controller.Music.Parent = AnimationController.Character:FindFirstChild("Head") or AnimationController.Character
            end
            controller.Music:Play()
            controller.IsPlaying = true
            AnimationController.Humanoid.WalkSpeed = 17
            controller.IsActive = true
            controller.CanClick = true
            controller.CurrentTrack = nil
            controller.TouchConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if controller.IsActive and not gameProcessed and controller.CanClick then
                    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                        controller.CanClick = false
                        local randomAnim = math.random(1, 2) == 1 and "rbxassetid://12333491302" or "rbxassetid://12807882732"
                        local anim = Instance.new("Animation")
                        anim.AnimationId = randomAnim
                        controller.CurrentTrack = AnimationController.Animator:LoadAnimation(anim)
                        controller.CurrentTrack.Priority = Enum.AnimationPriority.Action4
                        controller.CurrentTrack:Play()
                        
                        controller.CurrentTrack.Stopped:Connect(function()
                            anim:Destroy()
                            controller.CurrentTrack = nil
                            controller.CanClick = true
                        end)
                    end
                end
            end)
            controller.DeathConnection = AnimationController.Humanoid.Died:Connect(function()
                if controller.CurrentTrack then
                    controller.CurrentTrack:Stop()
                end
                if controller.Music then
                    controller.Music:Stop()
                end
            end)
            
        else
            if controller.Music then
                controller.Music:Stop()
                controller.Music:Destroy()
                controller.Music = nil
                controller.IsPlaying = false
            end
            controller.IsActive = false
            AnimationController.Humanoid.WalkSpeed = 16
            if controller.TouchConnection then
                controller.TouchConnection:Disconnect()
                controller.TouchConnection = nil
            end
            
            if controller.DeathConnection then
                controller.DeathConnection:Disconnect()
                controller.DeathConnection = nil
            end
            if controller.CurrentTrack then
                controller.CurrentTrack:Stop()
                controller.CurrentTrack = nil
            end
        end
    end
},
	{
        Name = "拿破仑背手",
        IdleId = "103557875332543",
        WalkId = "103557875332543",
        Priority = Enum.AnimationPriority.Action4,
	},
      
{
        Name = "寒冷",
        IdleId = "16863977222",
        WalkId = "16876434500",
        Priority = Enum.AnimationPriority.Action3,
        Callback = function(state) end
    },
    {
    Name = "吃神秘的东西",
    PlayOnceId = "16863982325",
    Priority = Enum.AnimationPriority.Action4,
    Callback = function(state)
        if state then
            local buttonName = "吃神秘的东西"
            local buttonData = AnimationController.ActiveButtons[buttonName]
            
            if buttonData and buttonData.Tracks.PlayOnce then
                buttonData.LoopTask = task.spawn(function()
                    while buttonData and buttonData.IsActive do
                        buttonData.Tracks.PlayOnce:Play()
                        buttonData.Tracks.PlayOnce:AdjustSpeed(0)
                        buttonData.Tracks.PlayOnce.TimePosition = 1.8
                        buttonData.Tracks.PlayOnce:AdjustSpeed(1)
                        task.wait(0.1)
                    end
                end)
            end
        else
            if buttonData and buttonData.LoopTask then
                task.cancel(buttonData.LoopTask)
                buttonData.LoopTask = nil
                if buttonData.Tracks.PlayOnce then
                    buttonData.Tracks.PlayOnce:Stop()
                end
            end
        end
    end
},
    {
        Name = "胸甲僵尸动画2",
        IdleId = "82800474630427",
        WalkId = "118210337289087",
        Priority = Enum.AnimationPriority.Action3,
        Callback = function(state) end
    },
	{
    Name = "飞", 
    PlayOnceId = "110087359963835", 
    Priority = Enum.AnimationPriority.Action4,
    Callback = function(state)
        local buttonName = "飞"
        local buttonData = AnimationController.ActiveButtons[buttonName]
        
        if state then
            if buttonData and buttonData.Tracks.PlayOnce then
                if buttonData.LoopTask then
                    task.cancel(buttonData.LoopTask)
                end
                buttonData.LoopTask = task.spawn(function()
                    while buttonData and buttonData.IsActive do
                        buttonData.Tracks.PlayOnce:Play()
                        buttonData.Tracks.PlayOnce.Looped = true 
                        task.wait(buttonData.Tracks.PlayOnce.Length)
                    end
                end)
            end
        else 
            if buttonData then
                if buttonData.LoopTask then
                    task.cancel(buttonData.LoopTask)
                end
                if buttonData.Tracks.PlayOnce then
                    buttonData.Tracks.PlayOnce:Stop()
                end
            end
        end
    end
},
    {
        Name = "老不死的布吕歇尔",
        Priority = Enum.AnimationPriority.Action4,
        Callback = function(state)
            if state then
                local buttonName = "老不死的布吕歇尔"
                local buttonData = AnimationController.ActiveButtons[buttonName]
                
                for _, track in pairs(AnimationController.Humanoid:GetPlayingAnimationTracks()) do
                    track:Stop()
                end
                
                local anim1 = Instance.new("Animation")
                anim1.AnimationId = "rbxassetid://15603033178"
                local track1 = AnimationController.Animator:LoadAnimation(anim1)
                track1.Priority = Enum.AnimationPriority.Action4
                
                local anim2 = Instance.new("Animation")
                anim2.AnimationId = "rbxassetid://16168689655"
                local track2 = AnimationController.Animator:LoadAnimation(anim2)
                track2.Priority = Enum.AnimationPriority.Action4
                
                local anim3 = Instance.new("Animation")
                anim3.AnimationId = "rbxassetid://15680560478"
                local track3 = AnimationController.Animator:LoadAnimation(anim3)
                track3.Priority = Enum.AnimationPriority.Action4
                
                local anim4 = Instance.new("Animation")
                anim4.AnimationId = "rbxassetid://15688743558"
                local track4 = AnimationController.Animator:LoadAnimation(anim4)
                track4.Priority = Enum.AnimationPriority.Action4
                
                local anim5 = Instance.new("Animation")
                anim5.AnimationId = "rbxassetid://15637342030"
                local track5 = AnimationController.Animator:LoadAnimation(anim5)
                track5.Priority = Enum.AnimationPriority.Action4
                
                buttonData.Tracks = {
                    track1, track2, track3, track4, track5
                }
                
                local function playSequence()
                    if not buttonData.IsActive then return end
                    
                    track1:Play()
                    track1.Stopped:Wait()
                    
                    if not buttonData.IsActive then return end
                    track2:Play()
                    track2.Stopped:Wait()
                    
                    if not buttonData.IsActive then return end
                    track3:Play()
                    task.wait(3)
                    if track3.IsPlaying then track3:Stop() end
                    
                    if not buttonData.IsActive then return end
                    track4:Play()
                    track4.Stopped:Wait()
                    
                    if not buttonData.IsActive then return end
                    track3:Play()
                    task.wait(3)
                    if track3.IsPlaying then track3:Stop() end
                    
                    if not buttonData.IsActive then return end
                    track5:Play()
                    track5.Stopped:Wait()
                    
                    if buttonData and buttonData.IsActive then
                        buttonData.IsActive = false
                        if buttonData.Instance then
                        buttonData.Instance.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                        end
                        AnimationController:RestoreDefaults()
                    end
                end
                
                task.spawn(playSequence)
            else
                local buttonName = "老不死的布吕歇尔"
                local buttonData = AnimationController.ActiveButtons[buttonName]
                
                if buttonData then
                    for _, track in pairs(buttonData.Tracks or {}) do
                        if track then track:Stop() end
                    end
                    AnimationController:RestoreDefaults()
                end
            end
        end
    },
	{
        Name = "威灵顿",
        Priority = Enum.AnimationPriority.Action4,
        Callback = function(state)
            if state then
                local buttonName = "威灵顿"
                local buttonData = AnimationController.ActiveButtons[buttonName]
                
                for _, track in pairs(AnimationController.Humanoid:GetPlayingAnimationTracks()) do
                    track:Stop()
                end
                
                local anim1 = Instance.new("Animation")
                anim1.AnimationId = "rbxassetid://90133636590921"
                local track1 = AnimationController.Animator:LoadAnimation(anim1)
                track1.Priority = Enum.AnimationPriority.Action3
                
                local anim2 = Instance.new("Animation")
                anim2.AnimationId = "rbxassetid://88094888547281"
                local track2 = AnimationController.Animator:LoadAnimation(anim2)
                track2.Priority = Enum.AnimationPriority.Action3
                
                local anim3 = Instance.new("Animation")
                anim3.AnimationId = "rbxassetid://85843915546775"
                local track3 = AnimationController.Animator:LoadAnimation(anim3)
                track3.Priority = Enum.AnimationPriority.Action3
                
                local anim4 = Instance.new("Animation")
                anim4.AnimationId = "rbxassetid://120593550434546"
                local track4 = AnimationController.Animator:LoadAnimation(anim4)
                track4.Priority = Enum.AnimationPriority.Action3
                
                
                buttonData.Tracks = {
                    track1, track2, track3, track4
                }
                
                local function playSequence()
                    if not buttonData.IsActive then return end
                    
                    track1:Play()
                    track1.Stopped:Wait()
                    
                    if not buttonData.IsActive then return end
                    track2:Play()
                    track2.Stopped:Wait()
                    
                    if not buttonData.IsActive then return end
                    track3:Play()
                    task.wait(15)
                    if track3.IsPlaying then track3:Stop() end
                    
                    if not buttonData.IsActive then return end
                    track4:Play()
                    track4.Stopped:Wait()
                    
                    if buttonData and buttonData.IsActive then
                        buttonData.IsActive = false
                        if buttonData.Instance then
                        buttonData.Instance.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                        end
                        AnimationController:RestoreDefaults()
                    end
                end
                
                task.spawn(playSequence)
            else
                local buttonName = "威灵顿"
                local buttonData = AnimationController.ActiveButtons[buttonName]
                
                if buttonData then
                    for _, track in pairs(buttonData.Tracks or {}) do
                        if track then track:Stop() end
                    end
                    AnimationController:RestoreDefaults()
                end
            end
        end
    },
    {
        Name = "副官",
        Priority = Enum.AnimationPriority.Action4,
        Callback = function(state)
            if state then
                local buttonName = "副官"
                local buttonData = AnimationController.ActiveButtons[buttonName]
                for _, track in pairs(AnimationController.Humanoid:GetPlayingAnimationTracks()) do
                    track:Stop()
                end
                local anim1 = Instance.new("Animation")
                anim1.AnimationId = "rbxassetid://15603037116"
                local track1 = AnimationController.Animator:LoadAnimation(anim1)
                track1.Priority = Enum.AnimationPriority.Action4
                
                local anim2 = Instance.new("Animation")
                anim2.AnimationId = "rbxassetid://15622136729"
                local track2 = AnimationController.Animator:LoadAnimation(anim2)
                track2.Priority = Enum.AnimationPriority.Action4
                
                local anim3 = Instance.new("Animation")
                anim3.AnimationId = "rbxassetid://15688841016"
                local track3 = AnimationController.Animator:LoadAnimation(anim3)
                track3.Priority = Enum.AnimationPriority.Action4
                
                local anim4 = Instance.new("Animation")
                anim4.AnimationId = "rbxassetid://15637317651"
                local track4 = AnimationController.Animator:LoadAnimation(anim4)
                track4.Priority = Enum.AnimationPriority.Action4
                buttonData.Tracks = {
                    track1, track2, track3, track4
                }
                local function playSequence()
                    if not buttonData.IsActive then return end
                    track1:Play()
                    track1.Stopped:Wait()
                    if not buttonData.IsActive then return end
                    track2:Play()
                    track2.Stopped:Wait()
                    
                    if not buttonData.IsActive then return end
                    track3:Play()
                    task.wait(9)
                     if track3.IsPlaying then track3:Stop() end
                    
                    if not buttonData.IsActive then return end
                    track4:Play()
                    track4.Stopped:Wait()
                    
                    if buttonData and buttonData.IsActive then
                        buttonData.IsActive = false
                        if buttonData.Instance then
                            buttonData.Instance.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                        end
                        AnimationController:RestoreDefaults()
                    end
                end
                
                task.spawn(playSequence)
            else
                local buttonName = "副官"
                local buttonData = AnimationController.ActiveButtons[buttonName]
                
                if buttonData then
                    for _, track in pairs(buttonData.Tracks or {}) do
                        if track then track:Stop() end
                    end
                    AnimationController:RestoreDefaults()
                end
            end
        end
    },
    {
        Name = "耐咬王Barry",
        Priority = Enum.AnimationPriority.Action4,
        Callback = function(state)
            if state then
                local buttonName = "耐咬王Barry"
                local buttonData = AnimationController.ActiveButtons[buttonName]
                
                for _, track in pairs(AnimationController.Humanoid:GetPlayingAnimationTracks()) do
                    track:Stop()
                end
                
                local anim1 = Instance.new("Animation")
                anim1.AnimationId = "rbxassetid://14284371664"
                local track1 = AnimationController.Animator:LoadAnimation(anim1)
                track1.Priority = Enum.AnimationPriority.Action4
                
                local anim2 = Instance.new("Animation")
                anim2.AnimationId = "rbxassetid://14284387207"
                local track2 = AnimationController.Animator:LoadAnimation(anim2)
                track2.Priority = Enum.AnimationPriority.Action4
                
                local anim3 = Instance.new("Animation")
                anim3.AnimationId = "rbxassetid://14284382730"
                local track3 = AnimationController.Animator:LoadAnimation(anim3)
                track3.Priority = Enum.AnimationPriority.Action4
                
                local anim4 = Instance.new("Animation")
                anim4.AnimationId = "rbxassetid://14304936421"
                local track4 = AnimationController.Animator:LoadAnimation(anim4)
                track4.Priority = Enum.AnimationPriority.Action4
                
                buttonData.Tracks = {track1, track2, track3, track4}
                
                local function playSequence()
                    if not buttonData.IsActive then return end
                    track1:Play()
                    track1.Stopped:Wait()
                    
                    if not buttonData.IsActive then return end
                    track2:Play()
                    
                    local counter = 0
                    while counter < 10 and buttonData.IsActive do
                        task.wait(0.1)
                        counter = counter + 0.1
                    end
                    if track2.IsPlaying then track2:Stop() end
                    
                    if not buttonData.IsActive then return end
                    track3:Play()
                    track3.Stopped:Wait()
                    
                    if not buttonData.IsActive then return end
                    track2:Play(0, 1, -1)
                    
                    counter = 0
                    while counter < 3 and buttonData.IsActive do
                        task.wait(0.1)
                        counter = counter + 0.1
                    end
                    if track2.IsPlaying then track2:Stop() end
                    
                    if not buttonData.IsActive then return end
                    track4:Play()
                    track4.Stopped:Wait()
                    
                    if buttonData and buttonData.IsActive then
                        buttonData.IsActive = false
                        if buttonData.Instance then
                            buttonData.Instance.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                        end
                        AnimationController:RestoreDefaults()
                    end
                end
                
                task.spawn(playSequence)
            else
                local buttonName = "耐咬王Barry"
                local buttonData = AnimationController.ActiveButtons[buttonName]
                
                if buttonData then
                    for _, track in pairs(buttonData.Tracks or {}) do
                        if track then track:Stop() end
                    end
                    AnimationController:RestoreDefaults()
                end
            end
        end
    },
    {
        Name = "克劳福德",
        PlayOnceId = "77859967130018",
        Priority = Enum.AnimationPriority.Action4,
        Callback = function(state) end
    },
    {
        Name = "十字架使用",
        PlayOnceId = "15210536563",
        Priority = Enum.AnimationPriority.Action4,
        Callback = function(state) end
    },
    {
        Name = "被胸甲刺伤",
        Callback = function(state)
            if state then
                for _, track in pairs(AnimationController.Humanoid:GetPlayingAnimationTracks()) do
                    track:Stop()
                end
                
                local anim1 = Instance.new("Animation")
                anim1.AnimationId = "rbxassetid://121955221153387"
                local track1 = AnimationController.Animator:LoadAnimation(anim1)
                track1.Priority = Enum.AnimationPriority.Action4
                track1:Play()
                AnimationController.Humanoid.WalkSpeed = 0
                
                track1.Stopped:Connect(function()
                    local anim2 = Instance.new("Animation")
                    anim2.AnimationId = "rbxassetid://111210841378590"
                    local track2 = AnimationController.Animator:LoadAnimation(anim2)
                    track2.Priority = Enum.AnimationPriority.Action4
                    track2.Looped = false
                    track2:Play()
                    AnimationController.Humanoid.WalkSpeed = 0
                    wait(4)
                    AnimationController.Humanoid.WalkSpeed = 16

                    AnimationController.ActiveButtons["被胸甲刺伤"].Tracks.Loop = track2
                end)
            else
                for _, track in pairs(AnimationController.Humanoid:GetPlayingAnimationTracks()) do
                    track:Stop()
                end
                AnimationController:RestoreDefaults()
            end
        end
    },
    {
        Name = "雅各布",
        PlayOnceId = "12404717502",
        Priority = Enum.AnimationPriority.Action4,
        Callback = function(state) end
    },
    {
        Name = "僵尸王",
        PlayOnceId = "13408244121",
        Priority = Enum.AnimationPriority.Action4,
        Callback = function(state) end
    },
    {
        Name = "僵尸扒门",
        PlayOnceId = "15593727441",
        Priority = Enum.AnimationPriority.Action4,
        Callback = function(state) end
    },
    {
        Name = "骨折",
        Callback = function(state)
            if state then
                for _, track in pairs(AnimationController.Humanoid:GetPlayingAnimationTracks()) do
                    track:Stop()
                end
                
                local anim1 = Instance.new("Animation")
                anim1.AnimationId = "rbxassetid://12333490324"
                local track1 = AnimationController.Animator:LoadAnimation(anim1)
                track1.Priority = Enum.AnimationPriority.Action4
                track1:Play()
                AnimationController.Humanoid.WalkSpeed = 0
                
                track1.Stopped:Connect(function()
                    local anim2 = Instance.new("Animation")
                    anim2.AnimationId = "rbxassetid://12333489072"
                    local track2 = AnimationController.Animator:LoadAnimation(anim2)
                    track2.Priority = Enum.AnimationPriority.Action4
                    track2.Looped = false
                    track2:Play()
                    AnimationController.Humanoid.WalkSpeed = 0
                    wait(3)
                    AnimationController.Humanoid.WalkSpeed = 16
                    
                    AnimationController.ActiveButtons["骨折"].Tracks.Loop = track2
                end)
            else
                for _, track in pairs(AnimationController.Humanoid:GetPlayingAnimationTracks()) do
                    track:Stop()
                end
                AnimationController:RestoreDefaults()
            end
        end
    }
}

function AnimationController:PlayCavalryAnimation()
    for _, track in pairs(self.Humanoid:GetPlayingAnimationTracks()) do
        track:Stop()
    end
    
    local anim1 = Instance.new("Animation")
    anim1.AnimationId = "rbxassetid://105118183189738"
    local track1 = self.Animator:LoadAnimation(anim1)
    track1:Play()
    track1.Priority = Enum.AnimationPriority.Action4
    self.Humanoid.WalkSpeed = 1
    
    track1.Stopped:Wait()
    
    local anim2 = Instance.new("Animation")
    anim2.AnimationId = "rbxassetid://17406602570"
    local track2 = self.Animator:LoadAnimation(anim2)
    track2:Play()
    track2.Priority = Enum.AnimationPriority.Action4
    self.Humanoid.WalkSpeed = 28

    local stopTime = os.clock() + 5
    while os.clock() < stopTime and track2.IsPlaying do
        task.wait()
    end
    track2:Stop()
    self.Humanoid.WalkSpeed = 16
    
    local hasPlayer = false
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= Players.LocalPlayer and otherPlayer.Character then
            local distance = (otherPlayer.Character:GetPivot().Position - self.Character:GetPivot().Position).Magnitude
            if distance < 10 then
                hasPlayer = true
                break
            end
        end
    end
    
    local finalAnim = Instance.new("Animation")
    if hasPlayer then
        finalAnim.AnimationId = "rbxassetid://102984581737936"
    else
        finalAnim.AnimationId = "rbxassetid://139159672489901"
        self.Humanoid.WalkSpeed = 4
    end
    local finalTrack = self.Animator:LoadAnimation(finalAnim)
    finalTrack:Play()
    finalTrack.Priority = Enum.AnimationPriority.Action4
    
    finalTrack.Stopped:Wait()
    
    self:RestoreDefaults()
end

function AnimationController:ToggleCannonHighlights()
    self.CannonHighlightEnabled = not self.CannonHighlightEnabled
    
    local buttonName = "火炮物资透视"
    local buttonData = self.ActiveButtons[buttonName]
    if buttonData then
        buttonData.IsActive = self.CannonHighlightEnabled
        buttonData.Instance.BackgroundColor3 = buttonData.IsActive and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(80, 80, 80)
    end
    
    if self.CannonHighlightEnabled then
        self:CreateCannonHighlights()
    else
        self:RemoveCannonHighlights()
    end
end

function AnimationController:CreateCannonHighlights()
    self:RemoveCannonHighlights()
    
    local cannonSupplies = game.Workspace:FindFirstChild("Vardohus Fortress")
    if cannonSupplies then
        cannonSupplies = cannonSupplies:FindFirstChild("Modes")
        if cannonSupplies then
            cannonSupplies = cannonSupplies:FindFirstChild("Objective")
            if cannonSupplies then
                cannonSupplies = cannonSupplies:FindFirstChild("CannonSupplies")
            end
        end
    end
    
    if not cannonSupplies then return end
    
    for _, folder in ipairs(cannonSupplies:GetChildren()) do
        if folder:IsA("Folder") then
            local swab = folder:FindFirstChild("Swab")
            local roundshot = folder:FindFirstChild("12 lb. Roundshots")
            
            if swab then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(255, 215, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = swab
                table.insert(self.CannonHighlights, highlight)
            end
            
            if roundshot then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(255, 215, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = roundshot
                table.insert(self.CannonHighlights, highlight)
            end
        end
    end
end

function AnimationController:RemoveCannonHighlights()
    for _, highlight in ipairs(self.CannonHighlights) do
        if highlight and highlight.Parent then
            highlight:Destroy()
        end
    end
    self.CannonHighlights = {}
end

function AnimationController:ToggleAnimation(config, buttonData)
    buttonData.IsActive = not buttonData.IsActive
    buttonData.Instance.BackgroundColor3 = buttonData.IsActive and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(80, 80, 80)
    
    if buttonData.IsActive then
        for name, otherButton in pairs(self.ActiveButtons) do
            if name ~= config.Name and otherButton.IsActive then
                otherButton.IsActive = false
                if otherButton.Instance then
                    otherButton.Instance.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                end
                for _, track in pairs(otherButton.Tracks) do
                    if track then track:Stop() end
                end
                for _, conn in pairs(otherButton.Connections) do
                    conn:Disconnect()
                end
                otherButton.Connections = {}
            end
        end
        
        if not next(buttonData.Tracks) then
            if config.IdleId then
                local anim = Instance.new("Animation")
                anim.AnimationId = "rbxassetid://"..config.IdleId
                buttonData.Tracks.Idle = self.Animator:LoadAnimation(anim)
                buttonData.Tracks.Idle.Priority = config.Priority or Enum.AnimationPriority.Action4
            end
            
            if config.WalkId then
                local anim = Instance.new("Animation")
                anim.AnimationId = "rbxassetid://"..config.WalkId
                buttonData.Tracks.Walk = self.Animator:LoadAnimation(anim)
                buttonData.Tracks.Walk.Priority = config.Priority or Enum.AnimationPriority.Action4
            end
            
            if config.Name == "爬尸" and config.SitId then
                local anim = Instance.new("Animation")
                anim.AnimationId = "rbxassetid://"..config.SitId
                buttonData.Tracks.Sit = self.Animator:LoadAnimation(anim)
                buttonData.Tracks.Sit.Priority = Enum.AnimationPriority.Action2
                buttonData.Tracks.Sit.Looped = true
            end
            
            if config.PlayOnceId then
                local anim = Instance.new("Animation")
                anim.AnimationId = "rbxassetid://"..config.PlayOnceId
                buttonData.Tracks.PlayOnce = self.Animator:LoadAnimation(anim)
                buttonData.Tracks.PlayOnce.Priority = config.Priority or Enum.AnimationPriority.Action
                buttonData.Tracks.PlayOnce.Looped = false
            end
        end
        
        if config.PlayOnceId then
            if buttonData.Tracks.PlayOnce then
                buttonData.Tracks.PlayOnce:Play()
                
                if config.Callback then 
                    config.Callback(true) 
                end
                
                if config.StopAfter then
                    task.delay(config.StopAfter, function()
                        if buttonData and buttonData.IsActive then
                            if buttonData.Tracks.PlayOnce and buttonData.Tracks.PlayOnce.IsPlaying then
                                buttonData.Tracks.PlayOnce:Stop()
                            end
                            
                            if config.Callback then 
                                config.Callback(false) 
                            end
                            
                            buttonData.IsActive = false
                            if buttonData.Instance then
                                buttonData.Instance.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                            end
                            
                            self:RestoreDefaults()
                        end
                    end)
                end
                
                buttonData.Connections.Stopped = buttonData.Tracks.PlayOnce.Stopped:Connect(function()
                    if buttonData and buttonData.IsActive then
                        buttonData.IsActive = false
                        if buttonData.Instance then
                            buttonData.Instance.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                        end
                        
                        if config.Callback then 
                            config.Callback(false) 
                        end
                        
                        self:RestoreDefaults()
                    end
                end)
            end
        else
            if config.Name == "爬尸" then
                if buttonData.Tracks.Sit then
                    buttonData.Tracks.Sit:Play()
                end
                
                if self.Humanoid.MoveDirection.Magnitude > 0 then
                    if buttonData.Tracks.Walk then
                        buttonData.Tracks.Walk:Play()
                    end
                else
                    if buttonData.Tracks.Idle then
                        buttonData.Tracks.Idle:Play()
                    end
                end
                
                buttonData.Connections.Movement = self.Humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
                    if self.Humanoid.MoveDirection.Magnitude > 0 then
                        if buttonData.Tracks.Walk and not buttonData.Tracks.Walk.IsPlaying then
                            buttonData.Tracks.Walk:Play()
                        end
                        if buttonData.Tracks.Idle and buttonData.Tracks.Idle.IsPlaying then
                            buttonData.Tracks.Idle:Stop()
                        end
                    else
                        if buttonData.Tracks.Idle and not buttonData.Tracks.Idle.IsPlaying then
                            buttonData.Tracks.Idle:Play()
                        end
                        if buttonData.Tracks.Walk and buttonData.Tracks.Walk.IsPlaying then
                            buttonData.Tracks.Walk:Stop()
                        end
                    end
                end)
            else
                if self.Humanoid.MoveDirection.Magnitude > 0 then
                    if buttonData.Tracks.Walk then
                        buttonData.Tracks.Walk:Play()
                    end
                else
                    if buttonData.Tracks.Idle then
                        buttonData.Tracks.Idle:Play()
                    end
                end
                
                buttonData.Connections.Movement = self.Humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
                    if self.Humanoid.MoveDirection.Magnitude > 0 then
                        if buttonData.Tracks.Walk and not buttonData.Tracks.Walk.IsPlaying then
                            buttonData.Tracks.Walk:Play()
                        end
                        if buttonData.Tracks.Idle and buttonData.Tracks.Idle.IsPlaying then
                            buttonData.Tracks.Idle:Stop()
                        end
                    else
                        if buttonData.Tracks.Idle and not buttonData.Tracks.Idle.IsPlaying then
                            buttonData.Tracks.Idle:Play()
                        end
                        if buttonData.Tracks.Walk and buttonData.Tracks.Walk.IsPlaying then
                            buttonData.Tracks.Walk:Stop()
                        end
                    end
                end)
            end
        end
        
        if config.Callback then
            config.Callback(true)
        end
    else
        for _, track in pairs(buttonData.Tracks) do
            if track then track:Stop() end
        end
        for _, conn in pairs(buttonData.Connections) do
            conn:Disconnect()
        end
        buttonData.Connections = {}
        
        if config.Callback then
            config.Callback(false)
        end
    end
end

function AnimationController:RestoreDefaults()
    if self.Humanoid then
        self.Humanoid.WalkSpeed = 16
        
        if self.DefaultAnimations.Walk and not self.DefaultAnimations.Walk.IsPlaying then
            self.DefaultAnimations.Walk:Play()
        end
        
        if self.DefaultAnimations.Idle and not self.DefaultAnimations.Idle.IsPlaying then
            self.DefaultAnimations.Idle:Play()
        end
    end
end

function AnimationController:CreateMainGUI()
self.DefaultPositions = {
    MainFrame = UDim2.new(1, -160, 0, 10),
    SideFrame = UDim2.new(1, -300, 0, 10),
    FunctionFrame = UDim2.new(1, -440, 0, 10), 
    OtherFrame = UDim2.new(1, -580, 0, 10) 
}

    if self.IsClosed then return end
    if self.Gui then self.Gui:Destroy() end

    self.Gui = Instance.new("ScreenGui")
    self.Gui.Name = "AnimationControllerUI"
    self.Gui.Parent = player:WaitForChild("PlayerGui")
    self.Gui.ResetOnSpawn = false
    self.Gui.IgnoreGuiInset = true

    local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 5)
UICorner.Parent = self.Gui

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 140, 0, 350)
    mainFrame.Position = UDim2.new(1, -160, 0, 10)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Parent = self.Gui

    self.SideFrame = Instance.new("Frame")
    self.SideFrame.Name = "SideFrame"
    self.SideFrame.Size = UDim2.new(0, 140, 0, 350)
    self.SideFrame.Position = UDim2.new(1, -300, 0, 10)
    self.SideFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    self.SideFrame.BorderSizePixel = 0
    self.SideFrame.Active = true
    self.SideFrame.Parent = self.Gui

    self.FunctionFrame = Instance.new("Frame")
    self.FunctionFrame.Name = "FunctionFrame"
    self.FunctionFrame.Size = UDim2.new(0, 140, 0, 350)
    self.FunctionFrame.Position = UDim2.new(1, -440, 0, 10)
    self.FunctionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    self.FunctionFrame.BorderSizePixel = 0
    self.FunctionFrame.Active = true
    self.FunctionFrame.Parent = self.Gui

    self.OtherFrame = Instance.new("Frame")
    self.OtherFrame.Name = "OtherFrame"
    self.OtherFrame.Size = UDim2.new(0, 140, 0, 150)
    self.OtherFrame.Position = UDim2.new(1, -580, 0, 10)
    self.OtherFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    self.OtherFrame.BorderSizePixel = 0
    self.OtherFrame.Active = true
    self.OtherFrame.Parent = self.Gui
    
    local otherTitleBar = Instance.new("Frame")
    otherTitleBar.Size = UDim2.new(1, 0, 0, 25)
    otherTitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    otherTitleBar.BorderSizePixel = 0
    otherTitleBar.Parent = self.OtherFrame

    local otherTitleText = Instance.new("TextLabel")
    otherTitleText.Size = UDim2.new(1, -10, 1, 0)
    otherTitleText.Position = UDim2.new(0, 10, 0, 0)
    otherTitleText.Text = "其他/杂物"
    otherTitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    otherTitleText.BackgroundTransparency = 1
    otherTitleText.Font = Enum.Font.GothamBold
    otherTitleText.TextSize = 12
    otherTitleText.TextXAlignment = Enum.TextXAlignment.Left
    otherTitleText.Parent = otherTitleBar

    local otherScrollFrame = Instance.new("ScrollingFrame")
    otherScrollFrame.Name = "OtherScrollFrame"
    otherScrollFrame.Size = UDim2.new(1, -10, 1, -35)
    otherScrollFrame.Position = UDim2.new(0, 5, 0, 30)
    otherScrollFrame.BackgroundTransparency = 1
    otherScrollFrame.ScrollBarThickness = 8
    otherScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    otherScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    otherScrollFrame.Parent = self.OtherFrame

    local otherButtonContainer = Instance.new("Frame")
    otherButtonContainer.Name = "OtherButtonContainer"
    otherButtonContainer.Size = UDim2.new(1, 0, 0, 0)
    otherButtonContainer.BackgroundTransparency = 1
    otherButtonContainer.Parent = otherScrollFrame

    local otherUIListLayout = Instance.new("UIListLayout")
    otherUIListLayout.Padding = UDim.new(0, 5)
    otherUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    otherUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    otherUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    otherUIListLayout.Parent = otherButtonContainer

    otherUIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        otherScrollFrame.CanvasSize = UDim2.new(0, 0, 0, otherUIListLayout.AbsoluteContentSize.Y)
    end)
    

local button = Instance.new("TextButton")
button.Name = "PlayerESPButton"
button.Size = UDim2.new(1, -10, 0, 30)
button.Text = "开启透视"
button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 14
button.Parent = otherButtonContainer

local espEnabled = false
local playerHighlights = {}
local teamColors = {}

local function getTeamColor(player)
    if player.Team then
        return player.Team.TeamColor.Color
    else
        return Color3.fromRGB(255, 255, 255) 
    end
end

local function createPlayerESP(player)
    if not player.Character then return end
    if playerHighlights[player] then
        playerHighlights[player]:Destroy()
        playerHighlights[player] = nil
    end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = player.Name .. "ESP"
    highlight.FillColor = getTeamColor(player)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = player.Character

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PlayerNameTag"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = player.Character:WaitForChild("Head") or player.Character:WaitForChild("HumanoidRootPart")
    billboard.Parent = player.Character
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Text = player.Name .. (player.Team and " ("..player.Team.Name..")" or "")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = getTeamColor(player)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Parent = billboard
    
    playerHighlights[player] = highlight
end

local function removePlayerESP(player)
    if playerHighlights[player] then
        playerHighlights[player]:Destroy()
        playerHighlights[player] = nil
    end
    
    if player.Character then
        local nameTag = player.Character:FindFirstChild("PlayerNameTag")
        if nameTag then
            nameTag:Destroy()
        end
    end
end
local function updateAllPlayerESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if espEnabled then
            createPlayerESP(player)
        else
            removePlayerESP(player)
        end
    end
end
local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        if espEnabled then
            espEnabled = false
            button.Text = "开启透视"
            button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            updateAllPlayerESP()
        end
        
        if espEnabled then
            createPlayerESP(player)
        end
    end)
    
    player.CharacterRemoving:Connect(function()
        removePlayerESP(player)
    end)
    local success, err = pcall(function()
        player:GetPropertyChangedSignal("Team"):Connect(function()
            if espEnabled and player.Character then
                createPlayerESP(player)
            end
        end)
    end)
    
    if not success then
        warn("玩家呢？", err)
    end
end
button.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    
    if espEnabled then
        button.Text = "关闭透视"
        button.BackgroundColor3 = Color3.fromRGB(9, 137, 207)
        updateAllPlayerESP()
    else
        button.Text = "开启透视"
        button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        updateAllPlayerESP()
    end
end)
for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)

if espEnabled then
    updateAllPlayerESP()
end

local teleportButton = Instance.new("TextButton")
teleportButton.Name = "TeleportButton"
teleportButton.Size = UDim2.new(1, -10, 0, 30)
teleportButton.Text = "莱比锡绕过大门"
teleportButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Font = Enum.Font.SourceSansBold
teleportButton.TextSize = 14
teleportButton.Parent = otherButtonContainer

teleportButton.MouseButton1Click:Connect(function()
    local character = player.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local targetCFrame = CFrame.new(
                -588.658203, 10.9199705, -109.468513,
                0.258864343, 0, -0.965913713,
                0, 1, 0,
                0.965913713, 0, 0.258864343
            )
            humanoidRootPart.CFrame = targetCFrame
        end
    end
end)

local teleportButton = Instance.new("TextButton")
teleportButton.Name = "GodModeTeleport"
teleportButton.Size = UDim2.new(1, -10, 0, 30)
teleportButton.Text = "无敌飞雷神"
teleportButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Font = Enum.Font.SourceSansBold
teleportButton.TextSize = 14
teleportButton.Parent = otherButtonContainer

local SAFE_DISTANCE = 3
local FLOAT_HEIGHT = 3
local FLOAT_SPEED = 15
local COOLDOWN = 0.6

local isActive = false
local currentTarget = nil
local floatOffset = 0
local lastSwitch = 0
local heartbeatConnection = nil

local function getValidTargets()
    local targets = {}
    local me = game:GetService("Players").LocalPlayer
    
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= me and 
           player.Character and
           player.Character:FindFirstChild("HumanoidRootPart") and
           (not me.Team or not player.Team or player.Team ~= me.Team) then
            table.insert(targets, player)
        end
    end
    
    return targets
end

local function godTeleport()
    local me = game:GetService("Players").LocalPlayer
    if not me.Character then return end
    local myRoot = me.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    local targets = getValidTargets()
    if #targets == 0 then
        teleportButton.Text = "无有效目标"
        task.wait(2)
        teleportButton.Text = isActive and "停止传送" or "无敌飞雷神"
        return
    end
    
    if tick() - lastSwitch >= COOLDOWN then
        currentTarget = targets[math.random(1, #targets)]
        lastSwitch = tick()
        floatOffset = 0
    end
    
    if currentTarget and currentTarget.Character then
        local targetRoot = currentTarget.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            floatOffset = math.sin(tick() * FLOAT_SPEED) * FLOAT_HEIGHT
            
            local backVector = targetRoot.CFrame.LookVector * -SAFE_DISTANCE
            local floatVector = Vector3.new(0, floatOffset, 0)
            myRoot.CFrame = CFrame.new(
                targetRoot.Position + backVector + floatVector,
                targetRoot.Position + floatVector
            )
        end
    end
end

local function stopTeleport()
    isActive = false
    if heartbeatConnection then
        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end
    teleportButton.Text = "无敌飞雷神"
    teleportButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    currentTarget = nil
end

teleportButton.MouseButton1Click:Connect(function()
    isActive = not isActive
    
    if isActive then
        teleportButton.Text = "停止传送"
        teleportButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        currentTarget = nil
        lastSwitch = 0
        
        heartbeatConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if isActive then
                godTeleport()
            end
        end)
    else
        stopTeleport()
    end
end)

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    stopTeleport()
    
    local humanoid = newCharacter:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        stopTeleport()
    end)
end)

local animLoopButton = Instance.new("TextButton")
animLoopButton.Name = "AnimationLoopButton"
animLoopButton.Size = UDim2.new(1, -10, 0, 30)
animLoopButton.Text = "黑皮体育生沉淀"
animLoopButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
animLoopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
animLoopButton.Font = Enum.Font.SourceSansBold
animLoopButton.TextSize = 14
animLoopButton.Parent = otherButtonContainer

local ANIMATION1 = "rbxassetid://127516132968916"
local ANIMATION2 = "rbxassetid://126160671215200"

local isAnimLooping = false
local animLoopConnection = nil
local currentTracks = {}

local function playAnimationSequence(player)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
    
    local anim1 = Instance.new("Animation")
    anim1.AnimationId = ANIMATION1
    
    local anim2 = Instance.new("Animation")
    anim2.AnimationId = ANIMATION2
    
    while isAnimLooping do
        for _, track in pairs(currentTracks) do
            if track then
                track:Stop()
            end
        end
        currentTracks = {}
        
        local track1 = animator:LoadAnimation(anim1)
        table.insert(currentTracks, track1)
        track1:Play()
        task.wait(0.1)
        track1:Stop()
        
        if not isAnimLooping then break end
        
        local track2 = animator:LoadAnimation(anim2)
        table.insert(currentTracks, track2)
        track2:Play()
        task.wait(0.15)
        track2:Stop()
    end
    
    for _, track in pairs(currentTracks) do
        if track then
            track:Stop()
        end
    end
    currentTracks = {}
end

animLoopButton.MouseButton1Click:Connect(function()
    isAnimLooping = not isAnimLooping
    
    if isAnimLooping then
        animLoopButton.Text = "黑皮体育生沉淀: 开启"
        animLoopButton.BackgroundColor3 = Color3.fromRGB(9, 137, 207)
        
        animLoopConnection = task.spawn(function()
            playAnimationSequence(Players.LocalPlayer)
        end)
    else
        animLoopButton.Text = "黑皮体育生沉淀: 关闭"
        animLoopButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        
        if animLoopConnection then
            task.cancel(animLoopConnection)
            animLoopConnection = nil
        end
        
        for _, track in pairs(currentTracks) do
            if track then
                track:Stop()
            end
        end
        currentTracks = {}
    end
end)

Players.LocalPlayer.CharacterAdded:Connect(function()
    if isAnimLooping then
        isAnimLooping = false
        animLoopButton.Text = "黑皮体育生沉淀: 关闭"
        animLoopButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        
        if animLoopConnection then
            task.cancel(animLoopConnection)
            animLoopConnection = nil
        end
        
        for _, track in pairs(currentTracks) do
            if track then
                track:Stop()
            end
        end
        currentTracks = {}
    end
end)

    local otherCloseButton = Instance.new("TextButton")
    otherCloseButton.Size = UDim2.new(0, 20, 0, 20)
    otherCloseButton.Position = UDim2.new(1, -25, 0, 5)
    otherCloseButton.Text = "X"
    otherCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    otherCloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    otherCloseButton.Font = Enum.Font.GothamBold
    otherCloseButton.Parent = self.OtherFrame

    otherCloseButton.MouseButton1Click:Connect(function()
        self.OtherFrame.Visible = not self.OtherFrame.Visible
    end)

    local functionTitleBar = Instance.new("Frame")
    functionTitleBar.Size = UDim2.new(1, 0, 0, 25)
    functionTitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    functionTitleBar.BorderSizePixel = 0
    functionTitleBar.Parent = self.FunctionFrame

    local functionTitleText = Instance.new("TextLabel")
    functionTitleText.Size = UDim2.new(1, -10, 1, 0)
    functionTitleText.Position = UDim2.new(0, 10, 0, 0)
    functionTitleText.Text = "功能"
    functionTitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    functionTitleText.BackgroundTransparency = 1
    functionTitleText.Font = Enum.Font.GothamBold
    functionTitleText.TextSize = 12
    functionTitleText.TextXAlignment = Enum.TextXAlignment.Left
    functionTitleText.Parent = functionTitleBar

    local functionScrollFrame = Instance.new("ScrollingFrame")
    functionScrollFrame.Name = "FunctionScrollFrame"
    functionScrollFrame.Size = UDim2.new(1, -10, 1, -35)
    functionScrollFrame.Position = UDim2.new(0, 5, 0, 30)
    functionScrollFrame.BackgroundTransparency = 1
    functionScrollFrame.ScrollBarThickness = 8
    functionScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    functionScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    functionScrollFrame.Parent = self.FunctionFrame

    local functionButtonContainer = Instance.new("Frame")
    functionButtonContainer.Name = "FunctionButtonContainer"
    functionButtonContainer.Size = UDim2.new(1, 0, 0, 0)
    functionButtonContainer.BackgroundTransparency = 1
    functionButtonContainer.Parent = functionScrollFrame

    local functionUIListLayout = Instance.new("UIListLayout")
    functionUIListLayout.Padding = UDim.new(0, 5)
    functionUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    functionUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    functionUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    functionUIListLayout.Parent = functionButtonContainer

    functionUIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        functionScrollFrame.CanvasSize = UDim2.new(0, 0, 0, functionUIListLayout.AbsoluteContentSize.Y)
    end)

local autoDigButton = Instance.new("TextButton")
autoDigButton.Name = "AutoDigSnow"
autoDigButton.Size = UDim2.new(1, -10, 0, 30)
autoDigButton.Text = "自动挖雪: 关闭"
autoDigButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
autoDigButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoDigButton.Font = Enum.Font.SourceSansBold
autoDigButton.TextSize = 14
autoDigButton.Parent = functionButtonContainer

local isAutoDigging = false
local digConnection = nil
local currentDiggable = nil

local DIGGABLE_PATHS = {
    "Vardohus Fortress/Modes/Objective/DoorSnow/Diggable",
    "Vardohus Fortress/Modes/Objective/Diggable",
    "OLD Vardohus Fortress/Modes/Objective/DigSnow/Diggable"
}

local function getDiggingTool()
    local character = game:GetService("Players").LocalPlayer.Character
    if not character then return nil end
    
    for _, tool in pairs(character:GetChildren()) do
        if (tool.Name == "Shovel" or tool.Name == "Spade") and tool:FindFirstChild("RemoteEvent") then
            return tool
        end
    end
    
    for _, tool in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
        if (tool.Name == "Shovel" or tool.Name == "Spade") and tool:FindFirstChild("RemoteEvent") then
            return tool
        end
    end
    
    return nil
end

local function findValidDiggable()
    for _, path in ipairs(DIGGABLE_PATHS) do
        local parts = path:split("/")
        local current = workspace
        for _, partName in ipairs(parts) do
            current = current:FindFirstChild(partName)
            if not current then break end
        end
        if current then
            return current
        end
    end
    return nil
end

local function executeDig()
    if not isAutoDigging then return end
    
    local diggable = findValidDiggable()
    if not diggable then return end
    
    local tool = getDiggingTool()
    if not tool then return end
    
    if tool.Parent ~= game:GetService("Players").LocalPlayer.Character then
        tool.Parent = game:GetService("Players").LocalPlayer.Character
        task.wait(0.2)
    end
    
    local remoteEvent = tool:FindFirstChild("RemoteEvent")
    if not remoteEvent then return end
    
    remoteEvent:FireServer("Dig", diggable, diggable.Position)
end

local function autoDigLoop()
    while isAutoDigging do
        executeDig()
        task.wait(0.01)
    end
end

autoDigButton.MouseButton1Click:Connect(function()
    isAutoDigging = not isAutoDigging
    
    if isAutoDigging then
        autoDigButton.Text = "自动挖雪: 开启"
        autoDigButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        digConnection = task.spawn(autoDigLoop)
    else
        autoDigButton.Text = "自动挖雪: 关闭"
        autoDigButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        if digConnection then
            task.cancel(digConnection)
            digConnection = nil
        end
    end
end)

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
    if isAutoDigging then
        isAutoDigging = false
        autoDigButton.Text = "自动挖雪: 关闭"
        autoDigButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        if digConnection then
            task.cancel(digConnection)
            digConnection = nil
        end
    end
end)

local button = Instance.new("TextButton")
button.Name = "FullBrightToggleButton"
button.Size = UDim2.new(1, -10, 0, 30)
button.Text = "全图高亮:OFF"
button.BackgroundColor3 = Color3.fromRGB(80,80,80)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 14
button.Parent = functionButtonContainer

button.MouseButton1Click:Connect(function()
    if not _G.FullBrightExecuted then
        _G.FullBrightEnabled = false
        
        _G.NormalLightingSettings = {
            Brightness = game:GetService("Lighting").Brightness,
            ClockTime = game:GetService("Lighting").ClockTime,
            FogEnd = game:GetService("Lighting").FogEnd,
            GlobalShadows = game:GetService("Lighting").GlobalShadows,
            Ambient = game:GetService("Lighting").Ambient
        }
        
        game:GetService("Lighting"):GetPropertyChangedSignal("Brightness"):Connect(function()
            if game:GetService("Lighting").Brightness ~= 1 and game:GetService("Lighting").Brightness ~= _G.NormalLightingSettings.Brightness then
                _G.NormalLightingSettings.Brightness = game:GetService("Lighting").Brightness
                if not _G.FullBrightEnabled then
                    repeat
                        wait()
                    until _G.FullBrightEnabled
                end
                game:GetService("Lighting").Brightness = 1
            end
        end)
        
        game:GetService("Lighting"):GetPropertyChangedSignal("ClockTime"):Connect(function()
            if game:GetService("Lighting").ClockTime ~= 12 and game:GetService("Lighting").ClockTime ~= _G.NormalLightingSettings.ClockTime then
                _G.NormalLightingSettings.ClockTime = game:GetService("Lighting").ClockTime
                if not _G.FullBrightEnabled then
                    repeat
                        wait()
                    until _G.FullBrightEnabled
                end
                game:GetService("Lighting").ClockTime = 12
            end
        end)
        
        game:GetService("Lighting"):GetPropertyChangedSignal("FogEnd"):Connect(function()
            if game:GetService("Lighting").FogEnd ~= 786543 and game:GetService("Lighting").FogEnd ~= _G.NormalLightingSettings.FogEnd then
                _G.NormalLightingSettings.FogEnd = game:GetService("Lighting").FogEnd
                if not _G.FullBrightEnabled then
                    repeat
                        wait()
                    until _G.FullBrightEnabled
                end
                game:GetService("Lighting").FogEnd = 786543
            end
        end)
        
        game:GetService("Lighting"):GetPropertyChangedSignal("GlobalShadows"):Connect(function()
            if game:GetService("Lighting").GlobalShadows ~= false and game:GetService("Lighting").GlobalShadows ~= _G.NormalLightingSettings.GlobalShadows then
                _G.NormalLightingSettings.GlobalShadows = game:GetService("Lighting").GlobalShadows
                if not _G.FullBrightEnabled then
                    repeat
                        wait()
                    until _G.FullBrightEnabled
                end
                game:GetService("Lighting").GlobalShadows = false
            end
        end)
        
        game:GetService("Lighting"):GetPropertyChangedSignal("Ambient"):Connect(function()
            if game:GetService("Lighting").Ambient ~= Color3.fromRGB(178, 178, 178) and game:GetService("Lighting").Ambient ~= _G.NormalLightingSettings.Ambient then
                _G.NormalLightingSettings.Ambient = game:GetService("Lighting").Ambient
                if not _G.FullBrightEnabled then
                    repeat
                        wait()
                    until _G.FullBrightEnabled
                end
                game:GetService("Lighting").Ambient = Color3.fromRGB(178, 178, 178)
            end
        end)
        
        game:GetService("Lighting").Brightness = 1
        game:GetService("Lighting").ClockTime = 12
        game:GetService("Lighting").FogEnd = 786543
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").Ambient = Color3.fromRGB(178, 178, 178)
        
        local LatestValue = true
        spawn(function()
            repeat
                wait()
            until _G.FullBrightEnabled
            while wait() do
                if _G.FullBrightEnabled ~= LatestValue then
                    if not _G.FullBrightEnabled then
                        game:GetService("Lighting").Brightness = _G.NormalLightingSettings.Brightness
                        game:GetService("Lighting").ClockTime = _G.NormalLightingSettings.ClockTime
                        game:GetService("Lighting").FogEnd = _G.NormalLightingSettings.FogEnd
                        game:GetService("Lighting").GlobalShadows = _G.NormalLightingSettings.GlobalShadows
                        game:GetService("Lighting").Ambient = _G.NormalLightingSettings.Ambient
                    else
                        game:GetService("Lighting").Brightness = 1
                        game:GetService("Lighting").ClockTime = 12
                        game:GetService("Lighting").FogEnd = 786543
                        game:GetService("Lighting").GlobalShadows = false
                        game:GetService("Lighting").Ambient = Color3.fromRGB(178, 178, 178)
                    end
                    LatestValue = not LatestValue
                end
            end
        end)
        
        _G.FullBrightExecuted = true
    end
    
    _G.FullBrightEnabled = not _G.FullBrightEnabled
    
    if _G.FullBrightEnabled then
        button.Text = "全图高亮:ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    else
        button.Text = "全图高亮:OFF"
        button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end
end)

local speedButton = Instance.new("TextButton")
speedButton.Name = "SpeedControlButton"
speedButton.Size = UDim2.new(1, -10, 0, 30)
speedButton.Text = "保持速度: 关闭"
speedButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.Font = Enum.Font.SourceSansBold
speedButton.TextSize = 14
speedButton.Parent = functionButtonContainer

local speedInput = Instance.new("TextBox")
speedInput.Name = "SpeedInput"
speedInput.Size = UDim2.new(1, -10, 0, 30)
speedInput.Position = UDim2.new(0, 5, 0, 35)
speedInput.Text = "16"
speedInput.PlaceholderText = "输入速度(1-100)"
speedInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.Font = Enum.Font.SourceSans
speedInput.TextSize = 14
speedInput.Parent = functionButtonContainer

local isSpeedActive = false
local DEFAULT_SPEED = 16

local function applySpeed()
    local speed = tonumber(speedInput.Text) or DEFAULT_SPEED
    speed = math.clamp(math.floor(speed), 1, 100)
    speedInput.Text = tostring(speed)
    
    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = isSpeedActive and speed or DEFAULT_SPEED
        end
    end
end

speedButton.MouseButton1Click:Connect(function()
    isSpeedActive = not isSpeedActive
    
    if isSpeedActive then
        speedButton.Text = "保持速度: 开启"
        speedButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    else
        speedButton.Text = "保持速度: 关闭" 
        speedButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end
    
    applySpeed()
end)

speedInput.FocusLost:Connect(function()
    applySpeed()
end)

player.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = isSpeedActive and (tonumber(speedInput.Text) or DEFAULT_SPEED) or DEFAULT_SPEED
end)

applySpeed()

local cannonButton = Instance.new("TextButton")
cannonButton.Name = "瓦尔多要塞火炮物资透视"
cannonButton.Size = UDim2.new(1, -10, 0, 30)
cannonButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
cannonButton.Text = "瓦尔多要塞火炮物资透视"
cannonButton.TextColor3 = Color3.fromRGB(255, 255, 255)
cannonButton.Font = Enum.Font.Gotham
cannonButton.TextSize = 14
cannonButton.Parent = functionButtonContainer

local cannonButtonData = {
    Instance = cannonButton,
    IsActive = false,
    Tracks = {},
    Connections = {}
}
self.ActiveButtons["瓦尔多要塞火炮物资透视"] = cannonButtonData

cannonButton.MouseButton1Click:Connect(function()
    self:ToggleCannonHighlights()
end)

local noFallDamageButton = Instance.new("TextButton")
noFallDamageButton.Name = "NoFallDamageButton"
noFallDamageButton.Size = UDim2.new(1, -10, 0, 30)
noFallDamageButton.Text = "移除摔伤: 关闭"
noFallDamageButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
noFallDamageButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noFallDamageButton.Font = Enum.Font.SourceSansBold
noFallDamageButton.TextSize = 14
noFallDamageButton.Parent = functionButtonContainer

local noFallDamageActive = false
local fallDamageConnection = nil

local noFallDamageData = {
    Instance = noFallDamageButton,
    IsActive = false,
    Tracks = {},
    Connections = {}
}
self.ActiveButtons["移除摔伤"] = noFallDamageData

local function preventFallDamage()
    while noFallDamageActive and task.wait(1) do
        if not player.Character then continue end
        
        local health = player.Character:FindFirstChild("Health")
        if not health then continue end
        
        local forceSelfDamage = health:FindFirstChild("ForceSelfDamage")
        if not forceSelfDamage then continue end
        
        local args = {0}
        forceSelfDamage:FireServer(unpack(args))
    end
end

noFallDamageButton.MouseButton1Click:Connect(function()
    noFallDamageActive = not noFallDamageActive
    
    if noFallDamageActive then
        noFallDamageButton.Text = "移除摔伤: 开启"
        noFallDamageButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        
        fallDamageConnection = task.spawn(preventFallDamage)
    else
        noFallDamageButton.Text = "移除摔伤: 关闭"
        noFallDamageButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        
        if fallDamageConnection then
            task.cancel(fallDamageConnection)
            fallDamageConnection = nil
        end
    end
end)

player.CharacterAdded:Connect(function()
    if noFallDamageActive then
        noFallDamageActive = false
        noFallDamageButton.Text = "移除摔伤: 关闭"
        noFallDamageButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        
        if fallDamageConnection then
            task.cancel(fallDamageConnection)
            fallDamageConnection = nil
        end
    end
end)

local killAuraButton = Instance.new("TextButton")
killAuraButton.Name = "杀戮光环"
killAuraButton.Size = UDim2.new(1, -10, 0, 30)
killAuraButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
killAuraButton.Text = "杀戮光环"
killAuraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
killAuraButton.Font = Enum.Font.Gotham
killAuraButton.TextSize = 14
killAuraButton.Parent = functionButtonContainer

local noBarrelsButton = Instance.new("TextButton")
noBarrelsButton.Name = "取消攻击炸药桶"
noBarrelsButton.Size = UDim2.new(1, -8, 0, 25)
noBarrelsButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
noBarrelsButton.Text = "攻击炸药桶: 取消"
noBarrelsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noBarrelsButton.Font = Enum.Font.Gotham
noBarrelsButton.TextSize = 14
noBarrelsButton.Visible = false
noBarrelsButton.Parent = functionButtonContainer

local autoRotateButton = Instance.new("TextButton")
autoRotateButton.Name = "自动转向"
autoRotateButton.Size = UDim2.new(1, -10, 0, 25)
autoRotateButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
autoRotateButton.Text = "自动转向: 关闭" 
autoRotateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoRotateButton.Font = Enum.Font.Gotham
autoRotateButton.TextSize = 14
autoRotateButton.Visible = false
autoRotateButton.Parent = functionButtonContainer

local attackDraculaButton = Instance.new("TextButton")
attackDraculaButton.Name = "攻击德古拉"
attackDraculaButton.Size = UDim2.new(1, -10, 0, 25)
attackDraculaButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
attackDraculaButton.Text = "攻击德古拉: 关闭"
attackDraculaButton.TextColor3 = Color3.fromRGB(255, 255, 255)
attackDraculaButton.Font = Enum.Font.Gotham
attackDraculaButton.TextSize = 14
attackDraculaButton.Visible = false
attackDraculaButton.Parent = functionButtonContainer

local killAuraActive = false
local attackBarrels = false
local autoRotateEnabled = false 
local attackDraculaEnabled = false
local killAuraConnection = nil

local function getMelee()
    for _, item in pairs(AnimationController.Character:GetChildren()) do
        if item:GetAttribute("Melee") then
            return item
        end
    end

    for _, item in pairs(player.Backpack:GetChildren()) do
        if item:GetAttribute("Melee") then
            return item
        end
    end
    return nil
end

local function distance(target)
    if not AnimationController.Character or not target or not target:FindFirstChild("HumanoidRootPart") then
        return math.huge
    end
    return (target.HumanoidRootPart.Position - AnimationController.Character.HumanoidRootPart.Position).magnitude
end

local function attackZombie(zombie)
    local weapon = getMelee()
    if not weapon then return end
    
    local range = 10
    if weapon.Name == "Pike" then
        range = 11
    elseif weapon.Name == "Axe" then
        range = 9
    end
    
    if weapon.Parent ~= AnimationController.Character then
        weapon.Parent = AnimationController.Character
        task.wait(0.1)
    end
    
    if autoRotateEnabled then
        local wasAutoRotate = AnimationController.Humanoid.AutoRotate
        AnimationController.Humanoid.AutoRotate = false
        local pos = zombie.HumanoidRootPart.Position
        AnimationController.Character.HumanoidRootPart.CFrame = CFrame.lookAt(
            AnimationController.Character.HumanoidRootPart.Position, 
            Vector3.new(pos.X, AnimationController.Character.HumanoidRootPart.Position.Y, pos.Z)
        )
        if wasAutoRotate then
            AnimationController.Humanoid.AutoRotate = true
        end
    end
    
    if weapon.Name == "Axe" and zombie.State.Value ~= "Stunned" then
        weapon.RemoteEvent:FireServer("BraceBlock")
        weapon.RemoteEvent:FireServer("StopBraceBlock")
        weapon.RemoteEvent:FireServer("FeedbackStun", zombie, zombie.HumanoidRootPart.Position)
    end
    
    if distance(zombie) <= range then
        weapon.RemoteEvent:FireServer("Swing", "Side")
        weapon.RemoteEvent:FireServer("HitZombie", zombie, zombie.Head.Position, true)
    end
end

local function attackDracula()
    local weapon = getMelee()
    if not weapon then return end
    
    local dracula = workspace:WaitForChild("Transylvania"):WaitForChild("Modes"):WaitForChild("Boss"):WaitForChild("Dracula")
    if not dracula or not dracula:FindFirstChild("HumanoidRootPart") then return end
    
    local range = 10
    if weapon.Name == "Pike" then
        range = 11
    elseif weapon.Name == "Axe" then
        range = 9
    end
    
    if weapon.Parent ~= AnimationController.Character then
        weapon.Parent = AnimationController.Character
        task.wait(0.1)
    end
    
    if autoRotateEnabled then
        local wasAutoRotate = AnimationController.Humanoid.AutoRotate
        AnimationController.Humanoid.AutoRotate = false
        local pos = dracula.HumanoidRootPart.Position
        AnimationController.Character.HumanoidRootPart.CFrame = CFrame.lookAt(
            AnimationController.Character.HumanoidRootPart.Position, 
            Vector3.new(pos.X, AnimationController.Character.HumanoidRootPart.Position.Y, pos.Z)
        )
        if wasAutoRotate then
            AnimationController.Humanoid.AutoRotate = true
        end
    end
    
    if distance(dracula) <= range then
        weapon.RemoteEvent:FireServer("Swing", "Side")
        
        -- 攻击Dracula的特殊参数
        local args = {
            "HitZombie",
            dracula,
            dracula.Head.Position,  -- 实时头部位置
            true,
            "Head",
        }
        weapon.RemoteEvent:FireServer(unpack(args))
    end
end

killAuraButton.MouseButton1Click:Connect(function()
    killAuraActive = not killAuraActive
    
    if killAuraActive then
        killAuraButton.Text = "杀戮光环"
        killAuraButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        noBarrelsButton.Visible = true
        autoRotateButton.Visible = true
        attackDraculaButton.Visible = true
        
        killAuraConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not killAuraActive or not AnimationController.Character or AnimationController.Humanoid.Health <= 0 then return end
            
            -- 攻击普通僵尸
            for _, zombie in pairs(workspace.Zombies:GetChildren()) do
                if zombie:IsA("Model") and zombie:FindFirstChild("HumanoidRootPart") then
                    if zombie:GetAttribute("Type") == "Barrel" and not attackBarrels then
                        continue
                    end
                    
                    if distance(zombie) <= 12 and zombie.State.Value ~= "Spawn" then
                        attackZombie(zombie)
                    end
                end
            end
            
            -- 攻击Dracula
            if attackDraculaEnabled then
                local dracula = workspace:FindFirstChild("Transylvania") and 
                               workspace.Transylvania:FindFirstChild("Modes") and
                               workspace.Transylvania.Modes:FindFirstChild("Boss") and
                               workspace.Transylvania.Modes.Boss:FindFirstChild("Dracula")
                
                if dracula and dracula:FindFirstChild("HumanoidRootPart") and distance(dracula) <= 12 then
                    attackDracula()
                end
            end
        end)
    else
        killAuraButton.Text = "杀戮光环"
        killAuraButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        noBarrelsButton.Visible = false
        autoRotateButton.Visible = false
        attackDraculaButton.Visible = false
        
        if killAuraConnection then
            killAuraConnection:Disconnect()
            killAuraConnection = nil
        end
    end
end)

autoRotateButton.MouseButton1Click:Connect(function()
    autoRotateEnabled = not autoRotateEnabled
    autoRotateButton.Text = "自动转向: " .. (autoRotateEnabled and "开启" or "关闭")
    autoRotateButton.BackgroundColor3 = autoRotateEnabled and Color3.fromRGB(39, 70, 45) or Color3.fromRGB(80, 80, 80)
end)

noBarrelsButton.MouseButton1Click:Connect(function()
    attackBarrels = not attackBarrels
    noBarrelsButton.Text = "攻击炸药桶: " .. (attackBarrels and "启用" or "取消")
    noBarrelsButton.BackgroundColor3 = attackBarrels and Color3.fromRGB(39, 70, 45) or Color3.fromRGB(80, 80, 80)
end)

attackDraculaButton.MouseButton1Click:Connect(function()
    attackDraculaEnabled = not attackDraculaEnabled
    attackDraculaButton.Text = "攻击德古拉: " .. (attackDraculaEnabled and "开启" or "关闭")
    attackDraculaButton.BackgroundColor3 = attackDraculaEnabled and Color3.fromRGB(120, 0, 0) or Color3.fromRGB(80, 80, 80)
end)

player.CharacterAdded:Connect(function(character)
    if killAuraConnection then
        killAuraConnection:Disconnect()
        killAuraConnection = nil
    end
    killAuraActive = false
    attackBarrels = false
    autoRotateEnabled = false
    attackDraculaEnabled = false
    killAuraButton.Text = "杀戮光环"
    killAuraButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    noBarrelsButton.Text = "攻击炸药桶: 取消"
    noBarrelsButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    noBarrelsButton.Visible = false
    autoRotateButton.Text = "自动转向: 关闭"
    autoRotateButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    autoRotateButton.Visible = false
    attackDraculaButton.Text = "攻击德古拉: 关闭"
    attackDraculaButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    attackDraculaButton.Visible = false
end)

local bayonetKillAuraButton = Instance.new("TextButton")
bayonetKillAuraButton.Name = "BayonetKillAura"
bayonetKillAuraButton.Size = UDim2.new(1, -10, 0, 30)
bayonetKillAuraButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
bayonetKillAuraButton.Text = "刺刀杀戮光环"
bayonetKillAuraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
bayonetKillAuraButton.Font = Enum.Font.Gotham
bayonetKillAuraButton.TextSize = 14
bayonetKillAuraButton.Parent = functionButtonContainer

local bayonetNoBarrelsButton = Instance.new("TextButton")
bayonetNoBarrelsButton.Name = "BayonetNoBarrelsButton"
bayonetNoBarrelsButton.Size = UDim2.new(1, -10, 0, 25)
bayonetNoBarrelsButton.Position = UDim2.new(0, 10, 0, 35)
bayonetNoBarrelsButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
bayonetNoBarrelsButton.Text = "攻击炸药桶: 取消"
bayonetNoBarrelsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
bayonetNoBarrelsButton.Font = Enum.Font.Gotham
bayonetNoBarrelsButton.TextSize = 14
bayonetNoBarrelsButton.Visible = false
bayonetNoBarrelsButton.Parent = functionButtonContainer

local bayonetAutoRotateButton = Instance.new("TextButton")
bayonetAutoRotateButton.Name = "BayonetAutoRotateButton"
bayonetAutoRotateButton.Size = UDim2.new(1, -10, 0, 25)
bayonetAutoRotateButton.Position = UDim2.new(0, 10, 0, 65)
bayonetAutoRotateButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
bayonetAutoRotateButton.Text = "自动转向: 关闭"
bayonetAutoRotateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
bayonetAutoRotateButton.Font = Enum.Font.Gotham
bayonetAutoRotateButton.TextSize = 14
bayonetAutoRotateButton.Visible = false
bayonetAutoRotateButton.Parent = functionButtonContainer

local isBayonetKillAuraActive = false
local bayonetAttackBarrels = false
local bayonetAutoRotateEnabled = false
local bayonetKillAuraConnection = nil

local function getMusket()
    for _, item in pairs(AnimationController.Character:GetChildren()) do
        if item:IsA("Tool") and item.Name == "Musket" then
            return item
        end
    end

    for _, item in pairs(player.Backpack:GetChildren()) do
        if item:IsA("Tool") and item.Name == "Musket" then
            return item
        end
    end
    return nil
end

local function distance(target)
    if not AnimationController.Character or not target or not target:FindFirstChild("HumanoidRootPart") then
        return math.huge
    end
    return (target.HumanoidRootPart.Position - AnimationController.Character.HumanoidRootPart.Position).magnitude
end

local function executeBayonetAttack(zombie)
    local weapon = getMusket()
    if not weapon then return end
    
    if weapon.Parent ~= AnimationController.Character then
        weapon.Parent = AnimationController.Character
        task.wait(0.1)
    end
    
    if bayonetAutoRotateEnabled then
        local wasAutoRotate = AnimationController.Humanoid.AutoRotate
        AnimationController.Humanoid.AutoRotate = false
        local pos = zombie.HumanoidRootPart.Position
        AnimationController.Character.HumanoidRootPart.CFrame = CFrame.lookAt(
            AnimationController.Character.HumanoidRootPart.Position, 
            Vector3.new(pos.X, AnimationController.Character.HumanoidRootPart.Position.Y, pos.Z)
        )
        if wasAutoRotate then
            AnimationController.Humanoid.AutoRotate = true
        end
    end
    
    local remoteEvent = weapon:FindFirstChild("RemoteEvent")
    if not remoteEvent then return end
    
    -- 修复部分：检查Head是否存在，如果不存在则使用HumanoidRootPart
    local hitPart = zombie:FindFirstChild("Head") or zombie:FindFirstChild("HumanoidRootPart")
    if not hitPart then return end
    
    remoteEvent:FireServer("ThrustBayonet")
    task.wait(0.1)
    remoteEvent:FireServer("Bayonet_HitZombie", zombie, hitPart.Position, true)
end

local function bayonetKillAuraLoop()
    while isBayonetKillAuraActive and task.wait() do
        if not AnimationController.Character or AnimationController.Humanoid.Health <= 0 then return end
        
        for _, zombie in pairs(workspace.Zombies:GetChildren()) do
            if zombie:IsA("Model") and zombie:FindFirstChild("HumanoidRootPart") then
                if zombie:GetAttribute("Type") == "Barrel" and not bayonetAttackBarrels then
                    continue
                end
                if zombie:FindFirstChild("Barrel") then
                    continue
                end
                
                if distance(zombie) <= 15 and zombie.State.Value ~= "Spawn" then
                    executeBayonetAttack(zombie)
                end
            end
        end
    end
end

bayonetKillAuraButton.MouseButton1Click:Connect(function()
    isBayonetKillAuraActive = not isBayonetKillAuraActive
    
    if isBayonetKillAuraActive then
        bayonetKillAuraButton.Text = "刺刀杀戮光环(开)"
        bayonetKillAuraButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        bayonetNoBarrelsButton.Visible = true
        bayonetAutoRotateButton.Visible = true
        
        bayonetKillAuraConnection = task.spawn(bayonetKillAuraLoop)
    else
        bayonetKillAuraButton.Text = "刺刀杀戮光环"
        bayonetKillAuraButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        bayonetNoBarrelsButton.Visible = false
        bayonetAutoRotateButton.Visible = false
        
        if bayonetKillAuraConnection then
            task.cancel(bayonetKillAuraConnection)
            bayonetKillAuraConnection = nil
        end
    end
end)

bayonetNoBarrelsButton.MouseButton1Click:Connect(function()
    bayonetAttackBarrels = not bayonetAttackBarrels
    bayonetNoBarrelsButton.Text = "攻击炸药桶: " .. (bayonetAttackBarrels and "启用" or "取消")
    bayonetNoBarrelsButton.BackgroundColor3 = bayonetAttackBarrels and Color3.fromRGB(39, 70, 45) or Color3.fromRGB(80, 80, 80)
end)

bayonetAutoRotateButton.MouseButton1Click:Connect(function()
    bayonetAutoRotateEnabled = not bayonetAutoRotateEnabled
    bayonetAutoRotateButton.Text = "自动转向: " .. (bayonetAutoRotateEnabled and "开启" or "关闭")
    bayonetAutoRotateButton.BackgroundColor3 = bayonetAutoRotateEnabled and Color3.fromRGB(39, 70, 45) or Color3.fromRGB(80, 80, 80)
end)

player.CharacterAdded:Connect(function(character)
    if bayonetKillAuraConnection then
        task.cancel(bayonetKillAuraConnection)
        bayonetKillAuraConnection = nil
    end
    isBayonetKillAuraActive = false
    bayonetAttackBarrels = false
    bayonetAutoRotateEnabled = false
    bayonetKillAuraButton.Text = "刺刀杀戮光环"
    bayonetKillAuraButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    bayonetNoBarrelsButton.Text = "攻击炸药桶: 取消"
    bayonetNoBarrelsButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    bayonetNoBarrelsButton.Visible = false
    bayonetAutoRotateButton.Text = "自动转向: 关闭"
    bayonetAutoRotateButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    bayonetAutoRotateButton.Visible = false
end)


local killBotsButton = Instance.new("TextButton")
killBotsButton.Name = "KillBots"
killBotsButton.Size = UDim2.new(1, -10, 0, 30)
killBotsButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
killBotsButton.Text = "杀戮机器人"
killBotsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
killBotsButton.Font = Enum.Font.Gotham
killBotsButton.TextSize = 14 
killBotsButton.Parent = functionButtonContainer

local autoRotateBotsButton = Instance.new("TextButton")
autoRotateBotsButton.Name = "AutoRotateBots"
autoRotateBotsButton.Size = UDim2.new(1, -10, 0, 25)
autoRotateBotsButton.Position = UDim2.new(0, 10, 0, 30) 
autoRotateBotsButton.Text = "自动转向: 关闭"
autoRotateBotsButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
autoRotateBotsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoRotateBotsButton.Font = Enum.Font.SourceSans
autoRotateBotsButton.TextSize = 14 
autoRotateBotsButton.Visible = false 
autoRotateBotsButton.Parent = functionButtonContainer

local isKillingBots = false
local autoRotateBots = false
local killBotsConnection = nil

local function getMeleeWeapon()
    for _, item in pairs(AnimationController.Character:GetChildren()) do
        if item:GetAttribute("Melee") then
            return item
        end
    end
    for _, item in pairs(player.Backpack:GetChildren()) do
        if item:GetAttribute("Melee") then
            return item
        end
    end
    return nil
end

local function distance(target)
    if not AnimationController.Character or not target or not target:FindFirstChild("HumanoidRootPart") then
        return math.huge
    end
    return (target.HumanoidRootPart.Position - AnimationController.Character.HumanoidRootPart.Position).magnitude
end

local function rotateToTarget(target)
    if not autoRotateBots or not target or not target:FindFirstChild("HumanoidRootPart") then return end
    
    local humanoid = AnimationController.Humanoid
    local rootPart = AnimationController.Character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    
    local originalAutoRotate = humanoid.AutoRotate
    humanoid.AutoRotate = false
    
    local targetPos = target.HumanoidRootPart.Position
    local lookAtPos = Vector3.new(targetPos.X, rootPart.Position.Y, targetPos.Z)
    rootPart.CFrame = CFrame.lookAt(rootPart.Position, lookAtPos)
    
    humanoid.AutoRotate = originalAutoRotate
end

local function attackBot(bot)
    local weapon = getMeleeWeapon()
    if not weapon then return end
    
    if weapon.Parent ~= AnimationController.Character then
        weapon.Parent = AnimationController.Character
        task.wait(0.1)
    end
    
    if autoRotateBots then
        rotateToTarget(bot)
    end
    
    local remoteEvent = weapon:FindFirstChild("RemoteEvent")
    if not remoteEvent then return end
    
    local prepareArgs = {"PrepareSwing"}
    remoteEvent:FireServer(unpack(prepareArgs))
    local swingArgs = {"Swing", "Side"}
    remoteEvent:FireServer(unpack(swingArgs))
    local head = bot:FindFirstChild("Head")
    if head then
        local hitArgs = {
            "HitZombie",
            bot,
            head.Position,
            true
        }
        remoteEvent:FireServer(unpack(hitArgs))
    end
end

local function killBotsLoop()
    while isKillingBots and task.wait() do
        if not AnimationController.Character or AnimationController.Humanoid.Health <= 0 then
            break
        end

        local botsFolder = workspace:FindFirstChild("Bots")
        if botsFolder then
            for _, bot in ipairs(botsFolder:GetChildren()) do
                if bot:IsA("Model") and bot:FindFirstChild("HumanoidRootPart") then
                    if distance(bot) <= 15 then
                        attackBot(bot)
                        task.wait(0.01) 
                    end
                end
            end
        end
    end
end

killBotsButton.MouseButton1Click:Connect(function()
    isKillingBots = not isKillingBots
    
    if isKillingBots then
        killBotsButton.Text = "杀戮机器人(开)"
        killBotsButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        autoRotateBotsButton.Visible = true
        
        killBotsConnection = task.spawn(killBotsLoop)
    else
        killBotsButton.Text = "杀戮机器人"
        killBotsButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        autoRotateBotsButton.Visible = false
        
        if killBotsConnection then
            task.cancel(killBotsConnection)
            killBotsConnection = nil
        end
    end
end)

autoRotateBotsButton.MouseButton1Click:Connect(function()
    autoRotateBots = not autoRotateBots
    autoRotateBotsButton.Text = "自动转向: " .. (autoRotateBots and "开启" or "关闭")
    autoRotateBotsButton.BackgroundColor3 = autoRotateBots and Color3.fromRGB(39, 70, 45) or Color3.fromRGB(60, 60, 60)
end)

player.CharacterAdded:Connect(function()
    if isKillingBots then
        isKillingBots = false
        autoRotateBots = false
        killBotsButton.Text = "杀戮机器人"
        killBotsButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        autoRotateBotsButton.Text = "自动转向: 关闭"
        autoRotateBotsButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        autoRotateBotsButton.Visible = false
        
        if killBotsConnection then
            task.cancel(killBotsConnection)
            killBotsConnection = nil
        end
    end
end)

local autoAttackButton = Instance.new("TextButton")
autoAttackButton.Name = "AutoAttackPlayers"
autoAttackButton.Size = UDim2.new(1, -10, 0, 30)
autoAttackButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
autoAttackButton.Text = "PVP杀戮"
autoAttackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoAttackButton.Font = Enum.Font.Gotham
autoAttackButton.TextSize = 14
autoAttackButton.Parent = functionButtonContainer

local isAutoAttacking = false
local attackLoopConnection = nil
local ATTACK_RANGE = 15

local function getMeleeWeapon()
    for _, tool in ipairs(player.Character:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("MeleeBase") then
            return tool
        end
    end
    
    for _, tool in ipairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("MeleeBase") then
            return tool
        end
    end
    
    return nil
end

local function getDistance(target)
    if not player.Character or not target or not target:FindFirstChild("HumanoidRootPart") then
        return math.huge
    end
    return (target.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).magnitude
end

local function isSameTeam(targetPlayer)
    if not player.Team or not targetPlayer.Team then
        return false
    end
    return player.Team == targetPlayer.Team
end

local function attackPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    if isSameTeam(targetPlayer) then
        return
    end
    
    local weapon = getMeleeWeapon()
    if not weapon then return end

    if weapon.Parent ~= player.Character then
        weapon.Parent = player.Character
        task.wait(0.1)
    end
    
    local remoteEvent = weapon:FindFirstChild("RemoteEvent")
    if not remoteEvent then return end
    local prepareArgs = {"PrepareSwing"}
    remoteEvent:FireServer(unpack(prepareArgs))
    local swingArgs = {"Swing", "Side"}
    remoteEvent:FireServer(unpack(swingArgs))
    local head = targetPlayer.Character:FindFirstChild("Head")
    if head then
        local hitArgs = {
            "HitPlayer",
            targetPlayer.Character:FindFirstChild("Humanoid"),
            head.Position 
        }
        remoteEvent:FireServer(unpack(hitArgs))
    end
end

local function autoAttackLoop()
    while isAutoAttacking and task.wait() do
        if not player.Character or player.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
            break
        end
    
        for _, targetPlayer in ipairs(game:GetService("Players"):GetPlayers()) do
            if targetPlayer ~= player and targetPlayer.Character and 
               targetPlayer.Character:FindFirstChild("Humanoid") and 
               targetPlayer.Character.Humanoid.Health > 0 and
               not isSameTeam(targetPlayer) then
                if getDistance(targetPlayer.Character) <= ATTACK_RANGE then
                    attackPlayer(targetPlayer)
                    task.wait(0.01) 
                end
            end
        end
    end
end

autoAttackButton.MouseButton1Click:Connect(function()
    isAutoAttacking = not isAutoAttacking
    
    if isAutoAttacking then
        autoAttackButton.Text = "PVP杀戮(开)"
        autoAttackButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        
        attackLoopConnection = task.spawn(autoAttackLoop)
    else
        autoAttackButton.Text = "PVP杀戮"
        autoAttackButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        
        if attackLoopConnection then
            task.cancel(attackLoopConnection)
            attackLoopConnection = nil
        end
    end
end)

player.CharacterAdded:Connect(function()
    if isAutoAttacking then
        isAutoAttacking = false
        autoAttackButton.Text = "PVP杀戮"
        autoAttackButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        
        if attackLoopConnection then
            task.cancel(attackLoopConnection)
            attackLoopConnection = nil
        end
    end
end)

local autoAttackButton = Instance.new("TextButton")
autoAttackButton.Name = "AutoAttackPlayers"
autoAttackButton.Size = UDim2.new(1, -10, 0, 30)
autoAttackButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
autoAttackButton.Text = "刺刀PVP杀戮"
autoAttackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoAttackButton.Font = Enum.Font.Gotham
autoAttackButton.TextWrapped = true
autoAttackButton.TextSize = 14
autoAttackButton.Parent = functionButtonContainer

local isAutoAttacking = false
local attackLoopConnection = nil
local ATTACK_RANGE = 17

local function getMusket()
    for _, tool in ipairs(player.Character:GetChildren()) do
        if tool:IsA("Tool") and tool.Name == "Musket" then
            return tool
        end
    end
    
    for _, tool in ipairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name == "Musket" then
            return tool
        end
    end
    
    return nil
end

local function getDistance(target)
    if not player.Character or not target or not target:FindFirstChild("HumanoidRootPart") then
        return math.huge
    end
    return (target.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).magnitude
end

local function isSameTeam(targetPlayer)
    if not player.Team or not targetPlayer.Team then
        return false
    end
    return player.Team == targetPlayer.Team
end

local function attackPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    
    if isSameTeam(targetPlayer) then
        return
    end
    
    local weapon = getMusket()
    if not weapon then return end
    
    if weapon.Parent ~= player.Character then
        weapon.Parent = player.Character
        task.wait(0.1)
    end
    
    local remoteEvent = weapon:FindFirstChild("RemoteEvent")
    if not remoteEvent then return end
    
    local prepareArgs = {"ThrustBayonet"}
    remoteEvent:FireServer(unpack(prepareArgs))
    
    local head = targetPlayer.Character:FindFirstChild("Head")
    if head then
        local hitArgs = {
            "Bayonet_HitPlayer",
            targetPlayer.Character:FindFirstChild("Humanoid"),
            head.Position 
        }
        remoteEvent:FireServer(unpack(hitArgs))
    end
end

local function autoAttackLoop()
    while isAutoAttacking and task.wait() do
        if not player.Character or player.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
            break
        end
        
        for _, targetPlayer in ipairs(game:GetService("Players"):GetPlayers()) do
            if targetPlayer ~= player and targetPlayer.Character and 
               targetPlayer.Character:FindFirstChild("Humanoid") and 
               targetPlayer.Character.Humanoid.Health > 0 and
               not isSameTeam(targetPlayer) then
                
                if getDistance(targetPlayer.Character) <= ATTACK_RANGE then
                    attackPlayer(targetPlayer)
                    task.wait(0.01)
                end
            end
        end
    end
end

autoAttackButton.MouseButton1Click:Connect(function()
    isAutoAttacking = not isAutoAttacking
    
    if isAutoAttacking then
        autoAttackButton.Text = "刺刀PVP杀戮(开)"
        autoAttackButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        attackLoopConnection = task.spawn(autoAttackLoop)
    else
        autoAttackButton.Text = "刺刀PVP杀戮"
        autoAttackButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        if attackLoopConnection then
            task.cancel(attackLoopConnection)
            attackLoopConnection = nil
        end
    end
end)

player.CharacterAdded:Connect(function()
    if isAutoAttacking then
        isAutoAttacking = false
        autoAttackButton.Text = "刺刀PVP杀戮"
        autoAttackButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        if attackLoopConnection then
            task.cancel(attackLoopConnection)
            attackLoopConnection = nil
        end
    end
end)

local axeStunButton = Instance.new("TextButton")
axeStunButton.Name = "AxeStun"
axeStunButton.Size = UDim2.new(1, -10, 0, 30)
axeStunButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
axeStunButton.Text = "肘击"
axeStunButton.TextColor3 = Color3.fromRGB(255, 255, 255)
axeStunButton.Font = Enum.Font.Gotham
axeStunButton.TextSize = 14
axeStunButton.Parent = functionButtonContainer

local axeStunData = {
    Instance = axeStunButton,
    IsActive = false,
    Tracks = {},
    Connections = {}
}
self.ActiveButtons["AxeStun"] = axeStunData

local isAxeStunActive = false
local axeStunConnection = nil

local function getMelee()
    for _, item in pairs(AnimationController.Character:GetChildren()) do
        if item:GetAttribute("Melee") then
            return item
        end
    end

    for _, item in pairs(player.Backpack:GetChildren()) do
        if item:GetAttribute("Melee") then
            return item
        end
    end
    return nil
end

local function executeStun(zombie)
    local weapon = getMelee()
    if not weapon or weapon.Name ~= "Axe" then return end
    if zombie.State.Value == "Stunned" then return end
    
    weapon.RemoteEvent:FireServer("BraceBlock")
    weapon.RemoteEvent:FireServer("StopBraceBlock")
    
    local Feed = {
        "FeedbackStun",
        zombie,
        zombie.HumanoidRootPart.CFrame.Position
    }
    weapon.RemoteEvent:FireServer(unpack(Feed))
end

axeStunButton.MouseButton1Click:Connect(function()
    isAxeStunActive = not isAxeStunActive
    
    if isAxeStunActive then
        axeStunButton.Text = "肘击"
        axeStunButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        
        axeStunConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not isAxeStunActive or not AnimationController.Character or AnimationController.Humanoid.Health <= 0 then return end
            
            for _, zombie in pairs(workspace.Zombies:GetChildren()) do
                if zombie:IsA("Model") and zombie:FindFirstChild("HumanoidRootPart") then
                    local distance = (zombie.HumanoidRootPart.Position - AnimationController.Character.HumanoidRootPart.Position).Magnitude
                    if distance <= 15 then
                        executeStun(zombie)
                    end
                end
            end
        end)
    else
        axeStunButton.Text = "肘击"
        axeStunButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        
        if axeStunConnection then
            axeStunConnection:Disconnect()
            axeStunConnection = nil
        end
    end
end)

player.CharacterAdded:Connect(function(character)
    if axeStunConnection then
        axeStunConnection:Disconnect()
        axeStunConnection = nil
    end
    isAxeStunActive = false
    axeStunButton.Text = "肘击"
    axeStunButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
end)

local carbineStunButton = Instance.new("TextButton")
carbineStunButton.Name = "CarbineCombo"
carbineStunButton.Size = UDim2.new(1, -10, 0, 30)
carbineStunButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
carbineStunButton.Text = "卡宾枪肘击(多目标)"
carbineStunButton.TextColor3 = Color3.fromRGB(255, 255, 255)
carbineStunButton.Font = Enum.Font.Gotham
carbineStunButton.TextSize = 14
carbineStunButton.Parent = functionButtonContainer

local carbineComboData = {
    Instance = carbineStunButton,
    IsActive = false,
    Tracks = {},
    Connections = {}
}
self.ActiveButtons["CarbineCombo"] = carbineComboData

local isComboActive = false
local comboConnection = nil

local function getZombiesInRange()
    if not AnimationController.Character then return {} end
    
    local humanoidRootPart = AnimationController.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return {} end
    
    local zombies = {}
    local playerPos = humanoidRootPart.Position
    
    for _, zombie in pairs(workspace.Zombies:GetChildren()) do
        if zombie:IsA("Model") and zombie:FindFirstChild("HumanoidRootPart") then
            local distance = (zombie.HumanoidRootPart.Position - playerPos).Magnitude
            if distance <= 15 then
                table.insert(zombies, zombie)
            end
        end
    end
    
    table.sort(zombies, function(a, b)
        return (a.HumanoidRootPart.Position - playerPos).Magnitude < 
               (b.HumanoidRootPart.Position - playerPos).Magnitude
    end)
    
    return zombies
end

local function executeCarbineComboMulti()
    local character = player.Character
    if not character then return end
    
    local carbine = player.Backpack:FindFirstChild("Carbine") or character:FindFirstChild("Carbine")
    if not carbine then return end
    
    local remoteEvent = carbine:FindFirstChild("RemoteEvent")
    if not remoteEvent then return end
    
    local shoveArgs = {"Shove"}
    remoteEvent:FireServer(unpack(shoveArgs))
    
    task.wait(0.2)
    
    local zombies = getZombiesInRange()
    local maxTargets = math.min(10, #zombies)
    
    for i = 1, maxTargets do
        local zombie = zombies[i]
        local stunArgs = {
            "FeedbackStun",
            zombie,
            zombie.HumanoidRootPart.CFrame.Position
        }
        remoteEvent:FireServer(unpack(stunArgs))
        
        if i < maxTargets then
            task.wait(0.1)
        end
    end
end

carbineStunButton.MouseButton1Click:Connect(function()
    isComboActive = not isComboActive
    
    if isComboActive then
        carbineStunButton.Text = "卡宾枪肘击(多目标)"
        carbineStunButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        
        comboConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not isComboActive or not AnimationController.Character or AnimationController.Humanoid.Health <= 0 then return end
            executeCarbineComboMulti()
            task.wait(0.01)
        end)
    else
        carbineStunButton.Text = "卡宾枪肘击(多目标)"
        carbineStunButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        
        if comboConnection then
            comboConnection:Disconnect()
            comboConnection = nil
        end
    end
end)

player.CharacterAdded:Connect(function(character)
    if comboConnection then
        comboConnection:Disconnect()
        comboConnection = nil
    end
    isComboActive = false
    carbineStunButton.Text = "卡宾枪肘击(多目标)"
    carbineStunButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
end)


local autorepairButton = Instance.new("TextButton")
autorepairButton.Name = "AutorepairButton"
autorepairButton.Size = UDim2.new(1, -10, 0, 30)
autorepairButton.Text = "自动修复建筑"
autorepairButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
autorepairButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autorepairButton.Font = Enum.Font.SourceSansBold
autorepairButton.TextSize = 14
autorepairButton.Parent = functionButtonContainer

local repairOthersButton = Instance.new("TextButton")
repairOthersButton.Name = "RepairOthersButton"
repairOthersButton.Size = UDim2.new(1, -20, 0, 25)
repairOthersButton.Position = UDim2.new(0, 10, 0, 35)
repairOthersButton.Text = "修复他人建筑: 关闭"
repairOthersButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
repairOthersButton.TextColor3 = Color3.fromRGB(255, 255, 255)
repairOthersButton.Font = Enum.Font.SourceSans
repairOthersButton.TextSize = 12
repairOthersButton.Visible = false
repairOthersButton.Parent = functionButtonContainer

local AutorepairT = false
local RepairOthersT = false
local autorepairConnection = nil

local function FindAndRepairNearestBuilding(includeOthers)
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    local workspace = game:GetService("Workspace")
    local camera = game:GetService("Workspace").CurrentCamera
    local character = localPlayer.Character
    
    if not character then return end
    
    local playerId = tostring(localPlayer.UserId)
    local buildingsFolder = workspace:FindFirstChild("Buildings")
    
    if not buildingsFolder then return end
    
    local minDistance = math.huge
    local nearestBuildingHealth = nil
    local screenCenterX = camera.ViewportSize.X / 2
    local screenCenterY = camera.ViewportSize.Y / 2

    local function checkAndSetNearest(model)
        local buildingHealth = model:FindFirstChild("BuildingHealth")
        if buildingHealth then
            local hitbox = model:FindFirstChild("Hitbox")
            if hitbox then
                local screenPosition, onScreen = camera:WorldToScreenPoint(hitbox.CFrame.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPosition.X, screenPosition.Y) - Vector2.new(screenCenterX, screenCenterY)).Magnitude
                    if distance < minDistance then
                        minDistance = distance
                        nearestBuildingHealth = buildingHealth
                    end
                end
            end
        end
    end

    local playerSpecificFolder = buildingsFolder:FindFirstChild(playerId)
    if playerSpecificFolder then
        for _, model in ipairs(playerSpecificFolder:GetChildren()) do
            if model:IsA("Model") then
                checkAndSetNearest(model)
            end
        end
    end

    if includeOthers then
        for _, folder in ipairs(buildingsFolder:GetChildren()) do
            if folder:IsA("Folder") and folder.Name ~= playerId then
                for _, model in ipairs(folder:GetChildren()) do
                    if model:IsA("Model") then
                        checkAndSetNearest(model)
                    end
                end
            end
        end
    end

    local caltrops = workspace:FindFirstChild("Caltrops")
    if caltrops and caltrops:IsA("Model") then
        checkAndSetNearest(caltrops)
    end

    local stakes = workspace:FindFirstChild("Stakes")
    if stakes then
        checkAndSetNearest(stakes)
    end

    if nearestBuildingHealth then
        local args = {
            [1] = "Repair",
            [2] = nearestBuildingHealth,
        }
        local hammer = character:FindFirstChild("Hammer")
        if hammer then
            local remoteEvent = hammer:FindFirstChild("RemoteEvent")
            if remoteEvent then
                remoteEvent:FireServer(unpack(args))
            end
        end
    end
end

local function Autorepair()
    while AutorepairT and task.wait(0.01) do
        FindAndRepairNearestBuilding(RepairOthersT)
    end
end

autorepairButton.MouseButton1Click:Connect(function()
    AutorepairT = not AutorepairT
    
    if AutorepairT then
        autorepairButton.Text = "自动修复建筑: 开启"
        autorepairButton.BackgroundColor3 = Color3.fromRGB(9, 137, 207)
        repairOthersButton.Visible = true
        autorepairConnection = task.spawn(Autorepair)
    else
        autorepairButton.Text = "自动修复建筑: 关闭"
        autorepairButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        repairOthersButton.Visible = false
        if autorepairConnection then
            task.cancel(autorepairConnection)
            autorepairConnection = nil
        end
    end
end)

repairOthersButton.MouseButton1Click:Connect(function()
    RepairOthersT = not RepairOthersT
    repairOthersButton.Text = "修复他人建筑: " .. (RepairOthersT and "开启" or "关闭")
    repairOthersButton.BackgroundColor3 = RepairOthersT and Color3.fromRGB(9, 137, 207) or Color3.fromRGB(60, 60, 60)
end)

Players.LocalPlayer.CharacterAdded:Connect(function()
    if AutorepairT then
        AutorepairT = false
        RepairOthersT = false
        autorepairButton.Text = "自动修复建筑: 关闭"
        autorepairButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        repairOthersButton.Text = "修复他人建筑: 关闭"
        repairOthersButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        repairOthersButton.Visible = false
        if autorepairConnection then
            task.cancel(autorepairConnection)
            autorepairConnection = nil
        end
    end
end)


local repairButton = Instance.new("TextButton")
repairButton.Name = "AutoRepairNearest"
repairButton.Size = UDim2.new(1, -10, 0, 30)
repairButton.Text = "自动修桥"
repairButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
repairButton.TextColor3 = Color3.fromRGB(255, 255, 255)
repairButton.Font = Enum.Font.SourceSansBold
repairButton.TextSize = 14
repairButton.Parent = functionButtonContainer

local repairing = false
local repairConnection

local function getNearestConstruct()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        return
    end
    local root = char.HumanoidRootPart

    local bridge =
        workspace:WaitForChild("Berezina"):WaitForChild("Modes"):WaitForChild("Holdout"):WaitForChild("Bridge")

    local nearest, dist = nil, math.huge

    for _, section in ipairs(bridge:GetChildren()) do
        local posts = section:FindFirstChild("Posts")
        if posts then
            for _, part in ipairs(posts:GetChildren()) do
                if part:IsA("BasePart") and part:FindFirstChild("ConstructHealth") then
                    local d = (part.Position - root.Position).Magnitude
                    if d < dist then
                        dist = d
                        nearest = part.ConstructHealth
                    end
                end
            end
        end

        local beam = section:FindFirstChild("Beam")
        if beam and beam:FindFirstChild("ConstructHealth") then
            local d = (beam.Position - root.Position).Magnitude
            if d < dist then
                dist = d
                nearest = beam.ConstructHealth
            end
        end

        for _, joists in ipairs(section:GetChildren()) do
            if joists.Name == "Joists" and joists:FindFirstChild("ConstructHealth") then
                local d = (joists.Position - root.Position).Magnitude
                if d < dist then
                    dist = d
                    nearest = joists.ConstructHealth
                end
            end
        end
    end

    return nearest
end

local function doRepair()
    local target = getNearestConstruct()
    if not target then
        return
    end

    local hammer = player.Backpack:FindFirstChild("Hammer") or player.Backpack:FindFirstChild("Claw Hammer")
    if not hammer or not hammer:FindFirstChild("RemoteEvent") then
        return
    end

    local args = {"Repair", target}
    hammer.RemoteEvent:FireServer(unpack(args))
end

repairButton.MouseButton1Click:Connect(
    function()
        repairing = not repairing
        if repairing then
            repairButton.Text = "自动修桥"
            repairButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            repairConnection =
                game:GetService("RunService").Heartbeat:Connect(
                function()
                    doRepair()
                end
            )
        else
            repairButton.Text = "自动修桥"
            repairButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            if repairConnection then
                repairConnection:Disconnect()
                repairConnection = nil
            end
        end
    end
)

local autoLogButton = Instance.new("TextButton")
autoLogButton.Name = "AutoLogButton"
autoLogButton.Size = UDim2.new(1, -10, 0, 30)
autoLogButton.Text = "自动拿木头"
autoLogButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
autoLogButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoLogButton.Font = Enum.Font.SourceSansBold
autoLogButton.TextSize = 14
autoLogButton.Parent = functionButtonContainer

local autoLogEnabled = false
local autoLogConnection = nil

autoLogButton.MouseButton1Click:Connect(
    function()
        autoLogEnabled = not autoLogEnabled

        if autoLogEnabled then
            autoLogButton.Text = "自动拿木头"
            autoLogButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)

            autoLogConnection =
                task.spawn(
                function()
                    while autoLogEnabled and task.wait(0.01) do
                        local remoteEvent =
                            workspace:FindFirstChild("Berezina") and workspace.Berezina:FindFirstChild("Modes") and
                            workspace.Berezina.Modes:FindFirstChild("Holdout") and
                            workspace.Berezina.Modes.Holdout:FindFirstChild("Log") and
                            workspace.Berezina.Modes.Holdout.Log:FindFirstChild("Log") and
                            workspace.Berezina.Modes.Holdout.Log.Log:FindFirstChild("Interact")

                        if remoteEvent and remoteEvent:IsA("RemoteEvent") then
                            pcall(
                                function()
                                    remoteEvent:FireServer()
                                end
                            )
                        end
                    end
                end
            )
        else
            autoLogButton.Text = "自动拿木头"
            autoLogButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)

            if autoLogConnection then
                task.cancel(autoLogConnection)
                autoLogConnection = nil
            end
        end
    end
)

player.CharacterAdded:Connect(
    function()
        if autoLogEnabled then
            autoLogEnabled = false
            autoLogButton.Text = "自动拿木头"
            autoLogButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            if autoLogConnection then
                task.cancel(autoLogConnection)
                autoLogConnection = nil
            end
        end
    end
)

local autoInteractButton = Instance.new("TextButton")
autoInteractButton.Name = "AutoInteractButton"
autoInteractButton.Size = UDim2.new(1, -10, 0, 30)
autoInteractButton.Text = "自动放置木头"
autoInteractButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
autoInteractButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoInteractButton.Font = Enum.Font.SourceSansBold
autoInteractButton.TextSize = 14
autoInteractButton.Parent = functionButtonContainer

local autoInteractEnabled = false
local autoInteractConnection = nil

autoInteractButton.MouseButton1Click:Connect(
    function()
        autoInteractEnabled = not autoInteractEnabled

        if autoInteractEnabled then
            autoInteractButton.Text = "自动放置木头"
            autoInteractButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            autoInteractConnection =
                task.spawn(
                function()
                    while autoInteractEnabled and task.wait(0.01) do
                        for _, prompt in pairs(workspace:GetDescendants()) do
                            if prompt:IsA("ProximityPrompt") and prompt.Name == "PlaceLogProximityPrompt" then
                                pcall(
                                    function()
                                        fireproximityprompt(prompt)
                                    end
                                )
                            end
                        end
                    end
                end
            )
        else
            autoInteractButton.Text = "自动放置木头"
            autoInteractButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)

            if autoInteractConnection then
                task.cancel(autoInteractConnection)
                autoInteractConnection = nil
            end
        end
    end
)

player.CharacterAdded:Connect(
    function()
        if autoInteractEnabled then
            autoInteractEnabled = false
            autoInteractButton.Text = "自动放置木头"
            autoInteractButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            if autoInteractConnection then
                task.cancel(autoInteractConnection)
                autoInteractConnection = nil
            end
        end
    end
)


local noSlowButton = Instance.new("TextButton")
noSlowButton.Name = "NoSlow"
noSlowButton.Size = UDim2.new(1, -10, 0, 30)
noSlowButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
noSlowButton.Text = "无减速"
noSlowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noSlowButton.Font = Enum.Font.Gotham
noSlowButton.TextSize = 14
noSlowButton.Parent = functionButtonContainer

local noSlowData = {
    Instance = noSlowButton,
    IsActive = false,
    Tracks = {},
    Connections = {}
}
self.ActiveButtons["NoSlow"] = noSlowData

local noSlowActive = false
local walkSpeedConnection = nil
local characterAddedConnection = nil

local function setupNoSlow()
    if not AnimationController.Character then return end
    
    local humanoid = AnimationController.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    if walkSpeedConnection then
        walkSpeedConnection:Disconnect()
        walkSpeedConnection = nil
    end
    
    walkSpeedConnection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if noSlowActive and humanoid.WalkSpeed < 16 then
            humanoid.WalkSpeed = 16
        end
    end)
    
    if noSlowActive and humanoid.WalkSpeed < 16 then
        humanoid.WalkSpeed = 16
    end
end

noSlowButton.MouseButton1Click:Connect(function()
    noSlowActive = not noSlowActive
    
    if noSlowActive then
        noSlowButton.Text = "无减速"
        noSlowButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        
        setupNoSlow()
        
        if characterAddedConnection then
            characterAddedConnection:Disconnect()
        end
        characterAddedConnection = player.CharacterAdded:Connect(function()
            task.wait(1)
            setupNoSlow()
        end)
    else
        noSlowButton.Text = "无减速"
        noSlowButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        
        if walkSpeedConnection then
            walkSpeedConnection:Disconnect()
            walkSpeedConnection = nil
        end
        if characterAddedConnection then
            characterAddedConnection:Disconnect()
            characterAddedConnection = nil
        end
    end
end)

if AnimationController.Character then
    setupNoSlow()
end

game:GetService("Players").PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        if walkSpeedConnection then
            walkSpeedConnection:Disconnect()
        end
        if characterAddedConnection then
            characterAddedConnection:Disconnect()
        end
    end
end)

local kaubCollectButton = Instance.new("TextButton")
kaubCollectButton.Name = "KaubAutoCollect"
kaubCollectButton.Size = UDim2.new(1, -10, 0, 30)
kaubCollectButton.Text = "Kaub自动收集"
kaubCollectButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
kaubCollectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
kaubCollectButton.Font = Enum.Font.SourceSansBold
kaubCollectButton.TextSize = 14
kaubCollectButton.Parent = functionButtonContainer

local isKaubCollecting = false
local kaubConnection = nil
local activePrompts = {}

local function setupKaubAutoCollect()
    local kaubFolder = workspace:FindFirstChild("Kaub")
    if not kaubFolder then 
        warn("66压根没在卡布地图你用个几把")
        return 
    end


    for _, descendant in ipairs(workspace:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") then
            activePrompts[descendant] = true
        end
    end

    local descendantAddedConn = workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("ProximityPrompt") then
            activePrompts[descendant] = true
        end
    end)

    kaubConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not isKaubCollecting or not player.Character then return end
        
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        for prompt, _ in pairs(activePrompts) do
            if prompt and prompt.Parent and prompt:IsA("ProximityPrompt") and prompt.Enabled then
                local part = prompt.Parent
                if part:IsA("BasePart") then
                    local distance = (part.Position - hrp.Position).Magnitude
                    if distance <= prompt.MaxActivationDistance then
                        fireproximityprompt(prompt)
                    end
                end
            else
                activePrompts[prompt] = nil
            end
        end
    end)

    return descendantAddedConn
end

kaubCollectButton.MouseButton1Click:Connect(function()
    isKaubCollecting = not isKaubCollecting
    
    if isKaubCollecting then
        kaubCollectButton.Text = "Kaub自动收集"
        kaubCollectButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        
        local descendantConn = setupKaubAutoCollect()
        
        kaubCollectButton.DescendantAddedConn = descendantConn
    else
        kaubCollectButton.Text = "Kaub自动收集"
        kaubCollectButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        
        if kaubConnection then
            kaubConnection:Disconnect()
            kaubConnection = nil
        end
        if kaubCollectButton.DescendantAddedConn then
            kaubCollectButton.DescendantAddedConn:Disconnect()
            kaubCollectButton.DescendantAddedConn = nil
        end
        activePrompts = {}
    end
end)

player.CharacterAdded:Connect(function()
    if isKaubCollecting then
        isKaubCollecting = false
        kaubCollectButton.Text = "Kaub自动收集"
        kaubCollectButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        
        if kaubConnection then
            kaubConnection:Disconnect()
            kaubConnection = nil
        end
        if kaubCollectButton.DescendantAddedConn then
            kaubCollectButton.DescendantAddedConn:Disconnect()
            kaubCollectButton.DescendantAddedConn = nil
        end
        activePrompts = {}
    end
end)

local zombieVisionButton = Instance.new("TextButton")
zombieVisionButton.Name = "ZombieVision"
zombieVisionButton.Size = UDim2.new(1, -10, 0, 30)
zombieVisionButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
zombieVisionButton.Text = "透视僵尸关闭🤔"
zombieVisionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
zombieVisionButton.Font = Enum.Font.Gotham
zombieVisionButton.TextSize = 14
zombieVisionButton.Parent = functionButtonContainer

local zombieVisionData = {
    Instance = zombieVisionButton,
    IsActive = false,
    Tracks = {},
    Connections = {}
}
self.ActiveButtons["ZombieVision"] = zombieVisionData

local zombieTags = {}
local draculaTag = nil
local headlessHorsemanTag = nil
local visionConnection = nil
local bossESPConnection = nil

local ZOMBIE_TYPES = {
    ["Axe"] = {
        name = "大师兄Zapper",
        color = Color3.fromRGB(180, 0, 250),
        size = UDim2.new(0, 120, 0, 30),
        priority = 1
    },
    ["Eye"] = {
        name = "红眼Runner",
        color = Color3.fromRGB(255, 50, 50),
        size = UDim2.new(0, 100, 0, 30),
        priority = 2
    },
    ["Sword"] = {
        name = "二师兄",
        color = Color3.fromRGB(456,13,56),
        size = UDim2.new(0, 100, 0, 30),
        priority = 2
    },
    ["Barrel"] = {
        name = "自爆Boomber",
        color = Color3.fromRGB(250, 250, 0),
        size = UDim2.new(0, 120, 0, 30),
        priority = 3
    },
    ["FTorso"] = {
        name = "提灯人_Light",
        color = Color3.fromRGB(255, 120, 0),
        size = UDim2.new(0, 120, 0, 30),
        priority = 4
    }
}

-- 德古拉配置
local DRACULA_CONFIG = {
    name = "德古拉",
    color = Color3.fromRGB(43, 255, 0),
    size = UDim2.new(0, 150, 0, 40),
    priority = 0  -- 最高优先级
}

-- 无头骑士配置
local HEADLESS_HORSEMAN_CONFIG = {
    name = "无头骑士",
    color = Color3.fromRGB(255,0,0),  -- 红色
    size = UDim2.new(0, 100, 0, 25),
    priority = -1  -- 比德古拉优先级更高
}

local function findZombies()
    local zombies = {}
    local cameraFolder = workspace:FindFirstChild("Camera")
    
    if cameraFolder then
        for _, model in pairs(cameraFolder:GetDescendants()) do
            if model:IsA("Model") and model.Name:find("Zombie") then
                table.insert(zombies, model)
            end
        end
    end
    
    return zombies
end

local function findDracula()
    local dracula = workspace:FindFirstChild("Transylvania") and 
                   workspace.Transylvania:FindFirstChild("Modes") and
                   workspace.Transylvania.Modes:FindFirstChild("Boss") and
                   workspace.Transylvania.Modes.Boss:FindFirstChild("Dracula")
    return dracula
end

local function findHeadlessHorseman()
    -- 在workspace中查找无头骑士
    for _, model in pairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model.Name == "HeadlessHorseman" then
            return model
        end
    end
    return nil
end

local function getZombieConfig(zombie)
    local highestPriority = math.huge
    local bestConfig = nil
    
    for partName, config in pairs(ZOMBIE_TYPES) do
        if zombie:FindFirstChild(partName) and config.priority < highestPriority then
            highestPriority = config.priority
            bestConfig = config
        end
    end
    
    return bestConfig
end

local function createZombieTag(zombie)
    local zombieConfig = getZombieConfig(zombie)
    if not zombieConfig then return end
    
    if zombieTags[zombie] then
        zombieTags[zombie]:Destroy()
    end
    
    local attachPart = zombie.PrimaryPart or zombie:FindFirstChild("Head") or zombie:FindFirstChild("HumanoidRootPart")
    if not attachPart then return end
    
    local tag = Instance.new("BillboardGui")
    tag.Name = "ZombieTag"
    tag.Size = zombieConfig.size
    tag.StudsOffset = Vector3.new(0, 2.5, 0)
    tag.AlwaysOnTop = true
    tag.Adornee = attachPart
    tag.MaxDistance = 0
    tag.Parent = zombie
    
    local label = Instance.new("TextLabel")
    label.Text = zombieConfig.name
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = zombieConfig.color
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextStrokeTransparency = 0.5
    label.Parent = tag
    
    zombieTags[zombie] = tag
end

local function createDraculaTag(dracula)
    if draculaTag then
        draculaTag:Destroy()
        draculaTag = nil
    end
    
    local attachPart = dracula.PrimaryPart or dracula:FindFirstChild("Head") or dracula:FindFirstChild("HumanoidRootPart")
    if not attachPart then return end
    
    local tag = Instance.new("BillboardGui")
    tag.Name = "DraculaTag"
    tag.Size = DRACULA_CONFIG.size
    tag.StudsOffset = Vector3.new(0, 3, 0)  -- 比普通僵尸高一点
    tag.AlwaysOnTop = true
    tag.Adornee = attachPart
    tag.MaxDistance = 0
    tag.Parent = dracula
    
    local label = Instance.new("TextLabel")
    label.Text = DRACULA_CONFIG.name
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = DRACULA_CONFIG.color
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16  -- 比普通僵尸大一点
    label.TextStrokeTransparency = 0.3
    label.Parent = tag
    
    draculaTag = tag
end

local function createHeadlessHorsemanTag(horseman)
    if headlessHorsemanTag then
        headlessHorsemanTag:Destroy()
        headlessHorsemanTag = nil
    end
    
    local attachPart = horseman.PrimaryPart or horseman:FindFirstChild("HumanoidRootPart")
    if not attachPart then return end
    
    local tag = Instance.new("BillboardGui")
    tag.Name = "HeadlessHorsemanTag"
    tag.Size = HEADLESS_HORSEMAN_CONFIG.size
    tag.StudsOffset = Vector3.new(0, 3.5, 0)  -- 比德古拉更高
    tag.AlwaysOnTop = true
    tag.Adornee = attachPart
    tag.MaxDistance = 0
    tag.Parent = horseman
    
    local label = Instance.new("TextLabel")
    label.Text = HEADLESS_HORSEMAN_CONFIG.name
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = HEADLESS_HORSEMAN_CONFIG.color
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextStrokeTransparency = 0.3
    label.Parent = tag
    
    headlessHorsemanTag = tag
end

local function clearZombieTags()
    for zombie, tag in pairs(zombieTags) do
        if tag and tag.Parent then
            tag:Destroy()
        end
    end
    zombieTags = {}
    
    if draculaTag then
        draculaTag:Destroy()
        draculaTag = nil
    end
    
    if headlessHorsemanTag then
        headlessHorsemanTag:Destroy()
        headlessHorsemanTag = nil
    end
end

local function setupBossESP()
    -- 只在找到无头骑士时才启动监听
    local headlessHorseman = findHeadlessHorseman()
    if not headlessHorseman then
        return  -- 没有无头骑士，不启动监听
    end
    
    -- 监听新出现的无头骑士
    if bossESPConnection then
        bossESPConnection:Disconnect()
    end
    
    bossESPConnection = workspace.DescendantAdded:Connect(function(inst)
        if inst.Name == "HumanoidRootPart" and inst.Parent.Name == "HeadlessHorseman" then
            createHeadlessHorsemanTag(inst.Parent)
        end
    end)
    
    -- 为已存在的无头骑士创建标签
    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name == "HumanoidRootPart" and v.Parent.Name == "HeadlessHorseman" then
            createHeadlessHorsemanTag(v.Parent)
        end
    end
end

local function updateZombieTags()
    -- 清理不存在的僵尸标签
    for zombie, tag in pairs(zombieTags) do
        if not zombie.Parent then
            tag:Destroy()
            zombieTags[zombie] = nil
        end
    end
    
    -- 更新普通僵尸标签
    local zombies = findZombies()
    for _, zombie in pairs(zombies) do
        if not zombieTags[zombie] then
            createZombieTag(zombie)
        end
    end
    
    -- 更新德古拉标签
    local dracula = findDracula()
    if dracula then
        if not draculaTag or draculaTag.Parent ~= dracula then
            createDraculaTag(dracula)
        end
    else
        if draculaTag then
            draculaTag:Destroy()
            draculaTag = nil
        end
    end
    
    -- 只在找到无头骑士时才更新标签
    local headlessHorseman = findHeadlessHorseman()
    if headlessHorseman then
        if not headlessHorsemanTag or headlessHorsemanTag.Parent ~= headlessHorseman then
            createHeadlessHorsemanTag(headlessHorseman)
        end
    else
        if headlessHorsemanTag then
            headlessHorsemanTag:Destroy()
            headlessHorsemanTag = nil
        end
    end
end

local function toggleVision()
    zombieVisionData.IsActive = not zombieVisionData.IsActive
    
    if zombieVisionData.IsActive then
        zombieVisionButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        zombieVisionButton.Text = "透视僵尸开启😡"
        updateZombieTags()
        
        -- 只在找到无头骑士时才启动ESP监听
        if findHeadlessHorseman() then
            setupBossESP()
        end
        
        visionConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not zombieVisionData.IsActive then return end
            -- 降低更新频率，每0.5秒更新一次，减少性能消耗
            if tick() % 0.5 < 0.016 then
                updateZombieTags()
            end
        end)
    else
        zombieVisionButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        zombieVisionButton.Text = "透视僵尸关闭🤔"
        clearZombieTags()
        if visionConnection then
            visionConnection:Disconnect()
            visionConnection = nil
        end
        if bossESPConnection then
            bossESPConnection:Disconnect()
            bossESPConnection = nil
        end
    end
end

zombieVisionButton.MouseButton1Click:Connect(toggleVision)

player.CharacterAdded:Connect(function(character)
    -- 角色重生时强制关闭透视
    if zombieVisionData.IsActive then
        zombieVisionData.IsActive = false
        clearZombieTags()
        if visionConnection then
            visionConnection:Disconnect()
            visionConnection = nil
        end
        if bossESPConnection then
            bossESPConnection:Disconnect()
            bossESPConnection = nil
        end
        zombieVisionButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        zombieVisionButton.Text = "透视僵尸关闭🤔"
    end
end)

player.CharacterRemoving:Connect(function()
    -- 角色死亡时强制关闭透视
    if zombieVisionData.IsActive then
        clearZombieTags()
        if visionConnection then
            visionConnection:Disconnect()
            visionConnection = nil
        end
        if bossESPConnection then
            bossESPConnection:Disconnect()
            bossESPConnection = nil
        end
    end
end)

game:GetService("Players").PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        clearZombieTags()
        if visionConnection then
            visionConnection:Disconnect()
        end
        if bossESPConnection then
            bossESPConnection:Disconnect()
        end
    end
end)

local button = Instance.new("TextButton")
button.Name = "ToggleHeadEffect"
button.Size = UDim2.new(1, -10, 0, 30)
button.Text = "🤓大头娃娃山伯乐"
button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = functionButtonContainer

local originalProperties = {}
local isEffectApplied = false

local function processZombies()
    for _, zombie in ipairs(workspace.Camera:GetDescendants()) do
        if zombie.Name == "m_Zombie" and zombie:FindFirstChild("Head") then
            local head = zombie.Head
            if isEffectApplied then
                if not originalProperties[zombie] then
                    originalProperties[zombie] = {
                        Size = head.Size,
                        Transparency = head.Transparency
                    }
                end
                head.Size = Vector3.new(4, 4, 4)
                head.Transparency = 0.5
            else
                if originalProperties[zombie] then
                    head.Size = originalProperties[zombie].Size
                    head.Transparency = originalProperties[zombie].Transparency
                end
            end
        end
    end
end

button.MouseButton1Click:Connect(function()
    isEffectApplied = not isEffectApplied
    button.Text = isEffectApplied and "运行中" or "🤓大头娃娃山伯乐"
    processZombies()
end)

workspace.Camera.DescendantAdded:Connect(function(descendant)
    if descendant.Name == "m_Zombie" and descendant:FindFirstChild("Head") then
        if isEffectApplied then
            local head = descendant.Head
            originalProperties[descendant] = {
                Size = head.Size,
                Transparency = head.Transparency
            }
            head.Size = Vector3.new(4, 4, 4)
            head.Transparency = 0.5
        end
    end
end)

game:GetService("Players").LocalPlayer.CharacterRemoving:Connect(function()
    isEffectApplied = false
    processZombies()
    table.clear(originalProperties)
end)

local button = Instance.new("TextButton")
button.Name = "LoadScriptButton"
button.Size = UDim2.new(1, -10, 0, 30)
button.Text = "老近卫（临时）"
button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 14
button.Parent = functionButtonContainer

button.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://pastefy.app/Z8ViYhme/raw"))()
    end)
    
    if success then
        button.Text = "Script Loaded"
        button.BackgroundColor3 = Color3.fromRGB(0, 200, 0) 
    else
        button.Text = "Error Loading Script"
        button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        warn("", err)
    end
    
    task.delay(2, function()
        button.Text = "老近卫（临时）"
        button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end)
end)

local button = Instance.new("TextButton")
button.Name = "LoadScriptButton"
button.Size = UDim2.new(1, -10, 0, 30)
button.Text = "临时冷溪"
button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 14
button.Parent = functionButtonContainer

button.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://pastefy.app/CWGtJMQ7/raw"))()
    end)
    
    if success then
        button.Text = "Script Loaded"
        button.BackgroundColor3 = Color3.fromRGB(0, 200, 0) 
    else
        button.Text = "Error Loading Script"
        button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        warn("", err)
    end
    
    task.delay(2, function()
        button.Text = "临时冷溪"
        button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end)
end)

    local sideTitleBar = Instance.new("Frame")
    sideTitleBar.Size = UDim2.new(1, 0, 0, 25)
    sideTitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    sideTitleBar.BorderSizePixel = 0
    sideTitleBar.Parent = self.SideFrame

    local sideTitleText = Instance.new("TextLabel")
    sideTitleText.Size = UDim2.new(1, -10, 1, 0)
    sideTitleText.Position = UDim2.new(0, 10, 0, 0)
    sideTitleText.Text = "特别动画"
    sideTitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    sideTitleText.BackgroundTransparency = 1
    sideTitleText.Font = Enum.Font.GothamBold
    sideTitleText.TextSize = 12
    sideTitleText.TextXAlignment = Enum.TextXAlignment.Left
    sideTitleText.Parent = sideTitleBar

    local sideScrollFrame = Instance.new("ScrollingFrame")
    sideScrollFrame.Name = "SideScrollFrame"
    sideScrollFrame.Size = UDim2.new(1, -10, 1, -35)
    sideScrollFrame.Position = UDim2.new(0, 5, 0, 30)
    sideScrollFrame.BackgroundTransparency = 1
    sideScrollFrame.ScrollBarThickness = 8
    sideScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    sideScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sideScrollFrame.Parent = self.SideFrame

    local sideButtonContainer = Instance.new("Frame")
    sideButtonContainer.Name = "SideButtonContainer"
    sideButtonContainer.Size = UDim2.new(1, 0, 0, 0)
    sideButtonContainer.BackgroundTransparency = 1
    sideButtonContainer.Parent = sideScrollFrame

    local sideUIListLayout = Instance.new("UIListLayout")
    sideUIListLayout.Padding = UDim.new(0, 5)
    sideUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sideUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    sideUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sideUIListLayout.Parent = sideButtonContainer

    sideUIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sideScrollFrame.CanvasSize = UDim2.new(0, 0, 0, sideUIListLayout.AbsoluteContentSize.Y)
    end)

    for i, config in ipairs(self.SideButtonConfigs) do
        local button = Instance.new("TextButton")
        button.Name = config.Name
        button.Size = UDim2.new(1, -10, 0, 30)
        button.LayoutOrder = i
        button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        button.Text = config.Name
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.Gotham
        button.TextSize = 14
        button.Parent = sideButtonContainer

        local buttonData = {
            Instance = button,
            IsActive = false,
            Tracks = {},
            Connections = {}
        }
        
        self.ActiveButtons[config.Name] = buttonData
        
        button.MouseButton1Click:Connect(function()
            self:ToggleAnimation(config, buttonData)
        end)
    end

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 25)
    titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -10, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.Text = "清水GB脚本v6.1"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.BackgroundTransparency = 1
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 12
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar

    local resetButton = Instance.new("TextButton")
    resetButton.Name = "ResetPositionButton"
    resetButton.Size = UDim2.new(1, -10, 0, 30)
    resetButton.Position = UDim2.new(0, 5, 1, 330)
    resetButton.Text = "重置面板位置"
    resetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    resetButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    resetButton.Font = Enum.Font.Gotham
    resetButton.TextSize = 14
    resetButton.Parent = titleBar

    local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 5)
UICorner.Parent =resetButton

    resetButton.MouseButton1Click:Connect(function()
        local tweenService = game:GetService("TweenService")
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        tweenService:Create(mainFrame, tweenInfo, { Position = self.DefaultPositions.MainFrame }):Play()
        tweenService:Create(self.SideFrame, tweenInfo, { Position = self.DefaultPositions.SideFrame }):Play()
        tweenService:Create(self.FunctionFrame, tweenInfo, { Position = self.DefaultPositions.FunctionFrame }):Play()
        tweenService:Create(self.OtherFrame, tweenInfo, { Position = self.DefaultPositions.OtherFrame }):Play()
        
        task.delay(2, function()
            notification:Destroy()
        end)
    end)

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ScrollFrame"
    scrollFrame.Size = UDim2.new(1, 0, 1, -25)
    scrollFrame.Position = UDim2.new(0, 0, 0, 25)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.CanvasSize = UDim2.new(1, 0, 0, 0)
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    scrollFrame.Parent = mainFrame

    self.ScrollContainer = Instance.new("Frame")
    self.ScrollContainer.Name = "ScrollContainer"
    self.ScrollContainer.Size = UDim2.new(1, 0, 0, 0)
    self.ScrollContainer.Position = UDim2.new(0, 0, 0, 0)
    self.ScrollContainer.BackgroundTransparency = 1
    self.ScrollContainer.Parent = scrollFrame

    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Padding = UDim.new(0, 5)
    uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiListLayout.Parent = self.ScrollContainer

    uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.ScrollContainer.Size = UDim2.new(1, 0, 0, uiListLayout.AbsoluteContentSize.Y)
        scrollFrame.CanvasSize = UDim2.new(1, 0, 0, uiListLayout.AbsoluteContentSize.Y)
    end)

    for _, config in ipairs(self.MainButtonConfigs) do
        local button = Instance.new("TextButton")
        button.Name = config.Name
        button.Size = UDim2.new(0.9, 0, 0, 30)
        button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        button.Text = config.Name
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.Gotham
        button.TextSize = 14
        button.Parent = self.ScrollContainer

        local buttonData = {
            Instance = button,
            IsActive = false,
            Tracks = {},
            Connections = {}
        }
        
        self.ActiveButtons[config.Name] = buttonData
        
        button.MouseButton1Click:Connect(function()
            if config.Name == "骑兵动画（刺）" then
                button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                buttonData.IsActive = false
                self:PlayCavalryAnimation()
            else
                self:ToggleAnimation(config, buttonData)
            end
        end)
    end

    
local function setupFrameDrag(frame, titleBar)
    local dragging, dragInput, dragStart, startPos
    
    local function beginDrag(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end
    
    titleBar.InputBegan:Connect(beginDrag)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

setupFrameDrag(mainFrame, titleBar)
setupFrameDrag(self.SideFrame, sideTitleBar)
setupFrameDrag(self.FunctionFrame, functionTitleBar)
setupFrameDrag(self.OtherFrame, otherTitleBar)


    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Position = UDim2.new(1, -25, 0, 5)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = mainFrame

    closeButton.MouseButton1Click:Connect(function()
        self:CloseGUI()
    end)

    local sideCloseButton = Instance.new("TextButton")
    sideCloseButton.Size = UDim2.new(0, 20, 0, 20)
    sideCloseButton.Position = UDim2.new(1, -25, 0, 5)
    sideCloseButton.Text = "X"
    sideCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    sideCloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    sideCloseButton.Font = Enum.Font.GothamBold
    sideCloseButton.Parent = self.SideFrame

    sideCloseButton.MouseButton1Click:Connect(function()
        self.SideFrame.Visible = not self.SideFrame.Visible
    end)

    local functionCloseButton = Instance.new("TextButton")
    functionCloseButton.Size = UDim2.new(0, 20, 0, 20)
    functionCloseButton.Position = UDim2.new(1, -25, 0, 5)
    functionCloseButton.Text = "X"
    functionCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    functionCloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    functionCloseButton.Font = Enum.Font.GothamBold
    functionCloseButton.Parent = self.FunctionFrame

    functionCloseButton.MouseButton1Click:Connect(function()
        self.FunctionFrame.Visible = not self.FunctionFrame.Visible
    end)

local leftCloseButton = Instance.new("TextButton")
leftCloseButton.Size = UDim2.new(0, 20, 0, 20)
leftCloseButton.Position = UDim2.new(1, -25, 0, 5)
leftCloseButton.Text = "X"
leftCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
leftCloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
leftCloseButton.Font = Enum.Font.GothamBold
leftCloseButton.Parent = self.LeftFrame

leftCloseButton.MouseButton1Click:Connect(function()
    self.LeftFrame.Visible = not self.LeftFrame.Visible
end)
end

function AnimationController:Initialize()
    if self.IsClosed then return end
    
    self.Character = player.Character or player.CharacterAdded:Wait()
    self.Humanoid = self.Character:WaitForChild("Humanoid")
    self.Animator = self.Humanoid:WaitForChild("Animator")

    self:SetupRespawnHandler()
    self.DefaultAnimations = {}
    for _, track in pairs(self.Humanoid:GetPlayingAnimationTracks()) do
        if track.Name == "IdleAnimation" then
            self.DefaultAnimations.Idle = track
        elseif track.Name == "Walk" then
            self.DefaultAnimations.Walk = track
        end
    end
    
    self.Humanoid.Died:Connect(function()
        self:RestoreDefaults()
    end)
    

    if not self.IsClosed then
        self:CreateMainGUI()
    end
    
    self.IsInitialized = true
end


function AnimationController:SetupRespawnHandler()
    if self.RespawnConnection then return end
    
    self.RespawnConnection = self.Humanoid.Died:Connect(function()
        local newChar = player.CharacterAdded:Wait()
        task.wait(1)
        self:Initialize()
    end)
end

function AnimationController:SetupAnimationMonitor()
    if self.AnimationConnection then
        self.AnimationConnection:Disconnect()
    end
    
    self.AnimationConnection = self.Animator.AnimationPlayed:Connect(function(track)
        if track.Animation and track.Animation.AnimationId == "rbxassetid://72042024" then
            track:Stop()
            track.Priority = Enum.AnimationPriority.Action4
            track:Play()
        end
    end)
end

function AnimationController:CloseGUI()
    if self.Gui then
        self.Gui:Destroy()
        self.Gui = nil
    end
    if self.CharacterConnections then
        for _, conn in pairs(self.CharacterConnections) do
            conn:Disconnect()
        end
    end
    if self.RespawnConnection then
        self.RespawnConnection:Disconnect()
        self.RespawnConnection = nil
    end
    if self.AnimationConnection then
        self.AnimationConnection:Disconnect()
        self.AnimationConnection = nil
    end
    self:RemoveCannonHighlights()
    self.IsClosed = true
    self:RestoreDefaults()
end

function AnimationController:OpenGUI()
    self.IsClosed = false
    if not self.IsInitialized then
        self:Initialize()
    else
        self:CreateMainGUI()
    end
end

local function SetupController()
    if not AnimationController.IsInitialized then
        AnimationController:Initialize()
    end
    
    player.CharacterAdded:Connect(function(character)
        if not AnimationController.IsClosed then
            task.wait(1)
            AnimationController:Initialize()
        end
    end)
end

SetupController()

return {
    Close = function() AnimationController:CloseGUI() end,
    Open = function() AnimationController:OpenGUI() end,
    Toggle = function() 
        if AnimationController.Gui and AnimationController.Gui.Parent then 
            AnimationController:CloseGUI()
        else 
            AnimationController:OpenGUI()
        end 
    end,
    
    SetDebugMode = function(enabled)
        qingshui.debug = enabled
        if unlockButton then
            unlockButton.Visible = enabled
        end
    end,
    
    SetMobileMode = function(enabled)
        if enabled then
            AnimationController.MOBILE_MODE = true
            AnimationController.BUTTON_HEIGHT = 50
            AnimationController.BUTTON_TEXT_SIZE = 18
            AnimationController.FRAME_WIDTH = 300
        else
            AnimationController.MOBILE_MODE = false
            AnimationController.BUTTON_HEIGHT = 30
            AnimationController.BUTTON_TEXT_SIZE = 14
            AnimationController.FRAME_WIDTH = 210
        end
    end
}