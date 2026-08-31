local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if LocalPlayer.Name == "91vip78tangxin" then
    LocalPlayer:Kick("[Yttrium你被禁止使用原因:Roblox服饰装扮辱华")
else
    local CurrentPlaceId = tostring(game.PlaceId)
    local Scripts = {
        ["136801880565837"] = {
            url = "https://raw.githubusercontent.com/MillJacson832/-/refs/heads/main/%E9%97%AA%E5%85%89.lua",
            name = "闪光点"
        },
        ["17625359962"] = {
            url = "https://raw.githubusercontent.com/MillJacson832/-/refs/heads/main/%E7%AB%9E%E4%BA%89%E5%AF%B9%E6%89%8B.YttriumHubObfuscator.lua",
            name = "竞争对手"
        },
        ["189707"] = {
            url = "https://raw.githubusercontent.com/MillJacson832/-/refs/heads/main/%E8%87%AA%E7%84%B6%E7%81%BE%E5%AE%B3user.lua",
            name = "自然灾害免费版"
        },
        ["126509999114328"] = {
            url = "https://raw.githubusercontent.com/MillJacson832/_/refs/heads/main/%E6%A3%AE%E6%9E%97%E9%87%8C%E7%9A%8499%E5%A4%9C.lua",
            name = "在森林里的99夜"
        },
        ["142823291"] = {
            url = "https://raw.githubusercontent.com/MillJacson832/-/refs/heads/main/%E7%A0%B4%E5%9D%8F%E8%80%85%E8%B0%9C%E5%9B%A22.lua",
            name = "破坏者谜团2"
        },
        ["6137321701"] = {
            url = "https://raw.githubusercontent.com/MillJacson832/-/refs/heads/main/%E6%81%90%E9%AC%BC%E7%97%87(1).lua",
            name = "恐鬼症"
        },
        ["7239319209"] = {
            url = "https://raw.githubusercontent.com/MillJacson832/_/refs/heads/main/ohio%E6%96%B0%E7%89%88.lua",
            name = "俄亥俄州"
        },
        ["3101667897"] = {
            url = "https://raw.githubusercontent.com/MillJacson832/-/refs/heads/main/%E6%9E%81%E9%80%9F%E4%BC%A0%E5%A5%87.lua",
            name = "极速传奇"
        },
        ["127380660530951"] = {
            url = "https://raw.githubusercontent.com/MillJacson832/-/refs/heads/main/%E5%9C%A8%E8%B6%85%E5%B8%82%E7%94%9F%E6%B4%BB%E4%B8%80%E5%91%A8.lua",
            name = "请在游戏内执行"
        },
        ["121418861436763"] = {
            url = "https://raw.githubusercontent.com/MillJacson832/-/refs/heads/main/%E5%9C%A8%E8%B6%85%E5%B8%82%E7%94%9F%E6%B4%BB%E4%B8%80%E5%91%A8.lua",
            name = "在超市生活一周"
        },
        ["15169316384"] = {
            url = "https://raw.githubusercontent.com/MillJackson832/-/refs/heads/main/commit.lua",
            name = "犯罪"
        },
        ["83645629621104"] = {
            url = "https://raw.githubusercontent.com/MillJacson832/-/refs/heads/main/%E9%97%AA%E5%85%8.lua",
            name = "被遗弃"
        },
        ["14438406081"] = {
            url = "https://raw.githubusercontent.com/MillJacson832/-/refs/heads/main/%E9%80%9A%E7BC%89.lua",
            name = "通缉"
        },
        ["109983668079237"] = {
            url = "https://raw.githubusercontent.com/MillJacson832/-/refs/heads/main/%E5%81%B7%E8%B5%B%E8%84%91%E7%BA%A2.lua",
            name = "偷走脑红"
        },
        ["3623096087"] = {
            url = "https://raw.githubusercontent.com/MillJacson832/-/refs/heads/main/%E5%8A%9B%E9%87%8F%E4BC%A0%E5%A5%87.lua",
            name = "力量传奇"
        }
    }

    local RevenantLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/Revenant", true))()
    local RunService = game:GetService("RunService")
    local t = 0
    RunService.Heartbeat:Connect(function(dt)
        t = t + 0.012
        local r = math.sin(t*1.1)*0.45+0.55
        local g = math.sin(t*1.3)*0.45+0.55
        local b = math.sin(t*1.6)*0.45+0.55
        RevenantLib.DefaultColor = Color3.new(r,g,b)
    end)

    if Scripts[CurrentPlaceId] then
        loadstring(game:HttpGet(Scripts[CurrentPlaceId].url))()
        RevenantLib:Notification({
            Text = "自动执行成功 当前游戏: " .. Scripts[CurrentPlaceId].name .. "\u{e000}",
            Duration = 6,
        })
        wait(1)
    else
        RevenantLib:Notification({
            Text = "当前游戏我们不支持 可以提供游戏id我们会选择是否更新 游戏ID: " .. CurrentPlaceId,
            Duration = 5,
        })
    end
end