-- 圣奥里出租车 手动瞄准传送版
-- 把视角对准目标，自动传送过去

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 120)
Frame.Position = UDim2.new(0.5, -100, 0.8, 0)
Frame.BackgroundColor3 = Color3.fromRGB(10,10,25)
Frame.BackgroundTransparency = 0.2
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = Frame

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(1,0,1,0)
Label.BackgroundTransparency = 1
Label.Text = "按 E 传送到视野中心"
Label.TextColor3 = Color3.fromRGB(255,255,255)
Label.TextSize = 16
Label.TextXAlignment = Enum.TextXAlignment.Center
Label.Font = Enum.Font.GothamBold
Label.Parent = Frame

-- 视野中心射线检测
local function GetTargetInView()
    local rayOrigin = Camera.CFrame.Position
    local rayDirection = Camera.CFrame.LookVector * 1000
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {Character}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local result = workspace:Raycast(rayOrigin, rayDirection, rayParams)
    if result then
        return result.Position
    end
    return nil
end

UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.E then
        local pos = GetTargetInView()
        if pos then
            HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0,3,0))
            Label.Text = "✅ 传送成功!"
            task.wait(0.8)
            Label.Text = "按 E 传送到视野中心"
        else
            Label.Text = "❌ 未找到目标"
            task.wait(0.8)
            Label.Text = "按 E 传送到视野中心"
        end
    end
end)