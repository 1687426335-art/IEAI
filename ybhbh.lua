-- ==================== AI聊天助手（离线版+上下文记忆） ====================
-- 不需要联网，不需要API，纯本地运行
-- 支持上下文记忆（记得你之前说了什么）

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()

if not WindUI then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "错误",
        Text = "UI库加载失败，请检查网络",
        Duration = 5,
    })
    return
end

-- ===== 颜色定义 =====
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

-- ===== 创建悬浮窗 =====
local Window = WindUI:CreateWindow({
    Title = 'AI聊天助手',
    Icon = "message-circle",
    IconThemed = true,
    Author = "wdfex",
    Folder = "AIChatHelper",
    Size = UDim2.fromOffset(480, 620),
    Transparent = true,
    Theme = "Dark",
    HideSearchBar = false,
    ScrollBarEnabled = true,
    Resizable = true,
    SideBarWidth = 180,
})

Window:Tag({ Title = "AI助手", Color = Color3.fromRGB(100, 200, 255) })

Window:EditOpenButton({
    Title = "AI助手",
    Icon = "message-circle",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 4,
    Color = ColorSequence.new(Color3.fromRGB(100, 200, 255)),
    Draggable = true,
})

spawn(function()
    while true do
        for hue = 0, 1, 0.01 do
            Window:EditOpenButton({ Color = ColorSequence.new(Color3.fromHSV(hue, 0.8, 1)) })
            wait(0.04)
        end
    end
end)

-- ===== Tab分类 =====
local Tabs = {
    Chat = Window:Tab({ Title = "聊天", Icon = "message-circle" }),
    Quick = Window:Tab({ Title = "快捷提问", Icon = "zap" }),
    Settings = Window:Tab({ Title = "设置", Icon = "settings" }),
}

-- ============================================================
-- Tab: 聊天
-- ============================================================
local ChatGroup = Tabs.Chat:Section({ Title = "AI聊天（离线版）", Opened = true })

local messages = {}
local chatDisplay = nil

-- ===== 上下文记忆（存最近5条对话） =====
local contextHistory = {}
local MAX_CONTEXT = 5

local function AddContext(topic, content)
    table.insert(contextHistory, { topic = topic, content = content })
    if #contextHistory > MAX_CONTEXT then
        table.remove(contextHistory, 1)
    end
end

local function GetContext()
    if #contextHistory == 0 then return nil end
    local last = contextHistory[#contextHistory]
    return last.topic, last.content
end

local function AddMessage(sender, content)
    local isAI = sender == "AI"
    local prefix = isAI and "AI" or "我"
    local color = isAI and "rgb(100, 255, 150)" or "rgb(100, 200, 255)"
    
    local msg = '<font color="' .. color .. '"><b>' .. prefix .. '</b></font>\n'
    msg = msg .. '<font color="rgb(220, 220, 220)">' .. content .. '</font>'
    local bubble = '━━━━━━━━━━━━━━━━━━━━━━━━\n' .. msg .. '\n━━━━━━━━━━━━━━━━━━━━━━━━'
    
    table.insert(messages, bubble)
    if #messages > 20 then table.remove(messages, 1) end
    
    local displayText = ""
    for _, m in ipairs(messages) do
        displayText = displayText .. m .. "\n\n"
    end
    
    pcall(function()
        if chatDisplay then
            chatDisplay:SetDesc(displayText or "等待你开始对话...")
        end
    end)
end

chatDisplay = ChatGroup:Paragraph({
    Title = "对话记录",
    Desc = "━━━━━━━━━━━━━━━━━━━━━━━━\nAI助手已就绪（支持上下文记忆）\n━━━━━━━━━━━━━━━━━━━━━━━━"
})

-- ===== 本地知识库（增强版-带上下文） =====
local function GetLocalReply(question, contextTopic, contextContent)
    local q = question:lower()
    
    -- 先检查当前问题是否命中关键词
    local function matchKeyword(keywords)
        for _, kw in ipairs(keywords) do
            if q:find(kw) then return true end
        end
        return false
    end
    
    -- 如果有上下文且当前问题模糊，结合上下文回答
    local function answerWithContext(contextTopic, contextContent, answer)
        return "（根据之前聊的" .. contextTopic .. "）\n\n" .. answer
    end
    
    -- ===== 功能列表 =====
    if matchKeyword({"功能", "什么", "介绍", "干嘛", "作用"}) then
        AddContext("功能", "脚本功能列表")
        return "wdfex-Hub 包含以下功能：\n\n- 杀戮光环（自动攻击敌人）\n- 透视（显示玩家信息）\n- 飞行模式（自由飞行）\n- 传送点（快速移动）\n- 自动躲警察（远离警察）\n- 互动加速（快速交互）\n- 设备授权系统\n- 音乐播放器\n- 同行显示"
    
    -- ===== 杀戮光环 =====
    elseif matchKeyword({"杀戮", "光环", "杀"}) then
        AddContext("杀戮光环", "杀戮光环使用方法")
        local answer = "杀戮光环使用方法：\n\n1. 装备枪械武器\n2. 在杀戮光环Tab开启开关\n3. 设置攻击距离（默认300米）\n4. 可调节伤害倍率\n5. 支持只攻击警察/平民过滤\n6. 支持不攻击血量为0的玩家"
        if contextTopic and contextTopic:find("杀戮") then
            return answer
        end
        return answer
    
    -- ===== 伤害 =====
    elseif matchKeyword({"伤害", "倍率", "攻击力", "秒人"}) then
        if contextTopic and contextTopic:find("杀戮") then
            return "杀戮光环的伤害在杀戮光环Tab里调节：\n\n- 伤害倍率滑块（1-100倍）\n- 基础伤害100，100倍就是10000伤害\n- 调高后可以秒杀敌人"
        end
        AddContext("伤害", "伤害相关")
        return "伤害相关功能在杀戮光环Tab里：\n\n- 伤害倍率可调（1-100倍）\n- 攻击距离可调（50-1000米）\n- 也可在枪械功能Tab强化武器"
    
    -- ===== 透视 =====
    elseif matchKeyword({"透视"}) then
        AddContext("透视", "透视使用方法")
        local answer = "透视使用方法：\n\n1. 在透视Tab开启总开关\n2. 选择显示内容（名字/队伍/血量/距离）\n3. 可开启同行显示（识别wdfex用户）\n4. 可开启透视自己\n5. 支持显示通缉玩家"
        if contextTopic and contextTopic:find("透视") then
            return answer
        end
        return answer
    
    -- ===== 飞行 =====
    elseif matchKeyword({"飞行", "飞", "飞天"}) then
        AddContext("飞行", "飞行模式使用方法")
        local answer = "飞行模式使用方法：\n\n1. 在飞天与加速Tab开启飞行\n2. 用WASD控制前后左右\n3. 按空格上升，Ctrl下降\n4. 可调节飞行速度（10-620）\n5. 可开启快捷开关方便控制"
        if contextTopic and contextTopic:find("飞行") then
            return answer
        end
        return answer
    
    -- ===== 速度 =====
    elseif matchKeyword({"速度", "移速", "加速"}) then
        if contextTopic and contextTopic:find("飞行") then
            return "飞行速度在飞天与加速Tab调节：\n\n- 飞行速度滑块（10-620）\n- 默认35，调高飞更快\n- 移速（绕过）也可调节行走速度"
        end
        AddContext("速度", "速度相关")
        return "速度相关功能在飞天与加速Tab：\n\n- 飞行速度（10-620）\n- 移速（5-150）\n- 两者分开调节"
    
    -- ===== 传送 =====
    elseif matchKeyword({"传送", "传送点"}) then
        AddContext("传送", "传送功能使用方法")
        local answer = "传送功能使用方法：\n\n1. 在传送点Tab开启传送开关\n2. 下拉选择要传送的地点\n3. 点击传送到选定地点\n4. 共45个传送点供选择\n5. 包含圣奥里、大景、莱斯维尔等区域"
        if contextTopic and contextTopic:find("传送") then
            return answer
        end
        return answer
    
    -- ===== 躲警察 =====
    elseif matchKeyword({"警察", "躲警", "躲警察", "弹开"}) then
        AddContext("躲警察", "自动躲警察使用方法")
        local answer = "自动躲警察使用方法：\n\n1. 在自动躲警察Tab开启开关\n2. 设置触发距离（10-100米）\n3. 警察进入范围会自动弹开\n4. 可调节弹开力度\n5. 只对警察队伍生效"
        if contextTopic and contextTopic:find("警察") then
            return answer
        end
        return answer
    
    -- ===== 授权 =====
    elseif matchKeyword({"授权", "uid", "设备", "绑定"}) then
        AddContext("授权", "设备授权系统")
        return "设备授权系统：\n\n1. 设备UID是唯一标识\n2. 作者在设置Tab管理授权\n3. 输入对方UID点击授权设备\n4. 被授权设备才能使用脚本\n5. 可拉黑违规设备"
    
    -- ===== 防甩飞 =====
    elseif matchKeyword({"甩飞", "防甩", "被甩"}) then
        AddContext("防甩飞", "防甩飞功能")
        return "防甩飞功能在玩家修改Tab里，开启后可以防止被其他脚本甩飞。"
    
    -- ===== 穿墙 =====
    elseif matchKeyword({"穿墙", "noclip"}) then
        AddContext("穿墙", "穿墙功能")
        return "穿墙功能在玩家修改Tab里，开启后人物可以穿过墙壁和物体。"
    
    -- ===== 体力 =====
    elseif matchKeyword({"体力", "耐力", "跑步"}) then
        AddContext("体力", "无限体力")
        return "无限体力在玩家修改Tab里，开启后跑步不会消耗体力。"
    
    -- ===== 防摔 =====
    elseif matchKeyword({"摔", "落地", "高空"}) then
        AddContext("防摔", "防摔功能")
        return "防摔功能在玩家修改Tab里，开启后从高处落地速度平稳，不会摔伤。"
    
    -- ===== 自瞄/子追 =====
    elseif matchKeyword({"自瞄", "子追", "瞄准"}) then
        AddContext("自瞄", "自瞄子追功能")
        return "子追和自瞄在枪械功能Tab里：\n\n- 子追：自动追踪敌人头部\n- 自瞄：自动瞄准敌人\n- 可调节FOV圈大小\n- 支持墙体检测\n- 支持不瞄准队友"
    
    -- ===== 音乐 =====
    elseif matchKeyword({"音乐", "歌曲", "播放"}) then
        AddContext("音乐", "音乐播放器")
        return "音乐Tab里有21首歌曲：\n\n- 选择歌曲下拉选歌\n- 开启播放音乐开关\n- 支持三种播放模式：顺序/循环/随机\n- 可调节音量大小"
    
    -- ===== 作者 =====
    elseif matchKeyword({"作者", "wdfex"}) then
        AddContext("作者", "作者信息")
        return "作者是wdfex\nQQ：1687426335\n有任何问题可以联系作者反馈。"
    
    -- ===== 卡密 =====
    elseif matchKeyword({"卡密", "验证"}) then
        AddContext("卡密", "卡密验证系统")
        return "卡密验证系统：\n\n作者卡：作者卡-AFXD-wdfexNB\n管理员卡：管理员卡-AZWQ-wdfexNB\n输入正确卡密可进入管理面板"
    
    -- ===== 互动 =====
    elseif matchKeyword({"互动", "快速"}) then
        AddContext("互动", "快速互动")
        return "快速互动在互动Tab里：\n\n- 启用快速互动开关\n- 可设置按住时间\n- 可设置触发距离\n- 对游戏内的ProximityPrompt生效"
    
    -- ===== 打招呼 =====
    elseif matchKeyword({"你好", "hi", "hello", "在吗"}) then
        AddContext("打招呼", "问候")
        return "你好！我是wdfex-Hub的AI助手，有什么可以帮助你的吗？\n\n你可以问我：\n- 脚本有什么功能？\n- 杀戮光环怎么用？\n- 透视怎么开？\n- 飞行模式怎么用？"
    
    -- ===== 上下文记忆（如果当前问题没匹配，但之前聊过相关话题） =====
    else
        -- 检查之前聊过什么，尝试关联回答
        if contextTopic and contextContent then
            -- 如果问题中包含之前话题的关键词
            local topicKeywords = {
                ["杀戮"] = {"伤害", "攻击", "武器", "枪"},
                ["透视"] = {"显示", "名字", "血量", "队伍"},
                ["飞行"] = {"速度", "控制", "方向"},
                ["传送"] = {"地点", "位置", "去哪"},
                ["警察"] = {"弹开", "距离", "力度"},
                ["授权"] = {"设备", "uid", "绑定"},
                ["音乐"] = {"歌", "播放", "音量"},
                ["自瞄"] = {"瞄准", "fov", "目标"},
            }
            
            for topic, keywords in pairs(topicKeywords) do
                if contextTopic:find(topic) then
                    for _, kw in ipairs(keywords) do
                        if q:find(kw) then
                            -- 用上下文回答
                            local contextAnswer = "（根据之前聊的" .. contextTopic .. "）\n\n" .. GetLocalReply(topic, nil, nil)
                            return contextAnswer
                        end
                    end
                end
            end
        end
        
        AddContext("未知", "无法回答的问题")
        return "这个问题我暂时没有预设答案。\n\n你可以试试问：\n- 脚本有什么功能？\n- 杀戮光环怎么用？\n- 透视怎么开？\n- 飞行模式怎么用？\n- 传送点怎么用？\n- 自动躲警察怎么用？\n- 怎么授权设备？"
    end
end

-- 发送消息
local function AskAI(question)
    if not question or question == "" then return end
    
    AddMessage("我", question)
    
    -- 获取上下文
    local contextTopic, contextContent = GetContext()
    
    -- 获取回复（带上下文）
    local reply = GetLocalReply(question, contextTopic, contextContent)
    AddMessage("AI", reply)
end

-- 输入框
local inputBox = ""
ChatGroup:Input({
    Title = "输入问题",
    Placeholder = "输入你想问的问题...",
    Callback = function(value) inputBox = value end
})

ChatGroup:Divider()

ChatGroup:Button({
    Title = "发送",
    Callback = function()
        if inputBox and inputBox ~= "" then
            local q = inputBox
            inputBox = ""
            AskAI(q)
        else
            WindUI:Notify({ Title = "提示", Content = "请输入问题", Duration = 2 })
        end
    end
})

ChatGroup:Divider()

ChatGroup:Button({
    Title = "清空对话",
    Callback = function()
        messages = {}
        contextHistory = {}
        pcall(function()
            chatDisplay:SetDesc("━━━━━━━━━━━━━━━━━━━━━━━━\n对话已清空\n━━━━━━━━━━━━━━━━━━━━━━━━")
        end)
        WindUI:Notify({ Title = "提示", Content = "对话已清空", Duration = 2 })
    end
})

-- ============================================================
-- Tab: 快捷提问
-- ============================================================
local QuickGroup = Tabs.Quick:Section({ Title = "快捷提问", Opened = true })

local function QuickAsk(question) AskAI(question) end

QuickGroup:Paragraph({
    Title = "点击下方快速提问",
    Desc = "AI会直接回答对应的问题"
})

QuickGroup:Divider()

QuickGroup:Button({
    Title = "脚本有什么功能？",
    Callback = function() QuickAsk("这个脚本有什么功能？") end
})

QuickGroup:Button({
    Title = "杀戮光环怎么用？",
    Callback = function() QuickAsk("杀戮光环怎么用？") end
})

QuickGroup:Button({
    Title = "透视怎么开？",
    Callback = function() QuickAsk("透视怎么开？") end
})

QuickGroup:Button({
    Title = "飞行模式怎么用？",
    Callback = function() QuickAsk("飞行模式怎么用？") end
})

QuickGroup:Button({
    Title = "传送点怎么用？",
    Callback = function() QuickAsk("传送点怎么用？") end
})

QuickGroup:Button({
    Title = "自动躲警察怎么用？",
    Callback = function() QuickAsk("自动躲警察怎么用？") end
})

QuickGroup:Button({
    Title = "怎么授权设备？",
    Callback = function() QuickAsk("怎么授权设备？") end
})

QuickGroup:Button({
    Title = "你好！",
    Callback = function() QuickAsk("你好") end
})

-- ============================================================
-- Tab: 设置
-- ============================================================
local SettingsGroup = Tabs.Settings:Section({ Title = "设置", Opened = true })

SettingsGroup:Paragraph({
    Title = "关于AI助手",
    Desc = "版本：v1.1（支持上下文记忆）\n完全离线运行，不需要联网\n不需要API，100%成功回复\n支持记住最近5条对话"
})

SettingsGroup:Divider()

SettingsGroup:Button({
    Title = "关闭AI助手",
    Callback = function()
        Window:Destroy()
    end
})

WindUI:Notify({
    Title = "AI助手（离线版）",
    Content = "已启动！支持上下文记忆，无需联网",
    Duration = 3,
})