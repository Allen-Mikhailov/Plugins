--Services
local History = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")
local Studio = game:GetService("StudioService")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local QuickWidget = require(script.Parent.Parent.Modules.QuickWidget)

local Widget = QuickWidget:CreateWidget("Wrap")

Widget:CreateSetting("Container Type", {"Model", "Folder"}, 2)

Widget:CreateButton("Wrap", function()
	local SelectionTable = Selection:Get()
	
	if #SelectionTable > 0 then
		local Parent = SelectionTable[1].Parent
		
		local Container = Instance.new(Widget.SettingData["Container Type"])
		
		local Count = 0
		for i, v in pairs(SelectionTable) do
			Count += 1
			v.Parent = Container
		end
		
		Container.Parent = Parent
		
		Selection:Set({Container})
		
		print("Wrapped "..Count.." Instance\\s in a "..Widget.SettingData["Container Type"])

		History:SetWaypoint("Wrapped")
	end
end)

local function Function()
	Widget:ToggleWidget(true)
end

return Function
