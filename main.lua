--[[
    Nebula UI Library
    Created with precision and elegance
    Version: 1.0.0
]]

local Nebula = {
    Version = "1.0.0",
    Theme = "Dark",
    Accent = Color3.fromRGB(0, 170, 255),
    Transparency = 0.1,
    Enabled = true
}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Local References
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Animation Presets
local AnimationPresets = {
    Smooth = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    Brisk = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Elastic = TweenInfo.new(0.35, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, 0, false, 0)
}

-- Utility Functions
local function Create(class, properties)
    local obj = Instance.new(class)
    for prop, value in pairs(properties) do
        if prop ~= "Parent" then
            obj[prop] = value
        end
    end
    obj.Parent = properties.Parent
    return obj
end

local function RoundCorners(obj, radius)
    local corner = Create("UICorner", {
        CornerRadius = UDim.new(0, radius),
        Parent = obj
    })
    return corner
end

local function CreateStroke(obj, color, thickness)
    local stroke = Create("UIStroke", {
        Color = color,
        Thickness = thickness,
        Parent = obj
    })
    return stroke
end

local function CreateGradient(obj, colors, rotation)
    local gradient = Create("UIGradient", {
        Color = ColorSequence.new(colors),
        Rotation = rotation,
        Parent = obj
    })
    return gradient
end

-- Theme System
local Themes = {
    Dark = {
        Background = Color3.fromRGB(20, 20, 25),
        Secondary = Color3.fromRGB(30, 30, 35),
        Tertiary = Color3.fromRGB(40, 40, 45),
        Text = Color3.fromRGB(240, 240, 240),
        SubText = Color3.fromRGB(180, 180, 180),
        Accent = Color3.fromRGB(0, 170, 255),
        Success = Color3.fromRGB(85, 255, 85),
        Warning = Color3.fromRGB(255, 170, 0),
        Error = Color3.fromRGB(255, 85, 85)
    },
    Light = {
        Background = Color3.fromRGB(245, 245, 245),
        Secondary = Color3.fromRGB(230, 230, 230),
        Tertiary = Color3.fromRGB(210, 210, 210),
        Text = Color3.fromRGB(30, 30, 30),
        SubText = Color3.fromRGB(100, 100, 100),
        Accent = Color3.fromRGB(0, 120, 215),
        Success = Color3.fromRGB(45, 200, 45),
        Warning = Color3.fromRGB(215, 140, 0),
        Error = Color3.fromRGB(215, 45, 45)
    },
    DeepBlue = {
        Background = Color3.fromRGB(15, 20, 35),
        Secondary = Color3.fromRGB(25, 35, 55),
        Tertiary = Color3.fromRGB(35, 50, 75),
        Text = Color3.fromRGB(240, 245, 255),
        SubText = Color3.fromRGB(170, 180, 200),
        Accent = Color3.fromRGB(65, 165, 255),
        Success = Color3.fromRGB(100, 255, 150),
        Warning = Color3.fromRGB(255, 200, 80),
        Error = Color3.fromRGB(255, 100, 120)
    }
}

-- Main UI Container
local NebulaUI = Create("ScreenGui", {
    Name = "NebulaUI",
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = CoreGui
})

-- Notification System
local Notifications = Create("Frame", {
    Name = "Notifications",
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 350, 1, 0),
    Position = UDim2.new(1, -370, 0, 10),
    Parent = NebulaUI
})

Create("UIListLayout", {
    Padding = UDim.new(0, 10),
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    VerticalAlignment = Enum.VerticalAlignment.Top,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = Notifications
})

function Nebula:Notify(title, message, duration, notificationType)
    duration = duration or 5
    notificationType = notificationType or "Info"
    
    local notification = Create("Frame", {
        Name = "Notification",
        BackgroundColor3 = Themes[Nebula.Theme].Secondary,
        BackgroundTransparency = 0.1,
        Size = UDim2.new(0, 340, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true,
        LayoutOrder = 999,
        Parent = Notifications
    })
    
    RoundCorners(notification, 12)
    CreateStroke(notification, Themes[Nebula.Theme].Tertiary, 1)
    
    local glow = Create("ImageLabel", {
        Name = "Glow",
        Image = "rbxassetid://8992235623",
        ImageColor3 = Themes[Nebula.Theme].Accent,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(100, 100, 900, 900),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0, -20, 0, -20),
        ZIndex = 0,
        Parent = notification
    })
    
    local content = Create("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = notification
    })
    
    Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = content
    })
    
    local header = Create("Frame", {
        Name = "Header",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 24),
        LayoutOrder = 1,
        Parent = content
    })
    
    local iconMap = {
        Info = "🔵",
        Success = "✅",
        Warning = "⚠️",
        Error = "❌"
    }
    
    Create("TextLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 24, 1, 0),
        Font = Enum.Font.Gotham,
        Text = iconMap[notificationType],
        TextColor3 = Themes[Nebula.Theme].Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })
    
    Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 30, 0, 0),
        Font = Enum.Font.GothamSemibold,
        Text = title,
        TextColor3 = Themes[Nebula.Theme].Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = header
    })
    
    Create("TextLabel", {
        Name = "Message",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Font = Enum.Font.Gotham,
        Text = message,
        TextColor3 = Themes[Nebula.Theme].SubText,
        TextSize = 13,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 2,
        Parent = content
    })
    
    local progressBar = Create("Frame", {
        Name = "ProgressBar",
        BackgroundColor3 = Themes[Nebula.Theme].Tertiary,
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        LayoutOrder = 3,
        Parent = content
    })
    
    RoundCorners(progressBar, 1)
    
    local progressFill = Create("Frame", {
        Name = "ProgressFill",
        BackgroundColor3 = Themes[Nebula.Theme].Accent,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = progressBar
    })
    
    RoundCorners(progressFill, 1)
    
    -- Entrance animation
    notification.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(notification, AnimationPresets.Elastic, {
        Size = UDim2.new(0, 340, 0, notification.AbsoluteContentSize.Y)
    }):Play()
    
    -- Progress animation
    TweenService:Create(progressFill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 1, 0)
    }):Play()
    
    -- Auto remove
    delay(duration, function()
        TweenService:Create(notification, AnimationPresets.Smooth, {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        wait(0.3)
        notification:Destroy()
    end)
end

-- Window Management
local WindowStack = {}

function Nebula:CreateWindow(config)
    config = config or {}
    
    local Window = {
        Name = config.Name or "Nebula Window",
        Size = config.Size or UDim2.new(0, 550, 0, 400),
        Position = config.Position or UDim2.new(0.5, -275, 0.5, -200),
        MinSize = config.MinSize or UDim2.new(0, 400, 0, 300),
        MaxSize = config.MaxSize or UDim2.new(0, 800, 0, 600),
        Theme = config.Theme or Nebula.Theme,
        Accent = config.Accent or Nebula.Accent
    }
    
    -- Window Container
    local WindowFrame = Create("Frame", {
        Name = Window.Name,
        BackgroundColor3 = Themes[Window.Theme].Background,
        BackgroundTransparency = Nebula.Transparency,
        Size = Window.Size,
        Position = Window.Position,
        ClipsDescendants = true,
        Parent = NebulaUI
    })
    
    RoundCorners(WindowFrame, 14)
    CreateStroke(WindowFrame, Themes[Window.Theme].Tertiary, 1)
    
    -- Background Blur (for depth)
    local blur = Create("ImageLabel", {
        Name = "BackgroundBlur",
        Image = "rbxassetid://8992235623",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.8,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(100, 100, 900, 900),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 60, 1, 60),
        Position = UDim2.new(0, -30, 0, -30),
        ZIndex = 0,
        Parent = WindowFrame
    })
    
    -- Title Bar
    local TitleBar = Create("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = Themes[Window.Theme].Secondary,
        BackgroundTransparency = 0.2,
        Size = UDim2.new(1, 0, 0, 42),
        ClipsDescendants = true,
        Parent = WindowFrame
    })
    
    RoundCorners(TitleBar, 14)
    
    local titleGradient = CreateGradient(TitleBar, {
        Themes[Window.Theme].Secondary,
        Themes[Window.Theme].Secondary,
        Themes[Window.Theme].Tertiary
    }, 90)
    
    -- Window Controls
    local Controls = Create("Frame", {
        Name = "Controls",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 80, 1, 0),
        Position = UDim2.new(1, -85, 0, 0),
        Parent = TitleBar
    })
    
    local function CreateControlButton(name, icon, color)
        local button = Create("TextButton", {
            Name = name,
            BackgroundColor3 = color or Themes[Window.Theme].Tertiary,
            BackgroundTransparency = 0.6,
            Size = UDim2.new(0, 24, 0, 24),
            Position = UDim2.new(0, (name == "Minimize" and 0) or (name == "Maximize" and 28) or 56, 0.5, -12),
            Text = icon,
            TextColor3 = Themes[Window.Theme].Text,
            TextSize = 14,
            Font = Enum.Font.GothamSemibold,
            Parent = Controls
        })
        
        RoundCorners(button, 6)
        
        button.MouseEnter:Connect(function()
            TweenService:Create(button, AnimationPresets.Smooth, {
                BackgroundTransparency = 0.3
            }):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, AnimationPresets.Smooth, {
                BackgroundTransparency = 0.6
            }):Play()
        end)
        
        return button
    end
    
    local minimizeBtn = CreateControlButton("Minimize", "_", Themes[Window.Theme].Warning)
    local maximizeBtn = CreateControlButton("Maximize", "□", Themes[Window.Theme].Success)
    local closeBtn = CreateControlButton("Close", "X", Themes[Window.Theme].Error)
    
    -- Window Title
    Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -90, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        Font = Enum.Font.GothamSemibold,
        Text = Window.Name,
        TextColor3 = Themes[Window.Theme].Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TitleBar
    })
    
    -- Content Area
    local Content = Create("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, -62),
        Position = UDim2.new(0, 10, 0, 52),
        Parent = WindowFrame
    })
    
    -- Tab System
    local TabContainer = Create("Frame", {
        Name = "TabContainer",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = Content
    })
    
    local TabButtons = Create("Frame", {
        Name = "TabButtons",
        BackgroundColor3 = Themes[Window.Theme].Secondary,
        BackgroundTransparency = 0.1,
        Size = UDim2.new(0, 120, 1, 0),
        Parent = TabContainer
    })
    
    RoundCorners(TabButtons, 10)
    CreateStroke(TabButtons, Themes[Window.Theme].Tertiary, 1)
    
    local TabContent = Create("Frame", {
        Name = "TabContent",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -130, 1, 0),
        Position = UDim2.new(0, 130, 0, 0),
        Parent = TabContainer
    })
    
    local Tabs = {}
    local CurrentTab = nil
    
    -- Drag functionality
    local dragging = false
    local dragInput, dragStart, startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = WindowFrame.Position
            
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
            local delta = input.Position - dragStart
            WindowFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Window Controls functionality
    local isMinimized = false
    local originalSize = Window.Size
    local originalPosition = WindowFrame.Position
    
    minimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            TweenService:Create(WindowFrame, AnimationPresets.Smooth, {
                Size = UDim2.new(Window.Size.X.Scale, Window.Size.X.Offset, 0, 42)
            }):Play()
        else
            TweenService:Create(WindowFrame, AnimationPresets.Smooth, {
                Size = originalSize
            }):Play()
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(WindowFrame, AnimationPresets.Smooth, {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        wait(0.3)
        WindowFrame:Destroy()
    end)
    
    -- Tab creation method
    function Window:CreateTab(tabName, tabIcon)
        local Tab = {}
        tabName = tabName or "New Tab"
        tabIcon = tabIcon or "📄"
        
        -- Tab Button
        local TabButton = Create("TextButton", {
            Name = tabName .. "Tab",
            BackgroundColor3 = Themes[Window.Theme].Tertiary,
            BackgroundTransparency = 0.8,
            Size = UDim2.new(1, -10, 0, 40),
            Position = UDim2.new(0, 5, 0, (#Tabs * 45) + 5),
            Text = "",
            Parent = TabButtons
        })
        
        RoundCorners(TabButton, 8)
        
        Create("TextLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 20, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            Font = Enum.Font.Gotham,
            Text = tabIcon,
            TextColor3 = Themes[Window.Theme].SubText,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabButton
        })
        
        Create("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -35, 1, 0),
            Position = UDim2.new(0, 30, 0, 0),
            Font = Enum.Font.Gotham,
            Text = tabName,
            TextColor3 = Themes[Window.Theme].SubText,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabButton
        })
        
        -- Tab Content
        local TabFrame = Create("ScrollingFrame", {
            Name = tabName .. "Content",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarImageColor3 = Themes[Window.Theme].Tertiary,
            ScrollBarThickness = 3,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = TabContent
        })
        
        local TabLayout = Create("UIListLayout", {
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = TabFrame
        })
        
        -- Tab selection
        TabButton.MouseButton1Click:Connect(function()
            if CurrentTab then
                CurrentTab.Visible = false
                -- Reset previous tab button appearance
                for _, btn in pairs(TabButtons:GetChildren()) do
                    if btn:IsA("TextButton") then
                        TweenService:Create(btn, AnimationPresets.Smooth, {
                            BackgroundTransparency = 0.8
                        }):Play()
                        btn:FindFirstChild("Label").TextColor3 = Themes[Window.Theme].SubText
                        btn:FindFirstChild("Icon").TextColor3 = Themes[Window.Theme].SubText
                    end
                end
            end
            
            CurrentTab = TabFrame
            TabFrame.Visible = true
            
            -- Animate active tab button
            TweenService:Create(TabButton, AnimationPresets.Smooth, {
                BackgroundTransparency = 0.3
            }):Play()
            TabButton:FindFirstChild("Label").TextColor3 = Themes[Window.Theme].Accent
            TabButton:FindFirstChild("Icon").TextColor3 = Themes[Window.Theme].Accent
        end)
        
        -- Activate first tab
        if #Tabs == 0 then
            TabButton:FindFirstChild("Label").TextColor3 = Themes[Window.Theme].Accent
            TabButton:FindFirstChild("Icon").TextColor3 = Themes[Window.Theme].Accent
            TweenService:Create(TabButton, AnimationPresets.Smooth, {
                BackgroundTransparency = 0.3
            }):Play()
            TabFrame.Visible = true
            CurrentTab = TabFrame
        end
        
        -- Section creation method
        function Tab:CreateSection(sectionName)
            local Section = {}
            
            local SectionFrame = Create("Frame", {
                Name = sectionName .. "Section",
                BackgroundColor3 = Themes[Window.Theme].Secondary,
                BackgroundTransparency = 0.1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                LayoutOrder = #Tabs + 1,
                Parent = TabFrame
            })
            
            RoundCorners(SectionFrame, 10)
            CreateStroke(SectionFrame, Themes[Window.Theme].Tertiary, 1)
            
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
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = SectionContent
            })
            
            -- Section Header
            local SectionHeader = Create("Frame", {
                Name = "Header",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 24),
                LayoutOrder = 1,
                Parent = SectionContent
            })
            
            Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = sectionName,
                TextColor3 = Themes[Window.Theme].Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SectionHeader
            })
            
            -- Button element
            function Section:CreateButton(buttonConfig)
                buttonConfig = buttonConfig or {}
                
                local Button = Create("TextButton", {
                    Name = buttonConfig.Name .. "Button",
                    BackgroundColor3 = Themes[Window.Theme].Tertiary,
                    BackgroundTransparency = 0.5,
                    Size = UDim2.new(1, 0, 0, 36),
                    Text = "",
                    LayoutOrder = #SectionContent:GetChildren() + 1,
                    Parent = SectionContent
                })
                
                RoundCorners(Button, 8)
                
                local buttonContent = Create("Frame", {
                    Name = "Content",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -20, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    Parent = Button
                })
                
                Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = buttonConfig.Name,
                    TextColor3 = Themes[Window.Theme].Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = buttonContent
                })
                
                -- Hover effects
                Button.MouseEnter:Connect(function()
                    TweenService:Create(Button, AnimationPresets.Smooth, {
                        BackgroundTransparency = 0.2
                    }):Play()
                end)
                
                Button.MouseLeave:Connect(function()
                    TweenService:Create(Button, AnimationPresets.Smooth, {
                        BackgroundTransparency = 0.5
                    }):Play()
                end)
                
                -- Click handler
                Button.MouseButton1Click:Connect(function()
                    if buttonConfig.Callback then
                        buttonConfig.Callback()
                    end
                end)
                
                return Button
            end
            
            -- Toggle element
            function Section:CreateToggle(toggleConfig)
                toggleConfig = toggleConfig or {}
                
                local Toggle = Create("Frame", {
                    Name = toggleConfig.Name .. "Toggle",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 36),
                    LayoutOrder = #SectionContent:GetChildren() + 1,
                    Parent = SectionContent
                })
                
                local label = Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.7, 0, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = toggleConfig.Name,
                    TextColor3 = Themes[Window.Theme].Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Toggle
                })
                
                local toggleButton = Create("TextButton", {
                    Name = "Toggle",
                    BackgroundColor3 = Themes[Window.Theme].Tertiary,
                    Size = UDim2.new(0, 50, 0, 26),
                    Position = UDim2.new(1, -50, 0.5, -13),
                    Text = "",
                    Parent = Toggle
                })
                
                RoundCorners(toggleButton, 13)
                
                local toggleKnob = Create("Frame", {
                    Name = "Knob",
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = UDim2.new(0, 3, 0.5, -10),
                    Parent = toggleButton
                })
                
                RoundCorners(toggleKnob, 10)
                
                local isToggled = toggleConfig.Default or false
                
                local function updateToggle()
                    if isToggled then
                        TweenService:Create(toggleButton, AnimationPresets.Smooth, {
                            BackgroundColor3 = Themes[Window.Theme].Accent
                        }):Play()
                        TweenService:Create(toggleKnob, AnimationPresets.Smooth, {
                            Position = UDim2.new(0, 27, 0.5, -10)
                        }):Play()
                    else
                        TweenService:Create(toggleButton, AnimationPresets.Smooth, {
                            BackgroundColor3 = Themes[Window.Theme].Tertiary
                        }):Play()
                        TweenService:Create(toggleKnob, AnimationPresets.Smooth, {
                            Position = UDim2.new(0, 3, 0.5, -10)
                        }):Play()
                    end
                    
                    if toggleConfig.Callback then
                        toggleConfig.Callback(isToggled)
                    end
                end
                
                toggleButton.MouseButton1Click:Connect(function()
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
            
            -- Slider element
            function Section:CreateSlider(sliderConfig)
                sliderConfig = sliderConfig or {}
                
                local Slider = Create("Frame", {
                    Name = sliderConfig.Name .. "Slider",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 50),
                    LayoutOrder = #SectionContent:GetChildren() + 1,
                    Parent = SectionContent
                })
                
                local topRow = Create("Frame", {
                    Name = "TopRow",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    Parent = Slider
                })
                
                Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.7, 0, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = sliderConfig.Name,
                    TextColor3 = Themes[Window.Theme].Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = topRow
                })
                
                local valueLabel = Create("TextLabel", {
                    Name = "Value",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.3, 0, 1, 0),
                    Position = UDim2.new(0.7, 0, 0, 0),
                    Font = Enum.Font.Gotham,
                    Text = tostring(sliderConfig.Default or sliderConfig.Min or 0),
                    TextColor3 = Themes[Window.Theme].SubText,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = topRow
                })
                
                local sliderTrack = Create("Frame", {
                    Name = "Track",
                    BackgroundColor3 = Themes[Window.Theme].Tertiary,
                    Size = UDim2.new(1, 0, 0, 6),
                    Position = UDim2.new(0, 0, 1, -16),
                    Parent = Slider
                })
                
                RoundCorners(sliderTrack, 3)
                
                local sliderFill = Create("Frame", {
                    Name = "Fill",
                    BackgroundColor3 = Themes[Window.Theme].Accent,
                    Size = UDim2.new(0, 0, 1, 0),
                    Parent = sliderTrack
                })
                
                RoundCorners(sliderFill, 3)
                
                local sliderKnob = Create("Frame", {
                    Name = "Knob",
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(0, 0, 0.5, -8),
                    Parent = sliderTrack
                })
                
                RoundCorners(sliderKnob, 8)
                CreateStroke(sliderKnob, Themes[Window.Theme].Tertiary, 1)
                
                local min = sliderConfig.Min or 0
                local max = sliderConfig.Max or 100
                local current = sliderConfig.Default or min
                local dragging = false
                
                local function updateSlider(value)
                    current = math.clamp(value, min, max)
                    local percentage = (current - min) / (max - min)
                    
                    valueLabel.Text = tostring(math.floor(current))
                    sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                    sliderKnob.Position = UDim2.new(percentage, -8, 0.5, -8)
                    
                    if sliderConfig.Callback then
                        sliderConfig.Callback(current)
                    end
                end
                
                local function inputChanged(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local relativeX = (input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X
                        local value = min + (relativeX * (max - min))
                        updateSlider(value)
                    end
                end
                
                sliderKnob.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                    end
                end)
                
                sliderKnob.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                sliderTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        local relativeX = (input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X
                        local value = min + (relativeX * (max - min))
                        updateSlider(value)
                    end
                end)
                
                UserInputService.InputChanged:Connect(inputChanged)
                
                updateSlider(current)
                
                return {
                    Set = function(self, value)
                        updateSlider(value)
                    end,
                    Get = function(self)
                        return current
                    end
                }
            end
            
            -- Dropdown element
            function Section:CreateDropdown(dropdownConfig)
                dropdownConfig = dropdownConfig or {}
                
                local Dropdown = Create("Frame", {
                    Name = dropdownConfig.Name .. "Dropdown",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 36),
                    LayoutOrder = #SectionContent:GetChildren() + 1,
                    Parent = SectionContent
                })
                
                local dropdownButton = Create("TextButton", {
                    Name = "DropdownButton",
                    BackgroundColor3 = Themes[Window.Theme].Tertiary,
                    BackgroundTransparency = 0.5,
                    Size = UDim2.new(1, 0, 0, 36),
                    Text = "",
                    Parent = Dropdown
                })
                
                RoundCorners(dropdownButton, 8)
                
                local buttonContent = Create("Frame", {
                    Name = "Content",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -40, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    Parent = dropdownButton
                })
                
                Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = dropdownConfig.Name,
                    TextColor3 = Themes[Window.Theme].Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = buttonContent
                })
                
                Create("TextLabel", {
                    Name = "Value",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Position = UDim2.new(0.5, 0, 0, 0),
                    Font = Enum.Font.Gotham,
                    Text = dropdownConfig.Default or dropdownConfig.Options[1] or "",
                    TextColor3 = Themes[Window.Theme].SubText,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = buttonContent
                })
                
                local dropdownArrow = Create("ImageLabel", {
                    Name = "Arrow",
                    Image = "rbxassetid://6031090990",
                    ImageColor3 = Themes[Window.Theme].SubText,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(1, -25, 0.5, -8),
                    Rotation = 0,
                    Parent = dropdownButton
                })
                
                local optionsFrame = Create("Frame", {
                    Name = "Options",
                    BackgroundColor3 = Themes[Window.Theme].Tertiary,
                    BackgroundTransparency = 0.1,
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 1, 5),
                    ClipsDescendants = true,
                    Visible = false,
                    Parent = Dropdown
                })
                
                RoundCorners(optionsFrame, 8)
                CreateStroke(optionsFrame, Themes[Window.Theme].Secondary, 1)
                
                local optionsLayout = Create("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = optionsFrame
                })
                
                local isOpen = false
                local selected = dropdownConfig.Default or dropdownConfig.Options[1]
                local options = {}
                
                local function updateDropdown()
                    dropdownButton:FindFirstChild("Content").Value.Text = selected
                    if dropdownConfig.Callback then
                        dropdownConfig.Callback(selected)
                    end
                end
                
                local function toggleDropdown()
                    isOpen = not isOpen
                    optionsFrame.Visible = isOpen
                    
                    if isOpen then
                        TweenService:Create(dropdownArrow, AnimationPresets.Smooth, {
                            Rotation = 180
                        }):Play()
                        TweenService:Create(optionsFrame, AnimationPresets.Smooth, {
                            Size = UDim2.new(1, 0, 0, math.min(#dropdownConfig.Options * 32, 160))
                        }):Play()
                    else
                        TweenService:Create(dropdownArrow, AnimationPresets.Smooth, {
                            Rotation = 0
                        }):Play()
                        TweenService:Create(optionsFrame, AnimationPresets.Smooth, {
                            Size = UDim2.new(1, 0, 0, 0)
                        }):Play()
                    end
                end
                
                for i, option in ipairs(dropdownConfig.Options or {}) do
                    local optionButton = Create("TextButton", {
                        Name = option .. "Option",
                        BackgroundColor3 = Themes[Window.Theme].Secondary,
                        BackgroundTransparency = 0.8,
                        Size = UDim2.new(1, -10, 0, 30),
                        Position = UDim2.new(0, 5, 0, (i-1)*32 + 5),
                        Text = option,
                        TextColor3 = Themes[Window.Theme].Text,
                        TextSize = 12,
                        LayoutOrder = i,
                        Parent = optionsFrame
                    })
                    
                    RoundCorners(optionButton, 6)
                    
                    optionButton.MouseButton1Click:Connect(function()
                        selected = option
                        updateDropdown()
                        toggleDropdown()
                    end)
                    
                    optionButton.MouseEnter:Connect(function()
                        TweenService:Create(optionButton, AnimationPresets.Smooth, {
                            BackgroundTransparency = 0.6
                        }):Play()
                    end)
                    
                    optionButton.MouseLeave:Connect(function()
                        TweenService:Create(optionButton, AnimationPresets.Smooth, {
                            BackgroundTransparency = 0.8
                        }):Play()
                    end)
                end
                
                dropdownButton.MouseButton1Click:Connect(toggleDropdown)
                updateDropdown()
                
                return {
                    Set = function(self, value)
                        if table.find(dropdownConfig.Options, value) then
                            selected = value
                            updateDropdown()
                        end
                    end,
                    Get = function(self)
                        return selected
                    end
                }
            end
            
            table.insert(Tabs, Tab)
            return Section
        end
        
        table.insert(Tabs, Tab)
        return Tab
    end
    
    table.insert(WindowStack, Window)
    return Window
end

-- Keybind System
local KeybindHandler = {
    ActiveKeybinds = {}
}

function Nebula:RegisterKeybind(key, callback)
    local connection
    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == key then
            callback()
        end
    end)
    
    KeybindHandler.ActiveKeybinds[key] = connection
    return connection
end

-- Initialize Nebula UI
function Nebula:Init()
    self:Notify("Nebula UI", "UI Library initialized successfully!", 3, "Success")
    
    -- Register toggle keybind (RightShift to hide/show)
    self:RegisterKeybind(Enum.KeyCode.RightShift, function()
        Nebula.Enabled = not Nebula.Enabled
        for _, window in pairs(NebulaUI:GetChildren()) do
            if window:IsA("Frame") then
                window.Visible = Nebula.Enabled
            end
        end
        self:Notify("Nebula UI", Nebula.Enabled and "UI Enabled" or "UI Disabled", 2, "Info")
    end)
end

-- Demo Window Creation (Example Usage)
local demoWindow = Nebula:CreateWindow({
    Name = "Nebula UI Demo",
    Size = UDim2.new(0, 600, 0, 500),
    Position = UDim2.new(0.5, -300, 0.5, -250),
    Theme = "Dark"
})

local mainTab = demoWindow:CreateTab("Main", "🏠")
local settingsTab = demoWindow:CreateTab("Settings", "⚙️")

local mainSection = mainTab:CreateSection("Controls")
local infoSection = mainTab:CreateSection("Information")

mainSection:CreateButton({
    Name = "Test Button",
    Callback = function()
        Nebula:Notify("Button Clicked", "You clicked the test button!", 3, "Success")
    end
})

local toggle = mainSection:CreateToggle({
    Name = "Enable Feature",
    Default = false,
    Callback = function(value)
        Nebula:Notify("Toggle", "Feature " .. (value and "enabled" or "disabled"), 2, "Info")
    end
})

local slider = mainSection:CreateSlider({
    Name = "Volume",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Volume set to:", value)
    end
})

local dropdown = mainSection:CreateDropdown({
    Name = "Quality",
    Options = {"Low", "Medium", "High", "Ultra"},
    Default = "Medium",
    Callback = function(value)
        Nebula:Notify("Quality", "Set to " .. value, 2, "Info")
    end
})

infoSection:CreateButton({
    Name = "Show Info",
    Callback = function()
        Nebula:Notify("Nebula UI", "Version: " .. Nebula.Version, 5, "Info")
    end
})

-- Initialize the UI
Nebula:Init()

return Nebula
