local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Confirmed = false

WindUI:Popup({
    Title = "大司马脚本付费版V2",
    IconThemed = true,
    Content = "尊贵的用户" .. game.Players.LocalPlayer.Name .. "使用大司马脚本付费版",
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
    local Window = WindUI:CreateWindow({
        Title = "大司马脚本",
        Icon = "palette",
    Author = "尊贵的"..game.Players.localPlayer.Name.."欢迎使用大司马脚本付费版", 
        Folder = "Premium",
        Size = UDim2.fromOffset(550, 320),
        Theme = "Light",
        User = {
            Enabled = true,
            Anonymous = true,
            Callback = function()
            end
        },
        SideBarWidth = 200,
        HideSearchBar = false,  
    })

    Window:Tag({
        Title = "紧急汉堡",
        Color = Color3.fromHex("#00ffff") 
    })
    
    Window:Tag({
        Title = "大司马脚本付费版",
        Color = Color3.fromHex("#00ffff") 
    })

    Window:EditOpenButton({
        Title = "大司马脚本V2",
        Icon = "crown",
        CornerRadius = UDim.new(0, 8),
        StrokeThickness = 3,
        Color = ColorSequence.new(
            Color3.fromRGB(255, 255, 0),  
            Color3.fromRGB(255, 165, 0),  
            Color3.fromRGB(255, 0, 0),    
            Color3.fromRGB(139, 0, 0)     
        ),
        Draggable = true,
    })

local AntiCheatTab = Window:Tab({Title = "系统", Icon = "shield"})

AntiCheatTab:Section({Title = "两个都开"})

AntiCheatTab:Button({
    Title = "饶过检测",
    Callback = function()
        local function funcnil()
            local func = nil
            for i,v in pairs(getgc(true)) do
                if type(v) == "function" and getfenv(v).script == game:GetService("Players").LocalPlayer.PlayerScripts.Code.controllers.antiCheatController and tostring(getinfo(v).name) ~= nil and tostring(getinfo(v).name) ~= "" then
                    func = v
                end
            end
            return func
        end
        
        repeat task.wait()
            for i,v in pairs(getgc(true)) do
                if type(v) == "function" and getfenv(v).script == game:GetService("Players").LocalPlayer.PlayerScripts.Code.controllers.antiCheatController then
                    warn(getinfo(v).name)
                    hookfunction(v,function()
                        return 
                    end)
                end
            end
            wait(1)
            print(funcnil())
        until funcnil() == nil
        wait(2)
        warn("反检测已禁用")
    end
})

AntiCheatTab:Toggle({
    Title = "防挂机",
    Default = false,
    Callback = function(state)
        if state then
            warn("防挂机运行中")
            game:GetService("Players").LocalPlayer.Idled:connect(function()
                warn("触发防挂机")
                game:GetService("VirtualUser"):CaptureController()
                game:GetService("VirtualUser"):ClickButton2(Vector2.new())
            end)
        end
    end
})

local AutoWorkTab = Window:Tab({Title = "自动工作", Icon = "clock"})

AutoWorkTab:Toggle({
    Title = "自动公交车司机",
    Default = false,
    Callback = function(state)
        getfenv().busman = state
        if state then
            spawn(function()
                while getfenv().busman do
                    task.wait()
                    pcall(function()
                        local plr = game.Players.LocalPlayer
                        local car = workspace.Vehicles:FindFirstChild(plr.Name)
                        if workspace.Vehicles:FindFirstChild(plr.Name) and string.find(tostring(car:GetAttribute("Model")),"Bus Driver") and partfind() ~= nil and game.Players.LocalPlayer.Character.Humanoid.SeatPart == nil then
                            car.DriveSeat:Sit(game.Players.LocalPlayer.Character.Humanoid)
                        end
                    end)
                end
            end)
            
            spawn(function()
                while getfenv().busman do
                    task.wait()
                    pcall(function()
                        if game.Players.LocalPlayer.Character.Humanoid.Health < 60 and game.Players.LocalPlayer.Character.Humanoid.SeatPart == nil then
                            game.Players.LocalPlayer.Character:BreakJoints()
                            warn("角色血量过低，已重置")
                        end
                    end)
                end
            end)
            
            while getfenv().busman do
                wait()
                pcall(function()
                    workspace.Gravity = 196
                    local plr = game.Players.LocalPlayer
                    local car = workspace.Vehicles[plr.Name]
                    if workspace.Vehicles:FindFirstChild(plr.Name) and game.Players.LocalPlayer.Team ~= game:GetService("Teams").BusCompany then
                        repeat wait()
                            workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name).DriveSeat:Sit(game.Players.LocalPlayer.Character.Humanoid)
                        until game.Players.LocalPlayer.Character.Humanoid.SeatPart ~= nil
                        wait()
                        workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name):PivotTo(CFrame.new(-1683.09375, 15.630923271179199, -1286.167236328125))
                        wait(5)
                        game.Players.LocalPlayer.Character.Humanoid.Sit = false
                        wait(2)
                        
                        if game.Players.LocalPlayer:DistanceFromCharacter(Vector3.new(-1683.09375, 5.630923271179199, -1286.167236328125)) < 50 then
                           
                            game.Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(-1708.8741455078125, 5.616213321685791, -1281.946044921875))
                            game.Players.LocalPlayer.Character.Humanoid.MoveToFinished:wait()
                            game.Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(-1730.544677734375, 5.683385848999023, -1280.9140625))
                            game.Players.LocalPlayer.Character.Humanoid.MoveToFinished:wait()
                            
                          
                            repeat wait()
                                game:GetService("VirtualInputManager"):SendKeyEvent(true,"E",false,game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false,"E",false,game)
                            until shiftfind() ~= nil
                            
                            wait(3)
                            local busdriver = getfenv().drivertype or "Rural Bus Driver"
                            for i,v in pairs(shiftfind():GetDescendants()) do
                                if v.ClassName == "ImageButton" and v.Name == busdriver then
                                    if v.Parent ~= nil then
                                        firesignal(v.MouseButton1Click)
                                    end
                                end
                            end
                            
                            wait(3)
                            for i,v in pairs(shiftfind():GetDescendants()) do
                                if v.ClassName == "ImageButton" and v.ImageColor3 == Color3.fromRGB(142, 68, 173) then
                                    if v.Parent ~= nil then
                                        firesignal(v.MouseButton1Click)
                                    end
                                end
                            end
                            
                            wait(2)
                          
                            game.Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(-1722.3858642578125, 5.645286560058594, -1264.3126220703125))
                            game.Players.LocalPlayer.Character.Humanoid.MoveToFinished:wait()
                            
                            repeat wait()
                                game:GetService("VirtualInputManager"):SendKeyEvent(true,"E",false,game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false,"E",false,game)
                            until dealership() ~= nil and dealership().Enabled == true or partfind() ~= nil
                            
                            wait(2)
                            for i,v in pairs(dealership():GetDescendants()) do
                                if v.ClassName == "TextLabel" and v.Text == "Stuttgart Omnibus" then
                                    local plr = game.Players.LocalPlayer
                                    repeat wait()
                                        if v.Parent ~= nil then
                                            firesignal(v.Parent.MouseButton1Click)
                                            for a,b in pairs(dealership():GetDescendants()) do
                                                if b.ClassName == "ImageButton" and b:FindFirstChildOfClass("TextLabel").Text == "Spawn Vehicle" or b.ClassName == "ImageButton" and b:FindFirstChildOfClass("TextLabel").Text == "Unlock Vehicle" then
                                                    firesignal(b.MouseButton1Click)
                                                end
                                            end
                                        end
                                    until workspace.Vehicles:FindFirstChild(plr.Name) and partfind() ~= nil or partfind() ~= nil
                                end
                            end
                        end
                    elseif partfind() ~= nil and game.Players.LocalPlayer.Character.Humanoid.SeatPart ~= nil then
                     
                        workspace.Gravity = 0
                        local plr = game.Players.LocalPlayer
                        local chr = plr.Character
                        local car = workspace.Vehicles[plr.Name]
                        car.PrimaryPart = car.Body.Mass
                        local pos = destination() or partfind()
                        
                      
                        if (car.WorldPivot.Position-Vector3.new(pos.Position.X,car.PrimaryPart.Position.Y,pos.Position.Z)).magnitude > 100 then
                            local TweenService = game:GetService("TweenService")
                            local TweenInfoToUse = TweenInfo.new(0, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0)
                            local TweenValue = Instance.new("CFrameValue")
                            TweenValue.Value = car.WorldPivot
                            TweenValue.Changed:Connect(function()
                                car:PivotTo(TweenValue.Value)
                            end)
                            getfenv().tween = TweenService:Create(TweenValue, TweenInfoToUse, {Value=car.WorldPivot+Vector3.new(0,1000,0)})
                            getfenv().tween:Play()
                            repeat task.wait()
                            until getfenv().tween.PlaybackState == Enum.PlaybackState.Cancelled or getfenv().tween.PlaybackState == Enum.PlaybackState.Completed or getfenv().tween.PlaybackState == Enum.PlaybackState.Paused
                        end
                        
                    
                        local plr = game.Players.LocalPlayer
                        local pos = destination() or partfind()
                        local car = workspace.Vehicles[plr.Name]
                        if (car.WorldPivot.Position-Vector3.new(pos.Position.X,car.PrimaryPart.Position.Y,pos.Position.Z)).magnitude < 100 then
                            car:PivotTo(pos.CFrame)
                            workspace.Gravity = 196
                            for i,v in pairs(workspace.BusStops:GetDescendants()) do
                                if v.Name == "SelectionBox" and v.Visible == true then
                                    car:PivotTo(v.Parent.CFrame+Vector3.new(0,5,0))
                                end
                            end
                            local time = tick()
                            repeat task.wait()
                            until partfind() == nil or game.Players.LocalPlayer:DistanceFromCharacter(partfind().Position) > 70 or tick() - time >= 5
                        end
                    end
                end)
            end
        end
    end
})

AutoWorkTab:Toggle({
    Title = "自动卡车司机",
    Default = false,
    Callback = function(state)
        getfenv().trucker = state
        if state then
            spawn(function()
                while getfenv().trucker do
                    task.wait()
                    pcall(function()
                        if workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name) and workspace.Vehicles[game.Players.LocalPlayer.Name].Body:FindFirstChild("Trailer") and game.Players.LocalPlayer.Character.Humanoid.SeatPart == nil then
                            local plr = game.Players.LocalPlayer
                            local car = workspace.Vehicles[plr.Name]
                            if getfenv().tween ~= nil then
                                getfenv().tween:Cancel()
                                print("Tween Cancelled")
                            end
                            car.DriveSeat:Sit(game.Players.LocalPlayer.Character.Humanoid)
                        end
                    end)
                end
            end)
            
            spawn(function()
                while getfenv().trucker do
                    task.wait()
                    pcall(function()
                        if game.Players.LocalPlayer.Character.Humanoid.Health < 60 and game.Players.LocalPlayer.Character.Humanoid.SeatPart == nil then
                            game.Players.LocalPlayer.Character:BreakJoints()
                            warn("角色血量过低，已重置")
                        end
                    end)
                end
            end)
            
            spawn(function()
                while getfenv().trucker do
                    task.wait()
                    pcall(function()
                        for i,v in pairs(workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name):GetDescendants()) do
                            pcall(function()
                                v.Velocity = Vector3.new(0,0,0)
                            end)
                        end
                    end)
                end
            end)
            
            while getfenv().trucker do
                wait()
                pcall(function()
                    workspace.Gravity = 196
                    if workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name) and not workspace.Vehicles[game.Players.LocalPlayer.Name].Body:FindFirstChild("Trailer") then
                        repeat wait()
                            workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name).DriveSeat:Sit(game.Players.LocalPlayer.Character.Humanoid)
                        until game.Players.LocalPlayer.Character.Humanoid.SeatPart ~= nil
                        wait()
                        workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name):PivotTo(CFrame.new(717.53125, 15.626567840576172, 1462.559814453125))
                        wait(1)
                        game.Players.LocalPlayer.Character.Humanoid.Sit = false
                        wait(2)
                        
                        if game.Players.LocalPlayer:DistanceFromCharacter(Vector3.new(717.53125, 15.626567840576172, 1462.559814453125)) < 50 then
                            -- 移动到工作地点
                            game.Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(712.7074584960938, 5.587162017822266, 1437.5025634765625))
                            game.Players.LocalPlayer.Character.Humanoid.MoveToFinished:wait()
                            game.Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(707.704345703125, 5.657994270324707, 1426.1021728515625))
                            game.Players.LocalPlayer.Character.Humanoid.MoveToFinished:wait()
                            
                            -- 开始工作
                            repeat wait()
                                game:GetService("VirtualInputManager"):SendKeyEvent(true,"E",false,game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false,"E",false,game)
                            until shiftfind() ~= nil
                            
                            wait(3)
                            local timestried = 0 
                            repeat wait()
                                if game.Players.LocalPlayer.Team ~= game:GetService("Teams").TruckCompany then
                                    repeat wait()
                                        game:GetService("VirtualInputManager"):SendKeyEvent(true,"E",false,game)
                                        game:GetService("VirtualInputManager"):SendKeyEvent(false,"E",false,game)
                                    until shiftfind() ~= nil
                                    task.wait(1)
                                    if game.Players.LocalPlayer.Team ~= game:GetService("Teams").TruckCompany and timestried > 10 then
                                        for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetDescendants()) do
                                            if v.ClassName == "TextLabel" and v.Text == "Start Shift" then
                                                firesignal(v.Parent.MouseButton1Click)
                                            end
                                        end
                                        timestried = 0
                                    end
                                    for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetDescendants()) do
                                        if v.ClassName == "ImageButton" and v.ImageColor3 == Color3.fromRGB(39, 174, 96) then
                                            if v.Parent ~= nil then
                                                pcall(function()
                                                    firesignal(v.MouseButton1Down)
                                                end)
                                            end
                                        end
                                    end
                                    timestried=timestried+1
                                    task.wait(1)
                                end
                            until findxpui() ~= nil
                            
                            -- 选择任务
                            repeat wait()
                            until findxpui() ~= nil and findxpui().Enabled == true
                            _G.rat = nil
                            local num = 0
                            for i,v in pairs(findxpui():GetDescendants()) do
                                if v.ClassName == "TextLabel" and string.find(v.Text,"XP") then
                                    local Val = tonumber(v.Text:split(" ")[1])
                                    if Val > num then
                                        num = Val
                                        print(Val)
                                        _G.rat = v.Parent
                                    end
                                end
                            end
                            if _G.rat ~= nil then
                                firesignal(_G.rat.MouseButton1Click)
                            end
                            
                            -- 前往车辆经销商
                            game.Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(699.1327514648438, 5.645294189453125, 1407.9368896484375))
                            game.Players.LocalPlayer.Character.Humanoid.MoveToFinished:wait()
                            game.Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(700.1976318359375, 5.645294189453125, 1408.7381591796875))
                            game.Players.LocalPlayer.Character.Humanoid.MoveToFinished:wait()
                            
                            repeat wait()
                                game:GetService("VirtualInputManager"):SendKeyEvent(true,"E",false,game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false,"E",false,game)
                            until dealership()~= nil and dealership().Enabled == true
                            
                          
                            for i,v in pairs(dealership():GetDescendants()) do
                                if v.ClassName == "TextLabel" and v.Text == "Stuttgart Lastkraft" then
                                    repeat wait()
                                        if v.Parent ~= nil then
                                            firesignal(v.Parent.MouseButton1Click)
                                            wait(1)
                                            for a,b in pairs(dealership():GetDescendants()) do
                                                if b.ClassName == "TextLabel" and b.Text == "Spawn Vehicle" or b.ClassName == "TextLabel" and b.Text == "Unlock Vehicle" then
                                                    firesignal(b.Parent.MouseButton1Click)
                                                end
                                            end
                                        end
                                    until workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name) and workspace.Vehicles[game.Players.LocalPlayer.Name].Body:FindFirstChild("Trailer")
                                end
                            end
                        end
                    elseif workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name) and workspace.Vehicles[game.Players.LocalPlayer.Name].Body:FindFirstChild("Trailer") and game.Players.LocalPlayer.Character.Humanoid.SeatPart ~= nil then
                        -- 自动运送货物
                        workspace.Gravity = 0
                        local plr = game.Players.LocalPlayer
                        local chr = plr.Character
                        local car = workspace.Vehicles[plr.Name]
                        local pos = destination() or partfind()
                        car.PrimaryPart = car.Body.Mass
                        
                        -- 飞行到目的地
                        if (car.WorldPivot.Position-Vector3.new(pos.Position.X,car.PrimaryPart.Position.Y,pos.Position.Z)).magnitude > 100 then
                            car:PivotTo(car.WorldPivot+Vector3.new(0,500,0))
                        end
                        
                        local plr = game.Players.LocalPlayer
                        local pos = destination() or partfind()
                        local car = workspace.Vehicles[plr.Name]
                        if (car.WorldPivot.Position-Vector3.new(pos.Position.X,car.PrimaryPart.Position.Y,pos.Position.Z)).magnitude > 100 then
                            local TweenService = game:GetService("TweenService")
                            local TweenInfoToUse = TweenInfo.new(dist/80, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0)
                            local TweenValue = Instance.new("CFrameValue")
                            TweenValue.Value = car.WorldPivot
                            TweenValue.Changed:Connect(function()
                                car:PivotTo(TweenValue.Value)
                            end)
                            getfenv().tween = TweenService:Create(TweenValue, TweenInfoToUse, {Value=pos.CFrame+Vector3.new(0,500,0)})
                            getfenv().tween:Play()
                            repeat task.wait()
                            until getfenv().tween.PlaybackState == Enum.PlaybackState.Cancelled or getfenv().tween.PlaybackState == Enum.PlaybackState.Completed or getfenv().tween.PlaybackState == Enum.PlaybackState.Paused
                        end
                        
                        -- 降落
                        local plr = game.Players.LocalPlayer
                        local pos = destination() or partfind()
                        local car = workspace.Vehicles[plr.Name]
                        if (car.WorldPivot.Position-Vector3.new(pos.Position.X,car.PrimaryPart.Position.Y,pos.Position.Z)).magnitude < 100 then
                            car:PivotTo(pos.CFrame)
                            workspace.Gravity = 196
                            for i,v in pairs(workspace.DeliveryDestinations:GetDescendants()) do
                                if v.Name == "SelectionBox" and v.Visible == true then
                                    car:PivotTo(v.Parent.CFrame+Vector3.new(0,5,0))
                                end
                            end
                            local time = tick()
                            repeat task.wait()
                            until partfind() == nil or game.Players.LocalPlayer:DistanceFromCharacter(partfind().Position) > 70 or tick() - time > 40
                        end
                    end
                end)
            end
        end
    end
})

local PlayerTab = Window:Tab({Title = "玩家设置", Icon = "user"})

PlayerTab:Toggle({
    Title = "防坠落伤害",
    Default = false,
    Callback = function(state)
        getfenv().ANTIFALL = state
        if getfenv().ANTIFALL then
            getfenv().nofall = game:GetService("RunService").RenderStepped:Connect(function()
                if workspace:Raycast(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, Vector3.new(0, -20, 0)).Instance ~= nil and 
                   game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity.Y < -30 then 
                    game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                end
            end)
        else
            getfenv().nofall:Disconnect()
        end
    end
})

PlayerTab:Toggle({
    Title = "防倒地",
    Default = false,
    Callback = function(state)
        getfenv().downed = state
        if getfenv().downed == true then
            getfenv().antichanged1 = game.Players.LocalPlayer.Character.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                game.Players.LocalPlayer.Character.Humanoid.Health = 100
            end)
        else
            getfenv().antichanged1:Disconnect()
        end
    end
})

PlayerTab:Button({
    Title = "重置角色",
    Callback = function()
        game.Players.LocalPlayer.Character:BreakJoints()
    end
})

PlayerTab:Button({
    Title = "无限耐力",
    Callback = function()
        if getfenv().firsttime == nil then
            getfenv().firsttime = true
            local func 
            for i,v in pairs(getgc(true)) do
                if type(v) == "function" and getinfo(v).name == "setStamina" then
                    warn(getinfo(v).name)
                    func = v
                end
            end
            hookfunction(func,function(...)
                local args = {...}
                return args[1],math.huge
            end)
        end
    end
})

local AimbotTab = Window:Tab({Title = "自动瞄准", Icon = "crosshair"})

local function teams()
    local teams = {"选择敌方队伍"}
    for i,v in pairs(game:GetService("Teams"):GetChildren()) do
        table.insert(teams,v.Name)
    end
    return teams
end

AimbotTab:Dropdown({
    Title = "选择敌方队伍",
    Values = teams(),
    Callback = function(state) 
        if state ~= "选择敌方队伍" then
            getfenv().enemy = state
        end
    end
})

AimbotTab:Toggle({
    Title = "自动瞄准",
    Default = false,
    Callback = function(state)
        getfenv().aimbot = state
        local function canaim(ye)
            return game:GetService("Players").LocalPlayer:DistanceFromCharacter(ye) < 3
        end
        
        while getfenv().aimbot do
            task.wait()
            if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") and canaim(workspace.Camera.CFrame.Position) then
                local plr = nil
                local distance = math.huge
                for a,b in pairs(game.Players:GetPlayers()) do
                    if b.Team.Name == getfenv().enemy then
                        pcall(function()
                            local Dist = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - b.Character.Head.Position).magnitude
                            if Dist < distance then
                                distance = Dist
                                plr = b
                            end
                        end)
                    end
                end
                if plr ~= nil then
                    workspace.Camera.CameraType = "Follow"
                    workspace.Camera.CFrame = CFrame.new(workspace.Camera.CFrame.Position,plr.Character.Head.Position)
                end
            end
        end
    end
})

AimbotTab:Toggle({
    Title = "高亮敌人",
    Default = false,
    Callback = function(state)
        getfenv().highlight = state
        if getfenv().highlight == false then
            for i,v in pairs(game.Players:GetChildren()) do
                if v.ClassName == "Player" and v.Team.Name == getfenv().enemy and v.Character ~= nil and v.Character:FindFirstChild("Highlight") then
                    v.Character:FindFirstChild("Highlight"):Destroy()
                    task.wait()
                end
            end
        end
        while getfenv().highlight do
            task.wait()
            for i,v in pairs(game.Players:GetChildren()) do
                if v.ClassName == "Player" and v.Team.Name == getfenv().enemy and v.Character ~= nil and not v.Character:FindFirstChild("Highlight") then
                    Instance.new("Highlight",v.Character)
                    task.wait()
                end
            end
        end
    end
})

local TeleportTab = Window:Tab({Title = "传送", Icon = "map-pin"})

TeleportTab:Section({Title = "传送点1"})
TeleportTab:Dropdown({
    Title = "选择传送点",
    Values = {"传送点","警察局","银行","停车场","珠宝店","监狱","公交公司","卡车公司","医院"},
    Callback = function(state)
        print(state)
        workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name).PrimaryPart = workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name).Body.Mass
        if state == "警察局" then
            local time = tick()
            repeat task.wait()
                if game.Players.LocalPlayer.Character.Humanoid.SeatPart == nil then
                    workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name).DriveSeat:Sit(game.Players.LocalPlayer.Character.Humanoid)
                    time = tick()
                    wait(1)
                    time = tick()
                elseif game.Players.LocalPlayer.Character.Humanoid.SeatPart ~= nil then
                    location = CFrame.new(-1549.2081298828125, 5.615050315856934, 2935.314697265625)
                    workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name):PivotTo(location)
                end
            until tick()-time > 2
        elseif state == "银行" then
            local time = tick()
            repeat task.wait()
                if game.Players.LocalPlayer.Character.Humanoid.SeatPart == nil then
                    workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name).DriveSeat:Sit(game.Players.LocalPlayer.Character.Humanoid)
                    time = tick()
                    wait(1)
                    time = tick()
                elseif game.Players.LocalPlayer.Character.Humanoid.SeatPart ~= nil then
                    location = CFrame.new(-1174.68115234375, 5.874685287475586, 3209.03271484375)
                    workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name):PivotTo(location)
                end
            until tick()-time > 2
        elseif state == "停车场" then
            local time = tick()
            repeat task.wait()
                if game.Players.LocalPlayer.Character.Humanoid.SeatPart == nil then
                    workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name).DriveSeat:Sit(game.Players.LocalPlayer.Character.Humanoid)
                    time = tick()
                    wait(1)
                    time = tick()
                elseif game.Players.LocalPlayer.Character.Humanoid.SeatPart ~= nil then
                    location = CFrame.new(-993.5323486328125, -11.622750282287598, 3705.0126953125)
                    workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name):PivotTo(location)
                end
            until tick()-time > 2
        elseif state == "珠宝店" then
            local time = tick()
            repeat task.wait()
                if game.Players.LocalPlayer.Character.Humanoid.SeatPart == nil then
                    workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name).DriveSeat:Sit(game.Players.LocalPlayer.Character.Humanoid)
                    time = tick()
                    wait(1)
                    time = tick()
                elseif game.Players.LocalPlayer.Character.Humanoid.SeatPart ~= nil then
                    location = CFrame.new(-396.0776062011719, 5.6145405769348145, 3508.26318359375)
                    workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name):PivotTo(location)
                end
            until tick()-time > 2  
        elseif state == "监狱" then
            local time = tick()
            repeat task.wait()
                if game.Players.LocalPlayer.Character.Humanoid.SeatPart == nil then
                    workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name).DriveSeat:Sit(game.Players.LocalPlayer.Character.Humanoid)
                    time = tick()
                    wait(1)
                    time = tick()
                elseif game.Players.LocalPlayer.Character.Humanoid.SeatPart ~= nil then
                    location = CFrame.new(-548.9014282226562, 5.6149725914001465, 2832.7587890625)
                    workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name):PivotTo(location)
                end
            until tick()-time > 2  
        elseif state == "卡车公司" then
            local time = tick()
            repeat task.wait()
                if game.Players.LocalPlayer.Character.Humanoid.SeatPart == nil then
                    workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name).DriveSeat:Sit(game.Players.LocalPlayer.Character.Humanoid)
                    time = tick()
                    wait(1)
                    time = tick()
                elseif game.Players.LocalPlayer.Character.Humanoid.SeatPart ~= nil then
                    location = CFrame.new(717.53125, 15.626567840576172, 1462.559814453125)
                    workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name):PivotTo(location)
                end
            until tick()-time > 2  
        elseif state == "公交公司" then
            local time = tick()
            repeat task.wait()
                if game.Players.LocalPlayer.Character.Humanoid.SeatPart == nil then
                    workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name).DriveSeat:Sit(game.Players.LocalPlayer.Character.Humanoid)
                    time = tick()
                    wait(1)
                    time = tick()
                elseif game.Players.LocalPlayer.Character.Humanoid.SeatPart ~= nil then
                    location = CFrame.new(-1683.09375, 15.630923271179199, -1286.167236328125)
                    workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name):PivotTo(location)
                end
            until tick()-time > 2  
        elseif state == "医院" then
            local time = tick()
            repeat task.wait()
                if game.Players.LocalPlayer.Character.Humanoid.SeatPart == nil then
                    workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name).DriveSeat:Sit(game.Players.LocalPlayer.Character.Humanoid)
                    time = tick()
                    wait(1)
                    time = tick()
                elseif game.Players.LocalPlayer.Character.Humanoid.SeatPart ~= nil then
                    location = CFrame.new(-304.7102966308594, 5.623022079467773, 1018.22119140625)
                    workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name):PivotTo(location)
                end
            until tick()-time > 2  
        end
    end
})

TeleportTab:Section({Title = "传送点2"})
TeleportTab:Dropdown({
    Title = "选择传送点",
    Values = {"传送点","工具店","汽车经销商","农场商店","Ares加油站","Osso加油站","Gas-N-Go加油站"},
    Callback = function(state)
        print(state)
        workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name).PrimaryPart = workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name).Body.Mass
        if state == "工具店" then
            local time = tick()
            repeat task.wait()
                if game.Players.LocalPlayer.Character.Humanoid.SeatPart == nil then
                    workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name).DriveSeat:Sit(game.Players.LocalPlayer.Character.Humanoid)
                    time = tick()
                    wait(1)
                    time = tick()
                elseif game.Players.LocalPlayer.Character.Humanoid.SeatPart ~= nil then
                    location = CFrame.new(-733.7286376953125, 5.614245414733887, 677.4180908203125)
                    workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name):PivotTo(location)
                end
            until tick()-time > 2  
        elseif state == "汽车经销商" then
            local time = tick()
            repeat task.wait()
                if game.Players.LocalPlayer.Character.Humanoid.SeatPart == nil then
                    workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name).DriveSeat:Sit(game.Players.LocalPlayer.Character.Humanoid)
                    time = tick()
                    wait(1)
                    time = tick()
                elseif game.Players.LocalPlayer.Character.Humanoid.SeatPart ~= nil then
                    location = CFrame.new(-1422.2327880859375, 5.624246120452881, 939.8997802734375)
                    workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name):PivotTo(location)
                end
            until tick()-time > 2  
        elseif state == "农场商店" then
            local time = tick()
            repeat task.wait()
                if game.Players.LocalPlayer.Character.Humanoid.SeatPart == nil then
                    workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name).DriveSeat:Sit(game.Players.LocalPlayer.Character.Humanoid)
                    time = tick()
                    wait(1)
                    time = tick()
                elseif game.Players.LocalPlayer.Character.Humanoid.SeatPart ~= nil then
                    location = CFrame.new(-840.9263305664062, 5.378037929534912, -1179.6783447265625)
                    workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name):PivotTo(location)
                end
            until tick()-time > 2  
        elseif state == "Ares加油站" then
            local time = tick()
            repeat task.wait()
                if game.Players.LocalPlayer.Character.Humanoid.SeatPart == nil then
                    workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name).DriveSeat:Sit(game.Players.LocalPlayer.Character.Humanoid)
                    time = tick()
                    wait(1)
                    time = tick()
                elseif game.Players.LocalPlayer.Character.Humanoid.SeatPart ~= nil then
                    location = CFrame.new(-873.4227294921875, 5.614551067352295, 1500.887451171875)
                    workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name):PivotTo(location)
                end
            until tick()-time > 2  
        elseif state == "Osso加油站" then
            local time = tick()
            repeat task.wait()
                if game.Players.LocalPlayer.Character.Humanoid.SeatPart == nil then
                    workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name).DriveSeat:Sit(game.Players.LocalPlayer.Character.Humanoid)
                    time = tick()
                    wait(1)
                    time = tick()
                elseif game.Players.LocalPlayer.Character.Humanoid.SeatPart ~= nil then
                    location = CFrame.new(-26.49447250366211, 5.615009307861328, -766.71630859375)
                    workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name):PivotTo(location)
                end
            until tick()-time > 2  
        elseif state == "Gas-N-Go加油站" then
            local time = tick()
            repeat task.wait()
                if game.Players.LocalPlayer.Character.Humanoid.SeatPart == nil then
                    workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name).DriveSeat:Sit(game.Players.LocalPlayer.Character.Humanoid)
                    time = tick()
                    wait(1)
                    time = tick()
                elseif game.Players.LocalPlayer.Character.Humanoid.SeatPart ~= nil then
                    location = CFrame.new(-1544.445556640625, 5.628605842590332, 3811.127685546875)
                    workspace.Vehicles:FindFirstChild(game.Players.LocalPlayer.Name):PivotTo(location)
                end
            until tick()-time > 2  
        end
    end
})

local function destination()
    local dest = nil
    for i,v in pairs(workspace.DeliveryDestinations:GetDescendants()) do
        if v.Name == "SelectionBox" and v.Visible == true and v.Transparency ~= 1 then
            dest = v.Parent
        end
    end
    return dest
end

local function getplayer(plr)
    local player = nil
    for i,v in pairs(game.Players:GetPlayers()) do
        if string.find(v.Name,plr) or string.find(v.DisplayName,plr) then
            player = v.Name
            break
        end
    end
    return player
end

local function shiftfind()
    local shift = nil
    local uifind = nil
    local busdriver = getfenv().drivertype or "Rural Bus Driver"
    for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetDescendants()) do
        if v.ClassName == "TextLabel" and v.Text == "Start Shift" or v.ClassName == "ImageButton" and v.Name == busdriver then
            shift = v.Parent
        end
    end
    if shift ~= nil then
        for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren()) do
            if shift:IsDescendantOf(v) then
                uifind = v
            end
        end
    end
    return uifind
end

local function dealership()
    local deal = nil
    local uifind = nil
    for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetDescendants()) do
        if v.ClassName == "TextLabel" and v.Text == "Stuttgart Lastkraft" or v.ClassName == "TextLabel" and v.Text == "Stuttgart Omnibus" then
            deal = v
        end
    end
    if deal ~= nil then
        for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren()) do
            if deal:IsDescendantOf(v) then
                uifind = v
            end
        end
    end
    return uifind
end

local function partfind()
    local part = nil
    for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetDescendants()) do
        if v.ClassName == "BillboardGui" and v.Adornee ~= nil then
            part = v.Adornee
        end
    end
    return part
end

local function findxpui() 
    local xpui = nil
    local test = nil
    for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetDescendants()) do
        if v.ClassName == "TextLabel" and string.find(v.Text,"XP") and v.Parent.ClassName == "ImageButton" and tonumber(v.Text:split(" ")[1]) then
            test = v
            break
        end
    end
    if test ~= nil then
        for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren()) do
            if test:IsDescendantOf(v) then
                xpui = v
            end
        end
    end
    return xpui
end
getfenv().jump = game.Players.LocalPlayer.Character.Humanoid.JumpHeight
end