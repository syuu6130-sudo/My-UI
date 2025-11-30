-- Nebula UI - Ultimate Edition (Fixed Drag & Horizontal Layout)
local Nebula = {}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")

-- Main UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NebulaUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Utility Functions
local function Create(className, properties)
    local obj = Instance.new(className)
    for prop, value in pairs(properties) do
        obj[prop] = value
    end
    return obj
end

-- 完全修正されたドラッグシステム
local DragManager = {
    ActiveWindows = {}
}

function DragManager:EnableDrag(frame, dragHandle)
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- 革新的な機能モジュール
local InnovativeFeatures = {
    -- リアルタイムパフォーマンスモニター（コンパクト版）
    PerformanceMonitor = function(container)
        local monitorFrame = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(25, 25, 30),
            Size = UDim2.new(1, 0, 0, 60),
            Parent = container
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = monitorFrame})
        
        local statsGrid = Create("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 1, -10),
            Position = UDim2.new(0, 10, 0, 5),
            Parent = monitorFrame
        })
        
        -- FPS表示
        local fpsFrame = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(40, 40, 45),
            Size = UDim2.new(0.3, -5, 1, 0),
            Parent = statsGrid
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = fpsFrame})
        
        local fpsLabel = Create("TextLabel", {
            Text = "FPS: --",
            TextColor3 = Color3.fromRGB(240, 240, 240),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.GothamSemibold,
            TextSize = 12,
            Parent = fpsFrame
        })
        
        -- メモリ表示
        local memoryFrame = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(40, 40, 45),
            Size = UDim2.new(0.3, -5, 1, 0),
            Position = UDim2.new(0.35, 0, 0, 0),
            Parent = statsGrid
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = memoryFrame})
        
        local memoryLabel = Create("TextLabel", {
            Text = "MEM: --",
            TextColor3 = Color3.fromRGB(240, 240, 240),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.GothamSemibold,
            TextSize = 12,
            Parent = memoryFrame
        })
        
        -- ピング表示
        local pingFrame = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(40, 40, 45),
            Size = UDim2.new(0.3, -5, 1, 0),
            Position = UDim2.new(0.7, 0, 0, 0),
            Parent = statsGrid
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = pingFrame})
        
        local pingLabel = Create("TextLabel", {
            Text = "PING: --",
            TextColor3 = Color3.fromRGB(240, 240, 240),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.GothamSemibold,
            TextSize = 12,
            Parent = pingFrame
        })
        
        -- パフォーマンス監視
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
                    fpsFrame.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
                elseif fps >= 30 then
                    fpsFrame.BackgroundColor3 = Color3.fromRGB(180, 180, 40)
                else
                    fpsFrame.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
                end
                
                frameCount = 0
                lastTime = currentTime
            end
        end)
        
        return monitorFrame
    end,
    
    -- コンパクトなホットキーシステム
    CompactHotkeySystem = function(container, hotkeys)
        local hotkeyFrame = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(30, 30, 35),
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = container
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = hotkeyFrame})
        
        local layout = Create("UIListLayout", {
            Padding = UDim.new(0, 8),
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
                Size = UDim2.new(1, 0, 0, 25),
                Parent = hotkeyFrame
            })
            
            Create("TextLabel", {
                Text = name,
                TextColor3 = Color3.fromRGB(240, 240, 240),
                BackgroundTransparency = 1,
                Size = UDim2.new(0.6, 0, 1, 0),
                Font = Enum.Font.Gotham,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = hotkeyRow
            })
            
            local keyButton = Create("TextButton", {
                Text = hotkeyConfig.key,
                BackgroundColor3 = Color3.fromRGB(50, 50, 55),
                Size = UDim2.new(0.3, 0, 0.8, 0),
                Position = UDim2.new(0.65, 0, 0.1, 0),
                TextColor3 = Color3.fromRGB(200, 200, 200),
                TextSize = 10,
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
    
    -- クイックアクションボタングリッド
    QuickActionGrid = function(container, actions)
        local gridFrame = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(30, 30, 35),
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = container
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = gridFrame})
        
        local gridLayout = Create("UIGridLayout", {
            CellSize = UDim2.new(0.48, 0, 0, 40),
            CellPadding = UDim2.new(0.04, 0, 0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = gridFrame
        })
        
        Create("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            Parent = gridFrame
        })
        
        for name, actionConfig in pairs(actions) do
            local actionButton = Create("TextButton", {
                BackgroundColor3 = Color3.fromRGB(50, 50, 55),
                BackgroundTransparency = 0.5,
                Size = UDim2.new(1, 0, 0, 40),
                Text = "",
                Parent = gridFrame
            })
            
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = actionButton})
            
            Create("TextLabel", {
                Text = name,
                TextColor3 = Color3.fromRGB(240, 240, 240),
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = actionButton
            })
            
            if actionConfig.icon then
                Create("TextLabel", {
                    Text = actionConfig.icon,
                    TextColor3 = Color3.fromRGB(200, 200, 200),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 20, 1, 0),
                    Position = UDim2.new(1, -25, 0, 0),
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = actionButton
                })
            end
            
            -- ホバーエフェクト
            actionButton.MouseEnter:Connect(function()
                TweenService:Create(actionButton, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.2
                }):Play()
            end)
            
            actionButton.MouseLeave:Connect(function()
                TweenService:Create(actionButton, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.5
                }):Play()
            end)
            
            actionButton.MouseButton1Click:Connect(function()
                actionConfig.callback()
            end)
        end
        
        return gridFrame
    end,
    
    -- コンパクトなデータ表示
    CompactDataView = function(container, data)
        local dataFrame = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(30, 30, 35),
            Size = UDim2.new(1, 0, 0, 80),
            Parent = container
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = dataFrame})
        
        -- シンプルなバーチャート
        local maxValue = math.max(unpack(data.values))
        local barWidth = 1 / #data.values
        
        for i, value in ipairs(data.values) do
            local barHeight = (value / maxValue) * 60
            local bar = Create("Frame", {
                BackgroundColor3 = data.colors[i] or Color3.fromRGB(0, 170, 255),
                Size = UDim2.new(barWidth - 0.05, 0, 0, barHeight),
                Position = UDim2.new((i-1) * barWidth + 0.025, 0, 1, -barHeight - 5),
                AnchorPoint = Vector2.new(0, 1),
                Parent = dataFrame
            })
            
            Create("UICorner", {
                CornerRadius = UDim.new(0, 2),
                Parent = bar
            })
        end
        
        Create("TextLabel", {
            Text = data.title or "Statistics",
            TextColor3 = Color3.fromRGB(240, 240, 240),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -10, 0, 20),
            Position = UDim2.new(0, 5, 0, 5),
            Font = Enum.Font.GothamSemibold,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = dataFrame
        })
        
        return dataFrame
    end
}

function Nebula:CreateWindow(config)
    local Window = {}
    
    -- 横広のウィンドウフレーム
    local MainFrame = Create("Frame", {
        Name = "MainWindow",
        BackgroundColor3 = Color3.fromRGB(20, 20, 25),
        BackgroundTransparency = 0.05,
        Size = config.Size or UDim2.new(0, 700, 0, 400), -- 横広サイズ
        Position = config.Position or UDim2.new(0.5, -350, 0.5, -200),
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
        Size = UDim2.new(1, 0, 0, 36),
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
        Text = config.Name or "Nebula UI - Ultimate",
        TextColor3 = Color3.fromRGB(240, 240, 240),
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TitleBar
    })

    -- 最小化ボタン
    local MinimizeButton = Create("TextButton", {
        Name = "Minimize",
        BackgroundColor3 = Color3.fromRGB(45, 45, 50),
        BackgroundTransparency = 0.5,
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -64, 0.5, -14),
        Text = "_",
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextSize = 16,
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
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -32, 0.5, -14),
        Text = "×",
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Parent = TitleBar
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = CloseButton
    })

    -- メインコンテンツエリア（横レイアウト）
    local Content = Create("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, -46),
        Position = UDim2.new(0, 10, 0, 36),
        Parent = MainFrame
    })

    -- 水平タブシステム（上部タブ）
    local TabContainer = Create("Frame", {
        Name = "TabContainer",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 35),
        Parent = Content
    })

    local TabContent = Create("Frame", {
        Name = "TabContent",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -40),
        Position = UDim2.new(0, 0, 0, 35),
        Parent = Content
    })

    -- スクロール可能なコンテンツエリア
    local ScrollContent = Create("ScrollingFrame", {
        Name = "ScrollContent",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Color3.fromRGB(60, 60, 65),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = TabContent
    })

    local ContentLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 10),
        Parent = ScrollContent
    })

    Create("UIPadding", {
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
        Parent = ScrollContent
    })

    -- 修正されたドラッグ機能を適用
    DragManager:EnableDrag(MainFrame, TitleBar)

    -- ウィンドウコントロール
    local isMinimized = false

    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                Size = UDim2.new(MainFrame.Size.X.Scale, MainFrame.Size.X.Offset, 0, 36)
            }):Play()
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                Size = config.Size or UDim2.new(0, 700, 0, 400)
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
        
        -- 水平タブボタン
        local TabButton = Create("TextButton", {
            Name = tabName .. "Tab",
            BackgroundColor3 = Color3.fromRGB(35, 35, 40),
            BackgroundTransparency = 0.8,
            Size = UDim2.new(0, 120, 1, 0),
            Position = UDim2.new((#Tabs * 125), 0, 0, 0),
            Text = "",
            Parent = TabContainer
        })
        
        Create("UICorner", {
            CornerRadius = UDim.new(0, 6),
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
            TextSize = 12,
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
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = buttonContent
        })

        -- タブコンテンツ
        local TabFrame = Create("Frame", {
            Name = tabName .. "Content",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            Parent = ScrollContent
        })

        -- タブ選択
        TabButton.MouseButton1Click:Connect(function()
            if CurrentTab then
                CurrentTab.Visible = false
            end
            
            -- ボタンステートを更新
            for _, btn in pairs(TabContainer:GetChildren()) do
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
                Padding = UDim.new(0, 8),
                Parent = SectionContent
            })

            -- セクションヘッダー
            Create("TextLabel", {
                Text = sectionName,
                TextColor3 = Color3.fromRGB(240, 240, 240),
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 25),
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SectionContent
            })

            -- 革新的な機能をセクションに追加
            Section.AddPerformanceMonitor = function(self)
                return InnovativeFeatures.PerformanceMonitor(SectionContent)
            end
            
            Section.AddHotkeySystem = function(self, hotkeys)
                return InnovativeFeatures.CompactHotkeySystem(SectionContent, hotkeys)
            end
            
            Section.AddQuickActions = function(self, actions)
                return InnovativeFeatures.QuickActionGrid(SectionContent, actions)
            end
            
            Section.AddDataView = function(self, data)
                return InnovativeFeatures.CompactDataView(SectionContent, data)
            end

            -- 従来のコントロールも保持
            Section.CreateButton = function(self, buttonConfig)
                local Button = Create("TextButton", {
                    Name = buttonConfig.Name .. "Button",
                    BackgroundColor3 = Color3.fromRGB(40, 40, 45),
                    BackgroundTransparency = 0.5,
                    Size = UDim2.new(1, 0, 0, 35),
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
    Name = "Nebula UI - Ultimate Edition",
    Size = UDim2.new(0, 750, 0, 450), -- 横広サイズ
    Position = UDim2.new(0.5, -375, 0.5, -225)
})

-- タブの作成
local DashboardTab = Window:CreateTab("ダッシュボード", "📊")
local ToolsTab = Window:CreateTab("ツール", "🛠️")
local GameTab = Window:CreateTab("ゲーム", "🎮")
local SettingsTab = Window:CreateTab("設定", "⚙️")

-- ダッシュボードに革新的な機能を追加
local PerformanceSection = DashboardTab:CreateSection("パフォーマンス")
PerformanceSection:AddPerformanceMonitor()

local StatsSection = DashboardTab:CreateSection("統計")
StatsSection:AddDataView({
    title = "週間アクティビティ",
    values = {65, 59, 80, 81, 56, 55, 70},
    colors = {
        Color3.fromRGB(255, 99, 132),
        Color3.fromRGB(255, 159, 64),
        Color3.fromRGB(255, 205, 86),
        Color3.fromRGB(75, 192, 192),
        Color3.fromRGB(54, 162, 235),
        Color3.fromRGB(153, 102, 255),
        Color3.fromRGB(201, 203, 207)
    }
})

-- ツールタブ
local QuickTools = ToolsTab:CreateSection("クイックアクション")
QuickTools:AddQuickActions({
    ["スクリーンショット"] = {
        icon = "📸",
        callback = function()
            print("スクリーンショットを撮影")
        end
    },
    ["位置を記録"] = {
        icon = "📍", 
        callback = function()
            print("現在位置を記録")
        end
    },
    ["テレポート"] = {
        icon = "⚡",
        callback = function()
            print("テレポート実行")
        end
    },
    ["設定を保存"] = {
        icon = "💾",
        callback = function()
            print("設定を保存")
        end
    }
})

local HotkeySection = ToolsTab:CreateSection("ホットキー")
HotkeySection:AddHotkeySystem({
    ["UI表示切替"] = {
        key = "RightShift",
        callback = function()
            print("UI表示を切り替え")
        end
    },
    ["クイックメニュー"] = {
        key = "F1", 
        callback = function()
            print("クイックメニューを表示")
        end
    }
})

-- ゲームタブ
local GameTools = GameTab:CreateSection("ゲームツール")
GameTools:CreateButton({
    Name = "サーバー情報を表示",
    Callback = function()
        print("サーバー情報を表示")
    end
})

GameTools:CreateButton({
    Name = "プレイヤーリスト",
    Callback = function()
        print("プレイヤーリストを表示")
    end
})

-- 設定タブ
local ConfigSection = SettingsTab:CreateSection("設定")
ConfigSection:CreateButton({
    Name = "テーマ設定",
    Callback = function()
        print("テーマ設定を開く")
    end
})

ConfigSection:CreateButton({
    Name = "キー設定", 
    Callback = function()
        print("キー設定を開く")
    end
})

return Nebula
