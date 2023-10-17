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
local RS_Frame = RemoteSpoofer:WaitForChild("RemoteSelector")

local SelectedContainer = RS_Frame:WaitForChild("SelectedContainer")
local OptionDropdown = RS_Frame:WaitForChild("SelectionContainerDropdown")

--
local SelectionTemplate = script:WaitForChild("TemplateSelection")

-- Modules
local RemoteSelector = {}

local ClientUtil = script.Parent.Parent:WaitForChild("ClientUtil")
local FilepathModule = require(ClientUtil:WaitForChild("Filepath"))

-- State
RemoteSelector.DropdownConnections = {}
RemoteSelector.DropdownShowing = false

--------------------------------------------------

function RemoteSelector.Init()
	
	SelectedContainer.STARTUP.RemotePath.Text = "NO REMOTE SELECTED"
	RemoteSelector.ClearOptions()
	
	--Initialize Display
	for _,RemoteReference : ObjectValue in ipairs(ExposedRemotes:GetChildren()) do
		local Remote = RemoteReference.Value
		RemoteSelector.RenderOption(Remote)
	end
	
end

--------------------------------------------------

function RemoteSelector.ShowDropdown()
	RemoteSelector.DropdownShowing = true
	RS_Frame.Detail.Visible = true
	OptionDropdown.Visible = true
end

function RemoteSelector.HideDropdown()
	RemoteSelector.DropdownShowing = false
	RS_Frame.Detail.Visible = false
	OptionDropdown.Visible = false
end

--------------------------------------------------

function RemoteSelector.ClearOptions()
	for _, Option : Frame in ipairs(OptionDropdown:GetChildren()) do
		print(Option)
		if not Option:IsA("Frame") then continue end
		if not Option:FindFirstChild("RemotePath") then continue end
		
		--TODO: Disconnect Option Connections
		if RemoteSelector.DropdownConnections[Option] then RemoteSelector.DropdownConnections[Option]:Disconnect() end
		Option:Destroy()
	end
end

function RemoteSelector.RenderOption(TargetRemote : RemoteEvent | RemoteFunction)
	local FilePath = FilepathModule.GetFilePath(TargetRemote)
	if not FilePath then return end
	
	local NewOptionFrame = SelectionTemplate:Clone()
	NewOptionFrame.Name = FilePath
	NewOptionFrame.RemotePath.Text = FilePath
	NewOptionFrame.Visible = true
	NewOptionFrame.RemoteReference.Value = TargetRemote
	
	print("Assinging targetRemote as",TargetRemote)
	
	NewOptionFrame.Parent = OptionDropdown
	
	RemoteSelector.DropdownConnections[NewOptionFrame] = NewOptionFrame.InputBegan:Connect(function(IO)
		if IO.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
		
		script.SelectedOption.Value = NewOptionFrame.RemoteReference.Value
		
		RemoteSelector.ClearSelectionContainer()
		RemoteSelector.CloneOptionToSelectionContainer(NewOptionFrame)
		
		RemoteSelector.HideDropdown()
		
		script:WaitForChild("Signals"):WaitForChild("OnRemoteChanged"):Fire(script.SelectedOption.Value)
		
	end)
end

--------------------------------------------------

function RemoteSelector.GetLinkedRemote(OptionFrame : Frame)
	return OptionFrame.RemoteReference.Value
end

--------------------------------------------------

function RemoteSelector.ClearSelectionContainer()
	for _,Child in ipairs(SelectedContainer:GetChildren()) do
		Child:Destroy()
	end
end

function RemoteSelector.CloneOptionToSelectionContainer(OptionFrame : Frame)
	local NOF = OptionFrame:Clone()
	NOF.Parent = SelectedContainer
end

--------------------------------------------------

--------------------------------------------------

RS_Frame.InputBegan:Connect(function(IO)
	if IO.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
	
	if RemoteSelector.DropdownShowing then
		RemoteSelector.HideDropdown()
	else
		RemoteSelector.ShowDropdown()
	end
end)

--------------------------------------------------

return RemoteSelector
