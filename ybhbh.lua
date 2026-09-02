-- ==================== AI聊天助手（独立AI回答区域） ====================
-- 直接复制执行即可

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()
local HttpService = game:GetService("HttpService")

if not WindUI then return end

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
local ChatGroup = Tabs.Chat:Section({ Title = "AI聊天", Opened = true })

-- AI回答内容（单独存储）
local aiResponse = "等待你提问..."
local userQuestion = ""

-- 显示当前AI回答
local responseLabel = ChatGroup:Paragraph({
    Title = "🤖 AI 回答",
    Desc = aiResponse
})

-- 显示我的问题
local questionLabel = ChatGroup:Paragraph({
    Title = "💬 我的问题",
    Desc = "还没有提问..."
})

ChatGroup:Divider()

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

-- 发送按钮
ChatGroup:Button({
    Title = "🚀 发送",
    Callback = function()
        if inputBox and inputBox ~= "" then
            local q = inputBox
            inputBox = ""
            
            -- 更新我的问题显示
            pcall(function()
                questionLabel:SetDesc(q)
            end)
            
            -- 显示AI思考中
            pcall(function()
                responseLabel:SetDesc("⏳ AI正在思考，请稍候...")
            end)
            
            -- 请求AI
            task.spawn(function()
                local success, response = pcall(function()
                    local data = {
                        messages = {
                            { role = "system", content = "你是一个有用的AI助手，简洁准确地回答问题。" },
                            { role = "user", content = q }
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
                
                if success and response then
                    pcall(function()
                        responseLabel:SetDesc(response)
                    end)
                else
                    pcall(function()
                        responseLabel:SetDesc("❌ 请求失败，请检查网络。")
                    end)
                end
            end)
        else
            WindUI:Notify({ Title = "提示", Content = "请输入问题", Duration = 2 })
        end
    end
})

ChatGroup:Divider()

-- 清空按钮
ChatGroup:Button({
    Title = "清空对话",
    Callback = function()
        pcall(function()
            questionLabel:SetDesc("还没有提问...")
            responseLabel:SetDesc("等待你提问...")
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
    
    pcall(function()
        questionLabel:SetDesc(question)
        responseLabel:SetDesc("⏳ AI正在思考，请稍候...")
    end)
    
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
        
        if success and response then
            pcall(function() responseLabel:SetDesc(response) end)
        else
            pcall(function() responseLabel:SetDesc("❌ 请求失败，请检查网络。") end)
        end
    end)
end

QuickGroup:Paragraph({
    Title = "点击下方快速提问",
    Desc = "AI会直接回答对应的问题"
})

QuickGroup:Divider()

QuickGroup:Button({
    Title = "这个脚本有什么功能？",
    Callback = function()
        QuickAsk("这个wdfex脚本有什么功能？请详细介绍一下所有功能。")
    end
})

QuickGroup:Button({
    Title = "杀戮光环怎么用？",
    Callback = function()
        QuickAsk("杀戮光环功能怎么使用？需要装备什么武器？怎么设置攻击距离和伤害倍率？")
    end
})

QuickGroup:Button({
    Title = "透视怎么开？",
    Callback = function()
        QuickAsk("透视功能怎么开启？可以看到哪些信息？怎么设置显示内容？")
    end
})

QuickGroup:Button({
    Title = "飞行模式怎么用？",
    Callback = function()
        QuickAsk("飞行模式怎么使用？怎么控制方向？怎么调整飞行速度？")
    end
})

QuickGroup:Button({
    Title = "传送点怎么用？",
    Callback = function()
        QuickAsk("传送功能怎么使用？需要先开启什么开关？有哪些传送点？")
    end
})

QuickGroup:Button({
    Title = "自动躲警察怎么用？",
    Callback = function()
        QuickAsk("自动躲警察功能怎么使用？触发距离和弹开力度怎么调？")
    end
})

QuickGroup:Button({
    Title = "如何授权设备？",
    Callback = function()
        QuickAsk("设备授权系统怎么用？什么是设备UID？作者怎么授权其他设备？")
    end
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

-- ===== 启动通知 =====
WindUI:Notify({
    Title = "AI助手",
    Content = "已启动！输入问题即可获取AI回答",
    Duration = 3,
})