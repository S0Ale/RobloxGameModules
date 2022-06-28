local RandomizerModule = {}
RandomizerModule.__index = RandomizerModule

function RandomizerModule.new()
	return setmetatable({elementList = {}}, RandomizerModule)
end

function RandomizerModule:insertNewItem(newItem)
	local i = #self.elementList + 1
	self.elementList[i] = newItem
end

function RandomizerModule:getRandomElement()
	local i = math.random(1, #self.elementList)
	return self.elementList[i]
end

function RandomizerModule:setRandomList(list)
	self.elementList = list
end

return RandomizerModule
