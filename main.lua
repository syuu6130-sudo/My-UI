-- Nebula UI - Revolutionary Edition
local Nebula = {}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")

-- Main UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NebulaUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

-- ユーティリティ関数
local function Create(className, properties)
    local obj = Instance.new(className)
    for prop, value in pairs(properties) do
        obj[prop] = value
    end
    return obj
end

-- 革新的な機能モジュール
local InnovativeFeatures = {
    -- スマートサーチ機能
    SmartSearch = function(container, items)
        local searchFrame = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(30, 30, 35),
            Size = UDim2.new(1, 0, 0, 40),
            Parent = container
        })
        
        local searchBox = Create("TextBox", {
            PlaceholderText = "🔍 スマート検索...",
            ClearTextOnFocus = false,
            BackgroundColor3 = Color3.fromRGB(40, 40, 45),
            Size = UDim2.new(1, -20, 0, 30),
            Position = UDim2.new(0, 10, 0, 5),
            TextColor3 = Color3.fromRGB(240, 240, 240),
            TextSize = 14,
            Font = Enum.Font.Gotham,
            Parent = searchFrame
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = searchBox})
        
        searchBox:GetPropertyChangedSignal("Text"):Connect(function()
            local searchText = searchBox.Text:lower()
            for _, item in pairs(items) do
                local visible = item.Name:lower():find(searchText) ~= nil
                item.Visible = visible
            end
        end)
        
        return searchFrame
    end,
    
    -- リアルタイムパフォーマンスモニター
    PerformanceMonitor = function(container)
        local monitorFrame = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(25, 25, 30),
            Size = UDim2.new(1, 0, 0, 80),
            Parent = container
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = monitorFrame})
        
        local fpsLabel = Create("TextLabel", {
            Text = "FPS: --",
            TextColor3 = Color3.fromRGB(240, 240, 240),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 0.5, 0),
            Position = UDim2.new(0, 10, 0, 5),
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = monitorFrame
        })
        
        local pingLabel = Create("TextLabel", {
            Text = "Ping: -- ms",
            TextColor3 = Color3.fromRGB(240, 240, 240),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 0.5, 0),
            Position = UDim2.new(0, 10, 0.5, 0),
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = monitorFrame
        })
        
        local lastTime = tick()
        local frameCount = 0
        
        RunService.Heartbeat:Connect(function()
            frameCount = frameCount + 1
            local currentTime = tick()
            if currentTime - lastTime >= 1 then
                local fps = math.floor(frameCount / (currentTime - lastTime))
                fpsLabel.Text = "FPS: " .. fps
                
                -- 色をパフォーマンスに基づいて変更
                if fps >= 60 then
                    fpsLabel.TextColor3 = Color3.fromRGB(85, 255, 85)
                elseif fps >= 30 then
                    fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 85)
                else
                    fpsLabel.TextColor3 = Color3.fromRGB(255, 85, 85)
                end
                
                frameCount = 0
                lastTime = currentTime
            end
        end)
        
        return monitorFrame
    end,
    
    -- カスタマイズ可能なホットキーシステム
    HotkeySystem = function(container, hotkeys)
        local hotkeyFrame = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(30, 30, 35),
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = container
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = hotkeyFrame})
        
        local layout = Create("UIListLayout", {
            Padding = UDim.new(0, 5),
            Parent = hotkeyFrame
        })
        
        Create("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            Parent = hotkeyFrame
        })
        
        for name, hotkeyConfig in pairs(hotkeys) do
            local hotkeyRow = Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 30),
                Parent = hotkeyFrame
            })
            
            Create("TextLabel", {
                Text = name,
                TextColor3 = Color3.fromRGB(240, 240, 240),
                BackgroundTransparency = 1,
                Size = UDim2.new(0.6, 0, 1, 0),
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = hotkeyRow
            })
            
            local keyButton = Create("TextButton", {
                Text = hotkeyConfig.key,
                BackgroundColor3 = Color3.fromRGB(50, 50, 55),
                Size = UDim2.new(0.3, 0, 0.7, 0),
                Position = UDim2.new(0.65, 0, 0.15, 0),
                TextColor3 = Color3.fromRGB(200, 200, 200),
                TextSize = 11,
                Font = Enum.Font.Gotham,
                Parent = hotkeyRow
            })
            
            Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = keyButton})
            
            local listening = false
            keyButton.MouseButton1Click:Connect(function()
                listening = true
                keyButton.Text = "[...]"
                keyButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
            end)
            
            local connection
            connection = UserInputService.InputBegan:Connect(function(input)
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    local key = input.KeyCode.Name
                    keyButton.Text = key
                    keyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
                    hotkeyConfig.key = key
                    listening = false
                    connection:Disconnect()
                end
            end)
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.KeyCode.Name == hotkeyConfig.key then
                    hotkeyConfig.callback()
                end
            end)
        end
        
        return hotkeyFrame
    end,
    
    -- 3Dプレビュー機能
    Create3DPreview = function(container, modelName)
        local previewFrame = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(20, 20, 25),
            Size = UDim2.new(1, 0, 0, 200),
            ClipsDescendants = true,
            Parent = container
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = previewFrame})
        
        local viewport = Create("ViewportFrame", {
            BackgroundColor3 = Color3.fromRGB(30, 30, 35),
            Size = UDim2.new(1, -20, 1, -40),
            Position = UDim2.new(0, 10, 0, 30),
            Parent = previewFrame
        })
        
        local camera = Create("Camera", {
            Parent = viewport,
            FieldOfView = 70
        })
        
        viewport.CurrentCamera = camera
        
        -- サンプルモデルを作成
        local part = Create("Part", {
            Name = "PreviewPart",
            Size = Vector3.new(4, 4, 4),
            Position = Vector3.new(0, 0, 0),
            Anchored = true,
            Parent = viewport,
            Material = Enum.Material.Neon,
            BrickColor = BrickColor.new("Bright blue")
        })
        
        camera.CFrame = CFrame.new(0, 0, 10)
        
        Create("TextLabel", {
            Text = "3D Preview: " .. modelName,
            TextColor3 = Color3.fromRGB(240, 240, 240),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 25),
            Position = UDim2.new(0, 10, 0, 5),
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = previewFrame
        })
        
        -- 自動回転
        local rotation = 0
        RunService.Heartbeat:Connect(function(delta)
            rotation = rotation + delta * 0.5
            part.CFrame = CFrame.Angles(0, rotation, 0)
        end)
        
        return previewFrame
    end,
    
    -- データ視覚化チャート
    CreateChart = function(container, data, chartType)
        local chartFrame = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(25, 25, 30),
            Size = UDim2.new(1, 0, 0, 150),
            Parent = container
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = chartFrame})
        
        local maxValue = math.max(unpack(data.values))
        
        if chartType == "bar" then
            for i, value in ipairs(data.values) do
                local bar = Create("Frame", {
                    BackgroundColor3 = data.colors[i] or Color3.fromRGB(0, 170, 255),
                    Size = UDim2.new(0.8 / #data.values, 0, value / maxValue, -10),
                    Position = UDim2.new(0.1 + (i-1) * (0.8 / #data.values), 0, 1 - (value / maxValue), 5),
                    AnchorPoint = Vector2.new(0, 1),
                    Parent = chartFrame
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = bar
                })
                
                Create("TextLabel", {
                    Text = data.labels[i] or "",
                    TextColor3 = Color3.fromRGB(240, 240, 240),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 15),
                    Position = UDim2.new(0, 0, 1, 2),
                    Font = Enum.Font.Gotham,
                    TextSize = 10,
                    Parent = bar
                })
            end
        end
        
        return chartFrame
    end
}

function Nebula:CreateWindow(config)
    local Window = {}
    
    -- ウィンドウフレーム
    local MainFrame = Create("Frame", {
        Name = "MainWindow",
        BackgroundColor3 = Color3.fromRGB(20, 20, 25),
        BackgroundTransparency = 0.05,
        Size = config.Size or UDim2.new(0, 600, 0, 500),
        Position = config.Position or UDim2.new(0.5, -300, 0.5, -250),
        ClipsDescendants = true,
        Parent = ScreenGui
    })
    
    -- スムーズな角丸
    local UICorner = Create("UICorner", {
        CornerRadius = UDim.new(0, 14),
        Parent = MainFrame
    })
    
    -- 控えめな境界線
    local UIStroke = Create("UIStroke", {
        Color = Color3.fromRGB(40, 40, 45),
        Thickness = 1,
        Parent = MainFrame
    })

    -- タイトルバー（ドラッグ可能領域）
    local TitleBar = Create("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = Color3.fromRGB(30, 30, 35),
        Size = UDim2.new(1, 0, 0, 42),
        Parent = MainFrame
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 14),
        Parent = TitleBar
    })

    -- ウィンドウタイトル
    local TitleLabel = Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        Font = Enum.Font.GothamSemibold,
        Text = config.Name or "Nebula UI - Revolutionary",
        TextColor3 = Color3.fromRGB(240, 240, 240),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TitleBar
    })

    -- 最小化ボタン
    local MinimizeButton = Create("TextButton", {
        Name = "Minimize",
        BackgroundColor3 = Color3.fromRGB(45, 45, 50),
        BackgroundTransparency = 0.5,
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(1, -74, 0.5, -16),
        Text = "_",
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        Parent = TitleBar
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = MinimizeButton
    })

    -- 閉じるボタン
    local CloseButton = Create("TextButton", {
        Name = "Close",
        BackgroundColor3 = Color3.fromRGB(45, 45, 50),
        BackgroundTransparency = 0.5,
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(1, -37, 0.5, -16),
        Text = "×",
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        Parent = TitleBar
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = CloseButton
    })

    -- コンテンツエリア
    local Content = Create("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, -62),
        Position = UDim2.new(0, 10, 0, 52),
        Parent = MainFrame
    })

    -- タブシステム
    local TabButtons = Create("Frame", {
        Name = "TabButtons",
        BackgroundColor3 = Color3.fromRGB(25, 25, 30),
        Size = UDim2.new(0, 140, 1, 0),
        Parent = Content
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = TabButtons
    })

    local TabContent = Create("Frame", {
        Name = "TabContent",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -150, 1, 0),
        Position = UDim2.new(0, 150, 0, 0),
        Parent = Content
    })

    -- 修正されたドラッグ機能
    local dragging = false
    local dragStart, startPos

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)

    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- ウィンドウコントロール
    local isMinimized = false

    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                Size = UDim2.new(MainFrame.Size.X.Scale, MainFrame.Size.X.Offset, 0, 42)
            }):Play()
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                Size = config.Size or UDim2.new(0, 600, 0, 500)
            }):Play()
        end
    end)

    CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        wait(0.3)
        MainFrame:Destroy()
    end)

    -- タブ管理
    local Tabs = {}
    local CurrentTab = nil

    function Window:CreateTab(tabName, icon)
        local Tab = {}
        
        -- タブボタン
        local TabButton = Create("TextButton", {
            Name = tabName .. "Tab",
            BackgroundColor3 = Color3.fromRGB(35, 35, 40),
            BackgroundTransparency = 0.8,
            Size = UDim2.new(1, -12, 0, 45),
            Position = UDim2.new(0, 6, 0, (#Tabs * 50) + 6),
            Text = "",
            Parent = TabButtons
        })
        
        Create("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = TabButton
        })

        local buttonContent = Create("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -10, 1, 0),
            Position = UDim2.new(0, 5, 0, 0),
            Parent = TabButton
        })

        Create("TextLabel", {
            Text = icon or "📄",
            TextColor3 = Color3.fromRGB(180, 180, 180),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 20, 1, 0),
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = buttonContent
        })

        Create("TextLabel", {
            Text = tabName,
            TextColor3 = Color3.fromRGB(180, 180, 180),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -25, 1, 0),
            Position = UDim2.new(0, 25, 0, 0),
            Font = Enum.Font.Gotham,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = buttonContent
        })

        -- タブコンテンツ
        local TabFrame = Create("ScrollingFrame", {
            Name = tabName .. "Content",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 4,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = TabContent
        })

        local Layout = Create("UIListLayout", {
            Padding = UDim.new(0, 12),
            Parent = TabFrame
        })

        -- タブ選択
        TabButton.MouseButton1Click:Connect(function()
            if CurrentTab then
                CurrentTab.Visible = false
            end
            
            -- ボタンステートを更新
            for _, btn in pairs(TabButtons:GetChildren()) do
                if btn:IsA("TextButton") then
                    TweenService:Create(btn, TweenInfo.new(0.2), {
                        BackgroundTransparency = 0.8
                    }):Play()
                    btn:FindFirstChildOfClass("Frame").TextLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
                end
            end
            
            CurrentTab = TabFrame
            TabFrame.Visible = true
            
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.3
            }):Play()
            buttonContent.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        -- 最初のタブを自動選択
        if #Tabs == 0 then
            buttonContent.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.3
            }):Play()
            TabFrame.Visible = true
            CurrentTab = TabFrame
        end

        function Tab:CreateSection(sectionName)
            local Section = {}
            
            local SectionFrame = Create("Frame", {
                Name = sectionName .. "Section",
                BackgroundColor3 = Color3.fromRGB(30, 30, 35),
                BackgroundTransparency = 0.1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = TabFrame
            })
            
            Create("UICorner", {
                CornerRadius = UDim.new(0, 10),
                Parent = SectionFrame
            })

            local SectionContent = Create("Frame", {
                Name = "Content",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 1, -20),
                Position = UDim2.new(0, 10, 0, 10),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = SectionFrame
            })

            local SectionLayout = Create("UIListLayout", {
                Padding = UDim.new(0, 10),
                Parent = SectionContent
            })

            -- セクションヘッダー
            Create("TextLabel", {
                Text = sectionName,
                TextColor3 = Color3.fromRGB(240, 240, 240),
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 28),
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SectionContent
            })

            -- 革新的な機能をセクションに追加
            Section.AddSmartSearch = function(self, items)
                return InnovativeFeatures.SmartSearch(SectionContent, items)
            end
            
            Section.AddPerformanceMonitor = function(self)
                return InnovativeFeatures.PerformanceMonitor(SectionContent)
            end
            
            Section.AddHotkeySystem = function(self, hotkeys)
                return InnovativeFeatures.HotkeySystem(SectionContent, hotkeys)
            end
            
            Section.Add3DPreview = function(self, modelName)
                return InnovativeFeatures.Create3DPreview(SectionContent, modelName)
            end
            
            Section.AddChart = function(self, data, chartType)
                return InnovativeFeatures.CreateChart(SectionContent, data, chartType)
            end

            -- 従来のコントロールも保持
            Section.CreateButton = function(self, buttonConfig)
                local Button = Create("TextButton", {
                    Name = buttonConfig.Name .. "Button",
                    BackgroundColor3 = Color3.fromRGB(40, 40, 45),
                    BackgroundTransparency = 0.5,
                    Size = UDim2.new(1, 0, 0, 38),
                    Text = "",
                    Parent = SectionContent
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = Button
                })

                Create("TextLabel", {
                    Text = buttonConfig.Name,
                    TextColor3 = Color3.fromRGB(240, 240, 240),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -20, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Button
                })

                -- ホバーエフェクト
                Button.MouseEnter:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.15), {
                        BackgroundTransparency = 0.2
                    }):Play()
                end)

                Button.MouseLeave:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.15), {
                        BackgroundTransparency = 0.5
                    }):Play()
                end)

                Button.MouseButton1Click:Connect(function()
                    if buttonConfig.Callback then
                        buttonConfig.Callback()
                    end
                end)

                return Button
            end

            table.insert(Tabs, Section)
            return Section
        end

        table.insert(Tabs, Tab)
        return Tab
    end

    return Window
end

-- 使用例
local Window = Nebula:CreateWindow({
    Name = "Nebula UI - Revolutionary",
    Size = UDim2.new(0, 650, 0, 550),
    Position = UDim2.new(0.5, -325, 0.5, -275)
})

-- タブの作成
local DashboardTab = Window:CreateTab("ダッシュボード", "📊")
local ToolsTab = Window:CreateTab("ツール", "🛠️")
local SettingsTab = Window:CreateTab("設定", "⚙️")

-- ダッシュボードに革新的な機能を追加
local DashboardSection = DashboardTab:CreateSection("パフォーマンス")
DashboardSection:AddPerformanceMonitor()

local StatsSection = DashboardTab:CreateSection("統計")
StatsSection:AddChart({
    labels = {"月", "火", "水", "木", "金", "土", "日"},
    values = {65, 59, 80, 81, 56, 55, 40},
    colors = {
        Color3.fromRGB(255, 99, 132),
        Color3.fromRGB(255, 159, 64),
        Color3.fromRGB(255, 205, 86),
        Color3.fromRGB(75, 192, 192),
        Color3.fromRGB(54, 162, 235),
        Color3.fromRGB(153, 102, 255),
        Color3.fromRGB(201, 203, 207)
    }
}, "bar")

-- ツールタブ
local QuickTools = ToolsTab:CreateSection("クイックツール")
QuickTools:Add3DPreview("サンプルオブジェクト")

local HotkeySection = ToolsTab:CreateSection("ホットキー")
HotkeySection:AddHotkeySystem({
    ["UIを表示/非表示"] = {
        key = "RightShift",
        callback = function()
            print("UIトグル")
        end
    },
    ["スクリーンショット"] = {
        key = "F12", 
        callback = function()
            print("スクリーンショット撮影")
        end
    },
    ["クイックセーブ"] = {
        key = "F5",
        callback = function()
            print("クイックセーブ実行")
        end
    }
})

-- 設定タブ
local ConfigSection = SettingsTab:CreateSection("設定")
ConfigSection:CreateButton({
    Name = "テーマを変更",
    Callback = function()
        print("テーマ変更ダイアログを表示")
    end
})

ConfigSection:CreateButton({
    Name = "設定をエクスポート", 
    Callback = function()
        print("設定をエクスポート")
    end
})

return Nebula
