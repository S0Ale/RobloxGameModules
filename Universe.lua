local UniverseClass = {}
UniverseClass.__index = UniverseClass

--Services
local runService = game["Run Service"]
local repStorage = game["ReplicatedStorage"]

--Modules
local RaycastModule = require(repStorage:FindFirstChild("RaycastModule"))
local MaidClass = require(repStorage.Classes:FindFirstChild("Maid"))

--Variables
local elFolder : Folder = workspace.Elements
local rayModule = RaycastModule.new()

local RAY_HEIGHT = 10

function UniverseClass.new()
	local data = {
		elements = {},
		heartbeat = nil
	}

	return setmetatable(data, UniverseClass)
end

function UniverseClass:CreateElement(name : string, instanceType : string)
	local newEl = Instance.new(instanceType)
	newEl.Name = name
	newEl.Parent = elFolder

	table.insert(self.elements, newEl)
	return newEl
end

function UniverseClass:AddElement(el : Instance)
	if el:IsA("BasePart") or el:IsA("Model") then
		el.Parent = elFolder
		table.insert(self.elements, el)
	end
end

function UniverseClass:RemoveElement(el : Instance)
	local index = table.find(self.elements, el, 1)
	if index then table.remove(self.elements, index) end
end

function UniverseClass:Start()
	self.heartbeat = runService.Heartbeat:Connect(function(delta)
		self:Update(delta)
	end)
end

function UniverseClass:Update(delta)
	for _,el in pairs(elFolder:GetChildren()) do
		local part = el

		if part:IsA("BasePart") or part:IsA("Model") then
			if el:IsA("Model") then
				part = el.PrimaryPart
			end

			if not part.Anchored then
				rayModule:setParams({el}, Enum.RaycastFilterType.Blacklist, true, "")

				local rayOrigin = part.CFrame.Position
				local rayDir = -(part.CFrame.UpVector) * RAY_HEIGHT
				local result = rayModule:ray(rayOrigin, rayDir)

				local gravityForce = part:GetMass() * 25
				if result then
					local distance = (rayOrigin - result.Position).Magnitude
					if distance > 2 then
						gravityForce = 5
					end

					gravityForce *= -(result.Normal)
					if string.sub(part.Name, 1, 2) == "sp" then gravityForce *= 2 end
				else
					gravityForce *= -(workspace:FindFirstChild("Baseplate").CFrame.UpVector)
				end

				part:ApplyImpulseAtPosition(gravityForce, part.CFrame.Position)
			end
		end
	end
end

function UniverseClass:Stop()
	self.heartbeat:Disconnect()
	self.heartbeat = nil
end

function UniverseClass:Clean()
	self:Stop()
	for _,el in pairs(elFolder:GetChildren()) do
		el:Destroy()
	end
	self.Start()
end
UniverseClass.Destroy = UniverseClass.Clean

return UniverseClass
