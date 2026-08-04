---必看：这个源码是我自己要开源的如果能对其他人有帮助的话也是值了关注我的b站吧UID:1531514159脚本这么久没更新是因为我上学太忙了之后会重新搞一个版本
---我看了很多付费脚本功能都是挺垃圾的建议不要去买付费脚本除非他们有什么特别牛逼的功能可以找老外的脚本平替不会找老外脚本的可以来找我我帮你们找
---关注我然后私信免费汉化脚本
local TextChatService = game:GetService("TextChatService") local ReplicatedStorage = game:GetService("ReplicatedStorage") local function SendChatMessage(message) if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then local textChannel = TextChatService.TextChannels.RBXGeneral textChannel:SendAsync(message) else ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All") end end SendChatMessage("The Dark Side of the Moon月之暗面。") SendChatMessage("Speak To Me和我对白。")
local LP = game:GetService("Players").LocalPlayer
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local customNotificationGui = Instance.new("ScreenGui")
customNotificationGui.Name = "CustomNotificationGui"
customNotificationGui.Parent = playerGui

local notificationFrame = Instance.new("Frame")
notificationFrame.Size = UDim2.new(0, 300, 0, 100)
notificationFrame.Position = UDim2.new(1, 0, 1, -110) 
notificationFrame.BackgroundColor3 = Color3.new(0, 0, 0) 
notificationFrame.BackgroundTransparency = 0.2 
notificationFrame.BorderSizePixel = 0 
notificationFrame.Parent = customNotificationGui

local loadingRing = Instance.new("ImageLabel")
loadingRing.Size = UDim2.new(1.2, 0, 1.2, 0) 
loadingRing.Position = UDim2.new(-0.1, 0, -0.1, 0) 
loadingRing.BackgroundTransparency = 1 
loadingRing.Image = "rbxassetid://1011584077" 
loadingRing.ImageColor3 = Color3.new(1, 1, 1) 
loadingRing.Parent = notificationFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundTransparency = 1 
titleLabel.TextColor3 = Color3.new(1, 1, 1) 
titleLabel.Text = "Kenny脚本" 
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18
titleLabel.Parent = notificationFrame

local contentLabel = Instance.new("TextLabel")
contentLabel.Size = UDim2.new(1, -20, 0, 40)
contentLabel.Position = UDim2.new(0, 10, 0, 45)
contentLabel.BackgroundTransparency = 1
contentLabel.TextColor3 = Color3.new(1, 1, 1)
contentLabel.Text = "Kenny脚本加载完成开始享受吧。" 
contentLabel.Font = Enum.Font.SourceSans
contentLabel.TextSize = 16
contentLabel.Parent = notificationFrame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -30, 0, 10)
closeButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Parent = notificationFrame

closeButton.MouseButton1Click:Connect(function()
    customNotificationGui:Destroy()
end)

local rotateTweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
local rotateTween = TweenService:Create(loadingRing, rotateTweenInfo, {Rotation = 360})
rotateTween:Play()

local targetPosition = UDim2.new(1, -310, 1, -110)
local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tween = TweenService:Create(notificationFrame, tweenInfo, {Position = targetPosition})
tween:Play()

wait(5)
customNotificationGui:Destroy()

local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/bailib/Roblox/refs/heads/main/main/ESP.lua"))()
ESP.AddFolder("HiderESPFolder")
ESP.AddFolder("HunterESPFolder")
ESP.AddFolder("GlassESPFolder")

local WindUISuccess, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
end)

if not WindUISuccess then
    error("❌ WindUI加载失败: "..tostring(WindUI))
    return
end

function gradient(text, startColor, endColor)
    if not text or #text == 0 then return "" end
    if not startColor or not endColor then
        warn("⚠️ 颜色参数无效，使用默认颜色")
        startColor = Color3.fromRGB(255,255,255)
        endColor = Color3.fromRGB(200,200,200)
    end

    local result = ""
    local length = #text

    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255)
        local g = math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255)
        local b = math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255)

        local char = text:sub(i, i)
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', r, g, b, char)
    end

    return result
end

local Confirmed = false
local popupSuccess, popupResult = pcall(function()
    WindUI:Popup({
        Title = "欢迎使用Kenny脚本",
        Icon = "rbxassetid://88797484203913",
        Content = "ken"..gradient("Kenny", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")).."Speak To Me",
        Buttons = {
            {
                Title = "取消",
                Callback = function() end,
                Variant = "Secondary"
            },
            {
                Title = "继续",
                Icon = "arrow-right",
                Callback = function() Confirmed = true end,
                Variant = "Primary"
            }
        }
    })
end)

if not popupSuccess then
    warn("⚠️ 弹窗创建失败: "..tostring(popupResult))
    Confirmed = true
end

repeat task.wait() until Confirmed

local Window
local windowSuccess, windowResult = pcall(function()
    return WindUI:CreateWindow({
        Title = "Kenny脚本V1.5正式版",
        Icon = "rbxassetid://88797484203913",
        Author = "比任何时候都更好",
        Folder = "ColdSilence",
        Size = UDim2.fromOffset(300, 350),
        Theme = "Dark",
        User = {
            Enabled = true,
            Callback = function() print("用户按钮点击") end,
            Anonymous = false
        },
        KeySystem = {
            Key = { "月之暗面", "月之暗面" },
            Note = "请输入有效密钥\n\n官方群:1057168892",
            SaveKey = false
        }
    })
end)

if not windowSuccess then
    error("❌ 窗口创建失败: "..tostring(windowResult))
    return
else
    Window = windowResult
end

local function safeCreateButton(name, icon, callback, order)
    pcall(function()
        Window:CreateTopbarButton(name, icon, callback, order)
    end)
end

safeCreateButton("MyButton1", "bird", function() print("按钮1") end, 990)
safeCreateButton("MyButton2", "settings", function() Window:ToggleFullscreen() end, 989)

task.defer(function()
    collectgarbage("")
    print("✅ 内存优化完成 | 当前用量:", math.floor((collectgarbage("count")/1024)).."MB")
end)

print("🎉 Kenny脚本加载完成!")

local Tabs = {}

do
    Tabs.MainTab = Window:Section({Title = "通用脚本", Opened = true})   
   Tabs.CSJTab = Tabs.MainTab:Tab({ Title = "创世纪FE", Icon = "zap" })
   Tabs.MLTab = Tabs.MainTab:Tab({ Title = "melonFE", Icon = "zap" })
   Tabs.FWTab = Tabs.MainTab:Tab({ Title = "服务器漏洞", Icon = "zap" }) 
   Tabs.HDTab = Tabs.MainTab:Tab({ Title = "黑洞大全", Icon = "zap" })
   Tabs.KFTab = Tabs.MainTab:Tab({ Title = "开发工具", Icon = "zap" })  
   Tabs.ZRTab = Tabs.MainTab:Tab({ Title = "其他注入器", Icon = "zap" }) 
   Tabs.HZTab = Tabs.MainTab:Tab({ Title = "画质光影类", Icon = "zap" }) 
   Tabs.SFTab = Tabs.MainTab:Tab({ Title = "甩飞类", Icon = "zap" })
   Tabs.DZTab = Tabs.MainTab:Tab({ Title = "表情和动作类", Icon = "zap" })
   Tabs.TYGNTab = Tabs.MainTab:Tab({ Title = "通用", Icon = "zap" })
   Tabs.WJTab = Tabs.MainTab:Tab({ Title = "玩家类", Icon = "zap" })
   Tabs.PVPTab = Tabs.MainTab:Tab({ Title = "PVP类", Icon = "zap" })
   Tabs.CBTab = Tabs.MainTab:Tab({ Title = "18+动作专区", Icon = "zap" })
end

do
    Tabs.LOLTab = Window:Section({Title = "服务器脚本", Opened = true})
Tabs.BZTab = Tabs.LOLTab:Tab({ Title = "巴掌模拟器", Icon = "zap" })
Tabs.ZQTab = Tabs.LOLTab:Tab({ Title = "最强战场", Icon = "zap" })
Tabs.FZTab = Tabs.LOLTab:Tab({ Title = "犯罪", Icon = "zap" })
Tabs.MSTab = Tabs.LOLTab:Tab({ Title = "墨水游戏", Icon = "zap" })
Tabs.JJTab = Tabs.LOLTab:Tab({ Title = "99夜", Icon = "zap" })
Tabs.TKTab = Tabs.LOLTab:Tab({ Title = "天空战争", Icon = "zap" })
Tabs.SCTab = Tabs.LOLTab:Tab({ Title = "生存战争", Icon = "zap" })
Tabs.CJTab = Tabs.LOLTab:Tab({ Title = "三叉戟生存", Icon = "zap" })
end

Tabs.TKTab:Button({
    Title = "vapev4",
    Desc = "已汉化",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E6%B1%89%E5%8C%96vapev4.txt"))()
    end
})

Tabs.SCTab:Button({
    Title = "vapev4",
    Desc = "已汉化",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E6%B1%89%E5%8C%96vapev4.txt"))()
    end
})

Tabs.CJTab:Button({
    Title = "vapev4",
    Desc = "已汉化",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E6%B1%89%E5%8C%96vapev4.txt"))()
    end
})

Tabs.JJTab:Button({
    Title = "虚空脚本",
    Desc = "已汉化",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/99%E5%A4%9C%E8%99%9A%E7%A9%BA.txt"))()
    end
})

Tabs.FZTab:Button({
    Title = "犯罪脚本",
    Desc = "已汉化加载两次过检测",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/Kenny%E6%B1%89%E5%8C%96%E7%8A%AF%E7%BD%AA%E8%84%9A%E6%9C%AC.txt"))()
    end
})

Tabs.ZQTab:Button({
    Title = "VexonHub已汉化",
    Desc = "超级强的脚本如果有卡密卡密是VexonHub_3",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/VexonHub%E6%B1%89%E5%8C%96.txt"))()
    end
})

Tabs.MSTab:Button({
    Title = "Ringta",
    Desc = "已汉化",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E6%B1%89%E5%8C%96%E5%A2%A8%E6%B0%B4Ringta.txt"))()
    end
})

Tabs.CBTab:Button({
    Title = "r6撸鸡吧",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-jerk-off-25958"))()
    end
})

Tabs.CBTab:Button({
    Title = "r15撸鸡吧",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
    end
})

Tabs.CBTab:Button({
    Title = "操人GUI",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/hkyuHQ7Y"))();
    end
})

Tabs.CBTab:Button({
    Title = "r15被操",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/kenk/refs/heads/main/%E8%A2%AB%E6%93%8DR15.txt"))()
    end
})

Tabs.CBTab:Button({
    Title = "R6被操",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/kenk/refs/heads/main/r6%E8%A2%AB%E6%93%8D.txt"))()
    end
})

Tabs.CBTab:Button({
    Title = "R6让别人给你口",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/kenk/refs/heads/main/R6%E8%AE%A9%E5%88%AB%E4%BA%BA%E7%BB%99%E4%BD%A0%E5%8F%A3.txt"))()
    end
})

Tabs.CBTab:Button({
    Title = "R15让别人给你口",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/kenk/refs/heads/main/R15%E8%AE%A9%E5%88%AB%E4%BA%BA%E7%BB%99%E4%BD%A0%E5%8F%A3.txt"))()
    end
})

Tabs.CBTab:Button({
    Title = "R15口别人",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/kenk/refs/heads/main/R15%E8%B5%A4%E5%A3%81%E6%88%96%E9%9B%86.txt"))()
    end
})

Tabs.CBTab:Button({
    Title = "R6口别人",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/kenk/refs/heads/main/R6%E8%B5%A4%E5%A3%81%E6%88%96%E9%B8%A1.txt"))()
    end
})

Tabs.CBTab:Button({
    Title = "R6后入",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/kenk/refs/heads/main/R6%E5%90%8E%E5%85%A5.txt"))()
    end
})

Tabs.CBTab:Button({
    Title = "r15后入",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/kenk/refs/heads/main/R15%E5%90%8E%E5%85%A5.txt"))()
    end
})

Tabs.PVPTab:Button({
    Title = "无后座快速射击",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/kenk/refs/heads/main/%E6%97%A0%E5%90%8E%E5%BA%A7%E5%BF%AB%E9%80%9F%E5%B0%84%E5%87%BB.txt"))()
    end
})

Tabs.PVPTab:Button({
    Title = "无限子弹",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/kenk/refs/heads/main/%E6%97%A0%E9%99%90%E5%AD%90%E5%BC%B9.txt"))()
    end
})

Tabs.WJTab:Button({
    Title = "实时数据",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/kenk/refs/heads/main/%E7%8E%A9%E5%AE%B6%E5%AE%9E%E6%97%B6%E6%95%B0%E6%8D%AE.txt"))()
    end
})

Tabs.WJTab:Button({
    Title = "阿尔宙斯飞行",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/kenk/refs/heads/main/%E9%98%BF%E5%B0%94%E5%AE%99%E6%96%AF%E9%A3%9E%E8%A1%8C.txt"))()
    end
})

Tabs.WJTab:Button({
    Title = "人物旋转",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/kenk/refs/heads/main/%E4%BA%BA%E7%89%A9%E6%97%8B%E8%BD%AC.txt"))()
    end
})

Tabs.TYGNTab:Button({
    Title = "坐标传送2",
    Desc = "这个有点挡",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E5%9D%90%E6%A0%87%E6%9F%A5%E7%9C%8B%E5%8A%A0%E4%BC%A0%E9%80%81.txt"))()
    end
})

Tabs.WJTab:Button({
    Title = "反重力",
    Desc = "反重力",
    Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/96XzjEiK"))()
    end
})

Tabs.TYGNTab:Button({
    Title = "自动弹钢琴",
    Desc = "钢琴",
    Callback = function()
loadstring(game:HttpGet("https://rawscripts.net/raw/Tac's-Piano-Stuff-Talentless-script-made-by-hellohellohell012321-44088"))()        
    end
})

Tabs.WJTab:Button({
    Title = "心灵牵引",
    Desc = "可以磁吸和控制掉落物",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E7%BF%BB%E8%AF%91.txt"))()
    end
})

Tabs.PVPTab:Button({
    Title = "vapev4",
    Desc = "超级强PVP脚本已汉化",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E6%B1%89%E5%8C%96vapev4.txt"))()
    end
})

Tabs.SFTab:Button({
    Title = "酷小孩",
    Desc = "这个要饰品可以在有碰撞的服甩飞",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/randomstring0/qwertys/refs/heads/main/qwerty2.lua"))()
    end
})

Tabs.WJTab:Button({
    Title = "跳墙",
    Desc = "跳墙",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ScpGuest666/Random-Roblox-script/refs/heads/main/Roblox%20WallHop%20V4%20script"))()
    end
})

Tabs.TYGNTab:Button({
    Title = "坐标仪2",
    Desc = "第二种",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E4%BD%8D%E7%BD%AE%E4%BB%AA.txt"))()
    end
})

Tabs.TYGNTab:Button({
    Title = "坐标传送1",
    Desc = "这个不挡视野",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E5%9D%90%E6%A0%87%E4%BC%A0%E9%80%81.txt"))()
    end
})

Tabs.TYGNTab:Button({
    Title = "坐标仪1",
    Desc = "第一种",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E5%9D%90%E6%A0%87%E4%BB%AA.txt"))()
    end
})

Tabs.TYGNTab:Button({
    Title = "玩家进入提示",
    Desc = "玩家进入提示",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/boyscp/scriscriptsc/main/bbn.lua"))()
    end
})

Tabs.TYGNTab:Button({
    Title = "计时器",
    Desc = "速通大佬说是",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E8%AE%A1%E6%97%B6%E5%99%A8.txt"))()
    end
})

Tabs.TYGNTab:Button({
    Title = "本地音乐播放器2",
    Desc = "输入音乐ID使用",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E6%9C%AC%E5%9C%B0%E9%9F%B3%E4%B9%90%E6%92%AD%E6%94%BE%E5%99%A8.txt"))()
    end
})

Tabs.TYGNTab:Button({
    Title = "蓝屏报错",
    Desc = "无法关闭",
    Callback = function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/CloudX-ScriptsWane/White-ash-script/main/Free%20Robux.LUA'))()
    end
})

Tabs.TYGNTab:Button({
    Title = "iy指令",
    Desc = "iy",
    Callback = function()
loadstring(game:HttpGet(('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'),true))()
    end
})

Tabs.TYGNTab:Button({
    Title = "本地音乐播放器",
    Desc = "可以自定义音乐教程看我视频",
    Callback = function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/refs/heads/main/ScriptAuthorization%20Source'))()Ioad('7208e39603889391caf77f6ff7d21e01')
    end
})

Tabs.TYGNTab:Button({
    Title = "我的世界",
    Desc = "真的能玩别人看不见",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Biem6ondo/mc/refs/heads/main/STARTUP"))()
    end
})

Tabs.TYGNTab:Button({
    Title = "假朋友",
    Desc = "假朋友",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/sigmaboy123z/MYFRIENDSCRIPT/refs/heads/main/MYNEWFRIENDSPAWNER"))();
    end
})

Tabs.TYGNTab:Button({
    Title = "忍者同款键盘",
    Desc = "键盘",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E9%94%AE%E7%9B%98.txt"))()
    end
})

Tabs.TYGNTab:Button({
    Title = "键盘",
    Desc = "键盘",
    Callback = function()
loadstring(game:HttpGet("https://gist.githubusercontent.com/RedZenXYZ/4d80bfd70ee27000660e4bfa7509c667/raw/da903c570249ab3c0c1a74f3467260972c3d87e6/KeyBoard%2520From%2520Ohio%2520Fr%2520Fr"))()
    end
})

Tabs.TYGNTab:Button({
    Title = "时间",
    Desc = "实时显示北京时间",
    Callback = function()
local LBLG = Instance.new("ScreenGui", getParent)
local LBL = Instance.new("TextLabel", getParent)
local player = game.Players.LocalPlayer

LBLG.Name = "LBLG"
LBLG.Parent = game.CoreGui
LBLG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LBLG.Enabled = true
LBL.Name = "LBL"
LBL.Parent = LBLG
LBL.BackgroundColor3 = Color3.new(0, 3, 1)
LBL.BackgroundTransparency = 1
LBL.BorderColor3 = Color3.new(0, 3, 1)
LBL.Position = UDim2.new(0.75,0,0.010,0)
LBL.Size = UDim2.new(0, 133, 0, 30)
LBL.Font = Enum.Font.GothamSemibold
LBL.Text = "TextLabel"
LBL.TextColor3 = Color3.new(0, 3, 3)
LBL.TextScaled = true
LBL.TextSize = 14
LBL.TextWrapped = true
LBL.Visible = true

local FpsLabel = LBL
local Heartbeat = game:GetService("RunService").Heartbeat
local LastIteration, Start
local FrameUpdateTable = { }

local function HeartbeatUpdate()
  LastIteration = tick()
  for Index = #FrameUpdateTable, 1, -1 do
    FrameUpdateTable[Index + 1] = (FrameUpdateTable[Index] >= LastIteration - 1) and FrameUpdateTable[Index] or nil
  end
  FrameUpdateTable[1] = LastIteration
  local CurrentFPS = (tick() - Start >= 1 and #FrameUpdateTable) or (#FrameUpdateTable / (tick() - Start))
  CurrentFPS = CurrentFPS - CurrentFPS % 1
  FpsLabel.Text = ("当前时间:"..os.date("%H").."时"..os.date("%M").."分"..os.date("%S"))
end
Start = tick()
Heartbeat:Connect(HeartbeatUpdate)
      end
})

Tabs.PVPTab:Button({
    Title = "透视可开关",
    Desc = "透视",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ZIONPCE/raw/refs/heads/main/ESP.lua"))()
    end
})

Tabs.PVPTab:Button({
    Title = "第一人称自瞄",
    Desc = "只能在第一人称射击游戏用",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Roblox-HttpSpy/Random-Silly-stuff/refs/heads/main/AimBotV2.lua"))()
    end
})

Tabs.PVPTab:Button({
    Title = "自瞄",
    Desc = "自瞄",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E4%B8%81%E4%B8%81%20%E6%B1%89%E5%8C%96%E8%87%AA%E7%9E%84.txt"))()
    end
})

Tabs.PVPTab:Button({
    Title = "子追",
    Desc = "不可穿墙",
    Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/m9E4cjnn"))()
    end
})

Tabs.PVPTab:Button({
    Title = "子追2",
    Desc = "可穿墙",
    Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/dbeV4YXx"))()
    end
})

Tabs.PVPTab:Button({
    Title = "透视",
    Desc = "不可关闭",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasfin000/SpaceHub/main/UESP"))()
    end
})

Tabs.PVPTab:Button({
    Title = "超大范围",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/KKY9EpZU"))()
    end
})

Tabs.PVPTab:Button({
    Title = "大范围",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/x13bwrFb"))()
    end
})

Tabs.PVPTab:Button({
    Title = "小小范围",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/yP09ddbu"))()
    end
})

Tabs.PVPTab:Button({
    Title = "小范围",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/jiNwDbCN"))()
    end
})

Tabs.PVPTab:Button({
    Title = "中等范围",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/FAY1au9v"))()
    end
})

Tabs.HZTab:Button({
    Title = "时间选择RTX光影",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Simple-Shader-37434"))()
    end
})

Tabs.HZTab:Button({
    Title = "巨好看光影",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/MZEEN2424/Graphics/main/Graphics.xml"))()
    end
})

Tabs.HZTab:Button({
    Title = "RTX昼夜切换光影",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E6%98%BC%E5%A4%9CRTX%E5%85%89%E5%BD%B1.txt"))()
    end
})

Tabs.HZTab:Button({
    Title = "高画质",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/jHBfJYmS"))()
    end
})

Tabs.HZTab:Button({
    Title = "高亮全图",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/4LDKiJ5a"))()
    end
})

Tabs.HZTab:Button({
    Title = "着色器",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/JeckAsChristopher/h/refs/heads/main/loader.lua"))()
    end
})

Tabs.HZTab:Button({
    Title = "自定义光影",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/lyraEz/gvb/refs/heads/main/DeepGraphicsHub.lua'))()
    end
})

Tabs.HZTab:Button({
    Title = "超高画质",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/jHBfJYmS"))()
    end
})

Tabs.HZTab:Button({
    Title = "白光影",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E7%99%BD%E5%85%89%E5%BD%B1.txt"))()
    end
})

Tabs.HZTab:Button({
    Title = "夜晚",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E5%A4%9C%E6%99%9A.txt"))()
    end
})

Tabs.HZTab:Button({
    Title = "FPS提升器",
    Desc = "这个脚本超级猛",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/JoshzzAlteregooo/JoshzzFpsBoosterVersion3/refs/heads/main/JoshzzNewFpsBooster"))()
    end
})

Tabs.HZTab:Button({
    Title = "高亮光影",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/4LDKiJ5a"))()
    end
})

Tabs.HZTab:Button({
    Title = "好看光影",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E5%A5%BD%E7%9C%8B%E5%85%89%E5%BD%B1.txt"))()
    end
})

Tabs.HZTab:Button({
    Title = "自制画质提升",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E7%94%BB%E8%B4%A8%E6%8F%90%E5%8D%871.txt"))()
    end
})

Tabs.HZTab:Button({
    Title = "自制光影",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E7%94%BB%E8%B4%A8%E6%8F%90%E5%8D%872.txt"))()
    end
})

Tabs.HZTab:Button({
    Title = "RTX光影V1",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/RTXv1.txt"))()
    end
})

Tabs.SFTab:Button({
    Title = "kenny甩飞gui",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/fe-flinger-gui-works-anywhere_1756291955889_SwfaGHMWsT.txt"))()
    end
})

Tabs.SFTab:Button({
    Title = "可选人甩飞",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://pastefy.app/A8Kfs9KV/raw", true))()
    end
})

Tabs.SFTab:Button({
    Title = "防甩飞",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ChinaQY/Scripts/Main/AntiFling.lua"))()
    end
})

Tabs.SFTab:Button({
    Title = "一键甩飞所有人",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/zqyDSUWX"))()
    end
})

Tabs.SFTab:Button({
    Title = "甩飞中心",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/3LD4D0/OP-FLING-GUI/c1fd15bf3114e6c9e4b76951b7d516c123836efe/OP%20FLING%20GUI%20R6%20AND%20R15"))()
    end
})

Tabs.SFTab:Button({
    Title = "Kenny甩飞",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/DHJB%E7%94%A9%E9%A3%9E.txt"))()
    end
})

Tabs.SFTab:Button({
    Title = "触摸甩飞",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/LiarRise/FLN-X/refs/heads/main/README.md"))()
    end
})

Tabs.SFTab:Button({
    Title = "铁拳",
    Desc = "汉化",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E6%B1%89%E5%8C%96%E9%93%81%E6%8B%B3.txt"))()
    end
})

Tabs.WJTab:Button({
    Title = "获取工具",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/BTools.txt"))()
    end
})

Tabs.WJTab:Button({
    Title = "蜘蛛侠",
    Desc = "四百大妈",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E8%9C%98%E8%9B%9B%E4%BE%A0.txt"))()
    end
})

Tabs.HZTab:Button({
    Title = "光影",
    Desc = "光影",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/MZEEN2424/Graphics/main/Graphics.xml"))()     
    end
})

Tabs.HZTab:Button({
    Title = "变流畅",
    Desc = "变流畅",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/gclich/FPS-X-GUI/main/FPS_X.lua"))()
    end
})

Tabs.WJTab:Button({
    Title = "闪回",
    Desc = "闪回",
    Callback = function()
loadstring(game:HttpGet("https://mscripts.vercel.app/scfiles/reverse-script.lua"))()
    end
})

Tabs.WJTab:Input({
    Title = "重力设置",
    Value = "",
    Placeholder = "修改重力",
    Callback = function(input)
        game.Workspace.Gravity = tonumber(input) or game.Workspace.Gravity
    end
})

Tabs.WJTab:Button({
    Title = "爬墙",
    Desc = "爬墙",
    Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/zXk4Rq2r"))() 
    end
})

Tabs.WJTab:Button({
    Title = "踏空",
    Desc = "踏空",
    Callback = function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Float'))()
    end
})

Tabs.WJTab:Button({
    Title = "R15变R6",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Yungengxin/roblox/refs/heads/main/R15toR6"))()
    end
})

Tabs.WJTab:Button({
    Title = "飞车",
    Desc = "飞车",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E9%A3%9E%E8%BD%A6.txt"))()
    end
})

Tabs.WJTab:Button({
    Title = "反挂机",
    Desc = "反挂机",
    Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/9fFu43FF"))()
    end
})

Tabs.WJTab:Toggle({
    Title = "夜视",
    Desc = "夜视功能",
    Default = false,
    Callback = function(value)
        if value then
            game.Lighting.Ambient = Color3.new(1, 1, 1)
        else
            game.Lighting.Ambient = Color3.new(0, 0, 0)
        end
    end
})

Tabs.WJTab:Button({
    Title = "物理枪",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Yungengxin/roblox/refs/heads/main/FEwuliqiang"))()
    end
})

Tabs.WJTab:Button({
    Title = "查看别人物品栏",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E7%9C%8B%E7%89%A9%E5%93%81%E6%A0%8F.txt"))()
    end
})

Tabs.WJTab:Button({
    Title = "实时数据",
    Desc = "玩家实时数据",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E5%AE%9E%E6%97%B6%E6%95%B0%E6%8D%AE.txt"))()
    end
})

Tabs.WJTab:Button({
    Title = "聊天查找器",
    Desc = "可以查找他人聊天记录",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/v-oidd/chat-tracker/main/chat-tracker.lua"))()
    end
})

Tabs.WJTab:Button({
    Title = "秘密聊天",
    Desc = "只有同样使用这个脚本的人可以看见",
    Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/MtgpaZaf"))()
    end
})

Tabs.WJTab:Button({
    Title = "秒互动",
    Desc = "一秒互动",
    Callback = function()
game.ProximityPromptService.PromptButtonHoldBegan:Connect(function(v)
    v.HoldDuration = 0
end)
    end
})

Tabs.WJTab:Toggle({
    Title = "连跳",
    Value = false,
    Callback = function(value)
       Jump = value
        game.UserInputService.JumpRequest:Connect(function()
            if Jump then
                game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
            end
        end)
    end
})

Tabs.WJTab:Button({
    Title = "飞行",
    Desc = "飞行",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E9%A3%9E%E8%A1%8C%E8%84%9A%E6%9C%ACV3(%E5%85%A8%E6%B8%B8%E6%88%8F%E9%80%9A%E7%94%A8)%20(1)%20(1).txt"))()
    end
})

Tabs.WJTab:Button({
    Title = "刷屏机器",
    Desc = "一键自定义发言",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E5%88%B7%E5%B1%8F.txt"))()
    end
})

Tabs.WJTab:Toggle({
    Title = "穿墙",
    Value = false,
    Callback = function(value)
        WallTp = value
        if value then
            game:GetService("RunService").Stepped:Connect(function()
                if WallTp and game.Players.LocalPlayer.Character then
                    local Character = game.Players.LocalPlayer.Character
                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                    if Humanoid then
                        for _, part in ipairs(Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end)
        else
            if game.Players.LocalPlayer.Character then
                for _, part in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

Tabs.WJTab:Button({
    Title = "点击传送工具",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Teleport-Tool-25249"))()     
    end
})

Tabs.WJTab:Slider({
    Title = "跳跃高度",
    Value = {
        Min = 1,
        Max = 9999,
        Default = 50,
    },
    Callback = function(value)
        local localPlayer = game.Players.LocalPlayer
        local character = localPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = value
            end
        end
    end
})

Tabs.WJTab:Slider({
    Title = "跑步速度",
    Value = {
        Min = 1,
        Max = 99999,
        Default = 50,
    },
    Callback = function(value)
        local localPlayer = game.Players.LocalPlayer
        local character = localPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = value
            end
        end
    end
})

Tabs.WJTab:Button({
    Title = "假管理",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/sZpgTVas"))()
    end
})

Tabs.WJTab:Button({
    Title = "控制玩家",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Yungengxin/roblox/refs/heads/main/wanjiakongzhi"))()
    end
})

Tabs.WJTab:Button({
    Title = "R6假无头",
    Desc = "R6假无头",
    Callback = function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/Gazer-Ha/Valiant-Ui-Lib-Gazed-/refs/heads/main/Head%20Pack'))()
    end
})

Tabs.WJTab:Button({
    Title = "失重",
    Desc = "失重",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Rawbr10/Roblox-Scripts/refs/heads/main/0%20Graviy%20Trip%20Universal"))()
    end
})

Tabs.WJTab:Button({
    Title = "偷别人物品",
    Desc = "一键获得所有人的物品",
    Callback = function()
for i,v in pairs (game.Players:GetChildren()) do
wait()
for i,b in pairs (v.Backpack:GetChildren()) do
b.Parent = game.Players.LocalPlayer.Backpack
end
end
    end
})

Tabs.WJTab:Button({
    Title = "隐身2",
    Desc = "通用",
    Callback = function()
loadstring(game:HttpGet('https://pastebin.com/raw/3Rnd9rHf'))()  
    end
})

Tabs.WJTab:Button({
    Title = "隐身",
    Desc = "这个自带加速",
    Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/vP6CrQJj"))()        
    end
})

Tabs.WJTab:Button({
    Title = "火车头",
    Desc = "越跑越快",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E8%B6%8A%E8%B7%91%E8%B6%8A%E5%BF%AB.txt"))();
    end
})

Tabs.DZTab:Button({
    Title = "自定义角色动画",
    Desc = "可调节",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E8%87%AA%E5%AE%9A%E4%B9%89%E5%8A%A8%E7%94%BB.txt"))()
    end
})

Tabs.DZTab:Button({
    Title = "变成球",
    Desc = "滚动",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/KaterHub-Inc/scripts/refs/heads/main/unofficial-Projects/FEHamsterBall.lua"))()
    end
})

Tabs.DZTab:Button({
    Title = "爬行",
    Desc = "爬行",
    Callback = function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/0Ben1/fe/main/obf_vZDX8j5ggfAf58QhdJ59BVEmF6nmZgq4Mcjt2l8wn16CiStIW2P6EkNc605qv9K4.lua.txt'))()
    end
})

Tabs.DZTab:Button({
    Title = "VR手",
    Desc = "VR",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/randomstring0/Qwerty/refs/heads/main/qwerty45.lua"))()
    end
})

Tabs.DZTab:Button({
    Title = "在别人身上转",
    Desc = "旋转",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ShutUpJamesTheLoserAlt/hatspin/refs/heads/main/hat"))()        
    end
})

Tabs.DZTab:Button({
    Title = "青蛙走路特效",
    Desc = "仅自己可见",
    Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/vhis9HZy"))()
    end
})

Tabs.DZTab:Button({
    Title = "遁地",
    Desc = "别人可见",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/0Ben1/fe/main/obf_rTvXTs8F16D8D2oiLxZ62E1E9jT1we312yUyJr2h72Vwqr32l37rirU1S89hqRV7.lua.txt"))()
    end
})

Tabs.DZTab:Button({
    Title = "镰刀死神可传送踏空",
    Desc = "只有自己能看到死神和镰刀特效",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/srzmnx/OLD-roblox-scripts/refs/heads/master/Scythe.txt"))()
    end
})

Tabs.DZTab:Button({
    Title = "开车",
    Desc = "开车",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/AstraOutlight/my-scripts/refs/heads/main/fe%20car%20v3"))()
    end
})

Tabs.DZTab:Button({
    Title = "头部宠物",
    Desc = "把自己变成别人宠物",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/randomstring0/Qwerty/refs/heads/main/qwerty40.lua"))()
    end
})

Tabs.DZTab:Button({
    Title = "超慢跑跳",
    Desc = "超慢跑跳",
    Callback = function()
loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fake-lag-41217"))()
    end
})

Tabs.DZTab:Button({
    Title = "ucg表情",
    Desc = "ucg表情",
    Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/1nJD7PkH",true))()       
    end
})

Tabs.DZTab:Button({
    Title = "r6动作",
    Desc = "很多很多别人可见",
    Callback = function()
loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-R6-Animations-Menu-By-Me-19427"))()
    end
})

Tabs.DZTab:Button({
    Title = "拥抱",
    Desc = "r6可用",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ExploitFin/Animations/refs/heads/main/Front%20and%20Back%20Hug%20Tool"))()       
    end
})

Tabs.DZTab:Button({
    Title = "r15无敌少侠飞行",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://github.com/Sinister-Scripts/Roblox-Exploits/raw/refs/heads/main/FE-Animated-Mobile-Fly"))()        
    end
})

Tabs.DZTab:Button({
    Title = "r15无敌少侠飞行2",
    Desc = "这个动作好一点",
    Callback = function()
loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Invinicible-Flight-R15-45414"))()     
    end
})

Tabs.DZTab:Button({
    Title = "r6无敌少侠飞行",
    Desc = "这个手机端需要配专属移动按键",
    Callback = function()
loadstring(game:HttpGet("https://gist.githubusercontent.com/JungleScripts/775c6366d91d39fe2633c5805a1d0c23/raw/c8de949402393510a27bcf4482c957b6c3bed2c2/gistfile1.txt"))()    
    end
})

Tabs.DZTab:Button({
    Title = "r6无敌少侠飞行专属按键",
    Desc = "移动端用这个来飞行",
    Callback = function()
loadstring(game:HttpGet("https://gist.githubusercontent.com/JungleScripts/8dc95c7ce10e86d353d606334a77de88/raw/08f3e2967701463da36f2fc28e9943e63799dd3f/gistfile1.txt"))() 
    end
})

Tabs.DZTab:Button({
    Title = "r6无敌少侠飞行2",
    Desc = "移动端用专属按键来飞",
    Callback = function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/396abc/Script/refs/heads/main/Fly.lua'))()
    end
})

Tabs.DZTab:Button({
    Title = "r6无敌少侠飞行3",
    Desc = "可以直接用移动键来飞",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E6%97%A0%E6%95%8C%E5%B0%91%E4%BE%A0%E9%A3%9E%E8%A1%8Cr6.txt"))()
    end
})

Tabs.DZTab:Button({
    Title = "动画和表情",
    Desc = "FE",
    Callback = function()
loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-AFEM-14048"))()       
    end
})

Tabs.DZTab:Button({
    Title = "舞蹈",
    Desc = "FE",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Gazer-Ha/Free-emote/refs/heads/main/Delta%20mad%20stuffs"))()       
    end
})

Tabs.DZTab:Button({
    Title = "R6动作",
    Desc = "FE",
    Callback = function()
loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-R6-Animations-Menu-By-Me-19427"))()       
    end
})

Tabs.DZTab:Button({
    Title = "R15动作",
    Desc = "FE",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Boxten-Keyes/music/refs/heads/main/music%23%5Bscripts%5D/music%23%5Bmiscellaneous%5D/music%23%5Bfe%20r15%20animation%20player%5D.lua"))()        
    end
})

Tabs.DZTab:Button({
    Title = "900个动作",
    Desc = "FE",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Rootleak/roblox/refs/heads/main/main.lua"))()        
    end
})

Tabs.DZTab:Button({
    Title = "车动作",
    Desc = "FE",
    Callback = function()
loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FE-SILLY-CAR-V1-48227"))()        
    end
})

Tabs.ZRTab:Button({
    Title = "阿尔宙斯V3",
    Desc = "Kenny汉化",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/Arceus%20X%20V3.txt"))()
    end
})

Tabs.ZRTab:Button({
    Title = "突触X改进版",
    Desc = "Kenny汉化",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E7%AA%81%E8%A7%A6X%E6%94%B9%E8%BF%9B.lua.txt"))()
    end
})

Tabs.ZRTab:Button({
    Title = "突触X重置版",
    Desc = "Kenny汉化",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E7%AA%81%E8%A7%A6X%E9%87%8D%E7%BD%AE%E7%89%88%E6%B1%89%E5%8C%96.txt"))()
    end
})

Tabs.ZQTab:Button({
    Title = "Sung Suho",
    Desc = "使用英雄猎人",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/sparksnaps/Sung-Suho/refs/heads/main/Lua"))()
    end
})

Tabs.ZQTab:Button({
    Title = "秤金次",
    Desc = "使用琦玉",
    Callback = function()
loadstring(game:HttpGet("https://pastefy.app/R9YJF35g/raw"))();
    end
})

Tabs.ZQTab:Button({
    Title = "反向闪光",
    Desc = "使用琦玉",
    Callback = function()
loadstring(game:HttpGet("https://pastefy.app/HwE5XJof/raw"))()
    end
})

Tabs.ZQTab:Button({
    Title = "吉连",
    Desc = "使用英雄猎人",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/sparksnaps/Jiren-Moveset-V2/refs/heads/main/Lua"))()
    end
})

Tabs.ZQTab:Button({
    Title = "沃利·韦斯特",
    Desc = "使用琦玉",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Nova2ezz/west/refs/heads/main/Protected_4638864115822087.lua.txt"))()
    end
})

Tabs.ZQTab:Button({
    Title = "无敌少侠",
    Desc = "使用琦玉",
    Callback = function()
loadstring(game:HttpGet("https://pastefy.app/BtDQqi2c/raw"))()
    end
})

Tabs.ZQTab:Button({
    Title = "希德·卡盖诺",
    Desc = "使用琦玉",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/sparksnaps/Lord-Shadow-Beta/refs/heads/main/Lua"))()
    end
})

Tabs.HDTab:Button({
    Title = "黑洞V1（黑洞中心同款）",
    Desc = "黑洞中心偷过来的。。。",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/1379qpalzmtygvezimaliexcvbnqplasdfg/BS/refs/heads/main/%E6%9B%BF%E8%BA%AB.txt"))()
    end
})

Tabs.HDTab:Button({
    Title = "黑洞v2",
    Desc = "未汉化",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/BOOSBS/666/refs/heads/main/656"))()
    end
})

Tabs.HDTab:Button({
    Title = "黑洞中心同款v3",
    Desc = "感谢黑洞中心。",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/1379qpalzmtygvezimaliexcvbnqplasdfg/11284/refs/heads/main/Protected_6980301799988851.lua.txt"))()
    end
})

Tabs.HDTab:Button({
    Title = "简陋黑洞",
    Desc = "我鸡吧好痒",
    Callback = function()
loadstring(game:HttpGet("https://codeberg.org/ajduoxcz/BS/raw/branch/main/199/%E4%BA%91Ul.txt"))()
    end
})

Tabs.HDTab:Button({
    Title = "终极黑洞",
    Desc = "感谢黑洞中心。",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/1379qpalzmtygvezimaliexcvbnqplasdfg/11284/refs/heads/main/Protected_2793948043438411.lua.txt"))()
    end
})

Tabs.HDTab:Button({
    Title = "直接吸",
    Desc = "黑洞",
    Callback = function()
loadstring(game:HttpGet("https://codeberg.org/ajduoxcz/BS/raw/branch/main/1234578/%E4%BA%91Ul.txt"))()
    end
})

Tabs.HDTab:Button({
    Title = "黑洞V1",
    Desc = "已汉化",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/V1.lua.txt"))()
    end
})

Tabs.HDTab:Button({
    Title = "黑洞V3",
    Desc = "已汉化",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/V3.txt"))()
    end
})

Tabs.KFTab:Button({
    Title = "动画spy",
    Desc = "获取角色动画",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E5%8A%A8%E7%94%BBSpy.lua.txt"))()
    end
})

Tabs.KFTab:Button({
    Title = "音频spy",
    Desc = "获取服务器音频链接",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/Alrthisfordetection.txt"))()
    end
})

Tabs.KFTab:Button({
    Title = "spy合集",
    Desc = "很多SPY融合在一块了",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/Simple_Spy_Utility.txt"))()
    end
})

Tabs.KFTab:Button({
    Title = "简洁spy",
    Desc = "UI简洁",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/fuckg1thub/RizzSpy/refs/heads/main/alright"))()
    end
})

Tabs.KFTab:Button({
    Title = "小spy",
    Desc = "UI小",
    Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/EHvjE2sT"))()
    end
})

Tabs.KFTab:Button({
    Title = "贴花spy",
    Desc = "获取所有贴花ID",
    Callback = function()
loadstring(game:HttpGet('https://pastefy.app/gkqzwu88/raw'))()
    end
})

Tabs.KFTab:Button({
    Title = "西格玛spy",
    Desc = "更高级的spy",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/depthso/Sigma-Spy/refs/heads/main/Main.lua"))()
    end
})

Tabs.KFTab:Button({
    Title = "dex++",
    Desc = "更好的dex",
    Callback = function()
loadstring(game:HttpGet("https://github.com/AZYsGithub/DexPlusPlus/releases/latest/download/out.lua"))()
    end
})

Tabs.KFTab:Button({
    Title = "氯胺酮spy",
    Desc = "spy",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/InfernusScripts/Ketamine/refs/heads/main/Ketamine.lua"))()
    end
})

Tabs.KFTab:Button({
    Title = "绕过spy和dex检测",
    Desc = "等级低的执行器无法使用",
    Callback = function()
loadstring(game:HttpGet("https://gist.githubusercontent.com/Tesker-103/23ea97f58891617afd8f797f0a7446e6/raw/011b70e99abb44aa6fc970c587c3eb686b40594e/Securedexbytesker103"))()
    end
})

Tabs.KFTab:Button({
    Title = "http嗅探器",
    Desc = "httpspy",
    Callback = function()
loadstring(game:HttpGet("https://ripskids.lol/official/HttpSpy/loader.lua"))()
    end
})

Tabs.KFTab:Button({
    Title = "乌托邦spy",
    Desc = "spy",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Klinac/scripts/main/utopia_spy.lua", true))()
    end
})

Tabs.KFTab:Button({
    Title = "Cobaltspy",
    Desc = "spy",
    Callback = function()
loadstring(game:HttpGet("https://github.com/notpoiu/cobalt/releases/latest/download/Cobalt.luau"))()
    end
})

Tabs.KFTab:Button({
    Title = "夜spyv3",
    Desc = "spy",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Angelo17123/NightSpyV3/refs/heads/main/NightSpy%20V4"))()
    end
})

Tabs.KFTab:Button({
    Title = "httpsSPY",
    Desc = "httpsspyWebhook销毁器",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Hm5011/hussain/refs/heads/main/Links%20Spy"))()
    end
})

Tabs.KFTab:Button({
    Title = "Webhook拦截器webhookspy",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/offperms/emplicswebhookspy/main/release"))()
    end
})

Tabs.KFTab:Button({
    Title = "RedCodespy",
    Desc = "一般",
    Callback = function()
loadstring(game:HttpGet(('https://raw.githubusercontent.com/RedCodeCheat/Roblox/refs/heads/main/RedCode_Remote_Spy.lua')))() 
    end
})

Tabs.KFTab:Button({
    Title = "HTTPspy",
    Desc = "撸鸡吧",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/293jOse0ejd8du/HttpSpy/refs/heads/main/main.lua"))() 
    end
})

Tabs.KFTab:Button({
    Title = "库尔斯克斯RSPY",
    Desc = "rspy",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/nizartitwaniii/Register-Roblox-/refs/heads/main/Protected_2944435597543940.txt"))() 
    end
})

Tabs.KFTab:Button({
    Title = "SpyOS",
    Desc = "HttpPost.HttpGet.SPY",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/RENBex6969/SpyOS/refs/heads/main/SpyOS_a2.lua"))() 
    end
})

Tabs.KFTab:Button({
    Title = "杰森SPY",
    Desc = "spy",
    Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/wjF5j5YD"))() 
    end
})

Tabs.KFTab:Button({
    Title = "速度spy",
    Desc = "rspy改进",
    Callback = function()
loadstring(game:HttpGet('https://gist.githubusercontent.com/24rr/ec08ee90929e07f3b4d2dd22f15146dc/raw/b337951012d6ed330067058f196ee0c414b42df3/spy-velocity'))()
    end
})

Tabs.HDTab:Button({
    Title = "黑洞V4",
    Desc = "已汉化",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/V4.txt"))()
    end
})

Tabs.HDTab:Button({
    Title = "黑洞V5",
    Desc = "已汉化",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/V5.txt"))()
    end
})

Tabs.HDTab:Button({
    Title = "黑洞V6",
    Desc = "已汉化",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/V6.txt"))()
    end
})

Tabs.HDTab:Button({
    Title = "双环控制黑洞",
    Desc = "已汉化",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E5%8F%8C%E7%8E%AF%E6%8E%A7%E5%88%B6%E9%BB%91%E6%B4%9E.txt"))()
    end
})

Tabs.HDTab:Button({
    Title = "哥特风黑洞",
    Desc = "已汉化",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E5%93%A5%E7%89%B9%E9%A3%8E%E9%BB%91%E6%B4%9E.txt"))()
    end
})

Tabs.HDTab:Button({
    Title = "磁铁黑洞V2",
    Desc = "已汉化",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E7%A3%81%E9%93%81%E9%BB%91%E6%B4%9EV2.txt"))()
    end
})

Tabs.HDTab:Button({
    Title = "无敌黑洞什么都可以吸",
    Desc = "仅自己可见娱乐用",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/iimateiYT/Scripts/main/Black%20Hole.lua"))()
    end
})

Tabs.HDTab:Button({
    Title = "磁铁黑洞",
    Desc = "未汉化但是好看",
    Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/CMnEfnz8"))()  
    end
})

Tabs.HDTab:Button({
    Title = "可爱黑洞",
    Desc = "未汉化",
    Callback = function()
pcall(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/hellohellohell012321/KAWAII-AURA/main/kawaii_aura.lua", true))()
end)
    end
})

Tabs.FWTab:Button({
    Title = "AC6",
    Desc = "这个漏洞和车有关系",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/AC6.txt"))()
    end
})

Tabs.FWTab:Button({
    Title = "RC7",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/CoreGui/Scripts/main/RC7"))()
    end
})

Tabs.FWTab:Button({
    Title = "FE旁路",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://pastefy.app/bVbm4o1L/raw"))()
    end
})

Tabs.FWTab:Button({
    Title = "FE旁路2",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/username12scripting/CloxoSS/refs/heads/main/Cloxo%20Server%20Side"))()
    end
})

Tabs.FWTab:Button({
    Title = "ssp",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/1h26sk16"))()
    end
})

Tabs.FWTab:Button({
    Title = "鬼怪后门执行器",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/adceDwMv"))()
    end
})

Tabs.FWTab:Button({
    Title = "cmd",
    Desc = "cmd",
    Callback = function()
loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Cool-10379"))()
    end
})

Tabs.FWTab:Button({
    Title = "prizz",
    Desc = "cmd",
    Callback = function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/elliexmln/PrizzLife/main/pladmin.lua'))()
    end
})

Tabs.FWTab:Button({
    Title = "QuirkyCMD",
    Desc = "cmd",
    Callback = function()
loadstring(game: HttpGet("https://gist.github.com/someunknowndude /38cecea5be9d75cb743eac8b1eaf6758 /raw"))()
    end
})

Tabs.FWTab:Button({
    Title = "backdoorv6",
    Desc = "后门执行器",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/iK4oS/backdoor.exe/v6x/source.lua"))()
    end
})

Tabs.FWTab:Button({
    Title = "LALOL",
    Desc = "后门执行器",
    Callback = function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/Its-LALOL/LALOL-Hub/main/Backdoor-Scanner/script'))()
    end
})

Tabs.FWTab:Button({
    Title = "CET",
    Desc = "扫描服务器",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/InfernusScripts/Executor-Tests/refs/heads/main/Environment/Test.lua"))()
    end
})

Tabs.MLTab:Button({
    Title = "不朽领主",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://gist.githubusercontent.com/MelonsStuff/342631416698bc733c93dbce1fc43371/raw/5b506412e72fbc1b9e9730ae7f096d33bf06e128/ImmortalityLord.lua"))()
    end
})

Tabs.MLTab:Button({
    Title = "大锤近战",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://gist.githubusercontent.com/MelonsStuff/bc7a020c542be0b7f528a5d8fda5ad52/raw/0db8993dc638613bd91b10fdbceb5c2d0754711e/SledgeHammer.lua"))()
    end
})

Tabs.MLTab:Button({
    Title = "杰森",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://gist.githubusercontent.com/MelonsStuff/6203b323781cfb0a7ad35e4e9f60e026/raw/222815c2a4f6ffe38f8ae3965f6b3640c180ab4c/Jason.lua"))()
    end
})

Tabs.MLTab:Button({
    Title = "反派本色",
    Desc = "无碰撞甩飞",
    Callback = function()
loadstring(game:HttpGet(('https://gist.githubusercontent.com/axelinharlem182/1ee425c9d850af697f8c3cb108a9d816/raw/c4660b01faf4db266e8031e310121a65836f98a7/The%2520Villain'),true))()
    end
})

Tabs.MLTab:Button({
    Title = "内部战台",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://gist.githubusercontent.com/MelonsStuff/20eeb7c97303b19d6079b35de1e71df4/raw/129bb5c45933671097386bcd9d944ab4e7ecc55b/InternalWar.lua"))()
    end
})

Tabs.MLTab:Button({
    Title = "速度之星",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://gist.githubusercontent.com/MelonsStuff/e75f359fee8f18a171962df8c020ed95/raw/7106700d10ec2efc084b8879048dca72f86a10e7/KyusEnder.lua"))()
    end
})

Tabs.MLTab:Button({
    Title = "地平线加农炮",
    Desc = "无碰撞甩飞",
    Callback = function()
loadstring(game:HttpGet("https://gist.githubusercontent.com/MelonsStuff/34653df65434cbbbc36b3ec51d03e7a3/raw/8bd9ef0ad4495baa06f435629b562a103eaf2bf8/HorizonLC"))()
    end
})

Tabs.MLTab:Button({
    Title = "机枪手",
    Desc = "无碰撞甩飞",
    Callback = function()
loadstring(game:HttpGet("https://gist.githubusercontent.com/MelonsStuff/e7b408abcb813525d37e9b7a6bf301c9/raw/6421f9000e90e8a4c2ed57052208acbd6f9648dd/Minigun.txt"))()
    end
})

Tabs.MLTab:Button({
    Title = "消色差",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://gist.githubusercontent.com/MelonsStuff/1e606bc885a3c12fd50bc8f29ae6ac49/raw/6f2e187cc59818d2a308bdd055ae2a93bf2fcb64/Achromatic.lua"))()
    end
})

Tabs.MLTab:Button({
    Title = "虚空领主怪物",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://gist.githubusercontent.com/MelonsStuff/679dc6167ec854831759f495b970cc71/raw/9663b65e4df1fa491f1227aee8cbea43cbfe04d8/VoidBoss.lua"))()
    end
})

Tabs.BZTab:Button({
    Title = "一键全徽章手套",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/Pro666Pro/UltimateBadgeHub/main/main.lua'))()
    end
})

Tabs.BZTab:Button({
    Title = "boos战脚本",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/File-Script/Slap_Battles.lua"))()
    end
})

Tabs.BZTab:Button({
    Title = "死神手套",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Yuna-ux/Slap-battles/refs/heads/main/Death_glove_V4.lua"))();
    end
})

Tabs.BZTab:Button({
    Title = "全自动刷巴掌",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/CelerityRBLX/Roblox/refs/heads/main/Slap%20Battles/Slap%20Farm%20Loader.lua"))()
    end
})

Tabs.BZTab:Button({
    Title = "能力gui",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/TheLostStar7/Scripts/refs/heads/main/Slap%20battles%20ability%20gui"))()
    end
})

Tabs.BZTab:Button({
    Title = "米诺斯",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/KietVN02202/KietVN02202/refs/heads/main/MinosPrimeFanMade2.0.lua"))()
    end
})

Tabs.BZTab:Button({
    Title = "弥诺斯",
    Desc = "超级牛逼",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Crossattic/SBS/refs/heads/main/Minos%20Prime%20v1%20BETA"))()
    end
})

Tabs.BZTab:Button({
    Title = "监督者",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/KietVN02202/KietVN02202/refs/heads/main/OVERSEERGlove.txt"))()
    end
})

Tabs.BZTab:Button({
    Title = "戴夫手套",
    Desc = "可叠加别的",
    Callback = function()
loadstring(game:HttpGet('https://pastefy.app/Tau7Gnno/raw'))()
    end
})

Tabs.BZTab:Button({
    Title = "超本能",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/DonjoScripts/Public-Scripts/refs/heads/Slap-Battles/MUI%5BGloveCustom%5D.lua'))()
    end
})

Tabs.BZTab:Button({
    Title = "边缘领主",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/IncognitoScripts/SlapBattles/refs/heads/main/Edgelord"))()
    end
})

Tabs.BZTab:Button({
    Title = "边缘领主v2",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/KietVN02202/KietVN02202/refs/heads/main/FeEdgelord2.0.lua"))()
    end
})

Tabs.BZTab:Button({
    Title = "远程杀戮+巴西",
    Desc = "超级牛逼装备rob手套",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/KietVN02202/KietVN02202/refs/heads/main/SlapBattlesIdkWhatToNameIt.lua"))()
    end
})

Tabs.BZTab:Button({
    Title = "超级人类",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/IncognitoScripts/SlapBattles/main/GodHuman", true))()
    end
})  

Tabs.BZTab:Button({
    Title = "查拉技能组",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/CelerityRBLX/Roblox/refs/heads/main/Slap%20Battles/Chara.lua"))();
    end
})

Tabs.BZTab:Button({
    Title = "冰霜神",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://pastefy.app/LYJzX6un/raw"))();
    end
})

Tabs.BZTab:Button({
    Title = "表情动作",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/KietVN02202/KietVN02202/refs/heads/main/FeEmote.lua"))()
    end
})

Tabs.BZTab:Button({
    Title = "sans手套",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/IncognitoScripts/SlapBattles/main/SansComeback", true))()
    end
})

Tabs.BZTab:Button({
    Title = "哨声",
    Desc = "可以炸服",
    Callback = function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/Umbrella-Scripter/Slap-Battles/refs/heads/main/F.L.O.W.E.R.lua'))()
    end
})

Tabs.BZTab:Button({
    Title = "500连杀",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/KietVN02202/KietVN02202/refs/heads/main/FEcustom500killstreak.lua"))()
    end
})

Tabs.ZQTab:Button({
    Title = "索尼克",
    Desc = "使用英雄猎人",
    Callback = function()
loadstring(game:HttpGet("https://pastefy.app/4zLt8a2P/raw"))()
    end
})

Tabs.ZQTab:Button({
    Title = "悟空",
    Desc = "动画",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/IdkRandomUsernameok/PublicAssets/refs/heads/main/Releases/MUI.lua"))()
    end
})

Tabs.ZQTab:Button({
    Title = "超强",
    Desc = "忍者注入器才能用",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Reapvitalized/TSB/refs/heads/main/SG_DEMO.lua"))()
    end
})

Tabs.ZQTab:Button({
    Title = "月光",
    Desc = "用格斗家",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/SlimJimShady/sungjin/refs/heads/main/Protected_7329509552810618.lua.txt"))()
    end
})

Tabs.ZQTab:Button({
    Title = "须久那",
    Desc = "装备琦玉",
    Callback = function()
loadstring(game:HttpGet("https://pastefy.app/3dQB5Mv5/raw"))();
    end
})

Tabs.ZQTab:Button({
    Title = "加百列",
    Desc = "装备英雄猎人",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/damir512/youinsinificants/main/insignificantFuck.txt",true))()
    end
})

Tabs.ZQTab:Button({
    Title = "狼牙",
    Desc = "装备琦玉",
    Callback = function()
loadstring(game:HttpGet("https://gist.githubusercontent.com/GoldenHeads2/f66279000c58a020e894a6db44914838/raw/62e53e1acacec0b38b43cd0f594292c32e09c39b/gistfile1.txt"))()
    end
})

Tabs.ZQTab:Button({
    Title = "黄金",
    Desc = "使用琦玉",
    Callback = function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/Kenjihin69/Kenjihin69/refs/heads/main/Saitama%20to%20golden%20sigma'))()
    end
})

Tabs.ZQTab:Button({
    Title = "狼牙",
    Desc = "装备琦玉",
    Callback = function()
loadstring(game:HttpGet("https://gist.githubusercontent.com/GoldenHeads2/f66279000c58a020e894a6db44914838/raw/62e53e1acacec0b38b43cd0f594292c32e09c39b/gistfile1.txt"))()
    end
})

Tabs.ZQTab:Button({
    Title = "光的速度",
    Desc = "装备琦玉",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Nova2ezz/west/refs/heads/main/Protected_4638864115822087.lua.txt"))()
    end
})

Tabs.ZQTab:Button({
    Title = "夜神月",
    Desc = "装备英雄猎人",
    Callback = function()
loadstring(game:HttpGet("https://gist.githubusercontent.com/GoldenHeads2/35ca43410a2e96102f73dca904137973/raw/c4cb113194c35e0439151b06ea82dcc8053ff2c3/gistfile1.txt"))()
    end
})

Tabs.ZQTab:Button({
    Title = "火车头",
    Desc = "装备英雄猎人",
    Callback = function()
getgenv().settings = {
    ["morph"] = {
        ["enabled"] = false,
        ["dontchangeskincolor"] = false,
    },
    ["ult_forcewalkspeed"] = true, -- forces walkspeed even if set to 0
    ["ult_walkspeed"] = 64, -- how fast you walk in ult
    ["tp_duration"] = 0.15 -- how long it takes to tp
} 

loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ATrainSounds/refs/heads/main/ATrain.lua"))()
    end
})

Tabs.ZQTab:Button({
    Title = "45%",
    Desc = "装备英雄猎人",
    Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/xKextYP5"))()
    end
})

Tabs.ZQTab:Button({
    Title = "真人",
    Desc = "装备琦玉",
    Callback = function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/Kenjihin69/Kenjihin69/refs/heads/main/Mahito%20v2%20sigma%20tp%20exploit'))()
    end
})

Tabs.ZQTab:Button({
    Title = "火影忍者",
    Desc = "三个角色",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/LolnotaKid/SCRIPTSBYVEUX/refs/heads/main/BoombasticLol.lua.txt"))()
    end
})

Tabs.ZQTab:Button({
    Title = "米诺斯",
    Desc = "装备英雄猎人",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/S1gmaGuy/MinosPrimeFixed/refs/heads/main/ThefixIsSoSigma"))()
    end
})

Tabs.CSJTab:Button({
    Title = "AK47",
    Desc = "AK47",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/AK-47"))()
    end
})

Tabs.CSJTab:Button({
    Title = "封禁之锤",
    Desc = "ban",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Ban%20Hammer"))()
    end
})

Tabs.CSJTab:Button({
    Title = "放逐者",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Banisher"))()
    end
})

Tabs.CSJTab:Button({
    Title = "亲爱的姐妹",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Dearsister"))()
    end
})

Tabs.CSJTab:Button({
    Title = "大风战士",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Gale%20Fighter"))()
    end
})

Tabs.CSJTab:Button({
    Title = "死",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Goner"))()
    end
})

Tabs.CSJTab:Button({
    Title = "好警察坏警察",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Good%20Cop%20Bad%20Cop"))()
    end
})

Tabs.CSJTab:Button({
    Title = "卡兰比特",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Karambit"))()
    end
})

Tabs.CSJTab:Button({
    Title = "闪电炮",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Lightning%20Cannon"))()
    end
})

Tabs.CSJTab:Button({
    Title = "连身剑",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Linked%20Sword"))()
    end
})

Tabs.CSJTab:Button({
    Title = "转轮机枪",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Minigun"))()
    end
})

Tabs.CSJTab:Button({
    Title = "摩托车",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Motorcycle"))()
    end
})

Tabs.CSJTab:Button({
    Title = "海王星五号",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Neptunian%20V"))()
    end
})

Tabs.CSJTab:Button({
    Title = "傀儡师",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Puppet%20Master"))()
    end
})

Tabs.CSJTab:Button({
    Title = "虐待狂种族灭绝",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Sadist%20Genocider"))()
    end
})

Tabs.CSJTab:Button({
    Title = "罪恶龙",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Sin%20Dragon"))()
    end
})

Tabs.CSJTab:Button({
    Title = "狙击手",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Sniper"))()
    end
})

Tabs.CSJTab:Button({
    Title = "工作室假人",
    Desc = "",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Studio%20Dummy"))()
    end
})

do
    Tabs.MainTab = Window:Section({Title = "主题设置", Opened = true})
    Tabs.WindowTab = Tabs.MainTab:Tab({ Title = "选择主题", Icon = "zap" })
    Tabs.CreateThemeTab = Tabs.MainTab:Tab({ Title = "自制主题", Icon = "zap" })
end

local themeValues = {}
for name, _ in pairs(WindUI:GetThemes()) do
    table.insert(themeValues, name)
end

local themeDropdown = Tabs.WindowTab:Dropdown({
    Title = "主题选择",
    Multi = false,
    AllowNone = false,
    Value = nil,
    Values = themeValues,
    Callback = function(theme)
        WindUI:SetTheme(theme)
    end
})
themeDropdown:Select(WindUI:GetCurrentTheme())

local ToggleTransparency = Tabs.WindowTab:Toggle({
    Title = "透明切换",
    Callback = function(e)
        Window:ToggleTransparency(e)
    end,
    Value = WindUI:GetTransparency()
})

Tabs.WindowTab:Section({ Title = "保存" })

local fileNameInput = ""
Tabs.WindowTab:Input({
    Title = "配置名输入与处理",
    PlaceholderText = "Enter file name",
    Callback = function(text)
        fileNameInput = text
    end
})

Tabs.WindowTab:Button({
    Title = "保存配置",
    Callback = function()
        if fileNameInput ~= "" then
            SaveFile(fileNameInput, { Transparent = WindUI:GetTransparency(), Theme = WindUI:GetCurrentTheme() })
        end
    end
})

filesDropdown = Tabs.WindowTab:Dropdown({
    Title = "选择配置",
    Multi = false,
    AllowNone = true,
    Values = files,
    Callback = function(selectedFile)
        fileNameInput = selectedFile
    end
})

Tabs.WindowTab:Button({
    Title = "加载配置",
    Callback = function()
        if fileNameInput ~= "" then
            local data = LoadFile(fileNameInput)
            if data then
                WindUI:Notify({
                    Title = "File Loaded",
                    Content = "Loaded data: " .. HttpService:JSONEncode(data),
                    Duration = 5,
                })
                if data.Transparent then 
                    Window:ToggleTransparency(data.Transparent)
                    ToggleTransparency:SetValue(data.Transparent)
                end
                if data.Theme then WindUI:SetTheme(data.Theme) end
            end
        end
    end
})

Tabs.WindowTab:Button({
    Title = "覆盖配置",
    Callback = function()
        if fileNameInput ~= "" then
            SaveFile(fileNameInput, { Transparent = WindUI:GetTransparency(), Theme = WindUI:GetCurrentTheme() })
        end
    end
})

Tabs.WindowTab:Button({
    Title = "列表刷新",
    Callback = function()
        filesDropdown:Refresh(ListFiles())
    end
})

local currentThemeName = WindUI:GetCurrentTheme()
local themes = WindUI:GetThemes()

local ThemeAccent = themes[currentThemeName].Accent
local ThemeOutline = themes[currentThemeName].Outline
local ThemeText = themes[currentThemeName].Text
local ThemePlaceholderText = themes[currentThemeName].Placeholder

function updateTheme()
    WindUI:AddTheme({
        Name = currentThemeName,
        Accent = ThemeAccent,
        Outline = ThemeOutline,
        Text = ThemeText,
        Placeholder = ThemePlaceholderText
    })
    WindUI:SetTheme(currentThemeName)
end

local CreateInput = Tabs.CreateThemeTab:Input({
    Title = "主题名字",
    Value = currentThemeName,
    Callback = function(name)
        currentThemeName = name
    end
})

Tabs.CreateThemeTab:Colorpicker({
    Title = "背景色配置",
    Default = Color3.fromHex(ThemeAccent),
    Callback = function(color)
        ThemeAccent = color:ToHex()
    end
})

Tabs.CreateThemeTab:Colorpicker({
    Title = "轮廓颜色选择",
    Default = Color3.fromHex(ThemeOutline),
    Callback = function(color)
        ThemeOutline = color:ToHex()
    end
})

Tabs.CreateThemeTab:Colorpicker({
    Title = "文本颜色选择",
    Default = Color3.fromHex(ThemeText),
    Callback = function(color)
        ThemeText = color:ToHex()
    end
})

Tabs.CreateThemeTab:Colorpicker({
    Title = "文本颜色配置",
    Default = Color3.fromHex(ThemePlaceholderText),
    Callback = function(color)
        ThemePlaceholderText = color:ToHex()
    end
})

Tabs.CreateThemeTab:Button({
    Title = "主题更新",
    Callback = function()
        updateTheme()
    end
})

do
   Tabs.MainTab = Window:Section({Title = "导航", Opened = true})
   Tabs.kkkTab = Tabs.MainTab:Tab({ Title = "簧片导航", Icon = "zap" })
   Tabs.MXTab = Tabs.MainTab:Tab({ Title = "鸣谢名单", Icon = "zap" })
   Tabs.YPTab = Tabs.MainTab:Tab({ Title = "约炮热线", Icon = "zap" })
   Tabs.JBTab = Tabs.MainTab:Tab({ Title = "脚本", Icon = "zap" })
end

Tabs.kkkTab:Paragraph({
    Title = "p站",
    Desc = "全球最大成人网站",
    Image = "github",
    ImageSize = 20,
    Color = "Grey",
    Buttons = {
        {
            Title = "点击复制",
            Icon = "copy",
            Variant = "Tertiary",
            Callback = function()
                setclipboard("https://cn.pornhub.com/")
                WindUI:Notify({
                    Title = "复制!",
                    Content = "群1057168892",
                    Duration = 2
                })
            end
        }
    }
})

Tabs.kkkTab:Paragraph({
    Title = "xvideos",
    Desc = "第二大",
    Image = "github",
    ImageSize = 20,
    Color = "Grey",
    Buttons = {
        {
            Title = "点击复制",
            Icon = "copy",
            Variant = "Tertiary",
            Callback = function()
                setclipboard("https://www.xvideos.com/")
                WindUI:Notify({
                    Title = "复制!",
                    Content = "群1057168892",
                    Duration = 2
                })
            end
        }
    }
})

Tabs.kkkTab:Paragraph({
    Title = "51吃瓜",
    Desc = "骚",
    Image = "github",
    ImageSize = 20,
    Color = "Grey",
    Buttons = {
        {
            Title = "点击复制",
            Icon = "copy",
            Variant = "Tertiary",
            Callback = function()
                setclipboard("https://www.jdxafwa.cc/category/rdsj/")
                WindUI:Notify({
                    Title = "复制!",
                    Content = "群1057168892",
                    Duration = 2
                })
            end
        }
    }
})

Tabs.kkkTab:Paragraph({
    Title = "51爆料",
    Desc = "和51吃瓜不是一个",
    Image = "github",
    ImageSize = 20,
    Color = "Grey",
    Buttons = {
        {
            Title = "点击复制",
            Icon = "copy",
            Variant = "Tertiary",
            Callback = function()
                setclipboard("https://album.abmdihw.cc/")
                WindUI:Notify({
                    Title = "复制!",
                    Content = "群1057168892",
                    Duration = 2
                })
            end
        }
    }
})

Tabs.kkkTab:Paragraph({
    Title = "成人韩漫网站",
    Desc = "这个是真的好看",
    Image = "github",
    ImageSize = 20,
    Color = "Grey",
    Buttons = {
        {
            Title = "点击复制",
            Icon = "copy",
            Variant = "Tertiary",
            Callback = function()
                setclipboard("https://manhwa-raw.com/")
                WindUI:Notify({
                    Title = "复制!",
                    Content = "群1057168892",
                    Duration = 2
                })
            end
        }
    }
})

Tabs.kkkTab:Paragraph({
    Title = "acg黄油",
    Desc = "撸撸撸",
    Image = "github",
    ImageSize = 20,
    Color = "Grey",
    Buttons = {
        {
            Title = "点击复制",
            Icon = "copy",
            Variant = "Tertiary",
            Callback = function()
                setclipboard("https://www.2gouacg.com/")
                WindUI:Notify({
                    Title = "复制!",
                    Content = "群1057168892",
                    Duration = 2
                })
            end
        }
    }
})

Tabs.kkkTab:Paragraph({
    Title = "xhamster",
    Desc = "第三大",
    Image = "github",
    ImageSize = 20,
    Color = "Grey",
    Buttons = {
        {
            Title = "点击复制",
            Icon = "copy",
            Variant = "Tertiary",
            Callback = function()
                setclipboard("https://xhamster.com/?ref=porndude")
                WindUI:Notify({
                    Title = "复制!",
                    Content = "群1057168892",
                    Duration = 2
                })
            end
        }
    }
})

Tabs.kkkTab:Paragraph({
    Title = "onlyfans",
    Desc = "不用多说",
    Image = "github",
    ImageSize = 20,
    Color = "Grey",
    Buttons = {
        {
            Title = "点击复制",
            Icon = "copy",
            Variant = "Tertiary",
            Callback = function()
                setclipboard("https://onlyfans.com/")
                WindUI:Notify({
                    Title = "复制!",
                    Content = "群1057168892",
                    Duration = 2
                })
            end
        }
    }
})

Tabs.kkkTab:Paragraph({
    Title = "r34",
    Desc = "基本啥都有",
    Image = "github",
    ImageSize = 20,
    Color = "Grey",
    Buttons = {
        {
            Title = "点击复制",
            Icon = "copy",
            Variant = "Tertiary",
            Callback = function()
                setclipboard("https://rule34.xxx/")
                WindUI:Notify({
                    Title = "复制!",
                    Content = "群1057168892",
                    Duration = 2
                })
            end
        }
    }
})

Tabs.kkkTab:Paragraph({
    Title = "COSplay",
    Desc = "基本上都是糖心的",
    Image = "github",
    ImageSize = 20,
    Color = "Grey",
    Buttons = {
        {
            Title = "点击复制",
            Icon = "copy",
            Variant = "Tertiary",
            Callback = function()
                setclipboard("https://rapidtai.com/cn/tag/Cosplay")
                WindUI:Notify({
                    Title = "复制!",
                    Content = "群1057168892",
                    Duration = 2
                })
            end
        }
    }
})

Tabs.MXTab:Paragraph({
    Title = "冷寂",
    Desc = "大红眼睛的恩情还不完",
    Image = "github",
    ImageSize = 20,
    Color = "Grey",
    Buttons = {
        {
            Title = "点击复制",
            Icon = "copy",
            Variant = "Tertiary",
            Callback = function()
                setclipboard("2893403284")
                WindUI:Notify({
                    Title = "复制!",
                    Content = "群1057168892",
                    Duration = 2
                })
            end
        }
    }
})

Tabs.MXTab:Paragraph({
    Title = "唐尧",
    Desc = "提供了自动发言和坐标仪",
    Image = "github",
    ImageSize = 20,
    Color = "Grey",
    Buttons = {
        {
            Title = "点击复制",
            Icon = "copy",
            Variant = "Tertiary",
            Callback = function()
                setclipboard("唐尧")
                WindUI:Notify({
                    Title = "复制!",
                    Content = "群1057168892",
                    Duration = 2
                })
            end
        }
    }
})

Tabs.MXTab:Paragraph({
    Title = "我",
    Desc = "Kenny",
    Image = "github",
    ImageSize = 20,
    Color = "Grey",
    Buttons = {
        {
            Title = "点击复制",
            Icon = "copy",
            Variant = "Tertiary",
            Callback = function()
                setclipboard("1531514159")
                WindUI:Notify({
                    Title = "复制!",
                    Content = "群1057168892",
                    Duration = 2
                })
            end
        }
    }
})

Tabs.YPTab:Paragraph({
    Title = "死爹烂妈傻逼少羽",
    Desc = "为了维护自己狗懒子刷屏狗兄弟背刺我现在还在搬运我的脚本搜不到用强制搜索",
    Image = "github",
    ImageSize = 20,
    Color = "Grey",
    Buttons = {
        {
            Title = "点击复制QQ",
            Icon = "copy",
            Variant = "Tertiary",
            Callback = function()
                setclipboard("3021581385")
                WindUI:Notify({
                    Title = "复制!",
                    Content = "群1057168892",
                    Duration = 2
                })
            end
        }
    }
})

Tabs.YPTab:Paragraph({
    Title = "死爹烂妈瞎骂狗",
    Desc = "傻逼护卫犬",
    Image = "github",
    ImageSize = 20,
    Color = "Grey",
    Buttons = {
        {
            Title = "点击复制QQ",
            Icon = "copy",
            Variant = "Tertiary",
            Callback = function()
                setclipboard("2763820948")
                WindUI:Notify({
                    Title = "复制!",
                    Content = "群1057168892",
                    Duration = 2
                })
            end
        }
    }
})

Tabs.YPTab:Paragraph({
    Title = "死爹烂妈瞎骂狗2",
    Desc = "傻逼护卫犬",
    Image = "github",
    ImageSize = 20,
    Color = "Grey",
    Buttons = {
        {
            Title = "点击复制QQ",
            Icon = "copy",
            Variant = "Tertiary",
            Callback = function()
                setclipboard("318590080")
                WindUI:Notify({
                    Title = "复制!",
                    Content = "群1057168892",
                    Duration = 2
                })
            end
        }
    }
})

Tabs.JBTab:Paragraph({
    Title = "创世纪官方频道",
    Desc = "genesis",
    Image = "github",
    ImageSize = 20,
    Color = "Grey",
    Buttons = {
        {
            Title = "点击复制",
            Icon = "copy",
            Variant = "Tertiary",
            Callback = function()
                setclipboard("http://www.youtube.com/@GENESIS-FE")
                WindUI:Notify({
                    Title = "复制!",
                    Content = "群1057168892",
                    Duration = 2
                })
            end
        }
    }
})

Tabs.JBTab:Paragraph({
    Title = "melon官方频道",
    Desc = "melon",
    Image = "github",
    ImageSize = 20,
    Color = "Grey",
    Buttons = {
        {
            Title = "点击复制",
            Icon = "copy",
            Variant = "Tertiary",
            Callback = function()
                setclipboard("http://www.youtube.com/@MelonScripter")
                WindUI:Notify({
                    Title = "复制!",
                    Content = "群1057168892",
                    Duration = 2
                })
            end
        }
    }
})
