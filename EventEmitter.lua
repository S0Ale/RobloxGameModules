local EventEmitter = {}
EventEmitter.__index = EventEmitter

--Services
local repStorage = game["ReplicatedStorage"]

--Variables
local eventFolder = repStorage.RemoteEvents
local events = {}

for _,event in pairs(eventFolder:GetChildren()) do
	events[event.Name] = event
end

--Constructor
function EventEmitter.new()
	local self = setmetatable({}, EventEmitter)
	return self
end

--Fires a remote event
function EventEmitter:Fire(mode : boolean, eventName : string, plr : Player, ...)-- false: servermode, true: clientmode
	if mode then
		if not plr then
			error("ERROR: Player object is nil")
		end

		events[eventName]:FireClient(plr, ...)
	else
		events[eventName]:FireServer(...)
	end
end

function EventEmitter:Broadcast(eventName : string, ...) --server only
	events[eventName]:FireAllClients(...)
end

--Destroy method
function EventEmitter:Destroy()
end

return EventEmitter
