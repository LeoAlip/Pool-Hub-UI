local NGuiHub = {}

warn("Preparing UI...")

repeat wait() until game:IsLoaded()
repeat wait() until game.Players.LocalPlayer
repeat wait() until game.Players.LocalPlayer.Character
repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

warn("UI Loaded")

local Tween = game:GetService("TweenService")
local Input = game:GetService("UserInputService")
local Run = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local ms = Player:GetMouse()

local notifiedCache = {}

local GuiName = "NotificationHub"

function NGuiHub:CreateWindow(title)

	for _, v in pairs(CoreGui:GetChildren()) do
		if v:IsA("ScreenGui") and v.Name == GuiName then
			v:Destroy()
		end
	end

	local Gui = Instance.new("ScreenGui")

	local themes = {
		BackgroundColor = Color3.fromRGB(79, 195, 247),
		TextColor       = Color3.fromRGB(255, 255, 255),
		ImageColor      = Color3.fromRGB(255, 255, 255),
		FrameColor      = Color3.fromRGB(34, 34, 34)
	}

	Gui.Name              = title or "NotificationHub"
	Gui.DisplayOrder      = 9999
	Gui.IgnoreGuiInset    = true
	Gui.ResetOnSpawn      = false
	Gui.ZIndexBehavior    = Enum.ZIndexBehavior.Global
	Gui.Parent            = CoreGui

	-- Queue: each entry = { frame = Frame, height = number }
	local activeNotifications = {}

	local GAP = 5        -- px gap between stacked notifications
	local BASE_Y = 0.85  -- UDim2 Y scale for the bottom notification

	-- Recalculates and tweens every active notification to its correct position.
	-- Notifications stack upward from BASE_Y, with GAP px between each.
	local function repositionAll()
		local offsetY = 0  -- accumulated pixel offset upward from BASE_Y

		-- Iterate from newest (top of stack) to oldest (bottom)
		for i = #activeNotifications, 1, -1 do
			local entry = activeNotifications[i]
			local targetPos = UDim2.new(0.775, 0, BASE_Y, -offsetY)

			Tween:Create(
				entry.frame,
				TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ Position = targetPos }
			):Play()

			offsetY = offsetY + entry.height + GAP
		end
	end

	function NGuiHub:SetTheme(theme, color)
		themes[theme] = color
	end

	local window = {}

	function window:AddNoti(title, gameName, message, notifyOnce, duration, callback, id)

		callback   = callback   or function() end
		duration   = duration   or 3
		notifyOnce = notifyOnce or false
		title      = title      or "Notification"
		message    = message    or "No message provided"
		id         = id         or (title .. message)

		if notifyOnce and notifiedCache[id] then return end
		if notifyOnce then notifiedCache[id] = true end

		-- Build UI instances
		local Frame       = Instance.new("Frame")
		local Header      = Instance.new("Frame")
		local slice       = Instance.new("Frame")
		local Title       = Instance.new("TextLabel")
		local GameName    = Instance.new("TextLabel")
		local Message     = Instance.new("TextLabel")
		local CloseButton = Instance.new("TextButton")
		local UICorner1   = Instance.new("UICorner")
		local UICorner2   = Instance.new("UICorner")
		local UIStroke1   = Instance.new("UIStroke")

		local FRAME_HEIGHT = 100  -- must match Frame.Size.Y.Offset below

		Frame.Name                  = "NotiFrame"
		Frame.Size                  = UDim2.new(0, 300, 0, FRAME_HEIGHT)
		-- Start off-screen to the right; repositionAll() will slide it in
		Frame.Position              = UDim2.new(1.05, 0, BASE_Y, 0)
		Frame.BackgroundColor3      = themes.FrameColor
		Frame.BackgroundTransparency = 0.15
		Frame.Visible               = false
		Frame.Parent                = Gui

		UICorner1.CornerRadius = UDim.new(0, 12.5)
		UICorner1.Parent       = Frame

		UICorner2.CornerRadius = UDim.new(0, 13)
		UICorner2.Parent       = slice

		UIStroke1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke1.Color           = themes.BackgroundColor
		UIStroke1.LineJoinMode    = Enum.LineJoinMode.Round
		UIStroke1.Thickness       = 1.5
		UIStroke1.Parent          = Frame

		Header.AnchorPoint          = Vector2.new(0.5, 0.5)
		Header.Size                 = UDim2.new(1, 0, 0, 50)
		Header.Position             = UDim2.new(0.5, 0, 0.1, 0)
		Header.BackgroundTransparency = 1
		Header.Parent               = Frame

		slice.AnchorPoint      = Vector2.new(0.5, 0.5)
		slice.Size             = UDim2.new(0.96, 0, 0, 5)
		slice.Position         = UDim2.new(0.5, 0, 0.9, 0)
		slice.BackgroundColor3 = themes.BackgroundColor
		slice.Parent           = Header

		Title.AnchorPoint          = Vector2.new(0.5, 0.5)
		Title.Size                 = UDim2.new(0, 100, 0, 45)
		Title.Position             = UDim2.new(0.205, 0, 0.575, 0)
		Title.BackgroundTransparency = 1
		Title.Text                 = title
		Title.RichText             = true
		Title.TextColor3           = themes.TextColor
		Title.Font                 = Enum.Font.SourceSansSemibold
		Title.TextSize             = 22
		Title.ZIndex               = 2
		Title.TextXAlignment       = Enum.TextXAlignment.Left
		Title.Parent               = Header

		GameName.AnchorPoint          = Vector2.new(0.5, 0.5)
		GameName.Size                 = UDim2.new(0, 75, 0, 45)
		GameName.Position             = UDim2.new(0.45, 0, 0.575, 0)
		GameName.BackgroundTransparency = 1
		GameName.Text                 = gameName
		GameName.RichText             = true
		GameName.TextColor3           = themes.TextColor
		GameName.Font                 = Enum.Font.SourceSansSemibold
		GameName.TextSize             = 22
		GameName.ZIndex               = 2
		GameName.TextXAlignment       = Enum.TextXAlignment.Left
		GameName.Parent               = Header

		Message.AnchorPoint          = Vector2.new(0.5, 0.5)
		Message.Size                 = UDim2.new(0.8, 0, 0.6, 0)
		Message.Position             = UDim2.new(0.5, 0, 0.665, 0)
		Message.BackgroundTransparency = 1
		Message.Text                 = message
		Message.RichText             = true
		Message.TextColor3           = themes.TextColor
		Message.Font                 = Enum.Font.SourceSansSemibold
		Message.TextScaled           = true
		Message.ZIndex               = 2
		Message.TextXAlignment       = Enum.TextXAlignment.Left
		Message.Parent               = Frame

		CloseButton.AnchorPoint          = Vector2.new(0.5, 0.5)
		CloseButton.Size                 = UDim2.new(0, 45, 0, 45)
		CloseButton.Position             = UDim2.new(0.9, 0, 0.5, 0)
		CloseButton.BackgroundTransparency = 1
		CloseButton.Text                 = "X"
		CloseButton.TextColor3           = themes.TextColor
		CloseButton.Font                 = Enum.Font.SourceSansSemibold
		CloseButton.TextSize             = 22
		CloseButton.ZIndex               = 2
		CloseButton.TextXAlignment       = Enum.TextXAlignment.Center
		CloseButton.Parent               = Header

		-- Track this notification in the queue
		local entry = { frame = Frame, height = FRAME_HEIGHT }
		table.insert(activeNotifications, 1, entry)  -- insert at front (newest = bottom)

		-- Shared teardown: slides out, destroys, removes from queue, repositions rest
		local dismissed = false
		local function dismiss()
			if dismissed then return end
			dismissed = true

			local TweenOut = Tween:Create(
				Frame,
				TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ Position = UDim2.new(1.05, 0, Frame.Position.Y.Scale, Frame.Position.Y.Offset),
				  BackgroundTransparency = 1 }
			)
			TweenOut:Play()
			TweenOut.Completed:Connect(function()
				Frame:Destroy()

				-- Remove from active list
				for i, e in ipairs(activeNotifications) do
					if e == entry then
						table.remove(activeNotifications, i)
						break
					end
				end

				repositionAll()
				callback()
			end)
		end

		CloseButton.MouseButton1Click:Connect(dismiss)

		-- Slide in: show frame, push it in, then wait for auto-dismiss
		Frame.Visible = true
		wait(0.1)

		-- Reposition all (including this new one) with slide-in tween
		repositionAll()

		task.delay(duration, dismiss)
	end

	return window
end

return NGuiHub
