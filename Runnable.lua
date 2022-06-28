local Runnable = {}
Runnable.__index = Runnable

function Runnable.new(rate : number, f)
	local data = {
		running = false,
		rate = rate,
		func = f
	}

	return setmetatable(data, Runnable)
end

function Runnable:Start()
	self.running = true

	spawn(function()
		while self.running do
			wait(self.rate)
			self.func()
		end
	end)
end

function Runnable:Stop()
	self.running = false
end

function Runnable:Destroy()
	if self.running then self:Stop() end
end

return Runnable
