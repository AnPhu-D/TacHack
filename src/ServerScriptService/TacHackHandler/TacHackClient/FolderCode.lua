-- Services
local RS = game:GetService("ReplicatedStorage")


-- System Assets
local TacHack_RS = RS:WaitForChild("TacHack")
local ExposedRemotes = TacHack_RS:WaitForChild("ExposedRemoteReferences")

-- Modules
local TacHack = {}

local ClientSubModules = script:WaitForChild("ClientSubModules")
local RequestsModule = require(ClientSubModules:WaitForChild("Requests"))
local ParametersModule = require(ClientSubModules:WaitForChild("Parameters"))

local GUI_Submodules = script:WaitForChild("ClientGUIHandlers")
local RemoteSelectorHandler = require(GUI_Submodules:WaitForChild("RemoteSelector"))
local RequestInformationHandler = require(GUI_Submodules:WaitForChild("RequestInformation"))
local RequestContainerHandler = require(GUI_Submodules:WaitForChild("RequestContainer"))

local ParamPopupHandler = require(GUI_Submodules:WaitForChild("ParamPopup"))
local RequestPopupHandler = require(GUI_Submodules:WaitForChild("RequestPopup"))

--------------------------------------------------

function TacHack.Init()
	
	if ExposedRemotes:GetAttribute("Ready") then
		
	else
		ExposedRemotes:GetAttributeChangedSignal("Ready"):Wait()
		if not ExposedRemotes:GetAttribute("Ready") then ExposedRemotes:GetAttributeChangedSignal("Ready"):Wait() end
	end

	
	print("Started")
	
	RemoteSelectorHandler.Init()
	RequestInformationHandler.Init()
	RequestContainerHandler.Init()
	
	ParamPopupHandler.Init()
	RequestPopupHandler.Init()
	
	--------------------------------------------------

end

--------------------------------------------------



--------------------------------------------------



--------------------------------------------------



--------------------------------------------------

TacHack.Init()

--------------------------------------------------

return TacHack
