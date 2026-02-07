-- Load VinzHub Library
local Library = loadstring(game:HttpGet("https://vinzhub.netlify.app/loader"))()

local Window = Library:CreateWindow({
    Title = "Alamak Hub - Fish It OP Delays",
    Center = true,
    AutoShow = true
})

local Tab = Window:AddTab("Auto Fish")
local Section = Tab:AddSection("Fitur Delays seperti Hub")

-- Variables
local AutoFishEnabled = false
local CastDelay = 1.5
local CompleteDelay = 0.2
local CancelDelay = 0.5
local castRemote = nil
local reelRemote = nil
local completeRemote = nil
local cancelRemote = nil

-- Scan all possible remotes (common di Fish It)
local function scanRemotes()
    local rep = game:GetService("ReplicatedStorage")
    local folders = {"Remotes", "Events", "Network", rep}
    for _, folder in pairs(folders) do
        if folder:IsA("Folder") then
            for _, obj in pairs(folder:GetChildren()) do
                local name = obj.Name:lower()
                if obj:IsA("RemoteEvent") then
                    if not castRemote and (name:find("cast") or name:find("throw") or name:find("rod") or name:find("start")) then
                        castRemote = obj
                    elseif not reelRemote and (name:find("reel") or name:find("hook")) then
                        reelRemote = obj
                    elseif not completeRemote and (name:find("complete") or name:find("catch") or name:find("claim") or name:find("collect")) then
                        completeRemote = obj
                    elseif not cancelRemote and (name:find("cancel") or name:find("fail")) then
                        cancelRemote = obj
                    end
                end
            end
        end
    end
    
    local msg = string.format("Cast: %s | Reel: %s | Complete: %s | Cancel: %s", 
        castRemote and castRemote.Name or "NONE", 
        reelRemote and reelRemote.Name or "NONE",
        completeRemote and completeRemote.Name or "NONE",
        cancelRemote and cancelRemote.Name or "NONE")
    game.StarterGui:SetCore("SendNotification", {Title="Scan OK", Text=msg, Duration=7})
    print(msg)
end

-- Sliders Delays
Section:AddSlider("CastD", {Text="Cast Delay (s)", Min=0.1, Max=5, Default=1.5, Rounding=2}):OnChanged(function(v) CastDelay = v end)
Section:AddSlider("CompD", {Text="Complete Delay (s)", Min=0.1, Max=2, Default=0.2, Rounding=2}):OnChanged(function(v) CompleteDelay = v end)
Section:AddSlider("CanD", {Text="Cancel Delay (s)", Min=0.1, Max=3, Default=0.5, Rounding=2}):OnChanged(function(v) CancelDelay = v end)

-- Button Scan (jalan dulu!)
Section:AddButton("🔍 Scan Remotes (WAJIB!)", scanRemotes)

-- Toggle Auto Fish
Section:AddToggle("AutoFishT", {
    Text = "Auto Fish + Delays",
    Default = false
}):OnChanged(function(Value)
    AutoFishEnabled = Value
    if Value then
        spawn(function()
            scanRemotes()
            while AutoFishEnabled do
                pcall(function()
                    if castRemote then castRemote:FireServer() end  -- Cast
                    task.wait(CastDelay)
                    if reelRemote then reelRemote:FireServer() end  -- Start Reel
                    task.wait(CompleteDelay)
                    if completeRemote then completeRemote:FireServer() end  -- Complete Catch
                    task.wait(CancelDelay)
                    if cancelRemote then cancelRemote:FireServer() end  -- Cancel if miss
                end)
                task.wait(0.5 + math.random()*0.5)  -- Anti detect
            end
        end)
    end
end)

-- Auto Sell
local AutoSellTog = false
Section:AddToggle("AutoSellT", {Text="Auto Sell Loop", Default=false}):OnChanged(function(v)
    AutoSellTog = v
    spawn(function()
        while AutoSellTog do
            for _, r in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                if r:IsA("RemoteEvent") and r.Name:lower():find("sell") then
                    r:FireServer("All")
                    break
                end
            end
            task.wait(2)
        end
    end)
end)

-- Equip Best Rod & TP
Section:AddButton("Equip Best Rod", function()
    -- Logic sederhana: Fire buy/equip remote atau set tool
    for _, r in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if r:IsA("RemoteEvent") and r.Name:lower():find("equip") or r.Name:lower():find("rod") then
            r:FireServer("Best")
        end
    end
end)

Section:AddButton("TP Ocean Rare", function()
    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = CFrame.new(-150, 20, -200)  -- Spot umum rare fish, adjust kalau beda
    end
end)

Tab:AddLabel("✅ Cara: Scan → Set Delays → Toggle ON → OP!")
Tab:AddLabel("Kalau remote NONE semua → Coba Poop Hub di atas (pasti ada).")

-- Test Tab
local TestTab = Window:AddTab("Test Manual")
TestTab:AddButton("Test Cast", function() scanRemotes() if castRemote then castRemote:FireServer() end end)
TestTab:AddButton("Test Complete", function() scanRemotes() if completeRemote then completeRemote:FireServer() end end)
