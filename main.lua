-- Crystal UI Library
-- 軽量でモダンなUIライブラリ

local CrystalUI = {
    Version = "1.0.0",
    Flags = {},
    Themes = {
        Dark = {
            Background = Color3.fromRGB(25, 25, 25),
            Topbar = Color3.fromRGB(34, 34, 34),
            Element = Color3.fromRGB(35, 35, 35),
            Text = Color3.fromRGB(240, 240, 240),
            Accent = Color3.fromRGB(0, 146, 214)
        },
        Light = {
            Background = Color3.fromRGB(245, 245, 245),
            Topbar = Color3.fromRGB(230, 230, 230),
            Element = Color3.fromRGB(240, 240, 240),
            Text = Color3.fromRGB(40, 40, 40),
            Accent = Color3.fromRGB(0, 120, 215)
        }
    }
}

-- サービス
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- 変数
local CurrentTheme = CrystalUI.Themes.Dark
local Dragging = false
local DragInput, DragStart, StartPos

-- ユーティリティ関数
local function Tween(Object, Properties, Duration)
    local TweenInfo = TweenInfo.new(Duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local Tween = TweenService:Create(Object, TweenInfo, Properties)
    Tween:Play()
    return Tween
end

local function MakeDraggable(Frame)
    Frame.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = Input.Position
            StartPos = Frame.Position
            
            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)
    
    Frame.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement then
            DragInput = Input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(Input)
        if Input == DragInput and Dragging then
            local Delta = Input.Position - DragStart
            Frame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)
end

-- メインウィンドウ作成
function CrystalUI:CreateWindow(Config)
    Config = Config or {}
    
    local MainWindow = {
        Tabs = {},
        CurrentTab = nil
    }
    
    -- メインGUI作成
    local ScreenGui = Instance.new("ScreenGui")
    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game:GetService("CoreGui")
    else
        ScreenGui.Parent = game:GetService("CoreGui")
    end
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "CrystalUI"
    MainFrame.Size = UDim2.new(0, 500, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    MainFrame.BackgroundColor3 = CurrentTheme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    local DropShadow = Instance.new("ImageLabel")
    DropShadow.Name = "DropShadow"
    DropShadow.Size = UDim2.new(1, 0, 1, 0)
    DropShadow.Position = UDim2.new(0, 0, 0, 0)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Image = "rbxassetid://1316045217"
    DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow.ImageTransparency = 0.8
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(10, 10, 118, 118)
    DropShadow.Parent = MainFrame
    
    -- トップバー
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.Position = UDim2.new(0, 0, 0, 0)
    Topbar.BackgroundColor3 = CurrentTheme.Topbar
    Topbar.BorderSizePixel = 0
    Topbar.Parent = MainFrame
    
    local TopbarCorner = Instance.new("UICorner")
    TopbarCorner.CornerRadius = UDim.new(0, 8)
    TopbarCorner.Parent = Topbar
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Config.Name or "Crystal UI"
    Title.TextColor3 = CurrentTheme.Text
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamSemibold
    Title.Parent = Topbar
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 18
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = Topbar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 4)
    CloseCorner.Parent = CloseButton
    
    -- タブリスト
    local TabList = Instance.new("Frame")
    TabList.Name = "TabList"
    TabList.Size = UDim2.new(0, 120, 1, -40)
    TabList.Position = UDim2.new(0, 0, 0, 40)
    TabList.BackgroundTransparency = 1
    TabList.Parent = MainFrame
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    TabListLayout.Parent = TabList
    
    -- コンテンツフレーム
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, -120, 1, -40)
    ContentFrame.Position = UDim2.new(0, 120, 0, 40)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame
    
    local ContentScrolling = Instance.new("ScrollingFrame")
    ContentScrolling.Size = UDim2.new(1, 0, 1, 0)
    ContentScrolling.Position = UDim2.new(0, 0, 0, 0)
    ContentScrolling.BackgroundTransparency = 1
    ContentScrolling.BorderSizePixel = 0
    ContentScrolling.ScrollBarThickness = 3
    ContentScrolling.ScrollBarImageColor3 = CurrentTheme.Accent
    ContentScrolling.Parent = ContentFrame
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Padding = UDim.new(0, 10)
    ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ContentLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    ContentLayout.Parent = ContentScrolling
    
    -- イベント
    MakeDraggable(Topbar)
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- タブ作成メソッド
    function MainWindow:CreateTab(TabName)
        local Tab = {
            Name = TabName,
            Elements = {}
        }
        
        -- タブボタン
        local TabButton = Instance.new("TextButton")
        TabButton.Name = TabName
        TabButton.Size = UDim2.new(0.9, 0, 0, 35)
        TabButton.BackgroundColor3 = CurrentTheme.Element
        TabButton.BorderSizePixel = 0
        TabButton.Text = TabName
        TabButton.TextColor3 = CurrentTheme.Text
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.Gotham
        TabButton.Parent = TabList
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton
        
        -- コンテンツページ
        local TabPage = Instance.new("Frame")
        TabPage.Name = TabName
        TabPage.Size = UDim2.new(1, -20, 1, -20)
        TabPage.Position = UDim2.new(0, 10, 0, 10)
        TabPage.BackgroundTransparency = 1
        TabPage.Visible = false
        TabPage.Parent = ContentScrolling
        
        local TabPageLayout = Instance.new("UIListLayout")
        TabPageLayout.Padding = UDim.new(0, 10)
        TabPageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        TabPageLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        TabPageLayout.Parent = TabPage
        
        -- 最初のタブをアクティブに
        if not MainWindow.CurrentTab then
            MainWindow.CurrentTab = Tab
            TabButton.BackgroundColor3 = CurrentTheme.Accent
            TabPage.Visible = true
        end
        
        TabButton.MouseButton1Click:Connect(function()
            -- 他のタブを非アクティブに
            for _, OtherTab in pairs(MainWindow.Tabs) do
                OtherTab.Button.BackgroundColor3 = CurrentTheme.Element
                OtherTab.Page.Visible = false
            end
            
            -- このタブをアクティブに
            TabButton.BackgroundColor3 = CurrentTheme.Accent
            TabPage.Visible = true
            MainWindow.CurrentTab = Tab
        end)
        
        -- 要素をタブに保存
        Tab.Button = TabButton
        Tab.Page = TabPage
        
        -- タブメソッド
        function Tab:CreateSection(SectionName)
            local Section = {}
            
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = "Section"
            SectionFrame.Size = UDim2.new(1, 0, 0, 30)
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.Parent = TabPage
            
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Name = "SectionLabel"
            SectionLabel.Size = UDim2.new(1, -20, 1, 0)
            SectionLabel.Position = UDim2.new(0, 10, 0, 0)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Text = SectionName
            SectionLabel.TextColor3 = CurrentTheme.Text
            SectionLabel.TextSize = 16
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.Font = Enum.Font.GothamSemibold
            SectionLabel.Parent = SectionFrame
            
            local SectionLine = Instance.new("Frame")
            SectionLine.Name = "SectionLine"
            SectionLine.Size = UDim2.new(1, 0, 0, 1)
            SectionLine.Position = UDim2.new(0, 0, 1, -1)
            SectionLine.BackgroundColor3 = CurrentTheme.Accent
            SectionLine.BorderSizePixel = 0
            SectionLine.Parent = SectionFrame
            
            function Section:Update()
                -- セクション更新ロジック
            end
            
            return Section
        end
        
        function Tab:CreateButton(ButtonConfig)
            local Button = {}
            
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Name = "Button"
            ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
            ButtonFrame.BackgroundColor3 = CurrentTheme.Element
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Parent = TabPage
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = ButtonFrame
            
            local ButtonLabel = Instance.new("TextLabel")
            ButtonLabel.Name = "ButtonLabel"
            ButtonLabel.Size = UDim2.new(1, -20, 1, 0)
            ButtonLabel.Position = UDim2.new(0, 10, 0, 0)
            ButtonLabel.BackgroundTransparency = 1
            ButtonLabel.Text = ButtonConfig.Name
            ButtonLabel.TextColor3 = CurrentTheme.Text
            ButtonLabel.TextSize = 14
            ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
            ButtonLabel.Font = Enum.Font.Gotham
            ButtonLabel.Parent = ButtonFrame
            
            local ButtonButton = Instance.new("TextButton")
            ButtonButton.Name = "ButtonInteract"
            ButtonButton.Size = UDim2.new(1, 0, 1, 0)
            ButtonButton.Position = UDim2.new(0, 0, 0, 0)
            ButtonButton.BackgroundTransparency = 1
            ButtonButton.BorderSizePixel = 0
            ButtonButton.Text = ""
            ButtonButton.Parent = ButtonFrame
            
            ButtonButton.MouseEnter:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = CurrentTheme.Accent}, 0.2)
            end)
            
            ButtonButton.MouseLeave:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = CurrentTheme.Element}, 0.2)
            end)
            
            ButtonButton.MouseButton1Click:Connect(function()
                if ButtonConfig.Callback then
                    pcall(ButtonConfig.Callback)
                end
            end)
            
            function Button:SetText(NewText)
                ButtonLabel.Text = NewText
            end
            
            return Button
        end
        
        function Tab:CreateToggle(ToggleConfig)
            local Toggle = {
                Value = ToggleConfig.Default or false
            }
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "Toggle"
            ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
            ToggleFrame.BackgroundColor3 = CurrentTheme.Element
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabPage
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Name = "ToggleLabel"
            ToggleLabel.Size = UDim2.new(0.7, -10, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = ToggleConfig.Name
            ToggleLabel.TextColor3 = CurrentTheme.Text
            ToggleLabel.TextSize = 14
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleSwitch = Instance.new("Frame")
            ToggleSwitch.Name = "ToggleSwitch"
            ToggleSwitch.Size = UDim2.new(0, 50, 0, 25)
            ToggleSwitch.Position = UDim2.new(1, -60, 0.5, -12.5)
            ToggleSwitch.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            ToggleSwitch.BorderSizePixel = 0
            ToggleSwitch.Parent = ToggleFrame
            
            local ToggleSwitchCorner = Instance.new("UICorner")
            ToggleSwitchCorner.CornerRadius = UDim.new(0, 12)
            ToggleSwitchCorner.Parent = ToggleSwitch
            
            local ToggleKnob = Instance.new("Frame")
            ToggleKnob.Name = "ToggleKnob"
            ToggleKnob.Size = UDim2.new(0, 21, 0, 21)
            ToggleKnob.Position = UDim2.new(0, 2, 0, 2)
            ToggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleKnob.BorderSizePixel = 0
            ToggleKnob.Parent = ToggleSwitch
            
            local ToggleKnobCorner = Instance.new("UICorner")
            ToggleKnobCorner.CornerRadius = UDim.new(0, 10)
            ToggleKnobCorner.Parent = ToggleKnob
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "ToggleInteract"
            ToggleButton.Size = UDim2.new(1, 0, 1, 0)
            ToggleButton.Position = UDim2.new(0, 0, 0, 0)
            ToggleButton.BackgroundTransparency = 1
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Text = ""
            ToggleButton.Parent = ToggleFrame
            
            local function UpdateToggle()
                if Toggle.Value then
                    Tween(ToggleSwitch, {BackgroundColor3 = CurrentTheme.Accent}, 0.2)
                    Tween(ToggleKnob, {Position = UDim2.new(0, 27, 0, 2)}, 0.2)
                else
                    Tween(ToggleSwitch, {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}, 0.2)
                    Tween(ToggleKnob, {Position = UDim2.new(0, 2, 0, 2)}, 0.2)
                end
            end
            
            UpdateToggle()
            
            ToggleButton.MouseButton1Click:Connect(function()
                Toggle.Value = not Toggle.Value
                UpdateToggle()
                
                if ToggleConfig.Callback then
                    pcall(ToggleConfig.Callback, Toggle.Value)
                end
                
                if ToggleConfig.Flag then
                    CrystalUI.Flags[ToggleConfig.Flag] = Toggle.Value
                end
            end)
            
            function Toggle:SetValue(NewValue)
                Toggle.Value = NewValue
                UpdateToggle()
            end
            
            return Toggle
        end
        
        function Tab:CreateSlider(SliderConfig)
            local Slider = {
                Value = SliderConfig.Default or SliderConfig.Min
            }
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "Slider"
            SliderFrame.Size = UDim2.new(1, 0, 0, 60)
            SliderFrame.BackgroundColor3 = CurrentTheme.Element
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabPage
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 6)
            SliderCorner.Parent = SliderFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Name = "SliderLabel"
            SliderLabel.Size = UDim2.new(1, -20, 0, 20)
            SliderLabel.Position = UDim2.new(0, 10, 0, 5)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = SliderConfig.Name
            SliderLabel.TextColor3 = CurrentTheme.Text
            SliderLabel.TextSize = 14
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.Parent = SliderFrame
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Name = "SliderValue"
            SliderValue.Size = UDim2.new(0, 60, 0, 20)
            SliderValue.Position = UDim2.new(1, -70, 0, 5)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Text = tostring(Slider.Value)
            SliderValue.TextColor3 = CurrentTheme.Text
            SliderValue.TextSize = 14
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Font = Enum.Font.Gotham
            SliderValue.Parent = SliderFrame
            
            local SliderTrack = Instance.new("Frame")
            SliderTrack.Name = "SliderTrack"
            SliderTrack.Size = UDim2.new(1, -20, 0, 5)
            SliderTrack.Position = UDim2.new(0, 10, 1, -20)
            SliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            SliderTrack.BorderSizePixel = 0
            SliderTrack.Parent = SliderFrame
            
            local SliderTrackCorner = Instance.new("UICorner")
            SliderTrackCorner.CornerRadius = UDim.new(0, 2)
            SliderTrackCorner.Parent = SliderTrack
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "SliderFill"
            SliderFill.Size = UDim2.new(0, 0, 1, 0)
            SliderFill.Position = UDim2.new(0, 0, 0, 0)
            SliderFill.BackgroundColor3 = CurrentTheme.Accent
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderTrack
            
            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(0, 2)
            SliderFillCorner.Parent = SliderFill
            
            local SliderButton = Instance.new("TextButton")
            SliderButton.Name = "SliderInteract"
            SliderButton.Size = UDim2.new(1, 0, 0, 25)
            SliderButton.Position = UDim2.new(0, 0, 1, -25)
            SliderButton.BackgroundTransparency = 1
            SliderButton.BorderSizePixel = 0
            SliderButton.Text = ""
            SliderButton.Parent = SliderFrame
            
            local function UpdateSlider()
                local Percent = (Slider.Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min)
                SliderFill.Size = UDim2.new(Percent, 0, 1, 0)
                SliderValue.Text = tostring(Slider.Value) .. (SliderConfig.Suffix or "")
            end
            
            UpdateSlider()
            
            local Dragging = false
            
            SliderButton.MouseButton1Down:Connect(function()
                Dragging = true
                
                while Dragging do
                    local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
                    local Percent = math.clamp((Mouse.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                    Slider.Value = math.floor(SliderConfig.Min + (SliderConfig.Max - SliderConfig.Min) * Percent)
                    UpdateSlider()
                    
                    if SliderConfig.Callback then
                        pcall(SliderConfig.Callback, Slider.Value)
                    end
                    
                    if SliderConfig.Flag then
                        CrystalUI.Flags[SliderConfig.Flag] = Slider.Value
                    end
                    
                    RunService.RenderStepped:Wait()
                end
            end)
            
            UserInputService.InputEnded:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = false
                end
            end)
            
            function Slider:SetValue(NewValue)
                Slider.Value = math.clamp(NewValue, SliderConfig.Min, SliderConfig.Max)
                UpdateSlider()
            end
            
            return Slider
        end
        
        -- タブをリストに追加
        table.insert(MainWindow.Tabs, Tab)
        
        return Tab
    end
    
    -- ウィンドウメソッド
    function MainWindow:SetTheme(ThemeName)
        if CrystalUI.Themes[ThemeName] then
            CurrentTheme = CrystalUI.Themes[ThemeName]
            -- ここで全てのUI要素の色を更新
        end
    end
    
    function MainWindow:Destroy()
        ScreenGui:Destroy()
    end
    
    return MainWindow
end

-- 使用例
-- local Window = CrystalUI:CreateWindow({
--     Name = "Crystal UI Example"
-- })
--
-- local MainTab = Window:CreateTab("Main")
-- local SettingsTab = Window:CreateTab("Settings")
--
-- local Section = MainTab:CreateSection("Main Section")
--
-- local Button = MainTab:CreateButton({
--     Name = "Click Me",
--     Callback = function()
--         print("Button clicked!")
--     end
-- })
--
-- local Toggle = MainTab:CreateToggle({
--     Name = "Enable Feature",
--     Default = false,
--     Flag = "FeatureToggle",
--     Callback = function(Value)
--         print("Toggle:", Value)
--     end
-- })
--
-- local Slider = MainTab:CreateSlider({
--     Name = "Volume",
--     Min = 0,
--     Max = 100,
--     Default = 50,
--     Suffix = "%",
--     Flag = "VolumeSlider",
--     Callback = function(Value)
--         print("Volume:", Value)
--     end
-- })

return CrystalUI
