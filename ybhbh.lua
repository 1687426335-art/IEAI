-- ==================== AI聊天助手（气泡聊天样式） ====================
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()
local HttpService = game:GetService("HttpService")

if not WindUI then return end

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
-- Tab: 聊天（气泡样式）
-- ============================================================
local ChatGroup = Tabs.Chat:Section({ Title = "AI聊天", Opened = true })

-- 聊天记录（存储所有消息）
local messages = {}
local chatDisplay = nil

-- 添加消息（气泡样式）
local function AddMessage(sender, content)
    local isAI = sender == "AI"
    local prefix = isAI and "🤖 AI" or "🧑 我"
    local color = isAI and "rgb(100, 255, 150)" or "rgb(100, 200, 255)"
    local bgColor = isAI and "rgba(30, 60, 30, 0.5)" or "rgba(30, 40, 70, 0.5)"
    
    -- 格式化消息（带气泡框效果）
    local msg = '<font color="' .. color .. '"><b>' .. prefix .. '</b></font>\n'
    msg = msg .. '<font color="rgb(220, 220, 220)">' .. content .. '</font>'
    
    -- 用分隔线+边框模拟气泡
    local bubble = '━━━━━━━━━━━━━━━━━━━━━━━━\n' .. msg .. '\n━━━━━━━━━━━━━━━━━━━━━━━━'
    
    table.insert(messages, bubble)
    if #messages > 20 then
        table.remove(messages, 1)
    end
    
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

-- 对话显示区域
chatDisplay = ChatGroup:Paragraph({
    Title = "💬 对话记录",
    Desc = "━━━━━━━━━━━━━━━━━━━━━━━━\n🤖 AI 助手已就绪，输入问题开始聊天！\n━━━━━━━━━━━━━━━━━━━━━━━━"
})

-- AI请求函数
local function AskAI(question)
    if not question or question == "" then return end
    
    AddMessage("我", question)
    AddMessage("AI", "⏳ 思考中...")
    
    task.spawn(function()
        local success, response = pcall(function()
            local data = {
                messages = {
                    { role = "system", content = "你是一个有用的AI助手，简洁准确地回答问题。" },
                    { role = "user", content = question }
                },
                model = "gpt-3.5-turbo",
                temperature = 0.7,
                max_tokens = 500
            }
            local headers = { ["Content-Type"] = "application/json" }
            local url = "https://api.itsapi.xyz/v1/chat/completions"
            local response = HttpService:PostAsync(url, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson, false, headers)
            local result = HttpService:JSONDecode(response)
            if result and result.choices and result.choices[1] and result.choices[1].message then
                return result.choices[1].message.content
            else
                return "抱歉，我暂时无法回答。"
            end
        end)
        
        -- 移除思考中
        for i = #messages, 1, -1 do
            if string.find(messages[i], "思考中...") then
                table.remove(messages, i)
                break
            end
        end
        
        if success and response then
            AddMessage("AI", response)
        else
            AddMessage("AI", "❌ 请求失败，请检查网络。")
        end
    end)
end

-- 输入框
local inputBox = ""
ChatGroup:Input({
    Title = "输入问题",
    Placeholder = "输入你想问的问题...",
    Callback = function(value)
        inputBox = value
    end
})

ChatGroup:Divider()

ChatGroup:Button({
    Title = "🚀 发送",
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
    Title = "🗑 清空对话",
    Callback = function()
        messages = {}
        pcall(function()
            chatDisplay:SetDesc("━━━━━━━━━━━━━━━━━━━━━━━━\n🤖 对话已清空，开始新的聊天吧！\n━━━━━━━━━━━━━━━━━━━━━━━━")
        end)
        WindUI:Notify({ Title = "提示", Content = "对话已清空", Duration = 2 })
    end
})

-- ============================================================
-- Tab: 快捷提问
-- ============================================================
local QuickGroup = Tabs.Quick:Section({ Title = "快捷提问", Opened = true })

local function QuickAsk(question)
    if not question then return end
    AskAI(question)
end

QuickGroup:Paragraph({
    Title = "点击下方快速提问",
    Desc = "AI会直接回答对应的问题"
})

QuickGroup:Divider()

QuickGroup:Button({
    Title = "这个脚本有什么功能？",
    Callback = function() QuickAsk("这个wdfex脚本有什么功能？请详细介绍一下所有功能。") end
})

QuickGroup:Button({
    Title = "杀戮光环怎么用？",
    Callback = function() QuickAsk("杀戮光环功能怎么使用？需要装备什么武器？怎么设置攻击距离和伤害倍率？") end
})

QuickGroup:Button({
    Title = "透视怎么开？",
    Callback = function() QuickAsk("透视功能怎么开启？可以看到哪些信息？怎么设置显示内容？") end
})

QuickGroup:Button({
    Title = "飞行模式怎么用？",
    Callback = function() QuickAsk("飞行模式怎么使用？怎么控制方向？怎么调整飞行速度？") end
})

QuickGroup:Button({
    Title = "传送点怎么用？",
    Callback = function() QuickAsk("传送功能怎么使用？需要先开启什么开关？有哪些传送点？") end
})

QuickGroup:Button({
    Title = "自动躲警察怎么用？",
    Callback = function() QuickAsk("自动躲警察功能怎么使用？触发距离和弹开力度怎么调？") end
})

QuickGroup:Button({
    Title = "如何授权设备？",
    Callback = function() QuickAsk("设备授权系统怎么用？什么是设备UID？作者怎么授权其他设备？") end
})

-- ============================================================
-- Tab: 设置
-- ============================================================
local SettingsGroup = Tabs.Settings:Section({ Title = "设置", Opened = true })

SettingsGroup:Paragraph({
    Title = "关于AI助手",
    Desc = "版本：v1.0\n使用免费GPT-3.5 API\n有调用次数限制，请合理使用"
})

SettingsGroup:Divider()

SettingsGroup:Button({
    Title = "关闭AI助手",
    Callback = function()
        Window:Destroy()
    end
})

WindUI:Notify({
    Title = "AI助手",
    Content = "已启动！输入问题即可获取AI回答",
    Duration = 3,
})