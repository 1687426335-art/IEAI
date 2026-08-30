-- ============================================================
-- wdfex 独立卡密验证系统（WindUI版）
-- 卡密格式：wdfex-XXXX-XXXX
-- ============================================================

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()

-- ===== 配置 =====
local CONFIG = {
    -- 有效卡密列表（生产环境建议从服务器获取）
    VALID_KEYS = {
        "wdfex-a1b2-c3d4",
        "wdfex-9f8e-7d6c",
        "wdfex-5g4h-3j2k",
        "wdfex-1q2w-3e4r",
        "wdfex-6t7y-8u9i",
        "wdfex-4f5g-6h7j",
        "wdfex-8k9l-0q1w",
    },
    SAVE_KEY = "wdfex_used_keys",
}

-- ===== 工具函数 =====
local function NormalizeKey(key)
    return key:lower()
end

local function IsKeyFormatValid(key)
    if type(key) ~= "string" then return false end
    key = key:lower()
    return string.match(key, "^wdfex%-[%w][%w][%w][%w]%-[%w][%w][%w][%w]$") ~= nil
end

local function IsKeyValid(key)
    key = NormalizeKey(key)
    for _, valid in ipairs(CONFIG.VALID_KEYS) do
        if NormalizeKey(valid) == key then
            return true
        end
    end
    return false
end

-- ===== 存储已使用卡密 =====
local function GetUsedKeys()
    local success, result = pcall(function()
        return getgenv()._wdfex_used_keys
    end)
    if success and result then
        return result
    end
    return {}
end

local function SaveUsedKeys(keys)
    getgenv()._wdfex_used_keys = keys
end

local function IsKeyUsed(key)
    key = NormalizeKey(key)
    local used = GetUsedKeys()
    for _, k in ipairs(used) do
        if NormalizeKey(k) == key then
            return true
        end
    end
    return false
end

local function MarkKeyUsed(key)
    key = NormalizeKey(key)
    local used = GetUsedKeys()
    table.insert(used, key)
    SaveUsedKeys(used)
end

-- ===== 验证主函数 =====
local function ValidateKey(key)
    if not key or key == "" then
        return false, "请输入卡密"
    end
    if not IsKeyFormatValid(key) then
        return false, "卡密格式错误，正确格式：wdfex-XXXX-XXXX"
    end
    if not IsKeyValid(key) then
        return false, "卡密无效"
    end
    if IsKeyUsed(key) then
        return false, "卡密已被使用"
    end
    return true, "验证成功"
end

-- ===== 显示卡密验证UI =====
local function ShowKeyUI(onVerified)
    WindUI:Popup({
        Title = "wdfex 卡密验证",
        IconThemed = true,
        Content = "请输入您的卡密以激活脚本\n\n格式：wdfex-XXXX-XXXX",
        Input = {
            Title = "卡密",
            Placeholder = "wdfex-XXXX-XXXX",
        },
        Buttons = {
            {
                Title = "取消",
                Variant = "Secondary",
                Callback = function()
                    WindUI:Notify({
                        Title = "已取消",
                        Content = "验证已取消",
                        Duration = 2,
                    })
                end,
            },
            {
                Title = "验证",
                Icon = "check",
                Variant = "Primary",
                Callback = function(input)
                    if not input or input == "" then
                        WindUI:Notify({
                            Title = "验证失败",
                            Content = "请输入卡密",
                            Duration = 3,
                        })
                        return
                    end
                    
                    local success, msg = ValidateKey(input)
                    if success then
                        MarkKeyUsed(input)
                        WindUI:Notify({
                            Title = "验证成功",
                            Content = "卡密验证通过！正在加载脚本...",
                            Duration = 3,
                        })
                        task.wait(1)
                        if onVerified then
                            onVerified()
                        end
                    else
                        WindUI:Notify({
                            Title = "验证失败",
                            Content = msg,
                            Duration = 3,
                        })
                    end
                end
            },
        }
    })
end

-- ============================================================
-- 导出函数
-- ============================================================
local wdfex = {
    -- 显示验证UI
    Verify = function(onVerified)
        ShowKeyUI(onVerified)
    end,
    
    -- 纯验证（不显示UI）
    CheckKey = function(key)
        return ValidateKey(key)
    end,
    
    -- 手动标记已使用
    UseKey = function(key)
        if IsKeyValid(key) and not IsKeyUsed(key) then
            MarkKeyUsed(key)
            return true
        end
        return false
    end,
    
    -- 获取已使用列表
    GetUsedKeys = GetUsedKeys,
    
    -- 重置所有已使用（调试用）
    ResetAllKeys = function()
        SaveUsedKeys({})
        WindUI:Notify({
            Title = "重置完成",
            Content = "所有卡密使用记录已清除",
            Duration = 2,
        })
    end,
}

-- ============================================================
-- 使用示例（直接运行此脚本时生效）
-- ============================================================
-- 如果直接运行此脚本，显示验证界面
if not getgenv()._wdfex_skip_verify then
    wdfex.Verify(function()
        WindUI:Notify({
            Title = "✅ 验证通过",
            Content = "欢迎使用 wdfex-Hub！",
            Duration = 3,
        })
        -- 在这里加载你的主脚本
        -- loadstring(game:HttpGet("你的主脚本URL"))()
    end)
end

-- 返回模块
return wdfex