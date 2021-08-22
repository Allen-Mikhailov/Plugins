--Services
local History = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")
local Studio = game:GetService("StudioService")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local function Order()
	local Sel = Selection:Get()
	
	local Count = 0
	
	local Instances = {}
	
	for _, Obj in pairs(Sel) do
		Count += #Obj:GetChildren()
		
		for i, v in pairs(Obj:GetChildren()) do
			if not Instances[v] then
				Instances[v] = true
				Count += 1
			end
		end
	end
	
	print("You have Selected "..Count.." Children")
end

return Order
