--// Player
--// Written by Demo (R0BL0XIAN_D3M0)
--// [https://www.roblox.com/users/289025524/profile]
--// 10/26/2022

--// Types
type table = {[any]: any}
type Function = (... any?) -> (... any?)

type PlayerData = {

	Character: Model?;
	Humanoid: Humanoid?;
	Cleanser: table;
	Name: string?;
	Player: Player?;
	UserId: number?

}

--[=[
	@class Player

	A class that wraps the Player object to give more development power.
]=]
local Player: table = {}
Player.__index = Player

--// Services
local RunService: RunService = game:GetService("RunService")
local StarterPlayer: StarterPlayer = game:GetService("StarterPlayer")

--// Modules
local Cleanser: table = require(script.Parent.Parent.Parent["Cleanser"])

--// Variables
local DefaultKickMessage: string = "You have been kicked from the server!"

local DefaultJumpPowerValue: boolean = StarterPlayer.CharacterUseJumpPower

local DefaultJumpHeight: number = ((not (DefaultJumpPowerValue)) and (StarterPlayer.CharacterJumpHeight))
local DefaultJumpPower: number = ((DefaultJumpPowerValue) and (StarterPlayer.CharacterJumpPower))

local DefaultMaxSlopAngle: number = StarterPlayer.CharacterMaxSlopeAngle
local DefaultWalkSpeed: number = StarterPlayer.CharacterWalkSpeed

local IsClient: boolean = RunService:IsClient()

--// Functions

--[=[
	@within Player

	@param LocalPlayer Player -- The player object.

	@return table -- Return the player class's metatable.

	Index a new player.

	```lua
		local PlayerMethods: table = PlayerClass.New(LocalPlayer)
	```
]=]
function Player.New(LocalPlayer: Player): table
	local self: PlayerData = setmetatable({

		["Character"] = nil;
		["Humanoid"] = nil;
		["Cleanser"] = Cleanser.New();
		["Name"] = LocalPlayer.Name;
		["Player"] = LocalPlayer;
		["UserId"] = LocalPlayer.UserId

	}, Player)

	self["Character"] = self:RetrieveCharacter()
	self["Humanoid"] = self:RetrieveHumanoid()

	self["Cleanser"]:Add(self)

	return (self)
end

--[=[
	@within Player

	@return Model -- Return the player's character model.

	Return the player's character.

	```lua
		local Character: Model = PlayerMethods:RetrieveCharacter()
	```
]=]
function Player:RetrieveCharacter(): Model
	return ((self["Character"]) or (self["Player"].Character)
		or (self["Player"].CharacterAdded:Wait())) :: Model
end

--[=[
	@within Player

	@return Humanoid -- Return the player's humanoid.

	Return the player's character's humanoid.

	```lua
		local Humanoid: Humanoid = PlayerMethods:RetrieveHumanoid()
	```
]=]
function Player:RetrieveHumanoid(): Humanoid
	return ((self["Humanoid"]) or ((self:RetrieveCharacter():FindFirstChildOfClass("Humanoid"))
		or (self["Character"]:FindFirstChildOfClass("Humanoid")))) :: Humanoid
end

--[=[
	@within Player

	@param Callback Function? -- The specified callback function.

	@return Model | boolean? -- Return the player's character model or false.

	Wait for and return the player's character (cancel if five attempts fail).

	```lua
		PlayerMethods:WaitForCharacter(function(...: Humanoid | boolean?): any?
			print(...) --> Model | Model.Name

			print(PlayerMethods:RetrieveCharacter().Name) --> Model.Name
		end)
	```
]=]
function Player:WaitForCharacter(Callback: Function?): Model | boolean?
	return (Cleanser.New():Grant(
		function(): any?
			local Character: Model?
			local Count: number = 0

			repeat
				Character = self:RetrieveCharacter()

				task.wait(1)

				Count += 1
			until ((Character) ~= (nil))

			if ((Character)) then
				return (Callback(Character)) :: Model
			end

			if ((Count) > (5)) then
				return (false) :: boolean
			end
		end
	):Destroy())
end

--[=[
	@within Player

	@param Callback Function? -- The specified callback function.

	@return Humanoid | boolean? -- Return the player's humanoid or false.

	Wait for and return the player's characters' humanoid (cancel if five attempts fail).

	```lua
		PlayerMethods:WaitForHumanoid(function(...: Humanoid | boolean?): any?
			print(...) --> Humanoid | Humanoid.Name

			PlayerMethods:SetWalkSpeed(1e+1) --> 10
			print(PlayerMethods:RetrieveHumanoid().WalkSpeed) --> 10

			PlayerMethods:SetWalkSpeed(1e+2) --> 100
			print(PlayerMethods:RetrieveHumanoid().WalkSpeed) --> 100
		end)
	```
]=]
function Player:WaitForHumanoid(Callback: Function?): Humanoid | boolean?
	return (Cleanser.New():Grant(
		function(): any?
			local Humanoid: Humanoid?
			local Count: number = 0

			repeat
				Humanoid = self:RetrieveHumanoid()

				task.wait(1)

				Count += 1
			until ((Humanoid) ~= (nil))

			if ((Humanoid)) then
				return (Callback(Humanoid)) :: Humanoid
			end

			if ((Count) > (5)) then
				return (false) :: boolean
			end
		end
	):Destroy())
end

--[=[
	@within Player

	@return string -- Return the player's name.

	Return the player's name.

	```lua
		print(PlayerMethods:RetrieveName()) --> Player.Name
	```
]=]
function Player:RetrieveName(): string
	return (self["Name"]) :: string
end

--[=[
	@within Player

	@return Player -- Return the player's player object.

	Return the player's player object.

	```lua
		print(PlayerMethods:RetrievePlayer()) --> Player | Player.Name
	```
]=]
function Player:RetrievePlayer(): Player
	return (self["Player"]) :: Player
end

--[=[
	@within Player

	@return number -- Return the player's UserId.

	Return the player's unique UserId.

	```lua
		print(PlayerMethods:RetrieveUserId()) --> Player.UserId
	```
]=]
function Player:RetrieveUserId(): number
	return (self["UserId"]) :: number
end

--[=[
	@within Player

	@param Callback Function -- The specified callback function.

	Run the specified callback function on the addition of the player's character.

	```lua
		local function Callback(): any?
			print("The character has been added!")
		end

		PlayerMethods:CharacterAdded(Callback)
	```
]=]
function Player:CharacterAdded(Callback: Function): any?
	Cleanser.New():Grant(
		task.defer(function(): any?
			Callback(self:RetrieveCharacter())
		end)
	):Destroy()
end

--[=[
	@within Player

	@param Callback Function -- The specified callback function.

	Run the specified callback function on the addition of the player's humanoid.

	```lua
		local function Callback(): any?
			print("The humanoid has been added!")
		end

		PlayerMethods:HumanoidAdded(Callback)
	```
]=]
function Player:HumanoidAdded(Callback: Function): any?
	Cleanser.New():Grant(
		task.defer(function(): any?
			Callback(self:RetrieveHumanoid())
		end)
	):Destroy()
end

--[=[
	@within Player

	@param JumpPower number? -- The specified jump-power to use in a numerical value.

	Set the player's jump-power.

	```lua
		PlayerMethods:SetJumpPower(JumpPower :: number) --> number
	```
]=]
function Player:SetJumpPower(JumpPower: number?): any?
	self:WaitForHumanoid(function(Humanoid: Humanoid): any?
		Humanoid.JumpPower = ((JumpPower) or (DefaultJumpPower))

		self["Humanoid"] = Humanoid
	end)
end

--[=[
	@within Player

	@param Value boolean? -- The status of whether or not to use the player's jump-power.

	Set whether or not to use the player's jump-power for jump-related adjustments.

	```lua
		PlayerMethods:UseJumpPower(Value :: boolean) --> boolean
	```
]=]
function Player:UseJumpPower(Value: boolean?): any?
	self:WaitForHumanoid(function(Humanoid: Humanoid): any?
		Humanoid.UseJumpPower = ((Value) or (DefaultJumpPowerValue))

		self["Humanoid"] = Humanoid
	end)
end

--[=[
	@within Player

	@param Height number? -- The specified jump-height to use in a numerical value.

	Set the player's jump-height.

	```lua
		PlayerMethods:SetJumpHeight(Height :: number) --> number
	```
]=]
function Player:SetJumpHeight(Height: number?): any?
	self:WaitForHumanoid(function(Humanoid: Humanoid): any?
		Humanoid.JumpHeight = ((Height) or (DefaultJumpHeight))

		self["Humanoid"] = Humanoid
	end)
end

--[=[
	@within Player

	@param Angle number? -- The specified angle to use in a numerical value.

	Set the player's maximum slope angle.

	```lua
		PlayerMethods:SetMaxSlopeAngle(Angle :: number) --> number
	```
]=]
function Player:SetMaxSlopeAngle(Angle: number?): any?
	self:WaitForHumanoid(function(Humanoid: Humanoid): any?
		Humanoid.SetMaxSlopeAngle = ((Angle) or (DefaultMaxSlopAngle))

		self["Humanoid"] = Humanoid
	end)
end

--[=[
	@within Player

	@param WalkSpeed number? -- The specified walking speed to use in a numerical value.

	Set the player's walking speed.

	```lua
		PlayerMethods:SetWalkSpeed(WalkSpeed :: number) --> number
	```
]=]
function Player:SetWalkSpeed(WalkSpeed: number?): any?
	self:WaitForHumanoid(function(Humanoid: Humanoid): any?
		Humanoid.WalkSpeed = ((WalkSpeed) or (DefaultWalkSpeed))

		self["Humanoid"] = Humanoid
	end)
end

--[=[
	@within Player

	@server

	@param Reason string? -- The specified walking speed to use in a numerical value.

	@return boolean -- Was the player successfuly kicked?

	Kick the player.

	```lua
		--// Server
		PlayerMethods:Kick("nerd") --> boolean
	```
]=]
function Player:Kick(Reason: string?): boolean
	if ((self["Player"]) and (not (IsClient))) then
		self["Player"]:Kick((tostring(Reason)) or (DefaultKickMessage))

		return (true) :: boolean
	else
		return (false) :: boolean
	end
end

--[=[
	@within Player

	Destroy and cleanup the player class.

	```lua
		PlayerMethods:Destroy()
	```
]=]
function Player:Destroy(): any?
	self["Cleanser"]:Destroy()
	self["Cleanser"] = nil

	table.clear(self)
	setmetatable(self, nil)
end

--// Pascal patches
Player.new = Player.New

Player.getCharacter = Player.RetrieveCharacter
Player.retrieveCharacter = Player.RetrieveCharacter

Player.getHumanoid = Player.RetrieveHumanoid
Player.retrieveHumanoid = Player.RetrieveHumanoid

Player.waitForCharacter = Player.WaitForCharacter
Player.waitForHumanoid = Player.WaitForHumanoid

Player.getName = Player.RetrieveName
Player.retrieveName = Player.RetrieveName

Player.getPlayer = Player.RetrievePlayer
Player.retrievePlayer = Player.RetrievePlayer

Player.getUserId = Player.RetrieveUserId
Player.getUserID = Player.RetrieveUserId
Player.retrieveUserId = Player.RetrieveUserId
Player.retrieveUserID = Player.RetrieveUserId

Player.characterAdded = Player.CharacterAdded
Player.humanoidAdded = Player.HumanoidAdded

Player.useJumpPower = Player.UseJumpPower
Player.setJumpPower = Player.SetJumpPower

Player.setJumpHeight = Player.SetJumpHeight

Player.setMaxSlopeAngle = Player.SetMaxSlopeAngle

Player.setWalkSpeed = Player.SetWalkSpeed

Player.kick = Player.Kick

Player.destroy = Player.Destroy

return (Player)