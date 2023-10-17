-- Services
local RS = game:GetService("ReplicatedStorage")

-- System Assets
local Enum_RS = RS:WaitForChild("EnumService")
local Events = Enum_RS:WaitForChild("Events")
local NotifSpawner = Enum_RS:WaitForChild("NotifSpawner")

local FolderTemplate = script:WaitForChild("FolderTemplate")
local ItemTemplate = script:WaitForChild("ItemTemplate")


local EnumService = {}


--------------------------------------------------

function EnumService.Init()

end

--------------------------------------------------

function EnumService.GetPlayerNotif(FromPlayer : Player)
	local FoundSpawner = NotifSpawner:FindFirstChild(FromPlayer.Name)
	if FoundSpawner then return FoundSpawner end

	local NewSpawner = Instance.new("Folder")
	NewSpawner.Name = FromPlayer.Name

	NewSpawner.Parent = NotifSpawner
	return NewSpawner
end

--------------------------------------------------

function EnumService.EnumItem(FromPlayer : Player, ItemFilePath : string)

	local PayloadPath = string.split(ItemFilePath, '.')
	local CurrentPtr = game

	for PathIndex, PathString in ipairs(PayloadPath) do
		if PathIndex == 1 then continue end
		CurrentPtr = CurrentPtr:FindFirstChild(PathString)
		if not CurrentPtr then return nil end
	end

	local NewItem = ItemTemplate:Clone()
	NewItem.Name = CurrentPtr.Name
	NewItem.Value  = CurrentPtr.Value

	NewItem.Parent = EnumService.GetPlayerNotif(FromPlayer)
	print(NewItem)
end

function EnumService.EnumDir(FromPlayer : Player, DirFilePath : string)
	local PayloadPath = string.split(DirFilePath, '.')
	local CurrentPtr = game

	for PathIndex, PathString in ipairs(PayloadPath) do
		if PathIndex == 1 then continue end
		CurrentPtr = CurrentPtr:FindFirstChild(PathString)
		if not CurrentPtr then return nil end
	end

	local NewFolder = FolderTemplate:Clone()
	NewFolder.Name = CurrentPtr.Name

	for _,Child : Instance in ipairs(CurrentPtr:GetChildren()) do
		local NewItem = ItemTemplate:Clone()
		NewItem.Name = Child.Name
		NewItem.Value = Child.ClassName

		NewItem.Parent = NewFolder
	end

	NewFolder.Parent = EnumService.GetPlayerNotif(FromPlayer)
end

--------------------------------------------------

game:GetService("Players").PlayerAdded:Connect(function(Player : Player)
	EnumService.GetPlayerNotif(Player)
end)

--------------------------------------------------

Events:WaitForChild("EnumDir").OnServerEvent:Connect(function(FromPlayer : Player, FilePath : string)
	EnumService.EnumDir(FromPlayer, FilePath)
end)


Events:WaitForChild("EnumItem").OnServerEvent:Connect(function(FromPlayer : Player, FilePath : string)
	EnumService.EnumItem(FromPlayer, FilePath)
end)

--------------------------------------------------

return EnumService
