--// Cleanser
--// Written by Demo (R0BL0XIAN_D3M0)
--// [https://www.roblox.com/users/289025524/profile]
--// 10/30/2022

--// Types
type table = {[any]: any}
type Function = (... any?) -> (... any?)

type Task = any | Function | thread | RBXScriptConnection | Instance
type TableTask = Task | table

type CleanserData = {

	Cleanser: table;
	Tasks: TableTask

}

--[=[
	@class Cleanser

	A class providing the cleanest and most efficient way of managing "dead" `Instances`,
		`RBXScriptConnections`, regular `Functions`, `Signals`, `Tables` consisting of objects,
			and `Threads`.

	:::info Warning
	If you are seeking a more customizable handler for `RBXScriptConnections`,
		then seek Trove, found here:
			https://sleitnick.github.io/RbxUtil/api/Trove
]=]
local Cleanser: table = {}
Cleanser.ClassName = "Cleanser" :: string
Cleanser.__index = Cleanser

--// Functions

--[=[
	@within Cleanser

	@function Is

	@param Task TableTask -- The specified item to check.

	@return boolean -- Return whether or not the item's a valid Cleanser.

	Returns whether or not the specified class is a valid Cleanser.

	```lua
		print(Cleanser.Is(Cleanser.new())) --> true
		print(Cleanser.Is(nil)) --> false
	```
]=]
local function Is(Task: TableTask): boolean
	return (((type(Task)) == ("table")) and ((Task.ClassName) == (Cleanser.ClassName))) :: boolean
end

--[=[
	@within Cleanser

	@param Tasks TableTask -- The cleanse tasks.

	@return table -- Return the cleanser class's metatable.

	Index a new cleanser.

	```lua
		local Object: Instance | Part = Instance.new("Part")
		Object.Name = "Part"
		Object.Position = Vector2.new(0, 5, 0)
		Object.Size = Vector2.new(5, 1, 5)
		Object.Parent = game:GetService("Workspace")

		local ObjectCleanser: table = Cleanser.New(Object)
	```
]=]
function Cleanser.New(Tasks: TableTask): table
	local self: CleanserData = setmetatable({

		["Cleanser"] = Cleanser;

		["Tasks"] = {

			Tasks

		}

	}, Cleanser)

	return (self)
end

--[=[
	@within Cleanser

	@method Grant

	@param Tasks TableTask -- The cleanse tasks.

	@return table -- Return the cleanser class's metatable.

	Grant (add) a new cleanser task.

	```lua
		local Object: Instance | Part = Instance.new("Part")
		Object.Name = "Part"
		Object.Position = Vector2.new(0, 5, 0)
		Object.Size = Vector2.new(5, 1, 5)
		Object.Parent = game:GetService("Workspace")

		local ObjectCleanser: table = Cleanser.New()
		ObjectCleanser:Grant(Object)
	```
]=]
function Cleanser:Grant(Tasks: TableTask): table
	if ((type(Tasks)) == ("table")) then
		for _: number, Task: Task in ipairs(Tasks) do
			self["Tasks"][(#self["Tasks"] + 1)] = Task
		end
	else
		self["Tasks"][(#self["Tasks"] + 1)] = Tasks
	end

	return (self)
end

--[=[
	@within Cleanser

	@method Cleanse

	Cleanse the specified cleanser objects.

	```lua
		ObjectCleanser:Cleanse()
	```
]=]
function Cleanser:Cleanse(): any?
	local Tasks: TableTask = self["Tasks"]

	task.defer(function(): any?
		for TaskId: number, Task: Task in ipairs(Tasks) do
			if ((typeof(Task)) == ("RBXScriptConnection")) then
				Tasks[TaskId] = nil

				Task:Disconnect()
			end
		end
	end)

	for TaskId: number, Task: Task in ipairs(Tasks) do
		Tasks[TaskId] = nil

		if ((type(Task)) == ("function")) then
			Task()
		elseif ((type(Task)) == ("thread")) then
			task.cancel(Task)
		elseif ((typeof(Task)) == ("RBXScriptConnection")) then
			Task:Disconnect()
		elseif (Task.Destroy) then
			Task:Destroy()
		end
	end
end

--[=[
	@within Cleanser

	@method DelayedDestroy

	@param Time number -- The amount of seconds to wait before cleansing the cleanser's objects.

	@return boolean -- Return whether or not the object has been destroyed.

	Destroy and cleanup a cleanser after a certain period of time.

	```lua
		ObjectCleanser:DelayedDestroy(Time :: number)
	```
]=]
function Cleanser:DelayedDestroy(Time: number): boolean
	task.defer(function(): any?
		task.delay(Time, function(): any?
			self:Destroy()

			return (true) :: boolean
		end)
	end)

	return (false) :: boolean
end

--[=[
	@within Cleanser

	@method Destroy

	Destroy and cleanup a cleanser.

	```lua
		ObjectCleanser:Destroy()
	```
]=]
function Cleanser:Destroy(): any?
	self:Cleanse()

	if (self["Objects"]) then
		table.clear(self["Objects"])
	end

	table.clear(self)
	setmetatable(self, nil)
end

--// Pascal patches
Cleanser.new = Cleanser.New

Cleanser.is = Is
Cleanser.Is = Is

Cleanser.add = Cleanser.Grant
Cleanser.Add = Cleanser.Grant
Cleanser.grant = Cleanser.Grant

Cleanser.cleanse = Cleanser.Cleanse

Cleanser.delayedDestroy = Cleanser.DelayedDestroy
Cleanser.timedDestroy = Cleanser.DelayedDestroy
Cleanser.TimedDestroy = Cleanser.DelayedDestroy
Cleanser.destroy = Cleanser.Destroy

--// Finalizations
export type Cleanser = (typeof(Cleanser.New()))

table.freeze(Cleanser)

return (Cleanser)