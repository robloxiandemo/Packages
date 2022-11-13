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

	@method RetrieveCharacter

	@return Model -- Return the player's character model.

	Return the player's character.
]=]
function Player:RetrieveCharacter(): Model
	return ((self["Character"]) or (self["Player"].CharacterAdded:Wait())) :: Model
end

--[=[
	@within Player

	@method RetrieveHumanoid

	@return Humanoid -- Return the player's humanoid.

	Return the player's character's humanoid.
]=]
function Player:RetrieveHumanoid(): Humanoid
	return ((self["Humanoid"]) or ((self:RetrieveCharacter():FindFirstChildOfClass("Humanoid"))
		or (self["Character"]:FindFirstChildOfClass("Humanoid")))) :: Humanoid
end

--[=[
	@within Player

	@method RetrieveName

	@return string -- Return the player's name.

	Return the player's name.
]=]
function Player:RetrieveName(): string
	return (self["Name"]) :: string
end

--[=[
	@within Player

	@method RetrievePlayer

	@return Player -- Return the player's player object.

	Return the player's player object.
]=]
function Player:RetrievePlayer(): Player
	return (self["Player"]) :: Player
end

--[=[
	@within Player

	@method RetrieveUserId

	@return number -- Return the player's UserId.

	Return the player's unique UserId.
]=]
function Player:RetrieveUserId(): number
	return (self["UserId"]) :: number
end

--[=[
	@within Player

	@method CharacterAdded

	@param Callback Function -- The specified callback function.

	Run the specified callback function on the addition of the player's character.
]=]
function Player:CharacterAdded(Callback: Function): any?
	Cleanser.New(task.defer(Callback)(self:RetrieveCharacter())):Destroy()
end

--[=[
	@within Player

	@method HumanoidAdded

	@param Callback Function -- The specified callback function.

	Run the specified callback function on the addition of the player's humanoid.
]=]
function Player:HumanoidAdded(Callback: Function): any?
	Cleanser.New(task.defer(Callback)(self:RetrieveHumanoid())):Destroy()
end

--[=[
	@within Player

	@method SetJumpPower

	@param JumpPower number? -- The specified jump-power to use in a numerical value.

	Set the player's jump-power.
]=]
function Player:SetJumpPower(JumpPower: number?): any?
	self:HumanoidAdded(function(Humanoid)
		Humanoid.JumpPower = ((JumpPower) or (DefaultJumpPower))
	end)
end

--[=[
	@within Player

	@method UseJumpPower

	@param Value boolean? -- The status of whether or not to use the player's jump-power.

	Set whether or not to use the player's jump-power for jump-related adjustments.
]=]
function Player:UseJumpPower(Value: boolean?): any?
	self:HumanoidAdded(function(Humanoid)
		Humanoid.UseJumpPower = ((Value) or (DefaultJumpPowerValue))
	end)
end

--[=[
	@within Player

	@method SetJumpHeight

	@param Height number? -- The specified jump-height to use in a numerical value.

	Set the player's jump-height.
]=]
function Player:SetJumpHeight(Height: number?): any?
	self:HumanoidAdded(function(Humanoid)
		Humanoid.JumpHeight = ((Height) or (DefaultJumpHeight))
	end)
end

--[=[
	@within Player

	@method SetMaxSlopeAngle

	@param Angle number? -- The specified angle to use in a numerical value.

	Set the player's maximum slope angle.
]=]
function Player:SetMaxSlopeAngle(Angle: number?): any?
	self:HumanoidAdded(function(Humanoid)
		Humanoid.SetMaxSlopeAngle = ((Angle) or (DefaultMaxSlopAngle))
	end)
end

--[=[
	@within Player

	@method SetWalkSpeed

	@param WalkSpeed number? -- The specified walking speed to use in a numerical value.

	Set the player's walking speed.
]=]
function Player:SetWalkSpeed(WalkSpeed: number?): any?
	self:HumanoidAdded(function(Humanoid)
		Humanoid.WalkSpeed = ((WalkSpeed) or (DefaultWalkSpeed))
	end)
end

--[=[
	@within Player

	@server

	@method Kick

	@param Reason string? -- The specified walking speed to use in a numerical value.

	@return boolean -- Was the player successfuly kicked?

	Kick the player.
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

	@method Destroy

	Destroy and cleanup the player class.
]=]
function Player:Destroy(): any?
	self["Cleanser"]:Destroy()
	self["Cleanser"] = nil

	table.clear(self)
	setmetatable(self, nil)
end

--// Pascal patches
Player.getCharacter = Player.RetrieveCharacter
Player.retrieveCharacter = Player.RetrieveCharacter

Player.getHumanoid = Player.RetrieveHumanoid
Player.retrieveHumanoid = Player.RetrieveHumanoid

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

Player.new = Player.New
Player.destroy = Player.Destroy

return (Player)