local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

if #Players:GetPlayers() == 0 then Players.PlayerAdded:Wait() end
local targetPlayer = Players:GetPlayers()[1] 
if not targetPlayer then return end

local playerGui = targetPlayer:WaitForChild("PlayerGui")

local oldGui = playerGui:FindFirstChild("BrassMenuGui")
if oldGui then oldGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrassMenuGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 550, 0, 350)
mainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

local headerBar = Instance.new("Frame")
headerBar.Name = "HeaderBar"
headerBar.Size = UDim2.new(1, 0, 0, 45)
headerBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
headerBar.BorderSizePixel = 0
headerBar.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 8)
headerCorner.Parent = headerBar

local uigradient = Instance.new("UIGradient")
uigradient.Rotation = 90
uigradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(240, 180, 15)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
})
uigradient.Parent = headerBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -20, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "BRASS"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 20
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = headerBar

local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 140, 1, -45)
sidebar.Position = UDim2.new(0, 0, 0, 45)
sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.Padding = UDim.new(0, 4)
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.Parent = sidebar

local sidebarPadding = Instance.new("UIPadding")
sidebarPadding.PaddingTop = UDim.new(0, 10)
sidebarPadding.PaddingLeft = UDim.new(0, 8)
sidebarPadding.PaddingRight = UDim.new(0, 8)
sidebarPadding.Parent = sidebar

local containerWindow = Instance.new("Frame")
containerWindow.Name = "ContainerWindow"
containerWindow.Size = UDim2.new(1, -140, 1, -45)
containerWindow.Position = UDim2.new(0, 140, 0, 45)
containerWindow.BackgroundTransparency = 1
containerWindow.Parent = mainFrame

local firstTab = true

local function CreateNewTab(tabName)
	local pageFrame = Instance.new("ScrollingFrame")
	pageFrame.Name = tabName .. "Page"
	pageFrame.Size = UDim2.new(1, 0, 1, 0)
	pageFrame.BackgroundTransparency = 1
	pageFrame.BorderSizePixel = 0
	pageFrame.ScrollBarThickness = 4
	pageFrame.ScrollBarImageColor3 = Color3.fromRGB(240, 180, 15)
	pageFrame.Visible = firstTab
	pageFrame.Parent = containerWindow

	local pageLayout = Instance.new("UIListLayout")
	pageLayout.Padding = UDim.new(0, 8)
	pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	pageLayout.Parent = pageFrame

	local pagePadding = Instance.new("UIPadding")
	pagePadding.PaddingTop = UDim.new(0, 15)
	pagePadding.PaddingLeft = UDim.new(0, 15)
	pagePadding.Parent = pageFrame

	local tabButton = Instance.new("TextButton")
	tabButton.Name = tabName .. "Btn"
	tabButton.Size = UDim2.new(1, 0, 0, 32)
	tabButton.BackgroundColor3 = firstTab and Color3.fromRGB(240, 180, 15) or Color3.fromRGB(25, 25, 25)
	tabButton.Text = tabName
	tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	tabButton.Font = Enum.Font.GothamMedium
	tabButton.TextSize = 13
	tabButton.AutoButtonColor = false
	tabButton.Parent = sidebar

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = tabButton

	tabButton.MouseButton1Click:Connect(function()
		for _, child in ipairs(containerWindow:GetChildren()) do
			if child:IsA("ScrollingFrame") then child.Visible = false end
		end
		for _, btn in ipairs(sidebar:GetChildren()) do
			if btn:IsA("TextButton") then
				TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
			end
		end
		pageFrame.Visible = true
		TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(240, 180, 15)}):Play()
	end)

	firstTab = false
	return pageFrame
end

local function CreateCheckbox(parentPage, textName, callback)
	local checkboxFrame = Instance.new("Frame")
	checkboxFrame.Size = UDim2.new(0, 350, 0, 30)
	checkboxFrame.BackgroundTransparency = 1
	checkboxFrame.Parent = parentPage

	local box = Instance.new("TextButton")
	box.Size = UDim2.new(0, 18, 0, 18)
	box.Position = UDim2.new(0, 0, 0.5, -9)
	box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	box.BorderSizePixel = 1
	box.BorderColor3 = Color3.fromRGB(60, 60, 60)
	box.Text = ""
	box.Parent = checkboxFrame

	local boxCorner = Instance.new("UICorner")
	boxCorner.CornerRadius = UDim.new(0, 4)
	boxCorner.Parent = box

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -30, 1, 0)
	label.Position = UDim2.new(0, 28, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = textName
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = checkboxFrame

	local enabled = false
	box.MouseButton1Click:Connect(function()
		enabled = not enabled
		if enabled then
			TweenService:Create(box, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(240, 180, 15)}):Play()
			box.Text = "✓"
			box.TextColor3 = Color3.fromRGB(0, 0, 0)
		else
			TweenService:Create(box, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
			box.Text = ""
		end
		if callback then
			callback(enabled)
		end
	end)
end

local combatPage = CreateNewTab("Combat")
local movementPage = CreateNewTab("Movement")
local visualsPage = CreateNewTab("Visuals")
local settingsPage = CreateNewTab("Settings")

CreateCheckbox(combatPage, "Aimbot", function(state)
	print("Aimbot status:", state)
end)

CreateCheckbox(combatPage, "Triggerbot", function(state)
	print("Triggerbot status:", state)
end)

CreateCheckbox(movementPage, "Fly Hack", function(state)
	print("Fly status:", state)
end)

CreateCheckbox(movementPage, "Noclip", function(state)
	print("Noclip status:", state)
end)

CreateCheckbox(visualsPage, "2D Box ESP", function(state)
	print("ESP status:", state)
end)

CreateCheckbox(visualsPage, "Show FOV Circle", function(state)
	print("FOV status:", state)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		mainFrame.Visible = not mainFrame.Visible
	end
end)
