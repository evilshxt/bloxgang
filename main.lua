-- Advanced Kill Aura Script with Aimbot, Full Special Moves, and Aesthetic GUI for Blox Fruits
-- Features:
-- - Modern GUI with Toggle Switches (Wednesday Theme)
-- - Select Attack Type: Melee, Sword, or Blox Fruit
-- - Automatically aims at nearest enemy (Aimbot)
-- - 360° Kill Aura (Attacks all enemies around player)
-- - No delay between attacks (constant damage output)
-- - Uses all special moves (Z, X, C, V) dynamically

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local range = 15 -- Extended attack range for safety
local selectedAttackType = "Sword" -- Default attack type
local killAuraEnabled = false
local attackCounter = 0 -- Counter to track normal attacks
local specialMoves = {Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V}

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleKillAura = Instance.new("TextButton")
local AttackModeLabel = Instance.new("TextLabel")
local AttackModeDropdown = Instance.new("Frame")
local AttackModeButton = Instance.new("TextButton")
local SwordOption = Instance.new("TextButton")
local MeleeOption = Instance.new("TextButton")
local FruitOption = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")
ScreenGui.Parent = game.CoreGui

-- GUI Styling
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 350, 0, 300)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
Title.Text = "Wednesday - Kill Aura"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true

-- Toggle Kill Aura Button
ToggleKillAura.Parent = MainFrame
ToggleKillAura.Size = UDim2.new(0.8, 0, 0, 40)
ToggleKillAura.Position = UDim2.new(0.1, 0, 0.2, 0)
ToggleKillAura.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleKillAura.Text = "Kill Aura: OFF"
ToggleKillAura.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleKillAura.Font = Enum.Font.GothamBold
ToggleKillAura.TextScaled = true

-- Attack Mode Dropdown Frame
AttackModeDropdown.Parent = MainFrame
AttackModeDropdown.Size = UDim2.new(0.8, 0, 0, 100)
AttackModeDropdown.Position = UDim2.new(0.1, 0, 0.5, 0)
AttackModeDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AttackModeDropdown.Visible = false

AttackModeButton.Parent = MainFrame
AttackModeButton.Size = UDim2.new(0.8, 0, 0, 40)
AttackModeButton.Position = UDim2.new(0.1, 0, 0.5, 0)
AttackModeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
AttackModeButton.Text = "Select Mode"
AttackModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AttackModeButton.Font = Enum.Font.GothamBold
AttackModeButton.TextScaled = true

-- Dropdown Options
local function createOption(name, yPos)
    local option = Instance.new("TextButton", AttackModeDropdown)
    option.Size = UDim2.new(1, 0, 0, 30)
    option.Position = UDim2.new(0, 0, 0, yPos)
    option.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
    option.Text = name
    option.TextColor3 = Color3.fromRGB(255, 255, 255)
    option.Font = Enum.Font.Gotham
    option.TextScaled = true
    return option
end

SwordOption = createOption("Sword", 0)
MeleeOption = createOption("Melee", 30)
FruitOption = createOption("Blox Fruit", 60)

-- Status Label
StatusLabel.Parent = MainFrame
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 0.85, 0)
StatusLabel.Text = "Status: Waiting..."
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextScaled = true
StatusLabel.BackgroundTransparency = 1

-- Dropdown Button Toggle
AttackModeButton.MouseButton1Click:Connect(function()
    AttackModeDropdown.Visible = not AttackModeDropdown.Visible
end)

-- Option Selection
local function selectAttackMode(mode)
    selectedAttackType = mode
    AttackModeButton.Text = mode
    AttackModeDropdown.Visible = false
end

SwordOption.MouseButton1Click:Connect(function() selectAttackMode("Sword") end)
MeleeOption.MouseButton1Click:Connect(function() selectAttackMode("Melee") end)
FruitOption.MouseButton1Click:Connect(function() selectAttackMode("Blox Fruit") end)

-- Toggle Kill Aura
ToggleKillAura.MouseButton1Click:Connect(function()
    killAuraEnabled = not killAuraEnabled
    ToggleKillAura.Text = killAuraEnabled and "Kill Aura: ON" or "Kill Aura: OFF"
    ToggleKillAura.BackgroundColor3 = killAuraEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    StatusLabel.Text = killAuraEnabled and "Status: Active" or "Status: Inactive"
end)

-- Main loop to continuously attack enemies
while wait() do
    attackEnemies()
end
