--Services
local History = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")
local Studio = game:GetService("StudioService")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local Mouse = require(script.Parent.Parent.PluginPass).Mouse

local function Function()
	print("Your Screen Size is {"..Mouse.ViewSizeX..", "..Mouse.ViewSizeY.."}")
end

return Function
