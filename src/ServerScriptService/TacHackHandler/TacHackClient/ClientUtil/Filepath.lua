local Filepath = {}

function Filepath.GetFilePath(TargetInstance : Instance)

	local PathStack = {}
	local MovingInstanceReference = TargetInstance

	while MovingInstanceReference ~= nil do
		table.insert(PathStack, MovingInstanceReference.Name)
		MovingInstanceReference = MovingInstanceReference.Parent
	end

	local PathString = "game"
	for RI = 1, #PathStack-1 do
		PathString = PathString.."/"..PathStack[#PathStack-RI]
	end

	return PathString

end

return Filepath
