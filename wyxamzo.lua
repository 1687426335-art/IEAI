-- This file has been deobfuscated Luraph using Hurricane https://discord.com/invite/AbeurBzKXe
local function safeLoad(url) local success, result = pcall(function() return loadstring(game:HttpGet(url))() end) if not success then warn("加载失败: " .. url) return nil end return result end local Library = safeLoad("https://raw.githubusercontent.com/kongbaNB/ui/refs/heads/main/黑曜石主库.ui") local ThemeManager = safeLoad("https://raw.githubusercontent.com/kongbaNB/ui/refs/heads/main/主题管理.ui") local SaveManager = safeLoad("https://raw.githubusercontent.com/kongbaNB/ui/refs/heads/main/配置管理.ui") if not Library then game:GetService("StarterGui"):SetCore("SendNotification", { Title = "错误", Text = "UI 库加载失败，请检查网络或脚本资源", Duration = 5, }) return end local Options = Library.Options local Toggles = Library.Toggles local Players = game:GetService("Players") local ReplicatedStorage = game:GetService("ReplicatedStorage") local Workspace = game:GetService("Workspace") local RunService = game:GetService("RunService") local player = Players.LocalPlayer local Window = Library:CreateWindow({ Title = "wdfex-圣奥里", Footer = "此脚本由wdfex高级工程师制作倒卖没有季吧", Icon = 131153193945220, NotifySide = "Right", ShowCustomCursor = true, }) Library:Notify({ Title = "圣奥里", Description = "创作者：wdfex\nQQ：1687426335（已为您开启反作弊与防挂机祝您玩的愉快）\n脚本已加载成功", Time = 5, }) local Tabs = { Notice = Window:AddTab("公告", "info"), Player = Window:AddTab("玩家修改", "user"), Gun = Window:AddTab("枪械功能", "target"), KA = Window:AddTab("杀戮光环", "skull"), Teleports = Window:AddTab("传送点", "map-pin"), Settings = Window:AddTab("设置", "settings"), } local NoticeGroup = Tabs.Notice:AddLeftGroupbox("作者消息") NoticeGroup:AddLabel('wdfex') NoticeGroup:AddLabel('创作者：wdfex') NoticeGroup:AddDivider() NoticeGroup:AddLabel('已更换悬浮窗添加了一些功能') NoticeGroup:AddLabel('杀戮光环的优先攻击最近目标如果选择距离内没有人') NoticeGroup:AddLabel('那这个选项就不会生效杀戮光环正常生效') NoticeGroup:AddDivider() NoticeGroup:AddLabel('如果你使用的过程中出现一些bug请联系作者修复')

local Settings = {
    HoldTime = 0,
    Distance = 25,
    HitboxEnabled = false,
    HitboxSize = 10,
    WhitelistEnabled = false,
    TeleportEnabled = false,
    NoclipEnabled = false,
    ESPEnabled = false,
    ESPShowName = true,
    ESPShowJob = true,
    OutlineESPEnabled = false,
}

local Whitelist = {}
local affectedHeads = {}
local frameCount = 0
local isDestroyed = false
local connections = {}
local noclipConnections = {}

local JobColors = {
    ["警察"] = Color3.fromRGB(0, 100, 255),
    ["医生"] = Color3.fromRGB(0, 200, 0),
    ["消防员"] = Color3.fromRGB(255, 50, 0),
    ["军人"] = Color3.fromRGB(50, 150, 50),
    ["黑帮"] = Color3.fromRGB(150, 0, 150),
    ["平民"] = Color3.fromRGB(200, 200, 200),
    ["圣奥里公民"] = Color3.fromRGB(200, 200, 200),
    ["银行家"] = Color3.fromRGB(0, 200, 200),
    ["市长"] = Color3.fromRGB(255, 200, 0),
    ["记者"] = Color3.fromRGB(255, 150, 0),
    ["律师"] = Color3.fromRGB(150, 100, 200),
    ["囚犯"] = Color3.fromRGB(255, 150, 0),
    ["狱警"] = Color3.fromRGB(0, 150, 255),
    ["司机"] = Color3.fromRGB(100, 200, 255),
    ["厨师"] = Color3.fromRGB(255, 100, 0),
    ["建筑工"] = Color3.fromRGB(255, 200, 50),
    ["农民"] = Color3.fromRGB(50, 200, 50),
    ["矿工"] = Color3.fromRGB(200, 150, 100),
    ["渔夫"] = Color3.fromRGB(0, 150, 200),
    ["商人"] = Color3.fromRGB(255, 150, 200),
    ["学生"] = Color3.fromRGB(100, 100, 255),
    ["老师"] = Color3.fromRGB(200, 100, 50),
    ["工程师"] = Color3.fromRGB(255, 100, 100),
    ["科学家"] = Color3.fromRGB(0, 255, 150),
    ["飞行员"] = Color3.fromRGB(50, 200, 255),
    ["快递员"] = Color3.fromRGB(255, 180, 0),
    ["公交车司机"] = Color3.fromRGB(0, 180, 255),
    ["送货"] = Color3.fromRGB(255, 100, 50),
    ["转运"] = Color3.fromRGB(0, 200, 150),
    ["货物"] = Color3.fromRGB(150, 100, 0),
    ["医疗服务工作人员"] = Color3.fromRGB(0, 220, 100),
}

local espBillboards = {}
local espConnections = {}

local outlineESPData = {}
local outlineESPConnections = {}

local function GetPlayerTeamColor(p)
    local team = p.Team
    if team then
        return team.TeamColor.Color
    end
    return Color3.fromRGB(255, 255, 255)
end

local function GetPlayerJob(p)
    if p.Team then
        return p.Team.Name
    end
    return "平民"
end

local function GetJobColor(jobName)
    return JobColors[jobName] or Color3.fromRGB(200, 200, 200)
end

local function IsPolice(p)
    if p.Team then
        local teamName = p.Team.Name or ""
        if teamName:find("警察") or teamName:find("Police") or teamName:find("Cop") or teamName:find("sheriff") then
            return true
        end
    end
    if p.Character then
        for _, child in ipairs(p.Character:GetDescendants()) do
            if child:IsA("StringValue") or child:IsA("BoolValue") or child:IsA("IntValue") then
                local name = child.Name:lower()
                if name:find("police") or name:find("cop") or name:find("警") or name:find("sheriff") then
                    return true
                end
            end
        end
    end
    return false
end

local function RemoveESP(userId)
    local data = espBillboards[userId]
    if data then
        if data.Billboard then
            data.Billboard:Destroy()
        end
        espBillboards[userId] = nil
    end
end

local function CreateESP(p)
    if isDestroyed then return end
    if not p.Character then return end
    if p == player then return end
    local head = p.Character:FindFirstChild("Head")
    if not head then return end
    if espBillboards[p.UserId] then return end
    local name = p.Name
    local job = GetPlayerJob(p)
    local teamColor = GetPlayerTeamColor(p)
    local jobColor = GetJobColor(job)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. p.UserId
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 300, 0, 60)
    billboard.StudsOffset = Vector3.new(0, 2.8, 0)
    billboard.MaxDistance = 500
    billboard.AlwaysOnTop = true
    billboard.Parent = head
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.Parent = billboard
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 26)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.TextColor3 = teamColor
    nameLabel.TextSize = 18
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.TextYAlignment = Enum.TextYAlignment.Center
    nameLabel.Parent = frame
    local jobLabel = Instance.new("TextLabel")
    jobLabel.Size = UDim2.new(1, 0, 0, 22)
    jobLabel.Position = UDim2.new(0, 0, 0, 28)
    jobLabel.BackgroundTransparency = 1
    jobLabel.Text = job
    jobLabel.TextColor3 = jobColor
    jobLabel.TextSize = 16
    jobLabel.Font = Enum.Font.GothamBold
    jobLabel.TextXAlignment = Enum.TextXAlignment.Center
    jobLabel.TextYAlignment = Enum.TextYAlignment.Center
    jobLabel.Parent = frame
    espBillboards[p.UserId] = {
        Billboard = billboard,
        Frame = frame,
        NameLabel = nameLabel,
        JobLabel = jobLabel,
    }
    local con
    con = p.AncestryChanged:Connect(function()
        if not p.Parent or not p.Character then
            RemoveESP(p.UserId)
            if con then
                con:Disconnect()
            end
        end
    end)
    table.insert(espConnections, con)
end

local function UpdateESPVisibility()
    for userId, data in pairs(espBillboards) do
        if data.NameLabel then
            data.NameLabel.Visible = Settings.ESPShowName
        end
        if data.JobLabel then
            data.JobLabel.Visible = Settings.ESPShowJob
        end
        if data.Billboard then
            data.Billboard.Enabled = Settings.ESPEnabled
        end
    end
end

local function UpdateAllESP()
    if not Settings.ESPEnabled then
        for userId, data in pairs(espBillboards) do
            if data.Billboard then
                data.Billboard.Enabled = false
            end
        end
        return
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            if not espBillboards[p.UserId] then
                CreateESP(p)
            else
                local data = espBillboards[p.UserId]
                local job = GetPlayerJob(p)
                if data.NameLabel then
                    data.NameLabel.Text = p.Name
                    data.NameLabel.TextColor3 = GetPlayerTeamColor(p)
                end
                if data.JobLabel then
                    data.JobLabel.Text = job
                    data.JobLabel.TextColor3 = GetJobColor(job)
                end
                if data.Billboard then
                    data.Billboard.Enabled = true
                end
            end
        end
    end
end

-- 透视实时刷新循环（名字+职业+所有透视）
task.spawn(function()
    while not isDestroyed do
        task.wait(0.3)
        if Settings.ESPEnabled then
            UpdateAllESP()
        end
        if Settings.OutlineESPEnabled then
            UpdateOutlineESP()
        end
        if teamEspOn then
            for _, plr in ipairs(Players:GetPlayers()) do
                teamApply(plr)
            end
        end
    end
end)

local function RemoveOutlineESP(userId)
    local data = outlineESPData[userId]
    if data then
        if data.Highlight then
            data.Highlight:Destroy()
        end
        if data.Billboard then
            data.Billboard:Destroy()
        end
        outlineESPData[userId] = nil
    end
end

local function ClearAllOutlineESP()
    for userId, _ in pairs(outlineESPData) do
        RemoveOutlineESP(userId)
    end
end

local function CreateOutlineESP(p)
    if isDestroyed then return end
    if p == player then return end
    local char = p.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    if outlineESPData[p.UserId] then
        local data = outlineESPData[p.UserId]
        if data.Highlight then data.Highlight.Enabled = true end
        if data.Billboard then data.Billboard.Enabled = true end
        return
    end
    
    -- 检测是否为警察
    local isPolice = IsPolice(p)
    
    -- 设置颜色：警察蓝色，平民白色
    local outlineColor = isPolice and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(255, 255, 255)
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "OutlineESP_" .. p.UserId
    highlight.Adornee = char
    highlight.FillColor = outlineColor
    highlight.OutlineColor = outlineColor
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "OutlineESPGui_" .. p.UserId
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 1000
    billboard.Parent = head
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = outlineColor
    label.TextSize = 15
    label.Font = Enum.Font.GothamBold
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.Text = p.Name
    label.Parent = billboard
    outlineESPData[p.UserId] = {
        Player = p,
        Highlight = highlight,
        Billboard = billboard,
        Label = label,
    }
end

-- 人物描边透视（优化版，减少CPU占用）
local outlineUpdateTimer = 0

local function UpdateOutlineESP()
    if not Settings.OutlineESPEnabled or isDestroyed then return end
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            if not outlineESPData[p.UserId] then
                CreateOutlineESP(p)
            else
                local data = outlineESPData[p.UserId]
                local isPolice = IsPolice(p)
                local outlineColor = isPolice and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(255, 255, 255)
                if data.Highlight then
                    data.Highlight.FillColor = outlineColor
                    data.Highlight.OutlineColor = outlineColor
                end
                if data.Label then
                    data.Label.TextColor3 = outlineColor
                    local targetHead = p.Character:FindFirstChild("Head")
                    if targetHead and root then
                        local dist = (targetHead.Position - root.Position).Magnitude
                        data.Label.Text = p.Name .. "\n[" .. math.floor(dist) .. "]"
                    else
                        data.Label.Text = p.Name
                    end
                end
                if data.Billboard then
                    data.Billboard.Enabled = true
                end
                if data.Highlight then
                    data.Highlight.Enabled = true
                end
            end
        elseif p ~= player then
            RemoveOutlineESP(p.UserId)
        end
    end
end

local function ToggleOutlineESP(state)
    Settings.OutlineESPEnabled = state
    if state then
        UpdateOutlineESP()
    else
        ClearAllOutlineESP()
    end
end

local function GetTeleportData()
    return {
        {n = "车辆经销商", p = Vector3.new(3719.9501953125, 3.018573522567749, -333.3118591308594), region = "圣奥里"},
        {n = "医院", p = Vector3.new(3980.091064453125, 2.876060724258423, -138.79454040527344), region = "圣奥里"},
        {n = "警察局", p = Vector3.new(3364.273193359375, 3.9188079834, -394.7233581542969), region = "圣奥里"},
        {n = "圣奥里修车店", p = Vector3.new(2782.46875, 2.630995750427246, -418.59930419921875), region = "圣奥里"},
        {n = "圣奥里银行", p = Vector3.new(3134.05419921875, 6.116048336029053, -171.36976623535156), region = "圣奥里"},
        {n = "圣奥里服装店", p = Vector3.new(3617.91259765625, 3.1072206497192383, -452.8206481933594), region = "圣奥里"},
        {n = "圣奥里平民重生", p = Vector3.new(3741.114990234375, 3.720573663711548, -438.1059875488281), region = "圣奥里"},
        {n = "圣奥里码头", p = Vector3.new(4527.65625, -23.968238830566406, -280.59356689453125), region = "圣奥里"},
        {n = "圣奥里餐饮店", p = Vector3.new(3182.416748046875, 3.01859188079834, 426.5179138183594), region = "圣奥里"},
        {n = "消防部门", p = Vector3.new(3578.676025390625, 8.408823013305664, 579.6567993164062), region = "圣奥里"},
        {n = "宠物店", p = Vector3.new(3678.237305, 3.017920, 693.114624), region = "圣奥里"},
        {n = "圣奥里大码头", p = Vector3.new(2736.307617, 2.630299, -1120.333008), region = "圣奥里"},
        {n = "圣奥里海滩桥下(消星点)", p = Vector3.new(3964.504395, -25.068211, -854.057251), region = "圣奥里"},
        {n = "大景超市", p = Vector3.new(3936.582764, 3.038293, 1136.326416), region = "大景"},
        {n = "转镜中心", p = Vector3.new(4152.919922, 2.631675, 941.446045), region = "大景"},
        {n = "道路服务", p = Vector3.new(4271.332520, 2.628108, 1200.086914), region = "大景"},
        {n = "大景餐饮店", p = Vector3.new(4476.997559, 3.037825, 906.802979), region = "大景"},
        {n = "送货中心", p = Vector3.new(4399.419434, 3.038999, 1609.455933), region = "大景"},
        {n = "大景卖车店", p = Vector3.new(3434.377441, 42.931786, 2687.997070), region = "大景"},
        {n = "莱斯维尔餐饮店", p = Vector3.new(753.757812, 3.039824, 998.132996), region = "莱斯维尔"},
        {n = "莱斯维尔服装店", p = Vector3.new(820.745117, 2.766988, 1047.445679), region = "莱斯维尔"},
        {n = "莱斯维尔自由广场", p = Vector3.new(926.523376, 2.630995, 865.764771), region = "莱斯维尔"},
        {n = "莱斯维尔码头(游艇)", p = Vector3.new(947.840210, -22.529087, 1216.085693), region = "莱斯维尔"},
        {n = "米尔顿左上加油站", p = Vector3.new(1145.635742, 2.630916, -864.273682), region = "米尔顿"},
        {n = "米尔顿右下加油站", p = Vector3.new(-1646.802734, 2.630164, 1812.894653), region = "米尔顿"},
        {n = "米尔顿上方加油站", p = Vector3.new(-900.701660, 2.630927, 1124.683105), region = "米尔顿"},
        {n = "米尔顿居民区", p = Vector3.new(-528.565552, 2.630996, 1331.981689), region = "米尔顿"},
        {n = "约克镇小银行", p = Vector3.new(-668.217224, 2.630995, -65.347839), region = "约克镇"},
        {n = "约克镇修车厂", p = Vector3.new(-407.163025, 3.076807, -6.098211), region = "约克镇"},
        {n = "约克镇枪店", p = Vector3.new(-323.869293, 3.037825, 37.149670), region = "约克镇"},
        {n = "约克镇重生点", p = Vector3.new(-219.560318, 3.039824, -85.725433), region = "约克镇"},
        {n = "约克镇当铺", p = Vector3.new(-168.513733, 3.039000, -106.926529), region = "约克镇"},
        {n = "约克镇卫星车", p = Vector3.new(-302.093567, 3.037825, -167.621017), region = "约克镇"},
        {n = "约克镇中心点", p = Vector3.new(-275.995209, 2.630996, -139.985352), region = "约克镇"},
        {n = "黑市", p = Vector3.new(1038.969849, -22.732950, 895.430237), region = "其他"},
        {n = "渔夫码头", p = Vector3.new(-50.147552, -24.555279, 1462.145996), region = "其他"},
        {n = "农场", p = Vector3.new(-1268.339233, 2.572412, 2560.060303), region = "其他"},
        {n = "监狱门口", p = Vector3.new(-1697.931885, 2.630666, 1284.567383), region = "其他"},
        {n = "监狱广场", p = Vector3.new(-1600.602417, 2.631028, 1268.060059), region = "其他"},
        {n = "代尔山", p = Vector3.new(847.062988, 194.115753, -326.212708), region = "其他"},
        {n = "瀑布洞穴(消星点)", p = Vector3.new(3040.956055, 109.688538, 2711.069336), region = "其他"},
        {n = "大桥", p = Vector3.new(949.014954, 25.215754, 2897.654785), region = "其他"},
        {n = "地图右下(消星点)", p = Vector3.new(-1651.385010, 2.414712, 3225.278320), region = "其他"},
        {n = "下部加油站", p = Vector3.new(2270.378174, 2.630927, 154.161484), region = "其他"},
        {n = "游戏厅", p = Vector3.new(2934.893799, 2.956458, 1693.660034), region = "其他"},
        {n = "高尔夫", p = Vector3.new(2280.767090, 3.037836, 1982.357300), region = "其他"},
        {n = "修船厂", p = Vector3.new(4096.405273, -30.401447, 2865.045166), region = "其他"},
    }
end
local FIXED_TELEPORTS = GetTeleportData()

local function TeleportTo(pos)
    if not Settings.TeleportEnabled or isDestroyed then return end
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    pcall(function()
        root.CFrame = CFrame.new(pos)
    end)
end

local function ApplyNoclip()
    if isDestroyed or not Settings.NoclipEnabled then return end
    local char = player.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

local function ToggleNoclip(state)
    Settings.NoclipEnabled = state
    if state then
        ApplyNoclip()
    else
        local char = player.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

local function ApplyHitbox()
    if isDestroyed or not Settings.HitboxEnabled then return end
    local players = Players:GetPlayers()
    local newAffected = {}
    for i = 1, #players do
        local p = players[i]
        if p ~= player and p.Character then
            if Settings.WhitelistEnabled and Whitelist[p.UserId] then
            else
                local char = p.Character
                local head = char:FindFirstChild("Head")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 and head then
                    head.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
                    head.Transparency = 1
                    head.Color = Color3.fromRGB(255, 215, 0)
                    head.Material = Enum.Material.Neon
                    head.CanCollide = false
                    newAffected[head] = true
                end
            end
        end
    end
    for head, _ in pairs(affectedHeads) do
        if not newAffected[head] and head and head.Parent then
            head.Size = Vector3.new(2, 1, 1)
            head.Transparency = 0
            head.CanCollide = true
            head.Color = Color3.new(1, 1, 1)
            head.Material = Enum.Material.Plastic
        end
    end
    affectedHeads = newAffected
end

local function ResetHitbox()
    for head, _ in pairs(affectedHeads) do
        if head and head.Parent then
            head.Size = Vector3.new(2, 1, 1)
            head.Transparency = 0
            head.CanCollide = true
            head.Color = Color3.new(1, 1, 1)
            head.Material = Enum.Material.Plastic
        end
    end
    affectedHeads = {}
end

local function UpdateWhitelist()
    if isDestroyed then return end
    Whitelist = {}
    local players = Players:GetPlayers()
    for i = 1, #players do
        local p = players[i]
        if p ~= player then
            pcall(function()
                if p:IsFriendsWith(player.UserId) then
                    Whitelist[p.UserId] = true
                end
            end)
        end
    end
end

local UserInputService = game:GetService("UserInputService")
local FlySpeed = 35
local flyState = { enabled = false, hrp = nil, hum = nil, microThread = nil, healthThread = nil, diedConn = nil, targetPos = nil, lastTime = 0 }
local flyAnchor = { active = false, head = nil, hrp = nil, hum = nil, rayLength = 3.5, rayCount = 12, verticalLayers = 3 }
local FlyControl
task.spawn(function()
    pcall(function()
        local pm = player.PlayerScripts:FindFirstChild("PlayerModule")
        if pm then FlyControl = require(pm):GetControls() end
    end)
end)

local function flyRefreshParts()
    local char = player.Character
    if not char then
        flyState.hrp = nil flyState.hum = nil
        flyAnchor.hrp = nil flyAnchor.head = nil flyAnchor.hum = nil
        return
    end
    flyState.hrp = char:FindFirstChild("HumanoidRootPart")
    flyState.hum = char:FindFirstChildOfClass("Humanoid")
    flyAnchor.hrp = flyState.hrp
    flyAnchor.head = char:FindFirstChild("Head")
    flyAnchor.hum = flyState.hum
end

local function flyDetectWall()
    local hrp = flyAnchor.hrp
    if not hrp then return false end
    local pos = hrp.Position
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = { player.Character }
    for i = 1, flyAnchor.rayCount do
        local angle = (i / flyAnchor.rayCount) * 2 * math.pi
        local dx = math.cos(angle)
        local dz = math.sin(angle)
        for j = -(flyAnchor.verticalLayers - 1) // 2, (flyAnchor.verticalLayers - 1) // 2 do
            local dir = Vector3.new(dx, j * 0.5, dz).Unit
            local result = workspace:Raycast(pos, dir * flyAnchor.rayLength, params)
            if result and result.Instance and result.Instance.CanCollide and result.Instance.Transparency < 0.9 then
                return true
            end
        end
    end
    return false
end

local function flyEnterAnchor()
    if flyAnchor.active then return end
    if not flyAnchor.head or not flyAnchor.hrp or not flyAnchor.hum then return end
    flyAnchor.head.Anchored = true
    flyAnchor.hum.PlatformStand = true
    flyAnchor.active = true
end

local function flyExitAnchor()
    if not flyAnchor.active then return end
    if flyAnchor.head and flyAnchor.hum then
        flyAnchor.head.Anchored = false
        flyAnchor.hum.PlatformStand = false
    end
    flyAnchor.active = false
end

local function flyMicroStepLoop()
    flyState.targetPos = flyState.hrp.Position
    flyState.lastTime = tick()
    while flyState.enabled do
        local now = tick()
        local dt = now - flyState.lastTime
        flyState.lastTime = now
        if not flyState.hrp or not flyState.hrp.Parent then break end
        local inWall = flyDetectWall()
        if inWall and not flyAnchor.active then
            flyEnterAnchor()
        elseif not inWall and flyAnchor.active then
            flyExitAnchor()
        end
        local moveDir
        if FlyControl then
            local mv = FlyControl:GetMoveVector()
            local cf = workspace.CurrentCamera.CFrame
            moveDir = (cf.LookVector * -mv.Z) + (cf.RightVector * mv.X)
        else
            moveDir = (flyState.hum and flyState.hum.MoveDirection) or Vector3.zero
        end
        local vertical = 0
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            vertical = 1
        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            vertical = -1
        end
        local delta = (moveDir + Vector3.new(0, vertical, 0)) * FlySpeed * dt
        flyState.targetPos = flyState.targetPos + delta
        local currentPos = flyState.hrp.Position
        local remaining = flyState.targetPos - currentPos
        local distance = remaining.Magnitude
        if distance > 0 then
            local steps = math.ceil(distance / 10)
            local stepVec = remaining / steps
            for i = 1, steps do
                if not flyState.enabled then break end
                currentPos = currentPos + stepVec
                flyState.hrp.CFrame = CFrame.new(currentPos) * flyState.hrp.CFrame.Rotation
                flyState.hrp.Velocity = Vector3.zero
            end
        else
            flyState.hrp.CFrame = CFrame.new(flyState.targetPos) * flyState.hrp.CFrame.Rotation
            flyState.hrp.Velocity = Vector3.zero
        end
        if flyState.hum then
            flyState.hum:ChangeState(Enum.HumanoidStateType.Climbing)
        end
        task.wait(0.001)
    end
end

local function flyHealthLockLoop()
    while flyState.enabled do
        if flyState.hum and flyState.hum.Health <= 0 then
            flyState.hum.Health = flyState.hum.MaxHealth
        end
        task.wait(0.1)
    end
end

local function startFly()
    if flyState.enabled then return end
    flyRefreshParts()
    if not flyState.hrp or not flyState.hum then return end
    flyState.enabled = true
    flyState.hum:ChangeState(Enum.HumanoidStateType.Climbing)
    flyState.microThread = task.spawn(flyMicroStepLoop)
    flyState.healthThread = task.spawn(flyHealthLockLoop)
    flyState.diedConn = flyState.hum.Died:Connect(function()
        if flyState.hum and flyState.enabled then
            flyState.hum.Health = flyState.hum.MaxHealth
            flyState.hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
end

local function stopFly()
    flyState.enabled = false
    flyExitAnchor()
    if flyState.microThread then task.cancel(flyState.microThread) flyState.microThread = nil end
    if flyState.healthThread then task.cancel(flyState.healthThread) flyState.healthThread = nil end
    if flyState.diedConn then flyState.diedConn:Disconnect() flyState.diedConn = nil end
    if flyState.hum then flyState.hum:ChangeState(Enum.H