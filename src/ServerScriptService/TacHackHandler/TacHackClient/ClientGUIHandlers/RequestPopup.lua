
-- GUI Assets
local GUI_Main = script.Parent.Parent.Parent.Parent:WaitForChild("Main")

local ContentContainer = GUI_Main:WaitForChild("ContentContainer")
local RemoteSpoofer = ContentContainer:WaitForChild("RemoteSpoofer")
local RC_Frame = RemoteSpoofer:WaitForChild("MainContentContainer"):WaitForChild("LeftFrame"):WaitForChild("RequestContainer")

--

local RequestPopupFrame = GUI_Main:WaitForChild("Popups"):WaitForChild("CreateRequest_Popup")
local ContentContainer = RequestPopupFrame:WaitForChild("ContentContainer")

local NicknameBar = ContentContainer:WaitForChild("NicknameBar")
local PathBar = ContentContainer:WaitForChild("PathBar")

-- Modules
local RequestPopup = {}

local ClientSubModules = script.Parent.Parent:WaitForChild("ClientSubModules")
local RequestModule = require(ClientSubModules:WaitForChild("Requests"))
local ParamModule = require(ClientSubModules:WaitForChild("Parameters"))

local ClientUtil = script.Parent.Parent:WaitForChild("ClientUtil")
local FilepathModule = require(ClientUtil:WaitForChild("Filepath"))

--------------------------------------------------

function RequestPopup.Init()
	RequestPopup.Disappear()
end

--------------------------------------------------

function RequestPopup.Appear()
	RequestPopupFrame.Visible = true
	RequestPopup.ResetState()
end

function RequestPopup.Disappear()
	RequestPopupFrame.Visible = false
	RequestPopup.ResetState()
end

function RequestPopup.ResetState()
	NicknameBar.TextBox.Text = NicknameBar.TextBox.PlaceholderText
end

--------------------------------------------------

function RequestPopup.GetNickname()
	return NicknameBar.TextBox.Text
end

function RequestPopup.SetFilepath(Target : RemoteEvent | RemoteFunction)
	PathBar.Content.Text = FilepathModule.GetFilePath(Target)
end

--------------------------------------------------



--------------------------------------------------



--------------------------------------------------

ContentContainer:WaitForChild("ConfirmBar"):WaitForChild("Confirm").MouseButton1Click:Connect(function()
	-- Create a new request with the target remote and nickname
	local SelectedRemote = script.Parent:WaitForChild("RemoteSelector"):WaitForChild("SelectedOption").Value
	if not SelectedRemote then warn("No remote selected.") return end
	
	local Nickname = RequestPopup.GetNickname()
	if Nickname == "" then Nickname = nil end
	
	local NewRequestUID = RequestModule.CreateEmptyRequest()
	RequestModule.AssignRemote(NewRequestUID, SelectedRemote)
	RequestModule.AssignNickname(NewRequestUID, Nickname)
	
	script:WaitForChild("Signals"):WaitForChild("OnRequestCreated"):Fire(NewRequestUID)
	RequestPopup.Disappear()
end)

RC_Frame:WaitForChild("CreateButton").InputBegan:Connect(function(IO)
	if IO.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
	
	RequestPopup.Appear()
	
	local SelectedRemote = script.Parent:WaitForChild("RemoteSelector"):WaitForChild("SelectedOption").Value
	if not SelectedRemote then warn("No remote selected.") RequestPopup.Disappear() return end
	
	RequestPopup.SetFilepath(SelectedRemote)
	
end)

RequestPopupFrame:WaitForChild("TopBar"):WaitForChild("ExitButton").MouseButton1Click:Connect(function()
	RequestPopup.Disappear()
end)

--------------------------------------------------


return RequestPopup
