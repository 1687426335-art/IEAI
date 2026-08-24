local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local gui = Instance.new("ScreenGui")
gui.Name = "CoordinateCopyTool"
gui.Parent = player:WaitForChild("PlayerGui")
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 100)
frame.Position = UDim2.new(0.5, -125, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Parent = gui
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.9, 0, 0, 30)
textBox.Position = UDim2.new(0.05, 0, 0.15, 0)
textBox.Text = "加载中..."
textBox.ClearTextOnFocus = false
textBox.TextEditable = false
textBox.Parent = frame
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0.9, 0, 0, 35)
copyBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
copyBtn.Text = "点击准备复制 (Ctrl+C)"
copyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
copyBtn.TextColor3 = Color3.new(1, 1, 1)
copyBtn.Parent = frame
local dragging = false
local dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)
frame.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
game:GetService("RunService").RenderStepped:Connect(function()
    local pos = root.Position
    local formattedPos = string.format("%.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z)
    if not textBox:IsFocused() then
        textBox.Text = formattedPos
    end
end)
copyBtn.MouseButton1Click:Connect(function()
    textBox:CaptureFocus()
    textBox.SelectionStart = 1
    textBox.CursorPosition = #textBox.Text + 1
    copyBtn.Text = "现在按下 Ctrl + C 复制！"
    wait(2)
    copyBtn.Text = "点击准备复制 (Ctrl+C)"
end)