--[[
CoolDev
working
]]
local CF = {
    Alt = ""
}

local Remotes = workspace.__REMOTES
local Core = Remotes.Core["Get Stats"]
local Trade = Remotes.Game.Trading
local Inv = Remotes.Game.Inventory

local Save = nil
local function refresh()
    Save = Core:InvokeServer().Save
end
refresh()

local function petPower(p)
    local pow = 0
    if p.dm then pow = 10000
    elseif p.r then pow = 1000
    elseif p.g then pow = 100 end
    if p.lvl then pow = pow + p.lvl * 10 end
    return pow
end

local function sorted()
    local list = {}
    for _, v in pairs(Save.Pets) do
        list[#list + 1] = {p = v, pow = petPower(v)}
    end
    table.sort(list, function(a,b) return a.pow > b.pow end)
    local out = {}
    for _, v in pairs(list) do out[#out + 1] = v.p end
    return out
end

local function best(limit)
    local s = sorted()
    local res = {}
    for _, v in pairs(s) do
        if not v.e and #res < limit then
            res[#res + 1] = v
        end
    end
    return res
end

local function eq()
    local e = {}
    for _, v in pairs(Save.Pets) do
        if v.e then e[#e + 1] = v end
    end
    return e
end

local MaxSlots = Save.MaxPets
local Lock = false
local Event = nil
local Run = true

while Run do
    task.wait()
    
    if Lock then continue end
    Lock = true
    
    if Event then Event:Disconnect() Event = nil end
    
    local TID = nil
    
    Event = game:FindFirstChild("Trade Update", true).OnClientEvent:Connect(function(id)
        TID = id
    end)
    
    local ok = false
    for _ = 1, 8 do
        if Trade:InvokeServer("InvSend", game.Players[CF.Alt]) then
            ok = true
            break
        end
        task.wait(0.25)
    end
    if not ok then Lock = false continue end
    
    for _ = 1, 20 do
        if TID then break end
        task.wait()
    end
    if not TID then Lock = false continue end
    
    local added = 0
    local eqp = eq()
    local total = #eqp
    
    for _, v in pairs(eqp) do
        task.spawn(function()
            Trade:InvokeServer("Add", TID, v.id)
            added = added + 1
        end)
    end
    
    local timeout = 0
    while added < total and timeout < 100 do
        task.wait(0.05)
        timeout = timeout + 1
    end
    
    local before = #Save.Pets
    Trade:InvokeServer("Ready", TID)
    
    timeout = 0
    while before == #Save.Pets and timeout < 50 do
        task.wait(0.1)
        refresh()
        timeout = timeout + 1
    end
    
    task.spawn(function()
        task.wait(0.5)
        Trade:InvokeServer("Cancel", TID)
    end)
    
    local toEquip = best(MaxSlots)
    
    for i, v in pairs(toEquip) do
        local r = ""
        if v.dm then r = "[DM]"
        elseif v.r then r = "[RB]"
        elseif v.g then r = "[GL]" end
        print(string.format("%d. %s %s", i, r, v.n or "?"))
    end
    
    local equipped = 0
    for _, v in pairs(toEquip) do
        task.spawn(function()
            if Inv:InvokeServer("Equip", v.id) then
                equipped = equipped + 1
            end
        end)
    end
    
    timeout = 0
    while equipped < #toEquip and timeout < 100 do
        task.wait(0.05)
        timeout = timeout + 1
    end
    
    refresh()
    
    local empty = true
    for _, v in pairs(Save.Pets) do
        if v.e then
            empty = false
            break
        end
    end
    
    if empty or #Save.Pets == #toEquip then
        Run = false
    end
    
    Lock = false
    task.wait(1)
end
