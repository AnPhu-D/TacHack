local SelectionState = {}

function SelectionState.GetSelectedRemote()
	return script.Parent.Parent:WaitForChild("ClientGUIHandlers"):WaitForChild("RemoteSelector"):WaitForChild("SelectedOption").Value
end

function SelectionState.GetSelectedRequest()
	if not script.Parent.Parent:WaitForChild("ClientGUIHandlers"):WaitForChild("RequestContainer"):WaitForChild("HighlightedRequestFrame").Value then return nil end
	return script.Parent.Parent:WaitForChild("ClientGUIHandlers"):WaitForChild("RequestContainer"):WaitForChild("HighlightedRequestFrame").Value:GetAttribute("RequestUID")
end

return SelectionState
