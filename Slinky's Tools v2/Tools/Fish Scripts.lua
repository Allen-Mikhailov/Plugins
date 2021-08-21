--Services
local History = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")
local Studio = game:GetService("StudioService")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local QuickWidget = require(script.Parent.Parent.Modules.QuickWidget)

local Widget = QuickWidget:CreateWidget("Fish Scripts")

Widget:CreateSetting("Effect Descendants", false)

Widget:CreateButton("Fish Scripts", function()
	local StorageFolder = Instance.new("Folder")
	StorageFolder.Name = "Fished_Scripts"

	local FishedScriptCount = 0

	for _, SelectObj in pairs(Selection:Get()) do
		local Objects
		if Widget.SettingData["Effect Descendants"] then
			Objects = SelectObj:GetDescendants()
		else
			Objects = SelectObj:GetChildren()
		end
		
		for i, v in pairs(Objects) do
			if v:IsA("LuaSourceContainer") then
				FishedScriptCount += 1
				v.Parent = StorageFolder
			end
		end
	end
	
	if FishedScriptCount > 0 then
		print("Fished "..FishedScriptCount.." Scripts from your Selection")
		StorageFolder.Parent = workspace
	else
		print([[The plugin found no scripts in you Selection, 
		try Adjusting the Settings or Changing your Selection]])
	end
end)

local function OnPress()
	Widget:ToggleWidget(true)
end

return OnPress
