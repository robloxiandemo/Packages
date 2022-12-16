--// Promise
--// Created by Quenty (NevermoreEngine)[https://github.com/Quenty/NevermoreEngine]
--// Modified by Demo (R0BL0XIAN_D3M0) for compatibility and usage with the Facilitator Framework / Wally.
--// [https://www.roblox.com/users/289025524/profile]
--// 11/13/2022

--// Types
type table = {[any]: any}
type Function = (... any?) -> (... any?)

type PromiseData = {

	PendingExecuteList: table;
	UnconsumedException: boolean;
	Source: string

}

--// Services
local RunService: RunService = game:GetService("RunService")

--// Variables
local EnableTraceback: boolean = false
local EmptyRejectedPromise: table? = nil
local EmptyFulfilledPromise: table? = nil

--[=[
	@class Promise

	Promises, though without error handling as this screws with stack traces, using Roblox signals.

	This differs a tad bit from Quenty's Promise, as it provides an altered structure, though it's
		still relatively the same!

	Forked from Quenty's NevermoreEngine: https://quenty.github.io/NevermoreEngine/api/Promise

	View: https://promisesaplus.com/
]=]
local Promise = {}
Promise.ClassName = "Promise" :: string
Promise.__index = Promise

--[=[
	Determines whether a value is a promise or not.

	@param Value any?

	@return boolean
]=]
function Promise.IsPromise(Value: any?): boolean
	return ((type(Value)) == ("table")) and ((Value.ClassName) == (Promise.ClassName)) :: boolean
end

--[=[
	Constructs a new promise.

	:::warning
	Do not yield within this callback's callback,
		as it will yield on the main thread. This is a performance optimization.
	:::

	@param Callback (Resolve: (...) -> (), Reject: (...) -> ()) -> ()?

	@return Promise<T>
]=]
function Promise.New(Callback: Function): PromiseData
	local self: PromiseData = setmetatable({

		PendingExecuteList = {},
		UnconsumedException = true,
		Source = (((EnableTraceback) and (debug.traceback())) or (""))

	}, Promise)

	if ((type(Callback)) == ("function")) then
		Callback(self:GetResolveReject())
	end

	return (self)
end

--[=[
	Initializes a new promise with the given function in a spawned wrapper.

	@param Callback (Resolve: (...) -> (), Reject: (...) -> ()) -> ()?

	@return Promise<T>
]=]
function Promise.Spawn(Callback: Function): PromiseData
	local self: PromiseData = Promise.New()

	task.spawn(Callback, self:GetResolveReject())

	return (self)
end

--[=[
	Initializes a new promise with the given function in a deferred wrapper.

	@param Callback (Resolve: (...) -> (), Reject: (...) -> ()) -> ()?

	@return Promise<T>
]=]
function Promise.Defer(Callback: Function): PromiseData
	local self: PromiseData = Promise.New()

	task.defer(Callback, self:GetResolveReject())

	return (self)
end

--[=[
	Returns a resolved promise with the following values.

	@param ... any? -- Values to resolve to.

	@return Promise<T>
]=]
function Promise.Resolved(...: any?): PromiseData
	local SelectedValue: any? = select("#", ...)

	if ((SelectedValue) == (0)) then
		return (EmptyFulfilledPromise) :: table?
	elseif (((SelectedValue) == (1)) and (Promise.IsPromise(...))) then
		local CurrentPromise: PromiseData = (...)

		if (not (CurrentPromise["PendingExecuteList"])) then
			return (CurrentPromise) :: PromiseData
		end
	end

	local CurrentPromise: PromiseData = Promise.New()
	CurrentPromise:Resolve(...)

	return (CurrentPromise) :: PromiseData
end

--[=[
	Returns a rejected promise with the following values.

	@param ... any? -- Values to reject to.

	@return Promise<T>
]=]
function Promise.Rejected(...: any?): PromiseData
	local SelectedValue: any? = select("#", ...)

	if ((SelectedValue) == (0)) then
		return (EmptyRejectedPromise) :: table?
	end

	local CurrentPromise: PromiseData = Promise.New()

	CurrentPromise:Reject({

		...

	})

	return (CurrentPromise) :: PromiseData
end

--[=[
	Returns whether or not the promise is pending.

	@return bool -- True if pending, false otherwise.
]=]
function Promise:IsPending(): boolean
	return ((self["PendingExecuteList"]) ~= (nil)) :: boolean
end

--[=[
	Returns whether or not the promise is fulfilled.

	@return bool -- True if fulfilled
]=]
function Promise:IsFulfilled(): boolean
	return ((self["Fulfilled"]) ~= (nil)) :: boolean
end

--[=[
	Returns whether or not the promise is rejected.

	@return bool -- True if rejected.
]=]
function Promise:IsRejected(): boolean
	return ((self["Rejected"]) ~= (nil)) :: boolean
end

--[=[
	Yields until the promise is complete, and errors if an error
		exists, otherwise it will return the fulfilled results.

	@yields

	@return T
]=]
function Promise:Wait(): (string) -> (any?)
	if self["Fulfilled"] then
		return (unpack(self["Fulfilled"], 1, self["ValuesLength"])) :: any?
	elseif self["Rejected"] then
		return (error(tostring(self["Rejected"][1]), 2)) :: string
	else
		local BindableEvent: BindableEvent = Instance.new("BindableEvent")

		self:Then(function(): any?
			BindableEvent:Fire()
		end, function(): any?
			BindableEvent:Fire()
		end)

		BindableEvent.Event:Wait()
		BindableEvent:Destroy()

		if (self["Rejected"]) then
			return (error(tostring(self["Rejected"][1]), 2)) :: string
		else
			return (unpack(self["Fulfilled"], 1, self["ValuesLength"])) :: any?
		end
	end
end

--[=[
	Yields until the promise is complete, then returns a boolean indicating
		the result, followed by the values from the promise.

	@yields

	@return boolean, T
]=]
function Promise:Yield(): (boolean, any?)
	if (self["Fulfilled"]) then
		return (true) :: boolean, (unpack(self["Fulfilled"], 1, self["ValuesLength"])) :: any?
	elseif (self["Rejected"]) then
		return (false) :: boolean, (unpack(self["Rejected"], 1, self["ValuesLength"])) :: any?
	else
		local BindableEvent: BindableEvent = Instance.new("BindableEvent")

		self:Then(function(): any?
			BindableEvent:Fire()
		end, function(): any?
			BindableEvent:Fire()
		end)

		BindableEvent.Event:Wait()
		BindableEvent:Destroy()

		if (self["Fulfilled"]) then
			return (true) :: boolean, (unpack(self["Fulfilled"], 1, self["ValuesLength"])) :: any?
		elseif (self["Rejected"]) then
			return (false) :: boolean, (unpack(self["Rejected"], 1, self["ValuesLength"])) :: any?
		end
	end
end

--[=[
	Promise resolution procedure, resolves the given values.

	@param ... T
]=]
function Promise:Resolve(...: any?): any?
	if (not (self["PendingExecuteList"])) then
		return
	end

	local RandomValue: any? = select("#", ...)

	if ((RandomValue) == (0)) then
		self:Fulfill({})
	elseif ((self) == ((...))) then
		self:Reject("TypeError: Resolved to self.")
	elseif (Promise.IsPromise(...)) then
		if ((RandomValue) > (1)) then
			warn(
				string.format(
					"When resolving a promise, extra arguments are discarded! See:\n\n%s.",
				self["Source"]
				)
			)
		end

		local CurrentPromise: PromiseData = (...)

		if (CurrentPromise["PendingExecuteList"]) then
			CurrentPromise["UnconsumedException"] = false
			CurrentPromise["PendingExecuteList"][#CurrentPromise["PendingExecuteList"] + 1] = {

				function(...: any?): any?
					self:Resolve(...)
				end;

				function(...: any?): any?
					if (self["PendingExecuteList"]) then
						self:Reject({ ... }, select("#", ...))
					end
				end;

				nil

			}
		elseif (CurrentPromise["Rejected"]) then
			CurrentPromise["UnconsumedException"] = false
			self:Reject(CurrentPromise["Rejected"], CurrentPromise["ValuesLength"])
		elseif (CurrentPromise["Fulfilled"]) then
			self:Fulfill(CurrentPromise["Fulfilled"], CurrentPromise["ValuesLength"])
		else
			error("[Promise.Resolve] - Bad CurrentPromise state!")
		end
	elseif ((type(...)) == ("function")) then
		if (RandomValue > 1) then
			warn(
				string.format(
					"When resolving a function, extra arguments are discarded! See:\n\n%s.",
					self["source"]
				)
			)
		end

		local Callback: Function = {

			...

		}

		Callback(self:GetResolveReject())
	else
		self:Fulfill({

			...

		})
	end
end

--[=[
	Fulfills the promise with the value.

	@param ... T -- Parameters to fulfill with.

	@private
]=]
function Promise:Fulfill(...: any?): any?
	if (not (self["PendingExecuteList"])) then
		return
	end

	self["Fulfilled"] = ...
	self["ValuesLength"] = select("#", select("#", ...))

	local List: table = self["PendingExecuteList"]
	self["PendingExecuteList"] = nil

	for _: number, Data: any? in pairs(List) do
		self:ExecuteThen(unpack(Data))
	end
end

--[=[
	Rejects the promise with the values given.

	@param ... T -- Parameters to reject with.
]=]
function Promise:Reject(...: any?): PromiseData
	if (not (self["PendingExecuteList"])) then
		return
	end

	self["Rejected"] = {

		...

	}

	self["ValuesLength"] = select("#", select("#", ...))

	local List: table = self["PendingExecuteList"]
	self["PendingExecuteList"] = nil

	for _: number, Data: any? in pairs(List) do
		self:ExecuteThen(unpack(Data))
	end

	if ((self["UnconsumedException"]) and ((self["ValuesLength"]) > (0))) then
		task.spawn(function(): any?
			RunService.Heartbeat:Wait()

			if ((#(self["Rejected"][1])) < (1)) then
				return
			end

			if (self["UnconsumedException"]) then
				if (EnableTraceback) then
					warn(
						string.format(
							"[Promise] - Uncaught exception in promise\n\n%q\n\n%s.",
							tostring(self["Rejected"][1]),
							self["Source"]
						)
					)
				else
					warn(
						string.format(
							"[Promise] - Uncaught exception in promise: %q.",
							tostring(self["Rejected"][1])
						)
					)
				end
			end
		end)
	end
end

--[=[
	Handles if / when a promise is fulfilled / rejected. It takes up to two arguments,
		callback functions for the success and failure cases of the Promise.
			May return the same promise if certain behavior is met.

	:::info
	We do not comply with 2.2.4 (OnFulfilled or OnRejected must not be called,
		at least until the execution context stack contains only platform code).

	This means that promises may stack overflow, however, it also makes promises a lot cheaper.
	:::

	If / when promise is rejected,
		all respective OnRejected callbacks must execute in the order of their originating calls to then.

	If / when promise is fulfilled,
		all respective OnFulfilled callbacks must execute in the order of their originating calls to then.

	@param OnFulfilled Function -- Called if / when fulfilled with parameters.

	@param OnRejected Function -- Called if / when rejected with parameters.

	@return Promise<T>
]=]
function Promise:Then(OnFulfilled: Function, OnRejected: Function): PromiseData
	if ((type(OnRejected)) == ("function")) then
		self["UnconsumedException"] = false
	end

	if (self["PendingExecuteList"]) then
		local CurrentPromise: PromiseData = Promise.New()

		self["PendingExecuteList"][#self["PendingExecuteList"] + 1] = {

			OnFulfilled;
			OnRejected;
			CurrentPromise

		}

		return (CurrentPromise) :: PromiseData
	else
		return (self:ExecuteThen(OnFulfilled, OnRejected, nil)) :: PromiseData
	end
end

--[=[
	Akin to `Then`, though the value passed down the chain is the resolved value of the promise,
		not the value returned from OnFulfilled or OnRejected.

	Will still yield for the result if a promise is returned, but will discard the result.

	@param OnFulfilled Function

	@param OnRejected Function

	@return Promise<T> -- Returns self
]=]
function Promise:Tap(OnFulfilled: Function, OnRejected: Function): PromiseData
	local Result: PromiseData = self:Then(OnFulfilled, OnRejected)

	if ((Result) == (self)) then
		return (Result) :: PromiseData
	end

	if (Result["Fulfilled"]) then
		return (self) :: PromiseData
	elseif (Result["Rejected"]) then
		return (self) :: PromiseData
	elseif (Result["PendingExecuteList"]) then
		local function ReturnSelf(): PromiseData
			return (self) :: PromiseData
		end

		return (Result:Then(ReturnSelf, ReturnSelf)) :: PromiseData
	else
		error("Bad result state!")
	end
end

--[=[
	Executes upon pending stop.

	@param Callback Function

	@return Promise<T>
]=]
function Promise:Finally(Callback: Function): PromiseData
	return (self:Then(Callback, Callback)) :: PromiseData
end

--[=[
	Catch errors from the promise.

	@param OnRejected Function

	@return Promise<T>
]=]
function Promise:Catch(OnRejected: Function): PromiseData
	return (self:Then(nil, OnRejected)) :: PromiseData
end

--[=[
	Rejects the current promise. Utility left for Cleanser task.
]=]
function Promise:Destroy(): any?
	self:Reject({}, 0)
end

--[=[
	Returns the results from the promise.

	:::warning
	This API surface will error if the promise is still pending.
	:::

	@return boolean -- true if resolved, false otherwise.
]=]
function Promise:GetResults(): (boolean, any?)
	if (self["Rejected"]) then
		return (false) :: boolean, (unpack(self["Rejected"], 1, self["ValuesLength"])) :: any?
	elseif self["Fulfilled"] then
		return (true) :: boolean, (unpack(self["Fulfilled"], 1, self["ValuesLength"])) :: any?
	else
		error("Still pending!")
	end
end

function Promise:GetResolveReject(): (Function, Function)
	return (
		function(...: any?): any?
			self:Resolve(...)
		end
	),
	(
		function(...: any?): any?
			self:Reject({

				...

			}, select("#", ...))
		end
	)
end

--[=[
	@private

	@param OnFulfilled Function?

	@param OnRejected Function?

	@param CurrentPromise Promise<T>? -- Might be nil, and if so, then we have the option to return self.

	@return Promise
]=]
function Promise:ExecuteThen(OnFulfilled: Function?, OnRejected: Function?,
	CurrentPromise: PromiseData): PromiseData

	if (self["Fulfilled"]) then
		if ((type(OnFulfilled)) == ("function")) then
			if (CurrentPromise) then
				CurrentPromise:Resolve(OnFulfilled(unpack(self["Fulfilled"], 1, self["ValuesLength"])))

				return (CurrentPromise) :: PromiseData
			else
				local Results: table = table.pack(
					OnFulfilled(
						unpack(

							self["Fulfilled"],
							1,
							self["ValuesLength"]

						)
					)
				)

				if ((Results["n"]) == (0)) then
					return (EmptyFulfilledPromise) :: PromiseData
				elseif (((Results["n"]) == (1)) and (Promise.IsPromise(Results[1]))) then
					return (Results[1]) :: any?
				else
					local SecondaryPromise: PromiseData = Promise.New()
					SecondaryPromise:Resolve(table.unpack(Results, 1, Results["n"]))

					return (SecondaryPromise) :: PromiseData
				end
			end
		else
			if (CurrentPromise) then
				CurrentPromise:Fulfill(self["Fulfilled"])

				return (CurrentPromise) :: PromiseData
			else
				return (self) :: PromiseData
			end
		end
	elseif (self["Rejected"]) then
		if ((type(OnRejected)) == ("function")) then
			if (CurrentPromise) then
				CurrentPromise:Resolve(OnRejected(unpack(self["Rejected"], 1, self["ValuesLength"])))

				return (CurrentPromise) :: PromiseData
			else
				local Results: table = table.pack(
					OnRejected(
						unpack(

							self["Rejected"],
							1,
							self["ValuesLength"]

						)
					)
				)

				if ((Results["n"]) == (0)) then
					return (EmptyFulfilledPromise) :: PromiseData
				elseif (((Results["n"]) == (1)) and (Promise.IsPromise(Results[1]))) then
					return (Results[1]) :: any?
				else
					local SecondaryPromise: PromiseData = Promise.New()
					SecondaryPromise:Resolve(table.unpack(Results, 1, Results["n"]))

					return (SecondaryPromise) :: PromiseData
				end
			end
		else
			if (CurrentPromise) then
				CurrentPromise:Reject(self["Rejected"])

				return (CurrentPromise) :: PromiseData
			else
				return (self) :: PromiseData
			end
		end
	else
		error("Internal error: still pending!")
	end
end

--// Initialize Promise values.
EmptyFulfilledPromise = Promise.New()
EmptyFulfilledPromise:Fulfill({})

EmptyRejectedPromise = Promise.New()
EmptyRejectedPromise:Reject({})

--// Pascal patches
Promise.isPromise = Promise.IsPromise

Promise.new = Promise.New

Promise.spawn = Promise.Spawn

Promise.defer = Promise.Defer

Promise.resolved = Promise.Resolved
Promise.rejected = Promise.Rejected

Promise.isPending = Promise.IsPending
Promise.isFulfilled = Promise.IsFulfilled
Promise.isRejected = Promise.IsRejected

Promise.wait = Promise.Wait
Promise.yield = Promise.Yield

Promise.resolve = Promise.Resolve
Promise.reject = Promise.Reject

Promise["then"] = Promise.Then
Promise.andThen = Promise.Then
Promise.AndThen = Promise.Then

Promise.tap = Promise.Tap

Promise.finally = Promise.Finally

Promise.catch = Promise.Catch

Promise.getResults = Promise.GetResults
Promise.retrieveResults = Promise.GetResults
Promise.RetrieveResults = Promise.GetResults

Promise.destroy = Promise.Destroy

return (Promise)