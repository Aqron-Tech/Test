local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

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

local function CreateSlider(parentPage, textName, min, max, default, callback)
	local sliderFrame = Instance.new("Frame")
	sliderFrame.Size = UDim2.new(0, 350, 0, 40)
	sliderFrame.BackgroundTransparency = 1
	sliderFrame.Parent = parentPage

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 20)
	label.BackgroundTransparency = 1
	label.Text = textName .. ": " .. tostring(default)
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = sliderFrame

	local track = Instance.new("TextButton")
	track.Size = UDim2.new(0, 200, 0, 6)
	track.Position = UDim2.new(0, 0, 0, 25)
	track.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	track.BorderSizePixel = 0
	track.Text = ""
	track.AutoButtonColor = false
	track.Parent = sliderFrame

	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = UDim.new(0, 3)
	trackCorner.Parent = track

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(240, 180, 15)
	fill.BorderSizePixel = 0
	fill.Parent = track

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 3)
	fillCorner.Parent = fill

	local holding = false

	local function updateSlider()
		local mousePos = UserInputService:GetMouseLocation().X
		local trackPos = track.AbsolutePosition.X
		local trackWidth = track.AbsoluteSize.X
		local percentage = math.clamp((mousePos - trackPos) / trackWidth, 0, 1)
		fill.Size = UDim2.new(percentage, 0, 1, 0)
		local value = math.round(min + (max - min) * percentage)
		label.Text = textName .. ": " .. tostring(value)
		if callback then callback(value) end
	end

	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			holding = true
			updateSlider()
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			holding = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if holding and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateSlider()
		end
	end)
end

local combatPage = CreateNewTab("Combat")
local movementPage = CreateNewTab("Movement")
local visualsPage = CreateNewTab("Visuals")
local settingsPage = CreateNewTab("Settings")

local walkSpeedActive = false
local targetWalkSpeed = 16
local baseWalkSpeed = 16

local jumpPowerActive = false
local targetJumpPower = 50
local baseJumpPower = 50

local espActive = false
local fovActive = false
local fovRadius = 100

local fovCircle = Drawing.new("Circle")
fovCircle.Color = Color3.fromRGB(240, 180, 15)
fovCircle.Thickness = 1
fovCircle.NumSides = 64
fovCircle.Filled = false
fovCircle.Visible = false

local function handleCharacter(character)
	local humanoid = character:WaitForChild("Humanoid", 10)
	if humanoid then
		baseWalkSpeed = humanoid.WalkSpeed
		baseJumpPower = humanoid.JumpPower
		
		humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
			if walkSpeedActive and humanoid.WalkSpeed ~= targetWalkSpeed then
				humanoid.WalkSpeed = targetWalkSpeed
			end
		end)
		
		humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
			if jumpPowerActive and humanoid.JumpPower ~= targetJumpPower then
				humanoid.JumpPower = targetJumpPower
			end
		end)
		
		if walkSpeedActive then humanoid.WalkSpeed = targetWalkSpeed end
		if jumpPowerActive then humanoid.JumpPower = targetJumpPower end
	end
end

if targetPlayer.Character then
	task.spawn(handleCharacter, targetPlayer.Character)
end
targetPlayer.CharacterAdded:Connect(handleCharacter)

CreateCheckbox(movementPage, "Modify WalkSpeed", function(state)
	walkSpeedActive = state
	local character = targetPlayer.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = state and targetWalkSpeed or 16
		end
	end
end)

CreateSlider(movementPage, "Speed Value", 16, 150, 50, function(value)
	targetWalkSpeed = value
	if walkSpeedActive then
		local character = targetPlayer.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then humanoid.WalkSpeed = value end
		end
	end
end)

CreateCheckbox(movementPage, "Modify JumpPower", function(state)
	jumpPowerActive = state
	local character = targetPlayer.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.JumpPower = state and targetJumpPower or 50
		end
	end
end)

CreateSlider(movementPage, "Jump Value", 50, 300, 100, function(value)
	targetJumpPower = value
	if jumpPowerActive then
		local character = targetPlayer.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then humanoid.JumpPower = value end
		end
	end
end)

CreateCheckbox(visualsPage, "Show FOV Circle", function(state)
	fovActive = state
	fovCircle.Visible = state
end)

CreateSlider(visualsPage, "FOV Size", 30, 400, 100, function(value)
	fovRadius = value
	fovCircle.Radius = value
end)

local function cleanEsp(player)
	local char = player.Character
	if char then
		local highlight = char:FindFirstChild("BrassEspHighlight")
		if highlight then highlight:Destroy() end
		local billboard = char:FindFirstChild("BrassEspTag")
		if billboard then billboard:Destroy() end
	end
end

local function applyEsp(player)
	if player == targetPlayer then return end
	
	local function updateCharacter(char)
		if not espActive then return end
		
		local highlight = char:FindFirstChild("BrassEspHighlight") or Instance.new("Highlight")
		highlight.Name = "BrassEspHighlight"
		highlight.FillColor = Color3.fromRGB(240, 180, 15)
		highlight.FillTransparency = 0.5
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		highlight.OutlineTransparency = 0
		highlight.Adornee = char
		highlight.Parent = char

		local head = char:WaitForChild("Head", 10)
		if head then
			local billboard = char:FindFirstChild("BrassEspTag") or Instance.new("BillboardGui")
			billboard.Name = "BrassEspTag"
			billboard.Size = UDim2.new(0, 100, 0, 30)
			billboard.AlwaysOnTop = true
			billboard.ExtentsOffset = Vector3.new(0, 2, 0)
			billboard.Adornee = head
			
			local textLabel = billboard:FindFirstChild("NameLabel") or Instance.new("TextLabel")
			textLabel.Name = "NameLabel"
			textLabel.Size = UDim2.new(1, 0, 1, 0)
			textLabel.BackgroundTransparency = 1
			textLabel.Text = player.Name
			textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			textLabel.Font = Enum.Font.GothamBold
			textLabel.TextSize = 12
			textLabel.Parent = billboard
			
			billboard.Parent = char
		end
	end

	if player.Character then task.spawn(updateCharacter, player.Character) end
	player.CharacterAdded:Connect(updateCharacter)
end

CreateCheckbox(visualsPage, "Highlight ESP", function(state)
	espActive = state
	if state then
		for _, player in ipairs(Players:GetPlayers()) do
			applyEsp(player)
		end
	else
		for _, player in ipairs(Players:GetPlayers()) do
			cleanEsp(player)
		end
	end
end)

Players.PlayerAdded:Connect(function(player)
	if espActive then
		applyEsp(player)
	end
end)

Players.PlayerRemoving:Connect(cleanEsp)

RunService.RenderStepped:Connect(function()
	if fovActive then
		fovCircle.Position = UserInputService:GetMouseLocation()
	end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		mainFrame.Visible = not mainFrame.Visible
	end
end)
