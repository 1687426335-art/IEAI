-- ==================== AI聊天助手（免费API版） ====================
-- 使用免费API，无需付费，开箱即用
-- 内置多个备用API，自动切换

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()
local HttpService = game:GetService("HttpService")

if not WindUI then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "错误",
        Text = "UI库加载失败，请检查网络",
        Duration = 5,
    })
    return
end

-- ===== 免费API列表（自动切换） =====
local API_LIST = {
    {
        url = "https://api.chatanywhere.tech/v1/chat/completions",
        key = "sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",  -- 去https://github.com/chatanywhere/GPT_API_free 领取
        name = "ChatAnywhere"
    },
    {
        url = "https://openai.good.hidns.vip/v1/chat/completions",
        key = "sk-7YwvRqVTUJ4cYYW9B2E4A474E5A14c3fBc6bA7EaDfFgH9i",  -- 内置Key
        name = "smanx免费API"
    },
    {
        url = "https://gpt.qt.cool/v1/chat/completions",
        key = "sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",  -- 去https://gpt.qt.cool 注册领取
        name = "晴辰AI"
    },
    {
        url = "https://free.v36.cm/v1/chat/completions",
        key = "sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",  -- 去https://free.v36.cm/github 领取
        name = "popjane免费API"
    },
}

-- ===== 创建设置 =====
local Window = WindUI:CreateWindow({
    Title = 'AI聊天助手',
    Icon = "message-circle",
    IconThemed = true,
    Author = "wdfex",
    Folder = "AIChatHelper",
    Size = UDim2.fromOffset(500, 650),
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
local ChatGroup = Tabs.Chat:Section({ Title = "AI聊天", Opened = true })

local messages = {}
local chatHistory = {}
local chatDisplay = nil
local currentApiIndex = 1
local isWaiting = false

local function AddMessage(sender, content)
    local isAI = sender == "AI"
    local prefix = isAI and "AI" or "我"
    local color = isAI and "rgb(100, 255, 150)" or "rgb(100, 200, 255)"
    
    local msg = '<font color="' .. color .. '"><b>' .. prefix .. '</b></font>\n'
    msg = msg .. '<font color="rgb(220, 220, 220)">' .. content .. '</font>'
    local bubble = '━━━━━━━━━━━━━━━━━━━━━━━━\n' .. msg .. '\n━━━━━━━━━━━━━━━━━━━━━━━━'
    
    table.insert(messages, bubble)
    if #messages > 30 then table.remove(messages, 1) end
    
    local displayText = ""
    for _, m in ipairs(messages) do
        displayText = displayText .. m .. "\n\n"
    end
    
    pcall(function()
        if chatDisplay then
            chatDisplay:SetDesc(displayText)
        end
    end)
end

chatDisplay = ChatGroup:Paragraph({
    Title = "对话记录",
    Desc = "━━━━━━━━━━━━━━━━━━━━━━━━\nAI助手已就绪（免费API版）\n━━━━━━━━━━━━━━━━━━━━━━━━"
})

-- ===== AI请求（自动切换备用API） =====
local function AskAI(question)
    if not question or question == "" then return end
    if isWaiting then
        WindUI:Notify({ Title = "提示", Content = "请等待上一条回复完成", Duration = 2 })
        return
    end
    
    AddMessage("我", question)
    table.insert(chatHistory, { role = "user", content = question })
    if #chatHistory > 20 then table.remove(chatHistory, 1) end
    
    AddMessage("AI", "思考中...")
    isWaiting = true
    
    task.spawn(function()
        local success = false
        local response = ""
        local usedApi = 1
        
        for i = 1, #API_LIST do
            local api = API_LIST[i]
            if api.key and api.key ~= "" then
                local ok, result = pcall(function()
                    local data = {
                        messages = chatHistory,
                        model = "gpt-3.5-turbo",
                        temperature = 0.7,
                        max_tokens = 500
                    }
                    local headers = {
                        ["Content-Type"] = "application/json",
                        ["Authorization"] = "Bearer " .. api.key
                    }
                    local res = HttpService:PostAsync(api.url, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson, false, headers)
                    return HttpService:JSONDecode(res)
                end)
                
                if ok and result and result.choices and result.choices[1] and result.choices[1].message then
                    success = true
                    response = result.choices[1].message.content
                    usedApi = i
                    table.insert(chatHistory, { role = "assistant", content = response })
                    break
                end
            end
        end
        
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
            AddMessage("AI", "所有免费API都不可用，请稍后再试。")
        end
        isWaiting = false
    end)
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
        chatHistory = {}
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
    Callback = function() QuickAsk("这个wdfex脚本有什么功能？请详细介绍一下。") end
})

QuickGroup:Button({
    Title = "杀戮光环怎么用？",
    Callback = function() QuickAsk("杀戮光环功能怎么使用？需要装备什么武器？") end
})

QuickGroup:Button({
    Title = "透视怎么开？",
    Callback = function() QuickAsk("透视功能怎么开启？可以看到哪些信息？") end
})

QuickGroup:Button({
    Title = "飞行模式怎么用？",
    Callback = function() QuickAsk("飞行模式怎么使用？怎么控制方向？") end
})

QuickGroup:Button({
    Title = "传送点怎么用？",
    Callback = function() QuickAsk("传送功能怎么使用？需要先开启什么开关？") end
})

QuickGroup:Button({
    Title = "自动躲警察怎么用？",
    Callback = function() QuickAsk("自动躲警察功能怎么使用？") end
})

QuickGroup:Button({
    Title = "怎么授权设备？",
    Callback = function() QuickAsk("设备授权系统怎么用？什么是设备UID？") end
})

QuickGroup:Button({
    Title = "你好！",
    Callback = function() QuickAsk("你好，很高兴认识你") end
})

-- ============================================================
-- Tab: 设置
-- ============================================================
local SettingsGroup = Tabs.Settings:Section({ Title = "设置", Opened = true })

SettingsGroup:Paragraph({
    Title = "关于AI助手",
    Desc = "版本：v2.0（免费API版）\n内置多个免费API，自动切换\n支持上下文记忆，可回答任何问题\n需要联网使用\n\n免费API来源：\n• ChatAnywhere\n• smanx/free-api\n• 晴辰AI\n• popjane/free_chatgpt_api"
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
    Content = "已启动！免费API版，可回答任何问题",
    Duration = 3,
})