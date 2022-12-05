--// String
--// Written by Demo (R0BL0XIAN_D3M0)
--// [https://www.roblox.com/users/289025524/profile]
--// 10/27/2022

--// Types
type table = {[any]: any}
type StringFunction = (string) -> (... any?)

type StringBuilder = {

	Append: StringFunction;
	Prepend: StringFunction;
	ToString: table

}

--[=[
	@class String

	A vast collection of very useful string-related functions (adjusted for the Facilitator framework).
	Many of these functions were ported over from JavaScript or Python that are not currently
		present in Lua.

	Some of the functions were ported from the following source:
	https://quenty.github.io/NevermoreEngine/api/String

	Strings that only work specifically with arrays or dictionaries are marked as such
		in the documentation.

	:::info Immutability
	All functions (_except_ `SwapRemove`, `SwapRemoveFirstValue`, and `Lock`)
		treat tables as immutable and will return copies of the given table(s)
			with the operations performed on the copies.
]=]
local String: table = {}

--// Variables
local MaximumTuple: number = 7997

--// Functions

--[=[
	@within String

	@param TargetString string -- The specified target string.

	@param Uppercase boolean -- Should we convert the string to an uppercased form?

	@return string -- Return the string.

	Return the specified target string in either upper or lower cased.
]=]
local function UseUppercase(TargetString: string, Uppercase: boolean): string
	return ((Uppercase) and (string.upper(TargetString)) or (string.lower(TargetString))) :: string
end

--[=[
	@within String

	@param TargetString string -- The specified target string.

	@return string -- Return the string.

	Escape the specified target string from pattern characters.
		In other words, it prefixes any special pattern characters with a `%`.
]=]
local function Escape(TargetString: string): string
	return (string.gsub(TargetString, "([%.%$%^%(%)%[%]%+%-%*%?%%])", "%%%1")) :: string
end

--[=[
	@within String

	@param TargetString string -- The specified target string.

	@return string -- Return the string.

	Trim the whitespace from the start and end of the specified target string.
]=]
local function Trim(TargetString: string): string
	return (string.match(TargetString, "^%s*(.-)%s*$")) :: string
end

--[=[
	@within String

	@param TargetString string -- The specified target string.

	@return string -- Return the string.

	Similar to `Trim()`, with the difference being that only the start of the string is trimmed.
]=]
local function TrimStart(TargetString: string): string
	return (string.match(TargetString, "^%s*(.+)")) :: string
end

--[=[
	@within String

	@param TargetString string -- The specified target string.

	@return string -- Return the string.

	Similar to `Trim()`, with the difference being that only the end of the string is trimmed.
]=]
local function TrimEnd(TargetString: string): string
	return (string.match(TargetString, "(.-)%s*$")) :: string
end

--[=[
	@within String

	@param TargetString string -- The specified target string.

	@return string -- Return the string.

	Replace all whitespace with a single space from the specified target string,
		(this does not trim the string).
]=]
local function RemoveExcessWhitespace(TargetString: string): string
	return (string.gsub(TargetString, "%s+", " ")) :: string
end

--[=[
	@within String

	@param TargetString string -- The specified target string.

	@return string -- Return the string.

	Remove all whitespace from the specified target string.
]=]
local function RemoveWhitespace(TargetString: string): string
	return (string.gsub(TargetString, "%s+", "")) :: string
end

--[=[
	@within String

	@param TargetString string -- The specified target string.

	@param EndingString string -- The ending string.

	@return string -- Return the string.

	Check if the specified target string ends with a certain string.
]=]
local function EndsWith(TargetString: string, EndingString: string): string
	return ((string.match(TargetString, (Escape(EndingString)) .. ("$"))) ~= (nil)) :: string
end

--[=[
	@within String

	@param TargetString string -- The specified target string.

	@param StartingString string -- The starting string.

	@return string -- Return the string.

	Check if the specified target string starts with a certain string.
]=]
local function StartsWith(TargetString: string, StartingString: string): string
	return ((string.match(TargetString, ("^") .. (String.Escape(StartingString)))) ~= (nil)) :: string
end

--[=[
	@within String

	@param TargetString string -- The specified target string.

	@param ContainedString string -- The contained string.

	@return string -- Return the string.

	Check if the specified target string contains another string.
]=]
local function Contains(TargetString: string, ContainedString: string): string
	return ((string.find(TargetString, ContainedString)) ~= (nil)) :: string
end

--[=[
	@within String

	@return StringBuilder -- Return the newly created metatable (string builder).

	Create a `StringBuilder` object that can be used to build a string.
		This is useful when a large string needs to be concatenated.
			Traditional concatenation of a string using ".." can be a performance issue,
				and thus `StringBuilders` can be used to store the pieces of the string in a table and
					then concatenate them all at once.
]=]
local function StringBuilder(): StringBuilder
	local StringTable: table = {}
	local Strings: table = {}

	function StringTable:Append(TargetString: string): any?
		Strings[#Strings + 1] = TargetString
	end

	function StringTable:Prepend(TargetString: string): any?
		table.insert(Strings, 1, TargetString)
	end

	function StringTable:ToString(): string
		return (table.concat(Strings, "")) :: string
	end

	setmetatable(StringTable, {

		__tostring = StringTable.ToString

	})

	return (StringTable) :: StringBuilder
end

--[=[
	@within String

	@param TargetString string -- The specified target string.

	@return table -- Return the character array.

	Return a table of all the characters in the specified target string.
]=]
local function ToCharacterArray(TargetString: string): table
	local Length: number = string.len(TargetString)
	local CharacterCache: table = table.create(Length)

	for Index = 1, Length do
		CharacterCache[Index] = string.sub(TargetString, Index, Index)
	end

	return (CharacterCache) :: table
end

--[=[
	@within String

	@param TargetString string -- The specified target string.

	@return table -- Return the byte array.

	Return a table of all the bytes of each character in the specified target string.
]=]
local function ToByteArray(TargetString: string): table
	local Length: number = string.len(TargetString)

	if ((Length) == (0)) then
		return ({}) :: table
	end

	if ((Length) <= (MaximumTuple)) then
		return (table.pack(string.byte(TargetString, Length, 1))) :: table
	end

	local ByteCache: table = table.create(Length)

	for Index = 1, Length do
		ByteCache[Index] = string.byte(string.sub(TargetString, Index, Index))
	end

	return (ByteCache) :: table
end

--[=[
	@within String

	@param ByteCache table -- The specified byte array.

	@return string -- Return the string.

	Transform the array of bytes into a string.
]=]
local function ByteArrayToString(ByteCache: table): string
	local Size: number = #ByteCache

	if ((Size) <= (MaximumTuple)) then
		return (string.char(table.unpack(ByteCache))) :: string
	end

	local NumberChunks: number = math.ceil((Size) / (MaximumTuple))
	local StringBuild: table = table.create(NumberChunks)

	for Index = 1, NumberChunks do
		local Chunk: string = string.char(table.unpack(ByteCache, ((((Index) - (1)) * (MaximumTuple)) +
			(1)), math.min(Size, (((Index) - (1)) * (MaximumTuple)) + (MaximumTuple))))

		StringBuild[Index] = Chunk
	end

	return (table.concat(StringBuild, "")) :: string
end

--[=[
	@within String

	@param StringA string -- The primary string.

	@param StringB string -- The secondary string.

	@return string -- Return the string.

	Check if two strings are equal, while ignoring their case.
]=]
local function EqualsIgnoreCase(StringA: string, StringB: string): boolean
	return ((string.lower(StringA)) == (string.lower(StringB))) :: string
end

--[=[
	@within String

	@param TargetString string -- The specified target string.

	@return string -- Return the string.

	Return the specified target string in `camelCase`.
]=]
local function ToCamelCase(TargetString: string): string
	TargetString = string.gsub(TargetString, "[%-_]+([^%-_])", function(NewString)
		return (string.upper(NewString)) :: string
	end)

	return ((string.lower(string.sub(TargetString, 1, 1))) .. (string.sub(TargetString, 2))) :: string
end

--[=[
	@within String

	@param TargetString string -- The specified target string.

	@return string -- Return the string.

	Return the specified target string in `PascalCase`.
]=]
local function ToPascalCase(TargetString: string): string
	TargetString = ToCamelCase(TargetString)

	return ((string.upper(string.sub(TargetString, 1, 1))) .. (string.sub(TargetString, 2))) :: string
end

--[=[
	@within String

	@param TargetString string -- The specified target string.

	@return string -- Return the string.

	Return the specified target string in `snake_case` or `SNAKE_CASE`.
]=]
local function ToSnakeCase(TargetString: string, Uppercase: boolean): string
	TargetString = string.gsub(string.gsub(TargetString, "[%-_]+", "_"), "([^%u%-_])(%u)",
		function(StringA: string, StringB: string)

		return ((StringA) .. ("_") .. (string.lower(StringB))) :: string
	end)

	TargetString = UseUppercase(TargetString, Uppercase)

	return (TargetString) :: string
end

--[=[
	@within String

	@param TargetString string -- The specified target string.

	@return string -- Return the string.

	Return the specified target string in `kebab-case` or `KEBAB-CASE`.
]=]
local function ToKebabCase(TargetString: string, Uppercase: boolean): string
	TargetString = string.gsub(string.gsub(TargetString, "[%-_]+", "-"), "([^%u%-_])(%u)",
		function(StringA: string, StringB: string)

		return ((StringA) .. ("-") .. (string.lower(StringB))) :: string
	end)

	TargetString = UseUppercase(TargetString, Uppercase)

	return (TargetString) :: string
end

setmetatable(String, {

	__index = string

})

--// Pascal patches
String.escape = Escape
String.Escape = Escape

String.trim = Trim
String.Trim = Trim

String.trimStart = TrimStart
String.TrimStart = TrimStart

String.trimEnd = TrimEnd
String.TrimEnd = TrimEnd

String.removeExcessWhitespace = RemoveExcessWhitespace
String.RemoveExcessWhitespace = RemoveExcessWhitespace

String.removeWhitespace = RemoveWhitespace
String.RemoveWhitespace = RemoveWhitespace

String.endsWith = EndsWith
String.EndsWith = EndsWith

String.startsWith = StartsWith
String.StartsWith = StartsWith

String.contains = Contains
String.Contains = Contains

String.stringBuilder = StringBuilder
String.StringBuilder = StringBuilder

String.toCharArray = ToCharacterArray
String.ToCharArray = ToCharacterArray
String.toCharacterArray = ToCharacterArray
String.ToCharacterArray = ToCharacterArray

String.toByteArray = ToByteArray
String.ToByteArray = ToByteArray

String.byteArrayToString = ByteArrayToString
String.ByteArrayToString = ByteArrayToString

String.equalsIgnoreCase = EqualsIgnoreCase
String.EqualsIgnoreCase = EqualsIgnoreCase

String.toPascalCase = ToPascalCase
String.ToPascalCase = ToPascalCase

String.toSnakeCase = ToSnakeCase
String.ToSnakeCase = ToSnakeCase

String.toKebabCase = ToKebabCase
String.ToKebabCase = ToKebabCase

return (String)