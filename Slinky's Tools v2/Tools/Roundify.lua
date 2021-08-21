--Services
local History = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")
local Studio = game:GetService("StudioService")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local QuickWidget = require(script.Parent.Parent.Modules.QuickWidget)

local Widget = QuickWidget:CreateWidget("Roundify")

Widget:CreateSetting("Effect Descendants", false)

Widget:CreateButton("Roundify", function()
	print("Roundify")
end)

local function Roundify()
	Widget:ToggleWidget(true)
end

return Roundify
