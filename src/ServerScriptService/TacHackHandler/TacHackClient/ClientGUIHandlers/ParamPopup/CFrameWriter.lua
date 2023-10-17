local CFrameWriter = {}

local ParamPopupFrame = script.Parent.Parent.Parent.Parent.Parent:WaitForChild("Main"):WaitForChild("Popups"):WaitForChild("CreateParam_Popup")

function CFrameWriter.CreatePayload()
	local CFrameWriterFrame = ParamPopupFrame:WaitForChild("ContentContainer"):WaitForChild("CFrameWriter")
	
	local PayloadContainer = CFrameWriterFrame:WaitForChild("PayloadContainer")
	local PayloadX = tonumber(PayloadContainer.XBox.TextBox.Text)
	local PayloadY = tonumber(PayloadContainer.YBox.TextBox.Text)
	local PayloadZ = tonumber(PayloadContainer.ZBox.TextBox.Text)
	
	local PayloadOX = tonumber(PayloadContainer.OXBox.TextBox.Text)
	local PayloadOY = tonumber(PayloadContainer.OYBox.TextBox.Text)
	local PayloadOZ = tonumber(PayloadContainer.OZBox.TextBox.Text)
	
	if not PayloadX or not PayloadY then return CFrame.new(0,0,0) end
	return CFrame.new(PayloadX,PayloadY,PayloadZ) * CFrame.Angles(math.rad(PayloadOX), math.rad(PayloadOY), math.rad(PayloadOZ))
end

return CFrameWriter
