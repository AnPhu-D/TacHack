# What is TacHack?
TacHack is a penetration testing tool that was built in May of 2023 to aid in testing ROBLOX games for remote event exploitability. It was very common for exploiters to maliciously and arbitrarily execute remote events to gain an unfair advantage in many ROBLOX experiences. TacHack can emulate the remote event execution behavior of the tools these exploiters use to explore vulnerable pathways in a developer's experience.

# How can I use TacHack?
Currently, the assets required to use TacHack are not fully available on GitHub. There are some GUI assets that are unable to be posted. The code, however, is available here. The GUI is not too complex, and you should find that implementing your own GUI (if you have experience in that) and matching up the functionalities should not be too difficult.

# Example of Vulnerable Code
```lua
local Events = game:GetService("ReplicatedStorage"):WaitForChild("CombatService")

local PlayerEquippedWeapons = {}
local WeaponDamages = {
	Sword = 15,
	Knife = 10,
	Spear = 20
}

--------------------------------------------------

Events:WaitForChild("DamagePlayer").OnServerEvent:Connect(function(FromPlayer : Player, TargetPlayer : Player)
	local CurrentWeapon = PlayerEquippedWeapons[FromPlayer.Name]
	if not CurrentWeapon then return end
	
	local EquippedWeaponDaamge = WeaponDamages[CurrentWeapon]
	if not EquippedWeaponDaamge then return end
	
	TargetPlayer.Character:FindFirstChildWhichIsA("Humanoid"):TakeDamage(EquippedWeaponDaamge)
end)

Events:WaitForChild("EquipWeapon").OnServerEvent:Connect(function(FromPlayer : Player, WeaponName : string)
	PlayerEquippedWeapons[FromPlayer.Name] = WeaponName
end)

Events:WaitForChild("UnequipWeapon").OnServerEvent:Connect(function(FromPlayer : Player)
	PlayerEquippedWeapons[FromPlayer.Name] = nil
end)

--------------------------------------------------

game:GetService("Players").PlayerAdded:Connect(function(Player : Player)
	PlayerEquippedWeapons[Player.Name] = nil
end)
```
# TacHack Client GUI
![image](https://github.com/AnPhu-D/TacHack/assets/103344940/ba772438-d132-4e09-b703-8df0722b1186)
![image](https://github.com/AnPhu-D/TacHack/assets/103344940/695a2295-af44-42a3-a074-c85bcbb51f7b)
