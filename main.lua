-- Obsidian UI Loader
local Obsidian = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Obsidian.lua"
))()

local Window = Obsidian:CreateWindow({
    Title = "ALAMAK HUB",
    Footer = "by amabar49-boop",
    Theme = "Dark",
    Size = UDim2.fromOffset(520, 360),
})

-- Tab
local MainTab = Window:AddTab({
    Title = "Main",
    Icon = "rbxassetid://4483345998"
})

-- Load features
loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/amabar49-boop/alamak/main/features.lua"
))()(MainTab)

Obsidian:Init()
