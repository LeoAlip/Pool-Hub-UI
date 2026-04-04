local Library = {}
Library.__index = Library

function Library:AddGui(options)
    local self = setmetatable({}, Library)

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = options.Title[1] or "UI"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 400, 0, 300)
    main.Position = UDim2.new(0.5, -200, 0.5, -150)
    main.BackgroundColor3 = options.ThemeColor
    main.Parent = screenGui

    local uis = game:GetService("UserInputService")
    uis.InputBegan:Connect(function(input)
        if input.KeyCode == options.ToggleKey then
            main.Visible = not main.Visible
        end
    end)

    self.Main = main
    self.Tabs = {}

    function self:AddTab(name)
        local Tab = {}
        Tab.Categories = {}

        local tabFrame = Instance.new("Frame")
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.Visible = (#self.Tabs == 0)
        tabFrame.Parent = main

        function Tab:AddCategory(name)
            local Category = {}

            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(1, -10, 0, 200)
            holder.Position = UDim2.new(0, 5, 0, #Tab.Categories * 210)
            holder.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            holder.Parent = tabFrame

            local title = Instance.new("TextLabel")
            title.Text = name
            title.Size = UDim2.new(1, 0, 0, 25)
            title.BackgroundTransparency = 1
            title.TextColor3 = Color3.new(1,1,1)
            title.Parent = holder

            local layout = Instance.new("UIListLayout")
            layout.Padding = UDim.new(0,5)
            layout.Parent = holder

            function Category:AddButton(text, callback)
                local btn = Instance.new("TextButton")
                btn.Text = text
                btn.Size = UDim2.new(1, -10, 0, 30)
                btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
                btn.Parent = holder
                btn.MouseButton1Click:Connect(callback)
            end

            function Category:AddLabel(text)
                local lbl = Instance.new("TextLabel")
                lbl.Text = text
                lbl.Size = UDim2.new(1, -10, 0, 25)
                lbl.BackgroundTransparency = 1
                lbl.TextColor3 = Color3.new(1,1,1)
                lbl.Parent = holder
            end

            function Category:AddToggle(text, callback)
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, -10, 0, 30)
                frame.BackgroundColor3 = Color3.fromRGB(60,60,60)
                frame.Parent = holder

                local lbl = Instance.new("TextLabel")
                lbl.Text = text
                lbl.Size = UDim2.new(0.7,0,1,0)
                lbl.BackgroundTransparency = 1
                lbl.TextColor3 = Color3.new(1,1,1)
                lbl.Parent = frame

                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(0.3,-5,0.8,0)
                btn.Position = UDim2.new(0.7,0,0.1,0)
                btn.BackgroundColor3 = Color3.fromRGB(120,0,0)
                btn.Text = ""
                btn.Parent = frame

                local state = false
                btn.MouseButton1Click:Connect(function()
                    state = not state
                    btn.BackgroundColor3 = state and Color3.fromRGB(0,120,0) or Color3.fromRGB(120,0,0)
                    callback(state)
                end)
            end

            table.insert(Tab.Categories, Category)
            return Category
        end

        table.insert(self.Tabs, Tab)
        return Tab
    end

    return self
end

return Library
