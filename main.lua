-- Full Blox Fruits Exploit Script: Kill Aura, Auto-Dodge, Auto-Leveling
-- Features:
-- - Aesthetic GUI (Wednesday Theme)
-- - Kill Aura with Aimbot & Special Moves
-- - Auto-Dodge System (Smart Evasion)
-- - Auto-Leveling (Auto-Quests, NPC Farming)

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local humanoid = char:FindFirstChildOfClass("Humanoid")
local range = 15 -- Attack range
local selectedAttackType = "Sword" -- Default attack type
local killAuraEnabled = false
local autoDodgeEnabled = false
local autoLevelingEnabled = false
local attackCounter = 0 -- Tracks normal attacks
local specialMoves = {Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V}

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleKillAura = Instance.new("TextButton")
local ToggleAutoDodge = Instance.new("TextButton")
local ToggleAutoLeveling = Instance.new("TextButton")
ScreenGui.Parent = game.CoreGui

-- GUI Styling
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
Title.Text = "Wednesday - Blox Fruits Exploit"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)

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

-- Function: Aimbot (Auto-Lock on Enemy)
local function aimAtEnemy()
    local enemies = getNearbyEnemies()
    if #enemies > 0 then
        root.CFrame = CFrame.lookAt(root.Position, enemies[1].HumanoidRootPart.Position)
    end
end

-- Function: Attack Enemies
local function attackEnemies()
    if not killAuraEnabled then return end
    aimAtEnemy()
    for _, enemy in pairs(getNearbyEnemies()) do
        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):Button1Down(Vector2.new(0, 0))
            attackCounter = attackCounter + 1
            if attackCounter % 10 == 0 then
                keypress(specialMoves[math.random(1, #specialMoves)])
            end
        end
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

while wait() do
    if killAuraEnabled then
        attackEnemies()
    end
end
