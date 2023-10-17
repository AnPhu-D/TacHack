local Vector3Writer = {}

local ParamPopupFrame = script.Parent.Parent.Parent.Parent.Parent:WaitForChild("Main"):WaitForChild("Popups"):WaitForChild("CreateParam_Popup")

function Vector3Writer.CreatePayload()
	local Vector3WriterFrame = ParamPopupFrame:WaitForChild("ContentContainer"):WaitForChild("Vector3Writer")
	
	local PayloadContainer = Vector3WriterFrame:WaitForChild("PayloadContainer")
	local PayloadX = tonumber(PayloadContainer.XBox.TextBox.Text)
	local PayloadY = tonumber(PayloadContainer.YBox.TextBox.Text)
	local PayloadZ = tonumber(PayloadContainer.ZBox.TextBox.Text)
	
	if not PayloadX or not PayloadY then return Vector3.new(0,0,0) end
	return Vector3.new(PayloadX, PayloadY, PayloadZ)
end

return Vector3Writer
