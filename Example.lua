local Library = {}
Library.__index = Library

function Library:CreateGui(name, themeColor, toggleKey)
    local self = setmetatable({}, Library)

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = name
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    mainFrame.BackgroundColor3 = themeColor
    mainFrame.Parent = screenGui

    local uis = game:GetService("UserInputService")
    uis.InputBegan:Connect(function(input)
        if input.KeyCode == toggleKey then
            mainFrame.Visible = not mainFrame.Visible
        end
    end)

    self.ScreenGui = screenGui
    self.MainFrame = mainFrame
    return self
end

function Library:AddCategory(name)
    local cat = Instance.new("TextLabel")
    cat.Text = name
    cat.Size = UDim2.new(1, 0, 0, 30)
    cat.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    cat.Parent = self.MainFrame
    return cat
end

function Library:AddButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, #self.MainFrame:GetChildren() * 35)
    btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    btn.Parent = self.MainFrame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

function Library:AddLabel(text)
    local label = Instance.new("TextLabel")
    label.Text = text
    label.Size = UDim2.new(1, -10, 0, 25)
    label.Position = UDim2.new(0, 5, 0, #self.MainFrame:GetChildren() * 30)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Parent = self.MainFrame
    return label
end

function Library:AddToggle(text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 30)
    frame.Position = UDim2.new(0, 5, 0, #self.MainFrame:GetChildren() * 35)
    frame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    frame.Parent = self.MainFrame

    local label = Instance.new("TextLabel")
    label.Text = text
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Parent = frame

    local button = Instance.new("TextButton")
    button.Text = ""
    button.Size = UDim2.new(0.3, -5, 0.8, 0)
    button.Position = UDim2.new(0.7, 0, 0.1, 0)
    button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    button.Parent = frame

    local toggled = false
    button.MouseButton1Click:Connect(function()
        toggled = not toggled
        button.BackgroundColor3 = toggled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        callback(toggled)
    end)
    return frame
end

return Library
