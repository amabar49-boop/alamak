-- Load VinzHub Library (pastikan koneksi bagus biar load)
local Library = loadstring(game:HttpGet("https://script.vinzhub.com/library"))()

local Window = Library:CreateWindow({
    Title = "Alamak Hub | Fish It Instant",
    Center = true,
    AutoShow = true
})

local Tab = Window:AddTab("Auto Fish")

local Section = Tab:AddSection("Instant Fishing (Coba Remote satu-satu)")

local enabled = false

Section:AddToggle("AutoFish", {
    Text = "Auto Cast + Instant Catch",
    Default = false
}):OnChanged(function(val)
    enabled = val
    if val then
        spawn(function()
            while enabled do
                -- VARIASI REMOTE (coba ganti satu per satu kalau gak work)
                local success, err = pcall(function()
                    -- Remote paling sering work di Fish It
                    game:GetService("ReplicatedStorage").Remotes.Cast:FireServer()   -- cast/lempar
                    wait(0.3)  -- tunggu sebentar biar bite
                    game:GetService("ReplicatedStorage").Remotes.Reel:FireServer("Instant")  -- atau tanpa arg
                    -- Alternatif lain (uncomment kalau atas gak jalan):
                    -- game:GetService("ReplicatedStorage").Remotes.Catch:FireServer()
                    -- game:GetService("ReplicatedStorage").Events.CatchFish:FireServer()
                    -- game:GetService("ReplicatedStorage").Remotes.FishHook:FireServer()
                end)
                if not success then
                    print("Remote error, coba ganti nama remote lain!")
                end
                wait(1.2 + math.random()*0.5)  -- delay biar mirip manusia + anti detect
            end
        end)
    end
end)

-- Tambahan Instant Sell (kalau ada)
Section:AddButton("Coba Auto Sell Sekali", function()
    pcall(function()
        game:GetService("ReplicatedStorage").Remotes.Sell:FireServer()
        -- atau game:GetService("ReplicatedStorage").Remotes.SellFish:FireServer("All")
    end)
end)

Tab:AddLabel("Cara pakai: Toggle ON → kalau gak jalan matiin, ganti nama remote di script (Cast/Reel/Catch), coba lagi.")
Tab:AddLabel("Remote biasa: Remotes.Cast, Remotes.Reel, Remotes.Catch")
Tab:AddLabel("Kalau masih error → coba script full hub di bawah (lebih gampang).")
