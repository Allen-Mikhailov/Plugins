local module = {}

local ColorData = require(script.Parent.Parent.ColorData)

local DefaultWidgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float ,  -- Widget will be initialized in floating panel
	false,   -- Widget will be initially enabled
	true,  -- Don't override the previous enabled state
	210,    -- Default width of the floating window
	150,    -- Default height of the floating window
	200,    -- Minimum width of the floating window (optional)
	100     -- Minimum height of the floating window (optional)
)

local plugin = require(script.Parent.Parent.PluginPass).Plugin

local Widget = plugin:CreateDockWidgetPluginGui("QuickWidget", DefaultWidgetInfo)
Widget.Title = "QuickWidget"
Widget.Name = "QuickWidget"

local CurrentWidget

local Widgets = {}

local BorderPadding = 5
local Padding = 5
local ItemSize = 25
local ButtonPadding = 10

local TitleToLinePadding = 13
local OptionSpacing = 1

local SelectedOptionColor = Color3.new(0.235294, 0.439216, 0.52549)

local WidgetBackgroundFrame = Instance.new("ScrollingFrame")
WidgetBackgroundFrame.Size = UDim2.fromScale(1, 1)
WidgetBackgroundFrame.BackgroundColor3 = ColorData.Background
WidgetBackgroundFrame.BorderSizePixel = 0
WidgetBackgroundFrame.Parent = Widget

local SeperationLineModel = Instance.new("Frame")
SeperationLineModel.BorderSizePixel = 0
SeperationLineModel.BackgroundColor3 = ColorData.Dark
SeperationLineModel.ZIndex = 2
SeperationLineModel.Name = "Line"
SeperationLineModel.Size = UDim2.new(1, 0, 0, 1)

--Check Box
local CheckBoxModel = Instance.new("Frame")
CheckBoxModel.BackgroundTransparency = 1
--CheckBoxModel.BackgroundColor3 = ColorData.Dark
CheckBoxModel.AnchorPoint = Vector2.new(.5, 0)
CheckBoxModel.BorderSizePixel = 0
CheckBoxModel.Size = UDim2.new(1, BorderPadding*-2, 0, ItemSize)
CheckBoxModel.ZIndex = 2

local CheckBoxTitle = Instance.new("TextLabel")
CheckBoxTitle.BackgroundTransparency = 1
CheckBoxTitle.AnchorPoint = Vector2.new(0, .5)
CheckBoxTitle.Position = UDim2.new(0, 3, .5, 0)
CheckBoxTitle.Size = UDim2.new(.3, 0, 1, 0)
CheckBoxTitle.TextXAlignment = Enum.TextXAlignment.Left
CheckBoxTitle.TextColor3 = ColorData.TextColor
CheckBoxTitle.BorderSizePixel = 0
CheckBoxTitle.ZIndex = 3
CheckBoxTitle.Parent = CheckBoxModel

local CheckBoxButton = Instance.new("TextButton")
CheckBoxButton.AutoButtonColor = false
CheckBoxButton.Text = ""
CheckBoxButton.Name = "Button"
CheckBoxButton.AnchorPoint = Vector2.new(0, .5)
CheckBoxButton.Size = UDim2.fromOffset(ItemSize*.8, ItemSize*.8)
CheckBoxButton.BackgroundColor3 = ColorData.Header
CheckBoxButton.BorderSizePixel = 0
CheckBoxButton.ZIndex = 3
CheckBoxButton.Parent = CheckBoxModel

local CheckFrame = Instance.new("Frame")
CheckFrame.BackgroundTransparency = 1
CheckFrame.ZIndex = 4
CheckFrame.BackgroundColor3 = Color3.new(0.207843, 0.709804, 1)
CheckFrame.BorderSizePixel = 0
CheckFrame.Size = UDim2.fromScale(.7, .7)
CheckFrame.AnchorPoint = Vector2.new(.5, .5)
CheckFrame.Position = UDim2.fromScale(.5, .5)
CheckFrame.Parent = CheckBoxButton

--MultiSelection
local MultiSelectionModel = Instance.new("Frame")
MultiSelectionModel.BackgroundTransparency = 1
MultiSelectionModel.AnchorPoint = Vector2.new(.5, 0)
MultiSelectionModel.BorderSizePixel = 0
MultiSelectionModel.Size = UDim2.new(1, BorderPadding*-2, 0, ItemSize)
MultiSelectionModel.ZIndex = 2

local MultiSelectionTitle = Instance.new("TextLabel")
MultiSelectionTitle.BackgroundTransparency = 1
MultiSelectionTitle.AnchorPoint = Vector2.new(0, .5)
MultiSelectionTitle.Position = UDim2.new(0, 3, .5, 0)
MultiSelectionTitle.Size = UDim2.new(.3, 0, 1, 0)
MultiSelectionTitle.TextXAlignment = Enum.TextXAlignment.Left
MultiSelectionTitle.TextColor3 = ColorData.TextColor
MultiSelectionTitle.BorderSizePixel = 0
MultiSelectionTitle.ZIndex = 3
MultiSelectionTitle.Parent = MultiSelectionModel

local MultiSelectionButton = Instance.new("TextButton")
MultiSelectionButton.Text = ""
MultiSelectionButton.Name = "Button"
MultiSelectionButton.AnchorPoint = Vector2.new(0, .5)
MultiSelectionButton.Size = UDim2.fromOffset(0, ItemSize*.8)
MultiSelectionButton.BackgroundColor3 = ColorData.Header
MultiSelectionButton.BorderSizePixel = 2
MultiSelectionButton.BorderColor3 = Color3.new(0.219608, 0.219608, 0.219608)
MultiSelectionButton.ZIndex = 3
MultiSelectionButton.TextColor3 = ColorData.TextColor
MultiSelectionButton.Parent = MultiSelectionModel

local MultiSelectionOption = Instance.new("TextButton")
MultiSelectionOption.Text = ""
MultiSelectionOption.Name = "Button"
MultiSelectionOption.Size = UDim2.new(1, 0, 1, 0)
MultiSelectionOption.BackgroundColor3 = ColorData.Header
MultiSelectionOption.BorderSizePixel = 2
MultiSelectionOption.BorderColor3 = Color3.new(0.219608, 0.219608, 0.219608)
MultiSelectionOption.ZIndex = 3
MultiSelectionOption.TextColor3 = ColorData.TextColor

--Default Button
local DefaultButtonModel = Instance.new("TextButton")
DefaultButtonModel.AnchorPoint = Vector2.new(.5, 0)
DefaultButtonModel.ZIndex = 2
--DefaultButtonModel.AutoButtonColor = false
DefaultButtonModel.BackgroundColor3 = ColorData.Dark
DefaultButtonModel.BorderSizePixel = 0
DefaultButtonModel.TextColor3 = ColorData.TextColor
DefaultButtonModel.TextSize = 16
DefaultButtonModel.Size = UDim2.new(1, -BorderPadding*2, 0, ItemSize)

--DefaultText
local DefaultTextModel = Instance.new("TextLabel")
DefaultTextModel.TextColor3 = Color3.new(1, 1, 1)
DefaultTextModel.AnchorPoint = Vector2.new(.5, 0)

function module:CreateWidget(Name)
	local WidgetData = {}
	local SettingData = {}
	WidgetData.SettingData = SettingData
	
	local WidgetFrame = Instance.new("Frame")
	WidgetFrame.BorderSizePixel = 0
	WidgetFrame.Size = UDim2.new(1, 0, 0, BorderPadding*2)
	WidgetFrame.Visible = false
	WidgetFrame.BackgroundTransparency = 1
	WidgetFrame.Name = Name
	WidgetFrame.Parent = WidgetBackgroundFrame
	
	local FirstLine = SeperationLineModel:Clone()
	FirstLine.Parent = WidgetFrame
	
	WidgetData.Frame = WidgetFrame
	
	local CurrentY = 0
	
	local SettingLine 
	local BiggestTextBounds = 0
	
	local BoundUpdates = {}
	
	local function BoundUpdate(newBounds)
		BiggestTextBounds = newBounds
		for i, v in pairs(BoundUpdates) do
			v(newBounds)
		end
	end
	
	local function FrameUpdate()
		WidgetFrame.Size = UDim2.new(1, 0, 0, 0 + CurrentY)
	end
	
	function WidgetData:CreateText(Text)
		
	end
	
	function WidgetData:CreateSetting(SettingName, DefaultValue, ExtraArg)
		
		if not SettingLine then
			SettingLine = SeperationLineModel:Clone()
			SettingLine.Size = UDim2.fromOffset(1, 0)
			SettingLine.Position = UDim2.fromOffset(0, CurrentY)
			SettingLine.Parent = WidgetFrame
		end
		
		local CurrentLine = SettingLine
		
		local StartingY = CurrentY
		
		local newFrame
		
		local TextSizeUpdate = function() end
		
		if typeof(DefaultValue) == "boolean" then
			WidgetData.SettingData[SettingName] = DefaultValue
			
			newFrame = CheckBoxModel:Clone()
			
			newFrame.TextLabel.Text = SettingName
			
			TextSizeUpdate =  function()
				local Bounds = newFrame.TextLabel.TextBounds.X + TitleToLinePadding --+ ItemSize*.8

				if BiggestTextBounds < Bounds then
					BoundUpdate(Bounds)
					BiggestTextBounds = Bounds
					
				end
			end
			
			table.insert(BoundUpdates, function(newBounds)
				newFrame.Button.Position 
					= UDim2.new(0, newBounds + 2, .5, -3)
				CurrentLine.Position = UDim2.fromOffset(newBounds, CurrentLine.Position.Y.Offset) 
			end)
			
			newFrame.TextLabel:GetPropertyChangedSignal("TextBounds"):Connect(TextSizeUpdate)
			
			if DefaultValue then
				newFrame.Button.Frame.BackgroundTransparency = 0
			else
				newFrame.Button.Frame.BackgroundTransparency = 1
			end
			
			newFrame.Button.Activated:Connect(function()
				SettingData[SettingName] = not SettingData[SettingName]
				
				if SettingData[SettingName] then
					newFrame.Button.Frame.BackgroundTransparency = 0
				else
					newFrame.Button.Frame.BackgroundTransparency = 1
				end
			end)
		elseif typeof(DefaultValue) == "table" then
			newFrame = MultiSelectionModel:Clone()
			local Button = newFrame.Button
			local Title = newFrame.TextLabel
			
			Title.Text = SettingName
			
			local BiggestTextSize = 0
			local CurrentOption
			
			local function UpdateOptionSize()
				Button.Size = UDim2.fromOffset(BiggestTextSize, ItemSize*.8)
			end
			
			TextSizeUpdate = function()
				local Bounds = Title.TextBounds.X + TitleToLinePadding --+ ItemSize*.8

				if BiggestTextBounds < Bounds then
					BoundUpdate(Bounds)
					BiggestTextBounds = Bounds
				end
			end

			table.insert(BoundUpdates, function(newBounds)
				Button.Position 
					= UDim2.new(0, newBounds + 2, .5, -3)
				CurrentLine.Position = UDim2.fromOffset(newBounds, CurrentLine.Position.Y.Offset) 
			end)

			Title:GetPropertyChangedSignal("TextBounds"):Connect(TextSizeUpdate)
			
			local OptionFrame = Instance.new("Frame")
			OptionFrame.BackgroundTransparency = 1
			OptionFrame.Size = UDim2.fromScale(1, 1)
			OptionFrame.Parent = newFrame.Button
			
			Button.Text = DefaultValue[ExtraArg]
			SettingData[SettingName] = DefaultValue[ExtraArg]
			
			Button.Activated:Connect(function()
				OptionFrame.Visible = not OptionFrame.Visible
			end)
			
			Button:GetPropertyChangedSignal("TextBounds"):Connect(function()
				local Bounds = newFrame.TextLabel.TextBounds.X + 5
				if BiggestTextSize < Bounds then
					BiggestTextSize = Bounds
					UpdateOptionSize()
				end
			end)
			
			for i, v in pairs(DefaultValue) do
				local newOptionModel = MultiSelectionOption:Clone()
				newOptionModel.Position = UDim2.new(0, 0, i, OptionSpacing*i)
				newOptionModel.Text = v
				newOptionModel.Parent = OptionFrame
				
				newOptionModel:GetPropertyChangedSignal("TextBounds"):Connect(function()
					local Bounds = newFrame.TextLabel.TextBounds.X + 5
					if BiggestTextSize < Bounds then
						BiggestTextSize = Bounds
						UpdateOptionSize()
					end
				end)
				
				if ExtraArg == i then
					CurrentOption = newOptionModel
					newOptionModel.BackgroundColor3 = SelectedOptionColor
				end
				
				newOptionModel.Activated:Connect(function()
					
					CurrentOption.BackgroundColor3 = MultiSelectionOption.BackgroundColor3
					CurrentOption = newOptionModel
					newOptionModel.BackgroundColor3 = SelectedOptionColor
					
					newFrame.Button.Text = v
					SettingData[SettingName] = v
					OptionFrame.Visible = false
				end)
			end
			
			OptionFrame.Visible = false
		end
		
		newFrame.Position = UDim2.new(.5, 0, 
			0, BorderPadding + CurrentY)
		newFrame.Parent = WidgetFrame
		
		CurrentY += ItemSize+Padding
		
		local Line = SeperationLineModel:Clone()
		Line.Position = UDim2.new(0, 0, 
			0, CurrentY)
		Line.Parent = WidgetFrame
		
		CurrentY += 1 --Account for Line
		
		CurrentLine.Size += UDim2.fromOffset(0, CurrentY-StartingY)
		
		TextSizeUpdate()
		FrameUpdate()
	end
	
	function WidgetData:CreateButton(ButtonName, ButtonFunction)
		CurrentY += ButtonPadding
		
		local newButton = DefaultButtonModel:Clone()
		newButton.Position = UDim2.new(.5, 0, 0, 0 + CurrentY)
		newButton.Text = ButtonName
		newButton.Parent = WidgetFrame
		
		newButton.Activated:Connect(ButtonFunction)
		
		CurrentY += ItemSize
		
		FrameUpdate()
	end
	
	function WidgetData:ToggleWidget(Toggle)
		if Toggle then
			if CurrentWidget then
				CurrentWidget.Frame.Visible = false
			end
			
			Widget.Title = Name
			WidgetBackgroundFrame.CanvasSize = UDim2.fromOffset(0, WidgetFrame.Size.X.Offset)
			WidgetFrame.Visible = true

			CurrentWidget = WidgetData
		else
			CurrentWidget = nil
		end
		Widget.Enabled = Toggle
	end
	
	Widgets[Name] = WidgetData
	return WidgetData
end

return module
