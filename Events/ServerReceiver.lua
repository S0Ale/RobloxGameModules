local ServerReceiver = {}
ServerReceiver.__index = ServerReceiver

--Service
local repStorage = game["ReplicatedStorage"]

--Modules
local MaidClass = require(repStorage.Classes:FindFirstChild("Maid"))

--Variables
local eventFolder = repStorage.RemoteEvents

local COOLDOWN = .5

--Constructor
function ServerReceiver.new()-- event names (string only)
	local data = {
		maid = MaidClass.new(),

		conns = {},
		debounceList = {}
	}

	local self = setmetatable(data, ServerReceiver)
	Init(self)

	return self
end

function Init(self)

	self.maid:Mark(game.Players.PlayerAdded:Connect(function(player)
		if not self.debounceList[player.Name] then
			self.debounceList[player.Name] = tick()
		end
	end))
	self.maid:Mark(game.Players.PlayerRemoving:Connect(function(player)
		if not self.debounceList[player.Name] then
			self.debounceList[player.Name] = tick()
		end
	end))

	for _,plr in pairs(game.Players:GetChildren()) do
		if not self.debounceList[plr.Name] then
			self.debounceList[plr.Name] = tick()
		end
	end
end

--Adds a connection to an event
function ServerReceiver:AddConnection(eventName : string, callback)-- false: servermode, true: clientmode
	local event = eventFolder:FindFirstChild(eventName)
	if self.conns[eventName] ~= nil then return end

	self.conns[eventName] = event.OnServerEvent:Connect(function(plr, ...)
		if tick() - self.debounceList[plr.Name] > COOLDOWN then
			self.debounceList[plr.Name] = tick()
			callback(plr, ...)
		end
	end)

	self.maid:Mark(self.conns[eventName])
end

--Removes a connection
function ServerReceiver:RemoveConnection(eventName : string)
	self.conns[eventName]:Disconnect()
	self.conns[eventName] = nil
end

--Destroy method
function ServerReceiver:Destroy()
	self.maid:Sweep()
	self.conns = nil
	self.maid = nil
	self.debounceList = nil
end

return ServerReceiver
