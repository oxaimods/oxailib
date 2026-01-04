-- Services
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- ===== WAIT FOR PlayerGui =====
local playerGui = player:WaitForChild("PlayerGui")

-- ===== FIND OR CREATE ScreenGui =====
local screenGui = playerGui:FindFirstChild("ScreenGui")
if not screenGui then
	screenGui = Instance.new("ScreenGui")
	screenGui.Name = "ScreenGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui
end

-- ===== CLEAR OLD CONTENT =====
for _, child in ipairs(screenGui:GetChildren()) do
	child:Destroy()
end

-- ===== MAIN FRAME =====
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 800, 0, 400)
frame.Position = UDim2.new(0.5, -375, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 0
frame.Visible = true
frame.Parent = screenGui

-- Rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- ===== TITLE =====
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "oxai client <3"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- ===== TOP LINE =====
local line = Instance.new("Frame")
line.Size = UDim2.new(1, 0, 0, 2)
line.Position = UDim2.new(0, 0, 0, 40)
line.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
line.BorderSizePixel = 0
line.Parent = frame

-- ===== TAB MODULE BUTTON SYSTEM =====
local moduleButtons = {} -- store buttons per tab

-- Parameters
local moduleWidth = 180
local moduleHeight = 80
local moduleSpacingX = 10
local moduleSpacingY = 10
local modulesPerRow = 3 -- now 3 per row
local toggleColor = Color3.fromRGB(39, 212, 245) -- glow when ON

-- Function to add a button to a specific tab
function addButton(tabFrame, name, functionOn, functionOff)
	if not moduleButtons[tabFrame] then
		moduleButtons[tabFrame] = {} -- initialize table for this tab
	end

	local buttons = moduleButtons[tabFrame]
	local index = #buttons + 1
	local row = math.floor((index - 1) / modulesPerRow)
	local col = (index - 1) % modulesPerRow

	-- Create module frame
	local module = Instance.new("Frame")
	module.Size = UDim2.new(0, moduleWidth, 0, moduleHeight)
	module.Position = UDim2.new(0, 10 + col * (moduleWidth + moduleSpacingX), 0, 10 + row * (moduleHeight + moduleSpacingY))
	module.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	module.BorderSizePixel = 0
	module.Parent = tabFrame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = module

	-- Name label (top-left)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -10, 0, 25)
	label.Position = UDim2.new(0, 5, 0, 5)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextSize = 16
	label.Font = Enum.Font.GothamSemibold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.Parent = module

	-- Separator line
	local line = Instance.new("Frame")
	line.Size = UDim2.new(1, -10, 0, 2)
	line.Position = UDim2.new(0, 5, 0, 30)
	line.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
	line.BorderSizePixel = 0
	line.Parent = module

	-- Toggle button (bottom-right)
	local toggle = Instance.new("TextButton") -- must be TextButton for click detection
	toggle.Size = UDim2.new(0, 20, 0, 20)
	toggle.Position = UDim2.new(1, -25, 1, -25)
	toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	toggle.BorderSizePixel = 0
	toggle.Text = ""
	toggle.Parent = module

	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(0, 4)
	toggleCorner.Parent = toggle

	local toggleOn = false

	local function updateToggle()
		if toggleOn then
			toggle.BackgroundColor3 = toggleColor
			toggle.BackgroundTransparency = 0
		else
			toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		end
	end

	updateToggle()

	-- Click to toggle
	toggle.MouseButton1Click:Connect(function()
		toggleOn = not toggleOn
		updateToggle()

		if toggleOn then
			if functionOn then pcall(functionOn) end
		else
			if functionOff then pcall(functionOff) end
		end
	end)

	table.insert(buttons, module)
	return module
end


-- ===== SIDE BUTTON SYSTEM (Always One Tab Open + Highlight) =====
local sideButtons = {} -- for layout
local sideButtonStartY = 45
local sideButtonSpacing = 10
local sideButtonWidth = 180
local sideButtonHeight = 50
local activeTabs = {} -- track all tabs
local activeButtonColor = Color3.fromRGB(39, 212, 245)
local defaultButtonColor = Color3.fromRGB(40, 40, 40)

function addSideButton(buttonName, tabParent)
	-- Calculate Y position automatically
	local posY = sideButtonStartY
	if #sideButtons > 0 then
		local lastButton = sideButtons[#sideButtons]
		posY = lastButton.Position.Y.Offset + sideButtonHeight + sideButtonSpacing
	end

	-- Create button
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, sideButtonWidth, 0, sideButtonHeight)
	button.Position = UDim2.new(0, 15, 0, posY)
	button.BackgroundColor3 = defaultButtonColor
	button.BorderSizePixel = 0
	button.Text = buttonName
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextSize = 16
	button.Font = Enum.Font.GothamSemibold
	button.TextXAlignment = Enum.TextXAlignment.Center
	button.TextYAlignment = Enum.TextYAlignment.Center
	button.Parent = frame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = button

	-- Optional: tab exclusivity
	if tabParent then
		tabParent.Visible = false
		table.insert(activeTabs, {tab = tabParent, button = button})

		button.MouseButton1Click:Connect(function()
			-- If this tab is already active, do nothing
			if tabParent.Visible then return end

			-- Hide all other tabs
			for _, data in ipairs(activeTabs) do
				if data.tab ~= tabParent then
					data.tab.Visible = false
					data.button.BackgroundColor3 = defaultButtonColor
				end
			end

			-- Show clicked tab
			tabParent.Visible = true
			button.BackgroundColor3 = activeButtonColor
		end)
	end

	table.insert(sideButtons, button)
	return button
end

-- ===== OPTIONAL: Open first tab automatically =====
-- Call this after creating all buttons
if #activeTabs > 0 then
	local firstTab = activeTabs[1]
	firstTab.tab.Visible = true
	firstTab.button.BackgroundColor3 = activeButtonColor
end


-- ===== PROFILE BOX =====
local profileBox = Instance.new("Frame")
profileBox.Size = UDim2.new(0, 180, 0, 50) -- smaller width and height
profileBox.Position = UDim2.new(0, 15, 1, -65) -- adjust position slightly
profileBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
profileBox.BorderSizePixel = 0
profileBox.Parent = frame

local profileCorner = Instance.new("UICorner")
profileCorner.CornerRadius = UDim.new(0, 8) -- slightly smaller radius
profileCorner.Parent = profileBox

-- Avatar
local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.new(0, 35, 0, 35) -- smaller avatar
avatar.Position = UDim2.new(0, 8, 0.5, -17.5)
avatar.BackgroundTransparency = 1
avatar.Parent = profileBox

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0)
avatarCorner.Parent = avatar

-- Username
local username = Instance.new("TextLabel")
username.Size = UDim2.new(1, -50, 1, 0) -- adjust text width
username.Position = UDim2.new(0, 45, 0, 0)
username.BackgroundTransparency = 1
username.Text = player.Name
username.TextColor3 = Color3.fromRGB(255, 255, 255)
username.TextSize = 16 -- smaller text
username.Font = Enum.Font.GothamSemibold
username.TextXAlignment = Enum.TextXAlignment.Left
username.TextYAlignment = Enum.TextYAlignment.Center
username.Parent = profileBox

-- Load avatar thumbnail
task.spawn(function()
	local image = Players:GetUserThumbnailAsync(
		player.UserId,
		Enum.ThumbnailType.HeadShot,
		Enum.ThumbnailSize.Size100x100
	)
	avatar.Image = image
end)


-- ===== DRAGGING =====
local dragging = false
local dragStart
local startPos

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

local TweenService = game:GetService("TweenService")

-- ===== INSERT TOGGLE WITH SLIDE + FADE =====
local menuVisible = true -- track visibility

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.Insert then
		menuVisible = not menuVisible

		if menuVisible then
			-- Show menu: fade in and glide back to center
			local fadeTween = TweenService:Create(
				frame,
				TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ Position = UDim2.new(0.5, -375, 0.5, -200), BackgroundTransparency = 0 }
			)
			fadeTween:Play()
		else
			-- Hide menu: glide off bottom and fade out
			local hideTween = TweenService:Create(
				frame,
				TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
				{ Position = UDim2.new(0.5, -375, 1, 50), BackgroundTransparency = 0.5 }
			)
			hideTween:Play()
		end
	end
end)


local TweenService = game:GetService("TweenService")

-- ===== INJECTION NOTIFICATION =====
local injectBox = Instance.new("Frame")
injectBox.Size = UDim2.new(0, 220, 0, 50)
injectBox.Position = UDim2.new(0, -240, 1, -60) -- off-screen left
injectBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
injectBox.BorderSizePixel = 0
injectBox.Parent = screenGui

local injectCorner = Instance.new("UICorner")
injectCorner.CornerRadius = UDim.new(0, 10)
injectCorner.Parent = injectBox

local injectText = Instance.new("TextLabel")
injectText.Size = UDim2.new(1, 0, 1, 0)
injectText.BackgroundTransparency = 1
injectText.Text = "oxai client - injected!"
injectText.TextColor3 = Color3.fromRGB(255, 255, 255)
injectText.TextSize = 20
injectText.Font = Enum.Font.GothamBold
injectText.TextXAlignment = Enum.TextXAlignment.Center
injectText.TextYAlignment = Enum.TextYAlignment.Center
injectText.Parent = injectBox

-- Tween settings
local slideIn = TweenService:Create(
	injectBox,
	TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	{ Position = UDim2.new(0, 15, 1, -60) }
)

local slideOut = TweenService:Create(
	injectBox,
	TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
	{ Position = UDim2.new(0, -240, 1, -60) }
)

-- Animation sequence
task.spawn(function()
	task.wait(1)        -- wait after menu appears
	slideIn:Play()
	slideIn.Completed:Wait()

	task.wait(6)        -- show "injected!" for 6 seconds

	slideOut:Play()
	slideOut.Completed:Wait()
	injectBox:Destroy()
end)

--tab buttons
local tab1 = Instance.new("Frame")
tab1.Size = UDim2.new(0, 0, 0, 0)
tab1.Position = UDim2.new(0, 200, 0, 50)
tab1.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
tab1.Visible = false
tab1.Parent = frame

local tab2 = Instance.new("Frame")
tab2.Visible = false
tab2.Parent = frame

-- Add side buttons
addSideButton("AimBot", tab1)
addSideButton("Tab 2", tab2)
addSideButton("Settings", nil)


-- main buttons

addButton(tab1, "Enable Feature A", function() print("A ON") end, function() print("A OFF") end)
addButton(tab1, "Enable Feature A", function() print("A ON") end, function() print("A OFF") end)
addButton(tab1, "Enable Feature A", function() print("A ON") end, function() print("A OFF") end)
addButton(tab1, "Enable Feature A", function() print("A ON") end, function() print("A OFF") end)
