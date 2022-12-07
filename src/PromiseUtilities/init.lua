--// PromiseUtilities
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

--[=[
	Utility methods for promise

	@class PromiseUtilities
]=]
local PromiseUtilities = {}

--// Modules
local Promise: table = require(script.Parent.Parent.Parent["Promise"])

--[=[
	Returns the value of the first promise resolved.

	@param Promises { Promise<T> }

	@return Promise<T> -- Promise that resolves with first result
]=]
function PromiseUtilities.Any(Promises: table): PromiseData
	local ReturnPromise: PromiseData = Promise.New()

	local function Resolve(...: any?): any?
		ReturnPromise:Resolve(...)
	end

	local function Reject(...: any?): any?
		ReturnPromise:Reject(...)
	end

	for _: number, CurrentPromise: PromiseData in pairs(Promises) do
		CurrentPromise:Then(Resolve, Reject)
	end

	return (ReturnPromise) :: PromiseData
end

--[=[
	Executes all promises. If any fails, the result will be rejected. However,
		it yields until every promise is complete.

	:::warning
	Passing in a spare array (i.e. {nil, promise}) will result in undefined behavior here.
	:::

	@param Promises { Promise<T> }

	@return Promise<T>
]=]
function PromiseUtilities.All(Promises: table): PromiseData
	local PromisesCount: number = #Promises

	if ((PromisesCount) == (0)) then
		return (Promise.Resolved())
	elseif ((PromisesCount) == (1)) then
		return (Promises[1])
	end

	local RemainingCount: number = PromisesCount
	local ReturnPromise: PromiseData = Promise.New()
	local Results: table = {}
	local AllFulfilled: boolean = true

	local function Synchronize(Index: number, IsFullfilled: boolean): Function
		return (function(Value: any?)
			AllFulfilled = ((AllFulfilled) and (IsFullfilled))
			Results[Index] = Value
			RemainingCount -= 1

			if ((RemainingCount) == (0)) then
				local Method: string = (((AllFulfilled) and ("Resolve")) or ("Reject"))
				ReturnPromise[Method](ReturnPromise, unpack(Results, 1, PromisesCount))
			end
		end) :: Function
	end

	for Index: number, CurrentPromise: PromiseData in pairs(Promises) do
		CurrentPromise:Then(Synchronize(Index, true), Synchronize(Index, false))
	end

	return (ReturnPromise) :: PromiseData
end

--[=[
	Inverts the result of a promise,
		turning a resolved promise into a rejected one, and a rejected one into a resolved one.

	@param CurrentPromise Promise<T>

	@return Promise<T>
]=]
function PromiseUtilities.Invert(CurrentPromise: PromiseData): PromiseData
	if (CurrentPromise:IsPending()) then
		return (CurrentPromise:Then(
			function(...): PromiseData
				return (Promise.Rejected(...)) :: PromiseData
			end,

			function(...): PromiseData
				return (Promise.Resolved(...)) :: PromiseData
			end)
		) :: PromiseData
	else
		local Results: any? = {CurrentPromise:GetResults()}

		if (Results[1]) then
			return (Promise.Rejected(unpack(Results, 2))) :: PromiseData
		else
			return (Promise.Resolved(unpack(Results, 2))) :: PromiseData
		end
	end
end

--[=[
	Creates a promise from a signal.

	@param Signal Signal<T>

	@return Promise<T>
]=]
function PromiseUtilities.FromSignal(Signal: RBXScriptConnection): PromiseData
	local CurrentPromise: PromiseData = Promise.New()
	local Connection: RBXScriptConnection

	CurrentPromise:Finally(function(): any?
		Connection:Disconnect()
		Connection = nil
	end)

	Connection = Signal:Connect(function(...: any?): RBXScriptConnection
		CurrentPromise:Resolve(...)
	end)

	return (CurrentPromise) :: PromiseData
end

--[=[
	Creates a new promise from the given promise that will reject after the given `TimeoutTime`.

	@param TimeoutTime number -- In seconds.

	@param FromPromise Promise<T>

	@return Promise<T>
]=]
function PromiseUtilities.Timeout(TimeoutTime, FromPromise: PromiseData): PromiseData?
	assert(((type(TimeoutTime)) == ("number")), "Bad TimeoutTime!")
	assert(FromPromise, "Bad FromPromise!")

	if (not (FromPromise:IsPending())) then
		return (FromPromise) :: PromiseData
	end

	local CurrentPromise: PromiseData = Promise.New()
	CurrentPromise:Resolve(FromPromise)

	task.delay(TimeoutTime, function(): any?
		CurrentPromise:Reject()
	end)

	return (CurrentPromise) :: PromiseData
end

--// Pascal patches
PromiseUtilities.any = PromiseUtilities.Any

PromiseUtilities.all = PromiseUtilities.All

PromiseUtilities.invert = PromiseUtilities.Invert

PromiseUtilities.fromSignal = PromiseUtilities.FromSignal

PromiseUtilities.timeout = PromiseUtilities.Timeout

return (PromiseUtilities)