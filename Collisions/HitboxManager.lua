local HitboxManager = {}
HitboxManager.__index = HitboxManager

--Services
local serverStorage = game["ServerStorage"]
local repStorage = game["ReplicatedStorage"]

--Modules
local MaidClass = require(repStorage.Classes:FindFirstChild("Maid"))
local RunnableClass = require(serverStorage.Modules:FindFirstChild("Runnable"))
local HitboxClass = require(script:FindFirstChild("Hitbox"))

--Variables

--Constructor
function HitboxManager.new(hitboxes)
	local data = {
		maid = MaidClass.new(),
		hitboxTask = nil,

		hitboxes = hitboxes,
		hitboxList = {}
	}

	local self = setmetatable(data, HitboxManager)
	Init(self)

	return self
end

--Initialization method
function Init(self)
	self.hitboxTask = RunnableClass.new(.02, function()
		for _,h in pairs(self.hitboxList) do
			if h:isEnabled() then h:Update() end
		end
	end)
	self.maid:Mark(self.hitboxTask)

	self.hitboxTask:Start()
end

--Adds a new Hitbox object
function HitboxManager:AddHitbox(reference : BasePart)
	local hitbox = HitboxClass.new(reference, self.hitboxes)

	table.insert(self.hitboxList, hitbox)
	self.maid:Mark(hitbox)

	return hitbox
end

--Destroy method
function HitboxManager:Destroy()
	self.maid:Sweep()
	self.hitboxList = {}
	self.hitboxTask = nil
end

return HitboxManager
