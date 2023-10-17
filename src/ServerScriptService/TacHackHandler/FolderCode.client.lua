local TH = require(script:WaitForChild("TacHackClient"))

game:GetService("UserInputService").InputBegan:Connect(function(IO, InChat)
	if InChat then return end
	
	if IO.KeyCode == Enum.KeyCode.H and game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
		script.Parent.Enabled = not script.Parent.Enabled
	end
end)