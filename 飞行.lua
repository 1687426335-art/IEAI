-- ========== 通用飞行脚本 V2 ==========
-- 适用所有游戏，点按钮或按F键飞行
-- 支持 WASD + 空格 控制方向

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local flying = false
local bodyVelocity = nil
local flightSpeed = 50

-- 创建UI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = CoreGui
screenGui.Name = "FlightGui"
screenGui.ResetOnSpawn = false

local button = Instance.new("TextButton")
button.Parent = screenGui
button.Size = UDim2.new(0, 140, 0, 55)
button.Position = UDim2.new(0.5, -70, 0.85, 0)
button.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
button.Text = "✈️ 飞行"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 20
button.Font = Enum.Font.GothamBold
button.BackgroundTransparency = 0.15
button.BorderSizePixel = 0

local corner = Instance.new("UICorner")
corner.Parent = button
corner.CornerRadius = UDim.new(0, 12)

local shadow = Instance.new("UIStroke")
shadow.Parent = button
shadow.Thickness = 2
shadow.Color = Color3.fromRGB(255, 255, 255)
shadow.Transparency = 0.5

-- 飞行功能
local function toggleFly()
    local character = LocalPlayer.Character
    if not character then
        print("❌ 没有角色")
        return
    end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local hum = character:FindFirstChild("Humanoid")
    if not hrp or not hum then
        print("❌ 找不到 Humanoid")
        return
    end
    
    flying = not flying
    
    if flying then
        hum.PlatformStand = true
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bodyVelocity.Velocity = Vector3.new(0, flightSpeed, 0)
        bodyVelocity.Parent = hrp
        
        button.Text = "🛑 降落"
        button.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        
        print("✅ 飞行开启")
        
        -- 方向控制
        RunService.Heartbeat:Connect(function()
            if not flying or not hrp or not bodyVelocity then return end
            
            local move = Vector3.new(0, 0, 0)
            local speed = flightSpeed
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                move = move + hrp.CFrame.LookVector * speed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                move = move - hrp.CFrame.LookVector * speed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                move = move - hrp.CFrame.RightVector * speed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                move = move + hrp.CFrame.RightVector * speed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                move = Vector3.new(0, speed * 2, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                move = Vector3.new(0, -speed, 0)
            end
            
            if move.Magnitude > 0 then
                bodyVelocity.Velocity = move
            else
                bodyVelocity.Velocity = Vector3.new(0, speed * 0.3, 0)
            end
        end)
        
    else
        hum.PlatformStand = false
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        
        button.Text = "✈️ 飞行"
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        print("✅ 飞行关闭")
    end
end

button.MouseButton1Click:Connect(toggleFly)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F then
        toggleFly()
    end
end)

print("========================================")
print("  ✅ 飞行脚本 V2 加载成功！")
print("  点击屏幕按钮 或 按 F 键 切换飞行")
print("  WASD = 前后左右  空格 = 上升")
print("  Shift = 下降")
print("========================================")