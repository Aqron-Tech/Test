local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- FIX 1: Ensure localPlayer is found before moving forward
local localPlayer = Players.LocalPlayer
while not localPlayer do
    task.wait()
    localPlayer = Players.LocalPlayer
end

local playerGui = localPlayer:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MinimapGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local minimapFrame = Instance.new("Frame")
minimapFrame.Name = "MinimapFrame"
-- FIX 2: Fixed typo from UUD2 to UDim2
minimapFrame.Size = UDim2.new(0, 150, 0, 150) 
minimapFrame.Position = UDim2.new(0, 20, 1, -170)
minimapFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
minimapFrame.BorderSizePixel = 2
minimapFrame.ClipsDescendants = true
minimapFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(1, 0)
uiCorner.Parent = minimapFrame

local centerDot = Instance.new("Frame")
centerDot.Name = "CenterDot"
centerDot.Size = UDim2.new(0, 8, 0, 8)
centerDot.Position = UDim2.new(0.5, -4, 0.5, -4)
centerDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
centerDot.Parent = minimapFrame

local centerCorner = Instance.new("UICorner")
centerCorner.CornerRadius = UDim.new(1, 0)
centerCorner.Parent = centerDot

local blips = {}

local function createBlip(player)
	if player == localPlayer then return end
	
	local blip = Instance.new("Frame")
	blip.Name = player.Name .. "_Blip"
	blip.Size = UDim2.new(0, 6, 0, 6)
	blip.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	blip.Visible = false
	blip.Parent = minimapFrame
	
	local blipCorner = Instance.new("UICorner")
	blipCorner.CornerRadius = UDim.new(1, 0)
	blipCorner.Parent = blip
	
	blips[player] = blip
end

local function removeBlip(player)
	if blips[player] then
		blips[player]:Destroy()
		blips[player] = nil
	end
end

for _, player in ipairs(Players:GetPlayers()) do
	createBlip(player)
end

Players.PlayerAdded:Connect(createBlip)
Players.PlayerRemoving:Connect(removeBlip)

RunService.RenderStepped:Connect(function()
	local localCharacter = localPlayer.Character
	if not localCharacter then return end
	local localHRP = localCharacter:FindFirstChild("HumanoidRootPart")
	if not localHRP then return end
	
	local mapRadius = 75
	local scaleFactor = 0.5
	
	for player, blip in pairs(blips) do
		local character = player.Character
		local hrp = character and character:FindFirstChild("HumanoidRootPart")
		
		if hrp then
			local deltaX = hrp.Position.X - localHRP.Position.X
			local deltaZ = hrp.Position.Z - localHRP.Position.Z
			
			local screenX = deltaX * scaleFactor
			local screenY = deltaZ * scaleFactor
			
			local distanceFromCenter = math.sqrt(screenX^2 + screenY^2)
			
			if distanceFromCenter <= mapRadius - 3 then
				blip.Position = UDim2.new(0.5, screenX - 3, 0.5, screenY - 3)
				blip.Visible = true
			else
				blip.Visible = false
			end
		else
			blip.Visible = false
		end
	end
end)
