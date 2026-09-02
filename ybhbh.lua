-- ==================== 独立AI聊天助手（修复版） ====================
-- 复制这段代码单独执行即可

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

-- ===== 创建悬浮窗 =====
local Window = WindUI:CreateWindow({
    Title = 'AI聊天助手',
    Icon = "message-circle",
    IconThemed = true,
    Author = "wdfex",
    Folder = "AIChatHelper",
    Size = UDim2.fromOffset(480, 580),
    Transparent = true,
    Theme = "Dark",
    HideSearchBar = true,
    ScrollBarEnabled = true,
    Resizable = true,
    SideBarWidth = 0,
})

Window:Tag({
    Title = "AI助手",
    Color = Color3.fromRGB(100, 200, 255)
})

Window:EditOpenButton({
    Title = "AI助手",
    Icon = "message-circle",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 4,
    Color = ColorSequence.new(Color3.fromRGB(100, 200, 255)),
    Draggable = true,
})

-- ===== 创建Tab和Section =====
local MainTab = Window:Tab({ Title = "聊天", Icon = "message-circle" })
local ChatGroup = MainTab:Section({ Title = "AI聊天助手", Opened = true })

-- 聊天记录变量
local messages = {}
local chatDesc = "等待你开始对话..."

-- 添加消息函数
local function AddMessage(sender, content)
    local prefix = sender == "我" and "你" or "AI"
    local color = sender == "我" and "rgb(100, 200, 255)" or "rgb(100, 255, 150)"
    local msg = '<font color="' .. color .. '"><b>' .. prefix .. ':</b></font> ' .. content
    table.insert(messages, msg)
    if #messages > 20 then
        table.remove(messages, 1)
    end
    local displayText = ""
    for _, m in ipairs(messages) do
        displayText = displayText .. m .. "\n\n"
    end
    chatDesc = displayText or "等待你开始对话..."
    -- 更新显示
    pcall(function()
        if chatLabel then
            chatLabel:SetDesc(chatDesc)
        end
    end)
end

-- 创建聊天显示区域
local chatLabel = ChatGroup:Paragraph({
    Title = "对话记录",
    Desc = chatDesc
})

-- AI请求函数
local function AskAI(question)
    if question == "" then return end
    
    AddMessage("我", question)
    AddMessage("AI", "思考中...")
    
    task.spawn(function()
        local success, response = pcall(function()
            local data = {
                messages = {
                    { role = "system", content = "你是一个有用的AI助手，可以回答任何问题。" },
                    { role = "user", content = question }
                },
                model = "gpt-3.5-turbo",
                temperature = 0.7,
                max_tokens = 500
            }
            
            local headers = {
                ["Content-Type"] = "application/json"
            }
            
            local url = "https://api.itsapi.xyz/v1/chat/completions"
            
            local response = HttpService:PostAsync(url, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson, false, headers)
            local result = HttpService:JSONDecode(response)
            
            if result and result.choices and result.choices[1] and result.choices[1].message then
                return result.choices[1].message.content
            else
                return "抱歉，我暂时无法回答，请稍后再试。"
            end
        end)
        
        -- 移除"思考中..."
        for i = #messages, 1, -1 do
            if string.find(messages[i], "思考中...") then
                table.remove(messages, i)
                break
            end
        end
        
        if success and response then
            AddMessage("AI", response)
        else
            AddMessage("AI", "请求失败，请检查网络或稍后再试。")
        end
    end)
end

-- 输入框
local questionInput = ""
ChatGroup:Input({
    Title = "输入问题",
    Placeholder = "输入你想问的问题...",
    Callback = function(value)
        questionInput = value
    end
})

ChatGroup:Divider()

ChatGroup:Button({
    Title = "发送",
    Callback = function()
        if questionInput and questionInput ~= "" then
            local q = questionInput
            questionInput = ""
            AskAI(q)
        else
            WindUI:Notify({ Title = "提示", Content = "请输入问题", Duration = 2 })
        end
    end
})

-- 快捷问题
ChatGroup:Divider()
ChatGroup:Paragraph({
    Title = "快捷提问",
    Desc = "点击下方按钮快速提问"
})

ChatGroup:Button({
    Title = "这个脚本有什么功能？",
    Callback = function()
        AskAI("这个wdfex脚本有什么功能？请详细介绍一下。")
    end
})

ChatGroup:Button({
    Title = "杀戮光环怎么用？",
    Callback = function()
        AskAI("杀戮光环功能怎么使用？需要装备什么武器？")
    end
})

ChatGroup:Button({
    Title = "透视怎么开？",
    Callback = function()
        AskAI("透视功能怎么开启？可以看到哪些信息？")
    end
})

ChatGroup:Button({
    Title = "飞行模式怎么用？",
    Callback = function()
        AskAI("飞行模式怎么使用？怎么控制方向？")
    end
})

ChatGroup:Divider()
ChatGroup:Button({
    Title = "清空对话记录",
    Callback = function()
        messages = {}
        chatDesc = "对话已清空"
        pcall(function()
            chatLabel:SetDesc(chatDesc)
        end)
        WindUI:Notify({ Title = "提示", Content = "对话记录已清空", Duration = 2 })
    end
})

-- 设置Tab
local SettingsTab = Window:Tab({ Title = "设置", Icon = "settings" })
local SettingsGroup = SettingsTab:Section({ Title = "设置", Opened = true })

SettingsGroup:Button({
    Title = "关闭AI助手",
    Callback = function()
        Window:Destroy()
    end
})

WindUI:Notify({
    Title = "AI助手",
    Content = "已启动，输入问题即可开始聊天",
    Duration = 3,
})