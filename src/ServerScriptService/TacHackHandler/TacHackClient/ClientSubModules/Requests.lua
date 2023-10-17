-- Services



-- System Assets


-- Type Annotation
export type TacHack_Request = {
	TargetRemote : RemoteEvent | RemoteFunction, 
	ParamList : {[number] : number},
	Nickname : string,
}


-- Modules
local Requests = {}
--: {
--	RequestUIDCounter : number, 
--	RequestCache : {[number] : TacHack_Request}
--} = {}
local Parameters

-- Module Vars
Requests.RequestUIDCounter = 1
Requests.RequestCache = {}

--------------------------------------------------

function Requests.Init()
	if not Parameters then Parameters = require(script.Parent:WaitForChild("Parameters")) end
end

--------------------------------------------------

function Requests.CreateEmptyRequest() : number
	local RequestUID = Requests.RequestUIDCounter
	Requests.RequestUIDCounter += 1
	
	Requests.RequestCache[RequestUID] = {}
	local NewRequest = Requests.RequestCache[RequestUID]
	
	----------------------------------------------
	
	NewRequest.TargetRemote = nil
	NewRequest.ParamList = {} -- Container for ParamIDs
	
	----------------------------------------------
	
	return RequestUID
end

--------------------------------------------------

function Requests.GetRequestPtr(RUID : number) : TacHack_Request
	return Requests.RequestCache[RUID]
end

--------------------------------------------------

function Requests.AssignRemote(RUID : number, TargetRemote : RemoteEvent | RemoteFunction) : nil
	local Request : TacHack_Request = Requests.GetRequestPtr(RUID)
	if not Request then return end
	
	Request.TargetRemote = TargetRemote
end

--------------------------------------------------

function Requests.AddParameter(RUID : number, PUID : number, ParamIndex : number)
	if not RUID or not PUID or not ParamIndex then warn("Insufficient parameters passed") return end
	
	local Request : TacHack_Request = Requests.GetRequestPtr(RUID)
	if not Request then return end
	
	if Request.ParamList[ParamIndex] then warn("FIXME: Show Client Warning (Cannot over existing param)") return end
	if not Parameters.GetParamPtr(PUID) then warn("FIXME: Show Client Warning (Cannot add nonexistant param)") return end
	
	----------------------------------------------
	
	Request.ParamList[ParamIndex] = PUID
end

function Requests.RemoveParameter(RUID : number, ParamIndex : number)
	if not RUID or not ParamIndex then warn("Insufficient parameters passed") return end
	
	local Request : TacHack_Request = Requests.GetRequestPtr(RUID)
	if not Request then return end
	
	if not Request.ParamList[ParamIndex] then warn("FIXME: Show Client Warning (Cannot remove nonexistant param)") return end
	
	----------------------------------------------
	
	Request.ParamList[ParamIndex] = nil
end

function Requests.ClearParameters(RUID : number)
	if not RUID then warn("Insufficient parameters passed") return end
	
	local Request : TacHack_Request = Requests.GetRequestPtr(RUID)
	if not Request then return end
	
	----------------------------------------------
	
	Request.ParamList = nil
	Request.ParamList = {}
end

--------------------------------------------------

function Requests.AssignNickname(RUID : number, Nickname : string)
	Requests.GetRequestPtr(RUID).Nickname = Nickname
end

--------------------------------------------------

Requests.Init()

--------------------------------------------------


return Requests
