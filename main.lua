-- Rayfield風UIライブラリ (教育用サンプル)
local Rayfield = {}

-- サービス宣言
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ローカルプレイヤー
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- メインGUI作成
function Rayfield:CreateWindow(options)
    local Window = {}
    
    -- デフォルトオプション
    options = options or {}
    options.Name = options.Name or "Rayfield UI"
    options.Theme = options.Theme or "Dark"
    
    -- メインGUIコンテナ
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RayfieldUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
    
    -- メインフレーム
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- 角丸効果
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    -- ドラッグ機能
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    -- タイトルバー
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -40, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = options.Name
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamSemibold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    -- 閉じるボタン
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 14
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 4)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- ドラッグイベント
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- タブコンテナ
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, 0, 1, -40)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainFrame
    
    -- タブボタンコンテナ
    local TabButtons = Instance.new("Frame")
    TabButtons.Name = "TabButtons"
    TabButtons.Size = UDim2.new(0, 120, 1, 0)
    TabButtons.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabButtons.BorderSizePixel = 0
    TabButtons.Parent = TabContainer
    
    -- タブコンテンツ
    local TabContent = Instance.new("Frame")
    TabContent.Name = "TabContent"
    TabContent.Size = UDim2.new(1, -120, 1, 0)
    TabContent.Position = UDim2.new(0, 120, 0, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.Parent = TabContainer
    
    -- スクロールフレーム
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Name = "ScrollFrame"
    ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.ScrollBarThickness = 3
    ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollFrame.Parent = TabContent
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = ScrollFrame
    
    -- タブ管理
    local Tabs = {}
    local CurrentTab = nil
    
    function Window:CreateTab(tabName)
        local Tab = {}
        tabName = tabName or "Tab"
        
        -- タブボタン
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Button"
        TabButton.Size = UDim2.new(1, -10, 0, 35)
        TabButton.Position = UDim2.new(0, 5, 0, (#Tabs * 40) + 5)
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TabButton.BorderSizePixel = 0
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.Gotham
        TabButton.Parent = TabButtons
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 4)
        TabButtonCorner.Parent = TabButton
        
        -- タブコンテンツコンテナ
        local TabFrame = Instance.new("Frame")
        TabFrame.Name = tabName .. "Frame"
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.BackgroundTransparency = 1
        TabFrame.Visible = false
        TabFrame.Parent = ScrollFrame
        
        -- タブ選択機能
        TabButton.MouseButton1Click:Connect(function()
            if CurrentTab then
                CurrentTab.Visible = false
            end
            TabFrame.Visible = true
            CurrentTab = TabFrame
            
            -- ボタンの色を更新
            for _, btn in pairs(TabButtons:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                end
            end
            TabButton.BackgroundColor3 = Color3.fromRGB(50, 100, 180)
        end)
        
        -- 最初のタブをアクティブに
        if #Tabs == 0 then
            TabButton.BackgroundColor3 = Color3.fromRGB(50, 100, 180)
            TabFrame.Visible = true
            CurrentTab = TabFrame
        end
        
        -- セクション作成関数
        function Tab:CreateSection(sectionName)
            local Section = {}
            
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = "SectionFrame"
            SectionFrame.Size = UDim2.new(1, -20, 0, 0)
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            SectionFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Parent = TabFrame
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 6)
            SectionCorner.Parent = SectionFrame
            
            local SectionLayout = Instance.new("UIListLayout")
            SectionLayout.Padding = UDim.new(0, 5)
            SectionLayout.Parent = SectionFrame
            
            local SectionPadding = Instance.new("UIPadding")
            SectionPadding.PaddingTop = UDim.new(0, 10)
            SectionPadding.PaddingBottom = UDim.new(0, 10)
            SectionPadding.PaddingLeft = UDim.new(0, 15)
            SectionPadding.PaddingRight = UDim.new(0, 15)
            SectionPadding.Parent = SectionFrame
            
            -- セクションタイトル
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "SectionTitle"
            SectionTitle.Size = UDim2.new(1, 0, 0, 20)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = sectionName
            SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionTitle.TextSize = 16
            SectionTitle.Font = Enum.Font.GothamSemibold
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionFrame
            
            -- ボタン作成関数
            function Section:CreateButton(buttonConfig)
                buttonConfig = buttonConfig or {}
                buttonConfig.Name = buttonConfig.Name or "Button"
                buttonConfig.Callback = buttonConfig.Callback or function() end
                
                local Button = Instance.new("TextButton")
                Button.Name = buttonConfig.Name .. "Button"
                Button.Size = UDim2.new(1, 0, 0, 35)
                Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                Button.BorderSizePixel = 0
                Button.Text = buttonConfig.Name
                Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                Button.TextSize = 14
                Button.Font = Enum.Font.Gotham
                Button.Parent = SectionFrame
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 4)
                ButtonCorner.Parent = Button
                
                Button.MouseButton1Click:Connect(function()
                    buttonConfig.Callback()
                end)
                
                -- ホバーエフェクト
                Button.MouseEnter:Connect(function()
                    game.TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                end)
                
                Button.MouseLeave:Connect(function()
                    game.TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
                end)
            end
            
            -- トグル作成関数
            function Section:CreateToggle(toggleConfig)
                toggleConfig = toggleConfig or {}
                toggleConfig.Name = toggleConfig.Name or "Toggle"
                toggleConfig.Default = toggleConfig.Default or false
                toggleConfig.Callback = toggleConfig.Callback or function() end
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = toggleConfig.Name .. "Toggle"
                ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Parent = SectionFrame
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Name = "ToggleLabel"
                ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Text = toggleConfig.Name
                ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                ToggleLabel.TextSize = 14
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleFrame
                
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Name = "ToggleButton"
                ToggleButton.Size = UDim2.new(0, 50, 0, 25)
                ToggleButton.Position = UDim2.new(1, -50, 0.5, -12.5)
                ToggleButton.BackgroundColor3 = toggleConfig.Default and Color3.fromRGB(50, 180, 80) or Color3.fromRGB(80, 80, 80)
                ToggleButton.BorderSizePixel = 0
                ToggleButton.Text = ""
                ToggleButton.Parent = ToggleFrame
                
                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 12)
                ToggleCorner.Parent = ToggleButton
                
                local ToggleDot = Instance.new("Frame")
                ToggleDot.Name = "ToggleDot"
                ToggleDot.Size = UDim2.new(0, 21, 0, 21)
                ToggleDot.Position = UDim2.new(0, toggleConfig.Default and 29 or 2, 0, 2)
                ToggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ToggleDot.BorderSizePixel = 0
                ToggleDot.Parent = ToggleButton
                
                local ToggleDotCorner = Instance.new("UICorner")
                ToggleDotCorner.CornerRadius = UDim.new(0, 10)
                ToggleDotCorner.Parent = ToggleDot
                
                local isToggled = toggleConfig.Default
                
                ToggleButton.MouseButton1Click:Connect(function()
                    isToggled = not isToggled
                    
                    if isToggled then
                        game.TweenService:Create(ToggleDot, TweenInfo.new(0.2), {Position = UDim2.new(0, 29, 0, 2)}):Play()
                        game.TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 180, 80)}):Play()
                    else
                        game.TweenService:Create(ToggleDot, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0, 2)}):Play()
                        game.TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
                    end
                    
                    toggleConfig.Callback(isToggled)
                end)
            end
            
            -- スライダー作成関数
            function Section:CreateSlider(sliderConfig)
                sliderConfig = sliderConfig or {}
                sliderConfig.Name = sliderConfig.Name or "Slider"
                sliderConfig.Min = sliderConfig.Min or 0
                sliderConfig.Max = sliderConfig.Max or 100
                sliderConfig.Default = sliderConfig.Default or 50
                sliderConfig.Callback = sliderConfig.Callback or function() end
                
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = sliderConfig.Name .. "Slider"
                SliderFrame.Size = UDim2.new(1, 0, 0, 60)
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Parent = SectionFrame
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Name = "SliderLabel"
                SliderLabel.Size = UDim2.new(1, 0, 0, 20)
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Text = sliderConfig.Name .. ": " .. sliderConfig.Default
                SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                SliderLabel.TextSize = 14
                SliderLabel.Font = Enum.Font.Gotham
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = SliderFrame
                
                local SliderTrack = Instance.new("Frame")
                SliderTrack.Name = "SliderTrack"
                SliderTrack.Size = UDim2.new(1, 0, 0, 5)
                SliderTrack.Position = UDim2.new(0, 0, 0, 35)
                SliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                SliderTrack.BorderSizePixel = 0
                SliderTrack.Parent = SliderFrame
                
                local SliderTrackCorner = Instance.new("UICorner")
                SliderTrackCorner.CornerRadius = UDim.new(0, 3)
                SliderTrackCorner.Parent = SliderTrack
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "SliderFill"
                SliderFill.Size = UDim2.new((sliderConfig.Default - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min), 0, 1, 0)
                SliderFill.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
                SliderFill.BorderSizePixel = 0
                SliderFill.Parent = SliderTrack
                
                local SliderFillCorner = Instance.new("UICorner")
                SliderFillCorner.CornerRadius = UDim.new(0, 3)
                SliderFillCorner.Parent = SliderFill
                
                local SliderButton = Instance.new("TextButton")
                SliderButton.Name = "SliderButton"
                SliderButton.Size = UDim2.new(0, 15, 0, 15)
                SliderButton.Position = UDim2.new((sliderConfig.Default - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min), -7.5, 0.5, -7.5)
                SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderButton.BorderSizePixel = 0
                SliderButton.Text = ""
                SliderButton.Parent = SliderTrack
                
                local SliderButtonCorner = Instance.new("UICorner")
                SliderButtonCorner.CornerRadius = UDim.new(0, 7)
                SliderButtonCorner.Parent = SliderButton
                
                local dragging = false
                
                local function updateSlider(input)
                    local pos = UDim2.new(math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1), -7.5, 0.5, -7.5)
                    local value = math.floor(((pos.X.Scale * (sliderConfig.Max - sliderConfig.Min)) + sliderConfig.Min) * 100) / 100
                    
                    SliderButton.Position = pos
                    SliderFill.Size = UDim2.new(pos.X.Scale, 0, 1, 0)
                    SliderLabel.Text = sliderConfig.Name .. ": " .. value
                    
                    sliderConfig.Callback(value)
                end
                
                SliderButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                    end
                end)
                
                SliderButton.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input)
                    end
                end)
                
                SliderTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        updateSlider(input)
                    end
                end)
            end
            
            -- ドロップダウン作成関数
            function Section:CreateDropdown(dropdownConfig)
                dropdownConfig = dropdownConfig or {}
                dropdownConfig.Name = dropdownConfig.Name or "Dropdown"
                dropdownConfig.Options = dropdownConfig.Options or {"Option 1", "Option 2"}
                dropdownConfig.Default = dropdownConfig.Default or dropdownConfig.Options[1]
                dropdownConfig.Callback = dropdownConfig.Callback or function() end
                
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Name = dropdownConfig.Name .. "Dropdown"
                DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
                DropdownFrame.BackgroundTransparency = 1
                DropdownFrame.Parent = SectionFrame
                
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Name = "DropdownButton"
                DropdownButton.Size = UDim2.new(1, 0, 0, 35)
                DropdownButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                DropdownButton.BorderSizePixel = 0
                DropdownButton.Text = dropdownConfig.Name .. ": " .. dropdownConfig.Default
                DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                DropdownButton.TextSize = 14
                DropdownButton.Font = Enum.Font.Gotham
                DropdownButton.Parent = DropdownFrame
                
                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 4)
                DropdownCorner.Parent = DropdownButton
                
                local DropdownArrow = Instance.new("ImageLabel")
                DropdownArrow.Name = "DropdownArrow"
                DropdownArrow.Size = UDim2.new(0, 20, 0, 20)
                DropdownArrow.Position = UDim2.new(1, -25, 0.5, -10)
                DropdownArrow.BackgroundTransparency = 1
                DropdownArrow.Image = "rbxassetid://6031090990"
                DropdownArrow.ImageColor3 = Color3.fromRGB(200, 200, 200)
                DropdownArrow.Parent = DropdownButton
                
                local OptionsFrame = Instance.new("Frame")
                OptionsFrame.Name = "OptionsFrame"
                OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
                OptionsFrame.Position = UDim2.new(0, 0, 1, 5)
                OptionsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                OptionsFrame.BorderSizePixel = 0
                OptionsFrame.ClipsDescendants = true
                OptionsFrame.Visible = false
                OptionsFrame.Parent = DropdownFrame
                
                local OptionsCorner = Instance.new("UICorner")
                OptionsCorner.CornerRadius = UDim.new(0, 4)
                OptionsCorner.Parent = OptionsFrame
                
                local OptionsLayout = Instance.new("UIListLayout")
                OptionsLayout.Parent = OptionsFrame
                
                local isOpen = false
                local selectedOption = dropdownConfig.Default
                
                local function updateOptionsSize()
                    OptionsFrame.Size = UDim2.new(1, 0, 0, OptionsLayout.AbsoluteContentSize.Y)
                end
                
                OptionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateOptionsSize)
                
                for i, option in ipairs(dropdownConfig.Options) do
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Name = option .. "Option"
                    OptionButton.Size = UDim2.new(1, 0, 0, 30)
                    OptionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                    OptionButton.BorderSizePixel = 0
                    OptionButton.Text = option
                    OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    OptionButton.TextSize = 14
                    OptionButton.Font = Enum.Font.Gotham
                    OptionButton.Parent = OptionsFrame
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        selectedOption = option
                        DropdownButton.Text = dropdownConfig.Name .. ": " .. selectedOption
                        dropdownConfig.Callback(selectedOption)
                        
                        OptionsFrame.Visible = false
                        isOpen = false
                        DropdownArrow.Rotation = 0
                    end)
                end
                
                DropdownButton.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    OptionsFrame.Visible = isOpen
                    DropdownArrow.Rotation = isOpen and 180 or 0
                end)
            end
            
            return Section
        end
        
        table.insert(Tabs, Tab)
        return Tab
    end
    
    return Window
end

-- UI使用例
local Window = Rayfield:CreateWindow({
    Name = "Rayfield UI サンプル",
    Theme = "Dark"
})

-- メインタブ
local MainTab = Window:CreateTab("メイン")
local MainSection = MainTab:CreateSection("主要機能")

MainSection:CreateButton({
    Name = "テストボタン",
    Callback = function()
        print("ボタンがクリックされました！")
    end
})

MainSection:CreateToggle({
    Name = "テストトグル",
    Default = false,
    Callback = function(value)
        print("トグル状態:", value)
    end
})

MainSection:CreateSlider({
    Name = "テストスライダー",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("スライダー値:", value)
    end
})

MainSection:CreateDropdown({
    Name = "テストドロップダウン",
    Options = {"オプション1", "オプション2", "オプション3"},
    Default = "オプション1",
    Callback = function(value)
        print("選択されたオプション:", value)
    end
})

-- セカンダリタブ
local SecondTab = Window:CreateTab("設定")
local SettingsSection = SecondTab:CreateSection("設定項目")

SettingsSection:CreateButton({
    Name = "設定を保存",
    Callback = function()
        print("設定を保存しました")
    end
})

return Rayfield
