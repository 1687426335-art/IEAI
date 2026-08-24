local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/kitten-maomao/cdnUI/refs/heads/main/Mao%20ui%E4%BF%AE%E5%A4%8Dbug.lua"))()
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)
local Window = WindUI:CreateWindow({
    Title = "<font color='#FFC0CB'><b>猫脚本</b></font>",
    Author = "<font color='#FFC0CB'><b>猫天帝制作</b></font>",
    Folder = "猫脚本",
    Size = UDim2.fromOffset(390, 460),
    Transparent = false,
    Theme = "Dark",
    SideBarWidth = 150,
    ScrollBarEnabled = true,
    Background = "rbxassetid://115018839123076",
    BackgroundlmageTransparency = 0.5,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 165, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 192, 203))
    }),
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function() end
    },
})
Window:EditOpenButton({
    Title = "<font color='#FFC0CB'><b>猫脚本</b></font>",
    CornerRadius = UDim.new(0, 10),
    StrokeThickness = 2.5,
    Color = ColorSequence.new(Color3.fromRGB(255, 100, 100)),
    Draggable = true,
})
local GameTag = Window:Tag({
    Title = "",
    Color = Color3.fromRGB(255, 255, 0),
    Radius = 12
})
local TimeTag = Window:Tag({
    Title = os.date("%H:%M"),
    Color = Color3.fromRGB(0, 255, 0),
    Radius = 12
})
local TimerTag = Window:Tag({
    Title = "00:00:00",
    Color = Color3.fromRGB(178, 34, 34),
    Radius = 12
})
local SessionTag = Window:Tag({
    Title = "00:00:00",
    Color = Color3.fromRGB(0, 100, 255),
    Radius = 12
})
local saveFolder = "猫脚本"
local saveFile = saveFolder .. "/total_time.json"
local function loadTotalTime()
    pcall(function()
        if not isfolder(saveFolder) then makefolder(saveFolder) end
    end)
    local saved = 0
    pcall(function()
        if isfile(saveFile) then
            local data = readfile(saveFile)
            saved = tonumber(data) or 0
        end
    end)
    return saved
end
local function saveTotalTime(total)
    pcall(function()
        if not isfolder(saveFolder) then makefolder(saveFolder) end
        writefile(saveFile, tostring(total))
    end)
end
local historyTime = loadTotalTime()
local sessionStartTime = tick()
local currentSessionStartTime = tick()
local function formatTime(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = math.floor(seconds % 60)
    return string.format("%02d:%02d:%02d", h, m, s)
end
if TimerTag and TimerTag.SetTitle then
    TimerTag:SetTitle(formatTime(historyTime))
end
task.spawn(function()
    while TimerTag do
        task.wait(1)
        if TimeTag and TimeTag.SetTitle then
            TimeTag:SetTitle(os.date("%H:%M"))
        end
        if TimerTag and TimerTag.SetTitle then
            local sessionElapsed = tick() - sessionStartTime
            local totalElapsed = historyTime + sessionElapsed
            TimerTag:SetTitle(formatTime(totalElapsed))
            saveTotalTime(totalElapsed)
        end
        if SessionTag and SessionTag.SetTitle then
            local currentSessionElapsed = tick() - currentSessionStartTime
            SessionTag:SetTitle(formatTime(currentSessionElapsed))
        end
    end
end)
local Tabs = {}
function Tabs:Create(name, icon)
    return Window:Tab({ Title = name, Icon = icon })
end
Tabs.Announce = Tabs:Create("<font color='#FFC0CB'>公告</font>", "megaphone")
Tabs.Announce:Paragraph({
    Title = "<font color='#FFC0CB'><b>猫脚本制作不易勿喷</b></font>",
    Desc = "",
    Image = "heart",
    ImageSize = 26,
})
Tabs.Announce:Paragraph({
    Title = "<font color='#FFC0CB'><b>感谢支持</b></font>",
    Desc = "",
    Image = "heart",
    ImageSize = 26,
})
Tabs.Announce:Paragraph({
    Title = "<font color='#FFC0CB'><b>猫脚本是免费的，可以倒卖，前提是要发脚本，拉他们进猫脚本的群\n猫脚本也支持为各大付费脚本服务，想要源码可以找我来领取源码</b></font>",
    Desc = "",
    Image = "heart",
    ImageSize = 26,
})
local announcePara = Tabs.Announce:Paragraph({
    Title = "<font color='#FFC0CB'><b>猫脚本：569036702\n猫脚本互赞群：1051220818</b></font>",
    Desc = "",
    Image = "heart",
    ImageSize = 26,
})
task.spawn(function()
    task.wait(0.3)
    pcall(function()
        local frame = announcePara.Frame or announcePara.Instance or announcePara.Main or announcePara.Container
        if not frame then
            for _, v in pairs(announcePara) do
                if typeof(v) == "Instance" and v:IsA("GuiObject") then
                    frame = v
                    break
                end
            end
        end
        if frame and frame:IsA("GuiObject") then
            frame.Active = true
            frame.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    pcall(function()
                        if setclipboard then
                            setclipboard("猫脚本：569036702 | 猫脚本互赞群：1051220818")
                        end
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "猫脚本",
                            Text = "猫脚本QQ群号与互赞群号已复制到剪贴板！",
                            Duration = 3
                        })
                    end)
                end
            end)
        end
    end)
end)
Tabs.Announce:Button({
    Title = "<font color='#FFD700'><b>🏆 点击查看赞助榜 🏆</b></font>",
    Callback = function()
        local sponsorUrl = "https://raw.githubusercontent.com/kitten-maomao/Master-script/refs/heads/main/sponsor.txt"
        pcall(function()
            if setclipboard then
                setclipboard(sponsorUrl)
            end
        end)
        local ok = pcall(function()
            game:GetService("GuiService"):OpenBrowserWindow(sponsorUrl)
        end)
        if ok then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "猫脚本",
                Text = "正在打开浏览器查看赞助榜...",
                Duration = 3
            })
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "猫脚本",
                Text = "链接已复制到剪贴板，请粘贴到浏览器查看",
                Duration = 5
            })
        end
    end
})
local imageUrl = "https://bee-reg-ab.imagency.cn/p/93db9216459b0a0f94072f0ebf159f07.jpg"
local localAssetId = nil
task.spawn(function()
    pcall(function()
        local folder = "猫脚本"
        if not isfolder(folder) then makefolder(folder) end
        local filename = folder .. "/sponsor_img.png"
        local data = game:HttpGet(imageUrl)
        writefile(filename, data)
        local ok, asset = pcall(getcustomasset, filename)
        if ok then
            localAssetId = asset
        end
    end)
end)
local imagePara = Tabs.Announce:Paragraph({
    Title = "<font color='#FFD700'><b>点击放大</b></font>",
    Thumbnail = imageUrl,
    ThumbnailSize = 250,
})
local isEnlarged = false
task.spawn(function()
    task.wait(0.5)
    pcall(function()
        local function waitForAsset()
            local waited = 0
            while not localAssetId and waited < 10 do
                task.wait(0.5)
                waited = waited + 0.5
            end
            return localAssetId
        end
        local frame = imagePara.Frame or imagePara.Instance or imagePara.Main or imagePara.Container
        if not frame then
            for _, v in pairs(imagePara) do
                if typeof(v) == "Instance" and v:IsA("GuiObject") then
                    frame = v
                    break
                end
            end
        end
        if frame and frame:IsA("GuiObject") then
            frame.Active = true
            frame.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    pcall(function()
                        local asset = waitForAsset()
                        if not asset then return end
                        local PlayerGui = Players.LocalPlayer:FindFirstChild("PlayerGui")
                        if not PlayerGui then return end
                        if isEnlarged then
                            local overlay = PlayerGui:FindFirstChild("CatImageOverlay")
                            if overlay then
                                local img = overlay:FindFirstChild("EnlargedImage")
                                if img then
                                    local ts = game:GetService("TweenService")
                                    local ti = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                                    local goal = {Size = UDim2.new(0, 260, 0, 260)}
                                    local tween = ts:Create(img, ti, goal)
                                    tween:Play()
                                    tween.Completed:Connect(function()
                                        overlay:Destroy()
                                    end)
                                end
                            end
                            isEnlarged = false
                            return
                        end
                        local overlay = Instance.new("ScreenGui")
                        overlay.Name = "CatImageOverlay"
                        overlay.Parent = PlayerGui
                        local bg = Instance.new("Frame")
                        bg.Size = UDim2.new(1, 0, 1, 0)
                        bg.BackgroundTransparency = 1
                        bg.Active = true
                        bg.Parent = overlay
                        local img = Instance.new("ImageLabel")
                        img.Name = "EnlargedImage"
                        img.AnchorPoint = Vector2.new(0.5, 0.5)
                        img.Position = UDim2.new(0.5, 0, 0.5, 0)
                        img.Size = UDim2.new(0, 260, 0, 260)
                        img.BackgroundTransparency = 1
                        img.Image = asset
                        img.ScaleType = Enum.ScaleType.Fit
                        img.Parent = overlay
                        local targetSize = UDim2.new(0, 320, 0, 320)
                        local ts = game:GetService("TweenService")
                        local ti = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                        local goal = {Size = targetSize}
                        local tween = ts:Create(img, ti, goal)
                        tween:Play()
                        isEnlarged = true
                        bg.InputBegan:Connect(function(inp, gp)
                            if gp then return end
                            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                                local ts2 = game:GetService("TweenService")
                                local ti2 = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                                local goal2 = {Size = UDim2.new(0, 260, 0, 260)}
                                local tween2 = ts2:Create(img, ti2, goal2)
                                tween2:Play()
                                tween2.Completed:Connect(function()
                                    overlay:Destroy()
                                end)
                                isEnlarged = false
                            end
                        end)
                    end)
                end
            end)
        end
    end)
end)
Tabs.General = Tabs:Create("<font color='#FFC0CB'>通用</font>", "zap")
do
    local Tab = Tabs.General
    Tab:Button({
        Title = "<font color='#FFC0CB'><b>猫飞行</b></font>",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/kitten-maomao/tongyong/refs/heads/main/%E9%A3%9E%E8%A1%8C.lua"))("猫脚本")
        end
    })
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>穿墙</b></font>",
        Default = false,
        Callback = function(s)
            _G.CatNoclip_Enabled = s
            if s and not _G.CatNoclip_Running then
                loadstring(game:HttpGet("https://raw.githubusercontent.com/kitten-maomao/tongyong/refs/heads/main/%E7%A9%BF%E5%A2%99.lua"))("猫脚本")
            end
        end
    })
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>隐身</b></font>",
        Desc = "<font color='#FFC0CB'><i>本功能原作者为蛙QWQ</i></font>",
        Default = false,
        Callback = function(s)
            _G.CatInvis_Enabled = s
            if s and not _G.CatInvis_Running then
                loadstring(game:HttpGet("https://raw.githubusercontent.com/kitten-maomao/tongyong/refs/heads/main/%E7%8C%AB%E5%A4%A9%E5%B8%9D%E4%BA%8C%E6%94%B9%E9%9A%90%E8%BA%AB.lua"))("猫脚本")
            end
        end
    })
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>透视</b></font>",
        Default = false,
        Callback = function(s)
            _G.CatESP_Enabled = s
            if s and not _G.CatESP_Running then
                loadstring(game:HttpGet("https://raw.githubusercontent.com/kitten-maomao/tongyong/refs/heads/main/%E9%80%8F%E8%A7%86.lua"))("猫脚本")
            end
        end
    })
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>无限跳</b></font>",
        Default = false,
        Callback = function(s)
            _G.CatInfJump_Enabled = s
            if s and not _G.CatInfJump_Running then
                loadstring(game:HttpGet("https://raw.githubusercontent.com/kitten-maomao/tongyong/refs/heads/main/%E6%97%A0%E9%99%90%E8%B7%B3.lua"))("猫脚本")
            end
        end
    })
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>美化无头</b></font>",
        Default = false,
        Callback = function(s)
            _G.CatHeadless_Enabled = s
            if s and not _G.CatHeadless_Running then
                loadstring(game:HttpGet("https://raw.githubusercontent.com/kitten-maomao/tongyong/refs/heads/main/%E7%BE%8E%E5%8C%96%E6%97%A0%E5%A4%B4.lua"))("猫脚本")
            end
        end
    })
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>美化断腿</b></font>",
        Default = false,
        Callback = function(s)
            _G.CatBrokenLeg_Enabled = s
            if s and not _G.CatBrokenLeg_Running then
                loadstring(game:HttpGet("https://raw.githubusercontent.com/kitten-maomao/tongyong/refs/heads/main/%E7%BE%8E%E5%8C%96%E6%96%AD%E8%85%BF.lua"))("猫脚本")
            end
        end
    })
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>删除帽子</b></font>",
        Default = false,
        Callback = function(s)
            _G.CatNoHat_Enabled = s
            if s and not _G.CatNoHat_Running then
                loadstring(game:HttpGet("https://raw.githubusercontent.com/kitten-maomao/tongyong/refs/heads/main/%E5%88%A0%E9%99%A4%E5%B8%BD%E5%AD%90.lua"))("猫脚本")
            end
        end
    })
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>删除全部衣服</b></font>",
        Default = false,
        Callback = function(s)
            _G.CatNoClothes_Enabled = s
            if s and not _G.CatNoClothes_Running then
                loadstring(game:HttpGet("https://raw.githubusercontent.com/kitten-maomao/tongyong/refs/heads/main/%E5%88%A0%E9%99%A4%E5%85%A8%E9%83%A8%E8%A1%A3%E6%9C%8D.lua"))("猫脚本")
            end
        end
    })
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>防甩飞</b></font>",
        Default = false,
        Callback = function(s)
            _G.CatAntiFling_Enabled = s
            if s and not _G.CatAntiFling_Running then
                loadstring(game:HttpGet("https://raw.githubusercontent.com/kitten-maomao/tongyong/refs/heads/main/%E9%98%B2%E7%94%A9%E9%A3%9E.lua"))("猫脚本")
            end
        end
    })
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>速度</b></font>",
        Default = false,
        Callback = function(s)
            changeSpeed = s
            if s then
                task.spawn(function()
                    while changeSpeed do
                        pcall(function()
                            local char = Players.LocalPlayer.Character
                            if char and char:FindFirstChild("Humanoid") then
                                char.Humanoid.WalkSpeed = speedValue
                            end
                        end)
                        task.wait()
                    end
                end)
            end
        end
    })
    Tab:Input({
        Title = "<font color='#FFC0CB'><b>速度值</b></font>",
        Placeholder = "默认16",
        Default = "",
        Callback = function(v)
            local num = tonumber(v)
            if num then speedValue = num end
        end
    })
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>重力</b></font>",
        Default = false,
        Callback = function(s)
            changeGravity = s
            if s then
                task.spawn(function()
                    while changeGravity do
                        pcall(function() workspace.Gravity = gravityValue end)
                        task.wait()
                    end
                end)
            end
        end
    })
    Tab:Input({
        Title = "<font color='#FFC0CB'><b>重力值</b></font>",
        Placeholder = "默认196.2",
        Default = "",
        Callback = function(v)
            local num = tonumber(v)
            if num then gravityValue = num end
        end
    })
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>跳跃</b></font>",
        Default = false,
        Callback = function(s)
            changeJump = s
            if s then
                task.spawn(function()
                    while changeJump do
                        pcall(function()
                            local char = Players.LocalPlayer.Character
                            if char and char:FindFirstChild("Humanoid") then
                                char.Humanoid.JumpPower = jumpValue
                            end
                        end)
                        task.wait()
                    end
                end)
            end
        end
    })
    Tab:Input({
        Title = "<font color='#FFC0CB'><b>跳跃值</b></font>",
        Placeholder = "默认50",
        Default = "",
        Callback = function(v)
            local num = tonumber(v)
            if num then jumpValue = num end
        end
    })
    local playerDropdown = Tab:Dropdown({
        Title = "<font color='#FFC0CB'><b>选择玩家</b></font>",
        Values = {},
        Default = "",
        Callback = function(v)
            selectedPlayer = v
            _G.CatSelectedPlayer = v
        end
    })
    Tab:Button({
        Title = "<font color='#FFC0CB'><b>传送到玩家</b></font>",
        Callback = function()
            pcall(function()
                local char = Players.LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if not root then return end
                local target = Players:FindFirstChild(selectedPlayer)
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    root.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                end
            end)
        end
    })
    Tab:Button({
        Title = "<font color='#FFC0CB'><b>把玩家传送过来</b></font>",
        Callback = function()
            pcall(function()
                local char = Players.LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if not root then return end
                local target = Players:FindFirstChild(selectedPlayer)
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    target.Character.HumanoidRootPart.CFrame = root.CFrame * CFrame.new(0, 3, 0)
                end
            end)
        end
    })
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>循环传送玩家</b></font>",
        Default = false,
        Callback = function(s)
            loopTpToPlayer = s
            if s then
                task.spawn(function()
                    while loopTpToPlayer do
                        pcall(function()
                            local char = Players.LocalPlayer.Character
                            local root = char and char:FindFirstChild("HumanoidRootPart")
                            if not root then return end
                            local target = Players:FindFirstChild(selectedPlayer)
                            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                                root.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                            end
                        end)
                        task.wait(0.1)
                    end
                end)
            end
        end
    })
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>循环传送过来</b></font>",
        Default = false,
        Callback = function(s)
            loopTpToMe = s
            if s then
                task.spawn(function()
                    while loopTpToMe do
                        pcall(function()
                            local char = Players.LocalPlayer.Character
                            local root = char and char:FindFirstChild("HumanoidRootPart")
                            if not root then return end
                            local target = Players:FindFirstChild(selectedPlayer)
                            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                                target.Character.HumanoidRootPart.CFrame = root.CFrame * CFrame.new(0, 3, 0)
                            end
                        end)
                        task.wait(0.1)
                    end
                end)
            end
        end
    })
    Tab:Toggle({
        Title = "<font color='#FFC0CB'><b>循环甩飞玩家</b></font>",
        Default = false,
        Callback = function(s)
            _G.CatFling_Enabled = s
            if s and not _G.CatFling_Running then
                loadstring(game:HttpGet("https://raw.githubusercontent.com/kitten-maomao/tongyong/refs/heads/main/%E7%94%A9%E9%A3%9E.lua"))("猫脚本")
            end
        end
    })
    local changeSpeed = false
    local speedValue = 16
    local changeGravity = false
    local gravityValue = 196.2
    local changeJump = false
    local jumpValue = 50
    local selectedPlayer = ""
    _G.CatSelectedPlayer = ""
    local function getPlayerList()
        local list = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= Players.LocalPlayer then
                table.insert(list, p.Name)
            end
        end
        if #list == 0 then table.insert(list, "无玩家") end
        return list
    end
    local function refreshPlayerList()
        local list = getPlayerList()
        if playerDropdown then
            if playerDropdown.SetValues then
                playerDropdown:SetValues(list)
            elseif playerDropdown.Refresh then
                playerDropdown:Refresh(list)
            elseif playerDropdown.Update then
                playerDropdown:Update({ Values = list })
            end
        end
    end
    refreshPlayerList()
    Players.PlayerAdded:Connect(refreshPlayerList)
    Players.PlayerRemoving:Connect(function(plr)
        if selectedPlayer == plr.Name then
            selectedPlayer = ""
            _G.CatSelectedPlayer = ""
        end
        refreshPlayerList()
    end)
    local loopTpToPlayer = false
    local loopTpToMe = false
end
Window:SelectTab(1)