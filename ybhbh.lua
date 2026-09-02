-- ==================== AI聊天助手（wdfex风格） ====================
-- 独立执行，UI风格与主脚本统一

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

-- ===== 颜色定义（跟主脚本一致） =====
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
    Size = UDim2.fromOffset(480, 580),
    Transparent = true,
    Theme = "Dark",
    HideSearchBar = false,
    ScrollBarEnabled = true,
    Resizable = true,
    SideBarWidth = 180,
})

-- 标签（类似主脚本的圣奥里）
Window:Tag({
    Title = "AI助手",
    Color = Color3.fromRGB(100, 200, 255)
})

-- 彩虹边框按钮（跟主脚本一样）
Window:EditOpenButton({
    Title = "AI助手",
    Icon = "message-circle",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 4,
    Color = ColorSequence.new(Color3.fromRGB(100, 200, 255)),
    Draggable = true,
})

-- 彩虹循环
spawn(function()
    while true do
        for hue = 0, 1, 0.01 do
            local color = Color3.fromHSV(hue, 0.8, 1)
            Window:EditOpenButton({
                Color = ColorSequence.new(color)
            })
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

-- 聊天记录
local messages = {}
local chatDesc = "欢迎使用AI助手，输入问题开始聊天吧！"

-- 添加消息
local function AddMessage(sender, content)
    local prefix = sender == "我" and "你" or "AI"
    local color = sender == "我" and "rgb(100, 200, 255)" or "rgb(100, 255, 150)"
    local msg = '<font color="' .. color .. '"><b>' .. prefix .. ':</b></font> ' .. content
    table.insert(messages, msg)
    if #messages > 30 then
        table.remove(messages, 1)
    end
    local displayText = ""
    for _, m in ipairs(messages) do
        displayText = displayText .. m .. "\n\n"
    end
    chatDesc = displayText or "等待你开始对话..."
    pcall(function()
        if chatLabel then
            chatLabel:SetDesc(chatDesc)
        end
    end)
end

-- 对话显示区域
local chatLabel = ChatGroup:Paragraph({
    Title = "对话记录",
    Desc = chatDesc
})

-- AI请求
local function AskAI(question)
    if question == "" or not question then return end
    
    AddMessage("我", question)
    AddMessage("AI", "思考中...")
    
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

-- ============================================================
-- Tab: 快捷提问
-- ============================================================
local QuickGroup = Tabs.Quick:Section({ Title = "快捷提问", Opened = true })

QuickGroup:Paragraph({
    Title = "点击下方按钮快速提问",
    Desc = "AI会回答对应的问题"
})

QuickGroup:Divider()

QuickGroup:Button({
    Title = "这个脚本有什么功能？",
    Callback = function()
        AskAI("这个wdfex脚本有什么功能？请详细介绍一下所有功能。")
    end
})

QuickGroup:Button({
    Title = "杀戮光环怎么用？",
    Callback = function()
        AskAI("杀戮光环功能怎么使用？需要装备什么武器？怎么设置攻击距离和伤害倍率？")
    end
})

QuickGroup:Button({
    Title = "透视怎么开？",
    Callback = function()
        AskAI("透视功能怎么开启？可以看到哪些信息？怎么设置显示内容？")
    end
})

QuickGroup:Button({
    Title = "飞行模式怎么用？",
    Callback = function()
        AskAI("飞行模式怎么使用？怎么控制方向？怎么调整飞行速度？")
    end
})

QuickGroup:Button({
    Title = "传送点怎么用？",
    Callback = function()
        AskAI("传送功能怎么使用？需要先开启什么开关？有哪些传送点？")
    end
})

QuickGroup:Button({
    Title = "自动躲警察怎么用？",
    Callback = function()
        AskAI("自动躲警察功能怎么使用？触发距离和弹开力度怎么调？")
    end
})

QuickGroup:Button({
    Title = "如何授权设备？",
    Callback = function()
        AskAI("设备授权系统怎么用？什么是设备UID？作者怎么授权其他设备？")
    end
})

-- ============================================================
-- Tab: 设置
-- ============================================================
local SettingsGroup = Tabs.Settings:Section({ Title = "设置", Opened = true })

SettingsGroup:Paragraph({
    Title = "关于AI助手",
    Desc = "版本：v1.0\n使用免费的GPT-3.5 API\n每天有调用次数限制，请合理使用"
})

SettingsGroup:Divider()

SettingsGroup:Button({
    Title = "关闭AI助手",
    Callback = function()
        Window:Destroy()
        WindUI:Notify({ Title = "AI助手", Content = "已关闭", Duration = 2 })
    end
})

-- ===== 启动通知 =====
WindUI:Notify({
    Title = "AI助手",
    Content = "已启动！输入问题即可开始聊天",
    Duration = 3,
})