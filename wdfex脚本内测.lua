--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.9) ~  Much Love, Ferib 

]]

repeat
    task.wait();
until game:IsLoaded() 
local player = game.Players.LocalPlayer;
local bin = {dropdown={},playernamedied=""};

-- ========== 卡密验证系统 ==========
local isVerified = false
local validKeys = {
    ["1"] = true,
    ["wdfexnb"] = true,
    ["WDFEXNB"] = true,
    ["邀请码"] = true,
}

local function verifyKey(input)
    return validKeys[input] or false
end

-- ========== 创建验证GUI ==========
local function createVerifyUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game:GetService("CoreGui")
    screenGui.Name = "VerifyUI"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = screenGui
    mainFrame.Size = UDim2.new(0, 350, 0, 220)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -110)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true

    local mainCorner = Instance.new("UICorner")
    mainCorner.Parent = mainFrame
    mainCorner.CornerRadius = UDim.new(0, 16)

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Parent = mainFrame
    mainStroke.Thickness = 1.5
    mainStroke.Color = Color3.fromRGB(0, 200, 255)
    mainStroke.Transparency = 0.3

    local title = Instance.new("TextLabel")
    title.Parent = mainFrame
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 15)
    title.Text = "🔐 wdfex内测版脚本"
    title.TextColor3 = Color3.fromRGB(0, 200, 255)
    title.BackgroundTransparency = 1
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold

    local subTitle = Instance.new("TextLabel")
    subTitle.Parent = mainFrame
    subTitle.Size = UDim2.new(1, 0, 0, 25)
    subTitle.Position = UDim2.new(0, 0, 0, 65)
    subTitle.Text = "请输入开发者邀请码"
    subTitle.TextColor3 = Color3.fromRGB(180, 180, 210)
    subTitle.BackgroundTransparency = 1
    subTitle.TextSize = 15
    subTitle.Font = Enum.Font.Gotham

    local keyInput = Instance.new("TextBox")
    keyInput.Parent = mainFrame
    keyInput.Size = UDim2.new(0, 250, 0, 45)
    keyInput.Position = UDim2.new(0.5, -125, 0, 100)
    keyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyInput.Text = ""
    keyInput.PlaceholderText = "请输入开发者邀请码"
    keyInput.TextSize = 18
    keyInput.Font = Enum.Font.Gotham
    keyInput.BorderSizePixel = 0

    local inputCorner = Instance.new("UICorner")
    inputCorner.Parent = keyInput
    inputCorner.CornerRadius = UDim.new(0, 10)

    local verifyBtn = Instance.new("TextButton")
    verifyBtn.Parent = mainFrame
    verifyBtn.Size = UDim2.new(0, 250, 0, 45)
    verifyBtn.Position = UDim2.new(0.5, -125, 0, 160)
    verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    verifyBtn.Text = "✅ 验证邀请码"
    verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    verifyBtn.TextSize = 18
    verifyBtn.Font = Enum.Font.GothamBold
    verifyBtn.BorderSizePixel = 0

    local verifyCorner = Instance.new("UICorner")
    verifyCorner.Parent = verifyBtn
    verifyCorner.CornerRadius = UDim.new(0, 10)

    local resultLabel = Instance.new("TextLabel")
    resultLabel.Parent = mainFrame
    resultLabel.Size = UDim2.new(1, 0, 0, 25)
    resultLabel.Position = UDim2.new(0, 0, 0, 215)
    resultLabel.Text = "💡 邀请码: 1"
    resultLabel.TextColor3 = Color3.fromRGB(255, 200, 0