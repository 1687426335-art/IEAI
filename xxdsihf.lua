---Kenny脚本群1019547871（五百人群）
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/385j8888/ZOUMAGUIX/refs/heads/main/ProtectUI.lua"))()
local lp = game.Players.LocalPlayer
local Mouse = lp:GetMouse()
--local lp = gs("Players").LocalPlayer
local pos = lp.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
local ME = game.Players.LocalPlayer.Character.HumanoidRootPart
local Mouse = game:GetService('Players').LocalPlayer:GetMouse()
--local CurrentSlot = game.Players.LocalPlayer:WaitForChild("CurrentSaveSlot").Value
local ScriptLoadOrSave = false
--local CurrentlySavingOrLoading = game.Players.LocalPlayer:WaitForChild("CurrentlySavingOrLoading")
local mouse = game.Players.LocalPlayer:GetMouse()
local tp = function(p)
    lp.Character:PivotTo(p)
end
game:GetService("StarterGui"):SetCore("SendNotification", { 
	Title = "走马观花X";
	Text = "脚本永远免费";
	Icon = "rbxthumb://type=Asset&id=17366451283&w=150&h=150";
Button1 = "明白";
Duration = 15})
game:GetService("StarterGui"):SetCore("SendNotification", { 
	Title = "走马观花X";
	Text = "感谢支持走马观花X";
	Icon = "rbxthumb://type=Asset&id=17366451283&w=150&h=150";
Button1 = "明白";
Duration = 15})
local window = library:new("走马观花X-战争大亨","light")

local creds = window:Tab("基本信息")

local bin = creds:section("信息",true)

    bin:Label("你的注入器:"..identifyexecutor())
    bin:Label("作者:小爱同学")
    bin:Label("走马观花X交流群:947178829")

local credits = creds:section("UI设置",true)

    credits:Button("摧毁UI",function()
        game:GetService("CoreGui")["frosty"]:Destroy()
    end)

    credits:Toggle("彩虹UI", "", false, function(state)
        if state then
        game:GetService("CoreGui")["frosty"].Main.Style = "DropShadow"
        else
            game:GetService("CoreGui")["frosty"].Main.Style = "Custom"
        end
    end)
local tpp = window:Tab("传送")
local tpp = tpp:section("传送",true)
tpp:Button("初始化全图",function()
ME.CFrame = CFrame.new(-954, 479, -2196)
wait(1)
ME.CFrame = CFrame.new(-1526, 439, -991)
wait(1)
ME.CFrame = CFrame.new(-1616, 326, 523)
wait(1)
ME.CFrame = CFrame.new(-846, 314, 1794)
wait(1)
ME.CFrame = CFrame.new(781, 292, 1885)
wait(1)
ME.CFrame = CFrame.new(2021, 199, 822)
wait(1)
ME.CFrame = CFrame.new(1768, 254, -492)
wait(1)
ME.CFrame = CFrame.new(550, 221, -1515)
wait(1)
ME.CFrame = CFrame.new(61, 216, 187)
wait(1)
ME.CFrame = CFrame.new(-954, 479, -2196)
wait(1)
ME.CFrame = CFrame.new(-1526, 439, -991)
wait(1)
ME.CFrame = CFrame.new(-1616, 326, 523)
wait(1)
ME.CFrame = CFrame.new(-846, 314, 1794)
wait(1)
ME.CFrame = CFrame.new(781, 292, 1885)
wait(1)
ME.CFrame = CFrame.new(2021, 199, 822)
wait(1)
ME.CFrame = CFrame.new(1768, 254, -492)
wait(1)
ME.CFrame = CFrame.new(550, 221, -1515)
wait(1)
ME.CFrame = CFrame.new(61, 216, 187)
end)
tpp:Button("传送到油桶旁",function()
    for i,v in next,workspace:GetDescendants() do
   if v.Name=='Barrel Template' and v:FindFirstChildOfClass('Part')  then
    tp(v:FindFirstChildOfClass('Part').CFrame)
   end
    end
end)
tpp:Button("回到自己基地",function()
    for i,c in next,workspace.Tycoon.Tycoons:GetChildren() do
        if c:FindFirstChild("Owner") and c.Owner.Value ==lp then
            for i,v in next,c:GetDescendants() do
                if v:IsA('Part') then
                tp(v.CFrame)
                end
            end
        end
    end
end)
tpp:Button("自动占点",function()
local oldpos=lp.Character.HumanoidRootPart.CFrame
local tycoon
for i,c in next,workspace.Tycoon.Tycoons:GetChildren() do
    if c:FindFirstChild("Owner") and c.Owner.Value ==lp then
       tycoon=c.Name
    end
    end

    if tostring( workspace["Game Systems"].CapturePoint['Captured Team'].Value)~=tycoon then
        repeat game:GetService("RunService").Stepped:wait()
    
            tp(CFrame.new(70.7639999, 44.887001, 189)+Vector3.new(0,5,0))   
           until tostring( workspace["Game Systems"].CapturePoint['Captured Team'].Value)==tycoon
    end
wait(12)
tp(oldpos)
end)
local gn = window:Tab("主要功能")
local gn = gn:section("功能",true)
gn:Label("子弹数量需要设置好后再拿起枪才生效")
gn:Textbox("子弹数量", "子弹数量", "请输入数字", function(value)
--print(value)
_AmmoNumber = value
end)
gn:Button("设置所有枪子弹数量",function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local ACS_Guns = ReplicatedStorage:FindFirstChild("Configurations"):FindFirstChild("ACS_Guns")

  if ACS_Guns then
    for _, descendant in ipairs(ACS_Guns:GetDescendants()) do
        if descendant.Name == "Ammo" and (descendant:IsA("IntValue") or descendant:IsA("NumberValue")) then
            descendant.Value = _AmmoNumber
        end
    end
  end
end)
--gn:Button("超射速",function()
--local ReplicatedStorage = game:GetService("ReplicatedStorage")

--local function waitForPath(path)
--    local current = ReplicatedStorage
--    for _, name in ipairs(path) do
--        current = current:WaitForChild(name)
--    end
--    return current
--end

--local function modifyFireRates(parent)
--    for _, child in ipairs(parent:GetChildren()) do
--        if child:IsA("ModuleScript") and child.Name == "Settings" then
           
--            local success, moduleTable = pcall(function()
--                return require(child)
--            end)
            
--            if success and type(moduleTable) == "table" then
--                if moduleTable.FireRate ~= nil then
--                    moduleTable.FireRate = 999999
--                end
--            end
--        else
            
--            modifyFireRates(child)
--        end
--    end
--end
--local startTime = os.clock()
--local rootPath = {"Configurations", "ACS_Guns"}

--pcall(function()
--    local root = waitForPath(rootPath)
--    modifyFireRates(root)
--end)
--end)
--gn:Button("子弹速度变快(子弹无下坠)",function()
--    for i,v in next,lp.Backpack:GetDescendants() do
--    if v.Name=='RocketSettings' then
--        require(v).velocity=10000
--    end
--end
--end)
--gn:Button("超远打击距离",function()
--    for i,v in next,lp.Backpack:GetDescendants() do
--    if v.Name=='RocketSettings' then
--        require(v).MinDistance=100000
--    end
--end
--end)
gn:Button("武器全自动",function()
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function waitForPath(path)
    local current = ReplicatedStorage
    for _, name in ipairs(path) do
        current = current:WaitForChild(name)
    end
    return current
end

local function modifyFireRates2(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("ModuleScript") and child.Name == "Settings" then
            local success, moduleTable = pcall(function()
                return require(child)
            end)
            
            if success and type(moduleTable) == "table" then
              --  if moduleTable.Mode ~= nil then
                    moduleTable.FireModes.Auto=true
                    moduleTable.Mode="Auto"
             --   end
            end
        else
            modifyFireRates2(child)
        end
    end
end
local startTime = os.clock()
local rootPath = {"Configurations", "ACS_Guns"}

pcall(function()
    local root = waitForPath(rootPath)
    modifyFireRates2(root)
end)
end)
gn:Button("子弹，炮弹追踪(无法关闭，不分敌我)",function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxiaoxin222/78scripts/refs/heads/main/%E4%BD%A0%E7%8C%9C%E7%8C%9C%E6%98%AF%E5%95%A5.lua"))()
end)
tpp:Button("传送到一个零件箱子",function()
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local originalCFrame = hrp.CFrame
local cratesFolder = Workspace:FindFirstChild("Game Systems") and Workspace["Game Systems"]:FindFirstChild("Crate Workspace")

local farthestCrate = nil
local farthestDistance = 0

for _, crate in pairs(cratesFolder:GetChildren()) do
    if crate.Name == "Tank Crate" and crate:IsA("BasePart") then
        local distance = (crate.Position - hrp.Position).Magnitude
        if distance > farthestDistance then
            farthestDistance = distance
            farthestCrate = crate
        end
    end
end


if farthestCrate then
    hrp.CFrame = farthestCrate.CFrame
    --autoInteract(farthestCrate)
    
end
end)
gn:Button("删除所有大亨(慎点)",function()
    local ty = game:GetService('Workspace')['Tycoon'].Tycoons;
    ty:Destroy()
end)
local esp = window:Tab("绘制")
local esp = esp:section("绘制",true)
local che = false
esp:Toggle("透视车辆", "", false, function(state)
    che = state  -- 同步阀门状态
    
    if state then
        --spawn(function()  -- 使用独立协程
           while che do  -- 检测阀门状态
                  local vehicleWorkspace = workspace["Game Systems"]["Vehicle Workspace"]

             for _, model in ipairs(vehicleWorkspace:GetChildren()) do
                 if model:IsA("Model") then
                     local existingGui = model:FindFirstChild("ModelNameBillboard")
        
                     if not existingGui and che==true then
                         local billboard = Instance.new("BillboardGui")
                         billboard.Name = "ModelNameBillboard"
                         billboard.Adornee = model
                         billboard.Size = UDim2.new(5, 0, 1, 0)
                         billboard.StudsOffset = Vector3.new(0, 3, 0)
                         billboard.AlwaysOnTop = true
                         billboard.LightInfluence = 0
                         billboard.MaxDistance = 10000000
            
                         local textLabel = Instance.new("TextLabel")
                         textLabel.Size = UDim2.new(1, 0, 1, 0)
                         textLabel.BackgroundTransparency = 1
                         textLabel.Text = model.Name
                         textLabel.Font = Enum.Font.SourceSansBold
                         textLabel.TextSize = 24
                         textLabel.TextColor3 = Color3.new(1, 0, 0)
                         textLabel.TextStrokeTransparency = 0.5
            
                         textLabel.Parent = billboard
                         billboard.Parent = model
                     end
                 end
             end
             wait(1)
           end
        --end)
    else
             local vehicleWorkspace = workspace["Game Systems"]["Vehicle Workspace"]

             for _, model in ipairs(vehicleWorkspace:GetChildren()) do
                 local billboard = model:FindFirstChild("ModelNameBillboard")
                 if billboard then
                     billboard:Destroy()
                 end
             end
    end
end)
local tank = false
esp:Toggle("透视坦克", "", false, function(state)
    tank = state  -- 同步阀门状态
    
    if state then
        --spawn(function()  -- 使用独立协程
           while tank do  -- 检测阀门状态
                  local tkWorkspace = workspace["Game Systems"]["Tank Workspace"]

             for _, model in ipairs(tkWorkspace:GetChildren()) do
                 if model:IsA("Model") then
                     local existingGui = model:FindFirstChild("ModelNameBillboard")
        
                     if not existingGui and tank==true then
                         local billboard = Instance.new("BillboardGui")
                         billboard.Name = "ModelNameBillboard"
                         billboard.Adornee = model
                         billboard.Size = UDim2.new(5, 0, 1, 0)
                         billboard.StudsOffset = Vector3.new(0, 3, 0)
                         billboard.AlwaysOnTop = true
                         billboard.LightInfluence = 0
                         billboard.MaxDistance = 10000000
            
                         local textLabel = Instance.new("TextLabel")
                         textLabel.Size = UDim2.new(1, 0, 1, 0)
                         textLabel.BackgroundTransparency = 1
                         textLabel.Text = model.Name
                         textLabel.Font = Enum.Font.SourceSansBold
                         textLabel.TextSize = 24
                         textLabel.TextColor3 = Color3.new(1, 0, 0)
                         textLabel.TextStrokeTransparency = 0.5
            
                         textLabel.Parent = billboard
                         billboard.Parent = model
                     end
                 end
             end
             wait(1)
           end
        --end)
    else
             local tkWorkspace = workspace["Game Systems"]["Tank Workspace"]

             for _, model in ipairs(tkWorkspace:GetChildren()) do
                 local billboard = model:FindFirstChild("ModelNameBillboard")
                 if billboard then
                     billboard:Destroy()
                 end
             end
    end
end)
local fj = false
esp:Toggle("透视飞机", "", false, function(state)
    fj = state  -- 同步阀门状态
    
    if state then
        --spawn(function()  -- 使用独立协程
           while fj do  -- 检测阀门状态
                  local fjWorkspace = workspace["Game Systems"]["Plane Workspace"]

             for _, model in ipairs(fjWorkspace:GetChildren()) do
                 if model:IsA("Model") then
                     local existingGui = model:FindFirstChild("ModelNameBillboard")
        
                     if not existingGui and fj==true then
                         local billboard = Instance.new("BillboardGui")
                         billboard.Name = "ModelNameBillboard"
                         billboard.Adornee = model
                         billboard.Size = UDim2.new(5, 0, 1, 0)
                         billboard.StudsOffset = Vector3.new(0, 3, 0)
                         billboard.AlwaysOnTop = true
                         billboard.LightInfluence = 0
                         billboard.MaxDistance = 10000000
            
                         local textLabel = Instance.new("TextLabel")
                         textLabel.Size = UDim2.new(1, 0, 1, 0)
                         textLabel.BackgroundTransparency = 1
                         textLabel.Text = model.Name
                         textLabel.Font = Enum.Font.SourceSansBold
                         textLabel.TextSize = 24
                         textLabel.TextColor3 = Color3.new(1, 0, 0)
                         textLabel.TextStrokeTransparency = 0.5
            
                         textLabel.Parent = billboard
                         billboard.Parent = model
                     end
                 end
             end
             wait(1)
           end
        --end)
    else
             local fjWorkspace = workspace["Game Systems"]["Plane Workspace"]

             for _, model in ipairs(fjWorkspace:GetChildren()) do
                 local billboard = model:FindFirstChild("ModelNameBillboard")
                 if billboard then
                     billboard:Destroy()
                 end
             end
    end
end)
local zsj = false
esp:Toggle("透视直升机", "", false, function(state)
    zsj = state  -- 同步阀门状态
    
    if state then
        --spawn(function()  -- 使用独立协程
           while zsj do  -- 检测阀门状态
                  local zsjWorkspace = workspace["Game Systems"]["Helicopter Workspace"]

             for _, model in ipairs(zsjWorkspace:GetChildren()) do
                 if model:IsA("Model") then
                     local existingGui = model:FindFirstChild("ModelNameBillboard")
        
                     if not existingGui and zsj==true then
                         local billboard = Instance.new("BillboardGui")
                         billboard.Name = "ModelNameBillboard"
                         billboard.Adornee = model
                         billboard.Size = UDim2.new(5, 0, 1, 0)
                         billboard.StudsOffset = Vector3.new(0, 3, 0)
                         billboard.AlwaysOnTop = true
                         billboard.LightInfluence = 0
                         billboard.MaxDistance = 10000000
            
                         local textLabel = Instance.new("TextLabel")
                         textLabel.Size = UDim2.new(1, 0, 1, 0)
                         textLabel.BackgroundTransparency = 1
                         textLabel.Text = model.Name
                         textLabel.Font = Enum.Font.SourceSansBold
                         textLabel.TextSize = 24
                         textLabel.TextColor3 = Color3.new(1, 0, 0)
                         textLabel.TextStrokeTransparency = 0.5
            
                         textLabel.Parent = billboard
                         billboard.Parent = model
                     end
                 end
             end
             wait(1)
           end
        --end)
    else
             local zsjWorkspace = workspace["Game Systems"]["Helicopter Workspace"]

             for _, model in ipairs(vehicleWorkspace:GetChildren()) do
                 local billboard = model:FindFirstChild("ModelNameBillboard")
                 if billboard then
                     billboard:Destroy()
                 end
             end
    end
end)
local c = false
esp:Toggle("透视船", "", false, function(state)
    c = state  -- 同步阀门状态
    
    if state then
        --spawn(function()  -- 使用独立协程
           while c do  -- 检测阀门状态
                  local cWorkspace = workspace["Game Systems"]["Boat Workspace"]

             for _, model in ipairs(cWorkspace:GetChildren()) do
                 if model:IsA("Model") then
                     local existingGui = model:FindFirstChild("ModelNameBillboard")
        
                     if not existingGui and c==true then
                         local billboard = Instance.new("BillboardGui")
                         billboard.Name = "ModelNameBillboard"
                         billboard.Adornee = model
                         billboard.Size = UDim2.new(5, 0, 1, 0)
                         billboard.StudsOffset = Vector3.new(0, 3, 0)
                         billboard.AlwaysOnTop = true
                         billboard.LightInfluence = 0
                         billboard.MaxDistance = 10000000
            
                         local textLabel = Instance.new("TextLabel")
                         textLabel.Size = UDim2.new(1, 0, 1, 0)
                         textLabel.BackgroundTransparency = 1
                         textLabel.Text = model.Name
                         textLabel.Font = Enum.Font.SourceSansBold
                         textLabel.TextSize = 24
                         textLabel.TextColor3 = Color3.new(1, 0, 0)
                         textLabel.TextStrokeTransparency = 0.5
            
                         textLabel.Parent = billboard
                         billboard.Parent = model
                     end
                 end
             end
             wait(1)
           end
        --end)
    else
             local cWorkspace = workspace["Game Systems"]["Boat Workspace"]

             for _, model in ipairs(cWorkspace:GetChildren()) do
                 local billboard = model:FindFirstChild("ModelNameBillboard")
                 if billboard then
                     billboard:Destroy()
                 end
             end
    end
end)
local wrj = false
esp:Toggle("透视无人机", "", false, function(state)
    wrj = state  -- 同步阀门状态
    
    if state then
        --spawn(function()  -- 使用独立协程
           while wrj do  -- 检测阀门状态
                  local wrjWorkspace = workspace["Game Systems"]["RC Workspace"]

             for _, model in ipairs(wrjWorkspace:GetChildren()) do
                 if model:IsA("Model") then
                     local existingGui = model:FindFirstChild("ModelNameBillboard")
        
                     if not existingGui and wrj==true then
                         local billboard = Instance.new("BillboardGui")
                         billboard.Name = "ModelNameBillboard"
                         billboard.Adornee = model
                         billboard.Size = UDim2.new(5, 0, 1, 0)
                         billboard.StudsOffset = Vector3.new(0, 3, 0)
                         billboard.AlwaysOnTop = true
                         billboard.LightInfluence = 0
                         billboard.MaxDistance = 10000000
            
                         local textLabel = Instance.new("TextLabel")
                         textLabel.Size = UDim2.new(1, 0, 1, 0)
                         textLabel.BackgroundTransparency = 1
                         textLabel.Text = model.Name
                         textLabel.Font = Enum.Font.SourceSansBold
                         textLabel.TextSize = 24
                         textLabel.TextColor3 = Color3.new(1, 0, 0)
                         textLabel.TextStrokeTransparency = 0.5
            
                         textLabel.Parent = billboard
                         billboard.Parent = model
                     end
                 end
             end
             wait(1)
           end
        --end)
    else
             local wrjWorkspace = workspace["Game Systems"]["RC Workspace"]

             for _, model in ipairs(wrjWorkspace:GetChildren()) do
                 local billboard = model:FindFirstChild("ModelNameBillboard")
                 if billboard then
                     billboard:Destroy()
                 end
             end
    end
end)