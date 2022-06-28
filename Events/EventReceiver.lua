local EventReceiver = {}
EventReceiver.__index = EventReceiver

--Service
local repStorage = game["ReplicatedStorage"]

--Modules
local MaidClass = require(repStorage.Classes:FindFirstChild("Maid"))

--Variables
local eventFolder = repStorage.RemoteEvents

--Constructor
function EventReceiver.new()-- event names (string only)
	local data = {
		maid = MaidClass.new(),
		conns = {}
	}

	return setmetatable(data, EventReceiver)
end

--Adds a connection to an event
function EventReceiver:AddConnection(mode : boolean, eventName : string, callback)-- false: servermode, true: clientmode
	local event = eventFolder:FindFirstChild(eventName)
	if self.conns[eventName] ~= nil then return end

	if mode then
		self.conns[eventName] = event.OnClientEvent:Connect(callback)
	else
		self.conns[eventName] = event.OnServerEvent:Connect(callback)
	end

	self.maid:Mark(self.conns[eventName])
end

--Removes a connection
function EventReceiver:RemoveConnection(eventName : string)
	self.conns[eventName]:Disconnect()
	self.conns[eventName] = nil
end

--Destroy method
function EventReceiver:Destroy()
	self.conns = nil
	self.maid:Sweep()
	self.maid = nil
end

return EventReceiver
