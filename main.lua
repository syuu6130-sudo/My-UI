-- Nebula UI - Mobile Optimized Edition
local Nebula = {}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

-- デバイス判定
local isMobile = UserInputService.TouchEnabled
local isDesktop = UserInputService.MouseEnabled

-- Main UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NebulaUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

-- 画面サイズに基づく動的サイズ計算
local function GetOptimalSize()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    if isMobile then
        -- スマホ: 画面の80%幅、高さはコンテンツに合わせて調整
        return UDim2.new(0.8, 0, 0, 0), UDim2.new(0.1, 0, 0.1, 0)
    else
        -- PC: 固定サイズだが画面に収まるように
        local width = math.min(600, viewportSize.X * 0.7)
        local height = math.min(450, viewportSize.Y * 0.7)
        return UDim2.new(0, width, 0, height), UDim2.new(0.5, -width/2, 0.5, -height/2)
    end
end

-- Utility Functions
local function Create(className, properties)
    local obj = Instance.new(className)
    for prop, value in pairs(properties) do
        obj[prop] = value
    end
    return obj
end

-- スマホ対応ドラッグシステム
local DragManager = {
    ActiveWindows = {}
}

function DragManager:EnableDrag(frame, dragHandle)
    local dragging = false
    local dragStart, startPos
    
    local function update(input)
        local delta
        if input.UserInputType == Enum.UserInputType.Touch then
            delta = input.Position - dragStart
        else
            delta = input.Position - dragStart
        end
        
        local newX = startPos.X.Offset + delta.X
        local newY = startPos.Y.Offset + delta.Y
        
        -- 画面内に制限
        local viewportSize = workspace.CurrentCamera.ViewportSize
        newX = math.clamp(newX, 0, viewportSize.X - frame.AbsoluteSize.X)
        newY = math.clamp(newY, 0, viewportSize.Y - frame.AbsoluteSize.Y)
        
        frame.Position = UDim2.new(0, newX, 0, newY)
    end
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            -- タッチフィードバック
            if isMobile then
                TweenService:Create(dragHandle, TweenInfo.new(0.1), {
                    BackgroundColor3 = Color3.fromRGB(60, 60, 65)
                }):Play()
            end
        end
    end)
    
    dragHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            if isMobile then
                TweenService:Create(dragHandle, TweenInfo.new(0.1), {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                }):Play()
            end
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            update(input)
        end
    end)
end

-- スマホ最適化された機能モジュール
local MobileFeatures = {
    -- タッチフレンドリーなパフォーマンスモニター
    PerformanceMonitor = function(container)
        local monitorFrame = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(25, 25, 30),
            Size = UDim2.new(1, 0, 0, isMobile and 70 or 60),
            Parent = container
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = monitorFrame})
        
        local statsGrid = Create("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 1, -10),
            Position = UDim2.new(0, 10, 0, 5),
            Parent = monitorFrame
        })
        
        -- スタット表示の作成
        local function CreateStatFrame(text, position, width)
            local frame = Create("Frame", {
                BackgroundColor3 = Color3.fromRGB(40, 40, 45),
                Size = UDim2.new(width, -5, 1, 0),
                Position = position,
                Parent = statsGrid
            })
            
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = frame})
            
            local label = Create("TextLabel", {
                Text = text,
                TextColor3 = Color3.fromRGB(240, 240, 240),
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = isMobile and Enum.Font.GothamBold or Enum.Font.GothamSemibold,
                TextSize = isMobile and 14 or 12,
                Parent = frame
            })
            
            return frame, label
        end
        
        local fpsFrame, fpsLabel = CreateStatFrame("FPS: --", UDim2.new(0, 0, 0, 0), isMobile and 0.32 or 0.3)
        local memoryFrame, memoryLabel = CreateStatFrame("MEM: --", UDim2.new(isMobile and 0.34 or 0.35, 0, 0, 0), isMobile and 0.32 or 0.3)
        local pingFrame, pingLabel = CreateStatFrame("PING: --", UDim2.new(isMobile and 0.68 or 0.7, 0, 0, 0), isMobile and 0.32 or 0.3)
        
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
    
    -- タッチ対応ボタングリッド
    TouchButtonGrid = function(container, actions, columns)
        columns = columns or (isMobile and 2 or 4)
        local buttonHeight = isMobile and 50 or 40
        
        local gridFrame = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(30, 30, 35),
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = container
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = gridFrame})
        
        local gridLayout = Create("UIGridLayout", {
            CellSize = UDim2.new(1/columns, -10, 0, buttonHeight),
            CellPadding = UDim2.new(0, 10, 0, 10),
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
                Size = UDim2.new(1, 0, 0, buttonHeight),
                Text = "",
                AutoButtonColor = false,
                Parent = gridFrame
            })
            
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = actionButton})
            
            -- タッチフィードバック用
            if isMobile then
                Create("UIPadding", {
                    PaddingTop = UDim.new(0, 5),
                    PaddingBottom = UDim.new(0, 5),
                    PaddingLeft = UDim.new(0, 5),
                    PaddingRight = UDim.new(0, 5),
                    Parent = actionButton
                })
            end
            
            local contentFrame = Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Parent = actionButton
            })
            
            Create("TextLabel", {
                Text = name,
                TextColor3 = Color3.fromRGB(240, 240, 240),
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -30, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                Font = isMobile and Enum.Font.GothamBold or Enum.Font.Gotham,
                TextSize = isMobile and 14 or 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Parent = contentFrame
            })
            
            if actionConfig.icon then
                Create("TextLabel", {
                    Text = actionConfig.icon,
                    TextColor3 = Color3.fromRGB(200, 200, 200),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 25, 1, 0),
                    Position = UDim2.new(1, -25, 0, 0),
                    Font = Enum.Font.Gotham,
                    TextSize = isMobile and 16 or 14,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = contentFrame
                })
            end
            
            -- タッチ/ホバーエフェクト
            local function onInputBegin()
                TweenService:Create(actionButton, TweenInfo.new(0.1), {
                    BackgroundTransparency = 0.2,
                    BackgroundColor3 = Color3.fromRGB(70, 70, 75)
                }):Play()
            end
            
            local function onInputEnd()
                TweenService:Create(actionButton, TweenInfo.new(0.2), {
                    BackgroundTransparency = 0.5,
                    BackgroundColor3 = Color3.fromRGB(50, 50, 55)
                }):Play()
            end
            
            if isMobile then
                actionButton.TouchTap:Connect(function()
                    actionConfig.callback()
                    onInputEnd()
                end)
                
                actionButton.TouchLongPress:Connect(function()
                    onInputBegin()
                end)
            else
                actionButton.MouseButton1Click:Connect(function()
                    actionConfig.callback()
                end)
                
                actionButton.MouseEnter:Connect(onInputBegin)
                actionButton.MouseLeave:Connect(onInputEnd)
            end
        end
        
        return gridFrame
    end,
    
    -- モバイル向けナビゲーション
    MobileNavigation = function(container, tabs)
        local navFrame = Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(25, 25, 30),
            Size = UDim2.new(1, 0, 0, isMobile and 60 : 50),
            Parent = container
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = navFrame})
        
        local scrollFrame = Create("ScrollingFrame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 1, -10),
            Position = UDim2.new(0, 10, 0, 5),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 0,
            AutomaticCanvasSize = Enum.AutomaticSize.X,
            Parent = navFrame
        })
        
        local layout = Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = scrollFrame
        })
        
        for i, tab in ipairs(tabs) do
            local navButton = Create("TextButton", {
                BackgroundColor3 = Color3.fromRGB(40, 40, 45),
                BackgroundTransparency = 0.7,
                Size = UDim2.new(0, isMobile and 80 : 70, 1, 0),
                Text = "",
                AutoButtonColor = false,
                LayoutOrder = i,
                Parent = scrollFrame
            })
            
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = navButton})
            
            Create("TextLabel", {
                Text = tab.icon .. "\n" .. tab.name,
                TextColor3 = Color3.fromRGB(200, 200, 200),
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.Gotham,
                TextSize = isMobile and 12 : 11,
                TextWrapped = true,
                Parent = navButton
            })
            
            navButton.MouseButton1Click:Connect(function()
                tab.callback()
            end)
        end
        
        return navFrame
    end
}

function Nebula:CreateWindow(config)
    local Window = {}
    
    -- デバイスに最適化されたサイズと位置
    local optimalSize, optimalPosition = GetOptimalSize()
    
    -- メインウィンドウ
    local MainFrame = Create("Frame", {
        Name = "NebulaUIWindow",
        BackgroundColor3 = Color3.fromRGB(20, 20, 25),
        BackgroundTransparency = 0.05,
        Size = config.Size or optimalSize,
        Position = config.Position or optimalPosition,
        ClipsDescendants = true,
        Parent = ScreenGui
    })
    
    -- 角丸
    Create("UICorner", {
        CornerRadius = UDim.new(0, isMobile and 12 : 14),
        Parent = MainFrame
    })
    
    -- 境界線
    Create("UIStroke", {
        Color = Color3.fromRGB(40, 40, 45),
        Thickness = 1,
        Parent = MainFrame
    })

    -- タイトルバー（ドラッグ可能）
    local titleBarHeight = isMobile and 44 : 36
    local TitleBar = Create("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = Color3.fromRGB(30, 30, 35),
        Size = UDim2.new(1, 0, 0, titleBarHeight),
        Parent = MainFrame
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, isMobile and 12 : 14),
        Parent = TitleBar
    })

    -- ウィンドウタイトル
    local TitleLabel = Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        Font = isMobile and Enum.Font.GothamBold or Enum.Font.GothamSemibold,
        Text = config.Name or "Nebula UI " .. (isMobile and "Mobile" or "Desktop"),
        TextColor3 = Color3.fromRGB(240, 240, 240),
        TextSize = isMobile and 16 : 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TitleBar
    })

    -- ウィンドウコントロール
    local controlSize = isMobile and 32 : 28
    local controlCorner = isMobile and 8 : 6
    
    local MinimizeButton = Create("TextButton", {
        Name = "Minimize",
        BackgroundColor3 = Color3.fromRGB(45, 45, 50),
        BackgroundTransparency = 0.5,
        Size = UDim2.new(0, controlSize, 0, controlSize),
        Position = UDim2.new(1, -(controlSize * 2 + 10), 0.5, -controlSize/2),
        Text = "_",
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextSize = isMobile and 18 : 16,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        Parent = TitleBar
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, controlCorner),
        Parent = MinimizeButton
    })

    local CloseButton = Create("TextButton", {
        Name = "Close",
        BackgroundColor3 = Color3.fromRGB(45, 45, 50),
        BackgroundTransparency = 0.5,
        Size = UDim2.new(0, controlSize, 0, controlSize),
        Position = UDim2.new(1, -(controlSize + 5), 0.5, -controlSize/2),
        Text = "×",
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextSize = isMobile and 18 : 16,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        Parent = TitleBar
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, controlCorner),
        Parent = CloseButton
    )

    -- メインコンテンツエリア
    local Content = Create("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, -(titleBarHeight + 10)),
        Position = UDim2.new(0, 10, 0, titleBarHeight + 5),
        Parent = MainFrame
    })

    -- スクロール可能なコンテンツエリア
    local ScrollContent = Create("ScrollingFrame", {
        Name = "ScrollContent",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = isMobile and 6 : 4,
        ScrollBarImageColor3 = Color3.fromRGB(60, 60, 65),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = Content
    })

    local ContentLayout = Create("UIListLayout", {
        Padding = UDim.new(0, isMobile and 12 : 10),
        Parent = ScrollContent
    })

    Create("UIPadding", {
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
        Parent = ScrollContent
    })

    -- ドラッグ機能を適用
    DragManager:EnableDrag(MainFrame, TitleBar)

    -- ウィンドウコントロールの機能
    local isMinimized = false

    local function setupControlButton(button, callback)
        if isMobile then
            button.TouchTap:Connect(callback)
        else
            button.MouseButton1Click:Connect(callback)
        end
        
        -- タッチ/ホバーエフェクト
        local function onInputBegin()
            TweenService:Create(button, TweenInfo.new(0.1), {
                BackgroundTransparency = 0.3
            }):Play()
        end
        
        local function onInputEnd()
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.5
            }):Play()
        end
        
        if isMobile then
            button.TouchLongPress:Connect(onInputBegin)
        else
            button.MouseEnter:Connect(onInputBegin)
            button.MouseLeave:Connect(onInputEnd)
        end
    end

    setupControlButton(MinimizeButton, function()
        isMinimized = not isMinimized
        if isMinimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                Size = UDim2.new(MainFrame.Size.X.Scale, MainFrame.Size.X.Offset, 0, titleBarHeight)
            }):Play()
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                Size = config.Size or optimalSize
            }):Play()
        end
    end)

    setupControlButton(CloseButton, function()
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
        
        local TabFrame = Create("Frame", {
            Name = tabName .. "Content",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            Parent = ScrollContent
        })

        local TabLayout = Create("UIListLayout", {
            Padding = UDim.new(0, isMobile and 12 : 10),
            Parent = TabFrame
        })

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
                CornerRadius = UDim.new(0, isMobile and 10 : 8),
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
                Padding = UDim.new(0, isMobile and 10 : 8),
                Parent = SectionContent
            })

            -- セクションヘッダー
            Create("TextLabel", {
                Text = sectionName,
                TextColor3 = Color3.fromRGB(240, 240, 240),
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, isMobile and 30 : 25),
                Font = isMobile and Enum.Font.GothamBold or Enum.Font.GothamSemibold,
                TextSize = isMobile and 16 : 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SectionContent
            })

            -- モバイル機能を追加
            Section.AddPerformanceMonitor = function(self)
                return MobileFeatures.PerformanceMonitor(SectionContent)
            end
            
            Section.AddButtonGrid = function(self, actions, columns)
                return MobileFeatures.TouchButtonGrid(SectionContent, actions, columns)
            end

            -- 基本的なボタン
            Section.CreateButton = function(self, buttonConfig)
                local buttonHeight = isMobile and 45 : 35
                
                local Button = Create("TextButton", {
                    Name = buttonConfig.Name .. "Button",
                    BackgroundColor3 = Color3.fromRGB(40, 40, 45),
                    BackgroundTransparency = 0.5,
                    Size = UDim2.new(1, 0, 0, buttonHeight),
                    Text = "",
                    AutoButtonColor = false,
                    Parent = SectionContent
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, isMobile and 8 : 6),
                    Parent = Button
                })

                Create("TextLabel", {
                    Text = buttonConfig.Name,
                    TextColor3 = Color3.fromRGB(240, 240, 240),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -20, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    Font = isMobile and Enum.Font.GothamBold or Enum.Font.Gotham,
                    TextSize = isMobile and 14 : 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Button
                })

                -- タッチ/ホバーエフェクト
                local function onInputBegin()
                    TweenService:Create(Button, TweenInfo.new(0.1), {
                        BackgroundTransparency = 0.2
                    }):Play()
                end
                
                local function onInputEnd()
                    TweenService:Create(Button, TweenInfo.new(0.2), {
                        BackgroundTransparency = 0.5
                    }):Play()
                end
                
                if isMobile then
                    Button.TouchTap:Connect(function()
                        if buttonConfig.Callback then
                            buttonConfig.Callback()
                        end
                        onInputEnd()
                    end)
                    
                    Button.TouchLongPress:Connect(onInputBegin)
                else
                    Button.MouseButton1Click:Connect(function()
                        if buttonConfig.Callback then
                            buttonConfig.Callback()
                        end
                    end)
                    
                    Button.MouseEnter:Connect(onInputBegin)
                    Button.MouseLeave:Connect(onInputEnd)
                end

                return Button
            end

            table.insert(Tabs, Section)
            return Section
        end

        -- 最初のタブを自動表示
        if #Tabs == 0 then
            TabFrame.Visible = true
            CurrentTab = TabFrame
        end

        table.insert(Tabs, Tab)
        return Tab
    end

    -- モバイルナビゲーションを追加
    if isMobile then
        local navTabs = {}
        for i, tab in ipairs(Tabs) do
            table.insert(navTabs, {
                name = "Tab" .. i,
                icon = "📱",
                callback = function()
                    if CurrentTab then
                        CurrentTab.Visible = false
                    end
                    CurrentTab = tab
                    tab.Visible = true
                end
            })
        end
        
        if #navTabs > 0 then
            MobileFeatures.MobileNavigation(Content, navTabs)
        end
    end

    return Window
end

-- 使用例
local Window = Nebula:CreateWindow({
    Name = "Nebula UI - " .. (isMobile and "Mobile" or "Desktop"),
})

-- タブの作成
local MainTab = Window:CreateTab("メイン", "🏠")
local ToolsTab = Window:CreateTab("ツール", "🛠️")
local GameTab = Window:CreateTab("ゲーム", "🎮")

-- メインタブ
local WelcomeSection = MainTab:CreateSection("ようこそ")
WelcomeSection:AddPerformanceMonitor()

local QuickSection = MainTab:CreateSection("クイックアクション")
QuickSection:AddButtonGrid({
    ["設定"] = {
        icon = "⚙️",
        callback = function()
            print("設定を開く")
        end
    },
    ["ヘルプ"] = {
        icon = "❓",
        callback = function()
            print("ヘルプを表示")
        end
    },
    ["情報"] = {
        icon = "ℹ️",
        callback = function()
            print("情報を表示")
        end
    },
    ["終了"] = {
        icon = "🚪",
        callback = function()
            print("終了")
        end
    }
}, 2)

-- ツールタブ
local UtilitySection = ToolsTab:CreateSection("ユーティリティ")
UtilitySection:AddButtonGrid({
    ["掃除"] = {
        icon = "🧹",
        callback = function()
            print("掃除実行")
        end
    },
    ["リセット"] = {
        icon = "🔄",
        callback = function()
            print("リセット実行")
        end
    },
    ["バックアップ"] = {
        icon = "💾", 
        callback = function()
            print("バックアップ作成")
        end
    }
}, 2)

-- ゲームタブ
local GameSection = GameTab:CreateSection("ゲーム機能")
GameSection:CreateButton({
    Name = "プレイヤーリストを表示",
    Callback = function()
        print("プレイヤーリスト表示")
    end
})

GameSection:CreateButton({
    Name = "サーバー情報",
    Callback = function()
        print("サーバー情報表示")
    end
})

return Nebula
