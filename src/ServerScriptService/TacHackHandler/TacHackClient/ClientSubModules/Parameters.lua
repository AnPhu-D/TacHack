-- Services


-- System Assets


-- Type Annotation
export type TacHack_Parameter = {
	DataType : string,
	Payload : any,
	IsTable : boolean
}

-- Modules
local Parameters = {}

Parameters.ParameterUIDCounter =1
Parameters.ParameterCache = {}

--------------------------------------------------

function Parameters.Init()
	
end

--------------------------------------------------

function Parameters.CreateRegularParameter(DataType : string, Payload)
	local ParameterUID = Parameters.ParameterUIDCounter
	Parameters.ParameterUIDCounter += 1
	
	Parameters.ParameterCache[ParameterUID] = {}
	local NewParameter = Parameters.ParameterCache[ParameterUID]
	
	----------------------------------------------
	
	NewParameter.DataType = DataType
	NewParameter.Payload = Payload
	NewParameter.IsTable = false
	
	----------------------------------------------
	
	return ParameterUID
end

function Parameters.CreateTableParameter()
	-- Note that for table parameters, they contain integers which are references to the respective payloads
	local NewPUID = Parameters.CreateRegularParameter("Table", {})
	Parameters.GetParamPtr(NewPUID).IsTable = true
	
	return NewPUID
end

--------------------------------------------------

function Parameters.GetParamPtr(PUID : number)
	return Parameters.ParameterCache[PUID]
end

--------------------------------------------------

function Parameters.SetPayload(PUID : number, Payload)
	if not PUID or not Payload then return end
	
	local Parameter : TacHack_Parameter = Parameters.GetParamPtr(PUID)
	if not Parameter then return end
	
	if Parameter.IsTable then warn("Cannot directly set value of table param") return end
	
	local ParamType = Parameter.DataType
	if ParamType ~= typeof(Payload) then warn("Invalid payload for parameter type",ParamType) return end
	
	----------------------------------------------
	
	Parameter.Payload = Payload
end

--------------------------------------------------

function Parameters.SetPayload_Table(PUID : number, PKey : any, PayloadPUID : number)
	if not PUID or not PKey or not PayloadPUID then return end
	
	local Parameter : TacHack_Parameter = Parameters.GetParamPtr(PUID)
	if not Parameter then return end
	
	if not Parameter.IsTable then return end
	
	----------------------------------------------
	
	Parameter.Payload[PKey] = PayloadPUID
end

--------------------------------------------------

function Parameters.InsertPayload_Table(PUID : number, PayloadPUID : number)
	if not PUID or not PayloadPUID then return end

	local Parameter : TacHack_Parameter = Parameters.GetParamPtr(PUID)
	if not Parameter then return end

	if not Parameter.IsTable then return end

	----------------------------------------------
	
	table.insert(Parameter.Payload, PayloadPUID)
end

function Parameters.RemovePayload_Table(PUID : number, PayloadPUID : number)
	if not PUID or not PayloadPUID then return end

	local Parameter : TacHack_Parameter = Parameters.GetParamPtr(PUID)
	if not Parameter then return end

	if not Parameter.IsTable then return end

	----------------------------------------------

	local PayloadIndex = table.find(Parameter.Payload, PayloadPUID)
	if not PayloadIndex then return end
	
	table.remove(Parameter.Payload, PayloadIndex)
end

--------------------------------------------------

function Parameters.UnpackPayload(PUID : number)
	local Parameter : TacHack_Parameter = Parameters.GetParamPtr(PUID)
	if not Parameter then return end
	
	if Parameter.IsTable then return Parameters.UnpackPayload_Table(PUID) end
	
	----------------------------------------------
	
	return Parameter.Payload
end

function Parameters.UnpackPayload_Table(PUID : number, StackTrace : {[number] : number})
	local Parameter : TacHack_Parameter = Parameters.GetParamPtr(PUID)
	if not Parameter then return end
	
	if not Parameter.IsTable then return end
	
	if not StackTrace then StackTrace = {} end
	if table.find(StackTrace, PUID) then warn("Nested table parameter.") return end
	table.insert(StackTrace, PUID)
	
	----------------------------------------------
	
	local UnpackedParam = {}
	for IterPKey, IterPUID in pairs(Parameter.Payload) do
		local IterParameter : TacHack_Parameter = Parameters.GetParamPtr(PUID)
		if not IterParameter then warn("Child parameter", IterPUID," was not found.") continue end
		
		UnpackedParam[IterPKey] = Parameters.UnpackPayload(IterPUID)
	end 
	
	return UnpackedParam
end

--------------------------------------------------

function Parameters.StringEncode(PUID : number)
	local Parameter : TacHack_Parameter = Parameters.GetParamPtr(PUID)
	if not Parameter then return end
	
	if Parameter.IsTable then return "Table..." end
	if typeof(Parameter.Payload) == typeof("String") then return "\""..Parameter.Payload.."\"" end
	
	----------------------------------------------
	
	return tostring(Parameter.Payload)
end

--------------------------------------------------

Parameters.Init()

--------------------------------------------------

return Parameters
