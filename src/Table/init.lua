--// Table
--// Written by Demo (R0BL0XIAN_D3M0)
--// [https://www.roblox.com/users/289025524/profile]
--// 11/29/2022

--// Types
type table = {[any]: any}
type Function = (... any?) -> (... any?)
type DecodedString = table | any?
type Key = number | any?

--[=[
	@class Table

	A vast collection of very useful table-related functions (adjusted for the Facilitator framework).
	Many of these functions were ported over from JavaScript or Python that are not present in Lua.

	Some of the functions were ported from these following sources:
	https://quenty.github.io/NevermoreEngine/api/Table
	https://sleitnick.github.io/RbxUtil/api/TableUtil

	Tables that only work specifically with arrays or dictionaries are marked as such
		in the documentation.

	:::info Immutability
	All functions (_except_ `SwapRemove`, `SwapRemoveFirstValue`, and `Lock`)
		treat tables as immutable and will return clones of the specified table(s)
			with the operations performed on the clones.
]=]
local Table: table = {}

--// Services
local HttpService: HttpService = game:GetService("HttpService")

--// Variables
local DefaultIndentationPower: number = 0

--// Functions

--[=[
	@within Table

	@param TargetTable table -- The target table.

	@param ShouldDeepRead boolean? -- Whether or not to perform a recursive read.

	@return table -- Return the read-only table.

	Assigns a readonly property to a table that'd error when a nil value is indexed,
		using `table.freeze`, disallowing further modfications to the specified table.
	By default, a shallow read will be performed.
	For deep reads, a second boolean argument must be passed to the function.

	Assign a readonly property to a table that'd error when a nil value is indexed:

	```lua
		local Data: table = {

			["Kills"] = 5;
			["Death"] = 2;
			["Experience"] = 150

		}

		Data["Level"] = 2 --> Works without a problem.

		print(Data["Level"])

		Data = Table.ReadOnly(Data)
		Data["Level"] = 5 --> Will result in an error (cannot modify readonly table).
	```

	Recurvisely assign a readonly property to a table that'd error when a nil value is indexed:

	```lua
		local Data: table = {

			["Statistics"] = {

				["Kills"] = 5;
				["Death"] = 2;

			};

			["Level"] = {

				["Level"] = 5
				["Experience"] = 150

			}

		}

		Data["Statistics"]["Captures"] = 2 --> Works without a problem.
		Data["Level"]["XP"] = 2 --> Works without a problem.

		print(Data["Statistics"]["Captures"])
		print(Data["Level"]["XP"])

		Data = Table.ReadOnly(Data, true)
		Data["Statistics"]["Captures"] = 5 --> Will result in an error (cannot modify readonly table).
		Data["Level"]["XP"] = 5 --> Will result in an error (cannot modify readonly table).
	```
]=]
local function ReadOnly(TargetTable: table, ShouldDeepRead: boolean?): table
	if (not (ShouldDeepRead)) then
		return (table.freeze(TargetTable)) :: table
	end

	local function DeepRead(ContextTable: table)
		for Key: Key, Value: any in pairs(ContextTable) do
			Key[Value] = ((type(Value)) == ("table") and (DeepRead(Value)))
		end

		return (ReadOnly(ContextTable)) :: table
	end

	return (DeepRead(TargetTable)) :: table
end

--[=[
	@within Table

	@param TargetTable table -- The target table.

	@param ContextTable table -- The context table.

	@return table -- Return the newly concatted target table.

	Concat the specified target table's entries with the context table.
]=]
local function Append(TargetTable: table, ContextTable: table): table
	for _: Key, Value: any in pairs(ContextTable) do
		TargetTable[#TargetTable + 1] = Value
	end

	return (TargetTable) :: table
end

--[=[
	@within Table

	@param OriginalTable table -- The original table.

	@param SecondaryTable table -- The secondary table.

	@return table -- Return the newly created and merged table.

	Merge the specified original table's entries with the secondary tables'.
]=]
local function Merge(OriginalTable: table, SecondaryTable: table): table
	local TemporaryTable: table = {}

	for Key: any, Value: any in pairs(OriginalTable) do
		TemporaryTable[Key] = Value
	end

	for Key: any, Value: any in pairs(SecondaryTable) do
		TemporaryTable[Key] = Value
	end

	return (TemporaryTable) :: table
end

--[=[
	@within Table

	@param OriginalTable table -- The original table.

	@param SecondaryTable table -- The secondary table.

	@return table -- Return the newly created and merged table.

	Merge the specified original table's entries with the secondary tables' in a list.
]=]
local function MergeLists(OriginalTable: table, SecondaryTable: table): table
	local TemporaryTable: table = {}

	for _: Key, Value: any in pairs(OriginalTable) do
		table.insert(TemporaryTable, Value)
	end

	for _: Key, Value: any in pairs(SecondaryTable) do
		table.insert(TemporaryTable, Value)
	end

	return (TemporaryTable) :: table
end

--[=[
	@within Table

	@param TargetTable table -- The target table.

	@return table -- Return the newly created table with all associated entry values.

	Return a list of all entries' values from within the specified target table.
]=]
local function RetrieveValues(TargetTable: table): table
	local TemporaryTable: table = {}

	for _: Key, Value: any in pairs(TargetTable) do
		table.insert(TemporaryTable, Value)
	end

	return (TemporaryTable) :: table
end

--[=[
	@within Table

	@param TargetTable table -- The target table.

	@return table -- Return the newly created table with all associated key values.

	Replace the specified target table's entries with their respective values.
]=]
local function SwapKeyValue(TargetTable: table): table
	local TemporaryTable: table = {}

	for Key: Key, Value: any in pairs(TargetTable) do
		TemporaryTable[Value] = Key
	end

	return (TemporaryTable) :: table
end

--[=[
	@within Table

	@param TargetTable table -- The target table.

	@return table -- Return the newly created list.

	Convert the specified target table's entries to a list.
]=]
local function ToList(TargetTable: table): table?
	local TemporaryTable: table = {}

	for _: Key, Value: any in pairs(TargetTable) do
		table.insert(TemporaryTable, Value)
	end

	return (TemporaryTable) :: table
end

--[=[
	@within Table

	@param TargetTable table -- The target table.

	@param Indent number? -- The indentation power.

	@param Output string? -- The output.

	@return string -- Return the output.

	Recurvisely return every table entry from the specified target table as a string.
]=]
local function Stringify(TargetTable: table, Indent: number?, Output: string?): string
	Output = ((Output) or (tostring(TargetTable)))
	Indent = ((Indent) or (DefaultIndentationPower))

	for Key: Key, Value: any in pairs(TargetTable) do
		local FormattedString = (("\n") .. (string.rep("  ", Indent)) .. (tostring(Key)) .. (": "))

		if ((type(Value)) == ("table")) then
			Output = ((Output) .. (FormattedString))
			Output = Stringify(Value, Indent + 1, Output)
		else
			Output = ((Output) .. (FormattedString) .. (tostring(Value)))
		end
	end

	return (Output) :: string
end

--[=[
	@within Table

	@param TargetTable table -- The target table to clone.

	@param ShouldDeepClone boolean? -- Whether or not to perform a deep clone.

	@return table -- Return the newly cloned table.

	Creates a clone of the given table.
	By default, a shallow clone will be performed.
	For deep clones, a second boolean argument must be passed to the function.

	:::caution No cyclical references
	Deep clones are _not_ protected against cyclical references.

	Passing a table with cyclical references _and_ the `ShouldDeepClone` parameter set to
		`true` will result in a stack-overflow!
]=]
local function Clone(TargetTable: table, ShouldDeepClone: boolean?): table
	if (not (TargetTable) or (type(TargetTable) ~= ("table"))) then
		return ({})
	end

	if (not (ShouldDeepClone)) then
		return (table.clone(TargetTable)) :: table
	end

	local function DeepClone(ContextTable: table): table
		local TemporaryTable: table = table.clone(ContextTable)

		for Key: Key, Value: any in pairs(TemporaryTable) do
			TemporaryTable[Key] = ((type(Value)) == ("table") and (DeepClone(Value)))
		end

		return (TemporaryTable) :: table
	end

	return (DeepClone(TargetTable)) :: table
end

--[=[
	@within Table

	@param TargetTable table -- The target table.

	@param ContextTable table -- The context table.

	@param ShouldDeepOverwrite boolean? -- Whether or not to perform a deep overwrite.

	@return table -- Return the newly overwritten table.

	Overwrite entries within the specified table with the respective entry from the context table.

	:::caution No cyclical references
	Deep overwrites are _not_ protected against cyclical references.

	Passing a table with cyclical references _and_ the `ShouldDeepOverwrite` parameter set to
		`true` will result in a stack-overflow!
]=]
local function Overwrite(TargetTable: table, ContextTable: table, ShouldDeepOverwrite: boolean?): table
	if (not (TargetTable) or (type(TargetTable) ~= ("table"))) then
		return ({})
	end

	if (not (ShouldDeepOverwrite)) then
		for Index: Key, Value: any in pairs(ContextTable) do
			TargetTable[Index] = Value
		end

		return (TargetTable) :: table
	end

	local function DeepOverwrite(DeepTargetTable: table, DeepContextTable: table): table
		for Key: Key, Value: any in pairs(DeepContextTable) do
			DeepTargetTable[Key] = (((type(DeepTargetTable[Key])) == ("table"))
				and (((type(Value)) == ("table"))
				and (DeepOverwrite(DeepTargetTable[Key], Value))) or (Value))
		end

		return (TargetTable) :: table
	end

	return (DeepOverwrite(TargetTable, ContextTable)) :: table
end

--[=[
	@within Table

	@param TargetTable table -- The target table.

	@param ContextTable table -- The context table.

	@return table -- Return the newly overwritten table.

	Synchronize every entry within the specified table with the respective entry from the context table.
]=]
local function Synchronize(TargetTable: table, ContextTable: table): table
	for Key: Key, Value: any in pairs(TargetTable) do
		local ContextTemplate: any? = ContextTable[Key]

		if ((ContextTemplate) == (nil)) then
			TargetTable[Key] = nil
		elseif ((type(Value)) ~= (type(ContextTemplate))) then
			TargetTable[Key] = ((type(ContextTemplate) == ("table"))
				and (Clone(ContextTemplate)) or (ContextTemplate))
		elseif ((type(Value)) == ("table")) then
			Synchronize(Value, ContextTemplate)
		end
	end

	for Key: Key, ContextTemplate: any? in pairs(ContextTable) do
		local Value: any? = TargetTable[Key]

		if ((Value) == (nil)) then
			TargetTable[Key] = (((type(ContextTemplate)) == ("table"))
				and (Clone(ContextTemplate)) or (ContextTemplate))
		end
	end

	return (TargetTable) :: table
end

--[=[
	@within Table

	@param TargetTable table -- The target table.

	@param ContextTable table -- The context table.

	@return table -- Return the newly reconciled table.

	Unlike the overwrite method, this one simply replaces strings (used primarily for `ProfileService`).
]=]
local function Reconcile(TargetTable: table, ContextTable: table): table
	for Key: Key, Value: any in pairs(ContextTable) do
		if ((type(Key)) == ("string")) then -- Only string keys will be reconciled.
			if (not (TargetTable[Key])) then
				TargetTable[Key] = (((type(Value)) == ("table"))
					and (Clone(Value)) or (Value))
			elseif ((type(TargetTable[Key]) == ("table")) and ((type(Value)) == ("table"))) then
				Reconcile(TargetTable[Key], Value)
			end
		end
	end

	return (TargetTable) :: table
end

--[=[
	@within Table

	@param TargetTable table -- The target table.

	@param TargetValue any? -- The target value.

	@return Key -- Return the specified target value from within the target table.

	Find a value within the specified target table that is identical to the specified target value
		and return its index within the specified target table if found.
]=]
local function FindIndex(TargetTable: table, TargetValue: any?): Key
	local Found: any = table.find(TargetTable, TargetValue)

	return ((Found) or (nil)) :: Key
end

--[=[
	@within Table

	@param TargetTable table -- The target table.

	@param TargetValue any? -- The target value.

	@return boolean -- Return whether or not the specified value was found, given the target table.

	Find a value within the specified target table that is identical to the specified target value
		and return whether or not it has been found and within the specified target table.
]=]
local function FindBoolean(TargetTable: table, TargetValue: any?): boolean
	local Found: any = table.find(TargetTable, TargetValue)

	return ((Found) ~= (nil)) :: boolean
end

--[=[
	@within Table

	@param TargetTable table -- The target table.

	@return boolean -- Return whether or not the target table is empty.

	Return whether or not the specified target table is empty.
]=]
local function IsEmpty(TargetTable: table): boolean
	return ((next(TargetTable)) == (nil)) :: boolean
end

--[=[
	@within Table

	@param TargetTable table -- The target table.
	@param ShouldDeepCount boolean? -- Should we count all entries from every table?

	@return number -- Return the count of all specified target table's entries.

	Count the specified target table's entries and return the count.
]=]
local function Count(TargetTable: table, ShouldDeepCount: boolean?): number
	if (not (TargetTable) or (type(TargetTable) ~= ("table"))) then
		return ({})
	end

	local EntryCount: number = 0

	if (not (ShouldDeepCount)) then
		for _: Key, _: any in pairs(TargetTable) do
			EntryCount += 1
		end

		return (EntryCount) :: number
	end

	local function DeepCount(ContextTable: table): table
		for _: Key, Value: any in pairs(ContextTable) do
			EntryCount += 1

			if ((type(Value)) == ("table")) then
				DeepCount(Value)
			end
		end

		return (DeepCount(ContextTable)) :: table
	end

	return (DeepCount(TargetTable)) :: number
end

--[=[
	@within Table

	@param TargetTable table -- The target table.

	@param ... table -- The specified context tables.

	@return table -- Return the altered target table.

	Return an assigned variant of the specified target table using the specified context tables.
]=]
local function Assign(TargetTable: table, ...: table): table
	for _: number, ContextTable: table in ipairs({
		...
	}) do
		for Key: Key, Value: any in pairs(ContextTable) do
			TargetTable[Key] = Value
		end
	end

	return (TargetTable) :: table
end

--[=[
	@within Table

	@param TargetTable table -- The target table.

	@param Function Function -- The specified function.

	@return table -- Return the altered target table.

	Return a mapped variant of the specified target table using the specified function.
]=]
local function Map(TargetTable: table, Function: Function): table
	local TemporaryTable: table = table.create(#TargetTable)

	for Key: Key, Value: any in pairs(TargetTable) do
		TemporaryTable = Function(Value, Key, TargetTable)
	end

	return (TemporaryTable) :: table
end

--[=[
	@within Table

	@param TargetTable table -- The target table.

	@param Function Function -- The specified function.

	@return number -- Return the reduced result.

	Return a reduced number variant of the specified target table using the specified function.
]=]
local function Reduce(TargetTable: table, Function: Function): number
	local Result: number = 0

	for Key: Key, Value: any in pairs(TargetTable) do
		Result = Function(Result, Value, Key, TargetTable)
	end

	return (Result) :: number
end

--[=[
	@within Table

	@param TargetTable table -- The target table.

	@return table -- Return the newly reversed table.

	Return a reversed variant of the specified target table.
]=]
local function Reverse(TargetTable: table): table
	local EntryCount: number = Count(TargetTable)
	local TemporaryTable: table = table.create(EntryCount)

	for Index = 1, EntryCount do
		TemporaryTable[Index] = TargetTable[(EntryCount) - (Index) + (1)]
	end

	return (TemporaryTable) :: table
end

--[=[
	@within Table

	@param TargetTable table -- The target table.

	@return table -- Return the newly randomized table.

	Return a randomized variant of the specified target table.
]=]
local function Randomize(TargetTable: table): table
	local EntryCount: number = Count(TargetTable)
	local RandomSeed: Random = Random.new()
	local TemporaryTable: table = table.create(EntryCount)

	for Index = EntryCount, 2, -1 do
		local NextInteger = RandomSeed:NextInteger(1, Index)

		TemporaryTable[Index] = TargetTable[NextInteger]
		TemporaryTable[NextInteger] = TargetTable[Index]
	end

	return (TemporaryTable) :: table
end

--[=[
	@within Table

	@param TargetTable table -- The target table.

	@param Function Function -- The specified function.

	@return table -- Return the newly filtered table.

	Return a filtered variant of the specified target table using the specified function.
]=]
local function Filter(TargetTable: table, Function: Function): table
	local EntryCount: number = Count(TargetTable)
	local TemporaryTable: table = table.create(EntryCount)

	if ((EntryCount) > (0)) then
		local Number: number = 0

		for Index = 1, EntryCount do
			local Value: any = TemporaryTable[Index]

			if (Function(Value, Index, TemporaryTable)) then
				Number += 1
				TemporaryTable[Number] = Value
			end
		end
	else
		for Key: Key, Value: any in pairs(TemporaryTable) do
			if (Function(Value, Key, TemporaryTable)) then
				TemporaryTable[Key] = Value
			end
		end
	end

	return (TemporaryTable) :: table
end

--[=[
	@within Table

	@param TargetTable table -- The target table.

	@param TakeCount number -- The specified take counter.

	@return table -- Return the newly altered table.

	Return the `TakeCount` amount [number] of entries from within the specified target table to clone.
]=]
local function Take(TargetTable: table, TakeCount: number): table
	local TemporaryTable: table = {}

	for Index = 1, math.min(#TargetTable, TakeCount) do
		TemporaryTable[Index] = TargetTable[Index]
	end

	return (TemporaryTable) :: table
end

--[=[
	@within Table

	@param TargetTable table -- The target table.

	@param TakeCount number -- The specified take amount.

	Return a random entry from a specified target table.
]=]
local function Random(TargetTable: table, TakeCount: number): table
	return (TargetTable[math.random(TakeCount, #TargetTable)]) :: table
end

--[=[
	@within Table

	@param TargetTable table -- The target table.

	@return string? -- Return the newly created string.

	JSON Encode the specified target table.
]=]
local function JSONEncode(TargetTable: table): string?
	return ((HttpService:JSONEncode(TargetTable)) or (nil)) :: string
end

--[=[
	@within Table

	@param TargetString string -- The target string.

	@return DecodedString -- Return the decoded JSON string as a table or anything.

	JSON Decode the specified target string.
]=]
local function JSONDecode(TargetString: string): DecodedString
	return ((HttpService:JSONDecode(TargetString)) or (nil)) :: DecodedString
end

--[=[
	@within Table

	@param TargetTable table -- The target table.

	@return nil -- Return a merely cleared table, resulting in a nil value.

	Destroy and cleanup all entries within the specified target table.
]=]
local function Destroy(TargetTable: table): nil
	return ((table.clear(TargetTable)) or (nil)) :: nil
end

--// Pascal patches
Table.freeze = ReadOnly
Table.Freeze = ReadOnly
Table.lock = ReadOnly
Table.Lock = ReadOnly
Table.readOnly = ReadOnly
Table.ReadOnly = ReadOnly
Table.deepReadOnly = ReadOnly
Table.DeepReadOnly = ReadOnly

Table.append = Append
Table.Append = Append

Table.combine = Merge
Table.Combine = Merge
Table.merge = Merge
Table.Merge = Merge

Table.combineLists = MergeLists
Table.CombineLists = MergeLists
Table.mergeLists = MergeLists
Table.MergeLists = MergeLists

Table.retrieveValues = RetrieveValues
Table.RetrieveValues = RetrieveValues
Table.values = RetrieveValues
Table.Values = RetrieveValues

Table.swapKeyValue = SwapKeyValue
Table.SwapKeyValue = SwapKeyValue

Table.toList = ToList
Table.ToList = ToList

Table.stringify = Stringify
Table.Stringify = Stringify

Table.clone = Clone
Table.Clone = Clone
Table.copy = Clone
Table.Copy = Clone
Table.deepClone = Clone(..., true)
Table.DeepClone = Clone(..., true)
Table.deepCopy = Clone(..., true)
Table.DeepCopy = Clone(..., true)

Table.overwrite = Overwrite
Table.Overwrite = Overwrite
Table.deepOverwrite = Overwrite(..., true)
Table.DeepOverwrite = Overwrite(..., true)

Table.synchronize = Synchronize
Table.Synchronize = Synchronize

Table.reconcile = Reconcile
Table.Reconcile = Reconcile

Table.findIndex = FindIndex
Table.FindIndex = FindIndex
Table.find = FindIndex
Table.Find = FindIndex
Table.indexOf = FindIndex
Table.IndexOf = FindIndex
Table.returnIndex = FindIndex
Table.ReturnIndex = FindIndex

Table.contains = FindBoolean
Table.Contains = FindBoolean
Table.findBoolean = FindBoolean
Table.FindBoolean = FindBoolean

Table.isEmpty = IsEmpty
Table.IsEmpty = IsEmpty

Table.count = Count
Table.Count = Count
Table.entryCount = Count
Table.EntryCount = Count
Table.deepCount = Count(..., true)
Table.DeepCount = Count(..., true)
Table.deepEntryCount = Count(..., true)
Table.DeepEntryCount = Count(..., true)

Table.assign = Assign
Table.Assign = Assign

Table.map = Map
Table.Map = Map

Table.reduce = Reduce
Table.Reduce = Reduce

Table.reverse = Reverse
Table.Reverse = Reverse

Table.randomize = Randomize
Table.Randomize = Randomize
Table.shuffle = Randomize
Table.Shuffle = Randomize

Table.filter = Filter
Table.Filter = Filter

Table.take = Take
Table.Take = Take

Table.random = Random
Table.Random = Random

Table.jsonEncode = JSONEncode
Table.JSONEncode = JSONEncode

Table.jsonDecode = JSONDecode
Table.JSONDecode = JSONDecode

Table.clear = Destroy
Table.Clear = Destroy
Table.clearAll = Destroy
Table.ClearAll = Destroy
Table.destroy = Destroy
Table.Destroy = Destroy
Table.empty = Destroy
Table.Empty = Destroy

return (Table)