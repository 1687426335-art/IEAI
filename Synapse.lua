---关注b站UID:1531514159
---一群1035184654
---二群2168053189（聊天群）
---十九群1064447273（五百人群）
---二十一群178021813（五百人群）
---二十二群336225224（五百人群）
---二十三群218012845（五百人群）没满
---二十四群1035646571（五百人群）没满
---二十五群1071017763（五百人群）没满
---二十六群820782679（五百人群）没满
---二十七群1067211151（五百人群）
---Kenny脚本群1019547871（五百人群）
---sp源码分享协会727992470
local NotificationModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/aA910FLsaIASFO1/gits/main/Notification.lua"))()
local VERSION_STRING = "v3.2022 <b>[BETA]</b>"
AutoExLoaded = false

local function emptyFunction()
end

local writeFile = writefile or emptyFunction
local readFile = readfile or emptyFunction
local isFile = isfile or emptyFunction
local isFolder = isfolder or emptyFunction
local makeFolder = makefolder or emptyFunction
local deleteFolder = delfolder or emptyFunction
local listFiles = listfiles or emptyFunction

function LoadModule(url)
    return loadstring(game:HttpGet(url))()
end

if not Engine then
    Engine = LoadModule("https://raw.githubusercontent.com/aA910FLsaIASFO1/gits/refs/heads/main/Abin.lua")
end

local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.ResetOnSpawn = false
Engine.Secure(ScreenGui)
ScreenGui.ClipToDeviceSafeArea = false
Engine.Init()

Engine.AssertFolders({
    "Themes/Synapse V3",
    "Themes/Synapse V3/Main",
    "Themes/Synapse V3/SavedThemes",
    "ExecutorConfigs",
    "ExecutorConfigs/bin",
    "ExecutorConfigs/n7YhEWpnV4EGxCEQFxdf"
})

GAME_NAME = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name or ""
Engine.AutoLoad("loadstring(game:HttpGet(\"https://pastebin.com/raw/qmufRs1A\"))()")

function fun(button, callback)
    button.MouseButton1Click:Connect(callback)
end

local function Color3ToRGB(color)
    if typeof(color) ~= "Color3" then
        return nil
    end
    local function convertComponent(component)
        if string.find(component, ".") then
            return string.split(component * 255, ".")[1]
        else
            return component
        end
    end
    return {
        R = convertComponent(color.R),
        G = convertComponent(color.G),
        B = convertComponent(color.B)
    }
end

function TripleClick(button, callback)
    local clickCount = 0
    waiting = false
    button.MouseButton1Click:Connect(function()
        clickCount = clickCount + 1
        if clickCount == 3 then
            clickCount = 0
            callback()
        end
    end)
    button.MouseButton1Click:Connect(function()
        if waiting == false then
            waiting = true
            wait(0.5)
            clickCount = 0
            waiting = false
        end
    end)
end

local function RGBToColor3(rgbTable)
    return Color3.fromRGB(rgbTable.R, rgbTable.G, rgbTable.B)
end

function getTheme(themeInput)
    if themeInput and themeInput ~= "" then
        if string.find(themeInput, "https") then
            Engine.getTheme("Themes/Synapse V3/Main", themeInput)
            local iterator, table, index = pairs(listFiles("Themes/Synapse V3/Main"))
            local key, value = iterator(table, index)
            if key ~= nil then
                return getcustomasset(value)
            end
            return
        elseif string.find(themeInput, "rbxassetid://") then
            return themeInput
        else
            return "rbxthumb://type=Asset&w=768&h=432&id=" .. themeInput
        end
    else
        return
    end
end

function getIcon(iconId)
    if string.find(iconId, "rbxassetid://") then
        return iconId
    else
        return "rbxthumb://type=Asset&w=150&h=150&id=" .. iconId
    end
end

function rgb(r, g, b)
    return Color3.fromRGB(r, g, b)
end

SynapseVariables = {
    AutoExecute = nil,
    oldpos = nil,
    oldframe = nil
}

local isFirstLoad = true
local SynapseConfigs = nil
SynapseConfigsLoaded = false
js = game:GetService("HttpService")

function ForceLoadAssets()
    if isFile("ExecutorConfigs/SynapseConfigs.dat") then
        SynapseConfigs = js:JSONDecode(readFile("ExecutorConfigs/SynapseConfigs.dat"))
    else
        SynapseConfigs = {
            Main = {
                MainTheme = "",
                IsThemed = false,
                CompactSettings = false,
                AutoExec = false,
                TabLayout = 1
            },
            Editor = {
                JSONTabs = true,
                ConsoleShortcut = true,
                CompactTabs = false,
                CompactEditorButtons = false,
                TabLenght = 4,
                FontSize = 16,
                TabCountLimit = 0,
                DefaultContent = "--Welcome to Hawk Series!",
                SmoothMovement = false,
                SmoothCursor = false,
                MoveFileListToLeft = false,
                HideFileList = false,
                ShowUnsavedWarnings = false,
                ButtonAlignment = false,
                AutoExec = false,
                AutoReload = false,
                AutoRecovery = false,
                ContextIndex = "",
                AnonymousMode = false,
                Opacity = 0.8
            },
            Layout = {
                AlwaysOnTop = true,
                CloseConfirm = false,
                NavigationLayout = 0,
                SilentLaunch = false,
                TransparentWindow = false,
                EmulatorVersion = false,
                Sounds = false,
                FastLoad = false,
                AntiAfk = false,
                AutoRejoin = false
            }
        }
        writeFile("ExecutorConfigs/SynapseConfigs.dat", js:JSONEncode(SynapseConfigs))
    end
    
    if isFile("ExecutorConfigs/XowZCfPrsllvmuBwG7c.dat") then
        swarnings = js:JSONDecode(readFile("ExecutorConfigs/XowZCfPrsllvmuBwG7c.dat"))
    else
        swarnings = {
            wlc = false
        }
        writeFile("ExecutorConfigs/XowZCfPrsllvmuBwG7c.dat", js:JSONEncode(swarnings))
    end
    
    if isFile("Themes/SynapseIcons.dat") then
        SynapseTheming = js:JSONDecode(readFile("Themes/SynapseIcons.dat"))
    else
        SynapseTheming = {
            Name = "",
            MainTheme = "",
            Top = {
                Executor = "16179947903",
                Settings = "10086106431",
                Theming = "16959846394",
                User = "17324798390",
                Console = "10085690058"
            },
            Executor = {
                Execute = "10085581761",
                Clear = "10085587880",
                OpenFile = "10085591930",
                ExecuteFile = "10085593803",
                SaveFile = "10085596898",
                LocalFiles = "17260568286",
                Bookmarks = "17260753651",
                AutoExecute = "17260998761"
            },
            ThemeColor = Color3ToRGB(Color3.fromRGB(200, 200, 200)),
            ThemeColor2 = Color3ToRGB(Color3.fromRGB(138, 189, 255)),
            BackgroundColor = Color3ToRGB(Color3.fromRGB(20, 20, 20)),
            ButtonColor = Color3ToRGB(Color3.fromRGB(45, 45, 45)),
            TextColor = Color3ToRGB(Color3.fromRGB(200, 200, 200)),
            TextColor2 = Color3ToRGB(Color3.fromRGB(255, 255, 255))
        }
        writeFile("Themes/SynapseIcons.dat", js:JSONEncode(SynapseTheming))
    end
    SynapseColorService = SynapseTheming
end

function CreateSynapse(launchMode)
    if not getgenv().xihHl4J4OCYYFGa1OJgGZn then
        getgenv().xihHl4J4OCYYFGa1OJgGZn = true
        ForceLoadAssets()
        
        function AdaptadorRuim(parent)
            local stroke = Instance.new("UIStroke")
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke.Color = Color3.fromRGB(60, 60, 60)
            stroke.LineJoinMode = Enum.LineJoinMode.Round
            stroke.Thickness = 1
            stroke.Transparency = 0
        end
        
        function getImage(assetId)
            return "rbxthumb://type=Asset&w=768&h=432&id=" .. assetId
        end
        
        local UserInputService = game:GetService("UserInputService")
        local LocalPlayer = game:GetService("Players").LocalPlayer
        
        ScreenGui:GetPropertyChangedSignal("Parent"):Connect(function()
            ScreenGui:Destroy()
        end)
        
        local themeIterator, themeTable, themeIndex = pairs(listFiles("Themes/Synapse V3/Main"))
        local hasCustomTheme = nil
        local ThemeFrame = nil
        local currentPageIndex = 0
        
        while true do
            local key, filePath = themeIterator(themeTable, themeIndex)
            if key == nil then
                break
            end
            themeIndex = key
            local fileExtension = string.sub(filePath, string.len(filePath) - 2)
            if fileExtension == "png" then
                ThemeFrame = Instance.new("ImageLabel")
                ThemeFrame.Image = getcustomasset(filePath)
                ThemeFrame.ImageTransparency = ThemeFrame.BackgroundTransparency
                ThemeFrame.ScaleType = Enum.ScaleType.Crop
                hasCustomTheme = true
            elseif fileExtension == "mp4" then
                ThemeFrame = Instance.new("VideoFrame")
                ThemeFrame.Video = getcustomasset(filePath)
                ThemeFrame.Looped = true
                ThemeFrame:Play()
                ThemeFrame.Volume = 0
                hasCustomTheme = true
            end
        end
        
        if not hasCustomTheme then
            ThemeFrame = Instance.new("ImageLabel")
            ThemeFrame.ImageTransparency = ThemeFrame.BackgroundTransparency
            ThemeFrame.Image = getTheme(SynapseTheming.MainTheme) or ""
            ThemeFrame.ScaleType = Enum.ScaleType.Crop
        end
        
        local MainFrame = ThemeFrame
        MainFrame.Parent = ScreenGui
        MainFrame.Active = true
        MainFrame.BackgroundColor3 = RGBToColor3(SynapseColorService.BackgroundColor)
        MainFrame.Position = UDim2.new(0, 0, 0, 0)
        
        if SynapseVariables.oldpos ~= nil then
            MainFrame.Position = SynapseVariables.oldpos
        end
        MainFrame.Size = UDim2.new(0, 747, 0, 310)
        
        local MinimizedButton = Instance.new("ImageButton", ScreenGui)
        local MinimizedGradient = Instance.new("UIGradient", MinimizedButton)
        local MinimizedCorner = Instance.new("UICorner", MinimizedButton)
        local LogoButton = Instance.new("ImageButton")
        local VersionLabel = Instance.new("TextLabel")
        local WindowControlsFrame = Instance.new("Frame")
        local WindowControlsLayout = Instance.new("UIListLayout")
        local MinimizeButton = Instance.new("TextButton")
        local MaximizeButton = Instance.new("TextButton")
        local CloseButton = Instance.new("TextButton")
        local ContentFrame = Instance.new("Frame")
        local MainStroke = Instance.new("UIStroke", MainFrame)
        local MainCorner = Instance.new("UICorner", MainFrame)
        local NavigationFrame = Instance.new("Frame", MainFrame)
        local NavigationLayout = Instance.new("UIListLayout", NavigationFrame)
        local ExecutorPage = Instance.new("Frame", ContentFrame)
        local HorizontalDivider = Instance.new("Frame")
        local VerticalDivider = Instance.new("Frame")
        local FileListContainer = Instance.new("Frame")
        local SearchBox = Instance.new("TextBox")
        local SearchIcon = Instance.new("ImageButton")
        local FileListScroll = Instance.new("ScrollingFrame")
        local FileListLayout = Instance.new("UIListLayout")
        local LocalFilesButton = Instance.new("TextButton")
        local BookmarksButton = Instance.new("TextButton")
        local AutoExecButton = Instance.new("TextButton")
        local TimeButton = Instance.new("TextButton")
        local TabsScroll = Instance.new("ScrollingFrame")
        local TabsLayout = Instance.new("UIListLayout")
        local TabsSpacer = Instance.new("Frame")
        local AddTabButton = Instance.new("TextButton")
        local ConsoleShortcutButton = Instance.new("ImageButton")
        local EditorContainer = Instance.new("ImageLabel")
        local LineNumberBackground = Instance.new("Frame")
        local ExecutorButtonsFrame = Instance.new("Frame")
        local ButtonsLayout = Instance.new("UIListLayout")
        local SettingsPage = Instance.new("Frame", ContentFrame)
        local SettingsListScroll = Instance.new("ScrollingFrame")
        local SettingsListLayout = Instance.new("UIListLayout")
        local SettingsDivider = Instance.new("Frame")
        Instance.new("UICorner", selected)
        local ThemePage = Instance.new("Frame", ContentFrame)
        local ThemeScroll = Instance.new("ScrollingFrame", ThemePage)
        local ThemeScrollLayout = Instance.new("UIListLayout", ThemeScroll)
        local ThemeOptionsScroll = Instance.new("ScrollingFrame", ThemePage)
        local ThemeOptionsLayout = Instance.new("UIListLayout", ThemeOptionsScroll)
        local ScriptHubPage = Instance.new("Frame", ContentFrame)
        local FavoriteScriptsScroll = Instance.new("ScrollingFrame")
        local FavoriteScriptsLayout = Instance.new("UIListLayout")
        local ScriptHubDivider = Instance.new("Frame")
        local ScriptHubResultsScroll = Instance.new("ScrollingFrame")
        local ScriptHubResultsLayout = Instance.new("UIListLayout")
        local ScriptSearchBox = Instance.new("TextBox")
        local ScriptSearchUnderline = Instance.new("Frame")
        local FavoriteScriptsLabel = Instance.new("TextButton")
        local FavoriteScriptsCorner = Instance.new("UICorner")
        local SettingsIndicator = Instance.new("Frame", SettingsPage)
        local SettingsIndicatorCorner = Instance.new("UICorner", SettingsIndicator)
        local ExplorerPage = Instance.new("Frame", ContentFrame)
        local ExplorerFilesScroll = Instance.new("ScrollingFrame")
        local ExplorerFilesLayout = Instance.new("UIListLayout")
        local ExplorerDivider = Instance.new("Frame")
        local ExplorerPathBox = Instance.new("TextBox")
        local ExplorerFavoritesLabel = Instance.new("TextButton")
        local ExplorerFavoritesCorner = Instance.new("UICorner")
        local ExplorerBackButton = Instance.new("ImageButton")
        
        ThemeOptionsScroll.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        ThemeOptionsScroll.BackgroundTransparency = 1
        ThemeOptionsScroll.BorderSizePixel = 0
        ThemeOptionsScroll.Position = UDim2.new(2.15000033, 0, 0.340000004, 0)
        ThemeOptionsScroll.Size = UDim2.new(0, 528, 0, 352)
        ThemeOptionsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        ThemeOptionsScroll.ScrollBarThickness = 5
        ThemeOptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ThemeOptionsLayout.Padding = UDim.new(0, 7)
        
        ThemePage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ThemePage.BackgroundTransparency = 1
        ThemePage.BorderSizePixel = 5
        ThemePage.Size = UDim2.new(0, 100, 0, 100)
        ThemePage.Visible = false
        
        ThemeScroll.Active = true
        ThemeScroll.Visible = false
        ThemeScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        ThemeScroll.BorderSizePixel = 0
        ThemeScroll.Position = UDim2.new(0, 0, 0.401036382, 0)
        ThemeScroll.Size = UDim2.new(0, 215, 0, 298)
        ThemeScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        ThemeScrollLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        ThemeScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ThemeScrollLayout.Padding = UDim.new(0, 8)
        
        SettingsIndicatorCorner.CornerRadius = UDim.new(0, 1000)
        SettingsIndicator.BackgroundColor3 = RGBToColor3(SynapseColorService.ThemeColor2)
        SettingsIndicator.Position = UDim2.new(0.13, 0, 0.45, 0)
        SettingsIndicator.Size = UDim2.new(0, 4, 0, 18)
        SettingsIndicator.ZIndex = 2
        
        MinimizedButton.Draggable = true
        MinimizedButton.Visible = false
        MinimizedButton.BackgroundColor3 = Color3.new(1, 1, 1)
        MinimizedButton.BorderColor3 = Color3.new(0, 0, 0)
        MinimizedButton.BorderSizePixel = 0
        MinimizedButton.Position = UDim2.new(0.173969075, 0, 0.333333343, 0)
        MinimizedButton.Size = UDim2.new(0, 20, 0, 20)
        MinimizedButton.Image = "http://www.roblox.com/asset/?id=9483813933"
        MinimizedButton.ImageColor3 = Color3.new(0, 0, 0)
        MinimizedButton.ScaleType = Enum.ScaleType.Fit
        
        MinimizedGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 4)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 255))
        })
        MinimizedCorner.CornerRadius = UDim.new(0, 0)
        
        MainCorner.CornerRadius = UDim.new(0, 5)
        MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
        MainStroke.Color = Color3.fromRGB(130, 130, 130)
        MainStroke.LineJoinMode = Enum.LineJoinMode.Round
        MainStroke.Thickness = 0.6
        MainStroke.Transparency = 0.4
        
        if launchMode == 1 and SynapseConfigs.Layout.SilentLaunch == true then
            MainFrame.Visible = false
            MinimizedButton.Visible = true
        end
        
        LogoButton.Parent = MainFrame
        LogoButton.BackgroundColor3 = Color3.new(1, 1, 1)
        LogoButton.BackgroundTransparency = 1
        LogoButton.Position = UDim2.new(0.014403807, 0, 0.0236266535, 0)
        LogoButton.Size = UDim2.new(0, 113, 0, 24)
        LogoButton.Image = "http://www.roblox.com/asset/?id=1188953704"
        LogoButton.ScaleType = Enum.ScaleType.Crop
        
        VersionLabel.Parent = LogoButton
        VersionLabel.BackgroundColor3 = Color3.new(1, 1, 1)
        VersionLabel.BackgroundTransparency = 1
        VersionLabel.Position = UDim2.new(1.04999995, 0, 0.458000004, 0)
        VersionLabel.Size = UDim2.new(0, 75, 0, 13)
        VersionLabel.Font = Enum.Font.SourceSans
        VersionLabel.Text = VERSION_STRING
        VersionLabel.TextColor3 = RGBToColor3(SynapseColorService.ThemeColor)
        VersionLabel.TextSize = 13
        VersionLabel.RichText = true
        VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        WindowControlsFrame.Parent = MainFrame
        WindowControlsFrame.BackgroundColor3 = Color3.new(1, 1, 1)
        WindowControlsFrame.BackgroundTransparency = 1
        WindowControlsFrame.Position = UDim2.new(0.812583685, 0, 0, 0)
        WindowControlsFrame.Size = UDim2.new(0, 140, 0, 26)
        
        WindowControlsLayout.Parent = WindowControlsFrame
        WindowControlsLayout.FillDirection = Enum.FillDirection.Horizontal
        WindowControlsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        WindowControlsLayout.Padding = UDim.new(0, 5)
        WindowControlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        
        MinimizeButton.Parent = WindowControlsFrame
        MinimizeButton.BackgroundColor3 = Color3.new(0.117647, 0.117647, 0.117647)
        MinimizeButton.BackgroundTransparency = 1
        MinimizeButton.BorderSizePixel = 0
        MinimizeButton.LayoutOrder = 2
        MinimizeButton.Rotation = 2
        MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
        MinimizeButton.Font = Enum.Font.SourceSans
        MinimizeButton.Text = "─ "
        MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
        MinimizeButton.TextSize = 20
        
        MaximizeButton.Parent = WindowControlsFrame
        MaximizeButton.BackgroundColor3 = Color3.new(0.117647, 0.117647, 0.117647)
        MaximizeButton.BackgroundTransparency = 1
        MaximizeButton.BorderSizePixel = 0
        MaximizeButton.LayoutOrder = 3
        MaximizeButton.Rotation = 3
        MaximizeButton.Size = UDim2.new(0, 30, 0, 30)
        MaximizeButton.Font = Enum.Font.SourceSans
        MaximizeButton.Text = "□"
        MaximizeButton.TextColor3 = Color3.new(1, 1, 1)
        MaximizeButton.TextSize = 20
        
        CloseButton.Parent = WindowControlsFrame
        CloseButton.BackgroundColor3 = Color3.new(0.117647, 0.117647, 0.117647)
        CloseButton.BackgroundTransparency = 1
        CloseButton.BorderSizePixel = 0
        CloseButton.LayoutOrder = 4
        CloseButton.Rotation = 4
        CloseButton.Size = UDim2.new(0, 30, 0, 30)
        CloseButton.Font = Enum.Font.Jura
        CloseButton.Text = "X"
        CloseButton.TextColor3 = Color3.new(1, 1, 1)
        CloseButton.TextSize = 20
        
        ContentFrame.Parent = MainFrame
        ContentFrame.BackgroundColor3 = Color3.new(1, 1, 1)
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
        ContentFrame.ClipsDescendants = true
        ContentFrame.Size = UDim2.new(0, 747, 0, 386)
        
        NavigationFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NavigationFrame.BackgroundTransparency = 1
        NavigationFrame.Position = UDim2.new(0.405622482, 0, 0.018134715, 0)
        NavigationFrame.Size = UDim2.new(0, 136, 0, 26)
        
        NavigationLayout.FillDirection = Enum.FillDirection.Horizontal
        NavigationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        NavigationLayout.SortOrder = Enum.SortOrder.LayoutOrder
        NavigationLayout.Padding = UDim.new(0, 20)
        
        ExecutorPage.Parent = ContentFrame
        ExecutorPage.BackgroundColor3 = Color3.new(1, 1, 1)
        ExecutorPage.BackgroundTransparency = 1
        ExecutorPage.Size = UDim2.new(0, 747, 0, 356)
        
        HorizontalDivider.Parent = ExecutorPage
        HorizontalDivider.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
        HorizontalDivider.BorderSizePixel = 0
        HorizontalDivider.Position = UDim2.new(0, 0, 0.764, 0)
        HorizontalDivider.Size = UDim2.new(0, 747, 0, 2)
        HorizontalDivider.ZIndex = 2
        
        VerticalDivider.Parent = ExecutorPage
        VerticalDivider.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
        VerticalDivider.BorderSizePixel = 0
        VerticalDivider.Position = UDim2.new(0.798, 0, 0.098, 0)
        VerticalDivider.Size = UDim2.new(0, 3, 0, 237)
        VerticalDivider.ZIndex = 2
        
        FileListContainer.Parent = ExecutorPage
        FileListContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        FileListContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
        FileListContainer.BorderSizePixel = 0
        FileListContainer.ClipsDescendants = true
        FileListContainer.Position = UDim2.new(0.799000025, 0, 0.0979999974, 0)
                FileListContainer.Size = UDim2.new(0, 150, 0, 190)
        
        SearchBox.Parent = FileListContainer
        SearchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        SearchBox.BorderSizePixel = 0
        SearchBox.Position = UDim2.new(0.0533333346, 0, 0.0210526325, 0)
        SearchBox.Size = UDim2.new(0, 134, 0, 22)
        SearchBox.Font = Enum.Font.SourceSans
        SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
        SearchBox.PlaceholderText = "Search..."
        SearchBox.Text = ""
        SearchBox.TextColor3 = Color3.fromRGB(200, 200, 200)
        SearchBox.TextSize = 14
        SearchBox.TextXAlignment = Enum.TextXAlignment.Left
        SearchBox.ClearTextOnFocus = false
        Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 4)
        Instance.new("UIPadding", SearchBox).PaddingLeft = UDim.new(0, 8)
        
        SearchIcon.Parent = SearchBox
        SearchIcon.BackgroundTransparency = 1
        SearchIcon.Position = UDim2.new(0.85, 0, 0.15, 0)
        SearchIcon.Size = UDim2.new(0, 16, 0, 16)
        SearchIcon.Image = "rbxassetid://10085557959"
        SearchIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
        
        FileListScroll.Parent = FileListContainer
        FileListScroll.BackgroundTransparency = 1
        FileListScroll.BorderSizePixel = 0
        FileListScroll.Position = UDim2.new(0, 0, 0.16, 0)
        FileListScroll.Size = UDim2.new(0, 150, 0, 125)
        FileListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        FileListScroll.ScrollBarThickness = 3
        FileListScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
        FileListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        FileListLayout.Parent = FileListScroll
        FileListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        FileListLayout.Padding = UDim.new(0, 2)
        FileListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        local FileButtonsFrame = Instance.new("Frame", FileListContainer)
        FileButtonsFrame.BackgroundTransparency = 1
        FileButtonsFrame.Position = UDim2.new(0, 0, 0.84, 0)
        FileButtonsFrame.Size = UDim2.new(1, 0, 0, 25)
        
        local FileButtonsLayout = Instance.new("UIListLayout", FileButtonsFrame)
        FileButtonsLayout.FillDirection = Enum.FillDirection.Horizontal
        FileButtonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        FileButtonsLayout.Padding = UDim.new(0, 3)
        
        LocalFilesButton.Parent = FileButtonsFrame
        LocalFilesButton.BackgroundColor3 = RGBToColor3(SynapseColorService.ButtonColor)
        LocalFilesButton.BorderSizePixel = 0
        LocalFilesButton.Size = UDim2.new(0, 44, 0, 22)
        LocalFilesButton.Font = Enum.Font.SourceSans
        LocalFilesButton.Text = ""
        LocalFilesButton.TextColor3 = Color3.new(1, 1, 1)
        LocalFilesButton.TextSize = 11
        Instance.new("UICorner", LocalFilesButton).CornerRadius = UDim.new(0, 4)
        
        local LocalFilesIcon = Instance.new("ImageLabel", LocalFilesButton)
        LocalFilesIcon.BackgroundTransparency = 1
        LocalFilesIcon.Position = UDim2.new(0.25, 0, 0.15, 0)
        LocalFilesIcon.Size = UDim2.new(0, 16, 0, 16)
        LocalFilesIcon.Image = getIcon(SynapseTheming.Executor.LocalFiles)
        LocalFilesIcon.ImageColor3 = RGBToColor3(SynapseColorService.ThemeColor)
        
        BookmarksButton.Parent = FileButtonsFrame
        BookmarksButton.BackgroundColor3 = RGBToColor3(SynapseColorService.ButtonColor)
        BookmarksButton.BorderSizePixel = 0
        BookmarksButton.Size = UDim2.new(0, 44, 0, 22)
        BookmarksButton.Font = Enum.Font.SourceSans
        BookmarksButton.Text = ""
        BookmarksButton.TextColor3 = Color3.new(1, 1, 1)
        BookmarksButton.TextSize = 11
        Instance.new("UICorner", BookmarksButton).CornerRadius = UDim.new(0, 4)
        
        local BookmarksIcon = Instance.new("ImageLabel", BookmarksButton)
        BookmarksIcon.BackgroundTransparency = 1
        BookmarksIcon.Position = UDim2.new(0.25, 0, 0.15, 0)
        BookmarksIcon.Size = UDim2.new(0, 16, 0, 16)
        BookmarksIcon.Image = getIcon(SynapseTheming.Executor.Bookmarks)
        BookmarksIcon.ImageColor3 = RGBToColor3(SynapseColorService.ThemeColor)
        
        AutoExecButton.Parent = FileButtonsFrame
        AutoExecButton.BackgroundColor3 = RGBToColor3(SynapseColorService.ButtonColor)
        AutoExecButton.BorderSizePixel = 0
        AutoExecButton.Size = UDim2.new(0, 44, 0, 22)
        AutoExecButton.Font = Enum.Font.SourceSans
        AutoExecButton.Text = ""
        AutoExecButton.TextColor3 = Color3.new(1, 1, 1)
        AutoExecButton.TextSize = 11
        Instance.new("UICorner", AutoExecButton).CornerRadius = UDim.new(0, 4)
        
        local AutoExecIcon = Instance.new("ImageLabel", AutoExecButton)
        AutoExecIcon.BackgroundTransparency = 1
        AutoExecIcon.Position = UDim2.new(0.25, 0, 0.15, 0)
        AutoExecIcon.Size = UDim2.new(0, 16, 0, 16)
        AutoExecIcon.Image = getIcon(SynapseTheming.Executor.AutoExecute)
        AutoExecIcon.ImageColor3 = RGBToColor3(SynapseColorService.ThemeColor)
        
        TabsScroll.Parent = ExecutorPage
        TabsScroll.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        TabsScroll.BackgroundTransparency = 1
        TabsScroll.BorderSizePixel = 0
        TabsScroll.Position = UDim2.new(0, 5, 0.098, 0)
        TabsScroll.Size = UDim2.new(0, 590, 0, 28)
        TabsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabsScroll.ScrollBarThickness = 0
        TabsScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
        TabsScroll.ScrollingDirection = Enum.ScrollingDirection.X
        
        TabsLayout.Parent = TabsScroll
        TabsLayout.FillDirection = Enum.FillDirection.Horizontal
        TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabsLayout.Padding = UDim.new(0, 3)
        TabsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        
        TabsSpacer.Parent = TabsScroll
        TabsSpacer.BackgroundTransparency = 1
        TabsSpacer.Size = UDim2.new(0, 3, 0, 1)
        TabsSpacer.LayoutOrder = -1
        
        AddTabButton.Parent = ExecutorPage
        AddTabButton.BackgroundColor3 = RGBToColor3(SynapseColorService.ButtonColor)
        AddTabButton.BorderSizePixel = 0
        AddTabButton.Position = UDim2.new(0.775, 0, 0.105, 0)
        AddTabButton.Size = UDim2.new(0, 20, 0, 20)
        AddTabButton.Font = Enum.Font.GothamBold
        AddTabButton.Text = "+"
        AddTabButton.TextColor3 = RGBToColor3(SynapseColorService.ThemeColor)
        AddTabButton.TextSize = 16
        Instance.new("UICorner", AddTabButton).CornerRadius = UDim.new(0, 4)
        
        ConsoleShortcutButton.Parent = ExecutorPage
        ConsoleShortcutButton.BackgroundTransparency = 1
        ConsoleShortcutButton.Position = UDim2.new(0.752, 0, 0.105, 0)
        ConsoleShortcutButton.Size = UDim2.new(0, 20, 0, 20)
        ConsoleShortcutButton.Image = getIcon(SynapseTheming.Top.Console)
        ConsoleShortcutButton.ImageColor3 = RGBToColor3(SynapseColorService.ThemeColor)
        ConsoleShortcutButton.Visible = SynapseConfigs.Editor.ConsoleShortcut
        
        EditorContainer.Parent = ExecutorPage
        EditorContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        EditorContainer.BackgroundTransparency = SynapseConfigs.Editor.Opacity
        EditorContainer.BorderSizePixel = 0
        EditorContainer.Position = UDim2.new(0.007, 0, 0.195, 0)
        EditorContainer.Size = UDim2.new(0, 590, 0, 165)
        EditorContainer.ClipsDescendants = true
        EditorContainer.ImageTransparency = 1
        Instance.new("UICorner", EditorContainer).CornerRadius = UDim.new(0, 5)
        
        LineNumberBackground.Parent = EditorContainer
        LineNumberBackground.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        LineNumberBackground.BorderSizePixel = 0
        LineNumberBackground.Position = UDim2.new(0, 0, 0, 0)
        LineNumberBackground.Size = UDim2.new(0, 35, 1, 0)
        
        local EditorFrame = Instance.new("ScrollingFrame", EditorContainer)
        EditorFrame.Name = "EditorFrame"
        EditorFrame.BackgroundTransparency = 1
        EditorFrame.Position = UDim2.new(0, 38, 0, 5)
        EditorFrame.Size = UDim2.new(0, 545, 0, 155)
        EditorFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        EditorFrame.ScrollBarThickness = 4
        EditorFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
        EditorFrame.AutomaticCanvasSize = Enum.AutomaticSize.XY
        
        local LineNumbers = Instance.new("TextLabel", EditorContainer)
        LineNumbers.Name = "LineNumbers"
        LineNumbers.BackgroundTransparency = 1
        LineNumbers.Position = UDim2.new(0, 5, 0, 5)
        LineNumbers.Size = UDim2.new(0, 25, 1, -10)
        LineNumbers.Font = Enum.Font.Code
        LineNumbers.Text = "1"
        LineNumbers.TextColor3 = Color3.fromRGB(100, 100, 100)
        LineNumbers.TextSize = SynapseConfigs.Editor.FontSize
        LineNumbers.TextYAlignment = Enum.TextYAlignment.Top
        LineNumbers.TextXAlignment = Enum.TextXAlignment.Right
        
        local CodeBox = Instance.new("TextBox", EditorFrame)
        CodeBox.Name = "CodeBox"
        CodeBox.BackgroundTransparency = 1
        CodeBox.Size = UDim2.new(1, 0, 1, 0)
        CodeBox.Font = Enum.Font.Code
        CodeBox.Text = SynapseConfigs.Editor.DefaultContent
        CodeBox.TextColor3 = Color3.fromRGB(220, 220, 220)
        CodeBox.TextSize = SynapseConfigs.Editor.FontSize
        CodeBox.TextXAlignment = Enum.TextXAlignment.Left
        CodeBox.TextYAlignment = Enum.TextYAlignment.Top
        CodeBox.ClearTextOnFocus = false
        CodeBox.MultiLine = true
        CodeBox.TextWrapped = false
        
        ExecutorButtonsFrame.Parent = ExecutorPage
        ExecutorButtonsFrame.BackgroundTransparency = 1
        ExecutorButtonsFrame.Position = UDim2.new(0, 5, 0.775, 0)
        ExecutorButtonsFrame.Size = UDim2.new(0, 590, 0, 40)
        
        ButtonsLayout.Parent = ExecutorButtonsFrame
        ButtonsLayout.FillDirection = Enum.FillDirection.Horizontal
        ButtonsLayout.HorizontalAlignment = SynapseConfigs.Editor.ButtonAlignment and Enum.HorizontalAlignment.Right or Enum.HorizontalAlignment.Left
        ButtonsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        ButtonsLayout.Padding = UDim.new(0, 8)
        ButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        local function CreateExecutorButton(name, iconId, layoutOrder)
            local button = Instance.new("TextButton")
            button.Name = name
            button.Parent = ExecutorButtonsFrame
            button.BackgroundColor3 = RGBToColor3(SynapseColorService.ButtonColor)
            button.BorderSizePixel = 0
            button.Size = UDim2.new(0, 75, 0, 30)
            button.Font = Enum.Font.SourceSans
            button.Text = ""
            button.TextColor3 = Color3.new(1, 1, 1)
            button.TextSize = 12
            button.LayoutOrder = layoutOrder
            button.AutoButtonColor = true
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 5)
            
            local icon = Instance.new("ImageLabel", button)
            icon.BackgroundTransparency = 1
            icon.Position = UDim2.new(0.1, 0, 0.15, 0)
            icon.Size = UDim2.new(0, 20, 0, 20)
            icon.Image = getIcon(iconId)
            icon.ImageColor3 = RGBToColor3(SynapseColorService.ThemeColor)
            
            local label = Instance.new("TextLabel", button)
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0.4, 0, 0, 0)
            label.Size = UDim2.new(0.55, 0, 1, 0)
            label.Font = Enum.Font.SourceSans
            label.Text = name
            label.TextColor3 = RGBToColor3(SynapseColorService.TextColor)
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            return button
        end
        
        local ExecuteButton = CreateExecutorButton("Execute", SynapseTheming.Executor.Execute, 1)
        local ClearButton = CreateExecutorButton("Clear", SynapseTheming.Executor.Clear, 2)
        local OpenFileButton = CreateExecutorButton("Open", SynapseTheming.Executor.OpenFile, 3)
        local ExecuteFileButton = CreateExecutorButton("Exec File", SynapseTheming.Executor.ExecuteFile, 4)
        local SaveFileButton = CreateExecutorButton("Save", SynapseTheming.Executor.SaveFile, 5)
        
        -- Settings Page Setup
        SettingsPage.BackgroundTransparency = 1
        SettingsPage.Size = UDim2.new(1, 0, 1, 0)
        SettingsPage.Visible = false
        
        local SettingsCategoriesScroll = Instance.new("ScrollingFrame", SettingsPage)
        SettingsCategoriesScroll.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        SettingsCategoriesScroll.BackgroundTransparency = 1
        SettingsCategoriesScroll.BorderSizePixel = 0
        SettingsCategoriesScroll.Position = UDim2.new(0.01, 0, 0.12, 0)
        SettingsCategoriesScroll.Size = UDim2.new(0, 150, 0, 260)
        SettingsCategoriesScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        SettingsCategoriesScroll.ScrollBarThickness = 3
        SettingsCategoriesScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        local SettingsCategoriesLayout = Instance.new("UIListLayout", SettingsCategoriesScroll)
        SettingsCategoriesLayout.SortOrder = Enum.SortOrder.LayoutOrder
        SettingsCategoriesLayout.Padding = UDim.new(0, 5)
        SettingsCategoriesLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        SettingsDivider.Parent = SettingsPage
        SettingsDivider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        SettingsDivider.BorderSizePixel = 0
        SettingsDivider.Position = UDim2.new(0.215, 0, 0.12, 0)
        SettingsDivider.Size = UDim2.new(0, 2, 0, 260)
        
        SettingsListScroll.Parent = SettingsPage
        SettingsListScroll.BackgroundTransparency = 1
        SettingsListScroll.BorderSizePixel = 0
        SettingsListScroll.Position = UDim2.new(0.23, 0, 0.12, 0)
        SettingsListScroll.Size = UDim2.new(0, 530, 0, 260)
        SettingsListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        SettingsListScroll.ScrollBarThickness = 4
        SettingsListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        SettingsListLayout.Parent = SettingsListScroll
        SettingsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        SettingsListLayout.Padding = UDim.new(0, 5)
        
        local settingsCategories = {
            {Name = "Editor", LayoutOrder = 1},
            {Name = "Layout", LayoutOrder = 2},
            {Name = "Execution", LayoutOrder = 3},
            {Name = "Advanced", LayoutOrder = 4}
        }
        
        local currentSettingsCategory = "Editor"
        
        local function CreateSettingsCategory(categoryName, layoutOrder)
            local categoryButton = Instance.new("TextButton")
            categoryButton.Name = categoryName
            categoryButton.Parent = SettingsCategoriesScroll
            categoryButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            categoryButton.BackgroundTransparency = 1
            categoryButton.BorderSizePixel = 0
            categoryButton.Size = UDim2.new(0, 140, 0, 30)
            categoryButton.Font = Enum.Font.SourceSans
            categoryButton.Text = categoryName
            categoryButton.TextColor3 = RGBToColor3(SynapseColorService.TextColor)
            categoryButton.TextSize = 14
            categoryButton.LayoutOrder = layoutOrder
            
            return categoryButton
        end
        
        for _, category in ipairs(settingsCategories) do
            CreateSettingsCategory(category.Name, category.LayoutOrder)
        end
        
        local function CreateToggleSetting(name, description, defaultValue, callback)
            local settingFrame = Instance.new("Frame")
            settingFrame.Name = name
            settingFrame.Parent = SettingsListScroll
            settingFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            settingFrame.BackgroundTransparency = 0.5
            settingFrame.BorderSizePixel = 0
            settingFrame.Size = UDim2.new(0, 510, 0, 45)
            Instance.new("UICorner", settingFrame).CornerRadius = UDim.new(0, 5)
            
            local nameLabel = Instance.new("TextLabel", settingFrame)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Position = UDim2.new(0.02, 0, 0.1, 0)
            nameLabel.Size = UDim2.new(0.7, 0, 0.4, 0)
            nameLabel.Font = Enum.Font.SourceSansSemibold
            nameLabel.Text = name
            nameLabel.TextColor3 = RGBToColor3(SynapseColorService.TextColor2)
            nameLabel.TextSize = 14
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local descLabel = Instance.new("TextLabel", settingFrame)
            descLabel.BackgroundTransparency = 1
            descLabel.Position = UDim2.new(0.02, 0, 0.5, 0)
            descLabel.Size = UDim2.new(0.7, 0, 0.4, 0)
            descLabel.Font = Enum.Font.SourceSans
            descLabel.Text = description
            descLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
            descLabel.TextSize = 12
            descLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local toggleButton = Instance.new("TextButton", settingFrame)
            toggleButton.BackgroundColor3 = defaultValue and RGBToColor3(SynapseColorService.ThemeColor2) or Color3.fromRGB(60, 60, 60)
            toggleButton.BorderSizePixel = 0
            toggleButton.Position = UDim2.new(0.9, 0, 0.25, 0)
            toggleButton.Size = UDim2.new(0, 40, 0, 22)
            toggleButton.Font = Enum.Font.SourceSans
            toggleButton.Text = ""
            Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 11)
            
            local toggleIndicator = Instance.new("Frame", toggleButton)
            toggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleIndicator.BorderSizePixel = 0
            toggleIndicator.Position = defaultValue and UDim2.new(0.5, 0, 0.1, 0) or UDim2.new(0.1, 0, 0.1, 0)
            toggleIndicator.Size = UDim2.new(0, 16, 0, 16)
            Instance.new("UICorner", toggleIndicator).CornerRadius = UDim.new(0, 8)
            
            local isEnabled = defaultValue
            
            toggleButton.MouseButton1Click:Connect(function()
                isEnabled = not isEnabled
                
                game:GetService("TweenService"):Create(toggleButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = isEnabled and RGBToColor3(SynapseColorService.ThemeColor2) or Color3.fromRGB(60, 60, 60)
                }):Play()
                
                game:GetService("TweenService"):Create(toggleIndicator, TweenInfo.new(0.2), {
                    Position = isEnabled and UDim2.new(0.5, 0, 0.1, 0) or UDim2.new(0.1, 0, 0.1, 0)
                }):Play()
                
                if callback then
                    callback(isEnabled)
                end
            end)
            
            return settingFrame
        end
        
        -- Create Navigation Buttons
        local function CreateNavButton(name, iconId, layoutOrder)
            local navButton = Instance.new("ImageButton")
            navButton.Name = name
            navButton.Parent = NavigationFrame
            navButton.BackgroundTransparency = 1
            navButton.Size = UDim2.new(0, 24, 0, 24)
            navButton.Image = getIcon(iconId)
            navButton.ImageColor3 = RGBToColor3(SynapseColorService.ThemeColor)
            navButton.LayoutOrder = layoutOrder
            
            return navButton
        end
        
        local ExecutorNavButton = CreateNavButton("Executor", SynapseTheming.Top.Executor, 1)
        local SettingsNavButton = CreateNavButton("Settings", SynapseTheming.Top.Settings, 2)
        local ThemeNavButton = CreateNavButton("Theme", SynapseTheming.Top.Theming, 3)
        local ScriptHubNavButton = CreateNavButton("ScriptHub", SynapseTheming.Top.User, 4)
        local ConsoleNavButton = CreateNavButton("Console", SynapseTheming.Top.Console, 5)
        
        -- ScriptHub Page Setup
        ScriptHubPage.Parent = ContentFrame
        ScriptHubPage.BackgroundTransparency = 1
        ScriptHubPage.Size = UDim2.new(1, 0, 1, 0)
        ScriptHubPage.Visible = false
        
        ScriptSearchBox.Parent = ScriptHubPage
        ScriptSearchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        ScriptSearchBox.BorderSizePixel = 0
        ScriptSearchBox.Position = UDim2.new(0.28, 0, 0.12, 0)
        ScriptSearchBox.Size = UDim2.new(0, 350, 0, 30)
        ScriptSearchBox.Font = Enum.Font.SourceSans
        ScriptSearchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
        ScriptSearchBox.PlaceholderText = "Search scripts..."
        ScriptSearchBox.Text = ""
        ScriptSearchBox.TextColor3 = Color3.fromRGB(200, 200, 200)
        ScriptSearchBox.TextSize = 14
        ScriptSearchBox.ClearTextOnFocus = false
        Instance.new("UICorner", ScriptSearchBox).CornerRadius = UDim.new(0, 5)
        Instance.new("UIPadding", ScriptSearchBox).PaddingLeft = UDim.new(0, 10)
        
        ScriptSearchUnderline.Parent = ScriptSearchBox
        ScriptSearchUnderline.BackgroundColor3 = RGBToColor3(SynapseColorService.ThemeColor2)
        ScriptSearchUnderline.BorderSizePixel = 0
        ScriptSearchUnderline.Position = UDim2.new(0, 0, 1, 0)
        ScriptSearchUnderline.Size = UDim2.new(1, 0, 0, 2)
        
        FavoriteScriptsLabel.Parent = ScriptHubPage
        FavoriteScriptsLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        FavoriteScriptsLabel.BorderSizePixel = 0
        FavoriteScriptsLabel.Position = UDim2.new(0.02, 0, 0.12, 0)
        FavoriteScriptsLabel.Size = UDim2.new(0, 150, 0, 30)
        FavoriteScriptsLabel.Font = Enum.Font.SourceSansSemibold
        FavoriteScriptsLabel.Text = "  Favorites"
        FavoriteScriptsLabel.TextColor3 = RGBToColor3(SynapseColorService.ThemeColor)
        FavoriteScriptsLabel.TextSize = 14
        FavoriteScriptsLabel.TextXAlignment = Enum.TextXAlignment.Left
        FavoriteScriptsCorner.Parent = FavoriteScriptsLabel
        FavoriteScriptsCorner.CornerRadius = UDim.new(0, 5)
        
        FavoriteScriptsScroll.Parent = ScriptHubPage
        FavoriteScriptsScroll.BackgroundTransparency = 1
        FavoriteScriptsScroll.BorderSizePixel = 0
        FavoriteScriptsScroll.Position = UDim2.new(0.02, 0, 0.24, 0)
        FavoriteScriptsScroll.Size = UDim2.new(0, 150, 0, 220)
        FavoriteScriptsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        FavoriteScriptsScroll.ScrollBarThickness = 3
        FavoriteScriptsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        FavoriteScriptsLayout.Parent = FavoriteScriptsScroll
        FavoriteScriptsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        FavoriteScriptsLayout.Padding = UDim.new(0, 5)
        FavoriteScriptsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        ScriptHubDivider.Parent = ScriptHubPage
        ScriptHubDivider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                ScriptHubDivider.BorderSizePixel = 0
        ScriptHubDivider.Position = UDim2.new(0.215, 0, 0.12, 0)
        ScriptHubDivider.Size = UDim2.new(0, 2, 0, 260)
        
        ScriptHubResultsScroll.Parent = ScriptHubPage
        ScriptHubResultsScroll.BackgroundTransparency = 1
        ScriptHubResultsScroll.BorderSizePixel = 0
        ScriptHubResultsScroll.Position = UDim2.new(0.23, 0, 0.24, 0)
        ScriptHubResultsScroll.Size = UDim2.new(0, 550, 0, 220)
        ScriptHubResultsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        ScriptHubResultsScroll.ScrollBarThickness = 4
        ScriptHubResultsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        ScriptHubResultsLayout.Parent = ScriptHubResultsScroll
        ScriptHubResultsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ScriptHubResultsLayout.Padding = UDim.new(0, 8)
        
        -- Explorer Page Setup
        ExplorerPage.BackgroundTransparency = 1
        ExplorerPage.Size = UDim2.new(1, 0, 1, 0)
        ExplorerPage.Visible = false
        
        ExplorerBackButton.Parent = ExplorerPage
        ExplorerBackButton.BackgroundTransparency = 1
        ExplorerBackButton.Position = UDim2.new(0.02, 0, 0.12, 0)
        ExplorerBackButton.Size = UDim2.new(0, 24, 0, 24)
        ExplorerBackButton.Image = "rbxassetid://10085570102"
        ExplorerBackButton.ImageColor3 = RGBToColor3(SynapseColorService.ThemeColor)
        
        ExplorerPathBox.Parent = ExplorerPage
        ExplorerPathBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        ExplorerPathBox.BorderSizePixel = 0
        ExplorerPathBox.Position = UDim2.new(0.07, 0, 0.12, 0)
        ExplorerPathBox.Size = UDim2.new(0, 500, 0, 28)
        ExplorerPathBox.Font = Enum.Font.SourceSans
        ExplorerPathBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
        ExplorerPathBox.PlaceholderText = "Path..."
        ExplorerPathBox.Text = "workspace/"
        ExplorerPathBox.TextColor3 = Color3.fromRGB(200, 200, 200)
        ExplorerPathBox.TextSize = 14
        ExplorerPathBox.TextXAlignment = Enum.TextXAlignment.Left
        ExplorerPathBox.ClearTextOnFocus = false
        Instance.new("UICorner", ExplorerPathBox).CornerRadius = UDim.new(0, 5)
        Instance.new("UIPadding", ExplorerPathBox).PaddingLeft = UDim.new(0, 10)
        
        ExplorerFavoritesLabel.Parent = ExplorerPage
        ExplorerFavoritesLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        ExplorerFavoritesLabel.BorderSizePixel = 0
        ExplorerFavoritesLabel.Position = UDim2.new(0.78, 0, 0.12, 0)
        ExplorerFavoritesLabel.Size = UDim2.new(0, 130, 0, 28)
        ExplorerFavoritesLabel.Font = Enum.Font.SourceSansSemibold
        ExplorerFavoritesLabel.Text = "Favorites"
        ExplorerFavoritesLabel.TextColor3 = RGBToColor3(SynapseColorService.ThemeColor)
        ExplorerFavoritesLabel.TextSize = 14
        ExplorerFavoritesCorner.Parent = ExplorerFavoritesLabel
        ExplorerFavoritesCorner.CornerRadius = UDim.new(0, 5)
        
        ExplorerDivider.Parent = ExplorerPage
        ExplorerDivider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        ExplorerDivider.BorderSizePixel = 0
        ExplorerDivider.Position = UDim2.new(0.76, 0, 0.2, 0)
        ExplorerDivider.Size = UDim2.new(0, 2, 0, 230)
        
        ExplorerFilesScroll.Parent = ExplorerPage
        ExplorerFilesScroll.BackgroundTransparency = 1
        ExplorerFilesScroll.BorderSizePixel = 0
        ExplorerFilesScroll.Position = UDim2.new(0.02, 0, 0.22, 0)
        ExplorerFilesScroll.Size = UDim2.new(0, 540, 0, 230)
        ExplorerFilesScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        ExplorerFilesScroll.ScrollBarThickness = 4
        ExplorerFilesScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        ExplorerFilesLayout.Parent = ExplorerFilesScroll
        ExplorerFilesLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ExplorerFilesLayout.Padding = UDim.new(0, 5)
        
        -- Console Page
        local ConsolePage = Instance.new("Frame", ContentFrame)
        ConsolePage.Name = "ConsolePage"
        ConsolePage.BackgroundTransparency = 1
        ConsolePage.Size = UDim2.new(1, 0, 1, 0)
        ConsolePage.Visible = false
        
        local ConsoleOutput = Instance.new("ScrollingFrame", ConsolePage)
        ConsoleOutput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        ConsoleOutput.BorderSizePixel = 0
        ConsoleOutput.Position = UDim2.new(0.01, 0, 0.1, 0)
        ConsoleOutput.Size = UDim2.new(0, 720, 0, 200)
        ConsoleOutput.CanvasSize = UDim2.new(0, 0, 0, 0)
        ConsoleOutput.ScrollBarThickness = 4
        ConsoleOutput.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Instance.new("UICorner", ConsoleOutput).CornerRadius = UDim.new(0, 5)
        
        local ConsoleOutputLayout = Instance.new("UIListLayout", ConsoleOutput)
        ConsoleOutputLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ConsoleOutputLayout.Padding = UDim.new(0, 2)
        
        local ConsoleInputBox = Instance.new("TextBox", ConsolePage)
        ConsoleInputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        ConsoleInputBox.BorderSizePixel = 0
        ConsoleInputBox.Position = UDim2.new(0.01, 0, 0.78, 0)
        ConsoleInputBox.Size = UDim2.new(0, 620, 0, 30)
        ConsoleInputBox.Font = Enum.Font.Code
        ConsoleInputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
        ConsoleInputBox.PlaceholderText = "> Enter command..."
        ConsoleInputBox.Text = ""
        ConsoleInputBox.TextColor3 = Color3.fromRGB(200, 200, 200)
        ConsoleInputBox.TextSize = 14
        ConsoleInputBox.TextXAlignment = Enum.TextXAlignment.Left
        ConsoleInputBox.ClearTextOnFocus = false
        Instance.new("UICorner", ConsoleInputBox).CornerRadius = UDim.new(0, 5)
        Instance.new("UIPadding", ConsoleInputBox).PaddingLeft = UDim.new(0, 10)
        
        local ConsoleExecuteButton = Instance.new("TextButton", ConsolePage)
        ConsoleExecuteButton.BackgroundColor3 = RGBToColor3(SynapseColorService.ButtonColor)
        ConsoleExecuteButton.BorderSizePixel = 0
        ConsoleExecuteButton.Position = UDim2.new(0.86, 0, 0.78, 0)
        ConsoleExecuteButton.Size = UDim2.new(0, 90, 0, 30)
        ConsoleExecuteButton.Font = Enum.Font.SourceSansSemibold
        ConsoleExecuteButton.Text = "Execute"
        ConsoleExecuteButton.TextColor3 = RGBToColor3(SynapseColorService.TextColor)
        ConsoleExecuteButton.TextSize = 14
        Instance.new("UICorner", ConsoleExecuteButton).CornerRadius = UDim.new(0, 5)
        
        local ConsoleClearButton = Instance.new("TextButton", ConsolePage)
        ConsoleClearButton.BackgroundColor3 = RGBToColor3(SynapseColorService.ButtonColor)
        ConsoleClearButton.BorderSizePixel = 0
        ConsoleClearButton.Position = UDim2.new(0.71, 0, 0.78, 0)
        ConsoleClearButton.Size = UDim2.new(0, 90, 0, 30)
        ConsoleClearButton.Font = Enum.Font.SourceSansSemibold
        ConsoleClearButton.Text = "Clear"
        ConsoleClearButton.TextColor3 = RGBToColor3(SynapseColorService.TextColor)
        ConsoleClearButton.TextSize = 14
        Instance.new("UICorner", ConsoleClearButton).CornerRadius = UDim.new(0, 5)
        
        -- Tab System
        local TabsData = {}
        local CurrentTab = nil
        local TabCount = 0
        
        local function CreateTab(tabName, content)
            TabCount = TabCount + 1
            local tabId = TabCount
            
            local tabButton = Instance.new("TextButton")
            tabButton.Name = "Tab_" .. tabId
            tabButton.Parent = TabsScroll
            tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            tabButton.BorderSizePixel = 0
            tabButton.Size = SynapseConfigs.Editor.CompactTabs and UDim2.new(0, 80, 0, 22) or UDim2.new(0, 120, 0, 22)
            tabButton.Font = Enum.Font.SourceSans
            tabButton.Text = "  " .. (tabName or "Script " .. tabId)
            tabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
            tabButton.TextSize = 12
            tabButton.TextXAlignment = Enum.TextXAlignment.Left
            tabButton.TextTruncate = Enum.TextTruncate.AtEnd
            tabButton.LayoutOrder = tabId
            tabButton.ClipsDescendants = true
            Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 4)
            
            local closeButton = Instance.new("TextButton", tabButton)
            closeButton.BackgroundTransparency = 1
            closeButton.Position = UDim2.new(1, -20, 0, 0)
            closeButton.Size = UDim2.new(0, 20, 1, 0)
            closeButton.Font = Enum.Font.SourceSansBold
            closeButton.Text = "×"
            closeButton.TextColor3 = Color3.fromRGB(150, 150, 150)
            closeButton.TextSize = 16
            
            local tabData = {
                Id = tabId,
                Button = tabButton,
                Content = content or SynapseConfigs.Editor.DefaultContent,
                Name = tabName or "Script " .. tabId,
                Saved = true
            }
            
            TabsData[tabId] = tabData
            
            local function SelectTab()
                if CurrentTab then
                    CurrentTab.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    CurrentTab.Button.TextColor3 = Color3.fromRGB(180, 180, 180)
                    CurrentTab.Content = CodeBox.Text
                end
                
                CurrentTab = tabData
                tabButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                tabButton.TextColor3 = RGBToColor3(SynapseColorService.ThemeColor2)
                CodeBox.Text = tabData.Content
                
                -- Update line numbers
                local lines = #string.split(tabData.Content, "\n")
                local lineText = ""
                for i = 1, lines do
                    lineText = lineText .. i .. "\n"
                end
                LineNumbers.Text = lineText
            end
            
            tabButton.MouseButton1Click:Connect(SelectTab)
            
            closeButton.MouseButton1Click:Connect(function()
                if #TabsData > 1 then
                    tabButton:Destroy()
                    TabsData[tabId] = nil
                    
                    if CurrentTab == tabData then
                        for _, tab in pairs(TabsData) do
                            CurrentTab = nil
                            tab.Button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                            tab.Button.TextColor3 = RGBToColor3(SynapseColorService.ThemeColor2)
                            CodeBox.Text = tab.Content
                            CurrentTab = tab
                            break
                        end
                    end
                end
            end)
            
            closeButton.MouseEnter:Connect(function()
                closeButton.TextColor3 = Color3.fromRGB(255, 100, 100)
            end)
            
            closeButton.MouseLeave:Connect(function()
                closeButton.TextColor3 = Color3.fromRGB(150, 150, 150)
            end)
            
            if not CurrentTab then
                SelectTab()
            end
            
            return tabData
        end
        
        CreateTab("Script 1", SynapseConfigs.Editor.DefaultContent)
        
        AddTabButton.MouseButton1Click:Connect(function()
            local tabLimit = SynapseConfigs.Editor.TabCountLimit
            if tabLimit == 0 or TabCount < tabLimit then
                CreateTab()
            else
                NotificationModule:Notify("Tab Limit", "Maximum tab limit reached!", 3)
            end
        end)
        
        -- Line Number Updates
        CodeBox:GetPropertyChangedSignal("Text"):Connect(function()
            local lines = #string.split(CodeBox.Text, "\n")
            local lineText = ""
            for i = 1, math.max(lines, 1) do
                lineText = lineText .. i .. "\n"
            end
            LineNumbers.Text = lineText
            
            if CurrentTab then
                CurrentTab.Content = CodeBox.Text
                CurrentTab.Saved = false
            end
        end)
        
        -- Dragging System
        local dragging = false
        local dragInput
        local dragStart
        local startPos
        
        local function UpdateDrag(input)
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
        
        LogoButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = MainFrame.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        LogoButton.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                UpdateDrag(input)
            end
        end)
        
        -- Window Controls
        MinimizeButton.MouseButton1Click:Connect(function()
            MainFrame.Visible = false
            MinimizedButton.Visible = true
            SynapseVariables.oldpos = MainFrame.Position
        end)
        
        MinimizedButton.MouseButton1Click:Connect(function()
            MainFrame.Visible = true
            MinimizedButton.Visible = false
        end)
        
        local isMaximized = false
        local originalSize = MainFrame.Size
        local originalPosition = MainFrame.Position
        
        MaximizeButton.MouseButton1Click:Connect(function()
            if isMaximized then
                MainFrame.Size = originalSize
                MainFrame.Position = originalPosition
                isMaximized = false
            else
                originalSize = MainFrame.Size
                originalPosition = MainFrame.Position
                MainFrame.Size = UDim2.new(1, 0, 1, 0)
                MainFrame.Position = UDim2.new(0, 0, 0, 0)
                isMaximized = true
            end
        end)
        
        CloseButton.MouseButton1Click:Connect(function()
            if SynapseConfigs.Layout.CloseConfirm then
                -- Show confirmation dialog
                local confirmFrame = Instance.new("Frame", ScreenGui)
                confirmFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                confirmFrame.Position = UDim2.new(0.5, -150, 0.5, -60)
                confirmFrame.Size = UDim2.new(0, 300, 0, 120)
                Instance.new("UICorner", confirmFrame).CornerRadius = UDim.new(0, 8)
                Instance.new("UIStroke", confirmFrame).Color = Color3.fromRGB(80, 80, 80)
                
                local confirmLabel = Instance.new("TextLabel", confirmFrame)
                confirmLabel.BackgroundTransparency = 1
                confirmLabel.Position = UDim2.new(0, 0, 0.1, 0)
                confirmLabel.Size = UDim2.new(1, 0, 0.4, 0)
                confirmLabel.Font = Enum.Font.SourceSansSemibold
                confirmLabel.Text = "Are you sure you want to close?"
                confirmLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                confirmLabel.TextSize = 16
                
                local yesButton = Instance.new("TextButton", confirmFrame)
                yesButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
                yesButton.Position = UDim2.new(0.1, 0, 0.6, 0)
                yesButton.Size = UDim2.new(0.35, 0, 0.3, 0)
                yesButton.Font = Enum.Font.SourceSansSemibold
                yesButton.Text = "Yes"
                yesButton.TextColor3 = Color3.new(1, 1, 1)
                yesButton.TextSize = 14
                Instance.new("UICorner", yesButton).CornerRadius = UDim.new(0, 5)
                
                local noButton = Instance.new("TextButton", confirmFrame)
                noButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                noButton.Position = UDim2.new(0.55, 0, 0.6, 0)
                noButton.Size = UDim2.new(0.35, 0, 0.3, 0)
                noButton.Font = Enum.Font.SourceSansSemibold
                noButton.Text = "No"
                noButton.TextColor3 = Color3.new(1, 1, 1)
                noButton.TextSize = 14
                Instance.new("UICorner", noButton).CornerRadius = UDim.new(0, 5)
                
                yesButton.MouseButton1Click:Connect(function()
                    SynapseVariables.oldpos = MainFrame.Position
                    getgenv().xihHl4J4OCYYFGa1OJgGZn = false
                    ScreenGui:Destroy()
                end)
                
                noButton.MouseButton1Click:Connect(function()
                    confirmFrame:Destroy()
                end)
            else
                SynapseVariables.oldpos = MainFrame.Position
                getgenv().xihHl4J4OCYYFGa1OJgGZn = false
                ScreenGui:Destroy()
            end
        end)
        
        -- Navigation System
        local Pages = {
            Executor = ExecutorPage,
            Settings = SettingsPage,
            Theme = ThemePage,
            ScriptHub = ScriptHubPage,
            Console = ConsolePage
        }
        
        local function SwitchPage(pageName)
            for name, page in pairs(Pages) do
                page.Visible = (name == pageName)
            end
            currentPageIndex = pageName
        end
        
        ExecutorNavButton.MouseButton1Click:Connect(function()
            SwitchPage("Executor")
        end)
        
        SettingsNavButton.MouseButton1Click:Connect(function()
            SwitchPage("Settings")
        end)
        
        ThemeNavButton.MouseButton1Click:Connect(function()
            SwitchPage("Theme")
        end)
        
        ScriptHubNavButton.MouseButton1Click:Connect(function()
            SwitchPage("ScriptHub")
        end)
        
        ConsoleNavButton.MouseButton1Click:Connect(function()
            SwitchPage("Console")
        end)
        
        ConsoleShortcutButton.MouseButton1Click:Connect(function()
            SwitchPage("Console")
        end)
        
        -- Executor Button Functions
        ExecuteButton.MouseButton1Click:Connect(function()
            local code = CodeBox.Text
            if code and code ~= "" then
                local success, err = pcall(function()
                    loadstring(code)()
                end)
                if not success then
                    NotificationModule:Notify("Execution Error", tostring(err), 5)
                else
                    NotificationModule:Notify("Success", "Script executed successfully!", 2)
                end
            end
        end)
        
        ClearButton.MouseButton1Click:Connect(function()
            CodeBox.Text = ""
            if CurrentTab then
                CurrentTab.Content = ""
            end
        end)
        
        SaveFileButton.MouseButton1Click:Connect(function()
            if CurrentTab then
                local fileName = CurrentTab.Name
                if not string.find(fileName, ".lua") then
                    fileName = fileName .. ".lua"
                end
                writeFile("Scripts/" .. fileName, CodeBox.Text)
                CurrentTab.Saved = true
                NotificationModule:Notify("Saved", "File saved as " .. fileName, 2)
            end
        end)
        
        -- File List System
        local currentFileMode = "local" -- local, bookmarks, autoexec
        
        local function LoadFileList(mode)
            currentFileMode = mode
            for _, child in pairs(FileListScroll:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end
            
            local folder = "Scripts"
            if mode == "autoexec" then
                folder = "autoexec"
            elseif mode == "bookmarks" then
                folder = "Bookmarks"
            end
            
            if not isFolder(folder) then
                makeFolder(folder)
            end
            
            local files = listFiles(folder)
            for i, filePath in ipairs(files) do
                local fileName = string.gsub(filePath, folder .. "/", "")
                local fileButton = Instance.new("TextButton")
                fileButton.Name = fileName
                fileButton.Parent = FileListScroll
                fileButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                fileButton.BackgroundTransparency = 0.5
                fileButton.BorderSizePixel = 0
                fileButton.Size = UDim2.new(0, 140, 0, 24)
                fileButton.Font = Enum.Font.SourceSans
                fileButton.Text = "  " .. fileName
                fileButton.TextColor3 = Color3.fromRGB(180, 180, 180)
                fileButton.TextSize = 12
                fileButton.TextXAlignment = Enum.TextXAlignment.Left
                fileButton.TextTruncate = Enum.TextTruncate.AtEnd
                fileButton.LayoutOrder = i
                Instance.new("UICorner", fileButton).CornerRadius = UDim.new(0, 4)
                
                fileButton.MouseButton1Click:Connect(function()
                    local content = readFile(filePath)
                    if CurrentTab then
                        CurrentTab.Content = content
                        CurrentTab.Name = fileName
                        CurrentTab.Button.Text = "  " .. fileName
                    end
                    CodeBox.Text = content
                end)
                
                fileButton.MouseEnter:Connect(function()
                    fileButton.BackgroundTransparency = 0.3
                end)
                
                fileButton.MouseLeave:Connect(function()
                    fileButton.BackgroundTransparency = 0.5
                end)
            end
        end
        
        LoadFileList("local")
        
        LocalFilesButton.MouseButton1Click:Connect(function()
            LoadFileList("local")
            LocalFilesIcon.ImageColor3 = RGBToColor3(SynapseColorService.ThemeColor2)
            BookmarksIcon.ImageColor3 = RGBToColor3(SynapseColorService.ThemeColor)
            AutoExecIcon.ImageColor3 = RGBToColor3(SynapseColorService.ThemeColor)
        end)
        
        BookmarksButton.MouseButton1Click:Connect(function()
            LoadFileList("bookmarks")
            LocalFilesIcon.ImageColor3 = RGBToColor3(SynapseColorService.ThemeColor)
            BookmarksIcon.ImageColor3 = RGBToColor3(SynapseColorService.ThemeColor2)
            AutoExecIcon.ImageColor3 = RGBToColor3(SynapseColorService.ThemeColor)
        end)
        
        AutoExecButton.MouseButton1Click:Connect(function()
            LoadFileList("autoexec")
            LocalFilesIcon.ImageColor3 = RGBToColor3(SynapseColorService.ThemeColor)
            BookmarksIcon.ImageColor3 = RGBToColor3(SynapseColorService.ThemeColor)
            AutoExecIcon.ImageColor3 = RGBToColor3(SynapseColorService.ThemeColor2)
        end)
        
        -- Search functionality
        SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
            local searchText = string.lower(SearchBox.Text)
            for _, child in pairs(FileListScroll:GetChildren()) do
                if child:IsA("TextButton") then
                    if searchText == "" then
                        child.Visible = true
                    else
                        child.Visible = string.find(string.lower(child.Name), searchText) ~= nil
                    end
                end
            end
        end)
        
        -- Console System
        local function AddConsoleMessage(message, messageType)
            local messageFrame = Instance.new("Frame", ConsoleOutput)
            messageFrame.BackgroundTransparency = 1
            messageFrame.Size = UDim2.new(1, 0, 0, 20)
            
            local timestamp = os.date("[%H:%M:%S] ")
            local messageLabel = Instance.new("TextLabel", messageFrame)
            messageLabel.BackgroundTransparency = 1
            messageLabel.Size = UDim2.new(1, -10, 1, 0)
            messageLabel.Position = UDim2.new(0, 5, 0, 0)
            messageLabel.Font = Enum.Font.Code
            messageLabel.Text = timestamp .. tostring(message)
            messageLabel.TextSize = 12
            messageLabel.TextXAlignment = Enum.TextXAlignment.Left
            messageLabel.TextTruncate = Enum.TextTruncate.AtEnd
            
            if messageType == "error" then
                messageLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            elseif messageType == "warn" then
                messageLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
            elseif messageType == "success" then
                messageLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            else
                messageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
        
        ConsoleExecuteButton.MouseButton1Click:Connect(function()
            local command = ConsoleInputBox.Text
            if command and command ~= "" then
                AddConsoleMessage("> " .. command, "info")
                local success, result = pcall(function()
                    return loadstring("return " .. command)() or loadstring(command)()
                end)
                if success then
                    if result ~= nil then
                        AddConsoleMessage(tostring(result), "success")
                    else
                        AddConsoleMessage("Executed successfully", "success")
                    end
                else
                    AddConsoleMessage(tostring(result), "error")
                end
                ConsoleInputBox.Text = ""
            end
        end)
        
        ConsoleInputBox.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                ConsoleExecuteButton.MouseButton1Click:Fire()
            end
        end)
        
        ConsoleClearButton.MouseButton1Click:Connect(function()
            for _, child in pairs(ConsoleOutput:GetChildren()) do
                if child:IsA("Frame") then
                    child:Destroy()
                end
            end
        end)
        
        -- Settings Toggle Functions
        CreateToggleSetting("Console Shortcut", "Show console shortcut button in executor", SynapseConfigs.Editor.ConsoleShortcut, function(value)
                        SynapseConfigs.Editor.ConsoleShortcut = value
            ConsoleShortcutButton.Visible = value
        end)
        
        CreateToggleSetting("Compact Tabs", "Use smaller tab sizes", SynapseConfigs.Editor.CompactTabs, function(value)
            SynapseConfigs.Editor.CompactTabs = value
            for _, tabData in pairs(TabsData) do
                tabData.Button.Size = value and UDim2.new(0, 80, 0, 22) or UDim2.new(0, 120, 0, 22)
            end
        end)
        
        CreateToggleSetting("Button Alignment Right", "Align executor buttons to the right", SynapseConfigs.Editor.ButtonAlignment, function(value)
            SynapseConfigs.Editor.ButtonAlignment = value
            ButtonsLayout.HorizontalAlignment = value and Enum.HorizontalAlignment.Right or Enum.HorizontalAlignment.Left
        end)
        
        CreateToggleSetting("Close Confirmation", "Show confirmation dialog when closing", SynapseConfigs.Layout.CloseConfirm, function(value)
            SynapseConfigs.Layout.CloseConfirm = value
        end)
        
        CreateToggleSetting("Auto Execute", "Automatically execute scripts in autoexec folder", SynapseConfigs.Execution.AutoExecute, function(value)
            SynapseConfigs.Execution.AutoExecute = value
        end)
        
        CreateToggleSetting("Top Most", "Keep window on top of other windows", SynapseConfigs.Layout.TopMost, function(value)
            SynapseConfigs.Layout.TopMost = value
        end)
        
        -- Theme Page Setup
        ThemePage.Parent = ContentFrame
        ThemePage.BackgroundTransparency = 1
        ThemePage.Size = UDim2.new(1, 0, 1, 0)
        ThemePage.Visible = false
        
        local ThemeTitle = Instance.new("TextLabel", ThemePage)
        ThemeTitle.BackgroundTransparency = 1
        ThemeTitle.Position = UDim2.new(0.02, 0, 0.08, 0)
        ThemeTitle.Size = UDim2.new(0, 200, 0, 30)
        ThemeTitle.Font = Enum.Font.SourceSansSemibold
        ThemeTitle.Text = "Theme Customization"
        ThemeTitle.TextColor3 = RGBToColor3(SynapseColorService.ThemeColor)
        ThemeTitle.TextSize = 18
        ThemeTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        local ThemePresetsScroll = Instance.new("ScrollingFrame", ThemePage)
        ThemePresetsScroll.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        ThemePresetsScroll.BackgroundTransparency = 0.5
        ThemePresetsScroll.BorderSizePixel = 0
        ThemePresetsScroll.Position = UDim2.new(0.02, 0, 0.18, 0)
        ThemePresetsScroll.Size = UDim2.new(0, 180, 0, 240)
        ThemePresetsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        ThemePresetsScroll.ScrollBarThickness = 3
        ThemePresetsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Instance.new("UICorner", ThemePresetsScroll).CornerRadius = UDim.new(0, 5)
        
        local ThemePresetsLayout = Instance.new("UIListLayout", ThemePresetsScroll)
        ThemePresetsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ThemePresetsLayout.Padding = UDim.new(0, 5)
        ThemePresetsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        local ThemePresetsPadding = Instance.new("UIPadding", ThemePresetsScroll)
        ThemePresetsPadding.PaddingTop = UDim.new(0, 5)
        ThemePresetsPadding.PaddingBottom = UDim.new(0, 5)
        
        local ThemeColorsFrame = Instance.new("Frame", ThemePage)
        ThemeColorsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        ThemeColorsFrame.BackgroundTransparency = 0.5
        ThemeColorsFrame.BorderSizePixel = 0
        ThemeColorsFrame.Position = UDim2.new(0.27, 0, 0.18, 0)
        ThemeColorsFrame.Size = UDim2.new(0, 520, 0, 240)
        Instance.new("UICorner", ThemeColorsFrame).CornerRadius = UDim.new(0, 5)
        
        local ThemeColorsScroll = Instance.new("ScrollingFrame", ThemeColorsFrame)
        ThemeColorsScroll.BackgroundTransparency = 1
        ThemeColorsScroll.BorderSizePixel = 0
        ThemeColorsScroll.Position = UDim2.new(0, 0, 0, 0)
        ThemeColorsScroll.Size = UDim2.new(1, 0, 1, 0)
        ThemeColorsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        ThemeColorsScroll.ScrollBarThickness = 4
        ThemeColorsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        local ThemeColorsLayout = Instance.new("UIListLayout", ThemeColorsScroll)
        ThemeColorsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ThemeColorsLayout.Padding = UDim.new(0, 5)
        
        local ThemeColorsPadding = Instance.new("UIPadding", ThemeColorsScroll)
        ThemeColorsPadding.PaddingTop = UDim.new(0, 10)
        ThemeColorsPadding.PaddingLeft = UDim.new(0, 10)
        ThemeColorsPadding.PaddingRight = UDim.new(0, 10)
        
        -- Theme Presets
        local ThemePresets = {
            {Name = "Default Purple", ThemeColor = {138, 43, 226}, ThemeColor2 = {180, 100, 255}},
            {Name = "Ocean Blue", ThemeColor = {30, 144, 255}, ThemeColor2 = {100, 180, 255}},
            {Name = "Forest Green", ThemeColor = {34, 139, 34}, ThemeColor2 = {50, 205, 50}},
            {Name = "Sunset Orange", ThemeColor = {255, 140, 0}, ThemeColor2 = {255, 180, 100}},
            {Name = "Cherry Red", ThemeColor = {220, 20, 60}, ThemeColor2 = {255, 99, 71}},
            {Name = "Midnight", ThemeColor = {75, 0, 130}, ThemeColor2 = {138, 43, 226}},
            {Name = "Aqua", ThemeColor = {0, 206, 209}, ThemeColor2 = {127, 255, 212}},
            {Name = "Gold", ThemeColor = {255, 215, 0}, ThemeColor2 = {255, 235, 100}},
            {Name = "Pink", ThemeColor = {255, 105, 180}, ThemeColor2 = {255, 182, 193}},
            {Name = "Cyber", ThemeColor = {0, 255, 255}, ThemeColor2 = {255, 0, 255}}
        }
        
        local function ApplyTheme(themeColor, themeColor2)
            SynapseColorService.ThemeColor = themeColor
            SynapseColorService.ThemeColor2 = themeColor2
            
            -- Update all themed elements
            LogoButton.ImageColor3 = RGBToColor3(themeColor)
            TitleLabel.TextColor3 = RGBToColor3(themeColor2)
            AddTabButton.TextColor3 = RGBToColor3(themeColor)
            ConsoleShortcutButton.ImageColor3 = RGBToColor3(themeColor)
            
            for _, navButton in pairs(NavigationFrame:GetChildren()) do
                if navButton:IsA("ImageButton") then
                    navButton.ImageColor3 = RGBToColor3(themeColor)
                end
            end
            
            if CurrentTab then
                CurrentTab.Button.TextColor3 = RGBToColor3(themeColor2)
            end
            
            LocalFilesIcon.ImageColor3 = RGBToColor3(currentFileMode == "local" and themeColor2 or themeColor)
            BookmarksIcon.ImageColor3 = RGBToColor3(currentFileMode == "bookmarks" and themeColor2 or themeColor)
            AutoExecIcon.ImageColor3 = RGBToColor3(currentFileMode == "autoexec" and themeColor2 or themeColor)
            
            ScriptSearchUnderline.BackgroundColor3 = RGBToColor3(themeColor2)
            FavoriteScriptsLabel.TextColor3 = RGBToColor3(themeColor)
            ExplorerFavoritesLabel.TextColor3 = RGBToColor3(themeColor)
            ExplorerBackButton.ImageColor3 = RGBToColor3(themeColor)
            ThemeTitle.TextColor3 = RGBToColor3(themeColor)
        end
        
        local function CreateThemePreset(preset, layoutOrder)
            local presetButton = Instance.new("TextButton")
            presetButton.Name = preset.Name
            presetButton.Parent = ThemePresetsScroll
            presetButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            presetButton.BorderSizePixel = 0
            presetButton.Size = UDim2.new(0, 165, 0, 35)
            presetButton.Font = Enum.Font.SourceSans
            presetButton.Text = ""
            presetButton.LayoutOrder = layoutOrder
            Instance.new("UICorner", presetButton).CornerRadius = UDim.new(0, 5)
            
            local colorIndicator = Instance.new("Frame", presetButton)
            colorIndicator.BackgroundColor3 = Color3.fromRGB(unpack(preset.ThemeColor))
            colorIndicator.BorderSizePixel = 0
            colorIndicator.Position = UDim2.new(0, 8, 0.2, 0)
            colorIndicator.Size = UDim2.new(0, 20, 0.6, 0)
            Instance.new("UICorner", colorIndicator).CornerRadius = UDim.new(0, 4)
            
            local colorIndicator2 = Instance.new("Frame", presetButton)
            colorIndicator2.BackgroundColor3 = Color3.fromRGB(unpack(preset.ThemeColor2))
            colorIndicator2.BorderSizePixel = 0
            colorIndicator2.Position = UDim2.new(0, 32, 0.2, 0)
            colorIndicator2.Size = UDim2.new(0, 20, 0.6, 0)
            Instance.new("UICorner", colorIndicator2).CornerRadius = UDim.new(0, 4)
            
            local presetLabel = Instance.new("TextLabel", presetButton)
            presetLabel.BackgroundTransparency = 1
            presetLabel.Position = UDim2.new(0, 58, 0, 0)
            presetLabel.Size = UDim2.new(1, -60, 1, 0)
            presetLabel.Font = Enum.Font.SourceSans
            presetLabel.Text = preset.Name
            presetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            presetLabel.TextSize = 13
            presetLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            presetButton.MouseButton1Click:Connect(function()
                ApplyTheme(preset.ThemeColor, preset.ThemeColor2)
                NotificationModule:Notify("Theme Applied", preset.Name .. " theme applied!", 2)
            end)
            
            presetButton.MouseEnter:Connect(function()
                presetButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            end)
            
            presetButton.MouseLeave:Connect(function()
                presetButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            end)
        end
        
        for i, preset in ipairs(ThemePresets) do
            CreateThemePreset(preset, i)
        end
        
        -- Color Picker Function
        local function CreateColorSetting(colorName, colorKey, layoutOrder)
            local colorFrame = Instance.new("Frame")
            colorFrame.Name = colorName
            colorFrame.Parent = ThemeColorsScroll
            colorFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            colorFrame.BackgroundTransparency = 0.5
            colorFrame.BorderSizePixel = 0
            colorFrame.Size = UDim2.new(1, -20, 0, 40)
            colorFrame.LayoutOrder = layoutOrder
            Instance.new("UICorner", colorFrame).CornerRadius = UDim.new(0, 5)
            
            local colorLabel = Instance.new("TextLabel", colorFrame)
            colorLabel.BackgroundTransparency = 1
            colorLabel.Position = UDim2.new(0.02, 0, 0, 0)
            colorLabel.Size = UDim2.new(0.5, 0, 1, 0)
            colorLabel.Font = Enum.Font.SourceSans
            colorLabel.Text = colorName
            colorLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            colorLabel.TextSize = 14
            colorLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local currentColor = SynapseColorService[colorKey] or {128, 128, 128}
            
            local colorDisplay = Instance.new("Frame", colorFrame)
            colorDisplay.BackgroundColor3 = Color3.fromRGB(unpack(currentColor))
            colorDisplay.BorderSizePixel = 0
            colorDisplay.Position = UDim2.new(0.85, 0, 0.15, 0)
            colorDisplay.Size = UDim2.new(0, 50, 0.7, 0)
            Instance.new("UICorner", colorDisplay).CornerRadius = UDim.new(0, 5)
            
            local rInput = Instance.new("TextBox", colorFrame)
            rInput.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
            rInput.BorderSizePixel = 0
            rInput.Position = UDim2.new(0.5, 0, 0.15, 0)
            rInput.Size = UDim2.new(0, 40, 0.7, 0)
            rInput.Font = Enum.Font.Code
            rInput.Text = tostring(currentColor[1])
            rInput.TextColor3 = Color3.fromRGB(255, 150, 150)
            rInput.TextSize = 12
            rInput.ClearTextOnFocus = false
            Instance.new("UICorner", rInput).CornerRadius = UDim.new(0, 4)
            
            local gInput = Instance.new("TextBox", colorFrame)
            gInput.BackgroundColor3 = Color3.fromRGB(30, 60, 30)
            gInput.BorderSizePixel = 0
            gInput.Position = UDim2.new(0.6, 0, 0.15, 0)
            gInput.Size = UDim2.new(0, 40, 0.7, 0)
            gInput.Font = Enum.Font.Code
            gInput.Text = tostring(currentColor[2])
            gInput.TextColor3 = Color3.fromRGB(150, 255, 150)
            gInput.TextSize = 12
            gInput.ClearTextOnFocus = false
            Instance.new("UICorner", gInput).CornerRadius = UDim.new(0, 4)
            
            local bInput = Instance.new("TextBox", colorFrame)
            bInput.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
            bInput.BorderSizePixel = 0
            bInput.Position = UDim2.new(0.7, 0, 0.15, 0)
            bInput.Size = UDim2.new(0, 40, 0.7, 0)
            bInput.Font = Enum.Font.Code
            bInput.Text = tostring(currentColor[3])
            bInput.TextColor3 = Color3.fromRGB(150, 150, 255)
            bInput.TextSize = 12
            bInput.ClearTextOnFocus = false
            Instance.new("UICorner", bInput).CornerRadius = UDim.new(0, 4)
            
            local function UpdateColor()
                local r = math.clamp(tonumber(rInput.Text) or 0, 0, 255)
                local g = math.clamp(tonumber(gInput.Text) or 0, 0, 255)
                local b = math.clamp(tonumber(bInput.Text) or 0, 0, 255)
                
                rInput.Text = tostring(r)
                gInput.Text = tostring(g)
                bInput.Text = tostring(b)
                
                colorDisplay.BackgroundColor3 = Color3.fromRGB(r, g, b)
                SynapseColorService[colorKey] = {r, g, b}
                
                if colorKey == "ThemeColor" or colorKey == "ThemeColor2" then
                    ApplyTheme(SynapseColorService.ThemeColor, SynapseColorService.ThemeColor2)
                end
            end
            
            rInput.FocusLost:Connect(UpdateColor)
            gInput.FocusLost:Connect(UpdateColor)
            bInput.FocusLost:Connect(UpdateColor)
        end
        
        CreateColorSetting("Theme Color", "ThemeColor", 1)
        CreateColorSetting("Theme Color 2", "ThemeColor2", 2)
        CreateColorSetting("Background Color", "BackgroundColor", 3)
        CreateColorSetting("Button Color", "ButtonColor", 4)
        CreateColorSetting("Text Color", "TextColor", 5)
        CreateColorSetting("Text Color 2", "TextColor2", 6)
        
        -- Script Hub Functions
        local function CreateScriptCard(scriptData, layoutOrder)
            local scriptCard = Instance.new("Frame")
            scriptCard.Name = scriptData.Name
            scriptCard.Parent = ScriptHubResultsScroll
            scriptCard.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            scriptCard.BorderSizePixel = 0
            scriptCard.Size = UDim2.new(1, -20, 0, 80)
            scriptCard.LayoutOrder = layoutOrder
            Instance.new("UICorner", scriptCard).CornerRadius = UDim.new(0, 8)
            
            local scriptIcon = Instance.new("ImageLabel", scriptCard)
            scriptIcon.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            scriptIcon.Position = UDim2.new(0, 10, 0, 10)
            scriptIcon.Size = UDim2.new(0, 60, 0, 60)
            scriptIcon.Image = scriptData.Icon or ""
            scriptIcon.ScaleType = Enum.ScaleType.Crop
            Instance.new("UICorner", scriptIcon).CornerRadius = UDim.new(0, 5)
            
            local scriptName = Instance.new("TextLabel", scriptCard)
            scriptName.BackgroundTransparency = 1
            scriptName.Position = UDim2.new(0, 80, 0, 8)
            scriptName.Size = UDim2.new(0.5, 0, 0, 22)
            scriptName.Font = Enum.Font.SourceSansSemibold
            scriptName.Text = scriptData.Name
            scriptName.TextColor3 = Color3.fromRGB(220, 220, 220)
            scriptName.TextSize = 16
            scriptName.TextXAlignment = Enum.TextXAlignment.Left
            
            local scriptDesc = Instance.new("TextLabel", scriptCard)
            scriptDesc.BackgroundTransparency = 1
            scriptDesc.Position = UDim2.new(0, 80, 0, 32)
            scriptDesc.Size = UDim2.new(0.6, 0, 0, 40)
            scriptDesc.Font = Enum.Font.SourceSans
            scriptDesc.Text = scriptData.Description or "No description available"
            scriptDesc.TextColor3 = Color3.fromRGB(150, 150, 150)
            scriptDesc.TextSize = 12
            scriptDesc.TextXAlignment = Enum.TextXAlignment.Left
            scriptDesc.TextYAlignment = Enum.TextYAlignment.Top
            scriptDesc.TextWrapped = true
            scriptDesc.TextTruncate = Enum.TextTruncate.AtEnd
            
            local executeBtn = Instance.new("TextButton", scriptCard)
            executeBtn.BackgroundColor3 = RGBToColor3(SynapseColorService.ThemeColor2)
            executeBtn.Position = UDim2.new(0.75, 0, 0.3, 0)
            executeBtn.Size = UDim2.new(0, 70, 0, 28)
            executeBtn.Font = Enum.Font.SourceSansSemibold
            executeBtn.Text = "Execute"
            executeBtn.TextColor3 = Color3.new(1, 1, 1)
            executeBtn.TextSize = 12
            Instance.new("UICorner", executeBtn).CornerRadius = UDim.new(0, 5)
            
            local favoriteBtn = Instance.new("ImageButton", scriptCard)
            favoriteBtn.BackgroundTransparency = 1
            favoriteBtn.Position = UDim2.new(0.9, 0, 0.35, 0)
            favoriteBtn.Size = UDim2.new(0, 24, 0, 24)
            favoriteBtn.Image = "rbxassetid://10085566401"
            favoriteBtn.ImageColor3 = Color3.fromRGB(150, 150, 150)
            
            local isFavorited = false
            
            executeBtn.MouseButton1Click:Connect(function()
                if scriptData.Script then
                    local success, err = pcall(function()
                        loadstring(game:HttpGet(scriptData.Script))()
                    end)
                    if success then
                        NotificationModule:Notify("Success", scriptData.Name .. " executed!", 2)
                    else
                        NotificationModule:Notify("Error", "Failed to execute: " .. tostring(err), 4)
                    end
                end
            end)
            
            favoriteBtn.MouseButton1Click:Connect(function()
                isFavorited = not isFavorited
                favoriteBtn.ImageColor3 = isFavorited and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(150, 150, 150)
            end)
            
            return scriptCard
        end
        
        -- Sample Scripts for Hub
        local SampleScripts = {
            {Name = "Infinite Yield", Description = "Admin command script with many features", Script = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", Icon = ""},
            {Name = "Dex Explorer", Description = "Game explorer and property editor", Script = "https://raw.githubusercontent.com/infyiff/backup/main/dex.lua", Icon = ""},
            {Name = "Remote Spy", Description = "Monitor remote events and functions", Script = "", Icon = ""},
            {Name = "ESP Script", Description = "Visual ESP for players and items", Script = "", Icon = ""},
        }
        
        for i, script in ipairs(SampleScripts) do
            CreateScriptCard(script, i)
        end
        
        -- Script Search
        ScriptSearchBox:GetPropertyChangedSignal("Text"):Connect(function()
            local searchText = string.lower(ScriptSearchBox.Text)
            for _, child in pairs(ScriptHubResultsScroll:GetChildren()) do
                if child:IsA("Frame") then
                    if searchText == "" then
                        child.Visible = true
                    else
                        child.Visible = string.find(string.lower(child.Name), searchText) ~= nil
                    end
                end
            end
        end)
        
        -- Auto Execute on Game Join
        if SynapseConfigs.Execution.AutoExecute then
            task.spawn(function()
                if isFolder("autoexec") then
                    local files = listFiles("autoexec")
                    for _, filePath in ipairs(files) do
                        if string.find(filePath, ".lua") or string.find(filePath, ".txt") then
                            local content = readFile(filePath)
                            pcall(function()
                                loadstring(content)()
                            end)
                        end
                    end
                end
            end)
        end
        
        -- Keybind System
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            if input.KeyCode == Enum.KeyCode.RightControl then
                MainFrame.Visible = not MainFrame.Visible
                MinimizedButton.Visible = not MainFrame.Visible
            end
        end)
        
        -- Initial Welcome Message
        AddConsoleMessage("Welcome to Synapse X", "success")
        AddConsoleMessage("Type 'help' for available commands", "info")
        
        -- Return the UI module for external access
        return {
            ScreenGui = ScreenGui,
            MainFrame = MainFrame,
            CodeBox = CodeBox,
            Execute = function(code)
                pcall(function()
                    loadstring(code)()
                end)
            end,
            SetTheme = ApplyTheme,
            CreateTab = CreateTab,
            Notify = function(title, message, duration)
                NotificationModule:Notify(title, message, duration)
            end,
            SwitchPage = SwitchPage,
            AddConsoleMessage = AddConsoleMessage
        }
    end
    
    return SynapseUI:Initialize()
end)()
