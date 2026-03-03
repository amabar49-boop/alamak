-- [[ 1. Inisialisasi Library ]] --
local success, UI = pcall(function()
    return loadstring(game:HttpGet("https://script.vinzhub.com/newlib"))()
end)

if not success or not UI then
    warn("Gagal memuat UI Library.")
    return
end

-- [[ 2. Variabel Kontrol ]] --
_G.AutoFish = false
_G.AutoSell = false
_G.CompleteDelay = 0.5
_G.WaitDelay = 1.0
_G.SellDelay = 10 
_G.PowerValue = 0.23002560436725616

-- [[ 3. Membuat Window Utama ]] --
local Window = UI:New({
    Title = "VinzHub | Fish a Brainrot",
    Footer = "Fixed Complete Delay • v1.4",
    Logo = "rbxassetid://93128969335561"
})

-- [[ 4. Tab & Section ]] --
local MainTab = Window:NewTab("Main Features")
local FarmSection = MainTab:NewSection("Auto Fishing", true)

-- Toggle Auto Fish
FarmSection:Toggle({
    Name = "Instant Auto Fish",
    Default = false,
    Callback = function(state)
        _G.AutoFish = state
    end
})

-- SLIDER COMPLETE DELAY (SUDAH DIPERBAIKI)
FarmSection:Slider({
    Name = "Complete Delay (Catch)",
    Min = 0,
    Max = 3,
    Default = 0.5,
    Callback = function(val)
        _G.CompleteDelay = val
    end
})

-- SLIDER WAIT/CANCEL DELAY
FarmSection:Slider({
    Name = "Wait Delay (Next Cast)",
    Min = 0,
    Max = 3,
    Default = 1.0,
    Callback = function(val)
        _G.WaitDelay = val
    end
})

local SellSection = MainTab:NewSection("Auto Sell", true)

-- Toggle Auto Sell
SellSection:Toggle({
    Name = "Auto Sell All Blocks",
    Default = false,
    Callback = function(state)
        _G.AutoSell = state
    end
})

-- Slider Sell Delay
SellSection:Slider({
    Name = "Sell Every (Seconds)",
    Min = 5,
    Max = 60,
    Default = 10,
    Callback = function(val)
        _G.SellDelay = val
    end
})

--- ==========================================
--- CORE LOGIC
--- ==========================================

local function getItemsToSell()
    local items = {}
    local lp = game:GetService("Players").LocalPlayer
    for _, item in pairs(lp.Backpack:GetChildren()) do
        if item:IsA("Tool") and not item.Name:lower():find("rod") then
            table.insert(items, item)
        end
    end
    if lp.Character then
        for _, item in pairs(lp.Character:GetChildren()) do
            if item:IsA("Tool") and not item.Name:lower():find("rod") then
                table.insert(items, item)
            end
        end
    end
    return items
end

-- Loop Memancing
task.spawn(function()
    local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
    while true do
        if _G.AutoFish then
            pcall(function()
                Remotes.RodEquipped:FireServer(true)
                Remotes.FishRequest:InvokeServer(_G.PowerValue)
                
                -- Menggunakan nilai dari slider Complete Delay
                task.wait(_G.CompleteDelay) 
                
                Remotes.FishingCompleted:FireServer(_G.PowerValue)
                
                -- Menggunakan nilai dari slider Wait Delay
                task.wait(_G.WaitDelay)
            end)
        end
        task.wait(0.1)
    end
end)

-- Loop Menjual
task.spawn(function()
    local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
    while true do
        task.wait(_G.SellDelay)
        if _G.AutoSell then
            pcall(function()
                local myItems = getItemsToSell()
                if #myItems > 0 then
                    Remotes.SellAllBlocksRequest:FireServer({unpack(myItems)})
                end
            end)
        end
    end
end)

UI:Notify({Title = "VinzHub", Content = "Script Fixed! Complete Delay Ready.", Time = 3})
