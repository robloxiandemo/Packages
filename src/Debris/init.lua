--// Debris
--// Created by RuizuKun_Dev (Debris2)[https://devforum.roblox.com/t/711522]
--// Modified by Demo (R0BL0XIAN_D3M0) for compatibility and usage with the Facilitator Framework / Wally.
--// [https://www.roblox.com/users/289025524/profile]
--// 12/01/2022

--// Types
type table = {[any]: any}

type Object = any | thread | RBXScriptConnection | Instance | table

--[=[
	@class Debris

	A collection of very useful debris-related functions (adjusted for the Facilitator framework).
]=]
local Debris: table = {}

--// Services
local RunService: RunService = game:GetService("RunService")

--// Variables
local CachedInstances: table = {}

local Connections: table = {}

local ValidMethods: table = {

	--// Active methods.
	["Active"] = {

		"Clean";
		"Clear";
		"CleanUp";
		"Destroy";
		"Disconnect";
		"Remove"

	};

	--// Inactive methods (could still be used).
	["Deprecated"] = {

		"clean";
		"clear";
		"cleanUp";
		"cleanup";
		"destroy";
		"disconnect";
		"remove"

	}

}

--// Functions

--[=[
	@within Debris

	@param Object Object -- The debris object.

	@param ObjectClass string -- The supposed object's class type.

	Destroy the specified debris object.
]=]
local function RemoveObject(Object: Object, ObjectClass: string): any?
	if ((ObjectClass) == ("Instance")) then
		pcall(Object["Destroy"], Object)
	elseif ((ObjectClass) == ("RBXScriptConnection")) then
		pcall(Object["Disconnect"], Object)
	else
		for _: number, MethodType: table in ipairs(ValidMethods) do
			for _: number, Method: string in ipairs(MethodType) do
				if (Object[Method]) then
					pcall(Object[Method], Method)

					break
				end
			end
		end
	end
end

--[=[
	@within Debris

	@param Object Object -- The debris object.

	@param LifeTime number -- The specified life time.

	@return table -- Return the debris object table.

	Add the specified debris object.
]=]
local function AddObject(Object: Object, LifeTime: number): table
	local ObjectClass: string = type(Object)

	if (not (CachedInstances[Object])) then
		table.insert(CachedInstances, Object)
	end

	CachedInstances[Object] = {
		["Cancel"] = function()
			Connections[Object]:Disconnect()

			table.remove(CachedInstances, table.find(CachedInstances, Object))

			CachedInstances[Object] = nil
		end;

		["CurrentTime"] = (os.clock()) + (LifeTime);
		["Destroyed"] = nil;
		["Instance"] = Object;
		["LifeTime"] = LifeTime

	}

	local CurrentDebris: table = CachedInstances[Object]

	Connections[Object] = RunService.Heartbeat:Connect(function(): any?
		if ((CurrentDebris) and (os.clock()) >= (CurrentDebris["CurrentTime"])) then
			if (CurrentDebris["Destroyed"]) then
				CurrentDebris["Destroyed"]()
			end

			CurrentDebris["Cancel"]()

			RemoveObject(Object, ObjectClass)
		end

		CurrentDebris = CachedInstances[Object]
	end)

	return (CachedInstances[Object]) :: table
end

--[=[
	@within Debris

	@param ObjectArray table -- The debris objects.

	@param LifeTime number -- The specified life time.

	Add the specified debris objects.
]=]
local function AddObjectArray(ObjectArray: table, LifeTime: number): any?
	for _: number, Object: Object in ipairs(ObjectArray) do
		AddObject(Object, LifeTime)
	end
end

--[=[
	@within Debris

	@param Object Object -- The debris object.

	@return table -- Return the debris instance's table.

	Retrieve the specified debris instance's table.
]=]
local function RetrieveDebris(Object: Object): table
	return (CachedInstances[Object]) :: table
end

--[=[
	@within Debris

	@return table -- Return the cached instances table.

	Retrieve all debris instances.
]=]
local function RetrieveAllDebris(): table
	return (CachedInstances) :: table
end

--// Pascal patches
Debris.addObject = AddObject
Debris.AddObject = AddObject

Debris.addObjectArray = AddObjectArray
Debris.AddObjectArray = AddObjectArray

Debris.getDebris = RetrieveDebris
Debris.GetDebris = RetrieveDebris
Debris.retrieveDebris = RetrieveDebris
Debris.RetrieveDebris = RetrieveDebris

Debris.getAllDebris = RetrieveAllDebris
Debris.GetAllDebris = RetrieveAllDebris
Debris.retrieveAllDebris = RetrieveAllDebris
Debris.RetrieveAllDebris = RetrieveAllDebris

return (Debris)