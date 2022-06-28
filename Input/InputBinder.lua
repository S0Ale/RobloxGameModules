local InputBinder = {}
InputBinder.__index = {}

local data = {actionList = {}}

--Services
local contextService = game["ContextActionService"]

function InputBinder.__index:BindAction(name : string, inputType, f)
	table.insert(self.actionList, name)
	contextService:BindAction(name, f, false, inputType)
end

function InputBinder.__index:UnbindAction(name : string)
	contextService:UnbindAction(name)
end

function InputBinder.__index:UnbindAll()
	for _,name in pairs(self.actionList) do
		contextService:UnbindAction(name)
	end
end

return setmetatable(data, InputBinder)
