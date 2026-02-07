-- Load VinzHub Library
local Library = loadstring(game:HttpGet("https://script.vinzhub.com/library"))()

-- Create Window
local Window = Library:CreateWindow({
    Title = "Alamak Hub",
    Center = true,
    AutoShow = true
})

-- Create Tab
local MainTab = Window:AddTab("Main")

-- Create Section
local MainSection = MainTab:AddSection("Basic Features")

-- Toggle Example
MainSection:AddToggle("Hello Toggle", {
    Text = "Print Hello",
    Default = false
}):OnChanged(function(Value)
    if Value then
        print("Hello from Alamak Hub!")
    else
        print("Toggle Off")
    end
end)

-- Button Example
MainSection:AddButton("Test Button", function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "Alamak Hub",
        Text = "Button clicked!",
        Duration = 3
    })
end)
