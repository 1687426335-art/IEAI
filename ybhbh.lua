-- =======================================================
-- 悬浮窗代码/文字存储器 (支持电脑/手机)
-- 需要执行器支持 writefile 和 readfile 才能永久保存
-- =======================================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- 保存数据的文件名
local SAVE_FILE = "MyScriptStorage.json"
local StorageData = {} -- 内存中的存储列表

-- ==================== 数据读取（尝试从文件加载） ====================
local canUseFile = pcall(function()
    if readfile and writefile then
        if isfile(SAVE_FILE) then
            local content = readfile(SAVE_FILE)
            if content and content ~= "" then
                StorageData = HttpService:JSONDecode(content)
            end
        end
        return true
    end
    return false
end)

if not canUseFile then
    LocalPlayer:WaitForChild("PlayerGui"):SetCore("SendNotification", {
        Title = "注意",
        Text = "你的执行器不支持文件读写，本次保存只在当前游戏生效，关游戏就没了！",
        Duration = 5
    })
end

-- ==================== UI 构建 ====================
local oldGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("StorageGui")
if oldGui then oldGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StorageGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- 主界面 (深色主题)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 400)
mainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 2
mainStroke.Color = Color3.fromRGB(0, 150, 255)
mainStroke.Parent = mainFrame

-- 标题栏 (拖拽区)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "📋 我的代码/文字存储器"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 14
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- 最小化按钮
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -30, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 20
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 5)
minCorner.Parent = minimizeBtn

-- 输入区
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, -20, 0, 100)
inputBox.Position = UDim2.new(0, 10, 0, 45)
inputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.PlaceholderText = "在这里粘贴你的长代码或短文字...\n(手机端点击即可输入)"
inputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
inputBox.TextSize = 12
inputBox.Font = Enum.Font.Code
inputBox.TextWrapped = true
inputBox.TextXAlignment = Enum.TextXAlignment.Left
inputBox.TextYAlignment = Enum.TextYAlignment.Top
inputBox.ClearTextOnFocus = false
inputBox.MultiLine = true
inputBox.Parent = mainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = inputBox

-- 保存按钮
local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(1, -20, 0, 30)
saveBtn.Position = UDim2.new(0, 10, 0, 155)
saveBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
saveBtn.Text = "💾 保存当前内容"
saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 14
saveBtn.Parent = mainFrame

local saveCorner = Instance.new("UICorner")
saveCorner.CornerRadius = UDim.new(0, 6)
saveCorner.Parent = saveBtn

-- 列表区 (滚动框)
local listFrame = Instance.new("ScrollingFrame")
listFrame.Size = UDim2.new(1, -20, 1, -200)
listFrame.Position = UDim2.new(0, 10, 0, 195)
listFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
listFrame.BorderSizePixel = 0
listFrame.ScrollBarThickness = 4
listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
listFrame.Parent = mainFrame

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 6)
listCorner.Parent = listFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = listFrame

-- ==================== 拖拽逻辑 (手机/电脑通用) ====================
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
titleBar.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- 最小化/展开
local isMinimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        mainFrame.Size = UDim2.new(0, 320, 0, 35)
        minimizeBtn.Text = "+"
        inputBox.Visible = false
        saveBtn.Visible = false
        listFrame.Visible = false
    else
        mainFrame.Size = UDim2.new(0, 320, 0, 400)
        minimizeBtn.Text = "-"
        inputBox.Visible = true
        saveBtn.Visible = true
        listFrame.Visible = true
    end
end)

-- ==================== 提示框功能 ====================
local function showToast(text)
    local toast = Instance.new("TextLabel")
    toast.Size = UDim2.new(0, 200, 0, 30)
    toast.Position = UDim2.new(0.5, -100, 0.1, 0)
    toast.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    toast.TextColor3 = Color3.fromRGB(255, 255, 255)
    toast.Text = text
    toast.Font = Enum.Font.GothamBold
    toast.TextSize = 14
    toast.Parent = screenGui
    
    local toastCorner = Instance.new("UICorner")
    toastCorner.CornerRadius = UDim.new(0, 6)
    toastCorner.Parent = toast
    
    task.wait(1.5)
    toast:Destroy()
end

-- ==================== 核心逻辑 ====================
local function SaveToFile()
    if canUseFile then
        pcall(function()
            writefile(SAVE_FILE, HttpService:JSONEncode(StorageData))
        end)
    end
end

local function RefreshList()
    -- 清空列表项
    for _, child in ipairs(listFrame:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("Frame") then
            child:Destroy()
        end
    end

    -- 重新生成
    for index, item in ipairs(StorageData) do
        local itemFrame = Instance.new("Frame")
        itemFrame.Size = UDim2.new(1, -10, 0, 40)
        itemFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        itemFrame.BorderSizePixel = 0
        itemFrame.Parent = listFrame

        local itemCorner = Instance.new("UICorner")
        itemCorner.CornerRadius = UDim.new(0, 5)
        itemCorner.Parent = itemFrame

        -- 标题/预览 (点击复制)
        local copyBtn = Instance.new("TextButton")
        copyBtn.Size = UDim2.new(1, -40, 1, 0)
        copyBtn.BackgroundTransparency = 1
        copyBtn.Text = " " .. (item.title or "未命名") .. " (点击复制)"
        copyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        copyBtn.Font = Enum.Font.Gotham
        copyBtn.TextSize = 12
        copyBtn.TextXAlignment = Enum.TextXAlignment.Left
        copyBtn.TextTruncate = Enum.TextTruncate.AtEnd
        copyBtn.Parent = itemFrame

        -- 删除按钮
        local delBtn = Instance.new("TextButton")
        delBtn.Size = UDim2.new(0, 30, 0, 30)
        delBtn.Position = UDim2.new(1, -35, 0.5, -15)
        delBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        delBtn.Text = "X"
        delBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 12
        delBtn.Parent = itemFrame

        local delCorner = Instance.new("UICorner")
        delCorner.CornerRadius = UDim.new(0, 4)
        delCorner.Parent = delBtn

        -- 复制事件
        copyBtn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard(item.content)
                showToast("复制成功！")
            else
                showToast("执行器不支持复制！")
            end
        end)

        -- 删除事件
        delBtn.MouseButton1Click:Connect(function()
            table.remove(StorageData, index)
            SaveToFile()
            RefreshList()
        end)
    end

    -- 调整滚动区域大小
    local totalHeight = #StorageData * 45
    listFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 10)
end

-- 保存事件
saveBtn.MouseButton1Click:Connect(function()
    local content = inputBox.Text
    if content == "" then
        showToast("内容不能为空！")
        return
    end
    
    -- 取前15个字符作为标题
    local title = string.sub(content, 1, 15)
    if #content > 15 then title = title .. "..." end
    
    table.insert(StorageData, { title = title, content = content })
    SaveToFile()
    RefreshList()
    
    inputBox.Text = ""
    showToast("保存成功！")
end)

-- 初始化列表
RefreshList()
showToast("存储器加载成功！")