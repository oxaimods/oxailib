-- oxai ui library
-- github-ready

local Library = {}

-- SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- INTERNAL STATE
Library.Tabs = {}
Library.Frame = nil
Library.ScreenGui = nil
Library.MenuVisible = true

-- ================= INIT =================
function Library:Init()
	-- GUI
	local playerGui = player:WaitForChild("PlayerGui")

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "OxaiUI"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui
	self.ScreenGui = screenGui

	-- BLUR
	local blur = Instance.new("BlurEffect")
	blur.Size = 0
	blur.Parent = Lighting
	self.Blur = blur

	-- DARK OVERLAY
	local overlay = Instance.new("Frame")
	overlay.Size = UDim2.fromScale(1, 1)
	overlay.BackgroundColor3 = Color3.new(0, 0, 0)
	overlay.BackgroundTransparency = 1
	overlay.ZIndex = 0
	overlay.Parent = screenGui
	self.Overlay = overlay

	-- MAIN FRAME
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 800, 0, 400)
	frame.Position = UDim2.new(0.5, -400, 1, 50)
	frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	frame.BorderSizePixel = 0
	frame.ZIndex = 1
	frame.Parent = screenGui
	self.Frame = frame

	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

	-- TITLE
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -20, 0, 30)
	title.Position = UDim2.new(0, 10, 0, 5)
	title.BackgroundTransparency = 1
	title.Text = "oxai client <3"
	title.Font = Enum.Font.GothamBold
	title.TextSize = 20
	title.TextColor3 = Color3.new(1, 1, 1)
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = frame

	-- INSERT TOGGLE
	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == Enum.KeyCode.Insert then
			self.MenuVisible = not self.MenuVisible

			if self.MenuVisible then
				frame.Visible = true
				TweenService:Create(frame, TweenInfo.new(0.4),
					{ Position = UDim2.new(0.5, -400, 0.5, -200) }
				):Play()
				TweenService:Create(blur, TweenInfo.new(0.4), { Size = 18 }):Play()
				TweenService:Create(overlay, TweenInfo.new(0.4),
					{ BackgroundTransparency = 0.4 }
				):Play()
			else
				TweenService:Create(frame, TweenInfo.new(0.4),
					{ Position = UDim2.new(0.5, -400, 1, 50) }
				):Play()
				TweenService:Create(blur, TweenInfo.new(0.4), { Size = 0 }):Play()
				TweenService:Create(overlay, TweenInfo.new(0.4),
					{ BackgroundTransparency = 1 }
				):Play()
			end
		end
	end)

	-- DRAGGING
	local dragging, startPos, startInput
	frame.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			startInput = i.Position
			startPos = frame.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = i.Position - startInput
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

-- ================= TAB =================
function Library:AddTab(name)
	local tab = Instance.new("Frame")
	tab.Size = UDim2.new(0, 550, 0, 300)
	tab.Position = UDim2.new(0, 230, 0, 60)
	tab.BackgroundTransparency = 1
	tab.Visible = false
	tab.Parent = self.Frame

	self.Tabs[name] = tab
	if not self.ActiveTab then
		self.ActiveTab = tab
		tab.Visible = true
	end

	return tab
end

-- ================= BUTTON =================
function Library:AddButton(tab, name, on, off)
	local module = Instance.new("Frame")
	module.Size = UDim2.new(0, 180, 0, 80)
	module.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	module.BorderSizePixel = 0
	module.Parent = tab
	Instance.new("UICorner", module).CornerRadius = UDim.new(0, 8)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -10, 0, 25)
	label.Position = UDim2.new(0, 5, 0, 5)
	label.BackgroundTransparency = 1
	label.Text = name
	label.Font = Enum.Font.GothamSemibold
	label.TextSize = 16
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = module

	local toggle = Instance.new("TextButton")
	toggle.Size = UDim2.new(0, 20, 0, 20)
	toggle.Position = UDim2.new(1, -25, 1, -25)
	toggle.Text = ""
	toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	toggle.Parent = module
	Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 4)

	local onState = false
	toggle.MouseButton1Click:Connect(function()
		onState = not onState
		toggle.BackgroundColor3 =
			onState and Color3.fromRGB(39, 212, 245) or Color3.fromRGB(60, 60, 60)

		if onState and on then pcall(on) end
		if not onState and off then pcall(off) end
	end)

	return module
end

return Library
