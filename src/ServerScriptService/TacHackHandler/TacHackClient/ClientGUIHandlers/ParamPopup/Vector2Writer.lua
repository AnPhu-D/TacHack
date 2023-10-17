local Vector2Writer = {}

local ParamPopupFrame = script.Parent.Parent.Parent.Parent.Parent:WaitForChild("Main"):WaitForChild("Popups"):WaitForChild("CreateParam_Popup")

function Vector2Writer.CreatePayload()
	local Vector2WriterFrame = ParamPopupFrame:WaitForChild("ContentContainer"):WaitForChild("Vector2Writer")
	
	local PayloadContainer = Vector2WriterFrame:WaitForChild("PayloadContainer")
	local PayloadX = tonumber(PayloadContainer.XBox.TextBox.Text)
	local PayloadY = tonumber(PayloadContainer.YBox.TextBox.Text)
	
	if not PayloadX or not PayloadY then return Vector2.new(0,0) end
	return Vector2.new(PayloadX, PayloadY)
end

return Vector2Writer
