local booleanWriter = {}

local ParamPopupFrame = script.Parent.Parent.Parent.Parent.Parent:WaitForChild("Main"):WaitForChild("Popups"):WaitForChild("CreateParam_Popup")

function booleanWriter.CreatePayload()
	local booleanWriterFrame = ParamPopupFrame:WaitForChild("ContentContainer"):WaitForChild("booleanWriter")
	
	local SelectedPayload = booleanWriterFrame.DropdownSelected.SelectedPayloadFrame.TextLabel.Text
	if SelectedPayload == "true" then return true else return false end
end

return booleanWriter
