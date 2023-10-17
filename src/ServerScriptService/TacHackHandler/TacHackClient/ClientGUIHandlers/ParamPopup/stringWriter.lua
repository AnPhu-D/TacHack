local stringWriter = {}

local ParamPopupFrame = script.Parent.Parent.Parent.Parent.Parent:WaitForChild("Main"):WaitForChild("Popups"):WaitForChild("CreateParam_Popup")

function stringWriter.CreatePayload()
	local StringWriterFrame = ParamPopupFrame:WaitForChild("ContentContainer"):WaitForChild("stringWriter")
	local PayloadContent = StringWriterFrame.TextboxBackground.TextBox.Text
	return PayloadContent
end

return stringWriter
