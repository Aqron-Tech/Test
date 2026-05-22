--  ROBLOX MINIMAP SCRIPT
--  Usage: loadstring(game:HttpGet("YOUR_RAW_GITHUB_URL"))()
--  Place this as a LocalScript in StarterPlayerScripts,
--  or run via loadstring from the Command Bar / another script.
-- ============================================================
 
local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")
local StarterGui    = game:GetService("StarterGui")
 
local localPlayer   = Players.LocalPlayer
local playerGui     = localPlayer:WaitForChild("PlayerGui")
 
-- ============================================================
--  CONFIG  (tweak these to your liking)
-- ============================================================
local CONFIG = {
    -- Minimap size in pixels
    MAP_SIZE        = 200,
 
    -- World area the minimap covers (studs). 
    -- Increase for bigger maps, decrease for small arenas.
    WORLD_RANGE     = 500,
 
    -- Position offset from the bottom-left corner
    PADDING         = 16,
 
    -- Dot sizes
    LOCAL_DOT_SIZE  = 10,
    OTHER_DOT_SIZE  = 8,
 
    -- Colors
    MAP_BG          = Color3.fromRGB(20,  20,  20),
    MAP_BORDER      = Color3.fromRGB(80,  80,  80),
    LOCAL_COLOR     = Color3.fromRGB(0,   220, 100),   -- green = you
    OTHER_COLOR     = Color3.fromRGB(220, 50,  50),    -- red   = others
    LABEL_COLOR     = Color3.fromRGB(255, 255, 255),
 
    -- Update rate (seconds between refreshes)
    UPDATE_RATE     = 0.05,
}
 
-- ============================================================
--  GUI SETUP
-- ============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name              = "MinimapGui"
screenGui.ResetOnSpawn      = false
screenGui.ZIndexBehavior    = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset    = true
screenGui.Parent            = playerGui
 
-- Outer frame (map background)
local mapFrame = Instance.new("Frame")
mapFrame.Name               = "MapFrame"
mapFrame.Size               = UDim2.new(0, CONFIG.MAP_SIZE, 0, CONFIG.MAP_SIZE)
mapFrame.Position           = UDim2.new(
    0, CONFIG.PADDING,
    1, -(CONFIG.MAP_SIZE + CONFIG.PADDING)
)
mapFrame.BackgroundColor3   = CONFIG.MAP_BG
mapFrame.BorderSizePixel    = 0
mapFrame.ClipsDescendants   = true
mapFrame.Parent             = screenGui
 
-- Rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent       = mapFrame
 
-- Border stroke
local stroke = Instance.new("UIStroke")
stroke.Color        = CONFIG.MAP_BORDER
stroke.Thickness    = 2
stroke.Parent       = mapFrame
 
-- "MINIMAP" label at the top of the frame
local titleLabel = Instance.new("TextLabel")
titleLabel.Size                 = UDim2.new(1, 0, 0, 18)
titleLabel.Position             = UDim2.new(0, 0, 0, 4)
titleLabel.BackgroundTransparency = 1
titleLabel.Text                 = "MINIMAP"
titleLabel.TextColor3           = CONFIG.LABEL_COLOR
titleLabel.TextSize             = 11
titleLabel.Font                 = Enum.Font.GothamBold
titleLabel.TextTransparency     = 0.4
titleLabel.Parent               = mapFrame
 
-- Crosshair lines (centre reference)
local function makeLine(isHorizontal)
    local line = Instance.new("Frame")
    line.BackgroundColor3   = Color3.fromRGB(255, 255, 255)
    line.BackgroundTransparency = 0.85
    line.BorderSizePixel    = 0
    if isHorizontal then
        line.Size       = UDim2.new(1, 0, 0, 1)
        line.Position   = UDim2.new(0, 0, 0.5, 0)
    else
        line.Size       = UDim2.new(0, 1, 1, 0)
        line.Position   = UDim2.new(0.5, 0, 0, 0)
    end
    line.Parent = mapFrame
    return line
end
makeLine(true)
makeLine(false)
 
-- ============================================================
--  DOT POOL  (we recycle frames to avoid GC pressure)
-- ============================================================
local dotPool   = {}   -- { frame, nameLabel }
local activeDots = {}  -- keyed by Player
 
local function getDot()
    if #dotPool > 0 then
        return table.remove(dotPool)
    end
 
    local dot = Instance.new("Frame")
    dot.BorderSizePixel     = 0
    dot.BackgroundColor3    = CONFIG.OTHER_COLOR
    dot.AnchorPoint         = Vector2.new(0.5, 0.5)
    dot.ZIndex              = 5
    dot.Parent              = mapFrame
 
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius  = UDim.new(1, 0)
    dotCorner.Parent        = dot
 
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size              = UDim2.new(0, 60, 0, 14)
    nameLabel.Position          = UDim2.new(0.5, -30, 0, -16)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3        = CONFIG.LABEL_COLOR
    nameLabel.TextSize          = 9
    nameLabel.Font              = Enum.Font.GothamBold
    nameLabel.TextTransparency  = 0.15
    nameLabel.Text              = ""
    nameLabel.ZIndex            = 6
    nameLabel.Parent            = dot
 
    return { frame = dot, label = nameLabel }
end
 
local function releaseDot(dotData)
    dotData.frame.Visible = false
    table.insert(dotPool, dotData)
end
 
-- ============================================================
--  WORLD → MAP COORDINATE CONVERSION
-- ============================================================
--  We use the LOCAL player's position as the map centre,
--  so the minimap always follows the local character.
-- ============================================================
local function worldToMap(worldPos, centrePos)
    local dx =  (worldPos.X - centrePos.X) / CONFIG.WORLD_RANGE   --  -1 .. 1
    local dz =  (worldPos.Z - centrePos.Z) / CONFIG.WORLD_RANGE   --  -1 .. 1
 
    -- Clamp so dots don't escape the frame
    dx = math.clamp(dx, -0.48, 0.48)
    dz = math.clamp(dz, -0.48, 0.48)
 
    -- UDim2 uses (0,0) = top-left; +X = right, +Z = down on the map
    return UDim2.new(0.5 + dx, 0, 0.5 + dz, 0)
end
 
-- ============================================================
--  UPDATE LOOP
-- ============================================================
local timeSinceUpdate = 0
 
RunService.Heartbeat:Connect(function(dt)
    timeSinceUpdate = timeSinceUpdate + dt
    if timeSinceUpdate < CONFIG.UPDATE_RATE then return end
    timeSinceUpdate = 0
 
    -- Get local character root
    local localChar  = localPlayer.Character
    local localRoot  = localChar and localChar:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end
 
    local centrePos = localRoot.Position
 
    -- Track which players we've drawn this frame
    local seen = {}
 
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            seen[player] = true
 
            -- Get or create dot
            if not activeDots[player] then
                activeDots[player] = getDot()
            end
            local dotData = activeDots[player]
            local isLocal = (player == localPlayer)
 
            local size = isLocal and CONFIG.LOCAL_DOT_SIZE or CONFIG.OTHER_DOT_SIZE
            dotData.frame.Size          = UDim2.new(0, size, 0, size)
            dotData.frame.BackgroundColor3 = isLocal and CONFIG.LOCAL_COLOR or CONFIG.OTHER_COLOR
            dotData.frame.Position      = worldToMap(root.Position, centrePos)
            dotData.frame.Visible       = true
            dotData.label.Text          = isLocal and "YOU" or player.Name
        end
    end
 
    -- Release dots for players no longer visible
    for player, dotData in pairs(activeDots) do
        if not seen[player] then
            releaseDot(dotData)
            activeDots[player] = nil
        end
    end
end)
 
-- ============================================================
--  CLEAN UP ON CHARACTER REMOVAL / SCRIPT DESTROY
-- ============================================================
screenGui.Destroying:Connect(function()
    for _, dotData in pairs(activeDots) do
        dotData.frame:Destroy()
    end
end)
 
print("[Minimap] Loaded successfully! Range: " .. CONFIG.WORLD_RANGE .. " studs.")
