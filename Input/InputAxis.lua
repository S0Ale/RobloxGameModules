local InputAxis = {}
InputAxis.__index = InputAxis

--Services
local repStorage : ReplicatedStorage = game["ReplicatedStorage"]

--Modules
local binder = require(repStorage.Classes:FindFirstChild("InputBinder"))

--Variables
local DEF_NEUTRAL = 0

function InputAxis.new(verticalLimits : Table, horizontalLimits : Table)
	local data = {
		vertical = DEF_NEUTRAL,
		horizontal = DEF_NEUTRAL,

		vLimits = verticalLimits,
		hLimits = horizontalLimits,

		up = false,
		down = false,
		left = false,
		right = false,

		neutral = DEF_NEUTRAL,
	}

	local self = setmetatable(data, InputAxis)
	Init(self)

	return self
end

function Init(self)
	self:mapKeys("W", "S", "A", "D") --default keys
end

function InputAxis:mapKeys(up, down, left, right)
	binder:UnbindAll()

	local upLimit = self.vLimits[1]
	local downLimit = self.vLimits[2]

	--Vertical
	binder:BindAction("Up", Enum.KeyCode[up], function(name, inputState)
		if inputState == Enum.UserInputState.Begin then
			self.up = true
		elseif inputState == Enum.UserInputState.End then
			self.up = false
		end

		self.vertical = updateVertical(self.vertical, self.up, self.down, DEF_NEUTRAL)
		self.vertical = math.clamp(self.vertical, downLimit, upLimit)

		return Enum.ContextActionResult.Sink
	end)

	binder:BindAction("Down", Enum.KeyCode[down], function(name, inputState)
		if inputState == Enum.UserInputState.Begin then
			self.down = true
		elseif inputState == Enum.UserInputState.End then
			self.down = false
		end

		self.vertical = updateVertical(self.vertical, self.up, self.down, DEF_NEUTRAL)
		self.vertical = math.clamp(self.vertical, downLimit, upLimit)

		return Enum.ContextActionResult.Sink
	end)

	--Horizontal
	binder:BindAction("Left", Enum.KeyCode[left], function(name, inputState)
		if inputState == Enum.UserInputState.Begin then
			self.left = true
		elseif inputState == Enum.UserInputState.End then
			self.left = false
		end

		self.horizontal = updateHorizontal(self.horizontal, self.left, self.right, self.neutral)
		self.horizontal = math.clamp(self.horizontal, self.hLimits[1], self.hLimits[2])

		return Enum.ContextActionResult.Sink
	end)

	binder:BindAction("Right", Enum.KeyCode[right], function(name, inputState)
		if inputState == Enum.UserInputState.Begin then
			self.right = true
		elseif inputState == Enum.UserInputState.End then
			self.right = false
		end

		self.horizontal = updateHorizontal(self.horizontal, self.left, self.right, self.neutral)
		self.horizontal = math.clamp(self.horizontal, self.hLimits[1], self.hLimits[2])

		return Enum.ContextActionResult.Sink
	end)
end

function InputAxis:Destroy()
	binder:UnbindAll()
end

--Auxiliary functions

function updateVertical(axis, up, down, neutral)
	if up == down then return neutral
	elseif up then return axis + 1
	else return axis - 1 end
end

function updateHorizontal(axis, left, right, neutral)
	if left == right then return neutral
	elseif right then return axis + 1
	elseif left then return axis - 1 end
end

---SETTERS/GETTERS---

function InputAxis:getVerticalAxis()
	return self.vertical
end

function InputAxis:getHorizontalAxis()
	return self.horizontal
end

function InputAxis:getNeutral()
	return self.neutral
end

function InputAxis:setVerticalLimits(l : Table)
	self.vLimits = l
end

function InputAxis:setHorizontalLimits(l : Table)
	self.hLimits = l
end

function InputAxis:setNeutral(n : number)
	self.neutral = n
	self.horizontal = updateHorizontal(self.horizontal, self.left, self.right, self.neutral)
	self.horizontal = math.clamp(self.horizontal, self.hLimits[1], self.hLimits[2])
end

return InputAxis
