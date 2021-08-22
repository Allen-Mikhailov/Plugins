--Services
local History = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")
local Studio = game:GetService("StudioService")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local function Order()
	local Sel = Selection:Get()
	
	for _, Obj in pairs(Sel) do
		local Children = Obj:GetChildren()
		
		for i, v in pairs(Children) do
			v.Name = i
		end
	end
	
	History:SetWaypoint("OrderChildren")
end

return Order
