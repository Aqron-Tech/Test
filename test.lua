-- =============================================================================
-- 1. TARGET THE PLAYER (Server-Compatible)
-- =============================================================================
local Players = game:GetService("Players")

-- Grabs the first player currently loaded in your Studio playtest session
local targetPlayer = Players:GetPlayers()[1] 

if not targetPlayer then 
	warn("No player found in the game to show the UI to! Make sure you are in Play mode.")
	return 
end

-- =============================================================================
-- 2. CREATE THE MAIN SCREEN UI CONTAINER
-- =============================================================================
-- Clean up any old test UI if it already exists so they don't stack up
local oldGui = targetPlayer:WaitForChild("PlayerGui"):FindFirstChild("TestNotificationGui")
if oldGui then oldGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TestNotificationGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = targetPlayer:WaitForChild("PlayerGui")

-- =============================================================================
-- 3. CREATE THE BACKGROUND TAB (The Frame)
-- =============================================================================
local tabFrame = Instance.new("Frame")
tabFrame.Name = "NotificationTab"
tabFrame.Size = UDim2.new(0, 250, 0, 80)           -- Width: 250px, Height: 80px
tabFrame.Position = UDim2.new(0.5, -125, -0.2, 0)   -- Starts completely off-screen at the top
tabFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- Sleek dark gray background
tabFrame.BorderSizePixel = 0
tabFrame.Parent = screenGui

-- Add smooth rounded corners to the tab box
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = tabFrame

-- =============================================================================
-- 4. CREATE THE TEXT MESSAGE
-- =============================================================================
local messageText = Instance.new("TextLabel")
messageText.Size = UDim2.new(1, 0, 1, 0)
messageText.BackgroundTransparency = 1
messageText.Text = "It works!"
messageText.TextColor3 = Color3.fromRGB(255, 255, 255) -- Sharp white text
messageText.Font = Enum.Font.GothamBold
messageText.TextSize = 22
messageText.Parent = tabFrame

-- =============================================================================
-- 5. ANIMATE THE TAB (Tweening)
-- =============================================================================
task.wait(0.5) -- Tiny pause to let the environment settle

-- Smoothly slide down from the sky to the top center of the screen
tabFrame:TweenPosition(
	UDim2.new(0.5, -125, 0.05, 0), -- Target screen position (top center)
	Enum.EasingDirection.Out,
	Enum.EasingStyle.Quart,
	0.5,                          -- Animation lasts 0.5 seconds
	true
)

-- Keep the notification active on the screen for 4 seconds
task.wait(4)

-- Smoothly slide back up off-screen
tabFrame:TweenPosition(
	UDim2.new(0.5, -125, -0.2, 0), -- Return to hidden off-screen coordinates
	Enum.EasingDirection.In,
	Enum.EasingStyle.Quart,
	0.5,
	true
)

-- Automatically clear the UI elements out of memory once the animation finishes
task.wait(0.5)
screenGui:Destroy()
