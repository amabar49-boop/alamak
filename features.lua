return function(Tab)

    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")

    local Player = Players.LocalPlayer
    local Event = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("DamageBlockEvent")
    local LuckyBlocksFolder = Workspace:WaitForChild("LuckyBlocks")

    local AutoBreak = false

    local function getTargetPos(obj)
        if obj:IsA("BasePart") then
            return obj.Position
        elseif obj:IsA("Model") then
            local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
            return part and part.Position
        end
    end

    -- TOGGLE UI
    Tab:AddToggle({
        Title = "Auto Break Block",
        Description = "Memecahkan Lucky Block otomatis",
        Default = false,
        Callback = function(Value)
            AutoBreak = Value
        end
    })

    -- LOOP
    task.spawn(function()
        while task.wait(0.1) do
            if not AutoBreak then continue end

            for _, block in ipairs(LuckyBlocksFolder:GetChildren()) do
                if not AutoBreak then break end

                local char = Player.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local pos = getTargetPos(block)

                if root and pos and block:IsDescendantOf(LuckyBlocksFolder) then
                    root.CFrame = CFrame.new(pos)

                    repeat
                        if not AutoBreak then break end
                        Event:FireServer(block)
                        task.wait()
                    until not block:IsDescendantOf(LuckyBlocksFolder)
                end
            end
        end
    end)
end
