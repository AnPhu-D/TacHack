local numberWriter = {}

local ParamPopupFrame = script.Parent.Parent.Parent.Parent.Parent:WaitForChild("Main"):WaitForChild("Popups"):WaitForChild("CreateParam_Popup")

function numberWriter.CreatePayload()
	local numberWriterFrame = ParamPopupFrame:WaitForChild("ContentContainer"):WaitForChild("numberWriter")
	local PayloadContent = numberWriterFrame.TextboxBackground.TextBox.Text
	return tonumber(PayloadContent)
end

return numberWriter
