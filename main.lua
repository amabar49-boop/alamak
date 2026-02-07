getgenv().OBSIDIAN_PARENT = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local Obsidian = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"
))()

local Window = Obsidian:CreateWindow({
    Title = "ALAMAK HUB",
    Footer = "by amabar49-boop",
    Theme = "Dark",
    Size = UDim2.fromOffset(520, 360)
})

local MainTab = Window:AddTab({
    Title = "Main"
})

loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/amabar49-boop/alamak/main/features.lua"
))()(MainTab)

Obsidia
