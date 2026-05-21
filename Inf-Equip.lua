-- CoolDev

local CONFIG = {
    ALT_ACCOUNT = ""  -- Enter alt account name here
}

--don't change anything from the bottom

local function calculatePetPower(pet)
    local power = 0
    
    if pet.dm then
        power = power + 10000  -- Dark Matter
    elseif pet.r then
        power = power + 1000   -- Rainbow
    elseif pet.g then
        power = power + 100    -- Golden
    end
    
    if pet.lvl then
        power = power + pet.lvl * 10
    end
    
    return power
end

--sort
local function getPetsSortedByPower()
    local pets = getSaveData().Pets
    local petPowerList = {}
    
    for _, pet in pairs(pets) do
        table.insert(petPowerList, {
            pet = pet,
            power = calculatePetPower(pet)
        })
    end

    table.sort(petPowerList, function(a, b)
        return a.power > b.power
    end)
    
    local sortedPets = {}
    for _, item in pairs(petPowerList) do
        table.insert(sortedPets, item.pet)
    end
    
    return sortedPets
end

--get best
local function getBestUnequippedPets(limit)
    local sortedPets = getPetsSortedByPower()
    local bestPets = {}
    
    for _, pet in pairs(sortedPets) do
        if not pet.e and #bestPets < limit then
            table.insert(bestPets, pet)
        end
    end
    
    return bestPets
end

function getSaveData()
    return workspace.__REMOTES.Core["Get Stats"]:InvokeServer().Save
end

function getAllPets()
    return getSaveData().Pets
end

function getEquippedPets()
    local equipped = {}
    for _, pet in pairs(getAllPets()) do
        if pet.e then
            equipped[#equipped + 1] = pet
        end
    end
    return equipped
end

--main
local maxPets = getSaveData().MaxPets
local TradeRemote = workspace.__REMOTES.Game.Trading
local InventoryRemote = workspace.__REMOTES.Game.Inventory
local isComplete = false
local tradeConnection = nil

repeat 
    task.wait()

    if tradeConnection then 
        tradeConnection:Disconnect() 
        tradeConnection = nil 
    end
    
    local currentTradeId = nil

    tradeConnection = game:FindFirstChild('Trade Update', true).OnClientEvent:Connect(function(id, data, operation)
        currentTradeId = id
    end)

    repeat 
        task.wait(0.25) 
    until TradeRemote:InvokeServer("InvSend", game.Players[CONFIG.ALT_ACCOUNT]) == true

    repeat 
        task.wait() 
    until currentTradeId

    local addedCount = 0
    local equippedPetsList = getEquippedPets()
    local totalEquipped = #equippedPetsList

    for _, pet in pairs(equippedPetsList) do
        task.spawn(function()
            TradeRemote:InvokeServer("Add", currentTradeId, pet.id)
            addedCount = addedCount + 1
        end)
    end

    repeat 
        task.wait(0.1) 
    until addedCount == totalEquipped

    local beforeTradePetCount = #getAllPets()
    TradeRemote:InvokeServer("Ready", currentTradeId)
    
    repeat 
        task.wait(0.1) 
    until beforeTradePetCount ~= #getAllPets()

    task.spawn(function()
        TradeRemote:InvokeServer("Cancel", currentTradeId)
    end)

    local equippedSuccessCount = 0
    local bestPetsToEquip = getBestUnequippedPets(maxPets)

    for index, pet in pairs(bestPetsToEquip) do
        local power = calculatePetPower(pet)
        local rarityTag = ""
        if pet.dm then 
            rarityTag = "💀 [DM]"
        elseif pet.r then 
            rarityTag = "🌈 [RB]"
        elseif pet.g then 
            rarityTag = "⭐ [GL]"
        end
        print(string.format("  %d. %s %s (⚡ Power: %d)", index, rarityTag, pet.n or "Unknown", power))
    end
    
    -- Equip each pet
    for _, pet in pairs(bestPetsToEquip) do
        task.spawn(function()
            local success = InventoryRemote:InvokeServer('Equip', pet.id)
            if success then
                equippedSuccessCount = equippedSuccessCount + 1
            end
        end)
    end

    repeat 
        task.wait() 
    until equippedSuccessCount == #bestPetsToEquip
    
    isComplete = (#getAllPets() == #bestPetsToEquip)

    repeat 
        task.wait(0.1) 
    until beforeTradePetCount <= #getAllPets()

until #getEquippedPets() == 0 or isComplete
