--[[
    PrismUI v2.0 — dashboard-style GUI library (single file)
    Style: CreateWindow({ Style = "Dashboard" }) — icon sidebar + cards
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local function GetParent()
    if gethui then return gethui() end
    return CoreGui
end

local function Protect(gui)
    if syn and syn.protect_gui then syn.protect_gui(gui) end
    if gethui then gui.Parent = gethui() end
end

local typeOf = typeof or type

local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then inst[k] = v end
    end
    if props and props.Parent then inst.Parent = props.Parent end
    return inst
end

local Theme = {
    Background = Color3.fromRGB(11, 12, 16),
    Surface = Color3.fromRGB(16, 17, 23),
    SurfaceHover = Color3.fromRGB(24, 26, 34),
    Card = Color3.fromRGB(19, 20, 28),
    CardHover = Color3.fromRGB(26, 26, 40),
    Border = Color3.fromRGB(36, 36, 54),
    BorderLight = Color3.fromRGB(55, 55, 78),
    Accent = Color3.fromRGB(108, 92, 231),
    Accent2 = Color3.fromRGB(0, 210, 255),
    Text = Color3.fromRGB(248, 248, 252),
    TextDim = Color3.fromRGB(120, 120, 148),
    Success = Color3.fromRGB(46, 213, 115),
    Warning = Color3.fromRGB(255, 184, 0),
    Error = Color3.fromRGB(255, 71, 87),
    CloseHover = Color3.fromRGB(255, 71, 87),
    ToggleOff = Color3.fromRGB(42, 42, 60),
    ToggleOn = Color3.fromRGB(108, 92, 231),
    Font = Enum.Font.GothamMedium,
    FontBold = Enum.Font.GothamBold,
    FontLight = Enum.Font.Gotham,
    Corner = UDim.new(0, 10),
    CornerSm = UDim.new(0, 7),
    TweenFast = TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    TweenMed = TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    TweenOpen = TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
}

local EmojiIcons = {
    Logo = "🔷",
    Home = "🏠",
    Code = "🧩",
    Widgets = "🧩",
    Settings = "⚙️",
    Themes = "🎨",
    Help = "❓",
    User = "👤",
    Bell = "🔔",
    Star = "⭐",
    Scripts = "📜",
    Map = "🗺️",
    Maps = "🗺️",
    Discord = "💬",
    Social = "💬",
    Wave = "⚡",
    Friends = "👥",
    Server = "🖥️",
    Alerts = "🔔",
    System = "⚙️",
    Notify = "🔔",
}

local BuiltinIcons = {
    Text = EmojiIcons,
}

function BuiltinIcons.Resolve(icon)
    if typeOf(icon) ~= "string" then
        return 0, "•", false
    end
    return 0, EmojiIcons[icon] or icon, false
end

setmetatable(BuiltinIcons, {
    __index = function(_, key)
        if EmojiIcons[key] then
            return EmojiIcons[key]
        end
        return nil
    end,
})

local Prism = {}
Prism.Version = "2.0.2"
Prism.Build = 4
Prism.Theme = Theme
Prism.LoadDemo = true
Prism.UseImageIcons = false
Prism.Icons = nil
Prism.IconsUrl = "https://raw.githubusercontent.com/CoolDev0000/Pet-Simulator-1-scripts/refs/heads/main/icons.lua"
Prism.IconsLocal = "PrismAssets/Icons.lua"

function Prism.ResolveEmoji(icon)
    if typeOf(icon) ~= "string" then
        return "•"
    end
    if EmojiIcons[icon] then
        return EmojiIcons[icon]
    end
    if Prism.Icons and Prism.Icons.Text and Prism.Icons.Text[icon] then
        return Prism.Icons.Text[icon]
    end
    if #icon <= 4 then
        return icon
    end
    return "•"
end

function Prism:EnsureIcons()
    if Prism.Icons then
        return Prism.Icons
    end

    if not Prism.UseImageIcons then
        Prism.Icons = BuiltinIcons
        return BuiltinIcons
    end

    local function runSource(src)
        local fn = loadstring(src)
        if not fn and load then
            fn = load(src, "@PrismIcons", "t", {})
        end
        if not fn then
            return nil
        end
        local ok, result = pcall(fn)
        if ok and type(result) == "table" and type(result.Resolve) == "function" then
            return result
        end
        return nil
    end

    local ok, icons = pcall(function()
        local src = game:HttpGet(Prism.IconsUrl)
        return runSource(src)
    end)
    if ok and icons then
        Prism.Icons = icons
        return icons
    end

    if readfile then
        ok, icons = pcall(function()
            return runSource(readfile(Prism.IconsLocal))
        end)
        if ok and icons then
            Prism.Icons = icons
            return icons
        end
    end

    Prism.Icons = BuiltinIcons
    return BuiltinIcons
end

function Prism:LoadIcons(iconsModule)
    Prism.Icons = iconsModule
end

Prism.Presets = {
    Default = {
        Background = Color3.fromRGB(8, 8, 14),
        Surface = Color3.fromRGB(14, 14, 22),
        SurfaceHover = Color3.fromRGB(22, 22, 34),
        Card = Color3.fromRGB(18, 18, 28),
        Border = Color3.fromRGB(36, 36, 54),
        BorderLight = Color3.fromRGB(55, 55, 78),
        Accent = Color3.fromRGB(108, 92, 231),
        Accent2 = Color3.fromRGB(0, 210, 255),
        ToggleOff = Color3.fromRGB(42, 42, 60),
    },
    Midnight = {
        Background = Color3.fromRGB(6, 10, 18),
        Surface = Color3.fromRGB(12, 18, 30),
        SurfaceHover = Color3.fromRGB(20, 28, 44),
        Card = Color3.fromRGB(14, 20, 34),
        Border = Color3.fromRGB(30, 42, 62),
        BorderLight = Color3.fromRGB(45, 60, 85),
        Accent = Color3.fromRGB(52, 152, 219),
        Accent2 = Color3.fromRGB(41, 128, 185),
        ToggleOff = Color3.fromRGB(35, 48, 68),
    },
    Amethyst = {
        Background = Color3.fromRGB(12, 8, 18),
        Surface = Color3.fromRGB(20, 14, 28),
        SurfaceHover = Color3.fromRGB(32, 22, 42),
        Card = Color3.fromRGB(24, 16, 34),
        Border = Color3.fromRGB(50, 36, 68),
        BorderLight = Color3.fromRGB(70, 50, 90),
        Accent = Color3.fromRGB(155, 89, 182),
        Accent2 = Color3.fromRGB(236, 72, 153),
        ToggleOff = Color3.fromRGB(48, 34, 62),
    },
    Emerald = {
        Background = Color3.fromRGB(6, 12, 10),
        Surface = Color3.fromRGB(12, 20, 16),
        SurfaceHover = Color3.fromRGB(20, 32, 26),
        Card = Color3.fromRGB(14, 24, 20),
        Border = Color3.fromRGB(30, 52, 42),
        BorderLight = Color3.fromRGB(45, 72, 58),
        Accent = Color3.fromRGB(46, 204, 113),
        Accent2 = Color3.fromRGB(26, 188, 156),
        ToggleOff = Color3.fromRGB(34, 52, 44),
    },
    Rose = {
        Background = Color3.fromRGB(14, 8, 10),
        Surface = Color3.fromRGB(24, 14, 18),
        SurfaceHover = Color3.fromRGB(36, 22, 28),
        Card = Color3.fromRGB(28, 16, 22),
        Border = Color3.fromRGB(58, 36, 44),
        BorderLight = Color3.fromRGB(78, 48, 58),
        Accent = Color3.fromRGB(255, 105, 130),
        Accent2 = Color3.fromRGB(255, 160, 90),
        ToggleOff = Color3.fromRGB(52, 34, 40),
    },
    Hidden = {
        Background = Color3.fromRGB(10, 11, 15),
        Surface = Color3.fromRGB(15, 16, 22),
        SurfaceHover = Color3.fromRGB(22, 24, 32),
        Card = Color3.fromRGB(18, 19, 27),
        Border = Color3.fromRGB(32, 34, 46),
        BorderLight = Color3.fromRGB(48, 50, 66),
        Accent = Color3.fromRGB(72, 162, 255),
        Accent2 = Color3.fromRGB(120, 200, 255),
        ToggleOff = Color3.fromRGB(38, 40, 54),
    },
}

local RootGui
local NotifGui
local NotifList
local DropdownLayer

local function Tween(obj, props, info)
    return TweenService:Create(obj, info or Theme.TweenMed, props)
end

local function Corner(parent, radius)
    return Create("UICorner", { CornerRadius = radius or Theme.Corner, Parent = parent })
end

local function Stroke(parent, color, thickness, trans)
    return Create("UIStroke", {
        Color = color or Theme.Border,
        Thickness = thickness or 1,
        Transparency = trans or 0,
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
    local g = Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, c1 or Theme.Accent),
            ColorSequenceKeypoint.new(1, c2 or Theme.Accent2),
        }),
        Rotation = rot or 30,
        Parent = parent,
    })
    g:SetAttribute("PrismTheme", "AccentGradient")
    return g
end

local function Tag(inst, role)
    if inst then inst:SetAttribute("PrismTheme", role) end
    return inst
end

local function MountEmoji(parent, icon, active, large)
    Prism:EnsureIcons()
    local lbl = Instance.new("TextLabel")
    lbl.Name = "Icon"
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = Prism.ResolveEmoji(icon)
    lbl.TextColor3 = active and Theme.Text or Theme.TextDim
    lbl.TextSize = large and 22 or 18
    lbl.TextScaled = large
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    lbl.TextYAlignment = Enum.TextYAlignment.Center
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.Parent = parent
    return nil, lbl, false
end

local function ApplyAccentGradient(g)
    if g and g:IsA("UIGradient") then
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.Accent),
            ColorSequenceKeypoint.new(1, Theme.Accent2),
        })
    end
end

function Prism:ApplyTheme()
    Theme.ToggleOn = Theme.Accent

    local roots = {}
    if RootGui and RootGui.Parent then table.insert(roots, RootGui) end
    if NotifGui and NotifGui.Parent then table.insert(roots, NotifGui) end

    for _, root in ipairs(roots) do
        for _, inst in ipairs(root:GetDescendants()) do
            local role = inst:GetAttribute("PrismTheme")
            if role == "Background" then
                if inst:IsA("GuiObject") then inst.BackgroundColor3 = Theme.Background end
            elseif role == "Surface" then
                if inst:IsA("GuiObject") then inst.BackgroundColor3 = Theme.Surface end
            elseif role == "Card" then
                if inst:IsA("GuiObject") then inst.BackgroundColor3 = Theme.Card end
            elseif role == "Accent" then
                if inst:IsA("GuiObject") then inst.BackgroundColor3 = Theme.Accent end
            elseif role == "AccentGradient" then
                ApplyAccentGradient(inst)
            elseif role == "Text" then
                if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
                    inst.TextColor3 = Theme.Text
                end
            elseif role == "TextDim" then
                if inst:IsA("TextLabel") or inst:IsA("TextButton") then
                    inst.TextColor3 = Theme.TextDim
                end
            elseif role == "AccentText" then
                if inst:IsA("TextLabel") or inst:IsA("TextButton") then
                    inst.TextColor3 = Theme.Accent2
                end
            elseif role == "Border" then
                if inst:IsA("UIStroke") then inst.Color = Theme.Border end
            elseif role == "BorderLight" then
                if inst:IsA("UIStroke") then inst.Color = Theme.BorderLight end
            elseif role == "ButtonPrimary" then
                if inst:IsA("GuiObject") then inst.BackgroundColor3 = Theme.Accent end
            elseif role == "ToggleTrack" then
                if inst:IsA("GuiObject") then
                    local on = inst:GetAttribute("PrismOn") == true
                    inst.BackgroundColor3 = on and Theme.ToggleOn or Theme.ToggleOff
                end
            elseif role == "ToggleOff" then
                if inst:IsA("GuiObject") then inst.BackgroundColor3 = Theme.ToggleOff end
            elseif role == "SliderFill" then
                if inst:IsA("GuiObject") then inst.BackgroundColor3 = Theme.Accent end
            elseif role == "TabIndicator" then
                if inst:IsA("GuiObject") then inst.BackgroundColor3 = Theme.Accent end
            elseif role == "IconBg" then
                if inst:IsA("GuiObject") then inst.BackgroundColor3 = Theme.Accent end
            elseif role == "Divider" then
                if inst:IsA("GuiObject") then inst.BackgroundColor3 = Theme.Border end
            elseif role == "ScrollBar" then
                if inst:IsA("ScrollingFrame") then inst.ScrollBarImageColor3 = Theme.Accent end
            elseif role == "SurfaceHover" then
                -- used only for hover memory; skip static apply
            end
        end
    end
end

local function Hover(btn, normal, hover)
    local n, h = normal or Theme.Surface, hover or Theme.SurfaceHover
    local baseTrans = btn.BackgroundTransparency
    btn.MouseEnter:Connect(function()
        Tween(btn, { BackgroundColor3 = h }, Theme.TweenFast):Play()
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn, { BackgroundColor3 = n, BackgroundTransparency = btn.BackgroundTransparency }, Theme.TweenFast):Play()
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
            BackgroundTransparency = 0.6,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(Mouse.X - btn.AbsolutePosition.X, Mouse.Y - btn.AbsolutePosition.Y),
            Size = UDim2.fromOffset(4, 4),
            ZIndex = btn.ZIndex + 5,
            Parent = btn,
        })
        Corner(r, UDim.new(1, 0))
        local s = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 2.5
        Tween(r, { Size = UDim2.fromOffset(s, s), BackgroundTransparency = 1 }, TweenInfo.new(0.4)):Play()
        task.delay(0.45, function() if r.Parent then r:Destroy() end end)
    end)
end

local function Divider(parent, trans)
    return Create("Frame", {
        BackgroundColor3 = Theme.Border,
        BackgroundTransparency = trans or 0.5,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 1),
        Parent = parent,
    })
end

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
    DropdownLayer = Create("Frame", {
        Name = "DropdownLayer",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 200,
        Parent = RootGui,
    })
    return RootGui
end

local function GetDropdownLayer()
    GetRoot()
    return DropdownLayer
end

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
        Position = UDim2.new(1, -16, 0, 16),
        Size = UDim2.fromOffset(310, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = NotifGui,
    })
    VList(NotifList, 8)
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
        LayoutOrder = math.floor(tick() * 100) % 100000,
        Parent = holder,
    })
    Corner(card, Theme.CornerSm)
    Stroke(card, Theme.BorderLight, 1, 0.3)

    Create("Frame", {
        BackgroundColor3 = accent,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 3, 1, 0),
        Parent = card,
    })

    local body = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -3, 0, 0),
        Position = UDim2.new(0, 3, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = card,
    })
    Pad(body, 11, 12, 11, 12)
    VList(body, 3)

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Font = Theme.FontBold,
        Text = title,
        TextColor3 = Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, 0, 0, 18),
        LayoutOrder = 1,
        Parent = body,
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
            Parent = body,
        })
    end

    card.Position = UDim2.new(1, 40, 0, 0)
    card.BackgroundTransparency = 0.15
    Tween(card, { Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0 }, Theme.TweenMed):Play()

    task.delay(duration, function()
        if not card.Parent then return end
        local tw = Tween(card, { Position = UDim2.new(1, 40, 0, 0), BackgroundTransparency = 1 }, Theme.TweenMed)
        tw:Play()
        tw.Completed:Wait()
        card:Destroy()
    end)
end

function Prism:Destroy()
    if DropdownLayer then
        for _, c in ipairs(DropdownLayer:GetChildren()) do c:Destroy() end
    end
    if RootGui then RootGui:Destroy() RootGui = nil end
    if NotifGui then NotifGui:Destroy() NotifGui = nil end
    NotifList = nil
    DropdownLayer = nil
    Prism.Windows = {}
end

function Prism:SetTheme(nameOrTable)
    if type(nameOrTable) == "string" then
        local preset = Prism.Presets[nameOrTable]
        if not preset then
            warn("[PrismUI] Unknown theme preset:", nameOrTable)
            return
        end
        for k, v in pairs(preset) do
            if typeof(v) == "Color3" then Theme[k] = v end
        end
    elseif type(nameOrTable) == "table" then
        for k, v in pairs(nameOrTable) do
            if typeof(v) == "Color3" then Theme[k] = v end
        end
    end
    Theme.ToggleOn = Theme.Accent
    self:ApplyTheme()
    for _, w in ipairs(self.Windows or {}) do
        if w._RefreshTabs then w:_RefreshTabs() end
    end
end

function Prism:CreateWindow(opts)
    opts = opts or {}
    local title = opts.Name or "Prism UI"
    local subtitle = opts.Subtitle or ""
    local winSize = opts.Size or Vector2.new(900, 560)
    local toggleKey = opts.Keybind or Enum.KeyCode.RightControl
    local notifyOnLoad = opts.NotifyOnLoad == true
    local dashboard = (opts.Style or "Dashboard") ~= "Classic"
    local logoIcon = opts.Logo or "🔷"

    GetRoot()
    Prism:EnsureIcons()
    Prism.Windows = Prism.Windows or {}

    local tabs = {}
    local activeTab = nil
    local minimized = false
    local savedSize = UDim2.fromOffset(winSize.X, winSize.Y)

    local shadow = Create("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://6015897843",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.45,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        Size = UDim2.fromOffset(winSize.X + 24, winSize.Y + 24),
        Position = UDim2.new(0.5, -(winSize.X + 24) / 2, 0.5, -(winSize.Y + 24) / 2),
        Parent = RootGui,
    })

    local win = Tag(Create("Frame", {
        Name = "PrismWindow",
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Size = savedSize,
        Position = UDim2.new(0.5, -winSize.X / 2, 0.5, -winSize.Y / 2),
        ClipsDescendants = true,
        Parent = RootGui,
    }), "Background")
    Corner(win, UDim.new(0, dashboard and 14 or 12))
    Tag(Stroke(win, Theme.BorderLight, 1, 0.55), "BorderLight")

    shadow.Position = UDim2.new(
        win.Position.X.Scale, win.Position.X.Offset - 12,
        win.Position.Y.Scale, win.Position.Y.Offset - 10
    )

    local WIN_PAD = dashboard and 14 or 12
    local HEADER_H = dashboard and 50 or 44
    local SIDEBAR_W = dashboard and 58 or 108
    local SIDEBAR_GAP = dashboard and 10 or 8

    local header = Tag(Create("Frame", {
        Name = "Header",
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, HEADER_H),
        Parent = win,
    }), "Background")

    if not dashboard then
        local accentBar = Tag(Create("Frame", {
            BorderSizePixel = 0,
            BackgroundColor3 = Theme.Accent,
            Size = UDim2.new(1, -(WIN_PAD * 2), 0, 2),
            Position = UDim2.new(0, WIN_PAD, 0, 0),
            Parent = header,
        }), "Accent")
        Gradient(accentBar, Theme.Accent, Theme.Accent2, 0)
    end

    local titleBar = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = header,
    })

    Tag(Create("Frame", {
        BackgroundColor3 = Theme.Border,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -(WIN_PAD * 2), 0, 1),
        Position = UDim2.new(0, WIN_PAD, 1, 0),
        Parent = header,
    }), "Divider")

    local logoOffset = 0
    if dashboard then
        local logoBox = Tag(Create("Frame", {
            Size = UDim2.fromOffset(34, 34),
            Position = UDim2.new(0, WIN_PAD, 0.5, -17),
            BackgroundColor3 = Theme.Accent,
            Parent = titleBar,
        }), "Accent")
        Corner(logoBox, UDim.new(0, 10))
        Gradient(logoBox, Theme.Accent, Theme.Accent2, 35)
        Tag(Stroke(logoBox, Theme.Accent2, 1, 0.5), "BorderLight")
        MountEmoji(logoBox, logoIcon, true, true)
        logoOffset = 42
    end

    local titleBlock = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, WIN_PAD + logoOffset, 0, dashboard and 8 or 5),
        Parent = titleBar,
    })
    VList(titleBlock, 1)

    Tag(Create("TextLabel", {
        BackgroundTransparency = 1,
        Font = Theme.FontBold,
        Text = title,
        TextColor3 = Theme.Text,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, 0, 0, 22),
        LayoutOrder = 1,
        Parent = titleBlock,
    }), "Text")
    if subtitle ~= "" then
        Tag(Create("TextLabel", {
            BackgroundTransparency = 1,
            Font = Theme.FontLight,
            Text = subtitle,
            TextColor3 = Theme.TextDim,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1, 0, 0, 14),
            LayoutOrder = 2,
            Parent = titleBlock,
        }), "TextDim")
    end

    local btnRow = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(72, 30),
        Position = UDim2.new(1, -80, 0, 7),
        Parent = titleBar,
    })
    HList(btnRow, 8)

    local function WinBtn(symbol, isClose)
        local b = Tag(Create("TextButton", {
            BackgroundColor3 = Theme.Surface,
            BackgroundTransparency = 0.3,
            Text = symbol,
            Font = Theme.FontBold,
            TextColor3 = Theme.TextDim,
            TextSize = 16,
            Size = UDim2.fromOffset(30, 30),
            AutoButtonColor = false,
            Parent = btnRow,
        }), "Surface")
        Corner(b, Theme.CornerSm)
        Tag(b, "TextDim")
        if isClose then
            b.MouseEnter:Connect(function()
                Tween(b, { BackgroundColor3 = Theme.CloseHover, TextColor3 = Theme.Text }, Theme.TweenFast):Play()
            end)
            b.MouseLeave:Connect(function()
                Tween(b, { BackgroundColor3 = Theme.Surface, TextColor3 = Theme.TextDim }, Theme.TweenFast):Play()
            end)
        else
            Hover(b, Theme.Surface, Theme.SurfaceHover)
        end
        return b
    end

    local minBtn = WinBtn("−", false)
    local closeBtn = WinBtn("×", true)

    local body = Create("Frame", {
        Name = "Body",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -(WIN_PAD * 2), 1, -(HEADER_H + WIN_PAD + 4)),
        Position = UDim2.new(0, WIN_PAD, 0, HEADER_H + 4),
        Parent = win,
    })

    local sidebar = Tag(Create("Frame", {
        BackgroundColor3 = Theme.Surface,
        BackgroundTransparency = dashboard and 0.25 or 0,
        Size = UDim2.new(0, SIDEBAR_W, 1, 0),
        Parent = body,
    }), "Surface")
    Corner(sidebar, UDim.new(0, dashboard and 10 or 8))
    Pad(sidebar, dashboard and 10 or 8, 6, dashboard and 10 or 8, 6)

    if not dashboard then
        Tag(Create("TextLabel", {
            BackgroundTransparency = 1,
            Font = Theme.FontBold,
            Text = "MENU",
            TextColor3 = Theme.TextDim,
            TextSize = 9,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1, 0, 0, 12),
            Position = UDim2.new(0, 2, 0, 0),
            Parent = sidebar,
        }), "TextDim")
    end

    local tabScroll = Tag(Create("ScrollingFrame", {
        Name = "TabScroll",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, dashboard and -52 or -18),
        Position = UDim2.new(0, 0, 0, dashboard and 0 or 16),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent,
        ScrollBarImageTransparency = 0.5,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = sidebar,
    }), "ScrollBar")

    local tabButtons = Create("Frame", {
        Name = "TabButtons",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = tabScroll,
    })
    VList(tabButtons, dashboard and 8 or 4)

    if dashboard then
        local avatar = Create("ImageLabel", {
            BackgroundColor3 = Theme.Card,
            Size = UDim2.fromOffset(36, 36),
            Position = UDim2.new(0.5, -18, 1, -40),
            Image = "",
            Parent = sidebar,
        })
        Corner(avatar, UDim.new(0, 10))
        Tag(Stroke(avatar, Theme.BorderLight, 1, 0.4), "BorderLight")
        task.spawn(function()
            local ok, img = pcall(function()
                return Players:GetUserThumbnailAsync(
                    LocalPlayer.UserId,
                    Enum.ThumbnailType.HeadShot,
                    Enum.ThumbnailSize.Size48x48
                )
            end)
            if ok and avatar.Parent then avatar.Image = img end
        end)
    end

    Tag(Create("Frame", {
        Name = "Divider",
        BackgroundColor3 = Theme.Border,
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 1, 1, -4),
        Position = UDim2.new(0, SIDEBAR_W + math.floor(SIDEBAR_GAP / 2), 0, 2),
        Parent = body,
    }), "Divider")

    local content = Tag(Create("Frame", {
        BackgroundColor3 = dashboard and Theme.Background or Theme.Card,
        BackgroundTransparency = dashboard and 0 or 0.35,
        Size = UDim2.new(1, -(SIDEBAR_W + SIDEBAR_GAP + 1), 1, 0),
        Position = UDim2.new(0, SIDEBAR_W + SIDEBAR_GAP + 1, 0, 0),
        ClipsDescendants = true,
        Parent = body,
    }), dashboard and "Background" or "Card")
    Corner(content, UDim.new(0, dashboard and 10 or 8))

    local pagesHost = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ClipsDescendants = true,
        Parent = content,
    })

    local function SetTabIconColor(iconLbl, color)
        if iconLbl and iconLbl.Parent then
            Tween(iconLbl, { TextColor3 = color }, Theme.TweenFast):Play()
        end
    end

    local function SelectTab(data)
        for _, t in ipairs(tabs) do
            t.Page.Visible = false
            if dashboard then
                Tween(t.Button, { BackgroundTransparency = 1 }, Theme.TweenFast):Play()
                Tween(t.IconBg, { BackgroundTransparency = 1 }, Theme.TweenFast):Play()
                SetTabIconColor(t.Icon, Theme.TextDim)
            else
                Tween(t.Button, { BackgroundTransparency = 1 }, Theme.TweenFast):Play()
                Tween(t.Title, { TextColor3 = Theme.TextDim }, Theme.TweenFast):Play()
                Tween(t.IconBg, { BackgroundTransparency = 1 }, Theme.TweenFast):Play()
                SetTabIconColor(t.Icon, Theme.TextDim)
                if t.Stripe then t.Stripe.Visible = false end
            end
        end
        data.Page.Visible = true
        activeTab = data
        if dashboard then
            Tween(data.Button, { BackgroundTransparency = 0.35 }, Theme.TweenFast):Play()
            Tween(data.IconBg, { BackgroundTransparency = 0.45 }, Theme.TweenFast):Play()
            SetTabIconColor(data.Icon, Theme.Text)
        else
            Tween(data.Button, { BackgroundTransparency = 0 }, Theme.TweenFast):Play()
            Tween(data.Title, { TextColor3 = Theme.Text }, Theme.TweenFast):Play()
            Tween(data.IconBg, { BackgroundTransparency = 0.5 }, Theme.TweenFast):Play()
            SetTabIconColor(data.Icon, Theme.Accent)
            if data.Stripe then data.Stripe.Visible = true end
        end
    end

    local window = { _Win = win, _Shadow = shadow }

    function window:SelectTabByName(name)
        for _, t in ipairs(tabs) do
            if t.Name == name then SelectTab(t) return end
        end
    end

    function window:Tab(name, icon)
        icon = Prism.ResolveEmoji(icon or name or "•")

        local page = Create("Frame", {
            Name = name .. "_Page",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            Parent = pagesHost,
        })

        local pageScroll = Tag(Create("ScrollingFrame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Theme.Accent,
            ScrollBarImageTransparency = 0.3,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Parent = page,
        }), "ScrollBar")
        Pad(pageScroll, dashboard and 16 or 14, dashboard and 16 or 14, dashboard and 16 or 14, dashboard and 16 or 14)

        local pageContent = Create("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -8, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = pageScroll,
        })
        VList(pageContent, dashboard and 14 or 16)

        local isFirst = #tabs == 0
        local tabOrder = #tabs + 1
        local tabBtn = Create("TextButton", {
            BackgroundColor3 = Theme.Card,
            BackgroundTransparency = isFirst and (dashboard and 0.35 or 0.4) or 1,
            Text = "",
            Size = dashboard and UDim2.fromOffset(44, 44) or UDim2.new(1, 0, 0, 34),
            LayoutOrder = tabOrder,
            AutoButtonColor = false,
            Parent = tabButtons,
        })
        Corner(tabBtn, UDim.new(0, dashboard and 10 or 6))

        local tabStripe = nil
        if not dashboard then
            tabStripe = Tag(Create("Frame", {
                Name = "TabStripe",
                BackgroundColor3 = Theme.Accent,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 2, 0.65, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 1, 0.5, 0),
                Visible = isFirst,
                ZIndex = 6,
                Parent = tabBtn,
            }), "TabIndicator")
            Corner(tabStripe, UDim.new(0, 1))
        end

        tabBtn.MouseEnter:Connect(function()
            if activeTab and activeTab.Button == tabBtn then return end
            Tween(tabBtn, { BackgroundTransparency = dashboard and 0.5 or 0.55 }, Theme.TweenFast):Play()
        end)
        tabBtn.MouseLeave:Connect(function()
            if activeTab and activeTab.Button == tabBtn then return end
            Tween(tabBtn, { BackgroundTransparency = 1 }, Theme.TweenFast):Play()
        end)

        local tabInner = Create("Frame", {
            BackgroundTransparency = 1,
            Size = dashboard and UDim2.fromScale(1, 1) or UDim2.new(1, -10, 1, 0),
            Position = dashboard and UDim2.fromOffset(0, 0) or UDim2.new(0, 8, 0, 0),
            Parent = tabBtn,
        })

        local iconBg = Tag(Create("Frame", {
            BackgroundColor3 = Theme.Accent,
            BackgroundTransparency = isFirst and (dashboard and 0.45 or 0.8) or 1,
            Size = dashboard and UDim2.fromOffset(32, 32) or UDim2.fromOffset(22, 22),
            AnchorPoint = dashboard and Vector2.new(0.5, 0.5) or nil,
            Position = dashboard and UDim2.fromScale(0.5, 0.5) or nil,
            Parent = tabInner,
        }), "IconBg")
        Corner(iconBg, UDim.new(0, dashboard and 8 or 5))

        local _, iconLbl = MountEmoji(iconBg, icon, isFirst, dashboard)
        if iconLbl then Tag(iconLbl, "AccentText") end

        local titleLbl = Tag(Create("TextLabel", {
            Name = "Title",
            BackgroundTransparency = 1,
            Font = Theme.Font,
            Text = name,
            TextColor3 = isFirst and Theme.Text or Theme.TextDim,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Size = UDim2.new(1, -30, 0, 18),
            Visible = not dashboard,
            Parent = tabInner,
        }), isFirst and "Text" or "TextDim")

        local tabData = {
            Name = name,
            Page = page,
            Button = tabBtn,
            Stripe = tabStripe,
            Icon = iconLbl,
            IconBg = iconBg,
            Title = titleLbl,
        }
        table.insert(tabs, tabData)

        tabBtn.MouseButton1Click:Connect(function() SelectTab(tabData) end)

        if isFirst then
            page.Visible = true
            activeTab = tabData
        end

        local tabAPI = {}
        local elementCount = 0

        local function nextDivider(box)
            elementCount += 1
            if elementCount > 1 then
                Divider(box, 0.65)
            end
        end

        function tabAPI:Section(sectionName)
            local block = Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = pageContent,
            })
            VList(block, 8)

            local headRow = Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                LayoutOrder = 1,
                Parent = block,
            })
            HList(headRow, 8, Enum.VerticalAlignment.Center)

            local accentMark = Tag(Create("Frame", {
                BackgroundColor3 = Theme.Accent,
                Size = UDim2.new(0, 3, 0, 14),
                BorderSizePixel = 0,
                LayoutOrder = 1,
                Parent = headRow,
            }), "Accent")
            Corner(accentMark, UDim.new(0, 2))

            Tag(Create("TextLabel", {
                BackgroundTransparency = 1,
                Font = Theme.FontBold,
                Text = string.upper(sectionName),
                TextColor3 = Theme.TextDim,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2.new(1, -12, 0, 16),
                LayoutOrder = 2,
                Parent = headRow,
            }), "TextDim")

            local box = Tag(Create("Frame", {
                BackgroundColor3 = Theme.Card,
                BackgroundTransparency = 0.2,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                LayoutOrder = 2,
                Parent = block,
            }), "Card")
            Corner(box, Theme.CornerSm)
            Tag(Stroke(box, Theme.Border, 1, 0.5), "Border")
            Pad(box, 6, 10, 6, 10)
            VList(box, 2)

            elementCount = 0
            local api = {}

            function api:Label(text)
                nextDivider(box)
                Tag(Create("TextLabel", {
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
                }), "TextDim")
            end

            function api:Button(text, callback)
                nextDivider(box)
                local b = Tag(Create("TextButton", {
                    BackgroundColor3 = Theme.Accent,
                    Text = text,
                    Font = Theme.FontBold,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    Size = UDim2.new(1, 0, 0, 38),
                    AutoButtonColor = false,
                    Parent = box,
                }), "ButtonPrimary")
                Corner(b, Theme.CornerSm)
                Gradient(b)
                Tag(Stroke(b, Theme.Accent2, 1, 0.7), "BorderLight")
                Ripple(b)
                b.MouseButton1Click:Connect(function()
                    if callback then callback() end
                end)
            end

            function api:Toggle(label, default, callback)
                nextDivider(box)
                local on = default == true
                local row = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 40),
                    Parent = box,
                })

                Tag(Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = Theme.Font,
                    Text = label,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Center,
                    Size = UDim2.new(1, -56, 1, 0),
                    Parent = row,
                }), "Text")

                local track = Tag(Create("TextButton", {
                    BackgroundColor3 = on and Theme.ToggleOn or Theme.ToggleOff,
                    Text = "",
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    Size = UDim2.fromOffset(48, 26),
                    AutoButtonColor = false,
                    Parent = row,
                }), "ToggleTrack")
                track:SetAttribute("PrismOn", on)
                Corner(track, UDim.new(1, 0))
                Tag(Stroke(track, Theme.BorderLight, 1, 0.6), "BorderLight")

                local knob = Create("Frame", {
                    BackgroundColor3 = Theme.Text,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = on and UDim2.new(1, -23, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                    Size = UDim2.fromOffset(20, 20),
                    Parent = track,
                })
                Corner(knob, UDim.new(1, 0))
                Stroke(knob, Theme.Border, 1, 0.8)

                local function set(v, fire)
                    on = v
                    track:SetAttribute("PrismOn", on)
                    Tween(track, { BackgroundColor3 = on and Theme.ToggleOn or Theme.ToggleOff }, Theme.TweenFast):Play()
                    Tween(knob, {
                        Position = on and UDim2.new(1, -23, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                    }, Theme.TweenFast):Play()
                    if fire and callback then callback(on) end
                end

                track.MouseButton1Click:Connect(function() set(not on, true) end)
                if on and callback then callback(true) end
            end

            function api:Slider(label, min, max, default, callback)
                nextDivider(box)
                min, max = min or 0, max or 100
                default = math.clamp(default or min, min, max)
                local val = default

                local wrap = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 54),
                    Parent = box,
                })
                VList(wrap, 8)

                local head = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 18),
                    LayoutOrder = 1,
                    Parent = wrap,
                })

                Tag(Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = Theme.Font,
                    Text = label,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, -40, 1, 0),
                    Parent = head,
                }), "Text")

                local num = Tag(Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = Theme.FontBold,
                    Text = tostring(val),
                    TextColor3 = Theme.Accent2,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Size = UDim2.fromOffset(40, 18),
                    Position = UDim2.new(1, -40, 0, 0),
                    Parent = head,
                }), "AccentText")

                local track = Tag(Create("TextButton", {
                    BackgroundColor3 = Theme.ToggleOff,
                    Text = "",
                    Size = UDim2.new(1, 0, 0, 12),
                    AutoButtonColor = false,
                    LayoutOrder = 2,
                    Parent = wrap,
                }), "ToggleOff")
                Corner(track, UDim.new(1, 0))

                local fill = Tag(Create("Frame", {
                    BackgroundColor3 = Theme.Accent,
                    Size = UDim2.new((val - min) / math.max(max - min, 1), 0, 1, 0),
                    BorderSizePixel = 0,
                    Parent = track,
                }), "SliderFill")
                Corner(fill, UDim.new(1, 0))
                Gradient(fill)

                local knob = Create("Frame", {
                    BackgroundColor3 = Theme.Text,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new((val - min) / math.max(max - min, 1), 0, 0.5, 0),
                    Size = UDim2.fromOffset(16, 16),
                    ZIndex = 2,
                    Parent = track,
                })
                Corner(knob, UDim.new(1, 0))
                Stroke(knob, Theme.Accent, 2, 0)

                local dragging = false
                local function setFromX(x, fire)
                    local rel = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
                    val = math.floor(min + (max - min) * rel + 0.5)
                    num.Text = tostring(val)
                    Tween(fill, { Size = UDim2.new(rel, 0, 1, 0) }, Theme.TweenFast):Play()
                    Tween(knob, { Position = UDim2.new(rel, 0, 0.5, 0) }, Theme.TweenFast):Play()
                    if fire and callback then callback(val) end
                end

                track.MouseButton1Down:Connect(function()
                    dragging = true
                    setFromX(Mouse.X, true)
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                        setFromX(Mouse.X, true)
                    end
                end)
            end

            function api:Dropdown(label, options, default, callback)
                nextDivider(box)
                options = options or {}
                local pick = default or options[1] or "—"

                local wrap = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Parent = box,
                })
                VList(wrap, 6)

                Tag(Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = Theme.Font,
                    Text = label,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 0, 16),
                    LayoutOrder = 1,
                    Parent = wrap,
                }), "Text")

                local drop = Tag(Create("TextButton", {
                    BackgroundColor3 = Theme.Surface,
                    Text = "  " .. pick,
                    Font = Theme.Font,
                    TextColor3 = Theme.Text,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    Size = UDim2.new(1, 0, 0, 34),
                    AutoButtonColor = false,
                    LayoutOrder = 2,
                    Parent = wrap,
                }), "Surface")
                Corner(drop, Theme.CornerSm)
                Tag(Stroke(drop), "Border")
                Pad(drop, 0, 28, 0, 10)

                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = "▼",
                    Font = Theme.Font,
                    TextColor3 = Theme.TextDim,
                    TextSize = 9,
                    Size = UDim2.fromOffset(24, 34),
                    Position = UDim2.new(1, -26, 0, 0),
                    Parent = drop,
                })

                local function closeMenu()
                    local m = GetDropdownLayer():FindFirstChild("ActiveMenu")
                    if m then m:Destroy() end
                end

                local function openMenu()
                    closeMenu()
                    local layer = GetDropdownLayer()
                    local ap, as = drop.AbsolutePosition, drop.AbsoluteSize

                    local menu = Create("Frame", {
                        Name = "ActiveMenu",
                        BackgroundColor3 = Theme.Card,
                        Position = UDim2.fromOffset(ap.X, ap.Y + as.Y + 4),
                        Size = UDim2.fromOffset(as.X, 0),
                        ClipsDescendants = true,
                        Parent = layer,
                    })
                    Corner(menu, Theme.CornerSm)
                    Stroke(menu, Theme.BorderLight)
                    Pad(menu, 4, 4, 4, 4)
                    VList(menu, 2)

                    for i, opt in ipairs(options) do
                        local ob = Create("TextButton", {
                            BackgroundColor3 = Theme.Surface,
                            BackgroundTransparency = pick == opt and 0.3 or 1,
                            Text = opt,
                            Font = Theme.Font,
                            TextColor3 = pick == opt and Theme.Accent or Theme.Text,
                            TextSize = 12,
                            Size = UDim2.new(1, 0, 0, 30),
                            AutoButtonColor = false,
                            LayoutOrder = i,
                            Parent = menu,
                        })
                        Corner(ob, Theme.CornerSm)
                        Hover(ob, Theme.Surface, Theme.SurfaceHover)
                        ob.MouseButton1Click:Connect(function()
                            pick = opt
                            drop.Text = "  " .. opt
                            closeMenu()
                            if callback then callback(opt) end
                        end)
                    end

                    local h = #options * 32 + 8
                    Tween(menu, { Size = UDim2.fromOffset(as.X, h) }, Theme.TweenFast):Play()

                    task.defer(function()
                        local conn
                        conn = UserInputService.InputBegan:Connect(function(input, gpe)
                            if gpe then return end
                            if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
                            if not menu.Parent then conn:Disconnect() return end
                            local pos = input.Position
                            local mp, ms = menu.AbsolutePosition, menu.AbsoluteSize
                            local dp, ds = drop.AbsolutePosition, drop.AbsoluteSize
                            local inMenu = pos.X >= mp.X and pos.X <= mp.X + ms.X and pos.Y >= mp.Y and pos.Y <= mp.Y + ms.Y
                            local inDrop = pos.X >= dp.X and pos.X <= dp.X + ds.X and pos.Y >= dp.Y and pos.Y <= dp.Y + ds.Y
                            if not inMenu and not inDrop then
                                closeMenu()
                                conn:Disconnect()
                            end
                        end)
                    end)
                end

                drop.MouseButton1Click:Connect(function()
                    if GetDropdownLayer():FindFirstChild("ActiveMenu") then
                        closeMenu()
                    else
                        openMenu()
                    end
                end)
            end

            function api:Input(label, placeholder, callback)
                nextDivider(box)
                local fieldWrap = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Parent = box,
                })
                VList(fieldWrap, 6)

                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = Theme.Font,
                    Text = label,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 0, 16),
                    LayoutOrder = 1,
                    Parent = fieldWrap,
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
                    Size = UDim2.new(1, 0, 0, 36),
                    LayoutOrder = 2,
                    Parent = fieldWrap,
                })
                Corner(field, Theme.CornerSm)
                Stroke(field)
                Pad(field, 0, 10, 0, 10)

                field.Focused:Connect(function()
                    Tween(field, { BackgroundColor3 = Theme.SurfaceHover }, Theme.TweenFast):Play()
                end)
                field.FocusLost:Connect(function(enter)
                    Tween(field, { BackgroundColor3 = Theme.Surface }, Theme.TweenFast):Play()
                    if enter and callback then callback(field.Text) end
                end)
            end

            function api:Keybind(label, defaultKey, callback)
                nextDivider(box)
                local key = defaultKey or Enum.KeyCode.E
                local listen = false

                local row = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 40),
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
                    Size = UDim2.new(1, -92, 1, 0),
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
                    Size = UDim2.fromOffset(84, 30),
                    AutoButtonColor = false,
                    Parent = row,
                })
                Corner(kb, Theme.CornerSm)
                Stroke(kb)

                kb.MouseButton1Click:Connect(function()
                    listen = true
                    kb.Text = "..."
                    Tween(kb, { BackgroundColor3 = Theme.Accent, TextColor3 = Theme.Text }, Theme.TweenFast):Play()
                end)

                UserInputService.InputBegan:Connect(function(input, gpe)
                    if not listen or gpe then return end
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        key = input.KeyCode
                        kb.Text = key.Name
                        listen = false
                        Tween(kb, { BackgroundColor3 = Theme.Surface, TextColor3 = Theme.Accent2 }, Theme.TweenFast):Play()
                        if callback then callback(key) end
                    end
                end)
            end

            function api:ColorPicker(label, defaultColor, callback)
                nextDivider(box)
                local col = defaultColor or Theme.Accent

                local row = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 40),
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
                    Size = UDim2.new(1, -48, 1, 0),
                    Parent = row,
                })

                local swatch = Create("TextButton", {
                    BackgroundColor3 = col,
                    Text = "",
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    Size = UDim2.fromOffset(38, 30),
                    AutoButtonColor = false,
                    Parent = row,
                })
                Corner(swatch, Theme.CornerSm)
                Stroke(swatch, Theme.BorderLight, 2, 0)

                swatch.MouseButton1Click:Connect(function()
                    if GetDropdownLayer():FindFirstChild("ColorPopup") then return end
                    local layer = GetDropdownLayer()
                    local ap, as = swatch.AbsolutePosition, swatch.AbsoluteSize
                    local pop = Create("Frame", {
                        Name = "ColorPopup",
                        BackgroundColor3 = Theme.Card,
                        Position = UDim2.fromOffset(ap.X - 120, ap.Y + as.Y + 6),
                        Size = UDim2.fromOffset(180, 40),
                        Parent = layer,
                    })
                    Corner(pop)
                    Stroke(pop)
                    Pad(pop, 12, 12, 12, 12)

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

                    local dragging = false
                    bar.MouseButton1Down:Connect(function()
                        dragging = true
                        pickAt(Mouse.X)
                    end)
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
                            task.delay(0.1, function() if pop.Parent then pop:Destroy() end end)
                        end
                    end)
                end)
            end

            return api
        end

        function tabAPI:Hero(title, subtitle)
            local card = Tag(Create("Frame", {
                BackgroundColor3 = Theme.Card,
                Size = UDim2.new(1, 0, 0, 78),
                Parent = pageContent,
            }), "Card")
            Corner(card, UDim.new(0, 10))
            Tag(Stroke(card, Theme.BorderLight, 1, 0.55), "BorderLight")

            local av = Create("ImageLabel", {
                BackgroundColor3 = Theme.Surface,
                Size = UDim2.fromOffset(50, 50),
                Position = UDim2.new(0, 14, 0.5, -25),
                Image = "",
                Parent = card,
            })
            Corner(av, UDim.new(0, 10))
            Tag(Stroke(av, Theme.BorderLight, 1, 0.35), "BorderLight")
            task.spawn(function()
                local ok, img = pcall(function()
                    return Players:GetUserThumbnailAsync(
                        LocalPlayer.UserId,
                        Enum.ThumbnailType.HeadShot,
                        Enum.ThumbnailSize.Size48x48
                    )
                end)
                if ok and av.Parent then av.Image = img end
            end)

            Tag(Create("TextLabel", {
                BackgroundTransparency = 1,
                Font = Theme.FontBold,
                Text = title,
                TextColor3 = Theme.Text,
                TextSize = 20,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2.new(1, -84, 0, 26),
                Position = UDim2.new(0, 76, 0, 14),
                Parent = card,
            }), "Text")

            Tag(Create("TextLabel", {
                BackgroundTransparency = 1,
                Font = Theme.FontLight,
                Text = subtitle,
                TextColor3 = Theme.TextDim,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Size = UDim2.new(1, -84, 0, 36),
                Position = UDim2.new(0, 76, 0, 38),
                Parent = card,
            }), "TextDim")
        end

        function tabAPI:Panel(panelTitle, panelDesc)
            local wrap = Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = pageContent,
            })
            VList(wrap, 10)

            Tag(Create("TextLabel", {
                BackgroundTransparency = 1,
                Font = Theme.FontBold,
                Text = panelTitle,
                TextColor3 = Theme.Text,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2.new(1, 0, 0, 20),
                LayoutOrder = 1,
                Parent = wrap,
            }), "Text")

            if panelDesc and panelDesc ~= "" then
                Tag(Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = Theme.FontLight,
                    Text = panelDesc,
                    TextColor3 = Theme.TextDim,
                    TextSize = 12,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Size = UDim2.new(1, 0, 0, 0),
                    LayoutOrder = 2,
                    Parent = wrap,
                }), "TextDim")
            end

            local grid = Tag(Create("Frame", {
                BackgroundColor3 = Theme.Card,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                LayoutOrder = 3,
                Parent = wrap,
            }), "Card")
            Corner(grid, UDim.new(0, 10))
            Tag(Stroke(grid, Theme.BorderLight, 1, 0.5), "BorderLight")
            Pad(grid, 10, 10, 10, 10)

            local tileH = 72
            Create("UIGridLayout", {
                CellSize = UDim2.new(0.5, -6, 0, tileH),
                CellPadding = UDim2.new(0, 8, 0, 8),
                FillDirectionMaxCells = 2,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = grid,
            })

            local panelAPI = {}
            local tileOrder = 0

            function panelAPI:Tile(label, value, hint, glow)
                tileOrder += 1
                local tile = Tag(Create("Frame", {
                    BackgroundColor3 = Theme.Surface,
                    BackgroundTransparency = 0.2,
                    Size = UDim2.new(1, 0, 1, 0),
                    ClipsDescendants = true,
                    LayoutOrder = tileOrder,
                    Parent = grid,
                }), "Surface")
                Corner(tile, UDim.new(0, 8))

                if glow then
                    Tag(Create("Frame", {
                        BackgroundColor3 = glow,
                        BorderSizePixel = 0,
                        Size = UDim2.new(0, 3, 1, -8),
                        Position = UDim2.new(0, 0, 0, 4),
                        Parent = tile,
                    }), "Accent")
                end

                local inner = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Position = UDim2.new(0, glow and 6 or 0, 0, 0),
                    Parent = tile,
                })
                Pad(inner, 8, 8, 8, 8)
                VList(inner, 2)

                Tag(Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = Theme.FontBold,
                    Text = label,
                    TextColor3 = Theme.Text,
                    TextSize = 12,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 0, 14),
                    LayoutOrder = 1,
                    Parent = inner,
                }), "Text")

                Tag(Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Font = Theme.FontBold,
                    Text = tostring(value),
                    TextColor3 = Theme.Text,
                    TextSize = 15,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 0, 18),
                    LayoutOrder = 2,
                    Parent = inner,
                }), "Text")

                if hint and hint ~= "" then
                    Tag(Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Font = Theme.FontLight,
                        Text = hint,
                        TextColor3 = Theme.TextDim,
                        TextSize = 10,
                        TextTruncate = Enum.TextTruncate.AtEnd,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Size = UDim2.new(1, 0, 0, 12),
                        LayoutOrder = 3,
                        Parent = inner,
                    }), "TextDim")
                end
            end

            return panelAPI
        end

        function tabAPI:Banner(title, desc, color1, color2, callback)
            local b = Tag(Create("TextButton", {
                BackgroundColor3 = color1 or Theme.Accent,
                Text = "",
                Size = UDim2.new(1, 0, 0, 76),
                AutoButtonColor = false,
                Parent = pageContent,
            }), "ButtonPrimary")
            Corner(b, UDim.new(0, 10))
            Gradient(b, color1 or Theme.Accent, color2 or Theme.Accent2, 25)
            if callback then Ripple(b) end

            local inner = Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Parent = b,
            })
            Pad(inner, 14, 16, 14, 16)
            VList(inner, 4)

            Tag(Create("TextLabel", {
                BackgroundTransparency = 1,
                Font = Theme.FontBold,
                Text = title,
                TextColor3 = Theme.Text,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2.new(1, 0, 0, 20),
                LayoutOrder = 1,
                Parent = inner,
            }), "Text")

            Tag(Create("TextLabel", {
                BackgroundTransparency = 1,
                Font = Theme.FontLight,
                Text = desc,
                TextColor3 = Theme.Text,
                TextTransparency = 0.15,
                TextSize = 12,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutomaticSize = Enum.AutomaticSize.Y,
                Size = UDim2.new(1, 0, 0, 0),
                LayoutOrder = 2,
                Parent = inner,
            }), "Text")

            if callback then
                b.MouseButton1Click:Connect(function() callback() end)
            end
        end

        local sectionCache = {}

        function tabAPI:GetSection(name)
            name = name or "General"
            if not sectionCache[name] then
                sectionCache[name] = tabAPI:Section(name)
            end
            return sectionCache[name]
        end

        local widgetMethods = {
            "Label", "Button", "Toggle", "Slider", "Dropdown", "Input", "Keybind", "ColorPicker",
        }
        for _, methodName in ipairs(widgetMethods) do
            tabAPI[methodName] = function(_, ...)
                local sec = tabAPI:GetSection()
                return sec[methodName](sec, ...)
            end
        end

        return tabAPI
    end

    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            savedSize = win.Size
            Tween(body, { BackgroundTransparency = 1 }, Theme.TweenMed):Play()
            body.Visible = false
            Tween(win, { Size = UDim2.new(savedSize.X.Scale, savedSize.X.Offset, 0, 56) }, Theme.TweenMed):Play()
            Tween(shadow, { Size = UDim2.fromOffset(savedSize.X.Offset + 24, 80) }, Theme.TweenMed):Play()
        else
            body.Visible = true
            Tween(win, { Size = savedSize }, Theme.TweenMed):Play()
            Tween(shadow, { Size = UDim2.fromOffset(savedSize.X.Offset + 24, savedSize.Y.Offset + 24) }, Theme.TweenMed):Play()
            Tween(body, { BackgroundTransparency = 0 }, Theme.TweenMed):Play()
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        Tween(win, { BackgroundTransparency = 1 }, Theme.TweenFast):Play()
        Tween(shadow, { ImageTransparency = 1 }, Theme.TweenFast):Play()
        task.delay(0.28, function()
            win:Destroy()
            shadow:Destroy()
        end)
    end)

    Drag(win, header)
    win:GetPropertyChangedSignal("Position"):Connect(function()
        shadow.Position = UDim2.new(
            win.Position.X.Scale, win.Position.X.Offset - 12,
            win.Position.Y.Scale, win.Position.Y.Offset - 10
        )
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == toggleKey then
            win.Visible = not win.Visible
            shadow.Visible = win.Visible
        end
    end)

    win.BackgroundTransparency = 1
    win.Size = UDim2.fromOffset(winSize.X * 0.92, winSize.Y * 0.92)
    win.Position = UDim2.new(0.5, -winSize.X * 0.46, 0.5, -winSize.Y * 0.46)
    Tween(win, {
        Size = savedSize,
        Position = UDim2.new(0.5, -winSize.X / 2, 0.5, -winSize.Y / 2),
        BackgroundTransparency = 0,
    }, Theme.TweenOpen):Play()

    task.defer(function()
        if notifyOnLoad then
            Prism:Notify({
                Title = "Prism UI",
                Content = toggleKey.Name .. " — toggle window",
                Type = "Success",
                Duration = 3,
            })
        end
    end)

    function window:ApplyTheme()
        Prism:ApplyTheme()
    end

    function window:_RefreshTabs()
        if activeTab then SelectTab(activeTab) end
    end

    table.insert(Prism.Windows, window)

    return window
end

if Prism.LoadDemo then
    Prism:EnsureIcons()
    Prism:SetTheme("Hidden")
    local I = Prism.Icons

    local Window = Prism:CreateWindow({
        Name = "Prism Hub",
        Subtitle = ".gg/prismui • demo",
        Logo = "🔷",
        Style = "Dashboard",
        Size = Vector2.new(900, 560),
        Keybind = Enum.KeyCode.RightControl,
        NotifyOnLoad = true,
    })

    local Home = Window:Tab("Home", "🏠")
    local Scripts = Window:Tab("Scripts", "📜")
    local Settings = Window:Tab("Settings", "⚙️")

    Home:Hero("Hello, " .. LocalPlayer.Name, LocalPlayer.Name .. " • Prism Dashboard")

    local Server = Home:Panel("Server", "Information on the session you're currently in.")
    Server:Tile("Players", "12", "playing")
    Server:Tile("Max Players", "15", "server cap")
    Server:Tile("Latency", "80ms", "ping")
    Server:Tile("Region", "US", "server region")
    Server:Tile("Session", "00:05:12", "in server for", Theme.Success)
    Server:Tile("Join Script", "Tap to copy", "click to copy", Theme.Accent)

    Home:Banner("Discord", "Tap to join the Discord server", Color3.fromRGB(88, 101, 242), Color3.fromRGB(155, 89, 182), function()
        Prism:Notify({ Title = "Discord", Content = "Link copied (demo)", Type = "Info" })
    end)

    local Friends = Home:Panel("Friends", "What your friends are doing.")
    Friends:Tile("In Server", "0", "no friends in game")
    Friends:Tile("Offline", "28", "friends")
    Friends:Tile("Online", "2", "friends online", Theme.Warning)
    Friends:Tile("All", "100", "total friends")

    Scripts:Panel("Scripts", "Quick actions"):Tile("Auto Farm", "Off", "toggle in settings")
    Scripts:Banner("Wave", "Your executor supports this script.", Color3.fromRGB(180, 40, 50), Color3.fromRGB(40, 10, 14))

    local Cfg = Settings:Section("Settings")
    Cfg:Dropdown("Theme", { "Hidden", "Default", "Midnight", "Amethyst", "Emerald", "Rose" }, "Hidden", function(v)
        Prism:SetTheme(v)
    end)
    Cfg:Toggle("Notifications", true, function() end)
    Cfg:Button("Destroy UI", function() Prism:Destroy() end)
end

task.defer(function()
    Prism:EnsureIcons()
end)

return Prism
