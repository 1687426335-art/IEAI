local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- ==================== 共享数据库 ====================
local BLOB_ID = "YOUR_BLOB_ID_HERE"
local BLOB_URL = "https://jsonblob.com/api/jsonBlob/" .. BLOB_ID
local AUTHOR_UID = "B184E82D"
local AUTHOR_PASSWORD = "177457rrr"

local function GetDeviceUID(userId)
    local str = tostring(userId) .. "wdfex_salt_2026_v1"
    local hash = 0
    for i = 1, #str do hash = (hash * 31 + string.byte(str, i)) % 0xFFFFFFFF end
    return string.format("%08X", hash)
end

local function ReadBlob()
    local ok, res = pcall(function() return HttpService:JSONDecode(game:HttpGet(BLOB_URL)) end)
    if ok and type(res) == "table" then
        res.bans = res.bans or {}; res.chat = res.chat or {}; res.online = res.online or {}
        res.forceQuit = res.forceQuit or {}; res.announcement = res.announcement or {id=0, text=""}
        return res
    end
    return {bans={}, chat={}, online={}, forceQuit={}, announcement={id=0,text=""}}
end

local function WriteBlob(data)
    pcall(function()
        HttpService:RequestAsync({Url=BLOB_URL, Method="PUT",
            Headers={["Content-Type"]="application/json"}, Body=HttpService:JSONEncode(data)})
    end)
end

local myDeviceUID = GetDeviceUID(player.UserId)
local isAuthor = (myDeviceUID == AUTHOR_UID)
local lastAnnouncementId = 0

-- ==================== 心跳 ====================
task.spawn(function()
    task.wait(3)
    while true do
        local data = ReadBlob()
        data.online[tostring(player.UserId)] = {name=player.Name, uid=myDeviceUID, lastSeen=os.time()}
        for uid, info in pairs(data.online) do
            if os.time() - (info.lastSeen or 0) > 60 then data.online[uid] = nil end
        end
        if data.bans[myDeviceUID] then
            local expire = data.bans[myDeviceUID]
            if os.time() < expire then
                WriteBlob(data)
                player:Kick("设备已被封禁\n解封时间: " .. os.date("%Y-%m-%d %H:%M:%S", expire))
                return
            else data.bans[myDeviceUID] = nil end
        end
        if data.forceQuit[myDeviceUID] then
            data.forceQuit[myDeviceUID] = nil
            WriteBlob(data)
            game:Shutdown()
            return
        end
        if data.announcement.id > lastAnnouncementId and data.announcement.text ~= "" then
            lastAnnouncementId = data.announcement.id
            WindUI:Notify({Title="【公告】", Content=data.announcement.text, Duration=10})
        end
        WriteBlob(data)
        task.wait(5)
    end
end)

-- ==================== 渐变 ====================
local gradientColors = {"rgb(255,230,235)","rgb(255,210,220)","rgb(255,190,205)","rgb(255,170,190)","rgb(255,150,175)","rgb(245,140,180)","rgb(235,130,185)","rgb(225,120,190)","rgb(215,110,195)","rgb(205,100,200)"}
local coloredUsername = ""
for i = 1, #player.Name do
    coloredUsername = coloredUsername .. '<font color="' .. gradientColors[(i-1)%#gradientColors+1] .. '">' .. player.Name:sub(i,i) .. '</font>'
end

WindUI:Popup({
    Title = '<font color="' .. gradientColors[1] .. '">wdf</font><font color="' .. gradientColors[5] .. '">ex</font>',
    IconThemed = true,
    Content = "尊敬的用户 " .. coloredUsername .. "\n脚本已就绪！",
    Buttons = {
        {Title="取消", Callback=function() end, Variant="Secondary"},
        {Title="执行", Icon="arrow-right", Callback=function() createUI() end, Variant="Primary"}
    }
})

function createUI()
    local isDestroyed = false
    local Settings = {HitboxEnabled=false, HitboxSize=10, WhitelistEnabled=false, TeleportEnabled=false}
    local Whitelist = {}; local affectedHeads = {}

    local Window = WindUI:CreateWindow({
        Title='wdfex-Hub', Icon="heart", IconThemed=true, Author="v4.3", Folder="CloudHub",
        Size=UDim2.fromOffset(580,440), Transparent=true, Theme="Dark",
        Background="https://raw.githubusercontent.com/XxwanhexxX/UN/main/preview_png.png",
        BackgroundImageTransparency=0.5,
        User={Enabled=true, Callback=function() end, Anonymous=false}, SideBarWidth=250,
        Search={Enabled=true, Placeholder="搜索...", Callback=function(s) end},
        SidePanel={Enabled=true, Content={{Type="Button", Text="wdfex-Hub", Style="Subtle", Size=UDim2.new(1,-20,0,30), Callback=function() end}}}
    })
    Window:Tag({Title="wdfex脚本NB", Color=Color3.fromHex("#00ffff")})
    Window:EditOpenButton({Title="wdfex-Hub", Icon="rbxassetid://105677776902677", CornerRadius=UDim.new(0,16), StrokeThickness=4, Color=ColorSequence.new(Color3.fromHex("FF6B6B")), Draggable=true})

    -- 顶部滚动
    task.spawn(function()
        pcall(function()
            local bg = Instance.new("ScreenGui"); bg.Name="BannerGui"; bg.ResetOnSpawn=false
            bg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; bg.Parent=player:WaitForChild("PlayerGui")
            local banner = Instance.new("TextLabel")
            banner.Size=UDim2.new(0,220,0,28); banner.Position=UDim2.new(0,-220,0,2)
            banner.BackgroundTransparency=1; banner.Text="倒卖死爸妈"; banner.TextSize=18
            banner.Font=Enum.Font.GothamBold; banner.TextStrokeTransparency=0
            banner.TextStrokeColor3=Color3.fromRGB(0,0,0); banner.Parent=bg
            local hue=0
            RunService.Heartbeat:Connect(function()
                hue=(hue+0.005)%1; banner.TextColor3=Color3.fromHSV(hue,0.9,1)
                banner.TextStrokeColor3=Color3.fromHSV((hue+0.5)%1,1,1)
            end)
            local function anim()
                local t = TweenService:Create(banner, TweenInfo.new(16,Enum.EasingStyle.Linear), {Position=UDim2.new(1,10,0,2)})
                t:Play(); t.Completed:Connect(function() banner.Position=UDim2.new(0,-220,0,2); anim() end)
            end
            task.wait(0.5); anim()
        end)
    end)

    -- ==================== 作者信息 ====================
    local AuthorTab = Window:Tab({Title="作者信息", Icon="user"})
    local AuthorSection = AuthorTab:Section({Title="", Opened=true})
    AuthorSection:Paragraph({Title="", Desc="", Thumbnail="rbxassetid://74369447499630", ThumbnailSize=150, ThumbnailShape="Square"})
    AuthorSection:Paragraph({Title="作者：wdfex", Desc=""})
    AuthorSection:Paragraph({Title="作者QQ：1687426335", Desc=""})
    AuthorSection:Paragraph({Title="此脚本仅wdfex一人开发其他均为假的", Desc=""})
    AuthorSection:Paragraph({Title="我的设备UID", Desc=myDeviceUID})

    -- ==================== 用户聊天 ====================
    local ChatTab = Window:Tab({Title="用户聊天", Icon="message-circle"})
    local ChatSection = ChatTab:Section({Title="聊天室", Opened=true})
    local chatDisplay = ChatSection:Paragraph({Title="聊天记录", Desc="加载中..."})
    local chatInput = ""
    ChatSection:Input({Title="输入消息", Placeholder="说点什么...", Callback=function(v) chatInput=v end})
    ChatSection:Button({Title="发送", Callback=function()
        if chatInput=="" then return end
        local data = ReadBlob()
        table.insert(data.chat, {name=player.Name, uid=myDeviceUID, msg=chatInput, time=os.time()})
        while #data.chat > 100 do table.remove(data.chat,1) end
        WriteBlob(data); chatInput=""
        WindUI:Notify({Title="聊天", Content="已发送", Duration=2})
    end})
    task.spawn(function()
        while true do
            task.wait(3)
            local data = ReadBlob()
            local lines = {}
            local start = math.max(1, #data.chat - 20)
            for i = start, #data.chat do
                local m = data.chat[i]
                table.insert(lines, "【" .. m.name .. " - " .. m.uid .. "】\n" .. m.msg .. "\n")
            end
            local text = #lines > 0 and table.concat(lines, "\n") or "暂无消息"
            pcall(function() chatDisplay:SetDesc(text) end)
        end
    end)

    -- ==================== 通知 ====================
    local infoTab = Window:Tab({Title="通知", Icon="layout-grid"})
    local infoSection = infoTab:Section({Title="详情信息", Opened=true})
    infoSection:Paragraph({Title="关于", Desc="此脚本永久免费请勿相信任何人"})
    infoSection:Paragraph({Title="更新提示", Desc="更新警察功能\n更新自动手铐\n更新甩飞传送\nQQ：1687426335"})
    infoTab:Select(); AuthorTab:Select()

    -- ==================== 主功能 ====================
    local MainSection = Window:Section({Title="主功能", Opened=true})
    local function AddTab(s,t,i) return s:Tab({Title=t, Icon=i}) end
    local A = AddTab(MainSection, "玩家修改", "user")
    local FlyTab = AddTab(MainSection, "飞天与加速", "plane")
    local RemoteBuyTab = AddTab(MainSection, "远程购买", "shopping-cart")
    local InteractTab = AddTab(MainSection, "互动", "hand")
    local PoliceTab = AddTab(MainSection, "警察功能", "shield")
    local DoctorTab = AddTab(MainSection, "医生功能", "heart-pulse")
    local B = AddTab(MainSection, "枪械功能", "target")
    local C = AddTab(MainSection, "杀戮光环", "skull")
    local D = AddTab(MainSection, "传送点", "map-pin")
    local E = AddTab(MainSection, "透视", "eye")
    local PoliceDodgeTab = AddTab(MainSection, "自动躲警察", "shield")

    -- ==================== 远程购买 ====================
    RemoteBuyTab:Divider({Text="黑市购买"})
    local toolItems = {{name="解密电路",id="1",itemName="Decryption Circuit"},{name="撬锁装置",id="2",itemName="Lockpick Device"},{name="入侵工具",id="3",itemName="Hacking Tool"},{name="C4",id="4",itemName="C4"},{name="绿色USB",id="5",itemName="Green USB"},{name="工作人员涂鸦",id="8",itemName="Crew Graffiti"}}
    local toolNameOptions = {}; for _,v in ipairs(toolItems) do table.insert(toolNameOptions, v.name) end
    local selectedToolItem = toolNameOptions[1]
    RemoteBuyTab:Dropdown({Title="工具", Values=toolNameOptions, Value=toolNameOptions[1], Callback=function(v) selectedToolItem=v end})
    RemoteBuyTab:Button({Title="购买", Callback=function()
        local event = ReplicatedStorage:FindFirstChild("Remote") and ReplicatedStorage.Remote:FindFirstChild("PlayerFunc")
        local stuff = ReplicatedStorage:FindFirstChild("Stuff")
        if event and stuff then
            local bm = stuff:FindFirstChild("Black Market"); local target, dn = nil, ""
            if bm then for _,info in ipairs(toolItems) do if info.name==selectedToolItem then
                local slot = bm:FindFirstChild(info.id); if slot then target=slot:FindFirstChild(info.itemName); dn=info.name end; break end end end
            if target then local ok = pcall(function() event:InvokeServer("purchase", {isRestaurant=false, item=target}) end)
                if ok then WindUI:Notify({Title="购买成功", Content=dn, Duration=3}) end
            else WindUI:Notify({Title="购买失败", Content="没找到", Duration=3}) end
        end
    end})
    RemoteBuyTab:Divider({Text="武器"})
    local weaponItems = {{name="洛克17",id="5",itemName="Glock 17"},{name="战斧",id="2",itemName="Battle Axe"},{name="球棒",id="3",itemName="Bat"},{name="大砍刀",id="4",itemName="Machete"},{name="小刀",id="1",itemName="Knife"}}
    local weaponNames = {}; for _,v in ipairs(weaponItems) do table.insert(weaponNames, v.name) end
    local selectedWeapon = weaponNames[1]
    RemoteBuyTab:Dropdown({Title="武器", Values=weaponNames, Value=weaponNames[1], Callback=function(v) selectedWeapon=v end})
    RemoteBuyTab:Button({Title="购买", Callback=function()
        local event = ReplicatedStorage:FindFirstChild("Remote") and ReplicatedStorage.Remote:FindFirstChild("PlayerFunc")
        local stuff = ReplicatedStorage:FindFirstChild("Stuff")
        if event and stuff then
            local wf = stuff:FindFirstChild("Weapons"); local target, dn = nil, ""
            if wf then for _,info in ipairs(weaponItems) do if info.name==selectedWeapon then
                local slot = wf:FindFirstChild(info.id); if slot then target=slot:FindFirstChild(info.itemName); dn=info.name end; break end end end
            if target then local ok = pcall(function() event:InvokeServer("purchase", {isRestaurant=false, item=target}) end)
                if ok then WindUI:Notify({Title="购买成功", Content=dn, Duration=3}) end
            else WindUI:Notify({Title="购买失败", Content="没找到", Duration=3}) end
        end
    end})
    RemoteBuyTab:Divider({Text="超市物品"})
    local superItems = {{name="望远镜",itemName="Binoculars"},{name="金属探测器",itemName="Metal Detector"},{name="铲子",itemName="Trowel"},{name="新闻摄像头",itemName="News Camera"},{name="新闻麦克风",itemName="News Microphone"},{name="雨伞",itemName="Blue Umbrella"},{name="钓鱼杆",itemName="Fishing Rod"}}
    local superNames = {}; for _,v in ipairs(superItems) do table.insert(superNames, v.name) end
    local selectedSuper = superNames[1]
    RemoteBuyTab:Dropdown({Title="超市物品", Values=superNames, Value=superNames[1], Callback=function(v) selectedSuper=v end})
    RemoteBuyTab:Button({Title="购买", Callback=function()
        local event = ReplicatedStorage:FindFirstChild("Remote") and ReplicatedStorage.Remote:FindFirstChild("PlayerFunc")
        local stuff = ReplicatedStorage:FindFirstChild("Stuff")
        if event and stuff then
            local items = stuff:FindFirstChild("Items"); local target, dn = nil, ""
            if items then for _,info in ipairs(superItems) do if info.name==selectedSuper then target=items:FindFirstChild(info.itemName); dn=info.name; break end end end
            if target then pcall(function() event:InvokeServer("purchase", {isRestaurant=false, item=target}) end)
                WindUI:Notify({Title="购买成功", Content=dn, Duration=3})
            else WindUI:Notify({Title="购买失败", Content="没找到", Duration=3}) end
        end
    end})
    RemoteBuyTab:Divider({Text="食物"})
    local foodItems = {{name="培根和鸡蛋",itemName="Bacon And Eggs"},{name="面条",itemName="Spaghetti"},{name="鸡肉和薯条",itemName="Chicken And Fries"},{name="沙拉",itemName="Salad"},{name="豆汁",itemName="Bean Soup"},{name="松饼卷",itemName="Croissant"},{name="煎饼",itemName="Pancake"},{name="冰茶",itemName="Iced Tea"},{name="一盒牛奶",itemName="Box Of Milk"}}
    local foodNames = {}; for _,v in ipairs(foodItems) do table.insert(foodNames, v.name) end
    local selectedFood = foodNames[1]
    RemoteBuyTab:Dropdown({Title="食物", Values=foodNames, Value=foodNames[1], Callback=function(v) selectedFood=v end})
    RemoteBuyTab:Button({Title="购买", Callback=function()
        local event = ReplicatedStorage:FindFirstChild("Remote") and ReplicatedStorage.Remote:FindFirstChild("PlayerFunc")
        local stuff = ReplicatedStorage:FindFirstChild("Stuff")
        if event and stuff then
            local ff = stuff:FindFirstChild("Food"); local target, dn = nil, ""
            if ff then for _,info in ipairs(foodItems) do if info.name==selectedFood then target=ff:FindFirstChild(info.itemName); dn=info.name; break end end end
            if target then pcall(function() event:InvokeServer("purchase", {isRestaurant=true, quantity=1, item=target}) end)
                WindUI:Notify({Title="购买成功", Content=dn, Duration=3})
            else WindUI:Notify({Title="购买失败", Content="没找到", Duration=3}) end
        end
    end})

    -- ==================== 互动 & 警察 ====================
    local fastInteractEnabled, autoInteractEnabled, autoCuffEnabled = false, false, false
    game.ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt) if fastInteractEnabled then prompt.HoldDuration=0 end end)
    InteractTab:Divider({Text="互动功能"})
    InteractTab:Toggle({Title="快速互动", Value=false, Callback=function(v) fastInteractEnabled=v end})
    InteractTab:Toggle({Title="自动互动", Value=false, Callback=function(v) autoInteractEnabled=v end})
    InteractTab:Divider({Text="自动捡钱"})
    local autoCashEnabled = false
    InteractTab:Toggle({Title="自动捡钱", Value=false, Callback=function(v) autoCashEnabled=v end})

    PoliceTab:Divider({Text="自动手铐"})
    PoliceTab:Divider({Text="自动点护送"})
    local autoEscortEnabled = false
    PoliceTab:Toggle({Title="自动手铐", Value=false, Callback=function(v) autoCuffEnabled=v end})
    PoliceTab:Toggle({Title="自动点护送", Value=false, Callback=function(v) autoEscortEnabled=v end})
    PoliceTab:Divider({Text="传送与甩飞"})

    local PlayerConfig = {playernamedied=nil, dropdown={}, LoopTeleport=false, LoopTeleportBack=false, LoopFling=false}
    local function shuaxinlb()
        local list = {}; for _,p in ipairs(Players:GetPlayers()) do if p~=player then table.insert(list, p.Name) end end
        table.sort(list); PlayerConfig.dropdown=list
    end
    shuaxinlb()
    local playerDropdown = PoliceTab:Dropdown({Title="选择玩家名称", Values=PlayerConfig.dropdown, Value=PlayerConfig.dropdown[1] or "无", Callback=function(v) PlayerConfig.playernamedied=v end})
    local searchNameInput = ""
    PoliceTab:Input({Title="搜索玩家名字", Placeholder="输入后点击搜索", Callback=function(v) searchNameInput=v end})
    PoliceTab:Button({Title="搜索并选中玩家", Callback=function()
        if searchNameInput=="" then return end
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=player and (p.Name:lower():find(searchNameInput:lower(),1,true) or p.DisplayName:lower():find(searchNameInput:lower(),1,true)) then
                PlayerConfig.playernamedied=p.Name; if playerDropdown then pcall(function() playerDropdown:SetValue(p.Name) end) end
                WindUI:Notify({Title="已选中", Content=p.Name, Duration=3}); return
            end
        end
        WindUI:Notify({Title="未找到", Content="", Duration=3})
    end})
    PoliceTab:Button({Title="传送到玩家旁边", Callback=function()
        local t = Players:FindFirstChild(PlayerConfig.playernamedied or "")
        if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
            local r = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if r then r.CFrame = t.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0) end
        end
    end})
    PoliceTab:Toggle({Title="循环锁定传送", Value=false, Callback=function(en)
        PlayerConfig.LoopTeleport=en
        if en then task.spawn(function() while PlayerConfig.LoopTeleport and not isDestroyed do
            local t = Players:FindFirstChild(PlayerConfig.playernamedied or "")
            local r = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") and r then
                r.CFrame = t.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
            end
            task.wait(0.1)
        end end) end
    end})
    PoliceTab:Button({Title="把玩家传送过来", Callback=function()
        local t = Players:FindFirstChild(PlayerConfig.playernamedied or "")
        if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
            local r = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if r then t.Character.HumanoidRootPart.CFrame = r.CFrame + Vector3.new(0,3,0) end
        end
    end})
    PoliceTab:Toggle({Title="循环传送玩家过来", Value=false, Callback=function(en)
        PlayerConfig.LoopTeleportBack=en
        if en then task.spawn(function() while PlayerConfig.LoopTeleportBack and not isDestroyed do
            local t = Players:FindFirstChild(PlayerConfig.playernamedied or "")
            local r = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") and r then
                t.Character.HumanoidRootPart.CFrame = r.CFrame + Vector3.new(0,3,0)
            end
            task.wait(0.1)
        end end) end
    end})
    PoliceTab:Toggle({Title="查看玩家", Value=false, Callback=function(en)
        if en then local t = Players:FindFirstChild(PlayerConfig.playernamedied or "")
            if t and t.Character then local h = t.Character:FindFirstChildOfClass("Humanoid")
                if h then workspace.CurrentCamera.CameraSubject=h end end
        else local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if h then workspace.CurrentCamera.CameraSubject=h end end
    end})
    local function ThrowPlayer(tp)
        local tc=tp.Character; if not tc then return end
        local tr=tc:FindFirstChild("HumanoidRootPart"); if not tr then return end
        local mc=player.Character; if not mc then return end
        local mr=mc:FindFirstChild("HumanoidRootPart"); if not mr then return end
        local old=workspace.FallenPartsDestroyHeight; workspace.FallenPartsDestroyHeight=-math.huge
        local bv=Instance.new("BodyVelocity"); bv.Name="wdfexFling"; bv.Parent=mr
        bv.Velocity=Vector3.new(9e8,9e8,9e8); bv.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
        for i=1,20 do if not tr.Parent or not mr.Parent then break end
            mr.CFrame=tr.CFrame*CFrame.new(0,1.5,0)*CFrame.Angles(math.rad(i*18),0,math.rad(i*18))
            tr.Velocity=Vector3.new(9e8,9e8,9e8); tr.RotVelocity=Vector3.new(9e8,9e8,9e8); task.wait(0.1) end
        bv:Destroy(); workspace.FallenPartsDestroyHeight=old
    end
    PoliceTab:Button({Title="甩飞一次", Callback=function()
        if PlayerConfig.playernamedied then local t=Players:FindFirstChild(PlayerConfig.playernamedied)
            if t then pcall(function() ThrowPlayer(t) end) end end
    end})
    PoliceTab:Toggle({Title="循环甩飞", Value=false, Callback=function(en)
        PlayerConfig.LoopFling=en
        if en then task.spawn(function() while PlayerConfig.LoopFling and not isDestroyed do
            local t=Players:FindFirstChild(PlayerConfig.playernamedied or "")
            if t and t.Character then pcall(function() ThrowPlayer(t) end) end
            task.wait(0.2)
        end end) end
    end})
    PoliceTab:Toggle({Title="开启指定自瞄目标", Value=false, Callback=function(en)
        if en then task.spawn(function() while en and not isDestroyed do
            local cam=workspace.CurrentCamera; local t=Players:FindFirstChild(PlayerConfig.playernamedied or "")
            local tr=t and t.Character and t.Character:FindFirstChild("HumanoidRootPart")
            if tr and cam then cam.CFrame=CFrame.new(cam.CFrame.Position, cam.CFrame.Position+(tr.Position-cam.CFrame.Position).Unit) end
            task.wait(0.1)
        end end) end
    end})

    -- ==================== 医生功能 ====================
    local autoHealEnabled=false; local healRadius=15; local healInterval=0.3
    DoctorTab:Divider({Text="自动治疗"})
    DoctorTab:Toggle({Title="自动治疗", Value=false, Callback=function(v) autoHealEnabled=v end})
    DoctorTab:Slider({Title="检测范围", Step=1, Value={Min=5,Max=50,Default=15}, Callback=function(v) healRadius=v end})
    DoctorTab:Slider({Title="治疗间隔", Step=0.1, Value={Min=0.1,Max=3,Default=0.3}, Callback=function(v) healInterval=v end})
    DoctorTab:Divider({Text="修复物品"})
    DoctorTab:Button({Title="修复MT急救包", Callback=function()
        local e = ReplicatedStorage:FindFirstChild("Remote") and ReplicatedStorage.Remote:FindFirstChild("PlayerFunc")
        if e then local ok = pcall(function() e:InvokeServer("repairReplenishItem", "MT First Aid Kit") end)
            WindUI:Notify({Title="医生功能", Content=ok and "修复成功" or "修复失败", Duration=3}) end
    end})
    DoctorTab:Divider({Text="循环传送低血量玩家"})
    local loopTeleportLowHp=false
    DoctorTab:Toggle({Title="循环传送血量为100以下的玩家", Value=false, Callback=function(en)
        loopTeleportLowHp=en
        if en then task.spawn(function() while loopTeleportLowHp and not isDestroyed do
            local r = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if r then for _,p in ipairs(Players:GetPlayers()) do
                if p~=player and p.Character then local h=p.Character:FindFirstChildOfClass("Humanoid")
                    local tr=p.Character:FindFirstChild("HumanoidRootPart")
                    if h and h.Health<100 and tr then r.CFrame=tr.CFrame+Vector3.new(0,3,0); break end end
            end end
            task.wait(0.1)
        end end) end
    end})
    task.spawn(function() while not isDestroyed do task.wait(healInterval)
        if autoHealEnabled then
            local c=player.Character; local r=c and c:FindFirstChild("HumanoidRootPart"); local kit=c and c:FindFirstChild("MT First Aid Kit")
            if r and kit then for _,p in ipairs(Players:GetPlayers()) do
                if p~=player and p.Character then local h=p.Character:FindFirstChildOfClass("Humanoid")
                    local tr=p.Character:FindFirstChild("HumanoidRootPart")
                    if h and h.Health<h.MaxHealth and tr and (tr.Position-r.Position).Magnitude<=healRadius then
                        for _,o in ipairs(p.Character:GetDescendants()) do if o:IsA("ProximityPrompt") then pcall(function() o.HoldDuration=0; fireproximityprompt(o) end) end end
                        for _,o in ipairs(c:GetDescendants()) do if o:IsA("ProximityPrompt") then pcall(function() o.HoldDuration=0; fireproximityprompt(o) end) end end
                    end end
            end end
        end
    end end)
    task.spawn(function() while not isDestroyed do task.wait(0.05)
        if autoInteractEnabled then for _,d in pairs(workspace:GetDescendants()) do if d:IsA("ProximityPrompt") then pcall(function() fireproximityprompt(d) end) end end end
        if autoCuffEnabled then local c=player.Character; local r=c and c:FindFirstChild("HumanoidRootPart")
            if r then for _,p in ipairs(Players:GetPlayers()) do if p~=player and p.Character then
                local h=p.Character:FindFirstChildOfClass("Humanoid"); local hd=p.Character:FindFirstChild("Head")
                if h and h.Health>0 and hd and (hd.Position-r.Position).Magnitude<15 then
                    local e=ReplicatedStorage:FindFirstChild("Remote") and ReplicatedStorage.Remote:FindFirstChild("PlayerFunc")
                    if e then pcall(function() e:InvokeServer("handcuff", p, false) end); task.wait(0.1) end
                end
            end end end
        end
    end end)
    task.spawn(function() while true do task.wait(0.1)
        if autoEscortEnabled then local c=player.Character; local r=c and c:FindFirstChild("HumanoidRootPart")
            if r then for _,p in ipairs(Players:GetPlayers()) do if p~=player and p.Character then
                local h=p.Character:FindFirstChildOfClass("Humanoid"); local hd=p.Character:FindFirstChild("Head")
                if h and h.Health>0 and hd and (hd.Position-r.Position).Magnitude<15 then
                    local e=ReplicatedStorage:FindFirstChild("Remote") and ReplicatedStorage.Remote:FindFirstChild("PlayerFunc")
                    if e then pcall(function() e:InvokeServer("escortPlayer", "Arrested", p) end); task.wait(0.1) end
                end
            end end end
        end
    end end)
    task.spawn(function() while not isDestroyed do task.wait(0.1)
        if autoCashEnabled then
            local e=ReplicatedStorage:FindFirstChild("Remote") and ReplicatedStorage.Remote:FindFirstChild("PlayerFunc")
            if e then local found=false
                if getnilinstances then for _,o in ipairs(getnilinstances()) do if o.Name=="CashDrop" then pcall(function() e:InvokeServer("cashDrop", o) end); found=true end end end
                if not found then for _,o in ipairs(workspace:GetDescendants()) do if o.Name=="CashDrop" then pcall(function() e:InvokeServer("cashDrop", o) end) end end end
                if not found then for _,d in pairs(workspace:GetDescendants()) do if d:IsA("ProximityPrompt") then pcall(function() d.HoldDuration=0; fireproximityprompt(d) end) end end end
            end
        end
    end end)

    -- ==================== 玩家修改 ====================
    local function ApplyHitbox()
        if not Settings.HitboxEnabled then return end
        local newAff={}
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=player and p.Character and not (Settings.WhitelistEnabled and Whitelist[p.UserId]) then
                local c=p.Character; local hd=c:FindFirstChild("Head"); local h=c:FindFirstChildOfClass("Humanoid")
                if h and h.Health>0 and hd then hd.Size=Vector3.new(Settings.HitboxSize,Settings.HitboxSize,Settings.HitboxSize); hd.Transparency=1; newAff[hd]=true end
            end
        end
        for hd,_ in pairs(affectedHeads) do if not newAff[hd] and hd and hd.Parent then hd.Size=Vector3.new(2,1,1); hd.Transparency=0 end end
        affectedHeads=newAff
    end
    local function ResetHitbox() for hd,_ in pairs(affectedHeads) do if hd and hd.Parent then hd.Size=Vector3.new(2,1,1); hd.Transparency=0 end end; affectedHeads={} end
    local godOn=false; local staminaOn=false
    A:Toggle({Title="免疫部分伤害", Value=false, Callback=function(v) godOn=v end})
    A:Divider({Text="穿墙"})
    A:Toggle({Title="启用人物穿墙", Value=false, Callback=function(v)
        local c=player.Character; if c then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=not v end end end
    end})
    A:Divider({Text="体力"})
    local oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local m=getnamecallmethod(); local a={...}
        if m=="FireServer" then
            if staminaOn then if a[1]=="setStaminaOrFood" and a[2]=="stamina" then a[3]=9999999; return oldNamecall(self, unpack(a)) end end
            if godOn and type(a[1])=="string" and a[1]=="takeDamage" then return end
        end
        return oldNamecall(self, ...)
    end)
    task.spawn(function() while not isDestroyed do
        if staminaOn then pcall(function()
            for _,o in ipairs(player:GetDescendants()) do if (o:IsA("NumberValue") or o:IsA("IntValue")) and (o.Name:lower():find("stamina") or o.Name:lower():find("energy")) then o.Value=9999999 end end
            local r=ReplicatedStorage:FindFirstChild("Remote"); if r then local pe=r:FindFirstChild("PlayerEvent"); if pe then pcall(function() pe:FireServer("setStaminaOrFood","stamina",9999999) end) end end
        end) end
        task.wait(0.15)
    end end)
    A:Toggle({Title="无限体力", Value=false, Callback=function(v) staminaOn=v end})
    A:Divider({Text="防甩飞"})
    A:Toggle({Title="防甩飞", Value=false, Callback=function(v)
        if v then task.spawn(function() while true do task.wait(0.1)
            local c=player.Character; local r=c and c:FindFirstChild("HumanoidRootPart")
            if r and (r.Velocity.Magnitude>500 or math.abs(r.Velocity.Y)>300) then r.Velocity=Vector3.new(0,0,0); r.RotVelocity=Vector3.new(0,0,0) end
        end end) end
    end})
    A:Divider({Text="防摔"})
    local antiFall=false
    A:Toggle({Title="防摔", Value=false, Callback=function(v) antiFall=v end})
    task.spawn(function() while not isDestroyed do task.wait(0.1)
        if antiFall then local r=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if r and r.Velocity.Y<-20 then r.Velocity=Vector3.new(r.Velocity.X, math.clamp(r.Velocity.Y,-40,-10), r.Velocity.Z) end end
    end end)
    A:Divider({Text="碰飞"})
    A:Button({Title="碰飞", Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/0Ben1/fe./main/Fling%20GUI"))()
    end})

    -- ==================== 枪械 ====================
    B:Divider({Text="枪械强化"})
    B:Toggle({Title="超快射速", Value=false, Callback=function(v)
        if not v then return end
        for _,tbl in pairs(getgc(true)) do if type(tbl)=="table" then
            if rawget(tbl,"SHOOT_MODE") then rawset(tbl,"SHOOT_MODE",2) end
            if rawget(tbl,"RPM") then rawset(tbl,"RPM",math.huge) end
            if rawget(tbl,"DAMAGE") then rawset(tbl,"DAMAGE",math.huge) end
        end end
    end})
    local infAmmo=false
    B:Toggle({Title="无限子弹", Value=false, Callback=function(v) infAmmo=v end})
    task.spawn(function() while not isDestroyed do
        if infAmmo then local cf=Workspace:FindFirstChild("Characters") and Workspace.Characters:FindFirstChild(player.Name)
            if cf then for _,g in ipairs(cf:GetChildren()) do local cfg=g:FindFirstChild("Config")
                if cfg then local a=cfg:FindFirstChild("Ammo"); local ta=cfg:FindFirstChild("TotalAmmo")
                    if a then a.Value=math.huge end; if ta then ta.Value=math.huge end
                end
            end end
        end
        RunService.Heartbeat:Wait()
    end end)
    B:Divider({Text="碰撞箱扩展"})
    B:Toggle({Title="启用头部碰撞箱", Value=false, Callback=function(v) Settings.HitboxEnabled=v; if v then ApplyHitbox() else ResetHitbox() end end})
    B:Slider({Title="头部大小", Step=1, Value={Min=5,Max=400,Default=10}, Callback=function(v) Settings.HitboxSize=v; if Settings.HitboxEnabled then ApplyHitbox() end end})
    B:Toggle({Title="好友检测(白名单)", Value=false, Callback=function(v) Settings.WhitelistEnabled=v end})

    B:Divider({Text="子追"})
    local zzOn, zzDist, zzAff = false, 40, nil
    task.spawn(function() while not isDestroyed do
        if zzOn then local c=player.Character; local r=c and c:FindFirstChild("HumanoidRootPart")
            local best, bd = nil, zzDist
            if r then for _,p in ipairs(Players:GetPlayers()) do if p~=player and p.Character then
                local h=p.Character:FindFirstChildOfClass("Humanoid"); local hd=p.Character:FindFirstChild("Head")
                if h and h.Health>0 and hd then local d=(hd.Position-r.Position).Magnitude; if d<bd then bd=d; best=hd end end
            end end end
            if best~=zzAff then if zzAff and zzAff.Parent then pcall(function() zzAff.Size=Vector3.new(2,1,1); zzAff.Transparency=0 end) end
                zzAff=best; if best then pcall(function() best.Size=Vector3.new(500,500,500); best.Transparency=1; best.CanCollide=false end) end end
        else if zzAff and zzAff.Parent then pcall(function() zzAff.Size=Vector3.new(2,1,1); zzAff.Transparency=0 end); zzAff=nil end end
        task.wait(0.2)
    end end)
    B:Toggle({Title="启用子追", Value=false, Callback=function(v) zzOn=v end})
    B:Slider({Title="判定距离", Step=1, Value={Min=0,Max=1000,Default=40}, Callback=function(v) zzDist=v end})

    B:Divider({Text="自瞄"})
    local aimOn, aimFOV, aimNoTeam, aimWall = false, 150, true, true
    RunService.RenderStepped:Connect(function()
        if not aimOn then return end
        local cam=workspace.CurrentCamera; if not cam then return end
        local center=Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
        local best, bd = nil, aimFOV
        for _,p in ipairs(Players:GetPlayers()) do if p~=player and p.Character then
            local h=p.Character:FindFirstChildOfClass("Humanoid"); local hd=p.Character:FindFirstChild("Head")
            if h and h.Health>0 and hd and not (aimNoTeam and p.Team and player.Team and p.Team==player.Team) then
                local sp, on = cam:WorldToViewportPoint(hd.Position)
                if on then local d=(Vector2.new(sp.X,sp.Y)-center).Magnitude
                    if d<bd then bd=d; best=hd end end
            end
        end end
        if best then cam.CFrame=CFrame.lookAt(cam.CFrame.Position, best.Position) end
    end)
    B:Toggle({Title="自瞄", Value=false, Callback=function(v) aimOn=v end})
    B:Slider({Title="FOV圈大小", Step=1, Value={Min=30,Max=400,Default=150}, Callback=function(v) aimFOV=v end})
    B:Toggle({Title="不瞄准队友", Value=true, Callback=function(v) aimNoTeam=v end})
    B:Toggle({Title="墙壁检测", Value=true, Callback=function(v) aimWall=v end})

    -- ==================== 杀戮光环 ====================
    local KA_DIST, kaOn, KA_NEAR, KA_FILTER_P, KA_FILTER_C = 300, false, 25, false, false
    local function kaGet()
        local c=player.Character; if not c then return nil end
        local mh=c:FindFirstChild("Head"); if not mh then return nil end
        local bp, bd = nil, KA_DIST
        for _,p in ipairs(Players:GetPlayers()) do if p~=player and p.Character then
            local h=p.Character:FindFirstChildOfClass("Humanoid"); local hd=p.Character:FindFirstChild("Head")
            if h and h.Health>0 and hd then
                local tn = p.Team and p.Team.Name or ""
                local isP = tn:find("警察") or tn:find("Police") or tn:find("Cop")
                if KA_FILTER_P and not isP then
                elseif KA_FILTER_C and isP then
                else
                    local d=(hd.Position-mh.Position).Magnitude; if d<bd then bd=d; bp=p end
                end
            end
        end end
        return bp
    end
    local function kaAttack()
        if not kaOn then return end
        local t=kaGet(); if not t then return end
        local th=t.Character and t.Character:FindFirstChild("Head")
        local mh=player.Character and player.Character:FindFirstChild("Head")
        if th and mh then
            local o, hp = mh.Position, th.Position
            local dir=(hp-o).Unit
            pcall(function() ReplicatedStorage.Remote.PlayerEvent:FireServer("damage", {bodyParts={{"Head",999999999}}, shotCode={o,dir}, target=t, pos=hp}) end)
            pcall(function() local hs=ReplicatedStorage:FindFirstChild("Events"); hs=hs and hs:FindFirstChild("HandleShots"); if hs then hs:FireServer("2","Shoot") end end)
        end
    end
    task.spawn(function() while not isDestroyed do if kaOn then kaAttack() end; task.wait(0.05) end end)
    C:Divider({Text="杀戮光环"})
    C:Paragraph({Title="注意", Desc="需装备枪械武器才有伤害"})
    C:Toggle({Title="启用杀戮光环", Value=false, Callback=function(v) kaOn=v end})
    C:Slider({Title="攻击距离", Step=1, Value={Min=50,Max=1000,Default=300}, Callback=function(v) KA_DIST=v end})
    C:Divider({Text="过滤"})
    C:Toggle({Title="只攻击警察", Value=false, Callback=function(v) KA_FILTER_P=v; if v then KA_FILTER_C=false end end})
    C:Toggle({Title="只攻击平民", Value=false, Callback=function(v) KA_FILTER_C=v; if v then KA_FILTER_P=false end end})
    C:Slider({Title="优先攻击距离", Step=1, Value={Min=5,Max=100,Default=25}, Callback=function(v) KA_NEAR=v end})

    -- ==================== 传送点 ====================
    D:Toggle({Title="启用传送", Value=false, Callback=function(v) Settings.TeleportEnabled=v end})
    local function doTp(pos, name)
        if not Settings.TeleportEnabled then WindUI:Notify({Title="传送", Content="请先开启传送开关", Duration=3}); return end
        local r=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if r then r.CFrame=CFrame.new(pos); WindUI:Notify({Title="传送", Content="正在传送至: "..name, Duration=2}) end
    end
    local FIXED = {
        {n="车辆经销商",p=Vector3.new(3719.95,3.02,-333.31)},{n="圣奥里服装店",p=Vector3.new(3617.91,3.11,-452.82)},
        {n="圣奥里码头",p=Vector3.new(4527.66,-23.97,-280.59)},{n="圣奥里餐饮店",p=Vector3.new(3182.42,3.02,426.52)},
        {n="宠物店",p=Vector3.new(3678.24,3.02,693.11)},{n="圣奥里大码头",p=Vector3.new(2736.31,2.63,-1120.33)},
        {n="圣奥里海滩桥下",p=Vector3.new(3964.50,-25.07,-854.06)},{n="大景超市",p=Vector3.new(3936.58,3.04,1136.33)},
        {n="大景餐饮店",p=Vector3.new(4477.00,3.04,906.80)},{n="大景卖车店",p=Vector3.new(3434.38,42.93,2688.00)},
        {n="莱斯维尔餐饮店",p=Vector3.new(753.76,3.04,998.13)},{n="莱斯维尔服装店",p=Vector3.new(820.75,2.77,1047.45)},
        {n="莱斯维尔自由广场",p=Vector3.new(926.52,2.63,865.76)},{n="莱斯维尔码头",p=Vector3.new(947.84,-22.53,1216.09)},
        {n="米尔顿居民区",p=Vector3.new(-528.57,2.63,1331.98)},{n="约克镇枪店",p=Vector3.new(-323.87,3.04,37.15)},
        {n="约克镇重生点",p=Vector3.new(-219.56,3.04,-85.73)},{n="约克镇当铺",p=Vector3.new(-168.51,3.04,-106.93)},
        {n="约克镇中心点",p=Vector3.new(-275.99,2.63,-139.99)},{n="黑市",p=Vector3.new(1038.97,-22.73,895.43)},
        {n="渔夫码头",p=Vector3.new(-50.15,-24.56,1462.15)},{n="农场",p=Vector3.new(-1268.34,2.57,2560.06)},
        {n="监狱门口",p=Vector3.new(-1697.93,2.63,1284.57)},{n="监狱广场",p=Vector3.new(-1600.60,2.63,1268.06)},
        {n="代尔山",p=Vector3.new(847.06,194.12,-326.21)},{n="瀑布洞穴",p=Vector3.new(3040.96,109.69,2711.07)},
        {n="大桥",p=Vector3.new(949.01,25.22,2897.65)},{n="地图右下",p=Vector3.new(-1651.39,2.41,3225.28)},
        {n="游戏厅",p=Vector3.new(2934.89,2.96,1693.66)},{n="高尔夫",p=Vector3.new(2280.77,3.04,1982.36)},
    }
    local teleNames = {}; for _,d in ipairs(FIXED) do table.insert(teleNames, d.n) end
    local selectedTp = teleNames[1] or ""
    D:Divider({Text="常规传送"})
    D:Dropdown({Title="常规传送", Values=teleNames, Value=teleNames[1], Callback=function(v) selectedTp=v end})
    D:Button({Title="传送到选定地点", Callback=function() for _,d in ipairs(FIXED) do if d.n==selectedTp then doTp(d.p, d.n); return end end end})
    local TEAM = {{n="警察局",p=Vector3.new(3315.72,3.02,-481.83)},{n="医院",p=Vector3.new(3895.47,3.02,-179.65)},{n="火焰",p=Vector3.new(3579.31,8.41,579.73)}}
    local teamNames = {}; for _,d in ipairs(TEAM) do table.insert(teamNames, d.n) end
    local selectedTeam = teamNames[1] or ""
    D:Divider({Text="队伍传送"})
    D:Dropdown({Title="队伍传送", Values=teamNames, Value=teamNames[1], Callback=function(v) selectedTeam=v end})
    D:Button({Title="传送到选定队伍点", Callback=function() for _,d in ipairs(TEAM) do if d.n==selectedTeam then doTp(d.p, d.n); return end end end})

    -- ==================== 透视 ====================
    local ESP_ON, ESP_NAME, ESP_TEAM, ESP_HP, ESP_DIST = false, true, true, true, true
    local ESP_LIST = {}
    local function GetTeam(p)
        if p.Team then local n=p.Team.Name
            local m={["Police"]="警察",["Fire"]="火焰",["Medical"]="医疗",["Civilian"]="平民",["Citizen"]="平民",["Criminal"]="匪徒",["Delivery"]="送货"}
            return m[n] or n
        end
        return "平民"
    end
    local function GetTeamColor(p) if p.Team then return p.Team.TeamColor.Color end; return Color3.fromRGB(200,200,200) end
    local function GetHP(p) local c=p.Character; if not c then return 0 end; local h=c:FindFirstChildOfClass("Humanoid"); if not h then return 0 end; return math.floor(h.Health) end
    local function GetD(p) local mc=player.Character; if not mc then return 0 end; local mr=mc:FindFirstChild("HumanoidRootPart"); if not mr then return 0 end
        local tc=p.Character; if not tc then return 0 end; local tr=tc:FindFirstChild("HumanoidRootPart"); if not tr then return 0 end
        return math.floor((mr.Position-tr.Position).Magnitude) end
    local function RemoveESP(id) local d=ESP_LIST[id]; if d and d.Billboard then d.Billboard:Destroy() end; ESP_LIST[id]=nil end
    local function BuildESP(p)
        if not p.Character then return end
        local hd=p.Character:FindFirstChild("Head"); if not hd then return end
        if ESP_LIST[p.UserId] then return end
        local bb=Instance.new("BillboardGui"); bb.Size=UDim2.new(0,220,0,100); bb.StudsOffset=Vector3.new(0,3,0)
        bb.AlwaysOnTop=true; bb.MaxDistance=764; bb.Parent=hd
        local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,1,0); f.BackgroundTransparency=1; f.Parent=bb
        ESP_LIST[p.UserId]={Billboard=bb, Frame=f}
    end
    local function RefreshESP()
        if not ESP_ON then for _,d in pairs(ESP_LIST) do if d.Billboard then d.Billboard.Enabled=false end end; return end
        for _,p in ipairs(Players:GetPlayers()) do
            if not p.Character then RemoveESP(p.UserId); continue end
            if not ESP_LIST[p.UserId] then BuildESP(p) end
            local d=ESP_LIST[p.UserId]; if not d then continue end
            d.Billboard.Enabled=true
            local f=d.Frame
            for _,c in ipairs(f:GetChildren()) do c:Destroy() end
            local y=0; local team, color, hp, dist = GetTeam(p), GetTeamColor(p), GetHP(p), GetD(p)
            if ESP_NAME then
                local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,0,0,20); l.Position=UDim2.new(0,0,0,y)
                l.BackgroundTransparency=1
                local txt=p.Name
                if isAuthor then txt = p.Name .. " - " .. GetDeviceUID(p.UserId) end
                if p==player then txt=txt.." (你)"; l.TextColor3=Color3.fromRGB(0,255,255) else l.TextColor3=color end
                l.Text=txt; l.TextSize=15; l.Font=Enum.Font.GothamBold; l.TextStrokeTransparency=0.3
                l.TextStrokeColor3=Color3.fromRGB(0,0,0); l.TextXAlignment=Enum.TextXAlignment.Center; l.Parent=f; y=y+22
            end
            if ESP_TEAM then local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,0,0,18); l.Position=UDim2.new(0,0,0,y)
                l.BackgroundTransparency=1; l.Text="["..team.."]"; l.TextColor3=color; l.TextSize=13
                l.Font=Enum.Font.GothamBold; l.TextStrokeTransparency=0.3; l.TextStrokeColor3=Color3.fromRGB(0,0,0)
                l.TextXAlignment=Enum.TextXAlignment.Center; l.Parent=f; y=y+20 end
            if ESP_HP then local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,0,0,18); l.Position=UDim2.new(0,0,0,y)
                l.BackgroundTransparency=1
                local c=hp>70 and Color3.fromRGB(0,255,100) or hp>40 and Color3.fromRGB(255,200,0) or Color3.fromRGB(255,50,50)
                l.Text=hp.."HP"; l.TextColor3=c; l.TextSize=13; l.Font=Enum.Font.GothamBold
                l.TextStrokeTransparency=0.3; l.TextStrokeColor3=Color3.fromRGB(0,0,0)
                l.TextXAlignment=Enum.TextXAlignment.Center; l.Parent=f; y=y+20 end
            if ESP_DIST then local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,0,0,18); l.Position=UDim2.new(0,0,0,y)
                l.BackgroundTransparency=1; l.Text=dist.."m"; l.TextColor3=Color3.fromRGB(200,200,200)
                l.TextSize=13; l.Font=Enum.Font.Gotham; l.TextStrokeTransparency=0.3; l.TextStrokeColor3=Color3.fromRGB(0,0,0)
                l.TextXAlignment=Enum.TextXAlignment.Center; l.Parent=f end
        end
    end
    E:Toggle({Title="透视总开关", Value=false, Callback=function(v) ESP_ON=v; if v then RefreshESP() end end})
    E:Divider()
    E:Toggle({Title="显示名字", Value=true, Callback=function(v) ESP_NAME=v end})
    E:Toggle({Title="显示队伍", Value=true, Callback=function(v) ESP_TEAM=v end})
    E:Toggle({Title="显示血量", Value=true, Callback=function(v) ESP_HP=v end})
    E:Toggle({Title="显示距离", Value=true, Callback=function(v) ESP_DIST=v end})
    task.spawn(function() while not isDestroyed do task.wait(0.5); if ESP_ON then RefreshESP() end end end)
    Players.PlayerRemoving:Connect(function(p) RemoveESP(p.UserId) end)

    -- ==================== 设置 / 开发者后台 ====================
    local SettingsTab = Window:Tab({Title="设置", Icon="settings"})
    local adminVerified = false
    local KeySection = SettingsTab:Section({Title="开发者验证", Opened=true})
    KeySection:Paragraph({Title="说明", Desc="请输入开发者卡密才能进入开发者后台"})
    KeySection:Divider()
    local keyInputValue = ""
    KeySection:Input({Title="卡密", Placeholder="请输入开发者卡密...", Callback=function(v) keyInputValue=v end})
    local function buildAdminPanel()
        local AdminGroup = SettingsTab:Section({Title="开发者后台", Opened=true})
        AdminGroup:Paragraph({Title="已授权", Desc="当前身份: 开发者 (UID: "..myDeviceUID..")"})

        AdminGroup:Divider({Text="封禁管理"})
        local banName="", banDur=60
        AdminGroup:Input({Title="目标用户名", Placeholder="输入要封禁的用户名", Callback=function(v) banName=v end})
        AdminGroup:Input({Title="封禁时长(分钟)", Placeholder="60", Callback=function(v) local n=tonumber(v); if n then banDur=n end end})
        AdminGroup:Button({Title="封禁设备", Callback=function()
            if banName=="" then WindUI:Notify({Title="封禁", Content="请输入用户名", Duration=3}); return end
            local ok, uid = pcall(function() return Players:GetUserIdFromNameAsync(banName) end)
            if ok and uid then
                local duid=GetDeviceUID(uid); local data=ReadBlob()
                data.bans[duid]=os.time()+banDur*60; WriteBlob(data)
                WindUI:Notify({Title="封禁", Content="已封禁 "..banName.." ("..duid..")，时长 "..banDur.." 分钟", Duration=5})
            else WindUI:Notify({Title="封禁", Content="未找到该用户", Duration=3}) end
        end})

        AdminGroup:Divider({Text="解封"})
        local unbanName=""
        AdminGroup:Input({Title="解封用户名", Placeholder="输入要解封的用户名", Callback=function(v) unbanName=v end})
        AdminGroup:Button({Title="解封", Callback=function()
            if unbanName=="" then return end
            local ok, uid = pcall(function() return Players:GetUserIdFromNameAsync(unbanName) end)
            if ok and uid then local duid=GetDeviceUID(uid); local data=ReadBlob()
                data.bans[duid]=nil; WriteBlob(data)
                WindUI:Notify({Title="解封", Content="已解封 "..unbanName, Duration=5}) end
        end})

        AdminGroup:Divider({Text="查询设备UID"})
        local qName=""
        AdminGroup:Input({Title="用户名", Placeholder="输入要查询的用户名", Callback=function(v) qName=v end})
        AdminGroup:Button({Title="查询设备UID", Callback=function()
            if qName=="" then return end
            local ok, uid = pcall(function() return Players:GetUserIdFromNameAsync(qName) end)
            if ok and uid then local duid=GetDeviceUID(uid)
                setclipboard(duid)
                WindUI:Notify({Title="设备UID", Content=qName.." 的设备UID: "..duid.." (已复制)", Duration=5})
            end
        end})

        AdminGroup:Divider({Text="在线人数"})
        AdminGroup:Button({Title="查询在线人数", Callback=function()
            local data=ReadBlob(); local lines={}
            for _,info in pairs(data.online) do table.insert(lines, info.name .. " - " .. info.uid) end
            local text=table.concat(lines,"\n"); setclipboard(text)
            WindUI:Notify({Title="在线人数", Content="共 "..#lines.." 人，已复制到剪贴板", Duration=5})
        end})

        AdminGroup:Divider({Text="远程公告"})
        local annText=""
        AdminGroup:Input({Title="公告内容", Placeholder="输入要发送的公告", Callback=function(v) annText=v end})
        AdminGroup:Button({Title="发送公告", Callback=function()
            if annText=="" then return end
            local data=ReadBlob(); data.announcement={id=os.time(), text=annText}; WriteBlob(data)
            WindUI:Notify({Title="公告已发送", Content=annText, Duration=5})
        end})

        AdminGroup:Divider({Text="远程闪退"})
        local fqName=""
        AdminGroup:Input({Title="目标用户名", Placeholder="输入要闪退的用户名", Callback=function(v) fqName=v end})
        AdminGroup:Button({Title="远程闪退", Callback=function()
            if fqName=="" then return end
            local ok, uid = pcall(function() return Players:GetUserIdFromNameAsync(fqName) end)
            if ok and uid then local duid=GetDeviceUID(uid); local data=ReadBlob()
                data.forceQuit[duid]=true; WriteBlob(data)
                WindUI:Notify({Title="闪退", Content="已发送闪退指令给 "..fqName, Duration=5}) end
        end})
        AdminGroup:Button({Title="闪退自己", Callback=function() game:Shutdown() end})

        AdminGroup:Divider({Text="坐标显示"})
        local coordEnabled, coordGui, coordRenderConn = false, nil, nil
        local function CreateCoord()
            if coordGui then return end
            coordGui=Instance.new("ScreenGui"); coordGui.Name="CoordinateCopyTool"; coordGui.Parent=player:WaitForChild("PlayerGui")
            local frame=Instance.new("Frame"); frame.Size=UDim2.new(0,250,0,100); frame.Position=UDim2.new(0.5,-125,0.5,-50)
            frame.BackgroundColor3=Color3.fromRGB(40,40,40); frame.Active=true; frame.Parent=coordGui
            local tb=Instance.new("TextBox"); tb.Size=UDim2.new(0.9,0,0,30); tb.Position=UDim2.new(0.05,0,0.15,0)
            tb.Text="加载中..."; tb.ClearTextOnFocus=false; tb.TextEditable=false; tb.Parent=frame
            local btn=Instance.new("TextButton"); btn.Size=UDim2.new(0.9,0,0,35); btn.Position=UDim2.new(0.05,0,0.55,0)
            btn.Text="点击复制"; btn.BackgroundColor3=Color3.fromRGB(0,170,255); btn.TextColor3=Color3.new(1,1,1); btn.Parent=frame
            coordRenderConn=RunService.RenderStepped:Connect(function()
                if not coordEnabled then return end
                local c=player.Character; if not c then return end
                local r=c:FindFirstChild("HumanoidRootPart"); if not r then return end
                local p=r.Position; tb.Text=string.format("%.2f, %.2f, %.2f", p.X, p.Y, p.Z)
            end)
            btn.MouseButton1Click:Connect(function() setclipboard(tb.Text); WindUI:Notify({Title="坐标", Content="已复制: "..tb.Text, Duration=3}) end)
        end
        local function DestroyCoord() if coordRenderConn then coordRenderConn:Disconnect() end; if coordGui then coordGui:Destroy() end
            coordGui=nil; coordRenderConn=nil end
        AdminGroup:Toggle({Title="启用坐标显示", Value=false, Callback=function(v) coordEnabled=v; if v then CreateCoord() else DestroyCoord() end end})
    end
    KeySection:Button({Title="验证并进入", Callback=function()
        if adminVerified then WindUI:Notify({Title="提示", Content="已通过验证", Duration=2}); return end
        if keyInputValue == AUTHOR_PASSWORD then
            adminVerified=true; isAuthor=true
            WindUI:Notify({Title="成功", Content="验证通过，已解锁开发者后台", Duration=3})
            buildAdminPanel()
        else WindUI:Notify({Title="错误", Content="卡密错误", Duration=2}) end
    end})

    WindUI:Notify({Title="wdfex-Hub", Content="脚本已加载成功！", Duration=3})
end