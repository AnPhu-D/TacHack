-- Services
local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TweenService")
local PS = game:GetService("Players")

-- System Assets
local TacHack_RS = RS:WaitForChild("TacHack")
local ExposedRemotes = TacHack_RS:WaitForChild("ExposedRemoteReferences")

-- GUI Assets
local GUI_Main = PS.LocalPlayer.PlayerGui:WaitForChild("TacHack"):WaitForChild("Main")
local ContentContainer = GUI_Main:WaitForChild("ContentContainer")
local RemoteSpoofer = ContentContainer:WaitForChild("RemoteSpoofer")

local RI_Container = RemoteSpoofer:WaitForChild("MainContentContainer"):WaitForChild("RightFrame"):WaitForChild("FrameContents")
local RI_Frame = RI_Container:WaitForChild("RequestInfo")
local ParamContainer = RI_Container:WaitForChild("ParameterContainer")

--
local ParamTemplate = script:WaitForChild("ParameterTemplate")
local NewParamButtonTemplate = script:WaitForChild("NewParamButtonTemplate")

-- Modules
local RequestInformation = {}

local ClientSubModules = script.Parent.Parent:WaitForChild("ClientSubModules")
local RequestModule = require(ClientSubModules:WaitForChild("Requests"))
local ParamModule = require(ClientSubModules:WaitForChild("Parameters"))

local ClientUtil = script.Parent.Parent:WaitForChild("ClientUtil")
local FilepathModule = require(ClientUtil:WaitForChild("Filepath"))
local SelectionStateModule = require(ClientUtil:WaitForChild("SelectionState"))

-- State
RequestInformation.ParamDropdownConnections = {}
RequestInformation.ParamChildrenFrames = {}
RequestInformation.NewParamButtonConnections = {}

--------------------------------------------------

function RequestInformation.Init()

	for _,ParamExample : Frame in ipairs(ParamContainer:GetChildren()) do
		if not ParamExample:IsA("Frame") then continue end
		ParamExample:Destroy()
	end
	
	RI_Frame.ContentContainer.RequestNickname.Text = "No request selected."
	RI_Frame.ContentContainer["Request Filepath"].Text = ""
	RI_Frame.ContentContainer.RequestParamCount.Text = ""
	
end

--------------------------------------------------



--------------------------------------------------

function RequestInformation.DisplayRequest(RequestUID : number)
	
	RequestInformation.ClearDisplayingParams()
	
	----------------------------------------------
	
	local Request : RequestModule.TacHack_Request = RequestModule.GetRequestPtr(RequestUID)

	local NumParams = #Request.ParamList
	local Nickname = Request.Nickname
	local FilePath = FilepathModule.GetFilePath(Request.TargetRemote)

	RI_Frame.ContentContainer.RequestNickname.Text = Nickname or "Unnamed Request"
	RI_Frame.ContentContainer["Request Filepath"].Text = FilePath
	RI_Frame.ContentContainer.RequestParamCount.Text = NumParams

	----------------------------------------------

	for _,ParamUID : number in ipairs(Request.ParamList) do
		RequestInformation.DisplayParameter(ParamUID, ParamContainer)
	end
end

--------------------------------------------------

function RequestInformation.DisplayParameter(ParamUID : number, TargetParent : ScrollingFrame | Frame, ParamKey : string | nil)
	ParamKey = ParamKey or ""
	local Parameter : ParamModule.TacHack_Parameter = ParamModule.GetParamPtr(ParamUID)

	local ParamString = ParamModule.StringEncode(ParamUID)
	local UnpackedPayload = ParamModule.UnpackPayload(ParamUID)

	local ParamFrame = ParamTemplate:Clone()
	ParamFrame.Name = "ParamDisplay_"..tostring(ParamUID)

	ParamFrame.Info.PayloadDisplay.Text = ParamKey..ParamString
	ParamFrame.Info.PayloadTypeDisplay.Text = "("..typeof(UnpackedPayload)..")"

	if Parameter.IsTable then
		
		local NewParamButton = NewParamButtonTemplate:Clone()
		NewParamButton.Parent = ParamFrame.Info
		
		RequestInformation.NewParamButtonConnections[NewParamButton] = NewParamButton.MouseButton1Click:Connect(function()
			script.Parent:WaitForChild("ParamPopup"):WaitForChild("Signals"):WaitForChild("OpenPopup"):Fire(ParamUID)
		end)
		
		RequestInformation.ParamChildrenFrames[ParamFrame] = ParamFrame.ChildrenFrame
		local ChildrenFrame = RequestInformation.ParamChildrenFrames[ParamFrame]
		ChildrenFrame.Parent = script.CFS
		
		for IterParamKey,IterParamUID in pairs(Parameter.Payload) do
			RequestInformation.DisplayParameter(IterParamUID, ChildrenFrame, "["..tostring(IterParamKey).."] : ")
		end

		RequestInformation.ParamDropdownConnections[ParamFrame] = ParamFrame.Info.ToggleExpand.InputBegan:Connect(function(IO)
			if IO.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

			--------------------------------------------

			if ChildrenFrame.Parent == ParamFrame then
				ChildrenFrame.Parent = script.CFS
				ParamFrame.Info.ToggleExpand.ToggleExpand.Rotation = 0
			else
				ChildrenFrame.Parent = ParamFrame
				ParamFrame.Info.ToggleExpand.ToggleExpand.Rotation = 90
			end
		end)

	else
		ParamFrame.Info.ToggleExpand.ToggleExpand.ImageColor3 = Color3.fromRGB(100,100,100)
		RequestInformation.ParamDropdownConnections[ParamFrame] = 1
	end
	
	ParamFrame.Parent = TargetParent
end

function RequestInformation.ClearDisplayingParams()
	
	for NPB, NPBC in pairs(RequestInformation.NewParamButtonConnections) do
		NPBC:Disconnect()
	end
	RequestInformation.NewParamButtonConnections = {}
	
	for ParamFrame : Frame, CF : Frame in pairs(RequestInformation.ParamChildrenFrames) do
		CF:Destroy()
	end
	RequestInformation.ParamChildrenFrames = {}
	
	for ParamFrame : Frame, Connection in pairs(RequestInformation.ParamDropdownConnections) do
		if Connection and Connection ~= 1 then Connection:Disconnect() end
		ParamFrame:Destroy()
	end
	RequestInformation.ParamDropdownConnections = {}
	
end

--------------------------------------------------

RI_Container:WaitForChild("Sender"):WaitForChild("FireRemoteButton").MouseButton1Click:Connect(function()
	if not SelectionStateModule.GetSelectedRemote() then return end
	if not SelectionStateModule.GetSelectedRequest() then return end
	
	local TargetRequestPtr = RequestModule.GetRequestPtr(SelectionStateModule.GetSelectedRequest())
	local TargetRemote = TargetRequestPtr.TargetRemote
	
	local Params = {}
	for _,ParamUID in ipairs(TargetRequestPtr.ParamList) do
		table.insert(Params, ParamModule.UnpackPayload(ParamUID))
	end
	
	if TargetRemote:IsA("RemoteEvent") then
		local TargetRE : RemoteEvent = TargetRemote
		TargetRE:FireServer(table.unpack(Params))
	end
end)
--------------------------------------------------



--------------------------------------------------



--------------------------------------------------

return RequestInformation
