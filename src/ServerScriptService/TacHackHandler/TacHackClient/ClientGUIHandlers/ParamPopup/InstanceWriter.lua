local stringWriter = {}

local ParamPopupFrame = script.Parent.Parent.Parent.Parent.Parent:WaitForChild("Main"):WaitForChild("Popups"):WaitForChild("CreateParam_Popup")

function stringWriter.CreatePayload()
	local InstanceWriterFrame = ParamPopupFrame:WaitForChild("ContentContainer"):WaitForChild("InstanceWriter")
	local PayloadContent = InstanceWriterFrame.TextboxBackground.TextBox.Text
	
	local PayloadPath = string.split(PayloadContent, '.')
	local CurrentPtr = game
	
	for PathIndex, PathString in ipairs(PayloadPath) do
		if PathIndex == 1 then continue end
		CurrentPtr = CurrentPtr:FindFirstChild(PathString)
		if not CurrentPtr then return nil end
		print(CurrentPtr)
	end
	
	return CurrentPtr
end

return stringWriter
