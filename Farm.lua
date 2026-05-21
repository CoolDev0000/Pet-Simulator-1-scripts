local R = workspace.__REMOTES
local S = R.Core["Get Stats"]:InvokeServer().Save
local M = R.Game.Coins

local ID = 12345670 -- pet id
-- to destroy
local T1 = "Christmas3 Cane"
local T2 = "Christmas3 Small Cane"

local L = 0
for _, p in pairs(S.Pets) do
    if p.id == ID then
        L = p.l or 0
        if p.h then
            for _, h in pairs(S.Hats or {}) do
                if h.id == p.h then
                    L = L + (h.l or 0)
                    break
                end
            end
        end
        break
    end
end

if L == 0 then return end

local C = nil
local X = os.clock()

_G.FARM = true

while _G.FARM do
    task.wait()
    
    if not C or C.Parent ~= workspace.__THINGS.Coins then
        C = nil
        for _, v in pairs(workspace.__THINGS.Coins:GetChildren()) do
            local N = v:FindFirstChild("CoinName")
            if N then
                if N.Value == T1 then
                    C = v
                    break
                elseif not C and N.Value == T2 then
                    C = v
                end
            end
        end
    end
    
    if C and os.clock() - X >= 0.13 then
        pcall(function()
            M:FireServer("Mine", C.Name, L * 2 - 1, ID)
        end)
        X = os.clock()
    end
end
