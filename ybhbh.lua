-- ==================== 独立AI聊天助手 ====================
-- 复制这段代码单独执行即可，不需要主脚本

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()
local HttpService = game:GetService("HttpService")

-- ===== 创建悬浮窗 =====
local Window = WindUI:CreateWindow({
    Title = 'AI 聊天助手',
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

-- ===== 主界面 =====
local MainTab = Window:Tab({ Title = "聊天", Icon = "message-circle" })
local ChatGroup = MainTab:Section({ Title = "AI 聊天助手", Opened = true })

-- 聊天显示区域（用Paragraph模拟聊天记录）
local chatHistory = ""
local chatDisplay = nil

-- 创建聊天显示区域
ChatGroup:Paragraph({
    Title = "对话记录",
    Desc = "等待你开始对话..."
})

-- 存储聊天消息的列表
local messages = {}

-- 添加消息到显示
local function AddMessage(sender, content)
    local time = os.date("%H:%M")
    local prefix = sender == "我" and "你" or "AI"
    local color = sender == "我" and "rgb(100, 200, 255)" or "rgb(100, 255, 150)"
    local msg = '<font color="' .. color .. '"><b>' .. prefix .. '</b></font> <font color="rgb(200,200,200)">' .. content .. '</font>'
    table.insert(messages, msg)
    if #messages > 20 then
        table.remove(messages, 1)
    end
    local displayText = ""
    for _, m in ipairs(messages) do
        displayText = displayText .. m .. "\n\n"
    end
    chatDisplay:SetDesc(displayText or "等待你开始对话...")
end

-- AI回复函数
local function AskAI(question)
    if question == "" then return end
    
    -- 显示用户消息
    AddMessage("我", question)
    
    -- 显示AI正在思考
    chatDisplay:SetDesc(chatDisplay.Desc .. "\n\nAI正在思考...")
    
    task.spawn(function()
        local success, response = pcall(function()
            local data = {
                messages = {
                    { role = "system", content = "你是一个有用的AI助手，可以回答任何问题，帮助用户了解脚本功能。" },
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
        
        if success and response then
            -- 移除"AI正在思考..."
            local currentDesc = chatDisplay.Desc
            local index = string.find(currentDesc, "AI正在思考...")
            if index then
                currentDesc = string.sub(currentDesc, 1, index - 1)
                chatDisplay:SetDesc(currentDesc)
            end
            AddMessage("AI", response)
        else
            AddMessage("AI", "请求失败，请检查网络或稍后再试。")
        end
    end)
end

-- 输入框
local questionInput = nil
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
            AskAI(questionInput)
            questionInput = ""
        else
            WindUI:Notify({ Title = "提示", Content = "请输入问题", Duration = 2 })
        end
    end
})

-- 重新获取chatDisplay
local function UpdateChatDisplay()
    for _, child in ipairs(ChatGroup:GetChildren()) do
        if child:IsA("Paragraph") and child.Title == "对话记录" then
            chatDisplay = child
            break
        end
    end
end

task.wait(0.5)
UpdateChatDisplay()
if not chatDisplay then
    ChatGroup:Paragraph({
        Title = "对话记录",
        Desc = "等待你开始对话..."
    })
    task.wait(0.1)
    UpdateChatDisplay()
end

-- ===== 快捷问题按钮 =====
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
    Title = "怎么快速传送？",
    Callback = function()
        AskAI("传送功能怎么使用？需要先开启什么开关？")
    end
})

ChatGroup:Button({
    Title = "飞行模式怎么用？",
    Callback = function()
        AskAI("飞行模式怎么使用？怎么控制方向？")
    end
})

-- ===== 清空对话 =====
ChatGroup:Divider()
ChatGroup:Button({
    Title = "清空对话记录",
    Callback = function()
        messages = {}
        chatDisplay:SetDesc("对话已清空")
        WindUI:Notify({ Title = "提示", Content = "对话记录已清空", Duration = 2 })
    end
})

-- ===== 设置Tab =====
local SettingsTab = Window:Tab({ Title = "设置", Icon = "settings" })
local SettingsGroup = SettingsTab:Section({ Title = "设置", Opened = true })

SettingsGroup:Button({
    Title = "关闭AI助手",
    Callback = function()
        Window:Destroy()
        WindUI:Notify({ Title = "AI助手", Content = "已关闭", Duration = 2 })
    end
})

WindUI:Notify({
    Title = "AI助手",
    Content = "已启动，输入问题即可开始聊天",
    Duration = 3,
})

-- 悬浮窗按钮可以拖动
Window:EditOpenButton({
    Title = "AI助手",
    Icon = "message-circle",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 4,
    Color = ColorSequence.new(Color3.fromRGB(100, 200, 255)),
    Draggable = true,
})