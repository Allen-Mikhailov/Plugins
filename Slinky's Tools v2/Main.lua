--Services
local History = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")
local Studio = game:GetService("StudioService")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local plrID = Studio:GetUserId()
local plr = game:GetService("Players"):GetNameFromUserIdAsync(plrID)
local Mouse = plugin:GetMouse()

--Gui Settings
local BaseMenuColor = Color3.new(0.180392, 0.180392, 0.180392)

local CommandBarSize = 25
local CommandBarTextPadding = .05

local CommandButtonSize = 25
local CommandButtonTextPadding = .05

local Lower = string.lower

--Creating Widget
local DefaultWidgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Left ,  -- Widget will be initialized in floating panel
	false,   -- Widget will be initially enabled
	false,  -- Don't override the previous enabled state
	100,    -- Default width of the floating window
	150,    -- Default height of the floating window
	100,    -- Minimum width of the floating window (optional)
	100     -- Minimum height of the floating window (optional)
)

local MainWidget = plugin:CreateDockWidgetPluginGui("Slinky's Tools v2 Menu", DefaultWidgetInfo)
MainWidget.Title = "Slinky's Tools v2 Menu"
MainWidget.Name = "Slinky's Tools v2 Menu"
MainWidget.Enabled = true

local MainToolBar = plugin:CreateToolbar("Slinky's Tools v2")
local OpenMainMenu = MainToolBar:CreateButton(
	"Open Menu", 
	"Opens The Main Menu of the Plugin", 
	"rbxassetid://4903710971"
)

OpenMainMenu.ClickableWhenViewportHidden = true
OpenMainMenu.Click:Connect(function()
	MainWidget.Enabled = not MainWidget.Enabled
end)

--Gui Setup
local BackgroundFrame = Instance.new("Frame")
BackgroundFrame.BorderSizePixel = 0
BackgroundFrame.BackgroundColor3 = BaseMenuColor
BackgroundFrame.Size = UDim2.fromScale(1, 1)
BackgroundFrame.Parent = MainWidget

local SearchBarBackground = Instance.new("Frame")
SearchBarBackground.BorderSizePixel = 0
SearchBarBackground.Size = UDim2.new(1, 0, 0, CommandBarSize)
SearchBarBackground.BackgroundColor3 = Color3.new(0.101961, 0.101961, 0.101961)
SearchBarBackground.Parent = BackgroundFrame

local SearchBar = Instance.new("TextBox")
SearchBar.BackgroundTransparency = 1
SearchBar.BorderSizePixel = 0
SearchBar.TextColor3 = Color3.new(1, 1, 1)
SearchBar.Size = UDim2.new(1-CommandBarTextPadding, 0, 1, 0)
SearchBar.Position = UDim2.fromScale(CommandBarTextPadding, 0)
SearchBar.TextXAlignment = Enum.TextXAlignment.Left
SearchBar.PlaceholderText = "Command Bar"
SearchBar.Text = ""
SearchBar.ClearTextOnFocus = false
SearchBar.Parent = SearchBarBackground

local ToolListFrame = Instance.new("ScrollingFrame")
ToolListFrame.BackgroundTransparency = 1
ToolListFrame.BorderSizePixel = 0
ToolListFrame.Position = UDim2.new(0, 0, 0, CommandBarSize)
ToolListFrame.Size = UDim2.new(1, 0, 1, -CommandBarSize)
ToolListFrame.Parent = BackgroundFrame

local ToolButtonModel = Instance.new("TextButton")
ToolButtonModel.BorderSizePixel = 0
ToolButtonModel.Text = ""
ToolButtonModel.BackgroundColor3 = Color3.new(0.129412, 0.129412, 0.129412)
ToolButtonModel.Size = UDim2.new(1, 0, 0, CommandButtonSize)

local ToolButtonCommandText = Instance.new("TextLabel")
ToolButtonCommandText.BackgroundTransparency = 1
ToolButtonCommandText.BorderSizePixel = 0
ToolButtonCommandText.TextColor3 = Color3.new(1, 1, 1)
ToolButtonCommandText.Position = UDim2.new(CommandBarTextPadding, 0, 0, 0)
ToolButtonCommandText.Size = UDim2.new(1, -CommandBarTextPadding, 1, 0)
ToolButtonCommandText.TextXAlignment = Enum.TextXAlignment.Left
ToolButtonCommandText.Parent = ToolButtonModel

--Setting Up The PluginPass
local PluginPass = require(script.Parent.PluginPass)
PluginPass.Plugin = plugin
PluginPass.plr = plr
PluginPass.Mouse = Mouse

--Tool Collection
local Tools = {}
local ToolList = {}

--Requiring Tool Modules
local CharacterValues = "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890"

local function Compare(String1, String2)
	--print(String1, String2)
	for i = 1, #String1 do
		wait()
		local String1Value = string.find(CharacterValues, string.sub(String1, i, i))
		local String2Value = string.find(CharacterValues, string.sub(String2, i, i))
		
		if String1Value ~= String2Value then
			return String1Value < String2Value
		end
	end
	return false
end

local function AddToList(String)
	local Index = #ToolList + 1
	if #ToolList > 0 then
		local Placed = false
		for i, v in pairs(ToolList) do
			if Compare(String, v[2]) then
				Index = i
				break
			end
		end
	end  
	
	local newButton = ToolButtonModel:Clone()
	newButton.Name = String
	newButton.TextLabel.Text = String
	newButton.Parent = ToolListFrame
	
	newButton.Activated:Connect(function()
		Tools[String]()
	end)
	
	table.insert(ToolList, Index, {newButton, String})
end

for _, Module in pairs(script.Parent.Tools:GetDescendants()) do
	if Module:IsA("ModuleScript") then
		local Result = require(Module)

		if typeof(Result) == "table" then
			for i, v in pairs(Result) do
				AddToList(i)
				Tools[i] = v
			end
		else
			AddToList(Module.Name)
			Tools[Module.Name] = Result
		end
	end
end

local function SearchUpdate()
	local SearchText = Lower(SearchBar.Text)
	local TextLength = #SearchText
	
	local i = 0
	
	for _, v in pairs(ToolList) do
		v[1].Visible = TextLength <= #v[2] 
			and Lower(string.sub(v[2], 1, TextLength)) == SearchText
		v[1].Position = UDim2.fromOffset(0, CommandBarSize*i)
		
		if v[1].Visible then i += 1 end
	end
	
	ToolListFrame.CanvasSize = UDim2.fromOffset(0, CommandBarSize*i)
end

SearchBar:GetPropertyChangedSignal("Text"):Connect(SearchUpdate)

SearchUpdate()
