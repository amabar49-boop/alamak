-- Load VinzHub Library (official, stabil)
local Library = loadstring(game:HttpGet("https://script.vinzhub.com/library"))()

-- Window
local Window = Library:CreateWindow({
    Title = "Alamak Hub - Fish It OP (Auto Detect Remote)",
    Center = true,
    AutoShow = true
})

local Tab = Window:AddTab("Auto Fish")
local Section = Tab:AddSection("Instant Auto Fish (Dynamic Remote)")

local AutoFishEnabled = false
local foundCast = nil
local foundReel = nil

-- Function scan & find remotes
local function scanRemotes()
    local rep = game:GetService("ReplicatedStorage")
    local remotesFolder = rep:FindFirstChild("Remotes") or rep:FindFirstChild("Events") or rep:FindFirstChild("Network")
    if not remotesFolder then
        game.StarterGui:SetCore("SendNotification", {Title="Error", Text="Remotes folder gak ketemu! Coba lagi.", Duration=5})
        return
    end
    
    -- Scan cast remote
    for _, remote in pairs(remotesFolder:GetChildren()) do
        if remote:IsA("RemoteEvent") and (remote.Name:lower():find("cast") or remote.Name:lower():find("throw") or remote.Name:lower():find("lob") or remote.Name:lower():find("rod")) then
            foundCast = remote
            break
        end
    end
    
    -- Scan reel/catch remote
    for _, remote in pairs(remotesFolder:GetChildren()) do
        if remote:IsA("RemoteEvent") and (remote.Name:lower():find("reel") or remote.Name:lower():find("catch") or remote.Name:lower():find("pull") or remote.Name:lower():find("claim") or remote.Name:lower():find("collect") or remote.Name:lower():find("hook")) then
            foundReel = remote
            break
        end
    end
    
    -- Notify & print
    local msg = "Cast: " .. (foundCast and foundCast.Name or "NONE") .. " | Reel: " .. (foundReel and foundReel.Name or "NONE")
    game.StarterGui:SetCore("SendNotification", {Title="Scan Done", Text=msg, Duration=5})
    print("=== FISH IT REMOTES ===")
    print("Cast Remote: " .. (foundCast and foundCast.Name or "Not found"))
    print("Reel Remote: " .. (foundReel and foundReel.Name or "Not found"))
end

-- Button Scan (jalanin dulu ini sekali)
Section:AddButton("🔍 Scan Remotes (Jalankan dulu!)", function()
    scanRemotes()
end)

-- Toggle Auto Fish
Section:AddToggle("AutoFish", {
    Text = "Auto Fish Instant (ON untuk mulai)",
    Default = false
}):OnChanged(function(Value)
    AutoFishEnabled = Value
    if Value then
        spawn(function()
            scanRemotes()  -- scan ulang
            while AutoFishEnabled do
                pcall(function()
                    if foundCast then
                        foundCast:FireServer()  -- cast/lempar
                        task.wait(0.5 + math.random() * 0.5)  -- wait bite instant
                    end
                    if foundReel then
                        foundReel:FireServer()  -- reel/catch instant
                    end
                end)
                task.wait(1.2 + math.random() * 0.8)  -- full cycle delay anti-ban
            end
        end)
    end
end)

-- Auto Sell
local AutoSellEnabled = false
Section:AddToggle("AutoSell", {
    Text = "Auto Sell All",
    Default = false
}):OnChanged(function(Value)
    AutoSellEnabled = Value
    spawn(function()
        while AutoSellEnabled do
            local rep = game:GetService("ReplicatedStorage")
            local remotesFolder = rep:FindFirstChild("Remotes") or rep:FindFirstChild("Events")
            for _, remote in pairs((remotesFolder or rep):GetChildren()) do
                if remote:IsA("RemoteEvent") and remote.Name:lower():find("sell") then
                    pcall(function() remote:FireServer("All") end)
                    pcall(function() remote:FireServer() end)
                    break
                end
            end
            task.wait(3)
        end
    end)
end)

-- Button TP ke spot bagus (contoh Ocean/Pond)
Section:AddButton("TP Ocean (Rare Fish)", function()
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(-500, 50, -500)  -- adjust kalau beda, test manual
    end
end)

Section:AddLabel("✅ Cara: 1. Scan → 2. Toggle ON → Auto OP!")
Section:AddLabel("📱 Mobile OK | Kalau gak work, kasih tau nama remote dari notif/console.")

-- Tab lain buat test
local TestTab = Window:AddTab("Test")
TestTab:AddButton("Test Cast Manual", function()
    scanRemotes()
    if foundCast then foundCast:FireServer() print("Cast fired!") end
end)
TestTab:AddButton("Test Reel Manual", function()
    scanRemotes()
    if foundReel then foundReel:FireServer() print("Reel fired!") end
end)
