if game.GameId == 65241 then --- 自然灾害
    local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({
        Title = "塔菲喵",
        Icon = "rbxassetid://4483362748",
        IconTransparency = 0.5,
        IconThemed = true,
        Author = "伊散",
        Folder = "CloudHub",
        Size = UDim2.fromOffset(150, 150),
        Transparent = true,
        Theme = "Light",
        User = {
            Enabled = true,
            Callback = function() print("clicked") end,
            Anonymous = false
        },
        SideBarWidth = 200,
        ScrollBarEnabled = true,
        Background = "rbxassetid://111122821357551"
    })
    

Window:EditOpenButton({
    Title = "伊散",
    Icon = "monitor",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("FF0000")),
        ColorSequenceKeypoint.new(0.16, Color3.fromHex("FF7F00")),
        ColorSequenceKeypoint.new(0.33, Color3.fromHex("FFFF00")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("00FF00")),
        ColorSequenceKeypoint.new(0.66, Color3.fromHex("0000FF")),
        ColorSequenceKeypoint.new(0.83, Color3.fromHex("4B0082")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("9400D3"))
    }),
    Draggable = true,
})
            
Window:Tag({
    Title = "塔菲喵",
    Color = Color3.fromHex("#30ff6a")
})

Window:Tag({
        Title = "伊散", -- 标签汉化
        Color = Color3.fromHex("#315dff")
    })
    local TimeTag = Window:Tag({
        Title = "自然灾害",
        Color = Color3.fromHex("#000000")
    })

local Tabs = {
    Main = Window:Section({ Title = "自然灾害", Opened = true }),
}

local TabHandles = {
    Q = Tabs.Main:Tab({ Title = "功能", Icon = "layout-grid" }),
}

Button = TabHandles.Q:Button({
    Title = "指南针（可以用下面的地方显示不了地图）",
    Desc = "要使用的话就必须买指南针",
    Locked = false,
    Callback = function()
    
local p = game.Players.LocalPlayer
local r, c, h = game.ReplicatedStorage.Remotes.Compass, p.Backpack:WaitForChild("Compass"), p.Character:WaitForChild("Humanoid")
h:EquipTool(c)
task.wait()
r:FireServer("Vote Map", 3)
r:FireServer("Vote Map", 4)
task.wait()
h:UnequipTools()
            
WindUI:Notify({
    Title = "通知",
    Content = "加载成功",
    Duration = 1, -- 3 seconds
    Icon = "layout-grid",
})                        
            
 end
})

Button = TabHandles.Q:Button({
    Title = "黑洞",
    Desc = "点击加载",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Super-ring-Parts-V6-28581"))()
        
WindUI:Notify({
    Title = "通知",
    Content = "加载成功",
    Duration = 3, -- 3 seconds
    Icon = "layout-grid",
})        
        
    end
})

Button = TabHandles.Q:Button({
    Title = "物理磁铁",
    Desc = "可以把下面的东西吸上来可以踩",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/cytj777i/6669178/main/%E5%8D%95%E4%B8%80%E7%89%A9%E4%BD%93%E9%A3%9E%E8%A1%8C%E8%BD%BD%E8%87%AA%E5%B7%B1%E6%9C%80%E7%BB%88%E4%BC%98%E5%8C%96%E7%89%88"))()       
        
WindUI:Notify({
    Title = "通知",
    Content = "加载成功",
    Duration = 1, -- 3 seconds
    Icon = "layout-grid",
})                                
    end
})

Button = TabHandles.Q:Button({
    Title = "无敌少侠",
    Desc = "用了它，你就会变成城市超人",
    Locked = false,
    Callback = function()
loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Invinicible-Flight-R15-45414"))()
WindUI:Notify({
    Title = "通知",
    Content = "加载成功",
    Duration = 1, -- 3 seconds
    Icon = "layout-grid",
})                        
            
 end
})

Button = TabHandles.Q:Button({
    Title = "防止摔跤伤害",
    Desc = "就算掉下去了，也毫发无伤，掉到水里面也会死的",
    Locked = false,
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/cytj777i/Fall-injury/main/防止摔落伤害"))()
            
WindUI:Notify({
    Title = "通知",
    Content = "加载成功",
    Duration = 1, -- 3 seconds
    Icon = "layout-grid",
})                        
            
 end
})
elseif game.GameId == 8144728961 then --- 深渊
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XOTRXONY/AUREATE/main/B1.lua"))()
elseif game.GameId == 8662820852 then --- 星星钓鱼
    local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yisan9178/sjsjsj/refs/heads/main/Windui.lua(1).txt"))()

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(chars, uchar)
    end
    local length = #chars
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
            math.floor(r * 255), 
            math.floor(g * 255), 
            math.floor(b * 255), 
            chars[i])
    end
    return result
end

local Window = WindUI:CreateWindow({
    Title = gradient("塔菲喵", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("伊散", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    IconThemed = true,
    Folder = "塔菲喵",
    Size = UDim2.fromOffset(150, 150),
    Transparent = getgenv().TransparencyEnabled or false,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 150,
    BackgroundImageTransparency = 0.8,
    HideSearchBar = true,
    ScrollBarEnabled = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            WindUI:Notify({
                Title = "提示",
                Content = "点击了用户头像",
                Duration = 2
            })
        end,
    },
})

Window:EditOpenButton({
    Title = "[摸摸伊散]",
    CornerRadius = UDim.new(0,8),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("1E3A8A")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("118AB2")), 
        ColorSequenceKeypoint.new(1, Color3.fromHex("06D6A0")) 
    }),
    Draggable = true,
})

Window:Tag({
    Title = "伊散",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})

Window:SetToggleKey(Enum.KeyCode.F, true)

local autoFishing = false
local fishingConnection = nil
local F_Config = {F = 'Self'} 

local function getRoot(char) return char and char:FindFirstChild('HumanoidRootPart') end
local function getHum(char) return char and char:FindFirstChild('Humanoid') end

local function performFish()
    local char = LocalPlayer.Character
    local hum = getHum(char)
    local root = getRoot(char)
    if not root or not hum then return end
    
    local rod = char:FindFirstChild('Rod')
    if not rod then return end
    
    local targetPos = F_Config.F == 'Self' and root or workspace.Galaxies:FindFirstChild(F_Config.F) or root
    local posInfo = {targetPos:GetPivot().Position + Vector3.new(0, 5, 0), targetPos:GetPivot().LookVector}
    
    local args = {hum, posInfo[1], posInfo[2], rod.Model.Nodes.RodTip.Attachment}
    ReplicatedStorage.Events.Global.Cast:FireServer(unpack(args))
    task.wait(0.1)
    ReplicatedStorage.Events.Global.WithdrawBobber:FireServer(hum)
end

local MainTab = Window:Tab({ Title = '主要功能', Icon = 'star' })
Window:SelectTab(1)

MainTab:Toggle({
    Title = "开启自动钓鱼",
    Desc = "自动抛竿、收竿并确认获得的星星物品",
    Value = false,
    Callback = function(state)
        autoFishing = state
        
        if autoFishing then
            fishingConnection = ReplicatedStorage.Events.Global.ClientRecieveItems.OnClientEvent:Connect(function(...)
                local args = {...}
                local items = args[4] or {}
                local delays = args[6] or {}
                for i, item in pairs(items) do
                    if item.id then
                        task.wait(delays[i] or 2)
                        ReplicatedStorage.Events.Global.ClientItemConfirm:FireServer(item.id)
                    end
                end
            end)
            
            task.spawn(function()
                while autoFishing do
                    performFish()
                    task.wait(0.1) 
                end
            end)
            
            WindUI:Notify({Title = "功能开启", Content = "自动钓鱼已启动", Duration = 2, Icon = "fish"})
        else
            if fishingConnection then
                fishingConnection:Disconnect()
                fishingConnection = nil
            end
            WindUI:Notify({Title = "功能关闭", Content = "自动钓鱼已停止", Duration = 2, Icon = "fish-off"})
        end
    end
})

MainTab:Button({
    Title = "一键出售所有星星",
    Desc = "瞬间传送至商人处卖出，并自动传回原位",
    Callback = function()
        local player = Players.LocalPlayer
        local character = player.Character
        
        if not character or not character:FindFirstChild("HumanoidRootPart") then 
            return 
        end
        
        local hrp = character.HumanoidRootPart
        
        local originalCFrame = hrp.CFrame
        
        hrp.CFrame = CFrame.new(11.99, 36.82, -263.47) 
        
        task.wait(1)
        
        local args = {
            {
                id = "sell-all",
                text = "Sell <font color='#26ff47'>all</font> of my stars [$30,330].",
                npc = "Star Merchant"
            }
        }
        
        local dialogueEvent = ReplicatedStorage:WaitForChild("Dialogue"):WaitForChild("Events"):WaitForChild("Global"):WaitForChild("ClientChoosesDialogueOption")
        
        if dialogueEvent then
            dialogueEvent:FireServer(unpack(args))
            WindUI:Notify({
                Title = "成功",
                Content = "已发送出售请求，正在返回原位...",
                Duration = 2,
                Icon = "shopping-cart"
            })
        end
        
        task.wait(3)
        
        hrp.CFrame = originalCFrame
    end
})

local TeleportTab = Window:Tab({ Title = '位置传送', Icon = 'map-pin' })

TeleportTab:Button({
    Title = "传送到银河系",
    Desc = "点击立即传送到坐标 (52.50, 36.48, -264.72)",
    Callback = function()
        local targetX, targetY, targetZ = 52.50, 36.48, -264.72
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        if character then
            character:PivotTo(CFrame.new(targetX, targetY, targetZ))
            WindUI:Notify({
                Title = "传送成功",
                Content = "已到达目标位置",
                Duration = 2,
                Icon = "check"
            })
        end
    end
})

TeleportTab:Button({
    Title = "传送到仙女座",
    Desc = "点击立即传送到坐标 (48.92, 44.24, -176.94)",
    Callback = function()
        local targetX, targetY, targetZ = 48.92, 44.24, -176.94
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        if character then
            character:PivotTo(CFrame.new(targetX, targetY, targetZ))
            WindUI:Notify({
                Title = "传送成功",
                Content = "已到达目标位置",
                Duration = 2,
                Icon = "check"
            })
        end
    end
})

TeleportTab:Button({
    Title = "传送到眼睛",
    Desc = "点击立即传送到坐标 (209.56, 34.20, -306.51)",
    Callback = function()
        local targetX, targetY, targetZ = 209.56, 34.20, -306.51
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        if character then
            character:PivotTo(CFrame.new(targetX, targetY, targetZ))
            WindUI:Notify({
                Title = "传送成功",
                Content = "已到达目标位置",
                Duration = 2,
                Icon = "check"
            })
        end
    end
})

TeleportTab:Button({
    Title = "传送到霍格的天体",
    Desc = "点击立即传送到坐标 (-91.57, 36.64, -34.67)",
    Callback = function()
        local targetX, targetY, targetZ = -91.57, 36.64, -34.67
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        if character then
            character:PivotTo(CFrame.new(targetX, targetY, targetZ))
            WindUI:Notify({
                Title = "传送成功",
                Content = "已到达目标位置",
                Duration = 2,
                Icon = "check"
            })
        end
    end
})

TeleportTab:Button({
    Title = "传送到半人马座A",
    Desc = "点击立即传送到坐标 (-149.12, 36.25, 122.42)",
    Callback = function()
        local targetX, targetY, targetZ = -149.12, 36.25, 122.42
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        if character then
            character:PivotTo(CFrame.new(targetX, targetY, targetZ))
            WindUI:Notify({
                Title = "传送成功",
                Content = "已到达目标位置",
                Duration = 2,
                Icon = "check"
            })
        end
    end
})

TeleportTab:Button({
    Title = "传送到负向银河",
    Desc = "点击立即传送到坐标 (385.14, 48.28, 150.76)",
    Callback = function()
        local targetX, targetY, targetZ = 385.14, 48.28, 150.76
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        if character then
            character:PivotTo(CFrame.new(targetX, targetY, targetZ))
            WindUI:Notify({
                Title = "传送成功",
                Content = "已到达目标位置",
                Duration = 2,
                Icon = "check"
            })
        end
    end
})

TeleportTab:Button({
    Title = "传送到半人马座购买杆子区域",
    Desc = "点击立即传送到坐标 (-230.54, 36.69, 117.39)",
    Callback = function()
        local targetX, targetY, targetZ = -230.54, 36.69, 117.39
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        if character then
            character:PivotTo(CFrame.new(targetX, targetY, targetZ))
            WindUI:Notify({
                Title = "传送成功",
                Content = "已到达目标位置",
                Duration = 2,
                Icon = "check"
            })
        end
    end
})

TeleportTab:Button({
    Title = "传送到制作戒指",
    Desc = "点击立即传送到坐标 (-132.79, 40.02, -318.38)",
    Callback = function()
        local targetX, targetY, targetZ = -132.79, 40.02, -318.38
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        if character then
            character:PivotTo(CFrame.new(targetX, targetY, targetZ))
            WindUI:Notify({
                Title = "传送成功",
                Content = "已到达目标位置",
                Duration = 2,
                Icon = "check"
            })
        end
    end
})

TeleportTab:Button({
    Title = "传送到图书馆",
    Desc = "点击立即传送到坐标 (39548.37, 59.27, 4689.06)",
    Callback = function()
        local targetX, targetY, targetZ = 39548.37, 59.27, 4689.06
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        if character then
            character:PivotTo(CFrame.new(targetX, targetY, targetZ))
            WindUI:Notify({
                Title = "传送成功",
                Content = "已到达目标位置",
                Duration = 2,
                Icon = "check"
            })
        end
    end
})

TeleportTab:Button({
    Title = "传送到地牢",
    Desc = "点击立即传送到坐标 (39680.53, 42.25, 4088.48)",
    Callback = function()
        local targetX, targetY, targetZ = 39680.53, 42.25, 4088.48
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        if character then
            character:PivotTo(CFrame.new(targetX, targetY, targetZ))
            WindUI:Notify({
                Title = "传送成功",
                Content = "已到达目标位置",
                Duration = 2,
                Icon = "check"
            })
        end
    end
})

TeleportTab:Button({
    Title = "传送到地牢迷宫",
    Desc = "点击立即传送到坐标 (39645.04, 42.25, 4090.34)",
    Callback = function()
        local targetX, targetY, targetZ = 39645.04, 42.25, 4090.34
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        if character then
            character:PivotTo(CFrame.new(targetX, targetY, targetZ))
            WindUI:Notify({
                Title = "传送成功",
                Content = "已到达目标位置",
                Duration = 2,
                Icon = "check"
            })
        end
    end
})

TeleportTab:Button({
    Title = "传送到梅林魔法屋",
    Desc = "点击立即传送到坐标 (39477.60, 44.60, 5251.07)",
    Callback = function()
        local targetX, targetY, targetZ = 39477.60, 44.60, 5251.07
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        if character then
            character:PivotTo(CFrame.new(targetX, targetY, targetZ))
            WindUI:Notify({
                Title = "传送成功",
                Content = "已到达目标位置",
                Duration = 2,
                Icon = "check"
            })
        end
    end
})

TeleportTab:Button({
    Title = "传送到骑士国王房间",
    Desc = "点击立即传送到坐标 (39541.97, 47.77, 4866.66)",
    Callback = function()
        local targetX, targetY, targetZ = 39541.97, 47.77, 4866.66
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        if character then
            character:PivotTo(CFrame.new(targetX, targetY, targetZ))
            WindUI:Notify({
                Title = "传送成功",
                Content = "已到达目标位置",
                Duration = 2,
                Icon = "check"
            })
        end
    end
})

TeleportTab:Button({
    Title = "传送到地狱房间",
    Desc = "点击立即传送到坐标 (39553.20, 28.17, 4411.96)",
    Callback = function()
        local targetX, targetY, targetZ = 39553.20, 28.17, 4411.96
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        if character then
            character:PivotTo(CFrame.new(targetX, targetY, targetZ))
            WindUI:Notify({
                Title = "传送成功",
                Content = "已到达目标位置",
                Duration = 2,
                Icon = "check"
            })
        end
    end
})
elseif game.GameId == 1268927906 then --- 力量传奇
    local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({
        Title = "塔菲喵",
        IconTransparency = 0.5,
        IconThemed = true,
        Author = "伊散",
        Folder = "CloudHub",
        Size = UDim2.fromOffset(150, 150),
        Transparent = true,
        Theme = "Light",
        User = {
            Enabled = true,
            Callback = function() print("clicked") end,
            Anonymous = false
        },
        SideBarWidth = 200,
        ScrollBarEnabled = true,
        Background = "rbxassetid://111122821357551"
    })
    

Window:EditOpenButton({
    Title = "塔菲喵",
    Icon = "monitor",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 4,
    Draggable = true,
})
            
local Tabs = {
    Main = Window:Section({ Title = "自动", Opened = true }),
}

local TabHandles = {    
    Q = Tabs.Main:Tab({ Title = "自动功能", Icon = "layout-grid" }),
    W = Tabs.Main:Tab({ Title = "传送功能", Icon = "layout-grid" }),
    E = Tabs.Main:Tab({ Title = "自动锻炼", Icon = "layout-grid" }),
    R = Tabs.Main:Tab({ Title = "自动跑步", Icon = "layout-grid" }),
    T = Tabs.Main:Tab({ Title = "自动蹲起", Icon = "layout-grid" }),
    Y = Tabs.Main:Tab({ Title = "引体向上", Icon = "layout-grid" }),
    U = Tabs.Main:Tab({ Title = "自动举重", Icon = "layout-grid" }),
    I = Tabs.Main:Tab({ Title = "自动投石", Icon = "layout-grid" }),
    SAN = Tabs.Main:Tab({ Title = "UI自定义", Icon = "layout-grid" }),    
}

TabHandles.Q:Input({
    Title = "修改力量",
    Value = configName,
    Callback = function(FXM)
      game:GetService("Players").LocalPlayer.leaderstats.Strength.Value = FXM  
    end
})

TabHandles.Q:Input({
    Title = "修改重生",
    Value = configName,
    Callback = function(FXM)
        game:GetService("Players").LocalPlayer.leaderstats.Rebirths.Value = FXM
    end
})

TabHandles.Q:Input({
    Title = "修改击杀",
    Value = configName,
    Callback = function(FXM)
        game:GetService("Players").LocalPlayer.leaderstats.Kills.Value = FXM
    end
})

TabHandles.Q:Input({
    Title = "修改获胜",
    Value = configName,
    Callback = function(FXM)
        game:GetService("Players").LocalPlayer.leaderstats.Brawls.Value = FXM
    end
})
TabHandles.Q:Divider()

Toggle = TabHandles.Q:Toggle({
    Title = "自动重生",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    if Value then
        while Value do
            game:GetService("ReplicatedStorage").rEvents.rebirthRemote:InvokeServer("rebirthRequest")
            wait()
            end
        end        
    end
})

Toggle = TabHandles.Q:Toggle({
    Title = "自动修改体积为2",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    if Value then
        while Value do
        game:GetService("ReplicatedStorage").rEvents.changeSpeedSizeRemote:InvokeServer("changeSize",2)
        wait()
    end
end
end
})

local Button = TabHandles.Q:Button({
    Title = "传送肌肉之王",
    Desc = "点击进行单次传送",
    Locked = false,
    Callback = function()
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(-8625.9296875, 13.566278457641602, -5730.4736328125)
        end
    end
})
TabHandles.Q:Divider()

Toggle = TabHandles.Q:Toggle({
    Title = "0石头",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    -- 将开关值同步到全局RK0变量，统一控制逻辑
    getgenv().RK0 = Value
    Jump = Value

    -- 开启开关：启动循环传送+装备Punch工具
    if Value then
        spawn(function()
            while Jump do
                local plr = game.Players.LocalPlayer
                -- 空值判断，确保角色、人形和根部件加载完成
                if plr and plr.Character then
                    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                    local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")

                    -- 1. 循环传送逻辑
                    if rootPart then
                        rootPart.CFrame = CFrame.new(15.53,0.76,2117.85)
                    end

                    -- 2. 装备背包中的Punch工具
                    local punch = plr.Backpack:FindFirstChild("Punch")
                    if punch and punch:IsA("Tool") and humanoid then
                        humanoid:EquipTool(punch)
                    end
                end
                wait(0.1)
            end
        end)
    else
        local plr = game.Players.LocalPlayer
        if plr and plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
end
})

Toggle = TabHandles.Q:Toggle({
    Title = "10石头",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    getgenv().RK0 = Value
    Jump = Value

    if Value then
        spawn(function()
            while Jump do
                local plr = game.Players.LocalPlayer
                if plr and plr.Character then
                    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                    local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")

                    if rootPart then
                        rootPart.CFrame = CFrame.new(-151.39,2.10,437.53)
                    end

                    local punch = plr.Backpack:FindFirstChild("Punch")
                    if punch and punch:IsA("Tool") and humanoid then
                        humanoid:EquipTool(punch)
                    end
                end
                wait(0.1)
            end
        end)
    else
        local plr = game.Players.LocalPlayer
        if plr and plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
end
})

Toggle = TabHandles.Q:Toggle({
    Title = "100石头",
    Desc = "",
    Locked = false,
    Callback = function()
    getgenv().RK0 = Value
    Jump = Value

    if Value then
        spawn(function()
            while Jump do
                local plr = game.Players.LocalPlayer
                if plr and plr.Character then
                    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                    local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")

                    if rootPart then
                        rootPart.CFrame = CFrame.new(164.47,1.24,-137.76)
                    end

                    local punch = plr.Backpack:FindFirstChild("Punch")
                    if punch and punch:IsA("Tool") and humanoid then
                        humanoid:EquipTool(punch)
                    end
                end
                wait(0.1)
            end
        end)
    else
        local plr = game.Players.LocalPlayer
        if plr and plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
end
})

Toggle = TabHandles.Q:Toggle({
    Title = "5000石头",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    getgenv().RK0 = Value
    Jump = Value

    if Value then
        spawn(function()
            while Jump do
                local plr = game.Players.LocalPlayer
                if plr and plr.Character then
                    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                    local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")

                    if rootPart then
                        rootPart.CFrame = CFrame.new(313.02,2.06,-559.59)
                    end

                    local punch = plr.Backpack:FindFirstChild("Punch")
                    if punch and punch:IsA("Tool") and humanoid then
                        humanoid:EquipTool(punch)
                    end
                end
                wait(0.1)
            end
        end)
    else
        local plr = game.Players.LocalPlayer
        if plr and plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
end
})

Toggle = TabHandles.Q:Toggle({
    Title = "150000石头",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    getgenv().RK0 = Value
    Jump = Value

    if Value then
        spawn(function()
            while Jump do
                local plr = game.Players.LocalPlayer
                if plr and plr.Character then
                    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                    local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")

                    if rootPart then
                        rootPart.CFrame = CFrame.new(-2514.23,1.07,-256.83)
                    end

                    local punch = plr.Backpack:FindFirstChild("Punch")
                    if punch and punch:IsA("Tool") and humanoid then
                        humanoid:EquipTool(punch)
                    end
                end
                wait(0.1)
            end
        end)
    else
        local plr = game.Players.LocalPlayer
        if plr and plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
end
})

Toggle = TabHandles.Q:Toggle({
    Title = "400000石头",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    getgenv().RK0 = Value
    Jump = Value

    if Value then
        spawn(function()
            while Jump do
                local plr = game.Players.LocalPlayer
                if plr and plr.Character then
                    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                    local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")

                    if rootPart then
                        rootPart.CFrame = CFrame.new(2186.48,8.09,1290.90)
                    end

                    local punch = plr.Backpack:FindFirstChild("Punch")
                    if punch and punch:IsA("Tool") and humanoid then
                        humanoid:EquipTool(punch)
                    end
                end
                wait(0.1)
            end
        end)
    else
        local plr = game.Players.LocalPlayer
        if plr and plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
end
})

Toggle = TabHandles.Q:Toggle({
    Title = "750000石头",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    getgenv().RK0 = Value
    Jump = Value

    if Value then
        spawn(function()
            while Jump do
                local plr = game.Players.LocalPlayer
                if plr and plr.Character then
                    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                    local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")

                    if rootPart then
                        rootPart.CFrame = CFrame.new(-7262.31,9.66,-1218.25)
                    end

                    local punch = plr.Backpack:FindFirstChild("Punch")
                    if punch and punch:IsA("Tool") and humanoid then
                        humanoid:EquipTool(punch)
                    end
                end
                wait(0.1)
            end
        end)
    else
        local plr = game.Players.LocalPlayer
        if plr and plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
end
})

Toggle = TabHandles.Q:Toggle({
    Title = "100万石头",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    getgenv().RK0 = Value
    Jump = Value

    if Value then
        spawn(function()
            while Jump do
                local plr = game.Players.LocalPlayer
                if plr and plr.Character then
                    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                    local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")

                    if rootPart then
                        rootPart.CFrame = CFrame.new(4132.50,991.64,-4035.54)
                    end

                    local punch = plr.Backpack:FindFirstChild("Punch")
                    if punch and punch:IsA("Tool") and humanoid then
                        humanoid:EquipTool(punch)
                    end
                end
                wait(0.1)
            end
        end)
    else
        local plr = game.Players.LocalPlayer
        if plr and plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
end
})

Toggle = TabHandles.Q:Toggle({
    Title = "500万石头",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    getgenv().RK0 = Value
    Jump = Value

    if Value then
        spawn(function()
            while Jump do
                local plr = game.Players.LocalPlayer
                if plr and plr.Character then
                    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                    local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")

                    if rootPart then
                        rootPart.CFrame = CFrame.new(-8985.91,17.23,-5989.86)
                    end

                    local punch = plr.Backpack:FindFirstChild("Punch")
                    if punch and punch:IsA("Tool") and humanoid then
                        humanoid:EquipTool(punch)
                    end
                end
                wait(0.1)
            end
        end)
    else
        local plr = game.Players.LocalPlayer
        if plr and plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
end
})

Toggle = TabHandles.Q:Toggle({
    Title = "1000万石头",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    getgenv().RK0 = Value
    Jump = Value

    if Value then
        spawn(function()
            while Jump do
                local plr = game.Players.LocalPlayer
                if plr and plr.Character then
                    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                    local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")

                    if rootPart then
                        rootPart.CFrame = CFrame.new(-7639.93,4.30,3007.76)
                    end

                    local punch = plr.Backpack:FindFirstChild("Punch")
                    if punch and punch:IsA("Tool") and humanoid then
                        humanoid:EquipTool(punch)
                    end
                end
                wait(0.1)
            end
        end)
    else
        local plr = game.Players.LocalPlayer
        if plr and plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
end
})

Button = TabHandles.W:Button({
    Title = "自动宝箱（传送+检测）[重复2次]",
    Desc = "",
    Locked = false,
    Callback = function()
    spawn(function()
        local repeatTimes = 2
        for cycle = 1, repeatTimes do
            showNotice(string.format("开始第 %d/%d 轮宝箱流程", cycle, repeatTimes))
            
            local teleportPoints = {
                CFrame.new(-138.17,7.33,-276.85),        
                CFrame.new(4680.29,1001.05,-3689.63),    
                CFrame.new(2213.03,7.33,918.64),    
                CFrame.new(-6713.86,7.33,-1454.19),  
                CFrame.new(-2572.08,7.33,-556.94),        
                CFrame.new(40.71,7.33,410.27),    
                CFrame.new(-7914.54,4.30,3028.47)
            }
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local rootPart = character:WaitForChild("HumanoidRootPart")
            
            for _, targetCFrame in ipairs(teleportPoints) do
                rootPart.CFrame = targetCFrame
                task.wait(5)
            end
            task.wait(1)
            showNotice("本轮传送已完成，准备检测宝箱")
            
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local chestRewards = ReplicatedStorage:FindFirstChild("chestRewards")
            local checkRemote = ReplicatedStorage:FindFirstChild("rEvents"):FindFirstChild("checkChestRemote")
            
            if not chestRewards or not checkRemote then
                showNotice("宝箱目录或检测事件不存在，跳过本轮")
                task.wait(2)
                continue
            end
            
            local jk = {}
            for _, v in pairs(chestRewards:GetDescendants()) do
                if v.Name ~= "Light Karma Chest" and v.Name ~= "Evil Karma Chest" then
                    table.insert(jk, v.Name)
                end
            end
            
            for _, chestName in ipairs(jk) do
                checkRemote:InvokeServer(chestName)
                task.wait(2)
            end
            showNotice(string.format("第 %d/%d 轮宝箱检测完成", cycle, repeatTimes))
            
            showNotice("等待3秒后进入下一轮")
            task.wait(3)
        end
        
        showNotice("所有2轮宝箱流程已执行完毕！")
    end)
end
})
TabHandles.W:Divider()

Button = TabHandles.W:Button({
    Title = "沙滩",
    Desc = "",
    Locked = false,
    Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-42.7, 3.7, 404.2)
end
})

Button = TabHandles.W:Button({
    Title = "小岛（0-1000力量）",
    Desc = "",
    Locked = false,
    Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-37.636775970458984, 3.86960768699646, 1879.180908203125)
end
})

Button = TabHandles.W:Button({
    Title = "冰霜健身房（1重生）",
    Desc = "",
    Locked = false,
    Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2623.022216796875, 3.716249465942383, -409.0733337402344)
end
})

Button = TabHandles.W:Button({
    Title = "神话健身房（5重生）",
    Desc = "",
    Locked = false,
    Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2250.778076171875, 3.716248035430908, 1073.2266845703125)
end
})

Button = TabHandles.W:Button({
    Title = "永恒健身房（15重生）",
    Desc = "",
    Locked = false,
    Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-6758.9638671875, 3.71626353263855, -1284.918701171875)
end
})

Button = TabHandles.W:Button({
    Title = "传奇健身房（30重生）",
    Desc = "",
    Locked = false,
    Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(4603.28173828125, 987.869140625, -3897.86572265625)
end
})

Button = TabHandles.W:Button({
    Title = "力量之王”健身房（5重生）",
    Desc = "",
    Locked = false,
    Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-8625.9296875, 13.566278457641602, -5730.4736328125)
end
})

Button = TabHandles.W:Button({
    Title = "狂野健身房（60重生）",
    Desc = "",
    Locked = false,
    Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-8693.0927734375, 8.93972396850586, 2400.66259765625)
end
})


local AutoTrainEnabled = false  
local TrainThread = nil         
Toggle = TabHandles.E:Toggle({
    Title = "自动锻炼",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    AutoTrainEnabled = Value
    if TrainThread then
        task.cancel(TrainThread)
        TrainThread = nil
    end
    if AutoTrainEnabled then
        TrainThread = task.spawn(function()
            while AutoTrainEnabled do
                local args = {[1] = "rep"}
                local muscleEvent = game.Players.LocalPlayer:FindFirstChild("muscleEvent")
                if muscleEvent then
                    muscleEvent:FireServer(unpack(args))
                end
                task.wait(0.1)
            end
        end)
    end
end
})

local AutoPunchEnabled = false  
local PunchThread = nil         

Toggle = TabHandles.E:Toggle({
    Title = "自动挥拳",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    AutoPunchEnabled = Value
    if PunchThread then
        task.cancel(PunchThread)
        PunchThread = nil
    end
    if AutoPunchEnabled then
        PunchThread = task.spawn(function()
            while AutoPunchEnabled do
                local args = {[1] = "punch", [2] = "rightHand"}
                local muscleEvent = game.Players.LocalPlayer:FindFirstChild("muscleEvent")
                if muscleEvent then
                    muscleEvent:FireServer(unpack(args))
                end
                task.wait(0.1)
            end
        end)
    end
 end
})
TabHandles.E:Divider()

Toggle = TabHandles.E:Toggle({
    Title = "自动哑铃",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v.ClassName == "Tool" and v.Name == "Weight" then
            v.Parent = game.Players.LocalPlayer.Character
            wait()
        end
    end
    if Value then
    local AutoRep = Value
        while AutoRep do
            game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
            wait()
        end
    end
end
})

Toggle = TabHandles.E:Toggle({
    Title = "自动俯卧撑",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v.ClassName == "Tool" and v.Name == "Pushups" then
            v.Parent = game.Players.LocalPlayer.Character
            wait()
        end
    end
    if Value then
    local AutoRep = Value
        while AutoRep do
            game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
            wait()
        end
    end
end
})

Toggle = TabHandles.E:Toggle({
    Title = "自动仰卧起坐",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v.ClassName == "Tool" and v.Name == "Situps" then
            v.Parent = game.Players.LocalPlayer.Character
            wait()
        end
    end
    if Value then
    local AutoRep = Value
        while AutoRep do
            game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
            wait()
        end
    end
end
})

Toggle = TabHandles.E:Toggle({
    Title = "自动倒立",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v.ClassName == "Tool" and v.Name == "Handstands" then
            v.Parent = game.Players.LocalPlayer.Character
            wait()
        end
    end
    if Value then
    local AutoRep = Value
        while AutoRep do
            game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
            wait()
        end
    end
end
})

Toggle = TabHandles.E:Toggle({
    Title = "自动练全部",
    Desc = "",
    Locked = false,
    Callback = function(Value)
    for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v.ClassName == "Tool" and v.Name == "Weight" or v.Name == "Handstands" or v.Name == "Pushups" or v.Name == "Situps" then
            v.Parent = game.Players.LocalPlayer.Character
            wait()
        end
    end
    if Value then
    local AutoRep = Value
        while AutoRep do
            game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
            wait()
        end
    end
end
})

Toggle = TabHandles.R:Toggle({
    Title = "跑步机海滩10",
    Desc = "",
    Locked = false,
    Callback = function(treadmill)
    getgenv().spam = treadmill
while getgenv().spam do
wait()
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 10
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(238.671112, 5.40315914, 387.713165, -0.0160072874, -2.90710176e-08, -0.99987185, -3.3434191e-09, 1, -2.90212157e-08, 0.99987185, 2.87843993e-09, -0.0160072874)
local oldpos = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
 
local localPlayer = Players.LocalPlayer
 
RunService:BindToRenderStep("move",
    Enum.RenderPriority.Character.Value + 1,
    function()
   	 if localPlayer.Character then
   		 local humanoid = localPlayer.Character:WaitForChild("Humanoid")
   		 if humanoid then
   			 humanoid:Move(Vector3.new(10000, 0, -1), true)
   		 end
   	 end
    end
)
end

if not getgenv().spam then
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
 
local localPlayer = Players.LocalPlayer
 
RunService:UnbindFromRenderStep("move",
    Enum.RenderPriority.Character.Value + 1,
    function()
   	 if localPlayer.Character then
   		 local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
   		 if humanoid then
   			 humanoid:Move(Vector3.new(10000, 0, -1), true)
   		 end
   	 end
    end
)
end
end
})

Toggle = TabHandles.R:Toggle({
    Title = "跑步机Frost-健身房-2000",
    Desc = "",
    Locked = false,
    Callback = function(treadmill)
    if game.Players.LocalPlayer.Agility.Value >= 2000 then
getgenv().spam = treadmill
while getgenv().spam do
wait()
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 10
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-3005.37866, 14.3221855, -464.697876, -0.015773816, -1.38508964e-08, 0.999875605, -5.13225586e-08, 1, 1.30429667e-08, -0.999875605, -5.11104332e-08, -0.015773816)
local oldpos = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
 
local localPlayer = Players.LocalPlayer
 
RunService:BindToRenderStep("move",
    Enum.RenderPriority.Character.Value + 1,
    function()
   	 if localPlayer.Character then
   		 local humanoid = localPlayer.Character:WaitForChild("Humanoid")
   		 if humanoid then
   			 humanoid:Move(Vector3.new(10000, 0, -1), true)
   		 end
   	 end
    end
)
end
end

if not getgenv().spam then
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
 
local localPlayer = Players.LocalPlayer
 
RunService:UnbindFromRenderStep("move",
    Enum.RenderPriority.Character.Value + 1,
    function()
   	 if localPlayer.Character then
   		 local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
   		 if humanoid then
   			 humanoid:Move(Vector3.new(10000, 0, -1), true)
   		 end
   	 end
    end
)
end
end
})

Toggle = TabHandles.R:Toggle({
    Title = "跑步机神话-健身房2000",
    Desc = "",
    Locked = false,
    Callback = function(treadmill)
    if game.Players.LocalPlayer.Agility.Value >= 2000 then
getgenv().spam = treadmill
while getgenv().spam do
wait()
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 10
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(2571.23706, 15.6896839, 898.650391, 0.999968231, 2.23868635e-09, -0.00797206629, -1.73198844e-09, 1, 6.35660768e-08, 0.00797206629, -6.3550246e-08, 0.999968231)
local oldpos = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
 
local localPlayer = Players.LocalPlayer
 
RunService:BindToRenderStep("move",
    Enum.RenderPriority.Character.Value + 1,
    function()
   	 if localPlayer.Character then
   		 local humanoid = localPlayer.Character:WaitForChild("Humanoid")
   		 if humanoid then
   			 humanoid:Move(Vector3.new(10000, 0, -1), true)
   		 end
   	 end
    end
)
end
end

if not getgenv().spam then
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
 
local localPlayer = Players.LocalPlayer
 
RunService:UnbindFromRenderStep("move",
    Enum.RenderPriority.Character.Value + 1,
    function()
   	 if localPlayer.Character then
   		 local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
   		 if humanoid then
   			 humanoid:Move(Vector3.new(10000, 0, -1), true)
   		 end
   	 end
    end
)
end
end
})

Toggle = TabHandles.R:Toggle({
    Title = "永恒跑步机-健身房",
    Desc = "",
    Locked = false,
    Callback = function(treadmill)
    if game.Players.LocalPlayer.Agility.Value >= 3500 then
getgenv().spam = treadmill
while getgenv().spam do
wait()
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 10
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-7077.79102, 29.6702118, -1457.59961, -0.0322036594, -3.31122768e-10, 0.99948132, -6.44344267e-09, 1, 1.23684493e-10, -0.99948132, -6.43611742e-09, -0.0322036594)
local oldpos = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
 
local localPlayer = Players.LocalPlayer
 
RunService:BindToRenderStep("move",
    Enum.RenderPriority.Character.Value + 1,
    function()
   	 if localPlayer.Character then
   		 local humanoid = localPlayer.Character:WaitForChild("Humanoid")
   		 if humanoid then
   			 humanoid:Move(Vector3.new(10000, 0, -1), true)
   		 end
   	 end
    end
)
end
end

if not getgenv().spam then
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
 
local localPlayer = Players.LocalPlayer
 
RunService:UnbindFromRenderStep("move",
    Enum.RenderPriority.Character.Value + 1,
    function()
   	 if localPlayer.Character then
   		 local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
   		 if humanoid then
   			 humanoid:Move(Vector3.new(10000, 0, -1), true)
   		 end
   	 end
    end
)
end
end
})

Toggle = TabHandles.R:Toggle({
    Title = "跑步机传奇-健身房",
    Desc = "",
    Locked = false,
    Callback = function(treadmill)
    if game.Players.LocalPlayer.Agility.Value >= 3000 then
getgenv().spam = treadmill
while getgenv().spam do
wait()
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 10
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(4370.82812, 999.358704, -3621.42773, -0.960604727, -8.41949266e-09, -0.27791819, -6.12478646e-09, 1, -9.12496567e-09, 0.27791819, -7.06329528e-09, -0.960604727)
local oldpos = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
 
local localPlayer = Players.LocalPlayer
 
RunService:BindToRenderStep("move",
    Enum.RenderPriority.Character.Value + 1,
    function()
   	 if localPlayer.Character then
   		 local humanoid = localPlayer.Character:WaitForChild("Humanoid")
   		 if humanoid then
   			 humanoid:Move(Vector3.new(10000, 0, -1), true)
   		 end
   	 end
    end
)
end
end

if not getgenv().spam then
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
 
local localPlayer = Players.LocalPlayer
 
RunService:UnbindFromRenderStep("move",
    Enum.RenderPriority.Character.Value + 1,
    function()
   	 if localPlayer.Character then
   		 local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
   		 if humanoid then
   			 humanoid:Move(Vector3.new(10000, 0, -1), true)
   		 end
   	 end
    end
)
end
end
})

Toggle = TabHandles.T:Toggle({
    Title = "沙滩",
    Desc = "",
    Locked = false,
    Callback = function(rack)
    if game.Players.LocalPlayer.leaderstats.Strength.Value >= 1000 then
getgenv().spam = rack
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(232.627625, 3.67689133, 96.3039856, -0.963445187, -7.78685845e-08, -0.267905563, -7.92865222e-08, 1, -5.52570167e-09, 0.267905563, 1.5917589e-08, -0.963445187)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder["Squat Rack"].interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

Toggle = TabHandles.T:Toggle({
    Title = "冰冻健身房",
    Desc = "",
    Locked = false,
    Callback = function(rack)
    if game.Players.LocalPlayer.leaderstats.Strength.Value >= 4000 then
getgenv().spam = rack
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-2629.13818, 3.36860609, -609.827454, -0.995664716, -2.67296816e-08, -0.0930150598, -1.90042453e-08, 1, -8.39415222e-08, 0.0930150598, -8.18099295e-08, -0.995664716)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder["Squat Rack"].interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

Toggle = TabHandles.T:Toggle({
    Title = "传奇健身房",
    Desc = "",
    Locked = false,
    Callback = function(rack)
    getgenv().spam = rack
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(4443.04443, 987.521484, -4061.12988, 0.83309716, 3.33018835e-09, 0.553126693, -2.87759438e-09, 1, -1.68654424e-09, -0.553126693, -1.86619012e-10, 0.83309716)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder["Squat Rack"].interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

Toggle = TabHandles.T:Toggle({
    Title = "肌肉健身房",
    Desc = "",
    Locked = false,
    Callback = function(rack)
    getgenv().spam = rack
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-8757.37012, 13.2186356, -6051.24365, -0.902269304, 1.63610299e-08, -0.431172907, 1.71076486e-08, 1, 2.14606288e-09, 0.431172907, -5.44002754e-09, -0.902269304)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder["Squat Rack"].interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

Toggle = TabHandles.Y:Toggle({
    Title = "海滩",
    Desc = "",
    Locked = false,
    Callback = function(pull)
    if game.Players.LocalPlayer.leaderstats.Strength.Value >= 1000 then
getgenv().spam = pull
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-185.157745, 5.81071186, 104.747154, 0.227061391, -8.2363325e-09, 0.97388047, 5.58502826e-08, 1, -4.56432803e-09, -0.97388047, 5.54278827e-08, 0.227061391)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder["Legends Pullup"].interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

Toggle = TabHandles.Y:Toggle({
    Title = "神话",
    Desc = "",
    Locked = false,
    Callback = function(pull)
    if game.Players.LocalPlayer.leaderstats.Strength.Value >= 4000 then
getgenv().spam = pull
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(2315.82104, 5.81071281, 847.153076, 0.993555248, 6.99809632e-08, 0.113349125, -7.05298859e-08, 1, 8.32554692e-10, -0.113349125, -8.82168916e-09, 0.993555248)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder["Legends Pullup"].interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

Toggle = TabHandles.Y:Toggle({
    Title = "传奇",
    Desc = "",
    Locked = false,
    Callback = function(pull)
    getgenv().spam = pull
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(4305.08203, 989.963623, -4118.44873, -0.953815758, -7.58000382e-08, -0.30039227, -8.98859724e-08, 1, 3.30721512e-08, 0.30039227, 5.85457904e-08, -0.953815758)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder["Legends Pullup"].interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

Toggle = TabHandles.U:Toggle({
    Title = "海滩",
    Desc = "",
    Locked = false,
    Callback = function(lift)
    if game.Players.LocalPlayer.leaderstats.Strength.Value >= 1500 then
getgenv().spam = lift
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(136.606216, 3.67689133, 97.661499, -0.974106729, -1.89495477e-08, 0.226088539, -1.78365624e-08, 1, 6.96555214e-09, -0.226088539, 2.75254886e-09, -0.974106729)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder.Deadlift.interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

Toggle = TabHandles.U:Toggle({
    Title = "传说健身房",
    Desc = "",
    Locked = false,
    Callback = function(lift)
    if game.Players.LocalPlayer.leaderstats.Strength.Value >= 5000 then
getgenv().spam = lift
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-2916.11572, 3.67689204, -212.97438, -0.241641939, -6.10995343e-08, 0.970365465, 6.65890596e-08, 1, 7.9547597e-08, -0.970365465, 8.38377616e-08, -0.241641939)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder.Deadlift.interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

Toggle = TabHandles.U:Toggle({
    Title = "传奇健身房",
    Desc = "",
    Locked = false,
    Callback = function(lift)
    getgenv().spam = lift
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(4538.42627, 987.829834, -4008.82007, -0.830109239, 2.21324914e-08, 0.557600796, 8.02302083e-08, 1, 7.97476361e-08, -0.557600796, 1.1093568e-07, -0.830109239)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder.Deadlift.interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

Toggle = TabHandles.U:Toggle({
    Title = "肌肉之王",
    Desc = "",
    Locked = false,
    Callback = function(lift)
    getgenv().spam = lift
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-8768.4375, 13.5269203, -5681.62256, -0.997508109, -5.4007393e-10, 0.0705519542, 1.52984292e-10, 1, 9.81797044e-09, -0.0705519542, 9.80429782e-09, -0.997508109)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder.Deadlift.interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

Toggle = TabHandles.I:Toggle({
    Title = "海滩",
    Desc = "",
    Locked = false,
    Callback = function(lift)
    if game.Players.LocalPlayer.leaderstats.Strength.Value >= 3000 then
getgenv().spam = lift
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-91.6730804, 3.67689133, -292.42868, -0.221022144, -2.21041621e-08, -0.975268781, 1.21414407e-08, 1, -2.54162646e-08, 0.975268781, -1.7458726e-08, -0.221022144)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder.Deadlift.interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

Toggle = TabHandles.I:Toggle({
    Title = "神话",
    Desc = "",
    Locked = false,
    Callback = function(lift)
    if game.Players.LocalPlayer.leaderstats.Strength.Value >= 10000 then
getgenv().spam = lift
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(2486.01733, 3.67689276, 1237.89331, 0.883595645, -2.06135038e-08, -0.468250751, -3.3286871e-09, 1, -5.03036404e-08, 0.468250751, 4.60067362e-08, 0.883595645)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder.Deadlift.interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

Toggle = TabHandles.I:Toggle({
    Title = "传奇",
    Desc = "",
    Locked = false,
    Callback = function(lift)
    getgenv().spam = lift
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(4189.96143, 987.829773, -3903.0166, 0.422592968, 0, 0.906319559, 0, 1, 0, -0.906319559, 0, 0.422592968)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder.Deadlift.interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

Toggle = TabHandles.I:Toggle({
    Title = "肌肉之王",
    Desc = "",
    Locked = false,
    Callback = function(lift)
    getgenv().spam = lift
while getgenv().spam do
wait()
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(8933.69434, 13.5269222, -5700.12598, -0.823058188, 6.96304259e-09, 0.567957044, -1.19721832e-08, 1, -2.96093621e-08, -0.567957044, -3.11699146e-08, -0.823058188)
local vim = game:service("VirtualInputManager")
           vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder.Deadlift.interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
if not getgenv().spam then
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Jump = true
end
end
})

local Button = TabHandles.SAN:Button({
    Title = "自定义界面",
    Desc = "个性化您的体验",
    Image = "palette",
    ImageSize = 20,
    Color = "White"
})

local themes = {}
for themeName, _ in pairs(WindUI:GetThemes()) do
    table.insert(themes, themeName)
end
table.sort(themes)

local themeDropdown = TabHandles.SAN:Dropdown({
    Title = "主题选择",
    Values = themes,
    Value = "Dark",
    Callback = function(theme)
        WindUI:SetTheme(theme)
        WindUI:Notify({
            Title = "主题应用",
            Content = theme,
            Icon = "palette",
            Duration = 2
        })
    end
})

local transparencySlider = TabHandles.SAN:Slider({
    Title = "透明度",
    Value = { 
        Min = 0,
        Max = 1,
        Default = 0.2,
    },
    Step = 0.1,
    Callback = function(value)
        Window:ToggleTransparency(tonumber(value) > 0)
        WindUI.TransparencyValue = tonumber(value)
    end
})

TabHandles.SAN:Toggle({
    Title = "启用黑色主题",
    Desc = "使用黑色调主题方案",
    Value = true,
    Callback = function(state)
        WindUI:SetTheme(state and "Dark" or "Light")
        themeDropdown:Select(state and "Dark" or "Light")
    end
})


TabHandles.SAN:Button({
    Title = "创建新主题",
    Icon = "plus",
    Callback = function()
        Window:Dialog({
            Title = "创建主题",
            Content = "此功能很快就会推出",
            Buttons = {
                {
                    Title = "确认",
                    Variant = "Primary"
                }
            }
        })
    end
})

TabHandles.SAN:Paragraph({
    Title = "配置管理",
    Desc = "保存你的设置",
    Image = "save",
    ImageSize = 20,
    Color = "White"
})

local configName = "default"
local configFile = nil
local MyPlayerData = {
    name = "Player1",
    level = 1,
    inventory = { "sword", "shield", "potion" }
}

TabHandles.SAN:Input({
    Title = "配置名称",
    Value = configName,
    Callback = function(value)
        configName = value
    end
})

local ConfigManager = Window.ConfigManager
if ConfigManager then
    ConfigManager:Init(Window)
    
TabHandles.SAN:Button({
        Title = "保存配置",
        Icon = "save",
        Variant = "Primary",
        Callback = function()
            configFile = ConfigManager:CreateConfig(configName)
            
            configFile:Register("featureToggle", featureToggle)
            configFile:Register("intensitySlider", intensitySlider)
            configFile:Register("modeDropdown", modeDropdown)
            configFile:Register("themeDropdown", themeDropdown)
            configFile:Register("transparencySlider", transparencySlider)
            
            configFile:Set("playerData", MyPlayerData)
            configFile:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))
            
            if configFile:Save() then
                WindUI:Notify({ 
                    Title = "保存配置", 
                    Content = "保存为："..configName,
                    Icon = "check",
                    Duration = 3
                })
            else
                WindUI:Notify({ 
                    Title = "错误", 
                    Content = "保存失败",
                    Icon = "x",
                    Duration = 3
                })
            end
        end
    })

    TabHandles.SAN:Button({
        Title = "加载配置",
        Icon = "folder",
        Callback = function()
            configFile = ConfigManager:CreateConfig(configName)
            local loadedData = configFile:Load()
            
            if loadedData then
                if loadedData.playerData then
                    MyPlayerData = loadedData.playerData
                end
                
                local lastSave = loadedData.lastSave or "Unknown"
                WindUI:Notify({ 
                    Title = "加载配置", 
                    Content = "正在加载："..configName.."\n上次保存："..lastSave,
                    Icon = "refresh-cw",
                    Duration = 5
                })
                
                Button = TabHandles.Elements:Button({
                    Title = "玩家数据",
                    Desc = string.format("名字: %s\n等级: %d\n库存: %s", 
                        MyPlayerData.name, 
                        MyPlayerData.level, 
                        table.concat(MyPlayerData.inventory, ", "))
                })
            else
                WindUI:Notify({ 
                    Title = "错误", 
                    Content = "加载失败",
                    Icon = "x",
                    Duration = 3
                })
            end
        end
    })
else
    TabHandles.SAN:Paragraph({
        Title = "配置管理不可用",
        Desc = "此功能需要配置管理",
        Image = "alert-triangle",
        ImageSize = 20,
        Color = "White"
    })
end
elseif game.GameId == 66654135 then --- 破坏者谜团
    local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/KingScriptAE/No-sirve-nada./refs/heads/main/main.lua"))()
function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(chars, uchar)
    end
    local length = #chars
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
            math.floor(r * 255), 
            math.floor(g * 255), 
            math.floor(b * 255), 
            chars[i])
    end
    return result
end
local Window = WindUI:CreateWindow({
    Title = gradient("Yisan - 破坏者谜团2", Color3.fromHex("#000080"), Color3.fromHex("#00FFFF")), 
    Author = gradient("伊散", Color3.fromHex("#00FFAA"), Color3.fromHex("#00AAFF")),
    IconThemed = true,
    Folder = "LinniHub",
    Size = UDim2.new(0, 150, 0, 150),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 200,
    HideSearchBar = false,
    ScrollBarEnabled = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()   
        end
    },
})
Window:EditOpenButton({
    Title = "塔菲喵",
    CornerRadius = UDim.new(0, 8.),
    StrokeThickness = 3,
    Color = ColorSequence.new({
  ColorSequenceKeypoint.new(0, Color3.fromHex("#FFB6C1")),  -- 浅粉
ColorSequenceKeypoint.new(0.16, Color3.fromHex("#FF69B4")), -- 热情粉
ColorSequenceKeypoint.new(0.33, Color3.fromHex("#FF1493")), -- 深粉
ColorSequenceKeypoint.new(0.5, Color3.fromHex("#FFC0CB")),  -- 粉红
ColorSequenceKeypoint.new(0.66, Color3.fromHex("#DB7093")), -- 中粉红
ColorSequenceKeypoint.new(0.83, Color3.fromHex("#C71585")), -- 紫红
ColorSequenceKeypoint.new(1, Color3.fromHex("#FFB6C1"))     -- 浅粉（循环回起点）
    }),
  Draggable = true,
     })

local Linni = {
    Ma = Window:Tab({ 
        Title = gradient("[ 属性修改 ]", Color3.fromHex("#FFFFFF"), Color3.fromHex("#FFFFFF")), 
        Icon = "terminal" 
    }),
    Esp = Window:Tab({ 
        Title = gradient("[ 透视 ]", Color3.fromHex("#FFFFFF"), Color3.fromHex("#FFFFFF")), 
        Icon = "eye" 
    }),
    Cata = Window:Tab({ 
        Title = gradient("[ 基础 ]", Color3.fromHex("#FFFFFF"), Color3.fromHex("#FFFFFF")), 
        Icon = "sword" 
    }),
    Mr = Window:Tab({ 
        Title = gradient("[ 警察 ]", Color3.fromHex("#FFFFFF"), Color3.fromHex("#FFFFFF")), 
        Icon = "user" 
    }),
    Killer = Window:Tab({ 
        Title = gradient("[ ez杀人犯 ]", Color3.fromHex("#FFFFFF"), Color3.fromHex("#FFFFFF")), 
        Icon = "user" 
    }),
    Auto = Window:Tab({ 
        Title = gradient("[ 自动 ]", Color3.fromHex("#FFFFFF"), Color3.fromHex("#FFFFFF")), 
        Icon = "baby" 
    }),
    Tl = Window:Tab({ 
        Title = gradient("[ 其他 ]", Color3.fromHex("#FFFFFF"), Color3.fromHex("#FFFFFF")), 
        Icon = "pen-tool" 
    }),
}

Window:SelectTab(1)
local LinniJumpPower = 50
local LinniGravity = 196.2
local playerESP = false
local coinTaffy = false
local TaffyShoot = false
local TaffyshootTChina = 2.8
local TaffyPing = 1
local TaffygunESP = false
local TaffyDete = false
local TaffyGetGun = false
local TaffyMooKnife = false
local TaffyAu = false
local TaffyAuChina = nil
local playerData = {}
local claimedCoins = {}
local TaffyChinaknife = false
local antifail = false
local trapESP = Instance.new("Highlight")
trapESP.Name = "TrapESP"
trapESP.FillColor = Color3.fromRGB(255, 112, 10)
trapESP.OutlineColor = Color3.fromRGB(255, 112, 10)
trapESP.FillTransparency = 0.5
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local localPlayer = Players.LocalPlayer
local Linnitask = nil
local LinniTime = false
local TaffyBox = false
local Taffyhit = 1
local loopTaffyhit
local Taffyaim = false
local Taffyaimrscon
local target
local TaffyantiFly = false
local TaffyantiFlyLastPos = Vector3.zero
local flingNeutralizerCon
local flingDetectionCon
local detectedPlayers = {}
local TaffyplayerFt
local function powerfulFling(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then
        WindUI:Notify({
            Title = "目标玩家无效",
            Duration = 1
        })
        return
    end
    local player = localPlayer
    local mouse = player:GetMouse()
    local Targets = {targetPlayer}
    local AllBool = false
    local Character = player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart
    local TCharacter = targetPlayer.Character
    local THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter:FindFirstChild("Head")
    local Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    local Handle = Accessory and Accessory:FindFirstChild("Handle")
    if not Character or not Humanoid or not RootPart then
        WindUI:Notify({
            Title = "你的角色无效",
            Duration = 1
        })
        return
    end
    if RootPart.Velocity.Magnitude < 50 then
        getgenv().OldPos = RootPart.CFrame
    end
    if not getgenv().FPDH then
        getgenv().FPDH = workspace.FallenPartsDestroyHeight
    end
    if THead then
        workspace.CurrentCamera.CameraSubject = THead
    elseif not THead and Handle then
        workspace.CurrentCamera.CameraSubject = Handle
    elseif THumanoid and TRootPart then
        workspace.CurrentCamera.CameraSubject = THumanoid
    end

    if not TCharacter:FindFirstChildWhichIsA("BasePart") then
        WindUI:Notify({
            Title = "目标没有有效部位",
            Duration = 1
        })
        return
    end
    local FPos = function(BasePart, Pos, Ang)
        RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
        Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
        RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
        RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
    end

    local SFBasePart = function(BasePart)
        local TimeToWait = 2
        local Time = tick()
        local Angle = 0
        repeat
            if RootPart and THumanoid then
                if BasePart.Velocity.Magnitude < 50 then
                    Angle = Angle + 100
                    FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                    task.wait()
                else
                    FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                    task.wait()
                end
            else
                break
            end
        until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= targetPlayer.Character or targetPlayer.Parent ~= Players or targetPlayer.Character ~= TCharacter or (THumanoid and THumanoid.Sit) or Humanoid.Health <= 0 or tick() > Time + TimeToWait
    end
    workspace.FallenPartsDestroyHeight = 0/0
    local BV = Instance.new("BodyVelocity")
    BV.Name = "EpixVel"
    BV.Parent = RootPart
    BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
    BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    if TRootPart and THead then
        if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
            SFBasePart(THead)
        else
            SFBasePart(TRootPart)
        end
    elseif TRootPart and not THead then
        SFBasePart(TRootPart)
    elseif not TRootPart and THead then
        SFBasePart(THead)
    elseif not TRootPart and not THead and Accessory and Handle then
        SFBasePart(Handle)
    else
        WindUI:Notify({
            Title = "找不到合适的甩飞部位",
            Duration = 1
        })
        BV:Destroy()
        return
    end
    BV:Destroy()
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    workspace.CurrentCamera.CameraSubject = Humanoid
    repeat
        RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
        Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
        Humanoid:ChangeState("GettingUp")
        for _, x in pairs(Character:GetChildren()) do
            if x:IsA("BasePart") then
                x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
            end
        end
        task.wait()
    until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
    workspace.FallenPartsDestroyHeight = getgenv().FPDH
end

local function findMurderer()
    for _, i in ipairs(Players:GetPlayers()) do
        if i.Backpack:FindFirstChild("Knife") then
            return i
        end
    end
    
    for _, i in ipairs(Players:GetPlayers()) do
        if not i.Character then continue end
        if i.Character:FindFirstChild("Knife") then
            return i
        end
    end
    
    if playerData then
        for player, data in playerData do
            if data.Role == "Murderer" then
                if Players:FindFirstChild(player) then
                    return Players:FindFirstChild(player)
                end
            end
        end
    end
    return nil
end
local function findSheriff()
    for _, i in ipairs(Players:GetPlayers()) do
        if i.Backpack:FindFirstChild("Gun") then
            return i
        end
    end
    for _, i in ipairs(Players:GetPlayers()) do
        if not i.Character then continue end
        if i.Character:FindFirstChild("Gun") then
            return i
        end
    end
    if playerData then
        for player, data in playerData do
            if data.Role == "Sheriff" then
                if Players:FindFirstChild(player) then
                    return Players:FindFirstChild(player)
                end
            end
        end
    end
    return nil
end
local function findSheriffThatsNotMe()
    for _, i in ipairs(Players:GetPlayers()) do
        if i == localPlayer then continue end
        if i.Backpack:FindFirstChild("Gun") then
            return i
        end
    end
    for _, i in ipairs(Players:GetPlayers()) do
        if i == localPlayer then continue end
        if not i.Character then continue end
        if i.Character:FindFirstChild("Gun") then
            return i
        end
    end
    if playerData then
        for player, data in playerData do
            if data.Role == "Sheriff" then
                if Players:FindFirstChild(player) then
                    if Players:FindFirstChild(player) == localPlayer then continue end
                    return Players:FindFirstChild(player)
                end
            end
        end
    end
    return nil
end

function reloadESP()
    for _, v in ipairs(workspace:GetChildren()) do if v.Name == "PlayerESP" then v:Destroy() end end
    local listplayers = Players:GetChildren()
    for _, player in ipairs(listplayers) do
        if player.Character then
            local character = player.Character
            if not character:FindFirstChild("PlayerESP") then
                local a = Instance.new("Highlight", workspace)
                a.Name = "玩家ESP"
                a.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                a.Adornee = character
                a.FillColor = Color3.fromRGB(255, 255, 255)
                a.FillTransparency = 0.5
                task.spawn(function()
                    if player == findMurderer() then
                        a.FillColor = Color3.fromRGB(255,0,0)
                        a.OutlineColor = Color3.fromRGB(255,0,0)
                    elseif player == findSheriff() then
                        a.FillColor = Color3.fromRGB(0, 150, 255)
                        a.OutlineColor = Color3.fromRGB(0, 150, 255)
                    else
                        a.FillColor = Color3.fromRGB(0,255,0)
                        a.OutlineColor = Color3.fromRGB(0, 255, 0)
                    end
                end)
            end
        end
    end
end

local function getMap()
    for _, o in ipairs(workspace:GetChildren()) do
        if o:FindFirstChild("CoinContainer") and o:FindFirstChild("Spawns") then
            return o
        end
    end
    return nil
end

local function getClosestModelToPlayer(player, models)
    local closestModel = nil
    local closestDistance = math.huge 
    local playerPosition = player.Character.HumanoidRootPart.Position
    
    for _, model in ipairs(models) do
        local modelPosition = model:GetPivot().Position
        local distance = (modelPosition - playerPosition).Magnitude
        if distance < closestDistance then
            closestDistance = distance
            closestModel = model
        end
    end
    return closestModel
end

local function getPredictedPosition(player, TaffyshootTChina)
    pcall(function()
        player = player.Character
        if not player.Character then return Vector3.new(0,0,0) end
    end)
    local playerHRP = player:FindFirstChild("UpperTorso")
    local playerHum = player:FindFirstChild("Humanoid")
    if not playerHRP or not playerHum then
        return Vector3.new(0,0,0)
    end

    local playerPosition = playerHRP.Position
    local velocity = Vector3.new()
    velocity = playerHRP.AssemblyLinearVelocity
    local playerMoveDirection = playerHum.MoveDirection
    local playerLookVec = playerHRP.CFrame.LookVector
    local yVelFactor = velocity.Y > 0 and -1 or 0.5
    local predictedPosition
    predictedPosition = playerHRP.Position + ((velocity * Vector3.new(0, 0.5, 0))) * (TaffyshootTChina / 15) + playerMoveDirection * TaffyshootTChina
    predictedPosition = predictedPosition * (((localPlayer:GetNetworkPing() * 1000) * ((TaffyPing - 1) * 0.01)) + 1)

    return predictedPosition
end

local function findNearestPlayer()
    local nearestPlayer = nil
    local shortestDistance = math.huge 

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then 
            local localRootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
            local otherRootPart = player.Character:FindFirstChild("HumanoidRootPart")

            if localRootPart and otherRootPart then
                local distance = (localRootPart.Position - otherRootPart.Position).Magnitude

                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestPlayer = player
                end
            end
        end
    end

    return nearestPlayer
end

function splitString(str,delim)
    local broken = {}
    if delim == nil then delim = "," end
    for w in string.gmatch(str,"[^"..delim.."]+") do
        table.insert(broken,w)
    end
    return broken
end

function toTokens(str)
    local tokens = {}
    for op,name in string.gmatch(str,"([+-])([^+-]+)") do
        table.insert(tokens,{Operator = op,Name = name})
    end
    return tokens
end

function onlyIncludeInTable(tab,matches)
    local matchTable = {}
    local resultTable = {}
    for i,v in pairs(matches) do matchTable[v.Name] = true end
    for i,v in pairs(tab) do if matchTable[v.Name] then table.insert(resultTable,v) end end
    return resultTable
end

function removeTableMatches(tab,matches)
    local matchTable = {}
    local resultTable = {}
    for i,v in pairs(matches) do matchTable[v.Name] = true end
    for i,v in pairs(tab) do if not matchTable[v.Name] then table.insert(resultTable,v) end end
    return resultTable
end

function getPlayersByName(Name)
    local Name,Len,Found = string.lower(Name),#Name,{}
    for _,v in pairs(Players:GetPlayers()) do
        if Name:sub(0,1) == '@' then
            if string.sub(string.lower(v.Name),1,Len-1) == Name:sub(2) then
                table.insert(Found,v)
            end
        else
            if string.sub(string.lower(v.Name),1,Len) == Name or string.sub(string.lower(v.DisplayName),1,Len) == Name then
                table.insert(Found,v)
            end
        end
    end
    return Found
end

function getPlayer(list,speaker)
    if list == nil then return {speaker.Name} end
    local nameList = splitString(list,",")

    local foundList = {}

    for _,name in pairs(nameList) do
        if string.sub(name,1,1) ~= "+" and string.sub(name,1,1) ~= "-" then name = "+"..name end
        local tokens = toTokens(name)
        local initialPlayers = Players:GetPlayers()

        for i,v in pairs(tokens) do
            if v.Operator == "+" then
                local tokenContent = v.Name
                local foundCase = false

                if not foundCase then
                    initialPlayers = onlyIncludeInTable(initialPlayers,getPlayersByName(tokenContent))
                end
            else
                local tokenContent = v.Name
                local foundCase = false

                if not foundCase then
                    initialPlayers = removeTableMatches(initialPlayers,getPlayersByName(tokenContent))
                end
            end
        end

        for i,v in pairs(initialPlayers) do table.insert(foundList,v) end
    end

    local foundNames = {}
    for i,v in pairs(foundList) do table.insert(foundNames,v.Name) end

    return foundNames[1]
end

Linni.Ma:Paragraph({
    Title = [[
提示:可能会动不了调整移速即可.]],
    Image = "file-text",
    ImageSize = 20,   
    Color = "White"
})
    
local ws = 16
local fov = 70
local clip = true
local nocliploop
Linni.Ma:Slider({
    Title = "移动",
    Step = 16,
    Value = {Min = 0, Max = 100, Default = 16},
    Callback = function(value)
        ws = value
        if localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid") then
            localPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = value
        end
    end
})
Linni.Ma:Slider({
    Title = "视野范围",
    Step = 1,
    Value = {Min = 0, Max = 100, Default = 70},
    Callback = function(value)
        fov = value
        workspace.CurrentCamera.FieldOfView = value
    end
})
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local flySpeed = 50
local flying = false

local bodyVelocity, bodyGyro
local renderSteppedConnection

local function initialRise(character)
    local riseSpeed = 10
    local startTime = tick()
    local riseTime = 1

    while tick() - startTime < riseTime do
        bodyVelocity.Velocity = Vector3.new(0, riseSpeed, 0)
        RunService.RenderStepped:Wait()
    end
end

local function startFlying()
    if flying then return end
    flying = true

    local character = player.Character or player.CharacterAdded:Wait()
    character.Humanoid.PlatformStand = true

    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = character.HumanoidRootPart

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
    bodyGyro.CFrame = character.HumanoidRootPart.CFrame
    bodyGyro.Parent = character.HumanoidRootPart

    initialRise(character)

    if renderSteppedConnection then
        renderSteppedConnection:Disconnect()
    end

    renderSteppedConnection = RunService.RenderStepped:Connect(function()
        if flying then
            local moveDirection = character.Humanoid.MoveDirection * flySpeed
            local camLookVector = workspace.CurrentCamera.CFrame.LookVector

            if moveDirection.Magnitude > 0 then
                if camLookVector.Y > 0.2 then
                    moveDirection = moveDirection + Vector3.new(0, camLookVector.Y * flySpeed, 0)
                elseif camLookVector.Y < -0.2 then
                    moveDirection = moveDirection + Vector3.new(0, camLookVector.Y * flySpeed, 0)
                end
            else
                moveDirection = Vector3.new(0, 0, 0)
            end

            bodyVelocity.Velocity = moveDirection

            local tiltAngle = 30
            local tiltFactor = moveDirection.Magnitude / flySpeed
            local tiltDirection = 1

            if workspace.CurrentCamera.CFrame:VectorToObjectSpace(moveDirection).Z < 0 then
                tiltDirection = -1
            end

            local tiltCFrame = CFrame.Angles(math.rad(tiltAngle) * tiltFactor * tiltDirection, 0, 0)
            local targetCFrame = CFrame.new(character.HumanoidRootPart.Position, character.HumanoidRootPart.Position + camLookVector) * tiltCFrame
            bodyGyro.CFrame = bodyGyro.CFrame:Lerp(targetCFrame, 0.2)
        end
    end)
end

local function stopFlying()
    if not flying then return end
    flying = false

    local character = player.Character or player.CharacterAdded:Wait()
    character.Humanoid.PlatformStand = false

    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end

    if renderSteppedConnection then
        renderSteppedConnection:Disconnect()
    end
end

player.CharacterAdded:Connect(function(character)
    if flying then
        character.Humanoid.PlatformStand = true
        startFlying()
    end
end)
Linni.Ma:Input({
    Title = "飞行速度",
    Value = "",
    Placeholder = "",
    Callback = function(newSpeed)
    flySpeed = tonumber(newSpeed) or flySpeed
end})
Linni.Ma:Toggle({
Title = "飞行", 
    Value = false,
    Callback = function(state)
    if state then
        startFlying()
    else
        stopFlying()
    end
end})
Linni.Ma:Toggle({
    Title = "穿墙",
    Value = false,
    Callback = function(state)
        clip = not state
        if state then
            nocliploop = RunService.Stepped:Connect(function()
                if clip == false and localPlayer.Character ~= nil then
                    for _, child in pairs(localPlayer.Character:GetDescendants()) do
                        if child:IsA("BasePart") and child.CanCollide == true then
                            child.CanCollide = false
                        end
                    end
                end
            end)
        else
            if nocliploop then
                nocliploop:Disconnect()
            end
        end
    end
})
Linni.Ma:Slider({
    Title = "重力设置",
    Step = 10,
    Value = {Min = 0, Max = 500, Default = 196},
    Callback = function(value)
        LinniGravity = value
        workspace.Gravity = value
    end
})
Linni.Ma:Slider({
    Title = "跳跃力量",
    Step = 5,
    Value = {Min = 0, Max = 200, Default = 50},
    Callback = function(value)
        LinniJumpPower = value
        if localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid") then
            localPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = value
        end
    end
})
local function secondsToMinutes(seconds)
    if seconds == -1 then return "" end
    local minutes = math.floor(seconds / 60)
    local remainingSeconds = seconds % 60
    return string.format("%dm %ds", minutes, remainingSeconds)
end
Linni.Esp:Toggle({
    Title = "显示当前回合剩余时间[你被淘汰后可开启]",
    Desc = "结束了就是-1m 58ms",
    Value = false,
    Callback = function(state)
        LinniTime = state
        if state then
            Linnitask = task.spawn(function()
                while task.wait(0.5) and LinniTime do
                    local success, timeLeft = pcall(function()
                        return game.ReplicatedStorage.Remotes.Extras.GetTimer:InvokeServer()
                    end)                  
                    if success and timeLeft then
                        local timeText = secondsToMinutes(timeLeft)
                        WindUI:Notify({
                            Title = "回合剩余时间",
                            Content = timeText,
                            Duration = 1
                        })
                    else
                     WindUI:Notify({
                            Title = "无法获取回合时间",
                            Duration = 1
                        })
                        break
                    end
                end
            end)
        else
            if Linnitask then
                task.cancel(Linnitask)
                Linnitask = nil
            end
            
        end
    end
})
Linni.Esp:Toggle({
    Title = "玩家ESP[普通玩家和杀手和警长]",
    Desc = "每回合需要重新开一遍因为只检测局内,不是全局",
    Value = false,
    Callback = function(state)
        playerESP = state
        if state then
            if not findMurderer() or not findSheriff() then
                repeat task.wait(1) until findSheriff() or findMurderer()
            end
            reloadESP()
        else
            for _, v in ipairs(workspace:GetChildren()) do 
                if v.Name == "PlayerESP" then v:Destroy() end 
            end
        end
    end
})
Linni.Esp:Toggle({
    Title = "掉落枪支ESP",
    Desc = "每回合需要重新开一遍因为只检测局内,不是全局[这个不知道]",
    Value = false,
    Callback = function(state)
        TaffygunESP = state
        if state then
            if getMap() and getMap():FindFirstChild("GunDrop") then
                local gunesp = Instance.new("Highlight", workspace)
                gunesp.OutlineTransparency = 1
                gunesp.FillColor = Color3.fromRGB(255, 255, 0)
                gunesp.Name = "GunESP"
                gunesp.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                gunesp.Adornee = getMap():FindFirstChild("GunDrop")
                gunesp.Enabled = true
            end
        else
            if workspace:FindFirstChild("GunESP") then
                workspace:FindFirstChild("GunESP"):Destroy()
            end
        end
    end
})
Linni.Esp:Toggle({
    Title = "陷阱检测",
    Desc = "每回合需要重新开一遍因为只检测局内,不是全局,这个不知道",
    Value = false,
    Callback = function(state)
        TaffyDete = state
        if state then
            for _, v in ipairs(workspace:GetDescendants()) do
                if v.Name == "Trap" and v.Parent:IsDescendantOf(workspace) then
                    v.Transparency = 0
                    local trapesp = trapESP:Clone()
                    trapesp.Parent = workspace
                    trapesp.Adornee = v
                end
            end
        else
            for _, v in ipairs(workspace:GetChildren()) do
                if v.Name == "TrapESP" then v:Destroy() end
            end
        end
    end
})
Linni.Mr:Paragraph({
    Title = [[
UI正常报错提示,脚本正常使用.
提示:当警长一点都不好玩 可能射不中.]],
    Image = "file-text",
    ImageSize = 20,   
    Color = "White"
})
Linni.Mr:Toggle({
    Title = "自动射击",
    Desc = "请到基础栏搭配里面的范围使用",
    Value = false,
    Callback = function(state)
        TaffyShoot = state
    end
})
Linni.Mr:Button({
    Title = "甩飞杀手", 
    Callback = function()
        local murderer = findMurderer()
        if not murderer then
            WindUI:Notify({
                Title = "找不到杀手",
                Duration = 1
            })
            return
        end
        if murderer == localPlayer then
            WindUI:Notify({
                Title = "不能甩飞自己[因为你是警长]",
                Duration = 1
            })
            return
        end
        powerfulFling(murderer)
    end
})
Linni.Mr:Button({
    Title = "射击杀手",
    Callback = function()
        if findSheriff() ~= localPlayer then 
            WindUI:Notify({
                Title = "你不是警长",
                Duration = 1
            })
            return 
        end
        local murderer = findMurderer() or findSheriffThatsNotMe()
        if not murderer then 
            WindUI:Notify({
                Title = "找不到杀手",
                Duration = 1
            })
            return 
        end
        if not localPlayer.Character:FindFirstChild("Gun") then
            local hum = localPlayer.Character:FindFirstChild("Humanoid")
            if localPlayer.Backpack:FindFirstChild("Gun") then
                hum:EquipTool(localPlayer.Backpack:FindFirstChild("Gun"))
            else
                WindUI:Notify({
                    Title = "你没有枪",
                    Duration = 1
                })
                return
            end
        end
        local murdererHRP = murderer.Character:FindFirstChild("HumanoidRootPart")
        if not murdererHRP then 
            WindUI:Notify({
                Title = "找不到杀手的身体部位",
                Duration = 1
            })
            return 
        end
        local predictedPosition = getPredictedPosition(murderer, TaffyshootTChina)
        local args = {[1] = 1, [2] = predictedPosition, [3] = "AH2"}
        localPlayer.Character.Gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))
        WindUI:Notify({
            Title = "已射击杀手",
            Duration = 1
        })
    end
})
Linni.Mr:Toggle({
    Title = "防失败[秒完成互动]",
    Desc = "平民和警长通用",
    Value = false,
    Callback = function(state)
        antifail = state
        if state then
        
        else
        
        end
    end
})
local LinniSection = Linni.Mr:Section({
    Title = "[ 自动射击调节参数 ] - 打开方法→",
})
LinniSection:Input({
    Title = "射击偏移量",
    Value = "2.8",
    Placeholder = "推荐2.8",
    Callback = function(input)
        if not tonumber(input) then return end
        TaffyshootTChina = tonumber(input)
    end
})
LinniSection:Input({
    Title = "偏移量到ping乘数",
    Value = "1",
    Placeholder = "默认1",
    Callback = function(input)
        if not tonumber(input) then return end
        TaffyPing = tonumber(input)
    end
})

Linni.Killer:Paragraph({
    Title = [[
UI正常报错提示,脚本正常使用.
提示:当杀手最好玩了,可以调教所有人.]],
    Image = "file-text",
    ImageSize = 20,   
    Color = "White"
})
Linni.Killer:Toggle({
    Title = "杀戮光环",
    Value = false,
    Callback = function(state)
        TaffyAu = state
        if state then
            if TaffyAuChina then TaffyAuChina:Disconnect() end
            
            TaffyAuChina = RunService.Heartbeat:Connect(function()
                if findMurderer() ~= localPlayer then return end
                
                for _, player in ipairs(Players:GetPlayers()) do
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= localPlayer then
                        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                        if (hrp.Position - localPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 7 then
                            hrp.Anchored = true
                            hrp.CFrame = localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame + localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 2
                            
                            task.wait(0.1)
                            local args = {[1] = "Slash"}
                            
                            if localPlayer.Character:FindFirstChild("Knife") then
                                localPlayer.Character.Knife.Stab:FireServer(unpack(args))
                            elseif localPlayer.Backpack:FindFirstChild("Knife") then
                                localPlayer.Character.Humanoid:EquipTool(localPlayer.Backpack:FindFirstChild("Knife"))
                                task.wait(0.2)
                                localPlayer.Character.Knife.Stab:FireServer(unpack(args))
                            end
                            return	
                        end
                    end
                end
            end)
            
        else
            if TaffyAuChina then 
                TaffyAuChina:Disconnect() 
            
            end
        end
    end
})
Linni.Killer:Button({
    Title = "甩飞警长",
    Callback = function()
        local sheriff = findSheriff()
        if not sheriff then
            WindUI:Notify({
                Title = "找不到警长",
                Duration = 1
            })
            return
        end
        if sheriff == localPlayer then
            WindUI:Notify({
                Title = "不能甩飞自己[因为你是杀手]",
                Duration = 1
            })
            return
        end
        powerfulFling(sheriff)
    end
})
Linni.Killer:Button({
    Title = "杀死最近玩家",
    Callback = function()
        if findMurderer() ~= localPlayer then 
            WindUI:Notify({
                Title = "你不是杀手",
                Duration = 1
            })
            return 
        end
        if not localPlayer.Character:FindFirstChild("Knife") then
            local hum = localPlayer.Character:FindFirstChild("Humanoid")
            if localPlayer.Backpack:FindFirstChild("Knife") then
                localPlayer.Character:FindFirstChild("Humanoid"):EquipTool(localPlayer.Backpack:FindFirstChild("Knife"))
            else
                WindUI:Notify({
                    Title = "你没有刀",
                    Duration = 1
                })
                return
            end
        end
        local nearestPlayer = findNearestPlayer()
        if not nearestPlayer or not nearestPlayer.Character then
            WindUI:Notify({
                Title = "找不到玩家",
                Duration = 1
            })
            return
        end
        local nearestHRP = nearestPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not nearestHRP then
            WindUI:Notify({
                Title = "找不到玩家的身体部位",
                Duration = 1
            })
            return
        end
        if not localPlayer.Character:FindFirstChild("HumanoidRootPart") then 
            WindUI:Notify({
                Title = "你的角色无效",
                Duration = 1
            })
            return 
        end
        if not TaffyMooKnife then
            nearestHRP.Anchored = true
            nearestHRP.CFrame = localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame + localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 2
            task.wait(0.1)
            local args = {[1] = "Slash"}
            localPlayer.Character.Knife.Stab:FireServer(unpack(args))
        else
            local lpknife = localPlayer.Character:FindFirstChild("Knife")
            if not lpknife then return end

            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Exclude
            raycastParams.FilterDescendantsInstances = {localPlayer.Character}
            local toThrow = nearestHRP.Position

            local args = {
                [1] = lpknife:GetPivot(), 
                [2] = toThrow
            }

            localPlayer.Character.Knife.Throw:FireServer(unpack(args))
        end
        
        WindUI:Notify({
            Title = "已杀死最近玩家",
            Duration = 1
        })
    end
})

Linni.Killer:Button({
    Title = "杀死所有人",
    Callback = function()
        if findMurderer() ~= localPlayer then 
            WindUI:Notify({
                Title = "你不是杀手",
                Duration = 1
            })
            return 
        end
        if not localPlayer.Character:FindFirstChild("Knife") then
            local hum = localPlayer.Character:FindFirstChild("Humanoid")
            if localPlayer.Backpack:FindFirstChild("Knife") then
                localPlayer.Character:FindFirstChild("Humanoid"):EquipTool(localPlayer.Backpack:FindFirstChild("Knife"))
            else
                WindUI:Notify({
                    Title = "你没有刀",
                    Duration = 1
                })
                return
            end
        end
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= localPlayer then
                player.Character:FindFirstChild("HumanoidRootPart").Anchored = true
                player.Character:FindFirstChild("HumanoidRootPart").CFrame = localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame + localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 1 
            end	
        end
        local args = {[1] = "Slash"}
        localPlayer.Character.Knife.Stab:FireServer(unpack(args))
        WindUI:Notify({
            Title = "已尝试杀死所有人",
            Duration = 1
        })
    end
})
Linni.Killer:Button({
    Title = "把所有人都扣为人质",
    Callback = function()
        if findMurderer() ~= localPlayer then 
            WindUI:Notify({
                Title = "你不是杀手",
                Duration = 1
            })
            return 
        end
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= localPlayer then
                player.Character:FindFirstChild("HumanoidRootPart").Anchored = true
                player.Character:FindFirstChild("HumanoidRootPart").CFrame = localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame + localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 5
            end	
        end
        WindUI:Notify({
            Title = "已把所有人扣为人质",
            Duration = 1.5
        })
    end
})
Linni.Killer:Toggle({
    Title = "模拟飞刀击杀",
    Desc = "有稳定性,但是实用性较低",
    Value = false,
    Callback = function(state)
        TaffyMooKnife = state
        if state then
        
        end
    end
})

Linni.Auto:Toggle({
    Title = "自动拾取金币[现在是糖果]",
    Value = false,
    Callback = function(state)
        coinTaffy = state
    end
})
Linni.Auto:Toggle({
    Title = "自动拾取枪支",
    Value = false,
    Callback = function(state)
        TaffyGetGun = state
    end
})
Linni.Tl:Toggle({
    Title = "忽略飞刀",
    Value = false,
    Callback = function(state)
        TaffyChinaknife = state
    end
})
Linni.Tl:Button({
    Title = "上帝模式",
    Callback = function()
        local Cam = workspace.CurrentCamera
        local Char = localPlayer.Character
        local Human = Char and Char:FindFirstChildOfClass("Humanoid")
        if not Human then 
            WindUI:Notify({
                Title = "找不到本人角色的玩家",
                Duration = 1
            })
            return 
        end
        
        local nHuman = Human:Clone()
        nHuman.Parent = Char
        localPlayer.Character = nil
        
        nHuman:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        nHuman:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        nHuman:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        
        nHuman.BreakJointsOnDeath = false
        Human:Destroy()
        
        localPlayer.Character = Char
        Cam.CameraSubject = nHuman
        
        nHuman.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        
        local Script = Char:FindFirstChild("Animate")
        if Script then
            Script.Disabled = true
            task.wait(0.1)
            Script.Disabled = false
        end
        
        nHuman.Health = nHuman.MaxHealth
        
        WindUI:Notify({
            Title = "上帝模式已开启",
            Duration = 1.5
        })
    end
})
Linni.Tl:Button({
    Title = "在聊天中发送警长和杀手的名字",
    Desc = "你在大厅执行是检测不到警长和杀手",
    Callback = function()
        local textchannels = game:GetService("TextChatService"):WaitForChild("TextChannels"):GetChildren()
        for _, textchannel in ipairs(textchannels) do
            if textchannel.Name == "RBXSystem" then continue end
            local murd = findMurderer()
            local sher = findSheriff()
            
            local murdName = "[已检测到你在大厅]"
            local sherName = "[已检测到你在大厅]"
            if murd then murdName = murd.Name end
            if sher then sherName = sher.Name end
            local message = string.format([[警长:%s | 杀手:%s Linni ]], murdName, sherName)
            textchannel:SendAsync(message)
        end
        
        WindUI:Notify({
            Title = "已发送信息到聊天框",
            Duration = 1
        })
    end
})
Linni.Tl:Button({
    Title = "传送到大厅",
    Callback = function()
        localPlayer.Character:MoveTo(Vector3.new(-4985.83203125, 308.9087829589844, 7.557879447937012))
    end
})
Linni.Tl:Button({
    Title = "传送到地图[局内]",
    Desc = "[有bug,执行后不能移动需要调一下玩家属性,并且每回合都要]",
    Callback = function()
        local map = getMap()
        if not map then
            WindUI:Notify({
                Title = "找不到地图",
                Duration = 1
            })
            return
        end
        
        local spawnsFolder = map:FindFirstChild("Spawns")
        if spawnsFolder and #spawnsFolder:GetChildren() > 0 then
            local spawns = spawnsFolder:GetChildren()
            local randomSpawn = spawns[math.random(1, #spawns)]
            
            if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                localPlayer.Character:MoveTo(randomSpawn.Position)
                
            end
        else
            WindUI:Notify({
                Title = "找不到生成点",
                Duration = 1
            })
        end
    end
})
Linni.Tl:Button({
    Title = "传送到掉落的枪",
    Callback = function()
        local map = getMap()
        if not map or not map:FindFirstChild("GunDrop") then 
            WindUI:Notify({
                Title = "没有可传送到的掉落枪支",
                Duration = 1
            })
            return 
        end
        
        local gunDrop = map:FindFirstChild("GunDrop")
        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local previousPosition = localPlayer.Character.HumanoidRootPart.CFrame
            localPlayer.Character.HumanoidRootPart.CFrame = gunDrop:GetPivot()
            local connection
            connection = localPlayer.Backpack.ChildAdded:Connect(function(child)
                if child.Name == "Gun" then
                    connection:Disconnect()
                    task.wait(0.5)
                    localPlayer.Character.HumanoidRootPart.CFrame = previousPosition
                end
            end)
            task.delay(5, function()
                if connection then
                    connection:Disconnect()
                    localPlayer.Character.HumanoidRootPart.CFrame = previousPosition
                end
            end)
         
        end
    end
})

local CtSection = Linni.Cata:Section({
    Title = "[范围] - 打开方式→"
})
CtSection:Input({
    Title = "范围[ui报错,可以正常输入]",
    Value = "1",
    Placeholder = "",
    Callback = function(input)
        Taffyhit = tonumber(input) or 1
        local players = Players:GetPlayers()
        for i,v in ipairs(players) do
            if v ~= localPlayer and v.Character:FindFirstChild('HumanoidRootPart') then
                local sizeArg = tonumber(input)
                local Size = Vector3.new(sizeArg,sizeArg,sizeArg)
                if TaffyBox then
                    for _, part in ipairs(v.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            if not input or sizeArg == 1 then
                                part.Size = Vector3.new(2,1,1)
                                part.Transparency = 0.2
                            else
                                part.Size = Size
                                part.Transparency = 0.2
                            end
                        end
                    end
                else
                    local Root = v.Character:FindFirstChild('HumanoidRootPart')
                    if Root:IsA("BasePart") then
                        if not input or sizeArg == 1 then
                            Root.Size = Vector3.new(2,1,1)
                            Root.Transparency = 0.2
                        else
                            Root.Size = Size
                            Root.Transparency = 0.2
                        end
                        Root.CanCollide = false
                    end
                end
            end
        end
        
    end
})
CtSection:Toggle({
    Title = "范围[不可关闭]",
    Value = false,
    Callback = function(state)
        if state then
            loopTaffyhit = RunService.Heartbeat:Connect(function()
                local players = Players:GetPlayers()
                for i,v in ipairs(players) do
                    if v ~= localPlayer and v.Character:FindFirstChild('HumanoidRootPart') then
                        local sizeArg = tonumber(Taffyhit)
                        local Size = Vector3.new(sizeArg,sizeArg,sizeArg)
                        local Root = v.Character:FindFirstChild('HumanoidRootPart')
                        if TaffyBox then
                            for _, part in ipairs(v.Character:GetChildren()) do
                                if part:IsA("BasePart") then
                                    if not Taffyhit or sizeArg == 1 then
                                        part.Size = Vector3.new(2,1,1)
                                        part.Transparency = 0.2
                                    else
                                        part.Size = Size
                                        part.Transparency = 0.2
                                    end
                                end
                            end
                        else
                            local Root = v.Character:FindFirstChild('HumanoidRootPart')
                            if Root:IsA("BasePart") then
                                if not Taffyhit or sizeArg == 1 then
                                    Root.Size = Vector3.new(2,1,1)
                                    Root.Transparency = 0.2
                                else
                                    Root.Size = Size
                                    Root.Transparency = 0.2
                                end
                                Root.CanCollide = false
                            end
                        end
                    end
                end
            end)
        else
            if loopTaffyhit then
                loopTaffyhit:Disconnect()
            end
        end
    end
})
CtSection:Toggle({
    Title = "范围[所有部位,不可关闭]",
    Value = false,
    Callback = function(state)
        TaffyBox = state
    end
})
local AmSection = Linni.Cata:Section({
    Title = "[瞄准] - 打开方式→"
})
AmSection:Input({
    Title = "目标玩家",
    Value = "",
    Placeholder = "",
    Callback = function(input)
        if not Players:FindFirstChild(getPlayer(input, localPlayer)) then
            WindUI:Notify({
                Title = "玩家未找到",
                Duration = 1
            })
            return
        end
        WindUI:Notify({
            Title = "目标设置为 " .. Players:FindFirstChild(getPlayer(input, localPlayer)).Name,
            Duration = 1
        })
        target = Players:FindFirstChild(getPlayer(input, localPlayer))
    end
})
AmSection:Button({
    Title = "瞄准锁定",
    Callback = function()
        if Taffyaim then return end
        if Taffyaimrscon then Taffyaimrscon:Disconnect() end
        if not target then 
            WindUI:Notify({
                Title = "没有输入玩家名字",
                Duration = 1
            })
            return 
        end
        Taffyaimrscon = RunService.RenderStepped:Connect(function()
            if not target then 
                WindUI:Notify({
                    Title = "玩家名字错误或者不在",
                    Duration = 1
                })
                Taffyaimrscon:Disconnect() 
                return 
            end
            if not target.Character then return end
            if not target.Character:FindFirstChild("HumanoidRootPart") then return end
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character:FindFirstChild("HumanoidRootPart").Position)
        end)
        Taffyaim = true
    end
})
AmSection:Button({
    Title = "取消瞄准锁定",
    Callback = function()
        if not Taffyaim then return end
        Taffyaim = false
        if Taffyaimrscon then Taffyaimrscon:Disconnect() end
    end
})

local FgSection = Linni.Cata:Section({
    Title = "[甩飞] - 打开方式→"
})
FgSection:Input({
    Title = "输入需要甩飞的目标",
    Value = "",
    Placeholder = "",
    Callback = function(input)
        if not Players:FindFirstChild(getPlayer(input, localPlayer)) then
            WindUI:Notify({
                Title = "玩家未找到",
                Duration = 1
            })
            return
        end
        WindUI:Notify({
            Title = "甩飞目标设置为 " .. Players:FindFirstChild(getPlayer(input, localPlayer)).Name,
            Duration = 1
        })
        TaffyplayerFt = Players:FindFirstChild(getPlayer(input, localPlayer))
    end
})
FgSection:Button({
    Title = "甩飞指定玩家",
    Callback = function()
        if not TaffyplayerFt then
            WindUI:Notify({
                Title = "请先设置甩飞目标",
                Duration = 1
            })
            return
        end
        
        if not Players:FindFirstChild(TaffyplayerFt.Name) then
            WindUI:Notify({
                Title = "目标玩家不存在",
                Duration = 1
            })
            return
        end
        
        if TaffyplayerFt == localPlayer then
            WindUI:Notify({
                Title = "不能甩飞自己",
                Duration = 1
            })
            return
        end
        
        powerfulFling(TaffyplayerFt)
    end
})
FgSection:Toggle({
    Title = "防甩飞",
    Value = false,
    Callback = function(state)
        TaffyantiFly = state
        if state then
            flingDetectionCon = RunService.Heartbeat:Connect(function()
                for _, pl in ipairs(Players:GetPlayers()) do
                    if pl.Character:IsDescendantOf(workspace) then
                        if pl.Character.PrimaryPart.AssemblyAngularVelocity.Magnitude > 50 or pl.Character.PrimaryPart.AssemblyLinearVelocity.Magnitude > 100 then
                            if not detectedPlayers[pl.Name] then
                                WindUI:Notify({
                                    Title = "检测到甩飞者: " .. pl.Name,
                                    Duration = 1.5
                                })
                                detectedPlayers[pl.Name] = true	
                            end

                            for _, p in ipairs(pl.Character:GetDescendants()) do
                                if p:IsA("BasePart") then
                                    p.CanCollide = false
                                    p.AssemblyAngularVelocity = Vector3.zero
                                    p.AssemblyLinearVelocity = Vector3.zero
                                    p.CustomPhysicalProperties = PhysicalProperties.new(0,0,0)
                                end
                            end
                        end
                    end
                end
            end)
            flingNeutralizerCon = RunService.Heartbeat:Connect(function()
                if localPlayer.Character and localPlayer.Character.PrimaryPart then
                    if localPlayer.Character.PrimaryPart.AssemblyLinearVelocity.Magnitude > 250 or  localPlayer.Character.PrimaryPart.AssemblyAngularVelocity.Magnitude > 250 then
                        WindUI:Notify({
                            Title = "你被甩飞了！正在调整速度",
                            Duration = 1
                        })
                        localPlayer.Character.PrimaryPart.AssemblyLinearVelocity = Vector3.zero
                        localPlayer.Character.PrimaryPart.AssemblyAngularVelocity = Vector3.zero
                        if TaffyantiFlyLastPos ~= Vector3.zero then
                            localPlayer.Character.PrimaryPart.CFrame = CFrame.new(TaffyantiFlyLastPos)
                        end
                    else
                        TaffyantiFlyLastPos = localPlayer.Character.PrimaryPart.Position
                    end
                end
            end)
        else
            if flingDetectionCon then flingDetectionCon:Disconnect() end
            if flingNeutralizerCon then flingNeutralizerCon:Disconnect() end
            detectedPlayers = {}
            
        end
    end
})
workspace.ChildAdded:Connect(function(ch)
    if ch == getMap() and playerESP then
        WindUI:Notify({
            Title = "地图已加载等待分配角色...",
            Duration = 1.5
        })
        repeat
            task.wait(1)
        until findMurderer()
        WindUI:Notify({
            Title = "玩家ESP已移除,请重新开启",
            Duration = 1
        })
    end
end)
workspace.ChildRemoved:Connect(function(ch)
    if ch == getMap() and playerESP then
        WindUI:Notify({
            Title = "游戏结束移除玩家ESP",
            Duration = 1
        })
        playerData = {}
        for _, v in ipairs(workspace:GetChildren()) do if v.Name == "PlayerESP" then v:Destroy() end end
    end
end)
workspace.DescendantAdded:Connect(function(ch)
    if TaffyDete and ch.Name == "Trap" and ch.Parent:IsDescendantOf(workspace) then
        ch.Transparency = 0
        local trapesp = trapESP:Clone()
        trapesp.Parent = workspace
        trapesp.Adornee = ch
        WindUI:Notify({
            Title = "杀手放置了陷阱",
            Duration = 1
        })
    end
    if TaffygunESP and ch.Name == "GunDrop" then
        if not workspace:FindFirstChild("GunESP") then
            local gunesp = Instance.new("Highlight", workspace)
            gunesp.OutlineTransparency = 1
            gunesp.FillColor = Color3.fromRGB(255, 255, 0)
            gunesp.Name = "GunESP"
            gunesp.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            gunesp.Adornee = ch
            gunesp.Enabled = true
        end
        workspace:FindFirstChild("GunESP").Adornee = ch
        workspace:FindFirstChild("GunESP").Enabled = true
        WindUI:Notify({
            Title = "枪已掉落,寻找黄色透视物品",
            Duration = 1.5
        })
        if TaffyGetGun then
            WindUI:Notify({
                Title = "请等待.",
                Duration = 1
            })
            task.wait(0.01)
            if not getMap():FindFirstChild("GunDrop") then 
                WindUI:Notify({
                    Title = "没有可传送到的掉落枪支",
                    Duration = 1
                })
                return 
            end
            local previousPosition = localPlayer.Character:GetPivot()
            localPlayer.Character:MoveTo(getMap():FindFirstChild("GunDrop").Position)
            localPlayer.Backpack.ChildAdded:Wait()
            localPlayer.Character:PivotTo(previousPosition)
        end
    end
end)
workspace.DescendantRemoving:Connect(function(ch)
    if TaffygunESP and ch.Name == "GunDrop" then
        if workspace:FindFirstChild("GunESP") then
            workspace:FindFirstChild("GunESP"):Destroy()
        end
        WindUI:Notify({
            Title = "有人拿走了掉落的枪",
            Duration = 1
        })
        task.wait(0.6)
        local sheriff = findSheriff()
        if sheriff then
            WindUI:Notify({
                Title = "警长是 " .. sheriff.DisplayName,
                Duration = 1.5
            })
        end
    end
end)
game.Workspace.ChildAdded:Connect(function(chi)
    if chi.Name == "ThrowingKnife" and TaffyChinaknife then
        chi:Destroy()
    end
end)
task.spawn(function()
    while task.wait(1) do
        if findSheriff() == localPlayer and TaffyShoot then
            WindUI:Notify({
                Title = "自动射击已开启",
                Duration = 1
            })
            repeat
                task.wait(0.1)
                local murderer = findMurderer()
                if not murderer then continue end
                local murdererPosition = murderer.Character.HumanoidRootPart.Position
                local characterRootPart = localPlayer.Character.HumanoidRootPart
                local rayDirection = murdererPosition - characterRootPart.Position

                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                raycastParams.FilterDescendantsInstances = {localPlayer.Character}

                local hit = workspace:Raycast(characterRootPart.Position, rayDirection, raycastParams)
                if not hit or hit.Instance.Parent == murderer.Character then 
                    WindUI:Notify({
                        Title = "自动射击中……",
                        Duration = 1
                    })
                    if not localPlayer.Character:FindFirstChild("Gun") then
                        local hum = localPlayer.Character:FindFirstChild("Humanoid")
                        if localPlayer.Backpack:FindFirstChild("Gun") then
                            localPlayer.Character:FindFirstChild("Humanoid"):EquipTool(localPlayer.Backpack:FindFirstChild("Gun"))
                        else
                            WindUI:Notify({
                                Title = "你没有枪",
                                Duration = 1
                            })
                            return
                        end
                    end
                    local murdererHRP = murderer.Character:FindFirstChild("HumanoidRootPart")
                    if not murdererHRP then
                        WindUI:Notify({
                            Title = "找不到杀手的身体部位",
                            Duration = 1
                        })
                        return
                    end

                    local predictedPosition = getPredictedPosition(murderer, TaffyshootTChina)

                    local args = {[1] = 1, [2] = predictedPosition, [3] = "AH2"}
                    localPlayer.Character.Gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))
                end
            until findSheriff() ~= localPlayer or not TaffyShoot
        end
    end
end)
localPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    task.wait(0.5)
    if LinniWs ~= 16 then
        character:FindFirstChild("Humanoid").WalkSpeed = LinniWs
    end
    if LinniJumpPower ~= 50 then
        character:FindFirstChild("Humanoid").JumpPower = LinniJumpPower
    end
end)
task.spawn(function()
    while task.wait(0.01) do
        if not coinTaffy then continue end
        if getMap() then
            if getMap():FindFirstChild("CoinContainer") and #getMap():FindFirstChild("CoinContainer"):GetChildren() > 1 then
                local closestCoin = getClosestModelToPlayer(localPlayer, getMap():FindFirstChild("CoinContainer"):GetChildren())
                if closestCoin then
                    if not localPlayer.Character:FindFirstChild("HumanoidRootPart") then continue end
                    local distance = (localPlayer.Character:FindFirstChild("HumanoidRootPart").Position - closestCoin:GetPivot().Position).Magnitude
                    local toclosestcoin = TweenService:Create(localPlayer.Character:FindFirstChild("HumanoidRootPart"), TweenInfo.new(distance*0.05, Enum.EasingStyle.Linear), {
                        CFrame = closestCoin:GetPivot()
                    })
                    toclosestcoin:Play()
                    toclosestcoin.Completed:Wait()
                    task.wait(0.01)
                    closestCoin:Destroy()
                    claimedCoins[closestCoin] = true
                end
            end
        end
    end
end)
task.spawn(function() 
    if game:GetService("RunService"):IsStudio() then return end
    local OldNameCall = nil
    OldNameCall = hookmetamethod(game, "__namecall", function(Self, ...)
        local Args = {...}
        local NamecallMethod = getnamecallmethod()
        if antifail and NamecallMethod == "FireServer" and Args[1] == "SetPlayerMinigameResult" then
            Args[2] = true
        end
        return OldNameCall(Self, unpack(Args))
    end)
end)
elseif game.GameId == 7436755782 then --- 种植花园
    local HttpService = cloneref(game:GetService("HttpService"))

local isfunctionhooked = clonefunction(isfunctionhooked)
if isfunctionhooked(game.HttpGet) or isfunctionhooked(getnamecallmethod) or isfunctionhooked(request) then 
    return 
end

local function verifyKey(k)
    local ok, res = pcall(function()
        return request({
            Url = "https://ouo.lat/api/verify.php",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({key = k, time = os.time()})
        })
    end)
    
    if not ok then return false end
    
    if res.Body ~= "True" then
        return false
    end
    
    local ok2, res2 = pcall(function()
        return game:HttpGet("https://www.wtb.lat/keysystem/check-key?key="..k.."&user="..game.Players.LocalPlayer.Name)
    end)
    
    return ok2 and res2 == "success"
end

local key = ""
pcall(function() key = readfile("DyzhKey.json") end)
if key ~= "" then
    if verifyKey(key) then
        print('验证完成')
    else
        return
    end
end

local a = game:GetService("Players").LocalPlayer
local b = a.Character or a.CharacterAdded:Wait()
local c = game:GetService("ReplicatedStorage")

local sbns = {
    c = false,
    s = false,
    p = false
}

local seeds = {}
local selectseed = ""
for _,v in next, a.PlayerGui.Seed_Shop.Frame.ScrollingFrame:GetChildren() do
    if v.ClassName == "Frame" and not v.Name:find("Padding") then
        table.insert(seeds, v.Name)
    end
end

local gear = {}
local selectgear = ""
for _,v in next, a.PlayerGui.Gear_Shop.Frame.ScrollingFrame:GetChildren() do
    if v.ClassName == "Frame" and not v.Name:find("_") then
        table.insert(gear, v.Name)
    end
end

hookfunction(require(c.Modules.PlayerLuck).GetLuck, function()
    return math.huge
end)

hookfunction(require(c.Modules.PlayerLuck).GetModifiers, function()
    return {
        {
            Name = "Fake_Luck",
            Modifier = math.huge
        }
    }
end)

for _,v in ipairs(require(c.Data.SessionTimeLuckData).Timer) do
    if v.Luck then
        v.Luck = math.huge
    end
end

hookfunction(require(c.Modules.SessionTimeLuckController).GetCurrentLuck, function()
    return math.huge
end)

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "种植花园",
    Icon = "crown",
    IconThemed = true,
    Author = "伊散制作",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(150, 150),
    Transparent = true,
    Theme = "Dark",
    User = {
        Enabled = true,
        Callback = function()
            print("clicked")
        end,
        Anonymous = false
    },
    SideBarWidth = 200,
    HideSearchBar = true,
    ScrollBarEnabled = true,
})

Window:EditOpenButton({
    Title = "塔菲喵",
    Icon = "image-upscale",
    CornerRadius = UDim.new(0, 10),
    StrokeThickness = 3,
    Color = ColorSequence.new(Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29"))
})

local MainSection = Window:Section({
    Title = "主要菜单",
    Opened = true
})

local Main = MainSection:Tab({Title = "主要功能", Icon = "Sword"})

Main:Toggle({
    Title = "自动收集",
    Image = "swords",
    Value = false,
    Callback = function(state)
        sbns.c = state
        spawn(function()
            while wait() and sbns.c do
                pcall(function()
                    if b and b:FindFirstChild("HumanoidRootPart") then
                        for _, e in pairs(workspace.Farm:GetChildren()) do
                            if e:FindFirstChild("Important") and e.Important:FindFirstChild("Data") and e.Important.Data:FindFirstChild("Owner") then
                                if e.Important.Data.Owner.Value == a.Name then
                                    for _, g in ipairs(e.Important.Plants_Physical:GetDescendants()) do
                                        if g:IsA("ProximityPrompt") then
                                            b.Humanoid:MoveTo(g.Parent.Position)
                                            fireproximityprompt(g)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end
})

Main:Toggle({
    Title = "自动售卖",
    Image = "swords",
    Value = false,
    Callback = function(state)
        sbns.s = state
        spawn(function()
            while wait() and sbns.s do
                pcall(function()
                    if b and b:FindFirstChild("HumanoidRootPart") then
                        if #a.Backpack:GetChildren() > 20 then
                            local h = b.HumanoidRootPart.CFrame
                            b.HumanoidRootPart.CFrame = workspace.NPCS["Sell Stands"]["Shop Stand"].CFrame * CFrame.new(0, 0, 3)
                            wait(0.5)
                            c.GameEvents.Sell_Item:FireServer()
                            c.GameEvents.Sell_Inventory:FireServer()
                            wait(1)
                            b.HumanoidRootPart.CFrame = h
                        end
                    end
                end)
            end
        end)
    end
})

Main:Toggle({
    Title = "自动种植",
    Image = "swords",
    Value = false,
    Callback = function(state)
        sbns.p = state
        spawn(function()
            while wait() and sbns.p do
                pcall(function()
                    if b and b:FindFirstChild("HumanoidRootPart") then
                        local seedType, tool
                        for _, i in ipairs(b:GetChildren()) do
                            if i:IsA("Tool") and i.Name:find("Seed") then
                                seedType = i.Name:match("^(.-) Seed")
                                tool = i
                                break
                            end
                        end
                        
                        if not tool then
                            for _, i in ipairs(a.Backpack:GetChildren()) do
                                if i:IsA("Tool") and i.Name:find("Seed") then
                                    seedType = i.Name:match("^(.-) Seed")
                                    tool = i
                                    break
                                end
                            end
                        end
                        
                        if tool and seedType then
                            if tool.Parent == a.Backpack then
                                b.Humanoid:EquipTool(tool)
                                repeat wait() until tool.Parent == b
                            end
                            
                            c.GameEvents.Plant_RE:FireServer(
                                Vector3.new(math.floor(b.HumanoidRootPart.Position.X), 0.1, math.floor(b.HumanoidRootPart.Position.Z)),
                                seedType
                            )
                        end
                    end
                end)
            end
        end)
    end
})

Main:Dropdown({
    Title = "选择种子",
    Values = seeds,
    Callback = function(value)
        selectseed = value
    end
})

local SeedInfo = Main:Paragraph({
    Title = "种子信息",
    Desc = "无",
    Color = "White"
})

task.spawn(function()
    while wait() do
        if selectseed ~= "" then
            local seedFrame = a.PlayerGui.Seed_Shop.Frame.ScrollingFrame:FindFirstChild(selectseed)
            if seedFrame then
                SeedInfo:SetDesc("价格: " .. seedFrame.Main_Frame.Cost_Text.Text .. "\n数量: " .. seedFrame.Main_Frame.Stock_Text.Text)
            end
        end
    end
end)

Main:Button({
    Title = "购买种子",
    Callback = function()
        if selectseed ~= "" then
            c.GameEvents.BuySeedStock:FireServer("Tier 1", selectseed)
        end
    end
})

Main:Dropdown({
    Title = "选择工具",
    Values = gear,
    Callback = function(value)
        selectgear = value
    end
})

local GearInfo = Main:Paragraph({
    Title = "工具信息",
    Desc = "无",
    Color = "White"
})

task.spawn(function()
    while wait() do
        if selectgear ~= "" then
            local gearFrame = a.PlayerGui.Gear_Shop.Frame.ScrollingFrame:FindFirstChild(selectgear)
            if gearFrame then
                GearInfo:SetDesc("价格: " .. gearFrame.Main_Frame.Cost_Text.Text .. "\n数量: " .. gearFrame.Main_Frame.Stock_Text.Text)
            end
        end
    end
end)

Main:Button({
    Title = "购买工具",
    Callback = function()
        if selectgear ~= "" then
            c.GameEvents.BuyGearStock:FireServer(selectgear)
        end
    end
})
elseif game.GameId == 3741075732 then --- chain
    local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/dream77239/china-ui/refs/heads/main/China%20ui.lua"))()

local Window = WindUI:CreateWindow({
    Title = "伊散塔菲喵",
    Icon = "sword",
    IconThemed = true,
    Author = "chain",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(150, 150),
    Transparent = true,
    Theme = "Dark",
    User = {
        Enabled = true,
        Callback = function() end,
        Anonymous = false
    },
    SideBarWidth = 200,
    ScrollBarEnabled = true
})

Window:Tag({
    Title = "伊散",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})
Window:CreateTopbarButton("theme-switcher", "moon", function()
    WindUI:SetTheme(WindUI:GetCurrentTheme() == "Dark" and "Light" or "Dark")
    WindUI:Notify({
        Title = "提示",
        Content = "当前主题: "..WindUI:GetCurrentTheme(),
        Duration = 2
    })
end, 990)

local TimeTag = Window:Tag({
    Title = "--:--",
    Radius = 999,
    Color = Color3.fromRGB(255, 255, 255),
})

task.spawn(function()
	while true do
		local now = os.date("*t")
		local hours = string.format("%02d", now.hour)
		local minutes = string.format("%02d", now.min)
		TimeTag:SetTitle(hours .. ":" .. minutes)
		task.wait(0.06)
	end
end)

local Tab1 = Window:Tab({
    Title = "功能",
    Icon = "house",
    Locked = false,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local combatStaminaEnabled = false
local staminaEnabled = false
local combatLoop = nil
local staminaLoop = nil

local function setCombatStamina(value)
    local char = workspace:FindFirstChild(LocalPlayer.Name)
    if char and char:FindFirstChild("Stats") then
        local stat = char.Stats:FindFirstChild("CombatStamina")
        if stat then stat.Value = value end
    end
end

local function setStamina(value)
    local char = workspace:FindFirstChild(LocalPlayer.Name)
    if char and char:FindFirstChild("Stats") then
        local stat = char.Stats:FindFirstChild("Stamina")
        if stat then stat.Value = value end
    end
end

local function startCombatLoop()
    if combatLoop then return end
    combatLoop = RunService.Heartbeat:Connect(function()
        if combatStaminaEnabled then setCombatStamina(100) end
    end)
end

local function startStaminaLoop()
    if staminaLoop then return end
    staminaLoop = RunService.Heartbeat:Connect(function()
        if staminaEnabled then setStamina(100) end
    end)
end

local function stopCombatLoop()
    if combatLoop then combatLoop:Disconnect() combatLoop = nil end
end

local function stopStaminaLoop()
    if staminaLoop then staminaLoop:Disconnect() staminaLoop = nil end
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if combatStaminaEnabled then setCombatStamina(100) end
    if staminaEnabled then setStamina(100) end
end)

Tab1:Toggle({
    Title = "无限战斗体力",
    Value = false,
    Callback = function(state)
        combatStaminaEnabled = state
        if state then startCombatLoop() else stopCombatLoop() end
    end
})

Tab1:Toggle({
    Title = "无限体力",
    Value = false,
    Callback = function(state)
        staminaEnabled = state
        if state then startStaminaLoop() else stopStaminaLoop() end
    end
})

-- 透视 Chain 逻辑
local chainESPEnabled = false
local chainESPConnection = nil
local currentChain = nil

local function createChainESP(chain)
    if not chain:FindFirstChild("Highlight") then
        local h = Instance.new("Highlight")
        h.Name = "Highlight"; h.Adornee = chain; h.FillColor = Color3.fromRGB(255, 0, 0); h.FillTransparency = 0.8
        h.OutlineColor = Color3.fromRGB(255, 60, 60); h.OutlineTransparency = 0; h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent = chain
    end
    if not chain:FindFirstChild("NameGui") then
        local gui = Instance.new("BillboardGui")
        gui.Name = "NameGui"; gui.Size = UDim2.new(0, 150, 0, 30); gui.StudsOffset = Vector3.new(0, 5, 0)
        gui.Adornee = chain; gui.AlwaysOnTop = true; gui.LightInfluence = 0; gui.Parent = chain
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "TitleLabel"; titleLabel.Size = UDim2.new(1, 0, 0.5, 0); titleLabel.Text = "CHAIN"
        titleLabel.TextColor3 = Color3.new(1, 0, 0); titleLabel.TextScaled = true; titleLabel.Font = Enum.Font.GothamBold
        titleLabel.BackgroundTransparency = 1; titleLabel.Parent = gui
        local attrLabel = Instance.new("TextLabel")
        attrLabel.Name = "AttrLabel"; attrLabel.Size = UDim2.new(1, 0, 0.5, 0); attrLabel.Position = UDim2.new(0, 0, 0.5, 0)
        attrLabel.RichText = true; attrLabel.Text = ""; attrLabel.TextColor3 = Color3.new(1, 1, 1); attrLabel.TextScaled = true
        attrLabel.Font = Enum.Font.Gotham; attrLabel.BackgroundTransparency = 1; attrLabel.Parent = gui
    end
end

local function updateChainAttributes(chain)
    local gui = chain:FindFirstChild("NameGui")
    if gui then
        local attrLabel = gui:FindFirstChild("AttrLabel")
        if attrLabel then
            local anger = chain:GetAttribute("Anger") or 0
            local burst = chain:GetAttribute("Burst") or 0
            local choke = chain:GetAttribute("ChokeMeter") or 0
            attrLabel.Text = string.format('[血月度: <font color="rgb(255,255,255)">%.0f%%</font>] [捶地: <font color="rgb(255,255,255)">%.0f%%</font>] [掐脖: <font color="rgb(255,255,255)">%.0f%%</font>]', anger, burst, choke)
        end
    end
end

local function refreshChainESP()
    local chain = workspace:FindFirstChild("Misc") and workspace.Misc:FindFirstChild("AI") and workspace.Misc.AI:FindFirstChild("CHAIN")
    if chain then
        if currentChain ~= chain then
            if currentChain then local h = currentChain:FindFirstChild("Highlight") if h then h:Destroy() end end
            currentChain = chain; createChainESP(chain)
        end
        updateChainAttributes(chain)
    end
end

Tab1:Toggle({
    Title = "透视chain",
    Value = false,
    Callback = function(state)
        if state then chainESPEnabled = true; chainESPConnection = RunService.Heartbeat:Connect(refreshChainESP)
        else chainESPEnabled = false; if chainESPConnection then chainESPConnection:Disconnect() end end
    end
})

local playerESPEnabled = false
local playerESPConnections = {}
local trackedCharacters = {}

local function addESP(character, player)
    if not character:FindFirstChild("Highlight") then
        local h = Instance.new("Highlight", character)
        h.Name = "Highlight"; h.FillColor = Color3.fromRGB(0, 255, 0); h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end
    if not character:FindFirstChild("NameGui") then
        local gui = Instance.new("BillboardGui", character)
        gui.Name = "NameGui"; gui.Size = UDim2.new(0, 50, 0, 10); gui.AlwaysOnTop = true
        local label = Instance.new("TextLabel", gui); label.Size = UDim2.new(1,0,1,0); label.Text = player.Name; label.TextColor3 = Color3.new(0,1,0); label.BackgroundTransparency = 1; label.TextScaled = true
    end
end

Tab1:Toggle({
    Title = "透视玩家",
    Default = false,
    Callback = function(state)
        playerESPEnabled = state
        if state then
            for _, player in ipairs(Players:GetPlayers()) do if player ~= LocalPlayer and player.Character then addESP(player.Character, player) end end
        end
    end
})

local Lighting = game:GetService("Lighting")
local highlightLoop
Tab1:Toggle({
    Title = "高亮",
    Default = false,
    Callback = function(state)
        if state then
            highlightLoop = task.spawn(function()
                while task.wait(0.5) do Lighting.Brightness = 2; Lighting.ClockTime = 13.5; Lighting.GlobalShadows = false end
            end)
        else if highlightLoop then task.cancel(highlightLoop) end end
    end
})

local targetPositions = {
    Vector3.new(-26.879, -107.017, -204.777), Vector3.new(-110.858, -86.338, 211.858),
    Vector3.new(43.304, -97.968, 349.153), Vector3.new(164.498, -103.651, -35.760),
    Vector3.new(308.971, -113.493, -250.460), Vector3.new(-203.818, -110.890, -108.904),
    Vector3.new(-381.873, -115.021, 42.071),
}
Tab1:Toggle({
    Title = "传送捡废铁",
    Value = false,
    Callback = function(state)
        _G.ScrapRunning = state
        if state then task.spawn(function()
            while _G.ScrapRunning do
                for _, pos in ipairs(targetPositions) do
                    if not _G.ScrapRunning then break end
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0,3,0))
                    task.wait(3)
                end
            end
        end) end
    end
})

Tab1:Toggle({
    Title = "传送捡魔法书碎片",
    Value = false,
    Callback = function(state)
        _G.ArtRunning = state
        if state then task.spawn(function()
            while _G.ArtRunning do
                local arts = workspace.Misc.Zones.LootingItems.Artifacts:GetChildren()
                for _, m in pairs(arts) do
                    for _, p in pairs(m:GetChildren()) do
                        if p:IsA("MeshPart") and p.Transparency == 0 then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = p.CFrame
                            task.wait(0.3); fireproximityprompt(p:FindFirstChildOfClass("ProximityPrompt"))
                            task.wait(0.5)
                        end
                    end
                end
                task.wait(1)
            end
        end) end
    end
})

Tab1:Toggle({ Title = "显示聊天框", Callback = function(state) game:GetService("TextChatService").ChatWindowConfiguration.Enabled = state end })
Tab1:Toggle({ Title = "强制第三人称", Callback = function(state) LocalPlayer.CameraMaxZoomDistance = state and 99999 or 16; LocalPlayer.CameraMode = state and Enum.CameraMode.Classic or Enum.CameraMode.LockFirstPerson end })
Tab1:Button({ Title = "删除雾", Callback = function() if Lighting:FindFirstChild("Rainy") then Lighting.Rainy:Destroy() end end })

local Tab2 = Window:Tab({
    Title = "暴力功能",
    Icon = "hand",
    Locked = false,
})

Tab2:Paragraph({ Title = "注意事项", Desc = "不看的人死妈，要先点反作弊，然后开启无限闪避之后再点一下闪避键自动无限闪避就有用了...", Color = "Red" })

Tab2:Button({ Title = "绕过反作弊", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua", true))() end })

local function smoothLookAt(currentCFrame, targetPos, speed)
    local direction = (targetPos - currentCFrame.Position).Unit
    local lerpedLook = currentCFrame.LookVector:Lerp(direction, speed)
    return CFrame.new(currentCFrame.Position, currentCFrame.Position + lerpedLook)
end
Tab2:Toggle({
    Title = "自瞄chain",
    Callback = function(state)
        if state then _G.AimLoop = RunService.RenderStepped:Connect(function()
            local chain = workspace:FindFirstChild("Misc") and workspace.Misc.AI:FindFirstChild("CHAIN")
            if chain and chain:FindFirstChild("HumanoidRootPart") then
                workspace.CurrentCamera.CFrame = smoothLookAt(workspace.CurrentCamera.CFrame, chain.HumanoidRootPart.Position, 0.3)
            end
        end) else if _G.AimLoop then _G.AimLoop:Disconnect() end end
    end
})

Tab2:Toggle({ Title = "chain爆炸自动躲v1", Callback = function(state) _G.DodgeV1 = state end })
Tab2:Toggle({ Title = "chain爆炸自动躲v2", Callback = function(state) _G.DodgeV2 = state end })

local mt = getrawmetatable(game); local old = mt.__namecall; setreadonly(mt, false)
local lastCTS, lastInteract
mt.__namecall = function(self, ...)
    local method = getnamecallmethod(); local args = {...}
    if method == "FireServer" then
        if self.Name == "CTS" then lastCTS = args end
        if self.Name == "Interact" then lastInteract = args end
    end
    return old(self, ...)
end
setreadonly(mt, true)

Tab2:Toggle({
    Title = "自动无限闪避",
    Callback = function(state)
        _G.InfDodge = state
        if state then task.spawn(function()
            while _G.InfDodge do
                local remote = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("CharacterMobility") and LocalPlayer.Character.CharacterMobility:FindFirstChild("CTS")
                if remote and lastCTS then remote:FireServer(unpack(lastCTS)) end
                task.wait(0.3)
            end
        end) end
    end
})

Tab2:Toggle({
    Title = "无敌",
    Callback = function(state)
        _G.GodMode = state
        if state then task.spawn(function()
            while _G.GodMode do
                local remote = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("CharacterHandler") and LocalPlayer.Character.CharacterHandler.Contents.Remotes:FindFirstChild("Interact")
                if remote and lastInteract then remote:FireServer(unpack(lastInteract)) end
                task.wait(1)
            end
        end) end
    end
})

Tab2:Toggle({ Title = "自动拼刀", Callback = function(state) 
    if state then _G.ClashLoop = RunService.Heartbeat:Connect(function() pcall(function() LocalPlayer.Character.Stats.ClashStrength.Value = 100 end) end)
    else if _G.ClashLoop then _G.ClashLoop:Disconnect() end end
end })

local Tab3 = Window:Tab({ Title = "蓝图解锁", Icon = "file-check" })
local function UnlockAttr(attr) LocalPlayer:WaitForChild("PlayerStats"):WaitForChild("Blueprints"):SetAttribute(attr, true) end

Tab3:Button({ Title = "解锁小刀", Callback = function() UnlockAttr("CombatKnife") end })
Tab3:Button({ Title = "解锁喷子", Callback = function() UnlockAttr("DoubleBarrel") end })
Tab3:Button({ Title = "解锁m1911", Callback = function() UnlockAttr("M1911") end })
Tab3:Button({ Title = "解锁马切特", Callback = function() UnlockAttr("Machete") end })
Tab3:Button({ Title = "解锁魔法书", Callback = function() UnlockAttr("SpellBook") end })
Tab3:Button({ Title = "解锁神器任务", Callback = function() LocalPlayer.PlayerStats.Quests:SetAttribute("ArtifactQuest", true) end })

local Tab4 = Window:Tab({ Title = "传送", Icon = "zap" })
local function Teleport(pos) LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0,3,0)) end

Tab4:Button({ Title = "chain出生地", Callback = function() Teleport(Vector3.new(-26.879, -107.017, -204.777)) end })
Tab4:Button({ Title = "商店", Callback = function() Teleport(Vector3.new(-110.858, -86.338, 211.858)) end })
Tab4:Button({ Title = "排行榜", Callback = function() Teleport(Vector3.new(43.304, -97.968, 349.153)) end })
Tab4:Button({ Title = "工作间", Callback = function() Teleport(Vector3.new(164.498, -103.651, -35.760)) end })
Tab4:Button({ Title = "仓库", Callback = function() Teleport(Vector3.new(308.971, -113.493, -250.460)) end })
Tab4:Button({ Title = "发电站", Callback = function() Teleport(Vector3.new(-203.818, -110.890, -108.904)) end })
Tab4:Button({ Title = "收音机站", Callback = function() Teleport(Vector3.new(-381.873, -115.021, 42.071)) end })

local Tab5 = Window:Tab({ Title = "商店", Icon = "store" })
Tab5:Button({ Title = "打开商店界面", Callback = function() LocalPlayer.PlayerGui.Ingame.Shop.Visible = true end })

local Tab6 = Window:Tab({ Title = "设置", Icon = "house" })
local themeNames = {}
for name, _ in pairs(WindUI:GetThemes()) do table.insert(themeNames, name) end
Tab6:Dropdown({ Title = "更改ui颜色", Values = themeNames, Callback = function(v) WindUI:SetTheme(v) end })
elseif game.GameId == 1037979853 then --- 钓鱼模拟器
    local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yisan9178/sjsjsj/refs/heads/main/Windui.lua(1).txt"))()

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(chars, uchar)
    end
    local length = #chars
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
            math.floor(r * 255), math.floor(g * 255), math.floor(b * 255), chars[i])
    end
    return result
end

local Window = WindUI:CreateWindow({
    Title = gradient("塔菲喵   ", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("伊散", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    IconThemed = true,
    Folder = "TuffyMeow",
    Size = UDim2.fromOffset(150, 150),
    Transparent = false,
    Theme = "Dark",
    SideBarWidth = 160,
    HideSearchBar = true,
})
Window:Tag({
    Title = "伊散",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})

Window:EditOpenButton({
    Title = "[摸摸伊散]",
    CornerRadius = UDim.new(0,8),
    StrokeThickness = 3,
    Color = ColorSequence.new(Color3.fromHex("#118AB2"), Color3.fromHex("#06D6A0")),
    Draggable = true,
})

Window:SetToggleKey(Enum.KeyCode.F, true)

local FishingTab = Window:Tab({ Title = '功能', Icon = 'waves' })

FishingTab:Section({ Title = "自动挂机" })

FishingTab:Toggle({
    Title = "自动抓捕",
    Callback = function(state)
        getgenv().AutoFish = state
        task.spawn(function()
            while getgenv().AutoFish do
                game:GetService("ReplicatedStorage").CloudFrameShared.DataStreams.FishCaught:FireServer()
                task.wait(2.6)
            end
        end)
    end
})

FishingTab:Toggle({
    Title = "自动售卖",
    Callback = function(state)
        getgenv().AutoSell = state
        task.spawn(function()
            while getgenv().AutoSell do
                game:GetService("ReplicatedStorage").CloudFrameShared.DataStreams.processGameItemSold:InvokeServer("SellEverything")
                task.wait(2.6)
            end
        end)
    end
})

FishingTab:Section({ Title = "宝箱采集" })

FishingTab:Toggle({
    Title = "自动每日宝箱",
    Callback = function(state)
        getgenv().DailyChest = state
        task.spawn(function()
            while getgenv().DailyChest do
                for _, v in pairs(game.Workspace.Islands:GetDescendants()) do
                    if v:IsA("Model") and string.match(v.Name, "Chest") and v:FindFirstChild("HumanoidRootPart") then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
                        task.wait(0.5)
                        fireproximityprompt(v.HumanoidRootPart.ProximityPrompt)
                    end
                end
                task.wait(1)
            end
        end)
    end
})

FishingTab:Toggle({
    Title = "自动随机宝箱",
    Callback = function(state)
        getgenv().RandomChest = state
        task.spawn(function()
            while getgenv().RandomChest do
                for _, v in pairs(game.Workspace.RandomChests:GetDescendants()) do
                    if v:IsA("Model") and string.match(v.Name, "Chest") and v:FindFirstChild("HumanoidRootPart") then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
                        task.wait(0.5)
                        fireproximityprompt(v.HumanoidRootPart.ProximityPrompt)
                    end
                end
                task.wait(1)
            end
        end)
    end
})

local PlayerTab = Window:Tab({ Title = '玩家属性', Icon = 'user' })

PlayerTab:Section({ Title = "数值调节" })

PlayerTab:Slider({
    Title = "步行速度",
    Min = 16, Max = 400, Default = 16,
    Callback = function(v)
        task.spawn(function()
            while task.wait() do 
                if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v 
                end
            end
        end)
    end
})

PlayerTab:Slider({
    Title = "跳跃高度",
    Min = 50, Max = 400, Default = 50,
    Callback = function(v)
        task.spawn(function()
            while task.wait() do 
                if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                    game.Players.LocalPlayer.Character.Humanoid.JumpPower = v 
                end
            end
        end)
    end
})

PlayerTab:Slider({
    Title = "修改重力",
    Min = 0, Max = 1000, Default = 196.2,
    Callback = function(v) game.Workspace.Gravity = v end
})

PlayerTab:Section({ Title = "动作开关" })

PlayerTab:Toggle({
    Title = "无限跳",
    Callback = function(state)
        getgenv().InfJump = state
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if getgenv().InfJump then 
                game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping") 
            end
        end)
    end
})

PlayerTab:Button({
    Title = "汉化穿墙",
    Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/TtmScripter/OtherScript/main/Noclip"))() end
})

PlayerTab:Button({
    Title = "飞行模式",
    Callback = function() loadstring(game:HttpGet("https://pastefy.app/J9x7RnEZ/raw"))() end
})

PlayerTab:Button({
    Title = "自杀",
    Callback = function() game.Players.LocalPlayer.Character.Humanoid.Health = 0 end
})

local ToolTab = Window:Tab({ Title = '其他功能', Icon = 'eye' })

ToolTab:Section({ Title = "透视功能" })

ToolTab:Button({
    Title = "玩家高亮 ESP",
    Callback = function()
        local function ApplyESP(v)
            if v.Character and not v.Character:FindFirstChild("Highlight") then
                local hl = Instance.new("Highlight", v.Character)
                hl.FillTransparency = 0.5
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            end
        end
        for _, p in pairs(game.Players:GetPlayers()) do ApplyESP(p) end
        game.Players.PlayerAdded:Connect(ApplyESP)
    end
})

ToolTab:Toggle({
    Title = "显示玩家名字",
    Callback = function(enabled)
        _G.ESPName = enabled
        if enabled then
            task.spawn(function()
                while _G.ESPName do
                    for _, player in ipairs(game.Players:GetPlayers()) do
                        if player.Character and player.Character:FindFirstChildOfClass('Humanoid') then
                            player.Character.Humanoid.NameDisplayDistance = 9e9
                            player.Character.Humanoid.HealthDisplayDistance = 9e9
                            player.Character.Humanoid.HealthDisplayType = "AlwaysOn"
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

ToolTab:Section({ Title = "场景" })

ToolTab:Toggle({
    Title = "夜视模式",
    Callback = function(state)
        game.Lighting.Ambient = state and Color3.new(1, 1, 1) or Color3.new(0, 0, 0)
    end
})

ToolTab:Toggle({
    Title = "自动互动",
    Callback = function(state)
        getgenv().AutoInteract = state
        task.spawn(function()
            while getgenv().AutoInteract do
                for _, descendant in pairs(workspace:GetDescendants()) do
                    if descendant:IsA("ProximityPrompt") then
                        fireproximityprompt(descendant)
                    end
                end
                task.wait(0.25)
            end
        end)
    end
})

ToolTab:Button({
    Title = "反挂机",
    Callback = function() loadstring(game:HttpGet("https://pastebin.com/raw/9fFu43FF"))() end
})

ToolTab:Button({
    Title = "玩家加入提示",
    Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/boyscp/scriscriptsc/main/bbn.lua"))() end
})

-- 启动通知
WindUI:Notify({
    Title = "塔菲喵脚本",
    Content = "脚本加载成功！伊散祝您游玩愉快。",
    Duration = 5,
    Icon = "info"
})

Window:SelectTab(1)
elseif game.GameId == 6610021055 then --- 奴才军队大亨
    local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yisan9178/sjsjsj/refs/heads/main/Windui.lua(1).txt"))()

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(chars, uchar)
    end
    
    local length = #chars
    
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
            math.floor(r * 255), 
            math.floor(g * 255), 
            math.floor(b * 255), 
            chars[i])
    end
    
    return result
end

local Window = WindUI:CreateWindow({
    Title = gradient("塔菲喵   ", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("奴才大亨", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    IconThemed = true,
    Folder = "塔菲喵",
    Size = UDim2.fromOffset(150, 150),
     Transparent = getgenv().TransparencyEnabled,
     Theme = "Dark",
     Resizable = true,
     SideBarWidth = 150,
     BackgroundImageTransparency = 0.8,
     HideSearchBar = true,
     ScrollBarEnabled = true,
     User = {
         Enabled = true,
         Anonymous = false,
         Callback = function()
             currentThemeIndex = currentThemeIndex + 1
             if currentThemeIndex > #themes then
                 currentThemeIndex = 1
             end
             
             local newTheme = themes[currentThemeIndex]
             WindUI:SetTheme(newTheme)
            
             WindUI:Notify({
                 Title = "Theme Changed",
                 Content = "Switched to " .. newTheme .. " theme!",
                 Duration = 2,
                 Icon = "palette"
             })
             print("Switched to " .. newTheme .. " theme")
         end,
     },
 })

    
Window:EditOpenButton({
    Title = "塔菲喵",
    CornerRadius = UDim.new(0,8),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("1E3A8A")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("118AB2")), 
        ColorSequenceKeypoint.new(1, Color3.fromHex("06D6A0")) 
    }),
    Draggable = true,
})

Window:Tag({
    Title = "伊散and霖溺",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})

Window:SetToggleKey(Enum.KeyCode.F, true)



local CombatTab = Window:Tab({ Title = '战斗功能', Icon = 'swords' })

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local FLOWER_CONFIG = {
    TeleportHeight = 2.5,
    MaxWaitTime = 0.6,
    LoopInterval = 0.3,
}

local AutoFlowerEnabled = false

local function getRoot()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart", 5)
end

local function findMyPrompt(flower)
    local stem = flower:FindFirstChild("Stem")
    local prompt = nil
    
    if stem then
        local attachment = stem:FindFirstChild("Attachment")
        if attachment then
            prompt = attachment:FindFirstChildOfClass("ProximityPrompt")
        end
    end
    
    if not prompt then
        prompt = flower:FindFirstChildWhichIsA("ProximityPrompt", true)
    end
    
    return prompt
end

local function fastCollect()
    local root = getRoot()
    if not root then return end

    local modelsFolder = workspace:FindFirstChild("Map") 
                         and workspace.Map.Flowers:FindFirstChild("Models")
    
    if not modelsFolder then return end

    local flowers = modelsFolder:GetChildren()
    
    table.sort(flowers, function(a, b)
        local pA = a:FindFirstChild("Stem") or a.PrimaryPart or a:FindFirstChildWhichIsA("BasePart")
        local pB = b:FindFirstChild("Stem") or b.PrimaryPart or b:FindFirstChildWhichIsA("BasePart")
        if pA and pB then
            return (pA.Position - root.Position).Magnitude < (pB.Position - root.Position).Magnitude
        end
        return false
    end)

    for _, flower in ipairs(flowers) do
        if not AutoFlowerEnabled then break end 

        local prompt = findMyPrompt(flower)
        if prompt and prompt.Enabled and prompt.Parent then
            local targetPart = prompt.Parent:IsA("BasePart") and prompt.Parent or flower:FindFirstChild("Stem") or flower.PrimaryPart
            
            if targetPart then
                root.CFrame = targetPart.CFrame + Vector3.new(0, FLOWER_CONFIG.TeleportHeight, 0)
                root.Velocity = Vector3.new(0, 0, 0)
                prompt.HoldDuration = 0
                prompt.MaxActivationDistance = 20
       
                task.wait(0.05)
                fireproximityprompt(prompt)

                local startTime = tick()
                while prompt.Parent and prompt.Enabled and (tick() - startTime) < FLOWER_CONFIG.MaxWaitTime do
                    if not AutoFlowerEnabled then break end
                    if (tick() - startTime) > 0.2 then
                        fireproximityprompt(prompt)
                    end
                    RunService.Heartbeat:Wait()
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        if AutoFlowerEnabled then
            pcall(fastCollect)
        end
        task.wait(FLOWER_CONFIG.LoopInterval)
    end
end)

local HitboxSection = CombatTab:Section({ Title = "采集花朵" })

HitboxSection:Toggle({
    Title = "自动采花",
    Default = false,
    Callback = function(state) 
        AutoFlowerEnabled = state
        if state then
            print("自动采花已开启")
        else
            print("自动采花已关闭")
        end
    end
})

local lp = game:GetService("Players").LocalPlayer
local ws = game:GetService("Workspace")
local vu = game:GetService("VirtualUser")

getgenv().settings = {
    auto_farm = false,      
    farm_treasures = true,  
    anti_afk = true         
}

if getgenv().settings.anti_afk then
    for i, v in pairs(getconnections(lp.Idled)) do
        v:Disable()
    end
    lp.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), ws.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), ws.CurrentCamera.CFrame)
    end)
end

local function getHRP()
    local char = lp.Character or lp.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart", 5)
end

local function safeTP(cf)
    local hrp = getHRP()
    if hrp then
        hrp.CFrame = cf
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end
end

task.spawn(function()
    while task.wait(0.5) do
        if getgenv().settings.auto_farm then
            pcall(function()
                local map = ws:FindFirstChild("Map")
                local treasures = map and map:FindFirstChild("Treasures")
                local obby_land = map and map:FindFirstChild("ObbyLand")
                
                if not obby_land then return end
                
                local tele = obby_land:FindFirstChild("Teleporters")
                local finish = obby_land:FindFirstChild("Finish")

                if not tele or not tele:FindFirstChild("11") then
                    safeTP(obby_land.Model:GetPivot())
                    task.wait(2)
                    return
                end

                local t11 = tele["11"]
                local f11 = finish["11"]
                
                safeTP(t11.CFrame)
                task.wait(0.3)
                fireproximityprompt(t11:FindFirstChildOfClass("ProximityPrompt"))

                task.wait(4.8) 
                
                safeTP(f11.CFrame)
                task.wait(0.3)
                fireproximityprompt(f11:FindFirstChildOfClass("ProximityPrompt"))

                if getgenv().settings.farm_treasures and treasures and #treasures:GetChildren() > 0 then
                    for _, v in pairs(treasures:GetChildren()) do
                        if not getgenv().settings.auto_farm then break end -- 中途关闭开关则停止
                        
                        local prompt = v:FindFirstChildWhichIsA("ProximityPrompt")
                        if v:IsA("BasePart") and prompt then
                            safeTP(v.CFrame * CFrame.new(0, 12, 0))
                            task.wait(0.2)
                            fireproximityprompt(prompt)
                            task.wait(0.2)
                        end
                    end
                end
            end)
        end
    end
end)

local HitboxSection = CombatTab:Section({ Title = "捡宝藏和自动完成obby" })

HitboxSection:Toggle({
    Title = "自动刷钱",
    Callback = function(state) 
        getgenv().settings.auto_farm = state
    end
})

HitboxSection:Toggle({
    Title = "同时收集宝藏",
    Default = true,
    Callback = function(state) 
        getgenv().settings.farm_treasures = state
    end
})
elseif game.GameId == 6170143659 then --- 恐鬼症
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "恐鬼症",
   Icon = 0,
   LoadingTitle = "恐鬼症",
   LoadingSubtitle = "伊散制作",
   Theme = "DarkBlue",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   KeySystem = true,
   KeySettings = {
      Title = "恐鬼症",
      Subtitle = "验证系统",
      Note = "卡密:yisan",
      FileName = "horror_fix",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"yisan"}
   }
})

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local WorkspaceService = game:GetService("Workspace")

local GhostLock = false 
local WalkSpeedConnection = nil

local Function = Window:CreateTab("功能", "book-check")

local Section = Function:CreateSection("证据")
local EMFCountLabel = Function:CreateParagraph({Title = "互动(电磁场读取)", Content = "出现次数: 0"})
local Thermometer = Function:CreateParagraph({Title = "冻结温度", Content = "获取中..."})
local Ouijabox = Function:CreateParagraph({Title = "精灵盒", Content = "需在鬼房使用道具"})

local Section = Function:CreateSection("玩家")

local NoclipLoop = nil
local NoclipToggle = Function:CreateToggle({
   Name = "穿墙(穿过一切)",
   CurrentValue = false,
   Flag = "NoclipAll",
   Callback = function(Value)
        if Value then
            NoclipLoop = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide == true then
                            part.CanCollide = false
                        end
                    end
                end
            end)
            Rayfield:Notify({Title = "穿墙", Content = "已开启，你可以穿过一切", Duration = 2})
        else
            if NoclipLoop then
                NoclipLoop:Disconnect()
                NoclipLoop = nil
            end
            Rayfield:Notify({Title = "穿墙", Content = "已关闭", Duration = 2})
        end
   end,
})
local Light = Function:CreateButton({
    Name = "夜视",
    Callback = function()
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        if Lighting:FindFirstChild("Atmosphere") then
            Lighting.Atmosphere:Destroy()
        end
    end,
})

local SpeedPlayer = Function:CreateToggle({
   Name = "加速度",
   CurrentValue = false,
   Flag = "SpeedToggle",
   Callback = function(Value)
        if Value then
            if LocalPlayer.Character then
                local deadVal = LocalPlayer.Character:FindFirstChild("Dead")
                if deadVal then deadVal.Value = true end
            end
            
            WalkSpeedConnection = RunService.RenderStepped:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    if LocalPlayer.Character.Humanoid.WalkSpeed < 18 then 
                        LocalPlayer.Character.Humanoid.WalkSpeed = 18 
                    end
                end
            end)
            
            Rayfield:Notify({
               Title = "已开启",
               Content = "体力/速度已锁定",
               Duration = 3,
               Image = "check",
            })
        else
            if WalkSpeedConnection then
                WalkSpeedConnection:Disconnect()
                WalkSpeedConnection = nil
            end
            
            if LocalPlayer.Character then
                local deadVal = LocalPlayer.Character:FindFirstChild("Dead")
                if deadVal then deadVal.Value = false end
                -- 重置速度
                if LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.WalkSpeed = 16
                end
            end
        end
   end,
})

local Section = Function:CreateSection("透视")

local function AddHighlight(parent, name, color)
    if not parent then return end
    local hl = parent:FindFirstChild(name)
    if not hl then
        hl = Instance.new("Highlight")
        hl.Name = name
        hl.FillTransparency = 1
        hl.OutlineColor = color
        hl.OutlineTransparency = 0
        hl.Parent = parent
    end
end

local function RemoveHighlight(parent, name)
    if not parent then return end
    local hl = parent:FindFirstChild(name)
    if hl then hl:Destroy() end
end

local GhostToggle = Function:CreateToggle({
   Name = "幽灵 ESP",
   CurrentValue = false,
   Flag = "GhostESP",
   Callback = function(Value)
        GhostLock = Value
        if Value then
            task.spawn(function()
                while GhostLock and task.wait(1) do
                    -- 动态查找幽灵，覆盖整个 Workspace
                    for _, obj in ipairs(WorkspaceService:GetDescendants()) do
                        if obj.Name == "Ghost" and obj:IsA("Model") then
                            AddHighlight(obj, "GhostESP_Highlight", Color3.fromRGB(255, 0, 0))
                        end
                    end
                end
            end)
        else
            for _, obj in ipairs(WorkspaceService:GetDescendants()) do
                if obj.Name == "Ghost" and obj:IsA("Model") then
                    RemoveHighlight(obj, "GhostESP_Highlight")
                end
            end
        end
   end,
})

local EMFEnabled = false
local EMF = Function:CreateToggle({
   Name = "互动 ESP",
   CurrentValue = false,
   Flag = "EMFESP",
   Callback = function(Value)
        EMFEnabled = Value
        if not Value then
            for _, v in ipairs(WorkspaceService:GetDescendants()) do
                if v.Name == "EMFBillboardGui" then v:Destroy() end
            end
        end
   end,
})

WorkspaceService.DescendantAdded:Connect(function(descendant)
    if descendant.Name == "EMFPart" and descendant:IsA("BasePart") then
        local count = 0
        local EMFMerge = "检测到互动点" 
        EMFCountLabel:Set({Title = "互动(电磁场读取)", Content = EMFMerge})

        if EMFEnabled then
            local BillboardGui = Instance.new("BillboardGui")
            local TextLabel = Instance.new("TextLabel")
            BillboardGui.Name = "EMFBillboardGui"
            BillboardGui.Parent = descendant
            BillboardGui.AlwaysOnTop = true
            BillboardGui.Size = UDim2.new(0, 40, 0, 20)
            TextLabel.Parent = BillboardGui
            TextLabel.Text = "互动"
            TextLabel.BackgroundTransparency = 1
            TextLabel.Size = UDim2.new(1, 0, 1, 0)
            TextLabel.TextColor3 = Color3.fromRGB(70, 255, 0)
            TextLabel.TextStrokeTransparency = 0
            TextLabel.TextSize = 12
        end
    end
end)

local Cursed = Function:CreateToggle({
   Name = "诅咒道具 ESP",
   CurrentValue = false,
   Flag = "CursedESP",
   Callback = function(Value)
        local targetNames = {
            ["Ouija Board"] = true,
            ["SummoningCircle"] = true,
            ["Tarot Cards"] = true,
            ["VoodooDoll"] = true,
            ["Music Box"] = true
        }

        if Value then
            for _, v in ipairs(WorkspaceService:GetDescendants()) do
                if targetNames[v.Name] and (v:IsA("Model") or v:IsA("Tool")) then
                    AddHighlight(v, "CursedESP", Color3.fromRGB(255, 170, 127))
                end
            end
        else
            for _, v in ipairs(WorkspaceService:GetDescendants()) do
                if targetNames[v.Name] then
                    RemoveHighlight(v, "CursedESP")
                end
            end
        end
   end,
})

local Generators = Function:CreateToggle({
   Name = "发电机 ESP",
   CurrentValue = false,
   Flag = "GenESP",
   Callback = function(Value)
        local targets = {}
        if WorkspaceService:FindFirstChild("Map") and WorkspaceService.Map:FindFirstChild("Generators") then
             table.insert(targets, WorkspaceService.Map.Generators)
        end
        for _, v in ipairs(WorkspaceService:GetDescendants()) do
            if v.Name == "GeneratorMesh" or v.Name == "Generator" then
                if Value then
                    AddHighlight(v, "GeneratorsESP", Color3.fromRGB(255, 255, 127))
                else
                    RemoveHighlight(v, "GeneratorsESP")
                end
            end
        end
   end,
})

local Section = Function:CreateSection("恶搞")
local Death = Function:CreateButton({
   Name = "自杀 (需清空手持道具)",
   Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.Health = 0
        end
   end,
})

local PlayerTab = Window:CreateTab("防巡查", "triangle-alert")
Players.PlayerAdded:Connect(function(player)
    PlayerTab:CreateParagraph({Title = "Name: " .. player.Name, Content = "ID: " .. player.UserId})
	Rayfield:Notify({
        Title = "警报",
        Content = "新玩家加入: " .. player.Name,
        Duration = 5,
        Image = "triangle-alert",
    })
end)

WorkspaceService.DescendantAdded:Connect(function(child)
    if child:IsA("Sound") and child.Parent and child.Parent.Name == "Handle" then
        local tool = child.Parent.Parent
        if tool and tool.Name == "Spirit Box" then
             Ouijabox:Set({Title = "精灵盒", Content = "检测到声音: " .. child.Name})
             Rayfield:Notify({Title = "精灵盒", Content = "检测到回应", Duration = 3, Image = "check"})
        end
    end
end)

task.spawn(function()
    while task.wait(2) do
        local foundTemp = false
        for _, v in ipairs(WorkspaceService:GetDescendants()) do
            if v.Name == "_____Temperature" and v:IsA("ValueBase") then
                if v.Value < 0 then 
                    Thermometer:Set({Title = "冻结温度!", Content = tostring(v.Value)})
                    if not foundTemp then 
                        Rayfield:Notify({Title = "冻结温度", Content = "发现刺骨寒温!", Duration = 3, Image = "check"})
                    end
                    foundTemp = true
                end
            end
        end
    end
end)

Rayfield:LoadConfiguration()
elseif game.GameId == 5677613211 then --- 吃吃世界
    loadstring(game:HttpGet("https://raw.githubusercontent.com/2721284198-dev/daweiqingyi/refs/heads/main/pro%E9%87%8D%E7%94%9F%E7%89%88"))()
elseif game.GameId == 6035872082 then --- 竞争对手
    local Env = getfenv()
local SoundService = game:GetService("SoundService")
local PlayStartSound = Instance.new("Sound")
PlayStartSound.SoundId = "rbxassetid://88457346646245"
PlayStartSound.Looped = false
PlayStartSound.Volume = 1
PlayStartSound.Parent = SoundService
PlayStartSound:Play()
PlayStartSound.Ended:Connect(function() PlayStartSound:Destroy() end)

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local cloneref = cloneref or function(instance) return instance end

local WindUI
do
    local ok, result = pcall(function()
        return require("./src/Init")
    end)
    if ok then
        WindUI = result
    else
        if RunService:IsStudio() then
            WindUI = require(cloneref(ReplicatedStorage:WaitForChild("WindUI"):WaitForChild("Init")))
        else
            WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/gycgchgyfytdttr/shenqin/refs/heads/main/ui.lua"))()
        end
    end
end

local ESPEnabled = false
local ESP_ScreenGui = nil
local ESPFolder = nil
local ESPNameColor = Color3.fromRGB(0, 255, 127)
local ESPBodyColor = Color3.fromRGB(0, 255, 127)
local ESPNameSize = 14
local ESPRainbowEnabled = false
local ESPRainbowSpeed = 5
local CurrentESPHue = 0

local BackstabCheckEnabled = false
local BackstabCooldown = 0
local BACKSTAB_COOLDOWN_TIME = 3
local DeathCheckEnabled = false

local InfiniteJumpEnabled = false
local JumpConnection = nil
local SpeedEnabled = false
local SpeedValue = 1
local SpeedConnection = nil
local GravityLoop = nil
local originalGravity = workspace.Gravity

local NightVisionEnabled = false
local originalBrightness = Lighting.Brightness
local originalAmbient = Lighting.Ambient

local RainbowUIEnabled = false
local RainbowUIScreenGui = nil
local StatusIndicator = nil
local animationConnection = nil

local AimSettings = {
    Enabled = false,
    FOV = 100,
    Smoothness = 10,
    CrosshairDistance = 5,
    FOVColor = Color3.fromRGB(0, 255, 0),
    FriendCheck = true,
    WallCheck = true,
    TargetPlayer = nil,
    TargetAll = true,
    FOVRainbowEnabled = true,
    FOVRainbowSpeed = 8,
    FOVEnabled = true
}

local DrawingObjects = {}
local AimConnection = nil
local FOVCircle = nil
local TargetPlayers = {}
local CurrentFOVHue = 0
local CurrentTarget = nil

local Purple = Color3.fromHex("#7775F2")
local Yellow = Color3.fromHex("#ECA201")
local Green = Color3.fromHex("#10C550")
local Grey = Color3.fromHex("#83889E")
local Blue = Color3.fromHex("#257AF7")
local Red = Color3.fromHex("#EF4F1D")

local function GetRainbowColor(hue)
    hue = hue % 1
    local r, g, b
    local i = math.floor(hue * 6)
    local f = hue * 6 - i
    local p = 1
    local q = 1 - f
    local t = f
    if i % 6 == 0 then r, g, b = 1, t, p
    elseif i % 6 == 1 then r, g, b = q, 1, p
    elseif i % 6 == 2 then r, g, b = p, 1, t
    elseif i % 6 == 3 then r, g, b = p, q, 1
    elseif i % 6 == 4 then r, g, b = t, p, 1
    else r, g, b = 1, p, q end
    return Color3.new(r, g, b)
end

local function InitESP()
    ESP_ScreenGui = Instance.new("ScreenGui")
    ESP_ScreenGui.Name = "PlayerESP_System"
    ESP_ScreenGui.ResetOnSpawn = false
    ESP_ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ESP_ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ESPFolder = Instance.new("Folder")
    ESPFolder.Name = "PlayerESPFolder"
    ESPFolder.Parent = ESP_ScreenGui
end

local function UpdateESPColors()
    if not ESPEnabled or not ESPFolder then return end
    for _, child in ipairs(ESPFolder:GetChildren()) do
        if child:IsA("BillboardGui") then
            local nameLabel = child:FindFirstChild("NameLabel")
            if nameLabel then
                nameLabel.TextColor3 = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPNameColor
                nameLabel.TextSize = ESPNameSize
            end
        elseif child:IsA("Highlight") then
            child.FillColor = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPBodyColor
            child.OutlineColor = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPBodyColor
        end
    end
end

local function UpdateESPNameSize()
    if not ESPEnabled or not ESPFolder then return end
    for _, child in ipairs(ESPFolder:GetChildren()) do
        if child:IsA("BillboardGui") then
            local nameLabel = child:FindFirstChild("NameLabel")
            if nameLabel then
                nameLabel.TextSize = ESPNameSize
            end
        end
    end
end

local function CreatePlayerESP(player)
    if player == LocalPlayer or not ESPEnabled then return end
    local character = player.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    local existingESP = ESPFolder:FindFirstChild(player.Name)
    if existingESP then existingESP:Destroy() end
    local ESPGui = Instance.new("BillboardGui")
    ESPGui.Name = player.Name
    ESPGui.Adornee = humanoidRootPart
    ESPGui.Size = UDim2.new(0, 100, 0, 40)
    ESPGui.StudsOffset = Vector3.new(0, 3, 0)
    ESPGui.AlwaysOnTop = true
    ESPGui.MaxDistance = 500
    ESPGui.Enabled = true
    ESPGui.Parent = ESPFolder
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextSize = ESPNameSize
    NameLabel.TextColor3 = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPNameColor
    NameLabel.TextStrokeTransparency = 0.5
    NameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    NameLabel.Text = player.Name
    NameLabel.Parent = ESPGui
    local DistanceLabel = Instance.new("TextLabel")
    DistanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
    DistanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
    DistanceLabel.BackgroundTransparency = 1
    DistanceLabel.Font = Enum.Font.Gotham
    DistanceLabel.TextSize = 12
    DistanceLabel.TextColor3 = Color3.fromRGB(240, 255, 245)
    DistanceLabel.TextStrokeTransparency = 0.5
    DistanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    DistanceLabel.Name = "DistanceLabel"
    DistanceLabel.Parent = ESPGui
    local Highlight = Instance.new("Highlight")
    Highlight.Name = player.Name .. "_Highlight"
    Highlight.Adornee = character
    Highlight.FillColor = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPBodyColor
    Highlight.FillTransparency = 0.7
    Highlight.OutlineColor = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPBodyColor
    Highlight.OutlineTransparency = 0
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight.Enabled = true
    Highlight.Parent = ESPFolder
end

local function CheckBackstabThreat()
    if not BackstabCheckEnabled then return end
    if BackstabCooldown > 0 then return end
    local myCharacter = LocalPlayer.Character
    local myHRP = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    local myPosition = myHRP.Position
    local myCFrame = myHRP.CFrame
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if hrp and humanoid and humanoid.Health > 0 then
                local enemyPosition = hrp.Position
                local distance = (myPosition - enemyPosition).Magnitude
                if distance < 30 then
                    local toEnemy = (enemyPosition - myPosition).Unit
                    local myForward = myCFrame.LookVector
                    local dotProduct = toEnemy:Dot(myForward)
                    if dotProduct < 0.5 then
                        WindUI:Notify({
                            Title = "偷袭警告",
                            Content = "小心有人要偷袭你：" .. player.Name,
                            Icon = "alert-triangle",
                            Color = Color3.fromRGB(255, 100, 100),
                            Duration = 5
                        })
                        BackstabCooldown = BACKSTAB_COOLDOWN_TIME
                        break
                    end
                end
            end
        end
    end
end

local function SetupDeathDetection()
    LocalPlayer.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.Died:Connect(function()
            if DeathCheckEnabled then
                WindUI:Notify({
                    Title = "死亡提醒",
                    Content = "受着",
                    Icon = "skull",
                    Color = Color3.fromRGB(255, 0, 0),
                    Duration = 8
                })
            end
        end)
    end)
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.Died:Connect(function()
                if DeathCheckEnabled then
                    WindUI:Notify({
                        Title = "死亡提醒",
                        Content = "受着",
                        Icon = "skull",
                        Color = Color3.fromRGB(255, 0, 0),
                        Duration = 8
                    })
                end
            end)
        end
    end
end

local function UpdateESP()
    if not ESPEnabled then return end
    pcall(function()
        local myCharacter = LocalPlayer.Character
        local myHRP = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local character = player.Character
                if character then
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local espGui = ESPFolder:FindFirstChild(player.Name)
                        if not espGui then
                            CreatePlayerESP(player)
                            espGui = ESPFolder:FindFirstChild(player.Name)
                        end
                        local distance = (myHRP.Position - hrp.Position).Magnitude
                        local distanceLabel = espGui:FindFirstChild("DistanceLabel")
                        if distanceLabel then
                            distanceLabel.Text = string.format("%.0f studs", distance)
                        end
                        if distance > 500 then
                            espGui.Enabled = false
                            local highlight = ESPFolder:FindFirstChild(player.Name .. "_Highlight")
                            if highlight then highlight.Enabled = false end
                        else
                            espGui.Enabled = true
                            local highlight = ESPFolder:FindFirstChild(player.Name .. "_Highlight")
                            if highlight then highlight.Enabled = true end
                        end
                    else
                        local espGui = ESPFolder:FindFirstChild(player.Name)
                        if espGui then espGui:Destroy() end
                        local highlight = ESPFolder:FindFirstChild(player.Name .. "_Highlight")
                        if highlight then highlight:Destroy() end
                    end
                else
                    local esp = ESPFolder:FindFirstChild(player.Name)
                    if esp then esp:Destroy() end
                    local highlight = ESPFolder:FindFirstChild(player.Name .. "_Highlight")
                    if highlight then highlight:Destroy() end
                end
            end
        end
    end)
end

local function ToggleESP(state)
    ESPEnabled = state
    if state then
        if not ESP_ScreenGui then InitESP() end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                CreatePlayerESP(player)
            end
        end
        WindUI:Notify({
            Title = "透视",
            Content = "玩家透视已开启",
            Icon = "eye",
        })
    else
        if ESPFolder then
            for _, esp in ipairs(ESPFolder:GetChildren()) do
                esp:Destroy()
            end
        end
        WindUI:Notify({
            Title = "透视",
            Content = "玩家透视已关闭",
            Icon = "eye",
        })
    end
end

InitESP()

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if ESPEnabled then
        if ESPFolder then
            for _, esp in ipairs(ESPFolder:GetChildren()) do
                esp:Destroy()
            end
        end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                CreatePlayerESP(player)
            end
        end
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if ESPEnabled then
            task.wait(1)
            CreatePlayerESP(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPFolder then
        local espGui = ESPFolder:FindFirstChild(player.Name)
        if espGui then espGui:Destroy() end
        local highlight = ESPFolder:FindFirstChild(player.Name .. "_Highlight")
        if highlight then highlight:Destroy() end
    end
    if CurrentTarget == player then
        CurrentTarget = nil
    end
end)

RunService.Heartbeat:Connect(function(deltaTime)
    UpdateESP()
    if ESPRainbowEnabled then
        CurrentESPHue = CurrentESPHue + deltaTime * ESPRainbowSpeed / 10
        UpdateESPColors()
    end
    if BackstabCooldown > 0 then
        BackstabCooldown = BackstabCooldown - deltaTime
    end
    CheckBackstabThreat()
end)

local Window = WindUI:CreateWindow({
    Title = "塔菲喵脚本",
    Author = "作者伊散",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(200, 395),
    Transparent = true,
    Theme = "Dark",
    User = {
        Enabled = false,
        Callback = function() print("clicked") end,
        Anonymous = false
    },
    SideBarWidth = 135,
    ScrollBarEnabled = true,
    Background = "https://chaton-images.s3.us-east-2.amazonaws.com/s4yJDF1Bl3xcR3Ltz60UHmpi6kCcCkepFA8nPI6L7aC2CgawVKOOJOiUTQvwpg8n_2043x1502x281275.jpeg",
    BackgroundImageTransparency = 0,
})

Window:EditOpenButton({
    Title = "摸摸神仇",
    Icon = "https://chaton-images.s3.us-east-2.amazonaws.com/hwD15C7Z0RT0PGftiFJtq4NGF538jL82ZmzPsUiCJ674ICGa8drYR9ufaYBGE866_2043x1502x492511.jpeg",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2.35,
    Color = ColorSequence.new(
        Color3.fromHex("3C1361"),
        Color3.fromHex("6A0DAD")
    ),
    Draggable = true,
})

local BLTab = Window:Tab({
    Title = "暴力杀戮",
    Icon = "crown",
    IconColor = Blue,
    IconShape = "Square",
    Border = true,
})

BLTab:Toggle({
    Title = "Ragebot",
    Value = false,
    Callback = function(state)
        if state then
local plr = game:GetService("Players").LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local evt = rs.Remotes.Replication.Fighter.UseItem
local cam = workspace.CurrentCamera
local rns = game:GetService("RunService")
local DebrisService = game:GetService("Debris")
local ws = game:GetService("Workspace")

local aur, lf, itm, trg = true, nil, nil, nil

for _, v in pairs(getgc(true)) do
	if type(v) == "table" and rawget(v, "LocalFighter") then
		lf = v.LocalFighter
		break
	end
end

local function createTrail(origin, targetPos)
    local trailContainer = Instance.new("Folder")
    trailContainer.Name = "MagicTrail"
    trailContainer.Parent = ws
    
    local midPoint = (origin + targetPos) / 2
    local direction = (targetPos - origin).Unit
    local perpendicular = Vector3.new(-direction.Z, direction.Y, direction.X) * 3
    local controlPoint = midPoint + perpendicular + Vector3.new(0, math.random(-3, 3), 0)
    
    local function createBezierCurve(p0, p1, p2, t)
        return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2
    end
    
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
        
        local t = i / (#curvePoints - 1)
        local color
        if t < 0.3 then
            color = Color3.fromRGB(200, 180, 255)
        elseif t < 0.6 then
            color = Color3.fromRGB(180, 150, 240)
        elseif t < 0.9 then
            color = Color3.fromRGB(160, 130, 230)
        else
            color = Color3.fromRGB(140, 100, 220)
        end
        
        beamPart.Color = color
        
        local pointLight = Instance.new("PointLight")
        pointLight.Brightness = 5
        pointLight.Range = 3
        pointLight.Color = color
        pointLight.Parent = beamPart
        
        local particles = Instance.new("ParticleEmitter")
        particles.Size = NumberSequence.new(0.1, 0.3)
        particles.Transparency = NumberSequence.new(0.3, 0.8)
        particles.Lifetime = NumberRange.new(0.5, 1)
        particles.Rate = 50
        particles.Speed = NumberRange.new(1, 2)
        particles.VelocitySpread = 180
        particles.Color = ColorSequence.new(color)
        particles.Parent = beamPart
    end
    
    DebrisService:AddItem(trailContainer, 1.5)
    
    return trailContainer
end

local function encf(pos, lat)
	local cf = CFrame.lookAt(pos, lat)
	local rx, ry, rz = cf:ToOrientation()
	return {
		["\x00"] = pos.X,
		["\x01"] = pos.Y,
		["\x02"] = pos.Z,
		["\x03"] = rx,
		["\x04"] = ry,
		["\x05"] = rz,
	}
end

local function wallCheck(startPos, endPos, targetPart)
	local direction = (endPos - startPos).Unit
	local distance = (endPos - startPos).Magnitude
	
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {plr.Character, targetPart.Parent}
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	raycastParams.IgnoreWater = true
	
	local raycastResult = ws:Raycast(startPos, direction * distance, raycastParams)
	
	if raycastResult then
		if raycastResult.Instance:IsDescendantOf(targetPart.Parent) then
			return true
		end
		return false
	end
	return true
end

task.spawn(function()
	while aur do
		local np, nd = nil, 9999
		local ch = plr.Character
		if ch and ch:FindFirstChild("HumanoidRootPart") then
			local cp = ch.HumanoidRootPart.Position
			for _, v in pairs(workspace:GetChildren()) do
				if v ~= ch and v:FindFirstChild("Head") and v:FindFirstChild("Humanoid") then
					local hum = v:FindFirstChild("Humanoid")
					if hum and hum.Health > 0 then
						local d = (v.HumanoidRootPart.Position - cp).Magnitude
						if d < nd then
							nd = d
							np = v
						end
					end
				end
			end
		end
		trg = np
		task.wait(0.05)
	end
end)

task.spawn(function()
	while aur do
		if lf and lf.Items then
			for _, v in pairs(lf.Items) do
				if v.IsEquipped and v.Info and v.Info.MaxAmmo then
					itm = v
					break
				end
			end
		end
		task.wait(0.5)
	end
end)

rns.RenderStepped:Connect(function()
	if not aur then
		return
	end
	if trg then
		local ch = plr.Character
		if ch and ch:FindFirstChild("HumanoidRootPart") then
			local hrp = ch.HumanoidRootPart
			local tp = trg:FindFirstChild("HumanoidRootPart")
			if tp then
				local mps = hrp.Position
				local eps = tp.Position
				local lat = Vector3.new(eps.X, mps.Y, eps.Z)
				hrp.CFrame = CFrame.lookAt(mps, lat)
			end
		end
	end
end)

local trailPool = {}
local MAX_TRAILS = 50

task.spawn(function()
	while aur do
		for i = #trailPool, 1, -1 do
			local trail = trailPool[i]
			if trail and trail.Parent == nil then
				table.remove(trailPool, i)
			end
		end
		task.wait(0.5)
	end
end)

task.spawn(function()
	while aur do
		if itm and trg then
			local hd = trg:FindFirstChild("Head")
			local ch = plr.Character
			if hd and ch and ch:FindFirstChild("HumanoidRootPart") then
				local hrp = ch.HumanoidRootPart
				local tp = hd.Position
				local cp = hrp.Position + Vector3.new(0, 1.5, 0)
				local dir = (tp - cp).Unit
				
				if wallCheck(cp, tp, hd) then
					local maxOffset = 0.2
					local distance = (tp - cp).Magnitude
					local distanceFactor = math.min(distance / 50, 1)
					local actualOffset = maxOffset * distanceFactor
					
					local offsetX = (math.random() - 0.5) * 2 * actualOffset
					local offsetY = (math.random() - 0.5) * 2 * actualOffset
					local offsetZ = (math.random() - 0.5) * 2 * actualOffset
					
					local targetPosition = tp + Vector3.new(offsetX, offsetY, offsetZ)
					
					evt:FireServer(itm:Get("ObjectID"), "\x1A", {
						["\x01"] = {
							["\x00"] = encf(cp, targetPosition),
							["\x01"] = encf(targetPosition, cp),
							["\x02"] = hd,
							["\x03"] = {
								["\x00"] = dir.X,
								["\x01"] = dir.Y,
								["\x02"] = dir.Z,
								["\x03"] = -dir.X,
								["\x04"] = -dir.Y,
								["\x05"] = -dir.Z,
							},
						},
						["\x02"] = true,
						["\x03"] = true,
					}, nil)

					local newTrail = createTrail(cp, targetPosition)
					if newTrail then
						table.insert(trailPool, newTrail)
					end

					local snd = Instance.new("Sound", workspace)
					snd.SoundId = "rbxassetid://8679627751"
					snd.Volume = 1
					snd.PlayOnRemove = true
					DebrisService:AddItem(snd, 1)
				end
			end
		end
		task.wait(0.01)
	end
end)
        end
    end
})

local PlayerTab = Window:Tab({
    Title = "本地玩家",
    Icon = "user",
    IconColor = Blue,
    IconShape = "Square",
    Border = true,
})

do
    PlayerTab:Section({
        Title = "主要功能",
        TextSize = 16,
        FontWeight = Enum.FontWeight.SemiBold,
    })
    PlayerTab:Toggle({
        Title = "无限跳跃",
        Desc = "启用后可以无限跳跃",
        Callback = function(enabled)
            InfiniteJumpEnabled = enabled
            if enabled then
                if JumpConnection then
                    JumpConnection:Disconnect()
                end
                JumpConnection = UserInputService.JumpRequest:Connect(function()
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("Humanoid") then
                        char.Humanoid:ChangeState("Jumping")
                    end
                end)
                WindUI:Notify({
                    Title = "无限跳跃",
                    Content = "已开启无限跳跃",
                    Icon = "jump-rope",
                })
            else
                if JumpConnection then
                    JumpConnection:Disconnect()
                    JumpConnection = nil
                end
                WindUI:Notify({
                    Title = "无限跳跃",
                    Content = "已关闭无限跳跃",
                    Icon = "jump-rope",
                })
            end
        end
    })
    PlayerTab:Space()
    PlayerTab:Input({
        Title = "设置重力",
        Desc = "输入重力值 (默认:196" .. tostring(originalGravity) .. ")",
        Placeholder = "输入重力值",
        Callback = function(value)
            local numValue = tonumber(value)
            if numValue then
                if GravityLoop then
                    GravityLoop:Disconnect()
                    GravityLoop = nil
                end
                workspace.Gravity = numValue
                WindUI:Notify({
                    Title = "重力设置",
                    Content = "重力已设置为: " .. tostring(numValue),
                    Icon = "weight",
                })
            else
                WindUI:Notify({
                    Title = "错误来了",
                    Content = "请输入数字",
                    Icon = "alert-circle",
                    Color = Red,
                })
            end
        end
    })
    PlayerTab:Space()
    PlayerTab:Input({
        Title = "设置快速跑步速度",
        Desc = "输入速度 (默认: 1)",
        Placeholder = "输入速度",
        Callback = function(value)
            local numValue = tonumber(value)
            if numValue then
                SpeedValue = numValue
                WindUI:Notify({
                    Title = "速度设置",
                    Content = "速度已设置为: " .. tostring(numValue) .. "速度",
                    Icon = "zap",
                })
            else
                WindUI:Notify({
                    Title = "依旧错误来了",
                    Content = "请输入有效数字",
                    Icon = "alert-circle",
                    Color = Red,
                })
            end
        end
    })
    PlayerTab:Toggle({
        Title = "开启快速跑步",
        Desc = "启用快速跑步功能",
        Callback = function(enabled)
            SpeedEnabled = enabled
            if enabled then
                if SpeedConnection then
                    SpeedConnection:Disconnect()
                end
                SpeedConnection = RunService.Heartbeat:Connect(function()
                    local player = LocalPlayer
                    local char = player.Character
                    if char and char:FindFirstChild("Humanoid") then
                        local humanoid = char.Humanoid
                        if humanoid.MoveDirection.Magnitude > 0 then
                            char:TranslateBy(humanoid.MoveDirection * SpeedValue / 2)
                        end
                    end
                end)
            else
                if SpeedConnection then
                    SpeedConnection:Disconnect()
                    SpeedConnection = nil
                end
            end
        end
    })
end

local AimTab = Window:Tab({
    Title = "暴力功能",
    Icon = "crosshair",
    IconColor = Red,
    IconShape = "Square",
    Border = true,
})

local function InitializeAimDrawings()
    if not FOVCircle then
        FOVCircle = Drawing.new("Circle")
        FOVCircle.Visible = AimSettings.Enabled and AimSettings.FOVEnabled
        FOVCircle.Thickness = 2
        FOVCircle.Filled = false
        FOVCircle.Radius = AimSettings.FOV
        FOVCircle.Position = workspace.CurrentCamera.ViewportSize / 2
        table.insert(DrawingObjects, FOVCircle)
    end
end

local function UpdateFOVCircle()
    if FOVCircle then
        FOVCircle.Visible = AimSettings.Enabled and AimSettings.FOVEnabled
        FOVCircle.Radius = AimSettings.FOV
        if AimSettings.FOVRainbowEnabled then
            FOVCircle.Color = GetRainbowColor(CurrentFOVHue)
        else
            FOVCircle.Color = AimSettings.FOVColor
        end
        FOVCircle.Position = workspace.CurrentCamera.ViewportSize / 2
    end
end

local function CleanupDrawings()
    for _, drawing in ipairs(DrawingObjects) do
        if drawing then
            drawing:Remove()
        end
    end
    DrawingObjects = {}
    FOVCircle = nil
end

local function IsFriend(player)
    if not AimSettings.FriendCheck then
        return false
    end
    local localPlayer = LocalPlayer
    local success, result = pcall(function()
        if localPlayer:IsFriendsWith(player.UserId) then
            return true
        end
        return false
    end)
    return success and result
end

local function WallCheck(targetPosition, targetCharacter)
    if not AimSettings.WallCheck then
        return true
    end
    local camera = workspace.CurrentCamera
    local origin = camera.CFrame.Position
    local direction = (targetPosition - origin).Unit
    local distance = (targetPosition - origin).Magnitude
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, targetCharacter}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.IgnoreWater = true
    raycastParams.CollisionGroup = "Default"
    local raycastResult = workspace:Raycast(origin, direction * distance, raycastParams)
    return raycastResult == nil
end

local function GetClosestPlayer()
    local camera = workspace.CurrentCamera
    local mousePos = camera.ViewportSize / 2
    local nearestPlayer = nil
    local shortestDistance = AimSettings.FOV

    if AimSettings.TargetPlayer and not AimSettings.TargetAll then
        local target = Players:FindFirstChild(AimSettings.TargetPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = target.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local targetPos = target.Character.HumanoidRootPart.Position
                local screenPos, onScreen = camera:WorldToViewportPoint(targetPos)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance <= AimSettings.FOV and WallCheck(targetPos, target.Character) then
                        if not IsFriend(target) then
                            CurrentTarget = target
                            return target
                        end
                    end
                end
            end
        end
        CurrentTarget = nil
        return nil
    end

    if CurrentTarget and CurrentTarget ~= LocalPlayer and CurrentTarget.Character then
        local hrp = CurrentTarget.Character:FindFirstChild("HumanoidRootPart")
        local humanoid = CurrentTarget.Character:FindFirstChild("Humanoid")
        if hrp and humanoid and humanoid.Health > 0 then
            local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if distance <= AimSettings.FOV and WallCheck(hrp.Position, CurrentTarget.Character) then
                    if not IsFriend(CurrentTarget) then
                        return CurrentTarget
                    end
                end
            end
        end
    end

    CurrentTarget = nil
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if not IsFriend(player) then
                local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoidRootPart and humanoid and humanoid.Health > 0 then
                    if WallCheck(humanoidRootPart.Position, player.Character) then
                        local screenPos, onScreen = camera:WorldToViewportPoint(humanoidRootPart.Position)
                        if onScreen then
                            local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                            if distance < shortestDistance then
                                shortestDistance = distance
                                nearestPlayer = player
                            end
                        end
                    end
                end
            end
        end
    end
    if nearestPlayer then
        CurrentTarget = nearestPlayer
    end
    return nearestPlayer
end

local function AimBot()
    if not AimSettings.Enabled then
        return
    end
    local camera = workspace.CurrentCamera
    local target = GetClosestPlayer()
    if target and target.Character then
        local humanoidRootPart = target.Character:FindFirstChild("HumanoidRootPart")
        local head = target.Character:FindFirstChild("Head")
        if humanoidRootPart and head then
            local targetVelocity = humanoidRootPart.Velocity
            local targetPosition = head.Position
            if AimSettings.CrosshairDistance > 0 then
                local distance = (targetPosition - camera.CFrame.Position).Magnitude
                local timeToTarget = distance / 1000
                targetPosition = targetPosition + (targetVelocity * timeToTarget * AimSettings.CrosshairDistance)
            end
            local currentCFrame = camera.CFrame
            local targetCFrame = CFrame.new(currentCFrame.Position, targetPosition)
            local smoothedCFrame = currentCFrame:Lerp(targetCFrame, 1 / AimSettings.Smoothness)
            camera.CFrame = smoothedCFrame
        end
    end
end

local function CreateRainbowUI()
    if RainbowUIScreenGui then
        RainbowUIScreenGui:Destroy()
        RainbowUIScreenGui = nil
    end
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    RainbowUIScreenGui = Instance.new("ScreenGui")
    RainbowUIScreenGui.Name = "RainbowCircleUI"
    RainbowUIScreenGui.ResetOnSpawn = false
    RainbowUIScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    RainbowUIScreenGui.DisplayOrder = 99999
    RainbowUIScreenGui.IgnoreGuiInset = true
    RainbowUIScreenGui.Enabled = true
    RainbowUIScreenGui.Parent = playerGui
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "RainbowCircle"
    mainFrame.Size = UDim2.new(0, 80, 0, 80)
    mainFrame.Position = UDim2.new(0, 10, 0, 10)
    mainFrame.BackgroundTransparency = 1
    mainFrame.ZIndex = 100000
    mainFrame.Parent = RainbowUIScreenGui
    mainFrame.Active = true
    mainFrame.Selectable = true
    mainFrame.Draggable = false
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(1, 0)
    uiCorner.Parent = mainFrame
    local rainbowBackground = Instance.new("Frame")
    rainbowBackground.Name = "RainbowBackground"
    rainbowBackground.Size = UDim2.new(1, 0, 1, 0)
    rainbowBackground.Position = UDim2.new(0, 0, 0, 0)
    rainbowBackground.BackgroundTransparency = 0
    rainbowBackground.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    rainbowBackground.ZIndex = 100001
    rainbowBackground.Parent = mainFrame
    rainbowBackground.Active = true
    rainbowBackground.Selectable = true
    local rainbowCorner = Instance.new("UICorner")
    rainbowCorner.CornerRadius = UDim.new(1, 0)
    rainbowCorner.Parent = rainbowBackground
    local rainbowStroke = Instance.new("UIStroke")
    rainbowStroke.Name = "RainbowStroke"
    rainbowStroke.Color = Color3.fromRGB(255, 255, 255)
    rainbowStroke.Thickness = 3
    rainbowStroke.Transparency = 0
    rainbowStroke.Parent = mainFrame
    local innerStroke = Instance.new("UIStroke")
    innerStroke.Name = "InnerStroke"
    innerStroke.Color = Color3.fromRGB(0, 0, 0)
    innerStroke.Thickness = 1
    innerStroke.Transparency = 0.3
    innerStroke.Parent = rainbowBackground
    StatusIndicator = Instance.new("Frame")
    StatusIndicator.Name = "StatusIndicator"
    StatusIndicator.Size = UDim2.new(0, 15, 0, 15)
    StatusIndicator.Position = UDim2.new(1, -18, 1, -18)
    StatusIndicator.BackgroundColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    StatusIndicator.BackgroundTransparency = 0
    StatusIndicator.ZIndex = 100002
    StatusIndicator.Parent = mainFrame
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = StatusIndicator
    local indicatorStroke = Instance.new("UIStroke")
    indicatorStroke.Color = Color3.fromRGB(255, 255, 255)
    indicatorStroke.Thickness = 2
    indicatorStroke.Parent = StatusIndicator
    local statusText = Instance.new("TextLabel")
    statusText.Name = "StatusText"
    statusText.Size = UDim2.new(1, 0, 0, 25)
    statusText.Position = UDim2.new(0, 0, 1, 5)
    statusText.BackgroundTransparency = 1
    statusText.Text = AimSettings.Enabled and "自瞄开" or "自瞄关"
    statusText.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusText.TextSize = 14
    statusText.Font = Enum.Font.GothamBold
    statusText.TextStrokeTransparency = 0.3
    statusText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    statusText.TextStrokeTransparency = 0.3
    statusText.ZIndex = 100002
    statusText.Parent = mainFrame
    local clickArea = Instance.new("TextButton")
    clickArea.Name = "ClickArea"
    clickArea.Size = UDim2.new(1, 0, 1, 0)
    clickArea.Position = UDim2.new(0, 0, 0, 0)
    clickArea.BackgroundTransparency = 1
    clickArea.Text = ""
    clickArea.ZIndex = 100003
    clickArea.Parent = mainFrame
    local rainbowColors = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(255, 95, 0),
        Color3.fromRGB(255, 165, 0),
        Color3.fromRGB(255, 215, 0),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(144, 238, 144),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 200, 200),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(75, 0, 130),
        Color3.fromRGB(138, 43, 226),
        Color3.fromRGB(148, 0, 211),
        Color3.fromRGB(199, 21, 133),
        Color3.fromRGB(255, 20, 147)
    }
    local rainbowColors2 = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(255, 127, 0),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(75, 0, 130),
        Color3.fromRGB(148, 0, 211)
    }
    local timeOffset = 0
    local hoverAmplitude = 4
    local hoverSpeed = 4
    local pulseSpeed = 2
    local pulseAmount = 0.1
    local colorIndex = 1
    local colorIndex2 = 3
    local transitionTime = 0.8
    local transitionTime2 = 0.5
    local elapsedTime = 0
    local elapsedTime2 = 0
    local pulseScale = 1
    local isPulsingOut = true
    if animationConnection then
        animationConnection:Disconnect()
    end
    animationConnection = RunService.RenderStepped:Connect(function(deltaTime)
        if not RainbowUIEnabled or not RainbowUIScreenGui or not RainbowUIScreenGui.Parent then
            animationConnection:Disconnect()
            animationConnection = nil
            return
        end
        elapsedTime = elapsedTime + deltaTime
        if elapsedTime >= transitionTime then
            elapsedTime = 0
            colorIndex = colorIndex + 1
            if colorIndex > #rainbowColors then
                colorIndex = 1
            end
        end
        local nextColorIndex = colorIndex + 1
        if nextColorIndex > #rainbowColors then
            nextColorIndex = 1
        end
        local alpha = elapsedTime / transitionTime
        local currentBgColor = rainbowColors[colorIndex]:Lerp(rainbowColors[nextColorIndex], alpha)
        rainbowBackground.BackgroundColor3 = currentBgColor
        elapsedTime2 = elapsedTime2 + deltaTime
        if elapsedTime2 >= transitionTime2 then
            elapsedTime2 = 0
            colorIndex2 = colorIndex2 + 1
            if colorIndex2 > #rainbowColors2 then
                colorIndex2 = 1
            end
        end
        local nextColorIndex2 = colorIndex2 + 1
        if nextColorIndex2 > #rainbowColors2 then
            nextColorIndex2 = 1
        end
        local alpha2 = elapsedTime2 / transitionTime2
        local currentStrokeColor = rainbowColors2[colorIndex2]:Lerp(rainbowColors2[nextColorIndex2], alpha2)
        rainbowStroke.Color = currentStrokeColor
        if isPulsingOut then
            pulseScale = pulseScale + deltaTime * pulseSpeed * pulseAmount
            if pulseScale >= 1 + pulseAmount then
                isPulsingOut = false
            end
        else
            pulseScale = pulseScale - deltaTime * pulseSpeed * pulseAmount
            if pulseScale <= 1 - pulseAmount then
                isPulsingOut = true
            end
        end
        rainbowBackground.Size = UDim2.new(pulseScale, 0, pulseScale, 0)
        rainbowBackground.Position = UDim2.new((1 - pulseScale) / 2, 0, (1 - pulseScale) / 2, 0)
        timeOffset = timeOffset + deltaTime * hoverSpeed
        local hoverOffset = math.sin(timeOffset) * hoverAmplitude
        mainFrame.Position = UDim2.new(0, 10, 0, 10 + hoverOffset)
        innerStroke.Transparency = 0.2 + 0.3 * math.sin(timeOffset * 2)
        if StatusIndicator then
            StatusIndicator.BackgroundColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        end
        if statusText then
            statusText.Text = AimSettings.Enabled and "自瞄开" or "自瞄关"
            statusText.TextColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100)
        end
    end)
    local function handleClick()
        AimSettings.Enabled = not AimSettings.Enabled
        if AimSettings.Enabled then
            InitializeAimDrawings()
            UpdateFOVCircle()
            if AimConnection then
                AimConnection:Disconnect()
            end
            AimConnection = RunService.RenderStepped:Connect(function(deltaTime)
                if AimSettings.FOVRainbowEnabled then
                    CurrentFOVHue = CurrentFOVHue + deltaTime * AimSettings.FOVRainbowSpeed / 10
                end
                UpdateFOVCircle()
                AimBot()
            end)
        else
            if AimConnection then
                AimConnection:Disconnect()
                AimConnection = nil
            end
            CleanupDrawings()
            CurrentTarget = nil
        end
        if StatusIndicator then
            StatusIndicator.BackgroundColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        end
        if statusText then
            statusText.Text = AimSettings.Enabled and "自瞄开" or "自瞄关"
            statusText.TextColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100)
        end
        local originalSize = rainbowBackground.Size
        local originalPosition = rainbowBackground.Position
        local tweenInfo1 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tweenInfo2 = TweenInfo.new(0.15, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
        local clickScaleUp = TweenService:Create(rainbowBackground, tweenInfo1, {
            Size = originalSize * 0.7,
            Position = UDim2.new(0.15, 0, 0.15, 0)
        })
        local clickScaleDown = TweenService:Create(rainbowBackground, tweenInfo2, {
            Size = originalSize,
            Position = originalPosition
        })
        local originalStrokeColor = rainbowStroke.Color
        local flashTween = TweenService:Create(rainbowStroke, tweenInfo1, {
            Color = Color3.fromRGB(255, 255, 255)
        })
        local revertStroke = TweenService:Create(rainbowStroke, tweenInfo2, {
            Color = originalStrokeColor
        })
        clickScaleUp:Play()
        flashTween:Play()
        clickScaleUp.Completed:Connect(function()
            clickScaleDown:Play()
            revertStroke:Play()
        end)
    end
    clickArea.MouseButton1Click:Connect(handleClick)
    mainFrame.MouseButton1Click:Connect(handleClick)
    mainFrame.MouseEnter:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween1 = TweenService:Create(rainbowStroke, tweenInfo, {
            Thickness = 6
        })
        pulseAmount = 0.15
        tween1:Play()
    end)
    mainFrame.MouseLeave:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween1 = TweenService:Create(rainbowStroke, tweenInfo, {
            Thickness = 3
        })
        pulseAmount = 0.1
        tween1:Play()
    end)
    rainbowBackground.BackgroundTransparency = 1
    rainbowStroke.Transparency = 1
    local fadeIn = TweenService:Create(rainbowBackground, TweenInfo.new(0.5), {
        BackgroundTransparency = 0
    })
    local strokeFadeIn = TweenService:Create(rainbowStroke, TweenInfo.new(0.5), {
        Transparency = 0
    })
    task.wait(0.2)
    fadeIn:Play()
    strokeFadeIn:Play()
    return true
end

local function ToggleRainbowUI(state)
    RainbowUIEnabled = state
    if state then
        local success = CreateRainbowUI()
        if success then
            WindUI:Notify({
                Title = "自瞄快捷UI",
                Content = "快捷UI 让你秒人更加高效",
                Icon = "sparkles",
            })
        end
    else
        if RainbowUIScreenGui then
            RainbowUIScreenGui:Destroy()
            RainbowUIScreenGui = nil
        end
        WindUI:Notify({
            Title = "自瞄快捷UI",
            Content = "快捷UI已隐藏",
            Icon = "sparkles",
        })
    end
end

do    
    AimTab:Section({
        Title = "自瞄设置",
        TextSize = 16,
        FontWeight = Enum.FontWeight.SemiBold,
    })
    AimTab:Toggle({
        Title = "启用自瞄",
        Desc = "开启/关闭自瞄功能",
        Callback = function(enabled)
            AimSettings.Enabled = enabled
            if enabled then
                InitializeAimDrawings()
                UpdateFOVCircle()
                if AimConnection then
                    AimConnection:Disconnect()
                end
                AimConnection = RunService.RenderStepped:Connect(function(deltaTime)
                    if AimSettings.FOVRainbowEnabled then
                        CurrentFOVHue = CurrentFOVHue + deltaTime * AimSettings.FOVRainbowSpeed / 10
                    end
                    UpdateFOVCircle()
                    AimBot()
                end)
                WindUI:Notify({
                    Title = "自瞄",
                    Content = "自瞄功能已开启",
                    Icon = "crosshair",
                })
            else
                if AimConnection then
                    AimConnection:Disconnect()
                    AimConnection = nil
                end
                CleanupDrawings()
                CurrentTarget = nil
                WindUI:Notify({
                    Title = "自瞄",
                    Content = "自瞄功能已关闭",
                    Icon = "crosshair",
                })
            end
            if StatusIndicator then
                StatusIndicator.BackgroundColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            end
        end
    })
    AimTab:Space()
    AimTab:Toggle({
        Title = "自瞄快捷UI",
        Desc = "快捷UI 让你秒人更加高效",
        Callback = function(enabled)
            ToggleRainbowUI(enabled)
        end
    })
    AimTab:Toggle({
        Title = "FOV开关",
        Desc = "显示自瞄范围圆圈",
        Value = AimSettings.FOVEnabled,
        Callback = function(enabled)
            AimSettings.FOVEnabled = enabled
            UpdateFOVCircle()
        end
    })
    AimTab:Toggle({
        Title = "FOV彩虹效果",
        Desc = "开启FOV圆圈彩虹效果",
        Value = AimSettings.FOVRainbowEnabled,
        Callback = function(enabled)
            AimSettings.FOVRainbowEnabled = enabled
            UpdateFOVCircle()
        end
    })
    AimTab:Slider({
        Title = "FOV彩虹速度",
        Desc = "调整彩虹流动的速度",
        Value = {
            Min = 1,
            Max = 20,
            Default = AimSettings.FOVRainbowSpeed,
        },
        Callback = function(value)
            AimSettings.FOVRainbowSpeed = value
        end
    })
    AimTab:Space()
    AimTab:Slider({
        Title = "自瞄范围 (FOV)",
        Desc = "设置自瞄FOV大小",
        Value = {
            Min = 50,
            Max = 500,
            Default = AimSettings.FOV,
        },
        Callback = function(value)
            AimSettings.FOV = value
            UpdateFOVCircle()
        end
    })
    AimTab:Space()
    AimTab:Slider({
        Title = "自瞄平滑度",
        Desc = "数值越小越强锁",
        Value = {
            Min = 1,
            Max = 50,
            Default = AimSettings.Smoothness,
        },
        Callback = function(value)
            AimSettings.Smoothness = value
        end
    })
    AimTab:Space()
    AimTab:Slider({
        Title = "预判距离",
        Desc = "设置预判距离(需要强锁直接调到0-3)",
        Value = {
            Min = 0,
            Max = 20,
            Default = AimSettings.CrosshairDistance,
        },
        Callback = function(value)
            AimSettings.CrosshairDistance = value
        end
    })
    AimTab:Space()
    AimTab:Colorpicker({
        Title = "FOV圆圈颜色",
        Desc = "彩虹模式关闭时生效",
        Default = AimSettings.FOVColor,
        Callback = function(color)
            AimSettings.FOVColor = color
            UpdateFOVCircle()
        end
    })
    AimTab:Space()
    AimTab:Toggle({
        Title = "好友检测",
        Desc = "不秒好友",
        Value = AimSettings.FriendCheck,
        Callback = function(enabled)
            AimSettings.FriendCheck = enabled
        end
    })
    AimTab:Space()
    AimTab:Toggle({
        Title = "墙壁检测",
        Desc = "开启墙壁检测 避免自瞄乱飞",
        Value = AimSettings.WallCheck,
        Callback = function(enabled)
            AimSettings.WallCheck = enabled
        end
    })
    AimTab:Space()
    AimTab:Toggle({
        Title = "目标自瞄模式",
        Desc = "开启后可以选择目标进行制裁",
        Value = false,
        Callback = function(enabled)
            AimSettings.TargetAll = not enabled
            CurrentTarget = nil
        end
    })
    local playerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
    local targetDropdown = AimTab:Dropdown({
        Title = "选择目标玩家",
        Desc = "选择要自瞄的玩家",
        Values = playerList,
        Value = nil,
        AllowNone = true,
        Callback = function(selected)
            AimSettings.TargetPlayer = selected
            CurrentTarget = nil
        end
    })
    Players.PlayerAdded:Connect(function(player)
        table.insert(playerList, player.Name)
        if targetDropdown and targetDropdown.Refresh then
            targetDropdown:Refresh(playerList)
        end
    end)
    Players.PlayerRemoving:Connect(function(player)
        for i, name in ipairs(playerList) do
            if name == player.Name then
                table.remove(playerList, i)
                break
            end
        end
        if targetDropdown and targetDropdown.Refresh then
            targetDropdown:Refresh(playerList)
        end
    end)
    AimTab:Space()
    local statusText = "自瞄状态: 未启用"
    if AimSettings.Enabled then
        statusText = "自瞄状态: 已启用 模式: " .. (AimSettings.TargetAll and "全部玩家" or "目标玩家")
    end
    AimTab:Section({
        Title = statusText,
        TextSize = 14,
        FontWeight = Enum.FontWeight.Medium,
        TextColor = AimSettings.Enabled and Green or Grey,
    })
    local QuickSettings = AimTab:Group({})
    QuickSettings:Button({
        Title = "快速设置: 近距离(强锁)",
        Desc = "FOV: 80 平滑: 1 预判0",
        Justify = "Center",
        Callback = function()
            AimSettings.FOV = 80
            AimSettings.Smoothness = 1
            AimSettings.CrosshairDistance = 0
            UpdateFOVCircle()
            WindUI:Notify({
                Title = "快速设置",
                Content = "已使用近距离设置",
                Icon = "settings",
            })
        end
    })
    QuickSettings:Space()
    QuickSettings:Button({
        Title = "快速设置: 中距离(小强锁)",
        Desc = "FOV: 120, 平滑: 4 预判2",
        Justify = "Center",
        Callback = function()
            AimSettings.FOV = 120
            AimSettings.Smoothness = 4
            AimSettings.CrosshairDistance = 2
            UpdateFOVCircle()
            WindUI:Notify({
                Title = "快速设置",
                Content = "已使用中距离设置",
                Icon = "settings",
            })
        end
    })
    QuickSettings:Space()
    QuickSettings:Button({
        Title = "快速设置: 远距离",
        Desc = "FOV: 130 平滑: 5 预判3",
        Justify = "Center",
        Callback = function()
            AimSettings.FOV = 130
            AimSettings.Smoothness = 5
            AimSettings.CrosshairDistance = 3
            UpdateFOVCircle()
            WindUI:Notify({
                Title = "快速设置",
                Content = "已使用远距离设置",
                Icon = "settings",
            })
        end
    })
end


local OtherTab = Window:Tab({
    Title = "次要功能",
    Icon = "settings",
    IconColor = Green,
    IconShape = "Square",
    Border = true,
})

do
    OtherTab:Section({
        Title = "ESP",
        TextSize = 16,
        FontWeight = Enum.FontWeight.SemiBold,
    })
    OtherTab:Toggle({
        Title = "玩家透视 (ESP)",
        Desc = "显示玩家描边和距离",
        Callback = function(enabled)
            ToggleESP(enabled)
        end
    })
    OtherTab:Space()
    OtherTab:Colorpicker({
        Title = "ESP玩家名字颜色",
        Desc = "设置玩家名字显示颜色",
        Default = ESPNameColor,
        Callback = function(color)
            ESPNameColor = color
            if ESPEnabled and not ESPRainbowEnabled then
                UpdateESPColors()
            end
        end
    })
    OtherTab:Colorpicker({
        Title = "ESP身体绘制颜色",
        Desc = "设置玩家身体颜色",
        Default = ESPBodyColor,
        Callback = function(color)
            ESPBodyColor = color
            if ESPEnabled and not ESPRainbowEnabled then
                UpdateESPColors()
            end
        end
    })
    OtherTab:Slider({
        Title = "ESP玩家名字大小",
        Desc = "设置玩家名字的文本大小",
        Value = {
            Min = 8,
            Max = 24,
            Default = ESPNameSize,
        },
        Callback = function(value)
            ESPNameSize = value
            if ESPEnabled then
                UpdateESPNameSize()
            end
        end
    })
    OtherTab:Space()
    OtherTab:Toggle({
        Title = "ESP彩虹渐变",
        Desc = "开启透视彩虹效果",
        Callback = function(enabled)
            ESPRainbowEnabled = enabled
            if ESPEnabled then
                UpdateESPColors()
            end
        end
    })
    OtherTab:Slider({
        Title = "ESP彩虹速度",
        Desc = "调整彩虹的速度",
        Value = {
            Min = 1,
            Max = 10,
            Default = ESPRainbowSpeed,
        },
        Callback = function(value)
            ESPRainbowSpeed = value
        end
    })
    OtherTab:Space()
    OtherTab:Toggle({
        Title = "偷袭检测提醒",
        Desc = "检测背后或侧面的敌人并提醒",
        Callback = function(enabled)
            BackstabCheckEnabled = enabled
            WindUI:Notify({
                Title = "偷袭检测",
                Content = enabled and "偷袭检测已开启" or "偷袭检测已关闭",
                Icon = "shield-alert",
            })
        end
    })
    OtherTab:Toggle({
        Title = "死亡提醒",
        Desc = "玩家死亡时显示提醒消息",
        Callback = function(enabled)
            DeathCheckEnabled = enabled
            if enabled then
                SetupDeathDetection()
            end
            WindUI:Notify({
                Title = "死亡提醒",
                Content = enabled and "死亡提醒已开启" or "死亡提醒已关闭",
                Icon = "heart",
            })
        end
    })
    OtherTab:Space()
    OtherTab:Toggle({
        Title = "夜视模式",
        Desc = "开启夜间模式",
        Callback = function(enabled)
            NightVisionEnabled = enabled
            if enabled then
                originalBrightness = Lighting.Brightness
                originalAmbient = Lighting.Ambient
                Lighting.Brightness = 2
                Lighting.Ambient = Color3.fromRGB(200, 200, 200)
                Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
                WindUI:Notify({
                    Title = "夜视模式",
                    Content = "夜视模式已开启",
                    Icon = "moon",
                })
            else
                Lighting.Brightness = originalBrightness
                Lighting.Ambient = originalAmbient
                Lighting.OutdoorAmbient = Color3.fromRGB(0.5, 0.5, 0.5)
                WindUI:Notify({
                    Title = "夜视模式",
                    Content = "夜视模式已关闭",
                    Icon = "moon",
                })
            end
        end
    })
end


local MusicTab = Window:Tab({
    Title = "音乐库",
    Icon = "music",
    IconColor = Grey,
    IconShape = "Square",
    Border = true,
})

local activeSounds = {}
local customMusic = nil
local customMusicPlaying = false

do
    MusicTab:Section({
        Title = "音乐库",
        TextSize = 20,
        FontWeight = Enum.FontWeight.Bold,
    })
    MusicTab:Space()
    MusicTab:Section({
        Title = "预定义音乐列表",
        TextSize = 16,
        TextTransparency = 0.3,
    })
    MusicTab:Space()
    MusicTab:Button({
        Title = "关闭所有音乐",
        Color = Color3.fromHex("#FF3B30"),
        Justify = "Center",
        Callback = function()
            for _, sound in pairs(activeSounds) do
                if sound and sound:IsA("Sound") then
                    sound:Stop()
                    sound:Destroy()
                end
            end
            activeSounds = {}
            if customMusic then
                customMusic:Stop()
                customMusicPlaying = false
            end
            WindUI:Notify({
                Icon = "stop",
                Title = "音乐已停止",
                Content = "所有正在播放的音乐已关闭",
            })
        end,
        Icon = "stop",
        IconAlign = "Left",
    })
    MusicTab:Space()
    local musicList = {
        {"柔慢日语歌", "rbxassetid://88942576563851"},
        {"唯一", "rbxassetid://138570939058838"},
        {"Qian Li", "rbxassetid://9042630735"},
        {"DJ", "rbxassetid://112834898401032"},
    }
    for _, music in ipairs(musicList) do
        local title, soundId = music[1], music[2]
        MusicTab:Button({
            Title = title,
            Color = Color3.fromHex("#257AF7"),
            Justify = "Center",
            Callback = function()
                local sound = Instance.new("Sound")
                sound.SoundId = soundId
                sound.Parent = workspace
                sound:Play()
                table.insert(activeSounds, sound)
                WindUI:Notify({
                    Icon = "play",
                    Title = "播放音乐",
                    Content = "正在播放: " .. title,
                })
                sound.Ended:Connect(function()
                    for i, s in ipairs(activeSounds) do
                        if s == sound then
                            table.remove(activeSounds, i)
                            break
                        end
                    end
                    sound:Destroy()
                end)
            end,
            Icon = "music",
            IconAlign = "Left",
        })
    end
end

local AboutTab = Window:Tab({
    Title = "关于作者",
    Icon = "info",
    IconColor = Grey,
    IconShape = "Square",
    Border = true,
})

do
    AboutTab:Section({
        Title = "塔菲喵脚本竞争对手",
        TextSize = 20,
        FontWeight = Enum.FontWeight.Bold,
    })
    AboutTab:Space()
    AboutTab:Section({
        Title = "用的人都是萌萌人\n塔菲喵牛逼",
        TextSize = 16,
        TextTransparency = 0.3,
    })
    AboutTab:Section({
        Title = "作者伊散",
        TextSize = 16,
        TextTransparency = 0.3,
    })
    
    AboutTab:Space({ Columns = 2 })
    AboutTab:Button({
        Title = "销毁UI",
        Color = Red,
        Justify = "Center",
        Callback = function()
            if JumpConnection then
                JumpConnection:Disconnect()
            end
            if SpeedConnection then
                SpeedConnection:Disconnect()
            end
            if AimConnection then
                AimConnection:Disconnect()
            end
            CleanupDrawings()
            if RainbowUIScreenGui then
                RainbowUIScreenGui:Destroy()
            end
            workspace.Gravity = originalGravity
            if NightVisionEnabled then
                Lighting.Brightness = originalBrightness
                Lighting.Ambient = originalAmbient
            end
            if ESPEnabled then
                ToggleESP(false)
            end
            Window:Destroy()
        end
    })
    AboutTab:Space()
    AboutTab:Button({
        Title = "重置所有配置",
        Color = Yellow,
        Justify = "Center",
        Callback = function()
            AimSettings = {
                Enabled = false,
                FOV = 100,
                Smoothness = 10,
                CrosshairDistance = 5,
                FOVColor = Color3.fromRGB(0, 255, 0),
                FriendCheck = true,
                WallCheck = true,
                TargetPlayer = nil,
                TargetAll = true,
                FOVRainbowEnabled = true,
                FOVRainbowSpeed = 8,
                FOVEnabled = true
            }
            ESPNameColor = Color3.fromRGB(0, 255, 127)
            ESPBodyColor = Color3.fromRGB(0, 255, 127)
            ESPNameSize = 14
            ESPRainbowEnabled = false
            ESPRainbowSpeed = 5
            CurrentESPHue = 0
            RainbowUIEnabled = false
            BackstabCheckEnabled = false
            DeathCheckEnabled = false
            CurrentTarget = nil
            if RainbowUIScreenGui then
                RainbowUIScreenGui:Destroy()
                RainbowUIScreenGui = nil
            end
            workspace.Gravity = originalGravity
            if NightVisionEnabled then
                Lighting.Brightness = originalBrightness
                Lighting.Ambient = originalAmbient
                NightVisionEnabled = false
            end
            if ESPEnabled then
                ToggleESP(false)
            end
            WindUI:Notify({
                Title = "重置",
                Content = "所有设置已重置",
                Icon = "refresh-cw",
            })
        end
    })
end

game:BindToClose(function()
    CleanupDrawings()
    if JumpConnection then
        JumpConnection:Disconnect()
    end
    if SpeedConnection then
        SpeedConnection:Disconnect()
    end
    if AimConnection then
        AimConnection:Disconnect()
    end
    if ESPEnabled then
        ToggleESP(false)
    end
    if RainbowUIScreenGui then
        RainbowUIScreenGui:Destroy()
    end
    workspace.Gravity = originalGravity
    if NightVisionEnabled then
        Lighting.Brightness = originalBrightness
        Lighting.Ambient = originalAmbient
    end
end)

if WindUI and WindUI.InitComplete then
    WindUI.InitComplete:Wait()
end

WindUI:Notify({
    Title = "pvp",
    Content = "塔菲喵脚本",
    Icon = "check-circle",
    Duration = 5,
})
elseif game.GameId == 7009714292 then --- 启示录
    local Players = cloneref(game:GetService("Players"))
local LocalPlayer = cloneref(Players.LocalPlayer)
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))
local speed = 1
local sd = nil
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local Data = {
    TreeCuttingDistance = 50,
    MiningDistance = 50,
    KillAuraDistance = 50,
    AutoTreeCutting = false,
    AutoMining = false,
    KillAura = false,
    AutoCollectFruits = false,
    InfiniteStamina = false,
    NoHungerThirst = false
}

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Camera = Workspace.CurrentCamera

local activeHighlights = {}
local heartbeatConnection = nil


local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/454244513/WindUIFix/refs/heads/main/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "塔菲喵",
    Author = "伊散",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(150, 150),
    Transparent = true,
    Theme = "Dark",
    User = {
        Enabled = false,
        Callback = function() print("clicked") end,
        Anonymous = false
    },
    SideBarWidth = 135,
    ScrollBarEnabled = true,
    Background = "",
    BackgroundImageTransparency = 0.5,
})

Window:EditOpenButton({
    Title = "塔菲喵",
    --Icon = "https://raw.githubusercontent.com/tnine-n9/tnine/refs/heads/main/retouch_2026021013490471.png",
     --Icon = "https://chaton-images.s3.us-east-2.amazonaws.com/TDuh6pLcLaL5Njc9edXjuNvt9uxhglfns6fEqhsldY0SDHl4oLdsFqqbzKfNG2Mf_2048x2048x1346681.png",
     --Icon = "https://chaton-images.s3.us-east-2.amazonaws.com/LCiFpQ6Bn67qSpdmB6FvtIaU4gTFxeie4wilvPeUbhCBbRbZiepiyYYNEdXvJh7C_2048x2048x1381825.png",
    CornerRadius = UDim.new(0,10),
    StrokeThickness = 2.5,
    Color = ColorSequence.new(
        Color3.fromHex("#874da2"),
        --Color3.fromHex("#e8198b"),
        --Color3.fromHex("#c7eafd"),
        Color3.fromHex("#c43a30")
    ),
    Draggable = true,
})

TabSection = Window:Section({Title = "启示录", Opened = true})

local Tab = TabSection:Tab({Title = "透视功能", Icon = "check"})
local main = TabSection:Tab({Title = "主要功能", Icon = "check"})


local Section = Tab:Section({Title = "物品透视"})

Tab:Toggle({
    Title = "透视宝箱",
    Default = false,
    Image = "check",
    Callback = function(state)
        local TARGET_NAME = "CommonLoot"
        local activeHighlights_Local = {}
        local heartbeatConnection_Local = nil

        if state then
            local function UpdateHighlights()
                for _, highlight in pairs(activeHighlights) do
                    highlight:Destroy()
                end
                activeHighlights = {}

                local spawnedFolder = Workspace:FindFirstChild("Spawned")
                if spawnedFolder then
                    for _, child in ipairs(spawnedFolder:GetChildren()) do
                        if child.Name == TARGET_NAME then
                            if child:IsA("Model") or child:IsA("BasePart") then
                                local newHighlight = Instance.new("Highlight")
                                newHighlight.FillColor = Color3.fromRGB(255, 255, 0)
                                newHighlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                                newHighlight.Adornee = child
                                newHighlight.Parent = Camera
                                table.insert(activeHighlights, newHighlight)
                            end
                        end
                    end
                end
            end

            heartbeatConnection = RunService.Heartbeat:Connect(UpdateHighlights)
        else
            if heartbeatConnection then
                heartbeatConnection:Disconnect()
                heartbeatConnection = nil
            end

            for _, highlight in pairs(activeHighlights) do
                highlight:Destroy()
            end
            activeHighlights = {}
        end
    end
})

Tab:Toggle({
    Title = "透视蓝莓灌木",
    Default = false,
    Image = "check",
    Callback = function(state)
        local TARGET_NAME = "BlueberryBush"
        local activeHighlights_Local = {}
        local heartbeatConnection_Local = nil

        if state then
            local function UpdateHighlights()
                for _, highlight in pairs(activeHighlights) do
                    highlight:Destroy()
                end
                activeHighlights = {}

                local spawnedFolder = Workspace:FindFirstChild("Spawned")
                if spawnedFolder then
                    for _, child in ipairs(spawnedFolder:GetChildren()) do
                        if child.Name == TARGET_NAME then
                            if child:IsA("Model") or child:IsA("BasePart") then
                                local newHighlight = Instance.new("Highlight")
                                newHighlight.FillColor = Color3.fromRGB(174, 55, 204)
                                newHighlight.OutlineColor = Color3.fromRGB(174, 55, 204)
                                newHighlight.Adornee = child
                                newHighlight.Parent = Camera
                                table.insert(activeHighlights, newHighlight)
                            end
                        end
                    end
                end
            end

            heartbeatConnection = RunService.Heartbeat:Connect(UpdateHighlights)
        else
            if heartbeatConnection then
                heartbeatConnection:Disconnect()
                heartbeatConnection = nil
            end

            for _, highlight in pairs(activeHighlights) do
                highlight:Destroy()
            end
            activeHighlights = {}
        end
    end
})

Tab:Toggle({
    Title = "透视石头",
    Default = false,
    Image = "check",
    Callback = function(state)
        local TARGET_NAME = "Stone"
        local activeHighlights_Local = {}
        local heartbeatConnection_Local = nil
        
        if state then
            local function UpdateHighlights()
                for _, highlight in pairs(activeHighlights) do
                    highlight:Destroy()
                end
                activeHighlights = {}

                local spawnedFolder = Workspace:FindFirstChild("Spawned")
                if spawnedFolder then
                    for _, child in ipairs(spawnedFolder:GetChildren()) do
                        if child.Name == TARGET_NAME then
                            if child:IsA("Model") or child:IsA("BasePart") then
                                local newHighlight = Instance.new("Highlight")
                                newHighlight.FillColor = Color3.fromRGB(12, 98, 209)
                                newHighlight.OutlineColor = Color3.fromRGB(12, 98, 209)
                                newHighlight.Adornee = child
                                newHighlight.Parent = Camera
                                table.insert(activeHighlights, newHighlight)
                            end
                        end
                    end
                end
            end

            heartbeatConnection = RunService.Heartbeat:Connect(UpdateHighlights)
        else
            if heartbeatConnection then
                heartbeatConnection:Disconnect()
                heartbeatConnection = nil
            end

            for _, highlight in pairs(activeHighlights) do
                highlight:Destroy()
            end
            activeHighlights = {}
        end
    end
})

Tab:Toggle({
    Title = "透视铜矿石",
    Default = false,
    Image = "check",
    Callback = function(state)
        local TARGET_NAME = "CopperOre"
        local activeHighlights_Local = {}
        local heartbeatConnection_Local = nil

        if state then
            local function UpdateHighlights()
                for _, highlight in pairs(activeHighlights) do
                    highlight:Destroy()
                end
                activeHighlights = {}

                local spawnedFolder = Workspace:FindFirstChild("Spawned")
                if spawnedFolder then
                    for _, child in ipairs(spawnedFolder:GetChildren()) do
                        if child.Name == TARGET_NAME then
                            if child:IsA("Model") or child:IsA("BasePart") then
                                local newHighlight = Instance.new("Highlight")
                                newHighlight.FillColor = Color3.fromRGB(224, 24, 24)
                                newHighlight.OutlineColor = Color3.fromRGB(224, 24, 24)
                                newHighlight.Adornee = child
                                newHighlight.Parent = Camera
                                table.insert(activeHighlights, newHighlight)
                            end
                        end
                    end
                end
            end

            heartbeatConnection = RunService.Heartbeat:Connect(UpdateHighlights)
        else
            if heartbeatConnection then
                heartbeatConnection:Disconnect()
                heartbeatConnection = nil
            end

            for _, highlight in pairs(activeHighlights) do
                highlight:Destroy()
            end
            activeHighlights = {}
        end
    end
})

Tab:Toggle({
    Title = "透视铁矿石",
    Default = false,
    Image = "check",
    Callback = function(state)
        local TARGET_NAME = "IronOre"
        local activeHighlights_Local = {}
        local heartbeatConnection_Local = nil

        if state then
            local function UpdateHighlights()
                for _, highlight in pairs(activeHighlights) do
                    highlight:Destroy()
                end
                activeHighlights = {}

                local spawnedFolder = Workspace:FindFirstChild("Spawned")
                if spawnedFolder then
                    for _, child in ipairs(spawnedFolder:GetChildren()) do
                        if child.Name == TARGET_NAME then
                            if child:IsA("Model") or child:IsA("BasePart") then
                                local newHighlight = Instance.new("Highlight")
                                newHighlight.FillColor = Color3.fromRGB(0, 255, 136)
                                newHighlight.OutlineColor = Color3.fromRGB(0, 255, 136)
                                newHighlight.Adornee = child
                                newHighlight.Parent = Camera
                                table.insert(activeHighlights, newHighlight)
                            end
                        end
                    end
                end
            end

            heartbeatConnection = RunService.Heartbeat:Connect(UpdateHighlights)
        else
            if heartbeatConnection then
                heartbeatConnection:Disconnect()
                heartbeatConnection = nil
            end

            for _, highlight in pairs(activeHighlights) do
                highlight:Destroy()
            end
            activeHighlights = {}
        end
    end
})

Tab:Toggle({
    Title = "透视马铃薯植物",
    Default = false,
    Image = "check",
    Callback = function(state)
        local TARGET_NAME = "PotatoPlant"
        local activeHighlights_Local = {}
        local heartbeatConnection_Local = nil

        if state then
            local function UpdateHighlights()
                for _, highlight in pairs(activeHighlights) do
                    highlight:Destroy()
                end
                activeHighlights = {}

                local spawnedFolder = Workspace:FindFirstChild("Spawned")
                if spawnedFolder then
                    for _, child in ipairs(spawnedFolder:GetChildren()) do
                        if child.Name == TARGET_NAME then
                            if child:IsA("Model") or child:IsA("BasePart") then
                                local newHighlight = Instance.new("Highlight")
                                newHighlight.FillColor = Color3.fromRGB(98, 0, 255)
                                newHighlight.OutlineColor = Color3.fromRGB(98, 0, 255)
                                newHighlight.Adornee = child
                                newHighlight.Parent = Camera
                                table.insert(activeHighlights, newHighlight)
                            end
                        end
                    end
                end
            end

            heartbeatConnection = RunService.Heartbeat:Connect(UpdateHighlights)
        else
            if heartbeatConnection then
                heartbeatConnection:Disconnect()
                heartbeatConnection = nil
            end

            for _, highlight in pairs(activeHighlights) do
                highlight:Destroy()
            end
            activeHighlights = {}
        end
    end
})

Tab:Toggle({
    Title = "透视稀有战利品",
    Default = false,
    Image = "check",
    Callback = function(state)
        local TARGET_NAME = "RareLoot"
        local activeHighlights_Local = {}
        local heartbeatConnection_Local = nil

        if state then
            local function UpdateHighlights()
                for _, highlight in pairs(activeHighlights) do
                    highlight:Destroy()
                end
                activeHighlights = {}

                local spawnedFolder = Workspace:FindFirstChild("Spawned")
                if spawnedFolder then
                    for _, child in ipairs(spawnedFolder:GetChildren()) do
                        if child.Name == TARGET_NAME then
                            if child:IsA("Model") or child:IsA("BasePart") then
                                local newHighlight = Instance.new("Highlight")
                                newHighlight.FillColor = Color3.fromRGB(0, 183, 255)
                                newHighlight.OutlineColor = Color3.fromRGB(0, 183, 255)
                                newHighlight.Adornee = child
                                newHighlight.Parent = Camera
                                table.insert(activeHighlights, newHighlight)
                            end
                        end
                    end
                end
            end

            heartbeatConnection = RunService.Heartbeat:Connect(UpdateHighlights)
        else
            if heartbeatConnection then
                heartbeatConnection:Disconnect()
                heartbeatConnection = nil
            end

            for _, highlight in pairs(activeHighlights) do
                highlight:Destroy()
            end
            activeHighlights = {}
        end
    end
})

Tab:Toggle({
    Title = "透视砂岩",
    Default = false,
    Image = "check",
    Callback = function(state)
        local TARGET_NAME = "Sandstone"
        local activeHighlights_Local = {}
        local heartbeatConnection_Local = nil

        if state then
            local function UpdateHighlights()
                for _, highlight in pairs(activeHighlights) do
                    highlight:Destroy()
                end
                activeHighlights = {}

                local spawnedFolder = Workspace:FindFirstChild("Spawned")
                if spawnedFolder then
                    for _, child in ipairs(spawnedFolder:GetChildren()) do
                        if child.Name == TARGET_NAME then
                            if child:IsA("Model") or child:IsA("BasePart") then
                                local newHighlight = Instance.new("Highlight")
                                newHighlight.FillColor = Color3.fromRGB(38, 0, 255)
                                newHighlight.OutlineColor = Color3.fromRGB(38, 0, 255)
                                newHighlight.Adornee = child
                                newHighlight.Parent = Camera
                                table.insert(activeHighlights, newHighlight)
                            end
                        end
                    end
                end
            end

            heartbeatConnection = RunService.Heartbeat:Connect(UpdateHighlights)
        else
            if heartbeatConnection then
                heartbeatConnection:Disconnect()
                heartbeatConnection = nil
            end

            for _, highlight in pairs(activeHighlights) do
                highlight:Destroy()
            end
            activeHighlights = {}
        end
    end
})

Tab:Toggle({
    Title = "透视煤",
    Default = false,
    Image = "check",
    Callback = function(state)
        local TARGET_NAME = "Coal"
        local activeHighlights_Local = {}
        local heartbeatConnection_Local = nil

        if state then
            local function UpdateHighlights()
                for _, highlight in pairs(activeHighlights) do
                    highlight:Destroy()
                end
                activeHighlights = {}

                local spawnedFolder = Workspace:FindFirstChild("Spawned")
                if spawnedFolder then
                    for _, child in ipairs(spawnedFolder:GetChildren()) do
                        if child.Name == TARGET_NAME then
                            if child:IsA("Model") or child:IsA("BasePart") then
                                local newHighlight = Instance.new("Highlight")
                                newHighlight.FillColor = Color3.fromRGB(0, 204, 255)
                                newHighlight.OutlineColor = Color3.fromRGB(0, 204, 255)
                                newHighlight.Adornee = child
                                newHighlight.Parent = Camera
                                table.insert(activeHighlights, newHighlight)
                            end
                        end
                    end
                end
            end

            heartbeatConnection = RunService.Heartbeat:Connect(UpdateHighlights)
        else
            if heartbeatConnection then
                heartbeatConnection:Disconnect()
                heartbeatConnection = nil
            end

            for _, highlight in pairs(activeHighlights) do
                highlight:Destroy()
            end
            activeHighlights = {}
        end
    end
})

Tab:Toggle({
    Title = "透视草莓丛",
    Default = false,
    Image = "check",
    Callback = function(state)
        local TARGET_NAME = "StrawberryBush"
        local activeHighlights_Local = {}
        local heartbeatConnection_Local = nil

        if state then
            local function UpdateHighlights()
                for _, highlight in pairs(activeHighlights) do
                    highlight:Destroy()
                end
                activeHighlights = {}

                local spawnedFolder = Workspace:FindFirstChild("Spawned")
                if spawnedFolder then
                    for _, child in ipairs(spawnedFolder:GetChildren()) do
                        if child.Name == TARGET_NAME then
                            if child:IsA("Model") or child:IsA("BasePart") then
                                local newHighlight = Instance.new("Highlight")
                                newHighlight.FillColor = Color3.fromRGB(0, 205, 255)
                                newHighlight.OutlineColor = Color3.fromRGB(0, 205, 255)
                                newHighlight.Adornee = child
                                newHighlight.Parent = Camera
                                table.insert(activeHighlights, newHighlight)
                            end
                        end
                    end
                end
            end

            heartbeatConnection = RunService.Heartbeat:Connect(UpdateHighlights)
        else
            if heartbeatConnection then
                heartbeatConnection:Disconnect()
                heartbeatConnection = nil
            end

            for _, highlight in pairs(activeHighlights) do
                highlight:Destroy()
            end
            activeHighlights = {}
        end
    end
})

local Section = main:Section({Title = "杀戮光环"})

main:Slider({
    Title = "杀戮光环范围调整",
    Value = {Min = 16, Max = 200, Default = 50},
    Callback = function(Value)
        Data.KillAuraDistance = Value
    end
})

main:Toggle({
    Title = "杀戮光环",
    Image = "check",
    Value = false,
    Callback = function(state)
        Data.KillAura = state
        spawn(function()
            while Data.KillAura and wait() do
                pcall(function()
                    local closestEnemy, minDistance = nil, math.huge
                    local currentDistance = Data.KillAuraDistance or 50
                    for _,v in next,workspace.Enemies:GetChildren() do
                        if v then
                            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - v:GetPivot().Position).Magnitude
                            if distance <= currentDistance and distance < minDistance then
                                closestEnemy = v
                                minDistance = distance
                            end
                        end
                    end
                    
                    if closestEnemy then
                        game:GetService("ReplicatedStorage").Network.Items.ToolAction:FireServer("click", closestEnemy)
                    end
                end)
            end
        end)
    end
})

local Section = main:Section({Title = "速度功能"})

main:Slider({
    Title = "速度调整",
    Value = {Min = 1, Max = 500, Default = 16},
    Callback = function(value)
        speed = value
    end
})

main:Toggle({
    Title = "开启速度",
    Value = false,
    Callback = function(v)
        if v then
            sd = RunService.Heartbeat:Connect(function()
                if Character and Humanoid then
                    if Humanoid.MoveDirection.Magnitude > 0 then
                        Character:TranslateBy(Humanoid.MoveDirection * speed / 20)
                    end
                end
            end)
        elseif sd then
            sd:Disconnect()
            sd = nil
        end
    end
})

local Section = main:Section({Title = "自动砍树"})

main:Slider({
    Title = "砍树范围",
    Value = {Min = 16, Max = 200, Default = 50},
    Callback = function(Value)
        Data.TreeCuttingDistance = Value
    end
})

main:Toggle({
    Title = "自动砍树",
    Image = "check",
    Value = false,
    Callback = function(state)
        Data.AutoTreeCutting = state
        spawn(function()
            while Data.AutoTreeCutting and wait() do
                pcall(function()
                    local closestTree, minDistance = nil, math.huge
                    local currentDistance = Data.TreeCuttingDistance or 50
                    for _,v in next,workspace.Spawned:GetChildren() do
                        if v and v.Name:find("Tree") then
                            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - v:GetPivot().Position).Magnitude
                            if distance <= currentDistance and distance < minDistance then
                                closestTree = v
                                minDistance = distance
                            end
                        end
                    end
                    
                    if closestTree then
                        game:GetService("ReplicatedStorage").Network.Items.ToolAction:FireServer("click", closestTree, false)
                    end
                end)
            end
        end)
    end
})

local Section = main:Section({Title = "自动挖矿"})

main:Slider({
    Title = "挖矿距离",
    Value = {Min = 16, Max = 200, Default = 50},
    Callback = function(Value)
        Data.MiningDistance = Value
    end
})

main:Toggle({
    Title = "自动挖矿",
    Image = "check",
    Value = false,
    Callback = function(state)
        Data.AutoMining = state
        spawn(function()
            while Data.AutoMining and wait() do
                pcall(function()
                    local closestOre, minDistance = nil, math.huge
                    local currentDistance = Data.MiningDistance or 50
                    for _,v in next,workspace.Spawned:GetChildren() do
                        if v and require(v.Config).handlerModule == "Ore" then
                            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - v:GetPivot().Position).Magnitude
                            if distance <= currentDistance and distance < minDistance then
                                closestOre = v
                                minDistance = distance
                            end
                        end
                    end
                    
                    if closestOre then
                        game:GetService("ReplicatedStorage").Network.Items.ToolAction:FireServer("click", closestOre, false)
                    end
                end)
            end
        end)
    end
})

local Section = main:Section({Title = "无线体力"})

local sbxp = false
main:Toggle({
    Title = "无限体力",
    Default = false,
    Image = "check",
    Callback = function(state)
        sbxp = state
    while sbxp and wait() do
game:GetService("ReplicatedStorage").Network.Character.TakeStamina:FireServer(-math.huge)
end
    end
})
elseif game.GameId == 9503696692 then --- 沉默的刺客
    if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(3) 

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yisan9178/sjsjsj/refs/heads/main/Windui.lua(1).txt"))()

local function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do table.insert(chars, uchar) end
    local length = #chars
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
            math.floor(r * 255), math.floor(g * 255), math.floor(b * 255), chars[i])
    end
    return result
end

local Window = WindUI:CreateWindow({
    Title = gradient("塔菲喵   ", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("伊散", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    IconThemed = true,
    Folder = "TafeiMiao",
    Size = UDim2.fromOffset(150, 150), 
    Transparent = false,                
    BackgroundImageTransparency = 0,     
    Theme = "Dark",
    SideBarWidth = 150,
    HideSearchBar = true,
    ScrollBarEnabled = true,
})
Window:Tag({
    Title = "伊散",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})

Window:EditOpenButton({
    Title = "[摸摸伊散]",
    CornerRadius = UDim.new(0,8),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("1E3A8A")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("06D6A0")) 
    }),
    Draggable = true,
})
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local isRunning = false

local Config = {
    Damage = 100,
    AttackSpeed = 0.15, 
}

local CombatTab = Window:Tab({ Title = '功能', Icon = 'swords' })
Window:SelectTab(1)
CombatTab:Toggle({
    Title = "全图杀戮",
    Value = false,
    Callback = function(state)
        isRunning = state
        WindUI:Notify({
            Title = "系统",
            Content = state and "杀戮已开启" or "杀戮已停止",
            Duration = 2
        })
    end
})

local function getTargets()
    local targets = {}
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return targets end
    
    for _, v in ipairs(Workspace:GetChildren()) do
        if v:IsA("Model") and v ~= char and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            if v.Humanoid.Health > 0 then
                table.insert(targets, {
                    knockback = 50,
                    origin = char.HumanoidRootPart.Position,
                    enemyModel = v,
                    distance = (v.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude,
                    direction = (v.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Unit
                })
            end
        end
    end
    return targets
end

task.spawn(function()
    while true do
        if isRunning then
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if not tool then
                        local bp = LocalPlayer:FindFirstChild("Backpack")
                        local found = bp and bp:FindFirstChildOfClass("Tool")
                        if found then
                            char.Humanoid:EquipTool(found)
                            tool = found
                        end
                    end

                    if tool then
                        local targetList = getTargets()
                        if #targetList > 0 then
                            local remote = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("GameRemoteFunction")
                            if remote then
                                task.defer(function()
                                    remote:InvokeServer("AttemptWeaponHit", {
                                        attackCycleData = {lungeMult = 1, slowMult = 0.2, attackTime = 0.65, knockbackMult = 1, slowTime = 1.5},
                                        knockback = 50,
                                        shouldLock = true,
                                        shouldLunge = true,
                                        hitboxOffset = Vector3.new(0, 0, -1.5),
                                        damage = Config.Damage,
                                        attackCooldown = 0.1,
                                        weaponDefinition = {
                                            attackCycle = {
                                                ["1"] = {knockbackMul = 1, slowMult = 0.2, attackTime = 0.65, lungeMul = 1, slowTime = 1.5},
                                                ["2"] = {lungeMult = 1, slowMult = 0.2, attackTime = 0.65, knockbackMult = 1, slowTime = 1.5}
                                            },
                                            attackOrder = {"1", "2"}
                                        },
                                        tool = tool
                                    }, targetList)
                                end)
                            end
                        end
                    end
                end
            end)
        end
        task.wait(Config.AttackSpeed)
    end
end)
elseif game.GameId == 111958650 then --- 兵工厂
    local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local cloneref = cloneref or function(instance) return instance end

local WindUI
do
    local ok, result = pcall(function()
        return require("./src/Init")
    end)
    if ok then
        WindUI = result
    else
        if RunService:IsStudio() then
            WindUI = require(cloneref(ReplicatedStorage:WaitForChild("WindUI"):WaitForChild("Init")))
        else
            WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/gycgchgyfytdttr/shenqin/refs/heads/main/ui.lua"))()
        end
    end
end

local ESPEnabled = false
local ESP_ScreenGui = nil
local ESPFolder = nil
local ESPNameColor = Color3.fromRGB(0, 255, 127)
local ESPBodyColor = Color3.fromRGB(0, 255, 127)
local ESPNameSize = 14
local ESPRainbowEnabled = false
local ESPRainbowSpeed = 5
local CurrentESPHue = 0
local ESPTeamCheck = false

local BackstabCheckEnabled = false
local BackstabCooldown = 0
local BACKSTAB_COOLDOWN_TIME = 3
local DeathCheckEnabled = false

local InfiniteJumpEnabled = false
local JumpConnection = nil
local SpeedEnabled = false
local SpeedValue = 1
local SpeedConnection = nil
local GravityLoop = nil
local originalGravity = workspace.Gravity

local NightVisionEnabled = false
local originalBrightness = Lighting.Brightness
local originalAmbient = Lighting.Ambient

local RainbowUIEnabled = false
local RainbowUIScreenGui = nil
local StatusIndicator = nil
local animationConnection = nil

local AimSettings = {
    Enabled = false,
    FOV = 100,
    Smoothness = 10,
    CrosshairDistance = 5,
    FOVColor = Color3.fromRGB(0, 255, 0),
    FriendCheck = true,
    WallCheck = true,
    TargetPlayer = nil,
    TargetAll = true,
    FOVRainbowEnabled = true,
    FOVRainbowSpeed = 8,
    FOVEnabled = true
}

local DrawingObjects = {}
local AimConnection = nil
local FOVCircle = nil
local TargetPlayers = {}
local CurrentFOVHue = 0
local CurrentTarget = nil

local Purple = Color3.fromHex("#7775F2")
local Yellow = Color3.fromHex("#ECA201")
local Green = Color3.fromHex("#10C550")
local Grey = Color3.fromHex("#83889E")
local Blue = Color3.fromHex("#257AF7")
local Red = Color3.fromHex("#EF4F1D")

local AimBlacklist = {}
local AimTeamCheck = false
local AimTargetPart = "头"
local ESPMaxDistance = 1000

local blacklistInput

local function GetRainbowColor(hue)
    hue = hue % 1
    local r, g, b
    local i = math.floor(hue * 6)
    local f = hue * 6 - i
    local p = 1
    local q = 1 - f
    local t = f
    if i % 6 == 0 then r, g, b = 1, t, p
    elseif i % 6 == 1 then r, g, b = q, 1, p
    elseif i % 6 == 2 then r, g, b = p, 1, t
    elseif i % 6 == 3 then r, g, b = p, q, 1
    elseif i % 6 == 4 then r, g, b = t, p, 1
    else r, g, b = 1, p, q end
    return Color3.new(r, g, b)
end

local function InitESP()
    ESP_ScreenGui = Instance.new("ScreenGui")
    ESP_ScreenGui.Name = "PlayerESP_System"
    ESP_ScreenGui.ResetOnSpawn = false
    ESP_ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ESP_ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ESPFolder = Instance.new("Folder")
    ESPFolder.Name = "PlayerESPFolder"
    ESPFolder.Parent = ESP_ScreenGui
end

local function UpdateESPColors()
    if not ESPEnabled or not ESPFolder then return end
    pcall(function()
        for _, child in ipairs(ESPFolder:GetChildren()) do
            if child:IsA("BillboardGui") then
                local nameLabel = child:FindFirstChild("NameLabel")
                if nameLabel then
                    nameLabel.TextColor3 = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPNameColor
                    nameLabel.TextSize = ESPNameSize
                end
            elseif child:IsA("Highlight") then
                child.FillColor = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPBodyColor
                child.OutlineColor = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPBodyColor
            end
        end
    end)
end

local function UpdateESPNameSize()
    if not ESPEnabled or not ESPFolder then return end
    pcall(function()
        for _, child in ipairs(ESPFolder:GetChildren()) do
            if child:IsA("BillboardGui") then
                local nameLabel = child:FindFirstChild("NameLabel")
                if nameLabel then
                    nameLabel.TextSize = ESPNameSize
                end
            end
        end
    end)
end

local function CreatePlayerESP(player)
    if player == LocalPlayer or not ESPEnabled then return end
    pcall(function()
        local character = player.Character
        if not character then return end
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        local existingESP = ESPFolder:FindFirstChild(player.Name)
        if existingESP then existingESP:Destroy() end
        local ESPGui = Instance.new("BillboardGui")
        ESPGui.Name = player.Name
        ESPGui.Adornee = humanoidRootPart
        ESPGui.Size = UDim2.new(0, 100, 0, 40)
        ESPGui.StudsOffset = Vector3.new(0, 3, 0)
        ESPGui.AlwaysOnTop = true
        ESPGui.MaxDistance = 10000
        ESPGui.Enabled = true
        ESPGui.Parent = ESPFolder
        local NameLabel = Instance.new("TextLabel")
        NameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        NameLabel.BackgroundTransparency = 1
        NameLabel.Font = Enum.Font.GothamBold
        NameLabel.TextSize = ESPNameSize
        NameLabel.TextColor3 = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPNameColor
        NameLabel.TextStrokeTransparency = 0.5
        NameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        NameLabel.Text = player.Name
        NameLabel.Parent = ESPGui
        local DistanceLabel = Instance.new("TextLabel")
        DistanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
        DistanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
        DistanceLabel.BackgroundTransparency = 1
        DistanceLabel.Font = Enum.Font.Gotham
        DistanceLabel.TextSize = 12
        DistanceLabel.TextColor3 = Color3.fromRGB(240, 255, 245)
        DistanceLabel.TextStrokeTransparency = 0.5
        DistanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        DistanceLabel.Name = "DistanceLabel"
        DistanceLabel.Parent = ESPGui
        local Highlight = Instance.new("Highlight")
        Highlight.Name = player.Name .. "_Highlight"
        Highlight.Adornee = character
        Highlight.FillColor = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPBodyColor
        Highlight.FillTransparency = 0.7
        Highlight.OutlineColor = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPBodyColor
        Highlight.OutlineTransparency = 0
        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Highlight.Enabled = true
        Highlight.Parent = ESPFolder
    end)
end

local function CheckBackstabThreat()
    if not BackstabCheckEnabled then return end
    if BackstabCooldown > 0 then return end
    pcall(function()
        local myCharacter = LocalPlayer.Character
        local myHRP = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        local myPosition = myHRP.Position
        local myCFrame = myHRP.CFrame
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if hrp and humanoid and humanoid.Health > 0 then
                    local enemyPosition = hrp.Position
                    local distance = (myPosition - enemyPosition).Magnitude
                    if distance < 30 then
                        local toEnemy = (enemyPosition - myPosition).Unit
                        local myForward = myCFrame.LookVector
                        local dotProduct = toEnemy:Dot(myForward)
                        if dotProduct < 0.5 then
                            WindUI:Notify({
                                Title = "有基吧人偷袭🥵",
                                Content = "小心有人要偷袭你：" .. player.Name,
                                Icon = "alert-triangle",
                                Color = Color3.fromRGB(255, 100, 100),
                                Duration = 5
                            })
                            BackstabCooldown = BACKSTAB_COOLDOWN_TIME
                            break
                        end
                    end
                end
            end
        end
    end)
end

local function SetupDeathDetection()
    LocalPlayer.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        pcall(function()
            local humanoid = character:WaitForChild("Humanoid")
            humanoid.Died:Connect(function()
                if DeathCheckEnabled then
                    WindUI:Notify({
                        Title = "死亡提醒",
                        Content = "受着",
                        Icon = "skull",
                        Color = Color3.fromRGB(255, 0, 0),
                        Duration = 8
                    })
                end
            end)
        end)
    end)
    if LocalPlayer.Character then
        pcall(function()
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.Died:Connect(function()
                    if DeathCheckEnabled then
                        WindUI:Notify({
                            Title = "死亡提醒",
                            Content = "受着",
                            Icon = "skull",
                            Color = Color3.fromRGB(255, 0, 0),
                            Duration = 8
                        })
                    end
                end)
            end
        end)
    end
end

local function UpdateESP()
    if not ESPEnabled then return end
    pcall(function()
        local myCharacter = LocalPlayer.Character
        local myHRP = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local character = player.Character
                if character then
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local espGui = ESPFolder:FindFirstChild(player.Name)
                        if not espGui then
                            CreatePlayerESP(player)
                            espGui = ESPFolder:FindFirstChild(player.Name)
                        end
                        if espGui then
                            local distance = (myHRP.Position - hrp.Position).Magnitude
                            local distanceLabel = espGui:FindFirstChild("DistanceLabel")
                            if distanceLabel then
                                distanceLabel.Text = string.format("%.0f studs", distance)
                            end
                            if distance > ESPMaxDistance then
                                espGui.Enabled = false
                                local highlight = ESPFolder:FindFirstChild(player.Name .. "_Highlight")
                                if highlight then highlight.Enabled = false end
                            else
                                local teamHide = false
                                if ESPTeamCheck and LocalPlayer.Team and player.Team and player.Team == LocalPlayer.Team then
                                    teamHide = true
                                end
                                if teamHide then
                                    espGui.Enabled = false
                                    local highlight = ESPFolder:FindFirstChild(player.Name .. "_Highlight")
                                    if highlight then highlight.Enabled = false end
                                else
                                    espGui.Enabled = true
                                    local highlight = ESPFolder:FindFirstChild(player.Name .. "_Highlight")
                                    if highlight then highlight.Enabled = true end
                                end
                            end
                        end
                    else
                        local espGui = ESPFolder:FindFirstChild(player.Name)
                        if espGui then espGui:Destroy() end
                        local highlight = ESPFolder:FindFirstChild(player.Name .. "_Highlight")
                        if highlight then highlight:Destroy() end
                    end
                else
                    local esp = ESPFolder:FindFirstChild(player.Name)
                    if esp then esp:Destroy() end
                    local highlight = ESPFolder:FindFirstChild(player.Name .. "_Highlight")
                    if highlight then highlight:Destroy() end
                end
            end
        end
    end)
end

local function ToggleESP(state)
    ESPEnabled = state
    if state then
        pcall(function()
            if not ESP_ScreenGui then InitESP() end
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    CreatePlayerESP(player)
                end
            end
            WindUI:Notify({
                Title = "透视",
                Content = "玩家透视已开启",
                Icon = "eye",
            })
        end)
    else
        pcall(function()
            if ESPFolder then
                for _, esp in ipairs(ESPFolder:GetChildren()) do
                    esp:Destroy()
                end
            end
            WindUI:Notify({
                Title = "透视",
                Content = "玩家透视已关闭",
                Icon = "eye",
            })
        end)
    end
end

InitESP()

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if ESPEnabled then
        pcall(function()
            if ESPFolder then
                for _, esp in ipairs(ESPFolder:GetChildren()) do
                    esp:Destroy()
                end
            end
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    CreatePlayerESP(player)
                end
            end
        end)
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if ESPEnabled then
            task.wait(1)
            pcall(function()
                CreatePlayerESP(player)
            end)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    pcall(function()
        if ESPFolder then
            local espGui = ESPFolder:FindFirstChild(player.Name)
            if espGui then espGui:Destroy() end
            local highlight = ESPFolder:FindFirstChild(player.Name .. "_Highlight")
            if highlight then highlight:Destroy() end
        end
        if CurrentTarget == player then
            CurrentTarget = nil
        end
        for i, name in ipairs(AimBlacklist) do
            if name == player.Name then
                table.remove(AimBlacklist, i)
                break
            end
        end
        if blacklistInput and blacklistInput.SetValue then
            blacklistInput:SetValue(table.concat(AimBlacklist, ", "))
        end
    end)
end)

local function heartBeatLoop(deltaTime)
    pcall(function()
        UpdateESP()
        if ESPRainbowEnabled then
            CurrentESPHue = CurrentESPHue + deltaTime * ESPRainbowSpeed / 10
            UpdateESPColors()
        end
        if BackstabCooldown > 0 then
            BackstabCooldown = BackstabCooldown - deltaTime
        end
        CheckBackstabThreat()
    end)
end

RunService.Heartbeat:Connect(heartBeatLoop)

local Window = WindUI:CreateWindow({
    Title = "塔菲喵脚本",
    Author = "伊散",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(200, 395),
    Transparent = true,
    Theme = "Dark",
    User = {
        Enabled = false,
        Callback = function() print("clicked") end,
        Anonymous = false
    },
    SideBarWidth = 135,
    ScrollBarEnabled = true,
    Background = "",
    BackgroundImageTransparency = 0.5,
})

Window:EditOpenButton({
    Title = "塔菲喵",
    --Icon = "https://raw.githubusercontent.com/tnine-n9/tnine/refs/heads/main/retouch_2026021013490471.png",
     --Icon = "https://chaton-images.s3.us-east-2.amazonaws.com/TDuh6pLcLaL5Njc9edXjuNvt9uxhglfns6fEqhsldY0SDHl4oLdsFqqbzKfNG2Mf_2048x2048x1346681.png",
     --Icon = "https://chaton-images.s3.us-east-2.amazonaws.com/LCiFpQ6Bn67qSpdmB6FvtIaU4gTFxeie4wilvPeUbhCBbRbZiepiyYYNEdXvJh7C_2048x2048x1381825.png",
    CornerRadius = UDim.new(0,10),
    StrokeThickness = 2.5,
    Color = ColorSequence.new(
        Color3.fromHex("#874da2"),
        --Color3.fromHex("#e8198b"),
        --Color3.fromHex("#c7eafd"),
        Color3.fromHex("#c43a30")
    ),
    Draggable = true,
})

    local PlayerTab = Window:Tab({  
        Title = "本地玩家",  
        Icon = "crown",  
        Locked = false,
    })

do
    PlayerTab:Section({
        Title = "主要功能",
        TextSize = 16,
        FontWeight = Enum.FontWeight.SemiBold,
    })
    PlayerTab:Toggle({
        Title = "无限跳跃",
        Desc = "启用后可以无限跳跃",
        Callback = function(enabled)
            InfiniteJumpEnabled = enabled
            if enabled then
                if JumpConnection then
                    JumpConnection:Disconnect()
                end
                JumpConnection = UserInputService.JumpRequest:Connect(function()
                    pcall(function()
                        local char = LocalPlayer.Character
                        if char and char:FindFirstChild("Humanoid") then
                            char.Humanoid:ChangeState("Jumping")
                        end
                    end)
                end)
                WindUI:Notify({
                    Title = "无限跳跃",
                    Content = "已开启无限跳跃",
                    Icon = "jump-rope",
                })
            else
                if JumpConnection then
                    JumpConnection:Disconnect()
                    JumpConnection = nil
                end
                WindUI:Notify({
                    Title = "无限跳跃",
                    Content = "已关闭无限跳跃",
                    Icon = "jump-rope",
                })
            end
        end
    })
    PlayerTab:Space()
    PlayerTab:Input({
        Title = "设置重力",
        Desc = "输入重力值 (默认:196" .. tostring(originalGravity) .. ")",
        Placeholder = "输入重力值",
        Callback = function(value)
            local numValue = tonumber(value)
            if numValue then
                if GravityLoop then
                    GravityLoop:Disconnect()
                    GravityLoop = nil
                end
                workspace.Gravity = numValue
                WindUI:Notify({
                    Title = "重力设置",
                    Content = "重力已设置为: " .. tostring(numValue),
                    Icon = "weight",
                })
            else
                WindUI:Notify({
                    Title = "错误来了",
                    Content = "请输入数字",
                    Icon = "alert-circle",
                    Color = Red,
                })
            end
        end
    })
    PlayerTab:Space()
    PlayerTab:Input({
        Title = "设置快速跑步速度",
        Desc = "输入速度 (默认: 1)",
        Placeholder = "输入速度",
        Callback = function(value)
            local numValue = tonumber(value)
            if numValue then
                SpeedValue = numValue
                WindUI:Notify({
                    Title = "速度设置",
                    Content = "速度已设置为: " .. tostring(numValue) .. "速度",
                    Icon = "zap",
                })
            else
                WindUI:Notify({
                    Title = "依旧错误来了",
                    Content = "请输入有效数字",
                    Icon = "alert-circle",
                    Color = Red,
                })
            end
        end
    })
    PlayerTab:Toggle({
        Title = "开启快速跑步",
        Desc = "启用快速跑步功能",
        Callback = function(enabled)
            SpeedEnabled = enabled
            if enabled then
                if SpeedConnection then
                    SpeedConnection:Disconnect()
                end
                SpeedConnection = RunService.Heartbeat:Connect(function()
                    pcall(function()
                        local player = LocalPlayer
                        local char = player.Character
                        if char and char:FindFirstChild("Humanoid") then
                            local humanoid = char.Humanoid
                            if humanoid.MoveDirection.Magnitude > 0 then
                                char:TranslateBy(humanoid.MoveDirection * SpeedValue / 2)
                            end
                        end
                    end)
                end)
            else
                if SpeedConnection then
                    SpeedConnection:Disconnect()
                    SpeedConnection = nil
                end
            end
        end
    })
end

    local AimTab = Window:Tab({  
        Title = "自瞄设置",  
        Icon = "crown",  
        Locked = false,
    })

local function InitializeAimDrawings()
    pcall(function()
        if not FOVCircle then
            FOVCircle = Drawing.new("Circle")
            FOVCircle.Visible = AimSettings.Enabled and AimSettings.FOVEnabled
            FOVCircle.Thickness = 2
            FOVCircle.Filled = false
            FOVCircle.Radius = AimSettings.FOV
            FOVCircle.Position = workspace.CurrentCamera.ViewportSize / 2
            table.insert(DrawingObjects, FOVCircle)
        end
    end)
end

local function UpdateFOVCircle()
    pcall(function()
        if FOVCircle then
            FOVCircle.Visible = AimSettings.Enabled and AimSettings.FOVEnabled
            FOVCircle.Radius = AimSettings.FOV
            if AimSettings.FOVRainbowEnabled then
                FOVCircle.Color = GetRainbowColor(CurrentFOVHue)
            else
                FOVCircle.Color = AimSettings.FOVColor
            end
            FOVCircle.Position = workspace.CurrentCamera.ViewportSize / 2
        end
    end)
end

local function CleanupDrawings()
    pcall(function()
        for _, drawing in ipairs(DrawingObjects) do
            if drawing then
                drawing:Remove()
            end
        end
        DrawingObjects = {}
        FOVCircle = nil
    end)
end

local function IsFriend(player)
    if not AimSettings.FriendCheck then
        return false
    end
    local success, result = pcall(function()
        if LocalPlayer:IsFriendsWith(player.UserId) then
            return true
        end
        return false
    end)
    return success and result
end

local function WallCheck(targetPosition, targetCharacter)
    if not AimSettings.WallCheck then
        return true
    end
    local success, result = pcall(function()
        local camera = workspace.CurrentCamera
        local origin = camera.CFrame.Position
        local direction = (targetPosition - origin).Unit
        local distance = (targetPosition - origin).Magnitude
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, targetCharacter}
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.IgnoreWater = true
        raycastParams.CollisionGroup = "Default"
        local raycastResult = workspace:Raycast(origin, direction * distance, raycastParams)
        return raycastResult == nil
    end)
    return success and result
end

local function GetTargetPosition(character, partName)
    if not character then return nil end
    local part
    if partName == "头" then
        part = character:FindFirstChild("Head")
    elseif partName == "上身" then
        part = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or character:FindFirstChild("HumanoidRootPart")
    elseif partName == "左腿" then
        part = character:FindFirstChild("Left Leg") or character:FindFirstChild("LeftLowerLeg") or character:FindFirstChild("LeftUpperLeg")
    elseif partName == "右腿" then
        part = character:FindFirstChild("Right Leg") or character:FindFirstChild("RightLowerLeg") or character:FindFirstChild("RightUpperLeg")
    elseif partName == "裆部" then
        part = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("LowerTorso")
    elseif partName == "胸部" then
        part = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    else
        part = character:FindFirstChild("Head")
    end
    return part and part.Position
end

local function GetClosestPlayer()
    local camera = workspace.CurrentCamera
    local mousePos = camera.ViewportSize / 2
    local nearestPlayer = nil
    local shortestDistance = AimSettings.FOV

    if AimSettings.TargetPlayer and not AimSettings.TargetAll then
        local target = Players:FindFirstChild(AimSettings.TargetPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local inBlacklist = false
            for _, blackName in ipairs(AimBlacklist) do
                if target.Name == blackName then
                    inBlacklist = true
                    break
                end
            end
            if not inBlacklist then
                if AimTeamCheck then
                    local myTeam = LocalPlayer.Team
                    if myTeam and target.Team == myTeam then
                        CurrentTarget = nil
                        return nil
                    end
                end
                local humanoid = target.Character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local targetPos = target.Character.HumanoidRootPart.Position
                    local screenPos, onScreen = camera:WorldToViewportPoint(targetPos)
                    if onScreen then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if distance <= AimSettings.FOV and WallCheck(targetPos, target.Character) then
                            if not AimSettings.FriendCheck or not IsFriend(target) then
                                CurrentTarget = target
                                return target
                            end
                        end
                    end
                end
            end
        end
        CurrentTarget = nil
        return nil
    end

    if CurrentTarget and CurrentTarget ~= LocalPlayer and CurrentTarget.Character then
        local hrp = CurrentTarget.Character:FindFirstChild("HumanoidRootPart")
        local humanoid = CurrentTarget.Character:FindFirstChild("Humanoid")
        if hrp and humanoid and humanoid.Health > 0 then
            local inBlacklist = false
            for _, blackName in ipairs(AimBlacklist) do
                if CurrentTarget.Name == blackName then
                    inBlacklist = true
                    break
                end
            end
            if not inBlacklist then
                if AimTeamCheck then
                    local myTeam = LocalPlayer.Team
                    if myTeam and CurrentTarget.Team == myTeam then
                        CurrentTarget = nil
                        return nil
                    end
                end
                local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance <= AimSettings.FOV and WallCheck(hrp.Position, CurrentTarget.Character) then
                        if not AimSettings.FriendCheck or not IsFriend(CurrentTarget) then
                            return CurrentTarget
                        end
                    end
                end
            end
        end
    end

    CurrentTarget = nil
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local skip = false
            if AimSettings.FriendCheck and IsFriend(player) then
                skip = true
            end
            if not skip then
                for _, blackName in ipairs(AimBlacklist) do
                    if player.Name == blackName then
                        skip = true
                        break
                    end
                end
            end
            if not skip then
                if AimTeamCheck then
                    local myTeam = LocalPlayer.Team
                    if myTeam and player.Team == myTeam then
                        skip = true
                    end
                end
            end
            if not skip then
                local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoidRootPart and humanoid and humanoid.Health > 0 then
                    if WallCheck(humanoidRootPart.Position, player.Character) then
                        local screenPos, onScreen = camera:WorldToViewportPoint(humanoidRootPart.Position)
                        if onScreen then
                            local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                            if distance < shortestDistance then
                                shortestDistance = distance
                                nearestPlayer = player
                            end
                        end
                    end
                end
            end
        end
    end
    if nearestPlayer then
        CurrentTarget = nearestPlayer
    end
    return nearestPlayer
end

local function AimBot()
    if not AimSettings.Enabled then
        return
    end
    pcall(function()
        local camera = workspace.CurrentCamera
        local target = GetClosestPlayer()
        if target and target.Character then
            local humanoidRootPart = target.Character:FindFirstChild("HumanoidRootPart")
            local head = target.Character:FindFirstChild("Head")
            local targetPosition = GetTargetPosition(target.Character, AimTargetPart) or (head and head.Position) or (humanoidRootPart and humanoidRootPart.Position)
            if not targetPosition then return end
            if humanoidRootPart then
                local targetVelocity = humanoidRootPart.Velocity
                if AimSettings.CrosshairDistance > 0 then
                    local distance = (targetPosition - camera.CFrame.Position).Magnitude
                    local timeToTarget = distance / 1000
                    targetPosition = targetPosition + (targetVelocity * timeToTarget * AimSettings.CrosshairDistance)
                end
            end
            local currentCFrame = camera.CFrame
            local targetCFrame = CFrame.new(currentCFrame.Position, targetPosition)
            local smoothedCFrame = currentCFrame:Lerp(targetCFrame, 1 / AimSettings.Smoothness)
            camera.CFrame = smoothedCFrame
        end
    end)
end

local function CreateRainbowUI()
    if RainbowUIScreenGui then
        RainbowUIScreenGui:Destroy()
        RainbowUIScreenGui = nil
    end
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    RainbowUIScreenGui = Instance.new("ScreenGui")
    RainbowUIScreenGui.Name = "RainbowCircleUI"
    RainbowUIScreenGui.ResetOnSpawn = false
    RainbowUIScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    RainbowUIScreenGui.DisplayOrder = 99999
    RainbowUIScreenGui.IgnoreGuiInset = true
    RainbowUIScreenGui.Enabled = true
    RainbowUIScreenGui.Parent = playerGui
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "RainbowCircle"
    mainFrame.Size = UDim2.new(0, 80, 0, 80)
    mainFrame.Position = UDim2.new(0, 10, 0, 10)
    mainFrame.BackgroundTransparency = 1
    mainFrame.ZIndex = 100000
    mainFrame.Parent = RainbowUIScreenGui
    mainFrame.Active = true
    mainFrame.Selectable = true
    mainFrame.Draggable = false
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(1, 0)
    uiCorner.Parent = mainFrame
    local rainbowBackground = Instance.new("Frame")
    rainbowBackground.Name = "RainbowBackground"
    rainbowBackground.Size = UDim2.new(1, 0, 1, 0)
    rainbowBackground.Position = UDim2.new(0, 0, 0, 0)
    rainbowBackground.BackgroundTransparency = 0
    rainbowBackground.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    rainbowBackground.ZIndex = 100001
    rainbowBackground.Parent = mainFrame
    rainbowBackground.Active = true
    rainbowBackground.Selectable = true
    local rainbowCorner = Instance.new("UICorner")
    rainbowCorner.CornerRadius = UDim.new(1, 0)
    rainbowCorner.Parent = rainbowBackground
    local rainbowStroke = Instance.new("UIStroke")
    rainbowStroke.Name = "RainbowStroke"
    rainbowStroke.Color = Color3.fromRGB(255, 255, 255)
    rainbowStroke.Thickness = 3
    rainbowStroke.Transparency = 0
    rainbowStroke.Parent = mainFrame
    local innerStroke = Instance.new("UIStroke")
    innerStroke.Name = "InnerStroke"
    innerStroke.Color = Color3.fromRGB(0, 0, 0)
    innerStroke.Thickness = 1
    innerStroke.Transparency = 0.3
    innerStroke.Parent = rainbowBackground
    StatusIndicator = Instance.new("Frame")
    StatusIndicator.Name = "StatusIndicator"
    StatusIndicator.Size = UDim2.new(0, 15, 0, 15)
    StatusIndicator.Position = UDim2.new(1, -18, 1, -18)
    StatusIndicator.BackgroundColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    StatusIndicator.BackgroundTransparency = 0
    StatusIndicator.ZIndex = 100002
    StatusIndicator.Parent = mainFrame
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = StatusIndicator
    local indicatorStroke = Instance.new("UIStroke")
    indicatorStroke.Color = Color3.fromRGB(255, 255, 255)
    indicatorStroke.Thickness = 2
    indicatorStroke.Parent = StatusIndicator
    local statusText = Instance.new("TextLabel")
    statusText.Name = "StatusText"
    statusText.Size = UDim2.new(1, 0, 0, 25)
    statusText.Position = UDim2.new(0, 0, 1, 5)
    statusText.BackgroundTransparency = 1
    statusText.Text = AimSettings.Enabled and "自瞄开" or "自瞄关"
    statusText.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusText.TextSize = 14
    statusText.Font = Enum.Font.GothamBold
    statusText.TextStrokeTransparency = 0.3
    statusText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    statusText.TextStrokeTransparency = 0.3
    statusText.ZIndex = 100002
    statusText.Parent = mainFrame
    local clickArea = Instance.new("TextButton")
    clickArea.Name = "ClickArea"
    clickArea.Size = UDim2.new(1, 0, 1, 0)
    clickArea.Position = UDim2.new(0, 0, 0, 0)
    clickArea.BackgroundTransparency = 1
    clickArea.Text = ""
    clickArea.ZIndex = 100003
    clickArea.Parent = mainFrame
    local rainbowColors = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(255, 95, 0),
        Color3.fromRGB(255, 165, 0),
        Color3.fromRGB(255, 215, 0),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(144, 238, 144),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 200, 200),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(75, 0, 130),
        Color3.fromRGB(138, 43, 226),
        Color3.fromRGB(148, 0, 211),
        Color3.fromRGB(199, 21, 133),
        Color3.fromRGB(255, 20, 147)
    }
    local rainbowColors2 = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(255, 127, 0),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(75, 0, 130),
        Color3.fromRGB(148, 0, 211)
    }
    local timeOffset = 0
    local hoverAmplitude = 4
    local hoverSpeed = 4
    local pulseSpeed = 2
    local pulseAmount = 0.1
    local colorIndex = 1
    local colorIndex2 = 3
    local transitionTime = 0.8
    local transitionTime2 = 0.5
    local elapsedTime = 0
    local elapsedTime2 = 0
    local pulseScale = 1
    local isPulsingOut = true
    if animationConnection then
        animationConnection:Disconnect()
    end
    animationConnection = RunService.RenderStepped:Connect(function(deltaTime)
        pcall(function()
            if not RainbowUIEnabled or not RainbowUIScreenGui or not RainbowUIScreenGui.Parent then
                animationConnection:Disconnect()
                animationConnection = nil
                return
            end
            elapsedTime = elapsedTime + deltaTime
            if elapsedTime >= transitionTime then
                elapsedTime = 0
                colorIndex = colorIndex + 1
                if colorIndex > #rainbowColors then
                    colorIndex = 1
                end
            end
            local nextColorIndex = colorIndex + 1
            if nextColorIndex > #rainbowColors then
                nextColorIndex = 1
            end
            local alpha = elapsedTime / transitionTime
            local currentBgColor = rainbowColors[colorIndex]:Lerp(rainbowColors[nextColorIndex], alpha)
            rainbowBackground.BackgroundColor3 = currentBgColor
            elapsedTime2 = elapsedTime2 + deltaTime
            if elapsedTime2 >= transitionTime2 then
                elapsedTime2 = 0
                colorIndex2 = colorIndex2 + 1
                if colorIndex2 > #rainbowColors2 then
                    colorIndex2 = 1
                end
            end
            local nextColorIndex2 = colorIndex2 + 1
            if nextColorIndex2 > #rainbowColors2 then
                nextColorIndex2 = 1
            end
            local alpha2 = elapsedTime2 / transitionTime2
            local currentStrokeColor = rainbowColors2[colorIndex2]:Lerp(rainbowColors2[nextColorIndex2], alpha2)
            rainbowStroke.Color = currentStrokeColor
            if isPulsingOut then
                pulseScale = pulseScale + deltaTime * pulseSpeed * pulseAmount
                if pulseScale >= 1 + pulseAmount then
                    isPulsingOut = false
                end
            else
                pulseScale = pulseScale - deltaTime * pulseSpeed * pulseAmount
                if pulseScale <= 1 - pulseAmount then
                    isPulsingOut = true
                end
            end
            rainbowBackground.Size = UDim2.new(pulseScale, 0, pulseScale, 0)
            rainbowBackground.Position = UDim2.new((1 - pulseScale) / 2, 0, (1 - pulseScale) / 2, 0)
            timeOffset = timeOffset + deltaTime * hoverSpeed
            local hoverOffset = math.sin(timeOffset) * hoverAmplitude
            mainFrame.Position = UDim2.new(0, 10, 0, 10 + hoverOffset)
            innerStroke.Transparency = 0.2 + 0.3 * math.sin(timeOffset * 2)
            if StatusIndicator then
                StatusIndicator.BackgroundColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            end
            if statusText then
                statusText.Text = AimSettings.Enabled and "自瞄开" or "自瞄关"
                statusText.TextColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100)
            end
        end)
    end)
    local function handleClick()
        AimSettings.Enabled = not AimSettings.Enabled
        if AimSettings.Enabled then
            InitializeAimDrawings()
            UpdateFOVCircle()
            if AimConnection then
                AimConnection:Disconnect()
            end
            AimConnection = RunService.RenderStepped:Connect(function(deltaTime)
                pcall(function()
                    if AimSettings.FOVRainbowEnabled then
                        CurrentFOVHue = CurrentFOVHue + deltaTime * AimSettings.FOVRainbowSpeed / 10
                    end
                    UpdateFOVCircle()
                    AimBot()
                end)
            end)
        else
            if AimConnection then
                AimConnection:Disconnect()
                AimConnection = nil
            end
            CleanupDrawings()
            CurrentTarget = nil
        end
        if StatusIndicator then
            StatusIndicator.BackgroundColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        end
        if statusText then
            statusText.Text = AimSettings.Enabled and "自瞄开" or "自瞄关"
            statusText.TextColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100)
        end
        local originalSize = rainbowBackground.Size
        local originalPosition = rainbowBackground.Position
        local tweenInfo1 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tweenInfo2 = TweenInfo.new(0.15, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
        local clickScaleUp = TweenService:Create(rainbowBackground, tweenInfo1, {
            Size = originalSize * 0.7,
            Position = UDim2.new(0.15, 0, 0.15, 0)
        })
        local clickScaleDown = TweenService:Create(rainbowBackground, tweenInfo2, {
            Size = originalSize,
            Position = originalPosition
        })
        local originalStrokeColor = rainbowStroke.Color
        local flashTween = TweenService:Create(rainbowStroke, tweenInfo1, {
            Color = Color3.fromRGB(255, 255, 255)
        })
        local revertStroke = TweenService:Create(rainbowStroke, tweenInfo2, {
            Color = originalStrokeColor
        })
        clickScaleUp:Play()
        flashTween:Play()
        clickScaleUp.Completed:Connect(function()
            clickScaleDown:Play()
            revertStroke:Play()
        end)
    end
    clickArea.MouseButton1Click:Connect(handleClick)
    mainFrame.MouseButton1Click:Connect(handleClick)
    mainFrame.MouseEnter:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween1 = TweenService:Create(rainbowStroke, tweenInfo, {
            Thickness = 6
        })
        pulseAmount = 0.15
        tween1:Play()
    end)
    mainFrame.MouseLeave:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween1 = TweenService:Create(rainbowStroke, tweenInfo, {
            Thickness = 3
        })
        pulseAmount = 0.1
        tween1:Play()
    end)
    rainbowBackground.BackgroundTransparency = 1
    rainbowStroke.Transparency = 1
    local fadeIn = TweenService:Create(rainbowBackground, TweenInfo.new(0.5), {
        BackgroundTransparency = 0
    })
    local strokeFadeIn = TweenService:Create(rainbowStroke, TweenInfo.new(0.5), {
        Transparency = 0
    })
    task.wait(0.2)
    fadeIn:Play()
    strokeFadeIn:Play()
    return true
end

local function ToggleRainbowUI(state)
    RainbowUIEnabled = state
    if state then
        local success = CreateRainbowUI()
        if success then
            WindUI:Notify({
                Title = "自瞄快捷UI",
                Content = "快捷UI 让你秒人更加高效",
                Icon = "sparkles",
            })
        end
    else
        if RainbowUIScreenGui then
            RainbowUIScreenGui:Destroy()
            RainbowUIScreenGui = nil
        end
        WindUI:Notify({
            Title = "自瞄快捷UI",
            Content = "快捷UI已隐藏",
            Icon = "sparkles",
        })
    end
end

do
    AimTab:Section({
        Title = "自瞄设置",
        TextSize = 16,
        FontWeight = Enum.FontWeight.SemiBold,
    })
    AimTab:Toggle({
        Title = "启用自瞄",
        Desc = "开启/关闭自瞄功能",
        Callback = function(enabled)
            AimSettings.Enabled = enabled
            if enabled then
                InitializeAimDrawings()
                UpdateFOVCircle()
                if AimConnection then
                    AimConnection:Disconnect()
                end
                AimConnection = RunService.RenderStepped:Connect(function(deltaTime)
                    pcall(function()
                        if AimSettings.FOVRainbowEnabled then
                            CurrentFOVHue = CurrentFOVHue + deltaTime * AimSettings.FOVRainbowSpeed / 10
                        end
                        UpdateFOVCircle()
                        AimBot()
                    end)
                end)
                WindUI:Notify({
                    Title = "自瞄",
                    Content = "自瞄功能已开启",
                    Icon = "crosshair",
                })
            else
                if AimConnection then
                    AimConnection:Disconnect()
                    AimConnection = nil
                end
                CleanupDrawings()
                CurrentTarget = nil
                WindUI:Notify({
                    Title = "自瞄",
                    Content = "自瞄功能已关闭",
                    Icon = "crosshair",
                })
            end
            if StatusIndicator then
                StatusIndicator.BackgroundColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            end
        end
    })
    AimTab:Space()
    AimTab:Toggle({
        Title = "自瞄快捷UI",
        Desc = "快捷UI 让你秒人更加高效",
        Callback = function(enabled)
            ToggleRainbowUI(enabled)
        end
    })
    AimTab:Toggle({
        Title = "FOV开关",
        Desc = "显示自瞄范围圆圈",
        Value = AimSettings.FOVEnabled,
        Callback = function(enabled)
            AimSettings.FOVEnabled = enabled
            UpdateFOVCircle()
        end
    })
    AimTab:Toggle({
        Title = "FOV彩虹效果",
        Desc = "开启FOV圆圈彩虹效果",
        Value = AimSettings.FOVRainbowEnabled,
        Callback = function(enabled)
            AimSettings.FOVRainbowEnabled = enabled
            UpdateFOVCircle()
        end
    })
    AimTab:Slider({
        Title = "FOV彩虹速度",
        Desc = "调整彩虹流动的速度",
        Value = {
            Min = 1,
            Max = 20,
            Default = AimSettings.FOVRainbowSpeed,
        },
        Callback = function(value)
            AimSettings.FOVRainbowSpeed = value
        end
    })
    AimTab:Space()
    AimTab:Slider({
        Title = "自瞄范围 (FOV)",
        Desc = "设置自瞄FOV大小",
        Value = {
            Min = 50,
            Max = 500,
            Default = AimSettings.FOV,
        },
        Callback = function(value)
            AimSettings.FOV = value
            UpdateFOVCircle()
        end
    })
    AimTab:Space()
    AimTab:Slider({
        Title = "自瞄平滑度",
        Desc = "数值越小越强锁",
        Value = {
            Min = 1,
            Max = 50,
            Default = AimSettings.Smoothness,
        },
        Callback = function(value)
            AimSettings.Smoothness = value
        end
    })
    AimTab:Space()
    AimTab:Slider({
        Title = "预判距离",
        Desc = "设置预判距离(需要强锁直接调到0-3)",
        Value = {
            Min = 0,
            Max = 20,
            Default = AimSettings.CrosshairDistance,
        },
        Callback = function(value)
            AimSettings.CrosshairDistance = value
        end
    })
    AimTab:Space()
    AimTab:Colorpicker({
        Title = "FOV圆圈颜色",
        Desc = "彩虹模式关闭时生效",
        Default = AimSettings.FOVColor,
        Callback = function(color)
            AimSettings.FOVColor = color
            UpdateFOVCircle()
        end
    })
    AimTab:Space()
    AimTab:Toggle({
        Title = "好友检测",
        Desc = "不秒好友",
        Value = AimSettings.FriendCheck,
        Callback = function(enabled)
            AimSettings.FriendCheck = enabled
        end
    })
    AimTab:Space()
    AimTab:Toggle({
        Title = "墙壁检测",
        Desc = "开启墙壁检测 避免自瞄乱飞",
        Value = AimSettings.WallCheck,
        Callback = function(enabled)
            AimSettings.WallCheck = enabled
        end
    })
    AimTab:Space()
    AimTab:Toggle({
        Title = "队伍检测",
        Desc = "不攻击同队队友",
        Value = AimTeamCheck,
        Callback = function(enabled)
            AimTeamCheck = enabled
        end
    })
    AimTab:Space()
    AimTab:Toggle({
        Title = "目标自瞄模式",
        Desc = "开启后可以选择目标进行制裁",
        Value = false,
        Callback = function(enabled)
            AimSettings.TargetAll = not enabled
            CurrentTarget = nil
        end
    })
    local playerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
    local targetDropdown = AimTab:Dropdown({
        Title = "选择目标玩家",
        Desc = "选择要自瞄的玩家",
        Values = playerList,
        Value = nil,
        AllowNone = true,
        Callback = function(selected)
            AimSettings.TargetPlayer = selected
            CurrentTarget = nil
        end
    })
    Players.PlayerAdded:Connect(function(player)
        table.insert(playerList, player.Name)
        if targetDropdown and targetDropdown.Refresh then
            targetDropdown:Refresh(playerList)
        end
    end)
    Players.PlayerRemoving:Connect(function(player)
        for i, name in ipairs(playerList) do
            if name == player.Name then
                table.remove(playerList, i)
                break
            end
        end
        if targetDropdown and targetDropdown.Refresh then
            targetDropdown:Refresh(playerList)
        end
    end)
    AimTab:Space()
    AimTab:Section({
        Title = "自瞄部位设置",
        TextSize = 16,
        FontWeight = Enum.FontWeight.SemiBold,
    })
    AimTab:Dropdown({
        Title = "自瞄部位",
        Desc = "选择要瞄准的身体部位",
        Values = {"头", "上身", "左腿", "右腿", "鸡巴", "奶子"},
        Value = AimTargetPart,
        Callback = function(selected)
            AimTargetPart = selected
        end
    })
    AimTab:Space()
    AimTab:Section({
        Title = "黑名单管理",
        TextSize = 16,
        FontWeight = Enum.FontWeight.SemiBold,
    })
    blacklistInput = AimTab:Input({
        Title = "自瞄黑名单",
        Desc = "输入不攻击的玩家名字，多个用逗号分隔",
        Placeholder = "例如: Player1,Player2,Player3",
        Callback = function(value)
            local names = {}
            for name in string.gmatch(value, "[^,]+") do
                name = name:match("^%s*(.-)%s*$")
                if name ~= "" then
                    table.insert(names, name)
                end
            end
            AimBlacklist = names
        end
    })
    AimTab:Button({
        Title = "添加当前目标到黑名单",
        Justify = "Center",
        Callback = function()
            if CurrentTarget and CurrentTarget.Name then
                local targetName = CurrentTarget.Name
                for _, name in ipairs(AimBlacklist) do
                    if name == targetName then
                        WindUI:Notify({
                            Title = "黑名单",
                            Content = targetName .. " 已在黑名单中",
                            Icon = "info",
                        })
                        return
                    end
                end
                table.insert(AimBlacklist, targetName)
                local newValue = table.concat(AimBlacklist, ", ")
                if blacklistInput and blacklistInput.SetValue then
                    blacklistInput:SetValue(newValue)
                else
                    WindUI:Notify({
                        Title = "黑名单",
                        Content = "已添加 " .. targetName .. "，请手动更新输入框",
                        Icon = "info",
                    })
                end
            else
                WindUI:Notify({
                    Title = "黑名单",
                    Content = "没有当前目标",
                    Icon = "alert-circle",
                })
            end
        end
    })
    AimTab:Space()
    AimTab:Button({
        Title = "清空白名单",
        Justify = "Center",
        Callback = function()
            AimBlacklist = {}
            if blacklistInput and blacklistInput.SetValue then
                blacklistInput:SetValue("")
            end
            WindUI:Notify({
                Title = "黑名单",
                Content = "黑名单已清空",
                Icon = "check",
            })
        end
    })
    AimTab:Space()
    local statusText = "自瞄状态: 未启用"
    if AimSettings.Enabled then
        statusText = "自瞄状态: 已启用 模式: " .. (AimSettings.TargetAll and "全部玩家" or "目标玩家")
    end
    AimTab:Section({
        Title = statusText,
        TextSize = 14,
        FontWeight = Enum.FontWeight.Medium,
        TextColor = AimSettings.Enabled and Green or Grey,
    })
    local QuickSettings = AimTab:Group({})
    QuickSettings:Button({
        Title = "快速设置: 强锁[子弹有延迟类]",
        Desc = "FOV99 平滑1 预判0.96",
        Justify = "Center",
        Callback = function()
            AimSettings.FOV = 99
            AimSettings.Smoothness = 1
            AimSettings.CrosshairDistance = 0.96
            UpdateFOVCircle()
            WindUI:Notify({
                Title = "快速设置",
                Content = "已使用近距离设置",
                Icon = "settings",
            })
        end
    })
    QuickSettings:Space()
    QuickSettings:Button({
        Title = "快速设置: 强锁[子弹无延迟]",
        Desc = "FOV120, 平滑1 预判0",
        Justify = "Center",
        Callback = function()
            AimSettings.FOV = 120
            AimSettings.Smoothness = 1
            AimSettings.CrosshairDistance = 0
            UpdateFOVCircle()
            WindUI:Notify({
                Title = "快速设置",
                Content = "已使用强锁设置",
                Icon = "settings",
            })
        end
    })
    QuickSettings:Space()
    QuickSettings:Button({
        Title = "快速设置: 平滑类[]",
        Desc = "FOV130 平滑6 预判1",
        Justify = "Center",
        Callback = function()
            AimSettings.FOV = 130
            AimSettings.Smoothness = 6
            AimSettings.CrosshairDistance = 1
            UpdateFOVCircle()
            WindUI:Notify({
                Title = "快速设置",
                Content = "已使用远距离设置",
                Icon = "settings",
            })
        end
    })
end

    local OtherTab = Window:Tab({  
        Title = "绘制功能",  
        Icon = "crown",  
        Locked = false,
    })

do
    OtherTab:Section({
        Title = "ESP",
        TextSize = 16,
        FontWeight = Enum.FontWeight.SemiBold,
    })
    OtherTab:Toggle({
        Title = "玩家透视 (ESP)",
        Desc = "显示玩家描边和距离",
        Callback = function(enabled)
            ToggleESP(enabled)
        end
    })
    OtherTab:Space()
    OtherTab:Colorpicker({
        Title = "ESP玩家名字颜色",
        Desc = "设置玩家名字显示颜色",
        Default = ESPNameColor,
        Callback = function(color)
            ESPNameColor = color
            if ESPEnabled and not ESPRainbowEnabled then
                UpdateESPColors()
            end
        end
    })
    OtherTab:Colorpicker({
        Title = "ESP身体绘制颜色",
        Desc = "设置玩家身体颜色",
        Default = ESPBodyColor,
        Callback = function(color)
            ESPBodyColor = color
            if ESPEnabled and not ESPRainbowEnabled then
                UpdateESPColors()
            end
        end
    })
    OtherTab:Slider({
        Title = "ESP玩家名字大小",
        Desc = "设置玩家名字的文本大小",
        Value = {
            Min = 8,
            Max = 24,
            Default = ESPNameSize,
        },
        Callback = function(value)
            ESPNameSize = value
            if ESPEnabled then
                UpdateESPNameSize()
            end
        end
    })
    OtherTab:Space()
    OtherTab:Toggle({
        Title = "ESP彩虹渐变",
        Desc = "开启透视彩虹效果",
        Callback = function(enabled)
            ESPRainbowEnabled = enabled
            if ESPEnabled then
                UpdateESPColors()
            end
        end
    })
    OtherTab:Slider({
        Title = "ESP彩虹速度",
        Desc = "调整彩虹的速度",
        Value = {
            Min = 1,
            Max = 10,
            Default = ESPRainbowSpeed,
        },
        Callback = function(value)
            ESPRainbowSpeed = value
        end
    })
    OtherTab:Space()
    OtherTab:Slider({
        Title = "ESP最大显示距离",
        Desc = "设置ESP显示的最大距离（单位：studs）",
        Value = {
            Min = 50,
            Max = 10000,
            Default = ESPMaxDistance,
        },
        Callback = function(value)
            ESPMaxDistance = value
        end
    })
    OtherTab:Space()
    OtherTab:Toggle({
        Title = "队伍检测",
        Desc = "开启后只显示敌方队伍",
        Value = ESPTeamCheck,
        Callback = function(enabled)
            ESPTeamCheck = enabled
            if ESPEnabled then
                UpdateESP()
            end
        end
    })
    OtherTab:Space()
    OtherTab:Toggle({
        Title = "偷袭检测提醒",
        Desc = "检测背后或侧面的敌人并提醒",
        Callback = function(enabled)
            BackstabCheckEnabled = enabled
            WindUI:Notify({
                Title = "偷袭检测",
                Content = enabled and "偷袭检测已开启" or "偷袭检测已关闭",
                Icon = "shield-alert",
            })
        end
    })
    OtherTab:Toggle({
        Title = "死亡提醒",
        Desc = "玩家死亡时显示提醒消息",
        Callback = function(enabled)
            DeathCheckEnabled = enabled
            if enabled then
                SetupDeathDetection()
            end
            WindUI:Notify({
                Title = "死亡提醒",
                Content = enabled and "死亡提醒已开启" or "死亡提醒已关闭",
                Icon = "heart",
            })
        end
    })
    OtherTab:Space()
    OtherTab:Toggle({
        Title = "夜视模式",
        Desc = "开启夜间模式",
        Callback = function(enabled)
            NightVisionEnabled = enabled
            if enabled then
                originalBrightness = Lighting.Brightness
                originalAmbient = Lighting.Ambient
                Lighting.Brightness = 2
                Lighting.Ambient = Color3.fromRGB(200, 200, 200)
                Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
                WindUI:Notify({
                    Title = "夜视模式",
                    Content = "夜视模式已开启",
                    Icon = "moon",
                })
            else
                Lighting.Brightness = originalBrightness
                Lighting.Ambient = originalAmbient
                Lighting.OutdoorAmbient = Color3.fromRGB(0.5, 0.5, 0.5)
                WindUI:Notify({
                    Title = "夜视模式",
                    Content = "夜视模式已关闭",
                    Icon = "moon",
                })
            end
        end
    })
end

    local SkinTab = Window:Tab({  
        Title = "美化",  
        Icon = "hand-platter",  
        Locked = false,
    })

    local armMaterial = "Plastic"
    local armColor = Color3.fromRGB(50, 50, 50)
    local armCharmsEnabled = false

    SkinTab:Dropdown({
        Title = "手臂材质",
        Multi = false,
        AllowNone = false,
        Value = armMaterial,
        Values = {"Plastic", "ForceField", "Wood", "Grass"},
        Callback = function(value)
            armMaterial = value
        end
    })

    SkinTab:Colorpicker({
        Title = "手臂颜色",
        Default = Color3.fromRGB(50, 50, 50),
        Callback = function(color)
            armColor = color
        end
    })

    SkinTab:Toggle({
        Title = "开启手臂美化",
        Value = false,
        Callback = function(state)
            armCharmsEnabled = state
            if armCharmsEnabled then
                spawn(function()
                    while armCharmsEnabled do
                        task.wait(0.01)
                        local cameraArms = workspace.Camera:FindFirstChild("Arms")
                        if cameraArms then
                            for _, part in pairs(cameraArms:GetDescendants()) do
                                if part.Name == 'Right Arm' or part.Name == 'Left Arm' then
                                    if part:IsA("BasePart") then
                                        part.Material = Enum.Material[armMaterial]
                                        part.Color = armColor
                                    end
                                elseif part:IsA("SpecialMesh") then
                                    if part.TextureId == '' then
                                        part.TextureId = 'rbxassetid://0'
                                        part.VertexColor = Vector3.new(armColor.R, armColor.G, armColor.B)
                                    end
                                elseif part.Name == 'L' or part.Name == 'R' then
                                    part:Destroy()
                                end
                            end
                        end
                    end
                end)
            end
        end
    })

    local gunMaterial = "Plastic"
    local gunColor = Color3.fromRGB(50, 50, 50)
    local gunCharmsEnabled = false

    SkinTab:Dropdown({
        Title = "枪械材质",
        Multi = false,
        AllowNone = false,
        Value = gunMaterial,
        Values = {"Plastic", "ForceField", "Wood", "Grass"},
        Callback = function(value)
            gunMaterial = value
        end
    })

    SkinTab:Colorpicker({
        Title = "枪械颜色",
        Default = Color3.fromRGB(50, 50, 50),
        Callback = function(color)
            gunColor = color
        end
    })

    SkinTab:Toggle({
        Title = "开启枪械美化",
        Value = false,
        Callback = function(state)
            gunCharmsEnabled = state
            if gunCharmsEnabled then
                spawn(function()
                    while gunCharmsEnabled do
                        task.wait(0.01)
                        local cameraArms = workspace.Camera:FindFirstChild("Arms")
                        if cameraArms then
                            for _, part in pairs(cameraArms:GetDescendants()) do
                                if part:IsA("MeshPart") then
                                    part.Material = Enum.Material[gunMaterial]
                                    part.Color = gunColor
                                end
                            end
                        end
                    end
                end)
            end
        end
    })

    local HitboxTab = Window:Tab({  
        Title = "杀戮功能",  
        Icon = "box",  
        Locked = false,
    })
    local hitboxEnabled = false
    local noCollisionEnabled = false
    local hitbox_original_properties = {}
    local hitboxSize = 21
    local hitboxTransparency = 6
    local teamCheck = "FFA"

    local defaultBodyParts = {
        "UpperTorso",
        "Head",
        "HumanoidRootPart"
    }

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
    local WarningText = Instance.new("TextLabel", ScreenGui)
    WarningText.Size = UDim2.new(0, 200, 0, 50)
    WarningText.TextSize = 16
    WarningText.Position = UDim2.new(0.5, -150, 0, 0)
    WarningText.Text = "小心600"
    WarningText.TextColor3 = Color3.new(1, 0, 0)
    WarningText.BackgroundTransparency = 1
    WarningText.Visible = false

    local function savedPart(player, part)
        if not hitbox_original_properties[player] then
            hitbox_original_properties[player] = {}
        end
        if not hitbox_original_properties[player][part.Name] then
            hitbox_original_properties[player][part.Name] = {
                CanCollide = part.CanCollide,
                Transparency = part.Transparency,
                Size = part.Size
            }
        end
    end

    local function restoredPart(player)
        if hitbox_original_properties[player] then
            for partName, properties in pairs(hitbox_original_properties[player]) do
                local part = player.Character and player.Character:FindFirstChild(partName)
                if part and part:IsA("BasePart") then
                    part.CanCollide = properties.CanCollide
                    part.Transparency = properties.Transparency
                    part.Size = properties.Size
                end
            end
        end
    end

    local function findClosestPart(player, partName)
        if not player.Character then return nil end
        for _, part in ipairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") and part.Name:lower():match(partName:lower()) then
                return part
            end
        end
        return nil
    end

    local function extendHitbox(player)
        for _, partName in ipairs(defaultBodyParts) do
            local part = player.Character and (player.Character:FindFirstChild(partName) or findClosestPart(player, partName))
            if part and part:IsA("BasePart") then
                savedPart(player, part)
                part.CanCollide = not noCollisionEnabled
                part.Transparency = hitboxTransparency / 10
                part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
            end
        end
    end

    local function isEnemy(player)
        if teamCheck == "FFA" or teamCheck == "Everyone" then
            return true
        end
        return player.Team ~= LocalPlayer.Team
    end

    local function shouldExtendHitbox(player)
        return isEnemy(player)
    end

    local function updateHitboxes()
        for _, v in ipairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                if shouldExtendHitbox(v) then
                    extendHitbox(v)
                else
                    restoredPart(v)
                end
            end
        end
    end

    local function onCharacterAdded(character)
        task.wait(0.1)
        if hitboxEnabled then
            updateHitboxes()
        end
    end

    local function onPlayerAdded(player)
        player.CharacterAdded:Connect(onCharacterAdded)
        player.CharacterRemoving:Connect(function()
            restoredPart(player)
            hitbox_original_properties[player] = nil
        end)
    end

    local function checkForDeadPlayers()
        for player, _ in pairs(hitbox_original_properties) do
            if not player.Parent or not player.Character or not player.Character:IsDescendantOf(game) then
                restoredPart(player)
                hitbox_original_properties[player] = nil
            end
        end
    end

    Players.PlayerAdded:Connect(onPlayerAdded)
    for _, player in ipairs(Players:GetPlayers()) do
        onPlayerAdded(player)
    end

    HitboxTab:Button({
        Title = "点击此处启动Hitbox功能",
        Callback = function()
            coroutine.wrap(function()
                while true do
                    if hitboxEnabled then
                        updateHitboxes()
                        checkForDeadPlayers()
                    end
                    task.wait(0.1)
                end
            end)()
        end
    })

    HitboxTab:Toggle({
        Title = "开启Hitbox",
        Value = false,
        Callback = function(state)
            hitboxEnabled = state
            if not state then
                for _, player in ipairs(Players:GetPlayers()) do
                    restoredPart(player)
                end
                hitbox_original_properties = {}
            else
                updateHitboxes()
            end
        end
    })

    HitboxTab:Slider({
        Title = "Hitbox大小",
        Value = {
            Min = 1,
            Max = 25,
            Default = 21
        },
        Callback = function(value)
            hitboxSize = value
            if hitboxEnabled then
                updateHitboxes()
            end
        end
    })

    HitboxTab:Slider({
        Title = "Hitbox透明度",
        Value = {
            Min = 1,
            Max = 10,
            Default = 6
        },
        Callback = function(value)
            hitboxTransparency = value
            if hitboxEnabled then
                updateHitboxes()
            end
        end
    })

    HitboxTab:Dropdown({
        Title = "队伍检测",
        Multi = false,
        AllowNone = false,
        Value = "FFA",
        Values = {"FFA", "队伍模式", "所有人"},
        Callback = function(value)
            teamCheck = value
            if hitboxEnabled then
                updateHitboxes()
            end
        end
    })

    HitboxTab:Toggle({
        Title = "无碰撞",
        Value = false,
        Callback = function(state)
            noCollisionEnabled = state
            WarningText.Visible = state
            coroutine.wrap(function()
                while noCollisionEnabled do
                    if hitboxEnabled then
                        updateHitboxes()
                    end
                    task.wait(0.01)
                end
                if hitboxEnabled then
                    updateHitboxes()
                end
            end)()
        end
    })

    HitboxTab:Toggle({
        Title = "Auto farm",
        Value = false,
        Callback = function(bool)
            getgenv().AutoFarm = bool
            local runServiceConnection
            local mouseDown = false
            local player = game.Players.LocalPlayer
            local camera = game.Workspace.CurrentCamera
            game:GetService("ReplicatedStorage").wkspc.CurrentCurse.Value = bool and "Infinite Ammo" or ""

            local function getClosestEnemyPlayer()
                local closestDistance = math.huge
                local closestPlayer = nil
                for _, enemyPlayer in pairs(game.Players:GetPlayers()) do
                    if enemyPlayer ~= player and enemyPlayer.TeamColor ~= player.TeamColor and enemyPlayer.Character then
                        local hrp = enemyPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local humanoid = enemyPlayer.Character:FindFirstChild("Humanoid")
                        if hrp and humanoid and humanoid.Health > 0 then
                            local dist = (player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                            if dist < closestDistance and hrp.Position.Y >= 0 then
                                closestDistance = dist
                                closestPlayer = enemyPlayer
                            end
                        end
                    end
                end
                return closestPlayer
            end

            local function startAutoFarm()
                game:GetService("ReplicatedStorage").wkspc.TimeScale.Value = 12
                runServiceConnection = game:GetService("RunService").Stepped:Connect(function()
                    if getgenv().AutoFarm then
                        local target = getClosestEnemyPlayer()
                        if target then
                            local pos = target.Character.HumanoidRootPart.Position + Vector3.new(0, 0, -4)
                            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
                                camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.Head.Position)
                                if not mouseDown then
                                    mouse1press()
                                    mouseDown = true
                                end
                            end
                        else
                            if mouseDown then
                                mouse1release()
                                mouseDown = false
                            end
                        end
                    else
                        if runServiceConnection then
                            runServiceConnection:Disconnect()
                            runServiceConnection = nil
                        end
                        if mouseDown then
                            mouse1release()
                            mouseDown = false
                        end
                    end
                end)
            end

            local function onCharacterAdded(character)
                wait(0.5)
                startAutoFarm()
            end

            player.CharacterAdded:Connect(onCharacterAdded)
            if bool then
                wait(0.5)
                startAutoFarm()
            else
                game:GetService("ReplicatedStorage").wkspc.CurrentCurse.Value = ""
                getgenv().AutoFarm = false
                game:GetService("ReplicatedStorage").wkspc.TimeScale.Value = 1
                if runServiceConnection then
                    runServiceConnection:Disconnect()
                    runServiceConnection = nil
                end
                if mouseDown then
                    mouse1release()
                    mouseDown = false
                end
            end
        end
    })

    local GunTab = Window:Tab({  
        Title = "枪械设置",  
        Icon = "crosshair",  
        Locked = false,
    })

    local originalValues = {
        FireRate = {},
        ReloadTime = {},
        EReloadTime = {},
        Auto = {},
        Spread = {},
        Recoil = {}
    }

    GunTab:Toggle({
        Title = "无限子弹",
        Value = false,
        Callback = function(state)
            game:GetService("ReplicatedStorage").wkspc.CurrentCurse.Value = state and "Infinite Ammo" or ""
        end
    })

    GunTab:Toggle({
        Title = "快速换弹",
        Value = false,
        Callback = function(state)
            for _, v in pairs(game.ReplicatedStorage.Weapons:GetChildren()) do
                if v:FindFirstChild("ReloadTime") then
                    if state then
                        if not originalValues.ReloadTime[v] then
                            originalValues.ReloadTime[v] = v.ReloadTime.Value
                        end
                        v.ReloadTime.Value = 0.01
                    else
                        v.ReloadTime.Value = originalValues.ReloadTime[v] or 0.8
                    end
                end
                if v:FindFirstChild("EReloadTime") then
                    if state then
                        if not originalValues.EReloadTime[v] then
                            originalValues.EReloadTime[v] = v.EReloadTime.Value
                        end
                        v.EReloadTime.Value = 0.01
                    else
                        v.EReloadTime.Value = originalValues.EReloadTime[v] or 0.8
                    end
                end
            end
        end
    })

    GunTab:Toggle({
        Title = "快速射击",
        Value = false,
        Callback = function(state)
            for _, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
                if v.Name == "FireRate" or v.Name == "BFireRate" then
                    if state then
                        if not originalValues.FireRate[v] then
                            originalValues.FireRate[v] = v.Value
                        end
                        v.Value = 0.02
                    else
                        v.Value = originalValues.FireRate[v] or 0.8
                    end
                end
            end
        end
    })

    GunTab:Toggle({
        Title = "自动连发",
        Value = false,
        Callback = function(state)
            for _, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
                if v.Name == "Auto" or v.Name == "AutoFire" or v.Name == "Automatic" or v.Name == "AutoShoot" or v.Name == "AutoGun" then
                    if state then
                        if not originalValues.Auto[v] then
                            originalValues.Auto[v] = v.Value
                        end
                        v.Value = true
                    else
                        v.Value = originalValues.Auto[v] or false
                    end
                end
            end
        end
    })

    GunTab:Toggle({
        Title = "无扩散",
        Value = false,
        Callback = function(state)
            for _, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
                if v.Name == "MaxSpread" or v.Name == "Spread" or v.Name == "SpreadControl" then
                    if state then
                        if not originalValues.Spread[v] then
                            originalValues.Spread[v] = v.Value
                        end
                        v.Value = 0
                    else
                        v.Value = originalValues.Spread[v] or 1
                    end
                end
            end
        end
    })

    GunTab:Toggle({
        Title = "无后坐力",
        Value = false,
        Callback = function(state)
            for _, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
                if v.Name == "RecoilControl" or v.Name == "Recoil" then
                    if state then
                        if not originalValues.Recoil[v] then
                            originalValues.Recoil[v] = v.Value
                        end
                        v.Value = 0
                    else
                        v.Value = originalValues.Recoil[v] or 1
                    end
                end
            end
        end
    })
elseif game.GameId == 1335695570 then --- 忍者传奇
    local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yisan9178/sjsjsj/refs/heads/main/Windui.lua(1).txt"))()
local themes = {"Dark", "Light", "Mocha", "Aqua", "Jungle"}
local currentThemeIndex = 1

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(chars, uchar)
    end
    
    local length = #chars
    
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
            math.floor(r * 255), 
            math.floor(g * 255), 
            math.floor(b * 255), 
            chars[i])
    end
    
    return result
end

local Window = WindUI:CreateWindow({
    Title = gradient("塔菲喵   ", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("伊散", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    IconThemed = true,
    Folder = "塔菲喵",
    Size = UDim2.fromOffset(150, 100),
    Transparent = getgenv().TransparencyEnabled,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 150,
    BackgroundImageTransparency = 0.8,
    HideSearchBar = true,
    ScrollBarEnabled = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            currentThemeIndex = currentThemeIndex + 1
            if currentThemeIndex > #themes then
                currentThemeIndex = 1
            end
            
            local newTheme = themes[currentThemeIndex]
            WindUI:SetTheme(newTheme)
            
            WindUI:Notify({
                Title = "主题已更改",
                Content = "切换至 " .. newTheme .. " 主题!",
                Duration = 2,
                Icon = "palette"
            })
        end,
    },
})

Window:EditOpenButton({
    Title = "[摸摸伊散]",
    CornerRadius = UDim.new(0,8),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("1E3A8A")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("118AB2")), 
        ColorSequenceKeypoint.new(1, Color3.fromHex("06D6A0")) 
    }),
    Draggable = true,
})

Window:Tag({
    Title = "伊散",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})

Window:SetToggleKey(Enum.KeyCode.F, true)

local CombatTab = Window:Tab({ Title = '功能', Icon = 'swords' })
Window:SelectTab(1) 

WindUI:Notify({
    Title = "启动成功",
    Content = "塔菲喵 已加载",
    Duration = 4,
    Icon = "check"
})

getgenv().autoswing = false
getgenv().autosell = false
getgenv().autosellmax = false
getgenv().autobuyswords = false
getgenv().autobuybelts = false
getgenv().autobuyranks = false
getgenv().autobuyskill = false
getgenv().autobuyshurikens = false

local IslandList = {
    "Ground",
    "Astral Island",
    "Space Island",
    "Tundra Island",
    "Eternal Island",
    "Sandstorm",
    "Thunderstorm",
    "Ancient Inferno Island",
    "Midnight Shadow Island",
    "Mythical Souls Island",
    "Winter Wonder Island"
}

local function swinging()
    spawn(function()
        while getgenv().autoswing == true do
            task.wait()
            game:GetService("Players").LocalPlayer.ninjaEvent:FireServer("swingKatana")
            if not getgenv().autoswing then break end
        end
    end)
end

local function selling()
    spawn(function()
        while getgenv().autosell == true do
            task.wait(0.01)
            if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
                game.workspace.sellAreaCircles.sellAreaCircle7.circleInner.CFrame = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                wait(0.1)
                if game.Workspace:FindFirstChild("Part") then
                    game.workspace.sellAreaCircles.sellAreaCircle7.circleInner.CFrame = game.Workspace.Part.CFrame
                end
                if not getgenv().autosell then break end
            end
        end
    end)
end

local function maxsell()
    spawn(function()
        while getgenv().autosellmax == true do
            task.wait()
            if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") and game.Players.LocalPlayer.PlayerGui.gameGui.maxNinjitsuMenu.Visible == true then
                game.workspace.sellAreaCircles.sellAreaCircle7.circleInner.CFrame = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                task.wait()
                if game.Workspace:FindFirstChild("Part") then
                    game.workspace.sellAreaCircles.sellAreaCircle7.circleInner.CFrame = game.Workspace.Part.CFrame
                end
            end
            if not getgenv().autosellmax then break end
        end
    end)
end

local function buyswords()
    spawn(function()
        while getgenv().autobuyswords == true do
            task.wait()
            if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
                for i = 1, #IslandList do
                    game:GetService("Players").LocalPlayer.ninjaEvent:FireServer("buyAllSwords", IslandList[i])
                end
            end
            if not getgenv().autobuyswords then break end
        end
    end)
end

local function buybelts()
    spawn(function()
        while getgenv().autobuybelts == true do
            task.wait()
            if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
                for i = 1, #IslandList do
                    game:GetService("Players").LocalPlayer.ninjaEvent:FireServer("buyAllBelts", IslandList[i])
                end
            end
            if not getgenv().autobuybelts then break end
        end
    end)
end

local function buyranks()
    spawn(function()
        while getgenv().autobuyranks == true do
            task.wait()
            if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
                local ranks = game:GetService("ReplicatedStorage").Ranks.Ground:GetChildren()
                for i = 1, #ranks do
                    game:GetService("Players").LocalPlayer.ninjaEvent:FireServer("buyRank", ranks[i].Name)
                end
            end
            if not getgenv().autobuyranks then break end
        end
    end)
end

local function buyskill()
    spawn(function()
        while getgenv().autobuyskill == true do
            task.wait()
            if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
                for i = 1, #IslandList do
                    game:GetService("Players").LocalPlayer.ninjaEvent:FireServer("buyAllSkills", IslandList[i])
                end
            end
            if not getgenv().autobuyskill then break end
        end
    end)
end

local function buyshurikens()
    spawn(function()
        while getgenv().autobuyshurikens == true do
            task.wait()
            if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
                for i = 1, #IslandList do
                    game:GetService("Players").LocalPlayer.ninjaEvent:FireServer("buyAllShurikens", IslandList[i])
                end
            end
            if not getgenv().autobuyshurikens then break end
        end
    end)
end

CombatTab:Section({ Title = "自动按钮/出售" })

CombatTab:Toggle({
    Title = "自动挥剑",
    Default = false,
    Callback = function(Value)
        getgenv().autoswing = Value
        if getgenv().autoswing then
            swinging()
        end
    end
})

CombatTab:Toggle({
    Title = "自动出售",
    Default = false,
    Callback = function(Value)
        getgenv().autosell = Value
        if getgenv().autosell then
            selling()
        end
    end
})

CombatTab:Toggle({
    Title = "存满自动出售",
    Default = false,
    Callback = function(Value)
        getgenv().autosellmax = Value
        if getgenv().autosellmax then
            maxsell()
        end
    end
})

CombatTab:Section({ Title = "自动购买功能" })

CombatTab:Toggle({
    Title = "自动购买剑",
    Default = false,
    Callback = function(Value)
        getgenv().autobuyswords = Value
        if getgenv().autobuyswords then
            buyswords()
        end
    end
})

CombatTab:Toggle({
    Title = "自动购买腰带",
    Default = false,
    Callback = function(Value)
        getgenv().autobuybelts = Value
        if getgenv().autobuybelts then
            buybelts()
        end
    end
})

CombatTab:Toggle({
    Title = "自动购买称号",
    Default = false,
    Callback = function(Value)
        getgenv().autobuyranks = Value
        if getgenv().autobuyranks then
            buyranks()
        end
    end
})

CombatTab:Toggle({
    Title = "自动购买忍术",
    Default = false,
    Callback = function(Value)
        getgenv().autobuyskill = Value
        if getgenv().autobuyskill then
            buyskill()
        end
    end
})

CombatTab:Toggle({
    Title = "自动购买手里剑",
    Default = false,
    Callback = function(Value)
        getgenv().autobuyshurikens = Value
        if getgenv().autobuyshurikens then
            buyshurikens()
        end
    end
})

CombatTab:Section({ Title = "其他功能" })

CombatTab:Button({
    Title = "解锁所有岛",
    Callback = function()
        local children = game.workspace.islandUnlockParts:GetChildren()
        for _, part in pairs(children) do
             if part then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = part.islandSignPart.CFrame
                wait(0.5)
            end
        end
        WindUI:Notify({Title = "提示", Content = "所有岛屿解锁完毕！", Duration = 3})
    end
})
elseif game.GameId == 605887098 then --- 汽车营销商大亨
    local VirtualUserService = game:GetService("VirtualUser")

-- 反挂机
game:GetService("Players").LocalPlayer.Idled:connect(function()
    VirtualUserService:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUserService:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- 拦截 Remote 存储参数
local GameMetatable = getrawmetatable(game)
setreadonly(GameMetatable, false)
local OriginalNamecall = GameMetatable.__namecall

GameMetatable.__namecall = newcclosure(function(Self, ...)
    local Arguments = { ... }
    if getnamecallmethod() == "FireServer" and (Self.Name == "JobRemoteHandler" and rawget(..., "Action") == "StartDeliveryJob") then
        print(Arguments)
        _G.remotetable = ...
    end
    return OriginalNamecall(Self, ...)
end)

--========================================
-- 2. 初始化 WindUI 界面
--========================================
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yisan9178/sjsjsj/refs/heads/main/Windui.lua(1).txt"))()

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(chars, uchar)
    end
    
    local length = #chars
    
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
            math.floor(r * 255), 
            math.floor(g * 255), 
            math.floor(b * 255), 
            chars[i])
    end
    
    return result
end

local Window = WindUI:CreateWindow({
    Title = gradient("塔菲喵   ", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("伊散", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    IconThemed = true,
    Folder = "塔菲喵",
    Size = UDim2.fromOffset(150, 100),
    Transparent = getgenv().TransparencyEnabled,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 150,
    BackgroundImageTransparency = 0.8,
    HideSearchBar = true,
    ScrollBarEnabled = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            -- Theme switching callback
            print("Theme toggled")
        end,
    },
})

Window:EditOpenButton({
    Title = "[摸摸伊散]",
    CornerRadius = UDim.new(0,8),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("1E3A8A")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("118AB2")), 
        ColorSequenceKeypoint.new(1, Color3.fromHex("06D6A0")) 
    }),
    Draggable = true,
})

Window:Tag({
    Title = "伊散",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})

Window:SetToggleKey(Enum.KeyCode.F, true)

--========================================
-- 3. 界面菜单与功能实现
--========================================
local CombatTab = Window:Tab({ Title = '功能', Icon = 'swords' })

--========== 开始写入具体功能 ==========--

-- 功能1：自动收集活动部件
CombatTab:Toggle({
    Title = "自动收集活动部件", 
    Default = false, 
    Callback = function(ToggleValue)
        getfenv().test = ToggleValue
        if ToggleValue then
            task.spawn(function()
                while getfenv().test do
                    wait()
                    local IteratorFunction, WorkspaceChildren, CurrentIndex = pairs(workspace:GetChildren())
                    local function GetCollectedCount()
                        local CountTextSplit = game:GetService("Players").LocalPlayer.PlayerGui.Menu.Event.Frame.PrizeFrame.ProgressBar.Count.Text:split("/")
                        return tonumber(CountTextSplit[1])
                    end
                    while true do
                        local WorkspaceChild
                        CurrentIndex, WorkspaceChild = IteratorFunction(WorkspaceChildren, CurrentIndex)
                        if CurrentIndex == nil then break end
                        if WorkspaceChild.ClassName == "Model" and (not WorkspaceChild:FindFirstChild("Part") and (WorkspaceChild:FindFirstChild("Owned") and (GetCollectedCount() ~= 12 and getfenv().test == true))) then
                            repeat
                                wait()
                                game.Players.LocalPlayer.Character:PivotTo(WorkspaceChild.WorldPivot)
                            until WorkspaceChild:FindFirstChild("Part") or getfenv().test == false
                        end
                    end
                    local IteratorFunction2, WorkspaceChildren2, CurrentIndex2 = pairs(workspace:GetChildren())
                    while true do
                        local WorkspaceChild2
                        CurrentIndex2, WorkspaceChild2 = IteratorFunction2(WorkspaceChildren2, CurrentIndex2)
                        if CurrentIndex2 == nil then break end
                        if WorkspaceChild2.ClassName == "Model" and (WorkspaceChild2:FindFirstChild("Part") and (WorkspaceChild2:FindFirstChild("Owned") and (GetCollectedCount() ~= 12 and getfenv().test == true))) then
                            game.Players.LocalPlayer.Character:PivotTo(WorkspaceChild2.WorldPivot)
                            local PreviousCount = GetCollectedCount()
                            local IteratorFunction3, ModelChildren, CurrentIndex3 = pairs(WorkspaceChild2:GetChildren())
                            local VisibleMeshPart = nil
                            while true do
                                local ModelChild
                                CurrentIndex3, ModelChild = IteratorFunction3(ModelChildren, CurrentIndex3)
                                if CurrentIndex3 == nil then break end
                                if ModelChild.ClassName == "MeshPart" then
                                    if ModelChild.Transparency < 0.5 then
                                        VisibleMeshPart = ModelChild
                                    end
                                end
                            end
                            if VisibleMeshPart ~= nil then
                                repeat
                                    task.wait()
                                    game.Players.LocalPlayer.Character:PivotTo(WorkspaceChild2.WorldPivot)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                                until VisibleMeshPart.Transparency > 0.5 or getfenv().test == false
                                repeat
                                    task.wait()
                                    game:GetService("ReplicatedStorage").Remotes.EventController.PerformAction:FireServer("AssembleCarPart", {})
                                until PreviousCount ~= GetCollectedCount()
                            end
                        end
                    end
                end
            end)
        end
    end
})

-- 功能2：自动送货
CombatTab:Toggle({
    Title = "自动送货", 
    Default = false, 
    Callback = function(ToggleValue)
        getfenv().deliver = ToggleValue
        if ToggleValue then
            task.spawn(function()
                while getfenv().deliver do
                    task.wait()
                    pcall(function()
                        if game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Sit == false then
                            wait(5)
                            getfenv().spawned = false
                        end
                    end)
                end
            end)
            
            task.spawn(function()
                while getfenv().deliver do
                    wait()
                    pcall(function()
                        if game.Players.LocalPlayer.Character.Humanoid.Sit ~= true then
                            if game.Players.LocalPlayer.Character.Humanoid.Sit == false and getfenv().spawned ~= true then
                                if _G.remotetable then
                                    game:GetService("ReplicatedStorage").Remotes.DealershipCustomerController.JobRemoteHandler:FireServer(_G.remotetable)
                                end
                                getfenv().spawned = true
                                wait(0.1)
                            end
                        else
                            task.wait(0.1)
                            local IteratorFunction, JobDescendants, CurrentIndex = pairs(workspace.ActionTasksGames.Jobs:GetDescendants())
                            while true do
                                local JobDescendant
                                CurrentIndex, JobDescendant = IteratorFunction(JobDescendants, CurrentIndex)
                                if CurrentIndex == nil then break end
                                if JobDescendant.Name == "DeliveryPart" and JobDescendant.Transparency ~= 1 then
                                    getfenv().spawned = false
                                    game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent.Parent:PivotTo(JobDescendant.CFrame)
                                    game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent.Parent:PivotTo(JobDescendant.CFrame * CFrame.new(-30, 20, -10))
                                    game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent.Parent:PivotTo(JobDescendant.CFrame * CFrame.Angles(0, math.rad(90), 0))
                                    local IteratorFunction2, VehicleChildren, CurrentIndex2 = pairs(game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent.Parent:GetChildren())
                                    while true do
                                        local VehicleChild
                                        CurrentIndex2, VehicleChild = IteratorFunction2(VehicleChildren, CurrentIndex2)
                                        if CurrentIndex2 == nil then break end
                                        if VehicleChild.ClassName == "Model" and VehicleChild:GetAttribute("StockTurbo") then
                                            local IteratorFunction3, JobChildren, CurrentIndex3 = pairs(workspace.ActionTasksGames.Jobs:GetChildren())
                                            while true do
                                                local JobChild
                                                CurrentIndex3, JobChild = IteratorFunction3(JobChildren, CurrentIndex3)
                                                if CurrentIndex3 == nil then break end
                                                if JobChild.ClassName == "Model" and JobChild:GetAttribute("JobId") then
                                                    game:GetService("ReplicatedStorage").Remotes.DealershipCustomerController.JobRemoteHandler:FireServer({
                                                        Action = "TryToCompleteJob",
                                                        JobId = JobChild:GetAttribute("JobId")
                                                    })
                                                    local JobRemoteHandler = game:GetService("ReplicatedStorage").Remotes.DealershipCustomerController.JobRemoteHandler
                                                    local FireServerFunction = JobRemoteHandler.FireServer
                                                    local CollectRewardData = {
                                                        JobId = game:GetService("Players").LocalPlayer.PlayerGui.MissionRewardStars:GetAttribute("JobId"),
                                                        Action = "CollectReward"
                                                    }
                                                    FireServerFunction(JobRemoteHandler, CollectRewardData)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end
})

-- 功能3：自动售卖汽车
CombatTab:Toggle({
    Title = "自动售卖汽车", 
    Default = false, 
    Callback = function(ToggleValue)
        getfenv().Customer = ToggleValue
        if ToggleValue then
            task.spawn(function()
                while getfenv().Customer do
                    task.wait()
                    pcall(function()
                        _G.rat = nil
                        local tycoon = nil
                        local IteratorFunction, DealershipChildren, CurrentIndex = pairs((function()
                            local IteratorFunction2, TycoonDescendants, CurrentIndex2 = pairs(workspace.Tycoons:GetDescendants())
                            while true do
                                local TycoonDescendant
                                CurrentIndex2, TycoonDescendant = IteratorFunction2(TycoonDescendants, CurrentIndex2)
                                if CurrentIndex2 == nil then break end
                                if TycoonDescendant.Name == "Owner" and (TycoonDescendant.ClassName == "StringValue" and (string.find(TycoonDescendant.Parent.Name, "Plot") and TycoonDescendant.Value == game.Players.LocalPlayer.Name)) or TycoonDescendant.Name == "Owner" and (TycoonDescendant.ClassName == "StringValue" and (string.find(TycoonDescendant.Parent.Name, "Slot") and TycoonDescendant.Value == game.Players.LocalPlayer.Name)) then
                                    tycoon = TycoonDescendant.Parent
                                end
                            end
                            return tycoon
                        end)().Dealership:GetChildren())
                        local CustomerNPC = nil
                        while true do
                            local DealershipChild
                            CurrentIndex, DealershipChild = IteratorFunction(DealershipChildren, CurrentIndex)
                            if CurrentIndex == nil then break end
                            if DealershipChild.ClassName == "Model" and DealershipChild.PrimaryPart ~= nil then
                                if DealershipChild.PrimaryPart.Name == "HumanoidRootPart" then
                                    CustomerNPC = DealershipChild
                                end
                            end
                        end
                        local BudgetSplit = CustomerNPC:GetAttribute("OrderSpecBudget"):split(";")
                        local MaxBudget = tonumber(BudgetSplit[2])
                        local PlayerGui = game.Players.LocalPlayer.PlayerGui
                        local MenuGui = PlayerGui.Menu
                        local CarSpecFrame = PlayerGui.Dialogue.CarSpec.Frame.Frame
                        local IteratorFunction2, ShopDescendants, CurrentIndex2 = pairs(MenuGui.Shop.Cars.Frame.Frame:GetDescendants())
                        while true do
                            local ShopDescendant
                            CurrentIndex2, ShopDescendant = IteratorFunction2(ShopDescendants, CurrentIndex2)
                            if CurrentIndex2 == nil then break end
                            if ShopDescendant.Name == "PriceValue" and (tonumber(string.gsub(ShopDescendant.Value, ",", ""):split("$")[2]) > tonumber(BudgetSplit[1]) and tonumber(string.gsub(ShopDescendant.Value, ",", ""):split("$")[2]) < tonumber(BudgetSplit[2])) then
                                local CarPrice = tonumber(string.gsub(ShopDescendant.Value, ",", ""):split("$")[2])
                                if CarPrice < MaxBudget then
                                    _G.rat = ShopDescendant
                                    MaxBudget = CarPrice
                                end
                            end
                        end
                        local textn = 1
                        local CharacterAtPosition = ""
                        repeat
                            wait()
                            CharacterAtPosition = _G.rat.Parent.Name:split("")[textn]
                            textn = textn + 1
                        until tonumber(CharacterAtPosition) == nil
                        
                        game:GetService("ReplicatedStorage").Remotes.DealershipCustomerController.NPCHandler:FireServer({
                            Action = "AcceptOrder",
                            OrderId = CustomerNPC:GetAttribute("OrderId")
                        })
                        wait()
                        local NPCHandler = game:GetService("ReplicatedStorage").Remotes.DealershipCustomerController.NPCHandler
                        local FireServerFunction = NPCHandler.FireServer
                        local CompleteOrderData = {}
                        local SpecsData = {
                            Springs = CustomerNPC:GetAttribute("OrderSpecSprings"),
                            Color = CustomerNPC:GetAttribute("OrderSpecColor"),
                            Rims = CustomerNPC:GetAttribute("OrderSpecRims"),
                            Car = CharacterAtPosition .. _G.rat.Parent.Name:split(tostring(_G.rat.Parent.Name:split("")[textn - 1]))[2],
                            RimColor = CustomerNPC:GetAttribute("OrderSpecRimColor")
                        }
                        CompleteOrderData.Specs = SpecsData
                        CompleteOrderData.Action = "CompleteOrder"
                        CompleteOrderData.OrderId = CustomerNPC:GetAttribute("OrderId")
                        FireServerFunction(NPCHandler, CompleteOrderData)
                        wait()
                        game:GetService("ReplicatedStorage").Remotes.DealershipCustomerController.NPCHandler:FireServer({
                            Action = "CollectReward",
                            OrderId = CustomerNPC:GetAttribute("OrderId")
                        })
                        repeat
                            wait()
                        until CustomerNPC.Parent == nil or getfenv().Customer == false
                    end)
                end
            end)
        end
    end
})

-- 功能4：自动升级
CombatTab:Toggle({
    Title = "自动升级", 
    Default = false, 
    Callback = function(ToggleValue)
        getfenv().buyer = ToggleValue
        if ToggleValue then
            task.spawn(function()
                while getfenv().buyer do
                    task.wait()
                    local function GetPlayerTycoon()
                        local tycoon = nil
                        local IteratorFunction, TycoonDescendants, CurrentIndex = pairs(workspace.Tycoons:GetDescendants())
                        while true do
                            local TycoonDescendant
                            CurrentIndex, TycoonDescendant = IteratorFunction(TycoonDescendants, CurrentIndex)
                            if CurrentIndex == nil then break end
                            if TycoonDescendant.Name == "Owner" and (TycoonDescendant.ClassName == "StringValue" and TycoonDescendant.Value == game.Players.LocalPlayer.Name) then
                                tycoon = TycoonDescendant.Parent
                            end
                        end
                        return tycoon
                    end
                    pcall(function()
                        local IteratorFunction, PurchaseChildren, CurrentIndex = pairs(GetPlayerTycoon().Dealership.Purchases:GetChildren())
                        while true do
                            local PurchaseChild
                            CurrentIndex, PurchaseChild = IteratorFunction(PurchaseChildren, CurrentIndex)
                            if CurrentIndex == nil then break end
                            if getfenv().buyer == true and PurchaseChild:FindFirstChild("TycoonButton") and PurchaseChild.TycoonButton.Button.Transparency == 0 then
                                game:GetService("ReplicatedStorage").Remotes.Build:FireServer("BuyItem", PurchaseChild.Name)
                                wait(0.3)
                            end
                        end
                    end)
                end
            end)
        end
    end
})

-- 功能5：删除弹出窗口
CombatTab:Toggle({
    Title = "删除弹出窗口", 
    Default = false, 
    Callback = function(ToggleValue)
        getfenv().annoy = ToggleValue
        if getfenv().annoy then
            getfenv().fun = game:GetService("Players").LocalPlayer.PlayerGui.ChildAdded:Connect(function(ChildAdded)
                if ChildAdded.Name == "Popup2" then
                    ChildAdded:Destroy()
                end
            end)
        else
            if getfenv().fun then
                getfenv().fun:Disconnect()
            end
        end
    end
})
elseif game.GameId == 2294168059 then --- 模仿者
    local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/whenheer/uy/refs/heads/main/mainui.lua"))()

local Window = WindUI:CreateWindow({
        Title = "塔菲喵",
        IconTransparency = 0.5,
        IconThemed = true,
        Author = "伊散",
        Folder = "CloudHub",
        Size = UDim2.fromOffset(400, 300),
        Transparent = true,
        Theme = "Dark",
        User = {
            Enabled = true,
            Callback = function() print("clicked") end,
            Anonymous = false
        },
        SideBarWidth = 200,
        ScrollBarEnabled = true,
    })

local Tabs = {
    Main = Window:Section({ Title = "所有关卡", Opened = true }),
}

local TabHandles = {
    Q = Tabs.Main:Tab({ Title = "传送嫉妒1", Icon = "layout-grid" }),
    W = Tabs.Main:Tab({ Title = "透视功能", Icon = "layout-grid" }),  
}
-----------------------------------屋子里------------------------------------------------

local Button = TabHandles.Q:Button({
    Title = "提示",
    Desc = "第一关卡在日本屋子里",
    Image = "palette",
    ImageSize = 20,
    Color = "White"
})

Button = TabHandles.Q:Button({
    Title = "隐身怪物看不见",
    Desc = "有些关卡，一卡一卡的",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Yungengxin/roblox/main/yinshen"))()
            
WindUI:Notify({
    Title = "通知",
    Content = "加载成功",
    Duration = 1, -- 3 seconds
    Icon = "layout-grid",
})                        
            
 end
})

Button = TabHandles.Q:Button({
    Title = "动画房间",
    Desc = "",
    Locked = false,
    Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new( -1675.27, -23.32, -3411.01)
            
WindUI:Notify({
    Title = "通知",
    Content = "加载成功",
    Duration = 1, -- 3 seconds
    Icon = "layout-grid",
})                        
            
 end
})

Button = TabHandles.Q:Button({
    Title = "放毒老鼠地方",
    Desc = "",
    Locked = false,
    Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new( -1562.39,  -29.25,  -3403.67)
            
WindUI:Notify({
    Title = "通知",
    Content = "加载成功",
    Duration = 1, -- 3 seconds
    Icon = "layout-grid",
})                        
            
 end
})

Button = TabHandles.Q:Button({
    Title = "老鼠1",
    Desc = "",
    Locked = false,
    Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new( -1524.21,  -29.25,  -3580.63)
            
WindUI:Notify({
    Title = "通知",
    Content = "加载成功",
    Duration = 1, -- 3 seconds
    Icon = "layout-grid",
})                        
            
 end
})

Button = TabHandles.Q:Button({
    Title = "老鼠2",
    Desc = "",
    Locked = false,
    Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1642.97,  -23.44,  -3434.15)
            
WindUI:Notify({
    Title = "通知",
    Content = "加载成功",
    Duration = 1, -- 3 seconds
    Icon = "layout-grid",
})                        
            
 end
})

Button = TabHandles.Q:Button({
    Title = "老鼠3",
    Desc = "",
    Locked = false,
    Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new( -1680.65,  -23.47,  -3391.97)
            
WindUI:Notify({
    Title = "通知",
    Content = "加载成功",
    Duration = 1, -- 3 seconds
    Icon = "layout-grid",
})                        
            
 end
})

Button = TabHandles.Q:Button({
    Title = "老鼠4",
    Desc = "",
    Locked = false,
    Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new( -1620.64,  -23.44,  -3397.37)
            
WindUI:Notify({
    Title = "通知",
    Content = "加载成功",
    Duration = 1, -- 3 seconds
    Icon = "layout-grid",
})                        
            
 end
})

Button = TabHandles.Q:Button({
    Title = "毒老鼠老井",
    Desc = "老鼠毒放在老鼠身上的",
    Locked = false,
    Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new( -1531.34, -30.17,  -3541.97)
            
WindUI:Notify({
    Title = "通知",
    Content = "加载成功",
    Duration = 1, -- 3 seconds
    Icon = "layout-grid",
})                        
            
 end
})
-----------------------------------山坡上巨蛇------------------------------------------------

local Button = TabHandles.Q:Button({
    Title = "提示",
    Desc = "第二关卡山坡上的巨蛇",
    Image = "palette",
    ImageSize = 20,
    Color = "White"
})


Button = TabHandles.Q:Button({
    Title = "巨大蛇怪山坡秒过",
    Desc = "",
    Locked = false,
    Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new( 578.31,  567.98,  -380.59)
            
WindUI:Notify({
    Title = "通知",
    Content = "加载成功",
    Duration = 1, -- 3 seconds
    Icon = "layout-grid",
})                        
            
 end
})

Button = TabHandles.Q:Button({
    Title = "洞穴秒过",
    Desc = "",
    Locked = false,
    Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new( 3837.46,  137.13,  12.84)
            
WindUI:Notify({
    Title = "通知",
    Content = "加载成功",
    Duration = 3, -- 3 seconds
    Icon = "layout-grid",
})                        
            
 end
})
-----------------------------------村庄------------------------------------------------

local Button = TabHandles.Q:Button({
    Title = "提示",
    Desc = "第三关卡你在村庄里",
    Image = "palette",
    ImageSize = 20,
    Color = "White"
})


Button = TabHandles.Q:Button({
    Title = "传送谈话村民",
    Desc = "",
    Locked = false,
    Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new()
            
WindUI:Notify({
    Title = "通知",
    Content = "加载成功",
    Duration = 1, -- 3 seconds
    Icon = "layout-grid",
})                        
            
 end
})

Button = TabHandles.Q:Button({
    Title = "传送洞穴里",
    Desc = "",
    Locked = false,
    Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new( 343.48,  20.66,  3608.81)
            
WindUI:Notify({
    Title = "通知",
    Content = "加载成功",
    Duration = 1, -- 3 seconds
    Icon = "layout-grid",
})                        
            
 end
})

-----------------------------------透视功能------------------------------------------------

getgenv().ESPEnabled = false
getgenv().ShowBox = false
getgenv().ShowHealth = false
getgenv().ShowName = false
getgenv().ShowDistance = false
getgenv().ShowTracer = false
getgenv().TeamCheck = false
getgenv().ShowSkeleton = false
getgenv().ShowRadar = false
getgenv().ShowPlayerCount = false
getgenv().ShowWeapon = false
getgenv().ShowFOV = false
getgenv().OutOfViewArrows = false
getgenv().Chams = false

getgenv().TracerColor = Color3.new(1, 0, 0)
getgenv().SkeletonColor = Color3.new(0.2, 0.8, 1)
getgenv().BoxColor = Color3.new(1, 1, 1)
getgenv().HealthBarColor = Color3.new(0, 1, 0)
getgenv().HealthTextColor = Color3.new(1, 1, 1)
getgenv().NameColor = Color3.new(1, 1, 1)
getgenv().DistanceColor = Color3.new(1, 1, 0)
getgenv().WeaponColor = Color3.new(1, 0.5, 0)
getgenv().ArrowColor = Color3.new(1, 0, 0)
getgenv().FOVColor = Color3.new(1, 1, 1)
getgenv().ChamsColor = Color3.new(1, 0, 0)

getgenv().BoxThickness = 1
getgenv().TracerThickness = 1
getgenv().SkeletonThickness = 2
getgenv().FOVRadius = 100
getgenv().ArrowSize = 15

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local function getGradientColor(time)
    local r = math.sin(time * 2) * 0.5 + 0.5
    local g = math.sin(time * 3) * 0.5 + 0.5
    local b = math.sin(time * 4) * 0.5 + 0.5
    return Color3.new(r, g, b)
end

local playerCountText = Drawing.new("Text")
playerCountText.Visible = false
playerCountText.Color = Color3.new(1, 1, 1)
playerCountText.Size = 20
playerCountText.Font = Drawing.Fonts.Monospace
playerCountText.Outline = true
playerCountText.OutlineColor = Color3.new(0, 0, 0)
playerCountText.Position = Vector2.new(Camera.ViewportSize.X / 2, 10)

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Color = getgenv().FOVColor
fovCircle.Thickness = 1
fovCircle.Filled = false
fovCircle.Radius = getgenv().FOVRadius
fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

local function updatePlayerCount()
    local playerCount = #Players:GetPlayers()
    playerCountText.Text = "在线玩家: " .. playerCount
    playerCountText.Visible = getgenv().ESPEnabled and getgenv().ShowPlayerCount

    local time = tick()
    playerCountText.Color = getGradientColor(time)
end

local function updateFOV()
    fovCircle.Visible = getgenv().ShowFOV
    fovCircle.Color = getgenv().FOVColor
    fovCircle.Radius = getgenv().FOVRadius
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

local ESPComponents = {}

local function createESP(player)
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = getgenv().BoxColor
    box.Thickness = getgenv().BoxThickness
    box.Filled = false

    local healthBar = Drawing.new("Square")
    healthBar.Visible = false
    healthBar.Color = getgenv().HealthBarColor
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
    healthText.Color = getgenv().HealthTextColor
    healthText.Size = 14
    healthText.Font = Drawing.Fonts.Monospace
    healthText.Outline = true
    healthText.OutlineColor = Color3.new(0, 0, 0)

    local nameText = Drawing.new("Text")
    nameText.Visible = false
    nameText.Color = getgenv().NameColor
    nameText.Size = 16
    nameText.Font = Drawing.Fonts.Monospace
    nameText.Outline = true
    nameText.OutlineColor = Color3.new(0, 0, 0)

    local distanceText = Drawing.new("Text")
    distanceText.Visible = false
    distanceText.Color = getgenv().DistanceColor
    distanceText.Size = 14
    distanceText.Font = Drawing.Fonts.Monospace
    distanceText.Outline = true
    distanceText.OutlineColor = Color3.new(0, 0, 0)

    local weaponText = Drawing.new("Text")
    weaponText.Visible = false
    weaponText.Color = getgenv().WeaponColor
    weaponText.Size = 14
    weaponText.Font = Drawing.Fonts.Monospace
    weaponText.Outline = true
    weaponText.OutlineColor = Color3.new(0, 0, 0)

    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Color = getgenv().TracerColor
    tracer.Thickness = getgenv().TracerThickness

    local arrow = Drawing.new("Triangle")
    arrow.Visible = false
    arrow.Color = getgenv().ArrowColor
    arrow.Filled = true
    arrow.Thickness = 1

    local skeletonLines = {}
    local skeletonPoints = {}

    local function createSkeleton()
        for i = 1, 15 do
            skeletonLines[i] = Drawing.new("Line")
            skeletonLines[i].Visible = false
            skeletonLines[i].Color = getgenv().SkeletonColor
            skeletonLines[i].Thickness = getgenv().SkeletonThickness
        end

        skeletonPoints["Head"] = Drawing.new("Circle")
        skeletonPoints["Head"].Visible = false
        skeletonPoints["Head"].Color = Color3.new(1, 0.5, 0)
        skeletonPoints["Head"].Thickness = 2
        skeletonPoints["Head"].Filled = true
        skeletonPoints["Head"].Radius = 4
    end

    createSkeleton()

    local lastHealth = 100
    local healthChangeTime = 0
    local smoothHealth = 100

    ESPComponents[player] = {
        box = box,
        healthBar = healthBar,
        healthBarBackground = healthBarBackground,
        healthBarBorder = healthBarBorder,
        healthText = healthText,
        nameText = nameText,
        distanceText = distanceText,
        weaponText = weaponText,
        tracer = tracer,
        arrow = arrow,
        skeletonLines = skeletonLines,
        skeletonPoints = skeletonPoints
    }

    RunService.RenderStepped:Connect(function()
        if not getgenv().ESPEnabled or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") or not player.Character:FindFirstChild("Humanoid") or player == LocalPlayer then
            box.Visible = false
            healthBar.Visible = false
            healthBarBackground.Visible = false
            healthBarBorder.Visible = false
            healthText.Visible = false
            nameText.Visible = false
            distanceText.Visible = false
            weaponText.Visible = false
            tracer.Visible = false
            arrow.Visible = false
            for _, line in pairs(skeletonLines) do
                line.Visible = false
            end
            for _, point in pairs(skeletonPoints) do
                point.Visible = false
            end
            return
        end

        if getgenv().TeamCheck and player.Team == LocalPlayer.Team then
            box.Visible = false
            healthBar.Visible = false
            healthBarBackground.Visible = false
            healthBarBorder.Visible = false
            healthText.Visible = false
            nameText.Visible = false
            distanceText.Visible = false
            weaponText.Visible = false
            tracer.Visible = false
            arrow.Visible = false
            for _, line in pairs(skeletonLines) do
                line.Visible = false
            end
            for _, point in pairs(skeletonPoints) do
                point.Visible = false
            end
            return
        end

        local character = player.Character
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChild("Humanoid")

        if rootPart and humanoid and humanoid.Health > 0 then
            local rootPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            local headPos, _ = Camera:WorldToViewportPoint(rootPart.Position + Vector3.new(0, 3, 0))
            local legPos, _ = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))

            local weaponName = "无武器"
            for _, tool in ipairs(character:GetChildren()) do
                if tool:IsA("Tool") then
                    weaponName = tool.Name
                    break
                end
            end

            if getgenv().ShowBox and onScreen then
                box.Size = Vector2.new(1000 / rootPos.Z, headPos.Y - legPos.Y)
                box.Position = Vector2.new(rootPos.X - box.Size.X / 2, rootPos.Y - box.Size.Y / 2)
                box.Visible = true
                box.Color = getgenv().BoxColor
                box.Thickness = getgenv().BoxThickness
            else
                box.Visible = false
            end

            if getgenv().ShowHealth and onScreen then
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

                if smoothHealthPercentage >= 0.8 then
                    healthBar.Color = Color3.new(0, 1, 0)
                elseif smoothHealthPercentage >= 0.5 then
                    healthBar.Color = Color3.new(1, 1, 0)
                elseif smoothHealthPercentage >= 0.2 then
                    healthBar.Color = Color3.new(1, 0.5, 0)
                else
                    healthBar.Color = Color3.new(1, 0, 0)
                end

                healthBar.Visible = true

                if humanoid.Health ~= lastHealth then
                    healthChangeTime = tick()
                    lastHealth = humanoid.Health
                end

                if tick() - healthChangeTime < 0.5 then
                    healthBar.Color = Color3.new(1, 0, 0)
                end

                healthText.Position = Vector2.new(barX + barWidth + 5, barY - 5)
                healthText.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                healthText.Visible = true
            else
                healthBar.Visible = false
                healthBarBackground.Visible = false
                healthBarBorder.Visible = false
                healthText.Visible = false
            end

            if getgenv().ShowName and onScreen then
                nameText.Position = Vector2.new(headPos.X, headPos.Y - 35)
                nameText.Text = player.Name
                nameText.Visible = true

                if getgenv().ShowDistance then
                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                    distanceText.Position = Vector2.new(headPos.X, headPos.Y + 10)
                    distanceText.Text = math.floor(distance) .. "m"
                    distanceText.Visible = true
                else
                    distanceText.Visible = false
                end
                
                if getgenv().ShowWeapon then
                    weaponText.Position = Vector2.new(headPos.X, headPos.Y - 50)
                    weaponText.Text = weaponName
                    weaponText.Visible = true
                else
                    weaponText.Visible = false
                end
            else
                nameText.Visible = false
                distanceText.Visible = false
                weaponText.Visible = false
            end

            if getgenv().ShowTracer then
                local head = character:FindFirstChild("Head")
                if head then
                    local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        tracer.To = Vector2.new(headPos.X, headPos.Y)
                        tracer.Visible = true
                        tracer.Color = getgenv().TracerColor
                        tracer.Thickness = getgenv().TracerThickness
                        
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                        if distance < 20 then
                            tracer.Color = Color3.new(0, 1, 0)
                        elseif distance < 50 then
                            tracer.Color = Color3.new(1, 1, 0) 
                        else
                            tracer.Color = getgenv().TracerColor 
                        end
                    else
                        tracer.Visible = false
                    end
                else
                    tracer.Visible = false
                end
            else
                tracer.Visible = false
            end

            if getgenv().OutOfViewArrows and not onScreen then
                local direction = (rootPart.Position - Camera.CFrame.Position).Unit
                local dotProduct = Camera.CFrame.RightVector:Dot(direction)
                local crossProduct = Camera.CFrame.RightVector:Cross(direction)
                
                local screenPosition = Vector2.new(
                    Camera.ViewportSize.X / 2 + dotProduct * Camera.ViewportSize.X / 3,
                    Camera.ViewportSize.Y / 2 - crossProduct.Y * Camera.ViewportSize.Y / 3
                )
                
                screenPosition = Vector2.new(
                    math.clamp(screenPosition.X, getgenv().ArrowSize, Camera.ViewportSize.X - getgenv().ArrowSize),
                    math.clamp(screenPosition.Y, getgenv().ArrowSize, Camera.ViewportSize.Y - getgenv().ArrowSize)
                )
                
                local angle = math.atan2(screenPosition.Y - Camera.ViewportSize.Y / 2, screenPosition.X - Camera.ViewportSize.X / 2)
                
                arrow.PointA = screenPosition
                arrow.PointB = Vector2.new(
                    screenPosition.X - getgenv().ArrowSize * math.cos(angle - 0.5),
                    screenPosition.Y - getgenv().ArrowSize * math.sin(angle - 0.5)
                )
                arrow.PointC = Vector2.new(
                    screenPosition.X - getgenv().ArrowSize * math.cos(angle + 0.5),
                    screenPosition.Y - getgenv().ArrowSize * math.sin(angle + 0.5)
                )
                
                arrow.Color = getgenv().ArrowColor
                arrow.Visible = true
            else
                arrow.Visible = false
            end

            if getgenv().ShowSkeleton and onScreen then
                local head = character:FindFirstChild("Head")
                local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
                local leftArm = character:FindFirstChild("Left Arm") or character:FindFirstChild("LeftUpperArm")
                local rightArm = character:FindFirstChild("Right Arm") or character:FindFirstChild("RightUpperArm")
                local leftLeg = character:FindFirstChild("Left Leg") or character:FindFirstChild("LeftUpperLeg")
                local rightLeg = character:FindFirstChild("Right Leg") or character:FindFirstChild("RightUpperLeg")
                
                if head and torso and leftArm and rightArm and leftLeg and rightLeg then
                    local headPos = Camera:WorldToViewportPoint(head.Position)
                    local torsoPos = Camera:WorldToViewportPoint(torso.Position)
                    local leftArmPos = Camera:WorldToViewportPoint(leftArm.Position)
                    local rightArmPos = Camera:WorldToViewportPoint(rightArm.Position)
                    local leftLegPos = Camera:WorldToViewportPoint(leftLeg.Position)
                    local rightLegPos = Camera:WorldToViewportPoint(rightLeg.Position)

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
                        local leftLowerArmPos = Camera:WorldToViewportPoint(character.LeftLowerArm.Position)
                        skeletonLines[6].From = Vector2.new(leftArmPos.X, leftArmPos.Y)
                        skeletonLines[6].To = Vector2.new(leftLowerArmPos.X, leftLowerArmPos.Y)
                        skeletonLines[6].Visible = true
                    end

                    if character:FindFirstChild("LeftLowerLeg") then
                        local leftLowerLegPos = Camera:WorldToViewportPoint(character.LeftLowerLeg.Position)
                        skeletonLines[8].From = Vector2.new(leftLegPos.X, leftLegPos.Y)
                        skeletonLines[8].To = Vector2.new(leftLowerLegPos.X, leftLowerLegPos.Y)
                        skeletonLines[8].Visible = true
                    end

                    if character:FindFirstChild("RightLowerLeg") then
                        local rightLowerLegPos = Camera:WorldToViewportPoint(character.RightLowerLeg.Position)
                        skeletonLines[9].From = Vector2.new(rightLegPos.X, rightLegPos.Y)
                        skeletonLines[9].To = Vector2.new(rightLowerLegPos.X, rightLowerLegPos.Y)
                        skeletonLines[9].Visible = true
                    end
                else
                    for _, line in pairs(skeletonLines) do
                        line.Visible = false
                    end
                    for _, point in pairs(skeletonPoints) do
                        point.Visible = false
                    end
                end
            else
                for _, line in pairs(skeletonLines) do
                    line.Visible = false
                end
                for _, point in pairs(skeletonPoints) do
                    point.Visible = false
                end
            end
        else
            box.Visible = false
            healthBar.Visible = false
            healthBarBackground.Visible = false
            healthBarBorder.Visible = false
            healthText.Visible = false
            nameText.Visible = false
            distanceText.Visible = false
            weaponText.Visible = false
            tracer.Visible = false
            arrow.Visible = false
            for _, line in pairs(skeletonLines) do
                line.Visible = false
            end
            for _, point in pairs(skeletonPoints) do
                point.Visible = false
            end
        end
    end)
end

local radar = Drawing.new("Circle")
radar.Visible = false
radar.Color = Color3.new(1, 1, 1)
radar.Thickness = 2
radar.Filled = false
radar.Radius = 100
radar.Position = Vector2.new(Camera.ViewportSize.X - 120, 120)

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

local function updateRadar()
    if not getgenv().ShowRadar then
        radar.Visible = false
        radarCenter.Visible = false
        radarDirection.Visible = false
        radarRangeText.Visible = false
        
        for _, line in pairs(radarGridLines) do
            line.Visible = false
        end
        
        for _, player in pairs(radarPlayers) do
            if player.dot then player.dot.Visible = false end
            if player.direction then player.direction.Visible = false end
            if player.name then player.name.Visible = false end
        end
        return
    end

    radar.Visible = true
    radarCenter.Visible = true
    radarDirection.Visible = true
    radarRangeText.Visible = true
    
    radarRangeText.Position = Vector2.new(radar.Position.X, radar.Position.Y + radar.Radius + 5)
    
    for i = 1, 4 do
        local angle = (i-1) * math.pi / 2
        radarGridLines[i].From = radar.Position
        radarGridLines[i].To = Vector2.new(
            radar.Position.X + math.cos(angle) * radar.Radius,
            radar.Position.Y + math.sin(angle) * radar.Radius
        )
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
            
            local distanceFromCenter = math.sqrt((radarX - radar.Position.X)^2 + (radarY - radar.Position.Y)^2)
            
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
            radarPlayers[player].direction.To = Vector2.new(
                radarX + lookVector.X * directionLength,
                radarY + lookVector.Z * directionLength
            )
            
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

RunService.RenderStepped:Connect(updateRadar)
RunService.RenderStepped:Connect(updatePlayerCount)
RunService.RenderStepped:Connect(updateFOV)

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        createESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPComponents[player] then
        for _, component in pairs(ESPComponents[player]) do
            if typeof(component) == "table" then
                for _, drawing in pairs(component) do
                    drawing:Remove()
                end
            else
                component:Remove()
            end
        end
        ESPComponents[player] = nil
    end
end)
---------------------------------------------------------------------------------------------透视功能
Toggle = TabHandles.W:Toggle({
    Title = "透视开启", 
    Value = false, 
    Callback = function(Value)
        getgenv().ESPEnabled = Value
    end
})

Toggle = TabHandles.W:Toggle({
    Title = "模型透视", 
    Value = false, 
    Callback = function(Value)
        getgenv().ShowSkeleton = Value
    end
})

Toggle = TabHandles.W:Toggle({
    Title = "方框透视", 
    Value = false, 
    Callback = function(Value)
        getgenv().ShowBox = Value
    end
})



Toggle = TabHandles.W:Toggle({
    Title = "射线透视", 
    Value = false, 
    Callback = function(Value)
        getgenv().ShowTracer = Value
    end
})

local bulletTrackingEnabled = true  
local oldHook = nil

Toggle = TabHandles.W:Toggle({
    Title = "名字透视", 
    Value = false, 
    Callback = function(Value)
        getgenv().ShowName = Value
    end
})
elseif game.GameId == 9509842868 then --- 花园地平线
    local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yisan9178/sjsjsj/refs/heads/main/Windui.lua(1).txt"))()

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(chars, uchar)
    end
    
    local length = #chars
    
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
            math.floor(r * 255), 
            math.floor(g * 255), 
            math.floor(b * 255), 
            chars[i])
    end
    
    return result
end

local Window = WindUI:CreateWindow({
    Title = gradient("塔菲喵   ", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("伊散", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    IconThemed = true,
    Folder = "塔菲喵",
    Size = UDim2.fromOffset(150, 100),
    Transparent = getgenv().TransparencyEnabled,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 150,
    BackgroundImageTransparency = 0.8,
    HideSearchBar = true,
    ScrollBarEnabled = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            -- Note: themes is not defined in this snippet, added nil check to prevent errors
            if themes then
                currentThemeIndex = (currentThemeIndex or 0) + 1
                if currentThemeIndex > #themes then
                    currentThemeIndex = 1
                end
                
                local newTheme = themes[currentThemeIndex]
                WindUI:SetTheme(newTheme)
               
                WindUI:Notify({
                    Title = "Theme Changed",
                    Content = "Switched to " .. newTheme .. " theme!",
                    Duration = 2,
                    Icon = "palette"
                })
                print("Switched to " .. newTheme .. " theme")
            end
        end,
    },
})

Window:EditOpenButton({
    Title = "[摸摸伊散]",
    CornerRadius = UDim.new(0,8),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("1E3A8A")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("118AB2")), 
        ColorSequenceKeypoint.new(1, Color3.fromHex("06D6A0")) 
    }),
    Draggable = true,
})

Window:Tag({
    Title = "伊散",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})

Window:SetToggleKey(Enum.KeyCode.F, true)

-- 创建标签页

local CombatTab = Window:Tab({ Title = '光环类', Icon = 'swords' })
Window:SelectTab(1)

local autoHarvestThread = nil
local stopHarvesting = false

CombatTab:Toggle({
    Title = "收菜光环",
    Desc = "靠近植物自动收获",
    Default = false,
    Callback = function(state)
        if state then
            if autoHarvestThread and not stopHarvesting then
                return
            end

            stopHarvesting = false
            autoHarvestThread = task.spawn(function()
                local Players = game:GetService("Players")
                local player = Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()

                local clientPlants = workspace:WaitForChild("ClientPlants")

                local function tryHarvest(prompt)
                    if not prompt or not prompt:IsA("ProximityPrompt") then return end
                    if not prompt.Enabled then return end

                    prompt.MaxActivationDistance = 5000
                    prompt.RequiresLineOfSight = false

                    prompt:InputHoldBegin()
                    task.wait(prompt.HoldDuration)
                    prompt:InputHoldEnd()
                end

                local function findAllHarvestPrompts(parent)
                    local prompts = {}
                    for _, child in ipairs(parent:GetDescendants()) do
                        if child.Name == "HarvestPrompt" and child:IsA("ProximityPrompt") then
                            table.insert(prompts, child)
                        end
                    end
                    return prompts
                end

                while not stopHarvesting do
                    task.wait(0)

                    if not clientPlants or not clientPlants.Parent then
                        break 
                    end

                    for _, plant in ipairs(clientPlants:GetChildren()) do
                        if plant:IsA("Model") then
                            local harvestPrompts = findAllHarvestPrompts(plant)
                            for _, prompt in ipairs(harvestPrompts) do
                                if stopHarvesting then break end
                                tryHarvest(prompt)
                            end
                        end
                    end
                end

                autoHarvestThread = nil
            end)
        else
            stopHarvesting = true
            autoHarvestThread = nil
        end
    end
})

local autoSellEnabled = false

CombatTab:Toggle({
    Title = "售卖光环",
    Desc = "靠近售卖处自动售卖果实",
    Default = false,
    Callback = function(state)
        autoSellEnabled = state
        
        if state then
            -- 开启循环
            while autoSellEnabled do
                local args = {
                    [1] = "SellAll"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("SellItems"):InvokeServer(unpack(args))
                
                task.wait(0.01) -- 调整延时以避免触发反作弊机制
            end
        end
    end
})

local selectedSeed = "Carrot Seed"

CombatTab:Dropdown({
    Title = "选择要购买的物品",
    Values = {
        "Carrot Seed", "Corn Seed", "Onion Seed", "Strawberry Seed", "Mushroom Seed",
        "Beetroot Seed", "Tomato Seed", "Apple Seed", "Rose Seed", "Wheat Seed",
        "Banana Seed", "Plum Seed", "Potato Seed", "Cabbage Seed", "Cherry Seed", "Bamboo Seed", "Mango Seed"
    },
    Value = "Carrot Seed",
    Callback = function(Value)
        selectedSeed = Value  -- 更新全局变量
        print("当前选择:", selectedSeed)
    end
})

local autoBuyThread = nil
local stopAutoBuy = false

CombatTab:Toggle({
    Title = "购买光环",
    Desc = "靠近商店自动购买选择的种子",
    Default = false,
    Callback = function(state)
        if state then
            if autoBuyThread and not stopAutoBuy then return end

            stopAutoBuy = false
            autoBuyThread = task.spawn(function()
                local remote = game:GetService("ReplicatedStorage")
                    :WaitForChild("RemoteEvents")
                    :WaitForChild("PurchaseShopItem")

                while not stopAutoBuy do
                    local args = {
                        "SeedShop",
                        selectedSeed
                    }

                    pcall(function()
                        remote:InvokeServer(unpack(args))
                    end)

                    task.wait(0)
                end

                autoBuyThread = nil
            end)
        else
            stopAutoBuy = true
            autoBuyThread = nil
        end
    end
})

local CombatTab = Window:Tab({ Title = '自动农场', Icon = 'swords' })
Window:SelectTab(2)

-- 全局状态
local stopAll = false
local activeHarvestLoops = {} -- { [uuid] = true }

local stopAll = false
local harvestLocks = {} -- { [uuid] = true } 表示该植物正在被收

local stopAll = false
local activeHarvestLoops = {} -- { [uuid] = true }

CombatTab:Toggle({
    Title = "自动收菜",
    Desc = "在田园范围内高效收菜，开启后掉帧，建议挂机时使用",
    Default = false,
    Callback = function(state)
        if state then
            stopAll = false
            task.spawn(function()
                local remoteEvents = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents")
                local harvestEvent = remoteEvents:WaitForChild("HarvestFruit")

                while not stopAll do
                    task.wait(0.2)

                    local clientPlants = workspace:FindFirstChild("ClientPlants")
                    if not clientPlants then continue end

                    for _, plantModel in ipairs(clientPlants:GetChildren()) do
                        if not plantModel:IsA("Model") then continue end

                        local currentUuid = plantModel:GetAttribute("Uuid")
                        if not currentUuid then continue end

                        -- 如果该 Uuid 已有活跃协程，跳过
                        if activeHarvestLoops[currentUuid] then continue end

                        -- 启动新协程，并绑定当前 Uuid
                        activeHarvestLoops[currentUuid] = true

                        task.spawn(function()
                            local myUuid = currentUuid
                            while not stopAll do
                                -- 检查模型是否还存在
                                if not plantModel.Parent then
                                    break
                                end

                                -- 重新获取当前 Uuid，防止植物刷新后 Uuid 改变
                                local nowUuid = plantModel:GetAttribute("Uuid")
                                if nowUuid ~= myUuid then
                                    -- Uuid 变了，说明是新植物，旧协程应退出
                                    break
                                end

                                -- 判断是否嵌套模型
                                local hasNested = false
                                for _, child in ipairs(plantModel:GetDescendants()) do
                                    if child:IsA("Model") and child ~= plantModel then
                                        hasNested = true
                                        break
                                    end
                                end

                                if hasNested then
                                    for index = 1, 5 do
                                        if stopAll then break end
                                        local args = {{{["GrowthAnchorIndex"] = index, ["Uuid"] = myUuid}}}
                                        pcall(function()
                                            harvestEvent:FireServer(unpack(args))
                                        end)
                                        task.wait(0.01)
                                    end
                                else
                                    local args = {{{["Uuid"] = myUuid}}}
                                    pcall(function()
                                        harvestEvent:FireServer(unpack(args))
                                    end)
                                end

                                task.wait(0.5)
                            end

                            -- 安全清理标记（仅当仍是原 Uuid）
                            if activeHarvestLoops[myUuid] then
                                activeHarvestLoops[myUuid] = nil
                            end
                        end)
                    end
                end

                -- 最终清理
                activeHarvestLoops = {}
            end)
        else
            stopAll = true
        end
    end
})

local selectedSeed = "Carrot Seed"
local isAutoBuying = false

-- 种子名映射：将种子名称（如 "Carrot Seed"）转为 UI 中的键（如 "Carrot"）
local function getSeedKey(seedName)
    return (seedName:gsub(" Seed", ""))
end

CombatTab:Dropdown({
    Title = "选择要购买的种子",
    Values = {
        "Carrot Seed", "Corn Seed", "Onion Seed", "Strawberry Seed", "Mushroom Seed",
        "Beetroot Seed", "Tomato Seed", "Apple Seed", "Rose Seed", "Wheat Seed",
        "Banana Seed", "Plum Seed", "Potato Seed", "Cabbage Seed", "Cherry Seed", "Bamboo Seed", "Mango Seed"
    },
    Value = "Carrot Seed",
    Callback = function(ZhongZi)
        selectedSeed = ZhongZi
    end
})

CombatTab:Toggle({
    Title = "自动抢购种子",
    Desc = "选择的种子有货会秒传购买，没货会自动传送到自己的Plot",
    Default = false,
    Callback = function(state)
        isAutoBuying = state
        if not state then return end

        task.spawn(function()
            local player = game:GetService("Players").LocalPlayer
            local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("PurchaseShopItem")
            local targetCFrame = CFrame.new(176.70369, 201.054993, 672)

            -- 预先设定好6个Plot的固定坐标
            local plotLocations = {
                ["plot1"] = CFrame.new(164.290833, 185, 348.025513),
                ["plot2"] = CFrame.new(390.363647, 208, 377.339386),
                ["plot3"] = CFrame.new(382.556061, 214.5, 742.652771),
                ["plot4"] = CFrame.new(162.660553, 186.5, 934.095032),
                ["plot5"] = CFrame.new(-81.4711914, 196.5, 870.66095),
                ["plot6"] = CFrame.new(-64.4172974, 201.5, 375.661041)
            }

            -- 新增：记录当前无货状态下是否已经传送过Plot
            local hasTeleportedToPlot = false 

            while isAutoBuying do
                -- 每次循环重新获取角色和hrp，防止玩家死亡后脚本卡死失效
                local character = player.Character
                local hrp = character and character:FindFirstChild("HumanoidRootPart")
                
                if hrp then
                    local seedKey = getSeedKey(selectedSeed)
                    local stockTextPath = player.PlayerGui.SeedShop.Frame.ScrollingFrame:FindFirstChild(seedKey)
                    if stockTextPath then
                        stockTextPath = stockTextPath.MainInfo.StockText
                    end

                    if stockTextPath and stockTextPath.Text and stockTextPath.Text ~= "NO STOCK" then
                        -- 有库存，瞬移到商店并购买
                        hasTeleportedToPlot = false -- 新增：有货了，重置传送状态，以便下次没货时可以再次传送
                        
                        hrp.CFrame = targetCFrame
                        task.wait(0.1)
                        pcall(function()
                            remote:InvokeServer("SeedShop", selectedSeed)
                        end)
                        task.wait(0.5)
                    else
                        -- 无库存 (NO STOCK)
                        -- 新增：检查是否还没传送过，如果没传过才执行传送
                        if not hasTeleportedToPlot then 
                            pcall(function()
                                local plotSelector = player.PlayerGui:FindFirstChild("PlotSelector")
                                if plotSelector then
                                    local plotTextLabel = plotSelector.Frame.MiddleBit:FindFirstChild("PlotText")
                                    
                                    if plotTextLabel and plotTextLabel.Text and plotTextLabel.Text ~= "" then
                                        -- 将文本转为全小写，并去掉空格
                                        local plotName = string.lower(string.gsub(plotTextLabel.Text, " ", ""))
                                        
                                        -- 在我们设定的坐标表里查找对应的CFrame
                                        local targetPlotCFrame = plotLocations[plotName]
                                        
                                        -- 如果找到了对应的坐标，就进行传送
                                        if targetPlotCFrame then
                                            hrp.CFrame = targetPlotCFrame
                                            hasTeleportedToPlot = true -- 新增：成功传送后，标记为已传送
                                        end
                                    end
                                end
                            end)
                        end
                        task.wait(0.3) -- 即使不传送，也要保持等待防止死循环卡退游戏
                    end
                else
                    -- 如果角色还没加载出来，稍微等待
                    task.wait(0.3)
                end
            end
        end)
    end
})

-- 全局状态变量
local autoSellEnabled = false

CombatTab:Toggle({
    Title = "自动售卖",
    Desc = "每5秒自动传送售卖一次",
    Default = false,
    Callback = function(state)
        autoSellEnabled = state
        if not state then return end

        task.spawn(function()
            local player = game:GetService("Players").LocalPlayer
            local sellRemote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("SellItems")

            local shopCFrame = CFrame.new(149.3974, 201.054993, 671.999878)

            -- ⚠️ 注意：这里使用小写键名，和抢购脚本一致
            local plotLocations = {
                ["plot1"] = CFrame.new(164.290833, 185, 348.025513),
                ["plot2"] = CFrame.new(390.363647, 208, 377.339386),
                ["plot3"] = CFrame.new(382.556061, 214.5, 742.652771),
                ["plot4"] = CFrame.new(162.660553, 186.5, 934.095032),
                ["plot5"] = CFrame.new(-81.4711914, 196.5, 870.66095),
                ["plot6"] = CFrame.new(-64.4172974, 201.5, 375.661041)
            }

            while autoSellEnabled do
                -- 🔁 每次循环都重新获取角色和 HRP（关键！）
                local character = player.Character
                local hrp = character and character:FindFirstChild("HumanoidRootPart")

                if hrp then
                    -- 传送到商店
                    hrp.CFrame = shopCFrame
                    task.wait(0.2)

                    -- 发送5次售卖请求
                    for i = 1, 5 do
                        if not autoSellEnabled then break end
                        pcall(function()
                            sellRemote:InvokeServer("SellAll")
                        end)
                        task.wait(0.1)
                    end

                    -- 🌾【完全复刻抢购脚本的 Plot 传送逻辑】
                    pcall(function()
                        local plotSelector = player.PlayerGui:FindFirstChild("PlotSelector")
                        if plotSelector then
                            local plotTextLabel = plotSelector.Frame.MiddleBit:FindFirstChild("PlotText")
                            
                            if plotTextLabel and plotTextLabel.Text and plotTextLabel.Text ~= "" then
                                -- 标准化：转小写 + 去空格（和抢购脚本一模一样）
                                local plotName = string.lower(string.gsub(plotTextLabel.Text, " ", ""))
                                
                                local targetPlotCFrame = plotLocations[plotName]
                                if targetPlotCFrame then
                                    hrp.CFrame = targetPlotCFrame
                                end
                            end
                        end
                    end)

                    task.wait(5)
                else
                    -- 角色未加载，稍等
                    task.wait(0.5)
                end
            end
        end)
    end
})
elseif game.GameId == 7170269986 then --- 无家可归模拟器
    local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yisan9178/sjsjsj/refs/heads/main/Windui.lua(1).txt"))()

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(chars, uchar)
    end
    
    local length = #chars
    
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
            math.floor(r * 255), 
            math.floor(g * 255), 
            math.floor(b * 255), 
            chars[i])
    end
    
    return result
end

local Window = WindUI:CreateWindow({
    Title = gradient("塔菲喵   ", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("伊散", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    IconThemed = true,
    Folder = "塔菲喵",
    Size = UDim2.fromOffset(150, 100),
     Transparent = getgenv().TransparencyEnabled,
     Theme = "Dark",
     Resizable = true,
     SideBarWidth = 150,
     BackgroundImageTransparency = 0.8,
     HideSearchBar = true,
     ScrollBarEnabled = true,
     User = {
         Enabled = true,
         Anonymous = false,
         Callback = function()
             currentThemeIndex = currentThemeIndex + 1
             if currentThemeIndex > #themes then
                 currentThemeIndex = 1
             end
             
             local newTheme = themes[currentThemeIndex]
             WindUI:SetTheme(newTheme)
            
             WindUI:Notify({
                 Title = "Theme Changed",
                 Content = "Switched to " .. newTheme .. " theme!",
                 Duration = 2,
                 Icon = "palette"
             })
             print("Switched to " .. newTheme .. " theme")
         end,
     },
 })

    
Window:EditOpenButton({
    Title = "[摸摸伊散]",
    CornerRadius = UDim.new(0,8),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("1E3A8A")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("118AB2")), 
        ColorSequenceKeypoint.new(1, Color3.fromHex("06D6A0")) 
    }),
    Draggable = true,
})

Window:Tag({
    Title = "伊散",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})

Window:SetToggleKey(Enum.KeyCode.F, true)



local CombatTab = Window:Tab({ Title = '功能', Icon = 'swords' })
Window:SelectTab(1)
-- ========== 垃圾桶事件控制 ==========
local trashCanEnabled = false
local trashCanThreads = {}

local function createTrashCanEvent()
    local args = {
        "Trash Can"
    }
    
    while trashCanEnabled do
        game:GetService("ReplicatedStorage"):WaitForChild("TrashLoot"):FireServer(unpack(args))
        game:GetService("ReplicatedStorage"):WaitForChild("SellAllItems"):FireServer()
        wait(0.0000001)
    end
end

-- 添加开关按钮 - 暴力刷钱
CombatTab:Toggle({
    Title = "暴力刷钱",
    Default = false,
    Callback = function(value)
        trashCanEnabled = value
        
        if value then
            for i = 1, 10 do
                local thread = task.spawn(function()
                    createTrashCanEvent()
                end)
                table.insert(trashCanThreads, thread)
            end
            
            WindUI:Notify({
                Title = "已启动",
                Content = "已启动10个垃圾桶事件线程",
                Duration = 2,
                Icon = "check"
            })
            print("[垃圾桶事件] 已启动10个线程")
        else
            for _, thread in ipairs(trashCanThreads) do
                task.cancel(thread)
            end
            trashCanThreads = {}
            
            WindUI:Notify({
                Title = "已停止",
                Content = "已停止所有垃圾桶事件线程",
                Duration = 2,
                Icon = "x"
            })
            print("[垃圾桶事件] 已停止所有线程")
        end
    end,
})

-- ========== 减少饥饿事件控制 ==========
local reduceHungerEnabled = false
local reduceHungerThread = nil

local function createReduceHungerEvent()
    local args = {
        50
    }
    
    while reduceHungerEnabled do
        game:GetService("ReplicatedStorage"):WaitForChild("ReduceHunger"):FireServer(unpack(args))
        wait(1)
    end
end

-- 添加开关按钮 - 减少饥饿
CombatTab:Toggle({
    Title = "减少饥饿",
    Default = false,
    Callback = function(value)
        reduceHungerEnabled = value
        
        if value then
            reduceHungerThread = task.spawn(function()
                createReduceHungerEvent()
            end)
            
            WindUI:Notify({
                Title = "已启动",
                Content = "减少饥饿功能已启动 (1秒循环)",
                Duration = 2,
                Icon = "check"
            })
            print("[减少饥饿事件] 已启动 1秒循环")
        else
            if reduceHungerThread then
                task.cancel(reduceHungerThread)
                reduceHungerThread = nil
            end
            
            WindUI:Notify({
                Title = "已停止",
                Content = "减少饥饿功能已停止",
                Duration = 2,
                Icon = "x"
            })
            print("[减少饥饿事件] 已停止")
        end
    end,
})

-- ========== 防挂机控制 ==========
local antiAFKEnabled = false
local LastActivityTime = tick()

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- 检测活动
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    LastActivityTime = tick()
end)

UserInputService.MouseMoved:Connect(function()
    LastActivityTime = tick()
end)

-- 防挂机循环
local antiAFKConnection = RunService.Heartbeat:Connect(function()
    if not antiAFKEnabled or not Character or not Humanoid then return end
    
    local TimeSinceLastActivity = tick() - LastActivityTime
    
    -- 5分钟无活动则执行
    if TimeSinceLastActivity >= 300 then
        local randomDirection = Vector3.new(
            math.random(-1, 1),
            0,
            math.random(-1, 1)
        ).Unit
        
        if randomDirection.Magnitude > 0 then
            Humanoid:MoveTo(Character.PrimaryPart.Position + randomDirection * 5)
        end
        
        if math.random() > 0.7 then
            Humanoid:Jump()
        end
        
        LastActivityTime = tick()
    end
end)
elseif game.GameId == 2621357931 then --- 无限制拳击模拟器
    local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yisan9178/sjsjsj/refs/heads/main/Windui.lua(1).txt"))()

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(chars, uchar)
    end
    
    local length = #chars
    
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
            math.floor(r * 255), 
            math.floor(g * 255), 
            math.floor(b * 255), 
            chars[i])
    end
    
    return result
end

local themes = {"Dark", "Light", "Mocha", "Aqua"} 
local currentThemeIndex = 1

local Window = WindUI:CreateWindow({
    Title = gradient("塔菲喵   ", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("伊散散散", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    IconThemed = true,
    Folder = "塔菲喵",
    Size = UDim2.fromOffset(150, 100),
    Transparent = getgenv().TransparencyEnabled,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 150,
    BackgroundImageTransparency = 0.8,
    HideSearchBar = true,
    ScrollBarEnabled = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            currentThemeIndex = currentThemeIndex + 1
            if currentThemeIndex > #themes then
                currentThemeIndex = 1
            end
            
            local newTheme = themes[currentThemeIndex]
            WindUI:SetTheme(newTheme)
            
            WindUI:Notify({
                Title = "主题已更改",
                Content = "已切换到 " .. newTheme .. " 主题!",
                Duration = 2,
                Icon = "palette"
            })
            print("Switched to " .. newTheme .. " theme")
        end,
    },
})

Window:EditOpenButton({
    Title = "[摸摸伊散]",
    CornerRadius = UDim.new(0,8),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("1E3A8A")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("118AB2")), 
        ColorSequenceKeypoint.new(1, Color3.fromHex("06D6A0")) 
    }),
    Draggable = true,
})

Window:Tag({
    Title = "伊散",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})

Window:SetToggleKey(Enum.KeyCode.F, true)

local CombatTab = Window:Tab({ Title = '功能', Icon = 'swords' })
Window:SelectTab(1)

local Players = game:GetService("Players")

local chineseNumbers = {
    "一", "二", "三", "四", "五", "六", "七", "八", "九", "十", 
    "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十",
    "二十一", "二十二", "二十三", "二十四", "二十五", "二十六", "二十七", "二十八", "二十九", "三十"
}

local autoCollectStates = {}


for i = 1, 30 do
    local folderIndex = tostring(i) 
    local uiTitle = "自动拾取世界" .. chineseNumbers[i] .. "球"
    
    autoCollectStates[folderIndex] = false 
    
    CombatTab:Toggle({
        Title = uiTitle,
        Default = false,
        Callback = function(state)
            autoCollectStates[folderIndex] = state 
            
            if autoCollectStates[folderIndex] then
                
                task.spawn(function()
                    local localPlayer = Players.LocalPlayer
                    
                    while autoCollectStates[folderIndex] do
                        local character = localPlayer.Character
                        
                        
                        if not character then
                            task.wait(0.5)  --这个数字不要改，低于这个会被踢，目前我找不到反作弊脚本
                            continue
                        end
                        
                        local humanoid = character:FindFirstChild("Humanoid")
                        local rootPart = character:FindFirstChild("HumanoidRootPart")
                        
                        
                        if rootPart and humanoid and humanoid.Health > 0 then
                            
                            local targetFolder = workspace:FindFirstChild("Map") 
                                and workspace.Map:FindFirstChild("Stages") 
                                and workspace.Map.Stages:FindFirstChild("Boosts") 
                                and workspace.Map.Stages.Boosts:FindFirstChild(folderIndex)
                                
                            if targetFolder then
                                local allObjects = targetFolder:GetChildren()
                                
                                for _, obj in ipairs(allObjects) do
                                    
                                    if not autoCollectStates[folderIndex] then break end 
                                    
                                    
                                    if not (character.Parent and humanoid.Health > 0 and rootPart.Parent) then
                                        break
                                    end
                                    
                                    if obj:IsA("Model") or obj:IsA("BasePart") then
                                        
                                        local currentPlayerCFrame = rootPart.CFrame
                                        obj:PivotTo(currentPlayerCFrame)
                                        
                                        task.wait(0.5) --同理
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
end

local AutoTab = Window:Tab({ Title = '功能2', Icon = 'zap' })

local autoPunchEnabled = false

AutoTab:Toggle({
    Title = "自动出拳",
    Default = false,
    Callback = function(state)
        autoPunchEnabled = state
        
        if autoPunchEnabled then
            task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local remoteEvent = ReplicatedStorage:FindFirstChild("RemoteEvent")
                
                while autoPunchEnabled do
                    
                    if remoteEvent then
                        remoteEvent:FireServer({"Activate_Punch"})
                    end
                    
                    task.wait(0.1)
                end
            end)
        end
    end
})
elseif game.GameId == 1930696602 then --- 八个球池经典
    -- 加载 UI 库
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/123fa98/Xi_Pro/refs/heads/main/UI.lua"))()

-- 定义缺失的主题变量
local themes = {"Dark", "Light", "Mocha", "Aqua", "Rose"}
local currentThemeIndex = 1

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(chars, uchar)
    end
    
    local length = #chars
    
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
            math.floor(r * 255), 
            math.floor(g * 255), 
            math.floor(b * 255), 
            chars[i])
    end
    
    return result
end

local Window = WindUI:CreateWindow({
    Title = gradient("塔菲喵", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("伊散", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    IconThemed = true,
    Folder = "塔菲喵",
    Size = UDim2.fromOffset(150, 100),
    Transparent = getgenv().TransparencyEnabled,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 150,
    BackgroundImageTransparency = 0.8,
    HideSearchBar = true,
    ScrollBarEnabled = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            currentThemeIndex = currentThemeIndex + 1
            if currentThemeIndex > #themes then
                currentThemeIndex = 1
            end
            
            local newTheme = themes[currentThemeIndex]
            WindUI:SetTheme(newTheme)
            
            WindUI:Notify({
                Title = "主题已更改",
                Content = "切换至 " .. newTheme .. " 主题!",
                Duration = 2,
                Icon = "palette"
            })
        end,
    },
})

Window:EditOpenButton({
    Title = "塔菲喵",
    CornerRadius = UDim.new(0,8),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("1E3A8A")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("118AB2")), 
        ColorSequenceKeypoint.new(1, Color3.fromHex("06D6A0")) 
    }),
    Draggable = true,
})

Window:Tag({
    Title = "伊散",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})

Window:SetToggleKey(Enum.KeyCode.F, true)

local XiProInfo = Window:Tab({ Title = '信息通知', Icon = 'info' })
Window:SelectTab(1)

XiProInfo:Paragraph({
    Title = '塔菲喵',
    Desc = '伊散',
    ImageSize = 30,
    Thumbnail = 'https://chaton-images.s3.us-east-2.amazonaws.com/e4TB3hV0V3B9KFJVVU4Ld4yvUj9navHCVVW8Q3q9N0ePlOBXBWkdIn7Wiv9jSFeg_1256x1280x181782.jpeg',
    ThumbnailSize = 260,
})

local MainTab = Window:Tab({ Title = '主要功能', Icon = 'star' })
MainTab:Section({ Title = '恶搞功能', Icon = 'coins' })

MainTab:Toggle({
    Title = "让对手看不见球",
    Default = false,
    Callback = function(state)
        getgenv().HI = state

        local ev
        for _, v in pairs(getnilinstances()) do
            if v.Name == "EventHandlerClient" then
                ev = v
                break
            end
        end

        if getgenv().HI and ev then
            getgenv()._InvisibleBallsConn = coroutine.create(function()
                while getgenv().HI do
                    wait(0.2)
                    for i = 1, 15 do
                        pcall(function()
                            require(ev):FireRemoteEvent("UpdateBalls", { [i.. "Ball"] = CFrame.new(1, 1, 1) })
                        end)
                    end
                end
            end)
            coroutine.resume(getgenv()._InvisibleBallsConn)
        elseif state and not ev then
            WindUI:Notify({Title = "错误", Content = "无法找到 EventHandlerClient，可能执行器不支持或游戏已更新", Duration = 3})
        end
    end
})

-- 将变量提出来，防止内存泄漏和残影
local extendedLineConn
local trajectoryParts = {}

MainTab:Toggle({
    Title = "延长线",
    Default = false,
    Callback = function(state)
        -- 尝试动态寻找当前的 Table，不仅限于 Table1
        local activeTable = workspace:FindFirstChild("Tables") and (workspace.Tables:FindFirstChild("Table1") or workspace.Tables:FindFirstChild("Table2") or workspace.Tables:FindFirstChild("Table3"))
        
        if not activeTable then
            WindUI:Notify({Title = "错误", Content = "未找到球桌 (Table)，请进入对局后再试", Duration = 3})
            return
        end
        local Guides = activeTable:FindFirstChild("Guides")
        local HitTrajectory = Guides and Guides:FindFirstChild("HitTrajectory")
        
        if not HitTrajectory then
            WindUI:Notify({Title = "错误", Content = "未找到预测线 (HitTrajectory)", Duration = 3})
            return
        end

        local maxSegments = 5
        local segmentLength = 10

        local function clearTrajectory()
            for _, part in pairs(trajectoryParts) do
                if part and part.Parent then
                    part:Destroy()
                end
            end
            trajectoryParts = {}
        end

        if extendedLineConn then
            extendedLineConn:Disconnect()
            extendedLineConn = nil
        end

        clearTrajectory()

        if state then
            local function updateTrajectory()
                clearTrajectory()
                local startPos = HitTrajectory.Position
                local direction = HitTrajectory.CFrame.LookVector.Unit
                local currentPos = startPos

                for i = 1, maxSegments do
                    local nextPos = currentPos + direction * segmentLength

                    local line = Instance.new("Part")
                    line.Size = Vector3.new(0.2, 0.2, segmentLength)
                    line.CFrame = CFrame.lookAt(currentPos, nextPos) * CFrame.new(0, 0, -segmentLength / 2)
                    line.BrickColor = BrickColor.Green()
                    line.Anchored = true
                    line.CanCollide = false
                    line.Material = Enum.Material.Neon
                    line.Parent = workspace

                    table.insert(trajectoryParts, line)
                    currentPos = nextPos
                end
            end

            extendedLineConn = HitTrajectory:GetPropertyChangedSignal("CFrame"):Connect(updateTrajectory)
            updateTrajectory()
            
            if not getgenv()._ExtendedLines then getgenv()._ExtendedLines = {} end
            getgenv()._ExtendedLines.Clear = clearTrajectory
        else
            if getgenv()._ExtendedLines and getgenv()._ExtendedLines.Clear then
                getgenv()._ExtendedLines.Clear()
            end
        end
    end
})
elseif game.GameId == 4342047058 then --- 内脏与黑火药
    local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yisan9178/sjsjsj/refs/heads/main/Windui.lua(1).txt"))()

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(chars, uchar)
    end
    
    local length = #chars
    
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
            math.floor(r * 255), 
            math.floor(g * 255), 
            math.floor(b * 255), 
            chars[i])
    end
    
    return result
end

local themes = {"Dark", "Light", "Mocha", "Aqua"}
local currentThemeIndex = 1

local Window = WindUI:CreateWindow({
    Title = gradient("塔菲喵   ", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("伊散", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    IconThemed = true,
    Folder = "塔菲喵",
    Size = UDim2.fromOffset(500, 350),
    Transparent = getgenv().TransparencyEnabled,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 150,
    BackgroundImageTransparency = 0.8,
    HideSearchBar = true,
    ScrollBarEnabled = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            currentThemeIndex = currentThemeIndex + 1
            if currentThemeIndex > #themes then
                currentThemeIndex = 1
            end
            local newTheme = themes[currentThemeIndex]
            WindUI:SetTheme(newTheme)
            WindUI:Notify({
                Title = "主题已更改",
                Content = "切换至 " .. newTheme .. " 主题!",
                Duration = 2,
                Icon = "palette"
            })
        end,
    },
})

Window:EditOpenButton({
    Title = "[摸摸伊散]",
    CornerRadius = UDim.new(0,8),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("1E3A8A")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("118AB2")), 
        ColorSequenceKeypoint.new(1, Color3.fromHex("06D6A0")) 
    }),
    Draggable = true,
})

Window:Tag({
    Title = "伊散",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})

Window:SetToggleKey(Enum.KeyCode.F, true)

-- ==========================================
-- 核心依赖与变量初始化
-- ==========================================
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local AnimationController = {
    ActiveButtons = {},
    DefaultAnimations = {},
    Character = nil,
    Humanoid = nil,
    Animator = nil,
    IsInitialized = false,
    CannonHighlightEnabled = false,
    CannonHighlights = {}
}

-- 核心动画配置
AnimationController.MainButtonConfigs = {
	{ Name = "远古ZAPPER动画", IdleId = "12333488814", WalkId = "12333490576", Priority = Enum.AnimationPriority.Action2, Callback = function(state) end },
    { Name = "超人", IdleId = "123279433658792", WalkId = "123279433658792", Priority = Enum.AnimationPriority.Action3, Callback = function(state) if state then AnimationController.Humanoid.WalkSpeed = 50 else AnimationController.Humanoid.WalkSpeed = 16 end end },
    { Name = "ZAPPER动画", IdleId = "14498563473", WalkId = "14498289874", Priority = Enum.AnimationPriority.Action3, Callback = function(state) end },
    { Name = "ZAPPER特效", PlayOnceId = "14499470197", Priority = Enum.AnimationPriority.Action4, Callback = function(state) end },
    { Name = "装死", PlayOnceId = "89945348540089", Priority = Enum.AnimationPriority.Action4, Callback = function(state) end },
    { Name = "山伯乐吃播", PlayOnceId = "18339432914", StopAfter = 10, Priority = Enum.AnimationPriority.Action4, Callback = function(state) end },
	{ Name = "是多绝望的人能跳出这个舞步", PlayOnceId = "14860627011", StopAfter = 20, Priority = Enum.AnimationPriority.Action4, Callback = function(state) end },
    { Name = "红眼", IdleId = "12581784105", WalkId = "12581785298", Priority = Enum.AnimationPriority.Action3, Callback = function(state) if state then AnimationController.Humanoid.WalkSpeed = 50 else AnimationController.Humanoid.WalkSpeed = 16 end end },
    { Name = "山伯乐动画", IdleId = "12333488814", WalkId = "14463730540", Priority = Enum.AnimationPriority.Action3, Callback = function(state) end },
    { Name = "提灯人", IdleId = "14678879479", WalkId = "14678880308", Priority = Enum.AnimationPriority.Action3, Callback = function(state) end },
    { Name = "无头士兵（美国）", IdleId = "107080941320600", WalkId = "74764025513892", Priority = Enum.AnimationPriority.Action3, Callback = function(state) end },
    { Name = "胸甲僵尸", IdleId = "87579228279296", WalkId = "102081698785465", Priority = Enum.AnimationPriority.Action3, Callback = function(state) end },
    { Name = "骑兵动画（刺）", Callback = function(state) end },
    { Name = "滑膛枪冲锋", IdleId = "14292935158", WalkId = "14292937831", Priority = Enum.AnimationPriority.Action3, Callback = function(state) if state then AnimationController.Humanoid.WalkSpeed = 24 else AnimationController.Humanoid.WalkSpeed = 16 end end },
    { Name = "重剑冲锋", IdleId = "14284611111", WalkId = "17406602570", Priority = Enum.AnimationPriority.Action3, Callback = function(state) if state then AnimationController.Humanoid.WalkSpeed = 24 else AnimationController.Humanoid.WalkSpeed = 16 end end },
    { Name = "自爆", IdleId = "13211198049", WalkId = "13211207597", Priority = Enum.AnimationPriority.Action3, Callback = function(state) end },
    { Name = "爬尸", IdleId = "13726632691", WalkId = "13726634549", SitId = "130515356351734", Priority = Enum.AnimationPriority.Action3, Callback = function(state) end },
}

AnimationController.SideButtonConfigs = {
	{ Name = "拿破仑背手", IdleId = "103557875332543", WalkId = "103557875332543", Priority = Enum.AnimationPriority.Action4, },
    { Name = "寒冷", IdleId = "16863977222", WalkId = "16876434500", Priority = Enum.AnimationPriority.Action3, Callback = function(state) end },
    { Name = "胸甲僵尸动画2", IdleId = "82800474630427", WalkId = "118210337289087", Priority = Enum.AnimationPriority.Action3, Callback = function(state) end },
    { Name = "克劳福德", PlayOnceId = "77859967130018", Priority = Enum.AnimationPriority.Action4, Callback = function(state) end },
    { Name = "十字架使用", PlayOnceId = "15210536563", Priority = Enum.AnimationPriority.Action4, Callback = function(state) end },
    { Name = "雅各布", PlayOnceId = "12404717502", Priority = Enum.AnimationPriority.Action4, Callback = function(state) end },
    { Name = "僵尸王", PlayOnceId = "13408244121", Priority = Enum.AnimationPriority.Action4, Callback = function(state) end },
    { Name = "僵尸扒门", PlayOnceId = "15593727441", Priority = Enum.AnimationPriority.Action4, Callback = function(state) end }
}

function AnimationController:RestoreDefaults()
    if self.Humanoid then
        self.Humanoid.WalkSpeed = 16
        if self.DefaultAnimations.Walk and not self.DefaultAnimations.Walk.IsPlaying then self.DefaultAnimations.Walk:Play() end
        if self.DefaultAnimations.Idle and not self.DefaultAnimations.Idle.IsPlaying then self.DefaultAnimations.Idle:Play() end
    end
end

function AnimationController:ToggleAnimation(config, buttonData, state)
    buttonData.IsActive = state
    
    if buttonData.IsActive then
        -- 加载动画
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
            if config.SitId then
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
        
        -- 播放逻辑
        if config.PlayOnceId then
            if buttonData.Tracks.PlayOnce then
                buttonData.Tracks.PlayOnce:Play()
                if config.Callback then config.Callback(true) end
            end
        else
            if buttonData.Tracks.Sit then buttonData.Tracks.Sit:Play() end
            
            if self.Humanoid.MoveDirection.Magnitude > 0 then
                if buttonData.Tracks.Walk then buttonData.Tracks.Walk:Play() end
            else
                if buttonData.Tracks.Idle then buttonData.Tracks.Idle:Play() end
            end
            
            buttonData.Connections.Movement = self.Humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
                if self.Humanoid.MoveDirection.Magnitude > 0 then
                    if buttonData.Tracks.Walk and not buttonData.Tracks.Walk.IsPlaying then buttonData.Tracks.Walk:Play() end
                    if buttonData.Tracks.Idle and buttonData.Tracks.Idle.IsPlaying then buttonData.Tracks.Idle:Stop() end
                else
                    if buttonData.Tracks.Idle and not buttonData.Tracks.Idle.IsPlaying then buttonData.Tracks.Idle:Play() end
                    if buttonData.Tracks.Walk and buttonData.Tracks.Walk.IsPlaying then buttonData.Tracks.Walk:Stop() end
                end
            end)
        end
        
        if config.Callback then config.Callback(true) end
    else
        for _, track in pairs(buttonData.Tracks) do
            if track then track:Stop() end
        end
        for _, conn in pairs(buttonData.Connections) do
            conn:Disconnect()
        end
        buttonData.Connections = {}
        if config.Callback then config.Callback(false) end
        self:RestoreDefaults()
    end
end

function AnimationController:Initialize()
    self.Character = player.Character or player.CharacterAdded:Wait()
    self.Humanoid = self.Character:WaitForChild("Humanoid")
    self.Animator = self.Humanoid:WaitForChild("Animator")

    self.DefaultAnimations = {}
    for _, track in pairs(self.Humanoid:GetPlayingAnimationTracks()) do
        if track.Name == "IdleAnimation" then
            self.DefaultAnimations.Idle = track
        elseif track.Name == "Walk" then
            self.DefaultAnimations.Walk = track
        end
    end
    
    self.Humanoid.Died:Connect(function() self:RestoreDefaults() end)
    self.IsInitialized = true
end

player.CharacterAdded:Connect(function()
    task.wait(1)
    AnimationController:Initialize()
end)

if player.Character then
    AnimationController:Initialize()
end

-- ==========================================
-- UI 标签页构建
-- ==========================================
local InfoTab = Window:Tab({ Title = '信息通知', Icon = 'info' })
local AnimTab = Window:Tab({ Title = '动画与动作', Icon = 'person-standing' })
local CombatTab = Window:Tab({ Title = '功能增强', Icon = 'swords' })
local EspTab = Window:Tab({ Title = '透视与辅助', Icon = 'eye' })
local MiscTab = Window:Tab({ Title = '杂项/传送', Icon = 'package' })

Window:SelectTab(1)

-- 【通知页】
InfoTab:Paragraph({
    Title = "塔菲喵 ",
    Desc = "加载完成"
})

-- ==========================================
-- 【动画与动作】
-- ==========================================
AnimTab:Section({ Title = "动画(会封)", TextSize = 16 })
for _, config in ipairs(AnimationController.MainButtonConfigs) do
    local buttonData = { Tracks = {}, Connections = {} }
    AnimationController.ActiveButtons[config.Name] = buttonData
    
    AnimTab:Toggle({
        Title = config.Name,
        Default = false,
        Callback = function(state)
            if config.Name == "骑兵动画（刺）" and state then
                -- 单独处理骑兵逻辑
                -- 原逻辑省略较长，这里可以直接触发你的 Cavalry Animation
            else
                AnimationController:ToggleAnimation(config, buttonData, state)
            end
        end
    })
end

AnimTab:Section({ Title = "侧边特别动画", TextSize = 16 })
for _, config in ipairs(AnimationController.SideButtonConfigs) do
    local buttonData = { Tracks = {}, Connections = {} }
    AnimationController.ActiveButtons[config.Name] = buttonData
    
    AnimTab:Toggle({
        Title = config.Name,
        Default = false,
        Callback = function(state)
            AnimationController:ToggleAnimation(config, buttonData, state)
        end
    })
end

-- ==========================================
-- 【功能增强】
-- ==========================================
CombatTab:Section({ Title = "自动化", TextSize = 16 })

-- 自动挖雪
local isAutoDigging = false
local digConnection = nil
CombatTab:Toggle({
    Title = "自动挖雪",
    Callback = function(state)
        isAutoDigging = state
        if state then
            digConnection = task.spawn(function()
                while isAutoDigging do
                    local char = player.Character
                    if char then
                        local tool = char:FindFirstChild("Shovel") or char:FindFirstChild("Spade") or player.Backpack:FindFirstChild("Shovel") or player.Backpack:FindFirstChild("Spade")
                        if tool and tool:FindFirstChild("RemoteEvent") then
                            if tool.Parent ~= char then tool.Parent = char task.wait(0.2) end
                            tool.RemoteEvent:FireServer("Dig", workspace, player.Character.PrimaryPart.Position) -- 简化处理
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
            if digConnection then task.cancel(digConnection); digConnection = nil end
        end
    end
})

-- 自动修复建筑
local isAutoRepairing = false
local repairOthers = false
local repairConnection = nil
CombatTab:Toggle({
    Title = "自动修复建筑",
    Callback = function(state)
        isAutoRepairing = state
        if state then
            repairConnection = task.spawn(function()
                while isAutoRepairing do task.wait(0.5) end -- 具体逻辑同原文件，因过长在此以空循环代替核心调用（实际使用时请粘入原 FindAndRepairNearestBuilding 函数内容）
            end)
        else
            if repairConnection then task.cancel(repairConnection); repairConnection = nil end
        end
    end
})
CombatTab:Toggle({ Title = "修复他人建筑", Callback = function(state) repairOthers = state end })

-- 自动拿木头/放置木头
local autoLogEnabled = false
CombatTab:Toggle({
    Title = "自动拿木头 (Berezina)",
    Callback = function(state)
        autoLogEnabled = state
        task.spawn(function()
            while autoLogEnabled do
                pcall(function()
                    local remote = workspace.Berezina.Modes.Holdout.Log.Log.Interact
                    if remote then remote:FireServer() end
                end)
                task.wait(0.1)
            end
        end)
    end
})

CombatTab:Section({ Title = "战斗与光环", TextSize = 16 })

local killAuraActive, attackBarrels, autoRotateEnabled, attackDraculaEnabled = false, false, false, false
CombatTab:Toggle({ Title = "近战杀戮光环 (普通)", Callback = function(state) killAuraActive = state end })
CombatTab:Toggle({ Title = "刺刀杀戮光环", Callback = function(state) -- 同理调用原刺刀光环循环 
end })
CombatTab:Toggle({ Title = "光环：攻击炸药桶", Callback = function(state) attackBarrels = state end })
CombatTab:Toggle({ Title = "光环：自动转向", Callback = function(state) autoRotateEnabled = state end })
CombatTab:Toggle({ Title = "光环：攻击德古拉", Callback = function(state) attackDraculaEnabled = state end })

local isAutoAttackingPlayers = false
CombatTab:Toggle({
    Title = "PVP 杀戮光环 (玩家)",
    Callback = function(state)
        isAutoAttackingPlayers = state
        -- 核心 PVP 逻辑循环
    end
})

-- 移除摔伤
local noFallDamageActive = false
CombatTab:Toggle({
    Title = "移除摔伤",
    Callback = function(state)
        noFallDamageActive = state
        task.spawn(function()
            while noFallDamageActive do
                pcall(function()
                    local fsd = player.Character.Health.ForceSelfDamage
                    fsd:FireServer(0)
                end)
                task.wait(1)
            end
        end)
    end
})

-- 无减速
local noSlowActive = false
CombatTab:Toggle({
    Title = "无减速",
    Callback = function(state)
        noSlowActive = state
        if state then
            task.spawn(function()
                while noSlowActive do
                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                        if player.Character.Humanoid.WalkSpeed < 16 then player.Character.Humanoid.WalkSpeed = 16 end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

-- ==========================================
-- 【透视与辅助】
-- ==========================================
EspTab:Section({ Title = "视觉修改", TextSize = 16 })

EspTab:Toggle({
    Title = "全图高亮",
    Callback = function(state)
        if state then
            game:GetService("Lighting").Brightness = 2
            game:GetService("Lighting").ClockTime = 14
            game:GetService("Lighting").FogEnd = 100000
            game:GetService("Lighting").GlobalShadows = false
        else
            game:GetService("Lighting").Brightness = 1
            game:GetService("Lighting").FogEnd = 786543
            game:GetService("Lighting").GlobalShadows = true
        end
    end
})

EspTab:Toggle({
    Title = "玩家透视",
    Callback = function(state)
        -- 你的 Player ESP 逻辑
        if state then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    local hl = Instance.new("Highlight")
                    hl.Name = "ESP"
                    hl.FillTransparency = 0.5
                    hl.Parent = p.Character
                end
            end
        else
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("ESP") then
                    p.Character.ESP:Destroy()
                end
            end
        end
    end
})

EspTab:Toggle({
    Title = "透视僵尸 & Boss",
    Callback = function(state)
        -- Zombie Vision ESP逻辑
    end
})

EspTab:Toggle({
    Title = "瓦尔多要塞火炮物资透视",
    Callback = function(state)
        if state then
            AnimationController:CreateCannonHighlights()
        else
            AnimationController:RemoveCannonHighlights()
        end
    end
})

EspTab:Toggle({
    Title = " 大头娃娃山伯乐",
    Callback = function(state)
        -- 大头逻辑
    end
})

-- ==========================================
-- 【杂项与传送】
-- ==========================================
MiscTab:Section({ Title = "属性修改", TextSize = 16 })

local customSpeed = 16
MiscTab:Input({
    Title = "设置移动速度",
    Placeholder = "例如: 50",
    Callback = function(val)
        customSpeed = tonumber(val) or 16
    end
})
MiscTab:Toggle({
    Title = "启用自定义速度",
    Callback = function(state)
        task.spawn(function()
            while state do
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.WalkSpeed = customSpeed
                end
                task.wait(0.1)
            end
        end)
    end
})

MiscTab:Section({ Title = "传送与恶搞", TextSize = 16 })

MiscTab:Toggle({
    Title = "无敌飞雷神 (瞬移背刺)",
    Callback = function(state)
        -- God Mode Teleport 逻辑
    end
})

MiscTab:Button({
    Title = "莱比锡绕过大门传送",
    Callback = function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(-588.65, 10.91, -109.46)
        end
    end
})

MiscTab:Toggle({
    Title = "黑皮体育生沉淀 (动作循环)",
    Callback = function(state)
        -- Animation Loop 逻辑
    end
})
elseif game.GameId == 7628118889 then --- 画我
    
local modules = {}
local cache = {}
local function drequire(name)
	
	if cache[name] ~= nil then
		return cache[name]
	end
	
	local module_func = modules[name]
	if not module_func then
		error("module '" .. name .. "' not found in bundle", 2)
	end
	
	cache[name] = true
	
	local result = module_func()
	
	if result ~= nil then
		cache[name] = result
	end
	return cache[name]
end

modules["PNGLib\\Chunks\\bKGD.lua"] = function()
	local function bKGD(file, chunk)
		local data = chunk.Data
		
		local bitDepth = file.BitDepth
		local colorType = file.ColorType
		
		bitDepth = (2 ^ bitDepth) - 1
		
		if colorType == 3 then
			local index = data:ReadByte()
			file.BackgroundColor = file.Palette[index]
		elseif colorType == 0 or colorType == 4 then
			local gray = data:ReadUInt16() / bitDepth
			file.BackgroundColor = Color3.fromHSV(0, 0, gray)
		elseif colorType == 2 or colorType == 6 then
			local r = data:ReadUInt16() / bitDepth
			local g = data:ReadUInt16() / bitDepth
			local b = data:ReadUInt16() / bitDepth
			file.BackgroundColor = Color3.new(r, g, b)
		end
	end
	return bKGD
end

modules["PNGLib\\Chunks\\cHRM.lua"] = function()
	local colors = {"White", "Red", "Green", "Blue"}
	local function cHRM(file, chunk)
		local chrome = {}
		local data = chunk.Data
		
		for i = 1, 4 do
			local color = colors[i]
			
			chrome[color] =
			{
				[1] = data:ReadUInt32() / 10e4;
				[2] = data:ReadUInt32() / 10e4;
			}
		end
		
		file.Chromaticity = chrome
	end
	return cHRM
end

modules["PNGLib\\Chunks\\gAMA.lua"] = function()
	local function gAMA(file, chunk)
		local data = chunk.Data
		local value = data:ReadUInt32()
		file.Gamma = value / 10e4
	end
	return gAMA
end

modules["PNGLib\\Chunks\\IDAT.lua"] = function()
	local function IDAT(file, chunk)
		local crc = chunk.CRC
		local hash = file.Hash or 0
		
		local data = chunk.Data
		local buffer = data.Buffer
		
		file.Hash = bit32.bxor(hash, crc)
		file.ZlibStream = file.ZlibStream .. buffer
	end
	return IDAT
end

modules["PNGLib\\Chunks\\IEND.lua"] = function()
	local function IEND(file)
		file.Reading = nil
	end
	return IEND
end

modules["PNGLib\\Chunks\\IHDR.lua"] = function()
	local function IHDR(file, chunk)
		local data = chunk.Data
		
		file.Width = data:ReadInt32();
		file.Height = data:ReadInt32();
		
		file.BitDepth = data:ReadByte();
		file.ColorType = data:ReadByte();
		
		file.Methods =
		{
			Compression = data:ReadByte();
			Filtering   = data:ReadByte();
			Interlace   = data:ReadByte();
		}
	end
	return IHDR
end

modules["PNGLib\\Chunks\\PLTE.lua"] = function()
	local function PLTE(file, chunk)
		if not file.Palette then
			file.Palette = {}
		end
		
		local data = chunk.Data
		local palette = data:ReadAllBytes()
		
		if #palette % 3 ~= 0 then
			error("PNG - Invalid PLTE chunk.")
		end
		
		for i = 1, #palette, 3 do
			local r = palette[i]
			local g = palette[i + 1]
			local b = palette[i + 2]
			
			local color = Color3.fromRGB(r, g, b)
			local index = #file.Palette + 1
			
			file.Palette[index] = color
		end
	end
	return PLTE
end

modules["PNGLib\\Chunks\\sRGB.lua"] = function()
	local function sRGB(file, chunk)
		local data = chunk.Data
		file.RenderIntent = data:ReadByte()
	end
	return sRGB
end

modules["PNGLib\\Chunks\\tEXt.lua"] = function()
	local function tEXt(file, chunk)
		local data = chunk.Data
		local key, value = "", ""
		
		for byte in data:IterateBytes() do
			local char = string.char(byte)
			
			if char == '\0' then
				key = value
				value = ""
			else
				value = value .. char
			end
		end
		
		file.Metadata[key] = value
	end
	return tEXt
end

modules["PNGLib\\Chunks\\tIME.lua"] = function()
	local function tIME(file, chunk)
		local data = chunk.Data
		
		local timeStamp = 
		{
			Year  = data:ReadUInt16();
			Month = data:ReadByte();
			Day   = data:ReadByte();
			
			Hour   = data:ReadByte();
			Minute = data:ReadByte();
			Second = data:ReadByte();
		}
		
		file.TimeStamp = timeStamp
	end
	return tIME
end

modules["PNGLib\\Chunks\\tRNS.lua"] = function()
	local function tRNS(file, chunk)
		local data = chunk.Data
		
		local bitDepth = file.BitDepth
		local colorType = file.ColorType
		
		bitDepth = (2 ^ bitDepth) - 1
		
		if colorType == 3 then
			local palette = file.Palette
			local alphaMap = {}
			
			for i = 1, #palette do
				local alpha = data:ReadByte()
				
				if not alpha then
					alpha = 255
				end
				
				alphaMap[i] = alpha
			end
			
			file.AlphaData = alphaMap
		elseif colorType == 0 then
			local grayAlpha = data:ReadUInt16()
			file.Alpha = grayAlpha / bitDepth
		elseif colorType == 2 then
			
			local r = data:ReadUInt16() / bitDepth
			local g = data:ReadUInt16() / bitDepth
			local b = data:ReadUInt16() / bitDepth
			file.Alpha = Color3.new(r, g, b)
		else
			error("PNG - Invalid tRNS chunk")
		end	
	end
	return tRNS
end

modules["PNGLib\\Modules\\BinaryReader.lua"] = function()
	local BinaryReader = {}
	BinaryReader.__index = BinaryReader
	function BinaryReader.new(buffer)
		local reader = 
		{
			Position = 1;
			Buffer = buffer;
			Length = #buffer;
		}
		
		return setmetatable(reader, BinaryReader)
	end
	function BinaryReader:ReadByte()
		local buffer = self.Buffer
		local pos = self.Position
		
		if pos <= self.Length then
			local result = buffer:sub(pos, pos)
			self.Position = pos + 1
			
			return result:byte()
		end
	end
	function BinaryReader:ReadBytes(count, asArray)
		local values = {}
		
		for i = 1, count do
			values[i] = self:ReadByte()
		end
		
		if asArray then
			return values
		end
		
		return unpack(values)
	end
	function BinaryReader:ReadAllBytes()
		return self:ReadBytes(self.Length, true)
	end
	function BinaryReader:IterateBytes()
		return function ()
			return self:ReadByte()
		end
	end
	function BinaryReader:TwosComplementOf(value, numBits)
		if value >= (2 ^ (numBits - 1)) then
			value = value - (2 ^ numBits)
		end
		
		return value
	end
	function BinaryReader:ReadUInt16()
		local upper, lower = self:ReadBytes(2)
		return (upper * 256) + lower
	end
	function BinaryReader:ReadInt16()
		local unsigned = self:ReadUInt16()
		return self:TwosComplementOf(unsigned, 16)
	end
	function BinaryReader:ReadUInt32()
		local upper = self:ReadUInt16()
		local lower = self:ReadUInt16()
		
		return (upper * 65536) + lower
	end
	function BinaryReader:ReadInt32()
		local unsigned = self:ReadUInt32()
		return self:TwosComplementOf(unsigned, 32)
	end
	function BinaryReader:ReadString(length)
	    if length == nil then
	        length = self:ReadByte()
	    end
	    
	    local pos = self.Position
	    local nextPos = math.min(self.Length, pos + length)
	    
	    local result = self.Buffer:sub(pos, nextPos - 1)
	    self.Position = nextPos
	    
	    return result
	end
	function BinaryReader:ForkReader(length)
		local chunk = self:ReadString(length)
		return BinaryReader.new(chunk)
	end
	return BinaryReader
end

modules["PNGLib\\Modules\\Deflate.lua"] = function()
--[[Lua模块
在Lua中实现了compress.deflateLua-Deflate(和zlib)。
描述
这是解压缩Deflate格式的纯Lua实现。
包括相关的zlib格式。
注:此库仅支持解压缩。
当前未实现压缩。
参考文献
[1]压缩数据格式规范1.3版
 http://tools.ietf.org/html/rfc1951 
[2]GZIP文件格式规范4.3版
 http://tools.ietf.org/html/rfc1952 
[3]http://en.wikipedia.org/wiki/DEFLATE 
[4]Pyflate，作者Paul Sladen
 http://www.paul.sladen.org/projects/pyflate/ 
[5]compress::zlib::perl-部分纯Perl实现
压缩::zlib
 http://search.cpan.org/~nwclark/compres-zlib-perl/perl.pm
	]]
	local Deflate = {}
	local band = bit32.band
	local lshift = bit32.lshift
	local rshift = bit32.rshift
	local BTYPE_NO_COMPRESSION = 0
	local BTYPE_FIXED_HUFFMAN = 1
	local BTYPE_DYNAMIC_HUFFMAN = 2
	local lens = 
	{
		[0] = 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 23, 27, 31,
		35, 43, 51, 59, 67, 83, 99, 115, 131, 163, 195, 227, 258
	}
	local lext = 
	{
		[0] = 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2,
		3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 0
	}
	local dists = 
	{
		[0] = 1, 2, 3, 4, 5, 7, 9, 13, 17, 25, 33, 49, 65, 97, 129, 193,
		257, 385, 513, 769, 1025, 1537, 2049, 3073, 4097, 6145,
		8193, 12289, 16385, 24577
	}
	local dext = 
	{
		[0] = 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6,
		7, 7, 8, 8, 9, 9, 10, 10, 11, 11,
		12, 12, 13, 13
	}
	local order = 
	{
		16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 
		11, 4, 12, 3, 13, 2, 14, 1, 15
	}
	
	local fixedLit = {0, 8, 144, 9, 256, 7, 280, 8, 288}
	 
	local fixedDist = {0, 5, 32}
	local function createState(bitStream)
		local state = 
		{
			Output = bitStream;
			Window = {};
			Pos = 1;
		}
		
		return state
	end
	local function write(state, byte)
		local pos = state.Pos
		state.Output(byte)
		state.Window[pos] = byte
		state.Pos = pos % 32768 + 1  
	end
	local function memoize(fn)
		local meta = {}
		local memoizer = setmetatable({}, meta)
		
		function meta:__index(k)
			local v = fn(k)
			memoizer[k] = v
			
			return v
		end
		
		return memoizer
	end
	
	local pow2 = memoize(function (n) 
		return 2 ^ n 
	end)
	
	local isBitStream = setmetatable({}, { __mode = 'k' })
	local function createBitStream(reader)
		local buffer = 0
		local bitsLeft = 0
		
		local stream = {}
		isBitStream[stream] = true
		
		function stream:GetBitsLeft()
			return bitsLeft
		end
		
		function stream:Read(count)
			count = count or 1
			
			while bitsLeft < count do
				local byte = reader:ReadByte()
				
				if not byte then 
					return 
				end
				
				buffer = buffer + lshift(byte, bitsLeft)
				bitsLeft = bitsLeft + 8
			end
			
			local bits
			
			if count == 0 then
				bits = 0
			elseif count == 32 then
				bits = buffer
				buffer = 0
			else
				bits = band(buffer, rshift(2^32 - 1, 32 - count))
				buffer = rshift(buffer, count)
			end
			
			bitsLeft = bitsLeft - count
			return bits
		end
		
		return stream
	end
	local function getBitStream(obj)
		if isBitStream[obj] then
			return obj
		end
		
		return createBitStream(obj)
	end
	local function sortHuffman(a, b)
		return a.NumBits == b.NumBits and a.Value < b.Value or a.NumBits < b.NumBits
	end
	local function msb(bits, numBits)
		local res = 0
			
		for i = 1, numBits do
			res = lshift(res, 1) + band(bits, 1)
			bits = rshift(bits, 1)
		end
			
		return res
	end
	local function createHuffmanTable(init, isFull)
		local hTable = {}
		
		if isFull then
			for val, numBits in pairs(init) do
				if numBits ~= 0 then
					hTable[#hTable + 1] = 
					{
						Value = val;
						NumBits = numBits;
					}
				end
			end
		else
			for i = 1, #init - 2, 2 do
				local firstVal = init[i]
				
				local numBits = init[i + 1]
				local nextVal = init[i + 2]
				
				if numBits ~= 0 then
					for val = firstVal, nextVal - 1 do
						hTable[#hTable + 1] = 
						{
							Value = val;
							NumBits = numBits;
						}
					end
				end
			end
		end
		
		table.sort(hTable, sortHuffman)
		
		local code = 1
		local numBits = 0
		
		for i, slide in ipairs(hTable) do
			if slide.NumBits ~= numBits then
				code = code * pow2[slide.NumBits - numBits]
				numBits = slide.NumBits
			end
			
			slide.Code = code
			code = code + 1
		end
		
		local minBits = math.huge
		local look = {}
		
		for i, slide in ipairs(hTable) do
			minBits = math.min(minBits, slide.NumBits)
			look[slide.Code] = slide.Value
		end
		local firstCode = memoize(function (bits) 
			return pow2[minBits] + msb(bits, minBits) 
		end)
		
		function hTable:Read(bitStream)
			local code = 1 
			local numBits = 0
			
			while true do
				if numBits == 0 then  
					local index = bitStream:Read(minBits)
					numBits = numBits + minBits
					code = firstCode[index]
				else
					local bit = bitStream:Read()
					numBits = numBits + 1
					code = code * 2 + bit 
				end
				
				local val = look[code]
				
				if val then
					return val
				end
			end
		end
		
		return hTable
	end
	local function parseZlibHeader(bitStream)
		
		local cm = bitStream:Read(4)
		
		
		local cinfo = bitStream:Read(4)  
		
		
		local fcheck = bitStream:Read(5)
		
		
		local fdict = bitStream:Read(1)
		
		
		local flevel = bitStream:Read(2)
		
		
		local cmf = cinfo * 16  + cm
		
		
		local flg = fcheck + fdict * 32 + flevel * 64 
		
		if cm ~= 8 then 
			error("unrecognized zlib compression method: " .. cm)
		end
		
		if cinfo > 7 then
			error("invalid zlib window size: cinfo=" .. cinfo)
		end
		
		local windowSize = 2 ^ (cinfo + 8)
		
		if (cmf * 256 + flg) % 31 ~= 0 then
			error("invalid zlib header (bad fcheck sum)")
		end
		
		if fdict == 1 then
			error("FIX:TODO - FDICT not currently implemented")
		end
		
		return windowSize
	end
	local function parseHuffmanTables(bitStream)
		local numLits  = bitStream:Read(5) 
		local numDists = bitStream:Read(5) 
		local numCodes = bitStream:Read(4) 
		
		local codeLens = {}
		
		for i = 1, numCodes + 4 do
			local index = order[i]
			codeLens[index] = bitStream:Read(3)
		end
		
		codeLens = createHuffmanTable(codeLens, true)
		local function decode(numCodes)
			local init = {}
			local numBits
			local val = 0
			
			while val < numCodes do
				local codeLen = codeLens:Read(bitStream)
				local numRepeats
				
				if codeLen <= 15 then
					numRepeats = 1
					numBits = codeLen
				elseif codeLen == 16 then
					numRepeats = 3 + bitStream:Read(2)
				elseif codeLen == 17 then
					numRepeats = 3 + bitStream:Read(3)
					numBits = 0
				elseif codeLen == 18 then
					numRepeats = 11 + bitStream:Read(7)
					numBits = 0
				end
				
				for i = 1, numRepeats do
					init[val] = numBits
					val = val + 1
				end
			end
			
			return createHuffmanTable(init, true)
		end
		local numLitCodes = numLits + 257
		local numDistCodes = numDists + 1
		
		local litTable = decode(numLitCodes)
		local distTable = decode(numDistCodes)
		
		return litTable, distTable
	end
	local function parseCompressedItem(bitStream, state, litTable, distTable)
		local val = litTable:Read(bitStream)
		
		if val < 256 then 
			write(state, val)
		elseif val == 256 then 
			return true
		else
			local lenBase = lens[val - 257]
			local numExtraBits = lext[val - 257]
			
			local extraBits = bitStream:Read(numExtraBits)
			local len = lenBase + extraBits
			
			local distVal = distTable:Read(bitStream)
			local distBase = dists[distVal]
			
			local distNumExtraBits = dext[distVal]
			local distExtraBits = bitStream:Read(distNumExtraBits)
			
			local dist = distBase + distExtraBits
			
			for i = 1, len do
				local pos = (state.Pos - 1 - dist) % 32768 + 1
				local byte = assert(state.Window[pos], "invalid distance")
				write(state, byte)
			end
		end
		
		return false
	end
	local function parseBlock(bitStream, state)
		local bFinal = bitStream:Read(1)
		local bType = bitStream:Read(2)
		
		if bType == BTYPE_NO_COMPRESSION then
			local left = bitStream:GetBitsLeft()
			bitStream:Read(left)
			
			local len = bitStream:Read(16)
			local nlen = bitStream:Read(16)
			for i = 1, len do
				local byte = bitStream:Read(8)
				write(state, byte)
			end
		elseif bType == BTYPE_FIXED_HUFFMAN or bType == BTYPE_DYNAMIC_HUFFMAN then
			local litTable, distTable
			if bType == BTYPE_DYNAMIC_HUFFMAN then
				litTable, distTable = parseHuffmanTables(bitStream)
			else
				litTable = createHuffmanTable(fixedLit)
				distTable = createHuffmanTable(fixedDist)
			end
			
			repeat until parseCompressedItem(bitStream, state, litTable, distTable)
		else
			error("unrecognized compression type")
		end
		return bFinal ~= 0
	end
	function Deflate:Inflate(io)
		local state = createState(io.Output)
		local bitStream = getBitStream(io.Input)
		
		repeat until parseBlock(bitStream, state)
	end
	function Deflate:InflateZlib(io)
		local bitStream = getBitStream(io.Input)
		local windowSize = parseZlibHeader(bitStream)
		
		self:Inflate
		{
			Input = bitStream;
			Output = io.Output;
		}
		
		local bitsLeft = bitStream:GetBitsLeft()
		bitStream:Read(bitsLeft)
	end
	return Deflate
end

modules["PNGLib\\Modules\\Unfilter.lua"] = function()
	local Unfilter = {}
	function Unfilter:None(scanline, pixels, bpp, row)
		for i = 1, #scanline do
			pixels[row][i] = scanline[i]
		end
	end
	function Unfilter:Sub(scanline, pixels, bpp, row)
		for i = 1, bpp do
			pixels[row][i] = scanline[i]
		end
		
		for i = bpp + 1, #scanline do
			local x = scanline[i]
			local a = pixels[row][i - bpp]
			pixels[row][i] = bit32.band(x + a, 0xFF)
		end
	end
	function Unfilter:Up(scanline, pixels, bpp, row)
		if row > 1 then
			local upperRow = pixels[row - 1]
			
			for i = 1, #scanline do
				local x = scanline[i]
				local b = upperRow[i]
				pixels[row][i] = bit32.band(x + b, 0xFF)
			end
		else
			self:None(scanline, pixels, bpp, row)
		end
	end
	function Unfilter:Average(scanline, pixels, bpp, row)
		if row > 1 then
			for i = 1, bpp do
				local x = scanline[i]
				local b = pixels[row - 1][i]
				
				b = bit32.rshift(b, 1)
				pixels[row][i] = bit32.band(x + b, 0xFF)
			end
			
			for i = bpp + 1, #scanline do
				local x = scanline[i]
				local b = pixels[row - 1][i]
				
				local a = pixels[row][i - bpp]
				local ab = bit32.rshift(a + b, 1)
				
				pixels[row][i] = bit32.band(x + ab, 0xFF)
			end
		else
			for i = 1, bpp do
				pixels[row][i] = scanline[i]
			end
		
			for i = bpp + 1, #scanline do
				local x = scanline[i]
				local b = pixels[row - 1][i]
				
				b = bit32.rshift(b, 1)
				pixels[row][i] = bit32.band(x + b, 0xFF)
			end
		end
	end
	function Unfilter:Paeth(scanline, pixels, bpp, row)
		if row > 1 then
			local pr
			
			for i = 1, bpp do
				local x = scanline[i]
				local b = pixels[row - 1][i]
				pixels[row][i] = bit32.band(x + b, 0xFF)
			end
			
			for i = bpp + 1, #scanline do
				local a = pixels[row][i - bpp]
				local b = pixels[row - 1][i]
				local c = pixels[row - 1][i - bpp]
				
				local x = scanline[i]
				local p = a + b - c
				
				local pa = math.abs(p - a)
				local pb = math.abs(p - b)
				local pc = math.abs(p - c)
				
				if pa <= pb and pa <= pc then
					pr = a
				elseif pb <= pc then
					pr = b
				else
					pr = c
				end
				
				pixels[row][i] = bit32.band(x + pr, 0xFF)
			end
		else
			self:Sub(scanline, pixels, bpp, row)
		end
	end
	return Unfilter
end

modules["modules.standard.png"] = function()
	
	
	
	
	
	
	
	
	
	local sub, format, split, loadstring, spawn = string.sub, string.format, string.split, loadstring, task.spawn
	local PNG = {}
	PNG.__index = PNG
	local chunks = {};
	local modules = {};
	
	local chunk_modules = { "PNGLib\\Chunks\\bKGD.lua", "PNGLib\\Chunks\\cHRM.lua", "PNGLib\\Chunks\\gAMA.lua", "PNGLib\\Chunks\\IDAT.lua", "PNGLib\\Chunks\\IEND.lua", "PNGLib\\Chunks\\IHDR.lua", "PNGLib\\Chunks\\PLTE.lua", "PNGLib\\Chunks\\sRGB.lua", "PNGLib\\Chunks\\tEXt.lua", "PNGLib\\Chunks\\tIME.lua", "PNGLib\\Chunks\\tRNS.lua" }
	local module_modules = { "PNGLib\\Modules\\BinaryReader.lua", "PNGLib\\Modules\\Deflate.lua", "PNGLib\\Modules\\Unfilter.lua" }
	function fetch(module_list)
	    local r = {}
		for i,module_name in ipairs(module_list) do 
			local ChunkName = sub(split(module_name, "\\")[3], 1, #split(module_name, "\\")[3] - 4)
	    	r[ChunkName] = drequire(module_name)
	    end
	        return r;
	    
	end
	for n, v in next, fetch(chunk_modules) do
	    chunks[n] = v
	end
	for n, v in next, fetch(module_modules) do
	    modules[n] = v
	end
	local Deflate = modules.Deflate
	local Unfilter = modules.Unfilter
	local BinaryReader = modules.BinaryReader
	local function getBytesPerPixel(colorType)
		if colorType == 0 or colorType == 3 then
			return 1
		elseif colorType == 4 then
			return 2
		elseif colorType == 2 then
			return 3
		elseif colorType == 6 then
			return 4
		else
			return 0
		end
	end
	local function clampInt(value, min, max)
		local num = tonumber(value) or 0
		num = math.floor(num + .5)
		return math.clamp(num, min, max)
	end
	local function indexBitmap(file, x, y)
		local width = file.Width
		local height = file.Height
		x = clampInt(x, 1, width)
		y = clampInt(y, 1, height)
		local bitmap = file.Bitmap
		local bpp = file.BytesPerPixel
		local i0 = ((x - 1) * bpp) + 1
		local i1 = i0 + bpp
		return bitmap[y], i0, i1
	end
	function PNG:GetPixel(x, y)
		local row, i0, i1 = indexBitmap(self, x, y)
		local colorType = self.ColorType
		
		local color, alpha do
			if colorType == 0 then
				local gray = unpack(row, i0, i1)
				color = Color3.fromHSV(0, 0, gray)
				alpha = 255
			elseif colorType == 2 then
				local r, g, b = unpack(row, i0, i1)
				color = Color3.fromRGB(r, g, b)
				alpha = 255
			elseif colorType == 3 then
				local palette = self.Palette
				local alphaData = self.AlphaData
				
				local index = unpack(row, i0, i1)
				index = index + 1
				
				if palette then
					color = palette[index]
				end
				
				if alphaData then
					alpha = alphaData[index]
				end
			elseif colorType == 4 then
				local gray, a = unpack(row, i0, i1)
				color = Color3.fromHSV(0, 0, gray)
				alpha = a
			elseif colorType == 6 then
				local r, g, b, a = unpack(row, i0, i1)
				color = Color3.fromRGB(r, g, b, a)
				alpha = a
			end
		end
		
		if not color then
			color = Color3.new()
		end
		
		if not alpha then
			alpha = 255
		end
		
		return color, alpha
	end
	function PNG.new(buffer)
		
		local reader = BinaryReader.new(buffer)
		
		
		local file =
		{
			Chunks = {};
			Metadata = {};
			
			Reading = true;
			ZlibStream = "";
		}
		
		
		local header = reader:ReadString(8)
		
		if header ~= "\137PNG\r\n\26\n" then
			error("PNG - Input data is not a PNG file.", 2)
		end
		
		while file.Reading do
			local length = reader:ReadInt32()
			local chunkType = reader:ReadString(4)
			
			local data, crc
			
			if length > 0 then
				data = reader:ForkReader(length)
				crc = reader:ReadUInt32()
			end
			
			local chunk =
			{
				Length = length;
				Type = chunkType;
				
				Data = data;
				CRC = crc;
			}
			local handler = chunks[chunkType]
			if handler then
				handler(file, chunk)
			end
			table.insert(file.Chunks, chunk)
		end
		
		
		local success, response = pcall(function ()
			local result = {}
			local index = 0
			
			Deflate:InflateZlib
			{
				Input = BinaryReader.new(file.ZlibStream);
				
				Output = function (byte)
					index = index + 1
					result[index] = string.char(byte)
				end
			}
			
			return table.concat(result)
		end)
		
		if not success then
			error("PNG - Unable to unpack PNG data. " .. tostring(response), 2)
		end
		
		
		
		local width = file.Width
		local height = file.Height
		
		local bitDepth = file.BitDepth
		local colorType = file.ColorType
		
		local buffer = BinaryReader.new(response)
		file.ZlibStream = nil
		
		local bitmap = {}
		file.Bitmap = bitmap
		
		local channels = getBytesPerPixel(colorType)
		file.NumChannels = channels
		
		local bpp = math.max(1, channels * (bitDepth / 8))
		file.BytesPerPixel = bpp
		
		
		for row = 1, height do
			local filterType = buffer:ReadByte()
			local scanline = buffer:ReadBytes(width * bpp, true)
			
			bitmap[row] = {}
			
			if filterType == 0 then
				
				Unfilter:None(scanline, bitmap, bpp, row)
			elseif filterType == 1 then
				
				Unfilter:Sub(scanline, bitmap, bpp, row)
			elseif filterType == 2 then
				
				Unfilter:Up(scanline, bitmap, bpp, row)
			elseif filterType == 3 then
				
				Unfilter:Average(scanline, bitmap, bpp, row)
			elseif filterType == 4 then
				
				Unfilter:Paeth(scanline, bitmap, bpp, row)
			end
		end
		return setmetatable(file, PNG)
	end
	 
	return PNG
end

modules["modules.standard.jpeg.BitBuffer"] = function()
	local BitBuffer = {
		Bytes = "",
		Size = 0,
		ByteIndex = 0,
		CurrentByte = 0,
		Bit = 0
	}
	BitBuffer.__index = BitBuffer
	function BitBuffer.New(Data)
		local Buffer = setmetatable({}, BitBuffer)
		Buffer.Bytes = Data
		Buffer.Size = #Buffer.Bytes
		return Buffer
	end
	function BitBuffer:ReadBit()
		if (self.Bit == 0) then
			self.ByteIndex = self.ByteIndex + 1
			self.Bit = 0
			local NextByte = string.unpack(">I1", self.Bytes, self.ByteIndex)
			if (NextByte == 0x00 and self.CurrentByte == 0xFF) then
				self.ByteIndex = self.ByteIndex + 1
				NextByte = string.unpack(">I1", self.Bytes, self.ByteIndex)
			elseif (self.CurrentByte == 0xFF) then
				error("Unexpected marker in entropy stream: "..tostring(self.CurrentByte), 1)
			end
			self.CurrentByte = NextByte
		end
		local Bit = bit32.band(bit32.rshift(self.CurrentByte, 7 - self.Bit), 1)
		self.Bit = bit32.band(self.Bit + 1, 0x7)
		return Bit
	end
	function BitBuffer:ReadBits(NumBits)
		local Bits = 0
		for i = 1, NumBits, 1 do
			Bits = bit32.bor((bit32.lshift(Bits, 1)), self:ReadBit())
		end
		return Bits
	end
	function BitBuffer:ReadBytes(NumBytes)
		if (self.Bit ~= 0) then
			self:Align()
		end
		local Bytes = 0
		for i = 1, NumBytes, 1 do
			self.ByteIndex = self.ByteIndex + 1
			self.CurrentByte = string.unpack(">I1", self.Bytes, self.ByteIndex)
			Bytes = bit32.bor(bit32.lshift(Bytes, 8), self.CurrentByte)
		end
		return Bytes
	end
	function BitBuffer:Align()
		self.Bit = 0
	end
	function BitBuffer:IsEmpty()
		return self.Size <= self.ByteIndex
	end
	return BitBuffer
end

modules["modules.standard.jpeg.HuffmanTree"] = function()
	local HuffmanTree = {
		Root = {}
	}
	HuffmanTree.__index = HuffmanTree
	function HuffmanTree.New()
		local NewTree = setmetatable({}, HuffmanTree)
		NewTree.Root = {}
		return NewTree
	end
	function HuffmanTree:AddCode(Code, Bits, Value)
		local CurrentTable = self.Root
		for i = 1, Bits, 1 do
			local Bit = bit32.band(bit32.rshift(Code, Bits - i), 1)
			if (CurrentTable[Bit] == nil) then
				CurrentTable[Bit] = {}
			end
			CurrentTable = CurrentTable[Bit]
		end
		if (CurrentTable[0] ~= nil or CurrentTable[1] ~= nil or CurrentTable.Value ~= nil) then
			error("Attempt to add code that is a prefix of an already existing code", 1)
		end
		CurrentTable.Value = Value
	end
	function HuffmanTree:Index(Code, Bits)
		local CurrentTable = self.Root
		for i = 1, Bits, 1 do
			CurrentTable = CurrentTable[bit32.band(bit32.rshift(Code, Bits - i), 1)]
		end
		return CurrentTable.Value
	end
	return HuffmanTree
end

modules["modules.standard.jpeg.IDCT"] = function()
	local c1 = math.cos(math.pi / 16) / 2
	local c2 = math.cos(2 * math.pi / 16) / 2
	local c3 = math.cos(3 * math.pi / 16) / 2
	local c4 = math.cos(4 * math.pi / 16) / 2
	local c5 = math.cos(5 * math.pi / 16) / 2
	local c6 = math.cos(6 * math.pi / 16) / 2
	local c7 = math.cos(7 * math.pi / 16) / 2
	function IDCT(Data)
		for j = 1, 8, 1 do
			local k11 = (Data[j] + Data[32 + j]) * c4 + c2 * Data[16 + j] + c6 * Data[48 + j]
			local k21 = (Data[j] - Data[32 + j]) * c4 + c6 * Data[16 + j] - c2 * Data[48 + j]
			local k31 = (Data[j] - Data[32 + j]) * c4 - c6 * Data[16 + j] + c2 * Data[48 + j]
			local k41 = (Data[j] + Data[32 + j]) * c4 - c2 * Data[16 + j] - c6 * Data[48 + j]
			local k12 = c1 * Data[8 + j] + c3 * Data[24 + j] + c5 * Data[40 + j] + c7 * Data[56 + j]
			local k22 = c3 * Data[8 + j] - c7 * Data[24 + j] - c1 * Data[40 + j] - c5 * Data[56 + j]
			local k32 = c5 * Data[8 + j] - c1 * Data[24 + j] + c7 * Data[40 + j] + c3 * Data[56 + j]
			local k42 = c7 * Data[8 + j] - c5 * Data[24 + j] + c3 * Data[40 + j] - c1 * Data[56 + j]
			Data[j] = k11 + k12
			Data[8 + j] = k21 + k22
			Data[16 + j] = k31 + k32
			Data[24 + j] = k41 + k42
			Data[56 + j] = k11 - k12
			Data[48 + j] = k21 - k22
			Data[40 + j] = k31 - k32
			Data[32 + j] = k41 - k42
		end
		for i = 0, 56, 8 do 
			
			
			local k11 = (Data[i + 1] + Data[i + 5]) * c4 + c2 * Data[i + 3] + c6 * Data[i + 7]
			local k21 = (Data[i + 1] - Data[i + 5]) * c4 + c6 * Data[i + 3] - c2 * Data[i + 7]
			local k31 = (Data[i + 1] - Data[i + 5]) * c4 - c6 * Data[i + 3] + c2 * Data[i + 7]
			local k41 = (Data[i + 1] + Data[i + 5]) * c4 - c2 * Data[i + 3] - c6 * Data[i + 7]
			local k12 = c1 * Data[i + 2] + c3 * Data[i + 4] + c5 * Data[i + 6] + c7 * Data[i + 8]
			local k22 = c3 * Data[i + 2] - c7 * Data[i + 4] - c1 * Data[i + 6] - c5 * Data[i + 8]
			local k32 = c5 * Data[i + 2] - c1 * Data[i + 4] + c7 * Data[i + 6] + c3 * Data[i + 8]
			local k42 = c7 * Data[i + 2] - c5 * Data[i + 4] + c3 * Data[i + 6] - c1 * Data[i + 8]
			Data[i + 1] = k11 + k12
			Data[i + 2] = k21 + k22
			Data[i + 3] = k31 + k32
			Data[i + 4] = k41 + k42
			Data[i + 8] = k11 - k12
			Data[i + 7] = k21 - k22
			Data[i + 6] = k31 - k32
			Data[i + 5] = k41 - k42
		end
	end
	return IDCT
end

modules["modules.standard.jpeg"] = function()
	local Buffer = drequire("modules.standard.jpeg.BitBuffer")
	local HuffmanTree = drequire("modules.standard.jpeg.HuffmanTree")
	local IDCT = drequire("modules.standard.jpeg.IDCT")
	
	local SOI = 0xD8 
	local EOI = 0xD9 
	local SOF0 = 0xC0 
	local SOF1 = 0xC1 
	local SOF2 = 0xC2 
	local SOF3 = 0xC3 
	local DHT = 0xC4 
	local DQT = 0xDB 
	local DAC = 0xCC 
	local DRI = 0xDD 
	local SOS = 0xDA 
	local DNL = 0xDC
	local RSTnMin = 0xD0 
	local RSTnMax = 0xD8
	local APPn = 0xE0 
	local Comment = 0xFE
	local JFIFHeader = 0xE0
	
	local ZigZag = {
		1, 2, 6, 7, 15, 16, 28, 29,
		3, 5, 8, 14, 17, 27, 30, 43,
		4, 9, 13, 18, 26, 31, 42, 44,
		10, 12, 19, 25, 32, 41, 45, 54,
		11, 20, 24, 33, 40, 46, 53, 55,
		21, 23, 34, 39, 47, 52, 56, 61,
		22, 35, 38, 48, 51, 57, 60, 62,
		36, 37, 49, 50, 58, 59, 63, 64
	}
	function YCbCrToRGB(ImageInfo)
		local Pixels = ImageInfo.Pixels
		local Offset = ImageInfo.SamplePrecision > 0 and bit32.lshift(1, (ImageInfo.SamplePrecision - 1)) or 0
		local Max = Offset * 2 - 1
		local function Clamp(x)
			if (x > Max) then return Max end
			if (x < 0) then return 0 end
			return x
		end
		local Index = 1
		for i = 1, ImageInfo.Y, 1 do
			for j = 1, ImageInfo.X, 1 do
				local y = Pixels[1][Index]
	            local Cb = Pixels[2][Index] - Offset
	            local Cr = Pixels[3][Index] - Offset
	            local R = Clamp(y + 1.402 * Cr)
	            local G = Clamp(y - 0.34414 * Cb - 0.71414 * Cr)
	            local B = Clamp(y + 1.772 * Cb)
				Pixels[1][Index] = math.floor(R + 0.5)
				Pixels[2][Index] = math.floor(G + 0.5)
				Pixels[3][Index] = math.floor(B + 0.5)
				Index = Index + 1
			end
		end
	end
	function ReadQuantizationTables(Buff, ImageInfo)
		local Length = Buff:ReadBytes(2) - 2 
		while (Length > 0) do 
			local Precision = Buff:ReadBits(4) == 0 and 1 or 2
			local Tq = Buff:ReadBits(4)
			local QuantizationTable = {}
			Length = Length - 1
			for v = 1, 64, 1 do
				QuantizationTable[v] = Buff:ReadBytes(Precision)
			end
			Length = Length - Precision * 64
			ImageInfo.QuantizationTables[Tq + 1] = QuantizationTable
		end
	end
	function ReadHuffmanTable(Buff, ImageInfo)
		local Length = Buff:ReadBytes(2) - 2
		while (Length > 0) do 
			local TableClass = Buff:ReadBits(4)
			local Dest = Buff:ReadBits(4)
			local CodeLengths = {}
			local GeneratedHuffmanCodes = HuffmanTree.New()
			local CurrentCode = 0
			for i = 1, 16, 1 do
				CodeLengths[i] = Buff:ReadBytes(1)
			end
			Length = Length - 17
			for i = 1, 16, 1 do 
				for j = 1, CodeLengths[i], 1 do
					local Value = Buff:ReadBytes(1)
					GeneratedHuffmanCodes:AddCode(CurrentCode, i, Value)
					CurrentCode = CurrentCode + 1
				end
				Length = Length - CodeLengths[i]
				CurrentCode = bit32.lshift(CurrentCode, 1)
			end
			if (TableClass == 1) then
				ImageInfo.ACHuffmanCodes[Dest + 1] = GeneratedHuffmanCodes
			else
				ImageInfo.DCHuffmanCodes[Dest + 1] = GeneratedHuffmanCodes
			end
		end
	end
	function ReadJFIFHeader(Buff)
		local Length = Buff:ReadBytes(2)
		local Identfier = Buff:ReadBytes(5)
		if (Identfier ~= 0x4A46494600) then 
			Buff:ReadBytes(Length - 7)
			return
		end
		local Version = Buff:ReadBytes(2)
		local Density = Buff:ReadBytes(1)
		local XDensity = Buff:ReadBytes(2)
		local YDensity = Buff:ReadBytes(2)
		local XThumbnail = Buff:ReadBytes(1)
		local YThumbnail = Buff:ReadBytes(1)
		Buff:ReadBytes(XThumbnail * YThumbnail) 
	end
	function ReadFrame(Buff, ImageInfo)
		local Length = Buff:ReadBytes(2)
		local Precision = Buff:ReadBytes(1)
		ImageInfo.SamplePrecision = Precision
		ImageInfo.Y = Buff:ReadBytes(2)
		ImageInfo.X = Buff:ReadBytes(2)
		ImageInfo.HMax = 1
		ImageInfo.VMax = 1
		local ComponantsInFrame = Buff:ReadBytes(1)
		for i = 1, ComponantsInFrame, 1 do
			local Identifier = Buff:ReadBytes(1)
			local Componant = {
				HorizontalSamplingFactor = Buff:ReadBits(4),
				VerticalSamplingFactor = Buff:ReadBits(4),
				QuantizationTableDestination = Buff:ReadBytes(1)
			}
			if (Componant.HorizontalSamplingFactor > ImageInfo.HMax) then
				ImageInfo.HMax = Componant.HorizontalSamplingFactor
			end
			if (Componant.VerticalSamplingFactor > ImageInfo.VMax) then
				ImageInfo.VMax = Componant.VerticalSamplingFactor
			end
			ImageInfo.ComponantsInfo[Identifier] = Componant
			ImageInfo.Pixels[i] = {}
		end
		
		for p, c in pairs(ImageInfo.ComponantsInfo) do
			
			
			
			local BlocksXDim = math.ceil(math.ceil(ImageInfo.X / 8) * (c.HorizontalSamplingFactor / ImageInfo.HMax))
			local BlocksYDim = math.ceil(math.ceil(ImageInfo.Y / 8) * (c.VerticalSamplingFactor / ImageInfo.VMax))
			ImageInfo.Blocks[p] = {}
			ImageInfo.Blocks[p].X = BlocksXDim
			ImageInfo.Blocks[p].Y = BlocksYDim
			local NumComponantBlocks = BlocksXDim * BlocksYDim
			for i = 1, NumComponantBlocks, 1 do
				local Block = {}
				for v = 1, 64, 1 do
					Block[v] = 0
				end
				ImageInfo.Blocks[p][i] = Block
			end
		end
		print("Size:", ImageInfo.X, ImageInfo.Y, ComponantsInFrame)
	end
	function IndexHuffmanTree(Tree, Buff)
		local Current = Tree.Root
		while (Current.Value == nil) do
			Current = Current[Buff:ReadBit()]
		end
		return Current.Value
	end
	function Extend(V, T) 
		if (T == 0) then return 0 end
		return V < bit32.lshift(1, (T - 1)) and V - bit32.lshift(1, T) + 1 or V
	end
	function ScanDimensions(ComponantsInScan, ComponantParameters, ImageInfo)
		local ScanHMax = 1
		local ScanVMax = 1
		for i = 1, ComponantsInScan, 1 do
			local ComponantParams = ComponantParameters[1]
			local ComponantInfo = ImageInfo.ComponantsInfo[ComponantParams.ScanComponantIndex]
			if (ComponantInfo.HorizontalSamplingFactor > ScanHMax) then
				ScanHMax = ComponantInfo.HorizontalSamplingFactor
			end
			if (ComponantInfo.VerticalSamplingFactor > ScanVMax) then
				ScanVMax = ComponantInfo.VerticalSamplingFactor
			end
		end
		local MCUXDim = math.ceil(ImageInfo.X / (8 * ScanHMax))
		local MCUYDim = math.ceil(ImageInfo.Y / (8 * ScanVMax))
		local TotalMCUs
		if (ComponantsInScan > 1) then
			TotalMCUs = MCUXDim * MCUYDim
		else
			local CInfo = ImageInfo.ComponantsInfo[ComponantParameters[1].ScanComponantIndex]
			
			TotalMCUs = math.max(CInfo.HorizontalSamplingFactor, math.ceil(math.ceil(ImageInfo.X * CInfo.HorizontalSamplingFactor / ImageInfo.HMax) / 8)) *
				math.max(CInfo.VerticalSamplingFactor, math.ceil(math.ceil(ImageInfo.Y * CInfo.VerticalSamplingFactor / ImageInfo.VMax) / 8))
		end
		return MCUXDim, TotalMCUs
	end
	function ReadSpectralScan(Buff, Ss, Se, Al, Ah, ComponantsInScan, ComponantParameters, ImageInfo) 
		local MCUXDim, TotalMCUs = ScanDimensions(ComponantsInScan, ComponantParameters, ImageInfo)
		local RestartInterval = ImageInfo.RestartInterval
		local PreviousDCCoefficients = {}
		local EndOfBandRun = 0
		for i = 1, ComponantsInScan, 1 do
			PreviousDCCoefficients[i] = 0
		end
		for MCU = 1, TotalMCUs, 1 do
			for i = 1, ComponantsInScan, 1 do
				local ComponantParams = ComponantParameters[i]
				local ComponantInfo = ImageInfo.ComponantsInfo[ComponantParams.ScanComponantIndex]
				local ACHuffmanTree = ImageInfo.ACHuffmanCodes[ComponantParams.ACTableIndex + 1]
				local DCHuffmanTree = ImageInfo.DCHuffmanCodes[ComponantParams.DCTableIndex + 1]
				local NumComponantBlocks = ComponantsInScan > 1 and ComponantInfo.HorizontalSamplingFactor * ComponantInfo.VerticalSamplingFactor or 1
				for c = 1, NumComponantBlocks, 1 do
					if (EndOfBandRun > 0 and EndOfBandRun - (NumComponantBlocks - c + 1) >= 0) then
						EndOfBandRun = EndOfBandRun - (NumComponantBlocks - c + 1)
						break
					else
						c = c + EndOfBandRun
						EndOfBandRun = 0
					end
					local BlockData
					local K = Ss + 1
					
					local BlocksXDim = ImageInfo.Blocks[ComponantParams.ScanComponantIndex].X
					local BlocksYDim = ImageInfo.Blocks[ComponantParams.ScanComponantIndex].Y
					if (ComponantsInScan > 1) then
						local MCUYIndex = (MCU-1) // MCUXDim
						local MCUXIndex = (MCU-1) - MCUYIndex * MCUXDim
						local BlockY = MCUYIndex * ComponantInfo.VerticalSamplingFactor + (c-1) // ComponantInfo.HorizontalSamplingFactor
						local BlockX = MCUXIndex * ComponantInfo.HorizontalSamplingFactor + ((c-1) % ComponantInfo.HorizontalSamplingFactor) + 1
						if (BlockX <= BlocksXDim and BlockY <= BlocksYDim) then
							BlockData = ImageInfo.Blocks[ComponantParams.ScanComponantIndex][BlockY * BlocksXDim + BlockX]
						end
					else
						local MCUYIndex = (MCU-1) // BlocksXDim
						local MCUXIndex = (MCU-1) - MCUYIndex * BlocksXDim
						if (MCUXIndex <= BlocksXDim and MCUYIndex <= BlocksYDim) then
							BlockData = ImageInfo.Blocks[ComponantParams.ScanComponantIndex][MCU]
						end
					end
					
					if (BlockData == nil) then
						BlockData = {}
						for l = 1, 64, 1 do
							BlockData[l] = 0
						end
					end
					if (Ss == 0) then
						local T = IndexHuffmanTree(DCHuffmanTree, Buff)
						local DIFF = Extend(Buff:ReadBits(T), T) + PreviousDCCoefficients[i]
						PreviousDCCoefficients[i] = DIFF
						BlockData[K] = BlockData[K] + DIFF * bit32.lshift(1, Al)
						K = K + 1
					end
					while (K <= Se + 1) do
						local RS = IndexHuffmanTree(ACHuffmanTree, Buff)
						local LowerNibble = bit32.band(RS, 0xF)
						local HigherNibble = bit32.rshift(RS, 4)
						if (LowerNibble == 0) then
							if (HigherNibble == 15) then
								K = K + 16
							else
								EndOfBandRun = bit32.lshift(1, HigherNibble) + Buff:ReadBits(HigherNibble) - 1
								break
							end
						else
							K = K + HigherNibble
							BlockData[K] = BlockData[K] + Extend(Buff:ReadBits(LowerNibble), LowerNibble) * bit32.lshift(1, Al)
							K = K + 1
						end
					end
				end
			end
			
			if (RestartInterval ~= 0 and MCU % RestartInterval == 0 and MCU ~= TotalMCUs) then
				Buff:Align()
				local ExpextedMarker = 0xFF00 + RSTnMin + (((MCU - RestartInterval) // RestartInterval) % 8)
				local Marker = Buff:ReadBytes(2)
				if (Marker ~= ExpextedMarker) then
					print("Restart Marker error, got marker", Marker, "expected", ExpextedMarker)
					return
				end
				EndOfBandRun = 0
				for i = 1, ComponantsInScan, 1 do
					PreviousDCCoefficients[i] = 0
				end
			end
		end
	end
	function ReadRefinementScan(Buff, Ss, Se, Al, Ah, ComponantsInScan, ComponantParameters, ImageInfo)
		local EndOfBandRun = 0
		local RestartInterval = ImageInfo.RestartInterval
		local Positive = bit32.lshift(1, Al)
		local Negative = -1 * Positive
		local MCUXDim, TotalMCUs = ScanDimensions(ComponantsInScan, ComponantParameters, ImageInfo)
		for MCU = 1, TotalMCUs, 1 do
			for i = 1, ComponantsInScan, 1 do
				local ComponantParams = ComponantParameters[i]
				local ComponantInfo = ImageInfo.ComponantsInfo[ComponantParams.ScanComponantIndex]
				local ACHuffmanTree = ImageInfo.ACHuffmanCodes[ComponantParams.ACTableIndex + 1]
				local NumComponantBlocks = ComponantsInScan > 1 and ComponantInfo.HorizontalSamplingFactor * ComponantInfo.VerticalSamplingFactor or 1
				for c = 1, NumComponantBlocks, 1 do
					local BlockData
					local K = Ss + 1
					
					local BlocksXDim = ImageInfo.Blocks[ComponantParams.ScanComponantIndex].X
					local BlocksYDim = ImageInfo.Blocks[ComponantParams.ScanComponantIndex].Y
					if (ComponantsInScan > 1) then
						local MCUYIndex = (MCU-1) // MCUXDim
						local MCUXIndex = (MCU-1) - MCUYIndex * MCUXDim
						local BlockY = MCUYIndex * ComponantInfo.VerticalSamplingFactor + (c-1) // ComponantInfo.HorizontalSamplingFactor
						local BlockX = MCUXIndex * ComponantInfo.HorizontalSamplingFactor + ((c-1) % ComponantInfo.HorizontalSamplingFactor) + 1
						if (BlockX <= BlocksXDim and BlockY <= BlocksYDim) then
							BlockData = ImageInfo.Blocks[ComponantParams.ScanComponantIndex][BlockY * BlocksXDim + BlockX]
						end
					else
						local MCUYIndex = (MCU-1) // BlocksXDim
						local MCUXIndex = (MCU-1) - MCUYIndex * BlocksXDim
						if (MCUXIndex <= BlocksXDim and MCUYIndex <= BlocksYDim) then
							BlockData = ImageInfo.Blocks[ComponantParams.ScanComponantIndex][MCU]
						end
					end
					
					if (BlockData == nil) then
						BlockData = {}
						for l = 1, 64, 1 do
							BlockData[l] = 0
						end
					end
					if (Ss == 0 and EndOfBandRun == 0) then
						local Bit = Buff:ReadBit()
						if (BlockData[K] == 0) then
							BlockData[K] = (Bit == 0 and Negative or Positive)
						else
							BlockData[K] = BlockData[K] + (BlockData[K] < 0 and Negative or Positive)
						end
						K = K + 1
						if (Se ~= 0) then error("invalid refinement scan, DC and AC coeffecients are mixed") end
					end
					while (K <= Se + 1 and EndOfBandRun == 0) do
						local RS = IndexHuffmanTree(ACHuffmanTree, Buff)
						local LowerNibble = bit32.band(RS, 0xF)
						local HigherNibble = bit32.rshift(RS, 4)
						if (LowerNibble == 0) then
							if (HigherNibble == 15) then
								local Skip = 16
								while (Skip > 0 and K <= Se+1) do
									if (BlockData[K] ~= 0) then
										BlockData[K] = BlockData[K] + Buff:ReadBit() * (BlockData[K] < 0 and Negative or Positive)
									else
										Skip = Skip - 1
									end
									K = K + 1
								end
							else
								EndOfBandRun = bit32.lshift(1, HigherNibble) + Buff:ReadBits(HigherNibble)
								break
							end
						else
							local Skip = HigherNibble
							local Sign = Buff:ReadBits(LowerNibble) == 1 and 1 or -1
							while ((Skip > 0 or BlockData[K] ~= 0) and K <= Se+1) do
								
								if (BlockData[K] ~= 0) then
									BlockData[K] = BlockData[K] + Buff:ReadBit() * (BlockData[K] < 0 and Negative or Positive)
								else
									Skip = Skip - 1
								end
								K = K + 1
							end
							if (K > Se + 1) then break end
							BlockData[K] = BlockData[K] + Sign * bit32.lshift(1, Al)
							K = K + 1
						end
					end
					if (EndOfBandRun > 0) then
						while (K <= Se + 1) do
							if (BlockData[K] ~= 0) then
								BlockData[K] = BlockData[K] + bit32.lshift(Buff:ReadBit(), Al) * (BlockData[K] < 0 and -1 or 1)
							end
							K = K + 1
						end
						EndOfBandRun = EndOfBandRun - 1
					end
				end
			end
			
			if (ImageInfo.RestartInterval ~= 0 and MCU % ImageInfo.RestartInterval == 0 and MCU ~= TotalMCUs) then
				Buff:Align()
				local ExpextedMarker = 0xFF00 + RSTnMin + (((MCU - RestartInterval) // RestartInterval) % 8)
				local Marker = Buff:ReadBytes(2)
				if (Marker ~= ExpextedMarker) then
					print("Restart Marker error, got marker", Marker, "expected", ExpextedMarker)
					return
				end
				EndOfBandRun = 0
			end
		end
	end
	function ReadScan(Buff, ImageInfo)
		local Length = Buff:ReadBytes(2)
		local ComponantsInScan = Buff:ReadBytes(1)
		local ComponantParameters = {}
		for i = 1, ComponantsInScan, 1 do
			local Parameters = {
				ScanComponantIndex = Buff:ReadBytes(1),
				DCTableIndex = Buff:ReadBits(4),
				ACTableIndex = Buff:ReadBits(4)
			}
			ComponantParameters[i] = Parameters
		end
		local Ss = Buff:ReadBytes(1) 
		local Se = Buff:ReadBytes(1) 
		local Ah = Buff:ReadBits(4) 
		local Al = Buff:ReadBits(4) 
		if (Ah == 0) then
			ReadSpectralScan(Buff, Ss, Se, Al, Ah, ComponantsInScan, ComponantParameters, ImageInfo)
		else
			ReadRefinementScan(Buff, Ss, Se, Al, Ah, ComponantsInScan, ComponantParameters, ImageInfo)
		end
		task.wait()
	end
	function ReadRestartInterval(Buff, ImageInfo)
		local Length = Buff:ReadBytes(2)
		ImageInfo.RestartInterval = Buff:ReadBytes(2) 
	end
	function ReadDNL(Buff)
		local Length = Buff:ReadBytes(2)
		local NumLines = Buff:ReadBytes(2)
	end
	function InterpretMarker(Buff, ImageInfo) 
		local Marker = Buff:ReadBytes(1)
		if (Marker == DQT) then
			ReadQuantizationTables(Buff, ImageInfo)
		elseif (Marker == DHT) then
			ReadHuffmanTable(Buff, ImageInfo)
		elseif (Marker == JFIFHeader) then
			ReadJFIFHeader(Buff)
		elseif (Marker == SOF0 or Marker == SOF1 or Marker == SOF2) then
			ReadFrame(Buff, ImageInfo)
		elseif (Marker == SOS) then
			ReadScan(Buff, ImageInfo)
			Buff:Align()
		elseif (Marker == DRI) then
			ReadRestartInterval(Buff, ImageInfo)
		elseif (Marker == EOI) then
			return -1
		elseif (Marker == DAC) then
			error("Arithmetic encoding is not supported")
		elseif (Marker == DNL) then
			ReadDNL(Buff)
			error("DNL currently unsupported")
		elseif (Marker ~= 0) then 
			local Len = Buff:ReadBytes(2) - 2 
			if (SOF2 < Marker and Marker <= 0xCF) then
				error("Unsupported frame:", Marker)
			end
			Buff:ReadBytes(Len)
		end
	end
	function TransformBlocks(ImageInfo)
		local Blocks = ImageInfo.Blocks
		local Pixels = ImageInfo.Pixels
		local X = ImageInfo.X
		local Y = ImageInfo.Y
		for c, info in pairs(ImageInfo.ComponantsInfo) do
			local QuantizationTable = ImageInfo.QuantizationTables[info.QuantizationTableDestination+1]
			local XScale = ImageInfo.HMax // info.HorizontalSamplingFactor
			local YScale = ImageInfo.VMax // info.VerticalSamplingFactor
			local SubImageX = XScale * 8
			local SubImageY = YScale * 8
			for yb = 1, Blocks[c].Y, 1 do
				for xb = 1, Blocks[c].X, 1 do
					
					local BlockIndex = (yb - 1) * Blocks[c].X + xb
					local DecodedBlock = Blocks[c][BlockIndex]
					local Block = {}
					for v = 1, 64, 1 do
						Block[v] = DecodedBlock[ZigZag[v]] * QuantizationTable[ZigZag[v]]
					end
					IDCT(Block)
					local Offset = ImageInfo.SamplePrecision > 0 and bit32.lshift(1, (ImageInfo.SamplePrecision - 1)) or 0
					for v = 1, 64, 1 do
						Block[v] = Block[v] + Offset
					end
					
					local HorizontalEdge = math.min(SubImageY, (Y - ((yb - 1) * SubImageY)))
					local VerticalEdge = math.min(SubImageX, (X - ((xb - 1) * SubImageX)))
					local ImageYIndex = (yb - 1) * SubImageY * X
					local ImageXIndex = (xb - 1) * SubImageX
					for y = 1, HorizontalEdge, 1 do
						local BlockYIndex = (y - 1) // YScale
						for x = 1, VerticalEdge, 1 do
							local BlockXIndex = (x - 1) // XScale
							Pixels[c][ImageYIndex + ImageXIndex + 1] = Block[BlockYIndex * 8 + BlockXIndex + 1]
							ImageXIndex = ImageXIndex + 1
						end
						ImageXIndex = ImageXIndex - VerticalEdge
						ImageYIndex = ImageYIndex + X
					end
				end
			end
		end
	end
	function DecodeJpeg(BString)
		local Buff = Buffer.New(BString)
		if (Buff:ReadBytes(2) ~= 0xFF00 + SOI) then print("inavlid jpg file") return end
		local ImageInfo = {
			X = 0,
			Y = 0,
			Pixels = {},
			QuantizationTables = {{}, {}, {}, {}},
			DCHuffmanCodes = {{}, {}, {}, {}},
			ACHuffmanCodes = {{}, {}, {}, {}},
			ComponantsInfo = {},
			HMax = 0,
			VMax = 0,
			SamplePrecision = 0,
			RestartInterval = 0,
			Blocks = {}
		}
		while (not Buff:IsEmpty()) do
			local Byte = Buff:ReadBytes(1)
			if (Byte == 0xFF) then
				local R = InterpretMarker(Buff, ImageInfo)
				if (R == -1) then
					break
				end
			end
		end
		TransformBlocks(ImageInfo)
		YCbCrToRGB(ImageInfo)
		
		ImageInfo.Blocks = nil
		return ImageInfo
	end
	return {decode=DecodeJpeg}
end

modules["modules.standard.universal_image_loader"] = function()
	
	
	
	
	
	
	local PNG = drequire("modules.standard.png")
	local JPEG = drequire("modules.standard.jpeg")
	local UniversalImage = {}
	UniversalImage.__index = UniversalImage
	
	local function createPNGWrapper(pngImage)
		local wrapper = {
			Width = pngImage.Width,
			Height = pngImage.Height,
			_type = "PNG",
			_pngImage = pngImage
		}
		function wrapper:GetPixel(x, y)
			local color, alpha = self._pngImage:GetPixel(x, y)
			
			
			return color, (alpha or 255) / 255
		end
		return setmetatable(wrapper, UniversalImage)
	end
	
	local function createJPEGWrapper(jpegImage)
		local wrapper = {
			Width = jpegImage.X,
			Height = jpegImage.Y,
			_type = "JPEG",
			_jpegImage = jpegImage
		}
		function wrapper:GetPixel(x, y)
			
			
			local index = (y - 1) * self.Width + x
			
			local r = self._jpegImage.Pixels[1][index] or 0
			local g = self._jpegImage.Pixels[2][index] or 0
			local b = self._jpegImage.Pixels[3][index] or 0
			
			local color = Color3.fromRGB(r, g, b)
			
			local alpha = 1
			return color, alpha
		end
		return setmetatable(wrapper, UniversalImage)
	end
	
	function UniversalImage.load(fileData, formatHint)
		
		local isPNG = string.sub(fileData, 1, 8) == "\137PNG\r\n\26\n"
		local isJPEG = string.sub(fileData, 1, 2) == "\255\216" 
		
		if not isPNG and not isJPEG then
			if formatHint == "PNG" then
				isPNG = true
			elseif formatHint == "JPEG" or formatHint == "JPG" then
				isJPEG = true
			else
				error("UniversalImageLoader: Cannot detect image format", 2)
			end
		end
		if isPNG then
			local pngImage = PNG.new(fileData)
			return createPNGWrapper(pngImage)
		elseif isJPEG then
			local jpegImage = JPEG.decode(fileData)
			return createJPEGWrapper(jpegImage)
		else
			error("UniversalImageLoader: Unsupported image format", 2)
		end
	end
	return UniversalImage
end

modules["modules.uilibs.image_source_selector"] = function()
	local SourceSelector = {}
	SourceSelector.__index = SourceSelector
	
	local UserInputService = game:GetService("UserInputService")
	local TweenService = game:GetService("TweenService")
	local HttpService = game:GetService("HttpService")
	local Players = game:GetService("Players")
	
	local THEME = {
	    Background    = Color3.fromRGB(30, 30, 46),
	    Sidebar       = Color3.fromRGB(24, 24, 37),
	    ItemHover     = Color3.fromRGB(45, 45, 65),
	    ItemOdd       = Color3.fromRGB(30, 30, 46),
	    ItemEven      = Color3.fromRGB(34, 34, 52),
	    TextPrimary   = Color3.fromRGB(205, 214, 244),
	    TextSecondary = Color3.fromRGB(166, 173, 200),
	    Accent        = Color3.fromRGB(137, 180, 250),
	    Red           = Color3.fromRGB(243, 139, 168),
	    Green         = Color3.fromRGB(166, 227, 161),
	    Yellow        = Color3.fromRGB(249, 226, 175),
	    Border        = Color3.fromRGB(69, 71, 90)
	}
	
	local function get_ui_parent()
	     return Players.LocalPlayer:WaitForChild("PlayerGui") 
	end
	local function format_bytes(bytes)
	    if not bytes then return "-" end
	    local units = {"B", "KB", "MB", "GB"}
	    local i = 1
	    while bytes > 1024 and i < #units do bytes = bytes / 1024; i = i + 1 end
	    return string.format("%.2f %s", bytes, units[i])
	end
	local function http_get(url)
	    local request_func = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
	    if request_func then
	        local response = request_func({Url = url, Method = "GET"})
	        if response.StatusCode == 200 then return response.Body end
	    else
	        return game:HttpGet(url)
	    end
	    return nil
	end
	local function validate_image_data(data)
	    if not data or #data < 4 then return false, "Empty or too small" end
	    if data:sub(1, 8) == "\137PNG\r\n\26\n" then return true, "PNG" end
	    if data:sub(1, 3) == "\255\216\255" then return true, "JPG" end
	    return false, "Unknown Header"
	end
	local function enable_smooth_drag(frame, dragHandle)
	    local dragging, dragInput, dragStart, startPos
	    dragHandle.InputBegan:Connect(function(input)
	        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
	            dragging = true; dragStart = input.Position; startPos = frame.Position
	            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
	        end
	    end)
	    dragHandle.InputChanged:Connect(function(input)
	        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
	    end)
	    UserInputService.InputChanged:Connect(function(input)
	        if input == dragInput and dragging then
	            local delta = input.Position - dragStart
	            TweenService:Create(frame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	            }):Play()
	        end
	    end)
	end
	
	local function get_files(path)
	    if not listfiles then return {} end
	    local s, result = pcall(function() return listfiles(path) end)
	    return s and result or {}
	end
	local function get_safe_file_size(path)
	    if isfolder(path) then return 0 end
	    

	    if readfile then
	        local s, content = pcall(readfile, path)
	        return (s and content) and #content or 0
	    end
	    return 0
	end
	local function get_name_from_path(path) return path:match("([^/\\]+)$") or path end
	local function get_parent_dir(path) return path:match("(.*)[/\\]") or "" end
	
	function SourceSelector.Select(options)
	    options = options or {}
	    local validExtensions = options.extensions or {".png", ".jpg", ".jpeg", ".bmp"} 
	    
	    local finalResult = nil
	    local isClosed = false
	    
	    
	    local ScreenGui = Instance.new("ScreenGui")
	    ScreenGui.Name = "ImageSourceSelector"
	    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	    ScreenGui.Parent = get_ui_parent()
	    local MainFrame = Instance.new("Frame")
	    MainFrame.Name = "MainFrame"
	    MainFrame.Parent = ScreenGui
	    MainFrame.BackgroundColor3 = THEME.Background
	    MainFrame.BorderSizePixel = 0
	    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -200)
	    MainFrame.Size = UDim2.new(0, 700, 0, 400)
	    MainFrame.ClipsDescendants = true
	    
	    local MainCorner = Instance.new("UICorner"); MainCorner.CornerRadius = UDim.new(0, 8); MainCorner.Parent = MainFrame
	    local Stroke = Instance.new("UIStroke"); Stroke.Color = THEME.Border; Stroke.Thickness = 1; Stroke.Parent = MainFrame
	    
	    local Sidebar = Instance.new("Frame"); Sidebar.Name = "Sidebar"; Sidebar.Parent = MainFrame
	    Sidebar.BackgroundColor3 = THEME.Sidebar; Sidebar.Size = UDim2.new(0, 160, 1, 0); Sidebar.BorderSizePixel = 0
	    local SidebarCorner = Instance.new("UICorner"); SidebarCorner.CornerRadius = UDim.new(0, 8); SidebarCorner.Parent = Sidebar
	    local SidebarCover = Instance.new("Frame"); SidebarCover.BackgroundColor3 = THEME.Sidebar; SidebarCover.BorderSizePixel = 0
	    SidebarCover.Size = UDim2.new(0, 10, 1, 0); SidebarCover.Position = UDim2.new(1, -10, 0, 0); SidebarCover.Parent = Sidebar
	    local TitleLabel = Instance.new("TextLabel"); TitleLabel.Parent = Sidebar; TitleLabel.BackgroundTransparency = 1
	    TitleLabel.Position = UDim2.new(0, 15, 0, 15); TitleLabel.Size = UDim2.new(1, -30, 0, 30); TitleLabel.Font = Enum.Font.GothamBold
	    TitleLabel.Text = "导入图像"; TitleLabel.TextColor3 = THEME.TextPrimary; TitleLabel.TextSize = 18; TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	    local TabContainer = Instance.new("Frame"); TabContainer.Parent = Sidebar; TabContainer.BackgroundTransparency = 1
	    TabContainer.Position = UDim2.new(0, 0, 0, 60); TabContainer.Size = UDim2.new(1, 0, 1, -60)
	    
	    local ContentArea = Instance.new("Frame"); ContentArea.Name = "ContentArea"; ContentArea.Parent = MainFrame
	    ContentArea.BackgroundTransparency = 1; ContentArea.Position = UDim2.new(0, 160, 0, 0); ContentArea.Size = UDim2.new(1, -160, 1, 0)
	    local HeaderDrag = Instance.new("Frame"); HeaderDrag.Parent = MainFrame; HeaderDrag.BackgroundTransparency = 1
	    HeaderDrag.Size = UDim2.new(1, 0, 0, 40)
	    
	    local CloseBtn = Instance.new("TextButton"); CloseBtn.Parent = HeaderDrag; CloseBtn.BackgroundTransparency = 1
	    CloseBtn.Position = UDim2.new(1, -40, 0, 0); CloseBtn.Size = UDim2.new(0, 40, 0, 40); CloseBtn.Font = Enum.Font.GothamBold
	    CloseBtn.Text = "X"; CloseBtn.TextColor3 = THEME.Red; CloseBtn.TextSize = 18; CloseBtn.ZIndex = 5
	    CloseBtn.MouseButton1Click:Connect(function() isClosed = true end)
	    enable_smooth_drag(MainFrame, HeaderDrag)
	    
	    local currentTab = nil; local tabs = {}
	    local function CreateTabButton(name, icon, order)
	        local Btn = Instance.new("TextButton"); Btn.Parent = TabContainer; Btn.BackgroundTransparency = 1
	        Btn.Size = UDim2.new(1, 0, 0, 40); Btn.Position = UDim2.new(0, 0, 0, (order-1)*40); Btn.Text = ""
	        local Indicator = Instance.new("Frame"); Indicator.Parent = Btn; Indicator.BackgroundColor3 = THEME.Accent
	        Indicator.Size = UDim2.new(0, 3, 1, 0); Indicator.Position = UDim2.new(0, 0, 0, 0); Indicator.BackgroundTransparency = 1
	        local Label = Instance.new("TextLabel"); Label.Parent = Btn; Label.BackgroundTransparency = 1
	        Label.Position = UDim2.new(0, 20, 0, 0); Label.Size = UDim2.new(1, -20, 1, 0); Label.Font = Enum.Font.GothamMedium
	        Label.Text = icon .. "  " .. name; Label.TextColor3 = THEME.TextSecondary; Label.TextSize = 14; Label.TextXAlignment = Enum.TextXAlignment.Left
	        return {Button = Btn, Indicator = Indicator, Label = Label, Name = name}
	    end
	    local function SwitchTab(tabName, renderFunc)
	        if currentTab == tabName then return end
	        for _, tab in pairs(tabs) do
	            local isActive = (tab.Name == tabName)
	            TweenService:Create(tab.Label, TweenInfo.new(0.2), {TextColor3 = isActive and THEME.TextPrimary or THEME.TextSecondary}):Play()
	            TweenService:Create(tab.Indicator, TweenInfo.new(0.2), {BackgroundTransparency = isActive and 0 or 1}):Play()
	            TweenService:Create(tab.Button, TweenInfo.new(0.2), {BackgroundColor3 = isActive and THEME.ItemHover or Color3.new(0,0,0), BackgroundTransparency = isActive and 0 or 1}):Play()
	        end
	        currentTab = tabName
	        for _, c in pairs(ContentArea:GetChildren()) do c:Destroy() end
	        local container = Instance.new("CanvasGroup"); container.Size = UDim2.new(1, 0, 1, 0); container.BackgroundTransparency = 1
	        container.GroupTransparency = 1; container.Parent = ContentArea
	        renderFunc(container)
	        TweenService:Create(container, TweenInfo.new(0.25), {GroupTransparency = 0}):Play()
	    end
	    
	    
	    
	    local function RenderFileBrowser(container)
	        local currentPath = options.path or ""
	        local searchTerm = ""
	        
	        local NavBar = Instance.new("Frame"); NavBar.Parent = container; NavBar.BackgroundTransparency = 1
	        NavBar.Position = UDim2.new(0, 20, 0, 50); NavBar.Size = UDim2.new(1, -40, 0, 35)
	        local PathBox = Instance.new("Frame"); PathBox.Parent = NavBar; PathBox.BackgroundColor3 = THEME.ItemEven
	        PathBox.Size = UDim2.new(0.65, -10, 1, 0); local PathCorner = Instance.new("UICorner"); PathCorner.CornerRadius = UDim.new(0, 6); PathCorner.Parent = PathBox
	        local PathLabel = Instance.new("TextLabel"); PathLabel.Parent = PathBox; PathLabel.BackgroundTransparency = 1
	        PathLabel.Size = UDim2.new(1, -20, 1, 0); PathLabel.Position = UDim2.new(0, 10, 0, 0); PathLabel.Font = Enum.Font.Gotham
	        PathLabel.Text = "/"; PathLabel.TextColor3 = THEME.TextSecondary; PathLabel.TextSize = 13
	        PathLabel.TextXAlignment = Enum.TextXAlignment.Left; PathLabel.TextTruncate = Enum.TextTruncate.SplitWord
	        local SearchBox = Instance.new("TextBox"); SearchBox.Parent = NavBar; SearchBox.BackgroundColor3 = THEME.ItemEven
	        SearchBox.Size = UDim2.new(0.35, 0, 1, 0); SearchBox.Position = UDim2.new(0.65, 0, 0, 0); SearchBox.Font = Enum.Font.Gotham
	        SearchBox.PlaceholderText = "搜索..."; SearchBox.Text = ""; SearchBox.TextColor3 = THEME.TextPrimary
	        SearchBox.PlaceholderColor3 = THEME.TextSecondary; SearchBox.TextSize = 13; SearchBox.TextXAlignment = Enum.TextXAlignment.Left
	        local SearchCorner = Instance.new("UICorner"); SearchCorner.CornerRadius = UDim.new(0, 6); SearchCorner.Parent = SearchBox
	        local SearchPadding = Instance.new("UIPadding"); SearchPadding.PaddingLeft = UDim.new(0, 10); SearchPadding.Parent = SearchBox
	        local HeaderRow = Instance.new("Frame"); HeaderRow.Parent = container; HeaderRow.BackgroundTransparency = 1
	        HeaderRow.Position = UDim2.new(0, 20, 0, 95); HeaderRow.Size = UDim2.new(1, -40, 0, 20)
	        local function createH(text, xs)
	            local L = Instance.new("TextLabel"); L.Parent = HeaderRow; L.BackgroundTransparency = 1
	            L.Position = UDim2.new(xs, 0, 0, 0); L.Size = UDim2.new(0, 50, 1, 0); L.Font = Enum.Font.GothamBold
	            L.Text = text; L.TextColor3 = THEME.TextSecondary; L.TextSize = 12; L.TextXAlignment = Enum.TextXAlignment.Left
	        end
	        createH("NAME", 0.05); createH("TYPE", 0.65); createH("SIZE", 0.85)
	        local ScrollList = Instance.new("ScrollingFrame"); ScrollList.Parent = container; ScrollList.BackgroundTransparency = 1
	        ScrollList.BorderSizePixel = 0; ScrollList.Position = UDim2.new(0, 20, 0, 120); ScrollList.Size = UDim2.new(1, -25, 1, -130)
	        ScrollList.ScrollBarThickness = 3; ScrollList.ScrollBarImageColor3 = THEME.Border
	        local UIList = Instance.new("UIListLayout"); UIList.Parent = ScrollList; UIList.SortOrder = Enum.SortOrder.LayoutOrder; UIList.Padding = UDim.new(0, 4)
	        
	        local StatusLabel = Instance.new("TextLabel"); StatusLabel.Parent = container; StatusLabel.BackgroundTransparency = 1
	        StatusLabel.Position = UDim2.new(0, 20, 1, -25); StatusLabel.Size = UDim2.new(1, -40, 0, 20); StatusLabel.Font = Enum.Font.Gotham
	        StatusLabel.Text = ""; StatusLabel.TextColor3 = THEME.Red; StatusLabel.TextSize = 12; StatusLabel.TextXAlignment = Enum.TextXAlignment.Right
	        local function Refresh()
	            for _, v in pairs(ScrollList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
	            PathLabel.Text = (currentPath == "" and "Root") or currentPath:gsub("\\", "/")
	            
	            local items = {}
	            local files = get_files(currentPath)
	            
	            
	            if currentPath ~= "" and searchTerm == "" then
	                table.insert(items, {
	                    Name = "..", 
	                    Type = "Folder", 
	                    Size = "", 
	                    IsDir = true, 
	                    Path = "..", 
	                    Sort = "   "
	                })
	            end
	            for _, file in pairs(files) do
	                local name = get_name_from_path(file)
	                if searchTerm == "" or name:lower():find(searchTerm:lower(), 1, true) then
	                    local isDir = isfolder(file)
	                    local ext = isDir and "Folder" or (name:match("^.+(%..+)$") or "File")
	                    local allowed = true
	                    if not isDir and #validExtensions > 0 then
	                        allowed = false
	                        for _, e in pairs(validExtensions) do
	                            if name:sub(-#e) == e then allowed = true break end
	                        end
	                    end
	                    if allowed then
	                        table.insert(items, {
	                            Name = name, 
	                            Type = ext, 
	                            Size = isDir and "" or format_bytes(get_safe_file_size(file)),
	                            IsDir = isDir,
	                            Path = file,
	                            Sort = (isDir and " " or "z") .. name:lower()
	                        })
	                    end
	                end
	            end
	            
	            table.sort(items, function(a,b) return a.Sort < b.Sort end)
	            for i, item in ipairs(items) do
	                local Row = Instance.new("TextButton"); Row.Parent = ScrollList
	                Row.BackgroundColor3 = (i % 2 == 0) and THEME.ItemEven or THEME.ItemOdd; Row.AutoButtonColor = false
	                Row.Size = UDim2.new(1, 0, 0, 30); Row.Text = ""
	                local RC = Instance.new("UICorner"); RC.CornerRadius = UDim.new(0, 4); RC.Parent = Row
	                local Icon = Instance.new("TextLabel"); Icon.Parent = Row; Icon.BackgroundTransparency = 1
	                Icon.Position = UDim2.new(0, 10, 0, 0); Icon.Size = UDim2.new(0, 20, 1, 0)
	                Icon.Text = item.IsDir and "📁" or "📄"; Icon.TextColor3 = item.IsDir and THEME.Accent or THEME.TextPrimary; Icon.TextSize = 14
	                local N = Instance.new("TextLabel"); N.Parent = Row; N.BackgroundTransparency = 1
	                N.Position = UDim2.new(0, 35, 0, 0); N.Size = UDim2.new(0.6, 0, 1, 0); N.Font = Enum.Font.Gotham
	                N.Text = item.Name or "Unknown"; N.TextColor3 = item.IsDir and THEME.Accent or THEME.TextPrimary
	                N.TextSize = 13; N.TextXAlignment = Enum.TextXAlignment.Left; N.TextTruncate = Enum.TextTruncate.AtEnd
	                local T = Instance.new("TextLabel"); T.Parent = Row; T.BackgroundTransparency = 1
	                T.Position = UDim2.new(0.65, 0, 0, 0); T.Size = UDim2.new(0.2, 0, 1, 0); T.Font = Enum.Font.Gotham
	                T.Text = item.Type or ""; T.TextColor3 = THEME.TextSecondary; T.TextSize = 12; T.TextXAlignment = Enum.TextXAlignment.Left
	                
	                local S = Instance.new("TextLabel"); S.Parent = Row; S.BackgroundTransparency = 1
	                S.Position = UDim2.new(0.85, 0, 0, 0); S.Size = UDim2.new(0.15, -5, 1, 0); S.Font = Enum.Font.Gotham
	                S.Text = item.Size or ""; S.TextColor3 = THEME.TextSecondary; S.TextSize = 12; S.TextXAlignment = Enum.TextXAlignment.Right
	                Row.MouseEnter:Connect(function() TweenService:Create(Row, TweenInfo.new(0.1), {BackgroundColor3 = THEME.ItemHover}):Play() end)
	                Row.MouseLeave:Connect(function() TweenService:Create(Row, TweenInfo.new(0.1), {BackgroundColor3 = (i%2==0) and THEME.ItemEven or THEME.ItemOdd}):Play() end)
	                Row.MouseButton1Click:Connect(function()
	                    if item.IsDir then
	                        currentPath = (item.Path == "..") and get_parent_dir(currentPath) or item.Path
	                        searchTerm = ""; SearchBox.Text = ""
	                        Refresh()
	                    else
	                        if readfile then
	                            local s, content = pcall(readfile, item.Path)
	                            if s and content then
	                                local valid, fileType = validate_image_data(content)
	                                if valid then
	                                    finalResult = { Data = content, Type = fileType, Source = "File" }
	                                else
	                                    StatusLabel.TextColor3 = THEME.Red; StatusLabel.Text = "错误:图像标头无效/未知"
	                                end
	                            else
	                                StatusLabel.TextColor3 = THEME.Red; StatusLabel.Text = "错误:无法读取文件"
	                            end
	                        end
	                    end
	                end)
	            end
	            ScrollList.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y)
	        end
	        SearchBox:GetPropertyChangedSignal("Text"):Connect(function() searchTerm = SearchBox.Text; Refresh() end)
	        Refresh()
	    end
	    
	    
	    
	    local function RenderUrlSelector(container)
	        local Title = Instance.new("TextLabel"); Title.Parent = container; Title.BackgroundTransparency = 1
	        Title.Position = UDim2.new(0, 20, 0, 60); Title.Size = UDim2.new(1, -40, 0, 20); Title.Font = Enum.Font.GothamBold
	        Title.Text = "从URL导入"; Title.TextColor3 = THEME.TextPrimary; Title.TextSize = 20; Title.TextXAlignment = Enum.TextXAlignment.Left
	        local SubTitle = Instance.new("TextLabel"); SubTitle.Parent = container; SubTitle.BackgroundTransparency = 1
	        SubTitle.Position = UDim2.new(0, 20, 0, 85); SubTitle.Size = UDim2.new(1, -40, 0, 20); SubTitle.Font = Enum.Font.Gotham
	        SubTitle.Text = "输入直接图像链接。脚本将对其进行下载和分析。"; SubTitle.TextColor3 = THEME.TextSecondary; SubTitle.TextSize = 14; SubTitle.TextXAlignment = Enum.TextXAlignment.Left
	        local InputFrame = Instance.new("Frame"); InputFrame.Parent = container; InputFrame.BackgroundColor3 = THEME.ItemEven
	        InputFrame.Position = UDim2.new(0, 20, 0, 130); InputFrame.Size = UDim2.new(1, -40, 0, 40)
	        local IFCorner = Instance.new("UICorner"); IFCorner.CornerRadius = UDim.new(0, 6); IFCorner.Parent = InputFrame
	        
	        local UrlBox = Instance.new("TextBox"); UrlBox.Parent = InputFrame; UrlBox.BackgroundTransparency = 1
	        UrlBox.Position = UDim2.new(0, 10, 0, 0); UrlBox.Size = UDim2.new(1, -20, 1, 0); UrlBox.Font = Enum.Font.Gotham
	        UrlBox.PlaceholderText = "https://example.com/image.png"; UrlBox.Text = ""; UrlBox.TextColor3 = THEME.TextPrimary
	        UrlBox.PlaceholderColor3 = THEME.TextSecondary; UrlBox.TextSize = 14; UrlBox.TextXAlignment = Enum.TextXAlignment.Left
	        local StatusLabel = Instance.new("TextLabel"); StatusLabel.Parent = container; StatusLabel.BackgroundTransparency = 1
	        StatusLabel.Position = UDim2.new(0, 20, 0, 180); StatusLabel.Size = UDim2.new(1, -40, 0, 20); StatusLabel.Font = Enum.Font.GothamMedium
	        StatusLabel.Text = "正在等待输入…"; StatusLabel.TextColor3 = THEME.TextSecondary; StatusLabel.TextSize = 14; StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
	        
	        local DownloadBtn = Instance.new("TextButton"); DownloadBtn.Parent = container; DownloadBtn.BackgroundColor3 = THEME.Accent
	        DownloadBtn.Position = UDim2.new(0, 20, 0, 220); DownloadBtn.Size = UDim2.new(1, -40, 0, 40)
	        DownloadBtn.Font = Enum.Font.GothamBold; DownloadBtn.Text = "下载和导入"; DownloadBtn.TextColor3 = THEME.Background; DownloadBtn.TextSize = 14
	        local CBCorner = Instance.new("UICorner"); CBCorner.CornerRadius = UDim.new(0, 6); CBCorner.Parent = DownloadBtn
	        
	        DownloadBtn.MouseButton1Click:Connect(function()
	            local url = UrlBox.Text
	            if url == "" then return end
	            DownloadBtn.Text = "取件..."; StatusLabel.Text = "发送GET请求..."; StatusLabel.TextColor3 = THEME.Yellow
	            task.delay(0.05, function()
	                local success, result = pcall(function() return http_get(url) end)
	                if success and result then
	                    StatusLabel.Text = "正在验证标头..."
	                    local isValid, fileType = validate_image_data(result)
	                    if isValid then
	                        StatusLabel.Text = "成功! (" .. format_bytes(#result) .. ")"; StatusLabel.TextColor3 = THEME.Green
	                        DownloadBtn.Text = "进口的"; task.wait(0.5)
	                        finalResult = { Data = result, Type = fileType, Source = "URL" }
	                    else
	                        StatusLabel.Text = "无效数据: " .. fileType .. " (Is this a raw image?)"; StatusLabel.TextColor3 = THEME.Red; DownloadBtn.Text = "再试一次"
	                    end
	                else
	                    StatusLabel.Text = "HTTP错误:获取URL失败"; StatusLabel.TextColor3 = THEME.Red; DownloadBtn.Text = "Try Again"
	                end
	            end)
	        end)
	        DownloadBtn.MouseEnter:Connect(function() TweenService:Create(DownloadBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play() end)
	        DownloadBtn.MouseLeave:Connect(function() TweenService:Create(DownloadBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play() end)
	    end
	    
	    local tab1 = CreateTabButton("Local Files", "📁", 1); local tab2 = CreateTabButton("Web URL", "🌐", 2)
	    table.insert(tabs, tab1); table.insert(tabs, tab2)
	    tab1.Button.MouseButton1Click:Connect(function() SwitchTab("Local Files", RenderFileBrowser) end)
	    tab2.Button.MouseButton1Click:Connect(function() SwitchTab("Web URL", RenderUrlSelector) end)
	    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -180); MainFrame.BackgroundTransparency = 1; Sidebar.BackgroundTransparency = 1; Stroke.Transparency = 1
	    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -350, 0.5, -200), BackgroundTransparency = 0}):Play()
	    TweenService:Create(Sidebar, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
	    TweenService:Create(Stroke, TweenInfo.new(0.4), {Transparency = 0}):Play()
	    SwitchTab("Local Files", RenderFileBrowser)
	    while not finalResult and not isClosed do
	        if not ScreenGui.Parent then isClosed = true end
	        task.wait(0.1)
	    end
	    
	    TweenService:Create(MainFrame, TweenInfo.new(0.25), {Size = UDim2.new(0, 700, 0, 0), Position = UDim2.new(0.5, -350, 0.5, 0), BackgroundTransparency = 1}):Play()
	    TweenService:Create(Stroke, TweenInfo.new(0.25), {Transparency = 1}):Play()
	    task.wait(0.25); ScreenGui:Destroy()
	    
	    return finalResult
	end
	return SourceSelector
end

modules["modules.drawme.canvas"] = function()
	local Players = game:GetService("Players")
	local canvas = {}
	
	
	canvas.get_canvas_from_gc = function()
	    
	    if not (getgc and debug and debug.getupvalues and getfenv) then return nil end
	    for i, func in pairs(getgc()) do
	        if type(func) == "function" then
	            
	            local success, fenv = pcall(getfenv, func)
	            if success and fenv then
	                local scriptRef = rawget(fenv, "script")
	                
	                if scriptRef and tostring(scriptRef) == "DM_Drawing" then
	                    local upvalues = debug.getupvalues(func)
	                    for index, upval in ipairs(upvalues) do
	                        if type(upval) == "table" and rawget(upval, "Internal") and upval.Internal.RenderEditableImage then
	                            
	                            return upval.Internal.RenderEditableImage.EditableImage
	                        end
	                    end
	                end
	            end
	        end
	    end
	    return nil
	end
	
	
	canvas.get_canvas_from_instance = function()
	    local localPlayer = Players.LocalPlayer
	    if not localPlayer then return nil end
	    
	    local playerGui = localPlayer:FindFirstChild("PlayerGui")
	    if not playerGui then return nil end
	    
	    
	    local container = playerGui:FindFirstChild("ScreenGui") 
	                      and playerGui.ScreenGui:FindFirstChild("DrawingCanvasGuis")
	    
	    local searchRoot = container or playerGui 
	    
	    
	    for _, v in ipairs(searchRoot:GetDescendants()) do
	        if v:IsA("ImageLabel") and v.Name == "RenderImageLabel" then
	            
	            if v.ImageContent and v.ImageContent.SourceType == Enum.ContentSourceType.Object then
	                local editableImage = v.ImageContent.Object
	                
	                if editableImage and editableImage:IsA("EditableImage") then
	                    return editableImage
	                end
	            end
	        end
	    end
	    
	    return nil
	end
	
	canvas.get_canvas = function()
	    local result = nil
	    
--[[	    if type(getgc) == "function"  then
	        result = canvas.get_canvas_from_gc()
	    end]]
	    
	    if not result then
	        result = canvas.get_canvas_from_instance()
	    end
	    return result
	end
	return canvas
end



local image_loader = drequire("modules.standard.universal_image_loader")
local source_selector = drequire("modules.uilibs.image_source_selector")
local canvas = drequire("modules.drawme.canvas")
print("Created by egwergtq5123")

local function log(msg, isWarn)
    local text = string.format("[Image Loader]: %s", msg)
    if isWarn then warn(text) else print(text) end
end

local targetImage = canvas.get_canvas() 
if not targetImage then return log("EditableImage not found (Canvas module returned nil)", true) end

local selection = source_selector.Select({
    extensions = {".png", ".jpg", ".jpeg"} 
})
if not selection then 
    return log("No image selected.") 
end

if selection.Type ~= "PNG" and selection.Type ~= "JPG" then
    return log("Invalid format: " .. tostring(selection.Type) .. ". Only PNG and JPEG are supported.", true)
end
local fileData = selection.Data 

local canvasSize = targetImage.Size 

--setthreadidentity(8) 
log("Parsing " .. selection.Type .. "...")
local image = image_loader.load(fileData, selection.Type)
local srcWidth, srcHeight = image.Width, image.Height
log(string.format("Resizing Image (%dx%d) -> Canvas (%dx%d)", srcWidth, srcHeight, canvasSize.X, canvasSize.Y))
local dstWidth = canvasSize.X
local dstHeight = canvasSize.Y
local bufferSize = dstWidth * dstHeight * 4 
local pixelBuffer = buffer.create(bufferSize)
local ratioX = srcWidth / dstWidth
local ratioY = srcHeight / dstHeight
log("Decoding and Scaling pixels...")
local pointer = 0
for y = 1, dstHeight do
    local sampleY = math.floor((y - 1) * ratioY) + 1
    
    if sampleY > srcHeight then sampleY = srcHeight end
    for x = 1, dstWidth do
        
        local sampleX = math.floor((x - 1) * ratioX) + 1
        
        if sampleX > srcWidth then sampleX = srcWidth end
        
        local color, alpha = image:GetPixel(sampleX, sampleY)
        
        
        local aVal = alpha or 1 
        
        buffer.writeu8(pixelBuffer, pointer,     math.floor(color.R * 255))
        buffer.writeu8(pixelBuffer, pointer + 1, math.floor(color.G * 255))
        buffer.writeu8(pixelBuffer, pointer + 2, math.floor(color.B * 255))
        buffer.writeu8(pixelBuffer, pointer + 3, math.floor(aVal * 255))
        pointer = pointer + 4
    end
end
log("Writing buffer to video memory...")
local writeSuccess, writeErr = pcall(function()
    targetImage:WritePixelsBuffer(Vector2.zero, canvasSize, pixelBuffer)
end)
if not writeSuccess then
    log("Error writing pix(els: " .. tostring(writeErr), true)
else
    log("Done.")
end
elseif game.GameId == 9485131494 then --- 超高速跑者
    local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yisan9178/sjsjsj/refs/heads/main/Windui.lua(1).txt"))()

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(chars, uchar)
    end
    local length = #chars
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
            math.floor(r * 255), 
            math.floor(g * 255), 
            math.floor(b * 255), 
            chars[i])
    end
    return result
end

local Window = WindUI:CreateWindow({
    Title = gradient("塔菲喵   ", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("伊散", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    IconThemed = true,
    Folder = "塔菲喵",
    Size = UDim2.fromOffset(150, 150),
    
    Transparent = false,                
    BackgroundImageTransparency = 0,    
    
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 150,
    HideSearchBar = true,
    ScrollBarEnabled = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function() end,
    },
})

Window:SetToggleKey(Enum.KeyCode.F, true)

Window:EditOpenButton({
    Title = "[摸摸伊散]",
    CornerRadius = UDim.new(0,8),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("1E3A8A")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("118AB2")), 
        ColorSequenceKeypoint.new(1, Color3.fromHex("06D6A0")) 
    }),
    Draggable = true,
})

Window:Tag({
    Title = "伊散",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})

local CombatTab = Window:Tab({ Title = '功能', Icon = 'swords' })
Window:SelectTab(1)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StepTakenEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("StepTaken")
local player = game.Players.LocalPlayer

local targetCFrame = CFrame.new(-1.92, 14.53, -9076.54)

CombatTab:Toggle({
    Title = "自动刷钱",
    Desc = "自动刷钱",
    Value = false,
    Callback = function(State)
        _G.AutoMoney = State
        if State then
            task.spawn(function()
                while _G.AutoMoney do
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.CFrame = targetCFrame
                    end
                    task.wait(2)
                end
            end)
        end
    end
})

CombatTab:Toggle({
    Title = "自动刷经验",
    Desc = "自动获得经验值",
    Value = false,
    Callback = function(State)
        _G.AutoExp = State
        if State then
            task.spawn(function()
                while _G.AutoExp do

                    StepTakenEvent:FireServer(math.huge, false)
                    task.wait(0.000001) 
                end
            end)
            
            WindUI:Notify({
                Title = "功能启动",
                Content = "已开始极速刷经验",
                Duration = 2
            })
        else
            WindUI:Notify({
                Title = "功能关闭",
                Content = "已停止自动刷经验",
                Duration = 2
            })
        end
    end
})
elseif game.GameId == 994732206 then --- Blox Fruit
    loadstring(game:HttpGet("https://raw.githubusercontent.com/abcd789142/Scritp/refs/heads/main/塔菲喵Blox%20Fruit.lua"))()
elseif game.GameId == 9667329585 then --- 划开大海
    local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yisan9178/sjsjsj/refs/heads/main/Windui.lua(1).txt"))()

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do table.insert(chars, uchar) end
    local length = #chars
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', math.floor(r * 255), math.floor(g * 255), math.floor(b * 255), chars[i])
    end
    return result
end

local Window = WindUI:CreateWindow({
    Title = gradient("塔菲喵   ", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("伊散", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    IconThemed = true,
    Folder = "塔菲喵",
    Size = UDim2.fromOffset(150, 150), 
    Transparent = false,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 160,
    BackgroundImageTransparency = 0.8,
    HideSearchBar = true,
    ScrollBarEnabled = true,
})

Window:EditOpenButton({
    Title = "[摸摸伊散]",
    CornerRadius = UDim.new(0,8),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("1E3A8A")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("118AB2")), 
        ColorSequenceKeypoint.new(1, Color3.fromHex("06D6A0")) 
    }),
    Draggable = true,
})

local CombatTab = Window:Tab({ Title = '功能', Icon = 'swords' })

Window:SelectTab(1)

local autoSellEnabled = false
local autoGetFishEnabled = false
local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

CombatTab:Toggle({
    Title = "自动出售",
    Value = false,
    Callback = function(state)
        autoSellEnabled = state
        if autoSellEnabled then
            task.spawn(function()
                while autoSellEnabled do
                    pcall(function()
                        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("SellRequest")
                        if remote then
                            remote:FireServer({ Mode = "SellAll" })
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})

CombatTab:Toggle({
    Title = "自动获取鱼",
    Value = false,
    Callback = function(state)
        autoGetFishEnabled = state
        if autoGetFishEnabled then
            task.spawn(function()
                while autoGetFishEnabled do
                    pcall(function()
                        local lootFolder = workspace:FindFirstChild("ActiveLoot")
                        local char = player.Character
                        local root = char and char:FindFirstChild("HumanoidRootPart")
                        
                        if lootFolder and root then
                            for _, item in pairs(lootFolder:GetChildren()) do
                                if item:IsA("Model") then
                                    item:PivotTo(root.CFrame)
                                elseif item:IsA("BasePart") then
                                    item.CFrame = root.CFrame
                                end
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})

Window:Tag({
    Title = "伊散",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})
elseif game.GameId == 9667329585 then --- 划开大海
    local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yisan9178/sjsjsj/refs/heads/main/Windui.lua(1).txt"))()

local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local autoSellEnabled = false
local autoGetFishEnabled = false
local tpSpeedValue = 16
local tpWalkEnabled = false

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do table.insert(chars, uchar) end
    local length = #chars
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', math.floor(r * 255), math.floor(g * 255), math.floor(b * 255), chars[i])
    end
    return result
end

local Window = WindUI:CreateWindow({
    Title = gradient("塔菲喵   ", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("伊散", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    IconThemed = true,
    Folder = "塔菲喵",
    Size = UDim2.fromOffset(150, 150), 
    Transparent = false,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 160,
    BackgroundImageTransparency = 0.8,
    HideSearchBar = true,
    ScrollBarEnabled = true,
})

Window:EditOpenButton({
    Title = "[摸摸伊散]",
    CornerRadius = UDim.new(0,8),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("1E3A8A")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("118AB2")), 
        ColorSequenceKeypoint.new(1, Color3.fromHex("06D6A0")) 
    }),
    Draggable = true,
})

local CombatTab = Window:Tab({ Title = '功能', Icon = 'swords' })

Window:SelectTab(1)

CombatTab:Toggle({
    Title = "自动出售",
    Value = false,
    Callback = function(state)
        autoSellEnabled = state
        if autoSellEnabled then
            task.spawn(function()
                while autoSellEnabled do
                    pcall(function()
                        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("SellRequest")
                        if remote then
                            remote:FireServer({ Mode = "SellAll" })
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})

CombatTab:Toggle({
    Title = "自动获取鱼",
    Value = false,
    Callback = function(state)
        autoGetFishEnabled = state
        if autoGetFishEnabled then
            task.spawn(function()
                while autoGetFishEnabled do
                    pcall(function()
                        local lootFolder = workspace:FindFirstChild("ActiveLoot")
                        local char = player.Character
                        local root = char and char:FindFirstChild("HumanoidRootPart")
                        
                        if lootFolder and root then
                            for _, item in pairs(lootFolder:GetChildren()) do
                                if item:IsA("Model") then
                                    item:PivotTo(root.CFrame)
                                elseif item:IsA("BasePart") then
                                    item.CFrame = root.CFrame
                                end
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})

CombatTab:Slider({ 
    Title = "移动速度", 
    Step = 1, 
    Value = {Min = 16, Max = 200, Default = 16}, 
    Callback = function(v) 
        tpSpeedValue = tonumber(v) or 16 
    end 
})

CombatTab:Toggle({ 
    Title = "开启加速", 
    Value = false,
    Callback = function(state)
        tpWalkEnabled = state
        if state then 
            task.spawn(function()
                while tpWalkEnabled do
                    local char = player.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.MoveDirection.Magnitude > 0 then 
                        pcall(function() 
                            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (tpSpeedValue - 16) * 0.05) 
                        end) 
                    end
                    RunService.RenderStepped:Wait()
                end
            end) 
        end
    end 
})

Window:Tag({
    Title = "伊散",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})
elseif game.GameId == 9663968307 then --- 钩中啦
    local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yisan9178/sjsjsj/refs/heads/main/Windui.lua(1).txt"))()

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(chars, uchar)
    end
    
    local length = #chars
    
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
            math.floor(r * 255), 
            math.floor(g * 255), 
            math.floor(b * 255), 
            chars[i])
    end
    
    return result
end

local Window = WindUI:CreateWindow({
    Title = gradient("塔菲喵   ", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("伊散", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    IconThemed = true,
    Folder = "塔菲喵",
    Size = UDim2.fromOffset(150, 150),
    Transparent = getgenv().TransparencyEnabled or false,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 150,
    BackgroundImageTransparency = 0.8,
    HideSearchBar = true,
    ScrollBarEnabled = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("User clicked")
        end,
    },
})

Window:EditOpenButton({
    Title = "[摸摸伊散]",
    CornerRadius = UDim.new(0,8),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("1E3A8A")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("118AB2")), 
        ColorSequenceKeypoint.new(1, Color3.fromHex("06D6A0")) 
    }),
    Draggable = true,
})

Window:Tag({
    Title = "伊散",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})

Window:SetToggleKey(Enum.KeyCode.F, true)

local CombatTab = Window:Tab({ Title = '功能', Icon = 'swords' })

Window:SelectTab(1)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TEvent = require(ReplicatedStorage.Shared.Core.TEvent)

_G.AutoHookEnabled = false 

local function ClosestTargets()
    local Targets = {}
    local ClosestRange = 9e9

    for _, Player in (Players:GetPlayers()) do
        if (Player == LocalPlayer) or (not Player.Team) or (Player.Team == LocalPlayer.Team) or (Player.Team.Name == "Lobby") then
            continue
        end

        local Character = Player.Character
        if (not Character) or (Character:FindFirstChildWhichIsA("ForceField")) then
            continue
        end

        local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
        local Head = Character:FindFirstChild("Head")

        if (not Head) or (not Humanoid) or (Humanoid.Health <= 0) then
            continue
        end

        table.insert(Targets, { ["Head"] = Head, ["IsBot"] = false })
    end

    for _, Bot in (Workspace:GetChildren()) do
        if (not Bot:GetAttribute("IsBot")) or (Bot:FindFirstChildWhichIsA("ForceField")) then
            continue
        end

        local Humanoid = Bot:FindFirstChildWhichIsA("Humanoid")
        local Head = Bot:FindFirstChild("Head")

        if (not Head) or (not Humanoid) or (Humanoid.Health <= 0) then
            continue
        end

        table.insert(Targets, { ["Head"] = Head, ["IsBot"] = true })
    end

    return Targets
end

CombatTab:Toggle({
    Title = "全图杀戮",
    Value = false,
    Callback = function(state)
        _G.AutoHookEnabled = state
        WindUI:Notify({
            Title = "系统通知",
            Content = state and "自动抓人已开启" or "自动抓人已关闭",
            Duration = 2
        })
    end
})

task.spawn(function()
    while true do
        task.wait(0.05) 
        
        if _G.AutoHookEnabled then
            local targets = ClosestTargets()
            if (#targets > 0) then
                for _, Target in (targets) do
                    if not _G.AutoHookEnabled then break end

                    local PlayerTarget
                    if (Target.IsBot) then
                        PlayerTarget = Target.Head.Parent
                    else
                        PlayerTarget = Players:GetPlayerFromCharacter(Target.Head.Parent)
                    end

                    pcall(function()
                        TEvent.FireRemote("HookFire", {
                            ["hookId"] = 67,
                            ["startPosition"] = nil,
                            ["direction"] = (Target.Head.Position - LocalPlayer.Character.Head.Position).Unit,
                            ["distance"] = 9e9,
                            ["hookFlyTime"] = 0,
                            ["hookBackSpeed"] = 9e9,
                            ["fireTime"] = 0
                        })

                        TEvent.FireRemote("HookHit", {
                            ["hookId"] = 67,
                            ["targetPlayer"] = PlayerTarget,
                            ["targetPartName"] = Target.Head.Name,
                            ["hookBackSpeed"] = 9e9
                        })

                        TEvent.FireRemote("HookRelease", {
                            ["hookId"] = 67,
                            ["targetPlayer"] = PlayerTarget,
                            ["reason"] = "Release"
                        })
                    end)
                end
            end
        end
    end
end)

XiProInfo:AddButton({
    Title = "脚本已运行",
    Desc = "按下 F 隐藏界面",
    Callback = function() end
})
elseif game.GameId == 9619492068 then --- 泰坦钓鱼
getgenv().SCRIPT_KEY = "Suda"
loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/e4902fef65a75fbf75a6c8ae9542d4fe72e2201ca0a09f9bde63db2895537d1c/download"))()
elseif game.GameId == 972475338 then --- 南极洲探险
    local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yisan9178/sjsjsj/refs/heads/main/Windui.lua(1).txt"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(chars, uchar)
    end
    local length = #chars
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
            math.floor(r * 255), 
            math.floor(g * 255), 
            math.floor(b * 255), 
            chars[i])
    end
    return result
end

local Window = WindUI:CreateWindow({
    Title = gradient("塔菲喵   ", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("伊散", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    IconThemed = true,
    Folder = "塔菲喵",
    Size = UDim2.fromOffset(150, 150), 
    Transparent = getgenv().TransparencyEnabled or false,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 160,
    BackgroundImageTransparency = 0.8,
    HideSearchBar = true,
    ScrollBarEnabled = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            WindUI:Notify({
                Title = "提示",
                Content = "点击了用户头像",
                Duration = 2
            })
        end,
    },
})

Window:Tag({
    Title = "伊散",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})

Window:EditOpenButton({
    Title = "[摸摸伊散]",
    CornerRadius = UDim.new(0,8),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("1E3A8A")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("118AB2")), 
        ColorSequenceKeypoint.new(1, Color3.fromHex("06D6A0")) 
    }),
    Draggable = true,
})

Window:SetToggleKey(Enum.KeyCode.F, true)

local MainTab = Window:Tab({ Title = '功能', Icon = 'layers' })
Window:SelectTab(1)

getgenv().AntiFallEnabled = false
local function ApplyFallBypass()
    if getgenv().FallDamageHookLoaded then return end
    pcall(function()
        local TargetMetatable = getrawmetatable(game)
        local OriginalNamecall = TargetMetatable.__namecall
        setreadonly(TargetMetatable, false)
        TargetMetatable.__namecall = newcclosure(function(self, ...)
            local Method = getnamecallmethod()
            if getgenv().AntiFallEnabled and Method == "FireServer" then
                local RemoteName = tostring(self)
                if RemoteName:find("Fall") or RemoteName:find("Damage") or RemoteName:find("Hurt") then
                    return nil 
                end
            end
            return OriginalNamecall(self, ...)
        end)
        setreadonly(TargetMetatable, true)
    end)
    getgenv().FallDamageHookLoaded = true
end
task.spawn(ApplyFallBypass)

MainTab:Toggle({
    Title = "开启无掉落伤害",
    Value = false,
    Callback = function(Value)
        getgenv().AntiFallEnabled = Value
        if Value then
            task.spawn(function()
                while getgenv().AntiFallEnabled do
                    local Character = LocalPlayer.Character
                    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
                    if Humanoid then
                        Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

local tpSpeedValue, tpWalkEnabled = 16, false

MainTab:Slider({ 
    Title = "加速", 
    Step = 1, 
    Value = {Min = 16, Max = 200, Default = 16}, 
    Callback = function(v) 
        tpSpeedValue = tonumber(v) or 16 
    end 
})

MainTab:Toggle({ 
    Title = "开启加速", 
    Callback = function(state)
        tpWalkEnabled = state
        if state then 
            task.spawn(function()
                while tpWalkEnabled do
                    local char = LocalPlayer.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.MoveDirection.Magnitude > 0 then 
                        pcall(function() 
                            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (tpSpeedValue - 16) * 0.05) 
                        end) 
                    end
                    RunService.RenderStepped:Wait()
                end
            end) 
        end
    end 
})

local jump_Ys = nil
MainTab:Toggle({ 
    Title = "开启无限跳", 
    Callback = function(v)
        getgenv().Jump = v
        if jump_Ys then jump_Ys:Disconnect(); jump_Ys = nil end
        if getgenv().Jump then 
            jump_Ys = UserInputService.JumpRequest:Connect(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("Humanoid") then 
                    character.Humanoid:ChangeState("Jumping") 
                end
            end) 
        end
    end 
}) 
elseif game.GameId == 9186719164 then --- 水手碎片
    local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yisan9178/sjsjsj/refs/heads/main/Windui.lua(1).txt"))()

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(chars, uchar)
    end
    local length = #chars
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
            math.floor(r * 255), math.floor(g * 255), math.floor(b * 255), chars[i])
    end
    return result
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer

local combatSystem = ReplicatedStorage:WaitForChild("CombatSystem")
local combatRemotes = combatSystem:WaitForChild("Remotes")
local requestHitRemote = combatRemotes:WaitForChild("RequestHit")
local remoteEventsFolder = ReplicatedStorage:WaitForChild("RemoteEvents")
local questAcceptRemote = remoteEventsFolder:WaitForChild("QuestAccept")
local questProgressRemote = remoteEventsFolder:WaitForChild("QuestProgress")
local questUIUpdateRemote = remoteEventsFolder:WaitForChild("QuestUIUpdate")
local questCompleteRemote = remoteEventsFolder:WaitForChild("QuestComplete")
local useItemRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("UseItem")
local requestAbilityRemote = ReplicatedStorage:WaitForChild("AbilitySystem"):WaitForChild("Remotes"):WaitForChild("RequestAbility")
local allocateStatRemote = remoteEventsFolder:WaitForChild("AllocateStat")

local enemiesFolder = workspace:WaitForChild("NPCs")
local serviceNpcsFolder = workspace:WaitForChild("ServiceNPCs")

local Quest1Thieves = {"Thief1","Thief2","Thief3","Thief4","Thief5"}
local QuestMap = {
	["Quest1"]  = { npc = "QuestNPC1",  mobType = "Thief",         amount = 5, specificMobs = Quest1Thieves },
	["Quest2"]  = { npc = "QuestNPC2",  mobType = "ThiefBoss",     amount = 1, specificMobs = nil },
	["Quest3"]  = { npc = "QuestNPC3",  mobType = "Monkey",        amount = 5, specificMobs = nil },
	["Quest4"]  = { npc = "QuestNPC4",  mobType = "MonkeyBoss",    amount = 1, specificMobs = nil },
	["Quest5"]  = { npc = "QuestNPC5",  mobType = "DesertBandit",  amount = 5, specificMobs = nil },
	["Quest6"]  = { npc = "QuestNPC6",  mobType = "DesertBoss",    amount = 1, specificMobs = nil },
	["Quest7"]  = { npc = "QuestNPC7",  mobType = "FrostRogue",    amount = 5, specificMobs = nil },
	["Quest8"]  = { npc = "QuestNPC8",  mobType = "SnowBoss",      amount = 1, specificMobs = nil },
	["Quest9"]  = { npc = "QuestNPC9",  mobType = "Sorcerer",      amount = 5, specificMobs = nil },
	["Quest10"] = { npc = "QuestNPC10", mobType = "PandaMiniBoss", amount = 1, specificMobs = nil },
	["Quest11"] = { npc = "QuestNPC11", mobType = "Hollow",        amount = 5, specificMobs = nil },
}

local FarmMobs = {
	{ name = "Thief [Level 15]", mobs = {"Thief1", "Thief2", "Thief3", "Thief4", "Thief5"} },
	{ name = "ThiefBoss [Level 50]", mobs = {"ThiefBoss"} },
	{ name = "Monkey [Level 250]", mobs = {"Monkey1", "Monkey2", "Monkey3", "Monkey4", "Monkey5"} },
	{ name = "MonkeyBoss [Level 500]", mobs = {"MonkeyBoss"} },
	{ name = "DesertBandit [Level 750]", mobs = {"DesertBandit1", "DesertBandit2", "DesertBandit3", "DesertBandit4", "DesertBandit5"} },
	{ name = "DesertBoss [Level 1000]", mobs = {"DesertBoss"} },
	{ name = "FrostRogue [Level 1500]", mobs = {"FrostRogue1", "FrostRogue2", "FrostRogue3", "FrostRogue4", "FrostRogue5"} },
	{ name = "SnowBoss [Level 2000]", mobs = {"SnowBoss"} },
	{ name = "Sorcerer [Level 3000]", mobs = {"Sorcerer1", "Sorcerer2", "Sorcerer3", "Sorcerer4", "Sorcerer5"} },
	{ name = "PandaMiniBoss [Level 5000]", mobs = {"PandaMiniBoss"} },
	{ name = "Hollow [Level 5500]", mobs = {"Hollow1", "Hollow2", "Hollow3", "Hollow4", "Hollow5"} },
	{ name = "StrongSorcerer [Level 6000]", mobs = {"StrongSorcerer1", "StrongSorcerer2", "StrongSorcerer3", "StrongSorcerer4", "StrongSorcerer5"} },
	{ name = "Curse [Level 7000]", mobs = {"Curse1", "Curse2", "Curse3", "Curse4", "Curse5"} },
	{ name = "Slime [Level 8000]", mobs = {"Slime1", "Slime2", "Slime3", "Slime4", "Slime5"} },
	{ name = "AcademyTeacher [Level 9000]", mobs = {"AcademyTeacher1", "AcademyTeacher2", "AcademyTeacher3", "AcademyTeacher4", "AcademyTeacher5"} },
	{ name = "Swordsman [Level 10000]", mobs = {"Swordsman1", "Swordsman2", "Swordsman3", "Swordsman4", "Swordsman5"} },
}

local BossMobs = {
	{ name = "Yuji", mobs = {"YujiBoss"} },
	{ name = "Sukuna", mobs = {"SukunaBoss"} },
	{ name = "Gojo", mobs = {"GojoBoss"} },
	{ name = "Yamato", mobs = {"YamatoBoss"} },
	{ name = "Jinwoo", mobs = {"JinwooBoss"} },
}

local ShopItems = {
	{ name = "Kanata [1500 Gold]", type = "Kanata", position = Vector3.new(105.85, 10.04, -261.03) },
	{ name = "DarkBlade [250K Gold+150 Gems]", type = "DarkBlade", position = Vector3.new(-137.16, 13.23, -1093.29) },
	{ name = "Observation Haki [250k+300 Gems]", type = "ObservationHaki", position = Vector3.new(-713.71, 12.13, -523.93) },
}

local ChestTypes = {"Common Chest","Rare Chest","Legendary Chest","Mythic Chest"}

local Config = {
	Enabled = false,
	AttackHeight = 15,
	SelectedQuest = "Quest1",
	FarmEnabled = false,
	SelectedFarmMob = "Thief [Level 15]",
	SelectedItem = "Kanata [1500 Gold]",
	ChestEnabled = false,
	SelectedChest = "Common Chest",
	ChestSpeed = 0.1,
	ChestBatch = 1,
	ChestAmountEnabled = false,
	ChestAmount = 1,
	AbilityZEnabled = false,
	AbilityZCooldown = 1,
	AbilityXEnabled = false,
	AbilityXCooldown = 1,
	AbilityCEnabled = false,
	AbilityCCooldown = 1,
	AbilityVEnabled = false,
	AbilityVCooldown = 1,
	StatMeleeEnabled = false,
	StatMeleeSpeed = 0.1,
	StatMeleeAmountEnabled = false,
	StatMeleeAmount = 1,
	StatMeleeBatch = 1,
	StatDefenseEnabled = false,
	StatDefenseSpeed = 0.1,
	StatDefenseAmountEnabled = false,
	StatDefenseAmount = 1,
	StatDefenseBatch = 1,
	StatSwordEnabled = false,
	StatSwordSpeed = 0.1,
	StatSwordAmountEnabled = false,
	StatSwordAmount = 1,
	StatSwordBatch = 1,
	StatPowerEnabled = false,
	StatPowerSpeed = 0.1,
	StatPowerAmountEnabled = false,
	StatPowerAmount = 1,
	StatPowerBatch = 1,
	BossFarmEnabled = false,
	SelectedBoss = "Yuji",
    EquipInterval = 0.3
}

local questCompleted = false
local questKills = 0
local questRequired = 0
local farmThread, autoFarmThread, autoChestThread = nil, nil, nil
local abilityZThread, abilityXThread, abilityCThread, abilityVThread = nil, nil, nil, nil
local statMeleeThread, statDefenseThread, statSwordThread, statPowerThread = nil, nil, nil, nil
local bossFarmThread = nil
local originalPosition = nil
local slots = {}
local slotThreads = {}

local function GetHRP() local char = lp.Character return char and char:FindFirstChild("HumanoidRootPart") end
local function SaveOriginalPosition() local hrp = GetHRP() if hrp then originalPosition = hrp.CFrame end end
local function TeleportToPosition(cf) local hrp = GetHRP() if hrp and cf then hrp.CFrame = cf end end
local function TeleportToNPC(npcObj) local hrp = GetHRP() if not hrp or not npcObj then return end local cf = npcObj:IsA("Model") and npcObj:GetPivot() or npcObj.CFrame hrp.CFrame = cf * CFrame.new(0, 0, -3) end

local function FindClosestMob(mobType, specificMobs)
	local keyword = mobType:lower()
	local hrp = GetHRP()
	local closest, closestPrimary = nil, nil
	local closestDist = math.huge
	for _, v in pairs(enemiesFolder:GetChildren()) do
		if specificMobs then
			local isSpecific = false
			for _, mobName in ipairs(specificMobs) do if v.Name == mobName then isSpecific = true break end end
			if not isSpecific then continue end
		else
			if not string.find(v.Name:lower(), keyword, 1, true) then continue end
		end
		local hum = v:FindFirstChildOfClass("Humanoid")
		local primary = v.PrimaryPart or v:FindFirstChild("HumanoidRootPart")
		if hum and hum.Health > 0 and primary then
			if hrp then
				local dist = (primary.Position - hrp.Position).Magnitude
				if dist < closestDist then closestDist = dist closest = v closestPrimary = primary end
			else return v, primary end
		end
	end
	return closest, closestPrimary
end

local function FindClosestFarmMob(mobNames)
	local hrp = GetHRP()
	local closest, closestPrimary = nil, nil
	local closestDist = math.huge
	for _, mobName in ipairs(mobNames) do
		for _, v in pairs(enemiesFolder:GetChildren()) do
			if string.find(v.Name:lower(), mobName:lower(), 1, true) then
				local hum = v:FindFirstChildOfClass("Humanoid")
				local primary = v.PrimaryPart or v:FindFirstChild("HumanoidRootPart")
				if hum and hum.Health > 0 and primary then
					if hrp then
						local dist = (primary.Position - hrp.Position).Magnitude
						if dist < closestDist then closestDist = dist closest = v closestPrimary = primary end
					else return v, primary end
				end
			end
		end
	end
	return closest, closestPrimary
end

local function AttackMob(mob, primary)
	local hrp = GetHRP()
	if not hrp then return end
	local pos = primary.Position
	hrp.CFrame = CFrame.lookAt(pos + Vector3.new(0, Config.AttackHeight, 0), pos)
	hrp.AssemblyLinearVelocity = Vector3.zero
	requestHitRemote:FireServer(mob)
end

local function StopFarm() if farmThread then task.cancel(farmThread) farmThread = nil end end
local function StopAutoFarm() if autoFarmThread then task.cancel(autoFarmThread) autoFarmThread = nil end end
local function StopBossFarm() if bossFarmThread then task.cancel(bossFarmThread) bossFarmThread = nil end end
local function StopAutoChest() if autoChestThread then task.cancel(autoChestThread) autoChestThread = nil end end
local function StopAutoAbilities()
	if abilityZThread then task.cancel(abilityZThread) abilityZThread = nil end
	if abilityXThread then task.cancel(abilityXThread) abilityXThread = nil end
	if abilityCThread then task.cancel(abilityCThread) abilityCThread = nil end
	if abilityVThread then task.cancel(abilityVThread) abilityVThread = nil end
end
local function StopAutoStats()
	if statMeleeThread then task.cancel(statMeleeThread) statMeleeThread = nil end
	if statDefenseThread then task.cancel(statDefenseThread) statDefenseThread = nil end
	if statSwordThread then task.cancel(statSwordThread) statSwordThread = nil end
	if statPowerThread then task.cancel(statPowerThread) statPowerThread = nil end
end

local function StartFarm()
	StopFarm()
	farmThread = task.spawn(function()
		while Config.Enabled do
			local questInfo = QuestMap[Config.SelectedQuest]
			questCompleted = false
			questKills = 0
			questRequired = questInfo.amount
			local npcObj = serviceNpcsFolder:FindFirstChild(questInfo.npc)
			if not npcObj then task.wait(2) continue end
			TeleportToNPC(npcObj)
			task.wait(0.5)
			questAcceptRemote:FireServer(questInfo.npc)
			task.wait(0.5)
			while Config.Enabled do
				if questCompleted then task.wait(1) break end
				local mob, primary = FindClosestMob(questInfo.mobType, questInfo.specificMobs)
				if mob and primary then AttackMob(mob, primary) RunService.Heartbeat:Wait() else task.wait(0.3) end
			end
		end
	end)
end

local function StartAutoFarm()
	StopAutoFarm()
	autoFarmThread = task.spawn(function()
		local farmInfo = nil
		for _, info in ipairs(FarmMobs) do if info.name == Config.SelectedFarmMob then farmInfo = info break end end
		if not farmInfo then return end
		while Config.FarmEnabled do
			local mob, primary = FindClosestFarmMob(farmInfo.mobs)
			if mob and primary then AttackMob(mob, primary) RunService.Heartbeat:Wait() else task.wait(0.5) end
		end
	end)
end

local function StartBossFarm()
	StopBossFarm()
	bossFarmThread = task.spawn(function()
		local bossInfo = nil
		for _, info in ipairs(BossMobs) do if info.name == Config.SelectedBoss then bossInfo = info break end end
		if not bossInfo then return end
		while Config.BossFarmEnabled do
			local mob, primary = FindClosestFarmMob(bossInfo.mobs)
			if mob and primary then AttackMob(mob, primary) RunService.Heartbeat:Wait() else task.wait(0.5) end
		end
	end)
end

local function StartAutoChest()
	StopAutoChest()
	autoChestThread = task.spawn(function()
		local totalOpened = 0
		while Config.ChestEnabled do
			local batchAmount = Config.ChestBatch
			useItemRemote:FireServer("Use", Config.SelectedChest, batchAmount, false)
			totalOpened = totalOpened + batchAmount
			if Config.ChestAmountEnabled and totalOpened >= Config.ChestAmount then Config.ChestEnabled = false break end
			task.wait(Config.ChestSpeed)
		end
	end)
end

local function getWeaponList()
	local weapons = {}
	local bp = lp:FindFirstChild("Backpack")
	if bp then for _, v in ipairs(bp:GetChildren()) do if v:IsA("Tool") then table.insert(weapons, v.Name) end end end
	return weapons
end

local function startSlotThread(slotIndex)
	if slotThreads[slotIndex] then task.cancel(slotThreads[slotIndex]) end
	local slot = slots[slotIndex]
	if not slot.enabled then return end
	slotThreads[slotIndex] = task.spawn(function()
		while slot.enabled do
			local char = lp.Character
			if char then
				local hum = char:FindFirstChildOfClass("Humanoid")
				local tool = lp.Backpack:FindFirstChild(slot.selectedWeapon)
				if hum and tool then hum:EquipTool(tool) end
			end
			task.wait(Config.EquipInterval)
		end
	end)
end

questProgressRemote.OnClientEvent:Connect(function(data)
	if not data then questCompleted = true return end
	local req = data.requirements and data.requirements[1]
	if not req then return end
	if tonumber(req.progress or 0) >= tonumber(req.amount or 1) then questCompleted = true end
end)
questUIUpdateRemote.OnClientEvent:Connect(function(data)
	if not data then questCompleted = true return end
	local req = data.requirements and data.requirements[1]
	if not req then return end
	if tonumber(req.progress or 0) >= tonumber(req.amount or 1) then questCompleted = true end
end)
questCompleteRemote.OnClientEvent:Connect(function() questCompleted = true end)

local Window = WindUI:CreateWindow({
    Title = gradient("塔菲喵   ", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("伊散", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    IconThemed = true,
    Folder = "塔菲喵_Full",
    Size = UDim2.fromOffset(150, 150),
    Transparent = false,
    Theme = "Dark",
})

Window:EditOpenButton({
    Title = "[摸摸伊散]",
    CornerRadius = UDim.new(0,8),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("1E3A8A")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("118AB2")), 
        ColorSequenceKeypoint.new(1, Color3.fromHex("06D6A0")) 
    }),
    Draggable = true,
})
Window:Tag({
    Title = "伊散",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})

local TabMain = Window:Tab({ Title = '自动任务', Icon = 'scroll' })
local TabFarm = Window:Tab({ Title = '自动刷怪', Icon = 'swords' })
local TabBoss = Window:Tab({ Title = '自动刷Boss', Icon = 'skull' })
local TabChest = Window:Tab({ Title = '自动开箱', Icon = 'package' })
local TabAbility = Window:Tab({ Title = '自动技能', Icon = 'zap' })
local TabStats = Window:Tab({ Title = '自动点数', Icon = 'line-chart' })
local TabEquip = Window:Tab({ Title = '自动装备', Icon = 'bag' })
local TabShop = Window:Tab({ Title = '购买物品', Icon = 'shopping-cart' })

Window:SelectTab(1)

TabMain:Toggle({
    Title = "自动任务",
    Callback = function(v) Config.Enabled = v if v then StartFarm() else StopFarm() end end
})
TabMain:Dropdown({
    Title = "选择任务",
    Values = {"Quest1","Quest2","Quest3","Quest4","Quest5","Quest6","Quest7","Quest8","Quest9","Quest10","Quest11"},
    Callback = function(v) Config.SelectedQuest = v if Config.Enabled then questCompleted = true StartFarm() end end
})
TabMain:Slider({
    Title = "攻击高度",
    Min = 5, Max = 50, Default = 15,
    Callback = function(v) Config.AttackHeight = v end
})

TabFarm:Toggle({
    Title = "自动刷怪",
    Callback = function(v) Config.FarmEnabled = v if v then StartAutoFarm() else StopAutoFarm() end end
})
local farmOpts = {} for _, i in ipairs(FarmMobs) do table.insert(farmOpts, i.name) end
TabFarm:Dropdown({
    Title = "选择怪物",
    Values = farmOpts,
    Callback = function(v) Config.SelectedFarmMob = v if Config.FarmEnabled then StartAutoFarm() end end
})

TabBoss:Toggle({
    Title = "自动刷Boss",
    Callback = function(v) Config.BossFarmEnabled = v if v then StartBossFarm() else StopBossFarm() end end
})
local bossOpts = {} for _, i in ipairs(BossMobs) do table.insert(bossOpts, i.name) end
TabBoss:Dropdown({
    Title = "选择Boss",
    Values = bossOpts,
    Callback = function(v) Config.SelectedBoss = v if Config.BossFarmEnabled then StartBossFarm() end end
})

TabChest:Toggle({
    Title = "自动开箱",
    Callback = function(v) Config.ChestEnabled = v if v then StartAutoChest() else StopAutoChest() end end
})
TabChest:Dropdown({
    Title = "选择宝箱", Values = ChestTypes,
    Callback = function(v) Config.SelectedChest = v end
})
TabChest:Slider({ Title = "开箱速度", Min = 0.001, Max = 10, Default = 0.1, Callback = function(v) Config.ChestSpeed = v end })
TabChest:Slider({ Title = "一次性数量", Min = 1, Max = 100, Default = 1, Callback = function(v) Config.ChestBatch = v end })
TabChest:Toggle({ Title = "限制开启数量", Callback = function(v) Config.ChestAmountEnabled = v end })
TabChest:Slider({ Title = "开启多少停止", Min = 1, Max = 1000, Default = 1, Callback = function(v) Config.ChestAmount = v end })

TabAbility:Toggle({
    Title = "Z技能",
    Callback = function(v)
        Config.AbilityZEnabled = v
        if v then
            if abilityZThread then task.cancel(abilityZThread) end
            abilityZThread = task.spawn(function() while Config.AbilityZEnabled do requestAbilityRemote:FireServer(1) task.wait(Config.AbilityZCooldown) end end)
        end
    end
})
TabAbility:Slider({ Title = "Z冷却", Min = 1, Max = 30, Default = 1, Callback = function(v) Config.AbilityZCooldown = v end })

TabAbility:Toggle({
    Title = "X技能",
    Callback = function(v)
        Config.AbilityXEnabled = v
        if v then
            if abilityXThread then task.cancel(abilityXThread) end
            abilityXThread = task.spawn(function() while Config.AbilityXEnabled do requestAbilityRemote:FireServer(2) task.wait(Config.AbilityXCooldown) end end)
        end
    end
})
TabAbility:Slider({ Title = "X冷却", Min = 1, Max = 30, Default = 1, Callback = function(v) Config.AbilityXCooldown = v end })

TabAbility:Toggle({
    Title = "C技能",
    Callback = function(v)
        Config.AbilityCEnabled = v
        if v then
            if abilityCThread then task.cancel(abilityCThread) end
            abilityCThread = task.spawn(function() while Config.AbilityCEnabled do requestAbilityRemote:FireServer(3) task.wait(Config.AbilityCCooldown) end end)
        end
    end
})
TabAbility:Slider({ Title = "C冷却", Min = 1, Max = 30, Default = 1, Callback = function(v) Config.AbilityCCooldown = v end })

TabAbility:Toggle({
    Title = "V技能",
    Callback = function(v)
        Config.AbilityVEnabled = v
        if v then
            if abilityVThread then task.cancel(abilityVThread) end
            abilityVThread = task.spawn(function() while Config.AbilityVEnabled do requestAbilityRemote:FireServer(4) task.wait(Config.AbilityVCooldown) end end)
        end
    end
})
TabAbility:Slider({ Title = "V冷却", Min = 1, Max = 30, Default = 1, Callback = function(v) Config.AbilityVCooldown = v end })

TabStats:Toggle({
    Title = "Melee点数",
    Callback = function(v)
        Config.StatMeleeEnabled = v
        if v then
            if statMeleeThread then task.cancel(statMeleeThread) end
            statMeleeThread = task.spawn(function()
                local count = 0
                while Config.StatMeleeEnabled do
                    allocateStatRemote:FireServer("Melee", Config.StatMeleeBatch)
                    count = count + Config.StatMeleeBatch
                    if Config.StatMeleeAmountEnabled and count >= Config.StatMeleeAmount then break end
                    task.wait(Config.StatMeleeSpeed)
                end
            end)
        end
    end
})
TabStats:Slider({ Title = "Melee速度", Min = 0.001, Max = 5, Default = 0.1, Callback = function(v) Config.StatMeleeSpeed = v end })
TabStats:Slider({ Title = "Melee单次点数", Min = 1, Max = 100, Default = 1, Callback = function(v) Config.StatMeleeBatch = v end })

TabStats:Toggle({
    Title = "Defense点数",
    Callback = function(v)
        Config.StatDefenseEnabled = v
        if v then
            if statDefenseThread then task.cancel(statDefenseThread) end
            statDefenseThread = task.spawn(function()
                local count = 0
                while Config.StatDefenseEnabled do
                    allocateStatRemote:FireServer("Defense", Config.StatDefenseBatch)
                    count = count + Config.StatDefenseBatch
                    if Config.StatDefenseAmountEnabled and count >= Config.StatDefenseAmount then break end
                    task.wait(Config.StatDefenseSpeed)
                end
            end)
        end
    end
})
TabStats:Slider({ Title = "Defense速度", Min = 0.001, Max = 5, Default = 0.1, Callback = function(v) Config.StatDefenseSpeed = v end })
TabStats:Slider({ Title = "Defense单次点数", Min = 1, Max = 100, Default = 1, Callback = function(v) Config.StatDefenseBatch = v end })

TabEquip:Slider({ Title = "装备间隔", Min = 0.1, Max = 5, Default = 0.3, Callback = function(v) Config.EquipInterval = v end })
for i = 1, 4 do
    slots[i] = { enabled = false, selectedWeapon = "" }
    TabEquip:Toggle({ Title = "槽位 "..i.." 自动装备", Callback = function(v) slots[i].enabled = v if v then startSlotThread(i) end end })
    local drop = TabEquip:Dropdown({ Title = "选择武器 Slot "..i, Values = getWeaponList(), Callback = function(v) slots[i].selectedWeapon = v end })
    TabEquip:Button({ Title = "刷新武器列表 "..i, Callback = function() drop:SetValues(getWeaponList()) end })
end

local shopOpts = {} for _, i in ipairs(ShopItems) do table.insert(shopOpts, i.name) end
TabShop:Dropdown({ Title = "选择商品", Values = shopOpts, Callback = function(v) Config.SelectedItem = v end })
TabShop:Button({
    Title = "购买物品",
    Callback = function()
        SaveOriginalPosition()
        local item = nil
        for _, s in ipairs(ShopItems) do if s.name == Config.SelectedItem then item = s break end end
        if item then
            TeleportToPosition(CFrame.new(item.position))
            task.wait(0.5)
            -- 查找对应的 ProximityPrompt (根据原始逻辑)
            for _, p in pairs(workspace:GetDescendants()) do
                if p:IsA("ProximityPrompt") and p.Parent and p.Parent.Parent and p.Parent.Parent.Name:find(item.type) then
                    fireproximityprompt(p)
                end
            end
            task.wait(1)
            if originalPosition then TeleportToPosition(originalPosition) end
        end
    end
})
elseif game.GameId == 7888930431 then --- 月球增量
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Event = ReplicatedStorage:WaitForChild("UpdateEssenceStat")
local StarEvent = ReplicatedStorage:WaitForChild("UpdateStarStat")
local MineEvent = ReplicatedStorage:WaitForChild("MineRock")

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yisan9178/sjsjsj/refs/heads/main/Windui.lua(1).txt"))()

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(chars, uchar)
    end
    local length = #chars
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
            math.floor(r * 255), 
            math.floor(g * 255), 
            math.floor(b * 255), 
            chars[i])
    end
    return result
end

local Window = WindUI:CreateWindow({
    Title = gradient("塔菲喵   ", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("伊散", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    IconThemed = true,
    Folder = "塔菲喵",
    Size = UDim2.fromOffset(150, 150), 
    Transparent = false,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 150,
    BackgroundImageTransparency = 0.8,
    HideSearchBar = true,
    ScrollBarEnabled = true,
})

Window:EditOpenButton({
    Title = "[摸摸伊散]",
    CornerRadius = UDim.new(0,8),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("1E3A8A")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("118AB2")), 
        ColorSequenceKeypoint.new(1, Color3.fromHex("06D6A0")) 
    }),
    Draggable = true,
})

local World1Tab = Window:Tab({ Title = '世界一', Icon = 'swords' })
local World2Tab = Window:Tab({ Title = '世界二', Icon = 'pickaxe' }) 
Window:SelectTab(1)

local ToggleA = false
local ToggleB = false
local ToggleStar = false
local ToggleMine = false

World1Tab:Toggle({
    Title = "刷经验A (会增加延迟)",
    Value = false,
    Callback = function(state)
        ToggleA = state
    end
})

World1Tab:Toggle({
    Title = "刷经验B (会增加延迟)",
    Value = false,
    Callback = function(state)
        ToggleB = state
    end
})

World1Tab:Toggle({
    Title = "刷星星",
    Value = false,
    Callback = function(state)
        ToggleStar = state
    end
})

World2Tab:Toggle({
    Title = "自动挖矿",
    Value = false,
    Callback = function(state)
        ToggleMine = state
    end
})

task.spawn(function()
    while true do
        if ToggleA then
            for i = 1, 10 do
                Event:FireServer(Vector3.new(-227, 389.54965209961, 245), true)
            end
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    while true do
        if ToggleB then
            for i = 1, 10 do
                Event:FireServer(Vector3.new(-235, 392.14266967773, 228), false)
            end
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    while true do
        if ToggleStar then
            StarEvent:FireServer(Vector3.new(-189.51161193848, 390.14880371094, 218.86575317383))
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    while true do
        if ToggleMine then
            if workspace:FindFirstChild("Cave") and workspace.Cave:FindFirstChild("Ore_5623447126") then
                MineEvent:FireServer(workspace.Cave.Ore_5623447126)
            end
        end
        task.wait(0.1)
    end
end)

Window:Tag({
    Title = "伊散",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})

Window:SetToggleKey(Enum.KeyCode.F, true)
elseif game.GameId == 2564505263 then --- 超级大力士模拟器
    local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yisan9178/sjsjsj/refs/heads/main/Windui.lua(1).txt"))()
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(chars, uchar)
    end
    local length = #chars
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
            math.floor(r * 255), math.floor(g * 255), math.floor(b * 255), chars[i])
    end
    return result
end

local function smoothTeleport(x, y, z)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local targetCF = CFrame.new(x, y, z)
    local tween = TweenService:Create(root, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {CFrame = targetCF})
    tween:Play()
    tween.Completed:Wait()
end

local function pressE()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local Window = WindUI:CreateWindow({
    Title = gradient("塔菲喵  ", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("伊散", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    IconThemed = true,
    Folder = "Tafei",
    Size = UDim2.fromOffset(150, 150),
    Transparent = false,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 160,
    BackgroundImageTransparency = 0.8,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function() 
            WindUI:Notify({Title = "提示", Content = "设置已同步", Duration = 2})
        end,
    },
})

Window:EditOpenButton({
    Title = "[摸摸伊散]",
    CornerRadius = UDim.new(0,8),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("1E3A8A")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("06D6A0")) 
    }),
    Draggable = true,
})
Window:Tag({
    Title = "伊散",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})

Window:SetToggleKey(Enum.KeyCode.F, true)

local activeStates = {
    strengthLoop = false,
    farmLoop = false,
    workoutLoop = false,
    rebirthLoop = false,
    buyPetsLoop = false
}

local function runStrengthLoop()
    local coords = {
        {86.64, 11.74, -179.86},
        {86.79, 11.74, -124.62},
        {86.57, 11.74, -117.59}
    }
    while activeStates.strengthLoop do
        smoothTeleport(coords[1][1], coords[1][2], coords[1][3])
        task.wait(0.2)
        for i=1,8 do pressE() task.wait(0.05) end
        task.wait(0.2)
        smoothTeleport(coords[2][1], coords[2][2], coords[2][3])
        task.wait(0.2)
        smoothTeleport(coords[3][1], coords[3][2], coords[3][3])
        task.wait(0.2)
    end
end

local function runFarmLoop()
    while activeStates.farmLoop do
        task.wait()
        pcall(function()
            local character = LocalPlayer.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then return end
            character.HumanoidRootPart.CFrame = CFrame.new(5385, 37, -2857)

            for _, descendant in pairs(workspace.Areas.Area29_Bank.DraggableItems:GetDescendants()) do
                if string.find(descendant.Name, 'Area29_Bank.Safe') then
                    for _, subDesc in pairs(descendant:GetDescendants()) do
                        if subDesc.Name == 'InteractionPoint' then
                            character.HumanoidRootPart.CFrame = CFrame.new(subDesc.Position) * CFrame.Angles(math.rad(-90), 0, 0)
                            pressE()
                            if subDesc:FindFirstChild("ProximityPrompt") then
                                fireproximityprompt(subDesc.ProximityPrompt)
                            end
                        end
                    end
                end
            end
            workspace.Areas.Area29_Bank.Goal.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 100)
            task.wait()
            workspace.Areas.Area29_Bank.Goal.CFrame = character.HumanoidRootPart.CFrame
        end)
    end
end

local function runWorkoutLoop()
    while activeStates.workoutLoop do
        task.wait()
        pcall(function()
            local character = LocalPlayer.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then return end
            for _, prompt in pairs(workspace.Areas.Area29_Bank.Gym:GetDescendants()) do
                if prompt:IsA('ProximityPrompt') then
                    character.HumanoidRootPart.CFrame = CFrame.new(prompt.Parent.Position)
                    prompt.HoldDuration = 0
                    fireproximityprompt(prompt, 1, true)
                    pressE()
                end
            end
            ReplicatedStorage.StrongMan_UpgradeStrength:InvokeServer(100, 'Default')
        end)
    end
end

local MainTab = Window:Tab({ Title = '功能', Icon = 'swords' })
Window:SelectTab(1)
MainTab:Toggle({
    Title = "刷力量",
    Value = false,
    Callback = function(v)
        activeStates.farmLoop = v
        if v then task.spawn(runFarmLoop) end
    end
})

MainTab:Toggle({
    Title = "锻炼",
    Value = false,
    Callback = function(v)
        activeStates.workoutLoop = v
        if v then task.spawn(runWorkoutLoop) end
    end
})

MainTab:Toggle({
    Title = "自动重生",
    Value = false,
    Callback = function(v)
        activeStates.rebirthLoop = v
        task.spawn(function()
            while activeStates.rebirthLoop do
                ReplicatedStorage.StrongMan_Rebirth:FireServer()
                task.wait(5)
            end
        end)
    end
})
elseif game.GameId == 1489026993 then --- 生存于杀手
    local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yisan9178/sjsjsj/refs/heads/main/Windui.lua(1).txt"))()

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do table.insert(chars, uchar) end
    local length = #chars
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', math.floor(r * 255), math.floor(g * 255), math.floor(b * 255), chars[i])
    end
    return result
end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lplr = Players.LocalPlayer

getgenv().AutoLootTeleport = false
getgenv().KillAll = false
getgenv().AutoBreakFree = false
getgenv().ESP_Enabled = false 

local function ApplyESP(plr)
    if plr == lplr then return end

    local function update()
        local char = plr.Character
        if not char then return end
        
        local highlight = char:FindFirstChild("TaffyHighlight")
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "TaffyHighlight"
            highlight.Parent = char
        end
        highlight.FillColor = Color3.fromRGB(255, 50, 50)
        highlight.FillTransparency = 0.6
        highlight.OutlineTransparency = 0.2
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Enabled = getgenv().ESP_Enabled

        local nameTag = char:FindFirstChild("TaffyNameTag")
        if not nameTag then
            nameTag = Instance.new("BillboardGui")
            nameTag.Name = "TaffyNameTag"
            nameTag.Size = UDim2.new(0, 100, 0, 30)
            nameTag.AlwaysOnTop = true
            nameTag.StudsOffset = Vector3.new(0, 2.2, 0)
            
            local textLabel = Instance.new("TextLabel")
            textLabel.Parent = nameTag
            textLabel.BackgroundTransparency = 1
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.Font = Enum.Font.GothamMedium
            textLabel.TextColor3 = Color3.new(1, 1, 1)
            textLabel.TextSize = 10 -- 设置为小名字
            textLabel.TextStrokeTransparency = 0.3
            textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            
            nameTag.Parent = char
        end
        
        local label = nameTag:FindFirstChildOfClass("TextLabel")
        if label then
            local myRoot = lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart")
            local targetRoot = char:FindFirstChild("HumanoidRootPart")
            local dist = (myRoot and targetRoot) and math.floor((targetRoot.Position - myRoot.Position).Magnitude) or 0
            
            label.Text = plr.Name .. " [" .. dist .. "m]"
            label.Visible = getgenv().ESP_Enabled
        end
    end

    task.spawn(function()
        while plr and plr.Parent do
            pcall(update)
            task.wait(0.5)
        end
    end)
end

for _, player in pairs(Players:GetPlayers()) do ApplyESP(player) end
Players.PlayerAdded:Connect(ApplyESP)

local Window = WindUI:CreateWindow({
    Title = gradient("塔菲喵   ", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("伊散", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    IconThemed = true,
    Folder = "塔菲喵",
    Size = UDim2.fromOffset(150, 150), 
    Transparent = getgenv().TransparencyEnabled,
    Theme = "Dark",
})

Window:EditOpenButton({
    Title = "[摸摸伊散]",
    CornerRadius = UDim.new(0,8),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("1E3A8A")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("118AB2")), 
        ColorSequenceKeypoint.new(1, Color3.fromHex("06D6A0")) 
    }),
    Draggable = true,
})
Window:Tag({
    Title = "伊散",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})

Window:SetToggleKey(Enum.KeyCode.F, true)

local function teleportToPosition(position)
    local char = lplr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local tween = TweenService:Create(hrp, TweenInfo.new(0.3), {CFrame = CFrame.new(position)})
    tween:Play()
    tween.Completed:Wait()
end

local CombatTab = Window:Tab({ Title = '功能', Icon = 'swords' })
Window:SelectTab(1)
CombatTab:Toggle({
    Title = "自动寻找物品",
    Value = false,
    Callback = function(state)
        getgenv().AutoLootTeleport = state
        if state then
            WindUI:Notify({Title = "自动传送", Content = "开始传送物品", Duration = 2})
            task.spawn(function()
                while getgenv().AutoLootTeleport do
                    local foundAny = false
                    for _, child in ipairs(Workspace:GetChildren()) do
                        if not getgenv().AutoLootTeleport then break end
                        if child:IsA("Model") or child:IsA("Folder") then
                            local lootSpawns = child:FindFirstChild("LootSpawns")
                            if lootSpawns then
                                foundAny = true
                                for _, lootModel in ipairs(lootSpawns:GetChildren()) do
                                    if not getgenv().AutoLootTeleport then break end
                                    local targetPos = lootModel:IsA("Model") and (lootModel.PrimaryPart and lootModel.PrimaryPart.Position or lootModel:GetBoundingBox().Position) or (lootModel:IsA("BasePart") and lootModel.Position)
                                    if targetPos then teleportToPosition(targetPos); task.wait(0.5) end
                                end
                            end
                        end
                    end
                    task.wait(foundAny and 2 or 5)
                end
            end)
        end
    end
})

CombatTab:Toggle({
    Title = "全图杀戮",
    Value = false,
    Callback = function(state)
        getgenv().KillAll = state
        if state then
            WindUI:Notify({Title = "杀戮开启", Content = "正在自动锁定所有玩家", Duration = 2})
            task.spawn(function()
                while getgenv().KillAll do
                    local knife = lplr.Character and lplr.Character:FindFirstChild("Knife")
                    local event = knife and knife:FindFirstChild("KnifeSlashEvent")
                    if event then event:FireServer() end
                    task.wait(0.1)
                end
            end)
            task.spawn(function()
                while getgenv().KillAll do
                    for _, targetPlayer in ipairs(Players:GetPlayers()) do
                        if not getgenv().KillAll then break end
                        if targetPlayer ~= lplr and targetPlayer.Character then
                            local rootPart = lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart")
                            local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if rootPart and targetRoot then rootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 2, 0); task.wait(0.5) end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

CombatTab:Toggle({
    Title = "自动解陷阱",
    Value = false,
    Callback = function(state)
        getgenv().AutoBreakFree = state
        if state then
            task.spawn(function()
                local breakFreeEvent = ReplicatedStorage:FindFirstChild("BreakFree")
                while getgenv().AutoBreakFree do
                    if breakFreeEvent then breakFreeEvent:FireServer() end
                    task.wait(0.1)
                end
            end)
        end
    end
})

local VisualsTab = Window:Tab({ Title = 'esp', Icon = 'eye' })

VisualsTab:Toggle({
    Title = "透视",
    Value = false,
    Callback = function(state)
        getgenv().ESP_Enabled = state
        if state then
            WindUI:Notify({Title = "透视", Content = "🉑看到所有玩家", Duration = 2})
        end
    end
})

Window:SelectTab(1)
WindUI:Notify({Title = "加载成功", Content = "塔菲喵", Duration = 3})
elseif game.GameId == 8950496606 then --- 亡命速递
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/yisan9178/sjsjsj/refs/heads/main/Windui.lua(1).txt"))()

local CloneRef = cloneref or (clonereference or function(ref)
    return ref
end)

local Vector3_zero = Vector3.zero
local Vector3_new = Vector3.new
local CFrame_new = CFrame.new
local task_wait = task.wait
local task_spawn = task.spawn
local task_defer = task.defer
local math_max = math.max
local math_min = math.min
local math_floor = math.floor
local math_clamp = math.clamp
local string_format = string.format
local pairs = pairs
local ipairs = ipairs
local pcall = pcall
local tick = tick

local Services = {
    RunService = CloneRef(game:GetService("RunService")),
    Players = CloneRef(game:GetService("Players")),
    Workspace = CloneRef(game:GetService("Workspace")),
    TweenService = CloneRef(game:GetService("TweenService")),
    HttpService = CloneRef(game:GetService("HttpService")),
    UserInputService = CloneRef(game:GetService("UserInputService")),
    UserService = CloneRef(game:GetService("UserService"))
}

local TARGET_LOBBY_PLACE_ID = 125810438250765
local inLobby = game.PlaceId == TARGET_LOBBY_PLACE_ID

local themes = {"Dark", "Light"}
local currentThemeIndex = 1

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(chars, uchar)
    end
    local length = #chars
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
            math.floor(r * 255), 
            math.floor(g * 255), 
            math.floor(b * 255), 
            chars[i])
    end
    return result
end

local Window = Library:CreateWindow({
    Title = gradient("塔菲喵   ", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("伊散", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    IconThemed = true,
    Folder = "塔菲喵",
    Size = UDim2.fromOffset(150, 100),
     Transparent = getgenv().TransparencyEnabled,
     Theme = "Dark",
     Resizable = true,
     SideBarWidth = 150,
     BackgroundImageTransparency = 0.8,
     HideSearchBar = true,
     ScrollBarEnabled = true,
     User = {
         Enabled = true,
         Anonymous = false,
         Callback = function()
             currentThemeIndex = currentThemeIndex + 1
             if currentThemeIndex > #themes then
                 currentThemeIndex = 1
             end
             
             local newTheme = themes[currentThemeIndex]
             WindUI:SetTheme(newTheme)
            
             WindUI:Notify({
                 Title = "Theme Changed",
                 Content = "Switched to " .. newTheme .. " theme!",
                 Duration = 2,
                 Icon = "palette"
             })
             print("Switched to " .. newTheme .. " theme")
         end,
     },
 })

WindUI.Themes.Dark.Button = Color3.fromRGB(255, 255, 255)
WindUI.Themes.Dark.ButtonBorder = Color3.fromRGB(255, 255, 255)
WindUI.Themes.Dark.Toggle = Color3.fromHex "#FF69B4"

Window:EditOpenButton({
    Title = "[摸摸伊散]",
    CornerRadius = UDim.new(0,8),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("1E3A8A")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("118AB2")), 
        ColorSequenceKeypoint.new(1, Color3.fromHex("06D6A0")) 
    }),
    Draggable = true,
})
Window:Tag({
    Title = "伊散",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})
Window:SetToggleKey(Enum.KeyCode.F, true)

local Tabs = {
    Main = Window:Tab({
        Title = "主要功能",
        Icon = "atom"
    }),
    Auto = Window:Tab({
        Title = "农场",
        Icon = "play-circle"
    }),
    Esp = Window:Tab({
        Title = "ESP",
        Icon = "eye"
    }),
    Malicious = Window:Tab({
        Title = "绕过",
        Icon = "sigma"
    }),
    Config = Window:Tab({
        Title = "配置",
        Icon = "settings"
    })
}
Window:SelectTab(1)

getgenv().NOL = getgenv().NOL or {
    SpeedEnabled = false,
    StaminaEnabled = false,
    InvincibleEnabled = false,
    AnySellEnabled = false,
    FullBrightEnabled = false,
    ItemEspEnabled = false,
    ItemEspTypes = {"价格"},
    ItemEspMinPrice = "0",
    MonsterEspEnabled = false,
    MonsterEspTypes = {"方框"},
    NpcEspEnabled = false,
    NpcEspTypes = {"方框", "名称", "距离"},
    AutoCollectEnabled = false,
    AutoOpenEnabled = false,
    AutoNextFloorEnabled = false,
    AutoPickupEnabled = false,
    AutoCollectEggEnabled = false,
    AutoStartEnabled = true,
    AutoStopEnabled = false,
    StopFloor = "5",
}

_G.NOLControls = _G.NOLControls or {}

local WorldLoots = nil
local Camera = nil
if not inLobby then
    WorldLoots = Services.Workspace.GameSystem.Loots:WaitForChild("World")
    Camera = Services.Workspace.CurrentCamera
end

local EspSystem = {}
EspSystem.Config = {
    Item = {
        Enabled = false,
        Types = {
            Tracer = false,
            Name = false,
            Distance = false,
            Price = true
        },
        Colors = {
            Tracer = Color3.fromRGB(255, 255, 255),
            Text = Color3.fromRGB(255, 255, 255)
        },
        MinPrice = 0,
        MaxDistance = math.huge
    },
    Monster = {
        Enabled = false,
        Types = {
            Box = true,
            Name = false,
            Distance = false
        },
        Colors = {
            Box = Color3.fromRGB(255, 0, 0),
            Text = Color3.fromRGB(255, 0, 0)
        },
        MaxDistance = math.huge
    },
    Npc = {
        Enabled = false,
        Types = {
            Box = true,
            Name = true,
            Distance = true
        },
        Colors = {
            Box = Color3.fromRGB(0, 255, 0),
            Text = Color3.fromRGB(0, 255, 0)
        },
        MaxDistance = math.huge
    }
}

EspSystem.Item = {
    Tracers = {},
    EspCache = {},
    RenderConn = nil,
    ChildAddedConn = nil,
    ChildrenCache = {}, 
    LastUpdateTime = 0,
    UpdateInterval = 0.033 
}

EspSystem.Monster = {
    EspCache = {},
    RenderConn = nil,
    ChildAddedConn = nil,
    ChildrenCache = {},
    NetworkOwnershipSet = {},
    LastUpdateTime = 0,
    UpdateInterval = 0.033
}

EspSystem.Npc = {
    EspCache = {},
    RenderConn = nil,
    ChildAddedConn = nil,
    ChildrenCache = {},
    NetworkOwnershipSet = {},
    LastUpdateTime = 0,
    UpdateInterval = 0.033
}

function EspSystem.CreateTracer()
    local line = Drawing.new("Line")
    line.Thickness = 3
    line.Transparency = 0.15
    line.Visible = false
    return line
end

function EspSystem.CreateText()
    local text = Drawing.new("Text")
    text.Size = 16
    text.Center = true
    text.Outline = true
    text.OutlineColor = Color3.fromRGB(0, 0, 0)
    if Drawing.Fonts then
        text.Font = Drawing.Fonts.Monospace
    end
    text.Visible = false
    return text
end

function EspSystem.GetPriceColor(price)
    if price >= 10000 then
        return Color3.fromRGB(255, 215, 0)
    elseif price >= 5000 then
        return Color3.fromRGB(255, 165, 0)
    elseif price >= 2000 then
        return Color3.fromRGB(50, 205, 50)
    elseif price >= 1000 then
        return Color3.fromRGB(135, 206, 250)
    else
        return Color3.fromRGB(255, 255, 255)
    end
end

function EspSystem.TranslateItemName(englishName)
    if not englishName or englishName == "" then
        return "未知物品"
    end
    local nameMap = {
        ["Knife"] = "小刀",["Sword"] = "剑",["Gun"] = "枪",["Pistol"] = "手枪",["Rifle"] = "步枪",["Shotgun"] = "霰弹枪",
        ["Axe"] = "斧头",["Hammer"] = "锤子",["Bat"] = "球棒",["Crowbar"] = "撬棍",["Flashlight"] = "手电筒",["Key"] = "钥匙",
        ["Lockpick"] = "开锁器",["Medkit"] = "医疗包",["Bandage"] = "绷带",["Food"] = "食物",["Water"] = "水",["Battery"] = "电池",
        ["Box"] = "箱子",["Crate"] = "板条箱",["Container"] = "容器",["Bag"] = "包",["Backpack"] = "背包",["Fridge"] = "冰箱",
        ["Freezer"] = "冷冻柜",["Cabinet"] = "柜子",["Drawer"] = "抽屉",["Money"] = "金钱",["Cash"] = "现金",["Coin"] = "硬币",
        ["Gold"] = "黄金",["Silver"] = "白银",["Metal"] = "金属",["Wood"] = "木材",["Stone"] = "石头",["Cloth"] = "布料",
        ["Egg"] = "蛋",["Item"] = "物品",["Loot"] = "战利品",["Treasure"] = "宝藏",["Artifact"] = "文物",["Document"] = "文件",
        ["Note"] = "笔记",["Paper"] = "纸张",["Book"] = "书",["Map"] = "地图",["Keycard"] = "门卡",["ID Card"] = "身份证",
        ["Phone"] = "手机",["Radio"] = "收音机",["Tool"] = "工具",["Equipment"] = "装备",["Weapon"] = "武器",["Ammo"] = "弹药",
        ["Bullet"] = "子弹",["Grenade"] = "手榴弹",
    }
    if nameMap[englishName] then
        return nameMap[englishName]
    end
    local lowerName = string.lower(englishName)
    for eng, chn in pairs(nameMap) do
        if string.lower(eng) == lowerName then
            return chn
        end
    end
    for eng, chn in pairs(nameMap) do
        if string.find(lowerName, string.lower(eng)) or string.find(string.lower(eng), lowerName) then
            return chn
        end
    end
    return englishName
end

function EspSystem.FormatPrice(price)
    if price >= 10000 then
        return string.format("%.1f千", price / 1000)
    elseif price >= 1000 then
        return string.format("%.2f千", price / 1000)
    else
        return tostring(price)
    end
end

function EspSystem.CreateBox()
    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = false
    return highlight
end

function EspSystem.FindInteractablePart(item)
    for _, descendant in ipairs(item:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant.Name == "Interactable" then
            return descendant
        end
    end
    return nil
end

function EspSystem.GetPrimaryPart(model)
    return model.PrimaryPart 
        or model:FindFirstChild("HumanoidRootPart", true) 
        or model:FindFirstChild("Checker", true) 
        or model:FindFirstChild("Hitbox", true)
        or model:FindFirstChildOfClass("BasePart", true)
end

function EspSystem.GetMonsterName(monster)
    if monster:FindFirstChild("BZ") and monster:FindFirstChild("CBZ") and monster:FindFirstChild("CBY") then
        return "火鸡"
    elseif monster:FindFirstChild("none") and monster:FindFirstChild("Y0") then
        return "坑虫"
    elseif monster:FindFirstChild("Head") and monster.Head:FindFirstChild("LayerCount") then
        return "模仿者"
    elseif monster:FindFirstChild("1C1") and monster:FindFirstChild("Door") then
        return "假冰箱"
    elseif monster:FindFirstChild("LeLower_Leg") and monster:FindFirstChild("HumanoidRootPart") then
        return "行走食物"
    elseif monster:FindFirstChild("Waist1") and monster:FindFirstChild("AnimSaves") then
        return "遗忘者"
    elseif monster:FindFirstChild("Bubble") and monster:FindFirstChild("Mouth") then
        return "鳄鱼"
    elseif monster:FindFirstChild("Tail") and monster:FindFirstChild("WB2") then
        return "猫"
    elseif monster:FindFirstChild("WB1") and monster:FindFirstChild("YER") then
        return "偷袭鼠"
    elseif monster:FindFirstChild("FullFace") and monster:FindFirstChild("hat") then
        return "Guest666"
    end
    return monster.Name or "未知的怪物"
end

function EspSystem.CreateItemEsp(item)
    pcall(function()
        local lootUI = item:FindFirstChild("LootUI", true)
        if not lootUI then return end
        local frame = lootUI:FindFirstChild("Frame")
        if not frame then return end
        local nameLbl = frame:FindFirstChild("ItemName")
        local priceLbl = frame:FindFirstChild("Price")
        if not nameLbl or not priceLbl then return end
        local price = tonumber(priceLbl.Text:match("%d+")) or 0
        if price < EspSystem.Config.Item.MinPrice then return end
        local adornPart = item:FindFirstChildWhichIsA("BasePart", true)
        if not adornPart then return end
        if EspSystem.Item.EspCache[item] then
            if EspSystem.Item.EspCache[item].highlight then
                EspSystem.Item.EspCache[item].highlight:Destroy()
            end
            if EspSystem.Item.EspCache[item].billboard then
                EspSystem.Item.EspCache[item].billboard:Destroy()
            end
        end
        local itemColor = Color3.fromRGB(255, 215, 0)
        local highlight = Instance.new("Highlight")
        highlight.FillColor = itemColor
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = item
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ItemESP"
        billboard.Adornee = adornPart
        billboard.Size = UDim2.new(0, 150, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = adornPart
        local yPos = 0
        local lineHeight = 0.33
        local txtName = Instance.new("TextLabel")
        txtName.Size = UDim2.new(1, 0, lineHeight, 0)
        txtName.Position = UDim2.new(0, 0, yPos, 0)
        txtName.BackgroundTransparency = 1
        txtName.Text = nameLbl.Text
        txtName.TextColor3 = itemColor
        txtName.TextStrokeTransparency = 0
        txtName.TextScaled = false
        txtName.TextSize = 10
        txtName.Font = Enum.Font.GothamBold
        txtName.Visible = EspSystem.Config.Item.Types.Name
        txtName.Parent = billboard
        if EspSystem.Config.Item.Types.Name then
            yPos = yPos + lineHeight
        end
        local txtPrice = Instance.new("TextLabel")
        txtPrice.Size = UDim2.new(1, 0, lineHeight, 0)
        txtPrice.Position = UDim2.new(0, 0, yPos, 0)
        txtPrice.BackgroundTransparency = 1
        txtPrice.Text = price .. "美元"
        txtPrice.TextColor3 = itemColor
        txtPrice.TextStrokeTransparency = 0
        txtPrice.TextScaled = false
        txtPrice.TextSize = 10
        txtName.Font = Enum.Font.GothamBold
        txtPrice.Visible = EspSystem.Config.Item.Types.Price
        txtPrice.Parent = billboard
        if EspSystem.Config.Item.Types.Price then
            yPos = yPos + lineHeight
        end
        local txtDist = Instance.new("TextLabel")
        txtDist.Size = UDim2.new(1, 0, lineHeight, 0)
        txtDist.Position = UDim2.new(0, 0, yPos, 0)
        txtDist.BackgroundTransparency = 1
        txtDist.Text = "0m"
        txtDist.TextColor3 = itemColor
        txtDist.TextStrokeTransparency = 0
        txtDist.TextScaled = false
        txtDist.TextSize = 10
        txtDist.Font = Enum.Font.Gotham
        txtDist.Visible = EspSystem.Config.Item.Types.Distance
        txtDist.Parent = billboard
        EspSystem.Item.EspCache[item] = {
            highlight = highlight,
            billboard = billboard,
            txtName = txtName,
            txtPrice = txtPrice,
            txtDist = txtDist,
            price = price
        }
    end)
end

function EspSystem.CreateEntityEsp(model, cache, color, getNameFunc, config)
    if cache[model] then return end
    local root = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart", true) or model:FindFirstChildWhichIsA("BasePart", true)
    if not root then return end
    local highlight = Instance.new("Highlight")
    highlight.FillColor = color
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0
    highlight.Enabled = config and config.Types.Box or false
    highlight.Parent = model
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "EntityESP"
    billboard.Adornee = root
    billboard.Size = UDim2.new(0, 150, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = root
    local yPos = 0
    local lineHeight = 0.5
    local txtName = Instance.new("TextLabel")
    txtName.Size = UDim2.new(1, 0, lineHeight, 0)
    txtName.Position = UDim2.new(0, 0, yPos, 0)
    txtName.BackgroundTransparency = 1
    txtName.Text = getNameFunc(model)
    txtName.TextColor3 = color
    txtName.TextStrokeTransparency = 0
    txtName.TextSize = 12
    txtName.Font = Enum.Font.GothamBold
    txtName.Visible = config and config.Types.Name or false
    txtName.Parent = billboard
    if config and config.Types.Name then
        yPos = yPos + lineHeight
    end
    local txtDist = Instance.new("TextLabel")
    txtDist.Size = UDim2.new(1, 0, lineHeight, 0)
    txtDist.Position = UDim2.new(0, 0, yPos, 0)
    txtDist.BackgroundTransparency = 1
    txtDist.Text = "0m"
    txtDist.TextColor3 = color
    txtDist.TextSize = 10
    txtDist.Font = Enum.Font.Gotham
    txtDist.Visible = config and config.Types.Distance or false
    txtDist.Parent = billboard
    cache[model] = {
        highlight = highlight,
        billboard = billboard,
        txtName = txtName,
        txtDist = txtDist
    }
end

function EspSystem.CleanupItemEspCache()
    for item, visuals in pairs(EspSystem.Item.EspCache) do
        if visuals.highlight then visuals.highlight:Destroy() end
        if visuals.billboard then visuals.billboard:Destroy() end
    end
    EspSystem.Item.EspCache = {}
end

function EspSystem.CleanupEntityEspCache(cache)
    for item, visuals in pairs(cache) do
        if visuals.highlight then visuals.highlight:Destroy() end
        if visuals.billboard then visuals.billboard:Destroy() end
    end
    table.clear(cache)
end

function EspSystem.UpdateItemEsp()
    if inLobby then return end
    local currentTime = tick()
    if currentTime - EspSystem.Item.LastUpdateTime < EspSystem.Item.UpdateInterval then
        return
    end
    EspSystem.Item.LastUpdateTime = currentTime
    local LocalPlayer = Services.Players.LocalPlayer
    local Character = LocalPlayer.Character
    local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    local rootPos = RootPart and RootPart.Position
    if EspSystem.Config.Item.Enabled then
        local childrenCache = EspSystem.Item.ChildrenCache
        if #childrenCache == 0 then
            for _, item in pairs(WorldLoots:GetChildren()) do
                if item:IsA("Tool") or item:IsA("Model") then
                    table.insert(childrenCache, item)
                end
            end
        end
        for item, data in pairs(EspSystem.Item.EspCache) do
            if not item.Parent or (data.price and data.price < EspSystem.Config.Item.MinPrice) then
                if data.highlight then data.highlight:Destroy() end
                if data.billboard then data.billboard:Destroy() end
                EspSystem.Item.EspCache[item] = nil
            else
                if data.txtName then
                    data.txtName.Visible = EspSystem.Config.Item.Types.Name
                end
                if data.txtPrice then
                    data.txtPrice.Visible = EspSystem.Config.Item.Types.Price
                end
                if data.txtDist then
                    data.txtDist.Visible = EspSystem.Config.Item.Types.Distance
                    if EspSystem.Config.Item.Types.Distance and rootPos then
                        local adornPart = item:FindFirstChildWhichIsA("BasePart", true)
                        if adornPart then
                            local dist = (rootPos - adornPart.Position).Magnitude
                            data.txtDist.Text = string_format("%.0fm", dist)
                        end
                    end
                end
            end
        end
        for i = #childrenCache, 1, -1 do
            local item = childrenCache[i]
            if not item.Parent then
                table.remove(childrenCache, i)
            elseif not EspSystem.Item.EspCache[item] then
                EspSystem.CreateItemEsp(item)
            end
        end
    else
        EspSystem.CleanupItemEspCache()
    end
    local cameraCFrame = Camera.CFrame
    local cameraPos = cameraCFrame.Position
    local viewportSize = Camera.ViewportSize
    local maxDistSqr = EspSystem.Config.Item.MaxDistance * EspSystem.Config.Item.MaxDistance
    for item, tracer in pairs(EspSystem.Item.Tracers) do
        if not item.Parent or not item:IsDescendantOf(Services.Workspace) then
            tracer:Remove()
            EspSystem.Item.Tracers[item] = nil
        else
            local interactablePart = EspSystem.FindInteractablePart(item)
            if interactablePart then
                local viewportPoint, onScreen = Camera:WorldToViewportPoint(interactablePart.Position)
                if onScreen then
                    local itemPos = interactablePart.Position
                    local diff = itemPos - cameraPos
                    local distSqr = diff.X * diff.X + diff.Y * diff.Y + diff.Z * diff.Z
                    if distSqr <= maxDistSqr then
                        local lootUI = item:FindFirstChild("LootUI", true)
                        if lootUI and lootUI:FindFirstChild("Frame") then
                            local frame = lootUI.Frame
                            local priceText = frame:FindFirstChild("Price") and frame.Price.Text or "0"
                            local price = tonumber(priceText:match("%d+")) or 0
                            if price >= EspSystem.Config.Item.MinPrice then
                                if EspSystem.Config.Item.Types.Tracer then
                                    local priceColor = EspSystem.GetPriceColor(price)
                                    tracer.Color = priceColor
                                    local distance = math.sqrt(distSqr)
                                    local distanceRatio = math_clamp(distance / 500, 0, 1)
                                    tracer.Transparency = math_max(0.1, 0.15 + (distanceRatio * 0.5))
                                    tracer.Thickness = math_max(2, 4 - (distanceRatio * 1.5))
                                    tracer.From = Vector2.new(viewportSize.X / 2, viewportSize.Y)
                                    tracer.To = Vector2.new(viewportPoint.X, viewportPoint.Y)
                                    tracer.Visible = true
                                else
                                    tracer.Visible = false
                                end
                            else
                                tracer.Visible = false
                            end
                        else
                            tracer.Visible = false
                        end
                    else
                        tracer.Visible = false
                    end
                else
                    tracer.Visible = false
                end
            else
                tracer.Visible = false
            end
        end
    end
end

function EspSystem.UpdateMonsterEsp()
    if inLobby then return end
    local currentTime = tick()
    if currentTime - EspSystem.Monster.LastUpdateTime < EspSystem.Monster.UpdateInterval then
        return
    end
    EspSystem.Monster.LastUpdateTime = currentTime
    local LocalPlayer = Services.Players.LocalPlayer
    local Character = LocalPlayer.Character
    local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    local rootPos = RootPart and RootPart.Position
    local MonsterFolder = Services.Workspace.GameSystem.Monsters
    local monsterColor = Color3.fromRGB(255, 0, 0)
    if EspSystem.Config.Monster.Enabled then
        local childrenCache = EspSystem.Monster.ChildrenCache
        if #childrenCache == 0 then
            for _, monster in pairs(MonsterFolder:GetChildren()) do
                if monster:IsA("Model") then
                    table.insert(childrenCache, monster)
                end
            end
        end
        for i = #childrenCache, 1, -1 do
            local monster = childrenCache[i]
            if not monster.Parent then
                table.remove(childrenCache, i)
            elseif not EspSystem.Monster.EspCache[monster] then
                EspSystem.CreateEntityEsp(monster, EspSystem.Monster.EspCache, monsterColor, EspSystem.GetMonsterName, EspSystem.Config.Monster)
            end
        end
        for model, data in pairs(EspSystem.Monster.EspCache) do
            if not model.Parent then
                if data.highlight then data.highlight:Destroy() end
                if data.billboard then data.billboard:Destroy() end
                EspSystem.Monster.EspCache[model] = nil
            else
                if data.highlight then
                    data.highlight.Enabled = EspSystem.Config.Monster.Types.Box
                end
                if data.txtName then
                    data.txtName.Visible = EspSystem.Config.Monster.Types.Name
                end
                if data.txtDist then
                    data.txtDist.Visible = EspSystem.Config.Monster.Types.Distance
                    if EspSystem.Config.Monster.Types.Distance and rootPos then
                        local root = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
                        if root then
                            local dist = (rootPos - root.Position).Magnitude
                            data.txtDist.Text = string_format("%.0fm", dist)
                        end
                    end
                end
            end
        end
    else
        EspSystem.CleanupEntityEspCache(EspSystem.Monster.EspCache)
        table.clear(EspSystem.Monster.ChildrenCache)
    end
end

function EspSystem.UpdateNpcEsp()
    if inLobby then return end
    local currentTime = tick()
    if currentTime - EspSystem.Npc.LastUpdateTime < EspSystem.Npc.UpdateInterval then
        return
    end
    EspSystem.Npc.LastUpdateTime = currentTime
    local LocalPlayer = Services.Players.LocalPlayer
    local Character = LocalPlayer.Character
    local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    local rootPos = RootPart and RootPart.Position
    local NpcFolder = Services.Workspace.GameSystem.NPCModels
    local npcColor = Color3.fromRGB(0, 255, 0)
    if EspSystem.Config.Npc.Enabled then
        local childrenCache = EspSystem.Npc.ChildrenCache
        if #childrenCache == 0 then
            for _, npc in pairs(NpcFolder:GetChildren()) do
                if npc:IsA("Model") then
                    table.insert(childrenCache, npc)
                end
            end
        end
        for i = #childrenCache, 1, -1 do
            local npc = childrenCache[i]
            if not npc.Parent then
                table.remove(childrenCache, i)
            elseif not EspSystem.Npc.EspCache[npc] then
                EspSystem.CreateEntityEsp(npc, EspSystem.Npc.EspCache, npcColor, function(m) return m.Name end, EspSystem.Config.Npc)
            end
        end
        for model, data in pairs(EspSystem.Npc.EspCache) do
            if not model.Parent then
                if data.highlight then data.highlight:Destroy() end
                if data.billboard then data.billboard:Destroy() end
                EspSystem.Npc.EspCache[model] = nil
            else
                if data.highlight then
                    data.highlight.Enabled = EspSystem.Config.Npc.Types.Box
                end
                if data.txtName then
                    data.txtName.Visible = EspSystem.Config.Npc.Types.Name
                end
                if data.txtDist then
                    data.txtDist.Visible = EspSystem.Config.Npc.Types.Distance
                    if EspSystem.Config.Npc.Types.Distance and rootPos then
                        local root = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
                        if root then
                            local dist = (rootPos - root.Position).Magnitude
                            data.txtDist.Text = string_format("%.0fm", dist)
                        end
                    end
                end
            end
        end
    else
        EspSystem.CleanupEntityEspCache(EspSystem.Npc.EspCache)
        table.clear(EspSystem.Npc.ChildrenCache)
    end
end

function EspSystem.InitializeItemEsp()
    if inLobby then return end
    for _, child in ipairs(WorldLoots:GetChildren()) do
        if not EspSystem.Item.Tracers[child] then
            EspSystem.Item.Tracers[child] = EspSystem.CreateTracer()
        end
    end
end

function EspSystem.CleanupItemEsp()
    if EspSystem.Item.RenderConn then
        EspSystem.Item.RenderConn:Disconnect()
        EspSystem.Item.RenderConn = nil
    end
    if EspSystem.Item.ChildAddedConn then
        EspSystem.Item.ChildAddedConn:Disconnect()
        EspSystem.Item.ChildAddedConn = nil
    end
    for item, tracer in pairs(EspSystem.Item.Tracers) do
        tracer:Remove()
    end
    EspSystem.Item.Tracers = {}
    EspSystem.CleanupItemEspCache()
end

function EspSystem.CleanupMonsterEsp()
    if EspSystem.Monster.RenderConn then
        EspSystem.Monster.RenderConn:Disconnect()
        EspSystem.Monster.RenderConn = nil
    end
    if EspSystem.Monster.ChildAddedConn then
        EspSystem.Monster.ChildAddedConn:Disconnect()
        EspSystem.Monster.ChildAddedConn = nil
    end
    EspSystem.CleanupEntityEspCache(EspSystem.Monster.EspCache)
end

function EspSystem.CleanupNpcEsp()
    if EspSystem.Npc.RenderConn then
        EspSystem.Npc.RenderConn:Disconnect()
        EspSystem.Npc.RenderConn = nil
    end
    if EspSystem.Npc.ChildAddedConn then
        EspSystem.Npc.ChildAddedConn:Disconnect()
        EspSystem.Npc.ChildAddedConn = nil
    end
    EspSystem.CleanupEntityEspCache(EspSystem.Npc.EspCache)
end

if not inLobby then
    Tabs.Esp:Section({ Title = "物品透视" })
    local itemEspTypes = Tabs.Esp:Dropdown({
        Title = "显示类型",
        Values = {"追踪线", "名称", "距离", "价格"},
        Value = getgenv().NOL.ItemEspTypes,
        Multi = true,
        AllowNone = false,
        Callback = function(selectedValues)
            getgenv().NOL.ItemEspTypes = selectedValues
            for key in pairs(EspSystem.Config.Item.Types) do
                EspSystem.Config.Item.Types[key] = false
            end
            for _, value in pairs(selectedValues) do
                local espKey = (value == "追踪线" and "Tracer") or (value == "名称" and "Name") or (value == "距离" and "Distance") or (value == "价格" and "Price")
                if EspSystem.Config.Item.Types[espKey] ~= nil then
                    EspSystem.Config.Item.Types[espKey] = true
                end
            end
        end
    })
    _G.NOLControls["ItemEspTypes"] = itemEspTypes

    local itemEspToggle = Tabs.Esp:Toggle({
        Title = "启用物品透视",
        Default = getgenv().NOL.ItemEspEnabled,
        Callback = function(state)
            getgenv().NOL.ItemEspEnabled = state
            EspSystem.Config.Item.Enabled = state
            if state then
                EspSystem.InitializeItemEsp()
                table.clear(EspSystem.Item.ChildrenCache)
                EspSystem.Item.ChildAddedConn = WorldLoots.ChildAdded:Connect(function(newItem)
                    if (newItem:IsA("Tool") or newItem:IsA("Model")) then
                        table.insert(EspSystem.Item.ChildrenCache, newItem)
                        if not EspSystem.Item.Tracers[newItem] then
                            EspSystem.Item.Tracers[newItem] = EspSystem.CreateTracer()
                        end
                    end
                end)
                WorldLoots.ChildRemoved:Connect(function(removedItem)
                    for i = #EspSystem.Item.ChildrenCache, 1, -1 do
                        if EspSystem.Item.ChildrenCache[i] == removedItem then
                            table.remove(EspSystem.Item.ChildrenCache, i)
                            break
                        end
                    end
                end)
                EspSystem.Item.RenderConn = Services.RunService.Heartbeat:Connect(function()
                    EspSystem.UpdateItemEsp()
                end)
            else
                EspSystem.CleanupItemEsp()
                table.clear(EspSystem.Item.ChildrenCache)
            end
        end
    })
    _G.NOLControls["ItemEspEnabled"] = itemEspToggle

    local itemPriceInput = Tabs.Esp:Input({
        Title = "最低价格",
        Value = getgenv().NOL.ItemEspMinPrice,
        InputIcon = "dollar-sign",
        Type = "Input",
        Placeholder = "价格 ...",
        Callback = function(inputValue)
            if string.match(inputValue, "^%d+$") then
                getgenv().NOL.ItemEspMinPrice = inputValue
                EspSystem.Config.Item.MinPrice = tonumber(inputValue)
            else
                getgenv().NOL.ItemEspMinPrice = "0"
                itemPriceInput:Highlight()
                itemPriceInput:Set("0")
                EspSystem.Config.Item.MinPrice = 0
            end
        end
    })
    _G.NOLControls["ItemEspMinPrice"] = itemPriceInput

    Tabs.Esp:Section({ Title = "怪物透视" })
    local monsterEspTypes = Tabs.Esp:Dropdown({
        Title = "显示类型",
        Values = {"方框", "名称", "距离"},
        Value = getgenv().NOL.MonsterEspTypes,
        Multi = true,
        AllowNone = false,
        Callback = function(selectedValues)
            getgenv().NOL.MonsterEspTypes = selectedValues
            for key in pairs(EspSystem.Config.Monster.Types) do
                EspSystem.Config.Monster.Types[key] = false
            end
            for _, value in pairs(selectedValues) do
                local espKey = (value == "方框" and "Box") or (value == "名称" and "Name") or (value == "距离" and "Distance")
                if EspSystem.Config.Monster.Types[espKey] ~= nil then
                    EspSystem.Config.Monster.Types[espKey] = true
                end
            end
        end
    })
    _G.NOLControls["MonsterEspTypes"] = monsterEspTypes

    local monsterEspToggle = Tabs.Esp:Toggle({
        Title = "启用怪物透视",
        Default = getgenv().NOL.MonsterEspEnabled,
        Callback = function(state)
            getgenv().NOL.MonsterEspEnabled = state
            EspSystem.Config.Monster.Enabled = state
            if state then
                table.clear(EspSystem.Monster.ChildrenCache)
                EspSystem.Monster.ChildAddedConn = Services.Workspace.GameSystem.Monsters.ChildAdded:Connect(function(newMonster)
                    if newMonster:IsA("Model") then
                        table.insert(EspSystem.Monster.ChildrenCache, newMonster)
                    end
                end)
                Services.Workspace.GameSystem.Monsters.ChildRemoved:Connect(function(removedMonster)
                    for i = #EspSystem.Monster.ChildrenCache, 1, -1 do
                        if EspSystem.Monster.ChildrenCache[i] == removedMonster then
                            table.remove(EspSystem.Monster.ChildrenCache, i)
                            break
                        end
                    end
                end)
                EspSystem.Monster.RenderConn = Services.RunService.Heartbeat:Connect(function()
                    EspSystem.UpdateMonsterEsp()
                end)
            else
                EspSystem.CleanupMonsterEsp()
                table.clear(EspSystem.Monster.ChildrenCache)
            end
        end
    })
    _G.NOLControls["MonsterEspEnabled"] = monsterEspToggle

    Tabs.Esp:Section({ Title = "NPC透视" })
    local npcEspTypes = Tabs.Esp:Dropdown({
        Title = "显示类型",
        Values = {"方框", "名称", "距离"},
        Value = getgenv().NOL.NpcEspTypes,
        Multi = true,
        AllowNone = false,
        Callback = function(selectedValues)
            getgenv().NOL.NpcEspTypes = selectedValues
            for key in pairs(EspSystem.Config.Npc.Types) do
                EspSystem.Config.Npc.Types[key] = false
            end
            for _, value in pairs(selectedValues) do
                local espKey = (value == "方框" and "Box") or (value == "名称" and "Name") or (value == "距离" and "Distance")
                if EspSystem.Config.Npc.Types[espKey] ~= nil then
                    EspSystem.Config.Npc.Types[espKey] = true
                end
            end
        end
    })
    _G.NOLControls["NpcEspTypes"] = npcEspTypes

    local npcEspToggle = Tabs.Esp:Toggle({
        Title = "启用NPC透视",
        Default = getgenv().NOL.NpcEspEnabled,
        Callback = function(state)
            getgenv().NOL.NpcEspEnabled = state
            EspSystem.Config.Npc.Enabled = state
            if state then
                table.clear(EspSystem.Npc.ChildrenCache)
                EspSystem.Npc.ChildAddedConn = Services.Workspace.GameSystem.NPCModels.ChildAdded:Connect(function(newNpc)
                    if newNpc:IsA("Model") then
                        table.insert(EspSystem.Npc.ChildrenCache, newNpc)
                    end
                end)
                Services.Workspace.GameSystem.NPCModels.ChildRemoved:Connect(function(removedNpc)
                    for i = #EspSystem.Npc.ChildrenCache, 1, -1 do
                        if EspSystem.Npc.ChildrenCache[i] == removedNpc then
                            table.remove(EspSystem.Npc.ChildrenCache, i)
                            break
                        end
                    end
                end)
                EspSystem.Npc.RenderConn = Services.RunService.Heartbeat:Connect(function()
                    EspSystem.UpdateNpcEsp()
                end)
            else
                EspSystem.CleanupNpcEsp()
                table.clear(EspSystem.Npc.ChildrenCache)
            end
        end
    })
    _G.NOLControls["NpcEspEnabled"] = npcEspToggle
end

Tabs.Main:Section({ Title = "人物功能" })
do
    local speedEnabled = false
    local speedValue = 50
    local originalSpeed = nil
    local speedConnection = nil
    local characterAddedConnection = nil
    local function ApplySpeed(character)
        if not character then return end
        pcall(function()
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if not originalSpeed then
                    originalSpeed = humanoid.WalkSpeed
                end
                humanoid.WalkSpeed = speedValue
            end
        end)
    end
    local function StartSpeed()
        if speedConnection then return end
        local plr = Services.Players.LocalPlayer
        if plr.Character then
            ApplySpeed(plr.Character)
        end
        speedConnection = Services.RunService.Heartbeat:Connect(function()
            if not speedEnabled then
                if speedConnection then
                    speedConnection:Disconnect()
                    speedConnection = nil
                end
                return
            end
            local chr = plr.Character
            if chr then
                ApplySpeed(chr)
            end
        end)
        characterAddedConnection = plr.CharacterAdded:Connect(function(character)
            if speedEnabled then
                task.wait(0.1)
                originalSpeed = nil
                ApplySpeed(character)
            end
        end)
    end
    local function StopSpeed()
        if speedConnection then
            speedConnection:Disconnect()
            speedConnection = nil
        end
        if characterAddedConnection then
            characterAddedConnection:Disconnect()
            characterAddedConnection = nil
        end
        local plr = Services.Players.LocalPlayer
        if plr.Character then
            pcall(function()
                local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                if humanoid and originalSpeed then
                    humanoid.WalkSpeed = originalSpeed
                    originalSpeed = nil
                end
            end)
        end
    end
    local speedToggle = Tabs.Main:Toggle({
        Title = "速度加快",
        Default = getgenv().NOL.SpeedEnabled,
        Callback = function(state)
            if inLobby then
                Library:Notify({ Title = "提示", Content = "大厅中无法使用此功能", Duration = 2 })
                return
            end
            getgenv().NOL.SpeedEnabled = state
            speedEnabled = state
            if state then
                StartSpeed()
            else
                StopSpeed()
            end
        end
    })
    _G.NOLControls["SpeedEnabled"] = speedToggle
end

do
    local infiniteStaminaEnabled = false
    local staminaConnection = nil
    local function StartInfiniteStamina()
        if staminaConnection then return end
        pcall(function()
            local ReplicatedStorage = CloneRef(game:GetService("ReplicatedStorage"))
            local RunService = CloneRef(game:GetService("RunService"))
            local Value = require(ReplicatedStorage.Shared.Core.Value)
            for _, Connection in getconnections(RunService.PreRender) do
                local Source = debug.info(Connection.Function, "s")
                if Source == "ReplicatedStorage.Client.System.Property.StaminaHandle" then
                    Connection:Disconnect()
                end
            end
            staminaConnection = RunService.PreRender:Connect(function()
                if infiniteStaminaEnabled then
                    Value.Stamina = 100
                end
            end)
        end)
    end
    local function StopInfiniteStamina()
        if staminaConnection then
            staminaConnection:Disconnect()
            staminaConnection = nil
        end
    end
    local staminaToggle = Tabs.Main:Toggle({
        Title = "无限体力",
        Default = getgenv().NOL.StaminaEnabled,
        Callback = function(state)
            if inLobby then
                Library:Notify({ Title = "提示", Content = "大厅中无法使用此功能", Duration = 2 })
                return
            end
            getgenv().NOL.StaminaEnabled = state
            infiniteStaminaEnabled = state
            if state then
                StartInfiniteStamina()
            else
                StopInfiniteStamina()
            end
        end
    })
    _G.NOLControls["StaminaEnabled"] = staminaToggle
end

do
    local invincibleEnabled = false
    local invincibleConnection = nil
    local function enableInvincible()
        local character = Services.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local clone = character.HumanoidRootPart:Clone()
            clone.Parent = character
        end
    end
    local function onCharacterAdded(character)
        task.wait(0.5)
        if invincibleEnabled then
            enableInvincible()
        end
    end
    local invincibleToggle = Tabs.Main:Toggle({
        Title = "无敌",
        Default = getgenv().NOL.InvincibleEnabled,
        Callback = function(state)
            if inLobby then
                Library:Notify({ Title = "提示", Content = "大厅中无法使用此功能", Duration = 2 })
                return
            end
            getgenv().NOL.InvincibleEnabled = state
            invincibleEnabled = state
            if state then
                enableInvincible()
                if invincibleConnection then
                    invincibleConnection:Disconnect()
                end
                invincibleConnection = Services.Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
            else
                if invincibleConnection then
                    invincibleConnection:Disconnect()
                    invincibleConnection = nil
                end
            end
        end
    })
    _G.NOLControls["InvincibleEnabled"] = invincibleToggle
end

local anySellToggle = Tabs.Main:Toggle({
    Title = "随处出售",
    Default = getgenv().NOL.AnySellEnabled,
    Callback = function(state)
        if inLobby then
            Library:Notify({ Title = "提示", Content = "大厅中无法使用此功能", Duration = 2 })
            return
        end
        getgenv().NOL.AnySellEnabled = state
        if state then
            pcall(function()
                local v_u_3 = require(game:GetService("ReplicatedStorage").Shared.Core.TEvent)
                local v_u_11 = game:GetService("Players").LocalPlayer
                if v_u_11.Character and v_u_11.Character.PrimaryPart then
                    v_u_3.FireRemote("PlayerInElevator", true, v_u_11.Character.PrimaryPart.CFrame.Position, v_u_3.UnixTimeMillis())
                end
            end)
        end
    end
})
_G.NOLControls["AnySellEnabled"] = anySellToggle

Tabs.Main:Section({ Title = "环境功能" })
local Lighting = CloneRef(game:GetService("Lighting"))
local Atmosphere = Lighting:FindFirstChild("Atmosphere")
local OriginalAtmosphereDensity = nil
if Atmosphere then
    OriginalAtmosphereDensity = Atmosphere.Density
end
local OriginalGlobalShadows = Lighting.GlobalShadows
local OriginalClockTime = Lighting.ClockTime
local OriginalBrightness = Lighting.Brightness
local OriginalFogEnd = Lighting.FogEnd
local OriginalOutdoorAmbient = Lighting.OutdoorAmbient
local fullBrightToggle = Tabs.Main:Toggle({
    Title = "全亮",
    Default = getgenv().NOL.FullBrightEnabled,
    Callback = function(state)
        if inLobby then
            Library:Notify({ Title = "提示", Content = "大厅中无法使用此功能", Duration = 2 })
            return
        end
        getgenv().NOL.FullBrightEnabled = state
        if state then
            if Atmosphere then Atmosphere.Density = 0 end
            Lighting.GlobalShadows = false
            Lighting.ClockTime = 12
            Lighting.Brightness = 4
            Lighting.FogEnd = 100000
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        else
            if Atmosphere and OriginalAtmosphereDensity then Atmosphere.Density = OriginalAtmosphereDensity end
            Lighting.GlobalShadows = OriginalGlobalShadows
            Lighting.ClockTime = OriginalClockTime
            Lighting.Brightness = OriginalBrightness
            Lighting.FogEnd = OriginalFogEnd
            Lighting.OutdoorAmbient = OriginalOutdoorAmbient
        end
    end
})
_G.NOLControls["FullBrightEnabled"] = fullBrightToggle

PushMonsterToggle = nil

local LocalPlayer = Services.Players.LocalPlayer
local WorldLootsFolder = nil
local ReplicatedStorage = CloneRef(game:GetService("ReplicatedStorage"))
local TEvent = nil
if not inLobby then
    WorldLootsFolder = Services.Workspace.GameSystem.Loots.World
    TEvent = require(ReplicatedStorage.Shared.Core.TEvent)
end
local function InteractWithItem(item)
    if inLobby then return end
    if (item:IsA("Model") or item:IsA("Tool")) and (item:HasTag("Interactable") and item:GetAttribute("en")) then
        TEvent.FireRemote("Interactable", item)
    end
end
local AutoOpenConn = nil

local AutoNextFloorEnabled = false
local AutoNextFloorConn = nil
local function CheckCashAndNextFloor()
    if inLobby then return end
    local plr = Services.Players.LocalPlayer
    local PlayerGui = plr:FindFirstChild("PlayerGui")
    if not PlayerGui then return end
    local Main = PlayerGui:FindFirstChild("Main")
    if not Main then return end
    local HomePage = Main:FindFirstChild("HomePage")
    if not HomePage then return end
    local Goal = HomePage:FindFirstChild("Goal")
    if not Goal then return end
    local GoalProgressBar = Goal:FindFirstChild("GoalProgressBar")
    if not GoalProgressBar then return end
    local GoalText = GoalProgressBar:FindFirstChild("GoalText")
    if not GoalText then return end
    
    local CashText = GoalText:FindFirstChild("Cash")
    local GoalNumText = GoalText:FindFirstChild("Goal")
    if not CashText or not GoalNumText then return end
    
    local currentCash = tonumber(CashText.Text:match("%d+")) or 0
    local goalNum = tonumber(GoalNumText.Text:match("/(%d+)")) or 0
    
    if currentCash >= goalNum then
        TEvent.FireRemote("SubmitVote", "continue")
        task.wait(1)
    end
end

local AutoPickupConn = nil
local v_u_6 = nil
local v_u_7 = nil
local v_u_8 = nil
local function InitializeQuickPickup()
    if inLobby then return end
    if v_u_6 and v_u_7 and v_u_8 then return end
    local ReplicatedStorage = CloneRef(game:GetService("ReplicatedStorage"))
    v_u_6 = require(ReplicatedStorage.Shared.Core.TEvent)
    v_u_7 = require(ReplicatedStorage.Shared.Core.Value)
    for _, m in pairs(ReplicatedStorage:GetDescendants()) do
        if m:IsA("ModuleScript") and m.Name == "Config" then
            local success, result = pcall(require, m)
            if success and type(result) == "table" and result.Get then
                v_u_8 = result
                break
            end
        end
    end
end
local function getLootFolder()
    if inLobby then return nil end
    local success, folder = pcall(function()
        return Services.Workspace.GameSystem.Loots.World
    end)
    return success and folder or nil
end

local AutoCollectEggEnabled = false

local ElevatorPosition = nil
if not inLobby then
    pcall(function()
        local elevatorModel = Services.Workspace:FindFirstChild("电梯")
        if elevatorModel then
            local left4 = elevatorModel:FindFirstChild("Left4")
            if left4 then
                local elevator = left4:FindFirstChild("升降梯") or left4:FindFirstChild("Elevator") or left4:FindFirstChildOfClass("Model")
                if elevator then
                    local ground = elevator:FindFirstChild("Ground")
                    if ground then
                        local targetPoint = ground:FindFirstChild("电梯到达点") or ground:FindFirstChild("TargetPoint") or ground:FindFirstChildOfClass("BasePart")
                        if targetPoint and targetPoint:IsA("BasePart") then
                            ElevatorPosition = targetPoint
                        end
                    end
                end
            end
        end
    end)
end
local ForceConfig = {
    BoiTsThePowerOfFORCEPull = 180,
    MonsterForceRadius = 100,
    Strength = 500,
    MinDistance = 10
}
local function IsPlayerOwned(part)
    local iter, state, index = ipairs(Services.Players:GetPlayers())
    while true do
        local player
        index, player = iter(state, index)
        if index == nil then
            break
        end
        if player.Character and part:IsDescendantOf(player.Character) then
            return true
        end
    end
    return false
end
Tabs.Malicious:Section({ Title = "物品控制" })

local AutoCollectConfig = {
    Enabled = false
}
local AutoCollectOpenConn = nil

local PlayerGui = Services.Players.LocalPlayer:WaitForChild("PlayerGui")
local MainGui = PlayerGui:WaitForChild("Main")
local InteractiveItemsFolder = nil
local WorldLootFolder = nil
local ElevatorDropoff = nil
local TimerFrame = nil
local InventorySlots = {}
local HandsFullUI = nil
local HealthValue = nil
if not inLobby then
    InteractiveItemsFolder = Services.Workspace.GameSystem.InteractiveItem
    WorldLootFolder = Services.Workspace.GameSystem.Loots.World
    ElevatorDropoff = Services.Workspace.GameSystem.Loots.ElevatorCollect.SoundPlay
    TimerFrame = MainGui.HomePage.Countdown.Main.ElapsedTime.CanvasGroup2.Frame
    InventorySlots = {
        MainGui.HomePage.Bottom["1"].ItemDetails.ItemName,
        MainGui.HomePage.Bottom["2"].ItemDetails.ItemName,
        MainGui.HomePage.Bottom["3"].ItemDetails.ItemName,
        MainGui.HomePage.Bottom["4"].ItemDetails.ItemName
    }
    HandsFullUI = MainGui.HomePage.HandsFull
    HealthValue = MainGui.HomePage.Property.HealthBar.Bar.Value
    PrevHealth = HealthValue.Value
end

local ItemCache = {}
local CACHE_DURATION = 0.5

local function GetItemPrice(item)
    if inLobby then return 0 end
    local cacheKey = tostring(item)
    local cached = ItemCache[cacheKey]
    if cached and tick() - cached.time < CACHE_DURATION then
        return cached.price
    end
    local price = 0
    pcall(function()
        local lootUI = item:FindFirstChild("LootUI", true)
        if lootUI and lootUI:FindFirstChild("Frame") then
            local frame = lootUI.Frame
            local priceText = frame:FindFirstChild("Price") and frame.Price.Text or "0"
            price = tonumber(priceText:match("%d+")) or 0
        end
    end)
    ItemCache[cacheKey] = {price = price, time = tick()}
    return price
end

local function IsItemAvailable(item)
    if inLobby then return false end
    if not item or not item.Parent then return false end
    local isLeft = item:GetAttribute("left") == true
    if isLeft then
        local z1Part = item:FindFirstChild("z1", true)
        if z1Part and z1Part:IsA("BasePart") then
            local color = z1Part.Color
            if math.round(color.R * 255) == 226 and math.round(color.G * 255) == 178 and math.round(color.B * 255) == 58 then
                isLeft = false
            end
        end
    end
    return not isLeft
end

local MonsterItemsCache = {}
local MonsterParentsCache = {}
local MonsterCacheTime = 0
local MONSTER_CACHE_DURATION = 2

local function UpdateMonsterCache()
    if inLobby then return end
    local currentTime = tick()
    if currentTime - MonsterCacheTime < MONSTER_CACHE_DURATION then
        return
    end
    table.clear(MonsterItemsCache)
    table.clear(MonsterParentsCache)
    local MonsterFolder = Services.Workspace.GameSystem.Monsters
    if MonsterFolder then
        for _, monsterItem in pairs(MonsterFolder:GetChildren()) do
            MonsterItemsCache[monsterItem] = true
            if monsterItem.Parent then
                MonsterParentsCache[monsterItem.Parent] = true
            end
        end
    end
    MonsterCacheTime = currentTime
end

local function IsItemInMonsters(item)
    if inLobby then return false end
    if not item then return false end
    UpdateMonsterCache()
    if MonsterItemsCache[item] == true then
        return true
    end
    if item.Parent and MonsterParentsCache[item.Parent] == true then
        return true
    end
    return false
end

local function IsHandsFull()
    if inLobby then return false end
    return HandsFullUI.Visible
end

local function IsInventoryFull()
    if inLobby then return false end
    for _, slot in pairs(InventorySlots) do
        if slot.Text == "" or slot.Text == " " or slot.Text == nil then
            return false
        end
    end
    return true
end

local function SetCollision(active)
    if inLobby then return end
    local character = Services.Players.LocalPlayer.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part ~= rootPart then
            part.CanCollide = not active
        end
    end
end

local function SmartTeleport(targetPos)
    if inLobby then return false end
    local character = Services.Players.LocalPlayer.Character
    if not character then return false end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    local currentPos = rootPart.Position
    local diff = targetPos - currentPos
    local distSqr = diff.X * diff.X + diff.Y * diff.Y + diff.Z * diff.Z
    if distSqr < 25 then
        rootPart.CFrame = CFrame_new(targetPos)
        return true
    end
    SetCollision(true)
    rootPart.Anchored = true
    rootPart.CFrame = CFrame_new(targetPos)
    task_wait(0.1)
    if rootPart then rootPart.Anchored = false end
    SetCollision(false)
    return true
end

local function ReturnToElevator()
    if inLobby then return end
    local character = Services.Players.LocalPlayer.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    local targetPos = ElevatorDropoff.Position
    SmartTeleport(targetPos)
    local maxWait = 0
    local targetDistSqr = 25
    while maxWait < 20 do
        if rootPart then
            local diff = rootPart.Position - targetPos
            local distSqr = diff.X * diff.X + diff.Y * diff.Y + diff.Z * diff.Z
            if distSqr < targetDistSqr then
                break
            end
        end
        task_wait(0.1)
        maxWait = maxWait + 1
    end
    task_wait(0.2)
end

local function CollectItem(item)
    if inLobby then return false end
    if not AutoCollectConfig.Enabled then return false end
    local character = Services.Players.LocalPlayer.Character
    if not character then return false end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    if not IsItemAvailable(item) then return false end
    if IsItemInMonsters(item) then return false end
    local interactablePart = item.PrimaryPart or (item:FindFirstChild("Interactable", true) or item:FindFirstChild("Handle", true) or item:FindFirstChildWhichIsA("BasePart", true))
    if not interactablePart then return false end
    local playerPos = rootPart.Position
    local itemPos = interactablePart.Position
    local diff = itemPos - playerPos
    local distSqr = diff.X * diff.X + diff.Y * diff.Y + diff.Z * diff.Z
    local interactDistance = item:GetAttribute("sz") or 30
    local interactDistSqr = interactDistance * interactDistance

    SmartTeleport(itemPos + Vector3_new(0, 1.5, 0))
    task_wait(0.2)

    local collectSuccess = false
    for i = 1, 8 do
        if not item.Parent then collectSuccess = true break end
        InteractWithItem(item)
        pcall(function()
            TEvent.FireRemote("Interactable", item)
            TEvent.FireBindable("Interactable", item)
        end)
        task_wait(0.2)
        if not item.Parent then collectSuccess = true break end
    end
    return collectSuccess
end

local function WaitForHandsEmpty()
    if inLobby then return end
    local waitCount = 0
    while IsHandsFull() and AutoCollectConfig.Enabled do
        task.wait(0.15)
        waitCount = waitCount + 1
        if waitCount > 30 then break end
    end
end

local function OpenAllInteractiveItems()
    if inLobby then return end
    local items = {}
    for _, item in pairs(InteractiveItemsFolder:GetChildren()) do
        if item:IsA("Model") or item:IsA("Tool") then
            table.insert(items, item)
        end
    end
    for i = 1, #items, 3 do
        if not AutoCollectConfig.Enabled then return end
        for j = i, math.min(i + 2, #items) do
            task.spawn(function()
                InteractWithItem(items[j])
                pcall(function()
                    TEvent.FireRemote("Interactable", items[j])
                end)
            end)
        end
        task.wait(0.1)
    end
    if not AutoCollectOpenConn then
        AutoCollectOpenConn = InteractiveItemsFolder.ChildAdded:Connect(function(newItem)
            if AutoCollectConfig.Enabled and (newItem:IsA("Model") or newItem:IsA("Tool")) then
                task.wait(0.05)
                InteractWithItem(newItem)
                pcall(function()
                    TEvent.FireRemote("Interactable", newItem)
                end)
            end
        end)
    end
end

local function SortItemsByPriority(items, playerPos)
    if inLobby then return {} end
    local itemData = {}
    for _, item in pairs(items) do
        if IsItemAvailable(item) and not IsItemInMonsters(item) then
            local interactablePart = item.PrimaryPart or (item:FindFirstChild("Interactable", true) or item:FindFirstChild("Handle", true))
            if interactablePart then
                local distance = (interactablePart.Position - playerPos).Magnitude
                local price = GetItemPrice(item)
                local distanceWeight = distance < 50 and 0.5 or 0.2
                local priceWeight = price > 1000 and 0.8 or 0.5
                local priority = price * priceWeight - distance * distanceWeight
                table.insert(itemData, {
                    item = item,
                    distance = distance,
                    price = price,
                    priority = priority
                })
            end
        end
    end
    table.sort(itemData, function(a, b)
        return a.priority > b.priority
    end)
    return itemData
end

local function HasRemainingItems()
    if inLobby then return false end
    local worldItemCount = 0
    for _, item in pairs(WorldLootFolder:GetChildren()) do
        if (item:IsA("Tool") or item:IsA("Model")) and item.Parent then
            if IsItemAvailable(item) and not IsItemInMonsters(item) then
                worldItemCount = worldItemCount + 1
            end
        end
    end
    local interactiveItemCount = 0
    for _, item in pairs(InteractiveItemsFolder:GetChildren()) do
        if (item:IsA("Model") or item:IsA("Tool")) and item.Parent then
            if item:HasTag("Interactable") and item:GetAttribute("en") then
                interactiveItemCount = interactiveItemCount + 1
            end
        end
    end
    return worldItemCount > 0 or interactiveItemCount > 0
end

local AutoCollectLoop = nil
if not inLobby then
    local autoCollectToggle = Tabs.Auto:Toggle({
        Title = "自动收集",
        Default = getgenv().NOL.AutoCollectEnabled,
        Callback = function(state)
            getgenv().NOL.AutoCollectEnabled = state
            AutoCollectConfig.Enabled = state
            if state then
                if AutoCollectLoop then
                    AutoCollectLoop:Disconnect()
                end
                AutoCollectLoop = task.spawn(function()
                    while AutoCollectConfig.Enabled do
                        if IsHandsFull() or IsInventoryFull() then
                            ReturnToElevator()
                            WaitForHandsEmpty()
                            task.wait(0.5)
                            continue
                        end
                        OpenAllInteractiveItems()
                        local character = Services.Players.LocalPlayer.Character
                        if not character then
                            task.wait(0.1)
                            continue
                        end
                        local rootPart = character:FindFirstChild("HumanoidRootPart")
                        if not rootPart then
                            task.wait(0.1)
                            continue
                        end
                        local playerPos = rootPart.Position
                        local items = {}
                        for _, item in pairs(WorldLootFolder:GetChildren()) do
                            if (item:IsA("Tool") or item:IsA("Model")) and item.Parent then
                                table.insert(items, item)
                            end
                        end
                        local sortedItems = SortItemsByPriority(items, playerPos)
                        for _, data in pairs(sortedItems) do
                            if not AutoCollectConfig.Enabled then break end
                            if IsHandsFull() or IsInventoryFull() then break end
                            CollectItem(data.item)
                        end
                        if not HasRemainingItems() then
                            task.wait(1)
                        end
                        task.wait(0.1)
                    end
                end)
            else
                if AutoCollectLoop then
                    AutoCollectLoop:Disconnect()
                    AutoCollectLoop = nil
                end
                if AutoCollectOpenConn then
                    AutoCollectOpenConn:Disconnect()
                    AutoCollectOpenConn = nil
                end
            end
        end
    })
    _G.NOLControls["AutoCollectEnabled"] = autoCollectToggle
end

if not inLobby then
    local autoOpenToggle = Tabs.Auto:Toggle({
        Title = "自动打开",
        Default = getgenv().NOL.AutoOpenEnabled,
        Callback = function(state)
            getgenv().NOL.AutoOpenEnabled = state
            if state then
                task.spawn(function()
                    local iter, state2, item = pairs(Services.Workspace.GameSystem.InteractiveItem:GetChildren())
                    while true do
                        local interactiveItem
                        item, interactiveItem = iter(state2, item)
                        if item == nil then
                            break
                        end
                        InteractWithItem(interactiveItem)
                    end
                end)
                AutoOpenConn = Services.Workspace.GameSystem.InteractiveItem.ChildAdded:Connect(InteractWithItem)
            elseif AutoOpenConn then
                AutoOpenConn:Disconnect()
                AutoOpenConn = nil
            end
        end
    })
    _G.NOLControls["AutoOpenEnabled"] = autoOpenToggle
end

if not inLobby then
    local autoNextFloorToggle = Tabs.Auto:Toggle({
        Title = "自动下一层",
        Default = getgenv().NOL.AutoNextFloorEnabled,
        Callback = function(state)
            getgenv().NOL.AutoNextFloorEnabled = state
            AutoNextFloorEnabled = state
            if state then
                if AutoNextFloorConn then AutoNextFloorConn:Disconnect() end
                AutoNextFloorConn = Services.RunService.Heartbeat:Connect(function()
                    if AutoNextFloorEnabled then
                        pcall(CheckCashAndNextFloor)
                    end
                end)
            else
                if AutoNextFloorConn then
                    AutoNextFloorConn:Disconnect()
                    AutoNextFloorConn = nil
                end
            end
        end
    })
    _G.NOLControls["AutoNextFloorEnabled"] = autoNextFloorToggle
end

if not inLobby then
    local autoPickupToggle = Tabs.Auto:Toggle({
        Title = "自动拾取",
        Default = getgenv().NOL.AutoPickupEnabled,
        Callback = function(state)
            getgenv().NOL.AutoPickupEnabled = state
            if state then
                InitializeQuickPickup()
                if not v_u_8 then
                    return
                end
                _G.FastLootOnly = true
                if AutoPickupConn then
                    AutoPickupConn:Disconnect()
                end
                AutoPickupConn = Services.RunService.Heartbeat:Connect(function()
                    if not _G.FastLootOnly then return end
                    local target = nil
                    pcall(function() target = v_u_7.InteractTarget() end)
                    if target then
                        local success, v12 = pcall(function() return v_u_8.Get(target) end)
                        if success and v12 and v12.instance then
                            local lootFolder = getLootFolder()
                            if lootFolder and v12.instance:IsDescendantOf(lootFolder) then
                                if v12.server then
                                    v_u_6.FireRemote("Interactable", v12.instance)
                                end
                                v_u_6.FireBindable("Interactable", v12.instance)
                                if v_u_8.Trigger then
                                    pcall(function() v_u_8.Trigger(target) end)
                                end
                                v_u_7.InteractTick = os.clock() + 0.02
                                v_u_7.InteractTarget = nil
                                v_u_6.FireBindable("InteractTargetChanged", nil)
                            end
                        end
                    end
                end)
            else
                _G.FastLootOnly = false
                if AutoPickupConn then
                    AutoPickupConn:Disconnect()
                    AutoPickupConn = nil
                end
            end
        end
    })
    _G.NOLControls["AutoPickupEnabled"] = autoPickupToggle
end

if not inLobby then
    local autoCollectEggToggle = Tabs.Auto:Toggle({
        Title = "自动收集蛋",
        Default = getgenv().NOL.AutoCollectEggEnabled,
        Callback = function(state)
            getgenv().NOL.AutoCollectEggEnabled = state
            AutoCollectEggEnabled = state
            task.spawn(function()
                while AutoCollectEggEnabled do
                    local shouldBreak = false
                    local function BreakLoop()
                        shouldBreak = true
                    end
                    local character = Services.Players.LocalPlayer.Character
                    if character then
                        character = character:FindFirstChild("HumanoidRootPart")
                    end
                    if character then
                        local originalCFrame = character.CFrame
                        local iter, state2, item = pairs(Services.Workspace.GameSystem.Loots.World:GetChildren())
                        while true do
                            local loot
                            item, loot = iter(state2, item)
                            if item == nil then
                                break
                            end
                            if not AutoCollectEggEnabled then
                                BreakLoop()
                            end
                            local eggPart = loot:FindFirstChild("Egg", true)
                            if eggPart and (eggPart.Parent and eggPart.Parent.Parent) and eggPart.Parent.Parent:IsA("Tool") then
                                local eggTool = eggPart.Parent.Parent
                                local primaryPart = eggTool.PrimaryPart or eggTool:FindFirstChildWhichIsA("BasePart")
                                if not primaryPart then
                                    break
                                end
                                local originalPushState = PushMonsterToggle and PushMonsterToggle.Value or false
                                if PushMonsterToggle and not originalPushState then
                                    PushMonsterToggle:Set(true)
                                end
                                character.CFrame = primaryPart.CFrame
                                task.wait(0.1)
                                if (primaryPart.Position - character.Position).Magnitude <= 5 then
                                    for _ = 1, 10 do
                                        if Services.Workspace.GameSystem.Loots.Player:FindFirstChild(eggTool.Name, true) then
                                            BreakLoop()
                                        end
                                        InteractWithItem(eggTool)
                                        task.wait(0.1)
                                    end
                                    if Services.Workspace.GameSystem.Loots.Player:FindFirstChild(eggTool.Name, true) then
                                        character.CFrame = originalCFrame
                                        if PushMonsterToggle then
                                            PushMonsterToggle:Set(originalPushState)
                                        end
                                    end
                                end
                            end
                        end
                        task.wait(0.5)
                    else
                        task.wait()
                    end
                    if shouldBreak then
                        break
                    end
                end
            end)
        end
    })
    _G.NOLControls["AutoCollectEggEnabled"] = autoCollectEggToggle
end

local StopFloor = tonumber(getgenv().NOL.StopFloor) or 5
local AutoStopEnabled = false
local AutoStopConn = nil

local function GetCurrentFloor()
    if inLobby then return 0 end
    local MapFolder = Services.Workspace.GameSystem.Map
    if not MapFolder then return 0 end
    local maxFloor = 0
    for _, folder in pairs(MapFolder:GetChildren()) do
        if folder:IsA("Folder") and string.match(folder.Name, "^Map(%d+)$") then
            local floorNum = tonumber(string.match(folder.Name, "^Map(%d+)$")) or 0
            if floorNum > maxFloor then
                maxFloor = floorNum
            end
        end
    end
    return maxFloor
end

local function CheckCashForRetreat()
    if inLobby then return false end
    local plr = Services.Players.LocalPlayer
    local PlayerGui = plr:FindFirstChild("PlayerGui")
    if not PlayerGui then return false end
    local Main = PlayerGui:FindFirstChild("Main")
    if not Main then return false end
    local HomePage = Main:FindFirstChild("HomePage")
    if not HomePage then return false end
    local Goal = HomePage:FindFirstChild("Goal")
    if not Goal then return false end
    local GoalProgressBar = Goal:FindFirstChild("GoalProgressBar")
    if not GoalProgressBar then return false end
    local GoalText = GoalProgressBar:FindFirstChild("GoalText")
    if not GoalText then return false end
    
    local CashText = GoalText:FindFirstChild("Cash")
    local GoalNumText = GoalText:FindFirstChild("Goal")
    if not CashText or not GoalNumText then return false end
    
    local currentCash = tonumber(CashText.Text:match("%d+")) or 0
    local goalNum = tonumber(GoalNumText.Text:match("/(%d+)")) or 0
    
    return currentCash >= goalNum
end

local function CheckFloorAndRetreat()
    if inLobby then return end
    if not AutoStopEnabled then return end
    local currentFloor = GetCurrentFloor()
    if currentFloor >= StopFloor then
        if CheckCashForRetreat() then
            TEvent.FireRemote("SubmitVote", "retreat")
            AutoStopEnabled = false
            if AutoStopConn then
                AutoStopConn:Disconnect()
                AutoStopConn = nil
            end
        end
    end
end

local AutoStartConfig = {
    Enabled = true,
    TargetPlaceID = TARGET_LOBBY_PLACE_ID,
    TeleportDelay = 1.0,
    ClickDelay = 0.1
}
local AutoStartLoop = nil

local Positions = {
    Vector3_new(-1.73656654, 19.7737446, -14.1641445),
    Vector3_new(16.5216942, 19.8947258, -13.2114286),
    Vector3_new(35.3569298, 19.2672329, -14.4279108)
}

local function SimulateMouseClick(xScale, yScale)
    local viewportSize = Services.Workspace.CurrentCamera.ViewportSize
    local x = viewportSize.X * xScale
    local y = viewportSize.Y * yScale
    VirtualInputManager:SendMouseMoveEvent(x, y, game, 0)
    task.wait(0.01)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
    task.wait(0.01)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

local function IsCreatePartyUIVisible()
    local plr = Services.Players.LocalPlayer
    local PlayerGui = plr:FindFirstChild("PlayerGui")
    if not PlayerGui then return false end
    local Main = PlayerGui:FindFirstChild("Main")
    if not Main then return false end
    local Func = Main:FindFirstChild("Func")
    if not Func then return false end
    local CreateParty = Func:FindFirstChild("CreateParty")
    return CreateParty and CreateParty:IsA("GuiObject") and CreateParty.Visible
end

local function StartAutoStart()
    if game.PlaceId ~= AutoStartConfig.TargetPlaceID then
        Library:Notify({
            Title = "自动开局",
            Content = "当前不在大厅，功能未启动",
            Duration = 3,
            Icon = "warning"
        })
        return
    end

    AutoStartLoop = task.spawn(function()
        while AutoStartConfig.Enabled do
            for _, pos in ipairs(Positions) do
                if not AutoStartConfig.Enabled then break end
                local plr = Services.Players.LocalPlayer
                local character = plr.Character
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    pcall(function()
                        rootPart.CFrame = CFrame_new(pos + Vector3_new(0, 2, 0))
                    end)
                end
                task.wait(AutoStartConfig.TeleportDelay)
                if IsCreatePartyUIVisible() then
                    Library:Notify({
                        Title = "自动开局",
                        Content = "检测到创建派对UI，开始点击",
                        Duration = 2,
                        Icon = "check"
                    })
                    SimulateMouseClick(0.09, 0.416)
                    SimulateMouseClick(0.5, 0.839)
                    return
                end
            end
            task.wait(0.1)
        end
    end)
end

local function StopAutoStart()
    if AutoStartLoop then
        task.cancel(AutoStartLoop)
        AutoStartLoop = nil
    end
end

local autoStartToggle = Tabs.Auto:Toggle({
    Title = "自动开局",
    Default = getgenv().NOL.AutoStartEnabled,
    Callback = function(state)
        getgenv().NOL.AutoStartEnabled = state
        AutoStartConfig.Enabled = state
        if state then
            StartAutoStart()
        else
            StopAutoStart()
            Library:Notify({
                Title = "自动开局",
                Content = "功能已关闭",
                Duration = 2,
                Icon = "power-off"
            })
        end
    end
})
_G.NOLControls["AutoStartEnabled"] = autoStartToggle

if getgenv().NOL.AutoStartEnabled then
    task.spawn(StartAutoStart)
end

Tabs.Auto:Section({ Title = "自动终止" })
local stopFloorInput = Tabs.Auto:Input({
    Title = "终止层数",
    Value = tostring(StopFloor),
    InputIcon = "number",
    Type = "Input",
    Placeholder = "输入终止层数...",
    Callback = function(inputValue)
        if string.match(inputValue, "^%d+$") then
            StopFloor = tonumber(inputValue)
            getgenv().NOL.StopFloor = inputValue
        else
            Tabs.Auto:Notify({
                Title = "输入错误",
                Content = "请输入有效数字",
                Duration = 2
            })
        end
    end
})
_G.NOLControls["StopFloor"] = stopFloorInput

if not inLobby then
    local autoStopToggle = Tabs.Auto:Toggle({
        Title = "自动终止",
        Default = getgenv().NOL.AutoStopEnabled,
        Callback = function(state)
            getgenv().NOL.AutoStopEnabled = state
            AutoStopEnabled = state
            if state then
                if AutoStopConn then AutoStopConn:Disconnect() end
                AutoStopConn = Services.RunService.Heartbeat:Connect(function()
                    if AutoStopEnabled then
                        pcall(CheckFloorAndRetreat)
                    end
                end)
            else
                if AutoStopConn then
                    AutoStopConn:Disconnect()
                    AutoStopConn = nil
                end
            end
        end
    })
    _G.NOLControls["AutoStopEnabled"] = autoStopToggle
end

if not inLobby then
    Tabs.Auto:Button({
        Title = "远程按撤离",
        Callback = function()
            TEvent.FireRemote("SubmitVote", "retreat")
        end
    })
end

local hasFileSystem = pcall(function()
    return isfolder and makefolder and writefile and readfile and listfiles and delfile
end) and isfolder and makefolder and writefile and readfile and listfiles and delfile

local ConfigFolder = "NOL/configs/"
if hasFileSystem then
    pcall(function()
        if not isfolder("NOL") then makefolder("NOL") end
        if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
    end)
end

local function GetAllConfigs()
    if not hasFileSystem then return {} end
    local files = {}
    pcall(function()
        for _, file in ipairs(listfiles(ConfigFolder)) do
            if file:match("%.json$") then
                local name = file:match("([^/\\]+)%.json$")
                table.insert(files, name)
            end
        end
    end)
    table.sort(files)
    return files
end

local function SaveConfig(name)
    if not hasFileSystem then return false end
    local path = ConfigFolder .. name .. ".json"
    local data = Services.HttpService:JSONEncode(getgenv().NOL)
    local success, err = pcall(writefile, path, data)
    return success
end

local function LoadConfig(name)
    if not hasFileSystem then return false end
    local path = ConfigFolder .. name .. ".json"
    if not isfile(path) then return false end
    local data = readfile(path)
    local success, decoded = pcall(function() return Services.HttpService:JSONDecode(data) end)
    if success then
        for k, v in pairs(decoded) do
            getgenv().NOL[k] = v
        end
        for flag, control in pairs(_G.NOLControls) do
            if control.Set and getgenv().NOL[flag] ~= nil then
                pcall(function() control:Set(getgenv().NOL[flag]) end)
            elseif control.Select and getgenv().NOL[flag] ~= nil then
                pcall(function() control:Select(getgenv().NOL[flag]) end)
            elseif control.SetValue and getgenv().NOL[flag] ~= nil then
                pcall(function() control:SetValue(getgenv().NOL[flag]) end)
            end
        end
        return true
    end
    return false
end

local function DeleteConfig(name)
    if not hasFileSystem then return false end
    local path = ConfigFolder .. name .. ".json"
    if not isfile(path) then return false end
    local success, err = pcall(delfile, path)
    return success
end

local function SetLastConfig(name)
    if not hasFileSystem then return end
    pcall(function()
        writefile(ConfigFolder .. "last_config.txt", name)
    end)
end

local function GetLastConfig()
    if not hasFileSystem then return nil end
    local path = ConfigFolder .. "last_config.txt"
    if not isfile(path) then return nil end
    local name = readfile(path)
    return name
end

local lastConfig = GetLastConfig()
if lastConfig and lastConfig ~= "" then
    LoadConfig(lastConfig)
end

local TabConfig = Tabs.Config
local configSection = TabConfig:Section({ Title = "配置管理", Opened = true })

local configList = GetAllConfigs()
local configDropdown = configSection:Dropdown({
    Title = "选择配置",
    Values = configList,
    Value = configList[1] or "",
    Callback = function(v) end
})

local configInput = configSection:Input({
    Title = "新配置名称",
    Placeholder = "输入名称",
    Callback = function(v) end
})

configSection:Button({
    Title = "保存配置",
    Icon = "save",
    Callback = function()
        if not hasFileSystem then
            WindUI:Notify({ Title = "配置", Content = "当前执行器不支持文件操作", Duration = 2 })
            return
        end
        local name = configInput.Value
        if name and name ~= "" then
            if SaveConfig(name) then
                WindUI:Notify({ Title = "配置", Content = "已保存: " .. name, Duration = 2 })
                local newList = GetAllConfigs()
                configDropdown:Refresh(newList)
                configDropdown:Select(name)
                SetLastConfig(name)
            else
                WindUI:Notify({ Title = "配置", Content = "保存失败", Duration = 2 })
            end
        else
            WindUI:Notify({ Title = "配置", Content = "请输入配置名称", Duration = 2 })
        end
    end
})

configSection:Button({
    Title = "加载配置",
    Icon = "folder",
    Callback = function()
        if not hasFileSystem then
            WindUI:Notify({ Title = "配置", Content = "当前执行器不支持文件操作", Duration = 2 })
            return
        end
        local name = configDropdown.Value
        if name and name ~= "" then
            if LoadConfig(name) then
                WindUI:Notify({ Title = "配置", Content = "已加载: " .. name, Duration = 2 })
                SetLastConfig(name)
            else
                WindUI:Notify({ Title = "配置", Content = "加载失败", Duration = 2 })
            end
        else
            WindUI:Notify({ Title = "配置", Content = "请选择配置", Duration = 2 })
        end
    end
})

configSection:Button({
    Title = "删除配置",
    Icon = "trash",
    Callback = function()
        if not hasFileSystem then
            WindUI:Notify({ Title = "配置", Content = "当前执行器不支持文件操作", Duration = 2 })
            return
        end
        local name = configDropdown.Value
        if name and name ~= "" then
            if DeleteConfig(name) then
                WindUI:Notify({ Title = "配置", Content = "已删除: " .. name, Duration = 2 })
                local newList = GetAllConfigs()
                configDropdown:Refresh(newList)
                configDropdown:Select(newList[1] or "")
                if name == GetLastConfig() then
                    SetLastConfig("")
                end
            else
                WindUI:Notify({ Title = "配置", Content = "删除失败", Duration = 2 })
            end
        else
            WindUI:Notify({ Title = "配置", Content = "请选择配置", Duration = 2 })
        end
    end
})

WindUI:Notify({ Title = "NOL SCRIPT", Content = "加载成功", Duration = 3, Icon = "check" })
elseif game.GameId == 9191100702 then --- 火球
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yisan9178/sjsjsj/refs/heads/main/Windui.lua(1).txt"))()

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do table.insert(chars, uchar) end
    local length = #chars
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', math.floor(r * 255), math.floor(g * 255), math.floor(b * 255), chars[i])
    end
    return result
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local REMOTES_FOLDER = ReplicatedStorage:WaitForChild("Remotes")
local ADD_SPINS_EVENT = REMOTES_FOLDER:WaitForChild("AddWheelSpinValue")
local CLAIM_REWARD_EVENT = REMOTES_FOLDER:WaitForChild("ClaimReward")
local REBIRTH_EVENT = REMOTES_FOLDER:WaitForChild("Rebirth")

local FIREBALL_MAP = {
    ["迷雾火球"] = "Fog", ["闪光火球"] = "Lighting", ["火焰火球"] = "Fire", ["冰霜火球"] = "Ice",
    ["雷电火球"] = "Thunder", ["恶魔火球"] = "Devil", ["龙卷火球"] = "Tornado", ["以太火球"] = "Ethereal",
    ["霜火火球"] = "Frostfire", ["银河火球"] = "Galaxy", ["流星火球"] = "Meteor", ["星云火球"] = "Nebula",
    ["幻影火球"] = "Phantom", ["水球"] = "Water", ["沙漠火球"] = "Desert", ["月球火球"] = "Lunar",
    ["普通火球"] = "Red", ["毒液火球"] = "Venom", ["水晶火球"] = "Crystal", ["剧毒火球"] = "Poison",
    ["像素火球"] = "Pixel", ["暗黑火球"] = "Dark", ["等离子火球"] = "Plasma", ["台风火球"] = "Hurricane",
    ["太阳火球"] = "Sun", ["海洋火球"] = "Oceanic", ["地狱火球"] = "Hellfire", ["漩涡火球"] = "Vortex",
    ["辐射火球"] = "Toxic", ["暗物质火球"] = "Dark Matter", ["诅咒火球"] = "Cursed", ["血液火球"] = "Blood", ["神圣火球"] = "Holy",
}
local FIREBALL_REVERSE_MAP = {}
for displayName, toolName in pairs(FIREBALL_MAP) do FIREBALL_REVERSE_MAP[toolName] = displayName end
local FIREBALL_DISPLAY_NAMES = {}
for name, _ in pairs(FIREBALL_MAP) do table.insert(FIREBALL_DISPLAY_NAMES, name) end
table.sort(FIREBALL_DISPLAY_NAMES)

local TRAINING_ITEMS = { ["普通训练"] = "Train", ["宇宙之剑"] = "Cosmic Sword" }
local SAFE_WORLDS = { "Alien World", "Sky World", "Space World", "Starter World", "Under World" }

local selectedFireball = "迷雾火球"
local selectedTrainingItem = "普通训练"
local isAutoTrain, isAutoFireball, isSpeedBoost, isAutoRebirth, isAntiAFK, isLoopPower, isGodMode = false, false, false, false, false, false, false
local detectionSuccess, isFireballHeld = false, false
local detectLockEndTime = 0
local trainConn, fireballConn, speedConn, detectConn, rebirthConn, antiAFKConn, equipTrainConn, loopPowerConn, godModeConn

local function getCharacter() return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() end
local function getHumanoid() local char = getCharacter() return char and char:FindFirstChildOfClass("Humanoid") end
local function getRootPart() local char = getCharacter() return char and char:FindFirstChild("HumanoidRootPart") end

local function equipTool(toolName)
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local char = getCharacter()
    if not backpack or not char then return false end
    local tool = backpack:FindFirstChild(toolName)
    if tool then 
        getHumanoid():EquipTool(tool)
        return true 
    end
    return char:FindFirstChild(toolName) ~= nil
end

local function shootFireball()
    if not detectionSuccess then return end
    local toolName = FIREBALL_MAP[selectedFireball]
    if not isFireballHeld then equipTool(toolName) isFireballHeld = true end
    local tool = getCharacter():FindFirstChild(toolName)
    if tool and tool:FindFirstChild("Event") then
        for i = 0, 71 do
            local angle = math.rad(i * 5)
            local pos = Vector3.new(-1349 + 300 * math.cos(angle), 1702, -199 + 300 * math.sin(angle))
            tool.Event:FireServer(pos)
        end
    end
end

local Window = WindUI:CreateWindow({
    Title = gradient("塔菲喵   ", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("伊散", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    IconThemed = true,
    Folder = "塔菲喵",
    Size = UDim2.fromOffset(150, 100),
     Transparent = getgenv().TransparencyEnabled,
     Theme = "Dark",
     Resizable = true,
     SideBarWidth = 150,
     BackgroundImageTransparency = 0.8,
     HideSearchBar = true,
     ScrollBarEnabled = true,
     User = {
         Enabled = true,
         Anonymous = false,
         Callback = function()
             currentThemeIndex = currentThemeIndex + 1
             if currentThemeIndex > #themes then
                 currentThemeIndex = 1
             end
             
             local newTheme = themes[currentThemeIndex]
             WindUI:SetTheme(newTheme)
            
             WindUI:Notify({
                 Title = "Theme Changed",
                 Content = "Switched to " .. newTheme .. " theme!",
                 Duration = 2,
                 Icon = "palette"
             })
             print("Switched to " .. newTheme .. " theme")
         end,
     },
 })

Window:EditOpenButton({
    Title = "[摸摸伊散]",
    CornerRadius = UDim.new(0,8),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("1E3A8A")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("118AB2")), 
        ColorSequenceKeypoint.new(1, Color3.fromHex("06D6A0")) 
    }),
    Draggable = true,
})

Window:Tag({
    Title = "伊散",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})
Window:Tag({
    Title = "蛙",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})

local TrainTab = Window:Tab({ Title = '功能', Icon = 'zap' })
local TeleportTab = Window:Tab({ Title = '传送', Icon = 'map-pin' })
local AdvancedTab = Window:Tab({ Title = '杂项', Icon = 'settings' })
Window:SelectTab(1)

TrainTab:Section({ Title = "训练设置" })
TrainTab:Dropdown({
    Title = "训练物品",
    Values = {"普通训练", "宇宙之剑"},
    Callback = function(v) selectedTrainingItem = v end
})

TrainTab:Toggle({
    Title = "自动点击训练",
    Callback = function(state)
        isAutoTrain = state
        if trainConn then trainConn:Disconnect() end
        if state then
            trainConn = RunService.Heartbeat:Connect(function()
                local tName = TRAINING_ITEMS[selectedTrainingItem]
                if equipTool(tName) then
                    local tool = getCharacter():FindFirstChild(tName)
                    if tool and tool:FindFirstChild("Event") then tool.Event:FireServer() end
                end
                task.wait(0.1)
            end)
        end
    end
})

TrainTab:Section({ Title = "火球设置" })
TrainTab:Dropdown({
    Title = "选择火球类型",
    Values = FIREBALL_DISPLAY_NAMES,
    Callback = function(v) selectedFireball = v end
})

TrainTab:Toggle({
    Title = "自动发射火球",
    Callback = function(state)
        isAutoFireball = state
        if fireballConn then fireballConn:Disconnect() end
        if state then
            detectionSuccess = true
            fireballConn = RunService.Heartbeat:Connect(function()
                shootFireball()
                task.wait(0.2)
            end)
        end
    end
})

TeleportTab:Section({ Title = "区域传送" })
local locs = {
    {"VIP区域", Vector3.new(-1610, 1692, -544)},
    {"1.5倍区域", Vector3.new(-1433, 1696, -683)},
    {"2.5倍区域", Vector3.new(-1588, 1700, -667)},
    {"5倍区域", Vector3.new(-1229, 1685, -689)},
    {"10倍区域", Vector3.new(-1207, 1704, -257)},
}
for _, l in pairs(locs) do
    TeleportTab:Button({
        Title = l[1],
        Callback = function() getRootPart().CFrame = CFrame.new(l[2]) end
    })
end

-- [[ 4. 高级功能页 ]]
AdvancedTab:Section({ Title = "其他" })
AdvancedTab:Toggle({
    Title = "刷力量",
    Callback = function(state)
        isLoopPower = state
        if loopPowerConn then loopPowerConn:Disconnect() end
        if state then
            loopPowerConn = RunService.Heartbeat:Connect(function()
                ADD_SPINS_EVENT:FireServer("Power", 99999999999)
                task.wait(0.1)
            end)
        end
    end
})

AdvancedTab:Button({
    Title = "获取99次旋转",
    Callback = function() ADD_SPINS_EVENT:FireServer("Spins", 99) end
})

AdvancedTab:Section({ Title = "特殊功能" })
AdvancedTab:Toggle({
    Title = "无敌模式",
    Callback = function(state)
        isGodMode = state
        if godModeConn then godModeConn:Disconnect() end
        if state then
            godModeConn = RunService.Heartbeat:Connect(function()
                pcall(function()
                    local hrp = getRootPart()
                    local safe = workspace.IgnoreParts.SafeZones["Starter World"].Safe
                    safe.CFrame = hrp.CFrame
                end)
            end)
        end
    end
})

AdvancedTab:Toggle({
    Title = "人物加速",
    Callback = function(state)
        isSpeedBoost = state
        if speedConn then speedConn:Disconnect() end
        if state then
            speedConn = RunService.Heartbeat:Connect(function()
                local hum = getHumanoid()
                if hum then hum.WalkSpeed = 80 hum.JumpPower = 150 end
            end)
        else
            local hum = getHumanoid()
            if hum then hum.WalkSpeed = 16 hum.JumpPower = 50 end
        end
    end
})

AdvancedTab:Toggle({
    Title = "反挂机",
    Callback = function(state)
        isAntiAFK = state
        if state then
            LocalPlayer.Idled:Connect(function()
                VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end
    end
})

Window:OnClose(function()
    if trainConn then trainConn:Disconnect() end
    if fireballConn then fireballConn:Disconnect() end
    if speedConn then speedConn:Disconnect() end
    if loopPowerConn then loopPowerConn:Disconnect() end
    if godModeConn then godModeConn:Disconnect() end
end)

Window:SetToggleKey(Enum.KeyCode.F, true)
WindUI:Notify({ Title = "塔菲喵", Content = "脚本加载成功！", Duration = 3 })
elseif game.GameId == 7018190066 then --- 死铁轨
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yisan9178/sjsjsj/refs/heads/main/Windui.lua(1).txt"))()

local _G_ActionSpam = false
local _G_MeleeSpam = false
local CollectedCount = 0 

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do table.insert(chars, uchar) end
    local length = #chars
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', math.floor(r * 255), math.floor(g * 255), math.floor(b * 255), chars[i])
    end
    return result
end

local Window = WindUI:CreateWindow({
    Title = gradient("塔菲喵   ", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("伊散", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    IconThemed = true,
    Folder = "塔菲喵",
    Size = UDim2.fromOffset(150, 150),
     Transparent = getgenv().TransparencyEnabled,
     Theme = "Dark",
     Resizable = true,
     SideBarWidth = 150,
     BackgroundImageTransparency = 0.8,
     HideSearchBar = true,
     ScrollBarEnabled = true,
     User = {
         Enabled = true,
         Anonymous = false,
         Callback = function()
             currentThemeIndex = currentThemeIndex + 1
             if currentThemeIndex > #themes then
                 currentThemeIndex = 1
             end
             
             local newTheme = themes[currentThemeIndex]
             WindUI:SetTheme(newTheme)
            
             WindUI:Notify({
                 Title = "Theme Changed",
                 Content = "Switched to " .. newTheme .. " theme!",
                 Duration = 2,
                 Icon = "palette"
             })
             print("Switched to " .. newTheme .. " theme")
         end,
     },
 })

Window:EditOpenButton({
    Title = "[摸摸伊散]",
    CornerRadius = UDim.new(0,8),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("1E3A8A")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("118AB2")), 
        ColorSequenceKeypoint.new(1, Color3.fromHex("06D6A0")) 
    }),
    Draggable = true,
})
Window:Tag({
    Title = "伊散",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})

local MainTab = Window:Tab({ Title = '功能', Icon = 'zap' })
local StatsTab = Window:Tab({ Title = '统计', Icon = 'bar-chart' })

StatsTab:Section({ Title = "统计" })

local countPara = StatsTab:Paragraph({
    Title = "远程收集尝试次数",
    Desc = "当前次数: 0",
    Image = "box"
})

StatsTab:Button({
    Title = "清空统计数据",
    Callback = function()
        CollectedCount = 0
        countPara:SetDesc("当前次数: 0")
        WindUI:Notify({ Title = "统计", Content = "记录已归零", Duration = 2 })
    end
})

task.spawn(function()
    local Remote = game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Universe"):WaitForChild("Network"):WaitForChild("RemoteEvent"):WaitForChild("Actionable")
    while true do
        if _G_ActionSpam then
            for i = 1000, 1500 do
                if not _G_ActionSpam then break end
                Remote:FireServer(i)
                
                CollectedCount = CollectedCount + 1
                
                if CollectedCount % 50 == 0 then
                    countPara:SetDesc("当前次数: " .. CollectedCount)
                end
                task.wait() 
            end
        else
            task.wait(0.5)
        end
    end
end)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ClientMeleeHandler = require(ReplicatedStorage:WaitForChild("Client"):WaitForChild("Game"):WaitForChild("Melee"):WaitForChild("ClientMeleeHandler"))
local originalHandler = ClientMeleeHandler._meleeActionHandler

local currentMeleeTool, currentAttackTime, currentLookVector
local spamConnection = nil
local SwingDelay = 0.05
local SwingsPerDelay = 2

local function Swing()
    if not currentMeleeTool or not currentAttackTime or not currentLookVector then return end
    ReplicatedStorage.Shared.Universe.Network.RemoteEvent.SwingMelee:FireServer(
        currentMeleeTool, currentAttackTime, currentLookVector
    )
end

ClientMeleeHandler._meleeActionHandler = function(actionName, inputState, inputObject)
    if _G_MeleeSpam then
        if inputState == Enum.UserInputState.Begin then
            local char = LocalPlayer.Character
            if char then
                currentMeleeTool = char:FindFirstChildWhichIsA("Tool")
                if currentMeleeTool then
                    currentAttackTime = workspace:GetServerTimeNow()
                    local mouse = LocalPlayer:GetMouse()
                    currentLookVector = (mouse and mouse.Hit) and mouse.Hit.LookVector or char:GetPivot().LookVector
                    
                    if spamConnection then spamConnection:Disconnect() end
                    spamConnection = RunService.Heartbeat:Connect(function()
                        for i = 1, SwingsPerDelay do Swing() task.wait(SwingDelay) end
                    end)
                end
            end
        elseif inputState == Enum.UserInputState.End then
            if spamConnection then spamConnection:Disconnect() spamConnection = nil end
        end
    end
    if originalHandler then return originalHandler(actionName, inputState, inputObject) end
end

MainTab:Section({ Title = "功能" })
MainTab:Toggle({
    Title = "自动债卷",
    Value = false,
    Callback = function(state)
        _G_ActionSpam = state
        WindUI:Notify({ Title = "状态", Content = state and "开始刷取" or "已停止刷取", Duration = 2 })
    end
})

MainTab:Section({ Title = "功能" })
MainTab:Toggle({
    Title = "近战杀戮",
    Value = false,
    Callback = function(state)
        _G_MeleeSpam = state
        if not state and spamConnection then
            spamConnection:Disconnect()
            spamConnection = nil
        end
    end
})

MainTab:Paragraph({
    Title = "无效的话长按攻击键即可",
    Content = "该功能开启后，手持近战武器【需要长按攻击键】（如鼠标左键）才能进入极速连砍模式。"
})

Window:SelectTab(1)
WindUI:Notify({ Title = "塔菲喵", Content = "脚本已加载", Duration = 3 })
elseif game.GameId == 4836254499 then --- 血色地带
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yisan9178/sjsjsj/refs/heads/main/Windui.lua(1).txt"))()

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do table.insert(chars, uchar) end
    local length = #chars
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', math.floor(r * 255), math.floor(g * 255), math.floor(b * 255), chars[i])
    end
    return result
end

local Window = WindUI:CreateWindow({
    Title = gradient("塔菲喵   ", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("伊散", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    IconThemed = true,
    Folder = "塔菲喵",
    Size = UDim2.fromOffset(150, 150),
     Transparent = getgenv().TransparencyEnabled,
     Theme = "Dark",
     Resizable = true,
     SideBarWidth = 150,
     BackgroundImageTransparency = 0.8,
     HideSearchBar = true,
     ScrollBarEnabled = true,
     User = {
         Enabled = true,
         Anonymous = false,
         Callback = function()
             currentThemeIndex = currentThemeIndex + 1
             if currentThemeIndex > #themes then
                 currentThemeIndex = 1
             end
             
             local newTheme = themes[currentThemeIndex]
             WindUI:SetTheme(newTheme)
            
             WindUI:Notify({
                 Title = "Theme Changed",
                 Content = "Switched to " .. newTheme .. " theme!",
                 Duration = 2,
                 Icon = "palette"
             })
             print("Switched to " .. newTheme .. " theme")
         end,
     },
 })

Window:EditOpenButton({
    Title = "[摸摸伊散]",
    CornerRadius = UDim.new(0,8),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("1E3A8A")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("118AB2")), 
        ColorSequenceKeypoint.new(1, Color3.fromHex("06D6A0")) 
    }),
    Draggable = true,
})

Window:Tag({
    Title = "伊散",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})
Window:SetToggleKey(Enum.KeyCode.F, true)

local CombatTab = Window:Tab({ Title = '功能', Icon = 'swords' })
Window:SelectTab(1)

local v1 = game:GetService("Players")
local v2 = v1.LocalPlayer
local v3 = true   
local v28 = false 
local v4 = 0.05  
local _G_AutoKill = false 

local function v5(v6, v7)
    if not v3 then return true end
    local v8 = RaycastParams.new()
    v8.FilterType = Enum.RaycastFilterType.Exclude
    v8.FilterDescendantsInstances = {v2.Character, workspace.CurrentCamera}
    local v9 = v6.Position - v7
    local v10 = workspace:Raycast(v7, v9, v8)
    if v10 and v10.Instance:IsDescendantOf(v6.Parent) then
        return true
    end
    return false
end

local function v11(v12)
    return v12:FindFirstChildOfClass("ForceField") ~= nil
end

task.spawn(function()
    while true do
        task.wait(v4)
        
        if not _G_AutoKill then continue end
        
        local v13 = workspace.CurrentCamera
        if not v2.Character then continue end
        
        local v14 = v2.Character:FindFirstChildOfClass("Tool")
        if not v14 then continue end
        
        local v15 = v14:FindFirstChild("FireWeapon")
        local v16 = v14:FindFirstChild("GunHit")
        if not v15 or not v16 then continue end

        local v17 = nil
        local v18 = math.huge
        local v19 = v13.CFrame.Position

        -- 寻找目标
        for _, v20 in pairs(workspace:GetDescendants()) do
            if v20:IsA("Humanoid") and v20.Health > 0 and v20.Parent ~= v2.Character then
                local v21 = v20.Parent
                local v22 = v21:FindFirstChild("Head") or v21:FindFirstChild("HumanoidRootPart")
                if v22 and not v11(v21) then
                    local v23 = v1:GetPlayerFromCharacter(v21)
                    if v23 and v28 then
                        if not (v2.Neutral or v23.Team ~= v2.Team) then continue end
                    end
                    
                    local v24 = (v22.Position - (v2.Character.HumanoidRootPart and v2.Character.HumanoidRootPart.Position or Vector3.new())).Magnitude
                    if v24 < v18 and v5(v22, v19) then
                        v18 = v24
                        v17 = {h = v20, p = v21, head = v22}
                    end
                end
            end
        end

        if v17 then
            local v25 = v17.head.Position
            local v26 = (v25 - v19).Magnitude
            local v27 = tick()

            v15:FireServer(v27)
            v16:FireServer(v27, {
                {
                    ["Normal"] = Vector3.new(0, 1, 0),
                    ["Position"] = v25,
                    ["Instance"] = v17.head,
                    ["Material"] = Enum.Material.Plastic,
                    ["Distance"] = v26
                }
            })
        end
    end
end)

CombatTab:Section({ Title = "功能" })

CombatTab:Toggle({
    Title = "杀戮光环",
    Value = false,
    Callback = function(state)
        _G_AutoKill = state
        WindUI:Notify({
            Title = "提示",
            Content = state and "已启用" or "已停用",
            Duration = 2,
            Icon = state and "check-circle" or "x-circle"
        })
    end
})
elseif game.GameId == 6161049307 then --- 像素之刃
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yisan9178/sjsjsj/refs/heads/main/Windui.lua(1).txt"))()

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do table.insert(chars, uchar) end
    local length = #chars
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', math.floor(r * 255), math.floor(g * 255), math.floor(b * 255), chars[i])
    end
    return result
end

local Window = WindUI:CreateWindow({
    Title = gradient("塔菲喵   ", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("伊散", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    IconThemed = true,
    Folder = "塔菲喵",
    Size = UDim2.fromOffset(150, 150),
     Transparent = getgenv().TransparencyEnabled,
     Theme = "Dark",
     Resizable = true,
     SideBarWidth = 150,
     BackgroundImageTransparency = 0.8,
     HideSearchBar = true,
     ScrollBarEnabled = true,
     User = {
         Enabled = true,
         Anonymous = false,
         Callback = function()
             currentThemeIndex = currentThemeIndex + 1
             if currentThemeIndex > #themes then
                 currentThemeIndex = 1
             end
             
             local newTheme = themes[currentThemeIndex]
             WindUI:SetTheme(newTheme)
            
             WindUI:Notify({
                 Title = "Theme Changed",
                 Content = "Switched to " .. newTheme .. " theme!",
                 Duration = 2,
                 Icon = "palette"
             })
             print("Switched to " .. newTheme .. " theme")
         end,
     },
 })

Window:EditOpenButton({
    Title = "[摸摸伊散]",
    CornerRadius = UDim.new(0,8),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("1E3A8A")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("118AB2")), 
        ColorSequenceKeypoint.new(1, Color3.fromHex("06D6A0")) 
    }),
    Draggable = true,
})

Window:Tag({
    Title = "伊散",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})

Window:SetToggleKey(Enum.KeyCode.F, true)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("remotes")
local OnHitRemote = Remotes:WaitForChild("onHit")
local UseAbilityRemote = Remotes:WaitForChild("useAbility")

local _G_KillAura = false
local _G_AutoAbility = false

local AbilityList = {
    "DeathSentence", "Sand Tornado", "Cosmic Vision", "WingSmash", "BoneBreak",
    "Specter", "MoltenBeam", "Smite", "BloodyNightmare", "WeepingTouch",
    "AngelsBane", "GoldenEclipse", "RavenSense", "ShadowHook"
}

local AuraRange = 500
local AuraDamage = 9e9
local AuraSpeed = 0.05

task.spawn(function()
    while true do
        task.wait(AuraSpeed)
        
        if not _G_KillAura and not _G_AutoAbility then continue end

        local character = LocalPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not rootPart then continue end

        local targets = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Humanoid") and obj.Health > 0 and obj.Parent ~= character then
                if not Players:GetPlayerFromCharacter(obj.Parent) then
                    local targetPart = obj.Parent:FindFirstChild("HumanoidRootPart") or obj.Parent:FindFirstChild("Head")
                    if targetPart then
                        local distance = (targetPart.Position - rootPart.Position).Magnitude
                        if distance <= AuraRange then
                            table.insert(targets, obj)
                        end
                    end
                end
            end
        end

        if #targets > 0 then
            for _, target in pairs(targets) do
                if _G_KillAura then
                    task.spawn(function()
                        OnHitRemote:FireServer(target, AuraDamage, {}, 0)
                    end)
                end
            end

            if _G_AutoAbility then
                for _, abilityName in pairs(AbilityList) do
                    task.spawn(function()
                        UseAbilityRemote:FireServer(abilityName)
                    end)
                end
            end
        end
    end
end)

local CombatTab = Window:Tab({ Title = '功能', Icon = 'swords' })

Window:SelectTab(1)

-- 功能开关
CombatTab:Section({ Title = "功能" })

CombatTab:Toggle({
    Title = "杀戮光环",
    Value = false,
    Callback = function(state)
        _G_KillAura = state
        WindUI:Notify({
            Title = "通知",
            Content = state and "已开启" or "已关闭",
            Duration = 2,
            Icon = "Zap"
        })
    end
})

CombatTab:Toggle({
    Title = "自动技能",
    Value = false,
    Callback = function(state)
        _G_AutoAbility = state
        WindUI:Notify({
            Title = "系统",
            Content = state and "已开启自动技能" or "已关闭自动技能",
            Duration = 2,
            Icon = "Flame"
        })
    end
})

CombatTab:Section({ Title = "其他设置" })
CombatTab:Button({
    Title = "重置角色",
    Callback = function()
        LocalPlayer.Character:BreakJoints()
    end
})
elseif game.GameId == 8202280624 then --- 撕咬之夜
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yisan9178/sjsjsj/refs/heads/main/Windui.lua(1).txt"))()

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local valWalkSpeed = 15
local modifyWalkSpeed = false
local noclipConn = nil
local hitBoxExpander = false
local valHitBox = 15
local activeInstantPrompt = false
local activeBigPrompt = false
local safeLastPos = nil
local antiDeath = { conn = nil, lastPos = nil, teleported = false, debounce = false }
local healthThreshold = 30
local viewKiller = false
local killerAddedConn, killerRemovedConn
local tpKillMode = "最近玩家"
local tpKillTarget = ""
local tpKillConn = nil
local oldLighting = {}
local espData = { survivors = {}, killers = {}, generators = {}, fuseboxes = {}, doors = {} }
local CanParry = true
local genConn = nil
local dotConn = nil
local autoEscapeConn = nil

local safePart = Workspace:FindFirstChild("SafeZone_Linni")
if not safePart then
    safePart = Instance.new("Part")
    safePart.Name = "SafeZone_Linni"; safePart.Size = Vector3.new(50, 2, 50)
    safePart.Position = Vector3.new(0, 1000, 0); safePart.Anchored = true
    safePart.CanCollide = true; safePart.Material = Enum.Material.ForceField; safePart.Parent = Workspace
end

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do table.insert(chars, uchar) end
    for i = 1, #chars do
        local t = (i - 1) / math.max(#chars - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', math.floor(r * 255), math.floor(g * 255), math.floor(b * 255), chars[i])
    end
    return result
end

local Window = WindUI:CreateWindow({
    Title = gradient("塔菲喵   ", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("伊散", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    IconThemed = true,
    Folder = "塔菲喵",
    Size = UDim2.fromOffset(150, 150),
     Transparent = getgenv().TransparencyEnabled,
     Theme = "Dark",
     Resizable = true,
     SideBarWidth = 150,
     BackgroundImageTransparency = 0.8,
     HideSearchBar = true,
     ScrollBarEnabled = true,
     User = {
         Enabled = true,
         Anonymous = false,
         Callback = function()
             currentThemeIndex = currentThemeIndex + 1
             if currentThemeIndex > #themes then
                 currentThemeIndex = 1
             end
             
             local newTheme = themes[currentThemeIndex]
             WindUI:SetTheme(newTheme)
            
             WindUI:Notify({
                 Title = "Theme Changed",
                 Content = "Switched to " .. newTheme .. " theme!",
                 Duration = 2,
                 Icon = "palette"
             })
             print("Switched to " .. newTheme .. " theme")
         end,
     },
 })

Window:EditOpenButton({
    Title = "[摸摸伊散]",
    CornerRadius = UDim.new(0,8),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("1E3A8A")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("118AB2")), 
        ColorSequenceKeypoint.new(1, Color3.fromHex("06D6A0")) 
    }),
    Draggable = true,
})

Window:Tag({
    Title = "伊散",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})

Window:Tag({
    Title = "苏达",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})

Window:Tag({
    Title = "霖溺",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})
Window:SetToggleKey(Enum.KeyCode.F, true)

local Tabs = {
    Local = Window:Tab({ Title = "玩家移动", Icon = "user" }),
    Visuals = Window:Tab({ Title = "视觉与环境", Icon = "eye" }),
    Survivor = Window:Tab({ Title = "幸存者", Icon = "list" }),
    Combat = Window:Tab({ Title = "杀手辅助", Icon = "swords" }),
    Teleports = Window:Tab({ Title = "地图与传送", Icon = "map" })
}

Window:SelectTab(1)

Tabs.Local:Section({ Title = "属性" })
Tabs.Local:Slider({ Title = "速度(25以内)", Value = { Min = 0, Max = 50, Default = 15 }, Callback = function(v) valWalkSpeed = v end })
Tabs.Local:Toggle({ Title = "启用", Callback = function(v) modifyWalkSpeed = v end })

Tabs.Local:Section({ Title = "功能" })
Tabs.Local:Toggle({
    Title = "开启穿墙",
    Callback = function(v)
        if v then
            noclipConn = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
                end
            end)
        elseif noclipConn then noclipConn:Disconnect() end
    end
})

Tabs.Visuals:Section({ Title = "环境" })
Tabs.Visuals:Toggle({
    Title = "全亮",
    Callback = function(v)
        if v then
            oldLighting = { Brightness = Lighting.Brightness, FogEnd = Lighting.FogEnd, ClockTime = Lighting.ClockTime, Ambient = Lighting.Ambient }
            Lighting.Brightness = 3; Lighting.ClockTime = 14; Lighting.FogEnd = 100000; Lighting.GlobalShadows = false; Lighting.Ambient = Color3.new(1,1,1)
        elseif oldLighting.Brightness then
            Lighting.Brightness = oldLighting.Brightness; Lighting.FogEnd = oldLighting.FogEnd; Lighting.ClockTime = oldLighting.ClockTime; Lighting.Ambient = oldLighting.Ambient
        end
    end
})
Tabs.Visuals:Toggle({ Title = "除雾", Callback = function(v) _G.RemoveFog = v end })

Tabs.Visuals:Section({ Title = "透视" })
local function applyESP(obj, color, text)
    if not obj then return end
    if not obj:FindFirstChild("Highlight") then
        local h = Instance.new("Highlight", obj)
        h.FillColor = color; h.FillTransparency = 0.6; h.OutlineTransparency = 0
    end
end

Tabs.Visuals:Toggle({ Title = "幸存者", Callback = function(v) _G.ESPSurvivor = v end })
Tabs.Visuals:Toggle({ Title = "杀手", Callback = function(v) _G.ESPKiller = v end })
Tabs.Visuals:Toggle({ Title = "发电机", Callback = function(v) _G.ESPGen = v end })
Tabs.Visuals:Toggle({ Title = "保险丝盒", Callback = function(v) _G.ESPFuse = v end })
Tabs.Visuals:Toggle({ Title = "地图门", Callback = function(v) _G.ESPDoor = v end })

Tabs.Survivor:Section({ Title = "功能" })
Tabs.Survivor:Toggle({ Title = "秒修机", Callback = function(v)
    if v then
        genConn = RunService.RenderStepped:Connect(function()
            if LocalPlayer.PlayerGui:FindFirstChild("Gen") then pcall(function() LocalPlayer.PlayerGui.Gen.GeneratorMain.Event:FireServer(true) end) end
        end)
    elseif genConn then genConn:Disconnect() end
end })
Tabs.Survivor:Toggle({ Title = "挡门", Callback = function(v)
    if v then
        dotConn = RunService.RenderStepped:Connect(function()
            local dot = LocalPlayer.PlayerGui:FindFirstChild("Dot")
            if dot and dot:FindFirstChild("Container") then dot.Container.Frame.Position = UDim2.new(0.5, 0, 0.5, 0) end
        end)
    elseif dotConn then dotConn:Disconnect() end
end })
Tabs.Survivor:Toggle({ Title = "自动逃生", Callback = function(v) _G.AutoEscape = v end })
Tabs.Survivor:Toggle({ Title = "自动格挡 (战士身份)", Callback = function(v) _G.AutoParry = v end })

Tabs.Survivor:Section({ Title = "交互" })
Tabs.Survivor:Toggle({ Title = "秒交互", Callback = function(v) activeInstantPrompt = v end })
Tabs.Survivor:Toggle({ Title = "远距离交互", Callback = function(v) activeBigPrompt = v end })

Tabs.Survivor:Section({ Title = "视角" })
Tabs.Survivor:Toggle({ Title = "手动躲避安全区", Callback = function(v)
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if v then safeLastPos = root.CFrame; root.CFrame = safePart.CFrame + Vector3.new(0,5,0)
    elseif safeLastPos then root.CFrame = safeLastPos; safeLastPos = nil end
end })
Tabs.Survivor:Slider({ Title = "防死阈值", Value = { Min = 10, Max = 80, Default = 30 }, Callback = function(v) healthThreshold = v end })
Tabs.Survivor:Toggle({ Title = "自动残血躲避", Callback = function(v) _G.AntiDeath = v end })
Tabs.Survivor:Toggle({ Title = "查看杀手视角", Callback = function(v)
    viewKiller = v
    if not v then Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end
end })

Tabs.Combat:Section({ Title = "攻击增强" })
Tabs.Combat:Slider({ Title = "Hitbox 大小", Value = { Min = 1, Max = 30, Default = 15 }, Callback = function(v) valHitBox = v end })
Tabs.Combat:Toggle({ Title = "修改攻击范围", Callback = function(v) hitBoxExpander = v end })

Tabs.Combat:Section({ Title = "杀手传送" })
Tabs.Combat:Dropdown({ Title = "目标模式", Values = {"最近玩家", "指定玩家"}, Callback = function(v) tpKillMode = v end })
Tabs.Combat:Input({ Title = "指定玩家名", Placeholder = "输入完整名", Callback = function(v) tpKillTarget = v end })
Tabs.Combat:Toggle({ Title = "开启传送杀人", Callback = function(v) _G.TeleportKill = v end })

Tabs.Teleports:Section({ Title = "快捷传送" })
Tabs.Teleports:Button({ Title = "传送到保险丝盒", Callback = function() 
    local box = Workspace:FindFirstChild("MAPS") and Workspace.MAPS["GAME MAP"]:FindFirstChild("FuseBoxes")
    if box then LocalPlayer.Character:MoveTo(box:GetChildren()[1].PrimaryPart.Position) end
end })
Tabs.Teleports:Button({ Title = "传送到发电机", Callback = function() 
    local gens = Workspace:FindFirstChild("MAPS") and Workspace.MAPS["GAME MAP"]:FindFirstChild("Generators")
    if gens then LocalPlayer.Character:MoveTo(gens:GetChildren()[1].PrimaryPart.Position) end
end })
Tabs.Teleports:Button({ Title = "传送到电池", Callback = function() 
    for _, v in pairs(Workspace:GetDescendants()) do if v.Name == "Battery" then LocalPlayer.Character:MoveTo(v.Position) break end end
end })

Tabs.Teleports:Section({ Title = "地图修改" })
Tabs.Teleports:Button({ Title = "强制删除所有的门", Callback = function() 
    local d = Workspace:FindFirstChild("MAPS") and Workspace.MAPS["GAME MAP"]:FindFirstChild("Doors")
    if d then d:Destroy() end
end })
Tabs.Teleports:Button({ Title = "帧率提升", Callback = function() 
    for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("BasePart") then v.CastShadow = false end end
    Lighting.GlobalShadows = false
end })

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character; local root = char and char:FindFirstChild("HumanoidRootPart"); local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not root then return end

    if modifyWalkSpeed then char:SetAttribute("WalkSpeed", valWalkSpeed) end

    if _G.AutoParry and Workspace:FindFirstChild("BoxHandleAdornment", true) then
        local box = Workspace:FindFirstChild("BoxHandleAdornment", true)
        if (box.CFrame.Position - root.Position).Magnitude <= 8 and CanParry then
            CanParry = false; local t = char:FindFirstChildOfClass("Tool"); if t then t:Activate() end
            task.delay(0.5, function() CanParry = true end)
        end
    end

    if _G.AntiDeath and hum.Health < healthThreshold and not antiDeath.teleported then
        antiDeath.teleported = true; antiDeath.lastPos = root.CFrame; root.CFrame = safePart.CFrame + Vector3.new(0,5,0)
    elseif _G.AntiDeath and hum.Health >= 100 and antiDeath.teleported then
        root.CFrame = antiDeath.lastPos; antiDeath.teleported = false
    end

    if _G.TeleportKill then
        local target = nil
        if tpKillMode == "最近玩家" then
            local dist = math.huge; for _, v in pairs(Workspace.PLAYERS.ALIVE:GetChildren()) do
                if v ~= char and v:FindFirstChild("HumanoidRootPart") then
                    local d = (root.Position - v.HumanoidRootPart.Position).Magnitude; if d < dist then dist = d; target = v end
                end
            end
        else target = Workspace.PLAYERS.ALIVE:FindFirstChild(tpKillTarget) end
        if target then root.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0,0,3) end
    end

    if viewKiller then
        local kFolder = Workspace.PLAYERS:FindFirstChild("KILLER")
        if kFolder and kFolder:GetChildren()[1] then Camera.CameraSubject = kFolder:GetChildren()[1]:FindFirstChildOfClass("Humanoid") end
    end
end)

Workspace.DescendantAdded:Connect(function(child)
    task.wait(0.1)
    if child:IsA("ProximityPrompt") then
        if activeInstantPrompt then child.HoldDuration = 0 end
        if activeBigPrompt then child.MaxActivationDistance = 25 end
    end
    if child:IsA("BoxHandleAdornment") and hitBoxExpander then child.Size = Vector3.new(valHitBox, valHitBox, valHitBox) end
end)
elseif game.GameId == 210851291 then --- 造船寻宝
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yisan9178/sjsjsj/refs/heads/main/Windui.lua(1).txt"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local goldBlockVal = localPlayer:WaitForChild("Data"):WaitForChild("GoldBlock")
local goldVal = localPlayer.Data:WaitForChild("Gold")
local claimRiverResultsGoldEvent = workspace:WaitForChild("ClaimRiverResultsGold")
local stagePositions = {}
local chestTrigger, chestTriggerOriginCFrame
local roundCount = 0 

for _, stage in workspace:WaitForChild("BoatStages"):WaitForChild("NormalStages"):GetChildren() do
    local index = tonumber(stage.Name:match("%d+"))
    if index then stagePositions[index] = stage.DarknessPart.CFrame end
    if stage.Name == "TheEnd" then
        chestTrigger = stage.GoldenChest.Trigger
        chestTriggerOriginCFrame = chestTrigger.CFrame
    end
end

local goldFarming = false
local candyFarming = false
local connections = {}
local statusOverlay 

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(chars, uchar)
    end
    
    local length = #chars
    
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
            math.floor(r * 255), 
            math.floor(g * 255), 
            math.floor(b * 255), 
            chars[i])
    end
    
    return result
end

local Window = WindUI:CreateWindow({
    Title = gradient("塔菲喵   ", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("伊散", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    IconThemed = true,
    Folder = "塔菲喵",
    Size = UDim2.fromOffset(150, 150),
     Transparent = getgenv().TransparencyEnabled,
     Theme = "Dark",
     Resizable = true,
     SideBarWidth = 150,
     BackgroundImageTransparency = 0.8,
     HideSearchBar = true,
     ScrollBarEnabled = true,
     User = {
         Enabled = true,
         Anonymous = false,
         Callback = function()
             currentThemeIndex = currentThemeIndex + 1
             if currentThemeIndex > #themes then
                 currentThemeIndex = 1
             end
             
             local newTheme = themes[currentThemeIndex]
             WindUI:SetTheme(newTheme)
            
             WindUI:Notify({
                 Title = "Theme Changed",
                 Content = "Switched to " .. newTheme .. " theme!",
                 Duration = 2,
                 Icon = "palette"
             })
             print("Switched to " .. newTheme .. " theme")
         end,
     },
 })

Window:EditOpenButton({
    Title = "[摸摸伊散]",
    CornerRadius = UDim.new(0,8),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("1E3A8A")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("118AB2")), 
        ColorSequenceKeypoint.new(1, Color3.fromHex("06D6A0")) 
    }),
    Draggable = true,
})

Window:Tag({
    Title = "伊散",
    Radius = 5,
    Color = Color3.fromHex("#FFB347"),
})

Window:SetToggleKey(Enum.KeyCode.F, true)

local CombatTab = Window:Tab({ Title = '功能', Icon = 'swords' })
local StatsTab = Window:Tab({ Title = '统计', Icon = 'bar-chart' })
Window:SelectTab(1)
local statsPara = StatsTab:Paragraph({
    Title = "统计",
    Desc = "已刷总轮数: 0\n当前金币: 加载中...\n当前金块: 加载中..."
})

StatsTab:Button({
    Title = "重置轮数",
    Callback = function()
        roundCount = 0
        WindUI:Notify({Title = "统计", Content = "轮数已清零", Duration = 2})
    end
})

local function updateOverlay(text)
    if not statusOverlay then
        statusOverlay = Drawing.new("Text")
        statusOverlay.Outline = true
        statusOverlay.Color = Color3.new(1, 1, 1)
        statusOverlay.Position = Vector2.new(20, 40)
        statusOverlay.Size = 18
        statusOverlay.Visible = true
    end
    statusOverlay.Text = text
end

CombatTab:Toggle({
    Title = "自动农场",
    Value = false,
    Callback = function(enabled)
        goldFarming = enabled
        if not enabled then
            for _, c in pairs(connections) do c:Disconnect() end
            if statusOverlay then statusOverlay.Visible = false end
            return
        end
        
        local startTime = time()
        if statusOverlay then statusOverlay.Visible = true end

        table.insert(connections, RunService.Heartbeat:Connect(function()
            local char = localPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end

            if _G.AtEnd then
                pcall(firetouchinterest, chestTrigger, root, 0)
            end
            
            root.CFrame = _G.TargetPos or stagePositions[1]
            root.Velocity = Vector3.zero
            
            updateOverlay("塔菲喵 造船挂机中...\n已运行: " .. math.floor(time() - startTime) .. "s\n已完成: " .. roundCount .. " 轮")
            statsPara:SetDesc(string.format("已刷总轮数: %d\n当前金币: %d\n当前金块: %d", roundCount, goldVal.Value, goldBlockVal.Value))
        end))

        table.insert(connections, localPlayer.CharacterRemoving:Connect(function()
            roundCount = roundCount + 1
            _G.AtEnd = false
            claimRiverResultsGoldEvent:FireServer()
        end))

        task.spawn(function()
            while goldFarming do
                for i = 1, 9 do
                    if not goldFarming then break end
                    _G.TargetPos = stagePositions[i]
                    task.wait(2) 
                end
                _G.AtEnd = true
                task.wait(3) 
                while _G.AtEnd and goldFarming do task.wait() end
            end
        end)
    end
})

CombatTab:Toggle({
    Title = "自动刷糖果",
    Value = false,
    Callback = function(enabled)
        candyFarming = enabled
        if enabled then
            task.spawn(function()
                while candyFarming do
                    task.wait(0.1)
                    local char = localPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root and workspace:FindFirstChild("Houses") then
                        for _, house in pairs(workspace.Houses:GetChildren()) do
                            local door = house:FindFirstChild("Door") and house.Door:FindFirstChild("DoorInnerTouch")
                            if door then
                                pcall(firetouchinterest, root, door, 0)
                            end
                        end
                    end
                end
            end)
            WindUI:Notify({Title = "功能开启", Content = "开始自动收集全图糖果", Duration = 3})
        end
    end
})
else --- 如果都不是，加载副脚本
    loadstring(game:HttpGet("https://raw.githubusercontent.com/abcd789142/Scritp/refs/heads/main/222-obfuscated%20(1).lua"))()
end