-- Full Blox Fruits Exploit Script: Kill Aura, Auto-Dodge, Auto-Leveling, Auto-Grab Fruits & Berries, Auto-Raid System
-- Features:
-- - Aesthetic GUI (Wednesday Theme)
-- - Kill Aura with Aimbot & Special Moves
-- - Auto-Dodge System (Smart Evasion)
-- - Auto-Leveling (Auto-Quests, NPC Farming)
-- - Auto-Grab Devil Fruits (Detect & Collect)
-- - Auto-Grab Berries (Used for Haki Colors)
-- - Improved Kill Aura (Levitate Over Enemies, Tweened Movement)
-- - Auto-Detect Sea (Second or Third Sea)
-- - Auto-Raid System (Fully Automated Raiding with Tweened Movement Between Islands)

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local humanoid = char:FindFirstChildOfClass("Humanoid")
local range = 15 -- Attack range
local selectedAttackType = "Sword" -- Default attack type
local killAuraEnabled = false
local autoDodgeEnabled = false
local autoLevelingEnabled = false
local autoGrabFruitsEnabled = false
local autoGrabBerriesEnabled = false
local autoRaidEnabled = false
local attackCounter = 0 -- Tracks normal attacks
local specialMoves = {Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V}
local TweenService = game:GetService("TweenService")

-- Function: Detect Player's Current Sea
local function getCurrentSea()
    if game.Workspace:FindFirstChild("New World") then
        return "Third Sea"
    elseif game.Workspace:FindFirstChild("Mysterious Scientist") then
        return "Second Sea"
    else
        return "Unknown"
    end
end

local currentSea = getCurrentSea()
print("Detected Sea:", currentSea)

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleKillAura = Instance.new("TextButton")
local ToggleAutoDodge = Instance.new("TextButton")
local ToggleAutoLeveling = Instance.new("TextButton")
local ToggleAutoGrabFruits = Instance.new("TextButton")
local ToggleAutoGrabBerries = Instance.new("TextButton")
ScreenGui.Parent = game.CoreGui

-- GUI Styling
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 350, 0, 500)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
Title.Text = "Wednesday - Blox Fruits Exploit"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)

--- Function: Smooth Tween Movement to Target
local function moveToTarget(target)
    local goal = target.Position + Vector3.new(0, 10, 0) -- Levitate 10 studs above
    local tweenInfo = TweenInfo.new((root.Position - goal).Magnitude / 50, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(goal)})
    tween:Play()
    tween.Completed:Wait()
end

-- Function: Get Nearby Enemies
local function getNearbyEnemies()
    local enemies = {}
    for _, npc in pairs(game.Workspace.Enemies:GetChildren()) do
        if npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("Humanoid") then
            local distance = (root.Position - npc.HumanoidRootPart.Position).Magnitude
            if distance <= range then
                table.insert(enemies, npc)
            end
        end
    end
    return enemies
end

-- Function: Attack Enemies While Floating
local function attackEnemies()
    if not killAuraEnabled then return end
    local enemies = getNearbyEnemies()
    for _, enemy in pairs(enemies) do
        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
            moveToTarget(enemy.HumanoidRootPart) -- Smooth movement above the enemy
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):Button1Down(Vector2.new(0, 0))
            attackCounter = attackCounter + 1
            if attackCounter % 10 == 0 then
                keypress(specialMoves[math.random(1, #specialMoves)])
            end
        end
    end
end

-- Function: Aimbot (Auto-Lock on Enemy)
local function aimAtEnemy()
    local enemies = getNearbyEnemies()
    if #enemies > 0 then
        root.CFrame = CFrame.lookAt(root.Position, enemies[1].HumanoidRootPart.Position)
    end
end

-- Function: Auto-Dodge System
local function autoDodge()
    while autoDodgeEnabled do
        wait(0.2)
        if humanoid and humanoid.Health > 0 then
            for _, enemy in pairs(getNearbyEnemies()) do
                if math.random(1, 3) == 1 then -- Random dodge chance
                    root.CFrame = root.CFrame * CFrame.new(math.random(-5, 5), 0, math.random(-5, 5))
                end
            end
        end
    end
end

-- Function: Auto-Leveling System
local function getBestQuest()
    local quests = game.Workspace.Quests:GetChildren()
    for _, quest in pairs(quests) do
        if quest:FindFirstChild("LevelRequirement") and player.Data.Level.Value >= quest.LevelRequirement.Value then
            return quest
        end
    end
    return nil
end

local function autoLevel()
    while autoLevelingEnabled do
        wait(1)
        local quest = getBestQuest()
        if quest then
            root.CFrame = quest.HumanoidRootPart.CFrame
            wait(2)
            fireproximityprompt(quest.ProximityPrompt)
            wait(1)
        end
        for _, enemy in pairs(getNearbyEnemies()) do
            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                root.CFrame = enemy.HumanoidRootPart.CFrame
                wait(0.5)
                attackEnemies()
            end
        end
    end
end

-- Function: Auto-Grab Devil Fruits
local function autoGrabFruits()
    while autoGrabFruitsEnabled do
        wait(2)
        for _, fruit in pairs(game.Workspace:GetChildren()) do
            if fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
                root.CFrame = fruit.Handle.CFrame
                wait(1)
                firetouchinterest(root, fruit.Handle, 0)
                firetouchinterest(root, fruit.Handle, 1)
            end
        end
    end
end

-- Function: Auto-Grab Berries
local function autoGrabBerries()
    while autoGrabBerriesEnabled do
        wait(1)
        for _, berry in pairs(game.Workspace:GetChildren()) do
            if berry.Name == "Berries" and berry:FindFirstChild("Handle") then
                root.CFrame = berry.Handle.CFrame
                wait(0.5)
                firetouchinterest(root, berry.Handle, 0)
                firetouchinterest(root, berry.Handle, 1)
            end
        end
    end
end

-- Function: Auto-Buy Microchip
local function buyMicrochip()
    local scientist = game.Workspace:FindFirstChild("Mysterious Scientist")
    if scientist then
        moveToTarget(scientist.HumanoidRootPart.Position)
        wait(2)
        fireproximityprompt(scientist.ProximityPrompt)
    end
end

-- Function: Auto-Start Raid
local function startRaid()
    local platform = game.Workspace:FindFirstChild("RaidPlatform")
    if platform then
        moveToTarget(platform.Position)
        wait(2)
        fireproximityprompt(platform.ProximityPrompt)
    end
end

-- Function: Move to Next Island in Raid
local function moveToNextRaidIsland()
    local islands = game.Workspace:FindFirstChild("RaidIslands")
    if islands then
        for _, island in pairs(islands:GetChildren()) do
            moveToTarget(island.Position)
            wait(1)
        end
    end
end

-- Function: Auto-Fight Raid Waves
local function fightRaid()
    while autoRaidEnabled do
        wait(1)
        local enemies = game.Workspace.Enemies:GetChildren()
        for _, enemy in pairs(enemies) do
            if enemy:FindFirstChild("HumanoidRootPart") then
                moveToTarget(enemy.HumanoidRootPart.Position + Vector3.new(0, 10, 0))
                wait(0.5)
                attackEnemies()
            end
        end
        moveToNextRaidIsland() -- Move to next island after waves are cleared
    end
end

-- Function: Auto-Raid System
local function autoRaidSystem()
    while autoRaidEnabled do
        wait(2)
        print("Auto-Raiding in:", currentSea)
        buyMicrochip()
        startRaid()
        wait(5)
        fightRaid()
    end
end

-- GUI Setup for Auto-Raid System
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleAutoRaid = Instance.new("TextButton")
ScreenGui.Parent = game.CoreGui

MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 350, 0, 600)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

ToggleAutoRaid.Parent = MainFrame
ToggleAutoRaid.Size = UDim2.new(0.8, 0, 0, 40)
ToggleAutoRaid.Position = UDim2.new(0.1, 0, 0.8, 0)
ToggleAutoRaid.Text = "Auto Raid: OFF"
ToggleAutoRaid.MouseButton1Click:Connect(function()
    autoRaidEnabled = not autoRaidEnabled
    ToggleAutoRaid.Text = autoRaidEnabled and "Auto Raid: ON" or "Auto Raid: OFF"
    if autoRaidEnabled then spawn(autoRaidSystem) end
end)

-- Button: Auto-Grab Fruits Toggle
ToggleAutoGrabFruits.Parent = MainFrame
ToggleAutoGrabFruits.Size = UDim2.new(0.8, 0, 0, 40)
ToggleAutoGrabFruits.Position = UDim2.new(0.1, 0, 0.5, 0)
ToggleAutoGrabFruits.Text = "Auto-Grab Fruits: OFF"
ToggleAutoGrabFruits.MouseButton1Click:Connect(function()
    autoGrabFruitsEnabled = not autoGrabFruitsEnabled
    ToggleAutoGrabFruits.Text = autoGrabFruitsEnabled and "Auto-Grab Fruits: ON" or "Auto-Grab Fruits: OFF"
    if autoGrabFruitsEnabled then spawn(autoGrabFruits) end
end)

-- Button: Auto-Grab Berries Toggle
ToggleAutoGrabBerries.Parent = MainFrame
ToggleAutoGrabBerries.Size = UDim2.new(0.8, 0, 0, 40)
ToggleAutoGrabBerries.Position = UDim2.new(0.1, 0, 0.6, 0)
ToggleAutoGrabBerries.Text = "Auto-Grab Berries: OFF"
ToggleAutoGrabBerries.MouseButton1Click:Connect(function()
    autoGrabBerriesEnabled = not autoGrabBerriesEnabled
    ToggleAutoGrabBerries.Text = autoGrabBerriesEnabled and "Auto-Grab Berries: ON" or "Auto-Grab Berries: OFF"
    if autoGrabBerriesEnabled then spawn(autoGrabBerries) end
end)


-- Button: Kill Aura Toggle
ToggleKillAura.Parent = MainFrame
ToggleKillAura.Size = UDim2.new(0.8, 0, 0, 40)
ToggleKillAura.Position = UDim2.new(0.1, 0, 0.2, 0)
ToggleKillAura.Text = "Kill Aura: OFF"
ToggleKillAura.MouseButton1Click:Connect(function()
    killAuraEnabled = not killAuraEnabled
    ToggleKillAura.Text = killAuraEnabled and "Kill Aura: ON" or "Kill Aura: OFF"
end)

-- Button: Auto-Dodge Toggle
ToggleAutoDodge.Parent = MainFrame
ToggleAutoDodge.Size = UDim2.new(0.8, 0, 0, 40)
ToggleAutoDodge.Position = UDim2.new(0.1, 0, 0.3, 0)
ToggleAutoDodge.Text = "Auto-Dodge: OFF"
ToggleAutoDodge.MouseButton1Click:Connect(function()
    autoDodgeEnabled = not autoDodgeEnabled
    ToggleAutoDodge.Text = autoDodgeEnabled and "Auto-Dodge: ON" or "Auto-Dodge: OFF"
    if autoDodgeEnabled then spawn(autoDodge) end
end)

-- Button: Auto-Leveling Toggle
ToggleAutoLeveling.Parent = MainFrame
ToggleAutoLeveling.Size = UDim2.new(0.8, 0, 0, 40)
ToggleAutoLeveling.Position = UDim2.new(0.1, 0, 0.4, 0)
ToggleAutoLeveling.Text = "Auto-Leveling: OFF"
ToggleAutoLeveling.MouseButton1Click:Connect(function()
    autoLevelingEnabled = not autoLevelingEnabled
    ToggleAutoLeveling.Text = autoLevelingEnabled and "Auto-Leveling: ON" or "Auto-Leveling: OFF"
    if autoLevelingEnabled then spawn(autoLevel) end
end)

-- Main Loop
while wait() do
    attackEnemies()
end
