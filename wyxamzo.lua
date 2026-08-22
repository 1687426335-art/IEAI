-- This file has been deobfuscated Luraph using Hurricane https://discord.com/invite/AbeurBzKXe
local function safeLoad(url) local success, result = pcall(function() return loadstring(game:HttpGet(url))() end) if not success then warn("加载失败: " .. url) return nil end return result end local Library = safeLoad("https://raw.githubusercontent.com/kongbaNB/ui/refs/heads/main/黑曜石主库.ui") local ThemeManager = safeLoad("https://raw.githubusercontent.com/kongbaNB/ui/refs/heads/main/主题管理.ui") local SaveManager = safeLoad("https://raw.githubusercontent.com/kongbaNB/ui/refs/heads/main/配置管理.ui") if not Library then game:GetService("StarterGui"):SetCore("SendNotification", { Title = "错误", Text = "UI 库加载失败，请检查网络或脚本资源", Duration = 5, }) return end local Options = Library.Options local Toggles = Library.Toggles local Players = game:GetService("Players") local ReplicatedStorage = game:GetService("ReplicatedStorage") local Workspace = game:GetService("Workspace") local RunService = game:GetService("RunService") local player = Players.LocalPlayer local Window = Library:CreateWindow({ Title = "wdfex-圣奥里", Footer = "此脚本由wdfex高级工程师制作倒卖没有季吧", Icon = 131153193945220, NotifySide = "Right", ShowCustomCursor = true, }) Library:Notify({ Title = "圣奥里", Description = "创作者：wdfex\nQQ：1687426335（已为您开启反作弊与防挂机祝您玩的愉快）\n脚本已加载成功", Time = 5, }) local Tabs = { Notice = Window:AddTab("通知", "info"), Player = Window:AddTab("玩家修改", "user"), Gun = Window:AddTab("枪械功能", "target"), KA = Window:AddTab("杀戮光环", "skull"), Teleports = Window:AddTab("传送点", "map-pin"), Settings = Window:AddTab("设置", "settings"), } local NoticeGroup = Tabs.Notice:AddLeftGroupbox("作者消息") NoticeGroup:AddLabel('wdfex') NoticeGroup:AddLabel('创作者：wdfex')

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
    if flyState.hum then flyState.hum:ChangeState(Enum.HumanoidStateType.Running) end
end

player.CharacterAdded:Connect(function()
    if flyState.enabled then
        stopFly()
        task.wait(0.2)
        startFly()
    end
end)


local interactEnabled = false
local ScanPrompts

local speedBypassOn = false
local speedBypassValue = 20
RunService.Heartbeat:Connect(function(dt)
    if not speedBypassOn then return end
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if hum and root and hum.MoveDirection.Magnitude > 0 then
        root.CFrame = root.CFrame + hum.MoveDirection * speedBypassValue * dt
    end
end)

local staminaOn = false
local godOn = false
local StaminaEvent
pcall(function()
    StaminaEvent = ReplicatedStorage:WaitForChild("Remote", 5):WaitForChild("PlayerEvent", 5)
end)
if StaminaEvent then
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if self == StaminaEvent and method == "FireServer" then
            if args[1] == "setStaminaOrFood" and args[2] == "stamina" and staminaOn then
                args[3] = 100
                return oldNamecall(self, unpack(args))
            end
            if args[1] == "takeDamage" and godOn then
                return
            end
        end
        return oldNamecall(self, ...)
    end)
end
task.spawn(function()
    while not isDestroyed do
        if staminaOn and StaminaEvent then
            pcall(function()
                StaminaEvent:FireServer("setStaminaOrFood", "stamina", 100)
            end)
        end
        task.wait(0.3)
    end
end)

local teamEspOn = false
local teamTracked = {}
local function teamClearAll()
    for plr, data in pairs(teamTracked) do
        pcall(function() if data.Highlight then data.Highlight:Destroy() end end)
        pcall(function() if data.Billboard then data.Billboard:Destroy() end end)
        teamTracked[plr] = nil
    end
end
local function teamApply(plr)
    if plr == player then return end
    local char = plr.Character
    if not char then return end
    local old = teamTracked[plr]
    if old then
        pcall(function() if old.Highlight then old.Highlight:Destroy() end end)
        pcall(function() if old.Billboard then old.Billboard:Destroy() end end)
        teamTracked[plr] = nil
    end
    local isTeam = plr.Team ~= nil and player.Team ~= nil and plr.Team == player.Team
    local color = isTeam and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    local hl = Instance.new("Highlight")
    hl.Adornee = char
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.FillColor = color
    hl.OutlineColor = color
    hl.Parent = char
    local bb
    local head = char:FindFirstChild("Head")
    if head then
        bb = Instance.new("BillboardGui")
        bb.Size = UDim2.new(0, 100, 0, 22)
        bb.StudsOffset = Vector3.new(0, 3.2, 0)
        bb.AlwaysOnTop = true
        bb.Adornee = head
        local tl = Instance.new("TextLabel")
        tl.Size = UDim2.new(1, 0, 1, 0)
        tl.BackgroundTransparency = 1
        tl.Text = isTeam and "队友" or "敌人"
        tl.TextColor3 = color
        tl.TextStrokeTransparency = 0
        tl.Font = Enum.Font.GothamBold
        tl.TextSize = 14
        tl.Parent = bb
        bb.Parent = head
    end
    teamTracked[plr] = { Highlight = hl, Billboard = bb }
end

-- teamEsp 实时刷新已包含在上面的全局循环中

Players.PlayerRemoving:Connect(function(plr)
    local data = teamTracked[plr]
    if data then
        pcall(function() if data.Highlight then data.Highlight:Destroy() end end)
        pcall(function() if data.Billboard then data.Billboard:Destroy() end end)
        teamTracked[plr] = nil
    end
end)

local zzEnabled = false
local zzDistance = 40
local zzAffected = nil
local function zzRestore()
    if zzAffected and zzAffected.Parent then
        pcall(function()
            zzAffected.Size = Vector3.new(2, 1, 1)
            zzAffected.Transparency = 0
        end)
    end
    zzAffected = nil
end
task.spawn(function()
    while not isDestroyed do
        if zzEnabled then
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local best, bestDist = nil, zzDistance
            if root then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player and p.Character then
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        local head = p.Character:FindFirstChild("Head")
                        if hum and hum.Health > 0 and head then
                            local d = (head.Position - root.Position).Magnitude
                            if d < bestDist then
                                bestDist = d
                                best = head
                            end
                        end
                    end
                end
            end
            if best ~= zzAffected then
                zzRestore()
                if best then
                    zzAffected = best
                    pcall(function()
                        best.Size = Vector3.new(500, 500, 500)
                        best.Transparency = 1
                        best.CanCollide = false
                    end)
                end
            end
        else
            zzRestore()
        end
        task.wait(0.2)
    end
end)

local aimOn = false
local aimFOV = 150
local aimNoTeam = true
local aimWall = true
local aimGui, aimCircle
local function aimEnsureCircle()
    if aimGui then return end
    aimGui = Instance.new("ScreenGui")
    aimGui.Name = "SA_AimFOV"
    aimGui.ResetOnSpawn = false
    aimGui.IgnoreGuiInset = true
    aimGui.Parent = player:WaitForChild("PlayerGui")
    aimCircle = Instance.new("Frame")
    aimCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    aimCircle.Position = UDim2.fromScale(0.5, 0.5)
    aimCircle.BackgroundTransparency = 1
    aimCircle.Parent = aimGui
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.4
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = aimCircle
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = aimCircle
end
RunService.RenderStepped:Connect(function()
    if not aimOn then
        if aimGui then aimGui.Enabled = false end
        return
    end
    aimEnsureCircle()
    aimGui.Enabled = true
    aimCircle.Size = UDim2.fromOffset(aimFOV * 2, aimFOV * 2)
    local camera = workspace.CurrentCamera
    if not camera then return end
    local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local best, bestDist = nil, aimFOV
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local head = p.Character:FindFirstChild("Head")
            if hum and hum.Health > 0 and head then
                local skip = aimNoTeam and p.Team ~= nil and player.Team ~= nil and p.Team == player.Team
                if not skip then
                    local sp, onScreen = camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                        if d < bestDist then
                            local visible = true
                            if aimWall then
                                local rp = RaycastParams.new()
                                rp.FilterType = Enum.RaycastFilterType.Exclude
                                rp.FilterDescendantsInstances = { player.Character }
                                local res = Workspace:Raycast(camera.CFrame.Position, (head.Position - camera.CFrame.Position).Unit * 500, rp)
                                visible = (not res) or res.Instance:IsDescendantOf(p.Character)
                            end
                            if visible then
                                bestDist = d
                                best = head
                            end
                        end
                    end
                end
            end
        end
    end
    if best then
        camera.CFrame = CFrame.lookAt(camera.CFrame.Position, best.Position)
    end
end)

local infAmmoEnabled = false
task.spawn(function()
    while not isDestroyed do
        if infAmmoEnabled then
            local characterFolder = Workspace:FindFirstChild("Characters") and Workspace.Characters:FindFirstChild(player.Name)
            if characterFolder then
                for _, gun in ipairs(characterFolder:GetChildren()) do
                    local config = gun:FindFirstChild("Config")
                    if config then
                        local ammo = config:FindFirstChild("Ammo")
                        local totalAmmo = config:FindFirstChild("TotalAmmo")
                        if ammo then ammo.Value = math.huge end
                        if totalAmmo then totalAmmo.Value = math.huge end
                    end
                end
            end
        end
        RunService.Heartbeat:Wait()
    end
end)

local KA_MAX_DISTANCE = 300
local KA_WALL_CHECK = true
local kaEnabled = false
local kaDamageMultiplier = 1
local KAPoliceOnly = false
local KACivilianOnly = false
local kaStatusLabel = nil

local function kaIsVisible(targetHead)
    local char = player.Character
    if not char then return false end
    local myHead = char:FindFirstChild("Head")
    if not myHead then return false end
    local direction = targetHead.Position - myHead.Position
    local distance = direction.Magnitude
    if distance < 0.1 then return true end
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {char, targetHead.Parent}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    return Workspace:Raycast(myHead.Position, direction.Unit * distance, rayParams) == nil
end

local function kaGetNearestEnemy()
    local char = player.Character
    if not char then return nil end
    local myHead = char:FindFirstChild("Head")
    if not myHead then return nil end
    local bestPlayer, bestDist = nil, KA_MAX_DISTANCE
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            -- 仅攻击警察过滤
            if KAPoliceOnly then
                local isPolice = false
                if p.Team then
                    local teamName = p.Team.Name or ""
                    if teamName:find("警察") or teamName:find("Police") or teamName:find("Cop") or teamName:find("sheriff") then
                        isPolice = true
                    end
                end
                if not isPolice then
                    for _, child in ipairs(p.Character:GetDescendants()) do
                        if child:IsA("StringValue") or child:IsA("BoolValue") or child:IsA("IntValue") then
                            local name = child.Name:lower()
                            if name:find("police") or name:find("cop") or name:find("警") or name:find("sheriff") then
                                isPolice = true
                                break
                            end
                        end
                    end
                end
                if not isPolice then
                    goto continue
                end
            end
            -- 仅攻击平民过滤
            if KACivilianOnly then
                local isPolice = false
                if p.Team then
                    local teamName = p.Team.Name or ""
                    if teamName:find("警察") or teamName:find("Police") or teamName:find("Cop") or teamName:find("sheriff") then
                        isPolice = true
                    end
                end
                if not isPolice then
                    for _, child in ipairs(p.Character:GetDescendants()) do
                        if child:IsA("StringValue") or child:IsA("BoolValue") or child:IsA("IntValue") then
                            local name = child.Name:lower()
                            if name:find("police") or name:find("cop") or name:find("警") or name:find("sheriff") then
                                isPolice = true
                                break
                            end
                        end
                    end
                end
                if isPolice then
                    goto continue
                end
            end
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local head = p.Character:FindFirstChild("Head")
                if head then
                    local dist = (head.Position - myHead.Position).Magnitude
                    if dist < bestDist and (not KA_WALL_CHECK or kaIsVisible(head)) then
                        bestDist = dist
                        bestPlayer = p
                    end
                end
            end
        end
        ::continue::
    end
    return bestPlayer
end

local function kaSetStatus(text)
    if kaStatusLabel then
        pcall(function() kaStatusLabel:SetText(text) end)
    end
end

RunService.Heartbeat:Connect(function()
    if not isDestroyed then
        if kaEnabled then
            do
                local target = kaGetNearestEnemy()
                local targetHead = target and target.Character and target.Character:FindFirstChild("Head")
                if targetHead then
                    local myHead = player.Character and player.Character:FindFirstChild("Head")
                    if myHead then
                        local origin = myHead.Position
                        local hitPos = targetHead.Position
                        local direction = (hitPos - origin).Unit
                        local damage = 100 * kaDamageMultiplier
                        pcall(function()
                            ReplicatedStorage.Remote.PlayerEvent:FireServer("damage", {
                                bodyParts = { { "Head", damage } },
                                shotCode = { origin, direction },
                                target = target,
                                pos = hitPos
                            })
                        end)
                        pcall(function()
                            local handleShots = ReplicatedStorage:FindFirstChild("Events")
                            handleShots = handleShots and handleShots:FindFirstChild("HandleShots")
                            if handleShots then
                                handleShots:FireServer("2", "Shoot")
                            end
                        end)
                        kaSetStatus("状态：已锁定 " .. target.Name .. "，攻击已发送")
                    else
                        kaSetStatus("状态：等待角色头部加载")
                    end
                else
                    kaSetStatus("状态：范围内未找到敌人")
                end
            end
        end
    end
end)

local weaponGroup = Tabs.Gun:AddLeftGroupbox("枪械功能")
weaponGroup:AddToggle("FastFire", {
    Text = "超快射速",
    Default = false,
    Callback = function(value)
        if not value then return end
        local function ModifyWeaponStats()
            local garbage = getgc(true)
            for _, tbl in pairs(garbage) do
                if type(tbl) == "table" then
                    if rawget(tbl, "SHOOT_MODE") then
                        rawset(tbl, "SHOOT_MODE", 2)
                    end
                    if rawget(tbl, "RPM") then
                        rawset(tbl, "RPM", math.huge)
                    end
                    if rawget(tbl, "DAMAGE") then
                        rawset(tbl, "DAMAGE", math.huge)
                    end
                end
            end
        end
        ModifyWeaponStats()
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Died:Connect(ModifyWeaponStats)
            end
        end
        Library:Notify({ Title = "武器强化", Description = "无限射速已生效，死亡后自动重新生效", Time = 3 })
    end
})
weaponGroup:AddToggle("InfAmmo", {
    Text = "无限子弹",
    Default = false,
    Callback = function(value)
        infAmmoEnabled = value
    end
})

local mainLeftGroup = Tabs.Player:AddRightGroupbox("快速互动")
mainLeftGroup:AddToggle("InteractToggle", {
    Text = "启用快速互动",
    Default = false,
    Callback = function(value)
        interactEnabled = value
        if value and ScanPrompts then ScanPrompts() end
    end
})
mainLeftGroup:AddDivider()
mainLeftGroup:AddSlider("HoldTime", {
    Text = "按住时间",
    Default = 0,
    Min = 0,
    Max = 10,
    Rounding = 0,
    Suffix = "秒",
    Callback = function(value)
        Settings.HoldTime = value
        if not interactEnabled then return end
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = value
            end
        end
    end
})
mainLeftGroup:AddSlider("Distance", {
    Text = "触发距离",
    Default = 25,
    Min = 5,
    Max = 150,
    Rounding = 0,
    Suffix = "单位",
    Callback = function(value)
        Settings.Distance = value
        if not interactEnabled then return end
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.MaxActivationDistance = value
            end
        end
    end
})

local godGroup = Tabs.Player:AddRightGroupbox("伤害免疫")
godGroup:AddToggle("GodToggle", {
    Text = "免疫部分伤害",
    Default = false,
    Callback = function(value)
        godOn = value
    end
})
godGroup:AddLabel("免疫火焰和车爆炸时候的伤害")

local espGroup = Tabs.Gun:AddRightGroupbox("透视")
espGroup:AddToggle("ESPEnabled", {
    Text = "启用透视",
    Default = false,
    Callback = function(value)
        Settings.ESPEnabled = value
        if value then
            UpdateAllESP()
        else
            for userId, data in pairs(espBillboards) do
                if data.Billboard then
                    data.Billboard.Enabled = false
                end
            end
        end
    end
})
espGroup:AddDivider()
espGroup:AddToggle("ESPShowName", {
    Text = "显示名字（队伍颜色）",
    Default = true,
    Callback = function(value)
        Settings.ESPShowName = value
        UpdateESPVisibility()
    end
})
espGroup:AddToggle("ESPShowJob", {
    Text = "显示职业（职业颜色）",
    Default = true,
    Callback = function(value)
        Settings.ESPShowJob = value
        UpdateESPVisibility()
    end
})
espGroup:AddDivider()
espGroup:AddToggle("OutlineESPEnabled", {
    Text = "人物描边透视（警察蓝色/平民白色）",
    Default = false,
    Callback = function(value)
        ToggleOutlineESP(value)
    end
})

local mainRightGroup = Tabs.Gun:AddLeftGroupbox("碰撞箱扩展")
mainRightGroup:AddToggle("HitboxToggle", {
    Text = "启用头部碰撞箱（推荐20-25）",
    Default = false,
    Callback = function(value)
        Settings.HitboxEnabled = value
        if value then ApplyHitbox() else ResetHitbox() end
    end
})
mainRightGroup:AddSlider("HitboxSize", {
    Text = "头部大小",
    Default = 10,
    Min = 5,
    Max = 400,
    Rounding = 0,
    Suffix = "单位",
    Callback = function(value)
        Settings.HitboxSize = value
        if Settings.HitboxEnabled then ApplyHitbox() end
    end
})
mainRightGroup:AddToggle("WhitelistToggle", {
    Text = "好友检测 (白名单)",
    Default = false,
    Callback = function(value)
        Settings.WhitelistEnabled = value
        if value then UpdateWhitelist() end
    end
})


local flyGroup = Tabs.Player:AddLeftGroupbox("角色修改")
flyGroup:AddToggle("FlyToggle", {
    Text = "飞行（绕过）",
    Default = false,
    Callback = function(value)
        if value then startFly() else stopFly() end
    end
})
flyGroup:AddSlider("FlySpeed", {
    Text = "飞行速度",
    Default = 35,
    Min = 10,
    Max = 620,
    Rounding = 0,
    Callback = function(value)
        FlySpeed = value
    end
})
flyGroup:AddDivider()
flyGroup:AddToggle("NoclipToggle", {
    Text = "启用人物穿墙",
    Default = false,
    Callback = function(value)
        ToggleNoclip(value)
    end
})
flyGroup:AddDivider()
flyGroup:AddToggle("SpeedBypassToggle", {
    Text = "修改移速（绕过）（速度推荐80-90）",
    Default = false,
    Callback = function(value)
        speedBypassOn = value
    end
})
flyGroup:AddSlider("SpeedBypassValue", {
    Text = "移速",
    Default = 20,
    Min = 5,
    Max = 150,
    Rounding = 0,
    Callback = function(value)
        speedBypassValue = value
    end
})
flyGroup:AddDivider()
flyGroup:AddToggle("StaminaToggle", {
    Text = "无限体力",
    Default = false,
    Callback = function(value)
        staminaOn = value
    end
})

-- 飞天快捷开关
local flyQuickToggle = false
local flyQuickButton = nil
local flyQuickScreenGui = nil
local flyQuickStatusLabel = nil
local flyQuickDragging = false
local flyQuickDragStart = nil
local flyQuickDragOffset = nil

local function DestroyFlyQuickToggle()
    if flyQuickScreenGui then
        flyQuickScreenGui:Destroy()
        flyQuickScreenGui = nil
        flyQuickButton = nil
        flyQuickStatusLabel = nil
    end
end

local function CreateFlyQuickToggle()
    if flyQuickButton then return end
    
    flyQuickScreenGui = Instance.new("ScreenGui")
    flyQuickScreenGui.Name = "FlyQuickToggle"
    flyQuickScreenGui.ResetOnSpawn = false
    flyQuickScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    flyQuickScreenGui.Parent = player:WaitForChild("PlayerGui")
    
    local button = Instance.new("ImageButton")
    button.Size = UDim2.new(0, 60, 0, 60)
    button.Position = UDim2.new(0.5, -30, 0.15, 0)
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    button.BackgroundTransparency = 0.15
    button.BorderSizePixel = 2
    button.BorderColor3 = Color3.fromRGB(100, 200, 255)
    button.Image = "rbxassetid://7734068321"
    button.ImageColor3 = Color3.fromRGB(100, 200, 255)
    button.ScaleType = Enum.ScaleType.Fit
    button.Parent = flyQuickScreenGui
    flyQuickButton = button
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = button
    
    -- 状态标签
    flyQuickStatusLabel = Instance.new("TextLabel")
    flyQuickStatusLabel.Size = UDim2.new(1, 0, 0, 20)
    flyQuickStatusLabel.Position = UDim2.new(0, 0, 1, 0)
    flyQuickStatusLabel.BackgroundTransparency = 1
    flyQuickStatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyQuickStatusLabel.TextSize = 12
    flyQuickStatusLabel.Font = Enum.Font.GothamBold
    flyQuickStatusLabel.TextStrokeTransparency = 0.3
    flyQuickStatusLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    flyQuickStatusLabel.Text = "飞行: 关"
    flyQuickStatusLabel.Parent = button
    
    -- 更新状态
    local function updateFlyStatus()
        if flyQuickStatusLabel then
            flyQuickStatusLabel.Text = flyState.enabled and "飞行: 开" or "飞行: 关"
            if flyQuickButton then
                flyQuickButton.BorderColor3 = flyState.enabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 200, 255)
                flyQuickButton.ImageColor3 = flyState.enabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 200, 255)
            end
        end
    end
    
    -- 按钮点击切换飞行
    button.MouseButton1Click:Connect(function()
        if flyState.enabled then
            stopFly()
        else
            startFly()
        end
        updateFlyStatus()
    end)
    
    -- 拖动功能
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local time = tick()
            dragging = true
            dragStart = input.Position
            startPos = button.Position
        end
    end)
    
    button.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(
                startPos.X.Scale + delta.X / player:WaitForChild("PlayerGui").AbsoluteSize.X,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale + delta.Y / player:WaitForChild("PlayerGui").AbsoluteSize.Y,
                startPos.Y.Offset + delta.Y
            )
            button.Position = newPos
        end
    end)
    
    button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- 初始更新状态
    updateFlyStatus()
    
    -- 监听飞行状态变化
    local statusConn = RunService.Heartbeat:Connect(function()
        if flyQuickToggle and flyQuickStatusLabel then
            updateFlyStatus()
        end
    end)
    table.insert(connections, statusConn)
end

flyGroup:AddDivider()
flyGroup:AddToggle("FlyQuickToggle", {
    Text = "飞天快捷开关",
    Desc = "开启后在屏幕显示可拖动的飞天开关",
    Default = false,
    Callback = function(value)
        flyQuickToggle = value
        if value then
            CreateFlyQuickToggle()
        else
            DestroyFlyQuickToggle()
        end
    end
})

-- 杀戮光环独立Tab
local kaGroup = Tabs.KA:AddLeftGroupbox("杀戮光环")
kaGroup:AddLabel("注意：需装备枪械武器才有伤害")
kaGroup:AddToggle("KAToggle", {
    Text = "启用杀戮光环",
    Default = false,
    Callback = function(value)
        kaEnabled = value
        if value then
            Library:Notify({ Title = "杀戮光环", Description = "已开启，正在搜索敌人", Time = 3 })
            kaSetStatus("状态：已开启，正在搜索敌人")
        else
            kaSetStatus("状态：已关闭")
        end
    end
})
kaGroup:AddSlider("KADistance", {
    Text = "攻击距离",
    Default = 300,
    Min = 50,
    Max = 1000,
    Rounding = 0,
    Suffix = "单位",
    Callback = function(value)
        KA_MAX_DISTANCE = value
    end
})
kaGroup:AddToggle("KAWallCheck", {
    Text = "墙体检测",
    Default = true,
    Callback = function(value)
        KA_WALL_CHECK = value
    end
})
kaGroup:AddSlider("KADamage", {
    Text = "伤害倍率",
    Default = 1,
    Min = 1,
    Max = 100,
    Rounding = 0,
    Suffix = "倍",
    Callback = function(value)
        kaDamageMultiplier = value
    end
})
kaGroup:AddDivider()
kaGroup:AddToggle("KAPoliceOnly", {
    Text = "仅攻击警察",
    Desc = "开启后杀戮光环只攻击警察队伍",
    Default = false,
    Callback = function(value)
        KAPoliceOnly = value
        if value then
            KACivilianOnly = false
            Toggles.KACivilianOnly:Set(false)
            Library:Notify({ Title = "杀戮光环", Description = "已切换至只攻击警察", Time = 2 })
        end
    end
})
kaGroup:AddToggle("KACivilianOnly", {
    Text = "仅攻击平民",
    Desc = "开启后杀戮光环只攻击平民队伍（非警察）",
    Default = false,
    Callback = function(value)
        KACivilianOnly = value
        if value then
            KAPoliceOnly = false
            Toggles.KAPoliceOnly:Set(false)
            Library:Notify({ Title = "杀戮光环", Description = "已切换至只攻击平民", Time = 2 })
        end
    end
})
kaStatusLabel = kaGroup:AddLabel("状态：已关闭")

local zzGroup = Tabs.Gun:AddLeftGroupbox("子追")
zzGroup:AddToggle("ZZToggle", {
    Text = "启用子追",
    Default = false,
    Callback = function(value)
        zzEnabled = value
        if not value then zzRestore() end
    end
})
zzGroup:AddSlider("ZZDistance", {
    Text = "判定距离",
    Default = 40,
    Min = 0,
    Max = 1000,
    Rounding = 0,
    Suffix = "米",
    Callback = function(value)
        zzDistance = value
    end
})

local aimGroup = Tabs.Gun:AddRightGroupbox("自瞄")
aimGroup:AddToggle("AimToggle", {
    Text = "自瞄",
    Default = false,
    Callback = function(value)
        aimOn = value
    end
})
aimGroup:AddSlider("AimFOVSize", {
    Text = "FOV圈大小",
    Default = 150,
    Min = 30,
    Max = 400,
    Rounding = 0,
    Callback = function(value)
        aimFOV = value
    end
})
aimGroup:AddToggle("AimNoTeam", {
    Text = "不瞄准队友",
    Default = true,
    Callback = function(value)
        aimNoTeam = value
    end
})
aimGroup:AddToggle("AimWallCheck", {
    Text = "墙壁检测",
    Default = true,
    Callback = function(value)
        aimWall = value
    end
})

local teamEspGroup = Tabs.Gun:AddRightGroupbox("敌我透视")
teamEspGroup:AddLabel("红色标注敌人，绿色标注队友")
teamEspGroup:AddToggle("TeamESP", {
    Text = "透视敌人和队友",
    Default = false,
    Callback = function(value)
        teamEspOn = value
        if not value then teamClearAll() end
    end
})

task.spawn(function()
    while not isDestroyed do
        if Settings.OutlineESPEnabled then
            UpdateOutlineESP()
        end
        task.wait(0.5)
    end
end)

local teleTab = Tabs.Teleports
local teleLeftGroup = teleTab:AddLeftGroupbox("传送控制")
teleLeftGroup:AddToggle("TeleportToggle", {
    Text = "启用传送",
    Default = false,
    Callback = function(value)
        Settings.TeleportEnabled = value
    end
})

local teleNames = {}
for _, data in ipairs(FIXED_TELEPORTS) do
    table.insert(teleNames, data.n)
end

teleLeftGroup:AddDropdown("TeleportSelect", {
    Values = teleNames,
    Default = 1,
    Multi = false,
    Text = "选定传送地点",
    Callback = function(value) end,
})

teleLeftGroup:AddButton({
    Text = "传送到选定地点",
    Func = function()
        if not Settings.TeleportEnabled then
            Library:Notify({ Title = "传送", Description = "你还没有开启传送开关，请先开启", Time = 3 })
            return
        end
        local selected = Options.TeleportSelect.Value
        for _, data in ipairs(FIXED_TELEPORTS) do
            if data.n == selected then
                TeleportTo(data.p)
                Library:Notify({
                    Title = "传送",
                    Description = "正在传送至: " .. data.n,
                    Time = 2,
                })
                return
            end
        end
        Library:Notify({ Title = "传送", Description = "未找到该地点", Time = 2 })
    end,
})



local function onPlayerAdded(p)
    p.CharacterAdded:Connect(function()
        task.wait(0.5)
        if Settings.ESPEnabled and p ~= player then
            CreateESP(p)
            UpdateESPVisibility()
        end
        if Settings.OutlineESPEnabled and p ~= player then
            RemoveOutlineESP(p.UserId)
            CreateOutlineESP(p)
        end
        if Settings.HitboxEnabled and not isDestroyed then
            task.wait(0.5)
            ApplyHitbox()
        end
        if Settings.NoclipEnabled and not isDestroyed then
            task.wait(0.1)
            ApplyNoclip()
        end
    end)
    if Settings.WhitelistEnabled and not isDestroyed then
        UpdateWhitelist()
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    onPlayerAdded(p)
end
local playerAddedCon = Players.PlayerAdded:Connect(onPlayerAdded)
table.insert(connections, playerAddedCon)
local playerRemovedCon = Players.PlayerRemoving:Connect(function(p)
    RemoveESP(p.UserId)
    RemoveOutlineESP(p.UserId)
end)
table.insert(connections, playerRemovedCon)

local renderCon = RunService.RenderStepped:Connect(function()
    if isDestroyed then return end
    if Settings.HitboxEnabled then
        frameCount = frameCount + 1
        if frameCount % 3 == 0 then
            ApplyHitbox()
        end
    end
    if Settings.NoclipEnabled then
        ApplyNoclip()
    end
    if Settings.ESPEnabled then
        for userId, data in pairs(espBillboards) do
            local p = Players:FindFirstChild(tostring(userId))
            if p and p.Character then
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
end)
table.insert(connections, renderCon)

task.spawn(function()
    while not isDestroyed do
        task.wait(10)
        if Settings.WhitelistEnabled and not isDestroyed then
            UpdateWhitelist()
        end
        if Settings.ESPEnabled then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    if not espBillboards[p.UserId] then
                        CreateESP(p)
                        UpdateESPVisibility()
                    end
                end
            end
        end
    end
end)

ScanPrompts = function()
    if isDestroyed or not interactEnabled then return end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            obj.HoldDuration = Settings.HoldTime
            obj.MaxActivationDistance = Settings.Distance
        end
    end
end
local descendantCon = workspace.DescendantAdded:Connect(function(obj)
    if isDestroyed then return end
    task.wait(0.1)
    if obj:IsA("ProximityPrompt") and interactEnabled then
        obj.HoldDuration = Settings.HoldTime
        obj.MaxActivationDistance = Settings.Distance
    end
end)
table.insert(connections, descendantCon)

Library:OnUnload(function()
    if isDestroyed then return end
    isDestroyed = true
    stopFly()
    flyQuickToggle = false
    DestroyFlyQuickToggle()
    teamClearAll()
    zzRestore()
    if aimGui then aimGui:Destroy() end
    ResetHitbox()
    if Settings.NoclipEnabled then
        ToggleNoclip(false)
    end
    if Settings.OutlineESPEnabled then
        ToggleOutlineESP(false)
    end
    ClearAllOutlineESP()
    for userId, data in pairs(espBillboards) do
        if data.Billboard then
            data.Billboard:Destroy()
        end
    end
    espBillboards = {}
    for _, conn in ipairs(espConnections) do
        pcall(function() conn:Disconnect() end)
    end
    espConnections = {}
    for _, conn in ipairs(connections) do
        pcall(function() conn:Disconnect() end)
    end
    for _, conn in ipairs(noclipConnections) do
        pcall(function() conn:Disconnect() end)
    end
end)

local UnloadGroup = Tabs.Settings:AddLeftGroupbox("脚本管理") UnloadGroup:AddButton("卸载脚本", function() Library:Unload() end) if ThemeManager then ThemeManager:SetLibrary(Library) ThemeManager:SetFolder("MyScriptTheme") ThemeManager:ApplyToTab(Tabs.Settings) end if SaveManager then SaveManager:SetLibrary(Library) SaveManager:IgnoreThemeSettings() SaveManager:SetFolder("MyScriptConfig") SaveManager:BuildConfigSection(Tabs.Settings) end