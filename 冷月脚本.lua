local OrionLib = loadstring(game:HttpGet("https://pastebin.com/raw/FUEx0f3G"))()

local ScreenGui = Instance.new("ScreenGui", getParent)
local TimeLabel = Instance.new("TextLabel", getParent)
local LocalPlayer = game.Players.LocalPlayer

ScreenGui.Name = "LBLG"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Enabled = true

TimeLabel.Name = "LBL"
TimeLabel.Parent = ScreenGui
TimeLabel.BackgroundColor3 = Color3.new(1, 1, 1)
TimeLabel.BackgroundTransparency = 1
TimeLabel.BorderColor3 = Color3.new(0, 0, 0)
TimeLabel.Position = UDim2.new(0.75, 0, 0.01, 0)
TimeLabel.Size = UDim2.new(0, 133, 0, 30)
TimeLabel.Font = Enum.Font.GothamSemibold
TimeLabel.Text = "TextLabel"
TimeLabel.TextColor3 = Color3.new(1, 1, 1)
TimeLabel.TextScaled = true
TimeLabel.TextSize = 14
TimeLabel.TextWrapped = true
TimeLabel.Visible = true

local TimeLabelRef = TimeLabel
local Heartbeat = game:GetService("RunService").Heartbeat
local CurrentTick = nil
local StartTick = nil
local FrameTable = {}

local function UpdateFPS()
    CurrentTick = tick()
    for i = #FrameTable, 1, -1 do
        FrameTable[i + 1] = FrameTable[i] >= CurrentTick - 1 and FrameTable[i] or nil
    end
    FrameTable[1] = CurrentTick
    local fps = tick() - StartTick >= 1 and #FrameTable or #FrameTable / (tick() - StartTick)
    local fpsRounded = fps - fps % 1
    TimeLabelRef.Text = "冷月时间:" .. os.date("%H") .. "时" .. os.date("%M") .. "分" .. os.date("%S")
end

StartTick = tick()
Heartbeat:Connect(UpdateFPS)

local MainWindow = OrionLib:MakeWindow({
    Name = "冷月中心",
    HidePremium = false,
    SaveConfig = true,
    IntroText = "冷月脚本",
    ConfigFolder = "冷月中心"
})

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "冷月脚本",
    Text = "冷月脚本",
    Duration = 4
})

local MainTab = MainWindow:MakeTab({
    Name = "冷月制作",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MainTab:AddParagraph("脚本更新内容：飞行")
MainTab:AddParagraph("禁止被圈")

local AnnouncementTab = MainWindow:MakeTab({
    Name = "公告",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

AnnouncementTab:AddButton({
    Name = "复制作者QQ",
    Callback = function()
        setclipboard("825763412")
    end
})

AnnouncementTab:AddButton({
    Name = "复制QQ群",
    Callback = function()
        setclipboard("498865259")
    end
})

MainWindow:MakeTab({
    Name = "隐脚本DOORS2.0",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
}):AddButton({
    Name = "门2.0",
    Callback = function()
        loadstring("loadstring(game:HttpGet(\"https://raw.githubusercontent.com/YSlon/RAW-..a-script/main/%E9%99%88DOORS2.0MOON%E6%B7%B7%E6%B7%86\"))()")()
    end
})

local PlayerTab = MainWindow:MakeTab({
    Name = "玩家",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

PlayerTab:AddSection({
    Name = "欢迎欢迎"
})

PlayerTab:AddSlider({
    Name = "速度",
    Min = 16,
    Max = 200,
    Default = 16,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "数值",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

PlayerTab:AddSlider({
    Name = "跳跃高度",
    Min = 50,
    Max = 200,
    Default = 50,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "数值",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end
})

PlayerTab:AddTextbox({
    Name = "跳跃高度设置",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end
})

PlayerTab:AddTextbox({
    Name = "移动速度设置",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

PlayerTab:AddTextbox({
    Name = "重力设置",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        game.Workspace.Gravity = Value
    end
})

PlayerTab:AddToggle({
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

PlayerTab:AddButton({
    Name = "飞行V3（隐藏）",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/U27yQRxS"))()
    end
})

PlayerTab:AddButton({
    Name = "曾躯",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SkrillexMe/SkrillexLoader/main/SkrillexLoadMain"))()
    end
})

PlayerTab:AddButton({
    Name = "爬墙",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/zXk4Rq2r"))()
    end
})

PlayerTab:AddButton({
    Name = "光影V4",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/MZEEN2424/Graphics/main/Graphics.xml"))()
    end
})

PlayerTab:AddButton({
    Name = "变成蛋",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.ga/tWBTcE4R/raw", true))()
    end
})

PlayerTab:AddButton({
    Name = "让别让别人控制自己",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.ga/a7RTi4un/raw", true))()
    end
})

PlayerTab:AddButton({
    Name = "点击传送工具",
    Callback = function()
        mouse = game.Players.LocalPlayer:GetMouse()
        tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = "[FE] TELEPORT TOOL"
        tool.Activated:connect(function()
            local targetPosition = mouse.Hit + Vector3.new(0, 2.5, 0)
            local newCFrame = CFrame.new(targetPosition.X, targetPosition.Y, targetPosition.Z)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = newCFrame
        end)
        tool.Parent = game.Players.LocalPlayer.Backpack
    end
})

PlayerTab:AddButton({
    Name = "全(英文������)",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/kEq7bdf9"))()
    end
})

PlayerTab:AddButton({
    Name = "地岩",
    Callback = function()
        loadstring("loadstring(game:HttpGet(\"https://raw.githubusercontent.com/bbamxbbamxbbamx/codespaces-blank/main/%E7%99%BD\"))()")()
    end
})

PlayerTab:AddButton({
    Name = "dx旧版本",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/DXuwu/test-lol/main/YO.lua"))()
    end
})

PlayerTab:AddButton({
    Name = "脚本中心",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/gemxHwA1"))()
    end
})

PlayerTab:AddButton({
    Name = "无敌",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        if player.Character:FindFirstChild("Head") then
            local character = player.Character
            character.Archivable = true
            local clonedCharacter = character:Clone()
            clonedCharacter.Parent = workspace
            player.Character = clonedCharacter
            wait(2)
            local humanoid = character:FindFirstChildWhichIsA("Humanoid")
            local humanoidRef = humanoid
            local clonedHumanoid = humanoid:Clone()
            clonedHumanoid.Parent = character
            clonedHumanoid.RequiresNeck = false
            humanoid.Parent = nil
            wait(2)
            player.Character = character
            clonedCharacter:Destroy()
            wait(1)
            local newHumanoid = clonedHumanoid
            clonedHumanoid:GetPropertyChangedSignal("Health"):Connect(function()
                if clonedHumanoid.Health <= 0 then
                    humanoid.Parent = player.Character
                    wait(1)
                    humanoid:Destroy()
                end
            end)
            workspace.CurrentCamera.CameraSubject = character
            if character:FindFirstChild("Animate") then
                character.Animate.Disabled = true
                wait(0.1)
                character.Animate.Disabled = false
            end
            player.Character:FindFirstChild("Head"):Destroy()
        end
    end
})

PlayerTab:AddButton({
    Name = "用飞别人",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/GnvPVBEi"))()
    end
})

PlayerTab:AddButton({
    Name = "防止掉线（反挂机）",
    Callback = function()
        print("Anti Afk On")
        local VirtualUser = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:connect(function()
            VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            wait(1)
            VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)
    end
})

PlayerTab:AddButton({
    Name = "透视",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/MA8jhPWT"))()
    end
})

PlayerTab:AddButton({
    Name = "吸取全部玩家",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/hQSBGsw2"))()
    end
})

PlayerTab:AddButton({
    Name = "人物无敌",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/H3RLCWWZ"))()
    end
})

PlayerTab:AddButton({
    Name = "隐躯(E)",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/nwGEvkez"))()
    end
})

PlayerTab:AddButton({
    Name = "电脑键盘",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/advxzivhsjjdhxhsidifvsh/mobkeyboard/main/main.txt", true))()
    end
})

PlayerTab:AddButton({
    Name = "飞车(E)(别人看到)",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/G3GnBCyC", true))()
    end
})

PlayerTab:AddTextbox({
    Name = "跳跃高度",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end
})

PlayerTab:AddTextbox({
    Name = "重力设置",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        game.Workspace.Gravity = Value
    end
})

PlayerTab:AddToggle({
    Name = "穿墙2",
    Default = false,
    Callback = function(Value)
        if Value then
            Noclip = true
            Stepped = game.RunService.Stepped:Connect(function()
                if Noclip ~= true then
                    Stepped:Disconnect()
                else
                    local iterator, table, index = pairs(game.Workspace:GetChildren())
                    while true do
                        local child
                        index, child = iterator(table, index)
                        if index == nil then
                            break
                        end
                        if child.Name == game.Players.LocalPlayer.Name then
                            local iterator2, table2, index2 = pairs(game.Workspace[game.Players.LocalPlayer.Name]:GetChildren())
                            while true do
                                local part
                                index2, part = iterator2(table2, index2)
                                if index2 == nil then
                                    break
                                end
                                if part:IsA("BasePart") then
                                    part.CanCollide = false
                                end
                            end
                        end
                    end
                end
            end)
        else
            Noclip = false
        end
    end
})

PlayerTab:AddToggle({
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

PlayerTab:AddButton({
    Name = "鼠标（手机非常不建议用）",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.ga/V75mqzaz/raw", true))()
    end
})

PlayerTab:AddButton({
    Name = "飞行",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/U27yQRxS"))()
    end
})

PlayerTab:AddButton({
    Name = "跟踪玩家",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/F9PNLcXk"))()
    end
})

PlayerTab:AddButton({
    Name = "伪名说话",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.ga/zCFEwaYq/raw", true))()
    end
})

PlayerTab:AddButton({
    Name = "踏空行走",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Float"))()
    end
})

PlayerTab:AddButton({
    Name = "透视",
    Callback = function()
        loadstring(game:GetObjects("rbxassetid://10092697033")[1].Source)()
    end
})

PlayerTab:AddButton({
    Name = "轿起来",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/r97d7dS0", true))()
    end
})

PlayerTab:AddButton({
    Name = "隐躯(E)",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/nwGEvkez"))()
    end
})

PlayerTab:AddButton({
    Name = "立即死亡",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.Health = 0
    end
})

PlayerTab:AddButton({
    Name = "黑客脚本",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/BirthScripts/Scripts/main/c00l.lua"))()
    end
})

PlayerTab:AddButton({
    Name = "管理员",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/iK4oS/backdoor.exe/master/source.lua", true))()
    end
})

PlayerTab:AddButton({
    Name = "回滚衙后分服务器可能不可以能用",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.Health = 10000
    end
})

PlayerTab:AddButton({
    Name = "键盘",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/advxzivhsjjdhxhsidifvsh/mobkeyboard/main/main.txt", true))()
    end
})

PlayerTab:AddButton({
    Name = "玩家动作",
    Callback = function()
        getgenv().she = "作者小盛蓝免贵请勿倒卖"
        loadstring(game:HttpGet("https://pastebin.com/raw/Zj4NnKs6"))()
    end
})

local DoorsTab = MainWindow:MakeTab({
    Name = "doors",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

DoorsTab:AddButton({
    Name = "DX夜",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/DXuwu/test-lol/main/YO.lua"))()
    end
})

DoorsTab:AddButton({
    Name = "脚本",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GamingScripter/Darkrai-X/main/Games/Doors"))()
    end
})

DoorsTab:AddButton({
    Name = "超级脚本",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Fazedrab/EntitySpawner/main/doors(orionlib).lua"))()
    end
})

DoorsTab:AddButton({
    Name = "修改",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/sponguss/Doors-Entity-Replicator/main/source.lua"))()
    end
})

DoorsTab:AddButton({
    Name = "广屏doors",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/uHHp8fzS"))()
    end
})

DoorsTab:AddButton({
    Name = "ms覆盖名单",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/zoophiliaphobic/POOPDOORS/main/script.lua"))()
    end
})

DoorsTab:AddButton({
    Name = "我的",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/QsCas0t3"))()
    end
})

DoorsTab:AddButton({
    Name = "云doors",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XiaoYunCN/EntitySpawner/main/doors(orionlib).lua"))()
    end
})

DoorsTab:AddButton({
    Name = "最不强",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/R8QMbhzv"))()
    end
})

DoorsTab:AddButton({
    Name = "白",
    Callback = function()
        _G["白脚本作者修狗"] = "xdjhadgdsrfcyefjhsadcctyseyr6432478rudghfvszhxcaheey"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/wev666666/baijiaobengV2.0beta/main/%E7%99%BD%E8%84%9A%E6%9C%ACbeta", true))()
    end
})

local NinjaLegendsTab = MainWindow:MakeTab({
    Name = "忍者传奇",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

NinjaLegendsTab:AddButton({
    Name = "撸佬妈不知道",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptpastebin/raw/main/1"))()
    end
})

NinjaLegendsTab:AddButton({
    Name = "忍者传奇",
    Callback = function()
        pcall(loadstring(game:HttpGet("https://pastebin.com/raw/2UjrXwTV")))
    end
})

NinjaLegendsTab:AddButton({
    Name = "不知道",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/harisiskandar178/5repo/main/script4.lua"))()
    end
})

local SpeedSimulatorTab = MainWindow:MakeTab({
    Name = "极速传奇",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

SpeedSimulatorTab:AddButton({
    Name = "靖脚本",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/kkaaccnnbb/money/main/fix"))()
    end
})

SpeedSimulatorTab:AddButton({
    Name = "脚本二",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/boyscp/beta/main/%E9%80%9F%E5%BA%A6%E7%82%B8%E8%B5%B7.lua"))()
    end
})

SpeedSimulatorTab:AddButton({
    Name = "脚本三",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TrixAde/Proxima-Hub/main/Main.lua"))()
    end
})

SpeedSimulatorTab:AddButton({
    Name = "剑客v3——roblox加入群主剑客才可用",
    Callback = function()
        jianke_V3 = "作者_初夏"
        jianke = "剑客QQ群347724155"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/jiankeQWQ/jiankeV3/main/jianke_V3"))()
    end
})

local SharkBite2Tab = MainWindow:MakeTab({
    Name = "鲨口求生2",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

SharkBite2Tab:AddDropdown({
    Name = "免贵船只",
    Default = "1",
    Options = {
        "DuckyBoatBeta",
        "DuckyBoat",
        "BlueCanopyMotorboat",
        "BlueWoodenMotorboat",
        "UnicornBoat",
        "Jetski",
        "RedMarlin",
        "Sloop",
        "TugBoat",
        "SmallDinghyMotorboat",
        "JetskiDonut",
        "Marlin",
        "TubeBoat",
        "FishingBoat",
        "VikingShip",
        "SmallWoodenSailboat",
        "RedCanopyMotorboat",
        "Catamaran",
        "CombatBoat",
        "TourBoat",
        "Duckmarine",
        "PartyBoat",
        "MilitarySubmarine",
        "GingerbreadSteamBoat",
        "Sleigh2022",
        "Snowmobile",
        "CruiseShip"
    },
    Callback = function(Value)
        game:GetService("ReplicatedStorage").EventsFolder.BoatSelection.UpdateHostBoat:FireServer(Value)
    end
})

SharkBite2Tab:AddButton({
    Name = "自动杀鲨鱼������",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Sw1ndlerScripts/RobloxScripts/main/Misc%20Scripts/sharkbite2.lua", true))()
    end
})

MainWindow:MakeTab({
    Name = "能量突击",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
}):AddButton({
    Name = "能量突击",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Harley-HUB/Energy-Assault/main/Ene", true))()
    end
})

MainWindow:MakeTab({
    Name = "汽车经销大亨",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
}):AddButton({
    Name = "英文版",
    Callback = function()
        pcall(function()
            repeat
                wait()
            until game:IsLoaded()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/03sAlt/BlueLockSeason2/main/README.md"))()
        end)
    end
})

local FEScriptTab = MainWindow:MakeTab({
    Name = "FE脚本",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

FEScriptTab:AddButton({
    Name = "C00lgui",
    Callback = function()
        loadstring(game:GetObjects("rbxassetid://8127297852")[1].Source)()
    end
})

FEScriptTab:AddButton({
    Name = "1x1x1x1",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/JipYNCht", true))()
    end
})

FEScriptTab:AddButton({
    Name = "动画中心",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GamingScripter/Animation-Hub/main/Animation%20Gui", true))()
    end
})

FEScriptTab:AddButton({
    Name = "幽灵中心",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostPlayer352/Test4/main/GhostHub"))()
    end
})

FEScriptTab:AddButton({
    Name = "蜘蛛侠爬墙配合键盘脚本挂c",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/2X0hKUgq", true))()
    end
})

FEScriptTab:AddButton({
    Name = "遵循打死你",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/0Ben1/fe/main/obf_rf6iQURzu1fqrytcnLBAvW34C9N55kS9g9G3CKz086rC47M6632sEd4ZZYB0AYgV.lua.txt", true))()
    end
})

FEScriptTab:AddButton({
    Name = "声音播放器",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/GEianeKX"))()
    end
})

FEScriptTab:AddButton({
    Name = "NA管理员",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source"))()
    end
})

local ByHandsTab = MainWindow:MakeTab({
    Name = "By手腕",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

ByHandsTab:AddButton({
    Name = "掰手腕",
    Callback = function()
        loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/99d16edc79729a038994f85ce7335971.lua"))()
    end
})

ByHandsTab:AddButton({
    Name = "脚本2——Key:ScriptJezz",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ZhenX201/FE-Infinite-Money-All-Stats/main/source"))()
    end
})

ByHandsTab:AddButton({
    Name = "无卡",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/KrzysztofWojworker/ArmWrestling/main/script.lua"))()
    end
})

ByHandsTab:AddButton({
    Name = "自动胜利",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptpastebin/raw/main/armwrestling"))()
    end
})

local BloxFruitsTab = MainWindow:MakeTab({
    Name = "海贼王",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

BloxFruitsTab:AddButton({
    Name = "海贼中心",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GamingScripter/Darkrai-X/main/Games/BloxFruits"))()
    end
})

BloxFruitsTab:AddButton({
    Name = "脚本二",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/BloxFruits/main/redz9999"))()
    end
})

BloxFruitsTab:AddButton({
    Name = "自动农场",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/PZjNN1dS"))()
    end
})

local MurderMysteryTab = MainWindow:MakeTab({
    Name = "谋杀神秘",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MurderMysteryTab:AddButton({
    Name = "MM2脚本",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GamingScripter/Darkrai-X/main/Games/MurderMystery2"))()
    end
})

MurderMysteryTab:AddButton({
    Name = "透视凶手",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/YcKLwQbr"))()
    end
})

local PetSimulatorTab = MainWindow:MakeTab({
    Name = "宠物模拟器",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

PetSimulatorTab:AddButton({
    Name = "PSX脚本",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GamingScripter/Darkrai-X/main/Games/PetSimulatorX"))()
    end
})

PetSimulatorTab:AddButton({
    Name = "自动农场",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/dJHK5bMg"))()
    end
})

local SettingsTab = MainWindow:MakeTab({
    Name = "设置",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

SettingsTab:AddButton({
    Name = "销毁界面",
    Callback = function()
        OrionLib:Destroy()
        if ScreenGui then
            ScreenGui:Destroy()
        end
    end
})

SettingsTab:AddButton({
    Name = "重新加载",
    Callback = function()
        OrionLib:Destroy()
        if ScreenGui then
            ScreenGui:Destroy()
        end
        wait(1)
        loadstring(game:HttpGet("原脚本链接"))()
    end
})

SettingsTab:AddLabel("版本: V2.0")
SettingsTab:AddLabel("作者: 冷月")
SettingsTab:AddParagraph("感谢使用冷月脚本中心！")

OrionLib:Init()