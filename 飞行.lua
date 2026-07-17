-- ========== 通用飞行脚本 ==========
-- 所有服务器通用，点按钮切换飞行

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local flying = false
local bodyVelocity = nil
local flightSpeed = 50

-- 创建屏幕按钮
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = CoreGui
screenGui.Name = "FlightGui"

local button = Instance.new("TextButton")
button.Parent = screenGui
button.Size = UDim2.new(0, 120, 0, 50)
button.Position = UDim2.new(0.5, -60, 0.8, 0)
button.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
button.Text = "✈️ 飞行"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 18
button.Font = Enum.Font.GothamBold
button.BackgroundTransparency = 0.2
button.BorderSizePixel = 0

-- 圆角效果
local corner = Instance.new("UICorner")
corner.Parent = button
corner.CornerRadius = UDim.new(0, 10)

-- 飞行核心函数
local function toggleFly()
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoidRootPart or not humanoid then return end
    
    flying = not flying
    
    if flying then
        -- 开启飞行
        humanoid.PlatformStand = true
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bodyVelocity.Velocity = Vector3.new(0, flightSpeed, 0)
        bodyVelocity.Parent = humanoidRootPart
        
        button.Text = "🛑 停止飞行"
        button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        
        -- 用 WASD 控制方向
        local moveConnection
        moveConnection = RunService.Heartbeat:Connect(function()
            if not flying or not humanoidRootPart or not bodyVelocity then
                if moveConnection then moveConnection:Disconnect() end
                return
            end
            
            local moveDir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + humanoidRootPart.CFrame.LookVector * flightSpeed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - humanoidRootPart.CFrame.LookVector * flightSpeed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - humanoidRootPart.CFrame.RightVector * flightSpeed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + humanoidRootPart.CFrame.RightVector * flightSpeed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = Vector3.new(0, flightSpeed * 2, 0)
            end
            
            if moveDir.Magnitude > 0 then
                bodyVelocity.Velocity = moveDir
            else
                bodyVelocity.Velocity = Vector3.new(0, flightSpeed * 0.5, 0)
            end
        end)
        
    else
        -- 关闭飞行
        humanoid.PlatformStand = false
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        
        button.Text = "✈️ 飞行"
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    end
end

button.MouseButton1Click:Connect(toggleFly)

-- 快捷键 F 键切换飞行
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        toggleFly()
    end
end)

print("✅ 飞行脚本加载成功！")
print("点击屏幕按钮 或 按 F 键 切换飞行")
print("WASD 控制方向，空格向上")