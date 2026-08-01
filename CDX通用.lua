--[[
    CDX UI Framework - Universal Version
    
    Author: LOL
    Keybind: Left Alt to open/close
    Platform: Mobile & PC Support
]]

-- 加載 Compkiller 庫
local Compkiller = loadstring(game:HttpGet("https://raw.githubusercontent.com/4lpaca-pin/CompKiller/refs/heads/main/src/source.luau"))();

-- 創建通知系統
local Notifier = Compkiller.newNotify();

-- 配置管理器
local ConfigManager = Compkiller:ConfigManager({
    Directory = "CDX-UI",
    Config = "CDX-Config"
});

-- 檢測設備類型
local UserInputService = game:GetService("UserInputService")
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled
local isPC = UserInputService.KeyboardEnabled and UserInputService.MouseEnabled and not UserInputService.TouchEnabled
local deviceType = isMobile and "Mobile" or isPC and "PC" or "Unknown"

print("設備檢測: " .. deviceType)

-- 根據設備類型調整設置
local scaleSetting = Compkiller.Scale.Auto
local textSizeSetting = isMobile and 18 or 15
local loadTime = isMobile and 1.5 or 2.5

-- 加載界面
Compkiller:Loader("rbxassetid://120245531583106", loadTime).yield();

-- 創建主窗口
local Window = Compkiller.new({
    Name = "CDX",
    Keybind = "LeftAlt",
    Logo = "rbxassetid://120245531583106",
    Scale = scaleSetting,
    TextSize = textSizeSetting,
});

-- 歡迎通知
Notifier.new({
    Title = "CDX",
    Content = "CDX已加載 (" .. deviceType .. ")",
    Duration = isMobile and 3 or 5,
    Icon = "rbxassetid://120245531583106"
});

-- 水印
local Watermark = Window:Watermark();
Watermark:AddText({
    Icon = "user",
    Text = "LOL",
});

-- 創建主頁標籤頁
Window:DrawCategory({
    Name = "主要"
});

local HomeTab = Window:DrawTab({
    Name = "主頁",
    Icon = "home",
    EnableScrolling = true
});

-- 左側欄：信息
local InfoSection = HomeTab:DrawSection({
    Name = "信息",
    Position = 'left'
});

InfoSection:AddParagraph({
    Title = "作者",
    Content = "LOL"
});

InfoSection:AddParagraph({
    Title = "合作者",
    Content = "心情"
});

InfoSection:AddParagraph({
    Title = "目前狀態",
    Content = "Dev"
});

-- 創建通用標籤頁
Window:DrawCategory({
    Name = "功能"
});

local GeneralTab = Window:DrawTab({
    Name = "通用",
    Icon = "settings",
    EnableScrolling = true
});

-- 設定變量
local SpeedEnabled = false
local SpeedMultiplier = 2
local JumpEnabled = false
local JumpPower = 50
local FOVEnabled = false
local FOVValue = 70
local WideAngleEnabled = false
local WideAngleValue = 90
local NoclipEnabled = false
local InfiniteJumpEnabled = false
local AutoPromoteEnabled = false
local HealthRegenEnabled = false
local DefaultFOV = 70  -- 默認視野值

-- 自動攻擊相關變量
local AutoAttackEnabled = false
local AutoAttackRunning = false
local AutoAttackConfig = nil

-- 保存原始值
local OriginalWalkSpeed = 16
local OriginalJumpPower = 50
local OriginalFOV = DefaultFOV

-- 穿牆相關變量
local NoclipConnection = nil
local OriginalCollisions = {}
local LastNoclipCheck = 0
local NoclipCheckInterval = 0.1

-- 無限跳相關變量
local InfiniteJumpConnection = nil
local JumpKey = Enum.KeyCode.Space
local LastJumpTime = 0
local JumpCooldown = 0.2

-- 自動宣傳相關變量
local AutoPromoteConnection = nil
local AutoPromoteRunning = false

-- 生命恢復相關變量
local HealthRegenLoop = nil
local HFLoop = false

-- 通用左側欄
local GeneralLeftSection = GeneralTab:DrawSection({
    Name = "玩家設定",
    Position = 'left'
});

-- 玩家速度設定
local SpeedToggle = GeneralLeftSection:AddToggle({
    Name = "修改玩家速度",
    Flag = "PlayerSpeed_Toggle",
    Default = false,
    Callback = function(state)
        SpeedEnabled = state
        if state then
            Notifier.new({
                Title = "提示",
                Content = "玩家速度修改已啟用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
        else
            Notifier.new({
                Title = "提示",
                Content = "玩家速度修改已禁用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
            ResetSpeed()
        end
    end,
});

local SpeedSlider = GeneralLeftSection:AddSlider({
    Name = "速度倍率",
    Min = 1,
    Max = 10,
    Default = 2,
    Round = 1,
    Flag = "PlayerSpeed_Slider",
    Callback = function(value)
        SpeedMultiplier = value
        print("玩家速度倍率設定為: " .. value .. "x")
        if SpeedEnabled then
            ApplySpeed()
        end
    end
});

-- 跳躍高度設定
local JumpToggle = GeneralLeftSection:AddToggle({
    Name = "修改跳躍高度",
    Flag = "JumpHeight_Toggle",
    Default = false,
    Callback = function(state)
        JumpEnabled = state
        if state then
            Notifier.new({
                Title = "提示",
                Content = "跳躍高度修改已啟用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
        else
            Notifier.new({
                Title = "提示",
                Content = "跳躍高度修改已禁用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
            ResetJump()
        end
    end,
});

local JumpSlider = GeneralLeftSection:AddSlider({
    Name = "跳躍高度",
    Min = 20,
    Max = 200,
    Default = 50,
    Round = 0,
    Flag = "JumpHeight_Slider",
    Callback = function(value)
        JumpPower = value
        print("跳躍高度設定為: " .. value)
        if JumpEnabled then
            ApplyJump()
        end
    end
});

-- 穿牆功能
local NoclipToggle = GeneralLeftSection:AddToggle({
    Name = "穿牆模式",
    Flag = "Noclip_Toggle",
    Default = false,
    Callback = function(state)
        NoclipEnabled = state
        if state then
            Notifier.new({
                Title = "提示",
                Content = "穿牆模式已啟用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
            StartNoclip()
        else
            Notifier.new({
                Title = "提示",
                Content = "穿牆模式已禁用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
            StopNoclip()
            RestoreCollisions()
        end
    end,
});

-- 無限跳功能
local InfiniteJumpToggle = GeneralLeftSection:AddToggle({
    Name = "無限跳躍",
    Flag = "InfiniteJump_Toggle",
    Default = false,
    Callback = function(state)
        InfiniteJumpEnabled = state
        if state then
            Notifier.new({
                Title = "提示",
                Content = "無限跳躍已啟用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
            StartInfiniteJump()
        else
            Notifier.new({
                Title = "提示",
                Content = "無限跳躍已禁用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
            StopInfiniteJump()
        end
    end,
});

-- 循環恢復生命
local HealthRegenToggle = GeneralLeftSection:AddToggle({
    Name = "循環恢復生命",
    Flag = "HealthRegen_Toggle",
    Default = false,
    Callback = function(state)
        HealthRegenEnabled = state
        if state then
            Notifier.new({
                Title = "提示",
                Content = "循環恢復生命已啟用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
            StartHealthRegen()
        else
            Notifier.new({
                Title = "提示",
                Content = "循環恢復生命已禁用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
            StopHealthRegen()
        end
    end,
});

-- 自動宣傳功能
GeneralLeftSection:AddButton({
    Name = "自動宣傳",
    Callback = function()
        if AutoPromoteRunning then
            StopAutoPromote()
            Notifier.new({
                Title = "提示",
                Content = "自動宣傳已停止",
                Duration = 3,
                Icon = "rbxassetid://120245531583106"
            });
        else
            StartAutoPromote()
            Notifier.new({
                Title = "提示",
                Content = "自動宣傳已啟動",
                Duration = 3,
                Icon = "rbxassetid://120245531583106"
            });
        end
    end
});

-- 通用右側欄
local GeneralRightSection = GeneralTab:DrawSection({
    Name = "視覺設定",
    Position = 'right'
});

-- 視野距離設定
local FOVToggle = GeneralRightSection:AddToggle({
    Name = "修改視野距離",
    Flag = "FOV_Toggle",
    Default = false,
    Callback = function(state)
        FOVEnabled = state
        if state then
            Notifier.new({
                Title = "提示",
                Content = "視野距離修改已啟用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
        else
            Notifier.new({
                Title = "提示",
                Content = "視野距離修改已禁用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
        end
        ApplyFOV()
    end,
});

local FOVSlider = GeneralRightSection:AddSlider({
    Name = "視野距離 (FOV)",
    Min = 50,
    Max = 120,
    Default = 70,
    Round = 0,
    Flag = "FOV_Slider",
    Callback = function(value)
        FOVValue = value
        print("視野距離設定為: " .. value)
        if FOVEnabled then
            ApplyFOV()
        end
    end
});

-- 廣角設定
local WideAngleToggle = GeneralRightSection:AddToggle({
    Name = "修改廣角",
    Flag = "WideAngle_Toggle",
    Default = false,
    Callback = function(state)
        WideAngleEnabled = state
        if state then
            Notifier.new({
                Title = "提示",
                Content = "廣角修改已啟用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
        else
            Notifier.new({
                Title = "提示",
                Content = "廣角修改已禁用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
        end
        ApplyWideAngle()
    end,
});

local WideAngleSlider = GeneralRightSection:AddSlider({
    Name = "廣角度數",
    Min = 70,
    Max = 130,
    Default = 90,
    Round = 0,
    Flag = "WideAngle_Slider",
    Callback = function(value)
        WideAngleValue = value
        print("廣角度數設定為: " .. value)
        if WideAngleEnabled then
            ApplyWideAngle()
        end
    end
});

-- 自動攻擊功能
local AttackSection = GeneralTab:DrawSection({
    Name = "自動攻擊",
    Position = 'right'
});

-- 自動攻擊開關
local AutoAttackToggle = AttackSection:AddToggle({
    Name = "自動攻擊",
    Flag = "AutoAttack_Toggle",
    Default = false,
    Callback = function(state)
        AutoAttackEnabled = state
        if state then
            Notifier.new({
                Title = "提示",
                Content = "自動攻擊已啟用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
            StartAutoAttack()
        else
            Notifier.new({
                Title = "提示",
                Content = "自動攻擊已禁用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
            StopAutoAttack()
        end
    end,
});

-- 添加說明
GeneralRightSection:AddParagraph({
    Title = "使用說明",
    Content = "穿牆模式：無視牆壁和障礙物移動\n無限跳躍：在空中也能連續跳躍\n循環恢復生命：保持生命值為最高\n自動宣傳：自動發送宣傳訊息\n自動攻擊：自動攻擊附近敵人\n啟用開關後可調整對應數值"
});

-- 創建ESP標籤頁
Window:DrawCategory({
    Name = "視覺"
});

local EspTab = Window:DrawTab({
    Name = "Esp",
    Icon = "eye",
    EnableScrolling = true
});

-- ESP核心變量
local EspEnabled = false
local PlayerEspEnabled = false
local EnemyEspEnabled = false
local NpcEspEnabled = false
local ItemEspEnabled = false
local AntennaEspEnabled = false
local Box2DEspEnabled = false
local Box3DEspEnabled = false

-- ESP存儲
local EspObjects = {}
local EspHighlights = {}
local EspBillboards = {}
local EspBoxes = {}
local EspBeams = {}
local EspConnection = nil

-- 顏色定義
local PlayerColor = Color3.fromRGB(0, 255, 0)  -- 綠色
local EnemyColor = Color3.fromRGB(255, 0, 0)   -- 紅色
local NpcColor = Color3.fromRGB(0, 120, 255)   -- 藍色
local ItemColor = Color3.fromRGB(255, 165, 0)  -- 橙色
local EspColor = PlayerColor  -- 默認顏色

-- ESP左側欄
local EspLeftSection = EspTab:DrawSection({
    Name = "基本透視",
    Position = 'left'
});

-- ESP主開關
local EspMainToggle = EspLeftSection:AddToggle({
    Name = "ESP主開關",
    Flag = "Esp_Main_Toggle",
    Default = false,
    Callback = function(state)
        EspEnabled = state
        if state then
            Notifier.new({
                Title = "提示",
                Content = "ESP系統已啟用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
            StartEspLoop()
        else
            Notifier.new({
                Title = "提示",
                Content = "ESP系統已禁用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
            ClearAllEsp()
            StopEspLoop()
        end
    end,
});

-- 玩家透視
local PlayerEspToggle = EspLeftSection:AddToggle({
    Name = "玩家透視",
    Flag = "PlayerEsp_Toggle",
    Default = false,
    Callback = function(state)
        PlayerEspEnabled = state
        if state then
            Notifier.new({
                Title = "提示",
                Content = "玩家透視已啟用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
        else
            Notifier.new({
                Title = "提示",
                Content = "玩家透視已禁用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
            ClearPlayerEsp()
        end
    end,
});

-- 敵人透視
local EnemyEspToggle = EspLeftSection:AddToggle({
    Name = "敵人透視",
    Flag = "EnemyEsp_Toggle",
    Default = false,
    Callback = function(state)
        EnemyEspEnabled = state
        if state then
            Notifier.new({
                Title = "提示",
                Content = "敵人透視已啟用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
        else
            Notifier.new({
                Title = "提示",
                Content = "敵人透視已禁用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
            ClearEnemyEsp()
        end
    end,
});

-- NPC透視
local NpcEspToggle = EspLeftSection:AddToggle({
    Name = "NPC透視",
    Flag = "NpcEsp_Toggle",
    Default = false,
    Callback = function(state)
        NpcEspEnabled = state
        if state then
            Notifier.new({
                Title = "提示",
                Content = "NPC透視已啟用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
        else
            Notifier.new({
                Title = "提示",
                Content = "NPC透視已禁用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
            ClearNpcEsp()
        end
    end,
});

-- 物品透視
local ItemEspToggle = EspLeftSection:AddToggle({
    Name = "物品透視",
    Flag = "ItemEsp_Toggle",
    Default = false,
    Callback = function(state)
        ItemEspEnabled = state
        if state then
            Notifier.new({
                Title = "提示",
                Content = "物品透視已啟用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
        else
            Notifier.new({
                Title = "提示",
                Content = "物品透視已禁用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
            ClearItemEsp()
        end
    end,
});

-- ESP右側欄
local EspRightSection = EspTab:DrawSection({
    Name = "進階透視",
    Position = 'right'
});

-- 天線透視
local AntennaEspToggle = EspRightSection:AddToggle({
    Name = "天線透視",
    Flag = "AntennaEsp_Toggle",
    Default = false,
    Callback = function(state)
        AntennaEspEnabled = state
        if state then
            Notifier.new({
                Title = "提示",
                Content = "天線透視已啟用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
        else
            Notifier.new({
                Title = "提示",
                Content = "天線透視已禁用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
            ClearAntennaEsp()
        end
    end,
});

-- 2D框透視
local Box2DEspToggle = EspRightSection:AddToggle({
    Name = "2D框透視",
    Flag = "Box2DEsp_Toggle",
    Default = false,
    Callback = function(state)
        Box2DEspEnabled = state
        if state then
            Notifier.new({
                Title = "提示",
                Content = "2D框透視已啟用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
        else
            Notifier.new({
                Title = "提示",
                Content = "2D框透視已禁用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
            ClearBox2DEsp()
        end
    end,
});

-- 3D框透視
local Box3DEspToggle = EspRightSection:AddToggle({
    Name = "3D框透視",
    Flag = "Box3DEsp_Toggle",
    Default = false,
    Callback = function(state)
        Box3DEspEnabled = state
        if state then
            Notifier.new({
                Title = "提示",
                Content = "3D框透視已啟用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
        else
            Notifier.new({
                Title = "提示",
                Content = "3D框透視已禁用",
                Duration = 2,
                Icon = "rbxassetid://120245531583106"
            });
            ClearBox3DEsp()
        end
    end,
});

-- 透視設定區域
local EspSettingsSection = EspTab:DrawSection({
    Name = "透視設定",
    Position = 'left'
});

-- 透視距離設定
local EspMaxDistance = 100
local EspDistanceSlider = EspSettingsSection:AddSlider({
    Name = "透視距離",
    Min = 10,
    Max = 500,
    Default = 100,
    Round = 0,
    Flag = "Esp_Distance",
    Callback = function(value)
        EspMaxDistance = value
        print("透視距離設定為: " .. value)
    end
});

-- 透視刷新率
local EspUpdateRate = 0.1
local EspUpdateSlider = EspSettingsSection:AddSlider({
    Name = "刷新率(秒)",
    Min = 0.05,
    Max = 1,
    Default = 0.1,
    Round = 2,
    Flag = "Esp_UpdateRate",
    Callback = function(value)
        EspUpdateRate = value
        print("ESP刷新率設定為: " .. value .. "秒")
    end
});

-- 添加ESP功能說明
EspSettingsSection:AddParagraph({
    Title = "ESP功能說明",
    Content = "玩家/敵人/NPC透視：顯示輪廓和名稱\n2D框：屏幕上顯示2D方框\n3D框：遊戲世界中顯示3D方框\n天線：顯示位置線條"
});

-- ====================================================================
-- 基礎函數定義
-- ====================================================================

function ResetSpeed()
    local player = game.Players.LocalPlayer
    if player and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = OriginalWalkSpeed
        end
    end
end

function ApplySpeed()
    if not SpeedEnabled then return end
    local player = game.Players.LocalPlayer
    if player and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = OriginalWalkSpeed * SpeedMultiplier
        end
    end
end

function ResetJump()
    local player = game.Players.LocalPlayer
    if player and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpPower = OriginalJumpPower
        end
    end
end

function ApplyJump()
    if not JumpEnabled then return end
    local player = game.Players.LocalPlayer
    if player and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpPower = JumpPower
        end
    end
end

function ApplyFOV()
    if not FOVEnabled and not WideAngleEnabled then
        ResetFOV()
        return
    end
    
    local camera = game:GetService("Workspace").CurrentCamera
    if camera then
        if WideAngleEnabled then
            camera.FieldOfView = WideAngleValue
        elseif FOVEnabled then
            camera.FieldOfView = FOVValue
        end
    end
end

function ResetFOV()
    local camera = game:GetService("Workspace").CurrentCamera
    if camera then
        camera.FieldOfView = DefaultFOV
    end
end

function ApplyWideAngle()
    ApplyFOV()
end

-- ====================================================================
-- 穿牆功能函數
-- ====================================================================

function StartNoclip()
    if NoclipConnection then
        NoclipConnection:Disconnect()
    end
    
    NoclipConnection = game:GetService("RunService").Stepped:Connect(function()
        if not NoclipEnabled then
            StopNoclip()
            return
        end
        
        local player = game.Players.LocalPlayer
        if player and player.Character then
            local currentTime = tick()
            
            -- 定期檢查，避免過度頻繁的操作
            if currentTime - LastNoclipCheck > NoclipCheckInterval then
                LastNoclipCheck = currentTime
                
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        -- 保存原始碰撞狀態（如果還沒保存）
                        if not OriginalCollisions[part] then
                            OriginalCollisions[part] = part.CanCollide
                        end
                        
                        -- 設置為無碰撞
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
    
    print("穿牆模式已啟動")
end

function StopNoclip()
    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end
    
    print("穿牆模式已停止")
end

function RestoreCollisions()
    for part, canCollide in pairs(OriginalCollisions) do
        if part and part.Parent then
            pcall(function()
                part.CanCollide = canCollide
            end)
        end
    end
    OriginalCollisions = {}
    
    print("碰撞已恢復")
end

-- ====================================================================
-- 無限跳功能函數
-- ====================================================================

function StartInfiniteJump()
    if InfiniteJumpConnection then
        InfiniteJumpConnection:Disconnect()
    end
    
    InfiniteJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
        if not InfiniteJumpEnabled then
            StopInfiniteJump()
            return
        end
        
        local player = game.Players.LocalPlayer
        if player and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                local currentTime = tick()
                
                -- 冷卻時間檢查，避免過度頻繁的跳躍
                if currentTime - LastJumpTime > JumpCooldown then
                    LastJumpTime = currentTime
                    
                    -- 強制跳躍
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end
    end)
    
    print("無限跳躍已啟動")
end

function StopInfiniteJump()
    if InfiniteJumpConnection then
        InfiniteJumpConnection:Disconnect()
        InfiniteJumpConnection = nil
    end
    
    print("無限跳躍已停止")
end

-- ====================================================================
-- 循環恢復生命功能函數
-- ====================================================================

function StartHealthRegen()
    if HealthRegenLoop then
        return
    end
    
    HFLoop = true
    HealthRegenLoop = task.spawn(function()
        while HFLoop and HealthRegenEnabled do
            local lp = game.Players.LocalPlayer
            if lp then
                local character = lp.Character
                if character then
                    local hum = character:FindFirstChildWhichIsA("Humanoid")
                    if hum and hum.Parent then
                        pcall(function()
                            hum.Health = 9000000000
                        end)
                    end
                end
            end
            task.wait(0.5)
        end
        HealthRegenLoop = nil
    end)
    
    print("循環恢復生命已啟動")
end

function StopHealthRegen()
    HFLoop = false
    if HealthRegenLoop then
        task.cancel(HealthRegenLoop)
        HealthRegenLoop = nil
    end
    
    print("循環恢復生命已停止")
end

-- ====================================================================
-- 自動宣傳功能函數
-- ====================================================================

function StartAutoPromote()
    if AutoPromoteRunning then return end
    
    AutoPromoteRunning = true
    AutoPromoteEnabled = true
    
    -- 在後台運行自動宣傳
    task.spawn(function()
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local TextChatService = (pcall(function() return game:GetService("TextChatService") end) and game:GetService("TextChatService")) or nil

        local AUTO_CHAT_MSG = "CDX最佳脚本，功能有修改速度，自动发言，esp等等"
        local CHAT_INTERVAL = 1.5

        local function tryTextChatSend(message)
            if not TextChatService then return false end
            local ok = false
            pcall(function()
                if TextChatService.TextChannels then
                    local ch = TextChatService.TextChannels:FindFirstChild("RBXGeneral") or TextChatService.TextChannels:FindFirstChild("RBXGeneralChannel")
                    if ch and ch.SendAsync then
                        ch:SendAsync(message)
                        ok = true
                    end
                end
            end)
            return ok
        end

        local function tryOldChatSend(message)
            local ok = false
            pcall(function()
                local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
                if chatEvents then
                    local SayMessageRequest = chatEvents:FindFirstChild("SayMessageRequest")
                    if SayMessageRequest then
                        SayMessageRequest:FireServer(message, "All")
                        ok = true
                    end
                end
            end)
            return ok
        end

        local function tryPlayerChat(message)
            local ok = false
            pcall(function()
                local pl = Players.LocalPlayer
                if pl and pl.Chat then
                    pl:Chat(message)
                    ok = true
                end
            end)
            return ok
        end

        local function sendSilentMessage()
            if not Players.LocalPlayer then return false end
            
            local msg = tostring(AUTO_CHAT_MSG or "")
            if msg == "" then return false end
            
            local sent = false
            pcall(function() sent = tryTextChatSend(msg) or sent end)
            if not sent then pcall(function() sent = tryOldChatSend(msg) or sent end) end
            if not sent then pcall(function() sent = tryPlayerChat(msg) or sent end) end
            
            return sent
        end

        if not Players.LocalPlayer then
            Players.PlayerAdded:Wait()
        end
        wait(1.5)

        -- 發送第一條訊息
        pcall(sendSilentMessage)
        print("自動宣傳：第一條訊息已發送")

        -- 循環發送訊息
        while AutoPromoteEnabled do
            wait(CHAT_INTERVAL)
            pcall(sendSilentMessage)
            print("自動宣傳：訊息已發送")
        end
        
        print("自動宣傳：循環已結束")
        AutoPromoteRunning = false
    end)
    
    print("自動宣傳已啟動")
end

function StopAutoPromote()
    AutoPromoteEnabled = false
    AutoPromoteRunning = false
    
    print("自動宣傳已停止")
end

-- ====================================================================
-- 自動攻擊功能函數
-- ====================================================================

function StartAutoAttack()
    if AutoAttackRunning then
        return
    end
    
    AutoAttackRunning = true
    
    -- 保存原始全局配置（如果有）
    local oldConfigs = getgenv().configs
    
    -- 清理舊的配置
    if oldConfigs then
        local disableEvent = oldConfigs.Disable
        if disableEvent then
            pcall(function()
                disableEvent:Fire()
                disableEvent:Destroy()
            end)
        end
        
        local connections = oldConfigs.connections
        if connections then
            for _, connection in pairs(connections) do
                pcall(function()
                    connection:Disconnect()
                end)
            end
            table.clear(connections)
        end
        table.clear(oldConfigs)
    end
    
    -- 創建新的配置
    local disableEvent = Instance.new("BindableEvent")
    getgenv().configs = {
        connections = {},
        Disable = disableEvent,
        Size = Vector3.new(10, 10, 10),
        DeathCheck = true,
    }
    
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    
    local isActive = true
    
    local overlapParams = OverlapParams.new()
    overlapParams.FilterType = Enum.RaycastFilterType.Include
    
    -- 獲取角色函數
    local function getCharacter(player)
        if not player then
            player = LocalPlayer
        end
        if player and player.Character then
            return player.Character
        end
        return nil
    end
    
    -- 安全獲取Humanoid函數
    local function getHumanoid(target)
        if not target then
            return nil
        end
        
        local candidate = target
        
        if type(candidate) == "userdata" and candidate.IsA then
            if candidate:IsA("Player") then
                candidate = getCharacter(candidate)
            end
            
            if candidate and type(candidate) == "userdata" and candidate.IsA then
                if candidate:IsA("Model") then
                    return candidate:FindFirstChildWhichIsA("Humanoid") or candidate:FindFirstChild("Humanoid")
                elseif candidate:IsA("Humanoid") then
                    return candidate
                end
            end
        end
        
        return nil
    end
    
    -- 檢查是否存活函數
    local function isAlive(humanoid)
        return humanoid and humanoid.Health > 0
    end
    
    -- 檢查是否有接觸傳輸器函數
    local function hasTouchTransmitter(part)
        return part and part:FindFirstChildWhichIsA("TouchTransmitter", true)
    end
    
    -- 獲取所有其他玩家角色函數
    local function getOtherCharacters(character)
        local characters = {}
        for _, player in pairs(Players:GetPlayers()) do
            local playerCharacter = getCharacter(player)
            if playerCharacter then
                table.insert(characters, playerCharacter)
            end
        end
        
        for i, char in pairs(characters) do
            if char == character then
                table.remove(characters, i)
                break
            end
        end
        
        return characters
    end
    
    -- 觸發攻擊函數
    local function triggerAttack(tool, weaponPart, targetPart)
        if tool:IsDescendantOf(workspace) then
            -- 激活工具
            pcall(function()
                tool:Activate()
            end)
            
            -- 使用firetouchinterest進行攻擊
            pcall(function()
                firetouchinterest(weaponPart, targetPart, 1)
                firetouchinterest(weaponPart, targetPart, 0)
            end)
        end
    end
    
    -- 添加停止事件監聽
    table.insert(getgenv().configs.connections, disableEvent.Event:Connect(function()
        isActive = false
    end))
    
    -- 主攻擊循環
    task.spawn(function()
        while isActive and AutoAttackEnabled do
            local character = getCharacter()
            local humanoid = getHumanoid(character)
            
            if isAlive(humanoid) then
                local tool = character and character:FindFirstChildWhichIsA("Tool")
                local weaponPart = tool and hasTouchTransmitter(tool)
                
                if weaponPart then
                    local weaponPartParent = weaponPart.Parent
                    local otherCharacters = getOtherCharacters(character)
                    
                    overlapParams.FilterDescendantsInstances = otherCharacters
                    
                    for _, part in pairs(workspace:GetPartBoundsInBox(
                        weaponPartParent.CFrame,
                        weaponPartParent.Size + getgenv().configs.Size,
                        overlapParams
                    )) do
                        local targetCharacter = part:FindFirstAncestorWhichIsA("Model")
                        

if table.find(otherCharacters, targetCharacter) then
                            local targetHumanoid = getHumanoid(targetCharacter)
                            
                            if getgenv().configs.DeathCheck then
                                if isAlive(targetHumanoid) then
                                    triggerAttack(tool, weaponPartParent, part)
                                end
                            else
                                triggerAttack(tool, weaponPartParent, part)
                            end
                        end
                    end
                end
            end
            
            RunService.Heartbeat:Wait()
        end
        
        AutoAttackRunning = false
        print("自動攻擊已停止")
    end)
    
    print("自動攻擊已啟動")
end

function StopAutoAttack()
    if not AutoAttackRunning then
        return
    end
    
    local configs = getgenv().configs
    if configs then
        local disableEvent = configs.Disable
        if disableEvent then
            pcall(function()
                disableEvent:Fire()
                disableEvent:Destroy()
            end)
        end
        
        local connections = configs.connections
        if connections then
            for _, connection in pairs(connections) do
                pcall(function()
                    connection:Disconnect()
                end)
            end
            table.clear(connections)
        end
        table.clear(configs)
    end
    
    AutoAttackRunning = false
    AutoAttackEnabled = false
    print("自動攻擊已停止")
end

-- ====================================================================
-- ESP函數定義
-- ====================================================================

-- 清除所有ESP
function ClearAllEsp()
    for _, obj in pairs(EspObjects) do
        if obj and obj.Parent then
            pcall(function()
                obj:Destroy()
            end)
        end
    end
    EspObjects = {}
    
    for _, beam in pairs(EspBeams) do
        if beam and beam.Parent then
            pcall(function()
                beam:Destroy()
            end)
        end
    end
    EspBeams = {}
    
    for _, box in pairs(EspBoxes) do
        if box and box.Parent then
            pcall(function()
                box:Destroy()
            end)
        end
    end
    EspBoxes = {}
    
    -- 清除所有玩家的ESP
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            ClearCharacterEsp(player.Character)
        end
    end
    
    -- 清除工作區中的NPC和物品ESP
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") then
            ClearCharacterEsp(obj)
        end
    end
end

-- 清除角色ESP
function ClearCharacterEsp(character)
    if not character then return end
    
    local highlight = character:FindFirstChild("CDX_Highlight")
    if highlight then
        pcall(function()
            highlight:Destroy()
        end)
    end
    
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            local billboard = part:FindFirstChild("CDX_Billboard")
            if billboard then
                pcall(function()
                    billboard:Destroy()
                end)
            end
            
            local box3d = part:FindFirstChild("CDX_Box3D")
            if box3d then
                pcall(function()
                    box3d:Destroy()
                end)
            end
        end
    end
end

-- 清除特定ESP類型
function ClearPlayerEsp()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            ClearCharacterEsp(player.Character)
        end
    end
end

function ClearEnemyEsp()
    ClearPlayerEsp()  -- 暫時使用相同邏輯
end

function ClearNpcEsp()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not game.Players:GetPlayerFromCharacter(obj) then
            ClearCharacterEsp(obj)
        end
    end
end

function ClearItemEsp()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local highlight = obj:FindFirstChild("CDX_Highlight")
            if highlight then
                pcall(function()
                    highlight:Destroy()
                end)
            end
        end
    end
end

function ClearAntennaEsp()
    for _, beam in pairs(EspBeams) do
        if beam and beam.Parent then
            pcall(function()
                beam:Destroy()
            end)
        end
    end
    EspBeams = {}
end

function ClearBox2DEsp()
    for _, box in pairs(EspBoxes) do
        if box and box.Parent then
            pcall(function()
                box:Destroy()
            end)
        end
    end
    EspBoxes = {}
end

function ClearBox3DEsp()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    local box3d = part:FindFirstChild("CDX_Box3D")
                    if box3d then
                        pcall(function()
                            box3d:Destroy()
                        end)
                    end
                end
            end
        end
    end
end

-- 停止ESP循環
function StopEspLoop()
    if EspConnection then
        EspConnection:Disconnect()
        EspConnection = nil
    end
end

-- 檢查是否在視野內
function IsInViewport(position)
    local camera = workspace.CurrentCamera
    local screenPoint = camera:WorldToViewportPoint(position)
    return screenPoint.Z > 0
end

-- 計算距離
function CalculateDistance(position1, position2)
    return (position1 - position2).Magnitude
end

-- ESP主循環
function StartEspLoop()
    -- 停止之前的循環
    StopEspLoop()
    
    -- 創建新循環
    EspConnection = game:GetService("RunService").RenderStepped:Connect(function()
        if not EspEnabled then
            StopEspLoop()
            return
        end
        
        -- 清除所有ESP
        ClearAllEsp()
        
        -- 更新各種ESP
        UpdatePlayerEsp()
        UpdateEnemyEsp()
        UpdateNpcEsp()
        UpdateItemEsp()
        UpdateAntennaEsp()
        UpdateBox2DEsp()
        UpdateBox3DEsp()
    end)
end

-- 更新玩家ESP
function UpdatePlayerEsp()
    if not PlayerEspEnabled then return end
    
    local localPlayer = game.Players.LocalPlayer
    local camera = workspace.CurrentCamera
    
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            CreateEntityHighlight(player.Character, PlayerColor, player.Name)
        end
    end
end

-- 更新敵人ESP（與玩家相同邏輯，但不同顏色）
function UpdateEnemyEsp()
    if not EnemyEspEnabled then return end
    
    local localPlayer = game.Players.LocalPlayer
    local camera = workspace.CurrentCamera
    
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            CreateEntityHighlight(player.Character, EnemyColor, player.Name .. " (敵人)")
        end
    end
end

-- 更新NPC ESP
function UpdateNpcEsp()
    if not NpcEspEnabled then return end
    
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") then
            local humanoid = obj:FindFirstChild("Humanoid")
            if humanoid and not game.Players:GetPlayerFromCharacter(obj) then
                CreateEntityHighlight(obj, NpcColor, obj.Name .. " (NPC)")
            end
        end
    end
end

-- 創建實體高亮
function CreateEntityHighlight(character, color, name)
    if not character then return end
    
    local camera = workspace.CurrentCamera
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head") or character.PrimaryPart
    
    if not humanoidRootPart then return end
    
    local distance = CalculateDistance(camera.CFrame.Position, humanoidRootPart.Position)
    if distance > EspMaxDistance then return end
    
    if not IsInViewport(humanoidRootPart.Position) then return end
    
    -- 創建高亮效果
    local highlight = Instance.new("Highlight")
    highlight.Name = "CDX_Highlight"
    highlight.Adornee = character
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = 0.8
    highlight.OutlineTransparency = 0.2
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character
    
    table.insert(EspObjects, highlight)
    
    -- 創建名稱標籤
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "CDX_Billboard"
    billboard.Adornee = humanoidRootPart
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = EspMaxDistance
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = name .. "\n距離: " .. math.floor(distance) .. " 單位"
    textLabel.TextColor3 = color
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.TextSize = 14
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Parent = billboard
    
    billboard.Parent = humanoidRootPart
    table.insert(EspObjects, billboard)
end

-- 更新物品ESP
function UpdateItemEsp()
    if not ItemEspEnabled then return end
    
    local camera = workspace.CurrentCamera
    
    -- 尋找可能的物品
    local itemNames = {"Tool", "Part", "Model", "MeshPart"}
    
    for _, itemName in pairs(itemNames) do
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA(itemName) then
                -- 檢查是否是物品
                local isItem = false
                local itemNamesToCheck = {"Item", "Tool", "Weapon", "Sword", "Gun", "Ammo", "Health", "Coin", "Money"}
                
                for _, namePart in pairs(itemNamesToCheck) do
                    if obj.Name:lower():find(namePart:lower()) then
                        isItem = true
                        break
                    end
                end
                
                if isItem then
                    local primaryPart = obj:IsA("Model") and obj.PrimaryPart or obj
                    if primaryPart then
                        local distance = CalculateDistance(camera.CFrame.Position, primaryPart.Position)
                        if distance <= EspMaxDistance then
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "CDX_Highlight"
                            highlight.Adornee = obj
                            highlight.FillColor = ItemColor
                            highlight.OutlineColor = ItemColor
                            highlight.FillTransparency = 0.7
                            highlight.OutlineTransparency = 0.3
                            highlight.Parent = obj
                            
                            table.insert(EspObjects, highlight)
                        end
                    end
                end
            end
        end
    end
end

-- 更新天線ESP
function UpdateAntennaEsp()
    if not AntennaEspEnabled then return end
    
    local localPlayer = game.Players.LocalPlayer
    if not localPlayer.Character then return end
    
    local localRoot = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end
    
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local distance = CalculateDistance(localRoot.Position, targetRoot.Position)
                if distance <= EspMaxDistance then
                    local beam = Instance.new("Beam")
                    beam.Name = "CDX_Beam"
                    
                    local attachment0 = Instance.new("Attachment")
                    attachment0.Parent = localRoot
                    attachment0.Position = Vector3.new(0, 0, 0)
                    
                    local attachment1 = Instance.new("Attachment")
                    attachment1.Parent = targetRoot
                    attachment1.Position = Vector3.new(0, 0, 0)
                    
                    beam.Attachment0 = attachment0
                    beam.Attachment1 = attachment1
                    beam.Color = ColorSequence.new(PlayerColor)
                    beam.Width0 = 0.1
                    beam.Width1 = 0.1
                    beam.Transparency = NumberSequence.new(0.5)
                    beam.Parent = workspace
                    
                    table.insert(EspBeams, beam)
                end
            end
        end
    end
end

-- 更新2D框ESP
function UpdateBox2DEsp()
    if not Box2DEspEnabled then return end
    
    local localPlayer = game.Players.LocalPlayer
    local camera = workspace.CurrentCamera
    
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local screenPoint, onScreen = camera:WorldToViewportPoint(humanoidRootPart.Position)
                
                if onScreen then
                    local distance = CalculateDistance(camera.CFrame.Position, humanoidRootPart.Position)
                    if distance <= EspMaxDistance then
                        local boxSize = 50 / (distance / 20)
                        boxSize = math.clamp(boxSize, 10, 100)
                        
                        local screenGui = Instance.new("ScreenGui")
                        screenGui.Name = "CDX_Box2D"
                        screenGui.ResetOnSpawn = false
                        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                        
                        local frame = Instance.new("Frame")
                        frame.Size = UDim2.new(0, boxSize, 0, boxSize * 2)
                        frame.Position = UDim2.new(0, screenPoint.X - boxSize/2, 0, screenPoint.Y - boxSize)
                        frame.BackgroundTransparency = 1
                        frame.BorderColor3 = PlayerColor
                        frame.BorderSizePixel = 2
                        frame.Parent = screenGui
                        
                        screenGui.Parent = game:GetService("CoreGui")
                        table.insert(EspBoxes, screenGui)
                    end
                end
            end
        end
    end
end

-- 更新3D框ESP
function UpdateBox3DEsp()
    if not Box3DEspEnabled then return end
    
    local camera = workspace.CurrentCamera
    
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local distance = CalculateDistance(camera.CFrame.Position, humanoidRootPart.Position)
                if distance <= EspMaxDistance then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Name = "CDX_Box3D"
                    box.Adornee = player.Character
                    box.AlwaysOnTop = true
                    box.ZIndex = 10
                    box.Size = player.Character:GetExtentsSize() * 1.1
                    box.Color3 = PlayerColor
                    box.Transparency = 0.7
                    box.Parent = player.Character
                    
                    table.insert(EspObjects, box)
                end
            end
        end
    end
end

-- ====================================================================
-- 主循環和初始化
-- ====================================================================

-- 通用功能循環
task.spawn(function()
    while true do
        task.wait(0.1)
        ApplySpeed()
        ApplyJump()
        ApplyFOV()
    end
end)

-- 角色重生時監聽
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    wait(1)
    -- 重置原始值
    if character:FindFirstChild("Humanoid") then
        OriginalWalkSpeed = character.Humanoid.WalkSpeed
        OriginalJumpPower = character.Humanoid.JumpPower
    end
    
    -- 重新應用設定
    ApplySpeed()
    ApplyJump()
    
    -- 如果穿牆啟用，重新啟動穿牆
    if NoclipEnabled then
        wait(0.5) -- 等待角色完全生成
        StartNoclip()
    end
    
    -- 如果生命恢復啟用，重新啟動生命恢復
    if HealthRegenEnabled then
        wait(0.5) -- 等待角色完全生成
        StartHealthRegen()
    end
    
    -- 如果自動攻擊啟用，重新啟動自動攻擊
    if AutoAttackEnabled then
        wait(0.5) -- 等待角色完全生成
        StartAutoAttack()
    end
    
    -- 如果ESP啟用，重新啟動ESP
    if EspEnabled then
        wait(0.5) -- 等待角色完全生成
        StartEspLoop()
    end
end)

-- 角色移除時監聽
game.Players.LocalPlayer.CharacterRemoving:Connect(function(character)
    -- 如果穿牆啟用，停止穿牆
    if NoclipEnabled then
        StopNoclip()
        RestoreCollisions()
    end
    
    -- 如果自動攻擊啟用，停止自動攻擊
    if AutoAttackEnabled then
        StopAutoAttack()
    end
end)

-- 初始化時獲取原始值
task.wait(2)
local player = game.Players.LocalPlayer
if player and player.Character then
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if humanoid then
        OriginalWalkSpeed = humanoid.WalkSpeed
        OriginalJumpPower = humanoid.JumpPower
    end
end

-- 獲取默認FOV
local camera = game:GetService("Workspace").CurrentCamera
if camera then
    DefaultFOV = camera.FieldOfView or 70
    OriginalFOV = DefaultFOV
end

print("CDX Universal UI framework initialized successfully!");
print("Device: " .. deviceType);
print("Press LeftAlt to open the interface");
print("Supports both Mobile and PC devices");
print("Features: Speed, Jump, FOV, Noclip, Infinite Jump, Health Regen, Auto Promote, Auto Attack, ESP");
print("Author: LOL | Co-author: 心情 | Status: Dev");
