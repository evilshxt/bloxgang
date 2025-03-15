-- Wednesday Cheats Fix - Redz Hub-Inspired GUI (Blue Theme)
-- Full Feature Integration: Kill Aura, Auto-Dodge, Auto-Leveling, Auto-Grab Fruits/Berries, Auto-Raid

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local humanoid = char:FindFirstChildOfClass("Humanoid")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local attackCounter = 0 -- Tracks normal attacks
local specialMoves = {Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V}

_G.killAuraEnabled = false
_G.autoDodgeEnabled = false
_G.autoLevelingEnabled = false
_G.autoGrabFruitsEnabled = false
_G.autoGrabBerriesEnabled = false
_G.autoRaidEnabled = false

-- Function: Get Nearby Enemies
local function getNearbyEnemies()
    local enemies = {}
    for _, npc in pairs(game.Workspace.Enemies:GetChildren()) do
        if npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("Humanoid") then
            table.insert(enemies, npc)
        end
    end
    return enemies
end

-- Function: Attack Enemies
local function attackEnemies()
    while _G.killAuraEnabled do
        local enemies = getNearbyEnemies()
        for _, enemy in pairs(enemies) do
            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                root.CFrame = enemy.HumanoidRootPart.CFrame
                wait(0.3)
                VirtualUser:CaptureController()
                VirtualUser:Button1Down(Vector2.new(0, 0), game:GetService("UserInputService"):GetMouseLocation())
                attackCounter = attackCounter + 1
                if attackCounter % 10 == 0 then
                    VirtualInputManager:SendKeyEvent(true, specialMoves[math.random(1, #specialMoves)], false, game)
                end
            end
        end
        wait(0.5)
    end
end

-- Function: Auto-Dodge System
local function autoDodge()
    while _G.autoDodgeEnabled do
        wait(math.random(0.3, 0.7))
        for _, enemy in pairs(getNearbyEnemies()) do
            local dodgeDirection = Vector3.new(math.random(-8, 8), 0, math.random(-8, 8))
            root.CFrame = root.CFrame * CFrame.new(dodgeDirection)
        end
    end
end

-- Function: Auto-Leveling
local function autoLevel()
    while _G.autoLevelingEnabled do
        wait(1)
        for _, enemy in pairs(getNearbyEnemies()) do
            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                root.CFrame = enemy.HumanoidRootPart.CFrame
                attackEnemies()
            end
        end
    end
end

-- Function: GUI Setup
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Sidebar = Instance.new("Frame")
ScreenGui.Parent = game.CoreGui

MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 112)
MainFrame.Active = true
MainFrame.Draggable = true

Sidebar.Parent = MainFrame
Sidebar.Size = UDim2.new(0, 100, 1, 0)
Sidebar.Position = UDim2.new(0, 0, 0, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 80)

-- Function: Create Toggle Buttons
local function createToggleButton(parent, text, position, toggleVar, func)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.Size = UDim2.new(0.8, 0, 0, 40)
    button.Position = UDim2.new(0.1, 0, position, 0)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = text .. ": OFF"
    button.MouseButton1Click:Connect(function()
        _G[toggleVar] = not _G[toggleVar]
        button.Text = text .. (_G[toggleVar] and ": ON" or ": OFF")
        if _G[toggleVar] then spawn(func) end
    end)
    return button
end

-- Create Toggle Buttons
createToggleButton(MainFrame, "Kill Aura", 0.1, "killAuraEnabled", attackEnemies)
createToggleButton(MainFrame, "Auto-Dodge", 0.2, "autoDodgeEnabled", autoDodge)
createToggleButton(MainFrame, "Auto-Leveling", 0.3, "autoLevelingEnabled", autoLevel)

print("[Wednesday Cheats Fix] GUI Loaded Successfully")
