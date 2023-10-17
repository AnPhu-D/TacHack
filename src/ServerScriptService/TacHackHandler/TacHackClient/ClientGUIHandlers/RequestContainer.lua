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
local RC_Frame = RemoteSpoofer:WaitForChild("MainContentContainer"):WaitForChild("LeftFrame"):WaitForChild("RequestContainer")


--
local RequestTemplate = script:WaitForChild("RequestTemplate")


-- Modules
local RequestContainer = {}

local ClientSubModules = script.Parent.Parent:WaitForChild("ClientSubModules")
local RequestModule = require(ClientSubModules:WaitForChild("Requests"))
local ParamModule = require(ClientSubModules:WaitForChild("Parameters"))

local ClientUtil = script.Parent.Parent:WaitForChild("ClientUtil")
local FilepathModule = require(ClientUtil:WaitForChild("Filepath"))
local SelectionStateModule = require(ClientUtil:WaitForChild("SelectionState"))

local GUI_Submodules = script.Parent.Parent:WaitForChild("ClientGUIHandlers")
local RequestInformationModule = require(GUI_Submodules:WaitForChild("RequestInformation"))

-- State
RequestContainer.FrameConnections = {}

--------------------------------------------------

function RequestContainer.Init()

	--TODO: Clear on startup to empty example UIs
	RequestContainer.ClearRequests()

end

--------------------------------------------------



--------------------------------------------------

function RequestContainer.ClearRequests()
	for _,RequestFrame : Frame in ipairs(RC_Frame:GetChildren()) do
		if not RequestFrame:IsA("Frame") then continue end
		if RequestFrame:GetAttribute("DoNotDelete") == true then continue end

		if RequestContainer.FrameConnections[RequestFrame] then RequestContainer.FrameConnections[RequestFrame]:Disconnect() end
		RequestFrame:Destroy()
	end

	RequestContainer.FrameConnections = {}
	script:WaitForChild("HighlightedRequestFrame").Value = nil
end

function RequestContainer.RenderRequest(RequestUID : number)
	local Request : RequestModule.TacHack_Request = RequestModule.GetRequestPtr(RequestUID)

	local ParamCount = #Request.ParamList
	local Nickname = Request.Nickname or "Unnamed Request"

	local RequestFrame = RequestTemplate:Clone()
	RequestFrame.Name = "RequestFrame_"..tostring(RequestUID)
	RequestFrame:SetAttribute("RequestUID", RequestUID)
	
	RequestFrame.RequestNickname.Text = Nickname
	RequestFrame.ParamCount.Text = ParamCount.." Parameters"

	RequestFrame.LayoutOrder = RequestUID

	RequestFrame.Visible = true
	RequestFrame.Parent = RC_Frame

	RequestContainer.FrameConnections[RequestFrame] = RequestFrame.InputBegan:Connect(function(IO)
		if IO.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

		RequestContainer.HighlightRequest(RequestFrame)
		
		RequestInformationModule.DisplayRequest(RequestUID)
	end)
end

function RequestContainer.GetRequestUID(RequestFrame : Frame)
	return RequestFrame:GetAttribute("RequestUID")
end

--------------------------------------------------

function RequestContainer.RenderRemoteRequests(TargetRemote : RemoteEvent | RemoteFunction)
	RequestContainer.ClearRequests()

	for RUID, RemoteHandle in ipairs(RequestModule.RequestCache) do
		local IterRemote = RemoteHandle.TargetRemote
		if IterRemote  == TargetRemote then
			RequestContainer.RenderRequest(RUID)
		end
	end
end

--------------------------------------------------

function RequestContainer.HighlightRequest(RequestFrame : Frame)
	local HighlightedFrame = RequestContainer.GetHighlightedFrame()
	if HighlightedFrame == RequestFrame then return end
	RequestContainer.UnhighlightRequest(HighlightedFrame)

	script:WaitForChild("HighlightedRequestFrame").Value = RequestFrame

	RequestFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	RequestFrame.MainInner.BackgroundColor3 = Color3.fromRGB(176, 202, 203)

	for _,TextLabel : TextLabel in ipairs(RequestFrame:GetChildren()) do
		if not TextLabel:IsA("TextLabel") then continue end
		TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.FontFace.Bold = true
	end

end

function RequestContainer.UnhighlightRequest(RequestFrame : Frame)
	
	if not RequestFrame then return end
	
	script:WaitForChild("HighlightedRequestFrame").Value = nil

	RequestFrame.BackgroundColor3 = Color3.fromRGB(50, 62, 62)
	RequestFrame.MainInner.BackgroundColor3 = Color3.fromRGB(5, 8, 13)

	for _,TextLabel : TextLabel in ipairs(RequestFrame:GetChildren()) do
		if not TextLabel:IsA("TextLabel") then continue end
		TextLabel.TextColor3 = Color3.fromRGB(176, 202, 203)
		TextLabel.FontFace.Bold = false
	end

end

function RequestContainer.GetHighlightedFrame()
	return script:WaitForChild("HighlightedRequestFrame").Value
end



--------------------------------------------------

script.Parent:WaitForChild("RequestPopup"):WaitForChild("Signals"):WaitForChild("OnRequestCreated").Event:Connect(function(NewRequestUID : number)
	local RequestHandle = RequestModule.GetRequestPtr(NewRequestUID)
	if not RequestHandle then return end
	
	local RequestRemote = RequestHandle.TargetRemote
	if RequestRemote ~= SelectionStateModule.GetSelectedRemote() then return end
	
	RequestContainer.RenderRequest(NewRequestUID)
end)

script.Parent:WaitForChild("RemoteSelector"):WaitForChild("Signals"):WaitForChild("OnRemoteChanged").Event:Connect(function(NewRemote : RemoteEvent | RemoteFunction)
	RequestContainer.RenderRemoteRequests(NewRemote)
end)



--------------------------------------------------

return RequestContainer
