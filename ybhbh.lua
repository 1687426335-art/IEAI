local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- 距离与资源设置
local MAX_HP_DISTANCE = 100 
local BACKGROUND_IMAGE_ID = "rbxassetid://13854737227" 

-- 移动端按钮图片
local MOBILE_BTN_IMAGE_ID = "rbxassetid://97793851580916"

local CLICK_SOUND_ID = "rbxassetid://535716488" 
local RESET_SOUND_ID = "rbxassetid://80804836827311" 
local INTRO_SOUND_ID = "rbxassetid://93122684397641" 

-- 界面颜色与透明度（黑白单色主题）
local DARK_BG = Color3.fromRGB(10, 10, 10)
local HEADER_BG = Color3.fromRGB(16, 16, 16)
local PANEL_BG = Color3.fromRGB(20, 20, 20)
local CARD_BG = Color3.fromRGB(25, 25, 25)
local BORDER_COLOR = Color3.fromRGB(60, 60, 60)
local ACCENT_WHITE = Color3.fromRGB(255, 255, 255)
local ACCENT_GREY = Color3.fromRGB(180, 180, 180)
local COLOR_ENABLED = Color3.fromRGB(240, 240, 240)
local COLOR_ENABLED_TEXT = Color3.fromRGB(15, 15, 15)
local COLOR_DISABLED = Color3.fromRGB(40, 40, 40)
local COLOR_DISABLED_TEXT = Color3.fromRGB(180, 180, 180)
local TEXT_WHITE = Color3.fromRGB(245, 245, 245)
local TEXT_MUTED = Color3.fromRGB(130, 130, 130)

-- 按键与缩放
local toggleKey = Enum.KeyCode.RightControl
local tpToggleKey = Enum.KeyCode.V
local isBinding = false
local isBindingTP = false
local blurEnabled = true -- 模糊效果开关

local fullSize = UDim2.new(0, 640, 0, 400)
local zeroSize = UDim2.new(0, 0, 0, 0)
local currentScale = 1.0

-- 清理旧界面
if PlayerGui:FindFirstChild("ShizukaExaminationUI") then
	PlayerGui.ShizukaExaminationUI:Destroy()
end
if Lighting:FindFirstChild("ShizukaMenuBlur") then
	Lighting.ShizukaMenuBlur:Destroy()
end

-- 游戏背景模糊效果
local MenuBlur = Instance.new("BlurEffect")
MenuBlur.Name = "ShizukaMenuBlur"
MenuBlur.Size = 0
MenuBlur.Enabled = true
MenuBlur.Parent = Lighting

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ShizukaExaminationUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- 音频实例
local ClickSound = Instance.new("Sound")
ClickSound.Name = "UIClickSound"
ClickSound.SoundId = CLICK_SOUND_ID
ClickSound.Volume = 0.5
ClickSound.Parent = ScreenGui

local ResetSound = Instance.new("Sound")
ResetSound.Name = "UIResetSound"
ResetSound.SoundId = RESET_SOUND_ID
ResetSound.Volume = 0.7
ResetSound.Parent = ScreenGui

local IntroSound = Instance.new("Sound")
IntroSound.Name = "UIIntroSound"
IntroSound.SoundId = INTRO_SOUND_ID
IntroSound.Volume = 1.0
IntroSound.Parent = ScreenGui

local function playClickSound()
	SoundService:PlayLocalSound(ClickSound)
end

local function playResetSound()
	SoundService:PlayLocalSound(ResetSound)
end

-- 主窗口
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Size = zeroSize
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = DARK_BG
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = ACCENT_GREY
MainStroke.Thickness = 1.2
MainStroke.Transparency = 0.4
MainStroke.Parent = MainFrame

-- 背景纹理
local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Name = "BackgroundImage"
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.Position = UDim2.new(0, 0, 0, 0)
 EnumBackgroundImage.BackgroundTransparency = .E1
BackgroundImage.Image = BACKGROUND_IMAGEasing_ID
BackgroundDirectionImage.ImageTransparency = .0.2
BackgroundImage.ScaleType = Enum.ScaleType.Crop
BackgroundImage.ZIndex = 1
BackgroundImage.Parent = MainFrame

-- 大小缩放控制
local MainScale = Instance.new("UIScale")
MainScale.Scale = currentScale
MainScale.Parent = MainFrame

local scaleTween = nil
local function animateScale(newScale)
	currentScale = math.clamp(newScale, 0.5, 1.4)
	if scaleTween then scaleTween:Cancel() end
	scaleTween = TweenService:Create(MainScale, TweenInfo.new(0.25, Enum.EasingStyle.Back,Out), { Scale = currentScale })
	scaleTween:Play()
end

-- 顶栏
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 42)
Header.BackgroundColor3 = HEADER_BG
Header.BackgroundTransparency = 0.3
Header.BorderSizePixel = 0
Header.ZIndex = 3
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 180, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "静香检测"
TitleLabel.TextColor3 = TEXT_WHITE
TitleLabel.TextSize = 12
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 4
TitleLabel.Parent = Header

-- 控制按钮（+ / - / X）
local ControlsContainer = Instance.new("Frame")
ControlsContainer.Size = UDim2.new(0, 110, 1, 0)
ControlsContainer.Position = UDim2.new(1, -115, 0, 0)
ControlsContainer.BackgroundTransparency = 1
ControlsContainer.ZIndex = 5
ControlsContainer.Parent = Header

local ControlsLayout = Instance.new("UIListLayout")
ControlsLayout.FillDirection = Enum.FillDirection.Horizontal
ControlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
ControlsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
ControlsLayout.Padding = UDim.new(0, 5)
ControlsLayout.Parent = ControlsContainer

local function createHeaderBtn(text, color)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 26, 0, 26)
	btn.BackgroundColor3 = CARD_BG
	btn.BackgroundTransparency = 0.3
	btn.Text = text
	btn.TextColor3 = color or TEXT_MUTED
	btn.TextSize = 13
	btn.Font = Enum.Font.GothamBold
	btn.ZIndex = 6
	btn.Parent = ControlsContainer
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = BORDER_COLOR
	stroke.Thickness = 1
	stroke.Parent = btn
	return btn
end

local ZoomOutBtn = createHeaderBtn("-", TEXT_WHITE)
local ZoomInBtn = createHeaderBtn("+", TEXT_WHITE)
local CloseButton = createHeaderBtn("X", ACCENT_WHITE)

ZoomOutBtn.MouseButton1Click:Connect(function() 
	playClickSound()
	animateScale(currentScale - 0.1) 
end)

ZoomInBtn.MouseButton1Click:Connect(function() 
	playClickSound()
	animateScale(currentScale + 0.1) 
end)

-- 拖动窗口
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

Header.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- 标签页系统
local TabsContainer = Instance.new("Frame")
TabsContainer.Size = UDim2.new(0, 220, 1, 0)
TabsContainer.Position = UDim2.new(0, 195, 0, 0)
TabsContainer.BackgroundTransparency = 1
TabsContainer.ZIndex = 4
TabsContainer.Parent = Header

local UIListTabs = Instance.new("UIListLayout")
UIListTabs.FillDirection = Enum.FillDirection.Horizontal
UIListTabs.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListTabs.VerticalAlignment = Enum.VerticalAlignment.Center
UIListTabs.Padding = UDim.new(0, 4)
UIListTabs.Parent = TabsContainer

local function createTabBtn(name)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 50, 0, 26)
	btn.BackgroundTransparency = 1
	btn.Text = name
	btn.TextColor3 = TEXT_MUTED
	btn.TextSize = 10
	btn.Font = Enum.Font.GothamBold
	btn.ZIndex = 5
	btn.Parent = TabsContainer
	return btn
end

local MainTabBtn = createTabBtn("主页")
local ExtrasTabBtn = createTabBtn("附加")
local KeybindTabBtn = createTabBtn("按键")
local InfoTabBtn = createTabBtn("信息")

-- 内容区
local BodyFrame = Instance.new("Frame")
BodyFrame.Size = UDim2.new(1, -20, 1, -55)
BodyFrame.Position = UDim2.new(0, 10, 0, 48)
BodyFrame.BackgroundTransparency = 1
BodyFrame.ZIndex = 3
BodyFrame.Parent = MainFrame

local GridContainer = Instance.new("Frame")
GridContainer.Size = UDim2.new(0, 400, 1, 0)
GridContainer.BackgroundTransparency = 1
GridContainer.ZIndex = 3
GridContainer.Parent = BodyFrame

-- 右侧详情面板
local DetailPanel = Instance.new("Frame")
DetailPanel.Size = UDim2.new(0, 210, 1, 0)
DetailPanel.Position = UDim2.new(1, -210, 0, 0)
DetailPanel.BackgroundColor3 = PANEL_BG
DetailPanel.BackgroundTransparency = 0.4
DetailPanel.ZIndex = 3
DetailPanel.Parent = BodyFrame

local DetailCorner = Instance.new("UICorner")
DetailCorner.CornerRadius = UDim.new(0, 8)
DetailCorner.Parent = DetailPanel

local DetailStroke = Instance.new("UIStroke")
DetailStroke.Color = BORDER_COLOR
DetailStroke.Thickness = 1
DetailStroke.Transparency = 0.4
DetailStroke.Parent = DetailPanel

local DetailTitle = Instance.new("TextLabel")
DetailTitle.Size = UDim2.new(1, -20, 0, 30)
DetailTitle.Position = UDim2.new(0, 10, 0, 8)
DetailTitle.BackgroundTransparency = 1
DetailTitle.Text = "请选择一个模块"
DetailTitle.TextColor3 = ACCENT_WHITE
DetailTitle.TextSize = 12
DetailTitle.Font = Enum.Font.GothamBold
DetailTitle.TextXAlignment = Enum.TextXAlignment.Left
DetailTitle.ZIndex = 4
DetailTitle.Parent = DetailPanel

local DetailDivider = Instance.new("Frame")
DetailDivider.Size = UDim2.new(1, -20, 0, 1)
DetailDivider.Position = UDim2.new(0, 10, 0, 38)
DetailDivider.BackgroundColor3 = ACCENT_WHITE
DetailDivider.BorderSizePixel = 0
DetailDivider.ZIndex = 4
DetailDivider.Parent = DetailPanel

local DetailDesc = Instance.new("TextLabel")
DetailDesc.Size = UDim2.new(1, -20, 0, 240)
DetailDesc.Position = UDim2.new(0, 10, 0, 46)
DetailDesc.BackgroundTransparency = 1
DetailDesc.Text = "将鼠标悬停或与任意模块交互，即可查看系统规格说明。"
DetailDesc.TextColor3 = TEXT_WHITE
DetailDesc.TextSize = 11
DetailDesc.Font = Enum.Font.Gotham
DetailDesc.TextXAlignment = Enum.TextXAlignment.Left
DetailDesc.TextYAlignment = Enum.TextYAlignment.Top
DetailDesc.TextWrapped = true
DetailDesc.ZIndex = 4
DetailDesc.Parent = DetailPanel

local function updateDetails(title, desc)
	DetailTitle.Text = string.upper(title)
	DetailDesc.Text = desc
end

-- 标签页面
local Pages = {}
local function createGridPage(name)
	local page = Instance.new("ScrollingFrame")
	page.Name = name
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.Visible = false
	page.ScrollBarThickness = 2
	page.ScrollBarImageColor3 = ACCENT_WHITE
	page.ZIndex = 3
	page.Parent = GridContainer
	
	local grid = Instance.new("UIGridLayout")
	grid.CellSize = UDim2.new(0, 185, 0, 105)
	grid.CellPadding = UDim2.new(0, 10, 0, 10)
	grid.Parent = page
	
	Pages[name] = page
	return page
end

local MainPage = createGridPage("Main")
local ExtrasPage = createGridPage("Extras")
local KeybindPage = createGridPage("Keybind")

local InfoPage = Instance.new("Frame")
InfoPage.Name = "Info"
InfoPage.Size = UDim2.new(1, 0, 1, 0)
InfoPage.BackgroundTransparency = 1
InfoPage.Visible = false
InfoPage.ZIndex = 3
InfoPage.Parent = GridContainer
Pages["Info"] = InfoPage

local infoCard = Instance.new("Frame")
infoCard.Size = UDim2.new(1, 0, 1, 0)
infoCard.BackgroundColor3 = CARD_BG
infoCard.BackgroundTransparency = 0.4
infoCard.ZIndex = 3
infoCard.Parent = InfoPage

local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(1, -20, 1, -20)
infoText.Position = UDim2.new(0, 10, 0, 10)
infoText.BackgroundTransparency = 1
infoText.Text = "DISCORD：shizuuw\nTWIN：Ant77\n版本：1.2 单色版\n\n我爱猫猫 🐾"
infoText.TextColor3 = TEXT_WHITE
infoText.TextSize = 12
infoText.Font = Enum.Font.Gotham
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.TextWrapped = true
infoText.ZIndex = 4
infoText.Parent = infoCard

MainPage.Visible = true

-- 模块构造器（卡片）
local function createTile(parent, name, code, description, onClick)
	local tile = Instance.new("Frame")
	tile.BackgroundColor3 = CARD_BG
	tile.BackgroundTransparency = 0.45
	tile.ZIndex = 3
	tile.Parent = parent
	
	local tileCorner = Instance.new("UICorner")
	tileCorner.CornerRadius = UDim.new(0, 8)
	tileCorner.Parent = tile
	
	local tileStroke = Instance.new("UIStroke")
	tileStroke.Color = BORDER_COLOR
	tileStroke.Thickness = 1
	tileStroke.Transparency = 0.4
	tileStroke.Parent = tile
	
	local titleLbl = Instance.new("TextLabel")
	titleLbl.Size = UDim2.new(1, 0, 0, 32)
	titleLbl.Position = UDim2.new(0, 0, 0, 4)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = name
	titleLbl.TextColor3 = TEXT_WHITE
	titleLbl.TextSize = 12
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.ZIndex = 4
	titleLbl.Parent = tile
	
	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Size = UDim2.new(1, -20, 0, 24)
	toggleBtn.Position = UDim2.new(0, 10, 1, -30)
	toggleBtn.BackgroundColor3 = COLOR_DISABLED
	toggleBtn.BackgroundTransparency = 0.2
	toggleBtn.Text = "已关闭"
	toggleBtn.TextColor3 = COLOR_DISABLED_TEXT
	toggleBtn.TextSize = 10
	toggleBtn.Font = Enum.Font.GothamBold
	toggleBtn.ZIndex = 5
	toggleBtn.Parent = tile
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 5)
	btnCorner.Parent = toggleBtn
	
	local state = false
	tile.MouseEnter:Connect(function() updateDetails(name, description) end)
	
	toggleBtn.MouseButton1Click:Connect(function()
		playClickSound()
		state = not state
		if state then
			toggleBtn.BackgroundColor3 = COLOR_ENABLED
			toggleBtn.TextColor3 = COLOR_ENABLED_TEXT
			toggleBtn.Text = "已开启"
			tileStroke.Color = ACCENT_WHITE
		else
			toggleBtn.BackgroundColor3 = COLOR_DISABLED
			toggleBtn.TextColor3 = COLOR_DISABLED_TEXT
			toggleBtn.Text = "已关闭"
			tileStroke.Color = BORDER_COLOR
		end
		if onClick then onClick(state, toggleBtn, tile) end
	end)
	
	return tile, toggleBtn
end

-- =======================================================
-- 严格的玩家 x 生物过滤
-- =======================================================
local function isPlayerCharacter(model)
	if not model or not model:IsA("Model") then return true end
	
	if Players:GetPlayerFromCharacter(model) then return true end
	
	if Player.Character and (model == Player.Character or model:IsDescendantOf(Player.Character)) then
		return true
	end
	
	for _, p in ipairs(Players:GetPlayers()) do
		if p.Character and (model == p.Character or model:IsDescendantOf(p.Character)) then
			return true
		end
		if model.Name == p.Name then
			return true
		end
	end
	
	local lowerName = model.Name:lower()
	if lowerName:find("viewmodel") or lowerName:find("menu") or lowerName:find("camera") or lowerName:find("display") or lowerName:find("avatar") then
		return true
	end
	
	return false
end

-- =======================================================
-- 1. 玩家透视 ESP（白色单色）
-- =======================================================
local espEnabled = false
local playerHighlights = {}

local function removePlayerESP(plr)
	if playerHighlights[plr] then
		playerHighlights[plr]:Destroy()
		playerHighlights[plr] = nil
	end
end

local function applyPlayerESP(plr)
	if not espEnabled or plr == Player then return end
	local character = plr.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return end

	if playerHighlights[plr] and playerHighlights[plr].Parent == character then return end
	removePlayerESP(plr)

	local hl = Instance.new("Highlight")
	hl.Name = "ShizukaPlayerESP"
	hl.FillColor = ACCENT_WHITE
	hl.OutlineColor = Color3.fromRGB(0, 0, 0)
	hl.FillTransparency = 0.4
	hl.OutlineTransparency = 0
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Parent = character

	playerHighlights[plr] = hl
end

local function setupPlayer(plr)
	if plr == Player then return end
	plr.CharacterAdded:Connect(function()
		task.wait(0.2)
		removePlayerESP(plr)
		if espEnabled then applyPlayerESP(plr) end
	end)
end

for _, plr in ipairs(Players:GetPlayers()) do setupPlayer(plr) end
Players.PlayerAdded:Connect(setupPlayer)
Players.PlayerRemoving:Connect(removePlayerESP)

createTile(MainPage, "玩家透视", "ESP_PLR", "扫描并追踪所有真实玩家的白色轮廓，可穿透建筑看见。", function(active)
	espEnabled = active
	if espEnabled then
		for _, plr in ipairs(Players:GetPlayers()) do applyPlayerESP(plr) end
	else
		for plr, _ in pairs(playerHighlights) do removePlayerESP(plr) end
	end
end)

-- =======================================================
-- 2. 生物透视 ESP（暗红色）
-- =======================================================
local mobEspEnabled = false

local function clearMobESP()
	for _, v in ipairs(workspace:GetDescendants()) do
		if v.Name == "Mob_Highlight" or v.Name == "Mob_HealthUI" then
			v:Destroy()
		end
	end
end

local function highlightAI(v)
	if not mobEspEnabled or not v:IsA("Model") then return end
	
	if isPlayerCharacter(v) then 
		if v:FindFirstChild("Mob_Highlight") then v.Mob_Highlight:Destroy() end
		if v:FindFirstChild("Mob_HealthUI") then v.Mob_HealthUI:Destroy() end
		return 
	end
	
	if v:FindFirstChild("Mob_Highlight") then return end

	local humanoid = v:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then return end

	local targetPart = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Head") or v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
	if not targetPart then return end

	local highlight = Instance.new("Highlight")
	highlight.Name = "Mob_Highlight"
	highlight.Adornee = v
	highlight.FillColor = Color3.fromRGB(120, 0, 0)
	highlight.FillTransparency = 0.75
	highlight.OutlineColor = Color3.fromRGB(180, 0, 0)
	highlight.OutlineTransparency = 0
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Enabled = true
	highlight.Parent = v

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "Mob_HealthUI"
	billboard.Adornee = targetPart
	billboard.Size = UDim2.new(0, 120, 0, 30)
	billboard.StudsOffset = Vector3.new(0, 3.5, 0)
	billboard.AlwaysOnTop = true
	billboard.Enabled = false
	billboard.Parent = v

	local textLabel = Instance.new("TextLabel")
	textLabel.Parent = billboard
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.TextColor3 = Color3.fromRGB(200, 30, 30)
	textLabel.TextStrokeTransparency = 0
	textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	textLabel.TextScaled = true
	textLabel.Font = Enum.Font.GothamBold

	task.spawn(function()
		while mobEspEnabled and v and v.Parent and humanoid do
			if humanoid.Health <= 0 then
				if highlight then highlight:Destroy() end
				if billboard then billboard:Destroy() end
				break
			end

			local camera = workspace.CurrentCamera
			local myChar = Player.Character
			local myPos = (myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Head"))) and myChar.HumanoidRootPart.Position or (camera and camera.CFrame.Position)

			if myPos and targetPart then
				local dist = (myPos - targetPart.Position).Magnitude
				if dist <= MAX_HP_DISTANCE then
					billboard.Enabled = true
					textLabel.Text = math.floor(humanoid.Health) .. " / " .. math.floor(humanoid.MaxHealth)
				else
					billboard.Enabled = false
				end
			else
				billboard.Enabled = false
			end

			task.wait(0.15)
		end
	end)
end

local function scanMobs()
	if not mobEspEnabled then return end
	for _, item in ipairs(workspace:GetDescendants()) do
		if item:IsA("Model") and item:FindFirstChildOfClass("Humanoid") then
			highlightAI(item)
		end
	end
end

createTile(MainPage, "生物透视", "ESP_MOB", "以暗红色高亮地图上的生物，仅在靠近时显示生命值。", function(active)
	mobEspEnabled = active
	if mobEspEnabled then
		scanMobs()
	else
		clearMobESP()
	end
end)

task.spawn(function()
	while true do
		if mobEspEnabled then
			scanMobs()
		end
		task.wait(1.5)
	end
end)

-- =======================================================
-- 3. 全亮
-- =======================================================
local fullbrightEnabled = false
local origLighting = {
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,
	GlobalShadows = Lighting.GlobalShadows,
	OutdoorAmbient = Lighting.OutdoorAmbient,
	Ambient = Lighting.Ambient
}

createTile(MainPage, "全亮", "LIGHT_01", "将环境亮度提升到最大值。", function(active)
	fullbrightEnabled = active
	if fullbrightEnabled then
		Lighting.GlobalShadows = false
		Lighting.Brightness = 2
		Lighting.ClockTime = 14
		Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
		Lighting.Ambient = Color3.fromRGB(200, 200, 200)
	else
		Lighting.GlobalShadows = origLighting.GlobalShadows
		Lighting.Brightness = origLighting.Brightness
		Lighting.ClockTime = origLighting.ClockTime
		Lighting.OutdoorAmbient = origLighting.OutdoorAmbient
		Lighting.Ambient = origLighting.Ambient
	end
end)

-- =======================================================
-- 4. 重置角色
-- =======================================================
createTile(MainPage, "重置角色", "RESET_01", "立即消灭你的角色，并播放重置音效。", function(active, toggleBtn, tile)
	if active then
		playResetSound()
		
		local char = Player.Character
		if char then
			local humanoid = char:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.Health = 0
			end
		end

		task.delay(0.5, function()
			if toggleBtn and toggleBtn.Parent then
				toggleBtn.BackgroundColor3 = COLOR_DISABLED
				toggleBtn.TextColor3 = COLOR_DISABLED_TEXT
				toggleBtn.Text = "已关闭"
				local stroke = tile:FindFirstChildOfClass("UIStroke")
				if stroke then stroke.Color = BORDER_COLOR end
			end
		end)
	end
end)

-- =======================================================
-- 5. 附加功能（第三人称、穿墙 与 关闭模糊）
-- =======================================================
local thirdPersonEnabled = false
local origCamMode, origMinZoom, origMaxZoom

local function toggleThirdPerson(state)
	thirdPersonEnabled = (state ~= nil and state) or not thirdPersonEnabled
	if thirdPersonEnabled then
		origCamMode = Player.CameraMode
		origMinZoom = Player.CameraMinZoomDistance
		origMaxZoom = Player.CameraMaxZoomDistance
		Player.CameraMode = Enum.CameraMode.Classic
		Player.CameraMinZoomDistance = 18
		Player.CameraMaxZoomDistance = math.max(Player.CameraMaxZoomDistance, 18)
	else
		if origCamMode then
			Player.CameraMode = origCamMode
			Player.CameraMinZoomDistance = origMinZoom
			Player.CameraMaxZoomDistance = origMaxZoom
		end
	end
end

createTile(ExtrasPage, "第三人称", "CAM_TP", "强制将视角切换为第三人称。", function(active)
	toggleThirdPerson(active)
end)

local noclipEnabled = false
createTile(ExtrasPage, "穿墙", "PHYS_01", "关闭角色的物理碰撞。", function(active)
	noclipEnabled = active
end)

-- 关闭背景模糊模块
createTile(ExtrasPage, "关闭模糊", "BLUR_OFF", "当界面打开时，关闭游戏背景的模糊效果。", function(active)
	blurEnabled = not active
	if not blurEnabled then
		TweenService:Create(MenuBlur, TweenInfo.new(0.2), { Size = 0 }):Play()
	else
		if MainFrame.Visible then
			TweenService:Create(MenuBlur, TweenInfo.new(0.3), { Size = 24 }):Play()
		end
	end
end)

RunService.Stepped:Connect(function()
	if noclipEnabled and Player.Character then
		for _, part in ipairs(Player.Character:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide = false end
		end
	end
end)

-- =======================================================
-- 按键绑定 与 标签页系统
-- =======================================================
local function createKeybindTile(parent, name, currentKey, onRebind)
	local tile = Instance.new("Frame")
	tile.BackgroundColor3 = CARD_BG
	tile.BackgroundTransparency = 0.45
	tile.ZIndex = 3
	tile.Parent = parent
	
	local tileCorner = Instance.new("UICorner")
	tileCorner.CornerRadius = UDim.new(0, 8)
	tileCorner.Parent = tile
	
	local titleLbl = Instance.new("TextLabel")
	titleLbl.Size = UDim2.new(1, -10, 0, 25)
	titleLbl.Position = UDim2.new(0, 10, 0, 5)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = name
	titleLbl.TextColor3 = TEXT_WHITE
	titleLbl.TextSize = 11
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.ZIndex = 4
	titleLbl.Parent = tile
	
	local bindBtn = Instance.new("TextButton")
	bindBtn.Size = UDim2.new(1, -20, 0, 28)
	bindBtn.Position = UDim2.new(0, 10, 0, 35)
	bindBtn.BackgroundColor3 = PANEL_BG
	bindBtn.BackgroundTransparency = 0.4
	bindBtn.Text = "[ " .. currentKey.Name .. " ]"
	bindBtn.TextColor3 = ACCENT_WHITE
	bindBtn.TextSize = 11
	bindBtn.Font = Enum.Font.GothamBold
	bindBtn.ZIndex = 4
	bindBtn.Parent = tile
	
	bindBtn.MouseButton1Click:Connect(function()
		playClickSound()
		bindBtn.Text = "[ 请按键... ]"
		bindBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
		onRebind(function(newKey)
			bindBtn.Text = "[ " .. newKey.Name .. " ]"
			bindBtn.TextColor3 = ACCENT_WHITE
		end)
	end)
end

createKeybindTile(KeybindPage, "菜单开关按键", toggleKey, function(setKey)
	isBinding = true
	local conn
	conn = UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			toggleKey = input.KeyCode
			isBinding = false
			setKey(toggleKey)
			conn:Disconnect()
		end
	end)
end)

createKeybindTile(KeybindPage, "第三人称按键", tpToggleKey, function(setKey)
	isBindingTP = true
	local conn
	conn = UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			tpToggleKey = input.KeyCode
			isBindingTP = false
			setKey(tpToggleKey)
			conn:Disconnect()
		end
	end)
end)

local function switchTab(selectedBtn, pageName)
	playClickSound()
	for name, page in pairs(Pages) do
		page.Visible = (name == pageName)
	end
	
	local btns = {MainTabBtn, ExtrasTabBtn, KeybindTabBtn, InfoTabBtn}
	for _, b in ipairs(btns) do b.TextColor3 = TEXT_MUTED end
	selectedBtn.TextColor3 = TEXT_WHITE
end

MainTabBtn.MouseButton1Click:Connect(function() switchTab(MainTabBtn, "Main") end)
ExtrasTabBtn.MouseButton1Click:Connect(function() switchTab(ExtrasTabBtn, "Extras") end)
KeybindTabBtn.MouseButton1Click:Connect(function() switchTab(KeybindTabBtn, "Keybind") end)
InfoTabBtn.MouseButton1Click:Connect(function() switchTab(InfoTabBtn, "Info") end)

for name, page in pairs(Pages) do page.Visible = (name == "Main") end
MainTabBtn.TextColor3 = TEXT_WHITE

-- 浮动移动端按钮
local OpenButton = Instance.new("ImageButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.new(0, 52, 0, 52)
OpenButton.Position = UDim2.new(0, 15, 0.5, -26)
OpenButton.BackgroundColor3 = DARK_BG
OpenButton.BackgroundTransparency = 0.2
OpenButton.Image = MOBILE_BTN_IMAGE_ID
OpenButton.ScaleType = Enum.ScaleType.Fit
OpenButton.Visible = false
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 12)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = ACCENT_GREY
OpenStroke.Thickness = 1.2
OpenStroke.Transparency = 0.3
OpenStroke.Parent = OpenButton

local function toggleUI(isOpen)
	if isOpen then
		OpenButton.Visible = false
		MainFrame.Size = zeroSize
		MainFrame.Visible = true
		if blurEnabled then
			TweenService:Create(MenuBlur, TweenInfo.new(0.3), { Size = 24 }):Play()
		else
			MenuBlur.Size = 0
		end
		TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = fullSize }):Play()
	else
		TweenService:Create(MenuBlur, TweenInfo.new(0.2), { Size = 0 }):Play()
		local tw = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Size = zeroSize })
		tw:Play()
		tw.Completed:Connect(function()
			MainFrame.Visible = false
			OpenButton.Visible = true
		end)
	end
end

CloseButton.MouseButton1Click:Connect(function() 
	playClickSound()
	toggleUI(false) 
end)

OpenButton.MouseButton1Click:Connect(function() 
	playClickSound()
	toggleUI(true) 
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if isBinding or isBindingTP or gameProcessed then return end
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == toggleKey then
			toggleUI(not MainFrame.Visible)
		elseif input.KeyCode == tpToggleKey then
			toggleThirdPerson()
		end
	end
end)

-- =======================================================
-- 开场动画
-- =======================================================
local function playIntroAnimation()
	local IntroContainer = Instance.new("Frame")
	IntroContainer.Name = "ShizukaIntroContainer"
	IntroContainer.AnchorPoint = Vector2.new(0.5, 0.5)
	IntroContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
	IntroContainer.Size = UDim2.new(0, 220, 0, 60)
	IntroContainer.BackgroundTransparency = 1
	IntroContainer.ZIndex = 100
	IntroContainer.Parent = ScreenGui

	local IntroText = Instance.new("TextLabel")
	IntroText.Name = "ShizukaIntroText"
	IntroText.Size = UDim2.new(1, 0, 0, 30)
	IntroText.Position = UDim2.new(0, 0, 0, 0)
	IntroText.BackgroundTransparency = 1
	IntroText.Text = "静香"
	IntroText.TextColor3 = Color3.fromRGB(255, 255, 255)
	IntroText.Font = Enum.Font.GothamBold
	IntroText.TextSize = 26
	IntroText.TextTransparency = 1
	IntroText.ZIndex = 101
	IntroText.Parent = IntroContainer

	local IntroStroke = Instance.new("UIStroke")
	IntroStroke.Color = Color3.fromRGB(0, 0, 0)
	IntroStroke.Thickness = 2
	IntroStroke.Transparency = 1
	IntroStroke.Parent = IntroText

	local LoadingBackground = Instance.new("Frame")
	LoadingBackground.Name = "LoadingBackground"
	LoadingBackground.AnchorPoint = Vector2.new(0.5, 0)
	LoadingBackground.Position = UDim2.new(0.5, 0, 0, 36)
	LoadingBackground.Size = UDim2.new(0, 140, 0, 3)
	LoadingBackground.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	LoadingBackground.BackgroundTransparency = 1
	LoadingBackground.BorderSizePixel = 0
	LoadingBackground.ZIndex = 101
	LoadingBackground.Parent = IntroContainer

	local LoadingBgCorner = Instance.new("UICorner")
	LoadingBgCorner.CornerRadius = UDim.new(1, 0)
	LoadingBgCorner.Parent = LoadingBackground

	local LoadingBgStroke = Instance.new("UIStroke")
	LoadingBgStroke.Color = Color3.fromRGB(255, 255, 255)
	LoadingBgStroke.Thickness = 1
	LoadingBgStroke.Transparency = 1
	LoadingBgStroke.Parent = LoadingBackground

	local LoadingFill = Instance.new("Frame")
	LoadingFill.Name = "LoadingFill"
	LoadingFill.Size = UDim2.new(0, 0, 1, 0)
	LoadingFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LoadingFill.BorderSizePixel = 0
	LoadingFill.ZIndex = 102
	LoadingFill.Parent = LoadingBackground

	local LoadingFillCorner = Instance.new("UICorner")
	LoadingFillCorner.CornerRadius = UDim.new(1, 0)
	LoadingFillCorner.Parent = LoadingFill

	local IntroScale = Instance.new("UIScale")
	IntroScale.Scale = 0.85
	IntroScale.Parent = IntroContainer

	SoundService:PlayLocalSound(IntroSound)

	local fadeIn = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	TweenService:Create(IntroText, fadeIn, { TextTransparency = 0 }):Play()
	TweenService:Create(IntroStroke, fadeIn, { Transparency = 0 }):Play()
	TweenService:Create(LoadingBackground, fadeIn, { BackgroundTransparency = 0.4 }):Play()
	TweenService:Create(LoadingBgStroke, fadeIn, { Transparency = 0.5 }):Play()
	TweenService:Create(IntroScale, fadeIn, { Scale = 1 }):Play()

	local loadingTween = TweenService:Create(LoadingFill, TweenInfo.new(3.0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 1, 0) })
	loadingTween:Play()
	loadingTween.Completed:Wait()

	task.wait(0.5)

	local fadeOut = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
	TweenService:Create(IntroText, fadeOut, { TextTransparency = 1 }):Play()
	TweenService:Create(IntroStroke, fadeOut, { Transparency = 1 }):Play()
	TweenService:Create(LoadingBackground, fadeOut, { BackgroundTransparency = 1 }):Play()
	TweenService:Create(LoadingBgStroke, fadeOut, { Transparency = 1 }):Play()
	TweenService:Create(LoadingFill, fadeOut, { BackgroundTransparency = 1 }):Play()
	TweenService:Create(IntroScale, fadeOut, { Scale = 1.05 }):Play()

	task.wait(0.5)

	IntroContainer:Destroy()

	toggleUI(true)
end

-- 执行时启动开场动画
task.spawn(playIntroAnimation)