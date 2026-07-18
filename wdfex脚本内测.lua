--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.9) ~  Much Love, Ferib 

]]--

repeat
	task.wait();
until game:IsLoaded() 
local player = game.Players.LocalPlayer;
local bin = {dropdown={},playernamedied=""};
local function shuaxinlb()
	bin.dropdown = {};
	for _, v in pairs(game.Players:GetPlayers()) do
		if (v ~= player) then
			table.insert(bin.dropdown, v.Name);
		end
	end
end
shuaxinlb();
local library = {};
local ToggleUI = false;
library.currentTab = nil;
library.flags = {};
local services = setmetatable({}, {__index=function(t, k)
	return game.GetService(game, k);
end});
local mouse = services.Players.LocalPlayer:GetMouse();
function Tween(obj, t, data)
	local FlatIdent_2584C = 0;
	while true do
		if (FlatIdent_2584C == 0) then
			services.TweenService:Create(obj, TweenInfo.new(t[1], Enum.EasingStyle[t[2]], Enum.EasingDirection[t[3]]), data):Play();
			return true;
		end
	end
end
function Ripple(obj)
	spawn(function()
		local FlatIdent_378D0 = 0;
		local Ripple;
		while true do
			if (FlatIdent_378D0 == 2) then
				Ripple.ImageTransparency = 0.8;
				Ripple.ScaleType = Enum.ScaleType.Fit;
				Ripple.ImageColor3 = Color3.fromRGB(255, 255, 255);
				Ripple.Position = UDim2.new((mouse.X - Ripple.AbsolutePosition.X) / obj.AbsoluteSize.X, 0, (mouse.Y - Ripple.AbsolutePosition.Y) / obj.AbsoluteSize.Y, 0);
				FlatIdent_378D0 = 3;
			end
			if (FlatIdent_378D0 == 1) then
				Ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				Ripple.BackgroundTransparency = 1;
				Ripple.ZIndex = 8;
				Ripple.Image = "rbxassetid://2708891598";
				FlatIdent_378D0 = 2;
			end
			if (3 == FlatIdent_378D0) then
				Tween(Ripple, {0.3,"Linear","InOut"}, {Position=UDim2.new(-5.5, 0, -5.5, 0),Size=UDim2.new(12, 0, 12, 0)});
				wait(0.15);
				Tween(Ripple, {0.3,"Linear","InOut"}, {ImageTransparency=1});
				wait(0.3);
				FlatIdent_378D0 = 4;
			end
			if (FlatIdent_378D0 == 0) then
				if (obj.ClipsDescendants ~= true) then
					obj.ClipsDescendants = true;
				end
				Ripple = Instance.new("ImageLabel");
				Ripple.Name = "Ripple";
				Ripple.Parent = obj;
				FlatIdent_378D0 = 1;
			end
			if (FlatIdent_378D0 == 4) then
				Ripple:Destroy();
				break;
			end
		end
	end);
end
local toggled = false;
local switchingTabs = false;
function switchTab(new)
	if switchingTabs then
		return;
	end
	local old = library.currentTab;
	if (old == nil) then
		local FlatIdent_475BC = 0;
		while true do
			if (FlatIdent_475BC == 2) then
				return;
			end
			if (FlatIdent_475BC == 0) then
				new[2].Visible = true;
				library.currentTab = new;
				FlatIdent_475BC = 1;
			end
			if (FlatIdent_475BC == 1) then
				services.TweenService:Create(new[1], TweenInfo.new(0.1), {ImageTransparency=0}):Play();
				services.TweenService:Create(new[1].TabText, TweenInfo.new(0.1), {TextTransparency=0}):Play();
				FlatIdent_475BC = 2;
			end
		end
	end
	if (old[1] == new[1]) then
		return;
	end
	switchingTabs = true;
	library.currentTab = new;
	services.TweenService:Create(old[1], TweenInfo.new(0.1), {ImageTransparency=0.2}):Play();
	services.TweenService:Create(new[1], TweenInfo.new(0.1), {ImageTransparency=0}):Play();
	services.TweenService:Create(old[1].TabText, TweenInfo.new(0.1), {TextTransparency=0.2}):Play();
	services.TweenService:Create(new[1].TabText, TweenInfo.new(0.1), {TextTransparency=0}):Play();
	old[2].Visible = false;
	new[2].Visible = true;
	task.wait(0.1);
	switchingTabs = false;
end
function drag(frame, hold)
	if not hold then
		hold = frame;
	end
	local dragging;
	local dragInput;
	local dragStart;
	local startPos;
	local function update(input)
		local FlatIdent_7DD24 = 0;
		local delta;
		while true do
			if (FlatIdent_7DD24 == 0) then
				delta = input.Position - dragStart;
				frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y);
				break;
			end
		end
	end
	hold.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1) then
			local FlatIdent_781F8 = 0;
			while true do
				if (FlatIdent_781F8 == 0) then
					dragging = true;
					dragStart = input.Position;
					FlatIdent_781F8 = 1;
				end
				if (1 == FlatIdent_781F8) then
					startPos = frame.Position;
					input.Changed:Connect(function()
						if (input.UserInputState == Enum.UserInputState.End) then
							dragging = false;
						end
					end);
					break;
				end
			end
		end
	end);
	frame.InputChanged:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseMovement) then
			dragInput = input;
		end
	end);
	services.UserInputService.InputChanged:Connect(function(input)
		if ((input == dragInput) and dragging) then
			update(input);
		end
	end);
end
library.new = function(library, name, theme)
	for _, v in next, services.CoreGui:GetChildren() do
		if (v.Name == "frosty") then
			v:Destroy();
		end
	end
	if (theme == "dark") then
		local FlatIdent_49AED = 0;
		while true do
			if (FlatIdent_49AED == 1) then
				zyColor = Color3.fromRGB(25, 25, 25);
				beijingColor = Color3.fromRGB(25, 25, 25);
				break;
			end
			if (FlatIdent_49AED == 0) then
				MainColor = Color3.fromRGB(25, 25, 25);
				Background = Color3.fromRGB(25, 25, 25);
				FlatIdent_49AED = 1;
			end
		end
	else
		MainColor = Color3.fromRGB(25, 25, 25);
		Background = Color3.fromRGB(25, 25, 25);
		zyColor = Color3.fromRGB(30, 30, 30);
		beijingColor = Color3.fromRGB(255, 255, 255);
	end
	local dogent = Instance.new("ScreenGui");
	local Main = Instance.new("Frame");
	local TabMain = Instance.new("Frame");
	local MainC = Instance.new("UICorner");
	local SB = Instance.new("Frame");
	local SBC = Instance.new("UICorner");
	local Side = Instance.new("Frame");
	local SideG = Instance.new("UIGradient");
	local TabBtns = Instance.new("ScrollingFrame");
	local TabBtnsL = Instance.new("UIListLayout");
	local ScriptTitle = Instance.new("TextLabel");
	local SBG = Instance.new("UIGradient");
	local Open = Instance.new("TextButton");
	local UIG = Instance.new("UIGradient");
	local DropShadowHolder = Instance.new("Frame");
	local DropShadow = Instance.new("ImageLabel");
	local UICornerMain = Instance.new("UICorner");
	local UIGradient = Instance.new("UIGradient");
	local UIGradientTitle = Instance.new("UIGradient");
	if (syn and syn.protect_gui) then
		syn.protect_gui(dogent);
	end
	dogent.Name = "frosty";
	dogent.Parent = services.CoreGui;
	function UiDestroy()
		dogent:Destroy();
	end
	function ToggleUILib()
		if not ToggleUI then
			local FlatIdent_65290 = 0;
			while true do
				if (FlatIdent_65290 == 0) then
					dogent.Enabled = false;
					ToggleUI = true;
					break;
				end
			end
		else
			local FlatIdent_7A75F = 0;
			while true do
				if (FlatIdent_7A75F == 0) then
					ToggleUI = false;
					dogent.Enabled = true;
					break;
				end
			end
		end
	end
	Main.Name = "Main";
	Main.Parent = dogent;
	Main.AnchorPoint = Vector2.new(0.5, 0.5);
	Main.BackgroundColor3 = Background;
	Main.BorderColor3 = MainColor;
	Main.Position = UDim2.new(0.5, 0, 0.5, 0);
	Main.Size = UDim2.new(0, 572, 0, 353);
	Main.ZIndex = 1;
	Main.Active = true;
	Main.Draggable = true;
	Main.Style = "DropShadow";
	services.UserInputService.InputEnded:Connect(function(input)
		if (input.KeyCode == Enum.KeyCode.LeftControl) then
			if (Main.Visible == true) then
				Main.Visible = false;
			else
				Main.Visible = true;
			end
		end
	end);
	drag(Main);
	UICornerMain.Parent = Main;
	UICornerMain.CornerRadius = UDim.new(0, 3);
	DropShadowHolder.Name = "DropShadowHolder";
	DropShadowHolder.Parent = Main;
	DropShadowHolder.BackgroundTransparency = 1;
	DropShadowHolder.BorderSizePixel = 0;
	DropShadowHolder.Size = UDim2.new(1, 0, 1, 0);
	DropShadowHolder.BorderColor3 = Color3.fromRGB(255, 255, 255);
	DropShadowHolder.ZIndex = 0;
	DropShadow.Name = "DropShadow";
	DropShadow.Parent = DropShadowHolder;
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5);
	DropShadow.BackgroundTransparency = 1;
	DropShadow.BorderSizePixel = 0;
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0);
	DropShadow.Size = UDim2.new(1, 43, 1, 43);
	DropShadow.ZIndex = 0;
	DropShadow.Image = "rbxassetid://6015897843";
	DropShadow.ImageColor3 = Color3.fromRGB(255, 255, 255);
	DropShadow.ImageTransparency = 0.5;
	DropShadow.ScaleType = Enum.ScaleType.Slice;
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450);
	UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),ColorSequenceKeypoint.new(0.1, Color3.fromRGB(255, 127, 0)),ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 255, 0)),ColorSequenceKeypoint.new(0.3, Color3.fromRGB(0, 255, 0)),ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 255, 255)),ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 255)),ColorSequenceKeypoint.new(0.6, Color3.fromRGB(139, 0, 255)),ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 0, 0)),ColorSequenceKeypoint.new(0.8, Color3.fromRGB(255, 127, 0)),ColorSequenceKeypoint.new(0.9, Color3.fromRGB(255, 255, 0)),ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 0))});
	UIGradient.Parent = DropShadow;
	local TweenService = game:GetService("TweenService");
	local tweeninfo = TweenInfo.new(7, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1);
	local tween = TweenService:Create(UIGradient, tweeninfo, {Rotation=360});
	tween:Play();
	function toggleui()
		local FlatIdent_1B1BA = 0;
		while true do
			if (FlatIdent_1B1BA == 0) then
				toggled = not toggled;
				spawn(function()
					if toggled then
						wait(0.3);
					end
				end);
				FlatIdent_1B1BA = 1;
			end
			if (FlatIdent_1B1BA == 1) then
				Tween(Main, {0.3,"Sine","InOut"}, {Size=UDim2.new(0, 609, 0, (toggled and 505) or 0)});
				break;
			end
		end
	end
	TabMain.Name = "TabMain";
	TabMain.Parent = Main;
	TabMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	TabMain.BackgroundTransparency = 1;
	TabMain.Position = UDim2.new(0.217000037, 0, 0, 3);
	TabMain.Size = UDim2.new(0, 448, 0, 353);
	MainC.CornerRadius = UDim.new(0, 5.5);
	MainC.Name = "MainC";
	MainC.Parent = Frame;
	SB.Name = "SB";
	SB.Parent = Main;
	SB.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	SB.BorderColor3 = MainColor;
	SB.Size = UDim2.new(0, 8, 0, 353);
	SBC.CornerRadius = UDim.new(0, 6);
	SBC.Name = "SBC";
	SBC.Parent = SB;
	Side.Name = "Side";
	Side.Parent = SB;
	Side.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	Side.BorderColor3 = Color3.fromRGB(255, 255, 255);
	Side.BorderSizePixel = 0;
	Side.ClipsDescendants = true;
	Side.Position = UDim2.new(1, 0, 0, 0);
	Side.Size = UDim2.new(0, 110, 0, 353);
	SideG.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, zyColor),ColorSequenceKeypoint.new(1, zyColor)});
	SideG.Rotation = 90;
	SideG.Name = "SideG";
	SideG.Parent = Side;
	TabBtns.Name = "TabBtns";
	TabBtns.Parent = Side;
	TabBtns.Active = true;
	TabBtns.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	TabBtns.BackgroundTransparency = 1;
	TabBtns.BorderSizePixel = 0;
	TabBtns.Position = UDim2.new(0, 0, 0.0973535776, 0);
	TabBtns.Size = UDim2.new(0, 110, 0, 318);
	TabBtns.CanvasSize = UDim2.new(0, 0, 1, 0);
	TabBtns.ScrollBarThickness = 0;
	TabBtnsL.Name = "TabBtnsL";
	TabBtnsL.Parent = TabBtns;
	TabBtnsL.SortOrder = Enum.SortOrder.LayoutOrder;
	TabBtnsL.Padding = UDim.new(0, 12);
	ScriptTitle.Name = "ScriptTitle";
	ScriptTitle.Parent = Side;
	ScriptTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	ScriptTitle.BackgroundTransparency = 1;
	ScriptTitle.Position = UDim2.new(0, 0, 0.00953488424, 0);
	ScriptTitle.Size = UDim2.new(0, 102, 0, 20);
	ScriptTitle.Font = Enum.Font.GothamSemibold;
	ScriptTitle.Text = name;
	ScriptTitle.TextColor3 = Color3.fromRGB(255, 255, 255);
	ScriptTitle.TextSize = 14;
	ScriptTitle.TextScaled = true;
	ScriptTitle.TextXAlignment = Enum.TextXAlignment.Left;
	UIGradientTitle.Parent = ScriptTitle;
	local function NPLHKB_fake_script()
		local script = Instance.new("LocalScript", ScriptTitle);
		local button = script.Parent;
		local gradient = button.UIGradient;
		local ts = game:GetService("TweenService");
		local ti = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
		local offset = {Offset=Vector2.new(1, 0)};
		local create = ts:Create(gradient, ti, offset);
		local startingPos = Vector2.new(-1, 0);
		local list = {};
		local s, kpt = ColorSequence.new, ColorSequenceKeypoint.new;
		local counter = 0;
		local status = "down";
		gradient.Offset = startingPos;
		local function rainbowColors()
			local sat, val = 255, 255;
			for i = 1, 10 do
				local hue = i * 17;
				table.insert(list, Color3.fromHSV(hue / 255, sat / 255, val / 255));
			end
		end
		rainbowColors();
		gradient.Color = s({kpt(0, list[#list]),kpt(0.5, list[#list - 1]),kpt(1, list[#list - 2])});
		counter = #list;
		local function animate()
			create:Play();
			create.Completed:Wait();
			gradient.Offset = startingPos;
			gradient.Rotation = 180;
			if ((counter == (#list - 1)) and (status == "down")) then
				gradient.Color = s({kpt(0, gradient.Color.Keypoints[1].Value),kpt(0.5, list[#list]),kpt(1, list[1])});
				counter = 1;
				status = "up";
			elseif ((counter == #list) and (status == "down")) then
				local FlatIdent_6B983 = 0;
				while true do
					if (FlatIdent_6B983 == 1) then
						status = "up";
						break;
					end
					if (FlatIdent_6B983 == 0) then
						gradient.Color = s({kpt(0, gradient.Color.Keypoints[1].Value),kpt(0.5, list[1]),kpt(1, list[2])});
						counter = 2;
						FlatIdent_6B983 = 1;
					end
				end
			elseif ((counter <= (#list - 2)) and (status == "down")) then
				local FlatIdent_287B5 = 0;
				while true do
					if (FlatIdent_287B5 == 0) then
						gradient.Color = s({kpt(0, gradient.Color.Keypoints[1].Value),kpt(0.5, list[counter + 1]),kpt(1, list[counter + 2])});
						counter = counter + 2;
						FlatIdent_287B5 = 1;
					end
					if (FlatIdent_287B5 == 1) then
						status = "up";
						break;
					end
				end
			end
			create:Play();
			create.Completed:Wait();
			gradient.Offset = startingPos;
			gradient.Rotation = 0;
			if ((counter == (#list - 1)) and (status == "up")) then
				local FlatIdent_D79D = 0;
				while true do
					if (0 == FlatIdent_D79D) then
						gradient.Color = s({kpt(0, list[1]),kpt(0.5, list[#list]),kpt(1, gradient.Color.Keypoints[3].Value)});
						counter = 1;
						FlatIdent_D79D = 1;
					end
					if (FlatIdent_D79D == 1) then
						status = "down";
						break;
					end
				end
			elseif ((counter == #list) and (status == "up")) then
				local FlatIdent_28F1 = 0;
				while true do
					if (0 == FlatIdent_28F1) then
						gradient.Color = s({kpt(0, list[2]),kpt(0.5, list[1]),kpt(1, gradient.Color.Keypoints[3].Value)});
						counter = 2;
						FlatIdent_28F1 = 1;
					end
					if (1 == FlatIdent_28F1) then
						status = "down";
						break;
					end
				end
			elseif ((counter <= (#list - 2)) and (status == "up")) then
				local FlatIdent_5477B = 0;
				while true do
					if (1 == FlatIdent_5477B) then
						status = "down";
						break;
					end
					if (FlatIdent_5477B == 0) then
						gradient.Color = s({kpt(0, list[counter + 2]),kpt(0.5, list[counter + 1]),kpt(1, gradient.Color.Keypoints[3].Value)});
						counter = counter + 2;
						FlatIdent_5477B = 1;
					end
				end
			end
			animate();
		end
		animate();
	end
	coroutine.wrap(NPLHKB_fake_script)();
	SBG.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, zyColor),ColorSequenceKeypoint.new(1, zyColor)});
	SBG.Rotation = 90;
	SBG.Name = "SBG";
	SBG.Parent = SB;
	TabBtnsL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		TabBtns.CanvasSize = UDim2.new(0, 0, 0, TabBtnsL.AbsoluteContentSize.Y + 18);
	end);
	local Open = Instance.new("ImageButton");
	local REN = Instance.new("UICorner");
	local UIG = Instance.new("UIGradient");
	Open.Name = "Open";
	Open.Parent = dogent;
	Open.BackgroundColor3 = Color3.fromRGB(25, 25, 25);
	Open.Position = UDim2.new(0.00829315186, 0, 0.31107837, 0);
	Open.Size = UDim2.new(0, 48, 0, 48);
	Open.BorderColor3 = Color3.fromRGB(0, 0, 0);
	Open.Image = "rbxassetid://92427963906770";
	Open.Active = true;
	Open.Draggable = true;
	REN.CornerRadius = UDim.new(0, 360);
	REN.Parent = Open;
	UIG.Parent = Open;
	local TweenService = game:GetService("TweenService");
	local function shake()
		local FlatIdent_7F121 = 0;
		local startPos;
		while true do
			if (FlatIdent_7F121 == 0) then
				startPos = Open.Position;
				for i = 1, 5 do
					local offset = UDim2.new(0, math.random(-2, 2), 0, math.random(-2, 2));
					TweenService:Create(Open, TweenInfo.new(0.02), {Position=(startPos + offset)}):Play();
					task.wait(0.02);
				end
				FlatIdent_7F121 = 1;
			end
			if (FlatIdent_7F121 == 1) then
				TweenService:Create(Open, TweenInfo.new(0.05), {Position=startPos}):Play();
				break;
			end
		end
	end
	local function spawnParticles()
		local FlatIdent_29E69 = 0;
		local Particle;
		while true do
			if (FlatIdent_29E69 == 1) then
				Particle.Texture = "rbxassetid://154966924";
				Particle.Lifetime = NumberRange.new(0.3, 0.5);
				FlatIdent_29E69 = 2;
			end
			if (FlatIdent_29E69 == 0) then
				Particle = Instance.new("ParticleEmitter");
				Particle.Parent = Open;
				FlatIdent_29E69 = 1;
			end
			if (4 == FlatIdent_29E69) then
				task.wait(0.5);
				Particle:Destroy();
				break;
			end
			if (FlatIdent_29E69 == 2) then
				Particle.Speed = NumberRange.new(10, 20);
				Particle.SpreadAngle = Vector2.new(360, 360);
				FlatIdent_29E69 = 3;
			end
			if (3 == FlatIdent_29E69) then
				Particle.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5),NumberSequenceKeypoint.new(1, 0)});
				Particle.Enabled = true;
				FlatIdent_29E69 = 4;
			end
		end
	end
	Open.MouseButton1Click:Connect(function()
		local FlatIdent_90A41 = 0;
		while true do
			if (FlatIdent_90A41 == 1) then
				spawnParticles();
				break;
			end
			if (FlatIdent_90A41 == 0) then
				Main.Visible = not Main.Visible;
				shake();
				FlatIdent_90A41 = 1;
			end
		end
	end);
	local window = {};
	window.Tab = function(window, name, icon)
		local FlatIdent_7DFA5 = 0;
		local Tab;
		local TabIco;
		local TabText;
		local TabBtn;
		local TabL;
		local tab;
		while true do
			if (FlatIdent_7DFA5 == 0) then
				Tab = Instance.new("ScrollingFrame");
				TabIco = Instance.new("ImageLabel");
				TabText = Instance.new("TextLabel");
				TabBtn = Instance.new("TextButton");
				TabL = Instance.new("UIListLayout");
				FlatIdent_7DFA5 = 1;
			end
			if (FlatIdent_7DFA5 == 3) then
				TabIco.BackgroundTransparency = 1;
				TabIco.BorderSizePixel = 0;
				TabIco.Size = UDim2.new(0, 24, 0, 24);
				TabIco.Image = ("rbxassetid://%s"):format(icon or 4370341699);
				TabIco.ImageTransparency = 0.2;
				FlatIdent_7DFA5 = 4;
			end
			if (FlatIdent_7DFA5 == 7) then
				TabBtn.BackgroundTransparency = 1;
				TabBtn.BorderSizePixel = 0;
				TabBtn.Size = UDim2.new(0, 110, 0, 24);
				TabBtn.AutoButtonColor = false;
				TabBtn.Font = Enum.Font.SourceSans;
				FlatIdent_7DFA5 = 8;
			end
			if (FlatIdent_7DFA5 == 1) then
				Tab.Name = "Tab";
				Tab.Parent = TabMain;
				Tab.Active = true;
				Tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				Tab.BackgroundTransparency = 1;
				FlatIdent_7DFA5 = 2;
			end
			if (FlatIdent_7DFA5 == 8) then
				TabBtn.Text = "";
				TabBtn.TextColor3 = Color3.fromRGB(0, 0, 0);
				TabBtn.TextSize = 14;
				TabL.Name = "TabL";
				TabL.Parent = Tab;
				FlatIdent_7DFA5 = 9;
			end
			if (FlatIdent_7DFA5 == 4) then
				TabText.Name = "TabText";
				TabText.Parent = TabIco;
				TabText.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				TabText.BackgroundTransparency = 1;
				TabText.Position = UDim2.new(1.41666663, 0, 0, 0);
				FlatIdent_7DFA5 = 5;
			end
			if (FlatIdent_7DFA5 == 2) then
				Tab.Size = UDim2.new(1, 0, 1, 0);
				Tab.ScrollBarThickness = 2;
				Tab.Visible = false;
				TabIco.Name = "TabIco";
				TabIco.Parent = TabBtns;
				FlatIdent_7DFA5 = 3;
			end
			if (FlatIdent_7DFA5 == 10) then
				tab = {};
				tab.section = function(tab, name, TabVal)
					local Section = Instance.new("Frame");
					local SectionC = Instance.new("UICorner");
					local SectionText = Instance.new("TextLabel");
					local SectionOpen = Instance.new("ImageLabel");
					local SectionOpened = Instance.new("ImageLabel");
					local SectionToggle = Instance.new("ImageButton");
					local Objs = Instance.new("Frame");
					local ObjsL = Instance.new("UIListLayout");
					Section.Name = "Section";
					Section.Parent = Tab;
					Section.BackgroundColor3 = zyColor;
					Section.BackgroundTransparency = 1;
					Section.BorderSizePixel = 0;
					Section.ClipsDescendants = true;
					Section.Size = UDim2.new(0.981000006, 0, 0, 36);
					SectionC.CornerRadius = UDim.new(0, 6);
					SectionC.Name = "SectionC";
					SectionC.Parent = Section;
					SectionText.Name = "SectionText";
					SectionText.Parent = Section;
					SectionText.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
					SectionText.BackgroundTransparency = 1;
					SectionText.Position = UDim2.new(0.0887396261, 0, 0, 0);
					SectionText.Size = UDim2.new(0, 401, 0, 36);
					SectionText.Font = Enum.Font.GothamSemibold;
					SectionText.Text = name;
					SectionText.TextColor3 = Color3.fromRGB(255, 255, 255);
					SectionText.TextSize = 16;
					SectionText.TextXAlignment = Enum.TextXAlignment.Left;
					SectionOpen.Name = "SectionOpen";
					SectionOpen.Parent = SectionText;
					SectionOpen.BackgroundTransparency = 1;
					SectionOpen.BorderSizePixel = 0;
					SectionOpen.Position = UDim2.new(0, -33, 0, 5);
					SectionOpen.Size = UDim2.new(0, 26, 0, 26);
					SectionOpen.Image = "http://www.roblox.com/asset/?id=6031302934";
					SectionOpened.Name = "SectionOpened";
					SectionOpened.Parent = SectionOpen;
					SectionOpened.BackgroundTransparency = 1;
					SectionOpened.BorderSizePixel = 0;
					SectionOpened.Size = UDim2.new(0, 26, 0, 26);
					SectionOpened.Image = "http://www.roblox.com/asset/?id=1687426335";
					SectionOpened.ImageTransparency = 1;
					SectionToggle.Name = "SectionToggle";
					SectionToggle.Parent = SectionOpen;
					SectionToggle.BackgroundTransparency = 1;
					SectionToggle.BorderSizePixel = 0;
					SectionToggle.Size = UDim2.new(0, 26, 0, 26);
					Objs.Name = "Objs";
					Objs.Parent = Section;
					Objs.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
					Objs.BackgroundTransparency = 1;
					Objs.BorderSizePixel = 0;
					Objs.Position = UDim2.new(0, 6, 0, 36);
					Objs.Size = UDim2.new(0.986347735, 0, 0, 0);
					ObjsL.Name = "ObjsL";
					ObjsL.Parent = Objs;
					ObjsL.SortOrder = Enum.SortOrder.LayoutOrder;
					ObjsL.Padding = UDim.new(0, 8);
					local open = TabVal;
					if (TabVal ~= false) then
						Section.Size = UDim2.new(0.981000006, 0, 0, (open and (36 + ObjsL.AbsoluteContentSize.Y + 8)) or 36);
						SectionOpened.ImageTransparency = (open and 0) or 1;
						SectionOpen.ImageTransparency = (open and 1) or 0;
					end
					SectionToggle.MouseButton1Click:Connect(function()
						local FlatIdent_53124 = 0;
						while true do
							if (FlatIdent_53124 == 0) then
								open = not open;
								Section.Size = UDim2.new(0.981000006, 0, 0, (open and (36 + ObjsL.AbsoluteContentSize.Y + 8)) or 36);
								FlatIdent_53124 = 1;
							end
							if (FlatIdent_53124 == 1) then
								SectionOpened.ImageTransparency = (open and 0) or 1;
								SectionOpen.ImageTransparency = (open and 1) or 0;
								break;
							end
						end
					end);
					ObjsL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
						if not open then
							return;
						end
						Section.Size = UDim2.new(0.981000006, 0, 0, 36 + ObjsL.AbsoluteContentSize.Y + 8);
					end);
					local section = {};
					section.Button = function(section, text, callback)
						local callback = callback or function()
						end;
						local BtnModule = Instance.new("Frame");
						local Btn = Instance.new("TextButton");
						local BtnC = Instance.new("UICorner");
						BtnModule.Name = "BtnModule";
						BtnModule.Parent = Objs;
						BtnModule.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
						BtnModule.BackgroundTransparency = 1;
						BtnModule.BorderSizePixel = 0;
						BtnModule.Position = UDim2.new(0, 0, 0, 0);
						BtnModule.Size = UDim2.new(0, 428, 0, 38);
						Btn.Name = "Btn";
						Btn.Parent = BtnModule;
						Btn.BackgroundColor3 = zyColor;
						Btn.BorderSizePixel = 0;
						Btn.Size = UDim2.new(0, 428, 0, 38);
						Btn.AutoButtonColor = false;
						Btn.Font = Enum.Font.GothamSemibold;
						Btn.Text = "   " .. text;
						Btn.TextColor3 = Color3.fromRGB(255, 255, 255);
						Btn.TextSize = 16;
						Btn.TextXAlignment = Enum.TextXAlignment.Left;
						BtnC.CornerRadius = UDim.new(0, 6);
						BtnC.Name = "BtnC";
						BtnC.Parent = Btn;
						Btn.MouseButton1Click:Connect(function()
							spawn(function()
								Ripple(Btn);
							end);
							spawn(callback);
						end);
					end;
					section.Label = function(self, text)
						local FlatIdent_4A248 = 0;
						local LabelModule;
						local TextLabel;
						local LabelC;
						while true do
							if (FlatIdent_4A248 == 4) then
								TextLabel.TextSize = 14;
								LabelC.CornerRadius = UDim.new(0, 6);
								LabelC.Name = "LabelC";
								LabelC.Parent = TextLabel;
								FlatIdent_4A248 = 5;
							end
							if (0 == FlatIdent_4A248) then
								LabelModule = Instance.new("Frame");
								TextLabel = Instance.new("TextLabel");
								LabelC = Instance.new("UICorner");
								LabelModule.Name = "LabelModule";
								FlatIdent_4A248 = 1;
							end
							if (5 == FlatIdent_4A248) then
								return TextLabel;
							end
							if (FlatIdent_4A248 == 3) then
								TextLabel.Size = UDim2.new(0, 428, 0, 22);
								TextLabel.Font = Enum.Font.GothamSemibold;
								TextLabel.Text = text;
								TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
								FlatIdent_4A248 = 4;
							end
							if (FlatIdent_4A248 == 1) then
								LabelModule.Parent = Objs;
								LabelModule.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
								LabelModule.BackgroundTransparency = 1;
								LabelModule.BorderSizePixel = 0;
								FlatIdent_4A248 = 2;
							end
							if (FlatIdent_4A248 == 2) then
								LabelModule.Position = UDim2.new(0, 0, NAN, 0);
								LabelModule.Size = UDim2.new(0, 428, 0, 19);
								TextLabel.Parent = LabelModule;
								TextLabel.BackgroundColor3 = zyColor;
								FlatIdent_4A248 = 3;
							end
						end
					end;
					section.Toggle = function(section, text, flag, enabled, callback)
						local FlatIdent_957A4 = 0;
						local callback;
						local enabled;
						local ToggleModule;
						local ToggleBtn;
						local ToggleBtnC;
						local ToggleDisable;
						local ToggleSwitch;
						local ToggleSwitchC;
						local ToggleDisableC;
						local funcs;
						while true do
							if (FlatIdent_957A4 == 10) then
								if (enabled ~= false) then
									funcs:SetState(flag, true);
								end
								ToggleBtn.MouseButton1Click:Connect(function()
									funcs:SetState();
								end);
								return funcs;
							end
							if (FlatIdent_957A4 == 8) then
								ToggleSwitch.Parent = ToggleDisable;
								ToggleSwitch.BackgroundColor3 = beijingColor;
								ToggleSwitch.Size = UDim2.new(0, 24, 0, 22);
								ToggleSwitchC.CornerRadius = UDim.new(0, 6);
								ToggleSwitchC.Name = "ToggleSwitchC";
								FlatIdent_957A4 = 9;
							end
							if (FlatIdent_957A4 == 6) then
								ToggleBtnC.CornerRadius = UDim.new(0, 6);
								ToggleBtnC.Name = "ToggleBtnC";
								ToggleBtnC.Parent = ToggleBtn;
								ToggleDisable.Name = "ToggleDisable";
								ToggleDisable.Parent = ToggleBtn;
								FlatIdent_957A4 = 7;
							end
							if (7 == FlatIdent_957A4) then
								ToggleDisable.BackgroundColor3 = Background;
								ToggleDisable.BorderSizePixel = 0;
								ToggleDisable.Position = UDim2.new(0.901869178, 0, 0.208881587, 0);
								ToggleDisable.Size = UDim2.new(0, 36, 0, 22);
								ToggleSwitch.Name = "ToggleSwitch";
								FlatIdent_957A4 = 8;
							end
							if (FlatIdent_957A4 == 1) then
								ToggleModule = Instance.new("Frame");
								ToggleBtn = Instance.new("TextButton");
								ToggleBtnC = Instance.new("UICorner");
								ToggleDisable = Instance.new("Frame");
								ToggleSwitch = Instance.new("Frame");
								FlatIdent_957A4 = 2;
							end
							if (FlatIdent_957A4 == 4) then
								ToggleBtn.Parent = ToggleModule;
								ToggleBtn.BackgroundColor3 = zyColor;
								ToggleBtn.BorderSizePixel = 0;
								ToggleBtn.Size = UDim2.new(0, 428, 0, 38);
								ToggleBtn.AutoButtonColor = false;
								FlatIdent_957A4 = 5;
							end
							if (FlatIdent_957A4 == 0) then
								callback = callback or function()
								end;
								enabled = enabled or false;
								assert(text, "No text provided");
								assert(flag, "No flag provided");
								library.flags[flag] = enabled;
								FlatIdent_957A4 = 1;
							end
							if (3 == FlatIdent_957A4) then
								ToggleModule.BackgroundTransparency = 1;
								ToggleModule.BorderSizePixel = 0;
								ToggleModule.Position = UDim2.new(0, 0, 0, 0);
								ToggleModule.Size = UDim2.new(0, 428, 0, 38);
								ToggleBtn.Name = "ToggleBtn";
								FlatIdent_957A4 = 4;
							end
							if (FlatIdent_957A4 == 2) then
								ToggleSwitchC = Instance.new("UICorner");
								ToggleDisableC = Instance.new("UICorner");
								ToggleModule.Name = "ToggleModule";
								ToggleModule.Parent = Objs;
								ToggleModule.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
								FlatIdent_957A4 = 3;
							end
							if (FlatIdent_957A4 == 5) then
								ToggleBtn.Font = Enum.Font.GothamSemibold;
								ToggleBtn.Text = "   " .. text;
								ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255);
								ToggleBtn.TextSize = 16;
								ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left;
								FlatIdent_957A4 = 6;
							end
							if (9 == FlatIdent_957A4) then
								ToggleSwitchC.Parent = ToggleSwitch;
								ToggleDisableC.CornerRadius = UDim.new(0, 6);
								ToggleDisableC.Name = "ToggleDisableC";
								ToggleDisableC.Parent = ToggleDisable;
								funcs = {SetState=function(self, state)
									local FlatIdent_7147 = 0;
									while true do
										if (FlatIdent_7147 == 0) then
											if (state == nil) then
												state = not library.flags[flag];
											end
											if (library.flags[flag] == state) then
												return;
											end
											FlatIdent_7147 = 1;
										end
										if (FlatIdent_7147 == 1) then
											services.TweenService:Create(ToggleSwitch, TweenInfo.new(0.2), {Position=UDim2.new(0, (state and (ToggleSwitch.Size.X.Offset / 2)) or 0, 0, 0),BackgroundColor3=((state and Color3.fromRGB(255, 255, 255)) or beijingColor)}):Play();
											library.flags[flag] = state;
											FlatIdent_7147 = 2;
										end
										if (FlatIdent_7147 == 2) then
											callback(state);
											break;
										end
									end
								end,Module=ToggleModule};
								FlatIdent_957A4 = 10;
							end
						end
					end;
					section.Keybind = function(section, text, default, callback)
						local FlatIdent_8EA6E = 0;
						local callback;
						local default;
						local banned;
						local shortNames;
						local bindKey;
						local keyTxt;
						local KeybindModule;
						local KeybindBtn;
						local KeybindBtnC;
						local KeybindValue;
						local KeybindValueC;
						local KeybindL;
						local UIPadding;
						while true do
							if (5 == FlatIdent_8EA6E) then
								KeybindBtnC.Parent = KeybindBtn;
								KeybindValue.Name = "KeybindValue";
								KeybindValue.Parent = KeybindBtn;
								KeybindValue.BackgroundColor3 = Background;
								KeybindValue.BorderSizePixel = 0;
								KeybindValue.Position = UDim2.new(0.763033211, 0, 0.289473683, 0);
								KeybindValue.Size = UDim2.new(0, 100, 0, 28);
								FlatIdent_8EA6E = 6;
							end
							if (FlatIdent_8EA6E == 2) then
								UIPadding = Instance.new("UIPadding");
								KeybindModule.Name = "KeybindModule";
								KeybindModule.Parent = Objs;
								KeybindModule.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
								KeybindModule.BackgroundTransparency = 1;
								KeybindModule.BorderSizePixel = 0;
								KeybindModule.Position = UDim2.new(0, 0, 0, 0);
								FlatIdent_8EA6E = 3;
							end
							if (FlatIdent_8EA6E == 7) then
								KeybindValueC.Parent = KeybindValue;
								KeybindL.Name = "KeybindL";
								KeybindL.Parent = KeybindBtn;
								KeybindL.HorizontalAlignment = Enum.HorizontalAlignment.Right;
								KeybindL.SortOrder = Enum.SortOrder.LayoutOrder;
								KeybindL.VerticalAlignment = Enum.VerticalAlignment.Center;
								UIPadding.Parent = KeybindBtn;
								FlatIdent_8EA6E = 8;
							end
							if (FlatIdent_8EA6E == 6) then
								KeybindValue.AutoButtonColor = false;
								KeybindValue.Font = Enum.Font.Gotham;
								KeybindValue.Text = keyTxt;
								KeybindValue.TextColor3 = Color3.fromRGB(255, 255, 255);
								KeybindValue.TextSize = 14;
								KeybindValueC.CornerRadius = UDim.new(0, 6);
								KeybindValueC.Name = "KeybindValueC";
								FlatIdent_8EA6E = 7;
							end
							if (FlatIdent_8EA6E == 0) then
								callback = callback or function()
								end;
								assert(text, "No text provided");
								assert(default, "No default key provided");
								default = ((typeof(default) == "string") and Enum.KeyCode[default]) or default;
								banned = {Return=true,Space=true,Tab=true,Backquote=true,CapsLock=true,Escape=true,Unknown=true};
								shortNames = {RightControl="Right Ctrl",LeftControl="Left Ctrl",LeftShift="Left Shift",RightShift="Right Shift",Semicolon=";",Quote='"',LeftBracket="[",RightBracket="]",Equals="=",Minus="-",RightAlt="Right Alt",LeftAlt="Left Alt"};
								bindKey = default;
								FlatIdent_8EA6E = 1;
							end
							if (FlatIdent_8EA6E == 3) then
								KeybindModule.Size = UDim2.new(0, 428, 0, 38);
								KeybindBtn.Name = "KeybindBtn";
								KeybindBtn.Parent = KeybindModule;
								KeybindBtn.BackgroundColor3 = zyColor;
								KeybindBtn.BorderSizePixel = 0;
								KeybindBtn.Size = UDim2.new(0, 428, 0, 38);
								KeybindBtn.AutoButtonColor = false;
								FlatIdent_8EA6E = 4;
							end
							if (4 == FlatIdent_8EA6E) then
								KeybindBtn.Font = Enum.Font.GothamSemibold;
								KeybindBtn.Text = "   " .. text;
								KeybindBtn.TextColor3 = Color3.fromRGB(255, 255, 255);
								KeybindBtn.TextSize = 16;
								KeybindBtn.TextXAlignment = Enum.TextXAlignment.Left;
								KeybindBtnC.CornerRadius = UDim.new(0, 6);
								KeybindBtnC.Name = "KeybindBtnC";
								FlatIdent_8EA6E = 5;
							end
							if (FlatIdent_8EA6E == 1) then
								keyTxt = (default and (shortNames[default.Name] or default.Name)) or "None";
								KeybindModule = Instance.new("Frame");
								KeybindBtn = Instance.new("TextButton");
								KeybindBtnC = Instance.new("UICorner");
								KeybindValue = Instance.new("TextButton");
								KeybindValueC = Instance.new("UICorner");
								KeybindL = Instance.new("UIListLayout");
								FlatIdent_8EA6E = 2;
							end
							if (FlatIdent_8EA6E == 8) then
								UIPadding.PaddingRight = UDim.new(0, 6);
								services.UserInputService.InputBegan:Connect(function(inp, gpe)
									local FlatIdent_1D701 = 0;
									while true do
										if (FlatIdent_1D701 == 0) then
											if gpe then
												return;
											end
											if (inp.UserInputType ~= Enum.UserInputType.Keyboard) then
												return;
											end
											FlatIdent_1D701 = 1;
										end
										if (1 == FlatIdent_1D701) then
											if (inp.KeyCode ~= bindKey) then
												return;
											end
											callback(bindKey.Name);
											break;
										end
									end
								end);
								KeybindValue.MouseButton1Click:Connect(function()
									local FlatIdent_6066D = 0;
									local key;
									local uwu;
									local keyName;
									while true do
										if (2 == FlatIdent_6066D) then
											if (key.UserInputType ~= Enum.UserInputType.Keyboard) then
												KeybindValue.Text = keyTxt;
												return;
											end
											if banned[keyName] then
												local FlatIdent_508D4 = 0;
												while true do
													if (FlatIdent_508D4 == 0) then
														KeybindValue.Text = keyTxt;
														return;
													end
												end
											end
											FlatIdent_6066D = 3;
										end
										if (FlatIdent_6066D == 1) then
											key, uwu = services.UserInputService.InputEnded:Wait();
											keyName = tostring(key.KeyCode.Name);
											FlatIdent_6066D = 2;
										end
										if (FlatIdent_6066D == 0) then
											KeybindValue.Text = "...";
											wait();
											FlatIdent_6066D = 1;
										end
										if (FlatIdent_6066D == 3) then
											wait();
											bindKey = Enum.KeyCode[keyName];
											FlatIdent_6066D = 4;
										end
										if (FlatIdent_6066D == 4) then
											KeybindValue.Text = shortNames[keyName] or keyName;
											break;
										end
									end
								end);
								KeybindValue:GetPropertyChangedSignal("TextBounds"):Connect(function()
									KeybindValue.Size = UDim2.new(0, KeybindValue.TextBounds.X + 30, 0, 28);
								end);
								KeybindValue.Size = UDim2.new(0, KeybindValue.TextBounds.X + 30, 0, 28);
								break;
							end
						end
					end;
					section.Textbox = function(section, text, flag, default, callback)
						local FlatIdent_8A9D7 = 0;
						local callback;
						local TextboxModule;
						local TextboxBack;
						local TextboxBackC;
						local BoxBG;
						local BoxBGC;
						local TextBox;
						local TextboxBackL;
						local TextboxBackP;
						while true do
							if (FlatIdent_8A9D7 == 2) then
								TextboxBackP = Instance.new("UIPadding");
								TextboxModule.Name = "TextboxModule";
								TextboxModule.Parent = Objs;
								TextboxModule.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
								TextboxModule.BackgroundTransparency = 1;
								TextboxModule.BorderSizePixel = 0;
								FlatIdent_8A9D7 = 3;
							end
							if (FlatIdent_8A9D7 == 10) then
								TextboxBackL.SortOrder = Enum.SortOrder.LayoutOrder;
								TextboxBackL.VerticalAlignment = Enum.VerticalAlignment.Center;
								TextboxBackP.Name = "TextboxBackP";
								TextboxBackP.Parent = TextboxBack;
								TextboxBackP.PaddingRight = UDim.new(0, 6);
								TextBox.FocusLost:Connect(function()
									local FlatIdent_84ED3 = 0;
									while true do
										if (0 == FlatIdent_84ED3) then
											if (TextBox.Text == "") then
												TextBox.Text = default;
											end
											library.flags[flag] = TextBox.Text;
											FlatIdent_84ED3 = 1;
										end
										if (FlatIdent_84ED3 == 1) then
											callback(TextBox.Text);
											break;
										end
									end
								end);
								FlatIdent_8A9D7 = 11;
							end
							if (9 == FlatIdent_8A9D7) then
								TextBox.Text = default;
								TextBox.TextColor3 = Color3.fromRGB(255, 255, 255);
								TextBox.TextSize = 14;
								TextboxBackL.Name = "TextboxBackL";
								TextboxBackL.Parent = TextboxBack;
								TextboxBackL.HorizontalAlignment = Enum.HorizontalAlignment.Right;
								FlatIdent_8A9D7 = 10;
							end
							if (FlatIdent_8A9D7 == 11) then
								TextBox:GetPropertyChangedSignal("TextBounds"):Connect(function()
									BoxBG.Size = UDim2.new(0, TextBox.TextBounds.X + 30, 0, 28);
								end);
								BoxBG.Size = UDim2.new(0, TextBox.TextBounds.X + 30, 0, 28);
								break;
							end
							if (FlatIdent_8A9D7 == 8) then
								TextBox.Parent = BoxBG;
								TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
								TextBox.BackgroundTransparency = 1;
								TextBox.BorderSizePixel = 0;
								TextBox.Size = UDim2.new(1, 0, 1, 0);
								TextBox.Font = Enum.Font.Gotham;
								FlatIdent_8A9D7 = 9;
							end
							if (FlatIdent_8A9D7 == 5) then
								TextboxBack.TextXAlignment = Enum.TextXAlignment.Left;
								TextboxBackC.CornerRadius = UDim.new(0, 6);
								TextboxBackC.Name = "TextboxBackC";
								TextboxBackC.Parent = TextboxBack;
								BoxBG.Name = "BoxBG";
								BoxBG.Parent = TextboxBack;
								FlatIdent_8A9D7 = 6;
							end
							if (FlatIdent_8A9D7 == 7) then
								BoxBG.Text = "";
								BoxBG.TextColor3 = Color3.fromRGB(255, 255, 255);
								BoxBG.TextSize = 14;
								BoxBGC.CornerRadius = UDim.new(0, 6);
								BoxBGC.Name = "BoxBGC";
								BoxBGC.Parent = BoxBG;
								FlatIdent_8A9D7 = 8;
							end
							if (FlatIdent_8A9D7 == 4) then
								TextboxBack.Size = UDim2.new(0, 428, 0, 38);
								TextboxBack.AutoButtonColor = false;
								TextboxBack.Font = Enum.Font.GothamSemibold;
								TextboxBack.Text = "   " .. text;
								TextboxBack.TextColor3 = Color3.fromRGB(255, 255, 255);
								TextboxBack.TextSize = 16;
								FlatIdent_8A9D7 = 5;
							end
							if (FlatIdent_8A9D7 == 1) then
								TextboxBack = Instance.new("TextButton");
								TextboxBackC = Instance.new("UICorner");
								BoxBG = Instance.new("TextButton");
								BoxBGC = Instance.new("UICorner");
								TextBox = Instance.new("TextBox");
								TextboxBackL = Instance.new("UIListLayout");
								FlatIdent_8A9D7 = 2;
							end
							if (FlatIdent_8A9D7 == 6) then
								BoxBG.BackgroundColor3 = Background;
								BoxBG.BorderSizePixel = 0;
								BoxBG.Position = UDim2.new(0.763033211, 0, 0.289473683, 0);
								BoxBG.Size = UDim2.new(0, 100, 0, 28);
								BoxBG.AutoButtonColor = false;
								BoxBG.Font = Enum.Font.Gotham;
								FlatIdent_8A9D7 = 7;
							end
							if (3 == FlatIdent_8A9D7) then
								TextboxModule.Position = UDim2.new(0, 0, 0, 0);
								TextboxModule.Size = UDim2.new(0, 428, 0, 38);
								TextboxBack.Name = "TextboxBack";
								TextboxBack.Parent = TextboxModule;
								TextboxBack.BackgroundColor3 = zyColor;
								TextboxBack.BorderSizePixel = 0;
								FlatIdent_8A9D7 = 4;
							end
							if (FlatIdent_8A9D7 == 0) then
								callback = callback or function()
								end;
								assert(text, "No text provided");
								assert(flag, "No flag provided");
								assert(default, "No default text provided");
								library.flags[flag] = default;
								TextboxModule = Instance.new("Frame");
								FlatIdent_8A9D7 = 1;
							end
						end
					end;
					section.Slider = function(section, text, flag, default, min, max, precise, callback)
						local callback = callback or function()
						end;
						local min = min or 1;
						local max = max or 10;
						local default = default or min;
						local precise = precise or false;
						library.flags[flag] = default;
						assert(text, "No text provided");
						assert(flag, "No flag provided");
						assert(default, "No default value provided");
						local SliderModule = Instance.new("Frame");
						local SliderBack = Instance.new("TextButton");
						local SliderBackC = Instance.new("UICorner");
						local SliderBar = Instance.new("Frame");
						local SliderBarC = Instance.new("UICorner");
						local SliderPart = Instance.new("Frame");
						local SliderPartC = Instance.new("UICorner");
						local SliderValBG = Instance.new("TextButton");
						local SliderValBGC = Instance.new("UICorner");
						local SliderValue = Instance.new("TextBox");
						local MinSlider = Instance.new("TextButton");
						local AddSlider = Instance.new("TextButton");
						SliderModule.Name = "SliderModule";
						SliderModule.Parent = Objs;
						SliderModule.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
						SliderModule.BackgroundTransparency = 1;
						SliderModule.BorderSizePixel = 0;
						SliderModule.Position = UDim2.new(0, 0, 0, 0);
						SliderModule.Size = UDim2.new(0, 428, 0, 38);
						SliderBack.Name = "SliderBack";
						SliderBack.Parent = SliderModule;
						SliderBack.BackgroundColor3 = zyColor;
						SliderBack.BorderSizePixel = 0;
						SliderBack.Size = UDim2.new(0, 428, 0, 38);
						SliderBack.AutoButtonColor = false;
						SliderBack.Font = Enum.Font.GothamSemibold;
						SliderBack.Text = "   " .. text;
						SliderBack.TextColor3 = Color3.fromRGB(255, 255, 255);
						SliderBack.TextSize = 16;
						SliderBack.TextXAlignment = Enum.TextXAlignment.Left;
						SliderBackC.CornerRadius = UDim.new(0, 6);
						SliderBackC.Name = "SliderBackC";
						SliderBackC.Parent = SliderBack;
						SliderBar.Name = "SliderBar";
						SliderBar.Parent = SliderBack;
						SliderBar.AnchorPoint = Vector2.new(0, 0.5);
						SliderBar.BackgroundColor3 = Background;
						SliderBar.BorderSizePixel = 0;
						SliderBar.Position = UDim2.new(0.369000018, 40, 0.5, 0);
						SliderBar.Size = UDim2.new(0, 140, 0, 12);
						SliderBarC.CornerRadius = UDim.new(0, 4);
						SliderBarC.Name = "SliderBarC";
						SliderBarC.Parent = SliderBar;
						SliderPart.Name = "SliderPart";
						SliderPart.Parent = SliderBar;
						SliderPart.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
						SliderPart.BorderSizePixel = 0;
						SliderPart.Size = UDim2.new(0, 54, 0, 13);
						SliderPartC.CornerRadius = UDim.new(0, 4);
						SliderPartC.Name = "SliderPartC";
						SliderPartC.Parent = SliderPart;
						SliderValBG.Name = "SliderValBG";
						SliderValBG.Parent = SliderBack;
						SliderValBG.BackgroundColor3 = Background;
						SliderValBG.BorderSizePixel = 0;
						SliderValBG.Position = UDim2.new(0.883177578, 0, 0.131578952, 0);
						SliderValBG.Size = UDim2.new(0, 44, 0, 28);
						SliderValBG.AutoButtonColor = false;
						SliderValBG.Font = Enum.Font.Gotham;
						SliderValBG.Text = "";
						SliderValBG.TextColor3 = Color3.fromRGB(255, 255, 255);
						SliderValBG.TextSize = 14;
						SliderValBGC.CornerRadius = UDim.new(0, 6);
						SliderValBGC.Name = "SliderValBGC";
						SliderValBGC.Parent = SliderValBG;
						SliderValue.Name = "SliderValue";
						SliderValue.Parent = SliderValBG;
						SliderValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
						SliderValue.BackgroundTransparency = 1;
						SliderValue.BorderSizePixel = 0;
						SliderValue.Size = UDim2.new(1, 0, 1, 0);
						SliderValue.Font = Enum.Font.Gotham;
						SliderValue.Text = "1000";
						SliderValue.TextColor3 = Color3.fromRGB(255, 255, 255);
						SliderValue.TextSize = 14;
						MinSlider.Name = "MinSlider";
						MinSlider.Parent = SliderModule;
						MinSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
						MinSlider.BackgroundTransparency = 1;
						MinSlider.BorderSizePixel = 0;
						MinSlider.Position = UDim2.new(0.296728969, 40, 0.236842096, 0);
						MinSlider.Size = UDim2.new(0, 20, 0, 20);
						MinSlider.Font = Enum.Font.Gotham;
						MinSlider.Text = "-";
						MinSlider.TextColor3 = Color3.fromRGB(255, 255, 255);
						MinSlider.TextSize = 24;
						MinSlider.TextWrapped = true;
						AddSlider.Name = "AddSlider";
						AddSlider.Parent = SliderModule;
						AddSlider.AnchorPoint = Vector2.new(0, 0.5);
						AddSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
						AddSlider.BackgroundTransparency = 1;
						AddSlider.BorderSizePixel = 0;
						AddSlider.Position = UDim2.new(0.810906529, 0, 0.5, 0);
						AddSlider.Size = UDim2.new(0, 20, 0, 20);
						AddSlider.Font = Enum.Font.Gotham;
						AddSlider.Text = "+";
						AddSlider.TextColor3 = Color3.fromRGB(255, 255, 255);
						AddSlider.TextSize = 24;
						AddSlider.TextWrapped = true;
						local funcs = {SetValue=function(self, value)
							local percent = (mouse.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X;
							if value then
								percent = (value - min) / (max - min);
							end
							percent = math.clamp(percent, 0, 1);
							if precise then
								value = value or tonumber(string.format("%.1f", tostring(min + ((max - min) * percent))));
							else
								value = value or math.floor(min + ((max - min) * percent));
							end
							library.flags[flag] = tonumber(value);
							SliderValue.Text = tostring(value);
							SliderPart.Size = UDim2.new(percent, 0, 1, 0);
							callback(tonumber(value));
						end};
						MinSlider.MouseButton1Click:Connect(function()
							local FlatIdent_7C57C = 0;
							local currentValue;
							while true do
								if (FlatIdent_7C57C == 1) then
									funcs:SetValue(currentValue);
									break;
								end
								if (FlatIdent_7C57C == 0) then
									currentValue = library.flags[flag];
									currentValue = math.clamp(currentValue - 1, min, max);
									FlatIdent_7C57C = 1;
								end
							end
						end);
						AddSlider.MouseButton1Click:Connect(function()
							local currentValue = library.flags[flag];
							currentValue = math.clamp(currentValue + 1, min, max);
							funcs:SetValue(currentValue);
						end);
						funcs:SetValue(default);
						local dragging, boxFocused, allowed = false, false, {[""]=true,["-"]=true};
						SliderBar.InputBegan:Connect(function(input)
							if (input.UserInputType == Enum.UserInputType.MouseButton1) then
								funcs:SetValue();
								dragging = true;
							end
						end);
						services.UserInputService.InputEnded:Connect(function(input)
							if (dragging and (input.UserInputType == Enum.UserInputType.MouseButton1)) then
								dragging = false;
							end
						end);
						services.UserInputService.InputChanged:Connect(function(input)
							if (dragging and (input.UserInputType == Enum.UserInputType.MouseMovement)) then
								funcs:SetValue();
							end
						end);
						SliderBar.InputBegan:Connect(function(input)
							if (input.UserInputType == Enum.UserInputType.Touch) then
								funcs:SetValue();
								dragging = true;
							end
						end);
						services.UserInputService.InputEnded:Connect(function(input)
							if (dragging and (input.UserInputType == Enum.UserInputType.Touch)) then
								dragging = false;
							end
						end);
						services.UserInputService.InputChanged:Connect(function(input)
							if (dragging and (input.UserInputType == Enum.UserInputType.Touch)) then
								funcs:SetValue();
							end
						end);
						SliderValue.Focused:Connect(function()
							boxFocused = true;
						end);
						SliderValue.FocusLost:Connect(function()
							local FlatIdent_74B46 = 0;
							while true do
								if (FlatIdent_74B46 == 0) then
									boxFocused = false;
									if (SliderValue.Text == "") then
										funcs:SetValue(default);
									end
									break;
								end
							end
						end);
						SliderValue:GetPropertyChangedSignal("Text"):Connect(function()
							local FlatIdent_30B1F = 0;
							local text;
							while true do
								if (1 == FlatIdent_30B1F) then
									text = SliderValue.Text;
									if not tonumber(text) then
										SliderValue.Text = SliderValue.Text:gsub("%D+", "");
									elseif not allowed[text] then
										local FlatIdent_23521 = 0;
										while true do
											if (FlatIdent_23521 == 0) then
												if (tonumber(text) > max) then
													local FlatIdent_87441 = 0;
													while true do
														if (FlatIdent_87441 == 0) then
															text = max;
															SliderValue.Text = tostring(max);
															break;
														end
													end
												end
												funcs:SetValue(tonumber(text));
												break;
											end
										end
									end
									break;
								end
								if (FlatIdent_30B1F == 0) then
									if not boxFocused then
										return;
									end
									SliderValue.Text = SliderValue.Text:gsub("%D+", "");
									FlatIdent_30B1F = 1;
								end
							end
						end);
						return funcs;
					end;
					section.Dropdown = function(section, text, flag, options, callback)
						local callback = callback or function()
						end;
						local options = options or {};
						assert(text, "No text provided");
						assert(flag, "No flag provided");
						library.flags[flag] = nil;
						local DropdownModule = Instance.new("Frame");
						local DropdownTop = Instance.new("TextButton");
						local DropdownTopC = Instance.new("UICorner");
						local DropdownOpen = Instance.new("TextButton");
						local DropdownText = Instance.new("TextBox");
						local DropdownModuleL = Instance.new("UIListLayout");
						local Option = Instance.new("TextButton");
						local OptionC = Instance.new("UICorner");
						DropdownModule.Name = "DropdownModule";
						DropdownModule.Parent = Objs;
						DropdownModule.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
						DropdownModule.BackgroundTransparency = 1;
						DropdownModule.BorderSizePixel = 0;
						DropdownModule.ClipsDescendants = true;
						DropdownModule.Position = UDim2.new(0, 0, 0, 0);
						DropdownModule.Size = UDim2.new(0, 428, 0, 38);
						DropdownTop.Name = "DropdownTop";
						DropdownTop.Parent = DropdownModule;
						DropdownTop.BackgroundColor3 = zyColor;
						DropdownTop.BorderSizePixel = 0;
						DropdownTop.Size = UDim2.new(0, 428, 0, 38);
						DropdownTop.AutoButtonColor = false;
						DropdownTop.Font = Enum.Font.GothamSemibold;
						DropdownTop.Text = "";
						DropdownTop.TextColor3 = Color3.fromRGB(255, 255, 255);
						DropdownTop.TextSize = 16;
						DropdownTop.TextXAlignment = Enum.TextXAlignment.Left;
						DropdownTopC.CornerRadius = UDim.new(0, 6);
						DropdownTopC.Name = "DropdownTopC";
						DropdownTopC.Parent = DropdownTop;
						DropdownOpen.Name = "DropdownOpen";
						DropdownOpen.Parent = DropdownTop;
						DropdownOpen.AnchorPoint = Vector2.new(0, 0.5);
						DropdownOpen.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
						DropdownOpen.BackgroundTransparency = 1;
						DropdownOpen.BorderSizePixel = 0;
						DropdownOpen.Position = UDim2.new(0.918383181, 0, 0.5, 0);
						DropdownOpen.Size = UDim2.new(0, 20, 0, 20);
						DropdownOpen.Font = Enum.Font.Gotham;
						DropdownOpen.Text = "+";
						DropdownOpen.TextColor3 = Color3.fromRGB(255, 255, 255);
						DropdownOpen.TextSize = 24;
						DropdownOpen.TextWrapped = true;
						DropdownText.Name = "DropdownText";
						DropdownText.Parent = DropdownTop;
						DropdownText.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
						DropdownText.BackgroundTransparency = 1;
						DropdownText.BorderSizePixel = 0;
						DropdownText.Position = UDim2.new(0.0373831764, 0, 0, 0);
						DropdownText.Size = UDim2.new(0, 184, 0, 38);
						DropdownText.Font = Enum.Font.GothamSemibold;
						DropdownText.PlaceholderColor3 = Color3.fromRGB(255, 255, 255);
						DropdownText.PlaceholderText = text;
						DropdownText.Text = "";
						DropdownText.TextColor3 = Color3.fromRGB(255, 255, 255);
						DropdownText.TextSize = 16;
						DropdownText.TextXAlignment = Enum.TextXAlignment.Left;
						DropdownModuleL.Name = "DropdownModuleL";
						DropdownModuleL.Parent = DropdownModule;
						DropdownModuleL.SortOrder = Enum.SortOrder.LayoutOrder;
						DropdownModuleL.Padding = UDim.new(0, 4);
						local setAllVisible = function()
							local FlatIdent_3416F = 0;
							local options;
							while true do
								if (FlatIdent_3416F == 0) then
									options = DropdownModule:GetChildren();
									for i = 1, #options do
										local option = options[i];
										if (option:IsA("TextButton") and option.Name:match("Option_")) then
											option.Visible = true;
										end
									end
									break;
								end
							end
						end;
						local searchDropdown = function(text)
							local FlatIdent_15354 = 0;
							local options;
							while true do
								if (FlatIdent_15354 == 0) then
									options = DropdownModule:GetChildren();
									for i = 1, #options do
										local option = options[i];
										if (text == "") then
											setAllVisible();
										elseif (option:IsA("TextButton") and option.Name:match("Option_")) then
											if option.Text:lower():match(text:lower()) then
												option.Visible = true;
											else
												option.Visible = false;
											end
										end
									end
									break;
								end
							end
						end;
						local open = false;
						local ToggleDropVis = function()
							open = not open;
							if open then
								setAllVisible();
							end
							DropdownOpen.Text = (open and "-") or "+";
							DropdownModule.Size = UDim2.new(0, 428, 0, (open and (DropdownModuleL.AbsoluteContentSize.Y + 4)) or 38);
						end;
						DropdownOpen.MouseButton1Click:Connect(ToggleDropVis);
						DropdownText.Focused:Connect(function()
							local FlatIdent_437D4 = 0;
							while true do
								if (FlatIdent_437D4 == 0) then
									if open then
										return;
									end
									ToggleDropVis();
									break;
								end
							end
						end);
						DropdownText:GetPropertyChangedSignal("Text"):Connect(function()
							local FlatIdent_94BA0 = 0;
							while true do
								if (0 == FlatIdent_94BA0) then
									if not open then
										return;
									end
									searchDropdown(DropdownText.Text);
									break;
								end
							end
						end);
						DropdownModuleL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
							local FlatIdent_1F138 = 0;
							while true do
								if (FlatIdent_1F138 == 0) then
									if not open then
										return;
									end
									DropdownModule.Size = UDim2.new(0, 428, 0, DropdownModuleL.AbsoluteContentSize.Y + 4);
									break;
								end
							end
						end);
						local funcs = {};
						funcs.AddOption = function(self, option)
							local FlatIdent_61AEE = 0;
							local Option;
							local OptionC;
							while true do
								if (FlatIdent_61AEE == 1) then
									Option.BackgroundColor3 = zyColor;
									Option.BorderSizePixel = 0;
									Option.Position = UDim2.new(0, 0, 0.328125, 0);
									Option.Size = UDim2.new(0, 428, 0, 26);
									FlatIdent_61AEE = 2;
								end
								if (FlatIdent_61AEE == 2) then
									Option.AutoButtonColor = false;
									Option.Font = Enum.Font.Gotham;
									Option.Text = option;
									Option.TextColor3 = Color3.fromRGB(255, 255, 255);
									FlatIdent_61AEE = 3;
								end
								if (3 == FlatIdent_61AEE) then
									Option.TextSize = 14;
									OptionC.CornerRadius = UDim.new(0, 6);
									OptionC.Name = "OptionC";
									OptionC.Parent = Option;
									FlatIdent_61AEE = 4;
								end
								if (FlatIdent_61AEE == 0) then
									Option = Instance.new("TextButton");
									OptionC = Instance.new("UICorner");
									Option.Name = "Option_" .. option;
									Option.Parent = DropdownModule;
									FlatIdent_61AEE = 1;
								end
								if (4 == FlatIdent_61AEE) then
									Option.MouseButton1Click:Connect(function()
										local FlatIdent_7FF2C = 0;
										while true do
											if (FlatIdent_7FF2C == 1) then
												DropdownText.Text = Option.Text;
												library.flags[flag] = Option.Text;
												break;
											end
											if (0 == FlatIdent_7FF2C) then
												ToggleDropVis();
												callback(Option.Text);
												FlatIdent_7FF2C = 1;
											end
										end
									end);
									break;
								end
							end
						end;
						funcs.RemoveOption = function(self, option)
							local option = DropdownModule:FindFirstChild("Option_" .. option);
							if option then
								option:Destroy();
							end
						end;
						funcs.SetOptions = function(self, options)
							for _, v in next, DropdownModule:GetChildren() do
								if v.Name:match("Option_") then
									v:Destroy();
								end
							end
							for _, v in next, options do
								funcs:AddOption(v);
							end
						end;
						funcs:SetOptions(options);
						return funcs;
					end;
					return section;
				end;
				return tab;
			end
			if (FlatIdent_7DFA5 == 6) then
				TabText.TextXAlignment = Enum.TextXAlignment.Left;
				TabText.TextTransparency = 0.2;
				TabBtn.Name = "TabBtn";
				TabBtn.Parent = TabIco;
				TabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				FlatIdent_7DFA5 = 7;
			end
			if (FlatIdent_7DFA5 == 5) then
				TabText.Size = UDim2.new(0, 76, 0, 24);
				TabText.Font = Enum.Font.GothamSemibold;
				TabText.Text = name;
				TabText.TextColor3 = Color3.fromRGB(255, 255, 255);
				TabText.TextSize = 14;
				FlatIdent_7DFA5 = 6;
			end
			if (FlatIdent_7DFA5 == 9) then
				TabL.SortOrder = Enum.SortOrder.LayoutOrder;
				TabL.Padding = UDim.new(0, 4);
				TabBtn.MouseButton1Click:Connect(function()
					local FlatIdent_2A9F7 = 0;
					while true do
						if (FlatIdent_2A9F7 == 0) then
							spawn(function()
								Ripple(TabBtn);
							end);
							switchTab({TabIco,Tab});
							break;
						end
					end
				end);
				if (library.currentTab == nil) then
					switchTab({TabIco,Tab});
				end
				TabL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					Tab.CanvasSize = UDim2.new(0, 0, 0, TabL.AbsoluteContentSize.Y + 8);
				end);
				FlatIdent_7DFA5 = 10;
			end
		end
	end;
	return window;
end;
local window = library:new("wdfex内测版脚本");
game:GetService("StarterGui"):SetCore("SendNotification", {Title="wdfex脚本",Text="欢迎使用wdfex脚本",Icon="rbxassetid://114909926486671",Duration=1,Callback=bindable,Button1="脚本功能多多",Button2="感谢您的使用"});
game:GetService("StarterGui"):SetCore("SendNotification", {Title="wdfex脚本",Text="wdfex免费脚本永远为您服务",Icon="rbxassetid://114909926486671",Duration=1,Callback=bindable,Button1="此脚本是永久免费的",Button2="请勿倒卖"});
local UITab1 = window:Tab("『信息』", "6035145364");
local LocalPlayerSection = UITab1:section("玩家信息", true);
LocalPlayerSection:Label("  你的注入器:" .. identifyexecutor());
LocalPlayerSection:Label("你的账号年龄:" .. game.Players.LocalPlayer.AccountAge .. "天");
LocalPlayerSection:Label("  您的用户ID:" .. game.Players.LocalPlayer.UserId);
LocalPlayerSection:Label("  您的用户名:" .. game.Players.LocalPlayer.Character.Name);
LocalPlayerSection:Label("您当前服务器的ID:" .. game.GameId);
LocalPlayerSection:Label("您的客户端ID:" .. game:GetService("RbxAnalyticsService"):GetClientId());
LocalPlayerSection:Toggle("显示用户信息", "IJ", false, function(IJ)
	loadstring(game:HttpGet("https://pastefy.app/05JLksJH/raw"))();
end);
local LocalPlayerSection = UITab1:section("公告", true);
LocalPlayerSection:Label("wdfex脚本欢迎您的使用");
LocalPlayerSection:Label("wdfex脚本QQ主群:无");
local UITab2 = window:Tab("『通用』", "6035145364");
local LocalPlayerSection = UITab2:section("本地玩家", true);
local sliderMethod = "Slider";
local sliderLabel = "设置速度";
LocalPlayerSection:Slider("步行速度", "WalkSpeed", game.Players.LocalPlayer.Character.Humanoid.WalkSpeed, 16, 400, false, function(Speed)
	spawn(function()
		while task.wait() do
			game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Speed;
		end
	end);
end);
LocalPlayerSection:Slider("跳跃高度", "JumpPower", game.Players.LocalPlayer.Character.Humanoid.JumpPower, 50, 400, false, function(Jump)
	spawn(function()
		while task.wait() do
			game.Players.LocalPlayer.Character.Humanoid.JumpPower = Jump;
		end
	end);
end);
LocalPlayerSection:Button("查看游戏中的所有玩家（包括血量条）", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/G2zb992X", true))();
end);
LocalPlayerSection:Button("）", function()
	loadstring(game:HttpGet("https://pastefy.app/zt1XVVdn/raw"))();
end);
LocalPlayerSection:Button("踏空行走", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Float"))();
end);
LocalPlayerSection:Button("甩飞所有人", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/zqyDSUWX"))();
end);
LocalPlayerSection:Button("点击传送道具", function()
	loadstring(game:HttpGet("https://pastefy.app/Jf2QXOwa/raw"))();
end);
LocalPlayerSection:Button("爬墙", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/zXk4Rq2r"))();
end);
LocalPlayerSection:Button("锁头（小皮）", function()
	loadstring(game:HttpGet([[https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/3683e49998644fb7.txt_2024-08-09_094310.OTed.lua]]))();
end);
LocalPlayerSection:Button("坐下", function()
	game.Players.LocalPlayer.Character.Humanoid.Sit = true;
end);
LocalPlayerSection:Toggle("无限跳", "IJ", false, function(IJ)
	local FlatIdent_98E39 = 0;
	while true do
		if (0 == FlatIdent_98E39) then
			getgenv().InfJ = IJ;
			game:GetService("UserInputService").JumpRequest:connect(function()
				if (InfJ == true) then
					game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping");
				end
			end);
			break;
		end
	end
end);
LocalPlayerSection:Toggle("穿墙", "NoClip", false, function(enabled)
	local FlatIdent_8E3FD = 0;
	local workspace;
	local Players;
	while true do
		if (1 == FlatIdent_8E3FD) then
			if enabled then
				Clipon = true;
			else
				Clipon = false;
			end
			Stepped = game:GetService("RunService").Stepped:Connect(function()
				if Clipon then
					for _, child in pairs(workspace:GetChildren()) do
						if (child.Name == Players.LocalPlayer.Name) then
							for _, part in pairs(workspace[Players.LocalPlayer.Name]:GetChildren()) do
								if part:IsA("BasePart") then
									part.CanCollide = false;
								end
							end
						end
					end
				else
					Stepped:Disconnect();
				end
			end);
			break;
		end
		if (FlatIdent_8E3FD == 0) then
			workspace = game:GetService("Workspace");
			Players = game:GetService("Players");
			FlatIdent_8E3FD = 1;
		end
	end
end);
LocalPlayerSection:Toggle("防甩飞（内测）", "IJ", false, function(IJ)
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Linux6699/DaHubRevival/main/AntiFling.lua"))();
end);
LocalPlayerSection:Button("快速互动", function()
	game.ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
		prompt.HoldDuration = 0;
	end);
end);
LocalPlayerSection:Toggle("自动互动（全图 与快速互动一起使用）", "AutoInteract", false, function(enabled)
	if enabled then
		local FlatIdent_62CB4 = 0;
		while true do
			if (FlatIdent_62CB4 == 0) then
				autoInteract = true;
				while autoInteract do
					local FlatIdent_8C1D5 = 0;
					while true do
						if (FlatIdent_8C1D5 == 0) then
							for _, descendant in pairs(workspace:GetDescendants()) do
								if descendant:IsA("ProximityPrompt") then
									fireproximityprompt(descendant);
								end
							end
							task.wait(0.25);
							break;
						end
					end
				end
				break;
			end
		end
	else
		autoInteract = false;
	end
end);
LocalPlayerSection:Toggle("原地复活", "IJ", false, function(IJ)
	loadstring(game:HttpGet("https://pastefy.app/erR67iPB/raw"))();
end);
local UITab3 = window:Tab("『范围』", "6035145364");
local LocalPlayerSection = UITab3:section("本地玩家", true);
_G.RangeConn = nil;
local function updateRange(size)
	if _G.RangeConn then
		local FlatIdent_511F5 = 0;
		while true do
			if (0 == FlatIdent_511F5) then
				_G.RangeConn:Disconnect();
				_G.RangeConn = nil;
				break;
			end
		end
	end
	_G.HeadSize = size;
	_G.Disabled = true;
	_G.RangeConn = game:GetService("RunService").RenderStepped:Connect(function()
		if _G.Disabled then
			for i, v in next, game:GetService("Players"):GetPlayers() do
				if (v.Name ~= game:GetService("Players").LocalPlayer.Name) then
					pcall(function()
						v.Character.HumanoidRootPart.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize);
						v.Character.HumanoidRootPart.Transparency = 0.7;
						v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really blue");
						v.Character.HumanoidRootPart.Material = "Neon";
						v.Character.HumanoidRootPart.CanCollide = false;
					end);
				end
			end
		end
	end);
end
LocalPlayerSection:Button("清空范围效果  注：范围功能仅部分服务器可用", function()
	updateRange(0);
end);
LocalPlayerSection:Button("范围10", function()
	updateRange(10);
end);
LocalPlayerSection:Button("范围20", function()
	updateRange(20);
end);
LocalPlayerSection:Button("范围30", function()
	updateRange(30);
end);
LocalPlayerSection:Button("范围50", function()
	updateRange(50);
end);
LocalPlayerSection:Button("范围70", function()
	updateRange(70);
end);
LocalPlayerSection:Button("范围120", function()
	updateRange(120);
end);
LocalPlayerSection:Button("范围300", function()
	updateRange(300);
end);
LocalPlayerSection:Button("范围500", function()
	updateRange(500);
end);
LocalPlayerSection:Button("范围999", function()
	updateRange(999);
end);
LocalPlayerSection:Button("范围999999999", function()
	updateRange(999999999);
end);
local UITab4 = window:Tab("『传送与甩飞』", "6035145364");
local LocalPlayerSection = UITab4:section("选中玩家传送甩飞", true);
shuaxinlb();
game.Players.PlayerAdded:Connect(function()
	shuaxinlb();
	if Players then
		Players:SetOptions(bin.dropdown);
	end
end);
game.Players.PlayerRemoving:Connect(function()
	shuaxinlb();
	if Players then
		Players:SetOptions(bin.dropdown);
	end
end);
local Players = LocalPlayerSection:Dropdown("选择玩家名字已开始下面的功能→→→", "Dropdown", bin.dropdown, function(v)
	bin.playernamedied = v;
end);
LocalPlayerSection:Button("重置玩家名字（刷新最新进入服务器的一批玩家 如没有要找的玩家 请点击）", function()
	local FlatIdent_7735C = 0;
	while true do
		if (FlatIdent_7735C == 0) then
			shuaxinlb();
			Players:SetOptions(bin.dropdown);
			break;
		end
	end
end);
LocalPlayerSection:Button("传送到玩家旁边", function()
	local HumRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart");
	local tp_player = game.Players:FindFirstChild(bin.playernamedied);
	if (tp_player and tp_player.Character and tp_player.Character:FindFirstChild("HumanoidRootPart")) then
		HumRoot.CFrame = tp_player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0);
	end
end);
LocalPlayerSection:Toggle("循环传送指定玩家", "TP", false, function(TP)
	local FlatIdent_38BA4 = 0;
	local tpThread;
	while true do
		if (FlatIdent_38BA4 == 1) then
			if TP then
				tpThread = spawn(function()
					while getgenv().EnableTP do
						local FlatIdent_2C010 = 0;
						local HumRoot;
						local tp_player;
						while true do
							if (FlatIdent_2C010 == 1) then
								tp_player = game.Players:FindFirstChild(bin.playernamedied);
								if (HumRoot and tp_player and tp_player.Character and tp_player.Character:FindFirstChild("HumanoidRootPart")) then
									HumRoot.CFrame = tp_player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0);
								end
								break;
							end
							if (FlatIdent_2C010 == 0) then
								task.wait(0.01);
								HumRoot = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
								FlatIdent_2C010 = 1;
							end
						end
					end
				end);
			elseif tpThread then
				local FlatIdent_185A5 = 0;
				while true do
					if (0 == FlatIdent_185A5) then
						task.cancel(tpThread);
						tpThread = nil;
						break;
					end
				end
			end
			break;
		end
		if (FlatIdent_38BA4 == 0) then
			getgenv().EnableTP = TP;
			tpThread = nil;
			FlatIdent_38BA4 = 1;
		end
	end
end);
getgenv().IsFlingLoopEnabled = false;
LocalPlayerSection:Toggle("循环甩飞指定玩家(内测版  bug以后会修)", "Toggleflag", false, function(state)
	getgenv().IsFlingLoopEnabled = state;
	if state then
		spawn(function()
			while getgenv().IsFlingLoopEnabled do
				local FlatIdent_4CEEC = 0;
				local HumRoot;
				local tp_player;
				while true do
					if (FlatIdent_4CEEC == 2) then
						if getgenv().IsFlingLoopEnabled then
							loadstring(game:HttpGet("https://pastefy.app/od3cnFl6/raw"))();
						end
						break;
					end
					if (FlatIdent_4CEEC == 1) then
						tp_player = game.Players:FindFirstChild(bin.playernamedied);
						if (tp_player and tp_player.Character and tp_player.Character:FindFirstChild("HumanoidRootPart") and HumRoot) then
							HumRoot.CFrame = tp_player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0);
						end
						FlatIdent_4CEEC = 2;
					end
					if (FlatIdent_4CEEC == 0) then
						task.wait(1e-14);
						HumRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart");
						FlatIdent_4CEEC = 1;
					end
				end
			end
		end);
	end
end);
LocalPlayerSection:Toggle("查看玩家（就是视角转移）", "Toggleflag", false, function(state)
	if state then
		local FlatIdent_904EC = 0;
		local target;
		while true do
			if (0 == FlatIdent_904EC) then
				target = game:GetService("Players"):FindFirstChild(bin.playernamedied);
				if (target and target.Character and target.Character:FindFirstChild("Humanoid")) then
					game:GetService("Workspace").CurrentCamera.CameraSubject = target.Character.Humanoid;
				end
				break;
			end
		end
	elseif (player.Character and player.Character:FindFirstChild("Humanoid")) then
		game:GetService("Workspace").CurrentCamera.CameraSubject = player.Character.Humanoid;
	end
end);
local LocalPlayerSection = UITab4:section("传送甩飞所有人", true);
LocalPlayerSection:Toggle("循环传送到所有玩家旁边", "wow", false, function(state)
	getgenv().wow = state;
	if state then
		spawn(function()
			local player = game.Players.LocalPlayer;
			while getgenv().wow do
				local FlatIdent_53252 = 0;
				while true do
					if (FlatIdent_53252 == 0) then
						for _, target in pairs(game:GetService("Players"):GetPlayers()) do
							if not getgenv().wow then
								break;
							end
							if ((target ~= player) and target.Character and target.Character:FindFirstChild("HumanoidRootPart")) then
								local FlatIdent_6B92D = 0;
								local targetRoot;
								local playerRoot;
								while true do
									if (FlatIdent_6B92D == 1) then
										for i = 1, 3 do
											if not getgenv().wow then
												break;
											end
											playerRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, -1.5);
											task.wait(0.05);
											playerRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 0, 1.5);
											task.wait(0.05);
										end
										task.wait(0.2);
										break;
									end
									if (FlatIdent_6B92D == 0) then
										targetRoot = target.Character.HumanoidRootPart;
										playerRoot = player.Character.HumanoidRootPart;
										FlatIdent_6B92D = 1;
									end
								end
							end
						end
						task.wait(0.1);
						break;
					end
				end
			end
		end);
	end
end);
getgenv().IsFlingAllEnabled = false;
getgenv().FlingAllThread = nil;
LocalPlayerSection:Toggle("循环甩飞所有人(不要多次按动开关，停止执行需等执行一轮完毕)", "IJ", false, function(IJ)
	local FlatIdent_95359 = 0;
	while true do
		if (1 == FlatIdent_95359) then
			if IJ then
				getgenv().FlingAllThread = spawn(function()
					while getgenv().IsFlingAllEnabled do
						local FlatIdent_68E5B = 0;
						while true do
							if (FlatIdent_68E5B == 0) then
								task.wait(0.5);
								loadstring(game:HttpGet("https://pastebin.com/raw/zqyDSUWX"))();
								break;
							end
						end
					end
				end);
			end
			break;
		end
		if (0 == FlatIdent_95359) then
			getgenv().IsFlingAllEnabled = IJ;
			if getgenv().FlingAllThread then
				local FlatIdent_54124 = 0;
				while true do
					if (FlatIdent_54124 == 0) then
						task.cancel(getgenv().FlingAllThread);
						getgenv().FlingAllThread = nil;
						break;
					end
				end
			end
			FlatIdent_95359 = 1;
		end
	end
end);
local UITab5 = window:Tab("『黑洞』", "6035145364");
local LocalPlayerSection = UITab5:section("搬运", true);
LocalPlayerSection:Button("普通黑洞(E键控制)", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/Sx6PY4gV"))();
end);
LocalPlayerSection:Button("普通黑洞(第2种)(点击即跟随)", function()
	loadstring(game:HttpGet("https://pastefy.app/BbXuvVkK/raw", true))();
end);
LocalPlayerSection:Button("高级黑洞(吸力超强E键控制)", function()
	loadstring(game:HttpGet([[https://raw.githubusercontent.com/xiaopi77/xiaopi77/refs/heads/main/blackhole.lua]]))();
end);
LocalPlayerSection:Button("黑洞脚本(第1种)", function()
	loadstring(game:HttpGet("https://pastefy.app/J21lpKbj/raw"))();
end);
LocalPlayerSection:Button("黑洞脚本(第2种要输入玩家名字)", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/dingding123hhh/lililiugg/main/jm114514.lua"))();
end);
LocalPlayerSection:Button("黑洞脚本(第3种)", function()
	loadstring(game:HttpGet("https://pastefy.app/EwpVHMPg/raw"))();
end);
LocalPlayerSection:Button("黑洞脚本(第4种)", function()
	loadstring(game:HttpGet([[https://raw.githubusercontent.com/BingusWR/BLACKHOLDSCRIPT/refs/heads/main/BLACK%20HOLD%20SCRIPT]]))();
end);
LocalPlayerSection:Button("黑洞脚本(第5种)", function()
	loadstring(game:HttpGet([[https://raw.githubusercontent.com/xiaopi77/xiaopi77/refs/heads/main/Blackholescript.lua]]))();
end);
LocalPlayerSection:Button("黑洞脚本(第6种)(环绕V2)", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/BOOSBS/666/refs/heads/main/656"))();
end);
LocalPlayerSection:Button("黑洞脚本(第7种)(传送型黑洞)(别人看不见)", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/U29jR1Cf"))();
end);
LocalPlayerSection:Button("黑洞脚本(第8种)(环绕V3)", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/BOOSBS/199/refs/heads/main/V3"))();
end);
local UITab6 = window:Tab("『服务器脚本』", "6035145364");
local LocalPlayerSection = UITab6:section("wdfex本人制作", true);
LocalPlayerSection:Button("《盲射》", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/main/BlindShot"))();
end);
LocalPlayerSection:Button("《自然灾害(建议用黑洞)》", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/2dgeneralspam1/scripts-and-stuff/master/scripts/LoadstringUjHI6RQpz2o8", true))();
end);
LocalPlayerSection:Button("《速度传奇》", function()
	loadstring(game:HttpGet("https://pastefy.app/DhttNHdb/raw"))();
end);
LocalPlayerSection:Button("《种植花园》", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/MoziIOnTop/MoziIHub/refs/heads/main/GrowaGarden"))();
end);
LocalPlayerSection:Button("《饲养宠物》", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xwwwwwwwwwwwwwwwwwwwqd/loader/main/GamesData/RaiseAnimals.lua"))();
end);
LocalPlayerSection:Button("《偷走脑红》", function()
	loadstring(game:HttpGet("https://pastefy.app/ULdWe37N/raw"))();
end);
LocalPlayerSection:Button("《伐木大亨》", function()
	loadstring(game:HttpGet("https://pastefy.app/oAqe0jak/raw"))();
end);
LocalPlayerSection:Button("《植物vs大脑机器人》", function()
	loadstring(game:HttpGet("https://pastefy.app/2EoYqTfl/raw"))();
end);
LocalPlayerSection:Button("《99夜》", function()
	loadstring(game:HttpGet("https://pastefy.app/2EoYqTfl/raw"))();
end);
LocalPlayerSection:Button("《兵工厂》", function()
	loadstring(game:HttpGet("https://pastefy.app/4onOuqPM/raw"))();
end);
LocalPlayerSection:Button("《闪光》", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/ShenJiaoBen/ScriptLoader/refs/heads/main/Linni_FreeLoader.lua"))();
end);
LocalPlayerSection:Button("《Blox战利品》", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/mnmnm123/5888/refs/heads/main/v9Blox"))();
end);
LocalPlayerSection:Button("《通缉》", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/ShenJiaoBen/Partial-Server-Ribbon/refs/heads/main/自动换服ATM和收银机%5B正在寻求%5D.txt"))();
end);
local UITab7 = window:Tab("『画质光影』", "6035145364");
local LocalPlayerSection = UITab7:section("改变游戏画质光影", true);
LocalPlayerSection:Button("光影", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/MZEEN2424/Graphics/main/Graphics.xml"))();
end);
LocalPlayerSection:Button("RTX高仿", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/Bkf0BJb3"))();
end);
LocalPlayerSection:Button("超高画质", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/jHBfJYmS"))();
end);
LocalPlayerSection:Button("光影v4", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/MZEEN2424/Graphics/main/Graphics.xml"))();
end);
LocalPlayerSection:Button("光影浅", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/jHBfJYmS"))();
end);
LocalPlayerSection:Button("光影深", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/MZEEN2424/Graphics/main/Graphics.xml"))();
end);
