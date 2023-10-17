
-- GUI Assets
local ParamPopupFrame = script.Parent.Parent.Parent.Parent:WaitForChild("Main"):WaitForChild("Popups"):WaitForChild("CreateParam_Popup")
local ContentContainer = ParamPopupFrame:WaitForChild("ContentContainer")

local TypeSelector = ContentContainer:WaitForChild("TypeSelector")
local TypeLabel = TypeSelector:WaitForChild("DropdownSelected"):WaitForChild("SelectedTypeFrame"):WaitForChild("TextLabel")
local TypeDropdown = TypeSelector:WaitForChild("DropdownSelected"):WaitForChild("DropdownContainer")

local ConfirmBar = ContentContainer:WaitForChild("ConfirmBar")

-- Modules
local ParamPopup = {}
local WriterModules = {}

local ClientSubModules = script.Parent.Parent:WaitForChild("ClientSubModules")
local RequestModule = require(ClientSubModules:WaitForChild("Requests"))
local ParamModule = require(ClientSubModules:WaitForChild("Parameters"))

local GUI_Submodules = script.Parent.Parent:WaitForChild("ClientGUIHandlers")
local RequestInformationModule = require(GUI_Submodules:WaitForChild("RequestInformation"))

local ClientUtil = script.Parent.Parent:WaitForChild("ClientUtil")
local FilepathModule = require(ClientUtil:WaitForChild("Filepath"))
local SelectionStateModule = require(ClientUtil:WaitForChild("SelectionState"))

ParamPopup.ParentParamUID = nil

--------------------------------------------------

function ParamPopup.Init()
	
	ParamPopup.ParentParamUID = nil
	
	for _,WriterModule : ModuleScript in ipairs(script:GetChildren()) do
		if not WriterModule:IsA("ModuleScript") then continue end
		if not WriterModules[WriterModule.Name] then
			WriterModules[WriterModule.Name] = require(WriterModule)
		end
	end

	ParamPopup.SetCurrentType("none")
	ParamPopup.HideTypeDropdown()
	ParamPopup.HideWriters()

	for _,TypeOptionFrame : Frame in ipairs(TypeDropdown:GetChildren()) do
		if not TypeOptionFrame:IsA("Frame") then continue end
		TypeOptionFrame.InputBegan:Connect(function(IO)
			if IO.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
			ParamPopup.SetCurrentType(TypeOptionFrame.TextLabel.Text)
			ParamPopup.HideTypeDropdown()
			ParamPopup.ShowWriter(ParamPopup.GetCurrentType())
		end)
	end

	-----------------------------------------------
	-- Configure BoolWriter

	local BoolWriter = ContentContainer.booleanWriter
	local BoolDropdownSel = BoolWriter:WaitForChild("DropdownSelected")
	local BoolDropdown = BoolDropdownSel:WaitForChild("DropdownContainer")
	local BoolPayloadFrame = BoolDropdownSel:WaitForChild("SelectedPayloadFrame")

	BoolDropdownSel.InputBegan:Connect(function(IO)
		if IO.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

		BoolDropdown.Visible = not BoolDropdown.Visible
	end)

	BoolDropdown:WaitForChild("trueOption").InputBegan:Connect(function(IO)
		if IO.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

		BoolPayloadFrame:WaitForChild("TextLabel").Text = "true"
		BoolDropdown.Visible = false
	end)

	BoolDropdown:WaitForChild("falseOption").InputBegan:Connect(function(IO)
		if IO.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

		BoolPayloadFrame:WaitForChild("TextLabel").Text = "false"
		BoolDropdown.Visible = false
	end)


end

--------------------------------------------------

function ParamPopup.Appear()
	ParamPopupFrame.Visible = true
	ParamPopup.ResetState()
end

function ParamPopup.Disappear()
	ParamPopupFrame.Visible = false
	ParamPopup.ResetState()
end

--------------------------------------------------

function ParamPopup.SetCurrentType(NewType : string)
	TypeLabel.Text = NewType
end

function ParamPopup.GetCurrentType()
	return TypeLabel.Text
end

--------------------------------------------------

function ParamPopup.HideWriters()
	for _,Writer : Frame in ipairs(ContentContainer:GetChildren()) do
		if Writer:GetAttribute("IsWriter") == true then
			Writer.Visible = false
		end
	end

	ContentContainer.booleanWriter.DropdownSelected.DropdownContainer.Visible = false
end

function ParamPopup.ShowWriter(Type : string)
	ParamPopup.HideWriters()

	local WriterFrame : Frame = ContentContainer:FindFirstChild(Type.."Writer")
	if not WriterFrame then return end

	for _,TB : TextBox in ipairs(WriterFrame:GetDescendants()) do
		if not TB:IsA("TextBox") then continue end
		TB.Text = TB.PlaceholderText
	end

	WriterFrame.Visible = true
end

--------------------------------------------------

function ParamPopup.ShowTypeDropdown()
	TypeDropdown.Visible = true
end

function ParamPopup.HideTypeDropdown()
	TypeDropdown.Visible = false
end

--------------------------------------------------

function ParamPopup.ResetState()
	ParamPopup.HideWriters()
	ParamPopup.HideTypeDropdown()
	
	ParamPopup.ParentParamUID = nil
	ParamPopup.SetCurrentType("none")
end

--------------------------------------------------

function ParamPopup.GetPayload()
	local Type = ParamPopup.GetCurrentType()
	if Type == "none" then return end

	local TargetWriterModule = WriterModules[Type.."Writer"]
	if not TargetWriterModule then warn("No writer module found for type",Type) return end

	local Payload = TargetWriterModule.CreatePayload()
	return Payload
end

--------------------------------------------------

ConfirmBar:WaitForChild("Confirm").MouseButton1Click:Connect(function()
	--TODO: Implement hook to parameter and then to request or something haha
	local CurrentPayload = ParamPopup.GetPayload()
	local ParamType = ParamPopup.GetCurrentType()
	
	if ParamType == "none" then
		CurrentPayload = nil
		ParamType = "none"
	end
	
	-- Create and assign the payload
	local CurrentRUID = SelectionStateModule.GetSelectedRequest()
	
	------------------------------------------------
	
	local NewParamUID
	
	if ParamType ~= "table" then
		NewParamUID = ParamModule.CreateRegularParameter(ParamType, CurrentPayload)
	else
		NewParamUID = ParamModule.CreateTableParameter()
	end
	
	if not ParamPopup.ParentParamUID then
		RequestModule.AddParameter(CurrentRUID, NewParamUID, #RequestModule.GetRequestPtr(CurrentRUID).ParamList + 1)
	else
		ParamModule.InsertPayload_Table(ParamPopup.ParentParamUID, NewParamUID)
	end
	
	------------------------------------------------

	ParamPopup.ResetState()
	ParamPopupFrame.Visible = false
	
	RequestInformationModule.DisplayRequest(CurrentRUID)
end)

ParamPopupFrame:WaitForChild("TopBar"):WaitForChild("ExitButton").MouseButton1Click:Connect(function()
	ParamPopup.ResetState()
	ParamPopupFrame.Visible = false
end)

TypeSelector:WaitForChild("DropdownSelected").InputBegan:Connect(function(IO)
	if IO.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

	if TypeDropdown.Visible == true then
		ParamPopup.HideTypeDropdown()
	else
		ParamPopup.ShowTypeDropdown()
	end
end)

ParamPopupFrame.Parent.Parent:FindFirstChild("CreateNewParamButton", true).MouseButton1Click:Connect(function()
	if SelectionStateModule.GetSelectedRemote() == nil then return end
	
	ParamPopup.Appear()
	ParamPopup.ParentParamUID = nil
end)

script:WaitForChild("Signals"):WaitForChild("OpenPopup").Event:Connect(function(ParamParentUID : number)
	ParamPopup.Appear()
	ParamPopup.ParentParamUID = ParamParentUID
end)

--------------------------------------------------

return ParamPopup
