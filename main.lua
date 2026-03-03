-- [[ 1. Inisialisasi Library ]] --
local UI = loadstring(game:HttpGet("https://script.vinzhub.com/newlib"))()

-- [[ 2. Variabel Kontrol ]] --
_G.AutoFish = false
_G.CompleteDelay = 0.5
_G.WaitDelay = 1.0
_G.PowerValue = 0.23002560436725616

-- [[ 3. Membuat Window Utama ]] --
local Window = UI:New({
    Title = "VinzHub | Fish a Brainrot",
    Footer = "Gemini AI Edition • v1.0",
    Logo = "rbxassetid://93128969335561"
})

-- [[ 4. Tab Utama ]] --
local MainTab = Window:NewTab("Main Features")
local SettingsTab = Window:NewTab("Settings")

--- ==========================================
--- TAB: MAIN FEATURES
--- ==========================================

local MainSection = MainTab:NewSection("Auto Farm Configuration", false)

-- Toggle Auto Fish
MainSection:Toggle({
    Name = "Instant Auto Fish",
    Default = false,
    Callback = function(state)
        _G.AutoFish = state
        if state then
            UI:Notify({
                Title = "Auto Fish",
                Content = "Script Memulai Proses...",
                Time = 3
            })
        end
    end
})

-- Slider Complete Delay
MainSection:Slider({
    Name = "Complete Delay (Catch)",
    Min = 0,
    Max = 5,
    Default = 0.5,
    Callback = function(val)
        _G.CompleteDelay = val
    end
})

-- Slider Wait Delay
MainSection:Slider({
    Name = "Wait/Cancel Delay",
    Min = 0,
    Max = 5,
    Default = 1.0,
    Callback = function(val)
        _G.WaitDelay = val
    end
})

-- Textbox Power Value (Bisa ganti manual jika data spy berubah)
MainSection:Textbox({
    Name = "Custom Power Value",
    Placeholder = "Default: 0.2300...",
    Callback = function(text)
        local num = tonumber(text)
        if num then
            _G.PowerValue = num
            print("Power Value updated to:", num)
        end
    end
})

--- ==========================================
--- TAB: SETTINGS
--- ==========================================
local ConfigSection = SettingsTab:NewSection("Configuration")
UI:ConfigManager(ConfigSection)

SettingsTab:Paragraph({
    Title = "Credits",
    Content = "Script optimized with VinzHub UI for Fish a Brainrot."
})

--- ==========================================
--- CORE LOOP (LOGIC)
--- ==========================================

task.spawn(function()
    while true do
        task.wait()
        if _G.AutoFish then
            local success, err = pcall(function()
                local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
                
                -- 1. Equip Rod
                Remotes.RodEquipped:FireServer(true)
                
                -- 2. Cast Rod (Invoke)
                Remotes.FishRequest:InvokeServer(_G.PowerValue)
                
                -- 3. Menunggu (Complete Delay)
                task.wait(_G.CompleteDelay)
                
                -- 4. Instant Catch
                Remotes.FishingCompleted:FireServer(_G.PowerValue)
                
                -- 5. Jeda antar lemparan (Wait Delay)
                task.wait(_G.WaitDelay)
            end)
            
            if not success then
                warn("Fishing Error: " .. tostring(err))
                task.wait(1)
            end
        end
    end
end)
