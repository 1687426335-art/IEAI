local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if LocalPlayer.Name == "twgsvgs6" then
    LocalPlayer:Kick("[你被禁止使用原因:Roblox服饰装扮辱华")
else
    local CurrentPlaceId = tostring(game.PlaceId)
    
    -- 只保留圣奥里
    if CurrentPlaceId == "14030691" then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/1687426335-art/IEAI/refs/heads/main/wyxamzo.lua"))()
    else
        local RevenantLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/Revenant", true))()
        RevenantLib:Notification({
            Text = "当前游戏不是圣奥里，不支持自动加载",
            Duration = 5,
        })
    end
end