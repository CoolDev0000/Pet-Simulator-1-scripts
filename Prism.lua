--[[
    PrismUI v1.1 — single-file GUI library (fully reworked layout)
]]

--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--// Executor
local function GetParent()
    if gethui then return gethui() end
    return CoreGui
end

local function Protect(gui)
    if syn and syn.protect_gui then syn.protect_gui(gui) end
    if gethui then gui.Parent = gethui() end
end

--// Theme
local Theme = {
    Background = Color3.fromRGB(10, 10, 16),
    Surface = Color3.fromRGB(16, 16, 26),
    SurfaceHover = Color3.fromRGB(24, 24, 38),
    Card = Color3.fromRGB(20, 20, 32),
    Border = Color3.fromRGB(38, 38, 58),
    Accent = Color3.fromRGB(108, 92, 231),
    Accent2 = Color3.fromRGB(0, 210, 255),
    Text = Color3.fromRGB(245, 245, 250),
    TextDim = Color3.fromRGB(130, 130, 155),
    Success = Color3.fromRGB(46, 213, 115),
    Warning = Color3.fromRGB(255, 184, 0),
    Error = Color3.fromRGB(255, 71, 87),
    ToggleOff = Color3.fromRGB(48, 48, 68),
    ToggleOn = Color3.fromRGB(108, 92, 231),
    Font = Enum.Font.GothamMedium,
    FontBold = Enum.Font.GothamBold,
    FontLight = Enum.Font.Gotham,
    Corner = UDim.new(0, 10),
    CornerSm = UDim.new(0, 6),
    TweenFast = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    TweenMed = TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
}

local Prism = {}
Prism.Version = "1.1.0"
Prism.Theme = Theme
Prism.LoadDemo = true

local function Tween(obj, props, info)
    return TweenService:Create(obj, info or Theme.TweenMed, props)
end

local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then inst[k] = v end
    end
    if props and props.Parent then inst.Parent = props.Parent end
    return inst
end

local function Corner(parent, radius)
    return Create("UICorner", { CornerRadius = radius or Theme.Corner, Parent = parent })
end

local function Stroke(parent, color, thickness)
    return Create("UIStroke", {
        Color = color or Theme.Border,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent,
    })
end

local function Pad(parent, top, right, bottom, left)
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, top or 0),
        PaddingRight = UDim.new(0, right or top or 0),
        PaddingBottom = UDim.new(0, bottom or top or 0),
        PaddingLeft = UDim.new(0, left or right or top or 0),
        Parent = parent,
    })
end

local function VList(parent, gap)
    return Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, gap or 8),
        Parent = parent,
    })
end

local function HList(parent, gap, valign)
    return Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, gap or 8),
        VerticalAlignment = valign or Enum.VerticalAlignment.Center,
        Parent = parent,
    })
end

local function Gradient(parent, c1, c2, rot)
    return Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, c1 or Theme.Accent),
            ColorSequenceKeypoint.new(1, c2 or Theme.Accent2),
        }),
        Rotation = rot or 35,
        Parent = parent,
    })
end

local function Hover(btn, normal, hover)
    local n = normal or Theme.Surface
    local h = hover or Theme.SurfaceHover
    btn.MouseEnter:Connect(function()
        Tween(btn, { BackgroundColor3 = h }, Theme.TweenFast):Play()
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn, { BackgroundColor3 = n }, Theme.TweenFast):Play()
    end)
end

local function Drag(frame, handle)
    local dragging, start, origin = false, nil, nil
    handle = handle or frame
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            start = input.Position
            origin = frame.Position
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local d = input.Position - start
            frame.Position = UDim2.new(origin.X.Scale, origin.X.Offset + d.X, origin.Y.Scale, origin.Y.Offset + d.Y)
        end
    end)
end

local function Ripple(btn)
    btn.ClipsDescendants = true
    btn.MouseButton1Click:Connect(function()
        local r = Create("Frame", {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 0.65,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(Mouse.X - btn.AbsolutePosition.X, Mouse.Y - btn.AbsolutePosition.Y),
            Size = UDim2.fromOffset(4, 4),
            ZIndex = (btn.ZIndex or 1) + 3,
            Parent = btn,
        })
        Corner(r, UDim.new(1, 0))
        local s = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 2.2
        Tween(r, { Size = UDim2.fromOffset(s, s), BackgroundTransparency = 1 }, TweenInfo.new(0.45)):Play()
        task.delay(0.5, function() if r.Parent then r:Destroy() end end)
    end)
end

--// Notifications (holder in Lua — Roblox Instances cannot use custom ._ fields)
local NotifGui
local NotifList

local function GetNotifGui()
    if NotifGui and NotifGui.Parent and NotifList and NotifList.Parent then
        return NotifGui, NotifList
    end
    NotifGui = Create("ScreenGui", {
        Name = "PrismNotifications",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100,
        Parent = GetParent(),
    })
    Protect(NotifGui)
    NotifList = Create("Frame", {
        Name = "List",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -20, 0, 20),
        Size = UDim2.fromOffset(300, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = NotifGui,
    })
    VList(NotifList, 10)
    return NotifGui, NotifList
end

function Prism:Notify(opts)
    opts = opts or {}
    local title = opts.Title or "Notice"
    local content = opts.Content or ""
    local duration = opts.Duration or 4
    local kind = opts.Type or "Info"
    local accent = ({ Info = Theme.Accent, Success = Theme.Success, Warning = Theme.Warning, Error = Theme.Error })[kind] or Theme.Accent

    local _, holder = GetNotifGui()

    local card = Create("Frame", {
        BackgroundColor3 = Theme.Card,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true,
        LayoutOrder = tick(),
        Parent = holder,
    })
    Corner(card)
    Stroke(card)
    Pad(card, 12, 14, 12, 20)

    Create("Frame", {
        BackgroundColor3 = accent,
        Size = UDim2.new(0, 3, 1, -8),
        Position = UDim2.new(0, -16, 0, 4),
        BorderSizePixel = 0,
        Parent = card,
    })

    local inner = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = card,
    })
    VList(inner, 4)

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Font = Theme.FontBold,
        Text = title,
        TextColor3 = Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, 0, 0, 18),
        LayoutOrder = 1,
        Parent = inner,
    })
    if content ~= "" then
        Create("TextLabel", {
            BackgroundTransparency = 1,
            Font = Theme.FontLight,
            Text = content,
            TextColor3 = Theme.TextDim,
            TextSize = 12,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutomaticSize = Enum.AutomaticSize.Y,
            Size = UDim2.new(1, 0, 0, 0),
            LayoutOrder = 2,
            Parent = inner,
        })
    end

    card.BackgroundTransparency = 1
    Tween(card, { BackgroundTransparency = 0 }, Theme.TweenFast):Play()

    task.delay(duration, function()
        if not card.Parent then return end
        local tw = Tween(card, { BackgroundTransparency = 1 }, Theme.TweenMed)
        tw:Play()
        tw.Completed:Wait()
        card:Destroy()
    end)
end

--// Root
local RootGui

local function GetRoot()
    if RootGui and RootGui.Parent then return RootGui end
    RootGui = Create("ScreenGui", {
        Name = "PrismUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 50,
        Parent = GetParent(),
    })
    Protect(RootGui)
    return RootGui
end

function Prism:Destroy()
    if RootGui then RootGui:Destroy() RootGui = nil end
    if NotifGui then NotifGui:Destroy() NotifGui = nil end
    NotifList = nil
end

function Prism:SetTheme(t)
    for k, v in pairs(t or {}) do Theme[k] = v end
end

--// Window
function Prism:CreateWindow(opts)
    opts = opts or {}
    local title = opts.Name or "Prism UI"
    local subtitle = opts.Subtitle or ""
    local winSize = opts.Size or Vector2.new(620, 440)
    local toggleKey = opts.Keybind or Enum.KeyCode.RightControl

    GetRoot()

    local tabs = {}
    local activeTab = nil
    local minimized = false

    -- Main window
    local win = Create("Frame", {
        Name = "PrismWindow",
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(winSize.X, winSize.Y),
        Position = UDim2.new(0.5, -winSize.X / 2, 0.5, -winSize.Y / 2),
        ClipsDescendants = true,
        Parent = RootGui,
    })
    Corner(win, UDim.new(0, 12))
    Stroke(win, Theme.Border, 1)

    local accentBar = Create("Frame", {
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 2),
        Parent = win,
    })
    Gradient(accentBar, Theme.Accent, Theme.Accent2, 0)

    -- Title bar (fixed height, no list overlap)
    local titleBar = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 48),
        Position = UDim2.new(0, 0, 0, 2),
        Parent = win,
    })

    local titleText = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 16, 0, 0),
        Parent = titleBar,
    })
    VList(titleText, 0)

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Font = Theme.FontBold,
        Text = title,
        TextColor3 = Theme.Text,
        TextSize = 17,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, 0, 0, 22),
        LayoutOrder = 1,
        Parent = titleText,
    })
    if subtitle ~= "" then
        Create("TextLabel", {
            BackgroundTransparency = 1,
            Font = Theme.FontLight,
            Text = subtitle,
            TextColor3 = Theme.TextDim,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1, 0, 0, 14),
            LayoutOrder = 2,
            Parent = titleText,
        })
    end

    local btnHolder = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(68, 28),
        Position = UDim2.new(1, -80, 0, 10),
        Parent = titleBar,
    })
    HList(btnHolder, 8)

    local function WinBtn(text, col)
        local b = Create("TextButton", {
            BackgroundColor3 = Theme.Surface,
            Text = text,
            Font = Theme.FontBold,
            TextColor3 = Theme.TextDim,
            TextSize = 15,
            Size = UDim2.fromOffset(28, 28),
            AutoButtonColor = false,
            Parent = btnHolder,
        })
        Corner(b, Theme.CornerSm)
        Hover(b, Theme.Surface, Theme.SurfaceHover)
        return b
    end

    local minBtn = WinBtn("−")
    local closeBtn = WinBtn("×")

    local body = Create("Frame", {
        Name = "Body",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -24, 1, -62),
        Position = UDim2.new(0, 12, 0, 54),
        Parent = win,
    })

    -- Sidebar
    local SIDEBAR_W = 130
    local sidebar = Create("Frame", {
        BackgroundColor3 = Theme.Surface,
        Size = UDim2.new(0, SIDEBAR_W, 1, 0),
        Parent = body,
    })
    Corner(sidebar)
    Stroke(sidebar)
    Pad(sidebar, 8, 6, 8, 10)

    local tabIndicator = Create("Frame", {
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 3, 0, 34),
        Position = UDim2.new(0, 2, 0, 8),
        ZIndex = 2,
        Parent = sidebar,
    })
    Corner(tabIndicator, UDim.new(0, 2))
    Gradient(tabIndicator)

    local tabButtons = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 3,
        Parent = sidebar,
    })
    VList(tabButtons, 4)

    -- Content (overlay pages — NOT stacked in one list)
    local content = Create("Frame", {
        BackgroundColor3 = Theme.Surface,
        Size = UDim2.new(1, -(SIDEBAR_W + 10), 1, 0),
        Position = UDim2.new(0, SIDEBAR_W + 10, 0, 0),
        ClipsDescendants = true,
        Parent = body,
    })
    Corner(content)
    Stroke(content)

    local pagesHost = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = content,
    })

    local function MoveIndicator(btn)
        task.defer(function()
            if not btn or not btn.Parent then return end
            local y = btn.AbsolutePosition.Y - sidebar.AbsolutePosition.Y
            local h = btn.AbsoluteSize.Y
            Tween(tabIndicator, {
                Position = UDim2.new(0, 2, 0, y),
                Size = UDim2.new(0, 3, 0, h),
            }, Theme.TweenFast):Play()
        end)
    end

    local function SelectTab(data)
        for _, t in ipairs(tabs) do
            t.Page.Visible = false
            Tween(t.Button, {
                BackgroundTransparency = 1,
                BackgroundColor3 = Theme.Card,
            }, Theme.TweenFast):Play()
            Tween(t.Title, { TextColor3 = Theme.TextDim }, Theme.TweenFast):Play()
            Tween(t.Icon, { TextColor3 = Theme.TextDim }, Theme.TweenFast):Play()
        end
        data.Page.Visible = true
        activeTab = data
        Tween(data.Button, { BackgroundTransparency = 0, BackgroundColor3 = Theme.Card }, Theme.TweenFast):Play()
        Tween(data.Title, { TextColor3 = Theme.Text }, Theme.TweenFast):Play()
        Tween(data.Icon, { TextColor3 = Theme.Accent }, Theme.TweenFast):Play()
        MoveIndicator(data.Button)
    end

    local window = { _Win = win }

    function window:SelectTabByName(name)
        for _, t in ipairs(tabs) do
            if t.Name == name then SelectTab(t) return end
        end
    end

    function window:Tab(name, icon)
        icon = icon or "•"

        -- Page: full-size overlay + own scroll
        local page = Create("Frame", {
            Name = name .. "_Page",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            ZIndex = 1,
            Parent = pagesHost,
        })

        local pageScroll = Create("ScrollingFrame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Parent = page,
        })
        Pad(pageScroll, 12, 12, 12, 12)

        local pageContent = Create("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = pageScroll,
        })
        VList(pageContent, 14)

        -- Tab button (fixed layout: icon box + title)
        local isFirst = #tabs == 0
        local tabBtn = Create("TextButton", {
            BackgroundColor3 = Theme.Card,
            BackgroundTransparency = isFirst and 0 or 1,
            Text = "",
            Size = UDim2.new(1, 0, 0, 36),
            AutoButtonColor = false,
            Parent = tabButtons,
        })
        Corner(tabBtn, Theme.CornerSm)

        local tabRow = Create("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -12, 1, 0),
            Position = UDim2.new(0, 6, 0, 0),
            Parent = tabBtn,
        })
        HList(tabRow, 8, Enum.VerticalAlignment.Center)

        local iconLbl = Create("TextLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Font = Theme.FontBold,
            Text = icon,
            TextColor3 = isFirst and Theme.Accent or Theme.TextDim,
            TextSize = 14,
            TextYAlignment = Enum.TextYAlignment.Center,
            Size = UDim2.fromOffset(22, 36),
            LayoutOrder = 1,
            Parent = tabRow,
        })

        local titleLbl = Create("TextLabel", {
            Name = "Title",
            BackgroundTransparency = 1,
            Font = Theme.Font,
            Text = name,
            TextColor3 = isFirst and Theme.Text or Theme.TextDim,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            Size = UDim2.new(1, -30, 0, 36),
            LayoutOrder = 2,
            Parent = tabRow,
        })

        local tabData = {
            Name = name,
            Page = page,
            Scroll = pageScroll,
            Content = pageContent,
            Button = tabBtn,
            Icon = iconLbl,
            Title = titleLbl,
        }
        table.insert(tabs, tabData)

        tabBtn.MouseButton1Click:Connect(function()
            SelectTab(tabData)
        end)

        if isFirst then
            page.Visible = true
            activeTab = tabData
            task.defer(function() MoveIndicator(tabBtn) end)
        end

        -- Section builder
        local tabAPI = {}

        function tabAPI:Section(sectionName)
            local block = Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = pageContent,
            })
            VList(block, 6)

            Create("TextLabel", {
                BackgroundTransparency = 1,
                Font = Theme.FontBold,
                Text = string.upper(sectionName),
                TextColor3 = Theme.TextDim,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2.new(1, 0, 0, 16),
                LayoutOrder = 1,
                Parent = block,
            })

            local box = Create("Frame", {
                BackgroundColor3 = Theme.Card,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                LayoutOrder = 2,
                Parent = block,
            })
            Corner(box)
            Stroke(box)
            Pad(box, 8, 10, 8, 10)
            VList(box, 4)

            local api = {}

            function api:Label(text)
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = Theme.FontLight,
                    Text = text,
                    TextColor3 = Theme.TextDim,
                    TextSize = 12,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Size = UDim2.new(1, 0, 0, 0),
                    Parent = box,
                })
            end

            function api:Button(text, callback)
                local b = Create("TextButton", {
                    BackgroundColor3 = Theme.Accent,
                    Text = text,
                    Font = Theme.FontBold,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    Size = UDim2.new(1, 0, 0, 36),
                    AutoButtonColor = false,
                    Parent = box,
                })
                Corner(b, Theme.CornerSm)
                Gradient(b)
                Ripple(b)
                b.MouseButton1Click:Connect(function()
                    if callback then callback() end
                end)
            end

            function api:Toggle(label, default, callback)
                local on = default == true
                local row = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 38),
                    Parent = box,
                })

                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = Theme.Font,
                    Text = label,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Center,
                    Size = UDim2.new(1, -54, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    Parent = row,
                })

                local track = Create("TextButton", {
                    BackgroundColor3 = on and Theme.ToggleOn or Theme.ToggleOff,
                    Text = "",
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    Size = UDim2.fromOffset(46, 24),
                    AutoButtonColor = false,
                    Parent = row,
                })
                Corner(track, UDim.new(1, 0))

                local knob = Create("Frame", {
                    BackgroundColor3 = Theme.Text,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = on and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                    Size = UDim2.fromOffset(18, 18),
                    Parent = track,
                })
                Corner(knob, UDim.new(1, 0))

                local function set(v, fire)
                    on = v
                    Tween(track, { BackgroundColor3 = on and Theme.ToggleOn or Theme.ToggleOff }, Theme.TweenFast):Play()
                    Tween(knob, {
                        Position = on and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                    }, Theme.TweenFast):Play()
                    if fire and callback then callback(on) end
                end

                track.MouseButton1Click:Connect(function()
                    set(not on, true)
                end)
                if on and callback then callback(true) end
            end

            function api:Slider(label, min, max, default, callback)
                min = min or 0
                max = max or 100
                default = math.clamp(default or min, min, max)
                local val = default

                local wrap = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 50),
                    Parent = box,
                })
                VList(wrap, 6)

                local head = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 18),
                    LayoutOrder = 1,
                    Parent = wrap,
                })

                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = Theme.Font,
                    Text = label,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, -36, 1, 0),
                    Parent = head,
                })

                local num = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = Theme.FontBold,
                    Text = tostring(val),
                    TextColor3 = Theme.Accent2,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Size = UDim2.fromOffset(36, 18),
                    Position = UDim2.new(1, -36, 0, 0),
                    Parent = head,
                })

                local track = Create("TextButton", {
                    BackgroundColor3 = Theme.ToggleOff,
                    Text = "",
                    Size = UDim2.new(1, 0, 0, 10),
                    AutoButtonColor = false,
                    LayoutOrder = 2,
                    Parent = wrap,
                })
                Corner(track, UDim.new(1, 0))

                local fill = Create("Frame", {
                    BackgroundColor3 = Theme.Accent,
                    Size = UDim2.new((val - min) / math.max(max - min, 1), 0, 1, 0),
                    BorderSizePixel = 0,
                    Parent = track,
                })
                Corner(fill, UDim.new(1, 0))
                Gradient(fill)

                local drag = false
                local function setFromX(x, fire)
                    local rel = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
                    val = math.floor(min + (max - min) * rel + 0.5)
                    num.Text = tostring(val)
                    Tween(fill, { Size = UDim2.new(rel, 0, 1, 0) }, Theme.TweenFast):Play()
                    if fire and callback then callback(val) end
                end

                track.MouseButton1Down:Connect(function()
                    drag = true
                    setFromX(Mouse.X, true)
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
                        setFromX(Mouse.X, true)
                    end
                end)
            end

            function api:Dropdown(label, options, default, callback)
                options = options or {}
                local pick = default or options[1] or "—"
                local opened = false

                local wrap = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Parent = box,
                })
                VList(wrap, 4)

                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = Theme.Font,
                    Text = label,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 0, 16),
                    LayoutOrder = 1,
                    Parent = wrap,
                })

                local drop = Create("TextButton", {
                    BackgroundColor3 = Theme.Surface,
                    Text = pick,
                    Font = Theme.Font,
                    TextColor3 = Theme.Text,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 0, 32),
                    AutoButtonColor = false,
                    LayoutOrder = 2,
                    Parent = wrap,
                })
                Corner(drop, Theme.CornerSm)
                Stroke(drop)
                Pad(drop, 0, 28, 0, 10)

                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = Theme.Font,
                    Text = "▼",
                    TextColor3 = Theme.TextDim,
                    TextSize = 10,
                    Size = UDim2.fromOffset(20, 32),
                    Position = UDim2.new(1, -24, 0, 0),
                    Parent = drop,
                })

                local menu = Create("Frame", {
                    BackgroundColor3 = Theme.Surface,
                    Size = UDim2.new(1, 0, 0, 0),
                    ClipsDescendants = true,
                    Visible = false,
                    LayoutOrder = 3,
                    ZIndex = 20,
                    Parent = wrap,
                })
                Corner(menu, Theme.CornerSm)
                Stroke(menu)
                Pad(menu, 4, 4, 4, 4)
                VList(menu, 2)

                local function closeMenu()
                    opened = false
                    Tween(menu, { Size = UDim2.new(1, 0, 0, 0) }, Theme.TweenFast):Play()
                    task.delay(0.2, function()
                        menu.Visible = false
                    end)
                end

                local function openMenu()
                    for _, c in ipairs(menu:GetChildren()) do
                        if c:IsA("GuiObject") and c.Name ~= "UIListLayout" and c.Name ~= "UIPadding" then
                            c:Destroy()
                        end
                    end
                    for i, opt in ipairs(options) do
                        local ob = Create("TextButton", {
                            BackgroundColor3 = Theme.Card,
                            BackgroundTransparency = 0,
                            Text = opt,
                            Font = Theme.Font,
                            TextColor3 = Theme.Text,
                            TextSize = 12,
                            Size = UDim2.new(1, 0, 0, 28),
                            AutoButtonColor = false,
                            LayoutOrder = i,
                            Parent = menu,
                        })
                        Corner(ob, Theme.CornerSm)
                        Hover(ob, Theme.Card, Theme.SurfaceHover)
                        ob.MouseButton1Click:Connect(function()
                            pick = opt
                            drop.Text = opt
                            closeMenu()
                            if callback then callback(opt) end
                        end)
                    end
                    menu.Visible = true
                    opened = true
                    local h = #options * 30 + 8
                    Tween(menu, { Size = UDim2.new(1, 0, 0, h) }, Theme.TweenFast):Play()
                end

                drop.MouseButton1Click:Connect(function()
                    if opened then closeMenu() else openMenu() end
                end)
            end

            function api:Input(label, placeholder, callback)
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = Theme.Font,
                    Text = label,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 0, 16),
                    Parent = box,
                })
                local field = Create("TextBox", {
                    BackgroundColor3 = Theme.Surface,
                    PlaceholderText = placeholder or "Enter text...",
                    PlaceholderColor3 = Theme.TextDim,
                    Text = "",
                    Font = Theme.Font,
                    TextColor3 = Theme.Text,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ClearTextOnFocus = false,
                    Size = UDim2.new(1, 0, 0, 34),
                    Parent = box,
                })
                Corner(field, Theme.CornerSm)
                Stroke(field)
                Pad(field, 0, 10, 0, 10)
                field.FocusLost:Connect(function(enter)
                    if enter and callback then callback(field.Text) end
                end)
            end

            function api:Keybind(label, defaultKey, callback)
                local key = defaultKey or Enum.KeyCode.E
                local listen = false

                local row = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 38),
                    Parent = box,
                })

                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = Theme.Font,
                    Text = label,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Center,
                    Size = UDim2.new(1, -88, 1, 0),
                    Parent = row,
                })

                local kb = Create("TextButton", {
                    BackgroundColor3 = Theme.Surface,
                    Text = key.Name,
                    Font = Theme.FontBold,
                    TextColor3 = Theme.Accent2,
                    TextSize = 11,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    Size = UDim2.fromOffset(80, 28),
                    AutoButtonColor = false,
                    Parent = row,
                })
                Corner(kb, Theme.CornerSm)
                Stroke(kb)

                kb.MouseButton1Click:Connect(function()
                    listen = true
                    kb.Text = "..."
                end)

                local conn
                conn = UserInputService.InputBegan:Connect(function(input, gpe)
                    if not listen or gpe then return end
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        key = input.KeyCode
                        kb.Text = key.Name
                        listen = false
                        if callback then callback(key) end
                    end
                end)
            end

            function api:ColorPicker(label, defaultColor, callback)
                local col = defaultColor or Theme.Accent

                local row = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 38),
                    Parent = box,
                })

                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = Theme.Font,
                    Text = label,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Center,
                    Size = UDim2.new(1, -44, 1, 0),
                    Parent = row,
                })

                local swatch = Create("TextButton", {
                    BackgroundColor3 = col,
                    Text = "",
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    Size = UDim2.fromOffset(34, 28),
                    AutoButtonColor = false,
                    ZIndex = 5,
                    Parent = row,
                })
                Corner(swatch, Theme.CornerSm)
                Stroke(swatch, Theme.Border, 2)

                swatch.MouseButton1Click:Connect(function()
                    if row:FindFirstChild("ColorPopup") then return end
                    local pop = Create("Frame", {
                        Name = "ColorPopup",
                        BackgroundColor3 = Theme.Card,
                        Size = UDim2.new(1, 0, 0, 36),
                        Position = UDim2.new(0, 0, 1, 6),
                        ZIndex = 30,
                        Parent = row,
                    })
                    Corner(pop)
                    Stroke(pop)
                    Pad(pop, 10, 10, 10, 10)

                    local bar = Create("TextButton", {
                        BackgroundColor3 = Color3.new(1, 1, 1),
                        Text = "",
                        Size = UDim2.new(1, 0, 0, 14),
                        AutoButtonColor = false,
                        Parent = pop,
                    })
                    Corner(bar, UDim.new(1, 0))
                    Create("UIGradient", {
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                            ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
                        }),
                        Parent = bar,
                    })

                    local function pickAt(x)
                        local rel = math.clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
                        col = Color3.fromHSV(rel, 1, 1)
                        swatch.BackgroundColor3 = col
                        if callback then callback(col) end
                    end

                    bar.MouseButton1Down:Connect(function() pickAt(Mouse.X) end)
                    local dragging = true
                    local c1 = RunService.RenderStepped:Connect(function()
                        if dragging and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                            pickAt(Mouse.X)
                        end
                    end)
                    local c2 = UserInputService.InputEnded:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = false
                            c1:Disconnect()
                            c2:Disconnect()
                            task.delay(0.15, function() if pop.Parent then pop:Destroy() end end)
                        end
                    end)
                end)
            end

            return api
        end

        return tabAPI
    end

    -- Minimize / close
    local savedSize = win.Size
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        body.Visible = not minimized
        if minimized then
            savedSize = win.Size
            Tween(win, { Size = UDim2.new(savedSize.X.Scale, savedSize.X.Offset, 0, 52) }, Theme.TweenMed):Play()
        else
            Tween(win, { Size = savedSize }, Theme.TweenMed):Play()
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        Tween(win, { BackgroundTransparency = 1 }, Theme.TweenFast):Play()
        task.delay(0.25, function() win:Destroy() end)
    end)

    Drag(win, titleBar)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == toggleKey then
            win.Visible = not win.Visible
        end
    end)

    task.defer(function()
        if activeTab then MoveIndicator(activeTab.Button) end
        Prism:Notify({
            Title = "Prism UI",
            Content = "Loaded. " .. toggleKey.Name .. " — toggle window.",
            Type = "Success",
            Duration = 4,
        })
    end)

    return window
end

--// Demo
if Prism.LoadDemo then
    local Window = Prism:CreateWindow({
        Name = "Prism UI",
        Subtitle = "v" .. Prism.Version,
        Size = Vector2.new(620, 440),
        Keybind = Enum.KeyCode.RightControl,
    })

    local Main = Window:Tab("Main", ">")
    local Settings = Window:Tab("Settings", "*")
    local About = Window:Tab("About", "?")

    local Combat = Main:Section("Combat")
    Combat:Toggle("Auto Attack", false, function(v)
        Prism:Notify({ Title = "Auto Attack", Content = v and "ON" or "OFF", Type = v and "Success" or "Info" })
    end)
    Combat:Slider("Attack Range", 10, 100, 50, function() end)
    Combat:Dropdown("Target", { "Nearest", "Lowest HP", "Random" }, "Nearest", function() end)

    local Move = Main:Section("Movement")
    Move:Toggle("Speed Boost", false, function() end)
    Move:Slider("Walk Speed", 16, 200, 16, function() end)
    Move:Keybind("Fly Key", Enum.KeyCode.F, function() end)

    local Vis = Main:Section("Visuals")
    Vis:ColorPicker("ESP Color", Color3.fromRGB(108, 92, 231), function() end)
    Vis:Toggle("Fullbright", false, function() end)

    local Act = Main:Section("Actions")
    Act:Button("Test Notify", function()
        Prism:Notify({ Title = "Hello", Content = "Everything works.", Type = "Info" })
    end)

    local Cfg = Settings:Section("Config")
    Cfg:Input("Username", "Enter name...", function(t)
        Prism:Notify({ Title = "Input", Content = t, Type = "Info" })
    end)
    Cfg:Dropdown("Theme", { "Default", "Midnight", "Amethyst" }, "Default", function(v)
        if v == "Amethyst" then
            Prism:SetTheme({ Accent = Color3.fromRGB(155, 89, 182), Accent2 = Color3.fromRGB(236, 72, 153) })
        elseif v == "Midnight" then
            Prism:SetTheme({ Accent = Color3.fromRGB(52, 152, 219), Accent2 = Color3.fromRGB(41, 128, 185) })
        else
            Prism:SetTheme({ Accent = Color3.fromRGB(108, 92, 231), Accent2 = Color3.fromRGB(0, 210, 255) })
        end
    end)

    local Info = About:Section("Info")
    Info:Label("PrismUI — custom library in one file.")
    Info:Label("Tabs overlay correctly. Sidebar icons aligned.")
    Info:Label("RightControl toggles the window.")
    Info:Button("Destroy UI", function() Prism:Destroy() end)
end

return Prism

