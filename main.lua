-- Load VinzHub Library
local Library = loadstring(game:HttpGet("https://script.vinzhub.com/library"))()

-- Create Window
local Window = Library:CreateWindow({
    Title = "Alamak Hub - Fish It",
    Center = true,
    AutoShow = true
})

-- Create Tab
local MainTab = Window:AddTab("Main")
local AutoTab = Window:AddTab("Auto Fish")   -- tab tambahan biar rapi

-- Create Section di Main (contoh fitur lain)
local MainSection = MainTab:AddSection("Basic Features")

MainSection:AddButton("Test Notification", function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "Alamak Hub",
        Text = "Test berhasil bro!",
        Duration = 3
    })
end)

-- ── AUTO FISH SECTION ────────────────────────────────────────────────
local AutoSection = AutoTab:AddSection("Instant / Auto Fishing")

local AutoFishEnabled = false
local InstantCatchEnabled = false

-- Toggle Auto Fish (loop casting + attempt auto catch)
AutoSection:AddToggle("AutoFishToggle", {
    Text = "Auto Fish (Loop Cast)",
    Default = false
}):OnChanged(function(Value)
    AutoFishEnabled = Value
    if Value then
        spawn(function()
            while AutoFishEnabled and task.wait() do
                -- Coba panggil action cast (ganti sesuai Remote yang benar)
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.Cast:FireServer()   -- nama Remote sering beda
                end)
                task.wait(0.8 + math.random()*0.4)  -- delay kecil biar ga terlalu ksp
            end
        end)
    end
end)

-- Toggle Instant Catch / Auto Reel (cara umum force catch)
AutoSection:AddToggle("InstantCatchToggle", {
    Text = "Instant Catch / Auto Reel",
    Default = false
}):OnChanged(function(Value)
    InstantCatchEnabled = Value
    if Value then
        spawn(function()
            while InstantCatchEnabled and task.wait(0.12) do
                -- Cara 1: force complete reel (jika ada value progress)
                pcall(function()
                    local player = game.Players.LocalPlayer
                    local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
                    if tool and tool:FindFirstChild("ReelProgress") then
                        tool.ReelProgress.Value = 100  -- coba set ke max (bisa gagal)
                    end
                end)

                -- Cara 2: panggil remote catch/reel (yang paling sering work)
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.Reel:FireServer("Instant")   -- ganti nama remote & arg
                    -- atau: .CatchFish:FireServer()
                    -- atau: .CompleteReel:FireServer(true)
                end)
            end
        end)
    end
end)

-- Slider untuk adjust speed loop (optional)
AutoSection:AddSlider("LoopDelay", {
    Text = "Auto Fish Delay (detik)",
    Min = 0.1,
    Max = 2,
    Default = 0.6,
    Rounding = 2
}):OnChanged(function(Value)
    -- bisa disimpan ke variable global kalau mau dipake di loop
    print("Delay diubah ke: " .. Value)
end)

-- Button untuk coba teleport ke spot bagus (contoh)
AutoSection:AddButton("Teleport ke Ocean (contoh)", function()
    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(1000, 50, 1000)   -- ganti koordinat spot bagus di map Fish It
    end
end)

-- Label info
AutoTab:AddLabel("Note: Ganti nama RemoteEvent sesuai game (pakai Dex).")
AutoTab:AddLabel("Kalau banjir error → matiin toggle & cari nama remote yang bener.")
