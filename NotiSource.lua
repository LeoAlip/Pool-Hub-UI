local NGuiHub = {}

warn("Preparing UI...")

repeat wait() until game:IsLoaded()
repeat wait() until game.Players.LocalPlayer
repeat wait() until game.Players.LocalPlayer.Character
repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

warn("UI Loaded")

local Tween = game:GetService("TweenService")
local Tweeninfo = TweenInfo.new
local Input = game:GetService("UserInputService")
local Run = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local ms = Player:GetMouse()

local notifiedCache = {}

local GuiName = "NotificationHub"

function NGuiHub:CreateWindow(title, gameName)

	for _, v in pairs(CoreGui:GetChildren()) do
		if v:IsA("ScreenGui") and v.Name == GuiName then
			v:Destroy()
		end
	end

	local Gui = Instance.new("ScreenGui")

	local themes = {
		BackgroundColor = Color3.fromRGB(79, 195, 247),
		TextColor = Color3.fromRGB(255, 255, 255),
		ImageColor = Color3.fromRGB(255, 255, 255),
		FrameColor = Color3.fromRGB(34, 34, 34)
	}

	Gui.Name = GuiName
	Gui.DisplayOrder = 9999
	Gui.IgnoreGuiInset = true
	Gui.ResetOnSpawn = false
	Gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	Gui.Parent = CoreGui

	local Frame = Instance.new("Frame")
	local Header = Instance.new("Frame")
	local slice = Instance.new("Frame")
	local Title = Instance.new("TextLabel")
	local GameName = Instance.new("TextLabel")
	local Message = Instance.new("TextLabel")
	local CloseButton = Instance.new("TextButton")

	local UICorner1 = Instance.new("UICorner")

	local UIStroke1 = Instance.new("UIStroke")

	GameName.Name = "GameNameLabel"
	GameName.AnchorPoint = Vector2.new(0.5, 0.5)
	GameName.Size = UDim2.new(0, 75, 0, 45)
	GameName.Position = UDim2.new(0.45, 0, 0.5, 0)
	GameName.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	GameName.BackgroundTransparency = 1
	GameName.Text = gameName
	GameName.RichText = true
	GameName.TextColor3 = themes.TextColor
	GameName.Font = Enum.Font.SourceSansSemibold
	GameName.TextSize = 22.000
	GameName.ZIndex = 2
	GameName.TextXAlignment = Enum.TextXAlignment.Left
	GameName.Parent = Header

	local window = {}

	function window:AddNoti(title, message, notifyOnce, duration, callback, id)
		
		callback = callback or function() end
		duration = duration or 3
		notifyOnce = notifyOnce or false
		title = title or "Notification"
		message = message or "No message provided"
		
		id = id or (title .. message)

		if notifyOnce and notifiedCache[id] then
			return
		end

		notifiedCache[id] = true
		
		Frame.Name = "NotiFrame"
		Frame.Size = UDim2.new(0, 350, 0, 125)
		Frame.Position = UDim2.new(1.05, 0, 0.85, 0)
		Frame.BackgroundColor3 = themes.FrameColor
		Frame.BackgroundTransparency = 0.05
		Frame.Visible = false
		Frame.Parent = Gui

		UICorner1.Name = "UICorner1"
		UICorner1.CornerRadius = UDim.new(0, 12.5)
		UICorner1.Parent = Frame

		UIStroke1.Name = "UIStroke1"
		UIStroke1.ApplyStrokeMode = "Border"
		UIStroke1.Color = themes.BackgroundColor
		UIStroke1.LineJoinMode = "Round"
		UIStroke1.Thickness = 1.5
		UIStroke1.Parent = Frame

		Header.Name = "NotiHeader"
		Header.AnchorPoint = Vector2.new(0.5, 0.5)
		Header.Size = UDim2.new(1, 0, 0, 50)
		Header.Position = UDim2.new(0.5, 0, 0.1, 0)
		Header.BackgroundColor3 = themes.FrameColor
		Header.BackgroundTransparency = 1
		Header.Visible = true
		Header.Parent = Frame

		slice.Name = "slice"
		slice.AnchorPoint = Vector2.new(0.5, 0.5)
		slice.Size = UDim2.new(0.96, 0, 0, 5)
		slice.Position = UDim2.new(0.5, 0, 1, 0)
		slice.BackgroundColor3 = themes.BackgroundColor
		slice.BackgroundTransparency = 0
		slice.Visible = true
		slice.Parent = Header

		Title.Name = "TitleLabel"
		Title.AnchorPoint = Vector2.new(0.5, 0.5)
		Title.Size = UDim2.new(0, 100, 0, 45)
		Title.Position = UDim2.new(0.175, 0, 0.5, 0)
		Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Title.BackgroundTransparency = 1
		Title.Text = title
		Title.RichText = true
		Title.TextColor3 = themes.TextColor
		Title.Font = Enum.Font.SourceSansSemibold
		Title.TextSize = 22.000
		Title.ZIndex = 2
		Title.TextXAlignment = Enum.TextXAlignment.Left
		Title.Parent = Header
		
		Message.Name = "MessageLabel"
		Message.AnchorPoint = Vector2.new(0.5, 0.5)
		Message.Size = UDim2.new(0.95, 0, 0.775, 0)
		Message.Position = UDim2.new(0.5, 0, 0.625, 0)
		Message.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Message.BackgroundTransparency = 1
		Message.Text = message
		Message.RichText = true
		Message.TextColor3 = themes.TextColor
		Message.Font = Enum.Font.SourceSansSemibold
		Message.TextScaled = true
		Message.ZIndex = 2
		Message.TextXAlignment = Enum.TextXAlignment.Left
		Message.Parent = Frame
		
		CloseButton.Name = "CloseButton"
		CloseButton.AnchorPoint = Vector2.new(0.5, 0.5)
		CloseButton.Size = UDim2.new(0, 45, 0, 45)
		CloseButton.Position = UDim2.new(0.9, 0, 0.5, 0)
		CloseButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		CloseButton.BackgroundTransparency = 1
		CloseButton.Text = "X"
		CloseButton.RichText = true
		CloseButton.TextColor3 = themes.TextColor
		CloseButton.Font = Enum.Font.SourceSansSemibold
		CloseButton.TextSize = 22.000
		CloseButton.ZIndex = 2
		CloseButton.TextXAlignment = Enum.TextXAlignment.Center
		CloseButton.Parent = Header

		CloseButton.MouseButton1Click:Connect(function()
			Frame.Visible = false
		end)
		
		local TweenIn = Tween:Create(
			Frame,
			TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{
				Position = UDim2.new(0.75, 0, 0.85, 0)
			}
		)
		
		local TweenOut = Tween:Create(
			Frame,
			TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{
				Position = UDim2.new(1.2, 0, 0.9, 0), 
				BackgroundTransparency = 1
			}
		)
		
		Frame.Visible = true
		wait(0.1)
		TweenIn:Play()

		task.wait(duration)
		
		TweenOut:Play()

		TweenOut.Completed:Connect(function()
			Frame:Destroy()
			callback()
		end)
	end
	return window
end

return NGuiHub
