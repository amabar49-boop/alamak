-- 1. Inisialisasi Library
local UI = loadstring(game:HttpGet("https://script.vinzhub.com/newlib"))()

-- 2. Membuat Window Utama
local Window = UI:New({
    Title = "VinzHub - Brainrot AutoFarm V4",
    Footer = "Lucky Block Jump • v1.5",
    Logo = "rbxassetid://93128969335561"
})

-- 3. Membuat Tab
local MainTab = Window:NewTab("Main Features")
local FarmTab = Window:NewTab("Auto Farm")
local AdvancedTab = Window:NewTab("Teleport")
local SettingsTab = Window:NewTab("Settings")

local ConfigSection = SettingsTab:NewSection("Configuration")
UI:ConfigManager(ConfigSection)

--- ==========================================
--- VARIABEL & LOGIKA
--- ==========================================
local _G = {
    AutoFarm = false,
    AutoCollect = false,
    AutoUpgrade = false,
    SelectedRarities = {}, 
    BasePos = Vector3.new(246.31, 4.16, 308.74),
    FarmDelay = 0.5
}

-- Jalur Remote Event
local NetRes = game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("Network"):WaitForChild("Remotes")
local CollectRemote = NetRes:WaitForChild("Collect Earnings")
local UpgradeRemote = NetRes:WaitForChild("Upgrade Friend")

-- Fungsi Auto Upgrade (Stands 1-100)
local function autoUpgradeAll()
    task.spawn(function()
        while _G.AutoUpgrade do
            for i = 1, 100 do
                if not _G.AutoUpgrade then break end
                UpgradeRemote:FireServer(tostring(i))
            end
            task.wait(2) -- Jeda 2 detik agar tidak spam/limit uang
        end
    end)
end

-- Fungsi Auto Collect (Instant All)
local function instantCollectAll()
    task.spawn(function()
        while _G.AutoCollect do
            for i = 1, 100 do
                if not _G.AutoCollect then break end
                CollectRemote:FireServer(tostring(i))
            end
            task.wait(1)
        end
    end)
end

-- Fungsi Interact & Lucky Farm
local function interact(object)
    local prompt = object:FindFirstChildOfClass("ProximityPrompt") or object:FindFirstChildWhichIsA("ProximityPrompt", true)
    if prompt then fireproximityprompt(prompt) end
end

local function startFarm()
    task.spawn(function()
        while _G.AutoFarm do
            local character = game.Players.LocalPlayer.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if root then
                for _, block in pairs(workspace.Live.Friends:GetChildren()) do
                    if not _G.AutoFarm then break end
                    local isTarget = false
                    for _, rarityName in pairs(_G.SelectedRarities) do
                        if block.Name:lower():match(rarityName:lower()) then
                            isTarget = true
                            break
                        end
                    end
                    if isTarget then
                        local targetPos = block:GetModelCFrame() or (block:IsA("BasePart") and block.CFrame)
                        if targetPos then
                            root.CFrame = targetPos
                            task.wait(0.1)
                            interact(block)
                            task.wait(0.1)
                            root.CFrame = CFrame.new(_G.BasePos)
                            task.wait(_G.FarmDelay)
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

--- ==========================================
--- TAB: AUTO FARM
--- ==========================================
local FarmSection = FarmTab:NewSection("Farming & Tycoon", true)

-- Fitur Auto Upgrade Baru
FarmSection:Toggle({
    Name = "Auto Upgrade Brainrot",
    Default = false,
    Callback = function(state)
        _G.AutoUpgrade = state
        if state then
            UI:Notify({Title = "Upgrade Active", Content = "Mengupgrade semua Brainrot otomatis!", Time = 3})
            autoUpgradeAll()
        end
    end
})

-- Fitur Auto Collect
FarmSection:Toggle({
    Name = "Auto Collect Coins",
    Default = false,
    Callback = function(state)
        _G.AutoCollect = state
        if state then
            instantCollectAll()
        end
    end
})

FarmSection:Toggle({
    Name = "Lucky Block Farm",
    Default = false,
    Callback = function(state)
        _G.AutoFarm = state
        if state then
            if #_G.SelectedRarities == 0 then
                UI:Notify({Title = "Peringatan", Content = "Pilih rarity!", Time = 3})
            else
                startFarm()
            end
        end
    end
})

FarmSection:Dropdown({
    Name = "Select Rarity",
    Multi = true,
    List = {"Common", "Rare", "Epic", "Legendary", "Mythic", "OG", "Secret", "Brainrot God"},
    Default = {},
    Callback = function(selected)
        _G.SelectedRarities = selected
    end
})

--- ==========================================
--- TAB: MAIN FEATURES
--- ==========================================
local MainSection = MainTab:NewSection("Player Mods", true)

MainSection:Button({
    Name = "Disable Guardians (Visual)",
    Callback = function()
        local list = {"67", "Ballerina Cappuccina", "JobJobSahur", "KatupatKepat", "Mateo", "Selephant", "TralaleroTralala", "Tung Tung Sahur"}
        local gPath = workspace.Live:FindFirstChild("Guardians")
        if gPath then
            for _, n in pairs(list) do
                local g = gPath:FindFirstChild(n)
                if g then g:MoveTo(Vector3.new(0, -500, 0)) end
            end
            UI:Notify({Title = "Success", Content = "Guardians dibuang ke void.", Time = 3})
        end
    end
})

MainSection:Slider({Name = "WalkSpeed", Min = 16, Max = 250, Default = 16, Callback = function(v) 
    if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end 
end})

--- ==========================================
--- TAB: TELEPORT
--- ==========================================
local TPSection = AdvancedTab:NewSection("Quick TP", true)
TPSection:Button({Name = "Teleport to Base", Callback = function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(_G.BasePos) end})

local Manager = UI.SettingManager()
Manager:AddToTab(SettingsTab)
UI:Notify({Title = "VinzHub", Content = "Auto Upgrade & Collect Ready!", Time = 5})
