local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local up = Instance.new("TextButton")
local down = Instance.new("TextButton")
local onof = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local plus = Instance.new("TextButton")
local speed = Instance.new("TextLabel")
local mine = Instance.new("TextButton")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local mini2 = Instance.new("TextButton")

-- 新增：青色轻微透明弹窗（脚本启动时显示）
local popupFrame = Instance.new("Frame")
local popupTitle = Instance.new("TextLabel")

main.Name = "main"
main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

-- 弹窗配置：青色轻微透明背景、居中显示
popupFrame.Name = "PopupFrame"
popupFrame.Parent = main
popupFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- 青色背景
popupFrame.BackgroundTransparency = 0.5 -- 轻微透明（70%显示）
popupFrame.Size = UDim2.new(0, 220, 0, 80) -- 弹窗尺寸
popupFrame.Position = UDim2.new(0.5, -110, 0.2, 0) -- 水平居中、顶部偏下
popupFrame.BorderSizePixel = 0 -- 隐藏边框
popupFrame.ZIndex = 10 -- 层级高于功能面板

-- 弹窗文字配置（白色文字适配青色背景，增强辨识度）
popupTitle.Name = "PopupTitle"
popupTitle.Parent = popupFrame
popupTitle.BackgroundTransparency = 1 -- 文本背景透明
popupTitle.Size = UDim2.new(1, 0, 1, 0) -- 文本占满弹窗
popupTitle.Text = "wdfex出品飞行脚本" -- 弹窗内容
popupTitle.TextColor3 = Color3.fromRGB(255, 0, 0) -- 白色文字
popupTitle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0) -- 黑色描边
popupTitle.TextStrokeTransparency = 0.5 -- 描边半透明
popupTitle.TextSize = 24 -- 文字大小
popupTitle.TextScaled = false -- 关闭自动缩放
popupTitle.TextXAlignment = Enum.TextXAlignment.Center -- 水平居中
popupTitle.TextYAlignment = Enum.TextYAlignment.Center -- 垂直居中

-- 弹窗2秒后缓慢消失逻辑
spawn(function()
    wait(2) -- 延迟2秒
    local fadeDuration = 0.8 -- 淡出动画时长（0.8秒）
    local startTime = tick()
    -- 渐变淡出：背景和文字同步透明化
    while tick() - startTime < fadeDuration do
        local progress = (tick() - startTime) / fadeDuration
        popupFrame.BackgroundTransparency = 0.3 + (1 - 0.3) * progress -- 从0.3过渡到1
        popupTitle.TextTransparency = 0 + 1 * progress -- 从0过渡到1
        popupTitle.TextStrokeTransparency = 0.5 + 0.5 * progress -- 描边同步淡出
        wait() -- 逐帧更新
    end
    popupFrame.Visible = false -- 动画结束后隐藏
end)

Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- 轻微透明绿色面板（原白色）
Frame.BackgroundTransparency = 0.5 -- 面板半透明（70%显示）
Frame.BorderColor3 = Color3.fromRGB(100, 200, 100) -- 深绿色边框，适配透明背景
Frame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
Frame.Size = UDim2.new(0, 190, 0, 57)

up.Name = "up"
up.Parent = Frame
up.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- 轻微透明绿色按钮（原白色）
up.BackgroundTransparency = 0.5 -- 按钮半透明
up.Size = UDim2.new(0, 44, 0, 28)
up.Font = Enum.Font.SourceSans
up.Text = "上升"
up.TextColor3 = Color3.fromRGB(255, 215, 0) -- 蓝色文字（保持不变）
up.TextSize = 14.000

down.Name = "down"
down.Parent = Frame
down.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- 轻微透明绿色按钮（原白色）
down.BackgroundTransparency = 0.5 -- 按钮半透明
down.Position = UDim2.new(0, 0, 0.491228074, 0)
down.Size = UDim2.new(0, 44, 0, 28)
down.Font = Enum.Font.SourceSans
down.Text = "下降"
down.TextColor3 = Color3.fromRGB(255, 215, 0) -- 蓝色文字（保持不变）
down.TextSize = 14.000

onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- 轻微透明绿色按钮（原白色）
onof.BackgroundTransparency = 0.5 -- 按钮半透明
onof.Position = UDim2.new(0.702823281, 0, 0.491228074, 0)
onof.Size = UDim2.new(0, 56, 0, 28)
onof.Font = Enum.Font.SourceSans
onof.Text = "飞行"
onof.TextColor3 = Color3.fromRGB(255, 215, 0) -- 蓝色文字（保持不变）
onof.TextSize = 14.000

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- 轻微透明绿色标签（原白色）
TextLabel.BackgroundTransparency = 0.6 -- 标签半透明
TextLabel.Position = UDim2.new(0.469327301, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 100, 0, 28)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "wdfex飞行"
TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- 改为红色文字
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

plus.Name = "plus"
plus.Parent = Frame
plus.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- 轻微透明绿色按钮（原白色）
plus.BackgroundTransparency = 0.5 -- 按钮半透明
plus.Position = UDim2.new(0.231578946, 0, 0, 0)
plus.Size = UDim2.new(0, 45, 0, 28)
plus.Font = Enum.Font.SourceSans
plus.Text = "速度+1"
plus.TextColor3 = Color3.fromRGB(255, 215, 0) -- 蓝色文字（保持不变）
plus.TextScaled = true
plus.TextSize = 14.000
plus.TextWrapped = true

speed.Name = "speed"
speed.Parent = Frame
speed.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- 轻微透明绿色标签（原白色）
speed.BackgroundTransparency = 0.5 -- 标签半透明
speed.Position = UDim2.new(0.468421042, 0, 0.491228074, 0)
speed.Size = UDim2.new(0, 44, 0, 28)
speed.Font = Enum.Font.SourceSans
speed.Text = "1"
speed.TextColor3 = Color3.fromRGB(255, 215, 0) -- 蓝色文字（保持不变）
speed.TextScaled = true
speed.TextSize = 14.000
speed.TextWrapped = true

mine.Name = "mine"
mine.Parent = Frame
mine.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- 轻微透明绿色按钮（原白色）
mine.BackgroundTransparency = 0.5 -- 按钮半透明
mine.Position = UDim2.new(0.231578946, 0, 0.491228074, 0)
mine.Size = UDim2.new(0, 45, 0, 29)
mine.Font = Enum.Font.SourceSans
mine.Text = "速度-1"
mine.TextColor3 = Color3.fromRGB(255, 215, 0) -- 蓝色文字（保持不变）
mine.TextScaled = true
mine.TextSize = 14.000
mine.TextWrapped = true

closebutton.Name = "Close"
closebutton.Parent = main.Frame
closebutton.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- 轻微透明绿色按钮（原白色）
closebutton.BackgroundTransparency = 0.5 -- 按钮半透明
closebutton.Font = "SourceSans"
closebutton.Size = UDim2.new(0, 45, 0, 28)
closebutton.Text = "关闭"
closebutton.TextColor3 = Color3.fromRGB(255, 215, 0) -- 蓝色文字（保持不变）
closebutton.TextSize = 30
closebutton.Position =  UDim2.new(0, 0, -1, 27)

mini.Name = "minimize"
mini.Parent = main.Frame
mini.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- 轻微透明绿色按钮（原白色）
mini.BackgroundTransparency = 0.5 -- 按钮半透明
mini.Font = "SourceSans"
mini.Size = UDim2.new(0, 45, 0, 28)
mini.Text = "隐藏"
mini.TextColor3 = Color3.fromRGB(255, 215, 0) -- 蓝色文字（保持不变）
mini.TextSize = 30
mini.Position = UDim2.new(0, 44, -1, 27)

mini2.Name = "minimize2"
mini2.Parent = main.Frame
mini2.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- 轻微透明绿色按钮（原白色）
mini2.BackgroundTransparency = 0.5 -- 按钮半透明
mini2.Font = "SourceSans"
mini2.Size = UDim2.new(0, 45, 0, 28)
mini2.Text = "+"
mini2.TextColor3 = Color3.fromRGB(255, 215, 0) -- 蓝色文字（保持不变）
mini2.TextSize = 40
mini2.Position = UDim2.new(0, 44, -1, 57)
mini2.Visible = false

-- 其余代码保持不变...
speeds = 1

local speaker = game:GetService("Players").LocalPlayer

local chr = game.Players.LocalPlayer.Character
local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")

nowe = false

game:GetService("StarterGui"):SetCore("SendNotification", { 
	Title = "Fly GUI V3";
	Text = "By me_ozone and Quandale The Dinglish XII#3550";
	Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150"})
Duration = 5;

Frame.Active = true -- main = gui
Frame.Draggable = true

onof.MouseButton1Down:connect(function()

	if nowe == true then
		nowe = false

		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
		speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
	else 
		nowe = true



		for i = 1, speeds do
			spawn(function()

				local hb = game:GetService("RunService").Heartbeat	


				tpwalking = true
				local chr = game.Players.LocalPlayer.Character
				local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
				while tpwalking and hb:Wait() and chr and hum and hum.Parent do
					if hum.MoveDirection.Magnitude > 0 then
						chr:TranslateBy(hum.MoveDirection)
					end
				end

			end)
		end
		game.Players.LocalPlayer.Character.Animate.Disabled = true
		local Char = game.Players.LocalPlayer.Character
		local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")

		for i,v in next, Hum:GetPlayingAnimationTracks() do
			v:AdjustSpeed(0)
		end
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
		speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
	end




	if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then



		local plr = game.Players.LocalPlayer
		local torso = plr.Character.Torso
		local flying = true
		local deb = true
		local ctrl = {f = 0, b = 0, l = 0, r = 0}
		local lastctrl = {f = 0, b = 0, l = 0, r = 0}
		local maxspeed = 50
		local speed = 0


		local bg = Instance.new("BodyGyro", torso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = torso.CFrame
		local bv = Instance.new("BodyVelocity", torso)
		bv.velocity = Vector3.new(0,0.1,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		if nowe == true then
			plr.Character.Humanoid.PlatformStand = true
		end
		while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
			game:GetService("RunService").RenderStepped:Wait()

			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed = speed+.5+(speed/maxspeed)
				if speed > maxspeed then
					speed = maxspeed
				end
			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
				speed = speed-1
				if speed < 0 then
					speed = 0
				end
			end
			if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
			else
				bv.velocity = Vector3.new(0,0,0)
			end
			--	game.Players.LocalPlayer.Character.Animate.Disabled = true
			bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
		end
		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastctrl = {f = 0, b = 0, l = 0, r = 0}
		speed = 0
		bg:Destroy()
		bv:Destroy()
		plr.Character.Humanoid.PlatformStand = false
		game.Players.LocalPlayer.Character.Animate.Disabled = false
		tpwalking = false




	else
		local plr = game.Players.LocalPlayer
		local UpperTorso = plr.Character.UpperTorso
		local flying = true
		local deb = true
		local ctrl = {f = 0, b = 0, l = 0, r = 0}
		local lastctrl = {f = 0, b = 0, l = 0, r = 0}
		local maxspeed = 50
		local speed = 0


		local bg = Instance.new("BodyGyro", UpperTorso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = UpperTorso.CFrame
		local bv = Instance.new("BodyVelocity", UpperTorso)
		bv.velocity = Vector3.new(0,0.1,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		if nowe == true then
			plr.Character.Humanoid.PlatformStand = true
		end
		while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
			wait()

			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed = speed+.5+(speed/maxspeed)
				if speed > maxspeed then
					speed = maxspeed
				end
			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
				speed = speed-1
				if speed < 0 then
					speed = 0
				end
			end
			if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
			else
				bv.velocity = Vector3.new(0,0,0)
			end

			bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
		end
		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastctrl = {f = 0, b = 0, l = 0, r = 0}
		speed = 0
		bg:Destroy()
		bv:Destroy()
		plr.Character.Humanoid.PlatformStand = false
		game.Players.LocalPlayer.Character.Animate.Disabled = false
		tpwalking = false



	end





end)

local tis

up.MouseButton1Down:connect(function()
	tis = up.MouseEnter:connect(function()
		while tis do
			wait()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,1,0)
		end
	end)
end)

up.MouseLeave:connect(function()
	if tis then
		tis:Disconnect()
		tis = nil
	end
end)

local dis

down.MouseButton1Down:connect(function()
	dis = down.MouseEnter:connect(function()
		while dis do
			wait()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,-1,0)
		end
	end)
end)

down.MouseLeave:connect(function()
	if dis then
		dis:Disconnect()
		dis = nil
	end
end)


game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
	wait(0.7)
	game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
	game.Players.LocalPlayer.Character.Animate.Disabled = false

end)


plus.MouseButton1Down:connect(function()
	speeds = speeds + 1
	speed.Text = speeds
	if nowe == true then


		tpwalking = false
		for i = 1, speeds do
			spawn(function()

				local hb = game:GetService("RunService").Heartbeat	


				tpwalking = true
				local chr = game.Players.LocalPlayer.Character
				local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
				while tpwalking and hb:Wait() and chr and hum and hum.Parent do
					if hum.MoveDirection.Magnitude > 0 then
						chr:TranslateBy(hum.MoveDirection)
					end
				end

			end)
		end
	end
end)
mine.MouseButton1Down:connect(function()
	if speeds == 1 then
		speed.Text = 'cannot be less than 1'
		wait(1)
		speed.Text = speeds
	else
		speeds = speeds - 1
		speed.Text = speeds
		if nowe == true then
			tpwalking = false
			for i = 1, speeds do
				spawn(function()

					local hb = game:GetService("RunService").Heartbeat	


					tpwalking = true
					local chr = game.Players.LocalPlayer.Character
					local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
					while tpwalking and hb:Wait() and chr and hum and hum.Parent do
						if hum.MoveDirection.Magnitude > 0 then
							chr:TranslateBy(hum.MoveDirection)
						end
					end

				end)
			end
		end
	end
end)

closebutton.MouseButton1Click:Connect(function()
	main:Destroy()
end)

mini.MouseButton1Click:Connect(function()
	up.Visible = false
	down.Visible = false
	onof.Visible = false
	plus.Visible = false
	speed.Visible = false
	mine.Visible = false
	mini.Visible = false
	mini2.Visible = true
	main.Frame.BackgroundTransparency = 1
	closebutton.Position =  UDim2.new(0, 0, -1, 57)
	-- 隐藏面板时同步隐藏弹窗（若未消失）
	if popupFrame.Visible then
		popupFrame.Visible = false
	end
end)

mini2.MouseButton1Click:Connect(function()
	up.Visible = true
	down.Visible = true
	onof.Visible = true
	plus.Visible = true
	speed.Visible = true
	mine.Visible = true
	mini.Visible = true
	mini2.Visible = false
	main.Frame.BackgroundTransparency = 0 
	closebutton.Position =  UDim2.new(0, 0, -1, 27)
end)

local Players = game:GetService("Players") -- 获取玩家服务
local wowPlayer = Players.LocalPlayer -- 获取本地玩家（自己）
local wowCharacter = wowPlayer.Character or wowPlayer.CharacterAdded:Wait() -- 获取玩家角色，若未加载则等待加载

if not wowCharacter:FindFirstChild("HumanoidRootPart") then -- 检查角色是否有HumanoidRootPart
    wowCharacter:WaitForChild("HumanoidRootPart") -- 若无则等待该部件加载
end

local wowTorso = wowCharacter:FindFirstChild("Torso") or wowCharacter:FindFirstChild("UpperTorso") -- 适配R6/R15，获取躯干部件（R6为Torso，R15为UpperTorso）
if not wowTorso then -- 若未找到躯干部件
    wowTorso = wowCharacter.HumanoidRootPart --  fallback到HumanoidRootPart
end

local wowParticle = Instance.new("ParticleEmitter") -- 创建粒子发射器实例
wowParticle.Parent = wowTorso -- 将粒子发射器挂载到躯干部件上

wowParticle.Color = ColorSequence.new{ -- 设置粒子颜色渐变（彩虹色）
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), -- 红色
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 215, 0)), -- 橙色
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 0, 0)), -- 黄色
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 215, 0)), -- 绿色
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(255, 0, 0)), -- 青色
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(0, 0, 0)), -- 靛蓝色
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)) -- 紫色
}

wowParticle.Size = NumberSequence.new({ -- 设置粒子大小变化（从小到大再消失）
    NumberSequenceKeypoint.new(0, 0.5), -- 初始大小0.1
    NumberSequenceKeypoint.new(0.5, 0.3), -- 中期最大大小0.3
    NumberSequenceKeypoint.new(1, 0) -- 结束时大小0（消失）
})

wowParticle.Transparency = NumberSequence.new({ -- 设置粒子透明度变化（半透明到完全透明）
    NumberSequenceKeypoint.new(0, 0.0), -- 初始透明度0.2（较清晰）
    NumberSequenceKeypoint.new(0.5, 0.1), -- 中期透明度0.5（半透明）
    NumberSequenceKeypoint.new(1, 1) -- 结束时透明度1（完全透明）
})

wowParticle.Lifetime = NumberRange.new(1, 2) -- 设置粒子生命周期（1-2秒）
wowParticle.Rate = 500 -- 设置粒子发射速率（每秒100个）
wowParticle.Speed = NumberRange.new(1, 3) -- 设置粒子移动速度（1-3 studs/秒）
wowParticle.VelocitySpread = 360 -- 设置粒子速度扩散角度（360度全方向）
wowParticle.Acceleration = Vector3.new(0, 2, 0) -- 设置粒子加速度（向上2 studs/秒²）
wowParticle.Drag = 0.5 -- 设置粒子空气阻力（0.5）
wowParticle.Rotation = NumberRange.new(0, 360) -- 设置粒子初始旋转角度（0-360度随机）
wowParticle.RotSpeed = NumberRange.new(-50, 50) -- 设置粒子旋转速度（-50到50度/秒随机）
wowParticle.LockedToPart = false -- 粒子是否锁定到发射部件（false=不锁定，可自由移动）
wowParticle.Shape = Enum.ParticleEmitterShape.Sphere -- 设置粒子发射形状（球形）
wowParticle.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward -- 设置粒子发射方向（从球心向外）
wowParticle.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume -- 设置粒子发射范围（球形体积内）
wowParticle.EmissionDirection = Enum.NormalId.Top -- 设置粒子发射主方向（朝上）

wowParticle.Enabled = true -- 启用粒子发射器（开始发射粒子）

wowCharacter:WaitForChild("Humanoid").Died:Connect(function() -- 监听角色死亡事件
    wowParticle:Destroy() -- 角色死亡后销毁粒子发射器（避免残留）
end)

local Players = game:GetService("Players") -- 获取玩家服务
local wowPlayer = Players.LocalPlayer -- 获取本地玩家（自己）
local wowCharacter = wowPlayer.Character or wowPlayer.CharacterAdded:Wait() -- 获取玩家角色，若未加载则等待加载

if not wowCharacter:FindFirstChild("HumanoidRootPart") then -- 检查角色是否有HumanoidRootPart
    wowCharacter:WaitForChild("HumanoidRootPart") -- 若无则等待该部件加载
end

local wowHead = wowCharacter:FindFirstChild("Head") or wowCharacter:FindFirstChild("UpperHead") -- 适配R6/R15，获取躯干部件（R6为Head，R15为UpperHead）
if not wowHead then -- 若未找到躯干部件
    wowHead = wowCharacter.HumanoidRootPart --  fallback到HumanoidRootPart
end

local wowParticle = Instance.new("ParticleEmitter") -- 创建粒子发射器实例
wowParticle.Parent = wowHead -- 将粒子发射器挂载到躯干部件上

wowParticle.Color = ColorSequence.new{ -- 设置粒子颜色渐变（彩虹色）
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), -- 红色
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 215, 0)), -- 橙色
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 0, 0)), -- 黄色
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 215, 0)), -- 绿色
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(255, 0, 0)), -- 青色
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(0, 0, 0)), -- 靛蓝色
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)) -- 紫色
}

wowParticle.Size = NumberSequence.new({ -- 设置粒子大小变化（从小到大再消失）
    NumberSequenceKeypoint.new(0, 0.5), -- 初始大小0.1
    NumberSequenceKeypoint.new(0.5, 0.3), -- 中期最大大小0.3
    NumberSequenceKeypoint.new(1, 0) -- 结束时大小0（消失）
})

wowParticle.Transparency = NumberSequence.new({ -- 设置粒子透明度变化（半透明到完全透明）
    NumberSequenceKeypoint.new(0, 0.0), -- 初始透明度0.2（较清晰）
    NumberSequenceKeypoint.new(0.5, 0.1), -- 中期透明度0.5（半透明）
    NumberSequenceKeypoint.new(1, 1) -- 结束时透明度1（完全透明）
})

wowParticle.Lifetime = NumberRange.new(1, 2) -- 设置粒子生命周期（1-2秒）
wowParticle.Rate = 500 -- 设置粒子发射速率（每秒100个）
wowParticle.Speed = NumberRange.new(1, 3) -- 设置粒子移动速度（1-3 studs/秒）
wowParticle.VelocitySpread = 360 -- 设置粒子速度扩散角度（360度全方向）
wowParticle.Acceleration = Vector3.new(0, 2, 0) -- 设置粒子加速度（向上2 studs/秒²）
wowParticle.Drag = 0.5 -- 设置粒子空气阻力（0.5）
wowParticle.Rotation = NumberRange.new(0, 360) -- 设置粒子初始旋转角度（0-360度随机）
wowParticle.RotSpeed = NumberRange.new(-50, 50) -- 设置粒子旋转速度（-50到50度/秒随机）
wowParticle.LockedToPart = false -- 粒子是否锁定到发射部件（false=不锁定，可自由移动）
wowParticle.Shape = Enum.ParticleEmitterShape.Sphere -- 设置粒子发射形状（球形）
wowParticle.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward -- 设置粒子发射方向（从球心向外）
wowParticle.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume -- 设置粒子发射范围（球形体积内）
wowParticle.EmissionDirection = Enum.NormalId.Top -- 设置粒子发射主方向（朝上）

wowParticle.Enabled = true -- 启用粒子发射器（开始发射粒子）

wowCharacter:WaitForChild("Humanoid").Died:Connect(function() -- 监听角色死亡事件
    wowParticle:Destroy() -- 角色死亡后销毁粒子发射器（避免残留）
end)

local Players = game:GetService("Players") -- 获取玩家服务
local wowPlayer = Players.LocalPlayer -- 获取本地玩家（自己）
local wowCharacter = wowPlayer.Character or wowPlayer.CharacterAdded:Wait() -- 获取玩家角色，若未加载则等待加载

if not wowCharacter:FindFirstChild("HumanoidRootPart") then -- 检查角色是否有HumanoidRootPart
    wowCharacter:WaitForChild("HumanoidRootPart") -- 若无则等待该部件加载
end

local wowRightLeg = wowCharacter:FindFirstChild("Right Leg") or wowCharacter:FindFirstChild("UpperRight Leg") -- 适配R6/R15，获取躯干部件（R6为Right Leg，R15为UpperRight Leg）
if not wowRightLeg then -- 若未找到躯干部件
    wowRightLeg = wowCharacter.HumanoidRootPart --  fallback到HumanoidRootPart
end

local wowParticle = Instance.new("ParticleEmitter") -- 创建粒子发射器实例
wowParticle.Parent = wowRightLeg -- 将粒子发射器挂载到躯干部件上

wowParticle.Color = ColorSequence.new{ -- 设置粒子颜色渐变（彩虹色）
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), -- 红色
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 215, 0)), -- 橙色
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 0, 0)), -- 黄色
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 215, 0)), -- 绿色
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(255, 0, 0)), -- 青色
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(0, 0, 0)), -- 靛蓝色
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)) -- 紫色
}

wowParticle.Size = NumberSequence.new({ -- 设置粒子大小变化（从小到大再消失）
    NumberSequenceKeypoint.new(0, 0.5), -- 初始大小0.1
    NumberSequenceKeypoint.new(0.5, 0.3), -- 中期最大大小0.3
    NumberSequenceKeypoint.new(1, 0) -- 结束时大小0（消失）
})

wowParticle.Transparency = NumberSequence.new({ -- 设置粒子透明度变化（半透明到完全透明）
    NumberSequenceKeypoint.new(0, 0.0), -- 初始透明度0.2（较清晰）
    NumberSequenceKeypoint.new(0.5, 0.1), -- 中期透明度0.5（半透明）
    NumberSequenceKeypoint.new(1, 1) -- 结束时透明度1（完全透明）
})

wowParticle.Lifetime = NumberRange.new(1, 2) -- 设置粒子生命周期（1-2秒）
wowParticle.Rate = 500 -- 设置粒子发射速率（每秒100个）
wowParticle.Speed = NumberRange.new(1, 3) -- 设置粒子移动速度（1-3 studs/秒）
wowParticle.VelocitySpread = 360 -- 设置粒子速度扩散角度（360度全方向）
wowParticle.Acceleration = Vector3.new(0, 2, 0) -- 设置粒子加速度（向上2 studs/秒²）
wowParticle.Drag = 0.5 -- 设置粒子空气阻力（0.5）
wowParticle.Rotation = NumberRange.new(0, 360) -- 设置粒子初始旋转角度（0-360度随机）
wowParticle.RotSpeed = NumberRange.new(-50, 50) -- 设置粒子旋转速度（-50到50度/秒随机）
wowParticle.LockedToPart = false -- 粒子是否锁定到发射部件（false=不锁定，可自由移动）
wowParticle.Shape = Enum.ParticleEmitterShape.Sphere -- 设置粒子发射形状（球形）
wowParticle.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward -- 设置粒子发射方向（从球心向外）
wowParticle.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume -- 设置粒子发射范围（球形体积内）
wowParticle.EmissionDirection = Enum.NormalId.Top -- 设置粒子发射主方向（朝上）

wowParticle.Enabled = true -- 启用粒子发射器（开始发射粒子）

wowCharacter:WaitForChild("Humanoid").Died:Connect(function() -- 监听角色死亡事件
    wowParticle:Destroy() -- 角色死亡后销毁粒子发射器（避免残留）
end)

local Players = game:GetService("Players") -- 获取玩家服务
local wowPlayer = Players.LocalPlayer -- 获取本地玩家（自己）
local wowCharacter = wowPlayer.Character or wowPlayer.CharacterAdded:Wait() -- 获取玩家角色，若未加载则等待加载

if not wowCharacter:FindFirstChild("HumanoidRootPart") then -- 检查角色是否有HumanoidRootPart
    wowCharacter:WaitForChild("HumanoidRootPart") -- 若无则等待该部件加载
end

local wowLeftLeg = wowCharacter:FindFirstChild("LeftLeg") or wowCharacter:FindFirstChild("UpperLeftLeg") -- 适配R6/R15，获取躯干部件（R6为LeftLeg，R15为UpperLeftLeg）
if not wowLeftLeg then -- 若未找到躯干部件
    wowLeftLeg = wowCharacter.HumanoidRootPart --  fallback到HumanoidRootPart
end

local wowParticle = Instance.new("ParticleEmitter") -- 创建粒子发射器实例
wowParticle.Parent = wowLeftLeg -- 将粒子发射器挂载到躯干部件上

wowParticle.Color = ColorSequence.new{ -- 设置粒子颜色渐变（彩虹色）
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), -- 红色
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 215, 0)), -- 橙色
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 0, 0)), -- 黄色
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 215, 0)), -- 绿色
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(255, 0, 0)), -- 青色
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(0, 0, 0)), -- 靛蓝色
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)) -- 紫色
}

wowParticle.Size = NumberSequence.new({ -- 设置粒子大小变化（从小到大再消失）
    NumberSequenceKeypoint.new(0, 0.5), -- 初始大小0.1
    NumberSequenceKeypoint.new(0.5, 0.3), -- 中期最大大小0.3
    NumberSequenceKeypoint.new(1, 0) -- 结束时大小0（消失）
})

wowParticle.Transparency = NumberSequence.new({ -- 设置粒子透明度变化（半透明到完全透明）
    NumberSequenceKeypoint.new(0, 0.0), -- 初始透明度0.2（较清晰）
    NumberSequenceKeypoint.new(0.5, 0.1), -- 中期透明度0.5（半透明）
    NumberSequenceKeypoint.new(1, 1) -- 结束时透明度1（完全透明）
})

wowParticle.Lifetime = NumberRange.new(1, 2) -- 设置粒子生命周期（1-2秒）
wowParticle.Rate = 500 -- 设置粒子发射速率（每秒100个）
wowParticle.Speed = NumberRange.new(1, 3) -- 设置粒子移动速度（1-3 studs/秒）
wowParticle.VelocitySpread = 360 -- 设置粒子速度扩散角度（360度全方向）
wowParticle.Acceleration = Vector3.new(0, 2, 0) -- 设置粒子加速度（向上2 studs/秒²）
wowParticle.Drag = 0.5 -- 设置粒子空气阻力（0.5）
wowParticle.Rotation = NumberRange.new(0, 360) -- 设置粒子初始旋转角度（0-360度随机）
wowParticle.RotSpeed = NumberRange.new(-50, 50) -- 设置粒子旋转速度（-50到50度/秒随机）
wowParticle.LockedToPart = false -- 粒子是否锁定到发射部件（false=不锁定，可自由移动）
wowParticle.Shape = Enum.ParticleEmitterShape.Sphere -- 设置粒子发射形状（球形）
wowParticle.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward -- 设置粒子发射方向（从球心向外）
wowParticle.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume -- 设置粒子发射范围（球形体积内）
wowParticle.EmissionDirection = Enum.NormalId.Top -- 设置粒子发射主方向（朝上）

wowParticle.Enabled = true -- 启用粒子发射器（开始发射粒子）

wowCharacter:WaitForChild("Humanoid").Died:Connect(function() -- 监听角色死亡事件
    wowParticle:Destroy() -- 角色死亡后销毁粒子发射器（避免残留）
end)

local Players = game:GetService("Players") -- 获取玩家服务
local wowPlayer = Players.LocalPlayer -- 获取本地玩家（自己）
local wowCharacter = wowPlayer.Character or wowPlayer.CharacterAdded:Wait() -- 获取玩家角色，若未加载则等待加载

if not wowCharacter:FindFirstChild("HumanoidRootPart") then -- 检查角色是否有HumanoidRootPart
    wowCharacter:WaitForChild("HumanoidRootPart") -- 若无则等待该部件加载
end

local wowRightArm = wowCharacter:FindFirstChild("RightArm") or wowCharacter:FindFirstChild("UpperRightArm") -- 适配R6/R15，获取躯干部件（R6为RightArm，R15为UpperRightArm）
if not wowRightArm then -- 若未找到躯干部件
    wowRightArm = wowCharacter.HumanoidRootPart --  fallback到HumanoidRootPart
end

local wowParticle = Instance.new("ParticleEmitter") -- 创建粒子发射器实例
wowParticle.Parent = wowRightArm -- 将粒子发射器挂载到躯干部件上

wowParticle.Color = ColorSequence.new{ -- 设置粒子颜色渐变（彩虹色）
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), -- 红色
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 215, 0)), -- 橙色
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 0, 0)), -- 黄色
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 215, 0)), -- 绿色
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(255, 0, 0)), -- 青色
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(0, 0, 0)), -- 靛蓝色
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)) -- 紫色
}

wowParticle.Size = NumberSequence.new({ -- 设置粒子大小变化（从小到大再消失）
    NumberSequenceKeypoint.new(0, 0.5), -- 初始大小0.1
    NumberSequenceKeypoint.new(0.5, 0.3), -- 中期最大大小0.3
    NumberSequenceKeypoint.new(1, 0) -- 结束时大小0（消失）
})

wowParticle.Transparency = NumberSequence.new({ -- 设置粒子透明度变化（半透明到完全透明）
    NumberSequenceKeypoint.new(0, 0.0), -- 初始透明度0.2（较清晰）
    NumberSequenceKeypoint.new(0.5, 0.1), -- 中期透明度0.5（半透明）
    NumberSequenceKeypoint.new(1, 1) -- 结束时透明度1（完全透明）
})

wowParticle.Lifetime = NumberRange.new(1, 2) -- 设置粒子生命周期（1-2秒）
wowParticle.Rate = 500 -- 设置粒子发射速率（每秒100个）
wowParticle.Speed = NumberRange.new(1, 3) -- 设置粒子移动速度（1-3 studs/秒）
wowParticle.VelocitySpread = 360 -- 设置粒子速度扩散角度（360度全方向）
wowParticle.Acceleration = Vector3.new(0, 2, 0) -- 设置粒子加速度（向上2 studs/秒²）
wowParticle.Drag = 0.5 -- 设置粒子空气阻力（0.5）
wowParticle.Rotation = NumberRange.new(0, 360) -- 设置粒子初始旋转角度（0-360度随机）
wowParticle.RotSpeed = NumberRange.new(-50, 50) -- 设置粒子旋转速度（-50到50度/秒随机）
wowParticle.LockedToPart = false -- 粒子是否锁定到发射部件（false=不锁定，可自由移动）
wowParticle.Shape = Enum.ParticleEmitterShape.Sphere -- 设置粒子发射形状（球形）
wowParticle.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward -- 设置粒子发射方向（从球心向外）
wowParticle.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume -- 设置粒子发射范围（球形体积内）
wowParticle.EmissionDirection = Enum.NormalId.Top -- 设置粒子发射主方向（朝上）

wowParticle.Enabled = true -- 启用粒子发射器（开始发射粒子）

wowCharacter:WaitForChild("Humanoid").Died:Connect(function() -- 监听角色死亡事件
    wowParticle:Destroy() -- 角色死亡后销毁粒子发射器（避免残留）
end)

local Players = game:GetService("Players") -- 获取玩家服务
local wowPlayer = Players.LocalPlayer -- 获取本地玩家（自己）
local wowCharacter = wowPlayer.Character or wowPlayer.CharacterAdded:Wait() -- 获取玩家角色，若未加载则等待加载

if not wowCharacter:FindFirstChild("HumanoidRootPart") then -- 检查角色是否有HumanoidRootPart
    wowCharacter:WaitForChild("HumanoidRootPart") -- 若无则等待该部件加载
end

local wowLeftArm = wowCharacter:FindFirstChild("LeftArm") or wowCharacter:FindFirstChild("UpperLeftArm") -- 适配R6/R15，获取躯干部件（R6为LeftArm，R15为UpperLeftArm）
if not wowLeftArm then -- 若未找到躯干部件
    wowLeftArm = wowCharacter.HumanoidRootPart --  fallback到HumanoidRootPart
end

local wowParticle = Instance.new("ParticleEmitter") -- 创建粒子发射器实例
wowParticle.Parent = wowLeftArm -- 将粒子发射器挂载到躯干部件上

wowParticle.Color = ColorSequence.new{ -- 设置粒子颜色渐变（彩虹色）
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), -- 红色
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 215, 0)), -- 橙色
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 0, 0)), -- 黄色
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 215, 0)), -- 绿色
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(255, 0, 0)), -- 青色
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(0, 0, 0)), -- 靛蓝色
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)) -- 紫色
}

wowParticle.Size = NumberSequence.new({ -- 设置粒子大小变化（从小到大再消失）
    NumberSequenceKeypoint.new(0, 0.5), -- 初始大小0.1
    NumberSequenceKeypoint.new(0.5, 0.3), -- 中期最大大小0.3
    NumberSequenceKeypoint.new(1, 0) -- 结束时大小0（消失）
})

wowParticle.Transparency = NumberSequence.new({ -- 设置粒子透明度变化（半透明到完全透明）
    NumberSequenceKeypoint.new(0, 0.0), -- 初始透明度0.2（较清晰）
    NumberSequenceKeypoint.new(0.5, 0.1), -- 中期透明度0.5（半透明）
    NumberSequenceKeypoint.new(1, 1) -- 结束时透明度1（完全透明）
})

wowParticle.Lifetime = NumberRange.new(1, 2) -- 设置粒子生命周期（1-2秒）
wowParticle.Rate = 500 -- 设置粒子发射速率（每秒100个）
wowParticle.Speed = NumberRange.new(1, 3) -- 设置粒子移动速度（1-3 studs/秒）
wowParticle.VelocitySpread = 360 -- 设置粒子速度扩散角度（360度全方向）
wowParticle.Acceleration = Vector3.new(0, 2, 0) -- 设置粒子加速度（向上2 studs/秒²）
wowParticle.Drag = 0.5 -- 设置粒子空气阻力（0.5）
wowParticle.Rotation = NumberRange.new(0, 360) -- 设置粒子初始旋转角度（0-360度随机）
wowParticle.RotSpeed = NumberRange.new(-50, 50) -- 设置粒子旋转速度（-50到50度/秒随机）
wowParticle.LockedToPart = false -- 粒子是否锁定到发射部件（false=不锁定，可自由移动）
wowParticle.Shape = Enum.ParticleEmitterShape.Sphere -- 设置粒子发射形状（球形）
wowParticle.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward -- 设置粒子发射方向（从球心向外）
wowParticle.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume -- 设置粒子发射范围（球形体积内）
wowParticle.EmissionDirection = Enum.NormalId.Top -- 设置粒子发射主方向（朝上）

wowParticle.Enabled = true -- 启用粒子发射器（开始发射粒子）

wowCharacter:WaitForChild("Humanoid").Died:Connect(function() -- 监听角色死亡事件
    wowParticle:Destroy() -- 角色死亡后销毁粒子发射器（避免残留）
end)

local Players = game:GetService("Players") -- 获取玩家服务
local wowPlayer = Players.LocalPlayer -- 获取本地玩家（自己）
local wowCharacter = wowPlayer.Character or wowPlayer.CharacterAdded:Wait() -- 获取玩家角色，若未加载则等待加载

if not wowCharacter:FindFirstChild("HumanoidRootPart") then -- 检查角色是否有HumanoidRootPart
    wowCharacter:WaitForChild("HumanoidRootPart") -- 若无则等待该部件加载
end

local wowHead = wowCharacter:FindFirstChild("Head") or wowCharacter:FindFirstChild("UpperHead") -- 适配R6/R15，获取躯干部件（R6为Head，R15为UpperHead）
if not wowHead then -- 若未找到躯干部件
    wowHead = wowCharacter.HumanoidRootPart --  fallback到HumanoidRootPart
end

local wowParticle = Instance.new("ParticleEmitter") -- 创建粒子发射器实例
wowParticle.Parent = wowHead -- 将粒子发射器挂载到躯干部件上

wowParticle.Color = ColorSequence.new{ -- 设置粒子颜色渐变（彩虹色）
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), -- 红色
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 215, 0)), -- 橙色
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 0, 0)), -- 黄色
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 215, 0)), -- 绿色
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(255, 0, 0)), -- 青色
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(0, 0, 0)), -- 靛蓝色
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)) -- 紫色
}

wowParticle.Size = NumberSequence.new({ -- 设置粒子大小变化（从小到大再消失）
    NumberSequenceKeypoint.new(0, 0.5), -- 初始大小0.1
    NumberSequenceKeypoint.new(0.5, 0.3), -- 中期最大大小0.3
    NumberSequenceKeypoint.new(1, 0) -- 结束时大小0（消失）
})

wowParticle.Transparency = NumberSequence.new({ -- 设置粒子透明度变化（半透明到完全透明）
    NumberSequenceKeypoint.new(0, 0.0), -- 初始透明度0.2（较清晰）
    NumberSequenceKeypoint.new(0.5, 0.1), -- 中期透明度0.5（半透明）
    NumberSequenceKeypoint.new(1, 1) -- 结束时透明度1（完全透明）
})

wowParticle.Lifetime = NumberRange.new(1, 2) -- 设置粒子生命周期（1-2秒）
wowParticle.Rate = 500 -- 设置粒子发射速率（每秒100个）
wowParticle.Speed = NumberRange.new(1, 3) -- 设置粒子移动速度（1-3 studs/秒）
wowParticle.VelocitySpread = 360 -- 设置粒子速度扩散角度（360度全方向）
wowParticle.Acceleration = Vector3.new(0, 2, 0) -- 设置粒子加速度（向上2 studs/秒²）
wowParticle.Drag = 0.5 -- 设置粒子空气阻力（0.5）
wowParticle.Rotation = NumberRange.new(0, 360) -- 设置粒子初始旋转角度（0-360度随机）
wowParticle.RotSpeed = NumberRange.new(-50, 50) -- 设置粒子旋转速度（-50到50度/秒随机）
wowParticle.LockedToPart = false -- 粒子是否锁定到发射部件（false=不锁定，可自由移动）
wowParticle.Shape = Enum.ParticleEmitterShape.Sphere -- 设置粒子发射形状（球形）
wowParticle.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward -- 设置粒子发射方向（从球心向外）
wowParticle.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume -- 设置粒子发射范围（球形体积内）
wowParticle.EmissionDirection = Enum.NormalId.Top -- 设置粒子发射主方向（朝上）

wowParticle.Enabled = true -- 启用粒子发射器（开始发射粒子）

wowCharacter:WaitForChild("Humanoid").Died:Connect(function() -- 监听角色死亡事件
    wowParticle:Destroy() -- 角色死亡后销毁粒子发射器（避免残留）
end)

local Players = game:GetService("Players") -- 获取玩家服务
local wowPlayer = Players.LocalPlayer -- 获取本地玩家（自己）
local wowCharacter = wowPlayer.Character or wowPlayer.CharacterAdded:Wait() -- 获取玩家角色，若未加载则等待加载

if not wowCharacter:FindFirstChild("HumanoidRootPart") then -- 检查角色是否有HumanoidRootPart
    wowCharacter:WaitForChild("HumanoidRootPart") -- 若无则等待该部件加载
end

local wowRightLeg = wowCharacter:FindFirstChild("Right Leg") or wowCharacter:FindFirstChild("UpperRight Leg") -- 适配R6/R15，获取躯干部件（R6为Right Leg，R15为UpperRight Leg）
if not wowRightLeg then -- 若未找到躯干部件
    wowRightLeg = wowCharacter.HumanoidRootPart --  fallback到HumanoidRootPart
end

local wowParticle = Instance.new("ParticleEmitter") -- 创建粒子发射器实例
wowParticle.Parent = wowRightLeg -- 将粒子发射器挂载到躯干部件上

wowParticle.Color = ColorSequence.new{ -- 设置粒子颜色渐变（彩虹色）
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), -- 红色
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 215, 0)), -- 橙色
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 0, 0)), -- 黄色
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 215, 0)), -- 绿色
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(255, 0, 0)), -- 青色
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(0, 0, 0)), -- 靛蓝色
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)) -- 紫色
}

wowParticle.Size = NumberSequence.new({ -- 设置粒子大小变化（从小到大再消失）
    NumberSequenceKeypoint.new(0, 0.5), -- 初始大小0.1
    NumberSequenceKeypoint.new(0.5, 0.3), -- 中期最大大小0.3
    NumberSequenceKeypoint.new(1, 0) -- 结束时大小0（消失）
})

wowParticle.Transparency = NumberSequence.new({ -- 设置粒子透明度变化（半透明到完全透明）
    NumberSequenceKeypoint.new(0, 0.0), -- 初始透明度0.2（较清晰）
    NumberSequenceKeypoint.new(0.5, 0.1), -- 中期透明度0.5（半透明）
    NumberSequenceKeypoint.new(1, 1) -- 结束时透明度1（完全透明）
})

wowParticle.Lifetime = NumberRange.new(1, 2) -- 设置粒子生命周期（1-2秒）
wowParticle.Rate = 500 -- 设置粒子发射速率（每秒100个）
wowParticle.Speed = NumberRange.new(1, 3) -- 设置粒子移动速度（1-3 studs/秒）
wowParticle.VelocitySpread = 360 -- 设置粒子速度扩散角度（360度全方向）
wowParticle.Acceleration = Vector3.new(0, 2, 0) -- 设置粒子加速度（向上2 studs/秒²）
wowParticle.Drag = 0.5 -- 设置粒子空气阻力（0.5）
wowParticle.Rotation = NumberRange.new(0, 360) -- 设置粒子初始旋转角度（0-360度随机）
wowParticle.RotSpeed = NumberRange.new(-50, 50) -- 设置粒子旋转速度（-50到50度/秒随机）
wowParticle.LockedToPart = false -- 粒子是否锁定到发射部件（false=不锁定，可自由移动）
wowParticle.Shape = Enum.ParticleEmitterShape.Sphere -- 设置粒子发射形状（球形）
wowParticle.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward -- 设置粒子发射方向（从球心向外）
wowParticle.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume -- 设置粒子发射范围（球形体积内）
wowParticle.EmissionDirection = Enum.NormalId.Top -- 设置粒子发射主方向（朝上）

wowParticle.Enabled = true -- 启用粒子发射器（开始发射粒子）

wowCharacter:WaitForChild("Humanoid").Died:Connect(function() -- 监听角色死亡事件
    wowParticle:Destroy() -- 角色死亡后销毁粒子发射器（避免残留）
end)

local Players = game:GetService("Players") -- 获取玩家服务
local wowPlayer = Players.LocalPlayer -- 获取本地玩家（自己）
local wowCharacter = wowPlayer.Character or wowPlayer.CharacterAdded:Wait() -- 获取玩家角色，若未加载则等待加载

if not wowCharacter:FindFirstChild("HumanoidRootPart") then -- 检查角色是否有HumanoidRootPart
    wowCharacter:WaitForChild("HumanoidRootPart") -- 若无则等待该部件加载
end

local wowLeftLeg = wowCharacter:FindFirstChild("LeftLeg") or wowCharacter:FindFirstChild("UpperLeftLeg") -- 适配R6/R15，获取躯干部件（R6为LeftLeg，R15为UpperLeftLeg）
if not wowLeftLeg then -- 若未找到躯干部件
    wowLeftLeg = wowCharacter.HumanoidRootPart --  fallback到HumanoidRootPart
end

local wowParticle = Instance.new("ParticleEmitter") -- 创建粒子发射器实例
wowParticle.Parent = wowLeftLeg -- 将粒子发射器挂载到躯干部件上

wowParticle.Color = ColorSequence.new{ -- 设置粒子颜色渐变（彩虹色）
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), -- 红色
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 215, 0)), -- 橙色
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 0, 0)), -- 黄色
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 215, 0)), -- 绿色
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(255, 0, 0)), -- 青色
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(0, 0, 0)), -- 靛蓝色
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)) -- 紫色
}

wowParticle.Size = NumberSequence.new({ -- 设置粒子大小变化（从小到大再消失）
    NumberSequenceKeypoint.new(0, 0.5), -- 初始大小0.1
    NumberSequenceKeypoint.new(0.5, 0.3), -- 中期最大大小0.3
    NumberSequenceKeypoint.new(1, 0) -- 结束时大小0（消失）
})

wowParticle.Transparency = NumberSequence.new({ -- 设置粒子透明度变化（半透明到完全透明）
    NumberSequenceKeypoint.new(0, 0.0), -- 初始透明度0.2（较清晰）
    NumberSequenceKeypoint.new(0.5, 0.1), -- 中期透明度0.5（半透明）
    NumberSequenceKeypoint.new(1, 1) -- 结束时透明度1（完全透明）
})

wowParticle.Lifetime = NumberRange.new(1, 2) -- 设置粒子生命周期（1-2秒）
wowParticle.Rate = 500 -- 设置粒子发射速率（每秒100个）
wowParticle.Speed = NumberRange.new(1, 3) -- 设置粒子移动速度（1-3 studs/秒）
wowParticle.VelocitySpread = 360 -- 设置粒子速度扩散角度（360度全方向）
wowParticle.Acceleration = Vector3.new(0, 2, 0) -- 设置粒子加速度（向上2 studs/秒²）
wowParticle.Drag = 0.5 -- 设置粒子空气阻力（0.5）
wowParticle.Rotation = NumberRange.new(0, 360) -- 设置粒子初始旋转角度（0-360度随机）
wowParticle.RotSpeed = NumberRange.new(-50, 50) -- 设置粒子旋转速度（-50到50度/秒随机）
wowParticle.LockedToPart = false -- 粒子是否锁定到发射部件（false=不锁定，可自由移动）
wowParticle.Shape = Enum.ParticleEmitterShape.Sphere -- 设置粒子发射形状（球形）
wowParticle.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward -- 设置粒子发射方向（从球心向外）
wowParticle.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume -- 设置粒子发射范围（球形体积内）
wowParticle.EmissionDirection = Enum.NormalId.Top -- 设置粒子发射主方向（朝上）

wowParticle.Enabled = true -- 启用粒子发射器（开始发射粒子）

wowCharacter:WaitForChild("Humanoid").Died:Connect(function() -- 监听角色死亡事件
    wowParticle:Destroy() -- 角色死亡后销毁粒子发射器（避免残留）
end)

local Players = game:GetService("Players") -- 获取玩家服务
local wowPlayer = Players.LocalPlayer -- 获取本地玩家（自己）
local wowCharacter = wowPlayer.Character or wowPlayer.CharacterAdded:Wait() -- 获取玩家角色，若未加载则等待加载

if not wowCharacter:FindFirstChild("HumanoidRootPart") then -- 检查角色是否有HumanoidRootPart
    wowCharacter:WaitForChild("HumanoidRootPart") -- 若无则等待该部件加载
end

local wowRightArm = wowCharacter:FindFirstChild("RightArm") or wowCharacter:FindFirstChild("UpperRightArm") -- 适配R6/R15，获取躯干部件（R6为RightArm，R15为UpperRightArm）
if not wowRightArm then -- 若未找到躯干部件
    wowRightArm = wowCharacter.HumanoidRootPart --  fallback到HumanoidRootPart
end

local wowParticle = Instance.new("ParticleEmitter") -- 创建粒子发射器实例
wowParticle.Parent = wowRightArm -- 将粒子发射器挂载到躯干部件上

wowParticle.Color = ColorSequence.new{ -- 设置粒子颜色渐变（彩虹色）
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), -- 红色
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 215, 0)), -- 橙色
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 0, 0)), -- 黄色
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 215, 0)), -- 绿色
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(255, 0, 0)), -- 青色
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(0, 0, 0)), -- 靛蓝色
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)) -- 紫色
}

wowParticle.Size = NumberSequence.new({ -- 设置粒子大小变化（从小到大再消失）
    NumberSequenceKeypoint.new(0, 0.5), -- 初始大小0.1
    NumberSequenceKeypoint.new(0.5, 0.3), -- 中期最大大小0.3
    NumberSequenceKeypoint.new(1, 0) -- 结束时大小0（消失）
})

wowParticle.Transparency = NumberSequence.new({ -- 设置粒子透明度变化（半透明到完全透明）
    NumberSequenceKeypoint.new(0, 0.0), -- 初始透明度0.2（较清晰）
    NumberSequenceKeypoint.new(0.5, 0.1), -- 中期透明度0.5（半透明）
    NumberSequenceKeypoint.new(1, 1) -- 结束时透明度1（完全透明）
})

wowParticle.Lifetime = NumberRange.new(1, 2) -- 设置粒子生命周期（1-2秒）
wowParticle.Rate = 500 -- 设置粒子发射速率（每秒100个）
wowParticle.Speed = NumberRange.new(1, 3) -- 设置粒子移动速度（1-3 studs/秒）
wowParticle.VelocitySpread = 360 -- 设置粒子速度扩散角度（360度全方向）
wowParticle.Acceleration = Vector3.new(0, 2, 0) -- 设置粒子加速度（向上2 studs/秒²）
wowParticle.Drag = 0.5 -- 设置粒子空气阻力（0.5）
wowParticle.Rotation = NumberRange.new(0, 360) -- 设置粒子初始旋转角度（0-360度随机）
wowParticle.RotSpeed = NumberRange.new(-50, 50) -- 设置粒子旋转速度（-50到50度/秒随机）
wowParticle.LockedToPart = false -- 粒子是否锁定到发射部件（false=不锁定，可自由移动）
wowParticle.Shape = Enum.ParticleEmitterShape.Sphere -- 设置粒子发射形状（球形）
wowParticle.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward -- 设置粒子发射方向（从球心向外）
wowParticle.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume -- 设置粒子发射范围（球形体积内）
wowParticle.EmissionDirection = Enum.NormalId.Top -- 设置粒子发射主方向（朝上）

wowParticle.Enabled = true -- 启用粒子发射器（开始发射粒子）

wowCharacter:WaitForChild("Humanoid").Died:Connect(function() -- 监听角色死亡事件
    wowParticle:Destroy() -- 角色死亡后销毁粒子发射器（避免残留）
end)