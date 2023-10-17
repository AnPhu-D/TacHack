-- Services
local RS = game:GetService("ReplicatedStorage")
local PS = game:GetService("Players")

-- System Assets
local TacHack_RS = RS:WaitForChild("TacHack")
local ExposedRemotes = TacHack_RS:WaitForChild("ExposedRemoteReferences")

local RemoteExposer = {}

--------------------------------------------------

function RemoteExposer.Init()
	RemoteExposer.ExposeDirectory(RS)
	
	print("Ready")
	ExposedRemotes:SetAttribute("Ready",true)
end

--------------------------------------------------

function RemoteExposer.ExposeDirectory(TargetDir : Instance)
	for _,Remote : RemoteEvent | RemoteFunction in ipairs(TargetDir:GetDescendants()) do
		if not Remote:IsA("RemoteEvent") and not Remote:IsA("RemoteFunction") then continue end
		RemoteExposer.ExposeRemote(Remote)
	end
	TargetDir.DescendantAdded:Connect(function(Descendant : Instance)
		if not Descendant:IsA("RemoteEvent") and not Descendant:IsA("RemoteFunction") then return end
		RemoteExposer.ExposeRemote(Descendant)
	end)
end

function RemoteExposer.ExposeRemote(TargetRemote : RemoteEvent | RemoteFunction)
	local NewRemoteRef = Instance.new("ObjectValue")
	NewRemoteRef.Name = TargetRemote.Name
	NewRemoteRef.Value = TargetRemote

	NewRemoteRef.Parent = ExposedRemotes
end

--------------------------------------------------




--------------------------------------------------



--------------------------------------------------



return RemoteExposer
