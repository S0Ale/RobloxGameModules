local Hitbox = {}
Hitbox.__index = Hitbox

--Services
local serverStorage = game["ServerStorage"]
local repStorage = game["ReplicatedStorage"]

--Modules
local MaidClass = require(repStorage.Classes:FindFirstChild("Maid"))
local Signal = require(serverStorage.Modules:FindFirstChild("Signal"))

--Variables

--Constructor
function Hitbox.new(reference : BasePart, whitelist : table)
	local self = setmetatable({}, Hitbox)

	self.region = reference
	self.Touched = Signal.new()
	self.enabled = true

	self.params = OverlapParams.new()
	self.params.FilterDescendantsInstances = whitelist
	self.params.MaxParts = 10
	self.params.FilterType = Enum.RaycastFilterType.Whitelist

	return self
end

--Update method
function Hitbox:Update()
	local result : table = workspace:GetPartBoundsInBox(self.region.CFrame, self.region.Size, self.params)

	for _,p in pairs(result) do
		self.Touched:Fire(p)
	end
end

--Destroy method
function Hitbox:Destroy()
	self.Touched = nil
	self.region:Destroy()
	self.region = nil
end

----SETTERS AND GETTERS----

function Hitbox:getReference()
	return self.reference
end

function Hitbox:isEnabled()
	return self.enabled
end

function Hitbox:setEnabled(b : boolean)
	self.enabled = b
end

return Hitbox
