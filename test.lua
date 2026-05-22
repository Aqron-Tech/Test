-- 1. Create the Main Screen UI Container
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TestNotificationGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- 2. Create the Background Tab (The Frame)
local tabFrame = Instance.new("Frame")
tabFrame.Name = "NotificationTab"
tabFrame.Size = UDim2.new(0, 250, 0, 80) -- Width: 250px, Height: 80px
tabFrame.Position = UDim2.new(0.5, -125, -0.2, 0) -- Starts off-screen at the top
tabFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- Sleek dark gray
tabFrame.BorderSizePixel = 0
tabFrame.Parent = screenGui

-- Add rounded corners to the tab
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = tabFrame

-- 3. Create the Text Message
local messageText = Instance.new("TextLabel")
messageText.Size = UDim2.new(1, 0, 1, 0)
messageText.BackgroundTransparency = 1
messageText.Text = "It works!"
messageText.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
messageText.Font = Enum.Font.GothamBold
messageText.TextSize = 20
messageText.Parent = tabFrame

-- 4. Animate the Tab onto the Screen (Tweening)
task.wait(1) -- Wait 1 second after spawning

-- Smoothly slide down from the top center
tabFrame:TweenPosition(
	UDim2.new(0.5, -125, 0.05, 0), -- Target position (top center of screen)
	Enum.EasingDirection.Out,
	Enum.EasingStyle.Quart,
	0.5, -- Takes half a second to animate
	true
)

-- Wait 3 seconds, then smoothly slide back off-screen
task.wait(3)
tabFrame:TweenPosition(
	UDim2.new(0.5, -125, -0.2, 0),
	Enum.EasingDirection.In,
	Enum.EasingStyle.Quart,
	0.5,
	true
)
