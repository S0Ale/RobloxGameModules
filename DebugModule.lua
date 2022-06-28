local DebugModule = {}
DebugModule.__index = DebugModule

local MSG_TYPE = {
	INFO = 0,
	WARN = 1,
	ERROR = 2
}

--Services
local testService : TestService = game:GetService("TestService")

--Variables
local debugFolder = workspace.Debug

--Function that counts parameters
local function checkArgs(args)
	if #args > 3 then
		DebugModule:error("Error: TOO MANY ARGUMENTS", script, 11)
		return false
	end
	if #args == 0 then
		DebugModule:error("ERROR: TOO FEW ARGUMENTS", script, 15)
		return false
	end
	return true
end

--Function that prints an error
function DebugModule:error(...)
	local args = {...}
	if checkArgs(args) then testService:Error(...) end
end

--Function that prinst a special message
function DebugModule:message(...)
	local args = {...}
	if checkArgs(args) then testService:Message(...) end
end

--Function that prints a custom message
function DebugModule:printMsg(msgType : number, name : string, message : string)
	local t = "INFO"
	if msgType == MSG_TYPE.WARN then t = "WARN" end
	if msgType == MSG_TYPE.ERROR then t = "ERROR" end
	local start = "["..t.."], "..name..": "

	return start..message..";"
end

--Function that spawns a part in a certain position
function DebugModule:debugPos(pos)
	local p = Instance.new("Part")
	p.Transparency = .5
	p.Size = Vector3.new(1, 1, 1)
	p.CanCollide = false
	p.CanQuery = false
	p.CanTouch = false
	p.Anchored = true
	p.CFrame = CFrame.new(pos)
	p.Parent = debugFolder
	delay(1, function()
		p:Destroy()
	end)
end

--Function that spawns a part in order to visualize a region
function DebugModule:debugRegion(r : Region3)
	local p = Instance.new("Part")
	p.Transparency = .5
	p.Size = r.Size
	p.CanCollide = false
	p.CanQuery = false
	p.CanTouch = false
	p.Anchored = true
	p.CFrame = r.CFrame
	p.Parent = debugFolder
	p.Name = "RegionDebug"
end

return DebugModule
