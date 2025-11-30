-- Nebula UI - Quality Over Quantity
local Nebula = {}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

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

function Nebula:CreateWindow(config)
    local Window = {}
    
    -- Window Frame
    local MainFrame = Create("Frame", {
        Name = "MainWindow",
        BackgroundColor3 = Color3.fromRGB(20, 20, 25),
        BackgroundTransparency = 0.05,
        Size = config.Size or UDim2.new(0, 500, 0, 400),
        Position = config.Position or UDim2.new(0.5, -250, 0.5, -200),
        ClipsDescendants = true,
        Parent = ScreenGui
    })
    
    -- Smooth Corners
    local UICorner = Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = MainFrame
    })
    
    -- Subtle Border
    local UIStroke = Create("UIStroke", {
        Color = Color3.fromRGB(40, 40, 45),
        Thickness = 1,
        Parent = MainFrame
    })

    -- Title Bar
    local TitleBar = Create("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = Color3.fromRGB(30, 30, 35),
        Size = UDim2.new(1, 0, 0, 40),
        Parent = MainFrame
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = TitleBar
    })

    -- Window Title
    local TitleLabel = Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        Font = Enum.Font.GothamSemibold,
        Text = config.Name or "Nebula UI",
        TextColor3 = Color3.fromRGB(240, 240, 240),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TitleBar
    })

    -- Minimize Button
    local MinimizeButton = Create("TextButton", {
        Name = "Minimize",
        BackgroundColor3 = Color3.fromRGB(45, 45, 50),
        BackgroundTransparency = 0.5,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -70, 0.5, -15),
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

    -- Close Button
    local CloseButton = Create("TextButton", {
        Name = "Close",
        BackgroundColor3 = Color3.fromRGB(45, 45, 50),
        BackgroundTransparency = 0.5,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0.5, -15),
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

    -- Content Area
    local Content = Create("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, -60),
        Position = UDim2.new(0, 10, 0, 50),
        Parent = MainFrame
    })

    -- Tab System
    local TabButtons = Create("Frame", {
        Name = "TabButtons",
        BackgroundColor3 = Color3.fromRGB(25, 25, 30),
        Size = UDim2.new(0, 120, 1, 0),
        Parent = Content
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = TabButtons
    })

    local TabContent = Create("Frame", {
        Name = "TabContent",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -130, 1, 0),
        Position = UDim2.new(0, 130, 0, 0),
        Parent = Content
    })

    -- Drag Functionality
    local dragging = false
    local dragInput, dragStart, startPos

    local function updateInput(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

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
            updateInput(input)
        end
    end)

    -- Window Controls
    local isMinimized = false

    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.2), {
                Size = UDim2.new(MainFrame.Size.X.Scale, MainFrame.Size.X.Offset, 0, 40)
            }):Play()
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.2), {
                Size = config.Size or UDim2.new(0, 500, 0, 400)
            }):Play()
        end
    end)

    CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }):Play()
    end)

    -- Tab Management
    local Tabs = {}
    local CurrentTab = nil

    function Window:CreateTab(tabName)
        local Tab = {}
        
        -- Tab Button
        local TabButton = Create("TextButton", {
            Name = tabName .. "Tab",
            BackgroundColor3 = Color3.fromRGB(35, 35, 40),
            BackgroundTransparency = 0.8,
            Size = UDim2.new(1, -10, 0, 40),
            Position = UDim2.new(0, 5, 0, (#Tabs * 45) + 5),
            Text = "",
            Parent = TabButtons
        })
        
        Create("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = TabButton
        })

        Create("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.Gotham,
            Text = tabName,
            TextColor3 = Color3.fromRGB(180, 180, 180),
            TextSize = 13,
            Parent = TabButton
        })

        -- Tab Content
        local TabFrame = Create("ScrollingFrame", {
            Name = tabName .. "Content",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 3,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = TabContent
        })

        local Layout = Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            Parent = TabFrame
        })

        -- Tab Selection
        TabButton.MouseButton1Click:Connect(function()
            if CurrentTab then
                CurrentTab.Visible = false
            end
            
            -- Update button states
            for _, btn in pairs(TabButtons:GetChildren()) do
                if btn:IsA("TextButton") then
                    TweenService:Create(btn, TweenInfo.new(0.1), {
                        BackgroundTransparency = 0.8
                    }):Play()
                    btn.Label.TextColor3 = Color3.fromRGB(180, 180, 180)
                end
            end
            
            CurrentTab = TabFrame
            TabFrame.Visible = true
            
            TweenService:Create(TabButton, TweenInfo.new(0.1), {
                BackgroundTransparency = 0.3
            }):Play()
            TabButton.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        -- Auto-select first tab
        if #Tabs == 0 then
            TabButton.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            TweenService:Create(TabButton, TweenInfo.new(0.1), {
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
                CornerRadius = UDim.new(0, 8),
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

            -- Section Header
            Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 25),
                Font = Enum.Font.GothamSemibold,
                Text = sectionName,
                TextColor3 = Color3.fromRGB(240, 240, 240),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SectionContent
            })

            function Section:CreateButton(buttonConfig)
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
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -20, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    Font = Enum.Font.Gotham,
                    Text = buttonConfig.Name,
                    TextColor3 = Color3.fromRGB(240, 240, 240),
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Button
                })

                -- Hover Effects
                Button.MouseEnter:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.1), {
                        BackgroundTransparency = 0.2
                    }):Play()
                end)

                Button.MouseLeave:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.1), {
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

            function Section:CreateToggle(toggleConfig)
                local Toggle = Create("Frame", {
                    Name = toggleConfig.Name .. "Toggle",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 35),
                    Parent = SectionContent
                })

                Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.7, 0, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = toggleConfig.Name,
                    TextColor3 = Color3.fromRGB(240, 240, 240),
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Toggle
                })

                local ToggleButton = Create("TextButton", {
                    Name = "Toggle",
                    BackgroundColor3 = Color3.fromRGB(60, 60, 65),
                    Size = UDim2.new(0, 50, 0, 25),
                    Position = UDim2.new(1, -50, 0.5, -12.5),
                    Text = "",
                    Parent = Toggle
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 12),
                    Parent = ToggleButton
                })

                local ToggleKnob = Create("Frame", {
                    Name = "Knob",
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(0, 21, 0, 21),
                    Position = UDim2.new(0, 2, 0.5, -10.5),
                    Parent = ToggleButton
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 10),
                    Parent = ToggleKnob
                })

                local isToggled = toggleConfig.Default or false

                local function updateToggle()
                    if isToggled then
                        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                        }):Play()
                        TweenService:Create(ToggleKnob, TweenInfo.new(0.2), {
                            Position = UDim2.new(0, 27, 0.5, -10.5)
                        }):Play()
                    else
                        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(60, 60, 65)
                        }):Play()
                        TweenService:Create(ToggleKnob, TweenInfo.new(0.2), {
                            Position = UDim2.new(0, 2, 0.5, -10.5)
                        }):Play()
                    end
                    
                    if toggleConfig.Callback then
                        toggleConfig.Callback(isToggled)
                    end
                end

                ToggleButton.MouseButton1Click:Connect(function()
                    isToggled = not isToggled
                    updateToggle()
                end)

                updateToggle()

                return {
                    Set = function(self, value)
                        isToggled = value
                        updateToggle()
                    end,
                    Get = function(self)
                        return isToggled
                    end
                }
            end

            table.insert(Tabs, Section)
            return Section
        end

        table.insert(Tabs, Tab)
        return Tab
    end

    return Window
end

-- Example Usage
local Window = Nebula:CreateWindow({
    Name = "Nebula UI - Premium",
    Size = UDim2.new(0, 550, 0, 450),
    Position = UDim2.new(0.5, -275, 0.5, -225)
})

local MainTab = Window:CreateTab("Main")
local SettingsTab = Window:CreateTab("Settings")

local MainSection = MainTab:CreateSection("Controls")
local InfoSection = MainTab:CreateSection("Information")

MainSection:CreateButton({
    Name = "Test Action",
    Callback = function()
        print("Action executed!")
    end
})

local toggle = MainSection:CreateToggle({
    Name = "Enable Feature",
    Default = false,
    Callback = function(value)
        print("Feature:", value)
    end
})

InfoSection:CreateButton({
    Name = "About Nebula UI",
    Callback = function()
        print("Nebula UI - Smooth and Elegant")
    end
})

return Nebula
