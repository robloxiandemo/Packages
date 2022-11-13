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

local Signal: table = {}
Signal.__index = Signal

--[=[
	@interface SignalMethods

	@within Signal
	.Connect table -- Connect to the signal while waiting for a fire to load the
		specified callback function.
	.ConnectOnce table -- Unlike the normal connect method, this will run once.
	.ConnectParallel table -- Unlike the normal connect method, this will run in parallel,
		resulting in zero code interference.
	.Wait Wait -- Wait for the connection to be fired and then return any retrieved values.
	.Fire table -- Fire the current signal's connections.
	.FireUntil table -- Fire the current signal's connections until the specified callback is reached.
	.OnInvoke table -- Create a callback function that'd be activated on invoke,
		retrieving the function's callback.
	.Invoke table -- Wait until the \"OnInvoke\" method exists and then invoke with the
		necessary arguments.
	.Destroy table -- Destroy and cleanup a Signal.

	All of the subsidiary code within Signal.
]=]
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
]=]
local function Is(Object: table?): boolean
	return ((type(Object)) == ("table")) and ((getmetatable(Object)) == (Signal)) :: boolean
end

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

function SignalMethods:ConnectParallel(Callback: Function): Connection
	return (self:Connect(function(...)
		task.desynchronize()

		return (Callback(...))
	end)) :: Connection
end

function SignalMethods:Wait(): Wait?
	local Result: any?
	local WaitSignal: any?

	WaitSignal = self:Connect(function(...)
		Result = (...)
		WaitSignal:Disconnect()
	end) :: Connection

	repeat
		task.wait()
	until (Result)

	return ((Result) :: Wait?)
end

function SignalMethods:Fire(...: any?): any?
	local Item: table = Signal["Connections"][self["Name"]]

	for _: number, Value: any in next, Item do
		if ((type(Value)) ~= ("function")) then
			continue
		end

		Value(...)
	end
end

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

function SignalMethods:OnInvoke(Callback: Function): any?
	Signal["Connections"][self["Name"]]["OnInvoke"] = Callback :: Function
end

function SignalMethods:Invoke(...: any?): Function
	local Item: table = Signal["Connections"][self["Name"]]

	repeat
		task.wait()
	until (type(Item["OnInvoke"]) == ("function"))

	return (Item["OnInvoke"](...)) :: Function
end

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