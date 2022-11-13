--// Signal
--// Written by Demo (R0BL0XIAN_D3M0)
--// [https://www.roblox.com/users/289025524/profile]
--// 10/28/2022

--// Types
type table = {[any]: any}
type Function = (... any?) -> (... any?)

type SignalData = {

	Name: string

}

type Connection = {

	disconnect: Function;
	Disconnect: Function

}

type Wait = () -> (... any)

--[=[
	@class Signal

	A class providing the cleanest and most efficient way of managing events via code.
]=]
local Signal: table = {}
Signal.__index = Signal

local SignalMethods: table = {}
SignalMethods.__index = SignalMethods

Signal["Connections"] = {}

--// Modules
local Cleanser: table = require(script.Parent.Parent.Parent["Cleanser"])

--// Functions

--[=[
	@param Name string -- The name to use for the newly created Signal.

	@param Listener string -- The listener to use for the newly created Signal.

	@return table -- Return the signal class's metatable.

	Index a new Signal.

	```lua
		local Table: table = {

			[1] = 1;
			[2] = 3;
			[3] = 5;

		}

		local TableSignal: table = Signal.New("TableSignal")
	```
]=]
function Signal.New(Name: string, Listener: Function?): table
	local Connections: table = Signal["Connections"]

	if ((Listener) and (not (typeof(Listener) == ("function")))) then
		error(("The specified listener \"") .. (tostring(Listener)) .. ("\" isn't a function!"))
	end

	local self: SignalData = setmetatable({

		["Name"] = Name

	}, SignalMethods)

	Connections[Name] = ((Connections[Name]) or {

		["Cleanser"] = Cleanser.New();
		["IsConnected"] = false;
		["Listener"] = (Listener or nil);
		["Listening"] = 0;
		["OnInvoke"] = nil

	})

	Connections[Name]["Cleanser"]:Add(Connections[Name])

	return (self)
end

--[=[
	@within Signal

	@param Object table -- The specified object.

	@return boolean -- Return whether or not the specified object is a Signal.

	Return whether or not the specified object is a Signal.

	```lua
		task.defer(function(): any?
			print(TableSignal.Is(TableSignal)) --> true
			print(TableSignal.Is("string")) --> false
			print(TableSignal.Is(0)) --> false
		end)
	```
]=]
local function Is(Object: table?): boolean
	return ((type(Object)) == ("table")) and ((getmetatable(Object)) == (Signal)) :: boolean
end

--[=[
	@within Signal

	@param Callback Function -- The specified callback function.

	@return Connection -- Return a table consisting of disconnect-related functions.

	Connect to the signal while waiting for a fire to load the specified callback function.

	```lua
		local function Callback(String: string, ...: any?): any?
			if (((type(string)) == ("string")) and ((String) == ("NewEntry"))) then
				table.insert(Table, ...)

				print(Table)
			end
		end

		TableSignal:Connect(Callback)
	```
]=]
function SignalMethods:Connect(Callback: Function): Connection
	local Item: table = Signal["Connections"][self["Name"]]
	local Head: any = (("C") .. (Item["Listening"]))

	Item["Listening"] += 1
	Item[Head] = Callback

	Item["IsConnected"] = true

	local function Disconnect(): any?
		Item["IsConnected"] = false
		Item[Head] = nil
	end

	return ({

		["disconnect"] = Disconnect;
		["Disconnect"] = Disconnect

	}) :: Connection
end

--[=[
	@within Signal

	@param Callback Function -- The specified callback function.

	@return Connection -- Return a table consisting of disconnect-related functions.

	Unlike the normal connect method, this will run once.

	```lua
		local function Callback(String: string, ...: any?): any?
			if (((type(string)) == ("string")) and ((String) == ("NewEntry"))) then
				table.insert(Table, ...)

				print(Table)
			end
		end

		TableSignal:ConnectOnce(Callback)
	```
]=]
function SignalMethods:ConnectOnce(Callback: Function): Connection
	local Connection: Function?

	Connection = self:Connect(function(...)
		if (not (Connection)) then
			return
		end

		Connection:Disconnect()
		Connection = nil

		Callback(...)
	end) :: Connection
end

--[=[
	@within Signal

	@param Callback Function -- The specified callback function.

	@return Connection -- Return a table consisting of disconnect-related functions.

	Unlike the normal connect method, this will run when specified callback when the server's closing.

	```lua
		local function Callback(String: string, ...: any?): any?
			if (((type(string)) == ("string")) and ((String) == ("NewEntry"))) then
				table.insert(Table, ...)

				print(Table)
			end
		end

		TableSignal:ConnectToOnClose(Callback)
	```
]=]
function SignalMethods:ConnectToOnClose(Callback: Function): Connection
	local Connection: Function?

	Connection = self:Connect(function(...)
		if (not (Connection)) then
			return
		end

		Connection:Disconnect()
		Connection = nil

		game:BindToClose(Callback)(...)
	end) :: Connection
end

--[=[
	@within Signal

	@param Callback Function -- The specified callback function.

	@return Connection -- Return a table consisting of disconnect-related functions.

	Unlike the normal connect method, this will run in parallel, resulting in zero code interference.

	```lua
		local function Callback(String: string, ...: any?): any?
			if (((type(string)) == ("string")) and ((String) == ("NewEntry"))) then
				table.insert(Table, ...)

				print(Table)
			end
		end

		TableSignal:ConnectParallel(Callback)
	```
]=]
function SignalMethods:ConnectParallel(Callback: Function): Connection
	return (self:Connect(function(...)
		task.desynchronize()

		return (Callback(...))
	end)) :: Connection
end

--[=[
	@within Signal

	@return Wait -- Return a table consisting of any retrieved values.

	Wait for the connection to be fired and then return any retrieved values.

	```lua
		task.defer(function(): any?
			local Arguments: any = {TableSignal:Wait()}

			print(table.unpack(Arguments))
		end)
	```
]=]
function SignalMethods:Wait(): Wait?
	local Result: Wait?
	local WaitSignal: any?

	WaitSignal = self:Connect(function(...)
		Result = (...)
		WaitSignal:Disconnect()
	end) :: Connection

	repeat
		task.wait()
	until (Result) :: Wait?

	return ((Result) :: Wait?)
end

--[=[
	@within Signal

	@param ... any? -- The specified arguments to fire with.

	Fire the current signal's connections.

	```lua
		TableSignal:Fire("NewEntry", 1)
	```
]=]
function SignalMethods:Fire(...: any?): any?
	local Item: table = Signal["Connections"][self["Name"]]

	for _: number, Value: any in next, Item do
		if ((type(Value)) ~= ("function")) then
			continue
		end

		Value(...)
	end
end

--[=[
	@within Signal

	@param Callback Function -- The specified callback.

	@param ... any? -- The specified arguments to fire with.

	Fire the current signal's connections until the specified callback is reached.

	```lua
		--// Very poor usage, though this works.
		local function Callback(): any?
			repeat
				task.wait(1)
			until (table.find(Table, 7))
		end

		TableSignal:FireUntil(Callback, "NewEntry", 1)
	```
]=]
function SignalMethods:FireUntil(Callback: Function, ...: any?): any?
	local Item: table = Signal["Connections"][self["Name"]]

	while ((Item) ~= (nil)) do
		if ((Item["IsConnected"]) == (true)) then
			Item["Listener"](...)

			if ((Callback()) ~= (true)) then
				return
			end
		end

		Item = nil
	end
end

--[=[
	@within Signal

	@param Callback Function -- The specified callback function.

	Create a callback function that'd be activated on invoke, retrieving the function's callback.

	```lua
		local function Callback(String: string): number
			if (((type(string)) == ("string")) and ((String) == ("RetrieveTotalCount"))) then
				return (Table[table.getn(Table)]) :: table
			end
		end

		TableSignal:OnInvoke(Callback)
	```
]=]
function SignalMethods:OnInvoke(Callback: Function): any?
	Signal["Connections"][self["Name"]]["OnInvoke"] = Callback :: Function
end

--[=[
	@within Signal

	@param ... any? -- The specified arguments to invoke with.

	@return Function -- Return the function associated with \"OnInvoke\".

	Wait until the \"OnInvoke\" method exists and then invoke with the necessary arguments.

	```lua
		TableSignal:Invoke("RetrieveTotal")
	```
]=]
function SignalMethods:Invoke(...: any?): Function
	local Item: table = Signal["Connections"][self["Name"]]

	repeat
		task.wait()
	until (type(Item["OnInvoke"]) == ("function"))

	return (Item["OnInvoke"](...)) :: Function
end

--[=[
	@within Signal

	Destroy and cleanup a Signal.

	```lua
		TableSignal:Destroy()
	```
]=]
function SignalMethods:Destroy(): any?
	Signal["Connections"][self["Name"]] = nil

	self["Cleanser"]:Destroy()
	self["Cleanser"] = nil

	table.clear(self)
	setmetatable(self, nil)
end

--// Pascal patches
Signal.new = Signal.New

SignalMethods.is = Is
SignalMethods.Is = Is

SignalMethods.connect = SignalMethods.Connect
SignalMethods.connectOnce = SignalMethods.ConnectOnce
SignalMethods.connectToOnClose = SignalMethods.ConnectToOnClose
SignalMethods.connectParallel = SignalMethods.ConnectParallel

SignalMethods.wait = SignalMethods.Wait

SignalMethods.fire = SignalMethods.Fire
SignalMethods.fireUntil = SignalMethods.FireUntil

SignalMethods.onInvoke = SignalMethods.OnInvoke
SignalMethods.invoke = SignalMethods.Invoke

SignalMethods.destroy = SignalMethods.Destroy

return (Signal)