--[[
    PrismAssets / Icons.lua
    ─────────────────────────────────────────
    1. Upload PNG from PrismAssets/icons/ to Roblox (Create > Decals/Images)
    2. Paste rbxassetid into Icons.Ids below
    3. In PrismUI: Window:Tab("Home", Icons.Home)  or  Icons.Get("Home")

    PNG = white minimal icons on black — in Roblox set ImageColor3 to white.
]]

local Icons = {
    Version = "1.0",

    -- Paste your rbxassetid here (0 = use text fallback)
    Ids = {
        Logo = 129159931459891,
        Home = 124054948741946,
        Code = 101391085553696,
        Settings = 86014294956636,
        Themes = 128075735564797,
        Help = 79592888732779,
        User = 80217218300928,
        Bell = 135374572541868,
        Star = 133417372199798,
        Map = 95598851353269,
        Discord = 76737711111847,
        Wave = 117470944830637,
        Scripts = 0,
        Friends = 0,
        Server = 0,
    },

    -- Text fallback until IDs are set
    Text = {
        Logo = "◐",
        Home = "⌂",
        Code = "<>",
        Settings = "⚙",
        Themes = "◎",
        Help = "?",
        User = "👤",
        Bell = "🔔",
        Star = "★",
        Map = "⌖",
        Discord = "💬",
        Wave = "⚡",
        Scripts = "<>",
        Friends = "♥",
        Server = "▣",
    },

    -- Local file names (for upload reference)
    Files = {
        Logo = "logo.png",
        Home = "home.png",
        Code = "code.png",
        Settings = "settings.png",
        Themes = "themes.png",
        Help = "help.png",
        User = "user.png",
        Bell = "bell.png",
        Star = "star.png",
        Map = "map.png",
        Discord = "discord.png",
        Wave = "wave.png",
    },
}

--- Resolve icon: returns assetId (number), textFallback (string), isImage (boolean)
function Icons.Resolve(icon)
    if typeof(icon) == "number" and icon > 0 then
        return icon, nil, true
    end
    if typeof(icon) ~= "string" then
        return 0, "•", false
    end

    local id = Icons.Ids[icon]
    if typeof(id) == "number" and id > 0 then
        return id, Icons.Text[icon], true
    end

    return 0, Icons.Text[icon] or icon, false
end

function Icons.Get(icon)
    local id, text, isImg = Icons.Resolve(icon)
    return id, text, isImg
end

function Icons.Set(name, rbxAssetId)
    if Icons.Ids[name] ~= nil then
        Icons.Ids[name] = rbxAssetId
    end
end

function Icons.SetMany(map)
    for name, id in pairs(map) do
        Icons.Set(name, id)
    end
end

function Icons.Has(name)
    local id = Icons.Ids[name]
    return typeof(id) == "number" and id > 0
end

-- Icons.Home → "Home" for Window:Tab("Home", Icons.Home)
setmetatable(Icons, {
    __index = function(_, key)
        if Icons.Ids[key] ~= nil or Icons.Text[key] then
            return key
        end
        return nil
    end,
})

return Icons
